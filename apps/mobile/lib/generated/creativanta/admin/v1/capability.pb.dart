// This is a generated file - do not edit.
//
// Generated from creativanta/admin/v1/capability.proto.

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
    as $2;

import '../../common/v1/types.pb.dart' as $1;
import 'capability.pbenum.dart';

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'capability.pbenum.dart';

/// Policy note explaining why a platform capability is restricted or requires manual fallback.
class PolicyNoteItem extends $pb.GeneratedMessage {
  factory PolicyNoteItem({
    $1.UUID? policyNoteId,
    $core.String? platform,
    $core.String? capabilityKey,
    $core.String? summary,
    $core.String? detail,
    $core.String? sourceUrl,
    $2.Timestamp? updatedAt,
  }) {
    final result = PolicyNoteItem._();
    if (policyNoteId != null) result.policyNoteId = policyNoteId;
    if (platform != null) result.platform = platform;
    if (capabilityKey != null) result.capabilityKey = capabilityKey;
    if (summary != null) result.summary = summary;
    if (detail != null) result.detail = detail;
    if (sourceUrl != null) result.sourceUrl = sourceUrl;
    if (updatedAt != null) result.updatedAt = updatedAt;
    return result;
  }

  PolicyNoteItem._();

  factory PolicyNoteItem.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PolicyNoteItem()..mergeFromBuffer(data, registry);
  factory PolicyNoteItem.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PolicyNoteItem()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PolicyNoteItem',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.admin.v1'),
      createEmptyInstance: PolicyNoteItem.$_createMessage)
    ..aOM<$1.UUID>(1, _omitFieldNames ? '' : 'policyNoteId',
        subBuilder: $1.UUID.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'platform')
    ..aOS(3, _omitFieldNames ? '' : 'capabilityKey')
    ..aOS(4, _omitFieldNames ? '' : 'summary')
    ..aOS(5, _omitFieldNames ? '' : 'detail')
    ..aOS(6, _omitFieldNames ? '' : 'sourceUrl')
    ..aOM<$2.Timestamp>(7, _omitFieldNames ? '' : 'updatedAt',
        subBuilder: $2.Timestamp.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PolicyNoteItem clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PolicyNoteItem copyWith(void Function(PolicyNoteItem) updates) =>
      super.copyWith((message) => updates(message as PolicyNoteItem))
          as PolicyNoteItem;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use PolicyNoteItem() / PolicyNoteItem.new instead')
  static PolicyNoteItem create() => PolicyNoteItem._();
  static $pb.GeneratedMessage $_createMessage() => PolicyNoteItem._();
  @$core.override
  PolicyNoteItem createEmptyInstance() => PolicyNoteItem._();
  @$core.pragma('dart2js:noInline')
  static PolicyNoteItem getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PolicyNoteItem>(
          PolicyNoteItem.$_createMessage);
  static PolicyNoteItem? _defaultInstance;

  @$pb.TagNumber(1)
  $1.UUID get policyNoteId => $_getN(0);
  @$pb.TagNumber(1)
  set policyNoteId($1.UUID value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasPolicyNoteId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPolicyNoteId() => $_clearField(1);
  @$pb.TagNumber(1)
  $1.UUID ensurePolicyNoteId() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get platform => $_getSZ(1);
  @$pb.TagNumber(2)
  set platform($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPlatform() => $_has(1);
  @$pb.TagNumber(2)
  void clearPlatform() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get capabilityKey => $_getSZ(2);
  @$pb.TagNumber(3)
  set capabilityKey($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasCapabilityKey() => $_has(2);
  @$pb.TagNumber(3)
  void clearCapabilityKey() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get summary => $_getSZ(3);
  @$pb.TagNumber(4)
  set summary($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasSummary() => $_has(3);
  @$pb.TagNumber(4)
  void clearSummary() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get detail => $_getSZ(4);
  @$pb.TagNumber(5)
  set detail($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasDetail() => $_has(4);
  @$pb.TagNumber(5)
  void clearDetail() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get sourceUrl => $_getSZ(5);
  @$pb.TagNumber(6)
  set sourceUrl($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasSourceUrl() => $_has(5);
  @$pb.TagNumber(6)
  void clearSourceUrl() => $_clearField(6);

  @$pb.TagNumber(7)
  $2.Timestamp get updatedAt => $_getN(6);
  @$pb.TagNumber(7)
  set updatedAt($2.Timestamp value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasUpdatedAt() => $_has(6);
  @$pb.TagNumber(7)
  void clearUpdatedAt() => $_clearField(7);
  @$pb.TagNumber(7)
  $2.Timestamp ensureUpdatedAt() => $_ensure(6);
}

/// Guided fallback path for non-native capabilities (RULE-M22-001, RULE-M22-004).
class FallbackPathItem extends $pb.GeneratedMessage {
  factory FallbackPathItem({
    $1.UUID? fallbackPathId,
    $core.String? platform,
    $core.String? capabilityKey,
    FallbackType? fallbackType,
    $core.String? instructions,
    $core.String? estimatedEffort,
    $1.UUID? relatedPolicyNoteId,
  }) {
    final result = FallbackPathItem._();
    if (fallbackPathId != null) result.fallbackPathId = fallbackPathId;
    if (platform != null) result.platform = platform;
    if (capabilityKey != null) result.capabilityKey = capabilityKey;
    if (fallbackType != null) result.fallbackType = fallbackType;
    if (instructions != null) result.instructions = instructions;
    if (estimatedEffort != null) result.estimatedEffort = estimatedEffort;
    if (relatedPolicyNoteId != null)
      result.relatedPolicyNoteId = relatedPolicyNoteId;
    return result;
  }

  FallbackPathItem._();

  factory FallbackPathItem.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      FallbackPathItem()..mergeFromBuffer(data, registry);
  factory FallbackPathItem.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      FallbackPathItem()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'FallbackPathItem',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.admin.v1'),
      createEmptyInstance: FallbackPathItem.$_createMessage)
    ..aOM<$1.UUID>(1, _omitFieldNames ? '' : 'fallbackPathId',
        subBuilder: $1.UUID.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'platform')
    ..aOS(3, _omitFieldNames ? '' : 'capabilityKey')
    ..aE<FallbackType>(4, _omitFieldNames ? '' : 'fallbackType',
        enumValues: FallbackType.values)
    ..aOS(5, _omitFieldNames ? '' : 'instructions')
    ..aOS(6, _omitFieldNames ? '' : 'estimatedEffort')
    ..aOM<$1.UUID>(7, _omitFieldNames ? '' : 'relatedPolicyNoteId',
        subBuilder: $1.UUID.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FallbackPathItem clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FallbackPathItem copyWith(void Function(FallbackPathItem) updates) =>
      super.copyWith((message) => updates(message as FallbackPathItem))
          as FallbackPathItem;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use FallbackPathItem() / FallbackPathItem.new instead')
  static FallbackPathItem create() => FallbackPathItem._();
  static $pb.GeneratedMessage $_createMessage() => FallbackPathItem._();
  @$core.override
  FallbackPathItem createEmptyInstance() => FallbackPathItem._();
  @$core.pragma('dart2js:noInline')
  static FallbackPathItem getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<FallbackPathItem>(
          FallbackPathItem.$_createMessage);
  static FallbackPathItem? _defaultInstance;

  @$pb.TagNumber(1)
  $1.UUID get fallbackPathId => $_getN(0);
  @$pb.TagNumber(1)
  set fallbackPathId($1.UUID value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasFallbackPathId() => $_has(0);
  @$pb.TagNumber(1)
  void clearFallbackPathId() => $_clearField(1);
  @$pb.TagNumber(1)
  $1.UUID ensureFallbackPathId() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get platform => $_getSZ(1);
  @$pb.TagNumber(2)
  set platform($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPlatform() => $_has(1);
  @$pb.TagNumber(2)
  void clearPlatform() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get capabilityKey => $_getSZ(2);
  @$pb.TagNumber(3)
  set capabilityKey($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasCapabilityKey() => $_has(2);
  @$pb.TagNumber(3)
  void clearCapabilityKey() => $_clearField(3);

  @$pb.TagNumber(4)
  FallbackType get fallbackType => $_getN(3);
  @$pb.TagNumber(4)
  set fallbackType(FallbackType value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasFallbackType() => $_has(3);
  @$pb.TagNumber(4)
  void clearFallbackType() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get instructions => $_getSZ(4);
  @$pb.TagNumber(5)
  set instructions($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasInstructions() => $_has(4);
  @$pb.TagNumber(5)
  void clearInstructions() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get estimatedEffort => $_getSZ(5);
  @$pb.TagNumber(6)
  set estimatedEffort($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasEstimatedEffort() => $_has(5);
  @$pb.TagNumber(6)
  void clearEstimatedEffort() => $_clearField(6);

  @$pb.TagNumber(7)
  $1.UUID get relatedPolicyNoteId => $_getN(6);
  @$pb.TagNumber(7)
  set relatedPolicyNoteId($1.UUID value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasRelatedPolicyNoteId() => $_has(6);
  @$pb.TagNumber(7)
  void clearRelatedPolicyNoteId() => $_clearField(7);
  @$pb.TagNumber(7)
  $1.UUID ensureRelatedPolicyNoteId() => $_ensure(6);
}

/// Single cell in the workspace capability matrix.
class CapabilityMatrixCell extends $pb.GeneratedMessage {
  factory CapabilityMatrixCell({
    $core.String? platform,
    $core.String? capabilityKey,
    $core.String? displayName,
    CapabilityState? state,
    $core.bool? verificationFresh,
    $core.bool? executable,
    $core.String? reason,
    PolicyNoteItem? policyNote,
    FallbackPathItem? fallbackPath,
    $2.Timestamp? checkedAt,
    $2.Timestamp? validUntil,
  }) {
    final result = CapabilityMatrixCell._();
    if (platform != null) result.platform = platform;
    if (capabilityKey != null) result.capabilityKey = capabilityKey;
    if (displayName != null) result.displayName = displayName;
    if (state != null) result.state = state;
    if (verificationFresh != null) result.verificationFresh = verificationFresh;
    if (executable != null) result.executable = executable;
    if (reason != null) result.reason = reason;
    if (policyNote != null) result.policyNote = policyNote;
    if (fallbackPath != null) result.fallbackPath = fallbackPath;
    if (checkedAt != null) result.checkedAt = checkedAt;
    if (validUntil != null) result.validUntil = validUntil;
    return result;
  }

  CapabilityMatrixCell._();

  factory CapabilityMatrixCell.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CapabilityMatrixCell()..mergeFromBuffer(data, registry);
  factory CapabilityMatrixCell.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CapabilityMatrixCell()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CapabilityMatrixCell',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.admin.v1'),
      createEmptyInstance: CapabilityMatrixCell.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'platform')
    ..aOS(2, _omitFieldNames ? '' : 'capabilityKey')
    ..aOS(3, _omitFieldNames ? '' : 'displayName')
    ..aE<CapabilityState>(4, _omitFieldNames ? '' : 'state',
        enumValues: CapabilityState.values)
    ..aOB(5, _omitFieldNames ? '' : 'verificationFresh')
    ..aOB(6, _omitFieldNames ? '' : 'executable')
    ..aOS(7, _omitFieldNames ? '' : 'reason')
    ..aOM<PolicyNoteItem>(8, _omitFieldNames ? '' : 'policyNote',
        subBuilder: PolicyNoteItem.$_createMessage)
    ..aOM<FallbackPathItem>(9, _omitFieldNames ? '' : 'fallbackPath',
        subBuilder: FallbackPathItem.$_createMessage)
    ..aOM<$2.Timestamp>(10, _omitFieldNames ? '' : 'checkedAt',
        subBuilder: $2.Timestamp.$_createMessage)
    ..aOM<$2.Timestamp>(11, _omitFieldNames ? '' : 'validUntil',
        subBuilder: $2.Timestamp.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CapabilityMatrixCell clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CapabilityMatrixCell copyWith(void Function(CapabilityMatrixCell) updates) =>
      super.copyWith((message) => updates(message as CapabilityMatrixCell))
          as CapabilityMatrixCell;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use CapabilityMatrixCell() / CapabilityMatrixCell.new instead')
  static CapabilityMatrixCell create() => CapabilityMatrixCell._();
  static $pb.GeneratedMessage $_createMessage() => CapabilityMatrixCell._();
  @$core.override
  CapabilityMatrixCell createEmptyInstance() => CapabilityMatrixCell._();
  @$core.pragma('dart2js:noInline')
  static CapabilityMatrixCell getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CapabilityMatrixCell>(
          CapabilityMatrixCell.$_createMessage);
  static CapabilityMatrixCell? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get platform => $_getSZ(0);
  @$pb.TagNumber(1)
  set platform($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPlatform() => $_has(0);
  @$pb.TagNumber(1)
  void clearPlatform() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get capabilityKey => $_getSZ(1);
  @$pb.TagNumber(2)
  set capabilityKey($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCapabilityKey() => $_has(1);
  @$pb.TagNumber(2)
  void clearCapabilityKey() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get displayName => $_getSZ(2);
  @$pb.TagNumber(3)
  set displayName($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasDisplayName() => $_has(2);
  @$pb.TagNumber(3)
  void clearDisplayName() => $_clearField(3);

  @$pb.TagNumber(4)
  CapabilityState get state => $_getN(3);
  @$pb.TagNumber(4)
  set state(CapabilityState value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasState() => $_has(3);
  @$pb.TagNumber(4)
  void clearState() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.bool get verificationFresh => $_getBF(4);
  @$pb.TagNumber(5)
  set verificationFresh($core.bool value) => $_setBool(4, value);
  @$pb.TagNumber(5)
  $core.bool hasVerificationFresh() => $_has(4);
  @$pb.TagNumber(5)
  void clearVerificationFresh() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.bool get executable => $_getBF(5);
  @$pb.TagNumber(6)
  set executable($core.bool value) => $_setBool(5, value);
  @$pb.TagNumber(6)
  $core.bool hasExecutable() => $_has(5);
  @$pb.TagNumber(6)
  void clearExecutable() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get reason => $_getSZ(6);
  @$pb.TagNumber(7)
  set reason($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasReason() => $_has(6);
  @$pb.TagNumber(7)
  void clearReason() => $_clearField(7);

  @$pb.TagNumber(8)
  PolicyNoteItem get policyNote => $_getN(7);
  @$pb.TagNumber(8)
  set policyNote(PolicyNoteItem value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasPolicyNote() => $_has(7);
  @$pb.TagNumber(8)
  void clearPolicyNote() => $_clearField(8);
  @$pb.TagNumber(8)
  PolicyNoteItem ensurePolicyNote() => $_ensure(7);

  @$pb.TagNumber(9)
  FallbackPathItem get fallbackPath => $_getN(8);
  @$pb.TagNumber(9)
  set fallbackPath(FallbackPathItem value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasFallbackPath() => $_has(8);
  @$pb.TagNumber(9)
  void clearFallbackPath() => $_clearField(9);
  @$pb.TagNumber(9)
  FallbackPathItem ensureFallbackPath() => $_ensure(8);

  @$pb.TagNumber(10)
  $2.Timestamp get checkedAt => $_getN(9);
  @$pb.TagNumber(10)
  set checkedAt($2.Timestamp value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasCheckedAt() => $_has(9);
  @$pb.TagNumber(10)
  void clearCheckedAt() => $_clearField(10);
  @$pb.TagNumber(10)
  $2.Timestamp ensureCheckedAt() => $_ensure(9);

  @$pb.TagNumber(11)
  $2.Timestamp get validUntil => $_getN(10);
  @$pb.TagNumber(11)
  set validUntil($2.Timestamp value) => $_setField(11, value);
  @$pb.TagNumber(11)
  $core.bool hasValidUntil() => $_has(10);
  @$pb.TagNumber(11)
  void clearValidUntil() => $_clearField(11);
  @$pb.TagNumber(11)
  $2.Timestamp ensureValidUntil() => $_ensure(10);
}

/// Request for GetMatrix.
class GetMatrixRequest extends $pb.GeneratedMessage {
  factory GetMatrixRequest({
    $1.UUID? workspaceId,
    $core.String? platformFilter,
  }) {
    final result = GetMatrixRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (platformFilter != null) result.platformFilter = platformFilter;
    return result;
  }

  GetMatrixRequest._();

  factory GetMatrixRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetMatrixRequest()..mergeFromBuffer(data, registry);
  factory GetMatrixRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetMatrixRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetMatrixRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.admin.v1'),
      createEmptyInstance: GetMatrixRequest.$_createMessage)
    ..aOM<$1.UUID>(1, _omitFieldNames ? '' : 'workspaceId',
        subBuilder: $1.UUID.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'platformFilter')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetMatrixRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetMatrixRequest copyWith(void Function(GetMatrixRequest) updates) =>
      super.copyWith((message) => updates(message as GetMatrixRequest))
          as GetMatrixRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use GetMatrixRequest() / GetMatrixRequest.new instead')
  static GetMatrixRequest create() => GetMatrixRequest._();
  static $pb.GeneratedMessage $_createMessage() => GetMatrixRequest._();
  @$core.override
  GetMatrixRequest createEmptyInstance() => GetMatrixRequest._();
  @$core.pragma('dart2js:noInline')
  static GetMatrixRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetMatrixRequest>(
          GetMatrixRequest.$_createMessage);
  static GetMatrixRequest? _defaultInstance;

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
  $core.String get platformFilter => $_getSZ(1);
  @$pb.TagNumber(2)
  set platformFilter($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPlatformFilter() => $_has(1);
  @$pb.TagNumber(2)
  void clearPlatformFilter() => $_clearField(2);
}

/// Response for GetMatrix.
class GetMatrixResponse extends $pb.GeneratedMessage {
  factory GetMatrixResponse({
    $1.UUID? workspaceId,
    $core.Iterable<CapabilityMatrixCell>? cells,
    $2.Timestamp? generatedAt,
  }) {
    final result = GetMatrixResponse._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (cells != null) result.cells.addAll(cells);
    if (generatedAt != null) result.generatedAt = generatedAt;
    return result;
  }

  GetMatrixResponse._();

  factory GetMatrixResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetMatrixResponse()..mergeFromBuffer(data, registry);
  factory GetMatrixResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetMatrixResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetMatrixResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.admin.v1'),
      createEmptyInstance: GetMatrixResponse.$_createMessage)
    ..aOM<$1.UUID>(1, _omitFieldNames ? '' : 'workspaceId',
        subBuilder: $1.UUID.$_createMessage)
    ..pPM<CapabilityMatrixCell>(2, _omitFieldNames ? '' : 'cells',
        subBuilder: CapabilityMatrixCell.$_createMessage)
    ..aOM<$2.Timestamp>(3, _omitFieldNames ? '' : 'generatedAt',
        subBuilder: $2.Timestamp.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetMatrixResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetMatrixResponse copyWith(void Function(GetMatrixResponse) updates) =>
      super.copyWith((message) => updates(message as GetMatrixResponse))
          as GetMatrixResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use GetMatrixResponse() / GetMatrixResponse.new instead')
  static GetMatrixResponse create() => GetMatrixResponse._();
  static $pb.GeneratedMessage $_createMessage() => GetMatrixResponse._();
  @$core.override
  GetMatrixResponse createEmptyInstance() => GetMatrixResponse._();
  @$core.pragma('dart2js:noInline')
  static GetMatrixResponse getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetMatrixResponse>(
          GetMatrixResponse.$_createMessage);
  static GetMatrixResponse? _defaultInstance;

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
  $pb.PbList<CapabilityMatrixCell> get cells => $_getList(1);

  @$pb.TagNumber(3)
  $2.Timestamp get generatedAt => $_getN(2);
  @$pb.TagNumber(3)
  set generatedAt($2.Timestamp value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasGeneratedAt() => $_has(2);
  @$pb.TagNumber(3)
  void clearGeneratedAt() => $_clearField(3);
  @$pb.TagNumber(3)
  $2.Timestamp ensureGeneratedAt() => $_ensure(2);
}

/// Proactive business coaching recommendation (PRD §36B).
/// Never alters technical API capability state.
class ProactiveCoachingCard extends $pb.GeneratedMessage {
  factory ProactiveCoachingCard({
    $core.String? metricKey,
    $core.String? observedValue,
    $core.String? thresholdValue,
    $fixnum.Int64? numerator,
    $fixnum.Int64? denominator,
    $core.String? windowLabel,
    $core.String? message,
    $core.Iterable<$core.String>? recommendedActions,
  }) {
    final result = ProactiveCoachingCard._();
    if (metricKey != null) result.metricKey = metricKey;
    if (observedValue != null) result.observedValue = observedValue;
    if (thresholdValue != null) result.thresholdValue = thresholdValue;
    if (numerator != null) result.numerator = numerator;
    if (denominator != null) result.denominator = denominator;
    if (windowLabel != null) result.windowLabel = windowLabel;
    if (message != null) result.message = message;
    if (recommendedActions != null)
      result.recommendedActions.addAll(recommendedActions);
    return result;
  }

  ProactiveCoachingCard._();

  factory ProactiveCoachingCard.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ProactiveCoachingCard()..mergeFromBuffer(data, registry);
  factory ProactiveCoachingCard.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ProactiveCoachingCard()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ProactiveCoachingCard',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.admin.v1'),
      createEmptyInstance: ProactiveCoachingCard.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'metricKey')
    ..aOS(2, _omitFieldNames ? '' : 'observedValue')
    ..aOS(3, _omitFieldNames ? '' : 'thresholdValue')
    ..aInt64(4, _omitFieldNames ? '' : 'numerator')
    ..aInt64(5, _omitFieldNames ? '' : 'denominator')
    ..aOS(6, _omitFieldNames ? '' : 'windowLabel')
    ..aOS(7, _omitFieldNames ? '' : 'message')
    ..pPS(8, _omitFieldNames ? '' : 'recommendedActions')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ProactiveCoachingCard clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ProactiveCoachingCard copyWith(
          void Function(ProactiveCoachingCard) updates) =>
      super.copyWith((message) => updates(message as ProactiveCoachingCard))
          as ProactiveCoachingCard;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ProactiveCoachingCard() / ProactiveCoachingCard.new instead')
  static ProactiveCoachingCard create() => ProactiveCoachingCard._();
  static $pb.GeneratedMessage $_createMessage() => ProactiveCoachingCard._();
  @$core.override
  ProactiveCoachingCard createEmptyInstance() => ProactiveCoachingCard._();
  @$core.pragma('dart2js:noInline')
  static ProactiveCoachingCard getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ProactiveCoachingCard>(
          ProactiveCoachingCard.$_createMessage);
  static ProactiveCoachingCard? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get metricKey => $_getSZ(0);
  @$pb.TagNumber(1)
  set metricKey($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasMetricKey() => $_has(0);
  @$pb.TagNumber(1)
  void clearMetricKey() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get observedValue => $_getSZ(1);
  @$pb.TagNumber(2)
  set observedValue($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasObservedValue() => $_has(1);
  @$pb.TagNumber(2)
  void clearObservedValue() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get thresholdValue => $_getSZ(2);
  @$pb.TagNumber(3)
  set thresholdValue($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasThresholdValue() => $_has(2);
  @$pb.TagNumber(3)
  void clearThresholdValue() => $_clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get numerator => $_getI64(3);
  @$pb.TagNumber(4)
  set numerator($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasNumerator() => $_has(3);
  @$pb.TagNumber(4)
  void clearNumerator() => $_clearField(4);

  @$pb.TagNumber(5)
  $fixnum.Int64 get denominator => $_getI64(4);
  @$pb.TagNumber(5)
  set denominator($fixnum.Int64 value) => $_setInt64(4, value);
  @$pb.TagNumber(5)
  $core.bool hasDenominator() => $_has(4);
  @$pb.TagNumber(5)
  void clearDenominator() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get windowLabel => $_getSZ(5);
  @$pb.TagNumber(6)
  set windowLabel($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasWindowLabel() => $_has(5);
  @$pb.TagNumber(6)
  void clearWindowLabel() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get message => $_getSZ(6);
  @$pb.TagNumber(7)
  set message($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasMessage() => $_has(6);
  @$pb.TagNumber(7)
  void clearMessage() => $_clearField(7);

  @$pb.TagNumber(8)
  $pb.PbList<$core.String> get recommendedActions => $_getList(7);
}

/// Composite platform health score card (RULE-M22-003).
class PlatformHealthScoreCard extends $pb.GeneratedMessage {
  factory PlatformHealthScoreCard({
    $1.UUID? healthScoreId,
    $1.UUID? connectedAccountId,
    $core.String? platform,
    $core.int? overallScore,
    $core.String? statusBand,
    $core.int? availabilityScore,
    $core.int? errorRateScore,
    $core.int? latencyScore,
    $core.int? rateLimitScore,
    $core.Iterable<$core.String>? riskFlags,
    $core.Iterable<ProactiveCoachingCard>? coachingCards,
    $2.Timestamp? capturedAt,
  }) {
    final result = PlatformHealthScoreCard._();
    if (healthScoreId != null) result.healthScoreId = healthScoreId;
    if (connectedAccountId != null)
      result.connectedAccountId = connectedAccountId;
    if (platform != null) result.platform = platform;
    if (overallScore != null) result.overallScore = overallScore;
    if (statusBand != null) result.statusBand = statusBand;
    if (availabilityScore != null) result.availabilityScore = availabilityScore;
    if (errorRateScore != null) result.errorRateScore = errorRateScore;
    if (latencyScore != null) result.latencyScore = latencyScore;
    if (rateLimitScore != null) result.rateLimitScore = rateLimitScore;
    if (riskFlags != null) result.riskFlags.addAll(riskFlags);
    if (coachingCards != null) result.coachingCards.addAll(coachingCards);
    if (capturedAt != null) result.capturedAt = capturedAt;
    return result;
  }

  PlatformHealthScoreCard._();

  factory PlatformHealthScoreCard.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PlatformHealthScoreCard()..mergeFromBuffer(data, registry);
  factory PlatformHealthScoreCard.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PlatformHealthScoreCard()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PlatformHealthScoreCard',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.admin.v1'),
      createEmptyInstance: PlatformHealthScoreCard.$_createMessage)
    ..aOM<$1.UUID>(1, _omitFieldNames ? '' : 'healthScoreId',
        subBuilder: $1.UUID.$_createMessage)
    ..aOM<$1.UUID>(2, _omitFieldNames ? '' : 'connectedAccountId',
        subBuilder: $1.UUID.$_createMessage)
    ..aOS(3, _omitFieldNames ? '' : 'platform')
    ..aI(4, _omitFieldNames ? '' : 'overallScore')
    ..aOS(5, _omitFieldNames ? '' : 'statusBand')
    ..aI(6, _omitFieldNames ? '' : 'availabilityScore')
    ..aI(7, _omitFieldNames ? '' : 'errorRateScore')
    ..aI(8, _omitFieldNames ? '' : 'latencyScore')
    ..aI(9, _omitFieldNames ? '' : 'rateLimitScore')
    ..pPS(10, _omitFieldNames ? '' : 'riskFlags')
    ..pPM<ProactiveCoachingCard>(11, _omitFieldNames ? '' : 'coachingCards',
        subBuilder: ProactiveCoachingCard.$_createMessage)
    ..aOM<$2.Timestamp>(12, _omitFieldNames ? '' : 'capturedAt',
        subBuilder: $2.Timestamp.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PlatformHealthScoreCard clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PlatformHealthScoreCard copyWith(
          void Function(PlatformHealthScoreCard) updates) =>
      super.copyWith((message) => updates(message as PlatformHealthScoreCard))
          as PlatformHealthScoreCard;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use PlatformHealthScoreCard() / PlatformHealthScoreCard.new instead')
  static PlatformHealthScoreCard create() => PlatformHealthScoreCard._();
  static $pb.GeneratedMessage $_createMessage() => PlatformHealthScoreCard._();
  @$core.override
  PlatformHealthScoreCard createEmptyInstance() => PlatformHealthScoreCard._();
  @$core.pragma('dart2js:noInline')
  static PlatformHealthScoreCard getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PlatformHealthScoreCard>(
          PlatformHealthScoreCard.$_createMessage);
  static PlatformHealthScoreCard? _defaultInstance;

  @$pb.TagNumber(1)
  $1.UUID get healthScoreId => $_getN(0);
  @$pb.TagNumber(1)
  set healthScoreId($1.UUID value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasHealthScoreId() => $_has(0);
  @$pb.TagNumber(1)
  void clearHealthScoreId() => $_clearField(1);
  @$pb.TagNumber(1)
  $1.UUID ensureHealthScoreId() => $_ensure(0);

  @$pb.TagNumber(2)
  $1.UUID get connectedAccountId => $_getN(1);
  @$pb.TagNumber(2)
  set connectedAccountId($1.UUID value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasConnectedAccountId() => $_has(1);
  @$pb.TagNumber(2)
  void clearConnectedAccountId() => $_clearField(2);
  @$pb.TagNumber(2)
  $1.UUID ensureConnectedAccountId() => $_ensure(1);

  @$pb.TagNumber(3)
  $core.String get platform => $_getSZ(2);
  @$pb.TagNumber(3)
  set platform($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPlatform() => $_has(2);
  @$pb.TagNumber(3)
  void clearPlatform() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get overallScore => $_getIZ(3);
  @$pb.TagNumber(4)
  set overallScore($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasOverallScore() => $_has(3);
  @$pb.TagNumber(4)
  void clearOverallScore() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get statusBand => $_getSZ(4);
  @$pb.TagNumber(5)
  set statusBand($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasStatusBand() => $_has(4);
  @$pb.TagNumber(5)
  void clearStatusBand() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.int get availabilityScore => $_getIZ(5);
  @$pb.TagNumber(6)
  set availabilityScore($core.int value) => $_setSignedInt32(5, value);
  @$pb.TagNumber(6)
  $core.bool hasAvailabilityScore() => $_has(5);
  @$pb.TagNumber(6)
  void clearAvailabilityScore() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.int get errorRateScore => $_getIZ(6);
  @$pb.TagNumber(7)
  set errorRateScore($core.int value) => $_setSignedInt32(6, value);
  @$pb.TagNumber(7)
  $core.bool hasErrorRateScore() => $_has(6);
  @$pb.TagNumber(7)
  void clearErrorRateScore() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.int get latencyScore => $_getIZ(7);
  @$pb.TagNumber(8)
  set latencyScore($core.int value) => $_setSignedInt32(7, value);
  @$pb.TagNumber(8)
  $core.bool hasLatencyScore() => $_has(7);
  @$pb.TagNumber(8)
  void clearLatencyScore() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.int get rateLimitScore => $_getIZ(8);
  @$pb.TagNumber(9)
  set rateLimitScore($core.int value) => $_setSignedInt32(8, value);
  @$pb.TagNumber(9)
  $core.bool hasRateLimitScore() => $_has(8);
  @$pb.TagNumber(9)
  void clearRateLimitScore() => $_clearField(9);

  @$pb.TagNumber(10)
  $pb.PbList<$core.String> get riskFlags => $_getList(9);

  @$pb.TagNumber(11)
  $pb.PbList<ProactiveCoachingCard> get coachingCards => $_getList(10);

  @$pb.TagNumber(12)
  $2.Timestamp get capturedAt => $_getN(11);
  @$pb.TagNumber(12)
  set capturedAt($2.Timestamp value) => $_setField(12, value);
  @$pb.TagNumber(12)
  $core.bool hasCapturedAt() => $_has(11);
  @$pb.TagNumber(12)
  void clearCapturedAt() => $_clearField(12);
  @$pb.TagNumber(12)
  $2.Timestamp ensureCapturedAt() => $_ensure(11);
}

/// Request for GetHealthScores.
class GetHealthScoresRequest extends $pb.GeneratedMessage {
  factory GetHealthScoresRequest({
    $1.UUID? workspaceId,
  }) {
    final result = GetHealthScoresRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    return result;
  }

  GetHealthScoresRequest._();

  factory GetHealthScoresRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetHealthScoresRequest()..mergeFromBuffer(data, registry);
  factory GetHealthScoresRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetHealthScoresRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetHealthScoresRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.admin.v1'),
      createEmptyInstance: GetHealthScoresRequest.$_createMessage)
    ..aOM<$1.UUID>(1, _omitFieldNames ? '' : 'workspaceId',
        subBuilder: $1.UUID.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetHealthScoresRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetHealthScoresRequest copyWith(
          void Function(GetHealthScoresRequest) updates) =>
      super.copyWith((message) => updates(message as GetHealthScoresRequest))
          as GetHealthScoresRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use GetHealthScoresRequest() / GetHealthScoresRequest.new instead')
  static GetHealthScoresRequest create() => GetHealthScoresRequest._();
  static $pb.GeneratedMessage $_createMessage() => GetHealthScoresRequest._();
  @$core.override
  GetHealthScoresRequest createEmptyInstance() => GetHealthScoresRequest._();
  @$core.pragma('dart2js:noInline')
  static GetHealthScoresRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetHealthScoresRequest>(
          GetHealthScoresRequest.$_createMessage);
  static GetHealthScoresRequest? _defaultInstance;

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
}

/// Response for GetHealthScores.
class GetHealthScoresResponse extends $pb.GeneratedMessage {
  factory GetHealthScoresResponse({
    $1.UUID? workspaceId,
    $core.Iterable<PlatformHealthScoreCard>? scores,
  }) {
    final result = GetHealthScoresResponse._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (scores != null) result.scores.addAll(scores);
    return result;
  }

  GetHealthScoresResponse._();

  factory GetHealthScoresResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetHealthScoresResponse()..mergeFromBuffer(data, registry);
  factory GetHealthScoresResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetHealthScoresResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetHealthScoresResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.admin.v1'),
      createEmptyInstance: GetHealthScoresResponse.$_createMessage)
    ..aOM<$1.UUID>(1, _omitFieldNames ? '' : 'workspaceId',
        subBuilder: $1.UUID.$_createMessage)
    ..pPM<PlatformHealthScoreCard>(2, _omitFieldNames ? '' : 'scores',
        subBuilder: PlatformHealthScoreCard.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetHealthScoresResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetHealthScoresResponse copyWith(
          void Function(GetHealthScoresResponse) updates) =>
      super.copyWith((message) => updates(message as GetHealthScoresResponse))
          as GetHealthScoresResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use GetHealthScoresResponse() / GetHealthScoresResponse.new instead')
  static GetHealthScoresResponse create() => GetHealthScoresResponse._();
  static $pb.GeneratedMessage $_createMessage() => GetHealthScoresResponse._();
  @$core.override
  GetHealthScoresResponse createEmptyInstance() => GetHealthScoresResponse._();
  @$core.pragma('dart2js:noInline')
  static GetHealthScoresResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetHealthScoresResponse>(
          GetHealthScoresResponse.$_createMessage);
  static GetHealthScoresResponse? _defaultInstance;

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
  $pb.PbList<PlatformHealthScoreCard> get scores => $_getList(1);
}

/// Request for ListPolicyNotes.
class ListPolicyNotesRequest extends $pb.GeneratedMessage {
  factory ListPolicyNotesRequest({
    $1.UUID? workspaceId,
    $core.String? platformFilter,
  }) {
    final result = ListPolicyNotesRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (platformFilter != null) result.platformFilter = platformFilter;
    return result;
  }

  ListPolicyNotesRequest._();

  factory ListPolicyNotesRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListPolicyNotesRequest()..mergeFromBuffer(data, registry);
  factory ListPolicyNotesRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListPolicyNotesRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListPolicyNotesRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.admin.v1'),
      createEmptyInstance: ListPolicyNotesRequest.$_createMessage)
    ..aOM<$1.UUID>(1, _omitFieldNames ? '' : 'workspaceId',
        subBuilder: $1.UUID.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'platformFilter')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListPolicyNotesRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListPolicyNotesRequest copyWith(
          void Function(ListPolicyNotesRequest) updates) =>
      super.copyWith((message) => updates(message as ListPolicyNotesRequest))
          as ListPolicyNotesRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ListPolicyNotesRequest() / ListPolicyNotesRequest.new instead')
  static ListPolicyNotesRequest create() => ListPolicyNotesRequest._();
  static $pb.GeneratedMessage $_createMessage() => ListPolicyNotesRequest._();
  @$core.override
  ListPolicyNotesRequest createEmptyInstance() => ListPolicyNotesRequest._();
  @$core.pragma('dart2js:noInline')
  static ListPolicyNotesRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListPolicyNotesRequest>(
          ListPolicyNotesRequest.$_createMessage);
  static ListPolicyNotesRequest? _defaultInstance;

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
  $core.String get platformFilter => $_getSZ(1);
  @$pb.TagNumber(2)
  set platformFilter($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPlatformFilter() => $_has(1);
  @$pb.TagNumber(2)
  void clearPlatformFilter() => $_clearField(2);
}

/// Response for ListPolicyNotes.
class ListPolicyNotesResponse extends $pb.GeneratedMessage {
  factory ListPolicyNotesResponse({
    $core.Iterable<PolicyNoteItem>? policyNotes,
  }) {
    final result = ListPolicyNotesResponse._();
    if (policyNotes != null) result.policyNotes.addAll(policyNotes);
    return result;
  }

  ListPolicyNotesResponse._();

  factory ListPolicyNotesResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListPolicyNotesResponse()..mergeFromBuffer(data, registry);
  factory ListPolicyNotesResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListPolicyNotesResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListPolicyNotesResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.admin.v1'),
      createEmptyInstance: ListPolicyNotesResponse.$_createMessage)
    ..pPM<PolicyNoteItem>(1, _omitFieldNames ? '' : 'policyNotes',
        subBuilder: PolicyNoteItem.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListPolicyNotesResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListPolicyNotesResponse copyWith(
          void Function(ListPolicyNotesResponse) updates) =>
      super.copyWith((message) => updates(message as ListPolicyNotesResponse))
          as ListPolicyNotesResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ListPolicyNotesResponse() / ListPolicyNotesResponse.new instead')
  static ListPolicyNotesResponse create() => ListPolicyNotesResponse._();
  static $pb.GeneratedMessage $_createMessage() => ListPolicyNotesResponse._();
  @$core.override
  ListPolicyNotesResponse createEmptyInstance() => ListPolicyNotesResponse._();
  @$core.pragma('dart2js:noInline')
  static ListPolicyNotesResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListPolicyNotesResponse>(
          ListPolicyNotesResponse.$_createMessage);
  static ListPolicyNotesResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<PolicyNoteItem> get policyNotes => $_getList(0);
}

/// Request for ListFallbackPaths.
class ListFallbackPathsRequest extends $pb.GeneratedMessage {
  factory ListFallbackPathsRequest({
    $1.UUID? workspaceId,
    $core.String? platformFilter,
  }) {
    final result = ListFallbackPathsRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (platformFilter != null) result.platformFilter = platformFilter;
    return result;
  }

  ListFallbackPathsRequest._();

  factory ListFallbackPathsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListFallbackPathsRequest()..mergeFromBuffer(data, registry);
  factory ListFallbackPathsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListFallbackPathsRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListFallbackPathsRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.admin.v1'),
      createEmptyInstance: ListFallbackPathsRequest.$_createMessage)
    ..aOM<$1.UUID>(1, _omitFieldNames ? '' : 'workspaceId',
        subBuilder: $1.UUID.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'platformFilter')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListFallbackPathsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListFallbackPathsRequest copyWith(
          void Function(ListFallbackPathsRequest) updates) =>
      super.copyWith((message) => updates(message as ListFallbackPathsRequest))
          as ListFallbackPathsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ListFallbackPathsRequest() / ListFallbackPathsRequest.new instead')
  static ListFallbackPathsRequest create() => ListFallbackPathsRequest._();
  static $pb.GeneratedMessage $_createMessage() => ListFallbackPathsRequest._();
  @$core.override
  ListFallbackPathsRequest createEmptyInstance() =>
      ListFallbackPathsRequest._();
  @$core.pragma('dart2js:noInline')
  static ListFallbackPathsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListFallbackPathsRequest>(
          ListFallbackPathsRequest.$_createMessage);
  static ListFallbackPathsRequest? _defaultInstance;

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
  $core.String get platformFilter => $_getSZ(1);
  @$pb.TagNumber(2)
  set platformFilter($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPlatformFilter() => $_has(1);
  @$pb.TagNumber(2)
  void clearPlatformFilter() => $_clearField(2);
}

/// Response for ListFallbackPaths.
class ListFallbackPathsResponse extends $pb.GeneratedMessage {
  factory ListFallbackPathsResponse({
    $core.Iterable<FallbackPathItem>? fallbackPaths,
  }) {
    final result = ListFallbackPathsResponse._();
    if (fallbackPaths != null) result.fallbackPaths.addAll(fallbackPaths);
    return result;
  }

  ListFallbackPathsResponse._();

  factory ListFallbackPathsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListFallbackPathsResponse()..mergeFromBuffer(data, registry);
  factory ListFallbackPathsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListFallbackPathsResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListFallbackPathsResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.admin.v1'),
      createEmptyInstance: ListFallbackPathsResponse.$_createMessage)
    ..pPM<FallbackPathItem>(1, _omitFieldNames ? '' : 'fallbackPaths',
        subBuilder: FallbackPathItem.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListFallbackPathsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListFallbackPathsResponse copyWith(
          void Function(ListFallbackPathsResponse) updates) =>
      super.copyWith((message) => updates(message as ListFallbackPathsResponse))
          as ListFallbackPathsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ListFallbackPathsResponse() / ListFallbackPathsResponse.new instead')
  static ListFallbackPathsResponse create() => ListFallbackPathsResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      ListFallbackPathsResponse._();
  @$core.override
  ListFallbackPathsResponse createEmptyInstance() =>
      ListFallbackPathsResponse._();
  @$core.pragma('dart2js:noInline')
  static ListFallbackPathsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListFallbackPathsResponse>(
          ListFallbackPathsResponse.$_createMessage);
  static ListFallbackPathsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<FallbackPathItem> get fallbackPaths => $_getList(0);
}

/// Sanitized connected account summary (never contains encrypted OAuth tokens).
class ConnectedAccountItem extends $pb.GeneratedMessage {
  factory ConnectedAccountItem({
    $1.UUID? connectedAccountId,
    $1.UUID? workspaceId,
    $core.String? platform,
    $core.String? accountType,
    $core.String? externalAccountId,
    $core.String? accountName,
    $core.String? status,
    $core.int? healthScore,
    $core.Iterable<$core.String>? grantedScopes,
    $2.Timestamp? tokenExpiresAt,
    $2.Timestamp? lastSyncedAt,
  }) {
    final result = ConnectedAccountItem._();
    if (connectedAccountId != null)
      result.connectedAccountId = connectedAccountId;
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (platform != null) result.platform = platform;
    if (accountType != null) result.accountType = accountType;
    if (externalAccountId != null) result.externalAccountId = externalAccountId;
    if (accountName != null) result.accountName = accountName;
    if (status != null) result.status = status;
    if (healthScore != null) result.healthScore = healthScore;
    if (grantedScopes != null) result.grantedScopes.addAll(grantedScopes);
    if (tokenExpiresAt != null) result.tokenExpiresAt = tokenExpiresAt;
    if (lastSyncedAt != null) result.lastSyncedAt = lastSyncedAt;
    return result;
  }

  ConnectedAccountItem._();

  factory ConnectedAccountItem.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ConnectedAccountItem()..mergeFromBuffer(data, registry);
  factory ConnectedAccountItem.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ConnectedAccountItem()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ConnectedAccountItem',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.admin.v1'),
      createEmptyInstance: ConnectedAccountItem.$_createMessage)
    ..aOM<$1.UUID>(1, _omitFieldNames ? '' : 'connectedAccountId',
        subBuilder: $1.UUID.$_createMessage)
    ..aOM<$1.UUID>(2, _omitFieldNames ? '' : 'workspaceId',
        subBuilder: $1.UUID.$_createMessage)
    ..aOS(3, _omitFieldNames ? '' : 'platform')
    ..aOS(4, _omitFieldNames ? '' : 'accountType')
    ..aOS(5, _omitFieldNames ? '' : 'externalAccountId')
    ..aOS(6, _omitFieldNames ? '' : 'accountName')
    ..aOS(7, _omitFieldNames ? '' : 'status')
    ..aI(8, _omitFieldNames ? '' : 'healthScore')
    ..pPS(9, _omitFieldNames ? '' : 'grantedScopes')
    ..aOM<$2.Timestamp>(10, _omitFieldNames ? '' : 'tokenExpiresAt',
        subBuilder: $2.Timestamp.$_createMessage)
    ..aOM<$2.Timestamp>(11, _omitFieldNames ? '' : 'lastSyncedAt',
        subBuilder: $2.Timestamp.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ConnectedAccountItem clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ConnectedAccountItem copyWith(void Function(ConnectedAccountItem) updates) =>
      super.copyWith((message) => updates(message as ConnectedAccountItem))
          as ConnectedAccountItem;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ConnectedAccountItem() / ConnectedAccountItem.new instead')
  static ConnectedAccountItem create() => ConnectedAccountItem._();
  static $pb.GeneratedMessage $_createMessage() => ConnectedAccountItem._();
  @$core.override
  ConnectedAccountItem createEmptyInstance() => ConnectedAccountItem._();
  @$core.pragma('dart2js:noInline')
  static ConnectedAccountItem getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ConnectedAccountItem>(
          ConnectedAccountItem.$_createMessage);
  static ConnectedAccountItem? _defaultInstance;

  @$pb.TagNumber(1)
  $1.UUID get connectedAccountId => $_getN(0);
  @$pb.TagNumber(1)
  set connectedAccountId($1.UUID value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasConnectedAccountId() => $_has(0);
  @$pb.TagNumber(1)
  void clearConnectedAccountId() => $_clearField(1);
  @$pb.TagNumber(1)
  $1.UUID ensureConnectedAccountId() => $_ensure(0);

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
  $core.String get platform => $_getSZ(2);
  @$pb.TagNumber(3)
  set platform($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPlatform() => $_has(2);
  @$pb.TagNumber(3)
  void clearPlatform() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get accountType => $_getSZ(3);
  @$pb.TagNumber(4)
  set accountType($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasAccountType() => $_has(3);
  @$pb.TagNumber(4)
  void clearAccountType() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get externalAccountId => $_getSZ(4);
  @$pb.TagNumber(5)
  set externalAccountId($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasExternalAccountId() => $_has(4);
  @$pb.TagNumber(5)
  void clearExternalAccountId() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get accountName => $_getSZ(5);
  @$pb.TagNumber(6)
  set accountName($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasAccountName() => $_has(5);
  @$pb.TagNumber(6)
  void clearAccountName() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get status => $_getSZ(6);
  @$pb.TagNumber(7)
  set status($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasStatus() => $_has(6);
  @$pb.TagNumber(7)
  void clearStatus() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.int get healthScore => $_getIZ(7);
  @$pb.TagNumber(8)
  set healthScore($core.int value) => $_setSignedInt32(7, value);
  @$pb.TagNumber(8)
  $core.bool hasHealthScore() => $_has(7);
  @$pb.TagNumber(8)
  void clearHealthScore() => $_clearField(8);

  @$pb.TagNumber(9)
  $pb.PbList<$core.String> get grantedScopes => $_getList(8);

  @$pb.TagNumber(10)
  $2.Timestamp get tokenExpiresAt => $_getN(9);
  @$pb.TagNumber(10)
  set tokenExpiresAt($2.Timestamp value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasTokenExpiresAt() => $_has(9);
  @$pb.TagNumber(10)
  void clearTokenExpiresAt() => $_clearField(10);
  @$pb.TagNumber(10)
  $2.Timestamp ensureTokenExpiresAt() => $_ensure(9);

  @$pb.TagNumber(11)
  $2.Timestamp get lastSyncedAt => $_getN(10);
  @$pb.TagNumber(11)
  set lastSyncedAt($2.Timestamp value) => $_setField(11, value);
  @$pb.TagNumber(11)
  $core.bool hasLastSyncedAt() => $_has(10);
  @$pb.TagNumber(11)
  void clearLastSyncedAt() => $_clearField(11);
  @$pb.TagNumber(11)
  $2.Timestamp ensureLastSyncedAt() => $_ensure(10);
}

/// Request for ConnectorService/List.
class ConnectorServiceListRequest extends $pb.GeneratedMessage {
  factory ConnectorServiceListRequest({
    $1.UUID? workspaceId,
  }) {
    final result = ConnectorServiceListRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    return result;
  }

  ConnectorServiceListRequest._();

  factory ConnectorServiceListRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ConnectorServiceListRequest()..mergeFromBuffer(data, registry);
  factory ConnectorServiceListRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ConnectorServiceListRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ConnectorServiceListRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.admin.v1'),
      createEmptyInstance: ConnectorServiceListRequest.$_createMessage)
    ..aOM<$1.UUID>(1, _omitFieldNames ? '' : 'workspaceId',
        subBuilder: $1.UUID.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ConnectorServiceListRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ConnectorServiceListRequest copyWith(
          void Function(ConnectorServiceListRequest) updates) =>
      super.copyWith(
              (message) => updates(message as ConnectorServiceListRequest))
          as ConnectorServiceListRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ConnectorServiceListRequest() / ConnectorServiceListRequest.new instead')
  static ConnectorServiceListRequest create() =>
      ConnectorServiceListRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      ConnectorServiceListRequest._();
  @$core.override
  ConnectorServiceListRequest createEmptyInstance() =>
      ConnectorServiceListRequest._();
  @$core.pragma('dart2js:noInline')
  static ConnectorServiceListRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ConnectorServiceListRequest>(
          ConnectorServiceListRequest.$_createMessage);
  static ConnectorServiceListRequest? _defaultInstance;

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
}

/// Response for ConnectorService/List.
class ConnectorServiceListResponse extends $pb.GeneratedMessage {
  factory ConnectorServiceListResponse({
    $core.Iterable<ConnectedAccountItem>? accounts,
  }) {
    final result = ConnectorServiceListResponse._();
    if (accounts != null) result.accounts.addAll(accounts);
    return result;
  }

  ConnectorServiceListResponse._();

  factory ConnectorServiceListResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ConnectorServiceListResponse()..mergeFromBuffer(data, registry);
  factory ConnectorServiceListResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ConnectorServiceListResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ConnectorServiceListResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.admin.v1'),
      createEmptyInstance: ConnectorServiceListResponse.$_createMessage)
    ..pPM<ConnectedAccountItem>(1, _omitFieldNames ? '' : 'accounts',
        subBuilder: ConnectedAccountItem.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ConnectorServiceListResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ConnectorServiceListResponse copyWith(
          void Function(ConnectorServiceListResponse) updates) =>
      super.copyWith(
              (message) => updates(message as ConnectorServiceListResponse))
          as ConnectorServiceListResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ConnectorServiceListResponse() / ConnectorServiceListResponse.new instead')
  static ConnectorServiceListResponse create() =>
      ConnectorServiceListResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      ConnectorServiceListResponse._();
  @$core.override
  ConnectorServiceListResponse createEmptyInstance() =>
      ConnectorServiceListResponse._();
  @$core.pragma('dart2js:noInline')
  static ConnectorServiceListResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ConnectorServiceListResponse>(
          ConnectorServiceListResponse.$_createMessage);
  static ConnectorServiceListResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<ConnectedAccountItem> get accounts => $_getList(0);
}

/// Request for ConnectorService/Check.
class ConnectorServiceCheckRequest extends $pb.GeneratedMessage {
  factory ConnectorServiceCheckRequest({
    $1.UUID? workspaceId,
    $1.UUID? connectedAccountId,
    $core.String? platform,
    $core.String? actionKey,
    $core.String? targetMarket,
    $core.bool? requireWrite,
  }) {
    final result = ConnectorServiceCheckRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (connectedAccountId != null)
      result.connectedAccountId = connectedAccountId;
    if (platform != null) result.platform = platform;
    if (actionKey != null) result.actionKey = actionKey;
    if (targetMarket != null) result.targetMarket = targetMarket;
    if (requireWrite != null) result.requireWrite = requireWrite;
    return result;
  }

  ConnectorServiceCheckRequest._();

  factory ConnectorServiceCheckRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ConnectorServiceCheckRequest()..mergeFromBuffer(data, registry);
  factory ConnectorServiceCheckRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ConnectorServiceCheckRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ConnectorServiceCheckRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.admin.v1'),
      createEmptyInstance: ConnectorServiceCheckRequest.$_createMessage)
    ..aOM<$1.UUID>(1, _omitFieldNames ? '' : 'workspaceId',
        subBuilder: $1.UUID.$_createMessage)
    ..aOM<$1.UUID>(2, _omitFieldNames ? '' : 'connectedAccountId',
        subBuilder: $1.UUID.$_createMessage)
    ..aOS(3, _omitFieldNames ? '' : 'platform')
    ..aOS(4, _omitFieldNames ? '' : 'actionKey')
    ..aOS(5, _omitFieldNames ? '' : 'targetMarket')
    ..aOB(6, _omitFieldNames ? '' : 'requireWrite')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ConnectorServiceCheckRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ConnectorServiceCheckRequest copyWith(
          void Function(ConnectorServiceCheckRequest) updates) =>
      super.copyWith(
              (message) => updates(message as ConnectorServiceCheckRequest))
          as ConnectorServiceCheckRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ConnectorServiceCheckRequest() / ConnectorServiceCheckRequest.new instead')
  static ConnectorServiceCheckRequest create() =>
      ConnectorServiceCheckRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      ConnectorServiceCheckRequest._();
  @$core.override
  ConnectorServiceCheckRequest createEmptyInstance() =>
      ConnectorServiceCheckRequest._();
  @$core.pragma('dart2js:noInline')
  static ConnectorServiceCheckRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ConnectorServiceCheckRequest>(
          ConnectorServiceCheckRequest.$_createMessage);
  static ConnectorServiceCheckRequest? _defaultInstance;

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
  $1.UUID get connectedAccountId => $_getN(1);
  @$pb.TagNumber(2)
  set connectedAccountId($1.UUID value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasConnectedAccountId() => $_has(1);
  @$pb.TagNumber(2)
  void clearConnectedAccountId() => $_clearField(2);
  @$pb.TagNumber(2)
  $1.UUID ensureConnectedAccountId() => $_ensure(1);

  @$pb.TagNumber(3)
  $core.String get platform => $_getSZ(2);
  @$pb.TagNumber(3)
  set platform($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPlatform() => $_has(2);
  @$pb.TagNumber(3)
  void clearPlatform() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get actionKey => $_getSZ(3);
  @$pb.TagNumber(4)
  set actionKey($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasActionKey() => $_has(3);
  @$pb.TagNumber(4)
  void clearActionKey() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get targetMarket => $_getSZ(4);
  @$pb.TagNumber(5)
  set targetMarket($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasTargetMarket() => $_has(4);
  @$pb.TagNumber(5)
  void clearTargetMarket() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.bool get requireWrite => $_getBF(5);
  @$pb.TagNumber(6)
  set requireWrite($core.bool value) => $_setBool(5, value);
  @$pb.TagNumber(6)
  $core.bool hasRequireWrite() => $_has(5);
  @$pb.TagNumber(6)
  void clearRequireWrite() => $_clearField(6);
}

/// Response for ConnectorService/Check.
class ConnectorServiceCheckResponse extends $pb.GeneratedMessage {
  factory ConnectorServiceCheckResponse({
    CapabilityState? state,
    $core.bool? executable,
    $core.bool? verificationFresh,
    $core.String? reason,
    PolicyNoteItem? policyNote,
    FallbackPathItem? fallbackPath,
  }) {
    final result = ConnectorServiceCheckResponse._();
    if (state != null) result.state = state;
    if (executable != null) result.executable = executable;
    if (verificationFresh != null) result.verificationFresh = verificationFresh;
    if (reason != null) result.reason = reason;
    if (policyNote != null) result.policyNote = policyNote;
    if (fallbackPath != null) result.fallbackPath = fallbackPath;
    return result;
  }

  ConnectorServiceCheckResponse._();

  factory ConnectorServiceCheckResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ConnectorServiceCheckResponse()..mergeFromBuffer(data, registry);
  factory ConnectorServiceCheckResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ConnectorServiceCheckResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ConnectorServiceCheckResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.admin.v1'),
      createEmptyInstance: ConnectorServiceCheckResponse.$_createMessage)
    ..aE<CapabilityState>(1, _omitFieldNames ? '' : 'state',
        enumValues: CapabilityState.values)
    ..aOB(2, _omitFieldNames ? '' : 'executable')
    ..aOB(3, _omitFieldNames ? '' : 'verificationFresh')
    ..aOS(4, _omitFieldNames ? '' : 'reason')
    ..aOM<PolicyNoteItem>(5, _omitFieldNames ? '' : 'policyNote',
        subBuilder: PolicyNoteItem.$_createMessage)
    ..aOM<FallbackPathItem>(6, _omitFieldNames ? '' : 'fallbackPath',
        subBuilder: FallbackPathItem.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ConnectorServiceCheckResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ConnectorServiceCheckResponse copyWith(
          void Function(ConnectorServiceCheckResponse) updates) =>
      super.copyWith(
              (message) => updates(message as ConnectorServiceCheckResponse))
          as ConnectorServiceCheckResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ConnectorServiceCheckResponse() / ConnectorServiceCheckResponse.new instead')
  static ConnectorServiceCheckResponse create() =>
      ConnectorServiceCheckResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      ConnectorServiceCheckResponse._();
  @$core.override
  ConnectorServiceCheckResponse createEmptyInstance() =>
      ConnectorServiceCheckResponse._();
  @$core.pragma('dart2js:noInline')
  static ConnectorServiceCheckResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ConnectorServiceCheckResponse>(
          ConnectorServiceCheckResponse.$_createMessage);
  static ConnectorServiceCheckResponse? _defaultInstance;

  @$pb.TagNumber(1)
  CapabilityState get state => $_getN(0);
  @$pb.TagNumber(1)
  set state(CapabilityState value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasState() => $_has(0);
  @$pb.TagNumber(1)
  void clearState() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.bool get executable => $_getBF(1);
  @$pb.TagNumber(2)
  set executable($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasExecutable() => $_has(1);
  @$pb.TagNumber(2)
  void clearExecutable() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.bool get verificationFresh => $_getBF(2);
  @$pb.TagNumber(3)
  set verificationFresh($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasVerificationFresh() => $_has(2);
  @$pb.TagNumber(3)
  void clearVerificationFresh() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get reason => $_getSZ(3);
  @$pb.TagNumber(4)
  set reason($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasReason() => $_has(3);
  @$pb.TagNumber(4)
  void clearReason() => $_clearField(4);

  @$pb.TagNumber(5)
  PolicyNoteItem get policyNote => $_getN(4);
  @$pb.TagNumber(5)
  set policyNote(PolicyNoteItem value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasPolicyNote() => $_has(4);
  @$pb.TagNumber(5)
  void clearPolicyNote() => $_clearField(5);
  @$pb.TagNumber(5)
  PolicyNoteItem ensurePolicyNote() => $_ensure(4);

  @$pb.TagNumber(6)
  FallbackPathItem get fallbackPath => $_getN(5);
  @$pb.TagNumber(6)
  set fallbackPath(FallbackPathItem value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasFallbackPath() => $_has(5);
  @$pb.TagNumber(6)
  void clearFallbackPath() => $_clearField(6);
  @$pb.TagNumber(6)
  FallbackPathItem ensureFallbackPath() => $_ensure(5);
}

/// Request for ConnectorService/CheckHealth.
class ConnectorServiceCheckHealthRequest extends $pb.GeneratedMessage {
  factory ConnectorServiceCheckHealthRequest({
    $1.UUID? workspaceId,
    $1.UUID? connectedAccountId,
  }) {
    final result = ConnectorServiceCheckHealthRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (connectedAccountId != null)
      result.connectedAccountId = connectedAccountId;
    return result;
  }

  ConnectorServiceCheckHealthRequest._();

  factory ConnectorServiceCheckHealthRequest.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ConnectorServiceCheckHealthRequest()..mergeFromBuffer(data, registry);
  factory ConnectorServiceCheckHealthRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ConnectorServiceCheckHealthRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ConnectorServiceCheckHealthRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.admin.v1'),
      createEmptyInstance: ConnectorServiceCheckHealthRequest.$_createMessage)
    ..aOM<$1.UUID>(1, _omitFieldNames ? '' : 'workspaceId',
        subBuilder: $1.UUID.$_createMessage)
    ..aOM<$1.UUID>(2, _omitFieldNames ? '' : 'connectedAccountId',
        subBuilder: $1.UUID.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ConnectorServiceCheckHealthRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ConnectorServiceCheckHealthRequest copyWith(
          void Function(ConnectorServiceCheckHealthRequest) updates) =>
      super.copyWith((message) =>
              updates(message as ConnectorServiceCheckHealthRequest))
          as ConnectorServiceCheckHealthRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ConnectorServiceCheckHealthRequest() / ConnectorServiceCheckHealthRequest.new instead')
  static ConnectorServiceCheckHealthRequest create() =>
      ConnectorServiceCheckHealthRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      ConnectorServiceCheckHealthRequest._();
  @$core.override
  ConnectorServiceCheckHealthRequest createEmptyInstance() =>
      ConnectorServiceCheckHealthRequest._();
  @$core.pragma('dart2js:noInline')
  static ConnectorServiceCheckHealthRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ConnectorServiceCheckHealthRequest>(
          ConnectorServiceCheckHealthRequest.$_createMessage);
  static ConnectorServiceCheckHealthRequest? _defaultInstance;

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
  $1.UUID get connectedAccountId => $_getN(1);
  @$pb.TagNumber(2)
  set connectedAccountId($1.UUID value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasConnectedAccountId() => $_has(1);
  @$pb.TagNumber(2)
  void clearConnectedAccountId() => $_clearField(2);
  @$pb.TagNumber(2)
  $1.UUID ensureConnectedAccountId() => $_ensure(1);
}

/// Response for ConnectorService/CheckHealth.
class ConnectorServiceCheckHealthResponse extends $pb.GeneratedMessage {
  factory ConnectorServiceCheckHealthResponse({
    PlatformHealthScoreCard? healthScore,
  }) {
    final result = ConnectorServiceCheckHealthResponse._();
    if (healthScore != null) result.healthScore = healthScore;
    return result;
  }

  ConnectorServiceCheckHealthResponse._();

  factory ConnectorServiceCheckHealthResponse.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ConnectorServiceCheckHealthResponse()..mergeFromBuffer(data, registry);
  factory ConnectorServiceCheckHealthResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ConnectorServiceCheckHealthResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ConnectorServiceCheckHealthResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.admin.v1'),
      createEmptyInstance: ConnectorServiceCheckHealthResponse.$_createMessage)
    ..aOM<PlatformHealthScoreCard>(1, _omitFieldNames ? '' : 'healthScore',
        subBuilder: PlatformHealthScoreCard.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ConnectorServiceCheckHealthResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ConnectorServiceCheckHealthResponse copyWith(
          void Function(ConnectorServiceCheckHealthResponse) updates) =>
      super.copyWith((message) =>
              updates(message as ConnectorServiceCheckHealthResponse))
          as ConnectorServiceCheckHealthResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ConnectorServiceCheckHealthResponse() / ConnectorServiceCheckHealthResponse.new instead')
  static ConnectorServiceCheckHealthResponse create() =>
      ConnectorServiceCheckHealthResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      ConnectorServiceCheckHealthResponse._();
  @$core.override
  ConnectorServiceCheckHealthResponse createEmptyInstance() =>
      ConnectorServiceCheckHealthResponse._();
  @$core.pragma('dart2js:noInline')
  static ConnectorServiceCheckHealthResponse getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
              ConnectorServiceCheckHealthResponse>(
          ConnectorServiceCheckHealthResponse.$_createMessage);
  static ConnectorServiceCheckHealthResponse? _defaultInstance;

  @$pb.TagNumber(1)
  PlatformHealthScoreCard get healthScore => $_getN(0);
  @$pb.TagNumber(1)
  set healthScore(PlatformHealthScoreCard value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasHealthScore() => $_has(0);
  @$pb.TagNumber(1)
  void clearHealthScore() => $_clearField(1);
  @$pb.TagNumber(1)
  PlatformHealthScoreCard ensureHealthScore() => $_ensure(0);
}

/// Request for ConnectorService/Disconnect.
class ConnectorServiceDisconnectRequest extends $pb.GeneratedMessage {
  factory ConnectorServiceDisconnectRequest({
    $1.CommandContext? context,
    $1.UUID? connectedAccountId,
  }) {
    final result = ConnectorServiceDisconnectRequest._();
    if (context != null) result.context = context;
    if (connectedAccountId != null)
      result.connectedAccountId = connectedAccountId;
    return result;
  }

  ConnectorServiceDisconnectRequest._();

  factory ConnectorServiceDisconnectRequest.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ConnectorServiceDisconnectRequest()..mergeFromBuffer(data, registry);
  factory ConnectorServiceDisconnectRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ConnectorServiceDisconnectRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ConnectorServiceDisconnectRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.admin.v1'),
      createEmptyInstance: ConnectorServiceDisconnectRequest.$_createMessage)
    ..aOM<$1.CommandContext>(1, _omitFieldNames ? '' : 'context',
        subBuilder: $1.CommandContext.$_createMessage)
    ..aOM<$1.UUID>(2, _omitFieldNames ? '' : 'connectedAccountId',
        subBuilder: $1.UUID.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ConnectorServiceDisconnectRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ConnectorServiceDisconnectRequest copyWith(
          void Function(ConnectorServiceDisconnectRequest) updates) =>
      super.copyWith((message) =>
              updates(message as ConnectorServiceDisconnectRequest))
          as ConnectorServiceDisconnectRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ConnectorServiceDisconnectRequest() / ConnectorServiceDisconnectRequest.new instead')
  static ConnectorServiceDisconnectRequest create() =>
      ConnectorServiceDisconnectRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      ConnectorServiceDisconnectRequest._();
  @$core.override
  ConnectorServiceDisconnectRequest createEmptyInstance() =>
      ConnectorServiceDisconnectRequest._();
  @$core.pragma('dart2js:noInline')
  static ConnectorServiceDisconnectRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ConnectorServiceDisconnectRequest>(
          ConnectorServiceDisconnectRequest.$_createMessage);
  static ConnectorServiceDisconnectRequest? _defaultInstance;

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
  $1.UUID get connectedAccountId => $_getN(1);
  @$pb.TagNumber(2)
  set connectedAccountId($1.UUID value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasConnectedAccountId() => $_has(1);
  @$pb.TagNumber(2)
  void clearConnectedAccountId() => $_clearField(2);
  @$pb.TagNumber(2)
  $1.UUID ensureConnectedAccountId() => $_ensure(1);
}

/// Response for ConnectorService/Disconnect.
class ConnectorServiceDisconnectResponse extends $pb.GeneratedMessage {
  factory ConnectorServiceDisconnectResponse({
    $1.UUID? connectedAccountId,
    $core.String? status,
    $core.bool? replayed,
    $2.Timestamp? disconnectedAt,
  }) {
    final result = ConnectorServiceDisconnectResponse._();
    if (connectedAccountId != null)
      result.connectedAccountId = connectedAccountId;
    if (status != null) result.status = status;
    if (replayed != null) result.replayed = replayed;
    if (disconnectedAt != null) result.disconnectedAt = disconnectedAt;
    return result;
  }

  ConnectorServiceDisconnectResponse._();

  factory ConnectorServiceDisconnectResponse.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ConnectorServiceDisconnectResponse()..mergeFromBuffer(data, registry);
  factory ConnectorServiceDisconnectResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ConnectorServiceDisconnectResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ConnectorServiceDisconnectResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.admin.v1'),
      createEmptyInstance: ConnectorServiceDisconnectResponse.$_createMessage)
    ..aOM<$1.UUID>(1, _omitFieldNames ? '' : 'connectedAccountId',
        subBuilder: $1.UUID.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'status')
    ..aOB(3, _omitFieldNames ? '' : 'replayed')
    ..aOM<$2.Timestamp>(4, _omitFieldNames ? '' : 'disconnectedAt',
        subBuilder: $2.Timestamp.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ConnectorServiceDisconnectResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ConnectorServiceDisconnectResponse copyWith(
          void Function(ConnectorServiceDisconnectResponse) updates) =>
      super.copyWith((message) =>
              updates(message as ConnectorServiceDisconnectResponse))
          as ConnectorServiceDisconnectResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ConnectorServiceDisconnectResponse() / ConnectorServiceDisconnectResponse.new instead')
  static ConnectorServiceDisconnectResponse create() =>
      ConnectorServiceDisconnectResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      ConnectorServiceDisconnectResponse._();
  @$core.override
  ConnectorServiceDisconnectResponse createEmptyInstance() =>
      ConnectorServiceDisconnectResponse._();
  @$core.pragma('dart2js:noInline')
  static ConnectorServiceDisconnectResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ConnectorServiceDisconnectResponse>(
          ConnectorServiceDisconnectResponse.$_createMessage);
  static ConnectorServiceDisconnectResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $1.UUID get connectedAccountId => $_getN(0);
  @$pb.TagNumber(1)
  set connectedAccountId($1.UUID value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasConnectedAccountId() => $_has(0);
  @$pb.TagNumber(1)
  void clearConnectedAccountId() => $_clearField(1);
  @$pb.TagNumber(1)
  $1.UUID ensureConnectedAccountId() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get status => $_getSZ(1);
  @$pb.TagNumber(2)
  set status($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasStatus() => $_has(1);
  @$pb.TagNumber(2)
  void clearStatus() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.bool get replayed => $_getBF(2);
  @$pb.TagNumber(3)
  set replayed($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasReplayed() => $_has(2);
  @$pb.TagNumber(3)
  void clearReplayed() => $_clearField(3);

  @$pb.TagNumber(4)
  $2.Timestamp get disconnectedAt => $_getN(3);
  @$pb.TagNumber(4)
  set disconnectedAt($2.Timestamp value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasDisconnectedAt() => $_has(3);
  @$pb.TagNumber(4)
  void clearDisconnectedAt() => $_clearField(4);
  @$pb.TagNumber(4)
  $2.Timestamp ensureDisconnectedAt() => $_ensure(3);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');

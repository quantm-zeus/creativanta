// This is a generated file - do not edit.
//
// Generated from creativanta/publish/v1/publish.proto.

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
import 'publish.pbenum.dart';

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'publish.pbenum.dart';

/// PublishItem represents a content piece prepared or scheduled for publication.
class PublishItem extends $pb.GeneratedMessage {
  factory PublishItem({
    $core.String? publishItemId,
    $core.String? workspaceId,
    $core.String? assetId,
    $core.String? targetPlatform,
    $core.String? targetAccountId,
    $core.String? targetFormat,
    PublishMode? publishMode,
    $core.String? title,
    $core.String? description,
    $core.Iterable<$core.String>? hashtags,
    $1.Timestamp? scheduleAt,
    $core.String? capabilitySnapshotId,
    PublishItemLifecycleState? lifecycleState,
    DiagnosticsState? diagnosticsState,
    $core.Iterable<$core.String>? linkedOfferIds,
    $core.Iterable<$core.String>? linkedCampaignIds,
    $core.double? packagingScore,
    $core.String? complianceScanResult,
    $core.String? createdBy,
    $1.Timestamp? createdAt,
    $1.Timestamp? updatedAt,
  }) {
    final result = PublishItem._();
    if (publishItemId != null) result.publishItemId = publishItemId;
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (assetId != null) result.assetId = assetId;
    if (targetPlatform != null) result.targetPlatform = targetPlatform;
    if (targetAccountId != null) result.targetAccountId = targetAccountId;
    if (targetFormat != null) result.targetFormat = targetFormat;
    if (publishMode != null) result.publishMode = publishMode;
    if (title != null) result.title = title;
    if (description != null) result.description = description;
    if (hashtags != null) result.hashtags.addAll(hashtags);
    if (scheduleAt != null) result.scheduleAt = scheduleAt;
    if (capabilitySnapshotId != null)
      result.capabilitySnapshotId = capabilitySnapshotId;
    if (lifecycleState != null) result.lifecycleState = lifecycleState;
    if (diagnosticsState != null) result.diagnosticsState = diagnosticsState;
    if (linkedOfferIds != null) result.linkedOfferIds.addAll(linkedOfferIds);
    if (linkedCampaignIds != null)
      result.linkedCampaignIds.addAll(linkedCampaignIds);
    if (packagingScore != null) result.packagingScore = packagingScore;
    if (complianceScanResult != null)
      result.complianceScanResult = complianceScanResult;
    if (createdBy != null) result.createdBy = createdBy;
    if (createdAt != null) result.createdAt = createdAt;
    if (updatedAt != null) result.updatedAt = updatedAt;
    return result;
  }

  PublishItem._();

  factory PublishItem.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PublishItem()..mergeFromBuffer(data, registry);
  factory PublishItem.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PublishItem()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PublishItem',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.publish.v1'),
      createEmptyInstance: PublishItem.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'publishItemId')
    ..aOS(2, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(3, _omitFieldNames ? '' : 'assetId')
    ..aOS(4, _omitFieldNames ? '' : 'targetPlatform')
    ..aOS(5, _omitFieldNames ? '' : 'targetAccountId')
    ..aOS(6, _omitFieldNames ? '' : 'targetFormat')
    ..aE<PublishMode>(7, _omitFieldNames ? '' : 'publishMode',
        enumValues: PublishMode.values)
    ..aOS(8, _omitFieldNames ? '' : 'title')
    ..aOS(9, _omitFieldNames ? '' : 'description')
    ..pPS(10, _omitFieldNames ? '' : 'hashtags')
    ..aOM<$1.Timestamp>(11, _omitFieldNames ? '' : 'scheduleAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..aOS(12, _omitFieldNames ? '' : 'capabilitySnapshotId')
    ..aE<PublishItemLifecycleState>(13, _omitFieldNames ? '' : 'lifecycleState',
        enumValues: PublishItemLifecycleState.values)
    ..aE<DiagnosticsState>(14, _omitFieldNames ? '' : 'diagnosticsState',
        enumValues: DiagnosticsState.values)
    ..pPS(15, _omitFieldNames ? '' : 'linkedOfferIds')
    ..pPS(16, _omitFieldNames ? '' : 'linkedCampaignIds')
    ..aD(17, _omitFieldNames ? '' : 'packagingScore',
        fieldType: $pb.PbFieldType.OF)
    ..aOS(18, _omitFieldNames ? '' : 'complianceScanResult')
    ..aOS(19, _omitFieldNames ? '' : 'createdBy')
    ..aOM<$1.Timestamp>(20, _omitFieldNames ? '' : 'createdAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..aOM<$1.Timestamp>(21, _omitFieldNames ? '' : 'updatedAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PublishItem clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PublishItem copyWith(void Function(PublishItem) updates) =>
      super.copyWith((message) => updates(message as PublishItem))
          as PublishItem;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use PublishItem() / PublishItem.new instead')
  static PublishItem create() => PublishItem._();
  static $pb.GeneratedMessage $_createMessage() => PublishItem._();
  @$core.override
  PublishItem createEmptyInstance() => PublishItem._();
  @$core.pragma('dart2js:noInline')
  static PublishItem getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PublishItem>(
          PublishItem.$_createMessage);
  static PublishItem? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get publishItemId => $_getSZ(0);
  @$pb.TagNumber(1)
  set publishItemId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPublishItemId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPublishItemId() => $_clearField(1);

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
  $core.String get targetPlatform => $_getSZ(3);
  @$pb.TagNumber(4)
  set targetPlatform($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasTargetPlatform() => $_has(3);
  @$pb.TagNumber(4)
  void clearTargetPlatform() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get targetAccountId => $_getSZ(4);
  @$pb.TagNumber(5)
  set targetAccountId($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasTargetAccountId() => $_has(4);
  @$pb.TagNumber(5)
  void clearTargetAccountId() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get targetFormat => $_getSZ(5);
  @$pb.TagNumber(6)
  set targetFormat($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasTargetFormat() => $_has(5);
  @$pb.TagNumber(6)
  void clearTargetFormat() => $_clearField(6);

  @$pb.TagNumber(7)
  PublishMode get publishMode => $_getN(6);
  @$pb.TagNumber(7)
  set publishMode(PublishMode value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasPublishMode() => $_has(6);
  @$pb.TagNumber(7)
  void clearPublishMode() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get title => $_getSZ(7);
  @$pb.TagNumber(8)
  set title($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasTitle() => $_has(7);
  @$pb.TagNumber(8)
  void clearTitle() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get description => $_getSZ(8);
  @$pb.TagNumber(9)
  set description($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasDescription() => $_has(8);
  @$pb.TagNumber(9)
  void clearDescription() => $_clearField(9);

  @$pb.TagNumber(10)
  $pb.PbList<$core.String> get hashtags => $_getList(9);

  @$pb.TagNumber(11)
  $1.Timestamp get scheduleAt => $_getN(10);
  @$pb.TagNumber(11)
  set scheduleAt($1.Timestamp value) => $_setField(11, value);
  @$pb.TagNumber(11)
  $core.bool hasScheduleAt() => $_has(10);
  @$pb.TagNumber(11)
  void clearScheduleAt() => $_clearField(11);
  @$pb.TagNumber(11)
  $1.Timestamp ensureScheduleAt() => $_ensure(10);

  @$pb.TagNumber(12)
  $core.String get capabilitySnapshotId => $_getSZ(11);
  @$pb.TagNumber(12)
  set capabilitySnapshotId($core.String value) => $_setString(11, value);
  @$pb.TagNumber(12)
  $core.bool hasCapabilitySnapshotId() => $_has(11);
  @$pb.TagNumber(12)
  void clearCapabilitySnapshotId() => $_clearField(12);

  @$pb.TagNumber(13)
  PublishItemLifecycleState get lifecycleState => $_getN(12);
  @$pb.TagNumber(13)
  set lifecycleState(PublishItemLifecycleState value) => $_setField(13, value);
  @$pb.TagNumber(13)
  $core.bool hasLifecycleState() => $_has(12);
  @$pb.TagNumber(13)
  void clearLifecycleState() => $_clearField(13);

  @$pb.TagNumber(14)
  DiagnosticsState get diagnosticsState => $_getN(13);
  @$pb.TagNumber(14)
  set diagnosticsState(DiagnosticsState value) => $_setField(14, value);
  @$pb.TagNumber(14)
  $core.bool hasDiagnosticsState() => $_has(13);
  @$pb.TagNumber(14)
  void clearDiagnosticsState() => $_clearField(14);

  @$pb.TagNumber(15)
  $pb.PbList<$core.String> get linkedOfferIds => $_getList(14);

  @$pb.TagNumber(16)
  $pb.PbList<$core.String> get linkedCampaignIds => $_getList(15);

  @$pb.TagNumber(17)
  $core.double get packagingScore => $_getN(16);
  @$pb.TagNumber(17)
  set packagingScore($core.double value) => $_setFloat(16, value);
  @$pb.TagNumber(17)
  $core.bool hasPackagingScore() => $_has(16);
  @$pb.TagNumber(17)
  void clearPackagingScore() => $_clearField(17);

  @$pb.TagNumber(18)
  $core.String get complianceScanResult => $_getSZ(17);
  @$pb.TagNumber(18)
  set complianceScanResult($core.String value) => $_setString(17, value);
  @$pb.TagNumber(18)
  $core.bool hasComplianceScanResult() => $_has(17);
  @$pb.TagNumber(18)
  void clearComplianceScanResult() => $_clearField(18);

  @$pb.TagNumber(19)
  $core.String get createdBy => $_getSZ(18);
  @$pb.TagNumber(19)
  set createdBy($core.String value) => $_setString(18, value);
  @$pb.TagNumber(19)
  $core.bool hasCreatedBy() => $_has(18);
  @$pb.TagNumber(19)
  void clearCreatedBy() => $_clearField(19);

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

/// PublishJob represents a single dispatch execution attempt for a publish item.
class PublishJob extends $pb.GeneratedMessage {
  factory PublishJob({
    $core.String? publishJobId,
    $core.String? workspaceId,
    $core.String? publishItemId,
    $core.String? dispatchStrategy,
    PublishJobLifecycleState? lifecycleState,
    $core.int? attemptCount,
    $core.int? maxAttempts,
    $core.String? currentWorkerId,
    $core.String? approvalRequestId,
    $1.Timestamp? createdAt,
    $1.Timestamp? updatedAt,
  }) {
    final result = PublishJob._();
    if (publishJobId != null) result.publishJobId = publishJobId;
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (publishItemId != null) result.publishItemId = publishItemId;
    if (dispatchStrategy != null) result.dispatchStrategy = dispatchStrategy;
    if (lifecycleState != null) result.lifecycleState = lifecycleState;
    if (attemptCount != null) result.attemptCount = attemptCount;
    if (maxAttempts != null) result.maxAttempts = maxAttempts;
    if (currentWorkerId != null) result.currentWorkerId = currentWorkerId;
    if (approvalRequestId != null) result.approvalRequestId = approvalRequestId;
    if (createdAt != null) result.createdAt = createdAt;
    if (updatedAt != null) result.updatedAt = updatedAt;
    return result;
  }

  PublishJob._();

  factory PublishJob.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PublishJob()..mergeFromBuffer(data, registry);
  factory PublishJob.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PublishJob()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PublishJob',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.publish.v1'),
      createEmptyInstance: PublishJob.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'publishJobId')
    ..aOS(2, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(3, _omitFieldNames ? '' : 'publishItemId')
    ..aOS(4, _omitFieldNames ? '' : 'dispatchStrategy')
    ..aE<PublishJobLifecycleState>(5, _omitFieldNames ? '' : 'lifecycleState',
        enumValues: PublishJobLifecycleState.values)
    ..aI(6, _omitFieldNames ? '' : 'attemptCount')
    ..aI(7, _omitFieldNames ? '' : 'maxAttempts')
    ..aOS(8, _omitFieldNames ? '' : 'currentWorkerId')
    ..aOS(9, _omitFieldNames ? '' : 'approvalRequestId')
    ..aOM<$1.Timestamp>(10, _omitFieldNames ? '' : 'createdAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..aOM<$1.Timestamp>(11, _omitFieldNames ? '' : 'updatedAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PublishJob clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PublishJob copyWith(void Function(PublishJob) updates) =>
      super.copyWith((message) => updates(message as PublishJob)) as PublishJob;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use PublishJob() / PublishJob.new instead')
  static PublishJob create() => PublishJob._();
  static $pb.GeneratedMessage $_createMessage() => PublishJob._();
  @$core.override
  PublishJob createEmptyInstance() => PublishJob._();
  @$core.pragma('dart2js:noInline')
  static PublishJob getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PublishJob>(PublishJob.$_createMessage);
  static PublishJob? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get publishJobId => $_getSZ(0);
  @$pb.TagNumber(1)
  set publishJobId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPublishJobId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPublishJobId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get workspaceId => $_getSZ(1);
  @$pb.TagNumber(2)
  set workspaceId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasWorkspaceId() => $_has(1);
  @$pb.TagNumber(2)
  void clearWorkspaceId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get publishItemId => $_getSZ(2);
  @$pb.TagNumber(3)
  set publishItemId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPublishItemId() => $_has(2);
  @$pb.TagNumber(3)
  void clearPublishItemId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get dispatchStrategy => $_getSZ(3);
  @$pb.TagNumber(4)
  set dispatchStrategy($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasDispatchStrategy() => $_has(3);
  @$pb.TagNumber(4)
  void clearDispatchStrategy() => $_clearField(4);

  @$pb.TagNumber(5)
  PublishJobLifecycleState get lifecycleState => $_getN(4);
  @$pb.TagNumber(5)
  set lifecycleState(PublishJobLifecycleState value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasLifecycleState() => $_has(4);
  @$pb.TagNumber(5)
  void clearLifecycleState() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.int get attemptCount => $_getIZ(5);
  @$pb.TagNumber(6)
  set attemptCount($core.int value) => $_setSignedInt32(5, value);
  @$pb.TagNumber(6)
  $core.bool hasAttemptCount() => $_has(5);
  @$pb.TagNumber(6)
  void clearAttemptCount() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.int get maxAttempts => $_getIZ(6);
  @$pb.TagNumber(7)
  set maxAttempts($core.int value) => $_setSignedInt32(6, value);
  @$pb.TagNumber(7)
  $core.bool hasMaxAttempts() => $_has(6);
  @$pb.TagNumber(7)
  void clearMaxAttempts() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get currentWorkerId => $_getSZ(7);
  @$pb.TagNumber(8)
  set currentWorkerId($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasCurrentWorkerId() => $_has(7);
  @$pb.TagNumber(8)
  void clearCurrentWorkerId() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get approvalRequestId => $_getSZ(8);
  @$pb.TagNumber(9)
  set approvalRequestId($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasApprovalRequestId() => $_has(8);
  @$pb.TagNumber(9)
  void clearApprovalRequestId() => $_clearField(9);

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

  @$pb.TagNumber(11)
  $1.Timestamp get updatedAt => $_getN(10);
  @$pb.TagNumber(11)
  set updatedAt($1.Timestamp value) => $_setField(11, value);
  @$pb.TagNumber(11)
  $core.bool hasUpdatedAt() => $_has(10);
  @$pb.TagNumber(11)
  void clearUpdatedAt() => $_clearField(11);
  @$pb.TagNumber(11)
  $1.Timestamp ensureUpdatedAt() => $_ensure(10);
}

/// PublishLog is an immutable execution record.
class PublishLog extends $pb.GeneratedMessage {
  factory PublishLog({
    $core.String? publishLogId,
    $core.String? workspaceId,
    $core.String? publishJobId,
    $core.String? publishItemId,
    $1.Timestamp? attemptedAt,
    $1.Timestamp? completedAt,
    $1.Timestamp? failedAt,
    $core.String? actorUserId,
    $2.OperatorMode? actingMode,
    ExecutionPath? executionPath,
    $core.String? capabilitySnapshotId,
    PublishResultStatus? resultStatus,
    $core.String? externalPostId,
    $core.String? externalPostUrl,
    $core.String? diagnosticsRef,
    $core.String? evidenceRef,
    $core.String? errorCode,
    $core.String? errorMessage,
  }) {
    final result = PublishLog._();
    if (publishLogId != null) result.publishLogId = publishLogId;
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (publishJobId != null) result.publishJobId = publishJobId;
    if (publishItemId != null) result.publishItemId = publishItemId;
    if (attemptedAt != null) result.attemptedAt = attemptedAt;
    if (completedAt != null) result.completedAt = completedAt;
    if (failedAt != null) result.failedAt = failedAt;
    if (actorUserId != null) result.actorUserId = actorUserId;
    if (actingMode != null) result.actingMode = actingMode;
    if (executionPath != null) result.executionPath = executionPath;
    if (capabilitySnapshotId != null)
      result.capabilitySnapshotId = capabilitySnapshotId;
    if (resultStatus != null) result.resultStatus = resultStatus;
    if (externalPostId != null) result.externalPostId = externalPostId;
    if (externalPostUrl != null) result.externalPostUrl = externalPostUrl;
    if (diagnosticsRef != null) result.diagnosticsRef = diagnosticsRef;
    if (evidenceRef != null) result.evidenceRef = evidenceRef;
    if (errorCode != null) result.errorCode = errorCode;
    if (errorMessage != null) result.errorMessage = errorMessage;
    return result;
  }

  PublishLog._();

  factory PublishLog.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PublishLog()..mergeFromBuffer(data, registry);
  factory PublishLog.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PublishLog()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PublishLog',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.publish.v1'),
      createEmptyInstance: PublishLog.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'publishLogId')
    ..aOS(2, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(3, _omitFieldNames ? '' : 'publishJobId')
    ..aOS(4, _omitFieldNames ? '' : 'publishItemId')
    ..aOM<$1.Timestamp>(5, _omitFieldNames ? '' : 'attemptedAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..aOM<$1.Timestamp>(6, _omitFieldNames ? '' : 'completedAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..aOM<$1.Timestamp>(7, _omitFieldNames ? '' : 'failedAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..aOS(8, _omitFieldNames ? '' : 'actorUserId')
    ..aE<$2.OperatorMode>(9, _omitFieldNames ? '' : 'actingMode',
        enumValues: $2.OperatorMode.values)
    ..aE<ExecutionPath>(10, _omitFieldNames ? '' : 'executionPath',
        enumValues: ExecutionPath.values)
    ..aOS(11, _omitFieldNames ? '' : 'capabilitySnapshotId')
    ..aE<PublishResultStatus>(12, _omitFieldNames ? '' : 'resultStatus',
        enumValues: PublishResultStatus.values)
    ..aOS(13, _omitFieldNames ? '' : 'externalPostId')
    ..aOS(14, _omitFieldNames ? '' : 'externalPostUrl')
    ..aOS(15, _omitFieldNames ? '' : 'diagnosticsRef')
    ..aOS(16, _omitFieldNames ? '' : 'evidenceRef')
    ..aOS(17, _omitFieldNames ? '' : 'errorCode')
    ..aOS(18, _omitFieldNames ? '' : 'errorMessage')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PublishLog clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PublishLog copyWith(void Function(PublishLog) updates) =>
      super.copyWith((message) => updates(message as PublishLog)) as PublishLog;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use PublishLog() / PublishLog.new instead')
  static PublishLog create() => PublishLog._();
  static $pb.GeneratedMessage $_createMessage() => PublishLog._();
  @$core.override
  PublishLog createEmptyInstance() => PublishLog._();
  @$core.pragma('dart2js:noInline')
  static PublishLog getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PublishLog>(PublishLog.$_createMessage);
  static PublishLog? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get publishLogId => $_getSZ(0);
  @$pb.TagNumber(1)
  set publishLogId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPublishLogId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPublishLogId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get workspaceId => $_getSZ(1);
  @$pb.TagNumber(2)
  set workspaceId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasWorkspaceId() => $_has(1);
  @$pb.TagNumber(2)
  void clearWorkspaceId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get publishJobId => $_getSZ(2);
  @$pb.TagNumber(3)
  set publishJobId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPublishJobId() => $_has(2);
  @$pb.TagNumber(3)
  void clearPublishJobId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get publishItemId => $_getSZ(3);
  @$pb.TagNumber(4)
  set publishItemId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasPublishItemId() => $_has(3);
  @$pb.TagNumber(4)
  void clearPublishItemId() => $_clearField(4);

  @$pb.TagNumber(5)
  $1.Timestamp get attemptedAt => $_getN(4);
  @$pb.TagNumber(5)
  set attemptedAt($1.Timestamp value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasAttemptedAt() => $_has(4);
  @$pb.TagNumber(5)
  void clearAttemptedAt() => $_clearField(5);
  @$pb.TagNumber(5)
  $1.Timestamp ensureAttemptedAt() => $_ensure(4);

  @$pb.TagNumber(6)
  $1.Timestamp get completedAt => $_getN(5);
  @$pb.TagNumber(6)
  set completedAt($1.Timestamp value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasCompletedAt() => $_has(5);
  @$pb.TagNumber(6)
  void clearCompletedAt() => $_clearField(6);
  @$pb.TagNumber(6)
  $1.Timestamp ensureCompletedAt() => $_ensure(5);

  @$pb.TagNumber(7)
  $1.Timestamp get failedAt => $_getN(6);
  @$pb.TagNumber(7)
  set failedAt($1.Timestamp value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasFailedAt() => $_has(6);
  @$pb.TagNumber(7)
  void clearFailedAt() => $_clearField(7);
  @$pb.TagNumber(7)
  $1.Timestamp ensureFailedAt() => $_ensure(6);

  @$pb.TagNumber(8)
  $core.String get actorUserId => $_getSZ(7);
  @$pb.TagNumber(8)
  set actorUserId($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasActorUserId() => $_has(7);
  @$pb.TagNumber(8)
  void clearActorUserId() => $_clearField(8);

  @$pb.TagNumber(9)
  $2.OperatorMode get actingMode => $_getN(8);
  @$pb.TagNumber(9)
  set actingMode($2.OperatorMode value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasActingMode() => $_has(8);
  @$pb.TagNumber(9)
  void clearActingMode() => $_clearField(9);

  @$pb.TagNumber(10)
  ExecutionPath get executionPath => $_getN(9);
  @$pb.TagNumber(10)
  set executionPath(ExecutionPath value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasExecutionPath() => $_has(9);
  @$pb.TagNumber(10)
  void clearExecutionPath() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.String get capabilitySnapshotId => $_getSZ(10);
  @$pb.TagNumber(11)
  set capabilitySnapshotId($core.String value) => $_setString(10, value);
  @$pb.TagNumber(11)
  $core.bool hasCapabilitySnapshotId() => $_has(10);
  @$pb.TagNumber(11)
  void clearCapabilitySnapshotId() => $_clearField(11);

  @$pb.TagNumber(12)
  PublishResultStatus get resultStatus => $_getN(11);
  @$pb.TagNumber(12)
  set resultStatus(PublishResultStatus value) => $_setField(12, value);
  @$pb.TagNumber(12)
  $core.bool hasResultStatus() => $_has(11);
  @$pb.TagNumber(12)
  void clearResultStatus() => $_clearField(12);

  @$pb.TagNumber(13)
  $core.String get externalPostId => $_getSZ(12);
  @$pb.TagNumber(13)
  set externalPostId($core.String value) => $_setString(12, value);
  @$pb.TagNumber(13)
  $core.bool hasExternalPostId() => $_has(12);
  @$pb.TagNumber(13)
  void clearExternalPostId() => $_clearField(13);

  @$pb.TagNumber(14)
  $core.String get externalPostUrl => $_getSZ(13);
  @$pb.TagNumber(14)
  set externalPostUrl($core.String value) => $_setString(13, value);
  @$pb.TagNumber(14)
  $core.bool hasExternalPostUrl() => $_has(13);
  @$pb.TagNumber(14)
  void clearExternalPostUrl() => $_clearField(14);

  @$pb.TagNumber(15)
  $core.String get diagnosticsRef => $_getSZ(14);
  @$pb.TagNumber(15)
  set diagnosticsRef($core.String value) => $_setString(14, value);
  @$pb.TagNumber(15)
  $core.bool hasDiagnosticsRef() => $_has(14);
  @$pb.TagNumber(15)
  void clearDiagnosticsRef() => $_clearField(15);

  @$pb.TagNumber(16)
  $core.String get evidenceRef => $_getSZ(15);
  @$pb.TagNumber(16)
  set evidenceRef($core.String value) => $_setString(15, value);
  @$pb.TagNumber(16)
  $core.bool hasEvidenceRef() => $_has(15);
  @$pb.TagNumber(16)
  void clearEvidenceRef() => $_clearField(16);

  @$pb.TagNumber(17)
  $core.String get errorCode => $_getSZ(16);
  @$pb.TagNumber(17)
  set errorCode($core.String value) => $_setString(16, value);
  @$pb.TagNumber(17)
  $core.bool hasErrorCode() => $_has(16);
  @$pb.TagNumber(17)
  void clearErrorCode() => $_clearField(17);

  @$pb.TagNumber(18)
  $core.String get errorMessage => $_getSZ(17);
  @$pb.TagNumber(18)
  set errorMessage($core.String value) => $_setString(17, value);
  @$pb.TagNumber(18)
  $core.bool hasErrorMessage() => $_has(17);
  @$pb.TagNumber(18)
  void clearErrorMessage() => $_clearField(18);
}

/// ChannelPost represents a post tracked on an external platform after publishing.
class ChannelPost extends $pb.GeneratedMessage {
  factory ChannelPost({
    $core.String? channelPostId,
    $core.String? workspaceId,
    $core.String? publishItemId,
    $core.String? connectedAccountId,
    $core.String? externalPostId,
    $core.String? externalPermalink,
    $core.String? title,
    $core.String? thumbnailUrl,
    $1.Timestamp? syncedAt,
    $1.Timestamp? createdAt,
    $1.Timestamp? updatedAt,
  }) {
    final result = ChannelPost._();
    if (channelPostId != null) result.channelPostId = channelPostId;
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (publishItemId != null) result.publishItemId = publishItemId;
    if (connectedAccountId != null)
      result.connectedAccountId = connectedAccountId;
    if (externalPostId != null) result.externalPostId = externalPostId;
    if (externalPermalink != null) result.externalPermalink = externalPermalink;
    if (title != null) result.title = title;
    if (thumbnailUrl != null) result.thumbnailUrl = thumbnailUrl;
    if (syncedAt != null) result.syncedAt = syncedAt;
    if (createdAt != null) result.createdAt = createdAt;
    if (updatedAt != null) result.updatedAt = updatedAt;
    return result;
  }

  ChannelPost._();

  factory ChannelPost.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ChannelPost()..mergeFromBuffer(data, registry);
  factory ChannelPost.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ChannelPost()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ChannelPost',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.publish.v1'),
      createEmptyInstance: ChannelPost.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'channelPostId')
    ..aOS(2, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(3, _omitFieldNames ? '' : 'publishItemId')
    ..aOS(4, _omitFieldNames ? '' : 'connectedAccountId')
    ..aOS(5, _omitFieldNames ? '' : 'externalPostId')
    ..aOS(6, _omitFieldNames ? '' : 'externalPermalink')
    ..aOS(7, _omitFieldNames ? '' : 'title')
    ..aOS(8, _omitFieldNames ? '' : 'thumbnailUrl')
    ..aOM<$1.Timestamp>(9, _omitFieldNames ? '' : 'syncedAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..aOM<$1.Timestamp>(10, _omitFieldNames ? '' : 'createdAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..aOM<$1.Timestamp>(11, _omitFieldNames ? '' : 'updatedAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ChannelPost clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ChannelPost copyWith(void Function(ChannelPost) updates) =>
      super.copyWith((message) => updates(message as ChannelPost))
          as ChannelPost;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ChannelPost() / ChannelPost.new instead')
  static ChannelPost create() => ChannelPost._();
  static $pb.GeneratedMessage $_createMessage() => ChannelPost._();
  @$core.override
  ChannelPost createEmptyInstance() => ChannelPost._();
  @$core.pragma('dart2js:noInline')
  static ChannelPost getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ChannelPost>(
          ChannelPost.$_createMessage);
  static ChannelPost? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get channelPostId => $_getSZ(0);
  @$pb.TagNumber(1)
  set channelPostId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasChannelPostId() => $_has(0);
  @$pb.TagNumber(1)
  void clearChannelPostId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get workspaceId => $_getSZ(1);
  @$pb.TagNumber(2)
  set workspaceId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasWorkspaceId() => $_has(1);
  @$pb.TagNumber(2)
  void clearWorkspaceId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get publishItemId => $_getSZ(2);
  @$pb.TagNumber(3)
  set publishItemId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPublishItemId() => $_has(2);
  @$pb.TagNumber(3)
  void clearPublishItemId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get connectedAccountId => $_getSZ(3);
  @$pb.TagNumber(4)
  set connectedAccountId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasConnectedAccountId() => $_has(3);
  @$pb.TagNumber(4)
  void clearConnectedAccountId() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get externalPostId => $_getSZ(4);
  @$pb.TagNumber(5)
  set externalPostId($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasExternalPostId() => $_has(4);
  @$pb.TagNumber(5)
  void clearExternalPostId() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get externalPermalink => $_getSZ(5);
  @$pb.TagNumber(6)
  set externalPermalink($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasExternalPermalink() => $_has(5);
  @$pb.TagNumber(6)
  void clearExternalPermalink() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get title => $_getSZ(6);
  @$pb.TagNumber(7)
  set title($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasTitle() => $_has(6);
  @$pb.TagNumber(7)
  void clearTitle() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get thumbnailUrl => $_getSZ(7);
  @$pb.TagNumber(8)
  set thumbnailUrl($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasThumbnailUrl() => $_has(7);
  @$pb.TagNumber(8)
  void clearThumbnailUrl() => $_clearField(8);

  @$pb.TagNumber(9)
  $1.Timestamp get syncedAt => $_getN(8);
  @$pb.TagNumber(9)
  set syncedAt($1.Timestamp value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasSyncedAt() => $_has(8);
  @$pb.TagNumber(9)
  void clearSyncedAt() => $_clearField(9);
  @$pb.TagNumber(9)
  $1.Timestamp ensureSyncedAt() => $_ensure(8);

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

  @$pb.TagNumber(11)
  $1.Timestamp get updatedAt => $_getN(10);
  @$pb.TagNumber(11)
  set updatedAt($1.Timestamp value) => $_setField(11, value);
  @$pb.TagNumber(11)
  $core.bool hasUpdatedAt() => $_has(10);
  @$pb.TagNumber(11)
  void clearUpdatedAt() => $_clearField(11);
  @$pb.TagNumber(11)
  $1.Timestamp ensureUpdatedAt() => $_ensure(10);
}

/// PlatformCapabilitySummary provides pre-publish capability awareness (RULE-M11-001).
class PlatformCapabilitySummary extends $pb.GeneratedMessage {
  factory PlatformCapabilitySummary({
    $core.String? platform,
    PublishCapabilityState? capabilityState,
    $core.String? connectorState,
    $core.bool? requiresManualFallback,
    $core.String? policySummary,
    $core.String? fallbackInstructions,
    $core.Iterable<$core.String>? requiredScopes,
    $core.bool? executable,
  }) {
    final result = PlatformCapabilitySummary._();
    if (platform != null) result.platform = platform;
    if (capabilityState != null) result.capabilityState = capabilityState;
    if (connectorState != null) result.connectorState = connectorState;
    if (requiresManualFallback != null)
      result.requiresManualFallback = requiresManualFallback;
    if (policySummary != null) result.policySummary = policySummary;
    if (fallbackInstructions != null)
      result.fallbackInstructions = fallbackInstructions;
    if (requiredScopes != null) result.requiredScopes.addAll(requiredScopes);
    if (executable != null) result.executable = executable;
    return result;
  }

  PlatformCapabilitySummary._();

  factory PlatformCapabilitySummary.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PlatformCapabilitySummary()..mergeFromBuffer(data, registry);
  factory PlatformCapabilitySummary.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PlatformCapabilitySummary()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PlatformCapabilitySummary',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.publish.v1'),
      createEmptyInstance: PlatformCapabilitySummary.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'platform')
    ..aE<PublishCapabilityState>(2, _omitFieldNames ? '' : 'capabilityState',
        enumValues: PublishCapabilityState.values)
    ..aOS(3, _omitFieldNames ? '' : 'connectorState')
    ..aOB(4, _omitFieldNames ? '' : 'requiresManualFallback')
    ..aOS(5, _omitFieldNames ? '' : 'policySummary')
    ..aOS(6, _omitFieldNames ? '' : 'fallbackInstructions')
    ..pPS(7, _omitFieldNames ? '' : 'requiredScopes')
    ..aOB(8, _omitFieldNames ? '' : 'executable')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PlatformCapabilitySummary clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PlatformCapabilitySummary copyWith(
          void Function(PlatformCapabilitySummary) updates) =>
      super.copyWith((message) => updates(message as PlatformCapabilitySummary))
          as PlatformCapabilitySummary;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use PlatformCapabilitySummary() / PlatformCapabilitySummary.new instead')
  static PlatformCapabilitySummary create() => PlatformCapabilitySummary._();
  static $pb.GeneratedMessage $_createMessage() =>
      PlatformCapabilitySummary._();
  @$core.override
  PlatformCapabilitySummary createEmptyInstance() =>
      PlatformCapabilitySummary._();
  @$core.pragma('dart2js:noInline')
  static PlatformCapabilitySummary getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PlatformCapabilitySummary>(
          PlatformCapabilitySummary.$_createMessage);
  static PlatformCapabilitySummary? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get platform => $_getSZ(0);
  @$pb.TagNumber(1)
  set platform($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPlatform() => $_has(0);
  @$pb.TagNumber(1)
  void clearPlatform() => $_clearField(1);

  @$pb.TagNumber(2)
  PublishCapabilityState get capabilityState => $_getN(1);
  @$pb.TagNumber(2)
  set capabilityState(PublishCapabilityState value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasCapabilityState() => $_has(1);
  @$pb.TagNumber(2)
  void clearCapabilityState() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get connectorState => $_getSZ(2);
  @$pb.TagNumber(3)
  set connectorState($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasConnectorState() => $_has(2);
  @$pb.TagNumber(3)
  void clearConnectorState() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.bool get requiresManualFallback => $_getBF(3);
  @$pb.TagNumber(4)
  set requiresManualFallback($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(4)
  $core.bool hasRequiresManualFallback() => $_has(3);
  @$pb.TagNumber(4)
  void clearRequiresManualFallback() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get policySummary => $_getSZ(4);
  @$pb.TagNumber(5)
  set policySummary($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasPolicySummary() => $_has(4);
  @$pb.TagNumber(5)
  void clearPolicySummary() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get fallbackInstructions => $_getSZ(5);
  @$pb.TagNumber(6)
  set fallbackInstructions($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasFallbackInstructions() => $_has(5);
  @$pb.TagNumber(6)
  void clearFallbackInstructions() => $_clearField(6);

  @$pb.TagNumber(7)
  $pb.PbList<$core.String> get requiredScopes => $_getList(6);

  @$pb.TagNumber(8)
  $core.bool get executable => $_getBF(7);
  @$pb.TagNumber(8)
  set executable($core.bool value) => $_setBool(7, value);
  @$pb.TagNumber(8)
  $core.bool hasExecutable() => $_has(7);
  @$pb.TagNumber(8)
  void clearExecutable() => $_clearField(8);
}

/// ManualExportPackage provides the asset package for offline upload.
class ManualExportPackage extends $pb.GeneratedMessage {
  factory ManualExportPackage({
    $core.String? publishItemId,
    $core.String? title,
    $core.String? description,
    $core.Iterable<$core.String>? hashtags,
    $core.String? mediaUrl,
    $core.String? targetPlatform,
    $core.String? instructions,
    $core.String? recommendedAspectRatio,
  }) {
    final result = ManualExportPackage._();
    if (publishItemId != null) result.publishItemId = publishItemId;
    if (title != null) result.title = title;
    if (description != null) result.description = description;
    if (hashtags != null) result.hashtags.addAll(hashtags);
    if (mediaUrl != null) result.mediaUrl = mediaUrl;
    if (targetPlatform != null) result.targetPlatform = targetPlatform;
    if (instructions != null) result.instructions = instructions;
    if (recommendedAspectRatio != null)
      result.recommendedAspectRatio = recommendedAspectRatio;
    return result;
  }

  ManualExportPackage._();

  factory ManualExportPackage.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ManualExportPackage()..mergeFromBuffer(data, registry);
  factory ManualExportPackage.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ManualExportPackage()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ManualExportPackage',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.publish.v1'),
      createEmptyInstance: ManualExportPackage.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'publishItemId')
    ..aOS(2, _omitFieldNames ? '' : 'title')
    ..aOS(3, _omitFieldNames ? '' : 'description')
    ..pPS(4, _omitFieldNames ? '' : 'hashtags')
    ..aOS(5, _omitFieldNames ? '' : 'mediaUrl')
    ..aOS(6, _omitFieldNames ? '' : 'targetPlatform')
    ..aOS(7, _omitFieldNames ? '' : 'instructions')
    ..aOS(8, _omitFieldNames ? '' : 'recommendedAspectRatio')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ManualExportPackage clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ManualExportPackage copyWith(void Function(ManualExportPackage) updates) =>
      super.copyWith((message) => updates(message as ManualExportPackage))
          as ManualExportPackage;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core
      .Deprecated('Use ManualExportPackage() / ManualExportPackage.new instead')
  static ManualExportPackage create() => ManualExportPackage._();
  static $pb.GeneratedMessage $_createMessage() => ManualExportPackage._();
  @$core.override
  ManualExportPackage createEmptyInstance() => ManualExportPackage._();
  @$core.pragma('dart2js:noInline')
  static ManualExportPackage getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ManualExportPackage>(
          ManualExportPackage.$_createMessage);
  static ManualExportPackage? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get publishItemId => $_getSZ(0);
  @$pb.TagNumber(1)
  set publishItemId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPublishItemId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPublishItemId() => $_clearField(1);

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
  $pb.PbList<$core.String> get hashtags => $_getList(3);

  @$pb.TagNumber(5)
  $core.String get mediaUrl => $_getSZ(4);
  @$pb.TagNumber(5)
  set mediaUrl($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasMediaUrl() => $_has(4);
  @$pb.TagNumber(5)
  void clearMediaUrl() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get targetPlatform => $_getSZ(5);
  @$pb.TagNumber(6)
  set targetPlatform($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasTargetPlatform() => $_has(5);
  @$pb.TagNumber(6)
  void clearTargetPlatform() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get instructions => $_getSZ(6);
  @$pb.TagNumber(7)
  set instructions($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasInstructions() => $_has(6);
  @$pb.TagNumber(7)
  void clearInstructions() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get recommendedAspectRatio => $_getSZ(7);
  @$pb.TagNumber(8)
  set recommendedAspectRatio($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasRecommendedAspectRatio() => $_has(7);
  @$pb.TagNumber(8)
  void clearRecommendedAspectRatio() => $_clearField(8);
}

/// CreateItemRequest / Response
class CreateItemRequest extends $pb.GeneratedMessage {
  factory CreateItemRequest({
    $2.CommandContext? context,
    $core.String? assetId,
    $core.String? targetPlatform,
    $core.String? targetAccountId,
    $core.String? targetFormat,
    PublishMode? publishMode,
    $core.String? title,
    $core.String? description,
    $core.Iterable<$core.String>? hashtags,
    $1.Timestamp? scheduleAt,
  }) {
    final result = CreateItemRequest._();
    if (context != null) result.context = context;
    if (assetId != null) result.assetId = assetId;
    if (targetPlatform != null) result.targetPlatform = targetPlatform;
    if (targetAccountId != null) result.targetAccountId = targetAccountId;
    if (targetFormat != null) result.targetFormat = targetFormat;
    if (publishMode != null) result.publishMode = publishMode;
    if (title != null) result.title = title;
    if (description != null) result.description = description;
    if (hashtags != null) result.hashtags.addAll(hashtags);
    if (scheduleAt != null) result.scheduleAt = scheduleAt;
    return result;
  }

  CreateItemRequest._();

  factory CreateItemRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CreateItemRequest()..mergeFromBuffer(data, registry);
  factory CreateItemRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CreateItemRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CreateItemRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.publish.v1'),
      createEmptyInstance: CreateItemRequest.$_createMessage)
    ..aOM<$2.CommandContext>(1, _omitFieldNames ? '' : 'context',
        subBuilder: $2.CommandContext.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'assetId')
    ..aOS(3, _omitFieldNames ? '' : 'targetPlatform')
    ..aOS(4, _omitFieldNames ? '' : 'targetAccountId')
    ..aOS(5, _omitFieldNames ? '' : 'targetFormat')
    ..aE<PublishMode>(6, _omitFieldNames ? '' : 'publishMode',
        enumValues: PublishMode.values)
    ..aOS(7, _omitFieldNames ? '' : 'title')
    ..aOS(8, _omitFieldNames ? '' : 'description')
    ..pPS(9, _omitFieldNames ? '' : 'hashtags')
    ..aOM<$1.Timestamp>(10, _omitFieldNames ? '' : 'scheduleAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateItemRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateItemRequest copyWith(void Function(CreateItemRequest) updates) =>
      super.copyWith((message) => updates(message as CreateItemRequest))
          as CreateItemRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use CreateItemRequest() / CreateItemRequest.new instead')
  static CreateItemRequest create() => CreateItemRequest._();
  static $pb.GeneratedMessage $_createMessage() => CreateItemRequest._();
  @$core.override
  CreateItemRequest createEmptyInstance() => CreateItemRequest._();
  @$core.pragma('dart2js:noInline')
  static CreateItemRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CreateItemRequest>(
          CreateItemRequest.$_createMessage);
  static CreateItemRequest? _defaultInstance;

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
  $core.String get targetPlatform => $_getSZ(2);
  @$pb.TagNumber(3)
  set targetPlatform($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasTargetPlatform() => $_has(2);
  @$pb.TagNumber(3)
  void clearTargetPlatform() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get targetAccountId => $_getSZ(3);
  @$pb.TagNumber(4)
  set targetAccountId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasTargetAccountId() => $_has(3);
  @$pb.TagNumber(4)
  void clearTargetAccountId() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get targetFormat => $_getSZ(4);
  @$pb.TagNumber(5)
  set targetFormat($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasTargetFormat() => $_has(4);
  @$pb.TagNumber(5)
  void clearTargetFormat() => $_clearField(5);

  @$pb.TagNumber(6)
  PublishMode get publishMode => $_getN(5);
  @$pb.TagNumber(6)
  set publishMode(PublishMode value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasPublishMode() => $_has(5);
  @$pb.TagNumber(6)
  void clearPublishMode() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get title => $_getSZ(6);
  @$pb.TagNumber(7)
  set title($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasTitle() => $_has(6);
  @$pb.TagNumber(7)
  void clearTitle() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get description => $_getSZ(7);
  @$pb.TagNumber(8)
  set description($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasDescription() => $_has(7);
  @$pb.TagNumber(8)
  void clearDescription() => $_clearField(8);

  @$pb.TagNumber(9)
  $pb.PbList<$core.String> get hashtags => $_getList(8);

  @$pb.TagNumber(10)
  $1.Timestamp get scheduleAt => $_getN(9);
  @$pb.TagNumber(10)
  set scheduleAt($1.Timestamp value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasScheduleAt() => $_has(9);
  @$pb.TagNumber(10)
  void clearScheduleAt() => $_clearField(10);
  @$pb.TagNumber(10)
  $1.Timestamp ensureScheduleAt() => $_ensure(9);
}

class CreateItemResponse extends $pb.GeneratedMessage {
  factory CreateItemResponse({
    PublishItem? item,
    PlatformCapabilitySummary? capabilitySummary,
  }) {
    final result = CreateItemResponse._();
    if (item != null) result.item = item;
    if (capabilitySummary != null) result.capabilitySummary = capabilitySummary;
    return result;
  }

  CreateItemResponse._();

  factory CreateItemResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CreateItemResponse()..mergeFromBuffer(data, registry);
  factory CreateItemResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CreateItemResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CreateItemResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.publish.v1'),
      createEmptyInstance: CreateItemResponse.$_createMessage)
    ..aOM<PublishItem>(1, _omitFieldNames ? '' : 'item',
        subBuilder: PublishItem.$_createMessage)
    ..aOM<PlatformCapabilitySummary>(
        2, _omitFieldNames ? '' : 'capabilitySummary',
        subBuilder: PlatformCapabilitySummary.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateItemResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateItemResponse copyWith(void Function(CreateItemResponse) updates) =>
      super.copyWith((message) => updates(message as CreateItemResponse))
          as CreateItemResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use CreateItemResponse() / CreateItemResponse.new instead')
  static CreateItemResponse create() => CreateItemResponse._();
  static $pb.GeneratedMessage $_createMessage() => CreateItemResponse._();
  @$core.override
  CreateItemResponse createEmptyInstance() => CreateItemResponse._();
  @$core.pragma('dart2js:noInline')
  static CreateItemResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CreateItemResponse>(
          CreateItemResponse.$_createMessage);
  static CreateItemResponse? _defaultInstance;

  @$pb.TagNumber(1)
  PublishItem get item => $_getN(0);
  @$pb.TagNumber(1)
  set item(PublishItem value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasItem() => $_has(0);
  @$pb.TagNumber(1)
  void clearItem() => $_clearField(1);
  @$pb.TagNumber(1)
  PublishItem ensureItem() => $_ensure(0);

  @$pb.TagNumber(2)
  PlatformCapabilitySummary get capabilitySummary => $_getN(1);
  @$pb.TagNumber(2)
  set capabilitySummary(PlatformCapabilitySummary value) =>
      $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasCapabilitySummary() => $_has(1);
  @$pb.TagNumber(2)
  void clearCapabilitySummary() => $_clearField(2);
  @$pb.TagNumber(2)
  PlatformCapabilitySummary ensureCapabilitySummary() => $_ensure(1);
}

/// ScheduleRequest / Response
class ScheduleRequest extends $pb.GeneratedMessage {
  factory ScheduleRequest({
    $2.CommandContext? context,
    $core.String? publishItemId,
    $1.Timestamp? scheduledAt,
  }) {
    final result = ScheduleRequest._();
    if (context != null) result.context = context;
    if (publishItemId != null) result.publishItemId = publishItemId;
    if (scheduledAt != null) result.scheduledAt = scheduledAt;
    return result;
  }

  ScheduleRequest._();

  factory ScheduleRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ScheduleRequest()..mergeFromBuffer(data, registry);
  factory ScheduleRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ScheduleRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ScheduleRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.publish.v1'),
      createEmptyInstance: ScheduleRequest.$_createMessage)
    ..aOM<$2.CommandContext>(1, _omitFieldNames ? '' : 'context',
        subBuilder: $2.CommandContext.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'publishItemId')
    ..aOM<$1.Timestamp>(3, _omitFieldNames ? '' : 'scheduledAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ScheduleRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ScheduleRequest copyWith(void Function(ScheduleRequest) updates) =>
      super.copyWith((message) => updates(message as ScheduleRequest))
          as ScheduleRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ScheduleRequest() / ScheduleRequest.new instead')
  static ScheduleRequest create() => ScheduleRequest._();
  static $pb.GeneratedMessage $_createMessage() => ScheduleRequest._();
  @$core.override
  ScheduleRequest createEmptyInstance() => ScheduleRequest._();
  @$core.pragma('dart2js:noInline')
  static ScheduleRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ScheduleRequest>(
          ScheduleRequest.$_createMessage);
  static ScheduleRequest? _defaultInstance;

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
  $core.String get publishItemId => $_getSZ(1);
  @$pb.TagNumber(2)
  set publishItemId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPublishItemId() => $_has(1);
  @$pb.TagNumber(2)
  void clearPublishItemId() => $_clearField(2);

  @$pb.TagNumber(3)
  $1.Timestamp get scheduledAt => $_getN(2);
  @$pb.TagNumber(3)
  set scheduledAt($1.Timestamp value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasScheduledAt() => $_has(2);
  @$pb.TagNumber(3)
  void clearScheduledAt() => $_clearField(3);
  @$pb.TagNumber(3)
  $1.Timestamp ensureScheduledAt() => $_ensure(2);
}

class ScheduleResponse extends $pb.GeneratedMessage {
  factory ScheduleResponse({
    PublishItem? item,
    PublishJob? job,
    $1.Timestamp? scheduledAt,
    $core.int? jitterDelaySeconds,
  }) {
    final result = ScheduleResponse._();
    if (item != null) result.item = item;
    if (job != null) result.job = job;
    if (scheduledAt != null) result.scheduledAt = scheduledAt;
    if (jitterDelaySeconds != null)
      result.jitterDelaySeconds = jitterDelaySeconds;
    return result;
  }

  ScheduleResponse._();

  factory ScheduleResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ScheduleResponse()..mergeFromBuffer(data, registry);
  factory ScheduleResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ScheduleResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ScheduleResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.publish.v1'),
      createEmptyInstance: ScheduleResponse.$_createMessage)
    ..aOM<PublishItem>(1, _omitFieldNames ? '' : 'item',
        subBuilder: PublishItem.$_createMessage)
    ..aOM<PublishJob>(2, _omitFieldNames ? '' : 'job',
        subBuilder: PublishJob.$_createMessage)
    ..aOM<$1.Timestamp>(3, _omitFieldNames ? '' : 'scheduledAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..aI(4, _omitFieldNames ? '' : 'jitterDelaySeconds')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ScheduleResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ScheduleResponse copyWith(void Function(ScheduleResponse) updates) =>
      super.copyWith((message) => updates(message as ScheduleResponse))
          as ScheduleResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ScheduleResponse() / ScheduleResponse.new instead')
  static ScheduleResponse create() => ScheduleResponse._();
  static $pb.GeneratedMessage $_createMessage() => ScheduleResponse._();
  @$core.override
  ScheduleResponse createEmptyInstance() => ScheduleResponse._();
  @$core.pragma('dart2js:noInline')
  static ScheduleResponse getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ScheduleResponse>(
          ScheduleResponse.$_createMessage);
  static ScheduleResponse? _defaultInstance;

  @$pb.TagNumber(1)
  PublishItem get item => $_getN(0);
  @$pb.TagNumber(1)
  set item(PublishItem value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasItem() => $_has(0);
  @$pb.TagNumber(1)
  void clearItem() => $_clearField(1);
  @$pb.TagNumber(1)
  PublishItem ensureItem() => $_ensure(0);

  @$pb.TagNumber(2)
  PublishJob get job => $_getN(1);
  @$pb.TagNumber(2)
  set job(PublishJob value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasJob() => $_has(1);
  @$pb.TagNumber(2)
  void clearJob() => $_clearField(2);
  @$pb.TagNumber(2)
  PublishJob ensureJob() => $_ensure(1);

  @$pb.TagNumber(3)
  $1.Timestamp get scheduledAt => $_getN(2);
  @$pb.TagNumber(3)
  set scheduledAt($1.Timestamp value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasScheduledAt() => $_has(2);
  @$pb.TagNumber(3)
  void clearScheduledAt() => $_clearField(3);
  @$pb.TagNumber(3)
  $1.Timestamp ensureScheduledAt() => $_ensure(2);

  @$pb.TagNumber(4)
  $core.int get jitterDelaySeconds => $_getIZ(3);
  @$pb.TagNumber(4)
  set jitterDelaySeconds($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasJitterDelaySeconds() => $_has(3);
  @$pb.TagNumber(4)
  void clearJitterDelaySeconds() => $_clearField(4);
}

/// ExecuteRequest / Response
class ExecuteRequest extends $pb.GeneratedMessage {
  factory ExecuteRequest({
    $2.CommandContext? context,
    $core.String? publishItemId,
    $core.String? publishJobId,
  }) {
    final result = ExecuteRequest._();
    if (context != null) result.context = context;
    if (publishItemId != null) result.publishItemId = publishItemId;
    if (publishJobId != null) result.publishJobId = publishJobId;
    return result;
  }

  ExecuteRequest._();

  factory ExecuteRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ExecuteRequest()..mergeFromBuffer(data, registry);
  factory ExecuteRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ExecuteRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ExecuteRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.publish.v1'),
      createEmptyInstance: ExecuteRequest.$_createMessage)
    ..aOM<$2.CommandContext>(1, _omitFieldNames ? '' : 'context',
        subBuilder: $2.CommandContext.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'publishItemId')
    ..aOS(3, _omitFieldNames ? '' : 'publishJobId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ExecuteRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ExecuteRequest copyWith(void Function(ExecuteRequest) updates) =>
      super.copyWith((message) => updates(message as ExecuteRequest))
          as ExecuteRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ExecuteRequest() / ExecuteRequest.new instead')
  static ExecuteRequest create() => ExecuteRequest._();
  static $pb.GeneratedMessage $_createMessage() => ExecuteRequest._();
  @$core.override
  ExecuteRequest createEmptyInstance() => ExecuteRequest._();
  @$core.pragma('dart2js:noInline')
  static ExecuteRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ExecuteRequest>(
          ExecuteRequest.$_createMessage);
  static ExecuteRequest? _defaultInstance;

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
  $core.String get publishItemId => $_getSZ(1);
  @$pb.TagNumber(2)
  set publishItemId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPublishItemId() => $_has(1);
  @$pb.TagNumber(2)
  void clearPublishItemId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get publishJobId => $_getSZ(2);
  @$pb.TagNumber(3)
  set publishJobId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPublishJobId() => $_has(2);
  @$pb.TagNumber(3)
  void clearPublishJobId() => $_clearField(3);
}

class ExecuteResponse extends $pb.GeneratedMessage {
  factory ExecuteResponse({
    PublishItem? item,
    PublishJob? job,
    PublishLog? log,
    ChannelPost? channelPost,
  }) {
    final result = ExecuteResponse._();
    if (item != null) result.item = item;
    if (job != null) result.job = job;
    if (log != null) result.log = log;
    if (channelPost != null) result.channelPost = channelPost;
    return result;
  }

  ExecuteResponse._();

  factory ExecuteResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ExecuteResponse()..mergeFromBuffer(data, registry);
  factory ExecuteResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ExecuteResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ExecuteResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.publish.v1'),
      createEmptyInstance: ExecuteResponse.$_createMessage)
    ..aOM<PublishItem>(1, _omitFieldNames ? '' : 'item',
        subBuilder: PublishItem.$_createMessage)
    ..aOM<PublishJob>(2, _omitFieldNames ? '' : 'job',
        subBuilder: PublishJob.$_createMessage)
    ..aOM<PublishLog>(3, _omitFieldNames ? '' : 'log',
        subBuilder: PublishLog.$_createMessage)
    ..aOM<ChannelPost>(4, _omitFieldNames ? '' : 'channelPost',
        subBuilder: ChannelPost.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ExecuteResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ExecuteResponse copyWith(void Function(ExecuteResponse) updates) =>
      super.copyWith((message) => updates(message as ExecuteResponse))
          as ExecuteResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ExecuteResponse() / ExecuteResponse.new instead')
  static ExecuteResponse create() => ExecuteResponse._();
  static $pb.GeneratedMessage $_createMessage() => ExecuteResponse._();
  @$core.override
  ExecuteResponse createEmptyInstance() => ExecuteResponse._();
  @$core.pragma('dart2js:noInline')
  static ExecuteResponse getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ExecuteResponse>(
          ExecuteResponse.$_createMessage);
  static ExecuteResponse? _defaultInstance;

  @$pb.TagNumber(1)
  PublishItem get item => $_getN(0);
  @$pb.TagNumber(1)
  set item(PublishItem value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasItem() => $_has(0);
  @$pb.TagNumber(1)
  void clearItem() => $_clearField(1);
  @$pb.TagNumber(1)
  PublishItem ensureItem() => $_ensure(0);

  @$pb.TagNumber(2)
  PublishJob get job => $_getN(1);
  @$pb.TagNumber(2)
  set job(PublishJob value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasJob() => $_has(1);
  @$pb.TagNumber(2)
  void clearJob() => $_clearField(2);
  @$pb.TagNumber(2)
  PublishJob ensureJob() => $_ensure(1);

  @$pb.TagNumber(3)
  PublishLog get log => $_getN(2);
  @$pb.TagNumber(3)
  set log(PublishLog value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasLog() => $_has(2);
  @$pb.TagNumber(3)
  void clearLog() => $_clearField(3);
  @$pb.TagNumber(3)
  PublishLog ensureLog() => $_ensure(2);

  @$pb.TagNumber(4)
  ChannelPost get channelPost => $_getN(3);
  @$pb.TagNumber(4)
  set channelPost(ChannelPost value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasChannelPost() => $_has(3);
  @$pb.TagNumber(4)
  void clearChannelPost() => $_clearField(4);
  @$pb.TagNumber(4)
  ChannelPost ensureChannelPost() => $_ensure(3);
}

/// RetryRequest / Response
class RetryRequest extends $pb.GeneratedMessage {
  factory RetryRequest({
    $2.CommandContext? context,
    $core.String? publishItemId,
    $core.String? reason,
  }) {
    final result = RetryRequest._();
    if (context != null) result.context = context;
    if (publishItemId != null) result.publishItemId = publishItemId;
    if (reason != null) result.reason = reason;
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
          _omitMessageNames ? '' : 'creativanta.publish.v1'),
      createEmptyInstance: RetryRequest.$_createMessage)
    ..aOM<$2.CommandContext>(1, _omitFieldNames ? '' : 'context',
        subBuilder: $2.CommandContext.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'publishItemId')
    ..aOS(3, _omitFieldNames ? '' : 'reason')
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
  $core.String get publishItemId => $_getSZ(1);
  @$pb.TagNumber(2)
  set publishItemId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPublishItemId() => $_has(1);
  @$pb.TagNumber(2)
  void clearPublishItemId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get reason => $_getSZ(2);
  @$pb.TagNumber(3)
  set reason($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasReason() => $_has(2);
  @$pb.TagNumber(3)
  void clearReason() => $_clearField(3);
}

class RetryResponse extends $pb.GeneratedMessage {
  factory RetryResponse({
    PublishItem? item,
    PublishJob? job,
  }) {
    final result = RetryResponse._();
    if (item != null) result.item = item;
    if (job != null) result.job = job;
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
          _omitMessageNames ? '' : 'creativanta.publish.v1'),
      createEmptyInstance: RetryResponse.$_createMessage)
    ..aOM<PublishItem>(1, _omitFieldNames ? '' : 'item',
        subBuilder: PublishItem.$_createMessage)
    ..aOM<PublishJob>(2, _omitFieldNames ? '' : 'job',
        subBuilder: PublishJob.$_createMessage)
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
  PublishItem get item => $_getN(0);
  @$pb.TagNumber(1)
  set item(PublishItem value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasItem() => $_has(0);
  @$pb.TagNumber(1)
  void clearItem() => $_clearField(1);
  @$pb.TagNumber(1)
  PublishItem ensureItem() => $_ensure(0);

  @$pb.TagNumber(2)
  PublishJob get job => $_getN(1);
  @$pb.TagNumber(2)
  set job(PublishJob value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasJob() => $_has(1);
  @$pb.TagNumber(2)
  void clearJob() => $_clearField(2);
  @$pb.TagNumber(2)
  PublishJob ensureJob() => $_ensure(1);
}

/// CancelRequest / Response
class CancelRequest extends $pb.GeneratedMessage {
  factory CancelRequest({
    $2.CommandContext? context,
    $core.String? publishItemId,
    $core.String? reason,
  }) {
    final result = CancelRequest._();
    if (context != null) result.context = context;
    if (publishItemId != null) result.publishItemId = publishItemId;
    if (reason != null) result.reason = reason;
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
          _omitMessageNames ? '' : 'creativanta.publish.v1'),
      createEmptyInstance: CancelRequest.$_createMessage)
    ..aOM<$2.CommandContext>(1, _omitFieldNames ? '' : 'context',
        subBuilder: $2.CommandContext.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'publishItemId')
    ..aOS(3, _omitFieldNames ? '' : 'reason')
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
  $core.String get publishItemId => $_getSZ(1);
  @$pb.TagNumber(2)
  set publishItemId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPublishItemId() => $_has(1);
  @$pb.TagNumber(2)
  void clearPublishItemId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get reason => $_getSZ(2);
  @$pb.TagNumber(3)
  set reason($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasReason() => $_has(2);
  @$pb.TagNumber(3)
  void clearReason() => $_clearField(3);
}

class CancelResponse extends $pb.GeneratedMessage {
  factory CancelResponse({
    PublishItem? item,
    $core.bool? cancelled,
  }) {
    final result = CancelResponse._();
    if (item != null) result.item = item;
    if (cancelled != null) result.cancelled = cancelled;
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
          _omitMessageNames ? '' : 'creativanta.publish.v1'),
      createEmptyInstance: CancelResponse.$_createMessage)
    ..aOM<PublishItem>(1, _omitFieldNames ? '' : 'item',
        subBuilder: PublishItem.$_createMessage)
    ..aOB(2, _omitFieldNames ? '' : 'cancelled')
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
  PublishItem get item => $_getN(0);
  @$pb.TagNumber(1)
  set item(PublishItem value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasItem() => $_has(0);
  @$pb.TagNumber(1)
  void clearItem() => $_clearField(1);
  @$pb.TagNumber(1)
  PublishItem ensureItem() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.bool get cancelled => $_getBF(1);
  @$pb.TagNumber(2)
  set cancelled($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCancelled() => $_has(1);
  @$pb.TagNumber(2)
  void clearCancelled() => $_clearField(2);
}

/// ListQueueRequest / Response
class ListQueueRequest extends $pb.GeneratedMessage {
  factory ListQueueRequest({
    $core.String? workspaceId,
    PublishItemLifecycleState? stateFilter,
    $2.Pagination? pagination,
  }) {
    final result = ListQueueRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (stateFilter != null) result.stateFilter = stateFilter;
    if (pagination != null) result.pagination = pagination;
    return result;
  }

  ListQueueRequest._();

  factory ListQueueRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListQueueRequest()..mergeFromBuffer(data, registry);
  factory ListQueueRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListQueueRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListQueueRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.publish.v1'),
      createEmptyInstance: ListQueueRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aE<PublishItemLifecycleState>(2, _omitFieldNames ? '' : 'stateFilter',
        enumValues: PublishItemLifecycleState.values)
    ..aOM<$2.Pagination>(3, _omitFieldNames ? '' : 'pagination',
        subBuilder: $2.Pagination.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListQueueRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListQueueRequest copyWith(void Function(ListQueueRequest) updates) =>
      super.copyWith((message) => updates(message as ListQueueRequest))
          as ListQueueRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ListQueueRequest() / ListQueueRequest.new instead')
  static ListQueueRequest create() => ListQueueRequest._();
  static $pb.GeneratedMessage $_createMessage() => ListQueueRequest._();
  @$core.override
  ListQueueRequest createEmptyInstance() => ListQueueRequest._();
  @$core.pragma('dart2js:noInline')
  static ListQueueRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ListQueueRequest>(
          ListQueueRequest.$_createMessage);
  static ListQueueRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  PublishItemLifecycleState get stateFilter => $_getN(1);
  @$pb.TagNumber(2)
  set stateFilter(PublishItemLifecycleState value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasStateFilter() => $_has(1);
  @$pb.TagNumber(2)
  void clearStateFilter() => $_clearField(2);

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

class ListQueueResponse extends $pb.GeneratedMessage {
  factory ListQueueResponse({
    $core.Iterable<PublishItem>? items,
    $core.Iterable<PublishJob>? jobs,
    $2.PaginatedResponse? pagination,
  }) {
    final result = ListQueueResponse._();
    if (items != null) result.items.addAll(items);
    if (jobs != null) result.jobs.addAll(jobs);
    if (pagination != null) result.pagination = pagination;
    return result;
  }

  ListQueueResponse._();

  factory ListQueueResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListQueueResponse()..mergeFromBuffer(data, registry);
  factory ListQueueResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListQueueResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListQueueResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.publish.v1'),
      createEmptyInstance: ListQueueResponse.$_createMessage)
    ..pPM<PublishItem>(1, _omitFieldNames ? '' : 'items',
        subBuilder: PublishItem.$_createMessage)
    ..pPM<PublishJob>(2, _omitFieldNames ? '' : 'jobs',
        subBuilder: PublishJob.$_createMessage)
    ..aOM<$2.PaginatedResponse>(3, _omitFieldNames ? '' : 'pagination',
        subBuilder: $2.PaginatedResponse.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListQueueResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListQueueResponse copyWith(void Function(ListQueueResponse) updates) =>
      super.copyWith((message) => updates(message as ListQueueResponse))
          as ListQueueResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ListQueueResponse() / ListQueueResponse.new instead')
  static ListQueueResponse create() => ListQueueResponse._();
  static $pb.GeneratedMessage $_createMessage() => ListQueueResponse._();
  @$core.override
  ListQueueResponse createEmptyInstance() => ListQueueResponse._();
  @$core.pragma('dart2js:noInline')
  static ListQueueResponse getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ListQueueResponse>(
          ListQueueResponse.$_createMessage);
  static ListQueueResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<PublishItem> get items => $_getList(0);

  @$pb.TagNumber(2)
  $pb.PbList<PublishJob> get jobs => $_getList(1);

  @$pb.TagNumber(3)
  $2.PaginatedResponse get pagination => $_getN(2);
  @$pb.TagNumber(3)
  set pagination($2.PaginatedResponse value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasPagination() => $_has(2);
  @$pb.TagNumber(3)
  void clearPagination() => $_clearField(3);
  @$pb.TagNumber(3)
  $2.PaginatedResponse ensurePagination() => $_ensure(2);
}

/// GetLogsRequest / Response
class GetLogsRequest extends $pb.GeneratedMessage {
  factory GetLogsRequest({
    $core.String? publishItemId,
    $2.Pagination? pagination,
  }) {
    final result = GetLogsRequest._();
    if (publishItemId != null) result.publishItemId = publishItemId;
    if (pagination != null) result.pagination = pagination;
    return result;
  }

  GetLogsRequest._();

  factory GetLogsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetLogsRequest()..mergeFromBuffer(data, registry);
  factory GetLogsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetLogsRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetLogsRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.publish.v1'),
      createEmptyInstance: GetLogsRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'publishItemId')
    ..aOM<$2.Pagination>(2, _omitFieldNames ? '' : 'pagination',
        subBuilder: $2.Pagination.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetLogsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetLogsRequest copyWith(void Function(GetLogsRequest) updates) =>
      super.copyWith((message) => updates(message as GetLogsRequest))
          as GetLogsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use GetLogsRequest() / GetLogsRequest.new instead')
  static GetLogsRequest create() => GetLogsRequest._();
  static $pb.GeneratedMessage $_createMessage() => GetLogsRequest._();
  @$core.override
  GetLogsRequest createEmptyInstance() => GetLogsRequest._();
  @$core.pragma('dart2js:noInline')
  static GetLogsRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetLogsRequest>(
          GetLogsRequest.$_createMessage);
  static GetLogsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get publishItemId => $_getSZ(0);
  @$pb.TagNumber(1)
  set publishItemId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPublishItemId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPublishItemId() => $_clearField(1);

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

class GetLogsResponse extends $pb.GeneratedMessage {
  factory GetLogsResponse({
    $core.Iterable<PublishLog>? logs,
    $2.PaginatedResponse? pagination,
  }) {
    final result = GetLogsResponse._();
    if (logs != null) result.logs.addAll(logs);
    if (pagination != null) result.pagination = pagination;
    return result;
  }

  GetLogsResponse._();

  factory GetLogsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetLogsResponse()..mergeFromBuffer(data, registry);
  factory GetLogsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetLogsResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetLogsResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.publish.v1'),
      createEmptyInstance: GetLogsResponse.$_createMessage)
    ..pPM<PublishLog>(1, _omitFieldNames ? '' : 'logs',
        subBuilder: PublishLog.$_createMessage)
    ..aOM<$2.PaginatedResponse>(2, _omitFieldNames ? '' : 'pagination',
        subBuilder: $2.PaginatedResponse.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetLogsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetLogsResponse copyWith(void Function(GetLogsResponse) updates) =>
      super.copyWith((message) => updates(message as GetLogsResponse))
          as GetLogsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use GetLogsResponse() / GetLogsResponse.new instead')
  static GetLogsResponse create() => GetLogsResponse._();
  static $pb.GeneratedMessage $_createMessage() => GetLogsResponse._();
  @$core.override
  GetLogsResponse createEmptyInstance() => GetLogsResponse._();
  @$core.pragma('dart2js:noInline')
  static GetLogsResponse getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetLogsResponse>(
          GetLogsResponse.$_createMessage);
  static GetLogsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<PublishLog> get logs => $_getList(0);

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

/// GetDiagnosticsRequest / Response
class GetDiagnosticsRequest extends $pb.GeneratedMessage {
  factory GetDiagnosticsRequest({
    $core.String? publishItemId,
  }) {
    final result = GetDiagnosticsRequest._();
    if (publishItemId != null) result.publishItemId = publishItemId;
    return result;
  }

  GetDiagnosticsRequest._();

  factory GetDiagnosticsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetDiagnosticsRequest()..mergeFromBuffer(data, registry);
  factory GetDiagnosticsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetDiagnosticsRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetDiagnosticsRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.publish.v1'),
      createEmptyInstance: GetDiagnosticsRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'publishItemId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetDiagnosticsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetDiagnosticsRequest copyWith(
          void Function(GetDiagnosticsRequest) updates) =>
      super.copyWith((message) => updates(message as GetDiagnosticsRequest))
          as GetDiagnosticsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use GetDiagnosticsRequest() / GetDiagnosticsRequest.new instead')
  static GetDiagnosticsRequest create() => GetDiagnosticsRequest._();
  static $pb.GeneratedMessage $_createMessage() => GetDiagnosticsRequest._();
  @$core.override
  GetDiagnosticsRequest createEmptyInstance() => GetDiagnosticsRequest._();
  @$core.pragma('dart2js:noInline')
  static GetDiagnosticsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetDiagnosticsRequest>(
          GetDiagnosticsRequest.$_createMessage);
  static GetDiagnosticsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get publishItemId => $_getSZ(0);
  @$pb.TagNumber(1)
  set publishItemId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPublishItemId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPublishItemId() => $_clearField(1);
}

class GetDiagnosticsResponse extends $pb.GeneratedMessage {
  factory GetDiagnosticsResponse({
    $core.String? publishItemId,
    DiagnosticsState? diagnosticsState,
    $core.String? errorCode,
    $core.String? errorMessage,
    $core.String? repairRecommendation,
    $core.bool? canReconnect,
    $core.bool? canManualFallback,
    $core.bool? canRetry,
    PlatformCapabilitySummary? capabilitySummary,
  }) {
    final result = GetDiagnosticsResponse._();
    if (publishItemId != null) result.publishItemId = publishItemId;
    if (diagnosticsState != null) result.diagnosticsState = diagnosticsState;
    if (errorCode != null) result.errorCode = errorCode;
    if (errorMessage != null) result.errorMessage = errorMessage;
    if (repairRecommendation != null)
      result.repairRecommendation = repairRecommendation;
    if (canReconnect != null) result.canReconnect = canReconnect;
    if (canManualFallback != null) result.canManualFallback = canManualFallback;
    if (canRetry != null) result.canRetry = canRetry;
    if (capabilitySummary != null) result.capabilitySummary = capabilitySummary;
    return result;
  }

  GetDiagnosticsResponse._();

  factory GetDiagnosticsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetDiagnosticsResponse()..mergeFromBuffer(data, registry);
  factory GetDiagnosticsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetDiagnosticsResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetDiagnosticsResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.publish.v1'),
      createEmptyInstance: GetDiagnosticsResponse.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'publishItemId')
    ..aE<DiagnosticsState>(2, _omitFieldNames ? '' : 'diagnosticsState',
        enumValues: DiagnosticsState.values)
    ..aOS(3, _omitFieldNames ? '' : 'errorCode')
    ..aOS(4, _omitFieldNames ? '' : 'errorMessage')
    ..aOS(5, _omitFieldNames ? '' : 'repairRecommendation')
    ..aOB(6, _omitFieldNames ? '' : 'canReconnect')
    ..aOB(7, _omitFieldNames ? '' : 'canManualFallback')
    ..aOB(8, _omitFieldNames ? '' : 'canRetry')
    ..aOM<PlatformCapabilitySummary>(
        9, _omitFieldNames ? '' : 'capabilitySummary',
        subBuilder: PlatformCapabilitySummary.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetDiagnosticsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetDiagnosticsResponse copyWith(
          void Function(GetDiagnosticsResponse) updates) =>
      super.copyWith((message) => updates(message as GetDiagnosticsResponse))
          as GetDiagnosticsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use GetDiagnosticsResponse() / GetDiagnosticsResponse.new instead')
  static GetDiagnosticsResponse create() => GetDiagnosticsResponse._();
  static $pb.GeneratedMessage $_createMessage() => GetDiagnosticsResponse._();
  @$core.override
  GetDiagnosticsResponse createEmptyInstance() => GetDiagnosticsResponse._();
  @$core.pragma('dart2js:noInline')
  static GetDiagnosticsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetDiagnosticsResponse>(
          GetDiagnosticsResponse.$_createMessage);
  static GetDiagnosticsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get publishItemId => $_getSZ(0);
  @$pb.TagNumber(1)
  set publishItemId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPublishItemId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPublishItemId() => $_clearField(1);

  @$pb.TagNumber(2)
  DiagnosticsState get diagnosticsState => $_getN(1);
  @$pb.TagNumber(2)
  set diagnosticsState(DiagnosticsState value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasDiagnosticsState() => $_has(1);
  @$pb.TagNumber(2)
  void clearDiagnosticsState() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get errorCode => $_getSZ(2);
  @$pb.TagNumber(3)
  set errorCode($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasErrorCode() => $_has(2);
  @$pb.TagNumber(3)
  void clearErrorCode() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get errorMessage => $_getSZ(3);
  @$pb.TagNumber(4)
  set errorMessage($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasErrorMessage() => $_has(3);
  @$pb.TagNumber(4)
  void clearErrorMessage() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get repairRecommendation => $_getSZ(4);
  @$pb.TagNumber(5)
  set repairRecommendation($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasRepairRecommendation() => $_has(4);
  @$pb.TagNumber(5)
  void clearRepairRecommendation() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.bool get canReconnect => $_getBF(5);
  @$pb.TagNumber(6)
  set canReconnect($core.bool value) => $_setBool(5, value);
  @$pb.TagNumber(6)
  $core.bool hasCanReconnect() => $_has(5);
  @$pb.TagNumber(6)
  void clearCanReconnect() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.bool get canManualFallback => $_getBF(6);
  @$pb.TagNumber(7)
  set canManualFallback($core.bool value) => $_setBool(6, value);
  @$pb.TagNumber(7)
  $core.bool hasCanManualFallback() => $_has(6);
  @$pb.TagNumber(7)
  void clearCanManualFallback() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.bool get canRetry => $_getBF(7);
  @$pb.TagNumber(8)
  set canRetry($core.bool value) => $_setBool(7, value);
  @$pb.TagNumber(8)
  $core.bool hasCanRetry() => $_has(7);
  @$pb.TagNumber(8)
  void clearCanRetry() => $_clearField(8);

  @$pb.TagNumber(9)
  PlatformCapabilitySummary get capabilitySummary => $_getN(8);
  @$pb.TagNumber(9)
  set capabilitySummary(PlatformCapabilitySummary value) =>
      $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasCapabilitySummary() => $_has(8);
  @$pb.TagNumber(9)
  void clearCapabilitySummary() => $_clearField(9);
  @$pb.TagNumber(9)
  PlatformCapabilitySummary ensureCapabilitySummary() => $_ensure(8);
}

/// SubmitManualProofRequest / Response (RULE-M11-004, Acceptance Target 3)
class SubmitManualProofRequest extends $pb.GeneratedMessage {
  factory SubmitManualProofRequest({
    $2.CommandContext? context,
    $core.String? publishItemId,
    $core.String? evidenceUrl,
    $core.String? externalPostUrl,
    $core.String? notes,
  }) {
    final result = SubmitManualProofRequest._();
    if (context != null) result.context = context;
    if (publishItemId != null) result.publishItemId = publishItemId;
    if (evidenceUrl != null) result.evidenceUrl = evidenceUrl;
    if (externalPostUrl != null) result.externalPostUrl = externalPostUrl;
    if (notes != null) result.notes = notes;
    return result;
  }

  SubmitManualProofRequest._();

  factory SubmitManualProofRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SubmitManualProofRequest()..mergeFromBuffer(data, registry);
  factory SubmitManualProofRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SubmitManualProofRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SubmitManualProofRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.publish.v1'),
      createEmptyInstance: SubmitManualProofRequest.$_createMessage)
    ..aOM<$2.CommandContext>(1, _omitFieldNames ? '' : 'context',
        subBuilder: $2.CommandContext.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'publishItemId')
    ..aOS(3, _omitFieldNames ? '' : 'evidenceUrl')
    ..aOS(4, _omitFieldNames ? '' : 'externalPostUrl')
    ..aOS(5, _omitFieldNames ? '' : 'notes')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SubmitManualProofRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SubmitManualProofRequest copyWith(
          void Function(SubmitManualProofRequest) updates) =>
      super.copyWith((message) => updates(message as SubmitManualProofRequest))
          as SubmitManualProofRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use SubmitManualProofRequest() / SubmitManualProofRequest.new instead')
  static SubmitManualProofRequest create() => SubmitManualProofRequest._();
  static $pb.GeneratedMessage $_createMessage() => SubmitManualProofRequest._();
  @$core.override
  SubmitManualProofRequest createEmptyInstance() =>
      SubmitManualProofRequest._();
  @$core.pragma('dart2js:noInline')
  static SubmitManualProofRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SubmitManualProofRequest>(
          SubmitManualProofRequest.$_createMessage);
  static SubmitManualProofRequest? _defaultInstance;

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
  $core.String get publishItemId => $_getSZ(1);
  @$pb.TagNumber(2)
  set publishItemId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPublishItemId() => $_has(1);
  @$pb.TagNumber(2)
  void clearPublishItemId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get evidenceUrl => $_getSZ(2);
  @$pb.TagNumber(3)
  set evidenceUrl($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasEvidenceUrl() => $_has(2);
  @$pb.TagNumber(3)
  void clearEvidenceUrl() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get externalPostUrl => $_getSZ(3);
  @$pb.TagNumber(4)
  set externalPostUrl($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasExternalPostUrl() => $_has(3);
  @$pb.TagNumber(4)
  void clearExternalPostUrl() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get notes => $_getSZ(4);
  @$pb.TagNumber(5)
  set notes($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasNotes() => $_has(4);
  @$pb.TagNumber(5)
  void clearNotes() => $_clearField(5);
}

class SubmitManualProofResponse extends $pb.GeneratedMessage {
  factory SubmitManualProofResponse({
    PublishItem? item,
    PublishLog? log,
    ChannelPost? channelPost,
    $core.bool? graphRetained,
  }) {
    final result = SubmitManualProofResponse._();
    if (item != null) result.item = item;
    if (log != null) result.log = log;
    if (channelPost != null) result.channelPost = channelPost;
    if (graphRetained != null) result.graphRetained = graphRetained;
    return result;
  }

  SubmitManualProofResponse._();

  factory SubmitManualProofResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SubmitManualProofResponse()..mergeFromBuffer(data, registry);
  factory SubmitManualProofResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SubmitManualProofResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SubmitManualProofResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.publish.v1'),
      createEmptyInstance: SubmitManualProofResponse.$_createMessage)
    ..aOM<PublishItem>(1, _omitFieldNames ? '' : 'item',
        subBuilder: PublishItem.$_createMessage)
    ..aOM<PublishLog>(2, _omitFieldNames ? '' : 'log',
        subBuilder: PublishLog.$_createMessage)
    ..aOM<ChannelPost>(3, _omitFieldNames ? '' : 'channelPost',
        subBuilder: ChannelPost.$_createMessage)
    ..aOB(4, _omitFieldNames ? '' : 'graphRetained')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SubmitManualProofResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SubmitManualProofResponse copyWith(
          void Function(SubmitManualProofResponse) updates) =>
      super.copyWith((message) => updates(message as SubmitManualProofResponse))
          as SubmitManualProofResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use SubmitManualProofResponse() / SubmitManualProofResponse.new instead')
  static SubmitManualProofResponse create() => SubmitManualProofResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      SubmitManualProofResponse._();
  @$core.override
  SubmitManualProofResponse createEmptyInstance() =>
      SubmitManualProofResponse._();
  @$core.pragma('dart2js:noInline')
  static SubmitManualProofResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SubmitManualProofResponse>(
          SubmitManualProofResponse.$_createMessage);
  static SubmitManualProofResponse? _defaultInstance;

  @$pb.TagNumber(1)
  PublishItem get item => $_getN(0);
  @$pb.TagNumber(1)
  set item(PublishItem value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasItem() => $_has(0);
  @$pb.TagNumber(1)
  void clearItem() => $_clearField(1);
  @$pb.TagNumber(1)
  PublishItem ensureItem() => $_ensure(0);

  @$pb.TagNumber(2)
  PublishLog get log => $_getN(1);
  @$pb.TagNumber(2)
  set log(PublishLog value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasLog() => $_has(1);
  @$pb.TagNumber(2)
  void clearLog() => $_clearField(2);
  @$pb.TagNumber(2)
  PublishLog ensureLog() => $_ensure(1);

  @$pb.TagNumber(3)
  ChannelPost get channelPost => $_getN(2);
  @$pb.TagNumber(3)
  set channelPost(ChannelPost value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasChannelPost() => $_has(2);
  @$pb.TagNumber(3)
  void clearChannelPost() => $_clearField(3);
  @$pb.TagNumber(3)
  ChannelPost ensureChannelPost() => $_ensure(2);

  @$pb.TagNumber(4)
  $core.bool get graphRetained => $_getBF(3);
  @$pb.TagNumber(4)
  set graphRetained($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(4)
  $core.bool hasGraphRetained() => $_has(3);
  @$pb.TagNumber(4)
  void clearGraphRetained() => $_clearField(4);
}

/// ReconcilePublishRequest / Response (Acceptance Target 2)
class ReconcilePublishRequest extends $pb.GeneratedMessage {
  factory ReconcilePublishRequest({
    $2.CommandContext? context,
    $core.String? publishItemId,
    $core.String? publishJobId,
    $core.String? providerRequestId,
  }) {
    final result = ReconcilePublishRequest._();
    if (context != null) result.context = context;
    if (publishItemId != null) result.publishItemId = publishItemId;
    if (publishJobId != null) result.publishJobId = publishJobId;
    if (providerRequestId != null) result.providerRequestId = providerRequestId;
    return result;
  }

  ReconcilePublishRequest._();

  factory ReconcilePublishRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ReconcilePublishRequest()..mergeFromBuffer(data, registry);
  factory ReconcilePublishRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ReconcilePublishRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ReconcilePublishRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.publish.v1'),
      createEmptyInstance: ReconcilePublishRequest.$_createMessage)
    ..aOM<$2.CommandContext>(1, _omitFieldNames ? '' : 'context',
        subBuilder: $2.CommandContext.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'publishItemId')
    ..aOS(3, _omitFieldNames ? '' : 'publishJobId')
    ..aOS(4, _omitFieldNames ? '' : 'providerRequestId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReconcilePublishRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReconcilePublishRequest copyWith(
          void Function(ReconcilePublishRequest) updates) =>
      super.copyWith((message) => updates(message as ReconcilePublishRequest))
          as ReconcilePublishRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ReconcilePublishRequest() / ReconcilePublishRequest.new instead')
  static ReconcilePublishRequest create() => ReconcilePublishRequest._();
  static $pb.GeneratedMessage $_createMessage() => ReconcilePublishRequest._();
  @$core.override
  ReconcilePublishRequest createEmptyInstance() => ReconcilePublishRequest._();
  @$core.pragma('dart2js:noInline')
  static ReconcilePublishRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ReconcilePublishRequest>(
          ReconcilePublishRequest.$_createMessage);
  static ReconcilePublishRequest? _defaultInstance;

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
  $core.String get publishItemId => $_getSZ(1);
  @$pb.TagNumber(2)
  set publishItemId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPublishItemId() => $_has(1);
  @$pb.TagNumber(2)
  void clearPublishItemId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get publishJobId => $_getSZ(2);
  @$pb.TagNumber(3)
  set publishJobId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPublishJobId() => $_has(2);
  @$pb.TagNumber(3)
  void clearPublishJobId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get providerRequestId => $_getSZ(3);
  @$pb.TagNumber(4)
  set providerRequestId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasProviderRequestId() => $_has(3);
  @$pb.TagNumber(4)
  void clearProviderRequestId() => $_clearField(4);
}

class ReconcilePublishResponse extends $pb.GeneratedMessage {
  factory ReconcilePublishResponse({
    PublishItem? item,
    PublishJob? job,
    PublishLog? log,
    $core.bool? reconciled,
    $core.String? reconciliationOutcome,
  }) {
    final result = ReconcilePublishResponse._();
    if (item != null) result.item = item;
    if (job != null) result.job = job;
    if (log != null) result.log = log;
    if (reconciled != null) result.reconciled = reconciled;
    if (reconciliationOutcome != null)
      result.reconciliationOutcome = reconciliationOutcome;
    return result;
  }

  ReconcilePublishResponse._();

  factory ReconcilePublishResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ReconcilePublishResponse()..mergeFromBuffer(data, registry);
  factory ReconcilePublishResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ReconcilePublishResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ReconcilePublishResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.publish.v1'),
      createEmptyInstance: ReconcilePublishResponse.$_createMessage)
    ..aOM<PublishItem>(1, _omitFieldNames ? '' : 'item',
        subBuilder: PublishItem.$_createMessage)
    ..aOM<PublishJob>(2, _omitFieldNames ? '' : 'job',
        subBuilder: PublishJob.$_createMessage)
    ..aOM<PublishLog>(3, _omitFieldNames ? '' : 'log',
        subBuilder: PublishLog.$_createMessage)
    ..aOB(4, _omitFieldNames ? '' : 'reconciled')
    ..aOS(5, _omitFieldNames ? '' : 'reconciliationOutcome')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReconcilePublishResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReconcilePublishResponse copyWith(
          void Function(ReconcilePublishResponse) updates) =>
      super.copyWith((message) => updates(message as ReconcilePublishResponse))
          as ReconcilePublishResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ReconcilePublishResponse() / ReconcilePublishResponse.new instead')
  static ReconcilePublishResponse create() => ReconcilePublishResponse._();
  static $pb.GeneratedMessage $_createMessage() => ReconcilePublishResponse._();
  @$core.override
  ReconcilePublishResponse createEmptyInstance() =>
      ReconcilePublishResponse._();
  @$core.pragma('dart2js:noInline')
  static ReconcilePublishResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ReconcilePublishResponse>(
          ReconcilePublishResponse.$_createMessage);
  static ReconcilePublishResponse? _defaultInstance;

  @$pb.TagNumber(1)
  PublishItem get item => $_getN(0);
  @$pb.TagNumber(1)
  set item(PublishItem value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasItem() => $_has(0);
  @$pb.TagNumber(1)
  void clearItem() => $_clearField(1);
  @$pb.TagNumber(1)
  PublishItem ensureItem() => $_ensure(0);

  @$pb.TagNumber(2)
  PublishJob get job => $_getN(1);
  @$pb.TagNumber(2)
  set job(PublishJob value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasJob() => $_has(1);
  @$pb.TagNumber(2)
  void clearJob() => $_clearField(2);
  @$pb.TagNumber(2)
  PublishJob ensureJob() => $_ensure(1);

  @$pb.TagNumber(3)
  PublishLog get log => $_getN(2);
  @$pb.TagNumber(3)
  set log(PublishLog value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasLog() => $_has(2);
  @$pb.TagNumber(3)
  void clearLog() => $_clearField(3);
  @$pb.TagNumber(3)
  PublishLog ensureLog() => $_ensure(2);

  @$pb.TagNumber(4)
  $core.bool get reconciled => $_getBF(3);
  @$pb.TagNumber(4)
  set reconciled($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(4)
  $core.bool hasReconciled() => $_has(3);
  @$pb.TagNumber(4)
  void clearReconciled() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get reconciliationOutcome => $_getSZ(4);
  @$pb.TagNumber(5)
  set reconciliationOutcome($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasReconciliationOutcome() => $_has(4);
  @$pb.TagNumber(5)
  void clearReconciliationOutcome() => $_clearField(5);
}

/// ExportManualPackageRequest / Response
class ExportManualPackageRequest extends $pb.GeneratedMessage {
  factory ExportManualPackageRequest({
    $core.String? publishItemId,
  }) {
    final result = ExportManualPackageRequest._();
    if (publishItemId != null) result.publishItemId = publishItemId;
    return result;
  }

  ExportManualPackageRequest._();

  factory ExportManualPackageRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ExportManualPackageRequest()..mergeFromBuffer(data, registry);
  factory ExportManualPackageRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ExportManualPackageRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ExportManualPackageRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.publish.v1'),
      createEmptyInstance: ExportManualPackageRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'publishItemId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ExportManualPackageRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ExportManualPackageRequest copyWith(
          void Function(ExportManualPackageRequest) updates) =>
      super.copyWith(
              (message) => updates(message as ExportManualPackageRequest))
          as ExportManualPackageRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ExportManualPackageRequest() / ExportManualPackageRequest.new instead')
  static ExportManualPackageRequest create() => ExportManualPackageRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      ExportManualPackageRequest._();
  @$core.override
  ExportManualPackageRequest createEmptyInstance() =>
      ExportManualPackageRequest._();
  @$core.pragma('dart2js:noInline')
  static ExportManualPackageRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ExportManualPackageRequest>(
          ExportManualPackageRequest.$_createMessage);
  static ExportManualPackageRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get publishItemId => $_getSZ(0);
  @$pb.TagNumber(1)
  set publishItemId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPublishItemId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPublishItemId() => $_clearField(1);
}

class ExportManualPackageResponse extends $pb.GeneratedMessage {
  factory ExportManualPackageResponse({
    ManualExportPackage? package,
  }) {
    final result = ExportManualPackageResponse._();
    if (package != null) result.package = package;
    return result;
  }

  ExportManualPackageResponse._();

  factory ExportManualPackageResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ExportManualPackageResponse()..mergeFromBuffer(data, registry);
  factory ExportManualPackageResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ExportManualPackageResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ExportManualPackageResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.publish.v1'),
      createEmptyInstance: ExportManualPackageResponse.$_createMessage)
    ..aOM<ManualExportPackage>(1, _omitFieldNames ? '' : 'package',
        subBuilder: ManualExportPackage.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ExportManualPackageResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ExportManualPackageResponse copyWith(
          void Function(ExportManualPackageResponse) updates) =>
      super.copyWith(
              (message) => updates(message as ExportManualPackageResponse))
          as ExportManualPackageResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ExportManualPackageResponse() / ExportManualPackageResponse.new instead')
  static ExportManualPackageResponse create() =>
      ExportManualPackageResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      ExportManualPackageResponse._();
  @$core.override
  ExportManualPackageResponse createEmptyInstance() =>
      ExportManualPackageResponse._();
  @$core.pragma('dart2js:noInline')
  static ExportManualPackageResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ExportManualPackageResponse>(
          ExportManualPackageResponse.$_createMessage);
  static ExportManualPackageResponse? _defaultInstance;

  @$pb.TagNumber(1)
  ManualExportPackage get package => $_getN(0);
  @$pb.TagNumber(1)
  set package(ManualExportPackage value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasPackage() => $_has(0);
  @$pb.TagNumber(1)
  void clearPackage() => $_clearField(1);
  @$pb.TagNumber(1)
  ManualExportPackage ensurePackage() => $_ensure(0);
}

/// PauseQueueRequest / Response (Acceptance Target 4)
class PauseQueueRequest extends $pb.GeneratedMessage {
  factory PauseQueueRequest({
    $2.CommandContext? context,
    $core.String? connectedAccountId,
    $core.String? reason,
  }) {
    final result = PauseQueueRequest._();
    if (context != null) result.context = context;
    if (connectedAccountId != null)
      result.connectedAccountId = connectedAccountId;
    if (reason != null) result.reason = reason;
    return result;
  }

  PauseQueueRequest._();

  factory PauseQueueRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PauseQueueRequest()..mergeFromBuffer(data, registry);
  factory PauseQueueRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PauseQueueRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PauseQueueRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.publish.v1'),
      createEmptyInstance: PauseQueueRequest.$_createMessage)
    ..aOM<$2.CommandContext>(1, _omitFieldNames ? '' : 'context',
        subBuilder: $2.CommandContext.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'connectedAccountId')
    ..aOS(3, _omitFieldNames ? '' : 'reason')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PauseQueueRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PauseQueueRequest copyWith(void Function(PauseQueueRequest) updates) =>
      super.copyWith((message) => updates(message as PauseQueueRequest))
          as PauseQueueRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use PauseQueueRequest() / PauseQueueRequest.new instead')
  static PauseQueueRequest create() => PauseQueueRequest._();
  static $pb.GeneratedMessage $_createMessage() => PauseQueueRequest._();
  @$core.override
  PauseQueueRequest createEmptyInstance() => PauseQueueRequest._();
  @$core.pragma('dart2js:noInline')
  static PauseQueueRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PauseQueueRequest>(
          PauseQueueRequest.$_createMessage);
  static PauseQueueRequest? _defaultInstance;

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
  $core.String get connectedAccountId => $_getSZ(1);
  @$pb.TagNumber(2)
  set connectedAccountId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasConnectedAccountId() => $_has(1);
  @$pb.TagNumber(2)
  void clearConnectedAccountId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get reason => $_getSZ(2);
  @$pb.TagNumber(3)
  set reason($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasReason() => $_has(2);
  @$pb.TagNumber(3)
  void clearReason() => $_clearField(3);
}

class PauseQueueResponse extends $pb.GeneratedMessage {
  factory PauseQueueResponse({
    $core.int? pausedJobsCount,
    $core.Iterable<$core.String>? pausedPublishItemIds,
  }) {
    final result = PauseQueueResponse._();
    if (pausedJobsCount != null) result.pausedJobsCount = pausedJobsCount;
    if (pausedPublishItemIds != null)
      result.pausedPublishItemIds.addAll(pausedPublishItemIds);
    return result;
  }

  PauseQueueResponse._();

  factory PauseQueueResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PauseQueueResponse()..mergeFromBuffer(data, registry);
  factory PauseQueueResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PauseQueueResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PauseQueueResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.publish.v1'),
      createEmptyInstance: PauseQueueResponse.$_createMessage)
    ..aI(1, _omitFieldNames ? '' : 'pausedJobsCount')
    ..pPS(2, _omitFieldNames ? '' : 'pausedPublishItemIds')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PauseQueueResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PauseQueueResponse copyWith(void Function(PauseQueueResponse) updates) =>
      super.copyWith((message) => updates(message as PauseQueueResponse))
          as PauseQueueResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use PauseQueueResponse() / PauseQueueResponse.new instead')
  static PauseQueueResponse create() => PauseQueueResponse._();
  static $pb.GeneratedMessage $_createMessage() => PauseQueueResponse._();
  @$core.override
  PauseQueueResponse createEmptyInstance() => PauseQueueResponse._();
  @$core.pragma('dart2js:noInline')
  static PauseQueueResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PauseQueueResponse>(
          PauseQueueResponse.$_createMessage);
  static PauseQueueResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get pausedJobsCount => $_getIZ(0);
  @$pb.TagNumber(1)
  set pausedJobsCount($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPausedJobsCount() => $_has(0);
  @$pb.TagNumber(1)
  void clearPausedJobsCount() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbList<$core.String> get pausedPublishItemIds => $_getList(1);
}

/// Generic CRUD & Extended RPC Request/Response Types
class GetRequest extends $pb.GeneratedMessage {
  factory GetRequest({
    $core.String? publishItemId,
  }) {
    final result = GetRequest._();
    if (publishItemId != null) result.publishItemId = publishItemId;
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
          _omitMessageNames ? '' : 'creativanta.publish.v1'),
      createEmptyInstance: GetRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'publishItemId')
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
  $core.String get publishItemId => $_getSZ(0);
  @$pb.TagNumber(1)
  set publishItemId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPublishItemId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPublishItemId() => $_clearField(1);
}

class GetResponse extends $pb.GeneratedMessage {
  factory GetResponse({
    PublishItem? item,
    PlatformCapabilitySummary? capabilitySummary,
  }) {
    final result = GetResponse._();
    if (item != null) result.item = item;
    if (capabilitySummary != null) result.capabilitySummary = capabilitySummary;
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
          _omitMessageNames ? '' : 'creativanta.publish.v1'),
      createEmptyInstance: GetResponse.$_createMessage)
    ..aOM<PublishItem>(1, _omitFieldNames ? '' : 'item',
        subBuilder: PublishItem.$_createMessage)
    ..aOM<PlatformCapabilitySummary>(
        2, _omitFieldNames ? '' : 'capabilitySummary',
        subBuilder: PlatformCapabilitySummary.$_createMessage)
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
  PublishItem get item => $_getN(0);
  @$pb.TagNumber(1)
  set item(PublishItem value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasItem() => $_has(0);
  @$pb.TagNumber(1)
  void clearItem() => $_clearField(1);
  @$pb.TagNumber(1)
  PublishItem ensureItem() => $_ensure(0);

  @$pb.TagNumber(2)
  PlatformCapabilitySummary get capabilitySummary => $_getN(1);
  @$pb.TagNumber(2)
  set capabilitySummary(PlatformCapabilitySummary value) =>
      $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasCapabilitySummary() => $_has(1);
  @$pb.TagNumber(2)
  void clearCapabilitySummary() => $_clearField(2);
  @$pb.TagNumber(2)
  PlatformCapabilitySummary ensureCapabilitySummary() => $_ensure(1);
}

class ListRequest extends $pb.GeneratedMessage {
  factory ListRequest({
    $core.String? workspaceId,
    $2.Pagination? pagination,
  }) {
    final result = ListRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
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
          _omitMessageNames ? '' : 'creativanta.publish.v1'),
      createEmptyInstance: ListRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOM<$2.Pagination>(2, _omitFieldNames ? '' : 'pagination',
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
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

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

class ListResponse extends $pb.GeneratedMessage {
  factory ListResponse({
    $core.Iterable<PublishItem>? items,
    $2.PaginatedResponse? pagination,
  }) {
    final result = ListResponse._();
    if (items != null) result.items.addAll(items);
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
          _omitMessageNames ? '' : 'creativanta.publish.v1'),
      createEmptyInstance: ListResponse.$_createMessage)
    ..pPM<PublishItem>(1, _omitFieldNames ? '' : 'items',
        subBuilder: PublishItem.$_createMessage)
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
  $pb.PbList<PublishItem> get items => $_getList(0);

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

class GetDraftRequest extends $pb.GeneratedMessage {
  factory GetDraftRequest({
    $core.String? draftId,
  }) {
    final result = GetDraftRequest._();
    if (draftId != null) result.draftId = draftId;
    return result;
  }

  GetDraftRequest._();

  factory GetDraftRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetDraftRequest()..mergeFromBuffer(data, registry);
  factory GetDraftRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetDraftRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetDraftRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.publish.v1'),
      createEmptyInstance: GetDraftRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'draftId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetDraftRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetDraftRequest copyWith(void Function(GetDraftRequest) updates) =>
      super.copyWith((message) => updates(message as GetDraftRequest))
          as GetDraftRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use GetDraftRequest() / GetDraftRequest.new instead')
  static GetDraftRequest create() => GetDraftRequest._();
  static $pb.GeneratedMessage $_createMessage() => GetDraftRequest._();
  @$core.override
  GetDraftRequest createEmptyInstance() => GetDraftRequest._();
  @$core.pragma('dart2js:noInline')
  static GetDraftRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetDraftRequest>(
          GetDraftRequest.$_createMessage);
  static GetDraftRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get draftId => $_getSZ(0);
  @$pb.TagNumber(1)
  set draftId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasDraftId() => $_has(0);
  @$pb.TagNumber(1)
  void clearDraftId() => $_clearField(1);
}

class GetDraftResponse extends $pb.GeneratedMessage {
  factory GetDraftResponse({
    PublishItem? item,
  }) {
    final result = GetDraftResponse._();
    if (item != null) result.item = item;
    return result;
  }

  GetDraftResponse._();

  factory GetDraftResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetDraftResponse()..mergeFromBuffer(data, registry);
  factory GetDraftResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetDraftResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetDraftResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.publish.v1'),
      createEmptyInstance: GetDraftResponse.$_createMessage)
    ..aOM<PublishItem>(1, _omitFieldNames ? '' : 'item',
        subBuilder: PublishItem.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetDraftResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetDraftResponse copyWith(void Function(GetDraftResponse) updates) =>
      super.copyWith((message) => updates(message as GetDraftResponse))
          as GetDraftResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use GetDraftResponse() / GetDraftResponse.new instead')
  static GetDraftResponse create() => GetDraftResponse._();
  static $pb.GeneratedMessage $_createMessage() => GetDraftResponse._();
  @$core.override
  GetDraftResponse createEmptyInstance() => GetDraftResponse._();
  @$core.pragma('dart2js:noInline')
  static GetDraftResponse getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetDraftResponse>(
          GetDraftResponse.$_createMessage);
  static GetDraftResponse? _defaultInstance;

  @$pb.TagNumber(1)
  PublishItem get item => $_getN(0);
  @$pb.TagNumber(1)
  set item(PublishItem value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasItem() => $_has(0);
  @$pb.TagNumber(1)
  void clearItem() => $_clearField(1);
  @$pb.TagNumber(1)
  PublishItem ensureItem() => $_ensure(0);
}

class SaveDraftRequest extends $pb.GeneratedMessage {
  factory SaveDraftRequest({
    $2.CommandContext? context,
    PublishItem? item,
  }) {
    final result = SaveDraftRequest._();
    if (context != null) result.context = context;
    if (item != null) result.item = item;
    return result;
  }

  SaveDraftRequest._();

  factory SaveDraftRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SaveDraftRequest()..mergeFromBuffer(data, registry);
  factory SaveDraftRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SaveDraftRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SaveDraftRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.publish.v1'),
      createEmptyInstance: SaveDraftRequest.$_createMessage)
    ..aOM<$2.CommandContext>(1, _omitFieldNames ? '' : 'context',
        subBuilder: $2.CommandContext.$_createMessage)
    ..aOM<PublishItem>(2, _omitFieldNames ? '' : 'item',
        subBuilder: PublishItem.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SaveDraftRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SaveDraftRequest copyWith(void Function(SaveDraftRequest) updates) =>
      super.copyWith((message) => updates(message as SaveDraftRequest))
          as SaveDraftRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use SaveDraftRequest() / SaveDraftRequest.new instead')
  static SaveDraftRequest create() => SaveDraftRequest._();
  static $pb.GeneratedMessage $_createMessage() => SaveDraftRequest._();
  @$core.override
  SaveDraftRequest createEmptyInstance() => SaveDraftRequest._();
  @$core.pragma('dart2js:noInline')
  static SaveDraftRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SaveDraftRequest>(
          SaveDraftRequest.$_createMessage);
  static SaveDraftRequest? _defaultInstance;

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
  PublishItem get item => $_getN(1);
  @$pb.TagNumber(2)
  set item(PublishItem value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasItem() => $_has(1);
  @$pb.TagNumber(2)
  void clearItem() => $_clearField(2);
  @$pb.TagNumber(2)
  PublishItem ensureItem() => $_ensure(1);
}

class SaveDraftResponse extends $pb.GeneratedMessage {
  factory SaveDraftResponse({
    PublishItem? item,
  }) {
    final result = SaveDraftResponse._();
    if (item != null) result.item = item;
    return result;
  }

  SaveDraftResponse._();

  factory SaveDraftResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SaveDraftResponse()..mergeFromBuffer(data, registry);
  factory SaveDraftResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SaveDraftResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SaveDraftResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.publish.v1'),
      createEmptyInstance: SaveDraftResponse.$_createMessage)
    ..aOM<PublishItem>(1, _omitFieldNames ? '' : 'item',
        subBuilder: PublishItem.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SaveDraftResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SaveDraftResponse copyWith(void Function(SaveDraftResponse) updates) =>
      super.copyWith((message) => updates(message as SaveDraftResponse))
          as SaveDraftResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use SaveDraftResponse() / SaveDraftResponse.new instead')
  static SaveDraftResponse create() => SaveDraftResponse._();
  static $pb.GeneratedMessage $_createMessage() => SaveDraftResponse._();
  @$core.override
  SaveDraftResponse createEmptyInstance() => SaveDraftResponse._();
  @$core.pragma('dart2js:noInline')
  static SaveDraftResponse getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SaveDraftResponse>(
          SaveDraftResponse.$_createMessage);
  static SaveDraftResponse? _defaultInstance;

  @$pb.TagNumber(1)
  PublishItem get item => $_getN(0);
  @$pb.TagNumber(1)
  set item(PublishItem value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasItem() => $_has(0);
  @$pb.TagNumber(1)
  void clearItem() => $_clearField(1);
  @$pb.TagNumber(1)
  PublishItem ensureItem() => $_ensure(0);
}

class UpdateDraftRequest extends $pb.GeneratedMessage {
  factory UpdateDraftRequest({
    $2.CommandContext? context,
    $core.String? publishItemId,
    $core.String? title,
    $core.String? description,
    $core.Iterable<$core.String>? hashtags,
  }) {
    final result = UpdateDraftRequest._();
    if (context != null) result.context = context;
    if (publishItemId != null) result.publishItemId = publishItemId;
    if (title != null) result.title = title;
    if (description != null) result.description = description;
    if (hashtags != null) result.hashtags.addAll(hashtags);
    return result;
  }

  UpdateDraftRequest._();

  factory UpdateDraftRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      UpdateDraftRequest()..mergeFromBuffer(data, registry);
  factory UpdateDraftRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      UpdateDraftRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UpdateDraftRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.publish.v1'),
      createEmptyInstance: UpdateDraftRequest.$_createMessage)
    ..aOM<$2.CommandContext>(1, _omitFieldNames ? '' : 'context',
        subBuilder: $2.CommandContext.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'publishItemId')
    ..aOS(3, _omitFieldNames ? '' : 'title')
    ..aOS(4, _omitFieldNames ? '' : 'description')
    ..pPS(5, _omitFieldNames ? '' : 'hashtags')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateDraftRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateDraftRequest copyWith(void Function(UpdateDraftRequest) updates) =>
      super.copyWith((message) => updates(message as UpdateDraftRequest))
          as UpdateDraftRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use UpdateDraftRequest() / UpdateDraftRequest.new instead')
  static UpdateDraftRequest create() => UpdateDraftRequest._();
  static $pb.GeneratedMessage $_createMessage() => UpdateDraftRequest._();
  @$core.override
  UpdateDraftRequest createEmptyInstance() => UpdateDraftRequest._();
  @$core.pragma('dart2js:noInline')
  static UpdateDraftRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UpdateDraftRequest>(
          UpdateDraftRequest.$_createMessage);
  static UpdateDraftRequest? _defaultInstance;

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
  $core.String get publishItemId => $_getSZ(1);
  @$pb.TagNumber(2)
  set publishItemId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPublishItemId() => $_has(1);
  @$pb.TagNumber(2)
  void clearPublishItemId() => $_clearField(2);

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
  $pb.PbList<$core.String> get hashtags => $_getList(4);
}

class UpdateDraftResponse extends $pb.GeneratedMessage {
  factory UpdateDraftResponse({
    PublishItem? item,
  }) {
    final result = UpdateDraftResponse._();
    if (item != null) result.item = item;
    return result;
  }

  UpdateDraftResponse._();

  factory UpdateDraftResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      UpdateDraftResponse()..mergeFromBuffer(data, registry);
  factory UpdateDraftResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      UpdateDraftResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UpdateDraftResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.publish.v1'),
      createEmptyInstance: UpdateDraftResponse.$_createMessage)
    ..aOM<PublishItem>(1, _omitFieldNames ? '' : 'item',
        subBuilder: PublishItem.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateDraftResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateDraftResponse copyWith(void Function(UpdateDraftResponse) updates) =>
      super.copyWith((message) => updates(message as UpdateDraftResponse))
          as UpdateDraftResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core
      .Deprecated('Use UpdateDraftResponse() / UpdateDraftResponse.new instead')
  static UpdateDraftResponse create() => UpdateDraftResponse._();
  static $pb.GeneratedMessage $_createMessage() => UpdateDraftResponse._();
  @$core.override
  UpdateDraftResponse createEmptyInstance() => UpdateDraftResponse._();
  @$core.pragma('dart2js:noInline')
  static UpdateDraftResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UpdateDraftResponse>(
          UpdateDraftResponse.$_createMessage);
  static UpdateDraftResponse? _defaultInstance;

  @$pb.TagNumber(1)
  PublishItem get item => $_getN(0);
  @$pb.TagNumber(1)
  set item(PublishItem value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasItem() => $_has(0);
  @$pb.TagNumber(1)
  void clearItem() => $_clearField(1);
  @$pb.TagNumber(1)
  PublishItem ensureItem() => $_ensure(0);
}

class ListDraftsRequest extends $pb.GeneratedMessage {
  factory ListDraftsRequest({
    $core.String? workspaceId,
    $2.Pagination? pagination,
  }) {
    final result = ListDraftsRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (pagination != null) result.pagination = pagination;
    return result;
  }

  ListDraftsRequest._();

  factory ListDraftsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListDraftsRequest()..mergeFromBuffer(data, registry);
  factory ListDraftsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListDraftsRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListDraftsRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.publish.v1'),
      createEmptyInstance: ListDraftsRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOM<$2.Pagination>(2, _omitFieldNames ? '' : 'pagination',
        subBuilder: $2.Pagination.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListDraftsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListDraftsRequest copyWith(void Function(ListDraftsRequest) updates) =>
      super.copyWith((message) => updates(message as ListDraftsRequest))
          as ListDraftsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ListDraftsRequest() / ListDraftsRequest.new instead')
  static ListDraftsRequest create() => ListDraftsRequest._();
  static $pb.GeneratedMessage $_createMessage() => ListDraftsRequest._();
  @$core.override
  ListDraftsRequest createEmptyInstance() => ListDraftsRequest._();
  @$core.pragma('dart2js:noInline')
  static ListDraftsRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ListDraftsRequest>(
          ListDraftsRequest.$_createMessage);
  static ListDraftsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

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

class ListDraftsResponse extends $pb.GeneratedMessage {
  factory ListDraftsResponse({
    $core.Iterable<PublishItem>? drafts,
    $2.PaginatedResponse? pagination,
  }) {
    final result = ListDraftsResponse._();
    if (drafts != null) result.drafts.addAll(drafts);
    if (pagination != null) result.pagination = pagination;
    return result;
  }

  ListDraftsResponse._();

  factory ListDraftsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListDraftsResponse()..mergeFromBuffer(data, registry);
  factory ListDraftsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListDraftsResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListDraftsResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.publish.v1'),
      createEmptyInstance: ListDraftsResponse.$_createMessage)
    ..pPM<PublishItem>(1, _omitFieldNames ? '' : 'drafts',
        subBuilder: PublishItem.$_createMessage)
    ..aOM<$2.PaginatedResponse>(2, _omitFieldNames ? '' : 'pagination',
        subBuilder: $2.PaginatedResponse.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListDraftsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListDraftsResponse copyWith(void Function(ListDraftsResponse) updates) =>
      super.copyWith((message) => updates(message as ListDraftsResponse))
          as ListDraftsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ListDraftsResponse() / ListDraftsResponse.new instead')
  static ListDraftsResponse create() => ListDraftsResponse._();
  static $pb.GeneratedMessage $_createMessage() => ListDraftsResponse._();
  @$core.override
  ListDraftsResponse createEmptyInstance() => ListDraftsResponse._();
  @$core.pragma('dart2js:noInline')
  static ListDraftsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListDraftsResponse>(
          ListDraftsResponse.$_createMessage);
  static ListDraftsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<PublishItem> get drafts => $_getList(0);

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

class PublishNowRequest extends $pb.GeneratedMessage {
  factory PublishNowRequest({
    $2.CommandContext? context,
    $core.String? publishItemId,
  }) {
    final result = PublishNowRequest._();
    if (context != null) result.context = context;
    if (publishItemId != null) result.publishItemId = publishItemId;
    return result;
  }

  PublishNowRequest._();

  factory PublishNowRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PublishNowRequest()..mergeFromBuffer(data, registry);
  factory PublishNowRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PublishNowRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PublishNowRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.publish.v1'),
      createEmptyInstance: PublishNowRequest.$_createMessage)
    ..aOM<$2.CommandContext>(1, _omitFieldNames ? '' : 'context',
        subBuilder: $2.CommandContext.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'publishItemId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PublishNowRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PublishNowRequest copyWith(void Function(PublishNowRequest) updates) =>
      super.copyWith((message) => updates(message as PublishNowRequest))
          as PublishNowRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use PublishNowRequest() / PublishNowRequest.new instead')
  static PublishNowRequest create() => PublishNowRequest._();
  static $pb.GeneratedMessage $_createMessage() => PublishNowRequest._();
  @$core.override
  PublishNowRequest createEmptyInstance() => PublishNowRequest._();
  @$core.pragma('dart2js:noInline')
  static PublishNowRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PublishNowRequest>(
          PublishNowRequest.$_createMessage);
  static PublishNowRequest? _defaultInstance;

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
  $core.String get publishItemId => $_getSZ(1);
  @$pb.TagNumber(2)
  set publishItemId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPublishItemId() => $_has(1);
  @$pb.TagNumber(2)
  void clearPublishItemId() => $_clearField(2);
}

class PublishNowResponse extends $pb.GeneratedMessage {
  factory PublishNowResponse({
    PublishItem? item,
    PublishJob? job,
  }) {
    final result = PublishNowResponse._();
    if (item != null) result.item = item;
    if (job != null) result.job = job;
    return result;
  }

  PublishNowResponse._();

  factory PublishNowResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PublishNowResponse()..mergeFromBuffer(data, registry);
  factory PublishNowResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PublishNowResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PublishNowResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.publish.v1'),
      createEmptyInstance: PublishNowResponse.$_createMessage)
    ..aOM<PublishItem>(1, _omitFieldNames ? '' : 'item',
        subBuilder: PublishItem.$_createMessage)
    ..aOM<PublishJob>(2, _omitFieldNames ? '' : 'job',
        subBuilder: PublishJob.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PublishNowResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PublishNowResponse copyWith(void Function(PublishNowResponse) updates) =>
      super.copyWith((message) => updates(message as PublishNowResponse))
          as PublishNowResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use PublishNowResponse() / PublishNowResponse.new instead')
  static PublishNowResponse create() => PublishNowResponse._();
  static $pb.GeneratedMessage $_createMessage() => PublishNowResponse._();
  @$core.override
  PublishNowResponse createEmptyInstance() => PublishNowResponse._();
  @$core.pragma('dart2js:noInline')
  static PublishNowResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PublishNowResponse>(
          PublishNowResponse.$_createMessage);
  static PublishNowResponse? _defaultInstance;

  @$pb.TagNumber(1)
  PublishItem get item => $_getN(0);
  @$pb.TagNumber(1)
  set item(PublishItem value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasItem() => $_has(0);
  @$pb.TagNumber(1)
  void clearItem() => $_clearField(1);
  @$pb.TagNumber(1)
  PublishItem ensureItem() => $_ensure(0);

  @$pb.TagNumber(2)
  PublishJob get job => $_getN(1);
  @$pb.TagNumber(2)
  set job(PublishJob value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasJob() => $_has(1);
  @$pb.TagNumber(2)
  void clearJob() => $_clearField(2);
  @$pb.TagNumber(2)
  PublishJob ensureJob() => $_ensure(1);
}

class RescheduleRequest extends $pb.GeneratedMessage {
  factory RescheduleRequest({
    $2.CommandContext? context,
    $core.String? publishItemId,
    $1.Timestamp? newScheduleAt,
  }) {
    final result = RescheduleRequest._();
    if (context != null) result.context = context;
    if (publishItemId != null) result.publishItemId = publishItemId;
    if (newScheduleAt != null) result.newScheduleAt = newScheduleAt;
    return result;
  }

  RescheduleRequest._();

  factory RescheduleRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RescheduleRequest()..mergeFromBuffer(data, registry);
  factory RescheduleRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RescheduleRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RescheduleRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.publish.v1'),
      createEmptyInstance: RescheduleRequest.$_createMessage)
    ..aOM<$2.CommandContext>(1, _omitFieldNames ? '' : 'context',
        subBuilder: $2.CommandContext.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'publishItemId')
    ..aOM<$1.Timestamp>(3, _omitFieldNames ? '' : 'newScheduleAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RescheduleRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RescheduleRequest copyWith(void Function(RescheduleRequest) updates) =>
      super.copyWith((message) => updates(message as RescheduleRequest))
          as RescheduleRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use RescheduleRequest() / RescheduleRequest.new instead')
  static RescheduleRequest create() => RescheduleRequest._();
  static $pb.GeneratedMessage $_createMessage() => RescheduleRequest._();
  @$core.override
  RescheduleRequest createEmptyInstance() => RescheduleRequest._();
  @$core.pragma('dart2js:noInline')
  static RescheduleRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<RescheduleRequest>(
          RescheduleRequest.$_createMessage);
  static RescheduleRequest? _defaultInstance;

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
  $core.String get publishItemId => $_getSZ(1);
  @$pb.TagNumber(2)
  set publishItemId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPublishItemId() => $_has(1);
  @$pb.TagNumber(2)
  void clearPublishItemId() => $_clearField(2);

  @$pb.TagNumber(3)
  $1.Timestamp get newScheduleAt => $_getN(2);
  @$pb.TagNumber(3)
  set newScheduleAt($1.Timestamp value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasNewScheduleAt() => $_has(2);
  @$pb.TagNumber(3)
  void clearNewScheduleAt() => $_clearField(3);
  @$pb.TagNumber(3)
  $1.Timestamp ensureNewScheduleAt() => $_ensure(2);
}

class RescheduleResponse extends $pb.GeneratedMessage {
  factory RescheduleResponse({
    PublishItem? item,
  }) {
    final result = RescheduleResponse._();
    if (item != null) result.item = item;
    return result;
  }

  RescheduleResponse._();

  factory RescheduleResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RescheduleResponse()..mergeFromBuffer(data, registry);
  factory RescheduleResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RescheduleResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RescheduleResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.publish.v1'),
      createEmptyInstance: RescheduleResponse.$_createMessage)
    ..aOM<PublishItem>(1, _omitFieldNames ? '' : 'item',
        subBuilder: PublishItem.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RescheduleResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RescheduleResponse copyWith(void Function(RescheduleResponse) updates) =>
      super.copyWith((message) => updates(message as RescheduleResponse))
          as RescheduleResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use RescheduleResponse() / RescheduleResponse.new instead')
  static RescheduleResponse create() => RescheduleResponse._();
  static $pb.GeneratedMessage $_createMessage() => RescheduleResponse._();
  @$core.override
  RescheduleResponse createEmptyInstance() => RescheduleResponse._();
  @$core.pragma('dart2js:noInline')
  static RescheduleResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RescheduleResponse>(
          RescheduleResponse.$_createMessage);
  static RescheduleResponse? _defaultInstance;

  @$pb.TagNumber(1)
  PublishItem get item => $_getN(0);
  @$pb.TagNumber(1)
  set item(PublishItem value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasItem() => $_has(0);
  @$pb.TagNumber(1)
  void clearItem() => $_clearField(1);
  @$pb.TagNumber(1)
  PublishItem ensureItem() => $_ensure(0);
}

class DeleteRequest extends $pb.GeneratedMessage {
  factory DeleteRequest({
    $2.CommandContext? context,
    $core.String? publishItemId,
  }) {
    final result = DeleteRequest._();
    if (context != null) result.context = context;
    if (publishItemId != null) result.publishItemId = publishItemId;
    return result;
  }

  DeleteRequest._();

  factory DeleteRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      DeleteRequest()..mergeFromBuffer(data, registry);
  factory DeleteRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      DeleteRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DeleteRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.publish.v1'),
      createEmptyInstance: DeleteRequest.$_createMessage)
    ..aOM<$2.CommandContext>(1, _omitFieldNames ? '' : 'context',
        subBuilder: $2.CommandContext.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'publishItemId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteRequest copyWith(void Function(DeleteRequest) updates) =>
      super.copyWith((message) => updates(message as DeleteRequest))
          as DeleteRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use DeleteRequest() / DeleteRequest.new instead')
  static DeleteRequest create() => DeleteRequest._();
  static $pb.GeneratedMessage $_createMessage() => DeleteRequest._();
  @$core.override
  DeleteRequest createEmptyInstance() => DeleteRequest._();
  @$core.pragma('dart2js:noInline')
  static DeleteRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DeleteRequest>(
          DeleteRequest.$_createMessage);
  static DeleteRequest? _defaultInstance;

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
  $core.String get publishItemId => $_getSZ(1);
  @$pb.TagNumber(2)
  set publishItemId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPublishItemId() => $_has(1);
  @$pb.TagNumber(2)
  void clearPublishItemId() => $_clearField(2);
}

class DeleteResponse extends $pb.GeneratedMessage {
  factory DeleteResponse({
    $core.bool? deleted,
  }) {
    final result = DeleteResponse._();
    if (deleted != null) result.deleted = deleted;
    return result;
  }

  DeleteResponse._();

  factory DeleteResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      DeleteResponse()..mergeFromBuffer(data, registry);
  factory DeleteResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      DeleteResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DeleteResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.publish.v1'),
      createEmptyInstance: DeleteResponse.$_createMessage)
    ..aOB(1, _omitFieldNames ? '' : 'deleted')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteResponse copyWith(void Function(DeleteResponse) updates) =>
      super.copyWith((message) => updates(message as DeleteResponse))
          as DeleteResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use DeleteResponse() / DeleteResponse.new instead')
  static DeleteResponse create() => DeleteResponse._();
  static $pb.GeneratedMessage $_createMessage() => DeleteResponse._();
  @$core.override
  DeleteResponse createEmptyInstance() => DeleteResponse._();
  @$core.pragma('dart2js:noInline')
  static DeleteResponse getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DeleteResponse>(
          DeleteResponse.$_createMessage);
  static DeleteResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get deleted => $_getBF(0);
  @$pb.TagNumber(1)
  set deleted($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasDeleted() => $_has(0);
  @$pb.TagNumber(1)
  void clearDeleted() => $_clearField(1);
}

class DuplicateRequest extends $pb.GeneratedMessage {
  factory DuplicateRequest({
    $2.CommandContext? context,
    $core.String? publishItemId,
  }) {
    final result = DuplicateRequest._();
    if (context != null) result.context = context;
    if (publishItemId != null) result.publishItemId = publishItemId;
    return result;
  }

  DuplicateRequest._();

  factory DuplicateRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      DuplicateRequest()..mergeFromBuffer(data, registry);
  factory DuplicateRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      DuplicateRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DuplicateRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.publish.v1'),
      createEmptyInstance: DuplicateRequest.$_createMessage)
    ..aOM<$2.CommandContext>(1, _omitFieldNames ? '' : 'context',
        subBuilder: $2.CommandContext.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'publishItemId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DuplicateRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DuplicateRequest copyWith(void Function(DuplicateRequest) updates) =>
      super.copyWith((message) => updates(message as DuplicateRequest))
          as DuplicateRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use DuplicateRequest() / DuplicateRequest.new instead')
  static DuplicateRequest create() => DuplicateRequest._();
  static $pb.GeneratedMessage $_createMessage() => DuplicateRequest._();
  @$core.override
  DuplicateRequest createEmptyInstance() => DuplicateRequest._();
  @$core.pragma('dart2js:noInline')
  static DuplicateRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DuplicateRequest>(
          DuplicateRequest.$_createMessage);
  static DuplicateRequest? _defaultInstance;

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
  $core.String get publishItemId => $_getSZ(1);
  @$pb.TagNumber(2)
  set publishItemId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPublishItemId() => $_has(1);
  @$pb.TagNumber(2)
  void clearPublishItemId() => $_clearField(2);
}

class DuplicateResponse extends $pb.GeneratedMessage {
  factory DuplicateResponse({
    PublishItem? item,
  }) {
    final result = DuplicateResponse._();
    if (item != null) result.item = item;
    return result;
  }

  DuplicateResponse._();

  factory DuplicateResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      DuplicateResponse()..mergeFromBuffer(data, registry);
  factory DuplicateResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      DuplicateResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DuplicateResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.publish.v1'),
      createEmptyInstance: DuplicateResponse.$_createMessage)
    ..aOM<PublishItem>(1, _omitFieldNames ? '' : 'item',
        subBuilder: PublishItem.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DuplicateResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DuplicateResponse copyWith(void Function(DuplicateResponse) updates) =>
      super.copyWith((message) => updates(message as DuplicateResponse))
          as DuplicateResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use DuplicateResponse() / DuplicateResponse.new instead')
  static DuplicateResponse create() => DuplicateResponse._();
  static $pb.GeneratedMessage $_createMessage() => DuplicateResponse._();
  @$core.override
  DuplicateResponse createEmptyInstance() => DuplicateResponse._();
  @$core.pragma('dart2js:noInline')
  static DuplicateResponse getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DuplicateResponse>(
          DuplicateResponse.$_createMessage);
  static DuplicateResponse? _defaultInstance;

  @$pb.TagNumber(1)
  PublishItem get item => $_getN(0);
  @$pb.TagNumber(1)
  set item(PublishItem value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasItem() => $_has(0);
  @$pb.TagNumber(1)
  void clearItem() => $_clearField(1);
  @$pb.TagNumber(1)
  PublishItem ensureItem() => $_ensure(0);
}

class PauseRequest extends $pb.GeneratedMessage {
  factory PauseRequest({
    $2.CommandContext? context,
    $core.String? publishItemId,
  }) {
    final result = PauseRequest._();
    if (context != null) result.context = context;
    if (publishItemId != null) result.publishItemId = publishItemId;
    return result;
  }

  PauseRequest._();

  factory PauseRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PauseRequest()..mergeFromBuffer(data, registry);
  factory PauseRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PauseRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PauseRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.publish.v1'),
      createEmptyInstance: PauseRequest.$_createMessage)
    ..aOM<$2.CommandContext>(1, _omitFieldNames ? '' : 'context',
        subBuilder: $2.CommandContext.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'publishItemId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PauseRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PauseRequest copyWith(void Function(PauseRequest) updates) =>
      super.copyWith((message) => updates(message as PauseRequest))
          as PauseRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use PauseRequest() / PauseRequest.new instead')
  static PauseRequest create() => PauseRequest._();
  static $pb.GeneratedMessage $_createMessage() => PauseRequest._();
  @$core.override
  PauseRequest createEmptyInstance() => PauseRequest._();
  @$core.pragma('dart2js:noInline')
  static PauseRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PauseRequest>(
          PauseRequest.$_createMessage);
  static PauseRequest? _defaultInstance;

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
  $core.String get publishItemId => $_getSZ(1);
  @$pb.TagNumber(2)
  set publishItemId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPublishItemId() => $_has(1);
  @$pb.TagNumber(2)
  void clearPublishItemId() => $_clearField(2);
}

class PauseResponse extends $pb.GeneratedMessage {
  factory PauseResponse({
    PublishItem? item,
  }) {
    final result = PauseResponse._();
    if (item != null) result.item = item;
    return result;
  }

  PauseResponse._();

  factory PauseResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PauseResponse()..mergeFromBuffer(data, registry);
  factory PauseResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PauseResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PauseResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.publish.v1'),
      createEmptyInstance: PauseResponse.$_createMessage)
    ..aOM<PublishItem>(1, _omitFieldNames ? '' : 'item',
        subBuilder: PublishItem.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PauseResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PauseResponse copyWith(void Function(PauseResponse) updates) =>
      super.copyWith((message) => updates(message as PauseResponse))
          as PauseResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use PauseResponse() / PauseResponse.new instead')
  static PauseResponse create() => PauseResponse._();
  static $pb.GeneratedMessage $_createMessage() => PauseResponse._();
  @$core.override
  PauseResponse createEmptyInstance() => PauseResponse._();
  @$core.pragma('dart2js:noInline')
  static PauseResponse getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PauseResponse>(
          PauseResponse.$_createMessage);
  static PauseResponse? _defaultInstance;

  @$pb.TagNumber(1)
  PublishItem get item => $_getN(0);
  @$pb.TagNumber(1)
  set item(PublishItem value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasItem() => $_has(0);
  @$pb.TagNumber(1)
  void clearItem() => $_clearField(1);
  @$pb.TagNumber(1)
  PublishItem ensureItem() => $_ensure(0);
}

class CheckCompatibilityRequest extends $pb.GeneratedMessage {
  factory CheckCompatibilityRequest({
    $core.String? targetPlatform,
    $core.String? assetId,
    $core.String? targetAccountId,
  }) {
    final result = CheckCompatibilityRequest._();
    if (targetPlatform != null) result.targetPlatform = targetPlatform;
    if (assetId != null) result.assetId = assetId;
    if (targetAccountId != null) result.targetAccountId = targetAccountId;
    return result;
  }

  CheckCompatibilityRequest._();

  factory CheckCompatibilityRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CheckCompatibilityRequest()..mergeFromBuffer(data, registry);
  factory CheckCompatibilityRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CheckCompatibilityRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CheckCompatibilityRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.publish.v1'),
      createEmptyInstance: CheckCompatibilityRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'targetPlatform')
    ..aOS(2, _omitFieldNames ? '' : 'assetId')
    ..aOS(3, _omitFieldNames ? '' : 'targetAccountId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CheckCompatibilityRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CheckCompatibilityRequest copyWith(
          void Function(CheckCompatibilityRequest) updates) =>
      super.copyWith((message) => updates(message as CheckCompatibilityRequest))
          as CheckCompatibilityRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use CheckCompatibilityRequest() / CheckCompatibilityRequest.new instead')
  static CheckCompatibilityRequest create() => CheckCompatibilityRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      CheckCompatibilityRequest._();
  @$core.override
  CheckCompatibilityRequest createEmptyInstance() =>
      CheckCompatibilityRequest._();
  @$core.pragma('dart2js:noInline')
  static CheckCompatibilityRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CheckCompatibilityRequest>(
          CheckCompatibilityRequest.$_createMessage);
  static CheckCompatibilityRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get targetPlatform => $_getSZ(0);
  @$pb.TagNumber(1)
  set targetPlatform($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTargetPlatform() => $_has(0);
  @$pb.TagNumber(1)
  void clearTargetPlatform() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get assetId => $_getSZ(1);
  @$pb.TagNumber(2)
  set assetId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasAssetId() => $_has(1);
  @$pb.TagNumber(2)
  void clearAssetId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get targetAccountId => $_getSZ(2);
  @$pb.TagNumber(3)
  set targetAccountId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasTargetAccountId() => $_has(2);
  @$pb.TagNumber(3)
  void clearTargetAccountId() => $_clearField(3);
}

class CheckCompatibilityResponse extends $pb.GeneratedMessage {
  factory CheckCompatibilityResponse({
    PlatformCapabilitySummary? capabilitySummary,
    $core.bool? compatible,
    $core.Iterable<$core.String>? issues,
  }) {
    final result = CheckCompatibilityResponse._();
    if (capabilitySummary != null) result.capabilitySummary = capabilitySummary;
    if (compatible != null) result.compatible = compatible;
    if (issues != null) result.issues.addAll(issues);
    return result;
  }

  CheckCompatibilityResponse._();

  factory CheckCompatibilityResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CheckCompatibilityResponse()..mergeFromBuffer(data, registry);
  factory CheckCompatibilityResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CheckCompatibilityResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CheckCompatibilityResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.publish.v1'),
      createEmptyInstance: CheckCompatibilityResponse.$_createMessage)
    ..aOM<PlatformCapabilitySummary>(
        1, _omitFieldNames ? '' : 'capabilitySummary',
        subBuilder: PlatformCapabilitySummary.$_createMessage)
    ..aOB(2, _omitFieldNames ? '' : 'compatible')
    ..pPS(3, _omitFieldNames ? '' : 'issues')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CheckCompatibilityResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CheckCompatibilityResponse copyWith(
          void Function(CheckCompatibilityResponse) updates) =>
      super.copyWith(
              (message) => updates(message as CheckCompatibilityResponse))
          as CheckCompatibilityResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use CheckCompatibilityResponse() / CheckCompatibilityResponse.new instead')
  static CheckCompatibilityResponse create() => CheckCompatibilityResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      CheckCompatibilityResponse._();
  @$core.override
  CheckCompatibilityResponse createEmptyInstance() =>
      CheckCompatibilityResponse._();
  @$core.pragma('dart2js:noInline')
  static CheckCompatibilityResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CheckCompatibilityResponse>(
          CheckCompatibilityResponse.$_createMessage);
  static CheckCompatibilityResponse? _defaultInstance;

  @$pb.TagNumber(1)
  PlatformCapabilitySummary get capabilitySummary => $_getN(0);
  @$pb.TagNumber(1)
  set capabilitySummary(PlatformCapabilitySummary value) =>
      $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasCapabilitySummary() => $_has(0);
  @$pb.TagNumber(1)
  void clearCapabilitySummary() => $_clearField(1);
  @$pb.TagNumber(1)
  PlatformCapabilitySummary ensureCapabilitySummary() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.bool get compatible => $_getBF(1);
  @$pb.TagNumber(2)
  set compatible($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCompatible() => $_has(1);
  @$pb.TagNumber(2)
  void clearCompatible() => $_clearField(2);

  @$pb.TagNumber(3)
  $pb.PbList<$core.String> get issues => $_getList(2);
}

class UpdateMetadataRequest extends $pb.GeneratedMessage {
  factory UpdateMetadataRequest({
    $2.CommandContext? context,
    $core.String? publishItemId,
    $core.String? title,
    $core.String? description,
    $core.Iterable<$core.String>? hashtags,
  }) {
    final result = UpdateMetadataRequest._();
    if (context != null) result.context = context;
    if (publishItemId != null) result.publishItemId = publishItemId;
    if (title != null) result.title = title;
    if (description != null) result.description = description;
    if (hashtags != null) result.hashtags.addAll(hashtags);
    return result;
  }

  UpdateMetadataRequest._();

  factory UpdateMetadataRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      UpdateMetadataRequest()..mergeFromBuffer(data, registry);
  factory UpdateMetadataRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      UpdateMetadataRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UpdateMetadataRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.publish.v1'),
      createEmptyInstance: UpdateMetadataRequest.$_createMessage)
    ..aOM<$2.CommandContext>(1, _omitFieldNames ? '' : 'context',
        subBuilder: $2.CommandContext.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'publishItemId')
    ..aOS(3, _omitFieldNames ? '' : 'title')
    ..aOS(4, _omitFieldNames ? '' : 'description')
    ..pPS(5, _omitFieldNames ? '' : 'hashtags')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateMetadataRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateMetadataRequest copyWith(
          void Function(UpdateMetadataRequest) updates) =>
      super.copyWith((message) => updates(message as UpdateMetadataRequest))
          as UpdateMetadataRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use UpdateMetadataRequest() / UpdateMetadataRequest.new instead')
  static UpdateMetadataRequest create() => UpdateMetadataRequest._();
  static $pb.GeneratedMessage $_createMessage() => UpdateMetadataRequest._();
  @$core.override
  UpdateMetadataRequest createEmptyInstance() => UpdateMetadataRequest._();
  @$core.pragma('dart2js:noInline')
  static UpdateMetadataRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UpdateMetadataRequest>(
          UpdateMetadataRequest.$_createMessage);
  static UpdateMetadataRequest? _defaultInstance;

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
  $core.String get publishItemId => $_getSZ(1);
  @$pb.TagNumber(2)
  set publishItemId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPublishItemId() => $_has(1);
  @$pb.TagNumber(2)
  void clearPublishItemId() => $_clearField(2);

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
  $pb.PbList<$core.String> get hashtags => $_getList(4);
}

class UpdateMetadataResponse extends $pb.GeneratedMessage {
  factory UpdateMetadataResponse({
    PublishItem? item,
  }) {
    final result = UpdateMetadataResponse._();
    if (item != null) result.item = item;
    return result;
  }

  UpdateMetadataResponse._();

  factory UpdateMetadataResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      UpdateMetadataResponse()..mergeFromBuffer(data, registry);
  factory UpdateMetadataResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      UpdateMetadataResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UpdateMetadataResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.publish.v1'),
      createEmptyInstance: UpdateMetadataResponse.$_createMessage)
    ..aOM<PublishItem>(1, _omitFieldNames ? '' : 'item',
        subBuilder: PublishItem.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateMetadataResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateMetadataResponse copyWith(
          void Function(UpdateMetadataResponse) updates) =>
      super.copyWith((message) => updates(message as UpdateMetadataResponse))
          as UpdateMetadataResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use UpdateMetadataResponse() / UpdateMetadataResponse.new instead')
  static UpdateMetadataResponse create() => UpdateMetadataResponse._();
  static $pb.GeneratedMessage $_createMessage() => UpdateMetadataResponse._();
  @$core.override
  UpdateMetadataResponse createEmptyInstance() => UpdateMetadataResponse._();
  @$core.pragma('dart2js:noInline')
  static UpdateMetadataResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UpdateMetadataResponse>(
          UpdateMetadataResponse.$_createMessage);
  static UpdateMetadataResponse? _defaultInstance;

  @$pb.TagNumber(1)
  PublishItem get item => $_getN(0);
  @$pb.TagNumber(1)
  set item(PublishItem value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasItem() => $_has(0);
  @$pb.TagNumber(1)
  void clearItem() => $_clearField(1);
  @$pb.TagNumber(1)
  PublishItem ensureItem() => $_ensure(0);
}

class GetCalendarRequest extends $pb.GeneratedMessage {
  factory GetCalendarRequest({
    $core.String? workspaceId,
    $1.Timestamp? startDate,
    $1.Timestamp? endDate,
  }) {
    final result = GetCalendarRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (startDate != null) result.startDate = startDate;
    if (endDate != null) result.endDate = endDate;
    return result;
  }

  GetCalendarRequest._();

  factory GetCalendarRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetCalendarRequest()..mergeFromBuffer(data, registry);
  factory GetCalendarRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetCalendarRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetCalendarRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.publish.v1'),
      createEmptyInstance: GetCalendarRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOM<$1.Timestamp>(2, _omitFieldNames ? '' : 'startDate',
        subBuilder: $1.Timestamp.$_createMessage)
    ..aOM<$1.Timestamp>(3, _omitFieldNames ? '' : 'endDate',
        subBuilder: $1.Timestamp.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetCalendarRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetCalendarRequest copyWith(void Function(GetCalendarRequest) updates) =>
      super.copyWith((message) => updates(message as GetCalendarRequest))
          as GetCalendarRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use GetCalendarRequest() / GetCalendarRequest.new instead')
  static GetCalendarRequest create() => GetCalendarRequest._();
  static $pb.GeneratedMessage $_createMessage() => GetCalendarRequest._();
  @$core.override
  GetCalendarRequest createEmptyInstance() => GetCalendarRequest._();
  @$core.pragma('dart2js:noInline')
  static GetCalendarRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetCalendarRequest>(
          GetCalendarRequest.$_createMessage);
  static GetCalendarRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $1.Timestamp get startDate => $_getN(1);
  @$pb.TagNumber(2)
  set startDate($1.Timestamp value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasStartDate() => $_has(1);
  @$pb.TagNumber(2)
  void clearStartDate() => $_clearField(2);
  @$pb.TagNumber(2)
  $1.Timestamp ensureStartDate() => $_ensure(1);

  @$pb.TagNumber(3)
  $1.Timestamp get endDate => $_getN(2);
  @$pb.TagNumber(3)
  set endDate($1.Timestamp value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasEndDate() => $_has(2);
  @$pb.TagNumber(3)
  void clearEndDate() => $_clearField(3);
  @$pb.TagNumber(3)
  $1.Timestamp ensureEndDate() => $_ensure(2);
}

class CalendarEntry extends $pb.GeneratedMessage {
  factory CalendarEntry({
    PublishItem? item,
    $1.Timestamp? scheduledTime,
    $core.String? status,
  }) {
    final result = CalendarEntry._();
    if (item != null) result.item = item;
    if (scheduledTime != null) result.scheduledTime = scheduledTime;
    if (status != null) result.status = status;
    return result;
  }

  CalendarEntry._();

  factory CalendarEntry.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CalendarEntry()..mergeFromBuffer(data, registry);
  factory CalendarEntry.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CalendarEntry()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CalendarEntry',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.publish.v1'),
      createEmptyInstance: CalendarEntry.$_createMessage)
    ..aOM<PublishItem>(1, _omitFieldNames ? '' : 'item',
        subBuilder: PublishItem.$_createMessage)
    ..aOM<$1.Timestamp>(2, _omitFieldNames ? '' : 'scheduledTime',
        subBuilder: $1.Timestamp.$_createMessage)
    ..aOS(3, _omitFieldNames ? '' : 'status')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CalendarEntry clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CalendarEntry copyWith(void Function(CalendarEntry) updates) =>
      super.copyWith((message) => updates(message as CalendarEntry))
          as CalendarEntry;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use CalendarEntry() / CalendarEntry.new instead')
  static CalendarEntry create() => CalendarEntry._();
  static $pb.GeneratedMessage $_createMessage() => CalendarEntry._();
  @$core.override
  CalendarEntry createEmptyInstance() => CalendarEntry._();
  @$core.pragma('dart2js:noInline')
  static CalendarEntry getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CalendarEntry>(
          CalendarEntry.$_createMessage);
  static CalendarEntry? _defaultInstance;

  @$pb.TagNumber(1)
  PublishItem get item => $_getN(0);
  @$pb.TagNumber(1)
  set item(PublishItem value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasItem() => $_has(0);
  @$pb.TagNumber(1)
  void clearItem() => $_clearField(1);
  @$pb.TagNumber(1)
  PublishItem ensureItem() => $_ensure(0);

  @$pb.TagNumber(2)
  $1.Timestamp get scheduledTime => $_getN(1);
  @$pb.TagNumber(2)
  set scheduledTime($1.Timestamp value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasScheduledTime() => $_has(1);
  @$pb.TagNumber(2)
  void clearScheduledTime() => $_clearField(2);
  @$pb.TagNumber(2)
  $1.Timestamp ensureScheduledTime() => $_ensure(1);

  @$pb.TagNumber(3)
  $core.String get status => $_getSZ(2);
  @$pb.TagNumber(3)
  set status($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasStatus() => $_has(2);
  @$pb.TagNumber(3)
  void clearStatus() => $_clearField(3);
}

class GetCalendarResponse extends $pb.GeneratedMessage {
  factory GetCalendarResponse({
    $core.Iterable<CalendarEntry>? entries,
  }) {
    final result = GetCalendarResponse._();
    if (entries != null) result.entries.addAll(entries);
    return result;
  }

  GetCalendarResponse._();

  factory GetCalendarResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetCalendarResponse()..mergeFromBuffer(data, registry);
  factory GetCalendarResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetCalendarResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetCalendarResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.publish.v1'),
      createEmptyInstance: GetCalendarResponse.$_createMessage)
    ..pPM<CalendarEntry>(1, _omitFieldNames ? '' : 'entries',
        subBuilder: CalendarEntry.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetCalendarResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetCalendarResponse copyWith(void Function(GetCalendarResponse) updates) =>
      super.copyWith((message) => updates(message as GetCalendarResponse))
          as GetCalendarResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core
      .Deprecated('Use GetCalendarResponse() / GetCalendarResponse.new instead')
  static GetCalendarResponse create() => GetCalendarResponse._();
  static $pb.GeneratedMessage $_createMessage() => GetCalendarResponse._();
  @$core.override
  GetCalendarResponse createEmptyInstance() => GetCalendarResponse._();
  @$core.pragma('dart2js:noInline')
  static GetCalendarResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetCalendarResponse>(
          GetCalendarResponse.$_createMessage);
  static GetCalendarResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<CalendarEntry> get entries => $_getList(0);
}

class ListByDateRangeRequest extends $pb.GeneratedMessage {
  factory ListByDateRangeRequest({
    $core.String? workspaceId,
    $1.Timestamp? startDate,
    $1.Timestamp? endDate,
    $2.Pagination? pagination,
  }) {
    final result = ListByDateRangeRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (startDate != null) result.startDate = startDate;
    if (endDate != null) result.endDate = endDate;
    if (pagination != null) result.pagination = pagination;
    return result;
  }

  ListByDateRangeRequest._();

  factory ListByDateRangeRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListByDateRangeRequest()..mergeFromBuffer(data, registry);
  factory ListByDateRangeRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListByDateRangeRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListByDateRangeRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.publish.v1'),
      createEmptyInstance: ListByDateRangeRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOM<$1.Timestamp>(2, _omitFieldNames ? '' : 'startDate',
        subBuilder: $1.Timestamp.$_createMessage)
    ..aOM<$1.Timestamp>(3, _omitFieldNames ? '' : 'endDate',
        subBuilder: $1.Timestamp.$_createMessage)
    ..aOM<$2.Pagination>(4, _omitFieldNames ? '' : 'pagination',
        subBuilder: $2.Pagination.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListByDateRangeRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListByDateRangeRequest copyWith(
          void Function(ListByDateRangeRequest) updates) =>
      super.copyWith((message) => updates(message as ListByDateRangeRequest))
          as ListByDateRangeRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ListByDateRangeRequest() / ListByDateRangeRequest.new instead')
  static ListByDateRangeRequest create() => ListByDateRangeRequest._();
  static $pb.GeneratedMessage $_createMessage() => ListByDateRangeRequest._();
  @$core.override
  ListByDateRangeRequest createEmptyInstance() => ListByDateRangeRequest._();
  @$core.pragma('dart2js:noInline')
  static ListByDateRangeRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListByDateRangeRequest>(
          ListByDateRangeRequest.$_createMessage);
  static ListByDateRangeRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $1.Timestamp get startDate => $_getN(1);
  @$pb.TagNumber(2)
  set startDate($1.Timestamp value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasStartDate() => $_has(1);
  @$pb.TagNumber(2)
  void clearStartDate() => $_clearField(2);
  @$pb.TagNumber(2)
  $1.Timestamp ensureStartDate() => $_ensure(1);

  @$pb.TagNumber(3)
  $1.Timestamp get endDate => $_getN(2);
  @$pb.TagNumber(3)
  set endDate($1.Timestamp value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasEndDate() => $_has(2);
  @$pb.TagNumber(3)
  void clearEndDate() => $_clearField(3);
  @$pb.TagNumber(3)
  $1.Timestamp ensureEndDate() => $_ensure(2);

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

class ListByDateRangeResponse extends $pb.GeneratedMessage {
  factory ListByDateRangeResponse({
    $core.Iterable<PublishItem>? items,
    $2.PaginatedResponse? pagination,
  }) {
    final result = ListByDateRangeResponse._();
    if (items != null) result.items.addAll(items);
    if (pagination != null) result.pagination = pagination;
    return result;
  }

  ListByDateRangeResponse._();

  factory ListByDateRangeResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListByDateRangeResponse()..mergeFromBuffer(data, registry);
  factory ListByDateRangeResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListByDateRangeResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListByDateRangeResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.publish.v1'),
      createEmptyInstance: ListByDateRangeResponse.$_createMessage)
    ..pPM<PublishItem>(1, _omitFieldNames ? '' : 'items',
        subBuilder: PublishItem.$_createMessage)
    ..aOM<$2.PaginatedResponse>(2, _omitFieldNames ? '' : 'pagination',
        subBuilder: $2.PaginatedResponse.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListByDateRangeResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListByDateRangeResponse copyWith(
          void Function(ListByDateRangeResponse) updates) =>
      super.copyWith((message) => updates(message as ListByDateRangeResponse))
          as ListByDateRangeResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ListByDateRangeResponse() / ListByDateRangeResponse.new instead')
  static ListByDateRangeResponse create() => ListByDateRangeResponse._();
  static $pb.GeneratedMessage $_createMessage() => ListByDateRangeResponse._();
  @$core.override
  ListByDateRangeResponse createEmptyInstance() => ListByDateRangeResponse._();
  @$core.pragma('dart2js:noInline')
  static ListByDateRangeResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListByDateRangeResponse>(
          ListByDateRangeResponse.$_createMessage);
  static ListByDateRangeResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<PublishItem> get items => $_getList(0);

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

class ListUpcomingRequest extends $pb.GeneratedMessage {
  factory ListUpcomingRequest({
    $core.String? workspaceId,
    $core.int? limit,
  }) {
    final result = ListUpcomingRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (limit != null) result.limit = limit;
    return result;
  }

  ListUpcomingRequest._();

  factory ListUpcomingRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListUpcomingRequest()..mergeFromBuffer(data, registry);
  factory ListUpcomingRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListUpcomingRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListUpcomingRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.publish.v1'),
      createEmptyInstance: ListUpcomingRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aI(2, _omitFieldNames ? '' : 'limit')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListUpcomingRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListUpcomingRequest copyWith(void Function(ListUpcomingRequest) updates) =>
      super.copyWith((message) => updates(message as ListUpcomingRequest))
          as ListUpcomingRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core
      .Deprecated('Use ListUpcomingRequest() / ListUpcomingRequest.new instead')
  static ListUpcomingRequest create() => ListUpcomingRequest._();
  static $pb.GeneratedMessage $_createMessage() => ListUpcomingRequest._();
  @$core.override
  ListUpcomingRequest createEmptyInstance() => ListUpcomingRequest._();
  @$core.pragma('dart2js:noInline')
  static ListUpcomingRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListUpcomingRequest>(
          ListUpcomingRequest.$_createMessage);
  static ListUpcomingRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get limit => $_getIZ(1);
  @$pb.TagNumber(2)
  set limit($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasLimit() => $_has(1);
  @$pb.TagNumber(2)
  void clearLimit() => $_clearField(2);
}

class ListUpcomingResponse extends $pb.GeneratedMessage {
  factory ListUpcomingResponse({
    $core.Iterable<PublishItem>? items,
  }) {
    final result = ListUpcomingResponse._();
    if (items != null) result.items.addAll(items);
    return result;
  }

  ListUpcomingResponse._();

  factory ListUpcomingResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListUpcomingResponse()..mergeFromBuffer(data, registry);
  factory ListUpcomingResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListUpcomingResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListUpcomingResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.publish.v1'),
      createEmptyInstance: ListUpcomingResponse.$_createMessage)
    ..pPM<PublishItem>(1, _omitFieldNames ? '' : 'items',
        subBuilder: PublishItem.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListUpcomingResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListUpcomingResponse copyWith(void Function(ListUpcomingResponse) updates) =>
      super.copyWith((message) => updates(message as ListUpcomingResponse))
          as ListUpcomingResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ListUpcomingResponse() / ListUpcomingResponse.new instead')
  static ListUpcomingResponse create() => ListUpcomingResponse._();
  static $pb.GeneratedMessage $_createMessage() => ListUpcomingResponse._();
  @$core.override
  ListUpcomingResponse createEmptyInstance() => ListUpcomingResponse._();
  @$core.pragma('dart2js:noInline')
  static ListUpcomingResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListUpcomingResponse>(
          ListUpcomingResponse.$_createMessage);
  static ListUpcomingResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<PublishItem> get items => $_getList(0);
}

class ListPublishedRequest extends $pb.GeneratedMessage {
  factory ListPublishedRequest({
    $core.String? workspaceId,
    $2.Pagination? pagination,
  }) {
    final result = ListPublishedRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (pagination != null) result.pagination = pagination;
    return result;
  }

  ListPublishedRequest._();

  factory ListPublishedRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListPublishedRequest()..mergeFromBuffer(data, registry);
  factory ListPublishedRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListPublishedRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListPublishedRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.publish.v1'),
      createEmptyInstance: ListPublishedRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOM<$2.Pagination>(2, _omitFieldNames ? '' : 'pagination',
        subBuilder: $2.Pagination.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListPublishedRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListPublishedRequest copyWith(void Function(ListPublishedRequest) updates) =>
      super.copyWith((message) => updates(message as ListPublishedRequest))
          as ListPublishedRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ListPublishedRequest() / ListPublishedRequest.new instead')
  static ListPublishedRequest create() => ListPublishedRequest._();
  static $pb.GeneratedMessage $_createMessage() => ListPublishedRequest._();
  @$core.override
  ListPublishedRequest createEmptyInstance() => ListPublishedRequest._();
  @$core.pragma('dart2js:noInline')
  static ListPublishedRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListPublishedRequest>(
          ListPublishedRequest.$_createMessage);
  static ListPublishedRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

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

class ListPublishedResponse extends $pb.GeneratedMessage {
  factory ListPublishedResponse({
    $core.Iterable<PublishItem>? items,
    $2.PaginatedResponse? pagination,
  }) {
    final result = ListPublishedResponse._();
    if (items != null) result.items.addAll(items);
    if (pagination != null) result.pagination = pagination;
    return result;
  }

  ListPublishedResponse._();

  factory ListPublishedResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListPublishedResponse()..mergeFromBuffer(data, registry);
  factory ListPublishedResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListPublishedResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListPublishedResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.publish.v1'),
      createEmptyInstance: ListPublishedResponse.$_createMessage)
    ..pPM<PublishItem>(1, _omitFieldNames ? '' : 'items',
        subBuilder: PublishItem.$_createMessage)
    ..aOM<$2.PaginatedResponse>(2, _omitFieldNames ? '' : 'pagination',
        subBuilder: $2.PaginatedResponse.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListPublishedResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListPublishedResponse copyWith(
          void Function(ListPublishedResponse) updates) =>
      super.copyWith((message) => updates(message as ListPublishedResponse))
          as ListPublishedResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ListPublishedResponse() / ListPublishedResponse.new instead')
  static ListPublishedResponse create() => ListPublishedResponse._();
  static $pb.GeneratedMessage $_createMessage() => ListPublishedResponse._();
  @$core.override
  ListPublishedResponse createEmptyInstance() => ListPublishedResponse._();
  @$core.pragma('dart2js:noInline')
  static ListPublishedResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListPublishedResponse>(
          ListPublishedResponse.$_createMessage);
  static ListPublishedResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<PublishItem> get items => $_getList(0);

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

class ListPostsRequest extends $pb.GeneratedMessage {
  factory ListPostsRequest({
    $core.String? workspaceId,
    $2.Pagination? pagination,
  }) {
    final result = ListPostsRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (pagination != null) result.pagination = pagination;
    return result;
  }

  ListPostsRequest._();

  factory ListPostsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListPostsRequest()..mergeFromBuffer(data, registry);
  factory ListPostsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListPostsRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListPostsRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.publish.v1'),
      createEmptyInstance: ListPostsRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOM<$2.Pagination>(2, _omitFieldNames ? '' : 'pagination',
        subBuilder: $2.Pagination.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListPostsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListPostsRequest copyWith(void Function(ListPostsRequest) updates) =>
      super.copyWith((message) => updates(message as ListPostsRequest))
          as ListPostsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ListPostsRequest() / ListPostsRequest.new instead')
  static ListPostsRequest create() => ListPostsRequest._();
  static $pb.GeneratedMessage $_createMessage() => ListPostsRequest._();
  @$core.override
  ListPostsRequest createEmptyInstance() => ListPostsRequest._();
  @$core.pragma('dart2js:noInline')
  static ListPostsRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ListPostsRequest>(
          ListPostsRequest.$_createMessage);
  static ListPostsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

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

class ListPostsResponse extends $pb.GeneratedMessage {
  factory ListPostsResponse({
    $core.Iterable<ChannelPost>? posts,
    $2.PaginatedResponse? pagination,
  }) {
    final result = ListPostsResponse._();
    if (posts != null) result.posts.addAll(posts);
    if (pagination != null) result.pagination = pagination;
    return result;
  }

  ListPostsResponse._();

  factory ListPostsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListPostsResponse()..mergeFromBuffer(data, registry);
  factory ListPostsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListPostsResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListPostsResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.publish.v1'),
      createEmptyInstance: ListPostsResponse.$_createMessage)
    ..pPM<ChannelPost>(1, _omitFieldNames ? '' : 'posts',
        subBuilder: ChannelPost.$_createMessage)
    ..aOM<$2.PaginatedResponse>(2, _omitFieldNames ? '' : 'pagination',
        subBuilder: $2.PaginatedResponse.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListPostsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListPostsResponse copyWith(void Function(ListPostsResponse) updates) =>
      super.copyWith((message) => updates(message as ListPostsResponse))
          as ListPostsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ListPostsResponse() / ListPostsResponse.new instead')
  static ListPostsResponse create() => ListPostsResponse._();
  static $pb.GeneratedMessage $_createMessage() => ListPostsResponse._();
  @$core.override
  ListPostsResponse createEmptyInstance() => ListPostsResponse._();
  @$core.pragma('dart2js:noInline')
  static ListPostsResponse getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ListPostsResponse>(
          ListPostsResponse.$_createMessage);
  static ListPostsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<ChannelPost> get posts => $_getList(0);

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

class GetPlatformStatusRequest extends $pb.GeneratedMessage {
  factory GetPlatformStatusRequest({
    $core.String? platform,
  }) {
    final result = GetPlatformStatusRequest._();
    if (platform != null) result.platform = platform;
    return result;
  }

  GetPlatformStatusRequest._();

  factory GetPlatformStatusRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetPlatformStatusRequest()..mergeFromBuffer(data, registry);
  factory GetPlatformStatusRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetPlatformStatusRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetPlatformStatusRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.publish.v1'),
      createEmptyInstance: GetPlatformStatusRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'platform')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetPlatformStatusRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetPlatformStatusRequest copyWith(
          void Function(GetPlatformStatusRequest) updates) =>
      super.copyWith((message) => updates(message as GetPlatformStatusRequest))
          as GetPlatformStatusRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use GetPlatformStatusRequest() / GetPlatformStatusRequest.new instead')
  static GetPlatformStatusRequest create() => GetPlatformStatusRequest._();
  static $pb.GeneratedMessage $_createMessage() => GetPlatformStatusRequest._();
  @$core.override
  GetPlatformStatusRequest createEmptyInstance() =>
      GetPlatformStatusRequest._();
  @$core.pragma('dart2js:noInline')
  static GetPlatformStatusRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetPlatformStatusRequest>(
          GetPlatformStatusRequest.$_createMessage);
  static GetPlatformStatusRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get platform => $_getSZ(0);
  @$pb.TagNumber(1)
  set platform($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPlatform() => $_has(0);
  @$pb.TagNumber(1)
  void clearPlatform() => $_clearField(1);
}

class GetPlatformStatusResponse extends $pb.GeneratedMessage {
  factory GetPlatformStatusResponse({
    PlatformCapabilitySummary? status,
  }) {
    final result = GetPlatformStatusResponse._();
    if (status != null) result.status = status;
    return result;
  }

  GetPlatformStatusResponse._();

  factory GetPlatformStatusResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetPlatformStatusResponse()..mergeFromBuffer(data, registry);
  factory GetPlatformStatusResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetPlatformStatusResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetPlatformStatusResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.publish.v1'),
      createEmptyInstance: GetPlatformStatusResponse.$_createMessage)
    ..aOM<PlatformCapabilitySummary>(1, _omitFieldNames ? '' : 'status',
        subBuilder: PlatformCapabilitySummary.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetPlatformStatusResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetPlatformStatusResponse copyWith(
          void Function(GetPlatformStatusResponse) updates) =>
      super.copyWith((message) => updates(message as GetPlatformStatusResponse))
          as GetPlatformStatusResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use GetPlatformStatusResponse() / GetPlatformStatusResponse.new instead')
  static GetPlatformStatusResponse create() => GetPlatformStatusResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      GetPlatformStatusResponse._();
  @$core.override
  GetPlatformStatusResponse createEmptyInstance() =>
      GetPlatformStatusResponse._();
  @$core.pragma('dart2js:noInline')
  static GetPlatformStatusResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetPlatformStatusResponse>(
          GetPlatformStatusResponse.$_createMessage);
  static GetPlatformStatusResponse? _defaultInstance;

  @$pb.TagNumber(1)
  PlatformCapabilitySummary get status => $_getN(0);
  @$pb.TagNumber(1)
  set status(PlatformCapabilitySummary value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasStatus() => $_has(0);
  @$pb.TagNumber(1)
  void clearStatus() => $_clearField(1);
  @$pb.TagNumber(1)
  PlatformCapabilitySummary ensureStatus() => $_ensure(0);
}

class GetCrossPostInsightsRequest extends $pb.GeneratedMessage {
  factory GetCrossPostInsightsRequest({
    $core.String? publishItemId,
  }) {
    final result = GetCrossPostInsightsRequest._();
    if (publishItemId != null) result.publishItemId = publishItemId;
    return result;
  }

  GetCrossPostInsightsRequest._();

  factory GetCrossPostInsightsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetCrossPostInsightsRequest()..mergeFromBuffer(data, registry);
  factory GetCrossPostInsightsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetCrossPostInsightsRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetCrossPostInsightsRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.publish.v1'),
      createEmptyInstance: GetCrossPostInsightsRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'publishItemId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetCrossPostInsightsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetCrossPostInsightsRequest copyWith(
          void Function(GetCrossPostInsightsRequest) updates) =>
      super.copyWith(
              (message) => updates(message as GetCrossPostInsightsRequest))
          as GetCrossPostInsightsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use GetCrossPostInsightsRequest() / GetCrossPostInsightsRequest.new instead')
  static GetCrossPostInsightsRequest create() =>
      GetCrossPostInsightsRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      GetCrossPostInsightsRequest._();
  @$core.override
  GetCrossPostInsightsRequest createEmptyInstance() =>
      GetCrossPostInsightsRequest._();
  @$core.pragma('dart2js:noInline')
  static GetCrossPostInsightsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetCrossPostInsightsRequest>(
          GetCrossPostInsightsRequest.$_createMessage);
  static GetCrossPostInsightsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get publishItemId => $_getSZ(0);
  @$pb.TagNumber(1)
  set publishItemId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPublishItemId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPublishItemId() => $_clearField(1);
}

class GetCrossPostInsightsResponse extends $pb.GeneratedMessage {
  factory GetCrossPostInsightsResponse({
    $core.String? publishItemId,
    $core.Iterable<ChannelPost>? posts,
    $fixnum.Int64? totalViews,
    $fixnum.Int64? totalLikes,
  }) {
    final result = GetCrossPostInsightsResponse._();
    if (publishItemId != null) result.publishItemId = publishItemId;
    if (posts != null) result.posts.addAll(posts);
    if (totalViews != null) result.totalViews = totalViews;
    if (totalLikes != null) result.totalLikes = totalLikes;
    return result;
  }

  GetCrossPostInsightsResponse._();

  factory GetCrossPostInsightsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetCrossPostInsightsResponse()..mergeFromBuffer(data, registry);
  factory GetCrossPostInsightsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetCrossPostInsightsResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetCrossPostInsightsResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.publish.v1'),
      createEmptyInstance: GetCrossPostInsightsResponse.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'publishItemId')
    ..pPM<ChannelPost>(2, _omitFieldNames ? '' : 'posts',
        subBuilder: ChannelPost.$_createMessage)
    ..aInt64(3, _omitFieldNames ? '' : 'totalViews')
    ..aInt64(4, _omitFieldNames ? '' : 'totalLikes')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetCrossPostInsightsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetCrossPostInsightsResponse copyWith(
          void Function(GetCrossPostInsightsResponse) updates) =>
      super.copyWith(
              (message) => updates(message as GetCrossPostInsightsResponse))
          as GetCrossPostInsightsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use GetCrossPostInsightsResponse() / GetCrossPostInsightsResponse.new instead')
  static GetCrossPostInsightsResponse create() =>
      GetCrossPostInsightsResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      GetCrossPostInsightsResponse._();
  @$core.override
  GetCrossPostInsightsResponse createEmptyInstance() =>
      GetCrossPostInsightsResponse._();
  @$core.pragma('dart2js:noInline')
  static GetCrossPostInsightsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetCrossPostInsightsResponse>(
          GetCrossPostInsightsResponse.$_createMessage);
  static GetCrossPostInsightsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get publishItemId => $_getSZ(0);
  @$pb.TagNumber(1)
  set publishItemId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPublishItemId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPublishItemId() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbList<ChannelPost> get posts => $_getList(1);

  @$pb.TagNumber(3)
  $fixnum.Int64 get totalViews => $_getI64(2);
  @$pb.TagNumber(3)
  set totalViews($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasTotalViews() => $_has(2);
  @$pb.TagNumber(3)
  void clearTotalViews() => $_clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get totalLikes => $_getI64(3);
  @$pb.TagNumber(4)
  set totalLikes($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasTotalLikes() => $_has(3);
  @$pb.TagNumber(4)
  void clearTotalLikes() => $_clearField(4);
}

class PublishVariantsRequest extends $pb.GeneratedMessage {
  factory PublishVariantsRequest({
    $2.CommandContext? context,
    $core.Iterable<$core.String>? publishItemIds,
  }) {
    final result = PublishVariantsRequest._();
    if (context != null) result.context = context;
    if (publishItemIds != null) result.publishItemIds.addAll(publishItemIds);
    return result;
  }

  PublishVariantsRequest._();

  factory PublishVariantsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PublishVariantsRequest()..mergeFromBuffer(data, registry);
  factory PublishVariantsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PublishVariantsRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PublishVariantsRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.publish.v1'),
      createEmptyInstance: PublishVariantsRequest.$_createMessage)
    ..aOM<$2.CommandContext>(1, _omitFieldNames ? '' : 'context',
        subBuilder: $2.CommandContext.$_createMessage)
    ..pPS(2, _omitFieldNames ? '' : 'publishItemIds')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PublishVariantsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PublishVariantsRequest copyWith(
          void Function(PublishVariantsRequest) updates) =>
      super.copyWith((message) => updates(message as PublishVariantsRequest))
          as PublishVariantsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use PublishVariantsRequest() / PublishVariantsRequest.new instead')
  static PublishVariantsRequest create() => PublishVariantsRequest._();
  static $pb.GeneratedMessage $_createMessage() => PublishVariantsRequest._();
  @$core.override
  PublishVariantsRequest createEmptyInstance() => PublishVariantsRequest._();
  @$core.pragma('dart2js:noInline')
  static PublishVariantsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PublishVariantsRequest>(
          PublishVariantsRequest.$_createMessage);
  static PublishVariantsRequest? _defaultInstance;

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
  $pb.PbList<$core.String> get publishItemIds => $_getList(1);
}

class PublishVariantsResponse extends $pb.GeneratedMessage {
  factory PublishVariantsResponse({
    $core.Iterable<PublishItem>? items,
    $core.Iterable<PublishJob>? jobs,
  }) {
    final result = PublishVariantsResponse._();
    if (items != null) result.items.addAll(items);
    if (jobs != null) result.jobs.addAll(jobs);
    return result;
  }

  PublishVariantsResponse._();

  factory PublishVariantsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PublishVariantsResponse()..mergeFromBuffer(data, registry);
  factory PublishVariantsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PublishVariantsResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PublishVariantsResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.publish.v1'),
      createEmptyInstance: PublishVariantsResponse.$_createMessage)
    ..pPM<PublishItem>(1, _omitFieldNames ? '' : 'items',
        subBuilder: PublishItem.$_createMessage)
    ..pPM<PublishJob>(2, _omitFieldNames ? '' : 'jobs',
        subBuilder: PublishJob.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PublishVariantsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PublishVariantsResponse copyWith(
          void Function(PublishVariantsResponse) updates) =>
      super.copyWith((message) => updates(message as PublishVariantsResponse))
          as PublishVariantsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use PublishVariantsResponse() / PublishVariantsResponse.new instead')
  static PublishVariantsResponse create() => PublishVariantsResponse._();
  static $pb.GeneratedMessage $_createMessage() => PublishVariantsResponse._();
  @$core.override
  PublishVariantsResponse createEmptyInstance() => PublishVariantsResponse._();
  @$core.pragma('dart2js:noInline')
  static PublishVariantsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PublishVariantsResponse>(
          PublishVariantsResponse.$_createMessage);
  static PublishVariantsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<PublishItem> get items => $_getList(0);

  @$pb.TagNumber(2)
  $pb.PbList<PublishJob> get jobs => $_getList(1);
}

class HoldScheduleRequest extends $pb.GeneratedMessage {
  factory HoldScheduleRequest({
    $2.CommandContext? context,
    $core.String? publishItemId,
  }) {
    final result = HoldScheduleRequest._();
    if (context != null) result.context = context;
    if (publishItemId != null) result.publishItemId = publishItemId;
    return result;
  }

  HoldScheduleRequest._();

  factory HoldScheduleRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      HoldScheduleRequest()..mergeFromBuffer(data, registry);
  factory HoldScheduleRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      HoldScheduleRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'HoldScheduleRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.publish.v1'),
      createEmptyInstance: HoldScheduleRequest.$_createMessage)
    ..aOM<$2.CommandContext>(1, _omitFieldNames ? '' : 'context',
        subBuilder: $2.CommandContext.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'publishItemId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  HoldScheduleRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  HoldScheduleRequest copyWith(void Function(HoldScheduleRequest) updates) =>
      super.copyWith((message) => updates(message as HoldScheduleRequest))
          as HoldScheduleRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core
      .Deprecated('Use HoldScheduleRequest() / HoldScheduleRequest.new instead')
  static HoldScheduleRequest create() => HoldScheduleRequest._();
  static $pb.GeneratedMessage $_createMessage() => HoldScheduleRequest._();
  @$core.override
  HoldScheduleRequest createEmptyInstance() => HoldScheduleRequest._();
  @$core.pragma('dart2js:noInline')
  static HoldScheduleRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<HoldScheduleRequest>(
          HoldScheduleRequest.$_createMessage);
  static HoldScheduleRequest? _defaultInstance;

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
  $core.String get publishItemId => $_getSZ(1);
  @$pb.TagNumber(2)
  set publishItemId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPublishItemId() => $_has(1);
  @$pb.TagNumber(2)
  void clearPublishItemId() => $_clearField(2);
}

class HoldScheduleResponse extends $pb.GeneratedMessage {
  factory HoldScheduleResponse({
    PublishItem? item,
  }) {
    final result = HoldScheduleResponse._();
    if (item != null) result.item = item;
    return result;
  }

  HoldScheduleResponse._();

  factory HoldScheduleResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      HoldScheduleResponse()..mergeFromBuffer(data, registry);
  factory HoldScheduleResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      HoldScheduleResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'HoldScheduleResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.publish.v1'),
      createEmptyInstance: HoldScheduleResponse.$_createMessage)
    ..aOM<PublishItem>(1, _omitFieldNames ? '' : 'item',
        subBuilder: PublishItem.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  HoldScheduleResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  HoldScheduleResponse copyWith(void Function(HoldScheduleResponse) updates) =>
      super.copyWith((message) => updates(message as HoldScheduleResponse))
          as HoldScheduleResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use HoldScheduleResponse() / HoldScheduleResponse.new instead')
  static HoldScheduleResponse create() => HoldScheduleResponse._();
  static $pb.GeneratedMessage $_createMessage() => HoldScheduleResponse._();
  @$core.override
  HoldScheduleResponse createEmptyInstance() => HoldScheduleResponse._();
  @$core.pragma('dart2js:noInline')
  static HoldScheduleResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<HoldScheduleResponse>(
          HoldScheduleResponse.$_createMessage);
  static HoldScheduleResponse? _defaultInstance;

  @$pb.TagNumber(1)
  PublishItem get item => $_getN(0);
  @$pb.TagNumber(1)
  set item(PublishItem value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasItem() => $_has(0);
  @$pb.TagNumber(1)
  void clearItem() => $_clearField(1);
  @$pb.TagNumber(1)
  PublishItem ensureItem() => $_ensure(0);
}

class ScheduleRetryRequest extends $pb.GeneratedMessage {
  factory ScheduleRetryRequest({
    $2.CommandContext? context,
    $core.String? publishItemId,
    $1.Timestamp? retryAt,
  }) {
    final result = ScheduleRetryRequest._();
    if (context != null) result.context = context;
    if (publishItemId != null) result.publishItemId = publishItemId;
    if (retryAt != null) result.retryAt = retryAt;
    return result;
  }

  ScheduleRetryRequest._();

  factory ScheduleRetryRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ScheduleRetryRequest()..mergeFromBuffer(data, registry);
  factory ScheduleRetryRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ScheduleRetryRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ScheduleRetryRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.publish.v1'),
      createEmptyInstance: ScheduleRetryRequest.$_createMessage)
    ..aOM<$2.CommandContext>(1, _omitFieldNames ? '' : 'context',
        subBuilder: $2.CommandContext.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'publishItemId')
    ..aOM<$1.Timestamp>(3, _omitFieldNames ? '' : 'retryAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ScheduleRetryRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ScheduleRetryRequest copyWith(void Function(ScheduleRetryRequest) updates) =>
      super.copyWith((message) => updates(message as ScheduleRetryRequest))
          as ScheduleRetryRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ScheduleRetryRequest() / ScheduleRetryRequest.new instead')
  static ScheduleRetryRequest create() => ScheduleRetryRequest._();
  static $pb.GeneratedMessage $_createMessage() => ScheduleRetryRequest._();
  @$core.override
  ScheduleRetryRequest createEmptyInstance() => ScheduleRetryRequest._();
  @$core.pragma('dart2js:noInline')
  static ScheduleRetryRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ScheduleRetryRequest>(
          ScheduleRetryRequest.$_createMessage);
  static ScheduleRetryRequest? _defaultInstance;

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
  $core.String get publishItemId => $_getSZ(1);
  @$pb.TagNumber(2)
  set publishItemId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPublishItemId() => $_has(1);
  @$pb.TagNumber(2)
  void clearPublishItemId() => $_clearField(2);

  @$pb.TagNumber(3)
  $1.Timestamp get retryAt => $_getN(2);
  @$pb.TagNumber(3)
  set retryAt($1.Timestamp value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasRetryAt() => $_has(2);
  @$pb.TagNumber(3)
  void clearRetryAt() => $_clearField(3);
  @$pb.TagNumber(3)
  $1.Timestamp ensureRetryAt() => $_ensure(2);
}

class ScheduleRetryResponse extends $pb.GeneratedMessage {
  factory ScheduleRetryResponse({
    PublishItem? item,
  }) {
    final result = ScheduleRetryResponse._();
    if (item != null) result.item = item;
    return result;
  }

  ScheduleRetryResponse._();

  factory ScheduleRetryResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ScheduleRetryResponse()..mergeFromBuffer(data, registry);
  factory ScheduleRetryResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ScheduleRetryResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ScheduleRetryResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.publish.v1'),
      createEmptyInstance: ScheduleRetryResponse.$_createMessage)
    ..aOM<PublishItem>(1, _omitFieldNames ? '' : 'item',
        subBuilder: PublishItem.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ScheduleRetryResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ScheduleRetryResponse copyWith(
          void Function(ScheduleRetryResponse) updates) =>
      super.copyWith((message) => updates(message as ScheduleRetryResponse))
          as ScheduleRetryResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ScheduleRetryResponse() / ScheduleRetryResponse.new instead')
  static ScheduleRetryResponse create() => ScheduleRetryResponse._();
  static $pb.GeneratedMessage $_createMessage() => ScheduleRetryResponse._();
  @$core.override
  ScheduleRetryResponse createEmptyInstance() => ScheduleRetryResponse._();
  @$core.pragma('dart2js:noInline')
  static ScheduleRetryResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ScheduleRetryResponse>(
          ScheduleRetryResponse.$_createMessage);
  static ScheduleRetryResponse? _defaultInstance;

  @$pb.TagNumber(1)
  PublishItem get item => $_getN(0);
  @$pb.TagNumber(1)
  set item(PublishItem value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasItem() => $_has(0);
  @$pb.TagNumber(1)
  void clearItem() => $_clearField(1);
  @$pb.TagNumber(1)
  PublishItem ensureItem() => $_ensure(0);
}

class TagProductRequest extends $pb.GeneratedMessage {
  factory TagProductRequest({
    $2.CommandContext? context,
    $core.String? publishItemId,
    $core.String? productId,
  }) {
    final result = TagProductRequest._();
    if (context != null) result.context = context;
    if (publishItemId != null) result.publishItemId = publishItemId;
    if (productId != null) result.productId = productId;
    return result;
  }

  TagProductRequest._();

  factory TagProductRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      TagProductRequest()..mergeFromBuffer(data, registry);
  factory TagProductRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      TagProductRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TagProductRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.publish.v1'),
      createEmptyInstance: TagProductRequest.$_createMessage)
    ..aOM<$2.CommandContext>(1, _omitFieldNames ? '' : 'context',
        subBuilder: $2.CommandContext.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'publishItemId')
    ..aOS(3, _omitFieldNames ? '' : 'productId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TagProductRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TagProductRequest copyWith(void Function(TagProductRequest) updates) =>
      super.copyWith((message) => updates(message as TagProductRequest))
          as TagProductRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use TagProductRequest() / TagProductRequest.new instead')
  static TagProductRequest create() => TagProductRequest._();
  static $pb.GeneratedMessage $_createMessage() => TagProductRequest._();
  @$core.override
  TagProductRequest createEmptyInstance() => TagProductRequest._();
  @$core.pragma('dart2js:noInline')
  static TagProductRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<TagProductRequest>(
          TagProductRequest.$_createMessage);
  static TagProductRequest? _defaultInstance;

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
  $core.String get publishItemId => $_getSZ(1);
  @$pb.TagNumber(2)
  set publishItemId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPublishItemId() => $_has(1);
  @$pb.TagNumber(2)
  void clearPublishItemId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get productId => $_getSZ(2);
  @$pb.TagNumber(3)
  set productId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasProductId() => $_has(2);
  @$pb.TagNumber(3)
  void clearProductId() => $_clearField(3);
}

class TagProductResponse extends $pb.GeneratedMessage {
  factory TagProductResponse({
    PublishItem? item,
  }) {
    final result = TagProductResponse._();
    if (item != null) result.item = item;
    return result;
  }

  TagProductResponse._();

  factory TagProductResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      TagProductResponse()..mergeFromBuffer(data, registry);
  factory TagProductResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      TagProductResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TagProductResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.publish.v1'),
      createEmptyInstance: TagProductResponse.$_createMessage)
    ..aOM<PublishItem>(1, _omitFieldNames ? '' : 'item',
        subBuilder: PublishItem.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TagProductResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TagProductResponse copyWith(void Function(TagProductResponse) updates) =>
      super.copyWith((message) => updates(message as TagProductResponse))
          as TagProductResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use TagProductResponse() / TagProductResponse.new instead')
  static TagProductResponse create() => TagProductResponse._();
  static $pb.GeneratedMessage $_createMessage() => TagProductResponse._();
  @$core.override
  TagProductResponse createEmptyInstance() => TagProductResponse._();
  @$core.pragma('dart2js:noInline')
  static TagProductResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<TagProductResponse>(
          TagProductResponse.$_createMessage);
  static TagProductResponse? _defaultInstance;

  @$pb.TagNumber(1)
  PublishItem get item => $_getN(0);
  @$pb.TagNumber(1)
  set item(PublishItem value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasItem() => $_has(0);
  @$pb.TagNumber(1)
  void clearItem() => $_clearField(1);
  @$pb.TagNumber(1)
  PublishItem ensureItem() => $_ensure(0);
}

class UntagProductRequest extends $pb.GeneratedMessage {
  factory UntagProductRequest({
    $2.CommandContext? context,
    $core.String? publishItemId,
    $core.String? productId,
  }) {
    final result = UntagProductRequest._();
    if (context != null) result.context = context;
    if (publishItemId != null) result.publishItemId = publishItemId;
    if (productId != null) result.productId = productId;
    return result;
  }

  UntagProductRequest._();

  factory UntagProductRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      UntagProductRequest()..mergeFromBuffer(data, registry);
  factory UntagProductRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      UntagProductRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UntagProductRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.publish.v1'),
      createEmptyInstance: UntagProductRequest.$_createMessage)
    ..aOM<$2.CommandContext>(1, _omitFieldNames ? '' : 'context',
        subBuilder: $2.CommandContext.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'publishItemId')
    ..aOS(3, _omitFieldNames ? '' : 'productId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UntagProductRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UntagProductRequest copyWith(void Function(UntagProductRequest) updates) =>
      super.copyWith((message) => updates(message as UntagProductRequest))
          as UntagProductRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core
      .Deprecated('Use UntagProductRequest() / UntagProductRequest.new instead')
  static UntagProductRequest create() => UntagProductRequest._();
  static $pb.GeneratedMessage $_createMessage() => UntagProductRequest._();
  @$core.override
  UntagProductRequest createEmptyInstance() => UntagProductRequest._();
  @$core.pragma('dart2js:noInline')
  static UntagProductRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UntagProductRequest>(
          UntagProductRequest.$_createMessage);
  static UntagProductRequest? _defaultInstance;

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
  $core.String get publishItemId => $_getSZ(1);
  @$pb.TagNumber(2)
  set publishItemId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPublishItemId() => $_has(1);
  @$pb.TagNumber(2)
  void clearPublishItemId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get productId => $_getSZ(2);
  @$pb.TagNumber(3)
  set productId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasProductId() => $_has(2);
  @$pb.TagNumber(3)
  void clearProductId() => $_clearField(3);
}

class UntagProductResponse extends $pb.GeneratedMessage {
  factory UntagProductResponse({
    PublishItem? item,
  }) {
    final result = UntagProductResponse._();
    if (item != null) result.item = item;
    return result;
  }

  UntagProductResponse._();

  factory UntagProductResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      UntagProductResponse()..mergeFromBuffer(data, registry);
  factory UntagProductResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      UntagProductResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UntagProductResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.publish.v1'),
      createEmptyInstance: UntagProductResponse.$_createMessage)
    ..aOM<PublishItem>(1, _omitFieldNames ? '' : 'item',
        subBuilder: PublishItem.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UntagProductResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UntagProductResponse copyWith(void Function(UntagProductResponse) updates) =>
      super.copyWith((message) => updates(message as UntagProductResponse))
          as UntagProductResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use UntagProductResponse() / UntagProductResponse.new instead')
  static UntagProductResponse create() => UntagProductResponse._();
  static $pb.GeneratedMessage $_createMessage() => UntagProductResponse._();
  @$core.override
  UntagProductResponse createEmptyInstance() => UntagProductResponse._();
  @$core.pragma('dart2js:noInline')
  static UntagProductResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UntagProductResponse>(
          UntagProductResponse.$_createMessage);
  static UntagProductResponse? _defaultInstance;

  @$pb.TagNumber(1)
  PublishItem get item => $_getN(0);
  @$pb.TagNumber(1)
  set item(PublishItem value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasItem() => $_has(0);
  @$pb.TagNumber(1)
  void clearItem() => $_clearField(1);
  @$pb.TagNumber(1)
  PublishItem ensureItem() => $_ensure(0);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');

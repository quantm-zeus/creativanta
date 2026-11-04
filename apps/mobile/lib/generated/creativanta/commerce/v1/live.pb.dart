// This is a generated file - do not edit.
//
// Generated from creativanta/commerce/v1/live.proto.

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
import 'live.pbenum.dart';

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'live.pbenum.dart';

/// RunOfShowItem represents an ordered segment in the live session script.
/// database_schema.md §25.2
class RunOfShowItem extends $pb.GeneratedMessage {
  factory RunOfShowItem({
    $core.int? timeOffsetMin,
    $core.String? type,
    $core.String? title,
    $core.String? productId,
    $core.String? offerId,
    $core.String? notes,
    $core.int? durationMin,
    $core.bool? executed,
    $1.Timestamp? executedAt,
    $core.Iterable<$core.String>? cueCardIds,
  }) {
    final result = RunOfShowItem._();
    if (timeOffsetMin != null) result.timeOffsetMin = timeOffsetMin;
    if (type != null) result.type = type;
    if (title != null) result.title = title;
    if (productId != null) result.productId = productId;
    if (offerId != null) result.offerId = offerId;
    if (notes != null) result.notes = notes;
    if (durationMin != null) result.durationMin = durationMin;
    if (executed != null) result.executed = executed;
    if (executedAt != null) result.executedAt = executedAt;
    if (cueCardIds != null) result.cueCardIds.addAll(cueCardIds);
    return result;
  }

  RunOfShowItem._();

  factory RunOfShowItem.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RunOfShowItem()..mergeFromBuffer(data, registry);
  factory RunOfShowItem.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RunOfShowItem()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RunOfShowItem',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: RunOfShowItem.$_createMessage)
    ..aI(1, _omitFieldNames ? '' : 'timeOffsetMin')
    ..aOS(2, _omitFieldNames ? '' : 'type')
    ..aOS(3, _omitFieldNames ? '' : 'title')
    ..aOS(4, _omitFieldNames ? '' : 'productId')
    ..aOS(5, _omitFieldNames ? '' : 'offerId')
    ..aOS(6, _omitFieldNames ? '' : 'notes')
    ..aI(7, _omitFieldNames ? '' : 'durationMin')
    ..aOB(8, _omitFieldNames ? '' : 'executed')
    ..aOM<$1.Timestamp>(9, _omitFieldNames ? '' : 'executedAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..pPS(10, _omitFieldNames ? '' : 'cueCardIds')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RunOfShowItem clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RunOfShowItem copyWith(void Function(RunOfShowItem) updates) =>
      super.copyWith((message) => updates(message as RunOfShowItem))
          as RunOfShowItem;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use RunOfShowItem() / RunOfShowItem.new instead')
  static RunOfShowItem create() => RunOfShowItem._();
  static $pb.GeneratedMessage $_createMessage() => RunOfShowItem._();
  @$core.override
  RunOfShowItem createEmptyInstance() => RunOfShowItem._();
  @$core.pragma('dart2js:noInline')
  static RunOfShowItem getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<RunOfShowItem>(
          RunOfShowItem.$_createMessage);
  static RunOfShowItem? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get timeOffsetMin => $_getIZ(0);
  @$pb.TagNumber(1)
  set timeOffsetMin($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTimeOffsetMin() => $_has(0);
  @$pb.TagNumber(1)
  void clearTimeOffsetMin() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get type => $_getSZ(1);
  @$pb.TagNumber(2)
  set type($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasType() => $_has(1);
  @$pb.TagNumber(2)
  void clearType() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get title => $_getSZ(2);
  @$pb.TagNumber(3)
  set title($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasTitle() => $_has(2);
  @$pb.TagNumber(3)
  void clearTitle() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get productId => $_getSZ(3);
  @$pb.TagNumber(4)
  set productId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasProductId() => $_has(3);
  @$pb.TagNumber(4)
  void clearProductId() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get offerId => $_getSZ(4);
  @$pb.TagNumber(5)
  set offerId($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasOfferId() => $_has(4);
  @$pb.TagNumber(5)
  void clearOfferId() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get notes => $_getSZ(5);
  @$pb.TagNumber(6)
  set notes($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasNotes() => $_has(5);
  @$pb.TagNumber(6)
  void clearNotes() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.int get durationMin => $_getIZ(6);
  @$pb.TagNumber(7)
  set durationMin($core.int value) => $_setSignedInt32(6, value);
  @$pb.TagNumber(7)
  $core.bool hasDurationMin() => $_has(6);
  @$pb.TagNumber(7)
  void clearDurationMin() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.bool get executed => $_getBF(7);
  @$pb.TagNumber(8)
  set executed($core.bool value) => $_setBool(7, value);
  @$pb.TagNumber(8)
  $core.bool hasExecuted() => $_has(7);
  @$pb.TagNumber(8)
  void clearExecuted() => $_clearField(8);

  @$pb.TagNumber(9)
  $1.Timestamp get executedAt => $_getN(8);
  @$pb.TagNumber(9)
  set executedAt($1.Timestamp value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasExecutedAt() => $_has(8);
  @$pb.TagNumber(9)
  void clearExecutedAt() => $_clearField(9);
  @$pb.TagNumber(9)
  $1.Timestamp ensureExecutedAt() => $_ensure(8);

  @$pb.TagNumber(10)
  $pb.PbList<$core.String> get cueCardIds => $_getList(9);
}

/// LiveMetricsSnapshot captures real-time and post-live performance metrics.
/// database_schema.md §25.2
class LiveMetricsSnapshot extends $pb.GeneratedMessage {
  factory LiveMetricsSnapshot({
    $fixnum.Int64? peakViewers,
    $fixnum.Int64? avgViewers,
    $fixnum.Int64? totalViewers,
    $fixnum.Int64? totalComments,
    $fixnum.Int64? totalLikes,
    $fixnum.Int64? totalShares,
    $core.int? productsShown,
    $fixnum.Int64? ordersDuringLive,
    $2.Money? revenueDuringLive,
    $core.double? engagementRate,
  }) {
    final result = LiveMetricsSnapshot._();
    if (peakViewers != null) result.peakViewers = peakViewers;
    if (avgViewers != null) result.avgViewers = avgViewers;
    if (totalViewers != null) result.totalViewers = totalViewers;
    if (totalComments != null) result.totalComments = totalComments;
    if (totalLikes != null) result.totalLikes = totalLikes;
    if (totalShares != null) result.totalShares = totalShares;
    if (productsShown != null) result.productsShown = productsShown;
    if (ordersDuringLive != null) result.ordersDuringLive = ordersDuringLive;
    if (revenueDuringLive != null) result.revenueDuringLive = revenueDuringLive;
    if (engagementRate != null) result.engagementRate = engagementRate;
    return result;
  }

  LiveMetricsSnapshot._();

  factory LiveMetricsSnapshot.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      LiveMetricsSnapshot()..mergeFromBuffer(data, registry);
  factory LiveMetricsSnapshot.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      LiveMetricsSnapshot()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'LiveMetricsSnapshot',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: LiveMetricsSnapshot.$_createMessage)
    ..aInt64(1, _omitFieldNames ? '' : 'peakViewers')
    ..aInt64(2, _omitFieldNames ? '' : 'avgViewers')
    ..aInt64(3, _omitFieldNames ? '' : 'totalViewers')
    ..aInt64(4, _omitFieldNames ? '' : 'totalComments')
    ..aInt64(5, _omitFieldNames ? '' : 'totalLikes')
    ..aInt64(6, _omitFieldNames ? '' : 'totalShares')
    ..aI(7, _omitFieldNames ? '' : 'productsShown')
    ..aInt64(8, _omitFieldNames ? '' : 'ordersDuringLive')
    ..aOM<$2.Money>(9, _omitFieldNames ? '' : 'revenueDuringLive',
        subBuilder: $2.Money.$_createMessage)
    ..aD(10, _omitFieldNames ? '' : 'engagementRate')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LiveMetricsSnapshot clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LiveMetricsSnapshot copyWith(void Function(LiveMetricsSnapshot) updates) =>
      super.copyWith((message) => updates(message as LiveMetricsSnapshot))
          as LiveMetricsSnapshot;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core
      .Deprecated('Use LiveMetricsSnapshot() / LiveMetricsSnapshot.new instead')
  static LiveMetricsSnapshot create() => LiveMetricsSnapshot._();
  static $pb.GeneratedMessage $_createMessage() => LiveMetricsSnapshot._();
  @$core.override
  LiveMetricsSnapshot createEmptyInstance() => LiveMetricsSnapshot._();
  @$core.pragma('dart2js:noInline')
  static LiveMetricsSnapshot getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<LiveMetricsSnapshot>(
          LiveMetricsSnapshot.$_createMessage);
  static LiveMetricsSnapshot? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get peakViewers => $_getI64(0);
  @$pb.TagNumber(1)
  set peakViewers($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPeakViewers() => $_has(0);
  @$pb.TagNumber(1)
  void clearPeakViewers() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get avgViewers => $_getI64(1);
  @$pb.TagNumber(2)
  set avgViewers($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasAvgViewers() => $_has(1);
  @$pb.TagNumber(2)
  void clearAvgViewers() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get totalViewers => $_getI64(2);
  @$pb.TagNumber(3)
  set totalViewers($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasTotalViewers() => $_has(2);
  @$pb.TagNumber(3)
  void clearTotalViewers() => $_clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get totalComments => $_getI64(3);
  @$pb.TagNumber(4)
  set totalComments($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasTotalComments() => $_has(3);
  @$pb.TagNumber(4)
  void clearTotalComments() => $_clearField(4);

  @$pb.TagNumber(5)
  $fixnum.Int64 get totalLikes => $_getI64(4);
  @$pb.TagNumber(5)
  set totalLikes($fixnum.Int64 value) => $_setInt64(4, value);
  @$pb.TagNumber(5)
  $core.bool hasTotalLikes() => $_has(4);
  @$pb.TagNumber(5)
  void clearTotalLikes() => $_clearField(5);

  @$pb.TagNumber(6)
  $fixnum.Int64 get totalShares => $_getI64(5);
  @$pb.TagNumber(6)
  set totalShares($fixnum.Int64 value) => $_setInt64(5, value);
  @$pb.TagNumber(6)
  $core.bool hasTotalShares() => $_has(5);
  @$pb.TagNumber(6)
  void clearTotalShares() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.int get productsShown => $_getIZ(6);
  @$pb.TagNumber(7)
  set productsShown($core.int value) => $_setSignedInt32(6, value);
  @$pb.TagNumber(7)
  $core.bool hasProductsShown() => $_has(6);
  @$pb.TagNumber(7)
  void clearProductsShown() => $_clearField(7);

  @$pb.TagNumber(8)
  $fixnum.Int64 get ordersDuringLive => $_getI64(7);
  @$pb.TagNumber(8)
  set ordersDuringLive($fixnum.Int64 value) => $_setInt64(7, value);
  @$pb.TagNumber(8)
  $core.bool hasOrdersDuringLive() => $_has(7);
  @$pb.TagNumber(8)
  void clearOrdersDuringLive() => $_clearField(8);

  @$pb.TagNumber(9)
  $2.Money get revenueDuringLive => $_getN(8);
  @$pb.TagNumber(9)
  set revenueDuringLive($2.Money value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasRevenueDuringLive() => $_has(8);
  @$pb.TagNumber(9)
  void clearRevenueDuringLive() => $_clearField(9);
  @$pb.TagNumber(9)
  $2.Money ensureRevenueDuringLive() => $_ensure(8);

  @$pb.TagNumber(10)
  $core.double get engagementRate => $_getN(9);
  @$pb.TagNumber(10)
  set engagementRate($core.double value) => $_setDouble(9, value);
  @$pb.TagNumber(10)
  $core.bool hasEngagementRate() => $_has(9);
  @$pb.TagNumber(10)
  void clearEngagementRate() => $_clearField(10);
}

/// LiveSession corresponds to database_schema.md §12.1 live_sessions.
class LiveSession extends $pb.GeneratedMessage {
  factory LiveSession({
    $core.String? sessionId,
    $core.String? workspaceId,
    $core.String? title,
    $core.String? platform,
    $core.String? connectedAccountId,
    LiveSessionStatus? status,
    $1.Timestamp? plannedStartAt,
    $1.Timestamp? actualStartAt,
    $1.Timestamp? actualEndAt,
    $core.Iterable<RunOfShowItem>? runOfShow,
    LiveMetricsSnapshot? metricsSnapshot,
    $core.Iterable<$core.MapEntry<$core.String, $core.String>>? metadata,
    $1.Timestamp? createdAt,
    $1.Timestamp? updatedAt,
  }) {
    final result = LiveSession._();
    if (sessionId != null) result.sessionId = sessionId;
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (title != null) result.title = title;
    if (platform != null) result.platform = platform;
    if (connectedAccountId != null)
      result.connectedAccountId = connectedAccountId;
    if (status != null) result.status = status;
    if (plannedStartAt != null) result.plannedStartAt = plannedStartAt;
    if (actualStartAt != null) result.actualStartAt = actualStartAt;
    if (actualEndAt != null) result.actualEndAt = actualEndAt;
    if (runOfShow != null) result.runOfShow.addAll(runOfShow);
    if (metricsSnapshot != null) result.metricsSnapshot = metricsSnapshot;
    if (metadata != null) result.metadata.addEntries(metadata);
    if (createdAt != null) result.createdAt = createdAt;
    if (updatedAt != null) result.updatedAt = updatedAt;
    return result;
  }

  LiveSession._();

  factory LiveSession.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      LiveSession()..mergeFromBuffer(data, registry);
  factory LiveSession.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      LiveSession()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'LiveSession',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: LiveSession.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'sessionId')
    ..aOS(2, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(3, _omitFieldNames ? '' : 'title')
    ..aOS(4, _omitFieldNames ? '' : 'platform')
    ..aOS(5, _omitFieldNames ? '' : 'connectedAccountId')
    ..aE<LiveSessionStatus>(6, _omitFieldNames ? '' : 'status',
        enumValues: LiveSessionStatus.values)
    ..aOM<$1.Timestamp>(7, _omitFieldNames ? '' : 'plannedStartAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..aOM<$1.Timestamp>(8, _omitFieldNames ? '' : 'actualStartAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..aOM<$1.Timestamp>(9, _omitFieldNames ? '' : 'actualEndAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..pPM<RunOfShowItem>(10, _omitFieldNames ? '' : 'runOfShow',
        subBuilder: RunOfShowItem.$_createMessage)
    ..aOM<LiveMetricsSnapshot>(11, _omitFieldNames ? '' : 'metricsSnapshot',
        subBuilder: LiveMetricsSnapshot.$_createMessage)
    ..m<$core.String, $core.String>(12, _omitFieldNames ? '' : 'metadata',
        entryClassName: 'LiveSession.MetadataEntry',
        keyFieldType: $pb.PbFieldType.OS,
        valueFieldType: $pb.PbFieldType.OS,
        packageName: const $pb.PackageName('creativanta.commerce.v1'))
    ..aOM<$1.Timestamp>(13, _omitFieldNames ? '' : 'createdAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..aOM<$1.Timestamp>(14, _omitFieldNames ? '' : 'updatedAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LiveSession clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LiveSession copyWith(void Function(LiveSession) updates) =>
      super.copyWith((message) => updates(message as LiveSession))
          as LiveSession;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use LiveSession() / LiveSession.new instead')
  static LiveSession create() => LiveSession._();
  static $pb.GeneratedMessage $_createMessage() => LiveSession._();
  @$core.override
  LiveSession createEmptyInstance() => LiveSession._();
  @$core.pragma('dart2js:noInline')
  static LiveSession getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<LiveSession>(
          LiveSession.$_createMessage);
  static LiveSession? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get sessionId => $_getSZ(0);
  @$pb.TagNumber(1)
  set sessionId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSessionId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSessionId() => $_clearField(1);

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
  $core.String get platform => $_getSZ(3);
  @$pb.TagNumber(4)
  set platform($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasPlatform() => $_has(3);
  @$pb.TagNumber(4)
  void clearPlatform() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get connectedAccountId => $_getSZ(4);
  @$pb.TagNumber(5)
  set connectedAccountId($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasConnectedAccountId() => $_has(4);
  @$pb.TagNumber(5)
  void clearConnectedAccountId() => $_clearField(5);

  @$pb.TagNumber(6)
  LiveSessionStatus get status => $_getN(5);
  @$pb.TagNumber(6)
  set status(LiveSessionStatus value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasStatus() => $_has(5);
  @$pb.TagNumber(6)
  void clearStatus() => $_clearField(6);

  @$pb.TagNumber(7)
  $1.Timestamp get plannedStartAt => $_getN(6);
  @$pb.TagNumber(7)
  set plannedStartAt($1.Timestamp value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasPlannedStartAt() => $_has(6);
  @$pb.TagNumber(7)
  void clearPlannedStartAt() => $_clearField(7);
  @$pb.TagNumber(7)
  $1.Timestamp ensurePlannedStartAt() => $_ensure(6);

  @$pb.TagNumber(8)
  $1.Timestamp get actualStartAt => $_getN(7);
  @$pb.TagNumber(8)
  set actualStartAt($1.Timestamp value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasActualStartAt() => $_has(7);
  @$pb.TagNumber(8)
  void clearActualStartAt() => $_clearField(8);
  @$pb.TagNumber(8)
  $1.Timestamp ensureActualStartAt() => $_ensure(7);

  @$pb.TagNumber(9)
  $1.Timestamp get actualEndAt => $_getN(8);
  @$pb.TagNumber(9)
  set actualEndAt($1.Timestamp value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasActualEndAt() => $_has(8);
  @$pb.TagNumber(9)
  void clearActualEndAt() => $_clearField(9);
  @$pb.TagNumber(9)
  $1.Timestamp ensureActualEndAt() => $_ensure(8);

  @$pb.TagNumber(10)
  $pb.PbList<RunOfShowItem> get runOfShow => $_getList(9);

  @$pb.TagNumber(11)
  LiveMetricsSnapshot get metricsSnapshot => $_getN(10);
  @$pb.TagNumber(11)
  set metricsSnapshot(LiveMetricsSnapshot value) => $_setField(11, value);
  @$pb.TagNumber(11)
  $core.bool hasMetricsSnapshot() => $_has(10);
  @$pb.TagNumber(11)
  void clearMetricsSnapshot() => $_clearField(11);
  @$pb.TagNumber(11)
  LiveMetricsSnapshot ensureMetricsSnapshot() => $_ensure(10);

  @$pb.TagNumber(12)
  $pb.PbMap<$core.String, $core.String> get metadata => $_getMap(11);

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

/// CueCard corresponds to database_schema.md §19.9B cue_cards.
class CueCard extends $pb.GeneratedMessage {
  factory CueCard({
    $core.String? cueCardId,
    $core.String? sessionId,
    $core.String? workspaceId,
    $core.String? segmentId,
    $core.String? cueType,
    $core.String? title,
    $core.String? body,
    $core.String? pinnedProductId,
    $core.String? pinnedOfferId,
    $core.int? displayOrder,
    $1.Timestamp? triggeredAt,
    CueCardStatus? status,
    $1.Timestamp? createdAt,
    $1.Timestamp? updatedAt,
  }) {
    final result = CueCard._();
    if (cueCardId != null) result.cueCardId = cueCardId;
    if (sessionId != null) result.sessionId = sessionId;
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (segmentId != null) result.segmentId = segmentId;
    if (cueType != null) result.cueType = cueType;
    if (title != null) result.title = title;
    if (body != null) result.body = body;
    if (pinnedProductId != null) result.pinnedProductId = pinnedProductId;
    if (pinnedOfferId != null) result.pinnedOfferId = pinnedOfferId;
    if (displayOrder != null) result.displayOrder = displayOrder;
    if (triggeredAt != null) result.triggeredAt = triggeredAt;
    if (status != null) result.status = status;
    if (createdAt != null) result.createdAt = createdAt;
    if (updatedAt != null) result.updatedAt = updatedAt;
    return result;
  }

  CueCard._();

  factory CueCard.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CueCard()..mergeFromBuffer(data, registry);
  factory CueCard.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CueCard()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CueCard',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: CueCard.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'cueCardId')
    ..aOS(2, _omitFieldNames ? '' : 'sessionId')
    ..aOS(3, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(4, _omitFieldNames ? '' : 'segmentId')
    ..aOS(5, _omitFieldNames ? '' : 'cueType')
    ..aOS(6, _omitFieldNames ? '' : 'title')
    ..aOS(7, _omitFieldNames ? '' : 'body')
    ..aOS(8, _omitFieldNames ? '' : 'pinnedProductId')
    ..aOS(9, _omitFieldNames ? '' : 'pinnedOfferId')
    ..aI(10, _omitFieldNames ? '' : 'displayOrder')
    ..aOM<$1.Timestamp>(11, _omitFieldNames ? '' : 'triggeredAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..aE<CueCardStatus>(12, _omitFieldNames ? '' : 'status',
        enumValues: CueCardStatus.values)
    ..aOM<$1.Timestamp>(13, _omitFieldNames ? '' : 'createdAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..aOM<$1.Timestamp>(14, _omitFieldNames ? '' : 'updatedAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CueCard clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CueCard copyWith(void Function(CueCard) updates) =>
      super.copyWith((message) => updates(message as CueCard)) as CueCard;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use CueCard() / CueCard.new instead')
  static CueCard create() => CueCard._();
  static $pb.GeneratedMessage $_createMessage() => CueCard._();
  @$core.override
  CueCard createEmptyInstance() => CueCard._();
  @$core.pragma('dart2js:noInline')
  static CueCard getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CueCard>(CueCard.$_createMessage);
  static CueCard? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get cueCardId => $_getSZ(0);
  @$pb.TagNumber(1)
  set cueCardId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCueCardId() => $_has(0);
  @$pb.TagNumber(1)
  void clearCueCardId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get sessionId => $_getSZ(1);
  @$pb.TagNumber(2)
  set sessionId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSessionId() => $_has(1);
  @$pb.TagNumber(2)
  void clearSessionId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get workspaceId => $_getSZ(2);
  @$pb.TagNumber(3)
  set workspaceId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasWorkspaceId() => $_has(2);
  @$pb.TagNumber(3)
  void clearWorkspaceId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get segmentId => $_getSZ(3);
  @$pb.TagNumber(4)
  set segmentId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasSegmentId() => $_has(3);
  @$pb.TagNumber(4)
  void clearSegmentId() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get cueType => $_getSZ(4);
  @$pb.TagNumber(5)
  set cueType($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasCueType() => $_has(4);
  @$pb.TagNumber(5)
  void clearCueType() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get title => $_getSZ(5);
  @$pb.TagNumber(6)
  set title($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasTitle() => $_has(5);
  @$pb.TagNumber(6)
  void clearTitle() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get body => $_getSZ(6);
  @$pb.TagNumber(7)
  set body($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasBody() => $_has(6);
  @$pb.TagNumber(7)
  void clearBody() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get pinnedProductId => $_getSZ(7);
  @$pb.TagNumber(8)
  set pinnedProductId($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasPinnedProductId() => $_has(7);
  @$pb.TagNumber(8)
  void clearPinnedProductId() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get pinnedOfferId => $_getSZ(8);
  @$pb.TagNumber(9)
  set pinnedOfferId($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasPinnedOfferId() => $_has(8);
  @$pb.TagNumber(9)
  void clearPinnedOfferId() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.int get displayOrder => $_getIZ(9);
  @$pb.TagNumber(10)
  set displayOrder($core.int value) => $_setSignedInt32(9, value);
  @$pb.TagNumber(10)
  $core.bool hasDisplayOrder() => $_has(9);
  @$pb.TagNumber(10)
  void clearDisplayOrder() => $_clearField(10);

  @$pb.TagNumber(11)
  $1.Timestamp get triggeredAt => $_getN(10);
  @$pb.TagNumber(11)
  set triggeredAt($1.Timestamp value) => $_setField(11, value);
  @$pb.TagNumber(11)
  $core.bool hasTriggeredAt() => $_has(10);
  @$pb.TagNumber(11)
  void clearTriggeredAt() => $_clearField(11);
  @$pb.TagNumber(11)
  $1.Timestamp ensureTriggeredAt() => $_ensure(10);

  @$pb.TagNumber(12)
  CueCardStatus get status => $_getN(11);
  @$pb.TagNumber(12)
  set status(CueCardStatus value) => $_setField(12, value);
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

/// Highlight corresponds to database_schema.md §19.9C highlights.
class Highlight extends $pb.GeneratedMessage {
  factory Highlight({
    $core.String? highlightId,
    $core.String? sessionId,
    $core.String? workspaceId,
    $core.String? title,
    $core.int? startOffsetSeconds,
    $core.int? endOffsetSeconds,
    $core.String? highlightType,
    $core.bool? autoDetected,
    $core.String? assetId,
    $core.double? engagementScore,
    $core.String? notes,
    $core.String? pinnedOfferId,
    $core.String? pinnedProductId,
    $1.Timestamp? createdAt,
    $1.Timestamp? updatedAt,
  }) {
    final result = Highlight._();
    if (highlightId != null) result.highlightId = highlightId;
    if (sessionId != null) result.sessionId = sessionId;
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (title != null) result.title = title;
    if (startOffsetSeconds != null)
      result.startOffsetSeconds = startOffsetSeconds;
    if (endOffsetSeconds != null) result.endOffsetSeconds = endOffsetSeconds;
    if (highlightType != null) result.highlightType = highlightType;
    if (autoDetected != null) result.autoDetected = autoDetected;
    if (assetId != null) result.assetId = assetId;
    if (engagementScore != null) result.engagementScore = engagementScore;
    if (notes != null) result.notes = notes;
    if (pinnedOfferId != null) result.pinnedOfferId = pinnedOfferId;
    if (pinnedProductId != null) result.pinnedProductId = pinnedProductId;
    if (createdAt != null) result.createdAt = createdAt;
    if (updatedAt != null) result.updatedAt = updatedAt;
    return result;
  }

  Highlight._();

  factory Highlight.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Highlight()..mergeFromBuffer(data, registry);
  factory Highlight.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Highlight()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Highlight',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: Highlight.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'highlightId')
    ..aOS(2, _omitFieldNames ? '' : 'sessionId')
    ..aOS(3, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(4, _omitFieldNames ? '' : 'title')
    ..aI(5, _omitFieldNames ? '' : 'startOffsetSeconds')
    ..aI(6, _omitFieldNames ? '' : 'endOffsetSeconds')
    ..aOS(7, _omitFieldNames ? '' : 'highlightType')
    ..aOB(8, _omitFieldNames ? '' : 'autoDetected')
    ..aOS(9, _omitFieldNames ? '' : 'assetId')
    ..aD(10, _omitFieldNames ? '' : 'engagementScore')
    ..aOS(11, _omitFieldNames ? '' : 'notes')
    ..aOS(12, _omitFieldNames ? '' : 'pinnedOfferId')
    ..aOS(13, _omitFieldNames ? '' : 'pinnedProductId')
    ..aOM<$1.Timestamp>(14, _omitFieldNames ? '' : 'createdAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..aOM<$1.Timestamp>(15, _omitFieldNames ? '' : 'updatedAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Highlight clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Highlight copyWith(void Function(Highlight) updates) =>
      super.copyWith((message) => updates(message as Highlight)) as Highlight;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use Highlight() / Highlight.new instead')
  static Highlight create() => Highlight._();
  static $pb.GeneratedMessage $_createMessage() => Highlight._();
  @$core.override
  Highlight createEmptyInstance() => Highlight._();
  @$core.pragma('dart2js:noInline')
  static Highlight getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Highlight>(Highlight.$_createMessage);
  static Highlight? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get highlightId => $_getSZ(0);
  @$pb.TagNumber(1)
  set highlightId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasHighlightId() => $_has(0);
  @$pb.TagNumber(1)
  void clearHighlightId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get sessionId => $_getSZ(1);
  @$pb.TagNumber(2)
  set sessionId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSessionId() => $_has(1);
  @$pb.TagNumber(2)
  void clearSessionId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get workspaceId => $_getSZ(2);
  @$pb.TagNumber(3)
  set workspaceId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasWorkspaceId() => $_has(2);
  @$pb.TagNumber(3)
  void clearWorkspaceId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get title => $_getSZ(3);
  @$pb.TagNumber(4)
  set title($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasTitle() => $_has(3);
  @$pb.TagNumber(4)
  void clearTitle() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get startOffsetSeconds => $_getIZ(4);
  @$pb.TagNumber(5)
  set startOffsetSeconds($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasStartOffsetSeconds() => $_has(4);
  @$pb.TagNumber(5)
  void clearStartOffsetSeconds() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.int get endOffsetSeconds => $_getIZ(5);
  @$pb.TagNumber(6)
  set endOffsetSeconds($core.int value) => $_setSignedInt32(5, value);
  @$pb.TagNumber(6)
  $core.bool hasEndOffsetSeconds() => $_has(5);
  @$pb.TagNumber(6)
  void clearEndOffsetSeconds() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get highlightType => $_getSZ(6);
  @$pb.TagNumber(7)
  set highlightType($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasHighlightType() => $_has(6);
  @$pb.TagNumber(7)
  void clearHighlightType() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.bool get autoDetected => $_getBF(7);
  @$pb.TagNumber(8)
  set autoDetected($core.bool value) => $_setBool(7, value);
  @$pb.TagNumber(8)
  $core.bool hasAutoDetected() => $_has(7);
  @$pb.TagNumber(8)
  void clearAutoDetected() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get assetId => $_getSZ(8);
  @$pb.TagNumber(9)
  set assetId($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasAssetId() => $_has(8);
  @$pb.TagNumber(9)
  void clearAssetId() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.double get engagementScore => $_getN(9);
  @$pb.TagNumber(10)
  set engagementScore($core.double value) => $_setDouble(9, value);
  @$pb.TagNumber(10)
  $core.bool hasEngagementScore() => $_has(9);
  @$pb.TagNumber(10)
  void clearEngagementScore() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.String get notes => $_getSZ(10);
  @$pb.TagNumber(11)
  set notes($core.String value) => $_setString(10, value);
  @$pb.TagNumber(11)
  $core.bool hasNotes() => $_has(10);
  @$pb.TagNumber(11)
  void clearNotes() => $_clearField(11);

  @$pb.TagNumber(12)
  $core.String get pinnedOfferId => $_getSZ(11);
  @$pb.TagNumber(12)
  set pinnedOfferId($core.String value) => $_setString(11, value);
  @$pb.TagNumber(12)
  $core.bool hasPinnedOfferId() => $_has(11);
  @$pb.TagNumber(12)
  void clearPinnedOfferId() => $_clearField(12);

  @$pb.TagNumber(13)
  $core.String get pinnedProductId => $_getSZ(12);
  @$pb.TagNumber(13)
  set pinnedProductId($core.String value) => $_setString(12, value);
  @$pb.TagNumber(13)
  $core.bool hasPinnedProductId() => $_has(12);
  @$pb.TagNumber(13)
  void clearPinnedProductId() => $_clearField(13);

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

/// TraceableOrderLink represents a traceable revenue chain link:
/// Live Session -> Product -> Offer -> Order -> Revenue.
class TraceableOrderLink extends $pb.GeneratedMessage {
  factory TraceableOrderLink({
    $core.String? orderId,
    $core.String? productId,
    $core.String? offerId,
    $core.String? customerId,
    $2.Money? amount,
    $1.Timestamp? createdAt,
    $core.String? reconciliationState,
  }) {
    final result = TraceableOrderLink._();
    if (orderId != null) result.orderId = orderId;
    if (productId != null) result.productId = productId;
    if (offerId != null) result.offerId = offerId;
    if (customerId != null) result.customerId = customerId;
    if (amount != null) result.amount = amount;
    if (createdAt != null) result.createdAt = createdAt;
    if (reconciliationState != null)
      result.reconciliationState = reconciliationState;
    return result;
  }

  TraceableOrderLink._();

  factory TraceableOrderLink.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      TraceableOrderLink()..mergeFromBuffer(data, registry);
  factory TraceableOrderLink.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      TraceableOrderLink()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TraceableOrderLink',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: TraceableOrderLink.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'orderId')
    ..aOS(2, _omitFieldNames ? '' : 'productId')
    ..aOS(3, _omitFieldNames ? '' : 'offerId')
    ..aOS(4, _omitFieldNames ? '' : 'customerId')
    ..aOM<$2.Money>(5, _omitFieldNames ? '' : 'amount',
        subBuilder: $2.Money.$_createMessage)
    ..aOM<$1.Timestamp>(6, _omitFieldNames ? '' : 'createdAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..aOS(7, _omitFieldNames ? '' : 'reconciliationState')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TraceableOrderLink clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TraceableOrderLink copyWith(void Function(TraceableOrderLink) updates) =>
      super.copyWith((message) => updates(message as TraceableOrderLink))
          as TraceableOrderLink;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use TraceableOrderLink() / TraceableOrderLink.new instead')
  static TraceableOrderLink create() => TraceableOrderLink._();
  static $pb.GeneratedMessage $_createMessage() => TraceableOrderLink._();
  @$core.override
  TraceableOrderLink createEmptyInstance() => TraceableOrderLink._();
  @$core.pragma('dart2js:noInline')
  static TraceableOrderLink getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<TraceableOrderLink>(
          TraceableOrderLink.$_createMessage);
  static TraceableOrderLink? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get orderId => $_getSZ(0);
  @$pb.TagNumber(1)
  set orderId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasOrderId() => $_has(0);
  @$pb.TagNumber(1)
  void clearOrderId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get productId => $_getSZ(1);
  @$pb.TagNumber(2)
  set productId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasProductId() => $_has(1);
  @$pb.TagNumber(2)
  void clearProductId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get offerId => $_getSZ(2);
  @$pb.TagNumber(3)
  set offerId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasOfferId() => $_has(2);
  @$pb.TagNumber(3)
  void clearOfferId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get customerId => $_getSZ(3);
  @$pb.TagNumber(4)
  set customerId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasCustomerId() => $_has(3);
  @$pb.TagNumber(4)
  void clearCustomerId() => $_clearField(4);

  @$pb.TagNumber(5)
  $2.Money get amount => $_getN(4);
  @$pb.TagNumber(5)
  set amount($2.Money value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasAmount() => $_has(4);
  @$pb.TagNumber(5)
  void clearAmount() => $_clearField(5);
  @$pb.TagNumber(5)
  $2.Money ensureAmount() => $_ensure(4);

  @$pb.TagNumber(6)
  $1.Timestamp get createdAt => $_getN(5);
  @$pb.TagNumber(6)
  set createdAt($1.Timestamp value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasCreatedAt() => $_has(5);
  @$pb.TagNumber(6)
  void clearCreatedAt() => $_clearField(6);
  @$pb.TagNumber(6)
  $1.Timestamp ensureCreatedAt() => $_ensure(5);

  @$pb.TagNumber(7)
  $core.String get reconciliationState => $_getSZ(6);
  @$pb.TagNumber(7)
  set reconciliationState($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasReconciliationState() => $_has(6);
  @$pb.TagNumber(7)
  void clearReconciliationState() => $_clearField(7);
}

/// PostLiveProofSummary represents the post-live proof document (RULE-M17-003, RULE-M17-004).
class PostLiveProofSummary extends $pb.GeneratedMessage {
  factory PostLiveProofSummary({
    $core.String? summaryId,
    $core.String? sessionId,
    $core.String? workspaceId,
    $core.String? sessionTitle,
    $core.String? platform,
    LiveMetricsSnapshot? metrics,
    $core.Iterable<Highlight>? highlights,
    $core.Iterable<$core.String>? extractedClipAssetIds,
    $core.Iterable<TraceableOrderLink>? orders,
    $2.Money? totalRevenue,
    $core.String? sourceClass,
    $core.String? proofBundleId,
    $1.Timestamp? generatedAt,
  }) {
    final result = PostLiveProofSummary._();
    if (summaryId != null) result.summaryId = summaryId;
    if (sessionId != null) result.sessionId = sessionId;
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (sessionTitle != null) result.sessionTitle = sessionTitle;
    if (platform != null) result.platform = platform;
    if (metrics != null) result.metrics = metrics;
    if (highlights != null) result.highlights.addAll(highlights);
    if (extractedClipAssetIds != null)
      result.extractedClipAssetIds.addAll(extractedClipAssetIds);
    if (orders != null) result.orders.addAll(orders);
    if (totalRevenue != null) result.totalRevenue = totalRevenue;
    if (sourceClass != null) result.sourceClass = sourceClass;
    if (proofBundleId != null) result.proofBundleId = proofBundleId;
    if (generatedAt != null) result.generatedAt = generatedAt;
    return result;
  }

  PostLiveProofSummary._();

  factory PostLiveProofSummary.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PostLiveProofSummary()..mergeFromBuffer(data, registry);
  factory PostLiveProofSummary.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PostLiveProofSummary()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PostLiveProofSummary',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: PostLiveProofSummary.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'summaryId')
    ..aOS(2, _omitFieldNames ? '' : 'sessionId')
    ..aOS(3, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(4, _omitFieldNames ? '' : 'sessionTitle')
    ..aOS(5, _omitFieldNames ? '' : 'platform')
    ..aOM<LiveMetricsSnapshot>(6, _omitFieldNames ? '' : 'metrics',
        subBuilder: LiveMetricsSnapshot.$_createMessage)
    ..pPM<Highlight>(7, _omitFieldNames ? '' : 'highlights',
        subBuilder: Highlight.$_createMessage)
    ..pPS(8, _omitFieldNames ? '' : 'extractedClipAssetIds')
    ..pPM<TraceableOrderLink>(9, _omitFieldNames ? '' : 'orders',
        subBuilder: TraceableOrderLink.$_createMessage)
    ..aOM<$2.Money>(10, _omitFieldNames ? '' : 'totalRevenue',
        subBuilder: $2.Money.$_createMessage)
    ..aOS(11, _omitFieldNames ? '' : 'sourceClass')
    ..aOS(12, _omitFieldNames ? '' : 'proofBundleId')
    ..aOM<$1.Timestamp>(13, _omitFieldNames ? '' : 'generatedAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PostLiveProofSummary clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PostLiveProofSummary copyWith(void Function(PostLiveProofSummary) updates) =>
      super.copyWith((message) => updates(message as PostLiveProofSummary))
          as PostLiveProofSummary;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use PostLiveProofSummary() / PostLiveProofSummary.new instead')
  static PostLiveProofSummary create() => PostLiveProofSummary._();
  static $pb.GeneratedMessage $_createMessage() => PostLiveProofSummary._();
  @$core.override
  PostLiveProofSummary createEmptyInstance() => PostLiveProofSummary._();
  @$core.pragma('dart2js:noInline')
  static PostLiveProofSummary getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PostLiveProofSummary>(
          PostLiveProofSummary.$_createMessage);
  static PostLiveProofSummary? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get summaryId => $_getSZ(0);
  @$pb.TagNumber(1)
  set summaryId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSummaryId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSummaryId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get sessionId => $_getSZ(1);
  @$pb.TagNumber(2)
  set sessionId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSessionId() => $_has(1);
  @$pb.TagNumber(2)
  void clearSessionId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get workspaceId => $_getSZ(2);
  @$pb.TagNumber(3)
  set workspaceId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasWorkspaceId() => $_has(2);
  @$pb.TagNumber(3)
  void clearWorkspaceId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get sessionTitle => $_getSZ(3);
  @$pb.TagNumber(4)
  set sessionTitle($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasSessionTitle() => $_has(3);
  @$pb.TagNumber(4)
  void clearSessionTitle() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get platform => $_getSZ(4);
  @$pb.TagNumber(5)
  set platform($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasPlatform() => $_has(4);
  @$pb.TagNumber(5)
  void clearPlatform() => $_clearField(5);

  @$pb.TagNumber(6)
  LiveMetricsSnapshot get metrics => $_getN(5);
  @$pb.TagNumber(6)
  set metrics(LiveMetricsSnapshot value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasMetrics() => $_has(5);
  @$pb.TagNumber(6)
  void clearMetrics() => $_clearField(6);
  @$pb.TagNumber(6)
  LiveMetricsSnapshot ensureMetrics() => $_ensure(5);

  @$pb.TagNumber(7)
  $pb.PbList<Highlight> get highlights => $_getList(6);

  @$pb.TagNumber(8)
  $pb.PbList<$core.String> get extractedClipAssetIds => $_getList(7);

  @$pb.TagNumber(9)
  $pb.PbList<TraceableOrderLink> get orders => $_getList(8);

  @$pb.TagNumber(10)
  $2.Money get totalRevenue => $_getN(9);
  @$pb.TagNumber(10)
  set totalRevenue($2.Money value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasTotalRevenue() => $_has(9);
  @$pb.TagNumber(10)
  void clearTotalRevenue() => $_clearField(10);
  @$pb.TagNumber(10)
  $2.Money ensureTotalRevenue() => $_ensure(9);

  @$pb.TagNumber(11)
  $core.String get sourceClass => $_getSZ(10);
  @$pb.TagNumber(11)
  set sourceClass($core.String value) => $_setString(10, value);
  @$pb.TagNumber(11)
  $core.bool hasSourceClass() => $_has(10);
  @$pb.TagNumber(11)
  void clearSourceClass() => $_clearField(11);

  @$pb.TagNumber(12)
  $core.String get proofBundleId => $_getSZ(11);
  @$pb.TagNumber(12)
  set proofBundleId($core.String value) => $_setString(11, value);
  @$pb.TagNumber(12)
  $core.bool hasProofBundleId() => $_has(11);
  @$pb.TagNumber(12)
  void clearProofBundleId() => $_clearField(12);

  @$pb.TagNumber(13)
  $1.Timestamp get generatedAt => $_getN(12);
  @$pb.TagNumber(13)
  set generatedAt($1.Timestamp value) => $_setField(13, value);
  @$pb.TagNumber(13)
  $core.bool hasGeneratedAt() => $_has(12);
  @$pb.TagNumber(13)
  void clearGeneratedAt() => $_clearField(13);
  @$pb.TagNumber(13)
  $1.Timestamp ensureGeneratedAt() => $_ensure(12);
}

/// CommentTriageItem represents high-priority audience interaction during live.
class CommentTriageItem extends $pb.GeneratedMessage {
  factory CommentTriageItem({
    $core.String? commentId,
    $core.String? sessionId,
    $core.String? author,
    $core.String? text,
    $core.String? intent,
    $core.bool? isPriority,
    $1.Timestamp? timestamp,
  }) {
    final result = CommentTriageItem._();
    if (commentId != null) result.commentId = commentId;
    if (sessionId != null) result.sessionId = sessionId;
    if (author != null) result.author = author;
    if (text != null) result.text = text;
    if (intent != null) result.intent = intent;
    if (isPriority != null) result.isPriority = isPriority;
    if (timestamp != null) result.timestamp = timestamp;
    return result;
  }

  CommentTriageItem._();

  factory CommentTriageItem.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CommentTriageItem()..mergeFromBuffer(data, registry);
  factory CommentTriageItem.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CommentTriageItem()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CommentTriageItem',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: CommentTriageItem.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'commentId')
    ..aOS(2, _omitFieldNames ? '' : 'sessionId')
    ..aOS(3, _omitFieldNames ? '' : 'author')
    ..aOS(4, _omitFieldNames ? '' : 'text')
    ..aOS(5, _omitFieldNames ? '' : 'intent')
    ..aOB(6, _omitFieldNames ? '' : 'isPriority')
    ..aOM<$1.Timestamp>(7, _omitFieldNames ? '' : 'timestamp',
        subBuilder: $1.Timestamp.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CommentTriageItem clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CommentTriageItem copyWith(void Function(CommentTriageItem) updates) =>
      super.copyWith((message) => updates(message as CommentTriageItem))
          as CommentTriageItem;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use CommentTriageItem() / CommentTriageItem.new instead')
  static CommentTriageItem create() => CommentTriageItem._();
  static $pb.GeneratedMessage $_createMessage() => CommentTriageItem._();
  @$core.override
  CommentTriageItem createEmptyInstance() => CommentTriageItem._();
  @$core.pragma('dart2js:noInline')
  static CommentTriageItem getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CommentTriageItem>(
          CommentTriageItem.$_createMessage);
  static CommentTriageItem? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get commentId => $_getSZ(0);
  @$pb.TagNumber(1)
  set commentId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCommentId() => $_has(0);
  @$pb.TagNumber(1)
  void clearCommentId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get sessionId => $_getSZ(1);
  @$pb.TagNumber(2)
  set sessionId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSessionId() => $_has(1);
  @$pb.TagNumber(2)
  void clearSessionId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get author => $_getSZ(2);
  @$pb.TagNumber(3)
  set author($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasAuthor() => $_has(2);
  @$pb.TagNumber(3)
  void clearAuthor() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get text => $_getSZ(3);
  @$pb.TagNumber(4)
  set text($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasText() => $_has(3);
  @$pb.TagNumber(4)
  void clearText() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get intent => $_getSZ(4);
  @$pb.TagNumber(5)
  set intent($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasIntent() => $_has(4);
  @$pb.TagNumber(5)
  void clearIntent() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.bool get isPriority => $_getBF(5);
  @$pb.TagNumber(6)
  set isPriority($core.bool value) => $_setBool(5, value);
  @$pb.TagNumber(6)
  $core.bool hasIsPriority() => $_has(5);
  @$pb.TagNumber(6)
  void clearIsPriority() => $_clearField(6);

  @$pb.TagNumber(7)
  $1.Timestamp get timestamp => $_getN(6);
  @$pb.TagNumber(7)
  set timestamp($1.Timestamp value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasTimestamp() => $_has(6);
  @$pb.TagNumber(7)
  void clearTimestamp() => $_clearField(7);
  @$pb.TagNumber(7)
  $1.Timestamp ensureTimestamp() => $_ensure(6);
}

class LiveCommerceServiceCreateSessionRequest extends $pb.GeneratedMessage {
  factory LiveCommerceServiceCreateSessionRequest({
    $2.CommandContext? context,
    $core.String? title,
    $core.String? platform,
    $core.String? connectedAccountId,
    $1.Timestamp? plannedStartAt,
    $core.Iterable<RunOfShowItem>? runOfShow,
    $core.Iterable<$core.MapEntry<$core.String, $core.String>>? metadata,
  }) {
    final result = LiveCommerceServiceCreateSessionRequest._();
    if (context != null) result.context = context;
    if (title != null) result.title = title;
    if (platform != null) result.platform = platform;
    if (connectedAccountId != null)
      result.connectedAccountId = connectedAccountId;
    if (plannedStartAt != null) result.plannedStartAt = plannedStartAt;
    if (runOfShow != null) result.runOfShow.addAll(runOfShow);
    if (metadata != null) result.metadata.addEntries(metadata);
    return result;
  }

  LiveCommerceServiceCreateSessionRequest._();

  factory LiveCommerceServiceCreateSessionRequest.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      LiveCommerceServiceCreateSessionRequest()
        ..mergeFromBuffer(data, registry);
  factory LiveCommerceServiceCreateSessionRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      LiveCommerceServiceCreateSessionRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'LiveCommerceServiceCreateSessionRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance:
          LiveCommerceServiceCreateSessionRequest.$_createMessage)
    ..aOM<$2.CommandContext>(1, _omitFieldNames ? '' : 'context',
        subBuilder: $2.CommandContext.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'title')
    ..aOS(3, _omitFieldNames ? '' : 'platform')
    ..aOS(4, _omitFieldNames ? '' : 'connectedAccountId')
    ..aOM<$1.Timestamp>(5, _omitFieldNames ? '' : 'plannedStartAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..pPM<RunOfShowItem>(6, _omitFieldNames ? '' : 'runOfShow',
        subBuilder: RunOfShowItem.$_createMessage)
    ..m<$core.String, $core.String>(7, _omitFieldNames ? '' : 'metadata',
        entryClassName: 'LiveCommerceServiceCreateSessionRequest.MetadataEntry',
        keyFieldType: $pb.PbFieldType.OS,
        valueFieldType: $pb.PbFieldType.OS,
        packageName: const $pb.PackageName('creativanta.commerce.v1'))
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LiveCommerceServiceCreateSessionRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LiveCommerceServiceCreateSessionRequest copyWith(
          void Function(LiveCommerceServiceCreateSessionRequest) updates) =>
      super.copyWith((message) =>
              updates(message as LiveCommerceServiceCreateSessionRequest))
          as LiveCommerceServiceCreateSessionRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use LiveCommerceServiceCreateSessionRequest() / LiveCommerceServiceCreateSessionRequest.new instead')
  static LiveCommerceServiceCreateSessionRequest create() =>
      LiveCommerceServiceCreateSessionRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      LiveCommerceServiceCreateSessionRequest._();
  @$core.override
  LiveCommerceServiceCreateSessionRequest createEmptyInstance() =>
      LiveCommerceServiceCreateSessionRequest._();
  @$core.pragma('dart2js:noInline')
  static LiveCommerceServiceCreateSessionRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
              LiveCommerceServiceCreateSessionRequest>(
          LiveCommerceServiceCreateSessionRequest.$_createMessage);
  static LiveCommerceServiceCreateSessionRequest? _defaultInstance;

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
  $core.String get platform => $_getSZ(2);
  @$pb.TagNumber(3)
  set platform($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPlatform() => $_has(2);
  @$pb.TagNumber(3)
  void clearPlatform() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get connectedAccountId => $_getSZ(3);
  @$pb.TagNumber(4)
  set connectedAccountId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasConnectedAccountId() => $_has(3);
  @$pb.TagNumber(4)
  void clearConnectedAccountId() => $_clearField(4);

  @$pb.TagNumber(5)
  $1.Timestamp get plannedStartAt => $_getN(4);
  @$pb.TagNumber(5)
  set plannedStartAt($1.Timestamp value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasPlannedStartAt() => $_has(4);
  @$pb.TagNumber(5)
  void clearPlannedStartAt() => $_clearField(5);
  @$pb.TagNumber(5)
  $1.Timestamp ensurePlannedStartAt() => $_ensure(4);

  @$pb.TagNumber(6)
  $pb.PbList<RunOfShowItem> get runOfShow => $_getList(5);

  @$pb.TagNumber(7)
  $pb.PbMap<$core.String, $core.String> get metadata => $_getMap(6);
}

class LiveCommerceServiceCreateSessionResponse extends $pb.GeneratedMessage {
  factory LiveCommerceServiceCreateSessionResponse({
    LiveSession? session,
    $core.bool? isDuplicate,
  }) {
    final result = LiveCommerceServiceCreateSessionResponse._();
    if (session != null) result.session = session;
    if (isDuplicate != null) result.isDuplicate = isDuplicate;
    return result;
  }

  LiveCommerceServiceCreateSessionResponse._();

  factory LiveCommerceServiceCreateSessionResponse.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      LiveCommerceServiceCreateSessionResponse()
        ..mergeFromBuffer(data, registry);
  factory LiveCommerceServiceCreateSessionResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      LiveCommerceServiceCreateSessionResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'LiveCommerceServiceCreateSessionResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance:
          LiveCommerceServiceCreateSessionResponse.$_createMessage)
    ..aOM<LiveSession>(1, _omitFieldNames ? '' : 'session',
        subBuilder: LiveSession.$_createMessage)
    ..aOB(2, _omitFieldNames ? '' : 'isDuplicate')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LiveCommerceServiceCreateSessionResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LiveCommerceServiceCreateSessionResponse copyWith(
          void Function(LiveCommerceServiceCreateSessionResponse) updates) =>
      super.copyWith((message) =>
              updates(message as LiveCommerceServiceCreateSessionResponse))
          as LiveCommerceServiceCreateSessionResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use LiveCommerceServiceCreateSessionResponse() / LiveCommerceServiceCreateSessionResponse.new instead')
  static LiveCommerceServiceCreateSessionResponse create() =>
      LiveCommerceServiceCreateSessionResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      LiveCommerceServiceCreateSessionResponse._();
  @$core.override
  LiveCommerceServiceCreateSessionResponse createEmptyInstance() =>
      LiveCommerceServiceCreateSessionResponse._();
  @$core.pragma('dart2js:noInline')
  static LiveCommerceServiceCreateSessionResponse getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
              LiveCommerceServiceCreateSessionResponse>(
          LiveCommerceServiceCreateSessionResponse.$_createMessage);
  static LiveCommerceServiceCreateSessionResponse? _defaultInstance;

  @$pb.TagNumber(1)
  LiveSession get session => $_getN(0);
  @$pb.TagNumber(1)
  set session(LiveSession value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasSession() => $_has(0);
  @$pb.TagNumber(1)
  void clearSession() => $_clearField(1);
  @$pb.TagNumber(1)
  LiveSession ensureSession() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.bool get isDuplicate => $_getBF(1);
  @$pb.TagNumber(2)
  set isDuplicate($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasIsDuplicate() => $_has(1);
  @$pb.TagNumber(2)
  void clearIsDuplicate() => $_clearField(2);
}

class LiveCommerceServiceGetRequest extends $pb.GeneratedMessage {
  factory LiveCommerceServiceGetRequest({
    $core.String? sessionId,
    $core.String? workspaceId,
  }) {
    final result = LiveCommerceServiceGetRequest._();
    if (sessionId != null) result.sessionId = sessionId;
    if (workspaceId != null) result.workspaceId = workspaceId;
    return result;
  }

  LiveCommerceServiceGetRequest._();

  factory LiveCommerceServiceGetRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      LiveCommerceServiceGetRequest()..mergeFromBuffer(data, registry);
  factory LiveCommerceServiceGetRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      LiveCommerceServiceGetRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'LiveCommerceServiceGetRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: LiveCommerceServiceGetRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'sessionId')
    ..aOS(2, _omitFieldNames ? '' : 'workspaceId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LiveCommerceServiceGetRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LiveCommerceServiceGetRequest copyWith(
          void Function(LiveCommerceServiceGetRequest) updates) =>
      super.copyWith(
              (message) => updates(message as LiveCommerceServiceGetRequest))
          as LiveCommerceServiceGetRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use LiveCommerceServiceGetRequest() / LiveCommerceServiceGetRequest.new instead')
  static LiveCommerceServiceGetRequest create() =>
      LiveCommerceServiceGetRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      LiveCommerceServiceGetRequest._();
  @$core.override
  LiveCommerceServiceGetRequest createEmptyInstance() =>
      LiveCommerceServiceGetRequest._();
  @$core.pragma('dart2js:noInline')
  static LiveCommerceServiceGetRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<LiveCommerceServiceGetRequest>(
          LiveCommerceServiceGetRequest.$_createMessage);
  static LiveCommerceServiceGetRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get sessionId => $_getSZ(0);
  @$pb.TagNumber(1)
  set sessionId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSessionId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSessionId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get workspaceId => $_getSZ(1);
  @$pb.TagNumber(2)
  set workspaceId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasWorkspaceId() => $_has(1);
  @$pb.TagNumber(2)
  void clearWorkspaceId() => $_clearField(2);
}

class LiveCommerceServiceGetResponse extends $pb.GeneratedMessage {
  factory LiveCommerceServiceGetResponse({
    LiveSession? session,
    $core.Iterable<CueCard>? cueCards,
    $core.Iterable<Highlight>? highlights,
  }) {
    final result = LiveCommerceServiceGetResponse._();
    if (session != null) result.session = session;
    if (cueCards != null) result.cueCards.addAll(cueCards);
    if (highlights != null) result.highlights.addAll(highlights);
    return result;
  }

  LiveCommerceServiceGetResponse._();

  factory LiveCommerceServiceGetResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      LiveCommerceServiceGetResponse()..mergeFromBuffer(data, registry);
  factory LiveCommerceServiceGetResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      LiveCommerceServiceGetResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'LiveCommerceServiceGetResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: LiveCommerceServiceGetResponse.$_createMessage)
    ..aOM<LiveSession>(1, _omitFieldNames ? '' : 'session',
        subBuilder: LiveSession.$_createMessage)
    ..pPM<CueCard>(2, _omitFieldNames ? '' : 'cueCards',
        subBuilder: CueCard.$_createMessage)
    ..pPM<Highlight>(3, _omitFieldNames ? '' : 'highlights',
        subBuilder: Highlight.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LiveCommerceServiceGetResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LiveCommerceServiceGetResponse copyWith(
          void Function(LiveCommerceServiceGetResponse) updates) =>
      super.copyWith(
              (message) => updates(message as LiveCommerceServiceGetResponse))
          as LiveCommerceServiceGetResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use LiveCommerceServiceGetResponse() / LiveCommerceServiceGetResponse.new instead')
  static LiveCommerceServiceGetResponse create() =>
      LiveCommerceServiceGetResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      LiveCommerceServiceGetResponse._();
  @$core.override
  LiveCommerceServiceGetResponse createEmptyInstance() =>
      LiveCommerceServiceGetResponse._();
  @$core.pragma('dart2js:noInline')
  static LiveCommerceServiceGetResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<LiveCommerceServiceGetResponse>(
          LiveCommerceServiceGetResponse.$_createMessage);
  static LiveCommerceServiceGetResponse? _defaultInstance;

  @$pb.TagNumber(1)
  LiveSession get session => $_getN(0);
  @$pb.TagNumber(1)
  set session(LiveSession value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasSession() => $_has(0);
  @$pb.TagNumber(1)
  void clearSession() => $_clearField(1);
  @$pb.TagNumber(1)
  LiveSession ensureSession() => $_ensure(0);

  @$pb.TagNumber(2)
  $pb.PbList<CueCard> get cueCards => $_getList(1);

  @$pb.TagNumber(3)
  $pb.PbList<Highlight> get highlights => $_getList(2);
}

class LiveCommerceServiceListRequest extends $pb.GeneratedMessage {
  factory LiveCommerceServiceListRequest({
    $core.String? workspaceId,
    $core.String? status,
    $core.String? platform,
    $2.Pagination? pagination,
  }) {
    final result = LiveCommerceServiceListRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (status != null) result.status = status;
    if (platform != null) result.platform = platform;
    if (pagination != null) result.pagination = pagination;
    return result;
  }

  LiveCommerceServiceListRequest._();

  factory LiveCommerceServiceListRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      LiveCommerceServiceListRequest()..mergeFromBuffer(data, registry);
  factory LiveCommerceServiceListRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      LiveCommerceServiceListRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'LiveCommerceServiceListRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: LiveCommerceServiceListRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'status')
    ..aOS(3, _omitFieldNames ? '' : 'platform')
    ..aOM<$2.Pagination>(4, _omitFieldNames ? '' : 'pagination',
        subBuilder: $2.Pagination.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LiveCommerceServiceListRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LiveCommerceServiceListRequest copyWith(
          void Function(LiveCommerceServiceListRequest) updates) =>
      super.copyWith(
              (message) => updates(message as LiveCommerceServiceListRequest))
          as LiveCommerceServiceListRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use LiveCommerceServiceListRequest() / LiveCommerceServiceListRequest.new instead')
  static LiveCommerceServiceListRequest create() =>
      LiveCommerceServiceListRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      LiveCommerceServiceListRequest._();
  @$core.override
  LiveCommerceServiceListRequest createEmptyInstance() =>
      LiveCommerceServiceListRequest._();
  @$core.pragma('dart2js:noInline')
  static LiveCommerceServiceListRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<LiveCommerceServiceListRequest>(
          LiveCommerceServiceListRequest.$_createMessage);
  static LiveCommerceServiceListRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get status => $_getSZ(1);
  @$pb.TagNumber(2)
  set status($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasStatus() => $_has(1);
  @$pb.TagNumber(2)
  void clearStatus() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get platform => $_getSZ(2);
  @$pb.TagNumber(3)
  set platform($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPlatform() => $_has(2);
  @$pb.TagNumber(3)
  void clearPlatform() => $_clearField(3);

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

class LiveCommerceServiceListResponse extends $pb.GeneratedMessage {
  factory LiveCommerceServiceListResponse({
    $core.Iterable<LiveSession>? sessions,
    $2.PaginatedResponse? pagination,
  }) {
    final result = LiveCommerceServiceListResponse._();
    if (sessions != null) result.sessions.addAll(sessions);
    if (pagination != null) result.pagination = pagination;
    return result;
  }

  LiveCommerceServiceListResponse._();

  factory LiveCommerceServiceListResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      LiveCommerceServiceListResponse()..mergeFromBuffer(data, registry);
  factory LiveCommerceServiceListResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      LiveCommerceServiceListResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'LiveCommerceServiceListResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: LiveCommerceServiceListResponse.$_createMessage)
    ..pPM<LiveSession>(1, _omitFieldNames ? '' : 'sessions',
        subBuilder: LiveSession.$_createMessage)
    ..aOM<$2.PaginatedResponse>(2, _omitFieldNames ? '' : 'pagination',
        subBuilder: $2.PaginatedResponse.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LiveCommerceServiceListResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LiveCommerceServiceListResponse copyWith(
          void Function(LiveCommerceServiceListResponse) updates) =>
      super.copyWith(
              (message) => updates(message as LiveCommerceServiceListResponse))
          as LiveCommerceServiceListResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use LiveCommerceServiceListResponse() / LiveCommerceServiceListResponse.new instead')
  static LiveCommerceServiceListResponse create() =>
      LiveCommerceServiceListResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      LiveCommerceServiceListResponse._();
  @$core.override
  LiveCommerceServiceListResponse createEmptyInstance() =>
      LiveCommerceServiceListResponse._();
  @$core.pragma('dart2js:noInline')
  static LiveCommerceServiceListResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<LiveCommerceServiceListResponse>(
          LiveCommerceServiceListResponse.$_createMessage);
  static LiveCommerceServiceListResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<LiveSession> get sessions => $_getList(0);

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

class LiveCommerceServiceStartSessionRequest extends $pb.GeneratedMessage {
  factory LiveCommerceServiceStartSessionRequest({
    $2.CommandContext? context,
    $core.String? sessionId,
  }) {
    final result = LiveCommerceServiceStartSessionRequest._();
    if (context != null) result.context = context;
    if (sessionId != null) result.sessionId = sessionId;
    return result;
  }

  LiveCommerceServiceStartSessionRequest._();

  factory LiveCommerceServiceStartSessionRequest.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      LiveCommerceServiceStartSessionRequest()..mergeFromBuffer(data, registry);
  factory LiveCommerceServiceStartSessionRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      LiveCommerceServiceStartSessionRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'LiveCommerceServiceStartSessionRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance:
          LiveCommerceServiceStartSessionRequest.$_createMessage)
    ..aOM<$2.CommandContext>(1, _omitFieldNames ? '' : 'context',
        subBuilder: $2.CommandContext.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'sessionId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LiveCommerceServiceStartSessionRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LiveCommerceServiceStartSessionRequest copyWith(
          void Function(LiveCommerceServiceStartSessionRequest) updates) =>
      super.copyWith((message) =>
              updates(message as LiveCommerceServiceStartSessionRequest))
          as LiveCommerceServiceStartSessionRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use LiveCommerceServiceStartSessionRequest() / LiveCommerceServiceStartSessionRequest.new instead')
  static LiveCommerceServiceStartSessionRequest create() =>
      LiveCommerceServiceStartSessionRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      LiveCommerceServiceStartSessionRequest._();
  @$core.override
  LiveCommerceServiceStartSessionRequest createEmptyInstance() =>
      LiveCommerceServiceStartSessionRequest._();
  @$core.pragma('dart2js:noInline')
  static LiveCommerceServiceStartSessionRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
              LiveCommerceServiceStartSessionRequest>(
          LiveCommerceServiceStartSessionRequest.$_createMessage);
  static LiveCommerceServiceStartSessionRequest? _defaultInstance;

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
  $core.String get sessionId => $_getSZ(1);
  @$pb.TagNumber(2)
  set sessionId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSessionId() => $_has(1);
  @$pb.TagNumber(2)
  void clearSessionId() => $_clearField(2);
}

class LiveCommerceServiceStartSessionResponse extends $pb.GeneratedMessage {
  factory LiveCommerceServiceStartSessionResponse({
    LiveSession? session,
    $core.bool? isDuplicate,
  }) {
    final result = LiveCommerceServiceStartSessionResponse._();
    if (session != null) result.session = session;
    if (isDuplicate != null) result.isDuplicate = isDuplicate;
    return result;
  }

  LiveCommerceServiceStartSessionResponse._();

  factory LiveCommerceServiceStartSessionResponse.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      LiveCommerceServiceStartSessionResponse()
        ..mergeFromBuffer(data, registry);
  factory LiveCommerceServiceStartSessionResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      LiveCommerceServiceStartSessionResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'LiveCommerceServiceStartSessionResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance:
          LiveCommerceServiceStartSessionResponse.$_createMessage)
    ..aOM<LiveSession>(1, _omitFieldNames ? '' : 'session',
        subBuilder: LiveSession.$_createMessage)
    ..aOB(2, _omitFieldNames ? '' : 'isDuplicate')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LiveCommerceServiceStartSessionResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LiveCommerceServiceStartSessionResponse copyWith(
          void Function(LiveCommerceServiceStartSessionResponse) updates) =>
      super.copyWith((message) =>
              updates(message as LiveCommerceServiceStartSessionResponse))
          as LiveCommerceServiceStartSessionResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use LiveCommerceServiceStartSessionResponse() / LiveCommerceServiceStartSessionResponse.new instead')
  static LiveCommerceServiceStartSessionResponse create() =>
      LiveCommerceServiceStartSessionResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      LiveCommerceServiceStartSessionResponse._();
  @$core.override
  LiveCommerceServiceStartSessionResponse createEmptyInstance() =>
      LiveCommerceServiceStartSessionResponse._();
  @$core.pragma('dart2js:noInline')
  static LiveCommerceServiceStartSessionResponse getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
              LiveCommerceServiceStartSessionResponse>(
          LiveCommerceServiceStartSessionResponse.$_createMessage);
  static LiveCommerceServiceStartSessionResponse? _defaultInstance;

  @$pb.TagNumber(1)
  LiveSession get session => $_getN(0);
  @$pb.TagNumber(1)
  set session(LiveSession value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasSession() => $_has(0);
  @$pb.TagNumber(1)
  void clearSession() => $_clearField(1);
  @$pb.TagNumber(1)
  LiveSession ensureSession() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.bool get isDuplicate => $_getBF(1);
  @$pb.TagNumber(2)
  set isDuplicate($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasIsDuplicate() => $_has(1);
  @$pb.TagNumber(2)
  void clearIsDuplicate() => $_clearField(2);
}

class LiveCommerceServiceEndSessionRequest extends $pb.GeneratedMessage {
  factory LiveCommerceServiceEndSessionRequest({
    $2.CommandContext? context,
    $core.String? sessionId,
  }) {
    final result = LiveCommerceServiceEndSessionRequest._();
    if (context != null) result.context = context;
    if (sessionId != null) result.sessionId = sessionId;
    return result;
  }

  LiveCommerceServiceEndSessionRequest._();

  factory LiveCommerceServiceEndSessionRequest.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      LiveCommerceServiceEndSessionRequest()..mergeFromBuffer(data, registry);
  factory LiveCommerceServiceEndSessionRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      LiveCommerceServiceEndSessionRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'LiveCommerceServiceEndSessionRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: LiveCommerceServiceEndSessionRequest.$_createMessage)
    ..aOM<$2.CommandContext>(1, _omitFieldNames ? '' : 'context',
        subBuilder: $2.CommandContext.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'sessionId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LiveCommerceServiceEndSessionRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LiveCommerceServiceEndSessionRequest copyWith(
          void Function(LiveCommerceServiceEndSessionRequest) updates) =>
      super.copyWith((message) =>
              updates(message as LiveCommerceServiceEndSessionRequest))
          as LiveCommerceServiceEndSessionRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use LiveCommerceServiceEndSessionRequest() / LiveCommerceServiceEndSessionRequest.new instead')
  static LiveCommerceServiceEndSessionRequest create() =>
      LiveCommerceServiceEndSessionRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      LiveCommerceServiceEndSessionRequest._();
  @$core.override
  LiveCommerceServiceEndSessionRequest createEmptyInstance() =>
      LiveCommerceServiceEndSessionRequest._();
  @$core.pragma('dart2js:noInline')
  static LiveCommerceServiceEndSessionRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
              LiveCommerceServiceEndSessionRequest>(
          LiveCommerceServiceEndSessionRequest.$_createMessage);
  static LiveCommerceServiceEndSessionRequest? _defaultInstance;

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
  $core.String get sessionId => $_getSZ(1);
  @$pb.TagNumber(2)
  set sessionId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSessionId() => $_has(1);
  @$pb.TagNumber(2)
  void clearSessionId() => $_clearField(2);
}

class LiveCommerceServiceEndSessionResponse extends $pb.GeneratedMessage {
  factory LiveCommerceServiceEndSessionResponse({
    LiveSession? session,
    PostLiveProofSummary? summary,
    $core.bool? isDuplicate,
  }) {
    final result = LiveCommerceServiceEndSessionResponse._();
    if (session != null) result.session = session;
    if (summary != null) result.summary = summary;
    if (isDuplicate != null) result.isDuplicate = isDuplicate;
    return result;
  }

  LiveCommerceServiceEndSessionResponse._();

  factory LiveCommerceServiceEndSessionResponse.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      LiveCommerceServiceEndSessionResponse()..mergeFromBuffer(data, registry);
  factory LiveCommerceServiceEndSessionResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      LiveCommerceServiceEndSessionResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'LiveCommerceServiceEndSessionResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance:
          LiveCommerceServiceEndSessionResponse.$_createMessage)
    ..aOM<LiveSession>(1, _omitFieldNames ? '' : 'session',
        subBuilder: LiveSession.$_createMessage)
    ..aOM<PostLiveProofSummary>(2, _omitFieldNames ? '' : 'summary',
        subBuilder: PostLiveProofSummary.$_createMessage)
    ..aOB(3, _omitFieldNames ? '' : 'isDuplicate')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LiveCommerceServiceEndSessionResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LiveCommerceServiceEndSessionResponse copyWith(
          void Function(LiveCommerceServiceEndSessionResponse) updates) =>
      super.copyWith((message) =>
              updates(message as LiveCommerceServiceEndSessionResponse))
          as LiveCommerceServiceEndSessionResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use LiveCommerceServiceEndSessionResponse() / LiveCommerceServiceEndSessionResponse.new instead')
  static LiveCommerceServiceEndSessionResponse create() =>
      LiveCommerceServiceEndSessionResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      LiveCommerceServiceEndSessionResponse._();
  @$core.override
  LiveCommerceServiceEndSessionResponse createEmptyInstance() =>
      LiveCommerceServiceEndSessionResponse._();
  @$core.pragma('dart2js:noInline')
  static LiveCommerceServiceEndSessionResponse getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
              LiveCommerceServiceEndSessionResponse>(
          LiveCommerceServiceEndSessionResponse.$_createMessage);
  static LiveCommerceServiceEndSessionResponse? _defaultInstance;

  @$pb.TagNumber(1)
  LiveSession get session => $_getN(0);
  @$pb.TagNumber(1)
  set session(LiveSession value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasSession() => $_has(0);
  @$pb.TagNumber(1)
  void clearSession() => $_clearField(1);
  @$pb.TagNumber(1)
  LiveSession ensureSession() => $_ensure(0);

  @$pb.TagNumber(2)
  PostLiveProofSummary get summary => $_getN(1);
  @$pb.TagNumber(2)
  set summary(PostLiveProofSummary value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasSummary() => $_has(1);
  @$pb.TagNumber(2)
  void clearSummary() => $_clearField(2);
  @$pb.TagNumber(2)
  PostLiveProofSummary ensureSummary() => $_ensure(1);

  @$pb.TagNumber(3)
  $core.bool get isDuplicate => $_getBF(2);
  @$pb.TagNumber(3)
  set isDuplicate($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasIsDuplicate() => $_has(2);
  @$pb.TagNumber(3)
  void clearIsDuplicate() => $_clearField(3);
}

class LiveCommerceServicePauseSessionRequest extends $pb.GeneratedMessage {
  factory LiveCommerceServicePauseSessionRequest({
    $2.CommandContext? context,
    $core.String? sessionId,
  }) {
    final result = LiveCommerceServicePauseSessionRequest._();
    if (context != null) result.context = context;
    if (sessionId != null) result.sessionId = sessionId;
    return result;
  }

  LiveCommerceServicePauseSessionRequest._();

  factory LiveCommerceServicePauseSessionRequest.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      LiveCommerceServicePauseSessionRequest()..mergeFromBuffer(data, registry);
  factory LiveCommerceServicePauseSessionRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      LiveCommerceServicePauseSessionRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'LiveCommerceServicePauseSessionRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance:
          LiveCommerceServicePauseSessionRequest.$_createMessage)
    ..aOM<$2.CommandContext>(1, _omitFieldNames ? '' : 'context',
        subBuilder: $2.CommandContext.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'sessionId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LiveCommerceServicePauseSessionRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LiveCommerceServicePauseSessionRequest copyWith(
          void Function(LiveCommerceServicePauseSessionRequest) updates) =>
      super.copyWith((message) =>
              updates(message as LiveCommerceServicePauseSessionRequest))
          as LiveCommerceServicePauseSessionRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use LiveCommerceServicePauseSessionRequest() / LiveCommerceServicePauseSessionRequest.new instead')
  static LiveCommerceServicePauseSessionRequest create() =>
      LiveCommerceServicePauseSessionRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      LiveCommerceServicePauseSessionRequest._();
  @$core.override
  LiveCommerceServicePauseSessionRequest createEmptyInstance() =>
      LiveCommerceServicePauseSessionRequest._();
  @$core.pragma('dart2js:noInline')
  static LiveCommerceServicePauseSessionRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
              LiveCommerceServicePauseSessionRequest>(
          LiveCommerceServicePauseSessionRequest.$_createMessage);
  static LiveCommerceServicePauseSessionRequest? _defaultInstance;

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
  $core.String get sessionId => $_getSZ(1);
  @$pb.TagNumber(2)
  set sessionId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSessionId() => $_has(1);
  @$pb.TagNumber(2)
  void clearSessionId() => $_clearField(2);
}

class LiveCommerceServicePauseSessionResponse extends $pb.GeneratedMessage {
  factory LiveCommerceServicePauseSessionResponse({
    LiveSession? session,
    $core.bool? isDuplicate,
  }) {
    final result = LiveCommerceServicePauseSessionResponse._();
    if (session != null) result.session = session;
    if (isDuplicate != null) result.isDuplicate = isDuplicate;
    return result;
  }

  LiveCommerceServicePauseSessionResponse._();

  factory LiveCommerceServicePauseSessionResponse.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      LiveCommerceServicePauseSessionResponse()
        ..mergeFromBuffer(data, registry);
  factory LiveCommerceServicePauseSessionResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      LiveCommerceServicePauseSessionResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'LiveCommerceServicePauseSessionResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance:
          LiveCommerceServicePauseSessionResponse.$_createMessage)
    ..aOM<LiveSession>(1, _omitFieldNames ? '' : 'session',
        subBuilder: LiveSession.$_createMessage)
    ..aOB(2, _omitFieldNames ? '' : 'isDuplicate')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LiveCommerceServicePauseSessionResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LiveCommerceServicePauseSessionResponse copyWith(
          void Function(LiveCommerceServicePauseSessionResponse) updates) =>
      super.copyWith((message) =>
              updates(message as LiveCommerceServicePauseSessionResponse))
          as LiveCommerceServicePauseSessionResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use LiveCommerceServicePauseSessionResponse() / LiveCommerceServicePauseSessionResponse.new instead')
  static LiveCommerceServicePauseSessionResponse create() =>
      LiveCommerceServicePauseSessionResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      LiveCommerceServicePauseSessionResponse._();
  @$core.override
  LiveCommerceServicePauseSessionResponse createEmptyInstance() =>
      LiveCommerceServicePauseSessionResponse._();
  @$core.pragma('dart2js:noInline')
  static LiveCommerceServicePauseSessionResponse getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
              LiveCommerceServicePauseSessionResponse>(
          LiveCommerceServicePauseSessionResponse.$_createMessage);
  static LiveCommerceServicePauseSessionResponse? _defaultInstance;

  @$pb.TagNumber(1)
  LiveSession get session => $_getN(0);
  @$pb.TagNumber(1)
  set session(LiveSession value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasSession() => $_has(0);
  @$pb.TagNumber(1)
  void clearSession() => $_clearField(1);
  @$pb.TagNumber(1)
  LiveSession ensureSession() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.bool get isDuplicate => $_getBF(1);
  @$pb.TagNumber(2)
  set isDuplicate($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasIsDuplicate() => $_has(1);
  @$pb.TagNumber(2)
  void clearIsDuplicate() => $_clearField(2);
}

class LiveCommerceServiceResumeSessionRequest extends $pb.GeneratedMessage {
  factory LiveCommerceServiceResumeSessionRequest({
    $2.CommandContext? context,
    $core.String? sessionId,
  }) {
    final result = LiveCommerceServiceResumeSessionRequest._();
    if (context != null) result.context = context;
    if (sessionId != null) result.sessionId = sessionId;
    return result;
  }

  LiveCommerceServiceResumeSessionRequest._();

  factory LiveCommerceServiceResumeSessionRequest.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      LiveCommerceServiceResumeSessionRequest()
        ..mergeFromBuffer(data, registry);
  factory LiveCommerceServiceResumeSessionRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      LiveCommerceServiceResumeSessionRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'LiveCommerceServiceResumeSessionRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance:
          LiveCommerceServiceResumeSessionRequest.$_createMessage)
    ..aOM<$2.CommandContext>(1, _omitFieldNames ? '' : 'context',
        subBuilder: $2.CommandContext.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'sessionId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LiveCommerceServiceResumeSessionRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LiveCommerceServiceResumeSessionRequest copyWith(
          void Function(LiveCommerceServiceResumeSessionRequest) updates) =>
      super.copyWith((message) =>
              updates(message as LiveCommerceServiceResumeSessionRequest))
          as LiveCommerceServiceResumeSessionRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use LiveCommerceServiceResumeSessionRequest() / LiveCommerceServiceResumeSessionRequest.new instead')
  static LiveCommerceServiceResumeSessionRequest create() =>
      LiveCommerceServiceResumeSessionRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      LiveCommerceServiceResumeSessionRequest._();
  @$core.override
  LiveCommerceServiceResumeSessionRequest createEmptyInstance() =>
      LiveCommerceServiceResumeSessionRequest._();
  @$core.pragma('dart2js:noInline')
  static LiveCommerceServiceResumeSessionRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
              LiveCommerceServiceResumeSessionRequest>(
          LiveCommerceServiceResumeSessionRequest.$_createMessage);
  static LiveCommerceServiceResumeSessionRequest? _defaultInstance;

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
  $core.String get sessionId => $_getSZ(1);
  @$pb.TagNumber(2)
  set sessionId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSessionId() => $_has(1);
  @$pb.TagNumber(2)
  void clearSessionId() => $_clearField(2);
}

class LiveCommerceServiceResumeSessionResponse extends $pb.GeneratedMessage {
  factory LiveCommerceServiceResumeSessionResponse({
    LiveSession? session,
    $core.bool? isDuplicate,
  }) {
    final result = LiveCommerceServiceResumeSessionResponse._();
    if (session != null) result.session = session;
    if (isDuplicate != null) result.isDuplicate = isDuplicate;
    return result;
  }

  LiveCommerceServiceResumeSessionResponse._();

  factory LiveCommerceServiceResumeSessionResponse.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      LiveCommerceServiceResumeSessionResponse()
        ..mergeFromBuffer(data, registry);
  factory LiveCommerceServiceResumeSessionResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      LiveCommerceServiceResumeSessionResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'LiveCommerceServiceResumeSessionResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance:
          LiveCommerceServiceResumeSessionResponse.$_createMessage)
    ..aOM<LiveSession>(1, _omitFieldNames ? '' : 'session',
        subBuilder: LiveSession.$_createMessage)
    ..aOB(2, _omitFieldNames ? '' : 'isDuplicate')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LiveCommerceServiceResumeSessionResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LiveCommerceServiceResumeSessionResponse copyWith(
          void Function(LiveCommerceServiceResumeSessionResponse) updates) =>
      super.copyWith((message) =>
              updates(message as LiveCommerceServiceResumeSessionResponse))
          as LiveCommerceServiceResumeSessionResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use LiveCommerceServiceResumeSessionResponse() / LiveCommerceServiceResumeSessionResponse.new instead')
  static LiveCommerceServiceResumeSessionResponse create() =>
      LiveCommerceServiceResumeSessionResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      LiveCommerceServiceResumeSessionResponse._();
  @$core.override
  LiveCommerceServiceResumeSessionResponse createEmptyInstance() =>
      LiveCommerceServiceResumeSessionResponse._();
  @$core.pragma('dart2js:noInline')
  static LiveCommerceServiceResumeSessionResponse getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
              LiveCommerceServiceResumeSessionResponse>(
          LiveCommerceServiceResumeSessionResponse.$_createMessage);
  static LiveCommerceServiceResumeSessionResponse? _defaultInstance;

  @$pb.TagNumber(1)
  LiveSession get session => $_getN(0);
  @$pb.TagNumber(1)
  set session(LiveSession value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasSession() => $_has(0);
  @$pb.TagNumber(1)
  void clearSession() => $_clearField(1);
  @$pb.TagNumber(1)
  LiveSession ensureSession() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.bool get isDuplicate => $_getBF(1);
  @$pb.TagNumber(2)
  set isDuplicate($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasIsDuplicate() => $_has(1);
  @$pb.TagNumber(2)
  void clearIsDuplicate() => $_clearField(2);
}

class LiveCommerceServiceAddCueRequest extends $pb.GeneratedMessage {
  factory LiveCommerceServiceAddCueRequest({
    $2.CommandContext? context,
    $core.String? sessionId,
    $core.String? cueType,
    $core.String? title,
    $core.String? body,
    $core.String? pinnedProductId,
    $core.String? pinnedOfferId,
    $core.int? displayOrder,
  }) {
    final result = LiveCommerceServiceAddCueRequest._();
    if (context != null) result.context = context;
    if (sessionId != null) result.sessionId = sessionId;
    if (cueType != null) result.cueType = cueType;
    if (title != null) result.title = title;
    if (body != null) result.body = body;
    if (pinnedProductId != null) result.pinnedProductId = pinnedProductId;
    if (pinnedOfferId != null) result.pinnedOfferId = pinnedOfferId;
    if (displayOrder != null) result.displayOrder = displayOrder;
    return result;
  }

  LiveCommerceServiceAddCueRequest._();

  factory LiveCommerceServiceAddCueRequest.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      LiveCommerceServiceAddCueRequest()..mergeFromBuffer(data, registry);
  factory LiveCommerceServiceAddCueRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      LiveCommerceServiceAddCueRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'LiveCommerceServiceAddCueRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: LiveCommerceServiceAddCueRequest.$_createMessage)
    ..aOM<$2.CommandContext>(1, _omitFieldNames ? '' : 'context',
        subBuilder: $2.CommandContext.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'sessionId')
    ..aOS(3, _omitFieldNames ? '' : 'cueType')
    ..aOS(4, _omitFieldNames ? '' : 'title')
    ..aOS(5, _omitFieldNames ? '' : 'body')
    ..aOS(6, _omitFieldNames ? '' : 'pinnedProductId')
    ..aOS(7, _omitFieldNames ? '' : 'pinnedOfferId')
    ..aI(8, _omitFieldNames ? '' : 'displayOrder')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LiveCommerceServiceAddCueRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LiveCommerceServiceAddCueRequest copyWith(
          void Function(LiveCommerceServiceAddCueRequest) updates) =>
      super.copyWith(
              (message) => updates(message as LiveCommerceServiceAddCueRequest))
          as LiveCommerceServiceAddCueRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use LiveCommerceServiceAddCueRequest() / LiveCommerceServiceAddCueRequest.new instead')
  static LiveCommerceServiceAddCueRequest create() =>
      LiveCommerceServiceAddCueRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      LiveCommerceServiceAddCueRequest._();
  @$core.override
  LiveCommerceServiceAddCueRequest createEmptyInstance() =>
      LiveCommerceServiceAddCueRequest._();
  @$core.pragma('dart2js:noInline')
  static LiveCommerceServiceAddCueRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<LiveCommerceServiceAddCueRequest>(
          LiveCommerceServiceAddCueRequest.$_createMessage);
  static LiveCommerceServiceAddCueRequest? _defaultInstance;

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
  $core.String get sessionId => $_getSZ(1);
  @$pb.TagNumber(2)
  set sessionId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSessionId() => $_has(1);
  @$pb.TagNumber(2)
  void clearSessionId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get cueType => $_getSZ(2);
  @$pb.TagNumber(3)
  set cueType($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasCueType() => $_has(2);
  @$pb.TagNumber(3)
  void clearCueType() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get title => $_getSZ(3);
  @$pb.TagNumber(4)
  set title($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasTitle() => $_has(3);
  @$pb.TagNumber(4)
  void clearTitle() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get body => $_getSZ(4);
  @$pb.TagNumber(5)
  set body($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasBody() => $_has(4);
  @$pb.TagNumber(5)
  void clearBody() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get pinnedProductId => $_getSZ(5);
  @$pb.TagNumber(6)
  set pinnedProductId($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasPinnedProductId() => $_has(5);
  @$pb.TagNumber(6)
  void clearPinnedProductId() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get pinnedOfferId => $_getSZ(6);
  @$pb.TagNumber(7)
  set pinnedOfferId($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasPinnedOfferId() => $_has(6);
  @$pb.TagNumber(7)
  void clearPinnedOfferId() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.int get displayOrder => $_getIZ(7);
  @$pb.TagNumber(8)
  set displayOrder($core.int value) => $_setSignedInt32(7, value);
  @$pb.TagNumber(8)
  $core.bool hasDisplayOrder() => $_has(7);
  @$pb.TagNumber(8)
  void clearDisplayOrder() => $_clearField(8);
}

class LiveCommerceServiceAddCueResponse extends $pb.GeneratedMessage {
  factory LiveCommerceServiceAddCueResponse({
    CueCard? cueCard,
    $core.bool? isDuplicate,
  }) {
    final result = LiveCommerceServiceAddCueResponse._();
    if (cueCard != null) result.cueCard = cueCard;
    if (isDuplicate != null) result.isDuplicate = isDuplicate;
    return result;
  }

  LiveCommerceServiceAddCueResponse._();

  factory LiveCommerceServiceAddCueResponse.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      LiveCommerceServiceAddCueResponse()..mergeFromBuffer(data, registry);
  factory LiveCommerceServiceAddCueResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      LiveCommerceServiceAddCueResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'LiveCommerceServiceAddCueResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: LiveCommerceServiceAddCueResponse.$_createMessage)
    ..aOM<CueCard>(1, _omitFieldNames ? '' : 'cueCard',
        subBuilder: CueCard.$_createMessage)
    ..aOB(2, _omitFieldNames ? '' : 'isDuplicate')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LiveCommerceServiceAddCueResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LiveCommerceServiceAddCueResponse copyWith(
          void Function(LiveCommerceServiceAddCueResponse) updates) =>
      super.copyWith((message) =>
              updates(message as LiveCommerceServiceAddCueResponse))
          as LiveCommerceServiceAddCueResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use LiveCommerceServiceAddCueResponse() / LiveCommerceServiceAddCueResponse.new instead')
  static LiveCommerceServiceAddCueResponse create() =>
      LiveCommerceServiceAddCueResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      LiveCommerceServiceAddCueResponse._();
  @$core.override
  LiveCommerceServiceAddCueResponse createEmptyInstance() =>
      LiveCommerceServiceAddCueResponse._();
  @$core.pragma('dart2js:noInline')
  static LiveCommerceServiceAddCueResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<LiveCommerceServiceAddCueResponse>(
          LiveCommerceServiceAddCueResponse.$_createMessage);
  static LiveCommerceServiceAddCueResponse? _defaultInstance;

  @$pb.TagNumber(1)
  CueCard get cueCard => $_getN(0);
  @$pb.TagNumber(1)
  set cueCard(CueCard value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasCueCard() => $_has(0);
  @$pb.TagNumber(1)
  void clearCueCard() => $_clearField(1);
  @$pb.TagNumber(1)
  CueCard ensureCueCard() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.bool get isDuplicate => $_getBF(1);
  @$pb.TagNumber(2)
  set isDuplicate($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasIsDuplicate() => $_has(1);
  @$pb.TagNumber(2)
  void clearIsDuplicate() => $_clearField(2);
}

class LiveCommerceServiceRemoveCueRequest extends $pb.GeneratedMessage {
  factory LiveCommerceServiceRemoveCueRequest({
    $2.CommandContext? context,
    $core.String? sessionId,
    $core.String? cueCardId,
  }) {
    final result = LiveCommerceServiceRemoveCueRequest._();
    if (context != null) result.context = context;
    if (sessionId != null) result.sessionId = sessionId;
    if (cueCardId != null) result.cueCardId = cueCardId;
    return result;
  }

  LiveCommerceServiceRemoveCueRequest._();

  factory LiveCommerceServiceRemoveCueRequest.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      LiveCommerceServiceRemoveCueRequest()..mergeFromBuffer(data, registry);
  factory LiveCommerceServiceRemoveCueRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      LiveCommerceServiceRemoveCueRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'LiveCommerceServiceRemoveCueRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: LiveCommerceServiceRemoveCueRequest.$_createMessage)
    ..aOM<$2.CommandContext>(1, _omitFieldNames ? '' : 'context',
        subBuilder: $2.CommandContext.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'sessionId')
    ..aOS(3, _omitFieldNames ? '' : 'cueCardId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LiveCommerceServiceRemoveCueRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LiveCommerceServiceRemoveCueRequest copyWith(
          void Function(LiveCommerceServiceRemoveCueRequest) updates) =>
      super.copyWith((message) =>
              updates(message as LiveCommerceServiceRemoveCueRequest))
          as LiveCommerceServiceRemoveCueRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use LiveCommerceServiceRemoveCueRequest() / LiveCommerceServiceRemoveCueRequest.new instead')
  static LiveCommerceServiceRemoveCueRequest create() =>
      LiveCommerceServiceRemoveCueRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      LiveCommerceServiceRemoveCueRequest._();
  @$core.override
  LiveCommerceServiceRemoveCueRequest createEmptyInstance() =>
      LiveCommerceServiceRemoveCueRequest._();
  @$core.pragma('dart2js:noInline')
  static LiveCommerceServiceRemoveCueRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
              LiveCommerceServiceRemoveCueRequest>(
          LiveCommerceServiceRemoveCueRequest.$_createMessage);
  static LiveCommerceServiceRemoveCueRequest? _defaultInstance;

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
  $core.String get sessionId => $_getSZ(1);
  @$pb.TagNumber(2)
  set sessionId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSessionId() => $_has(1);
  @$pb.TagNumber(2)
  void clearSessionId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get cueCardId => $_getSZ(2);
  @$pb.TagNumber(3)
  set cueCardId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasCueCardId() => $_has(2);
  @$pb.TagNumber(3)
  void clearCueCardId() => $_clearField(3);
}

class LiveCommerceServiceRemoveCueResponse extends $pb.GeneratedMessage {
  factory LiveCommerceServiceRemoveCueResponse({
    $core.bool? success,
  }) {
    final result = LiveCommerceServiceRemoveCueResponse._();
    if (success != null) result.success = success;
    return result;
  }

  LiveCommerceServiceRemoveCueResponse._();

  factory LiveCommerceServiceRemoveCueResponse.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      LiveCommerceServiceRemoveCueResponse()..mergeFromBuffer(data, registry);
  factory LiveCommerceServiceRemoveCueResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      LiveCommerceServiceRemoveCueResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'LiveCommerceServiceRemoveCueResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: LiveCommerceServiceRemoveCueResponse.$_createMessage)
    ..aOB(1, _omitFieldNames ? '' : 'success')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LiveCommerceServiceRemoveCueResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LiveCommerceServiceRemoveCueResponse copyWith(
          void Function(LiveCommerceServiceRemoveCueResponse) updates) =>
      super.copyWith((message) =>
              updates(message as LiveCommerceServiceRemoveCueResponse))
          as LiveCommerceServiceRemoveCueResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use LiveCommerceServiceRemoveCueResponse() / LiveCommerceServiceRemoveCueResponse.new instead')
  static LiveCommerceServiceRemoveCueResponse create() =>
      LiveCommerceServiceRemoveCueResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      LiveCommerceServiceRemoveCueResponse._();
  @$core.override
  LiveCommerceServiceRemoveCueResponse createEmptyInstance() =>
      LiveCommerceServiceRemoveCueResponse._();
  @$core.pragma('dart2js:noInline')
  static LiveCommerceServiceRemoveCueResponse getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
              LiveCommerceServiceRemoveCueResponse>(
          LiveCommerceServiceRemoveCueResponse.$_createMessage);
  static LiveCommerceServiceRemoveCueResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get success => $_getBF(0);
  @$pb.TagNumber(1)
  set success($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSuccess() => $_has(0);
  @$pb.TagNumber(1)
  void clearSuccess() => $_clearField(1);
}

class LiveCommerceServiceTriggerCueRequest extends $pb.GeneratedMessage {
  factory LiveCommerceServiceTriggerCueRequest({
    $2.CommandContext? context,
    $core.String? sessionId,
    $core.String? cueCardId,
  }) {
    final result = LiveCommerceServiceTriggerCueRequest._();
    if (context != null) result.context = context;
    if (sessionId != null) result.sessionId = sessionId;
    if (cueCardId != null) result.cueCardId = cueCardId;
    return result;
  }

  LiveCommerceServiceTriggerCueRequest._();

  factory LiveCommerceServiceTriggerCueRequest.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      LiveCommerceServiceTriggerCueRequest()..mergeFromBuffer(data, registry);
  factory LiveCommerceServiceTriggerCueRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      LiveCommerceServiceTriggerCueRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'LiveCommerceServiceTriggerCueRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: LiveCommerceServiceTriggerCueRequest.$_createMessage)
    ..aOM<$2.CommandContext>(1, _omitFieldNames ? '' : 'context',
        subBuilder: $2.CommandContext.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'sessionId')
    ..aOS(3, _omitFieldNames ? '' : 'cueCardId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LiveCommerceServiceTriggerCueRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LiveCommerceServiceTriggerCueRequest copyWith(
          void Function(LiveCommerceServiceTriggerCueRequest) updates) =>
      super.copyWith((message) =>
              updates(message as LiveCommerceServiceTriggerCueRequest))
          as LiveCommerceServiceTriggerCueRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use LiveCommerceServiceTriggerCueRequest() / LiveCommerceServiceTriggerCueRequest.new instead')
  static LiveCommerceServiceTriggerCueRequest create() =>
      LiveCommerceServiceTriggerCueRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      LiveCommerceServiceTriggerCueRequest._();
  @$core.override
  LiveCommerceServiceTriggerCueRequest createEmptyInstance() =>
      LiveCommerceServiceTriggerCueRequest._();
  @$core.pragma('dart2js:noInline')
  static LiveCommerceServiceTriggerCueRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
              LiveCommerceServiceTriggerCueRequest>(
          LiveCommerceServiceTriggerCueRequest.$_createMessage);
  static LiveCommerceServiceTriggerCueRequest? _defaultInstance;

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
  $core.String get sessionId => $_getSZ(1);
  @$pb.TagNumber(2)
  set sessionId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSessionId() => $_has(1);
  @$pb.TagNumber(2)
  void clearSessionId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get cueCardId => $_getSZ(2);
  @$pb.TagNumber(3)
  set cueCardId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasCueCardId() => $_has(2);
  @$pb.TagNumber(3)
  void clearCueCardId() => $_clearField(3);
}

class LiveCommerceServiceTriggerCueResponse extends $pb.GeneratedMessage {
  factory LiveCommerceServiceTriggerCueResponse({
    CueCard? cueCard,
    $core.bool? isDuplicate,
  }) {
    final result = LiveCommerceServiceTriggerCueResponse._();
    if (cueCard != null) result.cueCard = cueCard;
    if (isDuplicate != null) result.isDuplicate = isDuplicate;
    return result;
  }

  LiveCommerceServiceTriggerCueResponse._();

  factory LiveCommerceServiceTriggerCueResponse.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      LiveCommerceServiceTriggerCueResponse()..mergeFromBuffer(data, registry);
  factory LiveCommerceServiceTriggerCueResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      LiveCommerceServiceTriggerCueResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'LiveCommerceServiceTriggerCueResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance:
          LiveCommerceServiceTriggerCueResponse.$_createMessage)
    ..aOM<CueCard>(1, _omitFieldNames ? '' : 'cueCard',
        subBuilder: CueCard.$_createMessage)
    ..aOB(2, _omitFieldNames ? '' : 'isDuplicate')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LiveCommerceServiceTriggerCueResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LiveCommerceServiceTriggerCueResponse copyWith(
          void Function(LiveCommerceServiceTriggerCueResponse) updates) =>
      super.copyWith((message) =>
              updates(message as LiveCommerceServiceTriggerCueResponse))
          as LiveCommerceServiceTriggerCueResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use LiveCommerceServiceTriggerCueResponse() / LiveCommerceServiceTriggerCueResponse.new instead')
  static LiveCommerceServiceTriggerCueResponse create() =>
      LiveCommerceServiceTriggerCueResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      LiveCommerceServiceTriggerCueResponse._();
  @$core.override
  LiveCommerceServiceTriggerCueResponse createEmptyInstance() =>
      LiveCommerceServiceTriggerCueResponse._();
  @$core.pragma('dart2js:noInline')
  static LiveCommerceServiceTriggerCueResponse getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
              LiveCommerceServiceTriggerCueResponse>(
          LiveCommerceServiceTriggerCueResponse.$_createMessage);
  static LiveCommerceServiceTriggerCueResponse? _defaultInstance;

  @$pb.TagNumber(1)
  CueCard get cueCard => $_getN(0);
  @$pb.TagNumber(1)
  set cueCard(CueCard value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasCueCard() => $_has(0);
  @$pb.TagNumber(1)
  void clearCueCard() => $_clearField(1);
  @$pb.TagNumber(1)
  CueCard ensureCueCard() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.bool get isDuplicate => $_getBF(1);
  @$pb.TagNumber(2)
  set isDuplicate($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasIsDuplicate() => $_has(1);
  @$pb.TagNumber(2)
  void clearIsDuplicate() => $_clearField(2);
}

class LiveCommerceServiceHighlightProductRequest extends $pb.GeneratedMessage {
  factory LiveCommerceServiceHighlightProductRequest({
    $2.CommandContext? context,
    $core.String? sessionId,
    $core.String? productId,
    $core.String? offerId,
    $core.bool? isPinned,
    $core.int? activeTimeOffsetSeconds,
  }) {
    final result = LiveCommerceServiceHighlightProductRequest._();
    if (context != null) result.context = context;
    if (sessionId != null) result.sessionId = sessionId;
    if (productId != null) result.productId = productId;
    if (offerId != null) result.offerId = offerId;
    if (isPinned != null) result.isPinned = isPinned;
    if (activeTimeOffsetSeconds != null)
      result.activeTimeOffsetSeconds = activeTimeOffsetSeconds;
    return result;
  }

  LiveCommerceServiceHighlightProductRequest._();

  factory LiveCommerceServiceHighlightProductRequest.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      LiveCommerceServiceHighlightProductRequest()
        ..mergeFromBuffer(data, registry);
  factory LiveCommerceServiceHighlightProductRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      LiveCommerceServiceHighlightProductRequest()
        ..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'LiveCommerceServiceHighlightProductRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance:
          LiveCommerceServiceHighlightProductRequest.$_createMessage)
    ..aOM<$2.CommandContext>(1, _omitFieldNames ? '' : 'context',
        subBuilder: $2.CommandContext.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'sessionId')
    ..aOS(3, _omitFieldNames ? '' : 'productId')
    ..aOS(4, _omitFieldNames ? '' : 'offerId')
    ..aOB(5, _omitFieldNames ? '' : 'isPinned')
    ..aI(6, _omitFieldNames ? '' : 'activeTimeOffsetSeconds')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LiveCommerceServiceHighlightProductRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LiveCommerceServiceHighlightProductRequest copyWith(
          void Function(LiveCommerceServiceHighlightProductRequest) updates) =>
      super.copyWith((message) =>
              updates(message as LiveCommerceServiceHighlightProductRequest))
          as LiveCommerceServiceHighlightProductRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use LiveCommerceServiceHighlightProductRequest() / LiveCommerceServiceHighlightProductRequest.new instead')
  static LiveCommerceServiceHighlightProductRequest create() =>
      LiveCommerceServiceHighlightProductRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      LiveCommerceServiceHighlightProductRequest._();
  @$core.override
  LiveCommerceServiceHighlightProductRequest createEmptyInstance() =>
      LiveCommerceServiceHighlightProductRequest._();
  @$core.pragma('dart2js:noInline')
  static LiveCommerceServiceHighlightProductRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
              LiveCommerceServiceHighlightProductRequest>(
          LiveCommerceServiceHighlightProductRequest.$_createMessage);
  static LiveCommerceServiceHighlightProductRequest? _defaultInstance;

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
  $core.String get sessionId => $_getSZ(1);
  @$pb.TagNumber(2)
  set sessionId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSessionId() => $_has(1);
  @$pb.TagNumber(2)
  void clearSessionId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get productId => $_getSZ(2);
  @$pb.TagNumber(3)
  set productId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasProductId() => $_has(2);
  @$pb.TagNumber(3)
  void clearProductId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get offerId => $_getSZ(3);
  @$pb.TagNumber(4)
  set offerId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasOfferId() => $_has(3);
  @$pb.TagNumber(4)
  void clearOfferId() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.bool get isPinned => $_getBF(4);
  @$pb.TagNumber(5)
  set isPinned($core.bool value) => $_setBool(4, value);
  @$pb.TagNumber(5)
  $core.bool hasIsPinned() => $_has(4);
  @$pb.TagNumber(5)
  void clearIsPinned() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.int get activeTimeOffsetSeconds => $_getIZ(5);
  @$pb.TagNumber(6)
  set activeTimeOffsetSeconds($core.int value) => $_setSignedInt32(5, value);
  @$pb.TagNumber(6)
  $core.bool hasActiveTimeOffsetSeconds() => $_has(5);
  @$pb.TagNumber(6)
  void clearActiveTimeOffsetSeconds() => $_clearField(6);
}

class LiveCommerceServiceHighlightProductResponse extends $pb.GeneratedMessage {
  factory LiveCommerceServiceHighlightProductResponse({
    $core.String? sessionId,
    $core.String? pinnedProductId,
    $core.String? pinnedOfferId,
    $core.bool? isPinned,
    $core.bool? isDuplicate,
  }) {
    final result = LiveCommerceServiceHighlightProductResponse._();
    if (sessionId != null) result.sessionId = sessionId;
    if (pinnedProductId != null) result.pinnedProductId = pinnedProductId;
    if (pinnedOfferId != null) result.pinnedOfferId = pinnedOfferId;
    if (isPinned != null) result.isPinned = isPinned;
    if (isDuplicate != null) result.isDuplicate = isDuplicate;
    return result;
  }

  LiveCommerceServiceHighlightProductResponse._();

  factory LiveCommerceServiceHighlightProductResponse.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      LiveCommerceServiceHighlightProductResponse()
        ..mergeFromBuffer(data, registry);
  factory LiveCommerceServiceHighlightProductResponse.fromJson(
          $core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      LiveCommerceServiceHighlightProductResponse()
        ..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'LiveCommerceServiceHighlightProductResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance:
          LiveCommerceServiceHighlightProductResponse.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'sessionId')
    ..aOS(2, _omitFieldNames ? '' : 'pinnedProductId')
    ..aOS(3, _omitFieldNames ? '' : 'pinnedOfferId')
    ..aOB(4, _omitFieldNames ? '' : 'isPinned')
    ..aOB(5, _omitFieldNames ? '' : 'isDuplicate')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LiveCommerceServiceHighlightProductResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LiveCommerceServiceHighlightProductResponse copyWith(
          void Function(LiveCommerceServiceHighlightProductResponse) updates) =>
      super.copyWith((message) =>
              updates(message as LiveCommerceServiceHighlightProductResponse))
          as LiveCommerceServiceHighlightProductResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use LiveCommerceServiceHighlightProductResponse() / LiveCommerceServiceHighlightProductResponse.new instead')
  static LiveCommerceServiceHighlightProductResponse create() =>
      LiveCommerceServiceHighlightProductResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      LiveCommerceServiceHighlightProductResponse._();
  @$core.override
  LiveCommerceServiceHighlightProductResponse createEmptyInstance() =>
      LiveCommerceServiceHighlightProductResponse._();
  @$core.pragma('dart2js:noInline')
  static LiveCommerceServiceHighlightProductResponse getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
              LiveCommerceServiceHighlightProductResponse>(
          LiveCommerceServiceHighlightProductResponse.$_createMessage);
  static LiveCommerceServiceHighlightProductResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get sessionId => $_getSZ(0);
  @$pb.TagNumber(1)
  set sessionId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSessionId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSessionId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get pinnedProductId => $_getSZ(1);
  @$pb.TagNumber(2)
  set pinnedProductId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPinnedProductId() => $_has(1);
  @$pb.TagNumber(2)
  void clearPinnedProductId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get pinnedOfferId => $_getSZ(2);
  @$pb.TagNumber(3)
  set pinnedOfferId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPinnedOfferId() => $_has(2);
  @$pb.TagNumber(3)
  void clearPinnedOfferId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.bool get isPinned => $_getBF(3);
  @$pb.TagNumber(4)
  set isPinned($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(4)
  $core.bool hasIsPinned() => $_has(3);
  @$pb.TagNumber(4)
  void clearIsPinned() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.bool get isDuplicate => $_getBF(4);
  @$pb.TagNumber(5)
  set isDuplicate($core.bool value) => $_setBool(4, value);
  @$pb.TagNumber(5)
  $core.bool hasIsDuplicate() => $_has(4);
  @$pb.TagNumber(5)
  void clearIsDuplicate() => $_clearField(5);
}

class LiveCommerceServiceGetAnalyticsRequest extends $pb.GeneratedMessage {
  factory LiveCommerceServiceGetAnalyticsRequest({
    $core.String? sessionId,
    $core.String? workspaceId,
  }) {
    final result = LiveCommerceServiceGetAnalyticsRequest._();
    if (sessionId != null) result.sessionId = sessionId;
    if (workspaceId != null) result.workspaceId = workspaceId;
    return result;
  }

  LiveCommerceServiceGetAnalyticsRequest._();

  factory LiveCommerceServiceGetAnalyticsRequest.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      LiveCommerceServiceGetAnalyticsRequest()..mergeFromBuffer(data, registry);
  factory LiveCommerceServiceGetAnalyticsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      LiveCommerceServiceGetAnalyticsRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'LiveCommerceServiceGetAnalyticsRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance:
          LiveCommerceServiceGetAnalyticsRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'sessionId')
    ..aOS(2, _omitFieldNames ? '' : 'workspaceId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LiveCommerceServiceGetAnalyticsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LiveCommerceServiceGetAnalyticsRequest copyWith(
          void Function(LiveCommerceServiceGetAnalyticsRequest) updates) =>
      super.copyWith((message) =>
              updates(message as LiveCommerceServiceGetAnalyticsRequest))
          as LiveCommerceServiceGetAnalyticsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use LiveCommerceServiceGetAnalyticsRequest() / LiveCommerceServiceGetAnalyticsRequest.new instead')
  static LiveCommerceServiceGetAnalyticsRequest create() =>
      LiveCommerceServiceGetAnalyticsRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      LiveCommerceServiceGetAnalyticsRequest._();
  @$core.override
  LiveCommerceServiceGetAnalyticsRequest createEmptyInstance() =>
      LiveCommerceServiceGetAnalyticsRequest._();
  @$core.pragma('dart2js:noInline')
  static LiveCommerceServiceGetAnalyticsRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
              LiveCommerceServiceGetAnalyticsRequest>(
          LiveCommerceServiceGetAnalyticsRequest.$_createMessage);
  static LiveCommerceServiceGetAnalyticsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get sessionId => $_getSZ(0);
  @$pb.TagNumber(1)
  set sessionId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSessionId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSessionId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get workspaceId => $_getSZ(1);
  @$pb.TagNumber(2)
  set workspaceId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasWorkspaceId() => $_has(1);
  @$pb.TagNumber(2)
  void clearWorkspaceId() => $_clearField(2);
}

class LiveCommerceServiceGetAnalyticsResponse extends $pb.GeneratedMessage {
  factory LiveCommerceServiceGetAnalyticsResponse({
    $core.String? sessionId,
    LiveMetricsSnapshot? metrics,
    $fixnum.Int64? ordersCount,
    $2.Money? totalRevenue,
    $core.Iterable<TraceableOrderLink>? traceableOrders,
  }) {
    final result = LiveCommerceServiceGetAnalyticsResponse._();
    if (sessionId != null) result.sessionId = sessionId;
    if (metrics != null) result.metrics = metrics;
    if (ordersCount != null) result.ordersCount = ordersCount;
    if (totalRevenue != null) result.totalRevenue = totalRevenue;
    if (traceableOrders != null) result.traceableOrders.addAll(traceableOrders);
    return result;
  }

  LiveCommerceServiceGetAnalyticsResponse._();

  factory LiveCommerceServiceGetAnalyticsResponse.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      LiveCommerceServiceGetAnalyticsResponse()
        ..mergeFromBuffer(data, registry);
  factory LiveCommerceServiceGetAnalyticsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      LiveCommerceServiceGetAnalyticsResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'LiveCommerceServiceGetAnalyticsResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance:
          LiveCommerceServiceGetAnalyticsResponse.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'sessionId')
    ..aOM<LiveMetricsSnapshot>(2, _omitFieldNames ? '' : 'metrics',
        subBuilder: LiveMetricsSnapshot.$_createMessage)
    ..aInt64(3, _omitFieldNames ? '' : 'ordersCount')
    ..aOM<$2.Money>(4, _omitFieldNames ? '' : 'totalRevenue',
        subBuilder: $2.Money.$_createMessage)
    ..pPM<TraceableOrderLink>(5, _omitFieldNames ? '' : 'traceableOrders',
        subBuilder: TraceableOrderLink.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LiveCommerceServiceGetAnalyticsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LiveCommerceServiceGetAnalyticsResponse copyWith(
          void Function(LiveCommerceServiceGetAnalyticsResponse) updates) =>
      super.copyWith((message) =>
              updates(message as LiveCommerceServiceGetAnalyticsResponse))
          as LiveCommerceServiceGetAnalyticsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use LiveCommerceServiceGetAnalyticsResponse() / LiveCommerceServiceGetAnalyticsResponse.new instead')
  static LiveCommerceServiceGetAnalyticsResponse create() =>
      LiveCommerceServiceGetAnalyticsResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      LiveCommerceServiceGetAnalyticsResponse._();
  @$core.override
  LiveCommerceServiceGetAnalyticsResponse createEmptyInstance() =>
      LiveCommerceServiceGetAnalyticsResponse._();
  @$core.pragma('dart2js:noInline')
  static LiveCommerceServiceGetAnalyticsResponse getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
              LiveCommerceServiceGetAnalyticsResponse>(
          LiveCommerceServiceGetAnalyticsResponse.$_createMessage);
  static LiveCommerceServiceGetAnalyticsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get sessionId => $_getSZ(0);
  @$pb.TagNumber(1)
  set sessionId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSessionId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSessionId() => $_clearField(1);

  @$pb.TagNumber(2)
  LiveMetricsSnapshot get metrics => $_getN(1);
  @$pb.TagNumber(2)
  set metrics(LiveMetricsSnapshot value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasMetrics() => $_has(1);
  @$pb.TagNumber(2)
  void clearMetrics() => $_clearField(2);
  @$pb.TagNumber(2)
  LiveMetricsSnapshot ensureMetrics() => $_ensure(1);

  @$pb.TagNumber(3)
  $fixnum.Int64 get ordersCount => $_getI64(2);
  @$pb.TagNumber(3)
  set ordersCount($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasOrdersCount() => $_has(2);
  @$pb.TagNumber(3)
  void clearOrdersCount() => $_clearField(3);

  @$pb.TagNumber(4)
  $2.Money get totalRevenue => $_getN(3);
  @$pb.TagNumber(4)
  set totalRevenue($2.Money value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasTotalRevenue() => $_has(3);
  @$pb.TagNumber(4)
  void clearTotalRevenue() => $_clearField(4);
  @$pb.TagNumber(4)
  $2.Money ensureTotalRevenue() => $_ensure(3);

  @$pb.TagNumber(5)
  $pb.PbList<TraceableOrderLink> get traceableOrders => $_getList(4);
}

class LiveCommerceServiceUpdateRunOfShowRequest extends $pb.GeneratedMessage {
  factory LiveCommerceServiceUpdateRunOfShowRequest({
    $2.CommandContext? context,
    $core.String? sessionId,
    $core.Iterable<RunOfShowItem>? items,
  }) {
    final result = LiveCommerceServiceUpdateRunOfShowRequest._();
    if (context != null) result.context = context;
    if (sessionId != null) result.sessionId = sessionId;
    if (items != null) result.items.addAll(items);
    return result;
  }

  LiveCommerceServiceUpdateRunOfShowRequest._();

  factory LiveCommerceServiceUpdateRunOfShowRequest.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      LiveCommerceServiceUpdateRunOfShowRequest()
        ..mergeFromBuffer(data, registry);
  factory LiveCommerceServiceUpdateRunOfShowRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      LiveCommerceServiceUpdateRunOfShowRequest()
        ..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'LiveCommerceServiceUpdateRunOfShowRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance:
          LiveCommerceServiceUpdateRunOfShowRequest.$_createMessage)
    ..aOM<$2.CommandContext>(1, _omitFieldNames ? '' : 'context',
        subBuilder: $2.CommandContext.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'sessionId')
    ..pPM<RunOfShowItem>(3, _omitFieldNames ? '' : 'items',
        subBuilder: RunOfShowItem.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LiveCommerceServiceUpdateRunOfShowRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LiveCommerceServiceUpdateRunOfShowRequest copyWith(
          void Function(LiveCommerceServiceUpdateRunOfShowRequest) updates) =>
      super.copyWith((message) =>
              updates(message as LiveCommerceServiceUpdateRunOfShowRequest))
          as LiveCommerceServiceUpdateRunOfShowRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use LiveCommerceServiceUpdateRunOfShowRequest() / LiveCommerceServiceUpdateRunOfShowRequest.new instead')
  static LiveCommerceServiceUpdateRunOfShowRequest create() =>
      LiveCommerceServiceUpdateRunOfShowRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      LiveCommerceServiceUpdateRunOfShowRequest._();
  @$core.override
  LiveCommerceServiceUpdateRunOfShowRequest createEmptyInstance() =>
      LiveCommerceServiceUpdateRunOfShowRequest._();
  @$core.pragma('dart2js:noInline')
  static LiveCommerceServiceUpdateRunOfShowRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
              LiveCommerceServiceUpdateRunOfShowRequest>(
          LiveCommerceServiceUpdateRunOfShowRequest.$_createMessage);
  static LiveCommerceServiceUpdateRunOfShowRequest? _defaultInstance;

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
  $core.String get sessionId => $_getSZ(1);
  @$pb.TagNumber(2)
  set sessionId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSessionId() => $_has(1);
  @$pb.TagNumber(2)
  void clearSessionId() => $_clearField(2);

  @$pb.TagNumber(3)
  $pb.PbList<RunOfShowItem> get items => $_getList(2);
}

class LiveCommerceServiceUpdateRunOfShowResponse extends $pb.GeneratedMessage {
  factory LiveCommerceServiceUpdateRunOfShowResponse({
    LiveSession? session,
    $core.bool? isDuplicate,
  }) {
    final result = LiveCommerceServiceUpdateRunOfShowResponse._();
    if (session != null) result.session = session;
    if (isDuplicate != null) result.isDuplicate = isDuplicate;
    return result;
  }

  LiveCommerceServiceUpdateRunOfShowResponse._();

  factory LiveCommerceServiceUpdateRunOfShowResponse.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      LiveCommerceServiceUpdateRunOfShowResponse()
        ..mergeFromBuffer(data, registry);
  factory LiveCommerceServiceUpdateRunOfShowResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      LiveCommerceServiceUpdateRunOfShowResponse()
        ..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'LiveCommerceServiceUpdateRunOfShowResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance:
          LiveCommerceServiceUpdateRunOfShowResponse.$_createMessage)
    ..aOM<LiveSession>(1, _omitFieldNames ? '' : 'session',
        subBuilder: LiveSession.$_createMessage)
    ..aOB(2, _omitFieldNames ? '' : 'isDuplicate')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LiveCommerceServiceUpdateRunOfShowResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LiveCommerceServiceUpdateRunOfShowResponse copyWith(
          void Function(LiveCommerceServiceUpdateRunOfShowResponse) updates) =>
      super.copyWith((message) =>
              updates(message as LiveCommerceServiceUpdateRunOfShowResponse))
          as LiveCommerceServiceUpdateRunOfShowResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use LiveCommerceServiceUpdateRunOfShowResponse() / LiveCommerceServiceUpdateRunOfShowResponse.new instead')
  static LiveCommerceServiceUpdateRunOfShowResponse create() =>
      LiveCommerceServiceUpdateRunOfShowResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      LiveCommerceServiceUpdateRunOfShowResponse._();
  @$core.override
  LiveCommerceServiceUpdateRunOfShowResponse createEmptyInstance() =>
      LiveCommerceServiceUpdateRunOfShowResponse._();
  @$core.pragma('dart2js:noInline')
  static LiveCommerceServiceUpdateRunOfShowResponse getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
              LiveCommerceServiceUpdateRunOfShowResponse>(
          LiveCommerceServiceUpdateRunOfShowResponse.$_createMessage);
  static LiveCommerceServiceUpdateRunOfShowResponse? _defaultInstance;

  @$pb.TagNumber(1)
  LiveSession get session => $_getN(0);
  @$pb.TagNumber(1)
  set session(LiveSession value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasSession() => $_has(0);
  @$pb.TagNumber(1)
  void clearSession() => $_clearField(1);
  @$pb.TagNumber(1)
  LiveSession ensureSession() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.bool get isDuplicate => $_getBF(1);
  @$pb.TagNumber(2)
  set isDuplicate($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasIsDuplicate() => $_has(1);
  @$pb.TagNumber(2)
  void clearIsDuplicate() => $_clearField(2);
}

class LiveCommerceServiceCreateHighlightRequest extends $pb.GeneratedMessage {
  factory LiveCommerceServiceCreateHighlightRequest({
    $2.CommandContext? context,
    $core.String? sessionId,
    $core.String? title,
    $core.int? startOffsetSeconds,
    $core.int? endOffsetSeconds,
    $core.String? highlightType,
    $core.String? notes,
    $core.String? pinnedOfferId,
    $core.String? pinnedProductId,
    $core.bool? autoDetected,
    $core.double? engagementScore,
  }) {
    final result = LiveCommerceServiceCreateHighlightRequest._();
    if (context != null) result.context = context;
    if (sessionId != null) result.sessionId = sessionId;
    if (title != null) result.title = title;
    if (startOffsetSeconds != null)
      result.startOffsetSeconds = startOffsetSeconds;
    if (endOffsetSeconds != null) result.endOffsetSeconds = endOffsetSeconds;
    if (highlightType != null) result.highlightType = highlightType;
    if (notes != null) result.notes = notes;
    if (pinnedOfferId != null) result.pinnedOfferId = pinnedOfferId;
    if (pinnedProductId != null) result.pinnedProductId = pinnedProductId;
    if (autoDetected != null) result.autoDetected = autoDetected;
    if (engagementScore != null) result.engagementScore = engagementScore;
    return result;
  }

  LiveCommerceServiceCreateHighlightRequest._();

  factory LiveCommerceServiceCreateHighlightRequest.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      LiveCommerceServiceCreateHighlightRequest()
        ..mergeFromBuffer(data, registry);
  factory LiveCommerceServiceCreateHighlightRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      LiveCommerceServiceCreateHighlightRequest()
        ..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'LiveCommerceServiceCreateHighlightRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance:
          LiveCommerceServiceCreateHighlightRequest.$_createMessage)
    ..aOM<$2.CommandContext>(1, _omitFieldNames ? '' : 'context',
        subBuilder: $2.CommandContext.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'sessionId')
    ..aOS(3, _omitFieldNames ? '' : 'title')
    ..aI(4, _omitFieldNames ? '' : 'startOffsetSeconds')
    ..aI(5, _omitFieldNames ? '' : 'endOffsetSeconds')
    ..aOS(6, _omitFieldNames ? '' : 'highlightType')
    ..aOS(7, _omitFieldNames ? '' : 'notes')
    ..aOS(8, _omitFieldNames ? '' : 'pinnedOfferId')
    ..aOS(9, _omitFieldNames ? '' : 'pinnedProductId')
    ..aOB(10, _omitFieldNames ? '' : 'autoDetected')
    ..aD(11, _omitFieldNames ? '' : 'engagementScore')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LiveCommerceServiceCreateHighlightRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LiveCommerceServiceCreateHighlightRequest copyWith(
          void Function(LiveCommerceServiceCreateHighlightRequest) updates) =>
      super.copyWith((message) =>
              updates(message as LiveCommerceServiceCreateHighlightRequest))
          as LiveCommerceServiceCreateHighlightRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use LiveCommerceServiceCreateHighlightRequest() / LiveCommerceServiceCreateHighlightRequest.new instead')
  static LiveCommerceServiceCreateHighlightRequest create() =>
      LiveCommerceServiceCreateHighlightRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      LiveCommerceServiceCreateHighlightRequest._();
  @$core.override
  LiveCommerceServiceCreateHighlightRequest createEmptyInstance() =>
      LiveCommerceServiceCreateHighlightRequest._();
  @$core.pragma('dart2js:noInline')
  static LiveCommerceServiceCreateHighlightRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
              LiveCommerceServiceCreateHighlightRequest>(
          LiveCommerceServiceCreateHighlightRequest.$_createMessage);
  static LiveCommerceServiceCreateHighlightRequest? _defaultInstance;

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
  $core.String get sessionId => $_getSZ(1);
  @$pb.TagNumber(2)
  set sessionId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSessionId() => $_has(1);
  @$pb.TagNumber(2)
  void clearSessionId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get title => $_getSZ(2);
  @$pb.TagNumber(3)
  set title($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasTitle() => $_has(2);
  @$pb.TagNumber(3)
  void clearTitle() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get startOffsetSeconds => $_getIZ(3);
  @$pb.TagNumber(4)
  set startOffsetSeconds($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasStartOffsetSeconds() => $_has(3);
  @$pb.TagNumber(4)
  void clearStartOffsetSeconds() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get endOffsetSeconds => $_getIZ(4);
  @$pb.TagNumber(5)
  set endOffsetSeconds($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasEndOffsetSeconds() => $_has(4);
  @$pb.TagNumber(5)
  void clearEndOffsetSeconds() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get highlightType => $_getSZ(5);
  @$pb.TagNumber(6)
  set highlightType($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasHighlightType() => $_has(5);
  @$pb.TagNumber(6)
  void clearHighlightType() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get notes => $_getSZ(6);
  @$pb.TagNumber(7)
  set notes($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasNotes() => $_has(6);
  @$pb.TagNumber(7)
  void clearNotes() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get pinnedOfferId => $_getSZ(7);
  @$pb.TagNumber(8)
  set pinnedOfferId($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasPinnedOfferId() => $_has(7);
  @$pb.TagNumber(8)
  void clearPinnedOfferId() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get pinnedProductId => $_getSZ(8);
  @$pb.TagNumber(9)
  set pinnedProductId($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasPinnedProductId() => $_has(8);
  @$pb.TagNumber(9)
  void clearPinnedProductId() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.bool get autoDetected => $_getBF(9);
  @$pb.TagNumber(10)
  set autoDetected($core.bool value) => $_setBool(9, value);
  @$pb.TagNumber(10)
  $core.bool hasAutoDetected() => $_has(9);
  @$pb.TagNumber(10)
  void clearAutoDetected() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.double get engagementScore => $_getN(10);
  @$pb.TagNumber(11)
  set engagementScore($core.double value) => $_setDouble(10, value);
  @$pb.TagNumber(11)
  $core.bool hasEngagementScore() => $_has(10);
  @$pb.TagNumber(11)
  void clearEngagementScore() => $_clearField(11);
}

class LiveCommerceServiceCreateHighlightResponse extends $pb.GeneratedMessage {
  factory LiveCommerceServiceCreateHighlightResponse({
    Highlight? highlight,
    $core.bool? isDuplicate,
  }) {
    final result = LiveCommerceServiceCreateHighlightResponse._();
    if (highlight != null) result.highlight = highlight;
    if (isDuplicate != null) result.isDuplicate = isDuplicate;
    return result;
  }

  LiveCommerceServiceCreateHighlightResponse._();

  factory LiveCommerceServiceCreateHighlightResponse.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      LiveCommerceServiceCreateHighlightResponse()
        ..mergeFromBuffer(data, registry);
  factory LiveCommerceServiceCreateHighlightResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      LiveCommerceServiceCreateHighlightResponse()
        ..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'LiveCommerceServiceCreateHighlightResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance:
          LiveCommerceServiceCreateHighlightResponse.$_createMessage)
    ..aOM<Highlight>(1, _omitFieldNames ? '' : 'highlight',
        subBuilder: Highlight.$_createMessage)
    ..aOB(2, _omitFieldNames ? '' : 'isDuplicate')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LiveCommerceServiceCreateHighlightResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LiveCommerceServiceCreateHighlightResponse copyWith(
          void Function(LiveCommerceServiceCreateHighlightResponse) updates) =>
      super.copyWith((message) =>
              updates(message as LiveCommerceServiceCreateHighlightResponse))
          as LiveCommerceServiceCreateHighlightResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use LiveCommerceServiceCreateHighlightResponse() / LiveCommerceServiceCreateHighlightResponse.new instead')
  static LiveCommerceServiceCreateHighlightResponse create() =>
      LiveCommerceServiceCreateHighlightResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      LiveCommerceServiceCreateHighlightResponse._();
  @$core.override
  LiveCommerceServiceCreateHighlightResponse createEmptyInstance() =>
      LiveCommerceServiceCreateHighlightResponse._();
  @$core.pragma('dart2js:noInline')
  static LiveCommerceServiceCreateHighlightResponse getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
              LiveCommerceServiceCreateHighlightResponse>(
          LiveCommerceServiceCreateHighlightResponse.$_createMessage);
  static LiveCommerceServiceCreateHighlightResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Highlight get highlight => $_getN(0);
  @$pb.TagNumber(1)
  set highlight(Highlight value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasHighlight() => $_has(0);
  @$pb.TagNumber(1)
  void clearHighlight() => $_clearField(1);
  @$pb.TagNumber(1)
  Highlight ensureHighlight() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.bool get isDuplicate => $_getBF(1);
  @$pb.TagNumber(2)
  set isDuplicate($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasIsDuplicate() => $_has(1);
  @$pb.TagNumber(2)
  void clearIsDuplicate() => $_clearField(2);
}

class LiveCommerceServiceExtractHighlightsRequest extends $pb.GeneratedMessage {
  factory LiveCommerceServiceExtractHighlightsRequest({
    $2.CommandContext? context,
    $core.String? sessionId,
    $core.String? sourceAssetId,
    $core.Iterable<$core.String>? highlightIds,
  }) {
    final result = LiveCommerceServiceExtractHighlightsRequest._();
    if (context != null) result.context = context;
    if (sessionId != null) result.sessionId = sessionId;
    if (sourceAssetId != null) result.sourceAssetId = sourceAssetId;
    if (highlightIds != null) result.highlightIds.addAll(highlightIds);
    return result;
  }

  LiveCommerceServiceExtractHighlightsRequest._();

  factory LiveCommerceServiceExtractHighlightsRequest.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      LiveCommerceServiceExtractHighlightsRequest()
        ..mergeFromBuffer(data, registry);
  factory LiveCommerceServiceExtractHighlightsRequest.fromJson(
          $core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      LiveCommerceServiceExtractHighlightsRequest()
        ..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'LiveCommerceServiceExtractHighlightsRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance:
          LiveCommerceServiceExtractHighlightsRequest.$_createMessage)
    ..aOM<$2.CommandContext>(1, _omitFieldNames ? '' : 'context',
        subBuilder: $2.CommandContext.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'sessionId')
    ..aOS(3, _omitFieldNames ? '' : 'sourceAssetId')
    ..pPS(4, _omitFieldNames ? '' : 'highlightIds')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LiveCommerceServiceExtractHighlightsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LiveCommerceServiceExtractHighlightsRequest copyWith(
          void Function(LiveCommerceServiceExtractHighlightsRequest) updates) =>
      super.copyWith((message) =>
              updates(message as LiveCommerceServiceExtractHighlightsRequest))
          as LiveCommerceServiceExtractHighlightsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use LiveCommerceServiceExtractHighlightsRequest() / LiveCommerceServiceExtractHighlightsRequest.new instead')
  static LiveCommerceServiceExtractHighlightsRequest create() =>
      LiveCommerceServiceExtractHighlightsRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      LiveCommerceServiceExtractHighlightsRequest._();
  @$core.override
  LiveCommerceServiceExtractHighlightsRequest createEmptyInstance() =>
      LiveCommerceServiceExtractHighlightsRequest._();
  @$core.pragma('dart2js:noInline')
  static LiveCommerceServiceExtractHighlightsRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
              LiveCommerceServiceExtractHighlightsRequest>(
          LiveCommerceServiceExtractHighlightsRequest.$_createMessage);
  static LiveCommerceServiceExtractHighlightsRequest? _defaultInstance;

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
  $core.String get sessionId => $_getSZ(1);
  @$pb.TagNumber(2)
  set sessionId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSessionId() => $_has(1);
  @$pb.TagNumber(2)
  void clearSessionId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get sourceAssetId => $_getSZ(2);
  @$pb.TagNumber(3)
  set sourceAssetId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasSourceAssetId() => $_has(2);
  @$pb.TagNumber(3)
  void clearSourceAssetId() => $_clearField(3);

  @$pb.TagNumber(4)
  $pb.PbList<$core.String> get highlightIds => $_getList(3);
}

class LiveCommerceServiceExtractHighlightsResponse
    extends $pb.GeneratedMessage {
  factory LiveCommerceServiceExtractHighlightsResponse({
    $core.String? sessionId,
    $core.int? extractedCount,
    $core.Iterable<Highlight>? updatedHighlights,
    $core.Iterable<$core.String>? registeredDerivativeAssetIds,
    $core.bool? isDuplicate,
  }) {
    final result = LiveCommerceServiceExtractHighlightsResponse._();
    if (sessionId != null) result.sessionId = sessionId;
    if (extractedCount != null) result.extractedCount = extractedCount;
    if (updatedHighlights != null)
      result.updatedHighlights.addAll(updatedHighlights);
    if (registeredDerivativeAssetIds != null)
      result.registeredDerivativeAssetIds.addAll(registeredDerivativeAssetIds);
    if (isDuplicate != null) result.isDuplicate = isDuplicate;
    return result;
  }

  LiveCommerceServiceExtractHighlightsResponse._();

  factory LiveCommerceServiceExtractHighlightsResponse.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      LiveCommerceServiceExtractHighlightsResponse()
        ..mergeFromBuffer(data, registry);
  factory LiveCommerceServiceExtractHighlightsResponse.fromJson(
          $core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      LiveCommerceServiceExtractHighlightsResponse()
        ..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'LiveCommerceServiceExtractHighlightsResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance:
          LiveCommerceServiceExtractHighlightsResponse.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'sessionId')
    ..aI(2, _omitFieldNames ? '' : 'extractedCount')
    ..pPM<Highlight>(3, _omitFieldNames ? '' : 'updatedHighlights',
        subBuilder: Highlight.$_createMessage)
    ..pPS(4, _omitFieldNames ? '' : 'registeredDerivativeAssetIds')
    ..aOB(5, _omitFieldNames ? '' : 'isDuplicate')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LiveCommerceServiceExtractHighlightsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LiveCommerceServiceExtractHighlightsResponse copyWith(
          void Function(LiveCommerceServiceExtractHighlightsResponse)
              updates) =>
      super.copyWith((message) =>
              updates(message as LiveCommerceServiceExtractHighlightsResponse))
          as LiveCommerceServiceExtractHighlightsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use LiveCommerceServiceExtractHighlightsResponse() / LiveCommerceServiceExtractHighlightsResponse.new instead')
  static LiveCommerceServiceExtractHighlightsResponse create() =>
      LiveCommerceServiceExtractHighlightsResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      LiveCommerceServiceExtractHighlightsResponse._();
  @$core.override
  LiveCommerceServiceExtractHighlightsResponse createEmptyInstance() =>
      LiveCommerceServiceExtractHighlightsResponse._();
  @$core.pragma('dart2js:noInline')
  static LiveCommerceServiceExtractHighlightsResponse getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
              LiveCommerceServiceExtractHighlightsResponse>(
          LiveCommerceServiceExtractHighlightsResponse.$_createMessage);
  static LiveCommerceServiceExtractHighlightsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get sessionId => $_getSZ(0);
  @$pb.TagNumber(1)
  set sessionId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSessionId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSessionId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get extractedCount => $_getIZ(1);
  @$pb.TagNumber(2)
  set extractedCount($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasExtractedCount() => $_has(1);
  @$pb.TagNumber(2)
  void clearExtractedCount() => $_clearField(2);

  @$pb.TagNumber(3)
  $pb.PbList<Highlight> get updatedHighlights => $_getList(2);

  @$pb.TagNumber(4)
  $pb.PbList<$core.String> get registeredDerivativeAssetIds => $_getList(3);

  @$pb.TagNumber(5)
  $core.bool get isDuplicate => $_getBF(4);
  @$pb.TagNumber(5)
  set isDuplicate($core.bool value) => $_setBool(4, value);
  @$pb.TagNumber(5)
  $core.bool hasIsDuplicate() => $_has(4);
  @$pb.TagNumber(5)
  void clearIsDuplicate() => $_clearField(5);
}

class LiveCommerceServiceGetProofSummaryRequest extends $pb.GeneratedMessage {
  factory LiveCommerceServiceGetProofSummaryRequest({
    $core.String? sessionId,
    $core.String? workspaceId,
  }) {
    final result = LiveCommerceServiceGetProofSummaryRequest._();
    if (sessionId != null) result.sessionId = sessionId;
    if (workspaceId != null) result.workspaceId = workspaceId;
    return result;
  }

  LiveCommerceServiceGetProofSummaryRequest._();

  factory LiveCommerceServiceGetProofSummaryRequest.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      LiveCommerceServiceGetProofSummaryRequest()
        ..mergeFromBuffer(data, registry);
  factory LiveCommerceServiceGetProofSummaryRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      LiveCommerceServiceGetProofSummaryRequest()
        ..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'LiveCommerceServiceGetProofSummaryRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance:
          LiveCommerceServiceGetProofSummaryRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'sessionId')
    ..aOS(2, _omitFieldNames ? '' : 'workspaceId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LiveCommerceServiceGetProofSummaryRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LiveCommerceServiceGetProofSummaryRequest copyWith(
          void Function(LiveCommerceServiceGetProofSummaryRequest) updates) =>
      super.copyWith((message) =>
              updates(message as LiveCommerceServiceGetProofSummaryRequest))
          as LiveCommerceServiceGetProofSummaryRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use LiveCommerceServiceGetProofSummaryRequest() / LiveCommerceServiceGetProofSummaryRequest.new instead')
  static LiveCommerceServiceGetProofSummaryRequest create() =>
      LiveCommerceServiceGetProofSummaryRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      LiveCommerceServiceGetProofSummaryRequest._();
  @$core.override
  LiveCommerceServiceGetProofSummaryRequest createEmptyInstance() =>
      LiveCommerceServiceGetProofSummaryRequest._();
  @$core.pragma('dart2js:noInline')
  static LiveCommerceServiceGetProofSummaryRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
              LiveCommerceServiceGetProofSummaryRequest>(
          LiveCommerceServiceGetProofSummaryRequest.$_createMessage);
  static LiveCommerceServiceGetProofSummaryRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get sessionId => $_getSZ(0);
  @$pb.TagNumber(1)
  set sessionId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSessionId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSessionId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get workspaceId => $_getSZ(1);
  @$pb.TagNumber(2)
  set workspaceId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasWorkspaceId() => $_has(1);
  @$pb.TagNumber(2)
  void clearWorkspaceId() => $_clearField(2);
}

class LiveCommerceServiceGetProofSummaryResponse extends $pb.GeneratedMessage {
  factory LiveCommerceServiceGetProofSummaryResponse({
    PostLiveProofSummary? summary,
  }) {
    final result = LiveCommerceServiceGetProofSummaryResponse._();
    if (summary != null) result.summary = summary;
    return result;
  }

  LiveCommerceServiceGetProofSummaryResponse._();

  factory LiveCommerceServiceGetProofSummaryResponse.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      LiveCommerceServiceGetProofSummaryResponse()
        ..mergeFromBuffer(data, registry);
  factory LiveCommerceServiceGetProofSummaryResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      LiveCommerceServiceGetProofSummaryResponse()
        ..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'LiveCommerceServiceGetProofSummaryResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance:
          LiveCommerceServiceGetProofSummaryResponse.$_createMessage)
    ..aOM<PostLiveProofSummary>(1, _omitFieldNames ? '' : 'summary',
        subBuilder: PostLiveProofSummary.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LiveCommerceServiceGetProofSummaryResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LiveCommerceServiceGetProofSummaryResponse copyWith(
          void Function(LiveCommerceServiceGetProofSummaryResponse) updates) =>
      super.copyWith((message) =>
              updates(message as LiveCommerceServiceGetProofSummaryResponse))
          as LiveCommerceServiceGetProofSummaryResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use LiveCommerceServiceGetProofSummaryResponse() / LiveCommerceServiceGetProofSummaryResponse.new instead')
  static LiveCommerceServiceGetProofSummaryResponse create() =>
      LiveCommerceServiceGetProofSummaryResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      LiveCommerceServiceGetProofSummaryResponse._();
  @$core.override
  LiveCommerceServiceGetProofSummaryResponse createEmptyInstance() =>
      LiveCommerceServiceGetProofSummaryResponse._();
  @$core.pragma('dart2js:noInline')
  static LiveCommerceServiceGetProofSummaryResponse getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
              LiveCommerceServiceGetProofSummaryResponse>(
          LiveCommerceServiceGetProofSummaryResponse.$_createMessage);
  static LiveCommerceServiceGetProofSummaryResponse? _defaultInstance;

  @$pb.TagNumber(1)
  PostLiveProofSummary get summary => $_getN(0);
  @$pb.TagNumber(1)
  set summary(PostLiveProofSummary value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasSummary() => $_has(0);
  @$pb.TagNumber(1)
  void clearSummary() => $_clearField(1);
  @$pb.TagNumber(1)
  PostLiveProofSummary ensureSummary() => $_ensure(0);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');

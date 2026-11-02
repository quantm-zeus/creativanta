// This is a generated file - do not edit.
//
// Generated from creativanta/admin/v1/diagnostics.proto.

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
import 'diagnostics.pbenum.dart';

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'diagnostics.pbenum.dart';

/// Request for GetOverview.
class GetOverviewRequest extends $pb.GeneratedMessage {
  factory GetOverviewRequest({
    $1.UUID? workspaceId,
  }) {
    final result = GetOverviewRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    return result;
  }

  GetOverviewRequest._();

  factory GetOverviewRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetOverviewRequest()..mergeFromBuffer(data, registry);
  factory GetOverviewRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetOverviewRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetOverviewRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.admin.v1'),
      createEmptyInstance: GetOverviewRequest.$_createMessage)
    ..aOM<$1.UUID>(1, _omitFieldNames ? '' : 'workspaceId',
        subBuilder: $1.UUID.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetOverviewRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetOverviewRequest copyWith(void Function(GetOverviewRequest) updates) =>
      super.copyWith((message) => updates(message as GetOverviewRequest))
          as GetOverviewRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use GetOverviewRequest() / GetOverviewRequest.new instead')
  static GetOverviewRequest create() => GetOverviewRequest._();
  static $pb.GeneratedMessage $_createMessage() => GetOverviewRequest._();
  @$core.override
  GetOverviewRequest createEmptyInstance() => GetOverviewRequest._();
  @$core.pragma('dart2js:noInline')
  static GetOverviewRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetOverviewRequest>(
          GetOverviewRequest.$_createMessage);
  static GetOverviewRequest? _defaultInstance;

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

/// Response for GetOverview.
class GetOverviewResponse extends $pb.GeneratedMessage {
  factory GetOverviewResponse({
    $1.UUID? workspaceId,
    DiagnosticHealthStatus? overallStatus,
    $core.int? activeIssuesCount,
    $core.int? criticalIssuesCount,
    $core.int? warningIssuesCount,
    $core.int? healthyCategoriesCount,
    $core.int? totalCategoriesCount,
    $core.int? unknownExternalEffectsCount,
    $core.int? pendingDlqCount,
    $2.Timestamp? lastCheckedAt,
  }) {
    final result = GetOverviewResponse._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (overallStatus != null) result.overallStatus = overallStatus;
    if (activeIssuesCount != null) result.activeIssuesCount = activeIssuesCount;
    if (criticalIssuesCount != null)
      result.criticalIssuesCount = criticalIssuesCount;
    if (warningIssuesCount != null)
      result.warningIssuesCount = warningIssuesCount;
    if (healthyCategoriesCount != null)
      result.healthyCategoriesCount = healthyCategoriesCount;
    if (totalCategoriesCount != null)
      result.totalCategoriesCount = totalCategoriesCount;
    if (unknownExternalEffectsCount != null)
      result.unknownExternalEffectsCount = unknownExternalEffectsCount;
    if (pendingDlqCount != null) result.pendingDlqCount = pendingDlqCount;
    if (lastCheckedAt != null) result.lastCheckedAt = lastCheckedAt;
    return result;
  }

  GetOverviewResponse._();

  factory GetOverviewResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetOverviewResponse()..mergeFromBuffer(data, registry);
  factory GetOverviewResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetOverviewResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetOverviewResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.admin.v1'),
      createEmptyInstance: GetOverviewResponse.$_createMessage)
    ..aOM<$1.UUID>(1, _omitFieldNames ? '' : 'workspaceId',
        subBuilder: $1.UUID.$_createMessage)
    ..aE<DiagnosticHealthStatus>(2, _omitFieldNames ? '' : 'overallStatus',
        enumValues: DiagnosticHealthStatus.values)
    ..aI(3, _omitFieldNames ? '' : 'activeIssuesCount')
    ..aI(4, _omitFieldNames ? '' : 'criticalIssuesCount')
    ..aI(5, _omitFieldNames ? '' : 'warningIssuesCount')
    ..aI(6, _omitFieldNames ? '' : 'healthyCategoriesCount')
    ..aI(7, _omitFieldNames ? '' : 'totalCategoriesCount')
    ..aI(8, _omitFieldNames ? '' : 'unknownExternalEffectsCount')
    ..aI(9, _omitFieldNames ? '' : 'pendingDlqCount')
    ..aOM<$2.Timestamp>(10, _omitFieldNames ? '' : 'lastCheckedAt',
        subBuilder: $2.Timestamp.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetOverviewResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetOverviewResponse copyWith(void Function(GetOverviewResponse) updates) =>
      super.copyWith((message) => updates(message as GetOverviewResponse))
          as GetOverviewResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core
      .Deprecated('Use GetOverviewResponse() / GetOverviewResponse.new instead')
  static GetOverviewResponse create() => GetOverviewResponse._();
  static $pb.GeneratedMessage $_createMessage() => GetOverviewResponse._();
  @$core.override
  GetOverviewResponse createEmptyInstance() => GetOverviewResponse._();
  @$core.pragma('dart2js:noInline')
  static GetOverviewResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetOverviewResponse>(
          GetOverviewResponse.$_createMessage);
  static GetOverviewResponse? _defaultInstance;

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
  DiagnosticHealthStatus get overallStatus => $_getN(1);
  @$pb.TagNumber(2)
  set overallStatus(DiagnosticHealthStatus value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasOverallStatus() => $_has(1);
  @$pb.TagNumber(2)
  void clearOverallStatus() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get activeIssuesCount => $_getIZ(2);
  @$pb.TagNumber(3)
  set activeIssuesCount($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasActiveIssuesCount() => $_has(2);
  @$pb.TagNumber(3)
  void clearActiveIssuesCount() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get criticalIssuesCount => $_getIZ(3);
  @$pb.TagNumber(4)
  set criticalIssuesCount($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasCriticalIssuesCount() => $_has(3);
  @$pb.TagNumber(4)
  void clearCriticalIssuesCount() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get warningIssuesCount => $_getIZ(4);
  @$pb.TagNumber(5)
  set warningIssuesCount($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasWarningIssuesCount() => $_has(4);
  @$pb.TagNumber(5)
  void clearWarningIssuesCount() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.int get healthyCategoriesCount => $_getIZ(5);
  @$pb.TagNumber(6)
  set healthyCategoriesCount($core.int value) => $_setSignedInt32(5, value);
  @$pb.TagNumber(6)
  $core.bool hasHealthyCategoriesCount() => $_has(5);
  @$pb.TagNumber(6)
  void clearHealthyCategoriesCount() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.int get totalCategoriesCount => $_getIZ(6);
  @$pb.TagNumber(7)
  set totalCategoriesCount($core.int value) => $_setSignedInt32(6, value);
  @$pb.TagNumber(7)
  $core.bool hasTotalCategoriesCount() => $_has(6);
  @$pb.TagNumber(7)
  void clearTotalCategoriesCount() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.int get unknownExternalEffectsCount => $_getIZ(7);
  @$pb.TagNumber(8)
  set unknownExternalEffectsCount($core.int value) =>
      $_setSignedInt32(7, value);
  @$pb.TagNumber(8)
  $core.bool hasUnknownExternalEffectsCount() => $_has(7);
  @$pb.TagNumber(8)
  void clearUnknownExternalEffectsCount() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.int get pendingDlqCount => $_getIZ(8);
  @$pb.TagNumber(9)
  set pendingDlqCount($core.int value) => $_setSignedInt32(8, value);
  @$pb.TagNumber(9)
  $core.bool hasPendingDlqCount() => $_has(8);
  @$pb.TagNumber(9)
  void clearPendingDlqCount() => $_clearField(9);

  @$pb.TagNumber(10)
  $2.Timestamp get lastCheckedAt => $_getN(9);
  @$pb.TagNumber(10)
  set lastCheckedAt($2.Timestamp value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasLastCheckedAt() => $_has(9);
  @$pb.TagNumber(10)
  void clearLastCheckedAt() => $_clearField(10);
  @$pb.TagNumber(10)
  $2.Timestamp ensureLastCheckedAt() => $_ensure(9);
}

/// Request for GetHealthGrid.
class GetHealthGridRequest extends $pb.GeneratedMessage {
  factory GetHealthGridRequest({
    $1.UUID? workspaceId,
  }) {
    final result = GetHealthGridRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    return result;
  }

  GetHealthGridRequest._();

  factory GetHealthGridRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetHealthGridRequest()..mergeFromBuffer(data, registry);
  factory GetHealthGridRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetHealthGridRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetHealthGridRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.admin.v1'),
      createEmptyInstance: GetHealthGridRequest.$_createMessage)
    ..aOM<$1.UUID>(1, _omitFieldNames ? '' : 'workspaceId',
        subBuilder: $1.UUID.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetHealthGridRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetHealthGridRequest copyWith(void Function(GetHealthGridRequest) updates) =>
      super.copyWith((message) => updates(message as GetHealthGridRequest))
          as GetHealthGridRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use GetHealthGridRequest() / GetHealthGridRequest.new instead')
  static GetHealthGridRequest create() => GetHealthGridRequest._();
  static $pb.GeneratedMessage $_createMessage() => GetHealthGridRequest._();
  @$core.override
  GetHealthGridRequest createEmptyInstance() => GetHealthGridRequest._();
  @$core.pragma('dart2js:noInline')
  static GetHealthGridRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetHealthGridRequest>(
          GetHealthGridRequest.$_createMessage);
  static GetHealthGridRequest? _defaultInstance;

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

/// Single category card in the 8-category diagnostic health grid.
class HealthCategoryCard extends $pb.GeneratedMessage {
  factory HealthCategoryCard({
    $core.String? categoryKey,
    $core.String? displayName,
    DiagnosticHealthStatus? status,
    $core.String? summary,
    $core.int? openIssuesCount,
    $2.Timestamp? lastCheckedAt,
  }) {
    final result = HealthCategoryCard._();
    if (categoryKey != null) result.categoryKey = categoryKey;
    if (displayName != null) result.displayName = displayName;
    if (status != null) result.status = status;
    if (summary != null) result.summary = summary;
    if (openIssuesCount != null) result.openIssuesCount = openIssuesCount;
    if (lastCheckedAt != null) result.lastCheckedAt = lastCheckedAt;
    return result;
  }

  HealthCategoryCard._();

  factory HealthCategoryCard.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      HealthCategoryCard()..mergeFromBuffer(data, registry);
  factory HealthCategoryCard.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      HealthCategoryCard()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'HealthCategoryCard',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.admin.v1'),
      createEmptyInstance: HealthCategoryCard.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'categoryKey')
    ..aOS(2, _omitFieldNames ? '' : 'displayName')
    ..aE<DiagnosticHealthStatus>(3, _omitFieldNames ? '' : 'status',
        enumValues: DiagnosticHealthStatus.values)
    ..aOS(4, _omitFieldNames ? '' : 'summary')
    ..aI(5, _omitFieldNames ? '' : 'openIssuesCount')
    ..aOM<$2.Timestamp>(6, _omitFieldNames ? '' : 'lastCheckedAt',
        subBuilder: $2.Timestamp.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  HealthCategoryCard clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  HealthCategoryCard copyWith(void Function(HealthCategoryCard) updates) =>
      super.copyWith((message) => updates(message as HealthCategoryCard))
          as HealthCategoryCard;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use HealthCategoryCard() / HealthCategoryCard.new instead')
  static HealthCategoryCard create() => HealthCategoryCard._();
  static $pb.GeneratedMessage $_createMessage() => HealthCategoryCard._();
  @$core.override
  HealthCategoryCard createEmptyInstance() => HealthCategoryCard._();
  @$core.pragma('dart2js:noInline')
  static HealthCategoryCard getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<HealthCategoryCard>(
          HealthCategoryCard.$_createMessage);
  static HealthCategoryCard? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get categoryKey => $_getSZ(0);
  @$pb.TagNumber(1)
  set categoryKey($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCategoryKey() => $_has(0);
  @$pb.TagNumber(1)
  void clearCategoryKey() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get displayName => $_getSZ(1);
  @$pb.TagNumber(2)
  set displayName($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasDisplayName() => $_has(1);
  @$pb.TagNumber(2)
  void clearDisplayName() => $_clearField(2);

  @$pb.TagNumber(3)
  DiagnosticHealthStatus get status => $_getN(2);
  @$pb.TagNumber(3)
  set status(DiagnosticHealthStatus value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasStatus() => $_has(2);
  @$pb.TagNumber(3)
  void clearStatus() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get summary => $_getSZ(3);
  @$pb.TagNumber(4)
  set summary($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasSummary() => $_has(3);
  @$pb.TagNumber(4)
  void clearSummary() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get openIssuesCount => $_getIZ(4);
  @$pb.TagNumber(5)
  set openIssuesCount($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasOpenIssuesCount() => $_has(4);
  @$pb.TagNumber(5)
  void clearOpenIssuesCount() => $_clearField(5);

  @$pb.TagNumber(6)
  $2.Timestamp get lastCheckedAt => $_getN(5);
  @$pb.TagNumber(6)
  set lastCheckedAt($2.Timestamp value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasLastCheckedAt() => $_has(5);
  @$pb.TagNumber(6)
  void clearLastCheckedAt() => $_clearField(6);
  @$pb.TagNumber(6)
  $2.Timestamp ensureLastCheckedAt() => $_ensure(5);
}

/// Response for GetHealthGrid.
class GetHealthGridResponse extends $pb.GeneratedMessage {
  factory GetHealthGridResponse({
    $1.UUID? workspaceId,
    $core.Iterable<HealthCategoryCard>? categories,
    $2.Timestamp? generatedAt,
  }) {
    final result = GetHealthGridResponse._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (categories != null) result.categories.addAll(categories);
    if (generatedAt != null) result.generatedAt = generatedAt;
    return result;
  }

  GetHealthGridResponse._();

  factory GetHealthGridResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetHealthGridResponse()..mergeFromBuffer(data, registry);
  factory GetHealthGridResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetHealthGridResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetHealthGridResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.admin.v1'),
      createEmptyInstance: GetHealthGridResponse.$_createMessage)
    ..aOM<$1.UUID>(1, _omitFieldNames ? '' : 'workspaceId',
        subBuilder: $1.UUID.$_createMessage)
    ..pPM<HealthCategoryCard>(2, _omitFieldNames ? '' : 'categories',
        subBuilder: HealthCategoryCard.$_createMessage)
    ..aOM<$2.Timestamp>(3, _omitFieldNames ? '' : 'generatedAt',
        subBuilder: $2.Timestamp.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetHealthGridResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetHealthGridResponse copyWith(
          void Function(GetHealthGridResponse) updates) =>
      super.copyWith((message) => updates(message as GetHealthGridResponse))
          as GetHealthGridResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use GetHealthGridResponse() / GetHealthGridResponse.new instead')
  static GetHealthGridResponse create() => GetHealthGridResponse._();
  static $pb.GeneratedMessage $_createMessage() => GetHealthGridResponse._();
  @$core.override
  GetHealthGridResponse createEmptyInstance() => GetHealthGridResponse._();
  @$core.pragma('dart2js:noInline')
  static GetHealthGridResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetHealthGridResponse>(
          GetHealthGridResponse.$_createMessage);
  static GetHealthGridResponse? _defaultInstance;

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
  $pb.PbList<HealthCategoryCard> get categories => $_getList(1);

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

/// Request for ListIssues.
class ListIssuesRequest extends $pb.GeneratedMessage {
  factory ListIssuesRequest({
    $1.UUID? workspaceId,
    $1.Pagination? pagination,
    DiagnosticSeverity? severityFilter,
    DiagnosticIssueStatus? statusFilter,
    $core.String? scopeTypeFilter,
  }) {
    final result = ListIssuesRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (pagination != null) result.pagination = pagination;
    if (severityFilter != null) result.severityFilter = severityFilter;
    if (statusFilter != null) result.statusFilter = statusFilter;
    if (scopeTypeFilter != null) result.scopeTypeFilter = scopeTypeFilter;
    return result;
  }

  ListIssuesRequest._();

  factory ListIssuesRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListIssuesRequest()..mergeFromBuffer(data, registry);
  factory ListIssuesRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListIssuesRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListIssuesRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.admin.v1'),
      createEmptyInstance: ListIssuesRequest.$_createMessage)
    ..aOM<$1.UUID>(1, _omitFieldNames ? '' : 'workspaceId',
        subBuilder: $1.UUID.$_createMessage)
    ..aOM<$1.Pagination>(2, _omitFieldNames ? '' : 'pagination',
        subBuilder: $1.Pagination.$_createMessage)
    ..aE<DiagnosticSeverity>(3, _omitFieldNames ? '' : 'severityFilter',
        enumValues: DiagnosticSeverity.values)
    ..aE<DiagnosticIssueStatus>(4, _omitFieldNames ? '' : 'statusFilter',
        enumValues: DiagnosticIssueStatus.values)
    ..aOS(5, _omitFieldNames ? '' : 'scopeTypeFilter')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListIssuesRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListIssuesRequest copyWith(void Function(ListIssuesRequest) updates) =>
      super.copyWith((message) => updates(message as ListIssuesRequest))
          as ListIssuesRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ListIssuesRequest() / ListIssuesRequest.new instead')
  static ListIssuesRequest create() => ListIssuesRequest._();
  static $pb.GeneratedMessage $_createMessage() => ListIssuesRequest._();
  @$core.override
  ListIssuesRequest createEmptyInstance() => ListIssuesRequest._();
  @$core.pragma('dart2js:noInline')
  static ListIssuesRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ListIssuesRequest>(
          ListIssuesRequest.$_createMessage);
  static ListIssuesRequest? _defaultInstance;

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
  $1.Pagination get pagination => $_getN(1);
  @$pb.TagNumber(2)
  set pagination($1.Pagination value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasPagination() => $_has(1);
  @$pb.TagNumber(2)
  void clearPagination() => $_clearField(2);
  @$pb.TagNumber(2)
  $1.Pagination ensurePagination() => $_ensure(1);

  @$pb.TagNumber(3)
  DiagnosticSeverity get severityFilter => $_getN(2);
  @$pb.TagNumber(3)
  set severityFilter(DiagnosticSeverity value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasSeverityFilter() => $_has(2);
  @$pb.TagNumber(3)
  void clearSeverityFilter() => $_clearField(3);

  @$pb.TagNumber(4)
  DiagnosticIssueStatus get statusFilter => $_getN(3);
  @$pb.TagNumber(4)
  set statusFilter(DiagnosticIssueStatus value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasStatusFilter() => $_has(3);
  @$pb.TagNumber(4)
  void clearStatusFilter() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get scopeTypeFilter => $_getSZ(4);
  @$pb.TagNumber(5)
  set scopeTypeFilter($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasScopeTypeFilter() => $_has(4);
  @$pb.TagNumber(5)
  void clearScopeTypeFilter() => $_clearField(5);
}

/// User-facing diagnostic issue record compliant with RULE-M23-A04.
class DiagnosticIssue extends $pb.GeneratedMessage {
  factory DiagnosticIssue({
    $1.UUID? diagnosticsId,
    $1.UUID? workspaceId,
    $core.String? scopeType,
    $1.UUID? scopeId,
    $core.String? errorType,
    DiagnosticSeverity? severity,
    $core.String? userFacingExplanation,
    $core.Iterable<$core.String>? likelyCauses,
    $core.Iterable<$core.String>? suggestedActions,
    $core.String? repairPath,
    DiagnosticIssueStatus? status,
    $core.bool? requiresManualReconciliation,
    $2.Timestamp? detectedAt,
    $2.Timestamp? resolvedAt,
  }) {
    final result = DiagnosticIssue._();
    if (diagnosticsId != null) result.diagnosticsId = diagnosticsId;
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (scopeType != null) result.scopeType = scopeType;
    if (scopeId != null) result.scopeId = scopeId;
    if (errorType != null) result.errorType = errorType;
    if (severity != null) result.severity = severity;
    if (userFacingExplanation != null)
      result.userFacingExplanation = userFacingExplanation;
    if (likelyCauses != null) result.likelyCauses.addAll(likelyCauses);
    if (suggestedActions != null)
      result.suggestedActions.addAll(suggestedActions);
    if (repairPath != null) result.repairPath = repairPath;
    if (status != null) result.status = status;
    if (requiresManualReconciliation != null)
      result.requiresManualReconciliation = requiresManualReconciliation;
    if (detectedAt != null) result.detectedAt = detectedAt;
    if (resolvedAt != null) result.resolvedAt = resolvedAt;
    return result;
  }

  DiagnosticIssue._();

  factory DiagnosticIssue.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      DiagnosticIssue()..mergeFromBuffer(data, registry);
  factory DiagnosticIssue.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      DiagnosticIssue()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DiagnosticIssue',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.admin.v1'),
      createEmptyInstance: DiagnosticIssue.$_createMessage)
    ..aOM<$1.UUID>(1, _omitFieldNames ? '' : 'diagnosticsId',
        subBuilder: $1.UUID.$_createMessage)
    ..aOM<$1.UUID>(2, _omitFieldNames ? '' : 'workspaceId',
        subBuilder: $1.UUID.$_createMessage)
    ..aOS(3, _omitFieldNames ? '' : 'scopeType')
    ..aOM<$1.UUID>(4, _omitFieldNames ? '' : 'scopeId',
        subBuilder: $1.UUID.$_createMessage)
    ..aOS(5, _omitFieldNames ? '' : 'errorType')
    ..aE<DiagnosticSeverity>(6, _omitFieldNames ? '' : 'severity',
        enumValues: DiagnosticSeverity.values)
    ..aOS(7, _omitFieldNames ? '' : 'userFacingExplanation')
    ..pPS(8, _omitFieldNames ? '' : 'likelyCauses')
    ..pPS(9, _omitFieldNames ? '' : 'suggestedActions')
    ..aOS(10, _omitFieldNames ? '' : 'repairPath')
    ..aE<DiagnosticIssueStatus>(11, _omitFieldNames ? '' : 'status',
        enumValues: DiagnosticIssueStatus.values)
    ..aOB(12, _omitFieldNames ? '' : 'requiresManualReconciliation')
    ..aOM<$2.Timestamp>(13, _omitFieldNames ? '' : 'detectedAt',
        subBuilder: $2.Timestamp.$_createMessage)
    ..aOM<$2.Timestamp>(14, _omitFieldNames ? '' : 'resolvedAt',
        subBuilder: $2.Timestamp.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DiagnosticIssue clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DiagnosticIssue copyWith(void Function(DiagnosticIssue) updates) =>
      super.copyWith((message) => updates(message as DiagnosticIssue))
          as DiagnosticIssue;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use DiagnosticIssue() / DiagnosticIssue.new instead')
  static DiagnosticIssue create() => DiagnosticIssue._();
  static $pb.GeneratedMessage $_createMessage() => DiagnosticIssue._();
  @$core.override
  DiagnosticIssue createEmptyInstance() => DiagnosticIssue._();
  @$core.pragma('dart2js:noInline')
  static DiagnosticIssue getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DiagnosticIssue>(
          DiagnosticIssue.$_createMessage);
  static DiagnosticIssue? _defaultInstance;

  @$pb.TagNumber(1)
  $1.UUID get diagnosticsId => $_getN(0);
  @$pb.TagNumber(1)
  set diagnosticsId($1.UUID value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasDiagnosticsId() => $_has(0);
  @$pb.TagNumber(1)
  void clearDiagnosticsId() => $_clearField(1);
  @$pb.TagNumber(1)
  $1.UUID ensureDiagnosticsId() => $_ensure(0);

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
  $core.String get scopeType => $_getSZ(2);
  @$pb.TagNumber(3)
  set scopeType($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasScopeType() => $_has(2);
  @$pb.TagNumber(3)
  void clearScopeType() => $_clearField(3);

  @$pb.TagNumber(4)
  $1.UUID get scopeId => $_getN(3);
  @$pb.TagNumber(4)
  set scopeId($1.UUID value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasScopeId() => $_has(3);
  @$pb.TagNumber(4)
  void clearScopeId() => $_clearField(4);
  @$pb.TagNumber(4)
  $1.UUID ensureScopeId() => $_ensure(3);

  @$pb.TagNumber(5)
  $core.String get errorType => $_getSZ(4);
  @$pb.TagNumber(5)
  set errorType($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasErrorType() => $_has(4);
  @$pb.TagNumber(5)
  void clearErrorType() => $_clearField(5);

  @$pb.TagNumber(6)
  DiagnosticSeverity get severity => $_getN(5);
  @$pb.TagNumber(6)
  set severity(DiagnosticSeverity value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasSeverity() => $_has(5);
  @$pb.TagNumber(6)
  void clearSeverity() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get userFacingExplanation => $_getSZ(6);
  @$pb.TagNumber(7)
  set userFacingExplanation($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasUserFacingExplanation() => $_has(6);
  @$pb.TagNumber(7)
  void clearUserFacingExplanation() => $_clearField(7);

  @$pb.TagNumber(8)
  $pb.PbList<$core.String> get likelyCauses => $_getList(7);

  @$pb.TagNumber(9)
  $pb.PbList<$core.String> get suggestedActions => $_getList(8);

  @$pb.TagNumber(10)
  $core.String get repairPath => $_getSZ(9);
  @$pb.TagNumber(10)
  set repairPath($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasRepairPath() => $_has(9);
  @$pb.TagNumber(10)
  void clearRepairPath() => $_clearField(10);

  @$pb.TagNumber(11)
  DiagnosticIssueStatus get status => $_getN(10);
  @$pb.TagNumber(11)
  set status(DiagnosticIssueStatus value) => $_setField(11, value);
  @$pb.TagNumber(11)
  $core.bool hasStatus() => $_has(10);
  @$pb.TagNumber(11)
  void clearStatus() => $_clearField(11);

  @$pb.TagNumber(12)
  $core.bool get requiresManualReconciliation => $_getBF(11);
  @$pb.TagNumber(12)
  set requiresManualReconciliation($core.bool value) => $_setBool(11, value);
  @$pb.TagNumber(12)
  $core.bool hasRequiresManualReconciliation() => $_has(11);
  @$pb.TagNumber(12)
  void clearRequiresManualReconciliation() => $_clearField(12);

  @$pb.TagNumber(13)
  $2.Timestamp get detectedAt => $_getN(12);
  @$pb.TagNumber(13)
  set detectedAt($2.Timestamp value) => $_setField(13, value);
  @$pb.TagNumber(13)
  $core.bool hasDetectedAt() => $_has(12);
  @$pb.TagNumber(13)
  void clearDetectedAt() => $_clearField(13);
  @$pb.TagNumber(13)
  $2.Timestamp ensureDetectedAt() => $_ensure(12);

  @$pb.TagNumber(14)
  $2.Timestamp get resolvedAt => $_getN(13);
  @$pb.TagNumber(14)
  set resolvedAt($2.Timestamp value) => $_setField(14, value);
  @$pb.TagNumber(14)
  $core.bool hasResolvedAt() => $_has(13);
  @$pb.TagNumber(14)
  void clearResolvedAt() => $_clearField(14);
  @$pb.TagNumber(14)
  $2.Timestamp ensureResolvedAt() => $_ensure(13);
}

/// Response for ListIssues.
class ListIssuesResponse extends $pb.GeneratedMessage {
  factory ListIssuesResponse({
    $core.Iterable<DiagnosticIssue>? issues,
    $1.PaginatedResponse? pagination,
  }) {
    final result = ListIssuesResponse._();
    if (issues != null) result.issues.addAll(issues);
    if (pagination != null) result.pagination = pagination;
    return result;
  }

  ListIssuesResponse._();

  factory ListIssuesResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListIssuesResponse()..mergeFromBuffer(data, registry);
  factory ListIssuesResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListIssuesResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListIssuesResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.admin.v1'),
      createEmptyInstance: ListIssuesResponse.$_createMessage)
    ..pPM<DiagnosticIssue>(1, _omitFieldNames ? '' : 'issues',
        subBuilder: DiagnosticIssue.$_createMessage)
    ..aOM<$1.PaginatedResponse>(2, _omitFieldNames ? '' : 'pagination',
        subBuilder: $1.PaginatedResponse.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListIssuesResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListIssuesResponse copyWith(void Function(ListIssuesResponse) updates) =>
      super.copyWith((message) => updates(message as ListIssuesResponse))
          as ListIssuesResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ListIssuesResponse() / ListIssuesResponse.new instead')
  static ListIssuesResponse create() => ListIssuesResponse._();
  static $pb.GeneratedMessage $_createMessage() => ListIssuesResponse._();
  @$core.override
  ListIssuesResponse createEmptyInstance() => ListIssuesResponse._();
  @$core.pragma('dart2js:noInline')
  static ListIssuesResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListIssuesResponse>(
          ListIssuesResponse.$_createMessage);
  static ListIssuesResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<DiagnosticIssue> get issues => $_getList(0);

  @$pb.TagNumber(2)
  $1.PaginatedResponse get pagination => $_getN(1);
  @$pb.TagNumber(2)
  set pagination($1.PaginatedResponse value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasPagination() => $_has(1);
  @$pb.TagNumber(2)
  void clearPagination() => $_clearField(2);
  @$pb.TagNumber(2)
  $1.PaginatedResponse ensurePagination() => $_ensure(1);
}

/// Request for RunFullCheck.
class RunFullCheckRequest extends $pb.GeneratedMessage {
  factory RunFullCheckRequest({
    $1.CommandContext? context,
  }) {
    final result = RunFullCheckRequest._();
    if (context != null) result.context = context;
    return result;
  }

  RunFullCheckRequest._();

  factory RunFullCheckRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RunFullCheckRequest()..mergeFromBuffer(data, registry);
  factory RunFullCheckRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RunFullCheckRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RunFullCheckRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.admin.v1'),
      createEmptyInstance: RunFullCheckRequest.$_createMessage)
    ..aOM<$1.CommandContext>(1, _omitFieldNames ? '' : 'context',
        subBuilder: $1.CommandContext.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RunFullCheckRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RunFullCheckRequest copyWith(void Function(RunFullCheckRequest) updates) =>
      super.copyWith((message) => updates(message as RunFullCheckRequest))
          as RunFullCheckRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core
      .Deprecated('Use RunFullCheckRequest() / RunFullCheckRequest.new instead')
  static RunFullCheckRequest create() => RunFullCheckRequest._();
  static $pb.GeneratedMessage $_createMessage() => RunFullCheckRequest._();
  @$core.override
  RunFullCheckRequest createEmptyInstance() => RunFullCheckRequest._();
  @$core.pragma('dart2js:noInline')
  static RunFullCheckRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RunFullCheckRequest>(
          RunFullCheckRequest.$_createMessage);
  static RunFullCheckRequest? _defaultInstance;

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
}

/// Response for RunFullCheck.
class RunFullCheckResponse extends $pb.GeneratedMessage {
  factory RunFullCheckResponse({
    $1.UUID? checkRunId,
    DiagnosticHealthStatus? overallStatus,
    $core.int? issuesDetected,
    $core.int? unknownEffectsDetected,
    $core.Iterable<HealthCategoryCard>? categories,
    $2.Timestamp? completedAt,
    $core.bool? replayed,
  }) {
    final result = RunFullCheckResponse._();
    if (checkRunId != null) result.checkRunId = checkRunId;
    if (overallStatus != null) result.overallStatus = overallStatus;
    if (issuesDetected != null) result.issuesDetected = issuesDetected;
    if (unknownEffectsDetected != null)
      result.unknownEffectsDetected = unknownEffectsDetected;
    if (categories != null) result.categories.addAll(categories);
    if (completedAt != null) result.completedAt = completedAt;
    if (replayed != null) result.replayed = replayed;
    return result;
  }

  RunFullCheckResponse._();

  factory RunFullCheckResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RunFullCheckResponse()..mergeFromBuffer(data, registry);
  factory RunFullCheckResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RunFullCheckResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RunFullCheckResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.admin.v1'),
      createEmptyInstance: RunFullCheckResponse.$_createMessage)
    ..aOM<$1.UUID>(1, _omitFieldNames ? '' : 'checkRunId',
        subBuilder: $1.UUID.$_createMessage)
    ..aE<DiagnosticHealthStatus>(2, _omitFieldNames ? '' : 'overallStatus',
        enumValues: DiagnosticHealthStatus.values)
    ..aI(3, _omitFieldNames ? '' : 'issuesDetected')
    ..aI(4, _omitFieldNames ? '' : 'unknownEffectsDetected')
    ..pPM<HealthCategoryCard>(5, _omitFieldNames ? '' : 'categories',
        subBuilder: HealthCategoryCard.$_createMessage)
    ..aOM<$2.Timestamp>(6, _omitFieldNames ? '' : 'completedAt',
        subBuilder: $2.Timestamp.$_createMessage)
    ..aOB(7, _omitFieldNames ? '' : 'replayed')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RunFullCheckResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RunFullCheckResponse copyWith(void Function(RunFullCheckResponse) updates) =>
      super.copyWith((message) => updates(message as RunFullCheckResponse))
          as RunFullCheckResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use RunFullCheckResponse() / RunFullCheckResponse.new instead')
  static RunFullCheckResponse create() => RunFullCheckResponse._();
  static $pb.GeneratedMessage $_createMessage() => RunFullCheckResponse._();
  @$core.override
  RunFullCheckResponse createEmptyInstance() => RunFullCheckResponse._();
  @$core.pragma('dart2js:noInline')
  static RunFullCheckResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RunFullCheckResponse>(
          RunFullCheckResponse.$_createMessage);
  static RunFullCheckResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $1.UUID get checkRunId => $_getN(0);
  @$pb.TagNumber(1)
  set checkRunId($1.UUID value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasCheckRunId() => $_has(0);
  @$pb.TagNumber(1)
  void clearCheckRunId() => $_clearField(1);
  @$pb.TagNumber(1)
  $1.UUID ensureCheckRunId() => $_ensure(0);

  @$pb.TagNumber(2)
  DiagnosticHealthStatus get overallStatus => $_getN(1);
  @$pb.TagNumber(2)
  set overallStatus(DiagnosticHealthStatus value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasOverallStatus() => $_has(1);
  @$pb.TagNumber(2)
  void clearOverallStatus() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get issuesDetected => $_getIZ(2);
  @$pb.TagNumber(3)
  set issuesDetected($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasIssuesDetected() => $_has(2);
  @$pb.TagNumber(3)
  void clearIssuesDetected() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get unknownEffectsDetected => $_getIZ(3);
  @$pb.TagNumber(4)
  set unknownEffectsDetected($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasUnknownEffectsDetected() => $_has(3);
  @$pb.TagNumber(4)
  void clearUnknownEffectsDetected() => $_clearField(4);

  @$pb.TagNumber(5)
  $pb.PbList<HealthCategoryCard> get categories => $_getList(4);

  @$pb.TagNumber(6)
  $2.Timestamp get completedAt => $_getN(5);
  @$pb.TagNumber(6)
  set completedAt($2.Timestamp value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasCompletedAt() => $_has(5);
  @$pb.TagNumber(6)
  void clearCompletedAt() => $_clearField(6);
  @$pb.TagNumber(6)
  $2.Timestamp ensureCompletedAt() => $_ensure(5);

  @$pb.TagNumber(7)
  $core.bool get replayed => $_getBF(6);
  @$pb.TagNumber(7)
  set replayed($core.bool value) => $_setBool(6, value);
  @$pb.TagNumber(7)
  $core.bool hasReplayed() => $_has(6);
  @$pb.TagNumber(7)
  void clearReplayed() => $_clearField(7);
}

/// Request for ExecuteRepairStep.
class ExecuteRepairStepRequest extends $pb.GeneratedMessage {
  factory ExecuteRepairStepRequest({
    $1.CommandContext? context,
    $1.UUID? diagnosticsId,
    RepairWizardStep? step,
    $core.String? actionKey,
    $core.String? verificationReference,
  }) {
    final result = ExecuteRepairStepRequest._();
    if (context != null) result.context = context;
    if (diagnosticsId != null) result.diagnosticsId = diagnosticsId;
    if (step != null) result.step = step;
    if (actionKey != null) result.actionKey = actionKey;
    if (verificationReference != null)
      result.verificationReference = verificationReference;
    return result;
  }

  ExecuteRepairStepRequest._();

  factory ExecuteRepairStepRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ExecuteRepairStepRequest()..mergeFromBuffer(data, registry);
  factory ExecuteRepairStepRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ExecuteRepairStepRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ExecuteRepairStepRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.admin.v1'),
      createEmptyInstance: ExecuteRepairStepRequest.$_createMessage)
    ..aOM<$1.CommandContext>(1, _omitFieldNames ? '' : 'context',
        subBuilder: $1.CommandContext.$_createMessage)
    ..aOM<$1.UUID>(2, _omitFieldNames ? '' : 'diagnosticsId',
        subBuilder: $1.UUID.$_createMessage)
    ..aE<RepairWizardStep>(3, _omitFieldNames ? '' : 'step',
        enumValues: RepairWizardStep.values)
    ..aOS(4, _omitFieldNames ? '' : 'actionKey')
    ..aOS(5, _omitFieldNames ? '' : 'verificationReference')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ExecuteRepairStepRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ExecuteRepairStepRequest copyWith(
          void Function(ExecuteRepairStepRequest) updates) =>
      super.copyWith((message) => updates(message as ExecuteRepairStepRequest))
          as ExecuteRepairStepRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ExecuteRepairStepRequest() / ExecuteRepairStepRequest.new instead')
  static ExecuteRepairStepRequest create() => ExecuteRepairStepRequest._();
  static $pb.GeneratedMessage $_createMessage() => ExecuteRepairStepRequest._();
  @$core.override
  ExecuteRepairStepRequest createEmptyInstance() =>
      ExecuteRepairStepRequest._();
  @$core.pragma('dart2js:noInline')
  static ExecuteRepairStepRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ExecuteRepairStepRequest>(
          ExecuteRepairStepRequest.$_createMessage);
  static ExecuteRepairStepRequest? _defaultInstance;

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
  $1.UUID get diagnosticsId => $_getN(1);
  @$pb.TagNumber(2)
  set diagnosticsId($1.UUID value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasDiagnosticsId() => $_has(1);
  @$pb.TagNumber(2)
  void clearDiagnosticsId() => $_clearField(2);
  @$pb.TagNumber(2)
  $1.UUID ensureDiagnosticsId() => $_ensure(1);

  @$pb.TagNumber(3)
  RepairWizardStep get step => $_getN(2);
  @$pb.TagNumber(3)
  set step(RepairWizardStep value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasStep() => $_has(2);
  @$pb.TagNumber(3)
  void clearStep() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get actionKey => $_getSZ(3);
  @$pb.TagNumber(4)
  set actionKey($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasActionKey() => $_has(3);
  @$pb.TagNumber(4)
  void clearActionKey() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get verificationReference => $_getSZ(4);
  @$pb.TagNumber(5)
  set verificationReference($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasVerificationReference() => $_has(4);
  @$pb.TagNumber(5)
  void clearVerificationReference() => $_clearField(5);
}

/// Response for ExecuteRepairStep.
class ExecuteRepairStepResponse extends $pb.GeneratedMessage {
  factory ExecuteRepairStepResponse({
    $1.UUID? diagnosticsId,
    RepairWizardStep? completedStep,
    RepairWizardStep? nextStep,
    DiagnosticIssueStatus? issueStatus,
    $core.String? userFacingResult,
    $core.bool? resolved,
    $core.bool? replayed,
    $2.Timestamp? updatedAt,
  }) {
    final result = ExecuteRepairStepResponse._();
    if (diagnosticsId != null) result.diagnosticsId = diagnosticsId;
    if (completedStep != null) result.completedStep = completedStep;
    if (nextStep != null) result.nextStep = nextStep;
    if (issueStatus != null) result.issueStatus = issueStatus;
    if (userFacingResult != null) result.userFacingResult = userFacingResult;
    if (resolved != null) result.resolved = resolved;
    if (replayed != null) result.replayed = replayed;
    if (updatedAt != null) result.updatedAt = updatedAt;
    return result;
  }

  ExecuteRepairStepResponse._();

  factory ExecuteRepairStepResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ExecuteRepairStepResponse()..mergeFromBuffer(data, registry);
  factory ExecuteRepairStepResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ExecuteRepairStepResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ExecuteRepairStepResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.admin.v1'),
      createEmptyInstance: ExecuteRepairStepResponse.$_createMessage)
    ..aOM<$1.UUID>(1, _omitFieldNames ? '' : 'diagnosticsId',
        subBuilder: $1.UUID.$_createMessage)
    ..aE<RepairWizardStep>(2, _omitFieldNames ? '' : 'completedStep',
        enumValues: RepairWizardStep.values)
    ..aE<RepairWizardStep>(3, _omitFieldNames ? '' : 'nextStep',
        enumValues: RepairWizardStep.values)
    ..aE<DiagnosticIssueStatus>(4, _omitFieldNames ? '' : 'issueStatus',
        enumValues: DiagnosticIssueStatus.values)
    ..aOS(5, _omitFieldNames ? '' : 'userFacingResult')
    ..aOB(6, _omitFieldNames ? '' : 'resolved')
    ..aOB(7, _omitFieldNames ? '' : 'replayed')
    ..aOM<$2.Timestamp>(8, _omitFieldNames ? '' : 'updatedAt',
        subBuilder: $2.Timestamp.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ExecuteRepairStepResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ExecuteRepairStepResponse copyWith(
          void Function(ExecuteRepairStepResponse) updates) =>
      super.copyWith((message) => updates(message as ExecuteRepairStepResponse))
          as ExecuteRepairStepResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ExecuteRepairStepResponse() / ExecuteRepairStepResponse.new instead')
  static ExecuteRepairStepResponse create() => ExecuteRepairStepResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      ExecuteRepairStepResponse._();
  @$core.override
  ExecuteRepairStepResponse createEmptyInstance() =>
      ExecuteRepairStepResponse._();
  @$core.pragma('dart2js:noInline')
  static ExecuteRepairStepResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ExecuteRepairStepResponse>(
          ExecuteRepairStepResponse.$_createMessage);
  static ExecuteRepairStepResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $1.UUID get diagnosticsId => $_getN(0);
  @$pb.TagNumber(1)
  set diagnosticsId($1.UUID value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasDiagnosticsId() => $_has(0);
  @$pb.TagNumber(1)
  void clearDiagnosticsId() => $_clearField(1);
  @$pb.TagNumber(1)
  $1.UUID ensureDiagnosticsId() => $_ensure(0);

  @$pb.TagNumber(2)
  RepairWizardStep get completedStep => $_getN(1);
  @$pb.TagNumber(2)
  set completedStep(RepairWizardStep value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasCompletedStep() => $_has(1);
  @$pb.TagNumber(2)
  void clearCompletedStep() => $_clearField(2);

  @$pb.TagNumber(3)
  RepairWizardStep get nextStep => $_getN(2);
  @$pb.TagNumber(3)
  set nextStep(RepairWizardStep value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasNextStep() => $_has(2);
  @$pb.TagNumber(3)
  void clearNextStep() => $_clearField(3);

  @$pb.TagNumber(4)
  DiagnosticIssueStatus get issueStatus => $_getN(3);
  @$pb.TagNumber(4)
  set issueStatus(DiagnosticIssueStatus value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasIssueStatus() => $_has(3);
  @$pb.TagNumber(4)
  void clearIssueStatus() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get userFacingResult => $_getSZ(4);
  @$pb.TagNumber(5)
  set userFacingResult($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasUserFacingResult() => $_has(4);
  @$pb.TagNumber(5)
  void clearUserFacingResult() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.bool get resolved => $_getBF(5);
  @$pb.TagNumber(6)
  set resolved($core.bool value) => $_setBool(5, value);
  @$pb.TagNumber(6)
  $core.bool hasResolved() => $_has(5);
  @$pb.TagNumber(6)
  void clearResolved() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.bool get replayed => $_getBF(6);
  @$pb.TagNumber(7)
  set replayed($core.bool value) => $_setBool(6, value);
  @$pb.TagNumber(7)
  $core.bool hasReplayed() => $_has(6);
  @$pb.TagNumber(7)
  void clearReplayed() => $_clearField(7);

  @$pb.TagNumber(8)
  $2.Timestamp get updatedAt => $_getN(7);
  @$pb.TagNumber(8)
  set updatedAt($2.Timestamp value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasUpdatedAt() => $_has(7);
  @$pb.TagNumber(8)
  void clearUpdatedAt() => $_clearField(8);
  @$pb.TagNumber(8)
  $2.Timestamp ensureUpdatedAt() => $_ensure(7);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');

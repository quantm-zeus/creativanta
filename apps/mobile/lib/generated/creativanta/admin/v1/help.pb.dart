// This is a generated file - do not edit.
//
// Generated from creativanta/admin/v1/help.proto.

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
import 'help.pbenum.dart';

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'help.pbenum.dart';

class KBCategory extends $pb.GeneratedMessage {
  factory KBCategory({
    $1.UUID? categoryId,
    $core.String? slug,
    $core.String? displayName,
    $core.String? description,
    $core.String? iconKey,
    $core.int? sortOrder,
    $core.bool? isActive,
    $core.int? articleCount,
  }) {
    final result = KBCategory._();
    if (categoryId != null) result.categoryId = categoryId;
    if (slug != null) result.slug = slug;
    if (displayName != null) result.displayName = displayName;
    if (description != null) result.description = description;
    if (iconKey != null) result.iconKey = iconKey;
    if (sortOrder != null) result.sortOrder = sortOrder;
    if (isActive != null) result.isActive = isActive;
    if (articleCount != null) result.articleCount = articleCount;
    return result;
  }

  KBCategory._();

  factory KBCategory.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      KBCategory()..mergeFromBuffer(data, registry);
  factory KBCategory.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      KBCategory()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'KBCategory',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.admin.v1'),
      createEmptyInstance: KBCategory.$_createMessage)
    ..aOM<$1.UUID>(1, _omitFieldNames ? '' : 'categoryId',
        subBuilder: $1.UUID.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'slug')
    ..aOS(3, _omitFieldNames ? '' : 'displayName')
    ..aOS(4, _omitFieldNames ? '' : 'description')
    ..aOS(5, _omitFieldNames ? '' : 'iconKey')
    ..aI(6, _omitFieldNames ? '' : 'sortOrder')
    ..aOB(7, _omitFieldNames ? '' : 'isActive')
    ..aI(8, _omitFieldNames ? '' : 'articleCount')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  KBCategory clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  KBCategory copyWith(void Function(KBCategory) updates) =>
      super.copyWith((message) => updates(message as KBCategory)) as KBCategory;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use KBCategory() / KBCategory.new instead')
  static KBCategory create() => KBCategory._();
  static $pb.GeneratedMessage $_createMessage() => KBCategory._();
  @$core.override
  KBCategory createEmptyInstance() => KBCategory._();
  @$core.pragma('dart2js:noInline')
  static KBCategory getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<KBCategory>(KBCategory.$_createMessage);
  static KBCategory? _defaultInstance;

  @$pb.TagNumber(1)
  $1.UUID get categoryId => $_getN(0);
  @$pb.TagNumber(1)
  set categoryId($1.UUID value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasCategoryId() => $_has(0);
  @$pb.TagNumber(1)
  void clearCategoryId() => $_clearField(1);
  @$pb.TagNumber(1)
  $1.UUID ensureCategoryId() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get slug => $_getSZ(1);
  @$pb.TagNumber(2)
  set slug($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSlug() => $_has(1);
  @$pb.TagNumber(2)
  void clearSlug() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get displayName => $_getSZ(2);
  @$pb.TagNumber(3)
  set displayName($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasDisplayName() => $_has(2);
  @$pb.TagNumber(3)
  void clearDisplayName() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get description => $_getSZ(3);
  @$pb.TagNumber(4)
  set description($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasDescription() => $_has(3);
  @$pb.TagNumber(4)
  void clearDescription() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get iconKey => $_getSZ(4);
  @$pb.TagNumber(5)
  set iconKey($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasIconKey() => $_has(4);
  @$pb.TagNumber(5)
  void clearIconKey() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.int get sortOrder => $_getIZ(5);
  @$pb.TagNumber(6)
  set sortOrder($core.int value) => $_setSignedInt32(5, value);
  @$pb.TagNumber(6)
  $core.bool hasSortOrder() => $_has(5);
  @$pb.TagNumber(6)
  void clearSortOrder() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.bool get isActive => $_getBF(6);
  @$pb.TagNumber(7)
  set isActive($core.bool value) => $_setBool(6, value);
  @$pb.TagNumber(7)
  $core.bool hasIsActive() => $_has(6);
  @$pb.TagNumber(7)
  void clearIsActive() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.int get articleCount => $_getIZ(7);
  @$pb.TagNumber(8)
  set articleCount($core.int value) => $_setSignedInt32(7, value);
  @$pb.TagNumber(8)
  $core.bool hasArticleCount() => $_has(7);
  @$pb.TagNumber(8)
  void clearArticleCount() => $_clearField(8);
}

class KBArticleSummary extends $pb.GeneratedMessage {
  factory KBArticleSummary({
    $1.UUID? articleId,
    $1.UUID? categoryId,
    $core.String? slug,
    $core.String? locale,
    $core.String? title,
    $core.String? summary,
    KBArticleStatus? status,
    KBArticleType? articleType,
    $core.Iterable<$core.String>? targetModules,
    $core.Iterable<$core.String>? targetOperatorModes,
    $core.Iterable<$core.String>? tags,
    $core.int? estimatedReadMinutes,
    $core.int? helpfulVotes,
    $core.int? unhelpfulVotes,
    $core.int? viewCount,
    $2.Timestamp? lastReviewedAt,
    $2.Timestamp? publishedAt,
    $core.bool? isStaleForReview,
  }) {
    final result = KBArticleSummary._();
    if (articleId != null) result.articleId = articleId;
    if (categoryId != null) result.categoryId = categoryId;
    if (slug != null) result.slug = slug;
    if (locale != null) result.locale = locale;
    if (title != null) result.title = title;
    if (summary != null) result.summary = summary;
    if (status != null) result.status = status;
    if (articleType != null) result.articleType = articleType;
    if (targetModules != null) result.targetModules.addAll(targetModules);
    if (targetOperatorModes != null)
      result.targetOperatorModes.addAll(targetOperatorModes);
    if (tags != null) result.tags.addAll(tags);
    if (estimatedReadMinutes != null)
      result.estimatedReadMinutes = estimatedReadMinutes;
    if (helpfulVotes != null) result.helpfulVotes = helpfulVotes;
    if (unhelpfulVotes != null) result.unhelpfulVotes = unhelpfulVotes;
    if (viewCount != null) result.viewCount = viewCount;
    if (lastReviewedAt != null) result.lastReviewedAt = lastReviewedAt;
    if (publishedAt != null) result.publishedAt = publishedAt;
    if (isStaleForReview != null) result.isStaleForReview = isStaleForReview;
    return result;
  }

  KBArticleSummary._();

  factory KBArticleSummary.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      KBArticleSummary()..mergeFromBuffer(data, registry);
  factory KBArticleSummary.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      KBArticleSummary()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'KBArticleSummary',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.admin.v1'),
      createEmptyInstance: KBArticleSummary.$_createMessage)
    ..aOM<$1.UUID>(1, _omitFieldNames ? '' : 'articleId',
        subBuilder: $1.UUID.$_createMessage)
    ..aOM<$1.UUID>(2, _omitFieldNames ? '' : 'categoryId',
        subBuilder: $1.UUID.$_createMessage)
    ..aOS(3, _omitFieldNames ? '' : 'slug')
    ..aOS(4, _omitFieldNames ? '' : 'locale')
    ..aOS(5, _omitFieldNames ? '' : 'title')
    ..aOS(6, _omitFieldNames ? '' : 'summary')
    ..aE<KBArticleStatus>(7, _omitFieldNames ? '' : 'status',
        enumValues: KBArticleStatus.values)
    ..aE<KBArticleType>(8, _omitFieldNames ? '' : 'articleType',
        enumValues: KBArticleType.values)
    ..pPS(9, _omitFieldNames ? '' : 'targetModules')
    ..pPS(10, _omitFieldNames ? '' : 'targetOperatorModes')
    ..pPS(11, _omitFieldNames ? '' : 'tags')
    ..aI(12, _omitFieldNames ? '' : 'estimatedReadMinutes')
    ..aI(13, _omitFieldNames ? '' : 'helpfulVotes')
    ..aI(14, _omitFieldNames ? '' : 'unhelpfulVotes')
    ..aI(15, _omitFieldNames ? '' : 'viewCount')
    ..aOM<$2.Timestamp>(16, _omitFieldNames ? '' : 'lastReviewedAt',
        subBuilder: $2.Timestamp.$_createMessage)
    ..aOM<$2.Timestamp>(17, _omitFieldNames ? '' : 'publishedAt',
        subBuilder: $2.Timestamp.$_createMessage)
    ..aOB(18, _omitFieldNames ? '' : 'isStaleForReview')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  KBArticleSummary clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  KBArticleSummary copyWith(void Function(KBArticleSummary) updates) =>
      super.copyWith((message) => updates(message as KBArticleSummary))
          as KBArticleSummary;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use KBArticleSummary() / KBArticleSummary.new instead')
  static KBArticleSummary create() => KBArticleSummary._();
  static $pb.GeneratedMessage $_createMessage() => KBArticleSummary._();
  @$core.override
  KBArticleSummary createEmptyInstance() => KBArticleSummary._();
  @$core.pragma('dart2js:noInline')
  static KBArticleSummary getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<KBArticleSummary>(
          KBArticleSummary.$_createMessage);
  static KBArticleSummary? _defaultInstance;

  @$pb.TagNumber(1)
  $1.UUID get articleId => $_getN(0);
  @$pb.TagNumber(1)
  set articleId($1.UUID value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasArticleId() => $_has(0);
  @$pb.TagNumber(1)
  void clearArticleId() => $_clearField(1);
  @$pb.TagNumber(1)
  $1.UUID ensureArticleId() => $_ensure(0);

  @$pb.TagNumber(2)
  $1.UUID get categoryId => $_getN(1);
  @$pb.TagNumber(2)
  set categoryId($1.UUID value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasCategoryId() => $_has(1);
  @$pb.TagNumber(2)
  void clearCategoryId() => $_clearField(2);
  @$pb.TagNumber(2)
  $1.UUID ensureCategoryId() => $_ensure(1);

  @$pb.TagNumber(3)
  $core.String get slug => $_getSZ(2);
  @$pb.TagNumber(3)
  set slug($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasSlug() => $_has(2);
  @$pb.TagNumber(3)
  void clearSlug() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get locale => $_getSZ(3);
  @$pb.TagNumber(4)
  set locale($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasLocale() => $_has(3);
  @$pb.TagNumber(4)
  void clearLocale() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get title => $_getSZ(4);
  @$pb.TagNumber(5)
  set title($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasTitle() => $_has(4);
  @$pb.TagNumber(5)
  void clearTitle() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get summary => $_getSZ(5);
  @$pb.TagNumber(6)
  set summary($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasSummary() => $_has(5);
  @$pb.TagNumber(6)
  void clearSummary() => $_clearField(6);

  @$pb.TagNumber(7)
  KBArticleStatus get status => $_getN(6);
  @$pb.TagNumber(7)
  set status(KBArticleStatus value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasStatus() => $_has(6);
  @$pb.TagNumber(7)
  void clearStatus() => $_clearField(7);

  @$pb.TagNumber(8)
  KBArticleType get articleType => $_getN(7);
  @$pb.TagNumber(8)
  set articleType(KBArticleType value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasArticleType() => $_has(7);
  @$pb.TagNumber(8)
  void clearArticleType() => $_clearField(8);

  @$pb.TagNumber(9)
  $pb.PbList<$core.String> get targetModules => $_getList(8);

  @$pb.TagNumber(10)
  $pb.PbList<$core.String> get targetOperatorModes => $_getList(9);

  @$pb.TagNumber(11)
  $pb.PbList<$core.String> get tags => $_getList(10);

  @$pb.TagNumber(12)
  $core.int get estimatedReadMinutes => $_getIZ(11);
  @$pb.TagNumber(12)
  set estimatedReadMinutes($core.int value) => $_setSignedInt32(11, value);
  @$pb.TagNumber(12)
  $core.bool hasEstimatedReadMinutes() => $_has(11);
  @$pb.TagNumber(12)
  void clearEstimatedReadMinutes() => $_clearField(12);

  @$pb.TagNumber(13)
  $core.int get helpfulVotes => $_getIZ(12);
  @$pb.TagNumber(13)
  set helpfulVotes($core.int value) => $_setSignedInt32(12, value);
  @$pb.TagNumber(13)
  $core.bool hasHelpfulVotes() => $_has(12);
  @$pb.TagNumber(13)
  void clearHelpfulVotes() => $_clearField(13);

  @$pb.TagNumber(14)
  $core.int get unhelpfulVotes => $_getIZ(13);
  @$pb.TagNumber(14)
  set unhelpfulVotes($core.int value) => $_setSignedInt32(13, value);
  @$pb.TagNumber(14)
  $core.bool hasUnhelpfulVotes() => $_has(13);
  @$pb.TagNumber(14)
  void clearUnhelpfulVotes() => $_clearField(14);

  @$pb.TagNumber(15)
  $core.int get viewCount => $_getIZ(14);
  @$pb.TagNumber(15)
  set viewCount($core.int value) => $_setSignedInt32(14, value);
  @$pb.TagNumber(15)
  $core.bool hasViewCount() => $_has(14);
  @$pb.TagNumber(15)
  void clearViewCount() => $_clearField(15);

  @$pb.TagNumber(16)
  $2.Timestamp get lastReviewedAt => $_getN(15);
  @$pb.TagNumber(16)
  set lastReviewedAt($2.Timestamp value) => $_setField(16, value);
  @$pb.TagNumber(16)
  $core.bool hasLastReviewedAt() => $_has(15);
  @$pb.TagNumber(16)
  void clearLastReviewedAt() => $_clearField(16);
  @$pb.TagNumber(16)
  $2.Timestamp ensureLastReviewedAt() => $_ensure(15);

  @$pb.TagNumber(17)
  $2.Timestamp get publishedAt => $_getN(16);
  @$pb.TagNumber(17)
  set publishedAt($2.Timestamp value) => $_setField(17, value);
  @$pb.TagNumber(17)
  $core.bool hasPublishedAt() => $_has(16);
  @$pb.TagNumber(17)
  void clearPublishedAt() => $_clearField(17);
  @$pb.TagNumber(17)
  $2.Timestamp ensurePublishedAt() => $_ensure(16);

  @$pb.TagNumber(18)
  $core.bool get isStaleForReview => $_getBF(17);
  @$pb.TagNumber(18)
  set isStaleForReview($core.bool value) => $_setBool(17, value);
  @$pb.TagNumber(18)
  $core.bool hasIsStaleForReview() => $_has(17);
  @$pb.TagNumber(18)
  void clearIsStaleForReview() => $_clearField(18);
}

class KBArticleDetail extends $pb.GeneratedMessage {
  factory KBArticleDetail({
    KBArticleSummary? summary,
    $core.String? bodyMarkdown,
    $core.Iterable<$1.UUID>? relatedArticleIds,
    $core.Iterable<$core.String>? targetTiers,
  }) {
    final result = KBArticleDetail._();
    if (summary != null) result.summary = summary;
    if (bodyMarkdown != null) result.bodyMarkdown = bodyMarkdown;
    if (relatedArticleIds != null)
      result.relatedArticleIds.addAll(relatedArticleIds);
    if (targetTiers != null) result.targetTiers.addAll(targetTiers);
    return result;
  }

  KBArticleDetail._();

  factory KBArticleDetail.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      KBArticleDetail()..mergeFromBuffer(data, registry);
  factory KBArticleDetail.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      KBArticleDetail()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'KBArticleDetail',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.admin.v1'),
      createEmptyInstance: KBArticleDetail.$_createMessage)
    ..aOM<KBArticleSummary>(1, _omitFieldNames ? '' : 'summary',
        subBuilder: KBArticleSummary.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'bodyMarkdown')
    ..pPM<$1.UUID>(3, _omitFieldNames ? '' : 'relatedArticleIds',
        subBuilder: $1.UUID.$_createMessage)
    ..pPS(4, _omitFieldNames ? '' : 'targetTiers')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  KBArticleDetail clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  KBArticleDetail copyWith(void Function(KBArticleDetail) updates) =>
      super.copyWith((message) => updates(message as KBArticleDetail))
          as KBArticleDetail;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use KBArticleDetail() / KBArticleDetail.new instead')
  static KBArticleDetail create() => KBArticleDetail._();
  static $pb.GeneratedMessage $_createMessage() => KBArticleDetail._();
  @$core.override
  KBArticleDetail createEmptyInstance() => KBArticleDetail._();
  @$core.pragma('dart2js:noInline')
  static KBArticleDetail getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<KBArticleDetail>(
          KBArticleDetail.$_createMessage);
  static KBArticleDetail? _defaultInstance;

  @$pb.TagNumber(1)
  KBArticleSummary get summary => $_getN(0);
  @$pb.TagNumber(1)
  set summary(KBArticleSummary value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasSummary() => $_has(0);
  @$pb.TagNumber(1)
  void clearSummary() => $_clearField(1);
  @$pb.TagNumber(1)
  KBArticleSummary ensureSummary() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get bodyMarkdown => $_getSZ(1);
  @$pb.TagNumber(2)
  set bodyMarkdown($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasBodyMarkdown() => $_has(1);
  @$pb.TagNumber(2)
  void clearBodyMarkdown() => $_clearField(2);

  @$pb.TagNumber(3)
  $pb.PbList<$1.UUID> get relatedArticleIds => $_getList(2);

  @$pb.TagNumber(4)
  $pb.PbList<$core.String> get targetTiers => $_getList(3);
}

class SearchRequest extends $pb.GeneratedMessage {
  factory SearchRequest({
    $core.String? query,
    $core.String? locale,
    $core.String? moduleFilter,
    $core.String? operatorModeFilter,
    $1.UUID? categoryId,
    $1.Pagination? pagination,
  }) {
    final result = SearchRequest._();
    if (query != null) result.query = query;
    if (locale != null) result.locale = locale;
    if (moduleFilter != null) result.moduleFilter = moduleFilter;
    if (operatorModeFilter != null)
      result.operatorModeFilter = operatorModeFilter;
    if (categoryId != null) result.categoryId = categoryId;
    if (pagination != null) result.pagination = pagination;
    return result;
  }

  SearchRequest._();

  factory SearchRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SearchRequest()..mergeFromBuffer(data, registry);
  factory SearchRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SearchRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SearchRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.admin.v1'),
      createEmptyInstance: SearchRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'query')
    ..aOS(2, _omitFieldNames ? '' : 'locale')
    ..aOS(3, _omitFieldNames ? '' : 'moduleFilter')
    ..aOS(4, _omitFieldNames ? '' : 'operatorModeFilter')
    ..aOM<$1.UUID>(5, _omitFieldNames ? '' : 'categoryId',
        subBuilder: $1.UUID.$_createMessage)
    ..aOM<$1.Pagination>(6, _omitFieldNames ? '' : 'pagination',
        subBuilder: $1.Pagination.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SearchRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SearchRequest copyWith(void Function(SearchRequest) updates) =>
      super.copyWith((message) => updates(message as SearchRequest))
          as SearchRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use SearchRequest() / SearchRequest.new instead')
  static SearchRequest create() => SearchRequest._();
  static $pb.GeneratedMessage $_createMessage() => SearchRequest._();
  @$core.override
  SearchRequest createEmptyInstance() => SearchRequest._();
  @$core.pragma('dart2js:noInline')
  static SearchRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SearchRequest>(
          SearchRequest.$_createMessage);
  static SearchRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get query => $_getSZ(0);
  @$pb.TagNumber(1)
  set query($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasQuery() => $_has(0);
  @$pb.TagNumber(1)
  void clearQuery() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get locale => $_getSZ(1);
  @$pb.TagNumber(2)
  set locale($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasLocale() => $_has(1);
  @$pb.TagNumber(2)
  void clearLocale() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get moduleFilter => $_getSZ(2);
  @$pb.TagNumber(3)
  set moduleFilter($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasModuleFilter() => $_has(2);
  @$pb.TagNumber(3)
  void clearModuleFilter() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get operatorModeFilter => $_getSZ(3);
  @$pb.TagNumber(4)
  set operatorModeFilter($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasOperatorModeFilter() => $_has(3);
  @$pb.TagNumber(4)
  void clearOperatorModeFilter() => $_clearField(4);

  @$pb.TagNumber(5)
  $1.UUID get categoryId => $_getN(4);
  @$pb.TagNumber(5)
  set categoryId($1.UUID value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasCategoryId() => $_has(4);
  @$pb.TagNumber(5)
  void clearCategoryId() => $_clearField(5);
  @$pb.TagNumber(5)
  $1.UUID ensureCategoryId() => $_ensure(4);

  @$pb.TagNumber(6)
  $1.Pagination get pagination => $_getN(5);
  @$pb.TagNumber(6)
  set pagination($1.Pagination value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasPagination() => $_has(5);
  @$pb.TagNumber(6)
  void clearPagination() => $_clearField(6);
  @$pb.TagNumber(6)
  $1.Pagination ensurePagination() => $_ensure(5);
}

class SearchResponse extends $pb.GeneratedMessage {
  factory SearchResponse({
    $core.Iterable<KBArticleSummary>? articles,
    $1.PaginatedResponse? pagination,
  }) {
    final result = SearchResponse._();
    if (articles != null) result.articles.addAll(articles);
    if (pagination != null) result.pagination = pagination;
    return result;
  }

  SearchResponse._();

  factory SearchResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SearchResponse()..mergeFromBuffer(data, registry);
  factory SearchResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SearchResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SearchResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.admin.v1'),
      createEmptyInstance: SearchResponse.$_createMessage)
    ..pPM<KBArticleSummary>(1, _omitFieldNames ? '' : 'articles',
        subBuilder: KBArticleSummary.$_createMessage)
    ..aOM<$1.PaginatedResponse>(2, _omitFieldNames ? '' : 'pagination',
        subBuilder: $1.PaginatedResponse.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SearchResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SearchResponse copyWith(void Function(SearchResponse) updates) =>
      super.copyWith((message) => updates(message as SearchResponse))
          as SearchResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use SearchResponse() / SearchResponse.new instead')
  static SearchResponse create() => SearchResponse._();
  static $pb.GeneratedMessage $_createMessage() => SearchResponse._();
  @$core.override
  SearchResponse createEmptyInstance() => SearchResponse._();
  @$core.pragma('dart2js:noInline')
  static SearchResponse getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SearchResponse>(
          SearchResponse.$_createMessage);
  static SearchResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<KBArticleSummary> get articles => $_getList(0);

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

class GetCategoriesRequest extends $pb.GeneratedMessage {
  factory GetCategoriesRequest({
    $core.String? locale,
    $core.bool? activeOnly,
  }) {
    final result = GetCategoriesRequest._();
    if (locale != null) result.locale = locale;
    if (activeOnly != null) result.activeOnly = activeOnly;
    return result;
  }

  GetCategoriesRequest._();

  factory GetCategoriesRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetCategoriesRequest()..mergeFromBuffer(data, registry);
  factory GetCategoriesRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetCategoriesRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetCategoriesRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.admin.v1'),
      createEmptyInstance: GetCategoriesRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'locale')
    ..aOB(2, _omitFieldNames ? '' : 'activeOnly')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetCategoriesRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetCategoriesRequest copyWith(void Function(GetCategoriesRequest) updates) =>
      super.copyWith((message) => updates(message as GetCategoriesRequest))
          as GetCategoriesRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use GetCategoriesRequest() / GetCategoriesRequest.new instead')
  static GetCategoriesRequest create() => GetCategoriesRequest._();
  static $pb.GeneratedMessage $_createMessage() => GetCategoriesRequest._();
  @$core.override
  GetCategoriesRequest createEmptyInstance() => GetCategoriesRequest._();
  @$core.pragma('dart2js:noInline')
  static GetCategoriesRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetCategoriesRequest>(
          GetCategoriesRequest.$_createMessage);
  static GetCategoriesRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get locale => $_getSZ(0);
  @$pb.TagNumber(1)
  set locale($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasLocale() => $_has(0);
  @$pb.TagNumber(1)
  void clearLocale() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.bool get activeOnly => $_getBF(1);
  @$pb.TagNumber(2)
  set activeOnly($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasActiveOnly() => $_has(1);
  @$pb.TagNumber(2)
  void clearActiveOnly() => $_clearField(2);
}

class GetCategoriesResponse extends $pb.GeneratedMessage {
  factory GetCategoriesResponse({
    $core.Iterable<KBCategory>? categories,
  }) {
    final result = GetCategoriesResponse._();
    if (categories != null) result.categories.addAll(categories);
    return result;
  }

  GetCategoriesResponse._();

  factory GetCategoriesResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetCategoriesResponse()..mergeFromBuffer(data, registry);
  factory GetCategoriesResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetCategoriesResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetCategoriesResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.admin.v1'),
      createEmptyInstance: GetCategoriesResponse.$_createMessage)
    ..pPM<KBCategory>(1, _omitFieldNames ? '' : 'categories',
        subBuilder: KBCategory.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetCategoriesResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetCategoriesResponse copyWith(
          void Function(GetCategoriesResponse) updates) =>
      super.copyWith((message) => updates(message as GetCategoriesResponse))
          as GetCategoriesResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use GetCategoriesResponse() / GetCategoriesResponse.new instead')
  static GetCategoriesResponse create() => GetCategoriesResponse._();
  static $pb.GeneratedMessage $_createMessage() => GetCategoriesResponse._();
  @$core.override
  GetCategoriesResponse createEmptyInstance() => GetCategoriesResponse._();
  @$core.pragma('dart2js:noInline')
  static GetCategoriesResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetCategoriesResponse>(
          GetCategoriesResponse.$_createMessage);
  static GetCategoriesResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<KBCategory> get categories => $_getList(0);
}

class GetArticleRequest extends $pb.GeneratedMessage {
  factory GetArticleRequest({
    $core.String? slugOrId,
    $core.String? locale,
  }) {
    final result = GetArticleRequest._();
    if (slugOrId != null) result.slugOrId = slugOrId;
    if (locale != null) result.locale = locale;
    return result;
  }

  GetArticleRequest._();

  factory GetArticleRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetArticleRequest()..mergeFromBuffer(data, registry);
  factory GetArticleRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetArticleRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetArticleRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.admin.v1'),
      createEmptyInstance: GetArticleRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'slugOrId')
    ..aOS(2, _omitFieldNames ? '' : 'locale')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetArticleRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetArticleRequest copyWith(void Function(GetArticleRequest) updates) =>
      super.copyWith((message) => updates(message as GetArticleRequest))
          as GetArticleRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use GetArticleRequest() / GetArticleRequest.new instead')
  static GetArticleRequest create() => GetArticleRequest._();
  static $pb.GeneratedMessage $_createMessage() => GetArticleRequest._();
  @$core.override
  GetArticleRequest createEmptyInstance() => GetArticleRequest._();
  @$core.pragma('dart2js:noInline')
  static GetArticleRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetArticleRequest>(
          GetArticleRequest.$_createMessage);
  static GetArticleRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get slugOrId => $_getSZ(0);
  @$pb.TagNumber(1)
  set slugOrId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSlugOrId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSlugOrId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get locale => $_getSZ(1);
  @$pb.TagNumber(2)
  set locale($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasLocale() => $_has(1);
  @$pb.TagNumber(2)
  void clearLocale() => $_clearField(2);
}

class GetArticleResponse extends $pb.GeneratedMessage {
  factory GetArticleResponse({
    KBArticleDetail? article,
  }) {
    final result = GetArticleResponse._();
    if (article != null) result.article = article;
    return result;
  }

  GetArticleResponse._();

  factory GetArticleResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetArticleResponse()..mergeFromBuffer(data, registry);
  factory GetArticleResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetArticleResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetArticleResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.admin.v1'),
      createEmptyInstance: GetArticleResponse.$_createMessage)
    ..aOM<KBArticleDetail>(1, _omitFieldNames ? '' : 'article',
        subBuilder: KBArticleDetail.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetArticleResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetArticleResponse copyWith(void Function(GetArticleResponse) updates) =>
      super.copyWith((message) => updates(message as GetArticleResponse))
          as GetArticleResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use GetArticleResponse() / GetArticleResponse.new instead')
  static GetArticleResponse create() => GetArticleResponse._();
  static $pb.GeneratedMessage $_createMessage() => GetArticleResponse._();
  @$core.override
  GetArticleResponse createEmptyInstance() => GetArticleResponse._();
  @$core.pragma('dart2js:noInline')
  static GetArticleResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetArticleResponse>(
          GetArticleResponse.$_createMessage);
  static GetArticleResponse? _defaultInstance;

  @$pb.TagNumber(1)
  KBArticleDetail get article => $_getN(0);
  @$pb.TagNumber(1)
  set article(KBArticleDetail value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasArticle() => $_has(0);
  @$pb.TagNumber(1)
  void clearArticle() => $_clearField(1);
  @$pb.TagNumber(1)
  KBArticleDetail ensureArticle() => $_ensure(0);
}

class RateArticleRequest extends $pb.GeneratedMessage {
  factory RateArticleRequest({
    $1.UUID? articleId,
    $1.UUID? userId,
    $core.bool? helpful,
    $core.String? feedbackText,
  }) {
    final result = RateArticleRequest._();
    if (articleId != null) result.articleId = articleId;
    if (userId != null) result.userId = userId;
    if (helpful != null) result.helpful = helpful;
    if (feedbackText != null) result.feedbackText = feedbackText;
    return result;
  }

  RateArticleRequest._();

  factory RateArticleRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RateArticleRequest()..mergeFromBuffer(data, registry);
  factory RateArticleRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RateArticleRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RateArticleRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.admin.v1'),
      createEmptyInstance: RateArticleRequest.$_createMessage)
    ..aOM<$1.UUID>(1, _omitFieldNames ? '' : 'articleId',
        subBuilder: $1.UUID.$_createMessage)
    ..aOM<$1.UUID>(2, _omitFieldNames ? '' : 'userId',
        subBuilder: $1.UUID.$_createMessage)
    ..aOB(3, _omitFieldNames ? '' : 'helpful')
    ..aOS(4, _omitFieldNames ? '' : 'feedbackText')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RateArticleRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RateArticleRequest copyWith(void Function(RateArticleRequest) updates) =>
      super.copyWith((message) => updates(message as RateArticleRequest))
          as RateArticleRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use RateArticleRequest() / RateArticleRequest.new instead')
  static RateArticleRequest create() => RateArticleRequest._();
  static $pb.GeneratedMessage $_createMessage() => RateArticleRequest._();
  @$core.override
  RateArticleRequest createEmptyInstance() => RateArticleRequest._();
  @$core.pragma('dart2js:noInline')
  static RateArticleRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RateArticleRequest>(
          RateArticleRequest.$_createMessage);
  static RateArticleRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $1.UUID get articleId => $_getN(0);
  @$pb.TagNumber(1)
  set articleId($1.UUID value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasArticleId() => $_has(0);
  @$pb.TagNumber(1)
  void clearArticleId() => $_clearField(1);
  @$pb.TagNumber(1)
  $1.UUID ensureArticleId() => $_ensure(0);

  @$pb.TagNumber(2)
  $1.UUID get userId => $_getN(1);
  @$pb.TagNumber(2)
  set userId($1.UUID value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasUserId() => $_has(1);
  @$pb.TagNumber(2)
  void clearUserId() => $_clearField(2);
  @$pb.TagNumber(2)
  $1.UUID ensureUserId() => $_ensure(1);

  @$pb.TagNumber(3)
  $core.bool get helpful => $_getBF(2);
  @$pb.TagNumber(3)
  set helpful($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasHelpful() => $_has(2);
  @$pb.TagNumber(3)
  void clearHelpful() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get feedbackText => $_getSZ(3);
  @$pb.TagNumber(4)
  set feedbackText($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasFeedbackText() => $_has(3);
  @$pb.TagNumber(4)
  void clearFeedbackText() => $_clearField(4);
}

class RateArticleResponse extends $pb.GeneratedMessage {
  factory RateArticleResponse({
    $core.bool? success,
    $core.int? helpfulVotes,
    $core.int? unhelpfulVotes,
  }) {
    final result = RateArticleResponse._();
    if (success != null) result.success = success;
    if (helpfulVotes != null) result.helpfulVotes = helpfulVotes;
    if (unhelpfulVotes != null) result.unhelpfulVotes = unhelpfulVotes;
    return result;
  }

  RateArticleResponse._();

  factory RateArticleResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RateArticleResponse()..mergeFromBuffer(data, registry);
  factory RateArticleResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RateArticleResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RateArticleResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.admin.v1'),
      createEmptyInstance: RateArticleResponse.$_createMessage)
    ..aOB(1, _omitFieldNames ? '' : 'success')
    ..aI(2, _omitFieldNames ? '' : 'helpfulVotes')
    ..aI(3, _omitFieldNames ? '' : 'unhelpfulVotes')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RateArticleResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RateArticleResponse copyWith(void Function(RateArticleResponse) updates) =>
      super.copyWith((message) => updates(message as RateArticleResponse))
          as RateArticleResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core
      .Deprecated('Use RateArticleResponse() / RateArticleResponse.new instead')
  static RateArticleResponse create() => RateArticleResponse._();
  static $pb.GeneratedMessage $_createMessage() => RateArticleResponse._();
  @$core.override
  RateArticleResponse createEmptyInstance() => RateArticleResponse._();
  @$core.pragma('dart2js:noInline')
  static RateArticleResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RateArticleResponse>(
          RateArticleResponse.$_createMessage);
  static RateArticleResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get success => $_getBF(0);
  @$pb.TagNumber(1)
  set success($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSuccess() => $_has(0);
  @$pb.TagNumber(1)
  void clearSuccess() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get helpfulVotes => $_getIZ(1);
  @$pb.TagNumber(2)
  set helpfulVotes($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasHelpfulVotes() => $_has(1);
  @$pb.TagNumber(2)
  void clearHelpfulVotes() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get unhelpfulVotes => $_getIZ(2);
  @$pb.TagNumber(3)
  set unhelpfulVotes($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasUnhelpfulVotes() => $_has(2);
  @$pb.TagNumber(3)
  void clearUnhelpfulVotes() => $_clearField(3);
}

class ListRecentRequest extends $pb.GeneratedMessage {
  factory ListRecentRequest({
    $core.String? locale,
    $core.String? moduleFilter,
    $core.int? limit,
  }) {
    final result = ListRecentRequest._();
    if (locale != null) result.locale = locale;
    if (moduleFilter != null) result.moduleFilter = moduleFilter;
    if (limit != null) result.limit = limit;
    return result;
  }

  ListRecentRequest._();

  factory ListRecentRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListRecentRequest()..mergeFromBuffer(data, registry);
  factory ListRecentRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListRecentRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListRecentRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.admin.v1'),
      createEmptyInstance: ListRecentRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'locale')
    ..aOS(2, _omitFieldNames ? '' : 'moduleFilter')
    ..aI(3, _omitFieldNames ? '' : 'limit')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListRecentRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListRecentRequest copyWith(void Function(ListRecentRequest) updates) =>
      super.copyWith((message) => updates(message as ListRecentRequest))
          as ListRecentRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ListRecentRequest() / ListRecentRequest.new instead')
  static ListRecentRequest create() => ListRecentRequest._();
  static $pb.GeneratedMessage $_createMessage() => ListRecentRequest._();
  @$core.override
  ListRecentRequest createEmptyInstance() => ListRecentRequest._();
  @$core.pragma('dart2js:noInline')
  static ListRecentRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ListRecentRequest>(
          ListRecentRequest.$_createMessage);
  static ListRecentRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get locale => $_getSZ(0);
  @$pb.TagNumber(1)
  set locale($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasLocale() => $_has(0);
  @$pb.TagNumber(1)
  void clearLocale() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get moduleFilter => $_getSZ(1);
  @$pb.TagNumber(2)
  set moduleFilter($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasModuleFilter() => $_has(1);
  @$pb.TagNumber(2)
  void clearModuleFilter() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get limit => $_getIZ(2);
  @$pb.TagNumber(3)
  set limit($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasLimit() => $_has(2);
  @$pb.TagNumber(3)
  void clearLimit() => $_clearField(3);
}

class ListRecentResponse extends $pb.GeneratedMessage {
  factory ListRecentResponse({
    $core.Iterable<KBArticleSummary>? articles,
  }) {
    final result = ListRecentResponse._();
    if (articles != null) result.articles.addAll(articles);
    return result;
  }

  ListRecentResponse._();

  factory ListRecentResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListRecentResponse()..mergeFromBuffer(data, registry);
  factory ListRecentResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListRecentResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListRecentResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.admin.v1'),
      createEmptyInstance: ListRecentResponse.$_createMessage)
    ..pPM<KBArticleSummary>(1, _omitFieldNames ? '' : 'articles',
        subBuilder: KBArticleSummary.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListRecentResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListRecentResponse copyWith(void Function(ListRecentResponse) updates) =>
      super.copyWith((message) => updates(message as ListRecentResponse))
          as ListRecentResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ListRecentResponse() / ListRecentResponse.new instead')
  static ListRecentResponse create() => ListRecentResponse._();
  static $pb.GeneratedMessage $_createMessage() => ListRecentResponse._();
  @$core.override
  ListRecentResponse createEmptyInstance() => ListRecentResponse._();
  @$core.pragma('dart2js:noInline')
  static ListRecentResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListRecentResponse>(
          ListRecentResponse.$_createMessage);
  static ListRecentResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<KBArticleSummary> get articles => $_getList(0);
}

/// KBAdminService messages
class ListArticlesRequest extends $pb.GeneratedMessage {
  factory ListArticlesRequest({
    KBArticleStatus? statusFilter,
    KBArticleType? typeFilter,
    $core.String? moduleFilter,
    $core.bool? staleOnly,
    $1.Pagination? pagination,
  }) {
    final result = ListArticlesRequest._();
    if (statusFilter != null) result.statusFilter = statusFilter;
    if (typeFilter != null) result.typeFilter = typeFilter;
    if (moduleFilter != null) result.moduleFilter = moduleFilter;
    if (staleOnly != null) result.staleOnly = staleOnly;
    if (pagination != null) result.pagination = pagination;
    return result;
  }

  ListArticlesRequest._();

  factory ListArticlesRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListArticlesRequest()..mergeFromBuffer(data, registry);
  factory ListArticlesRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListArticlesRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListArticlesRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.admin.v1'),
      createEmptyInstance: ListArticlesRequest.$_createMessage)
    ..aE<KBArticleStatus>(1, _omitFieldNames ? '' : 'statusFilter',
        enumValues: KBArticleStatus.values)
    ..aE<KBArticleType>(2, _omitFieldNames ? '' : 'typeFilter',
        enumValues: KBArticleType.values)
    ..aOS(3, _omitFieldNames ? '' : 'moduleFilter')
    ..aOB(4, _omitFieldNames ? '' : 'staleOnly')
    ..aOM<$1.Pagination>(5, _omitFieldNames ? '' : 'pagination',
        subBuilder: $1.Pagination.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListArticlesRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListArticlesRequest copyWith(void Function(ListArticlesRequest) updates) =>
      super.copyWith((message) => updates(message as ListArticlesRequest))
          as ListArticlesRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core
      .Deprecated('Use ListArticlesRequest() / ListArticlesRequest.new instead')
  static ListArticlesRequest create() => ListArticlesRequest._();
  static $pb.GeneratedMessage $_createMessage() => ListArticlesRequest._();
  @$core.override
  ListArticlesRequest createEmptyInstance() => ListArticlesRequest._();
  @$core.pragma('dart2js:noInline')
  static ListArticlesRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListArticlesRequest>(
          ListArticlesRequest.$_createMessage);
  static ListArticlesRequest? _defaultInstance;

  @$pb.TagNumber(1)
  KBArticleStatus get statusFilter => $_getN(0);
  @$pb.TagNumber(1)
  set statusFilter(KBArticleStatus value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasStatusFilter() => $_has(0);
  @$pb.TagNumber(1)
  void clearStatusFilter() => $_clearField(1);

  @$pb.TagNumber(2)
  KBArticleType get typeFilter => $_getN(1);
  @$pb.TagNumber(2)
  set typeFilter(KBArticleType value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasTypeFilter() => $_has(1);
  @$pb.TagNumber(2)
  void clearTypeFilter() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get moduleFilter => $_getSZ(2);
  @$pb.TagNumber(3)
  set moduleFilter($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasModuleFilter() => $_has(2);
  @$pb.TagNumber(3)
  void clearModuleFilter() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.bool get staleOnly => $_getBF(3);
  @$pb.TagNumber(4)
  set staleOnly($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(4)
  $core.bool hasStaleOnly() => $_has(3);
  @$pb.TagNumber(4)
  void clearStaleOnly() => $_clearField(4);

  @$pb.TagNumber(5)
  $1.Pagination get pagination => $_getN(4);
  @$pb.TagNumber(5)
  set pagination($1.Pagination value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasPagination() => $_has(4);
  @$pb.TagNumber(5)
  void clearPagination() => $_clearField(5);
  @$pb.TagNumber(5)
  $1.Pagination ensurePagination() => $_ensure(4);
}

class ListArticlesResponse extends $pb.GeneratedMessage {
  factory ListArticlesResponse({
    $core.Iterable<KBArticleSummary>? articles,
    $1.PaginatedResponse? pagination,
    $core.int? totalStaleCount,
  }) {
    final result = ListArticlesResponse._();
    if (articles != null) result.articles.addAll(articles);
    if (pagination != null) result.pagination = pagination;
    if (totalStaleCount != null) result.totalStaleCount = totalStaleCount;
    return result;
  }

  ListArticlesResponse._();

  factory ListArticlesResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListArticlesResponse()..mergeFromBuffer(data, registry);
  factory ListArticlesResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListArticlesResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListArticlesResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.admin.v1'),
      createEmptyInstance: ListArticlesResponse.$_createMessage)
    ..pPM<KBArticleSummary>(1, _omitFieldNames ? '' : 'articles',
        subBuilder: KBArticleSummary.$_createMessage)
    ..aOM<$1.PaginatedResponse>(2, _omitFieldNames ? '' : 'pagination',
        subBuilder: $1.PaginatedResponse.$_createMessage)
    ..aI(3, _omitFieldNames ? '' : 'totalStaleCount')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListArticlesResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListArticlesResponse copyWith(void Function(ListArticlesResponse) updates) =>
      super.copyWith((message) => updates(message as ListArticlesResponse))
          as ListArticlesResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ListArticlesResponse() / ListArticlesResponse.new instead')
  static ListArticlesResponse create() => ListArticlesResponse._();
  static $pb.GeneratedMessage $_createMessage() => ListArticlesResponse._();
  @$core.override
  ListArticlesResponse createEmptyInstance() => ListArticlesResponse._();
  @$core.pragma('dart2js:noInline')
  static ListArticlesResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListArticlesResponse>(
          ListArticlesResponse.$_createMessage);
  static ListArticlesResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<KBArticleSummary> get articles => $_getList(0);

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

  @$pb.TagNumber(3)
  $core.int get totalStaleCount => $_getIZ(2);
  @$pb.TagNumber(3)
  set totalStaleCount($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasTotalStaleCount() => $_has(2);
  @$pb.TagNumber(3)
  void clearTotalStaleCount() => $_clearField(3);
}

class KBAdminServiceGetArticleRequest extends $pb.GeneratedMessage {
  factory KBAdminServiceGetArticleRequest({
    $1.UUID? articleId,
  }) {
    final result = KBAdminServiceGetArticleRequest._();
    if (articleId != null) result.articleId = articleId;
    return result;
  }

  KBAdminServiceGetArticleRequest._();

  factory KBAdminServiceGetArticleRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      KBAdminServiceGetArticleRequest()..mergeFromBuffer(data, registry);
  factory KBAdminServiceGetArticleRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      KBAdminServiceGetArticleRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'KBAdminServiceGetArticleRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.admin.v1'),
      createEmptyInstance: KBAdminServiceGetArticleRequest.$_createMessage)
    ..aOM<$1.UUID>(1, _omitFieldNames ? '' : 'articleId',
        subBuilder: $1.UUID.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  KBAdminServiceGetArticleRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  KBAdminServiceGetArticleRequest copyWith(
          void Function(KBAdminServiceGetArticleRequest) updates) =>
      super.copyWith(
              (message) => updates(message as KBAdminServiceGetArticleRequest))
          as KBAdminServiceGetArticleRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use KBAdminServiceGetArticleRequest() / KBAdminServiceGetArticleRequest.new instead')
  static KBAdminServiceGetArticleRequest create() =>
      KBAdminServiceGetArticleRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      KBAdminServiceGetArticleRequest._();
  @$core.override
  KBAdminServiceGetArticleRequest createEmptyInstance() =>
      KBAdminServiceGetArticleRequest._();
  @$core.pragma('dart2js:noInline')
  static KBAdminServiceGetArticleRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<KBAdminServiceGetArticleRequest>(
          KBAdminServiceGetArticleRequest.$_createMessage);
  static KBAdminServiceGetArticleRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $1.UUID get articleId => $_getN(0);
  @$pb.TagNumber(1)
  set articleId($1.UUID value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasArticleId() => $_has(0);
  @$pb.TagNumber(1)
  void clearArticleId() => $_clearField(1);
  @$pb.TagNumber(1)
  $1.UUID ensureArticleId() => $_ensure(0);
}

class KBAdminServiceGetArticleResponse extends $pb.GeneratedMessage {
  factory KBAdminServiceGetArticleResponse({
    KBArticleDetail? article,
  }) {
    final result = KBAdminServiceGetArticleResponse._();
    if (article != null) result.article = article;
    return result;
  }

  KBAdminServiceGetArticleResponse._();

  factory KBAdminServiceGetArticleResponse.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      KBAdminServiceGetArticleResponse()..mergeFromBuffer(data, registry);
  factory KBAdminServiceGetArticleResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      KBAdminServiceGetArticleResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'KBAdminServiceGetArticleResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.admin.v1'),
      createEmptyInstance: KBAdminServiceGetArticleResponse.$_createMessage)
    ..aOM<KBArticleDetail>(1, _omitFieldNames ? '' : 'article',
        subBuilder: KBArticleDetail.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  KBAdminServiceGetArticleResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  KBAdminServiceGetArticleResponse copyWith(
          void Function(KBAdminServiceGetArticleResponse) updates) =>
      super.copyWith(
              (message) => updates(message as KBAdminServiceGetArticleResponse))
          as KBAdminServiceGetArticleResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use KBAdminServiceGetArticleResponse() / KBAdminServiceGetArticleResponse.new instead')
  static KBAdminServiceGetArticleResponse create() =>
      KBAdminServiceGetArticleResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      KBAdminServiceGetArticleResponse._();
  @$core.override
  KBAdminServiceGetArticleResponse createEmptyInstance() =>
      KBAdminServiceGetArticleResponse._();
  @$core.pragma('dart2js:noInline')
  static KBAdminServiceGetArticleResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<KBAdminServiceGetArticleResponse>(
          KBAdminServiceGetArticleResponse.$_createMessage);
  static KBAdminServiceGetArticleResponse? _defaultInstance;

  @$pb.TagNumber(1)
  KBArticleDetail get article => $_getN(0);
  @$pb.TagNumber(1)
  set article(KBArticleDetail value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasArticle() => $_has(0);
  @$pb.TagNumber(1)
  void clearArticle() => $_clearField(1);
  @$pb.TagNumber(1)
  KBArticleDetail ensureArticle() => $_ensure(0);
}

class CreateArticleRequest extends $pb.GeneratedMessage {
  factory CreateArticleRequest({
    $1.UUID? categoryId,
    $core.String? slug,
    $core.String? locale,
    $core.String? title,
    $core.String? summary,
    $core.String? bodyMarkdown,
    KBArticleType? articleType,
    $core.Iterable<$core.String>? targetModules,
    $core.Iterable<$core.String>? targetOperatorModes,
    $core.Iterable<$core.String>? tags,
    $core.int? estimatedReadMinutes,
  }) {
    final result = CreateArticleRequest._();
    if (categoryId != null) result.categoryId = categoryId;
    if (slug != null) result.slug = slug;
    if (locale != null) result.locale = locale;
    if (title != null) result.title = title;
    if (summary != null) result.summary = summary;
    if (bodyMarkdown != null) result.bodyMarkdown = bodyMarkdown;
    if (articleType != null) result.articleType = articleType;
    if (targetModules != null) result.targetModules.addAll(targetModules);
    if (targetOperatorModes != null)
      result.targetOperatorModes.addAll(targetOperatorModes);
    if (tags != null) result.tags.addAll(tags);
    if (estimatedReadMinutes != null)
      result.estimatedReadMinutes = estimatedReadMinutes;
    return result;
  }

  CreateArticleRequest._();

  factory CreateArticleRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CreateArticleRequest()..mergeFromBuffer(data, registry);
  factory CreateArticleRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CreateArticleRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CreateArticleRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.admin.v1'),
      createEmptyInstance: CreateArticleRequest.$_createMessage)
    ..aOM<$1.UUID>(1, _omitFieldNames ? '' : 'categoryId',
        subBuilder: $1.UUID.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'slug')
    ..aOS(3, _omitFieldNames ? '' : 'locale')
    ..aOS(4, _omitFieldNames ? '' : 'title')
    ..aOS(5, _omitFieldNames ? '' : 'summary')
    ..aOS(6, _omitFieldNames ? '' : 'bodyMarkdown')
    ..aE<KBArticleType>(7, _omitFieldNames ? '' : 'articleType',
        enumValues: KBArticleType.values)
    ..pPS(8, _omitFieldNames ? '' : 'targetModules')
    ..pPS(9, _omitFieldNames ? '' : 'targetOperatorModes')
    ..pPS(10, _omitFieldNames ? '' : 'tags')
    ..aI(11, _omitFieldNames ? '' : 'estimatedReadMinutes')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateArticleRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateArticleRequest copyWith(void Function(CreateArticleRequest) updates) =>
      super.copyWith((message) => updates(message as CreateArticleRequest))
          as CreateArticleRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use CreateArticleRequest() / CreateArticleRequest.new instead')
  static CreateArticleRequest create() => CreateArticleRequest._();
  static $pb.GeneratedMessage $_createMessage() => CreateArticleRequest._();
  @$core.override
  CreateArticleRequest createEmptyInstance() => CreateArticleRequest._();
  @$core.pragma('dart2js:noInline')
  static CreateArticleRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CreateArticleRequest>(
          CreateArticleRequest.$_createMessage);
  static CreateArticleRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $1.UUID get categoryId => $_getN(0);
  @$pb.TagNumber(1)
  set categoryId($1.UUID value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasCategoryId() => $_has(0);
  @$pb.TagNumber(1)
  void clearCategoryId() => $_clearField(1);
  @$pb.TagNumber(1)
  $1.UUID ensureCategoryId() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get slug => $_getSZ(1);
  @$pb.TagNumber(2)
  set slug($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSlug() => $_has(1);
  @$pb.TagNumber(2)
  void clearSlug() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get locale => $_getSZ(2);
  @$pb.TagNumber(3)
  set locale($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasLocale() => $_has(2);
  @$pb.TagNumber(3)
  void clearLocale() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get title => $_getSZ(3);
  @$pb.TagNumber(4)
  set title($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasTitle() => $_has(3);
  @$pb.TagNumber(4)
  void clearTitle() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get summary => $_getSZ(4);
  @$pb.TagNumber(5)
  set summary($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasSummary() => $_has(4);
  @$pb.TagNumber(5)
  void clearSummary() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get bodyMarkdown => $_getSZ(5);
  @$pb.TagNumber(6)
  set bodyMarkdown($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasBodyMarkdown() => $_has(5);
  @$pb.TagNumber(6)
  void clearBodyMarkdown() => $_clearField(6);

  @$pb.TagNumber(7)
  KBArticleType get articleType => $_getN(6);
  @$pb.TagNumber(7)
  set articleType(KBArticleType value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasArticleType() => $_has(6);
  @$pb.TagNumber(7)
  void clearArticleType() => $_clearField(7);

  @$pb.TagNumber(8)
  $pb.PbList<$core.String> get targetModules => $_getList(7);

  @$pb.TagNumber(9)
  $pb.PbList<$core.String> get targetOperatorModes => $_getList(8);

  @$pb.TagNumber(10)
  $pb.PbList<$core.String> get tags => $_getList(9);

  @$pb.TagNumber(11)
  $core.int get estimatedReadMinutes => $_getIZ(10);
  @$pb.TagNumber(11)
  set estimatedReadMinutes($core.int value) => $_setSignedInt32(10, value);
  @$pb.TagNumber(11)
  $core.bool hasEstimatedReadMinutes() => $_has(10);
  @$pb.TagNumber(11)
  void clearEstimatedReadMinutes() => $_clearField(11);
}

class CreateArticleResponse extends $pb.GeneratedMessage {
  factory CreateArticleResponse({
    KBArticleDetail? article,
  }) {
    final result = CreateArticleResponse._();
    if (article != null) result.article = article;
    return result;
  }

  CreateArticleResponse._();

  factory CreateArticleResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CreateArticleResponse()..mergeFromBuffer(data, registry);
  factory CreateArticleResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CreateArticleResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CreateArticleResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.admin.v1'),
      createEmptyInstance: CreateArticleResponse.$_createMessage)
    ..aOM<KBArticleDetail>(1, _omitFieldNames ? '' : 'article',
        subBuilder: KBArticleDetail.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateArticleResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateArticleResponse copyWith(
          void Function(CreateArticleResponse) updates) =>
      super.copyWith((message) => updates(message as CreateArticleResponse))
          as CreateArticleResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use CreateArticleResponse() / CreateArticleResponse.new instead')
  static CreateArticleResponse create() => CreateArticleResponse._();
  static $pb.GeneratedMessage $_createMessage() => CreateArticleResponse._();
  @$core.override
  CreateArticleResponse createEmptyInstance() => CreateArticleResponse._();
  @$core.pragma('dart2js:noInline')
  static CreateArticleResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CreateArticleResponse>(
          CreateArticleResponse.$_createMessage);
  static CreateArticleResponse? _defaultInstance;

  @$pb.TagNumber(1)
  KBArticleDetail get article => $_getN(0);
  @$pb.TagNumber(1)
  set article(KBArticleDetail value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasArticle() => $_has(0);
  @$pb.TagNumber(1)
  void clearArticle() => $_clearField(1);
  @$pb.TagNumber(1)
  KBArticleDetail ensureArticle() => $_ensure(0);
}

class UpdateArticleRequest extends $pb.GeneratedMessage {
  factory UpdateArticleRequest({
    $1.UUID? articleId,
    $core.String? title,
    $core.String? summary,
    $core.String? bodyMarkdown,
    KBArticleType? articleType,
    $core.Iterable<$core.String>? targetModules,
    $core.Iterable<$core.String>? targetOperatorModes,
    $core.Iterable<$core.String>? tags,
    $core.int? estimatedReadMinutes,
    $core.String? changeNote,
  }) {
    final result = UpdateArticleRequest._();
    if (articleId != null) result.articleId = articleId;
    if (title != null) result.title = title;
    if (summary != null) result.summary = summary;
    if (bodyMarkdown != null) result.bodyMarkdown = bodyMarkdown;
    if (articleType != null) result.articleType = articleType;
    if (targetModules != null) result.targetModules.addAll(targetModules);
    if (targetOperatorModes != null)
      result.targetOperatorModes.addAll(targetOperatorModes);
    if (tags != null) result.tags.addAll(tags);
    if (estimatedReadMinutes != null)
      result.estimatedReadMinutes = estimatedReadMinutes;
    if (changeNote != null) result.changeNote = changeNote;
    return result;
  }

  UpdateArticleRequest._();

  factory UpdateArticleRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      UpdateArticleRequest()..mergeFromBuffer(data, registry);
  factory UpdateArticleRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      UpdateArticleRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UpdateArticleRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.admin.v1'),
      createEmptyInstance: UpdateArticleRequest.$_createMessage)
    ..aOM<$1.UUID>(1, _omitFieldNames ? '' : 'articleId',
        subBuilder: $1.UUID.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'title')
    ..aOS(3, _omitFieldNames ? '' : 'summary')
    ..aOS(4, _omitFieldNames ? '' : 'bodyMarkdown')
    ..aE<KBArticleType>(5, _omitFieldNames ? '' : 'articleType',
        enumValues: KBArticleType.values)
    ..pPS(6, _omitFieldNames ? '' : 'targetModules')
    ..pPS(7, _omitFieldNames ? '' : 'targetOperatorModes')
    ..pPS(8, _omitFieldNames ? '' : 'tags')
    ..aI(9, _omitFieldNames ? '' : 'estimatedReadMinutes')
    ..aOS(10, _omitFieldNames ? '' : 'changeNote')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateArticleRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateArticleRequest copyWith(void Function(UpdateArticleRequest) updates) =>
      super.copyWith((message) => updates(message as UpdateArticleRequest))
          as UpdateArticleRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use UpdateArticleRequest() / UpdateArticleRequest.new instead')
  static UpdateArticleRequest create() => UpdateArticleRequest._();
  static $pb.GeneratedMessage $_createMessage() => UpdateArticleRequest._();
  @$core.override
  UpdateArticleRequest createEmptyInstance() => UpdateArticleRequest._();
  @$core.pragma('dart2js:noInline')
  static UpdateArticleRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UpdateArticleRequest>(
          UpdateArticleRequest.$_createMessage);
  static UpdateArticleRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $1.UUID get articleId => $_getN(0);
  @$pb.TagNumber(1)
  set articleId($1.UUID value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasArticleId() => $_has(0);
  @$pb.TagNumber(1)
  void clearArticleId() => $_clearField(1);
  @$pb.TagNumber(1)
  $1.UUID ensureArticleId() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get title => $_getSZ(1);
  @$pb.TagNumber(2)
  set title($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTitle() => $_has(1);
  @$pb.TagNumber(2)
  void clearTitle() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get summary => $_getSZ(2);
  @$pb.TagNumber(3)
  set summary($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasSummary() => $_has(2);
  @$pb.TagNumber(3)
  void clearSummary() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get bodyMarkdown => $_getSZ(3);
  @$pb.TagNumber(4)
  set bodyMarkdown($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasBodyMarkdown() => $_has(3);
  @$pb.TagNumber(4)
  void clearBodyMarkdown() => $_clearField(4);

  @$pb.TagNumber(5)
  KBArticleType get articleType => $_getN(4);
  @$pb.TagNumber(5)
  set articleType(KBArticleType value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasArticleType() => $_has(4);
  @$pb.TagNumber(5)
  void clearArticleType() => $_clearField(5);

  @$pb.TagNumber(6)
  $pb.PbList<$core.String> get targetModules => $_getList(5);

  @$pb.TagNumber(7)
  $pb.PbList<$core.String> get targetOperatorModes => $_getList(6);

  @$pb.TagNumber(8)
  $pb.PbList<$core.String> get tags => $_getList(7);

  @$pb.TagNumber(9)
  $core.int get estimatedReadMinutes => $_getIZ(8);
  @$pb.TagNumber(9)
  set estimatedReadMinutes($core.int value) => $_setSignedInt32(8, value);
  @$pb.TagNumber(9)
  $core.bool hasEstimatedReadMinutes() => $_has(8);
  @$pb.TagNumber(9)
  void clearEstimatedReadMinutes() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.String get changeNote => $_getSZ(9);
  @$pb.TagNumber(10)
  set changeNote($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasChangeNote() => $_has(9);
  @$pb.TagNumber(10)
  void clearChangeNote() => $_clearField(10);
}

class UpdateArticleResponse extends $pb.GeneratedMessage {
  factory UpdateArticleResponse({
    KBArticleDetail? article,
  }) {
    final result = UpdateArticleResponse._();
    if (article != null) result.article = article;
    return result;
  }

  UpdateArticleResponse._();

  factory UpdateArticleResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      UpdateArticleResponse()..mergeFromBuffer(data, registry);
  factory UpdateArticleResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      UpdateArticleResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UpdateArticleResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.admin.v1'),
      createEmptyInstance: UpdateArticleResponse.$_createMessage)
    ..aOM<KBArticleDetail>(1, _omitFieldNames ? '' : 'article',
        subBuilder: KBArticleDetail.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateArticleResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateArticleResponse copyWith(
          void Function(UpdateArticleResponse) updates) =>
      super.copyWith((message) => updates(message as UpdateArticleResponse))
          as UpdateArticleResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use UpdateArticleResponse() / UpdateArticleResponse.new instead')
  static UpdateArticleResponse create() => UpdateArticleResponse._();
  static $pb.GeneratedMessage $_createMessage() => UpdateArticleResponse._();
  @$core.override
  UpdateArticleResponse createEmptyInstance() => UpdateArticleResponse._();
  @$core.pragma('dart2js:noInline')
  static UpdateArticleResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UpdateArticleResponse>(
          UpdateArticleResponse.$_createMessage);
  static UpdateArticleResponse? _defaultInstance;

  @$pb.TagNumber(1)
  KBArticleDetail get article => $_getN(0);
  @$pb.TagNumber(1)
  set article(KBArticleDetail value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasArticle() => $_has(0);
  @$pb.TagNumber(1)
  void clearArticle() => $_clearField(1);
  @$pb.TagNumber(1)
  KBArticleDetail ensureArticle() => $_ensure(0);
}

class PublishArticleRequest extends $pb.GeneratedMessage {
  factory PublishArticleRequest({
    $1.UUID? articleId,
  }) {
    final result = PublishArticleRequest._();
    if (articleId != null) result.articleId = articleId;
    return result;
  }

  PublishArticleRequest._();

  factory PublishArticleRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PublishArticleRequest()..mergeFromBuffer(data, registry);
  factory PublishArticleRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PublishArticleRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PublishArticleRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.admin.v1'),
      createEmptyInstance: PublishArticleRequest.$_createMessage)
    ..aOM<$1.UUID>(1, _omitFieldNames ? '' : 'articleId',
        subBuilder: $1.UUID.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PublishArticleRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PublishArticleRequest copyWith(
          void Function(PublishArticleRequest) updates) =>
      super.copyWith((message) => updates(message as PublishArticleRequest))
          as PublishArticleRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use PublishArticleRequest() / PublishArticleRequest.new instead')
  static PublishArticleRequest create() => PublishArticleRequest._();
  static $pb.GeneratedMessage $_createMessage() => PublishArticleRequest._();
  @$core.override
  PublishArticleRequest createEmptyInstance() => PublishArticleRequest._();
  @$core.pragma('dart2js:noInline')
  static PublishArticleRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PublishArticleRequest>(
          PublishArticleRequest.$_createMessage);
  static PublishArticleRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $1.UUID get articleId => $_getN(0);
  @$pb.TagNumber(1)
  set articleId($1.UUID value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasArticleId() => $_has(0);
  @$pb.TagNumber(1)
  void clearArticleId() => $_clearField(1);
  @$pb.TagNumber(1)
  $1.UUID ensureArticleId() => $_ensure(0);
}

class PublishArticleResponse extends $pb.GeneratedMessage {
  factory PublishArticleResponse({
    KBArticleDetail? article,
  }) {
    final result = PublishArticleResponse._();
    if (article != null) result.article = article;
    return result;
  }

  PublishArticleResponse._();

  factory PublishArticleResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PublishArticleResponse()..mergeFromBuffer(data, registry);
  factory PublishArticleResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PublishArticleResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PublishArticleResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.admin.v1'),
      createEmptyInstance: PublishArticleResponse.$_createMessage)
    ..aOM<KBArticleDetail>(1, _omitFieldNames ? '' : 'article',
        subBuilder: KBArticleDetail.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PublishArticleResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PublishArticleResponse copyWith(
          void Function(PublishArticleResponse) updates) =>
      super.copyWith((message) => updates(message as PublishArticleResponse))
          as PublishArticleResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use PublishArticleResponse() / PublishArticleResponse.new instead')
  static PublishArticleResponse create() => PublishArticleResponse._();
  static $pb.GeneratedMessage $_createMessage() => PublishArticleResponse._();
  @$core.override
  PublishArticleResponse createEmptyInstance() => PublishArticleResponse._();
  @$core.pragma('dart2js:noInline')
  static PublishArticleResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PublishArticleResponse>(
          PublishArticleResponse.$_createMessage);
  static PublishArticleResponse? _defaultInstance;

  @$pb.TagNumber(1)
  KBArticleDetail get article => $_getN(0);
  @$pb.TagNumber(1)
  set article(KBArticleDetail value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasArticle() => $_has(0);
  @$pb.TagNumber(1)
  void clearArticle() => $_clearField(1);
  @$pb.TagNumber(1)
  KBArticleDetail ensureArticle() => $_ensure(0);
}

class ArchiveArticleRequest extends $pb.GeneratedMessage {
  factory ArchiveArticleRequest({
    $1.UUID? articleId,
    $core.String? reason,
  }) {
    final result = ArchiveArticleRequest._();
    if (articleId != null) result.articleId = articleId;
    if (reason != null) result.reason = reason;
    return result;
  }

  ArchiveArticleRequest._();

  factory ArchiveArticleRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ArchiveArticleRequest()..mergeFromBuffer(data, registry);
  factory ArchiveArticleRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ArchiveArticleRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ArchiveArticleRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.admin.v1'),
      createEmptyInstance: ArchiveArticleRequest.$_createMessage)
    ..aOM<$1.UUID>(1, _omitFieldNames ? '' : 'articleId',
        subBuilder: $1.UUID.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'reason')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ArchiveArticleRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ArchiveArticleRequest copyWith(
          void Function(ArchiveArticleRequest) updates) =>
      super.copyWith((message) => updates(message as ArchiveArticleRequest))
          as ArchiveArticleRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ArchiveArticleRequest() / ArchiveArticleRequest.new instead')
  static ArchiveArticleRequest create() => ArchiveArticleRequest._();
  static $pb.GeneratedMessage $_createMessage() => ArchiveArticleRequest._();
  @$core.override
  ArchiveArticleRequest createEmptyInstance() => ArchiveArticleRequest._();
  @$core.pragma('dart2js:noInline')
  static ArchiveArticleRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ArchiveArticleRequest>(
          ArchiveArticleRequest.$_createMessage);
  static ArchiveArticleRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $1.UUID get articleId => $_getN(0);
  @$pb.TagNumber(1)
  set articleId($1.UUID value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasArticleId() => $_has(0);
  @$pb.TagNumber(1)
  void clearArticleId() => $_clearField(1);
  @$pb.TagNumber(1)
  $1.UUID ensureArticleId() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get reason => $_getSZ(1);
  @$pb.TagNumber(2)
  set reason($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasReason() => $_has(1);
  @$pb.TagNumber(2)
  void clearReason() => $_clearField(2);
}

class ArchiveArticleResponse extends $pb.GeneratedMessage {
  factory ArchiveArticleResponse({
    $core.bool? success,
  }) {
    final result = ArchiveArticleResponse._();
    if (success != null) result.success = success;
    return result;
  }

  ArchiveArticleResponse._();

  factory ArchiveArticleResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ArchiveArticleResponse()..mergeFromBuffer(data, registry);
  factory ArchiveArticleResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ArchiveArticleResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ArchiveArticleResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.admin.v1'),
      createEmptyInstance: ArchiveArticleResponse.$_createMessage)
    ..aOB(1, _omitFieldNames ? '' : 'success')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ArchiveArticleResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ArchiveArticleResponse copyWith(
          void Function(ArchiveArticleResponse) updates) =>
      super.copyWith((message) => updates(message as ArchiveArticleResponse))
          as ArchiveArticleResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ArchiveArticleResponse() / ArchiveArticleResponse.new instead')
  static ArchiveArticleResponse create() => ArchiveArticleResponse._();
  static $pb.GeneratedMessage $_createMessage() => ArchiveArticleResponse._();
  @$core.override
  ArchiveArticleResponse createEmptyInstance() => ArchiveArticleResponse._();
  @$core.pragma('dart2js:noInline')
  static ArchiveArticleResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ArchiveArticleResponse>(
          ArchiveArticleResponse.$_createMessage);
  static ArchiveArticleResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get success => $_getBF(0);
  @$pb.TagNumber(1)
  set success($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSuccess() => $_has(0);
  @$pb.TagNumber(1)
  void clearSuccess() => $_clearField(1);
}

class ListStaleArticlesRequest extends $pb.GeneratedMessage {
  factory ListStaleArticlesRequest({
    $core.int? daysThreshold,
    $1.Pagination? pagination,
  }) {
    final result = ListStaleArticlesRequest._();
    if (daysThreshold != null) result.daysThreshold = daysThreshold;
    if (pagination != null) result.pagination = pagination;
    return result;
  }

  ListStaleArticlesRequest._();

  factory ListStaleArticlesRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListStaleArticlesRequest()..mergeFromBuffer(data, registry);
  factory ListStaleArticlesRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListStaleArticlesRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListStaleArticlesRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.admin.v1'),
      createEmptyInstance: ListStaleArticlesRequest.$_createMessage)
    ..aI(1, _omitFieldNames ? '' : 'daysThreshold')
    ..aOM<$1.Pagination>(2, _omitFieldNames ? '' : 'pagination',
        subBuilder: $1.Pagination.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListStaleArticlesRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListStaleArticlesRequest copyWith(
          void Function(ListStaleArticlesRequest) updates) =>
      super.copyWith((message) => updates(message as ListStaleArticlesRequest))
          as ListStaleArticlesRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ListStaleArticlesRequest() / ListStaleArticlesRequest.new instead')
  static ListStaleArticlesRequest create() => ListStaleArticlesRequest._();
  static $pb.GeneratedMessage $_createMessage() => ListStaleArticlesRequest._();
  @$core.override
  ListStaleArticlesRequest createEmptyInstance() =>
      ListStaleArticlesRequest._();
  @$core.pragma('dart2js:noInline')
  static ListStaleArticlesRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListStaleArticlesRequest>(
          ListStaleArticlesRequest.$_createMessage);
  static ListStaleArticlesRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get daysThreshold => $_getIZ(0);
  @$pb.TagNumber(1)
  set daysThreshold($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasDaysThreshold() => $_has(0);
  @$pb.TagNumber(1)
  void clearDaysThreshold() => $_clearField(1);

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
}

class ListStaleArticlesResponse extends $pb.GeneratedMessage {
  factory ListStaleArticlesResponse({
    $core.Iterable<KBArticleSummary>? staleArticles,
    $1.PaginatedResponse? pagination,
    $core.int? staleCount,
  }) {
    final result = ListStaleArticlesResponse._();
    if (staleArticles != null) result.staleArticles.addAll(staleArticles);
    if (pagination != null) result.pagination = pagination;
    if (staleCount != null) result.staleCount = staleCount;
    return result;
  }

  ListStaleArticlesResponse._();

  factory ListStaleArticlesResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListStaleArticlesResponse()..mergeFromBuffer(data, registry);
  factory ListStaleArticlesResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListStaleArticlesResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListStaleArticlesResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.admin.v1'),
      createEmptyInstance: ListStaleArticlesResponse.$_createMessage)
    ..pPM<KBArticleSummary>(1, _omitFieldNames ? '' : 'staleArticles',
        subBuilder: KBArticleSummary.$_createMessage)
    ..aOM<$1.PaginatedResponse>(2, _omitFieldNames ? '' : 'pagination',
        subBuilder: $1.PaginatedResponse.$_createMessage)
    ..aI(3, _omitFieldNames ? '' : 'staleCount')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListStaleArticlesResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListStaleArticlesResponse copyWith(
          void Function(ListStaleArticlesResponse) updates) =>
      super.copyWith((message) => updates(message as ListStaleArticlesResponse))
          as ListStaleArticlesResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ListStaleArticlesResponse() / ListStaleArticlesResponse.new instead')
  static ListStaleArticlesResponse create() => ListStaleArticlesResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      ListStaleArticlesResponse._();
  @$core.override
  ListStaleArticlesResponse createEmptyInstance() =>
      ListStaleArticlesResponse._();
  @$core.pragma('dart2js:noInline')
  static ListStaleArticlesResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListStaleArticlesResponse>(
          ListStaleArticlesResponse.$_createMessage);
  static ListStaleArticlesResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<KBArticleSummary> get staleArticles => $_getList(0);

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

  @$pb.TagNumber(3)
  $core.int get staleCount => $_getIZ(2);
  @$pb.TagNumber(3)
  set staleCount($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasStaleCount() => $_has(2);
  @$pb.TagNumber(3)
  void clearStaleCount() => $_clearField(3);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');

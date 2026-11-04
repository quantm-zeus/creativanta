// This is a generated file - do not edit.
//
// Generated from creativanta/commerce/v1/creator_pro.proto.

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

import 'creator_pro.pbenum.dart';

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'creator_pro.pbenum.dart';

/// Canonical LinkInBioPage model.
class LinkInBioPage extends $pb.GeneratedMessage {
  factory LinkInBioPage({
    $core.String? pageId,
    $core.String? workspaceId,
    $core.String? slug,
    $core.String? title,
    $core.String? bio,
    $core.String? avatarUrl,
    $core.String? theme,
    $core.String? customCss,
    $core.String? customDomain,
    $core.bool? customDomainVerified,
    $core.bool? analyticsEnabled,
    $core.int? totalViews,
    LinkInBioPageStatus? status,
    $1.Timestamp? createdAt,
    $1.Timestamp? updatedAt,
    $core.Iterable<LinkItem>? items,
  }) {
    final result = LinkInBioPage._();
    if (pageId != null) result.pageId = pageId;
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (slug != null) result.slug = slug;
    if (title != null) result.title = title;
    if (bio != null) result.bio = bio;
    if (avatarUrl != null) result.avatarUrl = avatarUrl;
    if (theme != null) result.theme = theme;
    if (customCss != null) result.customCss = customCss;
    if (customDomain != null) result.customDomain = customDomain;
    if (customDomainVerified != null)
      result.customDomainVerified = customDomainVerified;
    if (analyticsEnabled != null) result.analyticsEnabled = analyticsEnabled;
    if (totalViews != null) result.totalViews = totalViews;
    if (status != null) result.status = status;
    if (createdAt != null) result.createdAt = createdAt;
    if (updatedAt != null) result.updatedAt = updatedAt;
    if (items != null) result.items.addAll(items);
    return result;
  }

  LinkInBioPage._();

  factory LinkInBioPage.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      LinkInBioPage()..mergeFromBuffer(data, registry);
  factory LinkInBioPage.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      LinkInBioPage()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'LinkInBioPage',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: LinkInBioPage.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'pageId')
    ..aOS(2, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(3, _omitFieldNames ? '' : 'slug')
    ..aOS(4, _omitFieldNames ? '' : 'title')
    ..aOS(5, _omitFieldNames ? '' : 'bio')
    ..aOS(6, _omitFieldNames ? '' : 'avatarUrl')
    ..aOS(7, _omitFieldNames ? '' : 'theme')
    ..aOS(8, _omitFieldNames ? '' : 'customCss')
    ..aOS(9, _omitFieldNames ? '' : 'customDomain')
    ..aOB(10, _omitFieldNames ? '' : 'customDomainVerified')
    ..aOB(11, _omitFieldNames ? '' : 'analyticsEnabled')
    ..aI(12, _omitFieldNames ? '' : 'totalViews')
    ..aE<LinkInBioPageStatus>(13, _omitFieldNames ? '' : 'status',
        enumValues: LinkInBioPageStatus.values)
    ..aOM<$1.Timestamp>(14, _omitFieldNames ? '' : 'createdAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..aOM<$1.Timestamp>(15, _omitFieldNames ? '' : 'updatedAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..pPM<LinkItem>(16, _omitFieldNames ? '' : 'items',
        subBuilder: LinkItem.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LinkInBioPage clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LinkInBioPage copyWith(void Function(LinkInBioPage) updates) =>
      super.copyWith((message) => updates(message as LinkInBioPage))
          as LinkInBioPage;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use LinkInBioPage() / LinkInBioPage.new instead')
  static LinkInBioPage create() => LinkInBioPage._();
  static $pb.GeneratedMessage $_createMessage() => LinkInBioPage._();
  @$core.override
  LinkInBioPage createEmptyInstance() => LinkInBioPage._();
  @$core.pragma('dart2js:noInline')
  static LinkInBioPage getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<LinkInBioPage>(
          LinkInBioPage.$_createMessage);
  static LinkInBioPage? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get pageId => $_getSZ(0);
  @$pb.TagNumber(1)
  set pageId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPageId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPageId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get workspaceId => $_getSZ(1);
  @$pb.TagNumber(2)
  set workspaceId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasWorkspaceId() => $_has(1);
  @$pb.TagNumber(2)
  void clearWorkspaceId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get slug => $_getSZ(2);
  @$pb.TagNumber(3)
  set slug($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasSlug() => $_has(2);
  @$pb.TagNumber(3)
  void clearSlug() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get title => $_getSZ(3);
  @$pb.TagNumber(4)
  set title($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasTitle() => $_has(3);
  @$pb.TagNumber(4)
  void clearTitle() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get bio => $_getSZ(4);
  @$pb.TagNumber(5)
  set bio($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasBio() => $_has(4);
  @$pb.TagNumber(5)
  void clearBio() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get avatarUrl => $_getSZ(5);
  @$pb.TagNumber(6)
  set avatarUrl($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasAvatarUrl() => $_has(5);
  @$pb.TagNumber(6)
  void clearAvatarUrl() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get theme => $_getSZ(6);
  @$pb.TagNumber(7)
  set theme($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasTheme() => $_has(6);
  @$pb.TagNumber(7)
  void clearTheme() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get customCss => $_getSZ(7);
  @$pb.TagNumber(8)
  set customCss($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasCustomCss() => $_has(7);
  @$pb.TagNumber(8)
  void clearCustomCss() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get customDomain => $_getSZ(8);
  @$pb.TagNumber(9)
  set customDomain($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasCustomDomain() => $_has(8);
  @$pb.TagNumber(9)
  void clearCustomDomain() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.bool get customDomainVerified => $_getBF(9);
  @$pb.TagNumber(10)
  set customDomainVerified($core.bool value) => $_setBool(9, value);
  @$pb.TagNumber(10)
  $core.bool hasCustomDomainVerified() => $_has(9);
  @$pb.TagNumber(10)
  void clearCustomDomainVerified() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.bool get analyticsEnabled => $_getBF(10);
  @$pb.TagNumber(11)
  set analyticsEnabled($core.bool value) => $_setBool(10, value);
  @$pb.TagNumber(11)
  $core.bool hasAnalyticsEnabled() => $_has(10);
  @$pb.TagNumber(11)
  void clearAnalyticsEnabled() => $_clearField(11);

  @$pb.TagNumber(12)
  $core.int get totalViews => $_getIZ(11);
  @$pb.TagNumber(12)
  set totalViews($core.int value) => $_setSignedInt32(11, value);
  @$pb.TagNumber(12)
  $core.bool hasTotalViews() => $_has(11);
  @$pb.TagNumber(12)
  void clearTotalViews() => $_clearField(12);

  @$pb.TagNumber(13)
  LinkInBioPageStatus get status => $_getN(12);
  @$pb.TagNumber(13)
  set status(LinkInBioPageStatus value) => $_setField(13, value);
  @$pb.TagNumber(13)
  $core.bool hasStatus() => $_has(12);
  @$pb.TagNumber(13)
  void clearStatus() => $_clearField(13);

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

  @$pb.TagNumber(16)
  $pb.PbList<LinkItem> get items => $_getList(15);
}

/// Canonical LinkItem model.
class LinkItem extends $pb.GeneratedMessage {
  factory LinkItem({
    $core.String? linkItemId,
    $core.String? pageId,
    $core.String? workspaceId,
    LinkType? linkType,
    $core.String? label,
    $core.String? url,
    $core.String? icon,
    $core.String? thumbnailUrl,
    $core.int? position,
    $core.int? clicks,
    $core.bool? isActive,
    LinkSecurityScanStatus? scanStatus,
    $core.bool? phishingDetected,
    $core.String? scanThreatDetails,
    $1.Timestamp? createdAt,
  }) {
    final result = LinkItem._();
    if (linkItemId != null) result.linkItemId = linkItemId;
    if (pageId != null) result.pageId = pageId;
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (linkType != null) result.linkType = linkType;
    if (label != null) result.label = label;
    if (url != null) result.url = url;
    if (icon != null) result.icon = icon;
    if (thumbnailUrl != null) result.thumbnailUrl = thumbnailUrl;
    if (position != null) result.position = position;
    if (clicks != null) result.clicks = clicks;
    if (isActive != null) result.isActive = isActive;
    if (scanStatus != null) result.scanStatus = scanStatus;
    if (phishingDetected != null) result.phishingDetected = phishingDetected;
    if (scanThreatDetails != null) result.scanThreatDetails = scanThreatDetails;
    if (createdAt != null) result.createdAt = createdAt;
    return result;
  }

  LinkItem._();

  factory LinkItem.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      LinkItem()..mergeFromBuffer(data, registry);
  factory LinkItem.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      LinkItem()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'LinkItem',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: LinkItem.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'linkItemId')
    ..aOS(2, _omitFieldNames ? '' : 'pageId')
    ..aOS(3, _omitFieldNames ? '' : 'workspaceId')
    ..aE<LinkType>(4, _omitFieldNames ? '' : 'linkType',
        enumValues: LinkType.values)
    ..aOS(5, _omitFieldNames ? '' : 'label')
    ..aOS(6, _omitFieldNames ? '' : 'url')
    ..aOS(7, _omitFieldNames ? '' : 'icon')
    ..aOS(8, _omitFieldNames ? '' : 'thumbnailUrl')
    ..aI(9, _omitFieldNames ? '' : 'position')
    ..aI(10, _omitFieldNames ? '' : 'clicks')
    ..aOB(11, _omitFieldNames ? '' : 'isActive')
    ..aE<LinkSecurityScanStatus>(12, _omitFieldNames ? '' : 'scanStatus',
        enumValues: LinkSecurityScanStatus.values)
    ..aOB(13, _omitFieldNames ? '' : 'phishingDetected')
    ..aOS(14, _omitFieldNames ? '' : 'scanThreatDetails')
    ..aOM<$1.Timestamp>(15, _omitFieldNames ? '' : 'createdAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LinkItem clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LinkItem copyWith(void Function(LinkItem) updates) =>
      super.copyWith((message) => updates(message as LinkItem)) as LinkItem;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use LinkItem() / LinkItem.new instead')
  static LinkItem create() => LinkItem._();
  static $pb.GeneratedMessage $_createMessage() => LinkItem._();
  @$core.override
  LinkItem createEmptyInstance() => LinkItem._();
  @$core.pragma('dart2js:noInline')
  static LinkItem getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<LinkItem>(LinkItem.$_createMessage);
  static LinkItem? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get linkItemId => $_getSZ(0);
  @$pb.TagNumber(1)
  set linkItemId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasLinkItemId() => $_has(0);
  @$pb.TagNumber(1)
  void clearLinkItemId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get pageId => $_getSZ(1);
  @$pb.TagNumber(2)
  set pageId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPageId() => $_has(1);
  @$pb.TagNumber(2)
  void clearPageId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get workspaceId => $_getSZ(2);
  @$pb.TagNumber(3)
  set workspaceId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasWorkspaceId() => $_has(2);
  @$pb.TagNumber(3)
  void clearWorkspaceId() => $_clearField(3);

  @$pb.TagNumber(4)
  LinkType get linkType => $_getN(3);
  @$pb.TagNumber(4)
  set linkType(LinkType value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasLinkType() => $_has(3);
  @$pb.TagNumber(4)
  void clearLinkType() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get label => $_getSZ(4);
  @$pb.TagNumber(5)
  set label($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasLabel() => $_has(4);
  @$pb.TagNumber(5)
  void clearLabel() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get url => $_getSZ(5);
  @$pb.TagNumber(6)
  set url($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasUrl() => $_has(5);
  @$pb.TagNumber(6)
  void clearUrl() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get icon => $_getSZ(6);
  @$pb.TagNumber(7)
  set icon($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasIcon() => $_has(6);
  @$pb.TagNumber(7)
  void clearIcon() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get thumbnailUrl => $_getSZ(7);
  @$pb.TagNumber(8)
  set thumbnailUrl($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasThumbnailUrl() => $_has(7);
  @$pb.TagNumber(8)
  void clearThumbnailUrl() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.int get position => $_getIZ(8);
  @$pb.TagNumber(9)
  set position($core.int value) => $_setSignedInt32(8, value);
  @$pb.TagNumber(9)
  $core.bool hasPosition() => $_has(8);
  @$pb.TagNumber(9)
  void clearPosition() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.int get clicks => $_getIZ(9);
  @$pb.TagNumber(10)
  set clicks($core.int value) => $_setSignedInt32(9, value);
  @$pb.TagNumber(10)
  $core.bool hasClicks() => $_has(9);
  @$pb.TagNumber(10)
  void clearClicks() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.bool get isActive => $_getBF(10);
  @$pb.TagNumber(11)
  set isActive($core.bool value) => $_setBool(10, value);
  @$pb.TagNumber(11)
  $core.bool hasIsActive() => $_has(10);
  @$pb.TagNumber(11)
  void clearIsActive() => $_clearField(11);

  @$pb.TagNumber(12)
  LinkSecurityScanStatus get scanStatus => $_getN(11);
  @$pb.TagNumber(12)
  set scanStatus(LinkSecurityScanStatus value) => $_setField(12, value);
  @$pb.TagNumber(12)
  $core.bool hasScanStatus() => $_has(11);
  @$pb.TagNumber(12)
  void clearScanStatus() => $_clearField(12);

  @$pb.TagNumber(13)
  $core.bool get phishingDetected => $_getBF(12);
  @$pb.TagNumber(13)
  set phishingDetected($core.bool value) => $_setBool(12, value);
  @$pb.TagNumber(13)
  $core.bool hasPhishingDetected() => $_has(12);
  @$pb.TagNumber(13)
  void clearPhishingDetected() => $_clearField(13);

  @$pb.TagNumber(14)
  $core.String get scanThreatDetails => $_getSZ(13);
  @$pb.TagNumber(14)
  set scanThreatDetails($core.String value) => $_setString(13, value);
  @$pb.TagNumber(14)
  $core.bool hasScanThreatDetails() => $_has(13);
  @$pb.TagNumber(14)
  void clearScanThreatDetails() => $_clearField(14);

  @$pb.TagNumber(15)
  $1.Timestamp get createdAt => $_getN(14);
  @$pb.TagNumber(15)
  set createdAt($1.Timestamp value) => $_setField(15, value);
  @$pb.TagNumber(15)
  $core.bool hasCreatedAt() => $_has(14);
  @$pb.TagNumber(15)
  void clearCreatedAt() => $_clearField(15);
  @$pb.TagNumber(15)
  $1.Timestamp ensureCreatedAt() => $_ensure(14);
}

/// Link click and engagement analytics summary.
class LinkInBioAnalytics extends $pb.GeneratedMessage {
  factory LinkInBioAnalytics({
    $core.String? pageId,
    $core.String? workspaceId,
    $core.int? totalViews,
    $core.int? totalClicks,
    $core.double? clickThroughRate,
    $core.Iterable<LinkItemMetric>? itemMetrics,
  }) {
    final result = LinkInBioAnalytics._();
    if (pageId != null) result.pageId = pageId;
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (totalViews != null) result.totalViews = totalViews;
    if (totalClicks != null) result.totalClicks = totalClicks;
    if (clickThroughRate != null) result.clickThroughRate = clickThroughRate;
    if (itemMetrics != null) result.itemMetrics.addAll(itemMetrics);
    return result;
  }

  LinkInBioAnalytics._();

  factory LinkInBioAnalytics.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      LinkInBioAnalytics()..mergeFromBuffer(data, registry);
  factory LinkInBioAnalytics.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      LinkInBioAnalytics()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'LinkInBioAnalytics',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: LinkInBioAnalytics.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'pageId')
    ..aOS(2, _omitFieldNames ? '' : 'workspaceId')
    ..aI(3, _omitFieldNames ? '' : 'totalViews')
    ..aI(4, _omitFieldNames ? '' : 'totalClicks')
    ..aD(5, _omitFieldNames ? '' : 'clickThroughRate')
    ..pPM<LinkItemMetric>(6, _omitFieldNames ? '' : 'itemMetrics',
        subBuilder: LinkItemMetric.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LinkInBioAnalytics clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LinkInBioAnalytics copyWith(void Function(LinkInBioAnalytics) updates) =>
      super.copyWith((message) => updates(message as LinkInBioAnalytics))
          as LinkInBioAnalytics;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use LinkInBioAnalytics() / LinkInBioAnalytics.new instead')
  static LinkInBioAnalytics create() => LinkInBioAnalytics._();
  static $pb.GeneratedMessage $_createMessage() => LinkInBioAnalytics._();
  @$core.override
  LinkInBioAnalytics createEmptyInstance() => LinkInBioAnalytics._();
  @$core.pragma('dart2js:noInline')
  static LinkInBioAnalytics getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<LinkInBioAnalytics>(
          LinkInBioAnalytics.$_createMessage);
  static LinkInBioAnalytics? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get pageId => $_getSZ(0);
  @$pb.TagNumber(1)
  set pageId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPageId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPageId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get workspaceId => $_getSZ(1);
  @$pb.TagNumber(2)
  set workspaceId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasWorkspaceId() => $_has(1);
  @$pb.TagNumber(2)
  void clearWorkspaceId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get totalViews => $_getIZ(2);
  @$pb.TagNumber(3)
  set totalViews($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasTotalViews() => $_has(2);
  @$pb.TagNumber(3)
  void clearTotalViews() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get totalClicks => $_getIZ(3);
  @$pb.TagNumber(4)
  set totalClicks($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasTotalClicks() => $_has(3);
  @$pb.TagNumber(4)
  void clearTotalClicks() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.double get clickThroughRate => $_getN(4);
  @$pb.TagNumber(5)
  set clickThroughRate($core.double value) => $_setDouble(4, value);
  @$pb.TagNumber(5)
  $core.bool hasClickThroughRate() => $_has(4);
  @$pb.TagNumber(5)
  void clearClickThroughRate() => $_clearField(5);

  @$pb.TagNumber(6)
  $pb.PbList<LinkItemMetric> get itemMetrics => $_getList(5);
}

/// Item-level performance metric.
class LinkItemMetric extends $pb.GeneratedMessage {
  factory LinkItemMetric({
    $core.String? linkItemId,
    $core.String? label,
    $core.String? url,
    $core.int? clicks,
    $core.int? conversions,
    $core.double? revenue,
  }) {
    final result = LinkItemMetric._();
    if (linkItemId != null) result.linkItemId = linkItemId;
    if (label != null) result.label = label;
    if (url != null) result.url = url;
    if (clicks != null) result.clicks = clicks;
    if (conversions != null) result.conversions = conversions;
    if (revenue != null) result.revenue = revenue;
    return result;
  }

  LinkItemMetric._();

  factory LinkItemMetric.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      LinkItemMetric()..mergeFromBuffer(data, registry);
  factory LinkItemMetric.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      LinkItemMetric()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'LinkItemMetric',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: LinkItemMetric.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'linkItemId')
    ..aOS(2, _omitFieldNames ? '' : 'label')
    ..aOS(3, _omitFieldNames ? '' : 'url')
    ..aI(4, _omitFieldNames ? '' : 'clicks')
    ..aI(5, _omitFieldNames ? '' : 'conversions')
    ..aD(6, _omitFieldNames ? '' : 'revenue')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LinkItemMetric clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LinkItemMetric copyWith(void Function(LinkItemMetric) updates) =>
      super.copyWith((message) => updates(message as LinkItemMetric))
          as LinkItemMetric;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use LinkItemMetric() / LinkItemMetric.new instead')
  static LinkItemMetric create() => LinkItemMetric._();
  static $pb.GeneratedMessage $_createMessage() => LinkItemMetric._();
  @$core.override
  LinkItemMetric createEmptyInstance() => LinkItemMetric._();
  @$core.pragma('dart2js:noInline')
  static LinkItemMetric getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<LinkItemMetric>(
          LinkItemMetric.$_createMessage);
  static LinkItemMetric? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get linkItemId => $_getSZ(0);
  @$pb.TagNumber(1)
  set linkItemId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasLinkItemId() => $_has(0);
  @$pb.TagNumber(1)
  void clearLinkItemId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get label => $_getSZ(1);
  @$pb.TagNumber(2)
  set label($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasLabel() => $_has(1);
  @$pb.TagNumber(2)
  void clearLabel() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get url => $_getSZ(2);
  @$pb.TagNumber(3)
  set url($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasUrl() => $_has(2);
  @$pb.TagNumber(3)
  void clearUrl() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get clicks => $_getIZ(3);
  @$pb.TagNumber(4)
  set clicks($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasClicks() => $_has(3);
  @$pb.TagNumber(4)
  void clearClicks() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get conversions => $_getIZ(4);
  @$pb.TagNumber(5)
  set conversions($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasConversions() => $_has(4);
  @$pb.TagNumber(5)
  void clearConversions() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.double get revenue => $_getN(5);
  @$pb.TagNumber(6)
  set revenue($core.double value) => $_setDouble(5, value);
  @$pb.TagNumber(6)
  $core.bool hasRevenue() => $_has(5);
  @$pb.TagNumber(6)
  void clearRevenue() => $_clearField(6);
}

/// Canonical MediaKit model.
class MediaKit extends $pb.GeneratedMessage {
  factory MediaKit({
    $core.String? mediaKitId,
    $core.String? workspaceId,
    $core.String? template,
    $core.String? sectionsJson,
    $core.String? brandProfileId,
    $core.String? shareUrl,
    $core.bool? directoryOptIn,
    MediaKitDirectoryStatus? directoryStatus,
    $core.String? directoryProfileJson,
    $1.Timestamp? directoryConsentedAt,
    $1.Timestamp? lastGeneratedAt,
    $core.double? generationCreditsUsed,
    $1.Timestamp? createdAt,
    $1.Timestamp? updatedAt,
  }) {
    final result = MediaKit._();
    if (mediaKitId != null) result.mediaKitId = mediaKitId;
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (template != null) result.template = template;
    if (sectionsJson != null) result.sectionsJson = sectionsJson;
    if (brandProfileId != null) result.brandProfileId = brandProfileId;
    if (shareUrl != null) result.shareUrl = shareUrl;
    if (directoryOptIn != null) result.directoryOptIn = directoryOptIn;
    if (directoryStatus != null) result.directoryStatus = directoryStatus;
    if (directoryProfileJson != null)
      result.directoryProfileJson = directoryProfileJson;
    if (directoryConsentedAt != null)
      result.directoryConsentedAt = directoryConsentedAt;
    if (lastGeneratedAt != null) result.lastGeneratedAt = lastGeneratedAt;
    if (generationCreditsUsed != null)
      result.generationCreditsUsed = generationCreditsUsed;
    if (createdAt != null) result.createdAt = createdAt;
    if (updatedAt != null) result.updatedAt = updatedAt;
    return result;
  }

  MediaKit._();

  factory MediaKit.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      MediaKit()..mergeFromBuffer(data, registry);
  factory MediaKit.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      MediaKit()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MediaKit',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: MediaKit.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'mediaKitId')
    ..aOS(2, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(3, _omitFieldNames ? '' : 'template')
    ..aOS(4, _omitFieldNames ? '' : 'sectionsJson')
    ..aOS(5, _omitFieldNames ? '' : 'brandProfileId')
    ..aOS(6, _omitFieldNames ? '' : 'shareUrl')
    ..aOB(7, _omitFieldNames ? '' : 'directoryOptIn')
    ..aE<MediaKitDirectoryStatus>(8, _omitFieldNames ? '' : 'directoryStatus',
        enumValues: MediaKitDirectoryStatus.values)
    ..aOS(9, _omitFieldNames ? '' : 'directoryProfileJson')
    ..aOM<$1.Timestamp>(10, _omitFieldNames ? '' : 'directoryConsentedAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..aOM<$1.Timestamp>(11, _omitFieldNames ? '' : 'lastGeneratedAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..aD(12, _omitFieldNames ? '' : 'generationCreditsUsed')
    ..aOM<$1.Timestamp>(13, _omitFieldNames ? '' : 'createdAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..aOM<$1.Timestamp>(14, _omitFieldNames ? '' : 'updatedAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MediaKit clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MediaKit copyWith(void Function(MediaKit) updates) =>
      super.copyWith((message) => updates(message as MediaKit)) as MediaKit;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use MediaKit() / MediaKit.new instead')
  static MediaKit create() => MediaKit._();
  static $pb.GeneratedMessage $_createMessage() => MediaKit._();
  @$core.override
  MediaKit createEmptyInstance() => MediaKit._();
  @$core.pragma('dart2js:noInline')
  static MediaKit getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<MediaKit>(MediaKit.$_createMessage);
  static MediaKit? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get mediaKitId => $_getSZ(0);
  @$pb.TagNumber(1)
  set mediaKitId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasMediaKitId() => $_has(0);
  @$pb.TagNumber(1)
  void clearMediaKitId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get workspaceId => $_getSZ(1);
  @$pb.TagNumber(2)
  set workspaceId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasWorkspaceId() => $_has(1);
  @$pb.TagNumber(2)
  void clearWorkspaceId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get template => $_getSZ(2);
  @$pb.TagNumber(3)
  set template($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasTemplate() => $_has(2);
  @$pb.TagNumber(3)
  void clearTemplate() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get sectionsJson => $_getSZ(3);
  @$pb.TagNumber(4)
  set sectionsJson($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasSectionsJson() => $_has(3);
  @$pb.TagNumber(4)
  void clearSectionsJson() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get brandProfileId => $_getSZ(4);
  @$pb.TagNumber(5)
  set brandProfileId($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasBrandProfileId() => $_has(4);
  @$pb.TagNumber(5)
  void clearBrandProfileId() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get shareUrl => $_getSZ(5);
  @$pb.TagNumber(6)
  set shareUrl($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasShareUrl() => $_has(5);
  @$pb.TagNumber(6)
  void clearShareUrl() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.bool get directoryOptIn => $_getBF(6);
  @$pb.TagNumber(7)
  set directoryOptIn($core.bool value) => $_setBool(6, value);
  @$pb.TagNumber(7)
  $core.bool hasDirectoryOptIn() => $_has(6);
  @$pb.TagNumber(7)
  void clearDirectoryOptIn() => $_clearField(7);

  @$pb.TagNumber(8)
  MediaKitDirectoryStatus get directoryStatus => $_getN(7);
  @$pb.TagNumber(8)
  set directoryStatus(MediaKitDirectoryStatus value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasDirectoryStatus() => $_has(7);
  @$pb.TagNumber(8)
  void clearDirectoryStatus() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get directoryProfileJson => $_getSZ(8);
  @$pb.TagNumber(9)
  set directoryProfileJson($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasDirectoryProfileJson() => $_has(8);
  @$pb.TagNumber(9)
  void clearDirectoryProfileJson() => $_clearField(9);

  @$pb.TagNumber(10)
  $1.Timestamp get directoryConsentedAt => $_getN(9);
  @$pb.TagNumber(10)
  set directoryConsentedAt($1.Timestamp value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasDirectoryConsentedAt() => $_has(9);
  @$pb.TagNumber(10)
  void clearDirectoryConsentedAt() => $_clearField(10);
  @$pb.TagNumber(10)
  $1.Timestamp ensureDirectoryConsentedAt() => $_ensure(9);

  @$pb.TagNumber(11)
  $1.Timestamp get lastGeneratedAt => $_getN(10);
  @$pb.TagNumber(11)
  set lastGeneratedAt($1.Timestamp value) => $_setField(11, value);
  @$pb.TagNumber(11)
  $core.bool hasLastGeneratedAt() => $_has(10);
  @$pb.TagNumber(11)
  void clearLastGeneratedAt() => $_clearField(11);
  @$pb.TagNumber(11)
  $1.Timestamp ensureLastGeneratedAt() => $_ensure(10);

  @$pb.TagNumber(12)
  $core.double get generationCreditsUsed => $_getN(11);
  @$pb.TagNumber(12)
  set generationCreditsUsed($core.double value) => $_setDouble(11, value);
  @$pb.TagNumber(12)
  $core.bool hasGenerationCreditsUsed() => $_has(11);
  @$pb.TagNumber(12)
  void clearGenerationCreditsUsed() => $_clearField(12);

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

/// Canonical RateCard model.
class RateCard extends $pb.GeneratedMessage {
  factory RateCard({
    $core.String? rateCardId,
    $core.String? workspaceId,
    $core.String? currency,
    $core.String? customNote,
    $1.Timestamp? aiSuggestedAt,
    $core.Iterable<RateCardItem>? items,
    $1.Timestamp? createdAt,
    $1.Timestamp? updatedAt,
  }) {
    final result = RateCard._();
    if (rateCardId != null) result.rateCardId = rateCardId;
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (currency != null) result.currency = currency;
    if (customNote != null) result.customNote = customNote;
    if (aiSuggestedAt != null) result.aiSuggestedAt = aiSuggestedAt;
    if (items != null) result.items.addAll(items);
    if (createdAt != null) result.createdAt = createdAt;
    if (updatedAt != null) result.updatedAt = updatedAt;
    return result;
  }

  RateCard._();

  factory RateCard.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RateCard()..mergeFromBuffer(data, registry);
  factory RateCard.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RateCard()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RateCard',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: RateCard.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'rateCardId')
    ..aOS(2, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(3, _omitFieldNames ? '' : 'currency')
    ..aOS(4, _omitFieldNames ? '' : 'customNote')
    ..aOM<$1.Timestamp>(5, _omitFieldNames ? '' : 'aiSuggestedAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..pPM<RateCardItem>(6, _omitFieldNames ? '' : 'items',
        subBuilder: RateCardItem.$_createMessage)
    ..aOM<$1.Timestamp>(7, _omitFieldNames ? '' : 'createdAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..aOM<$1.Timestamp>(8, _omitFieldNames ? '' : 'updatedAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RateCard clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RateCard copyWith(void Function(RateCard) updates) =>
      super.copyWith((message) => updates(message as RateCard)) as RateCard;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use RateCard() / RateCard.new instead')
  static RateCard create() => RateCard._();
  static $pb.GeneratedMessage $_createMessage() => RateCard._();
  @$core.override
  RateCard createEmptyInstance() => RateCard._();
  @$core.pragma('dart2js:noInline')
  static RateCard getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RateCard>(RateCard.$_createMessage);
  static RateCard? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get rateCardId => $_getSZ(0);
  @$pb.TagNumber(1)
  set rateCardId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRateCardId() => $_has(0);
  @$pb.TagNumber(1)
  void clearRateCardId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get workspaceId => $_getSZ(1);
  @$pb.TagNumber(2)
  set workspaceId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasWorkspaceId() => $_has(1);
  @$pb.TagNumber(2)
  void clearWorkspaceId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get currency => $_getSZ(2);
  @$pb.TagNumber(3)
  set currency($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasCurrency() => $_has(2);
  @$pb.TagNumber(3)
  void clearCurrency() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get customNote => $_getSZ(3);
  @$pb.TagNumber(4)
  set customNote($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasCustomNote() => $_has(3);
  @$pb.TagNumber(4)
  void clearCustomNote() => $_clearField(4);

  @$pb.TagNumber(5)
  $1.Timestamp get aiSuggestedAt => $_getN(4);
  @$pb.TagNumber(5)
  set aiSuggestedAt($1.Timestamp value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasAiSuggestedAt() => $_has(4);
  @$pb.TagNumber(5)
  void clearAiSuggestedAt() => $_clearField(5);
  @$pb.TagNumber(5)
  $1.Timestamp ensureAiSuggestedAt() => $_ensure(4);

  @$pb.TagNumber(6)
  $pb.PbList<RateCardItem> get items => $_getList(5);

  @$pb.TagNumber(7)
  $1.Timestamp get createdAt => $_getN(6);
  @$pb.TagNumber(7)
  set createdAt($1.Timestamp value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasCreatedAt() => $_has(6);
  @$pb.TagNumber(7)
  void clearCreatedAt() => $_clearField(7);
  @$pb.TagNumber(7)
  $1.Timestamp ensureCreatedAt() => $_ensure(6);

  @$pb.TagNumber(8)
  $1.Timestamp get updatedAt => $_getN(7);
  @$pb.TagNumber(8)
  set updatedAt($1.Timestamp value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasUpdatedAt() => $_has(7);
  @$pb.TagNumber(8)
  void clearUpdatedAt() => $_clearField(8);
  @$pb.TagNumber(8)
  $1.Timestamp ensureUpdatedAt() => $_ensure(7);
}

/// Canonical RateCardItem model.
class RateCardItem extends $pb.GeneratedMessage {
  factory RateCardItem({
    $core.String? itemId,
    $core.String? rateCardId,
    $core.String? workspaceId,
    $core.String? serviceType,
    $core.double? priceMin,
    $core.double? priceMax,
    $core.double? aiSuggestedPrice,
    $core.String? description,
    $core.String? deliveryTime,
    $core.int? position,
    $1.Timestamp? createdAt,
    $1.Timestamp? updatedAt,
  }) {
    final result = RateCardItem._();
    if (itemId != null) result.itemId = itemId;
    if (rateCardId != null) result.rateCardId = rateCardId;
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (serviceType != null) result.serviceType = serviceType;
    if (priceMin != null) result.priceMin = priceMin;
    if (priceMax != null) result.priceMax = priceMax;
    if (aiSuggestedPrice != null) result.aiSuggestedPrice = aiSuggestedPrice;
    if (description != null) result.description = description;
    if (deliveryTime != null) result.deliveryTime = deliveryTime;
    if (position != null) result.position = position;
    if (createdAt != null) result.createdAt = createdAt;
    if (updatedAt != null) result.updatedAt = updatedAt;
    return result;
  }

  RateCardItem._();

  factory RateCardItem.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RateCardItem()..mergeFromBuffer(data, registry);
  factory RateCardItem.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RateCardItem()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RateCardItem',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: RateCardItem.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'itemId')
    ..aOS(2, _omitFieldNames ? '' : 'rateCardId')
    ..aOS(3, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(4, _omitFieldNames ? '' : 'serviceType')
    ..aD(5, _omitFieldNames ? '' : 'priceMin')
    ..aD(6, _omitFieldNames ? '' : 'priceMax')
    ..aD(7, _omitFieldNames ? '' : 'aiSuggestedPrice')
    ..aOS(8, _omitFieldNames ? '' : 'description')
    ..aOS(9, _omitFieldNames ? '' : 'deliveryTime')
    ..aI(10, _omitFieldNames ? '' : 'position')
    ..aOM<$1.Timestamp>(11, _omitFieldNames ? '' : 'createdAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..aOM<$1.Timestamp>(12, _omitFieldNames ? '' : 'updatedAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RateCardItem clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RateCardItem copyWith(void Function(RateCardItem) updates) =>
      super.copyWith((message) => updates(message as RateCardItem))
          as RateCardItem;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use RateCardItem() / RateCardItem.new instead')
  static RateCardItem create() => RateCardItem._();
  static $pb.GeneratedMessage $_createMessage() => RateCardItem._();
  @$core.override
  RateCardItem createEmptyInstance() => RateCardItem._();
  @$core.pragma('dart2js:noInline')
  static RateCardItem getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<RateCardItem>(
          RateCardItem.$_createMessage);
  static RateCardItem? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get itemId => $_getSZ(0);
  @$pb.TagNumber(1)
  set itemId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasItemId() => $_has(0);
  @$pb.TagNumber(1)
  void clearItemId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get rateCardId => $_getSZ(1);
  @$pb.TagNumber(2)
  set rateCardId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasRateCardId() => $_has(1);
  @$pb.TagNumber(2)
  void clearRateCardId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get workspaceId => $_getSZ(2);
  @$pb.TagNumber(3)
  set workspaceId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasWorkspaceId() => $_has(2);
  @$pb.TagNumber(3)
  void clearWorkspaceId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get serviceType => $_getSZ(3);
  @$pb.TagNumber(4)
  set serviceType($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasServiceType() => $_has(3);
  @$pb.TagNumber(4)
  void clearServiceType() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.double get priceMin => $_getN(4);
  @$pb.TagNumber(5)
  set priceMin($core.double value) => $_setDouble(4, value);
  @$pb.TagNumber(5)
  $core.bool hasPriceMin() => $_has(4);
  @$pb.TagNumber(5)
  void clearPriceMin() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.double get priceMax => $_getN(5);
  @$pb.TagNumber(6)
  set priceMax($core.double value) => $_setDouble(5, value);
  @$pb.TagNumber(6)
  $core.bool hasPriceMax() => $_has(5);
  @$pb.TagNumber(6)
  void clearPriceMax() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.double get aiSuggestedPrice => $_getN(6);
  @$pb.TagNumber(7)
  set aiSuggestedPrice($core.double value) => $_setDouble(6, value);
  @$pb.TagNumber(7)
  $core.bool hasAiSuggestedPrice() => $_has(6);
  @$pb.TagNumber(7)
  void clearAiSuggestedPrice() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get description => $_getSZ(7);
  @$pb.TagNumber(8)
  set description($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasDescription() => $_has(7);
  @$pb.TagNumber(8)
  void clearDescription() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get deliveryTime => $_getSZ(8);
  @$pb.TagNumber(9)
  set deliveryTime($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasDeliveryTime() => $_has(8);
  @$pb.TagNumber(9)
  void clearDeliveryTime() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.int get position => $_getIZ(9);
  @$pb.TagNumber(10)
  set position($core.int value) => $_setSignedInt32(9, value);
  @$pb.TagNumber(10)
  $core.bool hasPosition() => $_has(9);
  @$pb.TagNumber(10)
  void clearPosition() => $_clearField(10);

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
  $1.Timestamp get updatedAt => $_getN(11);
  @$pb.TagNumber(12)
  set updatedAt($1.Timestamp value) => $_setField(12, value);
  @$pb.TagNumber(12)
  $core.bool hasUpdatedAt() => $_has(11);
  @$pb.TagNumber(12)
  void clearUpdatedAt() => $_clearField(12);
  @$pb.TagNumber(12)
  $1.Timestamp ensureUpdatedAt() => $_ensure(11);
}

/// Canonical BrandDeal model.
class BrandDeal extends $pb.GeneratedMessage {
  factory BrandDeal({
    $core.String? dealId,
    $core.String? workspaceId,
    $core.String? brandName,
    $core.String? contactEmail,
    BrandDealType? dealType,
    $core.double? value,
    $core.String? currency,
    BrandDealStatus? status,
    $core.String? deadline,
    $core.String? deliverables,
    $core.Iterable<$core.String>? contractEvidenceIds,
    $core.String? inquiryThreadId,
    $core.String? notes,
    $1.Timestamp? createdAt,
    $1.Timestamp? updatedAt,
  }) {
    final result = BrandDeal._();
    if (dealId != null) result.dealId = dealId;
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (brandName != null) result.brandName = brandName;
    if (contactEmail != null) result.contactEmail = contactEmail;
    if (dealType != null) result.dealType = dealType;
    if (value != null) result.value = value;
    if (currency != null) result.currency = currency;
    if (status != null) result.status = status;
    if (deadline != null) result.deadline = deadline;
    if (deliverables != null) result.deliverables = deliverables;
    if (contractEvidenceIds != null)
      result.contractEvidenceIds.addAll(contractEvidenceIds);
    if (inquiryThreadId != null) result.inquiryThreadId = inquiryThreadId;
    if (notes != null) result.notes = notes;
    if (createdAt != null) result.createdAt = createdAt;
    if (updatedAt != null) result.updatedAt = updatedAt;
    return result;
  }

  BrandDeal._();

  factory BrandDeal.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      BrandDeal()..mergeFromBuffer(data, registry);
  factory BrandDeal.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      BrandDeal()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'BrandDeal',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: BrandDeal.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'dealId')
    ..aOS(2, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(3, _omitFieldNames ? '' : 'brandName')
    ..aOS(4, _omitFieldNames ? '' : 'contactEmail')
    ..aE<BrandDealType>(5, _omitFieldNames ? '' : 'dealType',
        enumValues: BrandDealType.values)
    ..aD(6, _omitFieldNames ? '' : 'value')
    ..aOS(7, _omitFieldNames ? '' : 'currency')
    ..aE<BrandDealStatus>(8, _omitFieldNames ? '' : 'status',
        enumValues: BrandDealStatus.values)
    ..aOS(9, _omitFieldNames ? '' : 'deadline')
    ..aOS(10, _omitFieldNames ? '' : 'deliverables')
    ..pPS(11, _omitFieldNames ? '' : 'contractEvidenceIds')
    ..aOS(12, _omitFieldNames ? '' : 'inquiryThreadId')
    ..aOS(13, _omitFieldNames ? '' : 'notes')
    ..aOM<$1.Timestamp>(14, _omitFieldNames ? '' : 'createdAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..aOM<$1.Timestamp>(15, _omitFieldNames ? '' : 'updatedAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BrandDeal clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BrandDeal copyWith(void Function(BrandDeal) updates) =>
      super.copyWith((message) => updates(message as BrandDeal)) as BrandDeal;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use BrandDeal() / BrandDeal.new instead')
  static BrandDeal create() => BrandDeal._();
  static $pb.GeneratedMessage $_createMessage() => BrandDeal._();
  @$core.override
  BrandDeal createEmptyInstance() => BrandDeal._();
  @$core.pragma('dart2js:noInline')
  static BrandDeal getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<BrandDeal>(BrandDeal.$_createMessage);
  static BrandDeal? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get dealId => $_getSZ(0);
  @$pb.TagNumber(1)
  set dealId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasDealId() => $_has(0);
  @$pb.TagNumber(1)
  void clearDealId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get workspaceId => $_getSZ(1);
  @$pb.TagNumber(2)
  set workspaceId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasWorkspaceId() => $_has(1);
  @$pb.TagNumber(2)
  void clearWorkspaceId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get brandName => $_getSZ(2);
  @$pb.TagNumber(3)
  set brandName($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasBrandName() => $_has(2);
  @$pb.TagNumber(3)
  void clearBrandName() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get contactEmail => $_getSZ(3);
  @$pb.TagNumber(4)
  set contactEmail($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasContactEmail() => $_has(3);
  @$pb.TagNumber(4)
  void clearContactEmail() => $_clearField(4);

  @$pb.TagNumber(5)
  BrandDealType get dealType => $_getN(4);
  @$pb.TagNumber(5)
  set dealType(BrandDealType value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasDealType() => $_has(4);
  @$pb.TagNumber(5)
  void clearDealType() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.double get value => $_getN(5);
  @$pb.TagNumber(6)
  set value($core.double value) => $_setDouble(5, value);
  @$pb.TagNumber(6)
  $core.bool hasValue() => $_has(5);
  @$pb.TagNumber(6)
  void clearValue() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get currency => $_getSZ(6);
  @$pb.TagNumber(7)
  set currency($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasCurrency() => $_has(6);
  @$pb.TagNumber(7)
  void clearCurrency() => $_clearField(7);

  @$pb.TagNumber(8)
  BrandDealStatus get status => $_getN(7);
  @$pb.TagNumber(8)
  set status(BrandDealStatus value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasStatus() => $_has(7);
  @$pb.TagNumber(8)
  void clearStatus() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get deadline => $_getSZ(8);
  @$pb.TagNumber(9)
  set deadline($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasDeadline() => $_has(8);
  @$pb.TagNumber(9)
  void clearDeadline() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.String get deliverables => $_getSZ(9);
  @$pb.TagNumber(10)
  set deliverables($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasDeliverables() => $_has(9);
  @$pb.TagNumber(10)
  void clearDeliverables() => $_clearField(10);

  @$pb.TagNumber(11)
  $pb.PbList<$core.String> get contractEvidenceIds => $_getList(10);

  @$pb.TagNumber(12)
  $core.String get inquiryThreadId => $_getSZ(11);
  @$pb.TagNumber(12)
  set inquiryThreadId($core.String value) => $_setString(11, value);
  @$pb.TagNumber(12)
  $core.bool hasInquiryThreadId() => $_has(11);
  @$pb.TagNumber(12)
  void clearInquiryThreadId() => $_clearField(12);

  @$pb.TagNumber(13)
  $core.String get notes => $_getSZ(12);
  @$pb.TagNumber(13)
  set notes($core.String value) => $_setString(12, value);
  @$pb.TagNumber(13)
  $core.bool hasNotes() => $_has(12);
  @$pb.TagNumber(13)
  void clearNotes() => $_clearField(13);

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

/// Pipeline summary stats for brand deals.
class BrandDealPipelineStats extends $pb.GeneratedMessage {
  factory BrandDealPipelineStats({
    $core.String? workspaceId,
    $core.int? negotiatingCount,
    $core.int? agreedCount,
    $core.int? inProgressCount,
    $core.int? deliveredCount,
    $core.int? paidCount,
    $core.int? completedCount,
    $core.int? cancelledCount,
    $core.double? totalActiveValue,
    $core.double? totalCompletedValue,
    $core.String? currency,
  }) {
    final result = BrandDealPipelineStats._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (negotiatingCount != null) result.negotiatingCount = negotiatingCount;
    if (agreedCount != null) result.agreedCount = agreedCount;
    if (inProgressCount != null) result.inProgressCount = inProgressCount;
    if (deliveredCount != null) result.deliveredCount = deliveredCount;
    if (paidCount != null) result.paidCount = paidCount;
    if (completedCount != null) result.completedCount = completedCount;
    if (cancelledCount != null) result.cancelledCount = cancelledCount;
    if (totalActiveValue != null) result.totalActiveValue = totalActiveValue;
    if (totalCompletedValue != null)
      result.totalCompletedValue = totalCompletedValue;
    if (currency != null) result.currency = currency;
    return result;
  }

  BrandDealPipelineStats._();

  factory BrandDealPipelineStats.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      BrandDealPipelineStats()..mergeFromBuffer(data, registry);
  factory BrandDealPipelineStats.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      BrandDealPipelineStats()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'BrandDealPipelineStats',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: BrandDealPipelineStats.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aI(2, _omitFieldNames ? '' : 'negotiatingCount')
    ..aI(3, _omitFieldNames ? '' : 'agreedCount')
    ..aI(4, _omitFieldNames ? '' : 'inProgressCount')
    ..aI(5, _omitFieldNames ? '' : 'deliveredCount')
    ..aI(6, _omitFieldNames ? '' : 'paidCount')
    ..aI(7, _omitFieldNames ? '' : 'completedCount')
    ..aI(8, _omitFieldNames ? '' : 'cancelledCount')
    ..aD(9, _omitFieldNames ? '' : 'totalActiveValue')
    ..aD(10, _omitFieldNames ? '' : 'totalCompletedValue')
    ..aOS(11, _omitFieldNames ? '' : 'currency')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BrandDealPipelineStats clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BrandDealPipelineStats copyWith(
          void Function(BrandDealPipelineStats) updates) =>
      super.copyWith((message) => updates(message as BrandDealPipelineStats))
          as BrandDealPipelineStats;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use BrandDealPipelineStats() / BrandDealPipelineStats.new instead')
  static BrandDealPipelineStats create() => BrandDealPipelineStats._();
  static $pb.GeneratedMessage $_createMessage() => BrandDealPipelineStats._();
  @$core.override
  BrandDealPipelineStats createEmptyInstance() => BrandDealPipelineStats._();
  @$core.pragma('dart2js:noInline')
  static BrandDealPipelineStats getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<BrandDealPipelineStats>(
          BrandDealPipelineStats.$_createMessage);
  static BrandDealPipelineStats? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get negotiatingCount => $_getIZ(1);
  @$pb.TagNumber(2)
  set negotiatingCount($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasNegotiatingCount() => $_has(1);
  @$pb.TagNumber(2)
  void clearNegotiatingCount() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get agreedCount => $_getIZ(2);
  @$pb.TagNumber(3)
  set agreedCount($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasAgreedCount() => $_has(2);
  @$pb.TagNumber(3)
  void clearAgreedCount() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get inProgressCount => $_getIZ(3);
  @$pb.TagNumber(4)
  set inProgressCount($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasInProgressCount() => $_has(3);
  @$pb.TagNumber(4)
  void clearInProgressCount() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get deliveredCount => $_getIZ(4);
  @$pb.TagNumber(5)
  set deliveredCount($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasDeliveredCount() => $_has(4);
  @$pb.TagNumber(5)
  void clearDeliveredCount() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.int get paidCount => $_getIZ(5);
  @$pb.TagNumber(6)
  set paidCount($core.int value) => $_setSignedInt32(5, value);
  @$pb.TagNumber(6)
  $core.bool hasPaidCount() => $_has(5);
  @$pb.TagNumber(6)
  void clearPaidCount() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.int get completedCount => $_getIZ(6);
  @$pb.TagNumber(7)
  set completedCount($core.int value) => $_setSignedInt32(6, value);
  @$pb.TagNumber(7)
  $core.bool hasCompletedCount() => $_has(6);
  @$pb.TagNumber(7)
  void clearCompletedCount() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.int get cancelledCount => $_getIZ(7);
  @$pb.TagNumber(8)
  set cancelledCount($core.int value) => $_setSignedInt32(7, value);
  @$pb.TagNumber(8)
  $core.bool hasCancelledCount() => $_has(7);
  @$pb.TagNumber(8)
  void clearCancelledCount() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.double get totalActiveValue => $_getN(8);
  @$pb.TagNumber(9)
  set totalActiveValue($core.double value) => $_setDouble(8, value);
  @$pb.TagNumber(9)
  $core.bool hasTotalActiveValue() => $_has(8);
  @$pb.TagNumber(9)
  void clearTotalActiveValue() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.double get totalCompletedValue => $_getN(9);
  @$pb.TagNumber(10)
  set totalCompletedValue($core.double value) => $_setDouble(9, value);
  @$pb.TagNumber(10)
  $core.bool hasTotalCompletedValue() => $_has(9);
  @$pb.TagNumber(10)
  void clearTotalCompletedValue() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.String get currency => $_getSZ(10);
  @$pb.TagNumber(11)
  set currency($core.String value) => $_setString(10, value);
  @$pb.TagNumber(11)
  $core.bool hasCurrency() => $_has(10);
  @$pb.TagNumber(11)
  void clearCurrency() => $_clearField(11);
}

/// Content ROI metric item with Zero-view RPM undefined representation.
class ContentROIMetric extends $pb.GeneratedMessage {
  factory ContentROIMetric({
    $core.String? contentId,
    $core.String? title,
    $core.String? platform,
    $fixnum.Int64? views,
    $fixnum.Int64? engagement,
    $fixnum.Int64? linkClicks,
    $fixnum.Int64? ordersAttributed,
    $core.double? revenueAttributed,
    $core.double? costToProduce,
    $core.double? roiPercentage,
    $core.double? rpm,
    $core.bool? rpmIsUndefined,
    $core.String? productionMode,
    $core.bool? isDerivative,
    $core.String? sourceContentId,
    $core.int? derivativeCount,
    $core.double? derivativeTotalRevenue,
    $1.Timestamp? publishedAt,
  }) {
    final result = ContentROIMetric._();
    if (contentId != null) result.contentId = contentId;
    if (title != null) result.title = title;
    if (platform != null) result.platform = platform;
    if (views != null) result.views = views;
    if (engagement != null) result.engagement = engagement;
    if (linkClicks != null) result.linkClicks = linkClicks;
    if (ordersAttributed != null) result.ordersAttributed = ordersAttributed;
    if (revenueAttributed != null) result.revenueAttributed = revenueAttributed;
    if (costToProduce != null) result.costToProduce = costToProduce;
    if (roiPercentage != null) result.roiPercentage = roiPercentage;
    if (rpm != null) result.rpm = rpm;
    if (rpmIsUndefined != null) result.rpmIsUndefined = rpmIsUndefined;
    if (productionMode != null) result.productionMode = productionMode;
    if (isDerivative != null) result.isDerivative = isDerivative;
    if (sourceContentId != null) result.sourceContentId = sourceContentId;
    if (derivativeCount != null) result.derivativeCount = derivativeCount;
    if (derivativeTotalRevenue != null)
      result.derivativeTotalRevenue = derivativeTotalRevenue;
    if (publishedAt != null) result.publishedAt = publishedAt;
    return result;
  }

  ContentROIMetric._();

  factory ContentROIMetric.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ContentROIMetric()..mergeFromBuffer(data, registry);
  factory ContentROIMetric.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ContentROIMetric()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ContentROIMetric',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: ContentROIMetric.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'contentId')
    ..aOS(2, _omitFieldNames ? '' : 'title')
    ..aOS(3, _omitFieldNames ? '' : 'platform')
    ..aInt64(4, _omitFieldNames ? '' : 'views')
    ..aInt64(5, _omitFieldNames ? '' : 'engagement')
    ..aInt64(6, _omitFieldNames ? '' : 'linkClicks')
    ..aInt64(7, _omitFieldNames ? '' : 'ordersAttributed')
    ..aD(8, _omitFieldNames ? '' : 'revenueAttributed')
    ..aD(9, _omitFieldNames ? '' : 'costToProduce')
    ..aD(10, _omitFieldNames ? '' : 'roiPercentage')
    ..aD(11, _omitFieldNames ? '' : 'rpm')
    ..aOB(12, _omitFieldNames ? '' : 'rpmIsUndefined')
    ..aOS(13, _omitFieldNames ? '' : 'productionMode')
    ..aOB(14, _omitFieldNames ? '' : 'isDerivative')
    ..aOS(15, _omitFieldNames ? '' : 'sourceContentId')
    ..aI(16, _omitFieldNames ? '' : 'derivativeCount')
    ..aD(17, _omitFieldNames ? '' : 'derivativeTotalRevenue')
    ..aOM<$1.Timestamp>(18, _omitFieldNames ? '' : 'publishedAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ContentROIMetric clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ContentROIMetric copyWith(void Function(ContentROIMetric) updates) =>
      super.copyWith((message) => updates(message as ContentROIMetric))
          as ContentROIMetric;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ContentROIMetric() / ContentROIMetric.new instead')
  static ContentROIMetric create() => ContentROIMetric._();
  static $pb.GeneratedMessage $_createMessage() => ContentROIMetric._();
  @$core.override
  ContentROIMetric createEmptyInstance() => ContentROIMetric._();
  @$core.pragma('dart2js:noInline')
  static ContentROIMetric getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ContentROIMetric>(
          ContentROIMetric.$_createMessage);
  static ContentROIMetric? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get contentId => $_getSZ(0);
  @$pb.TagNumber(1)
  set contentId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasContentId() => $_has(0);
  @$pb.TagNumber(1)
  void clearContentId() => $_clearField(1);

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
  $fixnum.Int64 get views => $_getI64(3);
  @$pb.TagNumber(4)
  set views($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasViews() => $_has(3);
  @$pb.TagNumber(4)
  void clearViews() => $_clearField(4);

  @$pb.TagNumber(5)
  $fixnum.Int64 get engagement => $_getI64(4);
  @$pb.TagNumber(5)
  set engagement($fixnum.Int64 value) => $_setInt64(4, value);
  @$pb.TagNumber(5)
  $core.bool hasEngagement() => $_has(4);
  @$pb.TagNumber(5)
  void clearEngagement() => $_clearField(5);

  @$pb.TagNumber(6)
  $fixnum.Int64 get linkClicks => $_getI64(5);
  @$pb.TagNumber(6)
  set linkClicks($fixnum.Int64 value) => $_setInt64(5, value);
  @$pb.TagNumber(6)
  $core.bool hasLinkClicks() => $_has(5);
  @$pb.TagNumber(6)
  void clearLinkClicks() => $_clearField(6);

  @$pb.TagNumber(7)
  $fixnum.Int64 get ordersAttributed => $_getI64(6);
  @$pb.TagNumber(7)
  set ordersAttributed($fixnum.Int64 value) => $_setInt64(6, value);
  @$pb.TagNumber(7)
  $core.bool hasOrdersAttributed() => $_has(6);
  @$pb.TagNumber(7)
  void clearOrdersAttributed() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.double get revenueAttributed => $_getN(7);
  @$pb.TagNumber(8)
  set revenueAttributed($core.double value) => $_setDouble(7, value);
  @$pb.TagNumber(8)
  $core.bool hasRevenueAttributed() => $_has(7);
  @$pb.TagNumber(8)
  void clearRevenueAttributed() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.double get costToProduce => $_getN(8);
  @$pb.TagNumber(9)
  set costToProduce($core.double value) => $_setDouble(8, value);
  @$pb.TagNumber(9)
  $core.bool hasCostToProduce() => $_has(8);
  @$pb.TagNumber(9)
  void clearCostToProduce() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.double get roiPercentage => $_getN(9);
  @$pb.TagNumber(10)
  set roiPercentage($core.double value) => $_setDouble(9, value);
  @$pb.TagNumber(10)
  $core.bool hasRoiPercentage() => $_has(9);
  @$pb.TagNumber(10)
  void clearRoiPercentage() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.double get rpm => $_getN(10);
  @$pb.TagNumber(11)
  set rpm($core.double value) => $_setDouble(10, value);
  @$pb.TagNumber(11)
  $core.bool hasRpm() => $_has(10);
  @$pb.TagNumber(11)
  void clearRpm() => $_clearField(11);

  /// Crucial: Acceptance Target 3 - Zero-view RPM undefined.
  @$pb.TagNumber(12)
  $core.bool get rpmIsUndefined => $_getBF(11);
  @$pb.TagNumber(12)
  set rpmIsUndefined($core.bool value) => $_setBool(11, value);
  @$pb.TagNumber(12)
  $core.bool hasRpmIsUndefined() => $_has(11);
  @$pb.TagNumber(12)
  void clearRpmIsUndefined() => $_clearField(12);

  @$pb.TagNumber(13)
  $core.String get productionMode => $_getSZ(12);
  @$pb.TagNumber(13)
  set productionMode($core.String value) => $_setString(12, value);
  @$pb.TagNumber(13)
  $core.bool hasProductionMode() => $_has(12);
  @$pb.TagNumber(13)
  void clearProductionMode() => $_clearField(13);

  @$pb.TagNumber(14)
  $core.bool get isDerivative => $_getBF(13);
  @$pb.TagNumber(14)
  set isDerivative($core.bool value) => $_setBool(13, value);
  @$pb.TagNumber(14)
  $core.bool hasIsDerivative() => $_has(13);
  @$pb.TagNumber(14)
  void clearIsDerivative() => $_clearField(14);

  @$pb.TagNumber(15)
  $core.String get sourceContentId => $_getSZ(14);
  @$pb.TagNumber(15)
  set sourceContentId($core.String value) => $_setString(14, value);
  @$pb.TagNumber(15)
  $core.bool hasSourceContentId() => $_has(14);
  @$pb.TagNumber(15)
  void clearSourceContentId() => $_clearField(15);

  @$pb.TagNumber(16)
  $core.int get derivativeCount => $_getIZ(15);
  @$pb.TagNumber(16)
  set derivativeCount($core.int value) => $_setSignedInt32(15, value);
  @$pb.TagNumber(16)
  $core.bool hasDerivativeCount() => $_has(15);
  @$pb.TagNumber(16)
  void clearDerivativeCount() => $_clearField(16);

  @$pb.TagNumber(17)
  $core.double get derivativeTotalRevenue => $_getN(16);
  @$pb.TagNumber(17)
  set derivativeTotalRevenue($core.double value) => $_setDouble(16, value);
  @$pb.TagNumber(17)
  $core.bool hasDerivativeTotalRevenue() => $_has(16);
  @$pb.TagNumber(17)
  void clearDerivativeTotalRevenue() => $_clearField(17);

  @$pb.TagNumber(18)
  $1.Timestamp get publishedAt => $_getN(17);
  @$pb.TagNumber(18)
  set publishedAt($1.Timestamp value) => $_setField(18, value);
  @$pb.TagNumber(18)
  $core.bool hasPublishedAt() => $_has(17);
  @$pb.TagNumber(18)
  void clearPublishedAt() => $_clearField(18);
  @$pb.TagNumber(18)
  $1.Timestamp ensurePublishedAt() => $_ensure(17);
}

/// RPM trend point over time.
class RPMTrendPoint extends $pb.GeneratedMessage {
  factory RPMTrendPoint({
    $core.String? periodLabel,
    $core.String? platform,
    $core.double? rpm,
    $core.bool? rpmIsUndefined,
    $fixnum.Int64? views,
    $core.double? revenue,
    $core.double? changePercent,
    $core.bool? dropAlertTriggered,
  }) {
    final result = RPMTrendPoint._();
    if (periodLabel != null) result.periodLabel = periodLabel;
    if (platform != null) result.platform = platform;
    if (rpm != null) result.rpm = rpm;
    if (rpmIsUndefined != null) result.rpmIsUndefined = rpmIsUndefined;
    if (views != null) result.views = views;
    if (revenue != null) result.revenue = revenue;
    if (changePercent != null) result.changePercent = changePercent;
    if (dropAlertTriggered != null)
      result.dropAlertTriggered = dropAlertTriggered;
    return result;
  }

  RPMTrendPoint._();

  factory RPMTrendPoint.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RPMTrendPoint()..mergeFromBuffer(data, registry);
  factory RPMTrendPoint.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RPMTrendPoint()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RPMTrendPoint',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: RPMTrendPoint.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'periodLabel')
    ..aOS(2, _omitFieldNames ? '' : 'platform')
    ..aD(3, _omitFieldNames ? '' : 'rpm')
    ..aOB(4, _omitFieldNames ? '' : 'rpmIsUndefined')
    ..aInt64(5, _omitFieldNames ? '' : 'views')
    ..aD(6, _omitFieldNames ? '' : 'revenue')
    ..aD(7, _omitFieldNames ? '' : 'changePercent')
    ..aOB(8, _omitFieldNames ? '' : 'dropAlertTriggered')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RPMTrendPoint clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RPMTrendPoint copyWith(void Function(RPMTrendPoint) updates) =>
      super.copyWith((message) => updates(message as RPMTrendPoint))
          as RPMTrendPoint;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use RPMTrendPoint() / RPMTrendPoint.new instead')
  static RPMTrendPoint create() => RPMTrendPoint._();
  static $pb.GeneratedMessage $_createMessage() => RPMTrendPoint._();
  @$core.override
  RPMTrendPoint createEmptyInstance() => RPMTrendPoint._();
  @$core.pragma('dart2js:noInline')
  static RPMTrendPoint getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<RPMTrendPoint>(
          RPMTrendPoint.$_createMessage);
  static RPMTrendPoint? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get periodLabel => $_getSZ(0);
  @$pb.TagNumber(1)
  set periodLabel($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPeriodLabel() => $_has(0);
  @$pb.TagNumber(1)
  void clearPeriodLabel() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get platform => $_getSZ(1);
  @$pb.TagNumber(2)
  set platform($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPlatform() => $_has(1);
  @$pb.TagNumber(2)
  void clearPlatform() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.double get rpm => $_getN(2);
  @$pb.TagNumber(3)
  set rpm($core.double value) => $_setDouble(2, value);
  @$pb.TagNumber(3)
  $core.bool hasRpm() => $_has(2);
  @$pb.TagNumber(3)
  void clearRpm() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.bool get rpmIsUndefined => $_getBF(3);
  @$pb.TagNumber(4)
  set rpmIsUndefined($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(4)
  $core.bool hasRpmIsUndefined() => $_has(3);
  @$pb.TagNumber(4)
  void clearRpmIsUndefined() => $_clearField(4);

  @$pb.TagNumber(5)
  $fixnum.Int64 get views => $_getI64(4);
  @$pb.TagNumber(5)
  set views($fixnum.Int64 value) => $_setInt64(4, value);
  @$pb.TagNumber(5)
  $core.bool hasViews() => $_has(4);
  @$pb.TagNumber(5)
  void clearViews() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.double get revenue => $_getN(5);
  @$pb.TagNumber(6)
  set revenue($core.double value) => $_setDouble(5, value);
  @$pb.TagNumber(6)
  $core.bool hasRevenue() => $_has(5);
  @$pb.TagNumber(6)
  void clearRevenue() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.double get changePercent => $_getN(6);
  @$pb.TagNumber(7)
  set changePercent($core.double value) => $_setDouble(6, value);
  @$pb.TagNumber(7)
  $core.bool hasChangePercent() => $_has(6);
  @$pb.TagNumber(7)
  void clearChangePercent() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.bool get dropAlertTriggered => $_getBF(7);
  @$pb.TagNumber(8)
  set dropAlertTriggered($core.bool value) => $_setBool(7, value);
  @$pb.TagNumber(8)
  $core.bool hasDropAlertTriggered() => $_has(7);
  @$pb.TagNumber(8)
  void clearDropAlertTriggered() => $_clearField(8);
}

/// Tax report summary per platform, source and expenses.
class TaxReportSummary extends $pb.GeneratedMessage {
  factory TaxReportSummary({
    $core.String? reportId,
    $core.String? workspaceId,
    TaxReportPeriod? period,
    $core.int? year,
    $core.int? periodNumber,
    $core.double? totalRevenue,
    $core.double? affiliateRevenue,
    $core.double? sponsorshipRevenue,
    $core.double? productSalesRevenue,
    $core.double? aiCreditExpenses,
    $core.double? subscriptionExpenses,
    $core.double? netIncomeBeforeTax,
    $core.String? currency,
    TaxReportFormat? format,
    $core.String? downloadUrl,
    $1.Timestamp? generatedAt,
  }) {
    final result = TaxReportSummary._();
    if (reportId != null) result.reportId = reportId;
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (period != null) result.period = period;
    if (year != null) result.year = year;
    if (periodNumber != null) result.periodNumber = periodNumber;
    if (totalRevenue != null) result.totalRevenue = totalRevenue;
    if (affiliateRevenue != null) result.affiliateRevenue = affiliateRevenue;
    if (sponsorshipRevenue != null)
      result.sponsorshipRevenue = sponsorshipRevenue;
    if (productSalesRevenue != null)
      result.productSalesRevenue = productSalesRevenue;
    if (aiCreditExpenses != null) result.aiCreditExpenses = aiCreditExpenses;
    if (subscriptionExpenses != null)
      result.subscriptionExpenses = subscriptionExpenses;
    if (netIncomeBeforeTax != null)
      result.netIncomeBeforeTax = netIncomeBeforeTax;
    if (currency != null) result.currency = currency;
    if (format != null) result.format = format;
    if (downloadUrl != null) result.downloadUrl = downloadUrl;
    if (generatedAt != null) result.generatedAt = generatedAt;
    return result;
  }

  TaxReportSummary._();

  factory TaxReportSummary.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      TaxReportSummary()..mergeFromBuffer(data, registry);
  factory TaxReportSummary.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      TaxReportSummary()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TaxReportSummary',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: TaxReportSummary.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'reportId')
    ..aOS(2, _omitFieldNames ? '' : 'workspaceId')
    ..aE<TaxReportPeriod>(3, _omitFieldNames ? '' : 'period',
        enumValues: TaxReportPeriod.values)
    ..aI(4, _omitFieldNames ? '' : 'year')
    ..aI(5, _omitFieldNames ? '' : 'periodNumber')
    ..aD(6, _omitFieldNames ? '' : 'totalRevenue')
    ..aD(7, _omitFieldNames ? '' : 'affiliateRevenue')
    ..aD(8, _omitFieldNames ? '' : 'sponsorshipRevenue')
    ..aD(9, _omitFieldNames ? '' : 'productSalesRevenue')
    ..aD(10, _omitFieldNames ? '' : 'aiCreditExpenses')
    ..aD(11, _omitFieldNames ? '' : 'subscriptionExpenses')
    ..aD(12, _omitFieldNames ? '' : 'netIncomeBeforeTax')
    ..aOS(13, _omitFieldNames ? '' : 'currency')
    ..aE<TaxReportFormat>(14, _omitFieldNames ? '' : 'format',
        enumValues: TaxReportFormat.values)
    ..aOS(15, _omitFieldNames ? '' : 'downloadUrl')
    ..aOM<$1.Timestamp>(16, _omitFieldNames ? '' : 'generatedAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TaxReportSummary clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TaxReportSummary copyWith(void Function(TaxReportSummary) updates) =>
      super.copyWith((message) => updates(message as TaxReportSummary))
          as TaxReportSummary;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use TaxReportSummary() / TaxReportSummary.new instead')
  static TaxReportSummary create() => TaxReportSummary._();
  static $pb.GeneratedMessage $_createMessage() => TaxReportSummary._();
  @$core.override
  TaxReportSummary createEmptyInstance() => TaxReportSummary._();
  @$core.pragma('dart2js:noInline')
  static TaxReportSummary getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<TaxReportSummary>(
          TaxReportSummary.$_createMessage);
  static TaxReportSummary? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get reportId => $_getSZ(0);
  @$pb.TagNumber(1)
  set reportId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasReportId() => $_has(0);
  @$pb.TagNumber(1)
  void clearReportId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get workspaceId => $_getSZ(1);
  @$pb.TagNumber(2)
  set workspaceId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasWorkspaceId() => $_has(1);
  @$pb.TagNumber(2)
  void clearWorkspaceId() => $_clearField(2);

  @$pb.TagNumber(3)
  TaxReportPeriod get period => $_getN(2);
  @$pb.TagNumber(3)
  set period(TaxReportPeriod value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasPeriod() => $_has(2);
  @$pb.TagNumber(3)
  void clearPeriod() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get year => $_getIZ(3);
  @$pb.TagNumber(4)
  set year($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasYear() => $_has(3);
  @$pb.TagNumber(4)
  void clearYear() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get periodNumber => $_getIZ(4);
  @$pb.TagNumber(5)
  set periodNumber($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasPeriodNumber() => $_has(4);
  @$pb.TagNumber(5)
  void clearPeriodNumber() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.double get totalRevenue => $_getN(5);
  @$pb.TagNumber(6)
  set totalRevenue($core.double value) => $_setDouble(5, value);
  @$pb.TagNumber(6)
  $core.bool hasTotalRevenue() => $_has(5);
  @$pb.TagNumber(6)
  void clearTotalRevenue() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.double get affiliateRevenue => $_getN(6);
  @$pb.TagNumber(7)
  set affiliateRevenue($core.double value) => $_setDouble(6, value);
  @$pb.TagNumber(7)
  $core.bool hasAffiliateRevenue() => $_has(6);
  @$pb.TagNumber(7)
  void clearAffiliateRevenue() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.double get sponsorshipRevenue => $_getN(7);
  @$pb.TagNumber(8)
  set sponsorshipRevenue($core.double value) => $_setDouble(7, value);
  @$pb.TagNumber(8)
  $core.bool hasSponsorshipRevenue() => $_has(7);
  @$pb.TagNumber(8)
  void clearSponsorshipRevenue() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.double get productSalesRevenue => $_getN(8);
  @$pb.TagNumber(9)
  set productSalesRevenue($core.double value) => $_setDouble(8, value);
  @$pb.TagNumber(9)
  $core.bool hasProductSalesRevenue() => $_has(8);
  @$pb.TagNumber(9)
  void clearProductSalesRevenue() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.double get aiCreditExpenses => $_getN(9);
  @$pb.TagNumber(10)
  set aiCreditExpenses($core.double value) => $_setDouble(9, value);
  @$pb.TagNumber(10)
  $core.bool hasAiCreditExpenses() => $_has(9);
  @$pb.TagNumber(10)
  void clearAiCreditExpenses() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.double get subscriptionExpenses => $_getN(10);
  @$pb.TagNumber(11)
  set subscriptionExpenses($core.double value) => $_setDouble(10, value);
  @$pb.TagNumber(11)
  $core.bool hasSubscriptionExpenses() => $_has(10);
  @$pb.TagNumber(11)
  void clearSubscriptionExpenses() => $_clearField(11);

  @$pb.TagNumber(12)
  $core.double get netIncomeBeforeTax => $_getN(11);
  @$pb.TagNumber(12)
  set netIncomeBeforeTax($core.double value) => $_setDouble(11, value);
  @$pb.TagNumber(12)
  $core.bool hasNetIncomeBeforeTax() => $_has(11);
  @$pb.TagNumber(12)
  void clearNetIncomeBeforeTax() => $_clearField(12);

  @$pb.TagNumber(13)
  $core.String get currency => $_getSZ(12);
  @$pb.TagNumber(13)
  set currency($core.String value) => $_setString(12, value);
  @$pb.TagNumber(13)
  $core.bool hasCurrency() => $_has(12);
  @$pb.TagNumber(13)
  void clearCurrency() => $_clearField(13);

  @$pb.TagNumber(14)
  TaxReportFormat get format => $_getN(13);
  @$pb.TagNumber(14)
  set format(TaxReportFormat value) => $_setField(14, value);
  @$pb.TagNumber(14)
  $core.bool hasFormat() => $_has(13);
  @$pb.TagNumber(14)
  void clearFormat() => $_clearField(14);

  @$pb.TagNumber(15)
  $core.String get downloadUrl => $_getSZ(14);
  @$pb.TagNumber(15)
  set downloadUrl($core.String value) => $_setString(14, value);
  @$pb.TagNumber(15)
  $core.bool hasDownloadUrl() => $_has(14);
  @$pb.TagNumber(15)
  void clearDownloadUrl() => $_clearField(15);

  @$pb.TagNumber(16)
  $1.Timestamp get generatedAt => $_getN(15);
  @$pb.TagNumber(16)
  set generatedAt($1.Timestamp value) => $_setField(16, value);
  @$pb.TagNumber(16)
  $core.bool hasGeneratedAt() => $_has(15);
  @$pb.TagNumber(16)
  void clearGeneratedAt() => $_clearField(16);
  @$pb.TagNumber(16)
  $1.Timestamp ensureGeneratedAt() => $_ensure(15);
}

class CreatePageRequest extends $pb.GeneratedMessage {
  factory CreatePageRequest({
    $core.String? workspaceId,
    $core.String? slug,
    $core.String? title,
    $core.String? bio,
    $core.String? avatarUrl,
    $core.String? theme,
  }) {
    final result = CreatePageRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (slug != null) result.slug = slug;
    if (title != null) result.title = title;
    if (bio != null) result.bio = bio;
    if (avatarUrl != null) result.avatarUrl = avatarUrl;
    if (theme != null) result.theme = theme;
    return result;
  }

  CreatePageRequest._();

  factory CreatePageRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CreatePageRequest()..mergeFromBuffer(data, registry);
  factory CreatePageRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CreatePageRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CreatePageRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: CreatePageRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'slug')
    ..aOS(3, _omitFieldNames ? '' : 'title')
    ..aOS(4, _omitFieldNames ? '' : 'bio')
    ..aOS(5, _omitFieldNames ? '' : 'avatarUrl')
    ..aOS(6, _omitFieldNames ? '' : 'theme')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreatePageRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreatePageRequest copyWith(void Function(CreatePageRequest) updates) =>
      super.copyWith((message) => updates(message as CreatePageRequest))
          as CreatePageRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use CreatePageRequest() / CreatePageRequest.new instead')
  static CreatePageRequest create() => CreatePageRequest._();
  static $pb.GeneratedMessage $_createMessage() => CreatePageRequest._();
  @$core.override
  CreatePageRequest createEmptyInstance() => CreatePageRequest._();
  @$core.pragma('dart2js:noInline')
  static CreatePageRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CreatePageRequest>(
          CreatePageRequest.$_createMessage);
  static CreatePageRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get slug => $_getSZ(1);
  @$pb.TagNumber(2)
  set slug($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSlug() => $_has(1);
  @$pb.TagNumber(2)
  void clearSlug() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get title => $_getSZ(2);
  @$pb.TagNumber(3)
  set title($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasTitle() => $_has(2);
  @$pb.TagNumber(3)
  void clearTitle() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get bio => $_getSZ(3);
  @$pb.TagNumber(4)
  set bio($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasBio() => $_has(3);
  @$pb.TagNumber(4)
  void clearBio() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get avatarUrl => $_getSZ(4);
  @$pb.TagNumber(5)
  set avatarUrl($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasAvatarUrl() => $_has(4);
  @$pb.TagNumber(5)
  void clearAvatarUrl() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get theme => $_getSZ(5);
  @$pb.TagNumber(6)
  set theme($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasTheme() => $_has(5);
  @$pb.TagNumber(6)
  void clearTheme() => $_clearField(6);
}

class CreatePageResponse extends $pb.GeneratedMessage {
  factory CreatePageResponse({
    LinkInBioPage? page,
  }) {
    final result = CreatePageResponse._();
    if (page != null) result.page = page;
    return result;
  }

  CreatePageResponse._();

  factory CreatePageResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CreatePageResponse()..mergeFromBuffer(data, registry);
  factory CreatePageResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CreatePageResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CreatePageResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: CreatePageResponse.$_createMessage)
    ..aOM<LinkInBioPage>(1, _omitFieldNames ? '' : 'page',
        subBuilder: LinkInBioPage.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreatePageResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreatePageResponse copyWith(void Function(CreatePageResponse) updates) =>
      super.copyWith((message) => updates(message as CreatePageResponse))
          as CreatePageResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use CreatePageResponse() / CreatePageResponse.new instead')
  static CreatePageResponse create() => CreatePageResponse._();
  static $pb.GeneratedMessage $_createMessage() => CreatePageResponse._();
  @$core.override
  CreatePageResponse createEmptyInstance() => CreatePageResponse._();
  @$core.pragma('dart2js:noInline')
  static CreatePageResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CreatePageResponse>(
          CreatePageResponse.$_createMessage);
  static CreatePageResponse? _defaultInstance;

  @$pb.TagNumber(1)
  LinkInBioPage get page => $_getN(0);
  @$pb.TagNumber(1)
  set page(LinkInBioPage value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasPage() => $_has(0);
  @$pb.TagNumber(1)
  void clearPage() => $_clearField(1);
  @$pb.TagNumber(1)
  LinkInBioPage ensurePage() => $_ensure(0);
}

class GetPageRequest extends $pb.GeneratedMessage {
  factory GetPageRequest({
    $core.String? workspaceId,
    $core.String? pageId,
    $core.String? slug,
  }) {
    final result = GetPageRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (pageId != null) result.pageId = pageId;
    if (slug != null) result.slug = slug;
    return result;
  }

  GetPageRequest._();

  factory GetPageRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetPageRequest()..mergeFromBuffer(data, registry);
  factory GetPageRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetPageRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetPageRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: GetPageRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'pageId')
    ..aOS(3, _omitFieldNames ? '' : 'slug')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetPageRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetPageRequest copyWith(void Function(GetPageRequest) updates) =>
      super.copyWith((message) => updates(message as GetPageRequest))
          as GetPageRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use GetPageRequest() / GetPageRequest.new instead')
  static GetPageRequest create() => GetPageRequest._();
  static $pb.GeneratedMessage $_createMessage() => GetPageRequest._();
  @$core.override
  GetPageRequest createEmptyInstance() => GetPageRequest._();
  @$core.pragma('dart2js:noInline')
  static GetPageRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetPageRequest>(
          GetPageRequest.$_createMessage);
  static GetPageRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get pageId => $_getSZ(1);
  @$pb.TagNumber(2)
  set pageId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPageId() => $_has(1);
  @$pb.TagNumber(2)
  void clearPageId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get slug => $_getSZ(2);
  @$pb.TagNumber(3)
  set slug($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasSlug() => $_has(2);
  @$pb.TagNumber(3)
  void clearSlug() => $_clearField(3);
}

class GetPageResponse extends $pb.GeneratedMessage {
  factory GetPageResponse({
    LinkInBioPage? page,
  }) {
    final result = GetPageResponse._();
    if (page != null) result.page = page;
    return result;
  }

  GetPageResponse._();

  factory GetPageResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetPageResponse()..mergeFromBuffer(data, registry);
  factory GetPageResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetPageResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetPageResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: GetPageResponse.$_createMessage)
    ..aOM<LinkInBioPage>(1, _omitFieldNames ? '' : 'page',
        subBuilder: LinkInBioPage.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetPageResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetPageResponse copyWith(void Function(GetPageResponse) updates) =>
      super.copyWith((message) => updates(message as GetPageResponse))
          as GetPageResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use GetPageResponse() / GetPageResponse.new instead')
  static GetPageResponse create() => GetPageResponse._();
  static $pb.GeneratedMessage $_createMessage() => GetPageResponse._();
  @$core.override
  GetPageResponse createEmptyInstance() => GetPageResponse._();
  @$core.pragma('dart2js:noInline')
  static GetPageResponse getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetPageResponse>(
          GetPageResponse.$_createMessage);
  static GetPageResponse? _defaultInstance;

  @$pb.TagNumber(1)
  LinkInBioPage get page => $_getN(0);
  @$pb.TagNumber(1)
  set page(LinkInBioPage value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasPage() => $_has(0);
  @$pb.TagNumber(1)
  void clearPage() => $_clearField(1);
  @$pb.TagNumber(1)
  LinkInBioPage ensurePage() => $_ensure(0);
}

class UpdatePageRequest extends $pb.GeneratedMessage {
  factory UpdatePageRequest({
    $core.String? workspaceId,
    $core.String? pageId,
    $core.String? title,
    $core.String? bio,
    $core.String? avatarUrl,
    $core.String? theme,
    $core.String? customCss,
    $core.String? customDomain,
  }) {
    final result = UpdatePageRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (pageId != null) result.pageId = pageId;
    if (title != null) result.title = title;
    if (bio != null) result.bio = bio;
    if (avatarUrl != null) result.avatarUrl = avatarUrl;
    if (theme != null) result.theme = theme;
    if (customCss != null) result.customCss = customCss;
    if (customDomain != null) result.customDomain = customDomain;
    return result;
  }

  UpdatePageRequest._();

  factory UpdatePageRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      UpdatePageRequest()..mergeFromBuffer(data, registry);
  factory UpdatePageRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      UpdatePageRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UpdatePageRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: UpdatePageRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'pageId')
    ..aOS(3, _omitFieldNames ? '' : 'title')
    ..aOS(4, _omitFieldNames ? '' : 'bio')
    ..aOS(5, _omitFieldNames ? '' : 'avatarUrl')
    ..aOS(6, _omitFieldNames ? '' : 'theme')
    ..aOS(7, _omitFieldNames ? '' : 'customCss')
    ..aOS(8, _omitFieldNames ? '' : 'customDomain')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdatePageRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdatePageRequest copyWith(void Function(UpdatePageRequest) updates) =>
      super.copyWith((message) => updates(message as UpdatePageRequest))
          as UpdatePageRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use UpdatePageRequest() / UpdatePageRequest.new instead')
  static UpdatePageRequest create() => UpdatePageRequest._();
  static $pb.GeneratedMessage $_createMessage() => UpdatePageRequest._();
  @$core.override
  UpdatePageRequest createEmptyInstance() => UpdatePageRequest._();
  @$core.pragma('dart2js:noInline')
  static UpdatePageRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<UpdatePageRequest>(
          UpdatePageRequest.$_createMessage);
  static UpdatePageRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get pageId => $_getSZ(1);
  @$pb.TagNumber(2)
  set pageId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPageId() => $_has(1);
  @$pb.TagNumber(2)
  void clearPageId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get title => $_getSZ(2);
  @$pb.TagNumber(3)
  set title($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasTitle() => $_has(2);
  @$pb.TagNumber(3)
  void clearTitle() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get bio => $_getSZ(3);
  @$pb.TagNumber(4)
  set bio($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasBio() => $_has(3);
  @$pb.TagNumber(4)
  void clearBio() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get avatarUrl => $_getSZ(4);
  @$pb.TagNumber(5)
  set avatarUrl($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasAvatarUrl() => $_has(4);
  @$pb.TagNumber(5)
  void clearAvatarUrl() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get theme => $_getSZ(5);
  @$pb.TagNumber(6)
  set theme($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasTheme() => $_has(5);
  @$pb.TagNumber(6)
  void clearTheme() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get customCss => $_getSZ(6);
  @$pb.TagNumber(7)
  set customCss($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasCustomCss() => $_has(6);
  @$pb.TagNumber(7)
  void clearCustomCss() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get customDomain => $_getSZ(7);
  @$pb.TagNumber(8)
  set customDomain($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasCustomDomain() => $_has(7);
  @$pb.TagNumber(8)
  void clearCustomDomain() => $_clearField(8);
}

class UpdatePageResponse extends $pb.GeneratedMessage {
  factory UpdatePageResponse({
    LinkInBioPage? page,
  }) {
    final result = UpdatePageResponse._();
    if (page != null) result.page = page;
    return result;
  }

  UpdatePageResponse._();

  factory UpdatePageResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      UpdatePageResponse()..mergeFromBuffer(data, registry);
  factory UpdatePageResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      UpdatePageResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UpdatePageResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: UpdatePageResponse.$_createMessage)
    ..aOM<LinkInBioPage>(1, _omitFieldNames ? '' : 'page',
        subBuilder: LinkInBioPage.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdatePageResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdatePageResponse copyWith(void Function(UpdatePageResponse) updates) =>
      super.copyWith((message) => updates(message as UpdatePageResponse))
          as UpdatePageResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use UpdatePageResponse() / UpdatePageResponse.new instead')
  static UpdatePageResponse create() => UpdatePageResponse._();
  static $pb.GeneratedMessage $_createMessage() => UpdatePageResponse._();
  @$core.override
  UpdatePageResponse createEmptyInstance() => UpdatePageResponse._();
  @$core.pragma('dart2js:noInline')
  static UpdatePageResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UpdatePageResponse>(
          UpdatePageResponse.$_createMessage);
  static UpdatePageResponse? _defaultInstance;

  @$pb.TagNumber(1)
  LinkInBioPage get page => $_getN(0);
  @$pb.TagNumber(1)
  set page(LinkInBioPage value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasPage() => $_has(0);
  @$pb.TagNumber(1)
  void clearPage() => $_clearField(1);
  @$pb.TagNumber(1)
  LinkInBioPage ensurePage() => $_ensure(0);
}

class LinkInBioServiceSaveRequest extends $pb.GeneratedMessage {
  factory LinkInBioServiceSaveRequest({
    $core.String? workspaceId,
    $core.String? pageId,
    $core.String? title,
    $core.String? bio,
    $core.Iterable<LinkItem>? items,
  }) {
    final result = LinkInBioServiceSaveRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (pageId != null) result.pageId = pageId;
    if (title != null) result.title = title;
    if (bio != null) result.bio = bio;
    if (items != null) result.items.addAll(items);
    return result;
  }

  LinkInBioServiceSaveRequest._();

  factory LinkInBioServiceSaveRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      LinkInBioServiceSaveRequest()..mergeFromBuffer(data, registry);
  factory LinkInBioServiceSaveRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      LinkInBioServiceSaveRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'LinkInBioServiceSaveRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: LinkInBioServiceSaveRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'pageId')
    ..aOS(3, _omitFieldNames ? '' : 'title')
    ..aOS(4, _omitFieldNames ? '' : 'bio')
    ..pPM<LinkItem>(5, _omitFieldNames ? '' : 'items',
        subBuilder: LinkItem.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LinkInBioServiceSaveRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LinkInBioServiceSaveRequest copyWith(
          void Function(LinkInBioServiceSaveRequest) updates) =>
      super.copyWith(
              (message) => updates(message as LinkInBioServiceSaveRequest))
          as LinkInBioServiceSaveRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use LinkInBioServiceSaveRequest() / LinkInBioServiceSaveRequest.new instead')
  static LinkInBioServiceSaveRequest create() =>
      LinkInBioServiceSaveRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      LinkInBioServiceSaveRequest._();
  @$core.override
  LinkInBioServiceSaveRequest createEmptyInstance() =>
      LinkInBioServiceSaveRequest._();
  @$core.pragma('dart2js:noInline')
  static LinkInBioServiceSaveRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<LinkInBioServiceSaveRequest>(
          LinkInBioServiceSaveRequest.$_createMessage);
  static LinkInBioServiceSaveRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get pageId => $_getSZ(1);
  @$pb.TagNumber(2)
  set pageId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPageId() => $_has(1);
  @$pb.TagNumber(2)
  void clearPageId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get title => $_getSZ(2);
  @$pb.TagNumber(3)
  set title($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasTitle() => $_has(2);
  @$pb.TagNumber(3)
  void clearTitle() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get bio => $_getSZ(3);
  @$pb.TagNumber(4)
  set bio($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasBio() => $_has(3);
  @$pb.TagNumber(4)
  void clearBio() => $_clearField(4);

  @$pb.TagNumber(5)
  $pb.PbList<LinkItem> get items => $_getList(4);
}

class LinkInBioServiceSaveResponse extends $pb.GeneratedMessage {
  factory LinkInBioServiceSaveResponse({
    LinkInBioPage? page,
  }) {
    final result = LinkInBioServiceSaveResponse._();
    if (page != null) result.page = page;
    return result;
  }

  LinkInBioServiceSaveResponse._();

  factory LinkInBioServiceSaveResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      LinkInBioServiceSaveResponse()..mergeFromBuffer(data, registry);
  factory LinkInBioServiceSaveResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      LinkInBioServiceSaveResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'LinkInBioServiceSaveResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: LinkInBioServiceSaveResponse.$_createMessage)
    ..aOM<LinkInBioPage>(1, _omitFieldNames ? '' : 'page',
        subBuilder: LinkInBioPage.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LinkInBioServiceSaveResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LinkInBioServiceSaveResponse copyWith(
          void Function(LinkInBioServiceSaveResponse) updates) =>
      super.copyWith(
              (message) => updates(message as LinkInBioServiceSaveResponse))
          as LinkInBioServiceSaveResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use LinkInBioServiceSaveResponse() / LinkInBioServiceSaveResponse.new instead')
  static LinkInBioServiceSaveResponse create() =>
      LinkInBioServiceSaveResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      LinkInBioServiceSaveResponse._();
  @$core.override
  LinkInBioServiceSaveResponse createEmptyInstance() =>
      LinkInBioServiceSaveResponse._();
  @$core.pragma('dart2js:noInline')
  static LinkInBioServiceSaveResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<LinkInBioServiceSaveResponse>(
          LinkInBioServiceSaveResponse.$_createMessage);
  static LinkInBioServiceSaveResponse? _defaultInstance;

  @$pb.TagNumber(1)
  LinkInBioPage get page => $_getN(0);
  @$pb.TagNumber(1)
  set page(LinkInBioPage value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasPage() => $_has(0);
  @$pb.TagNumber(1)
  void clearPage() => $_clearField(1);
  @$pb.TagNumber(1)
  LinkInBioPage ensurePage() => $_ensure(0);
}

class GetAnalyticsRequest extends $pb.GeneratedMessage {
  factory GetAnalyticsRequest({
    $core.String? workspaceId,
    $core.String? pageId,
    $core.int? lookbackDays,
  }) {
    final result = GetAnalyticsRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (pageId != null) result.pageId = pageId;
    if (lookbackDays != null) result.lookbackDays = lookbackDays;
    return result;
  }

  GetAnalyticsRequest._();

  factory GetAnalyticsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetAnalyticsRequest()..mergeFromBuffer(data, registry);
  factory GetAnalyticsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetAnalyticsRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetAnalyticsRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: GetAnalyticsRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'pageId')
    ..aI(3, _omitFieldNames ? '' : 'lookbackDays')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetAnalyticsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetAnalyticsRequest copyWith(void Function(GetAnalyticsRequest) updates) =>
      super.copyWith((message) => updates(message as GetAnalyticsRequest))
          as GetAnalyticsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core
      .Deprecated('Use GetAnalyticsRequest() / GetAnalyticsRequest.new instead')
  static GetAnalyticsRequest create() => GetAnalyticsRequest._();
  static $pb.GeneratedMessage $_createMessage() => GetAnalyticsRequest._();
  @$core.override
  GetAnalyticsRequest createEmptyInstance() => GetAnalyticsRequest._();
  @$core.pragma('dart2js:noInline')
  static GetAnalyticsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetAnalyticsRequest>(
          GetAnalyticsRequest.$_createMessage);
  static GetAnalyticsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get pageId => $_getSZ(1);
  @$pb.TagNumber(2)
  set pageId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPageId() => $_has(1);
  @$pb.TagNumber(2)
  void clearPageId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get lookbackDays => $_getIZ(2);
  @$pb.TagNumber(3)
  set lookbackDays($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasLookbackDays() => $_has(2);
  @$pb.TagNumber(3)
  void clearLookbackDays() => $_clearField(3);
}

class GetAnalyticsResponse extends $pb.GeneratedMessage {
  factory GetAnalyticsResponse({
    LinkInBioAnalytics? analytics,
  }) {
    final result = GetAnalyticsResponse._();
    if (analytics != null) result.analytics = analytics;
    return result;
  }

  GetAnalyticsResponse._();

  factory GetAnalyticsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetAnalyticsResponse()..mergeFromBuffer(data, registry);
  factory GetAnalyticsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetAnalyticsResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetAnalyticsResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: GetAnalyticsResponse.$_createMessage)
    ..aOM<LinkInBioAnalytics>(1, _omitFieldNames ? '' : 'analytics',
        subBuilder: LinkInBioAnalytics.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetAnalyticsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetAnalyticsResponse copyWith(void Function(GetAnalyticsResponse) updates) =>
      super.copyWith((message) => updates(message as GetAnalyticsResponse))
          as GetAnalyticsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use GetAnalyticsResponse() / GetAnalyticsResponse.new instead')
  static GetAnalyticsResponse create() => GetAnalyticsResponse._();
  static $pb.GeneratedMessage $_createMessage() => GetAnalyticsResponse._();
  @$core.override
  GetAnalyticsResponse createEmptyInstance() => GetAnalyticsResponse._();
  @$core.pragma('dart2js:noInline')
  static GetAnalyticsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetAnalyticsResponse>(
          GetAnalyticsResponse.$_createMessage);
  static GetAnalyticsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  LinkInBioAnalytics get analytics => $_getN(0);
  @$pb.TagNumber(1)
  set analytics(LinkInBioAnalytics value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasAnalytics() => $_has(0);
  @$pb.TagNumber(1)
  void clearAnalytics() => $_clearField(1);
  @$pb.TagNumber(1)
  LinkInBioAnalytics ensureAnalytics() => $_ensure(0);
}

class LinkInBioServiceReorderRequest extends $pb.GeneratedMessage {
  factory LinkInBioServiceReorderRequest({
    $core.String? workspaceId,
    $core.String? pageId,
    $core.Iterable<$core.String>? itemIdsInOrder,
  }) {
    final result = LinkInBioServiceReorderRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (pageId != null) result.pageId = pageId;
    if (itemIdsInOrder != null) result.itemIdsInOrder.addAll(itemIdsInOrder);
    return result;
  }

  LinkInBioServiceReorderRequest._();

  factory LinkInBioServiceReorderRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      LinkInBioServiceReorderRequest()..mergeFromBuffer(data, registry);
  factory LinkInBioServiceReorderRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      LinkInBioServiceReorderRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'LinkInBioServiceReorderRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: LinkInBioServiceReorderRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'pageId')
    ..pPS(3, _omitFieldNames ? '' : 'itemIdsInOrder')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LinkInBioServiceReorderRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LinkInBioServiceReorderRequest copyWith(
          void Function(LinkInBioServiceReorderRequest) updates) =>
      super.copyWith(
              (message) => updates(message as LinkInBioServiceReorderRequest))
          as LinkInBioServiceReorderRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use LinkInBioServiceReorderRequest() / LinkInBioServiceReorderRequest.new instead')
  static LinkInBioServiceReorderRequest create() =>
      LinkInBioServiceReorderRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      LinkInBioServiceReorderRequest._();
  @$core.override
  LinkInBioServiceReorderRequest createEmptyInstance() =>
      LinkInBioServiceReorderRequest._();
  @$core.pragma('dart2js:noInline')
  static LinkInBioServiceReorderRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<LinkInBioServiceReorderRequest>(
          LinkInBioServiceReorderRequest.$_createMessage);
  static LinkInBioServiceReorderRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get pageId => $_getSZ(1);
  @$pb.TagNumber(2)
  set pageId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPageId() => $_has(1);
  @$pb.TagNumber(2)
  void clearPageId() => $_clearField(2);

  @$pb.TagNumber(3)
  $pb.PbList<$core.String> get itemIdsInOrder => $_getList(2);
}

class LinkInBioServiceReorderResponse extends $pb.GeneratedMessage {
  factory LinkInBioServiceReorderResponse({
    $core.Iterable<LinkItem>? items,
  }) {
    final result = LinkInBioServiceReorderResponse._();
    if (items != null) result.items.addAll(items);
    return result;
  }

  LinkInBioServiceReorderResponse._();

  factory LinkInBioServiceReorderResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      LinkInBioServiceReorderResponse()..mergeFromBuffer(data, registry);
  factory LinkInBioServiceReorderResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      LinkInBioServiceReorderResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'LinkInBioServiceReorderResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: LinkInBioServiceReorderResponse.$_createMessage)
    ..pPM<LinkItem>(1, _omitFieldNames ? '' : 'items',
        subBuilder: LinkItem.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LinkInBioServiceReorderResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LinkInBioServiceReorderResponse copyWith(
          void Function(LinkInBioServiceReorderResponse) updates) =>
      super.copyWith(
              (message) => updates(message as LinkInBioServiceReorderResponse))
          as LinkInBioServiceReorderResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use LinkInBioServiceReorderResponse() / LinkInBioServiceReorderResponse.new instead')
  static LinkInBioServiceReorderResponse create() =>
      LinkInBioServiceReorderResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      LinkInBioServiceReorderResponse._();
  @$core.override
  LinkInBioServiceReorderResponse createEmptyInstance() =>
      LinkInBioServiceReorderResponse._();
  @$core.pragma('dart2js:noInline')
  static LinkInBioServiceReorderResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<LinkInBioServiceReorderResponse>(
          LinkInBioServiceReorderResponse.$_createMessage);
  static LinkInBioServiceReorderResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<LinkItem> get items => $_getList(0);
}

class ToggleLinkRequest extends $pb.GeneratedMessage {
  factory ToggleLinkRequest({
    $core.String? workspaceId,
    $core.String? linkItemId,
    $core.bool? isActive,
  }) {
    final result = ToggleLinkRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (linkItemId != null) result.linkItemId = linkItemId;
    if (isActive != null) result.isActive = isActive;
    return result;
  }

  ToggleLinkRequest._();

  factory ToggleLinkRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ToggleLinkRequest()..mergeFromBuffer(data, registry);
  factory ToggleLinkRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ToggleLinkRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ToggleLinkRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: ToggleLinkRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'linkItemId')
    ..aOB(3, _omitFieldNames ? '' : 'isActive')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ToggleLinkRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ToggleLinkRequest copyWith(void Function(ToggleLinkRequest) updates) =>
      super.copyWith((message) => updates(message as ToggleLinkRequest))
          as ToggleLinkRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ToggleLinkRequest() / ToggleLinkRequest.new instead')
  static ToggleLinkRequest create() => ToggleLinkRequest._();
  static $pb.GeneratedMessage $_createMessage() => ToggleLinkRequest._();
  @$core.override
  ToggleLinkRequest createEmptyInstance() => ToggleLinkRequest._();
  @$core.pragma('dart2js:noInline')
  static ToggleLinkRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ToggleLinkRequest>(
          ToggleLinkRequest.$_createMessage);
  static ToggleLinkRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get linkItemId => $_getSZ(1);
  @$pb.TagNumber(2)
  set linkItemId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasLinkItemId() => $_has(1);
  @$pb.TagNumber(2)
  void clearLinkItemId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.bool get isActive => $_getBF(2);
  @$pb.TagNumber(3)
  set isActive($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasIsActive() => $_has(2);
  @$pb.TagNumber(3)
  void clearIsActive() => $_clearField(3);
}

class ToggleLinkResponse extends $pb.GeneratedMessage {
  factory ToggleLinkResponse({
    LinkItem? item,
  }) {
    final result = ToggleLinkResponse._();
    if (item != null) result.item = item;
    return result;
  }

  ToggleLinkResponse._();

  factory ToggleLinkResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ToggleLinkResponse()..mergeFromBuffer(data, registry);
  factory ToggleLinkResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ToggleLinkResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ToggleLinkResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: ToggleLinkResponse.$_createMessage)
    ..aOM<LinkItem>(1, _omitFieldNames ? '' : 'item',
        subBuilder: LinkItem.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ToggleLinkResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ToggleLinkResponse copyWith(void Function(ToggleLinkResponse) updates) =>
      super.copyWith((message) => updates(message as ToggleLinkResponse))
          as ToggleLinkResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ToggleLinkResponse() / ToggleLinkResponse.new instead')
  static ToggleLinkResponse create() => ToggleLinkResponse._();
  static $pb.GeneratedMessage $_createMessage() => ToggleLinkResponse._();
  @$core.override
  ToggleLinkResponse createEmptyInstance() => ToggleLinkResponse._();
  @$core.pragma('dart2js:noInline')
  static ToggleLinkResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ToggleLinkResponse>(
          ToggleLinkResponse.$_createMessage);
  static ToggleLinkResponse? _defaultInstance;

  @$pb.TagNumber(1)
  LinkItem get item => $_getN(0);
  @$pb.TagNumber(1)
  set item(LinkItem value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasItem() => $_has(0);
  @$pb.TagNumber(1)
  void clearItem() => $_clearField(1);
  @$pb.TagNumber(1)
  LinkItem ensureItem() => $_ensure(0);
}

class UpdateThemeRequest extends $pb.GeneratedMessage {
  factory UpdateThemeRequest({
    $core.String? workspaceId,
    $core.String? pageId,
    $core.String? theme,
    $core.String? customCss,
  }) {
    final result = UpdateThemeRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (pageId != null) result.pageId = pageId;
    if (theme != null) result.theme = theme;
    if (customCss != null) result.customCss = customCss;
    return result;
  }

  UpdateThemeRequest._();

  factory UpdateThemeRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      UpdateThemeRequest()..mergeFromBuffer(data, registry);
  factory UpdateThemeRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      UpdateThemeRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UpdateThemeRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: UpdateThemeRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'pageId')
    ..aOS(3, _omitFieldNames ? '' : 'theme')
    ..aOS(4, _omitFieldNames ? '' : 'customCss')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateThemeRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateThemeRequest copyWith(void Function(UpdateThemeRequest) updates) =>
      super.copyWith((message) => updates(message as UpdateThemeRequest))
          as UpdateThemeRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use UpdateThemeRequest() / UpdateThemeRequest.new instead')
  static UpdateThemeRequest create() => UpdateThemeRequest._();
  static $pb.GeneratedMessage $_createMessage() => UpdateThemeRequest._();
  @$core.override
  UpdateThemeRequest createEmptyInstance() => UpdateThemeRequest._();
  @$core.pragma('dart2js:noInline')
  static UpdateThemeRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UpdateThemeRequest>(
          UpdateThemeRequest.$_createMessage);
  static UpdateThemeRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get pageId => $_getSZ(1);
  @$pb.TagNumber(2)
  set pageId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPageId() => $_has(1);
  @$pb.TagNumber(2)
  void clearPageId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get theme => $_getSZ(2);
  @$pb.TagNumber(3)
  set theme($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasTheme() => $_has(2);
  @$pb.TagNumber(3)
  void clearTheme() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get customCss => $_getSZ(3);
  @$pb.TagNumber(4)
  set customCss($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasCustomCss() => $_has(3);
  @$pb.TagNumber(4)
  void clearCustomCss() => $_clearField(4);
}

class UpdateThemeResponse extends $pb.GeneratedMessage {
  factory UpdateThemeResponse({
    LinkInBioPage? page,
  }) {
    final result = UpdateThemeResponse._();
    if (page != null) result.page = page;
    return result;
  }

  UpdateThemeResponse._();

  factory UpdateThemeResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      UpdateThemeResponse()..mergeFromBuffer(data, registry);
  factory UpdateThemeResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      UpdateThemeResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UpdateThemeResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: UpdateThemeResponse.$_createMessage)
    ..aOM<LinkInBioPage>(1, _omitFieldNames ? '' : 'page',
        subBuilder: LinkInBioPage.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateThemeResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateThemeResponse copyWith(void Function(UpdateThemeResponse) updates) =>
      super.copyWith((message) => updates(message as UpdateThemeResponse))
          as UpdateThemeResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core
      .Deprecated('Use UpdateThemeResponse() / UpdateThemeResponse.new instead')
  static UpdateThemeResponse create() => UpdateThemeResponse._();
  static $pb.GeneratedMessage $_createMessage() => UpdateThemeResponse._();
  @$core.override
  UpdateThemeResponse createEmptyInstance() => UpdateThemeResponse._();
  @$core.pragma('dart2js:noInline')
  static UpdateThemeResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UpdateThemeResponse>(
          UpdateThemeResponse.$_createMessage);
  static UpdateThemeResponse? _defaultInstance;

  @$pb.TagNumber(1)
  LinkInBioPage get page => $_getN(0);
  @$pb.TagNumber(1)
  set page(LinkInBioPage value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasPage() => $_has(0);
  @$pb.TagNumber(1)
  void clearPage() => $_clearField(1);
  @$pb.TagNumber(1)
  LinkInBioPage ensurePage() => $_ensure(0);
}

class ScanLinkRequest extends $pb.GeneratedMessage {
  factory ScanLinkRequest({
    $core.String? workspaceId,
    $core.String? url,
  }) {
    final result = ScanLinkRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (url != null) result.url = url;
    return result;
  }

  ScanLinkRequest._();

  factory ScanLinkRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ScanLinkRequest()..mergeFromBuffer(data, registry);
  factory ScanLinkRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ScanLinkRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ScanLinkRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: ScanLinkRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'url')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ScanLinkRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ScanLinkRequest copyWith(void Function(ScanLinkRequest) updates) =>
      super.copyWith((message) => updates(message as ScanLinkRequest))
          as ScanLinkRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ScanLinkRequest() / ScanLinkRequest.new instead')
  static ScanLinkRequest create() => ScanLinkRequest._();
  static $pb.GeneratedMessage $_createMessage() => ScanLinkRequest._();
  @$core.override
  ScanLinkRequest createEmptyInstance() => ScanLinkRequest._();
  @$core.pragma('dart2js:noInline')
  static ScanLinkRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ScanLinkRequest>(
          ScanLinkRequest.$_createMessage);
  static ScanLinkRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get url => $_getSZ(1);
  @$pb.TagNumber(2)
  set url($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasUrl() => $_has(1);
  @$pb.TagNumber(2)
  void clearUrl() => $_clearField(2);
}

class ScanLinkResponse extends $pb.GeneratedMessage {
  factory ScanLinkResponse({
    $core.String? url,
    LinkSecurityScanStatus? scanStatus,
    $core.bool? phishingDetected,
    $core.String? threatDetails,
    $core.bool? canBePublished,
  }) {
    final result = ScanLinkResponse._();
    if (url != null) result.url = url;
    if (scanStatus != null) result.scanStatus = scanStatus;
    if (phishingDetected != null) result.phishingDetected = phishingDetected;
    if (threatDetails != null) result.threatDetails = threatDetails;
    if (canBePublished != null) result.canBePublished = canBePublished;
    return result;
  }

  ScanLinkResponse._();

  factory ScanLinkResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ScanLinkResponse()..mergeFromBuffer(data, registry);
  factory ScanLinkResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ScanLinkResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ScanLinkResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: ScanLinkResponse.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'url')
    ..aE<LinkSecurityScanStatus>(2, _omitFieldNames ? '' : 'scanStatus',
        enumValues: LinkSecurityScanStatus.values)
    ..aOB(3, _omitFieldNames ? '' : 'phishingDetected')
    ..aOS(4, _omitFieldNames ? '' : 'threatDetails')
    ..aOB(5, _omitFieldNames ? '' : 'canBePublished')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ScanLinkResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ScanLinkResponse copyWith(void Function(ScanLinkResponse) updates) =>
      super.copyWith((message) => updates(message as ScanLinkResponse))
          as ScanLinkResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ScanLinkResponse() / ScanLinkResponse.new instead')
  static ScanLinkResponse create() => ScanLinkResponse._();
  static $pb.GeneratedMessage $_createMessage() => ScanLinkResponse._();
  @$core.override
  ScanLinkResponse createEmptyInstance() => ScanLinkResponse._();
  @$core.pragma('dart2js:noInline')
  static ScanLinkResponse getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ScanLinkResponse>(
          ScanLinkResponse.$_createMessage);
  static ScanLinkResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get url => $_getSZ(0);
  @$pb.TagNumber(1)
  set url($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasUrl() => $_has(0);
  @$pb.TagNumber(1)
  void clearUrl() => $_clearField(1);

  @$pb.TagNumber(2)
  LinkSecurityScanStatus get scanStatus => $_getN(1);
  @$pb.TagNumber(2)
  set scanStatus(LinkSecurityScanStatus value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasScanStatus() => $_has(1);
  @$pb.TagNumber(2)
  void clearScanStatus() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.bool get phishingDetected => $_getBF(2);
  @$pb.TagNumber(3)
  set phishingDetected($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPhishingDetected() => $_has(2);
  @$pb.TagNumber(3)
  void clearPhishingDetected() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get threatDetails => $_getSZ(3);
  @$pb.TagNumber(4)
  set threatDetails($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasThreatDetails() => $_has(3);
  @$pb.TagNumber(4)
  void clearThreatDetails() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.bool get canBePublished => $_getBF(4);
  @$pb.TagNumber(5)
  set canBePublished($core.bool value) => $_setBool(4, value);
  @$pb.TagNumber(5)
  $core.bool hasCanBePublished() => $_has(4);
  @$pb.TagNumber(5)
  void clearCanBePublished() => $_clearField(5);
}

class ReportLinkRequest extends $pb.GeneratedMessage {
  factory ReportLinkRequest({
    $core.String? workspaceId,
    $core.String? linkItemId,
    $core.String? reason,
    $core.String? reporterEmail,
  }) {
    final result = ReportLinkRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (linkItemId != null) result.linkItemId = linkItemId;
    if (reason != null) result.reason = reason;
    if (reporterEmail != null) result.reporterEmail = reporterEmail;
    return result;
  }

  ReportLinkRequest._();

  factory ReportLinkRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ReportLinkRequest()..mergeFromBuffer(data, registry);
  factory ReportLinkRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ReportLinkRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ReportLinkRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: ReportLinkRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'linkItemId')
    ..aOS(3, _omitFieldNames ? '' : 'reason')
    ..aOS(4, _omitFieldNames ? '' : 'reporterEmail')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReportLinkRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReportLinkRequest copyWith(void Function(ReportLinkRequest) updates) =>
      super.copyWith((message) => updates(message as ReportLinkRequest))
          as ReportLinkRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ReportLinkRequest() / ReportLinkRequest.new instead')
  static ReportLinkRequest create() => ReportLinkRequest._();
  static $pb.GeneratedMessage $_createMessage() => ReportLinkRequest._();
  @$core.override
  ReportLinkRequest createEmptyInstance() => ReportLinkRequest._();
  @$core.pragma('dart2js:noInline')
  static ReportLinkRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ReportLinkRequest>(
          ReportLinkRequest.$_createMessage);
  static ReportLinkRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get linkItemId => $_getSZ(1);
  @$pb.TagNumber(2)
  set linkItemId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasLinkItemId() => $_has(1);
  @$pb.TagNumber(2)
  void clearLinkItemId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get reason => $_getSZ(2);
  @$pb.TagNumber(3)
  set reason($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasReason() => $_has(2);
  @$pb.TagNumber(3)
  void clearReason() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get reporterEmail => $_getSZ(3);
  @$pb.TagNumber(4)
  set reporterEmail($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasReporterEmail() => $_has(3);
  @$pb.TagNumber(4)
  void clearReporterEmail() => $_clearField(4);
}

class ReportLinkResponse extends $pb.GeneratedMessage {
  factory ReportLinkResponse({
    $core.bool? accepted,
    $core.String? incidentId,
  }) {
    final result = ReportLinkResponse._();
    if (accepted != null) result.accepted = accepted;
    if (incidentId != null) result.incidentId = incidentId;
    return result;
  }

  ReportLinkResponse._();

  factory ReportLinkResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ReportLinkResponse()..mergeFromBuffer(data, registry);
  factory ReportLinkResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ReportLinkResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ReportLinkResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: ReportLinkResponse.$_createMessage)
    ..aOB(1, _omitFieldNames ? '' : 'accepted')
    ..aOS(2, _omitFieldNames ? '' : 'incidentId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReportLinkResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReportLinkResponse copyWith(void Function(ReportLinkResponse) updates) =>
      super.copyWith((message) => updates(message as ReportLinkResponse))
          as ReportLinkResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ReportLinkResponse() / ReportLinkResponse.new instead')
  static ReportLinkResponse create() => ReportLinkResponse._();
  static $pb.GeneratedMessage $_createMessage() => ReportLinkResponse._();
  @$core.override
  ReportLinkResponse createEmptyInstance() => ReportLinkResponse._();
  @$core.pragma('dart2js:noInline')
  static ReportLinkResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ReportLinkResponse>(
          ReportLinkResponse.$_createMessage);
  static ReportLinkResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get accepted => $_getBF(0);
  @$pb.TagNumber(1)
  set accepted($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAccepted() => $_has(0);
  @$pb.TagNumber(1)
  void clearAccepted() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get incidentId => $_getSZ(1);
  @$pb.TagNumber(2)
  set incidentId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasIncidentId() => $_has(1);
  @$pb.TagNumber(2)
  void clearIncidentId() => $_clearField(2);
}

class VerifyCustomDomainRequest extends $pb.GeneratedMessage {
  factory VerifyCustomDomainRequest({
    $core.String? workspaceId,
    $core.String? pageId,
    $core.String? customDomain,
  }) {
    final result = VerifyCustomDomainRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (pageId != null) result.pageId = pageId;
    if (customDomain != null) result.customDomain = customDomain;
    return result;
  }

  VerifyCustomDomainRequest._();

  factory VerifyCustomDomainRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      VerifyCustomDomainRequest()..mergeFromBuffer(data, registry);
  factory VerifyCustomDomainRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      VerifyCustomDomainRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'VerifyCustomDomainRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: VerifyCustomDomainRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'pageId')
    ..aOS(3, _omitFieldNames ? '' : 'customDomain')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  VerifyCustomDomainRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  VerifyCustomDomainRequest copyWith(
          void Function(VerifyCustomDomainRequest) updates) =>
      super.copyWith((message) => updates(message as VerifyCustomDomainRequest))
          as VerifyCustomDomainRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use VerifyCustomDomainRequest() / VerifyCustomDomainRequest.new instead')
  static VerifyCustomDomainRequest create() => VerifyCustomDomainRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      VerifyCustomDomainRequest._();
  @$core.override
  VerifyCustomDomainRequest createEmptyInstance() =>
      VerifyCustomDomainRequest._();
  @$core.pragma('dart2js:noInline')
  static VerifyCustomDomainRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<VerifyCustomDomainRequest>(
          VerifyCustomDomainRequest.$_createMessage);
  static VerifyCustomDomainRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get pageId => $_getSZ(1);
  @$pb.TagNumber(2)
  set pageId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPageId() => $_has(1);
  @$pb.TagNumber(2)
  void clearPageId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get customDomain => $_getSZ(2);
  @$pb.TagNumber(3)
  set customDomain($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasCustomDomain() => $_has(2);
  @$pb.TagNumber(3)
  void clearCustomDomain() => $_clearField(3);
}

class VerifyCustomDomainResponse extends $pb.GeneratedMessage {
  factory VerifyCustomDomainResponse({
    $core.bool? verified,
    $core.String? statusMessage,
    $core.bool? sslProvisioned,
  }) {
    final result = VerifyCustomDomainResponse._();
    if (verified != null) result.verified = verified;
    if (statusMessage != null) result.statusMessage = statusMessage;
    if (sslProvisioned != null) result.sslProvisioned = sslProvisioned;
    return result;
  }

  VerifyCustomDomainResponse._();

  factory VerifyCustomDomainResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      VerifyCustomDomainResponse()..mergeFromBuffer(data, registry);
  factory VerifyCustomDomainResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      VerifyCustomDomainResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'VerifyCustomDomainResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: VerifyCustomDomainResponse.$_createMessage)
    ..aOB(1, _omitFieldNames ? '' : 'verified')
    ..aOS(2, _omitFieldNames ? '' : 'statusMessage')
    ..aOB(3, _omitFieldNames ? '' : 'sslProvisioned')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  VerifyCustomDomainResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  VerifyCustomDomainResponse copyWith(
          void Function(VerifyCustomDomainResponse) updates) =>
      super.copyWith(
              (message) => updates(message as VerifyCustomDomainResponse))
          as VerifyCustomDomainResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use VerifyCustomDomainResponse() / VerifyCustomDomainResponse.new instead')
  static VerifyCustomDomainResponse create() => VerifyCustomDomainResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      VerifyCustomDomainResponse._();
  @$core.override
  VerifyCustomDomainResponse createEmptyInstance() =>
      VerifyCustomDomainResponse._();
  @$core.pragma('dart2js:noInline')
  static VerifyCustomDomainResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<VerifyCustomDomainResponse>(
          VerifyCustomDomainResponse.$_createMessage);
  static VerifyCustomDomainResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get verified => $_getBF(0);
  @$pb.TagNumber(1)
  set verified($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasVerified() => $_has(0);
  @$pb.TagNumber(1)
  void clearVerified() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get statusMessage => $_getSZ(1);
  @$pb.TagNumber(2)
  set statusMessage($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasStatusMessage() => $_has(1);
  @$pb.TagNumber(2)
  void clearStatusMessage() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.bool get sslProvisioned => $_getBF(2);
  @$pb.TagNumber(3)
  set sslProvisioned($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasSslProvisioned() => $_has(2);
  @$pb.TagNumber(3)
  void clearSslProvisioned() => $_clearField(3);
}

class MediaKitServiceGenerateRequest extends $pb.GeneratedMessage {
  factory MediaKitServiceGenerateRequest({
    $core.String? workspaceId,
    $core.String? template,
    $core.String? brandProfileId,
  }) {
    final result = MediaKitServiceGenerateRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (template != null) result.template = template;
    if (brandProfileId != null) result.brandProfileId = brandProfileId;
    return result;
  }

  MediaKitServiceGenerateRequest._();

  factory MediaKitServiceGenerateRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      MediaKitServiceGenerateRequest()..mergeFromBuffer(data, registry);
  factory MediaKitServiceGenerateRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      MediaKitServiceGenerateRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MediaKitServiceGenerateRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: MediaKitServiceGenerateRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'template')
    ..aOS(3, _omitFieldNames ? '' : 'brandProfileId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MediaKitServiceGenerateRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MediaKitServiceGenerateRequest copyWith(
          void Function(MediaKitServiceGenerateRequest) updates) =>
      super.copyWith(
              (message) => updates(message as MediaKitServiceGenerateRequest))
          as MediaKitServiceGenerateRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use MediaKitServiceGenerateRequest() / MediaKitServiceGenerateRequest.new instead')
  static MediaKitServiceGenerateRequest create() =>
      MediaKitServiceGenerateRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      MediaKitServiceGenerateRequest._();
  @$core.override
  MediaKitServiceGenerateRequest createEmptyInstance() =>
      MediaKitServiceGenerateRequest._();
  @$core.pragma('dart2js:noInline')
  static MediaKitServiceGenerateRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<MediaKitServiceGenerateRequest>(
          MediaKitServiceGenerateRequest.$_createMessage);
  static MediaKitServiceGenerateRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get template => $_getSZ(1);
  @$pb.TagNumber(2)
  set template($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTemplate() => $_has(1);
  @$pb.TagNumber(2)
  void clearTemplate() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get brandProfileId => $_getSZ(2);
  @$pb.TagNumber(3)
  set brandProfileId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasBrandProfileId() => $_has(2);
  @$pb.TagNumber(3)
  void clearBrandProfileId() => $_clearField(3);
}

class MediaKitServiceGenerateResponse extends $pb.GeneratedMessage {
  factory MediaKitServiceGenerateResponse({
    MediaKit? mediaKit,
  }) {
    final result = MediaKitServiceGenerateResponse._();
    if (mediaKit != null) result.mediaKit = mediaKit;
    return result;
  }

  MediaKitServiceGenerateResponse._();

  factory MediaKitServiceGenerateResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      MediaKitServiceGenerateResponse()..mergeFromBuffer(data, registry);
  factory MediaKitServiceGenerateResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      MediaKitServiceGenerateResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MediaKitServiceGenerateResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: MediaKitServiceGenerateResponse.$_createMessage)
    ..aOM<MediaKit>(1, _omitFieldNames ? '' : 'mediaKit',
        subBuilder: MediaKit.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MediaKitServiceGenerateResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MediaKitServiceGenerateResponse copyWith(
          void Function(MediaKitServiceGenerateResponse) updates) =>
      super.copyWith(
              (message) => updates(message as MediaKitServiceGenerateResponse))
          as MediaKitServiceGenerateResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use MediaKitServiceGenerateResponse() / MediaKitServiceGenerateResponse.new instead')
  static MediaKitServiceGenerateResponse create() =>
      MediaKitServiceGenerateResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      MediaKitServiceGenerateResponse._();
  @$core.override
  MediaKitServiceGenerateResponse createEmptyInstance() =>
      MediaKitServiceGenerateResponse._();
  @$core.pragma('dart2js:noInline')
  static MediaKitServiceGenerateResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<MediaKitServiceGenerateResponse>(
          MediaKitServiceGenerateResponse.$_createMessage);
  static MediaKitServiceGenerateResponse? _defaultInstance;

  @$pb.TagNumber(1)
  MediaKit get mediaKit => $_getN(0);
  @$pb.TagNumber(1)
  set mediaKit(MediaKit value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasMediaKit() => $_has(0);
  @$pb.TagNumber(1)
  void clearMediaKit() => $_clearField(1);
  @$pb.TagNumber(1)
  MediaKit ensureMediaKit() => $_ensure(0);
}

class MediaKitServiceGetRequest extends $pb.GeneratedMessage {
  factory MediaKitServiceGetRequest({
    $core.String? workspaceId,
    $core.String? mediaKitId,
  }) {
    final result = MediaKitServiceGetRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (mediaKitId != null) result.mediaKitId = mediaKitId;
    return result;
  }

  MediaKitServiceGetRequest._();

  factory MediaKitServiceGetRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      MediaKitServiceGetRequest()..mergeFromBuffer(data, registry);
  factory MediaKitServiceGetRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      MediaKitServiceGetRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MediaKitServiceGetRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: MediaKitServiceGetRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'mediaKitId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MediaKitServiceGetRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MediaKitServiceGetRequest copyWith(
          void Function(MediaKitServiceGetRequest) updates) =>
      super.copyWith((message) => updates(message as MediaKitServiceGetRequest))
          as MediaKitServiceGetRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use MediaKitServiceGetRequest() / MediaKitServiceGetRequest.new instead')
  static MediaKitServiceGetRequest create() => MediaKitServiceGetRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      MediaKitServiceGetRequest._();
  @$core.override
  MediaKitServiceGetRequest createEmptyInstance() =>
      MediaKitServiceGetRequest._();
  @$core.pragma('dart2js:noInline')
  static MediaKitServiceGetRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<MediaKitServiceGetRequest>(
          MediaKitServiceGetRequest.$_createMessage);
  static MediaKitServiceGetRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get mediaKitId => $_getSZ(1);
  @$pb.TagNumber(2)
  set mediaKitId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasMediaKitId() => $_has(1);
  @$pb.TagNumber(2)
  void clearMediaKitId() => $_clearField(2);
}

class MediaKitServiceGetResponse extends $pb.GeneratedMessage {
  factory MediaKitServiceGetResponse({
    MediaKit? mediaKit,
  }) {
    final result = MediaKitServiceGetResponse._();
    if (mediaKit != null) result.mediaKit = mediaKit;
    return result;
  }

  MediaKitServiceGetResponse._();

  factory MediaKitServiceGetResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      MediaKitServiceGetResponse()..mergeFromBuffer(data, registry);
  factory MediaKitServiceGetResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      MediaKitServiceGetResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MediaKitServiceGetResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: MediaKitServiceGetResponse.$_createMessage)
    ..aOM<MediaKit>(1, _omitFieldNames ? '' : 'mediaKit',
        subBuilder: MediaKit.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MediaKitServiceGetResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MediaKitServiceGetResponse copyWith(
          void Function(MediaKitServiceGetResponse) updates) =>
      super.copyWith(
              (message) => updates(message as MediaKitServiceGetResponse))
          as MediaKitServiceGetResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use MediaKitServiceGetResponse() / MediaKitServiceGetResponse.new instead')
  static MediaKitServiceGetResponse create() => MediaKitServiceGetResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      MediaKitServiceGetResponse._();
  @$core.override
  MediaKitServiceGetResponse createEmptyInstance() =>
      MediaKitServiceGetResponse._();
  @$core.pragma('dart2js:noInline')
  static MediaKitServiceGetResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<MediaKitServiceGetResponse>(
          MediaKitServiceGetResponse.$_createMessage);
  static MediaKitServiceGetResponse? _defaultInstance;

  @$pb.TagNumber(1)
  MediaKit get mediaKit => $_getN(0);
  @$pb.TagNumber(1)
  set mediaKit(MediaKit value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasMediaKit() => $_has(0);
  @$pb.TagNumber(1)
  void clearMediaKit() => $_clearField(1);
  @$pb.TagNumber(1)
  MediaKit ensureMediaKit() => $_ensure(0);
}

class GetKitRequest extends $pb.GeneratedMessage {
  factory GetKitRequest({
    $core.String? workspaceId,
    $core.String? mediaKitId,
  }) {
    final result = GetKitRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (mediaKitId != null) result.mediaKitId = mediaKitId;
    return result;
  }

  GetKitRequest._();

  factory GetKitRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetKitRequest()..mergeFromBuffer(data, registry);
  factory GetKitRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetKitRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetKitRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: GetKitRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'mediaKitId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetKitRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetKitRequest copyWith(void Function(GetKitRequest) updates) =>
      super.copyWith((message) => updates(message as GetKitRequest))
          as GetKitRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use GetKitRequest() / GetKitRequest.new instead')
  static GetKitRequest create() => GetKitRequest._();
  static $pb.GeneratedMessage $_createMessage() => GetKitRequest._();
  @$core.override
  GetKitRequest createEmptyInstance() => GetKitRequest._();
  @$core.pragma('dart2js:noInline')
  static GetKitRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetKitRequest>(
          GetKitRequest.$_createMessage);
  static GetKitRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get mediaKitId => $_getSZ(1);
  @$pb.TagNumber(2)
  set mediaKitId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasMediaKitId() => $_has(1);
  @$pb.TagNumber(2)
  void clearMediaKitId() => $_clearField(2);
}

class GetKitResponse extends $pb.GeneratedMessage {
  factory GetKitResponse({
    MediaKit? mediaKit,
  }) {
    final result = GetKitResponse._();
    if (mediaKit != null) result.mediaKit = mediaKit;
    return result;
  }

  GetKitResponse._();

  factory GetKitResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetKitResponse()..mergeFromBuffer(data, registry);
  factory GetKitResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetKitResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetKitResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: GetKitResponse.$_createMessage)
    ..aOM<MediaKit>(1, _omitFieldNames ? '' : 'mediaKit',
        subBuilder: MediaKit.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetKitResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetKitResponse copyWith(void Function(GetKitResponse) updates) =>
      super.copyWith((message) => updates(message as GetKitResponse))
          as GetKitResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use GetKitResponse() / GetKitResponse.new instead')
  static GetKitResponse create() => GetKitResponse._();
  static $pb.GeneratedMessage $_createMessage() => GetKitResponse._();
  @$core.override
  GetKitResponse createEmptyInstance() => GetKitResponse._();
  @$core.pragma('dart2js:noInline')
  static GetKitResponse getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetKitResponse>(
          GetKitResponse.$_createMessage);
  static GetKitResponse? _defaultInstance;

  @$pb.TagNumber(1)
  MediaKit get mediaKit => $_getN(0);
  @$pb.TagNumber(1)
  set mediaKit(MediaKit value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasMediaKit() => $_has(0);
  @$pb.TagNumber(1)
  void clearMediaKit() => $_clearField(1);
  @$pb.TagNumber(1)
  MediaKit ensureMediaKit() => $_ensure(0);
}

class MediaKitServiceExportRequest extends $pb.GeneratedMessage {
  factory MediaKitServiceExportRequest({
    $core.String? workspaceId,
    $core.String? mediaKitId,
    $core.String? format,
  }) {
    final result = MediaKitServiceExportRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (mediaKitId != null) result.mediaKitId = mediaKitId;
    if (format != null) result.format = format;
    return result;
  }

  MediaKitServiceExportRequest._();

  factory MediaKitServiceExportRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      MediaKitServiceExportRequest()..mergeFromBuffer(data, registry);
  factory MediaKitServiceExportRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      MediaKitServiceExportRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MediaKitServiceExportRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: MediaKitServiceExportRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'mediaKitId')
    ..aOS(3, _omitFieldNames ? '' : 'format')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MediaKitServiceExportRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MediaKitServiceExportRequest copyWith(
          void Function(MediaKitServiceExportRequest) updates) =>
      super.copyWith(
              (message) => updates(message as MediaKitServiceExportRequest))
          as MediaKitServiceExportRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use MediaKitServiceExportRequest() / MediaKitServiceExportRequest.new instead')
  static MediaKitServiceExportRequest create() =>
      MediaKitServiceExportRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      MediaKitServiceExportRequest._();
  @$core.override
  MediaKitServiceExportRequest createEmptyInstance() =>
      MediaKitServiceExportRequest._();
  @$core.pragma('dart2js:noInline')
  static MediaKitServiceExportRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<MediaKitServiceExportRequest>(
          MediaKitServiceExportRequest.$_createMessage);
  static MediaKitServiceExportRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get mediaKitId => $_getSZ(1);
  @$pb.TagNumber(2)
  set mediaKitId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasMediaKitId() => $_has(1);
  @$pb.TagNumber(2)
  void clearMediaKitId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get format => $_getSZ(2);
  @$pb.TagNumber(3)
  set format($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasFormat() => $_has(2);
  @$pb.TagNumber(3)
  void clearFormat() => $_clearField(3);
}

class MediaKitServiceExportResponse extends $pb.GeneratedMessage {
  factory MediaKitServiceExportResponse({
    $core.String? exportUrl,
    $core.String? fileName,
  }) {
    final result = MediaKitServiceExportResponse._();
    if (exportUrl != null) result.exportUrl = exportUrl;
    if (fileName != null) result.fileName = fileName;
    return result;
  }

  MediaKitServiceExportResponse._();

  factory MediaKitServiceExportResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      MediaKitServiceExportResponse()..mergeFromBuffer(data, registry);
  factory MediaKitServiceExportResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      MediaKitServiceExportResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MediaKitServiceExportResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: MediaKitServiceExportResponse.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'exportUrl')
    ..aOS(2, _omitFieldNames ? '' : 'fileName')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MediaKitServiceExportResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MediaKitServiceExportResponse copyWith(
          void Function(MediaKitServiceExportResponse) updates) =>
      super.copyWith(
              (message) => updates(message as MediaKitServiceExportResponse))
          as MediaKitServiceExportResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use MediaKitServiceExportResponse() / MediaKitServiceExportResponse.new instead')
  static MediaKitServiceExportResponse create() =>
      MediaKitServiceExportResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      MediaKitServiceExportResponse._();
  @$core.override
  MediaKitServiceExportResponse createEmptyInstance() =>
      MediaKitServiceExportResponse._();
  @$core.pragma('dart2js:noInline')
  static MediaKitServiceExportResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<MediaKitServiceExportResponse>(
          MediaKitServiceExportResponse.$_createMessage);
  static MediaKitServiceExportResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get exportUrl => $_getSZ(0);
  @$pb.TagNumber(1)
  set exportUrl($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasExportUrl() => $_has(0);
  @$pb.TagNumber(1)
  void clearExportUrl() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get fileName => $_getSZ(1);
  @$pb.TagNumber(2)
  set fileName($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasFileName() => $_has(1);
  @$pb.TagNumber(2)
  void clearFileName() => $_clearField(2);
}

class SetDirectoryProfileRequest extends $pb.GeneratedMessage {
  factory SetDirectoryProfileRequest({
    $core.String? workspaceId,
    $core.String? mediaKitId,
    $core.bool? directoryOptIn,
    $core.String? directoryProfileJson,
  }) {
    final result = SetDirectoryProfileRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (mediaKitId != null) result.mediaKitId = mediaKitId;
    if (directoryOptIn != null) result.directoryOptIn = directoryOptIn;
    if (directoryProfileJson != null)
      result.directoryProfileJson = directoryProfileJson;
    return result;
  }

  SetDirectoryProfileRequest._();

  factory SetDirectoryProfileRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SetDirectoryProfileRequest()..mergeFromBuffer(data, registry);
  factory SetDirectoryProfileRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SetDirectoryProfileRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SetDirectoryProfileRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: SetDirectoryProfileRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'mediaKitId')
    ..aOB(3, _omitFieldNames ? '' : 'directoryOptIn')
    ..aOS(4, _omitFieldNames ? '' : 'directoryProfileJson')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetDirectoryProfileRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetDirectoryProfileRequest copyWith(
          void Function(SetDirectoryProfileRequest) updates) =>
      super.copyWith(
              (message) => updates(message as SetDirectoryProfileRequest))
          as SetDirectoryProfileRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use SetDirectoryProfileRequest() / SetDirectoryProfileRequest.new instead')
  static SetDirectoryProfileRequest create() => SetDirectoryProfileRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      SetDirectoryProfileRequest._();
  @$core.override
  SetDirectoryProfileRequest createEmptyInstance() =>
      SetDirectoryProfileRequest._();
  @$core.pragma('dart2js:noInline')
  static SetDirectoryProfileRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SetDirectoryProfileRequest>(
          SetDirectoryProfileRequest.$_createMessage);
  static SetDirectoryProfileRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get mediaKitId => $_getSZ(1);
  @$pb.TagNumber(2)
  set mediaKitId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasMediaKitId() => $_has(1);
  @$pb.TagNumber(2)
  void clearMediaKitId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.bool get directoryOptIn => $_getBF(2);
  @$pb.TagNumber(3)
  set directoryOptIn($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasDirectoryOptIn() => $_has(2);
  @$pb.TagNumber(3)
  void clearDirectoryOptIn() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get directoryProfileJson => $_getSZ(3);
  @$pb.TagNumber(4)
  set directoryProfileJson($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasDirectoryProfileJson() => $_has(3);
  @$pb.TagNumber(4)
  void clearDirectoryProfileJson() => $_clearField(4);
}

class SetDirectoryProfileResponse extends $pb.GeneratedMessage {
  factory SetDirectoryProfileResponse({
    MediaKit? mediaKit,
  }) {
    final result = SetDirectoryProfileResponse._();
    if (mediaKit != null) result.mediaKit = mediaKit;
    return result;
  }

  SetDirectoryProfileResponse._();

  factory SetDirectoryProfileResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SetDirectoryProfileResponse()..mergeFromBuffer(data, registry);
  factory SetDirectoryProfileResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SetDirectoryProfileResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SetDirectoryProfileResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: SetDirectoryProfileResponse.$_createMessage)
    ..aOM<MediaKit>(1, _omitFieldNames ? '' : 'mediaKit',
        subBuilder: MediaKit.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetDirectoryProfileResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetDirectoryProfileResponse copyWith(
          void Function(SetDirectoryProfileResponse) updates) =>
      super.copyWith(
              (message) => updates(message as SetDirectoryProfileResponse))
          as SetDirectoryProfileResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use SetDirectoryProfileResponse() / SetDirectoryProfileResponse.new instead')
  static SetDirectoryProfileResponse create() =>
      SetDirectoryProfileResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      SetDirectoryProfileResponse._();
  @$core.override
  SetDirectoryProfileResponse createEmptyInstance() =>
      SetDirectoryProfileResponse._();
  @$core.pragma('dart2js:noInline')
  static SetDirectoryProfileResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SetDirectoryProfileResponse>(
          SetDirectoryProfileResponse.$_createMessage);
  static SetDirectoryProfileResponse? _defaultInstance;

  @$pb.TagNumber(1)
  MediaKit get mediaKit => $_getN(0);
  @$pb.TagNumber(1)
  set mediaKit(MediaKit value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasMediaKit() => $_has(0);
  @$pb.TagNumber(1)
  void clearMediaKit() => $_clearField(1);
  @$pb.TagNumber(1)
  MediaKit ensureMediaKit() => $_ensure(0);
}

class RateCardServiceCreateRequest extends $pb.GeneratedMessage {
  factory RateCardServiceCreateRequest({
    $core.String? workspaceId,
    $core.String? currency,
    $core.String? customNote,
    $core.Iterable<RateCardItem>? items,
  }) {
    final result = RateCardServiceCreateRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (currency != null) result.currency = currency;
    if (customNote != null) result.customNote = customNote;
    if (items != null) result.items.addAll(items);
    return result;
  }

  RateCardServiceCreateRequest._();

  factory RateCardServiceCreateRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RateCardServiceCreateRequest()..mergeFromBuffer(data, registry);
  factory RateCardServiceCreateRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RateCardServiceCreateRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RateCardServiceCreateRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: RateCardServiceCreateRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'currency')
    ..aOS(3, _omitFieldNames ? '' : 'customNote')
    ..pPM<RateCardItem>(4, _omitFieldNames ? '' : 'items',
        subBuilder: RateCardItem.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RateCardServiceCreateRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RateCardServiceCreateRequest copyWith(
          void Function(RateCardServiceCreateRequest) updates) =>
      super.copyWith(
              (message) => updates(message as RateCardServiceCreateRequest))
          as RateCardServiceCreateRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use RateCardServiceCreateRequest() / RateCardServiceCreateRequest.new instead')
  static RateCardServiceCreateRequest create() =>
      RateCardServiceCreateRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      RateCardServiceCreateRequest._();
  @$core.override
  RateCardServiceCreateRequest createEmptyInstance() =>
      RateCardServiceCreateRequest._();
  @$core.pragma('dart2js:noInline')
  static RateCardServiceCreateRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RateCardServiceCreateRequest>(
          RateCardServiceCreateRequest.$_createMessage);
  static RateCardServiceCreateRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get currency => $_getSZ(1);
  @$pb.TagNumber(2)
  set currency($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCurrency() => $_has(1);
  @$pb.TagNumber(2)
  void clearCurrency() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get customNote => $_getSZ(2);
  @$pb.TagNumber(3)
  set customNote($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasCustomNote() => $_has(2);
  @$pb.TagNumber(3)
  void clearCustomNote() => $_clearField(3);

  @$pb.TagNumber(4)
  $pb.PbList<RateCardItem> get items => $_getList(3);
}

class RateCardServiceCreateResponse extends $pb.GeneratedMessage {
  factory RateCardServiceCreateResponse({
    RateCard? rateCard,
  }) {
    final result = RateCardServiceCreateResponse._();
    if (rateCard != null) result.rateCard = rateCard;
    return result;
  }

  RateCardServiceCreateResponse._();

  factory RateCardServiceCreateResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RateCardServiceCreateResponse()..mergeFromBuffer(data, registry);
  factory RateCardServiceCreateResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RateCardServiceCreateResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RateCardServiceCreateResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: RateCardServiceCreateResponse.$_createMessage)
    ..aOM<RateCard>(1, _omitFieldNames ? '' : 'rateCard',
        subBuilder: RateCard.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RateCardServiceCreateResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RateCardServiceCreateResponse copyWith(
          void Function(RateCardServiceCreateResponse) updates) =>
      super.copyWith(
              (message) => updates(message as RateCardServiceCreateResponse))
          as RateCardServiceCreateResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use RateCardServiceCreateResponse() / RateCardServiceCreateResponse.new instead')
  static RateCardServiceCreateResponse create() =>
      RateCardServiceCreateResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      RateCardServiceCreateResponse._();
  @$core.override
  RateCardServiceCreateResponse createEmptyInstance() =>
      RateCardServiceCreateResponse._();
  @$core.pragma('dart2js:noInline')
  static RateCardServiceCreateResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RateCardServiceCreateResponse>(
          RateCardServiceCreateResponse.$_createMessage);
  static RateCardServiceCreateResponse? _defaultInstance;

  @$pb.TagNumber(1)
  RateCard get rateCard => $_getN(0);
  @$pb.TagNumber(1)
  set rateCard(RateCard value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasRateCard() => $_has(0);
  @$pb.TagNumber(1)
  void clearRateCard() => $_clearField(1);
  @$pb.TagNumber(1)
  RateCard ensureRateCard() => $_ensure(0);
}

class GetRateCardRequest extends $pb.GeneratedMessage {
  factory GetRateCardRequest({
    $core.String? workspaceId,
    $core.String? rateCardId,
  }) {
    final result = GetRateCardRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (rateCardId != null) result.rateCardId = rateCardId;
    return result;
  }

  GetRateCardRequest._();

  factory GetRateCardRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetRateCardRequest()..mergeFromBuffer(data, registry);
  factory GetRateCardRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetRateCardRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetRateCardRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: GetRateCardRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'rateCardId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetRateCardRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetRateCardRequest copyWith(void Function(GetRateCardRequest) updates) =>
      super.copyWith((message) => updates(message as GetRateCardRequest))
          as GetRateCardRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use GetRateCardRequest() / GetRateCardRequest.new instead')
  static GetRateCardRequest create() => GetRateCardRequest._();
  static $pb.GeneratedMessage $_createMessage() => GetRateCardRequest._();
  @$core.override
  GetRateCardRequest createEmptyInstance() => GetRateCardRequest._();
  @$core.pragma('dart2js:noInline')
  static GetRateCardRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetRateCardRequest>(
          GetRateCardRequest.$_createMessage);
  static GetRateCardRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get rateCardId => $_getSZ(1);
  @$pb.TagNumber(2)
  set rateCardId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasRateCardId() => $_has(1);
  @$pb.TagNumber(2)
  void clearRateCardId() => $_clearField(2);
}

class GetRateCardResponse extends $pb.GeneratedMessage {
  factory GetRateCardResponse({
    RateCard? rateCard,
  }) {
    final result = GetRateCardResponse._();
    if (rateCard != null) result.rateCard = rateCard;
    return result;
  }

  GetRateCardResponse._();

  factory GetRateCardResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetRateCardResponse()..mergeFromBuffer(data, registry);
  factory GetRateCardResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetRateCardResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetRateCardResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: GetRateCardResponse.$_createMessage)
    ..aOM<RateCard>(1, _omitFieldNames ? '' : 'rateCard',
        subBuilder: RateCard.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetRateCardResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetRateCardResponse copyWith(void Function(GetRateCardResponse) updates) =>
      super.copyWith((message) => updates(message as GetRateCardResponse))
          as GetRateCardResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core
      .Deprecated('Use GetRateCardResponse() / GetRateCardResponse.new instead')
  static GetRateCardResponse create() => GetRateCardResponse._();
  static $pb.GeneratedMessage $_createMessage() => GetRateCardResponse._();
  @$core.override
  GetRateCardResponse createEmptyInstance() => GetRateCardResponse._();
  @$core.pragma('dart2js:noInline')
  static GetRateCardResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetRateCardResponse>(
          GetRateCardResponse.$_createMessage);
  static GetRateCardResponse? _defaultInstance;

  @$pb.TagNumber(1)
  RateCard get rateCard => $_getN(0);
  @$pb.TagNumber(1)
  set rateCard(RateCard value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasRateCard() => $_has(0);
  @$pb.TagNumber(1)
  void clearRateCard() => $_clearField(1);
  @$pb.TagNumber(1)
  RateCard ensureRateCard() => $_ensure(0);
}

class RateCardServiceListRequest extends $pb.GeneratedMessage {
  factory RateCardServiceListRequest({
    $core.String? workspaceId,
  }) {
    final result = RateCardServiceListRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    return result;
  }

  RateCardServiceListRequest._();

  factory RateCardServiceListRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RateCardServiceListRequest()..mergeFromBuffer(data, registry);
  factory RateCardServiceListRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RateCardServiceListRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RateCardServiceListRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: RateCardServiceListRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RateCardServiceListRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RateCardServiceListRequest copyWith(
          void Function(RateCardServiceListRequest) updates) =>
      super.copyWith(
              (message) => updates(message as RateCardServiceListRequest))
          as RateCardServiceListRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use RateCardServiceListRequest() / RateCardServiceListRequest.new instead')
  static RateCardServiceListRequest create() => RateCardServiceListRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      RateCardServiceListRequest._();
  @$core.override
  RateCardServiceListRequest createEmptyInstance() =>
      RateCardServiceListRequest._();
  @$core.pragma('dart2js:noInline')
  static RateCardServiceListRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RateCardServiceListRequest>(
          RateCardServiceListRequest.$_createMessage);
  static RateCardServiceListRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);
}

class RateCardServiceListResponse extends $pb.GeneratedMessage {
  factory RateCardServiceListResponse({
    $core.Iterable<RateCard>? rateCards,
  }) {
    final result = RateCardServiceListResponse._();
    if (rateCards != null) result.rateCards.addAll(rateCards);
    return result;
  }

  RateCardServiceListResponse._();

  factory RateCardServiceListResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RateCardServiceListResponse()..mergeFromBuffer(data, registry);
  factory RateCardServiceListResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RateCardServiceListResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RateCardServiceListResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: RateCardServiceListResponse.$_createMessage)
    ..pPM<RateCard>(1, _omitFieldNames ? '' : 'rateCards',
        subBuilder: RateCard.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RateCardServiceListResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RateCardServiceListResponse copyWith(
          void Function(RateCardServiceListResponse) updates) =>
      super.copyWith(
              (message) => updates(message as RateCardServiceListResponse))
          as RateCardServiceListResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use RateCardServiceListResponse() / RateCardServiceListResponse.new instead')
  static RateCardServiceListResponse create() =>
      RateCardServiceListResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      RateCardServiceListResponse._();
  @$core.override
  RateCardServiceListResponse createEmptyInstance() =>
      RateCardServiceListResponse._();
  @$core.pragma('dart2js:noInline')
  static RateCardServiceListResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RateCardServiceListResponse>(
          RateCardServiceListResponse.$_createMessage);
  static RateCardServiceListResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<RateCard> get rateCards => $_getList(0);
}

class RateCardServiceSaveRequest extends $pb.GeneratedMessage {
  factory RateCardServiceSaveRequest({
    $core.String? workspaceId,
    $core.String? rateCardId,
    $core.String? currency,
    $core.String? customNote,
    $core.Iterable<RateCardItem>? items,
  }) {
    final result = RateCardServiceSaveRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (rateCardId != null) result.rateCardId = rateCardId;
    if (currency != null) result.currency = currency;
    if (customNote != null) result.customNote = customNote;
    if (items != null) result.items.addAll(items);
    return result;
  }

  RateCardServiceSaveRequest._();

  factory RateCardServiceSaveRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RateCardServiceSaveRequest()..mergeFromBuffer(data, registry);
  factory RateCardServiceSaveRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RateCardServiceSaveRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RateCardServiceSaveRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: RateCardServiceSaveRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'rateCardId')
    ..aOS(3, _omitFieldNames ? '' : 'currency')
    ..aOS(4, _omitFieldNames ? '' : 'customNote')
    ..pPM<RateCardItem>(5, _omitFieldNames ? '' : 'items',
        subBuilder: RateCardItem.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RateCardServiceSaveRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RateCardServiceSaveRequest copyWith(
          void Function(RateCardServiceSaveRequest) updates) =>
      super.copyWith(
              (message) => updates(message as RateCardServiceSaveRequest))
          as RateCardServiceSaveRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use RateCardServiceSaveRequest() / RateCardServiceSaveRequest.new instead')
  static RateCardServiceSaveRequest create() => RateCardServiceSaveRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      RateCardServiceSaveRequest._();
  @$core.override
  RateCardServiceSaveRequest createEmptyInstance() =>
      RateCardServiceSaveRequest._();
  @$core.pragma('dart2js:noInline')
  static RateCardServiceSaveRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RateCardServiceSaveRequest>(
          RateCardServiceSaveRequest.$_createMessage);
  static RateCardServiceSaveRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get rateCardId => $_getSZ(1);
  @$pb.TagNumber(2)
  set rateCardId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasRateCardId() => $_has(1);
  @$pb.TagNumber(2)
  void clearRateCardId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get currency => $_getSZ(2);
  @$pb.TagNumber(3)
  set currency($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasCurrency() => $_has(2);
  @$pb.TagNumber(3)
  void clearCurrency() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get customNote => $_getSZ(3);
  @$pb.TagNumber(4)
  set customNote($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasCustomNote() => $_has(3);
  @$pb.TagNumber(4)
  void clearCustomNote() => $_clearField(4);

  @$pb.TagNumber(5)
  $pb.PbList<RateCardItem> get items => $_getList(4);
}

class RateCardServiceSaveResponse extends $pb.GeneratedMessage {
  factory RateCardServiceSaveResponse({
    RateCard? rateCard,
  }) {
    final result = RateCardServiceSaveResponse._();
    if (rateCard != null) result.rateCard = rateCard;
    return result;
  }

  RateCardServiceSaveResponse._();

  factory RateCardServiceSaveResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RateCardServiceSaveResponse()..mergeFromBuffer(data, registry);
  factory RateCardServiceSaveResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RateCardServiceSaveResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RateCardServiceSaveResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: RateCardServiceSaveResponse.$_createMessage)
    ..aOM<RateCard>(1, _omitFieldNames ? '' : 'rateCard',
        subBuilder: RateCard.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RateCardServiceSaveResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RateCardServiceSaveResponse copyWith(
          void Function(RateCardServiceSaveResponse) updates) =>
      super.copyWith(
              (message) => updates(message as RateCardServiceSaveResponse))
          as RateCardServiceSaveResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use RateCardServiceSaveResponse() / RateCardServiceSaveResponse.new instead')
  static RateCardServiceSaveResponse create() =>
      RateCardServiceSaveResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      RateCardServiceSaveResponse._();
  @$core.override
  RateCardServiceSaveResponse createEmptyInstance() =>
      RateCardServiceSaveResponse._();
  @$core.pragma('dart2js:noInline')
  static RateCardServiceSaveResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RateCardServiceSaveResponse>(
          RateCardServiceSaveResponse.$_createMessage);
  static RateCardServiceSaveResponse? _defaultInstance;

  @$pb.TagNumber(1)
  RateCard get rateCard => $_getN(0);
  @$pb.TagNumber(1)
  set rateCard(RateCard value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasRateCard() => $_has(0);
  @$pb.TagNumber(1)
  void clearRateCard() => $_clearField(1);
  @$pb.TagNumber(1)
  RateCard ensureRateCard() => $_ensure(0);
}

class RateCardServiceDeleteItemRequest extends $pb.GeneratedMessage {
  factory RateCardServiceDeleteItemRequest({
    $core.String? workspaceId,
    $core.String? itemId,
  }) {
    final result = RateCardServiceDeleteItemRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (itemId != null) result.itemId = itemId;
    return result;
  }

  RateCardServiceDeleteItemRequest._();

  factory RateCardServiceDeleteItemRequest.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RateCardServiceDeleteItemRequest()..mergeFromBuffer(data, registry);
  factory RateCardServiceDeleteItemRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RateCardServiceDeleteItemRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RateCardServiceDeleteItemRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: RateCardServiceDeleteItemRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'itemId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RateCardServiceDeleteItemRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RateCardServiceDeleteItemRequest copyWith(
          void Function(RateCardServiceDeleteItemRequest) updates) =>
      super.copyWith(
              (message) => updates(message as RateCardServiceDeleteItemRequest))
          as RateCardServiceDeleteItemRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use RateCardServiceDeleteItemRequest() / RateCardServiceDeleteItemRequest.new instead')
  static RateCardServiceDeleteItemRequest create() =>
      RateCardServiceDeleteItemRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      RateCardServiceDeleteItemRequest._();
  @$core.override
  RateCardServiceDeleteItemRequest createEmptyInstance() =>
      RateCardServiceDeleteItemRequest._();
  @$core.pragma('dart2js:noInline')
  static RateCardServiceDeleteItemRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RateCardServiceDeleteItemRequest>(
          RateCardServiceDeleteItemRequest.$_createMessage);
  static RateCardServiceDeleteItemRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get itemId => $_getSZ(1);
  @$pb.TagNumber(2)
  set itemId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasItemId() => $_has(1);
  @$pb.TagNumber(2)
  void clearItemId() => $_clearField(2);
}

class RateCardServiceDeleteItemResponse extends $pb.GeneratedMessage {
  factory RateCardServiceDeleteItemResponse({
    $core.bool? deleted,
  }) {
    final result = RateCardServiceDeleteItemResponse._();
    if (deleted != null) result.deleted = deleted;
    return result;
  }

  RateCardServiceDeleteItemResponse._();

  factory RateCardServiceDeleteItemResponse.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RateCardServiceDeleteItemResponse()..mergeFromBuffer(data, registry);
  factory RateCardServiceDeleteItemResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RateCardServiceDeleteItemResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RateCardServiceDeleteItemResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: RateCardServiceDeleteItemResponse.$_createMessage)
    ..aOB(1, _omitFieldNames ? '' : 'deleted')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RateCardServiceDeleteItemResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RateCardServiceDeleteItemResponse copyWith(
          void Function(RateCardServiceDeleteItemResponse) updates) =>
      super.copyWith((message) =>
              updates(message as RateCardServiceDeleteItemResponse))
          as RateCardServiceDeleteItemResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use RateCardServiceDeleteItemResponse() / RateCardServiceDeleteItemResponse.new instead')
  static RateCardServiceDeleteItemResponse create() =>
      RateCardServiceDeleteItemResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      RateCardServiceDeleteItemResponse._();
  @$core.override
  RateCardServiceDeleteItemResponse createEmptyInstance() =>
      RateCardServiceDeleteItemResponse._();
  @$core.pragma('dart2js:noInline')
  static RateCardServiceDeleteItemResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RateCardServiceDeleteItemResponse>(
          RateCardServiceDeleteItemResponse.$_createMessage);
  static RateCardServiceDeleteItemResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get deleted => $_getBF(0);
  @$pb.TagNumber(1)
  set deleted($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasDeleted() => $_has(0);
  @$pb.TagNumber(1)
  void clearDeleted() => $_clearField(1);
}

class RateCardServiceReorderRequest extends $pb.GeneratedMessage {
  factory RateCardServiceReorderRequest({
    $core.String? workspaceId,
    $core.String? rateCardId,
    $core.Iterable<$core.String>? itemIdsInOrder,
  }) {
    final result = RateCardServiceReorderRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (rateCardId != null) result.rateCardId = rateCardId;
    if (itemIdsInOrder != null) result.itemIdsInOrder.addAll(itemIdsInOrder);
    return result;
  }

  RateCardServiceReorderRequest._();

  factory RateCardServiceReorderRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RateCardServiceReorderRequest()..mergeFromBuffer(data, registry);
  factory RateCardServiceReorderRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RateCardServiceReorderRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RateCardServiceReorderRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: RateCardServiceReorderRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'rateCardId')
    ..pPS(3, _omitFieldNames ? '' : 'itemIdsInOrder')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RateCardServiceReorderRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RateCardServiceReorderRequest copyWith(
          void Function(RateCardServiceReorderRequest) updates) =>
      super.copyWith(
              (message) => updates(message as RateCardServiceReorderRequest))
          as RateCardServiceReorderRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use RateCardServiceReorderRequest() / RateCardServiceReorderRequest.new instead')
  static RateCardServiceReorderRequest create() =>
      RateCardServiceReorderRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      RateCardServiceReorderRequest._();
  @$core.override
  RateCardServiceReorderRequest createEmptyInstance() =>
      RateCardServiceReorderRequest._();
  @$core.pragma('dart2js:noInline')
  static RateCardServiceReorderRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RateCardServiceReorderRequest>(
          RateCardServiceReorderRequest.$_createMessage);
  static RateCardServiceReorderRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get rateCardId => $_getSZ(1);
  @$pb.TagNumber(2)
  set rateCardId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasRateCardId() => $_has(1);
  @$pb.TagNumber(2)
  void clearRateCardId() => $_clearField(2);

  @$pb.TagNumber(3)
  $pb.PbList<$core.String> get itemIdsInOrder => $_getList(2);
}

class RateCardServiceReorderResponse extends $pb.GeneratedMessage {
  factory RateCardServiceReorderResponse({
    $core.Iterable<RateCardItem>? items,
  }) {
    final result = RateCardServiceReorderResponse._();
    if (items != null) result.items.addAll(items);
    return result;
  }

  RateCardServiceReorderResponse._();

  factory RateCardServiceReorderResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RateCardServiceReorderResponse()..mergeFromBuffer(data, registry);
  factory RateCardServiceReorderResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RateCardServiceReorderResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RateCardServiceReorderResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: RateCardServiceReorderResponse.$_createMessage)
    ..pPM<RateCardItem>(1, _omitFieldNames ? '' : 'items',
        subBuilder: RateCardItem.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RateCardServiceReorderResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RateCardServiceReorderResponse copyWith(
          void Function(RateCardServiceReorderResponse) updates) =>
      super.copyWith(
              (message) => updates(message as RateCardServiceReorderResponse))
          as RateCardServiceReorderResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use RateCardServiceReorderResponse() / RateCardServiceReorderResponse.new instead')
  static RateCardServiceReorderResponse create() =>
      RateCardServiceReorderResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      RateCardServiceReorderResponse._();
  @$core.override
  RateCardServiceReorderResponse createEmptyInstance() =>
      RateCardServiceReorderResponse._();
  @$core.pragma('dart2js:noInline')
  static RateCardServiceReorderResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RateCardServiceReorderResponse>(
          RateCardServiceReorderResponse.$_createMessage);
  static RateCardServiceReorderResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<RateCardItem> get items => $_getList(0);
}

class CompareScopeRequest extends $pb.GeneratedMessage {
  factory CompareScopeRequest({
    $core.String? workspaceId,
    $core.String? serviceType,
  }) {
    final result = CompareScopeRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (serviceType != null) result.serviceType = serviceType;
    return result;
  }

  CompareScopeRequest._();

  factory CompareScopeRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CompareScopeRequest()..mergeFromBuffer(data, registry);
  factory CompareScopeRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CompareScopeRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CompareScopeRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: CompareScopeRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'serviceType')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CompareScopeRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CompareScopeRequest copyWith(void Function(CompareScopeRequest) updates) =>
      super.copyWith((message) => updates(message as CompareScopeRequest))
          as CompareScopeRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core
      .Deprecated('Use CompareScopeRequest() / CompareScopeRequest.new instead')
  static CompareScopeRequest create() => CompareScopeRequest._();
  static $pb.GeneratedMessage $_createMessage() => CompareScopeRequest._();
  @$core.override
  CompareScopeRequest createEmptyInstance() => CompareScopeRequest._();
  @$core.pragma('dart2js:noInline')
  static CompareScopeRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CompareScopeRequest>(
          CompareScopeRequest.$_createMessage);
  static CompareScopeRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get serviceType => $_getSZ(1);
  @$pb.TagNumber(2)
  set serviceType($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasServiceType() => $_has(1);
  @$pb.TagNumber(2)
  void clearServiceType() => $_clearField(2);
}

class CompareScopeResponse extends $pb.GeneratedMessage {
  factory CompareScopeResponse({
    $core.String? serviceType,
    $core.double? benchmarkMin,
    $core.double? benchmarkAvg,
    $core.double? benchmarkMax,
    $core.String? currency,
  }) {
    final result = CompareScopeResponse._();
    if (serviceType != null) result.serviceType = serviceType;
    if (benchmarkMin != null) result.benchmarkMin = benchmarkMin;
    if (benchmarkAvg != null) result.benchmarkAvg = benchmarkAvg;
    if (benchmarkMax != null) result.benchmarkMax = benchmarkMax;
    if (currency != null) result.currency = currency;
    return result;
  }

  CompareScopeResponse._();

  factory CompareScopeResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CompareScopeResponse()..mergeFromBuffer(data, registry);
  factory CompareScopeResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CompareScopeResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CompareScopeResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: CompareScopeResponse.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'serviceType')
    ..aD(2, _omitFieldNames ? '' : 'benchmarkMin')
    ..aD(3, _omitFieldNames ? '' : 'benchmarkAvg')
    ..aD(4, _omitFieldNames ? '' : 'benchmarkMax')
    ..aOS(5, _omitFieldNames ? '' : 'currency')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CompareScopeResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CompareScopeResponse copyWith(void Function(CompareScopeResponse) updates) =>
      super.copyWith((message) => updates(message as CompareScopeResponse))
          as CompareScopeResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use CompareScopeResponse() / CompareScopeResponse.new instead')
  static CompareScopeResponse create() => CompareScopeResponse._();
  static $pb.GeneratedMessage $_createMessage() => CompareScopeResponse._();
  @$core.override
  CompareScopeResponse createEmptyInstance() => CompareScopeResponse._();
  @$core.pragma('dart2js:noInline')
  static CompareScopeResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CompareScopeResponse>(
          CompareScopeResponse.$_createMessage);
  static CompareScopeResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get serviceType => $_getSZ(0);
  @$pb.TagNumber(1)
  set serviceType($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasServiceType() => $_has(0);
  @$pb.TagNumber(1)
  void clearServiceType() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.double get benchmarkMin => $_getN(1);
  @$pb.TagNumber(2)
  set benchmarkMin($core.double value) => $_setDouble(1, value);
  @$pb.TagNumber(2)
  $core.bool hasBenchmarkMin() => $_has(1);
  @$pb.TagNumber(2)
  void clearBenchmarkMin() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.double get benchmarkAvg => $_getN(2);
  @$pb.TagNumber(3)
  set benchmarkAvg($core.double value) => $_setDouble(2, value);
  @$pb.TagNumber(3)
  $core.bool hasBenchmarkAvg() => $_has(2);
  @$pb.TagNumber(3)
  void clearBenchmarkAvg() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.double get benchmarkMax => $_getN(3);
  @$pb.TagNumber(4)
  set benchmarkMax($core.double value) => $_setDouble(3, value);
  @$pb.TagNumber(4)
  $core.bool hasBenchmarkMax() => $_has(3);
  @$pb.TagNumber(4)
  void clearBenchmarkMax() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get currency => $_getSZ(4);
  @$pb.TagNumber(5)
  set currency($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasCurrency() => $_has(4);
  @$pb.TagNumber(5)
  void clearCurrency() => $_clearField(5);
}

class RateCardServiceAISuggestRequest extends $pb.GeneratedMessage {
  factory RateCardServiceAISuggestRequest({
    $core.String? workspaceId,
    $core.String? platform,
    $core.String? serviceType,
  }) {
    final result = RateCardServiceAISuggestRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (platform != null) result.platform = platform;
    if (serviceType != null) result.serviceType = serviceType;
    return result;
  }

  RateCardServiceAISuggestRequest._();

  factory RateCardServiceAISuggestRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RateCardServiceAISuggestRequest()..mergeFromBuffer(data, registry);
  factory RateCardServiceAISuggestRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RateCardServiceAISuggestRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RateCardServiceAISuggestRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: RateCardServiceAISuggestRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'platform')
    ..aOS(3, _omitFieldNames ? '' : 'serviceType')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RateCardServiceAISuggestRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RateCardServiceAISuggestRequest copyWith(
          void Function(RateCardServiceAISuggestRequest) updates) =>
      super.copyWith(
              (message) => updates(message as RateCardServiceAISuggestRequest))
          as RateCardServiceAISuggestRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use RateCardServiceAISuggestRequest() / RateCardServiceAISuggestRequest.new instead')
  static RateCardServiceAISuggestRequest create() =>
      RateCardServiceAISuggestRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      RateCardServiceAISuggestRequest._();
  @$core.override
  RateCardServiceAISuggestRequest createEmptyInstance() =>
      RateCardServiceAISuggestRequest._();
  @$core.pragma('dart2js:noInline')
  static RateCardServiceAISuggestRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RateCardServiceAISuggestRequest>(
          RateCardServiceAISuggestRequest.$_createMessage);
  static RateCardServiceAISuggestRequest? _defaultInstance;

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
  $core.String get serviceType => $_getSZ(2);
  @$pb.TagNumber(3)
  set serviceType($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasServiceType() => $_has(2);
  @$pb.TagNumber(3)
  void clearServiceType() => $_clearField(3);
}

class RateCardServiceAISuggestResponse extends $pb.GeneratedMessage {
  factory RateCardServiceAISuggestResponse({
    $core.double? suggestedPrice,
    $core.double? priceRangeLow,
    $core.double? priceRangeHigh,
    $core.String? rationale,
    $core.String? currency,
  }) {
    final result = RateCardServiceAISuggestResponse._();
    if (suggestedPrice != null) result.suggestedPrice = suggestedPrice;
    if (priceRangeLow != null) result.priceRangeLow = priceRangeLow;
    if (priceRangeHigh != null) result.priceRangeHigh = priceRangeHigh;
    if (rationale != null) result.rationale = rationale;
    if (currency != null) result.currency = currency;
    return result;
  }

  RateCardServiceAISuggestResponse._();

  factory RateCardServiceAISuggestResponse.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RateCardServiceAISuggestResponse()..mergeFromBuffer(data, registry);
  factory RateCardServiceAISuggestResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RateCardServiceAISuggestResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RateCardServiceAISuggestResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: RateCardServiceAISuggestResponse.$_createMessage)
    ..aD(1, _omitFieldNames ? '' : 'suggestedPrice')
    ..aD(2, _omitFieldNames ? '' : 'priceRangeLow')
    ..aD(3, _omitFieldNames ? '' : 'priceRangeHigh')
    ..aOS(4, _omitFieldNames ? '' : 'rationale')
    ..aOS(5, _omitFieldNames ? '' : 'currency')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RateCardServiceAISuggestResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RateCardServiceAISuggestResponse copyWith(
          void Function(RateCardServiceAISuggestResponse) updates) =>
      super.copyWith(
              (message) => updates(message as RateCardServiceAISuggestResponse))
          as RateCardServiceAISuggestResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use RateCardServiceAISuggestResponse() / RateCardServiceAISuggestResponse.new instead')
  static RateCardServiceAISuggestResponse create() =>
      RateCardServiceAISuggestResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      RateCardServiceAISuggestResponse._();
  @$core.override
  RateCardServiceAISuggestResponse createEmptyInstance() =>
      RateCardServiceAISuggestResponse._();
  @$core.pragma('dart2js:noInline')
  static RateCardServiceAISuggestResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RateCardServiceAISuggestResponse>(
          RateCardServiceAISuggestResponse.$_createMessage);
  static RateCardServiceAISuggestResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.double get suggestedPrice => $_getN(0);
  @$pb.TagNumber(1)
  set suggestedPrice($core.double value) => $_setDouble(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSuggestedPrice() => $_has(0);
  @$pb.TagNumber(1)
  void clearSuggestedPrice() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.double get priceRangeLow => $_getN(1);
  @$pb.TagNumber(2)
  set priceRangeLow($core.double value) => $_setDouble(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPriceRangeLow() => $_has(1);
  @$pb.TagNumber(2)
  void clearPriceRangeLow() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.double get priceRangeHigh => $_getN(2);
  @$pb.TagNumber(3)
  set priceRangeHigh($core.double value) => $_setDouble(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPriceRangeHigh() => $_has(2);
  @$pb.TagNumber(3)
  void clearPriceRangeHigh() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get rationale => $_getSZ(3);
  @$pb.TagNumber(4)
  set rationale($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasRationale() => $_has(3);
  @$pb.TagNumber(4)
  void clearRationale() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get currency => $_getSZ(4);
  @$pb.TagNumber(5)
  set currency($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasCurrency() => $_has(4);
  @$pb.TagNumber(5)
  void clearCurrency() => $_clearField(5);
}

class BrandDealServiceCreateRequest extends $pb.GeneratedMessage {
  factory BrandDealServiceCreateRequest({
    $core.String? workspaceId,
    $core.String? brandName,
    $core.String? contactEmail,
    BrandDealType? dealType,
    $core.double? value,
    $core.String? currency,
    $core.String? deadline,
    $core.String? deliverables,
    $core.String? inquiryThreadId,
    $core.String? notes,
  }) {
    final result = BrandDealServiceCreateRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (brandName != null) result.brandName = brandName;
    if (contactEmail != null) result.contactEmail = contactEmail;
    if (dealType != null) result.dealType = dealType;
    if (value != null) result.value = value;
    if (currency != null) result.currency = currency;
    if (deadline != null) result.deadline = deadline;
    if (deliverables != null) result.deliverables = deliverables;
    if (inquiryThreadId != null) result.inquiryThreadId = inquiryThreadId;
    if (notes != null) result.notes = notes;
    return result;
  }

  BrandDealServiceCreateRequest._();

  factory BrandDealServiceCreateRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      BrandDealServiceCreateRequest()..mergeFromBuffer(data, registry);
  factory BrandDealServiceCreateRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      BrandDealServiceCreateRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'BrandDealServiceCreateRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: BrandDealServiceCreateRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'brandName')
    ..aOS(3, _omitFieldNames ? '' : 'contactEmail')
    ..aE<BrandDealType>(4, _omitFieldNames ? '' : 'dealType',
        enumValues: BrandDealType.values)
    ..aD(5, _omitFieldNames ? '' : 'value')
    ..aOS(6, _omitFieldNames ? '' : 'currency')
    ..aOS(7, _omitFieldNames ? '' : 'deadline')
    ..aOS(8, _omitFieldNames ? '' : 'deliverables')
    ..aOS(9, _omitFieldNames ? '' : 'inquiryThreadId')
    ..aOS(10, _omitFieldNames ? '' : 'notes')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BrandDealServiceCreateRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BrandDealServiceCreateRequest copyWith(
          void Function(BrandDealServiceCreateRequest) updates) =>
      super.copyWith(
              (message) => updates(message as BrandDealServiceCreateRequest))
          as BrandDealServiceCreateRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use BrandDealServiceCreateRequest() / BrandDealServiceCreateRequest.new instead')
  static BrandDealServiceCreateRequest create() =>
      BrandDealServiceCreateRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      BrandDealServiceCreateRequest._();
  @$core.override
  BrandDealServiceCreateRequest createEmptyInstance() =>
      BrandDealServiceCreateRequest._();
  @$core.pragma('dart2js:noInline')
  static BrandDealServiceCreateRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<BrandDealServiceCreateRequest>(
          BrandDealServiceCreateRequest.$_createMessage);
  static BrandDealServiceCreateRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get brandName => $_getSZ(1);
  @$pb.TagNumber(2)
  set brandName($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasBrandName() => $_has(1);
  @$pb.TagNumber(2)
  void clearBrandName() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get contactEmail => $_getSZ(2);
  @$pb.TagNumber(3)
  set contactEmail($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasContactEmail() => $_has(2);
  @$pb.TagNumber(3)
  void clearContactEmail() => $_clearField(3);

  @$pb.TagNumber(4)
  BrandDealType get dealType => $_getN(3);
  @$pb.TagNumber(4)
  set dealType(BrandDealType value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasDealType() => $_has(3);
  @$pb.TagNumber(4)
  void clearDealType() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.double get value => $_getN(4);
  @$pb.TagNumber(5)
  set value($core.double value) => $_setDouble(4, value);
  @$pb.TagNumber(5)
  $core.bool hasValue() => $_has(4);
  @$pb.TagNumber(5)
  void clearValue() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get currency => $_getSZ(5);
  @$pb.TagNumber(6)
  set currency($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasCurrency() => $_has(5);
  @$pb.TagNumber(6)
  void clearCurrency() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get deadline => $_getSZ(6);
  @$pb.TagNumber(7)
  set deadline($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasDeadline() => $_has(6);
  @$pb.TagNumber(7)
  void clearDeadline() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get deliverables => $_getSZ(7);
  @$pb.TagNumber(8)
  set deliverables($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasDeliverables() => $_has(7);
  @$pb.TagNumber(8)
  void clearDeliverables() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get inquiryThreadId => $_getSZ(8);
  @$pb.TagNumber(9)
  set inquiryThreadId($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasInquiryThreadId() => $_has(8);
  @$pb.TagNumber(9)
  void clearInquiryThreadId() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.String get notes => $_getSZ(9);
  @$pb.TagNumber(10)
  set notes($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasNotes() => $_has(9);
  @$pb.TagNumber(10)
  void clearNotes() => $_clearField(10);
}

class BrandDealServiceCreateResponse extends $pb.GeneratedMessage {
  factory BrandDealServiceCreateResponse({
    BrandDeal? deal,
  }) {
    final result = BrandDealServiceCreateResponse._();
    if (deal != null) result.deal = deal;
    return result;
  }

  BrandDealServiceCreateResponse._();

  factory BrandDealServiceCreateResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      BrandDealServiceCreateResponse()..mergeFromBuffer(data, registry);
  factory BrandDealServiceCreateResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      BrandDealServiceCreateResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'BrandDealServiceCreateResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: BrandDealServiceCreateResponse.$_createMessage)
    ..aOM<BrandDeal>(1, _omitFieldNames ? '' : 'deal',
        subBuilder: BrandDeal.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BrandDealServiceCreateResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BrandDealServiceCreateResponse copyWith(
          void Function(BrandDealServiceCreateResponse) updates) =>
      super.copyWith(
              (message) => updates(message as BrandDealServiceCreateResponse))
          as BrandDealServiceCreateResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use BrandDealServiceCreateResponse() / BrandDealServiceCreateResponse.new instead')
  static BrandDealServiceCreateResponse create() =>
      BrandDealServiceCreateResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      BrandDealServiceCreateResponse._();
  @$core.override
  BrandDealServiceCreateResponse createEmptyInstance() =>
      BrandDealServiceCreateResponse._();
  @$core.pragma('dart2js:noInline')
  static BrandDealServiceCreateResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<BrandDealServiceCreateResponse>(
          BrandDealServiceCreateResponse.$_createMessage);
  static BrandDealServiceCreateResponse? _defaultInstance;

  @$pb.TagNumber(1)
  BrandDeal get deal => $_getN(0);
  @$pb.TagNumber(1)
  set deal(BrandDeal value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasDeal() => $_has(0);
  @$pb.TagNumber(1)
  void clearDeal() => $_clearField(1);
  @$pb.TagNumber(1)
  BrandDeal ensureDeal() => $_ensure(0);
}

class BrandDealServiceUpdateStatusRequest extends $pb.GeneratedMessage {
  factory BrandDealServiceUpdateStatusRequest({
    $core.String? workspaceId,
    $core.String? dealId,
    BrandDealStatus? targetStatus,
    $core.String? cancellationReason,
    $core.bool? requiresFinancialReversal,
  }) {
    final result = BrandDealServiceUpdateStatusRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (dealId != null) result.dealId = dealId;
    if (targetStatus != null) result.targetStatus = targetStatus;
    if (cancellationReason != null)
      result.cancellationReason = cancellationReason;
    if (requiresFinancialReversal != null)
      result.requiresFinancialReversal = requiresFinancialReversal;
    return result;
  }

  BrandDealServiceUpdateStatusRequest._();

  factory BrandDealServiceUpdateStatusRequest.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      BrandDealServiceUpdateStatusRequest()..mergeFromBuffer(data, registry);
  factory BrandDealServiceUpdateStatusRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      BrandDealServiceUpdateStatusRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'BrandDealServiceUpdateStatusRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: BrandDealServiceUpdateStatusRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'dealId')
    ..aE<BrandDealStatus>(3, _omitFieldNames ? '' : 'targetStatus',
        enumValues: BrandDealStatus.values)
    ..aOS(4, _omitFieldNames ? '' : 'cancellationReason')
    ..aOB(5, _omitFieldNames ? '' : 'requiresFinancialReversal')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BrandDealServiceUpdateStatusRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BrandDealServiceUpdateStatusRequest copyWith(
          void Function(BrandDealServiceUpdateStatusRequest) updates) =>
      super.copyWith((message) =>
              updates(message as BrandDealServiceUpdateStatusRequest))
          as BrandDealServiceUpdateStatusRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use BrandDealServiceUpdateStatusRequest() / BrandDealServiceUpdateStatusRequest.new instead')
  static BrandDealServiceUpdateStatusRequest create() =>
      BrandDealServiceUpdateStatusRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      BrandDealServiceUpdateStatusRequest._();
  @$core.override
  BrandDealServiceUpdateStatusRequest createEmptyInstance() =>
      BrandDealServiceUpdateStatusRequest._();
  @$core.pragma('dart2js:noInline')
  static BrandDealServiceUpdateStatusRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
              BrandDealServiceUpdateStatusRequest>(
          BrandDealServiceUpdateStatusRequest.$_createMessage);
  static BrandDealServiceUpdateStatusRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get dealId => $_getSZ(1);
  @$pb.TagNumber(2)
  set dealId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasDealId() => $_has(1);
  @$pb.TagNumber(2)
  void clearDealId() => $_clearField(2);

  @$pb.TagNumber(3)
  BrandDealStatus get targetStatus => $_getN(2);
  @$pb.TagNumber(3)
  set targetStatus(BrandDealStatus value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasTargetStatus() => $_has(2);
  @$pb.TagNumber(3)
  void clearTargetStatus() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get cancellationReason => $_getSZ(3);
  @$pb.TagNumber(4)
  set cancellationReason($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasCancellationReason() => $_has(3);
  @$pb.TagNumber(4)
  void clearCancellationReason() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.bool get requiresFinancialReversal => $_getBF(4);
  @$pb.TagNumber(5)
  set requiresFinancialReversal($core.bool value) => $_setBool(4, value);
  @$pb.TagNumber(5)
  $core.bool hasRequiresFinancialReversal() => $_has(4);
  @$pb.TagNumber(5)
  void clearRequiresFinancialReversal() => $_clearField(5);
}

class BrandDealServiceUpdateStatusResponse extends $pb.GeneratedMessage {
  factory BrandDealServiceUpdateStatusResponse({
    BrandDeal? deal,
  }) {
    final result = BrandDealServiceUpdateStatusResponse._();
    if (deal != null) result.deal = deal;
    return result;
  }

  BrandDealServiceUpdateStatusResponse._();

  factory BrandDealServiceUpdateStatusResponse.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      BrandDealServiceUpdateStatusResponse()..mergeFromBuffer(data, registry);
  factory BrandDealServiceUpdateStatusResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      BrandDealServiceUpdateStatusResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'BrandDealServiceUpdateStatusResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: BrandDealServiceUpdateStatusResponse.$_createMessage)
    ..aOM<BrandDeal>(1, _omitFieldNames ? '' : 'deal',
        subBuilder: BrandDeal.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BrandDealServiceUpdateStatusResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BrandDealServiceUpdateStatusResponse copyWith(
          void Function(BrandDealServiceUpdateStatusResponse) updates) =>
      super.copyWith((message) =>
              updates(message as BrandDealServiceUpdateStatusResponse))
          as BrandDealServiceUpdateStatusResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use BrandDealServiceUpdateStatusResponse() / BrandDealServiceUpdateStatusResponse.new instead')
  static BrandDealServiceUpdateStatusResponse create() =>
      BrandDealServiceUpdateStatusResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      BrandDealServiceUpdateStatusResponse._();
  @$core.override
  BrandDealServiceUpdateStatusResponse createEmptyInstance() =>
      BrandDealServiceUpdateStatusResponse._();
  @$core.pragma('dart2js:noInline')
  static BrandDealServiceUpdateStatusResponse getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
              BrandDealServiceUpdateStatusResponse>(
          BrandDealServiceUpdateStatusResponse.$_createMessage);
  static BrandDealServiceUpdateStatusResponse? _defaultInstance;

  @$pb.TagNumber(1)
  BrandDeal get deal => $_getN(0);
  @$pb.TagNumber(1)
  set deal(BrandDeal value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasDeal() => $_has(0);
  @$pb.TagNumber(1)
  void clearDeal() => $_clearField(1);
  @$pb.TagNumber(1)
  BrandDeal ensureDeal() => $_ensure(0);
}

class BrandDealServiceListRequest extends $pb.GeneratedMessage {
  factory BrandDealServiceListRequest({
    $core.String? workspaceId,
    BrandDealStatus? statusFilter,
  }) {
    final result = BrandDealServiceListRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (statusFilter != null) result.statusFilter = statusFilter;
    return result;
  }

  BrandDealServiceListRequest._();

  factory BrandDealServiceListRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      BrandDealServiceListRequest()..mergeFromBuffer(data, registry);
  factory BrandDealServiceListRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      BrandDealServiceListRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'BrandDealServiceListRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: BrandDealServiceListRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aE<BrandDealStatus>(2, _omitFieldNames ? '' : 'statusFilter',
        enumValues: BrandDealStatus.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BrandDealServiceListRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BrandDealServiceListRequest copyWith(
          void Function(BrandDealServiceListRequest) updates) =>
      super.copyWith(
              (message) => updates(message as BrandDealServiceListRequest))
          as BrandDealServiceListRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use BrandDealServiceListRequest() / BrandDealServiceListRequest.new instead')
  static BrandDealServiceListRequest create() =>
      BrandDealServiceListRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      BrandDealServiceListRequest._();
  @$core.override
  BrandDealServiceListRequest createEmptyInstance() =>
      BrandDealServiceListRequest._();
  @$core.pragma('dart2js:noInline')
  static BrandDealServiceListRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<BrandDealServiceListRequest>(
          BrandDealServiceListRequest.$_createMessage);
  static BrandDealServiceListRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  BrandDealStatus get statusFilter => $_getN(1);
  @$pb.TagNumber(2)
  set statusFilter(BrandDealStatus value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasStatusFilter() => $_has(1);
  @$pb.TagNumber(2)
  void clearStatusFilter() => $_clearField(2);
}

class BrandDealServiceListResponse extends $pb.GeneratedMessage {
  factory BrandDealServiceListResponse({
    $core.Iterable<BrandDeal>? deals,
  }) {
    final result = BrandDealServiceListResponse._();
    if (deals != null) result.deals.addAll(deals);
    return result;
  }

  BrandDealServiceListResponse._();

  factory BrandDealServiceListResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      BrandDealServiceListResponse()..mergeFromBuffer(data, registry);
  factory BrandDealServiceListResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      BrandDealServiceListResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'BrandDealServiceListResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: BrandDealServiceListResponse.$_createMessage)
    ..pPM<BrandDeal>(1, _omitFieldNames ? '' : 'deals',
        subBuilder: BrandDeal.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BrandDealServiceListResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BrandDealServiceListResponse copyWith(
          void Function(BrandDealServiceListResponse) updates) =>
      super.copyWith(
              (message) => updates(message as BrandDealServiceListResponse))
          as BrandDealServiceListResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use BrandDealServiceListResponse() / BrandDealServiceListResponse.new instead')
  static BrandDealServiceListResponse create() =>
      BrandDealServiceListResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      BrandDealServiceListResponse._();
  @$core.override
  BrandDealServiceListResponse createEmptyInstance() =>
      BrandDealServiceListResponse._();
  @$core.pragma('dart2js:noInline')
  static BrandDealServiceListResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<BrandDealServiceListResponse>(
          BrandDealServiceListResponse.$_createMessage);
  static BrandDealServiceListResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<BrandDeal> get deals => $_getList(0);
}

class ListDealsRequest extends $pb.GeneratedMessage {
  factory ListDealsRequest({
    $core.String? workspaceId,
    BrandDealStatus? statusFilter,
  }) {
    final result = ListDealsRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (statusFilter != null) result.statusFilter = statusFilter;
    return result;
  }

  ListDealsRequest._();

  factory ListDealsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListDealsRequest()..mergeFromBuffer(data, registry);
  factory ListDealsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListDealsRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListDealsRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: ListDealsRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aE<BrandDealStatus>(2, _omitFieldNames ? '' : 'statusFilter',
        enumValues: BrandDealStatus.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListDealsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListDealsRequest copyWith(void Function(ListDealsRequest) updates) =>
      super.copyWith((message) => updates(message as ListDealsRequest))
          as ListDealsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ListDealsRequest() / ListDealsRequest.new instead')
  static ListDealsRequest create() => ListDealsRequest._();
  static $pb.GeneratedMessage $_createMessage() => ListDealsRequest._();
  @$core.override
  ListDealsRequest createEmptyInstance() => ListDealsRequest._();
  @$core.pragma('dart2js:noInline')
  static ListDealsRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ListDealsRequest>(
          ListDealsRequest.$_createMessage);
  static ListDealsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  BrandDealStatus get statusFilter => $_getN(1);
  @$pb.TagNumber(2)
  set statusFilter(BrandDealStatus value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasStatusFilter() => $_has(1);
  @$pb.TagNumber(2)
  void clearStatusFilter() => $_clearField(2);
}

class ListDealsResponse extends $pb.GeneratedMessage {
  factory ListDealsResponse({
    $core.Iterable<BrandDeal>? deals,
  }) {
    final result = ListDealsResponse._();
    if (deals != null) result.deals.addAll(deals);
    return result;
  }

  ListDealsResponse._();

  factory ListDealsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListDealsResponse()..mergeFromBuffer(data, registry);
  factory ListDealsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListDealsResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListDealsResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: ListDealsResponse.$_createMessage)
    ..pPM<BrandDeal>(1, _omitFieldNames ? '' : 'deals',
        subBuilder: BrandDeal.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListDealsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListDealsResponse copyWith(void Function(ListDealsResponse) updates) =>
      super.copyWith((message) => updates(message as ListDealsResponse))
          as ListDealsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ListDealsResponse() / ListDealsResponse.new instead')
  static ListDealsResponse create() => ListDealsResponse._();
  static $pb.GeneratedMessage $_createMessage() => ListDealsResponse._();
  @$core.override
  ListDealsResponse createEmptyInstance() => ListDealsResponse._();
  @$core.pragma('dart2js:noInline')
  static ListDealsResponse getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ListDealsResponse>(
          ListDealsResponse.$_createMessage);
  static ListDealsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<BrandDeal> get deals => $_getList(0);
}

class ListPartnershipsRequest extends $pb.GeneratedMessage {
  factory ListPartnershipsRequest({
    $core.String? workspaceId,
  }) {
    final result = ListPartnershipsRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    return result;
  }

  ListPartnershipsRequest._();

  factory ListPartnershipsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListPartnershipsRequest()..mergeFromBuffer(data, registry);
  factory ListPartnershipsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListPartnershipsRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListPartnershipsRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: ListPartnershipsRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListPartnershipsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListPartnershipsRequest copyWith(
          void Function(ListPartnershipsRequest) updates) =>
      super.copyWith((message) => updates(message as ListPartnershipsRequest))
          as ListPartnershipsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ListPartnershipsRequest() / ListPartnershipsRequest.new instead')
  static ListPartnershipsRequest create() => ListPartnershipsRequest._();
  static $pb.GeneratedMessage $_createMessage() => ListPartnershipsRequest._();
  @$core.override
  ListPartnershipsRequest createEmptyInstance() => ListPartnershipsRequest._();
  @$core.pragma('dart2js:noInline')
  static ListPartnershipsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListPartnershipsRequest>(
          ListPartnershipsRequest.$_createMessage);
  static ListPartnershipsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);
}

class ListPartnershipsResponse extends $pb.GeneratedMessage {
  factory ListPartnershipsResponse({
    $core.Iterable<BrandDeal>? partnerships,
  }) {
    final result = ListPartnershipsResponse._();
    if (partnerships != null) result.partnerships.addAll(partnerships);
    return result;
  }

  ListPartnershipsResponse._();

  factory ListPartnershipsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListPartnershipsResponse()..mergeFromBuffer(data, registry);
  factory ListPartnershipsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListPartnershipsResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListPartnershipsResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: ListPartnershipsResponse.$_createMessage)
    ..pPM<BrandDeal>(1, _omitFieldNames ? '' : 'partnerships',
        subBuilder: BrandDeal.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListPartnershipsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListPartnershipsResponse copyWith(
          void Function(ListPartnershipsResponse) updates) =>
      super.copyWith((message) => updates(message as ListPartnershipsResponse))
          as ListPartnershipsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ListPartnershipsResponse() / ListPartnershipsResponse.new instead')
  static ListPartnershipsResponse create() => ListPartnershipsResponse._();
  static $pb.GeneratedMessage $_createMessage() => ListPartnershipsResponse._();
  @$core.override
  ListPartnershipsResponse createEmptyInstance() =>
      ListPartnershipsResponse._();
  @$core.pragma('dart2js:noInline')
  static ListPartnershipsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListPartnershipsResponse>(
          ListPartnershipsResponse.$_createMessage);
  static ListPartnershipsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<BrandDeal> get partnerships => $_getList(0);
}

class GetPipelineStatsRequest extends $pb.GeneratedMessage {
  factory GetPipelineStatsRequest({
    $core.String? workspaceId,
  }) {
    final result = GetPipelineStatsRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    return result;
  }

  GetPipelineStatsRequest._();

  factory GetPipelineStatsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetPipelineStatsRequest()..mergeFromBuffer(data, registry);
  factory GetPipelineStatsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetPipelineStatsRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetPipelineStatsRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: GetPipelineStatsRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetPipelineStatsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetPipelineStatsRequest copyWith(
          void Function(GetPipelineStatsRequest) updates) =>
      super.copyWith((message) => updates(message as GetPipelineStatsRequest))
          as GetPipelineStatsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use GetPipelineStatsRequest() / GetPipelineStatsRequest.new instead')
  static GetPipelineStatsRequest create() => GetPipelineStatsRequest._();
  static $pb.GeneratedMessage $_createMessage() => GetPipelineStatsRequest._();
  @$core.override
  GetPipelineStatsRequest createEmptyInstance() => GetPipelineStatsRequest._();
  @$core.pragma('dart2js:noInline')
  static GetPipelineStatsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetPipelineStatsRequest>(
          GetPipelineStatsRequest.$_createMessage);
  static GetPipelineStatsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);
}

class GetPipelineStatsResponse extends $pb.GeneratedMessage {
  factory GetPipelineStatsResponse({
    BrandDealPipelineStats? stats,
  }) {
    final result = GetPipelineStatsResponse._();
    if (stats != null) result.stats = stats;
    return result;
  }

  GetPipelineStatsResponse._();

  factory GetPipelineStatsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetPipelineStatsResponse()..mergeFromBuffer(data, registry);
  factory GetPipelineStatsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetPipelineStatsResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetPipelineStatsResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: GetPipelineStatsResponse.$_createMessage)
    ..aOM<BrandDealPipelineStats>(1, _omitFieldNames ? '' : 'stats',
        subBuilder: BrandDealPipelineStats.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetPipelineStatsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetPipelineStatsResponse copyWith(
          void Function(GetPipelineStatsResponse) updates) =>
      super.copyWith((message) => updates(message as GetPipelineStatsResponse))
          as GetPipelineStatsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use GetPipelineStatsResponse() / GetPipelineStatsResponse.new instead')
  static GetPipelineStatsResponse create() => GetPipelineStatsResponse._();
  static $pb.GeneratedMessage $_createMessage() => GetPipelineStatsResponse._();
  @$core.override
  GetPipelineStatsResponse createEmptyInstance() =>
      GetPipelineStatsResponse._();
  @$core.pragma('dart2js:noInline')
  static GetPipelineStatsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetPipelineStatsResponse>(
          GetPipelineStatsResponse.$_createMessage);
  static GetPipelineStatsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  BrandDealPipelineStats get stats => $_getN(0);
  @$pb.TagNumber(1)
  set stats(BrandDealPipelineStats value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasStats() => $_has(0);
  @$pb.TagNumber(1)
  void clearStats() => $_clearField(1);
  @$pb.TagNumber(1)
  BrandDealPipelineStats ensureStats() => $_ensure(0);
}

class BrandDealServiceGetSummaryRequest extends $pb.GeneratedMessage {
  factory BrandDealServiceGetSummaryRequest({
    $core.String? workspaceId,
    $core.String? dealId,
  }) {
    final result = BrandDealServiceGetSummaryRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (dealId != null) result.dealId = dealId;
    return result;
  }

  BrandDealServiceGetSummaryRequest._();

  factory BrandDealServiceGetSummaryRequest.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      BrandDealServiceGetSummaryRequest()..mergeFromBuffer(data, registry);
  factory BrandDealServiceGetSummaryRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      BrandDealServiceGetSummaryRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'BrandDealServiceGetSummaryRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: BrandDealServiceGetSummaryRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'dealId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BrandDealServiceGetSummaryRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BrandDealServiceGetSummaryRequest copyWith(
          void Function(BrandDealServiceGetSummaryRequest) updates) =>
      super.copyWith((message) =>
              updates(message as BrandDealServiceGetSummaryRequest))
          as BrandDealServiceGetSummaryRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use BrandDealServiceGetSummaryRequest() / BrandDealServiceGetSummaryRequest.new instead')
  static BrandDealServiceGetSummaryRequest create() =>
      BrandDealServiceGetSummaryRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      BrandDealServiceGetSummaryRequest._();
  @$core.override
  BrandDealServiceGetSummaryRequest createEmptyInstance() =>
      BrandDealServiceGetSummaryRequest._();
  @$core.pragma('dart2js:noInline')
  static BrandDealServiceGetSummaryRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<BrandDealServiceGetSummaryRequest>(
          BrandDealServiceGetSummaryRequest.$_createMessage);
  static BrandDealServiceGetSummaryRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get dealId => $_getSZ(1);
  @$pb.TagNumber(2)
  set dealId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasDealId() => $_has(1);
  @$pb.TagNumber(2)
  void clearDealId() => $_clearField(2);
}

class BrandDealServiceGetSummaryResponse extends $pb.GeneratedMessage {
  factory BrandDealServiceGetSummaryResponse({
    BrandDeal? deal,
  }) {
    final result = BrandDealServiceGetSummaryResponse._();
    if (deal != null) result.deal = deal;
    return result;
  }

  BrandDealServiceGetSummaryResponse._();

  factory BrandDealServiceGetSummaryResponse.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      BrandDealServiceGetSummaryResponse()..mergeFromBuffer(data, registry);
  factory BrandDealServiceGetSummaryResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      BrandDealServiceGetSummaryResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'BrandDealServiceGetSummaryResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: BrandDealServiceGetSummaryResponse.$_createMessage)
    ..aOM<BrandDeal>(1, _omitFieldNames ? '' : 'deal',
        subBuilder: BrandDeal.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BrandDealServiceGetSummaryResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BrandDealServiceGetSummaryResponse copyWith(
          void Function(BrandDealServiceGetSummaryResponse) updates) =>
      super.copyWith((message) =>
              updates(message as BrandDealServiceGetSummaryResponse))
          as BrandDealServiceGetSummaryResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use BrandDealServiceGetSummaryResponse() / BrandDealServiceGetSummaryResponse.new instead')
  static BrandDealServiceGetSummaryResponse create() =>
      BrandDealServiceGetSummaryResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      BrandDealServiceGetSummaryResponse._();
  @$core.override
  BrandDealServiceGetSummaryResponse createEmptyInstance() =>
      BrandDealServiceGetSummaryResponse._();
  @$core.pragma('dart2js:noInline')
  static BrandDealServiceGetSummaryResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<BrandDealServiceGetSummaryResponse>(
          BrandDealServiceGetSummaryResponse.$_createMessage);
  static BrandDealServiceGetSummaryResponse? _defaultInstance;

  @$pb.TagNumber(1)
  BrandDeal get deal => $_getN(0);
  @$pb.TagNumber(1)
  set deal(BrandDeal value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasDeal() => $_has(0);
  @$pb.TagNumber(1)
  void clearDeal() => $_clearField(1);
  @$pb.TagNumber(1)
  BrandDeal ensureDeal() => $_ensure(0);
}

class UpdateDeliverableRequest extends $pb.GeneratedMessage {
  factory UpdateDeliverableRequest({
    $core.String? workspaceId,
    $core.String? dealId,
    $core.String? deliverables,
    $core.String? proofPublishItemId,
  }) {
    final result = UpdateDeliverableRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (dealId != null) result.dealId = dealId;
    if (deliverables != null) result.deliverables = deliverables;
    if (proofPublishItemId != null)
      result.proofPublishItemId = proofPublishItemId;
    return result;
  }

  UpdateDeliverableRequest._();

  factory UpdateDeliverableRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      UpdateDeliverableRequest()..mergeFromBuffer(data, registry);
  factory UpdateDeliverableRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      UpdateDeliverableRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UpdateDeliverableRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: UpdateDeliverableRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'dealId')
    ..aOS(3, _omitFieldNames ? '' : 'deliverables')
    ..aOS(4, _omitFieldNames ? '' : 'proofPublishItemId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateDeliverableRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateDeliverableRequest copyWith(
          void Function(UpdateDeliverableRequest) updates) =>
      super.copyWith((message) => updates(message as UpdateDeliverableRequest))
          as UpdateDeliverableRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use UpdateDeliverableRequest() / UpdateDeliverableRequest.new instead')
  static UpdateDeliverableRequest create() => UpdateDeliverableRequest._();
  static $pb.GeneratedMessage $_createMessage() => UpdateDeliverableRequest._();
  @$core.override
  UpdateDeliverableRequest createEmptyInstance() =>
      UpdateDeliverableRequest._();
  @$core.pragma('dart2js:noInline')
  static UpdateDeliverableRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UpdateDeliverableRequest>(
          UpdateDeliverableRequest.$_createMessage);
  static UpdateDeliverableRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get dealId => $_getSZ(1);
  @$pb.TagNumber(2)
  set dealId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasDealId() => $_has(1);
  @$pb.TagNumber(2)
  void clearDealId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get deliverables => $_getSZ(2);
  @$pb.TagNumber(3)
  set deliverables($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasDeliverables() => $_has(2);
  @$pb.TagNumber(3)
  void clearDeliverables() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get proofPublishItemId => $_getSZ(3);
  @$pb.TagNumber(4)
  set proofPublishItemId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasProofPublishItemId() => $_has(3);
  @$pb.TagNumber(4)
  void clearProofPublishItemId() => $_clearField(4);
}

class UpdateDeliverableResponse extends $pb.GeneratedMessage {
  factory UpdateDeliverableResponse({
    BrandDeal? deal,
  }) {
    final result = UpdateDeliverableResponse._();
    if (deal != null) result.deal = deal;
    return result;
  }

  UpdateDeliverableResponse._();

  factory UpdateDeliverableResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      UpdateDeliverableResponse()..mergeFromBuffer(data, registry);
  factory UpdateDeliverableResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      UpdateDeliverableResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UpdateDeliverableResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: UpdateDeliverableResponse.$_createMessage)
    ..aOM<BrandDeal>(1, _omitFieldNames ? '' : 'deal',
        subBuilder: BrandDeal.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateDeliverableResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateDeliverableResponse copyWith(
          void Function(UpdateDeliverableResponse) updates) =>
      super.copyWith((message) => updates(message as UpdateDeliverableResponse))
          as UpdateDeliverableResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use UpdateDeliverableResponse() / UpdateDeliverableResponse.new instead')
  static UpdateDeliverableResponse create() => UpdateDeliverableResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      UpdateDeliverableResponse._();
  @$core.override
  UpdateDeliverableResponse createEmptyInstance() =>
      UpdateDeliverableResponse._();
  @$core.pragma('dart2js:noInline')
  static UpdateDeliverableResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UpdateDeliverableResponse>(
          UpdateDeliverableResponse.$_createMessage);
  static UpdateDeliverableResponse? _defaultInstance;

  @$pb.TagNumber(1)
  BrandDeal get deal => $_getN(0);
  @$pb.TagNumber(1)
  set deal(BrandDeal value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasDeal() => $_has(0);
  @$pb.TagNumber(1)
  void clearDeal() => $_clearField(1);
  @$pb.TagNumber(1)
  BrandDeal ensureDeal() => $_ensure(0);
}

class UpdatePaymentRequest extends $pb.GeneratedMessage {
  factory UpdatePaymentRequest({
    $core.String? workspaceId,
    $core.String? dealId,
    $core.double? amountPaid,
    $core.String? settlementReference,
  }) {
    final result = UpdatePaymentRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (dealId != null) result.dealId = dealId;
    if (amountPaid != null) result.amountPaid = amountPaid;
    if (settlementReference != null)
      result.settlementReference = settlementReference;
    return result;
  }

  UpdatePaymentRequest._();

  factory UpdatePaymentRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      UpdatePaymentRequest()..mergeFromBuffer(data, registry);
  factory UpdatePaymentRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      UpdatePaymentRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UpdatePaymentRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: UpdatePaymentRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'dealId')
    ..aD(3, _omitFieldNames ? '' : 'amountPaid')
    ..aOS(4, _omitFieldNames ? '' : 'settlementReference')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdatePaymentRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdatePaymentRequest copyWith(void Function(UpdatePaymentRequest) updates) =>
      super.copyWith((message) => updates(message as UpdatePaymentRequest))
          as UpdatePaymentRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use UpdatePaymentRequest() / UpdatePaymentRequest.new instead')
  static UpdatePaymentRequest create() => UpdatePaymentRequest._();
  static $pb.GeneratedMessage $_createMessage() => UpdatePaymentRequest._();
  @$core.override
  UpdatePaymentRequest createEmptyInstance() => UpdatePaymentRequest._();
  @$core.pragma('dart2js:noInline')
  static UpdatePaymentRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UpdatePaymentRequest>(
          UpdatePaymentRequest.$_createMessage);
  static UpdatePaymentRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get dealId => $_getSZ(1);
  @$pb.TagNumber(2)
  set dealId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasDealId() => $_has(1);
  @$pb.TagNumber(2)
  void clearDealId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.double get amountPaid => $_getN(2);
  @$pb.TagNumber(3)
  set amountPaid($core.double value) => $_setDouble(2, value);
  @$pb.TagNumber(3)
  $core.bool hasAmountPaid() => $_has(2);
  @$pb.TagNumber(3)
  void clearAmountPaid() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get settlementReference => $_getSZ(3);
  @$pb.TagNumber(4)
  set settlementReference($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasSettlementReference() => $_has(3);
  @$pb.TagNumber(4)
  void clearSettlementReference() => $_clearField(4);
}

class UpdatePaymentResponse extends $pb.GeneratedMessage {
  factory UpdatePaymentResponse({
    BrandDeal? deal,
  }) {
    final result = UpdatePaymentResponse._();
    if (deal != null) result.deal = deal;
    return result;
  }

  UpdatePaymentResponse._();

  factory UpdatePaymentResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      UpdatePaymentResponse()..mergeFromBuffer(data, registry);
  factory UpdatePaymentResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      UpdatePaymentResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UpdatePaymentResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: UpdatePaymentResponse.$_createMessage)
    ..aOM<BrandDeal>(1, _omitFieldNames ? '' : 'deal',
        subBuilder: BrandDeal.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdatePaymentResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdatePaymentResponse copyWith(
          void Function(UpdatePaymentResponse) updates) =>
      super.copyWith((message) => updates(message as UpdatePaymentResponse))
          as UpdatePaymentResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use UpdatePaymentResponse() / UpdatePaymentResponse.new instead')
  static UpdatePaymentResponse create() => UpdatePaymentResponse._();
  static $pb.GeneratedMessage $_createMessage() => UpdatePaymentResponse._();
  @$core.override
  UpdatePaymentResponse createEmptyInstance() => UpdatePaymentResponse._();
  @$core.pragma('dart2js:noInline')
  static UpdatePaymentResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UpdatePaymentResponse>(
          UpdatePaymentResponse.$_createMessage);
  static UpdatePaymentResponse? _defaultInstance;

  @$pb.TagNumber(1)
  BrandDeal get deal => $_getN(0);
  @$pb.TagNumber(1)
  set deal(BrandDeal value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasDeal() => $_has(0);
  @$pb.TagNumber(1)
  void clearDeal() => $_clearField(1);
  @$pb.TagNumber(1)
  BrandDeal ensureDeal() => $_ensure(0);
}

class ListContractTemplatesRequest extends $pb.GeneratedMessage {
  factory ListContractTemplatesRequest({
    $core.String? workspaceId,
  }) {
    final result = ListContractTemplatesRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    return result;
  }

  ListContractTemplatesRequest._();

  factory ListContractTemplatesRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListContractTemplatesRequest()..mergeFromBuffer(data, registry);
  factory ListContractTemplatesRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListContractTemplatesRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListContractTemplatesRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: ListContractTemplatesRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListContractTemplatesRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListContractTemplatesRequest copyWith(
          void Function(ListContractTemplatesRequest) updates) =>
      super.copyWith(
              (message) => updates(message as ListContractTemplatesRequest))
          as ListContractTemplatesRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ListContractTemplatesRequest() / ListContractTemplatesRequest.new instead')
  static ListContractTemplatesRequest create() =>
      ListContractTemplatesRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      ListContractTemplatesRequest._();
  @$core.override
  ListContractTemplatesRequest createEmptyInstance() =>
      ListContractTemplatesRequest._();
  @$core.pragma('dart2js:noInline')
  static ListContractTemplatesRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListContractTemplatesRequest>(
          ListContractTemplatesRequest.$_createMessage);
  static ListContractTemplatesRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);
}

class ContractTemplate extends $pb.GeneratedMessage {
  factory ContractTemplate({
    $core.String? templateId,
    $core.String? title,
    $core.String? description,
    $core.String? defaultTerms,
  }) {
    final result = ContractTemplate._();
    if (templateId != null) result.templateId = templateId;
    if (title != null) result.title = title;
    if (description != null) result.description = description;
    if (defaultTerms != null) result.defaultTerms = defaultTerms;
    return result;
  }

  ContractTemplate._();

  factory ContractTemplate.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ContractTemplate()..mergeFromBuffer(data, registry);
  factory ContractTemplate.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ContractTemplate()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ContractTemplate',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: ContractTemplate.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'templateId')
    ..aOS(2, _omitFieldNames ? '' : 'title')
    ..aOS(3, _omitFieldNames ? '' : 'description')
    ..aOS(4, _omitFieldNames ? '' : 'defaultTerms')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ContractTemplate clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ContractTemplate copyWith(void Function(ContractTemplate) updates) =>
      super.copyWith((message) => updates(message as ContractTemplate))
          as ContractTemplate;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ContractTemplate() / ContractTemplate.new instead')
  static ContractTemplate create() => ContractTemplate._();
  static $pb.GeneratedMessage $_createMessage() => ContractTemplate._();
  @$core.override
  ContractTemplate createEmptyInstance() => ContractTemplate._();
  @$core.pragma('dart2js:noInline')
  static ContractTemplate getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ContractTemplate>(
          ContractTemplate.$_createMessage);
  static ContractTemplate? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get templateId => $_getSZ(0);
  @$pb.TagNumber(1)
  set templateId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTemplateId() => $_has(0);
  @$pb.TagNumber(1)
  void clearTemplateId() => $_clearField(1);

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
  $core.String get defaultTerms => $_getSZ(3);
  @$pb.TagNumber(4)
  set defaultTerms($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasDefaultTerms() => $_has(3);
  @$pb.TagNumber(4)
  void clearDefaultTerms() => $_clearField(4);
}

class ListContractTemplatesResponse extends $pb.GeneratedMessage {
  factory ListContractTemplatesResponse({
    $core.Iterable<ContractTemplate>? templates,
  }) {
    final result = ListContractTemplatesResponse._();
    if (templates != null) result.templates.addAll(templates);
    return result;
  }

  ListContractTemplatesResponse._();

  factory ListContractTemplatesResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListContractTemplatesResponse()..mergeFromBuffer(data, registry);
  factory ListContractTemplatesResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListContractTemplatesResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListContractTemplatesResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: ListContractTemplatesResponse.$_createMessage)
    ..pPM<ContractTemplate>(1, _omitFieldNames ? '' : 'templates',
        subBuilder: ContractTemplate.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListContractTemplatesResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListContractTemplatesResponse copyWith(
          void Function(ListContractTemplatesResponse) updates) =>
      super.copyWith(
              (message) => updates(message as ListContractTemplatesResponse))
          as ListContractTemplatesResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ListContractTemplatesResponse() / ListContractTemplatesResponse.new instead')
  static ListContractTemplatesResponse create() =>
      ListContractTemplatesResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      ListContractTemplatesResponse._();
  @$core.override
  ListContractTemplatesResponse createEmptyInstance() =>
      ListContractTemplatesResponse._();
  @$core.pragma('dart2js:noInline')
  static ListContractTemplatesResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListContractTemplatesResponse>(
          ListContractTemplatesResponse.$_createMessage);
  static ListContractTemplatesResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<ContractTemplate> get templates => $_getList(0);
}

class AttachContractRequest extends $pb.GeneratedMessage {
  factory AttachContractRequest({
    $core.String? workspaceId,
    $core.String? dealId,
    $core.String? evidenceId,
  }) {
    final result = AttachContractRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (dealId != null) result.dealId = dealId;
    if (evidenceId != null) result.evidenceId = evidenceId;
    return result;
  }

  AttachContractRequest._();

  factory AttachContractRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      AttachContractRequest()..mergeFromBuffer(data, registry);
  factory AttachContractRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      AttachContractRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AttachContractRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: AttachContractRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'dealId')
    ..aOS(3, _omitFieldNames ? '' : 'evidenceId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AttachContractRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AttachContractRequest copyWith(
          void Function(AttachContractRequest) updates) =>
      super.copyWith((message) => updates(message as AttachContractRequest))
          as AttachContractRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use AttachContractRequest() / AttachContractRequest.new instead')
  static AttachContractRequest create() => AttachContractRequest._();
  static $pb.GeneratedMessage $_createMessage() => AttachContractRequest._();
  @$core.override
  AttachContractRequest createEmptyInstance() => AttachContractRequest._();
  @$core.pragma('dart2js:noInline')
  static AttachContractRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AttachContractRequest>(
          AttachContractRequest.$_createMessage);
  static AttachContractRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get dealId => $_getSZ(1);
  @$pb.TagNumber(2)
  set dealId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasDealId() => $_has(1);
  @$pb.TagNumber(2)
  void clearDealId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get evidenceId => $_getSZ(2);
  @$pb.TagNumber(3)
  set evidenceId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasEvidenceId() => $_has(2);
  @$pb.TagNumber(3)
  void clearEvidenceId() => $_clearField(3);
}

class AttachContractResponse extends $pb.GeneratedMessage {
  factory AttachContractResponse({
    BrandDeal? deal,
  }) {
    final result = AttachContractResponse._();
    if (deal != null) result.deal = deal;
    return result;
  }

  AttachContractResponse._();

  factory AttachContractResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      AttachContractResponse()..mergeFromBuffer(data, registry);
  factory AttachContractResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      AttachContractResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AttachContractResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: AttachContractResponse.$_createMessage)
    ..aOM<BrandDeal>(1, _omitFieldNames ? '' : 'deal',
        subBuilder: BrandDeal.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AttachContractResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AttachContractResponse copyWith(
          void Function(AttachContractResponse) updates) =>
      super.copyWith((message) => updates(message as AttachContractResponse))
          as AttachContractResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use AttachContractResponse() / AttachContractResponse.new instead')
  static AttachContractResponse create() => AttachContractResponse._();
  static $pb.GeneratedMessage $_createMessage() => AttachContractResponse._();
  @$core.override
  AttachContractResponse createEmptyInstance() => AttachContractResponse._();
  @$core.pragma('dart2js:noInline')
  static AttachContractResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AttachContractResponse>(
          AttachContractResponse.$_createMessage);
  static AttachContractResponse? _defaultInstance;

  @$pb.TagNumber(1)
  BrandDeal get deal => $_getN(0);
  @$pb.TagNumber(1)
  set deal(BrandDeal value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasDeal() => $_has(0);
  @$pb.TagNumber(1)
  void clearDeal() => $_clearField(1);
  @$pb.TagNumber(1)
  BrandDeal ensureDeal() => $_ensure(0);
}

class ListInquiriesRequest extends $pb.GeneratedMessage {
  factory ListInquiriesRequest({
    $core.String? workspaceId,
  }) {
    final result = ListInquiriesRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    return result;
  }

  ListInquiriesRequest._();

  factory ListInquiriesRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListInquiriesRequest()..mergeFromBuffer(data, registry);
  factory ListInquiriesRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListInquiriesRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListInquiriesRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: ListInquiriesRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListInquiriesRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListInquiriesRequest copyWith(void Function(ListInquiriesRequest) updates) =>
      super.copyWith((message) => updates(message as ListInquiriesRequest))
          as ListInquiriesRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ListInquiriesRequest() / ListInquiriesRequest.new instead')
  static ListInquiriesRequest create() => ListInquiriesRequest._();
  static $pb.GeneratedMessage $_createMessage() => ListInquiriesRequest._();
  @$core.override
  ListInquiriesRequest createEmptyInstance() => ListInquiriesRequest._();
  @$core.pragma('dart2js:noInline')
  static ListInquiriesRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListInquiriesRequest>(
          ListInquiriesRequest.$_createMessage);
  static ListInquiriesRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);
}

class SponsorInquiry extends $pb.GeneratedMessage {
  factory SponsorInquiry({
    $core.String? inquiryId,
    $core.String? workspaceId,
    $core.String? brandName,
    $core.String? contactEmail,
    $core.String? message,
    $core.double? estimatedBudget,
    $core.String? status,
    $core.String? threadId,
    $1.Timestamp? receivedAt,
  }) {
    final result = SponsorInquiry._();
    if (inquiryId != null) result.inquiryId = inquiryId;
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (brandName != null) result.brandName = brandName;
    if (contactEmail != null) result.contactEmail = contactEmail;
    if (message != null) result.message = message;
    if (estimatedBudget != null) result.estimatedBudget = estimatedBudget;
    if (status != null) result.status = status;
    if (threadId != null) result.threadId = threadId;
    if (receivedAt != null) result.receivedAt = receivedAt;
    return result;
  }

  SponsorInquiry._();

  factory SponsorInquiry.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SponsorInquiry()..mergeFromBuffer(data, registry);
  factory SponsorInquiry.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SponsorInquiry()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SponsorInquiry',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: SponsorInquiry.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'inquiryId')
    ..aOS(2, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(3, _omitFieldNames ? '' : 'brandName')
    ..aOS(4, _omitFieldNames ? '' : 'contactEmail')
    ..aOS(5, _omitFieldNames ? '' : 'message')
    ..aD(6, _omitFieldNames ? '' : 'estimatedBudget')
    ..aOS(7, _omitFieldNames ? '' : 'status')
    ..aOS(8, _omitFieldNames ? '' : 'threadId')
    ..aOM<$1.Timestamp>(9, _omitFieldNames ? '' : 'receivedAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SponsorInquiry clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SponsorInquiry copyWith(void Function(SponsorInquiry) updates) =>
      super.copyWith((message) => updates(message as SponsorInquiry))
          as SponsorInquiry;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use SponsorInquiry() / SponsorInquiry.new instead')
  static SponsorInquiry create() => SponsorInquiry._();
  static $pb.GeneratedMessage $_createMessage() => SponsorInquiry._();
  @$core.override
  SponsorInquiry createEmptyInstance() => SponsorInquiry._();
  @$core.pragma('dart2js:noInline')
  static SponsorInquiry getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SponsorInquiry>(
          SponsorInquiry.$_createMessage);
  static SponsorInquiry? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get inquiryId => $_getSZ(0);
  @$pb.TagNumber(1)
  set inquiryId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasInquiryId() => $_has(0);
  @$pb.TagNumber(1)
  void clearInquiryId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get workspaceId => $_getSZ(1);
  @$pb.TagNumber(2)
  set workspaceId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasWorkspaceId() => $_has(1);
  @$pb.TagNumber(2)
  void clearWorkspaceId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get brandName => $_getSZ(2);
  @$pb.TagNumber(3)
  set brandName($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasBrandName() => $_has(2);
  @$pb.TagNumber(3)
  void clearBrandName() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get contactEmail => $_getSZ(3);
  @$pb.TagNumber(4)
  set contactEmail($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasContactEmail() => $_has(3);
  @$pb.TagNumber(4)
  void clearContactEmail() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get message => $_getSZ(4);
  @$pb.TagNumber(5)
  set message($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasMessage() => $_has(4);
  @$pb.TagNumber(5)
  void clearMessage() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.double get estimatedBudget => $_getN(5);
  @$pb.TagNumber(6)
  set estimatedBudget($core.double value) => $_setDouble(5, value);
  @$pb.TagNumber(6)
  $core.bool hasEstimatedBudget() => $_has(5);
  @$pb.TagNumber(6)
  void clearEstimatedBudget() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get status => $_getSZ(6);
  @$pb.TagNumber(7)
  set status($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasStatus() => $_has(6);
  @$pb.TagNumber(7)
  void clearStatus() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get threadId => $_getSZ(7);
  @$pb.TagNumber(8)
  set threadId($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasThreadId() => $_has(7);
  @$pb.TagNumber(8)
  void clearThreadId() => $_clearField(8);

  @$pb.TagNumber(9)
  $1.Timestamp get receivedAt => $_getN(8);
  @$pb.TagNumber(9)
  set receivedAt($1.Timestamp value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasReceivedAt() => $_has(8);
  @$pb.TagNumber(9)
  void clearReceivedAt() => $_clearField(9);
  @$pb.TagNumber(9)
  $1.Timestamp ensureReceivedAt() => $_ensure(8);
}

class ListInquiriesResponse extends $pb.GeneratedMessage {
  factory ListInquiriesResponse({
    $core.Iterable<SponsorInquiry>? inquiries,
  }) {
    final result = ListInquiriesResponse._();
    if (inquiries != null) result.inquiries.addAll(inquiries);
    return result;
  }

  ListInquiriesResponse._();

  factory ListInquiriesResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListInquiriesResponse()..mergeFromBuffer(data, registry);
  factory ListInquiriesResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListInquiriesResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListInquiriesResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: ListInquiriesResponse.$_createMessage)
    ..pPM<SponsorInquiry>(1, _omitFieldNames ? '' : 'inquiries',
        subBuilder: SponsorInquiry.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListInquiriesResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListInquiriesResponse copyWith(
          void Function(ListInquiriesResponse) updates) =>
      super.copyWith((message) => updates(message as ListInquiriesResponse))
          as ListInquiriesResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ListInquiriesResponse() / ListInquiriesResponse.new instead')
  static ListInquiriesResponse create() => ListInquiriesResponse._();
  static $pb.GeneratedMessage $_createMessage() => ListInquiriesResponse._();
  @$core.override
  ListInquiriesResponse createEmptyInstance() => ListInquiriesResponse._();
  @$core.pragma('dart2js:noInline')
  static ListInquiriesResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListInquiriesResponse>(
          ListInquiriesResponse.$_createMessage);
  static ListInquiriesResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<SponsorInquiry> get inquiries => $_getList(0);
}

class SponsorInquiryServiceAcceptRequest extends $pb.GeneratedMessage {
  factory SponsorInquiryServiceAcceptRequest({
    $core.String? workspaceId,
    $core.String? inquiryId,
    $core.String? dealType,
    $core.double? agreedValue,
  }) {
    final result = SponsorInquiryServiceAcceptRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (inquiryId != null) result.inquiryId = inquiryId;
    if (dealType != null) result.dealType = dealType;
    if (agreedValue != null) result.agreedValue = agreedValue;
    return result;
  }

  SponsorInquiryServiceAcceptRequest._();

  factory SponsorInquiryServiceAcceptRequest.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SponsorInquiryServiceAcceptRequest()..mergeFromBuffer(data, registry);
  factory SponsorInquiryServiceAcceptRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SponsorInquiryServiceAcceptRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SponsorInquiryServiceAcceptRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: SponsorInquiryServiceAcceptRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'inquiryId')
    ..aOS(3, _omitFieldNames ? '' : 'dealType')
    ..aD(4, _omitFieldNames ? '' : 'agreedValue')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SponsorInquiryServiceAcceptRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SponsorInquiryServiceAcceptRequest copyWith(
          void Function(SponsorInquiryServiceAcceptRequest) updates) =>
      super.copyWith((message) =>
              updates(message as SponsorInquiryServiceAcceptRequest))
          as SponsorInquiryServiceAcceptRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use SponsorInquiryServiceAcceptRequest() / SponsorInquiryServiceAcceptRequest.new instead')
  static SponsorInquiryServiceAcceptRequest create() =>
      SponsorInquiryServiceAcceptRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      SponsorInquiryServiceAcceptRequest._();
  @$core.override
  SponsorInquiryServiceAcceptRequest createEmptyInstance() =>
      SponsorInquiryServiceAcceptRequest._();
  @$core.pragma('dart2js:noInline')
  static SponsorInquiryServiceAcceptRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SponsorInquiryServiceAcceptRequest>(
          SponsorInquiryServiceAcceptRequest.$_createMessage);
  static SponsorInquiryServiceAcceptRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get inquiryId => $_getSZ(1);
  @$pb.TagNumber(2)
  set inquiryId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasInquiryId() => $_has(1);
  @$pb.TagNumber(2)
  void clearInquiryId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get dealType => $_getSZ(2);
  @$pb.TagNumber(3)
  set dealType($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasDealType() => $_has(2);
  @$pb.TagNumber(3)
  void clearDealType() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.double get agreedValue => $_getN(3);
  @$pb.TagNumber(4)
  set agreedValue($core.double value) => $_setDouble(3, value);
  @$pb.TagNumber(4)
  $core.bool hasAgreedValue() => $_has(3);
  @$pb.TagNumber(4)
  void clearAgreedValue() => $_clearField(4);
}

class SponsorInquiryServiceAcceptResponse extends $pb.GeneratedMessage {
  factory SponsorInquiryServiceAcceptResponse({
    SponsorInquiry? inquiry,
    BrandDeal? deal,
  }) {
    final result = SponsorInquiryServiceAcceptResponse._();
    if (inquiry != null) result.inquiry = inquiry;
    if (deal != null) result.deal = deal;
    return result;
  }

  SponsorInquiryServiceAcceptResponse._();

  factory SponsorInquiryServiceAcceptResponse.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SponsorInquiryServiceAcceptResponse()..mergeFromBuffer(data, registry);
  factory SponsorInquiryServiceAcceptResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SponsorInquiryServiceAcceptResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SponsorInquiryServiceAcceptResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: SponsorInquiryServiceAcceptResponse.$_createMessage)
    ..aOM<SponsorInquiry>(1, _omitFieldNames ? '' : 'inquiry',
        subBuilder: SponsorInquiry.$_createMessage)
    ..aOM<BrandDeal>(2, _omitFieldNames ? '' : 'deal',
        subBuilder: BrandDeal.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SponsorInquiryServiceAcceptResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SponsorInquiryServiceAcceptResponse copyWith(
          void Function(SponsorInquiryServiceAcceptResponse) updates) =>
      super.copyWith((message) =>
              updates(message as SponsorInquiryServiceAcceptResponse))
          as SponsorInquiryServiceAcceptResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use SponsorInquiryServiceAcceptResponse() / SponsorInquiryServiceAcceptResponse.new instead')
  static SponsorInquiryServiceAcceptResponse create() =>
      SponsorInquiryServiceAcceptResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      SponsorInquiryServiceAcceptResponse._();
  @$core.override
  SponsorInquiryServiceAcceptResponse createEmptyInstance() =>
      SponsorInquiryServiceAcceptResponse._();
  @$core.pragma('dart2js:noInline')
  static SponsorInquiryServiceAcceptResponse getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
              SponsorInquiryServiceAcceptResponse>(
          SponsorInquiryServiceAcceptResponse.$_createMessage);
  static SponsorInquiryServiceAcceptResponse? _defaultInstance;

  @$pb.TagNumber(1)
  SponsorInquiry get inquiry => $_getN(0);
  @$pb.TagNumber(1)
  set inquiry(SponsorInquiry value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasInquiry() => $_has(0);
  @$pb.TagNumber(1)
  void clearInquiry() => $_clearField(1);
  @$pb.TagNumber(1)
  SponsorInquiry ensureInquiry() => $_ensure(0);

  @$pb.TagNumber(2)
  BrandDeal get deal => $_getN(1);
  @$pb.TagNumber(2)
  set deal(BrandDeal value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasDeal() => $_has(1);
  @$pb.TagNumber(2)
  void clearDeal() => $_clearField(2);
  @$pb.TagNumber(2)
  BrandDeal ensureDeal() => $_ensure(1);
}

class SponsorInquiryServiceDeclineRequest extends $pb.GeneratedMessage {
  factory SponsorInquiryServiceDeclineRequest({
    $core.String? workspaceId,
    $core.String? inquiryId,
    $core.String? reason,
  }) {
    final result = SponsorInquiryServiceDeclineRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (inquiryId != null) result.inquiryId = inquiryId;
    if (reason != null) result.reason = reason;
    return result;
  }

  SponsorInquiryServiceDeclineRequest._();

  factory SponsorInquiryServiceDeclineRequest.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SponsorInquiryServiceDeclineRequest()..mergeFromBuffer(data, registry);
  factory SponsorInquiryServiceDeclineRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SponsorInquiryServiceDeclineRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SponsorInquiryServiceDeclineRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: SponsorInquiryServiceDeclineRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'inquiryId')
    ..aOS(3, _omitFieldNames ? '' : 'reason')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SponsorInquiryServiceDeclineRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SponsorInquiryServiceDeclineRequest copyWith(
          void Function(SponsorInquiryServiceDeclineRequest) updates) =>
      super.copyWith((message) =>
              updates(message as SponsorInquiryServiceDeclineRequest))
          as SponsorInquiryServiceDeclineRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use SponsorInquiryServiceDeclineRequest() / SponsorInquiryServiceDeclineRequest.new instead')
  static SponsorInquiryServiceDeclineRequest create() =>
      SponsorInquiryServiceDeclineRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      SponsorInquiryServiceDeclineRequest._();
  @$core.override
  SponsorInquiryServiceDeclineRequest createEmptyInstance() =>
      SponsorInquiryServiceDeclineRequest._();
  @$core.pragma('dart2js:noInline')
  static SponsorInquiryServiceDeclineRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
              SponsorInquiryServiceDeclineRequest>(
          SponsorInquiryServiceDeclineRequest.$_createMessage);
  static SponsorInquiryServiceDeclineRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get inquiryId => $_getSZ(1);
  @$pb.TagNumber(2)
  set inquiryId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasInquiryId() => $_has(1);
  @$pb.TagNumber(2)
  void clearInquiryId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get reason => $_getSZ(2);
  @$pb.TagNumber(3)
  set reason($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasReason() => $_has(2);
  @$pb.TagNumber(3)
  void clearReason() => $_clearField(3);
}

class SponsorInquiryServiceDeclineResponse extends $pb.GeneratedMessage {
  factory SponsorInquiryServiceDeclineResponse({
    SponsorInquiry? inquiry,
  }) {
    final result = SponsorInquiryServiceDeclineResponse._();
    if (inquiry != null) result.inquiry = inquiry;
    return result;
  }

  SponsorInquiryServiceDeclineResponse._();

  factory SponsorInquiryServiceDeclineResponse.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SponsorInquiryServiceDeclineResponse()..mergeFromBuffer(data, registry);
  factory SponsorInquiryServiceDeclineResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SponsorInquiryServiceDeclineResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SponsorInquiryServiceDeclineResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: SponsorInquiryServiceDeclineResponse.$_createMessage)
    ..aOM<SponsorInquiry>(1, _omitFieldNames ? '' : 'inquiry',
        subBuilder: SponsorInquiry.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SponsorInquiryServiceDeclineResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SponsorInquiryServiceDeclineResponse copyWith(
          void Function(SponsorInquiryServiceDeclineResponse) updates) =>
      super.copyWith((message) =>
              updates(message as SponsorInquiryServiceDeclineResponse))
          as SponsorInquiryServiceDeclineResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use SponsorInquiryServiceDeclineResponse() / SponsorInquiryServiceDeclineResponse.new instead')
  static SponsorInquiryServiceDeclineResponse create() =>
      SponsorInquiryServiceDeclineResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      SponsorInquiryServiceDeclineResponse._();
  @$core.override
  SponsorInquiryServiceDeclineResponse createEmptyInstance() =>
      SponsorInquiryServiceDeclineResponse._();
  @$core.pragma('dart2js:noInline')
  static SponsorInquiryServiceDeclineResponse getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
              SponsorInquiryServiceDeclineResponse>(
          SponsorInquiryServiceDeclineResponse.$_createMessage);
  static SponsorInquiryServiceDeclineResponse? _defaultInstance;

  @$pb.TagNumber(1)
  SponsorInquiry get inquiry => $_getN(0);
  @$pb.TagNumber(1)
  set inquiry(SponsorInquiry value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasInquiry() => $_has(0);
  @$pb.TagNumber(1)
  void clearInquiry() => $_clearField(1);
  @$pb.TagNumber(1)
  SponsorInquiry ensureInquiry() => $_ensure(0);
}

class SponsorInquiryServiceFlagRequest extends $pb.GeneratedMessage {
  factory SponsorInquiryServiceFlagRequest({
    $core.String? workspaceId,
    $core.String? inquiryId,
    $core.String? flagReason,
  }) {
    final result = SponsorInquiryServiceFlagRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (inquiryId != null) result.inquiryId = inquiryId;
    if (flagReason != null) result.flagReason = flagReason;
    return result;
  }

  SponsorInquiryServiceFlagRequest._();

  factory SponsorInquiryServiceFlagRequest.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SponsorInquiryServiceFlagRequest()..mergeFromBuffer(data, registry);
  factory SponsorInquiryServiceFlagRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SponsorInquiryServiceFlagRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SponsorInquiryServiceFlagRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: SponsorInquiryServiceFlagRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'inquiryId')
    ..aOS(3, _omitFieldNames ? '' : 'flagReason')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SponsorInquiryServiceFlagRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SponsorInquiryServiceFlagRequest copyWith(
          void Function(SponsorInquiryServiceFlagRequest) updates) =>
      super.copyWith(
              (message) => updates(message as SponsorInquiryServiceFlagRequest))
          as SponsorInquiryServiceFlagRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use SponsorInquiryServiceFlagRequest() / SponsorInquiryServiceFlagRequest.new instead')
  static SponsorInquiryServiceFlagRequest create() =>
      SponsorInquiryServiceFlagRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      SponsorInquiryServiceFlagRequest._();
  @$core.override
  SponsorInquiryServiceFlagRequest createEmptyInstance() =>
      SponsorInquiryServiceFlagRequest._();
  @$core.pragma('dart2js:noInline')
  static SponsorInquiryServiceFlagRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SponsorInquiryServiceFlagRequest>(
          SponsorInquiryServiceFlagRequest.$_createMessage);
  static SponsorInquiryServiceFlagRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get inquiryId => $_getSZ(1);
  @$pb.TagNumber(2)
  set inquiryId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasInquiryId() => $_has(1);
  @$pb.TagNumber(2)
  void clearInquiryId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get flagReason => $_getSZ(2);
  @$pb.TagNumber(3)
  set flagReason($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasFlagReason() => $_has(2);
  @$pb.TagNumber(3)
  void clearFlagReason() => $_clearField(3);
}

class SponsorInquiryServiceFlagResponse extends $pb.GeneratedMessage {
  factory SponsorInquiryServiceFlagResponse({
    SponsorInquiry? inquiry,
  }) {
    final result = SponsorInquiryServiceFlagResponse._();
    if (inquiry != null) result.inquiry = inquiry;
    return result;
  }

  SponsorInquiryServiceFlagResponse._();

  factory SponsorInquiryServiceFlagResponse.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SponsorInquiryServiceFlagResponse()..mergeFromBuffer(data, registry);
  factory SponsorInquiryServiceFlagResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SponsorInquiryServiceFlagResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SponsorInquiryServiceFlagResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: SponsorInquiryServiceFlagResponse.$_createMessage)
    ..aOM<SponsorInquiry>(1, _omitFieldNames ? '' : 'inquiry',
        subBuilder: SponsorInquiry.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SponsorInquiryServiceFlagResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SponsorInquiryServiceFlagResponse copyWith(
          void Function(SponsorInquiryServiceFlagResponse) updates) =>
      super.copyWith((message) =>
              updates(message as SponsorInquiryServiceFlagResponse))
          as SponsorInquiryServiceFlagResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use SponsorInquiryServiceFlagResponse() / SponsorInquiryServiceFlagResponse.new instead')
  static SponsorInquiryServiceFlagResponse create() =>
      SponsorInquiryServiceFlagResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      SponsorInquiryServiceFlagResponse._();
  @$core.override
  SponsorInquiryServiceFlagResponse createEmptyInstance() =>
      SponsorInquiryServiceFlagResponse._();
  @$core.pragma('dart2js:noInline')
  static SponsorInquiryServiceFlagResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SponsorInquiryServiceFlagResponse>(
          SponsorInquiryServiceFlagResponse.$_createMessage);
  static SponsorInquiryServiceFlagResponse? _defaultInstance;

  @$pb.TagNumber(1)
  SponsorInquiry get inquiry => $_getN(0);
  @$pb.TagNumber(1)
  set inquiry(SponsorInquiry value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasInquiry() => $_has(0);
  @$pb.TagNumber(1)
  void clearInquiry() => $_clearField(1);
  @$pb.TagNumber(1)
  SponsorInquiry ensureInquiry() => $_ensure(0);
}

class SponsorInquiryServiceGetStatsRequest extends $pb.GeneratedMessage {
  factory SponsorInquiryServiceGetStatsRequest({
    $core.String? workspaceId,
  }) {
    final result = SponsorInquiryServiceGetStatsRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    return result;
  }

  SponsorInquiryServiceGetStatsRequest._();

  factory SponsorInquiryServiceGetStatsRequest.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SponsorInquiryServiceGetStatsRequest()..mergeFromBuffer(data, registry);
  factory SponsorInquiryServiceGetStatsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SponsorInquiryServiceGetStatsRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SponsorInquiryServiceGetStatsRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: SponsorInquiryServiceGetStatsRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SponsorInquiryServiceGetStatsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SponsorInquiryServiceGetStatsRequest copyWith(
          void Function(SponsorInquiryServiceGetStatsRequest) updates) =>
      super.copyWith((message) =>
              updates(message as SponsorInquiryServiceGetStatsRequest))
          as SponsorInquiryServiceGetStatsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use SponsorInquiryServiceGetStatsRequest() / SponsorInquiryServiceGetStatsRequest.new instead')
  static SponsorInquiryServiceGetStatsRequest create() =>
      SponsorInquiryServiceGetStatsRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      SponsorInquiryServiceGetStatsRequest._();
  @$core.override
  SponsorInquiryServiceGetStatsRequest createEmptyInstance() =>
      SponsorInquiryServiceGetStatsRequest._();
  @$core.pragma('dart2js:noInline')
  static SponsorInquiryServiceGetStatsRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
              SponsorInquiryServiceGetStatsRequest>(
          SponsorInquiryServiceGetStatsRequest.$_createMessage);
  static SponsorInquiryServiceGetStatsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);
}

class SponsorInquiryServiceGetStatsResponse extends $pb.GeneratedMessage {
  factory SponsorInquiryServiceGetStatsResponse({
    $core.int? totalInquiries,
    $core.int? pendingInquiries,
    $core.int? convertedInquiries,
    $core.int? declinedInquiries,
  }) {
    final result = SponsorInquiryServiceGetStatsResponse._();
    if (totalInquiries != null) result.totalInquiries = totalInquiries;
    if (pendingInquiries != null) result.pendingInquiries = pendingInquiries;
    if (convertedInquiries != null)
      result.convertedInquiries = convertedInquiries;
    if (declinedInquiries != null) result.declinedInquiries = declinedInquiries;
    return result;
  }

  SponsorInquiryServiceGetStatsResponse._();

  factory SponsorInquiryServiceGetStatsResponse.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SponsorInquiryServiceGetStatsResponse()..mergeFromBuffer(data, registry);
  factory SponsorInquiryServiceGetStatsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SponsorInquiryServiceGetStatsResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SponsorInquiryServiceGetStatsResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance:
          SponsorInquiryServiceGetStatsResponse.$_createMessage)
    ..aI(1, _omitFieldNames ? '' : 'totalInquiries')
    ..aI(2, _omitFieldNames ? '' : 'pendingInquiries')
    ..aI(3, _omitFieldNames ? '' : 'convertedInquiries')
    ..aI(4, _omitFieldNames ? '' : 'declinedInquiries')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SponsorInquiryServiceGetStatsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SponsorInquiryServiceGetStatsResponse copyWith(
          void Function(SponsorInquiryServiceGetStatsResponse) updates) =>
      super.copyWith((message) =>
              updates(message as SponsorInquiryServiceGetStatsResponse))
          as SponsorInquiryServiceGetStatsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use SponsorInquiryServiceGetStatsResponse() / SponsorInquiryServiceGetStatsResponse.new instead')
  static SponsorInquiryServiceGetStatsResponse create() =>
      SponsorInquiryServiceGetStatsResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      SponsorInquiryServiceGetStatsResponse._();
  @$core.override
  SponsorInquiryServiceGetStatsResponse createEmptyInstance() =>
      SponsorInquiryServiceGetStatsResponse._();
  @$core.pragma('dart2js:noInline')
  static SponsorInquiryServiceGetStatsResponse getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
              SponsorInquiryServiceGetStatsResponse>(
          SponsorInquiryServiceGetStatsResponse.$_createMessage);
  static SponsorInquiryServiceGetStatsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get totalInquiries => $_getIZ(0);
  @$pb.TagNumber(1)
  set totalInquiries($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTotalInquiries() => $_has(0);
  @$pb.TagNumber(1)
  void clearTotalInquiries() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get pendingInquiries => $_getIZ(1);
  @$pb.TagNumber(2)
  set pendingInquiries($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPendingInquiries() => $_has(1);
  @$pb.TagNumber(2)
  void clearPendingInquiries() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get convertedInquiries => $_getIZ(2);
  @$pb.TagNumber(3)
  set convertedInquiries($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasConvertedInquiries() => $_has(2);
  @$pb.TagNumber(3)
  void clearConvertedInquiries() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get declinedInquiries => $_getIZ(3);
  @$pb.TagNumber(4)
  set declinedInquiries($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasDeclinedInquiries() => $_has(3);
  @$pb.TagNumber(4)
  void clearDeclinedInquiries() => $_clearField(4);
}

class SponsorInquiryServiceSubmitRequest extends $pb.GeneratedMessage {
  factory SponsorInquiryServiceSubmitRequest({
    $core.String? workspaceId,
    $core.String? brandName,
    $core.String? contactEmail,
    $core.String? message,
    $core.double? proposedBudget,
  }) {
    final result = SponsorInquiryServiceSubmitRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (brandName != null) result.brandName = brandName;
    if (contactEmail != null) result.contactEmail = contactEmail;
    if (message != null) result.message = message;
    if (proposedBudget != null) result.proposedBudget = proposedBudget;
    return result;
  }

  SponsorInquiryServiceSubmitRequest._();

  factory SponsorInquiryServiceSubmitRequest.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SponsorInquiryServiceSubmitRequest()..mergeFromBuffer(data, registry);
  factory SponsorInquiryServiceSubmitRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SponsorInquiryServiceSubmitRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SponsorInquiryServiceSubmitRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: SponsorInquiryServiceSubmitRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'brandName')
    ..aOS(3, _omitFieldNames ? '' : 'contactEmail')
    ..aOS(4, _omitFieldNames ? '' : 'message')
    ..aD(5, _omitFieldNames ? '' : 'proposedBudget')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SponsorInquiryServiceSubmitRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SponsorInquiryServiceSubmitRequest copyWith(
          void Function(SponsorInquiryServiceSubmitRequest) updates) =>
      super.copyWith((message) =>
              updates(message as SponsorInquiryServiceSubmitRequest))
          as SponsorInquiryServiceSubmitRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use SponsorInquiryServiceSubmitRequest() / SponsorInquiryServiceSubmitRequest.new instead')
  static SponsorInquiryServiceSubmitRequest create() =>
      SponsorInquiryServiceSubmitRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      SponsorInquiryServiceSubmitRequest._();
  @$core.override
  SponsorInquiryServiceSubmitRequest createEmptyInstance() =>
      SponsorInquiryServiceSubmitRequest._();
  @$core.pragma('dart2js:noInline')
  static SponsorInquiryServiceSubmitRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SponsorInquiryServiceSubmitRequest>(
          SponsorInquiryServiceSubmitRequest.$_createMessage);
  static SponsorInquiryServiceSubmitRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get brandName => $_getSZ(1);
  @$pb.TagNumber(2)
  set brandName($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasBrandName() => $_has(1);
  @$pb.TagNumber(2)
  void clearBrandName() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get contactEmail => $_getSZ(2);
  @$pb.TagNumber(3)
  set contactEmail($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasContactEmail() => $_has(2);
  @$pb.TagNumber(3)
  void clearContactEmail() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get message => $_getSZ(3);
  @$pb.TagNumber(4)
  set message($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasMessage() => $_has(3);
  @$pb.TagNumber(4)
  void clearMessage() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.double get proposedBudget => $_getN(4);
  @$pb.TagNumber(5)
  set proposedBudget($core.double value) => $_setDouble(4, value);
  @$pb.TagNumber(5)
  $core.bool hasProposedBudget() => $_has(4);
  @$pb.TagNumber(5)
  void clearProposedBudget() => $_clearField(5);
}

class SponsorInquiryServiceSubmitResponse extends $pb.GeneratedMessage {
  factory SponsorInquiryServiceSubmitResponse({
    $core.bool? accepted,
    $core.String? inquiryId,
  }) {
    final result = SponsorInquiryServiceSubmitResponse._();
    if (accepted != null) result.accepted = accepted;
    if (inquiryId != null) result.inquiryId = inquiryId;
    return result;
  }

  SponsorInquiryServiceSubmitResponse._();

  factory SponsorInquiryServiceSubmitResponse.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SponsorInquiryServiceSubmitResponse()..mergeFromBuffer(data, registry);
  factory SponsorInquiryServiceSubmitResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SponsorInquiryServiceSubmitResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SponsorInquiryServiceSubmitResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: SponsorInquiryServiceSubmitResponse.$_createMessage)
    ..aOB(1, _omitFieldNames ? '' : 'accepted')
    ..aOS(2, _omitFieldNames ? '' : 'inquiryId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SponsorInquiryServiceSubmitResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SponsorInquiryServiceSubmitResponse copyWith(
          void Function(SponsorInquiryServiceSubmitResponse) updates) =>
      super.copyWith((message) =>
              updates(message as SponsorInquiryServiceSubmitResponse))
          as SponsorInquiryServiceSubmitResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use SponsorInquiryServiceSubmitResponse() / SponsorInquiryServiceSubmitResponse.new instead')
  static SponsorInquiryServiceSubmitResponse create() =>
      SponsorInquiryServiceSubmitResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      SponsorInquiryServiceSubmitResponse._();
  @$core.override
  SponsorInquiryServiceSubmitResponse createEmptyInstance() =>
      SponsorInquiryServiceSubmitResponse._();
  @$core.pragma('dart2js:noInline')
  static SponsorInquiryServiceSubmitResponse getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
              SponsorInquiryServiceSubmitResponse>(
          SponsorInquiryServiceSubmitResponse.$_createMessage);
  static SponsorInquiryServiceSubmitResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get accepted => $_getBF(0);
  @$pb.TagNumber(1)
  set accepted($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAccepted() => $_has(0);
  @$pb.TagNumber(1)
  void clearAccepted() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get inquiryId => $_getSZ(1);
  @$pb.TagNumber(2)
  set inquiryId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasInquiryId() => $_has(1);
  @$pb.TagNumber(2)
  void clearInquiryId() => $_clearField(2);
}

class GetPerContentRequest extends $pb.GeneratedMessage {
  factory GetPerContentRequest({
    $core.String? workspaceId,
    $core.String? platform,
    $core.int? lookbackDays,
  }) {
    final result = GetPerContentRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (platform != null) result.platform = platform;
    if (lookbackDays != null) result.lookbackDays = lookbackDays;
    return result;
  }

  GetPerContentRequest._();

  factory GetPerContentRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetPerContentRequest()..mergeFromBuffer(data, registry);
  factory GetPerContentRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetPerContentRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetPerContentRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: GetPerContentRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'platform')
    ..aI(3, _omitFieldNames ? '' : 'lookbackDays')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetPerContentRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetPerContentRequest copyWith(void Function(GetPerContentRequest) updates) =>
      super.copyWith((message) => updates(message as GetPerContentRequest))
          as GetPerContentRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use GetPerContentRequest() / GetPerContentRequest.new instead')
  static GetPerContentRequest create() => GetPerContentRequest._();
  static $pb.GeneratedMessage $_createMessage() => GetPerContentRequest._();
  @$core.override
  GetPerContentRequest createEmptyInstance() => GetPerContentRequest._();
  @$core.pragma('dart2js:noInline')
  static GetPerContentRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetPerContentRequest>(
          GetPerContentRequest.$_createMessage);
  static GetPerContentRequest? _defaultInstance;

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
  $core.int get lookbackDays => $_getIZ(2);
  @$pb.TagNumber(3)
  set lookbackDays($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasLookbackDays() => $_has(2);
  @$pb.TagNumber(3)
  void clearLookbackDays() => $_clearField(3);
}

class GetPerContentResponse extends $pb.GeneratedMessage {
  factory GetPerContentResponse({
    $core.Iterable<ContentROIMetric>? metrics,
  }) {
    final result = GetPerContentResponse._();
    if (metrics != null) result.metrics.addAll(metrics);
    return result;
  }

  GetPerContentResponse._();

  factory GetPerContentResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetPerContentResponse()..mergeFromBuffer(data, registry);
  factory GetPerContentResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetPerContentResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetPerContentResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: GetPerContentResponse.$_createMessage)
    ..pPM<ContentROIMetric>(1, _omitFieldNames ? '' : 'metrics',
        subBuilder: ContentROIMetric.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetPerContentResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetPerContentResponse copyWith(
          void Function(GetPerContentResponse) updates) =>
      super.copyWith((message) => updates(message as GetPerContentResponse))
          as GetPerContentResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use GetPerContentResponse() / GetPerContentResponse.new instead')
  static GetPerContentResponse create() => GetPerContentResponse._();
  static $pb.GeneratedMessage $_createMessage() => GetPerContentResponse._();
  @$core.override
  GetPerContentResponse createEmptyInstance() => GetPerContentResponse._();
  @$core.pragma('dart2js:noInline')
  static GetPerContentResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetPerContentResponse>(
          GetPerContentResponse.$_createMessage);
  static GetPerContentResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<ContentROIMetric> get metrics => $_getList(0);
}

class GetRPMTrendsRequest extends $pb.GeneratedMessage {
  factory GetRPMTrendsRequest({
    $core.String? workspaceId,
    $core.String? platform,
    $core.int? periods,
  }) {
    final result = GetRPMTrendsRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (platform != null) result.platform = platform;
    if (periods != null) result.periods = periods;
    return result;
  }

  GetRPMTrendsRequest._();

  factory GetRPMTrendsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetRPMTrendsRequest()..mergeFromBuffer(data, registry);
  factory GetRPMTrendsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetRPMTrendsRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetRPMTrendsRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: GetRPMTrendsRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'platform')
    ..aI(3, _omitFieldNames ? '' : 'periods')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetRPMTrendsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetRPMTrendsRequest copyWith(void Function(GetRPMTrendsRequest) updates) =>
      super.copyWith((message) => updates(message as GetRPMTrendsRequest))
          as GetRPMTrendsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core
      .Deprecated('Use GetRPMTrendsRequest() / GetRPMTrendsRequest.new instead')
  static GetRPMTrendsRequest create() => GetRPMTrendsRequest._();
  static $pb.GeneratedMessage $_createMessage() => GetRPMTrendsRequest._();
  @$core.override
  GetRPMTrendsRequest createEmptyInstance() => GetRPMTrendsRequest._();
  @$core.pragma('dart2js:noInline')
  static GetRPMTrendsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetRPMTrendsRequest>(
          GetRPMTrendsRequest.$_createMessage);
  static GetRPMTrendsRequest? _defaultInstance;

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
  $core.int get periods => $_getIZ(2);
  @$pb.TagNumber(3)
  set periods($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPeriods() => $_has(2);
  @$pb.TagNumber(3)
  void clearPeriods() => $_clearField(3);
}

class GetRPMTrendsResponse extends $pb.GeneratedMessage {
  factory GetRPMTrendsResponse({
    $core.Iterable<RPMTrendPoint>? trendPoints,
    $core.double? averageRpm,
    $core.bool? alertActive,
  }) {
    final result = GetRPMTrendsResponse._();
    if (trendPoints != null) result.trendPoints.addAll(trendPoints);
    if (averageRpm != null) result.averageRpm = averageRpm;
    if (alertActive != null) result.alertActive = alertActive;
    return result;
  }

  GetRPMTrendsResponse._();

  factory GetRPMTrendsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetRPMTrendsResponse()..mergeFromBuffer(data, registry);
  factory GetRPMTrendsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetRPMTrendsResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetRPMTrendsResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: GetRPMTrendsResponse.$_createMessage)
    ..pPM<RPMTrendPoint>(1, _omitFieldNames ? '' : 'trendPoints',
        subBuilder: RPMTrendPoint.$_createMessage)
    ..aD(2, _omitFieldNames ? '' : 'averageRpm')
    ..aOB(3, _omitFieldNames ? '' : 'alertActive')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetRPMTrendsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetRPMTrendsResponse copyWith(void Function(GetRPMTrendsResponse) updates) =>
      super.copyWith((message) => updates(message as GetRPMTrendsResponse))
          as GetRPMTrendsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use GetRPMTrendsResponse() / GetRPMTrendsResponse.new instead')
  static GetRPMTrendsResponse create() => GetRPMTrendsResponse._();
  static $pb.GeneratedMessage $_createMessage() => GetRPMTrendsResponse._();
  @$core.override
  GetRPMTrendsResponse createEmptyInstance() => GetRPMTrendsResponse._();
  @$core.pragma('dart2js:noInline')
  static GetRPMTrendsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetRPMTrendsResponse>(
          GetRPMTrendsResponse.$_createMessage);
  static GetRPMTrendsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<RPMTrendPoint> get trendPoints => $_getList(0);

  @$pb.TagNumber(2)
  $core.double get averageRpm => $_getN(1);
  @$pb.TagNumber(2)
  set averageRpm($core.double value) => $_setDouble(1, value);
  @$pb.TagNumber(2)
  $core.bool hasAverageRpm() => $_has(1);
  @$pb.TagNumber(2)
  void clearAverageRpm() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.bool get alertActive => $_getBF(2);
  @$pb.TagNumber(3)
  set alertActive($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasAlertActive() => $_has(2);
  @$pb.TagNumber(3)
  void clearAlertActive() => $_clearField(3);
}

class GetROIRequest extends $pb.GeneratedMessage {
  factory GetROIRequest({
    $core.String? workspaceId,
    $core.String? contentId,
  }) {
    final result = GetROIRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (contentId != null) result.contentId = contentId;
    return result;
  }

  GetROIRequest._();

  factory GetROIRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetROIRequest()..mergeFromBuffer(data, registry);
  factory GetROIRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetROIRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetROIRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: GetROIRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'contentId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetROIRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetROIRequest copyWith(void Function(GetROIRequest) updates) =>
      super.copyWith((message) => updates(message as GetROIRequest))
          as GetROIRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use GetROIRequest() / GetROIRequest.new instead')
  static GetROIRequest create() => GetROIRequest._();
  static $pb.GeneratedMessage $_createMessage() => GetROIRequest._();
  @$core.override
  GetROIRequest createEmptyInstance() => GetROIRequest._();
  @$core.pragma('dart2js:noInline')
  static GetROIRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetROIRequest>(
          GetROIRequest.$_createMessage);
  static GetROIRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get contentId => $_getSZ(1);
  @$pb.TagNumber(2)
  set contentId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasContentId() => $_has(1);
  @$pb.TagNumber(2)
  void clearContentId() => $_clearField(2);
}

class GetROIResponse extends $pb.GeneratedMessage {
  factory GetROIResponse({
    ContentROIMetric? metric,
  }) {
    final result = GetROIResponse._();
    if (metric != null) result.metric = metric;
    return result;
  }

  GetROIResponse._();

  factory GetROIResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetROIResponse()..mergeFromBuffer(data, registry);
  factory GetROIResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetROIResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetROIResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: GetROIResponse.$_createMessage)
    ..aOM<ContentROIMetric>(1, _omitFieldNames ? '' : 'metric',
        subBuilder: ContentROIMetric.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetROIResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetROIResponse copyWith(void Function(GetROIResponse) updates) =>
      super.copyWith((message) => updates(message as GetROIResponse))
          as GetROIResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use GetROIResponse() / GetROIResponse.new instead')
  static GetROIResponse create() => GetROIResponse._();
  static $pb.GeneratedMessage $_createMessage() => GetROIResponse._();
  @$core.override
  GetROIResponse createEmptyInstance() => GetROIResponse._();
  @$core.pragma('dart2js:noInline')
  static GetROIResponse getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetROIResponse>(
          GetROIResponse.$_createMessage);
  static GetROIResponse? _defaultInstance;

  @$pb.TagNumber(1)
  ContentROIMetric get metric => $_getN(0);
  @$pb.TagNumber(1)
  set metric(ContentROIMetric value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasMetric() => $_has(0);
  @$pb.TagNumber(1)
  void clearMetric() => $_clearField(1);
  @$pb.TagNumber(1)
  ContentROIMetric ensureMetric() => $_ensure(0);
}

class GetTopPerformersRequest extends $pb.GeneratedMessage {
  factory GetTopPerformersRequest({
    $core.String? workspaceId,
    $core.String? sortBy,
    $core.int? limit,
  }) {
    final result = GetTopPerformersRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (sortBy != null) result.sortBy = sortBy;
    if (limit != null) result.limit = limit;
    return result;
  }

  GetTopPerformersRequest._();

  factory GetTopPerformersRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetTopPerformersRequest()..mergeFromBuffer(data, registry);
  factory GetTopPerformersRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetTopPerformersRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetTopPerformersRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: GetTopPerformersRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'sortBy')
    ..aI(3, _omitFieldNames ? '' : 'limit')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetTopPerformersRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetTopPerformersRequest copyWith(
          void Function(GetTopPerformersRequest) updates) =>
      super.copyWith((message) => updates(message as GetTopPerformersRequest))
          as GetTopPerformersRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use GetTopPerformersRequest() / GetTopPerformersRequest.new instead')
  static GetTopPerformersRequest create() => GetTopPerformersRequest._();
  static $pb.GeneratedMessage $_createMessage() => GetTopPerformersRequest._();
  @$core.override
  GetTopPerformersRequest createEmptyInstance() => GetTopPerformersRequest._();
  @$core.pragma('dart2js:noInline')
  static GetTopPerformersRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetTopPerformersRequest>(
          GetTopPerformersRequest.$_createMessage);
  static GetTopPerformersRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get sortBy => $_getSZ(1);
  @$pb.TagNumber(2)
  set sortBy($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSortBy() => $_has(1);
  @$pb.TagNumber(2)
  void clearSortBy() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get limit => $_getIZ(2);
  @$pb.TagNumber(3)
  set limit($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasLimit() => $_has(2);
  @$pb.TagNumber(3)
  void clearLimit() => $_clearField(3);
}

class GetTopPerformersResponse extends $pb.GeneratedMessage {
  factory GetTopPerformersResponse({
    $core.Iterable<ContentROIMetric>? topPerformers,
  }) {
    final result = GetTopPerformersResponse._();
    if (topPerformers != null) result.topPerformers.addAll(topPerformers);
    return result;
  }

  GetTopPerformersResponse._();

  factory GetTopPerformersResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetTopPerformersResponse()..mergeFromBuffer(data, registry);
  factory GetTopPerformersResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetTopPerformersResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetTopPerformersResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: GetTopPerformersResponse.$_createMessage)
    ..pPM<ContentROIMetric>(1, _omitFieldNames ? '' : 'topPerformers',
        subBuilder: ContentROIMetric.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetTopPerformersResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetTopPerformersResponse copyWith(
          void Function(GetTopPerformersResponse) updates) =>
      super.copyWith((message) => updates(message as GetTopPerformersResponse))
          as GetTopPerformersResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use GetTopPerformersResponse() / GetTopPerformersResponse.new instead')
  static GetTopPerformersResponse create() => GetTopPerformersResponse._();
  static $pb.GeneratedMessage $_createMessage() => GetTopPerformersResponse._();
  @$core.override
  GetTopPerformersResponse createEmptyInstance() =>
      GetTopPerformersResponse._();
  @$core.pragma('dart2js:noInline')
  static GetTopPerformersResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetTopPerformersResponse>(
          GetTopPerformersResponse.$_createMessage);
  static GetTopPerformersResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<ContentROIMetric> get topPerformers => $_getList(0);
}

class TaxReportServiceGetReportRequest extends $pb.GeneratedMessage {
  factory TaxReportServiceGetReportRequest({
    $core.String? workspaceId,
    TaxReportPeriod? period,
    $core.int? year,
    $core.int? periodNumber,
  }) {
    final result = TaxReportServiceGetReportRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (period != null) result.period = period;
    if (year != null) result.year = year;
    if (periodNumber != null) result.periodNumber = periodNumber;
    return result;
  }

  TaxReportServiceGetReportRequest._();

  factory TaxReportServiceGetReportRequest.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      TaxReportServiceGetReportRequest()..mergeFromBuffer(data, registry);
  factory TaxReportServiceGetReportRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      TaxReportServiceGetReportRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TaxReportServiceGetReportRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: TaxReportServiceGetReportRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aE<TaxReportPeriod>(2, _omitFieldNames ? '' : 'period',
        enumValues: TaxReportPeriod.values)
    ..aI(3, _omitFieldNames ? '' : 'year')
    ..aI(4, _omitFieldNames ? '' : 'periodNumber')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TaxReportServiceGetReportRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TaxReportServiceGetReportRequest copyWith(
          void Function(TaxReportServiceGetReportRequest) updates) =>
      super.copyWith(
              (message) => updates(message as TaxReportServiceGetReportRequest))
          as TaxReportServiceGetReportRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use TaxReportServiceGetReportRequest() / TaxReportServiceGetReportRequest.new instead')
  static TaxReportServiceGetReportRequest create() =>
      TaxReportServiceGetReportRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      TaxReportServiceGetReportRequest._();
  @$core.override
  TaxReportServiceGetReportRequest createEmptyInstance() =>
      TaxReportServiceGetReportRequest._();
  @$core.pragma('dart2js:noInline')
  static TaxReportServiceGetReportRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<TaxReportServiceGetReportRequest>(
          TaxReportServiceGetReportRequest.$_createMessage);
  static TaxReportServiceGetReportRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  TaxReportPeriod get period => $_getN(1);
  @$pb.TagNumber(2)
  set period(TaxReportPeriod value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasPeriod() => $_has(1);
  @$pb.TagNumber(2)
  void clearPeriod() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get year => $_getIZ(2);
  @$pb.TagNumber(3)
  set year($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasYear() => $_has(2);
  @$pb.TagNumber(3)
  void clearYear() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get periodNumber => $_getIZ(3);
  @$pb.TagNumber(4)
  set periodNumber($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasPeriodNumber() => $_has(3);
  @$pb.TagNumber(4)
  void clearPeriodNumber() => $_clearField(4);
}

class TaxReportServiceGetReportResponse extends $pb.GeneratedMessage {
  factory TaxReportServiceGetReportResponse({
    TaxReportSummary? summary,
  }) {
    final result = TaxReportServiceGetReportResponse._();
    if (summary != null) result.summary = summary;
    return result;
  }

  TaxReportServiceGetReportResponse._();

  factory TaxReportServiceGetReportResponse.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      TaxReportServiceGetReportResponse()..mergeFromBuffer(data, registry);
  factory TaxReportServiceGetReportResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      TaxReportServiceGetReportResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TaxReportServiceGetReportResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: TaxReportServiceGetReportResponse.$_createMessage)
    ..aOM<TaxReportSummary>(1, _omitFieldNames ? '' : 'summary',
        subBuilder: TaxReportSummary.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TaxReportServiceGetReportResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TaxReportServiceGetReportResponse copyWith(
          void Function(TaxReportServiceGetReportResponse) updates) =>
      super.copyWith((message) =>
              updates(message as TaxReportServiceGetReportResponse))
          as TaxReportServiceGetReportResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use TaxReportServiceGetReportResponse() / TaxReportServiceGetReportResponse.new instead')
  static TaxReportServiceGetReportResponse create() =>
      TaxReportServiceGetReportResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      TaxReportServiceGetReportResponse._();
  @$core.override
  TaxReportServiceGetReportResponse createEmptyInstance() =>
      TaxReportServiceGetReportResponse._();
  @$core.pragma('dart2js:noInline')
  static TaxReportServiceGetReportResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<TaxReportServiceGetReportResponse>(
          TaxReportServiceGetReportResponse.$_createMessage);
  static TaxReportServiceGetReportResponse? _defaultInstance;

  @$pb.TagNumber(1)
  TaxReportSummary get summary => $_getN(0);
  @$pb.TagNumber(1)
  set summary(TaxReportSummary value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasSummary() => $_has(0);
  @$pb.TagNumber(1)
  void clearSummary() => $_clearField(1);
  @$pb.TagNumber(1)
  TaxReportSummary ensureSummary() => $_ensure(0);
}

class ExportTaxReportRequest extends $pb.GeneratedMessage {
  factory ExportTaxReportRequest({
    $core.String? workspaceId,
    TaxReportPeriod? period,
    $core.int? year,
    $core.int? periodNumber,
    TaxReportFormat? format,
  }) {
    final result = ExportTaxReportRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (period != null) result.period = period;
    if (year != null) result.year = year;
    if (periodNumber != null) result.periodNumber = periodNumber;
    if (format != null) result.format = format;
    return result;
  }

  ExportTaxReportRequest._();

  factory ExportTaxReportRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ExportTaxReportRequest()..mergeFromBuffer(data, registry);
  factory ExportTaxReportRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ExportTaxReportRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ExportTaxReportRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: ExportTaxReportRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aE<TaxReportPeriod>(2, _omitFieldNames ? '' : 'period',
        enumValues: TaxReportPeriod.values)
    ..aI(3, _omitFieldNames ? '' : 'year')
    ..aI(4, _omitFieldNames ? '' : 'periodNumber')
    ..aE<TaxReportFormat>(5, _omitFieldNames ? '' : 'format',
        enumValues: TaxReportFormat.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ExportTaxReportRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ExportTaxReportRequest copyWith(
          void Function(ExportTaxReportRequest) updates) =>
      super.copyWith((message) => updates(message as ExportTaxReportRequest))
          as ExportTaxReportRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ExportTaxReportRequest() / ExportTaxReportRequest.new instead')
  static ExportTaxReportRequest create() => ExportTaxReportRequest._();
  static $pb.GeneratedMessage $_createMessage() => ExportTaxReportRequest._();
  @$core.override
  ExportTaxReportRequest createEmptyInstance() => ExportTaxReportRequest._();
  @$core.pragma('dart2js:noInline')
  static ExportTaxReportRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ExportTaxReportRequest>(
          ExportTaxReportRequest.$_createMessage);
  static ExportTaxReportRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  TaxReportPeriod get period => $_getN(1);
  @$pb.TagNumber(2)
  set period(TaxReportPeriod value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasPeriod() => $_has(1);
  @$pb.TagNumber(2)
  void clearPeriod() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get year => $_getIZ(2);
  @$pb.TagNumber(3)
  set year($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasYear() => $_has(2);
  @$pb.TagNumber(3)
  void clearYear() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get periodNumber => $_getIZ(3);
  @$pb.TagNumber(4)
  set periodNumber($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasPeriodNumber() => $_has(3);
  @$pb.TagNumber(4)
  void clearPeriodNumber() => $_clearField(4);

  @$pb.TagNumber(5)
  TaxReportFormat get format => $_getN(4);
  @$pb.TagNumber(5)
  set format(TaxReportFormat value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasFormat() => $_has(4);
  @$pb.TagNumber(5)
  void clearFormat() => $_clearField(5);
}

class ExportTaxReportResponse extends $pb.GeneratedMessage {
  factory ExportTaxReportResponse({
    TaxReportSummary? summary,
    $core.List<$core.int>? reportData,
    $core.String? fileName,
  }) {
    final result = ExportTaxReportResponse._();
    if (summary != null) result.summary = summary;
    if (reportData != null) result.reportData = reportData;
    if (fileName != null) result.fileName = fileName;
    return result;
  }

  ExportTaxReportResponse._();

  factory ExportTaxReportResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ExportTaxReportResponse()..mergeFromBuffer(data, registry);
  factory ExportTaxReportResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ExportTaxReportResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ExportTaxReportResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: ExportTaxReportResponse.$_createMessage)
    ..aOM<TaxReportSummary>(1, _omitFieldNames ? '' : 'summary',
        subBuilder: TaxReportSummary.$_createMessage)
    ..a<$core.List<$core.int>>(
        2, _omitFieldNames ? '' : 'reportData', $pb.PbFieldType.OY)
    ..aOS(3, _omitFieldNames ? '' : 'fileName')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ExportTaxReportResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ExportTaxReportResponse copyWith(
          void Function(ExportTaxReportResponse) updates) =>
      super.copyWith((message) => updates(message as ExportTaxReportResponse))
          as ExportTaxReportResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ExportTaxReportResponse() / ExportTaxReportResponse.new instead')
  static ExportTaxReportResponse create() => ExportTaxReportResponse._();
  static $pb.GeneratedMessage $_createMessage() => ExportTaxReportResponse._();
  @$core.override
  ExportTaxReportResponse createEmptyInstance() => ExportTaxReportResponse._();
  @$core.pragma('dart2js:noInline')
  static ExportTaxReportResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ExportTaxReportResponse>(
          ExportTaxReportResponse.$_createMessage);
  static ExportTaxReportResponse? _defaultInstance;

  @$pb.TagNumber(1)
  TaxReportSummary get summary => $_getN(0);
  @$pb.TagNumber(1)
  set summary(TaxReportSummary value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasSummary() => $_has(0);
  @$pb.TagNumber(1)
  void clearSummary() => $_clearField(1);
  @$pb.TagNumber(1)
  TaxReportSummary ensureSummary() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.List<$core.int> get reportData => $_getN(1);
  @$pb.TagNumber(2)
  set reportData($core.List<$core.int> value) => $_setBytes(1, value);
  @$pb.TagNumber(2)
  $core.bool hasReportData() => $_has(1);
  @$pb.TagNumber(2)
  void clearReportData() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get fileName => $_getSZ(2);
  @$pb.TagNumber(3)
  set fileName($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasFileName() => $_has(2);
  @$pb.TagNumber(3)
  void clearFileName() => $_clearField(3);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');

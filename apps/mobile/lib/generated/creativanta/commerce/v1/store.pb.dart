// This is a generated file - do not edit.
//
// Generated from creativanta/commerce/v1/store.proto.

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
import 'store.pbenum.dart';

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'store.pbenum.dart';

class StorePage extends $pb.GeneratedMessage {
  factory StorePage({
    $core.String? storePageId,
    $core.String? workspaceId,
    $core.String? title,
    $core.String? slug,
    $core.String? description,
    $core.String? layoutJson,
    $core.String? themeOverridesJson,
    StorePageStatus? status,
    $core.String? customDomain,
    $core.String? seoConfigJson,
    $core.String? widgetConfigJson,
    $1.Timestamp? createdAt,
    $1.Timestamp? updatedAt,
    $1.Timestamp? deletedAt,
  }) {
    final result = StorePage._();
    if (storePageId != null) result.storePageId = storePageId;
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (title != null) result.title = title;
    if (slug != null) result.slug = slug;
    if (description != null) result.description = description;
    if (layoutJson != null) result.layoutJson = layoutJson;
    if (themeOverridesJson != null)
      result.themeOverridesJson = themeOverridesJson;
    if (status != null) result.status = status;
    if (customDomain != null) result.customDomain = customDomain;
    if (seoConfigJson != null) result.seoConfigJson = seoConfigJson;
    if (widgetConfigJson != null) result.widgetConfigJson = widgetConfigJson;
    if (createdAt != null) result.createdAt = createdAt;
    if (updatedAt != null) result.updatedAt = updatedAt;
    if (deletedAt != null) result.deletedAt = deletedAt;
    return result;
  }

  StorePage._();

  factory StorePage.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      StorePage()..mergeFromBuffer(data, registry);
  factory StorePage.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      StorePage()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'StorePage',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: StorePage.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'storePageId')
    ..aOS(2, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(3, _omitFieldNames ? '' : 'title')
    ..aOS(4, _omitFieldNames ? '' : 'slug')
    ..aOS(5, _omitFieldNames ? '' : 'description')
    ..aOS(6, _omitFieldNames ? '' : 'layoutJson')
    ..aOS(7, _omitFieldNames ? '' : 'themeOverridesJson')
    ..aE<StorePageStatus>(8, _omitFieldNames ? '' : 'status',
        enumValues: StorePageStatus.values)
    ..aOS(9, _omitFieldNames ? '' : 'customDomain')
    ..aOS(10, _omitFieldNames ? '' : 'seoConfigJson')
    ..aOS(11, _omitFieldNames ? '' : 'widgetConfigJson')
    ..aOM<$1.Timestamp>(12, _omitFieldNames ? '' : 'createdAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..aOM<$1.Timestamp>(13, _omitFieldNames ? '' : 'updatedAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..aOM<$1.Timestamp>(14, _omitFieldNames ? '' : 'deletedAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StorePage clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StorePage copyWith(void Function(StorePage) updates) =>
      super.copyWith((message) => updates(message as StorePage)) as StorePage;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use StorePage() / StorePage.new instead')
  static StorePage create() => StorePage._();
  static $pb.GeneratedMessage $_createMessage() => StorePage._();
  @$core.override
  StorePage createEmptyInstance() => StorePage._();
  @$core.pragma('dart2js:noInline')
  static StorePage getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<StorePage>(StorePage.$_createMessage);
  static StorePage? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get storePageId => $_getSZ(0);
  @$pb.TagNumber(1)
  set storePageId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasStorePageId() => $_has(0);
  @$pb.TagNumber(1)
  void clearStorePageId() => $_clearField(1);

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
  $core.String get slug => $_getSZ(3);
  @$pb.TagNumber(4)
  set slug($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasSlug() => $_has(3);
  @$pb.TagNumber(4)
  void clearSlug() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get description => $_getSZ(4);
  @$pb.TagNumber(5)
  set description($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasDescription() => $_has(4);
  @$pb.TagNumber(5)
  void clearDescription() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get layoutJson => $_getSZ(5);
  @$pb.TagNumber(6)
  set layoutJson($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasLayoutJson() => $_has(5);
  @$pb.TagNumber(6)
  void clearLayoutJson() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get themeOverridesJson => $_getSZ(6);
  @$pb.TagNumber(7)
  set themeOverridesJson($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasThemeOverridesJson() => $_has(6);
  @$pb.TagNumber(7)
  void clearThemeOverridesJson() => $_clearField(7);

  @$pb.TagNumber(8)
  StorePageStatus get status => $_getN(7);
  @$pb.TagNumber(8)
  set status(StorePageStatus value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasStatus() => $_has(7);
  @$pb.TagNumber(8)
  void clearStatus() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get customDomain => $_getSZ(8);
  @$pb.TagNumber(9)
  set customDomain($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasCustomDomain() => $_has(8);
  @$pb.TagNumber(9)
  void clearCustomDomain() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.String get seoConfigJson => $_getSZ(9);
  @$pb.TagNumber(10)
  set seoConfigJson($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasSeoConfigJson() => $_has(9);
  @$pb.TagNumber(10)
  void clearSeoConfigJson() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.String get widgetConfigJson => $_getSZ(10);
  @$pb.TagNumber(11)
  set widgetConfigJson($core.String value) => $_setString(10, value);
  @$pb.TagNumber(11)
  $core.bool hasWidgetConfigJson() => $_has(10);
  @$pb.TagNumber(11)
  void clearWidgetConfigJson() => $_clearField(11);

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

  @$pb.TagNumber(14)
  $1.Timestamp get deletedAt => $_getN(13);
  @$pb.TagNumber(14)
  set deletedAt($1.Timestamp value) => $_setField(14, value);
  @$pb.TagNumber(14)
  $core.bool hasDeletedAt() => $_has(13);
  @$pb.TagNumber(14)
  void clearDeletedAt() => $_clearField(14);
  @$pb.TagNumber(14)
  $1.Timestamp ensureDeletedAt() => $_ensure(13);
}

class StoreTheme extends $pb.GeneratedMessage {
  factory StoreTheme({
    $core.String? themeId,
    $core.String? name,
    $core.String? primaryColor,
    $core.String? fontFamily,
    $core.String? borderRadius,
    $core.bool? isDefault,
  }) {
    final result = StoreTheme._();
    if (themeId != null) result.themeId = themeId;
    if (name != null) result.name = name;
    if (primaryColor != null) result.primaryColor = primaryColor;
    if (fontFamily != null) result.fontFamily = fontFamily;
    if (borderRadius != null) result.borderRadius = borderRadius;
    if (isDefault != null) result.isDefault = isDefault;
    return result;
  }

  StoreTheme._();

  factory StoreTheme.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      StoreTheme()..mergeFromBuffer(data, registry);
  factory StoreTheme.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      StoreTheme()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'StoreTheme',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: StoreTheme.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'themeId')
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..aOS(3, _omitFieldNames ? '' : 'primaryColor')
    ..aOS(4, _omitFieldNames ? '' : 'fontFamily')
    ..aOS(5, _omitFieldNames ? '' : 'borderRadius')
    ..aOB(6, _omitFieldNames ? '' : 'isDefault')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StoreTheme clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StoreTheme copyWith(void Function(StoreTheme) updates) =>
      super.copyWith((message) => updates(message as StoreTheme)) as StoreTheme;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use StoreTheme() / StoreTheme.new instead')
  static StoreTheme create() => StoreTheme._();
  static $pb.GeneratedMessage $_createMessage() => StoreTheme._();
  @$core.override
  StoreTheme createEmptyInstance() => StoreTheme._();
  @$core.pragma('dart2js:noInline')
  static StoreTheme getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<StoreTheme>(StoreTheme.$_createMessage);
  static StoreTheme? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get themeId => $_getSZ(0);
  @$pb.TagNumber(1)
  set themeId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasThemeId() => $_has(0);
  @$pb.TagNumber(1)
  void clearThemeId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get name => $_getSZ(1);
  @$pb.TagNumber(2)
  set name($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasName() => $_has(1);
  @$pb.TagNumber(2)
  void clearName() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get primaryColor => $_getSZ(2);
  @$pb.TagNumber(3)
  set primaryColor($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPrimaryColor() => $_has(2);
  @$pb.TagNumber(3)
  void clearPrimaryColor() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get fontFamily => $_getSZ(3);
  @$pb.TagNumber(4)
  set fontFamily($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasFontFamily() => $_has(3);
  @$pb.TagNumber(4)
  void clearFontFamily() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get borderRadius => $_getSZ(4);
  @$pb.TagNumber(5)
  set borderRadius($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasBorderRadius() => $_has(4);
  @$pb.TagNumber(5)
  void clearBorderRadius() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.bool get isDefault => $_getBF(5);
  @$pb.TagNumber(6)
  set isDefault($core.bool value) => $_setBool(5, value);
  @$pb.TagNumber(6)
  $core.bool hasIsDefault() => $_has(5);
  @$pb.TagNumber(6)
  void clearIsDefault() => $_clearField(6);
}

class PageStats extends $pb.GeneratedMessage {
  factory PageStats({
    $core.String? storePageId,
    $fixnum.Int64? views,
    $fixnum.Int64? orders,
    $core.double? conversionRate,
    $core.String? revenue,
    $core.String? currency,
  }) {
    final result = PageStats._();
    if (storePageId != null) result.storePageId = storePageId;
    if (views != null) result.views = views;
    if (orders != null) result.orders = orders;
    if (conversionRate != null) result.conversionRate = conversionRate;
    if (revenue != null) result.revenue = revenue;
    if (currency != null) result.currency = currency;
    return result;
  }

  PageStats._();

  factory PageStats.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PageStats()..mergeFromBuffer(data, registry);
  factory PageStats.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PageStats()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PageStats',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: PageStats.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'storePageId')
    ..aInt64(2, _omitFieldNames ? '' : 'views')
    ..aInt64(3, _omitFieldNames ? '' : 'orders')
    ..aD(4, _omitFieldNames ? '' : 'conversionRate')
    ..aOS(5, _omitFieldNames ? '' : 'revenue')
    ..aOS(6, _omitFieldNames ? '' : 'currency')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PageStats clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PageStats copyWith(void Function(PageStats) updates) =>
      super.copyWith((message) => updates(message as PageStats)) as PageStats;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use PageStats() / PageStats.new instead')
  static PageStats create() => PageStats._();
  static $pb.GeneratedMessage $_createMessage() => PageStats._();
  @$core.override
  PageStats createEmptyInstance() => PageStats._();
  @$core.pragma('dart2js:noInline')
  static PageStats getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PageStats>(PageStats.$_createMessage);
  static PageStats? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get storePageId => $_getSZ(0);
  @$pb.TagNumber(1)
  set storePageId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasStorePageId() => $_has(0);
  @$pb.TagNumber(1)
  void clearStorePageId() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get views => $_getI64(1);
  @$pb.TagNumber(2)
  set views($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasViews() => $_has(1);
  @$pb.TagNumber(2)
  void clearViews() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get orders => $_getI64(2);
  @$pb.TagNumber(3)
  set orders($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasOrders() => $_has(2);
  @$pb.TagNumber(3)
  void clearOrders() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.double get conversionRate => $_getN(3);
  @$pb.TagNumber(4)
  set conversionRate($core.double value) => $_setDouble(3, value);
  @$pb.TagNumber(4)
  $core.bool hasConversionRate() => $_has(3);
  @$pb.TagNumber(4)
  void clearConversionRate() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get revenue => $_getSZ(4);
  @$pb.TagNumber(5)
  set revenue($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasRevenue() => $_has(4);
  @$pb.TagNumber(5)
  void clearRevenue() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get currency => $_getSZ(5);
  @$pb.TagNumber(6)
  set currency($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasCurrency() => $_has(5);
  @$pb.TagNumber(6)
  void clearCurrency() => $_clearField(6);
}

class MembershipPlan extends $pb.GeneratedMessage {
  factory MembershipPlan({
    $core.String? planId,
    $core.String? workspaceId,
    $core.String? title,
    $core.String? description,
    $core.String? price,
    $core.String? currency,
    $core.String? billingInterval,
    $core.String? benefitsJson,
    $core.String? entitlementConfigJson,
    MembershipPlanStatus? status,
    $core.int? subscriberCount,
    $1.Timestamp? createdAt,
    $1.Timestamp? updatedAt,
    $1.Timestamp? deletedAt,
  }) {
    final result = MembershipPlan._();
    if (planId != null) result.planId = planId;
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (title != null) result.title = title;
    if (description != null) result.description = description;
    if (price != null) result.price = price;
    if (currency != null) result.currency = currency;
    if (billingInterval != null) result.billingInterval = billingInterval;
    if (benefitsJson != null) result.benefitsJson = benefitsJson;
    if (entitlementConfigJson != null)
      result.entitlementConfigJson = entitlementConfigJson;
    if (status != null) result.status = status;
    if (subscriberCount != null) result.subscriberCount = subscriberCount;
    if (createdAt != null) result.createdAt = createdAt;
    if (updatedAt != null) result.updatedAt = updatedAt;
    if (deletedAt != null) result.deletedAt = deletedAt;
    return result;
  }

  MembershipPlan._();

  factory MembershipPlan.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      MembershipPlan()..mergeFromBuffer(data, registry);
  factory MembershipPlan.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      MembershipPlan()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MembershipPlan',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: MembershipPlan.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'planId')
    ..aOS(2, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(3, _omitFieldNames ? '' : 'title')
    ..aOS(4, _omitFieldNames ? '' : 'description')
    ..aOS(5, _omitFieldNames ? '' : 'price')
    ..aOS(6, _omitFieldNames ? '' : 'currency')
    ..aOS(7, _omitFieldNames ? '' : 'billingInterval')
    ..aOS(8, _omitFieldNames ? '' : 'benefitsJson')
    ..aOS(9, _omitFieldNames ? '' : 'entitlementConfigJson')
    ..aE<MembershipPlanStatus>(10, _omitFieldNames ? '' : 'status',
        enumValues: MembershipPlanStatus.values)
    ..aI(11, _omitFieldNames ? '' : 'subscriberCount')
    ..aOM<$1.Timestamp>(12, _omitFieldNames ? '' : 'createdAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..aOM<$1.Timestamp>(13, _omitFieldNames ? '' : 'updatedAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..aOM<$1.Timestamp>(14, _omitFieldNames ? '' : 'deletedAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MembershipPlan clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MembershipPlan copyWith(void Function(MembershipPlan) updates) =>
      super.copyWith((message) => updates(message as MembershipPlan))
          as MembershipPlan;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use MembershipPlan() / MembershipPlan.new instead')
  static MembershipPlan create() => MembershipPlan._();
  static $pb.GeneratedMessage $_createMessage() => MembershipPlan._();
  @$core.override
  MembershipPlan createEmptyInstance() => MembershipPlan._();
  @$core.pragma('dart2js:noInline')
  static MembershipPlan getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<MembershipPlan>(
          MembershipPlan.$_createMessage);
  static MembershipPlan? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get planId => $_getSZ(0);
  @$pb.TagNumber(1)
  set planId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPlanId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPlanId() => $_clearField(1);

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
  $core.String get description => $_getSZ(3);
  @$pb.TagNumber(4)
  set description($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasDescription() => $_has(3);
  @$pb.TagNumber(4)
  void clearDescription() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get price => $_getSZ(4);
  @$pb.TagNumber(5)
  set price($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasPrice() => $_has(4);
  @$pb.TagNumber(5)
  void clearPrice() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get currency => $_getSZ(5);
  @$pb.TagNumber(6)
  set currency($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasCurrency() => $_has(5);
  @$pb.TagNumber(6)
  void clearCurrency() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get billingInterval => $_getSZ(6);
  @$pb.TagNumber(7)
  set billingInterval($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasBillingInterval() => $_has(6);
  @$pb.TagNumber(7)
  void clearBillingInterval() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get benefitsJson => $_getSZ(7);
  @$pb.TagNumber(8)
  set benefitsJson($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasBenefitsJson() => $_has(7);
  @$pb.TagNumber(8)
  void clearBenefitsJson() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get entitlementConfigJson => $_getSZ(8);
  @$pb.TagNumber(9)
  set entitlementConfigJson($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasEntitlementConfigJson() => $_has(8);
  @$pb.TagNumber(9)
  void clearEntitlementConfigJson() => $_clearField(9);

  @$pb.TagNumber(10)
  MembershipPlanStatus get status => $_getN(9);
  @$pb.TagNumber(10)
  set status(MembershipPlanStatus value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasStatus() => $_has(9);
  @$pb.TagNumber(10)
  void clearStatus() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.int get subscriberCount => $_getIZ(10);
  @$pb.TagNumber(11)
  set subscriberCount($core.int value) => $_setSignedInt32(10, value);
  @$pb.TagNumber(11)
  $core.bool hasSubscriberCount() => $_has(10);
  @$pb.TagNumber(11)
  void clearSubscriberCount() => $_clearField(11);

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

  @$pb.TagNumber(14)
  $1.Timestamp get deletedAt => $_getN(13);
  @$pb.TagNumber(14)
  set deletedAt($1.Timestamp value) => $_setField(14, value);
  @$pb.TagNumber(14)
  $core.bool hasDeletedAt() => $_has(13);
  @$pb.TagNumber(14)
  void clearDeletedAt() => $_clearField(14);
  @$pb.TagNumber(14)
  $1.Timestamp ensureDeletedAt() => $_ensure(13);
}

class MembershipSubscription extends $pb.GeneratedMessage {
  factory MembershipSubscription({
    $core.String? membershipId,
    $core.String? workspaceId,
    $core.String? planId,
    $core.String? customerEntityId,
    MembershipSubscriptionStatus? status,
    $core.String? providerSubscriptionId,
    $1.Timestamp? currentPeriodStart,
    $1.Timestamp? currentPeriodEnd,
    $core.String? entitlementSnapshotJson,
    $1.Timestamp? createdAt,
    $1.Timestamp? updatedAt,
  }) {
    final result = MembershipSubscription._();
    if (membershipId != null) result.membershipId = membershipId;
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (planId != null) result.planId = planId;
    if (customerEntityId != null) result.customerEntityId = customerEntityId;
    if (status != null) result.status = status;
    if (providerSubscriptionId != null)
      result.providerSubscriptionId = providerSubscriptionId;
    if (currentPeriodStart != null)
      result.currentPeriodStart = currentPeriodStart;
    if (currentPeriodEnd != null) result.currentPeriodEnd = currentPeriodEnd;
    if (entitlementSnapshotJson != null)
      result.entitlementSnapshotJson = entitlementSnapshotJson;
    if (createdAt != null) result.createdAt = createdAt;
    if (updatedAt != null) result.updatedAt = updatedAt;
    return result;
  }

  MembershipSubscription._();

  factory MembershipSubscription.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      MembershipSubscription()..mergeFromBuffer(data, registry);
  factory MembershipSubscription.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      MembershipSubscription()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MembershipSubscription',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: MembershipSubscription.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'membershipId')
    ..aOS(2, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(3, _omitFieldNames ? '' : 'planId')
    ..aOS(4, _omitFieldNames ? '' : 'customerEntityId')
    ..aE<MembershipSubscriptionStatus>(5, _omitFieldNames ? '' : 'status',
        enumValues: MembershipSubscriptionStatus.values)
    ..aOS(6, _omitFieldNames ? '' : 'providerSubscriptionId')
    ..aOM<$1.Timestamp>(7, _omitFieldNames ? '' : 'currentPeriodStart',
        subBuilder: $1.Timestamp.$_createMessage)
    ..aOM<$1.Timestamp>(8, _omitFieldNames ? '' : 'currentPeriodEnd',
        subBuilder: $1.Timestamp.$_createMessage)
    ..aOS(9, _omitFieldNames ? '' : 'entitlementSnapshotJson')
    ..aOM<$1.Timestamp>(10, _omitFieldNames ? '' : 'createdAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..aOM<$1.Timestamp>(11, _omitFieldNames ? '' : 'updatedAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MembershipSubscription clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MembershipSubscription copyWith(
          void Function(MembershipSubscription) updates) =>
      super.copyWith((message) => updates(message as MembershipSubscription))
          as MembershipSubscription;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use MembershipSubscription() / MembershipSubscription.new instead')
  static MembershipSubscription create() => MembershipSubscription._();
  static $pb.GeneratedMessage $_createMessage() => MembershipSubscription._();
  @$core.override
  MembershipSubscription createEmptyInstance() => MembershipSubscription._();
  @$core.pragma('dart2js:noInline')
  static MembershipSubscription getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<MembershipSubscription>(
          MembershipSubscription.$_createMessage);
  static MembershipSubscription? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get membershipId => $_getSZ(0);
  @$pb.TagNumber(1)
  set membershipId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasMembershipId() => $_has(0);
  @$pb.TagNumber(1)
  void clearMembershipId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get workspaceId => $_getSZ(1);
  @$pb.TagNumber(2)
  set workspaceId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasWorkspaceId() => $_has(1);
  @$pb.TagNumber(2)
  void clearWorkspaceId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get planId => $_getSZ(2);
  @$pb.TagNumber(3)
  set planId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPlanId() => $_has(2);
  @$pb.TagNumber(3)
  void clearPlanId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get customerEntityId => $_getSZ(3);
  @$pb.TagNumber(4)
  set customerEntityId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasCustomerEntityId() => $_has(3);
  @$pb.TagNumber(4)
  void clearCustomerEntityId() => $_clearField(4);

  @$pb.TagNumber(5)
  MembershipSubscriptionStatus get status => $_getN(4);
  @$pb.TagNumber(5)
  set status(MembershipSubscriptionStatus value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasStatus() => $_has(4);
  @$pb.TagNumber(5)
  void clearStatus() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get providerSubscriptionId => $_getSZ(5);
  @$pb.TagNumber(6)
  set providerSubscriptionId($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasProviderSubscriptionId() => $_has(5);
  @$pb.TagNumber(6)
  void clearProviderSubscriptionId() => $_clearField(6);

  @$pb.TagNumber(7)
  $1.Timestamp get currentPeriodStart => $_getN(6);
  @$pb.TagNumber(7)
  set currentPeriodStart($1.Timestamp value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasCurrentPeriodStart() => $_has(6);
  @$pb.TagNumber(7)
  void clearCurrentPeriodStart() => $_clearField(7);
  @$pb.TagNumber(7)
  $1.Timestamp ensureCurrentPeriodStart() => $_ensure(6);

  @$pb.TagNumber(8)
  $1.Timestamp get currentPeriodEnd => $_getN(7);
  @$pb.TagNumber(8)
  set currentPeriodEnd($1.Timestamp value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasCurrentPeriodEnd() => $_has(7);
  @$pb.TagNumber(8)
  void clearCurrentPeriodEnd() => $_clearField(8);
  @$pb.TagNumber(8)
  $1.Timestamp ensureCurrentPeriodEnd() => $_ensure(7);

  @$pb.TagNumber(9)
  $core.String get entitlementSnapshotJson => $_getSZ(8);
  @$pb.TagNumber(9)
  set entitlementSnapshotJson($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasEntitlementSnapshotJson() => $_has(8);
  @$pb.TagNumber(9)
  void clearEntitlementSnapshotJson() => $_clearField(9);

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

class BundleItem extends $pb.GeneratedMessage {
  factory BundleItem({
    $core.String? bundleId,
    $core.String? productId,
    $core.int? quantity,
    $core.String? productTitle,
    $core.int? availableStock,
  }) {
    final result = BundleItem._();
    if (bundleId != null) result.bundleId = bundleId;
    if (productId != null) result.productId = productId;
    if (quantity != null) result.quantity = quantity;
    if (productTitle != null) result.productTitle = productTitle;
    if (availableStock != null) result.availableStock = availableStock;
    return result;
  }

  BundleItem._();

  factory BundleItem.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      BundleItem()..mergeFromBuffer(data, registry);
  factory BundleItem.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      BundleItem()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'BundleItem',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: BundleItem.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'bundleId')
    ..aOS(2, _omitFieldNames ? '' : 'productId')
    ..aI(3, _omitFieldNames ? '' : 'quantity')
    ..aOS(4, _omitFieldNames ? '' : 'productTitle')
    ..aI(5, _omitFieldNames ? '' : 'availableStock')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BundleItem clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BundleItem copyWith(void Function(BundleItem) updates) =>
      super.copyWith((message) => updates(message as BundleItem)) as BundleItem;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use BundleItem() / BundleItem.new instead')
  static BundleItem create() => BundleItem._();
  static $pb.GeneratedMessage $_createMessage() => BundleItem._();
  @$core.override
  BundleItem createEmptyInstance() => BundleItem._();
  @$core.pragma('dart2js:noInline')
  static BundleItem getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<BundleItem>(BundleItem.$_createMessage);
  static BundleItem? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get bundleId => $_getSZ(0);
  @$pb.TagNumber(1)
  set bundleId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasBundleId() => $_has(0);
  @$pb.TagNumber(1)
  void clearBundleId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get productId => $_getSZ(1);
  @$pb.TagNumber(2)
  set productId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasProductId() => $_has(1);
  @$pb.TagNumber(2)
  void clearProductId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get quantity => $_getIZ(2);
  @$pb.TagNumber(3)
  set quantity($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasQuantity() => $_has(2);
  @$pb.TagNumber(3)
  void clearQuantity() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get productTitle => $_getSZ(3);
  @$pb.TagNumber(4)
  set productTitle($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasProductTitle() => $_has(3);
  @$pb.TagNumber(4)
  void clearProductTitle() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get availableStock => $_getIZ(4);
  @$pb.TagNumber(5)
  set availableStock($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasAvailableStock() => $_has(4);
  @$pb.TagNumber(5)
  void clearAvailableStock() => $_clearField(5);
}

class Bundle extends $pb.GeneratedMessage {
  factory Bundle({
    $core.String? bundleId,
    $core.String? workspaceId,
    $core.String? title,
    $core.String? offerId,
    $core.String? bundlePrice,
    $core.double? discountPct,
    $core.String? status,
    $core.Iterable<BundleItem>? items,
    $core.bool? isAvailable,
    $core.String? unavailableReason,
    $1.Timestamp? createdAt,
  }) {
    final result = Bundle._();
    if (bundleId != null) result.bundleId = bundleId;
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (title != null) result.title = title;
    if (offerId != null) result.offerId = offerId;
    if (bundlePrice != null) result.bundlePrice = bundlePrice;
    if (discountPct != null) result.discountPct = discountPct;
    if (status != null) result.status = status;
    if (items != null) result.items.addAll(items);
    if (isAvailable != null) result.isAvailable = isAvailable;
    if (unavailableReason != null) result.unavailableReason = unavailableReason;
    if (createdAt != null) result.createdAt = createdAt;
    return result;
  }

  Bundle._();

  factory Bundle.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Bundle()..mergeFromBuffer(data, registry);
  factory Bundle.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Bundle()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Bundle',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: Bundle.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'bundleId')
    ..aOS(2, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(3, _omitFieldNames ? '' : 'title')
    ..aOS(4, _omitFieldNames ? '' : 'offerId')
    ..aOS(5, _omitFieldNames ? '' : 'bundlePrice')
    ..aD(6, _omitFieldNames ? '' : 'discountPct')
    ..aOS(7, _omitFieldNames ? '' : 'status')
    ..pPM<BundleItem>(8, _omitFieldNames ? '' : 'items',
        subBuilder: BundleItem.$_createMessage)
    ..aOB(9, _omitFieldNames ? '' : 'isAvailable')
    ..aOS(10, _omitFieldNames ? '' : 'unavailableReason')
    ..aOM<$1.Timestamp>(11, _omitFieldNames ? '' : 'createdAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Bundle clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Bundle copyWith(void Function(Bundle) updates) =>
      super.copyWith((message) => updates(message as Bundle)) as Bundle;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use Bundle() / Bundle.new instead')
  static Bundle create() => Bundle._();
  static $pb.GeneratedMessage $_createMessage() => Bundle._();
  @$core.override
  Bundle createEmptyInstance() => Bundle._();
  @$core.pragma('dart2js:noInline')
  static Bundle getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Bundle>(Bundle.$_createMessage);
  static Bundle? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get bundleId => $_getSZ(0);
  @$pb.TagNumber(1)
  set bundleId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasBundleId() => $_has(0);
  @$pb.TagNumber(1)
  void clearBundleId() => $_clearField(1);

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
  $core.String get offerId => $_getSZ(3);
  @$pb.TagNumber(4)
  set offerId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasOfferId() => $_has(3);
  @$pb.TagNumber(4)
  void clearOfferId() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get bundlePrice => $_getSZ(4);
  @$pb.TagNumber(5)
  set bundlePrice($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasBundlePrice() => $_has(4);
  @$pb.TagNumber(5)
  void clearBundlePrice() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.double get discountPct => $_getN(5);
  @$pb.TagNumber(6)
  set discountPct($core.double value) => $_setDouble(5, value);
  @$pb.TagNumber(6)
  $core.bool hasDiscountPct() => $_has(5);
  @$pb.TagNumber(6)
  void clearDiscountPct() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get status => $_getSZ(6);
  @$pb.TagNumber(7)
  set status($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasStatus() => $_has(6);
  @$pb.TagNumber(7)
  void clearStatus() => $_clearField(7);

  @$pb.TagNumber(8)
  $pb.PbList<BundleItem> get items => $_getList(7);

  @$pb.TagNumber(9)
  $core.bool get isAvailable => $_getBF(8);
  @$pb.TagNumber(9)
  set isAvailable($core.bool value) => $_setBool(8, value);
  @$pb.TagNumber(9)
  $core.bool hasIsAvailable() => $_has(8);
  @$pb.TagNumber(9)
  void clearIsAvailable() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.String get unavailableReason => $_getSZ(9);
  @$pb.TagNumber(10)
  set unavailableReason($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasUnavailableReason() => $_has(9);
  @$pb.TagNumber(10)
  void clearUnavailableReason() => $_clearField(10);

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

class DigitalDelivery extends $pb.GeneratedMessage {
  factory DigitalDelivery({
    $core.String? deliveryId,
    $core.String? workspaceId,
    $core.String? orderId,
    $core.String? customerEntityId,
    $core.String? productId,
    $core.String? offerId,
    DeliveryType? deliveryType,
    $core.String? entitlementPayloadJson,
    DeliveryStatus? status,
    $core.String? idempotencyKey,
    $core.int? downloadCount,
    $core.int? maxDownloads,
    $1.Timestamp? expiresAt,
    $1.Timestamp? createdAt,
  }) {
    final result = DigitalDelivery._();
    if (deliveryId != null) result.deliveryId = deliveryId;
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (orderId != null) result.orderId = orderId;
    if (customerEntityId != null) result.customerEntityId = customerEntityId;
    if (productId != null) result.productId = productId;
    if (offerId != null) result.offerId = offerId;
    if (deliveryType != null) result.deliveryType = deliveryType;
    if (entitlementPayloadJson != null)
      result.entitlementPayloadJson = entitlementPayloadJson;
    if (status != null) result.status = status;
    if (idempotencyKey != null) result.idempotencyKey = idempotencyKey;
    if (downloadCount != null) result.downloadCount = downloadCount;
    if (maxDownloads != null) result.maxDownloads = maxDownloads;
    if (expiresAt != null) result.expiresAt = expiresAt;
    if (createdAt != null) result.createdAt = createdAt;
    return result;
  }

  DigitalDelivery._();

  factory DigitalDelivery.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      DigitalDelivery()..mergeFromBuffer(data, registry);
  factory DigitalDelivery.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      DigitalDelivery()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DigitalDelivery',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: DigitalDelivery.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'deliveryId')
    ..aOS(2, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(3, _omitFieldNames ? '' : 'orderId')
    ..aOS(4, _omitFieldNames ? '' : 'customerEntityId')
    ..aOS(5, _omitFieldNames ? '' : 'productId')
    ..aOS(6, _omitFieldNames ? '' : 'offerId')
    ..aE<DeliveryType>(7, _omitFieldNames ? '' : 'deliveryType',
        enumValues: DeliveryType.values)
    ..aOS(8, _omitFieldNames ? '' : 'entitlementPayloadJson')
    ..aE<DeliveryStatus>(9, _omitFieldNames ? '' : 'status',
        enumValues: DeliveryStatus.values)
    ..aOS(10, _omitFieldNames ? '' : 'idempotencyKey')
    ..aI(11, _omitFieldNames ? '' : 'downloadCount')
    ..aI(12, _omitFieldNames ? '' : 'maxDownloads')
    ..aOM<$1.Timestamp>(13, _omitFieldNames ? '' : 'expiresAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..aOM<$1.Timestamp>(14, _omitFieldNames ? '' : 'createdAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DigitalDelivery clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DigitalDelivery copyWith(void Function(DigitalDelivery) updates) =>
      super.copyWith((message) => updates(message as DigitalDelivery))
          as DigitalDelivery;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use DigitalDelivery() / DigitalDelivery.new instead')
  static DigitalDelivery create() => DigitalDelivery._();
  static $pb.GeneratedMessage $_createMessage() => DigitalDelivery._();
  @$core.override
  DigitalDelivery createEmptyInstance() => DigitalDelivery._();
  @$core.pragma('dart2js:noInline')
  static DigitalDelivery getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DigitalDelivery>(
          DigitalDelivery.$_createMessage);
  static DigitalDelivery? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get deliveryId => $_getSZ(0);
  @$pb.TagNumber(1)
  set deliveryId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasDeliveryId() => $_has(0);
  @$pb.TagNumber(1)
  void clearDeliveryId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get workspaceId => $_getSZ(1);
  @$pb.TagNumber(2)
  set workspaceId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasWorkspaceId() => $_has(1);
  @$pb.TagNumber(2)
  void clearWorkspaceId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get orderId => $_getSZ(2);
  @$pb.TagNumber(3)
  set orderId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasOrderId() => $_has(2);
  @$pb.TagNumber(3)
  void clearOrderId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get customerEntityId => $_getSZ(3);
  @$pb.TagNumber(4)
  set customerEntityId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasCustomerEntityId() => $_has(3);
  @$pb.TagNumber(4)
  void clearCustomerEntityId() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get productId => $_getSZ(4);
  @$pb.TagNumber(5)
  set productId($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasProductId() => $_has(4);
  @$pb.TagNumber(5)
  void clearProductId() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get offerId => $_getSZ(5);
  @$pb.TagNumber(6)
  set offerId($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasOfferId() => $_has(5);
  @$pb.TagNumber(6)
  void clearOfferId() => $_clearField(6);

  @$pb.TagNumber(7)
  DeliveryType get deliveryType => $_getN(6);
  @$pb.TagNumber(7)
  set deliveryType(DeliveryType value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasDeliveryType() => $_has(6);
  @$pb.TagNumber(7)
  void clearDeliveryType() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get entitlementPayloadJson => $_getSZ(7);
  @$pb.TagNumber(8)
  set entitlementPayloadJson($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasEntitlementPayloadJson() => $_has(7);
  @$pb.TagNumber(8)
  void clearEntitlementPayloadJson() => $_clearField(8);

  @$pb.TagNumber(9)
  DeliveryStatus get status => $_getN(8);
  @$pb.TagNumber(9)
  set status(DeliveryStatus value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasStatus() => $_has(8);
  @$pb.TagNumber(9)
  void clearStatus() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.String get idempotencyKey => $_getSZ(9);
  @$pb.TagNumber(10)
  set idempotencyKey($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasIdempotencyKey() => $_has(9);
  @$pb.TagNumber(10)
  void clearIdempotencyKey() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.int get downloadCount => $_getIZ(10);
  @$pb.TagNumber(11)
  set downloadCount($core.int value) => $_setSignedInt32(10, value);
  @$pb.TagNumber(11)
  $core.bool hasDownloadCount() => $_has(10);
  @$pb.TagNumber(11)
  void clearDownloadCount() => $_clearField(11);

  @$pb.TagNumber(12)
  $core.int get maxDownloads => $_getIZ(11);
  @$pb.TagNumber(12)
  set maxDownloads($core.int value) => $_setSignedInt32(11, value);
  @$pb.TagNumber(12)
  $core.bool hasMaxDownloads() => $_has(11);
  @$pb.TagNumber(12)
  void clearMaxDownloads() => $_clearField(12);

  @$pb.TagNumber(13)
  $1.Timestamp get expiresAt => $_getN(12);
  @$pb.TagNumber(13)
  set expiresAt($1.Timestamp value) => $_setField(13, value);
  @$pb.TagNumber(13)
  $core.bool hasExpiresAt() => $_has(12);
  @$pb.TagNumber(13)
  void clearExpiresAt() => $_clearField(13);
  @$pb.TagNumber(13)
  $1.Timestamp ensureExpiresAt() => $_ensure(12);

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

class BuyerEntitlements extends $pb.GeneratedMessage {
  factory BuyerEntitlements({
    $core.String? customerEntityId,
    $core.String? workspaceId,
    $core.Iterable<$core.String>? accessibleContentIds,
    $core.double? discountPct,
    $core.bool? hasPriorityDm,
    $core.Iterable<DigitalDelivery>? deliveries,
    $core.Iterable<MembershipSubscription>? activeSubscriptions,
  }) {
    final result = BuyerEntitlements._();
    if (customerEntityId != null) result.customerEntityId = customerEntityId;
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (accessibleContentIds != null)
      result.accessibleContentIds.addAll(accessibleContentIds);
    if (discountPct != null) result.discountPct = discountPct;
    if (hasPriorityDm != null) result.hasPriorityDm = hasPriorityDm;
    if (deliveries != null) result.deliveries.addAll(deliveries);
    if (activeSubscriptions != null)
      result.activeSubscriptions.addAll(activeSubscriptions);
    return result;
  }

  BuyerEntitlements._();

  factory BuyerEntitlements.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      BuyerEntitlements()..mergeFromBuffer(data, registry);
  factory BuyerEntitlements.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      BuyerEntitlements()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'BuyerEntitlements',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: BuyerEntitlements.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'customerEntityId')
    ..aOS(2, _omitFieldNames ? '' : 'workspaceId')
    ..pPS(3, _omitFieldNames ? '' : 'accessibleContentIds')
    ..aD(4, _omitFieldNames ? '' : 'discountPct')
    ..aOB(5, _omitFieldNames ? '' : 'hasPriorityDm')
    ..pPM<DigitalDelivery>(6, _omitFieldNames ? '' : 'deliveries',
        subBuilder: DigitalDelivery.$_createMessage)
    ..pPM<MembershipSubscription>(
        7, _omitFieldNames ? '' : 'activeSubscriptions',
        subBuilder: MembershipSubscription.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BuyerEntitlements clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BuyerEntitlements copyWith(void Function(BuyerEntitlements) updates) =>
      super.copyWith((message) => updates(message as BuyerEntitlements))
          as BuyerEntitlements;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use BuyerEntitlements() / BuyerEntitlements.new instead')
  static BuyerEntitlements create() => BuyerEntitlements._();
  static $pb.GeneratedMessage $_createMessage() => BuyerEntitlements._();
  @$core.override
  BuyerEntitlements createEmptyInstance() => BuyerEntitlements._();
  @$core.pragma('dart2js:noInline')
  static BuyerEntitlements getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<BuyerEntitlements>(
          BuyerEntitlements.$_createMessage);
  static BuyerEntitlements? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get customerEntityId => $_getSZ(0);
  @$pb.TagNumber(1)
  set customerEntityId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCustomerEntityId() => $_has(0);
  @$pb.TagNumber(1)
  void clearCustomerEntityId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get workspaceId => $_getSZ(1);
  @$pb.TagNumber(2)
  set workspaceId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasWorkspaceId() => $_has(1);
  @$pb.TagNumber(2)
  void clearWorkspaceId() => $_clearField(2);

  @$pb.TagNumber(3)
  $pb.PbList<$core.String> get accessibleContentIds => $_getList(2);

  @$pb.TagNumber(4)
  $core.double get discountPct => $_getN(3);
  @$pb.TagNumber(4)
  set discountPct($core.double value) => $_setDouble(3, value);
  @$pb.TagNumber(4)
  $core.bool hasDiscountPct() => $_has(3);
  @$pb.TagNumber(4)
  void clearDiscountPct() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.bool get hasPriorityDm => $_getBF(4);
  @$pb.TagNumber(5)
  set hasPriorityDm($core.bool value) => $_setBool(4, value);
  @$pb.TagNumber(5)
  $core.bool hasHasPriorityDm() => $_has(4);
  @$pb.TagNumber(5)
  void clearHasPriorityDm() => $_clearField(5);

  @$pb.TagNumber(6)
  $pb.PbList<DigitalDelivery> get deliveries => $_getList(5);

  @$pb.TagNumber(7)
  $pb.PbList<MembershipSubscription> get activeSubscriptions => $_getList(6);
}

class StoreServiceCreatePageRequest extends $pb.GeneratedMessage {
  factory StoreServiceCreatePageRequest({
    $core.String? workspaceId,
    $core.String? title,
    $core.String? slug,
    $core.String? description,
    $core.String? layoutJson,
    $core.String? themeOverridesJson,
    $core.String? customDomain,
    $core.String? seoConfigJson,
    $core.String? widgetConfigJson,
    $2.CommandContext? commandContext,
  }) {
    final result = StoreServiceCreatePageRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (title != null) result.title = title;
    if (slug != null) result.slug = slug;
    if (description != null) result.description = description;
    if (layoutJson != null) result.layoutJson = layoutJson;
    if (themeOverridesJson != null)
      result.themeOverridesJson = themeOverridesJson;
    if (customDomain != null) result.customDomain = customDomain;
    if (seoConfigJson != null) result.seoConfigJson = seoConfigJson;
    if (widgetConfigJson != null) result.widgetConfigJson = widgetConfigJson;
    if (commandContext != null) result.commandContext = commandContext;
    return result;
  }

  StoreServiceCreatePageRequest._();

  factory StoreServiceCreatePageRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      StoreServiceCreatePageRequest()..mergeFromBuffer(data, registry);
  factory StoreServiceCreatePageRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      StoreServiceCreatePageRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'StoreServiceCreatePageRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: StoreServiceCreatePageRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'title')
    ..aOS(3, _omitFieldNames ? '' : 'slug')
    ..aOS(4, _omitFieldNames ? '' : 'description')
    ..aOS(5, _omitFieldNames ? '' : 'layoutJson')
    ..aOS(6, _omitFieldNames ? '' : 'themeOverridesJson')
    ..aOS(7, _omitFieldNames ? '' : 'customDomain')
    ..aOS(8, _omitFieldNames ? '' : 'seoConfigJson')
    ..aOS(9, _omitFieldNames ? '' : 'widgetConfigJson')
    ..aOM<$2.CommandContext>(10, _omitFieldNames ? '' : 'commandContext',
        subBuilder: $2.CommandContext.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StoreServiceCreatePageRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StoreServiceCreatePageRequest copyWith(
          void Function(StoreServiceCreatePageRequest) updates) =>
      super.copyWith(
              (message) => updates(message as StoreServiceCreatePageRequest))
          as StoreServiceCreatePageRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use StoreServiceCreatePageRequest() / StoreServiceCreatePageRequest.new instead')
  static StoreServiceCreatePageRequest create() =>
      StoreServiceCreatePageRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      StoreServiceCreatePageRequest._();
  @$core.override
  StoreServiceCreatePageRequest createEmptyInstance() =>
      StoreServiceCreatePageRequest._();
  @$core.pragma('dart2js:noInline')
  static StoreServiceCreatePageRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<StoreServiceCreatePageRequest>(
          StoreServiceCreatePageRequest.$_createMessage);
  static StoreServiceCreatePageRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get title => $_getSZ(1);
  @$pb.TagNumber(2)
  set title($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTitle() => $_has(1);
  @$pb.TagNumber(2)
  void clearTitle() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get slug => $_getSZ(2);
  @$pb.TagNumber(3)
  set slug($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasSlug() => $_has(2);
  @$pb.TagNumber(3)
  void clearSlug() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get description => $_getSZ(3);
  @$pb.TagNumber(4)
  set description($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasDescription() => $_has(3);
  @$pb.TagNumber(4)
  void clearDescription() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get layoutJson => $_getSZ(4);
  @$pb.TagNumber(5)
  set layoutJson($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasLayoutJson() => $_has(4);
  @$pb.TagNumber(5)
  void clearLayoutJson() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get themeOverridesJson => $_getSZ(5);
  @$pb.TagNumber(6)
  set themeOverridesJson($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasThemeOverridesJson() => $_has(5);
  @$pb.TagNumber(6)
  void clearThemeOverridesJson() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get customDomain => $_getSZ(6);
  @$pb.TagNumber(7)
  set customDomain($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasCustomDomain() => $_has(6);
  @$pb.TagNumber(7)
  void clearCustomDomain() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get seoConfigJson => $_getSZ(7);
  @$pb.TagNumber(8)
  set seoConfigJson($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasSeoConfigJson() => $_has(7);
  @$pb.TagNumber(8)
  void clearSeoConfigJson() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get widgetConfigJson => $_getSZ(8);
  @$pb.TagNumber(9)
  set widgetConfigJson($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasWidgetConfigJson() => $_has(8);
  @$pb.TagNumber(9)
  void clearWidgetConfigJson() => $_clearField(9);

  @$pb.TagNumber(10)
  $2.CommandContext get commandContext => $_getN(9);
  @$pb.TagNumber(10)
  set commandContext($2.CommandContext value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasCommandContext() => $_has(9);
  @$pb.TagNumber(10)
  void clearCommandContext() => $_clearField(10);
  @$pb.TagNumber(10)
  $2.CommandContext ensureCommandContext() => $_ensure(9);
}

class StoreServiceCreatePageResponse extends $pb.GeneratedMessage {
  factory StoreServiceCreatePageResponse({
    StorePage? page,
  }) {
    final result = StoreServiceCreatePageResponse._();
    if (page != null) result.page = page;
    return result;
  }

  StoreServiceCreatePageResponse._();

  factory StoreServiceCreatePageResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      StoreServiceCreatePageResponse()..mergeFromBuffer(data, registry);
  factory StoreServiceCreatePageResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      StoreServiceCreatePageResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'StoreServiceCreatePageResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: StoreServiceCreatePageResponse.$_createMessage)
    ..aOM<StorePage>(1, _omitFieldNames ? '' : 'page',
        subBuilder: StorePage.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StoreServiceCreatePageResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StoreServiceCreatePageResponse copyWith(
          void Function(StoreServiceCreatePageResponse) updates) =>
      super.copyWith(
              (message) => updates(message as StoreServiceCreatePageResponse))
          as StoreServiceCreatePageResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use StoreServiceCreatePageResponse() / StoreServiceCreatePageResponse.new instead')
  static StoreServiceCreatePageResponse create() =>
      StoreServiceCreatePageResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      StoreServiceCreatePageResponse._();
  @$core.override
  StoreServiceCreatePageResponse createEmptyInstance() =>
      StoreServiceCreatePageResponse._();
  @$core.pragma('dart2js:noInline')
  static StoreServiceCreatePageResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<StoreServiceCreatePageResponse>(
          StoreServiceCreatePageResponse.$_createMessage);
  static StoreServiceCreatePageResponse? _defaultInstance;

  @$pb.TagNumber(1)
  StorePage get page => $_getN(0);
  @$pb.TagNumber(1)
  set page(StorePage value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasPage() => $_has(0);
  @$pb.TagNumber(1)
  void clearPage() => $_clearField(1);
  @$pb.TagNumber(1)
  StorePage ensurePage() => $_ensure(0);
}

class StoreServiceGetRequest extends $pb.GeneratedMessage {
  factory StoreServiceGetRequest({
    $core.String? workspaceId,
    $core.String? storePageId,
    $core.String? slug,
  }) {
    final result = StoreServiceGetRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (storePageId != null) result.storePageId = storePageId;
    if (slug != null) result.slug = slug;
    return result;
  }

  StoreServiceGetRequest._();

  factory StoreServiceGetRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      StoreServiceGetRequest()..mergeFromBuffer(data, registry);
  factory StoreServiceGetRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      StoreServiceGetRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'StoreServiceGetRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: StoreServiceGetRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'storePageId')
    ..aOS(3, _omitFieldNames ? '' : 'slug')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StoreServiceGetRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StoreServiceGetRequest copyWith(
          void Function(StoreServiceGetRequest) updates) =>
      super.copyWith((message) => updates(message as StoreServiceGetRequest))
          as StoreServiceGetRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use StoreServiceGetRequest() / StoreServiceGetRequest.new instead')
  static StoreServiceGetRequest create() => StoreServiceGetRequest._();
  static $pb.GeneratedMessage $_createMessage() => StoreServiceGetRequest._();
  @$core.override
  StoreServiceGetRequest createEmptyInstance() => StoreServiceGetRequest._();
  @$core.pragma('dart2js:noInline')
  static StoreServiceGetRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<StoreServiceGetRequest>(
          StoreServiceGetRequest.$_createMessage);
  static StoreServiceGetRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get storePageId => $_getSZ(1);
  @$pb.TagNumber(2)
  set storePageId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasStorePageId() => $_has(1);
  @$pb.TagNumber(2)
  void clearStorePageId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get slug => $_getSZ(2);
  @$pb.TagNumber(3)
  set slug($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasSlug() => $_has(2);
  @$pb.TagNumber(3)
  void clearSlug() => $_clearField(3);
}

class StoreServiceGetResponse extends $pb.GeneratedMessage {
  factory StoreServiceGetResponse({
    StorePage? page,
    $core.Iterable<Bundle>? featuredBundles,
  }) {
    final result = StoreServiceGetResponse._();
    if (page != null) result.page = page;
    if (featuredBundles != null) result.featuredBundles.addAll(featuredBundles);
    return result;
  }

  StoreServiceGetResponse._();

  factory StoreServiceGetResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      StoreServiceGetResponse()..mergeFromBuffer(data, registry);
  factory StoreServiceGetResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      StoreServiceGetResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'StoreServiceGetResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: StoreServiceGetResponse.$_createMessage)
    ..aOM<StorePage>(1, _omitFieldNames ? '' : 'page',
        subBuilder: StorePage.$_createMessage)
    ..pPM<Bundle>(2, _omitFieldNames ? '' : 'featuredBundles',
        subBuilder: Bundle.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StoreServiceGetResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StoreServiceGetResponse copyWith(
          void Function(StoreServiceGetResponse) updates) =>
      super.copyWith((message) => updates(message as StoreServiceGetResponse))
          as StoreServiceGetResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use StoreServiceGetResponse() / StoreServiceGetResponse.new instead')
  static StoreServiceGetResponse create() => StoreServiceGetResponse._();
  static $pb.GeneratedMessage $_createMessage() => StoreServiceGetResponse._();
  @$core.override
  StoreServiceGetResponse createEmptyInstance() => StoreServiceGetResponse._();
  @$core.pragma('dart2js:noInline')
  static StoreServiceGetResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<StoreServiceGetResponse>(
          StoreServiceGetResponse.$_createMessage);
  static StoreServiceGetResponse? _defaultInstance;

  @$pb.TagNumber(1)
  StorePage get page => $_getN(0);
  @$pb.TagNumber(1)
  set page(StorePage value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasPage() => $_has(0);
  @$pb.TagNumber(1)
  void clearPage() => $_clearField(1);
  @$pb.TagNumber(1)
  StorePage ensurePage() => $_ensure(0);

  @$pb.TagNumber(2)
  $pb.PbList<Bundle> get featuredBundles => $_getList(1);
}

class StoreServiceGetPageRequest extends $pb.GeneratedMessage {
  factory StoreServiceGetPageRequest({
    $core.String? workspaceId,
    $core.String? storePageId,
    $core.String? slug,
  }) {
    final result = StoreServiceGetPageRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (storePageId != null) result.storePageId = storePageId;
    if (slug != null) result.slug = slug;
    return result;
  }

  StoreServiceGetPageRequest._();

  factory StoreServiceGetPageRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      StoreServiceGetPageRequest()..mergeFromBuffer(data, registry);
  factory StoreServiceGetPageRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      StoreServiceGetPageRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'StoreServiceGetPageRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: StoreServiceGetPageRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'storePageId')
    ..aOS(3, _omitFieldNames ? '' : 'slug')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StoreServiceGetPageRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StoreServiceGetPageRequest copyWith(
          void Function(StoreServiceGetPageRequest) updates) =>
      super.copyWith(
              (message) => updates(message as StoreServiceGetPageRequest))
          as StoreServiceGetPageRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use StoreServiceGetPageRequest() / StoreServiceGetPageRequest.new instead')
  static StoreServiceGetPageRequest create() => StoreServiceGetPageRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      StoreServiceGetPageRequest._();
  @$core.override
  StoreServiceGetPageRequest createEmptyInstance() =>
      StoreServiceGetPageRequest._();
  @$core.pragma('dart2js:noInline')
  static StoreServiceGetPageRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<StoreServiceGetPageRequest>(
          StoreServiceGetPageRequest.$_createMessage);
  static StoreServiceGetPageRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get storePageId => $_getSZ(1);
  @$pb.TagNumber(2)
  set storePageId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasStorePageId() => $_has(1);
  @$pb.TagNumber(2)
  void clearStorePageId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get slug => $_getSZ(2);
  @$pb.TagNumber(3)
  set slug($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasSlug() => $_has(2);
  @$pb.TagNumber(3)
  void clearSlug() => $_clearField(3);
}

class StoreServiceGetPageResponse extends $pb.GeneratedMessage {
  factory StoreServiceGetPageResponse({
    StorePage? page,
    $core.Iterable<Bundle>? featuredBundles,
  }) {
    final result = StoreServiceGetPageResponse._();
    if (page != null) result.page = page;
    if (featuredBundles != null) result.featuredBundles.addAll(featuredBundles);
    return result;
  }

  StoreServiceGetPageResponse._();

  factory StoreServiceGetPageResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      StoreServiceGetPageResponse()..mergeFromBuffer(data, registry);
  factory StoreServiceGetPageResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      StoreServiceGetPageResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'StoreServiceGetPageResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: StoreServiceGetPageResponse.$_createMessage)
    ..aOM<StorePage>(1, _omitFieldNames ? '' : 'page',
        subBuilder: StorePage.$_createMessage)
    ..pPM<Bundle>(2, _omitFieldNames ? '' : 'featuredBundles',
        subBuilder: Bundle.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StoreServiceGetPageResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StoreServiceGetPageResponse copyWith(
          void Function(StoreServiceGetPageResponse) updates) =>
      super.copyWith(
              (message) => updates(message as StoreServiceGetPageResponse))
          as StoreServiceGetPageResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use StoreServiceGetPageResponse() / StoreServiceGetPageResponse.new instead')
  static StoreServiceGetPageResponse create() =>
      StoreServiceGetPageResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      StoreServiceGetPageResponse._();
  @$core.override
  StoreServiceGetPageResponse createEmptyInstance() =>
      StoreServiceGetPageResponse._();
  @$core.pragma('dart2js:noInline')
  static StoreServiceGetPageResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<StoreServiceGetPageResponse>(
          StoreServiceGetPageResponse.$_createMessage);
  static StoreServiceGetPageResponse? _defaultInstance;

  @$pb.TagNumber(1)
  StorePage get page => $_getN(0);
  @$pb.TagNumber(1)
  set page(StorePage value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasPage() => $_has(0);
  @$pb.TagNumber(1)
  void clearPage() => $_clearField(1);
  @$pb.TagNumber(1)
  StorePage ensurePage() => $_ensure(0);

  @$pb.TagNumber(2)
  $pb.PbList<Bundle> get featuredBundles => $_getList(1);
}

class StoreServiceListRequest extends $pb.GeneratedMessage {
  factory StoreServiceListRequest({
    $core.String? workspaceId,
    $core.int? pageSize,
    $core.String? pageToken,
    StorePageStatus? statusFilter,
  }) {
    final result = StoreServiceListRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (pageSize != null) result.pageSize = pageSize;
    if (pageToken != null) result.pageToken = pageToken;
    if (statusFilter != null) result.statusFilter = statusFilter;
    return result;
  }

  StoreServiceListRequest._();

  factory StoreServiceListRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      StoreServiceListRequest()..mergeFromBuffer(data, registry);
  factory StoreServiceListRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      StoreServiceListRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'StoreServiceListRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: StoreServiceListRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aI(2, _omitFieldNames ? '' : 'pageSize')
    ..aOS(3, _omitFieldNames ? '' : 'pageToken')
    ..aE<StorePageStatus>(4, _omitFieldNames ? '' : 'statusFilter',
        enumValues: StorePageStatus.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StoreServiceListRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StoreServiceListRequest copyWith(
          void Function(StoreServiceListRequest) updates) =>
      super.copyWith((message) => updates(message as StoreServiceListRequest))
          as StoreServiceListRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use StoreServiceListRequest() / StoreServiceListRequest.new instead')
  static StoreServiceListRequest create() => StoreServiceListRequest._();
  static $pb.GeneratedMessage $_createMessage() => StoreServiceListRequest._();
  @$core.override
  StoreServiceListRequest createEmptyInstance() => StoreServiceListRequest._();
  @$core.pragma('dart2js:noInline')
  static StoreServiceListRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<StoreServiceListRequest>(
          StoreServiceListRequest.$_createMessage);
  static StoreServiceListRequest? _defaultInstance;

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
  StorePageStatus get statusFilter => $_getN(3);
  @$pb.TagNumber(4)
  set statusFilter(StorePageStatus value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasStatusFilter() => $_has(3);
  @$pb.TagNumber(4)
  void clearStatusFilter() => $_clearField(4);
}

class StoreServiceListResponse extends $pb.GeneratedMessage {
  factory StoreServiceListResponse({
    $core.Iterable<StorePage>? pages,
    $core.String? nextPageToken,
    $fixnum.Int64? totalCount,
  }) {
    final result = StoreServiceListResponse._();
    if (pages != null) result.pages.addAll(pages);
    if (nextPageToken != null) result.nextPageToken = nextPageToken;
    if (totalCount != null) result.totalCount = totalCount;
    return result;
  }

  StoreServiceListResponse._();

  factory StoreServiceListResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      StoreServiceListResponse()..mergeFromBuffer(data, registry);
  factory StoreServiceListResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      StoreServiceListResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'StoreServiceListResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: StoreServiceListResponse.$_createMessage)
    ..pPM<StorePage>(1, _omitFieldNames ? '' : 'pages',
        subBuilder: StorePage.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'nextPageToken')
    ..aInt64(3, _omitFieldNames ? '' : 'totalCount')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StoreServiceListResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StoreServiceListResponse copyWith(
          void Function(StoreServiceListResponse) updates) =>
      super.copyWith((message) => updates(message as StoreServiceListResponse))
          as StoreServiceListResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use StoreServiceListResponse() / StoreServiceListResponse.new instead')
  static StoreServiceListResponse create() => StoreServiceListResponse._();
  static $pb.GeneratedMessage $_createMessage() => StoreServiceListResponse._();
  @$core.override
  StoreServiceListResponse createEmptyInstance() =>
      StoreServiceListResponse._();
  @$core.pragma('dart2js:noInline')
  static StoreServiceListResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<StoreServiceListResponse>(
          StoreServiceListResponse.$_createMessage);
  static StoreServiceListResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<StorePage> get pages => $_getList(0);

  @$pb.TagNumber(2)
  $core.String get nextPageToken => $_getSZ(1);
  @$pb.TagNumber(2)
  set nextPageToken($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasNextPageToken() => $_has(1);
  @$pb.TagNumber(2)
  void clearNextPageToken() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get totalCount => $_getI64(2);
  @$pb.TagNumber(3)
  set totalCount($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasTotalCount() => $_has(2);
  @$pb.TagNumber(3)
  void clearTotalCount() => $_clearField(3);
}

class StoreServiceListPagesRequest extends $pb.GeneratedMessage {
  factory StoreServiceListPagesRequest({
    $core.String? workspaceId,
    $core.int? pageSize,
    $core.String? pageToken,
    StorePageStatus? statusFilter,
  }) {
    final result = StoreServiceListPagesRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (pageSize != null) result.pageSize = pageSize;
    if (pageToken != null) result.pageToken = pageToken;
    if (statusFilter != null) result.statusFilter = statusFilter;
    return result;
  }

  StoreServiceListPagesRequest._();

  factory StoreServiceListPagesRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      StoreServiceListPagesRequest()..mergeFromBuffer(data, registry);
  factory StoreServiceListPagesRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      StoreServiceListPagesRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'StoreServiceListPagesRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: StoreServiceListPagesRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aI(2, _omitFieldNames ? '' : 'pageSize')
    ..aOS(3, _omitFieldNames ? '' : 'pageToken')
    ..aE<StorePageStatus>(4, _omitFieldNames ? '' : 'statusFilter',
        enumValues: StorePageStatus.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StoreServiceListPagesRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StoreServiceListPagesRequest copyWith(
          void Function(StoreServiceListPagesRequest) updates) =>
      super.copyWith(
              (message) => updates(message as StoreServiceListPagesRequest))
          as StoreServiceListPagesRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use StoreServiceListPagesRequest() / StoreServiceListPagesRequest.new instead')
  static StoreServiceListPagesRequest create() =>
      StoreServiceListPagesRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      StoreServiceListPagesRequest._();
  @$core.override
  StoreServiceListPagesRequest createEmptyInstance() =>
      StoreServiceListPagesRequest._();
  @$core.pragma('dart2js:noInline')
  static StoreServiceListPagesRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<StoreServiceListPagesRequest>(
          StoreServiceListPagesRequest.$_createMessage);
  static StoreServiceListPagesRequest? _defaultInstance;

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
  StorePageStatus get statusFilter => $_getN(3);
  @$pb.TagNumber(4)
  set statusFilter(StorePageStatus value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasStatusFilter() => $_has(3);
  @$pb.TagNumber(4)
  void clearStatusFilter() => $_clearField(4);
}

class StoreServiceListPagesResponse extends $pb.GeneratedMessage {
  factory StoreServiceListPagesResponse({
    $core.Iterable<StorePage>? pages,
    $core.String? nextPageToken,
    $fixnum.Int64? totalCount,
  }) {
    final result = StoreServiceListPagesResponse._();
    if (pages != null) result.pages.addAll(pages);
    if (nextPageToken != null) result.nextPageToken = nextPageToken;
    if (totalCount != null) result.totalCount = totalCount;
    return result;
  }

  StoreServiceListPagesResponse._();

  factory StoreServiceListPagesResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      StoreServiceListPagesResponse()..mergeFromBuffer(data, registry);
  factory StoreServiceListPagesResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      StoreServiceListPagesResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'StoreServiceListPagesResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: StoreServiceListPagesResponse.$_createMessage)
    ..pPM<StorePage>(1, _omitFieldNames ? '' : 'pages',
        subBuilder: StorePage.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'nextPageToken')
    ..aInt64(3, _omitFieldNames ? '' : 'totalCount')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StoreServiceListPagesResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StoreServiceListPagesResponse copyWith(
          void Function(StoreServiceListPagesResponse) updates) =>
      super.copyWith(
              (message) => updates(message as StoreServiceListPagesResponse))
          as StoreServiceListPagesResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use StoreServiceListPagesResponse() / StoreServiceListPagesResponse.new instead')
  static StoreServiceListPagesResponse create() =>
      StoreServiceListPagesResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      StoreServiceListPagesResponse._();
  @$core.override
  StoreServiceListPagesResponse createEmptyInstance() =>
      StoreServiceListPagesResponse._();
  @$core.pragma('dart2js:noInline')
  static StoreServiceListPagesResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<StoreServiceListPagesResponse>(
          StoreServiceListPagesResponse.$_createMessage);
  static StoreServiceListPagesResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<StorePage> get pages => $_getList(0);

  @$pb.TagNumber(2)
  $core.String get nextPageToken => $_getSZ(1);
  @$pb.TagNumber(2)
  set nextPageToken($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasNextPageToken() => $_has(1);
  @$pb.TagNumber(2)
  void clearNextPageToken() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get totalCount => $_getI64(2);
  @$pb.TagNumber(3)
  set totalCount($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasTotalCount() => $_has(2);
  @$pb.TagNumber(3)
  void clearTotalCount() => $_clearField(3);
}

class StoreServiceUpdatePageRequest extends $pb.GeneratedMessage {
  factory StoreServiceUpdatePageRequest({
    $core.String? workspaceId,
    $core.String? storePageId,
    $core.String? title,
    $core.String? slug,
    $core.String? description,
    $core.String? layoutJson,
    $core.String? themeOverridesJson,
    $core.String? customDomain,
    $core.String? seoConfigJson,
    $core.String? widgetConfigJson,
    $2.CommandContext? commandContext,
  }) {
    final result = StoreServiceUpdatePageRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (storePageId != null) result.storePageId = storePageId;
    if (title != null) result.title = title;
    if (slug != null) result.slug = slug;
    if (description != null) result.description = description;
    if (layoutJson != null) result.layoutJson = layoutJson;
    if (themeOverridesJson != null)
      result.themeOverridesJson = themeOverridesJson;
    if (customDomain != null) result.customDomain = customDomain;
    if (seoConfigJson != null) result.seoConfigJson = seoConfigJson;
    if (widgetConfigJson != null) result.widgetConfigJson = widgetConfigJson;
    if (commandContext != null) result.commandContext = commandContext;
    return result;
  }

  StoreServiceUpdatePageRequest._();

  factory StoreServiceUpdatePageRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      StoreServiceUpdatePageRequest()..mergeFromBuffer(data, registry);
  factory StoreServiceUpdatePageRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      StoreServiceUpdatePageRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'StoreServiceUpdatePageRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: StoreServiceUpdatePageRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'storePageId')
    ..aOS(3, _omitFieldNames ? '' : 'title')
    ..aOS(4, _omitFieldNames ? '' : 'slug')
    ..aOS(5, _omitFieldNames ? '' : 'description')
    ..aOS(6, _omitFieldNames ? '' : 'layoutJson')
    ..aOS(7, _omitFieldNames ? '' : 'themeOverridesJson')
    ..aOS(8, _omitFieldNames ? '' : 'customDomain')
    ..aOS(9, _omitFieldNames ? '' : 'seoConfigJson')
    ..aOS(10, _omitFieldNames ? '' : 'widgetConfigJson')
    ..aOM<$2.CommandContext>(11, _omitFieldNames ? '' : 'commandContext',
        subBuilder: $2.CommandContext.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StoreServiceUpdatePageRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StoreServiceUpdatePageRequest copyWith(
          void Function(StoreServiceUpdatePageRequest) updates) =>
      super.copyWith(
              (message) => updates(message as StoreServiceUpdatePageRequest))
          as StoreServiceUpdatePageRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use StoreServiceUpdatePageRequest() / StoreServiceUpdatePageRequest.new instead')
  static StoreServiceUpdatePageRequest create() =>
      StoreServiceUpdatePageRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      StoreServiceUpdatePageRequest._();
  @$core.override
  StoreServiceUpdatePageRequest createEmptyInstance() =>
      StoreServiceUpdatePageRequest._();
  @$core.pragma('dart2js:noInline')
  static StoreServiceUpdatePageRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<StoreServiceUpdatePageRequest>(
          StoreServiceUpdatePageRequest.$_createMessage);
  static StoreServiceUpdatePageRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get storePageId => $_getSZ(1);
  @$pb.TagNumber(2)
  set storePageId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasStorePageId() => $_has(1);
  @$pb.TagNumber(2)
  void clearStorePageId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get title => $_getSZ(2);
  @$pb.TagNumber(3)
  set title($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasTitle() => $_has(2);
  @$pb.TagNumber(3)
  void clearTitle() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get slug => $_getSZ(3);
  @$pb.TagNumber(4)
  set slug($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasSlug() => $_has(3);
  @$pb.TagNumber(4)
  void clearSlug() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get description => $_getSZ(4);
  @$pb.TagNumber(5)
  set description($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasDescription() => $_has(4);
  @$pb.TagNumber(5)
  void clearDescription() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get layoutJson => $_getSZ(5);
  @$pb.TagNumber(6)
  set layoutJson($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasLayoutJson() => $_has(5);
  @$pb.TagNumber(6)
  void clearLayoutJson() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get themeOverridesJson => $_getSZ(6);
  @$pb.TagNumber(7)
  set themeOverridesJson($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasThemeOverridesJson() => $_has(6);
  @$pb.TagNumber(7)
  void clearThemeOverridesJson() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get customDomain => $_getSZ(7);
  @$pb.TagNumber(8)
  set customDomain($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasCustomDomain() => $_has(7);
  @$pb.TagNumber(8)
  void clearCustomDomain() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get seoConfigJson => $_getSZ(8);
  @$pb.TagNumber(9)
  set seoConfigJson($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasSeoConfigJson() => $_has(8);
  @$pb.TagNumber(9)
  void clearSeoConfigJson() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.String get widgetConfigJson => $_getSZ(9);
  @$pb.TagNumber(10)
  set widgetConfigJson($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasWidgetConfigJson() => $_has(9);
  @$pb.TagNumber(10)
  void clearWidgetConfigJson() => $_clearField(10);

  @$pb.TagNumber(11)
  $2.CommandContext get commandContext => $_getN(10);
  @$pb.TagNumber(11)
  set commandContext($2.CommandContext value) => $_setField(11, value);
  @$pb.TagNumber(11)
  $core.bool hasCommandContext() => $_has(10);
  @$pb.TagNumber(11)
  void clearCommandContext() => $_clearField(11);
  @$pb.TagNumber(11)
  $2.CommandContext ensureCommandContext() => $_ensure(10);
}

class StoreServiceUpdatePageResponse extends $pb.GeneratedMessage {
  factory StoreServiceUpdatePageResponse({
    StorePage? page,
  }) {
    final result = StoreServiceUpdatePageResponse._();
    if (page != null) result.page = page;
    return result;
  }

  StoreServiceUpdatePageResponse._();

  factory StoreServiceUpdatePageResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      StoreServiceUpdatePageResponse()..mergeFromBuffer(data, registry);
  factory StoreServiceUpdatePageResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      StoreServiceUpdatePageResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'StoreServiceUpdatePageResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: StoreServiceUpdatePageResponse.$_createMessage)
    ..aOM<StorePage>(1, _omitFieldNames ? '' : 'page',
        subBuilder: StorePage.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StoreServiceUpdatePageResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StoreServiceUpdatePageResponse copyWith(
          void Function(StoreServiceUpdatePageResponse) updates) =>
      super.copyWith(
              (message) => updates(message as StoreServiceUpdatePageResponse))
          as StoreServiceUpdatePageResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use StoreServiceUpdatePageResponse() / StoreServiceUpdatePageResponse.new instead')
  static StoreServiceUpdatePageResponse create() =>
      StoreServiceUpdatePageResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      StoreServiceUpdatePageResponse._();
  @$core.override
  StoreServiceUpdatePageResponse createEmptyInstance() =>
      StoreServiceUpdatePageResponse._();
  @$core.pragma('dart2js:noInline')
  static StoreServiceUpdatePageResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<StoreServiceUpdatePageResponse>(
          StoreServiceUpdatePageResponse.$_createMessage);
  static StoreServiceUpdatePageResponse? _defaultInstance;

  @$pb.TagNumber(1)
  StorePage get page => $_getN(0);
  @$pb.TagNumber(1)
  set page(StorePage value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasPage() => $_has(0);
  @$pb.TagNumber(1)
  void clearPage() => $_clearField(1);
  @$pb.TagNumber(1)
  StorePage ensurePage() => $_ensure(0);
}

class StoreServicePublishPageRequest extends $pb.GeneratedMessage {
  factory StoreServicePublishPageRequest({
    $core.String? workspaceId,
    $core.String? storePageId,
    $2.CommandContext? commandContext,
  }) {
    final result = StoreServicePublishPageRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (storePageId != null) result.storePageId = storePageId;
    if (commandContext != null) result.commandContext = commandContext;
    return result;
  }

  StoreServicePublishPageRequest._();

  factory StoreServicePublishPageRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      StoreServicePublishPageRequest()..mergeFromBuffer(data, registry);
  factory StoreServicePublishPageRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      StoreServicePublishPageRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'StoreServicePublishPageRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: StoreServicePublishPageRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'storePageId')
    ..aOM<$2.CommandContext>(3, _omitFieldNames ? '' : 'commandContext',
        subBuilder: $2.CommandContext.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StoreServicePublishPageRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StoreServicePublishPageRequest copyWith(
          void Function(StoreServicePublishPageRequest) updates) =>
      super.copyWith(
              (message) => updates(message as StoreServicePublishPageRequest))
          as StoreServicePublishPageRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use StoreServicePublishPageRequest() / StoreServicePublishPageRequest.new instead')
  static StoreServicePublishPageRequest create() =>
      StoreServicePublishPageRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      StoreServicePublishPageRequest._();
  @$core.override
  StoreServicePublishPageRequest createEmptyInstance() =>
      StoreServicePublishPageRequest._();
  @$core.pragma('dart2js:noInline')
  static StoreServicePublishPageRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<StoreServicePublishPageRequest>(
          StoreServicePublishPageRequest.$_createMessage);
  static StoreServicePublishPageRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get storePageId => $_getSZ(1);
  @$pb.TagNumber(2)
  set storePageId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasStorePageId() => $_has(1);
  @$pb.TagNumber(2)
  void clearStorePageId() => $_clearField(2);

  @$pb.TagNumber(3)
  $2.CommandContext get commandContext => $_getN(2);
  @$pb.TagNumber(3)
  set commandContext($2.CommandContext value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasCommandContext() => $_has(2);
  @$pb.TagNumber(3)
  void clearCommandContext() => $_clearField(3);
  @$pb.TagNumber(3)
  $2.CommandContext ensureCommandContext() => $_ensure(2);
}

class StoreServicePublishPageResponse extends $pb.GeneratedMessage {
  factory StoreServicePublishPageResponse({
    StorePage? page,
    $core.String? publicUrl,
  }) {
    final result = StoreServicePublishPageResponse._();
    if (page != null) result.page = page;
    if (publicUrl != null) result.publicUrl = publicUrl;
    return result;
  }

  StoreServicePublishPageResponse._();

  factory StoreServicePublishPageResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      StoreServicePublishPageResponse()..mergeFromBuffer(data, registry);
  factory StoreServicePublishPageResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      StoreServicePublishPageResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'StoreServicePublishPageResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: StoreServicePublishPageResponse.$_createMessage)
    ..aOM<StorePage>(1, _omitFieldNames ? '' : 'page',
        subBuilder: StorePage.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'publicUrl')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StoreServicePublishPageResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StoreServicePublishPageResponse copyWith(
          void Function(StoreServicePublishPageResponse) updates) =>
      super.copyWith(
              (message) => updates(message as StoreServicePublishPageResponse))
          as StoreServicePublishPageResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use StoreServicePublishPageResponse() / StoreServicePublishPageResponse.new instead')
  static StoreServicePublishPageResponse create() =>
      StoreServicePublishPageResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      StoreServicePublishPageResponse._();
  @$core.override
  StoreServicePublishPageResponse createEmptyInstance() =>
      StoreServicePublishPageResponse._();
  @$core.pragma('dart2js:noInline')
  static StoreServicePublishPageResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<StoreServicePublishPageResponse>(
          StoreServicePublishPageResponse.$_createMessage);
  static StoreServicePublishPageResponse? _defaultInstance;

  @$pb.TagNumber(1)
  StorePage get page => $_getN(0);
  @$pb.TagNumber(1)
  set page(StorePage value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasPage() => $_has(0);
  @$pb.TagNumber(1)
  void clearPage() => $_clearField(1);
  @$pb.TagNumber(1)
  StorePage ensurePage() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get publicUrl => $_getSZ(1);
  @$pb.TagNumber(2)
  set publicUrl($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPublicUrl() => $_has(1);
  @$pb.TagNumber(2)
  void clearPublicUrl() => $_clearField(2);
}

class StoreServicePublishRequest extends $pb.GeneratedMessage {
  factory StoreServicePublishRequest({
    $core.String? workspaceId,
    $core.String? storePageId,
    $2.CommandContext? commandContext,
  }) {
    final result = StoreServicePublishRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (storePageId != null) result.storePageId = storePageId;
    if (commandContext != null) result.commandContext = commandContext;
    return result;
  }

  StoreServicePublishRequest._();

  factory StoreServicePublishRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      StoreServicePublishRequest()..mergeFromBuffer(data, registry);
  factory StoreServicePublishRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      StoreServicePublishRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'StoreServicePublishRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: StoreServicePublishRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'storePageId')
    ..aOM<$2.CommandContext>(3, _omitFieldNames ? '' : 'commandContext',
        subBuilder: $2.CommandContext.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StoreServicePublishRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StoreServicePublishRequest copyWith(
          void Function(StoreServicePublishRequest) updates) =>
      super.copyWith(
              (message) => updates(message as StoreServicePublishRequest))
          as StoreServicePublishRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use StoreServicePublishRequest() / StoreServicePublishRequest.new instead')
  static StoreServicePublishRequest create() => StoreServicePublishRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      StoreServicePublishRequest._();
  @$core.override
  StoreServicePublishRequest createEmptyInstance() =>
      StoreServicePublishRequest._();
  @$core.pragma('dart2js:noInline')
  static StoreServicePublishRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<StoreServicePublishRequest>(
          StoreServicePublishRequest.$_createMessage);
  static StoreServicePublishRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get storePageId => $_getSZ(1);
  @$pb.TagNumber(2)
  set storePageId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasStorePageId() => $_has(1);
  @$pb.TagNumber(2)
  void clearStorePageId() => $_clearField(2);

  @$pb.TagNumber(3)
  $2.CommandContext get commandContext => $_getN(2);
  @$pb.TagNumber(3)
  set commandContext($2.CommandContext value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasCommandContext() => $_has(2);
  @$pb.TagNumber(3)
  void clearCommandContext() => $_clearField(3);
  @$pb.TagNumber(3)
  $2.CommandContext ensureCommandContext() => $_ensure(2);
}

class StoreServicePublishResponse extends $pb.GeneratedMessage {
  factory StoreServicePublishResponse({
    StorePage? page,
    $core.String? publicUrl,
  }) {
    final result = StoreServicePublishResponse._();
    if (page != null) result.page = page;
    if (publicUrl != null) result.publicUrl = publicUrl;
    return result;
  }

  StoreServicePublishResponse._();

  factory StoreServicePublishResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      StoreServicePublishResponse()..mergeFromBuffer(data, registry);
  factory StoreServicePublishResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      StoreServicePublishResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'StoreServicePublishResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: StoreServicePublishResponse.$_createMessage)
    ..aOM<StorePage>(1, _omitFieldNames ? '' : 'page',
        subBuilder: StorePage.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'publicUrl')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StoreServicePublishResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StoreServicePublishResponse copyWith(
          void Function(StoreServicePublishResponse) updates) =>
      super.copyWith(
              (message) => updates(message as StoreServicePublishResponse))
          as StoreServicePublishResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use StoreServicePublishResponse() / StoreServicePublishResponse.new instead')
  static StoreServicePublishResponse create() =>
      StoreServicePublishResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      StoreServicePublishResponse._();
  @$core.override
  StoreServicePublishResponse createEmptyInstance() =>
      StoreServicePublishResponse._();
  @$core.pragma('dart2js:noInline')
  static StoreServicePublishResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<StoreServicePublishResponse>(
          StoreServicePublishResponse.$_createMessage);
  static StoreServicePublishResponse? _defaultInstance;

  @$pb.TagNumber(1)
  StorePage get page => $_getN(0);
  @$pb.TagNumber(1)
  set page(StorePage value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasPage() => $_has(0);
  @$pb.TagNumber(1)
  void clearPage() => $_clearField(1);
  @$pb.TagNumber(1)
  StorePage ensurePage() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get publicUrl => $_getSZ(1);
  @$pb.TagNumber(2)
  set publicUrl($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPublicUrl() => $_has(1);
  @$pb.TagNumber(2)
  void clearPublicUrl() => $_clearField(2);
}

class StoreServiceUnpublishRequest extends $pb.GeneratedMessage {
  factory StoreServiceUnpublishRequest({
    $core.String? workspaceId,
    $core.String? storePageId,
    $2.CommandContext? commandContext,
  }) {
    final result = StoreServiceUnpublishRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (storePageId != null) result.storePageId = storePageId;
    if (commandContext != null) result.commandContext = commandContext;
    return result;
  }

  StoreServiceUnpublishRequest._();

  factory StoreServiceUnpublishRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      StoreServiceUnpublishRequest()..mergeFromBuffer(data, registry);
  factory StoreServiceUnpublishRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      StoreServiceUnpublishRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'StoreServiceUnpublishRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: StoreServiceUnpublishRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'storePageId')
    ..aOM<$2.CommandContext>(3, _omitFieldNames ? '' : 'commandContext',
        subBuilder: $2.CommandContext.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StoreServiceUnpublishRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StoreServiceUnpublishRequest copyWith(
          void Function(StoreServiceUnpublishRequest) updates) =>
      super.copyWith(
              (message) => updates(message as StoreServiceUnpublishRequest))
          as StoreServiceUnpublishRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use StoreServiceUnpublishRequest() / StoreServiceUnpublishRequest.new instead')
  static StoreServiceUnpublishRequest create() =>
      StoreServiceUnpublishRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      StoreServiceUnpublishRequest._();
  @$core.override
  StoreServiceUnpublishRequest createEmptyInstance() =>
      StoreServiceUnpublishRequest._();
  @$core.pragma('dart2js:noInline')
  static StoreServiceUnpublishRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<StoreServiceUnpublishRequest>(
          StoreServiceUnpublishRequest.$_createMessage);
  static StoreServiceUnpublishRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get storePageId => $_getSZ(1);
  @$pb.TagNumber(2)
  set storePageId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasStorePageId() => $_has(1);
  @$pb.TagNumber(2)
  void clearStorePageId() => $_clearField(2);

  @$pb.TagNumber(3)
  $2.CommandContext get commandContext => $_getN(2);
  @$pb.TagNumber(3)
  set commandContext($2.CommandContext value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasCommandContext() => $_has(2);
  @$pb.TagNumber(3)
  void clearCommandContext() => $_clearField(3);
  @$pb.TagNumber(3)
  $2.CommandContext ensureCommandContext() => $_ensure(2);
}

class StoreServiceUnpublishResponse extends $pb.GeneratedMessage {
  factory StoreServiceUnpublishResponse({
    StorePage? page,
  }) {
    final result = StoreServiceUnpublishResponse._();
    if (page != null) result.page = page;
    return result;
  }

  StoreServiceUnpublishResponse._();

  factory StoreServiceUnpublishResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      StoreServiceUnpublishResponse()..mergeFromBuffer(data, registry);
  factory StoreServiceUnpublishResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      StoreServiceUnpublishResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'StoreServiceUnpublishResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: StoreServiceUnpublishResponse.$_createMessage)
    ..aOM<StorePage>(1, _omitFieldNames ? '' : 'page',
        subBuilder: StorePage.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StoreServiceUnpublishResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StoreServiceUnpublishResponse copyWith(
          void Function(StoreServiceUnpublishResponse) updates) =>
      super.copyWith(
              (message) => updates(message as StoreServiceUnpublishResponse))
          as StoreServiceUnpublishResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use StoreServiceUnpublishResponse() / StoreServiceUnpublishResponse.new instead')
  static StoreServiceUnpublishResponse create() =>
      StoreServiceUnpublishResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      StoreServiceUnpublishResponse._();
  @$core.override
  StoreServiceUnpublishResponse createEmptyInstance() =>
      StoreServiceUnpublishResponse._();
  @$core.pragma('dart2js:noInline')
  static StoreServiceUnpublishResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<StoreServiceUnpublishResponse>(
          StoreServiceUnpublishResponse.$_createMessage);
  static StoreServiceUnpublishResponse? _defaultInstance;

  @$pb.TagNumber(1)
  StorePage get page => $_getN(0);
  @$pb.TagNumber(1)
  set page(StorePage value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasPage() => $_has(0);
  @$pb.TagNumber(1)
  void clearPage() => $_clearField(1);
  @$pb.TagNumber(1)
  StorePage ensurePage() => $_ensure(0);
}

class StoreServiceDeletePageRequest extends $pb.GeneratedMessage {
  factory StoreServiceDeletePageRequest({
    $core.String? workspaceId,
    $core.String? storePageId,
    $2.CommandContext? commandContext,
  }) {
    final result = StoreServiceDeletePageRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (storePageId != null) result.storePageId = storePageId;
    if (commandContext != null) result.commandContext = commandContext;
    return result;
  }

  StoreServiceDeletePageRequest._();

  factory StoreServiceDeletePageRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      StoreServiceDeletePageRequest()..mergeFromBuffer(data, registry);
  factory StoreServiceDeletePageRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      StoreServiceDeletePageRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'StoreServiceDeletePageRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: StoreServiceDeletePageRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'storePageId')
    ..aOM<$2.CommandContext>(3, _omitFieldNames ? '' : 'commandContext',
        subBuilder: $2.CommandContext.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StoreServiceDeletePageRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StoreServiceDeletePageRequest copyWith(
          void Function(StoreServiceDeletePageRequest) updates) =>
      super.copyWith(
              (message) => updates(message as StoreServiceDeletePageRequest))
          as StoreServiceDeletePageRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use StoreServiceDeletePageRequest() / StoreServiceDeletePageRequest.new instead')
  static StoreServiceDeletePageRequest create() =>
      StoreServiceDeletePageRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      StoreServiceDeletePageRequest._();
  @$core.override
  StoreServiceDeletePageRequest createEmptyInstance() =>
      StoreServiceDeletePageRequest._();
  @$core.pragma('dart2js:noInline')
  static StoreServiceDeletePageRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<StoreServiceDeletePageRequest>(
          StoreServiceDeletePageRequest.$_createMessage);
  static StoreServiceDeletePageRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get storePageId => $_getSZ(1);
  @$pb.TagNumber(2)
  set storePageId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasStorePageId() => $_has(1);
  @$pb.TagNumber(2)
  void clearStorePageId() => $_clearField(2);

  @$pb.TagNumber(3)
  $2.CommandContext get commandContext => $_getN(2);
  @$pb.TagNumber(3)
  set commandContext($2.CommandContext value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasCommandContext() => $_has(2);
  @$pb.TagNumber(3)
  void clearCommandContext() => $_clearField(3);
  @$pb.TagNumber(3)
  $2.CommandContext ensureCommandContext() => $_ensure(2);
}

class StoreServiceDeletePageResponse extends $pb.GeneratedMessage {
  factory StoreServiceDeletePageResponse({
    $core.bool? success,
  }) {
    final result = StoreServiceDeletePageResponse._();
    if (success != null) result.success = success;
    return result;
  }

  StoreServiceDeletePageResponse._();

  factory StoreServiceDeletePageResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      StoreServiceDeletePageResponse()..mergeFromBuffer(data, registry);
  factory StoreServiceDeletePageResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      StoreServiceDeletePageResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'StoreServiceDeletePageResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: StoreServiceDeletePageResponse.$_createMessage)
    ..aOB(1, _omitFieldNames ? '' : 'success')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StoreServiceDeletePageResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StoreServiceDeletePageResponse copyWith(
          void Function(StoreServiceDeletePageResponse) updates) =>
      super.copyWith(
              (message) => updates(message as StoreServiceDeletePageResponse))
          as StoreServiceDeletePageResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use StoreServiceDeletePageResponse() / StoreServiceDeletePageResponse.new instead')
  static StoreServiceDeletePageResponse create() =>
      StoreServiceDeletePageResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      StoreServiceDeletePageResponse._();
  @$core.override
  StoreServiceDeletePageResponse createEmptyInstance() =>
      StoreServiceDeletePageResponse._();
  @$core.pragma('dart2js:noInline')
  static StoreServiceDeletePageResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<StoreServiceDeletePageResponse>(
          StoreServiceDeletePageResponse.$_createMessage);
  static StoreServiceDeletePageResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get success => $_getBF(0);
  @$pb.TagNumber(1)
  set success($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSuccess() => $_has(0);
  @$pb.TagNumber(1)
  void clearSuccess() => $_clearField(1);
}

class StoreServiceDuplicatePageRequest extends $pb.GeneratedMessage {
  factory StoreServiceDuplicatePageRequest({
    $core.String? workspaceId,
    $core.String? storePageId,
    $core.String? newTitle,
    $core.String? newSlug,
    $2.CommandContext? commandContext,
  }) {
    final result = StoreServiceDuplicatePageRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (storePageId != null) result.storePageId = storePageId;
    if (newTitle != null) result.newTitle = newTitle;
    if (newSlug != null) result.newSlug = newSlug;
    if (commandContext != null) result.commandContext = commandContext;
    return result;
  }

  StoreServiceDuplicatePageRequest._();

  factory StoreServiceDuplicatePageRequest.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      StoreServiceDuplicatePageRequest()..mergeFromBuffer(data, registry);
  factory StoreServiceDuplicatePageRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      StoreServiceDuplicatePageRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'StoreServiceDuplicatePageRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: StoreServiceDuplicatePageRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'storePageId')
    ..aOS(3, _omitFieldNames ? '' : 'newTitle')
    ..aOS(4, _omitFieldNames ? '' : 'newSlug')
    ..aOM<$2.CommandContext>(5, _omitFieldNames ? '' : 'commandContext',
        subBuilder: $2.CommandContext.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StoreServiceDuplicatePageRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StoreServiceDuplicatePageRequest copyWith(
          void Function(StoreServiceDuplicatePageRequest) updates) =>
      super.copyWith(
              (message) => updates(message as StoreServiceDuplicatePageRequest))
          as StoreServiceDuplicatePageRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use StoreServiceDuplicatePageRequest() / StoreServiceDuplicatePageRequest.new instead')
  static StoreServiceDuplicatePageRequest create() =>
      StoreServiceDuplicatePageRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      StoreServiceDuplicatePageRequest._();
  @$core.override
  StoreServiceDuplicatePageRequest createEmptyInstance() =>
      StoreServiceDuplicatePageRequest._();
  @$core.pragma('dart2js:noInline')
  static StoreServiceDuplicatePageRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<StoreServiceDuplicatePageRequest>(
          StoreServiceDuplicatePageRequest.$_createMessage);
  static StoreServiceDuplicatePageRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get storePageId => $_getSZ(1);
  @$pb.TagNumber(2)
  set storePageId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasStorePageId() => $_has(1);
  @$pb.TagNumber(2)
  void clearStorePageId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get newTitle => $_getSZ(2);
  @$pb.TagNumber(3)
  set newTitle($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasNewTitle() => $_has(2);
  @$pb.TagNumber(3)
  void clearNewTitle() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get newSlug => $_getSZ(3);
  @$pb.TagNumber(4)
  set newSlug($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasNewSlug() => $_has(3);
  @$pb.TagNumber(4)
  void clearNewSlug() => $_clearField(4);

  @$pb.TagNumber(5)
  $2.CommandContext get commandContext => $_getN(4);
  @$pb.TagNumber(5)
  set commandContext($2.CommandContext value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasCommandContext() => $_has(4);
  @$pb.TagNumber(5)
  void clearCommandContext() => $_clearField(5);
  @$pb.TagNumber(5)
  $2.CommandContext ensureCommandContext() => $_ensure(4);
}

class StoreServiceDuplicatePageResponse extends $pb.GeneratedMessage {
  factory StoreServiceDuplicatePageResponse({
    StorePage? page,
  }) {
    final result = StoreServiceDuplicatePageResponse._();
    if (page != null) result.page = page;
    return result;
  }

  StoreServiceDuplicatePageResponse._();

  factory StoreServiceDuplicatePageResponse.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      StoreServiceDuplicatePageResponse()..mergeFromBuffer(data, registry);
  factory StoreServiceDuplicatePageResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      StoreServiceDuplicatePageResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'StoreServiceDuplicatePageResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: StoreServiceDuplicatePageResponse.$_createMessage)
    ..aOM<StorePage>(1, _omitFieldNames ? '' : 'page',
        subBuilder: StorePage.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StoreServiceDuplicatePageResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StoreServiceDuplicatePageResponse copyWith(
          void Function(StoreServiceDuplicatePageResponse) updates) =>
      super.copyWith((message) =>
              updates(message as StoreServiceDuplicatePageResponse))
          as StoreServiceDuplicatePageResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use StoreServiceDuplicatePageResponse() / StoreServiceDuplicatePageResponse.new instead')
  static StoreServiceDuplicatePageResponse create() =>
      StoreServiceDuplicatePageResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      StoreServiceDuplicatePageResponse._();
  @$core.override
  StoreServiceDuplicatePageResponse createEmptyInstance() =>
      StoreServiceDuplicatePageResponse._();
  @$core.pragma('dart2js:noInline')
  static StoreServiceDuplicatePageResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<StoreServiceDuplicatePageResponse>(
          StoreServiceDuplicatePageResponse.$_createMessage);
  static StoreServiceDuplicatePageResponse? _defaultInstance;

  @$pb.TagNumber(1)
  StorePage get page => $_getN(0);
  @$pb.TagNumber(1)
  set page(StorePage value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasPage() => $_has(0);
  @$pb.TagNumber(1)
  void clearPage() => $_clearField(1);
  @$pb.TagNumber(1)
  StorePage ensurePage() => $_ensure(0);
}

class StoreServiceGetThemesRequest extends $pb.GeneratedMessage {
  factory StoreServiceGetThemesRequest({
    $core.String? workspaceId,
  }) {
    final result = StoreServiceGetThemesRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    return result;
  }

  StoreServiceGetThemesRequest._();

  factory StoreServiceGetThemesRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      StoreServiceGetThemesRequest()..mergeFromBuffer(data, registry);
  factory StoreServiceGetThemesRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      StoreServiceGetThemesRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'StoreServiceGetThemesRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: StoreServiceGetThemesRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StoreServiceGetThemesRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StoreServiceGetThemesRequest copyWith(
          void Function(StoreServiceGetThemesRequest) updates) =>
      super.copyWith(
              (message) => updates(message as StoreServiceGetThemesRequest))
          as StoreServiceGetThemesRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use StoreServiceGetThemesRequest() / StoreServiceGetThemesRequest.new instead')
  static StoreServiceGetThemesRequest create() =>
      StoreServiceGetThemesRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      StoreServiceGetThemesRequest._();
  @$core.override
  StoreServiceGetThemesRequest createEmptyInstance() =>
      StoreServiceGetThemesRequest._();
  @$core.pragma('dart2js:noInline')
  static StoreServiceGetThemesRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<StoreServiceGetThemesRequest>(
          StoreServiceGetThemesRequest.$_createMessage);
  static StoreServiceGetThemesRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);
}

class StoreServiceGetThemesResponse extends $pb.GeneratedMessage {
  factory StoreServiceGetThemesResponse({
    $core.Iterable<StoreTheme>? themes,
  }) {
    final result = StoreServiceGetThemesResponse._();
    if (themes != null) result.themes.addAll(themes);
    return result;
  }

  StoreServiceGetThemesResponse._();

  factory StoreServiceGetThemesResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      StoreServiceGetThemesResponse()..mergeFromBuffer(data, registry);
  factory StoreServiceGetThemesResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      StoreServiceGetThemesResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'StoreServiceGetThemesResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: StoreServiceGetThemesResponse.$_createMessage)
    ..pPM<StoreTheme>(1, _omitFieldNames ? '' : 'themes',
        subBuilder: StoreTheme.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StoreServiceGetThemesResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StoreServiceGetThemesResponse copyWith(
          void Function(StoreServiceGetThemesResponse) updates) =>
      super.copyWith(
              (message) => updates(message as StoreServiceGetThemesResponse))
          as StoreServiceGetThemesResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use StoreServiceGetThemesResponse() / StoreServiceGetThemesResponse.new instead')
  static StoreServiceGetThemesResponse create() =>
      StoreServiceGetThemesResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      StoreServiceGetThemesResponse._();
  @$core.override
  StoreServiceGetThemesResponse createEmptyInstance() =>
      StoreServiceGetThemesResponse._();
  @$core.pragma('dart2js:noInline')
  static StoreServiceGetThemesResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<StoreServiceGetThemesResponse>(
          StoreServiceGetThemesResponse.$_createMessage);
  static StoreServiceGetThemesResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<StoreTheme> get themes => $_getList(0);
}

class StoreServiceGetPageStatsRequest extends $pb.GeneratedMessage {
  factory StoreServiceGetPageStatsRequest({
    $core.String? workspaceId,
    $core.String? storePageId,
  }) {
    final result = StoreServiceGetPageStatsRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (storePageId != null) result.storePageId = storePageId;
    return result;
  }

  StoreServiceGetPageStatsRequest._();

  factory StoreServiceGetPageStatsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      StoreServiceGetPageStatsRequest()..mergeFromBuffer(data, registry);
  factory StoreServiceGetPageStatsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      StoreServiceGetPageStatsRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'StoreServiceGetPageStatsRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: StoreServiceGetPageStatsRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'storePageId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StoreServiceGetPageStatsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StoreServiceGetPageStatsRequest copyWith(
          void Function(StoreServiceGetPageStatsRequest) updates) =>
      super.copyWith(
              (message) => updates(message as StoreServiceGetPageStatsRequest))
          as StoreServiceGetPageStatsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use StoreServiceGetPageStatsRequest() / StoreServiceGetPageStatsRequest.new instead')
  static StoreServiceGetPageStatsRequest create() =>
      StoreServiceGetPageStatsRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      StoreServiceGetPageStatsRequest._();
  @$core.override
  StoreServiceGetPageStatsRequest createEmptyInstance() =>
      StoreServiceGetPageStatsRequest._();
  @$core.pragma('dart2js:noInline')
  static StoreServiceGetPageStatsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<StoreServiceGetPageStatsRequest>(
          StoreServiceGetPageStatsRequest.$_createMessage);
  static StoreServiceGetPageStatsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get storePageId => $_getSZ(1);
  @$pb.TagNumber(2)
  set storePageId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasStorePageId() => $_has(1);
  @$pb.TagNumber(2)
  void clearStorePageId() => $_clearField(2);
}

class StoreServiceGetPageStatsResponse extends $pb.GeneratedMessage {
  factory StoreServiceGetPageStatsResponse({
    PageStats? stats,
  }) {
    final result = StoreServiceGetPageStatsResponse._();
    if (stats != null) result.stats = stats;
    return result;
  }

  StoreServiceGetPageStatsResponse._();

  factory StoreServiceGetPageStatsResponse.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      StoreServiceGetPageStatsResponse()..mergeFromBuffer(data, registry);
  factory StoreServiceGetPageStatsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      StoreServiceGetPageStatsResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'StoreServiceGetPageStatsResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: StoreServiceGetPageStatsResponse.$_createMessage)
    ..aOM<PageStats>(1, _omitFieldNames ? '' : 'stats',
        subBuilder: PageStats.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StoreServiceGetPageStatsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StoreServiceGetPageStatsResponse copyWith(
          void Function(StoreServiceGetPageStatsResponse) updates) =>
      super.copyWith(
              (message) => updates(message as StoreServiceGetPageStatsResponse))
          as StoreServiceGetPageStatsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use StoreServiceGetPageStatsResponse() / StoreServiceGetPageStatsResponse.new instead')
  static StoreServiceGetPageStatsResponse create() =>
      StoreServiceGetPageStatsResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      StoreServiceGetPageStatsResponse._();
  @$core.override
  StoreServiceGetPageStatsResponse createEmptyInstance() =>
      StoreServiceGetPageStatsResponse._();
  @$core.pragma('dart2js:noInline')
  static StoreServiceGetPageStatsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<StoreServiceGetPageStatsResponse>(
          StoreServiceGetPageStatsResponse.$_createMessage);
  static StoreServiceGetPageStatsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  PageStats get stats => $_getN(0);
  @$pb.TagNumber(1)
  set stats(PageStats value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasStats() => $_has(0);
  @$pb.TagNumber(1)
  void clearStats() => $_clearField(1);
  @$pb.TagNumber(1)
  PageStats ensureStats() => $_ensure(0);
}

class StoreServiceCheckoutRequest extends $pb.GeneratedMessage {
  factory StoreServiceCheckoutRequest({
    $core.String? workspaceId,
    $core.String? customerEntityId,
    $core.String? idempotencyKey,
    $core.String? paymentIntentId,
    $core.String? offerId,
    $core.String? bundleId,
    $core.String? membershipPlanId,
    $core.Iterable<$core.String>? productIds,
    $core.String? orderAmount,
    $core.String? currency,
    $2.CommandContext? commandContext,
  }) {
    final result = StoreServiceCheckoutRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (customerEntityId != null) result.customerEntityId = customerEntityId;
    if (idempotencyKey != null) result.idempotencyKey = idempotencyKey;
    if (paymentIntentId != null) result.paymentIntentId = paymentIntentId;
    if (offerId != null) result.offerId = offerId;
    if (bundleId != null) result.bundleId = bundleId;
    if (membershipPlanId != null) result.membershipPlanId = membershipPlanId;
    if (productIds != null) result.productIds.addAll(productIds);
    if (orderAmount != null) result.orderAmount = orderAmount;
    if (currency != null) result.currency = currency;
    if (commandContext != null) result.commandContext = commandContext;
    return result;
  }

  StoreServiceCheckoutRequest._();

  factory StoreServiceCheckoutRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      StoreServiceCheckoutRequest()..mergeFromBuffer(data, registry);
  factory StoreServiceCheckoutRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      StoreServiceCheckoutRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'StoreServiceCheckoutRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: StoreServiceCheckoutRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'customerEntityId')
    ..aOS(3, _omitFieldNames ? '' : 'idempotencyKey')
    ..aOS(4, _omitFieldNames ? '' : 'paymentIntentId')
    ..aOS(5, _omitFieldNames ? '' : 'offerId')
    ..aOS(6, _omitFieldNames ? '' : 'bundleId')
    ..aOS(7, _omitFieldNames ? '' : 'membershipPlanId')
    ..pPS(8, _omitFieldNames ? '' : 'productIds')
    ..aOS(9, _omitFieldNames ? '' : 'orderAmount')
    ..aOS(10, _omitFieldNames ? '' : 'currency')
    ..aOM<$2.CommandContext>(11, _omitFieldNames ? '' : 'commandContext',
        subBuilder: $2.CommandContext.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StoreServiceCheckoutRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StoreServiceCheckoutRequest copyWith(
          void Function(StoreServiceCheckoutRequest) updates) =>
      super.copyWith(
              (message) => updates(message as StoreServiceCheckoutRequest))
          as StoreServiceCheckoutRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use StoreServiceCheckoutRequest() / StoreServiceCheckoutRequest.new instead')
  static StoreServiceCheckoutRequest create() =>
      StoreServiceCheckoutRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      StoreServiceCheckoutRequest._();
  @$core.override
  StoreServiceCheckoutRequest createEmptyInstance() =>
      StoreServiceCheckoutRequest._();
  @$core.pragma('dart2js:noInline')
  static StoreServiceCheckoutRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<StoreServiceCheckoutRequest>(
          StoreServiceCheckoutRequest.$_createMessage);
  static StoreServiceCheckoutRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get customerEntityId => $_getSZ(1);
  @$pb.TagNumber(2)
  set customerEntityId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCustomerEntityId() => $_has(1);
  @$pb.TagNumber(2)
  void clearCustomerEntityId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get idempotencyKey => $_getSZ(2);
  @$pb.TagNumber(3)
  set idempotencyKey($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasIdempotencyKey() => $_has(2);
  @$pb.TagNumber(3)
  void clearIdempotencyKey() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get paymentIntentId => $_getSZ(3);
  @$pb.TagNumber(4)
  set paymentIntentId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasPaymentIntentId() => $_has(3);
  @$pb.TagNumber(4)
  void clearPaymentIntentId() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get offerId => $_getSZ(4);
  @$pb.TagNumber(5)
  set offerId($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasOfferId() => $_has(4);
  @$pb.TagNumber(5)
  void clearOfferId() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get bundleId => $_getSZ(5);
  @$pb.TagNumber(6)
  set bundleId($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasBundleId() => $_has(5);
  @$pb.TagNumber(6)
  void clearBundleId() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get membershipPlanId => $_getSZ(6);
  @$pb.TagNumber(7)
  set membershipPlanId($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasMembershipPlanId() => $_has(6);
  @$pb.TagNumber(7)
  void clearMembershipPlanId() => $_clearField(7);

  @$pb.TagNumber(8)
  $pb.PbList<$core.String> get productIds => $_getList(7);

  @$pb.TagNumber(9)
  $core.String get orderAmount => $_getSZ(8);
  @$pb.TagNumber(9)
  set orderAmount($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasOrderAmount() => $_has(8);
  @$pb.TagNumber(9)
  void clearOrderAmount() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.String get currency => $_getSZ(9);
  @$pb.TagNumber(10)
  set currency($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasCurrency() => $_has(9);
  @$pb.TagNumber(10)
  void clearCurrency() => $_clearField(10);

  @$pb.TagNumber(11)
  $2.CommandContext get commandContext => $_getN(10);
  @$pb.TagNumber(11)
  set commandContext($2.CommandContext value) => $_setField(11, value);
  @$pb.TagNumber(11)
  $core.bool hasCommandContext() => $_has(10);
  @$pb.TagNumber(11)
  void clearCommandContext() => $_clearField(11);
  @$pb.TagNumber(11)
  $2.CommandContext ensureCommandContext() => $_ensure(10);
}

class StoreServiceCheckoutResponse extends $pb.GeneratedMessage {
  factory StoreServiceCheckoutResponse({
    $core.bool? success,
    $core.String? orderId,
    $core.String? status,
    $core.Iterable<DigitalDelivery>? deliveries,
    MembershipSubscription? subscription,
    $core.bool? isReplayed,
  }) {
    final result = StoreServiceCheckoutResponse._();
    if (success != null) result.success = success;
    if (orderId != null) result.orderId = orderId;
    if (status != null) result.status = status;
    if (deliveries != null) result.deliveries.addAll(deliveries);
    if (subscription != null) result.subscription = subscription;
    if (isReplayed != null) result.isReplayed = isReplayed;
    return result;
  }

  StoreServiceCheckoutResponse._();

  factory StoreServiceCheckoutResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      StoreServiceCheckoutResponse()..mergeFromBuffer(data, registry);
  factory StoreServiceCheckoutResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      StoreServiceCheckoutResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'StoreServiceCheckoutResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: StoreServiceCheckoutResponse.$_createMessage)
    ..aOB(1, _omitFieldNames ? '' : 'success')
    ..aOS(2, _omitFieldNames ? '' : 'orderId')
    ..aOS(3, _omitFieldNames ? '' : 'status')
    ..pPM<DigitalDelivery>(4, _omitFieldNames ? '' : 'deliveries',
        subBuilder: DigitalDelivery.$_createMessage)
    ..aOM<MembershipSubscription>(5, _omitFieldNames ? '' : 'subscription',
        subBuilder: MembershipSubscription.$_createMessage)
    ..aOB(6, _omitFieldNames ? '' : 'isReplayed')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StoreServiceCheckoutResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StoreServiceCheckoutResponse copyWith(
          void Function(StoreServiceCheckoutResponse) updates) =>
      super.copyWith(
              (message) => updates(message as StoreServiceCheckoutResponse))
          as StoreServiceCheckoutResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use StoreServiceCheckoutResponse() / StoreServiceCheckoutResponse.new instead')
  static StoreServiceCheckoutResponse create() =>
      StoreServiceCheckoutResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      StoreServiceCheckoutResponse._();
  @$core.override
  StoreServiceCheckoutResponse createEmptyInstance() =>
      StoreServiceCheckoutResponse._();
  @$core.pragma('dart2js:noInline')
  static StoreServiceCheckoutResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<StoreServiceCheckoutResponse>(
          StoreServiceCheckoutResponse.$_createMessage);
  static StoreServiceCheckoutResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get success => $_getBF(0);
  @$pb.TagNumber(1)
  set success($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSuccess() => $_has(0);
  @$pb.TagNumber(1)
  void clearSuccess() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get orderId => $_getSZ(1);
  @$pb.TagNumber(2)
  set orderId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasOrderId() => $_has(1);
  @$pb.TagNumber(2)
  void clearOrderId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get status => $_getSZ(2);
  @$pb.TagNumber(3)
  set status($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasStatus() => $_has(2);
  @$pb.TagNumber(3)
  void clearStatus() => $_clearField(3);

  @$pb.TagNumber(4)
  $pb.PbList<DigitalDelivery> get deliveries => $_getList(3);

  @$pb.TagNumber(5)
  MembershipSubscription get subscription => $_getN(4);
  @$pb.TagNumber(5)
  set subscription(MembershipSubscription value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasSubscription() => $_has(4);
  @$pb.TagNumber(5)
  void clearSubscription() => $_clearField(5);
  @$pb.TagNumber(5)
  MembershipSubscription ensureSubscription() => $_ensure(4);

  @$pb.TagNumber(6)
  $core.bool get isReplayed => $_getBF(5);
  @$pb.TagNumber(6)
  set isReplayed($core.bool value) => $_setBool(5, value);
  @$pb.TagNumber(6)
  $core.bool hasIsReplayed() => $_has(5);
  @$pb.TagNumber(6)
  void clearIsReplayed() => $_clearField(6);
}

class StoreServiceGetBuyerEntitlementsRequest extends $pb.GeneratedMessage {
  factory StoreServiceGetBuyerEntitlementsRequest({
    $core.String? workspaceId,
    $core.String? customerEntityId,
  }) {
    final result = StoreServiceGetBuyerEntitlementsRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (customerEntityId != null) result.customerEntityId = customerEntityId;
    return result;
  }

  StoreServiceGetBuyerEntitlementsRequest._();

  factory StoreServiceGetBuyerEntitlementsRequest.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      StoreServiceGetBuyerEntitlementsRequest()
        ..mergeFromBuffer(data, registry);
  factory StoreServiceGetBuyerEntitlementsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      StoreServiceGetBuyerEntitlementsRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'StoreServiceGetBuyerEntitlementsRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance:
          StoreServiceGetBuyerEntitlementsRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'customerEntityId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StoreServiceGetBuyerEntitlementsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StoreServiceGetBuyerEntitlementsRequest copyWith(
          void Function(StoreServiceGetBuyerEntitlementsRequest) updates) =>
      super.copyWith((message) =>
              updates(message as StoreServiceGetBuyerEntitlementsRequest))
          as StoreServiceGetBuyerEntitlementsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use StoreServiceGetBuyerEntitlementsRequest() / StoreServiceGetBuyerEntitlementsRequest.new instead')
  static StoreServiceGetBuyerEntitlementsRequest create() =>
      StoreServiceGetBuyerEntitlementsRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      StoreServiceGetBuyerEntitlementsRequest._();
  @$core.override
  StoreServiceGetBuyerEntitlementsRequest createEmptyInstance() =>
      StoreServiceGetBuyerEntitlementsRequest._();
  @$core.pragma('dart2js:noInline')
  static StoreServiceGetBuyerEntitlementsRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
              StoreServiceGetBuyerEntitlementsRequest>(
          StoreServiceGetBuyerEntitlementsRequest.$_createMessage);
  static StoreServiceGetBuyerEntitlementsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get customerEntityId => $_getSZ(1);
  @$pb.TagNumber(2)
  set customerEntityId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCustomerEntityId() => $_has(1);
  @$pb.TagNumber(2)
  void clearCustomerEntityId() => $_clearField(2);
}

class StoreServiceGetBuyerEntitlementsResponse extends $pb.GeneratedMessage {
  factory StoreServiceGetBuyerEntitlementsResponse({
    BuyerEntitlements? entitlements,
  }) {
    final result = StoreServiceGetBuyerEntitlementsResponse._();
    if (entitlements != null) result.entitlements = entitlements;
    return result;
  }

  StoreServiceGetBuyerEntitlementsResponse._();

  factory StoreServiceGetBuyerEntitlementsResponse.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      StoreServiceGetBuyerEntitlementsResponse()
        ..mergeFromBuffer(data, registry);
  factory StoreServiceGetBuyerEntitlementsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      StoreServiceGetBuyerEntitlementsResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'StoreServiceGetBuyerEntitlementsResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance:
          StoreServiceGetBuyerEntitlementsResponse.$_createMessage)
    ..aOM<BuyerEntitlements>(1, _omitFieldNames ? '' : 'entitlements',
        subBuilder: BuyerEntitlements.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StoreServiceGetBuyerEntitlementsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StoreServiceGetBuyerEntitlementsResponse copyWith(
          void Function(StoreServiceGetBuyerEntitlementsResponse) updates) =>
      super.copyWith((message) =>
              updates(message as StoreServiceGetBuyerEntitlementsResponse))
          as StoreServiceGetBuyerEntitlementsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use StoreServiceGetBuyerEntitlementsResponse() / StoreServiceGetBuyerEntitlementsResponse.new instead')
  static StoreServiceGetBuyerEntitlementsResponse create() =>
      StoreServiceGetBuyerEntitlementsResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      StoreServiceGetBuyerEntitlementsResponse._();
  @$core.override
  StoreServiceGetBuyerEntitlementsResponse createEmptyInstance() =>
      StoreServiceGetBuyerEntitlementsResponse._();
  @$core.pragma('dart2js:noInline')
  static StoreServiceGetBuyerEntitlementsResponse getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
              StoreServiceGetBuyerEntitlementsResponse>(
          StoreServiceGetBuyerEntitlementsResponse.$_createMessage);
  static StoreServiceGetBuyerEntitlementsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  BuyerEntitlements get entitlements => $_getN(0);
  @$pb.TagNumber(1)
  set entitlements(BuyerEntitlements value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasEntitlements() => $_has(0);
  @$pb.TagNumber(1)
  void clearEntitlements() => $_clearField(1);
  @$pb.TagNumber(1)
  BuyerEntitlements ensureEntitlements() => $_ensure(0);
}

class MembershipServiceCreatePlanRequest extends $pb.GeneratedMessage {
  factory MembershipServiceCreatePlanRequest({
    $core.String? workspaceId,
    $core.String? title,
    $core.String? description,
    $core.String? price,
    $core.String? currency,
    $core.String? billingInterval,
    $core.String? benefitsJson,
    $core.String? entitlementConfigJson,
    $2.CommandContext? commandContext,
  }) {
    final result = MembershipServiceCreatePlanRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (title != null) result.title = title;
    if (description != null) result.description = description;
    if (price != null) result.price = price;
    if (currency != null) result.currency = currency;
    if (billingInterval != null) result.billingInterval = billingInterval;
    if (benefitsJson != null) result.benefitsJson = benefitsJson;
    if (entitlementConfigJson != null)
      result.entitlementConfigJson = entitlementConfigJson;
    if (commandContext != null) result.commandContext = commandContext;
    return result;
  }

  MembershipServiceCreatePlanRequest._();

  factory MembershipServiceCreatePlanRequest.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      MembershipServiceCreatePlanRequest()..mergeFromBuffer(data, registry);
  factory MembershipServiceCreatePlanRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      MembershipServiceCreatePlanRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MembershipServiceCreatePlanRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: MembershipServiceCreatePlanRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'title')
    ..aOS(3, _omitFieldNames ? '' : 'description')
    ..aOS(4, _omitFieldNames ? '' : 'price')
    ..aOS(5, _omitFieldNames ? '' : 'currency')
    ..aOS(6, _omitFieldNames ? '' : 'billingInterval')
    ..aOS(7, _omitFieldNames ? '' : 'benefitsJson')
    ..aOS(8, _omitFieldNames ? '' : 'entitlementConfigJson')
    ..aOM<$2.CommandContext>(9, _omitFieldNames ? '' : 'commandContext',
        subBuilder: $2.CommandContext.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MembershipServiceCreatePlanRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MembershipServiceCreatePlanRequest copyWith(
          void Function(MembershipServiceCreatePlanRequest) updates) =>
      super.copyWith((message) =>
              updates(message as MembershipServiceCreatePlanRequest))
          as MembershipServiceCreatePlanRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use MembershipServiceCreatePlanRequest() / MembershipServiceCreatePlanRequest.new instead')
  static MembershipServiceCreatePlanRequest create() =>
      MembershipServiceCreatePlanRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      MembershipServiceCreatePlanRequest._();
  @$core.override
  MembershipServiceCreatePlanRequest createEmptyInstance() =>
      MembershipServiceCreatePlanRequest._();
  @$core.pragma('dart2js:noInline')
  static MembershipServiceCreatePlanRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<MembershipServiceCreatePlanRequest>(
          MembershipServiceCreatePlanRequest.$_createMessage);
  static MembershipServiceCreatePlanRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

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
  $core.String get price => $_getSZ(3);
  @$pb.TagNumber(4)
  set price($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasPrice() => $_has(3);
  @$pb.TagNumber(4)
  void clearPrice() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get currency => $_getSZ(4);
  @$pb.TagNumber(5)
  set currency($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasCurrency() => $_has(4);
  @$pb.TagNumber(5)
  void clearCurrency() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get billingInterval => $_getSZ(5);
  @$pb.TagNumber(6)
  set billingInterval($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasBillingInterval() => $_has(5);
  @$pb.TagNumber(6)
  void clearBillingInterval() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get benefitsJson => $_getSZ(6);
  @$pb.TagNumber(7)
  set benefitsJson($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasBenefitsJson() => $_has(6);
  @$pb.TagNumber(7)
  void clearBenefitsJson() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get entitlementConfigJson => $_getSZ(7);
  @$pb.TagNumber(8)
  set entitlementConfigJson($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasEntitlementConfigJson() => $_has(7);
  @$pb.TagNumber(8)
  void clearEntitlementConfigJson() => $_clearField(8);

  @$pb.TagNumber(9)
  $2.CommandContext get commandContext => $_getN(8);
  @$pb.TagNumber(9)
  set commandContext($2.CommandContext value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasCommandContext() => $_has(8);
  @$pb.TagNumber(9)
  void clearCommandContext() => $_clearField(9);
  @$pb.TagNumber(9)
  $2.CommandContext ensureCommandContext() => $_ensure(8);
}

class MembershipServiceCreatePlanResponse extends $pb.GeneratedMessage {
  factory MembershipServiceCreatePlanResponse({
    MembershipPlan? plan,
  }) {
    final result = MembershipServiceCreatePlanResponse._();
    if (plan != null) result.plan = plan;
    return result;
  }

  MembershipServiceCreatePlanResponse._();

  factory MembershipServiceCreatePlanResponse.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      MembershipServiceCreatePlanResponse()..mergeFromBuffer(data, registry);
  factory MembershipServiceCreatePlanResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      MembershipServiceCreatePlanResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MembershipServiceCreatePlanResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: MembershipServiceCreatePlanResponse.$_createMessage)
    ..aOM<MembershipPlan>(1, _omitFieldNames ? '' : 'plan',
        subBuilder: MembershipPlan.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MembershipServiceCreatePlanResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MembershipServiceCreatePlanResponse copyWith(
          void Function(MembershipServiceCreatePlanResponse) updates) =>
      super.copyWith((message) =>
              updates(message as MembershipServiceCreatePlanResponse))
          as MembershipServiceCreatePlanResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use MembershipServiceCreatePlanResponse() / MembershipServiceCreatePlanResponse.new instead')
  static MembershipServiceCreatePlanResponse create() =>
      MembershipServiceCreatePlanResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      MembershipServiceCreatePlanResponse._();
  @$core.override
  MembershipServiceCreatePlanResponse createEmptyInstance() =>
      MembershipServiceCreatePlanResponse._();
  @$core.pragma('dart2js:noInline')
  static MembershipServiceCreatePlanResponse getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
              MembershipServiceCreatePlanResponse>(
          MembershipServiceCreatePlanResponse.$_createMessage);
  static MembershipServiceCreatePlanResponse? _defaultInstance;

  @$pb.TagNumber(1)
  MembershipPlan get plan => $_getN(0);
  @$pb.TagNumber(1)
  set plan(MembershipPlan value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasPlan() => $_has(0);
  @$pb.TagNumber(1)
  void clearPlan() => $_clearField(1);
  @$pb.TagNumber(1)
  MembershipPlan ensurePlan() => $_ensure(0);
}

class MembershipServiceGetPlanRequest extends $pb.GeneratedMessage {
  factory MembershipServiceGetPlanRequest({
    $core.String? workspaceId,
    $core.String? planId,
  }) {
    final result = MembershipServiceGetPlanRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (planId != null) result.planId = planId;
    return result;
  }

  MembershipServiceGetPlanRequest._();

  factory MembershipServiceGetPlanRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      MembershipServiceGetPlanRequest()..mergeFromBuffer(data, registry);
  factory MembershipServiceGetPlanRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      MembershipServiceGetPlanRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MembershipServiceGetPlanRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: MembershipServiceGetPlanRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'planId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MembershipServiceGetPlanRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MembershipServiceGetPlanRequest copyWith(
          void Function(MembershipServiceGetPlanRequest) updates) =>
      super.copyWith(
              (message) => updates(message as MembershipServiceGetPlanRequest))
          as MembershipServiceGetPlanRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use MembershipServiceGetPlanRequest() / MembershipServiceGetPlanRequest.new instead')
  static MembershipServiceGetPlanRequest create() =>
      MembershipServiceGetPlanRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      MembershipServiceGetPlanRequest._();
  @$core.override
  MembershipServiceGetPlanRequest createEmptyInstance() =>
      MembershipServiceGetPlanRequest._();
  @$core.pragma('dart2js:noInline')
  static MembershipServiceGetPlanRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<MembershipServiceGetPlanRequest>(
          MembershipServiceGetPlanRequest.$_createMessage);
  static MembershipServiceGetPlanRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get planId => $_getSZ(1);
  @$pb.TagNumber(2)
  set planId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPlanId() => $_has(1);
  @$pb.TagNumber(2)
  void clearPlanId() => $_clearField(2);
}

class MembershipServiceGetPlanResponse extends $pb.GeneratedMessage {
  factory MembershipServiceGetPlanResponse({
    MembershipPlan? plan,
  }) {
    final result = MembershipServiceGetPlanResponse._();
    if (plan != null) result.plan = plan;
    return result;
  }

  MembershipServiceGetPlanResponse._();

  factory MembershipServiceGetPlanResponse.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      MembershipServiceGetPlanResponse()..mergeFromBuffer(data, registry);
  factory MembershipServiceGetPlanResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      MembershipServiceGetPlanResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MembershipServiceGetPlanResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: MembershipServiceGetPlanResponse.$_createMessage)
    ..aOM<MembershipPlan>(1, _omitFieldNames ? '' : 'plan',
        subBuilder: MembershipPlan.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MembershipServiceGetPlanResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MembershipServiceGetPlanResponse copyWith(
          void Function(MembershipServiceGetPlanResponse) updates) =>
      super.copyWith(
              (message) => updates(message as MembershipServiceGetPlanResponse))
          as MembershipServiceGetPlanResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use MembershipServiceGetPlanResponse() / MembershipServiceGetPlanResponse.new instead')
  static MembershipServiceGetPlanResponse create() =>
      MembershipServiceGetPlanResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      MembershipServiceGetPlanResponse._();
  @$core.override
  MembershipServiceGetPlanResponse createEmptyInstance() =>
      MembershipServiceGetPlanResponse._();
  @$core.pragma('dart2js:noInline')
  static MembershipServiceGetPlanResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<MembershipServiceGetPlanResponse>(
          MembershipServiceGetPlanResponse.$_createMessage);
  static MembershipServiceGetPlanResponse? _defaultInstance;

  @$pb.TagNumber(1)
  MembershipPlan get plan => $_getN(0);
  @$pb.TagNumber(1)
  set plan(MembershipPlan value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasPlan() => $_has(0);
  @$pb.TagNumber(1)
  void clearPlan() => $_clearField(1);
  @$pb.TagNumber(1)
  MembershipPlan ensurePlan() => $_ensure(0);
}

class MembershipServiceListPlansRequest extends $pb.GeneratedMessage {
  factory MembershipServiceListPlansRequest({
    $core.String? workspaceId,
    $core.int? pageSize,
    $core.String? pageToken,
    MembershipPlanStatus? statusFilter,
  }) {
    final result = MembershipServiceListPlansRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (pageSize != null) result.pageSize = pageSize;
    if (pageToken != null) result.pageToken = pageToken;
    if (statusFilter != null) result.statusFilter = statusFilter;
    return result;
  }

  MembershipServiceListPlansRequest._();

  factory MembershipServiceListPlansRequest.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      MembershipServiceListPlansRequest()..mergeFromBuffer(data, registry);
  factory MembershipServiceListPlansRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      MembershipServiceListPlansRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MembershipServiceListPlansRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: MembershipServiceListPlansRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aI(2, _omitFieldNames ? '' : 'pageSize')
    ..aOS(3, _omitFieldNames ? '' : 'pageToken')
    ..aE<MembershipPlanStatus>(4, _omitFieldNames ? '' : 'statusFilter',
        enumValues: MembershipPlanStatus.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MembershipServiceListPlansRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MembershipServiceListPlansRequest copyWith(
          void Function(MembershipServiceListPlansRequest) updates) =>
      super.copyWith((message) =>
              updates(message as MembershipServiceListPlansRequest))
          as MembershipServiceListPlansRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use MembershipServiceListPlansRequest() / MembershipServiceListPlansRequest.new instead')
  static MembershipServiceListPlansRequest create() =>
      MembershipServiceListPlansRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      MembershipServiceListPlansRequest._();
  @$core.override
  MembershipServiceListPlansRequest createEmptyInstance() =>
      MembershipServiceListPlansRequest._();
  @$core.pragma('dart2js:noInline')
  static MembershipServiceListPlansRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<MembershipServiceListPlansRequest>(
          MembershipServiceListPlansRequest.$_createMessage);
  static MembershipServiceListPlansRequest? _defaultInstance;

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
  MembershipPlanStatus get statusFilter => $_getN(3);
  @$pb.TagNumber(4)
  set statusFilter(MembershipPlanStatus value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasStatusFilter() => $_has(3);
  @$pb.TagNumber(4)
  void clearStatusFilter() => $_clearField(4);
}

class MembershipServiceListPlansResponse extends $pb.GeneratedMessage {
  factory MembershipServiceListPlansResponse({
    $core.Iterable<MembershipPlan>? plans,
    $core.String? nextPageToken,
    $fixnum.Int64? totalCount,
  }) {
    final result = MembershipServiceListPlansResponse._();
    if (plans != null) result.plans.addAll(plans);
    if (nextPageToken != null) result.nextPageToken = nextPageToken;
    if (totalCount != null) result.totalCount = totalCount;
    return result;
  }

  MembershipServiceListPlansResponse._();

  factory MembershipServiceListPlansResponse.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      MembershipServiceListPlansResponse()..mergeFromBuffer(data, registry);
  factory MembershipServiceListPlansResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      MembershipServiceListPlansResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MembershipServiceListPlansResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: MembershipServiceListPlansResponse.$_createMessage)
    ..pPM<MembershipPlan>(1, _omitFieldNames ? '' : 'plans',
        subBuilder: MembershipPlan.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'nextPageToken')
    ..aInt64(3, _omitFieldNames ? '' : 'totalCount')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MembershipServiceListPlansResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MembershipServiceListPlansResponse copyWith(
          void Function(MembershipServiceListPlansResponse) updates) =>
      super.copyWith((message) =>
              updates(message as MembershipServiceListPlansResponse))
          as MembershipServiceListPlansResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use MembershipServiceListPlansResponse() / MembershipServiceListPlansResponse.new instead')
  static MembershipServiceListPlansResponse create() =>
      MembershipServiceListPlansResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      MembershipServiceListPlansResponse._();
  @$core.override
  MembershipServiceListPlansResponse createEmptyInstance() =>
      MembershipServiceListPlansResponse._();
  @$core.pragma('dart2js:noInline')
  static MembershipServiceListPlansResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<MembershipServiceListPlansResponse>(
          MembershipServiceListPlansResponse.$_createMessage);
  static MembershipServiceListPlansResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<MembershipPlan> get plans => $_getList(0);

  @$pb.TagNumber(2)
  $core.String get nextPageToken => $_getSZ(1);
  @$pb.TagNumber(2)
  set nextPageToken($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasNextPageToken() => $_has(1);
  @$pb.TagNumber(2)
  void clearNextPageToken() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get totalCount => $_getI64(2);
  @$pb.TagNumber(3)
  set totalCount($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasTotalCount() => $_has(2);
  @$pb.TagNumber(3)
  void clearTotalCount() => $_clearField(3);
}

class MembershipServiceUpdatePlanRequest extends $pb.GeneratedMessage {
  factory MembershipServiceUpdatePlanRequest({
    $core.String? workspaceId,
    $core.String? planId,
    $core.String? title,
    $core.String? description,
    $core.String? price,
    $core.String? currency,
    $core.String? billingInterval,
    $core.String? benefitsJson,
    $core.String? entitlementConfigJson,
    $2.CommandContext? commandContext,
  }) {
    final result = MembershipServiceUpdatePlanRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (planId != null) result.planId = planId;
    if (title != null) result.title = title;
    if (description != null) result.description = description;
    if (price != null) result.price = price;
    if (currency != null) result.currency = currency;
    if (billingInterval != null) result.billingInterval = billingInterval;
    if (benefitsJson != null) result.benefitsJson = benefitsJson;
    if (entitlementConfigJson != null)
      result.entitlementConfigJson = entitlementConfigJson;
    if (commandContext != null) result.commandContext = commandContext;
    return result;
  }

  MembershipServiceUpdatePlanRequest._();

  factory MembershipServiceUpdatePlanRequest.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      MembershipServiceUpdatePlanRequest()..mergeFromBuffer(data, registry);
  factory MembershipServiceUpdatePlanRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      MembershipServiceUpdatePlanRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MembershipServiceUpdatePlanRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: MembershipServiceUpdatePlanRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'planId')
    ..aOS(3, _omitFieldNames ? '' : 'title')
    ..aOS(4, _omitFieldNames ? '' : 'description')
    ..aOS(5, _omitFieldNames ? '' : 'price')
    ..aOS(6, _omitFieldNames ? '' : 'currency')
    ..aOS(7, _omitFieldNames ? '' : 'billingInterval')
    ..aOS(8, _omitFieldNames ? '' : 'benefitsJson')
    ..aOS(9, _omitFieldNames ? '' : 'entitlementConfigJson')
    ..aOM<$2.CommandContext>(10, _omitFieldNames ? '' : 'commandContext',
        subBuilder: $2.CommandContext.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MembershipServiceUpdatePlanRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MembershipServiceUpdatePlanRequest copyWith(
          void Function(MembershipServiceUpdatePlanRequest) updates) =>
      super.copyWith((message) =>
              updates(message as MembershipServiceUpdatePlanRequest))
          as MembershipServiceUpdatePlanRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use MembershipServiceUpdatePlanRequest() / MembershipServiceUpdatePlanRequest.new instead')
  static MembershipServiceUpdatePlanRequest create() =>
      MembershipServiceUpdatePlanRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      MembershipServiceUpdatePlanRequest._();
  @$core.override
  MembershipServiceUpdatePlanRequest createEmptyInstance() =>
      MembershipServiceUpdatePlanRequest._();
  @$core.pragma('dart2js:noInline')
  static MembershipServiceUpdatePlanRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<MembershipServiceUpdatePlanRequest>(
          MembershipServiceUpdatePlanRequest.$_createMessage);
  static MembershipServiceUpdatePlanRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get planId => $_getSZ(1);
  @$pb.TagNumber(2)
  set planId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPlanId() => $_has(1);
  @$pb.TagNumber(2)
  void clearPlanId() => $_clearField(2);

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
  $core.String get price => $_getSZ(4);
  @$pb.TagNumber(5)
  set price($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasPrice() => $_has(4);
  @$pb.TagNumber(5)
  void clearPrice() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get currency => $_getSZ(5);
  @$pb.TagNumber(6)
  set currency($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasCurrency() => $_has(5);
  @$pb.TagNumber(6)
  void clearCurrency() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get billingInterval => $_getSZ(6);
  @$pb.TagNumber(7)
  set billingInterval($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasBillingInterval() => $_has(6);
  @$pb.TagNumber(7)
  void clearBillingInterval() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get benefitsJson => $_getSZ(7);
  @$pb.TagNumber(8)
  set benefitsJson($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasBenefitsJson() => $_has(7);
  @$pb.TagNumber(8)
  void clearBenefitsJson() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get entitlementConfigJson => $_getSZ(8);
  @$pb.TagNumber(9)
  set entitlementConfigJson($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasEntitlementConfigJson() => $_has(8);
  @$pb.TagNumber(9)
  void clearEntitlementConfigJson() => $_clearField(9);

  @$pb.TagNumber(10)
  $2.CommandContext get commandContext => $_getN(9);
  @$pb.TagNumber(10)
  set commandContext($2.CommandContext value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasCommandContext() => $_has(9);
  @$pb.TagNumber(10)
  void clearCommandContext() => $_clearField(10);
  @$pb.TagNumber(10)
  $2.CommandContext ensureCommandContext() => $_ensure(9);
}

class MembershipServiceUpdatePlanResponse extends $pb.GeneratedMessage {
  factory MembershipServiceUpdatePlanResponse({
    MembershipPlan? plan,
  }) {
    final result = MembershipServiceUpdatePlanResponse._();
    if (plan != null) result.plan = plan;
    return result;
  }

  MembershipServiceUpdatePlanResponse._();

  factory MembershipServiceUpdatePlanResponse.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      MembershipServiceUpdatePlanResponse()..mergeFromBuffer(data, registry);
  factory MembershipServiceUpdatePlanResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      MembershipServiceUpdatePlanResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MembershipServiceUpdatePlanResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: MembershipServiceUpdatePlanResponse.$_createMessage)
    ..aOM<MembershipPlan>(1, _omitFieldNames ? '' : 'plan',
        subBuilder: MembershipPlan.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MembershipServiceUpdatePlanResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MembershipServiceUpdatePlanResponse copyWith(
          void Function(MembershipServiceUpdatePlanResponse) updates) =>
      super.copyWith((message) =>
              updates(message as MembershipServiceUpdatePlanResponse))
          as MembershipServiceUpdatePlanResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use MembershipServiceUpdatePlanResponse() / MembershipServiceUpdatePlanResponse.new instead')
  static MembershipServiceUpdatePlanResponse create() =>
      MembershipServiceUpdatePlanResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      MembershipServiceUpdatePlanResponse._();
  @$core.override
  MembershipServiceUpdatePlanResponse createEmptyInstance() =>
      MembershipServiceUpdatePlanResponse._();
  @$core.pragma('dart2js:noInline')
  static MembershipServiceUpdatePlanResponse getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
              MembershipServiceUpdatePlanResponse>(
          MembershipServiceUpdatePlanResponse.$_createMessage);
  static MembershipServiceUpdatePlanResponse? _defaultInstance;

  @$pb.TagNumber(1)
  MembershipPlan get plan => $_getN(0);
  @$pb.TagNumber(1)
  set plan(MembershipPlan value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasPlan() => $_has(0);
  @$pb.TagNumber(1)
  void clearPlan() => $_clearField(1);
  @$pb.TagNumber(1)
  MembershipPlan ensurePlan() => $_ensure(0);
}

class MembershipServiceDuplicatePlanRequest extends $pb.GeneratedMessage {
  factory MembershipServiceDuplicatePlanRequest({
    $core.String? workspaceId,
    $core.String? planId,
    $core.String? newTitle,
    $2.CommandContext? commandContext,
  }) {
    final result = MembershipServiceDuplicatePlanRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (planId != null) result.planId = planId;
    if (newTitle != null) result.newTitle = newTitle;
    if (commandContext != null) result.commandContext = commandContext;
    return result;
  }

  MembershipServiceDuplicatePlanRequest._();

  factory MembershipServiceDuplicatePlanRequest.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      MembershipServiceDuplicatePlanRequest()..mergeFromBuffer(data, registry);
  factory MembershipServiceDuplicatePlanRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      MembershipServiceDuplicatePlanRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MembershipServiceDuplicatePlanRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance:
          MembershipServiceDuplicatePlanRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'planId')
    ..aOS(3, _omitFieldNames ? '' : 'newTitle')
    ..aOM<$2.CommandContext>(4, _omitFieldNames ? '' : 'commandContext',
        subBuilder: $2.CommandContext.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MembershipServiceDuplicatePlanRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MembershipServiceDuplicatePlanRequest copyWith(
          void Function(MembershipServiceDuplicatePlanRequest) updates) =>
      super.copyWith((message) =>
              updates(message as MembershipServiceDuplicatePlanRequest))
          as MembershipServiceDuplicatePlanRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use MembershipServiceDuplicatePlanRequest() / MembershipServiceDuplicatePlanRequest.new instead')
  static MembershipServiceDuplicatePlanRequest create() =>
      MembershipServiceDuplicatePlanRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      MembershipServiceDuplicatePlanRequest._();
  @$core.override
  MembershipServiceDuplicatePlanRequest createEmptyInstance() =>
      MembershipServiceDuplicatePlanRequest._();
  @$core.pragma('dart2js:noInline')
  static MembershipServiceDuplicatePlanRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
              MembershipServiceDuplicatePlanRequest>(
          MembershipServiceDuplicatePlanRequest.$_createMessage);
  static MembershipServiceDuplicatePlanRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get planId => $_getSZ(1);
  @$pb.TagNumber(2)
  set planId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPlanId() => $_has(1);
  @$pb.TagNumber(2)
  void clearPlanId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get newTitle => $_getSZ(2);
  @$pb.TagNumber(3)
  set newTitle($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasNewTitle() => $_has(2);
  @$pb.TagNumber(3)
  void clearNewTitle() => $_clearField(3);

  @$pb.TagNumber(4)
  $2.CommandContext get commandContext => $_getN(3);
  @$pb.TagNumber(4)
  set commandContext($2.CommandContext value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasCommandContext() => $_has(3);
  @$pb.TagNumber(4)
  void clearCommandContext() => $_clearField(4);
  @$pb.TagNumber(4)
  $2.CommandContext ensureCommandContext() => $_ensure(3);
}

class MembershipServiceDuplicatePlanResponse extends $pb.GeneratedMessage {
  factory MembershipServiceDuplicatePlanResponse({
    MembershipPlan? plan,
  }) {
    final result = MembershipServiceDuplicatePlanResponse._();
    if (plan != null) result.plan = plan;
    return result;
  }

  MembershipServiceDuplicatePlanResponse._();

  factory MembershipServiceDuplicatePlanResponse.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      MembershipServiceDuplicatePlanResponse()..mergeFromBuffer(data, registry);
  factory MembershipServiceDuplicatePlanResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      MembershipServiceDuplicatePlanResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MembershipServiceDuplicatePlanResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance:
          MembershipServiceDuplicatePlanResponse.$_createMessage)
    ..aOM<MembershipPlan>(1, _omitFieldNames ? '' : 'plan',
        subBuilder: MembershipPlan.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MembershipServiceDuplicatePlanResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MembershipServiceDuplicatePlanResponse copyWith(
          void Function(MembershipServiceDuplicatePlanResponse) updates) =>
      super.copyWith((message) =>
              updates(message as MembershipServiceDuplicatePlanResponse))
          as MembershipServiceDuplicatePlanResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use MembershipServiceDuplicatePlanResponse() / MembershipServiceDuplicatePlanResponse.new instead')
  static MembershipServiceDuplicatePlanResponse create() =>
      MembershipServiceDuplicatePlanResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      MembershipServiceDuplicatePlanResponse._();
  @$core.override
  MembershipServiceDuplicatePlanResponse createEmptyInstance() =>
      MembershipServiceDuplicatePlanResponse._();
  @$core.pragma('dart2js:noInline')
  static MembershipServiceDuplicatePlanResponse getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
              MembershipServiceDuplicatePlanResponse>(
          MembershipServiceDuplicatePlanResponse.$_createMessage);
  static MembershipServiceDuplicatePlanResponse? _defaultInstance;

  @$pb.TagNumber(1)
  MembershipPlan get plan => $_getN(0);
  @$pb.TagNumber(1)
  set plan(MembershipPlan value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasPlan() => $_has(0);
  @$pb.TagNumber(1)
  void clearPlan() => $_clearField(1);
  @$pb.TagNumber(1)
  MembershipPlan ensurePlan() => $_ensure(0);
}

class MembershipServiceDeleteRequest extends $pb.GeneratedMessage {
  factory MembershipServiceDeleteRequest({
    $core.String? workspaceId,
    $core.String? planId,
    $2.CommandContext? commandContext,
  }) {
    final result = MembershipServiceDeleteRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (planId != null) result.planId = planId;
    if (commandContext != null) result.commandContext = commandContext;
    return result;
  }

  MembershipServiceDeleteRequest._();

  factory MembershipServiceDeleteRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      MembershipServiceDeleteRequest()..mergeFromBuffer(data, registry);
  factory MembershipServiceDeleteRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      MembershipServiceDeleteRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MembershipServiceDeleteRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: MembershipServiceDeleteRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'planId')
    ..aOM<$2.CommandContext>(3, _omitFieldNames ? '' : 'commandContext',
        subBuilder: $2.CommandContext.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MembershipServiceDeleteRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MembershipServiceDeleteRequest copyWith(
          void Function(MembershipServiceDeleteRequest) updates) =>
      super.copyWith(
              (message) => updates(message as MembershipServiceDeleteRequest))
          as MembershipServiceDeleteRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use MembershipServiceDeleteRequest() / MembershipServiceDeleteRequest.new instead')
  static MembershipServiceDeleteRequest create() =>
      MembershipServiceDeleteRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      MembershipServiceDeleteRequest._();
  @$core.override
  MembershipServiceDeleteRequest createEmptyInstance() =>
      MembershipServiceDeleteRequest._();
  @$core.pragma('dart2js:noInline')
  static MembershipServiceDeleteRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<MembershipServiceDeleteRequest>(
          MembershipServiceDeleteRequest.$_createMessage);
  static MembershipServiceDeleteRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get planId => $_getSZ(1);
  @$pb.TagNumber(2)
  set planId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPlanId() => $_has(1);
  @$pb.TagNumber(2)
  void clearPlanId() => $_clearField(2);

  @$pb.TagNumber(3)
  $2.CommandContext get commandContext => $_getN(2);
  @$pb.TagNumber(3)
  set commandContext($2.CommandContext value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasCommandContext() => $_has(2);
  @$pb.TagNumber(3)
  void clearCommandContext() => $_clearField(3);
  @$pb.TagNumber(3)
  $2.CommandContext ensureCommandContext() => $_ensure(2);
}

class MembershipServiceDeleteResponse extends $pb.GeneratedMessage {
  factory MembershipServiceDeleteResponse({
    $core.bool? success,
  }) {
    final result = MembershipServiceDeleteResponse._();
    if (success != null) result.success = success;
    return result;
  }

  MembershipServiceDeleteResponse._();

  factory MembershipServiceDeleteResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      MembershipServiceDeleteResponse()..mergeFromBuffer(data, registry);
  factory MembershipServiceDeleteResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      MembershipServiceDeleteResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MembershipServiceDeleteResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: MembershipServiceDeleteResponse.$_createMessage)
    ..aOB(1, _omitFieldNames ? '' : 'success')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MembershipServiceDeleteResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MembershipServiceDeleteResponse copyWith(
          void Function(MembershipServiceDeleteResponse) updates) =>
      super.copyWith(
              (message) => updates(message as MembershipServiceDeleteResponse))
          as MembershipServiceDeleteResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use MembershipServiceDeleteResponse() / MembershipServiceDeleteResponse.new instead')
  static MembershipServiceDeleteResponse create() =>
      MembershipServiceDeleteResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      MembershipServiceDeleteResponse._();
  @$core.override
  MembershipServiceDeleteResponse createEmptyInstance() =>
      MembershipServiceDeleteResponse._();
  @$core.pragma('dart2js:noInline')
  static MembershipServiceDeleteResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<MembershipServiceDeleteResponse>(
          MembershipServiceDeleteResponse.$_createMessage);
  static MembershipServiceDeleteResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get success => $_getBF(0);
  @$pb.TagNumber(1)
  set success($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSuccess() => $_has(0);
  @$pb.TagNumber(1)
  void clearSuccess() => $_clearField(1);
}

class MembershipServiceArchiveRequest extends $pb.GeneratedMessage {
  factory MembershipServiceArchiveRequest({
    $core.String? workspaceId,
    $core.String? planId,
    $2.CommandContext? commandContext,
  }) {
    final result = MembershipServiceArchiveRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (planId != null) result.planId = planId;
    if (commandContext != null) result.commandContext = commandContext;
    return result;
  }

  MembershipServiceArchiveRequest._();

  factory MembershipServiceArchiveRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      MembershipServiceArchiveRequest()..mergeFromBuffer(data, registry);
  factory MembershipServiceArchiveRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      MembershipServiceArchiveRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MembershipServiceArchiveRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: MembershipServiceArchiveRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'planId')
    ..aOM<$2.CommandContext>(3, _omitFieldNames ? '' : 'commandContext',
        subBuilder: $2.CommandContext.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MembershipServiceArchiveRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MembershipServiceArchiveRequest copyWith(
          void Function(MembershipServiceArchiveRequest) updates) =>
      super.copyWith(
              (message) => updates(message as MembershipServiceArchiveRequest))
          as MembershipServiceArchiveRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use MembershipServiceArchiveRequest() / MembershipServiceArchiveRequest.new instead')
  static MembershipServiceArchiveRequest create() =>
      MembershipServiceArchiveRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      MembershipServiceArchiveRequest._();
  @$core.override
  MembershipServiceArchiveRequest createEmptyInstance() =>
      MembershipServiceArchiveRequest._();
  @$core.pragma('dart2js:noInline')
  static MembershipServiceArchiveRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<MembershipServiceArchiveRequest>(
          MembershipServiceArchiveRequest.$_createMessage);
  static MembershipServiceArchiveRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get planId => $_getSZ(1);
  @$pb.TagNumber(2)
  set planId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPlanId() => $_has(1);
  @$pb.TagNumber(2)
  void clearPlanId() => $_clearField(2);

  @$pb.TagNumber(3)
  $2.CommandContext get commandContext => $_getN(2);
  @$pb.TagNumber(3)
  set commandContext($2.CommandContext value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasCommandContext() => $_has(2);
  @$pb.TagNumber(3)
  void clearCommandContext() => $_clearField(3);
  @$pb.TagNumber(3)
  $2.CommandContext ensureCommandContext() => $_ensure(2);
}

class MembershipServiceArchiveResponse extends $pb.GeneratedMessage {
  factory MembershipServiceArchiveResponse({
    MembershipPlan? plan,
  }) {
    final result = MembershipServiceArchiveResponse._();
    if (plan != null) result.plan = plan;
    return result;
  }

  MembershipServiceArchiveResponse._();

  factory MembershipServiceArchiveResponse.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      MembershipServiceArchiveResponse()..mergeFromBuffer(data, registry);
  factory MembershipServiceArchiveResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      MembershipServiceArchiveResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MembershipServiceArchiveResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: MembershipServiceArchiveResponse.$_createMessage)
    ..aOM<MembershipPlan>(1, _omitFieldNames ? '' : 'plan',
        subBuilder: MembershipPlan.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MembershipServiceArchiveResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MembershipServiceArchiveResponse copyWith(
          void Function(MembershipServiceArchiveResponse) updates) =>
      super.copyWith(
              (message) => updates(message as MembershipServiceArchiveResponse))
          as MembershipServiceArchiveResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use MembershipServiceArchiveResponse() / MembershipServiceArchiveResponse.new instead')
  static MembershipServiceArchiveResponse create() =>
      MembershipServiceArchiveResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      MembershipServiceArchiveResponse._();
  @$core.override
  MembershipServiceArchiveResponse createEmptyInstance() =>
      MembershipServiceArchiveResponse._();
  @$core.pragma('dart2js:noInline')
  static MembershipServiceArchiveResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<MembershipServiceArchiveResponse>(
          MembershipServiceArchiveResponse.$_createMessage);
  static MembershipServiceArchiveResponse? _defaultInstance;

  @$pb.TagNumber(1)
  MembershipPlan get plan => $_getN(0);
  @$pb.TagNumber(1)
  set plan(MembershipPlan value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasPlan() => $_has(0);
  @$pb.TagNumber(1)
  void clearPlan() => $_clearField(1);
  @$pb.TagNumber(1)
  MembershipPlan ensurePlan() => $_ensure(0);
}

class MembershipServicePublishRequest extends $pb.GeneratedMessage {
  factory MembershipServicePublishRequest({
    $core.String? workspaceId,
    $core.String? planId,
    $2.CommandContext? commandContext,
  }) {
    final result = MembershipServicePublishRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (planId != null) result.planId = planId;
    if (commandContext != null) result.commandContext = commandContext;
    return result;
  }

  MembershipServicePublishRequest._();

  factory MembershipServicePublishRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      MembershipServicePublishRequest()..mergeFromBuffer(data, registry);
  factory MembershipServicePublishRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      MembershipServicePublishRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MembershipServicePublishRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: MembershipServicePublishRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'planId')
    ..aOM<$2.CommandContext>(3, _omitFieldNames ? '' : 'commandContext',
        subBuilder: $2.CommandContext.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MembershipServicePublishRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MembershipServicePublishRequest copyWith(
          void Function(MembershipServicePublishRequest) updates) =>
      super.copyWith(
              (message) => updates(message as MembershipServicePublishRequest))
          as MembershipServicePublishRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use MembershipServicePublishRequest() / MembershipServicePublishRequest.new instead')
  static MembershipServicePublishRequest create() =>
      MembershipServicePublishRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      MembershipServicePublishRequest._();
  @$core.override
  MembershipServicePublishRequest createEmptyInstance() =>
      MembershipServicePublishRequest._();
  @$core.pragma('dart2js:noInline')
  static MembershipServicePublishRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<MembershipServicePublishRequest>(
          MembershipServicePublishRequest.$_createMessage);
  static MembershipServicePublishRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get planId => $_getSZ(1);
  @$pb.TagNumber(2)
  set planId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPlanId() => $_has(1);
  @$pb.TagNumber(2)
  void clearPlanId() => $_clearField(2);

  @$pb.TagNumber(3)
  $2.CommandContext get commandContext => $_getN(2);
  @$pb.TagNumber(3)
  set commandContext($2.CommandContext value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasCommandContext() => $_has(2);
  @$pb.TagNumber(3)
  void clearCommandContext() => $_clearField(3);
  @$pb.TagNumber(3)
  $2.CommandContext ensureCommandContext() => $_ensure(2);
}

class MembershipServicePublishResponse extends $pb.GeneratedMessage {
  factory MembershipServicePublishResponse({
    MembershipPlan? plan,
  }) {
    final result = MembershipServicePublishResponse._();
    if (plan != null) result.plan = plan;
    return result;
  }

  MembershipServicePublishResponse._();

  factory MembershipServicePublishResponse.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      MembershipServicePublishResponse()..mergeFromBuffer(data, registry);
  factory MembershipServicePublishResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      MembershipServicePublishResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MembershipServicePublishResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: MembershipServicePublishResponse.$_createMessage)
    ..aOM<MembershipPlan>(1, _omitFieldNames ? '' : 'plan',
        subBuilder: MembershipPlan.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MembershipServicePublishResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MembershipServicePublishResponse copyWith(
          void Function(MembershipServicePublishResponse) updates) =>
      super.copyWith(
              (message) => updates(message as MembershipServicePublishResponse))
          as MembershipServicePublishResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use MembershipServicePublishResponse() / MembershipServicePublishResponse.new instead')
  static MembershipServicePublishResponse create() =>
      MembershipServicePublishResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      MembershipServicePublishResponse._();
  @$core.override
  MembershipServicePublishResponse createEmptyInstance() =>
      MembershipServicePublishResponse._();
  @$core.pragma('dart2js:noInline')
  static MembershipServicePublishResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<MembershipServicePublishResponse>(
          MembershipServicePublishResponse.$_createMessage);
  static MembershipServicePublishResponse? _defaultInstance;

  @$pb.TagNumber(1)
  MembershipPlan get plan => $_getN(0);
  @$pb.TagNumber(1)
  set plan(MembershipPlan value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasPlan() => $_has(0);
  @$pb.TagNumber(1)
  void clearPlan() => $_clearField(1);
  @$pb.TagNumber(1)
  MembershipPlan ensurePlan() => $_ensure(0);
}

class MembershipServicePauseRequest extends $pb.GeneratedMessage {
  factory MembershipServicePauseRequest({
    $core.String? workspaceId,
    $core.String? planId,
    $2.CommandContext? commandContext,
  }) {
    final result = MembershipServicePauseRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (planId != null) result.planId = planId;
    if (commandContext != null) result.commandContext = commandContext;
    return result;
  }

  MembershipServicePauseRequest._();

  factory MembershipServicePauseRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      MembershipServicePauseRequest()..mergeFromBuffer(data, registry);
  factory MembershipServicePauseRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      MembershipServicePauseRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MembershipServicePauseRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: MembershipServicePauseRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'planId')
    ..aOM<$2.CommandContext>(3, _omitFieldNames ? '' : 'commandContext',
        subBuilder: $2.CommandContext.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MembershipServicePauseRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MembershipServicePauseRequest copyWith(
          void Function(MembershipServicePauseRequest) updates) =>
      super.copyWith(
              (message) => updates(message as MembershipServicePauseRequest))
          as MembershipServicePauseRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use MembershipServicePauseRequest() / MembershipServicePauseRequest.new instead')
  static MembershipServicePauseRequest create() =>
      MembershipServicePauseRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      MembershipServicePauseRequest._();
  @$core.override
  MembershipServicePauseRequest createEmptyInstance() =>
      MembershipServicePauseRequest._();
  @$core.pragma('dart2js:noInline')
  static MembershipServicePauseRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<MembershipServicePauseRequest>(
          MembershipServicePauseRequest.$_createMessage);
  static MembershipServicePauseRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get planId => $_getSZ(1);
  @$pb.TagNumber(2)
  set planId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPlanId() => $_has(1);
  @$pb.TagNumber(2)
  void clearPlanId() => $_clearField(2);

  @$pb.TagNumber(3)
  $2.CommandContext get commandContext => $_getN(2);
  @$pb.TagNumber(3)
  set commandContext($2.CommandContext value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasCommandContext() => $_has(2);
  @$pb.TagNumber(3)
  void clearCommandContext() => $_clearField(3);
  @$pb.TagNumber(3)
  $2.CommandContext ensureCommandContext() => $_ensure(2);
}

class MembershipServicePauseResponse extends $pb.GeneratedMessage {
  factory MembershipServicePauseResponse({
    MembershipPlan? plan,
  }) {
    final result = MembershipServicePauseResponse._();
    if (plan != null) result.plan = plan;
    return result;
  }

  MembershipServicePauseResponse._();

  factory MembershipServicePauseResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      MembershipServicePauseResponse()..mergeFromBuffer(data, registry);
  factory MembershipServicePauseResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      MembershipServicePauseResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MembershipServicePauseResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: MembershipServicePauseResponse.$_createMessage)
    ..aOM<MembershipPlan>(1, _omitFieldNames ? '' : 'plan',
        subBuilder: MembershipPlan.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MembershipServicePauseResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MembershipServicePauseResponse copyWith(
          void Function(MembershipServicePauseResponse) updates) =>
      super.copyWith(
              (message) => updates(message as MembershipServicePauseResponse))
          as MembershipServicePauseResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use MembershipServicePauseResponse() / MembershipServicePauseResponse.new instead')
  static MembershipServicePauseResponse create() =>
      MembershipServicePauseResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      MembershipServicePauseResponse._();
  @$core.override
  MembershipServicePauseResponse createEmptyInstance() =>
      MembershipServicePauseResponse._();
  @$core.pragma('dart2js:noInline')
  static MembershipServicePauseResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<MembershipServicePauseResponse>(
          MembershipServicePauseResponse.$_createMessage);
  static MembershipServicePauseResponse? _defaultInstance;

  @$pb.TagNumber(1)
  MembershipPlan get plan => $_getN(0);
  @$pb.TagNumber(1)
  set plan(MembershipPlan value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasPlan() => $_has(0);
  @$pb.TagNumber(1)
  void clearPlan() => $_clearField(1);
  @$pb.TagNumber(1)
  MembershipPlan ensurePlan() => $_ensure(0);
}

class MembershipServiceResumeRequest extends $pb.GeneratedMessage {
  factory MembershipServiceResumeRequest({
    $core.String? workspaceId,
    $core.String? planId,
    $2.CommandContext? commandContext,
  }) {
    final result = MembershipServiceResumeRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (planId != null) result.planId = planId;
    if (commandContext != null) result.commandContext = commandContext;
    return result;
  }

  MembershipServiceResumeRequest._();

  factory MembershipServiceResumeRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      MembershipServiceResumeRequest()..mergeFromBuffer(data, registry);
  factory MembershipServiceResumeRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      MembershipServiceResumeRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MembershipServiceResumeRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: MembershipServiceResumeRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'planId')
    ..aOM<$2.CommandContext>(3, _omitFieldNames ? '' : 'commandContext',
        subBuilder: $2.CommandContext.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MembershipServiceResumeRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MembershipServiceResumeRequest copyWith(
          void Function(MembershipServiceResumeRequest) updates) =>
      super.copyWith(
              (message) => updates(message as MembershipServiceResumeRequest))
          as MembershipServiceResumeRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use MembershipServiceResumeRequest() / MembershipServiceResumeRequest.new instead')
  static MembershipServiceResumeRequest create() =>
      MembershipServiceResumeRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      MembershipServiceResumeRequest._();
  @$core.override
  MembershipServiceResumeRequest createEmptyInstance() =>
      MembershipServiceResumeRequest._();
  @$core.pragma('dart2js:noInline')
  static MembershipServiceResumeRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<MembershipServiceResumeRequest>(
          MembershipServiceResumeRequest.$_createMessage);
  static MembershipServiceResumeRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get planId => $_getSZ(1);
  @$pb.TagNumber(2)
  set planId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPlanId() => $_has(1);
  @$pb.TagNumber(2)
  void clearPlanId() => $_clearField(2);

  @$pb.TagNumber(3)
  $2.CommandContext get commandContext => $_getN(2);
  @$pb.TagNumber(3)
  set commandContext($2.CommandContext value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasCommandContext() => $_has(2);
  @$pb.TagNumber(3)
  void clearCommandContext() => $_clearField(3);
  @$pb.TagNumber(3)
  $2.CommandContext ensureCommandContext() => $_ensure(2);
}

class MembershipServiceResumeResponse extends $pb.GeneratedMessage {
  factory MembershipServiceResumeResponse({
    MembershipPlan? plan,
  }) {
    final result = MembershipServiceResumeResponse._();
    if (plan != null) result.plan = plan;
    return result;
  }

  MembershipServiceResumeResponse._();

  factory MembershipServiceResumeResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      MembershipServiceResumeResponse()..mergeFromBuffer(data, registry);
  factory MembershipServiceResumeResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      MembershipServiceResumeResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MembershipServiceResumeResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: MembershipServiceResumeResponse.$_createMessage)
    ..aOM<MembershipPlan>(1, _omitFieldNames ? '' : 'plan',
        subBuilder: MembershipPlan.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MembershipServiceResumeResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MembershipServiceResumeResponse copyWith(
          void Function(MembershipServiceResumeResponse) updates) =>
      super.copyWith(
              (message) => updates(message as MembershipServiceResumeResponse))
          as MembershipServiceResumeResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use MembershipServiceResumeResponse() / MembershipServiceResumeResponse.new instead')
  static MembershipServiceResumeResponse create() =>
      MembershipServiceResumeResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      MembershipServiceResumeResponse._();
  @$core.override
  MembershipServiceResumeResponse createEmptyInstance() =>
      MembershipServiceResumeResponse._();
  @$core.pragma('dart2js:noInline')
  static MembershipServiceResumeResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<MembershipServiceResumeResponse>(
          MembershipServiceResumeResponse.$_createMessage);
  static MembershipServiceResumeResponse? _defaultInstance;

  @$pb.TagNumber(1)
  MembershipPlan get plan => $_getN(0);
  @$pb.TagNumber(1)
  set plan(MembershipPlan value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasPlan() => $_has(0);
  @$pb.TagNumber(1)
  void clearPlan() => $_clearField(1);
  @$pb.TagNumber(1)
  MembershipPlan ensurePlan() => $_ensure(0);
}

class MembershipServiceGetMRRSummaryRequest extends $pb.GeneratedMessage {
  factory MembershipServiceGetMRRSummaryRequest({
    $core.String? workspaceId,
  }) {
    final result = MembershipServiceGetMRRSummaryRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    return result;
  }

  MembershipServiceGetMRRSummaryRequest._();

  factory MembershipServiceGetMRRSummaryRequest.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      MembershipServiceGetMRRSummaryRequest()..mergeFromBuffer(data, registry);
  factory MembershipServiceGetMRRSummaryRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      MembershipServiceGetMRRSummaryRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MembershipServiceGetMRRSummaryRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance:
          MembershipServiceGetMRRSummaryRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MembershipServiceGetMRRSummaryRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MembershipServiceGetMRRSummaryRequest copyWith(
          void Function(MembershipServiceGetMRRSummaryRequest) updates) =>
      super.copyWith((message) =>
              updates(message as MembershipServiceGetMRRSummaryRequest))
          as MembershipServiceGetMRRSummaryRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use MembershipServiceGetMRRSummaryRequest() / MembershipServiceGetMRRSummaryRequest.new instead')
  static MembershipServiceGetMRRSummaryRequest create() =>
      MembershipServiceGetMRRSummaryRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      MembershipServiceGetMRRSummaryRequest._();
  @$core.override
  MembershipServiceGetMRRSummaryRequest createEmptyInstance() =>
      MembershipServiceGetMRRSummaryRequest._();
  @$core.pragma('dart2js:noInline')
  static MembershipServiceGetMRRSummaryRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
              MembershipServiceGetMRRSummaryRequest>(
          MembershipServiceGetMRRSummaryRequest.$_createMessage);
  static MembershipServiceGetMRRSummaryRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);
}

class MembershipServiceGetMRRSummaryResponse extends $pb.GeneratedMessage {
  factory MembershipServiceGetMRRSummaryResponse({
    $core.String? currentMrr,
    $core.String? currency,
    $core.int? activeSubscribers,
    $core.double? churnRate,
    $core.String? averageLtv,
    $core.double? trialConversionRate,
  }) {
    final result = MembershipServiceGetMRRSummaryResponse._();
    if (currentMrr != null) result.currentMrr = currentMrr;
    if (currency != null) result.currency = currency;
    if (activeSubscribers != null) result.activeSubscribers = activeSubscribers;
    if (churnRate != null) result.churnRate = churnRate;
    if (averageLtv != null) result.averageLtv = averageLtv;
    if (trialConversionRate != null)
      result.trialConversionRate = trialConversionRate;
    return result;
  }

  MembershipServiceGetMRRSummaryResponse._();

  factory MembershipServiceGetMRRSummaryResponse.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      MembershipServiceGetMRRSummaryResponse()..mergeFromBuffer(data, registry);
  factory MembershipServiceGetMRRSummaryResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      MembershipServiceGetMRRSummaryResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MembershipServiceGetMRRSummaryResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance:
          MembershipServiceGetMRRSummaryResponse.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'currentMrr')
    ..aOS(2, _omitFieldNames ? '' : 'currency')
    ..aI(3, _omitFieldNames ? '' : 'activeSubscribers')
    ..aD(4, _omitFieldNames ? '' : 'churnRate')
    ..aOS(5, _omitFieldNames ? '' : 'averageLtv')
    ..aD(6, _omitFieldNames ? '' : 'trialConversionRate')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MembershipServiceGetMRRSummaryResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MembershipServiceGetMRRSummaryResponse copyWith(
          void Function(MembershipServiceGetMRRSummaryResponse) updates) =>
      super.copyWith((message) =>
              updates(message as MembershipServiceGetMRRSummaryResponse))
          as MembershipServiceGetMRRSummaryResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use MembershipServiceGetMRRSummaryResponse() / MembershipServiceGetMRRSummaryResponse.new instead')
  static MembershipServiceGetMRRSummaryResponse create() =>
      MembershipServiceGetMRRSummaryResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      MembershipServiceGetMRRSummaryResponse._();
  @$core.override
  MembershipServiceGetMRRSummaryResponse createEmptyInstance() =>
      MembershipServiceGetMRRSummaryResponse._();
  @$core.pragma('dart2js:noInline')
  static MembershipServiceGetMRRSummaryResponse getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
              MembershipServiceGetMRRSummaryResponse>(
          MembershipServiceGetMRRSummaryResponse.$_createMessage);
  static MembershipServiceGetMRRSummaryResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get currentMrr => $_getSZ(0);
  @$pb.TagNumber(1)
  set currentMrr($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCurrentMrr() => $_has(0);
  @$pb.TagNumber(1)
  void clearCurrentMrr() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get currency => $_getSZ(1);
  @$pb.TagNumber(2)
  set currency($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCurrency() => $_has(1);
  @$pb.TagNumber(2)
  void clearCurrency() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get activeSubscribers => $_getIZ(2);
  @$pb.TagNumber(3)
  set activeSubscribers($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasActiveSubscribers() => $_has(2);
  @$pb.TagNumber(3)
  void clearActiveSubscribers() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.double get churnRate => $_getN(3);
  @$pb.TagNumber(4)
  set churnRate($core.double value) => $_setDouble(3, value);
  @$pb.TagNumber(4)
  $core.bool hasChurnRate() => $_has(3);
  @$pb.TagNumber(4)
  void clearChurnRate() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get averageLtv => $_getSZ(4);
  @$pb.TagNumber(5)
  set averageLtv($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasAverageLtv() => $_has(4);
  @$pb.TagNumber(5)
  void clearAverageLtv() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.double get trialConversionRate => $_getN(5);
  @$pb.TagNumber(6)
  set trialConversionRate($core.double value) => $_setDouble(5, value);
  @$pb.TagNumber(6)
  $core.bool hasTrialConversionRate() => $_has(5);
  @$pb.TagNumber(6)
  void clearTrialConversionRate() => $_clearField(6);
}

class MembershipServiceGetMRRTrendRequest extends $pb.GeneratedMessage {
  factory MembershipServiceGetMRRTrendRequest({
    $core.String? workspaceId,
    $core.int? months,
  }) {
    final result = MembershipServiceGetMRRTrendRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (months != null) result.months = months;
    return result;
  }

  MembershipServiceGetMRRTrendRequest._();

  factory MembershipServiceGetMRRTrendRequest.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      MembershipServiceGetMRRTrendRequest()..mergeFromBuffer(data, registry);
  factory MembershipServiceGetMRRTrendRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      MembershipServiceGetMRRTrendRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MembershipServiceGetMRRTrendRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: MembershipServiceGetMRRTrendRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aI(2, _omitFieldNames ? '' : 'months')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MembershipServiceGetMRRTrendRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MembershipServiceGetMRRTrendRequest copyWith(
          void Function(MembershipServiceGetMRRTrendRequest) updates) =>
      super.copyWith((message) =>
              updates(message as MembershipServiceGetMRRTrendRequest))
          as MembershipServiceGetMRRTrendRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use MembershipServiceGetMRRTrendRequest() / MembershipServiceGetMRRTrendRequest.new instead')
  static MembershipServiceGetMRRTrendRequest create() =>
      MembershipServiceGetMRRTrendRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      MembershipServiceGetMRRTrendRequest._();
  @$core.override
  MembershipServiceGetMRRTrendRequest createEmptyInstance() =>
      MembershipServiceGetMRRTrendRequest._();
  @$core.pragma('dart2js:noInline')
  static MembershipServiceGetMRRTrendRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
              MembershipServiceGetMRRTrendRequest>(
          MembershipServiceGetMRRTrendRequest.$_createMessage);
  static MembershipServiceGetMRRTrendRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get months => $_getIZ(1);
  @$pb.TagNumber(2)
  set months($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasMonths() => $_has(1);
  @$pb.TagNumber(2)
  void clearMonths() => $_clearField(2);
}

class MRRMonthPoint extends $pb.GeneratedMessage {
  factory MRRMonthPoint({
    $core.String? monthLabel,
    $core.String? mrr,
    $core.int? subscribers,
  }) {
    final result = MRRMonthPoint._();
    if (monthLabel != null) result.monthLabel = monthLabel;
    if (mrr != null) result.mrr = mrr;
    if (subscribers != null) result.subscribers = subscribers;
    return result;
  }

  MRRMonthPoint._();

  factory MRRMonthPoint.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      MRRMonthPoint()..mergeFromBuffer(data, registry);
  factory MRRMonthPoint.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      MRRMonthPoint()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MRRMonthPoint',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: MRRMonthPoint.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'monthLabel')
    ..aOS(2, _omitFieldNames ? '' : 'mrr')
    ..aI(3, _omitFieldNames ? '' : 'subscribers')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MRRMonthPoint clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MRRMonthPoint copyWith(void Function(MRRMonthPoint) updates) =>
      super.copyWith((message) => updates(message as MRRMonthPoint))
          as MRRMonthPoint;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use MRRMonthPoint() / MRRMonthPoint.new instead')
  static MRRMonthPoint create() => MRRMonthPoint._();
  static $pb.GeneratedMessage $_createMessage() => MRRMonthPoint._();
  @$core.override
  MRRMonthPoint createEmptyInstance() => MRRMonthPoint._();
  @$core.pragma('dart2js:noInline')
  static MRRMonthPoint getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<MRRMonthPoint>(
          MRRMonthPoint.$_createMessage);
  static MRRMonthPoint? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get monthLabel => $_getSZ(0);
  @$pb.TagNumber(1)
  set monthLabel($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasMonthLabel() => $_has(0);
  @$pb.TagNumber(1)
  void clearMonthLabel() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get mrr => $_getSZ(1);
  @$pb.TagNumber(2)
  set mrr($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasMrr() => $_has(1);
  @$pb.TagNumber(2)
  void clearMrr() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get subscribers => $_getIZ(2);
  @$pb.TagNumber(3)
  set subscribers($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasSubscribers() => $_has(2);
  @$pb.TagNumber(3)
  void clearSubscribers() => $_clearField(3);
}

class MembershipServiceGetMRRTrendResponse extends $pb.GeneratedMessage {
  factory MembershipServiceGetMRRTrendResponse({
    $core.Iterable<MRRMonthPoint>? trendPoints,
  }) {
    final result = MembershipServiceGetMRRTrendResponse._();
    if (trendPoints != null) result.trendPoints.addAll(trendPoints);
    return result;
  }

  MembershipServiceGetMRRTrendResponse._();

  factory MembershipServiceGetMRRTrendResponse.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      MembershipServiceGetMRRTrendResponse()..mergeFromBuffer(data, registry);
  factory MembershipServiceGetMRRTrendResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      MembershipServiceGetMRRTrendResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MembershipServiceGetMRRTrendResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: MembershipServiceGetMRRTrendResponse.$_createMessage)
    ..pPM<MRRMonthPoint>(1, _omitFieldNames ? '' : 'trendPoints',
        subBuilder: MRRMonthPoint.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MembershipServiceGetMRRTrendResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MembershipServiceGetMRRTrendResponse copyWith(
          void Function(MembershipServiceGetMRRTrendResponse) updates) =>
      super.copyWith((message) =>
              updates(message as MembershipServiceGetMRRTrendResponse))
          as MembershipServiceGetMRRTrendResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use MembershipServiceGetMRRTrendResponse() / MembershipServiceGetMRRTrendResponse.new instead')
  static MembershipServiceGetMRRTrendResponse create() =>
      MembershipServiceGetMRRTrendResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      MembershipServiceGetMRRTrendResponse._();
  @$core.override
  MembershipServiceGetMRRTrendResponse createEmptyInstance() =>
      MembershipServiceGetMRRTrendResponse._();
  @$core.pragma('dart2js:noInline')
  static MembershipServiceGetMRRTrendResponse getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
              MembershipServiceGetMRRTrendResponse>(
          MembershipServiceGetMRRTrendResponse.$_createMessage);
  static MembershipServiceGetMRRTrendResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<MRRMonthPoint> get trendPoints => $_getList(0);
}

class BundleServiceCreateBundleRequest extends $pb.GeneratedMessage {
  factory BundleServiceCreateBundleRequest({
    $core.String? workspaceId,
    $core.String? title,
    $core.String? offerId,
    $core.String? bundlePrice,
    $core.double? discountPct,
    $core.Iterable<BundleItem>? items,
    $2.CommandContext? commandContext,
  }) {
    final result = BundleServiceCreateBundleRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (title != null) result.title = title;
    if (offerId != null) result.offerId = offerId;
    if (bundlePrice != null) result.bundlePrice = bundlePrice;
    if (discountPct != null) result.discountPct = discountPct;
    if (items != null) result.items.addAll(items);
    if (commandContext != null) result.commandContext = commandContext;
    return result;
  }

  BundleServiceCreateBundleRequest._();

  factory BundleServiceCreateBundleRequest.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      BundleServiceCreateBundleRequest()..mergeFromBuffer(data, registry);
  factory BundleServiceCreateBundleRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      BundleServiceCreateBundleRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'BundleServiceCreateBundleRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: BundleServiceCreateBundleRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'title')
    ..aOS(3, _omitFieldNames ? '' : 'offerId')
    ..aOS(4, _omitFieldNames ? '' : 'bundlePrice')
    ..aD(5, _omitFieldNames ? '' : 'discountPct')
    ..pPM<BundleItem>(6, _omitFieldNames ? '' : 'items',
        subBuilder: BundleItem.$_createMessage)
    ..aOM<$2.CommandContext>(7, _omitFieldNames ? '' : 'commandContext',
        subBuilder: $2.CommandContext.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BundleServiceCreateBundleRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BundleServiceCreateBundleRequest copyWith(
          void Function(BundleServiceCreateBundleRequest) updates) =>
      super.copyWith(
              (message) => updates(message as BundleServiceCreateBundleRequest))
          as BundleServiceCreateBundleRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use BundleServiceCreateBundleRequest() / BundleServiceCreateBundleRequest.new instead')
  static BundleServiceCreateBundleRequest create() =>
      BundleServiceCreateBundleRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      BundleServiceCreateBundleRequest._();
  @$core.override
  BundleServiceCreateBundleRequest createEmptyInstance() =>
      BundleServiceCreateBundleRequest._();
  @$core.pragma('dart2js:noInline')
  static BundleServiceCreateBundleRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<BundleServiceCreateBundleRequest>(
          BundleServiceCreateBundleRequest.$_createMessage);
  static BundleServiceCreateBundleRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get title => $_getSZ(1);
  @$pb.TagNumber(2)
  set title($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTitle() => $_has(1);
  @$pb.TagNumber(2)
  void clearTitle() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get offerId => $_getSZ(2);
  @$pb.TagNumber(3)
  set offerId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasOfferId() => $_has(2);
  @$pb.TagNumber(3)
  void clearOfferId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get bundlePrice => $_getSZ(3);
  @$pb.TagNumber(4)
  set bundlePrice($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasBundlePrice() => $_has(3);
  @$pb.TagNumber(4)
  void clearBundlePrice() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.double get discountPct => $_getN(4);
  @$pb.TagNumber(5)
  set discountPct($core.double value) => $_setDouble(4, value);
  @$pb.TagNumber(5)
  $core.bool hasDiscountPct() => $_has(4);
  @$pb.TagNumber(5)
  void clearDiscountPct() => $_clearField(5);

  @$pb.TagNumber(6)
  $pb.PbList<BundleItem> get items => $_getList(5);

  @$pb.TagNumber(7)
  $2.CommandContext get commandContext => $_getN(6);
  @$pb.TagNumber(7)
  set commandContext($2.CommandContext value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasCommandContext() => $_has(6);
  @$pb.TagNumber(7)
  void clearCommandContext() => $_clearField(7);
  @$pb.TagNumber(7)
  $2.CommandContext ensureCommandContext() => $_ensure(6);
}

class BundleServiceCreateBundleResponse extends $pb.GeneratedMessage {
  factory BundleServiceCreateBundleResponse({
    Bundle? bundle,
  }) {
    final result = BundleServiceCreateBundleResponse._();
    if (bundle != null) result.bundle = bundle;
    return result;
  }

  BundleServiceCreateBundleResponse._();

  factory BundleServiceCreateBundleResponse.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      BundleServiceCreateBundleResponse()..mergeFromBuffer(data, registry);
  factory BundleServiceCreateBundleResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      BundleServiceCreateBundleResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'BundleServiceCreateBundleResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: BundleServiceCreateBundleResponse.$_createMessage)
    ..aOM<Bundle>(1, _omitFieldNames ? '' : 'bundle',
        subBuilder: Bundle.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BundleServiceCreateBundleResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BundleServiceCreateBundleResponse copyWith(
          void Function(BundleServiceCreateBundleResponse) updates) =>
      super.copyWith((message) =>
              updates(message as BundleServiceCreateBundleResponse))
          as BundleServiceCreateBundleResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use BundleServiceCreateBundleResponse() / BundleServiceCreateBundleResponse.new instead')
  static BundleServiceCreateBundleResponse create() =>
      BundleServiceCreateBundleResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      BundleServiceCreateBundleResponse._();
  @$core.override
  BundleServiceCreateBundleResponse createEmptyInstance() =>
      BundleServiceCreateBundleResponse._();
  @$core.pragma('dart2js:noInline')
  static BundleServiceCreateBundleResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<BundleServiceCreateBundleResponse>(
          BundleServiceCreateBundleResponse.$_createMessage);
  static BundleServiceCreateBundleResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Bundle get bundle => $_getN(0);
  @$pb.TagNumber(1)
  set bundle(Bundle value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasBundle() => $_has(0);
  @$pb.TagNumber(1)
  void clearBundle() => $_clearField(1);
  @$pb.TagNumber(1)
  Bundle ensureBundle() => $_ensure(0);
}

class BundleServiceGetBundleRequest extends $pb.GeneratedMessage {
  factory BundleServiceGetBundleRequest({
    $core.String? workspaceId,
    $core.String? bundleId,
  }) {
    final result = BundleServiceGetBundleRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (bundleId != null) result.bundleId = bundleId;
    return result;
  }

  BundleServiceGetBundleRequest._();

  factory BundleServiceGetBundleRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      BundleServiceGetBundleRequest()..mergeFromBuffer(data, registry);
  factory BundleServiceGetBundleRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      BundleServiceGetBundleRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'BundleServiceGetBundleRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: BundleServiceGetBundleRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'bundleId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BundleServiceGetBundleRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BundleServiceGetBundleRequest copyWith(
          void Function(BundleServiceGetBundleRequest) updates) =>
      super.copyWith(
              (message) => updates(message as BundleServiceGetBundleRequest))
          as BundleServiceGetBundleRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use BundleServiceGetBundleRequest() / BundleServiceGetBundleRequest.new instead')
  static BundleServiceGetBundleRequest create() =>
      BundleServiceGetBundleRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      BundleServiceGetBundleRequest._();
  @$core.override
  BundleServiceGetBundleRequest createEmptyInstance() =>
      BundleServiceGetBundleRequest._();
  @$core.pragma('dart2js:noInline')
  static BundleServiceGetBundleRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<BundleServiceGetBundleRequest>(
          BundleServiceGetBundleRequest.$_createMessage);
  static BundleServiceGetBundleRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get bundleId => $_getSZ(1);
  @$pb.TagNumber(2)
  set bundleId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasBundleId() => $_has(1);
  @$pb.TagNumber(2)
  void clearBundleId() => $_clearField(2);
}

class BundleServiceGetBundleResponse extends $pb.GeneratedMessage {
  factory BundleServiceGetBundleResponse({
    Bundle? bundle,
  }) {
    final result = BundleServiceGetBundleResponse._();
    if (bundle != null) result.bundle = bundle;
    return result;
  }

  BundleServiceGetBundleResponse._();

  factory BundleServiceGetBundleResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      BundleServiceGetBundleResponse()..mergeFromBuffer(data, registry);
  factory BundleServiceGetBundleResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      BundleServiceGetBundleResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'BundleServiceGetBundleResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: BundleServiceGetBundleResponse.$_createMessage)
    ..aOM<Bundle>(1, _omitFieldNames ? '' : 'bundle',
        subBuilder: Bundle.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BundleServiceGetBundleResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BundleServiceGetBundleResponse copyWith(
          void Function(BundleServiceGetBundleResponse) updates) =>
      super.copyWith(
              (message) => updates(message as BundleServiceGetBundleResponse))
          as BundleServiceGetBundleResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use BundleServiceGetBundleResponse() / BundleServiceGetBundleResponse.new instead')
  static BundleServiceGetBundleResponse create() =>
      BundleServiceGetBundleResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      BundleServiceGetBundleResponse._();
  @$core.override
  BundleServiceGetBundleResponse createEmptyInstance() =>
      BundleServiceGetBundleResponse._();
  @$core.pragma('dart2js:noInline')
  static BundleServiceGetBundleResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<BundleServiceGetBundleResponse>(
          BundleServiceGetBundleResponse.$_createMessage);
  static BundleServiceGetBundleResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Bundle get bundle => $_getN(0);
  @$pb.TagNumber(1)
  set bundle(Bundle value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasBundle() => $_has(0);
  @$pb.TagNumber(1)
  void clearBundle() => $_clearField(1);
  @$pb.TagNumber(1)
  Bundle ensureBundle() => $_ensure(0);
}

class BundleServiceListBundlesRequest extends $pb.GeneratedMessage {
  factory BundleServiceListBundlesRequest({
    $core.String? workspaceId,
  }) {
    final result = BundleServiceListBundlesRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    return result;
  }

  BundleServiceListBundlesRequest._();

  factory BundleServiceListBundlesRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      BundleServiceListBundlesRequest()..mergeFromBuffer(data, registry);
  factory BundleServiceListBundlesRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      BundleServiceListBundlesRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'BundleServiceListBundlesRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: BundleServiceListBundlesRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BundleServiceListBundlesRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BundleServiceListBundlesRequest copyWith(
          void Function(BundleServiceListBundlesRequest) updates) =>
      super.copyWith(
              (message) => updates(message as BundleServiceListBundlesRequest))
          as BundleServiceListBundlesRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use BundleServiceListBundlesRequest() / BundleServiceListBundlesRequest.new instead')
  static BundleServiceListBundlesRequest create() =>
      BundleServiceListBundlesRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      BundleServiceListBundlesRequest._();
  @$core.override
  BundleServiceListBundlesRequest createEmptyInstance() =>
      BundleServiceListBundlesRequest._();
  @$core.pragma('dart2js:noInline')
  static BundleServiceListBundlesRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<BundleServiceListBundlesRequest>(
          BundleServiceListBundlesRequest.$_createMessage);
  static BundleServiceListBundlesRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);
}

class BundleServiceListBundlesResponse extends $pb.GeneratedMessage {
  factory BundleServiceListBundlesResponse({
    $core.Iterable<Bundle>? bundles,
  }) {
    final result = BundleServiceListBundlesResponse._();
    if (bundles != null) result.bundles.addAll(bundles);
    return result;
  }

  BundleServiceListBundlesResponse._();

  factory BundleServiceListBundlesResponse.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      BundleServiceListBundlesResponse()..mergeFromBuffer(data, registry);
  factory BundleServiceListBundlesResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      BundleServiceListBundlesResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'BundleServiceListBundlesResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: BundleServiceListBundlesResponse.$_createMessage)
    ..pPM<Bundle>(1, _omitFieldNames ? '' : 'bundles',
        subBuilder: Bundle.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BundleServiceListBundlesResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BundleServiceListBundlesResponse copyWith(
          void Function(BundleServiceListBundlesResponse) updates) =>
      super.copyWith(
              (message) => updates(message as BundleServiceListBundlesResponse))
          as BundleServiceListBundlesResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use BundleServiceListBundlesResponse() / BundleServiceListBundlesResponse.new instead')
  static BundleServiceListBundlesResponse create() =>
      BundleServiceListBundlesResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      BundleServiceListBundlesResponse._();
  @$core.override
  BundleServiceListBundlesResponse createEmptyInstance() =>
      BundleServiceListBundlesResponse._();
  @$core.pragma('dart2js:noInline')
  static BundleServiceListBundlesResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<BundleServiceListBundlesResponse>(
          BundleServiceListBundlesResponse.$_createMessage);
  static BundleServiceListBundlesResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Bundle> get bundles => $_getList(0);
}

class BundleServiceCheckBundleStockRequest extends $pb.GeneratedMessage {
  factory BundleServiceCheckBundleStockRequest({
    $core.String? workspaceId,
    $core.String? bundleId,
    $core.int? requestedQuantity,
  }) {
    final result = BundleServiceCheckBundleStockRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (bundleId != null) result.bundleId = bundleId;
    if (requestedQuantity != null) result.requestedQuantity = requestedQuantity;
    return result;
  }

  BundleServiceCheckBundleStockRequest._();

  factory BundleServiceCheckBundleStockRequest.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      BundleServiceCheckBundleStockRequest()..mergeFromBuffer(data, registry);
  factory BundleServiceCheckBundleStockRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      BundleServiceCheckBundleStockRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'BundleServiceCheckBundleStockRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: BundleServiceCheckBundleStockRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'bundleId')
    ..aI(3, _omitFieldNames ? '' : 'requestedQuantity')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BundleServiceCheckBundleStockRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BundleServiceCheckBundleStockRequest copyWith(
          void Function(BundleServiceCheckBundleStockRequest) updates) =>
      super.copyWith((message) =>
              updates(message as BundleServiceCheckBundleStockRequest))
          as BundleServiceCheckBundleStockRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use BundleServiceCheckBundleStockRequest() / BundleServiceCheckBundleStockRequest.new instead')
  static BundleServiceCheckBundleStockRequest create() =>
      BundleServiceCheckBundleStockRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      BundleServiceCheckBundleStockRequest._();
  @$core.override
  BundleServiceCheckBundleStockRequest createEmptyInstance() =>
      BundleServiceCheckBundleStockRequest._();
  @$core.pragma('dart2js:noInline')
  static BundleServiceCheckBundleStockRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
              BundleServiceCheckBundleStockRequest>(
          BundleServiceCheckBundleStockRequest.$_createMessage);
  static BundleServiceCheckBundleStockRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get bundleId => $_getSZ(1);
  @$pb.TagNumber(2)
  set bundleId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasBundleId() => $_has(1);
  @$pb.TagNumber(2)
  void clearBundleId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get requestedQuantity => $_getIZ(2);
  @$pb.TagNumber(3)
  set requestedQuantity($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasRequestedQuantity() => $_has(2);
  @$pb.TagNumber(3)
  void clearRequestedQuantity() => $_clearField(3);
}

class BundleServiceCheckBundleStockResponse extends $pb.GeneratedMessage {
  factory BundleServiceCheckBundleStockResponse({
    $core.String? bundleId,
    $core.bool? isAvailable,
    $core.String? reason,
    $core.Iterable<BundleItem>? stockBreakdown,
  }) {
    final result = BundleServiceCheckBundleStockResponse._();
    if (bundleId != null) result.bundleId = bundleId;
    if (isAvailable != null) result.isAvailable = isAvailable;
    if (reason != null) result.reason = reason;
    if (stockBreakdown != null) result.stockBreakdown.addAll(stockBreakdown);
    return result;
  }

  BundleServiceCheckBundleStockResponse._();

  factory BundleServiceCheckBundleStockResponse.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      BundleServiceCheckBundleStockResponse()..mergeFromBuffer(data, registry);
  factory BundleServiceCheckBundleStockResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      BundleServiceCheckBundleStockResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'BundleServiceCheckBundleStockResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance:
          BundleServiceCheckBundleStockResponse.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'bundleId')
    ..aOB(2, _omitFieldNames ? '' : 'isAvailable')
    ..aOS(3, _omitFieldNames ? '' : 'reason')
    ..pPM<BundleItem>(4, _omitFieldNames ? '' : 'stockBreakdown',
        subBuilder: BundleItem.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BundleServiceCheckBundleStockResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BundleServiceCheckBundleStockResponse copyWith(
          void Function(BundleServiceCheckBundleStockResponse) updates) =>
      super.copyWith((message) =>
              updates(message as BundleServiceCheckBundleStockResponse))
          as BundleServiceCheckBundleStockResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use BundleServiceCheckBundleStockResponse() / BundleServiceCheckBundleStockResponse.new instead')
  static BundleServiceCheckBundleStockResponse create() =>
      BundleServiceCheckBundleStockResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      BundleServiceCheckBundleStockResponse._();
  @$core.override
  BundleServiceCheckBundleStockResponse createEmptyInstance() =>
      BundleServiceCheckBundleStockResponse._();
  @$core.pragma('dart2js:noInline')
  static BundleServiceCheckBundleStockResponse getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
              BundleServiceCheckBundleStockResponse>(
          BundleServiceCheckBundleStockResponse.$_createMessage);
  static BundleServiceCheckBundleStockResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get bundleId => $_getSZ(0);
  @$pb.TagNumber(1)
  set bundleId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasBundleId() => $_has(0);
  @$pb.TagNumber(1)
  void clearBundleId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.bool get isAvailable => $_getBF(1);
  @$pb.TagNumber(2)
  set isAvailable($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasIsAvailable() => $_has(1);
  @$pb.TagNumber(2)
  void clearIsAvailable() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get reason => $_getSZ(2);
  @$pb.TagNumber(3)
  set reason($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasReason() => $_has(2);
  @$pb.TagNumber(3)
  void clearReason() => $_clearField(3);

  @$pb.TagNumber(4)
  $pb.PbList<BundleItem> get stockBreakdown => $_getList(3);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');

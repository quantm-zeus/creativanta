// This is a generated file - do not edit.
//
// Generated from creativanta/commerce/v1/monetization.proto.

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
import 'monetization.pbenum.dart';

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'monetization.pbenum.dart';

/// Channel availability setting for an offer.
class ChannelAvailability extends $pb.GeneratedMessage {
  factory ChannelAvailability({
    $core.String? platform,
    $core.bool? enabled,
  }) {
    final result = ChannelAvailability._();
    if (platform != null) result.platform = platform;
    if (enabled != null) result.enabled = enabled;
    return result;
  }

  ChannelAvailability._();

  factory ChannelAvailability.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ChannelAvailability()..mergeFromBuffer(data, registry);
  factory ChannelAvailability.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ChannelAvailability()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ChannelAvailability',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: ChannelAvailability.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'platform')
    ..aOB(2, _omitFieldNames ? '' : 'enabled')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ChannelAvailability clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ChannelAvailability copyWith(void Function(ChannelAvailability) updates) =>
      super.copyWith((message) => updates(message as ChannelAvailability))
          as ChannelAvailability;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core
      .Deprecated('Use ChannelAvailability() / ChannelAvailability.new instead')
  static ChannelAvailability create() => ChannelAvailability._();
  static $pb.GeneratedMessage $_createMessage() => ChannelAvailability._();
  @$core.override
  ChannelAvailability createEmptyInstance() => ChannelAvailability._();
  @$core.pragma('dart2js:noInline')
  static ChannelAvailability getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ChannelAvailability>(
          ChannelAvailability.$_createMessage);
  static ChannelAvailability? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get platform => $_getSZ(0);
  @$pb.TagNumber(1)
  set platform($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPlatform() => $_has(0);
  @$pb.TagNumber(1)
  void clearPlatform() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.bool get enabled => $_getBF(1);
  @$pb.TagNumber(2)
  set enabled($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasEnabled() => $_has(1);
  @$pb.TagNumber(2)
  void clearEnabled() => $_clearField(2);
}

/// Canonical Offer model.
class Offer extends $pb.GeneratedMessage {
  factory Offer({
    $core.String? offerId,
    $core.String? workspaceId,
    OfferType? offerType,
    $core.String? productId,
    $core.String? productLessDeclaration,
    $core.String? title,
    $core.String? pricingValue,
    $core.String? pricingCurrency,
    $core.String? pricingLogicJson,
    $core.String? ctaText,
    $core.String? ctaUrl,
    $core.Iterable<ChannelAvailability>? channelAvailability,
    OfferLifecycleState? lifecycleState,
    $core.Iterable<$core.String>? campaignIds,
    $core.String? metadataJson,
    $1.Timestamp? validFrom,
    $1.Timestamp? validUntil,
    $1.Timestamp? createdAt,
    $1.Timestamp? updatedAt,
  }) {
    final result = Offer._();
    if (offerId != null) result.offerId = offerId;
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (offerType != null) result.offerType = offerType;
    if (productId != null) result.productId = productId;
    if (productLessDeclaration != null)
      result.productLessDeclaration = productLessDeclaration;
    if (title != null) result.title = title;
    if (pricingValue != null) result.pricingValue = pricingValue;
    if (pricingCurrency != null) result.pricingCurrency = pricingCurrency;
    if (pricingLogicJson != null) result.pricingLogicJson = pricingLogicJson;
    if (ctaText != null) result.ctaText = ctaText;
    if (ctaUrl != null) result.ctaUrl = ctaUrl;
    if (channelAvailability != null)
      result.channelAvailability.addAll(channelAvailability);
    if (lifecycleState != null) result.lifecycleState = lifecycleState;
    if (campaignIds != null) result.campaignIds.addAll(campaignIds);
    if (metadataJson != null) result.metadataJson = metadataJson;
    if (validFrom != null) result.validFrom = validFrom;
    if (validUntil != null) result.validUntil = validUntil;
    if (createdAt != null) result.createdAt = createdAt;
    if (updatedAt != null) result.updatedAt = updatedAt;
    return result;
  }

  Offer._();

  factory Offer.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Offer()..mergeFromBuffer(data, registry);
  factory Offer.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Offer()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Offer',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: Offer.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'offerId')
    ..aOS(2, _omitFieldNames ? '' : 'workspaceId')
    ..aE<OfferType>(3, _omitFieldNames ? '' : 'offerType',
        enumValues: OfferType.values)
    ..aOS(4, _omitFieldNames ? '' : 'productId')
    ..aOS(5, _omitFieldNames ? '' : 'productLessDeclaration')
    ..aOS(6, _omitFieldNames ? '' : 'title')
    ..aOS(7, _omitFieldNames ? '' : 'pricingValue')
    ..aOS(8, _omitFieldNames ? '' : 'pricingCurrency')
    ..aOS(9, _omitFieldNames ? '' : 'pricingLogicJson')
    ..aOS(10, _omitFieldNames ? '' : 'ctaText')
    ..aOS(11, _omitFieldNames ? '' : 'ctaUrl')
    ..pPM<ChannelAvailability>(12, _omitFieldNames ? '' : 'channelAvailability',
        subBuilder: ChannelAvailability.$_createMessage)
    ..aE<OfferLifecycleState>(13, _omitFieldNames ? '' : 'lifecycleState',
        enumValues: OfferLifecycleState.values)
    ..pPS(14, _omitFieldNames ? '' : 'campaignIds')
    ..aOS(15, _omitFieldNames ? '' : 'metadataJson')
    ..aOM<$1.Timestamp>(16, _omitFieldNames ? '' : 'validFrom',
        subBuilder: $1.Timestamp.$_createMessage)
    ..aOM<$1.Timestamp>(17, _omitFieldNames ? '' : 'validUntil',
        subBuilder: $1.Timestamp.$_createMessage)
    ..aOM<$1.Timestamp>(18, _omitFieldNames ? '' : 'createdAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..aOM<$1.Timestamp>(19, _omitFieldNames ? '' : 'updatedAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Offer clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Offer copyWith(void Function(Offer) updates) =>
      super.copyWith((message) => updates(message as Offer)) as Offer;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use Offer() / Offer.new instead')
  static Offer create() => Offer._();
  static $pb.GeneratedMessage $_createMessage() => Offer._();
  @$core.override
  Offer createEmptyInstance() => Offer._();
  @$core.pragma('dart2js:noInline')
  static Offer getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Offer>(Offer.$_createMessage);
  static Offer? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get offerId => $_getSZ(0);
  @$pb.TagNumber(1)
  set offerId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasOfferId() => $_has(0);
  @$pb.TagNumber(1)
  void clearOfferId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get workspaceId => $_getSZ(1);
  @$pb.TagNumber(2)
  set workspaceId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasWorkspaceId() => $_has(1);
  @$pb.TagNumber(2)
  void clearWorkspaceId() => $_clearField(2);

  @$pb.TagNumber(3)
  OfferType get offerType => $_getN(2);
  @$pb.TagNumber(3)
  set offerType(OfferType value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasOfferType() => $_has(2);
  @$pb.TagNumber(3)
  void clearOfferType() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get productId => $_getSZ(3);
  @$pb.TagNumber(4)
  set productId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasProductId() => $_has(3);
  @$pb.TagNumber(4)
  void clearProductId() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get productLessDeclaration => $_getSZ(4);
  @$pb.TagNumber(5)
  set productLessDeclaration($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasProductLessDeclaration() => $_has(4);
  @$pb.TagNumber(5)
  void clearProductLessDeclaration() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get title => $_getSZ(5);
  @$pb.TagNumber(6)
  set title($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasTitle() => $_has(5);
  @$pb.TagNumber(6)
  void clearTitle() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get pricingValue => $_getSZ(6);
  @$pb.TagNumber(7)
  set pricingValue($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasPricingValue() => $_has(6);
  @$pb.TagNumber(7)
  void clearPricingValue() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get pricingCurrency => $_getSZ(7);
  @$pb.TagNumber(8)
  set pricingCurrency($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasPricingCurrency() => $_has(7);
  @$pb.TagNumber(8)
  void clearPricingCurrency() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get pricingLogicJson => $_getSZ(8);
  @$pb.TagNumber(9)
  set pricingLogicJson($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasPricingLogicJson() => $_has(8);
  @$pb.TagNumber(9)
  void clearPricingLogicJson() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.String get ctaText => $_getSZ(9);
  @$pb.TagNumber(10)
  set ctaText($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasCtaText() => $_has(9);
  @$pb.TagNumber(10)
  void clearCtaText() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.String get ctaUrl => $_getSZ(10);
  @$pb.TagNumber(11)
  set ctaUrl($core.String value) => $_setString(10, value);
  @$pb.TagNumber(11)
  $core.bool hasCtaUrl() => $_has(10);
  @$pb.TagNumber(11)
  void clearCtaUrl() => $_clearField(11);

  @$pb.TagNumber(12)
  $pb.PbList<ChannelAvailability> get channelAvailability => $_getList(11);

  @$pb.TagNumber(13)
  OfferLifecycleState get lifecycleState => $_getN(12);
  @$pb.TagNumber(13)
  set lifecycleState(OfferLifecycleState value) => $_setField(13, value);
  @$pb.TagNumber(13)
  $core.bool hasLifecycleState() => $_has(12);
  @$pb.TagNumber(13)
  void clearLifecycleState() => $_clearField(13);

  @$pb.TagNumber(14)
  $pb.PbList<$core.String> get campaignIds => $_getList(13);

  @$pb.TagNumber(15)
  $core.String get metadataJson => $_getSZ(14);
  @$pb.TagNumber(15)
  set metadataJson($core.String value) => $_setString(14, value);
  @$pb.TagNumber(15)
  $core.bool hasMetadataJson() => $_has(14);
  @$pb.TagNumber(15)
  void clearMetadataJson() => $_clearField(15);

  @$pb.TagNumber(16)
  $1.Timestamp get validFrom => $_getN(15);
  @$pb.TagNumber(16)
  set validFrom($1.Timestamp value) => $_setField(16, value);
  @$pb.TagNumber(16)
  $core.bool hasValidFrom() => $_has(15);
  @$pb.TagNumber(16)
  void clearValidFrom() => $_clearField(16);
  @$pb.TagNumber(16)
  $1.Timestamp ensureValidFrom() => $_ensure(15);

  @$pb.TagNumber(17)
  $1.Timestamp get validUntil => $_getN(16);
  @$pb.TagNumber(17)
  set validUntil($1.Timestamp value) => $_setField(17, value);
  @$pb.TagNumber(17)
  $core.bool hasValidUntil() => $_has(16);
  @$pb.TagNumber(17)
  void clearValidUntil() => $_clearField(17);
  @$pb.TagNumber(17)
  $1.Timestamp ensureValidUntil() => $_ensure(16);

  @$pb.TagNumber(18)
  $1.Timestamp get createdAt => $_getN(17);
  @$pb.TagNumber(18)
  set createdAt($1.Timestamp value) => $_setField(18, value);
  @$pb.TagNumber(18)
  $core.bool hasCreatedAt() => $_has(17);
  @$pb.TagNumber(18)
  void clearCreatedAt() => $_clearField(18);
  @$pb.TagNumber(18)
  $1.Timestamp ensureCreatedAt() => $_ensure(17);

  @$pb.TagNumber(19)
  $1.Timestamp get updatedAt => $_getN(18);
  @$pb.TagNumber(19)
  set updatedAt($1.Timestamp value) => $_setField(19, value);
  @$pb.TagNumber(19)
  $core.bool hasUpdatedAt() => $_has(18);
  @$pb.TagNumber(19)
  void clearUpdatedAt() => $_clearField(19);
  @$pb.TagNumber(19)
  $1.Timestamp ensureUpdatedAt() => $_ensure(18);
}

/// Canonical Coupon model.
class Coupon extends $pb.GeneratedMessage {
  factory Coupon({
    $core.String? couponId,
    $core.String? workspaceId,
    $core.String? code,
    CouponType? couponType,
    $core.String? discountValue,
    $core.String? minOrderAmount,
    $core.int? maxUses,
    $core.int? currentUses,
    CouponLifecycleState? lifecycleState,
    $core.Iterable<$core.String>? relatedOfferIds,
    $core.Iterable<$core.String>? relatedCampaignIds,
    $1.Timestamp? validFrom,
    $1.Timestamp? validUntil,
    $1.Timestamp? createdAt,
    $1.Timestamp? updatedAt,
  }) {
    final result = Coupon._();
    if (couponId != null) result.couponId = couponId;
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (code != null) result.code = code;
    if (couponType != null) result.couponType = couponType;
    if (discountValue != null) result.discountValue = discountValue;
    if (minOrderAmount != null) result.minOrderAmount = minOrderAmount;
    if (maxUses != null) result.maxUses = maxUses;
    if (currentUses != null) result.currentUses = currentUses;
    if (lifecycleState != null) result.lifecycleState = lifecycleState;
    if (relatedOfferIds != null) result.relatedOfferIds.addAll(relatedOfferIds);
    if (relatedCampaignIds != null)
      result.relatedCampaignIds.addAll(relatedCampaignIds);
    if (validFrom != null) result.validFrom = validFrom;
    if (validUntil != null) result.validUntil = validUntil;
    if (createdAt != null) result.createdAt = createdAt;
    if (updatedAt != null) result.updatedAt = updatedAt;
    return result;
  }

  Coupon._();

  factory Coupon.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Coupon()..mergeFromBuffer(data, registry);
  factory Coupon.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Coupon()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Coupon',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: Coupon.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'couponId')
    ..aOS(2, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(3, _omitFieldNames ? '' : 'code')
    ..aE<CouponType>(4, _omitFieldNames ? '' : 'couponType',
        enumValues: CouponType.values)
    ..aOS(5, _omitFieldNames ? '' : 'discountValue')
    ..aOS(6, _omitFieldNames ? '' : 'minOrderAmount')
    ..aI(7, _omitFieldNames ? '' : 'maxUses')
    ..aI(8, _omitFieldNames ? '' : 'currentUses')
    ..aE<CouponLifecycleState>(9, _omitFieldNames ? '' : 'lifecycleState',
        enumValues: CouponLifecycleState.values)
    ..pPS(10, _omitFieldNames ? '' : 'relatedOfferIds')
    ..pPS(11, _omitFieldNames ? '' : 'relatedCampaignIds')
    ..aOM<$1.Timestamp>(12, _omitFieldNames ? '' : 'validFrom',
        subBuilder: $1.Timestamp.$_createMessage)
    ..aOM<$1.Timestamp>(13, _omitFieldNames ? '' : 'validUntil',
        subBuilder: $1.Timestamp.$_createMessage)
    ..aOM<$1.Timestamp>(14, _omitFieldNames ? '' : 'createdAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..aOM<$1.Timestamp>(15, _omitFieldNames ? '' : 'updatedAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Coupon clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Coupon copyWith(void Function(Coupon) updates) =>
      super.copyWith((message) => updates(message as Coupon)) as Coupon;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use Coupon() / Coupon.new instead')
  static Coupon create() => Coupon._();
  static $pb.GeneratedMessage $_createMessage() => Coupon._();
  @$core.override
  Coupon createEmptyInstance() => Coupon._();
  @$core.pragma('dart2js:noInline')
  static Coupon getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Coupon>(Coupon.$_createMessage);
  static Coupon? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get couponId => $_getSZ(0);
  @$pb.TagNumber(1)
  set couponId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCouponId() => $_has(0);
  @$pb.TagNumber(1)
  void clearCouponId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get workspaceId => $_getSZ(1);
  @$pb.TagNumber(2)
  set workspaceId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasWorkspaceId() => $_has(1);
  @$pb.TagNumber(2)
  void clearWorkspaceId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get code => $_getSZ(2);
  @$pb.TagNumber(3)
  set code($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasCode() => $_has(2);
  @$pb.TagNumber(3)
  void clearCode() => $_clearField(3);

  @$pb.TagNumber(4)
  CouponType get couponType => $_getN(3);
  @$pb.TagNumber(4)
  set couponType(CouponType value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasCouponType() => $_has(3);
  @$pb.TagNumber(4)
  void clearCouponType() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get discountValue => $_getSZ(4);
  @$pb.TagNumber(5)
  set discountValue($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasDiscountValue() => $_has(4);
  @$pb.TagNumber(5)
  void clearDiscountValue() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get minOrderAmount => $_getSZ(5);
  @$pb.TagNumber(6)
  set minOrderAmount($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasMinOrderAmount() => $_has(5);
  @$pb.TagNumber(6)
  void clearMinOrderAmount() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.int get maxUses => $_getIZ(6);
  @$pb.TagNumber(7)
  set maxUses($core.int value) => $_setSignedInt32(6, value);
  @$pb.TagNumber(7)
  $core.bool hasMaxUses() => $_has(6);
  @$pb.TagNumber(7)
  void clearMaxUses() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.int get currentUses => $_getIZ(7);
  @$pb.TagNumber(8)
  set currentUses($core.int value) => $_setSignedInt32(7, value);
  @$pb.TagNumber(8)
  $core.bool hasCurrentUses() => $_has(7);
  @$pb.TagNumber(8)
  void clearCurrentUses() => $_clearField(8);

  @$pb.TagNumber(9)
  CouponLifecycleState get lifecycleState => $_getN(8);
  @$pb.TagNumber(9)
  set lifecycleState(CouponLifecycleState value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasLifecycleState() => $_has(8);
  @$pb.TagNumber(9)
  void clearLifecycleState() => $_clearField(9);

  @$pb.TagNumber(10)
  $pb.PbList<$core.String> get relatedOfferIds => $_getList(9);

  @$pb.TagNumber(11)
  $pb.PbList<$core.String> get relatedCampaignIds => $_getList(10);

  @$pb.TagNumber(12)
  $1.Timestamp get validFrom => $_getN(11);
  @$pb.TagNumber(12)
  set validFrom($1.Timestamp value) => $_setField(12, value);
  @$pb.TagNumber(12)
  $core.bool hasValidFrom() => $_has(11);
  @$pb.TagNumber(12)
  void clearValidFrom() => $_clearField(12);
  @$pb.TagNumber(12)
  $1.Timestamp ensureValidFrom() => $_ensure(11);

  @$pb.TagNumber(13)
  $1.Timestamp get validUntil => $_getN(12);
  @$pb.TagNumber(13)
  set validUntil($1.Timestamp value) => $_setField(13, value);
  @$pb.TagNumber(13)
  $core.bool hasValidUntil() => $_has(12);
  @$pb.TagNumber(13)
  void clearValidUntil() => $_clearField(13);
  @$pb.TagNumber(13)
  $1.Timestamp ensureValidUntil() => $_ensure(12);

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

/// Canonical Campaign model.
class Campaign extends $pb.GeneratedMessage {
  factory Campaign({
    $core.String? campaignId,
    $core.String? workspaceId,
    CampaignType? campaignType,
    $core.String? title,
    $core.String? objective,
    CampaignStatus? status,
    $core.String? startDate,
    $core.String? endDate,
    $core.String? budget,
    $core.String? budgetCurrency,
    $core.Iterable<$core.String>? relatedProductIds,
    $core.Iterable<$core.String>? relatedOfferIds,
    $core.String? metadataJson,
    $1.Timestamp? createdAt,
    $1.Timestamp? updatedAt,
  }) {
    final result = Campaign._();
    if (campaignId != null) result.campaignId = campaignId;
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (campaignType != null) result.campaignType = campaignType;
    if (title != null) result.title = title;
    if (objective != null) result.objective = objective;
    if (status != null) result.status = status;
    if (startDate != null) result.startDate = startDate;
    if (endDate != null) result.endDate = endDate;
    if (budget != null) result.budget = budget;
    if (budgetCurrency != null) result.budgetCurrency = budgetCurrency;
    if (relatedProductIds != null)
      result.relatedProductIds.addAll(relatedProductIds);
    if (relatedOfferIds != null) result.relatedOfferIds.addAll(relatedOfferIds);
    if (metadataJson != null) result.metadataJson = metadataJson;
    if (createdAt != null) result.createdAt = createdAt;
    if (updatedAt != null) result.updatedAt = updatedAt;
    return result;
  }

  Campaign._();

  factory Campaign.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Campaign()..mergeFromBuffer(data, registry);
  factory Campaign.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Campaign()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Campaign',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: Campaign.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'campaignId')
    ..aOS(2, _omitFieldNames ? '' : 'workspaceId')
    ..aE<CampaignType>(3, _omitFieldNames ? '' : 'campaignType',
        enumValues: CampaignType.values)
    ..aOS(4, _omitFieldNames ? '' : 'title')
    ..aOS(5, _omitFieldNames ? '' : 'objective')
    ..aE<CampaignStatus>(6, _omitFieldNames ? '' : 'status',
        enumValues: CampaignStatus.values)
    ..aOS(7, _omitFieldNames ? '' : 'startDate')
    ..aOS(8, _omitFieldNames ? '' : 'endDate')
    ..aOS(9, _omitFieldNames ? '' : 'budget')
    ..aOS(10, _omitFieldNames ? '' : 'budgetCurrency')
    ..pPS(11, _omitFieldNames ? '' : 'relatedProductIds')
    ..pPS(12, _omitFieldNames ? '' : 'relatedOfferIds')
    ..aOS(13, _omitFieldNames ? '' : 'metadataJson')
    ..aOM<$1.Timestamp>(14, _omitFieldNames ? '' : 'createdAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..aOM<$1.Timestamp>(15, _omitFieldNames ? '' : 'updatedAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Campaign clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Campaign copyWith(void Function(Campaign) updates) =>
      super.copyWith((message) => updates(message as Campaign)) as Campaign;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use Campaign() / Campaign.new instead')
  static Campaign create() => Campaign._();
  static $pb.GeneratedMessage $_createMessage() => Campaign._();
  @$core.override
  Campaign createEmptyInstance() => Campaign._();
  @$core.pragma('dart2js:noInline')
  static Campaign getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Campaign>(Campaign.$_createMessage);
  static Campaign? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get campaignId => $_getSZ(0);
  @$pb.TagNumber(1)
  set campaignId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCampaignId() => $_has(0);
  @$pb.TagNumber(1)
  void clearCampaignId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get workspaceId => $_getSZ(1);
  @$pb.TagNumber(2)
  set workspaceId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasWorkspaceId() => $_has(1);
  @$pb.TagNumber(2)
  void clearWorkspaceId() => $_clearField(2);

  @$pb.TagNumber(3)
  CampaignType get campaignType => $_getN(2);
  @$pb.TagNumber(3)
  set campaignType(CampaignType value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasCampaignType() => $_has(2);
  @$pb.TagNumber(3)
  void clearCampaignType() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get title => $_getSZ(3);
  @$pb.TagNumber(4)
  set title($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasTitle() => $_has(3);
  @$pb.TagNumber(4)
  void clearTitle() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get objective => $_getSZ(4);
  @$pb.TagNumber(5)
  set objective($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasObjective() => $_has(4);
  @$pb.TagNumber(5)
  void clearObjective() => $_clearField(5);

  @$pb.TagNumber(6)
  CampaignStatus get status => $_getN(5);
  @$pb.TagNumber(6)
  set status(CampaignStatus value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasStatus() => $_has(5);
  @$pb.TagNumber(6)
  void clearStatus() => $_clearField(6);

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
  $core.String get budget => $_getSZ(8);
  @$pb.TagNumber(9)
  set budget($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasBudget() => $_has(8);
  @$pb.TagNumber(9)
  void clearBudget() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.String get budgetCurrency => $_getSZ(9);
  @$pb.TagNumber(10)
  set budgetCurrency($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasBudgetCurrency() => $_has(9);
  @$pb.TagNumber(10)
  void clearBudgetCurrency() => $_clearField(10);

  @$pb.TagNumber(11)
  $pb.PbList<$core.String> get relatedProductIds => $_getList(10);

  @$pb.TagNumber(12)
  $pb.PbList<$core.String> get relatedOfferIds => $_getList(11);

  @$pb.TagNumber(13)
  $core.String get metadataJson => $_getSZ(12);
  @$pb.TagNumber(13)
  set metadataJson($core.String value) => $_setString(12, value);
  @$pb.TagNumber(13)
  $core.bool hasMetadataJson() => $_has(12);
  @$pb.TagNumber(13)
  void clearMetadataJson() => $_clearField(13);

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

/// Coupon redemption record for ledger linkage.
class CouponRedemption extends $pb.GeneratedMessage {
  factory CouponRedemption({
    $core.String? redemptionId,
    $core.String? workspaceId,
    $core.String? couponId,
    $core.String? orderId,
    $core.String? discountAmount,
    $core.String? currency,
    $1.Timestamp? redeemedAt,
    $core.String? metadataJson,
  }) {
    final result = CouponRedemption._();
    if (redemptionId != null) result.redemptionId = redemptionId;
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (couponId != null) result.couponId = couponId;
    if (orderId != null) result.orderId = orderId;
    if (discountAmount != null) result.discountAmount = discountAmount;
    if (currency != null) result.currency = currency;
    if (redeemedAt != null) result.redeemedAt = redeemedAt;
    if (metadataJson != null) result.metadataJson = metadataJson;
    return result;
  }

  CouponRedemption._();

  factory CouponRedemption.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CouponRedemption()..mergeFromBuffer(data, registry);
  factory CouponRedemption.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CouponRedemption()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CouponRedemption',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: CouponRedemption.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'redemptionId')
    ..aOS(2, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(3, _omitFieldNames ? '' : 'couponId')
    ..aOS(4, _omitFieldNames ? '' : 'orderId')
    ..aOS(5, _omitFieldNames ? '' : 'discountAmount')
    ..aOS(6, _omitFieldNames ? '' : 'currency')
    ..aOM<$1.Timestamp>(7, _omitFieldNames ? '' : 'redeemedAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..aOS(8, _omitFieldNames ? '' : 'metadataJson')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CouponRedemption clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CouponRedemption copyWith(void Function(CouponRedemption) updates) =>
      super.copyWith((message) => updates(message as CouponRedemption))
          as CouponRedemption;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use CouponRedemption() / CouponRedemption.new instead')
  static CouponRedemption create() => CouponRedemption._();
  static $pb.GeneratedMessage $_createMessage() => CouponRedemption._();
  @$core.override
  CouponRedemption createEmptyInstance() => CouponRedemption._();
  @$core.pragma('dart2js:noInline')
  static CouponRedemption getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CouponRedemption>(
          CouponRedemption.$_createMessage);
  static CouponRedemption? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get redemptionId => $_getSZ(0);
  @$pb.TagNumber(1)
  set redemptionId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRedemptionId() => $_has(0);
  @$pb.TagNumber(1)
  void clearRedemptionId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get workspaceId => $_getSZ(1);
  @$pb.TagNumber(2)
  set workspaceId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasWorkspaceId() => $_has(1);
  @$pb.TagNumber(2)
  void clearWorkspaceId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get couponId => $_getSZ(2);
  @$pb.TagNumber(3)
  set couponId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasCouponId() => $_has(2);
  @$pb.TagNumber(3)
  void clearCouponId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get orderId => $_getSZ(3);
  @$pb.TagNumber(4)
  set orderId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasOrderId() => $_has(3);
  @$pb.TagNumber(4)
  void clearOrderId() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get discountAmount => $_getSZ(4);
  @$pb.TagNumber(5)
  set discountAmount($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasDiscountAmount() => $_has(4);
  @$pb.TagNumber(5)
  void clearDiscountAmount() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get currency => $_getSZ(5);
  @$pb.TagNumber(6)
  set currency($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasCurrency() => $_has(5);
  @$pb.TagNumber(6)
  void clearCurrency() => $_clearField(6);

  @$pb.TagNumber(7)
  $1.Timestamp get redeemedAt => $_getN(6);
  @$pb.TagNumber(7)
  set redeemedAt($1.Timestamp value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasRedeemedAt() => $_has(6);
  @$pb.TagNumber(7)
  void clearRedeemedAt() => $_clearField(7);
  @$pb.TagNumber(7)
  $1.Timestamp ensureRedeemedAt() => $_ensure(6);

  @$pb.TagNumber(8)
  $core.String get metadataJson => $_getSZ(7);
  @$pb.TagNumber(8)
  set metadataJson($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasMetadataJson() => $_has(7);
  @$pb.TagNumber(8)
  void clearMetadataJson() => $_clearField(8);
}

/// Offer Service Requests/Responses
class OfferServiceCreateRequest extends $pb.GeneratedMessage {
  factory OfferServiceCreateRequest({
    $core.String? workspaceId,
    OfferType? offerType,
    $core.String? productId,
    $core.String? productLessDeclaration,
    $core.String? title,
    $core.String? pricingValue,
    $core.String? pricingCurrency,
    $core.String? pricingLogicJson,
    $core.String? ctaText,
    $core.String? ctaUrl,
    $core.Iterable<ChannelAvailability>? channelAvailability,
    $core.Iterable<$core.String>? campaignIds,
    $core.String? metadataJson,
    $1.Timestamp? validFrom,
    $1.Timestamp? validUntil,
    $2.CommandContext? commandContext,
  }) {
    final result = OfferServiceCreateRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (offerType != null) result.offerType = offerType;
    if (productId != null) result.productId = productId;
    if (productLessDeclaration != null)
      result.productLessDeclaration = productLessDeclaration;
    if (title != null) result.title = title;
    if (pricingValue != null) result.pricingValue = pricingValue;
    if (pricingCurrency != null) result.pricingCurrency = pricingCurrency;
    if (pricingLogicJson != null) result.pricingLogicJson = pricingLogicJson;
    if (ctaText != null) result.ctaText = ctaText;
    if (ctaUrl != null) result.ctaUrl = ctaUrl;
    if (channelAvailability != null)
      result.channelAvailability.addAll(channelAvailability);
    if (campaignIds != null) result.campaignIds.addAll(campaignIds);
    if (metadataJson != null) result.metadataJson = metadataJson;
    if (validFrom != null) result.validFrom = validFrom;
    if (validUntil != null) result.validUntil = validUntil;
    if (commandContext != null) result.commandContext = commandContext;
    return result;
  }

  OfferServiceCreateRequest._();

  factory OfferServiceCreateRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      OfferServiceCreateRequest()..mergeFromBuffer(data, registry);
  factory OfferServiceCreateRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      OfferServiceCreateRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'OfferServiceCreateRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: OfferServiceCreateRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aE<OfferType>(2, _omitFieldNames ? '' : 'offerType',
        enumValues: OfferType.values)
    ..aOS(3, _omitFieldNames ? '' : 'productId')
    ..aOS(4, _omitFieldNames ? '' : 'productLessDeclaration')
    ..aOS(5, _omitFieldNames ? '' : 'title')
    ..aOS(6, _omitFieldNames ? '' : 'pricingValue')
    ..aOS(7, _omitFieldNames ? '' : 'pricingCurrency')
    ..aOS(8, _omitFieldNames ? '' : 'pricingLogicJson')
    ..aOS(9, _omitFieldNames ? '' : 'ctaText')
    ..aOS(10, _omitFieldNames ? '' : 'ctaUrl')
    ..pPM<ChannelAvailability>(11, _omitFieldNames ? '' : 'channelAvailability',
        subBuilder: ChannelAvailability.$_createMessage)
    ..pPS(12, _omitFieldNames ? '' : 'campaignIds')
    ..aOS(13, _omitFieldNames ? '' : 'metadataJson')
    ..aOM<$1.Timestamp>(14, _omitFieldNames ? '' : 'validFrom',
        subBuilder: $1.Timestamp.$_createMessage)
    ..aOM<$1.Timestamp>(15, _omitFieldNames ? '' : 'validUntil',
        subBuilder: $1.Timestamp.$_createMessage)
    ..aOM<$2.CommandContext>(16, _omitFieldNames ? '' : 'commandContext',
        subBuilder: $2.CommandContext.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OfferServiceCreateRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OfferServiceCreateRequest copyWith(
          void Function(OfferServiceCreateRequest) updates) =>
      super.copyWith((message) => updates(message as OfferServiceCreateRequest))
          as OfferServiceCreateRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use OfferServiceCreateRequest() / OfferServiceCreateRequest.new instead')
  static OfferServiceCreateRequest create() => OfferServiceCreateRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      OfferServiceCreateRequest._();
  @$core.override
  OfferServiceCreateRequest createEmptyInstance() =>
      OfferServiceCreateRequest._();
  @$core.pragma('dart2js:noInline')
  static OfferServiceCreateRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<OfferServiceCreateRequest>(
          OfferServiceCreateRequest.$_createMessage);
  static OfferServiceCreateRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  OfferType get offerType => $_getN(1);
  @$pb.TagNumber(2)
  set offerType(OfferType value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasOfferType() => $_has(1);
  @$pb.TagNumber(2)
  void clearOfferType() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get productId => $_getSZ(2);
  @$pb.TagNumber(3)
  set productId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasProductId() => $_has(2);
  @$pb.TagNumber(3)
  void clearProductId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get productLessDeclaration => $_getSZ(3);
  @$pb.TagNumber(4)
  set productLessDeclaration($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasProductLessDeclaration() => $_has(3);
  @$pb.TagNumber(4)
  void clearProductLessDeclaration() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get title => $_getSZ(4);
  @$pb.TagNumber(5)
  set title($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasTitle() => $_has(4);
  @$pb.TagNumber(5)
  void clearTitle() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get pricingValue => $_getSZ(5);
  @$pb.TagNumber(6)
  set pricingValue($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasPricingValue() => $_has(5);
  @$pb.TagNumber(6)
  void clearPricingValue() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get pricingCurrency => $_getSZ(6);
  @$pb.TagNumber(7)
  set pricingCurrency($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasPricingCurrency() => $_has(6);
  @$pb.TagNumber(7)
  void clearPricingCurrency() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get pricingLogicJson => $_getSZ(7);
  @$pb.TagNumber(8)
  set pricingLogicJson($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasPricingLogicJson() => $_has(7);
  @$pb.TagNumber(8)
  void clearPricingLogicJson() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get ctaText => $_getSZ(8);
  @$pb.TagNumber(9)
  set ctaText($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasCtaText() => $_has(8);
  @$pb.TagNumber(9)
  void clearCtaText() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.String get ctaUrl => $_getSZ(9);
  @$pb.TagNumber(10)
  set ctaUrl($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasCtaUrl() => $_has(9);
  @$pb.TagNumber(10)
  void clearCtaUrl() => $_clearField(10);

  @$pb.TagNumber(11)
  $pb.PbList<ChannelAvailability> get channelAvailability => $_getList(10);

  @$pb.TagNumber(12)
  $pb.PbList<$core.String> get campaignIds => $_getList(11);

  @$pb.TagNumber(13)
  $core.String get metadataJson => $_getSZ(12);
  @$pb.TagNumber(13)
  set metadataJson($core.String value) => $_setString(12, value);
  @$pb.TagNumber(13)
  $core.bool hasMetadataJson() => $_has(12);
  @$pb.TagNumber(13)
  void clearMetadataJson() => $_clearField(13);

  @$pb.TagNumber(14)
  $1.Timestamp get validFrom => $_getN(13);
  @$pb.TagNumber(14)
  set validFrom($1.Timestamp value) => $_setField(14, value);
  @$pb.TagNumber(14)
  $core.bool hasValidFrom() => $_has(13);
  @$pb.TagNumber(14)
  void clearValidFrom() => $_clearField(14);
  @$pb.TagNumber(14)
  $1.Timestamp ensureValidFrom() => $_ensure(13);

  @$pb.TagNumber(15)
  $1.Timestamp get validUntil => $_getN(14);
  @$pb.TagNumber(15)
  set validUntil($1.Timestamp value) => $_setField(15, value);
  @$pb.TagNumber(15)
  $core.bool hasValidUntil() => $_has(14);
  @$pb.TagNumber(15)
  void clearValidUntil() => $_clearField(15);
  @$pb.TagNumber(15)
  $1.Timestamp ensureValidUntil() => $_ensure(14);

  @$pb.TagNumber(16)
  $2.CommandContext get commandContext => $_getN(15);
  @$pb.TagNumber(16)
  set commandContext($2.CommandContext value) => $_setField(16, value);
  @$pb.TagNumber(16)
  $core.bool hasCommandContext() => $_has(15);
  @$pb.TagNumber(16)
  void clearCommandContext() => $_clearField(16);
  @$pb.TagNumber(16)
  $2.CommandContext ensureCommandContext() => $_ensure(15);
}

class OfferServiceCreateResponse extends $pb.GeneratedMessage {
  factory OfferServiceCreateResponse({
    Offer? offer,
  }) {
    final result = OfferServiceCreateResponse._();
    if (offer != null) result.offer = offer;
    return result;
  }

  OfferServiceCreateResponse._();

  factory OfferServiceCreateResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      OfferServiceCreateResponse()..mergeFromBuffer(data, registry);
  factory OfferServiceCreateResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      OfferServiceCreateResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'OfferServiceCreateResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: OfferServiceCreateResponse.$_createMessage)
    ..aOM<Offer>(1, _omitFieldNames ? '' : 'offer',
        subBuilder: Offer.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OfferServiceCreateResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OfferServiceCreateResponse copyWith(
          void Function(OfferServiceCreateResponse) updates) =>
      super.copyWith(
              (message) => updates(message as OfferServiceCreateResponse))
          as OfferServiceCreateResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use OfferServiceCreateResponse() / OfferServiceCreateResponse.new instead')
  static OfferServiceCreateResponse create() => OfferServiceCreateResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      OfferServiceCreateResponse._();
  @$core.override
  OfferServiceCreateResponse createEmptyInstance() =>
      OfferServiceCreateResponse._();
  @$core.pragma('dart2js:noInline')
  static OfferServiceCreateResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<OfferServiceCreateResponse>(
          OfferServiceCreateResponse.$_createMessage);
  static OfferServiceCreateResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Offer get offer => $_getN(0);
  @$pb.TagNumber(1)
  set offer(Offer value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasOffer() => $_has(0);
  @$pb.TagNumber(1)
  void clearOffer() => $_clearField(1);
  @$pb.TagNumber(1)
  Offer ensureOffer() => $_ensure(0);
}

class OfferServiceGetRequest extends $pb.GeneratedMessage {
  factory OfferServiceGetRequest({
    $core.String? workspaceId,
    $core.String? offerId,
  }) {
    final result = OfferServiceGetRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (offerId != null) result.offerId = offerId;
    return result;
  }

  OfferServiceGetRequest._();

  factory OfferServiceGetRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      OfferServiceGetRequest()..mergeFromBuffer(data, registry);
  factory OfferServiceGetRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      OfferServiceGetRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'OfferServiceGetRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: OfferServiceGetRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'offerId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OfferServiceGetRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OfferServiceGetRequest copyWith(
          void Function(OfferServiceGetRequest) updates) =>
      super.copyWith((message) => updates(message as OfferServiceGetRequest))
          as OfferServiceGetRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use OfferServiceGetRequest() / OfferServiceGetRequest.new instead')
  static OfferServiceGetRequest create() => OfferServiceGetRequest._();
  static $pb.GeneratedMessage $_createMessage() => OfferServiceGetRequest._();
  @$core.override
  OfferServiceGetRequest createEmptyInstance() => OfferServiceGetRequest._();
  @$core.pragma('dart2js:noInline')
  static OfferServiceGetRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<OfferServiceGetRequest>(
          OfferServiceGetRequest.$_createMessage);
  static OfferServiceGetRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get offerId => $_getSZ(1);
  @$pb.TagNumber(2)
  set offerId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasOfferId() => $_has(1);
  @$pb.TagNumber(2)
  void clearOfferId() => $_clearField(2);
}

class OfferServiceGetResponse extends $pb.GeneratedMessage {
  factory OfferServiceGetResponse({
    Offer? offer,
  }) {
    final result = OfferServiceGetResponse._();
    if (offer != null) result.offer = offer;
    return result;
  }

  OfferServiceGetResponse._();

  factory OfferServiceGetResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      OfferServiceGetResponse()..mergeFromBuffer(data, registry);
  factory OfferServiceGetResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      OfferServiceGetResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'OfferServiceGetResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: OfferServiceGetResponse.$_createMessage)
    ..aOM<Offer>(1, _omitFieldNames ? '' : 'offer',
        subBuilder: Offer.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OfferServiceGetResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OfferServiceGetResponse copyWith(
          void Function(OfferServiceGetResponse) updates) =>
      super.copyWith((message) => updates(message as OfferServiceGetResponse))
          as OfferServiceGetResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use OfferServiceGetResponse() / OfferServiceGetResponse.new instead')
  static OfferServiceGetResponse create() => OfferServiceGetResponse._();
  static $pb.GeneratedMessage $_createMessage() => OfferServiceGetResponse._();
  @$core.override
  OfferServiceGetResponse createEmptyInstance() => OfferServiceGetResponse._();
  @$core.pragma('dart2js:noInline')
  static OfferServiceGetResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<OfferServiceGetResponse>(
          OfferServiceGetResponse.$_createMessage);
  static OfferServiceGetResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Offer get offer => $_getN(0);
  @$pb.TagNumber(1)
  set offer(Offer value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasOffer() => $_has(0);
  @$pb.TagNumber(1)
  void clearOffer() => $_clearField(1);
  @$pb.TagNumber(1)
  Offer ensureOffer() => $_ensure(0);
}

class OfferServiceListRequest extends $pb.GeneratedMessage {
  factory OfferServiceListRequest({
    $core.String? workspaceId,
    OfferLifecycleState? status,
    $core.String? productId,
    $core.String? query,
    $core.String? sort,
    $core.int? pageSize,
    $core.String? pageToken,
  }) {
    final result = OfferServiceListRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (status != null) result.status = status;
    if (productId != null) result.productId = productId;
    if (query != null) result.query = query;
    if (sort != null) result.sort = sort;
    if (pageSize != null) result.pageSize = pageSize;
    if (pageToken != null) result.pageToken = pageToken;
    return result;
  }

  OfferServiceListRequest._();

  factory OfferServiceListRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      OfferServiceListRequest()..mergeFromBuffer(data, registry);
  factory OfferServiceListRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      OfferServiceListRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'OfferServiceListRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: OfferServiceListRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aE<OfferLifecycleState>(2, _omitFieldNames ? '' : 'status',
        enumValues: OfferLifecycleState.values)
    ..aOS(3, _omitFieldNames ? '' : 'productId')
    ..aOS(4, _omitFieldNames ? '' : 'query')
    ..aOS(5, _omitFieldNames ? '' : 'sort')
    ..aI(6, _omitFieldNames ? '' : 'pageSize')
    ..aOS(7, _omitFieldNames ? '' : 'pageToken')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OfferServiceListRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OfferServiceListRequest copyWith(
          void Function(OfferServiceListRequest) updates) =>
      super.copyWith((message) => updates(message as OfferServiceListRequest))
          as OfferServiceListRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use OfferServiceListRequest() / OfferServiceListRequest.new instead')
  static OfferServiceListRequest create() => OfferServiceListRequest._();
  static $pb.GeneratedMessage $_createMessage() => OfferServiceListRequest._();
  @$core.override
  OfferServiceListRequest createEmptyInstance() => OfferServiceListRequest._();
  @$core.pragma('dart2js:noInline')
  static OfferServiceListRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<OfferServiceListRequest>(
          OfferServiceListRequest.$_createMessage);
  static OfferServiceListRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  OfferLifecycleState get status => $_getN(1);
  @$pb.TagNumber(2)
  set status(OfferLifecycleState value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasStatus() => $_has(1);
  @$pb.TagNumber(2)
  void clearStatus() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get productId => $_getSZ(2);
  @$pb.TagNumber(3)
  set productId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasProductId() => $_has(2);
  @$pb.TagNumber(3)
  void clearProductId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get query => $_getSZ(3);
  @$pb.TagNumber(4)
  set query($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasQuery() => $_has(3);
  @$pb.TagNumber(4)
  void clearQuery() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get sort => $_getSZ(4);
  @$pb.TagNumber(5)
  set sort($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasSort() => $_has(4);
  @$pb.TagNumber(5)
  void clearSort() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.int get pageSize => $_getIZ(5);
  @$pb.TagNumber(6)
  set pageSize($core.int value) => $_setSignedInt32(5, value);
  @$pb.TagNumber(6)
  $core.bool hasPageSize() => $_has(5);
  @$pb.TagNumber(6)
  void clearPageSize() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get pageToken => $_getSZ(6);
  @$pb.TagNumber(7)
  set pageToken($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasPageToken() => $_has(6);
  @$pb.TagNumber(7)
  void clearPageToken() => $_clearField(7);
}

class OfferServiceListResponse extends $pb.GeneratedMessage {
  factory OfferServiceListResponse({
    $core.Iterable<Offer>? offers,
    $core.String? nextPageToken,
    $core.int? totalCount,
  }) {
    final result = OfferServiceListResponse._();
    if (offers != null) result.offers.addAll(offers);
    if (nextPageToken != null) result.nextPageToken = nextPageToken;
    if (totalCount != null) result.totalCount = totalCount;
    return result;
  }

  OfferServiceListResponse._();

  factory OfferServiceListResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      OfferServiceListResponse()..mergeFromBuffer(data, registry);
  factory OfferServiceListResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      OfferServiceListResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'OfferServiceListResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: OfferServiceListResponse.$_createMessage)
    ..pPM<Offer>(1, _omitFieldNames ? '' : 'offers',
        subBuilder: Offer.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'nextPageToken')
    ..aI(3, _omitFieldNames ? '' : 'totalCount')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OfferServiceListResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OfferServiceListResponse copyWith(
          void Function(OfferServiceListResponse) updates) =>
      super.copyWith((message) => updates(message as OfferServiceListResponse))
          as OfferServiceListResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use OfferServiceListResponse() / OfferServiceListResponse.new instead')
  static OfferServiceListResponse create() => OfferServiceListResponse._();
  static $pb.GeneratedMessage $_createMessage() => OfferServiceListResponse._();
  @$core.override
  OfferServiceListResponse createEmptyInstance() =>
      OfferServiceListResponse._();
  @$core.pragma('dart2js:noInline')
  static OfferServiceListResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<OfferServiceListResponse>(
          OfferServiceListResponse.$_createMessage);
  static OfferServiceListResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Offer> get offers => $_getList(0);

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

class OfferServiceUpdateRequest extends $pb.GeneratedMessage {
  factory OfferServiceUpdateRequest({
    $core.String? workspaceId,
    $core.String? offerId,
    $core.String? title,
    $core.String? pricingValue,
    $core.String? pricingLogicJson,
    $core.String? ctaText,
    $core.String? ctaUrl,
    $core.Iterable<ChannelAvailability>? channelAvailability,
    $core.Iterable<$core.String>? campaignIds,
    $core.String? metadataJson,
    $1.Timestamp? validFrom,
    $1.Timestamp? validUntil,
    $2.CommandContext? commandContext,
  }) {
    final result = OfferServiceUpdateRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (offerId != null) result.offerId = offerId;
    if (title != null) result.title = title;
    if (pricingValue != null) result.pricingValue = pricingValue;
    if (pricingLogicJson != null) result.pricingLogicJson = pricingLogicJson;
    if (ctaText != null) result.ctaText = ctaText;
    if (ctaUrl != null) result.ctaUrl = ctaUrl;
    if (channelAvailability != null)
      result.channelAvailability.addAll(channelAvailability);
    if (campaignIds != null) result.campaignIds.addAll(campaignIds);
    if (metadataJson != null) result.metadataJson = metadataJson;
    if (validFrom != null) result.validFrom = validFrom;
    if (validUntil != null) result.validUntil = validUntil;
    if (commandContext != null) result.commandContext = commandContext;
    return result;
  }

  OfferServiceUpdateRequest._();

  factory OfferServiceUpdateRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      OfferServiceUpdateRequest()..mergeFromBuffer(data, registry);
  factory OfferServiceUpdateRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      OfferServiceUpdateRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'OfferServiceUpdateRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: OfferServiceUpdateRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'offerId')
    ..aOS(3, _omitFieldNames ? '' : 'title')
    ..aOS(4, _omitFieldNames ? '' : 'pricingValue')
    ..aOS(5, _omitFieldNames ? '' : 'pricingLogicJson')
    ..aOS(6, _omitFieldNames ? '' : 'ctaText')
    ..aOS(7, _omitFieldNames ? '' : 'ctaUrl')
    ..pPM<ChannelAvailability>(8, _omitFieldNames ? '' : 'channelAvailability',
        subBuilder: ChannelAvailability.$_createMessage)
    ..pPS(9, _omitFieldNames ? '' : 'campaignIds')
    ..aOS(10, _omitFieldNames ? '' : 'metadataJson')
    ..aOM<$1.Timestamp>(11, _omitFieldNames ? '' : 'validFrom',
        subBuilder: $1.Timestamp.$_createMessage)
    ..aOM<$1.Timestamp>(12, _omitFieldNames ? '' : 'validUntil',
        subBuilder: $1.Timestamp.$_createMessage)
    ..aOM<$2.CommandContext>(13, _omitFieldNames ? '' : 'commandContext',
        subBuilder: $2.CommandContext.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OfferServiceUpdateRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OfferServiceUpdateRequest copyWith(
          void Function(OfferServiceUpdateRequest) updates) =>
      super.copyWith((message) => updates(message as OfferServiceUpdateRequest))
          as OfferServiceUpdateRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use OfferServiceUpdateRequest() / OfferServiceUpdateRequest.new instead')
  static OfferServiceUpdateRequest create() => OfferServiceUpdateRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      OfferServiceUpdateRequest._();
  @$core.override
  OfferServiceUpdateRequest createEmptyInstance() =>
      OfferServiceUpdateRequest._();
  @$core.pragma('dart2js:noInline')
  static OfferServiceUpdateRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<OfferServiceUpdateRequest>(
          OfferServiceUpdateRequest.$_createMessage);
  static OfferServiceUpdateRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get offerId => $_getSZ(1);
  @$pb.TagNumber(2)
  set offerId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasOfferId() => $_has(1);
  @$pb.TagNumber(2)
  void clearOfferId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get title => $_getSZ(2);
  @$pb.TagNumber(3)
  set title($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasTitle() => $_has(2);
  @$pb.TagNumber(3)
  void clearTitle() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get pricingValue => $_getSZ(3);
  @$pb.TagNumber(4)
  set pricingValue($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasPricingValue() => $_has(3);
  @$pb.TagNumber(4)
  void clearPricingValue() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get pricingLogicJson => $_getSZ(4);
  @$pb.TagNumber(5)
  set pricingLogicJson($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasPricingLogicJson() => $_has(4);
  @$pb.TagNumber(5)
  void clearPricingLogicJson() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get ctaText => $_getSZ(5);
  @$pb.TagNumber(6)
  set ctaText($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasCtaText() => $_has(5);
  @$pb.TagNumber(6)
  void clearCtaText() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get ctaUrl => $_getSZ(6);
  @$pb.TagNumber(7)
  set ctaUrl($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasCtaUrl() => $_has(6);
  @$pb.TagNumber(7)
  void clearCtaUrl() => $_clearField(7);

  @$pb.TagNumber(8)
  $pb.PbList<ChannelAvailability> get channelAvailability => $_getList(7);

  @$pb.TagNumber(9)
  $pb.PbList<$core.String> get campaignIds => $_getList(8);

  @$pb.TagNumber(10)
  $core.String get metadataJson => $_getSZ(9);
  @$pb.TagNumber(10)
  set metadataJson($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasMetadataJson() => $_has(9);
  @$pb.TagNumber(10)
  void clearMetadataJson() => $_clearField(10);

  @$pb.TagNumber(11)
  $1.Timestamp get validFrom => $_getN(10);
  @$pb.TagNumber(11)
  set validFrom($1.Timestamp value) => $_setField(11, value);
  @$pb.TagNumber(11)
  $core.bool hasValidFrom() => $_has(10);
  @$pb.TagNumber(11)
  void clearValidFrom() => $_clearField(11);
  @$pb.TagNumber(11)
  $1.Timestamp ensureValidFrom() => $_ensure(10);

  @$pb.TagNumber(12)
  $1.Timestamp get validUntil => $_getN(11);
  @$pb.TagNumber(12)
  set validUntil($1.Timestamp value) => $_setField(12, value);
  @$pb.TagNumber(12)
  $core.bool hasValidUntil() => $_has(11);
  @$pb.TagNumber(12)
  void clearValidUntil() => $_clearField(12);
  @$pb.TagNumber(12)
  $1.Timestamp ensureValidUntil() => $_ensure(11);

  @$pb.TagNumber(13)
  $2.CommandContext get commandContext => $_getN(12);
  @$pb.TagNumber(13)
  set commandContext($2.CommandContext value) => $_setField(13, value);
  @$pb.TagNumber(13)
  $core.bool hasCommandContext() => $_has(12);
  @$pb.TagNumber(13)
  void clearCommandContext() => $_clearField(13);
  @$pb.TagNumber(13)
  $2.CommandContext ensureCommandContext() => $_ensure(12);
}

class OfferServiceUpdateResponse extends $pb.GeneratedMessage {
  factory OfferServiceUpdateResponse({
    Offer? offer,
  }) {
    final result = OfferServiceUpdateResponse._();
    if (offer != null) result.offer = offer;
    return result;
  }

  OfferServiceUpdateResponse._();

  factory OfferServiceUpdateResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      OfferServiceUpdateResponse()..mergeFromBuffer(data, registry);
  factory OfferServiceUpdateResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      OfferServiceUpdateResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'OfferServiceUpdateResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: OfferServiceUpdateResponse.$_createMessage)
    ..aOM<Offer>(1, _omitFieldNames ? '' : 'offer',
        subBuilder: Offer.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OfferServiceUpdateResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OfferServiceUpdateResponse copyWith(
          void Function(OfferServiceUpdateResponse) updates) =>
      super.copyWith(
              (message) => updates(message as OfferServiceUpdateResponse))
          as OfferServiceUpdateResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use OfferServiceUpdateResponse() / OfferServiceUpdateResponse.new instead')
  static OfferServiceUpdateResponse create() => OfferServiceUpdateResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      OfferServiceUpdateResponse._();
  @$core.override
  OfferServiceUpdateResponse createEmptyInstance() =>
      OfferServiceUpdateResponse._();
  @$core.pragma('dart2js:noInline')
  static OfferServiceUpdateResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<OfferServiceUpdateResponse>(
          OfferServiceUpdateResponse.$_createMessage);
  static OfferServiceUpdateResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Offer get offer => $_getN(0);
  @$pb.TagNumber(1)
  set offer(Offer value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasOffer() => $_has(0);
  @$pb.TagNumber(1)
  void clearOffer() => $_clearField(1);
  @$pb.TagNumber(1)
  Offer ensureOffer() => $_ensure(0);
}

class OfferServiceActivateRequest extends $pb.GeneratedMessage {
  factory OfferServiceActivateRequest({
    $core.String? idempotencyKey,
    $core.String? workspaceId,
    $core.String? offerId,
    $2.CommandContext? commandContext,
  }) {
    final result = OfferServiceActivateRequest._();
    if (idempotencyKey != null) result.idempotencyKey = idempotencyKey;
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (offerId != null) result.offerId = offerId;
    if (commandContext != null) result.commandContext = commandContext;
    return result;
  }

  OfferServiceActivateRequest._();

  factory OfferServiceActivateRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      OfferServiceActivateRequest()..mergeFromBuffer(data, registry);
  factory OfferServiceActivateRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      OfferServiceActivateRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'OfferServiceActivateRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: OfferServiceActivateRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'idempotencyKey')
    ..aOS(2, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(3, _omitFieldNames ? '' : 'offerId')
    ..aOM<$2.CommandContext>(4, _omitFieldNames ? '' : 'commandContext',
        subBuilder: $2.CommandContext.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OfferServiceActivateRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OfferServiceActivateRequest copyWith(
          void Function(OfferServiceActivateRequest) updates) =>
      super.copyWith(
              (message) => updates(message as OfferServiceActivateRequest))
          as OfferServiceActivateRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use OfferServiceActivateRequest() / OfferServiceActivateRequest.new instead')
  static OfferServiceActivateRequest create() =>
      OfferServiceActivateRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      OfferServiceActivateRequest._();
  @$core.override
  OfferServiceActivateRequest createEmptyInstance() =>
      OfferServiceActivateRequest._();
  @$core.pragma('dart2js:noInline')
  static OfferServiceActivateRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<OfferServiceActivateRequest>(
          OfferServiceActivateRequest.$_createMessage);
  static OfferServiceActivateRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get idempotencyKey => $_getSZ(0);
  @$pb.TagNumber(1)
  set idempotencyKey($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasIdempotencyKey() => $_has(0);
  @$pb.TagNumber(1)
  void clearIdempotencyKey() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get workspaceId => $_getSZ(1);
  @$pb.TagNumber(2)
  set workspaceId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasWorkspaceId() => $_has(1);
  @$pb.TagNumber(2)
  void clearWorkspaceId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get offerId => $_getSZ(2);
  @$pb.TagNumber(3)
  set offerId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasOfferId() => $_has(2);
  @$pb.TagNumber(3)
  void clearOfferId() => $_clearField(3);

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

class OfferServiceActivateResponse extends $pb.GeneratedMessage {
  factory OfferServiceActivateResponse({
    $core.String? id,
    $core.String? lifecycleState,
    $1.Timestamp? activatedAt,
    $core.String? activatedBy,
    $1.Timestamp? expiresAt,
    Offer? offer,
  }) {
    final result = OfferServiceActivateResponse._();
    if (id != null) result.id = id;
    if (lifecycleState != null) result.lifecycleState = lifecycleState;
    if (activatedAt != null) result.activatedAt = activatedAt;
    if (activatedBy != null) result.activatedBy = activatedBy;
    if (expiresAt != null) result.expiresAt = expiresAt;
    if (offer != null) result.offer = offer;
    return result;
  }

  OfferServiceActivateResponse._();

  factory OfferServiceActivateResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      OfferServiceActivateResponse()..mergeFromBuffer(data, registry);
  factory OfferServiceActivateResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      OfferServiceActivateResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'OfferServiceActivateResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: OfferServiceActivateResponse.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'lifecycleState')
    ..aOM<$1.Timestamp>(3, _omitFieldNames ? '' : 'activatedAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..aOS(4, _omitFieldNames ? '' : 'activatedBy')
    ..aOM<$1.Timestamp>(5, _omitFieldNames ? '' : 'expiresAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..aOM<Offer>(6, _omitFieldNames ? '' : 'offer',
        subBuilder: Offer.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OfferServiceActivateResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OfferServiceActivateResponse copyWith(
          void Function(OfferServiceActivateResponse) updates) =>
      super.copyWith(
              (message) => updates(message as OfferServiceActivateResponse))
          as OfferServiceActivateResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use OfferServiceActivateResponse() / OfferServiceActivateResponse.new instead')
  static OfferServiceActivateResponse create() =>
      OfferServiceActivateResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      OfferServiceActivateResponse._();
  @$core.override
  OfferServiceActivateResponse createEmptyInstance() =>
      OfferServiceActivateResponse._();
  @$core.pragma('dart2js:noInline')
  static OfferServiceActivateResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<OfferServiceActivateResponse>(
          OfferServiceActivateResponse.$_createMessage);
  static OfferServiceActivateResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get lifecycleState => $_getSZ(1);
  @$pb.TagNumber(2)
  set lifecycleState($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasLifecycleState() => $_has(1);
  @$pb.TagNumber(2)
  void clearLifecycleState() => $_clearField(2);

  @$pb.TagNumber(3)
  $1.Timestamp get activatedAt => $_getN(2);
  @$pb.TagNumber(3)
  set activatedAt($1.Timestamp value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasActivatedAt() => $_has(2);
  @$pb.TagNumber(3)
  void clearActivatedAt() => $_clearField(3);
  @$pb.TagNumber(3)
  $1.Timestamp ensureActivatedAt() => $_ensure(2);

  @$pb.TagNumber(4)
  $core.String get activatedBy => $_getSZ(3);
  @$pb.TagNumber(4)
  set activatedBy($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasActivatedBy() => $_has(3);
  @$pb.TagNumber(4)
  void clearActivatedBy() => $_clearField(4);

  @$pb.TagNumber(5)
  $1.Timestamp get expiresAt => $_getN(4);
  @$pb.TagNumber(5)
  set expiresAt($1.Timestamp value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasExpiresAt() => $_has(4);
  @$pb.TagNumber(5)
  void clearExpiresAt() => $_clearField(5);
  @$pb.TagNumber(5)
  $1.Timestamp ensureExpiresAt() => $_ensure(4);

  @$pb.TagNumber(6)
  Offer get offer => $_getN(5);
  @$pb.TagNumber(6)
  set offer(Offer value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasOffer() => $_has(5);
  @$pb.TagNumber(6)
  void clearOffer() => $_clearField(6);
  @$pb.TagNumber(6)
  Offer ensureOffer() => $_ensure(5);
}

class OfferServicePauseRequest extends $pb.GeneratedMessage {
  factory OfferServicePauseRequest({
    $core.String? workspaceId,
    $core.String? offerId,
    $2.CommandContext? commandContext,
  }) {
    final result = OfferServicePauseRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (offerId != null) result.offerId = offerId;
    if (commandContext != null) result.commandContext = commandContext;
    return result;
  }

  OfferServicePauseRequest._();

  factory OfferServicePauseRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      OfferServicePauseRequest()..mergeFromBuffer(data, registry);
  factory OfferServicePauseRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      OfferServicePauseRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'OfferServicePauseRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: OfferServicePauseRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'offerId')
    ..aOM<$2.CommandContext>(3, _omitFieldNames ? '' : 'commandContext',
        subBuilder: $2.CommandContext.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OfferServicePauseRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OfferServicePauseRequest copyWith(
          void Function(OfferServicePauseRequest) updates) =>
      super.copyWith((message) => updates(message as OfferServicePauseRequest))
          as OfferServicePauseRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use OfferServicePauseRequest() / OfferServicePauseRequest.new instead')
  static OfferServicePauseRequest create() => OfferServicePauseRequest._();
  static $pb.GeneratedMessage $_createMessage() => OfferServicePauseRequest._();
  @$core.override
  OfferServicePauseRequest createEmptyInstance() =>
      OfferServicePauseRequest._();
  @$core.pragma('dart2js:noInline')
  static OfferServicePauseRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<OfferServicePauseRequest>(
          OfferServicePauseRequest.$_createMessage);
  static OfferServicePauseRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get offerId => $_getSZ(1);
  @$pb.TagNumber(2)
  set offerId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasOfferId() => $_has(1);
  @$pb.TagNumber(2)
  void clearOfferId() => $_clearField(2);

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

class OfferServicePauseResponse extends $pb.GeneratedMessage {
  factory OfferServicePauseResponse({
    Offer? offer,
  }) {
    final result = OfferServicePauseResponse._();
    if (offer != null) result.offer = offer;
    return result;
  }

  OfferServicePauseResponse._();

  factory OfferServicePauseResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      OfferServicePauseResponse()..mergeFromBuffer(data, registry);
  factory OfferServicePauseResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      OfferServicePauseResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'OfferServicePauseResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: OfferServicePauseResponse.$_createMessage)
    ..aOM<Offer>(1, _omitFieldNames ? '' : 'offer',
        subBuilder: Offer.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OfferServicePauseResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OfferServicePauseResponse copyWith(
          void Function(OfferServicePauseResponse) updates) =>
      super.copyWith((message) => updates(message as OfferServicePauseResponse))
          as OfferServicePauseResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use OfferServicePauseResponse() / OfferServicePauseResponse.new instead')
  static OfferServicePauseResponse create() => OfferServicePauseResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      OfferServicePauseResponse._();
  @$core.override
  OfferServicePauseResponse createEmptyInstance() =>
      OfferServicePauseResponse._();
  @$core.pragma('dart2js:noInline')
  static OfferServicePauseResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<OfferServicePauseResponse>(
          OfferServicePauseResponse.$_createMessage);
  static OfferServicePauseResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Offer get offer => $_getN(0);
  @$pb.TagNumber(1)
  set offer(Offer value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasOffer() => $_has(0);
  @$pb.TagNumber(1)
  void clearOffer() => $_clearField(1);
  @$pb.TagNumber(1)
  Offer ensureOffer() => $_ensure(0);
}

class OfferServiceResumeRequest extends $pb.GeneratedMessage {
  factory OfferServiceResumeRequest({
    $core.String? workspaceId,
    $core.String? offerId,
    $2.CommandContext? commandContext,
  }) {
    final result = OfferServiceResumeRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (offerId != null) result.offerId = offerId;
    if (commandContext != null) result.commandContext = commandContext;
    return result;
  }

  OfferServiceResumeRequest._();

  factory OfferServiceResumeRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      OfferServiceResumeRequest()..mergeFromBuffer(data, registry);
  factory OfferServiceResumeRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      OfferServiceResumeRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'OfferServiceResumeRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: OfferServiceResumeRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'offerId')
    ..aOM<$2.CommandContext>(3, _omitFieldNames ? '' : 'commandContext',
        subBuilder: $2.CommandContext.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OfferServiceResumeRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OfferServiceResumeRequest copyWith(
          void Function(OfferServiceResumeRequest) updates) =>
      super.copyWith((message) => updates(message as OfferServiceResumeRequest))
          as OfferServiceResumeRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use OfferServiceResumeRequest() / OfferServiceResumeRequest.new instead')
  static OfferServiceResumeRequest create() => OfferServiceResumeRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      OfferServiceResumeRequest._();
  @$core.override
  OfferServiceResumeRequest createEmptyInstance() =>
      OfferServiceResumeRequest._();
  @$core.pragma('dart2js:noInline')
  static OfferServiceResumeRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<OfferServiceResumeRequest>(
          OfferServiceResumeRequest.$_createMessage);
  static OfferServiceResumeRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get offerId => $_getSZ(1);
  @$pb.TagNumber(2)
  set offerId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasOfferId() => $_has(1);
  @$pb.TagNumber(2)
  void clearOfferId() => $_clearField(2);

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

class OfferServiceResumeResponse extends $pb.GeneratedMessage {
  factory OfferServiceResumeResponse({
    Offer? offer,
  }) {
    final result = OfferServiceResumeResponse._();
    if (offer != null) result.offer = offer;
    return result;
  }

  OfferServiceResumeResponse._();

  factory OfferServiceResumeResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      OfferServiceResumeResponse()..mergeFromBuffer(data, registry);
  factory OfferServiceResumeResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      OfferServiceResumeResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'OfferServiceResumeResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: OfferServiceResumeResponse.$_createMessage)
    ..aOM<Offer>(1, _omitFieldNames ? '' : 'offer',
        subBuilder: Offer.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OfferServiceResumeResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OfferServiceResumeResponse copyWith(
          void Function(OfferServiceResumeResponse) updates) =>
      super.copyWith(
              (message) => updates(message as OfferServiceResumeResponse))
          as OfferServiceResumeResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use OfferServiceResumeResponse() / OfferServiceResumeResponse.new instead')
  static OfferServiceResumeResponse create() => OfferServiceResumeResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      OfferServiceResumeResponse._();
  @$core.override
  OfferServiceResumeResponse createEmptyInstance() =>
      OfferServiceResumeResponse._();
  @$core.pragma('dart2js:noInline')
  static OfferServiceResumeResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<OfferServiceResumeResponse>(
          OfferServiceResumeResponse.$_createMessage);
  static OfferServiceResumeResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Offer get offer => $_getN(0);
  @$pb.TagNumber(1)
  set offer(Offer value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasOffer() => $_has(0);
  @$pb.TagNumber(1)
  void clearOffer() => $_clearField(1);
  @$pb.TagNumber(1)
  Offer ensureOffer() => $_ensure(0);
}

class OfferServiceExpireRequest extends $pb.GeneratedMessage {
  factory OfferServiceExpireRequest({
    $core.String? workspaceId,
    $core.String? offerId,
    $2.CommandContext? commandContext,
  }) {
    final result = OfferServiceExpireRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (offerId != null) result.offerId = offerId;
    if (commandContext != null) result.commandContext = commandContext;
    return result;
  }

  OfferServiceExpireRequest._();

  factory OfferServiceExpireRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      OfferServiceExpireRequest()..mergeFromBuffer(data, registry);
  factory OfferServiceExpireRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      OfferServiceExpireRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'OfferServiceExpireRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: OfferServiceExpireRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'offerId')
    ..aOM<$2.CommandContext>(3, _omitFieldNames ? '' : 'commandContext',
        subBuilder: $2.CommandContext.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OfferServiceExpireRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OfferServiceExpireRequest copyWith(
          void Function(OfferServiceExpireRequest) updates) =>
      super.copyWith((message) => updates(message as OfferServiceExpireRequest))
          as OfferServiceExpireRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use OfferServiceExpireRequest() / OfferServiceExpireRequest.new instead')
  static OfferServiceExpireRequest create() => OfferServiceExpireRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      OfferServiceExpireRequest._();
  @$core.override
  OfferServiceExpireRequest createEmptyInstance() =>
      OfferServiceExpireRequest._();
  @$core.pragma('dart2js:noInline')
  static OfferServiceExpireRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<OfferServiceExpireRequest>(
          OfferServiceExpireRequest.$_createMessage);
  static OfferServiceExpireRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get offerId => $_getSZ(1);
  @$pb.TagNumber(2)
  set offerId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasOfferId() => $_has(1);
  @$pb.TagNumber(2)
  void clearOfferId() => $_clearField(2);

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

class OfferServiceExpireResponse extends $pb.GeneratedMessage {
  factory OfferServiceExpireResponse({
    Offer? offer,
  }) {
    final result = OfferServiceExpireResponse._();
    if (offer != null) result.offer = offer;
    return result;
  }

  OfferServiceExpireResponse._();

  factory OfferServiceExpireResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      OfferServiceExpireResponse()..mergeFromBuffer(data, registry);
  factory OfferServiceExpireResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      OfferServiceExpireResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'OfferServiceExpireResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: OfferServiceExpireResponse.$_createMessage)
    ..aOM<Offer>(1, _omitFieldNames ? '' : 'offer',
        subBuilder: Offer.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OfferServiceExpireResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OfferServiceExpireResponse copyWith(
          void Function(OfferServiceExpireResponse) updates) =>
      super.copyWith(
              (message) => updates(message as OfferServiceExpireResponse))
          as OfferServiceExpireResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use OfferServiceExpireResponse() / OfferServiceExpireResponse.new instead')
  static OfferServiceExpireResponse create() => OfferServiceExpireResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      OfferServiceExpireResponse._();
  @$core.override
  OfferServiceExpireResponse createEmptyInstance() =>
      OfferServiceExpireResponse._();
  @$core.pragma('dart2js:noInline')
  static OfferServiceExpireResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<OfferServiceExpireResponse>(
          OfferServiceExpireResponse.$_createMessage);
  static OfferServiceExpireResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Offer get offer => $_getN(0);
  @$pb.TagNumber(1)
  set offer(Offer value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasOffer() => $_has(0);
  @$pb.TagNumber(1)
  void clearOffer() => $_clearField(1);
  @$pb.TagNumber(1)
  Offer ensureOffer() => $_ensure(0);
}

class OfferServiceRetireRequest extends $pb.GeneratedMessage {
  factory OfferServiceRetireRequest({
    $core.String? workspaceId,
    $core.String? offerId,
    $2.CommandContext? commandContext,
  }) {
    final result = OfferServiceRetireRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (offerId != null) result.offerId = offerId;
    if (commandContext != null) result.commandContext = commandContext;
    return result;
  }

  OfferServiceRetireRequest._();

  factory OfferServiceRetireRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      OfferServiceRetireRequest()..mergeFromBuffer(data, registry);
  factory OfferServiceRetireRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      OfferServiceRetireRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'OfferServiceRetireRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: OfferServiceRetireRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'offerId')
    ..aOM<$2.CommandContext>(3, _omitFieldNames ? '' : 'commandContext',
        subBuilder: $2.CommandContext.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OfferServiceRetireRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OfferServiceRetireRequest copyWith(
          void Function(OfferServiceRetireRequest) updates) =>
      super.copyWith((message) => updates(message as OfferServiceRetireRequest))
          as OfferServiceRetireRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use OfferServiceRetireRequest() / OfferServiceRetireRequest.new instead')
  static OfferServiceRetireRequest create() => OfferServiceRetireRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      OfferServiceRetireRequest._();
  @$core.override
  OfferServiceRetireRequest createEmptyInstance() =>
      OfferServiceRetireRequest._();
  @$core.pragma('dart2js:noInline')
  static OfferServiceRetireRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<OfferServiceRetireRequest>(
          OfferServiceRetireRequest.$_createMessage);
  static OfferServiceRetireRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get offerId => $_getSZ(1);
  @$pb.TagNumber(2)
  set offerId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasOfferId() => $_has(1);
  @$pb.TagNumber(2)
  void clearOfferId() => $_clearField(2);

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

class OfferServiceRetireResponse extends $pb.GeneratedMessage {
  factory OfferServiceRetireResponse({
    Offer? offer,
  }) {
    final result = OfferServiceRetireResponse._();
    if (offer != null) result.offer = offer;
    return result;
  }

  OfferServiceRetireResponse._();

  factory OfferServiceRetireResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      OfferServiceRetireResponse()..mergeFromBuffer(data, registry);
  factory OfferServiceRetireResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      OfferServiceRetireResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'OfferServiceRetireResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: OfferServiceRetireResponse.$_createMessage)
    ..aOM<Offer>(1, _omitFieldNames ? '' : 'offer',
        subBuilder: Offer.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OfferServiceRetireResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OfferServiceRetireResponse copyWith(
          void Function(OfferServiceRetireResponse) updates) =>
      super.copyWith(
              (message) => updates(message as OfferServiceRetireResponse))
          as OfferServiceRetireResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use OfferServiceRetireResponse() / OfferServiceRetireResponse.new instead')
  static OfferServiceRetireResponse create() => OfferServiceRetireResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      OfferServiceRetireResponse._();
  @$core.override
  OfferServiceRetireResponse createEmptyInstance() =>
      OfferServiceRetireResponse._();
  @$core.pragma('dart2js:noInline')
  static OfferServiceRetireResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<OfferServiceRetireResponse>(
          OfferServiceRetireResponse.$_createMessage);
  static OfferServiceRetireResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Offer get offer => $_getN(0);
  @$pb.TagNumber(1)
  set offer(Offer value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasOffer() => $_has(0);
  @$pb.TagNumber(1)
  void clearOffer() => $_clearField(1);
  @$pb.TagNumber(1)
  Offer ensureOffer() => $_ensure(0);
}

class OfferServiceDuplicateRequest extends $pb.GeneratedMessage {
  factory OfferServiceDuplicateRequest({
    $core.String? workspaceId,
    $core.String? offerId,
    $core.String? newTitle,
    $2.CommandContext? commandContext,
  }) {
    final result = OfferServiceDuplicateRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (offerId != null) result.offerId = offerId;
    if (newTitle != null) result.newTitle = newTitle;
    if (commandContext != null) result.commandContext = commandContext;
    return result;
  }

  OfferServiceDuplicateRequest._();

  factory OfferServiceDuplicateRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      OfferServiceDuplicateRequest()..mergeFromBuffer(data, registry);
  factory OfferServiceDuplicateRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      OfferServiceDuplicateRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'OfferServiceDuplicateRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: OfferServiceDuplicateRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'offerId')
    ..aOS(3, _omitFieldNames ? '' : 'newTitle')
    ..aOM<$2.CommandContext>(4, _omitFieldNames ? '' : 'commandContext',
        subBuilder: $2.CommandContext.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OfferServiceDuplicateRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OfferServiceDuplicateRequest copyWith(
          void Function(OfferServiceDuplicateRequest) updates) =>
      super.copyWith(
              (message) => updates(message as OfferServiceDuplicateRequest))
          as OfferServiceDuplicateRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use OfferServiceDuplicateRequest() / OfferServiceDuplicateRequest.new instead')
  static OfferServiceDuplicateRequest create() =>
      OfferServiceDuplicateRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      OfferServiceDuplicateRequest._();
  @$core.override
  OfferServiceDuplicateRequest createEmptyInstance() =>
      OfferServiceDuplicateRequest._();
  @$core.pragma('dart2js:noInline')
  static OfferServiceDuplicateRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<OfferServiceDuplicateRequest>(
          OfferServiceDuplicateRequest.$_createMessage);
  static OfferServiceDuplicateRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get offerId => $_getSZ(1);
  @$pb.TagNumber(2)
  set offerId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasOfferId() => $_has(1);
  @$pb.TagNumber(2)
  void clearOfferId() => $_clearField(2);

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

class OfferServiceDuplicateResponse extends $pb.GeneratedMessage {
  factory OfferServiceDuplicateResponse({
    Offer? offer,
  }) {
    final result = OfferServiceDuplicateResponse._();
    if (offer != null) result.offer = offer;
    return result;
  }

  OfferServiceDuplicateResponse._();

  factory OfferServiceDuplicateResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      OfferServiceDuplicateResponse()..mergeFromBuffer(data, registry);
  factory OfferServiceDuplicateResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      OfferServiceDuplicateResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'OfferServiceDuplicateResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: OfferServiceDuplicateResponse.$_createMessage)
    ..aOM<Offer>(1, _omitFieldNames ? '' : 'offer',
        subBuilder: Offer.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OfferServiceDuplicateResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OfferServiceDuplicateResponse copyWith(
          void Function(OfferServiceDuplicateResponse) updates) =>
      super.copyWith(
              (message) => updates(message as OfferServiceDuplicateResponse))
          as OfferServiceDuplicateResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use OfferServiceDuplicateResponse() / OfferServiceDuplicateResponse.new instead')
  static OfferServiceDuplicateResponse create() =>
      OfferServiceDuplicateResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      OfferServiceDuplicateResponse._();
  @$core.override
  OfferServiceDuplicateResponse createEmptyInstance() =>
      OfferServiceDuplicateResponse._();
  @$core.pragma('dart2js:noInline')
  static OfferServiceDuplicateResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<OfferServiceDuplicateResponse>(
          OfferServiceDuplicateResponse.$_createMessage);
  static OfferServiceDuplicateResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Offer get offer => $_getN(0);
  @$pb.TagNumber(1)
  set offer(Offer value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasOffer() => $_has(0);
  @$pb.TagNumber(1)
  void clearOffer() => $_clearField(1);
  @$pb.TagNumber(1)
  Offer ensureOffer() => $_ensure(0);
}

class OfferServiceDeleteRequest extends $pb.GeneratedMessage {
  factory OfferServiceDeleteRequest({
    $core.String? workspaceId,
    $core.String? offerId,
    $2.CommandContext? commandContext,
  }) {
    final result = OfferServiceDeleteRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (offerId != null) result.offerId = offerId;
    if (commandContext != null) result.commandContext = commandContext;
    return result;
  }

  OfferServiceDeleteRequest._();

  factory OfferServiceDeleteRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      OfferServiceDeleteRequest()..mergeFromBuffer(data, registry);
  factory OfferServiceDeleteRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      OfferServiceDeleteRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'OfferServiceDeleteRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: OfferServiceDeleteRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'offerId')
    ..aOM<$2.CommandContext>(3, _omitFieldNames ? '' : 'commandContext',
        subBuilder: $2.CommandContext.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OfferServiceDeleteRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OfferServiceDeleteRequest copyWith(
          void Function(OfferServiceDeleteRequest) updates) =>
      super.copyWith((message) => updates(message as OfferServiceDeleteRequest))
          as OfferServiceDeleteRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use OfferServiceDeleteRequest() / OfferServiceDeleteRequest.new instead')
  static OfferServiceDeleteRequest create() => OfferServiceDeleteRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      OfferServiceDeleteRequest._();
  @$core.override
  OfferServiceDeleteRequest createEmptyInstance() =>
      OfferServiceDeleteRequest._();
  @$core.pragma('dart2js:noInline')
  static OfferServiceDeleteRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<OfferServiceDeleteRequest>(
          OfferServiceDeleteRequest.$_createMessage);
  static OfferServiceDeleteRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get offerId => $_getSZ(1);
  @$pb.TagNumber(2)
  set offerId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasOfferId() => $_has(1);
  @$pb.TagNumber(2)
  void clearOfferId() => $_clearField(2);

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

class OfferServiceDeleteResponse extends $pb.GeneratedMessage {
  factory OfferServiceDeleteResponse({
    $core.bool? success,
  }) {
    final result = OfferServiceDeleteResponse._();
    if (success != null) result.success = success;
    return result;
  }

  OfferServiceDeleteResponse._();

  factory OfferServiceDeleteResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      OfferServiceDeleteResponse()..mergeFromBuffer(data, registry);
  factory OfferServiceDeleteResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      OfferServiceDeleteResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'OfferServiceDeleteResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: OfferServiceDeleteResponse.$_createMessage)
    ..aOB(1, _omitFieldNames ? '' : 'success')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OfferServiceDeleteResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OfferServiceDeleteResponse copyWith(
          void Function(OfferServiceDeleteResponse) updates) =>
      super.copyWith(
              (message) => updates(message as OfferServiceDeleteResponse))
          as OfferServiceDeleteResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use OfferServiceDeleteResponse() / OfferServiceDeleteResponse.new instead')
  static OfferServiceDeleteResponse create() => OfferServiceDeleteResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      OfferServiceDeleteResponse._();
  @$core.override
  OfferServiceDeleteResponse createEmptyInstance() =>
      OfferServiceDeleteResponse._();
  @$core.pragma('dart2js:noInline')
  static OfferServiceDeleteResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<OfferServiceDeleteResponse>(
          OfferServiceDeleteResponse.$_createMessage);
  static OfferServiceDeleteResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get success => $_getBF(0);
  @$pb.TagNumber(1)
  set success($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSuccess() => $_has(0);
  @$pb.TagNumber(1)
  void clearSuccess() => $_clearField(1);
}

class OfferServiceBulkPauseRequest extends $pb.GeneratedMessage {
  factory OfferServiceBulkPauseRequest({
    $core.String? workspaceId,
    $core.Iterable<$core.String>? offerIds,
    $2.CommandContext? commandContext,
  }) {
    final result = OfferServiceBulkPauseRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (offerIds != null) result.offerIds.addAll(offerIds);
    if (commandContext != null) result.commandContext = commandContext;
    return result;
  }

  OfferServiceBulkPauseRequest._();

  factory OfferServiceBulkPauseRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      OfferServiceBulkPauseRequest()..mergeFromBuffer(data, registry);
  factory OfferServiceBulkPauseRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      OfferServiceBulkPauseRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'OfferServiceBulkPauseRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: OfferServiceBulkPauseRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..pPS(2, _omitFieldNames ? '' : 'offerIds')
    ..aOM<$2.CommandContext>(3, _omitFieldNames ? '' : 'commandContext',
        subBuilder: $2.CommandContext.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OfferServiceBulkPauseRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OfferServiceBulkPauseRequest copyWith(
          void Function(OfferServiceBulkPauseRequest) updates) =>
      super.copyWith(
              (message) => updates(message as OfferServiceBulkPauseRequest))
          as OfferServiceBulkPauseRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use OfferServiceBulkPauseRequest() / OfferServiceBulkPauseRequest.new instead')
  static OfferServiceBulkPauseRequest create() =>
      OfferServiceBulkPauseRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      OfferServiceBulkPauseRequest._();
  @$core.override
  OfferServiceBulkPauseRequest createEmptyInstance() =>
      OfferServiceBulkPauseRequest._();
  @$core.pragma('dart2js:noInline')
  static OfferServiceBulkPauseRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<OfferServiceBulkPauseRequest>(
          OfferServiceBulkPauseRequest.$_createMessage);
  static OfferServiceBulkPauseRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbList<$core.String> get offerIds => $_getList(1);

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

class OfferServiceBulkPauseResponse extends $pb.GeneratedMessage {
  factory OfferServiceBulkPauseResponse({
    $core.int? pausedCount,
  }) {
    final result = OfferServiceBulkPauseResponse._();
    if (pausedCount != null) result.pausedCount = pausedCount;
    return result;
  }

  OfferServiceBulkPauseResponse._();

  factory OfferServiceBulkPauseResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      OfferServiceBulkPauseResponse()..mergeFromBuffer(data, registry);
  factory OfferServiceBulkPauseResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      OfferServiceBulkPauseResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'OfferServiceBulkPauseResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: OfferServiceBulkPauseResponse.$_createMessage)
    ..aI(1, _omitFieldNames ? '' : 'pausedCount')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OfferServiceBulkPauseResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OfferServiceBulkPauseResponse copyWith(
          void Function(OfferServiceBulkPauseResponse) updates) =>
      super.copyWith(
              (message) => updates(message as OfferServiceBulkPauseResponse))
          as OfferServiceBulkPauseResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use OfferServiceBulkPauseResponse() / OfferServiceBulkPauseResponse.new instead')
  static OfferServiceBulkPauseResponse create() =>
      OfferServiceBulkPauseResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      OfferServiceBulkPauseResponse._();
  @$core.override
  OfferServiceBulkPauseResponse createEmptyInstance() =>
      OfferServiceBulkPauseResponse._();
  @$core.pragma('dart2js:noInline')
  static OfferServiceBulkPauseResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<OfferServiceBulkPauseResponse>(
          OfferServiceBulkPauseResponse.$_createMessage);
  static OfferServiceBulkPauseResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get pausedCount => $_getIZ(0);
  @$pb.TagNumber(1)
  set pausedCount($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPausedCount() => $_has(0);
  @$pb.TagNumber(1)
  void clearPausedCount() => $_clearField(1);
}

class OfferServiceGetPerformanceRequest extends $pb.GeneratedMessage {
  factory OfferServiceGetPerformanceRequest({
    $core.String? workspaceId,
    $core.String? offerId,
  }) {
    final result = OfferServiceGetPerformanceRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (offerId != null) result.offerId = offerId;
    return result;
  }

  OfferServiceGetPerformanceRequest._();

  factory OfferServiceGetPerformanceRequest.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      OfferServiceGetPerformanceRequest()..mergeFromBuffer(data, registry);
  factory OfferServiceGetPerformanceRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      OfferServiceGetPerformanceRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'OfferServiceGetPerformanceRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: OfferServiceGetPerformanceRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'offerId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OfferServiceGetPerformanceRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OfferServiceGetPerformanceRequest copyWith(
          void Function(OfferServiceGetPerformanceRequest) updates) =>
      super.copyWith((message) =>
              updates(message as OfferServiceGetPerformanceRequest))
          as OfferServiceGetPerformanceRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use OfferServiceGetPerformanceRequest() / OfferServiceGetPerformanceRequest.new instead')
  static OfferServiceGetPerformanceRequest create() =>
      OfferServiceGetPerformanceRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      OfferServiceGetPerformanceRequest._();
  @$core.override
  OfferServiceGetPerformanceRequest createEmptyInstance() =>
      OfferServiceGetPerformanceRequest._();
  @$core.pragma('dart2js:noInline')
  static OfferServiceGetPerformanceRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<OfferServiceGetPerformanceRequest>(
          OfferServiceGetPerformanceRequest.$_createMessage);
  static OfferServiceGetPerformanceRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get offerId => $_getSZ(1);
  @$pb.TagNumber(2)
  set offerId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasOfferId() => $_has(1);
  @$pb.TagNumber(2)
  void clearOfferId() => $_clearField(2);
}

class OfferServiceGetPerformanceResponse extends $pb.GeneratedMessage {
  factory OfferServiceGetPerformanceResponse({
    $core.String? offerId,
    $fixnum.Int64? impressions,
    $fixnum.Int64? clicks,
    $fixnum.Int64? conversions,
    $core.String? conversionRate,
    $core.String? grossRevenue,
    $core.String? currency,
  }) {
    final result = OfferServiceGetPerformanceResponse._();
    if (offerId != null) result.offerId = offerId;
    if (impressions != null) result.impressions = impressions;
    if (clicks != null) result.clicks = clicks;
    if (conversions != null) result.conversions = conversions;
    if (conversionRate != null) result.conversionRate = conversionRate;
    if (grossRevenue != null) result.grossRevenue = grossRevenue;
    if (currency != null) result.currency = currency;
    return result;
  }

  OfferServiceGetPerformanceResponse._();

  factory OfferServiceGetPerformanceResponse.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      OfferServiceGetPerformanceResponse()..mergeFromBuffer(data, registry);
  factory OfferServiceGetPerformanceResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      OfferServiceGetPerformanceResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'OfferServiceGetPerformanceResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: OfferServiceGetPerformanceResponse.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'offerId')
    ..aInt64(2, _omitFieldNames ? '' : 'impressions')
    ..aInt64(3, _omitFieldNames ? '' : 'clicks')
    ..aInt64(4, _omitFieldNames ? '' : 'conversions')
    ..aOS(5, _omitFieldNames ? '' : 'conversionRate')
    ..aOS(6, _omitFieldNames ? '' : 'grossRevenue')
    ..aOS(7, _omitFieldNames ? '' : 'currency')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OfferServiceGetPerformanceResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OfferServiceGetPerformanceResponse copyWith(
          void Function(OfferServiceGetPerformanceResponse) updates) =>
      super.copyWith((message) =>
              updates(message as OfferServiceGetPerformanceResponse))
          as OfferServiceGetPerformanceResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use OfferServiceGetPerformanceResponse() / OfferServiceGetPerformanceResponse.new instead')
  static OfferServiceGetPerformanceResponse create() =>
      OfferServiceGetPerformanceResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      OfferServiceGetPerformanceResponse._();
  @$core.override
  OfferServiceGetPerformanceResponse createEmptyInstance() =>
      OfferServiceGetPerformanceResponse._();
  @$core.pragma('dart2js:noInline')
  static OfferServiceGetPerformanceResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<OfferServiceGetPerformanceResponse>(
          OfferServiceGetPerformanceResponse.$_createMessage);
  static OfferServiceGetPerformanceResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get offerId => $_getSZ(0);
  @$pb.TagNumber(1)
  set offerId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasOfferId() => $_has(0);
  @$pb.TagNumber(1)
  void clearOfferId() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get impressions => $_getI64(1);
  @$pb.TagNumber(2)
  set impressions($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasImpressions() => $_has(1);
  @$pb.TagNumber(2)
  void clearImpressions() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get clicks => $_getI64(2);
  @$pb.TagNumber(3)
  set clicks($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasClicks() => $_has(2);
  @$pb.TagNumber(3)
  void clearClicks() => $_clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get conversions => $_getI64(3);
  @$pb.TagNumber(4)
  set conversions($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasConversions() => $_has(3);
  @$pb.TagNumber(4)
  void clearConversions() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get conversionRate => $_getSZ(4);
  @$pb.TagNumber(5)
  set conversionRate($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasConversionRate() => $_has(4);
  @$pb.TagNumber(5)
  void clearConversionRate() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get grossRevenue => $_getSZ(5);
  @$pb.TagNumber(6)
  set grossRevenue($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasGrossRevenue() => $_has(5);
  @$pb.TagNumber(6)
  void clearGrossRevenue() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get currency => $_getSZ(6);
  @$pb.TagNumber(7)
  set currency($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasCurrency() => $_has(6);
  @$pb.TagNumber(7)
  void clearCurrency() => $_clearField(7);
}

class OfferServiceGetRedemptionStatsRequest extends $pb.GeneratedMessage {
  factory OfferServiceGetRedemptionStatsRequest({
    $core.String? workspaceId,
    $core.String? offerId,
  }) {
    final result = OfferServiceGetRedemptionStatsRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (offerId != null) result.offerId = offerId;
    return result;
  }

  OfferServiceGetRedemptionStatsRequest._();

  factory OfferServiceGetRedemptionStatsRequest.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      OfferServiceGetRedemptionStatsRequest()..mergeFromBuffer(data, registry);
  factory OfferServiceGetRedemptionStatsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      OfferServiceGetRedemptionStatsRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'OfferServiceGetRedemptionStatsRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance:
          OfferServiceGetRedemptionStatsRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'offerId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OfferServiceGetRedemptionStatsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OfferServiceGetRedemptionStatsRequest copyWith(
          void Function(OfferServiceGetRedemptionStatsRequest) updates) =>
      super.copyWith((message) =>
              updates(message as OfferServiceGetRedemptionStatsRequest))
          as OfferServiceGetRedemptionStatsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use OfferServiceGetRedemptionStatsRequest() / OfferServiceGetRedemptionStatsRequest.new instead')
  static OfferServiceGetRedemptionStatsRequest create() =>
      OfferServiceGetRedemptionStatsRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      OfferServiceGetRedemptionStatsRequest._();
  @$core.override
  OfferServiceGetRedemptionStatsRequest createEmptyInstance() =>
      OfferServiceGetRedemptionStatsRequest._();
  @$core.pragma('dart2js:noInline')
  static OfferServiceGetRedemptionStatsRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
              OfferServiceGetRedemptionStatsRequest>(
          OfferServiceGetRedemptionStatsRequest.$_createMessage);
  static OfferServiceGetRedemptionStatsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get offerId => $_getSZ(1);
  @$pb.TagNumber(2)
  set offerId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasOfferId() => $_has(1);
  @$pb.TagNumber(2)
  void clearOfferId() => $_clearField(2);
}

class OfferServiceGetRedemptionStatsResponse extends $pb.GeneratedMessage {
  factory OfferServiceGetRedemptionStatsResponse({
    $core.String? offerId,
    $fixnum.Int64? totalRedemptions,
    $core.String? totalDiscountAmount,
    $core.String? currency,
  }) {
    final result = OfferServiceGetRedemptionStatsResponse._();
    if (offerId != null) result.offerId = offerId;
    if (totalRedemptions != null) result.totalRedemptions = totalRedemptions;
    if (totalDiscountAmount != null)
      result.totalDiscountAmount = totalDiscountAmount;
    if (currency != null) result.currency = currency;
    return result;
  }

  OfferServiceGetRedemptionStatsResponse._();

  factory OfferServiceGetRedemptionStatsResponse.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      OfferServiceGetRedemptionStatsResponse()..mergeFromBuffer(data, registry);
  factory OfferServiceGetRedemptionStatsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      OfferServiceGetRedemptionStatsResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'OfferServiceGetRedemptionStatsResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance:
          OfferServiceGetRedemptionStatsResponse.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'offerId')
    ..aInt64(2, _omitFieldNames ? '' : 'totalRedemptions')
    ..aOS(3, _omitFieldNames ? '' : 'totalDiscountAmount')
    ..aOS(4, _omitFieldNames ? '' : 'currency')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OfferServiceGetRedemptionStatsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OfferServiceGetRedemptionStatsResponse copyWith(
          void Function(OfferServiceGetRedemptionStatsResponse) updates) =>
      super.copyWith((message) =>
              updates(message as OfferServiceGetRedemptionStatsResponse))
          as OfferServiceGetRedemptionStatsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use OfferServiceGetRedemptionStatsResponse() / OfferServiceGetRedemptionStatsResponse.new instead')
  static OfferServiceGetRedemptionStatsResponse create() =>
      OfferServiceGetRedemptionStatsResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      OfferServiceGetRedemptionStatsResponse._();
  @$core.override
  OfferServiceGetRedemptionStatsResponse createEmptyInstance() =>
      OfferServiceGetRedemptionStatsResponse._();
  @$core.pragma('dart2js:noInline')
  static OfferServiceGetRedemptionStatsResponse getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
              OfferServiceGetRedemptionStatsResponse>(
          OfferServiceGetRedemptionStatsResponse.$_createMessage);
  static OfferServiceGetRedemptionStatsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get offerId => $_getSZ(0);
  @$pb.TagNumber(1)
  set offerId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasOfferId() => $_has(0);
  @$pb.TagNumber(1)
  void clearOfferId() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get totalRedemptions => $_getI64(1);
  @$pb.TagNumber(2)
  set totalRedemptions($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTotalRedemptions() => $_has(1);
  @$pb.TagNumber(2)
  void clearTotalRedemptions() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get totalDiscountAmount => $_getSZ(2);
  @$pb.TagNumber(3)
  set totalDiscountAmount($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasTotalDiscountAmount() => $_has(2);
  @$pb.TagNumber(3)
  void clearTotalDiscountAmount() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get currency => $_getSZ(3);
  @$pb.TagNumber(4)
  set currency($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasCurrency() => $_has(3);
  @$pb.TagNumber(4)
  void clearCurrency() => $_clearField(4);
}

class OfferServiceGetStatusCountsRequest extends $pb.GeneratedMessage {
  factory OfferServiceGetStatusCountsRequest({
    $core.String? workspaceId,
  }) {
    final result = OfferServiceGetStatusCountsRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    return result;
  }

  OfferServiceGetStatusCountsRequest._();

  factory OfferServiceGetStatusCountsRequest.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      OfferServiceGetStatusCountsRequest()..mergeFromBuffer(data, registry);
  factory OfferServiceGetStatusCountsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      OfferServiceGetStatusCountsRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'OfferServiceGetStatusCountsRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: OfferServiceGetStatusCountsRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OfferServiceGetStatusCountsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OfferServiceGetStatusCountsRequest copyWith(
          void Function(OfferServiceGetStatusCountsRequest) updates) =>
      super.copyWith((message) =>
              updates(message as OfferServiceGetStatusCountsRequest))
          as OfferServiceGetStatusCountsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use OfferServiceGetStatusCountsRequest() / OfferServiceGetStatusCountsRequest.new instead')
  static OfferServiceGetStatusCountsRequest create() =>
      OfferServiceGetStatusCountsRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      OfferServiceGetStatusCountsRequest._();
  @$core.override
  OfferServiceGetStatusCountsRequest createEmptyInstance() =>
      OfferServiceGetStatusCountsRequest._();
  @$core.pragma('dart2js:noInline')
  static OfferServiceGetStatusCountsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<OfferServiceGetStatusCountsRequest>(
          OfferServiceGetStatusCountsRequest.$_createMessage);
  static OfferServiceGetStatusCountsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);
}

class OfferServiceGetStatusCountsResponse extends $pb.GeneratedMessage {
  factory OfferServiceGetStatusCountsResponse({
    $core.int? draftCount,
    $core.int? reviewRequiredCount,
    $core.int? activeCount,
    $core.int? pausedCount,
    $core.int? expiredCount,
    $core.int? retiredCount,
  }) {
    final result = OfferServiceGetStatusCountsResponse._();
    if (draftCount != null) result.draftCount = draftCount;
    if (reviewRequiredCount != null)
      result.reviewRequiredCount = reviewRequiredCount;
    if (activeCount != null) result.activeCount = activeCount;
    if (pausedCount != null) result.pausedCount = pausedCount;
    if (expiredCount != null) result.expiredCount = expiredCount;
    if (retiredCount != null) result.retiredCount = retiredCount;
    return result;
  }

  OfferServiceGetStatusCountsResponse._();

  factory OfferServiceGetStatusCountsResponse.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      OfferServiceGetStatusCountsResponse()..mergeFromBuffer(data, registry);
  factory OfferServiceGetStatusCountsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      OfferServiceGetStatusCountsResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'OfferServiceGetStatusCountsResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: OfferServiceGetStatusCountsResponse.$_createMessage)
    ..aI(1, _omitFieldNames ? '' : 'draftCount')
    ..aI(2, _omitFieldNames ? '' : 'reviewRequiredCount')
    ..aI(3, _omitFieldNames ? '' : 'activeCount')
    ..aI(4, _omitFieldNames ? '' : 'pausedCount')
    ..aI(5, _omitFieldNames ? '' : 'expiredCount')
    ..aI(6, _omitFieldNames ? '' : 'retiredCount')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OfferServiceGetStatusCountsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OfferServiceGetStatusCountsResponse copyWith(
          void Function(OfferServiceGetStatusCountsResponse) updates) =>
      super.copyWith((message) =>
              updates(message as OfferServiceGetStatusCountsResponse))
          as OfferServiceGetStatusCountsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use OfferServiceGetStatusCountsResponse() / OfferServiceGetStatusCountsResponse.new instead')
  static OfferServiceGetStatusCountsResponse create() =>
      OfferServiceGetStatusCountsResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      OfferServiceGetStatusCountsResponse._();
  @$core.override
  OfferServiceGetStatusCountsResponse createEmptyInstance() =>
      OfferServiceGetStatusCountsResponse._();
  @$core.pragma('dart2js:noInline')
  static OfferServiceGetStatusCountsResponse getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
              OfferServiceGetStatusCountsResponse>(
          OfferServiceGetStatusCountsResponse.$_createMessage);
  static OfferServiceGetStatusCountsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get draftCount => $_getIZ(0);
  @$pb.TagNumber(1)
  set draftCount($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasDraftCount() => $_has(0);
  @$pb.TagNumber(1)
  void clearDraftCount() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get reviewRequiredCount => $_getIZ(1);
  @$pb.TagNumber(2)
  set reviewRequiredCount($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasReviewRequiredCount() => $_has(1);
  @$pb.TagNumber(2)
  void clearReviewRequiredCount() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get activeCount => $_getIZ(2);
  @$pb.TagNumber(3)
  set activeCount($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasActiveCount() => $_has(2);
  @$pb.TagNumber(3)
  void clearActiveCount() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get pausedCount => $_getIZ(3);
  @$pb.TagNumber(4)
  set pausedCount($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasPausedCount() => $_has(3);
  @$pb.TagNumber(4)
  void clearPausedCount() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get expiredCount => $_getIZ(4);
  @$pb.TagNumber(5)
  set expiredCount($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasExpiredCount() => $_has(4);
  @$pb.TagNumber(5)
  void clearExpiredCount() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.int get retiredCount => $_getIZ(5);
  @$pb.TagNumber(6)
  set retiredCount($core.int value) => $_setSignedInt32(5, value);
  @$pb.TagNumber(6)
  $core.bool hasRetiredCount() => $_has(5);
  @$pb.TagNumber(6)
  void clearRetiredCount() => $_clearField(6);
}

class OfferServiceGetTabSummaryRequest extends $pb.GeneratedMessage {
  factory OfferServiceGetTabSummaryRequest({
    $core.String? workspaceId,
  }) {
    final result = OfferServiceGetTabSummaryRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    return result;
  }

  OfferServiceGetTabSummaryRequest._();

  factory OfferServiceGetTabSummaryRequest.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      OfferServiceGetTabSummaryRequest()..mergeFromBuffer(data, registry);
  factory OfferServiceGetTabSummaryRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      OfferServiceGetTabSummaryRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'OfferServiceGetTabSummaryRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: OfferServiceGetTabSummaryRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OfferServiceGetTabSummaryRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OfferServiceGetTabSummaryRequest copyWith(
          void Function(OfferServiceGetTabSummaryRequest) updates) =>
      super.copyWith(
              (message) => updates(message as OfferServiceGetTabSummaryRequest))
          as OfferServiceGetTabSummaryRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use OfferServiceGetTabSummaryRequest() / OfferServiceGetTabSummaryRequest.new instead')
  static OfferServiceGetTabSummaryRequest create() =>
      OfferServiceGetTabSummaryRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      OfferServiceGetTabSummaryRequest._();
  @$core.override
  OfferServiceGetTabSummaryRequest createEmptyInstance() =>
      OfferServiceGetTabSummaryRequest._();
  @$core.pragma('dart2js:noInline')
  static OfferServiceGetTabSummaryRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<OfferServiceGetTabSummaryRequest>(
          OfferServiceGetTabSummaryRequest.$_createMessage);
  static OfferServiceGetTabSummaryRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);
}

class OfferServiceGetTabSummaryResponse extends $pb.GeneratedMessage {
  factory OfferServiceGetTabSummaryResponse({
    $core.int? activeOffers,
    $core.int? pendingReview,
    $core.int? expiringSoon,
  }) {
    final result = OfferServiceGetTabSummaryResponse._();
    if (activeOffers != null) result.activeOffers = activeOffers;
    if (pendingReview != null) result.pendingReview = pendingReview;
    if (expiringSoon != null) result.expiringSoon = expiringSoon;
    return result;
  }

  OfferServiceGetTabSummaryResponse._();

  factory OfferServiceGetTabSummaryResponse.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      OfferServiceGetTabSummaryResponse()..mergeFromBuffer(data, registry);
  factory OfferServiceGetTabSummaryResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      OfferServiceGetTabSummaryResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'OfferServiceGetTabSummaryResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: OfferServiceGetTabSummaryResponse.$_createMessage)
    ..aI(1, _omitFieldNames ? '' : 'activeOffers')
    ..aI(2, _omitFieldNames ? '' : 'pendingReview')
    ..aI(3, _omitFieldNames ? '' : 'expiringSoon')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OfferServiceGetTabSummaryResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OfferServiceGetTabSummaryResponse copyWith(
          void Function(OfferServiceGetTabSummaryResponse) updates) =>
      super.copyWith((message) =>
              updates(message as OfferServiceGetTabSummaryResponse))
          as OfferServiceGetTabSummaryResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use OfferServiceGetTabSummaryResponse() / OfferServiceGetTabSummaryResponse.new instead')
  static OfferServiceGetTabSummaryResponse create() =>
      OfferServiceGetTabSummaryResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      OfferServiceGetTabSummaryResponse._();
  @$core.override
  OfferServiceGetTabSummaryResponse createEmptyInstance() =>
      OfferServiceGetTabSummaryResponse._();
  @$core.pragma('dart2js:noInline')
  static OfferServiceGetTabSummaryResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<OfferServiceGetTabSummaryResponse>(
          OfferServiceGetTabSummaryResponse.$_createMessage);
  static OfferServiceGetTabSummaryResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get activeOffers => $_getIZ(0);
  @$pb.TagNumber(1)
  set activeOffers($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasActiveOffers() => $_has(0);
  @$pb.TagNumber(1)
  void clearActiveOffers() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get pendingReview => $_getIZ(1);
  @$pb.TagNumber(2)
  set pendingReview($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPendingReview() => $_has(1);
  @$pb.TagNumber(2)
  void clearPendingReview() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get expiringSoon => $_getIZ(2);
  @$pb.TagNumber(3)
  set expiringSoon($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasExpiringSoon() => $_has(2);
  @$pb.TagNumber(3)
  void clearExpiringSoon() => $_clearField(3);
}

/// Coupon Service Requests/Responses
class CouponServiceCreateRequest extends $pb.GeneratedMessage {
  factory CouponServiceCreateRequest({
    $core.String? workspaceId,
    $core.String? code,
    CouponType? couponType,
    $core.String? discountValue,
    $core.String? minOrderAmount,
    $core.int? maxUses,
    $core.Iterable<$core.String>? relatedOfferIds,
    $core.Iterable<$core.String>? relatedCampaignIds,
    $1.Timestamp? validFrom,
    $1.Timestamp? validUntil,
    $2.CommandContext? commandContext,
  }) {
    final result = CouponServiceCreateRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (code != null) result.code = code;
    if (couponType != null) result.couponType = couponType;
    if (discountValue != null) result.discountValue = discountValue;
    if (minOrderAmount != null) result.minOrderAmount = minOrderAmount;
    if (maxUses != null) result.maxUses = maxUses;
    if (relatedOfferIds != null) result.relatedOfferIds.addAll(relatedOfferIds);
    if (relatedCampaignIds != null)
      result.relatedCampaignIds.addAll(relatedCampaignIds);
    if (validFrom != null) result.validFrom = validFrom;
    if (validUntil != null) result.validUntil = validUntil;
    if (commandContext != null) result.commandContext = commandContext;
    return result;
  }

  CouponServiceCreateRequest._();

  factory CouponServiceCreateRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CouponServiceCreateRequest()..mergeFromBuffer(data, registry);
  factory CouponServiceCreateRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CouponServiceCreateRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CouponServiceCreateRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: CouponServiceCreateRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'code')
    ..aE<CouponType>(3, _omitFieldNames ? '' : 'couponType',
        enumValues: CouponType.values)
    ..aOS(4, _omitFieldNames ? '' : 'discountValue')
    ..aOS(5, _omitFieldNames ? '' : 'minOrderAmount')
    ..aI(6, _omitFieldNames ? '' : 'maxUses')
    ..pPS(7, _omitFieldNames ? '' : 'relatedOfferIds')
    ..pPS(8, _omitFieldNames ? '' : 'relatedCampaignIds')
    ..aOM<$1.Timestamp>(9, _omitFieldNames ? '' : 'validFrom',
        subBuilder: $1.Timestamp.$_createMessage)
    ..aOM<$1.Timestamp>(10, _omitFieldNames ? '' : 'validUntil',
        subBuilder: $1.Timestamp.$_createMessage)
    ..aOM<$2.CommandContext>(11, _omitFieldNames ? '' : 'commandContext',
        subBuilder: $2.CommandContext.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CouponServiceCreateRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CouponServiceCreateRequest copyWith(
          void Function(CouponServiceCreateRequest) updates) =>
      super.copyWith(
              (message) => updates(message as CouponServiceCreateRequest))
          as CouponServiceCreateRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use CouponServiceCreateRequest() / CouponServiceCreateRequest.new instead')
  static CouponServiceCreateRequest create() => CouponServiceCreateRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      CouponServiceCreateRequest._();
  @$core.override
  CouponServiceCreateRequest createEmptyInstance() =>
      CouponServiceCreateRequest._();
  @$core.pragma('dart2js:noInline')
  static CouponServiceCreateRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CouponServiceCreateRequest>(
          CouponServiceCreateRequest.$_createMessage);
  static CouponServiceCreateRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get code => $_getSZ(1);
  @$pb.TagNumber(2)
  set code($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCode() => $_has(1);
  @$pb.TagNumber(2)
  void clearCode() => $_clearField(2);

  @$pb.TagNumber(3)
  CouponType get couponType => $_getN(2);
  @$pb.TagNumber(3)
  set couponType(CouponType value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasCouponType() => $_has(2);
  @$pb.TagNumber(3)
  void clearCouponType() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get discountValue => $_getSZ(3);
  @$pb.TagNumber(4)
  set discountValue($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasDiscountValue() => $_has(3);
  @$pb.TagNumber(4)
  void clearDiscountValue() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get minOrderAmount => $_getSZ(4);
  @$pb.TagNumber(5)
  set minOrderAmount($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasMinOrderAmount() => $_has(4);
  @$pb.TagNumber(5)
  void clearMinOrderAmount() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.int get maxUses => $_getIZ(5);
  @$pb.TagNumber(6)
  set maxUses($core.int value) => $_setSignedInt32(5, value);
  @$pb.TagNumber(6)
  $core.bool hasMaxUses() => $_has(5);
  @$pb.TagNumber(6)
  void clearMaxUses() => $_clearField(6);

  @$pb.TagNumber(7)
  $pb.PbList<$core.String> get relatedOfferIds => $_getList(6);

  @$pb.TagNumber(8)
  $pb.PbList<$core.String> get relatedCampaignIds => $_getList(7);

  @$pb.TagNumber(9)
  $1.Timestamp get validFrom => $_getN(8);
  @$pb.TagNumber(9)
  set validFrom($1.Timestamp value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasValidFrom() => $_has(8);
  @$pb.TagNumber(9)
  void clearValidFrom() => $_clearField(9);
  @$pb.TagNumber(9)
  $1.Timestamp ensureValidFrom() => $_ensure(8);

  @$pb.TagNumber(10)
  $1.Timestamp get validUntil => $_getN(9);
  @$pb.TagNumber(10)
  set validUntil($1.Timestamp value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasValidUntil() => $_has(9);
  @$pb.TagNumber(10)
  void clearValidUntil() => $_clearField(10);
  @$pb.TagNumber(10)
  $1.Timestamp ensureValidUntil() => $_ensure(9);

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

class CouponServiceCreateResponse extends $pb.GeneratedMessage {
  factory CouponServiceCreateResponse({
    Coupon? coupon,
  }) {
    final result = CouponServiceCreateResponse._();
    if (coupon != null) result.coupon = coupon;
    return result;
  }

  CouponServiceCreateResponse._();

  factory CouponServiceCreateResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CouponServiceCreateResponse()..mergeFromBuffer(data, registry);
  factory CouponServiceCreateResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CouponServiceCreateResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CouponServiceCreateResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: CouponServiceCreateResponse.$_createMessage)
    ..aOM<Coupon>(1, _omitFieldNames ? '' : 'coupon',
        subBuilder: Coupon.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CouponServiceCreateResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CouponServiceCreateResponse copyWith(
          void Function(CouponServiceCreateResponse) updates) =>
      super.copyWith(
              (message) => updates(message as CouponServiceCreateResponse))
          as CouponServiceCreateResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use CouponServiceCreateResponse() / CouponServiceCreateResponse.new instead')
  static CouponServiceCreateResponse create() =>
      CouponServiceCreateResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      CouponServiceCreateResponse._();
  @$core.override
  CouponServiceCreateResponse createEmptyInstance() =>
      CouponServiceCreateResponse._();
  @$core.pragma('dart2js:noInline')
  static CouponServiceCreateResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CouponServiceCreateResponse>(
          CouponServiceCreateResponse.$_createMessage);
  static CouponServiceCreateResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Coupon get coupon => $_getN(0);
  @$pb.TagNumber(1)
  set coupon(Coupon value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasCoupon() => $_has(0);
  @$pb.TagNumber(1)
  void clearCoupon() => $_clearField(1);
  @$pb.TagNumber(1)
  Coupon ensureCoupon() => $_ensure(0);
}

class CouponServiceGetRequest extends $pb.GeneratedMessage {
  factory CouponServiceGetRequest({
    $core.String? workspaceId,
    $core.String? couponId,
  }) {
    final result = CouponServiceGetRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (couponId != null) result.couponId = couponId;
    return result;
  }

  CouponServiceGetRequest._();

  factory CouponServiceGetRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CouponServiceGetRequest()..mergeFromBuffer(data, registry);
  factory CouponServiceGetRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CouponServiceGetRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CouponServiceGetRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: CouponServiceGetRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'couponId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CouponServiceGetRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CouponServiceGetRequest copyWith(
          void Function(CouponServiceGetRequest) updates) =>
      super.copyWith((message) => updates(message as CouponServiceGetRequest))
          as CouponServiceGetRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use CouponServiceGetRequest() / CouponServiceGetRequest.new instead')
  static CouponServiceGetRequest create() => CouponServiceGetRequest._();
  static $pb.GeneratedMessage $_createMessage() => CouponServiceGetRequest._();
  @$core.override
  CouponServiceGetRequest createEmptyInstance() => CouponServiceGetRequest._();
  @$core.pragma('dart2js:noInline')
  static CouponServiceGetRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CouponServiceGetRequest>(
          CouponServiceGetRequest.$_createMessage);
  static CouponServiceGetRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get couponId => $_getSZ(1);
  @$pb.TagNumber(2)
  set couponId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCouponId() => $_has(1);
  @$pb.TagNumber(2)
  void clearCouponId() => $_clearField(2);
}

class CouponServiceGetResponse extends $pb.GeneratedMessage {
  factory CouponServiceGetResponse({
    Coupon? coupon,
  }) {
    final result = CouponServiceGetResponse._();
    if (coupon != null) result.coupon = coupon;
    return result;
  }

  CouponServiceGetResponse._();

  factory CouponServiceGetResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CouponServiceGetResponse()..mergeFromBuffer(data, registry);
  factory CouponServiceGetResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CouponServiceGetResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CouponServiceGetResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: CouponServiceGetResponse.$_createMessage)
    ..aOM<Coupon>(1, _omitFieldNames ? '' : 'coupon',
        subBuilder: Coupon.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CouponServiceGetResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CouponServiceGetResponse copyWith(
          void Function(CouponServiceGetResponse) updates) =>
      super.copyWith((message) => updates(message as CouponServiceGetResponse))
          as CouponServiceGetResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use CouponServiceGetResponse() / CouponServiceGetResponse.new instead')
  static CouponServiceGetResponse create() => CouponServiceGetResponse._();
  static $pb.GeneratedMessage $_createMessage() => CouponServiceGetResponse._();
  @$core.override
  CouponServiceGetResponse createEmptyInstance() =>
      CouponServiceGetResponse._();
  @$core.pragma('dart2js:noInline')
  static CouponServiceGetResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CouponServiceGetResponse>(
          CouponServiceGetResponse.$_createMessage);
  static CouponServiceGetResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Coupon get coupon => $_getN(0);
  @$pb.TagNumber(1)
  set coupon(Coupon value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasCoupon() => $_has(0);
  @$pb.TagNumber(1)
  void clearCoupon() => $_clearField(1);
  @$pb.TagNumber(1)
  Coupon ensureCoupon() => $_ensure(0);
}

class CouponServiceListRequest extends $pb.GeneratedMessage {
  factory CouponServiceListRequest({
    $core.String? workspaceId,
    CouponLifecycleState? status,
    $core.String? query,
    $core.int? pageSize,
    $core.String? pageToken,
  }) {
    final result = CouponServiceListRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (status != null) result.status = status;
    if (query != null) result.query = query;
    if (pageSize != null) result.pageSize = pageSize;
    if (pageToken != null) result.pageToken = pageToken;
    return result;
  }

  CouponServiceListRequest._();

  factory CouponServiceListRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CouponServiceListRequest()..mergeFromBuffer(data, registry);
  factory CouponServiceListRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CouponServiceListRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CouponServiceListRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: CouponServiceListRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aE<CouponLifecycleState>(2, _omitFieldNames ? '' : 'status',
        enumValues: CouponLifecycleState.values)
    ..aOS(3, _omitFieldNames ? '' : 'query')
    ..aI(4, _omitFieldNames ? '' : 'pageSize')
    ..aOS(5, _omitFieldNames ? '' : 'pageToken')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CouponServiceListRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CouponServiceListRequest copyWith(
          void Function(CouponServiceListRequest) updates) =>
      super.copyWith((message) => updates(message as CouponServiceListRequest))
          as CouponServiceListRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use CouponServiceListRequest() / CouponServiceListRequest.new instead')
  static CouponServiceListRequest create() => CouponServiceListRequest._();
  static $pb.GeneratedMessage $_createMessage() => CouponServiceListRequest._();
  @$core.override
  CouponServiceListRequest createEmptyInstance() =>
      CouponServiceListRequest._();
  @$core.pragma('dart2js:noInline')
  static CouponServiceListRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CouponServiceListRequest>(
          CouponServiceListRequest.$_createMessage);
  static CouponServiceListRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  CouponLifecycleState get status => $_getN(1);
  @$pb.TagNumber(2)
  set status(CouponLifecycleState value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasStatus() => $_has(1);
  @$pb.TagNumber(2)
  void clearStatus() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get query => $_getSZ(2);
  @$pb.TagNumber(3)
  set query($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasQuery() => $_has(2);
  @$pb.TagNumber(3)
  void clearQuery() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get pageSize => $_getIZ(3);
  @$pb.TagNumber(4)
  set pageSize($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasPageSize() => $_has(3);
  @$pb.TagNumber(4)
  void clearPageSize() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get pageToken => $_getSZ(4);
  @$pb.TagNumber(5)
  set pageToken($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasPageToken() => $_has(4);
  @$pb.TagNumber(5)
  void clearPageToken() => $_clearField(5);
}

class CouponServiceListResponse extends $pb.GeneratedMessage {
  factory CouponServiceListResponse({
    $core.Iterable<Coupon>? coupons,
    $core.String? nextPageToken,
    $core.int? totalCount,
  }) {
    final result = CouponServiceListResponse._();
    if (coupons != null) result.coupons.addAll(coupons);
    if (nextPageToken != null) result.nextPageToken = nextPageToken;
    if (totalCount != null) result.totalCount = totalCount;
    return result;
  }

  CouponServiceListResponse._();

  factory CouponServiceListResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CouponServiceListResponse()..mergeFromBuffer(data, registry);
  factory CouponServiceListResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CouponServiceListResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CouponServiceListResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: CouponServiceListResponse.$_createMessage)
    ..pPM<Coupon>(1, _omitFieldNames ? '' : 'coupons',
        subBuilder: Coupon.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'nextPageToken')
    ..aI(3, _omitFieldNames ? '' : 'totalCount')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CouponServiceListResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CouponServiceListResponse copyWith(
          void Function(CouponServiceListResponse) updates) =>
      super.copyWith((message) => updates(message as CouponServiceListResponse))
          as CouponServiceListResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use CouponServiceListResponse() / CouponServiceListResponse.new instead')
  static CouponServiceListResponse create() => CouponServiceListResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      CouponServiceListResponse._();
  @$core.override
  CouponServiceListResponse createEmptyInstance() =>
      CouponServiceListResponse._();
  @$core.pragma('dart2js:noInline')
  static CouponServiceListResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CouponServiceListResponse>(
          CouponServiceListResponse.$_createMessage);
  static CouponServiceListResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Coupon> get coupons => $_getList(0);

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

class OrderContext extends $pb.GeneratedMessage {
  factory OrderContext({
    $core.Iterable<$core.String>? productIds,
    $core.String? subtotal,
    $core.String? currency,
  }) {
    final result = OrderContext._();
    if (productIds != null) result.productIds.addAll(productIds);
    if (subtotal != null) result.subtotal = subtotal;
    if (currency != null) result.currency = currency;
    return result;
  }

  OrderContext._();

  factory OrderContext.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      OrderContext()..mergeFromBuffer(data, registry);
  factory OrderContext.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      OrderContext()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'OrderContext',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: OrderContext.$_createMessage)
    ..pPS(1, _omitFieldNames ? '' : 'productIds')
    ..aOS(2, _omitFieldNames ? '' : 'subtotal')
    ..aOS(3, _omitFieldNames ? '' : 'currency')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OrderContext clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OrderContext copyWith(void Function(OrderContext) updates) =>
      super.copyWith((message) => updates(message as OrderContext))
          as OrderContext;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use OrderContext() / OrderContext.new instead')
  static OrderContext create() => OrderContext._();
  static $pb.GeneratedMessage $_createMessage() => OrderContext._();
  @$core.override
  OrderContext createEmptyInstance() => OrderContext._();
  @$core.pragma('dart2js:noInline')
  static OrderContext getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<OrderContext>(
          OrderContext.$_createMessage);
  static OrderContext? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<$core.String> get productIds => $_getList(0);

  @$pb.TagNumber(2)
  $core.String get subtotal => $_getSZ(1);
  @$pb.TagNumber(2)
  set subtotal($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSubtotal() => $_has(1);
  @$pb.TagNumber(2)
  void clearSubtotal() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get currency => $_getSZ(2);
  @$pb.TagNumber(3)
  set currency($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasCurrency() => $_has(2);
  @$pb.TagNumber(3)
  void clearCurrency() => $_clearField(3);
}

class CouponServiceValidateCouponRequest extends $pb.GeneratedMessage {
  factory CouponServiceValidateCouponRequest({
    $core.String? workspaceId,
    $core.String? code,
    OrderContext? orderContext,
  }) {
    final result = CouponServiceValidateCouponRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (code != null) result.code = code;
    if (orderContext != null) result.orderContext = orderContext;
    return result;
  }

  CouponServiceValidateCouponRequest._();

  factory CouponServiceValidateCouponRequest.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CouponServiceValidateCouponRequest()..mergeFromBuffer(data, registry);
  factory CouponServiceValidateCouponRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CouponServiceValidateCouponRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CouponServiceValidateCouponRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: CouponServiceValidateCouponRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'code')
    ..aOM<OrderContext>(3, _omitFieldNames ? '' : 'orderContext',
        subBuilder: OrderContext.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CouponServiceValidateCouponRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CouponServiceValidateCouponRequest copyWith(
          void Function(CouponServiceValidateCouponRequest) updates) =>
      super.copyWith((message) =>
              updates(message as CouponServiceValidateCouponRequest))
          as CouponServiceValidateCouponRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use CouponServiceValidateCouponRequest() / CouponServiceValidateCouponRequest.new instead')
  static CouponServiceValidateCouponRequest create() =>
      CouponServiceValidateCouponRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      CouponServiceValidateCouponRequest._();
  @$core.override
  CouponServiceValidateCouponRequest createEmptyInstance() =>
      CouponServiceValidateCouponRequest._();
  @$core.pragma('dart2js:noInline')
  static CouponServiceValidateCouponRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CouponServiceValidateCouponRequest>(
          CouponServiceValidateCouponRequest.$_createMessage);
  static CouponServiceValidateCouponRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get code => $_getSZ(1);
  @$pb.TagNumber(2)
  set code($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCode() => $_has(1);
  @$pb.TagNumber(2)
  void clearCode() => $_clearField(2);

  @$pb.TagNumber(3)
  OrderContext get orderContext => $_getN(2);
  @$pb.TagNumber(3)
  set orderContext(OrderContext value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasOrderContext() => $_has(2);
  @$pb.TagNumber(3)
  void clearOrderContext() => $_clearField(3);
  @$pb.TagNumber(3)
  OrderContext ensureOrderContext() => $_ensure(2);
}

class CouponServiceValidateCouponResponse extends $pb.GeneratedMessage {
  factory CouponServiceValidateCouponResponse({
    $core.bool? valid,
    $core.String? couponId,
    $core.String? discountType,
    $core.String? discountValue,
    $core.String? maxDiscountAmount,
    $core.String? calculatedDiscount,
    $core.bool? stackable,
    $1.Timestamp? expiresAt,
    $core.int? remainingUses,
    $core.String? failureReason,
  }) {
    final result = CouponServiceValidateCouponResponse._();
    if (valid != null) result.valid = valid;
    if (couponId != null) result.couponId = couponId;
    if (discountType != null) result.discountType = discountType;
    if (discountValue != null) result.discountValue = discountValue;
    if (maxDiscountAmount != null) result.maxDiscountAmount = maxDiscountAmount;
    if (calculatedDiscount != null)
      result.calculatedDiscount = calculatedDiscount;
    if (stackable != null) result.stackable = stackable;
    if (expiresAt != null) result.expiresAt = expiresAt;
    if (remainingUses != null) result.remainingUses = remainingUses;
    if (failureReason != null) result.failureReason = failureReason;
    return result;
  }

  CouponServiceValidateCouponResponse._();

  factory CouponServiceValidateCouponResponse.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CouponServiceValidateCouponResponse()..mergeFromBuffer(data, registry);
  factory CouponServiceValidateCouponResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CouponServiceValidateCouponResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CouponServiceValidateCouponResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: CouponServiceValidateCouponResponse.$_createMessage)
    ..aOB(1, _omitFieldNames ? '' : 'valid')
    ..aOS(2, _omitFieldNames ? '' : 'couponId')
    ..aOS(3, _omitFieldNames ? '' : 'discountType')
    ..aOS(4, _omitFieldNames ? '' : 'discountValue')
    ..aOS(5, _omitFieldNames ? '' : 'maxDiscountAmount')
    ..aOS(6, _omitFieldNames ? '' : 'calculatedDiscount')
    ..aOB(7, _omitFieldNames ? '' : 'stackable')
    ..aOM<$1.Timestamp>(8, _omitFieldNames ? '' : 'expiresAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..aI(9, _omitFieldNames ? '' : 'remainingUses')
    ..aOS(10, _omitFieldNames ? '' : 'failureReason')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CouponServiceValidateCouponResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CouponServiceValidateCouponResponse copyWith(
          void Function(CouponServiceValidateCouponResponse) updates) =>
      super.copyWith((message) =>
              updates(message as CouponServiceValidateCouponResponse))
          as CouponServiceValidateCouponResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use CouponServiceValidateCouponResponse() / CouponServiceValidateCouponResponse.new instead')
  static CouponServiceValidateCouponResponse create() =>
      CouponServiceValidateCouponResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      CouponServiceValidateCouponResponse._();
  @$core.override
  CouponServiceValidateCouponResponse createEmptyInstance() =>
      CouponServiceValidateCouponResponse._();
  @$core.pragma('dart2js:noInline')
  static CouponServiceValidateCouponResponse getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
              CouponServiceValidateCouponResponse>(
          CouponServiceValidateCouponResponse.$_createMessage);
  static CouponServiceValidateCouponResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get valid => $_getBF(0);
  @$pb.TagNumber(1)
  set valid($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasValid() => $_has(0);
  @$pb.TagNumber(1)
  void clearValid() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get couponId => $_getSZ(1);
  @$pb.TagNumber(2)
  set couponId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCouponId() => $_has(1);
  @$pb.TagNumber(2)
  void clearCouponId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get discountType => $_getSZ(2);
  @$pb.TagNumber(3)
  set discountType($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasDiscountType() => $_has(2);
  @$pb.TagNumber(3)
  void clearDiscountType() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get discountValue => $_getSZ(3);
  @$pb.TagNumber(4)
  set discountValue($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasDiscountValue() => $_has(3);
  @$pb.TagNumber(4)
  void clearDiscountValue() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get maxDiscountAmount => $_getSZ(4);
  @$pb.TagNumber(5)
  set maxDiscountAmount($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasMaxDiscountAmount() => $_has(4);
  @$pb.TagNumber(5)
  void clearMaxDiscountAmount() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get calculatedDiscount => $_getSZ(5);
  @$pb.TagNumber(6)
  set calculatedDiscount($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasCalculatedDiscount() => $_has(5);
  @$pb.TagNumber(6)
  void clearCalculatedDiscount() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.bool get stackable => $_getBF(6);
  @$pb.TagNumber(7)
  set stackable($core.bool value) => $_setBool(6, value);
  @$pb.TagNumber(7)
  $core.bool hasStackable() => $_has(6);
  @$pb.TagNumber(7)
  void clearStackable() => $_clearField(7);

  @$pb.TagNumber(8)
  $1.Timestamp get expiresAt => $_getN(7);
  @$pb.TagNumber(8)
  set expiresAt($1.Timestamp value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasExpiresAt() => $_has(7);
  @$pb.TagNumber(8)
  void clearExpiresAt() => $_clearField(8);
  @$pb.TagNumber(8)
  $1.Timestamp ensureExpiresAt() => $_ensure(7);

  @$pb.TagNumber(9)
  $core.int get remainingUses => $_getIZ(8);
  @$pb.TagNumber(9)
  set remainingUses($core.int value) => $_setSignedInt32(8, value);
  @$pb.TagNumber(9)
  $core.bool hasRemainingUses() => $_has(8);
  @$pb.TagNumber(9)
  void clearRemainingUses() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.String get failureReason => $_getSZ(9);
  @$pb.TagNumber(10)
  set failureReason($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasFailureReason() => $_has(9);
  @$pb.TagNumber(10)
  void clearFailureReason() => $_clearField(10);
}

class CouponServiceUpdateRequest extends $pb.GeneratedMessage {
  factory CouponServiceUpdateRequest({
    $core.String? workspaceId,
    $core.String? couponId,
    $core.String? discountValue,
    $core.String? minOrderAmount,
    $core.int? maxUses,
    $1.Timestamp? validFrom,
    $1.Timestamp? validUntil,
    $2.CommandContext? commandContext,
  }) {
    final result = CouponServiceUpdateRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (couponId != null) result.couponId = couponId;
    if (discountValue != null) result.discountValue = discountValue;
    if (minOrderAmount != null) result.minOrderAmount = minOrderAmount;
    if (maxUses != null) result.maxUses = maxUses;
    if (validFrom != null) result.validFrom = validFrom;
    if (validUntil != null) result.validUntil = validUntil;
    if (commandContext != null) result.commandContext = commandContext;
    return result;
  }

  CouponServiceUpdateRequest._();

  factory CouponServiceUpdateRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CouponServiceUpdateRequest()..mergeFromBuffer(data, registry);
  factory CouponServiceUpdateRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CouponServiceUpdateRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CouponServiceUpdateRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: CouponServiceUpdateRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'couponId')
    ..aOS(3, _omitFieldNames ? '' : 'discountValue')
    ..aOS(4, _omitFieldNames ? '' : 'minOrderAmount')
    ..aI(5, _omitFieldNames ? '' : 'maxUses')
    ..aOM<$1.Timestamp>(6, _omitFieldNames ? '' : 'validFrom',
        subBuilder: $1.Timestamp.$_createMessage)
    ..aOM<$1.Timestamp>(7, _omitFieldNames ? '' : 'validUntil',
        subBuilder: $1.Timestamp.$_createMessage)
    ..aOM<$2.CommandContext>(8, _omitFieldNames ? '' : 'commandContext',
        subBuilder: $2.CommandContext.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CouponServiceUpdateRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CouponServiceUpdateRequest copyWith(
          void Function(CouponServiceUpdateRequest) updates) =>
      super.copyWith(
              (message) => updates(message as CouponServiceUpdateRequest))
          as CouponServiceUpdateRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use CouponServiceUpdateRequest() / CouponServiceUpdateRequest.new instead')
  static CouponServiceUpdateRequest create() => CouponServiceUpdateRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      CouponServiceUpdateRequest._();
  @$core.override
  CouponServiceUpdateRequest createEmptyInstance() =>
      CouponServiceUpdateRequest._();
  @$core.pragma('dart2js:noInline')
  static CouponServiceUpdateRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CouponServiceUpdateRequest>(
          CouponServiceUpdateRequest.$_createMessage);
  static CouponServiceUpdateRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get couponId => $_getSZ(1);
  @$pb.TagNumber(2)
  set couponId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCouponId() => $_has(1);
  @$pb.TagNumber(2)
  void clearCouponId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get discountValue => $_getSZ(2);
  @$pb.TagNumber(3)
  set discountValue($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasDiscountValue() => $_has(2);
  @$pb.TagNumber(3)
  void clearDiscountValue() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get minOrderAmount => $_getSZ(3);
  @$pb.TagNumber(4)
  set minOrderAmount($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasMinOrderAmount() => $_has(3);
  @$pb.TagNumber(4)
  void clearMinOrderAmount() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get maxUses => $_getIZ(4);
  @$pb.TagNumber(5)
  set maxUses($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasMaxUses() => $_has(4);
  @$pb.TagNumber(5)
  void clearMaxUses() => $_clearField(5);

  @$pb.TagNumber(6)
  $1.Timestamp get validFrom => $_getN(5);
  @$pb.TagNumber(6)
  set validFrom($1.Timestamp value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasValidFrom() => $_has(5);
  @$pb.TagNumber(6)
  void clearValidFrom() => $_clearField(6);
  @$pb.TagNumber(6)
  $1.Timestamp ensureValidFrom() => $_ensure(5);

  @$pb.TagNumber(7)
  $1.Timestamp get validUntil => $_getN(6);
  @$pb.TagNumber(7)
  set validUntil($1.Timestamp value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasValidUntil() => $_has(6);
  @$pb.TagNumber(7)
  void clearValidUntil() => $_clearField(7);
  @$pb.TagNumber(7)
  $1.Timestamp ensureValidUntil() => $_ensure(6);

  @$pb.TagNumber(8)
  $2.CommandContext get commandContext => $_getN(7);
  @$pb.TagNumber(8)
  set commandContext($2.CommandContext value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasCommandContext() => $_has(7);
  @$pb.TagNumber(8)
  void clearCommandContext() => $_clearField(8);
  @$pb.TagNumber(8)
  $2.CommandContext ensureCommandContext() => $_ensure(7);
}

class CouponServiceUpdateResponse extends $pb.GeneratedMessage {
  factory CouponServiceUpdateResponse({
    Coupon? coupon,
  }) {
    final result = CouponServiceUpdateResponse._();
    if (coupon != null) result.coupon = coupon;
    return result;
  }

  CouponServiceUpdateResponse._();

  factory CouponServiceUpdateResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CouponServiceUpdateResponse()..mergeFromBuffer(data, registry);
  factory CouponServiceUpdateResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CouponServiceUpdateResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CouponServiceUpdateResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: CouponServiceUpdateResponse.$_createMessage)
    ..aOM<Coupon>(1, _omitFieldNames ? '' : 'coupon',
        subBuilder: Coupon.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CouponServiceUpdateResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CouponServiceUpdateResponse copyWith(
          void Function(CouponServiceUpdateResponse) updates) =>
      super.copyWith(
              (message) => updates(message as CouponServiceUpdateResponse))
          as CouponServiceUpdateResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use CouponServiceUpdateResponse() / CouponServiceUpdateResponse.new instead')
  static CouponServiceUpdateResponse create() =>
      CouponServiceUpdateResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      CouponServiceUpdateResponse._();
  @$core.override
  CouponServiceUpdateResponse createEmptyInstance() =>
      CouponServiceUpdateResponse._();
  @$core.pragma('dart2js:noInline')
  static CouponServiceUpdateResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CouponServiceUpdateResponse>(
          CouponServiceUpdateResponse.$_createMessage);
  static CouponServiceUpdateResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Coupon get coupon => $_getN(0);
  @$pb.TagNumber(1)
  set coupon(Coupon value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasCoupon() => $_has(0);
  @$pb.TagNumber(1)
  void clearCoupon() => $_clearField(1);
  @$pb.TagNumber(1)
  Coupon ensureCoupon() => $_ensure(0);
}

class CouponServiceActivateRequest extends $pb.GeneratedMessage {
  factory CouponServiceActivateRequest({
    $core.String? workspaceId,
    $core.String? couponId,
    $2.CommandContext? commandContext,
  }) {
    final result = CouponServiceActivateRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (couponId != null) result.couponId = couponId;
    if (commandContext != null) result.commandContext = commandContext;
    return result;
  }

  CouponServiceActivateRequest._();

  factory CouponServiceActivateRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CouponServiceActivateRequest()..mergeFromBuffer(data, registry);
  factory CouponServiceActivateRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CouponServiceActivateRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CouponServiceActivateRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: CouponServiceActivateRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'couponId')
    ..aOM<$2.CommandContext>(3, _omitFieldNames ? '' : 'commandContext',
        subBuilder: $2.CommandContext.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CouponServiceActivateRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CouponServiceActivateRequest copyWith(
          void Function(CouponServiceActivateRequest) updates) =>
      super.copyWith(
              (message) => updates(message as CouponServiceActivateRequest))
          as CouponServiceActivateRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use CouponServiceActivateRequest() / CouponServiceActivateRequest.new instead')
  static CouponServiceActivateRequest create() =>
      CouponServiceActivateRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      CouponServiceActivateRequest._();
  @$core.override
  CouponServiceActivateRequest createEmptyInstance() =>
      CouponServiceActivateRequest._();
  @$core.pragma('dart2js:noInline')
  static CouponServiceActivateRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CouponServiceActivateRequest>(
          CouponServiceActivateRequest.$_createMessage);
  static CouponServiceActivateRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get couponId => $_getSZ(1);
  @$pb.TagNumber(2)
  set couponId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCouponId() => $_has(1);
  @$pb.TagNumber(2)
  void clearCouponId() => $_clearField(2);

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

class CouponServiceActivateResponse extends $pb.GeneratedMessage {
  factory CouponServiceActivateResponse({
    Coupon? coupon,
  }) {
    final result = CouponServiceActivateResponse._();
    if (coupon != null) result.coupon = coupon;
    return result;
  }

  CouponServiceActivateResponse._();

  factory CouponServiceActivateResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CouponServiceActivateResponse()..mergeFromBuffer(data, registry);
  factory CouponServiceActivateResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CouponServiceActivateResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CouponServiceActivateResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: CouponServiceActivateResponse.$_createMessage)
    ..aOM<Coupon>(1, _omitFieldNames ? '' : 'coupon',
        subBuilder: Coupon.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CouponServiceActivateResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CouponServiceActivateResponse copyWith(
          void Function(CouponServiceActivateResponse) updates) =>
      super.copyWith(
              (message) => updates(message as CouponServiceActivateResponse))
          as CouponServiceActivateResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use CouponServiceActivateResponse() / CouponServiceActivateResponse.new instead')
  static CouponServiceActivateResponse create() =>
      CouponServiceActivateResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      CouponServiceActivateResponse._();
  @$core.override
  CouponServiceActivateResponse createEmptyInstance() =>
      CouponServiceActivateResponse._();
  @$core.pragma('dart2js:noInline')
  static CouponServiceActivateResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CouponServiceActivateResponse>(
          CouponServiceActivateResponse.$_createMessage);
  static CouponServiceActivateResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Coupon get coupon => $_getN(0);
  @$pb.TagNumber(1)
  set coupon(Coupon value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasCoupon() => $_has(0);
  @$pb.TagNumber(1)
  void clearCoupon() => $_clearField(1);
  @$pb.TagNumber(1)
  Coupon ensureCoupon() => $_ensure(0);
}

class CouponServicePauseRequest extends $pb.GeneratedMessage {
  factory CouponServicePauseRequest({
    $core.String? workspaceId,
    $core.String? couponId,
    $2.CommandContext? commandContext,
  }) {
    final result = CouponServicePauseRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (couponId != null) result.couponId = couponId;
    if (commandContext != null) result.commandContext = commandContext;
    return result;
  }

  CouponServicePauseRequest._();

  factory CouponServicePauseRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CouponServicePauseRequest()..mergeFromBuffer(data, registry);
  factory CouponServicePauseRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CouponServicePauseRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CouponServicePauseRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: CouponServicePauseRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'couponId')
    ..aOM<$2.CommandContext>(3, _omitFieldNames ? '' : 'commandContext',
        subBuilder: $2.CommandContext.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CouponServicePauseRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CouponServicePauseRequest copyWith(
          void Function(CouponServicePauseRequest) updates) =>
      super.copyWith((message) => updates(message as CouponServicePauseRequest))
          as CouponServicePauseRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use CouponServicePauseRequest() / CouponServicePauseRequest.new instead')
  static CouponServicePauseRequest create() => CouponServicePauseRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      CouponServicePauseRequest._();
  @$core.override
  CouponServicePauseRequest createEmptyInstance() =>
      CouponServicePauseRequest._();
  @$core.pragma('dart2js:noInline')
  static CouponServicePauseRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CouponServicePauseRequest>(
          CouponServicePauseRequest.$_createMessage);
  static CouponServicePauseRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get couponId => $_getSZ(1);
  @$pb.TagNumber(2)
  set couponId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCouponId() => $_has(1);
  @$pb.TagNumber(2)
  void clearCouponId() => $_clearField(2);

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

class CouponServicePauseResponse extends $pb.GeneratedMessage {
  factory CouponServicePauseResponse({
    Coupon? coupon,
  }) {
    final result = CouponServicePauseResponse._();
    if (coupon != null) result.coupon = coupon;
    return result;
  }

  CouponServicePauseResponse._();

  factory CouponServicePauseResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CouponServicePauseResponse()..mergeFromBuffer(data, registry);
  factory CouponServicePauseResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CouponServicePauseResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CouponServicePauseResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: CouponServicePauseResponse.$_createMessage)
    ..aOM<Coupon>(1, _omitFieldNames ? '' : 'coupon',
        subBuilder: Coupon.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CouponServicePauseResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CouponServicePauseResponse copyWith(
          void Function(CouponServicePauseResponse) updates) =>
      super.copyWith(
              (message) => updates(message as CouponServicePauseResponse))
          as CouponServicePauseResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use CouponServicePauseResponse() / CouponServicePauseResponse.new instead')
  static CouponServicePauseResponse create() => CouponServicePauseResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      CouponServicePauseResponse._();
  @$core.override
  CouponServicePauseResponse createEmptyInstance() =>
      CouponServicePauseResponse._();
  @$core.pragma('dart2js:noInline')
  static CouponServicePauseResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CouponServicePauseResponse>(
          CouponServicePauseResponse.$_createMessage);
  static CouponServicePauseResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Coupon get coupon => $_getN(0);
  @$pb.TagNumber(1)
  set coupon(Coupon value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasCoupon() => $_has(0);
  @$pb.TagNumber(1)
  void clearCoupon() => $_clearField(1);
  @$pb.TagNumber(1)
  Coupon ensureCoupon() => $_ensure(0);
}

class CouponServiceResumeRequest extends $pb.GeneratedMessage {
  factory CouponServiceResumeRequest({
    $core.String? workspaceId,
    $core.String? couponId,
    $2.CommandContext? commandContext,
  }) {
    final result = CouponServiceResumeRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (couponId != null) result.couponId = couponId;
    if (commandContext != null) result.commandContext = commandContext;
    return result;
  }

  CouponServiceResumeRequest._();

  factory CouponServiceResumeRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CouponServiceResumeRequest()..mergeFromBuffer(data, registry);
  factory CouponServiceResumeRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CouponServiceResumeRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CouponServiceResumeRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: CouponServiceResumeRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'couponId')
    ..aOM<$2.CommandContext>(3, _omitFieldNames ? '' : 'commandContext',
        subBuilder: $2.CommandContext.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CouponServiceResumeRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CouponServiceResumeRequest copyWith(
          void Function(CouponServiceResumeRequest) updates) =>
      super.copyWith(
              (message) => updates(message as CouponServiceResumeRequest))
          as CouponServiceResumeRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use CouponServiceResumeRequest() / CouponServiceResumeRequest.new instead')
  static CouponServiceResumeRequest create() => CouponServiceResumeRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      CouponServiceResumeRequest._();
  @$core.override
  CouponServiceResumeRequest createEmptyInstance() =>
      CouponServiceResumeRequest._();
  @$core.pragma('dart2js:noInline')
  static CouponServiceResumeRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CouponServiceResumeRequest>(
          CouponServiceResumeRequest.$_createMessage);
  static CouponServiceResumeRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get couponId => $_getSZ(1);
  @$pb.TagNumber(2)
  set couponId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCouponId() => $_has(1);
  @$pb.TagNumber(2)
  void clearCouponId() => $_clearField(2);

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

class CouponServiceResumeResponse extends $pb.GeneratedMessage {
  factory CouponServiceResumeResponse({
    Coupon? coupon,
  }) {
    final result = CouponServiceResumeResponse._();
    if (coupon != null) result.coupon = coupon;
    return result;
  }

  CouponServiceResumeResponse._();

  factory CouponServiceResumeResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CouponServiceResumeResponse()..mergeFromBuffer(data, registry);
  factory CouponServiceResumeResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CouponServiceResumeResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CouponServiceResumeResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: CouponServiceResumeResponse.$_createMessage)
    ..aOM<Coupon>(1, _omitFieldNames ? '' : 'coupon',
        subBuilder: Coupon.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CouponServiceResumeResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CouponServiceResumeResponse copyWith(
          void Function(CouponServiceResumeResponse) updates) =>
      super.copyWith(
              (message) => updates(message as CouponServiceResumeResponse))
          as CouponServiceResumeResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use CouponServiceResumeResponse() / CouponServiceResumeResponse.new instead')
  static CouponServiceResumeResponse create() =>
      CouponServiceResumeResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      CouponServiceResumeResponse._();
  @$core.override
  CouponServiceResumeResponse createEmptyInstance() =>
      CouponServiceResumeResponse._();
  @$core.pragma('dart2js:noInline')
  static CouponServiceResumeResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CouponServiceResumeResponse>(
          CouponServiceResumeResponse.$_createMessage);
  static CouponServiceResumeResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Coupon get coupon => $_getN(0);
  @$pb.TagNumber(1)
  set coupon(Coupon value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasCoupon() => $_has(0);
  @$pb.TagNumber(1)
  void clearCoupon() => $_clearField(1);
  @$pb.TagNumber(1)
  Coupon ensureCoupon() => $_ensure(0);
}

class CouponServiceDeactivateRequest extends $pb.GeneratedMessage {
  factory CouponServiceDeactivateRequest({
    $core.String? workspaceId,
    $core.String? couponId,
    $2.CommandContext? commandContext,
  }) {
    final result = CouponServiceDeactivateRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (couponId != null) result.couponId = couponId;
    if (commandContext != null) result.commandContext = commandContext;
    return result;
  }

  CouponServiceDeactivateRequest._();

  factory CouponServiceDeactivateRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CouponServiceDeactivateRequest()..mergeFromBuffer(data, registry);
  factory CouponServiceDeactivateRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CouponServiceDeactivateRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CouponServiceDeactivateRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: CouponServiceDeactivateRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'couponId')
    ..aOM<$2.CommandContext>(3, _omitFieldNames ? '' : 'commandContext',
        subBuilder: $2.CommandContext.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CouponServiceDeactivateRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CouponServiceDeactivateRequest copyWith(
          void Function(CouponServiceDeactivateRequest) updates) =>
      super.copyWith(
              (message) => updates(message as CouponServiceDeactivateRequest))
          as CouponServiceDeactivateRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use CouponServiceDeactivateRequest() / CouponServiceDeactivateRequest.new instead')
  static CouponServiceDeactivateRequest create() =>
      CouponServiceDeactivateRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      CouponServiceDeactivateRequest._();
  @$core.override
  CouponServiceDeactivateRequest createEmptyInstance() =>
      CouponServiceDeactivateRequest._();
  @$core.pragma('dart2js:noInline')
  static CouponServiceDeactivateRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CouponServiceDeactivateRequest>(
          CouponServiceDeactivateRequest.$_createMessage);
  static CouponServiceDeactivateRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get couponId => $_getSZ(1);
  @$pb.TagNumber(2)
  set couponId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCouponId() => $_has(1);
  @$pb.TagNumber(2)
  void clearCouponId() => $_clearField(2);

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

class CouponServiceDeactivateResponse extends $pb.GeneratedMessage {
  factory CouponServiceDeactivateResponse({
    Coupon? coupon,
  }) {
    final result = CouponServiceDeactivateResponse._();
    if (coupon != null) result.coupon = coupon;
    return result;
  }

  CouponServiceDeactivateResponse._();

  factory CouponServiceDeactivateResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CouponServiceDeactivateResponse()..mergeFromBuffer(data, registry);
  factory CouponServiceDeactivateResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CouponServiceDeactivateResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CouponServiceDeactivateResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: CouponServiceDeactivateResponse.$_createMessage)
    ..aOM<Coupon>(1, _omitFieldNames ? '' : 'coupon',
        subBuilder: Coupon.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CouponServiceDeactivateResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CouponServiceDeactivateResponse copyWith(
          void Function(CouponServiceDeactivateResponse) updates) =>
      super.copyWith(
              (message) => updates(message as CouponServiceDeactivateResponse))
          as CouponServiceDeactivateResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use CouponServiceDeactivateResponse() / CouponServiceDeactivateResponse.new instead')
  static CouponServiceDeactivateResponse create() =>
      CouponServiceDeactivateResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      CouponServiceDeactivateResponse._();
  @$core.override
  CouponServiceDeactivateResponse createEmptyInstance() =>
      CouponServiceDeactivateResponse._();
  @$core.pragma('dart2js:noInline')
  static CouponServiceDeactivateResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CouponServiceDeactivateResponse>(
          CouponServiceDeactivateResponse.$_createMessage);
  static CouponServiceDeactivateResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Coupon get coupon => $_getN(0);
  @$pb.TagNumber(1)
  set coupon(Coupon value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasCoupon() => $_has(0);
  @$pb.TagNumber(1)
  void clearCoupon() => $_clearField(1);
  @$pb.TagNumber(1)
  Coupon ensureCoupon() => $_ensure(0);
}

class CouponServiceRevokeRequest extends $pb.GeneratedMessage {
  factory CouponServiceRevokeRequest({
    $core.String? workspaceId,
    $core.String? couponId,
    $core.String? reason,
    $2.CommandContext? commandContext,
  }) {
    final result = CouponServiceRevokeRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (couponId != null) result.couponId = couponId;
    if (reason != null) result.reason = reason;
    if (commandContext != null) result.commandContext = commandContext;
    return result;
  }

  CouponServiceRevokeRequest._();

  factory CouponServiceRevokeRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CouponServiceRevokeRequest()..mergeFromBuffer(data, registry);
  factory CouponServiceRevokeRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CouponServiceRevokeRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CouponServiceRevokeRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: CouponServiceRevokeRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'couponId')
    ..aOS(3, _omitFieldNames ? '' : 'reason')
    ..aOM<$2.CommandContext>(4, _omitFieldNames ? '' : 'commandContext',
        subBuilder: $2.CommandContext.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CouponServiceRevokeRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CouponServiceRevokeRequest copyWith(
          void Function(CouponServiceRevokeRequest) updates) =>
      super.copyWith(
              (message) => updates(message as CouponServiceRevokeRequest))
          as CouponServiceRevokeRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use CouponServiceRevokeRequest() / CouponServiceRevokeRequest.new instead')
  static CouponServiceRevokeRequest create() => CouponServiceRevokeRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      CouponServiceRevokeRequest._();
  @$core.override
  CouponServiceRevokeRequest createEmptyInstance() =>
      CouponServiceRevokeRequest._();
  @$core.pragma('dart2js:noInline')
  static CouponServiceRevokeRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CouponServiceRevokeRequest>(
          CouponServiceRevokeRequest.$_createMessage);
  static CouponServiceRevokeRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get couponId => $_getSZ(1);
  @$pb.TagNumber(2)
  set couponId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCouponId() => $_has(1);
  @$pb.TagNumber(2)
  void clearCouponId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get reason => $_getSZ(2);
  @$pb.TagNumber(3)
  set reason($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasReason() => $_has(2);
  @$pb.TagNumber(3)
  void clearReason() => $_clearField(3);

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

class CouponServiceRevokeResponse extends $pb.GeneratedMessage {
  factory CouponServiceRevokeResponse({
    Coupon? coupon,
  }) {
    final result = CouponServiceRevokeResponse._();
    if (coupon != null) result.coupon = coupon;
    return result;
  }

  CouponServiceRevokeResponse._();

  factory CouponServiceRevokeResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CouponServiceRevokeResponse()..mergeFromBuffer(data, registry);
  factory CouponServiceRevokeResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CouponServiceRevokeResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CouponServiceRevokeResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: CouponServiceRevokeResponse.$_createMessage)
    ..aOM<Coupon>(1, _omitFieldNames ? '' : 'coupon',
        subBuilder: Coupon.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CouponServiceRevokeResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CouponServiceRevokeResponse copyWith(
          void Function(CouponServiceRevokeResponse) updates) =>
      super.copyWith(
              (message) => updates(message as CouponServiceRevokeResponse))
          as CouponServiceRevokeResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use CouponServiceRevokeResponse() / CouponServiceRevokeResponse.new instead')
  static CouponServiceRevokeResponse create() =>
      CouponServiceRevokeResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      CouponServiceRevokeResponse._();
  @$core.override
  CouponServiceRevokeResponse createEmptyInstance() =>
      CouponServiceRevokeResponse._();
  @$core.pragma('dart2js:noInline')
  static CouponServiceRevokeResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CouponServiceRevokeResponse>(
          CouponServiceRevokeResponse.$_createMessage);
  static CouponServiceRevokeResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Coupon get coupon => $_getN(0);
  @$pb.TagNumber(1)
  set coupon(Coupon value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasCoupon() => $_has(0);
  @$pb.TagNumber(1)
  void clearCoupon() => $_clearField(1);
  @$pb.TagNumber(1)
  Coupon ensureCoupon() => $_ensure(0);
}

class CouponServiceDeleteRequest extends $pb.GeneratedMessage {
  factory CouponServiceDeleteRequest({
    $core.String? workspaceId,
    $core.String? couponId,
    $2.CommandContext? commandContext,
  }) {
    final result = CouponServiceDeleteRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (couponId != null) result.couponId = couponId;
    if (commandContext != null) result.commandContext = commandContext;
    return result;
  }

  CouponServiceDeleteRequest._();

  factory CouponServiceDeleteRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CouponServiceDeleteRequest()..mergeFromBuffer(data, registry);
  factory CouponServiceDeleteRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CouponServiceDeleteRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CouponServiceDeleteRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: CouponServiceDeleteRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'couponId')
    ..aOM<$2.CommandContext>(3, _omitFieldNames ? '' : 'commandContext',
        subBuilder: $2.CommandContext.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CouponServiceDeleteRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CouponServiceDeleteRequest copyWith(
          void Function(CouponServiceDeleteRequest) updates) =>
      super.copyWith(
              (message) => updates(message as CouponServiceDeleteRequest))
          as CouponServiceDeleteRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use CouponServiceDeleteRequest() / CouponServiceDeleteRequest.new instead')
  static CouponServiceDeleteRequest create() => CouponServiceDeleteRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      CouponServiceDeleteRequest._();
  @$core.override
  CouponServiceDeleteRequest createEmptyInstance() =>
      CouponServiceDeleteRequest._();
  @$core.pragma('dart2js:noInline')
  static CouponServiceDeleteRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CouponServiceDeleteRequest>(
          CouponServiceDeleteRequest.$_createMessage);
  static CouponServiceDeleteRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get couponId => $_getSZ(1);
  @$pb.TagNumber(2)
  set couponId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCouponId() => $_has(1);
  @$pb.TagNumber(2)
  void clearCouponId() => $_clearField(2);

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

class CouponServiceDeleteResponse extends $pb.GeneratedMessage {
  factory CouponServiceDeleteResponse({
    $core.bool? success,
  }) {
    final result = CouponServiceDeleteResponse._();
    if (success != null) result.success = success;
    return result;
  }

  CouponServiceDeleteResponse._();

  factory CouponServiceDeleteResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CouponServiceDeleteResponse()..mergeFromBuffer(data, registry);
  factory CouponServiceDeleteResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CouponServiceDeleteResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CouponServiceDeleteResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: CouponServiceDeleteResponse.$_createMessage)
    ..aOB(1, _omitFieldNames ? '' : 'success')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CouponServiceDeleteResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CouponServiceDeleteResponse copyWith(
          void Function(CouponServiceDeleteResponse) updates) =>
      super.copyWith(
              (message) => updates(message as CouponServiceDeleteResponse))
          as CouponServiceDeleteResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use CouponServiceDeleteResponse() / CouponServiceDeleteResponse.new instead')
  static CouponServiceDeleteResponse create() =>
      CouponServiceDeleteResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      CouponServiceDeleteResponse._();
  @$core.override
  CouponServiceDeleteResponse createEmptyInstance() =>
      CouponServiceDeleteResponse._();
  @$core.pragma('dart2js:noInline')
  static CouponServiceDeleteResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CouponServiceDeleteResponse>(
          CouponServiceDeleteResponse.$_createMessage);
  static CouponServiceDeleteResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get success => $_getBF(0);
  @$pb.TagNumber(1)
  set success($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSuccess() => $_has(0);
  @$pb.TagNumber(1)
  void clearSuccess() => $_clearField(1);
}

class CouponServiceCheckAvailabilityRequest extends $pb.GeneratedMessage {
  factory CouponServiceCheckAvailabilityRequest({
    $core.String? workspaceId,
    $core.String? code,
  }) {
    final result = CouponServiceCheckAvailabilityRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (code != null) result.code = code;
    return result;
  }

  CouponServiceCheckAvailabilityRequest._();

  factory CouponServiceCheckAvailabilityRequest.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CouponServiceCheckAvailabilityRequest()..mergeFromBuffer(data, registry);
  factory CouponServiceCheckAvailabilityRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CouponServiceCheckAvailabilityRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CouponServiceCheckAvailabilityRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance:
          CouponServiceCheckAvailabilityRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'code')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CouponServiceCheckAvailabilityRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CouponServiceCheckAvailabilityRequest copyWith(
          void Function(CouponServiceCheckAvailabilityRequest) updates) =>
      super.copyWith((message) =>
              updates(message as CouponServiceCheckAvailabilityRequest))
          as CouponServiceCheckAvailabilityRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use CouponServiceCheckAvailabilityRequest() / CouponServiceCheckAvailabilityRequest.new instead')
  static CouponServiceCheckAvailabilityRequest create() =>
      CouponServiceCheckAvailabilityRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      CouponServiceCheckAvailabilityRequest._();
  @$core.override
  CouponServiceCheckAvailabilityRequest createEmptyInstance() =>
      CouponServiceCheckAvailabilityRequest._();
  @$core.pragma('dart2js:noInline')
  static CouponServiceCheckAvailabilityRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
              CouponServiceCheckAvailabilityRequest>(
          CouponServiceCheckAvailabilityRequest.$_createMessage);
  static CouponServiceCheckAvailabilityRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get code => $_getSZ(1);
  @$pb.TagNumber(2)
  set code($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCode() => $_has(1);
  @$pb.TagNumber(2)
  void clearCode() => $_clearField(2);
}

class CouponServiceCheckAvailabilityResponse extends $pb.GeneratedMessage {
  factory CouponServiceCheckAvailabilityResponse({
    $core.bool? available,
    $core.int? remainingUses,
    $1.Timestamp? expiresAt,
  }) {
    final result = CouponServiceCheckAvailabilityResponse._();
    if (available != null) result.available = available;
    if (remainingUses != null) result.remainingUses = remainingUses;
    if (expiresAt != null) result.expiresAt = expiresAt;
    return result;
  }

  CouponServiceCheckAvailabilityResponse._();

  factory CouponServiceCheckAvailabilityResponse.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CouponServiceCheckAvailabilityResponse()..mergeFromBuffer(data, registry);
  factory CouponServiceCheckAvailabilityResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CouponServiceCheckAvailabilityResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CouponServiceCheckAvailabilityResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance:
          CouponServiceCheckAvailabilityResponse.$_createMessage)
    ..aOB(1, _omitFieldNames ? '' : 'available')
    ..aI(2, _omitFieldNames ? '' : 'remainingUses')
    ..aOM<$1.Timestamp>(3, _omitFieldNames ? '' : 'expiresAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CouponServiceCheckAvailabilityResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CouponServiceCheckAvailabilityResponse copyWith(
          void Function(CouponServiceCheckAvailabilityResponse) updates) =>
      super.copyWith((message) =>
              updates(message as CouponServiceCheckAvailabilityResponse))
          as CouponServiceCheckAvailabilityResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use CouponServiceCheckAvailabilityResponse() / CouponServiceCheckAvailabilityResponse.new instead')
  static CouponServiceCheckAvailabilityResponse create() =>
      CouponServiceCheckAvailabilityResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      CouponServiceCheckAvailabilityResponse._();
  @$core.override
  CouponServiceCheckAvailabilityResponse createEmptyInstance() =>
      CouponServiceCheckAvailabilityResponse._();
  @$core.pragma('dart2js:noInline')
  static CouponServiceCheckAvailabilityResponse getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
              CouponServiceCheckAvailabilityResponse>(
          CouponServiceCheckAvailabilityResponse.$_createMessage);
  static CouponServiceCheckAvailabilityResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get available => $_getBF(0);
  @$pb.TagNumber(1)
  set available($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAvailable() => $_has(0);
  @$pb.TagNumber(1)
  void clearAvailable() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get remainingUses => $_getIZ(1);
  @$pb.TagNumber(2)
  set remainingUses($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasRemainingUses() => $_has(1);
  @$pb.TagNumber(2)
  void clearRemainingUses() => $_clearField(2);

  @$pb.TagNumber(3)
  $1.Timestamp get expiresAt => $_getN(2);
  @$pb.TagNumber(3)
  set expiresAt($1.Timestamp value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasExpiresAt() => $_has(2);
  @$pb.TagNumber(3)
  void clearExpiresAt() => $_clearField(3);
  @$pb.TagNumber(3)
  $1.Timestamp ensureExpiresAt() => $_ensure(2);
}

/// Campaign Service Requests/Responses
class CampaignServiceCreateRequest extends $pb.GeneratedMessage {
  factory CampaignServiceCreateRequest({
    $core.String? workspaceId,
    CampaignType? campaignType,
    $core.String? title,
    $core.String? objective,
    $core.String? startDate,
    $core.String? endDate,
    $core.String? budget,
    $core.String? budgetCurrency,
    $core.Iterable<$core.String>? relatedProductIds,
    $core.Iterable<$core.String>? relatedOfferIds,
    $core.String? metadataJson,
    $2.CommandContext? commandContext,
  }) {
    final result = CampaignServiceCreateRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (campaignType != null) result.campaignType = campaignType;
    if (title != null) result.title = title;
    if (objective != null) result.objective = objective;
    if (startDate != null) result.startDate = startDate;
    if (endDate != null) result.endDate = endDate;
    if (budget != null) result.budget = budget;
    if (budgetCurrency != null) result.budgetCurrency = budgetCurrency;
    if (relatedProductIds != null)
      result.relatedProductIds.addAll(relatedProductIds);
    if (relatedOfferIds != null) result.relatedOfferIds.addAll(relatedOfferIds);
    if (metadataJson != null) result.metadataJson = metadataJson;
    if (commandContext != null) result.commandContext = commandContext;
    return result;
  }

  CampaignServiceCreateRequest._();

  factory CampaignServiceCreateRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CampaignServiceCreateRequest()..mergeFromBuffer(data, registry);
  factory CampaignServiceCreateRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CampaignServiceCreateRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CampaignServiceCreateRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: CampaignServiceCreateRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aE<CampaignType>(2, _omitFieldNames ? '' : 'campaignType',
        enumValues: CampaignType.values)
    ..aOS(3, _omitFieldNames ? '' : 'title')
    ..aOS(4, _omitFieldNames ? '' : 'objective')
    ..aOS(5, _omitFieldNames ? '' : 'startDate')
    ..aOS(6, _omitFieldNames ? '' : 'endDate')
    ..aOS(7, _omitFieldNames ? '' : 'budget')
    ..aOS(8, _omitFieldNames ? '' : 'budgetCurrency')
    ..pPS(9, _omitFieldNames ? '' : 'relatedProductIds')
    ..pPS(10, _omitFieldNames ? '' : 'relatedOfferIds')
    ..aOS(11, _omitFieldNames ? '' : 'metadataJson')
    ..aOM<$2.CommandContext>(12, _omitFieldNames ? '' : 'commandContext',
        subBuilder: $2.CommandContext.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CampaignServiceCreateRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CampaignServiceCreateRequest copyWith(
          void Function(CampaignServiceCreateRequest) updates) =>
      super.copyWith(
              (message) => updates(message as CampaignServiceCreateRequest))
          as CampaignServiceCreateRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use CampaignServiceCreateRequest() / CampaignServiceCreateRequest.new instead')
  static CampaignServiceCreateRequest create() =>
      CampaignServiceCreateRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      CampaignServiceCreateRequest._();
  @$core.override
  CampaignServiceCreateRequest createEmptyInstance() =>
      CampaignServiceCreateRequest._();
  @$core.pragma('dart2js:noInline')
  static CampaignServiceCreateRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CampaignServiceCreateRequest>(
          CampaignServiceCreateRequest.$_createMessage);
  static CampaignServiceCreateRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  CampaignType get campaignType => $_getN(1);
  @$pb.TagNumber(2)
  set campaignType(CampaignType value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasCampaignType() => $_has(1);
  @$pb.TagNumber(2)
  void clearCampaignType() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get title => $_getSZ(2);
  @$pb.TagNumber(3)
  set title($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasTitle() => $_has(2);
  @$pb.TagNumber(3)
  void clearTitle() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get objective => $_getSZ(3);
  @$pb.TagNumber(4)
  set objective($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasObjective() => $_has(3);
  @$pb.TagNumber(4)
  void clearObjective() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get startDate => $_getSZ(4);
  @$pb.TagNumber(5)
  set startDate($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasStartDate() => $_has(4);
  @$pb.TagNumber(5)
  void clearStartDate() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get endDate => $_getSZ(5);
  @$pb.TagNumber(6)
  set endDate($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasEndDate() => $_has(5);
  @$pb.TagNumber(6)
  void clearEndDate() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get budget => $_getSZ(6);
  @$pb.TagNumber(7)
  set budget($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasBudget() => $_has(6);
  @$pb.TagNumber(7)
  void clearBudget() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get budgetCurrency => $_getSZ(7);
  @$pb.TagNumber(8)
  set budgetCurrency($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasBudgetCurrency() => $_has(7);
  @$pb.TagNumber(8)
  void clearBudgetCurrency() => $_clearField(8);

  @$pb.TagNumber(9)
  $pb.PbList<$core.String> get relatedProductIds => $_getList(8);

  @$pb.TagNumber(10)
  $pb.PbList<$core.String> get relatedOfferIds => $_getList(9);

  @$pb.TagNumber(11)
  $core.String get metadataJson => $_getSZ(10);
  @$pb.TagNumber(11)
  set metadataJson($core.String value) => $_setString(10, value);
  @$pb.TagNumber(11)
  $core.bool hasMetadataJson() => $_has(10);
  @$pb.TagNumber(11)
  void clearMetadataJson() => $_clearField(11);

  @$pb.TagNumber(12)
  $2.CommandContext get commandContext => $_getN(11);
  @$pb.TagNumber(12)
  set commandContext($2.CommandContext value) => $_setField(12, value);
  @$pb.TagNumber(12)
  $core.bool hasCommandContext() => $_has(11);
  @$pb.TagNumber(12)
  void clearCommandContext() => $_clearField(12);
  @$pb.TagNumber(12)
  $2.CommandContext ensureCommandContext() => $_ensure(11);
}

class CampaignServiceCreateResponse extends $pb.GeneratedMessage {
  factory CampaignServiceCreateResponse({
    Campaign? campaign,
  }) {
    final result = CampaignServiceCreateResponse._();
    if (campaign != null) result.campaign = campaign;
    return result;
  }

  CampaignServiceCreateResponse._();

  factory CampaignServiceCreateResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CampaignServiceCreateResponse()..mergeFromBuffer(data, registry);
  factory CampaignServiceCreateResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CampaignServiceCreateResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CampaignServiceCreateResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: CampaignServiceCreateResponse.$_createMessage)
    ..aOM<Campaign>(1, _omitFieldNames ? '' : 'campaign',
        subBuilder: Campaign.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CampaignServiceCreateResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CampaignServiceCreateResponse copyWith(
          void Function(CampaignServiceCreateResponse) updates) =>
      super.copyWith(
              (message) => updates(message as CampaignServiceCreateResponse))
          as CampaignServiceCreateResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use CampaignServiceCreateResponse() / CampaignServiceCreateResponse.new instead')
  static CampaignServiceCreateResponse create() =>
      CampaignServiceCreateResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      CampaignServiceCreateResponse._();
  @$core.override
  CampaignServiceCreateResponse createEmptyInstance() =>
      CampaignServiceCreateResponse._();
  @$core.pragma('dart2js:noInline')
  static CampaignServiceCreateResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CampaignServiceCreateResponse>(
          CampaignServiceCreateResponse.$_createMessage);
  static CampaignServiceCreateResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Campaign get campaign => $_getN(0);
  @$pb.TagNumber(1)
  set campaign(Campaign value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasCampaign() => $_has(0);
  @$pb.TagNumber(1)
  void clearCampaign() => $_clearField(1);
  @$pb.TagNumber(1)
  Campaign ensureCampaign() => $_ensure(0);
}

class CampaignServiceGetRequest extends $pb.GeneratedMessage {
  factory CampaignServiceGetRequest({
    $core.String? workspaceId,
    $core.String? campaignId,
  }) {
    final result = CampaignServiceGetRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (campaignId != null) result.campaignId = campaignId;
    return result;
  }

  CampaignServiceGetRequest._();

  factory CampaignServiceGetRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CampaignServiceGetRequest()..mergeFromBuffer(data, registry);
  factory CampaignServiceGetRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CampaignServiceGetRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CampaignServiceGetRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: CampaignServiceGetRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'campaignId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CampaignServiceGetRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CampaignServiceGetRequest copyWith(
          void Function(CampaignServiceGetRequest) updates) =>
      super.copyWith((message) => updates(message as CampaignServiceGetRequest))
          as CampaignServiceGetRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use CampaignServiceGetRequest() / CampaignServiceGetRequest.new instead')
  static CampaignServiceGetRequest create() => CampaignServiceGetRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      CampaignServiceGetRequest._();
  @$core.override
  CampaignServiceGetRequest createEmptyInstance() =>
      CampaignServiceGetRequest._();
  @$core.pragma('dart2js:noInline')
  static CampaignServiceGetRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CampaignServiceGetRequest>(
          CampaignServiceGetRequest.$_createMessage);
  static CampaignServiceGetRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get campaignId => $_getSZ(1);
  @$pb.TagNumber(2)
  set campaignId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCampaignId() => $_has(1);
  @$pb.TagNumber(2)
  void clearCampaignId() => $_clearField(2);
}

class CampaignServiceGetResponse extends $pb.GeneratedMessage {
  factory CampaignServiceGetResponse({
    Campaign? campaign,
  }) {
    final result = CampaignServiceGetResponse._();
    if (campaign != null) result.campaign = campaign;
    return result;
  }

  CampaignServiceGetResponse._();

  factory CampaignServiceGetResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CampaignServiceGetResponse()..mergeFromBuffer(data, registry);
  factory CampaignServiceGetResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CampaignServiceGetResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CampaignServiceGetResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: CampaignServiceGetResponse.$_createMessage)
    ..aOM<Campaign>(1, _omitFieldNames ? '' : 'campaign',
        subBuilder: Campaign.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CampaignServiceGetResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CampaignServiceGetResponse copyWith(
          void Function(CampaignServiceGetResponse) updates) =>
      super.copyWith(
              (message) => updates(message as CampaignServiceGetResponse))
          as CampaignServiceGetResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use CampaignServiceGetResponse() / CampaignServiceGetResponse.new instead')
  static CampaignServiceGetResponse create() => CampaignServiceGetResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      CampaignServiceGetResponse._();
  @$core.override
  CampaignServiceGetResponse createEmptyInstance() =>
      CampaignServiceGetResponse._();
  @$core.pragma('dart2js:noInline')
  static CampaignServiceGetResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CampaignServiceGetResponse>(
          CampaignServiceGetResponse.$_createMessage);
  static CampaignServiceGetResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Campaign get campaign => $_getN(0);
  @$pb.TagNumber(1)
  set campaign(Campaign value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasCampaign() => $_has(0);
  @$pb.TagNumber(1)
  void clearCampaign() => $_clearField(1);
  @$pb.TagNumber(1)
  Campaign ensureCampaign() => $_ensure(0);
}

class CampaignServiceListRequest extends $pb.GeneratedMessage {
  factory CampaignServiceListRequest({
    $core.String? workspaceId,
    CampaignStatus? status,
    CampaignType? campaignType,
    $core.String? query,
    $core.int? pageSize,
    $core.String? pageToken,
  }) {
    final result = CampaignServiceListRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (status != null) result.status = status;
    if (campaignType != null) result.campaignType = campaignType;
    if (query != null) result.query = query;
    if (pageSize != null) result.pageSize = pageSize;
    if (pageToken != null) result.pageToken = pageToken;
    return result;
  }

  CampaignServiceListRequest._();

  factory CampaignServiceListRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CampaignServiceListRequest()..mergeFromBuffer(data, registry);
  factory CampaignServiceListRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CampaignServiceListRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CampaignServiceListRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: CampaignServiceListRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aE<CampaignStatus>(2, _omitFieldNames ? '' : 'status',
        enumValues: CampaignStatus.values)
    ..aE<CampaignType>(3, _omitFieldNames ? '' : 'campaignType',
        enumValues: CampaignType.values)
    ..aOS(4, _omitFieldNames ? '' : 'query')
    ..aI(5, _omitFieldNames ? '' : 'pageSize')
    ..aOS(6, _omitFieldNames ? '' : 'pageToken')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CampaignServiceListRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CampaignServiceListRequest copyWith(
          void Function(CampaignServiceListRequest) updates) =>
      super.copyWith(
              (message) => updates(message as CampaignServiceListRequest))
          as CampaignServiceListRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use CampaignServiceListRequest() / CampaignServiceListRequest.new instead')
  static CampaignServiceListRequest create() => CampaignServiceListRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      CampaignServiceListRequest._();
  @$core.override
  CampaignServiceListRequest createEmptyInstance() =>
      CampaignServiceListRequest._();
  @$core.pragma('dart2js:noInline')
  static CampaignServiceListRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CampaignServiceListRequest>(
          CampaignServiceListRequest.$_createMessage);
  static CampaignServiceListRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  CampaignStatus get status => $_getN(1);
  @$pb.TagNumber(2)
  set status(CampaignStatus value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasStatus() => $_has(1);
  @$pb.TagNumber(2)
  void clearStatus() => $_clearField(2);

  @$pb.TagNumber(3)
  CampaignType get campaignType => $_getN(2);
  @$pb.TagNumber(3)
  set campaignType(CampaignType value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasCampaignType() => $_has(2);
  @$pb.TagNumber(3)
  void clearCampaignType() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get query => $_getSZ(3);
  @$pb.TagNumber(4)
  set query($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasQuery() => $_has(3);
  @$pb.TagNumber(4)
  void clearQuery() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get pageSize => $_getIZ(4);
  @$pb.TagNumber(5)
  set pageSize($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasPageSize() => $_has(4);
  @$pb.TagNumber(5)
  void clearPageSize() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get pageToken => $_getSZ(5);
  @$pb.TagNumber(6)
  set pageToken($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasPageToken() => $_has(5);
  @$pb.TagNumber(6)
  void clearPageToken() => $_clearField(6);
}

class CampaignServiceListResponse extends $pb.GeneratedMessage {
  factory CampaignServiceListResponse({
    $core.Iterable<Campaign>? campaigns,
    $core.String? nextPageToken,
    $core.int? totalCount,
  }) {
    final result = CampaignServiceListResponse._();
    if (campaigns != null) result.campaigns.addAll(campaigns);
    if (nextPageToken != null) result.nextPageToken = nextPageToken;
    if (totalCount != null) result.totalCount = totalCount;
    return result;
  }

  CampaignServiceListResponse._();

  factory CampaignServiceListResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CampaignServiceListResponse()..mergeFromBuffer(data, registry);
  factory CampaignServiceListResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CampaignServiceListResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CampaignServiceListResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: CampaignServiceListResponse.$_createMessage)
    ..pPM<Campaign>(1, _omitFieldNames ? '' : 'campaigns',
        subBuilder: Campaign.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'nextPageToken')
    ..aI(3, _omitFieldNames ? '' : 'totalCount')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CampaignServiceListResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CampaignServiceListResponse copyWith(
          void Function(CampaignServiceListResponse) updates) =>
      super.copyWith(
              (message) => updates(message as CampaignServiceListResponse))
          as CampaignServiceListResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use CampaignServiceListResponse() / CampaignServiceListResponse.new instead')
  static CampaignServiceListResponse create() =>
      CampaignServiceListResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      CampaignServiceListResponse._();
  @$core.override
  CampaignServiceListResponse createEmptyInstance() =>
      CampaignServiceListResponse._();
  @$core.pragma('dart2js:noInline')
  static CampaignServiceListResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CampaignServiceListResponse>(
          CampaignServiceListResponse.$_createMessage);
  static CampaignServiceListResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Campaign> get campaigns => $_getList(0);

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

class CampaignServiceUpdateRequest extends $pb.GeneratedMessage {
  factory CampaignServiceUpdateRequest({
    $core.String? workspaceId,
    $core.String? campaignId,
    $core.String? title,
    $core.String? objective,
    $core.String? startDate,
    $core.String? endDate,
    $core.String? budget,
    $core.String? budgetCurrency,
    $core.Iterable<$core.String>? relatedProductIds,
    $core.Iterable<$core.String>? relatedOfferIds,
    $core.String? metadataJson,
    $2.CommandContext? commandContext,
  }) {
    final result = CampaignServiceUpdateRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (campaignId != null) result.campaignId = campaignId;
    if (title != null) result.title = title;
    if (objective != null) result.objective = objective;
    if (startDate != null) result.startDate = startDate;
    if (endDate != null) result.endDate = endDate;
    if (budget != null) result.budget = budget;
    if (budgetCurrency != null) result.budgetCurrency = budgetCurrency;
    if (relatedProductIds != null)
      result.relatedProductIds.addAll(relatedProductIds);
    if (relatedOfferIds != null) result.relatedOfferIds.addAll(relatedOfferIds);
    if (metadataJson != null) result.metadataJson = metadataJson;
    if (commandContext != null) result.commandContext = commandContext;
    return result;
  }

  CampaignServiceUpdateRequest._();

  factory CampaignServiceUpdateRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CampaignServiceUpdateRequest()..mergeFromBuffer(data, registry);
  factory CampaignServiceUpdateRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CampaignServiceUpdateRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CampaignServiceUpdateRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: CampaignServiceUpdateRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'campaignId')
    ..aOS(3, _omitFieldNames ? '' : 'title')
    ..aOS(4, _omitFieldNames ? '' : 'objective')
    ..aOS(5, _omitFieldNames ? '' : 'startDate')
    ..aOS(6, _omitFieldNames ? '' : 'endDate')
    ..aOS(7, _omitFieldNames ? '' : 'budget')
    ..aOS(8, _omitFieldNames ? '' : 'budgetCurrency')
    ..pPS(9, _omitFieldNames ? '' : 'relatedProductIds')
    ..pPS(10, _omitFieldNames ? '' : 'relatedOfferIds')
    ..aOS(11, _omitFieldNames ? '' : 'metadataJson')
    ..aOM<$2.CommandContext>(12, _omitFieldNames ? '' : 'commandContext',
        subBuilder: $2.CommandContext.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CampaignServiceUpdateRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CampaignServiceUpdateRequest copyWith(
          void Function(CampaignServiceUpdateRequest) updates) =>
      super.copyWith(
              (message) => updates(message as CampaignServiceUpdateRequest))
          as CampaignServiceUpdateRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use CampaignServiceUpdateRequest() / CampaignServiceUpdateRequest.new instead')
  static CampaignServiceUpdateRequest create() =>
      CampaignServiceUpdateRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      CampaignServiceUpdateRequest._();
  @$core.override
  CampaignServiceUpdateRequest createEmptyInstance() =>
      CampaignServiceUpdateRequest._();
  @$core.pragma('dart2js:noInline')
  static CampaignServiceUpdateRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CampaignServiceUpdateRequest>(
          CampaignServiceUpdateRequest.$_createMessage);
  static CampaignServiceUpdateRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get campaignId => $_getSZ(1);
  @$pb.TagNumber(2)
  set campaignId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCampaignId() => $_has(1);
  @$pb.TagNumber(2)
  void clearCampaignId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get title => $_getSZ(2);
  @$pb.TagNumber(3)
  set title($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasTitle() => $_has(2);
  @$pb.TagNumber(3)
  void clearTitle() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get objective => $_getSZ(3);
  @$pb.TagNumber(4)
  set objective($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasObjective() => $_has(3);
  @$pb.TagNumber(4)
  void clearObjective() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get startDate => $_getSZ(4);
  @$pb.TagNumber(5)
  set startDate($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasStartDate() => $_has(4);
  @$pb.TagNumber(5)
  void clearStartDate() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get endDate => $_getSZ(5);
  @$pb.TagNumber(6)
  set endDate($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasEndDate() => $_has(5);
  @$pb.TagNumber(6)
  void clearEndDate() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get budget => $_getSZ(6);
  @$pb.TagNumber(7)
  set budget($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasBudget() => $_has(6);
  @$pb.TagNumber(7)
  void clearBudget() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get budgetCurrency => $_getSZ(7);
  @$pb.TagNumber(8)
  set budgetCurrency($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasBudgetCurrency() => $_has(7);
  @$pb.TagNumber(8)
  void clearBudgetCurrency() => $_clearField(8);

  @$pb.TagNumber(9)
  $pb.PbList<$core.String> get relatedProductIds => $_getList(8);

  @$pb.TagNumber(10)
  $pb.PbList<$core.String> get relatedOfferIds => $_getList(9);

  @$pb.TagNumber(11)
  $core.String get metadataJson => $_getSZ(10);
  @$pb.TagNumber(11)
  set metadataJson($core.String value) => $_setString(10, value);
  @$pb.TagNumber(11)
  $core.bool hasMetadataJson() => $_has(10);
  @$pb.TagNumber(11)
  void clearMetadataJson() => $_clearField(11);

  @$pb.TagNumber(12)
  $2.CommandContext get commandContext => $_getN(11);
  @$pb.TagNumber(12)
  set commandContext($2.CommandContext value) => $_setField(12, value);
  @$pb.TagNumber(12)
  $core.bool hasCommandContext() => $_has(11);
  @$pb.TagNumber(12)
  void clearCommandContext() => $_clearField(12);
  @$pb.TagNumber(12)
  $2.CommandContext ensureCommandContext() => $_ensure(11);
}

class CampaignServiceUpdateResponse extends $pb.GeneratedMessage {
  factory CampaignServiceUpdateResponse({
    Campaign? campaign,
  }) {
    final result = CampaignServiceUpdateResponse._();
    if (campaign != null) result.campaign = campaign;
    return result;
  }

  CampaignServiceUpdateResponse._();

  factory CampaignServiceUpdateResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CampaignServiceUpdateResponse()..mergeFromBuffer(data, registry);
  factory CampaignServiceUpdateResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CampaignServiceUpdateResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CampaignServiceUpdateResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: CampaignServiceUpdateResponse.$_createMessage)
    ..aOM<Campaign>(1, _omitFieldNames ? '' : 'campaign',
        subBuilder: Campaign.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CampaignServiceUpdateResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CampaignServiceUpdateResponse copyWith(
          void Function(CampaignServiceUpdateResponse) updates) =>
      super.copyWith(
              (message) => updates(message as CampaignServiceUpdateResponse))
          as CampaignServiceUpdateResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use CampaignServiceUpdateResponse() / CampaignServiceUpdateResponse.new instead')
  static CampaignServiceUpdateResponse create() =>
      CampaignServiceUpdateResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      CampaignServiceUpdateResponse._();
  @$core.override
  CampaignServiceUpdateResponse createEmptyInstance() =>
      CampaignServiceUpdateResponse._();
  @$core.pragma('dart2js:noInline')
  static CampaignServiceUpdateResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CampaignServiceUpdateResponse>(
          CampaignServiceUpdateResponse.$_createMessage);
  static CampaignServiceUpdateResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Campaign get campaign => $_getN(0);
  @$pb.TagNumber(1)
  set campaign(Campaign value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasCampaign() => $_has(0);
  @$pb.TagNumber(1)
  void clearCampaign() => $_clearField(1);
  @$pb.TagNumber(1)
  Campaign ensureCampaign() => $_ensure(0);
}

class CampaignServiceActivateRequest extends $pb.GeneratedMessage {
  factory CampaignServiceActivateRequest({
    $core.String? workspaceId,
    $core.String? campaignId,
    $2.CommandContext? commandContext,
  }) {
    final result = CampaignServiceActivateRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (campaignId != null) result.campaignId = campaignId;
    if (commandContext != null) result.commandContext = commandContext;
    return result;
  }

  CampaignServiceActivateRequest._();

  factory CampaignServiceActivateRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CampaignServiceActivateRequest()..mergeFromBuffer(data, registry);
  factory CampaignServiceActivateRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CampaignServiceActivateRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CampaignServiceActivateRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: CampaignServiceActivateRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'campaignId')
    ..aOM<$2.CommandContext>(3, _omitFieldNames ? '' : 'commandContext',
        subBuilder: $2.CommandContext.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CampaignServiceActivateRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CampaignServiceActivateRequest copyWith(
          void Function(CampaignServiceActivateRequest) updates) =>
      super.copyWith(
              (message) => updates(message as CampaignServiceActivateRequest))
          as CampaignServiceActivateRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use CampaignServiceActivateRequest() / CampaignServiceActivateRequest.new instead')
  static CampaignServiceActivateRequest create() =>
      CampaignServiceActivateRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      CampaignServiceActivateRequest._();
  @$core.override
  CampaignServiceActivateRequest createEmptyInstance() =>
      CampaignServiceActivateRequest._();
  @$core.pragma('dart2js:noInline')
  static CampaignServiceActivateRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CampaignServiceActivateRequest>(
          CampaignServiceActivateRequest.$_createMessage);
  static CampaignServiceActivateRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get campaignId => $_getSZ(1);
  @$pb.TagNumber(2)
  set campaignId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCampaignId() => $_has(1);
  @$pb.TagNumber(2)
  void clearCampaignId() => $_clearField(2);

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

class CampaignServiceActivateResponse extends $pb.GeneratedMessage {
  factory CampaignServiceActivateResponse({
    Campaign? campaign,
  }) {
    final result = CampaignServiceActivateResponse._();
    if (campaign != null) result.campaign = campaign;
    return result;
  }

  CampaignServiceActivateResponse._();

  factory CampaignServiceActivateResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CampaignServiceActivateResponse()..mergeFromBuffer(data, registry);
  factory CampaignServiceActivateResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CampaignServiceActivateResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CampaignServiceActivateResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: CampaignServiceActivateResponse.$_createMessage)
    ..aOM<Campaign>(1, _omitFieldNames ? '' : 'campaign',
        subBuilder: Campaign.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CampaignServiceActivateResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CampaignServiceActivateResponse copyWith(
          void Function(CampaignServiceActivateResponse) updates) =>
      super.copyWith(
              (message) => updates(message as CampaignServiceActivateResponse))
          as CampaignServiceActivateResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use CampaignServiceActivateResponse() / CampaignServiceActivateResponse.new instead')
  static CampaignServiceActivateResponse create() =>
      CampaignServiceActivateResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      CampaignServiceActivateResponse._();
  @$core.override
  CampaignServiceActivateResponse createEmptyInstance() =>
      CampaignServiceActivateResponse._();
  @$core.pragma('dart2js:noInline')
  static CampaignServiceActivateResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CampaignServiceActivateResponse>(
          CampaignServiceActivateResponse.$_createMessage);
  static CampaignServiceActivateResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Campaign get campaign => $_getN(0);
  @$pb.TagNumber(1)
  set campaign(Campaign value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasCampaign() => $_has(0);
  @$pb.TagNumber(1)
  void clearCampaign() => $_clearField(1);
  @$pb.TagNumber(1)
  Campaign ensureCampaign() => $_ensure(0);
}

class CampaignServicePauseRequest extends $pb.GeneratedMessage {
  factory CampaignServicePauseRequest({
    $core.String? workspaceId,
    $core.String? campaignId,
    $2.CommandContext? commandContext,
  }) {
    final result = CampaignServicePauseRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (campaignId != null) result.campaignId = campaignId;
    if (commandContext != null) result.commandContext = commandContext;
    return result;
  }

  CampaignServicePauseRequest._();

  factory CampaignServicePauseRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CampaignServicePauseRequest()..mergeFromBuffer(data, registry);
  factory CampaignServicePauseRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CampaignServicePauseRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CampaignServicePauseRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: CampaignServicePauseRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'campaignId')
    ..aOM<$2.CommandContext>(3, _omitFieldNames ? '' : 'commandContext',
        subBuilder: $2.CommandContext.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CampaignServicePauseRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CampaignServicePauseRequest copyWith(
          void Function(CampaignServicePauseRequest) updates) =>
      super.copyWith(
              (message) => updates(message as CampaignServicePauseRequest))
          as CampaignServicePauseRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use CampaignServicePauseRequest() / CampaignServicePauseRequest.new instead')
  static CampaignServicePauseRequest create() =>
      CampaignServicePauseRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      CampaignServicePauseRequest._();
  @$core.override
  CampaignServicePauseRequest createEmptyInstance() =>
      CampaignServicePauseRequest._();
  @$core.pragma('dart2js:noInline')
  static CampaignServicePauseRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CampaignServicePauseRequest>(
          CampaignServicePauseRequest.$_createMessage);
  static CampaignServicePauseRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get campaignId => $_getSZ(1);
  @$pb.TagNumber(2)
  set campaignId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCampaignId() => $_has(1);
  @$pb.TagNumber(2)
  void clearCampaignId() => $_clearField(2);

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

class CampaignServicePauseResponse extends $pb.GeneratedMessage {
  factory CampaignServicePauseResponse({
    Campaign? campaign,
  }) {
    final result = CampaignServicePauseResponse._();
    if (campaign != null) result.campaign = campaign;
    return result;
  }

  CampaignServicePauseResponse._();

  factory CampaignServicePauseResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CampaignServicePauseResponse()..mergeFromBuffer(data, registry);
  factory CampaignServicePauseResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CampaignServicePauseResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CampaignServicePauseResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: CampaignServicePauseResponse.$_createMessage)
    ..aOM<Campaign>(1, _omitFieldNames ? '' : 'campaign',
        subBuilder: Campaign.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CampaignServicePauseResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CampaignServicePauseResponse copyWith(
          void Function(CampaignServicePauseResponse) updates) =>
      super.copyWith(
              (message) => updates(message as CampaignServicePauseResponse))
          as CampaignServicePauseResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use CampaignServicePauseResponse() / CampaignServicePauseResponse.new instead')
  static CampaignServicePauseResponse create() =>
      CampaignServicePauseResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      CampaignServicePauseResponse._();
  @$core.override
  CampaignServicePauseResponse createEmptyInstance() =>
      CampaignServicePauseResponse._();
  @$core.pragma('dart2js:noInline')
  static CampaignServicePauseResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CampaignServicePauseResponse>(
          CampaignServicePauseResponse.$_createMessage);
  static CampaignServicePauseResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Campaign get campaign => $_getN(0);
  @$pb.TagNumber(1)
  set campaign(Campaign value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasCampaign() => $_has(0);
  @$pb.TagNumber(1)
  void clearCampaign() => $_clearField(1);
  @$pb.TagNumber(1)
  Campaign ensureCampaign() => $_ensure(0);
}

class CampaignServiceResumeRequest extends $pb.GeneratedMessage {
  factory CampaignServiceResumeRequest({
    $core.String? workspaceId,
    $core.String? campaignId,
    $2.CommandContext? commandContext,
  }) {
    final result = CampaignServiceResumeRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (campaignId != null) result.campaignId = campaignId;
    if (commandContext != null) result.commandContext = commandContext;
    return result;
  }

  CampaignServiceResumeRequest._();

  factory CampaignServiceResumeRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CampaignServiceResumeRequest()..mergeFromBuffer(data, registry);
  factory CampaignServiceResumeRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CampaignServiceResumeRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CampaignServiceResumeRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: CampaignServiceResumeRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'campaignId')
    ..aOM<$2.CommandContext>(3, _omitFieldNames ? '' : 'commandContext',
        subBuilder: $2.CommandContext.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CampaignServiceResumeRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CampaignServiceResumeRequest copyWith(
          void Function(CampaignServiceResumeRequest) updates) =>
      super.copyWith(
              (message) => updates(message as CampaignServiceResumeRequest))
          as CampaignServiceResumeRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use CampaignServiceResumeRequest() / CampaignServiceResumeRequest.new instead')
  static CampaignServiceResumeRequest create() =>
      CampaignServiceResumeRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      CampaignServiceResumeRequest._();
  @$core.override
  CampaignServiceResumeRequest createEmptyInstance() =>
      CampaignServiceResumeRequest._();
  @$core.pragma('dart2js:noInline')
  static CampaignServiceResumeRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CampaignServiceResumeRequest>(
          CampaignServiceResumeRequest.$_createMessage);
  static CampaignServiceResumeRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get campaignId => $_getSZ(1);
  @$pb.TagNumber(2)
  set campaignId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCampaignId() => $_has(1);
  @$pb.TagNumber(2)
  void clearCampaignId() => $_clearField(2);

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

class CampaignServiceResumeResponse extends $pb.GeneratedMessage {
  factory CampaignServiceResumeResponse({
    Campaign? campaign,
  }) {
    final result = CampaignServiceResumeResponse._();
    if (campaign != null) result.campaign = campaign;
    return result;
  }

  CampaignServiceResumeResponse._();

  factory CampaignServiceResumeResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CampaignServiceResumeResponse()..mergeFromBuffer(data, registry);
  factory CampaignServiceResumeResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CampaignServiceResumeResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CampaignServiceResumeResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: CampaignServiceResumeResponse.$_createMessage)
    ..aOM<Campaign>(1, _omitFieldNames ? '' : 'campaign',
        subBuilder: Campaign.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CampaignServiceResumeResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CampaignServiceResumeResponse copyWith(
          void Function(CampaignServiceResumeResponse) updates) =>
      super.copyWith(
              (message) => updates(message as CampaignServiceResumeResponse))
          as CampaignServiceResumeResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use CampaignServiceResumeResponse() / CampaignServiceResumeResponse.new instead')
  static CampaignServiceResumeResponse create() =>
      CampaignServiceResumeResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      CampaignServiceResumeResponse._();
  @$core.override
  CampaignServiceResumeResponse createEmptyInstance() =>
      CampaignServiceResumeResponse._();
  @$core.pragma('dart2js:noInline')
  static CampaignServiceResumeResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CampaignServiceResumeResponse>(
          CampaignServiceResumeResponse.$_createMessage);
  static CampaignServiceResumeResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Campaign get campaign => $_getN(0);
  @$pb.TagNumber(1)
  set campaign(Campaign value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasCampaign() => $_has(0);
  @$pb.TagNumber(1)
  void clearCampaign() => $_clearField(1);
  @$pb.TagNumber(1)
  Campaign ensureCampaign() => $_ensure(0);
}

class CampaignServiceEndRequest extends $pb.GeneratedMessage {
  factory CampaignServiceEndRequest({
    $core.String? workspaceId,
    $core.String? campaignId,
    $2.CommandContext? commandContext,
  }) {
    final result = CampaignServiceEndRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (campaignId != null) result.campaignId = campaignId;
    if (commandContext != null) result.commandContext = commandContext;
    return result;
  }

  CampaignServiceEndRequest._();

  factory CampaignServiceEndRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CampaignServiceEndRequest()..mergeFromBuffer(data, registry);
  factory CampaignServiceEndRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CampaignServiceEndRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CampaignServiceEndRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: CampaignServiceEndRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'campaignId')
    ..aOM<$2.CommandContext>(3, _omitFieldNames ? '' : 'commandContext',
        subBuilder: $2.CommandContext.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CampaignServiceEndRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CampaignServiceEndRequest copyWith(
          void Function(CampaignServiceEndRequest) updates) =>
      super.copyWith((message) => updates(message as CampaignServiceEndRequest))
          as CampaignServiceEndRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use CampaignServiceEndRequest() / CampaignServiceEndRequest.new instead')
  static CampaignServiceEndRequest create() => CampaignServiceEndRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      CampaignServiceEndRequest._();
  @$core.override
  CampaignServiceEndRequest createEmptyInstance() =>
      CampaignServiceEndRequest._();
  @$core.pragma('dart2js:noInline')
  static CampaignServiceEndRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CampaignServiceEndRequest>(
          CampaignServiceEndRequest.$_createMessage);
  static CampaignServiceEndRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get campaignId => $_getSZ(1);
  @$pb.TagNumber(2)
  set campaignId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCampaignId() => $_has(1);
  @$pb.TagNumber(2)
  void clearCampaignId() => $_clearField(2);

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

class CampaignServiceEndResponse extends $pb.GeneratedMessage {
  factory CampaignServiceEndResponse({
    Campaign? campaign,
  }) {
    final result = CampaignServiceEndResponse._();
    if (campaign != null) result.campaign = campaign;
    return result;
  }

  CampaignServiceEndResponse._();

  factory CampaignServiceEndResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CampaignServiceEndResponse()..mergeFromBuffer(data, registry);
  factory CampaignServiceEndResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CampaignServiceEndResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CampaignServiceEndResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: CampaignServiceEndResponse.$_createMessage)
    ..aOM<Campaign>(1, _omitFieldNames ? '' : 'campaign',
        subBuilder: Campaign.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CampaignServiceEndResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CampaignServiceEndResponse copyWith(
          void Function(CampaignServiceEndResponse) updates) =>
      super.copyWith(
              (message) => updates(message as CampaignServiceEndResponse))
          as CampaignServiceEndResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use CampaignServiceEndResponse() / CampaignServiceEndResponse.new instead')
  static CampaignServiceEndResponse create() => CampaignServiceEndResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      CampaignServiceEndResponse._();
  @$core.override
  CampaignServiceEndResponse createEmptyInstance() =>
      CampaignServiceEndResponse._();
  @$core.pragma('dart2js:noInline')
  static CampaignServiceEndResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CampaignServiceEndResponse>(
          CampaignServiceEndResponse.$_createMessage);
  static CampaignServiceEndResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Campaign get campaign => $_getN(0);
  @$pb.TagNumber(1)
  set campaign(Campaign value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasCampaign() => $_has(0);
  @$pb.TagNumber(1)
  void clearCampaign() => $_clearField(1);
  @$pb.TagNumber(1)
  Campaign ensureCampaign() => $_ensure(0);
}

class CampaignServiceDeleteRequest extends $pb.GeneratedMessage {
  factory CampaignServiceDeleteRequest({
    $core.String? workspaceId,
    $core.String? campaignId,
    $2.CommandContext? commandContext,
  }) {
    final result = CampaignServiceDeleteRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (campaignId != null) result.campaignId = campaignId;
    if (commandContext != null) result.commandContext = commandContext;
    return result;
  }

  CampaignServiceDeleteRequest._();

  factory CampaignServiceDeleteRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CampaignServiceDeleteRequest()..mergeFromBuffer(data, registry);
  factory CampaignServiceDeleteRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CampaignServiceDeleteRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CampaignServiceDeleteRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: CampaignServiceDeleteRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'campaignId')
    ..aOM<$2.CommandContext>(3, _omitFieldNames ? '' : 'commandContext',
        subBuilder: $2.CommandContext.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CampaignServiceDeleteRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CampaignServiceDeleteRequest copyWith(
          void Function(CampaignServiceDeleteRequest) updates) =>
      super.copyWith(
              (message) => updates(message as CampaignServiceDeleteRequest))
          as CampaignServiceDeleteRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use CampaignServiceDeleteRequest() / CampaignServiceDeleteRequest.new instead')
  static CampaignServiceDeleteRequest create() =>
      CampaignServiceDeleteRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      CampaignServiceDeleteRequest._();
  @$core.override
  CampaignServiceDeleteRequest createEmptyInstance() =>
      CampaignServiceDeleteRequest._();
  @$core.pragma('dart2js:noInline')
  static CampaignServiceDeleteRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CampaignServiceDeleteRequest>(
          CampaignServiceDeleteRequest.$_createMessage);
  static CampaignServiceDeleteRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get campaignId => $_getSZ(1);
  @$pb.TagNumber(2)
  set campaignId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCampaignId() => $_has(1);
  @$pb.TagNumber(2)
  void clearCampaignId() => $_clearField(2);

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

class CampaignServiceDeleteResponse extends $pb.GeneratedMessage {
  factory CampaignServiceDeleteResponse({
    $core.bool? success,
  }) {
    final result = CampaignServiceDeleteResponse._();
    if (success != null) result.success = success;
    return result;
  }

  CampaignServiceDeleteResponse._();

  factory CampaignServiceDeleteResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CampaignServiceDeleteResponse()..mergeFromBuffer(data, registry);
  factory CampaignServiceDeleteResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CampaignServiceDeleteResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CampaignServiceDeleteResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: CampaignServiceDeleteResponse.$_createMessage)
    ..aOB(1, _omitFieldNames ? '' : 'success')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CampaignServiceDeleteResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CampaignServiceDeleteResponse copyWith(
          void Function(CampaignServiceDeleteResponse) updates) =>
      super.copyWith(
              (message) => updates(message as CampaignServiceDeleteResponse))
          as CampaignServiceDeleteResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use CampaignServiceDeleteResponse() / CampaignServiceDeleteResponse.new instead')
  static CampaignServiceDeleteResponse create() =>
      CampaignServiceDeleteResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      CampaignServiceDeleteResponse._();
  @$core.override
  CampaignServiceDeleteResponse createEmptyInstance() =>
      CampaignServiceDeleteResponse._();
  @$core.pragma('dart2js:noInline')
  static CampaignServiceDeleteResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CampaignServiceDeleteResponse>(
          CampaignServiceDeleteResponse.$_createMessage);
  static CampaignServiceDeleteResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get success => $_getBF(0);
  @$pb.TagNumber(1)
  set success($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSuccess() => $_has(0);
  @$pb.TagNumber(1)
  void clearSuccess() => $_clearField(1);
}

class CampaignServiceDuplicateRequest extends $pb.GeneratedMessage {
  factory CampaignServiceDuplicateRequest({
    $core.String? workspaceId,
    $core.String? campaignId,
    $core.String? newTitle,
    $2.CommandContext? commandContext,
  }) {
    final result = CampaignServiceDuplicateRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (campaignId != null) result.campaignId = campaignId;
    if (newTitle != null) result.newTitle = newTitle;
    if (commandContext != null) result.commandContext = commandContext;
    return result;
  }

  CampaignServiceDuplicateRequest._();

  factory CampaignServiceDuplicateRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CampaignServiceDuplicateRequest()..mergeFromBuffer(data, registry);
  factory CampaignServiceDuplicateRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CampaignServiceDuplicateRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CampaignServiceDuplicateRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: CampaignServiceDuplicateRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'campaignId')
    ..aOS(3, _omitFieldNames ? '' : 'newTitle')
    ..aOM<$2.CommandContext>(4, _omitFieldNames ? '' : 'commandContext',
        subBuilder: $2.CommandContext.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CampaignServiceDuplicateRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CampaignServiceDuplicateRequest copyWith(
          void Function(CampaignServiceDuplicateRequest) updates) =>
      super.copyWith(
              (message) => updates(message as CampaignServiceDuplicateRequest))
          as CampaignServiceDuplicateRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use CampaignServiceDuplicateRequest() / CampaignServiceDuplicateRequest.new instead')
  static CampaignServiceDuplicateRequest create() =>
      CampaignServiceDuplicateRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      CampaignServiceDuplicateRequest._();
  @$core.override
  CampaignServiceDuplicateRequest createEmptyInstance() =>
      CampaignServiceDuplicateRequest._();
  @$core.pragma('dart2js:noInline')
  static CampaignServiceDuplicateRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CampaignServiceDuplicateRequest>(
          CampaignServiceDuplicateRequest.$_createMessage);
  static CampaignServiceDuplicateRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get campaignId => $_getSZ(1);
  @$pb.TagNumber(2)
  set campaignId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCampaignId() => $_has(1);
  @$pb.TagNumber(2)
  void clearCampaignId() => $_clearField(2);

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

class CampaignServiceDuplicateResponse extends $pb.GeneratedMessage {
  factory CampaignServiceDuplicateResponse({
    Campaign? campaign,
  }) {
    final result = CampaignServiceDuplicateResponse._();
    if (campaign != null) result.campaign = campaign;
    return result;
  }

  CampaignServiceDuplicateResponse._();

  factory CampaignServiceDuplicateResponse.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CampaignServiceDuplicateResponse()..mergeFromBuffer(data, registry);
  factory CampaignServiceDuplicateResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CampaignServiceDuplicateResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CampaignServiceDuplicateResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: CampaignServiceDuplicateResponse.$_createMessage)
    ..aOM<Campaign>(1, _omitFieldNames ? '' : 'campaign',
        subBuilder: Campaign.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CampaignServiceDuplicateResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CampaignServiceDuplicateResponse copyWith(
          void Function(CampaignServiceDuplicateResponse) updates) =>
      super.copyWith(
              (message) => updates(message as CampaignServiceDuplicateResponse))
          as CampaignServiceDuplicateResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use CampaignServiceDuplicateResponse() / CampaignServiceDuplicateResponse.new instead')
  static CampaignServiceDuplicateResponse create() =>
      CampaignServiceDuplicateResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      CampaignServiceDuplicateResponse._();
  @$core.override
  CampaignServiceDuplicateResponse createEmptyInstance() =>
      CampaignServiceDuplicateResponse._();
  @$core.pragma('dart2js:noInline')
  static CampaignServiceDuplicateResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CampaignServiceDuplicateResponse>(
          CampaignServiceDuplicateResponse.$_createMessage);
  static CampaignServiceDuplicateResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Campaign get campaign => $_getN(0);
  @$pb.TagNumber(1)
  set campaign(Campaign value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasCampaign() => $_has(0);
  @$pb.TagNumber(1)
  void clearCampaign() => $_clearField(1);
  @$pb.TagNumber(1)
  Campaign ensureCampaign() => $_ensure(0);
}

class CampaignServiceExportReportRequest extends $pb.GeneratedMessage {
  factory CampaignServiceExportReportRequest({
    $core.String? workspaceId,
    $core.String? campaignId,
    $core.String? format,
  }) {
    final result = CampaignServiceExportReportRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (campaignId != null) result.campaignId = campaignId;
    if (format != null) result.format = format;
    return result;
  }

  CampaignServiceExportReportRequest._();

  factory CampaignServiceExportReportRequest.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CampaignServiceExportReportRequest()..mergeFromBuffer(data, registry);
  factory CampaignServiceExportReportRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CampaignServiceExportReportRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CampaignServiceExportReportRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: CampaignServiceExportReportRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'campaignId')
    ..aOS(3, _omitFieldNames ? '' : 'format')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CampaignServiceExportReportRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CampaignServiceExportReportRequest copyWith(
          void Function(CampaignServiceExportReportRequest) updates) =>
      super.copyWith((message) =>
              updates(message as CampaignServiceExportReportRequest))
          as CampaignServiceExportReportRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use CampaignServiceExportReportRequest() / CampaignServiceExportReportRequest.new instead')
  static CampaignServiceExportReportRequest create() =>
      CampaignServiceExportReportRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      CampaignServiceExportReportRequest._();
  @$core.override
  CampaignServiceExportReportRequest createEmptyInstance() =>
      CampaignServiceExportReportRequest._();
  @$core.pragma('dart2js:noInline')
  static CampaignServiceExportReportRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CampaignServiceExportReportRequest>(
          CampaignServiceExportReportRequest.$_createMessage);
  static CampaignServiceExportReportRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get campaignId => $_getSZ(1);
  @$pb.TagNumber(2)
  set campaignId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCampaignId() => $_has(1);
  @$pb.TagNumber(2)
  void clearCampaignId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get format => $_getSZ(2);
  @$pb.TagNumber(3)
  set format($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasFormat() => $_has(2);
  @$pb.TagNumber(3)
  void clearFormat() => $_clearField(3);
}

class CampaignServiceExportReportResponse extends $pb.GeneratedMessage {
  factory CampaignServiceExportReportResponse({
    $core.String? downloadUrl,
    $core.String? exportId,
  }) {
    final result = CampaignServiceExportReportResponse._();
    if (downloadUrl != null) result.downloadUrl = downloadUrl;
    if (exportId != null) result.exportId = exportId;
    return result;
  }

  CampaignServiceExportReportResponse._();

  factory CampaignServiceExportReportResponse.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CampaignServiceExportReportResponse()..mergeFromBuffer(data, registry);
  factory CampaignServiceExportReportResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CampaignServiceExportReportResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CampaignServiceExportReportResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: CampaignServiceExportReportResponse.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'downloadUrl')
    ..aOS(2, _omitFieldNames ? '' : 'exportId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CampaignServiceExportReportResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CampaignServiceExportReportResponse copyWith(
          void Function(CampaignServiceExportReportResponse) updates) =>
      super.copyWith((message) =>
              updates(message as CampaignServiceExportReportResponse))
          as CampaignServiceExportReportResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use CampaignServiceExportReportResponse() / CampaignServiceExportReportResponse.new instead')
  static CampaignServiceExportReportResponse create() =>
      CampaignServiceExportReportResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      CampaignServiceExportReportResponse._();
  @$core.override
  CampaignServiceExportReportResponse createEmptyInstance() =>
      CampaignServiceExportReportResponse._();
  @$core.pragma('dart2js:noInline')
  static CampaignServiceExportReportResponse getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
              CampaignServiceExportReportResponse>(
          CampaignServiceExportReportResponse.$_createMessage);
  static CampaignServiceExportReportResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get downloadUrl => $_getSZ(0);
  @$pb.TagNumber(1)
  set downloadUrl($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasDownloadUrl() => $_has(0);
  @$pb.TagNumber(1)
  void clearDownloadUrl() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get exportId => $_getSZ(1);
  @$pb.TagNumber(2)
  set exportId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasExportId() => $_has(1);
  @$pb.TagNumber(2)
  void clearExportId() => $_clearField(2);
}

class CampaignServiceAddCostRequest extends $pb.GeneratedMessage {
  factory CampaignServiceAddCostRequest({
    $core.String? workspaceId,
    $core.String? campaignId,
    $core.String? costType,
    $core.String? amount,
    $core.String? currency,
    $core.String? description,
    $core.String? effectiveDate,
    $2.CommandContext? commandContext,
  }) {
    final result = CampaignServiceAddCostRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (campaignId != null) result.campaignId = campaignId;
    if (costType != null) result.costType = costType;
    if (amount != null) result.amount = amount;
    if (currency != null) result.currency = currency;
    if (description != null) result.description = description;
    if (effectiveDate != null) result.effectiveDate = effectiveDate;
    if (commandContext != null) result.commandContext = commandContext;
    return result;
  }

  CampaignServiceAddCostRequest._();

  factory CampaignServiceAddCostRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CampaignServiceAddCostRequest()..mergeFromBuffer(data, registry);
  factory CampaignServiceAddCostRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CampaignServiceAddCostRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CampaignServiceAddCostRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: CampaignServiceAddCostRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'campaignId')
    ..aOS(3, _omitFieldNames ? '' : 'costType')
    ..aOS(4, _omitFieldNames ? '' : 'amount')
    ..aOS(5, _omitFieldNames ? '' : 'currency')
    ..aOS(6, _omitFieldNames ? '' : 'description')
    ..aOS(7, _omitFieldNames ? '' : 'effectiveDate')
    ..aOM<$2.CommandContext>(8, _omitFieldNames ? '' : 'commandContext',
        subBuilder: $2.CommandContext.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CampaignServiceAddCostRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CampaignServiceAddCostRequest copyWith(
          void Function(CampaignServiceAddCostRequest) updates) =>
      super.copyWith(
              (message) => updates(message as CampaignServiceAddCostRequest))
          as CampaignServiceAddCostRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use CampaignServiceAddCostRequest() / CampaignServiceAddCostRequest.new instead')
  static CampaignServiceAddCostRequest create() =>
      CampaignServiceAddCostRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      CampaignServiceAddCostRequest._();
  @$core.override
  CampaignServiceAddCostRequest createEmptyInstance() =>
      CampaignServiceAddCostRequest._();
  @$core.pragma('dart2js:noInline')
  static CampaignServiceAddCostRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CampaignServiceAddCostRequest>(
          CampaignServiceAddCostRequest.$_createMessage);
  static CampaignServiceAddCostRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get campaignId => $_getSZ(1);
  @$pb.TagNumber(2)
  set campaignId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCampaignId() => $_has(1);
  @$pb.TagNumber(2)
  void clearCampaignId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get costType => $_getSZ(2);
  @$pb.TagNumber(3)
  set costType($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasCostType() => $_has(2);
  @$pb.TagNumber(3)
  void clearCostType() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get amount => $_getSZ(3);
  @$pb.TagNumber(4)
  set amount($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasAmount() => $_has(3);
  @$pb.TagNumber(4)
  void clearAmount() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get currency => $_getSZ(4);
  @$pb.TagNumber(5)
  set currency($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasCurrency() => $_has(4);
  @$pb.TagNumber(5)
  void clearCurrency() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get description => $_getSZ(5);
  @$pb.TagNumber(6)
  set description($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasDescription() => $_has(5);
  @$pb.TagNumber(6)
  void clearDescription() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get effectiveDate => $_getSZ(6);
  @$pb.TagNumber(7)
  set effectiveDate($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasEffectiveDate() => $_has(6);
  @$pb.TagNumber(7)
  void clearEffectiveDate() => $_clearField(7);

  @$pb.TagNumber(8)
  $2.CommandContext get commandContext => $_getN(7);
  @$pb.TagNumber(8)
  set commandContext($2.CommandContext value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasCommandContext() => $_has(7);
  @$pb.TagNumber(8)
  void clearCommandContext() => $_clearField(8);
  @$pb.TagNumber(8)
  $2.CommandContext ensureCommandContext() => $_ensure(7);
}

class CampaignServiceAddCostResponse extends $pb.GeneratedMessage {
  factory CampaignServiceAddCostResponse({
    $core.String? costItemId,
    $core.String? campaignId,
    $core.String? totalSpend,
    $core.String? budget,
    $core.String? budgetUtilizationPct,
    $core.bool? warningEmitted,
    $core.bool? alertEmitted,
  }) {
    final result = CampaignServiceAddCostResponse._();
    if (costItemId != null) result.costItemId = costItemId;
    if (campaignId != null) result.campaignId = campaignId;
    if (totalSpend != null) result.totalSpend = totalSpend;
    if (budget != null) result.budget = budget;
    if (budgetUtilizationPct != null)
      result.budgetUtilizationPct = budgetUtilizationPct;
    if (warningEmitted != null) result.warningEmitted = warningEmitted;
    if (alertEmitted != null) result.alertEmitted = alertEmitted;
    return result;
  }

  CampaignServiceAddCostResponse._();

  factory CampaignServiceAddCostResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CampaignServiceAddCostResponse()..mergeFromBuffer(data, registry);
  factory CampaignServiceAddCostResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CampaignServiceAddCostResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CampaignServiceAddCostResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: CampaignServiceAddCostResponse.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'costItemId')
    ..aOS(2, _omitFieldNames ? '' : 'campaignId')
    ..aOS(3, _omitFieldNames ? '' : 'totalSpend')
    ..aOS(4, _omitFieldNames ? '' : 'budget')
    ..aOS(5, _omitFieldNames ? '' : 'budgetUtilizationPct')
    ..aOB(6, _omitFieldNames ? '' : 'warningEmitted')
    ..aOB(7, _omitFieldNames ? '' : 'alertEmitted')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CampaignServiceAddCostResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CampaignServiceAddCostResponse copyWith(
          void Function(CampaignServiceAddCostResponse) updates) =>
      super.copyWith(
              (message) => updates(message as CampaignServiceAddCostResponse))
          as CampaignServiceAddCostResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use CampaignServiceAddCostResponse() / CampaignServiceAddCostResponse.new instead')
  static CampaignServiceAddCostResponse create() =>
      CampaignServiceAddCostResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      CampaignServiceAddCostResponse._();
  @$core.override
  CampaignServiceAddCostResponse createEmptyInstance() =>
      CampaignServiceAddCostResponse._();
  @$core.pragma('dart2js:noInline')
  static CampaignServiceAddCostResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CampaignServiceAddCostResponse>(
          CampaignServiceAddCostResponse.$_createMessage);
  static CampaignServiceAddCostResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get costItemId => $_getSZ(0);
  @$pb.TagNumber(1)
  set costItemId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCostItemId() => $_has(0);
  @$pb.TagNumber(1)
  void clearCostItemId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get campaignId => $_getSZ(1);
  @$pb.TagNumber(2)
  set campaignId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCampaignId() => $_has(1);
  @$pb.TagNumber(2)
  void clearCampaignId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get totalSpend => $_getSZ(2);
  @$pb.TagNumber(3)
  set totalSpend($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasTotalSpend() => $_has(2);
  @$pb.TagNumber(3)
  void clearTotalSpend() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get budget => $_getSZ(3);
  @$pb.TagNumber(4)
  set budget($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasBudget() => $_has(3);
  @$pb.TagNumber(4)
  void clearBudget() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get budgetUtilizationPct => $_getSZ(4);
  @$pb.TagNumber(5)
  set budgetUtilizationPct($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasBudgetUtilizationPct() => $_has(4);
  @$pb.TagNumber(5)
  void clearBudgetUtilizationPct() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.bool get warningEmitted => $_getBF(5);
  @$pb.TagNumber(6)
  set warningEmitted($core.bool value) => $_setBool(5, value);
  @$pb.TagNumber(6)
  $core.bool hasWarningEmitted() => $_has(5);
  @$pb.TagNumber(6)
  void clearWarningEmitted() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.bool get alertEmitted => $_getBF(6);
  @$pb.TagNumber(7)
  set alertEmitted($core.bool value) => $_setBool(6, value);
  @$pb.TagNumber(7)
  $core.bool hasAlertEmitted() => $_has(6);
  @$pb.TagNumber(7)
  void clearAlertEmitted() => $_clearField(7);
}

class CampaignServiceGetCostsRequest extends $pb.GeneratedMessage {
  factory CampaignServiceGetCostsRequest({
    $core.String? workspaceId,
    $core.String? campaignId,
  }) {
    final result = CampaignServiceGetCostsRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (campaignId != null) result.campaignId = campaignId;
    return result;
  }

  CampaignServiceGetCostsRequest._();

  factory CampaignServiceGetCostsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CampaignServiceGetCostsRequest()..mergeFromBuffer(data, registry);
  factory CampaignServiceGetCostsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CampaignServiceGetCostsRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CampaignServiceGetCostsRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: CampaignServiceGetCostsRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'campaignId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CampaignServiceGetCostsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CampaignServiceGetCostsRequest copyWith(
          void Function(CampaignServiceGetCostsRequest) updates) =>
      super.copyWith(
              (message) => updates(message as CampaignServiceGetCostsRequest))
          as CampaignServiceGetCostsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use CampaignServiceGetCostsRequest() / CampaignServiceGetCostsRequest.new instead')
  static CampaignServiceGetCostsRequest create() =>
      CampaignServiceGetCostsRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      CampaignServiceGetCostsRequest._();
  @$core.override
  CampaignServiceGetCostsRequest createEmptyInstance() =>
      CampaignServiceGetCostsRequest._();
  @$core.pragma('dart2js:noInline')
  static CampaignServiceGetCostsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CampaignServiceGetCostsRequest>(
          CampaignServiceGetCostsRequest.$_createMessage);
  static CampaignServiceGetCostsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get campaignId => $_getSZ(1);
  @$pb.TagNumber(2)
  set campaignId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCampaignId() => $_has(1);
  @$pb.TagNumber(2)
  void clearCampaignId() => $_clearField(2);
}

class CampaignCostItem extends $pb.GeneratedMessage {
  factory CampaignCostItem({
    $core.String? costItemId,
    $core.String? costType,
    $core.String? amount,
    $core.String? currency,
    $core.String? description,
    $core.String? effectiveDate,
    $1.Timestamp? createdAt,
  }) {
    final result = CampaignCostItem._();
    if (costItemId != null) result.costItemId = costItemId;
    if (costType != null) result.costType = costType;
    if (amount != null) result.amount = amount;
    if (currency != null) result.currency = currency;
    if (description != null) result.description = description;
    if (effectiveDate != null) result.effectiveDate = effectiveDate;
    if (createdAt != null) result.createdAt = createdAt;
    return result;
  }

  CampaignCostItem._();

  factory CampaignCostItem.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CampaignCostItem()..mergeFromBuffer(data, registry);
  factory CampaignCostItem.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CampaignCostItem()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CampaignCostItem',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: CampaignCostItem.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'costItemId')
    ..aOS(2, _omitFieldNames ? '' : 'costType')
    ..aOS(3, _omitFieldNames ? '' : 'amount')
    ..aOS(4, _omitFieldNames ? '' : 'currency')
    ..aOS(5, _omitFieldNames ? '' : 'description')
    ..aOS(6, _omitFieldNames ? '' : 'effectiveDate')
    ..aOM<$1.Timestamp>(7, _omitFieldNames ? '' : 'createdAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CampaignCostItem clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CampaignCostItem copyWith(void Function(CampaignCostItem) updates) =>
      super.copyWith((message) => updates(message as CampaignCostItem))
          as CampaignCostItem;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use CampaignCostItem() / CampaignCostItem.new instead')
  static CampaignCostItem create() => CampaignCostItem._();
  static $pb.GeneratedMessage $_createMessage() => CampaignCostItem._();
  @$core.override
  CampaignCostItem createEmptyInstance() => CampaignCostItem._();
  @$core.pragma('dart2js:noInline')
  static CampaignCostItem getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CampaignCostItem>(
          CampaignCostItem.$_createMessage);
  static CampaignCostItem? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get costItemId => $_getSZ(0);
  @$pb.TagNumber(1)
  set costItemId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCostItemId() => $_has(0);
  @$pb.TagNumber(1)
  void clearCostItemId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get costType => $_getSZ(1);
  @$pb.TagNumber(2)
  set costType($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCostType() => $_has(1);
  @$pb.TagNumber(2)
  void clearCostType() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get amount => $_getSZ(2);
  @$pb.TagNumber(3)
  set amount($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasAmount() => $_has(2);
  @$pb.TagNumber(3)
  void clearAmount() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get currency => $_getSZ(3);
  @$pb.TagNumber(4)
  set currency($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasCurrency() => $_has(3);
  @$pb.TagNumber(4)
  void clearCurrency() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get description => $_getSZ(4);
  @$pb.TagNumber(5)
  set description($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasDescription() => $_has(4);
  @$pb.TagNumber(5)
  void clearDescription() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get effectiveDate => $_getSZ(5);
  @$pb.TagNumber(6)
  set effectiveDate($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasEffectiveDate() => $_has(5);
  @$pb.TagNumber(6)
  void clearEffectiveDate() => $_clearField(6);

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
}

class CampaignServiceGetCostsResponse extends $pb.GeneratedMessage {
  factory CampaignServiceGetCostsResponse({
    $core.String? campaignId,
    $core.String? totalSpend,
    $core.String? budget,
    $core.String? remainingBudget,
    $core.String? budgetCurrency,
    $core.Iterable<CampaignCostItem>? items,
  }) {
    final result = CampaignServiceGetCostsResponse._();
    if (campaignId != null) result.campaignId = campaignId;
    if (totalSpend != null) result.totalSpend = totalSpend;
    if (budget != null) result.budget = budget;
    if (remainingBudget != null) result.remainingBudget = remainingBudget;
    if (budgetCurrency != null) result.budgetCurrency = budgetCurrency;
    if (items != null) result.items.addAll(items);
    return result;
  }

  CampaignServiceGetCostsResponse._();

  factory CampaignServiceGetCostsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CampaignServiceGetCostsResponse()..mergeFromBuffer(data, registry);
  factory CampaignServiceGetCostsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CampaignServiceGetCostsResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CampaignServiceGetCostsResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: CampaignServiceGetCostsResponse.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'campaignId')
    ..aOS(2, _omitFieldNames ? '' : 'totalSpend')
    ..aOS(3, _omitFieldNames ? '' : 'budget')
    ..aOS(4, _omitFieldNames ? '' : 'remainingBudget')
    ..aOS(5, _omitFieldNames ? '' : 'budgetCurrency')
    ..pPM<CampaignCostItem>(6, _omitFieldNames ? '' : 'items',
        subBuilder: CampaignCostItem.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CampaignServiceGetCostsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CampaignServiceGetCostsResponse copyWith(
          void Function(CampaignServiceGetCostsResponse) updates) =>
      super.copyWith(
              (message) => updates(message as CampaignServiceGetCostsResponse))
          as CampaignServiceGetCostsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use CampaignServiceGetCostsResponse() / CampaignServiceGetCostsResponse.new instead')
  static CampaignServiceGetCostsResponse create() =>
      CampaignServiceGetCostsResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      CampaignServiceGetCostsResponse._();
  @$core.override
  CampaignServiceGetCostsResponse createEmptyInstance() =>
      CampaignServiceGetCostsResponse._();
  @$core.pragma('dart2js:noInline')
  static CampaignServiceGetCostsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CampaignServiceGetCostsResponse>(
          CampaignServiceGetCostsResponse.$_createMessage);
  static CampaignServiceGetCostsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get campaignId => $_getSZ(0);
  @$pb.TagNumber(1)
  set campaignId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCampaignId() => $_has(0);
  @$pb.TagNumber(1)
  void clearCampaignId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get totalSpend => $_getSZ(1);
  @$pb.TagNumber(2)
  set totalSpend($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTotalSpend() => $_has(1);
  @$pb.TagNumber(2)
  void clearTotalSpend() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get budget => $_getSZ(2);
  @$pb.TagNumber(3)
  set budget($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasBudget() => $_has(2);
  @$pb.TagNumber(3)
  void clearBudget() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get remainingBudget => $_getSZ(3);
  @$pb.TagNumber(4)
  set remainingBudget($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasRemainingBudget() => $_has(3);
  @$pb.TagNumber(4)
  void clearRemainingBudget() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get budgetCurrency => $_getSZ(4);
  @$pb.TagNumber(5)
  set budgetCurrency($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasBudgetCurrency() => $_has(4);
  @$pb.TagNumber(5)
  void clearBudgetCurrency() => $_clearField(5);

  @$pb.TagNumber(6)
  $pb.PbList<CampaignCostItem> get items => $_getList(5);
}

class CampaignServiceGetFunnelRequest extends $pb.GeneratedMessage {
  factory CampaignServiceGetFunnelRequest({
    $core.String? workspaceId,
    $core.String? campaignId,
  }) {
    final result = CampaignServiceGetFunnelRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (campaignId != null) result.campaignId = campaignId;
    return result;
  }

  CampaignServiceGetFunnelRequest._();

  factory CampaignServiceGetFunnelRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CampaignServiceGetFunnelRequest()..mergeFromBuffer(data, registry);
  factory CampaignServiceGetFunnelRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CampaignServiceGetFunnelRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CampaignServiceGetFunnelRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: CampaignServiceGetFunnelRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'campaignId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CampaignServiceGetFunnelRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CampaignServiceGetFunnelRequest copyWith(
          void Function(CampaignServiceGetFunnelRequest) updates) =>
      super.copyWith(
              (message) => updates(message as CampaignServiceGetFunnelRequest))
          as CampaignServiceGetFunnelRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use CampaignServiceGetFunnelRequest() / CampaignServiceGetFunnelRequest.new instead')
  static CampaignServiceGetFunnelRequest create() =>
      CampaignServiceGetFunnelRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      CampaignServiceGetFunnelRequest._();
  @$core.override
  CampaignServiceGetFunnelRequest createEmptyInstance() =>
      CampaignServiceGetFunnelRequest._();
  @$core.pragma('dart2js:noInline')
  static CampaignServiceGetFunnelRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CampaignServiceGetFunnelRequest>(
          CampaignServiceGetFunnelRequest.$_createMessage);
  static CampaignServiceGetFunnelRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get campaignId => $_getSZ(1);
  @$pb.TagNumber(2)
  set campaignId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCampaignId() => $_has(1);
  @$pb.TagNumber(2)
  void clearCampaignId() => $_clearField(2);
}

class CampaignServiceGetFunnelResponse extends $pb.GeneratedMessage {
  factory CampaignServiceGetFunnelResponse({
    $core.String? campaignId,
    $fixnum.Int64? impressions,
    $fixnum.Int64? clicks,
    $fixnum.Int64? cartAdds,
    $fixnum.Int64? checkouts,
    $fixnum.Int64? completedOrders,
    $core.String? dropoffRate,
  }) {
    final result = CampaignServiceGetFunnelResponse._();
    if (campaignId != null) result.campaignId = campaignId;
    if (impressions != null) result.impressions = impressions;
    if (clicks != null) result.clicks = clicks;
    if (cartAdds != null) result.cartAdds = cartAdds;
    if (checkouts != null) result.checkouts = checkouts;
    if (completedOrders != null) result.completedOrders = completedOrders;
    if (dropoffRate != null) result.dropoffRate = dropoffRate;
    return result;
  }

  CampaignServiceGetFunnelResponse._();

  factory CampaignServiceGetFunnelResponse.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CampaignServiceGetFunnelResponse()..mergeFromBuffer(data, registry);
  factory CampaignServiceGetFunnelResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CampaignServiceGetFunnelResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CampaignServiceGetFunnelResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: CampaignServiceGetFunnelResponse.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'campaignId')
    ..aInt64(2, _omitFieldNames ? '' : 'impressions')
    ..aInt64(3, _omitFieldNames ? '' : 'clicks')
    ..aInt64(4, _omitFieldNames ? '' : 'cartAdds')
    ..aInt64(5, _omitFieldNames ? '' : 'checkouts')
    ..aInt64(6, _omitFieldNames ? '' : 'completedOrders')
    ..aOS(7, _omitFieldNames ? '' : 'dropoffRate')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CampaignServiceGetFunnelResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CampaignServiceGetFunnelResponse copyWith(
          void Function(CampaignServiceGetFunnelResponse) updates) =>
      super.copyWith(
              (message) => updates(message as CampaignServiceGetFunnelResponse))
          as CampaignServiceGetFunnelResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use CampaignServiceGetFunnelResponse() / CampaignServiceGetFunnelResponse.new instead')
  static CampaignServiceGetFunnelResponse create() =>
      CampaignServiceGetFunnelResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      CampaignServiceGetFunnelResponse._();
  @$core.override
  CampaignServiceGetFunnelResponse createEmptyInstance() =>
      CampaignServiceGetFunnelResponse._();
  @$core.pragma('dart2js:noInline')
  static CampaignServiceGetFunnelResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CampaignServiceGetFunnelResponse>(
          CampaignServiceGetFunnelResponse.$_createMessage);
  static CampaignServiceGetFunnelResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get campaignId => $_getSZ(0);
  @$pb.TagNumber(1)
  set campaignId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCampaignId() => $_has(0);
  @$pb.TagNumber(1)
  void clearCampaignId() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get impressions => $_getI64(1);
  @$pb.TagNumber(2)
  set impressions($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasImpressions() => $_has(1);
  @$pb.TagNumber(2)
  void clearImpressions() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get clicks => $_getI64(2);
  @$pb.TagNumber(3)
  set clicks($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasClicks() => $_has(2);
  @$pb.TagNumber(3)
  void clearClicks() => $_clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get cartAdds => $_getI64(3);
  @$pb.TagNumber(4)
  set cartAdds($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasCartAdds() => $_has(3);
  @$pb.TagNumber(4)
  void clearCartAdds() => $_clearField(4);

  @$pb.TagNumber(5)
  $fixnum.Int64 get checkouts => $_getI64(4);
  @$pb.TagNumber(5)
  set checkouts($fixnum.Int64 value) => $_setInt64(4, value);
  @$pb.TagNumber(5)
  $core.bool hasCheckouts() => $_has(4);
  @$pb.TagNumber(5)
  void clearCheckouts() => $_clearField(5);

  @$pb.TagNumber(6)
  $fixnum.Int64 get completedOrders => $_getI64(5);
  @$pb.TagNumber(6)
  set completedOrders($fixnum.Int64 value) => $_setInt64(5, value);
  @$pb.TagNumber(6)
  $core.bool hasCompletedOrders() => $_has(5);
  @$pb.TagNumber(6)
  void clearCompletedOrders() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get dropoffRate => $_getSZ(6);
  @$pb.TagNumber(7)
  set dropoffRate($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasDropoffRate() => $_has(6);
  @$pb.TagNumber(7)
  void clearDropoffRate() => $_clearField(7);
}

class CampaignServiceGetMetricsRequest extends $pb.GeneratedMessage {
  factory CampaignServiceGetMetricsRequest({
    $core.String? workspaceId,
    $core.String? campaignId,
  }) {
    final result = CampaignServiceGetMetricsRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (campaignId != null) result.campaignId = campaignId;
    return result;
  }

  CampaignServiceGetMetricsRequest._();

  factory CampaignServiceGetMetricsRequest.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CampaignServiceGetMetricsRequest()..mergeFromBuffer(data, registry);
  factory CampaignServiceGetMetricsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CampaignServiceGetMetricsRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CampaignServiceGetMetricsRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: CampaignServiceGetMetricsRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'campaignId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CampaignServiceGetMetricsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CampaignServiceGetMetricsRequest copyWith(
          void Function(CampaignServiceGetMetricsRequest) updates) =>
      super.copyWith(
              (message) => updates(message as CampaignServiceGetMetricsRequest))
          as CampaignServiceGetMetricsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use CampaignServiceGetMetricsRequest() / CampaignServiceGetMetricsRequest.new instead')
  static CampaignServiceGetMetricsRequest create() =>
      CampaignServiceGetMetricsRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      CampaignServiceGetMetricsRequest._();
  @$core.override
  CampaignServiceGetMetricsRequest createEmptyInstance() =>
      CampaignServiceGetMetricsRequest._();
  @$core.pragma('dart2js:noInline')
  static CampaignServiceGetMetricsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CampaignServiceGetMetricsRequest>(
          CampaignServiceGetMetricsRequest.$_createMessage);
  static CampaignServiceGetMetricsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get campaignId => $_getSZ(1);
  @$pb.TagNumber(2)
  set campaignId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCampaignId() => $_has(1);
  @$pb.TagNumber(2)
  void clearCampaignId() => $_clearField(2);
}

class CampaignServiceGetMetricsResponse extends $pb.GeneratedMessage {
  factory CampaignServiceGetMetricsResponse({
    $core.String? campaignId,
    $core.String? grossRevenue,
    $core.String? totalCosts,
    $core.String? netProfit,
    $core.String? roas,
    $core.String? currency,
    $core.int? ordersCount,
  }) {
    final result = CampaignServiceGetMetricsResponse._();
    if (campaignId != null) result.campaignId = campaignId;
    if (grossRevenue != null) result.grossRevenue = grossRevenue;
    if (totalCosts != null) result.totalCosts = totalCosts;
    if (netProfit != null) result.netProfit = netProfit;
    if (roas != null) result.roas = roas;
    if (currency != null) result.currency = currency;
    if (ordersCount != null) result.ordersCount = ordersCount;
    return result;
  }

  CampaignServiceGetMetricsResponse._();

  factory CampaignServiceGetMetricsResponse.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CampaignServiceGetMetricsResponse()..mergeFromBuffer(data, registry);
  factory CampaignServiceGetMetricsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CampaignServiceGetMetricsResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CampaignServiceGetMetricsResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: CampaignServiceGetMetricsResponse.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'campaignId')
    ..aOS(2, _omitFieldNames ? '' : 'grossRevenue')
    ..aOS(3, _omitFieldNames ? '' : 'totalCosts')
    ..aOS(4, _omitFieldNames ? '' : 'netProfit')
    ..aOS(5, _omitFieldNames ? '' : 'roas')
    ..aOS(6, _omitFieldNames ? '' : 'currency')
    ..aI(7, _omitFieldNames ? '' : 'ordersCount')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CampaignServiceGetMetricsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CampaignServiceGetMetricsResponse copyWith(
          void Function(CampaignServiceGetMetricsResponse) updates) =>
      super.copyWith((message) =>
              updates(message as CampaignServiceGetMetricsResponse))
          as CampaignServiceGetMetricsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use CampaignServiceGetMetricsResponse() / CampaignServiceGetMetricsResponse.new instead')
  static CampaignServiceGetMetricsResponse create() =>
      CampaignServiceGetMetricsResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      CampaignServiceGetMetricsResponse._();
  @$core.override
  CampaignServiceGetMetricsResponse createEmptyInstance() =>
      CampaignServiceGetMetricsResponse._();
  @$core.pragma('dart2js:noInline')
  static CampaignServiceGetMetricsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CampaignServiceGetMetricsResponse>(
          CampaignServiceGetMetricsResponse.$_createMessage);
  static CampaignServiceGetMetricsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get campaignId => $_getSZ(0);
  @$pb.TagNumber(1)
  set campaignId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCampaignId() => $_has(0);
  @$pb.TagNumber(1)
  void clearCampaignId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get grossRevenue => $_getSZ(1);
  @$pb.TagNumber(2)
  set grossRevenue($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasGrossRevenue() => $_has(1);
  @$pb.TagNumber(2)
  void clearGrossRevenue() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get totalCosts => $_getSZ(2);
  @$pb.TagNumber(3)
  set totalCosts($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasTotalCosts() => $_has(2);
  @$pb.TagNumber(3)
  void clearTotalCosts() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get netProfit => $_getSZ(3);
  @$pb.TagNumber(4)
  set netProfit($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasNetProfit() => $_has(3);
  @$pb.TagNumber(4)
  void clearNetProfit() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get roas => $_getSZ(4);
  @$pb.TagNumber(5)
  set roas($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasRoas() => $_has(4);
  @$pb.TagNumber(5)
  void clearRoas() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get currency => $_getSZ(5);
  @$pb.TagNumber(6)
  set currency($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasCurrency() => $_has(5);
  @$pb.TagNumber(6)
  void clearCurrency() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.int get ordersCount => $_getIZ(6);
  @$pb.TagNumber(7)
  set ordersCount($core.int value) => $_setSignedInt32(6, value);
  @$pb.TagNumber(7)
  $core.bool hasOrdersCount() => $_has(6);
  @$pb.TagNumber(7)
  void clearOrdersCount() => $_clearField(7);
}

class CampaignServiceGetLinkedContentRequest extends $pb.GeneratedMessage {
  factory CampaignServiceGetLinkedContentRequest({
    $core.String? workspaceId,
    $core.String? campaignId,
  }) {
    final result = CampaignServiceGetLinkedContentRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (campaignId != null) result.campaignId = campaignId;
    return result;
  }

  CampaignServiceGetLinkedContentRequest._();

  factory CampaignServiceGetLinkedContentRequest.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CampaignServiceGetLinkedContentRequest()..mergeFromBuffer(data, registry);
  factory CampaignServiceGetLinkedContentRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CampaignServiceGetLinkedContentRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CampaignServiceGetLinkedContentRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance:
          CampaignServiceGetLinkedContentRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'campaignId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CampaignServiceGetLinkedContentRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CampaignServiceGetLinkedContentRequest copyWith(
          void Function(CampaignServiceGetLinkedContentRequest) updates) =>
      super.copyWith((message) =>
              updates(message as CampaignServiceGetLinkedContentRequest))
          as CampaignServiceGetLinkedContentRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use CampaignServiceGetLinkedContentRequest() / CampaignServiceGetLinkedContentRequest.new instead')
  static CampaignServiceGetLinkedContentRequest create() =>
      CampaignServiceGetLinkedContentRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      CampaignServiceGetLinkedContentRequest._();
  @$core.override
  CampaignServiceGetLinkedContentRequest createEmptyInstance() =>
      CampaignServiceGetLinkedContentRequest._();
  @$core.pragma('dart2js:noInline')
  static CampaignServiceGetLinkedContentRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
              CampaignServiceGetLinkedContentRequest>(
          CampaignServiceGetLinkedContentRequest.$_createMessage);
  static CampaignServiceGetLinkedContentRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get campaignId => $_getSZ(1);
  @$pb.TagNumber(2)
  set campaignId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCampaignId() => $_has(1);
  @$pb.TagNumber(2)
  void clearCampaignId() => $_clearField(2);
}

class LinkedContentItem extends $pb.GeneratedMessage {
  factory LinkedContentItem({
    $core.String? postId,
    $core.String? platform,
    $core.String? title,
    $core.String? url,
    $fixnum.Int64? views,
    $fixnum.Int64? engagements,
  }) {
    final result = LinkedContentItem._();
    if (postId != null) result.postId = postId;
    if (platform != null) result.platform = platform;
    if (title != null) result.title = title;
    if (url != null) result.url = url;
    if (views != null) result.views = views;
    if (engagements != null) result.engagements = engagements;
    return result;
  }

  LinkedContentItem._();

  factory LinkedContentItem.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      LinkedContentItem()..mergeFromBuffer(data, registry);
  factory LinkedContentItem.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      LinkedContentItem()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'LinkedContentItem',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: LinkedContentItem.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'postId')
    ..aOS(2, _omitFieldNames ? '' : 'platform')
    ..aOS(3, _omitFieldNames ? '' : 'title')
    ..aOS(4, _omitFieldNames ? '' : 'url')
    ..aInt64(5, _omitFieldNames ? '' : 'views')
    ..aInt64(6, _omitFieldNames ? '' : 'engagements')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LinkedContentItem clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LinkedContentItem copyWith(void Function(LinkedContentItem) updates) =>
      super.copyWith((message) => updates(message as LinkedContentItem))
          as LinkedContentItem;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use LinkedContentItem() / LinkedContentItem.new instead')
  static LinkedContentItem create() => LinkedContentItem._();
  static $pb.GeneratedMessage $_createMessage() => LinkedContentItem._();
  @$core.override
  LinkedContentItem createEmptyInstance() => LinkedContentItem._();
  @$core.pragma('dart2js:noInline')
  static LinkedContentItem getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<LinkedContentItem>(
          LinkedContentItem.$_createMessage);
  static LinkedContentItem? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get postId => $_getSZ(0);
  @$pb.TagNumber(1)
  set postId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPostId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPostId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get platform => $_getSZ(1);
  @$pb.TagNumber(2)
  set platform($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPlatform() => $_has(1);
  @$pb.TagNumber(2)
  void clearPlatform() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get title => $_getSZ(2);
  @$pb.TagNumber(3)
  set title($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasTitle() => $_has(2);
  @$pb.TagNumber(3)
  void clearTitle() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get url => $_getSZ(3);
  @$pb.TagNumber(4)
  set url($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasUrl() => $_has(3);
  @$pb.TagNumber(4)
  void clearUrl() => $_clearField(4);

  @$pb.TagNumber(5)
  $fixnum.Int64 get views => $_getI64(4);
  @$pb.TagNumber(5)
  set views($fixnum.Int64 value) => $_setInt64(4, value);
  @$pb.TagNumber(5)
  $core.bool hasViews() => $_has(4);
  @$pb.TagNumber(5)
  void clearViews() => $_clearField(5);

  @$pb.TagNumber(6)
  $fixnum.Int64 get engagements => $_getI64(5);
  @$pb.TagNumber(6)
  set engagements($fixnum.Int64 value) => $_setInt64(5, value);
  @$pb.TagNumber(6)
  $core.bool hasEngagements() => $_has(5);
  @$pb.TagNumber(6)
  void clearEngagements() => $_clearField(6);
}

class CampaignServiceGetLinkedContentResponse extends $pb.GeneratedMessage {
  factory CampaignServiceGetLinkedContentResponse({
    $core.String? campaignId,
    $core.Iterable<LinkedContentItem>? items,
  }) {
    final result = CampaignServiceGetLinkedContentResponse._();
    if (campaignId != null) result.campaignId = campaignId;
    if (items != null) result.items.addAll(items);
    return result;
  }

  CampaignServiceGetLinkedContentResponse._();

  factory CampaignServiceGetLinkedContentResponse.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CampaignServiceGetLinkedContentResponse()
        ..mergeFromBuffer(data, registry);
  factory CampaignServiceGetLinkedContentResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CampaignServiceGetLinkedContentResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CampaignServiceGetLinkedContentResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance:
          CampaignServiceGetLinkedContentResponse.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'campaignId')
    ..pPM<LinkedContentItem>(2, _omitFieldNames ? '' : 'items',
        subBuilder: LinkedContentItem.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CampaignServiceGetLinkedContentResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CampaignServiceGetLinkedContentResponse copyWith(
          void Function(CampaignServiceGetLinkedContentResponse) updates) =>
      super.copyWith((message) =>
              updates(message as CampaignServiceGetLinkedContentResponse))
          as CampaignServiceGetLinkedContentResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use CampaignServiceGetLinkedContentResponse() / CampaignServiceGetLinkedContentResponse.new instead')
  static CampaignServiceGetLinkedContentResponse create() =>
      CampaignServiceGetLinkedContentResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      CampaignServiceGetLinkedContentResponse._();
  @$core.override
  CampaignServiceGetLinkedContentResponse createEmptyInstance() =>
      CampaignServiceGetLinkedContentResponse._();
  @$core.pragma('dart2js:noInline')
  static CampaignServiceGetLinkedContentResponse getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
              CampaignServiceGetLinkedContentResponse>(
          CampaignServiceGetLinkedContentResponse.$_createMessage);
  static CampaignServiceGetLinkedContentResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get campaignId => $_getSZ(0);
  @$pb.TagNumber(1)
  set campaignId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCampaignId() => $_has(0);
  @$pb.TagNumber(1)
  void clearCampaignId() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbList<LinkedContentItem> get items => $_getList(1);
}

class CampaignServiceGetLinkedOffersRequest extends $pb.GeneratedMessage {
  factory CampaignServiceGetLinkedOffersRequest({
    $core.String? workspaceId,
    $core.String? campaignId,
  }) {
    final result = CampaignServiceGetLinkedOffersRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (campaignId != null) result.campaignId = campaignId;
    return result;
  }

  CampaignServiceGetLinkedOffersRequest._();

  factory CampaignServiceGetLinkedOffersRequest.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CampaignServiceGetLinkedOffersRequest()..mergeFromBuffer(data, registry);
  factory CampaignServiceGetLinkedOffersRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CampaignServiceGetLinkedOffersRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CampaignServiceGetLinkedOffersRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance:
          CampaignServiceGetLinkedOffersRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'campaignId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CampaignServiceGetLinkedOffersRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CampaignServiceGetLinkedOffersRequest copyWith(
          void Function(CampaignServiceGetLinkedOffersRequest) updates) =>
      super.copyWith((message) =>
              updates(message as CampaignServiceGetLinkedOffersRequest))
          as CampaignServiceGetLinkedOffersRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use CampaignServiceGetLinkedOffersRequest() / CampaignServiceGetLinkedOffersRequest.new instead')
  static CampaignServiceGetLinkedOffersRequest create() =>
      CampaignServiceGetLinkedOffersRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      CampaignServiceGetLinkedOffersRequest._();
  @$core.override
  CampaignServiceGetLinkedOffersRequest createEmptyInstance() =>
      CampaignServiceGetLinkedOffersRequest._();
  @$core.pragma('dart2js:noInline')
  static CampaignServiceGetLinkedOffersRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
              CampaignServiceGetLinkedOffersRequest>(
          CampaignServiceGetLinkedOffersRequest.$_createMessage);
  static CampaignServiceGetLinkedOffersRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get campaignId => $_getSZ(1);
  @$pb.TagNumber(2)
  set campaignId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCampaignId() => $_has(1);
  @$pb.TagNumber(2)
  void clearCampaignId() => $_clearField(2);
}

class CampaignServiceGetLinkedOffersResponse extends $pb.GeneratedMessage {
  factory CampaignServiceGetLinkedOffersResponse({
    $core.String? campaignId,
    $core.Iterable<Offer>? offers,
  }) {
    final result = CampaignServiceGetLinkedOffersResponse._();
    if (campaignId != null) result.campaignId = campaignId;
    if (offers != null) result.offers.addAll(offers);
    return result;
  }

  CampaignServiceGetLinkedOffersResponse._();

  factory CampaignServiceGetLinkedOffersResponse.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CampaignServiceGetLinkedOffersResponse()..mergeFromBuffer(data, registry);
  factory CampaignServiceGetLinkedOffersResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CampaignServiceGetLinkedOffersResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CampaignServiceGetLinkedOffersResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance:
          CampaignServiceGetLinkedOffersResponse.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'campaignId')
    ..pPM<Offer>(2, _omitFieldNames ? '' : 'offers',
        subBuilder: Offer.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CampaignServiceGetLinkedOffersResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CampaignServiceGetLinkedOffersResponse copyWith(
          void Function(CampaignServiceGetLinkedOffersResponse) updates) =>
      super.copyWith((message) =>
              updates(message as CampaignServiceGetLinkedOffersResponse))
          as CampaignServiceGetLinkedOffersResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use CampaignServiceGetLinkedOffersResponse() / CampaignServiceGetLinkedOffersResponse.new instead')
  static CampaignServiceGetLinkedOffersResponse create() =>
      CampaignServiceGetLinkedOffersResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      CampaignServiceGetLinkedOffersResponse._();
  @$core.override
  CampaignServiceGetLinkedOffersResponse createEmptyInstance() =>
      CampaignServiceGetLinkedOffersResponse._();
  @$core.pragma('dart2js:noInline')
  static CampaignServiceGetLinkedOffersResponse getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
              CampaignServiceGetLinkedOffersResponse>(
          CampaignServiceGetLinkedOffersResponse.$_createMessage);
  static CampaignServiceGetLinkedOffersResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get campaignId => $_getSZ(0);
  @$pb.TagNumber(1)
  set campaignId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCampaignId() => $_has(0);
  @$pb.TagNumber(1)
  void clearCampaignId() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbList<Offer> get offers => $_getList(1);
}

class CampaignServiceGetPlatformBreakdownRequest extends $pb.GeneratedMessage {
  factory CampaignServiceGetPlatformBreakdownRequest({
    $core.String? workspaceId,
    $core.String? campaignId,
  }) {
    final result = CampaignServiceGetPlatformBreakdownRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (campaignId != null) result.campaignId = campaignId;
    return result;
  }

  CampaignServiceGetPlatformBreakdownRequest._();

  factory CampaignServiceGetPlatformBreakdownRequest.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CampaignServiceGetPlatformBreakdownRequest()
        ..mergeFromBuffer(data, registry);
  factory CampaignServiceGetPlatformBreakdownRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CampaignServiceGetPlatformBreakdownRequest()
        ..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CampaignServiceGetPlatformBreakdownRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance:
          CampaignServiceGetPlatformBreakdownRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'campaignId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CampaignServiceGetPlatformBreakdownRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CampaignServiceGetPlatformBreakdownRequest copyWith(
          void Function(CampaignServiceGetPlatformBreakdownRequest) updates) =>
      super.copyWith((message) =>
              updates(message as CampaignServiceGetPlatformBreakdownRequest))
          as CampaignServiceGetPlatformBreakdownRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use CampaignServiceGetPlatformBreakdownRequest() / CampaignServiceGetPlatformBreakdownRequest.new instead')
  static CampaignServiceGetPlatformBreakdownRequest create() =>
      CampaignServiceGetPlatformBreakdownRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      CampaignServiceGetPlatformBreakdownRequest._();
  @$core.override
  CampaignServiceGetPlatformBreakdownRequest createEmptyInstance() =>
      CampaignServiceGetPlatformBreakdownRequest._();
  @$core.pragma('dart2js:noInline')
  static CampaignServiceGetPlatformBreakdownRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
              CampaignServiceGetPlatformBreakdownRequest>(
          CampaignServiceGetPlatformBreakdownRequest.$_createMessage);
  static CampaignServiceGetPlatformBreakdownRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get campaignId => $_getSZ(1);
  @$pb.TagNumber(2)
  set campaignId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCampaignId() => $_has(1);
  @$pb.TagNumber(2)
  void clearCampaignId() => $_clearField(2);
}

class PlatformBreakdownItem extends $pb.GeneratedMessage {
  factory PlatformBreakdownItem({
    $core.String? platform,
    $core.String? revenue,
    $core.String? spend,
    $core.int? ordersCount,
  }) {
    final result = PlatformBreakdownItem._();
    if (platform != null) result.platform = platform;
    if (revenue != null) result.revenue = revenue;
    if (spend != null) result.spend = spend;
    if (ordersCount != null) result.ordersCount = ordersCount;
    return result;
  }

  PlatformBreakdownItem._();

  factory PlatformBreakdownItem.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PlatformBreakdownItem()..mergeFromBuffer(data, registry);
  factory PlatformBreakdownItem.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PlatformBreakdownItem()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PlatformBreakdownItem',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: PlatformBreakdownItem.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'platform')
    ..aOS(2, _omitFieldNames ? '' : 'revenue')
    ..aOS(3, _omitFieldNames ? '' : 'spend')
    ..aI(4, _omitFieldNames ? '' : 'ordersCount')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PlatformBreakdownItem clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PlatformBreakdownItem copyWith(
          void Function(PlatformBreakdownItem) updates) =>
      super.copyWith((message) => updates(message as PlatformBreakdownItem))
          as PlatformBreakdownItem;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use PlatformBreakdownItem() / PlatformBreakdownItem.new instead')
  static PlatformBreakdownItem create() => PlatformBreakdownItem._();
  static $pb.GeneratedMessage $_createMessage() => PlatformBreakdownItem._();
  @$core.override
  PlatformBreakdownItem createEmptyInstance() => PlatformBreakdownItem._();
  @$core.pragma('dart2js:noInline')
  static PlatformBreakdownItem getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PlatformBreakdownItem>(
          PlatformBreakdownItem.$_createMessage);
  static PlatformBreakdownItem? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get platform => $_getSZ(0);
  @$pb.TagNumber(1)
  set platform($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPlatform() => $_has(0);
  @$pb.TagNumber(1)
  void clearPlatform() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get revenue => $_getSZ(1);
  @$pb.TagNumber(2)
  set revenue($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasRevenue() => $_has(1);
  @$pb.TagNumber(2)
  void clearRevenue() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get spend => $_getSZ(2);
  @$pb.TagNumber(3)
  set spend($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasSpend() => $_has(2);
  @$pb.TagNumber(3)
  void clearSpend() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get ordersCount => $_getIZ(3);
  @$pb.TagNumber(4)
  set ordersCount($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasOrdersCount() => $_has(3);
  @$pb.TagNumber(4)
  void clearOrdersCount() => $_clearField(4);
}

class CampaignServiceGetPlatformBreakdownResponse extends $pb.GeneratedMessage {
  factory CampaignServiceGetPlatformBreakdownResponse({
    $core.String? campaignId,
    $core.Iterable<PlatformBreakdownItem>? items,
  }) {
    final result = CampaignServiceGetPlatformBreakdownResponse._();
    if (campaignId != null) result.campaignId = campaignId;
    if (items != null) result.items.addAll(items);
    return result;
  }

  CampaignServiceGetPlatformBreakdownResponse._();

  factory CampaignServiceGetPlatformBreakdownResponse.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CampaignServiceGetPlatformBreakdownResponse()
        ..mergeFromBuffer(data, registry);
  factory CampaignServiceGetPlatformBreakdownResponse.fromJson(
          $core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CampaignServiceGetPlatformBreakdownResponse()
        ..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CampaignServiceGetPlatformBreakdownResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance:
          CampaignServiceGetPlatformBreakdownResponse.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'campaignId')
    ..pPM<PlatformBreakdownItem>(2, _omitFieldNames ? '' : 'items',
        subBuilder: PlatformBreakdownItem.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CampaignServiceGetPlatformBreakdownResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CampaignServiceGetPlatformBreakdownResponse copyWith(
          void Function(CampaignServiceGetPlatformBreakdownResponse) updates) =>
      super.copyWith((message) =>
              updates(message as CampaignServiceGetPlatformBreakdownResponse))
          as CampaignServiceGetPlatformBreakdownResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use CampaignServiceGetPlatformBreakdownResponse() / CampaignServiceGetPlatformBreakdownResponse.new instead')
  static CampaignServiceGetPlatformBreakdownResponse create() =>
      CampaignServiceGetPlatformBreakdownResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      CampaignServiceGetPlatformBreakdownResponse._();
  @$core.override
  CampaignServiceGetPlatformBreakdownResponse createEmptyInstance() =>
      CampaignServiceGetPlatformBreakdownResponse._();
  @$core.pragma('dart2js:noInline')
  static CampaignServiceGetPlatformBreakdownResponse getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
              CampaignServiceGetPlatformBreakdownResponse>(
          CampaignServiceGetPlatformBreakdownResponse.$_createMessage);
  static CampaignServiceGetPlatformBreakdownResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get campaignId => $_getSZ(0);
  @$pb.TagNumber(1)
  set campaignId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCampaignId() => $_has(0);
  @$pb.TagNumber(1)
  void clearCampaignId() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbList<PlatformBreakdownItem> get items => $_getList(1);
}

class CampaignServiceGetRevenueTimelineRequest extends $pb.GeneratedMessage {
  factory CampaignServiceGetRevenueTimelineRequest({
    $core.String? workspaceId,
    $core.String? campaignId,
    $core.String? granularity,
  }) {
    final result = CampaignServiceGetRevenueTimelineRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (campaignId != null) result.campaignId = campaignId;
    if (granularity != null) result.granularity = granularity;
    return result;
  }

  CampaignServiceGetRevenueTimelineRequest._();

  factory CampaignServiceGetRevenueTimelineRequest.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CampaignServiceGetRevenueTimelineRequest()
        ..mergeFromBuffer(data, registry);
  factory CampaignServiceGetRevenueTimelineRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CampaignServiceGetRevenueTimelineRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CampaignServiceGetRevenueTimelineRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance:
          CampaignServiceGetRevenueTimelineRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'campaignId')
    ..aOS(3, _omitFieldNames ? '' : 'granularity')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CampaignServiceGetRevenueTimelineRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CampaignServiceGetRevenueTimelineRequest copyWith(
          void Function(CampaignServiceGetRevenueTimelineRequest) updates) =>
      super.copyWith((message) =>
              updates(message as CampaignServiceGetRevenueTimelineRequest))
          as CampaignServiceGetRevenueTimelineRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use CampaignServiceGetRevenueTimelineRequest() / CampaignServiceGetRevenueTimelineRequest.new instead')
  static CampaignServiceGetRevenueTimelineRequest create() =>
      CampaignServiceGetRevenueTimelineRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      CampaignServiceGetRevenueTimelineRequest._();
  @$core.override
  CampaignServiceGetRevenueTimelineRequest createEmptyInstance() =>
      CampaignServiceGetRevenueTimelineRequest._();
  @$core.pragma('dart2js:noInline')
  static CampaignServiceGetRevenueTimelineRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
              CampaignServiceGetRevenueTimelineRequest>(
          CampaignServiceGetRevenueTimelineRequest.$_createMessage);
  static CampaignServiceGetRevenueTimelineRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get campaignId => $_getSZ(1);
  @$pb.TagNumber(2)
  set campaignId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCampaignId() => $_has(1);
  @$pb.TagNumber(2)
  void clearCampaignId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get granularity => $_getSZ(2);
  @$pb.TagNumber(3)
  set granularity($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasGranularity() => $_has(2);
  @$pb.TagNumber(3)
  void clearGranularity() => $_clearField(3);
}

class RevenueTimelinePoint extends $pb.GeneratedMessage {
  factory RevenueTimelinePoint({
    $core.String? date,
    $core.String? revenue,
    $core.String? spend,
    $core.int? ordersCount,
  }) {
    final result = RevenueTimelinePoint._();
    if (date != null) result.date = date;
    if (revenue != null) result.revenue = revenue;
    if (spend != null) result.spend = spend;
    if (ordersCount != null) result.ordersCount = ordersCount;
    return result;
  }

  RevenueTimelinePoint._();

  factory RevenueTimelinePoint.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RevenueTimelinePoint()..mergeFromBuffer(data, registry);
  factory RevenueTimelinePoint.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RevenueTimelinePoint()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RevenueTimelinePoint',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: RevenueTimelinePoint.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'date')
    ..aOS(2, _omitFieldNames ? '' : 'revenue')
    ..aOS(3, _omitFieldNames ? '' : 'spend')
    ..aI(4, _omitFieldNames ? '' : 'ordersCount')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RevenueTimelinePoint clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RevenueTimelinePoint copyWith(void Function(RevenueTimelinePoint) updates) =>
      super.copyWith((message) => updates(message as RevenueTimelinePoint))
          as RevenueTimelinePoint;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use RevenueTimelinePoint() / RevenueTimelinePoint.new instead')
  static RevenueTimelinePoint create() => RevenueTimelinePoint._();
  static $pb.GeneratedMessage $_createMessage() => RevenueTimelinePoint._();
  @$core.override
  RevenueTimelinePoint createEmptyInstance() => RevenueTimelinePoint._();
  @$core.pragma('dart2js:noInline')
  static RevenueTimelinePoint getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RevenueTimelinePoint>(
          RevenueTimelinePoint.$_createMessage);
  static RevenueTimelinePoint? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get date => $_getSZ(0);
  @$pb.TagNumber(1)
  set date($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasDate() => $_has(0);
  @$pb.TagNumber(1)
  void clearDate() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get revenue => $_getSZ(1);
  @$pb.TagNumber(2)
  set revenue($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasRevenue() => $_has(1);
  @$pb.TagNumber(2)
  void clearRevenue() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get spend => $_getSZ(2);
  @$pb.TagNumber(3)
  set spend($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasSpend() => $_has(2);
  @$pb.TagNumber(3)
  void clearSpend() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get ordersCount => $_getIZ(3);
  @$pb.TagNumber(4)
  set ordersCount($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasOrdersCount() => $_has(3);
  @$pb.TagNumber(4)
  void clearOrdersCount() => $_clearField(4);
}

class CampaignServiceGetRevenueTimelineResponse extends $pb.GeneratedMessage {
  factory CampaignServiceGetRevenueTimelineResponse({
    $core.String? campaignId,
    $core.Iterable<RevenueTimelinePoint>? points,
  }) {
    final result = CampaignServiceGetRevenueTimelineResponse._();
    if (campaignId != null) result.campaignId = campaignId;
    if (points != null) result.points.addAll(points);
    return result;
  }

  CampaignServiceGetRevenueTimelineResponse._();

  factory CampaignServiceGetRevenueTimelineResponse.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CampaignServiceGetRevenueTimelineResponse()
        ..mergeFromBuffer(data, registry);
  factory CampaignServiceGetRevenueTimelineResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CampaignServiceGetRevenueTimelineResponse()
        ..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CampaignServiceGetRevenueTimelineResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance:
          CampaignServiceGetRevenueTimelineResponse.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'campaignId')
    ..pPM<RevenueTimelinePoint>(2, _omitFieldNames ? '' : 'points',
        subBuilder: RevenueTimelinePoint.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CampaignServiceGetRevenueTimelineResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CampaignServiceGetRevenueTimelineResponse copyWith(
          void Function(CampaignServiceGetRevenueTimelineResponse) updates) =>
      super.copyWith((message) =>
              updates(message as CampaignServiceGetRevenueTimelineResponse))
          as CampaignServiceGetRevenueTimelineResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use CampaignServiceGetRevenueTimelineResponse() / CampaignServiceGetRevenueTimelineResponse.new instead')
  static CampaignServiceGetRevenueTimelineResponse create() =>
      CampaignServiceGetRevenueTimelineResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      CampaignServiceGetRevenueTimelineResponse._();
  @$core.override
  CampaignServiceGetRevenueTimelineResponse createEmptyInstance() =>
      CampaignServiceGetRevenueTimelineResponse._();
  @$core.pragma('dart2js:noInline')
  static CampaignServiceGetRevenueTimelineResponse getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
              CampaignServiceGetRevenueTimelineResponse>(
          CampaignServiceGetRevenueTimelineResponse.$_createMessage);
  static CampaignServiceGetRevenueTimelineResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get campaignId => $_getSZ(0);
  @$pb.TagNumber(1)
  set campaignId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCampaignId() => $_has(0);
  @$pb.TagNumber(1)
  void clearCampaignId() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbList<RevenueTimelinePoint> get points => $_getList(1);
}

class CampaignServiceGetTopProductsRequest extends $pb.GeneratedMessage {
  factory CampaignServiceGetTopProductsRequest({
    $core.String? workspaceId,
    $core.String? campaignId,
    $core.int? limit,
  }) {
    final result = CampaignServiceGetTopProductsRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (campaignId != null) result.campaignId = campaignId;
    if (limit != null) result.limit = limit;
    return result;
  }

  CampaignServiceGetTopProductsRequest._();

  factory CampaignServiceGetTopProductsRequest.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CampaignServiceGetTopProductsRequest()..mergeFromBuffer(data, registry);
  factory CampaignServiceGetTopProductsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CampaignServiceGetTopProductsRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CampaignServiceGetTopProductsRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: CampaignServiceGetTopProductsRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'campaignId')
    ..aI(3, _omitFieldNames ? '' : 'limit')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CampaignServiceGetTopProductsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CampaignServiceGetTopProductsRequest copyWith(
          void Function(CampaignServiceGetTopProductsRequest) updates) =>
      super.copyWith((message) =>
              updates(message as CampaignServiceGetTopProductsRequest))
          as CampaignServiceGetTopProductsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use CampaignServiceGetTopProductsRequest() / CampaignServiceGetTopProductsRequest.new instead')
  static CampaignServiceGetTopProductsRequest create() =>
      CampaignServiceGetTopProductsRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      CampaignServiceGetTopProductsRequest._();
  @$core.override
  CampaignServiceGetTopProductsRequest createEmptyInstance() =>
      CampaignServiceGetTopProductsRequest._();
  @$core.pragma('dart2js:noInline')
  static CampaignServiceGetTopProductsRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
              CampaignServiceGetTopProductsRequest>(
          CampaignServiceGetTopProductsRequest.$_createMessage);
  static CampaignServiceGetTopProductsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get campaignId => $_getSZ(1);
  @$pb.TagNumber(2)
  set campaignId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCampaignId() => $_has(1);
  @$pb.TagNumber(2)
  void clearCampaignId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get limit => $_getIZ(2);
  @$pb.TagNumber(3)
  set limit($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasLimit() => $_has(2);
  @$pb.TagNumber(3)
  void clearLimit() => $_clearField(3);
}

class TopProductItem extends $pb.GeneratedMessage {
  factory TopProductItem({
    $core.String? productId,
    $core.String? title,
    $core.int? unitsSold,
    $core.String? revenue,
    $core.String? currency,
  }) {
    final result = TopProductItem._();
    if (productId != null) result.productId = productId;
    if (title != null) result.title = title;
    if (unitsSold != null) result.unitsSold = unitsSold;
    if (revenue != null) result.revenue = revenue;
    if (currency != null) result.currency = currency;
    return result;
  }

  TopProductItem._();

  factory TopProductItem.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      TopProductItem()..mergeFromBuffer(data, registry);
  factory TopProductItem.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      TopProductItem()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TopProductItem',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: TopProductItem.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'productId')
    ..aOS(2, _omitFieldNames ? '' : 'title')
    ..aI(3, _omitFieldNames ? '' : 'unitsSold')
    ..aOS(4, _omitFieldNames ? '' : 'revenue')
    ..aOS(5, _omitFieldNames ? '' : 'currency')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TopProductItem clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TopProductItem copyWith(void Function(TopProductItem) updates) =>
      super.copyWith((message) => updates(message as TopProductItem))
          as TopProductItem;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use TopProductItem() / TopProductItem.new instead')
  static TopProductItem create() => TopProductItem._();
  static $pb.GeneratedMessage $_createMessage() => TopProductItem._();
  @$core.override
  TopProductItem createEmptyInstance() => TopProductItem._();
  @$core.pragma('dart2js:noInline')
  static TopProductItem getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<TopProductItem>(
          TopProductItem.$_createMessage);
  static TopProductItem? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get productId => $_getSZ(0);
  @$pb.TagNumber(1)
  set productId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasProductId() => $_has(0);
  @$pb.TagNumber(1)
  void clearProductId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get title => $_getSZ(1);
  @$pb.TagNumber(2)
  set title($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTitle() => $_has(1);
  @$pb.TagNumber(2)
  void clearTitle() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get unitsSold => $_getIZ(2);
  @$pb.TagNumber(3)
  set unitsSold($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasUnitsSold() => $_has(2);
  @$pb.TagNumber(3)
  void clearUnitsSold() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get revenue => $_getSZ(3);
  @$pb.TagNumber(4)
  set revenue($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasRevenue() => $_has(3);
  @$pb.TagNumber(4)
  void clearRevenue() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get currency => $_getSZ(4);
  @$pb.TagNumber(5)
  set currency($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasCurrency() => $_has(4);
  @$pb.TagNumber(5)
  void clearCurrency() => $_clearField(5);
}

class CampaignServiceGetTopProductsResponse extends $pb.GeneratedMessage {
  factory CampaignServiceGetTopProductsResponse({
    $core.String? campaignId,
    $core.Iterable<TopProductItem>? products,
  }) {
    final result = CampaignServiceGetTopProductsResponse._();
    if (campaignId != null) result.campaignId = campaignId;
    if (products != null) result.products.addAll(products);
    return result;
  }

  CampaignServiceGetTopProductsResponse._();

  factory CampaignServiceGetTopProductsResponse.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CampaignServiceGetTopProductsResponse()..mergeFromBuffer(data, registry);
  factory CampaignServiceGetTopProductsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CampaignServiceGetTopProductsResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CampaignServiceGetTopProductsResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance:
          CampaignServiceGetTopProductsResponse.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'campaignId')
    ..pPM<TopProductItem>(2, _omitFieldNames ? '' : 'products',
        subBuilder: TopProductItem.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CampaignServiceGetTopProductsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CampaignServiceGetTopProductsResponse copyWith(
          void Function(CampaignServiceGetTopProductsResponse) updates) =>
      super.copyWith((message) =>
              updates(message as CampaignServiceGetTopProductsResponse))
          as CampaignServiceGetTopProductsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use CampaignServiceGetTopProductsResponse() / CampaignServiceGetTopProductsResponse.new instead')
  static CampaignServiceGetTopProductsResponse create() =>
      CampaignServiceGetTopProductsResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      CampaignServiceGetTopProductsResponse._();
  @$core.override
  CampaignServiceGetTopProductsResponse createEmptyInstance() =>
      CampaignServiceGetTopProductsResponse._();
  @$core.pragma('dart2js:noInline')
  static CampaignServiceGetTopProductsResponse getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
              CampaignServiceGetTopProductsResponse>(
          CampaignServiceGetTopProductsResponse.$_createMessage);
  static CampaignServiceGetTopProductsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get campaignId => $_getSZ(0);
  @$pb.TagNumber(1)
  set campaignId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCampaignId() => $_has(0);
  @$pb.TagNumber(1)
  void clearCampaignId() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbList<TopProductItem> get products => $_getList(1);
}

class CampaignServiceLinkContentRequest extends $pb.GeneratedMessage {
  factory CampaignServiceLinkContentRequest({
    $core.String? workspaceId,
    $core.String? campaignId,
    $core.String? postId,
    $2.CommandContext? commandContext,
  }) {
    final result = CampaignServiceLinkContentRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (campaignId != null) result.campaignId = campaignId;
    if (postId != null) result.postId = postId;
    if (commandContext != null) result.commandContext = commandContext;
    return result;
  }

  CampaignServiceLinkContentRequest._();

  factory CampaignServiceLinkContentRequest.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CampaignServiceLinkContentRequest()..mergeFromBuffer(data, registry);
  factory CampaignServiceLinkContentRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CampaignServiceLinkContentRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CampaignServiceLinkContentRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: CampaignServiceLinkContentRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'campaignId')
    ..aOS(3, _omitFieldNames ? '' : 'postId')
    ..aOM<$2.CommandContext>(4, _omitFieldNames ? '' : 'commandContext',
        subBuilder: $2.CommandContext.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CampaignServiceLinkContentRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CampaignServiceLinkContentRequest copyWith(
          void Function(CampaignServiceLinkContentRequest) updates) =>
      super.copyWith((message) =>
              updates(message as CampaignServiceLinkContentRequest))
          as CampaignServiceLinkContentRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use CampaignServiceLinkContentRequest() / CampaignServiceLinkContentRequest.new instead')
  static CampaignServiceLinkContentRequest create() =>
      CampaignServiceLinkContentRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      CampaignServiceLinkContentRequest._();
  @$core.override
  CampaignServiceLinkContentRequest createEmptyInstance() =>
      CampaignServiceLinkContentRequest._();
  @$core.pragma('dart2js:noInline')
  static CampaignServiceLinkContentRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CampaignServiceLinkContentRequest>(
          CampaignServiceLinkContentRequest.$_createMessage);
  static CampaignServiceLinkContentRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get campaignId => $_getSZ(1);
  @$pb.TagNumber(2)
  set campaignId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCampaignId() => $_has(1);
  @$pb.TagNumber(2)
  void clearCampaignId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get postId => $_getSZ(2);
  @$pb.TagNumber(3)
  set postId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPostId() => $_has(2);
  @$pb.TagNumber(3)
  void clearPostId() => $_clearField(3);

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

class CampaignServiceLinkContentResponse extends $pb.GeneratedMessage {
  factory CampaignServiceLinkContentResponse({
    $core.bool? success,
  }) {
    final result = CampaignServiceLinkContentResponse._();
    if (success != null) result.success = success;
    return result;
  }

  CampaignServiceLinkContentResponse._();

  factory CampaignServiceLinkContentResponse.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CampaignServiceLinkContentResponse()..mergeFromBuffer(data, registry);
  factory CampaignServiceLinkContentResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CampaignServiceLinkContentResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CampaignServiceLinkContentResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: CampaignServiceLinkContentResponse.$_createMessage)
    ..aOB(1, _omitFieldNames ? '' : 'success')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CampaignServiceLinkContentResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CampaignServiceLinkContentResponse copyWith(
          void Function(CampaignServiceLinkContentResponse) updates) =>
      super.copyWith((message) =>
              updates(message as CampaignServiceLinkContentResponse))
          as CampaignServiceLinkContentResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use CampaignServiceLinkContentResponse() / CampaignServiceLinkContentResponse.new instead')
  static CampaignServiceLinkContentResponse create() =>
      CampaignServiceLinkContentResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      CampaignServiceLinkContentResponse._();
  @$core.override
  CampaignServiceLinkContentResponse createEmptyInstance() =>
      CampaignServiceLinkContentResponse._();
  @$core.pragma('dart2js:noInline')
  static CampaignServiceLinkContentResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CampaignServiceLinkContentResponse>(
          CampaignServiceLinkContentResponse.$_createMessage);
  static CampaignServiceLinkContentResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get success => $_getBF(0);
  @$pb.TagNumber(1)
  set success($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSuccess() => $_has(0);
  @$pb.TagNumber(1)
  void clearSuccess() => $_clearField(1);
}

class CampaignServiceLinkOfferRequest extends $pb.GeneratedMessage {
  factory CampaignServiceLinkOfferRequest({
    $core.String? workspaceId,
    $core.String? campaignId,
    $core.String? offerId,
    $2.CommandContext? commandContext,
  }) {
    final result = CampaignServiceLinkOfferRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (campaignId != null) result.campaignId = campaignId;
    if (offerId != null) result.offerId = offerId;
    if (commandContext != null) result.commandContext = commandContext;
    return result;
  }

  CampaignServiceLinkOfferRequest._();

  factory CampaignServiceLinkOfferRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CampaignServiceLinkOfferRequest()..mergeFromBuffer(data, registry);
  factory CampaignServiceLinkOfferRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CampaignServiceLinkOfferRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CampaignServiceLinkOfferRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: CampaignServiceLinkOfferRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'campaignId')
    ..aOS(3, _omitFieldNames ? '' : 'offerId')
    ..aOM<$2.CommandContext>(4, _omitFieldNames ? '' : 'commandContext',
        subBuilder: $2.CommandContext.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CampaignServiceLinkOfferRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CampaignServiceLinkOfferRequest copyWith(
          void Function(CampaignServiceLinkOfferRequest) updates) =>
      super.copyWith(
              (message) => updates(message as CampaignServiceLinkOfferRequest))
          as CampaignServiceLinkOfferRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use CampaignServiceLinkOfferRequest() / CampaignServiceLinkOfferRequest.new instead')
  static CampaignServiceLinkOfferRequest create() =>
      CampaignServiceLinkOfferRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      CampaignServiceLinkOfferRequest._();
  @$core.override
  CampaignServiceLinkOfferRequest createEmptyInstance() =>
      CampaignServiceLinkOfferRequest._();
  @$core.pragma('dart2js:noInline')
  static CampaignServiceLinkOfferRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CampaignServiceLinkOfferRequest>(
          CampaignServiceLinkOfferRequest.$_createMessage);
  static CampaignServiceLinkOfferRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get campaignId => $_getSZ(1);
  @$pb.TagNumber(2)
  set campaignId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCampaignId() => $_has(1);
  @$pb.TagNumber(2)
  void clearCampaignId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get offerId => $_getSZ(2);
  @$pb.TagNumber(3)
  set offerId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasOfferId() => $_has(2);
  @$pb.TagNumber(3)
  void clearOfferId() => $_clearField(3);

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

class CampaignServiceLinkOfferResponse extends $pb.GeneratedMessage {
  factory CampaignServiceLinkOfferResponse({
    $core.bool? success,
  }) {
    final result = CampaignServiceLinkOfferResponse._();
    if (success != null) result.success = success;
    return result;
  }

  CampaignServiceLinkOfferResponse._();

  factory CampaignServiceLinkOfferResponse.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CampaignServiceLinkOfferResponse()..mergeFromBuffer(data, registry);
  factory CampaignServiceLinkOfferResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CampaignServiceLinkOfferResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CampaignServiceLinkOfferResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: CampaignServiceLinkOfferResponse.$_createMessage)
    ..aOB(1, _omitFieldNames ? '' : 'success')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CampaignServiceLinkOfferResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CampaignServiceLinkOfferResponse copyWith(
          void Function(CampaignServiceLinkOfferResponse) updates) =>
      super.copyWith(
              (message) => updates(message as CampaignServiceLinkOfferResponse))
          as CampaignServiceLinkOfferResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use CampaignServiceLinkOfferResponse() / CampaignServiceLinkOfferResponse.new instead')
  static CampaignServiceLinkOfferResponse create() =>
      CampaignServiceLinkOfferResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      CampaignServiceLinkOfferResponse._();
  @$core.override
  CampaignServiceLinkOfferResponse createEmptyInstance() =>
      CampaignServiceLinkOfferResponse._();
  @$core.pragma('dart2js:noInline')
  static CampaignServiceLinkOfferResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CampaignServiceLinkOfferResponse>(
          CampaignServiceLinkOfferResponse.$_createMessage);
  static CampaignServiceLinkOfferResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get success => $_getBF(0);
  @$pb.TagNumber(1)
  set success($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSuccess() => $_has(0);
  @$pb.TagNumber(1)
  void clearSuccess() => $_clearField(1);
}

class CampaignServiceUnlinkContentRequest extends $pb.GeneratedMessage {
  factory CampaignServiceUnlinkContentRequest({
    $core.String? workspaceId,
    $core.String? campaignId,
    $core.String? postId,
    $2.CommandContext? commandContext,
  }) {
    final result = CampaignServiceUnlinkContentRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (campaignId != null) result.campaignId = campaignId;
    if (postId != null) result.postId = postId;
    if (commandContext != null) result.commandContext = commandContext;
    return result;
  }

  CampaignServiceUnlinkContentRequest._();

  factory CampaignServiceUnlinkContentRequest.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CampaignServiceUnlinkContentRequest()..mergeFromBuffer(data, registry);
  factory CampaignServiceUnlinkContentRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CampaignServiceUnlinkContentRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CampaignServiceUnlinkContentRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: CampaignServiceUnlinkContentRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'campaignId')
    ..aOS(3, _omitFieldNames ? '' : 'postId')
    ..aOM<$2.CommandContext>(4, _omitFieldNames ? '' : 'commandContext',
        subBuilder: $2.CommandContext.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CampaignServiceUnlinkContentRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CampaignServiceUnlinkContentRequest copyWith(
          void Function(CampaignServiceUnlinkContentRequest) updates) =>
      super.copyWith((message) =>
              updates(message as CampaignServiceUnlinkContentRequest))
          as CampaignServiceUnlinkContentRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use CampaignServiceUnlinkContentRequest() / CampaignServiceUnlinkContentRequest.new instead')
  static CampaignServiceUnlinkContentRequest create() =>
      CampaignServiceUnlinkContentRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      CampaignServiceUnlinkContentRequest._();
  @$core.override
  CampaignServiceUnlinkContentRequest createEmptyInstance() =>
      CampaignServiceUnlinkContentRequest._();
  @$core.pragma('dart2js:noInline')
  static CampaignServiceUnlinkContentRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
              CampaignServiceUnlinkContentRequest>(
          CampaignServiceUnlinkContentRequest.$_createMessage);
  static CampaignServiceUnlinkContentRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get campaignId => $_getSZ(1);
  @$pb.TagNumber(2)
  set campaignId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCampaignId() => $_has(1);
  @$pb.TagNumber(2)
  void clearCampaignId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get postId => $_getSZ(2);
  @$pb.TagNumber(3)
  set postId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPostId() => $_has(2);
  @$pb.TagNumber(3)
  void clearPostId() => $_clearField(3);

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

class CampaignServiceUnlinkContentResponse extends $pb.GeneratedMessage {
  factory CampaignServiceUnlinkContentResponse({
    $core.bool? success,
  }) {
    final result = CampaignServiceUnlinkContentResponse._();
    if (success != null) result.success = success;
    return result;
  }

  CampaignServiceUnlinkContentResponse._();

  factory CampaignServiceUnlinkContentResponse.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CampaignServiceUnlinkContentResponse()..mergeFromBuffer(data, registry);
  factory CampaignServiceUnlinkContentResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CampaignServiceUnlinkContentResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CampaignServiceUnlinkContentResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance: CampaignServiceUnlinkContentResponse.$_createMessage)
    ..aOB(1, _omitFieldNames ? '' : 'success')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CampaignServiceUnlinkContentResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CampaignServiceUnlinkContentResponse copyWith(
          void Function(CampaignServiceUnlinkContentResponse) updates) =>
      super.copyWith((message) =>
              updates(message as CampaignServiceUnlinkContentResponse))
          as CampaignServiceUnlinkContentResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use CampaignServiceUnlinkContentResponse() / CampaignServiceUnlinkContentResponse.new instead')
  static CampaignServiceUnlinkContentResponse create() =>
      CampaignServiceUnlinkContentResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      CampaignServiceUnlinkContentResponse._();
  @$core.override
  CampaignServiceUnlinkContentResponse createEmptyInstance() =>
      CampaignServiceUnlinkContentResponse._();
  @$core.pragma('dart2js:noInline')
  static CampaignServiceUnlinkContentResponse getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
              CampaignServiceUnlinkContentResponse>(
          CampaignServiceUnlinkContentResponse.$_createMessage);
  static CampaignServiceUnlinkContentResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get success => $_getBF(0);
  @$pb.TagNumber(1)
  set success($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSuccess() => $_has(0);
  @$pb.TagNumber(1)
  void clearSuccess() => $_clearField(1);
}

/// Checkout evaluation request/response connecting Offer, Coupon, Order and Ledger
class MonetizationServiceEvaluateCheckoutRequest extends $pb.GeneratedMessage {
  factory MonetizationServiceEvaluateCheckoutRequest({
    $core.String? workspaceId,
    $core.String? offerId,
    $core.String? couponCode,
    $core.String? customerEntityId,
    $core.Iterable<$core.String>? productIds,
    $core.String? orderAmount,
    $core.String? currency,
    $2.CommandContext? commandContext,
  }) {
    final result = MonetizationServiceEvaluateCheckoutRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (offerId != null) result.offerId = offerId;
    if (couponCode != null) result.couponCode = couponCode;
    if (customerEntityId != null) result.customerEntityId = customerEntityId;
    if (productIds != null) result.productIds.addAll(productIds);
    if (orderAmount != null) result.orderAmount = orderAmount;
    if (currency != null) result.currency = currency;
    if (commandContext != null) result.commandContext = commandContext;
    return result;
  }

  MonetizationServiceEvaluateCheckoutRequest._();

  factory MonetizationServiceEvaluateCheckoutRequest.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      MonetizationServiceEvaluateCheckoutRequest()
        ..mergeFromBuffer(data, registry);
  factory MonetizationServiceEvaluateCheckoutRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      MonetizationServiceEvaluateCheckoutRequest()
        ..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MonetizationServiceEvaluateCheckoutRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance:
          MonetizationServiceEvaluateCheckoutRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'offerId')
    ..aOS(3, _omitFieldNames ? '' : 'couponCode')
    ..aOS(4, _omitFieldNames ? '' : 'customerEntityId')
    ..pPS(5, _omitFieldNames ? '' : 'productIds')
    ..aOS(6, _omitFieldNames ? '' : 'orderAmount')
    ..aOS(7, _omitFieldNames ? '' : 'currency')
    ..aOM<$2.CommandContext>(8, _omitFieldNames ? '' : 'commandContext',
        subBuilder: $2.CommandContext.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MonetizationServiceEvaluateCheckoutRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MonetizationServiceEvaluateCheckoutRequest copyWith(
          void Function(MonetizationServiceEvaluateCheckoutRequest) updates) =>
      super.copyWith((message) =>
              updates(message as MonetizationServiceEvaluateCheckoutRequest))
          as MonetizationServiceEvaluateCheckoutRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use MonetizationServiceEvaluateCheckoutRequest() / MonetizationServiceEvaluateCheckoutRequest.new instead')
  static MonetizationServiceEvaluateCheckoutRequest create() =>
      MonetizationServiceEvaluateCheckoutRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      MonetizationServiceEvaluateCheckoutRequest._();
  @$core.override
  MonetizationServiceEvaluateCheckoutRequest createEmptyInstance() =>
      MonetizationServiceEvaluateCheckoutRequest._();
  @$core.pragma('dart2js:noInline')
  static MonetizationServiceEvaluateCheckoutRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
              MonetizationServiceEvaluateCheckoutRequest>(
          MonetizationServiceEvaluateCheckoutRequest.$_createMessage);
  static MonetizationServiceEvaluateCheckoutRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get offerId => $_getSZ(1);
  @$pb.TagNumber(2)
  set offerId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasOfferId() => $_has(1);
  @$pb.TagNumber(2)
  void clearOfferId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get couponCode => $_getSZ(2);
  @$pb.TagNumber(3)
  set couponCode($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasCouponCode() => $_has(2);
  @$pb.TagNumber(3)
  void clearCouponCode() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get customerEntityId => $_getSZ(3);
  @$pb.TagNumber(4)
  set customerEntityId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasCustomerEntityId() => $_has(3);
  @$pb.TagNumber(4)
  void clearCustomerEntityId() => $_clearField(4);

  @$pb.TagNumber(5)
  $pb.PbList<$core.String> get productIds => $_getList(4);

  @$pb.TagNumber(6)
  $core.String get orderAmount => $_getSZ(5);
  @$pb.TagNumber(6)
  set orderAmount($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasOrderAmount() => $_has(5);
  @$pb.TagNumber(6)
  void clearOrderAmount() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get currency => $_getSZ(6);
  @$pb.TagNumber(7)
  set currency($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasCurrency() => $_has(6);
  @$pb.TagNumber(7)
  void clearCurrency() => $_clearField(7);

  @$pb.TagNumber(8)
  $2.CommandContext get commandContext => $_getN(7);
  @$pb.TagNumber(8)
  set commandContext($2.CommandContext value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasCommandContext() => $_has(7);
  @$pb.TagNumber(8)
  void clearCommandContext() => $_clearField(8);
  @$pb.TagNumber(8)
  $2.CommandContext ensureCommandContext() => $_ensure(7);
}

class MonetizationServiceEvaluateCheckoutResponse extends $pb.GeneratedMessage {
  factory MonetizationServiceEvaluateCheckoutResponse({
    $core.bool? accepted,
    $core.String? errorCode,
    $core.String? errorMessage,
    $core.String? originalAmount,
    $core.String? discountAmount,
    $core.String? netPayableAmount,
    $core.String? currency,
    $core.String? orderId,
    $core.String? postingId,
    $core.String? couponId,
    $core.int? couponRemainingUses,
  }) {
    final result = MonetizationServiceEvaluateCheckoutResponse._();
    if (accepted != null) result.accepted = accepted;
    if (errorCode != null) result.errorCode = errorCode;
    if (errorMessage != null) result.errorMessage = errorMessage;
    if (originalAmount != null) result.originalAmount = originalAmount;
    if (discountAmount != null) result.discountAmount = discountAmount;
    if (netPayableAmount != null) result.netPayableAmount = netPayableAmount;
    if (currency != null) result.currency = currency;
    if (orderId != null) result.orderId = orderId;
    if (postingId != null) result.postingId = postingId;
    if (couponId != null) result.couponId = couponId;
    if (couponRemainingUses != null)
      result.couponRemainingUses = couponRemainingUses;
    return result;
  }

  MonetizationServiceEvaluateCheckoutResponse._();

  factory MonetizationServiceEvaluateCheckoutResponse.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      MonetizationServiceEvaluateCheckoutResponse()
        ..mergeFromBuffer(data, registry);
  factory MonetizationServiceEvaluateCheckoutResponse.fromJson(
          $core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      MonetizationServiceEvaluateCheckoutResponse()
        ..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MonetizationServiceEvaluateCheckoutResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.commerce.v1'),
      createEmptyInstance:
          MonetizationServiceEvaluateCheckoutResponse.$_createMessage)
    ..aOB(1, _omitFieldNames ? '' : 'accepted')
    ..aOS(2, _omitFieldNames ? '' : 'errorCode')
    ..aOS(3, _omitFieldNames ? '' : 'errorMessage')
    ..aOS(4, _omitFieldNames ? '' : 'originalAmount')
    ..aOS(5, _omitFieldNames ? '' : 'discountAmount')
    ..aOS(6, _omitFieldNames ? '' : 'netPayableAmount')
    ..aOS(7, _omitFieldNames ? '' : 'currency')
    ..aOS(8, _omitFieldNames ? '' : 'orderId')
    ..aOS(9, _omitFieldNames ? '' : 'postingId')
    ..aOS(10, _omitFieldNames ? '' : 'couponId')
    ..aI(11, _omitFieldNames ? '' : 'couponRemainingUses')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MonetizationServiceEvaluateCheckoutResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MonetizationServiceEvaluateCheckoutResponse copyWith(
          void Function(MonetizationServiceEvaluateCheckoutResponse) updates) =>
      super.copyWith((message) =>
              updates(message as MonetizationServiceEvaluateCheckoutResponse))
          as MonetizationServiceEvaluateCheckoutResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use MonetizationServiceEvaluateCheckoutResponse() / MonetizationServiceEvaluateCheckoutResponse.new instead')
  static MonetizationServiceEvaluateCheckoutResponse create() =>
      MonetizationServiceEvaluateCheckoutResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      MonetizationServiceEvaluateCheckoutResponse._();
  @$core.override
  MonetizationServiceEvaluateCheckoutResponse createEmptyInstance() =>
      MonetizationServiceEvaluateCheckoutResponse._();
  @$core.pragma('dart2js:noInline')
  static MonetizationServiceEvaluateCheckoutResponse getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
              MonetizationServiceEvaluateCheckoutResponse>(
          MonetizationServiceEvaluateCheckoutResponse.$_createMessage);
  static MonetizationServiceEvaluateCheckoutResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get accepted => $_getBF(0);
  @$pb.TagNumber(1)
  set accepted($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAccepted() => $_has(0);
  @$pb.TagNumber(1)
  void clearAccepted() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get errorCode => $_getSZ(1);
  @$pb.TagNumber(2)
  set errorCode($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasErrorCode() => $_has(1);
  @$pb.TagNumber(2)
  void clearErrorCode() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get errorMessage => $_getSZ(2);
  @$pb.TagNumber(3)
  set errorMessage($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasErrorMessage() => $_has(2);
  @$pb.TagNumber(3)
  void clearErrorMessage() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get originalAmount => $_getSZ(3);
  @$pb.TagNumber(4)
  set originalAmount($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasOriginalAmount() => $_has(3);
  @$pb.TagNumber(4)
  void clearOriginalAmount() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get discountAmount => $_getSZ(4);
  @$pb.TagNumber(5)
  set discountAmount($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasDiscountAmount() => $_has(4);
  @$pb.TagNumber(5)
  void clearDiscountAmount() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get netPayableAmount => $_getSZ(5);
  @$pb.TagNumber(6)
  set netPayableAmount($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasNetPayableAmount() => $_has(5);
  @$pb.TagNumber(6)
  void clearNetPayableAmount() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get currency => $_getSZ(6);
  @$pb.TagNumber(7)
  set currency($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasCurrency() => $_has(6);
  @$pb.TagNumber(7)
  void clearCurrency() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get orderId => $_getSZ(7);
  @$pb.TagNumber(8)
  set orderId($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasOrderId() => $_has(7);
  @$pb.TagNumber(8)
  void clearOrderId() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get postingId => $_getSZ(8);
  @$pb.TagNumber(9)
  set postingId($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasPostingId() => $_has(8);
  @$pb.TagNumber(9)
  void clearPostingId() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.String get couponId => $_getSZ(9);
  @$pb.TagNumber(10)
  set couponId($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasCouponId() => $_has(9);
  @$pb.TagNumber(10)
  void clearCouponId() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.int get couponRemainingUses => $_getIZ(10);
  @$pb.TagNumber(11)
  set couponRemainingUses($core.int value) => $_setSignedInt32(10, value);
  @$pb.TagNumber(11)
  $core.bool hasCouponRemainingUses() => $_has(10);
  @$pb.TagNumber(11)
  void clearCouponRemainingUses() => $_clearField(11);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');

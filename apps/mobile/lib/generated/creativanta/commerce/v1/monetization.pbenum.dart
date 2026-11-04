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

import 'package:protobuf/protobuf.dart' as $pb;

/// Offer classifications per PRD §23.14 & DB Schema §10.2.
class OfferType extends $pb.ProtobufEnum {
  static const OfferType OFFER_TYPE_UNSPECIFIED =
      OfferType._(0, _omitEnumNames ? '' : 'OFFER_TYPE_UNSPECIFIED');
  static const OfferType OFFER_TYPE_PRODUCT_OFFER =
      OfferType._(1, _omitEnumNames ? '' : 'OFFER_TYPE_PRODUCT_OFFER');
  static const OfferType OFFER_TYPE_DIGITAL_OFFER =
      OfferType._(2, _omitEnumNames ? '' : 'OFFER_TYPE_DIGITAL_OFFER');
  static const OfferType OFFER_TYPE_MEMBERSHIP_OFFER =
      OfferType._(3, _omitEnumNames ? '' : 'OFFER_TYPE_MEMBERSHIP_OFFER');
  static const OfferType OFFER_TYPE_BUNDLE_OFFER =
      OfferType._(4, _omitEnumNames ? '' : 'OFFER_TYPE_BUNDLE_OFFER');
  static const OfferType OFFER_TYPE_AFFILIATE_OFFER =
      OfferType._(5, _omitEnumNames ? '' : 'OFFER_TYPE_AFFILIATE_OFFER');
  static const OfferType OFFER_TYPE_SPONSOR_OFFER =
      OfferType._(6, _omitEnumNames ? '' : 'OFFER_TYPE_SPONSOR_OFFER');

  static const $core.List<OfferType> values = <OfferType>[
    OFFER_TYPE_UNSPECIFIED,
    OFFER_TYPE_PRODUCT_OFFER,
    OFFER_TYPE_DIGITAL_OFFER,
    OFFER_TYPE_MEMBERSHIP_OFFER,
    OFFER_TYPE_BUNDLE_OFFER,
    OFFER_TYPE_AFFILIATE_OFFER,
    OFFER_TYPE_SPONSOR_OFFER,
  ];

  static final $core.List<OfferType?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 6);
  static OfferType? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const OfferType._(super.value, super.name);
}

/// Canonical offer lifecycle state machine per RULE-M14-002.
class OfferLifecycleState extends $pb.ProtobufEnum {
  static const OfferLifecycleState OFFER_LIFECYCLE_STATE_UNSPECIFIED =
      OfferLifecycleState._(
          0, _omitEnumNames ? '' : 'OFFER_LIFECYCLE_STATE_UNSPECIFIED');
  static const OfferLifecycleState OFFER_LIFECYCLE_STATE_DRAFT =
      OfferLifecycleState._(
          1, _omitEnumNames ? '' : 'OFFER_LIFECYCLE_STATE_DRAFT');
  static const OfferLifecycleState OFFER_LIFECYCLE_STATE_REVIEW_REQUIRED =
      OfferLifecycleState._(
          2, _omitEnumNames ? '' : 'OFFER_LIFECYCLE_STATE_REVIEW_REQUIRED');
  static const OfferLifecycleState OFFER_LIFECYCLE_STATE_ACTIVE =
      OfferLifecycleState._(
          3, _omitEnumNames ? '' : 'OFFER_LIFECYCLE_STATE_ACTIVE');
  static const OfferLifecycleState OFFER_LIFECYCLE_STATE_PAUSED =
      OfferLifecycleState._(
          4, _omitEnumNames ? '' : 'OFFER_LIFECYCLE_STATE_PAUSED');
  static const OfferLifecycleState OFFER_LIFECYCLE_STATE_EXPIRED =
      OfferLifecycleState._(
          5, _omitEnumNames ? '' : 'OFFER_LIFECYCLE_STATE_EXPIRED');
  static const OfferLifecycleState OFFER_LIFECYCLE_STATE_RETIRED =
      OfferLifecycleState._(
          6, _omitEnumNames ? '' : 'OFFER_LIFECYCLE_STATE_RETIRED');

  static const $core.List<OfferLifecycleState> values = <OfferLifecycleState>[
    OFFER_LIFECYCLE_STATE_UNSPECIFIED,
    OFFER_LIFECYCLE_STATE_DRAFT,
    OFFER_LIFECYCLE_STATE_REVIEW_REQUIRED,
    OFFER_LIFECYCLE_STATE_ACTIVE,
    OFFER_LIFECYCLE_STATE_PAUSED,
    OFFER_LIFECYCLE_STATE_EXPIRED,
    OFFER_LIFECYCLE_STATE_RETIRED,
  ];

  static final $core.List<OfferLifecycleState?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 6);
  static OfferLifecycleState? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const OfferLifecycleState._(super.value, super.name);
}

/// Coupon classification per DB Schema §19.2.
class CouponType extends $pb.ProtobufEnum {
  static const CouponType COUPON_TYPE_UNSPECIFIED =
      CouponType._(0, _omitEnumNames ? '' : 'COUPON_TYPE_UNSPECIFIED');
  static const CouponType COUPON_TYPE_PERCENTAGE =
      CouponType._(1, _omitEnumNames ? '' : 'COUPON_TYPE_PERCENTAGE');
  static const CouponType COUPON_TYPE_FIXED_AMOUNT =
      CouponType._(2, _omitEnumNames ? '' : 'COUPON_TYPE_FIXED_AMOUNT');
  static const CouponType COUPON_TYPE_FREE_SHIPPING =
      CouponType._(3, _omitEnumNames ? '' : 'COUPON_TYPE_FREE_SHIPPING');

  static const $core.List<CouponType> values = <CouponType>[
    COUPON_TYPE_UNSPECIFIED,
    COUPON_TYPE_PERCENTAGE,
    COUPON_TYPE_FIXED_AMOUNT,
    COUPON_TYPE_FREE_SHIPPING,
  ];

  static final $core.List<CouponType?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 3);
  static CouponType? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const CouponType._(super.value, super.name);
}

/// Canonical coupon lifecycle state machine per RULE-M14-003.
class CouponLifecycleState extends $pb.ProtobufEnum {
  static const CouponLifecycleState COUPON_LIFECYCLE_STATE_UNSPECIFIED =
      CouponLifecycleState._(
          0, _omitEnumNames ? '' : 'COUPON_LIFECYCLE_STATE_UNSPECIFIED');
  static const CouponLifecycleState COUPON_LIFECYCLE_STATE_DRAFT =
      CouponLifecycleState._(
          1, _omitEnumNames ? '' : 'COUPON_LIFECYCLE_STATE_DRAFT');
  static const CouponLifecycleState COUPON_LIFECYCLE_STATE_ACTIVE =
      CouponLifecycleState._(
          2, _omitEnumNames ? '' : 'COUPON_LIFECYCLE_STATE_ACTIVE');
  static const CouponLifecycleState COUPON_LIFECYCLE_STATE_PAUSED =
      CouponLifecycleState._(
          3, _omitEnumNames ? '' : 'COUPON_LIFECYCLE_STATE_PAUSED');
  static const CouponLifecycleState COUPON_LIFECYCLE_STATE_EXPIRED =
      CouponLifecycleState._(
          4, _omitEnumNames ? '' : 'COUPON_LIFECYCLE_STATE_EXPIRED');
  static const CouponLifecycleState COUPON_LIFECYCLE_STATE_RETIRED =
      CouponLifecycleState._(
          5, _omitEnumNames ? '' : 'COUPON_LIFECYCLE_STATE_RETIRED');
  static const CouponLifecycleState COUPON_LIFECYCLE_STATE_REVOKED =
      CouponLifecycleState._(
          6, _omitEnumNames ? '' : 'COUPON_LIFECYCLE_STATE_REVOKED');

  static const $core.List<CouponLifecycleState> values = <CouponLifecycleState>[
    COUPON_LIFECYCLE_STATE_UNSPECIFIED,
    COUPON_LIFECYCLE_STATE_DRAFT,
    COUPON_LIFECYCLE_STATE_ACTIVE,
    COUPON_LIFECYCLE_STATE_PAUSED,
    COUPON_LIFECYCLE_STATE_EXPIRED,
    COUPON_LIFECYCLE_STATE_RETIRED,
    COUPON_LIFECYCLE_STATE_REVOKED,
  ];

  static final $core.List<CouponLifecycleState?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 6);
  static CouponLifecycleState? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const CouponLifecycleState._(super.value, super.name);
}

/// Campaign classifications per DB Schema §10.5.
class CampaignType extends $pb.ProtobufEnum {
  static const CampaignType CAMPAIGN_TYPE_UNSPECIFIED =
      CampaignType._(0, _omitEnumNames ? '' : 'CAMPAIGN_TYPE_UNSPECIFIED');
  static const CampaignType CAMPAIGN_TYPE_CONTENT =
      CampaignType._(1, _omitEnumNames ? '' : 'CAMPAIGN_TYPE_CONTENT');
  static const CampaignType CAMPAIGN_TYPE_AFFILIATE =
      CampaignType._(2, _omitEnumNames ? '' : 'CAMPAIGN_TYPE_AFFILIATE');
  static const CampaignType CAMPAIGN_TYPE_SEEDING =
      CampaignType._(3, _omitEnumNames ? '' : 'CAMPAIGN_TYPE_SEEDING');
  static const CampaignType CAMPAIGN_TYPE_LIVE =
      CampaignType._(4, _omitEnumNames ? '' : 'CAMPAIGN_TYPE_LIVE');
  static const CampaignType CAMPAIGN_TYPE_BRAND_COLLAB =
      CampaignType._(5, _omitEnumNames ? '' : 'CAMPAIGN_TYPE_BRAND_COLLAB');

  static const $core.List<CampaignType> values = <CampaignType>[
    CAMPAIGN_TYPE_UNSPECIFIED,
    CAMPAIGN_TYPE_CONTENT,
    CAMPAIGN_TYPE_AFFILIATE,
    CAMPAIGN_TYPE_SEEDING,
    CAMPAIGN_TYPE_LIVE,
    CAMPAIGN_TYPE_BRAND_COLLAB,
  ];

  static final $core.List<CampaignType?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 5);
  static CampaignType? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const CampaignType._(super.value, super.name);
}

/// Canonical campaign lifecycle status per RULE-M14-004.
class CampaignStatus extends $pb.ProtobufEnum {
  static const CampaignStatus CAMPAIGN_STATUS_UNSPECIFIED =
      CampaignStatus._(0, _omitEnumNames ? '' : 'CAMPAIGN_STATUS_UNSPECIFIED');
  static const CampaignStatus CAMPAIGN_STATUS_PLANNED =
      CampaignStatus._(1, _omitEnumNames ? '' : 'CAMPAIGN_STATUS_PLANNED');
  static const CampaignStatus CAMPAIGN_STATUS_READY =
      CampaignStatus._(2, _omitEnumNames ? '' : 'CAMPAIGN_STATUS_READY');
  static const CampaignStatus CAMPAIGN_STATUS_LIVE =
      CampaignStatus._(3, _omitEnumNames ? '' : 'CAMPAIGN_STATUS_LIVE');
  static const CampaignStatus CAMPAIGN_STATUS_PAUSED =
      CampaignStatus._(4, _omitEnumNames ? '' : 'CAMPAIGN_STATUS_PAUSED');
  static const CampaignStatus CAMPAIGN_STATUS_COMPLETED =
      CampaignStatus._(5, _omitEnumNames ? '' : 'CAMPAIGN_STATUS_COMPLETED');
  static const CampaignStatus CAMPAIGN_STATUS_CANCELLED =
      CampaignStatus._(6, _omitEnumNames ? '' : 'CAMPAIGN_STATUS_CANCELLED');

  static const $core.List<CampaignStatus> values = <CampaignStatus>[
    CAMPAIGN_STATUS_UNSPECIFIED,
    CAMPAIGN_STATUS_PLANNED,
    CAMPAIGN_STATUS_READY,
    CAMPAIGN_STATUS_LIVE,
    CAMPAIGN_STATUS_PAUSED,
    CAMPAIGN_STATUS_COMPLETED,
    CAMPAIGN_STATUS_CANCELLED,
  ];

  static final $core.List<CampaignStatus?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 6);
  static CampaignStatus? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const CampaignStatus._(super.value, super.name);
}

const $core.bool _omitEnumNames =
    $core.bool.fromEnvironment('protobuf.omit_enum_names');

// This is a generated file - do not edit.
//
// Generated from creativanta/platform/v1/referral.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

/// Referral status per canonical state machine (referral_growth.md §5).
class ReferralStatus extends $pb.ProtobufEnum {
  static const ReferralStatus REFERRAL_STATUS_UNSPECIFIED =
      ReferralStatus._(0, _omitEnumNames ? '' : 'REFERRAL_STATUS_UNSPECIFIED');
  static const ReferralStatus REFERRAL_STATUS_PENDING =
      ReferralStatus._(1, _omitEnumNames ? '' : 'REFERRAL_STATUS_PENDING');
  static const ReferralStatus REFERRAL_STATUS_QUALIFIED =
      ReferralStatus._(2, _omitEnumNames ? '' : 'REFERRAL_STATUS_QUALIFIED');
  static const ReferralStatus REFERRAL_STATUS_REWARDED =
      ReferralStatus._(3, _omitEnumNames ? '' : 'REFERRAL_STATUS_REWARDED');
  static const ReferralStatus REFERRAL_STATUS_REVOKED =
      ReferralStatus._(4, _omitEnumNames ? '' : 'REFERRAL_STATUS_REVOKED');
  static const ReferralStatus REFERRAL_STATUS_EXPIRED =
      ReferralStatus._(5, _omitEnumNames ? '' : 'REFERRAL_STATUS_EXPIRED');
  static const ReferralStatus REFERRAL_STATUS_FRAUD_FLAGGED = ReferralStatus._(
      6, _omitEnumNames ? '' : 'REFERRAL_STATUS_FRAUD_FLAGGED');
  static const ReferralStatus REFERRAL_STATUS_FORFEITED =
      ReferralStatus._(7, _omitEnumNames ? '' : 'REFERRAL_STATUS_FORFEITED');

  static const $core.List<ReferralStatus> values = <ReferralStatus>[
    REFERRAL_STATUS_UNSPECIFIED,
    REFERRAL_STATUS_PENDING,
    REFERRAL_STATUS_QUALIFIED,
    REFERRAL_STATUS_REWARDED,
    REFERRAL_STATUS_REVOKED,
    REFERRAL_STATUS_EXPIRED,
    REFERRAL_STATUS_FRAUD_FLAGGED,
    REFERRAL_STATUS_FORFEITED,
  ];

  static final $core.List<ReferralStatus?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 7);
  static ReferralStatus? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const ReferralStatus._(super.value, super.name);
}

/// Referral reward tiers with escalating multipliers (referral_growth.md §4.2).
class ReferralTier extends $pb.ProtobufEnum {
  static const ReferralTier REFERRAL_TIER_UNSPECIFIED =
      ReferralTier._(0, _omitEnumNames ? '' : 'REFERRAL_TIER_UNSPECIFIED');
  static const ReferralTier REFERRAL_TIER_BRONZE =
      ReferralTier._(1, _omitEnumNames ? '' : 'REFERRAL_TIER_BRONZE');
  static const ReferralTier REFERRAL_TIER_SILVER =
      ReferralTier._(2, _omitEnumNames ? '' : 'REFERRAL_TIER_SILVER');
  static const ReferralTier REFERRAL_TIER_GOLD =
      ReferralTier._(3, _omitEnumNames ? '' : 'REFERRAL_TIER_GOLD');
  static const ReferralTier REFERRAL_TIER_PLATINUM =
      ReferralTier._(4, _omitEnumNames ? '' : 'REFERRAL_TIER_PLATINUM');

  static const $core.List<ReferralTier> values = <ReferralTier>[
    REFERRAL_TIER_UNSPECIFIED,
    REFERRAL_TIER_BRONZE,
    REFERRAL_TIER_SILVER,
    REFERRAL_TIER_GOLD,
    REFERRAL_TIER_PLATINUM,
  ];

  static final $core.List<ReferralTier?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 4);
  static ReferralTier? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const ReferralTier._(super.value, super.name);
}

/// In-product viral and growth trigger points (referral_growth.md §3.4).
class GrowthTriggerType extends $pb.ProtobufEnum {
  static const GrowthTriggerType GROWTH_TRIGGER_TYPE_UNSPECIFIED =
      GrowthTriggerType._(
          0, _omitEnumNames ? '' : 'GROWTH_TRIGGER_TYPE_UNSPECIFIED');
  static const GrowthTriggerType GROWTH_TRIGGER_TYPE_FIRST_PUBLISH =
      GrowthTriggerType._(
          1, _omitEnumNames ? '' : 'GROWTH_TRIGGER_TYPE_FIRST_PUBLISH');
  static const GrowthTriggerType GROWTH_TRIGGER_TYPE_FIRST_PROFIT =
      GrowthTriggerType._(
          2, _omitEnumNames ? '' : 'GROWTH_TRIGGER_TYPE_FIRST_PROFIT');
  static const GrowthTriggerType GROWTH_TRIGGER_TYPE_FOLLOWER_MILESTONE =
      GrowthTriggerType._(
          3, _omitEnumNames ? '' : 'GROWTH_TRIGGER_TYPE_FOLLOWER_MILESTONE');
  static const GrowthTriggerType GROWTH_TRIGGER_TYPE_TEAM_INVITE =
      GrowthTriggerType._(
          4, _omitEnumNames ? '' : 'GROWTH_TRIGGER_TYPE_TEAM_INVITE');
  static const GrowthTriggerType GROWTH_TRIGGER_TYPE_RECIPE_SUBMIT =
      GrowthTriggerType._(
          5, _omitEnumNames ? '' : 'GROWTH_TRIGGER_TYPE_RECIPE_SUBMIT');
  static const GrowthTriggerType GROWTH_TRIGGER_TYPE_FEATURE_UPVOTE =
      GrowthTriggerType._(
          6, _omitEnumNames ? '' : 'GROWTH_TRIGGER_TYPE_FEATURE_UPVOTE');

  static const $core.List<GrowthTriggerType> values = <GrowthTriggerType>[
    GROWTH_TRIGGER_TYPE_UNSPECIFIED,
    GROWTH_TRIGGER_TYPE_FIRST_PUBLISH,
    GROWTH_TRIGGER_TYPE_FIRST_PROFIT,
    GROWTH_TRIGGER_TYPE_FOLLOWER_MILESTONE,
    GROWTH_TRIGGER_TYPE_TEAM_INVITE,
    GROWTH_TRIGGER_TYPE_RECIPE_SUBMIT,
    GROWTH_TRIGGER_TYPE_FEATURE_UPVOTE,
  ];

  static final $core.List<GrowthTriggerType?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 6);
  static GrowthTriggerType? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const GrowthTriggerType._(super.value, super.name);
}

const $core.bool _omitEnumNames =
    $core.bool.fromEnvironment('protobuf.omit_enum_names');

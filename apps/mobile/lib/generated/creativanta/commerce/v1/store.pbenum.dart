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

import 'package:protobuf/protobuf.dart' as $pb;

class StorePageStatus extends $pb.ProtobufEnum {
  static const StorePageStatus STORE_PAGE_STATUS_UNSPECIFIED =
      StorePageStatus._(
          0, _omitEnumNames ? '' : 'STORE_PAGE_STATUS_UNSPECIFIED');
  static const StorePageStatus STORE_PAGE_STATUS_DRAFT =
      StorePageStatus._(1, _omitEnumNames ? '' : 'STORE_PAGE_STATUS_DRAFT');
  static const StorePageStatus STORE_PAGE_STATUS_PUBLISHED =
      StorePageStatus._(2, _omitEnumNames ? '' : 'STORE_PAGE_STATUS_PUBLISHED');
  static const StorePageStatus STORE_PAGE_STATUS_HIDDEN =
      StorePageStatus._(3, _omitEnumNames ? '' : 'STORE_PAGE_STATUS_HIDDEN');
  static const StorePageStatus STORE_PAGE_STATUS_RETIRED =
      StorePageStatus._(4, _omitEnumNames ? '' : 'STORE_PAGE_STATUS_RETIRED');

  static const $core.List<StorePageStatus> values = <StorePageStatus>[
    STORE_PAGE_STATUS_UNSPECIFIED,
    STORE_PAGE_STATUS_DRAFT,
    STORE_PAGE_STATUS_PUBLISHED,
    STORE_PAGE_STATUS_HIDDEN,
    STORE_PAGE_STATUS_RETIRED,
  ];

  static final $core.List<StorePageStatus?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 4);
  static StorePageStatus? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const StorePageStatus._(super.value, super.name);
}

class MembershipPlanStatus extends $pb.ProtobufEnum {
  static const MembershipPlanStatus MEMBERSHIP_PLAN_STATUS_UNSPECIFIED =
      MembershipPlanStatus._(
          0, _omitEnumNames ? '' : 'MEMBERSHIP_PLAN_STATUS_UNSPECIFIED');
  static const MembershipPlanStatus MEMBERSHIP_PLAN_STATUS_DRAFT =
      MembershipPlanStatus._(
          1, _omitEnumNames ? '' : 'MEMBERSHIP_PLAN_STATUS_DRAFT');
  static const MembershipPlanStatus MEMBERSHIP_PLAN_STATUS_ACTIVE =
      MembershipPlanStatus._(
          2, _omitEnumNames ? '' : 'MEMBERSHIP_PLAN_STATUS_ACTIVE');
  static const MembershipPlanStatus MEMBERSHIP_PLAN_STATUS_HIDDEN =
      MembershipPlanStatus._(
          3, _omitEnumNames ? '' : 'MEMBERSHIP_PLAN_STATUS_HIDDEN');
  static const MembershipPlanStatus MEMBERSHIP_PLAN_STATUS_PAUSED =
      MembershipPlanStatus._(
          4, _omitEnumNames ? '' : 'MEMBERSHIP_PLAN_STATUS_PAUSED');
  static const MembershipPlanStatus MEMBERSHIP_PLAN_STATUS_RETIRED =
      MembershipPlanStatus._(
          5, _omitEnumNames ? '' : 'MEMBERSHIP_PLAN_STATUS_RETIRED');

  static const $core.List<MembershipPlanStatus> values = <MembershipPlanStatus>[
    MEMBERSHIP_PLAN_STATUS_UNSPECIFIED,
    MEMBERSHIP_PLAN_STATUS_DRAFT,
    MEMBERSHIP_PLAN_STATUS_ACTIVE,
    MEMBERSHIP_PLAN_STATUS_HIDDEN,
    MEMBERSHIP_PLAN_STATUS_PAUSED,
    MEMBERSHIP_PLAN_STATUS_RETIRED,
  ];

  static final $core.List<MembershipPlanStatus?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 5);
  static MembershipPlanStatus? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const MembershipPlanStatus._(super.value, super.name);
}

class MembershipSubscriptionStatus extends $pb.ProtobufEnum {
  static const MembershipSubscriptionStatus
      MEMBERSHIP_SUBSCRIPTION_STATUS_UNSPECIFIED =
      MembershipSubscriptionStatus._(0,
          _omitEnumNames ? '' : 'MEMBERSHIP_SUBSCRIPTION_STATUS_UNSPECIFIED');
  static const MembershipSubscriptionStatus
      MEMBERSHIP_SUBSCRIPTION_STATUS_ACTIVE = MembershipSubscriptionStatus._(
          1, _omitEnumNames ? '' : 'MEMBERSHIP_SUBSCRIPTION_STATUS_ACTIVE');
  static const MembershipSubscriptionStatus
      MEMBERSHIP_SUBSCRIPTION_STATUS_CANCELLED = MembershipSubscriptionStatus._(
          2, _omitEnumNames ? '' : 'MEMBERSHIP_SUBSCRIPTION_STATUS_CANCELLED');
  static const MembershipSubscriptionStatus
      MEMBERSHIP_SUBSCRIPTION_STATUS_EXPIRED = MembershipSubscriptionStatus._(
          3, _omitEnumNames ? '' : 'MEMBERSHIP_SUBSCRIPTION_STATUS_EXPIRED');

  static const $core.List<MembershipSubscriptionStatus> values =
      <MembershipSubscriptionStatus>[
    MEMBERSHIP_SUBSCRIPTION_STATUS_UNSPECIFIED,
    MEMBERSHIP_SUBSCRIPTION_STATUS_ACTIVE,
    MEMBERSHIP_SUBSCRIPTION_STATUS_CANCELLED,
    MEMBERSHIP_SUBSCRIPTION_STATUS_EXPIRED,
  ];

  static final $core.List<MembershipSubscriptionStatus?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 3);
  static MembershipSubscriptionStatus? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const MembershipSubscriptionStatus._(super.value, super.name);
}

class DeliveryType extends $pb.ProtobufEnum {
  static const DeliveryType DELIVERY_TYPE_UNSPECIFIED =
      DeliveryType._(0, _omitEnumNames ? '' : 'DELIVERY_TYPE_UNSPECIFIED');
  static const DeliveryType DELIVERY_TYPE_DOWNLOAD_LINK =
      DeliveryType._(1, _omitEnumNames ? '' : 'DELIVERY_TYPE_DOWNLOAD_LINK');
  static const DeliveryType DELIVERY_TYPE_LICENSE_KEY =
      DeliveryType._(2, _omitEnumNames ? '' : 'DELIVERY_TYPE_LICENSE_KEY');
  static const DeliveryType DELIVERY_TYPE_ACCESS_GRANT =
      DeliveryType._(3, _omitEnumNames ? '' : 'DELIVERY_TYPE_ACCESS_GRANT');

  static const $core.List<DeliveryType> values = <DeliveryType>[
    DELIVERY_TYPE_UNSPECIFIED,
    DELIVERY_TYPE_DOWNLOAD_LINK,
    DELIVERY_TYPE_LICENSE_KEY,
    DELIVERY_TYPE_ACCESS_GRANT,
  ];

  static final $core.List<DeliveryType?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 3);
  static DeliveryType? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const DeliveryType._(super.value, super.name);
}

class DeliveryStatus extends $pb.ProtobufEnum {
  static const DeliveryStatus DELIVERY_STATUS_UNSPECIFIED =
      DeliveryStatus._(0, _omitEnumNames ? '' : 'DELIVERY_STATUS_UNSPECIFIED');
  static const DeliveryStatus DELIVERY_STATUS_PENDING =
      DeliveryStatus._(1, _omitEnumNames ? '' : 'DELIVERY_STATUS_PENDING');
  static const DeliveryStatus DELIVERY_STATUS_DELIVERED =
      DeliveryStatus._(2, _omitEnumNames ? '' : 'DELIVERY_STATUS_DELIVERED');
  static const DeliveryStatus DELIVERY_STATUS_REVOKED =
      DeliveryStatus._(3, _omitEnumNames ? '' : 'DELIVERY_STATUS_REVOKED');

  static const $core.List<DeliveryStatus> values = <DeliveryStatus>[
    DELIVERY_STATUS_UNSPECIFIED,
    DELIVERY_STATUS_PENDING,
    DELIVERY_STATUS_DELIVERED,
    DELIVERY_STATUS_REVOKED,
  ];

  static final $core.List<DeliveryStatus?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 3);
  static DeliveryStatus? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const DeliveryStatus._(super.value, super.name);
}

const $core.bool _omitEnumNames =
    $core.bool.fromEnvironment('protobuf.omit_enum_names');

// This is a generated file - do not edit.
//
// Generated from creativanta/admin/v1/billing.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

/// Canonical credit lot source types (§26.3).
class CreditSourceType extends $pb.ProtobufEnum {
  static const CreditSourceType CREDIT_SOURCE_TYPE_UNSPECIFIED =
      CreditSourceType._(
          0, _omitEnumNames ? '' : 'CREDIT_SOURCE_TYPE_UNSPECIFIED');
  static const CreditSourceType CREDIT_SOURCE_TYPE_SUBSCRIPTION =
      CreditSourceType._(
          1, _omitEnumNames ? '' : 'CREDIT_SOURCE_TYPE_SUBSCRIPTION');
  static const CreditSourceType CREDIT_SOURCE_TYPE_PURCHASED =
      CreditSourceType._(
          2, _omitEnumNames ? '' : 'CREDIT_SOURCE_TYPE_PURCHASED');
  static const CreditSourceType CREDIT_SOURCE_TYPE_PROMOTIONAL =
      CreditSourceType._(
          3, _omitEnumNames ? '' : 'CREDIT_SOURCE_TYPE_PROMOTIONAL');
  static const CreditSourceType CREDIT_SOURCE_TYPE_OVERAGE =
      CreditSourceType._(4, _omitEnumNames ? '' : 'CREDIT_SOURCE_TYPE_OVERAGE');

  static const $core.List<CreditSourceType> values = <CreditSourceType>[
    CREDIT_SOURCE_TYPE_UNSPECIFIED,
    CREDIT_SOURCE_TYPE_SUBSCRIPTION,
    CREDIT_SOURCE_TYPE_PURCHASED,
    CREDIT_SOURCE_TYPE_PROMOTIONAL,
    CREDIT_SOURCE_TYPE_OVERAGE,
  ];

  static final $core.List<CreditSourceType?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 4);
  static CreditSourceType? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const CreditSourceType._(super.value, super.name);
}

/// Canonical credit reservation states (§26.4).
class CreditReservationStatus extends $pb.ProtobufEnum {
  static const CreditReservationStatus CREDIT_RESERVATION_STATUS_UNSPECIFIED =
      CreditReservationStatus._(
          0, _omitEnumNames ? '' : 'CREDIT_RESERVATION_STATUS_UNSPECIFIED');
  static const CreditReservationStatus CREDIT_RESERVATION_STATUS_HELD =
      CreditReservationStatus._(
          1, _omitEnumNames ? '' : 'CREDIT_RESERVATION_STATUS_HELD');
  static const CreditReservationStatus CREDIT_RESERVATION_STATUS_IN_FLIGHT =
      CreditReservationStatus._(
          2, _omitEnumNames ? '' : 'CREDIT_RESERVATION_STATUS_IN_FLIGHT');
  static const CreditReservationStatus CREDIT_RESERVATION_STATUS_RECONCILING =
      CreditReservationStatus._(
          3, _omitEnumNames ? '' : 'CREDIT_RESERVATION_STATUS_RECONCILING');
  static const CreditReservationStatus CREDIT_RESERVATION_STATUS_COMMITTED =
      CreditReservationStatus._(
          4, _omitEnumNames ? '' : 'CREDIT_RESERVATION_STATUS_COMMITTED');
  static const CreditReservationStatus CREDIT_RESERVATION_STATUS_RELEASED =
      CreditReservationStatus._(
          5, _omitEnumNames ? '' : 'CREDIT_RESERVATION_STATUS_RELEASED');
  static const CreditReservationStatus CREDIT_RESERVATION_STATUS_EXPIRED =
      CreditReservationStatus._(
          6, _omitEnumNames ? '' : 'CREDIT_RESERVATION_STATUS_EXPIRED');

  static const $core.List<CreditReservationStatus> values =
      <CreditReservationStatus>[
    CREDIT_RESERVATION_STATUS_UNSPECIFIED,
    CREDIT_RESERVATION_STATUS_HELD,
    CREDIT_RESERVATION_STATUS_IN_FLIGHT,
    CREDIT_RESERVATION_STATUS_RECONCILING,
    CREDIT_RESERVATION_STATUS_COMMITTED,
    CREDIT_RESERVATION_STATUS_RELEASED,
    CREDIT_RESERVATION_STATUS_EXPIRED,
  ];

  static final $core.List<CreditReservationStatus?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 6);
  static CreditReservationStatus? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const CreditReservationStatus._(super.value, super.name);
}

/// Canonical subscription lifecycle statuses (§19.1).
class SubscriptionStatus extends $pb.ProtobufEnum {
  static const SubscriptionStatus SUBSCRIPTION_STATUS_UNSPECIFIED =
      SubscriptionStatus._(
          0, _omitEnumNames ? '' : 'SUBSCRIPTION_STATUS_UNSPECIFIED');
  static const SubscriptionStatus SUBSCRIPTION_STATUS_ACTIVE =
      SubscriptionStatus._(
          1, _omitEnumNames ? '' : 'SUBSCRIPTION_STATUS_ACTIVE');
  static const SubscriptionStatus SUBSCRIPTION_STATUS_PAST_DUE =
      SubscriptionStatus._(
          2, _omitEnumNames ? '' : 'SUBSCRIPTION_STATUS_PAST_DUE');
  static const SubscriptionStatus SUBSCRIPTION_STATUS_CANCELED =
      SubscriptionStatus._(
          3, _omitEnumNames ? '' : 'SUBSCRIPTION_STATUS_CANCELED');
  static const SubscriptionStatus SUBSCRIPTION_STATUS_TRIALING =
      SubscriptionStatus._(
          4, _omitEnumNames ? '' : 'SUBSCRIPTION_STATUS_TRIALING');
  static const SubscriptionStatus SUBSCRIPTION_STATUS_INCOMPLETE =
      SubscriptionStatus._(
          5, _omitEnumNames ? '' : 'SUBSCRIPTION_STATUS_INCOMPLETE');
  static const SubscriptionStatus SUBSCRIPTION_STATUS_PAUSED =
      SubscriptionStatus._(
          6, _omitEnumNames ? '' : 'SUBSCRIPTION_STATUS_PAUSED');

  static const $core.List<SubscriptionStatus> values = <SubscriptionStatus>[
    SUBSCRIPTION_STATUS_UNSPECIFIED,
    SUBSCRIPTION_STATUS_ACTIVE,
    SUBSCRIPTION_STATUS_PAST_DUE,
    SUBSCRIPTION_STATUS_CANCELED,
    SUBSCRIPTION_STATUS_TRIALING,
    SUBSCRIPTION_STATUS_INCOMPLETE,
    SUBSCRIPTION_STATUS_PAUSED,
  ];

  static final $core.List<SubscriptionStatus?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 6);
  static SubscriptionStatus? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const SubscriptionStatus._(super.value, super.name);
}

/// Canonical invoice statuses (§19.1B).
class InvoiceStatus extends $pb.ProtobufEnum {
  static const InvoiceStatus INVOICE_STATUS_UNSPECIFIED =
      InvoiceStatus._(0, _omitEnumNames ? '' : 'INVOICE_STATUS_UNSPECIFIED');
  static const InvoiceStatus INVOICE_STATUS_DRAFT =
      InvoiceStatus._(1, _omitEnumNames ? '' : 'INVOICE_STATUS_DRAFT');
  static const InvoiceStatus INVOICE_STATUS_OPEN =
      InvoiceStatus._(2, _omitEnumNames ? '' : 'INVOICE_STATUS_OPEN');
  static const InvoiceStatus INVOICE_STATUS_PAID =
      InvoiceStatus._(3, _omitEnumNames ? '' : 'INVOICE_STATUS_PAID');
  static const InvoiceStatus INVOICE_STATUS_VOID =
      InvoiceStatus._(4, _omitEnumNames ? '' : 'INVOICE_STATUS_VOID');
  static const InvoiceStatus INVOICE_STATUS_UNCOLLECTIBLE =
      InvoiceStatus._(5, _omitEnumNames ? '' : 'INVOICE_STATUS_UNCOLLECTIBLE');

  static const $core.List<InvoiceStatus> values = <InvoiceStatus>[
    INVOICE_STATUS_UNSPECIFIED,
    INVOICE_STATUS_DRAFT,
    INVOICE_STATUS_OPEN,
    INVOICE_STATUS_PAID,
    INVOICE_STATUS_VOID,
    INVOICE_STATUS_UNCOLLECTIBLE,
  ];

  static final $core.List<InvoiceStatus?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 5);
  static InvoiceStatus? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const InvoiceStatus._(super.value, super.name);
}

const $core.bool _omitEnumNames =
    $core.bool.fromEnvironment('protobuf.omit_enum_names');

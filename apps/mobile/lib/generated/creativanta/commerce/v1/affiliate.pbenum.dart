// This is a generated file - do not edit.
//
// Generated from creativanta/commerce/v1/affiliate.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

/// Canonical lifecycle state machine for affiliate links per M16.
class AffiliateLinkLifecycleState extends $pb.ProtobufEnum {
  static const AffiliateLinkLifecycleState
      AFFILIATE_LINK_LIFECYCLE_STATE_UNSPECIFIED =
      AffiliateLinkLifecycleState._(0,
          _omitEnumNames ? '' : 'AFFILIATE_LINK_LIFECYCLE_STATE_UNSPECIFIED');
  static const AffiliateLinkLifecycleState
      AFFILIATE_LINK_LIFECYCLE_STATE_DRAFT = AffiliateLinkLifecycleState._(
          1, _omitEnumNames ? '' : 'AFFILIATE_LINK_LIFECYCLE_STATE_DRAFT');
  static const AffiliateLinkLifecycleState
      AFFILIATE_LINK_LIFECYCLE_STATE_ACTIVE = AffiliateLinkLifecycleState._(
          2, _omitEnumNames ? '' : 'AFFILIATE_LINK_LIFECYCLE_STATE_ACTIVE');
  static const AffiliateLinkLifecycleState
      AFFILIATE_LINK_LIFECYCLE_STATE_PAUSED = AffiliateLinkLifecycleState._(
          3, _omitEnumNames ? '' : 'AFFILIATE_LINK_LIFECYCLE_STATE_PAUSED');
  static const AffiliateLinkLifecycleState
      AFFILIATE_LINK_LIFECYCLE_STATE_REVOKED = AffiliateLinkLifecycleState._(
          4, _omitEnumNames ? '' : 'AFFILIATE_LINK_LIFECYCLE_STATE_REVOKED');
  static const AffiliateLinkLifecycleState
      AFFILIATE_LINK_LIFECYCLE_STATE_EXPIRED = AffiliateLinkLifecycleState._(
          5, _omitEnumNames ? '' : 'AFFILIATE_LINK_LIFECYCLE_STATE_EXPIRED');

  static const $core.List<AffiliateLinkLifecycleState> values =
      <AffiliateLinkLifecycleState>[
    AFFILIATE_LINK_LIFECYCLE_STATE_UNSPECIFIED,
    AFFILIATE_LINK_LIFECYCLE_STATE_DRAFT,
    AFFILIATE_LINK_LIFECYCLE_STATE_ACTIVE,
    AFFILIATE_LINK_LIFECYCLE_STATE_PAUSED,
    AFFILIATE_LINK_LIFECYCLE_STATE_REVOKED,
    AFFILIATE_LINK_LIFECYCLE_STATE_EXPIRED,
  ];

  static final $core.List<AffiliateLinkLifecycleState?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 5);
  static AffiliateLinkLifecycleState? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const AffiliateLinkLifecycleState._(super.value, super.name);
}

/// Canonical health status for affiliate links (DB §10.4, §22.14).
class LinkHealthStatus extends $pb.ProtobufEnum {
  static const LinkHealthStatus LINK_HEALTH_STATUS_UNSPECIFIED =
      LinkHealthStatus._(
          0, _omitEnumNames ? '' : 'LINK_HEALTH_STATUS_UNSPECIFIED');
  static const LinkHealthStatus LINK_HEALTH_STATUS_HEALTHY =
      LinkHealthStatus._(1, _omitEnumNames ? '' : 'LINK_HEALTH_STATUS_HEALTHY');
  static const LinkHealthStatus LINK_HEALTH_STATUS_WARNING =
      LinkHealthStatus._(2, _omitEnumNames ? '' : 'LINK_HEALTH_STATUS_WARNING');
  static const LinkHealthStatus LINK_HEALTH_STATUS_BROKEN =
      LinkHealthStatus._(3, _omitEnumNames ? '' : 'LINK_HEALTH_STATUS_BROKEN');
  static const LinkHealthStatus LINK_HEALTH_STATUS_EXPIRED =
      LinkHealthStatus._(4, _omitEnumNames ? '' : 'LINK_HEALTH_STATUS_EXPIRED');
  static const LinkHealthStatus LINK_HEALTH_STATUS_PRODUCT_UNAVAILABLE =
      LinkHealthStatus._(
          5, _omitEnumNames ? '' : 'LINK_HEALTH_STATUS_PRODUCT_UNAVAILABLE');

  static const $core.List<LinkHealthStatus> values = <LinkHealthStatus>[
    LINK_HEALTH_STATUS_UNSPECIFIED,
    LINK_HEALTH_STATUS_HEALTHY,
    LINK_HEALTH_STATUS_WARNING,
    LINK_HEALTH_STATUS_BROKEN,
    LINK_HEALTH_STATUS_EXPIRED,
    LINK_HEALTH_STATUS_PRODUCT_UNAVAILABLE,
  ];

  static final $core.List<LinkHealthStatus?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 5);
  static LinkHealthStatus? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const LinkHealthStatus._(super.value, super.name);
}

/// Attribution source provenance classes per RULE-M16-001 & PRD §15.1.
class AttributionSourceClass extends $pb.ProtobufEnum {
  static const AttributionSourceClass ATTRIBUTION_SOURCE_CLASS_UNSPECIFIED =
      AttributionSourceClass._(
          0, _omitEnumNames ? '' : 'ATTRIBUTION_SOURCE_CLASS_UNSPECIFIED');
  static const AttributionSourceClass ATTRIBUTION_SOURCE_CLASS_OFFICIAL =
      AttributionSourceClass._(
          1, _omitEnumNames ? '' : 'ATTRIBUTION_SOURCE_CLASS_OFFICIAL');
  static const AttributionSourceClass ATTRIBUTION_SOURCE_CLASS_IMPORTED =
      AttributionSourceClass._(
          2, _omitEnumNames ? '' : 'ATTRIBUTION_SOURCE_CLASS_IMPORTED');
  static const AttributionSourceClass ATTRIBUTION_SOURCE_CLASS_INFERRED =
      AttributionSourceClass._(
          3, _omitEnumNames ? '' : 'ATTRIBUTION_SOURCE_CLASS_INFERRED');
  static const AttributionSourceClass ATTRIBUTION_SOURCE_CLASS_ESTIMATED =
      AttributionSourceClass._(
          4, _omitEnumNames ? '' : 'ATTRIBUTION_SOURCE_CLASS_ESTIMATED');
  static const AttributionSourceClass ATTRIBUTION_SOURCE_CLASS_UNRECONCILED =
      AttributionSourceClass._(
          5, _omitEnumNames ? '' : 'ATTRIBUTION_SOURCE_CLASS_UNRECONCILED');

  static const $core.List<AttributionSourceClass> values =
      <AttributionSourceClass>[
    ATTRIBUTION_SOURCE_CLASS_UNSPECIFIED,
    ATTRIBUTION_SOURCE_CLASS_OFFICIAL,
    ATTRIBUTION_SOURCE_CLASS_IMPORTED,
    ATTRIBUTION_SOURCE_CLASS_INFERRED,
    ATTRIBUTION_SOURCE_CLASS_ESTIMATED,
    ATTRIBUTION_SOURCE_CLASS_UNRECONCILED,
  ];

  static final $core.List<AttributionSourceClass?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 5);
  static AttributionSourceClass? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const AttributionSourceClass._(super.value, super.name);
}

/// Attribution confidence bands per RULE-M16-001 & M19.
class AttributionConfidence extends $pb.ProtobufEnum {
  static const AttributionConfidence ATTRIBUTION_CONFIDENCE_UNSPECIFIED =
      AttributionConfidence._(
          0, _omitEnumNames ? '' : 'ATTRIBUTION_CONFIDENCE_UNSPECIFIED');
  static const AttributionConfidence ATTRIBUTION_CONFIDENCE_HIGH =
      AttributionConfidence._(
          1, _omitEnumNames ? '' : 'ATTRIBUTION_CONFIDENCE_HIGH');
  static const AttributionConfidence ATTRIBUTION_CONFIDENCE_MEDIUM =
      AttributionConfidence._(
          2, _omitEnumNames ? '' : 'ATTRIBUTION_CONFIDENCE_MEDIUM');
  static const AttributionConfidence ATTRIBUTION_CONFIDENCE_LOW =
      AttributionConfidence._(
          3, _omitEnumNames ? '' : 'ATTRIBUTION_CONFIDENCE_LOW');

  static const $core.List<AttributionConfidence> values =
      <AttributionConfidence>[
    ATTRIBUTION_CONFIDENCE_UNSPECIFIED,
    ATTRIBUTION_CONFIDENCE_HIGH,
    ATTRIBUTION_CONFIDENCE_MEDIUM,
    ATTRIBUTION_CONFIDENCE_LOW,
  ];

  static final $core.List<AttributionConfidence?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 3);
  static AttributionConfidence? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const AttributionConfidence._(super.value, super.name);
}

/// Commission state machine per DB §10.4B.
class CommissionStatus extends $pb.ProtobufEnum {
  static const CommissionStatus COMMISSION_STATUS_UNSPECIFIED =
      CommissionStatus._(
          0, _omitEnumNames ? '' : 'COMMISSION_STATUS_UNSPECIFIED');
  static const CommissionStatus COMMISSION_STATUS_PENDING =
      CommissionStatus._(1, _omitEnumNames ? '' : 'COMMISSION_STATUS_PENDING');
  static const CommissionStatus COMMISSION_STATUS_CONFIRMED =
      CommissionStatus._(
          2, _omitEnumNames ? '' : 'COMMISSION_STATUS_CONFIRMED');
  static const CommissionStatus COMMISSION_STATUS_CLAWED_BACK =
      CommissionStatus._(
          3, _omitEnumNames ? '' : 'COMMISSION_STATUS_CLAWED_BACK');
  static const CommissionStatus COMMISSION_STATUS_PAID_OUT =
      CommissionStatus._(4, _omitEnumNames ? '' : 'COMMISSION_STATUS_PAID_OUT');

  static const $core.List<CommissionStatus> values = <CommissionStatus>[
    COMMISSION_STATUS_UNSPECIFIED,
    COMMISSION_STATUS_PENDING,
    COMMISSION_STATUS_CONFIRMED,
    COMMISSION_STATUS_CLAWED_BACK,
    COMMISSION_STATUS_PAID_OUT,
  ];

  static final $core.List<CommissionStatus?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 4);
  static CommissionStatus? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const CommissionStatus._(super.value, super.name);
}

/// Payout batch state.
class PayoutStatus extends $pb.ProtobufEnum {
  static const PayoutStatus PAYOUT_STATUS_UNSPECIFIED =
      PayoutStatus._(0, _omitEnumNames ? '' : 'PAYOUT_STATUS_UNSPECIFIED');
  static const PayoutStatus PAYOUT_STATUS_PENDING =
      PayoutStatus._(1, _omitEnumNames ? '' : 'PAYOUT_STATUS_PENDING');
  static const PayoutStatus PAYOUT_STATUS_PROCESSING =
      PayoutStatus._(2, _omitEnumNames ? '' : 'PAYOUT_STATUS_PROCESSING');
  static const PayoutStatus PAYOUT_STATUS_COMPLETED =
      PayoutStatus._(3, _omitEnumNames ? '' : 'PAYOUT_STATUS_COMPLETED');
  static const PayoutStatus PAYOUT_STATUS_FAILED =
      PayoutStatus._(4, _omitEnumNames ? '' : 'PAYOUT_STATUS_FAILED');

  static const $core.List<PayoutStatus> values = <PayoutStatus>[
    PAYOUT_STATUS_UNSPECIFIED,
    PAYOUT_STATUS_PENDING,
    PAYOUT_STATUS_PROCESSING,
    PAYOUT_STATUS_COMPLETED,
    PAYOUT_STATUS_FAILED,
  ];

  static final $core.List<PayoutStatus?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 4);
  static PayoutStatus? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const PayoutStatus._(super.value, super.name);
}

/// Creator assignment status.
class AssignmentStatus extends $pb.ProtobufEnum {
  static const AssignmentStatus ASSIGNMENT_STATUS_UNSPECIFIED =
      AssignmentStatus._(
          0, _omitEnumNames ? '' : 'ASSIGNMENT_STATUS_UNSPECIFIED');
  static const AssignmentStatus ASSIGNMENT_STATUS_ACTIVE =
      AssignmentStatus._(1, _omitEnumNames ? '' : 'ASSIGNMENT_STATUS_ACTIVE');
  static const AssignmentStatus ASSIGNMENT_STATUS_COMPLETED =
      AssignmentStatus._(
          2, _omitEnumNames ? '' : 'ASSIGNMENT_STATUS_COMPLETED');
  static const AssignmentStatus ASSIGNMENT_STATUS_CANCELLED =
      AssignmentStatus._(
          3, _omitEnumNames ? '' : 'ASSIGNMENT_STATUS_CANCELLED');

  static const $core.List<AssignmentStatus> values = <AssignmentStatus>[
    ASSIGNMENT_STATUS_UNSPECIFIED,
    ASSIGNMENT_STATUS_ACTIVE,
    ASSIGNMENT_STATUS_COMPLETED,
    ASSIGNMENT_STATUS_CANCELLED,
  ];

  static final $core.List<AssignmentStatus?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 3);
  static AssignmentStatus? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const AssignmentStatus._(super.value, super.name);
}

/// Workspace economic role distinguishing creator income vs seller expense.
class WorkspaceEconomicRole extends $pb.ProtobufEnum {
  static const WorkspaceEconomicRole WORKSPACE_ECONOMIC_ROLE_UNSPECIFIED =
      WorkspaceEconomicRole._(
          0, _omitEnumNames ? '' : 'WORKSPACE_ECONOMIC_ROLE_UNSPECIFIED');
  static const WorkspaceEconomicRole WORKSPACE_ECONOMIC_ROLE_CREATOR =
      WorkspaceEconomicRole._(
          1, _omitEnumNames ? '' : 'WORKSPACE_ECONOMIC_ROLE_CREATOR');
  static const WorkspaceEconomicRole WORKSPACE_ECONOMIC_ROLE_SELLER =
      WorkspaceEconomicRole._(
          2, _omitEnumNames ? '' : 'WORKSPACE_ECONOMIC_ROLE_SELLER');

  static const $core.List<WorkspaceEconomicRole> values =
      <WorkspaceEconomicRole>[
    WORKSPACE_ECONOMIC_ROLE_UNSPECIFIED,
    WORKSPACE_ECONOMIC_ROLE_CREATOR,
    WORKSPACE_ECONOMIC_ROLE_SELLER,
  ];

  static final $core.List<WorkspaceEconomicRole?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 2);
  static WorkspaceEconomicRole? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const WorkspaceEconomicRole._(super.value, super.name);
}

const $core.bool _omitEnumNames =
    $core.bool.fromEnvironment('protobuf.omit_enum_names');

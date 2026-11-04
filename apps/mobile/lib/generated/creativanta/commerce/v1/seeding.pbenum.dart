// This is a generated file - do not edit.
//
// Generated from creativanta/commerce/v1/seeding.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

/// Logistics/request lifecycle per RULE-M18-001 & §19.10
class SampleRequestStatus extends $pb.ProtobufEnum {
  static const SampleRequestStatus SAMPLE_REQUEST_STATUS_UNSPECIFIED =
      SampleRequestStatus._(
          0, _omitEnumNames ? '' : 'SAMPLE_REQUEST_STATUS_UNSPECIFIED');
  static const SampleRequestStatus SAMPLE_REQUEST_STATUS_REQUESTED =
      SampleRequestStatus._(
          1, _omitEnumNames ? '' : 'SAMPLE_REQUEST_STATUS_REQUESTED');
  static const SampleRequestStatus SAMPLE_REQUEST_STATUS_APPROVED =
      SampleRequestStatus._(
          2, _omitEnumNames ? '' : 'SAMPLE_REQUEST_STATUS_APPROVED');
  static const SampleRequestStatus SAMPLE_REQUEST_STATUS_DECLINED =
      SampleRequestStatus._(
          3, _omitEnumNames ? '' : 'SAMPLE_REQUEST_STATUS_DECLINED');
  static const SampleRequestStatus SAMPLE_REQUEST_STATUS_FULFILLED =
      SampleRequestStatus._(
          4, _omitEnumNames ? '' : 'SAMPLE_REQUEST_STATUS_FULFILLED');
  static const SampleRequestStatus SAMPLE_REQUEST_STATUS_CANCELLED =
      SampleRequestStatus._(
          5, _omitEnumNames ? '' : 'SAMPLE_REQUEST_STATUS_CANCELLED');

  static const $core.List<SampleRequestStatus> values = <SampleRequestStatus>[
    SAMPLE_REQUEST_STATUS_UNSPECIFIED,
    SAMPLE_REQUEST_STATUS_REQUESTED,
    SAMPLE_REQUEST_STATUS_APPROVED,
    SAMPLE_REQUEST_STATUS_DECLINED,
    SAMPLE_REQUEST_STATUS_FULFILLED,
    SAMPLE_REQUEST_STATUS_CANCELLED,
  ];

  static final $core.List<SampleRequestStatus?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 5);
  static SampleRequestStatus? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const SampleRequestStatus._(super.value, super.name);
}

/// Physical shipment lifecycle per §19.10
class SampleShipmentStatus extends $pb.ProtobufEnum {
  static const SampleShipmentStatus SAMPLE_SHIPMENT_STATUS_UNSPECIFIED =
      SampleShipmentStatus._(
          0, _omitEnumNames ? '' : 'SAMPLE_SHIPMENT_STATUS_UNSPECIFIED');
  static const SampleShipmentStatus SAMPLE_SHIPMENT_STATUS_PREPARING =
      SampleShipmentStatus._(
          1, _omitEnumNames ? '' : 'SAMPLE_SHIPMENT_STATUS_PREPARING');
  static const SampleShipmentStatus SAMPLE_SHIPMENT_STATUS_SHIPPED =
      SampleShipmentStatus._(
          2, _omitEnumNames ? '' : 'SAMPLE_SHIPMENT_STATUS_SHIPPED');
  static const SampleShipmentStatus SAMPLE_SHIPMENT_STATUS_DELIVERED =
      SampleShipmentStatus._(
          3, _omitEnumNames ? '' : 'SAMPLE_SHIPMENT_STATUS_DELIVERED');
  static const SampleShipmentStatus SAMPLE_SHIPMENT_STATUS_LOST =
      SampleShipmentStatus._(
          4, _omitEnumNames ? '' : 'SAMPLE_SHIPMENT_STATUS_LOST');
  static const SampleShipmentStatus SAMPLE_SHIPMENT_STATUS_RETURNED =
      SampleShipmentStatus._(
          5, _omitEnumNames ? '' : 'SAMPLE_SHIPMENT_STATUS_RETURNED');
  static const SampleShipmentStatus SAMPLE_SHIPMENT_STATUS_CLOSED =
      SampleShipmentStatus._(
          6, _omitEnumNames ? '' : 'SAMPLE_SHIPMENT_STATUS_CLOSED');

  static const $core.List<SampleShipmentStatus> values = <SampleShipmentStatus>[
    SAMPLE_SHIPMENT_STATUS_UNSPECIFIED,
    SAMPLE_SHIPMENT_STATUS_PREPARING,
    SAMPLE_SHIPMENT_STATUS_SHIPPED,
    SAMPLE_SHIPMENT_STATUS_DELIVERED,
    SAMPLE_SHIPMENT_STATUS_LOST,
    SAMPLE_SHIPMENT_STATUS_RETURNED,
    SAMPLE_SHIPMENT_STATUS_CLOSED,
  ];

  static final $core.List<SampleShipmentStatus?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 6);
  static SampleShipmentStatus? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const SampleShipmentStatus._(super.value, super.name);
}

/// Business outcome state (orthogonal to logistics status per RULE-M18-003)
class SampleOutcomeStatus extends $pb.ProtobufEnum {
  static const SampleOutcomeStatus SAMPLE_OUTCOME_STATUS_UNSPECIFIED =
      SampleOutcomeStatus._(
          0, _omitEnumNames ? '' : 'SAMPLE_OUTCOME_STATUS_UNSPECIFIED');
  static const SampleOutcomeStatus SAMPLE_OUTCOME_STATUS_PENDING =
      SampleOutcomeStatus._(
          1, _omitEnumNames ? '' : 'SAMPLE_OUTCOME_STATUS_PENDING');
  static const SampleOutcomeStatus SAMPLE_OUTCOME_STATUS_LOGGED =
      SampleOutcomeStatus._(
          2, _omitEnumNames ? '' : 'SAMPLE_OUTCOME_STATUS_LOGGED');

  static const $core.List<SampleOutcomeStatus> values = <SampleOutcomeStatus>[
    SAMPLE_OUTCOME_STATUS_UNSPECIFIED,
    SAMPLE_OUTCOME_STATUS_PENDING,
    SAMPLE_OUTCOME_STATUS_LOGGED,
  ];

  static final $core.List<SampleOutcomeStatus?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 2);
  static SampleOutcomeStatus? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const SampleOutcomeStatus._(super.value, super.name);
}

/// Post-delivery communication state per RULE-M18-006
class FollowUpStatus extends $pb.ProtobufEnum {
  static const FollowUpStatus FOLLOW_UP_STATUS_UNSPECIFIED =
      FollowUpStatus._(0, _omitEnumNames ? '' : 'FOLLOW_UP_STATUS_UNSPECIFIED');
  static const FollowUpStatus FOLLOW_UP_STATUS_PENDING_FOLLOWUP =
      FollowUpStatus._(
          1, _omitEnumNames ? '' : 'FOLLOW_UP_STATUS_PENDING_FOLLOWUP');
  static const FollowUpStatus FOLLOW_UP_STATUS_CONTACTED =
      FollowUpStatus._(2, _omitEnumNames ? '' : 'FOLLOW_UP_STATUS_CONTACTED');
  static const FollowUpStatus FOLLOW_UP_STATUS_RESPONDED =
      FollowUpStatus._(3, _omitEnumNames ? '' : 'FOLLOW_UP_STATUS_RESPONDED');
  static const FollowUpStatus FOLLOW_UP_STATUS_NO_RESPONSE =
      FollowUpStatus._(4, _omitEnumNames ? '' : 'FOLLOW_UP_STATUS_NO_RESPONSE');

  static const $core.List<FollowUpStatus> values = <FollowUpStatus>[
    FOLLOW_UP_STATUS_UNSPECIFIED,
    FOLLOW_UP_STATUS_PENDING_FOLLOWUP,
    FOLLOW_UP_STATUS_CONTACTED,
    FOLLOW_UP_STATUS_RESPONDED,
    FOLLOW_UP_STATUS_NO_RESPONSE,
  ];

  static final $core.List<FollowUpStatus?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 4);
  static FollowUpStatus? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const FollowUpStatus._(super.value, super.name);
}

/// Data provenance class per PRD §15.1 and RULE-M18-002
class SeedingSourceClass extends $pb.ProtobufEnum {
  static const SeedingSourceClass SEEDING_SOURCE_CLASS_UNSPECIFIED =
      SeedingSourceClass._(
          0, _omitEnumNames ? '' : 'SEEDING_SOURCE_CLASS_UNSPECIFIED');
  static const SeedingSourceClass SEEDING_SOURCE_CLASS_OFFICIAL =
      SeedingSourceClass._(
          1, _omitEnumNames ? '' : 'SEEDING_SOURCE_CLASS_OFFICIAL');
  static const SeedingSourceClass SEEDING_SOURCE_CLASS_IMPORTED =
      SeedingSourceClass._(
          2, _omitEnumNames ? '' : 'SEEDING_SOURCE_CLASS_IMPORTED');
  static const SeedingSourceClass SEEDING_SOURCE_CLASS_INFERRED =
      SeedingSourceClass._(
          3, _omitEnumNames ? '' : 'SEEDING_SOURCE_CLASS_INFERRED');
  static const SeedingSourceClass SEEDING_SOURCE_CLASS_ESTIMATED =
      SeedingSourceClass._(
          4, _omitEnumNames ? '' : 'SEEDING_SOURCE_CLASS_ESTIMATED');
  static const SeedingSourceClass SEEDING_SOURCE_CLASS_UNRECONCILED =
      SeedingSourceClass._(
          5, _omitEnumNames ? '' : 'SEEDING_SOURCE_CLASS_UNRECONCILED');

  static const $core.List<SeedingSourceClass> values = <SeedingSourceClass>[
    SEEDING_SOURCE_CLASS_UNSPECIFIED,
    SEEDING_SOURCE_CLASS_OFFICIAL,
    SEEDING_SOURCE_CLASS_IMPORTED,
    SEEDING_SOURCE_CLASS_INFERRED,
    SEEDING_SOURCE_CLASS_ESTIMATED,
    SEEDING_SOURCE_CLASS_UNRECONCILED,
  ];

  static final $core.List<SeedingSourceClass?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 5);
  static SeedingSourceClass? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const SeedingSourceClass._(super.value, super.name);
}

/// Confidence band per financial computation contract §3
class SeedingConfidenceLevel extends $pb.ProtobufEnum {
  static const SeedingConfidenceLevel SEEDING_CONFIDENCE_LEVEL_UNSPECIFIED =
      SeedingConfidenceLevel._(
          0, _omitEnumNames ? '' : 'SEEDING_CONFIDENCE_LEVEL_UNSPECIFIED');
  static const SeedingConfidenceLevel SEEDING_CONFIDENCE_LEVEL_HIGH =
      SeedingConfidenceLevel._(
          1, _omitEnumNames ? '' : 'SEEDING_CONFIDENCE_LEVEL_HIGH');
  static const SeedingConfidenceLevel SEEDING_CONFIDENCE_LEVEL_MEDIUM =
      SeedingConfidenceLevel._(
          2, _omitEnumNames ? '' : 'SEEDING_CONFIDENCE_LEVEL_MEDIUM');
  static const SeedingConfidenceLevel SEEDING_CONFIDENCE_LEVEL_LOW =
      SeedingConfidenceLevel._(
          3, _omitEnumNames ? '' : 'SEEDING_CONFIDENCE_LEVEL_LOW');

  static const $core.List<SeedingConfidenceLevel> values =
      <SeedingConfidenceLevel>[
    SEEDING_CONFIDENCE_LEVEL_UNSPECIFIED,
    SEEDING_CONFIDENCE_LEVEL_HIGH,
    SEEDING_CONFIDENCE_LEVEL_MEDIUM,
    SEEDING_CONFIDENCE_LEVEL_LOW,
  ];

  static final $core.List<SeedingConfidenceLevel?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 3);
  static SeedingConfidenceLevel? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const SeedingConfidenceLevel._(super.value, super.name);
}

const $core.bool _omitEnumNames =
    $core.bool.fromEnvironment('protobuf.omit_enum_names');

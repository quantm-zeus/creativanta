// This is a generated file - do not edit.
//
// Generated from creativanta/platform/v1/gamification.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class ChallengeStatus extends $pb.ProtobufEnum {
  static const ChallengeStatus CHALLENGE_STATUS_UNSPECIFIED = ChallengeStatus._(
      0, _omitEnumNames ? '' : 'CHALLENGE_STATUS_UNSPECIFIED');
  static const ChallengeStatus CHALLENGE_STATUS_DRAFT =
      ChallengeStatus._(1, _omitEnumNames ? '' : 'CHALLENGE_STATUS_DRAFT');
  static const ChallengeStatus CHALLENGE_STATUS_ENROLLING =
      ChallengeStatus._(2, _omitEnumNames ? '' : 'CHALLENGE_STATUS_ENROLLING');
  static const ChallengeStatus CHALLENGE_STATUS_ACTIVE =
      ChallengeStatus._(3, _omitEnumNames ? '' : 'CHALLENGE_STATUS_ACTIVE');
  static const ChallengeStatus CHALLENGE_STATUS_COMPLETED =
      ChallengeStatus._(4, _omitEnumNames ? '' : 'CHALLENGE_STATUS_COMPLETED');
  static const ChallengeStatus CHALLENGE_STATUS_REWARDED =
      ChallengeStatus._(5, _omitEnumNames ? '' : 'CHALLENGE_STATUS_REWARDED');
  static const ChallengeStatus CHALLENGE_STATUS_CANCELLED =
      ChallengeStatus._(6, _omitEnumNames ? '' : 'CHALLENGE_STATUS_CANCELLED');

  static const $core.List<ChallengeStatus> values = <ChallengeStatus>[
    CHALLENGE_STATUS_UNSPECIFIED,
    CHALLENGE_STATUS_DRAFT,
    CHALLENGE_STATUS_ENROLLING,
    CHALLENGE_STATUS_ACTIVE,
    CHALLENGE_STATUS_COMPLETED,
    CHALLENGE_STATUS_REWARDED,
    CHALLENGE_STATUS_CANCELLED,
  ];

  static final $core.List<ChallengeStatus?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 6);
  static ChallengeStatus? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const ChallengeStatus._(super.value, super.name);
}

class ChallengeType extends $pb.ProtobufEnum {
  static const ChallengeType CHALLENGE_TYPE_UNSPECIFIED =
      ChallengeType._(0, _omitEnumNames ? '' : 'CHALLENGE_TYPE_UNSPECIFIED');
  static const ChallengeType CHALLENGE_TYPE_PUBLISH_COUNT =
      ChallengeType._(1, _omitEnumNames ? '' : 'CHALLENGE_TYPE_PUBLISH_COUNT');
  static const ChallengeType CHALLENGE_TYPE_REVENUE_TARGET =
      ChallengeType._(2, _omitEnumNames ? '' : 'CHALLENGE_TYPE_REVENUE_TARGET');
  static const ChallengeType CHALLENGE_TYPE_ENGAGEMENT_TARGET = ChallengeType._(
      3, _omitEnumNames ? '' : 'CHALLENGE_TYPE_ENGAGEMENT_TARGET');
  static const ChallengeType CHALLENGE_TYPE_STREAK =
      ChallengeType._(4, _omitEnumNames ? '' : 'CHALLENGE_TYPE_STREAK');
  static const ChallengeType CHALLENGE_TYPE_CUSTOM =
      ChallengeType._(5, _omitEnumNames ? '' : 'CHALLENGE_TYPE_CUSTOM');

  static const $core.List<ChallengeType> values = <ChallengeType>[
    CHALLENGE_TYPE_UNSPECIFIED,
    CHALLENGE_TYPE_PUBLISH_COUNT,
    CHALLENGE_TYPE_REVENUE_TARGET,
    CHALLENGE_TYPE_ENGAGEMENT_TARGET,
    CHALLENGE_TYPE_STREAK,
    CHALLENGE_TYPE_CUSTOM,
  ];

  static final $core.List<ChallengeType?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 5);
  static ChallengeType? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const ChallengeType._(super.value, super.name);
}

const $core.bool _omitEnumNames =
    $core.bool.fromEnvironment('protobuf.omit_enum_names');

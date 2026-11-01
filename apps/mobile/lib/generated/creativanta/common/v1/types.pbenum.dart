// This is a generated file - do not edit.
//
// Generated from creativanta/common/v1/types.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

/// Provenance classification for metrics, records, and external data.
/// Validation belongs to application code: must be a defined enum value != SOURCE_CLASS_UNSPECIFIED (1..5).
class SourceClass extends $pb.ProtobufEnum {
  static const SourceClass SOURCE_CLASS_UNSPECIFIED =
      SourceClass._(0, _omitEnumNames ? '' : 'SOURCE_CLASS_UNSPECIFIED');
  static const SourceClass SOURCE_CLASS_OFFICIAL =
      SourceClass._(1, _omitEnumNames ? '' : 'SOURCE_CLASS_OFFICIAL');
  static const SourceClass SOURCE_CLASS_IMPORTED =
      SourceClass._(2, _omitEnumNames ? '' : 'SOURCE_CLASS_IMPORTED');
  static const SourceClass SOURCE_CLASS_INFERRED =
      SourceClass._(3, _omitEnumNames ? '' : 'SOURCE_CLASS_INFERRED');
  static const SourceClass SOURCE_CLASS_ESTIMATED =
      SourceClass._(4, _omitEnumNames ? '' : 'SOURCE_CLASS_ESTIMATED');
  static const SourceClass SOURCE_CLASS_UNRECONCILED =
      SourceClass._(5, _omitEnumNames ? '' : 'SOURCE_CLASS_UNRECONCILED');

  static const $core.List<SourceClass> values = <SourceClass>[
    SOURCE_CLASS_UNSPECIFIED,
    SOURCE_CLASS_OFFICIAL,
    SOURCE_CLASS_IMPORTED,
    SOURCE_CLASS_INFERRED,
    SOURCE_CLASS_ESTIMATED,
    SOURCE_CLASS_UNRECONCILED,
  ];

  static final $core.List<SourceClass?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 5);
  static SourceClass? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const SourceClass._(super.value, super.name);
}

/// Confidence band for AI-generated, inferred, or estimated values.
/// Validation belongs to application code: must be a defined enum value != CONFIDENCE_BAND_UNSPECIFIED (1..5).
class ConfidenceBand extends $pb.ProtobufEnum {
  static const ConfidenceBand CONFIDENCE_BAND_UNSPECIFIED =
      ConfidenceBand._(0, _omitEnumNames ? '' : 'CONFIDENCE_BAND_UNSPECIFIED');
  static const ConfidenceBand CONFIDENCE_BAND_HIGH =
      ConfidenceBand._(1, _omitEnumNames ? '' : 'CONFIDENCE_BAND_HIGH');
  static const ConfidenceBand CONFIDENCE_BAND_MEDIUM_HIGH =
      ConfidenceBand._(2, _omitEnumNames ? '' : 'CONFIDENCE_BAND_MEDIUM_HIGH');
  static const ConfidenceBand CONFIDENCE_BAND_MEDIUM =
      ConfidenceBand._(3, _omitEnumNames ? '' : 'CONFIDENCE_BAND_MEDIUM');
  static const ConfidenceBand CONFIDENCE_BAND_LOW_MEDIUM =
      ConfidenceBand._(4, _omitEnumNames ? '' : 'CONFIDENCE_BAND_LOW_MEDIUM');
  static const ConfidenceBand CONFIDENCE_BAND_LOW =
      ConfidenceBand._(5, _omitEnumNames ? '' : 'CONFIDENCE_BAND_LOW');

  static const $core.List<ConfidenceBand> values = <ConfidenceBand>[
    CONFIDENCE_BAND_UNSPECIFIED,
    CONFIDENCE_BAND_HIGH,
    CONFIDENCE_BAND_MEDIUM_HIGH,
    CONFIDENCE_BAND_MEDIUM,
    CONFIDENCE_BAND_LOW_MEDIUM,
    CONFIDENCE_BAND_LOW,
  ];

  static final $core.List<ConfidenceBand?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 5);
  static ConfidenceBand? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const ConfidenceBand._(super.value, super.name);
}

/// Six canonical operator modes supported by Creativanta.
/// Validation belongs to application code: must be a defined enum value != OPERATOR_MODE_UNSPECIFIED (1..6).
class OperatorMode extends $pb.ProtobufEnum {
  static const OperatorMode OPERATOR_MODE_UNSPECIFIED =
      OperatorMode._(0, _omitEnumNames ? '' : 'OPERATOR_MODE_UNSPECIFIED');
  static const OperatorMode OPERATOR_MODE_CREATOR =
      OperatorMode._(1, _omitEnumNames ? '' : 'OPERATOR_MODE_CREATOR');
  static const OperatorMode OPERATOR_MODE_SELLER =
      OperatorMode._(2, _omitEnumNames ? '' : 'OPERATOR_MODE_SELLER');
  static const OperatorMode OPERATOR_MODE_AFFILIATE_OPERATOR = OperatorMode._(
      3, _omitEnumNames ? '' : 'OPERATOR_MODE_AFFILIATE_OPERATOR');
  static const OperatorMode OPERATOR_MODE_LIVE_OPERATOR =
      OperatorMode._(4, _omitEnumNames ? '' : 'OPERATOR_MODE_LIVE_OPERATOR');
  static const OperatorMode OPERATOR_MODE_AGENCY_MCN =
      OperatorMode._(5, _omitEnumNames ? '' : 'OPERATOR_MODE_AGENCY_MCN');
  static const OperatorMode OPERATOR_MODE_BRAND_COLLABORATION = OperatorMode._(
      6, _omitEnumNames ? '' : 'OPERATOR_MODE_BRAND_COLLABORATION');

  static const $core.List<OperatorMode> values = <OperatorMode>[
    OPERATOR_MODE_UNSPECIFIED,
    OPERATOR_MODE_CREATOR,
    OPERATOR_MODE_SELLER,
    OPERATOR_MODE_AFFILIATE_OPERATOR,
    OPERATOR_MODE_LIVE_OPERATOR,
    OPERATOR_MODE_AGENCY_MCN,
    OPERATOR_MODE_BRAND_COLLABORATION,
  ];

  static final $core.List<OperatorMode?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 6);
  static OperatorMode? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const OperatorMode._(super.value, super.name);
}

const $core.bool _omitEnumNames =
    $core.bool.fromEnvironment('protobuf.omit_enum_names');

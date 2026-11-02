// This is a generated file - do not edit.
//
// Generated from creativanta/intelligence/v1/trend.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

/// ConfidenceBand represents confidence classification per database_schema.md §3.2.
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

/// SourceClass represents data lineage classification per database_schema.md §3.1.
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

/// LifecycleState represents the trend lifecycle stage per database_schema.md §5.2.
class LifecycleState extends $pb.ProtobufEnum {
  static const LifecycleState LIFECYCLE_STATE_UNSPECIFIED =
      LifecycleState._(0, _omitEnumNames ? '' : 'LIFECYCLE_STATE_UNSPECIFIED');
  static const LifecycleState LIFECYCLE_STATE_EMERGING =
      LifecycleState._(1, _omitEnumNames ? '' : 'LIFECYCLE_STATE_EMERGING');
  static const LifecycleState LIFECYCLE_STATE_RISING =
      LifecycleState._(2, _omitEnumNames ? '' : 'LIFECYCLE_STATE_RISING');
  static const LifecycleState LIFECYCLE_STATE_PEAKING =
      LifecycleState._(3, _omitEnumNames ? '' : 'LIFECYCLE_STATE_PEAKING');
  static const LifecycleState LIFECYCLE_STATE_DECLINING =
      LifecycleState._(4, _omitEnumNames ? '' : 'LIFECYCLE_STATE_DECLINING');
  static const LifecycleState LIFECYCLE_STATE_EXPIRED =
      LifecycleState._(5, _omitEnumNames ? '' : 'LIFECYCLE_STATE_EXPIRED');
  static const LifecycleState LIFECYCLE_STATE_ARCHIVED =
      LifecycleState._(6, _omitEnumNames ? '' : 'LIFECYCLE_STATE_ARCHIVED');

  static const $core.List<LifecycleState> values = <LifecycleState>[
    LIFECYCLE_STATE_UNSPECIFIED,
    LIFECYCLE_STATE_EMERGING,
    LIFECYCLE_STATE_RISING,
    LIFECYCLE_STATE_PEAKING,
    LIFECYCLE_STATE_DECLINING,
    LIFECYCLE_STATE_EXPIRED,
    LIFECYCLE_STATE_ARCHIVED,
  ];

  static final $core.List<LifecycleState?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 6);
  static LifecycleState? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const LifecycleState._(super.value, super.name);
}

const $core.bool _omitEnumNames =
    $core.bool.fromEnvironment('protobuf.omit_enum_names');

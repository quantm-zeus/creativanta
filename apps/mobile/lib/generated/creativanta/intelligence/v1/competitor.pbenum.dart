// This is a generated file - do not edit.
//
// Generated from creativanta/intelligence/v1/competitor.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

/// AlertDirection defines whether an alert triggers above or below a threshold.
class AlertDirection extends $pb.ProtobufEnum {
  static const AlertDirection ALERT_DIRECTION_UNSPECIFIED =
      AlertDirection._(0, _omitEnumNames ? '' : 'ALERT_DIRECTION_UNSPECIFIED');
  static const AlertDirection ALERT_DIRECTION_ABOVE =
      AlertDirection._(1, _omitEnumNames ? '' : 'ALERT_DIRECTION_ABOVE');
  static const AlertDirection ALERT_DIRECTION_BELOW =
      AlertDirection._(2, _omitEnumNames ? '' : 'ALERT_DIRECTION_BELOW');

  static const $core.List<AlertDirection> values = <AlertDirection>[
    ALERT_DIRECTION_UNSPECIFIED,
    ALERT_DIRECTION_ABOVE,
    ALERT_DIRECTION_BELOW,
  ];

  static final $core.List<AlertDirection?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 2);
  static AlertDirection? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const AlertDirection._(super.value, super.name);
}

/// AlertMetric defines the metric to monitor for a competitor.
class AlertMetric extends $pb.ProtobufEnum {
  static const AlertMetric ALERT_METRIC_UNSPECIFIED =
      AlertMetric._(0, _omitEnumNames ? '' : 'ALERT_METRIC_UNSPECIFIED');
  static const AlertMetric ALERT_METRIC_ENGAGEMENT_RATE =
      AlertMetric._(1, _omitEnumNames ? '' : 'ALERT_METRIC_ENGAGEMENT_RATE');
  static const AlertMetric ALERT_METRIC_POST_FREQUENCY =
      AlertMetric._(2, _omitEnumNames ? '' : 'ALERT_METRIC_POST_FREQUENCY');
  static const AlertMetric ALERT_METRIC_OBSERVED_PRICE =
      AlertMetric._(3, _omitEnumNames ? '' : 'ALERT_METRIC_OBSERVED_PRICE');

  static const $core.List<AlertMetric> values = <AlertMetric>[
    ALERT_METRIC_UNSPECIFIED,
    ALERT_METRIC_ENGAGEMENT_RATE,
    ALERT_METRIC_POST_FREQUENCY,
    ALERT_METRIC_OBSERVED_PRICE,
  ];

  static final $core.List<AlertMetric?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 3);
  static AlertMetric? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const AlertMetric._(super.value, super.name);
}

const $core.bool _omitEnumNames =
    $core.bool.fromEnvironment('protobuf.omit_enum_names');

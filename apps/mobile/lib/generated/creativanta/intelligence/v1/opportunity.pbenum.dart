// This is a generated file - do not edit.
//
// Generated from creativanta/intelligence/v1/opportunity.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

/// PriorityState defines canonical opportunity progression stages per database_schema.md §5.4.
class PriorityState extends $pb.ProtobufEnum {
  static const PriorityState PRIORITY_STATE_UNSPECIFIED =
      PriorityState._(0, _omitEnumNames ? '' : 'PRIORITY_STATE_UNSPECIFIED');
  static const PriorityState PRIORITY_STATE_DRAFT =
      PriorityState._(1, _omitEnumNames ? '' : 'PRIORITY_STATE_DRAFT');
  static const PriorityState PRIORITY_STATE_OPEN =
      PriorityState._(2, _omitEnumNames ? '' : 'PRIORITY_STATE_OPEN');
  static const PriorityState PRIORITY_STATE_PRIORITIZED =
      PriorityState._(3, _omitEnumNames ? '' : 'PRIORITY_STATE_PRIORITIZED');
  static const PriorityState PRIORITY_STATE_ASSIGNED =
      PriorityState._(4, _omitEnumNames ? '' : 'PRIORITY_STATE_ASSIGNED');
  static const PriorityState PRIORITY_STATE_IN_PROGRESS =
      PriorityState._(5, _omitEnumNames ? '' : 'PRIORITY_STATE_IN_PROGRESS');
  static const PriorityState PRIORITY_STATE_CONVERTED =
      PriorityState._(6, _omitEnumNames ? '' : 'PRIORITY_STATE_CONVERTED');
  static const PriorityState PRIORITY_STATE_PARKED =
      PriorityState._(7, _omitEnumNames ? '' : 'PRIORITY_STATE_PARKED');
  static const PriorityState PRIORITY_STATE_CLOSED_WON =
      PriorityState._(8, _omitEnumNames ? '' : 'PRIORITY_STATE_CLOSED_WON');
  static const PriorityState PRIORITY_STATE_CLOSED_LOST =
      PriorityState._(9, _omitEnumNames ? '' : 'PRIORITY_STATE_CLOSED_LOST');

  static const $core.List<PriorityState> values = <PriorityState>[
    PRIORITY_STATE_UNSPECIFIED,
    PRIORITY_STATE_DRAFT,
    PRIORITY_STATE_OPEN,
    PRIORITY_STATE_PRIORITIZED,
    PRIORITY_STATE_ASSIGNED,
    PRIORITY_STATE_IN_PROGRESS,
    PRIORITY_STATE_CONVERTED,
    PRIORITY_STATE_PARKED,
    PRIORITY_STATE_CLOSED_WON,
    PRIORITY_STATE_CLOSED_LOST,
  ];

  static final $core.List<PriorityState?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 9);
  static PriorityState? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const PriorityState._(super.value, super.name);
}

const $core.bool _omitEnumNames =
    $core.bool.fromEnvironment('protobuf.omit_enum_names');

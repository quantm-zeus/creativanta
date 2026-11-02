// This is a generated file - do not edit.
//
// Generated from creativanta/admin/v1/dashboard.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class OperatorModeId extends $pb.ProtobufEnum {
  static const OperatorModeId OPERATOR_MODE_ID_UNSPECIFIED =
      OperatorModeId._(0, _omitEnumNames ? '' : 'OPERATOR_MODE_ID_UNSPECIFIED');
  static const OperatorModeId OPERATOR_MODE_ID_CREATOR =
      OperatorModeId._(1, _omitEnumNames ? '' : 'OPERATOR_MODE_ID_CREATOR');
  static const OperatorModeId OPERATOR_MODE_ID_SELLER =
      OperatorModeId._(2, _omitEnumNames ? '' : 'OPERATOR_MODE_ID_SELLER');
  static const OperatorModeId OPERATOR_MODE_ID_AFFILIATE_OPERATOR =
      OperatorModeId._(
          3, _omitEnumNames ? '' : 'OPERATOR_MODE_ID_AFFILIATE_OPERATOR');
  static const OperatorModeId OPERATOR_MODE_ID_LIVE_OPERATOR = OperatorModeId._(
      4, _omitEnumNames ? '' : 'OPERATOR_MODE_ID_LIVE_OPERATOR');
  static const OperatorModeId OPERATOR_MODE_ID_AGENCY_MCN =
      OperatorModeId._(5, _omitEnumNames ? '' : 'OPERATOR_MODE_ID_AGENCY_MCN');
  static const OperatorModeId OPERATOR_MODE_ID_BRAND_COLLABORATION =
      OperatorModeId._(
          6, _omitEnumNames ? '' : 'OPERATOR_MODE_ID_BRAND_COLLABORATION');

  static const $core.List<OperatorModeId> values = <OperatorModeId>[
    OPERATOR_MODE_ID_UNSPECIFIED,
    OPERATOR_MODE_ID_CREATOR,
    OPERATOR_MODE_ID_SELLER,
    OPERATOR_MODE_ID_AFFILIATE_OPERATOR,
    OPERATOR_MODE_ID_LIVE_OPERATOR,
    OPERATOR_MODE_ID_AGENCY_MCN,
    OPERATOR_MODE_ID_BRAND_COLLABORATION,
  ];

  static final $core.List<OperatorModeId?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 6);
  static OperatorModeId? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const OperatorModeId._(super.value, super.name);
}

class DataSourceBadge extends $pb.ProtobufEnum {
  static const DataSourceBadge DATA_SOURCE_BADGE_UNSPECIFIED =
      DataSourceBadge._(
          0, _omitEnumNames ? '' : 'DATA_SOURCE_BADGE_UNSPECIFIED');
  static const DataSourceBadge DATA_SOURCE_BADGE_OFFICIAL =
      DataSourceBadge._(1, _omitEnumNames ? '' : 'DATA_SOURCE_BADGE_OFFICIAL');
  static const DataSourceBadge DATA_SOURCE_BADGE_IMPORTED =
      DataSourceBadge._(2, _omitEnumNames ? '' : 'DATA_SOURCE_BADGE_IMPORTED');
  static const DataSourceBadge DATA_SOURCE_BADGE_INFERRED =
      DataSourceBadge._(3, _omitEnumNames ? '' : 'DATA_SOURCE_BADGE_INFERRED');
  static const DataSourceBadge DATA_SOURCE_BADGE_DEMO =
      DataSourceBadge._(4, _omitEnumNames ? '' : 'DATA_SOURCE_BADGE_DEMO');

  static const $core.List<DataSourceBadge> values = <DataSourceBadge>[
    DATA_SOURCE_BADGE_UNSPECIFIED,
    DATA_SOURCE_BADGE_OFFICIAL,
    DATA_SOURCE_BADGE_IMPORTED,
    DATA_SOURCE_BADGE_INFERRED,
    DATA_SOURCE_BADGE_DEMO,
  ];

  static final $core.List<DataSourceBadge?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 4);
  static DataSourceBadge? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const DataSourceBadge._(super.value, super.name);
}

class ConfidenceLevel extends $pb.ProtobufEnum {
  static const ConfidenceLevel CONFIDENCE_LEVEL_UNSPECIFIED = ConfidenceLevel._(
      0, _omitEnumNames ? '' : 'CONFIDENCE_LEVEL_UNSPECIFIED');
  static const ConfidenceLevel CONFIDENCE_LEVEL_HIGH =
      ConfidenceLevel._(1, _omitEnumNames ? '' : 'CONFIDENCE_LEVEL_HIGH');
  static const ConfidenceLevel CONFIDENCE_LEVEL_MEDIUM =
      ConfidenceLevel._(2, _omitEnumNames ? '' : 'CONFIDENCE_LEVEL_MEDIUM');
  static const ConfidenceLevel CONFIDENCE_LEVEL_LOW =
      ConfidenceLevel._(3, _omitEnumNames ? '' : 'CONFIDENCE_LEVEL_LOW');

  static const $core.List<ConfidenceLevel> values = <ConfidenceLevel>[
    CONFIDENCE_LEVEL_UNSPECIFIED,
    CONFIDENCE_LEVEL_HIGH,
    CONFIDENCE_LEVEL_MEDIUM,
    CONFIDENCE_LEVEL_LOW,
  ];

  static final $core.List<ConfidenceLevel?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 3);
  static ConfidenceLevel? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const ConfidenceLevel._(super.value, super.name);
}

class UIStateType extends $pb.ProtobufEnum {
  static const UIStateType UI_STATE_TYPE_UNSPECIFIED =
      UIStateType._(0, _omitEnumNames ? '' : 'UI_STATE_TYPE_UNSPECIFIED');
  static const UIStateType UI_STATE_TYPE_NORMAL =
      UIStateType._(1, _omitEnumNames ? '' : 'UI_STATE_TYPE_NORMAL');
  static const UIStateType UI_STATE_TYPE_LOADING =
      UIStateType._(2, _omitEnumNames ? '' : 'UI_STATE_TYPE_LOADING');
  static const UIStateType UI_STATE_TYPE_EMPTY =
      UIStateType._(3, _omitEnumNames ? '' : 'UI_STATE_TYPE_EMPTY');
  static const UIStateType UI_STATE_TYPE_ERROR =
      UIStateType._(4, _omitEnumNames ? '' : 'UI_STATE_TYPE_ERROR');
  static const UIStateType UI_STATE_TYPE_REPAIR =
      UIStateType._(5, _omitEnumNames ? '' : 'UI_STATE_TYPE_REPAIR');

  static const $core.List<UIStateType> values = <UIStateType>[
    UI_STATE_TYPE_UNSPECIFIED,
    UI_STATE_TYPE_NORMAL,
    UI_STATE_TYPE_LOADING,
    UI_STATE_TYPE_EMPTY,
    UI_STATE_TYPE_ERROR,
    UI_STATE_TYPE_REPAIR,
  ];

  static final $core.List<UIStateType?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 5);
  static UIStateType? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const UIStateType._(super.value, super.name);
}

const $core.bool _omitEnumNames =
    $core.bool.fromEnvironment('protobuf.omit_enum_names');

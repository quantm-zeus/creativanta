// This is a generated file - do not edit.
//
// Generated from creativanta/copilot/v1/copilot.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

/// CopilotMode tracks the operational mode of the Copilot session per database_schema.md §19.12.
class CopilotMode extends $pb.ProtobufEnum {
  static const CopilotMode COPILOT_MODE_UNSPECIFIED =
      CopilotMode._(0, _omitEnumNames ? '' : 'COPILOT_MODE_UNSPECIFIED');
  static const CopilotMode COPILOT_MODE_CREATIVE =
      CopilotMode._(1, _omitEnumNames ? '' : 'COPILOT_MODE_CREATIVE');
  static const CopilotMode COPILOT_MODE_ANALYTICS =
      CopilotMode._(2, _omitEnumNames ? '' : 'COPILOT_MODE_ANALYTICS');
  static const CopilotMode COPILOT_MODE_ACTION =
      CopilotMode._(3, _omitEnumNames ? '' : 'COPILOT_MODE_ACTION');
  static const CopilotMode COPILOT_MODE_VIDEO_PRODUCTION =
      CopilotMode._(4, _omitEnumNames ? '' : 'COPILOT_MODE_VIDEO_PRODUCTION');
  static const CopilotMode COPILOT_MODE_HELP =
      CopilotMode._(5, _omitEnumNames ? '' : 'COPILOT_MODE_HELP');

  static const $core.List<CopilotMode> values = <CopilotMode>[
    COPILOT_MODE_UNSPECIFIED,
    COPILOT_MODE_CREATIVE,
    COPILOT_MODE_ANALYTICS,
    COPILOT_MODE_ACTION,
    COPILOT_MODE_VIDEO_PRODUCTION,
    COPILOT_MODE_HELP,
  ];

  static final $core.List<CopilotMode?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 5);
  static CopilotMode? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const CopilotMode._(super.value, super.name);
}

/// ActionQuoteStatus tracks the confirmation lifecycle of an AI credit quote.
class ActionQuoteStatus extends $pb.ProtobufEnum {
  static const ActionQuoteStatus ACTION_QUOTE_STATUS_UNSPECIFIED =
      ActionQuoteStatus._(
          0, _omitEnumNames ? '' : 'ACTION_QUOTE_STATUS_UNSPECIFIED');
  static const ActionQuoteStatus ACTION_QUOTE_STATUS_PENDING =
      ActionQuoteStatus._(
          1, _omitEnumNames ? '' : 'ACTION_QUOTE_STATUS_PENDING');
  static const ActionQuoteStatus ACTION_QUOTE_STATUS_CONFIRMED =
      ActionQuoteStatus._(
          2, _omitEnumNames ? '' : 'ACTION_QUOTE_STATUS_CONFIRMED');
  static const ActionQuoteStatus ACTION_QUOTE_STATUS_CANCELLED =
      ActionQuoteStatus._(
          3, _omitEnumNames ? '' : 'ACTION_QUOTE_STATUS_CANCELLED');
  static const ActionQuoteStatus ACTION_QUOTE_STATUS_EXPIRED =
      ActionQuoteStatus._(
          4, _omitEnumNames ? '' : 'ACTION_QUOTE_STATUS_EXPIRED');

  static const $core.List<ActionQuoteStatus> values = <ActionQuoteStatus>[
    ACTION_QUOTE_STATUS_UNSPECIFIED,
    ACTION_QUOTE_STATUS_PENDING,
    ACTION_QUOTE_STATUS_CONFIRMED,
    ACTION_QUOTE_STATUS_CANCELLED,
    ACTION_QUOTE_STATUS_EXPIRED,
  ];

  static final $core.List<ActionQuoteStatus?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 4);
  static ActionQuoteStatus? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const ActionQuoteStatus._(super.value, super.name);
}

const $core.bool _omitEnumNames =
    $core.bool.fromEnvironment('protobuf.omit_enum_names');

// This is a generated file - do not edit.
//
// Generated from creativanta/automation/v1/agent.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

/// AgentRunState defines the lifecycle of an AI agent run per database_schema.md §12.4.
class AgentRunState extends $pb.ProtobufEnum {
  static const AgentRunState AGENT_RUN_STATE_UNSPECIFIED =
      AgentRunState._(0, _omitEnumNames ? '' : 'AGENT_RUN_STATE_UNSPECIFIED');
  static const AgentRunState AGENT_RUN_STATE_PLANNING =
      AgentRunState._(1, _omitEnumNames ? '' : 'AGENT_RUN_STATE_PLANNING');
  static const AgentRunState AGENT_RUN_STATE_AWAITING_APPROVAL =
      AgentRunState._(
          2, _omitEnumNames ? '' : 'AGENT_RUN_STATE_AWAITING_APPROVAL');
  static const AgentRunState AGENT_RUN_STATE_EXECUTING =
      AgentRunState._(3, _omitEnumNames ? '' : 'AGENT_RUN_STATE_EXECUTING');
  static const AgentRunState AGENT_RUN_STATE_WAITING_CONTEXT = AgentRunState._(
      4, _omitEnumNames ? '' : 'AGENT_RUN_STATE_WAITING_CONTEXT');
  static const AgentRunState AGENT_RUN_STATE_COMPLETED =
      AgentRunState._(5, _omitEnumNames ? '' : 'AGENT_RUN_STATE_COMPLETED');
  static const AgentRunState AGENT_RUN_STATE_PARTIALLY_COMPLETED =
      AgentRunState._(
          6, _omitEnumNames ? '' : 'AGENT_RUN_STATE_PARTIALLY_COMPLETED');
  static const AgentRunState AGENT_RUN_STATE_FAILED =
      AgentRunState._(7, _omitEnumNames ? '' : 'AGENT_RUN_STATE_FAILED');
  static const AgentRunState AGENT_RUN_STATE_HANDED_OFF =
      AgentRunState._(8, _omitEnumNames ? '' : 'AGENT_RUN_STATE_HANDED_OFF');
  static const AgentRunState AGENT_RUN_STATE_CANCELLED =
      AgentRunState._(9, _omitEnumNames ? '' : 'AGENT_RUN_STATE_CANCELLED');

  static const $core.List<AgentRunState> values = <AgentRunState>[
    AGENT_RUN_STATE_UNSPECIFIED,
    AGENT_RUN_STATE_PLANNING,
    AGENT_RUN_STATE_AWAITING_APPROVAL,
    AGENT_RUN_STATE_EXECUTING,
    AGENT_RUN_STATE_WAITING_CONTEXT,
    AGENT_RUN_STATE_COMPLETED,
    AGENT_RUN_STATE_PARTIALLY_COMPLETED,
    AGENT_RUN_STATE_FAILED,
    AGENT_RUN_STATE_HANDED_OFF,
    AGENT_RUN_STATE_CANCELLED,
  ];

  static final $core.List<AgentRunState?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 9);
  static AgentRunState? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const AgentRunState._(super.value, super.name);
}

/// AgentApprovalState tracks the approval gate status for agent plans.
class AgentApprovalState extends $pb.ProtobufEnum {
  static const AgentApprovalState AGENT_APPROVAL_STATE_UNSPECIFIED =
      AgentApprovalState._(
          0, _omitEnumNames ? '' : 'AGENT_APPROVAL_STATE_UNSPECIFIED');
  static const AgentApprovalState AGENT_APPROVAL_STATE_NOT_REQUIRED =
      AgentApprovalState._(
          1, _omitEnumNames ? '' : 'AGENT_APPROVAL_STATE_NOT_REQUIRED');
  static const AgentApprovalState AGENT_APPROVAL_STATE_AWAITING_APPROVAL =
      AgentApprovalState._(
          2, _omitEnumNames ? '' : 'AGENT_APPROVAL_STATE_AWAITING_APPROVAL');
  static const AgentApprovalState AGENT_APPROVAL_STATE_APPROVED =
      AgentApprovalState._(
          3, _omitEnumNames ? '' : 'AGENT_APPROVAL_STATE_APPROVED');
  static const AgentApprovalState AGENT_APPROVAL_STATE_REJECTED =
      AgentApprovalState._(
          4, _omitEnumNames ? '' : 'AGENT_APPROVAL_STATE_REJECTED');

  static const $core.List<AgentApprovalState> values = <AgentApprovalState>[
    AGENT_APPROVAL_STATE_UNSPECIFIED,
    AGENT_APPROVAL_STATE_NOT_REQUIRED,
    AGENT_APPROVAL_STATE_AWAITING_APPROVAL,
    AGENT_APPROVAL_STATE_APPROVED,
    AGENT_APPROVAL_STATE_REJECTED,
  ];

  static final $core.List<AgentApprovalState?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 4);
  static AgentApprovalState? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const AgentApprovalState._(super.value, super.name);
}

/// AgentStepStatus defines the state of an individual agent step per database_schema.md §12.4A.
class AgentStepStatus extends $pb.ProtobufEnum {
  static const AgentStepStatus AGENT_STEP_STATUS_UNSPECIFIED =
      AgentStepStatus._(
          0, _omitEnumNames ? '' : 'AGENT_STEP_STATUS_UNSPECIFIED');
  static const AgentStepStatus AGENT_STEP_STATUS_PLANNING =
      AgentStepStatus._(1, _omitEnumNames ? '' : 'AGENT_STEP_STATUS_PLANNING');
  static const AgentStepStatus AGENT_STEP_STATUS_AWAITING_APPROVAL =
      AgentStepStatus._(
          2, _omitEnumNames ? '' : 'AGENT_STEP_STATUS_AWAITING_APPROVAL');
  static const AgentStepStatus AGENT_STEP_STATUS_EXECUTING =
      AgentStepStatus._(3, _omitEnumNames ? '' : 'AGENT_STEP_STATUS_EXECUTING');
  static const AgentStepStatus AGENT_STEP_STATUS_WAITING_CONTEXT =
      AgentStepStatus._(
          4, _omitEnumNames ? '' : 'AGENT_STEP_STATUS_WAITING_CONTEXT');
  static const AgentStepStatus AGENT_STEP_STATUS_COMPLETED =
      AgentStepStatus._(5, _omitEnumNames ? '' : 'AGENT_STEP_STATUS_COMPLETED');
  static const AgentStepStatus AGENT_STEP_STATUS_FAILED =
      AgentStepStatus._(6, _omitEnumNames ? '' : 'AGENT_STEP_STATUS_FAILED');
  static const AgentStepStatus AGENT_STEP_STATUS_SKIPPED =
      AgentStepStatus._(7, _omitEnumNames ? '' : 'AGENT_STEP_STATUS_SKIPPED');
  static const AgentStepStatus AGENT_STEP_STATUS_CANCELLED =
      AgentStepStatus._(8, _omitEnumNames ? '' : 'AGENT_STEP_STATUS_CANCELLED');

  static const $core.List<AgentStepStatus> values = <AgentStepStatus>[
    AGENT_STEP_STATUS_UNSPECIFIED,
    AGENT_STEP_STATUS_PLANNING,
    AGENT_STEP_STATUS_AWAITING_APPROVAL,
    AGENT_STEP_STATUS_EXECUTING,
    AGENT_STEP_STATUS_WAITING_CONTEXT,
    AGENT_STEP_STATUS_COMPLETED,
    AGENT_STEP_STATUS_FAILED,
    AGENT_STEP_STATUS_SKIPPED,
    AGENT_STEP_STATUS_CANCELLED,
  ];

  static final $core.List<AgentStepStatus?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 8);
  static AgentStepStatus? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const AgentStepStatus._(super.value, super.name);
}

/// AgentOutputType defines the category of artifact produced by an agent run per §12.4B.
class AgentOutputType extends $pb.ProtobufEnum {
  static const AgentOutputType AGENT_OUTPUT_TYPE_UNSPECIFIED =
      AgentOutputType._(
          0, _omitEnumNames ? '' : 'AGENT_OUTPUT_TYPE_UNSPECIFIED');
  static const AgentOutputType AGENT_OUTPUT_TYPE_TEXT =
      AgentOutputType._(1, _omitEnumNames ? '' : 'AGENT_OUTPUT_TYPE_TEXT');
  static const AgentOutputType AGENT_OUTPUT_TYPE_ASSET =
      AgentOutputType._(2, _omitEnumNames ? '' : 'AGENT_OUTPUT_TYPE_ASSET');
  static const AgentOutputType AGENT_OUTPUT_TYPE_DATASET =
      AgentOutputType._(3, _omitEnumNames ? '' : 'AGENT_OUTPUT_TYPE_DATASET');
  static const AgentOutputType AGENT_OUTPUT_TYPE_WORKFLOW_PATCH =
      AgentOutputType._(
          4, _omitEnumNames ? '' : 'AGENT_OUTPUT_TYPE_WORKFLOW_PATCH');
  static const AgentOutputType AGENT_OUTPUT_TYPE_RECOMMENDATION =
      AgentOutputType._(
          5, _omitEnumNames ? '' : 'AGENT_OUTPUT_TYPE_RECOMMENDATION');
  static const AgentOutputType AGENT_OUTPUT_TYPE_REPORT =
      AgentOutputType._(6, _omitEnumNames ? '' : 'AGENT_OUTPUT_TYPE_REPORT');
  static const AgentOutputType AGENT_OUTPUT_TYPE_VIDEO =
      AgentOutputType._(7, _omitEnumNames ? '' : 'AGENT_OUTPUT_TYPE_VIDEO');

  static const $core.List<AgentOutputType> values = <AgentOutputType>[
    AGENT_OUTPUT_TYPE_UNSPECIFIED,
    AGENT_OUTPUT_TYPE_TEXT,
    AGENT_OUTPUT_TYPE_ASSET,
    AGENT_OUTPUT_TYPE_DATASET,
    AGENT_OUTPUT_TYPE_WORKFLOW_PATCH,
    AGENT_OUTPUT_TYPE_RECOMMENDATION,
    AGENT_OUTPUT_TYPE_REPORT,
    AGENT_OUTPUT_TYPE_VIDEO,
  ];

  static final $core.List<AgentOutputType?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 7);
  static AgentOutputType? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const AgentOutputType._(super.value, super.name);
}

/// AgentType defines the specialized operational role or pipeline of the agent.
class AgentType extends $pb.ProtobufEnum {
  static const AgentType AGENT_TYPE_UNSPECIFIED =
      AgentType._(0, _omitEnumNames ? '' : 'AGENT_TYPE_UNSPECIFIED');
  static const AgentType AGENT_TYPE_GENERIC =
      AgentType._(1, _omitEnumNames ? '' : 'AGENT_TYPE_GENERIC');
  static const AgentType AGENT_TYPE_VIDEO_AGENT =
      AgentType._(2, _omitEnumNames ? '' : 'AGENT_TYPE_VIDEO_AGENT');
  static const AgentType AGENT_TYPE_COPILOT_ACTION =
      AgentType._(3, _omitEnumNames ? '' : 'AGENT_TYPE_COPILOT_ACTION');
  static const AgentType AGENT_TYPE_CONTENT_OPTIMIZER =
      AgentType._(4, _omitEnumNames ? '' : 'AGENT_TYPE_CONTENT_OPTIMIZER');

  static const $core.List<AgentType> values = <AgentType>[
    AGENT_TYPE_UNSPECIFIED,
    AGENT_TYPE_GENERIC,
    AGENT_TYPE_VIDEO_AGENT,
    AGENT_TYPE_COPILOT_ACTION,
    AGENT_TYPE_CONTENT_OPTIMIZER,
  ];

  static final $core.List<AgentType?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 4);
  static AgentType? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const AgentType._(super.value, super.name);
}

const $core.bool _omitEnumNames =
    $core.bool.fromEnvironment('protobuf.omit_enum_names');

// This is a generated file - do not edit.
//
// Generated from creativanta/automation/v1/workflow.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

/// WorkflowStatus defines canonical lifecycle states per database_schema.md §12.2 and workflow_studio.md RULE-M20-001.
class WorkflowStatus extends $pb.ProtobufEnum {
  static const WorkflowStatus WORKFLOW_STATUS_UNSPECIFIED =
      WorkflowStatus._(0, _omitEnumNames ? '' : 'WORKFLOW_STATUS_UNSPECIFIED');
  static const WorkflowStatus WORKFLOW_STATUS_DRAFT =
      WorkflowStatus._(1, _omitEnumNames ? '' : 'WORKFLOW_STATUS_DRAFT');
  static const WorkflowStatus WORKFLOW_STATUS_ACTIVE =
      WorkflowStatus._(2, _omitEnumNames ? '' : 'WORKFLOW_STATUS_ACTIVE');
  static const WorkflowStatus WORKFLOW_STATUS_PAUSED =
      WorkflowStatus._(3, _omitEnumNames ? '' : 'WORKFLOW_STATUS_PAUSED');
  static const WorkflowStatus WORKFLOW_STATUS_ERROR =
      WorkflowStatus._(4, _omitEnumNames ? '' : 'WORKFLOW_STATUS_ERROR');
  static const WorkflowStatus WORKFLOW_STATUS_ARCHIVED =
      WorkflowStatus._(5, _omitEnumNames ? '' : 'WORKFLOW_STATUS_ARCHIVED');

  static const $core.List<WorkflowStatus> values = <WorkflowStatus>[
    WORKFLOW_STATUS_UNSPECIFIED,
    WORKFLOW_STATUS_DRAFT,
    WORKFLOW_STATUS_ACTIVE,
    WORKFLOW_STATUS_PAUSED,
    WORKFLOW_STATUS_ERROR,
    WORKFLOW_STATUS_ARCHIVED,
  ];

  static final $core.List<WorkflowStatus?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 5);
  static WorkflowStatus? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const WorkflowStatus._(super.value, super.name);
}

/// WorkflowRunStatus defines runtime run lifecycle states per database_schema.md §12.3 and workflow_studio.md.
class WorkflowRunStatus extends $pb.ProtobufEnum {
  static const WorkflowRunStatus WORKFLOW_RUN_STATUS_UNSPECIFIED =
      WorkflowRunStatus._(
          0, _omitEnumNames ? '' : 'WORKFLOW_RUN_STATUS_UNSPECIFIED');
  static const WorkflowRunStatus WORKFLOW_RUN_STATUS_QUEUED =
      WorkflowRunStatus._(
          1, _omitEnumNames ? '' : 'WORKFLOW_RUN_STATUS_QUEUED');
  static const WorkflowRunStatus WORKFLOW_RUN_STATUS_RUNNING =
      WorkflowRunStatus._(
          2, _omitEnumNames ? '' : 'WORKFLOW_RUN_STATUS_RUNNING');
  static const WorkflowRunStatus WORKFLOW_RUN_STATUS_WAITING_APPROVAL =
      WorkflowRunStatus._(
          3, _omitEnumNames ? '' : 'WORKFLOW_RUN_STATUS_WAITING_APPROVAL');
  static const WorkflowRunStatus
      WORKFLOW_RUN_STATUS_WAITING_EXTERNAL_CONDITION = WorkflowRunStatus._(
          4,
          _omitEnumNames
              ? ''
              : 'WORKFLOW_RUN_STATUS_WAITING_EXTERNAL_CONDITION');
  static const WorkflowRunStatus WORKFLOW_RUN_STATUS_SUCCEEDED =
      WorkflowRunStatus._(
          5, _omitEnumNames ? '' : 'WORKFLOW_RUN_STATUS_SUCCEEDED');
  static const WorkflowRunStatus WORKFLOW_RUN_STATUS_PARTIALLY_SUCCEEDED =
      WorkflowRunStatus._(
          6, _omitEnumNames ? '' : 'WORKFLOW_RUN_STATUS_PARTIALLY_SUCCEEDED');
  static const WorkflowRunStatus WORKFLOW_RUN_STATUS_FAILED =
      WorkflowRunStatus._(
          7, _omitEnumNames ? '' : 'WORKFLOW_RUN_STATUS_FAILED');
  static const WorkflowRunStatus WORKFLOW_RUN_STATUS_CANCELLED =
      WorkflowRunStatus._(
          8, _omitEnumNames ? '' : 'WORKFLOW_RUN_STATUS_CANCELLED');
  static const WorkflowRunStatus
      WORKFLOW_RUN_STATUS_REQUIRES_MANUAL_INTERVENTION = WorkflowRunStatus._(
          9,
          _omitEnumNames
              ? ''
              : 'WORKFLOW_RUN_STATUS_REQUIRES_MANUAL_INTERVENTION');

  static const $core.List<WorkflowRunStatus> values = <WorkflowRunStatus>[
    WORKFLOW_RUN_STATUS_UNSPECIFIED,
    WORKFLOW_RUN_STATUS_QUEUED,
    WORKFLOW_RUN_STATUS_RUNNING,
    WORKFLOW_RUN_STATUS_WAITING_APPROVAL,
    WORKFLOW_RUN_STATUS_WAITING_EXTERNAL_CONDITION,
    WORKFLOW_RUN_STATUS_SUCCEEDED,
    WORKFLOW_RUN_STATUS_PARTIALLY_SUCCEEDED,
    WORKFLOW_RUN_STATUS_FAILED,
    WORKFLOW_RUN_STATUS_CANCELLED,
    WORKFLOW_RUN_STATUS_REQUIRES_MANUAL_INTERVENTION,
  ];

  static final $core.List<WorkflowRunStatus?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 9);
  static WorkflowRunStatus? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const WorkflowRunStatus._(super.value, super.name);
}

/// NodeType defines all 10 canonical workflow node types per database_schema.md §12.3A and runtime_workflow.md §4.2.
class NodeType extends $pb.ProtobufEnum {
  static const NodeType NODE_TYPE_UNSPECIFIED =
      NodeType._(0, _omitEnumNames ? '' : 'NODE_TYPE_UNSPECIFIED');
  static const NodeType NODE_TYPE_TRIGGER =
      NodeType._(1, _omitEnumNames ? '' : 'NODE_TYPE_TRIGGER');
  static const NodeType NODE_TYPE_CONDITION =
      NodeType._(2, _omitEnumNames ? '' : 'NODE_TYPE_CONDITION');
  static const NodeType NODE_TYPE_TRANSFORM =
      NodeType._(3, _omitEnumNames ? '' : 'NODE_TYPE_TRANSFORM');
  static const NodeType NODE_TYPE_ACTION =
      NodeType._(4, _omitEnumNames ? '' : 'NODE_TYPE_ACTION');
  static const NodeType NODE_TYPE_APPROVAL =
      NodeType._(5, _omitEnumNames ? '' : 'NODE_TYPE_APPROVAL');
  static const NodeType NODE_TYPE_WAIT =
      NodeType._(6, _omitEnumNames ? '' : 'NODE_TYPE_WAIT');
  static const NodeType NODE_TYPE_FALLBACK =
      NodeType._(7, _omitEnumNames ? '' : 'NODE_TYPE_FALLBACK');
  static const NodeType NODE_TYPE_DIAGNOSTICS =
      NodeType._(8, _omitEnumNames ? '' : 'NODE_TYPE_DIAGNOSTICS');
  static const NodeType NODE_TYPE_HANDOFF =
      NodeType._(9, _omitEnumNames ? '' : 'NODE_TYPE_HANDOFF');
  static const NodeType NODE_TYPE_TERMINAL =
      NodeType._(10, _omitEnumNames ? '' : 'NODE_TYPE_TERMINAL');

  static const $core.List<NodeType> values = <NodeType>[
    NODE_TYPE_UNSPECIFIED,
    NODE_TYPE_TRIGGER,
    NODE_TYPE_CONDITION,
    NODE_TYPE_TRANSFORM,
    NODE_TYPE_ACTION,
    NODE_TYPE_APPROVAL,
    NODE_TYPE_WAIT,
    NODE_TYPE_FALLBACK,
    NODE_TYPE_DIAGNOSTICS,
    NODE_TYPE_HANDOFF,
    NODE_TYPE_TERMINAL,
  ];

  static final $core.List<NodeType?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 10);
  static NodeType? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const NodeType._(super.value, super.name);
}

/// TriggerType defines supported trigger types per database_schema.md §25.4.
class TriggerType extends $pb.ProtobufEnum {
  static const TriggerType TRIGGER_TYPE_UNSPECIFIED =
      TriggerType._(0, _omitEnumNames ? '' : 'TRIGGER_TYPE_UNSPECIFIED');
  static const TriggerType TRIGGER_TYPE_EVENT =
      TriggerType._(1, _omitEnumNames ? '' : 'TRIGGER_TYPE_EVENT');
  static const TriggerType TRIGGER_TYPE_SCHEDULE =
      TriggerType._(2, _omitEnumNames ? '' : 'TRIGGER_TYPE_SCHEDULE');
  static const TriggerType TRIGGER_TYPE_MANUAL =
      TriggerType._(3, _omitEnumNames ? '' : 'TRIGGER_TYPE_MANUAL');
  static const TriggerType TRIGGER_TYPE_WEBHOOK =
      TriggerType._(4, _omitEnumNames ? '' : 'TRIGGER_TYPE_WEBHOOK');

  static const $core.List<TriggerType> values = <TriggerType>[
    TRIGGER_TYPE_UNSPECIFIED,
    TRIGGER_TYPE_EVENT,
    TRIGGER_TYPE_SCHEDULE,
    TRIGGER_TYPE_MANUAL,
    TRIGGER_TYPE_WEBHOOK,
  ];

  static final $core.List<TriggerType?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 4);
  static TriggerType? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const TriggerType._(super.value, super.name);
}

/// EdgeBranch defines branching condition labels per database_schema.md §25.7.
class EdgeBranch extends $pb.ProtobufEnum {
  static const EdgeBranch EDGE_BRANCH_UNSPECIFIED =
      EdgeBranch._(0, _omitEnumNames ? '' : 'EDGE_BRANCH_UNSPECIFIED');
  static const EdgeBranch EDGE_BRANCH_SUCCESS =
      EdgeBranch._(1, _omitEnumNames ? '' : 'EDGE_BRANCH_SUCCESS');
  static const EdgeBranch EDGE_BRANCH_FAILURE =
      EdgeBranch._(2, _omitEnumNames ? '' : 'EDGE_BRANCH_FAILURE');
  static const EdgeBranch EDGE_BRANCH_TRUE =
      EdgeBranch._(3, _omitEnumNames ? '' : 'EDGE_BRANCH_TRUE');
  static const EdgeBranch EDGE_BRANCH_FALSE =
      EdgeBranch._(4, _omitEnumNames ? '' : 'EDGE_BRANCH_FALSE');

  static const $core.List<EdgeBranch> values = <EdgeBranch>[
    EDGE_BRANCH_UNSPECIFIED,
    EDGE_BRANCH_SUCCESS,
    EDGE_BRANCH_FAILURE,
    EDGE_BRANCH_TRUE,
    EDGE_BRANCH_FALSE,
  ];

  static final $core.List<EdgeBranch?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 4);
  static EdgeBranch? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const EdgeBranch._(super.value, super.name);
}

const $core.bool _omitEnumNames =
    $core.bool.fromEnvironment('protobuf.omit_enum_names');

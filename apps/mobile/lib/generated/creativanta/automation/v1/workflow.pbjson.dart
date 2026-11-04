// This is a generated file - do not edit.
//
// Generated from creativanta/automation/v1/workflow.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports
// ignore_for_file: unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use workflowStatusDescriptor instead')
const WorkflowStatus$json = {
  '1': 'WorkflowStatus',
  '2': [
    {'1': 'WORKFLOW_STATUS_UNSPECIFIED', '2': 0},
    {'1': 'WORKFLOW_STATUS_DRAFT', '2': 1},
    {'1': 'WORKFLOW_STATUS_ACTIVE', '2': 2},
    {'1': 'WORKFLOW_STATUS_PAUSED', '2': 3},
    {'1': 'WORKFLOW_STATUS_ERROR', '2': 4},
    {'1': 'WORKFLOW_STATUS_ARCHIVED', '2': 5},
  ],
};

/// Descriptor for `WorkflowStatus`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List workflowStatusDescriptor = $convert.base64Decode(
    'Cg5Xb3JrZmxvd1N0YXR1cxIfChtXT1JLRkxPV19TVEFUVVNfVU5TUEVDSUZJRUQQABIZChVXT1'
    'JLRkxPV19TVEFUVVNfRFJBRlQQARIaChZXT1JLRkxPV19TVEFUVVNfQUNUSVZFEAISGgoWV09S'
    'S0ZMT1dfU1RBVFVTX1BBVVNFRBADEhkKFVdPUktGTE9XX1NUQVRVU19FUlJPUhAEEhwKGFdPUk'
    'tGTE9XX1NUQVRVU19BUkNISVZFRBAF');

@$core.Deprecated('Use workflowRunStatusDescriptor instead')
const WorkflowRunStatus$json = {
  '1': 'WorkflowRunStatus',
  '2': [
    {'1': 'WORKFLOW_RUN_STATUS_UNSPECIFIED', '2': 0},
    {'1': 'WORKFLOW_RUN_STATUS_QUEUED', '2': 1},
    {'1': 'WORKFLOW_RUN_STATUS_RUNNING', '2': 2},
    {'1': 'WORKFLOW_RUN_STATUS_WAITING_APPROVAL', '2': 3},
    {'1': 'WORKFLOW_RUN_STATUS_WAITING_EXTERNAL_CONDITION', '2': 4},
    {'1': 'WORKFLOW_RUN_STATUS_SUCCEEDED', '2': 5},
    {'1': 'WORKFLOW_RUN_STATUS_PARTIALLY_SUCCEEDED', '2': 6},
    {'1': 'WORKFLOW_RUN_STATUS_FAILED', '2': 7},
    {'1': 'WORKFLOW_RUN_STATUS_CANCELLED', '2': 8},
    {'1': 'WORKFLOW_RUN_STATUS_REQUIRES_MANUAL_INTERVENTION', '2': 9},
  ],
};

/// Descriptor for `WorkflowRunStatus`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List workflowRunStatusDescriptor = $convert.base64Decode(
    'ChFXb3JrZmxvd1J1blN0YXR1cxIjCh9XT1JLRkxPV19SVU5fU1RBVFVTX1VOU1BFQ0lGSUVEEA'
    'ASHgoaV09SS0ZMT1dfUlVOX1NUQVRVU19RVUVVRUQQARIfChtXT1JLRkxPV19SVU5fU1RBVFVT'
    'X1JVTk5JTkcQAhIoCiRXT1JLRkxPV19SVU5fU1RBVFVTX1dBSVRJTkdfQVBQUk9WQUwQAxIyCi'
    '5XT1JLRkxPV19SVU5fU1RBVFVTX1dBSVRJTkdfRVhURVJOQUxfQ09ORElUSU9OEAQSIQodV09S'
    'S0ZMT1dfUlVOX1NUQVRVU19TVUNDRUVERUQQBRIrCidXT1JLRkxPV19SVU5fU1RBVFVTX1BBUl'
    'RJQUxMWV9TVUNDRUVERUQQBhIeChpXT1JLRkxPV19SVU5fU1RBVFVTX0ZBSUxFRBAHEiEKHVdP'
    'UktGTE9XX1JVTl9TVEFUVVNfQ0FOQ0VMTEVEEAgSNAowV09SS0ZMT1dfUlVOX1NUQVRVU19SRV'
    'FVSVJFU19NQU5VQUxfSU5URVJWRU5USU9OEAk=');

@$core.Deprecated('Use nodeTypeDescriptor instead')
const NodeType$json = {
  '1': 'NodeType',
  '2': [
    {'1': 'NODE_TYPE_UNSPECIFIED', '2': 0},
    {'1': 'NODE_TYPE_TRIGGER', '2': 1},
    {'1': 'NODE_TYPE_CONDITION', '2': 2},
    {'1': 'NODE_TYPE_TRANSFORM', '2': 3},
    {'1': 'NODE_TYPE_ACTION', '2': 4},
    {'1': 'NODE_TYPE_APPROVAL', '2': 5},
    {'1': 'NODE_TYPE_WAIT', '2': 6},
    {'1': 'NODE_TYPE_FALLBACK', '2': 7},
    {'1': 'NODE_TYPE_DIAGNOSTICS', '2': 8},
    {'1': 'NODE_TYPE_HANDOFF', '2': 9},
    {'1': 'NODE_TYPE_TERMINAL', '2': 10},
  ],
};

/// Descriptor for `NodeType`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List nodeTypeDescriptor = $convert.base64Decode(
    'CghOb2RlVHlwZRIZChVOT0RFX1RZUEVfVU5TUEVDSUZJRUQQABIVChFOT0RFX1RZUEVfVFJJR0'
    'dFUhABEhcKE05PREVfVFlQRV9DT05ESVRJT04QAhIXChNOT0RFX1RZUEVfVFJBTlNGT1JNEAMS'
    'FAoQTk9ERV9UWVBFX0FDVElPThAEEhYKEk5PREVfVFlQRV9BUFBST1ZBTBAFEhIKDk5PREVfVF'
    'lQRV9XQUlUEAYSFgoSTk9ERV9UWVBFX0ZBTExCQUNLEAcSGQoVTk9ERV9UWVBFX0RJQUdOT1NU'
    'SUNTEAgSFQoRTk9ERV9UWVBFX0hBTkRPRkYQCRIWChJOT0RFX1RZUEVfVEVSTUlOQUwQCg==');

@$core.Deprecated('Use triggerTypeDescriptor instead')
const TriggerType$json = {
  '1': 'TriggerType',
  '2': [
    {'1': 'TRIGGER_TYPE_UNSPECIFIED', '2': 0},
    {'1': 'TRIGGER_TYPE_EVENT', '2': 1},
    {'1': 'TRIGGER_TYPE_SCHEDULE', '2': 2},
    {'1': 'TRIGGER_TYPE_MANUAL', '2': 3},
    {'1': 'TRIGGER_TYPE_WEBHOOK', '2': 4},
  ],
};

/// Descriptor for `TriggerType`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List triggerTypeDescriptor = $convert.base64Decode(
    'CgtUcmlnZ2VyVHlwZRIcChhUUklHR0VSX1RZUEVfVU5TUEVDSUZJRUQQABIWChJUUklHR0VSX1'
    'RZUEVfRVZFTlQQARIZChVUUklHR0VSX1RZUEVfU0NIRURVTEUQAhIXChNUUklHR0VSX1RZUEVf'
    'TUFOVUFMEAMSGAoUVFJJR0dFUl9UWVBFX1dFQkhPT0sQBA==');

@$core.Deprecated('Use edgeBranchDescriptor instead')
const EdgeBranch$json = {
  '1': 'EdgeBranch',
  '2': [
    {'1': 'EDGE_BRANCH_UNSPECIFIED', '2': 0},
    {'1': 'EDGE_BRANCH_SUCCESS', '2': 1},
    {'1': 'EDGE_BRANCH_FAILURE', '2': 2},
    {'1': 'EDGE_BRANCH_TRUE', '2': 3},
    {'1': 'EDGE_BRANCH_FALSE', '2': 4},
  ],
};

/// Descriptor for `EdgeBranch`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List edgeBranchDescriptor = $convert.base64Decode(
    'CgpFZGdlQnJhbmNoEhsKF0VER0VfQlJBTkNIX1VOU1BFQ0lGSUVEEAASFwoTRURHRV9CUkFOQ0'
    'hfU1VDQ0VTUxABEhcKE0VER0VfQlJBTkNIX0ZBSUxVUkUQAhIUChBFREdFX0JSQU5DSF9UUlVF'
    'EAMSFQoRRURHRV9CUkFOQ0hfRkFMU0UQBA==');

@$core.Deprecated('Use triggerFilterDescriptor instead')
const TriggerFilter$json = {
  '1': 'TriggerFilter',
  '2': [
    {'1': 'field', '3': 1, '4': 1, '5': 9, '10': 'field'},
    {'1': 'operator', '3': 2, '4': 1, '5': 9, '10': 'operator'},
    {'1': 'value_json', '3': 3, '4': 1, '5': 9, '10': 'valueJson'},
  ],
};

/// Descriptor for `TriggerFilter`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List triggerFilterDescriptor = $convert.base64Decode(
    'Cg1UcmlnZ2VyRmlsdGVyEhQKBWZpZWxkGAEgASgJUgVmaWVsZBIaCghvcGVyYXRvchgCIAEoCV'
    'IIb3BlcmF0b3ISHQoKdmFsdWVfanNvbhgDIAEoCVIJdmFsdWVKc29u');

@$core.Deprecated('Use triggerConfigDescriptor instead')
const TriggerConfig$json = {
  '1': 'TriggerConfig',
  '2': [
    {
      '1': 'type',
      '3': 1,
      '4': 1,
      '5': 14,
      '6': '.creativanta.automation.v1.TriggerType',
      '10': 'type'
    },
    {'1': 'event_type', '3': 2, '4': 1, '5': 9, '10': 'eventType'},
    {'1': 'cron_expression', '3': 3, '4': 1, '5': 9, '10': 'cronExpression'},
    {'1': 'webhook_path', '3': 4, '4': 1, '5': 9, '10': 'webhookPath'},
    {
      '1': 'filters',
      '3': 5,
      '4': 3,
      '5': 11,
      '6': '.creativanta.automation.v1.TriggerFilter',
      '10': 'filters'
    },
  ],
};

/// Descriptor for `TriggerConfig`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List triggerConfigDescriptor = $convert.base64Decode(
    'Cg1UcmlnZ2VyQ29uZmlnEjoKBHR5cGUYASABKA4yJi5jcmVhdGl2YW50YS5hdXRvbWF0aW9uLn'
    'YxLlRyaWdnZXJUeXBlUgR0eXBlEh0KCmV2ZW50X3R5cGUYAiABKAlSCWV2ZW50VHlwZRInCg9j'
    'cm9uX2V4cHJlc3Npb24YAyABKAlSDmNyb25FeHByZXNzaW9uEiEKDHdlYmhvb2tfcGF0aBgEIA'
    'EoCVILd2ViaG9va1BhdGgSQgoHZmlsdGVycxgFIAMoCzIoLmNyZWF0aXZhbnRhLmF1dG9tYXRp'
    'b24udjEuVHJpZ2dlckZpbHRlclIHZmlsdGVycw==');

@$core.Deprecated('Use triggerNodeConfigDescriptor instead')
const TriggerNodeConfig$json = {
  '1': 'TriggerNodeConfig',
  '2': [
    {
      '1': 'config',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.automation.v1.TriggerConfig',
      '10': 'config'
    },
  ],
};

/// Descriptor for `TriggerNodeConfig`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List triggerNodeConfigDescriptor = $convert.base64Decode(
    'ChFUcmlnZ2VyTm9kZUNvbmZpZxJACgZjb25maWcYASABKAsyKC5jcmVhdGl2YW50YS5hdXRvbW'
    'F0aW9uLnYxLlRyaWdnZXJDb25maWdSBmNvbmZpZw==');

@$core.Deprecated('Use conditionNodeConfigDescriptor instead')
const ConditionNodeConfig$json = {
  '1': 'ConditionNodeConfig',
  '2': [
    {'1': 'field', '3': 1, '4': 1, '5': 9, '10': 'field'},
    {'1': 'operator', '3': 2, '4': 1, '5': 9, '10': 'operator'},
    {'1': 'value_json', '3': 3, '4': 1, '5': 9, '10': 'valueJson'},
  ],
};

/// Descriptor for `ConditionNodeConfig`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List conditionNodeConfigDescriptor = $convert.base64Decode(
    'ChNDb25kaXRpb25Ob2RlQ29uZmlnEhQKBWZpZWxkGAEgASgJUgVmaWVsZBIaCghvcGVyYXRvch'
    'gCIAEoCVIIb3BlcmF0b3ISHQoKdmFsdWVfanNvbhgDIAEoCVIJdmFsdWVKc29u');

@$core.Deprecated('Use transformMappingDescriptor instead')
const TransformMapping$json = {
  '1': 'TransformMapping',
  '2': [
    {'1': 'target_field', '3': 1, '4': 1, '5': 9, '10': 'targetField'},
    {'1': 'source_field', '3': 2, '4': 1, '5': 9, '10': 'sourceField'},
    {'1': 'default_value', '3': 3, '4': 1, '5': 9, '10': 'defaultValue'},
    {'1': 'template', '3': 4, '4': 1, '5': 9, '10': 'template'},
  ],
};

/// Descriptor for `TransformMapping`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List transformMappingDescriptor = $convert.base64Decode(
    'ChBUcmFuc2Zvcm1NYXBwaW5nEiEKDHRhcmdldF9maWVsZBgBIAEoCVILdGFyZ2V0RmllbGQSIQ'
    'oMc291cmNlX2ZpZWxkGAIgASgJUgtzb3VyY2VGaWVsZBIjCg1kZWZhdWx0X3ZhbHVlGAMgASgJ'
    'UgxkZWZhdWx0VmFsdWUSGgoIdGVtcGxhdGUYBCABKAlSCHRlbXBsYXRl');

@$core.Deprecated('Use transformNodeConfigDescriptor instead')
const TransformNodeConfig$json = {
  '1': 'TransformNodeConfig',
  '2': [
    {
      '1': 'mappings',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.creativanta.automation.v1.TransformMapping',
      '10': 'mappings'
    },
  ],
};

/// Descriptor for `TransformNodeConfig`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List transformNodeConfigDescriptor = $convert.base64Decode(
    'ChNUcmFuc2Zvcm1Ob2RlQ29uZmlnEkcKCG1hcHBpbmdzGAEgAygLMisuY3JlYXRpdmFudGEuYX'
    'V0b21hdGlvbi52MS5UcmFuc2Zvcm1NYXBwaW5nUghtYXBwaW5ncw==');

@$core.Deprecated('Use actionNodeConfigDescriptor instead')
const ActionNodeConfig$json = {
  '1': 'ActionNodeConfig',
  '2': [
    {'1': 'rpc_name', '3': 1, '4': 1, '5': 9, '10': 'rpcName'},
    {'1': 'input_json', '3': 2, '4': 1, '5': 9, '10': 'inputJson'},
    {'1': 'timeout_seconds', '3': 3, '4': 1, '5': 5, '10': 'timeoutSeconds'},
    {'1': 'max_retries', '3': 4, '4': 1, '5': 5, '10': 'maxRetries'},
    {'1': 'backoff_seconds', '3': 5, '4': 1, '5': 5, '10': 'backoffSeconds'},
  ],
};

/// Descriptor for `ActionNodeConfig`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List actionNodeConfigDescriptor = $convert.base64Decode(
    'ChBBY3Rpb25Ob2RlQ29uZmlnEhkKCHJwY19uYW1lGAEgASgJUgdycGNOYW1lEh0KCmlucHV0X2'
    'pzb24YAiABKAlSCWlucHV0SnNvbhInCg90aW1lb3V0X3NlY29uZHMYAyABKAVSDnRpbWVvdXRT'
    'ZWNvbmRzEh8KC21heF9yZXRyaWVzGAQgASgFUgptYXhSZXRyaWVzEicKD2JhY2tvZmZfc2Vjb2'
    '5kcxgFIAEoBVIOYmFja29mZlNlY29uZHM=');

@$core.Deprecated('Use approvalNodeConfigDescriptor instead')
const ApprovalNodeConfig$json = {
  '1': 'ApprovalNodeConfig',
  '2': [
    {'1': 'approver_ids', '3': 1, '4': 3, '5': 9, '10': 'approverIds'},
    {
      '1': 'required_approvals',
      '3': 2,
      '4': 1,
      '5': 5,
      '10': 'requiredApprovals'
    },
    {
      '1': 'expires_at_duration_seconds',
      '3': 3,
      '4': 1,
      '5': 3,
      '10': 'expiresAtDurationSeconds'
    },
    {
      '1': 'auto_action_on_timeout',
      '3': 4,
      '4': 1,
      '5': 9,
      '10': 'autoActionOnTimeout'
    },
  ],
};

/// Descriptor for `ApprovalNodeConfig`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List approvalNodeConfigDescriptor = $convert.base64Decode(
    'ChJBcHByb3ZhbE5vZGVDb25maWcSIQoMYXBwcm92ZXJfaWRzGAEgAygJUgthcHByb3Zlcklkcx'
    'ItChJyZXF1aXJlZF9hcHByb3ZhbHMYAiABKAVSEXJlcXVpcmVkQXBwcm92YWxzEj0KG2V4cGly'
    'ZXNfYXRfZHVyYXRpb25fc2Vjb25kcxgDIAEoA1IYZXhwaXJlc0F0RHVyYXRpb25TZWNvbmRzEj'
    'MKFmF1dG9fYWN0aW9uX29uX3RpbWVvdXQYBCABKAlSE2F1dG9BY3Rpb25PblRpbWVvdXQ=');

@$core.Deprecated('Use waitNodeConfigDescriptor instead')
const WaitNodeConfig$json = {
  '1': 'WaitNodeConfig',
  '2': [
    {'1': 'wait_type', '3': 1, '4': 1, '5': 9, '10': 'waitType'},
    {'1': 'duration_seconds', '3': 2, '4': 1, '5': 3, '10': 'durationSeconds'},
    {'1': 'resume_condition', '3': 3, '4': 1, '5': 9, '10': 'resumeCondition'},
    {'1': 'until_timestamp', '3': 4, '4': 1, '5': 9, '10': 'untilTimestamp'},
  ],
};

/// Descriptor for `WaitNodeConfig`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List waitNodeConfigDescriptor = $convert.base64Decode(
    'Cg5XYWl0Tm9kZUNvbmZpZxIbCgl3YWl0X3R5cGUYASABKAlSCHdhaXRUeXBlEikKEGR1cmF0aW'
    '9uX3NlY29uZHMYAiABKANSD2R1cmF0aW9uU2Vjb25kcxIpChByZXN1bWVfY29uZGl0aW9uGAMg'
    'ASgJUg9yZXN1bWVDb25kaXRpb24SJwoPdW50aWxfdGltZXN0YW1wGAQgASgJUg51bnRpbFRpbW'
    'VzdGFtcA==');

@$core.Deprecated('Use fallbackNodeConfigDescriptor instead')
const FallbackNodeConfig$json = {
  '1': 'FallbackNodeConfig',
  '2': [
    {'1': 'fallback_node_id', '3': 1, '4': 1, '5': 9, '10': 'fallbackNodeId'},
    {'1': 'reason_template', '3': 2, '4': 1, '5': 9, '10': 'reasonTemplate'},
    {'1': 'log_level', '3': 3, '4': 1, '5': 9, '10': 'logLevel'},
  ],
};

/// Descriptor for `FallbackNodeConfig`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List fallbackNodeConfigDescriptor = $convert.base64Decode(
    'ChJGYWxsYmFja05vZGVDb25maWcSKAoQZmFsbGJhY2tfbm9kZV9pZBgBIAEoCVIOZmFsbGJhY2'
    'tOb2RlSWQSJwoPcmVhc29uX3RlbXBsYXRlGAIgASgJUg5yZWFzb25UZW1wbGF0ZRIbCglsb2df'
    'bGV2ZWwYAyABKAlSCGxvZ0xldmVs');

@$core.Deprecated('Use diagnosticsNodeConfigDescriptor instead')
const DiagnosticsNodeConfig$json = {
  '1': 'DiagnosticsNodeConfig',
  '2': [
    {'1': 'severity', '3': 1, '4': 1, '5': 9, '10': 'severity'},
    {'1': 'user_message', '3': 2, '4': 1, '5': 9, '10': 'userMessage'},
    {'1': 'operator_message', '3': 3, '4': 1, '5': 9, '10': 'operatorMessage'},
    {
      '1': 'recommended_next_step',
      '3': 4,
      '4': 1,
      '5': 9,
      '10': 'recommendedNextStep'
    },
  ],
};

/// Descriptor for `DiagnosticsNodeConfig`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List diagnosticsNodeConfigDescriptor = $convert.base64Decode(
    'ChVEaWFnbm9zdGljc05vZGVDb25maWcSGgoIc2V2ZXJpdHkYASABKAlSCHNldmVyaXR5EiEKDH'
    'VzZXJfbWVzc2FnZRgCIAEoCVILdXNlck1lc3NhZ2USKQoQb3BlcmF0b3JfbWVzc2FnZRgDIAEo'
    'CVIPb3BlcmF0b3JNZXNzYWdlEjIKFXJlY29tbWVuZGVkX25leHRfc3RlcBgEIAEoCVITcmVjb2'
    '1tZW5kZWROZXh0U3RlcA==');

@$core.Deprecated('Use handoffNodeConfigDescriptor instead')
const HandoffNodeConfig$json = {
  '1': 'HandoffNodeConfig',
  '2': [
    {'1': 'target_user_id', '3': 1, '4': 1, '5': 9, '10': 'targetUserId'},
    {'1': 'target_role', '3': 2, '4': 1, '5': 9, '10': 'targetRole'},
    {'1': 'context_note', '3': 3, '4': 1, '5': 9, '10': 'contextNote'},
  ],
};

/// Descriptor for `HandoffNodeConfig`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List handoffNodeConfigDescriptor = $convert.base64Decode(
    'ChFIYW5kb2ZmTm9kZUNvbmZpZxIkCg50YXJnZXRfdXNlcl9pZBgBIAEoCVIMdGFyZ2V0VXNlck'
    'lkEh8KC3RhcmdldF9yb2xlGAIgASgJUgp0YXJnZXRSb2xlEiEKDGNvbnRleHRfbm90ZRgDIAEo'
    'CVILY29udGV4dE5vdGU=');

@$core.Deprecated('Use terminalNodeConfigDescriptor instead')
const TerminalNodeConfig$json = {
  '1': 'TerminalNodeConfig',
  '2': [
    {'1': 'outcome', '3': 1, '4': 1, '5': 9, '10': 'outcome'},
    {'1': 'result_template', '3': 2, '4': 1, '5': 9, '10': 'resultTemplate'},
  ],
};

/// Descriptor for `TerminalNodeConfig`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List terminalNodeConfigDescriptor = $convert.base64Decode(
    'ChJUZXJtaW5hbE5vZGVDb25maWcSGAoHb3V0Y29tZRgBIAEoCVIHb3V0Y29tZRInCg9yZXN1bH'
    'RfdGVtcGxhdGUYAiABKAlSDnJlc3VsdFRlbXBsYXRl');

@$core.Deprecated('Use workflowNodeDescriptor instead')
const WorkflowNode$json = {
  '1': 'WorkflowNode',
  '2': [
    {'1': 'node_id', '3': 1, '4': 1, '5': 9, '10': 'nodeId'},
    {
      '1': 'node_type',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.creativanta.automation.v1.NodeType',
      '10': 'nodeType'
    },
    {'1': 'title', '3': 3, '4': 1, '5': 9, '10': 'title'},
    {'1': 'description', '3': 4, '4': 1, '5': 9, '10': 'description'},
    {
      '1': 'trigger_config',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.creativanta.automation.v1.TriggerNodeConfig',
      '9': 0,
      '10': 'triggerConfig'
    },
    {
      '1': 'condition_config',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.creativanta.automation.v1.ConditionNodeConfig',
      '9': 0,
      '10': 'conditionConfig'
    },
    {
      '1': 'transform_config',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.creativanta.automation.v1.TransformNodeConfig',
      '9': 0,
      '10': 'transformConfig'
    },
    {
      '1': 'action_config',
      '3': 8,
      '4': 1,
      '5': 11,
      '6': '.creativanta.automation.v1.ActionNodeConfig',
      '9': 0,
      '10': 'actionConfig'
    },
    {
      '1': 'approval_config',
      '3': 9,
      '4': 1,
      '5': 11,
      '6': '.creativanta.automation.v1.ApprovalNodeConfig',
      '9': 0,
      '10': 'approvalConfig'
    },
    {
      '1': 'wait_config',
      '3': 10,
      '4': 1,
      '5': 11,
      '6': '.creativanta.automation.v1.WaitNodeConfig',
      '9': 0,
      '10': 'waitConfig'
    },
    {
      '1': 'fallback_config',
      '3': 11,
      '4': 1,
      '5': 11,
      '6': '.creativanta.automation.v1.FallbackNodeConfig',
      '9': 0,
      '10': 'fallbackConfig'
    },
    {
      '1': 'diagnostics_config',
      '3': 12,
      '4': 1,
      '5': 11,
      '6': '.creativanta.automation.v1.DiagnosticsNodeConfig',
      '9': 0,
      '10': 'diagnosticsConfig'
    },
    {
      '1': 'handoff_config',
      '3': 13,
      '4': 1,
      '5': 11,
      '6': '.creativanta.automation.v1.HandoffNodeConfig',
      '9': 0,
      '10': 'handoffConfig'
    },
    {
      '1': 'terminal_config',
      '3': 14,
      '4': 1,
      '5': 11,
      '6': '.creativanta.automation.v1.TerminalNodeConfig',
      '9': 0,
      '10': 'terminalConfig'
    },
    {'1': 'raw_config_json', '3': 15, '4': 1, '5': 9, '10': 'rawConfigJson'},
  ],
  '8': [
    {'1': 'config'},
  ],
};

/// Descriptor for `WorkflowNode`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List workflowNodeDescriptor = $convert.base64Decode(
    'CgxXb3JrZmxvd05vZGUSFwoHbm9kZV9pZBgBIAEoCVIGbm9kZUlkEkAKCW5vZGVfdHlwZRgCIA'
    'EoDjIjLmNyZWF0aXZhbnRhLmF1dG9tYXRpb24udjEuTm9kZVR5cGVSCG5vZGVUeXBlEhQKBXRp'
    'dGxlGAMgASgJUgV0aXRsZRIgCgtkZXNjcmlwdGlvbhgEIAEoCVILZGVzY3JpcHRpb24SVQoOdH'
    'JpZ2dlcl9jb25maWcYBSABKAsyLC5jcmVhdGl2YW50YS5hdXRvbWF0aW9uLnYxLlRyaWdnZXJO'
    'b2RlQ29uZmlnSABSDXRyaWdnZXJDb25maWcSWwoQY29uZGl0aW9uX2NvbmZpZxgGIAEoCzIuLm'
    'NyZWF0aXZhbnRhLmF1dG9tYXRpb24udjEuQ29uZGl0aW9uTm9kZUNvbmZpZ0gAUg9jb25kaXRp'
    'b25Db25maWcSWwoQdHJhbnNmb3JtX2NvbmZpZxgHIAEoCzIuLmNyZWF0aXZhbnRhLmF1dG9tYX'
    'Rpb24udjEuVHJhbnNmb3JtTm9kZUNvbmZpZ0gAUg90cmFuc2Zvcm1Db25maWcSUgoNYWN0aW9u'
    'X2NvbmZpZxgIIAEoCzIrLmNyZWF0aXZhbnRhLmF1dG9tYXRpb24udjEuQWN0aW9uTm9kZUNvbm'
    'ZpZ0gAUgxhY3Rpb25Db25maWcSWAoPYXBwcm92YWxfY29uZmlnGAkgASgLMi0uY3JlYXRpdmFu'
    'dGEuYXV0b21hdGlvbi52MS5BcHByb3ZhbE5vZGVDb25maWdIAFIOYXBwcm92YWxDb25maWcSTA'
    'oLd2FpdF9jb25maWcYCiABKAsyKS5jcmVhdGl2YW50YS5hdXRvbWF0aW9uLnYxLldhaXROb2Rl'
    'Q29uZmlnSABSCndhaXRDb25maWcSWAoPZmFsbGJhY2tfY29uZmlnGAsgASgLMi0uY3JlYXRpdm'
    'FudGEuYXV0b21hdGlvbi52MS5GYWxsYmFja05vZGVDb25maWdIAFIOZmFsbGJhY2tDb25maWcS'
    'YQoSZGlhZ25vc3RpY3NfY29uZmlnGAwgASgLMjAuY3JlYXRpdmFudGEuYXV0b21hdGlvbi52MS'
    '5EaWFnbm9zdGljc05vZGVDb25maWdIAFIRZGlhZ25vc3RpY3NDb25maWcSVQoOaGFuZG9mZl9j'
    'b25maWcYDSABKAsyLC5jcmVhdGl2YW50YS5hdXRvbWF0aW9uLnYxLkhhbmRvZmZOb2RlQ29uZm'
    'lnSABSDWhhbmRvZmZDb25maWcSWAoPdGVybWluYWxfY29uZmlnGA4gASgLMi0uY3JlYXRpdmFu'
    'dGEuYXV0b21hdGlvbi52MS5UZXJtaW5hbE5vZGVDb25maWdIAFIOdGVybWluYWxDb25maWcSJg'
    'oPcmF3X2NvbmZpZ19qc29uGA8gASgJUg1yYXdDb25maWdKc29uQggKBmNvbmZpZw==');

@$core.Deprecated('Use workflowEdgeDescriptor instead')
const WorkflowEdge$json = {
  '1': 'WorkflowEdge',
  '2': [
    {'1': 'from_node_id', '3': 1, '4': 1, '5': 9, '10': 'fromNodeId'},
    {'1': 'to_node_id', '3': 2, '4': 1, '5': 9, '10': 'toNodeId'},
    {
      '1': 'branch',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.creativanta.automation.v1.EdgeBranch',
      '10': 'branch'
    },
  ],
};

/// Descriptor for `WorkflowEdge`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List workflowEdgeDescriptor = $convert.base64Decode(
    'CgxXb3JrZmxvd0VkZ2USIAoMZnJvbV9ub2RlX2lkGAEgASgJUgpmcm9tTm9kZUlkEhwKCnRvX2'
    '5vZGVfaWQYAiABKAlSCHRvTm9kZUlkEj0KBmJyYW5jaBgDIAEoDjIlLmNyZWF0aXZhbnRhLmF1'
    'dG9tYXRpb24udjEuRWRnZUJyYW5jaFIGYnJhbmNo');

@$core.Deprecated('Use workflowGraphDescriptor instead')
const WorkflowGraph$json = {
  '1': 'WorkflowGraph',
  '2': [
    {'1': 'schema_version', '3': 1, '4': 1, '5': 5, '10': 'schemaVersion'},
    {
      '1': 'nodes',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.creativanta.automation.v1.WorkflowNode',
      '10': 'nodes'
    },
    {
      '1': 'edges',
      '3': 3,
      '4': 3,
      '5': 11,
      '6': '.creativanta.automation.v1.WorkflowEdge',
      '10': 'edges'
    },
  ],
};

/// Descriptor for `WorkflowGraph`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List workflowGraphDescriptor = $convert.base64Decode(
    'Cg1Xb3JrZmxvd0dyYXBoEiUKDnNjaGVtYV92ZXJzaW9uGAEgASgFUg1zY2hlbWFWZXJzaW9uEj'
    '0KBW5vZGVzGAIgAygLMicuY3JlYXRpdmFudGEuYXV0b21hdGlvbi52MS5Xb3JrZmxvd05vZGVS'
    'BW5vZGVzEj0KBWVkZ2VzGAMgAygLMicuY3JlYXRpdmFudGEuYXV0b21hdGlvbi52MS5Xb3JrZm'
    'xvd0VkZ2VSBWVkZ2Vz');

@$core.Deprecated('Use workflowDescriptor instead')
const Workflow$json = {
  '1': 'Workflow',
  '2': [
    {'1': 'workflow_id', '3': 1, '4': 1, '5': 9, '10': 'workflowId'},
    {'1': 'workspace_id', '3': 2, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'title', '3': 3, '4': 1, '5': 9, '10': 'title'},
    {'1': 'description', '3': 4, '4': 1, '5': 9, '10': 'description'},
    {'1': 'workflow_type', '3': 5, '4': 1, '5': 9, '10': 'workflowType'},
    {
      '1': 'status',
      '3': 6,
      '4': 1,
      '5': 14,
      '6': '.creativanta.automation.v1.WorkflowStatus',
      '10': 'status'
    },
    {'1': 'version', '3': 7, '4': 1, '5': 5, '10': 'version'},
    {
      '1': 'trigger_config',
      '3': 8,
      '4': 1,
      '5': 11,
      '6': '.creativanta.automation.v1.TriggerConfig',
      '10': 'triggerConfig'
    },
    {
      '1': 'action_chain',
      '3': 9,
      '4': 1,
      '5': 11,
      '6': '.creativanta.automation.v1.WorkflowGraph',
      '10': 'actionChain'
    },
    {
      '1': 'action_chain_json',
      '3': 10,
      '4': 1,
      '5': 9,
      '10': 'actionChainJson'
    },
    {
      '1': 'approval_requirements_json',
      '3': 11,
      '4': 1,
      '5': 9,
      '10': 'approvalRequirementsJson'
    },
    {
      '1': 'activepieces_flow_id',
      '3': 12,
      '4': 1,
      '5': 9,
      '10': 'activepiecesFlowId'
    },
    {'1': 'tier_limit_check', '3': 13, '4': 1, '5': 8, '10': 'tierLimitCheck'},
    {'1': 'run_count', '3': 14, '4': 1, '5': 5, '10': 'runCount'},
    {'1': 'created_by', '3': 15, '4': 1, '5': 9, '10': 'createdBy'},
    {
      '1': 'created_at',
      '3': 16,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'createdAt'
    },
    {
      '1': 'updated_at',
      '3': 17,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'updatedAt'
    },
  ],
};

/// Descriptor for `Workflow`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List workflowDescriptor = $convert.base64Decode(
    'CghXb3JrZmxvdxIfCgt3b3JrZmxvd19pZBgBIAEoCVIKd29ya2Zsb3dJZBIhCgx3b3Jrc3BhY2'
    'VfaWQYAiABKAlSC3dvcmtzcGFjZUlkEhQKBXRpdGxlGAMgASgJUgV0aXRsZRIgCgtkZXNjcmlw'
    'dGlvbhgEIAEoCVILZGVzY3JpcHRpb24SIwoNd29ya2Zsb3dfdHlwZRgFIAEoCVIMd29ya2Zsb3'
    'dUeXBlEkEKBnN0YXR1cxgGIAEoDjIpLmNyZWF0aXZhbnRhLmF1dG9tYXRpb24udjEuV29ya2Zs'
    'b3dTdGF0dXNSBnN0YXR1cxIYCgd2ZXJzaW9uGAcgASgFUgd2ZXJzaW9uEk8KDnRyaWdnZXJfY2'
    '9uZmlnGAggASgLMiguY3JlYXRpdmFudGEuYXV0b21hdGlvbi52MS5UcmlnZ2VyQ29uZmlnUg10'
    'cmlnZ2VyQ29uZmlnEksKDGFjdGlvbl9jaGFpbhgJIAEoCzIoLmNyZWF0aXZhbnRhLmF1dG9tYX'
    'Rpb24udjEuV29ya2Zsb3dHcmFwaFILYWN0aW9uQ2hhaW4SKgoRYWN0aW9uX2NoYWluX2pzb24Y'
    'CiABKAlSD2FjdGlvbkNoYWluSnNvbhI8ChphcHByb3ZhbF9yZXF1aXJlbWVudHNfanNvbhgLIA'
    'EoCVIYYXBwcm92YWxSZXF1aXJlbWVudHNKc29uEjAKFGFjdGl2ZXBpZWNlc19mbG93X2lkGAwg'
    'ASgJUhJhY3RpdmVwaWVjZXNGbG93SWQSKAoQdGllcl9saW1pdF9jaGVjaxgNIAEoCFIOdGllck'
    'xpbWl0Q2hlY2sSGwoJcnVuX2NvdW50GA4gASgFUghydW5Db3VudBIdCgpjcmVhdGVkX2J5GA8g'
    'ASgJUgljcmVhdGVkQnkSOQoKY3JlYXRlZF9hdBgQIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW'
    '1lc3RhbXBSCWNyZWF0ZWRBdBI5Cgp1cGRhdGVkX2F0GBEgASgLMhouZ29vZ2xlLnByb3RvYnVm'
    'LlRpbWVzdGFtcFIJdXBkYXRlZEF0');

@$core.Deprecated('Use workflowSummaryDescriptor instead')
const WorkflowSummary$json = {
  '1': 'WorkflowSummary',
  '2': [
    {'1': 'workflow_id', '3': 1, '4': 1, '5': 9, '10': 'workflowId'},
    {'1': 'workspace_id', '3': 2, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'title', '3': 3, '4': 1, '5': 9, '10': 'title'},
    {'1': 'workflow_type', '3': 4, '4': 1, '5': 9, '10': 'workflowType'},
    {
      '1': 'status',
      '3': 5,
      '4': 1,
      '5': 14,
      '6': '.creativanta.automation.v1.WorkflowStatus',
      '10': 'status'
    },
    {'1': 'version', '3': 6, '4': 1, '5': 5, '10': 'version'},
    {
      '1': 'trigger_type',
      '3': 7,
      '4': 1,
      '5': 14,
      '6': '.creativanta.automation.v1.TriggerType',
      '10': 'triggerType'
    },
    {'1': 'node_count', '3': 8, '4': 1, '5': 5, '10': 'nodeCount'},
    {'1': 'run_count', '3': 9, '4': 1, '5': 5, '10': 'runCount'},
    {
      '1': 'created_at',
      '3': 10,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'createdAt'
    },
    {
      '1': 'updated_at',
      '3': 11,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'updatedAt'
    },
  ],
};

/// Descriptor for `WorkflowSummary`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List workflowSummaryDescriptor = $convert.base64Decode(
    'Cg9Xb3JrZmxvd1N1bW1hcnkSHwoLd29ya2Zsb3dfaWQYASABKAlSCndvcmtmbG93SWQSIQoMd2'
    '9ya3NwYWNlX2lkGAIgASgJUgt3b3Jrc3BhY2VJZBIUCgV0aXRsZRgDIAEoCVIFdGl0bGUSIwoN'
    'd29ya2Zsb3dfdHlwZRgEIAEoCVIMd29ya2Zsb3dUeXBlEkEKBnN0YXR1cxgFIAEoDjIpLmNyZW'
    'F0aXZhbnRhLmF1dG9tYXRpb24udjEuV29ya2Zsb3dTdGF0dXNSBnN0YXR1cxIYCgd2ZXJzaW9u'
    'GAYgASgFUgd2ZXJzaW9uEkkKDHRyaWdnZXJfdHlwZRgHIAEoDjImLmNyZWF0aXZhbnRhLmF1dG'
    '9tYXRpb24udjEuVHJpZ2dlclR5cGVSC3RyaWdnZXJUeXBlEh0KCm5vZGVfY291bnQYCCABKAVS'
    'CW5vZGVDb3VudBIbCglydW5fY291bnQYCSABKAVSCHJ1bkNvdW50EjkKCmNyZWF0ZWRfYXQYCi'
    'ABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUgljcmVhdGVkQXQSOQoKdXBkYXRlZF9h'
    'dBgLIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSCXVwZGF0ZWRBdA==');

@$core.Deprecated('Use workflowRunDescriptor instead')
const WorkflowRun$json = {
  '1': 'WorkflowRun',
  '2': [
    {'1': 'run_id', '3': 1, '4': 1, '5': 9, '10': 'runId'},
    {'1': 'workspace_id', '3': 2, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'workflow_id', '3': 3, '4': 1, '5': 9, '10': 'workflowId'},
    {
      '1': 'status',
      '3': 4,
      '4': 1,
      '5': 14,
      '6': '.creativanta.automation.v1.WorkflowRunStatus',
      '10': 'status'
    },
    {'1': 'current_node', '3': 5, '4': 1, '5': 9, '10': 'currentNode'},
    {
      '1': 'trigger_event_json',
      '3': 6,
      '4': 1,
      '5': 9,
      '10': 'triggerEventJson'
    },
    {
      '1': 'result_summary_json',
      '3': 7,
      '4': 1,
      '5': 9,
      '10': 'resultSummaryJson'
    },
    {
      '1': 'execution_log_json',
      '3': 8,
      '4': 1,
      '5': 9,
      '10': 'executionLogJson'
    },
    {
      '1': 'affected_object_refs_json',
      '3': 9,
      '4': 1,
      '5': 9,
      '10': 'affectedObjectRefsJson'
    },
    {
      '1': 'side_effects_summary_json',
      '3': 10,
      '4': 1,
      '5': 9,
      '10': 'sideEffectsSummaryJson'
    },
    {
      '1': 'activepieces_run_id',
      '3': 11,
      '4': 1,
      '5': 9,
      '10': 'activepiecesRunId'
    },
    {
      '1': 'started_at',
      '3': 12,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'startedAt'
    },
    {
      '1': 'completed_at',
      '3': 13,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'completedAt'
    },
    {
      '1': 'created_at',
      '3': 14,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'createdAt'
    },
    {
      '1': 'updated_at',
      '3': 15,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'updatedAt'
    },
  ],
};

/// Descriptor for `WorkflowRun`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List workflowRunDescriptor = $convert.base64Decode(
    'CgtXb3JrZmxvd1J1bhIVCgZydW5faWQYASABKAlSBXJ1bklkEiEKDHdvcmtzcGFjZV9pZBgCIA'
    'EoCVILd29ya3NwYWNlSWQSHwoLd29ya2Zsb3dfaWQYAyABKAlSCndvcmtmbG93SWQSRAoGc3Rh'
    'dHVzGAQgASgOMiwuY3JlYXRpdmFudGEuYXV0b21hdGlvbi52MS5Xb3JrZmxvd1J1blN0YXR1c1'
    'IGc3RhdHVzEiEKDGN1cnJlbnRfbm9kZRgFIAEoCVILY3VycmVudE5vZGUSLAoSdHJpZ2dlcl9l'
    'dmVudF9qc29uGAYgASgJUhB0cmlnZ2VyRXZlbnRKc29uEi4KE3Jlc3VsdF9zdW1tYXJ5X2pzb2'
    '4YByABKAlSEXJlc3VsdFN1bW1hcnlKc29uEiwKEmV4ZWN1dGlvbl9sb2dfanNvbhgIIAEoCVIQ'
    'ZXhlY3V0aW9uTG9nSnNvbhI5ChlhZmZlY3RlZF9vYmplY3RfcmVmc19qc29uGAkgASgJUhZhZm'
    'ZlY3RlZE9iamVjdFJlZnNKc29uEjkKGXNpZGVfZWZmZWN0c19zdW1tYXJ5X2pzb24YCiABKAlS'
    'FnNpZGVFZmZlY3RzU3VtbWFyeUpzb24SLgoTYWN0aXZlcGllY2VzX3J1bl9pZBgLIAEoCVIRYW'
    'N0aXZlcGllY2VzUnVuSWQSOQoKc3RhcnRlZF9hdBgMIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5U'
    'aW1lc3RhbXBSCXN0YXJ0ZWRBdBI9Cgxjb21wbGV0ZWRfYXQYDSABKAsyGi5nb29nbGUucHJvdG'
    '9idWYuVGltZXN0YW1wUgtjb21wbGV0ZWRBdBI5CgpjcmVhdGVkX2F0GA4gASgLMhouZ29vZ2xl'
    'LnByb3RvYnVmLlRpbWVzdGFtcFIJY3JlYXRlZEF0EjkKCnVwZGF0ZWRfYXQYDyABKAsyGi5nb2'
    '9nbGUucHJvdG9idWYuVGltZXN0YW1wUgl1cGRhdGVkQXQ=');

@$core.Deprecated('Use workflowRunStepDescriptor instead')
const WorkflowRunStep$json = {
  '1': 'WorkflowRunStep',
  '2': [
    {'1': 'step_id', '3': 1, '4': 1, '5': 9, '10': 'stepId'},
    {'1': 'workspace_id', '3': 2, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'run_id', '3': 3, '4': 1, '5': 9, '10': 'runId'},
    {'1': 'node_id', '3': 4, '4': 1, '5': 9, '10': 'nodeId'},
    {
      '1': 'node_type',
      '3': 5,
      '4': 1,
      '5': 14,
      '6': '.creativanta.automation.v1.NodeType',
      '10': 'nodeType'
    },
    {'1': 'step_order', '3': 6, '4': 1, '5': 5, '10': 'stepOrder'},
    {'1': 'status', '3': 7, '4': 1, '5': 9, '10': 'status'},
    {
      '1': 'input_snapshot_json',
      '3': 8,
      '4': 1,
      '5': 9,
      '10': 'inputSnapshotJson'
    },
    {
      '1': 'output_snapshot_json',
      '3': 9,
      '4': 1,
      '5': 9,
      '10': 'outputSnapshotJson'
    },
    {'1': 'diagnostics_ref', '3': 10, '4': 1, '5': 9, '10': 'diagnosticsRef'},
    {
      '1': 'side_effect_refs_json',
      '3': 11,
      '4': 1,
      '5': 9,
      '10': 'sideEffectRefsJson'
    },
    {
      '1': 'started_at',
      '3': 12,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'startedAt'
    },
    {
      '1': 'completed_at',
      '3': 13,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'completedAt'
    },
    {
      '1': 'created_at',
      '3': 14,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'createdAt'
    },
    {
      '1': 'updated_at',
      '3': 15,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'updatedAt'
    },
  ],
};

/// Descriptor for `WorkflowRunStep`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List workflowRunStepDescriptor = $convert.base64Decode(
    'Cg9Xb3JrZmxvd1J1blN0ZXASFwoHc3RlcF9pZBgBIAEoCVIGc3RlcElkEiEKDHdvcmtzcGFjZV'
    '9pZBgCIAEoCVILd29ya3NwYWNlSWQSFQoGcnVuX2lkGAMgASgJUgVydW5JZBIXCgdub2RlX2lk'
    'GAQgASgJUgZub2RlSWQSQAoJbm9kZV90eXBlGAUgASgOMiMuY3JlYXRpdmFudGEuYXV0b21hdG'
    'lvbi52MS5Ob2RlVHlwZVIIbm9kZVR5cGUSHQoKc3RlcF9vcmRlchgGIAEoBVIJc3RlcE9yZGVy'
    'EhYKBnN0YXR1cxgHIAEoCVIGc3RhdHVzEi4KE2lucHV0X3NuYXBzaG90X2pzb24YCCABKAlSEW'
    'lucHV0U25hcHNob3RKc29uEjAKFG91dHB1dF9zbmFwc2hvdF9qc29uGAkgASgJUhJvdXRwdXRT'
    'bmFwc2hvdEpzb24SJwoPZGlhZ25vc3RpY3NfcmVmGAogASgJUg5kaWFnbm9zdGljc1JlZhIxCh'
    'VzaWRlX2VmZmVjdF9yZWZzX2pzb24YCyABKAlSEnNpZGVFZmZlY3RSZWZzSnNvbhI5CgpzdGFy'
    'dGVkX2F0GAwgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIJc3RhcnRlZEF0Ej0KDG'
    'NvbXBsZXRlZF9hdBgNIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSC2NvbXBsZXRl'
    'ZEF0EjkKCmNyZWF0ZWRfYXQYDiABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUgljcm'
    'VhdGVkQXQSOQoKdXBkYXRlZF9hdBgPIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBS'
    'CXVwZGF0ZWRBdA==');

@$core.Deprecated('Use portableWorkflowPayloadDescriptor instead')
const PortableWorkflowPayload$json = {
  '1': 'PortableWorkflowPayload',
  '2': [
    {'1': 'schema_version', '3': 1, '4': 1, '5': 5, '10': 'schemaVersion'},
    {'1': 'title', '3': 2, '4': 1, '5': 9, '10': 'title'},
    {'1': 'description', '3': 3, '4': 1, '5': 9, '10': 'description'},
    {'1': 'workflow_type', '3': 4, '4': 1, '5': 9, '10': 'workflowType'},
    {
      '1': 'trigger_config',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.creativanta.automation.v1.TriggerConfig',
      '10': 'triggerConfig'
    },
    {
      '1': 'graph',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.creativanta.automation.v1.WorkflowGraph',
      '10': 'graph'
    },
    {'1': 'license_notice', '3': 7, '4': 1, '5': 9, '10': 'licenseNotice'},
    {'1': 'parameters_json', '3': 8, '4': 1, '5': 9, '10': 'parametersJson'},
  ],
};

/// Descriptor for `PortableWorkflowPayload`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List portableWorkflowPayloadDescriptor = $convert.base64Decode(
    'ChdQb3J0YWJsZVdvcmtmbG93UGF5bG9hZBIlCg5zY2hlbWFfdmVyc2lvbhgBIAEoBVINc2NoZW'
    '1hVmVyc2lvbhIUCgV0aXRsZRgCIAEoCVIFdGl0bGUSIAoLZGVzY3JpcHRpb24YAyABKAlSC2Rl'
    'c2NyaXB0aW9uEiMKDXdvcmtmbG93X3R5cGUYBCABKAlSDHdvcmtmbG93VHlwZRJPCg50cmlnZ2'
    'VyX2NvbmZpZxgFIAEoCzIoLmNyZWF0aXZhbnRhLmF1dG9tYXRpb24udjEuVHJpZ2dlckNvbmZp'
    'Z1INdHJpZ2dlckNvbmZpZxI+CgVncmFwaBgGIAEoCzIoLmNyZWF0aXZhbnRhLmF1dG9tYXRpb2'
    '4udjEuV29ya2Zsb3dHcmFwaFIFZ3JhcGgSJQoObGljZW5zZV9ub3RpY2UYByABKAlSDWxpY2Vu'
    'c2VOb3RpY2USJwoPcGFyYW1ldGVyc19qc29uGAggASgJUg5wYXJhbWV0ZXJzSnNvbg==');

@$core.Deprecated('Use workflowServiceCreateRequestDescriptor instead')
const WorkflowServiceCreateRequest$json = {
  '1': 'WorkflowServiceCreateRequest',
  '2': [
    {'1': 'idempotency_key', '3': 1, '4': 1, '5': 9, '10': 'idempotencyKey'},
    {'1': 'workspace_id', '3': 2, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'title', '3': 3, '4': 1, '5': 9, '10': 'title'},
    {'1': 'description', '3': 4, '4': 1, '5': 9, '10': 'description'},
    {'1': 'workflow_type', '3': 5, '4': 1, '5': 9, '10': 'workflowType'},
    {
      '1': 'trigger_config',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.creativanta.automation.v1.TriggerConfig',
      '10': 'triggerConfig'
    },
    {
      '1': 'action_chain',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.creativanta.automation.v1.WorkflowGraph',
      '10': 'actionChain'
    },
    {
      '1': 'approval_requirements_json',
      '3': 8,
      '4': 1,
      '5': 9,
      '10': 'approvalRequirementsJson'
    },
  ],
};

/// Descriptor for `WorkflowServiceCreateRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List workflowServiceCreateRequestDescriptor = $convert.base64Decode(
    'ChxXb3JrZmxvd1NlcnZpY2VDcmVhdGVSZXF1ZXN0EicKD2lkZW1wb3RlbmN5X2tleRgBIAEoCV'
    'IOaWRlbXBvdGVuY3lLZXkSIQoMd29ya3NwYWNlX2lkGAIgASgJUgt3b3Jrc3BhY2VJZBIUCgV0'
    'aXRsZRgDIAEoCVIFdGl0bGUSIAoLZGVzY3JpcHRpb24YBCABKAlSC2Rlc2NyaXB0aW9uEiMKDX'
    'dvcmtmbG93X3R5cGUYBSABKAlSDHdvcmtmbG93VHlwZRJPCg50cmlnZ2VyX2NvbmZpZxgGIAEo'
    'CzIoLmNyZWF0aXZhbnRhLmF1dG9tYXRpb24udjEuVHJpZ2dlckNvbmZpZ1INdHJpZ2dlckNvbm'
    'ZpZxJLCgxhY3Rpb25fY2hhaW4YByABKAsyKC5jcmVhdGl2YW50YS5hdXRvbWF0aW9uLnYxLldv'
    'cmtmbG93R3JhcGhSC2FjdGlvbkNoYWluEjwKGmFwcHJvdmFsX3JlcXVpcmVtZW50c19qc29uGA'
    'ggASgJUhhhcHByb3ZhbFJlcXVpcmVtZW50c0pzb24=');

@$core.Deprecated('Use workflowServiceCreateResponseDescriptor instead')
const WorkflowServiceCreateResponse$json = {
  '1': 'WorkflowServiceCreateResponse',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'workspace_id', '3': 2, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'title', '3': 3, '4': 1, '5': 9, '10': 'title'},
    {'1': 'status', '3': 4, '4': 1, '5': 9, '10': 'status'},
    {'1': 'node_count', '3': 5, '4': 1, '5': 5, '10': 'nodeCount'},
    {'1': 'version', '3': 6, '4': 1, '5': 5, '10': 'version'},
    {
      '1': 'created_at',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'createdAt'
    },
    {
      '1': 'workflow',
      '3': 8,
      '4': 1,
      '5': 11,
      '6': '.creativanta.automation.v1.Workflow',
      '10': 'workflow'
    },
  ],
};

/// Descriptor for `WorkflowServiceCreateResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List workflowServiceCreateResponseDescriptor = $convert.base64Decode(
    'Ch1Xb3JrZmxvd1NlcnZpY2VDcmVhdGVSZXNwb25zZRIOCgJpZBgBIAEoCVICaWQSIQoMd29ya3'
    'NwYWNlX2lkGAIgASgJUgt3b3Jrc3BhY2VJZBIUCgV0aXRsZRgDIAEoCVIFdGl0bGUSFgoGc3Rh'
    'dHVzGAQgASgJUgZzdGF0dXMSHQoKbm9kZV9jb3VudBgFIAEoBVIJbm9kZUNvdW50EhgKB3Zlcn'
    'Npb24YBiABKAVSB3ZlcnNpb24SOQoKY3JlYXRlZF9hdBgHIAEoCzIaLmdvb2dsZS5wcm90b2J1'
    'Zi5UaW1lc3RhbXBSCWNyZWF0ZWRBdBI/Cgh3b3JrZmxvdxgIIAEoCzIjLmNyZWF0aXZhbnRhLm'
    'F1dG9tYXRpb24udjEuV29ya2Zsb3dSCHdvcmtmbG93');

@$core.Deprecated('Use workflowServiceGetRequestDescriptor instead')
const WorkflowServiceGetRequest$json = {
  '1': 'WorkflowServiceGetRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'workflow_id', '3': 2, '4': 1, '5': 9, '10': 'workflowId'},
  ],
};

/// Descriptor for `WorkflowServiceGetRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List workflowServiceGetRequestDescriptor =
    $convert.base64Decode(
        'ChlXb3JrZmxvd1NlcnZpY2VHZXRSZXF1ZXN0EiEKDHdvcmtzcGFjZV9pZBgBIAEoCVILd29ya3'
        'NwYWNlSWQSHwoLd29ya2Zsb3dfaWQYAiABKAlSCndvcmtmbG93SWQ=');

@$core.Deprecated('Use workflowServiceGetResponseDescriptor instead')
const WorkflowServiceGetResponse$json = {
  '1': 'WorkflowServiceGetResponse',
  '2': [
    {
      '1': 'workflow',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.automation.v1.Workflow',
      '10': 'workflow'
    },
  ],
};

/// Descriptor for `WorkflowServiceGetResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List workflowServiceGetResponseDescriptor =
    $convert.base64Decode(
        'ChpXb3JrZmxvd1NlcnZpY2VHZXRSZXNwb25zZRI/Cgh3b3JrZmxvdxgBIAEoCzIjLmNyZWF0aX'
        'ZhbnRhLmF1dG9tYXRpb24udjEuV29ya2Zsb3dSCHdvcmtmbG93');

@$core.Deprecated('Use workflowServiceListRequestDescriptor instead')
const WorkflowServiceListRequest$json = {
  '1': 'WorkflowServiceListRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'status', '3': 2, '4': 1, '5': 9, '10': 'status'},
    {'1': 'limit', '3': 3, '4': 1, '5': 5, '10': 'limit'},
    {'1': 'offset', '3': 4, '4': 1, '5': 5, '10': 'offset'},
  ],
};

/// Descriptor for `WorkflowServiceListRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List workflowServiceListRequestDescriptor =
    $convert.base64Decode(
        'ChpXb3JrZmxvd1NlcnZpY2VMaXN0UmVxdWVzdBIhCgx3b3Jrc3BhY2VfaWQYASABKAlSC3dvcm'
        'tzcGFjZUlkEhYKBnN0YXR1cxgCIAEoCVIGc3RhdHVzEhQKBWxpbWl0GAMgASgFUgVsaW1pdBIW'
        'CgZvZmZzZXQYBCABKAVSBm9mZnNldA==');

@$core.Deprecated('Use workflowServiceListResponseDescriptor instead')
const WorkflowServiceListResponse$json = {
  '1': 'WorkflowServiceListResponse',
  '2': [
    {
      '1': 'workflows',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.creativanta.automation.v1.WorkflowSummary',
      '10': 'workflows'
    },
    {'1': 'total_count', '3': 2, '4': 1, '5': 5, '10': 'totalCount'},
  ],
};

/// Descriptor for `WorkflowServiceListResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List workflowServiceListResponseDescriptor =
    $convert.base64Decode(
        'ChtXb3JrZmxvd1NlcnZpY2VMaXN0UmVzcG9uc2USSAoJd29ya2Zsb3dzGAEgAygLMiouY3JlYX'
        'RpdmFudGEuYXV0b21hdGlvbi52MS5Xb3JrZmxvd1N1bW1hcnlSCXdvcmtmbG93cxIfCgt0b3Rh'
        'bF9jb3VudBgCIAEoBVIKdG90YWxDb3VudA==');

@$core.Deprecated('Use workflowServiceUpdateRequestDescriptor instead')
const WorkflowServiceUpdateRequest$json = {
  '1': 'WorkflowServiceUpdateRequest',
  '2': [
    {'1': 'idempotency_key', '3': 1, '4': 1, '5': 9, '10': 'idempotencyKey'},
    {'1': 'workspace_id', '3': 2, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'workflow_id', '3': 3, '4': 1, '5': 9, '10': 'workflowId'},
    {'1': 'title', '3': 4, '4': 1, '5': 9, '10': 'title'},
    {'1': 'description', '3': 5, '4': 1, '5': 9, '10': 'description'},
    {
      '1': 'trigger_config',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.creativanta.automation.v1.TriggerConfig',
      '10': 'triggerConfig'
    },
    {
      '1': 'action_chain',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.creativanta.automation.v1.WorkflowGraph',
      '10': 'actionChain'
    },
    {
      '1': 'approval_requirements_json',
      '3': 8,
      '4': 1,
      '5': 9,
      '10': 'approvalRequirementsJson'
    },
    {'1': 'expected_version', '3': 9, '4': 1, '5': 5, '10': 'expectedVersion'},
  ],
};

/// Descriptor for `WorkflowServiceUpdateRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List workflowServiceUpdateRequestDescriptor = $convert.base64Decode(
    'ChxXb3JrZmxvd1NlcnZpY2VVcGRhdGVSZXF1ZXN0EicKD2lkZW1wb3RlbmN5X2tleRgBIAEoCV'
    'IOaWRlbXBvdGVuY3lLZXkSIQoMd29ya3NwYWNlX2lkGAIgASgJUgt3b3Jrc3BhY2VJZBIfCgt3'
    'b3JrZmxvd19pZBgDIAEoCVIKd29ya2Zsb3dJZBIUCgV0aXRsZRgEIAEoCVIFdGl0bGUSIAoLZG'
    'VzY3JpcHRpb24YBSABKAlSC2Rlc2NyaXB0aW9uEk8KDnRyaWdnZXJfY29uZmlnGAYgASgLMigu'
    'Y3JlYXRpdmFudGEuYXV0b21hdGlvbi52MS5UcmlnZ2VyQ29uZmlnUg10cmlnZ2VyQ29uZmlnEk'
    'sKDGFjdGlvbl9jaGFpbhgHIAEoCzIoLmNyZWF0aXZhbnRhLmF1dG9tYXRpb24udjEuV29ya2Zs'
    'b3dHcmFwaFILYWN0aW9uQ2hhaW4SPAoaYXBwcm92YWxfcmVxdWlyZW1lbnRzX2pzb24YCCABKA'
    'lSGGFwcHJvdmFsUmVxdWlyZW1lbnRzSnNvbhIpChBleHBlY3RlZF92ZXJzaW9uGAkgASgFUg9l'
    'eHBlY3RlZFZlcnNpb24=');

@$core.Deprecated('Use workflowServiceUpdateResponseDescriptor instead')
const WorkflowServiceUpdateResponse$json = {
  '1': 'WorkflowServiceUpdateResponse',
  '2': [
    {
      '1': 'workflow',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.automation.v1.Workflow',
      '10': 'workflow'
    },
  ],
};

/// Descriptor for `WorkflowServiceUpdateResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List workflowServiceUpdateResponseDescriptor =
    $convert.base64Decode(
        'Ch1Xb3JrZmxvd1NlcnZpY2VVcGRhdGVSZXNwb25zZRI/Cgh3b3JrZmxvdxgBIAEoCzIjLmNyZW'
        'F0aXZhbnRhLmF1dG9tYXRpb24udjEuV29ya2Zsb3dSCHdvcmtmbG93');

@$core.Deprecated('Use workflowServiceActivateRequestDescriptor instead')
const WorkflowServiceActivateRequest$json = {
  '1': 'WorkflowServiceActivateRequest',
  '2': [
    {'1': 'idempotency_key', '3': 1, '4': 1, '5': 9, '10': 'idempotencyKey'},
    {'1': 'workspace_id', '3': 2, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'workflow_id', '3': 3, '4': 1, '5': 9, '10': 'workflowId'},
  ],
};

/// Descriptor for `WorkflowServiceActivateRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List workflowServiceActivateRequestDescriptor =
    $convert.base64Decode(
        'Ch5Xb3JrZmxvd1NlcnZpY2VBY3RpdmF0ZVJlcXVlc3QSJwoPaWRlbXBvdGVuY3lfa2V5GAEgAS'
        'gJUg5pZGVtcG90ZW5jeUtleRIhCgx3b3Jrc3BhY2VfaWQYAiABKAlSC3dvcmtzcGFjZUlkEh8K'
        'C3dvcmtmbG93X2lkGAMgASgJUgp3b3JrZmxvd0lk');

@$core.Deprecated('Use workflowServiceActivateResponseDescriptor instead')
const WorkflowServiceActivateResponse$json = {
  '1': 'WorkflowServiceActivateResponse',
  '2': [
    {
      '1': 'workflow',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.automation.v1.Workflow',
      '10': 'workflow'
    },
  ],
};

/// Descriptor for `WorkflowServiceActivateResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List workflowServiceActivateResponseDescriptor =
    $convert.base64Decode(
        'Ch9Xb3JrZmxvd1NlcnZpY2VBY3RpdmF0ZVJlc3BvbnNlEj8KCHdvcmtmbG93GAEgASgLMiMuY3'
        'JlYXRpdmFudGEuYXV0b21hdGlvbi52MS5Xb3JrZmxvd1IId29ya2Zsb3c=');

@$core.Deprecated('Use workflowServiceDeactivateRequestDescriptor instead')
const WorkflowServiceDeactivateRequest$json = {
  '1': 'WorkflowServiceDeactivateRequest',
  '2': [
    {'1': 'idempotency_key', '3': 1, '4': 1, '5': 9, '10': 'idempotencyKey'},
    {'1': 'workspace_id', '3': 2, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'workflow_id', '3': 3, '4': 1, '5': 9, '10': 'workflowId'},
  ],
};

/// Descriptor for `WorkflowServiceDeactivateRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List workflowServiceDeactivateRequestDescriptor =
    $convert.base64Decode(
        'CiBXb3JrZmxvd1NlcnZpY2VEZWFjdGl2YXRlUmVxdWVzdBInCg9pZGVtcG90ZW5jeV9rZXkYAS'
        'ABKAlSDmlkZW1wb3RlbmN5S2V5EiEKDHdvcmtzcGFjZV9pZBgCIAEoCVILd29ya3NwYWNlSWQS'
        'HwoLd29ya2Zsb3dfaWQYAyABKAlSCndvcmtmbG93SWQ=');

@$core.Deprecated('Use workflowServiceDeactivateResponseDescriptor instead')
const WorkflowServiceDeactivateResponse$json = {
  '1': 'WorkflowServiceDeactivateResponse',
  '2': [
    {
      '1': 'workflow',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.automation.v1.Workflow',
      '10': 'workflow'
    },
  ],
};

/// Descriptor for `WorkflowServiceDeactivateResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List workflowServiceDeactivateResponseDescriptor =
    $convert.base64Decode(
        'CiFXb3JrZmxvd1NlcnZpY2VEZWFjdGl2YXRlUmVzcG9uc2USPwoId29ya2Zsb3cYASABKAsyIy'
        '5jcmVhdGl2YW50YS5hdXRvbWF0aW9uLnYxLldvcmtmbG93Ugh3b3JrZmxvdw==');

@$core.Deprecated('Use workflowServiceRunRequestDescriptor instead')
const WorkflowServiceRunRequest$json = {
  '1': 'WorkflowServiceRunRequest',
  '2': [
    {'1': 'idempotency_key', '3': 1, '4': 1, '5': 9, '10': 'idempotencyKey'},
    {'1': 'workspace_id', '3': 2, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'workflow_id', '3': 3, '4': 1, '5': 9, '10': 'workflowId'},
    {
      '1': 'trigger_context_json',
      '3': 4,
      '4': 1,
      '5': 9,
      '10': 'triggerContextJson'
    },
  ],
};

/// Descriptor for `WorkflowServiceRunRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List workflowServiceRunRequestDescriptor = $convert.base64Decode(
    'ChlXb3JrZmxvd1NlcnZpY2VSdW5SZXF1ZXN0EicKD2lkZW1wb3RlbmN5X2tleRgBIAEoCVIOaW'
    'RlbXBvdGVuY3lLZXkSIQoMd29ya3NwYWNlX2lkGAIgASgJUgt3b3Jrc3BhY2VJZBIfCgt3b3Jr'
    'Zmxvd19pZBgDIAEoCVIKd29ya2Zsb3dJZBIwChR0cmlnZ2VyX2NvbnRleHRfanNvbhgEIAEoCV'
    'ISdHJpZ2dlckNvbnRleHRKc29u');

@$core.Deprecated('Use workflowServiceRunResponseDescriptor instead')
const WorkflowServiceRunResponse$json = {
  '1': 'WorkflowServiceRunResponse',
  '2': [
    {'1': 'run_id', '3': 1, '4': 1, '5': 9, '10': 'runId'},
    {'1': 'workflow_id', '3': 2, '4': 1, '5': 9, '10': 'workflowId'},
    {'1': 'status', '3': 3, '4': 1, '5': 9, '10': 'status'},
    {'1': 'current_node', '3': 4, '4': 1, '5': 9, '10': 'currentNode'},
    {
      '1': 'created_at',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'createdAt'
    },
    {
      '1': 'run',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.creativanta.automation.v1.WorkflowRun',
      '10': 'run'
    },
  ],
};

/// Descriptor for `WorkflowServiceRunResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List workflowServiceRunResponseDescriptor = $convert.base64Decode(
    'ChpXb3JrZmxvd1NlcnZpY2VSdW5SZXNwb25zZRIVCgZydW5faWQYASABKAlSBXJ1bklkEh8KC3'
    'dvcmtmbG93X2lkGAIgASgJUgp3b3JrZmxvd0lkEhYKBnN0YXR1cxgDIAEoCVIGc3RhdHVzEiEK'
    'DGN1cnJlbnRfbm9kZRgEIAEoCVILY3VycmVudE5vZGUSOQoKY3JlYXRlZF9hdBgFIAEoCzIaLm'
    'dvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSCWNyZWF0ZWRBdBI4CgNydW4YBiABKAsyJi5jcmVh'
    'dGl2YW50YS5hdXRvbWF0aW9uLnYxLldvcmtmbG93UnVuUgNydW4=');

@$core.Deprecated('Use workflowServiceGetRunDetailRequestDescriptor instead')
const WorkflowServiceGetRunDetailRequest$json = {
  '1': 'WorkflowServiceGetRunDetailRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'run_id', '3': 2, '4': 1, '5': 9, '10': 'runId'},
  ],
};

/// Descriptor for `WorkflowServiceGetRunDetailRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List workflowServiceGetRunDetailRequestDescriptor =
    $convert.base64Decode(
        'CiJXb3JrZmxvd1NlcnZpY2VHZXRSdW5EZXRhaWxSZXF1ZXN0EiEKDHdvcmtzcGFjZV9pZBgBIA'
        'EoCVILd29ya3NwYWNlSWQSFQoGcnVuX2lkGAIgASgJUgVydW5JZA==');

@$core.Deprecated('Use workflowServiceGetRunDetailResponseDescriptor instead')
const WorkflowServiceGetRunDetailResponse$json = {
  '1': 'WorkflowServiceGetRunDetailResponse',
  '2': [
    {
      '1': 'run',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.automation.v1.WorkflowRun',
      '10': 'run'
    },
    {
      '1': 'steps',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.creativanta.automation.v1.WorkflowRunStep',
      '10': 'steps'
    },
  ],
};

/// Descriptor for `WorkflowServiceGetRunDetailResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List workflowServiceGetRunDetailResponseDescriptor =
    $convert.base64Decode(
        'CiNXb3JrZmxvd1NlcnZpY2VHZXRSdW5EZXRhaWxSZXNwb25zZRI4CgNydW4YASABKAsyJi5jcm'
        'VhdGl2YW50YS5hdXRvbWF0aW9uLnYxLldvcmtmbG93UnVuUgNydW4SQAoFc3RlcHMYAiADKAsy'
        'Ki5jcmVhdGl2YW50YS5hdXRvbWF0aW9uLnYxLldvcmtmbG93UnVuU3RlcFIFc3RlcHM=');

@$core.Deprecated('Use workflowServiceGetRunLogsRequestDescriptor instead')
const WorkflowServiceGetRunLogsRequest$json = {
  '1': 'WorkflowServiceGetRunLogsRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'run_id', '3': 2, '4': 1, '5': 9, '10': 'runId'},
  ],
};

/// Descriptor for `WorkflowServiceGetRunLogsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List workflowServiceGetRunLogsRequestDescriptor =
    $convert.base64Decode(
        'CiBXb3JrZmxvd1NlcnZpY2VHZXRSdW5Mb2dzUmVxdWVzdBIhCgx3b3Jrc3BhY2VfaWQYASABKA'
        'lSC3dvcmtzcGFjZUlkEhUKBnJ1bl9pZBgCIAEoCVIFcnVuSWQ=');

@$core.Deprecated('Use workflowServiceGetRunLogsResponseDescriptor instead')
const WorkflowServiceGetRunLogsResponse$json = {
  '1': 'WorkflowServiceGetRunLogsResponse',
  '2': [
    {
      '1': 'execution_log_json',
      '3': 1,
      '4': 1,
      '5': 9,
      '10': 'executionLogJson'
    },
    {
      '1': 'steps',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.creativanta.automation.v1.WorkflowRunStep',
      '10': 'steps'
    },
  ],
};

/// Descriptor for `WorkflowServiceGetRunLogsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List workflowServiceGetRunLogsResponseDescriptor =
    $convert.base64Decode(
        'CiFXb3JrZmxvd1NlcnZpY2VHZXRSdW5Mb2dzUmVzcG9uc2USLAoSZXhlY3V0aW9uX2xvZ19qc2'
        '9uGAEgASgJUhBleGVjdXRpb25Mb2dKc29uEkAKBXN0ZXBzGAIgAygLMiouY3JlYXRpdmFudGEu'
        'YXV0b21hdGlvbi52MS5Xb3JrZmxvd1J1blN0ZXBSBXN0ZXBz');

@$core.Deprecated('Use workflowServiceListRunsRequestDescriptor instead')
const WorkflowServiceListRunsRequest$json = {
  '1': 'WorkflowServiceListRunsRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'workflow_id', '3': 2, '4': 1, '5': 9, '10': 'workflowId'},
    {'1': 'status', '3': 3, '4': 1, '5': 9, '10': 'status'},
    {'1': 'limit', '3': 4, '4': 1, '5': 5, '10': 'limit'},
    {'1': 'offset', '3': 5, '4': 1, '5': 5, '10': 'offset'},
  ],
};

/// Descriptor for `WorkflowServiceListRunsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List workflowServiceListRunsRequestDescriptor =
    $convert.base64Decode(
        'Ch5Xb3JrZmxvd1NlcnZpY2VMaXN0UnVuc1JlcXVlc3QSIQoMd29ya3NwYWNlX2lkGAEgASgJUg'
        't3b3Jrc3BhY2VJZBIfCgt3b3JrZmxvd19pZBgCIAEoCVIKd29ya2Zsb3dJZBIWCgZzdGF0dXMY'
        'AyABKAlSBnN0YXR1cxIUCgVsaW1pdBgEIAEoBVIFbGltaXQSFgoGb2Zmc2V0GAUgASgFUgZvZm'
        'ZzZXQ=');

@$core.Deprecated('Use workflowServiceListRunsResponseDescriptor instead')
const WorkflowServiceListRunsResponse$json = {
  '1': 'WorkflowServiceListRunsResponse',
  '2': [
    {
      '1': 'runs',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.creativanta.automation.v1.WorkflowRun',
      '10': 'runs'
    },
    {'1': 'total_count', '3': 2, '4': 1, '5': 5, '10': 'totalCount'},
  ],
};

/// Descriptor for `WorkflowServiceListRunsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List workflowServiceListRunsResponseDescriptor =
    $convert.base64Decode(
        'Ch9Xb3JrZmxvd1NlcnZpY2VMaXN0UnVuc1Jlc3BvbnNlEjoKBHJ1bnMYASADKAsyJi5jcmVhdG'
        'l2YW50YS5hdXRvbWF0aW9uLnYxLldvcmtmbG93UnVuUgRydW5zEh8KC3RvdGFsX2NvdW50GAIg'
        'ASgFUgp0b3RhbENvdW50');

@$core.Deprecated('Use workflowServiceCloneRequestDescriptor instead')
const WorkflowServiceCloneRequest$json = {
  '1': 'WorkflowServiceCloneRequest',
  '2': [
    {'1': 'idempotency_key', '3': 1, '4': 1, '5': 9, '10': 'idempotencyKey'},
    {'1': 'workspace_id', '3': 2, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'workflow_id', '3': 3, '4': 1, '5': 9, '10': 'workflowId'},
    {'1': 'new_title', '3': 4, '4': 1, '5': 9, '10': 'newTitle'},
  ],
};

/// Descriptor for `WorkflowServiceCloneRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List workflowServiceCloneRequestDescriptor = $convert.base64Decode(
    'ChtXb3JrZmxvd1NlcnZpY2VDbG9uZVJlcXVlc3QSJwoPaWRlbXBvdGVuY3lfa2V5GAEgASgJUg'
    '5pZGVtcG90ZW5jeUtleRIhCgx3b3Jrc3BhY2VfaWQYAiABKAlSC3dvcmtzcGFjZUlkEh8KC3dv'
    'cmtmbG93X2lkGAMgASgJUgp3b3JrZmxvd0lkEhsKCW5ld190aXRsZRgEIAEoCVIIbmV3VGl0bG'
    'U=');

@$core.Deprecated('Use workflowServiceCloneResponseDescriptor instead')
const WorkflowServiceCloneResponse$json = {
  '1': 'WorkflowServiceCloneResponse',
  '2': [
    {
      '1': 'workflow',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.automation.v1.Workflow',
      '10': 'workflow'
    },
  ],
};

/// Descriptor for `WorkflowServiceCloneResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List workflowServiceCloneResponseDescriptor =
    $convert.base64Decode(
        'ChxXb3JrZmxvd1NlcnZpY2VDbG9uZVJlc3BvbnNlEj8KCHdvcmtmbG93GAEgASgLMiMuY3JlYX'
        'RpdmFudGEuYXV0b21hdGlvbi52MS5Xb3JrZmxvd1IId29ya2Zsb3c=');

@$core.Deprecated('Use workflowServiceExportRequestDescriptor instead')
const WorkflowServiceExportRequest$json = {
  '1': 'WorkflowServiceExportRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'workflow_id', '3': 2, '4': 1, '5': 9, '10': 'workflowId'},
  ],
};

/// Descriptor for `WorkflowServiceExportRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List workflowServiceExportRequestDescriptor =
    $convert.base64Decode(
        'ChxXb3JrZmxvd1NlcnZpY2VFeHBvcnRSZXF1ZXN0EiEKDHdvcmtzcGFjZV9pZBgBIAEoCVILd2'
        '9ya3NwYWNlSWQSHwoLd29ya2Zsb3dfaWQYAiABKAlSCndvcmtmbG93SWQ=');

@$core.Deprecated('Use workflowServiceExportResponseDescriptor instead')
const WorkflowServiceExportResponse$json = {
  '1': 'WorkflowServiceExportResponse',
  '2': [
    {
      '1': 'payload',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.automation.v1.PortableWorkflowPayload',
      '10': 'payload'
    },
    {'1': 'payload_json', '3': 2, '4': 1, '5': 9, '10': 'payloadJson'},
  ],
};

/// Descriptor for `WorkflowServiceExportResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List workflowServiceExportResponseDescriptor =
    $convert.base64Decode(
        'Ch1Xb3JrZmxvd1NlcnZpY2VFeHBvcnRSZXNwb25zZRJMCgdwYXlsb2FkGAEgASgLMjIuY3JlYX'
        'RpdmFudGEuYXV0b21hdGlvbi52MS5Qb3J0YWJsZVdvcmtmbG93UGF5bG9hZFIHcGF5bG9hZBIh'
        'CgxwYXlsb2FkX2pzb24YAiABKAlSC3BheWxvYWRKc29u');

@$core.Deprecated('Use workflowServiceImportRequestDescriptor instead')
const WorkflowServiceImportRequest$json = {
  '1': 'WorkflowServiceImportRequest',
  '2': [
    {'1': 'idempotency_key', '3': 1, '4': 1, '5': 9, '10': 'idempotencyKey'},
    {'1': 'workspace_id', '3': 2, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'payload_json', '3': 3, '4': 1, '5': 9, '10': 'payloadJson'},
    {
      '1': 'payload',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.creativanta.automation.v1.PortableWorkflowPayload',
      '10': 'payload'
    },
  ],
};

/// Descriptor for `WorkflowServiceImportRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List workflowServiceImportRequestDescriptor = $convert.base64Decode(
    'ChxXb3JrZmxvd1NlcnZpY2VJbXBvcnRSZXF1ZXN0EicKD2lkZW1wb3RlbmN5X2tleRgBIAEoCV'
    'IOaWRlbXBvdGVuY3lLZXkSIQoMd29ya3NwYWNlX2lkGAIgASgJUgt3b3Jrc3BhY2VJZBIhCgxw'
    'YXlsb2FkX2pzb24YAyABKAlSC3BheWxvYWRKc29uEkwKB3BheWxvYWQYBCABKAsyMi5jcmVhdG'
    'l2YW50YS5hdXRvbWF0aW9uLnYxLlBvcnRhYmxlV29ya2Zsb3dQYXlsb2FkUgdwYXlsb2Fk');

@$core.Deprecated('Use workflowServiceImportResponseDescriptor instead')
const WorkflowServiceImportResponse$json = {
  '1': 'WorkflowServiceImportResponse',
  '2': [
    {
      '1': 'workflow',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.automation.v1.Workflow',
      '10': 'workflow'
    },
  ],
};

/// Descriptor for `WorkflowServiceImportResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List workflowServiceImportResponseDescriptor =
    $convert.base64Decode(
        'Ch1Xb3JrZmxvd1NlcnZpY2VJbXBvcnRSZXNwb25zZRI/Cgh3b3JrZmxvdxgBIAEoCzIjLmNyZW'
        'F0aXZhbnRhLmF1dG9tYXRpb24udjEuV29ya2Zsb3dSCHdvcmtmbG93');

@$core.Deprecated('Use workflowServiceTestRequestDescriptor instead')
const WorkflowServiceTestRequest$json = {
  '1': 'WorkflowServiceTestRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'workflow_id', '3': 2, '4': 1, '5': 9, '10': 'workflowId'},
    {
      '1': 'draft_graph',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.creativanta.automation.v1.WorkflowGraph',
      '10': 'draftGraph'
    },
    {
      '1': 'sample_context_json',
      '3': 4,
      '4': 1,
      '5': 9,
      '10': 'sampleContextJson'
    },
  ],
};

/// Descriptor for `WorkflowServiceTestRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List workflowServiceTestRequestDescriptor = $convert.base64Decode(
    'ChpXb3JrZmxvd1NlcnZpY2VUZXN0UmVxdWVzdBIhCgx3b3Jrc3BhY2VfaWQYASABKAlSC3dvcm'
    'tzcGFjZUlkEh8KC3dvcmtmbG93X2lkGAIgASgJUgp3b3JrZmxvd0lkEkkKC2RyYWZ0X2dyYXBo'
    'GAMgASgLMiguY3JlYXRpdmFudGEuYXV0b21hdGlvbi52MS5Xb3JrZmxvd0dyYXBoUgpkcmFmdE'
    'dyYXBoEi4KE3NhbXBsZV9jb250ZXh0X2pzb24YBCABKAlSEXNhbXBsZUNvbnRleHRKc29u');

@$core.Deprecated('Use workflowServiceTestStepResultDescriptor instead')
const WorkflowServiceTestStepResult$json = {
  '1': 'WorkflowServiceTestStepResult',
  '2': [
    {'1': 'node_id', '3': 1, '4': 1, '5': 9, '10': 'nodeId'},
    {
      '1': 'node_type',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.creativanta.automation.v1.NodeType',
      '10': 'nodeType'
    },
    {'1': 'status', '3': 3, '4': 1, '5': 9, '10': 'status'},
    {
      '1': 'simulated_output_json',
      '3': 4,
      '4': 1,
      '5': 9,
      '10': 'simulatedOutputJson'
    },
    {
      '1': 'diagnostic_message',
      '3': 5,
      '4': 1,
      '5': 9,
      '10': 'diagnosticMessage'
    },
    {
      '1': 'estimated_credits',
      '3': 6,
      '4': 1,
      '5': 1,
      '10': 'estimatedCredits'
    },
  ],
};

/// Descriptor for `WorkflowServiceTestStepResult`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List workflowServiceTestStepResultDescriptor = $convert.base64Decode(
    'Ch1Xb3JrZmxvd1NlcnZpY2VUZXN0U3RlcFJlc3VsdBIXCgdub2RlX2lkGAEgASgJUgZub2RlSW'
    'QSQAoJbm9kZV90eXBlGAIgASgOMiMuY3JlYXRpdmFudGEuYXV0b21hdGlvbi52MS5Ob2RlVHlw'
    'ZVIIbm9kZVR5cGUSFgoGc3RhdHVzGAMgASgJUgZzdGF0dXMSMgoVc2ltdWxhdGVkX291dHB1dF'
    '9qc29uGAQgASgJUhNzaW11bGF0ZWRPdXRwdXRKc29uEi0KEmRpYWdub3N0aWNfbWVzc2FnZRgF'
    'IAEoCVIRZGlhZ25vc3RpY01lc3NhZ2USKwoRZXN0aW1hdGVkX2NyZWRpdHMYBiABKAFSEGVzdG'
    'ltYXRlZENyZWRpdHM=');

@$core.Deprecated('Use workflowServiceTestResponseDescriptor instead')
const WorkflowServiceTestResponse$json = {
  '1': 'WorkflowServiceTestResponse',
  '2': [
    {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
    {
      '1': 'step_results',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.creativanta.automation.v1.WorkflowServiceTestStepResult',
      '10': 'stepResults'
    },
    {
      '1': 'total_estimated_credits',
      '3': 3,
      '4': 1,
      '5': 1,
      '10': 'totalEstimatedCredits'
    },
    {
      '1': 'simulation_summary',
      '3': 4,
      '4': 1,
      '5': 9,
      '10': 'simulationSummary'
    },
  ],
};

/// Descriptor for `WorkflowServiceTestResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List workflowServiceTestResponseDescriptor = $convert.base64Decode(
    'ChtXb3JrZmxvd1NlcnZpY2VUZXN0UmVzcG9uc2USGAoHc3VjY2VzcxgBIAEoCFIHc3VjY2Vzcx'
    'JbCgxzdGVwX3Jlc3VsdHMYAiADKAsyOC5jcmVhdGl2YW50YS5hdXRvbWF0aW9uLnYxLldvcmtm'
    'bG93U2VydmljZVRlc3RTdGVwUmVzdWx0UgtzdGVwUmVzdWx0cxI2Chd0b3RhbF9lc3RpbWF0ZW'
    'RfY3JlZGl0cxgDIAEoAVIVdG90YWxFc3RpbWF0ZWRDcmVkaXRzEi0KEnNpbXVsYXRpb25fc3Vt'
    'bWFyeRgEIAEoCVIRc2ltdWxhdGlvblN1bW1hcnk=');

@$core.Deprecated('Use workflowServiceGetRunStatsRequestDescriptor instead')
const WorkflowServiceGetRunStatsRequest$json = {
  '1': 'WorkflowServiceGetRunStatsRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'workflow_id', '3': 2, '4': 1, '5': 9, '10': 'workflowId'},
  ],
};

/// Descriptor for `WorkflowServiceGetRunStatsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List workflowServiceGetRunStatsRequestDescriptor =
    $convert.base64Decode(
        'CiFXb3JrZmxvd1NlcnZpY2VHZXRSdW5TdGF0c1JlcXVlc3QSIQoMd29ya3NwYWNlX2lkGAEgAS'
        'gJUgt3b3Jrc3BhY2VJZBIfCgt3b3JrZmxvd19pZBgCIAEoCVIKd29ya2Zsb3dJZA==');

@$core.Deprecated('Use workflowServiceGetRunStatsResponseDescriptor instead')
const WorkflowServiceGetRunStatsResponse$json = {
  '1': 'WorkflowServiceGetRunStatsResponse',
  '2': [
    {'1': 'total_runs', '3': 1, '4': 1, '5': 5, '10': 'totalRuns'},
    {'1': 'successful_runs', '3': 2, '4': 1, '5': 5, '10': 'successfulRuns'},
    {'1': 'failed_runs', '3': 3, '4': 1, '5': 5, '10': 'failedRuns'},
    {
      '1': 'pending_approvals',
      '3': 4,
      '4': 1,
      '5': 5,
      '10': 'pendingApprovals'
    },
    {
      '1': 'avg_duration_seconds',
      '3': 5,
      '4': 1,
      '5': 1,
      '10': 'avgDurationSeconds'
    },
  ],
};

/// Descriptor for `WorkflowServiceGetRunStatsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List workflowServiceGetRunStatsResponseDescriptor =
    $convert.base64Decode(
        'CiJXb3JrZmxvd1NlcnZpY2VHZXRSdW5TdGF0c1Jlc3BvbnNlEh0KCnRvdGFsX3J1bnMYASABKA'
        'VSCXRvdGFsUnVucxInCg9zdWNjZXNzZnVsX3J1bnMYAiABKAVSDnN1Y2Nlc3NmdWxSdW5zEh8K'
        'C2ZhaWxlZF9ydW5zGAMgASgFUgpmYWlsZWRSdW5zEisKEXBlbmRpbmdfYXBwcm92YWxzGAQgAS'
        'gFUhBwZW5kaW5nQXBwcm92YWxzEjAKFGF2Z19kdXJhdGlvbl9zZWNvbmRzGAUgASgBUhJhdmdE'
        'dXJhdGlvblNlY29uZHM=');

@$core.Deprecated('Use workflowServiceCancelRunRequestDescriptor instead')
const WorkflowServiceCancelRunRequest$json = {
  '1': 'WorkflowServiceCancelRunRequest',
  '2': [
    {'1': 'idempotency_key', '3': 1, '4': 1, '5': 9, '10': 'idempotencyKey'},
    {'1': 'workspace_id', '3': 2, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'run_id', '3': 3, '4': 1, '5': 9, '10': 'runId'},
    {'1': 'reason', '3': 4, '4': 1, '5': 9, '10': 'reason'},
  ],
};

/// Descriptor for `WorkflowServiceCancelRunRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List workflowServiceCancelRunRequestDescriptor =
    $convert.base64Decode(
        'Ch9Xb3JrZmxvd1NlcnZpY2VDYW5jZWxSdW5SZXF1ZXN0EicKD2lkZW1wb3RlbmN5X2tleRgBIA'
        'EoCVIOaWRlbXBvdGVuY3lLZXkSIQoMd29ya3NwYWNlX2lkGAIgASgJUgt3b3Jrc3BhY2VJZBIV'
        'CgZydW5faWQYAyABKAlSBXJ1bklkEhYKBnJlYXNvbhgEIAEoCVIGcmVhc29u');

@$core.Deprecated('Use workflowServiceCancelRunResponseDescriptor instead')
const WorkflowServiceCancelRunResponse$json = {
  '1': 'WorkflowServiceCancelRunResponse',
  '2': [
    {
      '1': 'run',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.automation.v1.WorkflowRun',
      '10': 'run'
    },
  ],
};

/// Descriptor for `WorkflowServiceCancelRunResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List workflowServiceCancelRunResponseDescriptor =
    $convert.base64Decode(
        'CiBXb3JrZmxvd1NlcnZpY2VDYW5jZWxSdW5SZXNwb25zZRI4CgNydW4YASABKAsyJi5jcmVhdG'
        'l2YW50YS5hdXRvbWF0aW9uLnYxLldvcmtmbG93UnVuUgNydW4=');

@$core.Deprecated('Use workflowServiceRetryRunRequestDescriptor instead')
const WorkflowServiceRetryRunRequest$json = {
  '1': 'WorkflowServiceRetryRunRequest',
  '2': [
    {'1': 'idempotency_key', '3': 1, '4': 1, '5': 9, '10': 'idempotencyKey'},
    {'1': 'workspace_id', '3': 2, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'run_id', '3': 3, '4': 1, '5': 9, '10': 'runId'},
    {
      '1': 'repair_context_json',
      '3': 4,
      '4': 1,
      '5': 9,
      '10': 'repairContextJson'
    },
  ],
};

/// Descriptor for `WorkflowServiceRetryRunRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List workflowServiceRetryRunRequestDescriptor =
    $convert.base64Decode(
        'Ch5Xb3JrZmxvd1NlcnZpY2VSZXRyeVJ1blJlcXVlc3QSJwoPaWRlbXBvdGVuY3lfa2V5GAEgAS'
        'gJUg5pZGVtcG90ZW5jeUtleRIhCgx3b3Jrc3BhY2VfaWQYAiABKAlSC3dvcmtzcGFjZUlkEhUK'
        'BnJ1bl9pZBgDIAEoCVIFcnVuSWQSLgoTcmVwYWlyX2NvbnRleHRfanNvbhgEIAEoCVIRcmVwYW'
        'lyQ29udGV4dEpzb24=');

@$core.Deprecated('Use workflowServiceRetryRunResponseDescriptor instead')
const WorkflowServiceRetryRunResponse$json = {
  '1': 'WorkflowServiceRetryRunResponse',
  '2': [
    {
      '1': 'run',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.automation.v1.WorkflowRun',
      '10': 'run'
    },
  ],
};

/// Descriptor for `WorkflowServiceRetryRunResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List workflowServiceRetryRunResponseDescriptor =
    $convert.base64Decode(
        'Ch9Xb3JrZmxvd1NlcnZpY2VSZXRyeVJ1blJlc3BvbnNlEjgKA3J1bhgBIAEoCzImLmNyZWF0aX'
        'ZhbnRhLmF1dG9tYXRpb24udjEuV29ya2Zsb3dSdW5SA3J1bg==');

@$core.Deprecated('Use workflowServiceDismissRunRequestDescriptor instead')
const WorkflowServiceDismissRunRequest$json = {
  '1': 'WorkflowServiceDismissRunRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'run_id', '3': 2, '4': 1, '5': 9, '10': 'runId'},
    {'1': 'dismissal_reason', '3': 3, '4': 1, '5': 9, '10': 'dismissalReason'},
  ],
};

/// Descriptor for `WorkflowServiceDismissRunRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List workflowServiceDismissRunRequestDescriptor =
    $convert.base64Decode(
        'CiBXb3JrZmxvd1NlcnZpY2VEaXNtaXNzUnVuUmVxdWVzdBIhCgx3b3Jrc3BhY2VfaWQYASABKA'
        'lSC3dvcmtzcGFjZUlkEhUKBnJ1bl9pZBgCIAEoCVIFcnVuSWQSKQoQZGlzbWlzc2FsX3JlYXNv'
        'bhgDIAEoCVIPZGlzbWlzc2FsUmVhc29u');

@$core.Deprecated('Use workflowServiceDismissRunResponseDescriptor instead')
const WorkflowServiceDismissRunResponse$json = {
  '1': 'WorkflowServiceDismissRunResponse',
  '2': [
    {'1': 'dismissed', '3': 1, '4': 1, '5': 8, '10': 'dismissed'},
  ],
};

/// Descriptor for `WorkflowServiceDismissRunResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List workflowServiceDismissRunResponseDescriptor =
    $convert.base64Decode(
        'CiFXb3JrZmxvd1NlcnZpY2VEaXNtaXNzUnVuUmVzcG9uc2USHAoJZGlzbWlzc2VkGAEgASgIUg'
        'lkaXNtaXNzZWQ=');

@$core.Deprecated('Use workflowServiceSkipStepRequestDescriptor instead')
const WorkflowServiceSkipStepRequest$json = {
  '1': 'WorkflowServiceSkipStepRequest',
  '2': [
    {'1': 'idempotency_key', '3': 1, '4': 1, '5': 9, '10': 'idempotencyKey'},
    {'1': 'workspace_id', '3': 2, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'run_id', '3': 3, '4': 1, '5': 9, '10': 'runId'},
    {'1': 'node_id', '3': 4, '4': 1, '5': 9, '10': 'nodeId'},
    {'1': 'reason', '3': 5, '4': 1, '5': 9, '10': 'reason'},
  ],
};

/// Descriptor for `WorkflowServiceSkipStepRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List workflowServiceSkipStepRequestDescriptor =
    $convert.base64Decode(
        'Ch5Xb3JrZmxvd1NlcnZpY2VTa2lwU3RlcFJlcXVlc3QSJwoPaWRlbXBvdGVuY3lfa2V5GAEgAS'
        'gJUg5pZGVtcG90ZW5jeUtleRIhCgx3b3Jrc3BhY2VfaWQYAiABKAlSC3dvcmtzcGFjZUlkEhUK'
        'BnJ1bl9pZBgDIAEoCVIFcnVuSWQSFwoHbm9kZV9pZBgEIAEoCVIGbm9kZUlkEhYKBnJlYXNvbh'
        'gFIAEoCVIGcmVhc29u');

@$core.Deprecated('Use workflowServiceSkipStepResponseDescriptor instead')
const WorkflowServiceSkipStepResponse$json = {
  '1': 'WorkflowServiceSkipStepResponse',
  '2': [
    {
      '1': 'step',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.automation.v1.WorkflowRunStep',
      '10': 'step'
    },
  ],
};

/// Descriptor for `WorkflowServiceSkipStepResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List workflowServiceSkipStepResponseDescriptor =
    $convert.base64Decode(
        'Ch9Xb3JrZmxvd1NlcnZpY2VTa2lwU3RlcFJlc3BvbnNlEj4KBHN0ZXAYASABKAsyKi5jcmVhdG'
        'l2YW50YS5hdXRvbWF0aW9uLnYxLldvcmtmbG93UnVuU3RlcFIEc3RlcA==');

@$core.Deprecated('Use workflowServiceProvideInputRequestDescriptor instead')
const WorkflowServiceProvideInputRequest$json = {
  '1': 'WorkflowServiceProvideInputRequest',
  '2': [
    {'1': 'idempotency_key', '3': 1, '4': 1, '5': 9, '10': 'idempotencyKey'},
    {'1': 'workspace_id', '3': 2, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'run_id', '3': 3, '4': 1, '5': 9, '10': 'runId'},
    {'1': 'node_id', '3': 4, '4': 1, '5': 9, '10': 'nodeId'},
    {'1': 'input_json', '3': 5, '4': 1, '5': 9, '10': 'inputJson'},
  ],
};

/// Descriptor for `WorkflowServiceProvideInputRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List workflowServiceProvideInputRequestDescriptor =
    $convert.base64Decode(
        'CiJXb3JrZmxvd1NlcnZpY2VQcm92aWRlSW5wdXRSZXF1ZXN0EicKD2lkZW1wb3RlbmN5X2tleR'
        'gBIAEoCVIOaWRlbXBvdGVuY3lLZXkSIQoMd29ya3NwYWNlX2lkGAIgASgJUgt3b3Jrc3BhY2VJ'
        'ZBIVCgZydW5faWQYAyABKAlSBXJ1bklkEhcKB25vZGVfaWQYBCABKAlSBm5vZGVJZBIdCgppbn'
        'B1dF9qc29uGAUgASgJUglpbnB1dEpzb24=');

@$core.Deprecated('Use workflowServiceProvideInputResponseDescriptor instead')
const WorkflowServiceProvideInputResponse$json = {
  '1': 'WorkflowServiceProvideInputResponse',
  '2': [
    {
      '1': 'step',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.automation.v1.WorkflowRunStep',
      '10': 'step'
    },
  ],
};

/// Descriptor for `WorkflowServiceProvideInputResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List workflowServiceProvideInputResponseDescriptor =
    $convert.base64Decode(
        'CiNXb3JrZmxvd1NlcnZpY2VQcm92aWRlSW5wdXRSZXNwb25zZRI+CgRzdGVwGAEgASgLMiouY3'
        'JlYXRpdmFudGEuYXV0b21hdGlvbi52MS5Xb3JrZmxvd1J1blN0ZXBSBHN0ZXA=');

@$core.Deprecated('Use workflowServiceExportRunsRequestDescriptor instead')
const WorkflowServiceExportRunsRequest$json = {
  '1': 'WorkflowServiceExportRunsRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'workflow_id', '3': 2, '4': 1, '5': 9, '10': 'workflowId'},
    {'1': 'format', '3': 3, '4': 1, '5': 9, '10': 'format'},
  ],
};

/// Descriptor for `WorkflowServiceExportRunsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List workflowServiceExportRunsRequestDescriptor =
    $convert.base64Decode(
        'CiBXb3JrZmxvd1NlcnZpY2VFeHBvcnRSdW5zUmVxdWVzdBIhCgx3b3Jrc3BhY2VfaWQYASABKA'
        'lSC3dvcmtzcGFjZUlkEh8KC3dvcmtmbG93X2lkGAIgASgJUgp3b3JrZmxvd0lkEhYKBmZvcm1h'
        'dBgDIAEoCVIGZm9ybWF0');

@$core.Deprecated('Use workflowServiceExportRunsResponseDescriptor instead')
const WorkflowServiceExportRunsResponse$json = {
  '1': 'WorkflowServiceExportRunsResponse',
  '2': [
    {'1': 'file_url', '3': 1, '4': 1, '5': 9, '10': 'fileUrl'},
    {'1': 'content', '3': 2, '4': 1, '5': 9, '10': 'content'},
  ],
};

/// Descriptor for `WorkflowServiceExportRunsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List workflowServiceExportRunsResponseDescriptor =
    $convert.base64Decode(
        'CiFXb3JrZmxvd1NlcnZpY2VFeHBvcnRSdW5zUmVzcG9uc2USGQoIZmlsZV91cmwYASABKAlSB2'
        'ZpbGVVcmwSGAoHY29udGVudBgCIAEoCVIHY29udGVudA==');

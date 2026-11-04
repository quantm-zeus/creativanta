// This is a generated file - do not edit.
//
// Generated from creativanta/automation/v1/agent.proto.

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

@$core.Deprecated('Use agentRunStateDescriptor instead')
const AgentRunState$json = {
  '1': 'AgentRunState',
  '2': [
    {'1': 'AGENT_RUN_STATE_UNSPECIFIED', '2': 0},
    {'1': 'AGENT_RUN_STATE_PLANNING', '2': 1},
    {'1': 'AGENT_RUN_STATE_AWAITING_APPROVAL', '2': 2},
    {'1': 'AGENT_RUN_STATE_EXECUTING', '2': 3},
    {'1': 'AGENT_RUN_STATE_WAITING_CONTEXT', '2': 4},
    {'1': 'AGENT_RUN_STATE_COMPLETED', '2': 5},
    {'1': 'AGENT_RUN_STATE_PARTIALLY_COMPLETED', '2': 6},
    {'1': 'AGENT_RUN_STATE_FAILED', '2': 7},
    {'1': 'AGENT_RUN_STATE_HANDED_OFF', '2': 8},
    {'1': 'AGENT_RUN_STATE_CANCELLED', '2': 9},
  ],
};

/// Descriptor for `AgentRunState`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List agentRunStateDescriptor = $convert.base64Decode(
    'Cg1BZ2VudFJ1blN0YXRlEh8KG0FHRU5UX1JVTl9TVEFURV9VTlNQRUNJRklFRBAAEhwKGEFHRU'
    '5UX1JVTl9TVEFURV9QTEFOTklORxABEiUKIUFHRU5UX1JVTl9TVEFURV9BV0FJVElOR19BUFBS'
    'T1ZBTBACEh0KGUFHRU5UX1JVTl9TVEFURV9FWEVDVVRJTkcQAxIjCh9BR0VOVF9SVU5fU1RBVE'
    'VfV0FJVElOR19DT05URVhUEAQSHQoZQUdFTlRfUlVOX1NUQVRFX0NPTVBMRVRFRBAFEicKI0FH'
    'RU5UX1JVTl9TVEFURV9QQVJUSUFMTFlfQ09NUExFVEVEEAYSGgoWQUdFTlRfUlVOX1NUQVRFX0'
    'ZBSUxFRBAHEh4KGkFHRU5UX1JVTl9TVEFURV9IQU5ERURfT0ZGEAgSHQoZQUdFTlRfUlVOX1NU'
    'QVRFX0NBTkNFTExFRBAJ');

@$core.Deprecated('Use agentApprovalStateDescriptor instead')
const AgentApprovalState$json = {
  '1': 'AgentApprovalState',
  '2': [
    {'1': 'AGENT_APPROVAL_STATE_UNSPECIFIED', '2': 0},
    {'1': 'AGENT_APPROVAL_STATE_NOT_REQUIRED', '2': 1},
    {'1': 'AGENT_APPROVAL_STATE_AWAITING_APPROVAL', '2': 2},
    {'1': 'AGENT_APPROVAL_STATE_APPROVED', '2': 3},
    {'1': 'AGENT_APPROVAL_STATE_REJECTED', '2': 4},
  ],
};

/// Descriptor for `AgentApprovalState`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List agentApprovalStateDescriptor = $convert.base64Decode(
    'ChJBZ2VudEFwcHJvdmFsU3RhdGUSJAogQUdFTlRfQVBQUk9WQUxfU1RBVEVfVU5TUEVDSUZJRU'
    'QQABIlCiFBR0VOVF9BUFBST1ZBTF9TVEFURV9OT1RfUkVRVUlSRUQQARIqCiZBR0VOVF9BUFBS'
    'T1ZBTF9TVEFURV9BV0FJVElOR19BUFBST1ZBTBACEiEKHUFHRU5UX0FQUFJPVkFMX1NUQVRFX0'
    'FQUFJPVkVEEAMSIQodQUdFTlRfQVBQUk9WQUxfU1RBVEVfUkVKRUNURUQQBA==');

@$core.Deprecated('Use agentStepStatusDescriptor instead')
const AgentStepStatus$json = {
  '1': 'AgentStepStatus',
  '2': [
    {'1': 'AGENT_STEP_STATUS_UNSPECIFIED', '2': 0},
    {'1': 'AGENT_STEP_STATUS_PLANNING', '2': 1},
    {'1': 'AGENT_STEP_STATUS_AWAITING_APPROVAL', '2': 2},
    {'1': 'AGENT_STEP_STATUS_EXECUTING', '2': 3},
    {'1': 'AGENT_STEP_STATUS_WAITING_CONTEXT', '2': 4},
    {'1': 'AGENT_STEP_STATUS_COMPLETED', '2': 5},
    {'1': 'AGENT_STEP_STATUS_FAILED', '2': 6},
    {'1': 'AGENT_STEP_STATUS_SKIPPED', '2': 7},
    {'1': 'AGENT_STEP_STATUS_CANCELLED', '2': 8},
  ],
};

/// Descriptor for `AgentStepStatus`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List agentStepStatusDescriptor = $convert.base64Decode(
    'Cg9BZ2VudFN0ZXBTdGF0dXMSIQodQUdFTlRfU1RFUF9TVEFUVVNfVU5TUEVDSUZJRUQQABIeCh'
    'pBR0VOVF9TVEVQX1NUQVRVU19QTEFOTklORxABEicKI0FHRU5UX1NURVBfU1RBVFVTX0FXQUlU'
    'SU5HX0FQUFJPVkFMEAISHwobQUdFTlRfU1RFUF9TVEFUVVNfRVhFQ1VUSU5HEAMSJQohQUdFTl'
    'RfU1RFUF9TVEFUVVNfV0FJVElOR19DT05URVhUEAQSHwobQUdFTlRfU1RFUF9TVEFUVVNfQ09N'
    'UExFVEVEEAUSHAoYQUdFTlRfU1RFUF9TVEFUVVNfRkFJTEVEEAYSHQoZQUdFTlRfU1RFUF9TVE'
    'FUVVNfU0tJUFBFRBAHEh8KG0FHRU5UX1NURVBfU1RBVFVTX0NBTkNFTExFRBAI');

@$core.Deprecated('Use agentOutputTypeDescriptor instead')
const AgentOutputType$json = {
  '1': 'AgentOutputType',
  '2': [
    {'1': 'AGENT_OUTPUT_TYPE_UNSPECIFIED', '2': 0},
    {'1': 'AGENT_OUTPUT_TYPE_TEXT', '2': 1},
    {'1': 'AGENT_OUTPUT_TYPE_ASSET', '2': 2},
    {'1': 'AGENT_OUTPUT_TYPE_DATASET', '2': 3},
    {'1': 'AGENT_OUTPUT_TYPE_WORKFLOW_PATCH', '2': 4},
    {'1': 'AGENT_OUTPUT_TYPE_RECOMMENDATION', '2': 5},
    {'1': 'AGENT_OUTPUT_TYPE_REPORT', '2': 6},
    {'1': 'AGENT_OUTPUT_TYPE_VIDEO', '2': 7},
  ],
};

/// Descriptor for `AgentOutputType`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List agentOutputTypeDescriptor = $convert.base64Decode(
    'Cg9BZ2VudE91dHB1dFR5cGUSIQodQUdFTlRfT1VUUFVUX1RZUEVfVU5TUEVDSUZJRUQQABIaCh'
    'ZBR0VOVF9PVVRQVVRfVFlQRV9URVhUEAESGwoXQUdFTlRfT1VUUFVUX1RZUEVfQVNTRVQQAhId'
    'ChlBR0VOVF9PVVRQVVRfVFlQRV9EQVRBU0VUEAMSJAogQUdFTlRfT1VUUFVUX1RZUEVfV09SS0'
    'ZMT1dfUEFUQ0gQBBIkCiBBR0VOVF9PVVRQVVRfVFlQRV9SRUNPTU1FTkRBVElPThAFEhwKGEFH'
    'RU5UX09VVFBVVF9UWVBFX1JFUE9SVBAGEhsKF0FHRU5UX09VVFBVVF9UWVBFX1ZJREVPEAc=');

@$core.Deprecated('Use agentTypeDescriptor instead')
const AgentType$json = {
  '1': 'AgentType',
  '2': [
    {'1': 'AGENT_TYPE_UNSPECIFIED', '2': 0},
    {'1': 'AGENT_TYPE_GENERIC', '2': 1},
    {'1': 'AGENT_TYPE_VIDEO_AGENT', '2': 2},
    {'1': 'AGENT_TYPE_COPILOT_ACTION', '2': 3},
    {'1': 'AGENT_TYPE_CONTENT_OPTIMIZER', '2': 4},
  ],
};

/// Descriptor for `AgentType`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List agentTypeDescriptor = $convert.base64Decode(
    'CglBZ2VudFR5cGUSGgoWQUdFTlRfVFlQRV9VTlNQRUNJRklFRBAAEhYKEkFHRU5UX1RZUEVfR0'
    'VORVJJQxABEhoKFkFHRU5UX1RZUEVfVklERU9fQUdFTlQQAhIdChlBR0VOVF9UWVBFX0NPUElM'
    'T1RfQUNUSU9OEAMSIAocQUdFTlRfVFlQRV9DT05URU5UX09QVElNSVpFUhAE');

@$core.Deprecated('Use agentStepDescriptor instead')
const AgentStep$json = {
  '1': 'AgentStep',
  '2': [
    {'1': 'step_id', '3': 1, '4': 1, '5': 9, '10': 'stepId'},
    {'1': 'agent_run_id', '3': 2, '4': 1, '5': 9, '10': 'agentRunId'},
    {'1': 'step_order', '3': 3, '4': 1, '5': 5, '10': 'stepOrder'},
    {'1': 'phase', '3': 4, '4': 1, '5': 9, '10': 'phase'},
    {'1': 'title', '3': 5, '4': 1, '5': 9, '10': 'title'},
    {
      '1': 'status',
      '3': 6,
      '4': 1,
      '5': 14,
      '6': '.creativanta.automation.v1.AgentStepStatus',
      '10': 'status'
    },
    {'1': 'expected_outcome', '3': 7, '4': 1, '5': 9, '10': 'expectedOutcome'},
    {'1': 'observed_outcome', '3': 8, '4': 1, '5': 9, '10': 'observedOutcome'},
    {
      '1': 'required_permission',
      '3': 9,
      '4': 1,
      '5': 9,
      '10': 'requiredPermission'
    },
    {
      '1': 'required_capability',
      '3': 10,
      '4': 1,
      '5': 9,
      '10': 'requiredCapability'
    },
    {'1': 'is_high_risk', '3': 11, '4': 1, '5': 8, '10': 'isHighRisk'},
    {
      '1': 'estimated_credits',
      '3': 12,
      '4': 1,
      '5': 9,
      '10': 'estimatedCredits'
    },
    {'1': 'actual_credits', '3': 13, '4': 1, '5': 9, '10': 'actualCredits'},
    {
      '1': 'input_context_json',
      '3': 14,
      '4': 1,
      '5': 9,
      '10': 'inputContextJson'
    },
    {
      '1': 'output_context_json',
      '3': 15,
      '4': 1,
      '5': 9,
      '10': 'outputContextJson'
    },
    {'1': 'diagnostics_ref', '3': 16, '4': 1, '5': 9, '10': 'diagnosticsRef'},
    {
      '1': 'started_at',
      '3': 17,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'startedAt'
    },
    {
      '1': 'completed_at',
      '3': 18,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'completedAt'
    },
  ],
};

/// Descriptor for `AgentStep`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List agentStepDescriptor = $convert.base64Decode(
    'CglBZ2VudFN0ZXASFwoHc3RlcF9pZBgBIAEoCVIGc3RlcElkEiAKDGFnZW50X3J1bl9pZBgCIA'
    'EoCVIKYWdlbnRSdW5JZBIdCgpzdGVwX29yZGVyGAMgASgFUglzdGVwT3JkZXISFAoFcGhhc2UY'
    'BCABKAlSBXBoYXNlEhQKBXRpdGxlGAUgASgJUgV0aXRsZRJCCgZzdGF0dXMYBiABKA4yKi5jcm'
    'VhdGl2YW50YS5hdXRvbWF0aW9uLnYxLkFnZW50U3RlcFN0YXR1c1IGc3RhdHVzEikKEGV4cGVj'
    'dGVkX291dGNvbWUYByABKAlSD2V4cGVjdGVkT3V0Y29tZRIpChBvYnNlcnZlZF9vdXRjb21lGA'
    'ggASgJUg9vYnNlcnZlZE91dGNvbWUSLwoTcmVxdWlyZWRfcGVybWlzc2lvbhgJIAEoCVIScmVx'
    'dWlyZWRQZXJtaXNzaW9uEi8KE3JlcXVpcmVkX2NhcGFiaWxpdHkYCiABKAlSEnJlcXVpcmVkQ2'
    'FwYWJpbGl0eRIgCgxpc19oaWdoX3Jpc2sYCyABKAhSCmlzSGlnaFJpc2sSKwoRZXN0aW1hdGVk'
    'X2NyZWRpdHMYDCABKAlSEGVzdGltYXRlZENyZWRpdHMSJQoOYWN0dWFsX2NyZWRpdHMYDSABKA'
    'lSDWFjdHVhbENyZWRpdHMSLAoSaW5wdXRfY29udGV4dF9qc29uGA4gASgJUhBpbnB1dENvbnRl'
    'eHRKc29uEi4KE291dHB1dF9jb250ZXh0X2pzb24YDyABKAlSEW91dHB1dENvbnRleHRKc29uEi'
    'cKD2RpYWdub3N0aWNzX3JlZhgQIAEoCVIOZGlhZ25vc3RpY3NSZWYSOQoKc3RhcnRlZF9hdBgR'
    'IAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSCXN0YXJ0ZWRBdBI9Cgxjb21wbGV0ZW'
    'RfYXQYEiABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUgtjb21wbGV0ZWRBdA==');

@$core.Deprecated('Use agentOutputDescriptor instead')
const AgentOutput$json = {
  '1': 'AgentOutput',
  '2': [
    {'1': 'output_id', '3': 1, '4': 1, '5': 9, '10': 'outputId'},
    {'1': 'agent_run_id', '3': 2, '4': 1, '5': 9, '10': 'agentRunId'},
    {
      '1': 'output_type',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.creativanta.automation.v1.AgentOutputType',
      '10': 'outputType'
    },
    {'1': 'title', '3': 4, '4': 1, '5': 9, '10': 'title'},
    {'1': 'summary', '3': 5, '4': 1, '5': 9, '10': 'summary'},
    {'1': 'object_refs_json', '3': 6, '4': 1, '5': 9, '10': 'objectRefsJson'},
    {
      '1': 'downloadable_refs_json',
      '3': 7,
      '4': 1,
      '5': 9,
      '10': 'downloadableRefsJson'
    },
    {
      '1': 'preview_payload_json',
      '3': 8,
      '4': 1,
      '5': 9,
      '10': 'previewPayloadJson'
    },
    {'1': 'approval_state', '3': 9, '4': 1, '5': 9, '10': 'approvalState'},
    {
      '1': 'created_at',
      '3': 10,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'createdAt'
    },
  ],
};

/// Descriptor for `AgentOutput`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List agentOutputDescriptor = $convert.base64Decode(
    'CgtBZ2VudE91dHB1dBIbCglvdXRwdXRfaWQYASABKAlSCG91dHB1dElkEiAKDGFnZW50X3J1bl'
    '9pZBgCIAEoCVIKYWdlbnRSdW5JZBJLCgtvdXRwdXRfdHlwZRgDIAEoDjIqLmNyZWF0aXZhbnRh'
    'LmF1dG9tYXRpb24udjEuQWdlbnRPdXRwdXRUeXBlUgpvdXRwdXRUeXBlEhQKBXRpdGxlGAQgAS'
    'gJUgV0aXRsZRIYCgdzdW1tYXJ5GAUgASgJUgdzdW1tYXJ5EigKEG9iamVjdF9yZWZzX2pzb24Y'
    'BiABKAlSDm9iamVjdFJlZnNKc29uEjQKFmRvd25sb2FkYWJsZV9yZWZzX2pzb24YByABKAlSFG'
    'Rvd25sb2FkYWJsZVJlZnNKc29uEjAKFHByZXZpZXdfcGF5bG9hZF9qc29uGAggASgJUhJwcmV2'
    'aWV3UGF5bG9hZEpzb24SJQoOYXBwcm92YWxfc3RhdGUYCSABKAlSDWFwcHJvdmFsU3RhdGUSOQ'
    'oKY3JlYXRlZF9hdBgKIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSCWNyZWF0ZWRB'
    'dA==');

@$core.Deprecated('Use agentMemoryEntryDescriptor instead')
const AgentMemoryEntry$json = {
  '1': 'AgentMemoryEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {'1': 'value', '3': 2, '4': 1, '5': 9, '10': 'value'},
    {'1': 'byte_size', '3': 3, '4': 1, '5': 5, '10': 'byteSize'},
    {
      '1': 'observed_at',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'observedAt'
    },
  ],
};

/// Descriptor for `AgentMemoryEntry`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List agentMemoryEntryDescriptor = $convert.base64Decode(
    'ChBBZ2VudE1lbW9yeUVudHJ5EhAKA2tleRgBIAEoCVIDa2V5EhQKBXZhbHVlGAIgASgJUgV2YW'
    'x1ZRIbCglieXRlX3NpemUYAyABKAVSCGJ5dGVTaXplEjsKC29ic2VydmVkX2F0GAQgASgLMhou'
    'Z29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIKb2JzZXJ2ZWRBdA==');

@$core.Deprecated('Use agentMemoryDescriptor instead')
const AgentMemory$json = {
  '1': 'AgentMemory',
  '2': [
    {'1': 'total_bytes', '3': 1, '4': 1, '5': 3, '10': 'totalBytes'},
    {'1': 'max_bytes', '3': 2, '4': 1, '5': 3, '10': 'maxBytes'},
    {'1': 'is_compressed', '3': 3, '4': 1, '5': 8, '10': 'isCompressed'},
    {
      '1': 'entries',
      '3': 4,
      '4': 3,
      '5': 11,
      '6': '.creativanta.automation.v1.AgentMemoryEntry',
      '10': 'entries'
    },
    {'1': 'summary', '3': 5, '4': 1, '5': 9, '10': 'summary'},
  ],
};

/// Descriptor for `AgentMemory`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List agentMemoryDescriptor = $convert.base64Decode(
    'CgtBZ2VudE1lbW9yeRIfCgt0b3RhbF9ieXRlcxgBIAEoA1IKdG90YWxCeXRlcxIbCgltYXhfYn'
    'l0ZXMYAiABKANSCG1heEJ5dGVzEiMKDWlzX2NvbXByZXNzZWQYAyABKAhSDGlzQ29tcHJlc3Nl'
    'ZBJFCgdlbnRyaWVzGAQgAygLMisuY3JlYXRpdmFudGEuYXV0b21hdGlvbi52MS5BZ2VudE1lbW'
    '9yeUVudHJ5UgdlbnRyaWVzEhgKB3N1bW1hcnkYBSABKAlSB3N1bW1hcnk=');

@$core.Deprecated('Use agentHandoffContextDescriptor instead')
const AgentHandoffContext$json = {
  '1': 'AgentHandoffContext',
  '2': [
    {
      '1': 'handoff_target_user_id',
      '3': 1,
      '4': 1,
      '5': 9,
      '10': 'handoffTargetUserId'
    },
    {'1': 'reason', '3': 2, '4': 1, '5': 9, '10': 'reason'},
    {
      '1': 'summary_of_completed_work',
      '3': 3,
      '4': 1,
      '5': 9,
      '10': 'summaryOfCompletedWork'
    },
    {
      '1': 'unresolved_actions',
      '3': 4,
      '4': 3,
      '5': 9,
      '10': 'unresolvedActions'
    },
    {'1': 'diagnostics_ref', '3': 5, '4': 1, '5': 9, '10': 'diagnosticsRef'},
    {'1': 'audit_ref', '3': 6, '4': 1, '5': 9, '10': 'auditRef'},
  ],
};

/// Descriptor for `AgentHandoffContext`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List agentHandoffContextDescriptor = $convert.base64Decode(
    'ChNBZ2VudEhhbmRvZmZDb250ZXh0EjMKFmhhbmRvZmZfdGFyZ2V0X3VzZXJfaWQYASABKAlSE2'
    'hhbmRvZmZUYXJnZXRVc2VySWQSFgoGcmVhc29uGAIgASgJUgZyZWFzb24SOQoZc3VtbWFyeV9v'
    'Zl9jb21wbGV0ZWRfd29yaxgDIAEoCVIWc3VtbWFyeU9mQ29tcGxldGVkV29yaxItChJ1bnJlc2'
    '9sdmVkX2FjdGlvbnMYBCADKAlSEXVucmVzb2x2ZWRBY3Rpb25zEicKD2RpYWdub3N0aWNzX3Jl'
    'ZhgFIAEoCVIOZGlhZ25vc3RpY3NSZWYSGwoJYXVkaXRfcmVmGAYgASgJUghhdWRpdFJlZg==');

@$core.Deprecated('Use agentRunDescriptor instead')
const AgentRun$json = {
  '1': 'AgentRun',
  '2': [
    {'1': 'agent_run_id', '3': 1, '4': 1, '5': 9, '10': 'agentRunId'},
    {'1': 'workspace_id', '3': 2, '4': 1, '5': 9, '10': 'workspaceId'},
    {
      '1': 'agent_type',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.creativanta.automation.v1.AgentType',
      '10': 'agentType'
    },
    {'1': 'recipe_id', '3': 4, '4': 1, '5': 9, '10': 'recipeId'},
    {'1': 'workflow_id', '3': 5, '4': 1, '5': 9, '10': 'workflowId'},
    {'1': 'plan_summary', '3': 6, '4': 1, '5': 9, '10': 'planSummary'},
    {
      '1': 'execution_scope_json',
      '3': 7,
      '4': 1,
      '5': 9,
      '10': 'executionScopeJson'
    },
    {
      '1': 'approval_state',
      '3': 8,
      '4': 1,
      '5': 14,
      '6': '.creativanta.automation.v1.AgentApprovalState',
      '10': 'approvalState'
    },
    {
      '1': 'current_state',
      '3': 9,
      '4': 1,
      '5': 14,
      '6': '.creativanta.automation.v1.AgentRunState',
      '10': 'currentState'
    },
    {
      '1': 'side_effects_summary_json',
      '3': 10,
      '4': 1,
      '5': 9,
      '10': 'sideEffectsSummaryJson'
    },
    {
      '1': 'handoff_context',
      '3': 11,
      '4': 1,
      '5': 11,
      '6': '.creativanta.automation.v1.AgentHandoffContext',
      '10': 'handoffContext'
    },
    {'1': 'diagnostics_ref', '3': 12, '4': 1, '5': 9, '10': 'diagnosticsRef'},
    {'1': 'audit_ref', '3': 13, '4': 1, '5': 9, '10': 'auditRef'},
    {'1': 'credits_used', '3': 14, '4': 1, '5': 9, '10': 'creditsUsed'},
    {'1': 'budget_ceiling', '3': 15, '4': 1, '5': 9, '10': 'budgetCeiling'},
    {
      '1': 'memory',
      '3': 16,
      '4': 1,
      '5': 11,
      '6': '.creativanta.automation.v1.AgentMemory',
      '10': 'memory'
    },
    {
      '1': 'steps',
      '3': 17,
      '4': 3,
      '5': 11,
      '6': '.creativanta.automation.v1.AgentStep',
      '10': 'steps'
    },
    {
      '1': 'outputs',
      '3': 18,
      '4': 3,
      '5': 11,
      '6': '.creativanta.automation.v1.AgentOutput',
      '10': 'outputs'
    },
    {'1': 'created_by', '3': 19, '4': 1, '5': 9, '10': 'createdBy'},
    {
      '1': 'started_at',
      '3': 20,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'startedAt'
    },
    {
      '1': 'completed_at',
      '3': 21,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'completedAt'
    },
    {
      '1': 'created_at',
      '3': 22,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'createdAt'
    },
    {
      '1': 'updated_at',
      '3': 23,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'updatedAt'
    },
  ],
};

/// Descriptor for `AgentRun`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List agentRunDescriptor = $convert.base64Decode(
    'CghBZ2VudFJ1bhIgCgxhZ2VudF9ydW5faWQYASABKAlSCmFnZW50UnVuSWQSIQoMd29ya3NwYW'
    'NlX2lkGAIgASgJUgt3b3Jrc3BhY2VJZBJDCgphZ2VudF90eXBlGAMgASgOMiQuY3JlYXRpdmFu'
    'dGEuYXV0b21hdGlvbi52MS5BZ2VudFR5cGVSCWFnZW50VHlwZRIbCglyZWNpcGVfaWQYBCABKA'
    'lSCHJlY2lwZUlkEh8KC3dvcmtmbG93X2lkGAUgASgJUgp3b3JrZmxvd0lkEiEKDHBsYW5fc3Vt'
    'bWFyeRgGIAEoCVILcGxhblN1bW1hcnkSMAoUZXhlY3V0aW9uX3Njb3BlX2pzb24YByABKAlSEm'
    'V4ZWN1dGlvblNjb3BlSnNvbhJUCg5hcHByb3ZhbF9zdGF0ZRgIIAEoDjItLmNyZWF0aXZhbnRh'
    'LmF1dG9tYXRpb24udjEuQWdlbnRBcHByb3ZhbFN0YXRlUg1hcHByb3ZhbFN0YXRlEk0KDWN1cn'
    'JlbnRfc3RhdGUYCSABKA4yKC5jcmVhdGl2YW50YS5hdXRvbWF0aW9uLnYxLkFnZW50UnVuU3Rh'
    'dGVSDGN1cnJlbnRTdGF0ZRI5ChlzaWRlX2VmZmVjdHNfc3VtbWFyeV9qc29uGAogASgJUhZzaW'
    'RlRWZmZWN0c1N1bW1hcnlKc29uElcKD2hhbmRvZmZfY29udGV4dBgLIAEoCzIuLmNyZWF0aXZh'
    'bnRhLmF1dG9tYXRpb24udjEuQWdlbnRIYW5kb2ZmQ29udGV4dFIOaGFuZG9mZkNvbnRleHQSJw'
    'oPZGlhZ25vc3RpY3NfcmVmGAwgASgJUg5kaWFnbm9zdGljc1JlZhIbCglhdWRpdF9yZWYYDSAB'
    'KAlSCGF1ZGl0UmVmEiEKDGNyZWRpdHNfdXNlZBgOIAEoCVILY3JlZGl0c1VzZWQSJQoOYnVkZ2'
    'V0X2NlaWxpbmcYDyABKAlSDWJ1ZGdldENlaWxpbmcSPgoGbWVtb3J5GBAgASgLMiYuY3JlYXRp'
    'dmFudGEuYXV0b21hdGlvbi52MS5BZ2VudE1lbW9yeVIGbWVtb3J5EjoKBXN0ZXBzGBEgAygLMi'
    'QuY3JlYXRpdmFudGEuYXV0b21hdGlvbi52MS5BZ2VudFN0ZXBSBXN0ZXBzEkAKB291dHB1dHMY'
    'EiADKAsyJi5jcmVhdGl2YW50YS5hdXRvbWF0aW9uLnYxLkFnZW50T3V0cHV0UgdvdXRwdXRzEh'
    '0KCmNyZWF0ZWRfYnkYEyABKAlSCWNyZWF0ZWRCeRI5CgpzdGFydGVkX2F0GBQgASgLMhouZ29v'
    'Z2xlLnByb3RvYnVmLlRpbWVzdGFtcFIJc3RhcnRlZEF0Ej0KDGNvbXBsZXRlZF9hdBgVIAEoCz'
    'IaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSC2NvbXBsZXRlZEF0EjkKCmNyZWF0ZWRfYXQY'
    'FiABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUgljcmVhdGVkQXQSOQoKdXBkYXRlZF'
    '9hdBgXIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSCXVwZGF0ZWRBdA==');

@$core.Deprecated('Use agentServiceLaunchAgentRequestDescriptor instead')
const AgentServiceLaunchAgentRequest$json = {
  '1': 'AgentServiceLaunchAgentRequest',
  '2': [
    {'1': 'idempotency_key', '3': 1, '4': 1, '5': 9, '10': 'idempotencyKey'},
    {'1': 'workspace_id', '3': 2, '4': 1, '5': 9, '10': 'workspaceId'},
    {
      '1': 'agent_type',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.creativanta.automation.v1.AgentType',
      '10': 'agentType'
    },
    {'1': 'task_prompt', '3': 4, '4': 1, '5': 9, '10': 'taskPrompt'},
    {'1': 'recipe_id', '3': 5, '4': 1, '5': 9, '10': 'recipeId'},
    {'1': 'workflow_id', '3': 6, '4': 1, '5': 9, '10': 'workflowId'},
    {
      '1': 'budget_ceiling_credits',
      '3': 7,
      '4': 1,
      '5': 9,
      '10': 'budgetCeilingCredits'
    },
    {
      '1': 'execution_scope_json',
      '3': 8,
      '4': 1,
      '5': 9,
      '10': 'executionScopeJson'
    },
    {'1': 'auto_execute', '3': 9, '4': 1, '5': 8, '10': 'autoExecute'},
    {
      '1': 'parameters',
      '3': 10,
      '4': 3,
      '5': 11,
      '6':
          '.creativanta.automation.v1.AgentServiceLaunchAgentRequest.ParametersEntry',
      '10': 'parameters'
    },
  ],
  '3': [AgentServiceLaunchAgentRequest_ParametersEntry$json],
};

@$core.Deprecated('Use agentServiceLaunchAgentRequestDescriptor instead')
const AgentServiceLaunchAgentRequest_ParametersEntry$json = {
  '1': 'ParametersEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {'1': 'value', '3': 2, '4': 1, '5': 9, '10': 'value'},
  ],
  '7': {'7': true},
};

/// Descriptor for `AgentServiceLaunchAgentRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List agentServiceLaunchAgentRequestDescriptor = $convert.base64Decode(
    'Ch5BZ2VudFNlcnZpY2VMYXVuY2hBZ2VudFJlcXVlc3QSJwoPaWRlbXBvdGVuY3lfa2V5GAEgAS'
    'gJUg5pZGVtcG90ZW5jeUtleRIhCgx3b3Jrc3BhY2VfaWQYAiABKAlSC3dvcmtzcGFjZUlkEkMK'
    'CmFnZW50X3R5cGUYAyABKA4yJC5jcmVhdGl2YW50YS5hdXRvbWF0aW9uLnYxLkFnZW50VHlwZV'
    'IJYWdlbnRUeXBlEh8KC3Rhc2tfcHJvbXB0GAQgASgJUgp0YXNrUHJvbXB0EhsKCXJlY2lwZV9p'
    'ZBgFIAEoCVIIcmVjaXBlSWQSHwoLd29ya2Zsb3dfaWQYBiABKAlSCndvcmtmbG93SWQSNAoWYn'
    'VkZ2V0X2NlaWxpbmdfY3JlZGl0cxgHIAEoCVIUYnVkZ2V0Q2VpbGluZ0NyZWRpdHMSMAoUZXhl'
    'Y3V0aW9uX3Njb3BlX2pzb24YCCABKAlSEmV4ZWN1dGlvblNjb3BlSnNvbhIhCgxhdXRvX2V4ZW'
    'N1dGUYCSABKAhSC2F1dG9FeGVjdXRlEmkKCnBhcmFtZXRlcnMYCiADKAsySS5jcmVhdGl2YW50'
    'YS5hdXRvbWF0aW9uLnYxLkFnZW50U2VydmljZUxhdW5jaEFnZW50UmVxdWVzdC5QYXJhbWV0ZX'
    'JzRW50cnlSCnBhcmFtZXRlcnMaPQoPUGFyYW1ldGVyc0VudHJ5EhAKA2tleRgBIAEoCVIDa2V5'
    'EhQKBXZhbHVlGAIgASgJUgV2YWx1ZToCOAE=');

@$core.Deprecated('Use agentServiceLaunchAgentResponseDescriptor instead')
const AgentServiceLaunchAgentResponse$json = {
  '1': 'AgentServiceLaunchAgentResponse',
  '2': [
    {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
    {
      '1': 'run',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.creativanta.automation.v1.AgentRun',
      '10': 'run'
    },
    {
      '1': 'permission_warnings',
      '3': 3,
      '4': 3,
      '5': 9,
      '10': 'permissionWarnings'
    },
    {
      '1': 'requires_approval',
      '3': 4,
      '4': 1,
      '5': 8,
      '10': 'requiresApproval'
    },
    {'1': 'rejection_reason', '3': 5, '4': 1, '5': 9, '10': 'rejectionReason'},
  ],
};

/// Descriptor for `AgentServiceLaunchAgentResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List agentServiceLaunchAgentResponseDescriptor = $convert.base64Decode(
    'Ch9BZ2VudFNlcnZpY2VMYXVuY2hBZ2VudFJlc3BvbnNlEhgKB3N1Y2Nlc3MYASABKAhSB3N1Y2'
    'Nlc3MSNQoDcnVuGAIgASgLMiMuY3JlYXRpdmFudGEuYXV0b21hdGlvbi52MS5BZ2VudFJ1blID'
    'cnVuEi8KE3Blcm1pc3Npb25fd2FybmluZ3MYAyADKAlSEnBlcm1pc3Npb25XYXJuaW5ncxIrCh'
    'FyZXF1aXJlc19hcHByb3ZhbBgEIAEoCFIQcmVxdWlyZXNBcHByb3ZhbBIpChByZWplY3Rpb25f'
    'cmVhc29uGAUgASgJUg9yZWplY3Rpb25SZWFzb24=');

@$core.Deprecated('Use agentServiceListRunsRequestDescriptor instead')
const AgentServiceListRunsRequest$json = {
  '1': 'AgentServiceListRunsRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {
      '1': 'agent_type',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.creativanta.automation.v1.AgentType',
      '10': 'agentType'
    },
    {
      '1': 'state_filter',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.creativanta.automation.v1.AgentRunState',
      '10': 'stateFilter'
    },
    {'1': 'page_size', '3': 4, '4': 1, '5': 5, '10': 'pageSize'},
    {'1': 'page_token', '3': 5, '4': 1, '5': 9, '10': 'pageToken'},
  ],
};

/// Descriptor for `AgentServiceListRunsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List agentServiceListRunsRequestDescriptor = $convert.base64Decode(
    'ChtBZ2VudFNlcnZpY2VMaXN0UnVuc1JlcXVlc3QSIQoMd29ya3NwYWNlX2lkGAEgASgJUgt3b3'
    'Jrc3BhY2VJZBJDCgphZ2VudF90eXBlGAIgASgOMiQuY3JlYXRpdmFudGEuYXV0b21hdGlvbi52'
    'MS5BZ2VudFR5cGVSCWFnZW50VHlwZRJLCgxzdGF0ZV9maWx0ZXIYAyABKA4yKC5jcmVhdGl2YW'
    '50YS5hdXRvbWF0aW9uLnYxLkFnZW50UnVuU3RhdGVSC3N0YXRlRmlsdGVyEhsKCXBhZ2Vfc2l6'
    'ZRgEIAEoBVIIcGFnZVNpemUSHQoKcGFnZV90b2tlbhgFIAEoCVIJcGFnZVRva2Vu');

@$core.Deprecated('Use agentServiceListRunsResponseDescriptor instead')
const AgentServiceListRunsResponse$json = {
  '1': 'AgentServiceListRunsResponse',
  '2': [
    {
      '1': 'runs',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.creativanta.automation.v1.AgentRun',
      '10': 'runs'
    },
    {'1': 'next_page_token', '3': 2, '4': 1, '5': 9, '10': 'nextPageToken'},
    {'1': 'total_count', '3': 3, '4': 1, '5': 5, '10': 'totalCount'},
  ],
};

/// Descriptor for `AgentServiceListRunsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List agentServiceListRunsResponseDescriptor =
    $convert.base64Decode(
        'ChxBZ2VudFNlcnZpY2VMaXN0UnVuc1Jlc3BvbnNlEjcKBHJ1bnMYASADKAsyIy5jcmVhdGl2YW'
        '50YS5hdXRvbWF0aW9uLnYxLkFnZW50UnVuUgRydW5zEiYKD25leHRfcGFnZV90b2tlbhgCIAEo'
        'CVINbmV4dFBhZ2VUb2tlbhIfCgt0b3RhbF9jb3VudBgDIAEoBVIKdG90YWxDb3VudA==');

@$core.Deprecated('Use agentServiceCancelRunRequestDescriptor instead')
const AgentServiceCancelRunRequest$json = {
  '1': 'AgentServiceCancelRunRequest',
  '2': [
    {'1': 'idempotency_key', '3': 1, '4': 1, '5': 9, '10': 'idempotencyKey'},
    {'1': 'workspace_id', '3': 2, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'agent_run_id', '3': 3, '4': 1, '5': 9, '10': 'agentRunId'},
    {'1': 'reason', '3': 4, '4': 1, '5': 9, '10': 'reason'},
  ],
};

/// Descriptor for `AgentServiceCancelRunRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List agentServiceCancelRunRequestDescriptor = $convert.base64Decode(
    'ChxBZ2VudFNlcnZpY2VDYW5jZWxSdW5SZXF1ZXN0EicKD2lkZW1wb3RlbmN5X2tleRgBIAEoCV'
    'IOaWRlbXBvdGVuY3lLZXkSIQoMd29ya3NwYWNlX2lkGAIgASgJUgt3b3Jrc3BhY2VJZBIgCgxh'
    'Z2VudF9ydW5faWQYAyABKAlSCmFnZW50UnVuSWQSFgoGcmVhc29uGAQgASgJUgZyZWFzb24=');

@$core.Deprecated('Use agentServiceCancelRunResponseDescriptor instead')
const AgentServiceCancelRunResponse$json = {
  '1': 'AgentServiceCancelRunResponse',
  '2': [
    {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
    {
      '1': 'run',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.creativanta.automation.v1.AgentRun',
      '10': 'run'
    },
  ],
};

/// Descriptor for `AgentServiceCancelRunResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List agentServiceCancelRunResponseDescriptor =
    $convert.base64Decode(
        'Ch1BZ2VudFNlcnZpY2VDYW5jZWxSdW5SZXNwb25zZRIYCgdzdWNjZXNzGAEgASgIUgdzdWNjZX'
        'NzEjUKA3J1bhgCIAEoCzIjLmNyZWF0aXZhbnRhLmF1dG9tYXRpb24udjEuQWdlbnRSdW5SA3J1'
        'bg==');

@$core.Deprecated('Use agentServiceStreamRunRequestDescriptor instead')
const AgentServiceStreamRunRequest$json = {
  '1': 'AgentServiceStreamRunRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'agent_run_id', '3': 2, '4': 1, '5': 9, '10': 'agentRunId'},
  ],
};

/// Descriptor for `AgentServiceStreamRunRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List agentServiceStreamRunRequestDescriptor =
    $convert.base64Decode(
        'ChxBZ2VudFNlcnZpY2VTdHJlYW1SdW5SZXF1ZXN0EiEKDHdvcmtzcGFjZV9pZBgBIAEoCVILd2'
        '9ya3NwYWNlSWQSIAoMYWdlbnRfcnVuX2lkGAIgASgJUgphZ2VudFJ1bklk');

@$core.Deprecated('Use agentServiceStreamRunResponseDescriptor instead')
const AgentServiceStreamRunResponse$json = {
  '1': 'AgentServiceStreamRunResponse',
  '2': [
    {
      '1': 'run',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.automation.v1.AgentRun',
      '10': 'run'
    },
    {
      '1': 'current_step',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.creativanta.automation.v1.AgentStep',
      '10': 'currentStep'
    },
    {'1': 'progress_message', '3': 3, '4': 1, '5': 9, '10': 'progressMessage'},
    {'1': 'progress_percent', '3': 4, '4': 1, '5': 5, '10': 'progressPercent'},
  ],
};

/// Descriptor for `AgentServiceStreamRunResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List agentServiceStreamRunResponseDescriptor = $convert.base64Decode(
    'Ch1BZ2VudFNlcnZpY2VTdHJlYW1SdW5SZXNwb25zZRI1CgNydW4YASABKAsyIy5jcmVhdGl2YW'
    '50YS5hdXRvbWF0aW9uLnYxLkFnZW50UnVuUgNydW4SRwoMY3VycmVudF9zdGVwGAIgASgLMiQu'
    'Y3JlYXRpdmFudGEuYXV0b21hdGlvbi52MS5BZ2VudFN0ZXBSC2N1cnJlbnRTdGVwEikKEHByb2'
    'dyZXNzX21lc3NhZ2UYAyABKAlSD3Byb2dyZXNzTWVzc2FnZRIpChBwcm9ncmVzc19wZXJjZW50'
    'GAQgASgFUg9wcm9ncmVzc1BlcmNlbnQ=');

@$core.Deprecated('Use agentServiceProvideInputRequestDescriptor instead')
const AgentServiceProvideInputRequest$json = {
  '1': 'AgentServiceProvideInputRequest',
  '2': [
    {'1': 'idempotency_key', '3': 1, '4': 1, '5': 9, '10': 'idempotencyKey'},
    {'1': 'workspace_id', '3': 2, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'agent_run_id', '3': 3, '4': 1, '5': 9, '10': 'agentRunId'},
    {'1': 'input_text', '3': 4, '4': 1, '5': 9, '10': 'inputText'},
    {'1': 'input_json', '3': 5, '4': 1, '5': 9, '10': 'inputJson'},
    {'1': 'approve_plan', '3': 6, '4': 1, '5': 8, '10': 'approvePlan'},
    {
      '1': 'budget_ceiling_increase',
      '3': 7,
      '4': 1,
      '5': 9,
      '10': 'budgetCeilingIncrease'
    },
    {
      '1': 'handoff_target_user_id',
      '3': 8,
      '4': 1,
      '5': 9,
      '10': 'handoffTargetUserId'
    },
  ],
};

/// Descriptor for `AgentServiceProvideInputRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List agentServiceProvideInputRequestDescriptor = $convert.base64Decode(
    'Ch9BZ2VudFNlcnZpY2VQcm92aWRlSW5wdXRSZXF1ZXN0EicKD2lkZW1wb3RlbmN5X2tleRgBIA'
    'EoCVIOaWRlbXBvdGVuY3lLZXkSIQoMd29ya3NwYWNlX2lkGAIgASgJUgt3b3Jrc3BhY2VJZBIg'
    'CgxhZ2VudF9ydW5faWQYAyABKAlSCmFnZW50UnVuSWQSHQoKaW5wdXRfdGV4dBgEIAEoCVIJaW'
    '5wdXRUZXh0Eh0KCmlucHV0X2pzb24YBSABKAlSCWlucHV0SnNvbhIhCgxhcHByb3ZlX3BsYW4Y'
    'BiABKAhSC2FwcHJvdmVQbGFuEjYKF2J1ZGdldF9jZWlsaW5nX2luY3JlYXNlGAcgASgJUhVidW'
    'RnZXRDZWlsaW5nSW5jcmVhc2USMwoWaGFuZG9mZl90YXJnZXRfdXNlcl9pZBgIIAEoCVITaGFu'
    'ZG9mZlRhcmdldFVzZXJJZA==');

@$core.Deprecated('Use agentServiceProvideInputResponseDescriptor instead')
const AgentServiceProvideInputResponse$json = {
  '1': 'AgentServiceProvideInputResponse',
  '2': [
    {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
    {
      '1': 'run',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.creativanta.automation.v1.AgentRun',
      '10': 'run'
    },
  ],
};

/// Descriptor for `AgentServiceProvideInputResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List agentServiceProvideInputResponseDescriptor =
    $convert.base64Decode(
        'CiBBZ2VudFNlcnZpY2VQcm92aWRlSW5wdXRSZXNwb25zZRIYCgdzdWNjZXNzGAEgASgIUgdzdW'
        'NjZXNzEjUKA3J1bhgCIAEoCzIjLmNyZWF0aXZhbnRhLmF1dG9tYXRpb24udjEuQWdlbnRSdW5S'
        'A3J1bg==');

// This is a generated file - do not edit.
//
// Generated from creativanta/intelligence/v1/opportunity.proto.

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

@$core.Deprecated('Use priorityStateDescriptor instead')
const PriorityState$json = {
  '1': 'PriorityState',
  '2': [
    {'1': 'PRIORITY_STATE_UNSPECIFIED', '2': 0},
    {'1': 'PRIORITY_STATE_DRAFT', '2': 1},
    {'1': 'PRIORITY_STATE_OPEN', '2': 2},
    {'1': 'PRIORITY_STATE_PRIORITIZED', '2': 3},
    {'1': 'PRIORITY_STATE_ASSIGNED', '2': 4},
    {'1': 'PRIORITY_STATE_IN_PROGRESS', '2': 5},
    {'1': 'PRIORITY_STATE_CONVERTED', '2': 6},
    {'1': 'PRIORITY_STATE_PARKED', '2': 7},
    {'1': 'PRIORITY_STATE_CLOSED_WON', '2': 8},
    {'1': 'PRIORITY_STATE_CLOSED_LOST', '2': 9},
  ],
};

/// Descriptor for `PriorityState`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List priorityStateDescriptor = $convert.base64Decode(
    'Cg1Qcmlvcml0eVN0YXRlEh4KGlBSSU9SSVRZX1NUQVRFX1VOU1BFQ0lGSUVEEAASGAoUUFJJT1'
    'JJVFlfU1RBVEVfRFJBRlQQARIXChNQUklPUklUWV9TVEFURV9PUEVOEAISHgoaUFJJT1JJVFlf'
    'U1RBVEVfUFJJT1JJVElaRUQQAxIbChdQUklPUklUWV9TVEFURV9BU1NJR05FRBAEEh4KGlBSSU'
    '9SSVRZX1NUQVRFX0lOX1BST0dSRVNTEAUSHAoYUFJJT1JJVFlfU1RBVEVfQ09OVkVSVEVEEAYS'
    'GQoVUFJJT1JJVFlfU1RBVEVfUEFSS0VEEAcSHQoZUFJJT1JJVFlfU1RBVEVfQ0xPU0VEX1dPTh'
    'AIEh4KGlBSSU9SSVRZX1NUQVRFX0NMT1NFRF9MT1NUEAk=');

@$core.Deprecated('Use expectedImpactDescriptor instead')
const ExpectedImpact$json = {
  '1': 'ExpectedImpact',
  '2': [
    {'1': 'score', '3': 1, '4': 1, '5': 5, '10': 'score'},
    {'1': 'description', '3': 2, '4': 1, '5': 9, '10': 'description'},
    {'1': 'revenue_estimate', '3': 3, '4': 1, '5': 9, '10': 'revenueEstimate'},
  ],
};

/// Descriptor for `ExpectedImpact`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List expectedImpactDescriptor = $convert.base64Decode(
    'Cg5FeHBlY3RlZEltcGFjdBIUCgVzY29yZRgBIAEoBVIFc2NvcmUSIAoLZGVzY3JpcHRpb24YAi'
    'ABKAlSC2Rlc2NyaXB0aW9uEikKEHJldmVudWVfZXN0aW1hdGUYAyABKAlSD3JldmVudWVFc3Rp'
    'bWF0ZQ==');

@$core.Deprecated('Use expectedEffortDescriptor instead')
const ExpectedEffort$json = {
  '1': 'ExpectedEffort',
  '2': [
    {'1': 'score', '3': 1, '4': 1, '5': 5, '10': 'score'},
    {'1': 'description', '3': 2, '4': 1, '5': 9, '10': 'description'},
    {'1': 'time_estimate', '3': 3, '4': 1, '5': 9, '10': 'timeEstimate'},
  ],
};

/// Descriptor for `ExpectedEffort`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List expectedEffortDescriptor = $convert.base64Decode(
    'Cg5FeHBlY3RlZEVmZm9ydBIUCgVzY29yZRgBIAEoBVIFc2NvcmUSIAoLZGVzY3JpcHRpb24YAi'
    'ABKAlSC2Rlc2NyaXB0aW9uEiMKDXRpbWVfZXN0aW1hdGUYAyABKAlSDHRpbWVFc3RpbWF0ZQ==');

@$core.Deprecated('Use estimatedProfitDescriptor instead')
const EstimatedProfit$json = {
  '1': 'EstimatedProfit',
  '2': [
    {'1': 'amount_cents', '3': 1, '4': 1, '5': 3, '10': 'amountCents'},
    {'1': 'currency', '3': 2, '4': 1, '5': 9, '10': 'currency'},
    {
      '1': 'confidence',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.creativanta.intelligence.v1.ConfidenceBand',
      '10': 'confidence'
    },
    {
      '1': 'source_class',
      '3': 4,
      '4': 1,
      '5': 14,
      '6': '.creativanta.intelligence.v1.SourceClass',
      '10': 'sourceClass'
    },
    {'1': 'is_estimate', '3': 5, '4': 1, '5': 8, '10': 'isEstimate'},
    {'1': 'explanation', '3': 6, '4': 1, '5': 9, '10': 'explanation'},
  ],
};

/// Descriptor for `EstimatedProfit`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List estimatedProfitDescriptor = $convert.base64Decode(
    'Cg9Fc3RpbWF0ZWRQcm9maXQSIQoMYW1vdW50X2NlbnRzGAEgASgDUgthbW91bnRDZW50cxIaCg'
    'hjdXJyZW5jeRgCIAEoCVIIY3VycmVuY3kSSwoKY29uZmlkZW5jZRgDIAEoDjIrLmNyZWF0aXZh'
    'bnRhLmludGVsbGlnZW5jZS52MS5Db25maWRlbmNlQmFuZFIKY29uZmlkZW5jZRJLCgxzb3VyY2'
    'VfY2xhc3MYBCABKA4yKC5jcmVhdGl2YW50YS5pbnRlbGxpZ2VuY2UudjEuU291cmNlQ2xhc3NS'
    'C3NvdXJjZUNsYXNzEh8KC2lzX2VzdGltYXRlGAUgASgIUgppc0VzdGltYXRlEiAKC2V4cGxhbm'
    'F0aW9uGAYgASgJUgtleHBsYW5hdGlvbg==');

@$core.Deprecated('Use opportunitySourceRefDescriptor instead')
const OpportunitySourceRef$json = {
  '1': 'OpportunitySourceRef',
  '2': [
    {'1': 'source_type', '3': 1, '4': 1, '5': 9, '10': 'sourceType'},
    {'1': 'source_id', '3': 2, '4': 1, '5': 9, '10': 'sourceId'},
    {'1': 'source_name', '3': 3, '4': 1, '5': 9, '10': 'sourceName'},
    {'1': 'source_url', '3': 4, '4': 1, '5': 9, '10': 'sourceUrl'},
    {'1': 'is_expired', '3': 5, '4': 1, '5': 8, '10': 'isExpired'},
    {'1': 'archive_notice', '3': 6, '4': 1, '5': 9, '10': 'archiveNotice'},
  ],
};

/// Descriptor for `OpportunitySourceRef`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List opportunitySourceRefDescriptor = $convert.base64Decode(
    'ChRPcHBvcnR1bml0eVNvdXJjZVJlZhIfCgtzb3VyY2VfdHlwZRgBIAEoCVIKc291cmNlVHlwZR'
    'IbCglzb3VyY2VfaWQYAiABKAlSCHNvdXJjZUlkEh8KC3NvdXJjZV9uYW1lGAMgASgJUgpzb3Vy'
    'Y2VOYW1lEh0KCnNvdXJjZV91cmwYBCABKAlSCXNvdXJjZVVybBIdCgppc19leHBpcmVkGAUgAS'
    'gIUglpc0V4cGlyZWQSJQoOYXJjaGl2ZV9ub3RpY2UYBiABKAlSDWFyY2hpdmVOb3RpY2U=');

@$core.Deprecated('Use opportunityDescriptor instead')
const Opportunity$json = {
  '1': 'Opportunity',
  '2': [
    {'1': 'opportunity_id', '3': 1, '4': 1, '5': 9, '10': 'opportunityId'},
    {'1': 'workspace_id', '3': 2, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'opportunity_type', '3': 3, '4': 1, '5': 9, '10': 'opportunityType'},
    {'1': 'title', '3': 4, '4': 1, '5': 9, '10': 'title'},
    {'1': 'summary', '3': 5, '4': 1, '5': 9, '10': 'summary'},
    {'1': 'why_it_matters', '3': 6, '4': 1, '5': 9, '10': 'whyItMatters'},
    {
      '1': 'expected_impact',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.creativanta.intelligence.v1.ExpectedImpact',
      '10': 'expectedImpact'
    },
    {
      '1': 'expected_effort',
      '3': 8,
      '4': 1,
      '5': 11,
      '6': '.creativanta.intelligence.v1.ExpectedEffort',
      '10': 'expectedEffort'
    },
    {
      '1': 'priority_state',
      '3': 9,
      '4': 1,
      '5': 14,
      '6': '.creativanta.intelligence.v1.PriorityState',
      '10': 'priorityState'
    },
    {'1': 'priority_reason', '3': 10, '4': 1, '5': 9, '10': 'priorityReason'},
    {
      '1': 'suggested_next_step',
      '3': 11,
      '4': 1,
      '5': 9,
      '10': 'suggestedNextStep'
    },
    {'1': 'owner_user_id', '3': 12, '4': 1, '5': 9, '10': 'ownerUserId'},
    {
      '1': 'confidence',
      '3': 13,
      '4': 1,
      '5': 14,
      '6': '.creativanta.intelligence.v1.ConfidenceBand',
      '10': 'confidence'
    },
    {
      '1': 'source_class',
      '3': 14,
      '4': 1,
      '5': 14,
      '6': '.creativanta.intelligence.v1.SourceClass',
      '10': 'sourceClass'
    },
    {
      '1': 'converted_to_type',
      '3': 15,
      '4': 1,
      '5': 9,
      '10': 'convertedToType'
    },
    {'1': 'converted_to_id', '3': 16, '4': 1, '5': 9, '10': 'convertedToId'},
    {
      '1': 'sources',
      '3': 17,
      '4': 3,
      '5': 11,
      '6': '.creativanta.intelligence.v1.OpportunitySourceRef',
      '10': 'sources'
    },
    {
      '1': 'created_at',
      '3': 18,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'createdAt'
    },
    {
      '1': 'updated_at',
      '3': 19,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'updatedAt'
    },
    {'1': 'is_repairable', '3': 20, '4': 1, '5': 8, '10': 'isRepairable'},
    {'1': 'repair_reasons', '3': 21, '4': 3, '5': 9, '10': 'repairReasons'},
    {
      '1': 'estimated_profit',
      '3': 22,
      '4': 1,
      '5': 11,
      '6': '.creativanta.intelligence.v1.EstimatedProfit',
      '10': 'estimatedProfit'
    },
    {'1': 'is_saved', '3': 23, '4': 1, '5': 8, '10': 'isSaved'},
    {'1': 'is_dismissed', '3': 24, '4': 1, '5': 8, '10': 'isDismissed'},
    {'1': 'overall_score', '3': 25, '4': 1, '5': 5, '10': 'overallScore'},
  ],
};

/// Descriptor for `Opportunity`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List opportunityDescriptor = $convert.base64Decode(
    'CgtPcHBvcnR1bml0eRIlCg5vcHBvcnR1bml0eV9pZBgBIAEoCVINb3Bwb3J0dW5pdHlJZBIhCg'
    'x3b3Jrc3BhY2VfaWQYAiABKAlSC3dvcmtzcGFjZUlkEikKEG9wcG9ydHVuaXR5X3R5cGUYAyAB'
    'KAlSD29wcG9ydHVuaXR5VHlwZRIUCgV0aXRsZRgEIAEoCVIFdGl0bGUSGAoHc3VtbWFyeRgFIA'
    'EoCVIHc3VtbWFyeRIkCg53aHlfaXRfbWF0dGVycxgGIAEoCVIMd2h5SXRNYXR0ZXJzElQKD2V4'
    'cGVjdGVkX2ltcGFjdBgHIAEoCzIrLmNyZWF0aXZhbnRhLmludGVsbGlnZW5jZS52MS5FeHBlY3'
    'RlZEltcGFjdFIOZXhwZWN0ZWRJbXBhY3QSVAoPZXhwZWN0ZWRfZWZmb3J0GAggASgLMisuY3Jl'
    'YXRpdmFudGEuaW50ZWxsaWdlbmNlLnYxLkV4cGVjdGVkRWZmb3J0Ug5leHBlY3RlZEVmZm9ydB'
    'JRCg5wcmlvcml0eV9zdGF0ZRgJIAEoDjIqLmNyZWF0aXZhbnRhLmludGVsbGlnZW5jZS52MS5Q'
    'cmlvcml0eVN0YXRlUg1wcmlvcml0eVN0YXRlEicKD3ByaW9yaXR5X3JlYXNvbhgKIAEoCVIOcH'
    'Jpb3JpdHlSZWFzb24SLgoTc3VnZ2VzdGVkX25leHRfc3RlcBgLIAEoCVIRc3VnZ2VzdGVkTmV4'
    'dFN0ZXASIgoNb3duZXJfdXNlcl9pZBgMIAEoCVILb3duZXJVc2VySWQSSwoKY29uZmlkZW5jZR'
    'gNIAEoDjIrLmNyZWF0aXZhbnRhLmludGVsbGlnZW5jZS52MS5Db25maWRlbmNlQmFuZFIKY29u'
    'ZmlkZW5jZRJLCgxzb3VyY2VfY2xhc3MYDiABKA4yKC5jcmVhdGl2YW50YS5pbnRlbGxpZ2VuY2'
    'UudjEuU291cmNlQ2xhc3NSC3NvdXJjZUNsYXNzEioKEWNvbnZlcnRlZF90b190eXBlGA8gASgJ'
    'Ug9jb252ZXJ0ZWRUb1R5cGUSJgoPY29udmVydGVkX3RvX2lkGBAgASgJUg1jb252ZXJ0ZWRUb0'
    'lkEksKB3NvdXJjZXMYESADKAsyMS5jcmVhdGl2YW50YS5pbnRlbGxpZ2VuY2UudjEuT3Bwb3J0'
    'dW5pdHlTb3VyY2VSZWZSB3NvdXJjZXMSOQoKY3JlYXRlZF9hdBgSIAEoCzIaLmdvb2dsZS5wcm'
    '90b2J1Zi5UaW1lc3RhbXBSCWNyZWF0ZWRBdBI5Cgp1cGRhdGVkX2F0GBMgASgLMhouZ29vZ2xl'
    'LnByb3RvYnVmLlRpbWVzdGFtcFIJdXBkYXRlZEF0EiMKDWlzX3JlcGFpcmFibGUYFCABKAhSDG'
    'lzUmVwYWlyYWJsZRIlCg5yZXBhaXJfcmVhc29ucxgVIAMoCVINcmVwYWlyUmVhc29ucxJXChBl'
    'c3RpbWF0ZWRfcHJvZml0GBYgASgLMiwuY3JlYXRpdmFudGEuaW50ZWxsaWdlbmNlLnYxLkVzdG'
    'ltYXRlZFByb2ZpdFIPZXN0aW1hdGVkUHJvZml0EhkKCGlzX3NhdmVkGBcgASgIUgdpc1NhdmVk'
    'EiEKDGlzX2Rpc21pc3NlZBgYIAEoCFILaXNEaXNtaXNzZWQSIwoNb3ZlcmFsbF9zY29yZRgZIA'
    'EoBVIMb3ZlcmFsbFNjb3Jl');

@$core.Deprecated('Use opportunityServiceListRequestDescriptor instead')
const OpportunityServiceListRequest$json = {
  '1': 'OpportunityServiceListRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {
      '1': 'priority_state',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.creativanta.intelligence.v1.PriorityState',
      '10': 'priorityState'
    },
    {'1': 'opportunity_type', '3': 3, '4': 1, '5': 9, '10': 'opportunityType'},
    {'1': 'owner_user_id', '3': 4, '4': 1, '5': 9, '10': 'ownerUserId'},
    {
      '1': 'confidence',
      '3': 5,
      '4': 1,
      '5': 14,
      '6': '.creativanta.intelligence.v1.ConfidenceBand',
      '10': 'confidence'
    },
    {'1': 'page_size', '3': 6, '4': 1, '5': 5, '10': 'pageSize'},
    {'1': 'page_token', '3': 7, '4': 1, '5': 9, '10': 'pageToken'},
  ],
};

/// Descriptor for `OpportunityServiceListRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List opportunityServiceListRequestDescriptor = $convert.base64Decode(
    'Ch1PcHBvcnR1bml0eVNlcnZpY2VMaXN0UmVxdWVzdBIhCgx3b3Jrc3BhY2VfaWQYASABKAlSC3'
    'dvcmtzcGFjZUlkElEKDnByaW9yaXR5X3N0YXRlGAIgASgOMiouY3JlYXRpdmFudGEuaW50ZWxs'
    'aWdlbmNlLnYxLlByaW9yaXR5U3RhdGVSDXByaW9yaXR5U3RhdGUSKQoQb3Bwb3J0dW5pdHlfdH'
    'lwZRgDIAEoCVIPb3Bwb3J0dW5pdHlUeXBlEiIKDW93bmVyX3VzZXJfaWQYBCABKAlSC293bmVy'
    'VXNlcklkEksKCmNvbmZpZGVuY2UYBSABKA4yKy5jcmVhdGl2YW50YS5pbnRlbGxpZ2VuY2Uudj'
    'EuQ29uZmlkZW5jZUJhbmRSCmNvbmZpZGVuY2USGwoJcGFnZV9zaXplGAYgASgFUghwYWdlU2l6'
    'ZRIdCgpwYWdlX3Rva2VuGAcgASgJUglwYWdlVG9rZW4=');

@$core.Deprecated('Use opportunityServiceListResponseDescriptor instead')
const OpportunityServiceListResponse$json = {
  '1': 'OpportunityServiceListResponse',
  '2': [
    {
      '1': 'opportunities',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.creativanta.intelligence.v1.Opportunity',
      '10': 'opportunities'
    },
    {'1': 'next_page_token', '3': 2, '4': 1, '5': 9, '10': 'nextPageToken'},
    {'1': 'total_count', '3': 3, '4': 1, '5': 5, '10': 'totalCount'},
    {'1': 'avg_score', '3': 4, '4': 1, '5': 2, '10': 'avgScore'},
    {'1': 'new_today_count', '3': 5, '4': 1, '5': 5, '10': 'newTodayCount'},
  ],
};

/// Descriptor for `OpportunityServiceListResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List opportunityServiceListResponseDescriptor = $convert.base64Decode(
    'Ch5PcHBvcnR1bml0eVNlcnZpY2VMaXN0UmVzcG9uc2USTgoNb3Bwb3J0dW5pdGllcxgBIAMoCz'
    'IoLmNyZWF0aXZhbnRhLmludGVsbGlnZW5jZS52MS5PcHBvcnR1bml0eVINb3Bwb3J0dW5pdGll'
    'cxImCg9uZXh0X3BhZ2VfdG9rZW4YAiABKAlSDW5leHRQYWdlVG9rZW4SHwoLdG90YWxfY291bn'
    'QYAyABKAVSCnRvdGFsQ291bnQSGwoJYXZnX3Njb3JlGAQgASgCUghhdmdTY29yZRImCg9uZXdf'
    'dG9kYXlfY291bnQYBSABKAVSDW5ld1RvZGF5Q291bnQ=');

@$core.Deprecated('Use opportunityServiceGetRequestDescriptor instead')
const OpportunityServiceGetRequest$json = {
  '1': 'OpportunityServiceGetRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'opportunity_id', '3': 2, '4': 1, '5': 9, '10': 'opportunityId'},
  ],
};

/// Descriptor for `OpportunityServiceGetRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List opportunityServiceGetRequestDescriptor =
    $convert.base64Decode(
        'ChxPcHBvcnR1bml0eVNlcnZpY2VHZXRSZXF1ZXN0EiEKDHdvcmtzcGFjZV9pZBgBIAEoCVILd2'
        '9ya3NwYWNlSWQSJQoOb3Bwb3J0dW5pdHlfaWQYAiABKAlSDW9wcG9ydHVuaXR5SWQ=');

@$core.Deprecated('Use opportunityServiceGetResponseDescriptor instead')
const OpportunityServiceGetResponse$json = {
  '1': 'OpportunityServiceGetResponse',
  '2': [
    {
      '1': 'opportunity',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.intelligence.v1.Opportunity',
      '10': 'opportunity'
    },
  ],
};

/// Descriptor for `OpportunityServiceGetResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List opportunityServiceGetResponseDescriptor =
    $convert.base64Decode(
        'Ch1PcHBvcnR1bml0eVNlcnZpY2VHZXRSZXNwb25zZRJKCgtvcHBvcnR1bml0eRgBIAEoCzIoLm'
        'NyZWF0aXZhbnRhLmludGVsbGlnZW5jZS52MS5PcHBvcnR1bml0eVILb3Bwb3J0dW5pdHk=');

@$core.Deprecated('Use opportunityServiceCreateRequestDescriptor instead')
const OpportunityServiceCreateRequest$json = {
  '1': 'OpportunityServiceCreateRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'opportunity_type', '3': 2, '4': 1, '5': 9, '10': 'opportunityType'},
    {'1': 'title', '3': 3, '4': 1, '5': 9, '10': 'title'},
    {'1': 'summary', '3': 4, '4': 1, '5': 9, '10': 'summary'},
    {'1': 'why_it_matters', '3': 5, '4': 1, '5': 9, '10': 'whyItMatters'},
    {
      '1': 'expected_impact',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.creativanta.intelligence.v1.ExpectedImpact',
      '10': 'expectedImpact'
    },
    {
      '1': 'expected_effort',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.creativanta.intelligence.v1.ExpectedEffort',
      '10': 'expectedEffort'
    },
    {'1': 'priority_reason', '3': 8, '4': 1, '5': 9, '10': 'priorityReason'},
    {
      '1': 'confidence',
      '3': 9,
      '4': 1,
      '5': 14,
      '6': '.creativanta.intelligence.v1.ConfidenceBand',
      '10': 'confidence'
    },
    {
      '1': 'source_refs',
      '3': 10,
      '4': 3,
      '5': 11,
      '6': '.creativanta.intelligence.v1.OpportunitySourceRef',
      '10': 'sourceRefs'
    },
    {
      '1': 'suggested_next_step',
      '3': 11,
      '4': 1,
      '5': 9,
      '10': 'suggestedNextStep'
    },
  ],
};

/// Descriptor for `OpportunityServiceCreateRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List opportunityServiceCreateRequestDescriptor = $convert.base64Decode(
    'Ch9PcHBvcnR1bml0eVNlcnZpY2VDcmVhdGVSZXF1ZXN0EiEKDHdvcmtzcGFjZV9pZBgBIAEoCV'
    'ILd29ya3NwYWNlSWQSKQoQb3Bwb3J0dW5pdHlfdHlwZRgCIAEoCVIPb3Bwb3J0dW5pdHlUeXBl'
    'EhQKBXRpdGxlGAMgASgJUgV0aXRsZRIYCgdzdW1tYXJ5GAQgASgJUgdzdW1tYXJ5EiQKDndoeV'
    '9pdF9tYXR0ZXJzGAUgASgJUgx3aHlJdE1hdHRlcnMSVAoPZXhwZWN0ZWRfaW1wYWN0GAYgASgL'
    'MisuY3JlYXRpdmFudGEuaW50ZWxsaWdlbmNlLnYxLkV4cGVjdGVkSW1wYWN0Ug5leHBlY3RlZE'
    'ltcGFjdBJUCg9leHBlY3RlZF9lZmZvcnQYByABKAsyKy5jcmVhdGl2YW50YS5pbnRlbGxpZ2Vu'
    'Y2UudjEuRXhwZWN0ZWRFZmZvcnRSDmV4cGVjdGVkRWZmb3J0EicKD3ByaW9yaXR5X3JlYXNvbh'
    'gIIAEoCVIOcHJpb3JpdHlSZWFzb24SSwoKY29uZmlkZW5jZRgJIAEoDjIrLmNyZWF0aXZhbnRh'
    'LmludGVsbGlnZW5jZS52MS5Db25maWRlbmNlQmFuZFIKY29uZmlkZW5jZRJSCgtzb3VyY2Vfcm'
    'VmcxgKIAMoCzIxLmNyZWF0aXZhbnRhLmludGVsbGlnZW5jZS52MS5PcHBvcnR1bml0eVNvdXJj'
    'ZVJlZlIKc291cmNlUmVmcxIuChNzdWdnZXN0ZWRfbmV4dF9zdGVwGAsgASgJUhFzdWdnZXN0ZW'
    'ROZXh0U3RlcA==');

@$core.Deprecated('Use opportunityServiceCreateResponseDescriptor instead')
const OpportunityServiceCreateResponse$json = {
  '1': 'OpportunityServiceCreateResponse',
  '2': [
    {
      '1': 'opportunity',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.intelligence.v1.Opportunity',
      '10': 'opportunity'
    },
  ],
};

/// Descriptor for `OpportunityServiceCreateResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List opportunityServiceCreateResponseDescriptor =
    $convert.base64Decode(
        'CiBPcHBvcnR1bml0eVNlcnZpY2VDcmVhdGVSZXNwb25zZRJKCgtvcHBvcnR1bml0eRgBIAEoCz'
        'IoLmNyZWF0aXZhbnRhLmludGVsbGlnZW5jZS52MS5PcHBvcnR1bml0eVILb3Bwb3J0dW5pdHk=');

@$core.Deprecated('Use opportunityServiceUpdateStateRequestDescriptor instead')
const OpportunityServiceUpdateStateRequest$json = {
  '1': 'OpportunityServiceUpdateStateRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'opportunity_id', '3': 2, '4': 1, '5': 9, '10': 'opportunityId'},
    {
      '1': 'expected_updated_at',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'expectedUpdatedAt'
    },
    {
      '1': 'new_state',
      '3': 4,
      '4': 1,
      '5': 14,
      '6': '.creativanta.intelligence.v1.PriorityState',
      '10': 'newState'
    },
    {'1': 'reason', '3': 5, '4': 1, '5': 9, '10': 'reason'},
    {
      '1': 'expected_impact',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.creativanta.intelligence.v1.ExpectedImpact',
      '10': 'expectedImpact'
    },
    {
      '1': 'expected_effort',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.creativanta.intelligence.v1.ExpectedEffort',
      '10': 'expectedEffort'
    },
    {'1': 'priority_reason', '3': 8, '4': 1, '5': 9, '10': 'priorityReason'},
    {
      '1': 'confidence',
      '3': 9,
      '4': 1,
      '5': 14,
      '6': '.creativanta.intelligence.v1.ConfidenceBand',
      '10': 'confidence'
    },
  ],
};

/// Descriptor for `OpportunityServiceUpdateStateRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List opportunityServiceUpdateStateRequestDescriptor = $convert.base64Decode(
    'CiRPcHBvcnR1bml0eVNlcnZpY2VVcGRhdGVTdGF0ZVJlcXVlc3QSIQoMd29ya3NwYWNlX2lkGA'
    'EgASgJUgt3b3Jrc3BhY2VJZBIlCg5vcHBvcnR1bml0eV9pZBgCIAEoCVINb3Bwb3J0dW5pdHlJ'
    'ZBJKChNleHBlY3RlZF91cGRhdGVkX2F0GAMgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdG'
    'FtcFIRZXhwZWN0ZWRVcGRhdGVkQXQSRwoJbmV3X3N0YXRlGAQgASgOMiouY3JlYXRpdmFudGEu'
    'aW50ZWxsaWdlbmNlLnYxLlByaW9yaXR5U3RhdGVSCG5ld1N0YXRlEhYKBnJlYXNvbhgFIAEoCV'
    'IGcmVhc29uElQKD2V4cGVjdGVkX2ltcGFjdBgGIAEoCzIrLmNyZWF0aXZhbnRhLmludGVsbGln'
    'ZW5jZS52MS5FeHBlY3RlZEltcGFjdFIOZXhwZWN0ZWRJbXBhY3QSVAoPZXhwZWN0ZWRfZWZmb3'
    'J0GAcgASgLMisuY3JlYXRpdmFudGEuaW50ZWxsaWdlbmNlLnYxLkV4cGVjdGVkRWZmb3J0Ug5l'
    'eHBlY3RlZEVmZm9ydBInCg9wcmlvcml0eV9yZWFzb24YCCABKAlSDnByaW9yaXR5UmVhc29uEk'
    'sKCmNvbmZpZGVuY2UYCSABKA4yKy5jcmVhdGl2YW50YS5pbnRlbGxpZ2VuY2UudjEuQ29uZmlk'
    'ZW5jZUJhbmRSCmNvbmZpZGVuY2U=');

@$core.Deprecated('Use opportunityServiceUpdateStateResponseDescriptor instead')
const OpportunityServiceUpdateStateResponse$json = {
  '1': 'OpportunityServiceUpdateStateResponse',
  '2': [
    {
      '1': 'opportunity',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.intelligence.v1.Opportunity',
      '10': 'opportunity'
    },
  ],
};

/// Descriptor for `OpportunityServiceUpdateStateResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List opportunityServiceUpdateStateResponseDescriptor =
    $convert.base64Decode(
        'CiVPcHBvcnR1bml0eVNlcnZpY2VVcGRhdGVTdGF0ZVJlc3BvbnNlEkoKC29wcG9ydHVuaXR5GA'
        'EgASgLMiguY3JlYXRpdmFudGEuaW50ZWxsaWdlbmNlLnYxLk9wcG9ydHVuaXR5UgtvcHBvcnR1'
        'bml0eQ==');

@$core.Deprecated('Use opportunityServiceAssignRequestDescriptor instead')
const OpportunityServiceAssignRequest$json = {
  '1': 'OpportunityServiceAssignRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'opportunity_id', '3': 2, '4': 1, '5': 9, '10': 'opportunityId'},
    {
      '1': 'expected_updated_at',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'expectedUpdatedAt'
    },
    {'1': 'owner_user_id', '3': 4, '4': 1, '5': 9, '10': 'ownerUserId'},
  ],
};

/// Descriptor for `OpportunityServiceAssignRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List opportunityServiceAssignRequestDescriptor = $convert.base64Decode(
    'Ch9PcHBvcnR1bml0eVNlcnZpY2VBc3NpZ25SZXF1ZXN0EiEKDHdvcmtzcGFjZV9pZBgBIAEoCV'
    'ILd29ya3NwYWNlSWQSJQoOb3Bwb3J0dW5pdHlfaWQYAiABKAlSDW9wcG9ydHVuaXR5SWQSSgoT'
    'ZXhwZWN0ZWRfdXBkYXRlZF9hdBgDIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSEW'
    'V4cGVjdGVkVXBkYXRlZEF0EiIKDW93bmVyX3VzZXJfaWQYBCABKAlSC293bmVyVXNlcklk');

@$core.Deprecated('Use opportunityServiceAssignResponseDescriptor instead')
const OpportunityServiceAssignResponse$json = {
  '1': 'OpportunityServiceAssignResponse',
  '2': [
    {
      '1': 'opportunity',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.intelligence.v1.Opportunity',
      '10': 'opportunity'
    },
  ],
};

/// Descriptor for `OpportunityServiceAssignResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List opportunityServiceAssignResponseDescriptor =
    $convert.base64Decode(
        'CiBPcHBvcnR1bml0eVNlcnZpY2VBc3NpZ25SZXNwb25zZRJKCgtvcHBvcnR1bml0eRgBIAEoCz'
        'IoLmNyZWF0aXZhbnRhLmludGVsbGlnZW5jZS52MS5PcHBvcnR1bml0eVILb3Bwb3J0dW5pdHk=');

@$core.Deprecated('Use opportunityServiceConvertRequestDescriptor instead')
const OpportunityServiceConvertRequest$json = {
  '1': 'OpportunityServiceConvertRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'opportunity_id', '3': 2, '4': 1, '5': 9, '10': 'opportunityId'},
    {
      '1': 'expected_updated_at',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'expectedUpdatedAt'
    },
    {'1': 'conversion_type', '3': 4, '4': 1, '5': 9, '10': 'conversionType'},
    {'1': 'title', '3': 5, '4': 1, '5': 9, '10': 'title'},
    {'1': 'notes', '3': 6, '4': 1, '5': 9, '10': 'notes'},
  ],
};

/// Descriptor for `OpportunityServiceConvertRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List opportunityServiceConvertRequestDescriptor = $convert.base64Decode(
    'CiBPcHBvcnR1bml0eVNlcnZpY2VDb252ZXJ0UmVxdWVzdBIhCgx3b3Jrc3BhY2VfaWQYASABKA'
    'lSC3dvcmtzcGFjZUlkEiUKDm9wcG9ydHVuaXR5X2lkGAIgASgJUg1vcHBvcnR1bml0eUlkEkoK'
    'E2V4cGVjdGVkX3VwZGF0ZWRfYXQYAyABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUh'
    'FleHBlY3RlZFVwZGF0ZWRBdBInCg9jb252ZXJzaW9uX3R5cGUYBCABKAlSDmNvbnZlcnNpb25U'
    'eXBlEhQKBXRpdGxlGAUgASgJUgV0aXRsZRIUCgVub3RlcxgGIAEoCVIFbm90ZXM=');

@$core.Deprecated('Use opportunityServiceConvertResponseDescriptor instead')
const OpportunityServiceConvertResponse$json = {
  '1': 'OpportunityServiceConvertResponse',
  '2': [
    {
      '1': 'opportunity',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.intelligence.v1.Opportunity',
      '10': 'opportunity'
    },
    {'1': 'converted_to_type', '3': 2, '4': 1, '5': 9, '10': 'convertedToType'},
    {'1': 'converted_to_id', '3': 3, '4': 1, '5': 9, '10': 'convertedToId'},
    {'1': 'target_route', '3': 4, '4': 1, '5': 9, '10': 'targetRoute'},
  ],
};

/// Descriptor for `OpportunityServiceConvertResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List opportunityServiceConvertResponseDescriptor = $convert.base64Decode(
    'CiFPcHBvcnR1bml0eVNlcnZpY2VDb252ZXJ0UmVzcG9uc2USSgoLb3Bwb3J0dW5pdHkYASABKA'
    'syKC5jcmVhdGl2YW50YS5pbnRlbGxpZ2VuY2UudjEuT3Bwb3J0dW5pdHlSC29wcG9ydHVuaXR5'
    'EioKEWNvbnZlcnRlZF90b190eXBlGAIgASgJUg9jb252ZXJ0ZWRUb1R5cGUSJgoPY29udmVydG'
    'VkX3RvX2lkGAMgASgJUg1jb252ZXJ0ZWRUb0lkEiEKDHRhcmdldF9yb3V0ZRgEIAEoCVILdGFy'
    'Z2V0Um91dGU=');

@$core.Deprecated('Use opportunityServiceSaveRequestDescriptor instead')
const OpportunityServiceSaveRequest$json = {
  '1': 'OpportunityServiceSaveRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'opportunity_id', '3': 2, '4': 1, '5': 9, '10': 'opportunityId'},
  ],
};

/// Descriptor for `OpportunityServiceSaveRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List opportunityServiceSaveRequestDescriptor =
    $convert.base64Decode(
        'Ch1PcHBvcnR1bml0eVNlcnZpY2VTYXZlUmVxdWVzdBIhCgx3b3Jrc3BhY2VfaWQYASABKAlSC3'
        'dvcmtzcGFjZUlkEiUKDm9wcG9ydHVuaXR5X2lkGAIgASgJUg1vcHBvcnR1bml0eUlk');

@$core.Deprecated('Use opportunityServiceSaveResponseDescriptor instead')
const OpportunityServiceSaveResponse$json = {
  '1': 'OpportunityServiceSaveResponse',
  '2': [
    {
      '1': 'opportunity',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.intelligence.v1.Opportunity',
      '10': 'opportunity'
    },
  ],
};

/// Descriptor for `OpportunityServiceSaveResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List opportunityServiceSaveResponseDescriptor =
    $convert.base64Decode(
        'Ch5PcHBvcnR1bml0eVNlcnZpY2VTYXZlUmVzcG9uc2USSgoLb3Bwb3J0dW5pdHkYASABKAsyKC'
        '5jcmVhdGl2YW50YS5pbnRlbGxpZ2VuY2UudjEuT3Bwb3J0dW5pdHlSC29wcG9ydHVuaXR5');

@$core.Deprecated('Use opportunityServiceDismissRequestDescriptor instead')
const OpportunityServiceDismissRequest$json = {
  '1': 'OpportunityServiceDismissRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'opportunity_id', '3': 2, '4': 1, '5': 9, '10': 'opportunityId'},
    {'1': 'reason', '3': 3, '4': 1, '5': 9, '10': 'reason'},
  ],
};

/// Descriptor for `OpportunityServiceDismissRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List opportunityServiceDismissRequestDescriptor =
    $convert.base64Decode(
        'CiBPcHBvcnR1bml0eVNlcnZpY2VEaXNtaXNzUmVxdWVzdBIhCgx3b3Jrc3BhY2VfaWQYASABKA'
        'lSC3dvcmtzcGFjZUlkEiUKDm9wcG9ydHVuaXR5X2lkGAIgASgJUg1vcHBvcnR1bml0eUlkEhYK'
        'BnJlYXNvbhgDIAEoCVIGcmVhc29u');

@$core.Deprecated('Use opportunityServiceDismissResponseDescriptor instead')
const OpportunityServiceDismissResponse$json = {
  '1': 'OpportunityServiceDismissResponse',
  '2': [
    {
      '1': 'opportunity',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.intelligence.v1.Opportunity',
      '10': 'opportunity'
    },
  ],
};

/// Descriptor for `OpportunityServiceDismissResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List opportunityServiceDismissResponseDescriptor =
    $convert.base64Decode(
        'CiFPcHBvcnR1bml0eVNlcnZpY2VEaXNtaXNzUmVzcG9uc2USSgoLb3Bwb3J0dW5pdHkYASABKA'
        'syKC5jcmVhdGl2YW50YS5pbnRlbGxpZ2VuY2UudjEuT3Bwb3J0dW5pdHlSC29wcG9ydHVuaXR5');

@$core.Deprecated('Use opportunityServiceListRelatedRequestDescriptor instead')
const OpportunityServiceListRelatedRequest$json = {
  '1': 'OpportunityServiceListRelatedRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'opportunity_id', '3': 2, '4': 1, '5': 9, '10': 'opportunityId'},
    {'1': 'limit', '3': 3, '4': 1, '5': 5, '10': 'limit'},
  ],
};

/// Descriptor for `OpportunityServiceListRelatedRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List opportunityServiceListRelatedRequestDescriptor =
    $convert.base64Decode(
        'CiRPcHBvcnR1bml0eVNlcnZpY2VMaXN0UmVsYXRlZFJlcXVlc3QSIQoMd29ya3NwYWNlX2lkGA'
        'EgASgJUgt3b3Jrc3BhY2VJZBIlCg5vcHBvcnR1bml0eV9pZBgCIAEoCVINb3Bwb3J0dW5pdHlJ'
        'ZBIUCgVsaW1pdBgDIAEoBVIFbGltaXQ=');

@$core.Deprecated('Use opportunityServiceListRelatedResponseDescriptor instead')
const OpportunityServiceListRelatedResponse$json = {
  '1': 'OpportunityServiceListRelatedResponse',
  '2': [
    {
      '1': 'related_opportunities',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.creativanta.intelligence.v1.Opportunity',
      '10': 'relatedOpportunities'
    },
  ],
};

/// Descriptor for `OpportunityServiceListRelatedResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List opportunityServiceListRelatedResponseDescriptor =
    $convert.base64Decode(
        'CiVPcHBvcnR1bml0eVNlcnZpY2VMaXN0UmVsYXRlZFJlc3BvbnNlEl0KFXJlbGF0ZWRfb3Bwb3'
        'J0dW5pdGllcxgBIAMoCzIoLmNyZWF0aXZhbnRhLmludGVsbGlnZW5jZS52MS5PcHBvcnR1bml0'
        'eVIUcmVsYXRlZE9wcG9ydHVuaXRpZXM=');

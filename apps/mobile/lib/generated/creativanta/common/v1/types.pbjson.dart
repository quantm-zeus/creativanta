// This is a generated file - do not edit.
//
// Generated from creativanta/common/v1/types.proto.

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

@$core.Deprecated('Use sourceClassDescriptor instead')
const SourceClass$json = {
  '1': 'SourceClass',
  '2': [
    {'1': 'SOURCE_CLASS_UNSPECIFIED', '2': 0},
    {'1': 'SOURCE_CLASS_OFFICIAL', '2': 1},
    {'1': 'SOURCE_CLASS_IMPORTED', '2': 2},
    {'1': 'SOURCE_CLASS_INFERRED', '2': 3},
    {'1': 'SOURCE_CLASS_ESTIMATED', '2': 4},
    {'1': 'SOURCE_CLASS_UNRECONCILED', '2': 5},
  ],
};

/// Descriptor for `SourceClass`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List sourceClassDescriptor = $convert.base64Decode(
    'CgtTb3VyY2VDbGFzcxIcChhTT1VSQ0VfQ0xBU1NfVU5TUEVDSUZJRUQQABIZChVTT1VSQ0VfQ0'
    'xBU1NfT0ZGSUNJQUwQARIZChVTT1VSQ0VfQ0xBU1NfSU1QT1JURUQQAhIZChVTT1VSQ0VfQ0xB'
    'U1NfSU5GRVJSRUQQAxIaChZTT1VSQ0VfQ0xBU1NfRVNUSU1BVEVEEAQSHQoZU09VUkNFX0NMQV'
    'NTX1VOUkVDT05DSUxFRBAF');

@$core.Deprecated('Use confidenceBandDescriptor instead')
const ConfidenceBand$json = {
  '1': 'ConfidenceBand',
  '2': [
    {'1': 'CONFIDENCE_BAND_UNSPECIFIED', '2': 0},
    {'1': 'CONFIDENCE_BAND_HIGH', '2': 1},
    {'1': 'CONFIDENCE_BAND_MEDIUM_HIGH', '2': 2},
    {'1': 'CONFIDENCE_BAND_MEDIUM', '2': 3},
    {'1': 'CONFIDENCE_BAND_LOW_MEDIUM', '2': 4},
    {'1': 'CONFIDENCE_BAND_LOW', '2': 5},
  ],
};

/// Descriptor for `ConfidenceBand`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List confidenceBandDescriptor = $convert.base64Decode(
    'Cg5Db25maWRlbmNlQmFuZBIfChtDT05GSURFTkNFX0JBTkRfVU5TUEVDSUZJRUQQABIYChRDT0'
    '5GSURFTkNFX0JBTkRfSElHSBABEh8KG0NPTkZJREVOQ0VfQkFORF9NRURJVU1fSElHSBACEhoK'
    'FkNPTkZJREVOQ0VfQkFORF9NRURJVU0QAxIeChpDT05GSURFTkNFX0JBTkRfTE9XX01FRElVTR'
    'AEEhcKE0NPTkZJREVOQ0VfQkFORF9MT1cQBQ==');

@$core.Deprecated('Use operatorModeDescriptor instead')
const OperatorMode$json = {
  '1': 'OperatorMode',
  '2': [
    {'1': 'OPERATOR_MODE_UNSPECIFIED', '2': 0},
    {'1': 'OPERATOR_MODE_CREATOR', '2': 1},
    {'1': 'OPERATOR_MODE_SELLER', '2': 2},
    {'1': 'OPERATOR_MODE_AFFILIATE_OPERATOR', '2': 3},
    {'1': 'OPERATOR_MODE_LIVE_OPERATOR', '2': 4},
    {'1': 'OPERATOR_MODE_AGENCY_MCN', '2': 5},
    {'1': 'OPERATOR_MODE_BRAND_COLLABORATION', '2': 6},
  ],
};

/// Descriptor for `OperatorMode`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List operatorModeDescriptor = $convert.base64Decode(
    'CgxPcGVyYXRvck1vZGUSHQoZT1BFUkFUT1JfTU9ERV9VTlNQRUNJRklFRBAAEhkKFU9QRVJBVE'
    '9SX01PREVfQ1JFQVRPUhABEhgKFE9QRVJBVE9SX01PREVfU0VMTEVSEAISJAogT1BFUkFUT1Jf'
    'TU9ERV9BRkZJTElBVEVfT1BFUkFUT1IQAxIfChtPUEVSQVRPUl9NT0RFX0xJVkVfT1BFUkFUT1'
    'IQBBIcChhPUEVSQVRPUl9NT0RFX0FHRU5DWV9NQ04QBRIlCiFPUEVSQVRPUl9NT0RFX0JSQU5E'
    'X0NPTExBQk9SQVRJT04QBg==');

@$core.Deprecated('Use uUIDDescriptor instead')
const UUID$json = {
  '1': 'UUID',
  '2': [
    {'1': 'value', '3': 1, '4': 1, '5': 9, '10': 'value'},
  ],
};

/// Descriptor for `UUID`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List uUIDDescriptor =
    $convert.base64Decode('CgRVVUlEEhQKBXZhbHVlGAEgASgJUgV2YWx1ZQ==');

@$core.Deprecated('Use moneyDescriptor instead')
const Money$json = {
  '1': 'Money',
  '2': [
    {'1': 'amount', '3': 1, '4': 1, '5': 9, '10': 'amount'},
    {'1': 'currency', '3': 2, '4': 1, '5': 9, '10': 'currency'},
  ],
};

/// Descriptor for `Money`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List moneyDescriptor = $convert.base64Decode(
    'CgVNb25leRIWCgZhbW91bnQYASABKAlSBmFtb3VudBIaCghjdXJyZW5jeRgCIAEoCVIIY3Vycm'
    'VuY3k=');

@$core.Deprecated('Use paginationDescriptor instead')
const Pagination$json = {
  '1': 'Pagination',
  '2': [
    {'1': 'page_size', '3': 1, '4': 1, '5': 5, '10': 'pageSize'},
    {'1': 'page_token', '3': 2, '4': 1, '5': 9, '10': 'pageToken'},
  ],
};

/// Descriptor for `Pagination`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List paginationDescriptor = $convert.base64Decode(
    'CgpQYWdpbmF0aW9uEhsKCXBhZ2Vfc2l6ZRgBIAEoBVIIcGFnZVNpemUSHQoKcGFnZV90b2tlbh'
    'gCIAEoCVIJcGFnZVRva2Vu');

@$core.Deprecated('Use paginatedResponseDescriptor instead')
const PaginatedResponse$json = {
  '1': 'PaginatedResponse',
  '2': [
    {'1': 'next_page_token', '3': 1, '4': 1, '5': 9, '10': 'nextPageToken'},
    {
      '1': 'total_count',
      '3': 2,
      '4': 1,
      '5': 3,
      '9': 0,
      '10': 'totalCount',
      '17': true
    },
    {'1': 'has_more', '3': 3, '4': 1, '5': 8, '10': 'hasMore'},
  ],
  '8': [
    {'1': '_total_count'},
  ],
};

/// Descriptor for `PaginatedResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List paginatedResponseDescriptor = $convert.base64Decode(
    'ChFQYWdpbmF0ZWRSZXNwb25zZRImCg9uZXh0X3BhZ2VfdG9rZW4YASABKAlSDW5leHRQYWdlVG'
    '9rZW4SJAoLdG90YWxfY291bnQYAiABKANIAFIKdG90YWxDb3VudIgBARIZCghoYXNfbW9yZRgD'
    'IAEoCFIHaGFzTW9yZUIOCgxfdG90YWxfY291bnQ=');

@$core.Deprecated('Use commandContextDescriptor instead')
const CommandContext$json = {
  '1': 'CommandContext',
  '2': [
    {'1': 'idempotency_key', '3': 1, '4': 1, '5': 9, '10': 'idempotencyKey'},
    {
      '1': 'expected_updated_at',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'expectedUpdatedAt'
    },
    {'1': 'reason', '3': 3, '4': 1, '5': 9, '10': 'reason'},
    {
      '1': 'workspace_id',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.UUID',
      '10': 'workspaceId'
    },
  ],
};

/// Descriptor for `CommandContext`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List commandContextDescriptor = $convert.base64Decode(
    'Cg5Db21tYW5kQ29udGV4dBInCg9pZGVtcG90ZW5jeV9rZXkYASABKAlSDmlkZW1wb3RlbmN5S2'
    'V5EkoKE2V4cGVjdGVkX3VwZGF0ZWRfYXQYAiABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0'
    'YW1wUhFleHBlY3RlZFVwZGF0ZWRBdBIWCgZyZWFzb24YAyABKAlSBnJlYXNvbhI+Cgx3b3Jrc3'
    'BhY2VfaWQYBCABKAsyGy5jcmVhdGl2YW50YS5jb21tb24udjEuVVVJRFILd29ya3NwYWNlSWQ=');

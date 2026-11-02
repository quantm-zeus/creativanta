// This is a generated file - do not edit.
//
// Generated from creativanta/intelligence/v1/trend.proto.

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

@$core.Deprecated('Use lifecycleStateDescriptor instead')
const LifecycleState$json = {
  '1': 'LifecycleState',
  '2': [
    {'1': 'LIFECYCLE_STATE_UNSPECIFIED', '2': 0},
    {'1': 'LIFECYCLE_STATE_EMERGING', '2': 1},
    {'1': 'LIFECYCLE_STATE_RISING', '2': 2},
    {'1': 'LIFECYCLE_STATE_PEAKING', '2': 3},
    {'1': 'LIFECYCLE_STATE_DECLINING', '2': 4},
    {'1': 'LIFECYCLE_STATE_EXPIRED', '2': 5},
    {'1': 'LIFECYCLE_STATE_ARCHIVED', '2': 6},
  ],
};

/// Descriptor for `LifecycleState`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List lifecycleStateDescriptor = $convert.base64Decode(
    'Cg5MaWZlY3ljbGVTdGF0ZRIfChtMSUZFQ1lDTEVfU1RBVEVfVU5TUEVDSUZJRUQQABIcChhMSU'
    'ZFQ1lDTEVfU1RBVEVfRU1FUkdJTkcQARIaChZMSUZFQ1lDTEVfU1RBVEVfUklTSU5HEAISGwoX'
    'TElGRUNZQ0xFX1NUQVRFX1BFQUtJTkcQAxIdChlMSUZFQ1lDTEVfU1RBVEVfREVDTElOSU5HEA'
    'QSGwoXTElGRUNZQ0xFX1NUQVRFX0VYUElSRUQQBRIcChhMSUZFQ1lDTEVfU1RBVEVfQVJDSElW'
    'RUQQBg==');

@$core.Deprecated('Use signalRefDescriptor instead')
const SignalRef$json = {
  '1': 'SignalRef',
  '2': [
    {'1': 'signal_id', '3': 1, '4': 1, '5': 9, '10': 'signalId'},
    {'1': 'workspace_id', '3': 2, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'source_platform', '3': 3, '4': 1, '5': 9, '10': 'sourcePlatform'},
    {
      '1': 'source_class',
      '3': 4,
      '4': 1,
      '5': 14,
      '6': '.creativanta.intelligence.v1.SourceClass',
      '10': 'sourceClass'
    },
    {'1': 'signal_type', '3': 5, '4': 1, '5': 9, '10': 'signalType'},
    {
      '1': 'normalized_summary',
      '3': 6,
      '4': 1,
      '5': 9,
      '10': 'normalizedSummary'
    },
    {
      '1': 'confidence',
      '3': 7,
      '4': 1,
      '5': 14,
      '6': '.creativanta.intelligence.v1.ConfidenceBand',
      '10': 'confidence'
    },
    {
      '1': 'freshness_at',
      '3': 8,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'freshnessAt'
    },
    {
      '1': 'collected_at',
      '3': 9,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'collectedAt'
    },
  ],
};

/// Descriptor for `SignalRef`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List signalRefDescriptor = $convert.base64Decode(
    'CglTaWduYWxSZWYSGwoJc2lnbmFsX2lkGAEgASgJUghzaWduYWxJZBIhCgx3b3Jrc3BhY2VfaW'
    'QYAiABKAlSC3dvcmtzcGFjZUlkEicKD3NvdXJjZV9wbGF0Zm9ybRgDIAEoCVIOc291cmNlUGxh'
    'dGZvcm0SSwoMc291cmNlX2NsYXNzGAQgASgOMiguY3JlYXRpdmFudGEuaW50ZWxsaWdlbmNlLn'
    'YxLlNvdXJjZUNsYXNzUgtzb3VyY2VDbGFzcxIfCgtzaWduYWxfdHlwZRgFIAEoCVIKc2lnbmFs'
    'VHlwZRItChJub3JtYWxpemVkX3N1bW1hcnkYBiABKAlSEW5vcm1hbGl6ZWRTdW1tYXJ5EksKCm'
    'NvbmZpZGVuY2UYByABKA4yKy5jcmVhdGl2YW50YS5pbnRlbGxpZ2VuY2UudjEuQ29uZmlkZW5j'
    'ZUJhbmRSCmNvbmZpZGVuY2USPQoMZnJlc2huZXNzX2F0GAggASgLMhouZ29vZ2xlLnByb3RvYn'
    'VmLlRpbWVzdGFtcFILZnJlc2huZXNzQXQSPQoMY29sbGVjdGVkX2F0GAkgASgLMhouZ29vZ2xl'
    'LnByb3RvYnVmLlRpbWVzdGFtcFILY29sbGVjdGVkQXQ=');

@$core.Deprecated('Use trendDescriptor instead')
const Trend$json = {
  '1': 'Trend',
  '2': [
    {'1': 'trend_id', '3': 1, '4': 1, '5': 9, '10': 'trendId'},
    {'1': 'workspace_id', '3': 2, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'title', '3': 3, '4': 1, '5': 9, '10': 'title'},
    {'1': 'summary', '3': 4, '4': 1, '5': 9, '10': 'summary'},
    {'1': 'category', '3': 5, '4': 1, '5': 9, '10': 'category'},
    {'1': 'platforms', '3': 6, '4': 3, '5': 9, '10': 'platforms'},
    {'1': 'strength_score', '3': 7, '4': 1, '5': 2, '10': 'strengthScore'},
    {'1': 'velocity_score', '3': 8, '4': 1, '5': 2, '10': 'velocityScore'},
    {'1': 'freshness_score', '3': 9, '4': 1, '5': 2, '10': 'freshnessScore'},
    {'1': 'saturation_score', '3': 10, '4': 1, '5': 2, '10': 'saturationScore'},
    {
      '1': 'confidence',
      '3': 11,
      '4': 1,
      '5': 14,
      '6': '.creativanta.intelligence.v1.ConfidenceBand',
      '10': 'confidence'
    },
    {
      '1': 'confidence_reason',
      '3': 12,
      '4': 1,
      '5': 9,
      '10': 'confidenceReason'
    },
    {
      '1': 'source_class',
      '3': 13,
      '4': 1,
      '5': 14,
      '6': '.creativanta.intelligence.v1.SourceClass',
      '10': 'sourceClass'
    },
    {
      '1': 'lifecycle_state',
      '3': 14,
      '4': 1,
      '5': 14,
      '6': '.creativanta.intelligence.v1.LifecycleState',
      '10': 'lifecycleState'
    },
    {
      '1': 'freshness_at',
      '3': 15,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'freshnessAt'
    },
    {'1': 'why_now', '3': 16, '4': 1, '5': 9, '10': 'whyNow'},
    {
      '1': 'relevance_description',
      '3': 17,
      '4': 1,
      '5': 9,
      '10': 'relevanceDescription'
    },
    {
      '1': 'source_signals',
      '3': 18,
      '4': 3,
      '5': 11,
      '6': '.creativanta.intelligence.v1.SignalRef',
      '10': 'sourceSignals'
    },
    {'1': 'is_saved', '3': 19, '4': 1, '5': 8, '10': 'isSaved'},
    {'1': 'is_degraded', '3': 20, '4': 1, '5': 8, '10': 'isDegraded'},
    {'1': 'degraded_reason', '3': 21, '4': 1, '5': 9, '10': 'degradedReason'},
    {'1': 'embedding_vector', '3': 22, '4': 3, '5': 2, '10': 'embeddingVector'},
    {
      '1': 'created_at',
      '3': 23,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'createdAt'
    },
    {
      '1': 'updated_at',
      '3': 24,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'updatedAt'
    },
  ],
};

/// Descriptor for `Trend`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List trendDescriptor = $convert.base64Decode(
    'CgVUcmVuZBIZCgh0cmVuZF9pZBgBIAEoCVIHdHJlbmRJZBIhCgx3b3Jrc3BhY2VfaWQYAiABKA'
    'lSC3dvcmtzcGFjZUlkEhQKBXRpdGxlGAMgASgJUgV0aXRsZRIYCgdzdW1tYXJ5GAQgASgJUgdz'
    'dW1tYXJ5EhoKCGNhdGVnb3J5GAUgASgJUghjYXRlZ29yeRIcCglwbGF0Zm9ybXMYBiADKAlSCX'
    'BsYXRmb3JtcxIlCg5zdHJlbmd0aF9zY29yZRgHIAEoAlINc3RyZW5ndGhTY29yZRIlCg52ZWxv'
    'Y2l0eV9zY29yZRgIIAEoAlINdmVsb2NpdHlTY29yZRInCg9mcmVzaG5lc3Nfc2NvcmUYCSABKA'
    'JSDmZyZXNobmVzc1Njb3JlEikKEHNhdHVyYXRpb25fc2NvcmUYCiABKAJSD3NhdHVyYXRpb25T'
    'Y29yZRJLCgpjb25maWRlbmNlGAsgASgOMisuY3JlYXRpdmFudGEuaW50ZWxsaWdlbmNlLnYxLk'
    'NvbmZpZGVuY2VCYW5kUgpjb25maWRlbmNlEisKEWNvbmZpZGVuY2VfcmVhc29uGAwgASgJUhBj'
    'b25maWRlbmNlUmVhc29uEksKDHNvdXJjZV9jbGFzcxgNIAEoDjIoLmNyZWF0aXZhbnRhLmludG'
    'VsbGlnZW5jZS52MS5Tb3VyY2VDbGFzc1ILc291cmNlQ2xhc3MSVAoPbGlmZWN5Y2xlX3N0YXRl'
    'GA4gASgOMisuY3JlYXRpdmFudGEuaW50ZWxsaWdlbmNlLnYxLkxpZmVjeWNsZVN0YXRlUg5saW'
    'ZlY3ljbGVTdGF0ZRI9CgxmcmVzaG5lc3NfYXQYDyABKAsyGi5nb29nbGUucHJvdG9idWYuVGlt'
    'ZXN0YW1wUgtmcmVzaG5lc3NBdBIXCgd3aHlfbm93GBAgASgJUgZ3aHlOb3cSMwoVcmVsZXZhbm'
    'NlX2Rlc2NyaXB0aW9uGBEgASgJUhRyZWxldmFuY2VEZXNjcmlwdGlvbhJNCg5zb3VyY2Vfc2ln'
    'bmFscxgSIAMoCzImLmNyZWF0aXZhbnRhLmludGVsbGlnZW5jZS52MS5TaWduYWxSZWZSDXNvdX'
    'JjZVNpZ25hbHMSGQoIaXNfc2F2ZWQYEyABKAhSB2lzU2F2ZWQSHwoLaXNfZGVncmFkZWQYFCAB'
    'KAhSCmlzRGVncmFkZWQSJwoPZGVncmFkZWRfcmVhc29uGBUgASgJUg5kZWdyYWRlZFJlYXNvbh'
    'IpChBlbWJlZGRpbmdfdmVjdG9yGBYgAygCUg9lbWJlZGRpbmdWZWN0b3ISOQoKY3JlYXRlZF9h'
    'dBgXIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSCWNyZWF0ZWRBdBI5Cgp1cGRhdG'
    'VkX2F0GBggASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIJdXBkYXRlZEF0');

@$core.Deprecated('Use alertThresholdDescriptor instead')
const AlertThreshold$json = {
  '1': 'AlertThreshold',
  '2': [
    {
      '1': 'min_velocity_score',
      '3': 1,
      '4': 1,
      '5': 2,
      '10': 'minVelocityScore'
    },
    {
      '1': 'min_strength_score',
      '3': 2,
      '4': 1,
      '5': 2,
      '10': 'minStrengthScore'
    },
    {'1': 'spike_percentage', '3': 3, '4': 1, '5': 2, '10': 'spikePercentage'},
    {'1': 'cooldown_minutes', '3': 4, '4': 1, '5': 5, '10': 'cooldownMinutes'},
  ],
};

/// Descriptor for `AlertThreshold`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List alertThresholdDescriptor = $convert.base64Decode(
    'Cg5BbGVydFRocmVzaG9sZBIsChJtaW5fdmVsb2NpdHlfc2NvcmUYASABKAJSEG1pblZlbG9jaX'
    'R5U2NvcmUSLAoSbWluX3N0cmVuZ3RoX3Njb3JlGAIgASgCUhBtaW5TdHJlbmd0aFNjb3JlEikK'
    'EHNwaWtlX3BlcmNlbnRhZ2UYAyABKAJSD3NwaWtlUGVyY2VudGFnZRIpChBjb29sZG93bl9taW'
    '51dGVzGAQgASgFUg9jb29sZG93bk1pbnV0ZXM=');

@$core.Deprecated('Use watchlistDescriptor instead')
const Watchlist$json = {
  '1': 'Watchlist',
  '2': [
    {'1': 'watchlist_id', '3': 1, '4': 1, '5': 9, '10': 'watchlistId'},
    {'1': 'workspace_id', '3': 2, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'name', '3': 3, '4': 1, '5': 9, '10': 'name'},
    {'1': 'type', '3': 4, '4': 1, '5': 9, '10': 'type'},
    {'1': 'criteria_json', '3': 5, '4': 1, '5': 9, '10': 'criteriaJson'},
    {'1': 'alert_enabled', '3': 6, '4': 1, '5': 8, '10': 'alertEnabled'},
    {
      '1': 'alert_threshold',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.creativanta.intelligence.v1.AlertThreshold',
      '10': 'alertThreshold'
    },
    {'1': 'tracked_trend_ids', '3': 8, '4': 3, '5': 9, '10': 'trackedTrendIds'},
    {
      '1': 'created_at',
      '3': 9,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'createdAt'
    },
    {
      '1': 'updated_at',
      '3': 10,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'updatedAt'
    },
  ],
};

/// Descriptor for `Watchlist`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List watchlistDescriptor = $convert.base64Decode(
    'CglXYXRjaGxpc3QSIQoMd2F0Y2hsaXN0X2lkGAEgASgJUgt3YXRjaGxpc3RJZBIhCgx3b3Jrc3'
    'BhY2VfaWQYAiABKAlSC3dvcmtzcGFjZUlkEhIKBG5hbWUYAyABKAlSBG5hbWUSEgoEdHlwZRgE'
    'IAEoCVIEdHlwZRIjCg1jcml0ZXJpYV9qc29uGAUgASgJUgxjcml0ZXJpYUpzb24SIwoNYWxlcn'
    'RfZW5hYmxlZBgGIAEoCFIMYWxlcnRFbmFibGVkElQKD2FsZXJ0X3RocmVzaG9sZBgHIAEoCzIr'
    'LmNyZWF0aXZhbnRhLmludGVsbGlnZW5jZS52MS5BbGVydFRocmVzaG9sZFIOYWxlcnRUaHJlc2'
    'hvbGQSKgoRdHJhY2tlZF90cmVuZF9pZHMYCCADKAlSD3RyYWNrZWRUcmVuZElkcxI5CgpjcmVh'
    'dGVkX2F0GAkgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIJY3JlYXRlZEF0EjkKCn'
    'VwZGF0ZWRfYXQYCiABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUgl1cGRhdGVkQXQ=');

@$core.Deprecated('Use watchlistAlertDescriptor instead')
const WatchlistAlert$json = {
  '1': 'WatchlistAlert',
  '2': [
    {'1': 'alert_log_id', '3': 1, '4': 1, '5': 9, '10': 'alertLogId'},
    {'1': 'watchlist_id', '3': 2, '4': 1, '5': 9, '10': 'watchlistId'},
    {'1': 'trend_id', '3': 3, '4': 1, '5': 9, '10': 'trendId'},
    {'1': 'trend_title', '3': 4, '4': 1, '5': 9, '10': 'trendTitle'},
    {
      '1': 'alert_fingerprint',
      '3': 5,
      '4': 1,
      '5': 9,
      '10': 'alertFingerprint'
    },
    {'1': 'velocity_score', '3': 6, '4': 1, '5': 2, '10': 'velocityScore'},
    {'1': 'threshold_value', '3': 7, '4': 1, '5': 2, '10': 'thresholdValue'},
    {
      '1': 'delivered_at',
      '3': 8,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'deliveredAt'
    },
    {
      '1': 'cooldown_until',
      '3': 9,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'cooldownUntil'
    },
    {
      '1': 'is_batched_summary',
      '3': 10,
      '4': 1,
      '5': 8,
      '10': 'isBatchedSummary'
    },
    {
      '1': 'batched_alert_count',
      '3': 11,
      '4': 1,
      '5': 5,
      '10': 'batchedAlertCount'
    },
  ],
};

/// Descriptor for `WatchlistAlert`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List watchlistAlertDescriptor = $convert.base64Decode(
    'Cg5XYXRjaGxpc3RBbGVydBIgCgxhbGVydF9sb2dfaWQYASABKAlSCmFsZXJ0TG9nSWQSIQoMd2'
    'F0Y2hsaXN0X2lkGAIgASgJUgt3YXRjaGxpc3RJZBIZCgh0cmVuZF9pZBgDIAEoCVIHdHJlbmRJ'
    'ZBIfCgt0cmVuZF90aXRsZRgEIAEoCVIKdHJlbmRUaXRsZRIrChFhbGVydF9maW5nZXJwcmludB'
    'gFIAEoCVIQYWxlcnRGaW5nZXJwcmludBIlCg52ZWxvY2l0eV9zY29yZRgGIAEoAlINdmVsb2Np'
    'dHlTY29yZRInCg90aHJlc2hvbGRfdmFsdWUYByABKAJSDnRocmVzaG9sZFZhbHVlEj0KDGRlbG'
    'l2ZXJlZF9hdBgIIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSC2RlbGl2ZXJlZEF0'
    'EkEKDmNvb2xkb3duX3VudGlsGAkgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFINY2'
    '9vbGRvd25VbnRpbBIsChJpc19iYXRjaGVkX3N1bW1hcnkYCiABKAhSEGlzQmF0Y2hlZFN1bW1h'
    'cnkSLgoTYmF0Y2hlZF9hbGVydF9jb3VudBgLIAEoBVIRYmF0Y2hlZEFsZXJ0Q291bnQ=');

@$core.Deprecated('Use trendServiceListRequestDescriptor instead')
const TrendServiceListRequest$json = {
  '1': 'TrendServiceListRequest',
  '2': [
    {
      '1': 'context',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.CommandContext',
      '10': 'context'
    },
    {'1': 'workspace_id', '3': 2, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'category', '3': 3, '4': 1, '5': 9, '10': 'category'},
    {'1': 'platform', '3': 4, '4': 1, '5': 9, '10': 'platform'},
    {
      '1': 'min_confidence',
      '3': 5,
      '4': 1,
      '5': 14,
      '6': '.creativanta.intelligence.v1.ConfidenceBand',
      '10': 'minConfidence'
    },
    {
      '1': 'min_strength_score',
      '3': 6,
      '4': 1,
      '5': 2,
      '10': 'minStrengthScore'
    },
    {'1': 'sort_by', '3': 7, '4': 1, '5': 9, '10': 'sortBy'},
    {
      '1': 'pagination',
      '3': 8,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.Pagination',
      '10': 'pagination'
    },
  ],
};

/// Descriptor for `TrendServiceListRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List trendServiceListRequestDescriptor = $convert.base64Decode(
    'ChdUcmVuZFNlcnZpY2VMaXN0UmVxdWVzdBI/Cgdjb250ZXh0GAEgASgLMiUuY3JlYXRpdmFudG'
    'EuY29tbW9uLnYxLkNvbW1hbmRDb250ZXh0Ugdjb250ZXh0EiEKDHdvcmtzcGFjZV9pZBgCIAEo'
    'CVILd29ya3NwYWNlSWQSGgoIY2F0ZWdvcnkYAyABKAlSCGNhdGVnb3J5EhoKCHBsYXRmb3JtGA'
    'QgASgJUghwbGF0Zm9ybRJSCg5taW5fY29uZmlkZW5jZRgFIAEoDjIrLmNyZWF0aXZhbnRhLmlu'
    'dGVsbGlnZW5jZS52MS5Db25maWRlbmNlQmFuZFINbWluQ29uZmlkZW5jZRIsChJtaW5fc3RyZW'
    '5ndGhfc2NvcmUYBiABKAJSEG1pblN0cmVuZ3RoU2NvcmUSFwoHc29ydF9ieRgHIAEoCVIGc29y'
    'dEJ5EkEKCnBhZ2luYXRpb24YCCABKAsyIS5jcmVhdGl2YW50YS5jb21tb24udjEuUGFnaW5hdG'
    'lvblIKcGFnaW5hdGlvbg==');

@$core.Deprecated('Use trendServiceListResponseDescriptor instead')
const TrendServiceListResponse$json = {
  '1': 'TrendServiceListResponse',
  '2': [
    {
      '1': 'trends',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.creativanta.intelligence.v1.Trend',
      '10': 'trends'
    },
    {
      '1': 'pagination',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.Pagination',
      '10': 'pagination'
    },
    {'1': 'total_count', '3': 3, '4': 1, '5': 5, '10': 'totalCount'},
    {'1': 'source_degraded', '3': 4, '4': 1, '5': 8, '10': 'sourceDegraded'},
    {
      '1': 'disconnected_sources',
      '3': 5,
      '4': 3,
      '5': 9,
      '10': 'disconnectedSources'
    },
  ],
};

/// Descriptor for `TrendServiceListResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List trendServiceListResponseDescriptor = $convert.base64Decode(
    'ChhUcmVuZFNlcnZpY2VMaXN0UmVzcG9uc2USOgoGdHJlbmRzGAEgAygLMiIuY3JlYXRpdmFudG'
    'EuaW50ZWxsaWdlbmNlLnYxLlRyZW5kUgZ0cmVuZHMSQQoKcGFnaW5hdGlvbhgCIAEoCzIhLmNy'
    'ZWF0aXZhbnRhLmNvbW1vbi52MS5QYWdpbmF0aW9uUgpwYWdpbmF0aW9uEh8KC3RvdGFsX2NvdW'
    '50GAMgASgFUgp0b3RhbENvdW50EicKD3NvdXJjZV9kZWdyYWRlZBgEIAEoCFIOc291cmNlRGVn'
    'cmFkZWQSMQoUZGlzY29ubmVjdGVkX3NvdXJjZXMYBSADKAlSE2Rpc2Nvbm5lY3RlZFNvdXJjZX'
    'M=');

@$core.Deprecated('Use trendServiceGetRequestDescriptor instead')
const TrendServiceGetRequest$json = {
  '1': 'TrendServiceGetRequest',
  '2': [
    {
      '1': 'context',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.CommandContext',
      '10': 'context'
    },
    {'1': 'workspace_id', '3': 2, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'trend_id', '3': 3, '4': 1, '5': 9, '10': 'trendId'},
  ],
};

/// Descriptor for `TrendServiceGetRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List trendServiceGetRequestDescriptor = $convert.base64Decode(
    'ChZUcmVuZFNlcnZpY2VHZXRSZXF1ZXN0Ej8KB2NvbnRleHQYASABKAsyJS5jcmVhdGl2YW50YS'
    '5jb21tb24udjEuQ29tbWFuZENvbnRleHRSB2NvbnRleHQSIQoMd29ya3NwYWNlX2lkGAIgASgJ'
    'Ugt3b3Jrc3BhY2VJZBIZCgh0cmVuZF9pZBgDIAEoCVIHdHJlbmRJZA==');

@$core.Deprecated('Use trendServiceGetResponseDescriptor instead')
const TrendServiceGetResponse$json = {
  '1': 'TrendServiceGetResponse',
  '2': [
    {
      '1': 'trend',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.intelligence.v1.Trend',
      '10': 'trend'
    },
    {
      '1': 'lineage_signals',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.creativanta.intelligence.v1.SignalRef',
      '10': 'lineageSignals'
    },
    {
      '1': 'improvement_advice',
      '3': 3,
      '4': 1,
      '5': 9,
      '10': 'improvementAdvice'
    },
  ],
};

/// Descriptor for `TrendServiceGetResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List trendServiceGetResponseDescriptor = $convert.base64Decode(
    'ChdUcmVuZFNlcnZpY2VHZXRSZXNwb25zZRI4CgV0cmVuZBgBIAEoCzIiLmNyZWF0aXZhbnRhLm'
    'ludGVsbGlnZW5jZS52MS5UcmVuZFIFdHJlbmQSTwoPbGluZWFnZV9zaWduYWxzGAIgAygLMiYu'
    'Y3JlYXRpdmFudGEuaW50ZWxsaWdlbmNlLnYxLlNpZ25hbFJlZlIObGluZWFnZVNpZ25hbHMSLQ'
    'oSaW1wcm92ZW1lbnRfYWR2aWNlGAMgASgJUhFpbXByb3ZlbWVudEFkdmljZQ==');

@$core.Deprecated('Use trendServiceSearchRequestDescriptor instead')
const TrendServiceSearchRequest$json = {
  '1': 'TrendServiceSearchRequest',
  '2': [
    {
      '1': 'context',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.CommandContext',
      '10': 'context'
    },
    {'1': 'workspace_id', '3': 2, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'query', '3': 3, '4': 1, '5': 9, '10': 'query'},
    {'1': 'query_embedding', '3': 4, '4': 3, '5': 2, '10': 'queryEmbedding'},
    {'1': 'limit', '3': 5, '4': 1, '5': 5, '10': 'limit'},
  ],
};

/// Descriptor for `TrendServiceSearchRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List trendServiceSearchRequestDescriptor = $convert.base64Decode(
    'ChlUcmVuZFNlcnZpY2VTZWFyY2hSZXF1ZXN0Ej8KB2NvbnRleHQYASABKAsyJS5jcmVhdGl2YW'
    '50YS5jb21tb24udjEuQ29tbWFuZENvbnRleHRSB2NvbnRleHQSIQoMd29ya3NwYWNlX2lkGAIg'
    'ASgJUgt3b3Jrc3BhY2VJZBIUCgVxdWVyeRgDIAEoCVIFcXVlcnkSJwoPcXVlcnlfZW1iZWRkaW'
    '5nGAQgAygCUg5xdWVyeUVtYmVkZGluZxIUCgVsaW1pdBgFIAEoBVIFbGltaXQ=');

@$core.Deprecated('Use trendServiceSearchResponseDescriptor instead')
const TrendServiceSearchResponse$json = {
  '1': 'TrendServiceSearchResponse',
  '2': [
    {
      '1': 'results',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.creativanta.intelligence.v1.Trend',
      '10': 'results'
    },
    {'1': 'total_matches', '3': 2, '4': 1, '5': 5, '10': 'totalMatches'},
    {'1': 'search_strategy', '3': 3, '4': 1, '5': 9, '10': 'searchStrategy'},
  ],
};

/// Descriptor for `TrendServiceSearchResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List trendServiceSearchResponseDescriptor = $convert.base64Decode(
    'ChpUcmVuZFNlcnZpY2VTZWFyY2hSZXNwb25zZRI8CgdyZXN1bHRzGAEgAygLMiIuY3JlYXRpdm'
    'FudGEuaW50ZWxsaWdlbmNlLnYxLlRyZW5kUgdyZXN1bHRzEiMKDXRvdGFsX21hdGNoZXMYAiAB'
    'KAVSDHRvdGFsTWF0Y2hlcxInCg9zZWFyY2hfc3RyYXRlZ3kYAyABKAlSDnNlYXJjaFN0cmF0ZW'
    'd5');

@$core.Deprecated('Use trendServiceManageWatchlistRequestDescriptor instead')
const TrendServiceManageWatchlistRequest$json = {
  '1': 'TrendServiceManageWatchlistRequest',
  '2': [
    {
      '1': 'context',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.CommandContext',
      '10': 'context'
    },
    {'1': 'workspace_id', '3': 2, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'action', '3': 3, '4': 1, '5': 9, '10': 'action'},
    {'1': 'watchlist_id', '3': 4, '4': 1, '5': 9, '10': 'watchlistId'},
    {'1': 'name', '3': 5, '4': 1, '5': 9, '10': 'name'},
    {'1': 'type', '3': 6, '4': 1, '5': 9, '10': 'type'},
    {'1': 'criteria_json', '3': 7, '4': 1, '5': 9, '10': 'criteriaJson'},
    {'1': 'alert_enabled', '3': 8, '4': 1, '5': 8, '10': 'alertEnabled'},
    {
      '1': 'alert_threshold',
      '3': 9,
      '4': 1,
      '5': 11,
      '6': '.creativanta.intelligence.v1.AlertThreshold',
      '10': 'alertThreshold'
    },
    {'1': 'trend_id', '3': 10, '4': 1, '5': 9, '10': 'trendId'},
  ],
};

/// Descriptor for `TrendServiceManageWatchlistRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List trendServiceManageWatchlistRequestDescriptor = $convert.base64Decode(
    'CiJUcmVuZFNlcnZpY2VNYW5hZ2VXYXRjaGxpc3RSZXF1ZXN0Ej8KB2NvbnRleHQYASABKAsyJS'
    '5jcmVhdGl2YW50YS5jb21tb24udjEuQ29tbWFuZENvbnRleHRSB2NvbnRleHQSIQoMd29ya3Nw'
    'YWNlX2lkGAIgASgJUgt3b3Jrc3BhY2VJZBIWCgZhY3Rpb24YAyABKAlSBmFjdGlvbhIhCgx3YX'
    'RjaGxpc3RfaWQYBCABKAlSC3dhdGNobGlzdElkEhIKBG5hbWUYBSABKAlSBG5hbWUSEgoEdHlw'
    'ZRgGIAEoCVIEdHlwZRIjCg1jcml0ZXJpYV9qc29uGAcgASgJUgxjcml0ZXJpYUpzb24SIwoNYW'
    'xlcnRfZW5hYmxlZBgIIAEoCFIMYWxlcnRFbmFibGVkElQKD2FsZXJ0X3RocmVzaG9sZBgJIAEo'
    'CzIrLmNyZWF0aXZhbnRhLmludGVsbGlnZW5jZS52MS5BbGVydFRocmVzaG9sZFIOYWxlcnRUaH'
    'Jlc2hvbGQSGQoIdHJlbmRfaWQYCiABKAlSB3RyZW5kSWQ=');

@$core.Deprecated('Use trendServiceManageWatchlistResponseDescriptor instead')
const TrendServiceManageWatchlistResponse$json = {
  '1': 'TrendServiceManageWatchlistResponse',
  '2': [
    {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
    {
      '1': 'watchlist',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.creativanta.intelligence.v1.Watchlist',
      '10': 'watchlist'
    },
    {'1': 'message', '3': 3, '4': 1, '5': 9, '10': 'message'},
  ],
};

/// Descriptor for `TrendServiceManageWatchlistResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List trendServiceManageWatchlistResponseDescriptor =
    $convert.base64Decode(
        'CiNUcmVuZFNlcnZpY2VNYW5hZ2VXYXRjaGxpc3RSZXNwb25zZRIYCgdzdWNjZXNzGAEgASgIUg'
        'dzdWNjZXNzEkQKCXdhdGNobGlzdBgCIAEoCzImLmNyZWF0aXZhbnRhLmludGVsbGlnZW5jZS52'
        'MS5XYXRjaGxpc3RSCXdhdGNobGlzdBIYCgdtZXNzYWdlGAMgASgJUgdtZXNzYWdl');

@$core.Deprecated('Use trendServiceGetTopRequestDescriptor instead')
const TrendServiceGetTopRequest$json = {
  '1': 'TrendServiceGetTopRequest',
  '2': [
    {
      '1': 'context',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.CommandContext',
      '10': 'context'
    },
    {'1': 'workspace_id', '3': 2, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'limit', '3': 3, '4': 1, '5': 5, '10': 'limit'},
  ],
};

/// Descriptor for `TrendServiceGetTopRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List trendServiceGetTopRequestDescriptor = $convert.base64Decode(
    'ChlUcmVuZFNlcnZpY2VHZXRUb3BSZXF1ZXN0Ej8KB2NvbnRleHQYASABKAsyJS5jcmVhdGl2YW'
    '50YS5jb21tb24udjEuQ29tbWFuZENvbnRleHRSB2NvbnRleHQSIQoMd29ya3NwYWNlX2lkGAIg'
    'ASgJUgt3b3Jrc3BhY2VJZBIUCgVsaW1pdBgDIAEoBVIFbGltaXQ=');

@$core.Deprecated('Use trendServiceGetTopResponseDescriptor instead')
const TrendServiceGetTopResponse$json = {
  '1': 'TrendServiceGetTopResponse',
  '2': [
    {
      '1': 'top_trends',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.creativanta.intelligence.v1.Trend',
      '10': 'topTrends'
    },
  ],
};

/// Descriptor for `TrendServiceGetTopResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List trendServiceGetTopResponseDescriptor =
    $convert.base64Decode(
        'ChpUcmVuZFNlcnZpY2VHZXRUb3BSZXNwb25zZRJBCgp0b3BfdHJlbmRzGAEgAygLMiIuY3JlYX'
        'RpdmFudGEuaW50ZWxsaWdlbmNlLnYxLlRyZW5kUgl0b3BUcmVuZHM=');

@$core.Deprecated('Use trendServiceListTopRequestDescriptor instead')
const TrendServiceListTopRequest$json = {
  '1': 'TrendServiceListTopRequest',
  '2': [
    {
      '1': 'context',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.CommandContext',
      '10': 'context'
    },
    {'1': 'workspace_id', '3': 2, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'time_window', '3': 3, '4': 1, '5': 9, '10': 'timeWindow'},
    {'1': 'limit', '3': 4, '4': 1, '5': 5, '10': 'limit'},
  ],
};

/// Descriptor for `TrendServiceListTopRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List trendServiceListTopRequestDescriptor = $convert.base64Decode(
    'ChpUcmVuZFNlcnZpY2VMaXN0VG9wUmVxdWVzdBI/Cgdjb250ZXh0GAEgASgLMiUuY3JlYXRpdm'
    'FudGEuY29tbW9uLnYxLkNvbW1hbmRDb250ZXh0Ugdjb250ZXh0EiEKDHdvcmtzcGFjZV9pZBgC'
    'IAEoCVILd29ya3NwYWNlSWQSHwoLdGltZV93aW5kb3cYAyABKAlSCnRpbWVXaW5kb3cSFAoFbG'
    'ltaXQYBCABKAVSBWxpbWl0');

@$core.Deprecated('Use trendServiceListTopResponseDescriptor instead')
const TrendServiceListTopResponse$json = {
  '1': 'TrendServiceListTopResponse',
  '2': [
    {
      '1': 'trends',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.creativanta.intelligence.v1.Trend',
      '10': 'trends'
    },
  ],
};

/// Descriptor for `TrendServiceListTopResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List trendServiceListTopResponseDescriptor =
    $convert.base64Decode(
        'ChtUcmVuZFNlcnZpY2VMaXN0VG9wUmVzcG9uc2USOgoGdHJlbmRzGAEgAygLMiIuY3JlYXRpdm'
        'FudGEuaW50ZWxsaWdlbmNlLnYxLlRyZW5kUgZ0cmVuZHM=');

@$core.Deprecated('Use trendServiceListRelatedRequestDescriptor instead')
const TrendServiceListRelatedRequest$json = {
  '1': 'TrendServiceListRelatedRequest',
  '2': [
    {
      '1': 'context',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.CommandContext',
      '10': 'context'
    },
    {'1': 'workspace_id', '3': 2, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'trend_id', '3': 3, '4': 1, '5': 9, '10': 'trendId'},
  ],
};

/// Descriptor for `TrendServiceListRelatedRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List trendServiceListRelatedRequestDescriptor =
    $convert.base64Decode(
        'Ch5UcmVuZFNlcnZpY2VMaXN0UmVsYXRlZFJlcXVlc3QSPwoHY29udGV4dBgBIAEoCzIlLmNyZW'
        'F0aXZhbnRhLmNvbW1vbi52MS5Db21tYW5kQ29udGV4dFIHY29udGV4dBIhCgx3b3Jrc3BhY2Vf'
        'aWQYAiABKAlSC3dvcmtzcGFjZUlkEhkKCHRyZW5kX2lkGAMgASgJUgd0cmVuZElk');

@$core.Deprecated('Use trendServiceListRelatedResponseDescriptor instead')
const TrendServiceListRelatedResponse$json = {
  '1': 'TrendServiceListRelatedResponse',
  '2': [
    {
      '1': 'related_trends',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.creativanta.intelligence.v1.Trend',
      '10': 'relatedTrends'
    },
  ],
};

/// Descriptor for `TrendServiceListRelatedResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List trendServiceListRelatedResponseDescriptor =
    $convert.base64Decode(
        'Ch9UcmVuZFNlcnZpY2VMaXN0UmVsYXRlZFJlc3BvbnNlEkkKDnJlbGF0ZWRfdHJlbmRzGAEgAy'
        'gLMiIuY3JlYXRpdmFudGEuaW50ZWxsaWdlbmNlLnYxLlRyZW5kUg1yZWxhdGVkVHJlbmRz');

@$core.Deprecated('Use trendServiceGetTimeSeriesRequestDescriptor instead')
const TrendServiceGetTimeSeriesRequest$json = {
  '1': 'TrendServiceGetTimeSeriesRequest',
  '2': [
    {
      '1': 'context',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.CommandContext',
      '10': 'context'
    },
    {'1': 'workspace_id', '3': 2, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'trend_id', '3': 3, '4': 1, '5': 9, '10': 'trendId'},
    {'1': 'interval', '3': 4, '4': 1, '5': 9, '10': 'interval'},
  ],
};

/// Descriptor for `TrendServiceGetTimeSeriesRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List trendServiceGetTimeSeriesRequestDescriptor =
    $convert.base64Decode(
        'CiBUcmVuZFNlcnZpY2VHZXRUaW1lU2VyaWVzUmVxdWVzdBI/Cgdjb250ZXh0GAEgASgLMiUuY3'
        'JlYXRpdmFudGEuY29tbW9uLnYxLkNvbW1hbmRDb250ZXh0Ugdjb250ZXh0EiEKDHdvcmtzcGFj'
        'ZV9pZBgCIAEoCVILd29ya3NwYWNlSWQSGQoIdHJlbmRfaWQYAyABKAlSB3RyZW5kSWQSGgoIaW'
        '50ZXJ2YWwYBCABKAlSCGludGVydmFs');

@$core.Deprecated('Use timeSeriesPointDescriptor instead')
const TimeSeriesPoint$json = {
  '1': 'TimeSeriesPoint',
  '2': [
    {
      '1': 'timestamp',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'timestamp'
    },
    {'1': 'volume', '3': 2, '4': 1, '5': 2, '10': 'volume'},
    {'1': 'velocity', '3': 3, '4': 1, '5': 2, '10': 'velocity'},
  ],
};

/// Descriptor for `TimeSeriesPoint`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List timeSeriesPointDescriptor = $convert.base64Decode(
    'Cg9UaW1lU2VyaWVzUG9pbnQSOAoJdGltZXN0YW1wGAEgASgLMhouZ29vZ2xlLnByb3RvYnVmLl'
    'RpbWVzdGFtcFIJdGltZXN0YW1wEhYKBnZvbHVtZRgCIAEoAlIGdm9sdW1lEhoKCHZlbG9jaXR5'
    'GAMgASgCUgh2ZWxvY2l0eQ==');

@$core.Deprecated('Use trendServiceGetTimeSeriesResponseDescriptor instead')
const TrendServiceGetTimeSeriesResponse$json = {
  '1': 'TrendServiceGetTimeSeriesResponse',
  '2': [
    {'1': 'trend_id', '3': 1, '4': 1, '5': 9, '10': 'trendId'},
    {
      '1': 'points',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.creativanta.intelligence.v1.TimeSeriesPoint',
      '10': 'points'
    },
  ],
};

/// Descriptor for `TrendServiceGetTimeSeriesResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List trendServiceGetTimeSeriesResponseDescriptor =
    $convert.base64Decode(
        'CiFUcmVuZFNlcnZpY2VHZXRUaW1lU2VyaWVzUmVzcG9uc2USGQoIdHJlbmRfaWQYASABKAlSB3'
        'RyZW5kSWQSRAoGcG9pbnRzGAIgAygLMiwuY3JlYXRpdmFudGEuaW50ZWxsaWdlbmNlLnYxLlRp'
        'bWVTZXJpZXNQb2ludFIGcG9pbnRz');

@$core.Deprecated('Use trendServiceGetSparklinesRequestDescriptor instead')
const TrendServiceGetSparklinesRequest$json = {
  '1': 'TrendServiceGetSparklinesRequest',
  '2': [
    {
      '1': 'context',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.CommandContext',
      '10': 'context'
    },
    {'1': 'workspace_id', '3': 2, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'trend_ids', '3': 3, '4': 3, '5': 9, '10': 'trendIds'},
  ],
};

/// Descriptor for `TrendServiceGetSparklinesRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List trendServiceGetSparklinesRequestDescriptor =
    $convert.base64Decode(
        'CiBUcmVuZFNlcnZpY2VHZXRTcGFya2xpbmVzUmVxdWVzdBI/Cgdjb250ZXh0GAEgASgLMiUuY3'
        'JlYXRpdmFudGEuY29tbW9uLnYxLkNvbW1hbmRDb250ZXh0Ugdjb250ZXh0EiEKDHdvcmtzcGFj'
        'ZV9pZBgCIAEoCVILd29ya3NwYWNlSWQSGwoJdHJlbmRfaWRzGAMgAygJUgh0cmVuZElkcw==');

@$core.Deprecated('Use sparklineDataDescriptor instead')
const SparklineData$json = {
  '1': 'SparklineData',
  '2': [
    {'1': 'trend_id', '3': 1, '4': 1, '5': 9, '10': 'trendId'},
    {'1': 'values', '3': 2, '4': 3, '5': 2, '10': 'values'},
  ],
};

/// Descriptor for `SparklineData`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List sparklineDataDescriptor = $convert.base64Decode(
    'Cg1TcGFya2xpbmVEYXRhEhkKCHRyZW5kX2lkGAEgASgJUgd0cmVuZElkEhYKBnZhbHVlcxgCIA'
    'MoAlIGdmFsdWVz');

@$core.Deprecated('Use trendServiceGetSparklinesResponseDescriptor instead')
const TrendServiceGetSparklinesResponse$json = {
  '1': 'TrendServiceGetSparklinesResponse',
  '2': [
    {
      '1': 'sparklines',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.creativanta.intelligence.v1.SparklineData',
      '10': 'sparklines'
    },
  ],
};

/// Descriptor for `TrendServiceGetSparklinesResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List trendServiceGetSparklinesResponseDescriptor =
    $convert.base64Decode(
        'CiFUcmVuZFNlcnZpY2VHZXRTcGFya2xpbmVzUmVzcG9uc2USSgoKc3BhcmtsaW5lcxgBIAMoCz'
        'IqLmNyZWF0aXZhbnRhLmludGVsbGlnZW5jZS52MS5TcGFya2xpbmVEYXRhUgpzcGFya2xpbmVz');

@$core.Deprecated('Use trendServiceGetStatsRequestDescriptor instead')
const TrendServiceGetStatsRequest$json = {
  '1': 'TrendServiceGetStatsRequest',
  '2': [
    {
      '1': 'context',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.CommandContext',
      '10': 'context'
    },
    {'1': 'workspace_id', '3': 2, '4': 1, '5': 9, '10': 'workspaceId'},
  ],
};

/// Descriptor for `TrendServiceGetStatsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List trendServiceGetStatsRequestDescriptor =
    $convert.base64Decode(
        'ChtUcmVuZFNlcnZpY2VHZXRTdGF0c1JlcXVlc3QSPwoHY29udGV4dBgBIAEoCzIlLmNyZWF0aX'
        'ZhbnRhLmNvbW1vbi52MS5Db21tYW5kQ29udGV4dFIHY29udGV4dBIhCgx3b3Jrc3BhY2VfaWQY'
        'AiABKAlSC3dvcmtzcGFjZUlk');

@$core.Deprecated('Use trendServiceGetStatsResponseDescriptor instead')
const TrendServiceGetStatsResponse$json = {
  '1': 'TrendServiceGetStatsResponse',
  '2': [
    {
      '1': 'total_active_trends',
      '3': 1,
      '4': 1,
      '5': 5,
      '10': 'totalActiveTrends'
    },
    {'1': 'new_today', '3': 2, '4': 1, '5': 5, '10': 'newToday'},
    {'1': 'spiking_count', '3': 3, '4': 1, '5': 5, '10': 'spikingCount'},
    {
      '1': 'platform_distribution',
      '3': 4,
      '4': 3,
      '5': 11,
      '6':
          '.creativanta.intelligence.v1.TrendServiceGetStatsResponse.PlatformDistributionEntry',
      '10': 'platformDistribution'
    },
    {'1': 'source_degraded', '3': 5, '4': 1, '5': 8, '10': 'sourceDegraded'},
    {
      '1': 'disconnected_sources',
      '3': 6,
      '4': 3,
      '5': 9,
      '10': 'disconnectedSources'
    },
  ],
  '3': [TrendServiceGetStatsResponse_PlatformDistributionEntry$json],
};

@$core.Deprecated('Use trendServiceGetStatsResponseDescriptor instead')
const TrendServiceGetStatsResponse_PlatformDistributionEntry$json = {
  '1': 'PlatformDistributionEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {'1': 'value', '3': 2, '4': 1, '5': 5, '10': 'value'},
  ],
  '7': {'7': true},
};

/// Descriptor for `TrendServiceGetStatsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List trendServiceGetStatsResponseDescriptor = $convert.base64Decode(
    'ChxUcmVuZFNlcnZpY2VHZXRTdGF0c1Jlc3BvbnNlEi4KE3RvdGFsX2FjdGl2ZV90cmVuZHMYAS'
    'ABKAVSEXRvdGFsQWN0aXZlVHJlbmRzEhsKCW5ld190b2RheRgCIAEoBVIIbmV3VG9kYXkSIwoN'
    'c3Bpa2luZ19jb3VudBgDIAEoBVIMc3Bpa2luZ0NvdW50EogBChVwbGF0Zm9ybV9kaXN0cmlidX'
    'Rpb24YBCADKAsyUy5jcmVhdGl2YW50YS5pbnRlbGxpZ2VuY2UudjEuVHJlbmRTZXJ2aWNlR2V0'
    'U3RhdHNSZXNwb25zZS5QbGF0Zm9ybURpc3RyaWJ1dGlvbkVudHJ5UhRwbGF0Zm9ybURpc3RyaW'
    'J1dGlvbhInCg9zb3VyY2VfZGVncmFkZWQYBSABKAhSDnNvdXJjZURlZ3JhZGVkEjEKFGRpc2Nv'
    'bm5lY3RlZF9zb3VyY2VzGAYgAygJUhNkaXNjb25uZWN0ZWRTb3VyY2VzGkcKGVBsYXRmb3JtRG'
    'lzdHJpYnV0aW9uRW50cnkSEAoDa2V5GAEgASgJUgNrZXkSFAoFdmFsdWUYAiABKAVSBXZhbHVl'
    'OgI4AQ==');

@$core.Deprecated('Use trendServiceGetExamplesRequestDescriptor instead')
const TrendServiceGetExamplesRequest$json = {
  '1': 'TrendServiceGetExamplesRequest',
  '2': [
    {
      '1': 'context',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.CommandContext',
      '10': 'context'
    },
    {'1': 'workspace_id', '3': 2, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'trend_id', '3': 3, '4': 1, '5': 9, '10': 'trendId'},
  ],
};

/// Descriptor for `TrendServiceGetExamplesRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List trendServiceGetExamplesRequestDescriptor =
    $convert.base64Decode(
        'Ch5UcmVuZFNlcnZpY2VHZXRFeGFtcGxlc1JlcXVlc3QSPwoHY29udGV4dBgBIAEoCzIlLmNyZW'
        'F0aXZhbnRhLmNvbW1vbi52MS5Db21tYW5kQ29udGV4dFIHY29udGV4dBIhCgx3b3Jrc3BhY2Vf'
        'aWQYAiABKAlSC3dvcmtzcGFjZUlkEhkKCHRyZW5kX2lkGAMgASgJUgd0cmVuZElk');

@$core.Deprecated('Use trendExampleItemDescriptor instead')
const TrendExampleItem$json = {
  '1': 'TrendExampleItem',
  '2': [
    {'1': 'external_url', '3': 1, '4': 1, '5': 9, '10': 'externalUrl'},
    {'1': 'platform', '3': 2, '4': 1, '5': 9, '10': 'platform'},
    {'1': 'creator_handle', '3': 3, '4': 1, '5': 9, '10': 'creatorHandle'},
    {'1': 'caption', '3': 4, '4': 1, '5': 9, '10': 'caption'},
    {'1': 'view_count', '3': 5, '4': 1, '5': 3, '10': 'viewCount'},
  ],
};

/// Descriptor for `TrendExampleItem`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List trendExampleItemDescriptor = $convert.base64Decode(
    'ChBUcmVuZEV4YW1wbGVJdGVtEiEKDGV4dGVybmFsX3VybBgBIAEoCVILZXh0ZXJuYWxVcmwSGg'
    'oIcGxhdGZvcm0YAiABKAlSCHBsYXRmb3JtEiUKDmNyZWF0b3JfaGFuZGxlGAMgASgJUg1jcmVh'
    'dG9ySGFuZGxlEhgKB2NhcHRpb24YBCABKAlSB2NhcHRpb24SHQoKdmlld19jb3VudBgFIAEoA1'
    'IJdmlld0NvdW50');

@$core.Deprecated('Use trendServiceGetExamplesResponseDescriptor instead')
const TrendServiceGetExamplesResponse$json = {
  '1': 'TrendServiceGetExamplesResponse',
  '2': [
    {'1': 'trend_id', '3': 1, '4': 1, '5': 9, '10': 'trendId'},
    {
      '1': 'examples',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.creativanta.intelligence.v1.TrendExampleItem',
      '10': 'examples'
    },
  ],
};

/// Descriptor for `TrendServiceGetExamplesResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List trendServiceGetExamplesResponseDescriptor =
    $convert.base64Decode(
        'Ch9UcmVuZFNlcnZpY2VHZXRFeGFtcGxlc1Jlc3BvbnNlEhkKCHRyZW5kX2lkGAEgASgJUgd0cm'
        'VuZElkEkkKCGV4YW1wbGVzGAIgAygLMi0uY3JlYXRpdmFudGEuaW50ZWxsaWdlbmNlLnYxLlRy'
        'ZW5kRXhhbXBsZUl0ZW1SCGV4YW1wbGVz');

@$core.Deprecated('Use trendServiceGetAudienceFitRequestDescriptor instead')
const TrendServiceGetAudienceFitRequest$json = {
  '1': 'TrendServiceGetAudienceFitRequest',
  '2': [
    {
      '1': 'context',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.CommandContext',
      '10': 'context'
    },
    {'1': 'workspace_id', '3': 2, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'trend_id', '3': 3, '4': 1, '5': 9, '10': 'trendId'},
  ],
};

/// Descriptor for `TrendServiceGetAudienceFitRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List trendServiceGetAudienceFitRequestDescriptor =
    $convert.base64Decode(
        'CiFUcmVuZFNlcnZpY2VHZXRBdWRpZW5jZUZpdFJlcXVlc3QSPwoHY29udGV4dBgBIAEoCzIlLm'
        'NyZWF0aXZhbnRhLmNvbW1vbi52MS5Db21tYW5kQ29udGV4dFIHY29udGV4dBIhCgx3b3Jrc3Bh'
        'Y2VfaWQYAiABKAlSC3dvcmtzcGFjZUlkEhkKCHRyZW5kX2lkGAMgASgJUgd0cmVuZElk');

@$core.Deprecated('Use trendServiceGetAudienceFitResponseDescriptor instead')
const TrendServiceGetAudienceFitResponse$json = {
  '1': 'TrendServiceGetAudienceFitResponse',
  '2': [
    {'1': 'trend_id', '3': 1, '4': 1, '5': 9, '10': 'trendId'},
    {'1': 'fit_score', '3': 2, '4': 1, '5': 2, '10': 'fitScore'},
    {'1': 'rationale', '3': 3, '4': 1, '5': 9, '10': 'rationale'},
    {'1': 'suggested_angles', '3': 4, '4': 3, '5': 9, '10': 'suggestedAngles'},
  ],
};

/// Descriptor for `TrendServiceGetAudienceFitResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List trendServiceGetAudienceFitResponseDescriptor =
    $convert.base64Decode(
        'CiJUcmVuZFNlcnZpY2VHZXRBdWRpZW5jZUZpdFJlc3BvbnNlEhkKCHRyZW5kX2lkGAEgASgJUg'
        'd0cmVuZElkEhsKCWZpdF9zY29yZRgCIAEoAlIIZml0U2NvcmUSHAoJcmF0aW9uYWxlGAMgASgJ'
        'UglyYXRpb25hbGUSKQoQc3VnZ2VzdGVkX2FuZ2xlcxgEIAMoCVIPc3VnZ2VzdGVkQW5nbGVz');

@$core.Deprecated('Use watchlistServiceCreateRequestDescriptor instead')
const WatchlistServiceCreateRequest$json = {
  '1': 'WatchlistServiceCreateRequest',
  '2': [
    {
      '1': 'context',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.CommandContext',
      '10': 'context'
    },
    {'1': 'workspace_id', '3': 2, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'name', '3': 3, '4': 1, '5': 9, '10': 'name'},
    {'1': 'type', '3': 4, '4': 1, '5': 9, '10': 'type'},
    {'1': 'criteria_json', '3': 5, '4': 1, '5': 9, '10': 'criteriaJson'},
    {'1': 'alert_enabled', '3': 6, '4': 1, '5': 8, '10': 'alertEnabled'},
    {
      '1': 'alert_threshold',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.creativanta.intelligence.v1.AlertThreshold',
      '10': 'alertThreshold'
    },
  ],
};

/// Descriptor for `WatchlistServiceCreateRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List watchlistServiceCreateRequestDescriptor = $convert.base64Decode(
    'Ch1XYXRjaGxpc3RTZXJ2aWNlQ3JlYXRlUmVxdWVzdBI/Cgdjb250ZXh0GAEgASgLMiUuY3JlYX'
    'RpdmFudGEuY29tbW9uLnYxLkNvbW1hbmRDb250ZXh0Ugdjb250ZXh0EiEKDHdvcmtzcGFjZV9p'
    'ZBgCIAEoCVILd29ya3NwYWNlSWQSEgoEbmFtZRgDIAEoCVIEbmFtZRISCgR0eXBlGAQgASgJUg'
    'R0eXBlEiMKDWNyaXRlcmlhX2pzb24YBSABKAlSDGNyaXRlcmlhSnNvbhIjCg1hbGVydF9lbmFi'
    'bGVkGAYgASgIUgxhbGVydEVuYWJsZWQSVAoPYWxlcnRfdGhyZXNob2xkGAcgASgLMisuY3JlYX'
    'RpdmFudGEuaW50ZWxsaWdlbmNlLnYxLkFsZXJ0VGhyZXNob2xkUg5hbGVydFRocmVzaG9sZA==');

@$core.Deprecated('Use watchlistServiceCreateResponseDescriptor instead')
const WatchlistServiceCreateResponse$json = {
  '1': 'WatchlistServiceCreateResponse',
  '2': [
    {
      '1': 'watchlist',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.intelligence.v1.Watchlist',
      '10': 'watchlist'
    },
  ],
};

/// Descriptor for `WatchlistServiceCreateResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List watchlistServiceCreateResponseDescriptor =
    $convert.base64Decode(
        'Ch5XYXRjaGxpc3RTZXJ2aWNlQ3JlYXRlUmVzcG9uc2USRAoJd2F0Y2hsaXN0GAEgASgLMiYuY3'
        'JlYXRpdmFudGEuaW50ZWxsaWdlbmNlLnYxLldhdGNobGlzdFIJd2F0Y2hsaXN0');

@$core.Deprecated('Use watchlistServiceListRequestDescriptor instead')
const WatchlistServiceListRequest$json = {
  '1': 'WatchlistServiceListRequest',
  '2': [
    {
      '1': 'context',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.CommandContext',
      '10': 'context'
    },
    {'1': 'workspace_id', '3': 2, '4': 1, '5': 9, '10': 'workspaceId'},
    {
      '1': 'pagination',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.Pagination',
      '10': 'pagination'
    },
  ],
};

/// Descriptor for `WatchlistServiceListRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List watchlistServiceListRequestDescriptor = $convert.base64Decode(
    'ChtXYXRjaGxpc3RTZXJ2aWNlTGlzdFJlcXVlc3QSPwoHY29udGV4dBgBIAEoCzIlLmNyZWF0aX'
    'ZhbnRhLmNvbW1vbi52MS5Db21tYW5kQ29udGV4dFIHY29udGV4dBIhCgx3b3Jrc3BhY2VfaWQY'
    'AiABKAlSC3dvcmtzcGFjZUlkEkEKCnBhZ2luYXRpb24YAyABKAsyIS5jcmVhdGl2YW50YS5jb2'
    '1tb24udjEuUGFnaW5hdGlvblIKcGFnaW5hdGlvbg==');

@$core.Deprecated('Use watchlistServiceListResponseDescriptor instead')
const WatchlistServiceListResponse$json = {
  '1': 'WatchlistServiceListResponse',
  '2': [
    {
      '1': 'watchlists',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.creativanta.intelligence.v1.Watchlist',
      '10': 'watchlists'
    },
    {
      '1': 'pagination',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.Pagination',
      '10': 'pagination'
    },
  ],
};

/// Descriptor for `WatchlistServiceListResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List watchlistServiceListResponseDescriptor = $convert.base64Decode(
    'ChxXYXRjaGxpc3RTZXJ2aWNlTGlzdFJlc3BvbnNlEkYKCndhdGNobGlzdHMYASADKAsyJi5jcm'
    'VhdGl2YW50YS5pbnRlbGxpZ2VuY2UudjEuV2F0Y2hsaXN0Ugp3YXRjaGxpc3RzEkEKCnBhZ2lu'
    'YXRpb24YAiABKAsyIS5jcmVhdGl2YW50YS5jb21tb24udjEuUGFnaW5hdGlvblIKcGFnaW5hdG'
    'lvbg==');

@$core.Deprecated('Use watchlistServiceDeleteRequestDescriptor instead')
const WatchlistServiceDeleteRequest$json = {
  '1': 'WatchlistServiceDeleteRequest',
  '2': [
    {
      '1': 'context',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.CommandContext',
      '10': 'context'
    },
    {'1': 'workspace_id', '3': 2, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'watchlist_id', '3': 3, '4': 1, '5': 9, '10': 'watchlistId'},
  ],
};

/// Descriptor for `WatchlistServiceDeleteRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List watchlistServiceDeleteRequestDescriptor = $convert.base64Decode(
    'Ch1XYXRjaGxpc3RTZXJ2aWNlRGVsZXRlUmVxdWVzdBI/Cgdjb250ZXh0GAEgASgLMiUuY3JlYX'
    'RpdmFudGEuY29tbW9uLnYxLkNvbW1hbmRDb250ZXh0Ugdjb250ZXh0EiEKDHdvcmtzcGFjZV9p'
    'ZBgCIAEoCVILd29ya3NwYWNlSWQSIQoMd2F0Y2hsaXN0X2lkGAMgASgJUgt3YXRjaGxpc3RJZA'
    '==');

@$core.Deprecated('Use watchlistServiceDeleteResponseDescriptor instead')
const WatchlistServiceDeleteResponse$json = {
  '1': 'WatchlistServiceDeleteResponse',
  '2': [
    {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
  ],
};

/// Descriptor for `WatchlistServiceDeleteResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List watchlistServiceDeleteResponseDescriptor =
    $convert.base64Decode(
        'Ch5XYXRjaGxpc3RTZXJ2aWNlRGVsZXRlUmVzcG9uc2USGAoHc3VjY2VzcxgBIAEoCFIHc3VjY2'
        'Vzcw==');

@$core.Deprecated('Use watchlistServiceUpdateRequestDescriptor instead')
const WatchlistServiceUpdateRequest$json = {
  '1': 'WatchlistServiceUpdateRequest',
  '2': [
    {
      '1': 'context',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.CommandContext',
      '10': 'context'
    },
    {'1': 'workspace_id', '3': 2, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'watchlist_id', '3': 3, '4': 1, '5': 9, '10': 'watchlistId'},
    {'1': 'name', '3': 4, '4': 1, '5': 9, '10': 'name'},
    {'1': 'criteria_json', '3': 5, '4': 1, '5': 9, '10': 'criteriaJson'},
    {'1': 'alert_enabled', '3': 6, '4': 1, '5': 8, '10': 'alertEnabled'},
    {
      '1': 'alert_threshold',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.creativanta.intelligence.v1.AlertThreshold',
      '10': 'alertThreshold'
    },
  ],
};

/// Descriptor for `WatchlistServiceUpdateRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List watchlistServiceUpdateRequestDescriptor = $convert.base64Decode(
    'Ch1XYXRjaGxpc3RTZXJ2aWNlVXBkYXRlUmVxdWVzdBI/Cgdjb250ZXh0GAEgASgLMiUuY3JlYX'
    'RpdmFudGEuY29tbW9uLnYxLkNvbW1hbmRDb250ZXh0Ugdjb250ZXh0EiEKDHdvcmtzcGFjZV9p'
    'ZBgCIAEoCVILd29ya3NwYWNlSWQSIQoMd2F0Y2hsaXN0X2lkGAMgASgJUgt3YXRjaGxpc3RJZB'
    'ISCgRuYW1lGAQgASgJUgRuYW1lEiMKDWNyaXRlcmlhX2pzb24YBSABKAlSDGNyaXRlcmlhSnNv'
    'bhIjCg1hbGVydF9lbmFibGVkGAYgASgIUgxhbGVydEVuYWJsZWQSVAoPYWxlcnRfdGhyZXNob2'
    'xkGAcgASgLMisuY3JlYXRpdmFudGEuaW50ZWxsaWdlbmNlLnYxLkFsZXJ0VGhyZXNob2xkUg5h'
    'bGVydFRocmVzaG9sZA==');

@$core.Deprecated('Use watchlistServiceUpdateResponseDescriptor instead')
const WatchlistServiceUpdateResponse$json = {
  '1': 'WatchlistServiceUpdateResponse',
  '2': [
    {
      '1': 'watchlist',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.intelligence.v1.Watchlist',
      '10': 'watchlist'
    },
  ],
};

/// Descriptor for `WatchlistServiceUpdateResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List watchlistServiceUpdateResponseDescriptor =
    $convert.base64Decode(
        'Ch5XYXRjaGxpc3RTZXJ2aWNlVXBkYXRlUmVzcG9uc2USRAoJd2F0Y2hsaXN0GAEgASgLMiYuY3'
        'JlYXRpdmFudGEuaW50ZWxsaWdlbmNlLnYxLldhdGNobGlzdFIJd2F0Y2hsaXN0');

@$core.Deprecated('Use watchlistServiceAddItemRequestDescriptor instead')
const WatchlistServiceAddItemRequest$json = {
  '1': 'WatchlistServiceAddItemRequest',
  '2': [
    {
      '1': 'context',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.CommandContext',
      '10': 'context'
    },
    {'1': 'workspace_id', '3': 2, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'watchlist_id', '3': 3, '4': 1, '5': 9, '10': 'watchlistId'},
    {'1': 'trend_id', '3': 4, '4': 1, '5': 9, '10': 'trendId'},
  ],
};

/// Descriptor for `WatchlistServiceAddItemRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List watchlistServiceAddItemRequestDescriptor =
    $convert.base64Decode(
        'Ch5XYXRjaGxpc3RTZXJ2aWNlQWRkSXRlbVJlcXVlc3QSPwoHY29udGV4dBgBIAEoCzIlLmNyZW'
        'F0aXZhbnRhLmNvbW1vbi52MS5Db21tYW5kQ29udGV4dFIHY29udGV4dBIhCgx3b3Jrc3BhY2Vf'
        'aWQYAiABKAlSC3dvcmtzcGFjZUlkEiEKDHdhdGNobGlzdF9pZBgDIAEoCVILd2F0Y2hsaXN0SW'
        'QSGQoIdHJlbmRfaWQYBCABKAlSB3RyZW5kSWQ=');

@$core.Deprecated('Use watchlistServiceAddItemResponseDescriptor instead')
const WatchlistServiceAddItemResponse$json = {
  '1': 'WatchlistServiceAddItemResponse',
  '2': [
    {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
    {'1': 'item_count', '3': 2, '4': 1, '5': 5, '10': 'itemCount'},
  ],
};

/// Descriptor for `WatchlistServiceAddItemResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List watchlistServiceAddItemResponseDescriptor =
    $convert.base64Decode(
        'Ch9XYXRjaGxpc3RTZXJ2aWNlQWRkSXRlbVJlc3BvbnNlEhgKB3N1Y2Nlc3MYASABKAhSB3N1Y2'
        'Nlc3MSHQoKaXRlbV9jb3VudBgCIAEoBVIJaXRlbUNvdW50');

@$core.Deprecated('Use watchlistServiceRemoveItemRequestDescriptor instead')
const WatchlistServiceRemoveItemRequest$json = {
  '1': 'WatchlistServiceRemoveItemRequest',
  '2': [
    {
      '1': 'context',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.CommandContext',
      '10': 'context'
    },
    {'1': 'workspace_id', '3': 2, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'watchlist_id', '3': 3, '4': 1, '5': 9, '10': 'watchlistId'},
    {'1': 'trend_id', '3': 4, '4': 1, '5': 9, '10': 'trendId'},
  ],
};

/// Descriptor for `WatchlistServiceRemoveItemRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List watchlistServiceRemoveItemRequestDescriptor =
    $convert.base64Decode(
        'CiFXYXRjaGxpc3RTZXJ2aWNlUmVtb3ZlSXRlbVJlcXVlc3QSPwoHY29udGV4dBgBIAEoCzIlLm'
        'NyZWF0aXZhbnRhLmNvbW1vbi52MS5Db21tYW5kQ29udGV4dFIHY29udGV4dBIhCgx3b3Jrc3Bh'
        'Y2VfaWQYAiABKAlSC3dvcmtzcGFjZUlkEiEKDHdhdGNobGlzdF9pZBgDIAEoCVILd2F0Y2hsaX'
        'N0SWQSGQoIdHJlbmRfaWQYBCABKAlSB3RyZW5kSWQ=');

@$core.Deprecated('Use watchlistServiceRemoveItemResponseDescriptor instead')
const WatchlistServiceRemoveItemResponse$json = {
  '1': 'WatchlistServiceRemoveItemResponse',
  '2': [
    {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
    {'1': 'item_count', '3': 2, '4': 1, '5': 5, '10': 'itemCount'},
  ],
};

/// Descriptor for `WatchlistServiceRemoveItemResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List watchlistServiceRemoveItemResponseDescriptor =
    $convert.base64Decode(
        'CiJXYXRjaGxpc3RTZXJ2aWNlUmVtb3ZlSXRlbVJlc3BvbnNlEhgKB3N1Y2Nlc3MYASABKAhSB3'
        'N1Y2Nlc3MSHQoKaXRlbV9jb3VudBgCIAEoBVIJaXRlbUNvdW50');

@$core.Deprecated('Use watchlistServiceGetItemsRequestDescriptor instead')
const WatchlistServiceGetItemsRequest$json = {
  '1': 'WatchlistServiceGetItemsRequest',
  '2': [
    {
      '1': 'context',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.CommandContext',
      '10': 'context'
    },
    {'1': 'workspace_id', '3': 2, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'watchlist_id', '3': 3, '4': 1, '5': 9, '10': 'watchlistId'},
    {
      '1': 'pagination',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.Pagination',
      '10': 'pagination'
    },
  ],
};

/// Descriptor for `WatchlistServiceGetItemsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List watchlistServiceGetItemsRequestDescriptor = $convert.base64Decode(
    'Ch9XYXRjaGxpc3RTZXJ2aWNlR2V0SXRlbXNSZXF1ZXN0Ej8KB2NvbnRleHQYASABKAsyJS5jcm'
    'VhdGl2YW50YS5jb21tb24udjEuQ29tbWFuZENvbnRleHRSB2NvbnRleHQSIQoMd29ya3NwYWNl'
    'X2lkGAIgASgJUgt3b3Jrc3BhY2VJZBIhCgx3YXRjaGxpc3RfaWQYAyABKAlSC3dhdGNobGlzdE'
    'lkEkEKCnBhZ2luYXRpb24YBCABKAsyIS5jcmVhdGl2YW50YS5jb21tb24udjEuUGFnaW5hdGlv'
    'blIKcGFnaW5hdGlvbg==');

@$core.Deprecated('Use watchlistServiceGetItemsResponseDescriptor instead')
const WatchlistServiceGetItemsResponse$json = {
  '1': 'WatchlistServiceGetItemsResponse',
  '2': [
    {'1': 'watchlist_id', '3': 1, '4': 1, '5': 9, '10': 'watchlistId'},
    {
      '1': 'items',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.creativanta.intelligence.v1.Trend',
      '10': 'items'
    },
    {
      '1': 'pagination',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.Pagination',
      '10': 'pagination'
    },
  ],
};

/// Descriptor for `WatchlistServiceGetItemsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List watchlistServiceGetItemsResponseDescriptor =
    $convert.base64Decode(
        'CiBXYXRjaGxpc3RTZXJ2aWNlR2V0SXRlbXNSZXNwb25zZRIhCgx3YXRjaGxpc3RfaWQYASABKA'
        'lSC3dhdGNobGlzdElkEjgKBWl0ZW1zGAIgAygLMiIuY3JlYXRpdmFudGEuaW50ZWxsaWdlbmNl'
        'LnYxLlRyZW5kUgVpdGVtcxJBCgpwYWdpbmF0aW9uGAMgASgLMiEuY3JlYXRpdmFudGEuY29tbW'
        '9uLnYxLlBhZ2luYXRpb25SCnBhZ2luYXRpb24=');

@$core.Deprecated('Use watchlistServiceMuteItemRequestDescriptor instead')
const WatchlistServiceMuteItemRequest$json = {
  '1': 'WatchlistServiceMuteItemRequest',
  '2': [
    {
      '1': 'context',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.CommandContext',
      '10': 'context'
    },
    {'1': 'workspace_id', '3': 2, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'watchlist_id', '3': 3, '4': 1, '5': 9, '10': 'watchlistId'},
    {'1': 'trend_id', '3': 4, '4': 1, '5': 9, '10': 'trendId'},
    {'1': 'mute_hours', '3': 5, '4': 1, '5': 5, '10': 'muteHours'},
  ],
};

/// Descriptor for `WatchlistServiceMuteItemRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List watchlistServiceMuteItemRequestDescriptor = $convert.base64Decode(
    'Ch9XYXRjaGxpc3RTZXJ2aWNlTXV0ZUl0ZW1SZXF1ZXN0Ej8KB2NvbnRleHQYASABKAsyJS5jcm'
    'VhdGl2YW50YS5jb21tb24udjEuQ29tbWFuZENvbnRleHRSB2NvbnRleHQSIQoMd29ya3NwYWNl'
    'X2lkGAIgASgJUgt3b3Jrc3BhY2VJZBIhCgx3YXRjaGxpc3RfaWQYAyABKAlSC3dhdGNobGlzdE'
    'lkEhkKCHRyZW5kX2lkGAQgASgJUgd0cmVuZElkEh0KCm11dGVfaG91cnMYBSABKAVSCW11dGVI'
    'b3Vycw==');

@$core.Deprecated('Use watchlistServiceMuteItemResponseDescriptor instead')
const WatchlistServiceMuteItemResponse$json = {
  '1': 'WatchlistServiceMuteItemResponse',
  '2': [
    {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
    {
      '1': 'muted_until',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'mutedUntil'
    },
  ],
};

/// Descriptor for `WatchlistServiceMuteItemResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List watchlistServiceMuteItemResponseDescriptor =
    $convert.base64Decode(
        'CiBXYXRjaGxpc3RTZXJ2aWNlTXV0ZUl0ZW1SZXNwb25zZRIYCgdzdWNjZXNzGAEgASgIUgdzdW'
        'NjZXNzEjsKC211dGVkX3VudGlsGAIgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIK'
        'bXV0ZWRVbnRpbA==');

// This is a generated file - do not edit.
//
// Generated from creativanta/intelligence/v1/competitor.proto.

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

@$core.Deprecated('Use alertDirectionDescriptor instead')
const AlertDirection$json = {
  '1': 'AlertDirection',
  '2': [
    {'1': 'ALERT_DIRECTION_UNSPECIFIED', '2': 0},
    {'1': 'ALERT_DIRECTION_ABOVE', '2': 1},
    {'1': 'ALERT_DIRECTION_BELOW', '2': 2},
  ],
};

/// Descriptor for `AlertDirection`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List alertDirectionDescriptor = $convert.base64Decode(
    'Cg5BbGVydERpcmVjdGlvbhIfChtBTEVSVF9ESVJFQ1RJT05fVU5TUEVDSUZJRUQQABIZChVBTE'
    'VSVF9ESVJFQ1RJT05fQUJPVkUQARIZChVBTEVSVF9ESVJFQ1RJT05fQkVMT1cQAg==');

@$core.Deprecated('Use alertMetricDescriptor instead')
const AlertMetric$json = {
  '1': 'AlertMetric',
  '2': [
    {'1': 'ALERT_METRIC_UNSPECIFIED', '2': 0},
    {'1': 'ALERT_METRIC_ENGAGEMENT_RATE', '2': 1},
    {'1': 'ALERT_METRIC_POST_FREQUENCY', '2': 2},
    {'1': 'ALERT_METRIC_OBSERVED_PRICE', '2': 3},
  ],
};

/// Descriptor for `AlertMetric`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List alertMetricDescriptor = $convert.base64Decode(
    'CgtBbGVydE1ldHJpYxIcChhBTEVSVF9NRVRSSUNfVU5TUEVDSUZJRUQQABIgChxBTEVSVF9NRV'
    'RSSUNfRU5HQUdFTUVOVF9SQVRFEAESHwobQUxFUlRfTUVUUklDX1BPU1RfRlJFUVVFTkNZEAIS'
    'HwobQUxFUlRfTUVUUklDX09CU0VSVkVEX1BSSUNFEAM=');

@$core.Deprecated('Use alertConfigDescriptor instead')
const AlertConfig$json = {
  '1': 'AlertConfig',
  '2': [
    {'1': 'enabled', '3': 1, '4': 1, '5': 8, '10': 'enabled'},
    {
      '1': 'metric',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.creativanta.intelligence.v1.AlertMetric',
      '10': 'metric'
    },
    {'1': 'threshold', '3': 3, '4': 1, '5': 1, '10': 'threshold'},
    {
      '1': 'direction',
      '3': 4,
      '4': 1,
      '5': 14,
      '6': '.creativanta.intelligence.v1.AlertDirection',
      '10': 'direction'
    },
    {
      '1': 'min_interval_minutes',
      '3': 5,
      '4': 1,
      '5': 5,
      '10': 'minIntervalMinutes'
    },
  ],
};

/// Descriptor for `AlertConfig`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List alertConfigDescriptor = $convert.base64Decode(
    'CgtBbGVydENvbmZpZxIYCgdlbmFibGVkGAEgASgIUgdlbmFibGVkEkAKBm1ldHJpYxgCIAEoDj'
    'IoLmNyZWF0aXZhbnRhLmludGVsbGlnZW5jZS52MS5BbGVydE1ldHJpY1IGbWV0cmljEhwKCXRo'
    'cmVzaG9sZBgDIAEoAVIJdGhyZXNob2xkEkkKCWRpcmVjdGlvbhgEIAEoDjIrLmNyZWF0aXZhbn'
    'RhLmludGVsbGlnZW5jZS52MS5BbGVydERpcmVjdGlvblIJZGlyZWN0aW9uEjAKFG1pbl9pbnRl'
    'cnZhbF9taW51dGVzGAUgASgFUhJtaW5JbnRlcnZhbE1pbnV0ZXM=');

@$core.Deprecated('Use competitorEntityDescriptor instead')
const CompetitorEntity$json = {
  '1': 'CompetitorEntity',
  '2': [
    {'1': 'competitor_id', '3': 1, '4': 1, '5': 9, '10': 'competitorId'},
    {'1': 'workspace_id', '3': 2, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'name', '3': 3, '4': 1, '5': 9, '10': 'name'},
    {'1': 'platform', '3': 4, '4': 1, '5': 9, '10': 'platform'},
    {'1': 'external_handle', '3': 5, '4': 1, '5': 9, '10': 'externalHandle'},
    {'1': 'category', '3': 6, '4': 1, '5': 9, '10': 'category'},
    {'1': 'notes', '3': 7, '4': 1, '5': 9, '10': 'notes'},
    {'1': 'relevance_score', '3': 8, '4': 1, '5': 2, '10': 'relevanceScore'},
    {'1': 'relevance_reason', '3': 9, '4': 1, '5': 9, '10': 'relevanceReason'},
    {'1': 'followers_count', '3': 10, '4': 1, '5': 3, '10': 'followersCount'},
    {'1': 'video_count_30d', '3': 11, '4': 1, '5': 5, '10': 'videoCount30d'},
    {'1': 'avg_views', '3': 12, '4': 1, '5': 3, '10': 'avgViews'},
    {'1': 'growth_rate_30d', '3': 13, '4': 1, '5': 2, '10': 'growthRate30d'},
    {
      '1': 'avg_engagement_rate',
      '3': 14,
      '4': 1,
      '5': 2,
      '10': 'avgEngagementRate'
    },
    {
      '1': 'posting_frequency_per_day',
      '3': 15,
      '4': 1,
      '5': 2,
      '10': 'postingFrequencyPerDay'
    },
    {
      '1': 'last_post_at',
      '3': 16,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'lastPostAt'
    },
    {'1': 'status', '3': 17, '4': 1, '5': 9, '10': 'status'},
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
    {
      '1': 'alert_config',
      '3': 20,
      '4': 1,
      '5': 11,
      '6': '.creativanta.intelligence.v1.AlertConfig',
      '10': 'alertConfig'
    },
  ],
};

/// Descriptor for `CompetitorEntity`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List competitorEntityDescriptor = $convert.base64Decode(
    'ChBDb21wZXRpdG9yRW50aXR5EiMKDWNvbXBldGl0b3JfaWQYASABKAlSDGNvbXBldGl0b3JJZB'
    'IhCgx3b3Jrc3BhY2VfaWQYAiABKAlSC3dvcmtzcGFjZUlkEhIKBG5hbWUYAyABKAlSBG5hbWUS'
    'GgoIcGxhdGZvcm0YBCABKAlSCHBsYXRmb3JtEicKD2V4dGVybmFsX2hhbmRsZRgFIAEoCVIOZX'
    'h0ZXJuYWxIYW5kbGUSGgoIY2F0ZWdvcnkYBiABKAlSCGNhdGVnb3J5EhQKBW5vdGVzGAcgASgJ'
    'UgVub3RlcxInCg9yZWxldmFuY2Vfc2NvcmUYCCABKAJSDnJlbGV2YW5jZVNjb3JlEikKEHJlbG'
    'V2YW5jZV9yZWFzb24YCSABKAlSD3JlbGV2YW5jZVJlYXNvbhInCg9mb2xsb3dlcnNfY291bnQY'
    'CiABKANSDmZvbGxvd2Vyc0NvdW50EiYKD3ZpZGVvX2NvdW50XzMwZBgLIAEoBVINdmlkZW9Db3'
    'VudDMwZBIbCglhdmdfdmlld3MYDCABKANSCGF2Z1ZpZXdzEiYKD2dyb3d0aF9yYXRlXzMwZBgN'
    'IAEoAlINZ3Jvd3RoUmF0ZTMwZBIuChNhdmdfZW5nYWdlbWVudF9yYXRlGA4gASgCUhFhdmdFbm'
    'dhZ2VtZW50UmF0ZRI5Chlwb3N0aW5nX2ZyZXF1ZW5jeV9wZXJfZGF5GA8gASgCUhZwb3N0aW5n'
    'RnJlcXVlbmN5UGVyRGF5EjwKDGxhc3RfcG9zdF9hdBgQIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi'
    '5UaW1lc3RhbXBSCmxhc3RQb3N0QXQSFgoGc3RhdHVzGBEgASgJUgZzdGF0dXMSOQoKY3JlYXRl'
    'ZF9hdBgSIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSCWNyZWF0ZWRBdBI5Cgp1cG'
    'RhdGVkX2F0GBMgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIJdXBkYXRlZEF0EksK'
    'DGFsZXJ0X2NvbmZpZxgUIAEoCzIoLmNyZWF0aXZhbnRhLmludGVsbGlnZW5jZS52MS5BbGVydE'
    'NvbmZpZ1ILYWxlcnRDb25maWc=');

@$core.Deprecated('Use competitorSuggestionDescriptor instead')
const CompetitorSuggestion$json = {
  '1': 'CompetitorSuggestion',
  '2': [
    {'1': 'suggestion_id', '3': 1, '4': 1, '5': 9, '10': 'suggestionId'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    {'1': 'platform', '3': 3, '4': 1, '5': 9, '10': 'platform'},
    {'1': 'external_handle', '3': 4, '4': 1, '5': 9, '10': 'externalHandle'},
    {'1': 'followers_count', '3': 5, '4': 1, '5': 3, '10': 'followersCount'},
    {'1': 'relevance_score', '3': 6, '4': 1, '5': 2, '10': 'relevanceScore'},
    {'1': 'ai_explanation', '3': 7, '4': 1, '5': 9, '10': 'aiExplanation'},
    {'1': 'category', '3': 8, '4': 1, '5': 9, '10': 'category'},
    {'1': 'is_dismissed', '3': 9, '4': 1, '5': 8, '10': 'isDismissed'},
  ],
};

/// Descriptor for `CompetitorSuggestion`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List competitorSuggestionDescriptor = $convert.base64Decode(
    'ChRDb21wZXRpdG9yU3VnZ2VzdGlvbhIjCg1zdWdnZXN0aW9uX2lkGAEgASgJUgxzdWdnZXN0aW'
    '9uSWQSEgoEbmFtZRgCIAEoCVIEbmFtZRIaCghwbGF0Zm9ybRgDIAEoCVIIcGxhdGZvcm0SJwoP'
    'ZXh0ZXJuYWxfaGFuZGxlGAQgASgJUg5leHRlcm5hbEhhbmRsZRInCg9mb2xsb3dlcnNfY291bn'
    'QYBSABKANSDmZvbGxvd2Vyc0NvdW50EicKD3JlbGV2YW5jZV9zY29yZRgGIAEoAlIOcmVsZXZh'
    'bmNlU2NvcmUSJQoOYWlfZXhwbGFuYXRpb24YByABKAlSDWFpRXhwbGFuYXRpb24SGgoIY2F0ZW'
    'dvcnkYCCABKAlSCGNhdGVnb3J5EiEKDGlzX2Rpc21pc3NlZBgJIAEoCFILaXNEaXNtaXNzZWQ=');

@$core.Deprecated('Use whyExplanationDescriptor instead')
const WhyExplanation$json = {
  '1': 'WhyExplanation',
  '2': [
    {'1': 'data_sources', '3': 1, '4': 3, '5': 9, '10': 'dataSources'},
    {'1': 'limitations', '3': 2, '4': 3, '5': 9, '10': 'limitations'},
    {'1': 'data_gaps', '3': 3, '4': 3, '5': 9, '10': 'dataGaps'},
    {'1': 'basis_summary', '3': 4, '4': 1, '5': 9, '10': 'basisSummary'},
  ],
};

/// Descriptor for `WhyExplanation`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List whyExplanationDescriptor = $convert.base64Decode(
    'Cg5XaHlFeHBsYW5hdGlvbhIhCgxkYXRhX3NvdXJjZXMYASADKAlSC2RhdGFTb3VyY2VzEiAKC2'
    'xpbWl0YXRpb25zGAIgAygJUgtsaW1pdGF0aW9ucxIbCglkYXRhX2dhcHMYAyADKAlSCGRhdGFH'
    'YXBzEiMKDWJhc2lzX3N1bW1hcnkYBCABKAlSDGJhc2lzU3VtbWFyeQ==');

@$core.Deprecated('Use benchmarkMetricsDescriptor instead')
const BenchmarkMetrics$json = {
  '1': 'BenchmarkMetrics',
  '2': [
    {
      '1': 'content_frequency_per_week',
      '3': 1,
      '4': 1,
      '5': 2,
      '10': 'contentFrequencyPerWeek'
    },
    {'1': 'engagement_rate', '3': 2, '4': 1, '5': 2, '10': 'engagementRate'},
    {'1': 'avg_views', '3': 3, '4': 1, '5': 3, '10': 'avgViews'},
    {
      '1': 'format_distribution',
      '3': 4,
      '4': 3,
      '5': 11,
      '6':
          '.creativanta.intelligence.v1.BenchmarkMetrics.FormatDistributionEntry',
      '10': 'formatDistribution'
    },
    {
      '1': 'observed_price_range',
      '3': 5,
      '4': 1,
      '5': 9,
      '10': 'observedPriceRange'
    },
    {'1': 'offer_types', '3': 6, '4': 3, '5': 9, '10': 'offerTypes'},
    {'1': 'follower_count', '3': 7, '4': 1, '5': 3, '10': 'followerCount'},
    {
      '1': 'follower_growth_pct',
      '3': 8,
      '4': 1,
      '5': 2,
      '10': 'followerGrowthPct'
    },
  ],
  '3': [BenchmarkMetrics_FormatDistributionEntry$json],
};

@$core.Deprecated('Use benchmarkMetricsDescriptor instead')
const BenchmarkMetrics_FormatDistributionEntry$json = {
  '1': 'FormatDistributionEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {'1': 'value', '3': 2, '4': 1, '5': 2, '10': 'value'},
  ],
  '7': {'7': true},
};

/// Descriptor for `BenchmarkMetrics`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List benchmarkMetricsDescriptor = $convert.base64Decode(
    'ChBCZW5jaG1hcmtNZXRyaWNzEjsKGmNvbnRlbnRfZnJlcXVlbmN5X3Blcl93ZWVrGAEgASgCUh'
    'djb250ZW50RnJlcXVlbmN5UGVyV2VlaxInCg9lbmdhZ2VtZW50X3JhdGUYAiABKAJSDmVuZ2Fn'
    'ZW1lbnRSYXRlEhsKCWF2Z192aWV3cxgDIAEoA1IIYXZnVmlld3MSdgoTZm9ybWF0X2Rpc3RyaW'
    'J1dGlvbhgEIAMoCzJFLmNyZWF0aXZhbnRhLmludGVsbGlnZW5jZS52MS5CZW5jaG1hcmtNZXRy'
    'aWNzLkZvcm1hdERpc3RyaWJ1dGlvbkVudHJ5UhJmb3JtYXREaXN0cmlidXRpb24SMAoUb2JzZX'
    'J2ZWRfcHJpY2VfcmFuZ2UYBSABKAlSEm9ic2VydmVkUHJpY2VSYW5nZRIfCgtvZmZlcl90eXBl'
    'cxgGIAMoCVIKb2ZmZXJUeXBlcxIlCg5mb2xsb3dlcl9jb3VudBgHIAEoA1INZm9sbG93ZXJDb3'
    'VudBIuChNmb2xsb3dlcl9ncm93dGhfcGN0GAggASgCUhFmb2xsb3dlckdyb3d0aFBjdBpFChdG'
    'b3JtYXREaXN0cmlidXRpb25FbnRyeRIQCgNrZXkYASABKAlSA2tleRIUCgV2YWx1ZRgCIAEoAl'
    'IFdmFsdWU6AjgB');

@$core.Deprecated('Use benchmarkSnapshotDescriptor instead')
const BenchmarkSnapshot$json = {
  '1': 'BenchmarkSnapshot',
  '2': [
    {'1': 'snapshot_id', '3': 1, '4': 1, '5': 9, '10': 'snapshotId'},
    {'1': 'workspace_id', '3': 2, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'competitor_id', '3': 3, '4': 1, '5': 9, '10': 'competitorId'},
    {'1': 'snapshot_type', '3': 4, '4': 1, '5': 9, '10': 'snapshotType'},
    {'1': 'data_period_start', '3': 5, '4': 1, '5': 9, '10': 'dataPeriodStart'},
    {'1': 'data_period_end', '3': 6, '4': 1, '5': 9, '10': 'dataPeriodEnd'},
    {
      '1': 'metrics',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.creativanta.intelligence.v1.BenchmarkMetrics',
      '10': 'metrics'
    },
    {
      '1': 'source_class',
      '3': 8,
      '4': 1,
      '5': 14,
      '6': '.creativanta.intelligence.v1.SourceClass',
      '10': 'sourceClass'
    },
    {
      '1': 'confidence',
      '3': 9,
      '4': 1,
      '5': 14,
      '6': '.creativanta.intelligence.v1.ConfidenceBand',
      '10': 'confidence'
    },
    {
      '1': 'captured_at',
      '3': 10,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'capturedAt'
    },
    {
      '1': 'created_at',
      '3': 11,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'createdAt'
    },
    {'1': 'is_stale', '3': 12, '4': 1, '5': 8, '10': 'isStale'},
    {'1': 'stale_warning', '3': 13, '4': 1, '5': 9, '10': 'staleWarning'},
    {
      '1': 'days_since_capture',
      '3': 14,
      '4': 1,
      '5': 5,
      '10': 'daysSinceCapture'
    },
    {
      '1': 'why_explanation',
      '3': 15,
      '4': 1,
      '5': 11,
      '6': '.creativanta.intelligence.v1.WhyExplanation',
      '10': 'whyExplanation'
    },
  ],
};

/// Descriptor for `BenchmarkSnapshot`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List benchmarkSnapshotDescriptor = $convert.base64Decode(
    'ChFCZW5jaG1hcmtTbmFwc2hvdBIfCgtzbmFwc2hvdF9pZBgBIAEoCVIKc25hcHNob3RJZBIhCg'
    'x3b3Jrc3BhY2VfaWQYAiABKAlSC3dvcmtzcGFjZUlkEiMKDWNvbXBldGl0b3JfaWQYAyABKAlS'
    'DGNvbXBldGl0b3JJZBIjCg1zbmFwc2hvdF90eXBlGAQgASgJUgxzbmFwc2hvdFR5cGUSKgoRZG'
    'F0YV9wZXJpb2Rfc3RhcnQYBSABKAlSD2RhdGFQZXJpb2RTdGFydBImCg9kYXRhX3BlcmlvZF9l'
    'bmQYBiABKAlSDWRhdGFQZXJpb2RFbmQSRwoHbWV0cmljcxgHIAEoCzItLmNyZWF0aXZhbnRhLm'
    'ludGVsbGlnZW5jZS52MS5CZW5jaG1hcmtNZXRyaWNzUgdtZXRyaWNzEksKDHNvdXJjZV9jbGFz'
    'cxgIIAEoDjIoLmNyZWF0aXZhbnRhLmludGVsbGlnZW5jZS52MS5Tb3VyY2VDbGFzc1ILc291cm'
    'NlQ2xhc3MSSwoKY29uZmlkZW5jZRgJIAEoDjIrLmNyZWF0aXZhbnRhLmludGVsbGlnZW5jZS52'
    'MS5Db25maWRlbmNlQmFuZFIKY29uZmlkZW5jZRI7CgtjYXB0dXJlZF9hdBgKIAEoCzIaLmdvb2'
    'dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSCmNhcHR1cmVkQXQSOQoKY3JlYXRlZF9hdBgLIAEoCzIa'
    'Lmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSCWNyZWF0ZWRBdBIZCghpc19zdGFsZRgMIAEoCF'
    'IHaXNTdGFsZRIjCg1zdGFsZV93YXJuaW5nGA0gASgJUgxzdGFsZVdhcm5pbmcSLAoSZGF5c19z'
    'aW5jZV9jYXB0dXJlGA4gASgFUhBkYXlzU2luY2VDYXB0dXJlElQKD3doeV9leHBsYW5hdGlvbh'
    'gPIAEoCzIrLmNyZWF0aXZhbnRhLmludGVsbGlnZW5jZS52MS5XaHlFeHBsYW5hdGlvblIOd2h5'
    'RXhwbGFuYXRpb24=');

@$core.Deprecated('Use whiteSpaceGapDescriptor instead')
const WhiteSpaceGap$json = {
  '1': 'WhiteSpaceGap',
  '2': [
    {'1': 'gap_id', '3': 1, '4': 1, '5': 9, '10': 'gapId'},
    {'1': 'category', '3': 2, '4': 1, '5': 9, '10': 'category'},
    {'1': 'format_type', '3': 3, '4': 1, '5': 9, '10': 'formatType'},
    {'1': 'price_tier', '3': 4, '4': 1, '5': 9, '10': 'priceTier'},
    {'1': 'description', '3': 5, '4': 1, '5': 9, '10': 'description'},
    {
      '1': 'opportunity_hypothesis',
      '3': 6,
      '4': 1,
      '5': 9,
      '10': 'opportunityHypothesis'
    },
    {
      '1': 'source_class',
      '3': 7,
      '4': 1,
      '5': 14,
      '6': '.creativanta.intelligence.v1.SourceClass',
      '10': 'sourceClass'
    },
    {
      '1': 'confidence',
      '3': 8,
      '4': 1,
      '5': 14,
      '6': '.creativanta.intelligence.v1.ConfidenceBand',
      '10': 'confidence'
    },
    {'1': 'competitor_ids', '3': 9, '4': 3, '5': 9, '10': 'competitorIds'},
    {
      '1': 'why_explanation',
      '3': 10,
      '4': 1,
      '5': 11,
      '6': '.creativanta.intelligence.v1.WhyExplanation',
      '10': 'whyExplanation'
    },
  ],
};

/// Descriptor for `WhiteSpaceGap`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List whiteSpaceGapDescriptor = $convert.base64Decode(
    'Cg1XaGl0ZVNwYWNlR2FwEhUKBmdhcF9pZBgBIAEoCVIFZ2FwSWQSGgoIY2F0ZWdvcnkYAiABKA'
    'lSCGNhdGVnb3J5Eh8KC2Zvcm1hdF90eXBlGAMgASgJUgpmb3JtYXRUeXBlEh0KCnByaWNlX3Rp'
    'ZXIYBCABKAlSCXByaWNlVGllchIgCgtkZXNjcmlwdGlvbhgFIAEoCVILZGVzY3JpcHRpb24SNQ'
    'oWb3Bwb3J0dW5pdHlfaHlwb3RoZXNpcxgGIAEoCVIVb3Bwb3J0dW5pdHlIeXBvdGhlc2lzEksK'
    'DHNvdXJjZV9jbGFzcxgHIAEoDjIoLmNyZWF0aXZhbnRhLmludGVsbGlnZW5jZS52MS5Tb3VyY2'
    'VDbGFzc1ILc291cmNlQ2xhc3MSSwoKY29uZmlkZW5jZRgIIAEoDjIrLmNyZWF0aXZhbnRhLmlu'
    'dGVsbGlnZW5jZS52MS5Db25maWRlbmNlQmFuZFIKY29uZmlkZW5jZRIlCg5jb21wZXRpdG9yX2'
    'lkcxgJIAMoCVINY29tcGV0aXRvcklkcxJUCg93aHlfZXhwbGFuYXRpb24YCiABKAsyKy5jcmVh'
    'dGl2YW50YS5pbnRlbGxpZ2VuY2UudjEuV2h5RXhwbGFuYXRpb25SDndoeUV4cGxhbmF0aW9u');

@$core.Deprecated('Use pricingComparisonItemDescriptor instead')
const PricingComparisonItem$json = {
  '1': 'PricingComparisonItem',
  '2': [
    {'1': 'item_id', '3': 1, '4': 1, '5': 9, '10': 'itemId'},
    {'1': 'competitor_id', '3': 2, '4': 1, '5': 9, '10': 'competitorId'},
    {'1': 'competitor_name', '3': 3, '4': 1, '5': 9, '10': 'competitorName'},
    {'1': 'product_name', '3': 4, '4': 1, '5': 9, '10': 'productName'},
    {'1': 'observed_price', '3': 5, '4': 1, '5': 9, '10': 'observedPrice'},
    {'1': 'currency', '3': 6, '4': 1, '5': 9, '10': 'currency'},
    {'1': 'offer_type', '3': 7, '4': 1, '5': 9, '10': 'offerType'},
    {'1': 'is_observational', '3': 8, '4': 1, '5': 8, '10': 'isObservational'},
    {'1': 'disclaimer', '3': 9, '4': 1, '5': 9, '10': 'disclaimer'},
    {
      '1': 'source_class',
      '3': 10,
      '4': 1,
      '5': 14,
      '6': '.creativanta.intelligence.v1.SourceClass',
      '10': 'sourceClass'
    },
  ],
};

/// Descriptor for `PricingComparisonItem`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List pricingComparisonItemDescriptor = $convert.base64Decode(
    'ChVQcmljaW5nQ29tcGFyaXNvbkl0ZW0SFwoHaXRlbV9pZBgBIAEoCVIGaXRlbUlkEiMKDWNvbX'
    'BldGl0b3JfaWQYAiABKAlSDGNvbXBldGl0b3JJZBInCg9jb21wZXRpdG9yX25hbWUYAyABKAlS'
    'DmNvbXBldGl0b3JOYW1lEiEKDHByb2R1Y3RfbmFtZRgEIAEoCVILcHJvZHVjdE5hbWUSJQoOb2'
    'JzZXJ2ZWRfcHJpY2UYBSABKAlSDW9ic2VydmVkUHJpY2USGgoIY3VycmVuY3kYBiABKAlSCGN1'
    'cnJlbmN5Eh0KCm9mZmVyX3R5cGUYByABKAlSCW9mZmVyVHlwZRIpChBpc19vYnNlcnZhdGlvbm'
    'FsGAggASgIUg9pc09ic2VydmF0aW9uYWwSHgoKZGlzY2xhaW1lchgJIAEoCVIKZGlzY2xhaW1l'
    'chJLCgxzb3VyY2VfY2xhc3MYCiABKA4yKC5jcmVhdGl2YW50YS5pbnRlbGxpZ2VuY2UudjEuU2'
    '91cmNlQ2xhc3NSC3NvdXJjZUNsYXNz');

@$core.Deprecated('Use formatComparisonItemDescriptor instead')
const FormatComparisonItem$json = {
  '1': 'FormatComparisonItem',
  '2': [
    {'1': 'format_name', '3': 1, '4': 1, '5': 9, '10': 'formatName'},
    {'1': 'your_share_pct', '3': 2, '4': 1, '5': 2, '10': 'yourSharePct'},
    {
      '1': 'market_avg_share_pct',
      '3': 3,
      '4': 1,
      '5': 2,
      '10': 'marketAvgSharePct'
    },
    {
      '1': 'top_competitor_share_pct',
      '3': 4,
      '4': 1,
      '5': 2,
      '10': 'topCompetitorSharePct'
    },
    {'1': 'recommendation', '3': 5, '4': 1, '5': 9, '10': 'recommendation'},
    {
      '1': 'source_class',
      '3': 6,
      '4': 1,
      '5': 14,
      '6': '.creativanta.intelligence.v1.SourceClass',
      '10': 'sourceClass'
    },
    {
      '1': 'confidence',
      '3': 7,
      '4': 1,
      '5': 14,
      '6': '.creativanta.intelligence.v1.ConfidenceBand',
      '10': 'confidence'
    },
  ],
};

/// Descriptor for `FormatComparisonItem`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List formatComparisonItemDescriptor = $convert.base64Decode(
    'ChRGb3JtYXRDb21wYXJpc29uSXRlbRIfCgtmb3JtYXRfbmFtZRgBIAEoCVIKZm9ybWF0TmFtZR'
    'IkCg55b3VyX3NoYXJlX3BjdBgCIAEoAlIMeW91clNoYXJlUGN0Ei8KFG1hcmtldF9hdmdfc2hh'
    'cmVfcGN0GAMgASgCUhFtYXJrZXRBdmdTaGFyZVBjdBI3Chh0b3BfY29tcGV0aXRvcl9zaGFyZV'
    '9wY3QYBCABKAJSFXRvcENvbXBldGl0b3JTaGFyZVBjdBImCg5yZWNvbW1lbmRhdGlvbhgFIAEo'
    'CVIOcmVjb21tZW5kYXRpb24SSwoMc291cmNlX2NsYXNzGAYgASgOMiguY3JlYXRpdmFudGEuaW'
    '50ZWxsaWdlbmNlLnYxLlNvdXJjZUNsYXNzUgtzb3VyY2VDbGFzcxJLCgpjb25maWRlbmNlGAcg'
    'ASgOMisuY3JlYXRpdmFudGEuaW50ZWxsaWdlbmNlLnYxLkNvbmZpZGVuY2VCYW5kUgpjb25maW'
    'RlbmNl');

@$core.Deprecated('Use financialNonConflationNoticeDescriptor instead')
const FinancialNonConflationNotice$json = {
  '1': 'FinancialNonConflationNotice',
  '2': [
    {'1': 'metric_name', '3': 1, '4': 1, '5': 9, '10': 'metricName'},
    {'1': 'status', '3': 2, '4': 1, '5': 9, '10': 'status'},
    {'1': 'display_value', '3': 3, '4': 1, '5': 9, '10': 'displayValue'},
    {'1': 'caveat_text', '3': 4, '4': 1, '5': 9, '10': 'caveatText'},
    {
      '1': 'is_conflation_blocked',
      '3': 5,
      '4': 1,
      '5': 8,
      '10': 'isConflationBlocked'
    },
  ],
};

/// Descriptor for `FinancialNonConflationNotice`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List financialNonConflationNoticeDescriptor = $convert.base64Decode(
    'ChxGaW5hbmNpYWxOb25Db25mbGF0aW9uTm90aWNlEh8KC21ldHJpY19uYW1lGAEgASgJUgptZX'
    'RyaWNOYW1lEhYKBnN0YXR1cxgCIAEoCVIGc3RhdHVzEiMKDWRpc3BsYXlfdmFsdWUYAyABKAlS'
    'DGRpc3BsYXlWYWx1ZRIfCgtjYXZlYXRfdGV4dBgEIAEoCVIKY2F2ZWF0VGV4dBIyChVpc19jb2'
    '5mbGF0aW9uX2Jsb2NrZWQYBSABKAhSE2lzQ29uZmxhdGlvbkJsb2NrZWQ=');

@$core.Deprecated('Use entityBenchmarkScoreDescriptor instead')
const EntityBenchmarkScore$json = {
  '1': 'EntityBenchmarkScore',
  '2': [
    {'1': 'entity_id', '3': 1, '4': 1, '5': 9, '10': 'entityId'},
    {'1': 'entity_name', '3': 2, '4': 1, '5': 9, '10': 'entityName'},
    {'1': 'handle', '3': 3, '4': 1, '5': 9, '10': 'handle'},
    {'1': 'is_you', '3': 4, '4': 1, '5': 8, '10': 'isYou'},
    {'1': 'rank', '3': 5, '4': 1, '5': 5, '10': 'rank'},
    {'1': 'overall_score', '3': 6, '4': 1, '5': 2, '10': 'overallScore'},
    {'1': 'followers', '3': 7, '4': 1, '5': 3, '10': 'followers'},
    {'1': 'growth_rate', '3': 8, '4': 1, '5': 2, '10': 'growthRate'},
    {'1': 'engagement_rate', '3': 9, '4': 1, '5': 2, '10': 'engagementRate'},
    {'1': 'avg_views', '3': 10, '4': 1, '5': 3, '10': 'avgViews'},
    {'1': 'posts_per_week', '3': 11, '4': 1, '5': 2, '10': 'postsPerWeek'},
    {'1': 'leader_badges', '3': 12, '4': 3, '5': 9, '10': 'leaderBadges'},
  ],
};

/// Descriptor for `EntityBenchmarkScore`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List entityBenchmarkScoreDescriptor = $convert.base64Decode(
    'ChRFbnRpdHlCZW5jaG1hcmtTY29yZRIbCgllbnRpdHlfaWQYASABKAlSCGVudGl0eUlkEh8KC2'
    'VudGl0eV9uYW1lGAIgASgJUgplbnRpdHlOYW1lEhYKBmhhbmRsZRgDIAEoCVIGaGFuZGxlEhUK'
    'BmlzX3lvdRgEIAEoCFIFaXNZb3USEgoEcmFuaxgFIAEoBVIEcmFuaxIjCg1vdmVyYWxsX3Njb3'
    'JlGAYgASgCUgxvdmVyYWxsU2NvcmUSHAoJZm9sbG93ZXJzGAcgASgDUglmb2xsb3dlcnMSHwoL'
    'Z3Jvd3RoX3JhdGUYCCABKAJSCmdyb3d0aFJhdGUSJwoPZW5nYWdlbWVudF9yYXRlGAkgASgCUg'
    '5lbmdhZ2VtZW50UmF0ZRIbCglhdmdfdmlld3MYCiABKANSCGF2Z1ZpZXdzEiQKDnBvc3RzX3Bl'
    'cl93ZWVrGAsgASgCUgxwb3N0c1BlcldlZWsSIwoNbGVhZGVyX2JhZGdlcxgMIAMoCVIMbGVhZG'
    'VyQmFkZ2Vz');

@$core.Deprecated('Use benchmarkComparisonDescriptor instead')
const BenchmarkComparison$json = {
  '1': 'BenchmarkComparison',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'period', '3': 2, '4': 1, '5': 9, '10': 'period'},
    {'1': 'total_tracked', '3': 3, '4': 1, '5': 5, '10': 'totalTracked'},
    {'1': 'your_rank', '3': 4, '4': 1, '5': 5, '10': 'yourRank'},
    {
      '1': 'your_overall_score',
      '3': 5,
      '4': 1,
      '5': 2,
      '10': 'yourOverallScore'
    },
    {
      '1': 'score_delta_vs_last_month',
      '3': 6,
      '4': 1,
      '5': 2,
      '10': 'scoreDeltaVsLastMonth'
    },
    {
      '1': 'entities',
      '3': 7,
      '4': 3,
      '5': 11,
      '6': '.creativanta.intelligence.v1.EntityBenchmarkScore',
      '10': 'entities'
    },
    {
      '1': 'market_average',
      '3': 8,
      '4': 1,
      '5': 11,
      '6': '.creativanta.intelligence.v1.EntityBenchmarkScore',
      '10': 'marketAverage'
    },
    {
      '1': 'revenue_metric_guard',
      '3': 9,
      '4': 1,
      '5': 11,
      '6': '.creativanta.intelligence.v1.FinancialNonConflationNotice',
      '10': 'revenueMetricGuard'
    },
    {
      '1': 'ai_insight_summary',
      '3': 10,
      '4': 1,
      '5': 9,
      '10': 'aiInsightSummary'
    },
    {
      '1': 'insight_source_class',
      '3': 11,
      '4': 1,
      '5': 14,
      '6': '.creativanta.intelligence.v1.SourceClass',
      '10': 'insightSourceClass'
    },
    {
      '1': 'insight_confidence',
      '3': 12,
      '4': 1,
      '5': 14,
      '6': '.creativanta.intelligence.v1.ConfidenceBand',
      '10': 'insightConfidence'
    },
    {
      '1': 'insight_why',
      '3': 13,
      '4': 1,
      '5': 11,
      '6': '.creativanta.intelligence.v1.WhyExplanation',
      '10': 'insightWhy'
    },
  ],
};

/// Descriptor for `BenchmarkComparison`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List benchmarkComparisonDescriptor = $convert.base64Decode(
    'ChNCZW5jaG1hcmtDb21wYXJpc29uEiEKDHdvcmtzcGFjZV9pZBgBIAEoCVILd29ya3NwYWNlSW'
    'QSFgoGcGVyaW9kGAIgASgJUgZwZXJpb2QSIwoNdG90YWxfdHJhY2tlZBgDIAEoBVIMdG90YWxU'
    'cmFja2VkEhsKCXlvdXJfcmFuaxgEIAEoBVIIeW91clJhbmsSLAoSeW91cl9vdmVyYWxsX3Njb3'
    'JlGAUgASgCUhB5b3VyT3ZlcmFsbFNjb3JlEjgKGXNjb3JlX2RlbHRhX3ZzX2xhc3RfbW9udGgY'
    'BiABKAJSFXNjb3JlRGVsdGFWc0xhc3RNb250aBJNCghlbnRpdGllcxgHIAMoCzIxLmNyZWF0aX'
    'ZhbnRhLmludGVsbGlnZW5jZS52MS5FbnRpdHlCZW5jaG1hcmtTY29yZVIIZW50aXRpZXMSWAoO'
    'bWFya2V0X2F2ZXJhZ2UYCCABKAsyMS5jcmVhdGl2YW50YS5pbnRlbGxpZ2VuY2UudjEuRW50aX'
    'R5QmVuY2htYXJrU2NvcmVSDW1hcmtldEF2ZXJhZ2USawoUcmV2ZW51ZV9tZXRyaWNfZ3VhcmQY'
    'CSABKAsyOS5jcmVhdGl2YW50YS5pbnRlbGxpZ2VuY2UudjEuRmluYW5jaWFsTm9uQ29uZmxhdG'
    'lvbk5vdGljZVIScmV2ZW51ZU1ldHJpY0d1YXJkEiwKEmFpX2luc2lnaHRfc3VtbWFyeRgKIAEo'
    'CVIQYWlJbnNpZ2h0U3VtbWFyeRJaChRpbnNpZ2h0X3NvdXJjZV9jbGFzcxgLIAEoDjIoLmNyZW'
    'F0aXZhbnRhLmludGVsbGlnZW5jZS52MS5Tb3VyY2VDbGFzc1ISaW5zaWdodFNvdXJjZUNsYXNz'
    'EloKEmluc2lnaHRfY29uZmlkZW5jZRgMIAEoDjIrLmNyZWF0aXZhbnRhLmludGVsbGlnZW5jZS'
    '52MS5Db25maWRlbmNlQmFuZFIRaW5zaWdodENvbmZpZGVuY2USTAoLaW5zaWdodF93aHkYDSAB'
    'KAsyKy5jcmVhdGl2YW50YS5pbnRlbGxpZ2VuY2UudjEuV2h5RXhwbGFuYXRpb25SCmluc2lnaH'
    'RXaHk=');

@$core.Deprecated('Use benchmarkDataPointDescriptor instead')
const BenchmarkDataPoint$json = {
  '1': 'BenchmarkDataPoint',
  '2': [
    {
      '1': 'timestamp',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'timestamp'
    },
    {'1': 'value', '3': 2, '4': 1, '5': 1, '10': 'value'},
    {'1': 'formatted_value', '3': 3, '4': 1, '5': 9, '10': 'formattedValue'},
  ],
};

/// Descriptor for `BenchmarkDataPoint`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List benchmarkDataPointDescriptor = $convert.base64Decode(
    'ChJCZW5jaG1hcmtEYXRhUG9pbnQSOAoJdGltZXN0YW1wGAEgASgLMhouZ29vZ2xlLnByb3RvYn'
    'VmLlRpbWVzdGFtcFIJdGltZXN0YW1wEhQKBXZhbHVlGAIgASgBUgV2YWx1ZRInCg9mb3JtYXR0'
    'ZWRfdmFsdWUYAyABKAlSDmZvcm1hdHRlZFZhbHVl');

@$core.Deprecated('Use timeSeriesSeriesDescriptor instead')
const TimeSeriesSeries$json = {
  '1': 'TimeSeriesSeries',
  '2': [
    {'1': 'entity_id', '3': 1, '4': 1, '5': 9, '10': 'entityId'},
    {'1': 'entity_name', '3': 2, '4': 1, '5': 9, '10': 'entityName'},
    {'1': 'handle', '3': 3, '4': 1, '5': 9, '10': 'handle'},
    {'1': 'is_you', '3': 4, '4': 1, '5': 8, '10': 'isYou'},
    {
      '1': 'points',
      '3': 5,
      '4': 3,
      '5': 11,
      '6': '.creativanta.intelligence.v1.BenchmarkDataPoint',
      '10': 'points'
    },
  ],
};

/// Descriptor for `TimeSeriesSeries`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List timeSeriesSeriesDescriptor = $convert.base64Decode(
    'ChBUaW1lU2VyaWVzU2VyaWVzEhsKCWVudGl0eV9pZBgBIAEoCVIIZW50aXR5SWQSHwoLZW50aX'
    'R5X25hbWUYAiABKAlSCmVudGl0eU5hbWUSFgoGaGFuZGxlGAMgASgJUgZoYW5kbGUSFQoGaXNf'
    'eW91GAQgASgIUgVpc1lvdRJHCgZwb2ludHMYBSADKAsyLy5jcmVhdGl2YW50YS5pbnRlbGxpZ2'
    'VuY2UudjEuQmVuY2htYXJrRGF0YVBvaW50UgZwb2ludHM=');

@$core.Deprecated('Use competitorPreviewDescriptor instead')
const CompetitorPreview$json = {
  '1': 'CompetitorPreview',
  '2': [
    {'1': 'platform', '3': 1, '4': 1, '5': 9, '10': 'platform'},
    {'1': 'external_handle', '3': 2, '4': 1, '5': 9, '10': 'externalHandle'},
    {'1': 'display_name', '3': 3, '4': 1, '5': 9, '10': 'displayName'},
    {'1': 'avatar_url', '3': 4, '4': 1, '5': 9, '10': 'avatarUrl'},
    {'1': 'followers_count', '3': 5, '4': 1, '5': 3, '10': 'followersCount'},
    {
      '1': 'relevance_preview',
      '3': 6,
      '4': 1,
      '5': 2,
      '10': 'relevancePreview'
    },
    {
      '1': 'relevance_explanation',
      '3': 7,
      '4': 1,
      '5': 9,
      '10': 'relevanceExplanation'
    },
  ],
};

/// Descriptor for `CompetitorPreview`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List competitorPreviewDescriptor = $convert.base64Decode(
    'ChFDb21wZXRpdG9yUHJldmlldxIaCghwbGF0Zm9ybRgBIAEoCVIIcGxhdGZvcm0SJwoPZXh0ZX'
    'JuYWxfaGFuZGxlGAIgASgJUg5leHRlcm5hbEhhbmRsZRIhCgxkaXNwbGF5X25hbWUYAyABKAlS'
    'C2Rpc3BsYXlOYW1lEh0KCmF2YXRhcl91cmwYBCABKAlSCWF2YXRhclVybBInCg9mb2xsb3dlcn'
    'NfY291bnQYBSABKANSDmZvbGxvd2Vyc0NvdW50EisKEXJlbGV2YW5jZV9wcmV2aWV3GAYgASgC'
    'UhByZWxldmFuY2VQcmV2aWV3EjMKFXJlbGV2YW5jZV9leHBsYW5hdGlvbhgHIAEoCVIUcmVsZX'
    'ZhbmNlRXhwbGFuYXRpb24=');

@$core.Deprecated('Use competitorServiceListRequestDescriptor instead')
const CompetitorServiceListRequest$json = {
  '1': 'CompetitorServiceListRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'page_size', '3': 2, '4': 1, '5': 5, '10': 'pageSize'},
    {'1': 'page_token', '3': 3, '4': 1, '5': 9, '10': 'pageToken'},
    {'1': 'platform', '3': 4, '4': 1, '5': 9, '10': 'platform'},
    {'1': 'category', '3': 5, '4': 1, '5': 9, '10': 'category'},
    {'1': 'search_query', '3': 6, '4': 1, '5': 9, '10': 'searchQuery'},
  ],
};

/// Descriptor for `CompetitorServiceListRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List competitorServiceListRequestDescriptor = $convert.base64Decode(
    'ChxDb21wZXRpdG9yU2VydmljZUxpc3RSZXF1ZXN0EiEKDHdvcmtzcGFjZV9pZBgBIAEoCVILd2'
    '9ya3NwYWNlSWQSGwoJcGFnZV9zaXplGAIgASgFUghwYWdlU2l6ZRIdCgpwYWdlX3Rva2VuGAMg'
    'ASgJUglwYWdlVG9rZW4SGgoIcGxhdGZvcm0YBCABKAlSCHBsYXRmb3JtEhoKCGNhdGVnb3J5GA'
    'UgASgJUghjYXRlZ29yeRIhCgxzZWFyY2hfcXVlcnkYBiABKAlSC3NlYXJjaFF1ZXJ5');

@$core.Deprecated('Use competitorServiceListResponseDescriptor instead')
const CompetitorServiceListResponse$json = {
  '1': 'CompetitorServiceListResponse',
  '2': [
    {
      '1': 'competitors',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.creativanta.intelligence.v1.CompetitorEntity',
      '10': 'competitors'
    },
    {'1': 'next_page_token', '3': 2, '4': 1, '5': 9, '10': 'nextPageToken'},
    {'1': 'total_count', '3': 3, '4': 1, '5': 5, '10': 'totalCount'},
  ],
};

/// Descriptor for `CompetitorServiceListResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List competitorServiceListResponseDescriptor = $convert.base64Decode(
    'Ch1Db21wZXRpdG9yU2VydmljZUxpc3RSZXNwb25zZRJPCgtjb21wZXRpdG9ycxgBIAMoCzItLm'
    'NyZWF0aXZhbnRhLmludGVsbGlnZW5jZS52MS5Db21wZXRpdG9yRW50aXR5Ugtjb21wZXRpdG9y'
    'cxImCg9uZXh0X3BhZ2VfdG9rZW4YAiABKAlSDW5leHRQYWdlVG9rZW4SHwoLdG90YWxfY291bn'
    'QYAyABKAVSCnRvdGFsQ291bnQ=');

@$core.Deprecated('Use competitorServiceAddRequestDescriptor instead')
const CompetitorServiceAddRequest$json = {
  '1': 'CompetitorServiceAddRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'platform', '3': 2, '4': 1, '5': 9, '10': 'platform'},
    {'1': 'external_handle', '3': 3, '4': 1, '5': 9, '10': 'externalHandle'},
    {'1': 'name', '3': 4, '4': 1, '5': 9, '10': 'name'},
    {'1': 'category', '3': 5, '4': 1, '5': 9, '10': 'category'},
    {'1': 'notes', '3': 6, '4': 1, '5': 9, '10': 'notes'},
    {'1': 'idempotency_key', '3': 7, '4': 1, '5': 9, '10': 'idempotencyKey'},
  ],
};

/// Descriptor for `CompetitorServiceAddRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List competitorServiceAddRequestDescriptor = $convert.base64Decode(
    'ChtDb21wZXRpdG9yU2VydmljZUFkZFJlcXVlc3QSIQoMd29ya3NwYWNlX2lkGAEgASgJUgt3b3'
    'Jrc3BhY2VJZBIaCghwbGF0Zm9ybRgCIAEoCVIIcGxhdGZvcm0SJwoPZXh0ZXJuYWxfaGFuZGxl'
    'GAMgASgJUg5leHRlcm5hbEhhbmRsZRISCgRuYW1lGAQgASgJUgRuYW1lEhoKCGNhdGVnb3J5GA'
    'UgASgJUghjYXRlZ29yeRIUCgVub3RlcxgGIAEoCVIFbm90ZXMSJwoPaWRlbXBvdGVuY3lfa2V5'
    'GAcgASgJUg5pZGVtcG90ZW5jeUtleQ==');

@$core.Deprecated('Use competitorServiceAddResponseDescriptor instead')
const CompetitorServiceAddResponse$json = {
  '1': 'CompetitorServiceAddResponse',
  '2': [
    {
      '1': 'competitor',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.intelligence.v1.CompetitorEntity',
      '10': 'competitor'
    },
  ],
};

/// Descriptor for `CompetitorServiceAddResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List competitorServiceAddResponseDescriptor =
    $convert.base64Decode(
        'ChxDb21wZXRpdG9yU2VydmljZUFkZFJlc3BvbnNlEk0KCmNvbXBldGl0b3IYASABKAsyLS5jcm'
        'VhdGl2YW50YS5pbnRlbGxpZ2VuY2UudjEuQ29tcGV0aXRvckVudGl0eVIKY29tcGV0aXRvcg==');

@$core.Deprecated('Use competitorServiceRemoveRequestDescriptor instead')
const CompetitorServiceRemoveRequest$json = {
  '1': 'CompetitorServiceRemoveRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'competitor_id', '3': 2, '4': 1, '5': 9, '10': 'competitorId'},
  ],
};

/// Descriptor for `CompetitorServiceRemoveRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List competitorServiceRemoveRequestDescriptor =
    $convert.base64Decode(
        'Ch5Db21wZXRpdG9yU2VydmljZVJlbW92ZVJlcXVlc3QSIQoMd29ya3NwYWNlX2lkGAEgASgJUg'
        't3b3Jrc3BhY2VJZBIjCg1jb21wZXRpdG9yX2lkGAIgASgJUgxjb21wZXRpdG9ySWQ=');

@$core.Deprecated('Use competitorServiceRemoveResponseDescriptor instead')
const CompetitorServiceRemoveResponse$json = {
  '1': 'CompetitorServiceRemoveResponse',
  '2': [
    {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
    {'1': 'competitor_id', '3': 2, '4': 1, '5': 9, '10': 'competitorId'},
  ],
};

/// Descriptor for `CompetitorServiceRemoveResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List competitorServiceRemoveResponseDescriptor =
    $convert.base64Decode(
        'Ch9Db21wZXRpdG9yU2VydmljZVJlbW92ZVJlc3BvbnNlEhgKB3N1Y2Nlc3MYASABKAhSB3N1Y2'
        'Nlc3MSIwoNY29tcGV0aXRvcl9pZBgCIAEoCVIMY29tcGV0aXRvcklk');

@$core.Deprecated('Use getSuggestionsRequestDescriptor instead')
const GetSuggestionsRequest$json = {
  '1': 'GetSuggestionsRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'category', '3': 2, '4': 1, '5': 9, '10': 'category'},
    {'1': 'limit', '3': 3, '4': 1, '5': 5, '10': 'limit'},
  ],
};

/// Descriptor for `GetSuggestionsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getSuggestionsRequestDescriptor = $convert.base64Decode(
    'ChVHZXRTdWdnZXN0aW9uc1JlcXVlc3QSIQoMd29ya3NwYWNlX2lkGAEgASgJUgt3b3Jrc3BhY2'
    'VJZBIaCghjYXRlZ29yeRgCIAEoCVIIY2F0ZWdvcnkSFAoFbGltaXQYAyABKAVSBWxpbWl0');

@$core.Deprecated('Use getSuggestionsResponseDescriptor instead')
const GetSuggestionsResponse$json = {
  '1': 'GetSuggestionsResponse',
  '2': [
    {
      '1': 'suggestions',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.creativanta.intelligence.v1.CompetitorSuggestion',
      '10': 'suggestions'
    },
  ],
};

/// Descriptor for `GetSuggestionsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getSuggestionsResponseDescriptor = $convert.base64Decode(
    'ChZHZXRTdWdnZXN0aW9uc1Jlc3BvbnNlElMKC3N1Z2dlc3Rpb25zGAEgAygLMjEuY3JlYXRpdm'
    'FudGEuaW50ZWxsaWdlbmNlLnYxLkNvbXBldGl0b3JTdWdnZXN0aW9uUgtzdWdnZXN0aW9ucw==');

@$core.Deprecated('Use dismissSuggestionRequestDescriptor instead')
const DismissSuggestionRequest$json = {
  '1': 'DismissSuggestionRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'suggestion_id', '3': 2, '4': 1, '5': 9, '10': 'suggestionId'},
  ],
};

/// Descriptor for `DismissSuggestionRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List dismissSuggestionRequestDescriptor =
    $convert.base64Decode(
        'ChhEaXNtaXNzU3VnZ2VzdGlvblJlcXVlc3QSIQoMd29ya3NwYWNlX2lkGAEgASgJUgt3b3Jrc3'
        'BhY2VJZBIjCg1zdWdnZXN0aW9uX2lkGAIgASgJUgxzdWdnZXN0aW9uSWQ=');

@$core.Deprecated('Use dismissSuggestionResponseDescriptor instead')
const DismissSuggestionResponse$json = {
  '1': 'DismissSuggestionResponse',
  '2': [
    {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
    {'1': 'suggestion_id', '3': 2, '4': 1, '5': 9, '10': 'suggestionId'},
  ],
};

/// Descriptor for `DismissSuggestionResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List dismissSuggestionResponseDescriptor =
    $convert.base64Decode(
        'ChlEaXNtaXNzU3VnZ2VzdGlvblJlc3BvbnNlEhgKB3N1Y2Nlc3MYASABKAhSB3N1Y2Nlc3MSIw'
        'oNc3VnZ2VzdGlvbl9pZBgCIAEoCVIMc3VnZ2VzdGlvbklk');

@$core.Deprecated('Use setAlertsRequestDescriptor instead')
const SetAlertsRequest$json = {
  '1': 'SetAlertsRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'competitor_id', '3': 2, '4': 1, '5': 9, '10': 'competitorId'},
    {
      '1': 'alert_config',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.creativanta.intelligence.v1.AlertConfig',
      '10': 'alertConfig'
    },
  ],
};

/// Descriptor for `SetAlertsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List setAlertsRequestDescriptor = $convert.base64Decode(
    'ChBTZXRBbGVydHNSZXF1ZXN0EiEKDHdvcmtzcGFjZV9pZBgBIAEoCVILd29ya3NwYWNlSWQSIw'
    'oNY29tcGV0aXRvcl9pZBgCIAEoCVIMY29tcGV0aXRvcklkEksKDGFsZXJ0X2NvbmZpZxgDIAEo'
    'CzIoLmNyZWF0aXZhbnRhLmludGVsbGlnZW5jZS52MS5BbGVydENvbmZpZ1ILYWxlcnRDb25maW'
    'c=');

@$core.Deprecated('Use setAlertsResponseDescriptor instead')
const SetAlertsResponse$json = {
  '1': 'SetAlertsResponse',
  '2': [
    {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
    {'1': 'competitor_id', '3': 2, '4': 1, '5': 9, '10': 'competitorId'},
    {
      '1': 'alert_config',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.creativanta.intelligence.v1.AlertConfig',
      '10': 'alertConfig'
    },
  ],
};

/// Descriptor for `SetAlertsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List setAlertsResponseDescriptor = $convert.base64Decode(
    'ChFTZXRBbGVydHNSZXNwb25zZRIYCgdzdWNjZXNzGAEgASgIUgdzdWNjZXNzEiMKDWNvbXBldG'
    'l0b3JfaWQYAiABKAlSDGNvbXBldGl0b3JJZBJLCgxhbGVydF9jb25maWcYAyABKAsyKC5jcmVh'
    'dGl2YW50YS5pbnRlbGxpZ2VuY2UudjEuQWxlcnRDb25maWdSC2FsZXJ0Q29uZmln');

@$core.Deprecated('Use validateHandleRequestDescriptor instead')
const ValidateHandleRequest$json = {
  '1': 'ValidateHandleRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'platform', '3': 2, '4': 1, '5': 9, '10': 'platform'},
    {'1': 'external_handle', '3': 3, '4': 1, '5': 9, '10': 'externalHandle'},
  ],
};

/// Descriptor for `ValidateHandleRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List validateHandleRequestDescriptor = $convert.base64Decode(
    'ChVWYWxpZGF0ZUhhbmRsZVJlcXVlc3QSIQoMd29ya3NwYWNlX2lkGAEgASgJUgt3b3Jrc3BhY2'
    'VJZBIaCghwbGF0Zm9ybRgCIAEoCVIIcGxhdGZvcm0SJwoPZXh0ZXJuYWxfaGFuZGxlGAMgASgJ'
    'Ug5leHRlcm5hbEhhbmRsZQ==');

@$core.Deprecated('Use validateHandleResponseDescriptor instead')
const ValidateHandleResponse$json = {
  '1': 'ValidateHandleResponse',
  '2': [
    {'1': 'is_valid', '3': 1, '4': 1, '5': 8, '10': 'isValid'},
    {'1': 'error_message', '3': 2, '4': 1, '5': 9, '10': 'errorMessage'},
    {
      '1': 'preview',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.creativanta.intelligence.v1.CompetitorPreview',
      '10': 'preview'
    },
  ],
};

/// Descriptor for `ValidateHandleResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List validateHandleResponseDescriptor = $convert.base64Decode(
    'ChZWYWxpZGF0ZUhhbmRsZVJlc3BvbnNlEhkKCGlzX3ZhbGlkGAEgASgIUgdpc1ZhbGlkEiMKDW'
    'Vycm9yX21lc3NhZ2UYAiABKAlSDGVycm9yTWVzc2FnZRJICgdwcmV2aWV3GAMgASgLMi4uY3Jl'
    'YXRpdmFudGEuaW50ZWxsaWdlbmNlLnYxLkNvbXBldGl0b3JQcmV2aWV3UgdwcmV2aWV3');

@$core.Deprecated('Use analyzeBenchmarkRequestDescriptor instead')
const AnalyzeBenchmarkRequest$json = {
  '1': 'AnalyzeBenchmarkRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'competitor_id', '3': 2, '4': 1, '5': 9, '10': 'competitorId'},
    {'1': 'snapshot_type', '3': 3, '4': 1, '5': 9, '10': 'snapshotType'},
    {'1': 'data_period_start', '3': 4, '4': 1, '5': 9, '10': 'dataPeriodStart'},
    {'1': 'data_period_end', '3': 5, '4': 1, '5': 9, '10': 'dataPeriodEnd'},
  ],
};

/// Descriptor for `AnalyzeBenchmarkRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List analyzeBenchmarkRequestDescriptor = $convert.base64Decode(
    'ChdBbmFseXplQmVuY2htYXJrUmVxdWVzdBIhCgx3b3Jrc3BhY2VfaWQYASABKAlSC3dvcmtzcG'
    'FjZUlkEiMKDWNvbXBldGl0b3JfaWQYAiABKAlSDGNvbXBldGl0b3JJZBIjCg1zbmFwc2hvdF90'
    'eXBlGAMgASgJUgxzbmFwc2hvdFR5cGUSKgoRZGF0YV9wZXJpb2Rfc3RhcnQYBCABKAlSD2RhdG'
    'FQZXJpb2RTdGFydBImCg9kYXRhX3BlcmlvZF9lbmQYBSABKAlSDWRhdGFQZXJpb2RFbmQ=');

@$core.Deprecated('Use analyzeBenchmarkResponseDescriptor instead')
const AnalyzeBenchmarkResponse$json = {
  '1': 'AnalyzeBenchmarkResponse',
  '2': [
    {
      '1': 'snapshot',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.intelligence.v1.BenchmarkSnapshot',
      '10': 'snapshot'
    },
    {
      '1': 'white_space_gaps',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.creativanta.intelligence.v1.WhiteSpaceGap',
      '10': 'whiteSpaceGaps'
    },
    {
      '1': 'pricing_comparisons',
      '3': 3,
      '4': 3,
      '5': 11,
      '6': '.creativanta.intelligence.v1.PricingComparisonItem',
      '10': 'pricingComparisons'
    },
    {
      '1': 'format_comparisons',
      '3': 4,
      '4': 3,
      '5': 11,
      '6': '.creativanta.intelligence.v1.FormatComparisonItem',
      '10': 'formatComparisons'
    },
  ],
};

/// Descriptor for `AnalyzeBenchmarkResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List analyzeBenchmarkResponseDescriptor = $convert.base64Decode(
    'ChhBbmFseXplQmVuY2htYXJrUmVzcG9uc2USSgoIc25hcHNob3QYASABKAsyLi5jcmVhdGl2YW'
    '50YS5pbnRlbGxpZ2VuY2UudjEuQmVuY2htYXJrU25hcHNob3RSCHNuYXBzaG90ElQKEHdoaXRl'
    'X3NwYWNlX2dhcHMYAiADKAsyKi5jcmVhdGl2YW50YS5pbnRlbGxpZ2VuY2UudjEuV2hpdGVTcG'
    'FjZUdhcFIOd2hpdGVTcGFjZUdhcHMSYwoTcHJpY2luZ19jb21wYXJpc29ucxgDIAMoCzIyLmNy'
    'ZWF0aXZhbnRhLmludGVsbGlnZW5jZS52MS5QcmljaW5nQ29tcGFyaXNvbkl0ZW1SEnByaWNpbm'
    'dDb21wYXJpc29ucxJgChJmb3JtYXRfY29tcGFyaXNvbnMYBCADKAsyMS5jcmVhdGl2YW50YS5p'
    'bnRlbGxpZ2VuY2UudjEuRm9ybWF0Q29tcGFyaXNvbkl0ZW1SEWZvcm1hdENvbXBhcmlzb25z');

@$core.Deprecated('Use benchmarkServiceCompareRequestDescriptor instead')
const BenchmarkServiceCompareRequest$json = {
  '1': 'BenchmarkServiceCompareRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'competitor_ids', '3': 2, '4': 3, '5': 9, '10': 'competitorIds'},
    {'1': 'period', '3': 3, '4': 1, '5': 9, '10': 'period'},
  ],
};

/// Descriptor for `BenchmarkServiceCompareRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List benchmarkServiceCompareRequestDescriptor =
    $convert.base64Decode(
        'Ch5CZW5jaG1hcmtTZXJ2aWNlQ29tcGFyZVJlcXVlc3QSIQoMd29ya3NwYWNlX2lkGAEgASgJUg'
        't3b3Jrc3BhY2VJZBIlCg5jb21wZXRpdG9yX2lkcxgCIAMoCVINY29tcGV0aXRvcklkcxIWCgZw'
        'ZXJpb2QYAyABKAlSBnBlcmlvZA==');

@$core.Deprecated('Use benchmarkServiceCompareResponseDescriptor instead')
const BenchmarkServiceCompareResponse$json = {
  '1': 'BenchmarkServiceCompareResponse',
  '2': [
    {
      '1': 'comparison',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.intelligence.v1.BenchmarkComparison',
      '10': 'comparison'
    },
  ],
};

/// Descriptor for `BenchmarkServiceCompareResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List benchmarkServiceCompareResponseDescriptor =
    $convert.base64Decode(
        'Ch9CZW5jaG1hcmtTZXJ2aWNlQ29tcGFyZVJlc3BvbnNlElAKCmNvbXBhcmlzb24YASABKAsyMC'
        '5jcmVhdGl2YW50YS5pbnRlbGxpZ2VuY2UudjEuQmVuY2htYXJrQ29tcGFyaXNvblIKY29tcGFy'
        'aXNvbg==');

@$core.Deprecated('Use getTimeSeriesRequestDescriptor instead')
const GetTimeSeriesRequest$json = {
  '1': 'GetTimeSeriesRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'competitor_ids', '3': 2, '4': 3, '5': 9, '10': 'competitorIds'},
    {'1': 'metric', '3': 3, '4': 1, '5': 9, '10': 'metric'},
    {'1': 'period', '3': 4, '4': 1, '5': 9, '10': 'period'},
  ],
};

/// Descriptor for `GetTimeSeriesRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getTimeSeriesRequestDescriptor = $convert.base64Decode(
    'ChRHZXRUaW1lU2VyaWVzUmVxdWVzdBIhCgx3b3Jrc3BhY2VfaWQYASABKAlSC3dvcmtzcGFjZU'
    'lkEiUKDmNvbXBldGl0b3JfaWRzGAIgAygJUg1jb21wZXRpdG9ySWRzEhYKBm1ldHJpYxgDIAEo'
    'CVIGbWV0cmljEhYKBnBlcmlvZBgEIAEoCVIGcGVyaW9k');

@$core.Deprecated('Use getTimeSeriesResponseDescriptor instead')
const GetTimeSeriesResponse$json = {
  '1': 'GetTimeSeriesResponse',
  '2': [
    {
      '1': 'series',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.creativanta.intelligence.v1.TimeSeriesSeries',
      '10': 'series'
    },
  ],
};

/// Descriptor for `GetTimeSeriesResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getTimeSeriesResponseDescriptor = $convert.base64Decode(
    'ChVHZXRUaW1lU2VyaWVzUmVzcG9uc2USRQoGc2VyaWVzGAEgAygLMi0uY3JlYXRpdmFudGEuaW'
    '50ZWxsaWdlbmNlLnYxLlRpbWVTZXJpZXNTZXJpZXNSBnNlcmllcw==');

// This is a generated file - do not edit.
//
// Generated from creativanta/commerce/v1/live.proto.

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

@$core.Deprecated('Use liveSessionStatusDescriptor instead')
const LiveSessionStatus$json = {
  '1': 'LiveSessionStatus',
  '2': [
    {'1': 'LIVE_SESSION_STATUS_UNSPECIFIED', '2': 0},
    {'1': 'LIVE_SESSION_STATUS_PLANNED', '2': 1},
    {'1': 'LIVE_SESSION_STATUS_READY', '2': 2},
    {'1': 'LIVE_SESSION_STATUS_LIVE', '2': 3},
    {'1': 'LIVE_SESSION_STATUS_PAUSED', '2': 4},
    {'1': 'LIVE_SESSION_STATUS_ENDED', '2': 5},
    {'1': 'LIVE_SESSION_STATUS_POST_LIVE_PROCESSING', '2': 6},
    {'1': 'LIVE_SESSION_STATUS_CLOSED', '2': 7},
  ],
};

/// Descriptor for `LiveSessionStatus`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List liveSessionStatusDescriptor = $convert.base64Decode(
    'ChFMaXZlU2Vzc2lvblN0YXR1cxIjCh9MSVZFX1NFU1NJT05fU1RBVFVTX1VOU1BFQ0lGSUVEEA'
    'ASHwobTElWRV9TRVNTSU9OX1NUQVRVU19QTEFOTkVEEAESHQoZTElWRV9TRVNTSU9OX1NUQVRV'
    'U19SRUFEWRACEhwKGExJVkVfU0VTU0lPTl9TVEFUVVNfTElWRRADEh4KGkxJVkVfU0VTU0lPTl'
    '9TVEFUVVNfUEFVU0VEEAQSHQoZTElWRV9TRVNTSU9OX1NUQVRVU19FTkRFRBAFEiwKKExJVkVf'
    'U0VTU0lPTl9TVEFUVVNfUE9TVF9MSVZFX1BST0NFU1NJTkcQBhIeChpMSVZFX1NFU1NJT05fU1'
    'RBVFVTX0NMT1NFRBAH');

@$core.Deprecated('Use cueCardStatusDescriptor instead')
const CueCardStatus$json = {
  '1': 'CueCardStatus',
  '2': [
    {'1': 'CUE_CARD_STATUS_UNSPECIFIED', '2': 0},
    {'1': 'CUE_CARD_STATUS_PENDING', '2': 1},
    {'1': 'CUE_CARD_STATUS_ACTIVE', '2': 2},
    {'1': 'CUE_CARD_STATUS_USED', '2': 3},
    {'1': 'CUE_CARD_STATUS_SKIPPED', '2': 4},
  ],
};

/// Descriptor for `CueCardStatus`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List cueCardStatusDescriptor = $convert.base64Decode(
    'Cg1DdWVDYXJkU3RhdHVzEh8KG0NVRV9DQVJEX1NUQVRVU19VTlNQRUNJRklFRBAAEhsKF0NVRV'
    '9DQVJEX1NUQVRVU19QRU5ESU5HEAESGgoWQ1VFX0NBUkRfU1RBVFVTX0FDVElWRRACEhgKFENV'
    'RV9DQVJEX1NUQVRVU19VU0VEEAMSGwoXQ1VFX0NBUkRfU1RBVFVTX1NLSVBQRUQQBA==');

@$core.Deprecated('Use runOfShowItemDescriptor instead')
const RunOfShowItem$json = {
  '1': 'RunOfShowItem',
  '2': [
    {'1': 'time_offset_min', '3': 1, '4': 1, '5': 5, '10': 'timeOffsetMin'},
    {'1': 'type', '3': 2, '4': 1, '5': 9, '10': 'type'},
    {'1': 'title', '3': 3, '4': 1, '5': 9, '10': 'title'},
    {'1': 'product_id', '3': 4, '4': 1, '5': 9, '10': 'productId'},
    {'1': 'offer_id', '3': 5, '4': 1, '5': 9, '10': 'offerId'},
    {'1': 'notes', '3': 6, '4': 1, '5': 9, '10': 'notes'},
    {'1': 'duration_min', '3': 7, '4': 1, '5': 5, '10': 'durationMin'},
    {'1': 'executed', '3': 8, '4': 1, '5': 8, '10': 'executed'},
    {
      '1': 'executed_at',
      '3': 9,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'executedAt'
    },
    {'1': 'cue_card_ids', '3': 10, '4': 3, '5': 9, '10': 'cueCardIds'},
  ],
};

/// Descriptor for `RunOfShowItem`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List runOfShowItemDescriptor = $convert.base64Decode(
    'Cg1SdW5PZlNob3dJdGVtEiYKD3RpbWVfb2Zmc2V0X21pbhgBIAEoBVINdGltZU9mZnNldE1pbh'
    'ISCgR0eXBlGAIgASgJUgR0eXBlEhQKBXRpdGxlGAMgASgJUgV0aXRsZRIdCgpwcm9kdWN0X2lk'
    'GAQgASgJUglwcm9kdWN0SWQSGQoIb2ZmZXJfaWQYBSABKAlSB29mZmVySWQSFAoFbm90ZXMYBi'
    'ABKAlSBW5vdGVzEiEKDGR1cmF0aW9uX21pbhgHIAEoBVILZHVyYXRpb25NaW4SGgoIZXhlY3V0'
    'ZWQYCCABKAhSCGV4ZWN1dGVkEjsKC2V4ZWN1dGVkX2F0GAkgASgLMhouZ29vZ2xlLnByb3RvYn'
    'VmLlRpbWVzdGFtcFIKZXhlY3V0ZWRBdBIgCgxjdWVfY2FyZF9pZHMYCiADKAlSCmN1ZUNhcmRJ'
    'ZHM=');

@$core.Deprecated('Use liveMetricsSnapshotDescriptor instead')
const LiveMetricsSnapshot$json = {
  '1': 'LiveMetricsSnapshot',
  '2': [
    {'1': 'peak_viewers', '3': 1, '4': 1, '5': 3, '10': 'peakViewers'},
    {'1': 'avg_viewers', '3': 2, '4': 1, '5': 3, '10': 'avgViewers'},
    {'1': 'total_viewers', '3': 3, '4': 1, '5': 3, '10': 'totalViewers'},
    {'1': 'total_comments', '3': 4, '4': 1, '5': 3, '10': 'totalComments'},
    {'1': 'total_likes', '3': 5, '4': 1, '5': 3, '10': 'totalLikes'},
    {'1': 'total_shares', '3': 6, '4': 1, '5': 3, '10': 'totalShares'},
    {'1': 'products_shown', '3': 7, '4': 1, '5': 5, '10': 'productsShown'},
    {
      '1': 'orders_during_live',
      '3': 8,
      '4': 1,
      '5': 3,
      '10': 'ordersDuringLive'
    },
    {
      '1': 'revenue_during_live',
      '3': 9,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.Money',
      '10': 'revenueDuringLive'
    },
    {'1': 'engagement_rate', '3': 10, '4': 1, '5': 1, '10': 'engagementRate'},
  ],
};

/// Descriptor for `LiveMetricsSnapshot`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List liveMetricsSnapshotDescriptor = $convert.base64Decode(
    'ChNMaXZlTWV0cmljc1NuYXBzaG90EiEKDHBlYWtfdmlld2VycxgBIAEoA1ILcGVha1ZpZXdlcn'
    'MSHwoLYXZnX3ZpZXdlcnMYAiABKANSCmF2Z1ZpZXdlcnMSIwoNdG90YWxfdmlld2VycxgDIAEo'
    'A1IMdG90YWxWaWV3ZXJzEiUKDnRvdGFsX2NvbW1lbnRzGAQgASgDUg10b3RhbENvbW1lbnRzEh'
    '8KC3RvdGFsX2xpa2VzGAUgASgDUgp0b3RhbExpa2VzEiEKDHRvdGFsX3NoYXJlcxgGIAEoA1IL'
    'dG90YWxTaGFyZXMSJQoOcHJvZHVjdHNfc2hvd24YByABKAVSDXByb2R1Y3RzU2hvd24SLAoSb3'
    'JkZXJzX2R1cmluZ19saXZlGAggASgDUhBvcmRlcnNEdXJpbmdMaXZlEkwKE3JldmVudWVfZHVy'
    'aW5nX2xpdmUYCSABKAsyHC5jcmVhdGl2YW50YS5jb21tb24udjEuTW9uZXlSEXJldmVudWVEdX'
    'JpbmdMaXZlEicKD2VuZ2FnZW1lbnRfcmF0ZRgKIAEoAVIOZW5nYWdlbWVudFJhdGU=');

@$core.Deprecated('Use liveSessionDescriptor instead')
const LiveSession$json = {
  '1': 'LiveSession',
  '2': [
    {'1': 'session_id', '3': 1, '4': 1, '5': 9, '10': 'sessionId'},
    {'1': 'workspace_id', '3': 2, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'title', '3': 3, '4': 1, '5': 9, '10': 'title'},
    {'1': 'platform', '3': 4, '4': 1, '5': 9, '10': 'platform'},
    {
      '1': 'connected_account_id',
      '3': 5,
      '4': 1,
      '5': 9,
      '10': 'connectedAccountId'
    },
    {
      '1': 'status',
      '3': 6,
      '4': 1,
      '5': 14,
      '6': '.creativanta.commerce.v1.LiveSessionStatus',
      '10': 'status'
    },
    {
      '1': 'planned_start_at',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'plannedStartAt'
    },
    {
      '1': 'actual_start_at',
      '3': 8,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'actualStartAt'
    },
    {
      '1': 'actual_end_at',
      '3': 9,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'actualEndAt'
    },
    {
      '1': 'run_of_show',
      '3': 10,
      '4': 3,
      '5': 11,
      '6': '.creativanta.commerce.v1.RunOfShowItem',
      '10': 'runOfShow'
    },
    {
      '1': 'metrics_snapshot',
      '3': 11,
      '4': 1,
      '5': 11,
      '6': '.creativanta.commerce.v1.LiveMetricsSnapshot',
      '10': 'metricsSnapshot'
    },
    {
      '1': 'metadata',
      '3': 12,
      '4': 3,
      '5': 11,
      '6': '.creativanta.commerce.v1.LiveSession.MetadataEntry',
      '10': 'metadata'
    },
    {
      '1': 'created_at',
      '3': 13,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'createdAt'
    },
    {
      '1': 'updated_at',
      '3': 14,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'updatedAt'
    },
  ],
  '3': [LiveSession_MetadataEntry$json],
};

@$core.Deprecated('Use liveSessionDescriptor instead')
const LiveSession_MetadataEntry$json = {
  '1': 'MetadataEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {'1': 'value', '3': 2, '4': 1, '5': 9, '10': 'value'},
  ],
  '7': {'7': true},
};

/// Descriptor for `LiveSession`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List liveSessionDescriptor = $convert.base64Decode(
    'CgtMaXZlU2Vzc2lvbhIdCgpzZXNzaW9uX2lkGAEgASgJUglzZXNzaW9uSWQSIQoMd29ya3NwYW'
    'NlX2lkGAIgASgJUgt3b3Jrc3BhY2VJZBIUCgV0aXRsZRgDIAEoCVIFdGl0bGUSGgoIcGxhdGZv'
    'cm0YBCABKAlSCHBsYXRmb3JtEjAKFGNvbm5lY3RlZF9hY2NvdW50X2lkGAUgASgJUhJjb25uZW'
    'N0ZWRBY2NvdW50SWQSQgoGc3RhdHVzGAYgASgOMiouY3JlYXRpdmFudGEuY29tbWVyY2UudjEu'
    'TGl2ZVNlc3Npb25TdGF0dXNSBnN0YXR1cxJEChBwbGFubmVkX3N0YXJ0X2F0GAcgASgLMhouZ2'
    '9vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIOcGxhbm5lZFN0YXJ0QXQSQgoPYWN0dWFsX3N0YXJ0'
    'X2F0GAggASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFINYWN0dWFsU3RhcnRBdBI+Cg'
    '1hY3R1YWxfZW5kX2F0GAkgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFILYWN0dWFs'
    'RW5kQXQSRgoLcnVuX29mX3Nob3cYCiADKAsyJi5jcmVhdGl2YW50YS5jb21tZXJjZS52MS5SdW'
    '5PZlNob3dJdGVtUglydW5PZlNob3cSVwoQbWV0cmljc19zbmFwc2hvdBgLIAEoCzIsLmNyZWF0'
    'aXZhbnRhLmNvbW1lcmNlLnYxLkxpdmVNZXRyaWNzU25hcHNob3RSD21ldHJpY3NTbmFwc2hvdB'
    'JOCghtZXRhZGF0YRgMIAMoCzIyLmNyZWF0aXZhbnRhLmNvbW1lcmNlLnYxLkxpdmVTZXNzaW9u'
    'Lk1ldGFkYXRhRW50cnlSCG1ldGFkYXRhEjkKCmNyZWF0ZWRfYXQYDSABKAsyGi5nb29nbGUucH'
    'JvdG9idWYuVGltZXN0YW1wUgljcmVhdGVkQXQSOQoKdXBkYXRlZF9hdBgOIAEoCzIaLmdvb2ds'
    'ZS5wcm90b2J1Zi5UaW1lc3RhbXBSCXVwZGF0ZWRBdBo7Cg1NZXRhZGF0YUVudHJ5EhAKA2tleR'
    'gBIAEoCVIDa2V5EhQKBXZhbHVlGAIgASgJUgV2YWx1ZToCOAE=');

@$core.Deprecated('Use cueCardDescriptor instead')
const CueCard$json = {
  '1': 'CueCard',
  '2': [
    {'1': 'cue_card_id', '3': 1, '4': 1, '5': 9, '10': 'cueCardId'},
    {'1': 'session_id', '3': 2, '4': 1, '5': 9, '10': 'sessionId'},
    {'1': 'workspace_id', '3': 3, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'segment_id', '3': 4, '4': 1, '5': 9, '10': 'segmentId'},
    {'1': 'cue_type', '3': 5, '4': 1, '5': 9, '10': 'cueType'},
    {'1': 'title', '3': 6, '4': 1, '5': 9, '10': 'title'},
    {'1': 'body', '3': 7, '4': 1, '5': 9, '10': 'body'},
    {'1': 'pinned_product_id', '3': 8, '4': 1, '5': 9, '10': 'pinnedProductId'},
    {'1': 'pinned_offer_id', '3': 9, '4': 1, '5': 9, '10': 'pinnedOfferId'},
    {'1': 'display_order', '3': 10, '4': 1, '5': 5, '10': 'displayOrder'},
    {
      '1': 'triggered_at',
      '3': 11,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'triggeredAt'
    },
    {
      '1': 'status',
      '3': 12,
      '4': 1,
      '5': 14,
      '6': '.creativanta.commerce.v1.CueCardStatus',
      '10': 'status'
    },
    {
      '1': 'created_at',
      '3': 13,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'createdAt'
    },
    {
      '1': 'updated_at',
      '3': 14,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'updatedAt'
    },
  ],
};

/// Descriptor for `CueCard`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List cueCardDescriptor = $convert.base64Decode(
    'CgdDdWVDYXJkEh4KC2N1ZV9jYXJkX2lkGAEgASgJUgljdWVDYXJkSWQSHQoKc2Vzc2lvbl9pZB'
    'gCIAEoCVIJc2Vzc2lvbklkEiEKDHdvcmtzcGFjZV9pZBgDIAEoCVILd29ya3NwYWNlSWQSHQoK'
    'c2VnbWVudF9pZBgEIAEoCVIJc2VnbWVudElkEhkKCGN1ZV90eXBlGAUgASgJUgdjdWVUeXBlEh'
    'QKBXRpdGxlGAYgASgJUgV0aXRsZRISCgRib2R5GAcgASgJUgRib2R5EioKEXBpbm5lZF9wcm9k'
    'dWN0X2lkGAggASgJUg9waW5uZWRQcm9kdWN0SWQSJgoPcGlubmVkX29mZmVyX2lkGAkgASgJUg'
    '1waW5uZWRPZmZlcklkEiMKDWRpc3BsYXlfb3JkZXIYCiABKAVSDGRpc3BsYXlPcmRlchI9Cgx0'
    'cmlnZ2VyZWRfYXQYCyABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUgt0cmlnZ2VyZW'
    'RBdBI+CgZzdGF0dXMYDCABKA4yJi5jcmVhdGl2YW50YS5jb21tZXJjZS52MS5DdWVDYXJkU3Rh'
    'dHVzUgZzdGF0dXMSOQoKY3JlYXRlZF9hdBgNIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3'
    'RhbXBSCWNyZWF0ZWRBdBI5Cgp1cGRhdGVkX2F0GA4gASgLMhouZ29vZ2xlLnByb3RvYnVmLlRp'
    'bWVzdGFtcFIJdXBkYXRlZEF0');

@$core.Deprecated('Use highlightDescriptor instead')
const Highlight$json = {
  '1': 'Highlight',
  '2': [
    {'1': 'highlight_id', '3': 1, '4': 1, '5': 9, '10': 'highlightId'},
    {'1': 'session_id', '3': 2, '4': 1, '5': 9, '10': 'sessionId'},
    {'1': 'workspace_id', '3': 3, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'title', '3': 4, '4': 1, '5': 9, '10': 'title'},
    {
      '1': 'start_offset_seconds',
      '3': 5,
      '4': 1,
      '5': 5,
      '10': 'startOffsetSeconds'
    },
    {
      '1': 'end_offset_seconds',
      '3': 6,
      '4': 1,
      '5': 5,
      '10': 'endOffsetSeconds'
    },
    {'1': 'highlight_type', '3': 7, '4': 1, '5': 9, '10': 'highlightType'},
    {'1': 'auto_detected', '3': 8, '4': 1, '5': 8, '10': 'autoDetected'},
    {'1': 'asset_id', '3': 9, '4': 1, '5': 9, '10': 'assetId'},
    {'1': 'engagement_score', '3': 10, '4': 1, '5': 1, '10': 'engagementScore'},
    {'1': 'notes', '3': 11, '4': 1, '5': 9, '10': 'notes'},
    {'1': 'pinned_offer_id', '3': 12, '4': 1, '5': 9, '10': 'pinnedOfferId'},
    {
      '1': 'pinned_product_id',
      '3': 13,
      '4': 1,
      '5': 9,
      '10': 'pinnedProductId'
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

/// Descriptor for `Highlight`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List highlightDescriptor = $convert.base64Decode(
    'CglIaWdobGlnaHQSIQoMaGlnaGxpZ2h0X2lkGAEgASgJUgtoaWdobGlnaHRJZBIdCgpzZXNzaW'
    '9uX2lkGAIgASgJUglzZXNzaW9uSWQSIQoMd29ya3NwYWNlX2lkGAMgASgJUgt3b3Jrc3BhY2VJ'
    'ZBIUCgV0aXRsZRgEIAEoCVIFdGl0bGUSMAoUc3RhcnRfb2Zmc2V0X3NlY29uZHMYBSABKAVSEn'
    'N0YXJ0T2Zmc2V0U2Vjb25kcxIsChJlbmRfb2Zmc2V0X3NlY29uZHMYBiABKAVSEGVuZE9mZnNl'
    'dFNlY29uZHMSJQoOaGlnaGxpZ2h0X3R5cGUYByABKAlSDWhpZ2hsaWdodFR5cGUSIwoNYXV0b1'
    '9kZXRlY3RlZBgIIAEoCFIMYXV0b0RldGVjdGVkEhkKCGFzc2V0X2lkGAkgASgJUgdhc3NldElk'
    'EikKEGVuZ2FnZW1lbnRfc2NvcmUYCiABKAFSD2VuZ2FnZW1lbnRTY29yZRIUCgVub3RlcxgLIA'
    'EoCVIFbm90ZXMSJgoPcGlubmVkX29mZmVyX2lkGAwgASgJUg1waW5uZWRPZmZlcklkEioKEXBp'
    'bm5lZF9wcm9kdWN0X2lkGA0gASgJUg9waW5uZWRQcm9kdWN0SWQSOQoKY3JlYXRlZF9hdBgOIA'
    'EoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSCWNyZWF0ZWRBdBI5Cgp1cGRhdGVkX2F0'
    'GA8gASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIJdXBkYXRlZEF0');

@$core.Deprecated('Use traceableOrderLinkDescriptor instead')
const TraceableOrderLink$json = {
  '1': 'TraceableOrderLink',
  '2': [
    {'1': 'order_id', '3': 1, '4': 1, '5': 9, '10': 'orderId'},
    {'1': 'product_id', '3': 2, '4': 1, '5': 9, '10': 'productId'},
    {'1': 'offer_id', '3': 3, '4': 1, '5': 9, '10': 'offerId'},
    {'1': 'customer_id', '3': 4, '4': 1, '5': 9, '10': 'customerId'},
    {
      '1': 'amount',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.Money',
      '10': 'amount'
    },
    {
      '1': 'created_at',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'createdAt'
    },
    {
      '1': 'reconciliation_state',
      '3': 7,
      '4': 1,
      '5': 9,
      '10': 'reconciliationState'
    },
  ],
};

/// Descriptor for `TraceableOrderLink`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List traceableOrderLinkDescriptor = $convert.base64Decode(
    'ChJUcmFjZWFibGVPcmRlckxpbmsSGQoIb3JkZXJfaWQYASABKAlSB29yZGVySWQSHQoKcHJvZH'
    'VjdF9pZBgCIAEoCVIJcHJvZHVjdElkEhkKCG9mZmVyX2lkGAMgASgJUgdvZmZlcklkEh8KC2N1'
    'c3RvbWVyX2lkGAQgASgJUgpjdXN0b21lcklkEjQKBmFtb3VudBgFIAEoCzIcLmNyZWF0aXZhbn'
    'RhLmNvbW1vbi52MS5Nb25leVIGYW1vdW50EjkKCmNyZWF0ZWRfYXQYBiABKAsyGi5nb29nbGUu'
    'cHJvdG9idWYuVGltZXN0YW1wUgljcmVhdGVkQXQSMQoUcmVjb25jaWxpYXRpb25fc3RhdGUYBy'
    'ABKAlSE3JlY29uY2lsaWF0aW9uU3RhdGU=');

@$core.Deprecated('Use postLiveProofSummaryDescriptor instead')
const PostLiveProofSummary$json = {
  '1': 'PostLiveProofSummary',
  '2': [
    {'1': 'summary_id', '3': 1, '4': 1, '5': 9, '10': 'summaryId'},
    {'1': 'session_id', '3': 2, '4': 1, '5': 9, '10': 'sessionId'},
    {'1': 'workspace_id', '3': 3, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'session_title', '3': 4, '4': 1, '5': 9, '10': 'sessionTitle'},
    {'1': 'platform', '3': 5, '4': 1, '5': 9, '10': 'platform'},
    {
      '1': 'metrics',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.creativanta.commerce.v1.LiveMetricsSnapshot',
      '10': 'metrics'
    },
    {
      '1': 'highlights',
      '3': 7,
      '4': 3,
      '5': 11,
      '6': '.creativanta.commerce.v1.Highlight',
      '10': 'highlights'
    },
    {
      '1': 'extracted_clip_asset_ids',
      '3': 8,
      '4': 3,
      '5': 9,
      '10': 'extractedClipAssetIds'
    },
    {
      '1': 'orders',
      '3': 9,
      '4': 3,
      '5': 11,
      '6': '.creativanta.commerce.v1.TraceableOrderLink',
      '10': 'orders'
    },
    {
      '1': 'total_revenue',
      '3': 10,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.Money',
      '10': 'totalRevenue'
    },
    {'1': 'source_class', '3': 11, '4': 1, '5': 9, '10': 'sourceClass'},
    {'1': 'proof_bundle_id', '3': 12, '4': 1, '5': 9, '10': 'proofBundleId'},
    {
      '1': 'generated_at',
      '3': 13,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'generatedAt'
    },
  ],
};

/// Descriptor for `PostLiveProofSummary`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List postLiveProofSummaryDescriptor = $convert.base64Decode(
    'ChRQb3N0TGl2ZVByb29mU3VtbWFyeRIdCgpzdW1tYXJ5X2lkGAEgASgJUglzdW1tYXJ5SWQSHQ'
    'oKc2Vzc2lvbl9pZBgCIAEoCVIJc2Vzc2lvbklkEiEKDHdvcmtzcGFjZV9pZBgDIAEoCVILd29y'
    'a3NwYWNlSWQSIwoNc2Vzc2lvbl90aXRsZRgEIAEoCVIMc2Vzc2lvblRpdGxlEhoKCHBsYXRmb3'
    'JtGAUgASgJUghwbGF0Zm9ybRJGCgdtZXRyaWNzGAYgASgLMiwuY3JlYXRpdmFudGEuY29tbWVy'
    'Y2UudjEuTGl2ZU1ldHJpY3NTbmFwc2hvdFIHbWV0cmljcxJCCgpoaWdobGlnaHRzGAcgAygLMi'
    'IuY3JlYXRpdmFudGEuY29tbWVyY2UudjEuSGlnaGxpZ2h0UgpoaWdobGlnaHRzEjcKGGV4dHJh'
    'Y3RlZF9jbGlwX2Fzc2V0X2lkcxgIIAMoCVIVZXh0cmFjdGVkQ2xpcEFzc2V0SWRzEkMKBm9yZG'
    'VycxgJIAMoCzIrLmNyZWF0aXZhbnRhLmNvbW1lcmNlLnYxLlRyYWNlYWJsZU9yZGVyTGlua1IG'
    'b3JkZXJzEkEKDXRvdGFsX3JldmVudWUYCiABKAsyHC5jcmVhdGl2YW50YS5jb21tb24udjEuTW'
    '9uZXlSDHRvdGFsUmV2ZW51ZRIhCgxzb3VyY2VfY2xhc3MYCyABKAlSC3NvdXJjZUNsYXNzEiYK'
    'D3Byb29mX2J1bmRsZV9pZBgMIAEoCVINcHJvb2ZCdW5kbGVJZBI9CgxnZW5lcmF0ZWRfYXQYDS'
    'ABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUgtnZW5lcmF0ZWRBdA==');

@$core.Deprecated('Use commentTriageItemDescriptor instead')
const CommentTriageItem$json = {
  '1': 'CommentTriageItem',
  '2': [
    {'1': 'comment_id', '3': 1, '4': 1, '5': 9, '10': 'commentId'},
    {'1': 'session_id', '3': 2, '4': 1, '5': 9, '10': 'sessionId'},
    {'1': 'author', '3': 3, '4': 1, '5': 9, '10': 'author'},
    {'1': 'text', '3': 4, '4': 1, '5': 9, '10': 'text'},
    {'1': 'intent', '3': 5, '4': 1, '5': 9, '10': 'intent'},
    {'1': 'is_priority', '3': 6, '4': 1, '5': 8, '10': 'isPriority'},
    {
      '1': 'timestamp',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'timestamp'
    },
  ],
};

/// Descriptor for `CommentTriageItem`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List commentTriageItemDescriptor = $convert.base64Decode(
    'ChFDb21tZW50VHJpYWdlSXRlbRIdCgpjb21tZW50X2lkGAEgASgJUgljb21tZW50SWQSHQoKc2'
    'Vzc2lvbl9pZBgCIAEoCVIJc2Vzc2lvbklkEhYKBmF1dGhvchgDIAEoCVIGYXV0aG9yEhIKBHRl'
    'eHQYBCABKAlSBHRleHQSFgoGaW50ZW50GAUgASgJUgZpbnRlbnQSHwoLaXNfcHJpb3JpdHkYBi'
    'ABKAhSCmlzUHJpb3JpdHkSOAoJdGltZXN0YW1wGAcgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRp'
    'bWVzdGFtcFIJdGltZXN0YW1w');

@$core
    .Deprecated('Use liveCommerceServiceCreateSessionRequestDescriptor instead')
const LiveCommerceServiceCreateSessionRequest$json = {
  '1': 'LiveCommerceServiceCreateSessionRequest',
  '2': [
    {
      '1': 'context',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.CommandContext',
      '10': 'context'
    },
    {'1': 'title', '3': 2, '4': 1, '5': 9, '10': 'title'},
    {'1': 'platform', '3': 3, '4': 1, '5': 9, '10': 'platform'},
    {
      '1': 'connected_account_id',
      '3': 4,
      '4': 1,
      '5': 9,
      '10': 'connectedAccountId'
    },
    {
      '1': 'planned_start_at',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'plannedStartAt'
    },
    {
      '1': 'run_of_show',
      '3': 6,
      '4': 3,
      '5': 11,
      '6': '.creativanta.commerce.v1.RunOfShowItem',
      '10': 'runOfShow'
    },
    {
      '1': 'metadata',
      '3': 7,
      '4': 3,
      '5': 11,
      '6':
          '.creativanta.commerce.v1.LiveCommerceServiceCreateSessionRequest.MetadataEntry',
      '10': 'metadata'
    },
  ],
  '3': [LiveCommerceServiceCreateSessionRequest_MetadataEntry$json],
};

@$core
    .Deprecated('Use liveCommerceServiceCreateSessionRequestDescriptor instead')
const LiveCommerceServiceCreateSessionRequest_MetadataEntry$json = {
  '1': 'MetadataEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {'1': 'value', '3': 2, '4': 1, '5': 9, '10': 'value'},
  ],
  '7': {'7': true},
};

/// Descriptor for `LiveCommerceServiceCreateSessionRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List liveCommerceServiceCreateSessionRequestDescriptor = $convert.base64Decode(
    'CidMaXZlQ29tbWVyY2VTZXJ2aWNlQ3JlYXRlU2Vzc2lvblJlcXVlc3QSPwoHY29udGV4dBgBIA'
    'EoCzIlLmNyZWF0aXZhbnRhLmNvbW1vbi52MS5Db21tYW5kQ29udGV4dFIHY29udGV4dBIUCgV0'
    'aXRsZRgCIAEoCVIFdGl0bGUSGgoIcGxhdGZvcm0YAyABKAlSCHBsYXRmb3JtEjAKFGNvbm5lY3'
    'RlZF9hY2NvdW50X2lkGAQgASgJUhJjb25uZWN0ZWRBY2NvdW50SWQSRAoQcGxhbm5lZF9zdGFy'
    'dF9hdBgFIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSDnBsYW5uZWRTdGFydEF0Ek'
    'YKC3J1bl9vZl9zaG93GAYgAygLMiYuY3JlYXRpdmFudGEuY29tbWVyY2UudjEuUnVuT2ZTaG93'
    'SXRlbVIJcnVuT2ZTaG93EmoKCG1ldGFkYXRhGAcgAygLMk4uY3JlYXRpdmFudGEuY29tbWVyY2'
    'UudjEuTGl2ZUNvbW1lcmNlU2VydmljZUNyZWF0ZVNlc3Npb25SZXF1ZXN0Lk1ldGFkYXRhRW50'
    'cnlSCG1ldGFkYXRhGjsKDU1ldGFkYXRhRW50cnkSEAoDa2V5GAEgASgJUgNrZXkSFAoFdmFsdW'
    'UYAiABKAlSBXZhbHVlOgI4AQ==');

@$core.Deprecated(
    'Use liveCommerceServiceCreateSessionResponseDescriptor instead')
const LiveCommerceServiceCreateSessionResponse$json = {
  '1': 'LiveCommerceServiceCreateSessionResponse',
  '2': [
    {
      '1': 'session',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.commerce.v1.LiveSession',
      '10': 'session'
    },
    {'1': 'is_duplicate', '3': 2, '4': 1, '5': 8, '10': 'isDuplicate'},
  ],
};

/// Descriptor for `LiveCommerceServiceCreateSessionResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List liveCommerceServiceCreateSessionResponseDescriptor =
    $convert.base64Decode(
        'CihMaXZlQ29tbWVyY2VTZXJ2aWNlQ3JlYXRlU2Vzc2lvblJlc3BvbnNlEj4KB3Nlc3Npb24YAS'
        'ABKAsyJC5jcmVhdGl2YW50YS5jb21tZXJjZS52MS5MaXZlU2Vzc2lvblIHc2Vzc2lvbhIhCgxp'
        'c19kdXBsaWNhdGUYAiABKAhSC2lzRHVwbGljYXRl');

@$core.Deprecated('Use liveCommerceServiceGetRequestDescriptor instead')
const LiveCommerceServiceGetRequest$json = {
  '1': 'LiveCommerceServiceGetRequest',
  '2': [
    {'1': 'session_id', '3': 1, '4': 1, '5': 9, '10': 'sessionId'},
    {'1': 'workspace_id', '3': 2, '4': 1, '5': 9, '10': 'workspaceId'},
  ],
};

/// Descriptor for `LiveCommerceServiceGetRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List liveCommerceServiceGetRequestDescriptor =
    $convert.base64Decode(
        'Ch1MaXZlQ29tbWVyY2VTZXJ2aWNlR2V0UmVxdWVzdBIdCgpzZXNzaW9uX2lkGAEgASgJUglzZX'
        'NzaW9uSWQSIQoMd29ya3NwYWNlX2lkGAIgASgJUgt3b3Jrc3BhY2VJZA==');

@$core.Deprecated('Use liveCommerceServiceGetResponseDescriptor instead')
const LiveCommerceServiceGetResponse$json = {
  '1': 'LiveCommerceServiceGetResponse',
  '2': [
    {
      '1': 'session',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.commerce.v1.LiveSession',
      '10': 'session'
    },
    {
      '1': 'cue_cards',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.creativanta.commerce.v1.CueCard',
      '10': 'cueCards'
    },
    {
      '1': 'highlights',
      '3': 3,
      '4': 3,
      '5': 11,
      '6': '.creativanta.commerce.v1.Highlight',
      '10': 'highlights'
    },
  ],
};

/// Descriptor for `LiveCommerceServiceGetResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List liveCommerceServiceGetResponseDescriptor = $convert.base64Decode(
    'Ch5MaXZlQ29tbWVyY2VTZXJ2aWNlR2V0UmVzcG9uc2USPgoHc2Vzc2lvbhgBIAEoCzIkLmNyZW'
    'F0aXZhbnRhLmNvbW1lcmNlLnYxLkxpdmVTZXNzaW9uUgdzZXNzaW9uEj0KCWN1ZV9jYXJkcxgC'
    'IAMoCzIgLmNyZWF0aXZhbnRhLmNvbW1lcmNlLnYxLkN1ZUNhcmRSCGN1ZUNhcmRzEkIKCmhpZ2'
    'hsaWdodHMYAyADKAsyIi5jcmVhdGl2YW50YS5jb21tZXJjZS52MS5IaWdobGlnaHRSCmhpZ2hs'
    'aWdodHM=');

@$core.Deprecated('Use liveCommerceServiceListRequestDescriptor instead')
const LiveCommerceServiceListRequest$json = {
  '1': 'LiveCommerceServiceListRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'status', '3': 2, '4': 1, '5': 9, '10': 'status'},
    {'1': 'platform', '3': 3, '4': 1, '5': 9, '10': 'platform'},
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

/// Descriptor for `LiveCommerceServiceListRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List liveCommerceServiceListRequestDescriptor =
    $convert.base64Decode(
        'Ch5MaXZlQ29tbWVyY2VTZXJ2aWNlTGlzdFJlcXVlc3QSIQoMd29ya3NwYWNlX2lkGAEgASgJUg'
        't3b3Jrc3BhY2VJZBIWCgZzdGF0dXMYAiABKAlSBnN0YXR1cxIaCghwbGF0Zm9ybRgDIAEoCVII'
        'cGxhdGZvcm0SQQoKcGFnaW5hdGlvbhgEIAEoCzIhLmNyZWF0aXZhbnRhLmNvbW1vbi52MS5QYW'
        'dpbmF0aW9uUgpwYWdpbmF0aW9u');

@$core.Deprecated('Use liveCommerceServiceListResponseDescriptor instead')
const LiveCommerceServiceListResponse$json = {
  '1': 'LiveCommerceServiceListResponse',
  '2': [
    {
      '1': 'sessions',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.creativanta.commerce.v1.LiveSession',
      '10': 'sessions'
    },
    {
      '1': 'pagination',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.PaginatedResponse',
      '10': 'pagination'
    },
  ],
};

/// Descriptor for `LiveCommerceServiceListResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List liveCommerceServiceListResponseDescriptor =
    $convert.base64Decode(
        'Ch9MaXZlQ29tbWVyY2VTZXJ2aWNlTGlzdFJlc3BvbnNlEkAKCHNlc3Npb25zGAEgAygLMiQuY3'
        'JlYXRpdmFudGEuY29tbWVyY2UudjEuTGl2ZVNlc3Npb25SCHNlc3Npb25zEkgKCnBhZ2luYXRp'
        'b24YAiABKAsyKC5jcmVhdGl2YW50YS5jb21tb24udjEuUGFnaW5hdGVkUmVzcG9uc2VSCnBhZ2'
        'luYXRpb24=');

@$core
    .Deprecated('Use liveCommerceServiceStartSessionRequestDescriptor instead')
const LiveCommerceServiceStartSessionRequest$json = {
  '1': 'LiveCommerceServiceStartSessionRequest',
  '2': [
    {
      '1': 'context',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.CommandContext',
      '10': 'context'
    },
    {'1': 'session_id', '3': 2, '4': 1, '5': 9, '10': 'sessionId'},
  ],
};

/// Descriptor for `LiveCommerceServiceStartSessionRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List liveCommerceServiceStartSessionRequestDescriptor =
    $convert.base64Decode(
        'CiZMaXZlQ29tbWVyY2VTZXJ2aWNlU3RhcnRTZXNzaW9uUmVxdWVzdBI/Cgdjb250ZXh0GAEgAS'
        'gLMiUuY3JlYXRpdmFudGEuY29tbW9uLnYxLkNvbW1hbmRDb250ZXh0Ugdjb250ZXh0Eh0KCnNl'
        'c3Npb25faWQYAiABKAlSCXNlc3Npb25JZA==');

@$core
    .Deprecated('Use liveCommerceServiceStartSessionResponseDescriptor instead')
const LiveCommerceServiceStartSessionResponse$json = {
  '1': 'LiveCommerceServiceStartSessionResponse',
  '2': [
    {
      '1': 'session',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.commerce.v1.LiveSession',
      '10': 'session'
    },
    {'1': 'is_duplicate', '3': 2, '4': 1, '5': 8, '10': 'isDuplicate'},
  ],
};

/// Descriptor for `LiveCommerceServiceStartSessionResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List liveCommerceServiceStartSessionResponseDescriptor =
    $convert.base64Decode(
        'CidMaXZlQ29tbWVyY2VTZXJ2aWNlU3RhcnRTZXNzaW9uUmVzcG9uc2USPgoHc2Vzc2lvbhgBIA'
        'EoCzIkLmNyZWF0aXZhbnRhLmNvbW1lcmNlLnYxLkxpdmVTZXNzaW9uUgdzZXNzaW9uEiEKDGlz'
        'X2R1cGxpY2F0ZRgCIAEoCFILaXNEdXBsaWNhdGU=');

@$core.Deprecated('Use liveCommerceServiceEndSessionRequestDescriptor instead')
const LiveCommerceServiceEndSessionRequest$json = {
  '1': 'LiveCommerceServiceEndSessionRequest',
  '2': [
    {
      '1': 'context',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.CommandContext',
      '10': 'context'
    },
    {'1': 'session_id', '3': 2, '4': 1, '5': 9, '10': 'sessionId'},
  ],
};

/// Descriptor for `LiveCommerceServiceEndSessionRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List liveCommerceServiceEndSessionRequestDescriptor =
    $convert.base64Decode(
        'CiRMaXZlQ29tbWVyY2VTZXJ2aWNlRW5kU2Vzc2lvblJlcXVlc3QSPwoHY29udGV4dBgBIAEoCz'
        'IlLmNyZWF0aXZhbnRhLmNvbW1vbi52MS5Db21tYW5kQ29udGV4dFIHY29udGV4dBIdCgpzZXNz'
        'aW9uX2lkGAIgASgJUglzZXNzaW9uSWQ=');

@$core.Deprecated('Use liveCommerceServiceEndSessionResponseDescriptor instead')
const LiveCommerceServiceEndSessionResponse$json = {
  '1': 'LiveCommerceServiceEndSessionResponse',
  '2': [
    {
      '1': 'session',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.commerce.v1.LiveSession',
      '10': 'session'
    },
    {
      '1': 'summary',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.creativanta.commerce.v1.PostLiveProofSummary',
      '10': 'summary'
    },
    {'1': 'is_duplicate', '3': 3, '4': 1, '5': 8, '10': 'isDuplicate'},
  ],
};

/// Descriptor for `LiveCommerceServiceEndSessionResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List liveCommerceServiceEndSessionResponseDescriptor =
    $convert.base64Decode(
        'CiVMaXZlQ29tbWVyY2VTZXJ2aWNlRW5kU2Vzc2lvblJlc3BvbnNlEj4KB3Nlc3Npb24YASABKA'
        'syJC5jcmVhdGl2YW50YS5jb21tZXJjZS52MS5MaXZlU2Vzc2lvblIHc2Vzc2lvbhJHCgdzdW1t'
        'YXJ5GAIgASgLMi0uY3JlYXRpdmFudGEuY29tbWVyY2UudjEuUG9zdExpdmVQcm9vZlN1bW1hcn'
        'lSB3N1bW1hcnkSIQoMaXNfZHVwbGljYXRlGAMgASgIUgtpc0R1cGxpY2F0ZQ==');

@$core
    .Deprecated('Use liveCommerceServicePauseSessionRequestDescriptor instead')
const LiveCommerceServicePauseSessionRequest$json = {
  '1': 'LiveCommerceServicePauseSessionRequest',
  '2': [
    {
      '1': 'context',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.CommandContext',
      '10': 'context'
    },
    {'1': 'session_id', '3': 2, '4': 1, '5': 9, '10': 'sessionId'},
  ],
};

/// Descriptor for `LiveCommerceServicePauseSessionRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List liveCommerceServicePauseSessionRequestDescriptor =
    $convert.base64Decode(
        'CiZMaXZlQ29tbWVyY2VTZXJ2aWNlUGF1c2VTZXNzaW9uUmVxdWVzdBI/Cgdjb250ZXh0GAEgAS'
        'gLMiUuY3JlYXRpdmFudGEuY29tbW9uLnYxLkNvbW1hbmRDb250ZXh0Ugdjb250ZXh0Eh0KCnNl'
        'c3Npb25faWQYAiABKAlSCXNlc3Npb25JZA==');

@$core
    .Deprecated('Use liveCommerceServicePauseSessionResponseDescriptor instead')
const LiveCommerceServicePauseSessionResponse$json = {
  '1': 'LiveCommerceServicePauseSessionResponse',
  '2': [
    {
      '1': 'session',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.commerce.v1.LiveSession',
      '10': 'session'
    },
    {'1': 'is_duplicate', '3': 2, '4': 1, '5': 8, '10': 'isDuplicate'},
  ],
};

/// Descriptor for `LiveCommerceServicePauseSessionResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List liveCommerceServicePauseSessionResponseDescriptor =
    $convert.base64Decode(
        'CidMaXZlQ29tbWVyY2VTZXJ2aWNlUGF1c2VTZXNzaW9uUmVzcG9uc2USPgoHc2Vzc2lvbhgBIA'
        'EoCzIkLmNyZWF0aXZhbnRhLmNvbW1lcmNlLnYxLkxpdmVTZXNzaW9uUgdzZXNzaW9uEiEKDGlz'
        'X2R1cGxpY2F0ZRgCIAEoCFILaXNEdXBsaWNhdGU=');

@$core
    .Deprecated('Use liveCommerceServiceResumeSessionRequestDescriptor instead')
const LiveCommerceServiceResumeSessionRequest$json = {
  '1': 'LiveCommerceServiceResumeSessionRequest',
  '2': [
    {
      '1': 'context',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.CommandContext',
      '10': 'context'
    },
    {'1': 'session_id', '3': 2, '4': 1, '5': 9, '10': 'sessionId'},
  ],
};

/// Descriptor for `LiveCommerceServiceResumeSessionRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List liveCommerceServiceResumeSessionRequestDescriptor =
    $convert.base64Decode(
        'CidMaXZlQ29tbWVyY2VTZXJ2aWNlUmVzdW1lU2Vzc2lvblJlcXVlc3QSPwoHY29udGV4dBgBIA'
        'EoCzIlLmNyZWF0aXZhbnRhLmNvbW1vbi52MS5Db21tYW5kQ29udGV4dFIHY29udGV4dBIdCgpz'
        'ZXNzaW9uX2lkGAIgASgJUglzZXNzaW9uSWQ=');

@$core.Deprecated(
    'Use liveCommerceServiceResumeSessionResponseDescriptor instead')
const LiveCommerceServiceResumeSessionResponse$json = {
  '1': 'LiveCommerceServiceResumeSessionResponse',
  '2': [
    {
      '1': 'session',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.commerce.v1.LiveSession',
      '10': 'session'
    },
    {'1': 'is_duplicate', '3': 2, '4': 1, '5': 8, '10': 'isDuplicate'},
  ],
};

/// Descriptor for `LiveCommerceServiceResumeSessionResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List liveCommerceServiceResumeSessionResponseDescriptor =
    $convert.base64Decode(
        'CihMaXZlQ29tbWVyY2VTZXJ2aWNlUmVzdW1lU2Vzc2lvblJlc3BvbnNlEj4KB3Nlc3Npb24YAS'
        'ABKAsyJC5jcmVhdGl2YW50YS5jb21tZXJjZS52MS5MaXZlU2Vzc2lvblIHc2Vzc2lvbhIhCgxp'
        'c19kdXBsaWNhdGUYAiABKAhSC2lzRHVwbGljYXRl');

@$core.Deprecated('Use liveCommerceServiceAddCueRequestDescriptor instead')
const LiveCommerceServiceAddCueRequest$json = {
  '1': 'LiveCommerceServiceAddCueRequest',
  '2': [
    {
      '1': 'context',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.CommandContext',
      '10': 'context'
    },
    {'1': 'session_id', '3': 2, '4': 1, '5': 9, '10': 'sessionId'},
    {'1': 'cue_type', '3': 3, '4': 1, '5': 9, '10': 'cueType'},
    {'1': 'title', '3': 4, '4': 1, '5': 9, '10': 'title'},
    {'1': 'body', '3': 5, '4': 1, '5': 9, '10': 'body'},
    {'1': 'pinned_product_id', '3': 6, '4': 1, '5': 9, '10': 'pinnedProductId'},
    {'1': 'pinned_offer_id', '3': 7, '4': 1, '5': 9, '10': 'pinnedOfferId'},
    {'1': 'display_order', '3': 8, '4': 1, '5': 5, '10': 'displayOrder'},
  ],
};

/// Descriptor for `LiveCommerceServiceAddCueRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List liveCommerceServiceAddCueRequestDescriptor = $convert.base64Decode(
    'CiBMaXZlQ29tbWVyY2VTZXJ2aWNlQWRkQ3VlUmVxdWVzdBI/Cgdjb250ZXh0GAEgASgLMiUuY3'
    'JlYXRpdmFudGEuY29tbW9uLnYxLkNvbW1hbmRDb250ZXh0Ugdjb250ZXh0Eh0KCnNlc3Npb25f'
    'aWQYAiABKAlSCXNlc3Npb25JZBIZCghjdWVfdHlwZRgDIAEoCVIHY3VlVHlwZRIUCgV0aXRsZR'
    'gEIAEoCVIFdGl0bGUSEgoEYm9keRgFIAEoCVIEYm9keRIqChFwaW5uZWRfcHJvZHVjdF9pZBgG'
    'IAEoCVIPcGlubmVkUHJvZHVjdElkEiYKD3Bpbm5lZF9vZmZlcl9pZBgHIAEoCVINcGlubmVkT2'
    'ZmZXJJZBIjCg1kaXNwbGF5X29yZGVyGAggASgFUgxkaXNwbGF5T3JkZXI=');

@$core.Deprecated('Use liveCommerceServiceAddCueResponseDescriptor instead')
const LiveCommerceServiceAddCueResponse$json = {
  '1': 'LiveCommerceServiceAddCueResponse',
  '2': [
    {
      '1': 'cue_card',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.commerce.v1.CueCard',
      '10': 'cueCard'
    },
    {'1': 'is_duplicate', '3': 2, '4': 1, '5': 8, '10': 'isDuplicate'},
  ],
};

/// Descriptor for `LiveCommerceServiceAddCueResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List liveCommerceServiceAddCueResponseDescriptor =
    $convert.base64Decode(
        'CiFMaXZlQ29tbWVyY2VTZXJ2aWNlQWRkQ3VlUmVzcG9uc2USOwoIY3VlX2NhcmQYASABKAsyIC'
        '5jcmVhdGl2YW50YS5jb21tZXJjZS52MS5DdWVDYXJkUgdjdWVDYXJkEiEKDGlzX2R1cGxpY2F0'
        'ZRgCIAEoCFILaXNEdXBsaWNhdGU=');

@$core.Deprecated('Use liveCommerceServiceRemoveCueRequestDescriptor instead')
const LiveCommerceServiceRemoveCueRequest$json = {
  '1': 'LiveCommerceServiceRemoveCueRequest',
  '2': [
    {
      '1': 'context',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.CommandContext',
      '10': 'context'
    },
    {'1': 'session_id', '3': 2, '4': 1, '5': 9, '10': 'sessionId'},
    {'1': 'cue_card_id', '3': 3, '4': 1, '5': 9, '10': 'cueCardId'},
  ],
};

/// Descriptor for `LiveCommerceServiceRemoveCueRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List liveCommerceServiceRemoveCueRequestDescriptor =
    $convert.base64Decode(
        'CiNMaXZlQ29tbWVyY2VTZXJ2aWNlUmVtb3ZlQ3VlUmVxdWVzdBI/Cgdjb250ZXh0GAEgASgLMi'
        'UuY3JlYXRpdmFudGEuY29tbW9uLnYxLkNvbW1hbmRDb250ZXh0Ugdjb250ZXh0Eh0KCnNlc3Np'
        'b25faWQYAiABKAlSCXNlc3Npb25JZBIeCgtjdWVfY2FyZF9pZBgDIAEoCVIJY3VlQ2FyZElk');

@$core.Deprecated('Use liveCommerceServiceRemoveCueResponseDescriptor instead')
const LiveCommerceServiceRemoveCueResponse$json = {
  '1': 'LiveCommerceServiceRemoveCueResponse',
  '2': [
    {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
  ],
};

/// Descriptor for `LiveCommerceServiceRemoveCueResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List liveCommerceServiceRemoveCueResponseDescriptor =
    $convert.base64Decode(
        'CiRMaXZlQ29tbWVyY2VTZXJ2aWNlUmVtb3ZlQ3VlUmVzcG9uc2USGAoHc3VjY2VzcxgBIAEoCF'
        'IHc3VjY2Vzcw==');

@$core.Deprecated('Use liveCommerceServiceTriggerCueRequestDescriptor instead')
const LiveCommerceServiceTriggerCueRequest$json = {
  '1': 'LiveCommerceServiceTriggerCueRequest',
  '2': [
    {
      '1': 'context',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.CommandContext',
      '10': 'context'
    },
    {'1': 'session_id', '3': 2, '4': 1, '5': 9, '10': 'sessionId'},
    {'1': 'cue_card_id', '3': 3, '4': 1, '5': 9, '10': 'cueCardId'},
  ],
};

/// Descriptor for `LiveCommerceServiceTriggerCueRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List liveCommerceServiceTriggerCueRequestDescriptor =
    $convert.base64Decode(
        'CiRMaXZlQ29tbWVyY2VTZXJ2aWNlVHJpZ2dlckN1ZVJlcXVlc3QSPwoHY29udGV4dBgBIAEoCz'
        'IlLmNyZWF0aXZhbnRhLmNvbW1vbi52MS5Db21tYW5kQ29udGV4dFIHY29udGV4dBIdCgpzZXNz'
        'aW9uX2lkGAIgASgJUglzZXNzaW9uSWQSHgoLY3VlX2NhcmRfaWQYAyABKAlSCWN1ZUNhcmRJZA'
        '==');

@$core.Deprecated('Use liveCommerceServiceTriggerCueResponseDescriptor instead')
const LiveCommerceServiceTriggerCueResponse$json = {
  '1': 'LiveCommerceServiceTriggerCueResponse',
  '2': [
    {
      '1': 'cue_card',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.commerce.v1.CueCard',
      '10': 'cueCard'
    },
    {'1': 'is_duplicate', '3': 2, '4': 1, '5': 8, '10': 'isDuplicate'},
  ],
};

/// Descriptor for `LiveCommerceServiceTriggerCueResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List liveCommerceServiceTriggerCueResponseDescriptor =
    $convert.base64Decode(
        'CiVMaXZlQ29tbWVyY2VTZXJ2aWNlVHJpZ2dlckN1ZVJlc3BvbnNlEjsKCGN1ZV9jYXJkGAEgAS'
        'gLMiAuY3JlYXRpdmFudGEuY29tbWVyY2UudjEuQ3VlQ2FyZFIHY3VlQ2FyZBIhCgxpc19kdXBs'
        'aWNhdGUYAiABKAhSC2lzRHVwbGljYXRl');

@$core.Deprecated(
    'Use liveCommerceServiceHighlightProductRequestDescriptor instead')
const LiveCommerceServiceHighlightProductRequest$json = {
  '1': 'LiveCommerceServiceHighlightProductRequest',
  '2': [
    {
      '1': 'context',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.CommandContext',
      '10': 'context'
    },
    {'1': 'session_id', '3': 2, '4': 1, '5': 9, '10': 'sessionId'},
    {'1': 'product_id', '3': 3, '4': 1, '5': 9, '10': 'productId'},
    {'1': 'offer_id', '3': 4, '4': 1, '5': 9, '10': 'offerId'},
    {'1': 'is_pinned', '3': 5, '4': 1, '5': 8, '10': 'isPinned'},
    {
      '1': 'active_time_offset_seconds',
      '3': 6,
      '4': 1,
      '5': 5,
      '10': 'activeTimeOffsetSeconds'
    },
  ],
};

/// Descriptor for `LiveCommerceServiceHighlightProductRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List
    liveCommerceServiceHighlightProductRequestDescriptor =
    $convert.base64Decode(
        'CipMaXZlQ29tbWVyY2VTZXJ2aWNlSGlnaGxpZ2h0UHJvZHVjdFJlcXVlc3QSPwoHY29udGV4dB'
        'gBIAEoCzIlLmNyZWF0aXZhbnRhLmNvbW1vbi52MS5Db21tYW5kQ29udGV4dFIHY29udGV4dBId'
        'CgpzZXNzaW9uX2lkGAIgASgJUglzZXNzaW9uSWQSHQoKcHJvZHVjdF9pZBgDIAEoCVIJcHJvZH'
        'VjdElkEhkKCG9mZmVyX2lkGAQgASgJUgdvZmZlcklkEhsKCWlzX3Bpbm5lZBgFIAEoCFIIaXNQ'
        'aW5uZWQSOwoaYWN0aXZlX3RpbWVfb2Zmc2V0X3NlY29uZHMYBiABKAVSF2FjdGl2ZVRpbWVPZm'
        'ZzZXRTZWNvbmRz');

@$core.Deprecated(
    'Use liveCommerceServiceHighlightProductResponseDescriptor instead')
const LiveCommerceServiceHighlightProductResponse$json = {
  '1': 'LiveCommerceServiceHighlightProductResponse',
  '2': [
    {'1': 'session_id', '3': 1, '4': 1, '5': 9, '10': 'sessionId'},
    {'1': 'pinned_product_id', '3': 2, '4': 1, '5': 9, '10': 'pinnedProductId'},
    {'1': 'pinned_offer_id', '3': 3, '4': 1, '5': 9, '10': 'pinnedOfferId'},
    {'1': 'is_pinned', '3': 4, '4': 1, '5': 8, '10': 'isPinned'},
    {'1': 'is_duplicate', '3': 5, '4': 1, '5': 8, '10': 'isDuplicate'},
  ],
};

/// Descriptor for `LiveCommerceServiceHighlightProductResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List
    liveCommerceServiceHighlightProductResponseDescriptor =
    $convert.base64Decode(
        'CitMaXZlQ29tbWVyY2VTZXJ2aWNlSGlnaGxpZ2h0UHJvZHVjdFJlc3BvbnNlEh0KCnNlc3Npb2'
        '5faWQYASABKAlSCXNlc3Npb25JZBIqChFwaW5uZWRfcHJvZHVjdF9pZBgCIAEoCVIPcGlubmVk'
        'UHJvZHVjdElkEiYKD3Bpbm5lZF9vZmZlcl9pZBgDIAEoCVINcGlubmVkT2ZmZXJJZBIbCglpc1'
        '9waW5uZWQYBCABKAhSCGlzUGlubmVkEiEKDGlzX2R1cGxpY2F0ZRgFIAEoCFILaXNEdXBsaWNh'
        'dGU=');

@$core
    .Deprecated('Use liveCommerceServiceGetAnalyticsRequestDescriptor instead')
const LiveCommerceServiceGetAnalyticsRequest$json = {
  '1': 'LiveCommerceServiceGetAnalyticsRequest',
  '2': [
    {'1': 'session_id', '3': 1, '4': 1, '5': 9, '10': 'sessionId'},
    {'1': 'workspace_id', '3': 2, '4': 1, '5': 9, '10': 'workspaceId'},
  ],
};

/// Descriptor for `LiveCommerceServiceGetAnalyticsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List liveCommerceServiceGetAnalyticsRequestDescriptor =
    $convert.base64Decode(
        'CiZMaXZlQ29tbWVyY2VTZXJ2aWNlR2V0QW5hbHl0aWNzUmVxdWVzdBIdCgpzZXNzaW9uX2lkGA'
        'EgASgJUglzZXNzaW9uSWQSIQoMd29ya3NwYWNlX2lkGAIgASgJUgt3b3Jrc3BhY2VJZA==');

@$core
    .Deprecated('Use liveCommerceServiceGetAnalyticsResponseDescriptor instead')
const LiveCommerceServiceGetAnalyticsResponse$json = {
  '1': 'LiveCommerceServiceGetAnalyticsResponse',
  '2': [
    {'1': 'session_id', '3': 1, '4': 1, '5': 9, '10': 'sessionId'},
    {
      '1': 'metrics',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.creativanta.commerce.v1.LiveMetricsSnapshot',
      '10': 'metrics'
    },
    {'1': 'orders_count', '3': 3, '4': 1, '5': 3, '10': 'ordersCount'},
    {
      '1': 'total_revenue',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.Money',
      '10': 'totalRevenue'
    },
    {
      '1': 'traceable_orders',
      '3': 5,
      '4': 3,
      '5': 11,
      '6': '.creativanta.commerce.v1.TraceableOrderLink',
      '10': 'traceableOrders'
    },
  ],
};

/// Descriptor for `LiveCommerceServiceGetAnalyticsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List liveCommerceServiceGetAnalyticsResponseDescriptor = $convert.base64Decode(
    'CidMaXZlQ29tbWVyY2VTZXJ2aWNlR2V0QW5hbHl0aWNzUmVzcG9uc2USHQoKc2Vzc2lvbl9pZB'
    'gBIAEoCVIJc2Vzc2lvbklkEkYKB21ldHJpY3MYAiABKAsyLC5jcmVhdGl2YW50YS5jb21tZXJj'
    'ZS52MS5MaXZlTWV0cmljc1NuYXBzaG90UgdtZXRyaWNzEiEKDG9yZGVyc19jb3VudBgDIAEoA1'
    'ILb3JkZXJzQ291bnQSQQoNdG90YWxfcmV2ZW51ZRgEIAEoCzIcLmNyZWF0aXZhbnRhLmNvbW1v'
    'bi52MS5Nb25leVIMdG90YWxSZXZlbnVlElYKEHRyYWNlYWJsZV9vcmRlcnMYBSADKAsyKy5jcm'
    'VhdGl2YW50YS5jb21tZXJjZS52MS5UcmFjZWFibGVPcmRlckxpbmtSD3RyYWNlYWJsZU9yZGVy'
    'cw==');

@$core.Deprecated(
    'Use liveCommerceServiceUpdateRunOfShowRequestDescriptor instead')
const LiveCommerceServiceUpdateRunOfShowRequest$json = {
  '1': 'LiveCommerceServiceUpdateRunOfShowRequest',
  '2': [
    {
      '1': 'context',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.CommandContext',
      '10': 'context'
    },
    {'1': 'session_id', '3': 2, '4': 1, '5': 9, '10': 'sessionId'},
    {
      '1': 'items',
      '3': 3,
      '4': 3,
      '5': 11,
      '6': '.creativanta.commerce.v1.RunOfShowItem',
      '10': 'items'
    },
  ],
};

/// Descriptor for `LiveCommerceServiceUpdateRunOfShowRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List
    liveCommerceServiceUpdateRunOfShowRequestDescriptor = $convert.base64Decode(
        'CilMaXZlQ29tbWVyY2VTZXJ2aWNlVXBkYXRlUnVuT2ZTaG93UmVxdWVzdBI/Cgdjb250ZXh0GA'
        'EgASgLMiUuY3JlYXRpdmFudGEuY29tbW9uLnYxLkNvbW1hbmRDb250ZXh0Ugdjb250ZXh0Eh0K'
        'CnNlc3Npb25faWQYAiABKAlSCXNlc3Npb25JZBI8CgVpdGVtcxgDIAMoCzImLmNyZWF0aXZhbn'
        'RhLmNvbW1lcmNlLnYxLlJ1bk9mU2hvd0l0ZW1SBWl0ZW1z');

@$core.Deprecated(
    'Use liveCommerceServiceUpdateRunOfShowResponseDescriptor instead')
const LiveCommerceServiceUpdateRunOfShowResponse$json = {
  '1': 'LiveCommerceServiceUpdateRunOfShowResponse',
  '2': [
    {
      '1': 'session',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.commerce.v1.LiveSession',
      '10': 'session'
    },
    {'1': 'is_duplicate', '3': 2, '4': 1, '5': 8, '10': 'isDuplicate'},
  ],
};

/// Descriptor for `LiveCommerceServiceUpdateRunOfShowResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List
    liveCommerceServiceUpdateRunOfShowResponseDescriptor =
    $convert.base64Decode(
        'CipMaXZlQ29tbWVyY2VTZXJ2aWNlVXBkYXRlUnVuT2ZTaG93UmVzcG9uc2USPgoHc2Vzc2lvbh'
        'gBIAEoCzIkLmNyZWF0aXZhbnRhLmNvbW1lcmNlLnYxLkxpdmVTZXNzaW9uUgdzZXNzaW9uEiEK'
        'DGlzX2R1cGxpY2F0ZRgCIAEoCFILaXNEdXBsaWNhdGU=');

@$core.Deprecated(
    'Use liveCommerceServiceCreateHighlightRequestDescriptor instead')
const LiveCommerceServiceCreateHighlightRequest$json = {
  '1': 'LiveCommerceServiceCreateHighlightRequest',
  '2': [
    {
      '1': 'context',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.CommandContext',
      '10': 'context'
    },
    {'1': 'session_id', '3': 2, '4': 1, '5': 9, '10': 'sessionId'},
    {'1': 'title', '3': 3, '4': 1, '5': 9, '10': 'title'},
    {
      '1': 'start_offset_seconds',
      '3': 4,
      '4': 1,
      '5': 5,
      '10': 'startOffsetSeconds'
    },
    {
      '1': 'end_offset_seconds',
      '3': 5,
      '4': 1,
      '5': 5,
      '10': 'endOffsetSeconds'
    },
    {'1': 'highlight_type', '3': 6, '4': 1, '5': 9, '10': 'highlightType'},
    {'1': 'notes', '3': 7, '4': 1, '5': 9, '10': 'notes'},
    {'1': 'pinned_offer_id', '3': 8, '4': 1, '5': 9, '10': 'pinnedOfferId'},
    {'1': 'pinned_product_id', '3': 9, '4': 1, '5': 9, '10': 'pinnedProductId'},
    {'1': 'auto_detected', '3': 10, '4': 1, '5': 8, '10': 'autoDetected'},
    {'1': 'engagement_score', '3': 11, '4': 1, '5': 1, '10': 'engagementScore'},
  ],
};

/// Descriptor for `LiveCommerceServiceCreateHighlightRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List liveCommerceServiceCreateHighlightRequestDescriptor = $convert.base64Decode(
    'CilMaXZlQ29tbWVyY2VTZXJ2aWNlQ3JlYXRlSGlnaGxpZ2h0UmVxdWVzdBI/Cgdjb250ZXh0GA'
    'EgASgLMiUuY3JlYXRpdmFudGEuY29tbW9uLnYxLkNvbW1hbmRDb250ZXh0Ugdjb250ZXh0Eh0K'
    'CnNlc3Npb25faWQYAiABKAlSCXNlc3Npb25JZBIUCgV0aXRsZRgDIAEoCVIFdGl0bGUSMAoUc3'
    'RhcnRfb2Zmc2V0X3NlY29uZHMYBCABKAVSEnN0YXJ0T2Zmc2V0U2Vjb25kcxIsChJlbmRfb2Zm'
    'c2V0X3NlY29uZHMYBSABKAVSEGVuZE9mZnNldFNlY29uZHMSJQoOaGlnaGxpZ2h0X3R5cGUYBi'
    'ABKAlSDWhpZ2hsaWdodFR5cGUSFAoFbm90ZXMYByABKAlSBW5vdGVzEiYKD3Bpbm5lZF9vZmZl'
    'cl9pZBgIIAEoCVINcGlubmVkT2ZmZXJJZBIqChFwaW5uZWRfcHJvZHVjdF9pZBgJIAEoCVIPcG'
    'lubmVkUHJvZHVjdElkEiMKDWF1dG9fZGV0ZWN0ZWQYCiABKAhSDGF1dG9EZXRlY3RlZBIpChBl'
    'bmdhZ2VtZW50X3Njb3JlGAsgASgBUg9lbmdhZ2VtZW50U2NvcmU=');

@$core.Deprecated(
    'Use liveCommerceServiceCreateHighlightResponseDescriptor instead')
const LiveCommerceServiceCreateHighlightResponse$json = {
  '1': 'LiveCommerceServiceCreateHighlightResponse',
  '2': [
    {
      '1': 'highlight',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.commerce.v1.Highlight',
      '10': 'highlight'
    },
    {'1': 'is_duplicate', '3': 2, '4': 1, '5': 8, '10': 'isDuplicate'},
  ],
};

/// Descriptor for `LiveCommerceServiceCreateHighlightResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List
    liveCommerceServiceCreateHighlightResponseDescriptor =
    $convert.base64Decode(
        'CipMaXZlQ29tbWVyY2VTZXJ2aWNlQ3JlYXRlSGlnaGxpZ2h0UmVzcG9uc2USQAoJaGlnaGxpZ2'
        'h0GAEgASgLMiIuY3JlYXRpdmFudGEuY29tbWVyY2UudjEuSGlnaGxpZ2h0UgloaWdobGlnaHQS'
        'IQoMaXNfZHVwbGljYXRlGAIgASgIUgtpc0R1cGxpY2F0ZQ==');

@$core.Deprecated(
    'Use liveCommerceServiceExtractHighlightsRequestDescriptor instead')
const LiveCommerceServiceExtractHighlightsRequest$json = {
  '1': 'LiveCommerceServiceExtractHighlightsRequest',
  '2': [
    {
      '1': 'context',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.CommandContext',
      '10': 'context'
    },
    {'1': 'session_id', '3': 2, '4': 1, '5': 9, '10': 'sessionId'},
    {'1': 'source_asset_id', '3': 3, '4': 1, '5': 9, '10': 'sourceAssetId'},
    {'1': 'highlight_ids', '3': 4, '4': 3, '5': 9, '10': 'highlightIds'},
  ],
};

/// Descriptor for `LiveCommerceServiceExtractHighlightsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List
    liveCommerceServiceExtractHighlightsRequestDescriptor =
    $convert.base64Decode(
        'CitMaXZlQ29tbWVyY2VTZXJ2aWNlRXh0cmFjdEhpZ2hsaWdodHNSZXF1ZXN0Ej8KB2NvbnRleH'
        'QYASABKAsyJS5jcmVhdGl2YW50YS5jb21tb24udjEuQ29tbWFuZENvbnRleHRSB2NvbnRleHQS'
        'HQoKc2Vzc2lvbl9pZBgCIAEoCVIJc2Vzc2lvbklkEiYKD3NvdXJjZV9hc3NldF9pZBgDIAEoCV'
        'INc291cmNlQXNzZXRJZBIjCg1oaWdobGlnaHRfaWRzGAQgAygJUgxoaWdobGlnaHRJZHM=');

@$core.Deprecated(
    'Use liveCommerceServiceExtractHighlightsResponseDescriptor instead')
const LiveCommerceServiceExtractHighlightsResponse$json = {
  '1': 'LiveCommerceServiceExtractHighlightsResponse',
  '2': [
    {'1': 'session_id', '3': 1, '4': 1, '5': 9, '10': 'sessionId'},
    {'1': 'extracted_count', '3': 2, '4': 1, '5': 5, '10': 'extractedCount'},
    {
      '1': 'updated_highlights',
      '3': 3,
      '4': 3,
      '5': 11,
      '6': '.creativanta.commerce.v1.Highlight',
      '10': 'updatedHighlights'
    },
    {
      '1': 'registered_derivative_asset_ids',
      '3': 4,
      '4': 3,
      '5': 9,
      '10': 'registeredDerivativeAssetIds'
    },
    {'1': 'is_duplicate', '3': 5, '4': 1, '5': 8, '10': 'isDuplicate'},
  ],
};

/// Descriptor for `LiveCommerceServiceExtractHighlightsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List
    liveCommerceServiceExtractHighlightsResponseDescriptor =
    $convert.base64Decode(
        'CixMaXZlQ29tbWVyY2VTZXJ2aWNlRXh0cmFjdEhpZ2hsaWdodHNSZXNwb25zZRIdCgpzZXNzaW'
        '9uX2lkGAEgASgJUglzZXNzaW9uSWQSJwoPZXh0cmFjdGVkX2NvdW50GAIgASgFUg5leHRyYWN0'
        'ZWRDb3VudBJRChJ1cGRhdGVkX2hpZ2hsaWdodHMYAyADKAsyIi5jcmVhdGl2YW50YS5jb21tZX'
        'JjZS52MS5IaWdobGlnaHRSEXVwZGF0ZWRIaWdobGlnaHRzEkUKH3JlZ2lzdGVyZWRfZGVyaXZh'
        'dGl2ZV9hc3NldF9pZHMYBCADKAlSHHJlZ2lzdGVyZWREZXJpdmF0aXZlQXNzZXRJZHMSIQoMaX'
        'NfZHVwbGljYXRlGAUgASgIUgtpc0R1cGxpY2F0ZQ==');

@$core.Deprecated(
    'Use liveCommerceServiceGetProofSummaryRequestDescriptor instead')
const LiveCommerceServiceGetProofSummaryRequest$json = {
  '1': 'LiveCommerceServiceGetProofSummaryRequest',
  '2': [
    {'1': 'session_id', '3': 1, '4': 1, '5': 9, '10': 'sessionId'},
    {'1': 'workspace_id', '3': 2, '4': 1, '5': 9, '10': 'workspaceId'},
  ],
};

/// Descriptor for `LiveCommerceServiceGetProofSummaryRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List
    liveCommerceServiceGetProofSummaryRequestDescriptor = $convert.base64Decode(
        'CilMaXZlQ29tbWVyY2VTZXJ2aWNlR2V0UHJvb2ZTdW1tYXJ5UmVxdWVzdBIdCgpzZXNzaW9uX2'
        'lkGAEgASgJUglzZXNzaW9uSWQSIQoMd29ya3NwYWNlX2lkGAIgASgJUgt3b3Jrc3BhY2VJZA==');

@$core.Deprecated(
    'Use liveCommerceServiceGetProofSummaryResponseDescriptor instead')
const LiveCommerceServiceGetProofSummaryResponse$json = {
  '1': 'LiveCommerceServiceGetProofSummaryResponse',
  '2': [
    {
      '1': 'summary',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.commerce.v1.PostLiveProofSummary',
      '10': 'summary'
    },
  ],
};

/// Descriptor for `LiveCommerceServiceGetProofSummaryResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List
    liveCommerceServiceGetProofSummaryResponseDescriptor =
    $convert.base64Decode(
        'CipMaXZlQ29tbWVyY2VTZXJ2aWNlR2V0UHJvb2ZTdW1tYXJ5UmVzcG9uc2USRwoHc3VtbWFyeR'
        'gBIAEoCzItLmNyZWF0aXZhbnRhLmNvbW1lcmNlLnYxLlBvc3RMaXZlUHJvb2ZTdW1tYXJ5Ugdz'
        'dW1tYXJ5');

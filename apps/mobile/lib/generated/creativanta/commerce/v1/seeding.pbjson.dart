// This is a generated file - do not edit.
//
// Generated from creativanta/commerce/v1/seeding.proto.

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

@$core.Deprecated('Use sampleRequestStatusDescriptor instead')
const SampleRequestStatus$json = {
  '1': 'SampleRequestStatus',
  '2': [
    {'1': 'SAMPLE_REQUEST_STATUS_UNSPECIFIED', '2': 0},
    {'1': 'SAMPLE_REQUEST_STATUS_REQUESTED', '2': 1},
    {'1': 'SAMPLE_REQUEST_STATUS_APPROVED', '2': 2},
    {'1': 'SAMPLE_REQUEST_STATUS_DECLINED', '2': 3},
    {'1': 'SAMPLE_REQUEST_STATUS_FULFILLED', '2': 4},
    {'1': 'SAMPLE_REQUEST_STATUS_CANCELLED', '2': 5},
  ],
};

/// Descriptor for `SampleRequestStatus`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List sampleRequestStatusDescriptor = $convert.base64Decode(
    'ChNTYW1wbGVSZXF1ZXN0U3RhdHVzEiUKIVNBTVBMRV9SRVFVRVNUX1NUQVRVU19VTlNQRUNJRk'
    'lFRBAAEiMKH1NBTVBMRV9SRVFVRVNUX1NUQVRVU19SRVFVRVNURUQQARIiCh5TQU1QTEVfUkVR'
    'VUVTVF9TVEFUVVNfQVBQUk9WRUQQAhIiCh5TQU1QTEVfUkVRVUVTVF9TVEFUVVNfREVDTElORU'
    'QQAxIjCh9TQU1QTEVfUkVRVUVTVF9TVEFUVVNfRlVMRklMTEVEEAQSIwofU0FNUExFX1JFUVVF'
    'U1RfU1RBVFVTX0NBTkNFTExFRBAF');

@$core.Deprecated('Use sampleShipmentStatusDescriptor instead')
const SampleShipmentStatus$json = {
  '1': 'SampleShipmentStatus',
  '2': [
    {'1': 'SAMPLE_SHIPMENT_STATUS_UNSPECIFIED', '2': 0},
    {'1': 'SAMPLE_SHIPMENT_STATUS_PREPARING', '2': 1},
    {'1': 'SAMPLE_SHIPMENT_STATUS_SHIPPED', '2': 2},
    {'1': 'SAMPLE_SHIPMENT_STATUS_DELIVERED', '2': 3},
    {'1': 'SAMPLE_SHIPMENT_STATUS_LOST', '2': 4},
    {'1': 'SAMPLE_SHIPMENT_STATUS_RETURNED', '2': 5},
    {'1': 'SAMPLE_SHIPMENT_STATUS_CLOSED', '2': 6},
  ],
};

/// Descriptor for `SampleShipmentStatus`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List sampleShipmentStatusDescriptor = $convert.base64Decode(
    'ChRTYW1wbGVTaGlwbWVudFN0YXR1cxImCiJTQU1QTEVfU0hJUE1FTlRfU1RBVFVTX1VOU1BFQ0'
    'lGSUVEEAASJAogU0FNUExFX1NISVBNRU5UX1NUQVRVU19QUkVQQVJJTkcQARIiCh5TQU1QTEVf'
    'U0hJUE1FTlRfU1RBVFVTX1NISVBQRUQQAhIkCiBTQU1QTEVfU0hJUE1FTlRfU1RBVFVTX0RFTE'
    'lWRVJFRBADEh8KG1NBTVBMRV9TSElQTUVOVF9TVEFUVVNfTE9TVBAEEiMKH1NBTVBMRV9TSElQ'
    'TUVOVF9TVEFUVVNfUkVUVVJORUQQBRIhCh1TQU1QTEVfU0hJUE1FTlRfU1RBVFVTX0NMT1NFRB'
    'AG');

@$core.Deprecated('Use sampleOutcomeStatusDescriptor instead')
const SampleOutcomeStatus$json = {
  '1': 'SampleOutcomeStatus',
  '2': [
    {'1': 'SAMPLE_OUTCOME_STATUS_UNSPECIFIED', '2': 0},
    {'1': 'SAMPLE_OUTCOME_STATUS_PENDING', '2': 1},
    {'1': 'SAMPLE_OUTCOME_STATUS_LOGGED', '2': 2},
  ],
};

/// Descriptor for `SampleOutcomeStatus`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List sampleOutcomeStatusDescriptor = $convert.base64Decode(
    'ChNTYW1wbGVPdXRjb21lU3RhdHVzEiUKIVNBTVBMRV9PVVRDT01FX1NUQVRVU19VTlNQRUNJRk'
    'lFRBAAEiEKHVNBTVBMRV9PVVRDT01FX1NUQVRVU19QRU5ESU5HEAESIAocU0FNUExFX09VVENP'
    'TUVfU1RBVFVTX0xPR0dFRBAC');

@$core.Deprecated('Use followUpStatusDescriptor instead')
const FollowUpStatus$json = {
  '1': 'FollowUpStatus',
  '2': [
    {'1': 'FOLLOW_UP_STATUS_UNSPECIFIED', '2': 0},
    {'1': 'FOLLOW_UP_STATUS_PENDING_FOLLOWUP', '2': 1},
    {'1': 'FOLLOW_UP_STATUS_CONTACTED', '2': 2},
    {'1': 'FOLLOW_UP_STATUS_RESPONDED', '2': 3},
    {'1': 'FOLLOW_UP_STATUS_NO_RESPONSE', '2': 4},
  ],
};

/// Descriptor for `FollowUpStatus`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List followUpStatusDescriptor = $convert.base64Decode(
    'Cg5Gb2xsb3dVcFN0YXR1cxIgChxGT0xMT1dfVVBfU1RBVFVTX1VOU1BFQ0lGSUVEEAASJQohRk'
    '9MTE9XX1VQX1NUQVRVU19QRU5ESU5HX0ZPTExPV1VQEAESHgoaRk9MTE9XX1VQX1NUQVRVU19D'
    'T05UQUNURUQQAhIeChpGT0xMT1dfVVBfU1RBVFVTX1JFU1BPTkRFRBADEiAKHEZPTExPV19VUF'
    '9TVEFUVVNfTk9fUkVTUE9OU0UQBA==');

@$core.Deprecated('Use seedingSourceClassDescriptor instead')
const SeedingSourceClass$json = {
  '1': 'SeedingSourceClass',
  '2': [
    {'1': 'SEEDING_SOURCE_CLASS_UNSPECIFIED', '2': 0},
    {'1': 'SEEDING_SOURCE_CLASS_OFFICIAL', '2': 1},
    {'1': 'SEEDING_SOURCE_CLASS_IMPORTED', '2': 2},
    {'1': 'SEEDING_SOURCE_CLASS_INFERRED', '2': 3},
    {'1': 'SEEDING_SOURCE_CLASS_ESTIMATED', '2': 4},
    {'1': 'SEEDING_SOURCE_CLASS_UNRECONCILED', '2': 5},
  ],
};

/// Descriptor for `SeedingSourceClass`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List seedingSourceClassDescriptor = $convert.base64Decode(
    'ChJTZWVkaW5nU291cmNlQ2xhc3MSJAogU0VFRElOR19TT1VSQ0VfQ0xBU1NfVU5TUEVDSUZJRU'
    'QQABIhCh1TRUVESU5HX1NPVVJDRV9DTEFTU19PRkZJQ0lBTBABEiEKHVNFRURJTkdfU09VUkNF'
    'X0NMQVNTX0lNUE9SVEVEEAISIQodU0VFRElOR19TT1VSQ0VfQ0xBU1NfSU5GRVJSRUQQAxIiCh'
    '5TRUVESU5HX1NPVVJDRV9DTEFTU19FU1RJTUFURUQQBBIlCiFTRUVESU5HX1NPVVJDRV9DTEFT'
    'U19VTlJFQ09OQ0lMRUQQBQ==');

@$core.Deprecated('Use seedingConfidenceLevelDescriptor instead')
const SeedingConfidenceLevel$json = {
  '1': 'SeedingConfidenceLevel',
  '2': [
    {'1': 'SEEDING_CONFIDENCE_LEVEL_UNSPECIFIED', '2': 0},
    {'1': 'SEEDING_CONFIDENCE_LEVEL_HIGH', '2': 1},
    {'1': 'SEEDING_CONFIDENCE_LEVEL_MEDIUM', '2': 2},
    {'1': 'SEEDING_CONFIDENCE_LEVEL_LOW', '2': 3},
  ],
};

/// Descriptor for `SeedingConfidenceLevel`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List seedingConfidenceLevelDescriptor = $convert.base64Decode(
    'ChZTZWVkaW5nQ29uZmlkZW5jZUxldmVsEigKJFNFRURJTkdfQ09ORklERU5DRV9MRVZFTF9VTl'
    'NQRUNJRklFRBAAEiEKHVNFRURJTkdfQ09ORklERU5DRV9MRVZFTF9ISUdIEAESIwofU0VFRElO'
    'R19DT05GSURFTkNFX0xFVkVMX01FRElVTRACEiAKHFNFRURJTkdfQ09ORklERU5DRV9MRVZFTF'
    '9MT1cQAw==');

@$core.Deprecated('Use shippingAddressDescriptor instead')
const ShippingAddress$json = {
  '1': 'ShippingAddress',
  '2': [
    {'1': 'name', '3': 1, '4': 1, '5': 9, '10': 'name'},
    {'1': 'phone', '3': 2, '4': 1, '5': 9, '10': 'phone'},
    {'1': 'address_line_1', '3': 3, '4': 1, '5': 9, '10': 'addressLine1'},
    {'1': 'address_line_2', '3': 4, '4': 1, '5': 9, '10': 'addressLine2'},
    {'1': 'city', '3': 5, '4': 1, '5': 9, '10': 'city'},
    {'1': 'postal_code', '3': 6, '4': 1, '5': 9, '10': 'postalCode'},
    {'1': 'country', '3': 7, '4': 1, '5': 9, '10': 'country'},
  ],
};

/// Descriptor for `ShippingAddress`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List shippingAddressDescriptor = $convert.base64Decode(
    'Cg9TaGlwcGluZ0FkZHJlc3MSEgoEbmFtZRgBIAEoCVIEbmFtZRIUCgVwaG9uZRgCIAEoCVIFcG'
    'hvbmUSJAoOYWRkcmVzc19saW5lXzEYAyABKAlSDGFkZHJlc3NMaW5lMRIkCg5hZGRyZXNzX2xp'
    'bmVfMhgEIAEoCVIMYWRkcmVzc0xpbmUyEhIKBGNpdHkYBSABKAlSBGNpdHkSHwoLcG9zdGFsX2'
    'NvZGUYBiABKAlSCnBvc3RhbENvZGUSGAoHY291bnRyeRgHIAEoCVIHY291bnRyeQ==');

@$core.Deprecated('Use sampleOutcomeDescriptor instead')
const SampleOutcome$json = {
  '1': 'SampleOutcome',
  '2': [
    {'1': 'content_url', '3': 1, '4': 1, '5': 9, '10': 'contentUrl'},
    {'1': 'content_type', '3': 2, '4': 1, '5': 9, '10': 'contentType'},
    {'1': 'publish_item_id', '3': 3, '4': 1, '5': 9, '10': 'publishItemId'},
    {'1': 'impressions', '3': 4, '4': 1, '5': 3, '10': 'impressions'},
    {'1': 'views', '3': 5, '4': 1, '5': 3, '10': 'views'},
    {'1': 'engagements', '3': 6, '4': 1, '5': 3, '10': 'engagements'},
    {
      '1': 'conversions_count',
      '3': 7,
      '4': 1,
      '5': 3,
      '10': 'conversionsCount'
    },
    {
      '1': 'attributable_revenue',
      '3': 8,
      '4': 1,
      '5': 9,
      '10': 'attributableRevenue'
    },
    {'1': 'currency', '3': 9, '4': 1, '5': 9, '10': 'currency'},
    {
      '1': 'source_class',
      '3': 10,
      '4': 1,
      '5': 14,
      '6': '.creativanta.commerce.v1.SeedingSourceClass',
      '10': 'sourceClass'
    },
    {
      '1': 'confidence_level',
      '3': 11,
      '4': 1,
      '5': 14,
      '6': '.creativanta.commerce.v1.SeedingConfidenceLevel',
      '10': 'confidenceLevel'
    },
    {
      '1': 'confidence_reason',
      '3': 12,
      '4': 1,
      '5': 9,
      '10': 'confidenceReason'
    },
    {'1': 'notes', '3': 13, '4': 1, '5': 9, '10': 'notes'},
    {
      '1': 'logged_at',
      '3': 14,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'loggedAt'
    },
  ],
};

/// Descriptor for `SampleOutcome`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List sampleOutcomeDescriptor = $convert.base64Decode(
    'Cg1TYW1wbGVPdXRjb21lEh8KC2NvbnRlbnRfdXJsGAEgASgJUgpjb250ZW50VXJsEiEKDGNvbn'
    'RlbnRfdHlwZRgCIAEoCVILY29udGVudFR5cGUSJgoPcHVibGlzaF9pdGVtX2lkGAMgASgJUg1w'
    'dWJsaXNoSXRlbUlkEiAKC2ltcHJlc3Npb25zGAQgASgDUgtpbXByZXNzaW9ucxIUCgV2aWV3cx'
    'gFIAEoA1IFdmlld3MSIAoLZW5nYWdlbWVudHMYBiABKANSC2VuZ2FnZW1lbnRzEisKEWNvbnZl'
    'cnNpb25zX2NvdW50GAcgASgDUhBjb252ZXJzaW9uc0NvdW50EjEKFGF0dHJpYnV0YWJsZV9yZX'
    'ZlbnVlGAggASgJUhNhdHRyaWJ1dGFibGVSZXZlbnVlEhoKCGN1cnJlbmN5GAkgASgJUghjdXJy'
    'ZW5jeRJOCgxzb3VyY2VfY2xhc3MYCiABKA4yKy5jcmVhdGl2YW50YS5jb21tZXJjZS52MS5TZW'
    'VkaW5nU291cmNlQ2xhc3NSC3NvdXJjZUNsYXNzEloKEGNvbmZpZGVuY2VfbGV2ZWwYCyABKA4y'
    'Ly5jcmVhdGl2YW50YS5jb21tZXJjZS52MS5TZWVkaW5nQ29uZmlkZW5jZUxldmVsUg9jb25maW'
    'RlbmNlTGV2ZWwSKwoRY29uZmlkZW5jZV9yZWFzb24YDCABKAlSEGNvbmZpZGVuY2VSZWFzb24S'
    'FAoFbm90ZXMYDSABKAlSBW5vdGVzEjcKCWxvZ2dlZF9hdBgOIAEoCzIaLmdvb2dsZS5wcm90b2'
    'J1Zi5UaW1lc3RhbXBSCGxvZ2dlZEF0');

@$core.Deprecated('Use sampleShipmentDescriptor instead')
const SampleShipment$json = {
  '1': 'SampleShipment',
  '2': [
    {'1': 'shipment_id', '3': 1, '4': 1, '5': 9, '10': 'shipmentId'},
    {'1': 'request_id', '3': 2, '4': 1, '5': 9, '10': 'requestId'},
    {'1': 'workspace_id', '3': 3, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'tracking_number', '3': 4, '4': 1, '5': 9, '10': 'trackingNumber'},
    {'1': 'carrier', '3': 5, '4': 1, '5': 9, '10': 'carrier'},
    {'1': 'shipping_cost', '3': 6, '4': 1, '5': 9, '10': 'shippingCost'},
    {
      '1': 'shipped_at',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'shippedAt'
    },
    {
      '1': 'delivered_at',
      '3': 8,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'deliveredAt'
    },
    {
      '1': 'status',
      '3': 9,
      '4': 1,
      '5': 14,
      '6': '.creativanta.commerce.v1.SampleShipmentStatus',
      '10': 'status'
    },
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

/// Descriptor for `SampleShipment`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List sampleShipmentDescriptor = $convert.base64Decode(
    'Cg5TYW1wbGVTaGlwbWVudBIfCgtzaGlwbWVudF9pZBgBIAEoCVIKc2hpcG1lbnRJZBIdCgpyZX'
    'F1ZXN0X2lkGAIgASgJUglyZXF1ZXN0SWQSIQoMd29ya3NwYWNlX2lkGAMgASgJUgt3b3Jrc3Bh'
    'Y2VJZBInCg90cmFja2luZ19udW1iZXIYBCABKAlSDnRyYWNraW5nTnVtYmVyEhgKB2NhcnJpZX'
    'IYBSABKAlSB2NhcnJpZXISIwoNc2hpcHBpbmdfY29zdBgGIAEoCVIMc2hpcHBpbmdDb3N0EjkK'
    'CnNoaXBwZWRfYXQYByABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUglzaGlwcGVkQX'
    'QSPQoMZGVsaXZlcmVkX2F0GAggASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFILZGVs'
    'aXZlcmVkQXQSRQoGc3RhdHVzGAkgASgOMi0uY3JlYXRpdmFudGEuY29tbWVyY2UudjEuU2FtcG'
    'xlU2hpcG1lbnRTdGF0dXNSBnN0YXR1cxI5CgpjcmVhdGVkX2F0GAogASgLMhouZ29vZ2xlLnBy'
    'b3RvYnVmLlRpbWVzdGFtcFIJY3JlYXRlZEF0EjkKCnVwZGF0ZWRfYXQYCyABKAsyGi5nb29nbG'
    'UucHJvdG9idWYuVGltZXN0YW1wUgl1cGRhdGVkQXQ=');

@$core.Deprecated('Use sampleRequestDescriptor instead')
const SampleRequest$json = {
  '1': 'SampleRequest',
  '2': [
    {'1': 'request_id', '3': 1, '4': 1, '5': 9, '10': 'requestId'},
    {'1': 'workspace_id', '3': 2, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'campaign_id', '3': 3, '4': 1, '5': 9, '10': 'campaignId'},
    {'1': 'product_id', '3': 4, '4': 1, '5': 9, '10': 'productId'},
    {'1': 'creator_entity_id', '3': 5, '4': 1, '5': 9, '10': 'creatorEntityId'},
    {
      '1': 'status',
      '3': 6,
      '4': 1,
      '5': 14,
      '6': '.creativanta.commerce.v1.SampleRequestStatus',
      '10': 'status'
    },
    {'1': 'quantity', '3': 7, '4': 1, '5': 5, '10': 'quantity'},
    {
      '1': 'outcome_status',
      '3': 8,
      '4': 1,
      '5': 14,
      '6': '.creativanta.commerce.v1.SampleOutcomeStatus',
      '10': 'outcomeStatus'
    },
    {
      '1': 'outcome',
      '3': 9,
      '4': 1,
      '5': 11,
      '6': '.creativanta.commerce.v1.SampleOutcome',
      '10': 'outcome'
    },
    {
      '1': 'follow_up_status',
      '3': 10,
      '4': 1,
      '5': 14,
      '6': '.creativanta.commerce.v1.FollowUpStatus',
      '10': 'followUpStatus'
    },
    {
      '1': 'shipping_address',
      '3': 11,
      '4': 1,
      '5': 11,
      '6': '.creativanta.commerce.v1.ShippingAddress',
      '10': 'shippingAddress'
    },
    {
      '1': 'content_requirements',
      '3': 12,
      '4': 1,
      '5': 9,
      '10': 'contentRequirements'
    },
    {'1': 'deadline', '3': 13, '4': 1, '5': 9, '10': 'deadline'},
    {'1': 'decline_reason', '3': 14, '4': 1, '5': 9, '10': 'declineReason'},
    {'1': 'notes', '3': 15, '4': 1, '5': 9, '10': 'notes'},
    {'1': 'product_title', '3': 16, '4': 1, '5': 9, '10': 'productTitle'},
    {'1': 'product_cogs', '3': 17, '4': 1, '5': 9, '10': 'productCogs'},
    {'1': 'creator_name', '3': 18, '4': 1, '5': 9, '10': 'creatorName'},
    {'1': 'creator_handle', '3': 19, '4': 1, '5': 9, '10': 'creatorHandle'},
    {
      '1': 'creator_avatar_url',
      '3': 20,
      '4': 1,
      '5': 9,
      '10': 'creatorAvatarUrl'
    },
    {
      '1': 'creator_followers',
      '3': 21,
      '4': 1,
      '5': 3,
      '10': 'creatorFollowers'
    },
    {'1': 'creator_platform', '3': 22, '4': 1, '5': 9, '10': 'creatorPlatform'},
    {
      '1': 'shipment',
      '3': 23,
      '4': 1,
      '5': 11,
      '6': '.creativanta.commerce.v1.SampleShipment',
      '10': 'shipment'
    },
    {
      '1': 'created_at',
      '3': 24,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'createdAt'
    },
    {
      '1': 'updated_at',
      '3': 25,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'updatedAt'
    },
  ],
};

/// Descriptor for `SampleRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List sampleRequestDescriptor = $convert.base64Decode(
    'Cg1TYW1wbGVSZXF1ZXN0Eh0KCnJlcXVlc3RfaWQYASABKAlSCXJlcXVlc3RJZBIhCgx3b3Jrc3'
    'BhY2VfaWQYAiABKAlSC3dvcmtzcGFjZUlkEh8KC2NhbXBhaWduX2lkGAMgASgJUgpjYW1wYWln'
    'bklkEh0KCnByb2R1Y3RfaWQYBCABKAlSCXByb2R1Y3RJZBIqChFjcmVhdG9yX2VudGl0eV9pZB'
    'gFIAEoCVIPY3JlYXRvckVudGl0eUlkEkQKBnN0YXR1cxgGIAEoDjIsLmNyZWF0aXZhbnRhLmNv'
    'bW1lcmNlLnYxLlNhbXBsZVJlcXVlc3RTdGF0dXNSBnN0YXR1cxIaCghxdWFudGl0eRgHIAEoBV'
    'IIcXVhbnRpdHkSUwoOb3V0Y29tZV9zdGF0dXMYCCABKA4yLC5jcmVhdGl2YW50YS5jb21tZXJj'
    'ZS52MS5TYW1wbGVPdXRjb21lU3RhdHVzUg1vdXRjb21lU3RhdHVzEkAKB291dGNvbWUYCSABKA'
    'syJi5jcmVhdGl2YW50YS5jb21tZXJjZS52MS5TYW1wbGVPdXRjb21lUgdvdXRjb21lElEKEGZv'
    'bGxvd191cF9zdGF0dXMYCiABKA4yJy5jcmVhdGl2YW50YS5jb21tZXJjZS52MS5Gb2xsb3dVcF'
    'N0YXR1c1IOZm9sbG93VXBTdGF0dXMSUwoQc2hpcHBpbmdfYWRkcmVzcxgLIAEoCzIoLmNyZWF0'
    'aXZhbnRhLmNvbW1lcmNlLnYxLlNoaXBwaW5nQWRkcmVzc1IPc2hpcHBpbmdBZGRyZXNzEjEKFG'
    'NvbnRlbnRfcmVxdWlyZW1lbnRzGAwgASgJUhNjb250ZW50UmVxdWlyZW1lbnRzEhoKCGRlYWRs'
    'aW5lGA0gASgJUghkZWFkbGluZRIlCg5kZWNsaW5lX3JlYXNvbhgOIAEoCVINZGVjbGluZVJlYX'
    'NvbhIUCgVub3RlcxgPIAEoCVIFbm90ZXMSIwoNcHJvZHVjdF90aXRsZRgQIAEoCVIMcHJvZHVj'
    'dFRpdGxlEiEKDHByb2R1Y3RfY29ncxgRIAEoCVILcHJvZHVjdENvZ3MSIQoMY3JlYXRvcl9uYW'
    '1lGBIgASgJUgtjcmVhdG9yTmFtZRIlCg5jcmVhdG9yX2hhbmRsZRgTIAEoCVINY3JlYXRvckhh'
    'bmRsZRIsChJjcmVhdG9yX2F2YXRhcl91cmwYFCABKAlSEGNyZWF0b3JBdmF0YXJVcmwSKwoRY3'
    'JlYXRvcl9mb2xsb3dlcnMYFSABKANSEGNyZWF0b3JGb2xsb3dlcnMSKQoQY3JlYXRvcl9wbGF0'
    'Zm9ybRgWIAEoCVIPY3JlYXRvclBsYXRmb3JtEkMKCHNoaXBtZW50GBcgASgLMicuY3JlYXRpdm'
    'FudGEuY29tbWVyY2UudjEuU2FtcGxlU2hpcG1lbnRSCHNoaXBtZW50EjkKCmNyZWF0ZWRfYXQY'
    'GCABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUgljcmVhdGVkQXQSOQoKdXBkYXRlZF'
    '9hdBgZIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSCXVwZGF0ZWRBdA==');

@$core.Deprecated('Use seedingCampaignDescriptor instead')
const SeedingCampaign$json = {
  '1': 'SeedingCampaign',
  '2': [
    {'1': 'campaign_id', '3': 1, '4': 1, '5': 9, '10': 'campaignId'},
    {'1': 'workspace_id', '3': 2, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'title', '3': 3, '4': 1, '5': 9, '10': 'title'},
    {'1': 'objective', '3': 4, '4': 1, '5': 9, '10': 'objective'},
    {'1': 'status', '3': 5, '4': 1, '5': 9, '10': 'status'},
    {'1': 'start_date', '3': 6, '4': 1, '5': 9, '10': 'startDate'},
    {'1': 'end_date', '3': 7, '4': 1, '5': 9, '10': 'endDate'},
    {'1': 'budget', '3': 8, '4': 1, '5': 9, '10': 'budget'},
    {'1': 'budget_currency', '3': 9, '4': 1, '5': 9, '10': 'budgetCurrency'},
    {
      '1': 'related_product_ids',
      '3': 10,
      '4': 3,
      '5': 9,
      '10': 'relatedProductIds'
    },
    {'1': 'total_requests', '3': 11, '4': 1, '5': 5, '10': 'totalRequests'},
    {'1': 'shipped_count', '3': 12, '4': 1, '5': 5, '10': 'shippedCount'},
    {'1': 'published_count', '3': 13, '4': 1, '5': 5, '10': 'publishedCount'},
    {'1': 'total_cost', '3': 14, '4': 1, '5': 9, '10': 'totalCost'},
    {
      '1': 'attributed_revenue',
      '3': 15,
      '4': 1,
      '5': 9,
      '10': 'attributedRevenue'
    },
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

/// Descriptor for `SeedingCampaign`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List seedingCampaignDescriptor = $convert.base64Decode(
    'Cg9TZWVkaW5nQ2FtcGFpZ24SHwoLY2FtcGFpZ25faWQYASABKAlSCmNhbXBhaWduSWQSIQoMd2'
    '9ya3NwYWNlX2lkGAIgASgJUgt3b3Jrc3BhY2VJZBIUCgV0aXRsZRgDIAEoCVIFdGl0bGUSHAoJ'
    'b2JqZWN0aXZlGAQgASgJUglvYmplY3RpdmUSFgoGc3RhdHVzGAUgASgJUgZzdGF0dXMSHQoKc3'
    'RhcnRfZGF0ZRgGIAEoCVIJc3RhcnREYXRlEhkKCGVuZF9kYXRlGAcgASgJUgdlbmREYXRlEhYK'
    'BmJ1ZGdldBgIIAEoCVIGYnVkZ2V0EicKD2J1ZGdldF9jdXJyZW5jeRgJIAEoCVIOYnVkZ2V0Q3'
    'VycmVuY3kSLgoTcmVsYXRlZF9wcm9kdWN0X2lkcxgKIAMoCVIRcmVsYXRlZFByb2R1Y3RJZHMS'
    'JQoOdG90YWxfcmVxdWVzdHMYCyABKAVSDXRvdGFsUmVxdWVzdHMSIwoNc2hpcHBlZF9jb3VudB'
    'gMIAEoBVIMc2hpcHBlZENvdW50EicKD3B1Ymxpc2hlZF9jb3VudBgNIAEoBVIOcHVibGlzaGVk'
    'Q291bnQSHQoKdG90YWxfY29zdBgOIAEoCVIJdG90YWxDb3N0Ei0KEmF0dHJpYnV0ZWRfcmV2ZW'
    '51ZRgPIAEoCVIRYXR0cmlidXRlZFJldmVudWUSOQoKY3JlYXRlZF9hdBgQIAEoCzIaLmdvb2ds'
    'ZS5wcm90b2J1Zi5UaW1lc3RhbXBSCWNyZWF0ZWRBdBI5Cgp1cGRhdGVkX2F0GBEgASgLMhouZ2'
    '9vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIJdXBkYXRlZEF0');

@$core.Deprecated('Use seedingReportDescriptor instead')
const SeedingReport$json = {
  '1': 'SeedingReport',
  '2': [
    {'1': 'campaign_id', '3': 1, '4': 1, '5': 9, '10': 'campaignId'},
    {'1': 'workspace_id', '3': 2, '4': 1, '5': 9, '10': 'workspaceId'},
    {
      '1': 'total_samples_requested',
      '3': 3,
      '4': 1,
      '5': 5,
      '10': 'totalSamplesRequested'
    },
    {
      '1': 'total_samples_approved',
      '3': 4,
      '4': 1,
      '5': 5,
      '10': 'totalSamplesApproved'
    },
    {
      '1': 'total_samples_shipped',
      '3': 5,
      '4': 1,
      '5': 5,
      '10': 'totalSamplesShipped'
    },
    {
      '1': 'total_samples_delivered',
      '3': 6,
      '4': 1,
      '5': 5,
      '10': 'totalSamplesDelivered'
    },
    {
      '1': 'outcomes_logged_count',
      '3': 7,
      '4': 1,
      '5': 5,
      '10': 'outcomesLoggedCount'
    },
    {
      '1': 'pending_outcomes_count',
      '3': 8,
      '4': 1,
      '5': 5,
      '10': 'pendingOutcomesCount'
    },
    {
      '1': 'outcome_coverage_rate',
      '3': 9,
      '4': 1,
      '5': 9,
      '10': 'outcomeCoverageRate'
    },
    {'1': 'total_cogs', '3': 10, '4': 1, '5': 9, '10': 'totalCogs'},
    {'1': 'total_shipping', '3': 11, '4': 1, '5': 9, '10': 'totalShipping'},
    {'1': 'total_cost', '3': 12, '4': 1, '5': 9, '10': 'totalCost'},
    {
      '1': 'attributable_revenue',
      '3': 13,
      '4': 1,
      '5': 9,
      '10': 'attributableRevenue'
    },
    {'1': 'roi_percentage', '3': 14, '4': 1, '5': 9, '10': 'roiPercentage'},
    {
      '1': 'overall_confidence',
      '3': 15,
      '4': 1,
      '5': 14,
      '6': '.creativanta.commerce.v1.SeedingConfidenceLevel',
      '10': 'overallConfidence'
    },
    {'1': 'confidence_notes', '3': 16, '4': 1, '5': 9, '10': 'confidenceNotes'},
    {'1': 'currency', '3': 17, '4': 1, '5': 9, '10': 'currency'},
    {
      '1': 'is_missing_outcome_pending',
      '3': 18,
      '4': 1,
      '5': 8,
      '10': 'isMissingOutcomePending'
    },
  ],
};

/// Descriptor for `SeedingReport`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List seedingReportDescriptor = $convert.base64Decode(
    'Cg1TZWVkaW5nUmVwb3J0Eh8KC2NhbXBhaWduX2lkGAEgASgJUgpjYW1wYWlnbklkEiEKDHdvcm'
    'tzcGFjZV9pZBgCIAEoCVILd29ya3NwYWNlSWQSNgoXdG90YWxfc2FtcGxlc19yZXF1ZXN0ZWQY'
    'AyABKAVSFXRvdGFsU2FtcGxlc1JlcXVlc3RlZBI0ChZ0b3RhbF9zYW1wbGVzX2FwcHJvdmVkGA'
    'QgASgFUhR0b3RhbFNhbXBsZXNBcHByb3ZlZBIyChV0b3RhbF9zYW1wbGVzX3NoaXBwZWQYBSAB'
    'KAVSE3RvdGFsU2FtcGxlc1NoaXBwZWQSNgoXdG90YWxfc2FtcGxlc19kZWxpdmVyZWQYBiABKA'
    'VSFXRvdGFsU2FtcGxlc0RlbGl2ZXJlZBIyChVvdXRjb21lc19sb2dnZWRfY291bnQYByABKAVS'
    'E291dGNvbWVzTG9nZ2VkQ291bnQSNAoWcGVuZGluZ19vdXRjb21lc19jb3VudBgIIAEoBVIUcG'
    'VuZGluZ091dGNvbWVzQ291bnQSMgoVb3V0Y29tZV9jb3ZlcmFnZV9yYXRlGAkgASgJUhNvdXRj'
    'b21lQ292ZXJhZ2VSYXRlEh0KCnRvdGFsX2NvZ3MYCiABKAlSCXRvdGFsQ29ncxIlCg50b3RhbF'
    '9zaGlwcGluZxgLIAEoCVINdG90YWxTaGlwcGluZxIdCgp0b3RhbF9jb3N0GAwgASgJUgl0b3Rh'
    'bENvc3QSMQoUYXR0cmlidXRhYmxlX3JldmVudWUYDSABKAlSE2F0dHJpYnV0YWJsZVJldmVudW'
    'USJQoOcm9pX3BlcmNlbnRhZ2UYDiABKAlSDXJvaVBlcmNlbnRhZ2USXgoSb3ZlcmFsbF9jb25m'
    'aWRlbmNlGA8gASgOMi8uY3JlYXRpdmFudGEuY29tbWVyY2UudjEuU2VlZGluZ0NvbmZpZGVuY2'
    'VMZXZlbFIRb3ZlcmFsbENvbmZpZGVuY2USKQoQY29uZmlkZW5jZV9ub3RlcxgQIAEoCVIPY29u'
    'ZmlkZW5jZU5vdGVzEhoKCGN1cnJlbmN5GBEgASgJUghjdXJyZW5jeRI7Chppc19taXNzaW5nX2'
    '91dGNvbWVfcGVuZGluZxgSIAEoCFIXaXNNaXNzaW5nT3V0Y29tZVBlbmRpbmc=');

@$core.Deprecated('Use seedingServiceCreateSampleRequestDescriptor instead')
const SeedingServiceCreateSampleRequest$json = {
  '1': 'SeedingServiceCreateSampleRequest',
  '2': [
    {'1': 'idempotency_key', '3': 1, '4': 1, '5': 9, '10': 'idempotencyKey'},
    {'1': 'workspace_id', '3': 2, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'campaign_id', '3': 3, '4': 1, '5': 9, '10': 'campaignId'},
    {'1': 'product_id', '3': 4, '4': 1, '5': 9, '10': 'productId'},
    {'1': 'creator_entity_id', '3': 5, '4': 1, '5': 9, '10': 'creatorEntityId'},
    {'1': 'quantity', '3': 6, '4': 1, '5': 5, '10': 'quantity'},
    {
      '1': 'shipping_address',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.creativanta.commerce.v1.ShippingAddress',
      '10': 'shippingAddress'
    },
    {
      '1': 'content_requirements',
      '3': 8,
      '4': 1,
      '5': 9,
      '10': 'contentRequirements'
    },
    {'1': 'deadline', '3': 9, '4': 1, '5': 9, '10': 'deadline'},
    {'1': 'notes', '3': 10, '4': 1, '5': 9, '10': 'notes'},
  ],
};

/// Descriptor for `SeedingServiceCreateSampleRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List seedingServiceCreateSampleRequestDescriptor = $convert.base64Decode(
    'CiFTZWVkaW5nU2VydmljZUNyZWF0ZVNhbXBsZVJlcXVlc3QSJwoPaWRlbXBvdGVuY3lfa2V5GA'
    'EgASgJUg5pZGVtcG90ZW5jeUtleRIhCgx3b3Jrc3BhY2VfaWQYAiABKAlSC3dvcmtzcGFjZUlk'
    'Eh8KC2NhbXBhaWduX2lkGAMgASgJUgpjYW1wYWlnbklkEh0KCnByb2R1Y3RfaWQYBCABKAlSCX'
    'Byb2R1Y3RJZBIqChFjcmVhdG9yX2VudGl0eV9pZBgFIAEoCVIPY3JlYXRvckVudGl0eUlkEhoK'
    'CHF1YW50aXR5GAYgASgFUghxdWFudGl0eRJTChBzaGlwcGluZ19hZGRyZXNzGAcgASgLMiguY3'
    'JlYXRpdmFudGEuY29tbWVyY2UudjEuU2hpcHBpbmdBZGRyZXNzUg9zaGlwcGluZ0FkZHJlc3MS'
    'MQoUY29udGVudF9yZXF1aXJlbWVudHMYCCABKAlSE2NvbnRlbnRSZXF1aXJlbWVudHMSGgoIZG'
    'VhZGxpbmUYCSABKAlSCGRlYWRsaW5lEhQKBW5vdGVzGAogASgJUgVub3Rlcw==');

@$core.Deprecated('Use seedingServiceCreateSampleResponseDescriptor instead')
const SeedingServiceCreateSampleResponse$json = {
  '1': 'SeedingServiceCreateSampleResponse',
  '2': [
    {
      '1': 'sample_request',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.commerce.v1.SampleRequest',
      '10': 'sampleRequest'
    },
    {'1': 'already_existed', '3': 2, '4': 1, '5': 8, '10': 'alreadyExisted'},
  ],
};

/// Descriptor for `SeedingServiceCreateSampleResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List seedingServiceCreateSampleResponseDescriptor =
    $convert.base64Decode(
        'CiJTZWVkaW5nU2VydmljZUNyZWF0ZVNhbXBsZVJlc3BvbnNlEk0KDnNhbXBsZV9yZXF1ZXN0GA'
        'EgASgLMiYuY3JlYXRpdmFudGEuY29tbWVyY2UudjEuU2FtcGxlUmVxdWVzdFINc2FtcGxlUmVx'
        'dWVzdBInCg9hbHJlYWR5X2V4aXN0ZWQYAiABKAhSDmFscmVhZHlFeGlzdGVk');

@$core.Deprecated('Use seedingServiceGetRequestDescriptor instead')
const SeedingServiceGetRequest$json = {
  '1': 'SeedingServiceGetRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'request_id', '3': 2, '4': 1, '5': 9, '10': 'requestId'},
  ],
};

/// Descriptor for `SeedingServiceGetRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List seedingServiceGetRequestDescriptor =
    $convert.base64Decode(
        'ChhTZWVkaW5nU2VydmljZUdldFJlcXVlc3QSIQoMd29ya3NwYWNlX2lkGAEgASgJUgt3b3Jrc3'
        'BhY2VJZBIdCgpyZXF1ZXN0X2lkGAIgASgJUglyZXF1ZXN0SWQ=');

@$core.Deprecated('Use seedingServiceGetResponseDescriptor instead')
const SeedingServiceGetResponse$json = {
  '1': 'SeedingServiceGetResponse',
  '2': [
    {
      '1': 'sample_request',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.commerce.v1.SampleRequest',
      '10': 'sampleRequest'
    },
  ],
};

/// Descriptor for `SeedingServiceGetResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List seedingServiceGetResponseDescriptor =
    $convert.base64Decode(
        'ChlTZWVkaW5nU2VydmljZUdldFJlc3BvbnNlEk0KDnNhbXBsZV9yZXF1ZXN0GAEgASgLMiYuY3'
        'JlYXRpdmFudGEuY29tbWVyY2UudjEuU2FtcGxlUmVxdWVzdFINc2FtcGxlUmVxdWVzdA==');

@$core.Deprecated('Use seedingServiceListRequestDescriptor instead')
const SeedingServiceListRequest$json = {
  '1': 'SeedingServiceListRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'campaign_id', '3': 2, '4': 1, '5': 9, '10': 'campaignId'},
    {'1': 'product_id', '3': 3, '4': 1, '5': 9, '10': 'productId'},
    {'1': 'creator_entity_id', '3': 4, '4': 1, '5': 9, '10': 'creatorEntityId'},
    {
      '1': 'status',
      '3': 5,
      '4': 1,
      '5': 14,
      '6': '.creativanta.commerce.v1.SampleRequestStatus',
      '10': 'status'
    },
    {
      '1': 'outcome_status',
      '3': 6,
      '4': 1,
      '5': 14,
      '6': '.creativanta.commerce.v1.SampleOutcomeStatus',
      '10': 'outcomeStatus'
    },
    {
      '1': 'follow_up_status',
      '3': 7,
      '4': 1,
      '5': 14,
      '6': '.creativanta.commerce.v1.FollowUpStatus',
      '10': 'followUpStatus'
    },
    {'1': 'limit', '3': 8, '4': 1, '5': 5, '10': 'limit'},
    {'1': 'offset', '3': 9, '4': 1, '5': 5, '10': 'offset'},
  ],
};

/// Descriptor for `SeedingServiceListRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List seedingServiceListRequestDescriptor = $convert.base64Decode(
    'ChlTZWVkaW5nU2VydmljZUxpc3RSZXF1ZXN0EiEKDHdvcmtzcGFjZV9pZBgBIAEoCVILd29ya3'
    'NwYWNlSWQSHwoLY2FtcGFpZ25faWQYAiABKAlSCmNhbXBhaWduSWQSHQoKcHJvZHVjdF9pZBgD'
    'IAEoCVIJcHJvZHVjdElkEioKEWNyZWF0b3JfZW50aXR5X2lkGAQgASgJUg9jcmVhdG9yRW50aX'
    'R5SWQSRAoGc3RhdHVzGAUgASgOMiwuY3JlYXRpdmFudGEuY29tbWVyY2UudjEuU2FtcGxlUmVx'
    'dWVzdFN0YXR1c1IGc3RhdHVzElMKDm91dGNvbWVfc3RhdHVzGAYgASgOMiwuY3JlYXRpdmFudG'
    'EuY29tbWVyY2UudjEuU2FtcGxlT3V0Y29tZVN0YXR1c1INb3V0Y29tZVN0YXR1cxJRChBmb2xs'
    'b3dfdXBfc3RhdHVzGAcgASgOMicuY3JlYXRpdmFudGEuY29tbWVyY2UudjEuRm9sbG93VXBTdG'
    'F0dXNSDmZvbGxvd1VwU3RhdHVzEhQKBWxpbWl0GAggASgFUgVsaW1pdBIWCgZvZmZzZXQYCSAB'
    'KAVSBm9mZnNldA==');

@$core.Deprecated('Use seedingServiceListResponseDescriptor instead')
const SeedingServiceListResponse$json = {
  '1': 'SeedingServiceListResponse',
  '2': [
    {
      '1': 'sample_requests',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.creativanta.commerce.v1.SampleRequest',
      '10': 'sampleRequests'
    },
    {'1': 'total_count', '3': 2, '4': 1, '5': 3, '10': 'totalCount'},
    {'1': 'requested_count', '3': 3, '4': 1, '5': 5, '10': 'requestedCount'},
    {'1': 'approved_count', '3': 4, '4': 1, '5': 5, '10': 'approvedCount'},
    {'1': 'shipped_count', '3': 5, '4': 1, '5': 5, '10': 'shippedCount'},
    {'1': 'received_count', '3': 6, '4': 1, '5': 5, '10': 'receivedCount'},
    {
      '1': 'review_published_count',
      '3': 7,
      '4': 1,
      '5': 5,
      '10': 'reviewPublishedCount'
    },
  ],
};

/// Descriptor for `SeedingServiceListResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List seedingServiceListResponseDescriptor = $convert.base64Decode(
    'ChpTZWVkaW5nU2VydmljZUxpc3RSZXNwb25zZRJPCg9zYW1wbGVfcmVxdWVzdHMYASADKAsyJi'
    '5jcmVhdGl2YW50YS5jb21tZXJjZS52MS5TYW1wbGVSZXF1ZXN0Ug5zYW1wbGVSZXF1ZXN0cxIf'
    'Cgt0b3RhbF9jb3VudBgCIAEoA1IKdG90YWxDb3VudBInCg9yZXF1ZXN0ZWRfY291bnQYAyABKA'
    'VSDnJlcXVlc3RlZENvdW50EiUKDmFwcHJvdmVkX2NvdW50GAQgASgFUg1hcHByb3ZlZENvdW50'
    'EiMKDXNoaXBwZWRfY291bnQYBSABKAVSDHNoaXBwZWRDb3VudBIlCg5yZWNlaXZlZF9jb3VudB'
    'gGIAEoBVINcmVjZWl2ZWRDb3VudBI0ChZyZXZpZXdfcHVibGlzaGVkX2NvdW50GAcgASgFUhRy'
    'ZXZpZXdQdWJsaXNoZWRDb3VudA==');

@$core.Deprecated('Use seedingServiceApproveRequestDescriptor instead')
const SeedingServiceApproveRequest$json = {
  '1': 'SeedingServiceApproveRequest',
  '2': [
    {'1': 'idempotency_key', '3': 1, '4': 1, '5': 9, '10': 'idempotencyKey'},
    {'1': 'workspace_id', '3': 2, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'request_id', '3': 3, '4': 1, '5': 9, '10': 'requestId'},
  ],
};

/// Descriptor for `SeedingServiceApproveRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List seedingServiceApproveRequestDescriptor =
    $convert.base64Decode(
        'ChxTZWVkaW5nU2VydmljZUFwcHJvdmVSZXF1ZXN0EicKD2lkZW1wb3RlbmN5X2tleRgBIAEoCV'
        'IOaWRlbXBvdGVuY3lLZXkSIQoMd29ya3NwYWNlX2lkGAIgASgJUgt3b3Jrc3BhY2VJZBIdCgpy'
        'ZXF1ZXN0X2lkGAMgASgJUglyZXF1ZXN0SWQ=');

@$core.Deprecated('Use seedingServiceApproveResponseDescriptor instead')
const SeedingServiceApproveResponse$json = {
  '1': 'SeedingServiceApproveResponse',
  '2': [
    {
      '1': 'sample_request',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.commerce.v1.SampleRequest',
      '10': 'sampleRequest'
    },
    {'1': 'cost_item_id', '3': 2, '4': 1, '5': 9, '10': 'costItemId'},
    {'1': 'cost_amount', '3': 3, '4': 1, '5': 9, '10': 'costAmount'},
    {'1': 'currency', '3': 4, '4': 1, '5': 9, '10': 'currency'},
    {'1': 'replayed', '3': 5, '4': 1, '5': 8, '10': 'replayed'},
  ],
};

/// Descriptor for `SeedingServiceApproveResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List seedingServiceApproveResponseDescriptor = $convert.base64Decode(
    'Ch1TZWVkaW5nU2VydmljZUFwcHJvdmVSZXNwb25zZRJNCg5zYW1wbGVfcmVxdWVzdBgBIAEoCz'
    'ImLmNyZWF0aXZhbnRhLmNvbW1lcmNlLnYxLlNhbXBsZVJlcXVlc3RSDXNhbXBsZVJlcXVlc3QS'
    'IAoMY29zdF9pdGVtX2lkGAIgASgJUgpjb3N0SXRlbUlkEh8KC2Nvc3RfYW1vdW50GAMgASgJUg'
    'pjb3N0QW1vdW50EhoKCGN1cnJlbmN5GAQgASgJUghjdXJyZW5jeRIaCghyZXBsYXllZBgFIAEo'
    'CFIIcmVwbGF5ZWQ=');

@$core.Deprecated('Use seedingServiceShipRequestDescriptor instead')
const SeedingServiceShipRequest$json = {
  '1': 'SeedingServiceShipRequest',
  '2': [
    {'1': 'idempotency_key', '3': 1, '4': 1, '5': 9, '10': 'idempotencyKey'},
    {'1': 'workspace_id', '3': 2, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'request_id', '3': 3, '4': 1, '5': 9, '10': 'requestId'},
    {'1': 'carrier', '3': 4, '4': 1, '5': 9, '10': 'carrier'},
    {'1': 'tracking_number', '3': 5, '4': 1, '5': 9, '10': 'trackingNumber'},
    {'1': 'shipping_cost', '3': 6, '4': 1, '5': 9, '10': 'shippingCost'},
  ],
};

/// Descriptor for `SeedingServiceShipRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List seedingServiceShipRequestDescriptor = $convert.base64Decode(
    'ChlTZWVkaW5nU2VydmljZVNoaXBSZXF1ZXN0EicKD2lkZW1wb3RlbmN5X2tleRgBIAEoCVIOaW'
    'RlbXBvdGVuY3lLZXkSIQoMd29ya3NwYWNlX2lkGAIgASgJUgt3b3Jrc3BhY2VJZBIdCgpyZXF1'
    'ZXN0X2lkGAMgASgJUglyZXF1ZXN0SWQSGAoHY2FycmllchgEIAEoCVIHY2FycmllchInCg90cm'
    'Fja2luZ19udW1iZXIYBSABKAlSDnRyYWNraW5nTnVtYmVyEiMKDXNoaXBwaW5nX2Nvc3QYBiAB'
    'KAlSDHNoaXBwaW5nQ29zdA==');

@$core.Deprecated('Use seedingServiceShipResponseDescriptor instead')
const SeedingServiceShipResponse$json = {
  '1': 'SeedingServiceShipResponse',
  '2': [
    {
      '1': 'sample_request',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.commerce.v1.SampleRequest',
      '10': 'sampleRequest'
    },
    {
      '1': 'shipment',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.creativanta.commerce.v1.SampleShipment',
      '10': 'shipment'
    },
    {
      '1': 'total_updated_cost',
      '3': 3,
      '4': 1,
      '5': 9,
      '10': 'totalUpdatedCost'
    },
    {'1': 'replayed', '3': 4, '4': 1, '5': 8, '10': 'replayed'},
  ],
};

/// Descriptor for `SeedingServiceShipResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List seedingServiceShipResponseDescriptor = $convert.base64Decode(
    'ChpTZWVkaW5nU2VydmljZVNoaXBSZXNwb25zZRJNCg5zYW1wbGVfcmVxdWVzdBgBIAEoCzImLm'
    'NyZWF0aXZhbnRhLmNvbW1lcmNlLnYxLlNhbXBsZVJlcXVlc3RSDXNhbXBsZVJlcXVlc3QSQwoI'
    'c2hpcG1lbnQYAiABKAsyJy5jcmVhdGl2YW50YS5jb21tZXJjZS52MS5TYW1wbGVTaGlwbWVudF'
    'IIc2hpcG1lbnQSLAoSdG90YWxfdXBkYXRlZF9jb3N0GAMgASgJUhB0b3RhbFVwZGF0ZWRDb3N0'
    'EhoKCHJlcGxheWVkGAQgASgIUghyZXBsYXllZA==');

@$core.Deprecated('Use seedingServiceTrackDeliveryRequestDescriptor instead')
const SeedingServiceTrackDeliveryRequest$json = {
  '1': 'SeedingServiceTrackDeliveryRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'shipment_id', '3': 2, '4': 1, '5': 9, '10': 'shipmentId'},
  ],
};

/// Descriptor for `SeedingServiceTrackDeliveryRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List seedingServiceTrackDeliveryRequestDescriptor =
    $convert.base64Decode(
        'CiJTZWVkaW5nU2VydmljZVRyYWNrRGVsaXZlcnlSZXF1ZXN0EiEKDHdvcmtzcGFjZV9pZBgBIA'
        'EoCVILd29ya3NwYWNlSWQSHwoLc2hpcG1lbnRfaWQYAiABKAlSCnNoaXBtZW50SWQ=');

@$core.Deprecated('Use seedingServiceTrackDeliveryResponseDescriptor instead')
const SeedingServiceTrackDeliveryResponse$json = {
  '1': 'SeedingServiceTrackDeliveryResponse',
  '2': [
    {
      '1': 'shipment',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.commerce.v1.SampleShipment',
      '10': 'shipment'
    },
    {'1': 'carrier_status', '3': 2, '4': 1, '5': 9, '10': 'carrierStatus'},
    {
      '1': 'estimated_delivery',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'estimatedDelivery'
    },
  ],
};

/// Descriptor for `SeedingServiceTrackDeliveryResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List seedingServiceTrackDeliveryResponseDescriptor =
    $convert.base64Decode(
        'CiNTZWVkaW5nU2VydmljZVRyYWNrRGVsaXZlcnlSZXNwb25zZRJDCghzaGlwbWVudBgBIAEoCz'
        'InLmNyZWF0aXZhbnRhLmNvbW1lcmNlLnYxLlNhbXBsZVNoaXBtZW50UghzaGlwbWVudBIlCg5j'
        'YXJyaWVyX3N0YXR1cxgCIAEoCVINY2FycmllclN0YXR1cxJJChJlc3RpbWF0ZWRfZGVsaXZlcn'
        'kYAyABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUhFlc3RpbWF0ZWREZWxpdmVyeQ==');

@$core.Deprecated('Use seedingServiceGetReportRequestDescriptor instead')
const SeedingServiceGetReportRequest$json = {
  '1': 'SeedingServiceGetReportRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'campaign_id', '3': 2, '4': 1, '5': 9, '10': 'campaignId'},
  ],
};

/// Descriptor for `SeedingServiceGetReportRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List seedingServiceGetReportRequestDescriptor =
    $convert.base64Decode(
        'Ch5TZWVkaW5nU2VydmljZUdldFJlcG9ydFJlcXVlc3QSIQoMd29ya3NwYWNlX2lkGAEgASgJUg'
        't3b3Jrc3BhY2VJZBIfCgtjYW1wYWlnbl9pZBgCIAEoCVIKY2FtcGFpZ25JZA==');

@$core.Deprecated('Use seedingServiceGetReportResponseDescriptor instead')
const SeedingServiceGetReportResponse$json = {
  '1': 'SeedingServiceGetReportResponse',
  '2': [
    {
      '1': 'report',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.commerce.v1.SeedingReport',
      '10': 'report'
    },
  ],
};

/// Descriptor for `SeedingServiceGetReportResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List seedingServiceGetReportResponseDescriptor =
    $convert.base64Decode(
        'Ch9TZWVkaW5nU2VydmljZUdldFJlcG9ydFJlc3BvbnNlEj4KBnJlcG9ydBgBIAEoCzImLmNyZW'
        'F0aXZhbnRhLmNvbW1lcmNlLnYxLlNlZWRpbmdSZXBvcnRSBnJlcG9ydA==');

@$core.Deprecated('Use seedingServiceCreateCampaignRequestDescriptor instead')
const SeedingServiceCreateCampaignRequest$json = {
  '1': 'SeedingServiceCreateCampaignRequest',
  '2': [
    {'1': 'idempotency_key', '3': 1, '4': 1, '5': 9, '10': 'idempotencyKey'},
    {'1': 'workspace_id', '3': 2, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'title', '3': 3, '4': 1, '5': 9, '10': 'title'},
    {'1': 'objective', '3': 4, '4': 1, '5': 9, '10': 'objective'},
    {'1': 'start_date', '3': 5, '4': 1, '5': 9, '10': 'startDate'},
    {'1': 'end_date', '3': 6, '4': 1, '5': 9, '10': 'endDate'},
    {'1': 'budget', '3': 7, '4': 1, '5': 9, '10': 'budget'},
    {'1': 'budget_currency', '3': 8, '4': 1, '5': 9, '10': 'budgetCurrency'},
    {
      '1': 'related_product_ids',
      '3': 9,
      '4': 3,
      '5': 9,
      '10': 'relatedProductIds'
    },
  ],
};

/// Descriptor for `SeedingServiceCreateCampaignRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List seedingServiceCreateCampaignRequestDescriptor = $convert.base64Decode(
    'CiNTZWVkaW5nU2VydmljZUNyZWF0ZUNhbXBhaWduUmVxdWVzdBInCg9pZGVtcG90ZW5jeV9rZX'
    'kYASABKAlSDmlkZW1wb3RlbmN5S2V5EiEKDHdvcmtzcGFjZV9pZBgCIAEoCVILd29ya3NwYWNl'
    'SWQSFAoFdGl0bGUYAyABKAlSBXRpdGxlEhwKCW9iamVjdGl2ZRgEIAEoCVIJb2JqZWN0aXZlEh'
    '0KCnN0YXJ0X2RhdGUYBSABKAlSCXN0YXJ0RGF0ZRIZCghlbmRfZGF0ZRgGIAEoCVIHZW5kRGF0'
    'ZRIWCgZidWRnZXQYByABKAlSBmJ1ZGdldBInCg9idWRnZXRfY3VycmVuY3kYCCABKAlSDmJ1ZG'
    'dldEN1cnJlbmN5Ei4KE3JlbGF0ZWRfcHJvZHVjdF9pZHMYCSADKAlSEXJlbGF0ZWRQcm9kdWN0'
    'SWRz');

@$core.Deprecated('Use seedingServiceCreateCampaignResponseDescriptor instead')
const SeedingServiceCreateCampaignResponse$json = {
  '1': 'SeedingServiceCreateCampaignResponse',
  '2': [
    {
      '1': 'campaign',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.commerce.v1.SeedingCampaign',
      '10': 'campaign'
    },
  ],
};

/// Descriptor for `SeedingServiceCreateCampaignResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List seedingServiceCreateCampaignResponseDescriptor =
    $convert.base64Decode(
        'CiRTZWVkaW5nU2VydmljZUNyZWF0ZUNhbXBhaWduUmVzcG9uc2USRAoIY2FtcGFpZ24YASABKA'
        'syKC5jcmVhdGl2YW50YS5jb21tZXJjZS52MS5TZWVkaW5nQ2FtcGFpZ25SCGNhbXBhaWdu');

@$core.Deprecated('Use seedingServiceListCampaignsRequestDescriptor instead')
const SeedingServiceListCampaignsRequest$json = {
  '1': 'SeedingServiceListCampaignsRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'status', '3': 2, '4': 1, '5': 9, '10': 'status'},
    {'1': 'limit', '3': 3, '4': 1, '5': 5, '10': 'limit'},
    {'1': 'offset', '3': 4, '4': 1, '5': 5, '10': 'offset'},
  ],
};

/// Descriptor for `SeedingServiceListCampaignsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List seedingServiceListCampaignsRequestDescriptor =
    $convert.base64Decode(
        'CiJTZWVkaW5nU2VydmljZUxpc3RDYW1wYWlnbnNSZXF1ZXN0EiEKDHdvcmtzcGFjZV9pZBgBIA'
        'EoCVILd29ya3NwYWNlSWQSFgoGc3RhdHVzGAIgASgJUgZzdGF0dXMSFAoFbGltaXQYAyABKAVS'
        'BWxpbWl0EhYKBm9mZnNldBgEIAEoBVIGb2Zmc2V0');

@$core.Deprecated('Use seedingServiceListCampaignsResponseDescriptor instead')
const SeedingServiceListCampaignsResponse$json = {
  '1': 'SeedingServiceListCampaignsResponse',
  '2': [
    {
      '1': 'campaigns',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.creativanta.commerce.v1.SeedingCampaign',
      '10': 'campaigns'
    },
    {'1': 'total_count', '3': 2, '4': 1, '5': 3, '10': 'totalCount'},
  ],
};

/// Descriptor for `SeedingServiceListCampaignsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List seedingServiceListCampaignsResponseDescriptor =
    $convert.base64Decode(
        'CiNTZWVkaW5nU2VydmljZUxpc3RDYW1wYWlnbnNSZXNwb25zZRJGCgljYW1wYWlnbnMYASADKA'
        'syKC5jcmVhdGl2YW50YS5jb21tZXJjZS52MS5TZWVkaW5nQ2FtcGFpZ25SCWNhbXBhaWducxIf'
        'Cgt0b3RhbF9jb3VudBgCIAEoA1IKdG90YWxDb3VudA==');

@$core.Deprecated('Use seedingServiceCreateAssignmentRequestDescriptor instead')
const SeedingServiceCreateAssignmentRequest$json = {
  '1': 'SeedingServiceCreateAssignmentRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'campaign_id', '3': 2, '4': 1, '5': 9, '10': 'campaignId'},
    {'1': 'creator_entity_id', '3': 3, '4': 1, '5': 9, '10': 'creatorEntityId'},
    {'1': 'product_id', '3': 4, '4': 1, '5': 9, '10': 'productId'},
    {'1': 'notes', '3': 5, '4': 1, '5': 9, '10': 'notes'},
  ],
};

/// Descriptor for `SeedingServiceCreateAssignmentRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List seedingServiceCreateAssignmentRequestDescriptor =
    $convert.base64Decode(
        'CiVTZWVkaW5nU2VydmljZUNyZWF0ZUFzc2lnbm1lbnRSZXF1ZXN0EiEKDHdvcmtzcGFjZV9pZB'
        'gBIAEoCVILd29ya3NwYWNlSWQSHwoLY2FtcGFpZ25faWQYAiABKAlSCmNhbXBhaWduSWQSKgoR'
        'Y3JlYXRvcl9lbnRpdHlfaWQYAyABKAlSD2NyZWF0b3JFbnRpdHlJZBIdCgpwcm9kdWN0X2lkGA'
        'QgASgJUglwcm9kdWN0SWQSFAoFbm90ZXMYBSABKAlSBW5vdGVz');

@$core
    .Deprecated('Use seedingServiceCreateAssignmentResponseDescriptor instead')
const SeedingServiceCreateAssignmentResponse$json = {
  '1': 'SeedingServiceCreateAssignmentResponse',
  '2': [
    {'1': 'assignment_id', '3': 1, '4': 1, '5': 9, '10': 'assignmentId'},
    {
      '1': 'sample_request',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.creativanta.commerce.v1.SampleRequest',
      '10': 'sampleRequest'
    },
  ],
};

/// Descriptor for `SeedingServiceCreateAssignmentResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List seedingServiceCreateAssignmentResponseDescriptor =
    $convert.base64Decode(
        'CiZTZWVkaW5nU2VydmljZUNyZWF0ZUFzc2lnbm1lbnRSZXNwb25zZRIjCg1hc3NpZ25tZW50X2'
        'lkGAEgASgJUgxhc3NpZ25tZW50SWQSTQoOc2FtcGxlX3JlcXVlc3QYAiABKAsyJi5jcmVhdGl2'
        'YW50YS5jb21tZXJjZS52MS5TYW1wbGVSZXF1ZXN0Ug1zYW1wbGVSZXF1ZXN0');

@$core.Deprecated('Use seedingServiceRemoveAssignmentRequestDescriptor instead')
const SeedingServiceRemoveAssignmentRequest$json = {
  '1': 'SeedingServiceRemoveAssignmentRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'assignment_id', '3': 2, '4': 1, '5': 9, '10': 'assignmentId'},
  ],
};

/// Descriptor for `SeedingServiceRemoveAssignmentRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List seedingServiceRemoveAssignmentRequestDescriptor =
    $convert.base64Decode(
        'CiVTZWVkaW5nU2VydmljZVJlbW92ZUFzc2lnbm1lbnRSZXF1ZXN0EiEKDHdvcmtzcGFjZV9pZB'
        'gBIAEoCVILd29ya3NwYWNlSWQSIwoNYXNzaWdubWVudF9pZBgCIAEoCVIMYXNzaWdubWVudElk');

@$core
    .Deprecated('Use seedingServiceRemoveAssignmentResponseDescriptor instead')
const SeedingServiceRemoveAssignmentResponse$json = {
  '1': 'SeedingServiceRemoveAssignmentResponse',
  '2': [
    {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
  ],
};

/// Descriptor for `SeedingServiceRemoveAssignmentResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List seedingServiceRemoveAssignmentResponseDescriptor =
    $convert.base64Decode(
        'CiZTZWVkaW5nU2VydmljZVJlbW92ZUFzc2lnbm1lbnRSZXNwb25zZRIYCgdzdWNjZXNzGAEgAS'
        'gIUgdzdWNjZXNz');

@$core.Deprecated('Use seedingServiceListAssignmentsRequestDescriptor instead')
const SeedingServiceListAssignmentsRequest$json = {
  '1': 'SeedingServiceListAssignmentsRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'campaign_id', '3': 2, '4': 1, '5': 9, '10': 'campaignId'},
    {'1': 'limit', '3': 3, '4': 1, '5': 5, '10': 'limit'},
    {'1': 'offset', '3': 4, '4': 1, '5': 5, '10': 'offset'},
  ],
};

/// Descriptor for `SeedingServiceListAssignmentsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List seedingServiceListAssignmentsRequestDescriptor =
    $convert.base64Decode(
        'CiRTZWVkaW5nU2VydmljZUxpc3RBc3NpZ25tZW50c1JlcXVlc3QSIQoMd29ya3NwYWNlX2lkGA'
        'EgASgJUgt3b3Jrc3BhY2VJZBIfCgtjYW1wYWlnbl9pZBgCIAEoCVIKY2FtcGFpZ25JZBIUCgVs'
        'aW1pdBgDIAEoBVIFbGltaXQSFgoGb2Zmc2V0GAQgASgFUgZvZmZzZXQ=');

@$core.Deprecated('Use seedingServiceListAssignmentsResponseDescriptor instead')
const SeedingServiceListAssignmentsResponse$json = {
  '1': 'SeedingServiceListAssignmentsResponse',
  '2': [
    {
      '1': 'assignments',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.creativanta.commerce.v1.SampleRequest',
      '10': 'assignments'
    },
    {'1': 'total_count', '3': 2, '4': 1, '5': 3, '10': 'totalCount'},
  ],
};

/// Descriptor for `SeedingServiceListAssignmentsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List seedingServiceListAssignmentsResponseDescriptor =
    $convert.base64Decode(
        'CiVTZWVkaW5nU2VydmljZUxpc3RBc3NpZ25tZW50c1Jlc3BvbnNlEkgKC2Fzc2lnbm1lbnRzGA'
        'EgAygLMiYuY3JlYXRpdmFudGEuY29tbWVyY2UudjEuU2FtcGxlUmVxdWVzdFILYXNzaWdubWVu'
        'dHMSHwoLdG90YWxfY291bnQYAiABKANSCnRvdGFsQ291bnQ=');

@$core.Deprecated('Use seedingServiceListRequestsRequestDescriptor instead')
const SeedingServiceListRequestsRequest$json = {
  '1': 'SeedingServiceListRequestsRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'campaign_id', '3': 2, '4': 1, '5': 9, '10': 'campaignId'},
    {
      '1': 'status',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.creativanta.commerce.v1.SampleRequestStatus',
      '10': 'status'
    },
    {'1': 'limit', '3': 4, '4': 1, '5': 5, '10': 'limit'},
    {'1': 'offset', '3': 5, '4': 1, '5': 5, '10': 'offset'},
  ],
};

/// Descriptor for `SeedingServiceListRequestsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List seedingServiceListRequestsRequestDescriptor =
    $convert.base64Decode(
        'CiFTZWVkaW5nU2VydmljZUxpc3RSZXF1ZXN0c1JlcXVlc3QSIQoMd29ya3NwYWNlX2lkGAEgAS'
        'gJUgt3b3Jrc3BhY2VJZBIfCgtjYW1wYWlnbl9pZBgCIAEoCVIKY2FtcGFpZ25JZBJECgZzdGF0'
        'dXMYAyABKA4yLC5jcmVhdGl2YW50YS5jb21tZXJjZS52MS5TYW1wbGVSZXF1ZXN0U3RhdHVzUg'
        'ZzdGF0dXMSFAoFbGltaXQYBCABKAVSBWxpbWl0EhYKBm9mZnNldBgFIAEoBVIGb2Zmc2V0');

@$core.Deprecated('Use seedingServiceListRequestsResponseDescriptor instead')
const SeedingServiceListRequestsResponse$json = {
  '1': 'SeedingServiceListRequestsResponse',
  '2': [
    {
      '1': 'sample_requests',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.creativanta.commerce.v1.SampleRequest',
      '10': 'sampleRequests'
    },
    {'1': 'total_count', '3': 2, '4': 1, '5': 3, '10': 'totalCount'},
  ],
};

/// Descriptor for `SeedingServiceListRequestsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List seedingServiceListRequestsResponseDescriptor =
    $convert.base64Decode(
        'CiJTZWVkaW5nU2VydmljZUxpc3RSZXF1ZXN0c1Jlc3BvbnNlEk8KD3NhbXBsZV9yZXF1ZXN0cx'
        'gBIAMoCzImLmNyZWF0aXZhbnRhLmNvbW1lcmNlLnYxLlNhbXBsZVJlcXVlc3RSDnNhbXBsZVJl'
        'cXVlc3RzEh8KC3RvdGFsX2NvdW50GAIgASgDUgp0b3RhbENvdW50');

@$core.Deprecated('Use seedingServiceMarkReceivedRequestDescriptor instead')
const SeedingServiceMarkReceivedRequest$json = {
  '1': 'SeedingServiceMarkReceivedRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'request_id', '3': 2, '4': 1, '5': 9, '10': 'requestId'},
  ],
};

/// Descriptor for `SeedingServiceMarkReceivedRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List seedingServiceMarkReceivedRequestDescriptor =
    $convert.base64Decode(
        'CiFTZWVkaW5nU2VydmljZU1hcmtSZWNlaXZlZFJlcXVlc3QSIQoMd29ya3NwYWNlX2lkGAEgAS'
        'gJUgt3b3Jrc3BhY2VJZBIdCgpyZXF1ZXN0X2lkGAIgASgJUglyZXF1ZXN0SWQ=');

@$core.Deprecated('Use seedingServiceMarkReceivedResponseDescriptor instead')
const SeedingServiceMarkReceivedResponse$json = {
  '1': 'SeedingServiceMarkReceivedResponse',
  '2': [
    {
      '1': 'sample_request',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.commerce.v1.SampleRequest',
      '10': 'sampleRequest'
    },
    {
      '1': 'shipment',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.creativanta.commerce.v1.SampleShipment',
      '10': 'shipment'
    },
  ],
};

/// Descriptor for `SeedingServiceMarkReceivedResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List seedingServiceMarkReceivedResponseDescriptor =
    $convert.base64Decode(
        'CiJTZWVkaW5nU2VydmljZU1hcmtSZWNlaXZlZFJlc3BvbnNlEk0KDnNhbXBsZV9yZXF1ZXN0GA'
        'EgASgLMiYuY3JlYXRpdmFudGEuY29tbWVyY2UudjEuU2FtcGxlUmVxdWVzdFINc2FtcGxlUmVx'
        'dWVzdBJDCghzaGlwbWVudBgCIAEoCzInLmNyZWF0aXZhbnRhLmNvbW1lcmNlLnYxLlNhbXBsZV'
        'NoaXBtZW50UghzaGlwbWVudA==');

@$core.Deprecated('Use seedingServiceMarkShippedRequestDescriptor instead')
const SeedingServiceMarkShippedRequest$json = {
  '1': 'SeedingServiceMarkShippedRequest',
  '2': [
    {'1': 'idempotency_key', '3': 1, '4': 1, '5': 9, '10': 'idempotencyKey'},
    {'1': 'workspace_id', '3': 2, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'request_id', '3': 3, '4': 1, '5': 9, '10': 'requestId'},
    {'1': 'carrier', '3': 4, '4': 1, '5': 9, '10': 'carrier'},
    {'1': 'tracking_number', '3': 5, '4': 1, '5': 9, '10': 'trackingNumber'},
    {'1': 'shipping_cost', '3': 6, '4': 1, '5': 9, '10': 'shippingCost'},
  ],
};

/// Descriptor for `SeedingServiceMarkShippedRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List seedingServiceMarkShippedRequestDescriptor = $convert.base64Decode(
    'CiBTZWVkaW5nU2VydmljZU1hcmtTaGlwcGVkUmVxdWVzdBInCg9pZGVtcG90ZW5jeV9rZXkYAS'
    'ABKAlSDmlkZW1wb3RlbmN5S2V5EiEKDHdvcmtzcGFjZV9pZBgCIAEoCVILd29ya3NwYWNlSWQS'
    'HQoKcmVxdWVzdF9pZBgDIAEoCVIJcmVxdWVzdElkEhgKB2NhcnJpZXIYBCABKAlSB2NhcnJpZX'
    'ISJwoPdHJhY2tpbmdfbnVtYmVyGAUgASgJUg50cmFja2luZ051bWJlchIjCg1zaGlwcGluZ19j'
    'b3N0GAYgASgJUgxzaGlwcGluZ0Nvc3Q=');

@$core.Deprecated('Use seedingServiceMarkShippedResponseDescriptor instead')
const SeedingServiceMarkShippedResponse$json = {
  '1': 'SeedingServiceMarkShippedResponse',
  '2': [
    {
      '1': 'sample_request',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.commerce.v1.SampleRequest',
      '10': 'sampleRequest'
    },
    {
      '1': 'shipment',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.creativanta.commerce.v1.SampleShipment',
      '10': 'shipment'
    },
  ],
};

/// Descriptor for `SeedingServiceMarkShippedResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List seedingServiceMarkShippedResponseDescriptor =
    $convert.base64Decode(
        'CiFTZWVkaW5nU2VydmljZU1hcmtTaGlwcGVkUmVzcG9uc2USTQoOc2FtcGxlX3JlcXVlc3QYAS'
        'ABKAsyJi5jcmVhdGl2YW50YS5jb21tZXJjZS52MS5TYW1wbGVSZXF1ZXN0Ug1zYW1wbGVSZXF1'
        'ZXN0EkMKCHNoaXBtZW50GAIgASgLMicuY3JlYXRpdmFudGEuY29tbWVyY2UudjEuU2FtcGxlU2'
        'hpcG1lbnRSCHNoaXBtZW50');

@$core.Deprecated('Use seedingServiceSendReminderRequestDescriptor instead')
const SeedingServiceSendReminderRequest$json = {
  '1': 'SeedingServiceSendReminderRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'request_id', '3': 2, '4': 1, '5': 9, '10': 'requestId'},
    {'1': 'message', '3': 3, '4': 1, '5': 9, '10': 'message'},
  ],
};

/// Descriptor for `SeedingServiceSendReminderRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List seedingServiceSendReminderRequestDescriptor =
    $convert.base64Decode(
        'CiFTZWVkaW5nU2VydmljZVNlbmRSZW1pbmRlclJlcXVlc3QSIQoMd29ya3NwYWNlX2lkGAEgAS'
        'gJUgt3b3Jrc3BhY2VJZBIdCgpyZXF1ZXN0X2lkGAIgASgJUglyZXF1ZXN0SWQSGAoHbWVzc2Fn'
        'ZRgDIAEoCVIHbWVzc2FnZQ==');

@$core.Deprecated('Use seedingServiceSendReminderResponseDescriptor instead')
const SeedingServiceSendReminderResponse$json = {
  '1': 'SeedingServiceSendReminderResponse',
  '2': [
    {'1': 'request_id', '3': 1, '4': 1, '5': 9, '10': 'requestId'},
    {
      '1': 'follow_up_status',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.creativanta.commerce.v1.FollowUpStatus',
      '10': 'followUpStatus'
    },
    {
      '1': 'reminder_sent_at',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'reminderSentAt'
    },
  ],
};

/// Descriptor for `SeedingServiceSendReminderResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List seedingServiceSendReminderResponseDescriptor =
    $convert.base64Decode(
        'CiJTZWVkaW5nU2VydmljZVNlbmRSZW1pbmRlclJlc3BvbnNlEh0KCnJlcXVlc3RfaWQYASABKA'
        'lSCXJlcXVlc3RJZBJRChBmb2xsb3dfdXBfc3RhdHVzGAIgASgOMicuY3JlYXRpdmFudGEuY29t'
        'bWVyY2UudjEuRm9sbG93VXBTdGF0dXNSDmZvbGxvd1VwU3RhdHVzEkQKEHJlbWluZGVyX3Nlbn'
        'RfYXQYAyABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUg5yZW1pbmRlclNlbnRBdA==');

@$core.Deprecated('Use seedingServiceUpdateStatusRequestDescriptor instead')
const SeedingServiceUpdateStatusRequest$json = {
  '1': 'SeedingServiceUpdateStatusRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'request_id', '3': 2, '4': 1, '5': 9, '10': 'requestId'},
    {
      '1': 'new_status',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.creativanta.commerce.v1.SampleRequestStatus',
      '10': 'newStatus'
    },
    {'1': 'notes', '3': 4, '4': 1, '5': 9, '10': 'notes'},
  ],
};

/// Descriptor for `SeedingServiceUpdateStatusRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List seedingServiceUpdateStatusRequestDescriptor =
    $convert.base64Decode(
        'CiFTZWVkaW5nU2VydmljZVVwZGF0ZVN0YXR1c1JlcXVlc3QSIQoMd29ya3NwYWNlX2lkGAEgAS'
        'gJUgt3b3Jrc3BhY2VJZBIdCgpyZXF1ZXN0X2lkGAIgASgJUglyZXF1ZXN0SWQSSwoKbmV3X3N0'
        'YXR1cxgDIAEoDjIsLmNyZWF0aXZhbnRhLmNvbW1lcmNlLnYxLlNhbXBsZVJlcXVlc3RTdGF0dX'
        'NSCW5ld1N0YXR1cxIUCgVub3RlcxgEIAEoCVIFbm90ZXM=');

@$core.Deprecated('Use seedingServiceUpdateStatusResponseDescriptor instead')
const SeedingServiceUpdateStatusResponse$json = {
  '1': 'SeedingServiceUpdateStatusResponse',
  '2': [
    {
      '1': 'sample_request',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.commerce.v1.SampleRequest',
      '10': 'sampleRequest'
    },
  ],
};

/// Descriptor for `SeedingServiceUpdateStatusResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List seedingServiceUpdateStatusResponseDescriptor =
    $convert.base64Decode(
        'CiJTZWVkaW5nU2VydmljZVVwZGF0ZVN0YXR1c1Jlc3BvbnNlEk0KDnNhbXBsZV9yZXF1ZXN0GA'
        'EgASgLMiYuY3JlYXRpdmFudGEuY29tbWVyY2UudjEuU2FtcGxlUmVxdWVzdFINc2FtcGxlUmVx'
        'dWVzdA==');

@$core.Deprecated('Use seedingServiceDuplicateRequestDescriptor instead')
const SeedingServiceDuplicateRequest$json = {
  '1': 'SeedingServiceDuplicateRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'request_id', '3': 2, '4': 1, '5': 9, '10': 'requestId'},
  ],
};

/// Descriptor for `SeedingServiceDuplicateRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List seedingServiceDuplicateRequestDescriptor =
    $convert.base64Decode(
        'Ch5TZWVkaW5nU2VydmljZUR1cGxpY2F0ZVJlcXVlc3QSIQoMd29ya3NwYWNlX2lkGAEgASgJUg'
        't3b3Jrc3BhY2VJZBIdCgpyZXF1ZXN0X2lkGAIgASgJUglyZXF1ZXN0SWQ=');

@$core.Deprecated('Use seedingServiceDuplicateResponseDescriptor instead')
const SeedingServiceDuplicateResponse$json = {
  '1': 'SeedingServiceDuplicateResponse',
  '2': [
    {
      '1': 'new_request',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.commerce.v1.SampleRequest',
      '10': 'newRequest'
    },
  ],
};

/// Descriptor for `SeedingServiceDuplicateResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List seedingServiceDuplicateResponseDescriptor =
    $convert.base64Decode(
        'Ch9TZWVkaW5nU2VydmljZUR1cGxpY2F0ZVJlc3BvbnNlEkcKC25ld19yZXF1ZXN0GAEgASgLMi'
        'YuY3JlYXRpdmFudGEuY29tbWVyY2UudjEuU2FtcGxlUmVxdWVzdFIKbmV3UmVxdWVzdA==');

@$core
    .Deprecated('Use seedingServiceDuplicateCampaignRequestDescriptor instead')
const SeedingServiceDuplicateCampaignRequest$json = {
  '1': 'SeedingServiceDuplicateCampaignRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'campaign_id', '3': 2, '4': 1, '5': 9, '10': 'campaignId'},
  ],
};

/// Descriptor for `SeedingServiceDuplicateCampaignRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List seedingServiceDuplicateCampaignRequestDescriptor =
    $convert.base64Decode(
        'CiZTZWVkaW5nU2VydmljZUR1cGxpY2F0ZUNhbXBhaWduUmVxdWVzdBIhCgx3b3Jrc3BhY2VfaW'
        'QYASABKAlSC3dvcmtzcGFjZUlkEh8KC2NhbXBhaWduX2lkGAIgASgJUgpjYW1wYWlnbklk');

@$core
    .Deprecated('Use seedingServiceDuplicateCampaignResponseDescriptor instead')
const SeedingServiceDuplicateCampaignResponse$json = {
  '1': 'SeedingServiceDuplicateCampaignResponse',
  '2': [
    {
      '1': 'new_campaign',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.commerce.v1.SeedingCampaign',
      '10': 'newCampaign'
    },
  ],
};

/// Descriptor for `SeedingServiceDuplicateCampaignResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List seedingServiceDuplicateCampaignResponseDescriptor =
    $convert.base64Decode(
        'CidTZWVkaW5nU2VydmljZUR1cGxpY2F0ZUNhbXBhaWduUmVzcG9uc2USSwoMbmV3X2NhbXBhaW'
        'duGAEgASgLMiguY3JlYXRpdmFudGEuY29tbWVyY2UudjEuU2VlZGluZ0NhbXBhaWduUgtuZXdD'
        'YW1wYWlnbg==');

@$core.Deprecated('Use seedingServiceLaunchRequestDescriptor instead')
const SeedingServiceLaunchRequest$json = {
  '1': 'SeedingServiceLaunchRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'campaign_id', '3': 2, '4': 1, '5': 9, '10': 'campaignId'},
  ],
};

/// Descriptor for `SeedingServiceLaunchRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List seedingServiceLaunchRequestDescriptor =
    $convert.base64Decode(
        'ChtTZWVkaW5nU2VydmljZUxhdW5jaFJlcXVlc3QSIQoMd29ya3NwYWNlX2lkGAEgASgJUgt3b3'
        'Jrc3BhY2VJZBIfCgtjYW1wYWlnbl9pZBgCIAEoCVIKY2FtcGFpZ25JZA==');

@$core.Deprecated('Use seedingServiceLaunchResponseDescriptor instead')
const SeedingServiceLaunchResponse$json = {
  '1': 'SeedingServiceLaunchResponse',
  '2': [
    {
      '1': 'campaign',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.commerce.v1.SeedingCampaign',
      '10': 'campaign'
    },
  ],
};

/// Descriptor for `SeedingServiceLaunchResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List seedingServiceLaunchResponseDescriptor =
    $convert.base64Decode(
        'ChxTZWVkaW5nU2VydmljZUxhdW5jaFJlc3BvbnNlEkQKCGNhbXBhaWduGAEgASgLMiguY3JlYX'
        'RpdmFudGEuY29tbWVyY2UudjEuU2VlZGluZ0NhbXBhaWduUghjYW1wYWlnbg==');

@$core.Deprecated('Use seedingServiceLinkContentRequestDescriptor instead')
const SeedingServiceLinkContentRequest$json = {
  '1': 'SeedingServiceLinkContentRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'request_id', '3': 2, '4': 1, '5': 9, '10': 'requestId'},
    {'1': 'content_url', '3': 3, '4': 1, '5': 9, '10': 'contentUrl'},
    {'1': 'content_type', '3': 4, '4': 1, '5': 9, '10': 'contentType'},
    {'1': 'publish_item_id', '3': 5, '4': 1, '5': 9, '10': 'publishItemId'},
    {'1': 'impressions', '3': 6, '4': 1, '5': 3, '10': 'impressions'},
    {'1': 'views', '3': 7, '4': 1, '5': 3, '10': 'views'},
    {'1': 'engagements', '3': 8, '4': 1, '5': 3, '10': 'engagements'},
    {
      '1': 'conversions_count',
      '3': 9,
      '4': 1,
      '5': 3,
      '10': 'conversionsCount'
    },
    {
      '1': 'attributable_revenue',
      '3': 10,
      '4': 1,
      '5': 9,
      '10': 'attributableRevenue'
    },
    {'1': 'currency', '3': 11, '4': 1, '5': 9, '10': 'currency'},
    {
      '1': 'source_class',
      '3': 12,
      '4': 1,
      '5': 14,
      '6': '.creativanta.commerce.v1.SeedingSourceClass',
      '10': 'sourceClass'
    },
    {
      '1': 'confidence_level',
      '3': 13,
      '4': 1,
      '5': 14,
      '6': '.creativanta.commerce.v1.SeedingConfidenceLevel',
      '10': 'confidenceLevel'
    },
    {
      '1': 'confidence_reason',
      '3': 14,
      '4': 1,
      '5': 9,
      '10': 'confidenceReason'
    },
    {'1': 'notes', '3': 15, '4': 1, '5': 9, '10': 'notes'},
  ],
};

/// Descriptor for `SeedingServiceLinkContentRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List seedingServiceLinkContentRequestDescriptor = $convert.base64Decode(
    'CiBTZWVkaW5nU2VydmljZUxpbmtDb250ZW50UmVxdWVzdBIhCgx3b3Jrc3BhY2VfaWQYASABKA'
    'lSC3dvcmtzcGFjZUlkEh0KCnJlcXVlc3RfaWQYAiABKAlSCXJlcXVlc3RJZBIfCgtjb250ZW50'
    'X3VybBgDIAEoCVIKY29udGVudFVybBIhCgxjb250ZW50X3R5cGUYBCABKAlSC2NvbnRlbnRUeX'
    'BlEiYKD3B1Ymxpc2hfaXRlbV9pZBgFIAEoCVINcHVibGlzaEl0ZW1JZBIgCgtpbXByZXNzaW9u'
    'cxgGIAEoA1ILaW1wcmVzc2lvbnMSFAoFdmlld3MYByABKANSBXZpZXdzEiAKC2VuZ2FnZW1lbn'
    'RzGAggASgDUgtlbmdhZ2VtZW50cxIrChFjb252ZXJzaW9uc19jb3VudBgJIAEoA1IQY29udmVy'
    'c2lvbnNDb3VudBIxChRhdHRyaWJ1dGFibGVfcmV2ZW51ZRgKIAEoCVITYXR0cmlidXRhYmxlUm'
    'V2ZW51ZRIaCghjdXJyZW5jeRgLIAEoCVIIY3VycmVuY3kSTgoMc291cmNlX2NsYXNzGAwgASgO'
    'MisuY3JlYXRpdmFudGEuY29tbWVyY2UudjEuU2VlZGluZ1NvdXJjZUNsYXNzUgtzb3VyY2VDbG'
    'FzcxJaChBjb25maWRlbmNlX2xldmVsGA0gASgOMi8uY3JlYXRpdmFudGEuY29tbWVyY2UudjEu'
    'U2VlZGluZ0NvbmZpZGVuY2VMZXZlbFIPY29uZmlkZW5jZUxldmVsEisKEWNvbmZpZGVuY2Vfcm'
    'Vhc29uGA4gASgJUhBjb25maWRlbmNlUmVhc29uEhQKBW5vdGVzGA8gASgJUgVub3Rlcw==');

@$core.Deprecated('Use seedingServiceLinkContentResponseDescriptor instead')
const SeedingServiceLinkContentResponse$json = {
  '1': 'SeedingServiceLinkContentResponse',
  '2': [
    {
      '1': 'sample_request',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.commerce.v1.SampleRequest',
      '10': 'sampleRequest'
    },
    {
      '1': 'outcome',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.creativanta.commerce.v1.SampleOutcome',
      '10': 'outcome'
    },
  ],
};

/// Descriptor for `SeedingServiceLinkContentResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List seedingServiceLinkContentResponseDescriptor =
    $convert.base64Decode(
        'CiFTZWVkaW5nU2VydmljZUxpbmtDb250ZW50UmVzcG9uc2USTQoOc2FtcGxlX3JlcXVlc3QYAS'
        'ABKAsyJi5jcmVhdGl2YW50YS5jb21tZXJjZS52MS5TYW1wbGVSZXF1ZXN0Ug1zYW1wbGVSZXF1'
        'ZXN0EkAKB291dGNvbWUYAiABKAsyJi5jcmVhdGl2YW50YS5jb21tZXJjZS52MS5TYW1wbGVPdX'
        'Rjb21lUgdvdXRjb21l');

@$core.Deprecated('Use sampleServiceCreateRequestDescriptor instead')
const SampleServiceCreateRequest$json = {
  '1': 'SampleServiceCreateRequest',
  '2': [
    {'1': 'idempotency_key', '3': 1, '4': 1, '5': 9, '10': 'idempotencyKey'},
    {'1': 'workspace_id', '3': 2, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'campaign_id', '3': 3, '4': 1, '5': 9, '10': 'campaignId'},
    {'1': 'product_id', '3': 4, '4': 1, '5': 9, '10': 'productId'},
    {'1': 'creator_entity_id', '3': 5, '4': 1, '5': 9, '10': 'creatorEntityId'},
    {'1': 'quantity', '3': 6, '4': 1, '5': 5, '10': 'quantity'},
    {
      '1': 'shipping_address',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.creativanta.commerce.v1.ShippingAddress',
      '10': 'shippingAddress'
    },
    {
      '1': 'content_requirements',
      '3': 8,
      '4': 1,
      '5': 9,
      '10': 'contentRequirements'
    },
    {'1': 'deadline', '3': 9, '4': 1, '5': 9, '10': 'deadline'},
    {'1': 'notes', '3': 10, '4': 1, '5': 9, '10': 'notes'},
  ],
};

/// Descriptor for `SampleServiceCreateRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List sampleServiceCreateRequestDescriptor = $convert.base64Decode(
    'ChpTYW1wbGVTZXJ2aWNlQ3JlYXRlUmVxdWVzdBInCg9pZGVtcG90ZW5jeV9rZXkYASABKAlSDm'
    'lkZW1wb3RlbmN5S2V5EiEKDHdvcmtzcGFjZV9pZBgCIAEoCVILd29ya3NwYWNlSWQSHwoLY2Ft'
    'cGFpZ25faWQYAyABKAlSCmNhbXBhaWduSWQSHQoKcHJvZHVjdF9pZBgEIAEoCVIJcHJvZHVjdE'
    'lkEioKEWNyZWF0b3JfZW50aXR5X2lkGAUgASgJUg9jcmVhdG9yRW50aXR5SWQSGgoIcXVhbnRp'
    'dHkYBiABKAVSCHF1YW50aXR5ElMKEHNoaXBwaW5nX2FkZHJlc3MYByABKAsyKC5jcmVhdGl2YW'
    '50YS5jb21tZXJjZS52MS5TaGlwcGluZ0FkZHJlc3NSD3NoaXBwaW5nQWRkcmVzcxIxChRjb250'
    'ZW50X3JlcXVpcmVtZW50cxgIIAEoCVITY29udGVudFJlcXVpcmVtZW50cxIaCghkZWFkbGluZR'
    'gJIAEoCVIIZGVhZGxpbmUSFAoFbm90ZXMYCiABKAlSBW5vdGVz');

@$core.Deprecated('Use sampleServiceCreateResponseDescriptor instead')
const SampleServiceCreateResponse$json = {
  '1': 'SampleServiceCreateResponse',
  '2': [
    {
      '1': 'sample_request',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.commerce.v1.SampleRequest',
      '10': 'sampleRequest'
    },
  ],
};

/// Descriptor for `SampleServiceCreateResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List sampleServiceCreateResponseDescriptor =
    $convert.base64Decode(
        'ChtTYW1wbGVTZXJ2aWNlQ3JlYXRlUmVzcG9uc2USTQoOc2FtcGxlX3JlcXVlc3QYASABKAsyJi'
        '5jcmVhdGl2YW50YS5jb21tZXJjZS52MS5TYW1wbGVSZXF1ZXN0Ug1zYW1wbGVSZXF1ZXN0');

@$core.Deprecated('Use sampleServiceListRequestDescriptor instead')
const SampleServiceListRequest$json = {
  '1': 'SampleServiceListRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'campaign_id', '3': 2, '4': 1, '5': 9, '10': 'campaignId'},
    {'1': 'limit', '3': 3, '4': 1, '5': 5, '10': 'limit'},
    {'1': 'offset', '3': 4, '4': 1, '5': 5, '10': 'offset'},
  ],
};

/// Descriptor for `SampleServiceListRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List sampleServiceListRequestDescriptor = $convert.base64Decode(
    'ChhTYW1wbGVTZXJ2aWNlTGlzdFJlcXVlc3QSIQoMd29ya3NwYWNlX2lkGAEgASgJUgt3b3Jrc3'
    'BhY2VJZBIfCgtjYW1wYWlnbl9pZBgCIAEoCVIKY2FtcGFpZ25JZBIUCgVsaW1pdBgDIAEoBVIF'
    'bGltaXQSFgoGb2Zmc2V0GAQgASgFUgZvZmZzZXQ=');

@$core.Deprecated('Use sampleServiceListResponseDescriptor instead')
const SampleServiceListResponse$json = {
  '1': 'SampleServiceListResponse',
  '2': [
    {
      '1': 'sample_requests',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.creativanta.commerce.v1.SampleRequest',
      '10': 'sampleRequests'
    },
    {'1': 'total_count', '3': 2, '4': 1, '5': 3, '10': 'totalCount'},
  ],
};

/// Descriptor for `SampleServiceListResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List sampleServiceListResponseDescriptor = $convert.base64Decode(
    'ChlTYW1wbGVTZXJ2aWNlTGlzdFJlc3BvbnNlEk8KD3NhbXBsZV9yZXF1ZXN0cxgBIAMoCzImLm'
    'NyZWF0aXZhbnRhLmNvbW1lcmNlLnYxLlNhbXBsZVJlcXVlc3RSDnNhbXBsZVJlcXVlc3RzEh8K'
    'C3RvdGFsX2NvdW50GAIgASgDUgp0b3RhbENvdW50');

@$core.Deprecated('Use sampleServiceApproveRequestDescriptor instead')
const SampleServiceApproveRequest$json = {
  '1': 'SampleServiceApproveRequest',
  '2': [
    {'1': 'idempotency_key', '3': 1, '4': 1, '5': 9, '10': 'idempotencyKey'},
    {'1': 'workspace_id', '3': 2, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'request_id', '3': 3, '4': 1, '5': 9, '10': 'requestId'},
  ],
};

/// Descriptor for `SampleServiceApproveRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List sampleServiceApproveRequestDescriptor =
    $convert.base64Decode(
        'ChtTYW1wbGVTZXJ2aWNlQXBwcm92ZVJlcXVlc3QSJwoPaWRlbXBvdGVuY3lfa2V5GAEgASgJUg'
        '5pZGVtcG90ZW5jeUtleRIhCgx3b3Jrc3BhY2VfaWQYAiABKAlSC3dvcmtzcGFjZUlkEh0KCnJl'
        'cXVlc3RfaWQYAyABKAlSCXJlcXVlc3RJZA==');

@$core.Deprecated('Use sampleServiceApproveResponseDescriptor instead')
const SampleServiceApproveResponse$json = {
  '1': 'SampleServiceApproveResponse',
  '2': [
    {
      '1': 'sample_request',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.commerce.v1.SampleRequest',
      '10': 'sampleRequest'
    },
  ],
};

/// Descriptor for `SampleServiceApproveResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List sampleServiceApproveResponseDescriptor =
    $convert.base64Decode(
        'ChxTYW1wbGVTZXJ2aWNlQXBwcm92ZVJlc3BvbnNlEk0KDnNhbXBsZV9yZXF1ZXN0GAEgASgLMi'
        'YuY3JlYXRpdmFudGEuY29tbWVyY2UudjEuU2FtcGxlUmVxdWVzdFINc2FtcGxlUmVxdWVzdA==');

@$core.Deprecated('Use sampleServiceDeclineRequestDescriptor instead')
const SampleServiceDeclineRequest$json = {
  '1': 'SampleServiceDeclineRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'request_id', '3': 2, '4': 1, '5': 9, '10': 'requestId'},
    {'1': 'reason', '3': 3, '4': 1, '5': 9, '10': 'reason'},
  ],
};

/// Descriptor for `SampleServiceDeclineRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List sampleServiceDeclineRequestDescriptor =
    $convert.base64Decode(
        'ChtTYW1wbGVTZXJ2aWNlRGVjbGluZVJlcXVlc3QSIQoMd29ya3NwYWNlX2lkGAEgASgJUgt3b3'
        'Jrc3BhY2VJZBIdCgpyZXF1ZXN0X2lkGAIgASgJUglyZXF1ZXN0SWQSFgoGcmVhc29uGAMgASgJ'
        'UgZyZWFzb24=');

@$core.Deprecated('Use sampleServiceDeclineResponseDescriptor instead')
const SampleServiceDeclineResponse$json = {
  '1': 'SampleServiceDeclineResponse',
  '2': [
    {
      '1': 'sample_request',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.commerce.v1.SampleRequest',
      '10': 'sampleRequest'
    },
  ],
};

/// Descriptor for `SampleServiceDeclineResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List sampleServiceDeclineResponseDescriptor =
    $convert.base64Decode(
        'ChxTYW1wbGVTZXJ2aWNlRGVjbGluZVJlc3BvbnNlEk0KDnNhbXBsZV9yZXF1ZXN0GAEgASgLMi'
        'YuY3JlYXRpdmFudGEuY29tbWVyY2UudjEuU2FtcGxlUmVxdWVzdFINc2FtcGxlUmVxdWVzdA==');

@$core.Deprecated('Use sampleServiceCancelRequestDescriptor instead')
const SampleServiceCancelRequest$json = {
  '1': 'SampleServiceCancelRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'request_id', '3': 2, '4': 1, '5': 9, '10': 'requestId'},
    {'1': 'reason', '3': 3, '4': 1, '5': 9, '10': 'reason'},
  ],
};

/// Descriptor for `SampleServiceCancelRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List sampleServiceCancelRequestDescriptor =
    $convert.base64Decode(
        'ChpTYW1wbGVTZXJ2aWNlQ2FuY2VsUmVxdWVzdBIhCgx3b3Jrc3BhY2VfaWQYASABKAlSC3dvcm'
        'tzcGFjZUlkEh0KCnJlcXVlc3RfaWQYAiABKAlSCXJlcXVlc3RJZBIWCgZyZWFzb24YAyABKAlS'
        'BnJlYXNvbg==');

@$core.Deprecated('Use sampleServiceCancelResponseDescriptor instead')
const SampleServiceCancelResponse$json = {
  '1': 'SampleServiceCancelResponse',
  '2': [
    {
      '1': 'sample_request',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.commerce.v1.SampleRequest',
      '10': 'sampleRequest'
    },
  ],
};

/// Descriptor for `SampleServiceCancelResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List sampleServiceCancelResponseDescriptor =
    $convert.base64Decode(
        'ChtTYW1wbGVTZXJ2aWNlQ2FuY2VsUmVzcG9uc2USTQoOc2FtcGxlX3JlcXVlc3QYASABKAsyJi'
        '5jcmVhdGl2YW50YS5jb21tZXJjZS52MS5TYW1wbGVSZXF1ZXN0Ug1zYW1wbGVSZXF1ZXN0');

@$core.Deprecated('Use sampleServiceMarkShippedRequestDescriptor instead')
const SampleServiceMarkShippedRequest$json = {
  '1': 'SampleServiceMarkShippedRequest',
  '2': [
    {'1': 'idempotency_key', '3': 1, '4': 1, '5': 9, '10': 'idempotencyKey'},
    {'1': 'workspace_id', '3': 2, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'request_id', '3': 3, '4': 1, '5': 9, '10': 'requestId'},
    {'1': 'carrier', '3': 4, '4': 1, '5': 9, '10': 'carrier'},
    {'1': 'tracking_number', '3': 5, '4': 1, '5': 9, '10': 'trackingNumber'},
    {'1': 'shipping_cost', '3': 6, '4': 1, '5': 9, '10': 'shippingCost'},
  ],
};

/// Descriptor for `SampleServiceMarkShippedRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List sampleServiceMarkShippedRequestDescriptor = $convert.base64Decode(
    'Ch9TYW1wbGVTZXJ2aWNlTWFya1NoaXBwZWRSZXF1ZXN0EicKD2lkZW1wb3RlbmN5X2tleRgBIA'
    'EoCVIOaWRlbXBvdGVuY3lLZXkSIQoMd29ya3NwYWNlX2lkGAIgASgJUgt3b3Jrc3BhY2VJZBId'
    'CgpyZXF1ZXN0X2lkGAMgASgJUglyZXF1ZXN0SWQSGAoHY2FycmllchgEIAEoCVIHY2Fycmllch'
    'InCg90cmFja2luZ19udW1iZXIYBSABKAlSDnRyYWNraW5nTnVtYmVyEiMKDXNoaXBwaW5nX2Nv'
    'c3QYBiABKAlSDHNoaXBwaW5nQ29zdA==');

@$core.Deprecated('Use sampleServiceMarkShippedResponseDescriptor instead')
const SampleServiceMarkShippedResponse$json = {
  '1': 'SampleServiceMarkShippedResponse',
  '2': [
    {
      '1': 'sample_request',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.commerce.v1.SampleRequest',
      '10': 'sampleRequest'
    },
    {
      '1': 'shipment',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.creativanta.commerce.v1.SampleShipment',
      '10': 'shipment'
    },
  ],
};

/// Descriptor for `SampleServiceMarkShippedResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List sampleServiceMarkShippedResponseDescriptor =
    $convert.base64Decode(
        'CiBTYW1wbGVTZXJ2aWNlTWFya1NoaXBwZWRSZXNwb25zZRJNCg5zYW1wbGVfcmVxdWVzdBgBIA'
        'EoCzImLmNyZWF0aXZhbnRhLmNvbW1lcmNlLnYxLlNhbXBsZVJlcXVlc3RSDXNhbXBsZVJlcXVl'
        'c3QSQwoIc2hpcG1lbnQYAiABKAsyJy5jcmVhdGl2YW50YS5jb21tZXJjZS52MS5TYW1wbGVTaG'
        'lwbWVudFIIc2hpcG1lbnQ=');

@$core.Deprecated('Use sampleServiceMarkReceivedRequestDescriptor instead')
const SampleServiceMarkReceivedRequest$json = {
  '1': 'SampleServiceMarkReceivedRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'request_id', '3': 2, '4': 1, '5': 9, '10': 'requestId'},
  ],
};

/// Descriptor for `SampleServiceMarkReceivedRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List sampleServiceMarkReceivedRequestDescriptor =
    $convert.base64Decode(
        'CiBTYW1wbGVTZXJ2aWNlTWFya1JlY2VpdmVkUmVxdWVzdBIhCgx3b3Jrc3BhY2VfaWQYASABKA'
        'lSC3dvcmtzcGFjZUlkEh0KCnJlcXVlc3RfaWQYAiABKAlSCXJlcXVlc3RJZA==');

@$core.Deprecated('Use sampleServiceMarkReceivedResponseDescriptor instead')
const SampleServiceMarkReceivedResponse$json = {
  '1': 'SampleServiceMarkReceivedResponse',
  '2': [
    {
      '1': 'sample_request',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.commerce.v1.SampleRequest',
      '10': 'sampleRequest'
    },
    {
      '1': 'shipment',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.creativanta.commerce.v1.SampleShipment',
      '10': 'shipment'
    },
  ],
};

/// Descriptor for `SampleServiceMarkReceivedResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List sampleServiceMarkReceivedResponseDescriptor =
    $convert.base64Decode(
        'CiFTYW1wbGVTZXJ2aWNlTWFya1JlY2VpdmVkUmVzcG9uc2USTQoOc2FtcGxlX3JlcXVlc3QYAS'
        'ABKAsyJi5jcmVhdGl2YW50YS5jb21tZXJjZS52MS5TYW1wbGVSZXF1ZXN0Ug1zYW1wbGVSZXF1'
        'ZXN0EkMKCHNoaXBtZW50GAIgASgLMicuY3JlYXRpdmFudGEuY29tbWVyY2UudjEuU2FtcGxlU2'
        'hpcG1lbnRSCHNoaXBtZW50');

@$core.Deprecated('Use sampleServiceUpdateStatusRequestDescriptor instead')
const SampleServiceUpdateStatusRequest$json = {
  '1': 'SampleServiceUpdateStatusRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'request_id', '3': 2, '4': 1, '5': 9, '10': 'requestId'},
    {
      '1': 'new_status',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.creativanta.commerce.v1.SampleRequestStatus',
      '10': 'newStatus'
    },
    {'1': 'notes', '3': 4, '4': 1, '5': 9, '10': 'notes'},
  ],
};

/// Descriptor for `SampleServiceUpdateStatusRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List sampleServiceUpdateStatusRequestDescriptor =
    $convert.base64Decode(
        'CiBTYW1wbGVTZXJ2aWNlVXBkYXRlU3RhdHVzUmVxdWVzdBIhCgx3b3Jrc3BhY2VfaWQYASABKA'
        'lSC3dvcmtzcGFjZUlkEh0KCnJlcXVlc3RfaWQYAiABKAlSCXJlcXVlc3RJZBJLCgpuZXdfc3Rh'
        'dHVzGAMgASgOMiwuY3JlYXRpdmFudGEuY29tbWVyY2UudjEuU2FtcGxlUmVxdWVzdFN0YXR1c1'
        'IJbmV3U3RhdHVzEhQKBW5vdGVzGAQgASgJUgVub3Rlcw==');

@$core.Deprecated('Use sampleServiceUpdateStatusResponseDescriptor instead')
const SampleServiceUpdateStatusResponse$json = {
  '1': 'SampleServiceUpdateStatusResponse',
  '2': [
    {
      '1': 'sample_request',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.commerce.v1.SampleRequest',
      '10': 'sampleRequest'
    },
  ],
};

/// Descriptor for `SampleServiceUpdateStatusResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List sampleServiceUpdateStatusResponseDescriptor =
    $convert.base64Decode(
        'CiFTYW1wbGVTZXJ2aWNlVXBkYXRlU3RhdHVzUmVzcG9uc2USTQoOc2FtcGxlX3JlcXVlc3QYAS'
        'ABKAsyJi5jcmVhdGl2YW50YS5jb21tZXJjZS52MS5TYW1wbGVSZXF1ZXN0Ug1zYW1wbGVSZXF1'
        'ZXN0');

@$core.Deprecated('Use sampleServiceGetSummaryRequestDescriptor instead')
const SampleServiceGetSummaryRequest$json = {
  '1': 'SampleServiceGetSummaryRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'campaign_id', '3': 2, '4': 1, '5': 9, '10': 'campaignId'},
  ],
};

/// Descriptor for `SampleServiceGetSummaryRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List sampleServiceGetSummaryRequestDescriptor =
    $convert.base64Decode(
        'Ch5TYW1wbGVTZXJ2aWNlR2V0U3VtbWFyeVJlcXVlc3QSIQoMd29ya3NwYWNlX2lkGAEgASgJUg'
        't3b3Jrc3BhY2VJZBIfCgtjYW1wYWlnbl9pZBgCIAEoCVIKY2FtcGFpZ25JZA==');

@$core.Deprecated('Use sampleServiceGetSummaryResponseDescriptor instead')
const SampleServiceGetSummaryResponse$json = {
  '1': 'SampleServiceGetSummaryResponse',
  '2': [
    {
      '1': 'report',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.commerce.v1.SeedingReport',
      '10': 'report'
    },
  ],
};

/// Descriptor for `SampleServiceGetSummaryResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List sampleServiceGetSummaryResponseDescriptor =
    $convert.base64Decode(
        'Ch9TYW1wbGVTZXJ2aWNlR2V0U3VtbWFyeVJlc3BvbnNlEj4KBnJlcG9ydBgBIAEoCzImLmNyZW'
        'F0aXZhbnRhLmNvbW1lcmNlLnYxLlNlZWRpbmdSZXBvcnRSBnJlcG9ydA==');

@$core.Deprecated('Use sampleServiceGetStatsRequestDescriptor instead')
const SampleServiceGetStatsRequest$json = {
  '1': 'SampleServiceGetStatsRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'campaign_id', '3': 2, '4': 1, '5': 9, '10': 'campaignId'},
  ],
};

/// Descriptor for `SampleServiceGetStatsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List sampleServiceGetStatsRequestDescriptor =
    $convert.base64Decode(
        'ChxTYW1wbGVTZXJ2aWNlR2V0U3RhdHNSZXF1ZXN0EiEKDHdvcmtzcGFjZV9pZBgBIAEoCVILd2'
        '9ya3NwYWNlSWQSHwoLY2FtcGFpZ25faWQYAiABKAlSCmNhbXBhaWduSWQ=');

@$core.Deprecated('Use sampleServiceGetStatsResponseDescriptor instead')
const SampleServiceGetStatsResponse$json = {
  '1': 'SampleServiceGetStatsResponse',
  '2': [
    {'1': 'requested_count', '3': 1, '4': 1, '5': 5, '10': 'requestedCount'},
    {'1': 'approved_count', '3': 2, '4': 1, '5': 5, '10': 'approvedCount'},
    {'1': 'shipped_count', '3': 3, '4': 1, '5': 5, '10': 'shippedCount'},
    {'1': 'received_count', '3': 4, '4': 1, '5': 5, '10': 'receivedCount'},
    {
      '1': 'review_published_count',
      '3': 5,
      '4': 1,
      '5': 5,
      '10': 'reviewPublishedCount'
    },
    {'1': 'overdue_count', '3': 6, '4': 1, '5': 5, '10': 'overdueCount'},
    {'1': 'total_cost', '3': 7, '4': 1, '5': 9, '10': 'totalCost'},
    {'1': 'review_rate', '3': 8, '4': 1, '5': 9, '10': 'reviewRate'},
  ],
};

/// Descriptor for `SampleServiceGetStatsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List sampleServiceGetStatsResponseDescriptor = $convert.base64Decode(
    'Ch1TYW1wbGVTZXJ2aWNlR2V0U3RhdHNSZXNwb25zZRInCg9yZXF1ZXN0ZWRfY291bnQYASABKA'
    'VSDnJlcXVlc3RlZENvdW50EiUKDmFwcHJvdmVkX2NvdW50GAIgASgFUg1hcHByb3ZlZENvdW50'
    'EiMKDXNoaXBwZWRfY291bnQYAyABKAVSDHNoaXBwZWRDb3VudBIlCg5yZWNlaXZlZF9jb3VudB'
    'gEIAEoBVINcmVjZWl2ZWRDb3VudBI0ChZyZXZpZXdfcHVibGlzaGVkX2NvdW50GAUgASgFUhRy'
    'ZXZpZXdQdWJsaXNoZWRDb3VudBIjCg1vdmVyZHVlX2NvdW50GAYgASgFUgxvdmVyZHVlQ291bn'
    'QSHQoKdG90YWxfY29zdBgHIAEoCVIJdG90YWxDb3N0Eh8KC3Jldmlld19yYXRlGAggASgJUgpy'
    'ZXZpZXdSYXRl');

@$core.Deprecated('Use sampleServiceLinkReviewRequestDescriptor instead')
const SampleServiceLinkReviewRequest$json = {
  '1': 'SampleServiceLinkReviewRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'request_id', '3': 2, '4': 1, '5': 9, '10': 'requestId'},
    {'1': 'review_url', '3': 3, '4': 1, '5': 9, '10': 'reviewUrl'},
    {'1': 'platform', '3': 4, '4': 1, '5': 9, '10': 'platform'},
  ],
};

/// Descriptor for `SampleServiceLinkReviewRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List sampleServiceLinkReviewRequestDescriptor =
    $convert.base64Decode(
        'Ch5TYW1wbGVTZXJ2aWNlTGlua1Jldmlld1JlcXVlc3QSIQoMd29ya3NwYWNlX2lkGAEgASgJUg'
        't3b3Jrc3BhY2VJZBIdCgpyZXF1ZXN0X2lkGAIgASgJUglyZXF1ZXN0SWQSHQoKcmV2aWV3X3Vy'
        'bBgDIAEoCVIJcmV2aWV3VXJsEhoKCHBsYXRmb3JtGAQgASgJUghwbGF0Zm9ybQ==');

@$core.Deprecated('Use sampleServiceLinkReviewResponseDescriptor instead')
const SampleServiceLinkReviewResponse$json = {
  '1': 'SampleServiceLinkReviewResponse',
  '2': [
    {
      '1': 'sample_request',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.commerce.v1.SampleRequest',
      '10': 'sampleRequest'
    },
  ],
};

/// Descriptor for `SampleServiceLinkReviewResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List sampleServiceLinkReviewResponseDescriptor =
    $convert.base64Decode(
        'Ch9TYW1wbGVTZXJ2aWNlTGlua1Jldmlld1Jlc3BvbnNlEk0KDnNhbXBsZV9yZXF1ZXN0GAEgAS'
        'gLMiYuY3JlYXRpdmFudGEuY29tbWVyY2UudjEuU2FtcGxlUmVxdWVzdFINc2FtcGxlUmVxdWVz'
        'dA==');

@$core.Deprecated('Use sampleServiceRateCreatorRequestDescriptor instead')
const SampleServiceRateCreatorRequest$json = {
  '1': 'SampleServiceRateCreatorRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'creator_entity_id', '3': 2, '4': 1, '5': 9, '10': 'creatorEntityId'},
    {'1': 'rating', '3': 3, '4': 1, '5': 5, '10': 'rating'},
    {'1': 'feedback', '3': 4, '4': 1, '5': 9, '10': 'feedback'},
  ],
};

/// Descriptor for `SampleServiceRateCreatorRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List sampleServiceRateCreatorRequestDescriptor =
    $convert.base64Decode(
        'Ch9TYW1wbGVTZXJ2aWNlUmF0ZUNyZWF0b3JSZXF1ZXN0EiEKDHdvcmtzcGFjZV9pZBgBIAEoCV'
        'ILd29ya3NwYWNlSWQSKgoRY3JlYXRvcl9lbnRpdHlfaWQYAiABKAlSD2NyZWF0b3JFbnRpdHlJ'
        'ZBIWCgZyYXRpbmcYAyABKAVSBnJhdGluZxIaCghmZWVkYmFjaxgEIAEoCVIIZmVlZGJhY2s=');

@$core.Deprecated('Use sampleServiceRateCreatorResponseDescriptor instead')
const SampleServiceRateCreatorResponse$json = {
  '1': 'SampleServiceRateCreatorResponse',
  '2': [
    {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
  ],
};

/// Descriptor for `SampleServiceRateCreatorResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List sampleServiceRateCreatorResponseDescriptor =
    $convert.base64Decode(
        'CiBTYW1wbGVTZXJ2aWNlUmF0ZUNyZWF0b3JSZXNwb25zZRIYCgdzdWNjZXNzGAEgASgIUgdzdW'
        'NjZXNz');

@$core.Deprecated('Use sampleServiceGetReviewRevenueRequestDescriptor instead')
const SampleServiceGetReviewRevenueRequest$json = {
  '1': 'SampleServiceGetReviewRevenueRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'request_id', '3': 2, '4': 1, '5': 9, '10': 'requestId'},
  ],
};

/// Descriptor for `SampleServiceGetReviewRevenueRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List sampleServiceGetReviewRevenueRequestDescriptor =
    $convert.base64Decode(
        'CiRTYW1wbGVTZXJ2aWNlR2V0UmV2aWV3UmV2ZW51ZVJlcXVlc3QSIQoMd29ya3NwYWNlX2lkGA'
        'EgASgJUgt3b3Jrc3BhY2VJZBIdCgpyZXF1ZXN0X2lkGAIgASgJUglyZXF1ZXN0SWQ=');

@$core.Deprecated('Use sampleServiceGetReviewRevenueResponseDescriptor instead')
const SampleServiceGetReviewRevenueResponse$json = {
  '1': 'SampleServiceGetReviewRevenueResponse',
  '2': [
    {
      '1': 'attributable_revenue',
      '3': 1,
      '4': 1,
      '5': 9,
      '10': 'attributableRevenue'
    },
    {'1': 'currency', '3': 2, '4': 1, '5': 9, '10': 'currency'},
    {
      '1': 'source_class',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.creativanta.commerce.v1.SeedingSourceClass',
      '10': 'sourceClass'
    },
  ],
};

/// Descriptor for `SampleServiceGetReviewRevenueResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List sampleServiceGetReviewRevenueResponseDescriptor =
    $convert.base64Decode(
        'CiVTYW1wbGVTZXJ2aWNlR2V0UmV2aWV3UmV2ZW51ZVJlc3BvbnNlEjEKFGF0dHJpYnV0YWJsZV'
        '9yZXZlbnVlGAEgASgJUhNhdHRyaWJ1dGFibGVSZXZlbnVlEhoKCGN1cnJlbmN5GAIgASgJUghj'
        'dXJyZW5jeRJOCgxzb3VyY2VfY2xhc3MYAyABKA4yKy5jcmVhdGl2YW50YS5jb21tZXJjZS52MS'
        '5TZWVkaW5nU291cmNlQ2xhc3NSC3NvdXJjZUNsYXNz');

@$core.Deprecated('Use sampleServiceExtendDeadlineRequestDescriptor instead')
const SampleServiceExtendDeadlineRequest$json = {
  '1': 'SampleServiceExtendDeadlineRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'request_id', '3': 2, '4': 1, '5': 9, '10': 'requestId'},
    {'1': 'new_deadline', '3': 3, '4': 1, '5': 9, '10': 'newDeadline'},
    {'1': 'reason', '3': 4, '4': 1, '5': 9, '10': 'reason'},
  ],
};

/// Descriptor for `SampleServiceExtendDeadlineRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List sampleServiceExtendDeadlineRequestDescriptor =
    $convert.base64Decode(
        'CiJTYW1wbGVTZXJ2aWNlRXh0ZW5kRGVhZGxpbmVSZXF1ZXN0EiEKDHdvcmtzcGFjZV9pZBgBIA'
        'EoCVILd29ya3NwYWNlSWQSHQoKcmVxdWVzdF9pZBgCIAEoCVIJcmVxdWVzdElkEiEKDG5ld19k'
        'ZWFkbGluZRgDIAEoCVILbmV3RGVhZGxpbmUSFgoGcmVhc29uGAQgASgJUgZyZWFzb24=');

@$core.Deprecated('Use sampleServiceExtendDeadlineResponseDescriptor instead')
const SampleServiceExtendDeadlineResponse$json = {
  '1': 'SampleServiceExtendDeadlineResponse',
  '2': [
    {
      '1': 'sample_request',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.commerce.v1.SampleRequest',
      '10': 'sampleRequest'
    },
  ],
};

/// Descriptor for `SampleServiceExtendDeadlineResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List sampleServiceExtendDeadlineResponseDescriptor =
    $convert.base64Decode(
        'CiNTYW1wbGVTZXJ2aWNlRXh0ZW5kRGVhZGxpbmVSZXNwb25zZRJNCg5zYW1wbGVfcmVxdWVzdB'
        'gBIAEoCzImLmNyZWF0aXZhbnRhLmNvbW1lcmNlLnYxLlNhbXBsZVJlcXVlc3RSDXNhbXBsZVJl'
        'cXVlc3Q=');

@$core.Deprecated('Use sampleServiceExportReportRequestDescriptor instead')
const SampleServiceExportReportRequest$json = {
  '1': 'SampleServiceExportReportRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'campaign_id', '3': 2, '4': 1, '5': 9, '10': 'campaignId'},
    {'1': 'format', '3': 3, '4': 1, '5': 9, '10': 'format'},
  ],
};

/// Descriptor for `SampleServiceExportReportRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List sampleServiceExportReportRequestDescriptor =
    $convert.base64Decode(
        'CiBTYW1wbGVTZXJ2aWNlRXhwb3J0UmVwb3J0UmVxdWVzdBIhCgx3b3Jrc3BhY2VfaWQYASABKA'
        'lSC3dvcmtzcGFjZUlkEh8KC2NhbXBhaWduX2lkGAIgASgJUgpjYW1wYWlnbklkEhYKBmZvcm1h'
        'dBgDIAEoCVIGZm9ybWF0');

@$core.Deprecated('Use sampleServiceExportReportResponseDescriptor instead')
const SampleServiceExportReportResponse$json = {
  '1': 'SampleServiceExportReportResponse',
  '2': [
    {'1': 'file_url', '3': 1, '4': 1, '5': 9, '10': 'fileUrl'},
    {'1': 'content', '3': 2, '4': 1, '5': 9, '10': 'content'},
  ],
};

/// Descriptor for `SampleServiceExportReportResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List sampleServiceExportReportResponseDescriptor =
    $convert.base64Decode(
        'CiFTYW1wbGVTZXJ2aWNlRXhwb3J0UmVwb3J0UmVzcG9uc2USGQoIZmlsZV91cmwYASABKAlSB2'
        'ZpbGVVcmwSGAoHY29udGVudBgCIAEoCVIHY29udGVudA==');

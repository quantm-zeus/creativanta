// This is a generated file - do not edit.
//
// Generated from creativanta/commerce/v1/affiliate.proto.

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

@$core.Deprecated('Use affiliateLinkLifecycleStateDescriptor instead')
const AffiliateLinkLifecycleState$json = {
  '1': 'AffiliateLinkLifecycleState',
  '2': [
    {'1': 'AFFILIATE_LINK_LIFECYCLE_STATE_UNSPECIFIED', '2': 0},
    {'1': 'AFFILIATE_LINK_LIFECYCLE_STATE_DRAFT', '2': 1},
    {'1': 'AFFILIATE_LINK_LIFECYCLE_STATE_ACTIVE', '2': 2},
    {'1': 'AFFILIATE_LINK_LIFECYCLE_STATE_PAUSED', '2': 3},
    {'1': 'AFFILIATE_LINK_LIFECYCLE_STATE_REVOKED', '2': 4},
    {'1': 'AFFILIATE_LINK_LIFECYCLE_STATE_EXPIRED', '2': 5},
  ],
};

/// Descriptor for `AffiliateLinkLifecycleState`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List affiliateLinkLifecycleStateDescriptor = $convert.base64Decode(
    'ChtBZmZpbGlhdGVMaW5rTGlmZWN5Y2xlU3RhdGUSLgoqQUZGSUxJQVRFX0xJTktfTElGRUNZQ0'
    'xFX1NUQVRFX1VOU1BFQ0lGSUVEEAASKAokQUZGSUxJQVRFX0xJTktfTElGRUNZQ0xFX1NUQVRF'
    'X0RSQUZUEAESKQolQUZGSUxJQVRFX0xJTktfTElGRUNZQ0xFX1NUQVRFX0FDVElWRRACEikKJU'
    'FGRklMSUFURV9MSU5LX0xJRkVDWUNMRV9TVEFURV9QQVVTRUQQAxIqCiZBRkZJTElBVEVfTElO'
    'S19MSUZFQ1lDTEVfU1RBVEVfUkVWT0tFRBAEEioKJkFGRklMSUFURV9MSU5LX0xJRkVDWUNMRV'
    '9TVEFURV9FWFBJUkVEEAU=');

@$core.Deprecated('Use linkHealthStatusDescriptor instead')
const LinkHealthStatus$json = {
  '1': 'LinkHealthStatus',
  '2': [
    {'1': 'LINK_HEALTH_STATUS_UNSPECIFIED', '2': 0},
    {'1': 'LINK_HEALTH_STATUS_HEALTHY', '2': 1},
    {'1': 'LINK_HEALTH_STATUS_WARNING', '2': 2},
    {'1': 'LINK_HEALTH_STATUS_BROKEN', '2': 3},
    {'1': 'LINK_HEALTH_STATUS_EXPIRED', '2': 4},
    {'1': 'LINK_HEALTH_STATUS_PRODUCT_UNAVAILABLE', '2': 5},
  ],
};

/// Descriptor for `LinkHealthStatus`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List linkHealthStatusDescriptor = $convert.base64Decode(
    'ChBMaW5rSGVhbHRoU3RhdHVzEiIKHkxJTktfSEVBTFRIX1NUQVRVU19VTlNQRUNJRklFRBAAEh'
    '4KGkxJTktfSEVBTFRIX1NUQVRVU19IRUFMVEhZEAESHgoaTElOS19IRUFMVEhfU1RBVFVTX1dB'
    'Uk5JTkcQAhIdChlMSU5LX0hFQUxUSF9TVEFUVVNfQlJPS0VOEAMSHgoaTElOS19IRUFMVEhfU1'
    'RBVFVTX0VYUElSRUQQBBIqCiZMSU5LX0hFQUxUSF9TVEFUVVNfUFJPRFVDVF9VTkFWQUlMQUJM'
    'RRAF');

@$core.Deprecated('Use attributionSourceClassDescriptor instead')
const AttributionSourceClass$json = {
  '1': 'AttributionSourceClass',
  '2': [
    {'1': 'ATTRIBUTION_SOURCE_CLASS_UNSPECIFIED', '2': 0},
    {'1': 'ATTRIBUTION_SOURCE_CLASS_OFFICIAL', '2': 1},
    {'1': 'ATTRIBUTION_SOURCE_CLASS_IMPORTED', '2': 2},
    {'1': 'ATTRIBUTION_SOURCE_CLASS_INFERRED', '2': 3},
    {'1': 'ATTRIBUTION_SOURCE_CLASS_ESTIMATED', '2': 4},
    {'1': 'ATTRIBUTION_SOURCE_CLASS_UNRECONCILED', '2': 5},
  ],
};

/// Descriptor for `AttributionSourceClass`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List attributionSourceClassDescriptor = $convert.base64Decode(
    'ChZBdHRyaWJ1dGlvblNvdXJjZUNsYXNzEigKJEFUVFJJQlVUSU9OX1NPVVJDRV9DTEFTU19VTl'
    'NQRUNJRklFRBAAEiUKIUFUVFJJQlVUSU9OX1NPVVJDRV9DTEFTU19PRkZJQ0lBTBABEiUKIUFU'
    'VFJJQlVUSU9OX1NPVVJDRV9DTEFTU19JTVBPUlRFRBACEiUKIUFUVFJJQlVUSU9OX1NPVVJDRV'
    '9DTEFTU19JTkZFUlJFRBADEiYKIkFUVFJJQlVUSU9OX1NPVVJDRV9DTEFTU19FU1RJTUFURUQQ'
    'BBIpCiVBVFRSSUJVVElPTl9TT1VSQ0VfQ0xBU1NfVU5SRUNPTkNJTEVEEAU=');

@$core.Deprecated('Use attributionConfidenceDescriptor instead')
const AttributionConfidence$json = {
  '1': 'AttributionConfidence',
  '2': [
    {'1': 'ATTRIBUTION_CONFIDENCE_UNSPECIFIED', '2': 0},
    {'1': 'ATTRIBUTION_CONFIDENCE_HIGH', '2': 1},
    {'1': 'ATTRIBUTION_CONFIDENCE_MEDIUM', '2': 2},
    {'1': 'ATTRIBUTION_CONFIDENCE_LOW', '2': 3},
  ],
};

/// Descriptor for `AttributionConfidence`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List attributionConfidenceDescriptor = $convert.base64Decode(
    'ChVBdHRyaWJ1dGlvbkNvbmZpZGVuY2USJgoiQVRUUklCVVRJT05fQ09ORklERU5DRV9VTlNQRU'
    'NJRklFRBAAEh8KG0FUVFJJQlVUSU9OX0NPTkZJREVOQ0VfSElHSBABEiEKHUFUVFJJQlVUSU9O'
    'X0NPTkZJREVOQ0VfTUVESVVNEAISHgoaQVRUUklCVVRJT05fQ09ORklERU5DRV9MT1cQAw==');

@$core.Deprecated('Use commissionStatusDescriptor instead')
const CommissionStatus$json = {
  '1': 'CommissionStatus',
  '2': [
    {'1': 'COMMISSION_STATUS_UNSPECIFIED', '2': 0},
    {'1': 'COMMISSION_STATUS_PENDING', '2': 1},
    {'1': 'COMMISSION_STATUS_CONFIRMED', '2': 2},
    {'1': 'COMMISSION_STATUS_CLAWED_BACK', '2': 3},
    {'1': 'COMMISSION_STATUS_PAID_OUT', '2': 4},
  ],
};

/// Descriptor for `CommissionStatus`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List commissionStatusDescriptor = $convert.base64Decode(
    'ChBDb21taXNzaW9uU3RhdHVzEiEKHUNPTU1JU1NJT05fU1RBVFVTX1VOU1BFQ0lGSUVEEAASHQ'
    'oZQ09NTUlTU0lPTl9TVEFUVVNfUEVORElORxABEh8KG0NPTU1JU1NJT05fU1RBVFVTX0NPTkZJ'
    'Uk1FRBACEiEKHUNPTU1JU1NJT05fU1RBVFVTX0NMQVdFRF9CQUNLEAMSHgoaQ09NTUlTU0lPTl'
    '9TVEFUVVNfUEFJRF9PVVQQBA==');

@$core.Deprecated('Use payoutStatusDescriptor instead')
const PayoutStatus$json = {
  '1': 'PayoutStatus',
  '2': [
    {'1': 'PAYOUT_STATUS_UNSPECIFIED', '2': 0},
    {'1': 'PAYOUT_STATUS_PENDING', '2': 1},
    {'1': 'PAYOUT_STATUS_PROCESSING', '2': 2},
    {'1': 'PAYOUT_STATUS_COMPLETED', '2': 3},
    {'1': 'PAYOUT_STATUS_FAILED', '2': 4},
  ],
};

/// Descriptor for `PayoutStatus`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List payoutStatusDescriptor = $convert.base64Decode(
    'CgxQYXlvdXRTdGF0dXMSHQoZUEFZT1VUX1NUQVRVU19VTlNQRUNJRklFRBAAEhkKFVBBWU9VVF'
    '9TVEFUVVNfUEVORElORxABEhwKGFBBWU9VVF9TVEFUVVNfUFJPQ0VTU0lORxACEhsKF1BBWU9V'
    'VF9TVEFUVVNfQ09NUExFVEVEEAMSGAoUUEFZT1VUX1NUQVRVU19GQUlMRUQQBA==');

@$core.Deprecated('Use assignmentStatusDescriptor instead')
const AssignmentStatus$json = {
  '1': 'AssignmentStatus',
  '2': [
    {'1': 'ASSIGNMENT_STATUS_UNSPECIFIED', '2': 0},
    {'1': 'ASSIGNMENT_STATUS_ACTIVE', '2': 1},
    {'1': 'ASSIGNMENT_STATUS_COMPLETED', '2': 2},
    {'1': 'ASSIGNMENT_STATUS_CANCELLED', '2': 3},
  ],
};

/// Descriptor for `AssignmentStatus`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List assignmentStatusDescriptor = $convert.base64Decode(
    'ChBBc3NpZ25tZW50U3RhdHVzEiEKHUFTU0lHTk1FTlRfU1RBVFVTX1VOU1BFQ0lGSUVEEAASHA'
    'oYQVNTSUdOTUVOVF9TVEFUVVNfQUNUSVZFEAESHwobQVNTSUdOTUVOVF9TVEFUVVNfQ09NUExF'
    'VEVEEAISHwobQVNTSUdOTUVOVF9TVEFUVVNfQ0FOQ0VMTEVEEAM=');

@$core.Deprecated('Use workspaceEconomicRoleDescriptor instead')
const WorkspaceEconomicRole$json = {
  '1': 'WorkspaceEconomicRole',
  '2': [
    {'1': 'WORKSPACE_ECONOMIC_ROLE_UNSPECIFIED', '2': 0},
    {'1': 'WORKSPACE_ECONOMIC_ROLE_CREATOR', '2': 1},
    {'1': 'WORKSPACE_ECONOMIC_ROLE_SELLER', '2': 2},
  ],
};

/// Descriptor for `WorkspaceEconomicRole`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List workspaceEconomicRoleDescriptor = $convert.base64Decode(
    'ChVXb3Jrc3BhY2VFY29ub21pY1JvbGUSJwojV09SS1NQQUNFX0VDT05PTUlDX1JPTEVfVU5TUE'
    'VDSUZJRUQQABIjCh9XT1JLU1BBQ0VfRUNPTk9NSUNfUk9MRV9DUkVBVE9SEAESIgoeV09SS1NQ'
    'QUNFX0VDT05PTUlDX1JPTEVfU0VMTEVSEAI=');

@$core.Deprecated('Use affiliateLinkDescriptor instead')
const AffiliateLink$json = {
  '1': 'AffiliateLink',
  '2': [
    {'1': 'affiliate_link_id', '3': 1, '4': 1, '5': 9, '10': 'affiliateLinkId'},
    {'1': 'workspace_id', '3': 2, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'product_id', '3': 3, '4': 1, '5': 9, '10': 'productId'},
    {'1': 'offer_id', '3': 4, '4': 1, '5': 9, '10': 'offerId'},
    {'1': 'campaign_id', '3': 5, '4': 1, '5': 9, '10': 'campaignId'},
    {'1': 'platform', '3': 6, '4': 1, '5': 9, '10': 'platform'},
    {'1': 'original_url', '3': 7, '4': 1, '5': 9, '10': 'originalUrl'},
    {'1': 'tracked_url', '3': 8, '4': 1, '5': 9, '10': 'trackedUrl'},
    {'1': 'short_code', '3': 9, '4': 1, '5': 9, '10': 'shortCode'},
    {'1': 'commission_rate', '3': 10, '4': 1, '5': 9, '10': 'commissionRate'},
    {
      '1': 'lifecycle_state',
      '3': 11,
      '4': 1,
      '5': 14,
      '6': '.creativanta.commerce.v1.AffiliateLinkLifecycleState',
      '10': 'lifecycleState'
    },
    {
      '1': 'health_status',
      '3': 12,
      '4': 1,
      '5': 14,
      '6': '.creativanta.commerce.v1.LinkHealthStatus',
      '10': 'healthStatus'
    },
    {
      '1': 'last_health_check_at',
      '3': 13,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'lastHealthCheckAt'
    },
    {'1': 'click_count', '3': 14, '4': 1, '5': 5, '10': 'clickCount'},
    {'1': 'conversion_count', '3': 15, '4': 1, '5': 5, '10': 'conversionCount'},
    {
      '1': 'revenue_attributed',
      '3': 16,
      '4': 1,
      '5': 9,
      '10': 'revenueAttributed'
    },
    {
      '1': 'expires_at',
      '3': 17,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'expiresAt'
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
    {
      '1': 'suggested_replacement_product_id',
      '3': 20,
      '4': 1,
      '5': 9,
      '10': 'suggestedReplacementProductId'
    },
  ],
};

/// Descriptor for `AffiliateLink`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List affiliateLinkDescriptor = $convert.base64Decode(
    'Cg1BZmZpbGlhdGVMaW5rEioKEWFmZmlsaWF0ZV9saW5rX2lkGAEgASgJUg9hZmZpbGlhdGVMaW'
    '5rSWQSIQoMd29ya3NwYWNlX2lkGAIgASgJUgt3b3Jrc3BhY2VJZBIdCgpwcm9kdWN0X2lkGAMg'
    'ASgJUglwcm9kdWN0SWQSGQoIb2ZmZXJfaWQYBCABKAlSB29mZmVySWQSHwoLY2FtcGFpZ25faW'
    'QYBSABKAlSCmNhbXBhaWduSWQSGgoIcGxhdGZvcm0YBiABKAlSCHBsYXRmb3JtEiEKDG9yaWdp'
    'bmFsX3VybBgHIAEoCVILb3JpZ2luYWxVcmwSHwoLdHJhY2tlZF91cmwYCCABKAlSCnRyYWNrZW'
    'RVcmwSHQoKc2hvcnRfY29kZRgJIAEoCVIJc2hvcnRDb2RlEicKD2NvbW1pc3Npb25fcmF0ZRgK'
    'IAEoCVIOY29tbWlzc2lvblJhdGUSXQoPbGlmZWN5Y2xlX3N0YXRlGAsgASgOMjQuY3JlYXRpdm'
    'FudGEuY29tbWVyY2UudjEuQWZmaWxpYXRlTGlua0xpZmVjeWNsZVN0YXRlUg5saWZlY3ljbGVT'
    'dGF0ZRJOCg1oZWFsdGhfc3RhdHVzGAwgASgOMikuY3JlYXRpdmFudGEuY29tbWVyY2UudjEuTG'
    'lua0hlYWx0aFN0YXR1c1IMaGVhbHRoU3RhdHVzEksKFGxhc3RfaGVhbHRoX2NoZWNrX2F0GA0g'
    'ASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIRbGFzdEhlYWx0aENoZWNrQXQSHwoLY2'
    'xpY2tfY291bnQYDiABKAVSCmNsaWNrQ291bnQSKQoQY29udmVyc2lvbl9jb3VudBgPIAEoBVIP'
    'Y29udmVyc2lvbkNvdW50Ei0KEnJldmVudWVfYXR0cmlidXRlZBgQIAEoCVIRcmV2ZW51ZUF0dH'
    'JpYnV0ZWQSOQoKZXhwaXJlc19hdBgRIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBS'
    'CWV4cGlyZXNBdBI5CgpjcmVhdGVkX2F0GBIgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdG'
    'FtcFIJY3JlYXRlZEF0EjkKCnVwZGF0ZWRfYXQYEyABKAsyGi5nb29nbGUucHJvdG9idWYuVGlt'
    'ZXN0YW1wUgl1cGRhdGVkQXQSRwogc3VnZ2VzdGVkX3JlcGxhY2VtZW50X3Byb2R1Y3RfaWQYFC'
    'ABKAlSHXN1Z2dlc3RlZFJlcGxhY2VtZW50UHJvZHVjdElk');

@$core.Deprecated('Use creatorAssignmentDescriptor instead')
const CreatorAssignment$json = {
  '1': 'CreatorAssignment',
  '2': [
    {'1': 'assignment_id', '3': 1, '4': 1, '5': 9, '10': 'assignmentId'},
    {'1': 'workspace_id', '3': 2, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'campaign_id', '3': 3, '4': 1, '5': 9, '10': 'campaignId'},
    {'1': 'creator_entity_id', '3': 4, '4': 1, '5': 9, '10': 'creatorEntityId'},
    {'1': 'affiliate_link_id', '3': 5, '4': 1, '5': 9, '10': 'affiliateLinkId'},
    {'1': 'coupon_id', '3': 6, '4': 1, '5': 9, '10': 'couponId'},
    {
      '1': 'status',
      '3': 7,
      '4': 1,
      '5': 14,
      '6': '.creativanta.commerce.v1.AssignmentStatus',
      '10': 'status'
    },
    {'1': 'notes', '3': 8, '4': 1, '5': 9, '10': 'notes'},
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

/// Descriptor for `CreatorAssignment`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List creatorAssignmentDescriptor = $convert.base64Decode(
    'ChFDcmVhdG9yQXNzaWdubWVudBIjCg1hc3NpZ25tZW50X2lkGAEgASgJUgxhc3NpZ25tZW50SW'
    'QSIQoMd29ya3NwYWNlX2lkGAIgASgJUgt3b3Jrc3BhY2VJZBIfCgtjYW1wYWlnbl9pZBgDIAEo'
    'CVIKY2FtcGFpZ25JZBIqChFjcmVhdG9yX2VudGl0eV9pZBgEIAEoCVIPY3JlYXRvckVudGl0eU'
    'lkEioKEWFmZmlsaWF0ZV9saW5rX2lkGAUgASgJUg9hZmZpbGlhdGVMaW5rSWQSGwoJY291cG9u'
    'X2lkGAYgASgJUghjb3Vwb25JZBJBCgZzdGF0dXMYByABKA4yKS5jcmVhdGl2YW50YS5jb21tZX'
    'JjZS52MS5Bc3NpZ25tZW50U3RhdHVzUgZzdGF0dXMSFAoFbm90ZXMYCCABKAlSBW5vdGVzEjkK'
    'CmNyZWF0ZWRfYXQYCSABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUgljcmVhdGVkQX'
    'QSOQoKdXBkYXRlZF9hdBgKIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSCXVwZGF0'
    'ZWRBdA==');

@$core.Deprecated('Use attributionRecordDescriptor instead')
const AttributionRecord$json = {
  '1': 'AttributionRecord',
  '2': [
    {'1': 'attribution_id', '3': 1, '4': 1, '5': 9, '10': 'attributionId'},
    {'1': 'workspace_id', '3': 2, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'order_id', '3': 3, '4': 1, '5': 9, '10': 'orderId'},
    {'1': 'affiliate_link_id', '3': 4, '4': 1, '5': 9, '10': 'affiliateLinkId'},
    {'1': 'creator_entity_id', '3': 5, '4': 1, '5': 9, '10': 'creatorEntityId'},
    {'1': 'click_id', '3': 6, '4': 1, '5': 9, '10': 'clickId'},
    {'1': 'touchpoint_count', '3': 7, '4': 1, '5': 5, '10': 'touchpointCount'},
    {'1': 'is_multi_touch', '3': 8, '4': 1, '5': 8, '10': 'isMultiTouch'},
    {
      '1': 'source_class',
      '3': 9,
      '4': 1,
      '5': 14,
      '6': '.creativanta.commerce.v1.AttributionSourceClass',
      '10': 'sourceClass'
    },
    {
      '1': 'confidence',
      '3': 10,
      '4': 1,
      '5': 14,
      '6': '.creativanta.commerce.v1.AttributionConfidence',
      '10': 'confidence'
    },
    {'1': 'attribution_note', '3': 11, '4': 1, '5': 9, '10': 'attributionNote'},
    {'1': 'order_amount', '3': 12, '4': 1, '5': 9, '10': 'orderAmount'},
    {
      '1': 'attributed_revenue',
      '3': 13,
      '4': 1,
      '5': 9,
      '10': 'attributedRevenue'
    },
    {
      '1': 'commission_amount',
      '3': 14,
      '4': 1,
      '5': 9,
      '10': 'commissionAmount'
    },
    {'1': 'currency', '3': 15, '4': 1, '5': 9, '10': 'currency'},
    {
      '1': 'attributed_at',
      '3': 16,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'attributedAt'
    },
  ],
};

/// Descriptor for `AttributionRecord`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List attributionRecordDescriptor = $convert.base64Decode(
    'ChFBdHRyaWJ1dGlvblJlY29yZBIlCg5hdHRyaWJ1dGlvbl9pZBgBIAEoCVINYXR0cmlidXRpb2'
    '5JZBIhCgx3b3Jrc3BhY2VfaWQYAiABKAlSC3dvcmtzcGFjZUlkEhkKCG9yZGVyX2lkGAMgASgJ'
    'UgdvcmRlcklkEioKEWFmZmlsaWF0ZV9saW5rX2lkGAQgASgJUg9hZmZpbGlhdGVMaW5rSWQSKg'
    'oRY3JlYXRvcl9lbnRpdHlfaWQYBSABKAlSD2NyZWF0b3JFbnRpdHlJZBIZCghjbGlja19pZBgG'
    'IAEoCVIHY2xpY2tJZBIpChB0b3VjaHBvaW50X2NvdW50GAcgASgFUg90b3VjaHBvaW50Q291bn'
    'QSJAoOaXNfbXVsdGlfdG91Y2gYCCABKAhSDGlzTXVsdGlUb3VjaBJSCgxzb3VyY2VfY2xhc3MY'
    'CSABKA4yLy5jcmVhdGl2YW50YS5jb21tZXJjZS52MS5BdHRyaWJ1dGlvblNvdXJjZUNsYXNzUg'
    'tzb3VyY2VDbGFzcxJOCgpjb25maWRlbmNlGAogASgOMi4uY3JlYXRpdmFudGEuY29tbWVyY2Uu'
    'djEuQXR0cmlidXRpb25Db25maWRlbmNlUgpjb25maWRlbmNlEikKEGF0dHJpYnV0aW9uX25vdG'
    'UYCyABKAlSD2F0dHJpYnV0aW9uTm90ZRIhCgxvcmRlcl9hbW91bnQYDCABKAlSC29yZGVyQW1v'
    'dW50Ei0KEmF0dHJpYnV0ZWRfcmV2ZW51ZRgNIAEoCVIRYXR0cmlidXRlZFJldmVudWUSKwoRY2'
    '9tbWlzc2lvbl9hbW91bnQYDiABKAlSEGNvbW1pc3Npb25BbW91bnQSGgoIY3VycmVuY3kYDyAB'
    'KAlSCGN1cnJlbmN5Ej8KDWF0dHJpYnV0ZWRfYXQYECABKAsyGi5nb29nbGUucHJvdG9idWYuVG'
    'ltZXN0YW1wUgxhdHRyaWJ1dGVkQXQ=');

@$core.Deprecated('Use affiliateCommissionDescriptor instead')
const AffiliateCommission$json = {
  '1': 'AffiliateCommission',
  '2': [
    {'1': 'commission_id', '3': 1, '4': 1, '5': 9, '10': 'commissionId'},
    {'1': 'workspace_id', '3': 2, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'affiliate_link_id', '3': 3, '4': 1, '5': 9, '10': 'affiliateLinkId'},
    {'1': 'order_id', '3': 4, '4': 1, '5': 9, '10': 'orderId'},
    {'1': 'creator_entity_id', '3': 5, '4': 1, '5': 9, '10': 'creatorEntityId'},
    {
      '1': 'commission_amount',
      '3': 6,
      '4': 1,
      '5': 9,
      '10': 'commissionAmount'
    },
    {'1': 'currency', '3': 7, '4': 1, '5': 9, '10': 'currency'},
    {
      '1': 'status',
      '3': 8,
      '4': 1,
      '5': 14,
      '6': '.creativanta.commerce.v1.CommissionStatus',
      '10': 'status'
    },
    {
      '1': 'hold_until',
      '3': 9,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'holdUntil'
    },
    {'1': 'clawback_reason', '3': 10, '4': 1, '5': 9, '10': 'clawbackReason'},
    {'1': 'clawback_amount', '3': 11, '4': 1, '5': 9, '10': 'clawbackAmount'},
    {'1': 'payout_id', '3': 12, '4': 1, '5': 9, '10': 'payoutId'},
    {
      '1': 'confirmed_at',
      '3': 13,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'confirmedAt'
    },
    {
      '1': 'clawed_back_at',
      '3': 14,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'clawedBackAt'
    },
    {
      '1': 'paid_out_at',
      '3': 15,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'paidOutAt'
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

/// Descriptor for `AffiliateCommission`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List affiliateCommissionDescriptor = $convert.base64Decode(
    'ChNBZmZpbGlhdGVDb21taXNzaW9uEiMKDWNvbW1pc3Npb25faWQYASABKAlSDGNvbW1pc3Npb2'
    '5JZBIhCgx3b3Jrc3BhY2VfaWQYAiABKAlSC3dvcmtzcGFjZUlkEioKEWFmZmlsaWF0ZV9saW5r'
    'X2lkGAMgASgJUg9hZmZpbGlhdGVMaW5rSWQSGQoIb3JkZXJfaWQYBCABKAlSB29yZGVySWQSKg'
    'oRY3JlYXRvcl9lbnRpdHlfaWQYBSABKAlSD2NyZWF0b3JFbnRpdHlJZBIrChFjb21taXNzaW9u'
    'X2Ftb3VudBgGIAEoCVIQY29tbWlzc2lvbkFtb3VudBIaCghjdXJyZW5jeRgHIAEoCVIIY3Vycm'
    'VuY3kSQQoGc3RhdHVzGAggASgOMikuY3JlYXRpdmFudGEuY29tbWVyY2UudjEuQ29tbWlzc2lv'
    'blN0YXR1c1IGc3RhdHVzEjkKCmhvbGRfdW50aWwYCSABKAsyGi5nb29nbGUucHJvdG9idWYuVG'
    'ltZXN0YW1wUglob2xkVW50aWwSJwoPY2xhd2JhY2tfcmVhc29uGAogASgJUg5jbGF3YmFja1Jl'
    'YXNvbhInCg9jbGF3YmFja19hbW91bnQYCyABKAlSDmNsYXdiYWNrQW1vdW50EhsKCXBheW91dF'
    '9pZBgMIAEoCVIIcGF5b3V0SWQSPQoMY29uZmlybWVkX2F0GA0gASgLMhouZ29vZ2xlLnByb3Rv'
    'YnVmLlRpbWVzdGFtcFILY29uZmlybWVkQXQSQAoOY2xhd2VkX2JhY2tfYXQYDiABKAsyGi5nb2'
    '9nbGUucHJvdG9idWYuVGltZXN0YW1wUgxjbGF3ZWRCYWNrQXQSOgoLcGFpZF9vdXRfYXQYDyAB'
    'KAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUglwYWlkT3V0QXQSOQoKY3JlYXRlZF9hdB'
    'gQIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSCWNyZWF0ZWRBdBI5Cgp1cGRhdGVk'
    'X2F0GBEgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIJdXBkYXRlZEF0');

@$core.Deprecated('Use affiliatePayoutDescriptor instead')
const AffiliatePayout$json = {
  '1': 'AffiliatePayout',
  '2': [
    {'1': 'payout_id', '3': 1, '4': 1, '5': 9, '10': 'payoutId'},
    {'1': 'workspace_id', '3': 2, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'creator_entity_id', '3': 3, '4': 1, '5': 9, '10': 'creatorEntityId'},
    {'1': 'commission_ids', '3': 4, '4': 3, '5': 9, '10': 'commissionIds'},
    {'1': 'total_amount', '3': 5, '4': 1, '5': 9, '10': 'totalAmount'},
    {'1': 'currency', '3': 6, '4': 1, '5': 9, '10': 'currency'},
    {
      '1': 'status',
      '3': 7,
      '4': 1,
      '5': 14,
      '6': '.creativanta.commerce.v1.PayoutStatus',
      '10': 'status'
    },
    {'1': 'proof_hash', '3': 8, '4': 1, '5': 9, '10': 'proofHash'},
    {
      '1': 'proof_metadata_json',
      '3': 9,
      '4': 1,
      '5': 9,
      '10': 'proofMetadataJson'
    },
    {'1': 'settlement_id', '3': 10, '4': 1, '5': 9, '10': 'settlementId'},
    {
      '1': 'paid_at',
      '3': 11,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'paidAt'
    },
    {
      '1': 'created_at',
      '3': 12,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'createdAt'
    },
  ],
};

/// Descriptor for `AffiliatePayout`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List affiliatePayoutDescriptor = $convert.base64Decode(
    'Cg9BZmZpbGlhdGVQYXlvdXQSGwoJcGF5b3V0X2lkGAEgASgJUghwYXlvdXRJZBIhCgx3b3Jrc3'
    'BhY2VfaWQYAiABKAlSC3dvcmtzcGFjZUlkEioKEWNyZWF0b3JfZW50aXR5X2lkGAMgASgJUg9j'
    'cmVhdG9yRW50aXR5SWQSJQoOY29tbWlzc2lvbl9pZHMYBCADKAlSDWNvbW1pc3Npb25JZHMSIQ'
    'oMdG90YWxfYW1vdW50GAUgASgJUgt0b3RhbEFtb3VudBIaCghjdXJyZW5jeRgGIAEoCVIIY3Vy'
    'cmVuY3kSPQoGc3RhdHVzGAcgASgOMiUuY3JlYXRpdmFudGEuY29tbWVyY2UudjEuUGF5b3V0U3'
    'RhdHVzUgZzdGF0dXMSHQoKcHJvb2ZfaGFzaBgIIAEoCVIJcHJvb2ZIYXNoEi4KE3Byb29mX21l'
    'dGFkYXRhX2pzb24YCSABKAlSEXByb29mTWV0YWRhdGFKc29uEiMKDXNldHRsZW1lbnRfaWQYCi'
    'ABKAlSDHNldHRsZW1lbnRJZBIzCgdwYWlkX2F0GAsgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRp'
    'bWVzdGFtcFIGcGFpZEF0EjkKCmNyZWF0ZWRfYXQYDCABKAsyGi5nb29nbGUucHJvdG9idWYuVG'
    'ltZXN0YW1wUgljcmVhdGVkQXQ=');

@$core.Deprecated('Use linkHealthRecordDescriptor instead')
const LinkHealthRecord$json = {
  '1': 'LinkHealthRecord',
  '2': [
    {'1': 'health_id', '3': 1, '4': 1, '5': 9, '10': 'healthId'},
    {'1': 'workspace_id', '3': 2, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'affiliate_link_id', '3': 3, '4': 1, '5': 9, '10': 'affiliateLinkId'},
    {'1': 'http_status', '3': 4, '4': 1, '5': 5, '10': 'httpStatus'},
    {'1': 'product_status', '3': 5, '4': 1, '5': 9, '10': 'productStatus'},
    {
      '1': 'commission_status',
      '3': 6,
      '4': 1,
      '5': 9,
      '10': 'commissionStatus'
    },
    {
      '1': 'link_status',
      '3': 7,
      '4': 1,
      '5': 14,
      '6': '.creativanta.commerce.v1.LinkHealthStatus',
      '10': 'linkStatus'
    },
    {
      '1': 'expiry_date',
      '3': 8,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'expiryDate'
    },
    {'1': 'suggested_action', '3': 9, '4': 1, '5': 9, '10': 'suggestedAction'},
    {
      '1': 'checked_at',
      '3': 10,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'checkedAt'
    },
    {'1': 'alert_sent', '3': 11, '4': 1, '5': 8, '10': 'alertSent'},
    {
      '1': 'estimated_revenue_impact',
      '3': 12,
      '4': 1,
      '5': 9,
      '10': 'estimatedRevenueImpact'
    },
    {
      '1': 'suggested_replacement_product_id',
      '3': 13,
      '4': 1,
      '5': 9,
      '10': 'suggestedReplacementProductId'
    },
  ],
};

/// Descriptor for `LinkHealthRecord`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List linkHealthRecordDescriptor = $convert.base64Decode(
    'ChBMaW5rSGVhbHRoUmVjb3JkEhsKCWhlYWx0aF9pZBgBIAEoCVIIaGVhbHRoSWQSIQoMd29ya3'
    'NwYWNlX2lkGAIgASgJUgt3b3Jrc3BhY2VJZBIqChFhZmZpbGlhdGVfbGlua19pZBgDIAEoCVIP'
    'YWZmaWxpYXRlTGlua0lkEh8KC2h0dHBfc3RhdHVzGAQgASgFUgpodHRwU3RhdHVzEiUKDnByb2'
    'R1Y3Rfc3RhdHVzGAUgASgJUg1wcm9kdWN0U3RhdHVzEisKEWNvbW1pc3Npb25fc3RhdHVzGAYg'
    'ASgJUhBjb21taXNzaW9uU3RhdHVzEkoKC2xpbmtfc3RhdHVzGAcgASgOMikuY3JlYXRpdmFudG'
    'EuY29tbWVyY2UudjEuTGlua0hlYWx0aFN0YXR1c1IKbGlua1N0YXR1cxI7CgtleHBpcnlfZGF0'
    'ZRgIIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSCmV4cGlyeURhdGUSKQoQc3VnZ2'
    'VzdGVkX2FjdGlvbhgJIAEoCVIPc3VnZ2VzdGVkQWN0aW9uEjkKCmNoZWNrZWRfYXQYCiABKAsy'
    'Gi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUgljaGVja2VkQXQSHQoKYWxlcnRfc2VudBgLIA'
    'EoCFIJYWxlcnRTZW50EjgKGGVzdGltYXRlZF9yZXZlbnVlX2ltcGFjdBgMIAEoCVIWZXN0aW1h'
    'dGVkUmV2ZW51ZUltcGFjdBJHCiBzdWdnZXN0ZWRfcmVwbGFjZW1lbnRfcHJvZHVjdF9pZBgNIA'
    'EoCVIdc3VnZ2VzdGVkUmVwbGFjZW1lbnRQcm9kdWN0SWQ=');

@$core.Deprecated('Use affiliateStatementDescriptor instead')
const AffiliateStatement$json = {
  '1': 'AffiliateStatement',
  '2': [
    {'1': 'statement_id', '3': 1, '4': 1, '5': 9, '10': 'statementId'},
    {'1': 'workspace_id', '3': 2, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'platform', '3': 3, '4': 1, '5': 9, '10': 'platform'},
    {
      '1': 'external_statement_ref',
      '3': 4,
      '4': 1,
      '5': 9,
      '10': 'externalStatementRef'
    },
    {'1': 'period_start', '3': 5, '4': 1, '5': 9, '10': 'periodStart'},
    {'1': 'period_end', '3': 6, '4': 1, '5': 9, '10': 'periodEnd'},
    {'1': 'total_commission', '3': 7, '4': 1, '5': 9, '10': 'totalCommission'},
    {'1': 'currency', '3': 8, '4': 1, '5': 9, '10': 'currency'},
    {
      '1': 'reconciliation_state',
      '3': 9,
      '4': 1,
      '5': 9,
      '10': 'reconciliationState'
    },
    {'1': 'item_count', '3': 10, '4': 1, '5': 5, '10': 'itemCount'},
    {
      '1': 'reconciled_item_count',
      '3': 11,
      '4': 1,
      '5': 5,
      '10': 'reconciledItemCount'
    },
    {
      '1': 'imported_at',
      '3': 12,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'importedAt'
    },
  ],
};

/// Descriptor for `AffiliateStatement`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List affiliateStatementDescriptor = $convert.base64Decode(
    'ChJBZmZpbGlhdGVTdGF0ZW1lbnQSIQoMc3RhdGVtZW50X2lkGAEgASgJUgtzdGF0ZW1lbnRJZB'
    'IhCgx3b3Jrc3BhY2VfaWQYAiABKAlSC3dvcmtzcGFjZUlkEhoKCHBsYXRmb3JtGAMgASgJUghw'
    'bGF0Zm9ybRI0ChZleHRlcm5hbF9zdGF0ZW1lbnRfcmVmGAQgASgJUhRleHRlcm5hbFN0YXRlbW'
    'VudFJlZhIhCgxwZXJpb2Rfc3RhcnQYBSABKAlSC3BlcmlvZFN0YXJ0Eh0KCnBlcmlvZF9lbmQY'
    'BiABKAlSCXBlcmlvZEVuZBIpChB0b3RhbF9jb21taXNzaW9uGAcgASgJUg90b3RhbENvbW1pc3'
    'Npb24SGgoIY3VycmVuY3kYCCABKAlSCGN1cnJlbmN5EjEKFHJlY29uY2lsaWF0aW9uX3N0YXRl'
    'GAkgASgJUhNyZWNvbmNpbGlhdGlvblN0YXRlEh0KCml0ZW1fY291bnQYCiABKAVSCWl0ZW1Db3'
    'VudBIyChVyZWNvbmNpbGVkX2l0ZW1fY291bnQYCyABKAVSE3JlY29uY2lsZWRJdGVtQ291bnQS'
    'OwoLaW1wb3J0ZWRfYXQYDCABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUgppbXBvcn'
    'RlZEF0');

@$core.Deprecated('Use affiliateStatementItemDescriptor instead')
const AffiliateStatementItem$json = {
  '1': 'AffiliateStatementItem',
  '2': [
    {'1': 'item_id', '3': 1, '4': 1, '5': 9, '10': 'itemId'},
    {'1': 'statement_id', '3': 2, '4': 1, '5': 9, '10': 'statementId'},
    {'1': 'external_order_id', '3': 3, '4': 1, '5': 9, '10': 'externalOrderId'},
    {'1': 'order_amount', '3': 4, '4': 1, '5': 9, '10': 'orderAmount'},
    {
      '1': 'commission_amount',
      '3': 5,
      '4': 1,
      '5': 9,
      '10': 'commissionAmount'
    },
    {'1': 'matched_order_id', '3': 6, '4': 1, '5': 9, '10': 'matchedOrderId'},
    {
      '1': 'matched_commission_id',
      '3': 7,
      '4': 1,
      '5': 9,
      '10': 'matchedCommissionId'
    },
    {'1': 'status', '3': 8, '4': 1, '5': 9, '10': 'status'},
  ],
};

/// Descriptor for `AffiliateStatementItem`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List affiliateStatementItemDescriptor = $convert.base64Decode(
    'ChZBZmZpbGlhdGVTdGF0ZW1lbnRJdGVtEhcKB2l0ZW1faWQYASABKAlSBml0ZW1JZBIhCgxzdG'
    'F0ZW1lbnRfaWQYAiABKAlSC3N0YXRlbWVudElkEioKEWV4dGVybmFsX29yZGVyX2lkGAMgASgJ'
    'Ug9leHRlcm5hbE9yZGVySWQSIQoMb3JkZXJfYW1vdW50GAQgASgJUgtvcmRlckFtb3VudBIrCh'
    'Fjb21taXNzaW9uX2Ftb3VudBgFIAEoCVIQY29tbWlzc2lvbkFtb3VudBIoChBtYXRjaGVkX29y'
    'ZGVyX2lkGAYgASgJUg5tYXRjaGVkT3JkZXJJZBIyChVtYXRjaGVkX2NvbW1pc3Npb25faWQYBy'
    'ABKAlSE21hdGNoZWRDb21taXNzaW9uSWQSFgoGc3RhdHVzGAggASgJUgZzdGF0dXM=');

@$core.Deprecated('Use ledgerAffiliatePostingResultDescriptor instead')
const LedgerAffiliatePostingResult$json = {
  '1': 'LedgerAffiliatePostingResult',
  '2': [
    {'1': 'posting_id', '3': 1, '4': 1, '5': 9, '10': 'postingId'},
    {'1': 'workspace_id', '3': 2, '4': 1, '5': 9, '10': 'workspaceId'},
    {
      '1': 'economic_role',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.creativanta.commerce.v1.WorkspaceEconomicRole',
      '10': 'economicRole'
    },
    {'1': 'posting_type', '3': 4, '4': 1, '5': 9, '10': 'postingType'},
    {'1': 'amount', '3': 5, '4': 1, '5': 9, '10': 'amount'},
    {'1': 'currency', '3': 6, '4': 1, '5': 9, '10': 'currency'},
    {'1': 'cogs_deducted', '3': 7, '4': 1, '5': 8, '10': 'cogsDeducted'},
    {'1': 'net_profit_impact', '3': 8, '4': 1, '5': 9, '10': 'netProfitImpact'},
    {
      '1': 'posted_at',
      '3': 9,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'postedAt'
    },
  ],
};

/// Descriptor for `LedgerAffiliatePostingResult`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List ledgerAffiliatePostingResultDescriptor = $convert.base64Decode(
    'ChxMZWRnZXJBZmZpbGlhdGVQb3N0aW5nUmVzdWx0Eh0KCnBvc3RpbmdfaWQYASABKAlSCXBvc3'
    'RpbmdJZBIhCgx3b3Jrc3BhY2VfaWQYAiABKAlSC3dvcmtzcGFjZUlkElMKDWVjb25vbWljX3Jv'
    'bGUYAyABKA4yLi5jcmVhdGl2YW50YS5jb21tZXJjZS52MS5Xb3Jrc3BhY2VFY29ub21pY1JvbG'
    'VSDGVjb25vbWljUm9sZRIhCgxwb3N0aW5nX3R5cGUYBCABKAlSC3Bvc3RpbmdUeXBlEhYKBmFt'
    'b3VudBgFIAEoCVIGYW1vdW50EhoKCGN1cnJlbmN5GAYgASgJUghjdXJyZW5jeRIjCg1jb2dzX2'
    'RlZHVjdGVkGAcgASgIUgxjb2dzRGVkdWN0ZWQSKgoRbmV0X3Byb2ZpdF9pbXBhY3QYCCABKAlS'
    'D25ldFByb2ZpdEltcGFjdBI3Cglwb3N0ZWRfYXQYCSABKAsyGi5nb29nbGUucHJvdG9idWYuVG'
    'ltZXN0YW1wUghwb3N0ZWRBdA==');

@$core.Deprecated('Use createAffiliateLinkRequestDescriptor instead')
const CreateAffiliateLinkRequest$json = {
  '1': 'CreateAffiliateLinkRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'product_id', '3': 2, '4': 1, '5': 9, '10': 'productId'},
    {'1': 'offer_id', '3': 3, '4': 1, '5': 9, '10': 'offerId'},
    {'1': 'campaign_id', '3': 4, '4': 1, '5': 9, '10': 'campaignId'},
    {'1': 'platform', '3': 5, '4': 1, '5': 9, '10': 'platform'},
    {'1': 'original_url', '3': 6, '4': 1, '5': 9, '10': 'originalUrl'},
    {'1': 'commission_rate', '3': 7, '4': 1, '5': 9, '10': 'commissionRate'},
    {'1': 'custom_short_code', '3': 8, '4': 1, '5': 9, '10': 'customShortCode'},
    {
      '1': 'expires_at',
      '3': 9,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'expiresAt'
    },
  ],
};

/// Descriptor for `CreateAffiliateLinkRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createAffiliateLinkRequestDescriptor = $convert.base64Decode(
    'ChpDcmVhdGVBZmZpbGlhdGVMaW5rUmVxdWVzdBIhCgx3b3Jrc3BhY2VfaWQYASABKAlSC3dvcm'
    'tzcGFjZUlkEh0KCnByb2R1Y3RfaWQYAiABKAlSCXByb2R1Y3RJZBIZCghvZmZlcl9pZBgDIAEo'
    'CVIHb2ZmZXJJZBIfCgtjYW1wYWlnbl9pZBgEIAEoCVIKY2FtcGFpZ25JZBIaCghwbGF0Zm9ybR'
    'gFIAEoCVIIcGxhdGZvcm0SIQoMb3JpZ2luYWxfdXJsGAYgASgJUgtvcmlnaW5hbFVybBInCg9j'
    'b21taXNzaW9uX3JhdGUYByABKAlSDmNvbW1pc3Npb25SYXRlEioKEWN1c3RvbV9zaG9ydF9jb2'
    'RlGAggASgJUg9jdXN0b21TaG9ydENvZGUSOQoKZXhwaXJlc19hdBgJIAEoCzIaLmdvb2dsZS5w'
    'cm90b2J1Zi5UaW1lc3RhbXBSCWV4cGlyZXNBdA==');

@$core.Deprecated('Use createAffiliateLinkResponseDescriptor instead')
const CreateAffiliateLinkResponse$json = {
  '1': 'CreateAffiliateLinkResponse',
  '2': [
    {
      '1': 'link',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.commerce.v1.AffiliateLink',
      '10': 'link'
    },
  ],
};

/// Descriptor for `CreateAffiliateLinkResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createAffiliateLinkResponseDescriptor =
    $convert.base64Decode(
        'ChtDcmVhdGVBZmZpbGlhdGVMaW5rUmVzcG9uc2USOgoEbGluaxgBIAEoCzImLmNyZWF0aXZhbn'
        'RhLmNvbW1lcmNlLnYxLkFmZmlsaWF0ZUxpbmtSBGxpbms=');

@$core.Deprecated('Use getAffiliateLinkRequestDescriptor instead')
const GetAffiliateLinkRequest$json = {
  '1': 'GetAffiliateLinkRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'affiliate_link_id', '3': 2, '4': 1, '5': 9, '10': 'affiliateLinkId'},
  ],
};

/// Descriptor for `GetAffiliateLinkRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getAffiliateLinkRequestDescriptor =
    $convert.base64Decode(
        'ChdHZXRBZmZpbGlhdGVMaW5rUmVxdWVzdBIhCgx3b3Jrc3BhY2VfaWQYASABKAlSC3dvcmtzcG'
        'FjZUlkEioKEWFmZmlsaWF0ZV9saW5rX2lkGAIgASgJUg9hZmZpbGlhdGVMaW5rSWQ=');

@$core.Deprecated('Use getAffiliateLinkResponseDescriptor instead')
const GetAffiliateLinkResponse$json = {
  '1': 'GetAffiliateLinkResponse',
  '2': [
    {
      '1': 'link',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.commerce.v1.AffiliateLink',
      '10': 'link'
    },
    {
      '1': 'latest_health',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.creativanta.commerce.v1.LinkHealthRecord',
      '10': 'latestHealth'
    },
  ],
};

/// Descriptor for `GetAffiliateLinkResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getAffiliateLinkResponseDescriptor = $convert.base64Decode(
    'ChhHZXRBZmZpbGlhdGVMaW5rUmVzcG9uc2USOgoEbGluaxgBIAEoCzImLmNyZWF0aXZhbnRhLm'
    'NvbW1lcmNlLnYxLkFmZmlsaWF0ZUxpbmtSBGxpbmsSTgoNbGF0ZXN0X2hlYWx0aBgCIAEoCzIp'
    'LmNyZWF0aXZhbnRhLmNvbW1lcmNlLnYxLkxpbmtIZWFsdGhSZWNvcmRSDGxhdGVzdEhlYWx0aA'
    '==');

@$core.Deprecated('Use listAffiliateLinksRequestDescriptor instead')
const ListAffiliateLinksRequest$json = {
  '1': 'ListAffiliateLinksRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'campaign_id', '3': 2, '4': 1, '5': 9, '10': 'campaignId'},
    {'1': 'platform', '3': 3, '4': 1, '5': 9, '10': 'platform'},
    {
      '1': 'lifecycle_state',
      '3': 4,
      '4': 1,
      '5': 14,
      '6': '.creativanta.commerce.v1.AffiliateLinkLifecycleState',
      '10': 'lifecycleState'
    },
    {'1': 'page_size', '3': 5, '4': 1, '5': 5, '10': 'pageSize'},
    {'1': 'page_token', '3': 6, '4': 1, '5': 9, '10': 'pageToken'},
  ],
};

/// Descriptor for `ListAffiliateLinksRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listAffiliateLinksRequestDescriptor = $convert.base64Decode(
    'ChlMaXN0QWZmaWxpYXRlTGlua3NSZXF1ZXN0EiEKDHdvcmtzcGFjZV9pZBgBIAEoCVILd29ya3'
    'NwYWNlSWQSHwoLY2FtcGFpZ25faWQYAiABKAlSCmNhbXBhaWduSWQSGgoIcGxhdGZvcm0YAyAB'
    'KAlSCHBsYXRmb3JtEl0KD2xpZmVjeWNsZV9zdGF0ZRgEIAEoDjI0LmNyZWF0aXZhbnRhLmNvbW'
    '1lcmNlLnYxLkFmZmlsaWF0ZUxpbmtMaWZlY3ljbGVTdGF0ZVIObGlmZWN5Y2xlU3RhdGUSGwoJ'
    'cGFnZV9zaXplGAUgASgFUghwYWdlU2l6ZRIdCgpwYWdlX3Rva2VuGAYgASgJUglwYWdlVG9rZW'
    '4=');

@$core.Deprecated('Use listAffiliateLinksResponseDescriptor instead')
const ListAffiliateLinksResponse$json = {
  '1': 'ListAffiliateLinksResponse',
  '2': [
    {
      '1': 'links',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.creativanta.commerce.v1.AffiliateLink',
      '10': 'links'
    },
    {'1': 'next_page_token', '3': 2, '4': 1, '5': 9, '10': 'nextPageToken'},
    {'1': 'total_count', '3': 3, '4': 1, '5': 5, '10': 'totalCount'},
  ],
};

/// Descriptor for `ListAffiliateLinksResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listAffiliateLinksResponseDescriptor = $convert.base64Decode(
    'ChpMaXN0QWZmaWxpYXRlTGlua3NSZXNwb25zZRI8CgVsaW5rcxgBIAMoCzImLmNyZWF0aXZhbn'
    'RhLmNvbW1lcmNlLnYxLkFmZmlsaWF0ZUxpbmtSBWxpbmtzEiYKD25leHRfcGFnZV90b2tlbhgC'
    'IAEoCVINbmV4dFBhZ2VUb2tlbhIfCgt0b3RhbF9jb3VudBgDIAEoBVIKdG90YWxDb3VudA==');

@$core.Deprecated('Use updateAffiliateLinkRequestDescriptor instead')
const UpdateAffiliateLinkRequest$json = {
  '1': 'UpdateAffiliateLinkRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'affiliate_link_id', '3': 2, '4': 1, '5': 9, '10': 'affiliateLinkId'},
    {'1': 'commission_rate', '3': 3, '4': 1, '5': 9, '10': 'commissionRate'},
    {'1': 'original_url', '3': 4, '4': 1, '5': 9, '10': 'originalUrl'},
    {
      '1': 'expires_at',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'expiresAt'
    },
  ],
};

/// Descriptor for `UpdateAffiliateLinkRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateAffiliateLinkRequestDescriptor = $convert.base64Decode(
    'ChpVcGRhdGVBZmZpbGlhdGVMaW5rUmVxdWVzdBIhCgx3b3Jrc3BhY2VfaWQYASABKAlSC3dvcm'
    'tzcGFjZUlkEioKEWFmZmlsaWF0ZV9saW5rX2lkGAIgASgJUg9hZmZpbGlhdGVMaW5rSWQSJwoP'
    'Y29tbWlzc2lvbl9yYXRlGAMgASgJUg5jb21taXNzaW9uUmF0ZRIhCgxvcmlnaW5hbF91cmwYBC'
    'ABKAlSC29yaWdpbmFsVXJsEjkKCmV4cGlyZXNfYXQYBSABKAsyGi5nb29nbGUucHJvdG9idWYu'
    'VGltZXN0YW1wUglleHBpcmVzQXQ=');

@$core.Deprecated('Use updateAffiliateLinkResponseDescriptor instead')
const UpdateAffiliateLinkResponse$json = {
  '1': 'UpdateAffiliateLinkResponse',
  '2': [
    {
      '1': 'link',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.commerce.v1.AffiliateLink',
      '10': 'link'
    },
  ],
};

/// Descriptor for `UpdateAffiliateLinkResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateAffiliateLinkResponseDescriptor =
    $convert.base64Decode(
        'ChtVcGRhdGVBZmZpbGlhdGVMaW5rUmVzcG9uc2USOgoEbGluaxgBIAEoCzImLmNyZWF0aXZhbn'
        'RhLmNvbW1lcmNlLnYxLkFmZmlsaWF0ZUxpbmtSBGxpbms=');

@$core.Deprecated('Use deleteAffiliateLinkRequestDescriptor instead')
const DeleteAffiliateLinkRequest$json = {
  '1': 'DeleteAffiliateLinkRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'affiliate_link_id', '3': 2, '4': 1, '5': 9, '10': 'affiliateLinkId'},
  ],
};

/// Descriptor for `DeleteAffiliateLinkRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deleteAffiliateLinkRequestDescriptor =
    $convert.base64Decode(
        'ChpEZWxldGVBZmZpbGlhdGVMaW5rUmVxdWVzdBIhCgx3b3Jrc3BhY2VfaWQYASABKAlSC3dvcm'
        'tzcGFjZUlkEioKEWFmZmlsaWF0ZV9saW5rX2lkGAIgASgJUg9hZmZpbGlhdGVMaW5rSWQ=');

@$core.Deprecated('Use deleteAffiliateLinkResponseDescriptor instead')
const DeleteAffiliateLinkResponse$json = {
  '1': 'DeleteAffiliateLinkResponse',
  '2': [
    {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
  ],
};

/// Descriptor for `DeleteAffiliateLinkResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deleteAffiliateLinkResponseDescriptor =
    $convert.base64Decode(
        'ChtEZWxldGVBZmZpbGlhdGVMaW5rUmVzcG9uc2USGAoHc3VjY2VzcxgBIAEoCFIHc3VjY2Vzcw'
        '==');

@$core.Deprecated('Use pauseAffiliateLinkRequestDescriptor instead')
const PauseAffiliateLinkRequest$json = {
  '1': 'PauseAffiliateLinkRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'affiliate_link_id', '3': 2, '4': 1, '5': 9, '10': 'affiliateLinkId'},
  ],
};

/// Descriptor for `PauseAffiliateLinkRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List pauseAffiliateLinkRequestDescriptor =
    $convert.base64Decode(
        'ChlQYXVzZUFmZmlsaWF0ZUxpbmtSZXF1ZXN0EiEKDHdvcmtzcGFjZV9pZBgBIAEoCVILd29ya3'
        'NwYWNlSWQSKgoRYWZmaWxpYXRlX2xpbmtfaWQYAiABKAlSD2FmZmlsaWF0ZUxpbmtJZA==');

@$core.Deprecated('Use pauseAffiliateLinkResponseDescriptor instead')
const PauseAffiliateLinkResponse$json = {
  '1': 'PauseAffiliateLinkResponse',
  '2': [
    {
      '1': 'link',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.commerce.v1.AffiliateLink',
      '10': 'link'
    },
  ],
};

/// Descriptor for `PauseAffiliateLinkResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List pauseAffiliateLinkResponseDescriptor =
    $convert.base64Decode(
        'ChpQYXVzZUFmZmlsaWF0ZUxpbmtSZXNwb25zZRI6CgRsaW5rGAEgASgLMiYuY3JlYXRpdmFudG'
        'EuY29tbWVyY2UudjEuQWZmaWxpYXRlTGlua1IEbGluaw==');

@$core.Deprecated('Use resumeAffiliateLinkRequestDescriptor instead')
const ResumeAffiliateLinkRequest$json = {
  '1': 'ResumeAffiliateLinkRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'affiliate_link_id', '3': 2, '4': 1, '5': 9, '10': 'affiliateLinkId'},
  ],
};

/// Descriptor for `ResumeAffiliateLinkRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List resumeAffiliateLinkRequestDescriptor =
    $convert.base64Decode(
        'ChpSZXN1bWVBZmZpbGlhdGVMaW5rUmVxdWVzdBIhCgx3b3Jrc3BhY2VfaWQYASABKAlSC3dvcm'
        'tzcGFjZUlkEioKEWFmZmlsaWF0ZV9saW5rX2lkGAIgASgJUg9hZmZpbGlhdGVMaW5rSWQ=');

@$core.Deprecated('Use resumeAffiliateLinkResponseDescriptor instead')
const ResumeAffiliateLinkResponse$json = {
  '1': 'ResumeAffiliateLinkResponse',
  '2': [
    {
      '1': 'link',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.commerce.v1.AffiliateLink',
      '10': 'link'
    },
  ],
};

/// Descriptor for `ResumeAffiliateLinkResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List resumeAffiliateLinkResponseDescriptor =
    $convert.base64Decode(
        'ChtSZXN1bWVBZmZpbGlhdGVMaW5rUmVzcG9uc2USOgoEbGluaxgBIAEoCzImLmNyZWF0aXZhbn'
        'RhLmNvbW1lcmNlLnYxLkFmZmlsaWF0ZUxpbmtSBGxpbms=');

@$core.Deprecated('Use getAffiliateAnalyticsRequestDescriptor instead')
const GetAffiliateAnalyticsRequest$json = {
  '1': 'GetAffiliateAnalyticsRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'affiliate_link_id', '3': 2, '4': 1, '5': 9, '10': 'affiliateLinkId'},
  ],
};

/// Descriptor for `GetAffiliateAnalyticsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getAffiliateAnalyticsRequestDescriptor =
    $convert.base64Decode(
        'ChxHZXRBZmZpbGlhdGVBbmFseXRpY3NSZXF1ZXN0EiEKDHdvcmtzcGFjZV9pZBgBIAEoCVILd2'
        '9ya3NwYWNlSWQSKgoRYWZmaWxpYXRlX2xpbmtfaWQYAiABKAlSD2FmZmlsaWF0ZUxpbmtJZA==');

@$core.Deprecated('Use getAffiliateAnalyticsResponseDescriptor instead')
const GetAffiliateAnalyticsResponse$json = {
  '1': 'GetAffiliateAnalyticsResponse',
  '2': [
    {'1': 'affiliate_link_id', '3': 1, '4': 1, '5': 9, '10': 'affiliateLinkId'},
    {'1': 'click_count', '3': 2, '4': 1, '5': 5, '10': 'clickCount'},
    {'1': 'conversion_count', '3': 3, '4': 1, '5': 5, '10': 'conversionCount'},
    {
      '1': 'revenue_attributed',
      '3': 4,
      '4': 1,
      '5': 9,
      '10': 'revenueAttributed'
    },
    {
      '1': 'total_commission_earned',
      '3': 5,
      '4': 1,
      '5': 9,
      '10': 'totalCommissionEarned'
    },
    {'1': 'currency', '3': 6, '4': 1, '5': 9, '10': 'currency'},
  ],
};

/// Descriptor for `GetAffiliateAnalyticsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getAffiliateAnalyticsResponseDescriptor = $convert.base64Decode(
    'Ch1HZXRBZmZpbGlhdGVBbmFseXRpY3NSZXNwb25zZRIqChFhZmZpbGlhdGVfbGlua19pZBgBIA'
    'EoCVIPYWZmaWxpYXRlTGlua0lkEh8KC2NsaWNrX2NvdW50GAIgASgFUgpjbGlja0NvdW50EikK'
    'EGNvbnZlcnNpb25fY291bnQYAyABKAVSD2NvbnZlcnNpb25Db3VudBItChJyZXZlbnVlX2F0dH'
    'JpYnV0ZWQYBCABKAlSEXJldmVudWVBdHRyaWJ1dGVkEjYKF3RvdGFsX2NvbW1pc3Npb25fZWFy'
    'bmVkGAUgASgJUhV0b3RhbENvbW1pc3Npb25FYXJuZWQSGgoIY3VycmVuY3kYBiABKAlSCGN1cn'
    'JlbmN5');

@$core.Deprecated('Use createAssignmentRequestDescriptor instead')
const CreateAssignmentRequest$json = {
  '1': 'CreateAssignmentRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'campaign_id', '3': 2, '4': 1, '5': 9, '10': 'campaignId'},
    {'1': 'creator_entity_id', '3': 3, '4': 1, '5': 9, '10': 'creatorEntityId'},
    {'1': 'affiliate_link_id', '3': 4, '4': 1, '5': 9, '10': 'affiliateLinkId'},
    {'1': 'coupon_id', '3': 5, '4': 1, '5': 9, '10': 'couponId'},
    {'1': 'notes', '3': 6, '4': 1, '5': 9, '10': 'notes'},
  ],
};

/// Descriptor for `CreateAssignmentRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createAssignmentRequestDescriptor = $convert.base64Decode(
    'ChdDcmVhdGVBc3NpZ25tZW50UmVxdWVzdBIhCgx3b3Jrc3BhY2VfaWQYASABKAlSC3dvcmtzcG'
    'FjZUlkEh8KC2NhbXBhaWduX2lkGAIgASgJUgpjYW1wYWlnbklkEioKEWNyZWF0b3JfZW50aXR5'
    'X2lkGAMgASgJUg9jcmVhdG9yRW50aXR5SWQSKgoRYWZmaWxpYXRlX2xpbmtfaWQYBCABKAlSD2'
    'FmZmlsaWF0ZUxpbmtJZBIbCgljb3Vwb25faWQYBSABKAlSCGNvdXBvbklkEhQKBW5vdGVzGAYg'
    'ASgJUgVub3Rlcw==');

@$core.Deprecated('Use createAssignmentResponseDescriptor instead')
const CreateAssignmentResponse$json = {
  '1': 'CreateAssignmentResponse',
  '2': [
    {
      '1': 'assignment',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.commerce.v1.CreatorAssignment',
      '10': 'assignment'
    },
  ],
};

/// Descriptor for `CreateAssignmentResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createAssignmentResponseDescriptor =
    $convert.base64Decode(
        'ChhDcmVhdGVBc3NpZ25tZW50UmVzcG9uc2USSgoKYXNzaWdubWVudBgBIAEoCzIqLmNyZWF0aX'
        'ZhbnRhLmNvbW1lcmNlLnYxLkNyZWF0b3JBc3NpZ25tZW50Ugphc3NpZ25tZW50');

@$core.Deprecated('Use listAssignmentsRequestDescriptor instead')
const ListAssignmentsRequest$json = {
  '1': 'ListAssignmentsRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'campaign_id', '3': 2, '4': 1, '5': 9, '10': 'campaignId'},
    {'1': 'creator_entity_id', '3': 3, '4': 1, '5': 9, '10': 'creatorEntityId'},
    {'1': 'page_size', '3': 4, '4': 1, '5': 5, '10': 'pageSize'},
    {'1': 'page_token', '3': 5, '4': 1, '5': 9, '10': 'pageToken'},
  ],
};

/// Descriptor for `ListAssignmentsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listAssignmentsRequestDescriptor = $convert.base64Decode(
    'ChZMaXN0QXNzaWdubWVudHNSZXF1ZXN0EiEKDHdvcmtzcGFjZV9pZBgBIAEoCVILd29ya3NwYW'
    'NlSWQSHwoLY2FtcGFpZ25faWQYAiABKAlSCmNhbXBhaWduSWQSKgoRY3JlYXRvcl9lbnRpdHlf'
    'aWQYAyABKAlSD2NyZWF0b3JFbnRpdHlJZBIbCglwYWdlX3NpemUYBCABKAVSCHBhZ2VTaXplEh'
    '0KCnBhZ2VfdG9rZW4YBSABKAlSCXBhZ2VUb2tlbg==');

@$core.Deprecated('Use listAssignmentsResponseDescriptor instead')
const ListAssignmentsResponse$json = {
  '1': 'ListAssignmentsResponse',
  '2': [
    {
      '1': 'assignments',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.creativanta.commerce.v1.CreatorAssignment',
      '10': 'assignments'
    },
    {'1': 'next_page_token', '3': 2, '4': 1, '5': 9, '10': 'nextPageToken'},
  ],
};

/// Descriptor for `ListAssignmentsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listAssignmentsResponseDescriptor = $convert.base64Decode(
    'ChdMaXN0QXNzaWdubWVudHNSZXNwb25zZRJMCgthc3NpZ25tZW50cxgBIAMoCzIqLmNyZWF0aX'
    'ZhbnRhLmNvbW1lcmNlLnYxLkNyZWF0b3JBc3NpZ25tZW50Ugthc3NpZ25tZW50cxImCg9uZXh0'
    'X3BhZ2VfdG9rZW4YAiABKAlSDW5leHRQYWdlVG9rZW4=');

@$core.Deprecated('Use updateAssignmentRequestDescriptor instead')
const UpdateAssignmentRequest$json = {
  '1': 'UpdateAssignmentRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'assignment_id', '3': 2, '4': 1, '5': 9, '10': 'assignmentId'},
    {
      '1': 'status',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.creativanta.commerce.v1.AssignmentStatus',
      '10': 'status'
    },
    {'1': 'notes', '3': 4, '4': 1, '5': 9, '10': 'notes'},
  ],
};

/// Descriptor for `UpdateAssignmentRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateAssignmentRequestDescriptor = $convert.base64Decode(
    'ChdVcGRhdGVBc3NpZ25tZW50UmVxdWVzdBIhCgx3b3Jrc3BhY2VfaWQYASABKAlSC3dvcmtzcG'
    'FjZUlkEiMKDWFzc2lnbm1lbnRfaWQYAiABKAlSDGFzc2lnbm1lbnRJZBJBCgZzdGF0dXMYAyAB'
    'KA4yKS5jcmVhdGl2YW50YS5jb21tZXJjZS52MS5Bc3NpZ25tZW50U3RhdHVzUgZzdGF0dXMSFA'
    'oFbm90ZXMYBCABKAlSBW5vdGVz');

@$core.Deprecated('Use updateAssignmentResponseDescriptor instead')
const UpdateAssignmentResponse$json = {
  '1': 'UpdateAssignmentResponse',
  '2': [
    {
      '1': 'assignment',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.commerce.v1.CreatorAssignment',
      '10': 'assignment'
    },
  ],
};

/// Descriptor for `UpdateAssignmentResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateAssignmentResponseDescriptor =
    $convert.base64Decode(
        'ChhVcGRhdGVBc3NpZ25tZW50UmVzcG9uc2USSgoKYXNzaWdubWVudBgBIAEoCzIqLmNyZWF0aX'
        'ZhbnRhLmNvbW1lcmNlLnYxLkNyZWF0b3JBc3NpZ25tZW50Ugphc3NpZ25tZW50');

@$core.Deprecated('Use recordAttributionRequestDescriptor instead')
const RecordAttributionRequest$json = {
  '1': 'RecordAttributionRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'order_id', '3': 2, '4': 1, '5': 9, '10': 'orderId'},
    {'1': 'affiliate_link_id', '3': 3, '4': 1, '5': 9, '10': 'affiliateLinkId'},
    {'1': 'creator_entity_id', '3': 4, '4': 1, '5': 9, '10': 'creatorEntityId'},
    {'1': 'click_id', '3': 5, '4': 1, '5': 9, '10': 'clickId'},
    {'1': 'touchpoint_count', '3': 6, '4': 1, '5': 5, '10': 'touchpointCount'},
    {'1': 'is_multi_touch', '3': 7, '4': 1, '5': 8, '10': 'isMultiTouch'},
    {'1': 'order_amount', '3': 8, '4': 1, '5': 9, '10': 'orderAmount'},
    {'1': 'currency', '3': 9, '4': 1, '5': 9, '10': 'currency'},
    {'1': 'is_official_api', '3': 10, '4': 1, '5': 8, '10': 'isOfficialApi'},
  ],
};

/// Descriptor for `RecordAttributionRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List recordAttributionRequestDescriptor = $convert.base64Decode(
    'ChhSZWNvcmRBdHRyaWJ1dGlvblJlcXVlc3QSIQoMd29ya3NwYWNlX2lkGAEgASgJUgt3b3Jrc3'
    'BhY2VJZBIZCghvcmRlcl9pZBgCIAEoCVIHb3JkZXJJZBIqChFhZmZpbGlhdGVfbGlua19pZBgD'
    'IAEoCVIPYWZmaWxpYXRlTGlua0lkEioKEWNyZWF0b3JfZW50aXR5X2lkGAQgASgJUg9jcmVhdG'
    '9yRW50aXR5SWQSGQoIY2xpY2tfaWQYBSABKAlSB2NsaWNrSWQSKQoQdG91Y2hwb2ludF9jb3Vu'
    'dBgGIAEoBVIPdG91Y2hwb2ludENvdW50EiQKDmlzX211bHRpX3RvdWNoGAcgASgIUgxpc011bH'
    'RpVG91Y2gSIQoMb3JkZXJfYW1vdW50GAggASgJUgtvcmRlckFtb3VudBIaCghjdXJyZW5jeRgJ'
    'IAEoCVIIY3VycmVuY3kSJgoPaXNfb2ZmaWNpYWxfYXBpGAogASgIUg1pc09mZmljaWFsQXBp');

@$core.Deprecated('Use recordAttributionResponseDescriptor instead')
const RecordAttributionResponse$json = {
  '1': 'RecordAttributionResponse',
  '2': [
    {
      '1': 'attribution',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.commerce.v1.AttributionRecord',
      '10': 'attribution'
    },
  ],
};

/// Descriptor for `RecordAttributionResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List recordAttributionResponseDescriptor =
    $convert.base64Decode(
        'ChlSZWNvcmRBdHRyaWJ1dGlvblJlc3BvbnNlEkwKC2F0dHJpYnV0aW9uGAEgASgLMiouY3JlYX'
        'RpdmFudGEuY29tbWVyY2UudjEuQXR0cmlidXRpb25SZWNvcmRSC2F0dHJpYnV0aW9u');

@$core.Deprecated('Use getAttributionReportRequestDescriptor instead')
const GetAttributionReportRequest$json = {
  '1': 'GetAttributionReportRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'affiliate_link_id', '3': 2, '4': 1, '5': 9, '10': 'affiliateLinkId'},
  ],
};

/// Descriptor for `GetAttributionReportRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getAttributionReportRequestDescriptor =
    $convert.base64Decode(
        'ChtHZXRBdHRyaWJ1dGlvblJlcG9ydFJlcXVlc3QSIQoMd29ya3NwYWNlX2lkGAEgASgJUgt3b3'
        'Jrc3BhY2VJZBIqChFhZmZpbGlhdGVfbGlua19pZBgCIAEoCVIPYWZmaWxpYXRlTGlua0lk');

@$core.Deprecated('Use getAttributionReportResponseDescriptor instead')
const GetAttributionReportResponse$json = {
  '1': 'GetAttributionReportResponse',
  '2': [
    {
      '1': 'attributions',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.creativanta.commerce.v1.AttributionRecord',
      '10': 'attributions'
    },
    {'1': 'official_count', '3': 2, '4': 1, '5': 5, '10': 'officialCount'},
    {'1': 'inferred_count', '3': 3, '4': 1, '5': 5, '10': 'inferredCount'},
    {'1': 'imported_count', '3': 4, '4': 1, '5': 5, '10': 'importedCount'},
    {
      '1': 'unreconciled_count',
      '3': 5,
      '4': 1,
      '5': 5,
      '10': 'unreconciledCount'
    },
    {
      '1': 'total_attributed_revenue',
      '3': 6,
      '4': 1,
      '5': 9,
      '10': 'totalAttributedRevenue'
    },
  ],
};

/// Descriptor for `GetAttributionReportResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getAttributionReportResponseDescriptor = $convert.base64Decode(
    'ChxHZXRBdHRyaWJ1dGlvblJlcG9ydFJlc3BvbnNlEk4KDGF0dHJpYnV0aW9ucxgBIAMoCzIqLm'
    'NyZWF0aXZhbnRhLmNvbW1lcmNlLnYxLkF0dHJpYnV0aW9uUmVjb3JkUgxhdHRyaWJ1dGlvbnMS'
    'JQoOb2ZmaWNpYWxfY291bnQYAiABKAVSDW9mZmljaWFsQ291bnQSJQoOaW5mZXJyZWRfY291bn'
    'QYAyABKAVSDWluZmVycmVkQ291bnQSJQoOaW1wb3J0ZWRfY291bnQYBCABKAVSDWltcG9ydGVk'
    'Q291bnQSLQoSdW5yZWNvbmNpbGVkX2NvdW50GAUgASgFUhF1bnJlY29uY2lsZWRDb3VudBI4Ch'
    'h0b3RhbF9hdHRyaWJ1dGVkX3JldmVudWUYBiABKAlSFnRvdGFsQXR0cmlidXRlZFJldmVudWU=');

@$core.Deprecated('Use calculateCommissionRequestDescriptor instead')
const CalculateCommissionRequest$json = {
  '1': 'CalculateCommissionRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'affiliate_link_id', '3': 2, '4': 1, '5': 9, '10': 'affiliateLinkId'},
    {'1': 'order_id', '3': 3, '4': 1, '5': 9, '10': 'orderId'},
    {'1': 'creator_entity_id', '3': 4, '4': 1, '5': 9, '10': 'creatorEntityId'},
    {'1': 'order_amount', '3': 5, '4': 1, '5': 9, '10': 'orderAmount'},
    {'1': 'currency', '3': 6, '4': 1, '5': 9, '10': 'currency'},
    {'1': 'hold_period_days', '3': 7, '4': 1, '5': 5, '10': 'holdPeriodDays'},
  ],
};

/// Descriptor for `CalculateCommissionRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List calculateCommissionRequestDescriptor = $convert.base64Decode(
    'ChpDYWxjdWxhdGVDb21taXNzaW9uUmVxdWVzdBIhCgx3b3Jrc3BhY2VfaWQYASABKAlSC3dvcm'
    'tzcGFjZUlkEioKEWFmZmlsaWF0ZV9saW5rX2lkGAIgASgJUg9hZmZpbGlhdGVMaW5rSWQSGQoI'
    'b3JkZXJfaWQYAyABKAlSB29yZGVySWQSKgoRY3JlYXRvcl9lbnRpdHlfaWQYBCABKAlSD2NyZW'
    'F0b3JFbnRpdHlJZBIhCgxvcmRlcl9hbW91bnQYBSABKAlSC29yZGVyQW1vdW50EhoKCGN1cnJl'
    'bmN5GAYgASgJUghjdXJyZW5jeRIoChBob2xkX3BlcmlvZF9kYXlzGAcgASgFUg5ob2xkUGVyaW'
    '9kRGF5cw==');

@$core.Deprecated('Use calculateCommissionResponseDescriptor instead')
const CalculateCommissionResponse$json = {
  '1': 'CalculateCommissionResponse',
  '2': [
    {
      '1': 'commission',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.commerce.v1.AffiliateCommission',
      '10': 'commission'
    },
  ],
};

/// Descriptor for `CalculateCommissionResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List calculateCommissionResponseDescriptor =
    $convert.base64Decode(
        'ChtDYWxjdWxhdGVDb21taXNzaW9uUmVzcG9uc2USTAoKY29tbWlzc2lvbhgBIAEoCzIsLmNyZW'
        'F0aXZhbnRhLmNvbW1lcmNlLnYxLkFmZmlsaWF0ZUNvbW1pc3Npb25SCmNvbW1pc3Npb24=');

@$core.Deprecated('Use confirmCommissionRequestDescriptor instead')
const ConfirmCommissionRequest$json = {
  '1': 'ConfirmCommissionRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'commission_id', '3': 2, '4': 1, '5': 9, '10': 'commissionId'},
  ],
};

/// Descriptor for `ConfirmCommissionRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List confirmCommissionRequestDescriptor =
    $convert.base64Decode(
        'ChhDb25maXJtQ29tbWlzc2lvblJlcXVlc3QSIQoMd29ya3NwYWNlX2lkGAEgASgJUgt3b3Jrc3'
        'BhY2VJZBIjCg1jb21taXNzaW9uX2lkGAIgASgJUgxjb21taXNzaW9uSWQ=');

@$core.Deprecated('Use confirmCommissionResponseDescriptor instead')
const ConfirmCommissionResponse$json = {
  '1': 'ConfirmCommissionResponse',
  '2': [
    {
      '1': 'commission',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.commerce.v1.AffiliateCommission',
      '10': 'commission'
    },
  ],
};

/// Descriptor for `ConfirmCommissionResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List confirmCommissionResponseDescriptor =
    $convert.base64Decode(
        'ChlDb25maXJtQ29tbWlzc2lvblJlc3BvbnNlEkwKCmNvbW1pc3Npb24YASABKAsyLC5jcmVhdG'
        'l2YW50YS5jb21tZXJjZS52MS5BZmZpbGlhdGVDb21taXNzaW9uUgpjb21taXNzaW9u');

@$core.Deprecated('Use clawbackCommissionRequestDescriptor instead')
const ClawbackCommissionRequest$json = {
  '1': 'ClawbackCommissionRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'commission_id', '3': 2, '4': 1, '5': 9, '10': 'commissionId'},
    {'1': 'reason', '3': 3, '4': 1, '5': 9, '10': 'reason'},
    {'1': 'amount', '3': 4, '4': 1, '5': 9, '10': 'amount'},
  ],
};

/// Descriptor for `ClawbackCommissionRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List clawbackCommissionRequestDescriptor = $convert.base64Decode(
    'ChlDbGF3YmFja0NvbW1pc3Npb25SZXF1ZXN0EiEKDHdvcmtzcGFjZV9pZBgBIAEoCVILd29ya3'
    'NwYWNlSWQSIwoNY29tbWlzc2lvbl9pZBgCIAEoCVIMY29tbWlzc2lvbklkEhYKBnJlYXNvbhgD'
    'IAEoCVIGcmVhc29uEhYKBmFtb3VudBgEIAEoCVIGYW1vdW50');

@$core.Deprecated('Use clawbackCommissionResponseDescriptor instead')
const ClawbackCommissionResponse$json = {
  '1': 'ClawbackCommissionResponse',
  '2': [
    {
      '1': 'commission',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.commerce.v1.AffiliateCommission',
      '10': 'commission'
    },
  ],
};

/// Descriptor for `ClawbackCommissionResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List clawbackCommissionResponseDescriptor =
    $convert.base64Decode(
        'ChpDbGF3YmFja0NvbW1pc3Npb25SZXNwb25zZRJMCgpjb21taXNzaW9uGAEgASgLMiwuY3JlYX'
        'RpdmFudGEuY29tbWVyY2UudjEuQWZmaWxpYXRlQ29tbWlzc2lvblIKY29tbWlzc2lvbg==');

@$core.Deprecated('Use listCommissionsRequestDescriptor instead')
const ListCommissionsRequest$json = {
  '1': 'ListCommissionsRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'affiliate_link_id', '3': 2, '4': 1, '5': 9, '10': 'affiliateLinkId'},
    {
      '1': 'status',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.creativanta.commerce.v1.CommissionStatus',
      '10': 'status'
    },
    {'1': 'page_size', '3': 4, '4': 1, '5': 5, '10': 'pageSize'},
    {'1': 'page_token', '3': 5, '4': 1, '5': 9, '10': 'pageToken'},
  ],
};

/// Descriptor for `ListCommissionsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listCommissionsRequestDescriptor = $convert.base64Decode(
    'ChZMaXN0Q29tbWlzc2lvbnNSZXF1ZXN0EiEKDHdvcmtzcGFjZV9pZBgBIAEoCVILd29ya3NwYW'
    'NlSWQSKgoRYWZmaWxpYXRlX2xpbmtfaWQYAiABKAlSD2FmZmlsaWF0ZUxpbmtJZBJBCgZzdGF0'
    'dXMYAyABKA4yKS5jcmVhdGl2YW50YS5jb21tZXJjZS52MS5Db21taXNzaW9uU3RhdHVzUgZzdG'
    'F0dXMSGwoJcGFnZV9zaXplGAQgASgFUghwYWdlU2l6ZRIdCgpwYWdlX3Rva2VuGAUgASgJUglw'
    'YWdlVG9rZW4=');

@$core.Deprecated('Use listCommissionsResponseDescriptor instead')
const ListCommissionsResponse$json = {
  '1': 'ListCommissionsResponse',
  '2': [
    {
      '1': 'commissions',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.creativanta.commerce.v1.AffiliateCommission',
      '10': 'commissions'
    },
    {'1': 'next_page_token', '3': 2, '4': 1, '5': 9, '10': 'nextPageToken'},
  ],
};

/// Descriptor for `ListCommissionsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listCommissionsResponseDescriptor = $convert.base64Decode(
    'ChdMaXN0Q29tbWlzc2lvbnNSZXNwb25zZRJOCgtjb21taXNzaW9ucxgBIAMoCzIsLmNyZWF0aX'
    'ZhbnRhLmNvbW1lcmNlLnYxLkFmZmlsaWF0ZUNvbW1pc3Npb25SC2NvbW1pc3Npb25zEiYKD25l'
    'eHRfcGFnZV90b2tlbhgCIAEoCVINbmV4dFBhZ2VUb2tlbg==');

@$core.Deprecated('Use postCommissionToLedgerRequestDescriptor instead')
const PostCommissionToLedgerRequest$json = {
  '1': 'PostCommissionToLedgerRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'commission_id', '3': 2, '4': 1, '5': 9, '10': 'commissionId'},
    {
      '1': 'economic_role',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.creativanta.commerce.v1.WorkspaceEconomicRole',
      '10': 'economicRole'
    },
  ],
};

/// Descriptor for `PostCommissionToLedgerRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List postCommissionToLedgerRequestDescriptor = $convert.base64Decode(
    'Ch1Qb3N0Q29tbWlzc2lvblRvTGVkZ2VyUmVxdWVzdBIhCgx3b3Jrc3BhY2VfaWQYASABKAlSC3'
    'dvcmtzcGFjZUlkEiMKDWNvbW1pc3Npb25faWQYAiABKAlSDGNvbW1pc3Npb25JZBJTCg1lY29u'
    'b21pY19yb2xlGAMgASgOMi4uY3JlYXRpdmFudGEuY29tbWVyY2UudjEuV29ya3NwYWNlRWNvbm'
    '9taWNSb2xlUgxlY29ub21pY1JvbGU=');

@$core.Deprecated('Use postCommissionToLedgerResponseDescriptor instead')
const PostCommissionToLedgerResponse$json = {
  '1': 'PostCommissionToLedgerResponse',
  '2': [
    {
      '1': 'result',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.commerce.v1.LedgerAffiliatePostingResult',
      '10': 'result'
    },
  ],
};

/// Descriptor for `PostCommissionToLedgerResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List postCommissionToLedgerResponseDescriptor =
    $convert.base64Decode(
        'Ch5Qb3N0Q29tbWlzc2lvblRvTGVkZ2VyUmVzcG9uc2USTQoGcmVzdWx0GAEgASgLMjUuY3JlYX'
        'RpdmFudGEuY29tbWVyY2UudjEuTGVkZ2VyQWZmaWxpYXRlUG9zdGluZ1Jlc3VsdFIGcmVzdWx0');

@$core.Deprecated('Use createPayoutBatchRequestDescriptor instead')
const CreatePayoutBatchRequest$json = {
  '1': 'CreatePayoutBatchRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'creator_entity_id', '3': 2, '4': 1, '5': 9, '10': 'creatorEntityId'},
    {'1': 'commission_ids', '3': 3, '4': 3, '5': 9, '10': 'commissionIds'},
  ],
};

/// Descriptor for `CreatePayoutBatchRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createPayoutBatchRequestDescriptor = $convert.base64Decode(
    'ChhDcmVhdGVQYXlvdXRCYXRjaFJlcXVlc3QSIQoMd29ya3NwYWNlX2lkGAEgASgJUgt3b3Jrc3'
    'BhY2VJZBIqChFjcmVhdG9yX2VudGl0eV9pZBgCIAEoCVIPY3JlYXRvckVudGl0eUlkEiUKDmNv'
    'bW1pc3Npb25faWRzGAMgAygJUg1jb21taXNzaW9uSWRz');

@$core.Deprecated('Use createPayoutBatchResponseDescriptor instead')
const CreatePayoutBatchResponse$json = {
  '1': 'CreatePayoutBatchResponse',
  '2': [
    {
      '1': 'payout',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.commerce.v1.AffiliatePayout',
      '10': 'payout'
    },
  ],
};

/// Descriptor for `CreatePayoutBatchResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createPayoutBatchResponseDescriptor =
    $convert.base64Decode(
        'ChlDcmVhdGVQYXlvdXRCYXRjaFJlc3BvbnNlEkAKBnBheW91dBgBIAEoCzIoLmNyZWF0aXZhbn'
        'RhLmNvbW1lcmNlLnYxLkFmZmlsaWF0ZVBheW91dFIGcGF5b3V0');

@$core.Deprecated('Use executePayoutBatchRequestDescriptor instead')
const ExecutePayoutBatchRequest$json = {
  '1': 'ExecutePayoutBatchRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'payout_id', '3': 2, '4': 1, '5': 9, '10': 'payoutId'},
    {'1': 'settlement_id', '3': 3, '4': 1, '5': 9, '10': 'settlementId'},
  ],
};

/// Descriptor for `ExecutePayoutBatchRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List executePayoutBatchRequestDescriptor = $convert.base64Decode(
    'ChlFeGVjdXRlUGF5b3V0QmF0Y2hSZXF1ZXN0EiEKDHdvcmtzcGFjZV9pZBgBIAEoCVILd29ya3'
    'NwYWNlSWQSGwoJcGF5b3V0X2lkGAIgASgJUghwYXlvdXRJZBIjCg1zZXR0bGVtZW50X2lkGAMg'
    'ASgJUgxzZXR0bGVtZW50SWQ=');

@$core.Deprecated('Use executePayoutBatchResponseDescriptor instead')
const ExecutePayoutBatchResponse$json = {
  '1': 'ExecutePayoutBatchResponse',
  '2': [
    {
      '1': 'payout',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.commerce.v1.AffiliatePayout',
      '10': 'payout'
    },
  ],
};

/// Descriptor for `ExecutePayoutBatchResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List executePayoutBatchResponseDescriptor =
    $convert.base64Decode(
        'ChpFeGVjdXRlUGF5b3V0QmF0Y2hSZXNwb25zZRJACgZwYXlvdXQYASABKAsyKC5jcmVhdGl2YW'
        '50YS5jb21tZXJjZS52MS5BZmZpbGlhdGVQYXlvdXRSBnBheW91dA==');

@$core.Deprecated('Use getPayoutProofRequestDescriptor instead')
const GetPayoutProofRequest$json = {
  '1': 'GetPayoutProofRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'payout_id', '3': 2, '4': 1, '5': 9, '10': 'payoutId'},
  ],
};

/// Descriptor for `GetPayoutProofRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getPayoutProofRequestDescriptor = $convert.base64Decode(
    'ChVHZXRQYXlvdXRQcm9vZlJlcXVlc3QSIQoMd29ya3NwYWNlX2lkGAEgASgJUgt3b3Jrc3BhY2'
    'VJZBIbCglwYXlvdXRfaWQYAiABKAlSCHBheW91dElk');

@$core.Deprecated('Use getPayoutProofResponseDescriptor instead')
const GetPayoutProofResponse$json = {
  '1': 'GetPayoutProofResponse',
  '2': [
    {
      '1': 'payout',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.commerce.v1.AffiliatePayout',
      '10': 'payout'
    },
    {'1': 'proof_hash', '3': 2, '4': 1, '5': 9, '10': 'proofHash'},
    {'1': 'proof_url', '3': 3, '4': 1, '5': 9, '10': 'proofUrl'},
  ],
};

/// Descriptor for `GetPayoutProofResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getPayoutProofResponseDescriptor = $convert.base64Decode(
    'ChZHZXRQYXlvdXRQcm9vZlJlc3BvbnNlEkAKBnBheW91dBgBIAEoCzIoLmNyZWF0aXZhbnRhLm'
    'NvbW1lcmNlLnYxLkFmZmlsaWF0ZVBheW91dFIGcGF5b3V0Eh0KCnByb29mX2hhc2gYAiABKAlS'
    'CXByb29mSGFzaBIbCglwcm9vZl91cmwYAyABKAlSCHByb29mVXJs');

@$core.Deprecated('Use importStatementRequestDescriptor instead')
const ImportStatementRequest$json = {
  '1': 'ImportStatementRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'platform', '3': 2, '4': 1, '5': 9, '10': 'platform'},
    {
      '1': 'external_statement_ref',
      '3': 3,
      '4': 1,
      '5': 9,
      '10': 'externalStatementRef'
    },
    {'1': 'period_start', '3': 4, '4': 1, '5': 9, '10': 'periodStart'},
    {'1': 'period_end', '3': 5, '4': 1, '5': 9, '10': 'periodEnd'},
    {'1': 'currency', '3': 6, '4': 1, '5': 9, '10': 'currency'},
    {
      '1': 'items',
      '3': 7,
      '4': 3,
      '5': 11,
      '6': '.creativanta.commerce.v1.AffiliateStatementItem',
      '10': 'items'
    },
  ],
};

/// Descriptor for `ImportStatementRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List importStatementRequestDescriptor = $convert.base64Decode(
    'ChZJbXBvcnRTdGF0ZW1lbnRSZXF1ZXN0EiEKDHdvcmtzcGFjZV9pZBgBIAEoCVILd29ya3NwYW'
    'NlSWQSGgoIcGxhdGZvcm0YAiABKAlSCHBsYXRmb3JtEjQKFmV4dGVybmFsX3N0YXRlbWVudF9y'
    'ZWYYAyABKAlSFGV4dGVybmFsU3RhdGVtZW50UmVmEiEKDHBlcmlvZF9zdGFydBgEIAEoCVILcG'
    'VyaW9kU3RhcnQSHQoKcGVyaW9kX2VuZBgFIAEoCVIJcGVyaW9kRW5kEhoKCGN1cnJlbmN5GAYg'
    'ASgJUghjdXJyZW5jeRJFCgVpdGVtcxgHIAMoCzIvLmNyZWF0aXZhbnRhLmNvbW1lcmNlLnYxLk'
    'FmZmlsaWF0ZVN0YXRlbWVudEl0ZW1SBWl0ZW1z');

@$core.Deprecated('Use importStatementResponseDescriptor instead')
const ImportStatementResponse$json = {
  '1': 'ImportStatementResponse',
  '2': [
    {
      '1': 'statement',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.commerce.v1.AffiliateStatement',
      '10': 'statement'
    },
  ],
};

/// Descriptor for `ImportStatementResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List importStatementResponseDescriptor =
    $convert.base64Decode(
        'ChdJbXBvcnRTdGF0ZW1lbnRSZXNwb25zZRJJCglzdGF0ZW1lbnQYASABKAsyKy5jcmVhdGl2YW'
        '50YS5jb21tZXJjZS52MS5BZmZpbGlhdGVTdGF0ZW1lbnRSCXN0YXRlbWVudA==');

@$core.Deprecated('Use reconcileStatementRequestDescriptor instead')
const ReconcileStatementRequest$json = {
  '1': 'ReconcileStatementRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'statement_id', '3': 2, '4': 1, '5': 9, '10': 'statementId'},
  ],
};

/// Descriptor for `ReconcileStatementRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List reconcileStatementRequestDescriptor =
    $convert.base64Decode(
        'ChlSZWNvbmNpbGVTdGF0ZW1lbnRSZXF1ZXN0EiEKDHdvcmtzcGFjZV9pZBgBIAEoCVILd29ya3'
        'NwYWNlSWQSIQoMc3RhdGVtZW50X2lkGAIgASgJUgtzdGF0ZW1lbnRJZA==');

@$core.Deprecated('Use reconcileStatementResponseDescriptor instead')
const ReconcileStatementResponse$json = {
  '1': 'ReconcileStatementResponse',
  '2': [
    {
      '1': 'statement',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.commerce.v1.AffiliateStatement',
      '10': 'statement'
    },
    {'1': 'matched_count', '3': 2, '4': 1, '5': 5, '10': 'matchedCount'},
    {'1': 'conflict_count', '3': 3, '4': 1, '5': 5, '10': 'conflictCount'},
    {
      '1': 'unreconciled_count',
      '3': 4,
      '4': 1,
      '5': 5,
      '10': 'unreconciledCount'
    },
  ],
};

/// Descriptor for `ReconcileStatementResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List reconcileStatementResponseDescriptor = $convert.base64Decode(
    'ChpSZWNvbmNpbGVTdGF0ZW1lbnRSZXNwb25zZRJJCglzdGF0ZW1lbnQYASABKAsyKy5jcmVhdG'
    'l2YW50YS5jb21tZXJjZS52MS5BZmZpbGlhdGVTdGF0ZW1lbnRSCXN0YXRlbWVudBIjCg1tYXRj'
    'aGVkX2NvdW50GAIgASgFUgxtYXRjaGVkQ291bnQSJQoOY29uZmxpY3RfY291bnQYAyABKAVSDW'
    'NvbmZsaWN0Q291bnQSLQoSdW5yZWNvbmNpbGVkX2NvdW50GAQgASgFUhF1bnJlY29uY2lsZWRD'
    'b3VudA==');

@$core.Deprecated('Use runHealthCheckRequestDescriptor instead')
const RunHealthCheckRequest$json = {
  '1': 'RunHealthCheckRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'affiliate_link_id', '3': 2, '4': 1, '5': 9, '10': 'affiliateLinkId'},
    {
      '1': 'simulated_http_status',
      '3': 3,
      '4': 1,
      '5': 5,
      '10': 'simulatedHttpStatus'
    },
    {
      '1': 'simulated_product_status',
      '3': 4,
      '4': 1,
      '5': 9,
      '10': 'simulatedProductStatus'
    },
    {
      '1': 'simulated_commission_rate',
      '3': 5,
      '4': 1,
      '5': 9,
      '10': 'simulatedCommissionRate'
    },
  ],
};

/// Descriptor for `RunHealthCheckRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List runHealthCheckRequestDescriptor = $convert.base64Decode(
    'ChVSdW5IZWFsdGhDaGVja1JlcXVlc3QSIQoMd29ya3NwYWNlX2lkGAEgASgJUgt3b3Jrc3BhY2'
    'VJZBIqChFhZmZpbGlhdGVfbGlua19pZBgCIAEoCVIPYWZmaWxpYXRlTGlua0lkEjIKFXNpbXVs'
    'YXRlZF9odHRwX3N0YXR1cxgDIAEoBVITc2ltdWxhdGVkSHR0cFN0YXR1cxI4ChhzaW11bGF0ZW'
    'RfcHJvZHVjdF9zdGF0dXMYBCABKAlSFnNpbXVsYXRlZFByb2R1Y3RTdGF0dXMSOgoZc2ltdWxh'
    'dGVkX2NvbW1pc3Npb25fcmF0ZRgFIAEoCVIXc2ltdWxhdGVkQ29tbWlzc2lvblJhdGU=');

@$core.Deprecated('Use runHealthCheckResponseDescriptor instead')
const RunHealthCheckResponse$json = {
  '1': 'RunHealthCheckResponse',
  '2': [
    {
      '1': 'health',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.commerce.v1.LinkHealthRecord',
      '10': 'health'
    },
    {'1': 'health_degraded', '3': 2, '4': 1, '5': 8, '10': 'healthDegraded'},
  ],
};

/// Descriptor for `RunHealthCheckResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List runHealthCheckResponseDescriptor = $convert.base64Decode(
    'ChZSdW5IZWFsdGhDaGVja1Jlc3BvbnNlEkEKBmhlYWx0aBgBIAEoCzIpLmNyZWF0aXZhbnRhLm'
    'NvbW1lcmNlLnYxLkxpbmtIZWFsdGhSZWNvcmRSBmhlYWx0aBInCg9oZWFsdGhfZGVncmFkZWQY'
    'AiABKAhSDmhlYWx0aERlZ3JhZGVk');

@$core.Deprecated('Use repairBrokenLinkRequestDescriptor instead')
const RepairBrokenLinkRequest$json = {
  '1': 'RepairBrokenLinkRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'affiliate_link_id', '3': 2, '4': 1, '5': 9, '10': 'affiliateLinkId'},
    {
      '1': 'new_destination_url',
      '3': 3,
      '4': 1,
      '5': 9,
      '10': 'newDestinationUrl'
    },
    {
      '1': 'replacement_product_id',
      '3': 4,
      '4': 1,
      '5': 9,
      '10': 'replacementProductId'
    },
  ],
};

/// Descriptor for `RepairBrokenLinkRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List repairBrokenLinkRequestDescriptor = $convert.base64Decode(
    'ChdSZXBhaXJCcm9rZW5MaW5rUmVxdWVzdBIhCgx3b3Jrc3BhY2VfaWQYASABKAlSC3dvcmtzcG'
    'FjZUlkEioKEWFmZmlsaWF0ZV9saW5rX2lkGAIgASgJUg9hZmZpbGlhdGVMaW5rSWQSLgoTbmV3'
    'X2Rlc3RpbmF0aW9uX3VybBgDIAEoCVIRbmV3RGVzdGluYXRpb25VcmwSNAoWcmVwbGFjZW1lbn'
    'RfcHJvZHVjdF9pZBgEIAEoCVIUcmVwbGFjZW1lbnRQcm9kdWN0SWQ=');

@$core.Deprecated('Use repairBrokenLinkResponseDescriptor instead')
const RepairBrokenLinkResponse$json = {
  '1': 'RepairBrokenLinkResponse',
  '2': [
    {
      '1': 'link',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.commerce.v1.AffiliateLink',
      '10': 'link'
    },
    {
      '1': 'health',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.creativanta.commerce.v1.LinkHealthRecord',
      '10': 'health'
    },
  ],
};

/// Descriptor for `RepairBrokenLinkResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List repairBrokenLinkResponseDescriptor = $convert.base64Decode(
    'ChhSZXBhaXJCcm9rZW5MaW5rUmVzcG9uc2USOgoEbGluaxgBIAEoCzImLmNyZWF0aXZhbnRhLm'
    'NvbW1lcmNlLnYxLkFmZmlsaWF0ZUxpbmtSBGxpbmsSQQoGaGVhbHRoGAIgASgLMikuY3JlYXRp'
    'dmFudGEuY29tbWVyY2UudjEuTGlua0hlYWx0aFJlY29yZFIGaGVhbHRo');

@$core.Deprecated('Use getHealthReportRequestDescriptor instead')
const GetHealthReportRequest$json = {
  '1': 'GetHealthReportRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
  ],
};

/// Descriptor for `GetHealthReportRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getHealthReportRequestDescriptor =
    $convert.base64Decode(
        'ChZHZXRIZWFsdGhSZXBvcnRSZXF1ZXN0EiEKDHdvcmtzcGFjZV9pZBgBIAEoCVILd29ya3NwYW'
        'NlSWQ=');

@$core.Deprecated('Use getHealthReportResponseDescriptor instead')
const GetHealthReportResponse$json = {
  '1': 'GetHealthReportResponse',
  '2': [
    {
      '1': 'health_records',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.creativanta.commerce.v1.LinkHealthRecord',
      '10': 'healthRecords'
    },
    {'1': 'healthy_count', '3': 2, '4': 1, '5': 5, '10': 'healthyCount'},
    {'1': 'warning_count', '3': 3, '4': 1, '5': 5, '10': 'warningCount'},
    {'1': 'broken_count', '3': 4, '4': 1, '5': 5, '10': 'brokenCount'},
    {
      '1': 'total_revenue_at_risk',
      '3': 5,
      '4': 1,
      '5': 9,
      '10': 'totalRevenueAtRisk'
    },
  ],
};

/// Descriptor for `GetHealthReportResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getHealthReportResponseDescriptor = $convert.base64Decode(
    'ChdHZXRIZWFsdGhSZXBvcnRSZXNwb25zZRJQCg5oZWFsdGhfcmVjb3JkcxgBIAMoCzIpLmNyZW'
    'F0aXZhbnRhLmNvbW1lcmNlLnYxLkxpbmtIZWFsdGhSZWNvcmRSDWhlYWx0aFJlY29yZHMSIwoN'
    'aGVhbHRoeV9jb3VudBgCIAEoBVIMaGVhbHRoeUNvdW50EiMKDXdhcm5pbmdfY291bnQYAyABKA'
    'VSDHdhcm5pbmdDb3VudBIhCgxicm9rZW5fY291bnQYBCABKAVSC2Jyb2tlbkNvdW50EjEKFXRv'
    'dGFsX3JldmVudWVfYXRfcmlzaxgFIAEoCVISdG90YWxSZXZlbnVlQXRSaXNr');

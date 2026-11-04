// This is a generated file - do not edit.
//
// Generated from creativanta/commerce/v1/monetization.proto.

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

@$core.Deprecated('Use offerTypeDescriptor instead')
const OfferType$json = {
  '1': 'OfferType',
  '2': [
    {'1': 'OFFER_TYPE_UNSPECIFIED', '2': 0},
    {'1': 'OFFER_TYPE_PRODUCT_OFFER', '2': 1},
    {'1': 'OFFER_TYPE_DIGITAL_OFFER', '2': 2},
    {'1': 'OFFER_TYPE_MEMBERSHIP_OFFER', '2': 3},
    {'1': 'OFFER_TYPE_BUNDLE_OFFER', '2': 4},
    {'1': 'OFFER_TYPE_AFFILIATE_OFFER', '2': 5},
    {'1': 'OFFER_TYPE_SPONSOR_OFFER', '2': 6},
  ],
};

/// Descriptor for `OfferType`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List offerTypeDescriptor = $convert.base64Decode(
    'CglPZmZlclR5cGUSGgoWT0ZGRVJfVFlQRV9VTlNQRUNJRklFRBAAEhwKGE9GRkVSX1RZUEVfUF'
    'JPRFVDVF9PRkZFUhABEhwKGE9GRkVSX1RZUEVfRElHSVRBTF9PRkZFUhACEh8KG09GRkVSX1RZ'
    'UEVfTUVNQkVSU0hJUF9PRkZFUhADEhsKF09GRkVSX1RZUEVfQlVORExFX09GRkVSEAQSHgoaT0'
    'ZGRVJfVFlQRV9BRkZJTElBVEVfT0ZGRVIQBRIcChhPRkZFUl9UWVBFX1NQT05TT1JfT0ZGRVIQ'
    'Bg==');

@$core.Deprecated('Use offerLifecycleStateDescriptor instead')
const OfferLifecycleState$json = {
  '1': 'OfferLifecycleState',
  '2': [
    {'1': 'OFFER_LIFECYCLE_STATE_UNSPECIFIED', '2': 0},
    {'1': 'OFFER_LIFECYCLE_STATE_DRAFT', '2': 1},
    {'1': 'OFFER_LIFECYCLE_STATE_REVIEW_REQUIRED', '2': 2},
    {'1': 'OFFER_LIFECYCLE_STATE_ACTIVE', '2': 3},
    {'1': 'OFFER_LIFECYCLE_STATE_PAUSED', '2': 4},
    {'1': 'OFFER_LIFECYCLE_STATE_EXPIRED', '2': 5},
    {'1': 'OFFER_LIFECYCLE_STATE_RETIRED', '2': 6},
  ],
};

/// Descriptor for `OfferLifecycleState`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List offerLifecycleStateDescriptor = $convert.base64Decode(
    'ChNPZmZlckxpZmVjeWNsZVN0YXRlEiUKIU9GRkVSX0xJRkVDWUNMRV9TVEFURV9VTlNQRUNJRk'
    'lFRBAAEh8KG09GRkVSX0xJRkVDWUNMRV9TVEFURV9EUkFGVBABEikKJU9GRkVSX0xJRkVDWUNM'
    'RV9TVEFURV9SRVZJRVdfUkVRVUlSRUQQAhIgChxPRkZFUl9MSUZFQ1lDTEVfU1RBVEVfQUNUSV'
    'ZFEAMSIAocT0ZGRVJfTElGRUNZQ0xFX1NUQVRFX1BBVVNFRBAEEiEKHU9GRkVSX0xJRkVDWUNM'
    'RV9TVEFURV9FWFBJUkVEEAUSIQodT0ZGRVJfTElGRUNZQ0xFX1NUQVRFX1JFVElSRUQQBg==');

@$core.Deprecated('Use couponTypeDescriptor instead')
const CouponType$json = {
  '1': 'CouponType',
  '2': [
    {'1': 'COUPON_TYPE_UNSPECIFIED', '2': 0},
    {'1': 'COUPON_TYPE_PERCENTAGE', '2': 1},
    {'1': 'COUPON_TYPE_FIXED_AMOUNT', '2': 2},
    {'1': 'COUPON_TYPE_FREE_SHIPPING', '2': 3},
  ],
};

/// Descriptor for `CouponType`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List couponTypeDescriptor = $convert.base64Decode(
    'CgpDb3Vwb25UeXBlEhsKF0NPVVBPTl9UWVBFX1VOU1BFQ0lGSUVEEAASGgoWQ09VUE9OX1RZUE'
    'VfUEVSQ0VOVEFHRRABEhwKGENPVVBPTl9UWVBFX0ZJWEVEX0FNT1VOVBACEh0KGUNPVVBPTl9U'
    'WVBFX0ZSRUVfU0hJUFBJTkcQAw==');

@$core.Deprecated('Use couponLifecycleStateDescriptor instead')
const CouponLifecycleState$json = {
  '1': 'CouponLifecycleState',
  '2': [
    {'1': 'COUPON_LIFECYCLE_STATE_UNSPECIFIED', '2': 0},
    {'1': 'COUPON_LIFECYCLE_STATE_DRAFT', '2': 1},
    {'1': 'COUPON_LIFECYCLE_STATE_ACTIVE', '2': 2},
    {'1': 'COUPON_LIFECYCLE_STATE_PAUSED', '2': 3},
    {'1': 'COUPON_LIFECYCLE_STATE_EXPIRED', '2': 4},
    {'1': 'COUPON_LIFECYCLE_STATE_RETIRED', '2': 5},
    {'1': 'COUPON_LIFECYCLE_STATE_REVOKED', '2': 6},
  ],
};

/// Descriptor for `CouponLifecycleState`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List couponLifecycleStateDescriptor = $convert.base64Decode(
    'ChRDb3Vwb25MaWZlY3ljbGVTdGF0ZRImCiJDT1VQT05fTElGRUNZQ0xFX1NUQVRFX1VOU1BFQ0'
    'lGSUVEEAASIAocQ09VUE9OX0xJRkVDWUNMRV9TVEFURV9EUkFGVBABEiEKHUNPVVBPTl9MSUZF'
    'Q1lDTEVfU1RBVEVfQUNUSVZFEAISIQodQ09VUE9OX0xJRkVDWUNMRV9TVEFURV9QQVVTRUQQAx'
    'IiCh5DT1VQT05fTElGRUNZQ0xFX1NUQVRFX0VYUElSRUQQBBIiCh5DT1VQT05fTElGRUNZQ0xF'
    'X1NUQVRFX1JFVElSRUQQBRIiCh5DT1VQT05fTElGRUNZQ0xFX1NUQVRFX1JFVk9LRUQQBg==');

@$core.Deprecated('Use campaignTypeDescriptor instead')
const CampaignType$json = {
  '1': 'CampaignType',
  '2': [
    {'1': 'CAMPAIGN_TYPE_UNSPECIFIED', '2': 0},
    {'1': 'CAMPAIGN_TYPE_CONTENT', '2': 1},
    {'1': 'CAMPAIGN_TYPE_AFFILIATE', '2': 2},
    {'1': 'CAMPAIGN_TYPE_SEEDING', '2': 3},
    {'1': 'CAMPAIGN_TYPE_LIVE', '2': 4},
    {'1': 'CAMPAIGN_TYPE_BRAND_COLLAB', '2': 5},
  ],
};

/// Descriptor for `CampaignType`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List campaignTypeDescriptor = $convert.base64Decode(
    'CgxDYW1wYWlnblR5cGUSHQoZQ0FNUEFJR05fVFlQRV9VTlNQRUNJRklFRBAAEhkKFUNBTVBBSU'
    'dOX1RZUEVfQ09OVEVOVBABEhsKF0NBTVBBSUdOX1RZUEVfQUZGSUxJQVRFEAISGQoVQ0FNUEFJ'
    'R05fVFlQRV9TRUVESU5HEAMSFgoSQ0FNUEFJR05fVFlQRV9MSVZFEAQSHgoaQ0FNUEFJR05fVF'
    'lQRV9CUkFORF9DT0xMQUIQBQ==');

@$core.Deprecated('Use campaignStatusDescriptor instead')
const CampaignStatus$json = {
  '1': 'CampaignStatus',
  '2': [
    {'1': 'CAMPAIGN_STATUS_UNSPECIFIED', '2': 0},
    {'1': 'CAMPAIGN_STATUS_PLANNED', '2': 1},
    {'1': 'CAMPAIGN_STATUS_READY', '2': 2},
    {'1': 'CAMPAIGN_STATUS_LIVE', '2': 3},
    {'1': 'CAMPAIGN_STATUS_PAUSED', '2': 4},
    {'1': 'CAMPAIGN_STATUS_COMPLETED', '2': 5},
    {'1': 'CAMPAIGN_STATUS_CANCELLED', '2': 6},
  ],
};

/// Descriptor for `CampaignStatus`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List campaignStatusDescriptor = $convert.base64Decode(
    'Cg5DYW1wYWlnblN0YXR1cxIfChtDQU1QQUlHTl9TVEFUVVNfVU5TUEVDSUZJRUQQABIbChdDQU'
    '1QQUlHTl9TVEFUVVNfUExBTk5FRBABEhkKFUNBTVBBSUdOX1NUQVRVU19SRUFEWRACEhgKFENB'
    'TVBBSUdOX1NUQVRVU19MSVZFEAMSGgoWQ0FNUEFJR05fU1RBVFVTX1BBVVNFRBAEEh0KGUNBTV'
    'BBSUdOX1NUQVRVU19DT01QTEVURUQQBRIdChlDQU1QQUlHTl9TVEFUVVNfQ0FOQ0VMTEVEEAY=');

@$core.Deprecated('Use channelAvailabilityDescriptor instead')
const ChannelAvailability$json = {
  '1': 'ChannelAvailability',
  '2': [
    {'1': 'platform', '3': 1, '4': 1, '5': 9, '10': 'platform'},
    {'1': 'enabled', '3': 2, '4': 1, '5': 8, '10': 'enabled'},
  ],
};

/// Descriptor for `ChannelAvailability`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List channelAvailabilityDescriptor = $convert.base64Decode(
    'ChNDaGFubmVsQXZhaWxhYmlsaXR5EhoKCHBsYXRmb3JtGAEgASgJUghwbGF0Zm9ybRIYCgdlbm'
    'FibGVkGAIgASgIUgdlbmFibGVk');

@$core.Deprecated('Use offerDescriptor instead')
const Offer$json = {
  '1': 'Offer',
  '2': [
    {'1': 'offer_id', '3': 1, '4': 1, '5': 9, '10': 'offerId'},
    {'1': 'workspace_id', '3': 2, '4': 1, '5': 9, '10': 'workspaceId'},
    {
      '1': 'offer_type',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.creativanta.commerce.v1.OfferType',
      '10': 'offerType'
    },
    {'1': 'product_id', '3': 4, '4': 1, '5': 9, '10': 'productId'},
    {
      '1': 'product_less_declaration',
      '3': 5,
      '4': 1,
      '5': 9,
      '10': 'productLessDeclaration'
    },
    {'1': 'title', '3': 6, '4': 1, '5': 9, '10': 'title'},
    {'1': 'pricing_value', '3': 7, '4': 1, '5': 9, '10': 'pricingValue'},
    {'1': 'pricing_currency', '3': 8, '4': 1, '5': 9, '10': 'pricingCurrency'},
    {
      '1': 'pricing_logic_json',
      '3': 9,
      '4': 1,
      '5': 9,
      '10': 'pricingLogicJson'
    },
    {'1': 'cta_text', '3': 10, '4': 1, '5': 9, '10': 'ctaText'},
    {'1': 'cta_url', '3': 11, '4': 1, '5': 9, '10': 'ctaUrl'},
    {
      '1': 'channel_availability',
      '3': 12,
      '4': 3,
      '5': 11,
      '6': '.creativanta.commerce.v1.ChannelAvailability',
      '10': 'channelAvailability'
    },
    {
      '1': 'lifecycle_state',
      '3': 13,
      '4': 1,
      '5': 14,
      '6': '.creativanta.commerce.v1.OfferLifecycleState',
      '10': 'lifecycleState'
    },
    {'1': 'campaign_ids', '3': 14, '4': 3, '5': 9, '10': 'campaignIds'},
    {'1': 'metadata_json', '3': 15, '4': 1, '5': 9, '10': 'metadataJson'},
    {
      '1': 'valid_from',
      '3': 16,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'validFrom'
    },
    {
      '1': 'valid_until',
      '3': 17,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'validUntil'
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
  ],
};

/// Descriptor for `Offer`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List offerDescriptor = $convert.base64Decode(
    'CgVPZmZlchIZCghvZmZlcl9pZBgBIAEoCVIHb2ZmZXJJZBIhCgx3b3Jrc3BhY2VfaWQYAiABKA'
    'lSC3dvcmtzcGFjZUlkEkEKCm9mZmVyX3R5cGUYAyABKA4yIi5jcmVhdGl2YW50YS5jb21tZXJj'
    'ZS52MS5PZmZlclR5cGVSCW9mZmVyVHlwZRIdCgpwcm9kdWN0X2lkGAQgASgJUglwcm9kdWN0SW'
    'QSOAoYcHJvZHVjdF9sZXNzX2RlY2xhcmF0aW9uGAUgASgJUhZwcm9kdWN0TGVzc0RlY2xhcmF0'
    'aW9uEhQKBXRpdGxlGAYgASgJUgV0aXRsZRIjCg1wcmljaW5nX3ZhbHVlGAcgASgJUgxwcmljaW'
    '5nVmFsdWUSKQoQcHJpY2luZ19jdXJyZW5jeRgIIAEoCVIPcHJpY2luZ0N1cnJlbmN5EiwKEnBy'
    'aWNpbmdfbG9naWNfanNvbhgJIAEoCVIQcHJpY2luZ0xvZ2ljSnNvbhIZCghjdGFfdGV4dBgKIA'
    'EoCVIHY3RhVGV4dBIXCgdjdGFfdXJsGAsgASgJUgZjdGFVcmwSXwoUY2hhbm5lbF9hdmFpbGFi'
    'aWxpdHkYDCADKAsyLC5jcmVhdGl2YW50YS5jb21tZXJjZS52MS5DaGFubmVsQXZhaWxhYmlsaX'
    'R5UhNjaGFubmVsQXZhaWxhYmlsaXR5ElUKD2xpZmVjeWNsZV9zdGF0ZRgNIAEoDjIsLmNyZWF0'
    'aXZhbnRhLmNvbW1lcmNlLnYxLk9mZmVyTGlmZWN5Y2xlU3RhdGVSDmxpZmVjeWNsZVN0YXRlEi'
    'EKDGNhbXBhaWduX2lkcxgOIAMoCVILY2FtcGFpZ25JZHMSIwoNbWV0YWRhdGFfanNvbhgPIAEo'
    'CVIMbWV0YWRhdGFKc29uEjkKCnZhbGlkX2Zyb20YECABKAsyGi5nb29nbGUucHJvdG9idWYuVG'
    'ltZXN0YW1wUgl2YWxpZEZyb20SOwoLdmFsaWRfdW50aWwYESABKAsyGi5nb29nbGUucHJvdG9i'
    'dWYuVGltZXN0YW1wUgp2YWxpZFVudGlsEjkKCmNyZWF0ZWRfYXQYEiABKAsyGi5nb29nbGUucH'
    'JvdG9idWYuVGltZXN0YW1wUgljcmVhdGVkQXQSOQoKdXBkYXRlZF9hdBgTIAEoCzIaLmdvb2ds'
    'ZS5wcm90b2J1Zi5UaW1lc3RhbXBSCXVwZGF0ZWRBdA==');

@$core.Deprecated('Use couponDescriptor instead')
const Coupon$json = {
  '1': 'Coupon',
  '2': [
    {'1': 'coupon_id', '3': 1, '4': 1, '5': 9, '10': 'couponId'},
    {'1': 'workspace_id', '3': 2, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'code', '3': 3, '4': 1, '5': 9, '10': 'code'},
    {
      '1': 'coupon_type',
      '3': 4,
      '4': 1,
      '5': 14,
      '6': '.creativanta.commerce.v1.CouponType',
      '10': 'couponType'
    },
    {'1': 'discount_value', '3': 5, '4': 1, '5': 9, '10': 'discountValue'},
    {'1': 'min_order_amount', '3': 6, '4': 1, '5': 9, '10': 'minOrderAmount'},
    {'1': 'max_uses', '3': 7, '4': 1, '5': 5, '10': 'maxUses'},
    {'1': 'current_uses', '3': 8, '4': 1, '5': 5, '10': 'currentUses'},
    {
      '1': 'lifecycle_state',
      '3': 9,
      '4': 1,
      '5': 14,
      '6': '.creativanta.commerce.v1.CouponLifecycleState',
      '10': 'lifecycleState'
    },
    {
      '1': 'related_offer_ids',
      '3': 10,
      '4': 3,
      '5': 9,
      '10': 'relatedOfferIds'
    },
    {
      '1': 'related_campaign_ids',
      '3': 11,
      '4': 3,
      '5': 9,
      '10': 'relatedCampaignIds'
    },
    {
      '1': 'valid_from',
      '3': 12,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'validFrom'
    },
    {
      '1': 'valid_until',
      '3': 13,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'validUntil'
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

/// Descriptor for `Coupon`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List couponDescriptor = $convert.base64Decode(
    'CgZDb3Vwb24SGwoJY291cG9uX2lkGAEgASgJUghjb3Vwb25JZBIhCgx3b3Jrc3BhY2VfaWQYAi'
    'ABKAlSC3dvcmtzcGFjZUlkEhIKBGNvZGUYAyABKAlSBGNvZGUSRAoLY291cG9uX3R5cGUYBCAB'
    'KA4yIy5jcmVhdGl2YW50YS5jb21tZXJjZS52MS5Db3Vwb25UeXBlUgpjb3Vwb25UeXBlEiUKDm'
    'Rpc2NvdW50X3ZhbHVlGAUgASgJUg1kaXNjb3VudFZhbHVlEigKEG1pbl9vcmRlcl9hbW91bnQY'
    'BiABKAlSDm1pbk9yZGVyQW1vdW50EhkKCG1heF91c2VzGAcgASgFUgdtYXhVc2VzEiEKDGN1cn'
    'JlbnRfdXNlcxgIIAEoBVILY3VycmVudFVzZXMSVgoPbGlmZWN5Y2xlX3N0YXRlGAkgASgOMi0u'
    'Y3JlYXRpdmFudGEuY29tbWVyY2UudjEuQ291cG9uTGlmZWN5Y2xlU3RhdGVSDmxpZmVjeWNsZV'
    'N0YXRlEioKEXJlbGF0ZWRfb2ZmZXJfaWRzGAogAygJUg9yZWxhdGVkT2ZmZXJJZHMSMAoUcmVs'
    'YXRlZF9jYW1wYWlnbl9pZHMYCyADKAlSEnJlbGF0ZWRDYW1wYWlnbklkcxI5Cgp2YWxpZF9mcm'
    '9tGAwgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIJdmFsaWRGcm9tEjsKC3ZhbGlk'
    'X3VudGlsGA0gASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIKdmFsaWRVbnRpbBI5Cg'
    'pjcmVhdGVkX2F0GA4gASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIJY3JlYXRlZEF0'
    'EjkKCnVwZGF0ZWRfYXQYDyABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUgl1cGRhdG'
    'VkQXQ=');

@$core.Deprecated('Use campaignDescriptor instead')
const Campaign$json = {
  '1': 'Campaign',
  '2': [
    {'1': 'campaign_id', '3': 1, '4': 1, '5': 9, '10': 'campaignId'},
    {'1': 'workspace_id', '3': 2, '4': 1, '5': 9, '10': 'workspaceId'},
    {
      '1': 'campaign_type',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.creativanta.commerce.v1.CampaignType',
      '10': 'campaignType'
    },
    {'1': 'title', '3': 4, '4': 1, '5': 9, '10': 'title'},
    {'1': 'objective', '3': 5, '4': 1, '5': 9, '10': 'objective'},
    {
      '1': 'status',
      '3': 6,
      '4': 1,
      '5': 14,
      '6': '.creativanta.commerce.v1.CampaignStatus',
      '10': 'status'
    },
    {'1': 'start_date', '3': 7, '4': 1, '5': 9, '10': 'startDate'},
    {'1': 'end_date', '3': 8, '4': 1, '5': 9, '10': 'endDate'},
    {'1': 'budget', '3': 9, '4': 1, '5': 9, '10': 'budget'},
    {'1': 'budget_currency', '3': 10, '4': 1, '5': 9, '10': 'budgetCurrency'},
    {
      '1': 'related_product_ids',
      '3': 11,
      '4': 3,
      '5': 9,
      '10': 'relatedProductIds'
    },
    {
      '1': 'related_offer_ids',
      '3': 12,
      '4': 3,
      '5': 9,
      '10': 'relatedOfferIds'
    },
    {'1': 'metadata_json', '3': 13, '4': 1, '5': 9, '10': 'metadataJson'},
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

/// Descriptor for `Campaign`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List campaignDescriptor = $convert.base64Decode(
    'CghDYW1wYWlnbhIfCgtjYW1wYWlnbl9pZBgBIAEoCVIKY2FtcGFpZ25JZBIhCgx3b3Jrc3BhY2'
    'VfaWQYAiABKAlSC3dvcmtzcGFjZUlkEkoKDWNhbXBhaWduX3R5cGUYAyABKA4yJS5jcmVhdGl2'
    'YW50YS5jb21tZXJjZS52MS5DYW1wYWlnblR5cGVSDGNhbXBhaWduVHlwZRIUCgV0aXRsZRgEIA'
    'EoCVIFdGl0bGUSHAoJb2JqZWN0aXZlGAUgASgJUglvYmplY3RpdmUSPwoGc3RhdHVzGAYgASgO'
    'MicuY3JlYXRpdmFudGEuY29tbWVyY2UudjEuQ2FtcGFpZ25TdGF0dXNSBnN0YXR1cxIdCgpzdG'
    'FydF9kYXRlGAcgASgJUglzdGFydERhdGUSGQoIZW5kX2RhdGUYCCABKAlSB2VuZERhdGUSFgoG'
    'YnVkZ2V0GAkgASgJUgZidWRnZXQSJwoPYnVkZ2V0X2N1cnJlbmN5GAogASgJUg5idWRnZXRDdX'
    'JyZW5jeRIuChNyZWxhdGVkX3Byb2R1Y3RfaWRzGAsgAygJUhFyZWxhdGVkUHJvZHVjdElkcxIq'
    'ChFyZWxhdGVkX29mZmVyX2lkcxgMIAMoCVIPcmVsYXRlZE9mZmVySWRzEiMKDW1ldGFkYXRhX2'
    'pzb24YDSABKAlSDG1ldGFkYXRhSnNvbhI5CgpjcmVhdGVkX2F0GA4gASgLMhouZ29vZ2xlLnBy'
    'b3RvYnVmLlRpbWVzdGFtcFIJY3JlYXRlZEF0EjkKCnVwZGF0ZWRfYXQYDyABKAsyGi5nb29nbG'
    'UucHJvdG9idWYuVGltZXN0YW1wUgl1cGRhdGVkQXQ=');

@$core.Deprecated('Use couponRedemptionDescriptor instead')
const CouponRedemption$json = {
  '1': 'CouponRedemption',
  '2': [
    {'1': 'redemption_id', '3': 1, '4': 1, '5': 9, '10': 'redemptionId'},
    {'1': 'workspace_id', '3': 2, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'coupon_id', '3': 3, '4': 1, '5': 9, '10': 'couponId'},
    {'1': 'order_id', '3': 4, '4': 1, '5': 9, '10': 'orderId'},
    {'1': 'discount_amount', '3': 5, '4': 1, '5': 9, '10': 'discountAmount'},
    {'1': 'currency', '3': 6, '4': 1, '5': 9, '10': 'currency'},
    {
      '1': 'redeemed_at',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'redeemedAt'
    },
    {'1': 'metadata_json', '3': 8, '4': 1, '5': 9, '10': 'metadataJson'},
  ],
};

/// Descriptor for `CouponRedemption`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List couponRedemptionDescriptor = $convert.base64Decode(
    'ChBDb3Vwb25SZWRlbXB0aW9uEiMKDXJlZGVtcHRpb25faWQYASABKAlSDHJlZGVtcHRpb25JZB'
    'IhCgx3b3Jrc3BhY2VfaWQYAiABKAlSC3dvcmtzcGFjZUlkEhsKCWNvdXBvbl9pZBgDIAEoCVII'
    'Y291cG9uSWQSGQoIb3JkZXJfaWQYBCABKAlSB29yZGVySWQSJwoPZGlzY291bnRfYW1vdW50GA'
    'UgASgJUg5kaXNjb3VudEFtb3VudBIaCghjdXJyZW5jeRgGIAEoCVIIY3VycmVuY3kSOwoLcmVk'
    'ZWVtZWRfYXQYByABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUgpyZWRlZW1lZEF0Ei'
    'MKDW1ldGFkYXRhX2pzb24YCCABKAlSDG1ldGFkYXRhSnNvbg==');

@$core.Deprecated('Use offerServiceCreateRequestDescriptor instead')
const OfferServiceCreateRequest$json = {
  '1': 'OfferServiceCreateRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {
      '1': 'offer_type',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.creativanta.commerce.v1.OfferType',
      '10': 'offerType'
    },
    {'1': 'product_id', '3': 3, '4': 1, '5': 9, '10': 'productId'},
    {
      '1': 'product_less_declaration',
      '3': 4,
      '4': 1,
      '5': 9,
      '10': 'productLessDeclaration'
    },
    {'1': 'title', '3': 5, '4': 1, '5': 9, '10': 'title'},
    {'1': 'pricing_value', '3': 6, '4': 1, '5': 9, '10': 'pricingValue'},
    {'1': 'pricing_currency', '3': 7, '4': 1, '5': 9, '10': 'pricingCurrency'},
    {
      '1': 'pricing_logic_json',
      '3': 8,
      '4': 1,
      '5': 9,
      '10': 'pricingLogicJson'
    },
    {'1': 'cta_text', '3': 9, '4': 1, '5': 9, '10': 'ctaText'},
    {'1': 'cta_url', '3': 10, '4': 1, '5': 9, '10': 'ctaUrl'},
    {
      '1': 'channel_availability',
      '3': 11,
      '4': 3,
      '5': 11,
      '6': '.creativanta.commerce.v1.ChannelAvailability',
      '10': 'channelAvailability'
    },
    {'1': 'campaign_ids', '3': 12, '4': 3, '5': 9, '10': 'campaignIds'},
    {'1': 'metadata_json', '3': 13, '4': 1, '5': 9, '10': 'metadataJson'},
    {
      '1': 'valid_from',
      '3': 14,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'validFrom'
    },
    {
      '1': 'valid_until',
      '3': 15,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'validUntil'
    },
    {
      '1': 'command_context',
      '3': 16,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.CommandContext',
      '10': 'commandContext'
    },
  ],
};

/// Descriptor for `OfferServiceCreateRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List offerServiceCreateRequestDescriptor = $convert.base64Decode(
    'ChlPZmZlclNlcnZpY2VDcmVhdGVSZXF1ZXN0EiEKDHdvcmtzcGFjZV9pZBgBIAEoCVILd29ya3'
    'NwYWNlSWQSQQoKb2ZmZXJfdHlwZRgCIAEoDjIiLmNyZWF0aXZhbnRhLmNvbW1lcmNlLnYxLk9m'
    'ZmVyVHlwZVIJb2ZmZXJUeXBlEh0KCnByb2R1Y3RfaWQYAyABKAlSCXByb2R1Y3RJZBI4Chhwcm'
    '9kdWN0X2xlc3NfZGVjbGFyYXRpb24YBCABKAlSFnByb2R1Y3RMZXNzRGVjbGFyYXRpb24SFAoF'
    'dGl0bGUYBSABKAlSBXRpdGxlEiMKDXByaWNpbmdfdmFsdWUYBiABKAlSDHByaWNpbmdWYWx1ZR'
    'IpChBwcmljaW5nX2N1cnJlbmN5GAcgASgJUg9wcmljaW5nQ3VycmVuY3kSLAoScHJpY2luZ19s'
    'b2dpY19qc29uGAggASgJUhBwcmljaW5nTG9naWNKc29uEhkKCGN0YV90ZXh0GAkgASgJUgdjdG'
    'FUZXh0EhcKB2N0YV91cmwYCiABKAlSBmN0YVVybBJfChRjaGFubmVsX2F2YWlsYWJpbGl0eRgL'
    'IAMoCzIsLmNyZWF0aXZhbnRhLmNvbW1lcmNlLnYxLkNoYW5uZWxBdmFpbGFiaWxpdHlSE2NoYW'
    '5uZWxBdmFpbGFiaWxpdHkSIQoMY2FtcGFpZ25faWRzGAwgAygJUgtjYW1wYWlnbklkcxIjCg1t'
    'ZXRhZGF0YV9qc29uGA0gASgJUgxtZXRhZGF0YUpzb24SOQoKdmFsaWRfZnJvbRgOIAEoCzIaLm'
    'dvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSCXZhbGlkRnJvbRI7Cgt2YWxpZF91bnRpbBgPIAEo'
    'CzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSCnZhbGlkVW50aWwSTgoPY29tbWFuZF9jb2'
    '50ZXh0GBAgASgLMiUuY3JlYXRpdmFudGEuY29tbW9uLnYxLkNvbW1hbmRDb250ZXh0Ug5jb21t'
    'YW5kQ29udGV4dA==');

@$core.Deprecated('Use offerServiceCreateResponseDescriptor instead')
const OfferServiceCreateResponse$json = {
  '1': 'OfferServiceCreateResponse',
  '2': [
    {
      '1': 'offer',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.commerce.v1.Offer',
      '10': 'offer'
    },
  ],
};

/// Descriptor for `OfferServiceCreateResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List offerServiceCreateResponseDescriptor =
    $convert.base64Decode(
        'ChpPZmZlclNlcnZpY2VDcmVhdGVSZXNwb25zZRI0CgVvZmZlchgBIAEoCzIeLmNyZWF0aXZhbn'
        'RhLmNvbW1lcmNlLnYxLk9mZmVyUgVvZmZlcg==');

@$core.Deprecated('Use offerServiceGetRequestDescriptor instead')
const OfferServiceGetRequest$json = {
  '1': 'OfferServiceGetRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'offer_id', '3': 2, '4': 1, '5': 9, '10': 'offerId'},
  ],
};

/// Descriptor for `OfferServiceGetRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List offerServiceGetRequestDescriptor =
    $convert.base64Decode(
        'ChZPZmZlclNlcnZpY2VHZXRSZXF1ZXN0EiEKDHdvcmtzcGFjZV9pZBgBIAEoCVILd29ya3NwYW'
        'NlSWQSGQoIb2ZmZXJfaWQYAiABKAlSB29mZmVySWQ=');

@$core.Deprecated('Use offerServiceGetResponseDescriptor instead')
const OfferServiceGetResponse$json = {
  '1': 'OfferServiceGetResponse',
  '2': [
    {
      '1': 'offer',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.commerce.v1.Offer',
      '10': 'offer'
    },
  ],
};

/// Descriptor for `OfferServiceGetResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List offerServiceGetResponseDescriptor =
    $convert.base64Decode(
        'ChdPZmZlclNlcnZpY2VHZXRSZXNwb25zZRI0CgVvZmZlchgBIAEoCzIeLmNyZWF0aXZhbnRhLm'
        'NvbW1lcmNlLnYxLk9mZmVyUgVvZmZlcg==');

@$core.Deprecated('Use offerServiceListRequestDescriptor instead')
const OfferServiceListRequest$json = {
  '1': 'OfferServiceListRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {
      '1': 'status',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.creativanta.commerce.v1.OfferLifecycleState',
      '10': 'status'
    },
    {'1': 'product_id', '3': 3, '4': 1, '5': 9, '10': 'productId'},
    {'1': 'query', '3': 4, '4': 1, '5': 9, '10': 'query'},
    {'1': 'sort', '3': 5, '4': 1, '5': 9, '10': 'sort'},
    {'1': 'page_size', '3': 6, '4': 1, '5': 5, '10': 'pageSize'},
    {'1': 'page_token', '3': 7, '4': 1, '5': 9, '10': 'pageToken'},
  ],
};

/// Descriptor for `OfferServiceListRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List offerServiceListRequestDescriptor = $convert.base64Decode(
    'ChdPZmZlclNlcnZpY2VMaXN0UmVxdWVzdBIhCgx3b3Jrc3BhY2VfaWQYASABKAlSC3dvcmtzcG'
    'FjZUlkEkQKBnN0YXR1cxgCIAEoDjIsLmNyZWF0aXZhbnRhLmNvbW1lcmNlLnYxLk9mZmVyTGlm'
    'ZWN5Y2xlU3RhdGVSBnN0YXR1cxIdCgpwcm9kdWN0X2lkGAMgASgJUglwcm9kdWN0SWQSFAoFcX'
    'VlcnkYBCABKAlSBXF1ZXJ5EhIKBHNvcnQYBSABKAlSBHNvcnQSGwoJcGFnZV9zaXplGAYgASgF'
    'UghwYWdlU2l6ZRIdCgpwYWdlX3Rva2VuGAcgASgJUglwYWdlVG9rZW4=');

@$core.Deprecated('Use offerServiceListResponseDescriptor instead')
const OfferServiceListResponse$json = {
  '1': 'OfferServiceListResponse',
  '2': [
    {
      '1': 'offers',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.creativanta.commerce.v1.Offer',
      '10': 'offers'
    },
    {'1': 'next_page_token', '3': 2, '4': 1, '5': 9, '10': 'nextPageToken'},
    {'1': 'total_count', '3': 3, '4': 1, '5': 5, '10': 'totalCount'},
  ],
};

/// Descriptor for `OfferServiceListResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List offerServiceListResponseDescriptor = $convert.base64Decode(
    'ChhPZmZlclNlcnZpY2VMaXN0UmVzcG9uc2USNgoGb2ZmZXJzGAEgAygLMh4uY3JlYXRpdmFudG'
    'EuY29tbWVyY2UudjEuT2ZmZXJSBm9mZmVycxImCg9uZXh0X3BhZ2VfdG9rZW4YAiABKAlSDW5l'
    'eHRQYWdlVG9rZW4SHwoLdG90YWxfY291bnQYAyABKAVSCnRvdGFsQ291bnQ=');

@$core.Deprecated('Use offerServiceUpdateRequestDescriptor instead')
const OfferServiceUpdateRequest$json = {
  '1': 'OfferServiceUpdateRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'offer_id', '3': 2, '4': 1, '5': 9, '10': 'offerId'},
    {'1': 'title', '3': 3, '4': 1, '5': 9, '10': 'title'},
    {'1': 'pricing_value', '3': 4, '4': 1, '5': 9, '10': 'pricingValue'},
    {
      '1': 'pricing_logic_json',
      '3': 5,
      '4': 1,
      '5': 9,
      '10': 'pricingLogicJson'
    },
    {'1': 'cta_text', '3': 6, '4': 1, '5': 9, '10': 'ctaText'},
    {'1': 'cta_url', '3': 7, '4': 1, '5': 9, '10': 'ctaUrl'},
    {
      '1': 'channel_availability',
      '3': 8,
      '4': 3,
      '5': 11,
      '6': '.creativanta.commerce.v1.ChannelAvailability',
      '10': 'channelAvailability'
    },
    {'1': 'campaign_ids', '3': 9, '4': 3, '5': 9, '10': 'campaignIds'},
    {'1': 'metadata_json', '3': 10, '4': 1, '5': 9, '10': 'metadataJson'},
    {
      '1': 'valid_from',
      '3': 11,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'validFrom'
    },
    {
      '1': 'valid_until',
      '3': 12,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'validUntil'
    },
    {
      '1': 'command_context',
      '3': 13,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.CommandContext',
      '10': 'commandContext'
    },
  ],
};

/// Descriptor for `OfferServiceUpdateRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List offerServiceUpdateRequestDescriptor = $convert.base64Decode(
    'ChlPZmZlclNlcnZpY2VVcGRhdGVSZXF1ZXN0EiEKDHdvcmtzcGFjZV9pZBgBIAEoCVILd29ya3'
    'NwYWNlSWQSGQoIb2ZmZXJfaWQYAiABKAlSB29mZmVySWQSFAoFdGl0bGUYAyABKAlSBXRpdGxl'
    'EiMKDXByaWNpbmdfdmFsdWUYBCABKAlSDHByaWNpbmdWYWx1ZRIsChJwcmljaW5nX2xvZ2ljX2'
    'pzb24YBSABKAlSEHByaWNpbmdMb2dpY0pzb24SGQoIY3RhX3RleHQYBiABKAlSB2N0YVRleHQS'
    'FwoHY3RhX3VybBgHIAEoCVIGY3RhVXJsEl8KFGNoYW5uZWxfYXZhaWxhYmlsaXR5GAggAygLMi'
    'wuY3JlYXRpdmFudGEuY29tbWVyY2UudjEuQ2hhbm5lbEF2YWlsYWJpbGl0eVITY2hhbm5lbEF2'
    'YWlsYWJpbGl0eRIhCgxjYW1wYWlnbl9pZHMYCSADKAlSC2NhbXBhaWduSWRzEiMKDW1ldGFkYX'
    'RhX2pzb24YCiABKAlSDG1ldGFkYXRhSnNvbhI5Cgp2YWxpZF9mcm9tGAsgASgLMhouZ29vZ2xl'
    'LnByb3RvYnVmLlRpbWVzdGFtcFIJdmFsaWRGcm9tEjsKC3ZhbGlkX3VudGlsGAwgASgLMhouZ2'
    '9vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIKdmFsaWRVbnRpbBJOCg9jb21tYW5kX2NvbnRleHQY'
    'DSABKAsyJS5jcmVhdGl2YW50YS5jb21tb24udjEuQ29tbWFuZENvbnRleHRSDmNvbW1hbmRDb2'
    '50ZXh0');

@$core.Deprecated('Use offerServiceUpdateResponseDescriptor instead')
const OfferServiceUpdateResponse$json = {
  '1': 'OfferServiceUpdateResponse',
  '2': [
    {
      '1': 'offer',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.commerce.v1.Offer',
      '10': 'offer'
    },
  ],
};

/// Descriptor for `OfferServiceUpdateResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List offerServiceUpdateResponseDescriptor =
    $convert.base64Decode(
        'ChpPZmZlclNlcnZpY2VVcGRhdGVSZXNwb25zZRI0CgVvZmZlchgBIAEoCzIeLmNyZWF0aXZhbn'
        'RhLmNvbW1lcmNlLnYxLk9mZmVyUgVvZmZlcg==');

@$core.Deprecated('Use offerServiceActivateRequestDescriptor instead')
const OfferServiceActivateRequest$json = {
  '1': 'OfferServiceActivateRequest',
  '2': [
    {'1': 'idempotency_key', '3': 1, '4': 1, '5': 9, '10': 'idempotencyKey'},
    {'1': 'workspace_id', '3': 2, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'offer_id', '3': 3, '4': 1, '5': 9, '10': 'offerId'},
    {
      '1': 'command_context',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.CommandContext',
      '10': 'commandContext'
    },
  ],
};

/// Descriptor for `OfferServiceActivateRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List offerServiceActivateRequestDescriptor = $convert.base64Decode(
    'ChtPZmZlclNlcnZpY2VBY3RpdmF0ZVJlcXVlc3QSJwoPaWRlbXBvdGVuY3lfa2V5GAEgASgJUg'
    '5pZGVtcG90ZW5jeUtleRIhCgx3b3Jrc3BhY2VfaWQYAiABKAlSC3dvcmtzcGFjZUlkEhkKCG9m'
    'ZmVyX2lkGAMgASgJUgdvZmZlcklkEk4KD2NvbW1hbmRfY29udGV4dBgEIAEoCzIlLmNyZWF0aX'
    'ZhbnRhLmNvbW1vbi52MS5Db21tYW5kQ29udGV4dFIOY29tbWFuZENvbnRleHQ=');

@$core.Deprecated('Use offerServiceActivateResponseDescriptor instead')
const OfferServiceActivateResponse$json = {
  '1': 'OfferServiceActivateResponse',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'lifecycle_state', '3': 2, '4': 1, '5': 9, '10': 'lifecycleState'},
    {
      '1': 'activated_at',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'activatedAt'
    },
    {'1': 'activated_by', '3': 4, '4': 1, '5': 9, '10': 'activatedBy'},
    {
      '1': 'expires_at',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'expiresAt'
    },
    {
      '1': 'offer',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.creativanta.commerce.v1.Offer',
      '10': 'offer'
    },
  ],
};

/// Descriptor for `OfferServiceActivateResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List offerServiceActivateResponseDescriptor = $convert.base64Decode(
    'ChxPZmZlclNlcnZpY2VBY3RpdmF0ZVJlc3BvbnNlEg4KAmlkGAEgASgJUgJpZBInCg9saWZlY3'
    'ljbGVfc3RhdGUYAiABKAlSDmxpZmVjeWNsZVN0YXRlEj0KDGFjdGl2YXRlZF9hdBgDIAEoCzIa'
    'Lmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSC2FjdGl2YXRlZEF0EiEKDGFjdGl2YXRlZF9ieR'
    'gEIAEoCVILYWN0aXZhdGVkQnkSOQoKZXhwaXJlc19hdBgFIAEoCzIaLmdvb2dsZS5wcm90b2J1'
    'Zi5UaW1lc3RhbXBSCWV4cGlyZXNBdBI0CgVvZmZlchgGIAEoCzIeLmNyZWF0aXZhbnRhLmNvbW'
    '1lcmNlLnYxLk9mZmVyUgVvZmZlcg==');

@$core.Deprecated('Use offerServicePauseRequestDescriptor instead')
const OfferServicePauseRequest$json = {
  '1': 'OfferServicePauseRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'offer_id', '3': 2, '4': 1, '5': 9, '10': 'offerId'},
    {
      '1': 'command_context',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.CommandContext',
      '10': 'commandContext'
    },
  ],
};

/// Descriptor for `OfferServicePauseRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List offerServicePauseRequestDescriptor = $convert.base64Decode(
    'ChhPZmZlclNlcnZpY2VQYXVzZVJlcXVlc3QSIQoMd29ya3NwYWNlX2lkGAEgASgJUgt3b3Jrc3'
    'BhY2VJZBIZCghvZmZlcl9pZBgCIAEoCVIHb2ZmZXJJZBJOCg9jb21tYW5kX2NvbnRleHQYAyAB'
    'KAsyJS5jcmVhdGl2YW50YS5jb21tb24udjEuQ29tbWFuZENvbnRleHRSDmNvbW1hbmRDb250ZX'
    'h0');

@$core.Deprecated('Use offerServicePauseResponseDescriptor instead')
const OfferServicePauseResponse$json = {
  '1': 'OfferServicePauseResponse',
  '2': [
    {
      '1': 'offer',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.commerce.v1.Offer',
      '10': 'offer'
    },
  ],
};

/// Descriptor for `OfferServicePauseResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List offerServicePauseResponseDescriptor =
    $convert.base64Decode(
        'ChlPZmZlclNlcnZpY2VQYXVzZVJlc3BvbnNlEjQKBW9mZmVyGAEgASgLMh4uY3JlYXRpdmFudG'
        'EuY29tbWVyY2UudjEuT2ZmZXJSBW9mZmVy');

@$core.Deprecated('Use offerServiceResumeRequestDescriptor instead')
const OfferServiceResumeRequest$json = {
  '1': 'OfferServiceResumeRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'offer_id', '3': 2, '4': 1, '5': 9, '10': 'offerId'},
    {
      '1': 'command_context',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.CommandContext',
      '10': 'commandContext'
    },
  ],
};

/// Descriptor for `OfferServiceResumeRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List offerServiceResumeRequestDescriptor = $convert.base64Decode(
    'ChlPZmZlclNlcnZpY2VSZXN1bWVSZXF1ZXN0EiEKDHdvcmtzcGFjZV9pZBgBIAEoCVILd29ya3'
    'NwYWNlSWQSGQoIb2ZmZXJfaWQYAiABKAlSB29mZmVySWQSTgoPY29tbWFuZF9jb250ZXh0GAMg'
    'ASgLMiUuY3JlYXRpdmFudGEuY29tbW9uLnYxLkNvbW1hbmRDb250ZXh0Ug5jb21tYW5kQ29udG'
    'V4dA==');

@$core.Deprecated('Use offerServiceResumeResponseDescriptor instead')
const OfferServiceResumeResponse$json = {
  '1': 'OfferServiceResumeResponse',
  '2': [
    {
      '1': 'offer',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.commerce.v1.Offer',
      '10': 'offer'
    },
  ],
};

/// Descriptor for `OfferServiceResumeResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List offerServiceResumeResponseDescriptor =
    $convert.base64Decode(
        'ChpPZmZlclNlcnZpY2VSZXN1bWVSZXNwb25zZRI0CgVvZmZlchgBIAEoCzIeLmNyZWF0aXZhbn'
        'RhLmNvbW1lcmNlLnYxLk9mZmVyUgVvZmZlcg==');

@$core.Deprecated('Use offerServiceExpireRequestDescriptor instead')
const OfferServiceExpireRequest$json = {
  '1': 'OfferServiceExpireRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'offer_id', '3': 2, '4': 1, '5': 9, '10': 'offerId'},
    {
      '1': 'command_context',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.CommandContext',
      '10': 'commandContext'
    },
  ],
};

/// Descriptor for `OfferServiceExpireRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List offerServiceExpireRequestDescriptor = $convert.base64Decode(
    'ChlPZmZlclNlcnZpY2VFeHBpcmVSZXF1ZXN0EiEKDHdvcmtzcGFjZV9pZBgBIAEoCVILd29ya3'
    'NwYWNlSWQSGQoIb2ZmZXJfaWQYAiABKAlSB29mZmVySWQSTgoPY29tbWFuZF9jb250ZXh0GAMg'
    'ASgLMiUuY3JlYXRpdmFudGEuY29tbW9uLnYxLkNvbW1hbmRDb250ZXh0Ug5jb21tYW5kQ29udG'
    'V4dA==');

@$core.Deprecated('Use offerServiceExpireResponseDescriptor instead')
const OfferServiceExpireResponse$json = {
  '1': 'OfferServiceExpireResponse',
  '2': [
    {
      '1': 'offer',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.commerce.v1.Offer',
      '10': 'offer'
    },
  ],
};

/// Descriptor for `OfferServiceExpireResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List offerServiceExpireResponseDescriptor =
    $convert.base64Decode(
        'ChpPZmZlclNlcnZpY2VFeHBpcmVSZXNwb25zZRI0CgVvZmZlchgBIAEoCzIeLmNyZWF0aXZhbn'
        'RhLmNvbW1lcmNlLnYxLk9mZmVyUgVvZmZlcg==');

@$core.Deprecated('Use offerServiceRetireRequestDescriptor instead')
const OfferServiceRetireRequest$json = {
  '1': 'OfferServiceRetireRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'offer_id', '3': 2, '4': 1, '5': 9, '10': 'offerId'},
    {
      '1': 'command_context',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.CommandContext',
      '10': 'commandContext'
    },
  ],
};

/// Descriptor for `OfferServiceRetireRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List offerServiceRetireRequestDescriptor = $convert.base64Decode(
    'ChlPZmZlclNlcnZpY2VSZXRpcmVSZXF1ZXN0EiEKDHdvcmtzcGFjZV9pZBgBIAEoCVILd29ya3'
    'NwYWNlSWQSGQoIb2ZmZXJfaWQYAiABKAlSB29mZmVySWQSTgoPY29tbWFuZF9jb250ZXh0GAMg'
    'ASgLMiUuY3JlYXRpdmFudGEuY29tbW9uLnYxLkNvbW1hbmRDb250ZXh0Ug5jb21tYW5kQ29udG'
    'V4dA==');

@$core.Deprecated('Use offerServiceRetireResponseDescriptor instead')
const OfferServiceRetireResponse$json = {
  '1': 'OfferServiceRetireResponse',
  '2': [
    {
      '1': 'offer',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.commerce.v1.Offer',
      '10': 'offer'
    },
  ],
};

/// Descriptor for `OfferServiceRetireResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List offerServiceRetireResponseDescriptor =
    $convert.base64Decode(
        'ChpPZmZlclNlcnZpY2VSZXRpcmVSZXNwb25zZRI0CgVvZmZlchgBIAEoCzIeLmNyZWF0aXZhbn'
        'RhLmNvbW1lcmNlLnYxLk9mZmVyUgVvZmZlcg==');

@$core.Deprecated('Use offerServiceDuplicateRequestDescriptor instead')
const OfferServiceDuplicateRequest$json = {
  '1': 'OfferServiceDuplicateRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'offer_id', '3': 2, '4': 1, '5': 9, '10': 'offerId'},
    {'1': 'new_title', '3': 3, '4': 1, '5': 9, '10': 'newTitle'},
    {
      '1': 'command_context',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.CommandContext',
      '10': 'commandContext'
    },
  ],
};

/// Descriptor for `OfferServiceDuplicateRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List offerServiceDuplicateRequestDescriptor = $convert.base64Decode(
    'ChxPZmZlclNlcnZpY2VEdXBsaWNhdGVSZXF1ZXN0EiEKDHdvcmtzcGFjZV9pZBgBIAEoCVILd2'
    '9ya3NwYWNlSWQSGQoIb2ZmZXJfaWQYAiABKAlSB29mZmVySWQSGwoJbmV3X3RpdGxlGAMgASgJ'
    'UghuZXdUaXRsZRJOCg9jb21tYW5kX2NvbnRleHQYBCABKAsyJS5jcmVhdGl2YW50YS5jb21tb2'
    '4udjEuQ29tbWFuZENvbnRleHRSDmNvbW1hbmRDb250ZXh0');

@$core.Deprecated('Use offerServiceDuplicateResponseDescriptor instead')
const OfferServiceDuplicateResponse$json = {
  '1': 'OfferServiceDuplicateResponse',
  '2': [
    {
      '1': 'offer',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.commerce.v1.Offer',
      '10': 'offer'
    },
  ],
};

/// Descriptor for `OfferServiceDuplicateResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List offerServiceDuplicateResponseDescriptor =
    $convert.base64Decode(
        'Ch1PZmZlclNlcnZpY2VEdXBsaWNhdGVSZXNwb25zZRI0CgVvZmZlchgBIAEoCzIeLmNyZWF0aX'
        'ZhbnRhLmNvbW1lcmNlLnYxLk9mZmVyUgVvZmZlcg==');

@$core.Deprecated('Use offerServiceDeleteRequestDescriptor instead')
const OfferServiceDeleteRequest$json = {
  '1': 'OfferServiceDeleteRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'offer_id', '3': 2, '4': 1, '5': 9, '10': 'offerId'},
    {
      '1': 'command_context',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.CommandContext',
      '10': 'commandContext'
    },
  ],
};

/// Descriptor for `OfferServiceDeleteRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List offerServiceDeleteRequestDescriptor = $convert.base64Decode(
    'ChlPZmZlclNlcnZpY2VEZWxldGVSZXF1ZXN0EiEKDHdvcmtzcGFjZV9pZBgBIAEoCVILd29ya3'
    'NwYWNlSWQSGQoIb2ZmZXJfaWQYAiABKAlSB29mZmVySWQSTgoPY29tbWFuZF9jb250ZXh0GAMg'
    'ASgLMiUuY3JlYXRpdmFudGEuY29tbW9uLnYxLkNvbW1hbmRDb250ZXh0Ug5jb21tYW5kQ29udG'
    'V4dA==');

@$core.Deprecated('Use offerServiceDeleteResponseDescriptor instead')
const OfferServiceDeleteResponse$json = {
  '1': 'OfferServiceDeleteResponse',
  '2': [
    {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
  ],
};

/// Descriptor for `OfferServiceDeleteResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List offerServiceDeleteResponseDescriptor =
    $convert.base64Decode(
        'ChpPZmZlclNlcnZpY2VEZWxldGVSZXNwb25zZRIYCgdzdWNjZXNzGAEgASgIUgdzdWNjZXNz');

@$core.Deprecated('Use offerServiceBulkPauseRequestDescriptor instead')
const OfferServiceBulkPauseRequest$json = {
  '1': 'OfferServiceBulkPauseRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'offer_ids', '3': 2, '4': 3, '5': 9, '10': 'offerIds'},
    {
      '1': 'command_context',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.CommandContext',
      '10': 'commandContext'
    },
  ],
};

/// Descriptor for `OfferServiceBulkPauseRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List offerServiceBulkPauseRequestDescriptor = $convert.base64Decode(
    'ChxPZmZlclNlcnZpY2VCdWxrUGF1c2VSZXF1ZXN0EiEKDHdvcmtzcGFjZV9pZBgBIAEoCVILd2'
    '9ya3NwYWNlSWQSGwoJb2ZmZXJfaWRzGAIgAygJUghvZmZlcklkcxJOCg9jb21tYW5kX2NvbnRl'
    'eHQYAyABKAsyJS5jcmVhdGl2YW50YS5jb21tb24udjEuQ29tbWFuZENvbnRleHRSDmNvbW1hbm'
    'RDb250ZXh0');

@$core.Deprecated('Use offerServiceBulkPauseResponseDescriptor instead')
const OfferServiceBulkPauseResponse$json = {
  '1': 'OfferServiceBulkPauseResponse',
  '2': [
    {'1': 'paused_count', '3': 1, '4': 1, '5': 5, '10': 'pausedCount'},
  ],
};

/// Descriptor for `OfferServiceBulkPauseResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List offerServiceBulkPauseResponseDescriptor =
    $convert.base64Decode(
        'Ch1PZmZlclNlcnZpY2VCdWxrUGF1c2VSZXNwb25zZRIhCgxwYXVzZWRfY291bnQYASABKAVSC3'
        'BhdXNlZENvdW50');

@$core.Deprecated('Use offerServiceGetPerformanceRequestDescriptor instead')
const OfferServiceGetPerformanceRequest$json = {
  '1': 'OfferServiceGetPerformanceRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'offer_id', '3': 2, '4': 1, '5': 9, '10': 'offerId'},
  ],
};

/// Descriptor for `OfferServiceGetPerformanceRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List offerServiceGetPerformanceRequestDescriptor =
    $convert.base64Decode(
        'CiFPZmZlclNlcnZpY2VHZXRQZXJmb3JtYW5jZVJlcXVlc3QSIQoMd29ya3NwYWNlX2lkGAEgAS'
        'gJUgt3b3Jrc3BhY2VJZBIZCghvZmZlcl9pZBgCIAEoCVIHb2ZmZXJJZA==');

@$core.Deprecated('Use offerServiceGetPerformanceResponseDescriptor instead')
const OfferServiceGetPerformanceResponse$json = {
  '1': 'OfferServiceGetPerformanceResponse',
  '2': [
    {'1': 'offer_id', '3': 1, '4': 1, '5': 9, '10': 'offerId'},
    {'1': 'impressions', '3': 2, '4': 1, '5': 3, '10': 'impressions'},
    {'1': 'clicks', '3': 3, '4': 1, '5': 3, '10': 'clicks'},
    {'1': 'conversions', '3': 4, '4': 1, '5': 3, '10': 'conversions'},
    {'1': 'conversion_rate', '3': 5, '4': 1, '5': 9, '10': 'conversionRate'},
    {'1': 'gross_revenue', '3': 6, '4': 1, '5': 9, '10': 'grossRevenue'},
    {'1': 'currency', '3': 7, '4': 1, '5': 9, '10': 'currency'},
  ],
};

/// Descriptor for `OfferServiceGetPerformanceResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List offerServiceGetPerformanceResponseDescriptor =
    $convert.base64Decode(
        'CiJPZmZlclNlcnZpY2VHZXRQZXJmb3JtYW5jZVJlc3BvbnNlEhkKCG9mZmVyX2lkGAEgASgJUg'
        'dvZmZlcklkEiAKC2ltcHJlc3Npb25zGAIgASgDUgtpbXByZXNzaW9ucxIWCgZjbGlja3MYAyAB'
        'KANSBmNsaWNrcxIgCgtjb252ZXJzaW9ucxgEIAEoA1ILY29udmVyc2lvbnMSJwoPY29udmVyc2'
        'lvbl9yYXRlGAUgASgJUg5jb252ZXJzaW9uUmF0ZRIjCg1ncm9zc19yZXZlbnVlGAYgASgJUgxn'
        'cm9zc1JldmVudWUSGgoIY3VycmVuY3kYByABKAlSCGN1cnJlbmN5');

@$core.Deprecated('Use offerServiceGetRedemptionStatsRequestDescriptor instead')
const OfferServiceGetRedemptionStatsRequest$json = {
  '1': 'OfferServiceGetRedemptionStatsRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'offer_id', '3': 2, '4': 1, '5': 9, '10': 'offerId'},
  ],
};

/// Descriptor for `OfferServiceGetRedemptionStatsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List offerServiceGetRedemptionStatsRequestDescriptor =
    $convert.base64Decode(
        'CiVPZmZlclNlcnZpY2VHZXRSZWRlbXB0aW9uU3RhdHNSZXF1ZXN0EiEKDHdvcmtzcGFjZV9pZB'
        'gBIAEoCVILd29ya3NwYWNlSWQSGQoIb2ZmZXJfaWQYAiABKAlSB29mZmVySWQ=');

@$core
    .Deprecated('Use offerServiceGetRedemptionStatsResponseDescriptor instead')
const OfferServiceGetRedemptionStatsResponse$json = {
  '1': 'OfferServiceGetRedemptionStatsResponse',
  '2': [
    {'1': 'offer_id', '3': 1, '4': 1, '5': 9, '10': 'offerId'},
    {
      '1': 'total_redemptions',
      '3': 2,
      '4': 1,
      '5': 3,
      '10': 'totalRedemptions'
    },
    {
      '1': 'total_discount_amount',
      '3': 3,
      '4': 1,
      '5': 9,
      '10': 'totalDiscountAmount'
    },
    {'1': 'currency', '3': 4, '4': 1, '5': 9, '10': 'currency'},
  ],
};

/// Descriptor for `OfferServiceGetRedemptionStatsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List offerServiceGetRedemptionStatsResponseDescriptor =
    $convert.base64Decode(
        'CiZPZmZlclNlcnZpY2VHZXRSZWRlbXB0aW9uU3RhdHNSZXNwb25zZRIZCghvZmZlcl9pZBgBIA'
        'EoCVIHb2ZmZXJJZBIrChF0b3RhbF9yZWRlbXB0aW9ucxgCIAEoA1IQdG90YWxSZWRlbXB0aW9u'
        'cxIyChV0b3RhbF9kaXNjb3VudF9hbW91bnQYAyABKAlSE3RvdGFsRGlzY291bnRBbW91bnQSGg'
        'oIY3VycmVuY3kYBCABKAlSCGN1cnJlbmN5');

@$core.Deprecated('Use offerServiceGetStatusCountsRequestDescriptor instead')
const OfferServiceGetStatusCountsRequest$json = {
  '1': 'OfferServiceGetStatusCountsRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
  ],
};

/// Descriptor for `OfferServiceGetStatusCountsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List offerServiceGetStatusCountsRequestDescriptor =
    $convert.base64Decode(
        'CiJPZmZlclNlcnZpY2VHZXRTdGF0dXNDb3VudHNSZXF1ZXN0EiEKDHdvcmtzcGFjZV9pZBgBIA'
        'EoCVILd29ya3NwYWNlSWQ=');

@$core.Deprecated('Use offerServiceGetStatusCountsResponseDescriptor instead')
const OfferServiceGetStatusCountsResponse$json = {
  '1': 'OfferServiceGetStatusCountsResponse',
  '2': [
    {'1': 'draft_count', '3': 1, '4': 1, '5': 5, '10': 'draftCount'},
    {
      '1': 'review_required_count',
      '3': 2,
      '4': 1,
      '5': 5,
      '10': 'reviewRequiredCount'
    },
    {'1': 'active_count', '3': 3, '4': 1, '5': 5, '10': 'activeCount'},
    {'1': 'paused_count', '3': 4, '4': 1, '5': 5, '10': 'pausedCount'},
    {'1': 'expired_count', '3': 5, '4': 1, '5': 5, '10': 'expiredCount'},
    {'1': 'retired_count', '3': 6, '4': 1, '5': 5, '10': 'retiredCount'},
  ],
};

/// Descriptor for `OfferServiceGetStatusCountsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List offerServiceGetStatusCountsResponseDescriptor =
    $convert.base64Decode(
        'CiNPZmZlclNlcnZpY2VHZXRTdGF0dXNDb3VudHNSZXNwb25zZRIfCgtkcmFmdF9jb3VudBgBIA'
        'EoBVIKZHJhZnRDb3VudBIyChVyZXZpZXdfcmVxdWlyZWRfY291bnQYAiABKAVSE3Jldmlld1Jl'
        'cXVpcmVkQ291bnQSIQoMYWN0aXZlX2NvdW50GAMgASgFUgthY3RpdmVDb3VudBIhCgxwYXVzZW'
        'RfY291bnQYBCABKAVSC3BhdXNlZENvdW50EiMKDWV4cGlyZWRfY291bnQYBSABKAVSDGV4cGly'
        'ZWRDb3VudBIjCg1yZXRpcmVkX2NvdW50GAYgASgFUgxyZXRpcmVkQ291bnQ=');

@$core.Deprecated('Use offerServiceGetTabSummaryRequestDescriptor instead')
const OfferServiceGetTabSummaryRequest$json = {
  '1': 'OfferServiceGetTabSummaryRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
  ],
};

/// Descriptor for `OfferServiceGetTabSummaryRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List offerServiceGetTabSummaryRequestDescriptor =
    $convert.base64Decode(
        'CiBPZmZlclNlcnZpY2VHZXRUYWJTdW1tYXJ5UmVxdWVzdBIhCgx3b3Jrc3BhY2VfaWQYASABKA'
        'lSC3dvcmtzcGFjZUlk');

@$core.Deprecated('Use offerServiceGetTabSummaryResponseDescriptor instead')
const OfferServiceGetTabSummaryResponse$json = {
  '1': 'OfferServiceGetTabSummaryResponse',
  '2': [
    {'1': 'active_offers', '3': 1, '4': 1, '5': 5, '10': 'activeOffers'},
    {'1': 'pending_review', '3': 2, '4': 1, '5': 5, '10': 'pendingReview'},
    {'1': 'expiring_soon', '3': 3, '4': 1, '5': 5, '10': 'expiringSoon'},
  ],
};

/// Descriptor for `OfferServiceGetTabSummaryResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List offerServiceGetTabSummaryResponseDescriptor =
    $convert.base64Decode(
        'CiFPZmZlclNlcnZpY2VHZXRUYWJTdW1tYXJ5UmVzcG9uc2USIwoNYWN0aXZlX29mZmVycxgBIA'
        'EoBVIMYWN0aXZlT2ZmZXJzEiUKDnBlbmRpbmdfcmV2aWV3GAIgASgFUg1wZW5kaW5nUmV2aWV3'
        'EiMKDWV4cGlyaW5nX3Nvb24YAyABKAVSDGV4cGlyaW5nU29vbg==');

@$core.Deprecated('Use couponServiceCreateRequestDescriptor instead')
const CouponServiceCreateRequest$json = {
  '1': 'CouponServiceCreateRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'code', '3': 2, '4': 1, '5': 9, '10': 'code'},
    {
      '1': 'coupon_type',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.creativanta.commerce.v1.CouponType',
      '10': 'couponType'
    },
    {'1': 'discount_value', '3': 4, '4': 1, '5': 9, '10': 'discountValue'},
    {'1': 'min_order_amount', '3': 5, '4': 1, '5': 9, '10': 'minOrderAmount'},
    {'1': 'max_uses', '3': 6, '4': 1, '5': 5, '10': 'maxUses'},
    {'1': 'related_offer_ids', '3': 7, '4': 3, '5': 9, '10': 'relatedOfferIds'},
    {
      '1': 'related_campaign_ids',
      '3': 8,
      '4': 3,
      '5': 9,
      '10': 'relatedCampaignIds'
    },
    {
      '1': 'valid_from',
      '3': 9,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'validFrom'
    },
    {
      '1': 'valid_until',
      '3': 10,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'validUntil'
    },
    {
      '1': 'command_context',
      '3': 11,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.CommandContext',
      '10': 'commandContext'
    },
  ],
};

/// Descriptor for `CouponServiceCreateRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List couponServiceCreateRequestDescriptor = $convert.base64Decode(
    'ChpDb3Vwb25TZXJ2aWNlQ3JlYXRlUmVxdWVzdBIhCgx3b3Jrc3BhY2VfaWQYASABKAlSC3dvcm'
    'tzcGFjZUlkEhIKBGNvZGUYAiABKAlSBGNvZGUSRAoLY291cG9uX3R5cGUYAyABKA4yIy5jcmVh'
    'dGl2YW50YS5jb21tZXJjZS52MS5Db3Vwb25UeXBlUgpjb3Vwb25UeXBlEiUKDmRpc2NvdW50X3'
    'ZhbHVlGAQgASgJUg1kaXNjb3VudFZhbHVlEigKEG1pbl9vcmRlcl9hbW91bnQYBSABKAlSDm1p'
    'bk9yZGVyQW1vdW50EhkKCG1heF91c2VzGAYgASgFUgdtYXhVc2VzEioKEXJlbGF0ZWRfb2ZmZX'
    'JfaWRzGAcgAygJUg9yZWxhdGVkT2ZmZXJJZHMSMAoUcmVsYXRlZF9jYW1wYWlnbl9pZHMYCCAD'
    'KAlSEnJlbGF0ZWRDYW1wYWlnbklkcxI5Cgp2YWxpZF9mcm9tGAkgASgLMhouZ29vZ2xlLnByb3'
    'RvYnVmLlRpbWVzdGFtcFIJdmFsaWRGcm9tEjsKC3ZhbGlkX3VudGlsGAogASgLMhouZ29vZ2xl'
    'LnByb3RvYnVmLlRpbWVzdGFtcFIKdmFsaWRVbnRpbBJOCg9jb21tYW5kX2NvbnRleHQYCyABKA'
    'syJS5jcmVhdGl2YW50YS5jb21tb24udjEuQ29tbWFuZENvbnRleHRSDmNvbW1hbmRDb250ZXh0');

@$core.Deprecated('Use couponServiceCreateResponseDescriptor instead')
const CouponServiceCreateResponse$json = {
  '1': 'CouponServiceCreateResponse',
  '2': [
    {
      '1': 'coupon',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.commerce.v1.Coupon',
      '10': 'coupon'
    },
  ],
};

/// Descriptor for `CouponServiceCreateResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List couponServiceCreateResponseDescriptor =
    $convert.base64Decode(
        'ChtDb3Vwb25TZXJ2aWNlQ3JlYXRlUmVzcG9uc2USNwoGY291cG9uGAEgASgLMh8uY3JlYXRpdm'
        'FudGEuY29tbWVyY2UudjEuQ291cG9uUgZjb3Vwb24=');

@$core.Deprecated('Use couponServiceGetRequestDescriptor instead')
const CouponServiceGetRequest$json = {
  '1': 'CouponServiceGetRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'coupon_id', '3': 2, '4': 1, '5': 9, '10': 'couponId'},
  ],
};

/// Descriptor for `CouponServiceGetRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List couponServiceGetRequestDescriptor =
    $convert.base64Decode(
        'ChdDb3Vwb25TZXJ2aWNlR2V0UmVxdWVzdBIhCgx3b3Jrc3BhY2VfaWQYASABKAlSC3dvcmtzcG'
        'FjZUlkEhsKCWNvdXBvbl9pZBgCIAEoCVIIY291cG9uSWQ=');

@$core.Deprecated('Use couponServiceGetResponseDescriptor instead')
const CouponServiceGetResponse$json = {
  '1': 'CouponServiceGetResponse',
  '2': [
    {
      '1': 'coupon',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.commerce.v1.Coupon',
      '10': 'coupon'
    },
  ],
};

/// Descriptor for `CouponServiceGetResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List couponServiceGetResponseDescriptor =
    $convert.base64Decode(
        'ChhDb3Vwb25TZXJ2aWNlR2V0UmVzcG9uc2USNwoGY291cG9uGAEgASgLMh8uY3JlYXRpdmFudG'
        'EuY29tbWVyY2UudjEuQ291cG9uUgZjb3Vwb24=');

@$core.Deprecated('Use couponServiceListRequestDescriptor instead')
const CouponServiceListRequest$json = {
  '1': 'CouponServiceListRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {
      '1': 'status',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.creativanta.commerce.v1.CouponLifecycleState',
      '10': 'status'
    },
    {'1': 'query', '3': 3, '4': 1, '5': 9, '10': 'query'},
    {'1': 'page_size', '3': 4, '4': 1, '5': 5, '10': 'pageSize'},
    {'1': 'page_token', '3': 5, '4': 1, '5': 9, '10': 'pageToken'},
  ],
};

/// Descriptor for `CouponServiceListRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List couponServiceListRequestDescriptor = $convert.base64Decode(
    'ChhDb3Vwb25TZXJ2aWNlTGlzdFJlcXVlc3QSIQoMd29ya3NwYWNlX2lkGAEgASgJUgt3b3Jrc3'
    'BhY2VJZBJFCgZzdGF0dXMYAiABKA4yLS5jcmVhdGl2YW50YS5jb21tZXJjZS52MS5Db3Vwb25M'
    'aWZlY3ljbGVTdGF0ZVIGc3RhdHVzEhQKBXF1ZXJ5GAMgASgJUgVxdWVyeRIbCglwYWdlX3Npem'
    'UYBCABKAVSCHBhZ2VTaXplEh0KCnBhZ2VfdG9rZW4YBSABKAlSCXBhZ2VUb2tlbg==');

@$core.Deprecated('Use couponServiceListResponseDescriptor instead')
const CouponServiceListResponse$json = {
  '1': 'CouponServiceListResponse',
  '2': [
    {
      '1': 'coupons',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.creativanta.commerce.v1.Coupon',
      '10': 'coupons'
    },
    {'1': 'next_page_token', '3': 2, '4': 1, '5': 9, '10': 'nextPageToken'},
    {'1': 'total_count', '3': 3, '4': 1, '5': 5, '10': 'totalCount'},
  ],
};

/// Descriptor for `CouponServiceListResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List couponServiceListResponseDescriptor = $convert.base64Decode(
    'ChlDb3Vwb25TZXJ2aWNlTGlzdFJlc3BvbnNlEjkKB2NvdXBvbnMYASADKAsyHy5jcmVhdGl2YW'
    '50YS5jb21tZXJjZS52MS5Db3Vwb25SB2NvdXBvbnMSJgoPbmV4dF9wYWdlX3Rva2VuGAIgASgJ'
    'Ug1uZXh0UGFnZVRva2VuEh8KC3RvdGFsX2NvdW50GAMgASgFUgp0b3RhbENvdW50');

@$core.Deprecated('Use orderContextDescriptor instead')
const OrderContext$json = {
  '1': 'OrderContext',
  '2': [
    {'1': 'product_ids', '3': 1, '4': 3, '5': 9, '10': 'productIds'},
    {'1': 'subtotal', '3': 2, '4': 1, '5': 9, '10': 'subtotal'},
    {'1': 'currency', '3': 3, '4': 1, '5': 9, '10': 'currency'},
  ],
};

/// Descriptor for `OrderContext`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List orderContextDescriptor = $convert.base64Decode(
    'CgxPcmRlckNvbnRleHQSHwoLcHJvZHVjdF9pZHMYASADKAlSCnByb2R1Y3RJZHMSGgoIc3VidG'
    '90YWwYAiABKAlSCHN1YnRvdGFsEhoKCGN1cnJlbmN5GAMgASgJUghjdXJyZW5jeQ==');

@$core.Deprecated('Use couponServiceValidateCouponRequestDescriptor instead')
const CouponServiceValidateCouponRequest$json = {
  '1': 'CouponServiceValidateCouponRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'code', '3': 2, '4': 1, '5': 9, '10': 'code'},
    {
      '1': 'order_context',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.creativanta.commerce.v1.OrderContext',
      '10': 'orderContext'
    },
  ],
};

/// Descriptor for `CouponServiceValidateCouponRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List couponServiceValidateCouponRequestDescriptor =
    $convert.base64Decode(
        'CiJDb3Vwb25TZXJ2aWNlVmFsaWRhdGVDb3Vwb25SZXF1ZXN0EiEKDHdvcmtzcGFjZV9pZBgBIA'
        'EoCVILd29ya3NwYWNlSWQSEgoEY29kZRgCIAEoCVIEY29kZRJKCg1vcmRlcl9jb250ZXh0GAMg'
        'ASgLMiUuY3JlYXRpdmFudGEuY29tbWVyY2UudjEuT3JkZXJDb250ZXh0UgxvcmRlckNvbnRleH'
        'Q=');

@$core.Deprecated('Use couponServiceValidateCouponResponseDescriptor instead')
const CouponServiceValidateCouponResponse$json = {
  '1': 'CouponServiceValidateCouponResponse',
  '2': [
    {'1': 'valid', '3': 1, '4': 1, '5': 8, '10': 'valid'},
    {'1': 'coupon_id', '3': 2, '4': 1, '5': 9, '10': 'couponId'},
    {'1': 'discount_type', '3': 3, '4': 1, '5': 9, '10': 'discountType'},
    {'1': 'discount_value', '3': 4, '4': 1, '5': 9, '10': 'discountValue'},
    {
      '1': 'max_discount_amount',
      '3': 5,
      '4': 1,
      '5': 9,
      '10': 'maxDiscountAmount'
    },
    {
      '1': 'calculated_discount',
      '3': 6,
      '4': 1,
      '5': 9,
      '10': 'calculatedDiscount'
    },
    {'1': 'stackable', '3': 7, '4': 1, '5': 8, '10': 'stackable'},
    {
      '1': 'expires_at',
      '3': 8,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'expiresAt'
    },
    {'1': 'remaining_uses', '3': 9, '4': 1, '5': 5, '10': 'remainingUses'},
    {'1': 'failure_reason', '3': 10, '4': 1, '5': 9, '10': 'failureReason'},
  ],
};

/// Descriptor for `CouponServiceValidateCouponResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List couponServiceValidateCouponResponseDescriptor = $convert.base64Decode(
    'CiNDb3Vwb25TZXJ2aWNlVmFsaWRhdGVDb3Vwb25SZXNwb25zZRIUCgV2YWxpZBgBIAEoCFIFdm'
    'FsaWQSGwoJY291cG9uX2lkGAIgASgJUghjb3Vwb25JZBIjCg1kaXNjb3VudF90eXBlGAMgASgJ'
    'UgxkaXNjb3VudFR5cGUSJQoOZGlzY291bnRfdmFsdWUYBCABKAlSDWRpc2NvdW50VmFsdWUSLg'
    'oTbWF4X2Rpc2NvdW50X2Ftb3VudBgFIAEoCVIRbWF4RGlzY291bnRBbW91bnQSLwoTY2FsY3Vs'
    'YXRlZF9kaXNjb3VudBgGIAEoCVISY2FsY3VsYXRlZERpc2NvdW50EhwKCXN0YWNrYWJsZRgHIA'
    'EoCFIJc3RhY2thYmxlEjkKCmV4cGlyZXNfYXQYCCABKAsyGi5nb29nbGUucHJvdG9idWYuVGlt'
    'ZXN0YW1wUglleHBpcmVzQXQSJQoOcmVtYWluaW5nX3VzZXMYCSABKAVSDXJlbWFpbmluZ1VzZX'
    'MSJQoOZmFpbHVyZV9yZWFzb24YCiABKAlSDWZhaWx1cmVSZWFzb24=');

@$core.Deprecated('Use couponServiceUpdateRequestDescriptor instead')
const CouponServiceUpdateRequest$json = {
  '1': 'CouponServiceUpdateRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'coupon_id', '3': 2, '4': 1, '5': 9, '10': 'couponId'},
    {'1': 'discount_value', '3': 3, '4': 1, '5': 9, '10': 'discountValue'},
    {'1': 'min_order_amount', '3': 4, '4': 1, '5': 9, '10': 'minOrderAmount'},
    {'1': 'max_uses', '3': 5, '4': 1, '5': 5, '10': 'maxUses'},
    {
      '1': 'valid_from',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'validFrom'
    },
    {
      '1': 'valid_until',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'validUntil'
    },
    {
      '1': 'command_context',
      '3': 8,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.CommandContext',
      '10': 'commandContext'
    },
  ],
};

/// Descriptor for `CouponServiceUpdateRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List couponServiceUpdateRequestDescriptor = $convert.base64Decode(
    'ChpDb3Vwb25TZXJ2aWNlVXBkYXRlUmVxdWVzdBIhCgx3b3Jrc3BhY2VfaWQYASABKAlSC3dvcm'
    'tzcGFjZUlkEhsKCWNvdXBvbl9pZBgCIAEoCVIIY291cG9uSWQSJQoOZGlzY291bnRfdmFsdWUY'
    'AyABKAlSDWRpc2NvdW50VmFsdWUSKAoQbWluX29yZGVyX2Ftb3VudBgEIAEoCVIObWluT3JkZX'
    'JBbW91bnQSGQoIbWF4X3VzZXMYBSABKAVSB21heFVzZXMSOQoKdmFsaWRfZnJvbRgGIAEoCzIa'
    'Lmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSCXZhbGlkRnJvbRI7Cgt2YWxpZF91bnRpbBgHIA'
    'EoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSCnZhbGlkVW50aWwSTgoPY29tbWFuZF9j'
    'b250ZXh0GAggASgLMiUuY3JlYXRpdmFudGEuY29tbW9uLnYxLkNvbW1hbmRDb250ZXh0Ug5jb2'
    '1tYW5kQ29udGV4dA==');

@$core.Deprecated('Use couponServiceUpdateResponseDescriptor instead')
const CouponServiceUpdateResponse$json = {
  '1': 'CouponServiceUpdateResponse',
  '2': [
    {
      '1': 'coupon',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.commerce.v1.Coupon',
      '10': 'coupon'
    },
  ],
};

/// Descriptor for `CouponServiceUpdateResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List couponServiceUpdateResponseDescriptor =
    $convert.base64Decode(
        'ChtDb3Vwb25TZXJ2aWNlVXBkYXRlUmVzcG9uc2USNwoGY291cG9uGAEgASgLMh8uY3JlYXRpdm'
        'FudGEuY29tbWVyY2UudjEuQ291cG9uUgZjb3Vwb24=');

@$core.Deprecated('Use couponServiceActivateRequestDescriptor instead')
const CouponServiceActivateRequest$json = {
  '1': 'CouponServiceActivateRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'coupon_id', '3': 2, '4': 1, '5': 9, '10': 'couponId'},
    {
      '1': 'command_context',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.CommandContext',
      '10': 'commandContext'
    },
  ],
};

/// Descriptor for `CouponServiceActivateRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List couponServiceActivateRequestDescriptor = $convert.base64Decode(
    'ChxDb3Vwb25TZXJ2aWNlQWN0aXZhdGVSZXF1ZXN0EiEKDHdvcmtzcGFjZV9pZBgBIAEoCVILd2'
    '9ya3NwYWNlSWQSGwoJY291cG9uX2lkGAIgASgJUghjb3Vwb25JZBJOCg9jb21tYW5kX2NvbnRl'
    'eHQYAyABKAsyJS5jcmVhdGl2YW50YS5jb21tb24udjEuQ29tbWFuZENvbnRleHRSDmNvbW1hbm'
    'RDb250ZXh0');

@$core.Deprecated('Use couponServiceActivateResponseDescriptor instead')
const CouponServiceActivateResponse$json = {
  '1': 'CouponServiceActivateResponse',
  '2': [
    {
      '1': 'coupon',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.commerce.v1.Coupon',
      '10': 'coupon'
    },
  ],
};

/// Descriptor for `CouponServiceActivateResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List couponServiceActivateResponseDescriptor =
    $convert.base64Decode(
        'Ch1Db3Vwb25TZXJ2aWNlQWN0aXZhdGVSZXNwb25zZRI3CgZjb3Vwb24YASABKAsyHy5jcmVhdG'
        'l2YW50YS5jb21tZXJjZS52MS5Db3Vwb25SBmNvdXBvbg==');

@$core.Deprecated('Use couponServicePauseRequestDescriptor instead')
const CouponServicePauseRequest$json = {
  '1': 'CouponServicePauseRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'coupon_id', '3': 2, '4': 1, '5': 9, '10': 'couponId'},
    {
      '1': 'command_context',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.CommandContext',
      '10': 'commandContext'
    },
  ],
};

/// Descriptor for `CouponServicePauseRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List couponServicePauseRequestDescriptor = $convert.base64Decode(
    'ChlDb3Vwb25TZXJ2aWNlUGF1c2VSZXF1ZXN0EiEKDHdvcmtzcGFjZV9pZBgBIAEoCVILd29ya3'
    'NwYWNlSWQSGwoJY291cG9uX2lkGAIgASgJUghjb3Vwb25JZBJOCg9jb21tYW5kX2NvbnRleHQY'
    'AyABKAsyJS5jcmVhdGl2YW50YS5jb21tb24udjEuQ29tbWFuZENvbnRleHRSDmNvbW1hbmRDb2'
    '50ZXh0');

@$core.Deprecated('Use couponServicePauseResponseDescriptor instead')
const CouponServicePauseResponse$json = {
  '1': 'CouponServicePauseResponse',
  '2': [
    {
      '1': 'coupon',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.commerce.v1.Coupon',
      '10': 'coupon'
    },
  ],
};

/// Descriptor for `CouponServicePauseResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List couponServicePauseResponseDescriptor =
    $convert.base64Decode(
        'ChpDb3Vwb25TZXJ2aWNlUGF1c2VSZXNwb25zZRI3CgZjb3Vwb24YASABKAsyHy5jcmVhdGl2YW'
        '50YS5jb21tZXJjZS52MS5Db3Vwb25SBmNvdXBvbg==');

@$core.Deprecated('Use couponServiceResumeRequestDescriptor instead')
const CouponServiceResumeRequest$json = {
  '1': 'CouponServiceResumeRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'coupon_id', '3': 2, '4': 1, '5': 9, '10': 'couponId'},
    {
      '1': 'command_context',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.CommandContext',
      '10': 'commandContext'
    },
  ],
};

/// Descriptor for `CouponServiceResumeRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List couponServiceResumeRequestDescriptor = $convert.base64Decode(
    'ChpDb3Vwb25TZXJ2aWNlUmVzdW1lUmVxdWVzdBIhCgx3b3Jrc3BhY2VfaWQYASABKAlSC3dvcm'
    'tzcGFjZUlkEhsKCWNvdXBvbl9pZBgCIAEoCVIIY291cG9uSWQSTgoPY29tbWFuZF9jb250ZXh0'
    'GAMgASgLMiUuY3JlYXRpdmFudGEuY29tbW9uLnYxLkNvbW1hbmRDb250ZXh0Ug5jb21tYW5kQ2'
    '9udGV4dA==');

@$core.Deprecated('Use couponServiceResumeResponseDescriptor instead')
const CouponServiceResumeResponse$json = {
  '1': 'CouponServiceResumeResponse',
  '2': [
    {
      '1': 'coupon',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.commerce.v1.Coupon',
      '10': 'coupon'
    },
  ],
};

/// Descriptor for `CouponServiceResumeResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List couponServiceResumeResponseDescriptor =
    $convert.base64Decode(
        'ChtDb3Vwb25TZXJ2aWNlUmVzdW1lUmVzcG9uc2USNwoGY291cG9uGAEgASgLMh8uY3JlYXRpdm'
        'FudGEuY29tbWVyY2UudjEuQ291cG9uUgZjb3Vwb24=');

@$core.Deprecated('Use couponServiceDeactivateRequestDescriptor instead')
const CouponServiceDeactivateRequest$json = {
  '1': 'CouponServiceDeactivateRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'coupon_id', '3': 2, '4': 1, '5': 9, '10': 'couponId'},
    {
      '1': 'command_context',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.CommandContext',
      '10': 'commandContext'
    },
  ],
};

/// Descriptor for `CouponServiceDeactivateRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List couponServiceDeactivateRequestDescriptor =
    $convert.base64Decode(
        'Ch5Db3Vwb25TZXJ2aWNlRGVhY3RpdmF0ZVJlcXVlc3QSIQoMd29ya3NwYWNlX2lkGAEgASgJUg'
        't3b3Jrc3BhY2VJZBIbCgljb3Vwb25faWQYAiABKAlSCGNvdXBvbklkEk4KD2NvbW1hbmRfY29u'
        'dGV4dBgDIAEoCzIlLmNyZWF0aXZhbnRhLmNvbW1vbi52MS5Db21tYW5kQ29udGV4dFIOY29tbW'
        'FuZENvbnRleHQ=');

@$core.Deprecated('Use couponServiceDeactivateResponseDescriptor instead')
const CouponServiceDeactivateResponse$json = {
  '1': 'CouponServiceDeactivateResponse',
  '2': [
    {
      '1': 'coupon',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.commerce.v1.Coupon',
      '10': 'coupon'
    },
  ],
};

/// Descriptor for `CouponServiceDeactivateResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List couponServiceDeactivateResponseDescriptor =
    $convert.base64Decode(
        'Ch9Db3Vwb25TZXJ2aWNlRGVhY3RpdmF0ZVJlc3BvbnNlEjcKBmNvdXBvbhgBIAEoCzIfLmNyZW'
        'F0aXZhbnRhLmNvbW1lcmNlLnYxLkNvdXBvblIGY291cG9u');

@$core.Deprecated('Use couponServiceRevokeRequestDescriptor instead')
const CouponServiceRevokeRequest$json = {
  '1': 'CouponServiceRevokeRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'coupon_id', '3': 2, '4': 1, '5': 9, '10': 'couponId'},
    {'1': 'reason', '3': 3, '4': 1, '5': 9, '10': 'reason'},
    {
      '1': 'command_context',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.CommandContext',
      '10': 'commandContext'
    },
  ],
};

/// Descriptor for `CouponServiceRevokeRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List couponServiceRevokeRequestDescriptor = $convert.base64Decode(
    'ChpDb3Vwb25TZXJ2aWNlUmV2b2tlUmVxdWVzdBIhCgx3b3Jrc3BhY2VfaWQYASABKAlSC3dvcm'
    'tzcGFjZUlkEhsKCWNvdXBvbl9pZBgCIAEoCVIIY291cG9uSWQSFgoGcmVhc29uGAMgASgJUgZy'
    'ZWFzb24STgoPY29tbWFuZF9jb250ZXh0GAQgASgLMiUuY3JlYXRpdmFudGEuY29tbW9uLnYxLk'
    'NvbW1hbmRDb250ZXh0Ug5jb21tYW5kQ29udGV4dA==');

@$core.Deprecated('Use couponServiceRevokeResponseDescriptor instead')
const CouponServiceRevokeResponse$json = {
  '1': 'CouponServiceRevokeResponse',
  '2': [
    {
      '1': 'coupon',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.commerce.v1.Coupon',
      '10': 'coupon'
    },
  ],
};

/// Descriptor for `CouponServiceRevokeResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List couponServiceRevokeResponseDescriptor =
    $convert.base64Decode(
        'ChtDb3Vwb25TZXJ2aWNlUmV2b2tlUmVzcG9uc2USNwoGY291cG9uGAEgASgLMh8uY3JlYXRpdm'
        'FudGEuY29tbWVyY2UudjEuQ291cG9uUgZjb3Vwb24=');

@$core.Deprecated('Use couponServiceDeleteRequestDescriptor instead')
const CouponServiceDeleteRequest$json = {
  '1': 'CouponServiceDeleteRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'coupon_id', '3': 2, '4': 1, '5': 9, '10': 'couponId'},
    {
      '1': 'command_context',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.CommandContext',
      '10': 'commandContext'
    },
  ],
};

/// Descriptor for `CouponServiceDeleteRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List couponServiceDeleteRequestDescriptor = $convert.base64Decode(
    'ChpDb3Vwb25TZXJ2aWNlRGVsZXRlUmVxdWVzdBIhCgx3b3Jrc3BhY2VfaWQYASABKAlSC3dvcm'
    'tzcGFjZUlkEhsKCWNvdXBvbl9pZBgCIAEoCVIIY291cG9uSWQSTgoPY29tbWFuZF9jb250ZXh0'
    'GAMgASgLMiUuY3JlYXRpdmFudGEuY29tbW9uLnYxLkNvbW1hbmRDb250ZXh0Ug5jb21tYW5kQ2'
    '9udGV4dA==');

@$core.Deprecated('Use couponServiceDeleteResponseDescriptor instead')
const CouponServiceDeleteResponse$json = {
  '1': 'CouponServiceDeleteResponse',
  '2': [
    {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
  ],
};

/// Descriptor for `CouponServiceDeleteResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List couponServiceDeleteResponseDescriptor =
    $convert.base64Decode(
        'ChtDb3Vwb25TZXJ2aWNlRGVsZXRlUmVzcG9uc2USGAoHc3VjY2VzcxgBIAEoCFIHc3VjY2Vzcw'
        '==');

@$core.Deprecated('Use couponServiceCheckAvailabilityRequestDescriptor instead')
const CouponServiceCheckAvailabilityRequest$json = {
  '1': 'CouponServiceCheckAvailabilityRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'code', '3': 2, '4': 1, '5': 9, '10': 'code'},
  ],
};

/// Descriptor for `CouponServiceCheckAvailabilityRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List couponServiceCheckAvailabilityRequestDescriptor =
    $convert.base64Decode(
        'CiVDb3Vwb25TZXJ2aWNlQ2hlY2tBdmFpbGFiaWxpdHlSZXF1ZXN0EiEKDHdvcmtzcGFjZV9pZB'
        'gBIAEoCVILd29ya3NwYWNlSWQSEgoEY29kZRgCIAEoCVIEY29kZQ==');

@$core
    .Deprecated('Use couponServiceCheckAvailabilityResponseDescriptor instead')
const CouponServiceCheckAvailabilityResponse$json = {
  '1': 'CouponServiceCheckAvailabilityResponse',
  '2': [
    {'1': 'available', '3': 1, '4': 1, '5': 8, '10': 'available'},
    {'1': 'remaining_uses', '3': 2, '4': 1, '5': 5, '10': 'remainingUses'},
    {
      '1': 'expires_at',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'expiresAt'
    },
  ],
};

/// Descriptor for `CouponServiceCheckAvailabilityResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List couponServiceCheckAvailabilityResponseDescriptor =
    $convert.base64Decode(
        'CiZDb3Vwb25TZXJ2aWNlQ2hlY2tBdmFpbGFiaWxpdHlSZXNwb25zZRIcCglhdmFpbGFibGUYAS'
        'ABKAhSCWF2YWlsYWJsZRIlCg5yZW1haW5pbmdfdXNlcxgCIAEoBVINcmVtYWluaW5nVXNlcxI5'
        'CgpleHBpcmVzX2F0GAMgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIJZXhwaXJlc0'
        'F0');

@$core.Deprecated('Use campaignServiceCreateRequestDescriptor instead')
const CampaignServiceCreateRequest$json = {
  '1': 'CampaignServiceCreateRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {
      '1': 'campaign_type',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.creativanta.commerce.v1.CampaignType',
      '10': 'campaignType'
    },
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
    {
      '1': 'related_offer_ids',
      '3': 10,
      '4': 3,
      '5': 9,
      '10': 'relatedOfferIds'
    },
    {'1': 'metadata_json', '3': 11, '4': 1, '5': 9, '10': 'metadataJson'},
    {
      '1': 'command_context',
      '3': 12,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.CommandContext',
      '10': 'commandContext'
    },
  ],
};

/// Descriptor for `CampaignServiceCreateRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List campaignServiceCreateRequestDescriptor = $convert.base64Decode(
    'ChxDYW1wYWlnblNlcnZpY2VDcmVhdGVSZXF1ZXN0EiEKDHdvcmtzcGFjZV9pZBgBIAEoCVILd2'
    '9ya3NwYWNlSWQSSgoNY2FtcGFpZ25fdHlwZRgCIAEoDjIlLmNyZWF0aXZhbnRhLmNvbW1lcmNl'
    'LnYxLkNhbXBhaWduVHlwZVIMY2FtcGFpZ25UeXBlEhQKBXRpdGxlGAMgASgJUgV0aXRsZRIcCg'
    'lvYmplY3RpdmUYBCABKAlSCW9iamVjdGl2ZRIdCgpzdGFydF9kYXRlGAUgASgJUglzdGFydERh'
    'dGUSGQoIZW5kX2RhdGUYBiABKAlSB2VuZERhdGUSFgoGYnVkZ2V0GAcgASgJUgZidWRnZXQSJw'
    'oPYnVkZ2V0X2N1cnJlbmN5GAggASgJUg5idWRnZXRDdXJyZW5jeRIuChNyZWxhdGVkX3Byb2R1'
    'Y3RfaWRzGAkgAygJUhFyZWxhdGVkUHJvZHVjdElkcxIqChFyZWxhdGVkX29mZmVyX2lkcxgKIA'
    'MoCVIPcmVsYXRlZE9mZmVySWRzEiMKDW1ldGFkYXRhX2pzb24YCyABKAlSDG1ldGFkYXRhSnNv'
    'bhJOCg9jb21tYW5kX2NvbnRleHQYDCABKAsyJS5jcmVhdGl2YW50YS5jb21tb24udjEuQ29tbW'
    'FuZENvbnRleHRSDmNvbW1hbmRDb250ZXh0');

@$core.Deprecated('Use campaignServiceCreateResponseDescriptor instead')
const CampaignServiceCreateResponse$json = {
  '1': 'CampaignServiceCreateResponse',
  '2': [
    {
      '1': 'campaign',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.commerce.v1.Campaign',
      '10': 'campaign'
    },
  ],
};

/// Descriptor for `CampaignServiceCreateResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List campaignServiceCreateResponseDescriptor =
    $convert.base64Decode(
        'Ch1DYW1wYWlnblNlcnZpY2VDcmVhdGVSZXNwb25zZRI9CghjYW1wYWlnbhgBIAEoCzIhLmNyZW'
        'F0aXZhbnRhLmNvbW1lcmNlLnYxLkNhbXBhaWduUghjYW1wYWlnbg==');

@$core.Deprecated('Use campaignServiceGetRequestDescriptor instead')
const CampaignServiceGetRequest$json = {
  '1': 'CampaignServiceGetRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'campaign_id', '3': 2, '4': 1, '5': 9, '10': 'campaignId'},
  ],
};

/// Descriptor for `CampaignServiceGetRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List campaignServiceGetRequestDescriptor =
    $convert.base64Decode(
        'ChlDYW1wYWlnblNlcnZpY2VHZXRSZXF1ZXN0EiEKDHdvcmtzcGFjZV9pZBgBIAEoCVILd29ya3'
        'NwYWNlSWQSHwoLY2FtcGFpZ25faWQYAiABKAlSCmNhbXBhaWduSWQ=');

@$core.Deprecated('Use campaignServiceGetResponseDescriptor instead')
const CampaignServiceGetResponse$json = {
  '1': 'CampaignServiceGetResponse',
  '2': [
    {
      '1': 'campaign',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.commerce.v1.Campaign',
      '10': 'campaign'
    },
  ],
};

/// Descriptor for `CampaignServiceGetResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List campaignServiceGetResponseDescriptor =
    $convert.base64Decode(
        'ChpDYW1wYWlnblNlcnZpY2VHZXRSZXNwb25zZRI9CghjYW1wYWlnbhgBIAEoCzIhLmNyZWF0aX'
        'ZhbnRhLmNvbW1lcmNlLnYxLkNhbXBhaWduUghjYW1wYWlnbg==');

@$core.Deprecated('Use campaignServiceListRequestDescriptor instead')
const CampaignServiceListRequest$json = {
  '1': 'CampaignServiceListRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {
      '1': 'status',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.creativanta.commerce.v1.CampaignStatus',
      '10': 'status'
    },
    {
      '1': 'campaign_type',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.creativanta.commerce.v1.CampaignType',
      '10': 'campaignType'
    },
    {'1': 'query', '3': 4, '4': 1, '5': 9, '10': 'query'},
    {'1': 'page_size', '3': 5, '4': 1, '5': 5, '10': 'pageSize'},
    {'1': 'page_token', '3': 6, '4': 1, '5': 9, '10': 'pageToken'},
  ],
};

/// Descriptor for `CampaignServiceListRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List campaignServiceListRequestDescriptor = $convert.base64Decode(
    'ChpDYW1wYWlnblNlcnZpY2VMaXN0UmVxdWVzdBIhCgx3b3Jrc3BhY2VfaWQYASABKAlSC3dvcm'
    'tzcGFjZUlkEj8KBnN0YXR1cxgCIAEoDjInLmNyZWF0aXZhbnRhLmNvbW1lcmNlLnYxLkNhbXBh'
    'aWduU3RhdHVzUgZzdGF0dXMSSgoNY2FtcGFpZ25fdHlwZRgDIAEoDjIlLmNyZWF0aXZhbnRhLm'
    'NvbW1lcmNlLnYxLkNhbXBhaWduVHlwZVIMY2FtcGFpZ25UeXBlEhQKBXF1ZXJ5GAQgASgJUgVx'
    'dWVyeRIbCglwYWdlX3NpemUYBSABKAVSCHBhZ2VTaXplEh0KCnBhZ2VfdG9rZW4YBiABKAlSCX'
    'BhZ2VUb2tlbg==');

@$core.Deprecated('Use campaignServiceListResponseDescriptor instead')
const CampaignServiceListResponse$json = {
  '1': 'CampaignServiceListResponse',
  '2': [
    {
      '1': 'campaigns',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.creativanta.commerce.v1.Campaign',
      '10': 'campaigns'
    },
    {'1': 'next_page_token', '3': 2, '4': 1, '5': 9, '10': 'nextPageToken'},
    {'1': 'total_count', '3': 3, '4': 1, '5': 5, '10': 'totalCount'},
  ],
};

/// Descriptor for `CampaignServiceListResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List campaignServiceListResponseDescriptor = $convert.base64Decode(
    'ChtDYW1wYWlnblNlcnZpY2VMaXN0UmVzcG9uc2USPwoJY2FtcGFpZ25zGAEgAygLMiEuY3JlYX'
    'RpdmFudGEuY29tbWVyY2UudjEuQ2FtcGFpZ25SCWNhbXBhaWducxImCg9uZXh0X3BhZ2VfdG9r'
    'ZW4YAiABKAlSDW5leHRQYWdlVG9rZW4SHwoLdG90YWxfY291bnQYAyABKAVSCnRvdGFsQ291bn'
    'Q=');

@$core.Deprecated('Use campaignServiceUpdateRequestDescriptor instead')
const CampaignServiceUpdateRequest$json = {
  '1': 'CampaignServiceUpdateRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'campaign_id', '3': 2, '4': 1, '5': 9, '10': 'campaignId'},
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
    {
      '1': 'related_offer_ids',
      '3': 10,
      '4': 3,
      '5': 9,
      '10': 'relatedOfferIds'
    },
    {'1': 'metadata_json', '3': 11, '4': 1, '5': 9, '10': 'metadataJson'},
    {
      '1': 'command_context',
      '3': 12,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.CommandContext',
      '10': 'commandContext'
    },
  ],
};

/// Descriptor for `CampaignServiceUpdateRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List campaignServiceUpdateRequestDescriptor = $convert.base64Decode(
    'ChxDYW1wYWlnblNlcnZpY2VVcGRhdGVSZXF1ZXN0EiEKDHdvcmtzcGFjZV9pZBgBIAEoCVILd2'
    '9ya3NwYWNlSWQSHwoLY2FtcGFpZ25faWQYAiABKAlSCmNhbXBhaWduSWQSFAoFdGl0bGUYAyAB'
    'KAlSBXRpdGxlEhwKCW9iamVjdGl2ZRgEIAEoCVIJb2JqZWN0aXZlEh0KCnN0YXJ0X2RhdGUYBS'
    'ABKAlSCXN0YXJ0RGF0ZRIZCghlbmRfZGF0ZRgGIAEoCVIHZW5kRGF0ZRIWCgZidWRnZXQYByAB'
    'KAlSBmJ1ZGdldBInCg9idWRnZXRfY3VycmVuY3kYCCABKAlSDmJ1ZGdldEN1cnJlbmN5Ei4KE3'
    'JlbGF0ZWRfcHJvZHVjdF9pZHMYCSADKAlSEXJlbGF0ZWRQcm9kdWN0SWRzEioKEXJlbGF0ZWRf'
    'b2ZmZXJfaWRzGAogAygJUg9yZWxhdGVkT2ZmZXJJZHMSIwoNbWV0YWRhdGFfanNvbhgLIAEoCV'
    'IMbWV0YWRhdGFKc29uEk4KD2NvbW1hbmRfY29udGV4dBgMIAEoCzIlLmNyZWF0aXZhbnRhLmNv'
    'bW1vbi52MS5Db21tYW5kQ29udGV4dFIOY29tbWFuZENvbnRleHQ=');

@$core.Deprecated('Use campaignServiceUpdateResponseDescriptor instead')
const CampaignServiceUpdateResponse$json = {
  '1': 'CampaignServiceUpdateResponse',
  '2': [
    {
      '1': 'campaign',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.commerce.v1.Campaign',
      '10': 'campaign'
    },
  ],
};

/// Descriptor for `CampaignServiceUpdateResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List campaignServiceUpdateResponseDescriptor =
    $convert.base64Decode(
        'Ch1DYW1wYWlnblNlcnZpY2VVcGRhdGVSZXNwb25zZRI9CghjYW1wYWlnbhgBIAEoCzIhLmNyZW'
        'F0aXZhbnRhLmNvbW1lcmNlLnYxLkNhbXBhaWduUghjYW1wYWlnbg==');

@$core.Deprecated('Use campaignServiceActivateRequestDescriptor instead')
const CampaignServiceActivateRequest$json = {
  '1': 'CampaignServiceActivateRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'campaign_id', '3': 2, '4': 1, '5': 9, '10': 'campaignId'},
    {
      '1': 'command_context',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.CommandContext',
      '10': 'commandContext'
    },
  ],
};

/// Descriptor for `CampaignServiceActivateRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List campaignServiceActivateRequestDescriptor =
    $convert.base64Decode(
        'Ch5DYW1wYWlnblNlcnZpY2VBY3RpdmF0ZVJlcXVlc3QSIQoMd29ya3NwYWNlX2lkGAEgASgJUg'
        't3b3Jrc3BhY2VJZBIfCgtjYW1wYWlnbl9pZBgCIAEoCVIKY2FtcGFpZ25JZBJOCg9jb21tYW5k'
        'X2NvbnRleHQYAyABKAsyJS5jcmVhdGl2YW50YS5jb21tb24udjEuQ29tbWFuZENvbnRleHRSDm'
        'NvbW1hbmRDb250ZXh0');

@$core.Deprecated('Use campaignServiceActivateResponseDescriptor instead')
const CampaignServiceActivateResponse$json = {
  '1': 'CampaignServiceActivateResponse',
  '2': [
    {
      '1': 'campaign',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.commerce.v1.Campaign',
      '10': 'campaign'
    },
  ],
};

/// Descriptor for `CampaignServiceActivateResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List campaignServiceActivateResponseDescriptor =
    $convert.base64Decode(
        'Ch9DYW1wYWlnblNlcnZpY2VBY3RpdmF0ZVJlc3BvbnNlEj0KCGNhbXBhaWduGAEgASgLMiEuY3'
        'JlYXRpdmFudGEuY29tbWVyY2UudjEuQ2FtcGFpZ25SCGNhbXBhaWdu');

@$core.Deprecated('Use campaignServicePauseRequestDescriptor instead')
const CampaignServicePauseRequest$json = {
  '1': 'CampaignServicePauseRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'campaign_id', '3': 2, '4': 1, '5': 9, '10': 'campaignId'},
    {
      '1': 'command_context',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.CommandContext',
      '10': 'commandContext'
    },
  ],
};

/// Descriptor for `CampaignServicePauseRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List campaignServicePauseRequestDescriptor = $convert.base64Decode(
    'ChtDYW1wYWlnblNlcnZpY2VQYXVzZVJlcXVlc3QSIQoMd29ya3NwYWNlX2lkGAEgASgJUgt3b3'
    'Jrc3BhY2VJZBIfCgtjYW1wYWlnbl9pZBgCIAEoCVIKY2FtcGFpZ25JZBJOCg9jb21tYW5kX2Nv'
    'bnRleHQYAyABKAsyJS5jcmVhdGl2YW50YS5jb21tb24udjEuQ29tbWFuZENvbnRleHRSDmNvbW'
    '1hbmRDb250ZXh0');

@$core.Deprecated('Use campaignServicePauseResponseDescriptor instead')
const CampaignServicePauseResponse$json = {
  '1': 'CampaignServicePauseResponse',
  '2': [
    {
      '1': 'campaign',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.commerce.v1.Campaign',
      '10': 'campaign'
    },
  ],
};

/// Descriptor for `CampaignServicePauseResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List campaignServicePauseResponseDescriptor =
    $convert.base64Decode(
        'ChxDYW1wYWlnblNlcnZpY2VQYXVzZVJlc3BvbnNlEj0KCGNhbXBhaWduGAEgASgLMiEuY3JlYX'
        'RpdmFudGEuY29tbWVyY2UudjEuQ2FtcGFpZ25SCGNhbXBhaWdu');

@$core.Deprecated('Use campaignServiceResumeRequestDescriptor instead')
const CampaignServiceResumeRequest$json = {
  '1': 'CampaignServiceResumeRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'campaign_id', '3': 2, '4': 1, '5': 9, '10': 'campaignId'},
    {
      '1': 'command_context',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.CommandContext',
      '10': 'commandContext'
    },
  ],
};

/// Descriptor for `CampaignServiceResumeRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List campaignServiceResumeRequestDescriptor = $convert.base64Decode(
    'ChxDYW1wYWlnblNlcnZpY2VSZXN1bWVSZXF1ZXN0EiEKDHdvcmtzcGFjZV9pZBgBIAEoCVILd2'
    '9ya3NwYWNlSWQSHwoLY2FtcGFpZ25faWQYAiABKAlSCmNhbXBhaWduSWQSTgoPY29tbWFuZF9j'
    'b250ZXh0GAMgASgLMiUuY3JlYXRpdmFudGEuY29tbW9uLnYxLkNvbW1hbmRDb250ZXh0Ug5jb2'
    '1tYW5kQ29udGV4dA==');

@$core.Deprecated('Use campaignServiceResumeResponseDescriptor instead')
const CampaignServiceResumeResponse$json = {
  '1': 'CampaignServiceResumeResponse',
  '2': [
    {
      '1': 'campaign',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.commerce.v1.Campaign',
      '10': 'campaign'
    },
  ],
};

/// Descriptor for `CampaignServiceResumeResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List campaignServiceResumeResponseDescriptor =
    $convert.base64Decode(
        'Ch1DYW1wYWlnblNlcnZpY2VSZXN1bWVSZXNwb25zZRI9CghjYW1wYWlnbhgBIAEoCzIhLmNyZW'
        'F0aXZhbnRhLmNvbW1lcmNlLnYxLkNhbXBhaWduUghjYW1wYWlnbg==');

@$core.Deprecated('Use campaignServiceEndRequestDescriptor instead')
const CampaignServiceEndRequest$json = {
  '1': 'CampaignServiceEndRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'campaign_id', '3': 2, '4': 1, '5': 9, '10': 'campaignId'},
    {
      '1': 'command_context',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.CommandContext',
      '10': 'commandContext'
    },
  ],
};

/// Descriptor for `CampaignServiceEndRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List campaignServiceEndRequestDescriptor = $convert.base64Decode(
    'ChlDYW1wYWlnblNlcnZpY2VFbmRSZXF1ZXN0EiEKDHdvcmtzcGFjZV9pZBgBIAEoCVILd29ya3'
    'NwYWNlSWQSHwoLY2FtcGFpZ25faWQYAiABKAlSCmNhbXBhaWduSWQSTgoPY29tbWFuZF9jb250'
    'ZXh0GAMgASgLMiUuY3JlYXRpdmFudGEuY29tbW9uLnYxLkNvbW1hbmRDb250ZXh0Ug5jb21tYW'
    '5kQ29udGV4dA==');

@$core.Deprecated('Use campaignServiceEndResponseDescriptor instead')
const CampaignServiceEndResponse$json = {
  '1': 'CampaignServiceEndResponse',
  '2': [
    {
      '1': 'campaign',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.commerce.v1.Campaign',
      '10': 'campaign'
    },
  ],
};

/// Descriptor for `CampaignServiceEndResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List campaignServiceEndResponseDescriptor =
    $convert.base64Decode(
        'ChpDYW1wYWlnblNlcnZpY2VFbmRSZXNwb25zZRI9CghjYW1wYWlnbhgBIAEoCzIhLmNyZWF0aX'
        'ZhbnRhLmNvbW1lcmNlLnYxLkNhbXBhaWduUghjYW1wYWlnbg==');

@$core.Deprecated('Use campaignServiceDeleteRequestDescriptor instead')
const CampaignServiceDeleteRequest$json = {
  '1': 'CampaignServiceDeleteRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'campaign_id', '3': 2, '4': 1, '5': 9, '10': 'campaignId'},
    {
      '1': 'command_context',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.CommandContext',
      '10': 'commandContext'
    },
  ],
};

/// Descriptor for `CampaignServiceDeleteRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List campaignServiceDeleteRequestDescriptor = $convert.base64Decode(
    'ChxDYW1wYWlnblNlcnZpY2VEZWxldGVSZXF1ZXN0EiEKDHdvcmtzcGFjZV9pZBgBIAEoCVILd2'
    '9ya3NwYWNlSWQSHwoLY2FtcGFpZ25faWQYAiABKAlSCmNhbXBhaWduSWQSTgoPY29tbWFuZF9j'
    'b250ZXh0GAMgASgLMiUuY3JlYXRpdmFudGEuY29tbW9uLnYxLkNvbW1hbmRDb250ZXh0Ug5jb2'
    '1tYW5kQ29udGV4dA==');

@$core.Deprecated('Use campaignServiceDeleteResponseDescriptor instead')
const CampaignServiceDeleteResponse$json = {
  '1': 'CampaignServiceDeleteResponse',
  '2': [
    {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
  ],
};

/// Descriptor for `CampaignServiceDeleteResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List campaignServiceDeleteResponseDescriptor =
    $convert.base64Decode(
        'Ch1DYW1wYWlnblNlcnZpY2VEZWxldGVSZXNwb25zZRIYCgdzdWNjZXNzGAEgASgIUgdzdWNjZX'
        'Nz');

@$core.Deprecated('Use campaignServiceDuplicateRequestDescriptor instead')
const CampaignServiceDuplicateRequest$json = {
  '1': 'CampaignServiceDuplicateRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'campaign_id', '3': 2, '4': 1, '5': 9, '10': 'campaignId'},
    {'1': 'new_title', '3': 3, '4': 1, '5': 9, '10': 'newTitle'},
    {
      '1': 'command_context',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.CommandContext',
      '10': 'commandContext'
    },
  ],
};

/// Descriptor for `CampaignServiceDuplicateRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List campaignServiceDuplicateRequestDescriptor =
    $convert.base64Decode(
        'Ch9DYW1wYWlnblNlcnZpY2VEdXBsaWNhdGVSZXF1ZXN0EiEKDHdvcmtzcGFjZV9pZBgBIAEoCV'
        'ILd29ya3NwYWNlSWQSHwoLY2FtcGFpZ25faWQYAiABKAlSCmNhbXBhaWduSWQSGwoJbmV3X3Rp'
        'dGxlGAMgASgJUghuZXdUaXRsZRJOCg9jb21tYW5kX2NvbnRleHQYBCABKAsyJS5jcmVhdGl2YW'
        '50YS5jb21tb24udjEuQ29tbWFuZENvbnRleHRSDmNvbW1hbmRDb250ZXh0');

@$core.Deprecated('Use campaignServiceDuplicateResponseDescriptor instead')
const CampaignServiceDuplicateResponse$json = {
  '1': 'CampaignServiceDuplicateResponse',
  '2': [
    {
      '1': 'campaign',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.commerce.v1.Campaign',
      '10': 'campaign'
    },
  ],
};

/// Descriptor for `CampaignServiceDuplicateResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List campaignServiceDuplicateResponseDescriptor =
    $convert.base64Decode(
        'CiBDYW1wYWlnblNlcnZpY2VEdXBsaWNhdGVSZXNwb25zZRI9CghjYW1wYWlnbhgBIAEoCzIhLm'
        'NyZWF0aXZhbnRhLmNvbW1lcmNlLnYxLkNhbXBhaWduUghjYW1wYWlnbg==');

@$core.Deprecated('Use campaignServiceExportReportRequestDescriptor instead')
const CampaignServiceExportReportRequest$json = {
  '1': 'CampaignServiceExportReportRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'campaign_id', '3': 2, '4': 1, '5': 9, '10': 'campaignId'},
    {'1': 'format', '3': 3, '4': 1, '5': 9, '10': 'format'},
  ],
};

/// Descriptor for `CampaignServiceExportReportRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List campaignServiceExportReportRequestDescriptor =
    $convert.base64Decode(
        'CiJDYW1wYWlnblNlcnZpY2VFeHBvcnRSZXBvcnRSZXF1ZXN0EiEKDHdvcmtzcGFjZV9pZBgBIA'
        'EoCVILd29ya3NwYWNlSWQSHwoLY2FtcGFpZ25faWQYAiABKAlSCmNhbXBhaWduSWQSFgoGZm9y'
        'bWF0GAMgASgJUgZmb3JtYXQ=');

@$core.Deprecated('Use campaignServiceExportReportResponseDescriptor instead')
const CampaignServiceExportReportResponse$json = {
  '1': 'CampaignServiceExportReportResponse',
  '2': [
    {'1': 'download_url', '3': 1, '4': 1, '5': 9, '10': 'downloadUrl'},
    {'1': 'export_id', '3': 2, '4': 1, '5': 9, '10': 'exportId'},
  ],
};

/// Descriptor for `CampaignServiceExportReportResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List campaignServiceExportReportResponseDescriptor =
    $convert.base64Decode(
        'CiNDYW1wYWlnblNlcnZpY2VFeHBvcnRSZXBvcnRSZXNwb25zZRIhCgxkb3dubG9hZF91cmwYAS'
        'ABKAlSC2Rvd25sb2FkVXJsEhsKCWV4cG9ydF9pZBgCIAEoCVIIZXhwb3J0SWQ=');

@$core.Deprecated('Use campaignServiceAddCostRequestDescriptor instead')
const CampaignServiceAddCostRequest$json = {
  '1': 'CampaignServiceAddCostRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'campaign_id', '3': 2, '4': 1, '5': 9, '10': 'campaignId'},
    {'1': 'cost_type', '3': 3, '4': 1, '5': 9, '10': 'costType'},
    {'1': 'amount', '3': 4, '4': 1, '5': 9, '10': 'amount'},
    {'1': 'currency', '3': 5, '4': 1, '5': 9, '10': 'currency'},
    {'1': 'description', '3': 6, '4': 1, '5': 9, '10': 'description'},
    {'1': 'effective_date', '3': 7, '4': 1, '5': 9, '10': 'effectiveDate'},
    {
      '1': 'command_context',
      '3': 8,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.CommandContext',
      '10': 'commandContext'
    },
  ],
};

/// Descriptor for `CampaignServiceAddCostRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List campaignServiceAddCostRequestDescriptor = $convert.base64Decode(
    'Ch1DYW1wYWlnblNlcnZpY2VBZGRDb3N0UmVxdWVzdBIhCgx3b3Jrc3BhY2VfaWQYASABKAlSC3'
    'dvcmtzcGFjZUlkEh8KC2NhbXBhaWduX2lkGAIgASgJUgpjYW1wYWlnbklkEhsKCWNvc3RfdHlw'
    'ZRgDIAEoCVIIY29zdFR5cGUSFgoGYW1vdW50GAQgASgJUgZhbW91bnQSGgoIY3VycmVuY3kYBS'
    'ABKAlSCGN1cnJlbmN5EiAKC2Rlc2NyaXB0aW9uGAYgASgJUgtkZXNjcmlwdGlvbhIlCg5lZmZl'
    'Y3RpdmVfZGF0ZRgHIAEoCVINZWZmZWN0aXZlRGF0ZRJOCg9jb21tYW5kX2NvbnRleHQYCCABKA'
    'syJS5jcmVhdGl2YW50YS5jb21tb24udjEuQ29tbWFuZENvbnRleHRSDmNvbW1hbmRDb250ZXh0');

@$core.Deprecated('Use campaignServiceAddCostResponseDescriptor instead')
const CampaignServiceAddCostResponse$json = {
  '1': 'CampaignServiceAddCostResponse',
  '2': [
    {'1': 'cost_item_id', '3': 1, '4': 1, '5': 9, '10': 'costItemId'},
    {'1': 'campaign_id', '3': 2, '4': 1, '5': 9, '10': 'campaignId'},
    {'1': 'total_spend', '3': 3, '4': 1, '5': 9, '10': 'totalSpend'},
    {'1': 'budget', '3': 4, '4': 1, '5': 9, '10': 'budget'},
    {
      '1': 'budget_utilization_pct',
      '3': 5,
      '4': 1,
      '5': 9,
      '10': 'budgetUtilizationPct'
    },
    {'1': 'warning_emitted', '3': 6, '4': 1, '5': 8, '10': 'warningEmitted'},
    {'1': 'alert_emitted', '3': 7, '4': 1, '5': 8, '10': 'alertEmitted'},
  ],
};

/// Descriptor for `CampaignServiceAddCostResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List campaignServiceAddCostResponseDescriptor = $convert.base64Decode(
    'Ch5DYW1wYWlnblNlcnZpY2VBZGRDb3N0UmVzcG9uc2USIAoMY29zdF9pdGVtX2lkGAEgASgJUg'
    'pjb3N0SXRlbUlkEh8KC2NhbXBhaWduX2lkGAIgASgJUgpjYW1wYWlnbklkEh8KC3RvdGFsX3Nw'
    'ZW5kGAMgASgJUgp0b3RhbFNwZW5kEhYKBmJ1ZGdldBgEIAEoCVIGYnVkZ2V0EjQKFmJ1ZGdldF'
    '91dGlsaXphdGlvbl9wY3QYBSABKAlSFGJ1ZGdldFV0aWxpemF0aW9uUGN0EicKD3dhcm5pbmdf'
    'ZW1pdHRlZBgGIAEoCFIOd2FybmluZ0VtaXR0ZWQSIwoNYWxlcnRfZW1pdHRlZBgHIAEoCFIMYW'
    'xlcnRFbWl0dGVk');

@$core.Deprecated('Use campaignServiceGetCostsRequestDescriptor instead')
const CampaignServiceGetCostsRequest$json = {
  '1': 'CampaignServiceGetCostsRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'campaign_id', '3': 2, '4': 1, '5': 9, '10': 'campaignId'},
  ],
};

/// Descriptor for `CampaignServiceGetCostsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List campaignServiceGetCostsRequestDescriptor =
    $convert.base64Decode(
        'Ch5DYW1wYWlnblNlcnZpY2VHZXRDb3N0c1JlcXVlc3QSIQoMd29ya3NwYWNlX2lkGAEgASgJUg'
        't3b3Jrc3BhY2VJZBIfCgtjYW1wYWlnbl9pZBgCIAEoCVIKY2FtcGFpZ25JZA==');

@$core.Deprecated('Use campaignCostItemDescriptor instead')
const CampaignCostItem$json = {
  '1': 'CampaignCostItem',
  '2': [
    {'1': 'cost_item_id', '3': 1, '4': 1, '5': 9, '10': 'costItemId'},
    {'1': 'cost_type', '3': 2, '4': 1, '5': 9, '10': 'costType'},
    {'1': 'amount', '3': 3, '4': 1, '5': 9, '10': 'amount'},
    {'1': 'currency', '3': 4, '4': 1, '5': 9, '10': 'currency'},
    {'1': 'description', '3': 5, '4': 1, '5': 9, '10': 'description'},
    {'1': 'effective_date', '3': 6, '4': 1, '5': 9, '10': 'effectiveDate'},
    {
      '1': 'created_at',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'createdAt'
    },
  ],
};

/// Descriptor for `CampaignCostItem`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List campaignCostItemDescriptor = $convert.base64Decode(
    'ChBDYW1wYWlnbkNvc3RJdGVtEiAKDGNvc3RfaXRlbV9pZBgBIAEoCVIKY29zdEl0ZW1JZBIbCg'
    'ljb3N0X3R5cGUYAiABKAlSCGNvc3RUeXBlEhYKBmFtb3VudBgDIAEoCVIGYW1vdW50EhoKCGN1'
    'cnJlbmN5GAQgASgJUghjdXJyZW5jeRIgCgtkZXNjcmlwdGlvbhgFIAEoCVILZGVzY3JpcHRpb2'
    '4SJQoOZWZmZWN0aXZlX2RhdGUYBiABKAlSDWVmZmVjdGl2ZURhdGUSOQoKY3JlYXRlZF9hdBgH'
    'IAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSCWNyZWF0ZWRBdA==');

@$core.Deprecated('Use campaignServiceGetCostsResponseDescriptor instead')
const CampaignServiceGetCostsResponse$json = {
  '1': 'CampaignServiceGetCostsResponse',
  '2': [
    {'1': 'campaign_id', '3': 1, '4': 1, '5': 9, '10': 'campaignId'},
    {'1': 'total_spend', '3': 2, '4': 1, '5': 9, '10': 'totalSpend'},
    {'1': 'budget', '3': 3, '4': 1, '5': 9, '10': 'budget'},
    {'1': 'remaining_budget', '3': 4, '4': 1, '5': 9, '10': 'remainingBudget'},
    {'1': 'budget_currency', '3': 5, '4': 1, '5': 9, '10': 'budgetCurrency'},
    {
      '1': 'items',
      '3': 6,
      '4': 3,
      '5': 11,
      '6': '.creativanta.commerce.v1.CampaignCostItem',
      '10': 'items'
    },
  ],
};

/// Descriptor for `CampaignServiceGetCostsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List campaignServiceGetCostsResponseDescriptor = $convert.base64Decode(
    'Ch9DYW1wYWlnblNlcnZpY2VHZXRDb3N0c1Jlc3BvbnNlEh8KC2NhbXBhaWduX2lkGAEgASgJUg'
    'pjYW1wYWlnbklkEh8KC3RvdGFsX3NwZW5kGAIgASgJUgp0b3RhbFNwZW5kEhYKBmJ1ZGdldBgD'
    'IAEoCVIGYnVkZ2V0EikKEHJlbWFpbmluZ19idWRnZXQYBCABKAlSD3JlbWFpbmluZ0J1ZGdldB'
    'InCg9idWRnZXRfY3VycmVuY3kYBSABKAlSDmJ1ZGdldEN1cnJlbmN5Ej8KBWl0ZW1zGAYgAygL'
    'MikuY3JlYXRpdmFudGEuY29tbWVyY2UudjEuQ2FtcGFpZ25Db3N0SXRlbVIFaXRlbXM=');

@$core.Deprecated('Use campaignServiceGetFunnelRequestDescriptor instead')
const CampaignServiceGetFunnelRequest$json = {
  '1': 'CampaignServiceGetFunnelRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'campaign_id', '3': 2, '4': 1, '5': 9, '10': 'campaignId'},
  ],
};

/// Descriptor for `CampaignServiceGetFunnelRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List campaignServiceGetFunnelRequestDescriptor =
    $convert.base64Decode(
        'Ch9DYW1wYWlnblNlcnZpY2VHZXRGdW5uZWxSZXF1ZXN0EiEKDHdvcmtzcGFjZV9pZBgBIAEoCV'
        'ILd29ya3NwYWNlSWQSHwoLY2FtcGFpZ25faWQYAiABKAlSCmNhbXBhaWduSWQ=');

@$core.Deprecated('Use campaignServiceGetFunnelResponseDescriptor instead')
const CampaignServiceGetFunnelResponse$json = {
  '1': 'CampaignServiceGetFunnelResponse',
  '2': [
    {'1': 'campaign_id', '3': 1, '4': 1, '5': 9, '10': 'campaignId'},
    {'1': 'impressions', '3': 2, '4': 1, '5': 3, '10': 'impressions'},
    {'1': 'clicks', '3': 3, '4': 1, '5': 3, '10': 'clicks'},
    {'1': 'cart_adds', '3': 4, '4': 1, '5': 3, '10': 'cartAdds'},
    {'1': 'checkouts', '3': 5, '4': 1, '5': 3, '10': 'checkouts'},
    {'1': 'completed_orders', '3': 6, '4': 1, '5': 3, '10': 'completedOrders'},
    {'1': 'dropoff_rate', '3': 7, '4': 1, '5': 9, '10': 'dropoffRate'},
  ],
};

/// Descriptor for `CampaignServiceGetFunnelResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List campaignServiceGetFunnelResponseDescriptor = $convert.base64Decode(
    'CiBDYW1wYWlnblNlcnZpY2VHZXRGdW5uZWxSZXNwb25zZRIfCgtjYW1wYWlnbl9pZBgBIAEoCV'
    'IKY2FtcGFpZ25JZBIgCgtpbXByZXNzaW9ucxgCIAEoA1ILaW1wcmVzc2lvbnMSFgoGY2xpY2tz'
    'GAMgASgDUgZjbGlja3MSGwoJY2FydF9hZGRzGAQgASgDUghjYXJ0QWRkcxIcCgljaGVja291dH'
    'MYBSABKANSCWNoZWNrb3V0cxIpChBjb21wbGV0ZWRfb3JkZXJzGAYgASgDUg9jb21wbGV0ZWRP'
    'cmRlcnMSIQoMZHJvcG9mZl9yYXRlGAcgASgJUgtkcm9wb2ZmUmF0ZQ==');

@$core.Deprecated('Use campaignServiceGetMetricsRequestDescriptor instead')
const CampaignServiceGetMetricsRequest$json = {
  '1': 'CampaignServiceGetMetricsRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'campaign_id', '3': 2, '4': 1, '5': 9, '10': 'campaignId'},
  ],
};

/// Descriptor for `CampaignServiceGetMetricsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List campaignServiceGetMetricsRequestDescriptor =
    $convert.base64Decode(
        'CiBDYW1wYWlnblNlcnZpY2VHZXRNZXRyaWNzUmVxdWVzdBIhCgx3b3Jrc3BhY2VfaWQYASABKA'
        'lSC3dvcmtzcGFjZUlkEh8KC2NhbXBhaWduX2lkGAIgASgJUgpjYW1wYWlnbklk');

@$core.Deprecated('Use campaignServiceGetMetricsResponseDescriptor instead')
const CampaignServiceGetMetricsResponse$json = {
  '1': 'CampaignServiceGetMetricsResponse',
  '2': [
    {'1': 'campaign_id', '3': 1, '4': 1, '5': 9, '10': 'campaignId'},
    {'1': 'gross_revenue', '3': 2, '4': 1, '5': 9, '10': 'grossRevenue'},
    {'1': 'total_costs', '3': 3, '4': 1, '5': 9, '10': 'totalCosts'},
    {'1': 'net_profit', '3': 4, '4': 1, '5': 9, '10': 'netProfit'},
    {'1': 'roas', '3': 5, '4': 1, '5': 9, '10': 'roas'},
    {'1': 'currency', '3': 6, '4': 1, '5': 9, '10': 'currency'},
    {'1': 'orders_count', '3': 7, '4': 1, '5': 5, '10': 'ordersCount'},
  ],
};

/// Descriptor for `CampaignServiceGetMetricsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List campaignServiceGetMetricsResponseDescriptor = $convert.base64Decode(
    'CiFDYW1wYWlnblNlcnZpY2VHZXRNZXRyaWNzUmVzcG9uc2USHwoLY2FtcGFpZ25faWQYASABKA'
    'lSCmNhbXBhaWduSWQSIwoNZ3Jvc3NfcmV2ZW51ZRgCIAEoCVIMZ3Jvc3NSZXZlbnVlEh8KC3Rv'
    'dGFsX2Nvc3RzGAMgASgJUgp0b3RhbENvc3RzEh0KCm5ldF9wcm9maXQYBCABKAlSCW5ldFByb2'
    'ZpdBISCgRyb2FzGAUgASgJUgRyb2FzEhoKCGN1cnJlbmN5GAYgASgJUghjdXJyZW5jeRIhCgxv'
    'cmRlcnNfY291bnQYByABKAVSC29yZGVyc0NvdW50');

@$core
    .Deprecated('Use campaignServiceGetLinkedContentRequestDescriptor instead')
const CampaignServiceGetLinkedContentRequest$json = {
  '1': 'CampaignServiceGetLinkedContentRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'campaign_id', '3': 2, '4': 1, '5': 9, '10': 'campaignId'},
  ],
};

/// Descriptor for `CampaignServiceGetLinkedContentRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List campaignServiceGetLinkedContentRequestDescriptor =
    $convert.base64Decode(
        'CiZDYW1wYWlnblNlcnZpY2VHZXRMaW5rZWRDb250ZW50UmVxdWVzdBIhCgx3b3Jrc3BhY2VfaW'
        'QYASABKAlSC3dvcmtzcGFjZUlkEh8KC2NhbXBhaWduX2lkGAIgASgJUgpjYW1wYWlnbklk');

@$core.Deprecated('Use linkedContentItemDescriptor instead')
const LinkedContentItem$json = {
  '1': 'LinkedContentItem',
  '2': [
    {'1': 'post_id', '3': 1, '4': 1, '5': 9, '10': 'postId'},
    {'1': 'platform', '3': 2, '4': 1, '5': 9, '10': 'platform'},
    {'1': 'title', '3': 3, '4': 1, '5': 9, '10': 'title'},
    {'1': 'url', '3': 4, '4': 1, '5': 9, '10': 'url'},
    {'1': 'views', '3': 5, '4': 1, '5': 3, '10': 'views'},
    {'1': 'engagements', '3': 6, '4': 1, '5': 3, '10': 'engagements'},
  ],
};

/// Descriptor for `LinkedContentItem`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List linkedContentItemDescriptor = $convert.base64Decode(
    'ChFMaW5rZWRDb250ZW50SXRlbRIXCgdwb3N0X2lkGAEgASgJUgZwb3N0SWQSGgoIcGxhdGZvcm'
    '0YAiABKAlSCHBsYXRmb3JtEhQKBXRpdGxlGAMgASgJUgV0aXRsZRIQCgN1cmwYBCABKAlSA3Vy'
    'bBIUCgV2aWV3cxgFIAEoA1IFdmlld3MSIAoLZW5nYWdlbWVudHMYBiABKANSC2VuZ2FnZW1lbn'
    'Rz');

@$core
    .Deprecated('Use campaignServiceGetLinkedContentResponseDescriptor instead')
const CampaignServiceGetLinkedContentResponse$json = {
  '1': 'CampaignServiceGetLinkedContentResponse',
  '2': [
    {'1': 'campaign_id', '3': 1, '4': 1, '5': 9, '10': 'campaignId'},
    {
      '1': 'items',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.creativanta.commerce.v1.LinkedContentItem',
      '10': 'items'
    },
  ],
};

/// Descriptor for `CampaignServiceGetLinkedContentResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List campaignServiceGetLinkedContentResponseDescriptor =
    $convert.base64Decode(
        'CidDYW1wYWlnblNlcnZpY2VHZXRMaW5rZWRDb250ZW50UmVzcG9uc2USHwoLY2FtcGFpZ25faW'
        'QYASABKAlSCmNhbXBhaWduSWQSQAoFaXRlbXMYAiADKAsyKi5jcmVhdGl2YW50YS5jb21tZXJj'
        'ZS52MS5MaW5rZWRDb250ZW50SXRlbVIFaXRlbXM=');

@$core.Deprecated('Use campaignServiceGetLinkedOffersRequestDescriptor instead')
const CampaignServiceGetLinkedOffersRequest$json = {
  '1': 'CampaignServiceGetLinkedOffersRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'campaign_id', '3': 2, '4': 1, '5': 9, '10': 'campaignId'},
  ],
};

/// Descriptor for `CampaignServiceGetLinkedOffersRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List campaignServiceGetLinkedOffersRequestDescriptor =
    $convert.base64Decode(
        'CiVDYW1wYWlnblNlcnZpY2VHZXRMaW5rZWRPZmZlcnNSZXF1ZXN0EiEKDHdvcmtzcGFjZV9pZB'
        'gBIAEoCVILd29ya3NwYWNlSWQSHwoLY2FtcGFpZ25faWQYAiABKAlSCmNhbXBhaWduSWQ=');

@$core
    .Deprecated('Use campaignServiceGetLinkedOffersResponseDescriptor instead')
const CampaignServiceGetLinkedOffersResponse$json = {
  '1': 'CampaignServiceGetLinkedOffersResponse',
  '2': [
    {'1': 'campaign_id', '3': 1, '4': 1, '5': 9, '10': 'campaignId'},
    {
      '1': 'offers',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.creativanta.commerce.v1.Offer',
      '10': 'offers'
    },
  ],
};

/// Descriptor for `CampaignServiceGetLinkedOffersResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List campaignServiceGetLinkedOffersResponseDescriptor =
    $convert.base64Decode(
        'CiZDYW1wYWlnblNlcnZpY2VHZXRMaW5rZWRPZmZlcnNSZXNwb25zZRIfCgtjYW1wYWlnbl9pZB'
        'gBIAEoCVIKY2FtcGFpZ25JZBI2CgZvZmZlcnMYAiADKAsyHi5jcmVhdGl2YW50YS5jb21tZXJj'
        'ZS52MS5PZmZlclIGb2ZmZXJz');

@$core.Deprecated(
    'Use campaignServiceGetPlatformBreakdownRequestDescriptor instead')
const CampaignServiceGetPlatformBreakdownRequest$json = {
  '1': 'CampaignServiceGetPlatformBreakdownRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'campaign_id', '3': 2, '4': 1, '5': 9, '10': 'campaignId'},
  ],
};

/// Descriptor for `CampaignServiceGetPlatformBreakdownRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List
    campaignServiceGetPlatformBreakdownRequestDescriptor =
    $convert.base64Decode(
        'CipDYW1wYWlnblNlcnZpY2VHZXRQbGF0Zm9ybUJyZWFrZG93blJlcXVlc3QSIQoMd29ya3NwYW'
        'NlX2lkGAEgASgJUgt3b3Jrc3BhY2VJZBIfCgtjYW1wYWlnbl9pZBgCIAEoCVIKY2FtcGFpZ25J'
        'ZA==');

@$core.Deprecated('Use platformBreakdownItemDescriptor instead')
const PlatformBreakdownItem$json = {
  '1': 'PlatformBreakdownItem',
  '2': [
    {'1': 'platform', '3': 1, '4': 1, '5': 9, '10': 'platform'},
    {'1': 'revenue', '3': 2, '4': 1, '5': 9, '10': 'revenue'},
    {'1': 'spend', '3': 3, '4': 1, '5': 9, '10': 'spend'},
    {'1': 'orders_count', '3': 4, '4': 1, '5': 5, '10': 'ordersCount'},
  ],
};

/// Descriptor for `PlatformBreakdownItem`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List platformBreakdownItemDescriptor = $convert.base64Decode(
    'ChVQbGF0Zm9ybUJyZWFrZG93bkl0ZW0SGgoIcGxhdGZvcm0YASABKAlSCHBsYXRmb3JtEhgKB3'
    'JldmVudWUYAiABKAlSB3JldmVudWUSFAoFc3BlbmQYAyABKAlSBXNwZW5kEiEKDG9yZGVyc19j'
    'b3VudBgEIAEoBVILb3JkZXJzQ291bnQ=');

@$core.Deprecated(
    'Use campaignServiceGetPlatformBreakdownResponseDescriptor instead')
const CampaignServiceGetPlatformBreakdownResponse$json = {
  '1': 'CampaignServiceGetPlatformBreakdownResponse',
  '2': [
    {'1': 'campaign_id', '3': 1, '4': 1, '5': 9, '10': 'campaignId'},
    {
      '1': 'items',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.creativanta.commerce.v1.PlatformBreakdownItem',
      '10': 'items'
    },
  ],
};

/// Descriptor for `CampaignServiceGetPlatformBreakdownResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List
    campaignServiceGetPlatformBreakdownResponseDescriptor =
    $convert.base64Decode(
        'CitDYW1wYWlnblNlcnZpY2VHZXRQbGF0Zm9ybUJyZWFrZG93blJlc3BvbnNlEh8KC2NhbXBhaW'
        'duX2lkGAEgASgJUgpjYW1wYWlnbklkEkQKBWl0ZW1zGAIgAygLMi4uY3JlYXRpdmFudGEuY29t'
        'bWVyY2UudjEuUGxhdGZvcm1CcmVha2Rvd25JdGVtUgVpdGVtcw==');

@$core.Deprecated(
    'Use campaignServiceGetRevenueTimelineRequestDescriptor instead')
const CampaignServiceGetRevenueTimelineRequest$json = {
  '1': 'CampaignServiceGetRevenueTimelineRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'campaign_id', '3': 2, '4': 1, '5': 9, '10': 'campaignId'},
    {'1': 'granularity', '3': 3, '4': 1, '5': 9, '10': 'granularity'},
  ],
};

/// Descriptor for `CampaignServiceGetRevenueTimelineRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List campaignServiceGetRevenueTimelineRequestDescriptor =
    $convert.base64Decode(
        'CihDYW1wYWlnblNlcnZpY2VHZXRSZXZlbnVlVGltZWxpbmVSZXF1ZXN0EiEKDHdvcmtzcGFjZV'
        '9pZBgBIAEoCVILd29ya3NwYWNlSWQSHwoLY2FtcGFpZ25faWQYAiABKAlSCmNhbXBhaWduSWQS'
        'IAoLZ3JhbnVsYXJpdHkYAyABKAlSC2dyYW51bGFyaXR5');

@$core.Deprecated('Use revenueTimelinePointDescriptor instead')
const RevenueTimelinePoint$json = {
  '1': 'RevenueTimelinePoint',
  '2': [
    {'1': 'date', '3': 1, '4': 1, '5': 9, '10': 'date'},
    {'1': 'revenue', '3': 2, '4': 1, '5': 9, '10': 'revenue'},
    {'1': 'spend', '3': 3, '4': 1, '5': 9, '10': 'spend'},
    {'1': 'orders_count', '3': 4, '4': 1, '5': 5, '10': 'ordersCount'},
  ],
};

/// Descriptor for `RevenueTimelinePoint`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List revenueTimelinePointDescriptor = $convert.base64Decode(
    'ChRSZXZlbnVlVGltZWxpbmVQb2ludBISCgRkYXRlGAEgASgJUgRkYXRlEhgKB3JldmVudWUYAi'
    'ABKAlSB3JldmVudWUSFAoFc3BlbmQYAyABKAlSBXNwZW5kEiEKDG9yZGVyc19jb3VudBgEIAEo'
    'BVILb3JkZXJzQ291bnQ=');

@$core.Deprecated(
    'Use campaignServiceGetRevenueTimelineResponseDescriptor instead')
const CampaignServiceGetRevenueTimelineResponse$json = {
  '1': 'CampaignServiceGetRevenueTimelineResponse',
  '2': [
    {'1': 'campaign_id', '3': 1, '4': 1, '5': 9, '10': 'campaignId'},
    {
      '1': 'points',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.creativanta.commerce.v1.RevenueTimelinePoint',
      '10': 'points'
    },
  ],
};

/// Descriptor for `CampaignServiceGetRevenueTimelineResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List
    campaignServiceGetRevenueTimelineResponseDescriptor = $convert.base64Decode(
        'CilDYW1wYWlnblNlcnZpY2VHZXRSZXZlbnVlVGltZWxpbmVSZXNwb25zZRIfCgtjYW1wYWlnbl'
        '9pZBgBIAEoCVIKY2FtcGFpZ25JZBJFCgZwb2ludHMYAiADKAsyLS5jcmVhdGl2YW50YS5jb21t'
        'ZXJjZS52MS5SZXZlbnVlVGltZWxpbmVQb2ludFIGcG9pbnRz');

@$core.Deprecated('Use campaignServiceGetTopProductsRequestDescriptor instead')
const CampaignServiceGetTopProductsRequest$json = {
  '1': 'CampaignServiceGetTopProductsRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'campaign_id', '3': 2, '4': 1, '5': 9, '10': 'campaignId'},
    {'1': 'limit', '3': 3, '4': 1, '5': 5, '10': 'limit'},
  ],
};

/// Descriptor for `CampaignServiceGetTopProductsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List campaignServiceGetTopProductsRequestDescriptor =
    $convert.base64Decode(
        'CiRDYW1wYWlnblNlcnZpY2VHZXRUb3BQcm9kdWN0c1JlcXVlc3QSIQoMd29ya3NwYWNlX2lkGA'
        'EgASgJUgt3b3Jrc3BhY2VJZBIfCgtjYW1wYWlnbl9pZBgCIAEoCVIKY2FtcGFpZ25JZBIUCgVs'
        'aW1pdBgDIAEoBVIFbGltaXQ=');

@$core.Deprecated('Use topProductItemDescriptor instead')
const TopProductItem$json = {
  '1': 'TopProductItem',
  '2': [
    {'1': 'product_id', '3': 1, '4': 1, '5': 9, '10': 'productId'},
    {'1': 'title', '3': 2, '4': 1, '5': 9, '10': 'title'},
    {'1': 'units_sold', '3': 3, '4': 1, '5': 5, '10': 'unitsSold'},
    {'1': 'revenue', '3': 4, '4': 1, '5': 9, '10': 'revenue'},
    {'1': 'currency', '3': 5, '4': 1, '5': 9, '10': 'currency'},
  ],
};

/// Descriptor for `TopProductItem`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List topProductItemDescriptor = $convert.base64Decode(
    'Cg5Ub3BQcm9kdWN0SXRlbRIdCgpwcm9kdWN0X2lkGAEgASgJUglwcm9kdWN0SWQSFAoFdGl0bG'
    'UYAiABKAlSBXRpdGxlEh0KCnVuaXRzX3NvbGQYAyABKAVSCXVuaXRzU29sZBIYCgdyZXZlbnVl'
    'GAQgASgJUgdyZXZlbnVlEhoKCGN1cnJlbmN5GAUgASgJUghjdXJyZW5jeQ==');

@$core.Deprecated('Use campaignServiceGetTopProductsResponseDescriptor instead')
const CampaignServiceGetTopProductsResponse$json = {
  '1': 'CampaignServiceGetTopProductsResponse',
  '2': [
    {'1': 'campaign_id', '3': 1, '4': 1, '5': 9, '10': 'campaignId'},
    {
      '1': 'products',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.creativanta.commerce.v1.TopProductItem',
      '10': 'products'
    },
  ],
};

/// Descriptor for `CampaignServiceGetTopProductsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List campaignServiceGetTopProductsResponseDescriptor =
    $convert.base64Decode(
        'CiVDYW1wYWlnblNlcnZpY2VHZXRUb3BQcm9kdWN0c1Jlc3BvbnNlEh8KC2NhbXBhaWduX2lkGA'
        'EgASgJUgpjYW1wYWlnbklkEkMKCHByb2R1Y3RzGAIgAygLMicuY3JlYXRpdmFudGEuY29tbWVy'
        'Y2UudjEuVG9wUHJvZHVjdEl0ZW1SCHByb2R1Y3Rz');

@$core.Deprecated('Use campaignServiceLinkContentRequestDescriptor instead')
const CampaignServiceLinkContentRequest$json = {
  '1': 'CampaignServiceLinkContentRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'campaign_id', '3': 2, '4': 1, '5': 9, '10': 'campaignId'},
    {'1': 'post_id', '3': 3, '4': 1, '5': 9, '10': 'postId'},
    {
      '1': 'command_context',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.CommandContext',
      '10': 'commandContext'
    },
  ],
};

/// Descriptor for `CampaignServiceLinkContentRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List campaignServiceLinkContentRequestDescriptor =
    $convert.base64Decode(
        'CiFDYW1wYWlnblNlcnZpY2VMaW5rQ29udGVudFJlcXVlc3QSIQoMd29ya3NwYWNlX2lkGAEgAS'
        'gJUgt3b3Jrc3BhY2VJZBIfCgtjYW1wYWlnbl9pZBgCIAEoCVIKY2FtcGFpZ25JZBIXCgdwb3N0'
        'X2lkGAMgASgJUgZwb3N0SWQSTgoPY29tbWFuZF9jb250ZXh0GAQgASgLMiUuY3JlYXRpdmFudG'
        'EuY29tbW9uLnYxLkNvbW1hbmRDb250ZXh0Ug5jb21tYW5kQ29udGV4dA==');

@$core.Deprecated('Use campaignServiceLinkContentResponseDescriptor instead')
const CampaignServiceLinkContentResponse$json = {
  '1': 'CampaignServiceLinkContentResponse',
  '2': [
    {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
  ],
};

/// Descriptor for `CampaignServiceLinkContentResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List campaignServiceLinkContentResponseDescriptor =
    $convert.base64Decode(
        'CiJDYW1wYWlnblNlcnZpY2VMaW5rQ29udGVudFJlc3BvbnNlEhgKB3N1Y2Nlc3MYASABKAhSB3'
        'N1Y2Nlc3M=');

@$core.Deprecated('Use campaignServiceLinkOfferRequestDescriptor instead')
const CampaignServiceLinkOfferRequest$json = {
  '1': 'CampaignServiceLinkOfferRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'campaign_id', '3': 2, '4': 1, '5': 9, '10': 'campaignId'},
    {'1': 'offer_id', '3': 3, '4': 1, '5': 9, '10': 'offerId'},
    {
      '1': 'command_context',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.CommandContext',
      '10': 'commandContext'
    },
  ],
};

/// Descriptor for `CampaignServiceLinkOfferRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List campaignServiceLinkOfferRequestDescriptor =
    $convert.base64Decode(
        'Ch9DYW1wYWlnblNlcnZpY2VMaW5rT2ZmZXJSZXF1ZXN0EiEKDHdvcmtzcGFjZV9pZBgBIAEoCV'
        'ILd29ya3NwYWNlSWQSHwoLY2FtcGFpZ25faWQYAiABKAlSCmNhbXBhaWduSWQSGQoIb2ZmZXJf'
        'aWQYAyABKAlSB29mZmVySWQSTgoPY29tbWFuZF9jb250ZXh0GAQgASgLMiUuY3JlYXRpdmFudG'
        'EuY29tbW9uLnYxLkNvbW1hbmRDb250ZXh0Ug5jb21tYW5kQ29udGV4dA==');

@$core.Deprecated('Use campaignServiceLinkOfferResponseDescriptor instead')
const CampaignServiceLinkOfferResponse$json = {
  '1': 'CampaignServiceLinkOfferResponse',
  '2': [
    {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
  ],
};

/// Descriptor for `CampaignServiceLinkOfferResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List campaignServiceLinkOfferResponseDescriptor =
    $convert.base64Decode(
        'CiBDYW1wYWlnblNlcnZpY2VMaW5rT2ZmZXJSZXNwb25zZRIYCgdzdWNjZXNzGAEgASgIUgdzdW'
        'NjZXNz');

@$core.Deprecated('Use campaignServiceUnlinkContentRequestDescriptor instead')
const CampaignServiceUnlinkContentRequest$json = {
  '1': 'CampaignServiceUnlinkContentRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'campaign_id', '3': 2, '4': 1, '5': 9, '10': 'campaignId'},
    {'1': 'post_id', '3': 3, '4': 1, '5': 9, '10': 'postId'},
    {
      '1': 'command_context',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.CommandContext',
      '10': 'commandContext'
    },
  ],
};

/// Descriptor for `CampaignServiceUnlinkContentRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List campaignServiceUnlinkContentRequestDescriptor =
    $convert.base64Decode(
        'CiNDYW1wYWlnblNlcnZpY2VVbmxpbmtDb250ZW50UmVxdWVzdBIhCgx3b3Jrc3BhY2VfaWQYAS'
        'ABKAlSC3dvcmtzcGFjZUlkEh8KC2NhbXBhaWduX2lkGAIgASgJUgpjYW1wYWlnbklkEhcKB3Bv'
        'c3RfaWQYAyABKAlSBnBvc3RJZBJOCg9jb21tYW5kX2NvbnRleHQYBCABKAsyJS5jcmVhdGl2YW'
        '50YS5jb21tb24udjEuQ29tbWFuZENvbnRleHRSDmNvbW1hbmRDb250ZXh0');

@$core.Deprecated('Use campaignServiceUnlinkContentResponseDescriptor instead')
const CampaignServiceUnlinkContentResponse$json = {
  '1': 'CampaignServiceUnlinkContentResponse',
  '2': [
    {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
  ],
};

/// Descriptor for `CampaignServiceUnlinkContentResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List campaignServiceUnlinkContentResponseDescriptor =
    $convert.base64Decode(
        'CiRDYW1wYWlnblNlcnZpY2VVbmxpbmtDb250ZW50UmVzcG9uc2USGAoHc3VjY2VzcxgBIAEoCF'
        'IHc3VjY2Vzcw==');

@$core.Deprecated(
    'Use monetizationServiceEvaluateCheckoutRequestDescriptor instead')
const MonetizationServiceEvaluateCheckoutRequest$json = {
  '1': 'MonetizationServiceEvaluateCheckoutRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'offer_id', '3': 2, '4': 1, '5': 9, '10': 'offerId'},
    {'1': 'coupon_code', '3': 3, '4': 1, '5': 9, '10': 'couponCode'},
    {
      '1': 'customer_entity_id',
      '3': 4,
      '4': 1,
      '5': 9,
      '10': 'customerEntityId'
    },
    {'1': 'product_ids', '3': 5, '4': 3, '5': 9, '10': 'productIds'},
    {'1': 'order_amount', '3': 6, '4': 1, '5': 9, '10': 'orderAmount'},
    {'1': 'currency', '3': 7, '4': 1, '5': 9, '10': 'currency'},
    {
      '1': 'command_context',
      '3': 8,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.CommandContext',
      '10': 'commandContext'
    },
  ],
};

/// Descriptor for `MonetizationServiceEvaluateCheckoutRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List
    monetizationServiceEvaluateCheckoutRequestDescriptor =
    $convert.base64Decode(
        'CipNb25ldGl6YXRpb25TZXJ2aWNlRXZhbHVhdGVDaGVja291dFJlcXVlc3QSIQoMd29ya3NwYW'
        'NlX2lkGAEgASgJUgt3b3Jrc3BhY2VJZBIZCghvZmZlcl9pZBgCIAEoCVIHb2ZmZXJJZBIfCgtj'
        'b3Vwb25fY29kZRgDIAEoCVIKY291cG9uQ29kZRIsChJjdXN0b21lcl9lbnRpdHlfaWQYBCABKA'
        'lSEGN1c3RvbWVyRW50aXR5SWQSHwoLcHJvZHVjdF9pZHMYBSADKAlSCnByb2R1Y3RJZHMSIQoM'
        'b3JkZXJfYW1vdW50GAYgASgJUgtvcmRlckFtb3VudBIaCghjdXJyZW5jeRgHIAEoCVIIY3Vycm'
        'VuY3kSTgoPY29tbWFuZF9jb250ZXh0GAggASgLMiUuY3JlYXRpdmFudGEuY29tbW9uLnYxLkNv'
        'bW1hbmRDb250ZXh0Ug5jb21tYW5kQ29udGV4dA==');

@$core.Deprecated(
    'Use monetizationServiceEvaluateCheckoutResponseDescriptor instead')
const MonetizationServiceEvaluateCheckoutResponse$json = {
  '1': 'MonetizationServiceEvaluateCheckoutResponse',
  '2': [
    {'1': 'accepted', '3': 1, '4': 1, '5': 8, '10': 'accepted'},
    {'1': 'error_code', '3': 2, '4': 1, '5': 9, '10': 'errorCode'},
    {'1': 'error_message', '3': 3, '4': 1, '5': 9, '10': 'errorMessage'},
    {'1': 'original_amount', '3': 4, '4': 1, '5': 9, '10': 'originalAmount'},
    {'1': 'discount_amount', '3': 5, '4': 1, '5': 9, '10': 'discountAmount'},
    {
      '1': 'net_payable_amount',
      '3': 6,
      '4': 1,
      '5': 9,
      '10': 'netPayableAmount'
    },
    {'1': 'currency', '3': 7, '4': 1, '5': 9, '10': 'currency'},
    {'1': 'order_id', '3': 8, '4': 1, '5': 9, '10': 'orderId'},
    {'1': 'posting_id', '3': 9, '4': 1, '5': 9, '10': 'postingId'},
    {'1': 'coupon_id', '3': 10, '4': 1, '5': 9, '10': 'couponId'},
    {
      '1': 'coupon_remaining_uses',
      '3': 11,
      '4': 1,
      '5': 5,
      '10': 'couponRemainingUses'
    },
  ],
};

/// Descriptor for `MonetizationServiceEvaluateCheckoutResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List monetizationServiceEvaluateCheckoutResponseDescriptor = $convert.base64Decode(
    'CitNb25ldGl6YXRpb25TZXJ2aWNlRXZhbHVhdGVDaGVja291dFJlc3BvbnNlEhoKCGFjY2VwdG'
    'VkGAEgASgIUghhY2NlcHRlZBIdCgplcnJvcl9jb2RlGAIgASgJUgllcnJvckNvZGUSIwoNZXJy'
    'b3JfbWVzc2FnZRgDIAEoCVIMZXJyb3JNZXNzYWdlEicKD29yaWdpbmFsX2Ftb3VudBgEIAEoCV'
    'IOb3JpZ2luYWxBbW91bnQSJwoPZGlzY291bnRfYW1vdW50GAUgASgJUg5kaXNjb3VudEFtb3Vu'
    'dBIsChJuZXRfcGF5YWJsZV9hbW91bnQYBiABKAlSEG5ldFBheWFibGVBbW91bnQSGgoIY3Vycm'
    'VuY3kYByABKAlSCGN1cnJlbmN5EhkKCG9yZGVyX2lkGAggASgJUgdvcmRlcklkEh0KCnBvc3Rp'
    'bmdfaWQYCSABKAlSCXBvc3RpbmdJZBIbCgljb3Vwb25faWQYCiABKAlSCGNvdXBvbklkEjIKFW'
    'NvdXBvbl9yZW1haW5pbmdfdXNlcxgLIAEoBVITY291cG9uUmVtYWluaW5nVXNlcw==');

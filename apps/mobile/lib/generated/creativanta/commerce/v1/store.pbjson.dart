// This is a generated file - do not edit.
//
// Generated from creativanta/commerce/v1/store.proto.

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

@$core.Deprecated('Use storePageStatusDescriptor instead')
const StorePageStatus$json = {
  '1': 'StorePageStatus',
  '2': [
    {'1': 'STORE_PAGE_STATUS_UNSPECIFIED', '2': 0},
    {'1': 'STORE_PAGE_STATUS_DRAFT', '2': 1},
    {'1': 'STORE_PAGE_STATUS_PUBLISHED', '2': 2},
    {'1': 'STORE_PAGE_STATUS_HIDDEN', '2': 3},
    {'1': 'STORE_PAGE_STATUS_RETIRED', '2': 4},
  ],
};

/// Descriptor for `StorePageStatus`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List storePageStatusDescriptor = $convert.base64Decode(
    'Cg9TdG9yZVBhZ2VTdGF0dXMSIQodU1RPUkVfUEFHRV9TVEFUVVNfVU5TUEVDSUZJRUQQABIbCh'
    'dTVE9SRV9QQUdFX1NUQVRVU19EUkFGVBABEh8KG1NUT1JFX1BBR0VfU1RBVFVTX1BVQkxJU0hF'
    'RBACEhwKGFNUT1JFX1BBR0VfU1RBVFVTX0hJRERFThADEh0KGVNUT1JFX1BBR0VfU1RBVFVTX1'
    'JFVElSRUQQBA==');

@$core.Deprecated('Use membershipPlanStatusDescriptor instead')
const MembershipPlanStatus$json = {
  '1': 'MembershipPlanStatus',
  '2': [
    {'1': 'MEMBERSHIP_PLAN_STATUS_UNSPECIFIED', '2': 0},
    {'1': 'MEMBERSHIP_PLAN_STATUS_DRAFT', '2': 1},
    {'1': 'MEMBERSHIP_PLAN_STATUS_ACTIVE', '2': 2},
    {'1': 'MEMBERSHIP_PLAN_STATUS_HIDDEN', '2': 3},
    {'1': 'MEMBERSHIP_PLAN_STATUS_PAUSED', '2': 4},
    {'1': 'MEMBERSHIP_PLAN_STATUS_RETIRED', '2': 5},
  ],
};

/// Descriptor for `MembershipPlanStatus`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List membershipPlanStatusDescriptor = $convert.base64Decode(
    'ChRNZW1iZXJzaGlwUGxhblN0YXR1cxImCiJNRU1CRVJTSElQX1BMQU5fU1RBVFVTX1VOU1BFQ0'
    'lGSUVEEAASIAocTUVNQkVSU0hJUF9QTEFOX1NUQVRVU19EUkFGVBABEiEKHU1FTUJFUlNISVBf'
    'UExBTl9TVEFUVVNfQUNUSVZFEAISIQodTUVNQkVSU0hJUF9QTEFOX1NUQVRVU19ISURERU4QAx'
    'IhCh1NRU1CRVJTSElQX1BMQU5fU1RBVFVTX1BBVVNFRBAEEiIKHk1FTUJFUlNISVBfUExBTl9T'
    'VEFUVVNfUkVUSVJFRBAF');

@$core.Deprecated('Use membershipSubscriptionStatusDescriptor instead')
const MembershipSubscriptionStatus$json = {
  '1': 'MembershipSubscriptionStatus',
  '2': [
    {'1': 'MEMBERSHIP_SUBSCRIPTION_STATUS_UNSPECIFIED', '2': 0},
    {'1': 'MEMBERSHIP_SUBSCRIPTION_STATUS_ACTIVE', '2': 1},
    {'1': 'MEMBERSHIP_SUBSCRIPTION_STATUS_CANCELLED', '2': 2},
    {'1': 'MEMBERSHIP_SUBSCRIPTION_STATUS_EXPIRED', '2': 3},
  ],
};

/// Descriptor for `MembershipSubscriptionStatus`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List membershipSubscriptionStatusDescriptor = $convert.base64Decode(
    'ChxNZW1iZXJzaGlwU3Vic2NyaXB0aW9uU3RhdHVzEi4KKk1FTUJFUlNISVBfU1VCU0NSSVBUSU'
    '9OX1NUQVRVU19VTlNQRUNJRklFRBAAEikKJU1FTUJFUlNISVBfU1VCU0NSSVBUSU9OX1NUQVRV'
    'U19BQ1RJVkUQARIsCihNRU1CRVJTSElQX1NVQlNDUklQVElPTl9TVEFUVVNfQ0FOQ0VMTEVEEA'
    'ISKgomTUVNQkVSU0hJUF9TVUJTQ1JJUFRJT05fU1RBVFVTX0VYUElSRUQQAw==');

@$core.Deprecated('Use deliveryTypeDescriptor instead')
const DeliveryType$json = {
  '1': 'DeliveryType',
  '2': [
    {'1': 'DELIVERY_TYPE_UNSPECIFIED', '2': 0},
    {'1': 'DELIVERY_TYPE_DOWNLOAD_LINK', '2': 1},
    {'1': 'DELIVERY_TYPE_LICENSE_KEY', '2': 2},
    {'1': 'DELIVERY_TYPE_ACCESS_GRANT', '2': 3},
  ],
};

/// Descriptor for `DeliveryType`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List deliveryTypeDescriptor = $convert.base64Decode(
    'CgxEZWxpdmVyeVR5cGUSHQoZREVMSVZFUllfVFlQRV9VTlNQRUNJRklFRBAAEh8KG0RFTElWRV'
    'JZX1RZUEVfRE9XTkxPQURfTElOSxABEh0KGURFTElWRVJZX1RZUEVfTElDRU5TRV9LRVkQAhIe'
    'ChpERUxJVkVSWV9UWVBFX0FDQ0VTU19HUkFOVBAD');

@$core.Deprecated('Use deliveryStatusDescriptor instead')
const DeliveryStatus$json = {
  '1': 'DeliveryStatus',
  '2': [
    {'1': 'DELIVERY_STATUS_UNSPECIFIED', '2': 0},
    {'1': 'DELIVERY_STATUS_PENDING', '2': 1},
    {'1': 'DELIVERY_STATUS_DELIVERED', '2': 2},
    {'1': 'DELIVERY_STATUS_REVOKED', '2': 3},
  ],
};

/// Descriptor for `DeliveryStatus`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List deliveryStatusDescriptor = $convert.base64Decode(
    'Cg5EZWxpdmVyeVN0YXR1cxIfChtERUxJVkVSWV9TVEFUVVNfVU5TUEVDSUZJRUQQABIbChdERU'
    'xJVkVSWV9TVEFUVVNfUEVORElORxABEh0KGURFTElWRVJZX1NUQVRVU19ERUxJVkVSRUQQAhIb'
    'ChdERUxJVkVSWV9TVEFUVVNfUkVWT0tFRBAD');

@$core.Deprecated('Use storePageDescriptor instead')
const StorePage$json = {
  '1': 'StorePage',
  '2': [
    {'1': 'store_page_id', '3': 1, '4': 1, '5': 9, '10': 'storePageId'},
    {'1': 'workspace_id', '3': 2, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'title', '3': 3, '4': 1, '5': 9, '10': 'title'},
    {'1': 'slug', '3': 4, '4': 1, '5': 9, '10': 'slug'},
    {'1': 'description', '3': 5, '4': 1, '5': 9, '10': 'description'},
    {'1': 'layout_json', '3': 6, '4': 1, '5': 9, '10': 'layoutJson'},
    {
      '1': 'theme_overrides_json',
      '3': 7,
      '4': 1,
      '5': 9,
      '10': 'themeOverridesJson'
    },
    {
      '1': 'status',
      '3': 8,
      '4': 1,
      '5': 14,
      '6': '.creativanta.commerce.v1.StorePageStatus',
      '10': 'status'
    },
    {'1': 'custom_domain', '3': 9, '4': 1, '5': 9, '10': 'customDomain'},
    {'1': 'seo_config_json', '3': 10, '4': 1, '5': 9, '10': 'seoConfigJson'},
    {
      '1': 'widget_config_json',
      '3': 11,
      '4': 1,
      '5': 9,
      '10': 'widgetConfigJson'
    },
    {
      '1': 'created_at',
      '3': 12,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'createdAt'
    },
    {
      '1': 'updated_at',
      '3': 13,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'updatedAt'
    },
    {
      '1': 'deleted_at',
      '3': 14,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'deletedAt'
    },
  ],
};

/// Descriptor for `StorePage`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List storePageDescriptor = $convert.base64Decode(
    'CglTdG9yZVBhZ2USIgoNc3RvcmVfcGFnZV9pZBgBIAEoCVILc3RvcmVQYWdlSWQSIQoMd29ya3'
    'NwYWNlX2lkGAIgASgJUgt3b3Jrc3BhY2VJZBIUCgV0aXRsZRgDIAEoCVIFdGl0bGUSEgoEc2x1'
    'ZxgEIAEoCVIEc2x1ZxIgCgtkZXNjcmlwdGlvbhgFIAEoCVILZGVzY3JpcHRpb24SHwoLbGF5b3'
    'V0X2pzb24YBiABKAlSCmxheW91dEpzb24SMAoUdGhlbWVfb3ZlcnJpZGVzX2pzb24YByABKAlS'
    'EnRoZW1lT3ZlcnJpZGVzSnNvbhJACgZzdGF0dXMYCCABKA4yKC5jcmVhdGl2YW50YS5jb21tZX'
    'JjZS52MS5TdG9yZVBhZ2VTdGF0dXNSBnN0YXR1cxIjCg1jdXN0b21fZG9tYWluGAkgASgJUgxj'
    'dXN0b21Eb21haW4SJgoPc2VvX2NvbmZpZ19qc29uGAogASgJUg1zZW9Db25maWdKc29uEiwKEn'
    'dpZGdldF9jb25maWdfanNvbhgLIAEoCVIQd2lkZ2V0Q29uZmlnSnNvbhI5CgpjcmVhdGVkX2F0'
    'GAwgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIJY3JlYXRlZEF0EjkKCnVwZGF0ZW'
    'RfYXQYDSABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUgl1cGRhdGVkQXQSOQoKZGVs'
    'ZXRlZF9hdBgOIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSCWRlbGV0ZWRBdA==');

@$core.Deprecated('Use storeThemeDescriptor instead')
const StoreTheme$json = {
  '1': 'StoreTheme',
  '2': [
    {'1': 'theme_id', '3': 1, '4': 1, '5': 9, '10': 'themeId'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    {'1': 'primary_color', '3': 3, '4': 1, '5': 9, '10': 'primaryColor'},
    {'1': 'font_family', '3': 4, '4': 1, '5': 9, '10': 'fontFamily'},
    {'1': 'border_radius', '3': 5, '4': 1, '5': 9, '10': 'borderRadius'},
    {'1': 'is_default', '3': 6, '4': 1, '5': 8, '10': 'isDefault'},
  ],
};

/// Descriptor for `StoreTheme`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List storeThemeDescriptor = $convert.base64Decode(
    'CgpTdG9yZVRoZW1lEhkKCHRoZW1lX2lkGAEgASgJUgd0aGVtZUlkEhIKBG5hbWUYAiABKAlSBG'
    '5hbWUSIwoNcHJpbWFyeV9jb2xvchgDIAEoCVIMcHJpbWFyeUNvbG9yEh8KC2ZvbnRfZmFtaWx5'
    'GAQgASgJUgpmb250RmFtaWx5EiMKDWJvcmRlcl9yYWRpdXMYBSABKAlSDGJvcmRlclJhZGl1cx'
    'IdCgppc19kZWZhdWx0GAYgASgIUglpc0RlZmF1bHQ=');

@$core.Deprecated('Use pageStatsDescriptor instead')
const PageStats$json = {
  '1': 'PageStats',
  '2': [
    {'1': 'store_page_id', '3': 1, '4': 1, '5': 9, '10': 'storePageId'},
    {'1': 'views', '3': 2, '4': 1, '5': 3, '10': 'views'},
    {'1': 'orders', '3': 3, '4': 1, '5': 3, '10': 'orders'},
    {'1': 'conversion_rate', '3': 4, '4': 1, '5': 1, '10': 'conversionRate'},
    {'1': 'revenue', '3': 5, '4': 1, '5': 9, '10': 'revenue'},
    {'1': 'currency', '3': 6, '4': 1, '5': 9, '10': 'currency'},
  ],
};

/// Descriptor for `PageStats`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List pageStatsDescriptor = $convert.base64Decode(
    'CglQYWdlU3RhdHMSIgoNc3RvcmVfcGFnZV9pZBgBIAEoCVILc3RvcmVQYWdlSWQSFAoFdmlld3'
    'MYAiABKANSBXZpZXdzEhYKBm9yZGVycxgDIAEoA1IGb3JkZXJzEicKD2NvbnZlcnNpb25fcmF0'
    'ZRgEIAEoAVIOY29udmVyc2lvblJhdGUSGAoHcmV2ZW51ZRgFIAEoCVIHcmV2ZW51ZRIaCghjdX'
    'JyZW5jeRgGIAEoCVIIY3VycmVuY3k=');

@$core.Deprecated('Use membershipPlanDescriptor instead')
const MembershipPlan$json = {
  '1': 'MembershipPlan',
  '2': [
    {'1': 'plan_id', '3': 1, '4': 1, '5': 9, '10': 'planId'},
    {'1': 'workspace_id', '3': 2, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'title', '3': 3, '4': 1, '5': 9, '10': 'title'},
    {'1': 'description', '3': 4, '4': 1, '5': 9, '10': 'description'},
    {'1': 'price', '3': 5, '4': 1, '5': 9, '10': 'price'},
    {'1': 'currency', '3': 6, '4': 1, '5': 9, '10': 'currency'},
    {'1': 'billing_interval', '3': 7, '4': 1, '5': 9, '10': 'billingInterval'},
    {'1': 'benefits_json', '3': 8, '4': 1, '5': 9, '10': 'benefitsJson'},
    {
      '1': 'entitlement_config_json',
      '3': 9,
      '4': 1,
      '5': 9,
      '10': 'entitlementConfigJson'
    },
    {
      '1': 'status',
      '3': 10,
      '4': 1,
      '5': 14,
      '6': '.creativanta.commerce.v1.MembershipPlanStatus',
      '10': 'status'
    },
    {'1': 'subscriber_count', '3': 11, '4': 1, '5': 5, '10': 'subscriberCount'},
    {
      '1': 'created_at',
      '3': 12,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'createdAt'
    },
    {
      '1': 'updated_at',
      '3': 13,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'updatedAt'
    },
    {
      '1': 'deleted_at',
      '3': 14,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'deletedAt'
    },
  ],
};

/// Descriptor for `MembershipPlan`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List membershipPlanDescriptor = $convert.base64Decode(
    'Cg5NZW1iZXJzaGlwUGxhbhIXCgdwbGFuX2lkGAEgASgJUgZwbGFuSWQSIQoMd29ya3NwYWNlX2'
    'lkGAIgASgJUgt3b3Jrc3BhY2VJZBIUCgV0aXRsZRgDIAEoCVIFdGl0bGUSIAoLZGVzY3JpcHRp'
    'b24YBCABKAlSC2Rlc2NyaXB0aW9uEhQKBXByaWNlGAUgASgJUgVwcmljZRIaCghjdXJyZW5jeR'
    'gGIAEoCVIIY3VycmVuY3kSKQoQYmlsbGluZ19pbnRlcnZhbBgHIAEoCVIPYmlsbGluZ0ludGVy'
    'dmFsEiMKDWJlbmVmaXRzX2pzb24YCCABKAlSDGJlbmVmaXRzSnNvbhI2ChdlbnRpdGxlbWVudF'
    '9jb25maWdfanNvbhgJIAEoCVIVZW50aXRsZW1lbnRDb25maWdKc29uEkUKBnN0YXR1cxgKIAEo'
    'DjItLmNyZWF0aXZhbnRhLmNvbW1lcmNlLnYxLk1lbWJlcnNoaXBQbGFuU3RhdHVzUgZzdGF0dX'
    'MSKQoQc3Vic2NyaWJlcl9jb3VudBgLIAEoBVIPc3Vic2NyaWJlckNvdW50EjkKCmNyZWF0ZWRf'
    'YXQYDCABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUgljcmVhdGVkQXQSOQoKdXBkYX'
    'RlZF9hdBgNIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSCXVwZGF0ZWRBdBI5Cgpk'
    'ZWxldGVkX2F0GA4gASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIJZGVsZXRlZEF0');

@$core.Deprecated('Use membershipSubscriptionDescriptor instead')
const MembershipSubscription$json = {
  '1': 'MembershipSubscription',
  '2': [
    {'1': 'membership_id', '3': 1, '4': 1, '5': 9, '10': 'membershipId'},
    {'1': 'workspace_id', '3': 2, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'plan_id', '3': 3, '4': 1, '5': 9, '10': 'planId'},
    {
      '1': 'customer_entity_id',
      '3': 4,
      '4': 1,
      '5': 9,
      '10': 'customerEntityId'
    },
    {
      '1': 'status',
      '3': 5,
      '4': 1,
      '5': 14,
      '6': '.creativanta.commerce.v1.MembershipSubscriptionStatus',
      '10': 'status'
    },
    {
      '1': 'provider_subscription_id',
      '3': 6,
      '4': 1,
      '5': 9,
      '10': 'providerSubscriptionId'
    },
    {
      '1': 'current_period_start',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'currentPeriodStart'
    },
    {
      '1': 'current_period_end',
      '3': 8,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'currentPeriodEnd'
    },
    {
      '1': 'entitlement_snapshot_json',
      '3': 9,
      '4': 1,
      '5': 9,
      '10': 'entitlementSnapshotJson'
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

/// Descriptor for `MembershipSubscription`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List membershipSubscriptionDescriptor = $convert.base64Decode(
    'ChZNZW1iZXJzaGlwU3Vic2NyaXB0aW9uEiMKDW1lbWJlcnNoaXBfaWQYASABKAlSDG1lbWJlcn'
    'NoaXBJZBIhCgx3b3Jrc3BhY2VfaWQYAiABKAlSC3dvcmtzcGFjZUlkEhcKB3BsYW5faWQYAyAB'
    'KAlSBnBsYW5JZBIsChJjdXN0b21lcl9lbnRpdHlfaWQYBCABKAlSEGN1c3RvbWVyRW50aXR5SW'
    'QSTQoGc3RhdHVzGAUgASgOMjUuY3JlYXRpdmFudGEuY29tbWVyY2UudjEuTWVtYmVyc2hpcFN1'
    'YnNjcmlwdGlvblN0YXR1c1IGc3RhdHVzEjgKGHByb3ZpZGVyX3N1YnNjcmlwdGlvbl9pZBgGIA'
    'EoCVIWcHJvdmlkZXJTdWJzY3JpcHRpb25JZBJMChRjdXJyZW50X3BlcmlvZF9zdGFydBgHIAEo'
    'CzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSEmN1cnJlbnRQZXJpb2RTdGFydBJIChJjdX'
    'JyZW50X3BlcmlvZF9lbmQYCCABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUhBjdXJy'
    'ZW50UGVyaW9kRW5kEjoKGWVudGl0bGVtZW50X3NuYXBzaG90X2pzb24YCSABKAlSF2VudGl0bG'
    'VtZW50U25hcHNob3RKc29uEjkKCmNyZWF0ZWRfYXQYCiABKAsyGi5nb29nbGUucHJvdG9idWYu'
    'VGltZXN0YW1wUgljcmVhdGVkQXQSOQoKdXBkYXRlZF9hdBgLIAEoCzIaLmdvb2dsZS5wcm90b2'
    'J1Zi5UaW1lc3RhbXBSCXVwZGF0ZWRBdA==');

@$core.Deprecated('Use bundleItemDescriptor instead')
const BundleItem$json = {
  '1': 'BundleItem',
  '2': [
    {'1': 'bundle_id', '3': 1, '4': 1, '5': 9, '10': 'bundleId'},
    {'1': 'product_id', '3': 2, '4': 1, '5': 9, '10': 'productId'},
    {'1': 'quantity', '3': 3, '4': 1, '5': 5, '10': 'quantity'},
    {'1': 'product_title', '3': 4, '4': 1, '5': 9, '10': 'productTitle'},
    {'1': 'available_stock', '3': 5, '4': 1, '5': 5, '10': 'availableStock'},
  ],
};

/// Descriptor for `BundleItem`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List bundleItemDescriptor = $convert.base64Decode(
    'CgpCdW5kbGVJdGVtEhsKCWJ1bmRsZV9pZBgBIAEoCVIIYnVuZGxlSWQSHQoKcHJvZHVjdF9pZB'
    'gCIAEoCVIJcHJvZHVjdElkEhoKCHF1YW50aXR5GAMgASgFUghxdWFudGl0eRIjCg1wcm9kdWN0'
    'X3RpdGxlGAQgASgJUgxwcm9kdWN0VGl0bGUSJwoPYXZhaWxhYmxlX3N0b2NrGAUgASgFUg5hdm'
    'FpbGFibGVTdG9jaw==');

@$core.Deprecated('Use bundleDescriptor instead')
const Bundle$json = {
  '1': 'Bundle',
  '2': [
    {'1': 'bundle_id', '3': 1, '4': 1, '5': 9, '10': 'bundleId'},
    {'1': 'workspace_id', '3': 2, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'title', '3': 3, '4': 1, '5': 9, '10': 'title'},
    {'1': 'offer_id', '3': 4, '4': 1, '5': 9, '10': 'offerId'},
    {'1': 'bundle_price', '3': 5, '4': 1, '5': 9, '10': 'bundlePrice'},
    {'1': 'discount_pct', '3': 6, '4': 1, '5': 1, '10': 'discountPct'},
    {'1': 'status', '3': 7, '4': 1, '5': 9, '10': 'status'},
    {
      '1': 'items',
      '3': 8,
      '4': 3,
      '5': 11,
      '6': '.creativanta.commerce.v1.BundleItem',
      '10': 'items'
    },
    {'1': 'is_available', '3': 9, '4': 1, '5': 8, '10': 'isAvailable'},
    {
      '1': 'unavailable_reason',
      '3': 10,
      '4': 1,
      '5': 9,
      '10': 'unavailableReason'
    },
    {
      '1': 'created_at',
      '3': 11,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'createdAt'
    },
  ],
};

/// Descriptor for `Bundle`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List bundleDescriptor = $convert.base64Decode(
    'CgZCdW5kbGUSGwoJYnVuZGxlX2lkGAEgASgJUghidW5kbGVJZBIhCgx3b3Jrc3BhY2VfaWQYAi'
    'ABKAlSC3dvcmtzcGFjZUlkEhQKBXRpdGxlGAMgASgJUgV0aXRsZRIZCghvZmZlcl9pZBgEIAEo'
    'CVIHb2ZmZXJJZBIhCgxidW5kbGVfcHJpY2UYBSABKAlSC2J1bmRsZVByaWNlEiEKDGRpc2NvdW'
    '50X3BjdBgGIAEoAVILZGlzY291bnRQY3QSFgoGc3RhdHVzGAcgASgJUgZzdGF0dXMSOQoFaXRl'
    'bXMYCCADKAsyIy5jcmVhdGl2YW50YS5jb21tZXJjZS52MS5CdW5kbGVJdGVtUgVpdGVtcxIhCg'
    'xpc19hdmFpbGFibGUYCSABKAhSC2lzQXZhaWxhYmxlEi0KEnVuYXZhaWxhYmxlX3JlYXNvbhgK'
    'IAEoCVIRdW5hdmFpbGFibGVSZWFzb24SOQoKY3JlYXRlZF9hdBgLIAEoCzIaLmdvb2dsZS5wcm'
    '90b2J1Zi5UaW1lc3RhbXBSCWNyZWF0ZWRBdA==');

@$core.Deprecated('Use digitalDeliveryDescriptor instead')
const DigitalDelivery$json = {
  '1': 'DigitalDelivery',
  '2': [
    {'1': 'delivery_id', '3': 1, '4': 1, '5': 9, '10': 'deliveryId'},
    {'1': 'workspace_id', '3': 2, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'order_id', '3': 3, '4': 1, '5': 9, '10': 'orderId'},
    {
      '1': 'customer_entity_id',
      '3': 4,
      '4': 1,
      '5': 9,
      '10': 'customerEntityId'
    },
    {'1': 'product_id', '3': 5, '4': 1, '5': 9, '10': 'productId'},
    {'1': 'offer_id', '3': 6, '4': 1, '5': 9, '10': 'offerId'},
    {
      '1': 'delivery_type',
      '3': 7,
      '4': 1,
      '5': 14,
      '6': '.creativanta.commerce.v1.DeliveryType',
      '10': 'deliveryType'
    },
    {
      '1': 'entitlement_payload_json',
      '3': 8,
      '4': 1,
      '5': 9,
      '10': 'entitlementPayloadJson'
    },
    {
      '1': 'status',
      '3': 9,
      '4': 1,
      '5': 14,
      '6': '.creativanta.commerce.v1.DeliveryStatus',
      '10': 'status'
    },
    {'1': 'idempotency_key', '3': 10, '4': 1, '5': 9, '10': 'idempotencyKey'},
    {'1': 'download_count', '3': 11, '4': 1, '5': 5, '10': 'downloadCount'},
    {'1': 'max_downloads', '3': 12, '4': 1, '5': 5, '10': 'maxDownloads'},
    {
      '1': 'expires_at',
      '3': 13,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'expiresAt'
    },
    {
      '1': 'created_at',
      '3': 14,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'createdAt'
    },
  ],
};

/// Descriptor for `DigitalDelivery`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List digitalDeliveryDescriptor = $convert.base64Decode(
    'Cg9EaWdpdGFsRGVsaXZlcnkSHwoLZGVsaXZlcnlfaWQYASABKAlSCmRlbGl2ZXJ5SWQSIQoMd2'
    '9ya3NwYWNlX2lkGAIgASgJUgt3b3Jrc3BhY2VJZBIZCghvcmRlcl9pZBgDIAEoCVIHb3JkZXJJ'
    'ZBIsChJjdXN0b21lcl9lbnRpdHlfaWQYBCABKAlSEGN1c3RvbWVyRW50aXR5SWQSHQoKcHJvZH'
    'VjdF9pZBgFIAEoCVIJcHJvZHVjdElkEhkKCG9mZmVyX2lkGAYgASgJUgdvZmZlcklkEkoKDWRl'
    'bGl2ZXJ5X3R5cGUYByABKA4yJS5jcmVhdGl2YW50YS5jb21tZXJjZS52MS5EZWxpdmVyeVR5cG'
    'VSDGRlbGl2ZXJ5VHlwZRI4ChhlbnRpdGxlbWVudF9wYXlsb2FkX2pzb24YCCABKAlSFmVudGl0'
    'bGVtZW50UGF5bG9hZEpzb24SPwoGc3RhdHVzGAkgASgOMicuY3JlYXRpdmFudGEuY29tbWVyY2'
    'UudjEuRGVsaXZlcnlTdGF0dXNSBnN0YXR1cxInCg9pZGVtcG90ZW5jeV9rZXkYCiABKAlSDmlk'
    'ZW1wb3RlbmN5S2V5EiUKDmRvd25sb2FkX2NvdW50GAsgASgFUg1kb3dubG9hZENvdW50EiMKDW'
    '1heF9kb3dubG9hZHMYDCABKAVSDG1heERvd25sb2FkcxI5CgpleHBpcmVzX2F0GA0gASgLMhou'
    'Z29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIJZXhwaXJlc0F0EjkKCmNyZWF0ZWRfYXQYDiABKA'
    'syGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUgljcmVhdGVkQXQ=');

@$core.Deprecated('Use buyerEntitlementsDescriptor instead')
const BuyerEntitlements$json = {
  '1': 'BuyerEntitlements',
  '2': [
    {
      '1': 'customer_entity_id',
      '3': 1,
      '4': 1,
      '5': 9,
      '10': 'customerEntityId'
    },
    {'1': 'workspace_id', '3': 2, '4': 1, '5': 9, '10': 'workspaceId'},
    {
      '1': 'accessible_content_ids',
      '3': 3,
      '4': 3,
      '5': 9,
      '10': 'accessibleContentIds'
    },
    {'1': 'discount_pct', '3': 4, '4': 1, '5': 1, '10': 'discountPct'},
    {'1': 'has_priority_dm', '3': 5, '4': 1, '5': 8, '10': 'hasPriorityDm'},
    {
      '1': 'deliveries',
      '3': 6,
      '4': 3,
      '5': 11,
      '6': '.creativanta.commerce.v1.DigitalDelivery',
      '10': 'deliveries'
    },
    {
      '1': 'active_subscriptions',
      '3': 7,
      '4': 3,
      '5': 11,
      '6': '.creativanta.commerce.v1.MembershipSubscription',
      '10': 'activeSubscriptions'
    },
  ],
};

/// Descriptor for `BuyerEntitlements`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List buyerEntitlementsDescriptor = $convert.base64Decode(
    'ChFCdXllckVudGl0bGVtZW50cxIsChJjdXN0b21lcl9lbnRpdHlfaWQYASABKAlSEGN1c3RvbW'
    'VyRW50aXR5SWQSIQoMd29ya3NwYWNlX2lkGAIgASgJUgt3b3Jrc3BhY2VJZBI0ChZhY2Nlc3Np'
    'YmxlX2NvbnRlbnRfaWRzGAMgAygJUhRhY2Nlc3NpYmxlQ29udGVudElkcxIhCgxkaXNjb3VudF'
    '9wY3QYBCABKAFSC2Rpc2NvdW50UGN0EiYKD2hhc19wcmlvcml0eV9kbRgFIAEoCFINaGFzUHJp'
    'b3JpdHlEbRJICgpkZWxpdmVyaWVzGAYgAygLMiguY3JlYXRpdmFudGEuY29tbWVyY2UudjEuRG'
    'lnaXRhbERlbGl2ZXJ5UgpkZWxpdmVyaWVzEmIKFGFjdGl2ZV9zdWJzY3JpcHRpb25zGAcgAygL'
    'Mi8uY3JlYXRpdmFudGEuY29tbWVyY2UudjEuTWVtYmVyc2hpcFN1YnNjcmlwdGlvblITYWN0aX'
    'ZlU3Vic2NyaXB0aW9ucw==');

@$core.Deprecated('Use storeServiceCreatePageRequestDescriptor instead')
const StoreServiceCreatePageRequest$json = {
  '1': 'StoreServiceCreatePageRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'title', '3': 2, '4': 1, '5': 9, '10': 'title'},
    {'1': 'slug', '3': 3, '4': 1, '5': 9, '10': 'slug'},
    {'1': 'description', '3': 4, '4': 1, '5': 9, '10': 'description'},
    {'1': 'layout_json', '3': 5, '4': 1, '5': 9, '10': 'layoutJson'},
    {
      '1': 'theme_overrides_json',
      '3': 6,
      '4': 1,
      '5': 9,
      '10': 'themeOverridesJson'
    },
    {'1': 'custom_domain', '3': 7, '4': 1, '5': 9, '10': 'customDomain'},
    {'1': 'seo_config_json', '3': 8, '4': 1, '5': 9, '10': 'seoConfigJson'},
    {
      '1': 'widget_config_json',
      '3': 9,
      '4': 1,
      '5': 9,
      '10': 'widgetConfigJson'
    },
    {
      '1': 'command_context',
      '3': 10,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.CommandContext',
      '10': 'commandContext'
    },
  ],
};

/// Descriptor for `StoreServiceCreatePageRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List storeServiceCreatePageRequestDescriptor = $convert.base64Decode(
    'Ch1TdG9yZVNlcnZpY2VDcmVhdGVQYWdlUmVxdWVzdBIhCgx3b3Jrc3BhY2VfaWQYASABKAlSC3'
    'dvcmtzcGFjZUlkEhQKBXRpdGxlGAIgASgJUgV0aXRsZRISCgRzbHVnGAMgASgJUgRzbHVnEiAK'
    'C2Rlc2NyaXB0aW9uGAQgASgJUgtkZXNjcmlwdGlvbhIfCgtsYXlvdXRfanNvbhgFIAEoCVIKbG'
    'F5b3V0SnNvbhIwChR0aGVtZV9vdmVycmlkZXNfanNvbhgGIAEoCVISdGhlbWVPdmVycmlkZXNK'
    'c29uEiMKDWN1c3RvbV9kb21haW4YByABKAlSDGN1c3RvbURvbWFpbhImCg9zZW9fY29uZmlnX2'
    'pzb24YCCABKAlSDXNlb0NvbmZpZ0pzb24SLAoSd2lkZ2V0X2NvbmZpZ19qc29uGAkgASgJUhB3'
    'aWRnZXRDb25maWdKc29uEk4KD2NvbW1hbmRfY29udGV4dBgKIAEoCzIlLmNyZWF0aXZhbnRhLm'
    'NvbW1vbi52MS5Db21tYW5kQ29udGV4dFIOY29tbWFuZENvbnRleHQ=');

@$core.Deprecated('Use storeServiceCreatePageResponseDescriptor instead')
const StoreServiceCreatePageResponse$json = {
  '1': 'StoreServiceCreatePageResponse',
  '2': [
    {
      '1': 'page',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.commerce.v1.StorePage',
      '10': 'page'
    },
  ],
};

/// Descriptor for `StoreServiceCreatePageResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List storeServiceCreatePageResponseDescriptor =
    $convert.base64Decode(
        'Ch5TdG9yZVNlcnZpY2VDcmVhdGVQYWdlUmVzcG9uc2USNgoEcGFnZRgBIAEoCzIiLmNyZWF0aX'
        'ZhbnRhLmNvbW1lcmNlLnYxLlN0b3JlUGFnZVIEcGFnZQ==');

@$core.Deprecated('Use storeServiceGetRequestDescriptor instead')
const StoreServiceGetRequest$json = {
  '1': 'StoreServiceGetRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'store_page_id', '3': 2, '4': 1, '5': 9, '10': 'storePageId'},
    {'1': 'slug', '3': 3, '4': 1, '5': 9, '10': 'slug'},
  ],
};

/// Descriptor for `StoreServiceGetRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List storeServiceGetRequestDescriptor = $convert.base64Decode(
    'ChZTdG9yZVNlcnZpY2VHZXRSZXF1ZXN0EiEKDHdvcmtzcGFjZV9pZBgBIAEoCVILd29ya3NwYW'
    'NlSWQSIgoNc3RvcmVfcGFnZV9pZBgCIAEoCVILc3RvcmVQYWdlSWQSEgoEc2x1ZxgDIAEoCVIE'
    'c2x1Zw==');

@$core.Deprecated('Use storeServiceGetResponseDescriptor instead')
const StoreServiceGetResponse$json = {
  '1': 'StoreServiceGetResponse',
  '2': [
    {
      '1': 'page',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.commerce.v1.StorePage',
      '10': 'page'
    },
    {
      '1': 'featured_bundles',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.creativanta.commerce.v1.Bundle',
      '10': 'featuredBundles'
    },
  ],
};

/// Descriptor for `StoreServiceGetResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List storeServiceGetResponseDescriptor = $convert.base64Decode(
    'ChdTdG9yZVNlcnZpY2VHZXRSZXNwb25zZRI2CgRwYWdlGAEgASgLMiIuY3JlYXRpdmFudGEuY2'
    '9tbWVyY2UudjEuU3RvcmVQYWdlUgRwYWdlEkoKEGZlYXR1cmVkX2J1bmRsZXMYAiADKAsyHy5j'
    'cmVhdGl2YW50YS5jb21tZXJjZS52MS5CdW5kbGVSD2ZlYXR1cmVkQnVuZGxlcw==');

@$core.Deprecated('Use storeServiceGetPageRequestDescriptor instead')
const StoreServiceGetPageRequest$json = {
  '1': 'StoreServiceGetPageRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'store_page_id', '3': 2, '4': 1, '5': 9, '10': 'storePageId'},
    {'1': 'slug', '3': 3, '4': 1, '5': 9, '10': 'slug'},
  ],
};

/// Descriptor for `StoreServiceGetPageRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List storeServiceGetPageRequestDescriptor =
    $convert.base64Decode(
        'ChpTdG9yZVNlcnZpY2VHZXRQYWdlUmVxdWVzdBIhCgx3b3Jrc3BhY2VfaWQYASABKAlSC3dvcm'
        'tzcGFjZUlkEiIKDXN0b3JlX3BhZ2VfaWQYAiABKAlSC3N0b3JlUGFnZUlkEhIKBHNsdWcYAyAB'
        'KAlSBHNsdWc=');

@$core.Deprecated('Use storeServiceGetPageResponseDescriptor instead')
const StoreServiceGetPageResponse$json = {
  '1': 'StoreServiceGetPageResponse',
  '2': [
    {
      '1': 'page',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.commerce.v1.StorePage',
      '10': 'page'
    },
    {
      '1': 'featured_bundles',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.creativanta.commerce.v1.Bundle',
      '10': 'featuredBundles'
    },
  ],
};

/// Descriptor for `StoreServiceGetPageResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List storeServiceGetPageResponseDescriptor =
    $convert.base64Decode(
        'ChtTdG9yZVNlcnZpY2VHZXRQYWdlUmVzcG9uc2USNgoEcGFnZRgBIAEoCzIiLmNyZWF0aXZhbn'
        'RhLmNvbW1lcmNlLnYxLlN0b3JlUGFnZVIEcGFnZRJKChBmZWF0dXJlZF9idW5kbGVzGAIgAygL'
        'Mh8uY3JlYXRpdmFudGEuY29tbWVyY2UudjEuQnVuZGxlUg9mZWF0dXJlZEJ1bmRsZXM=');

@$core.Deprecated('Use storeServiceListRequestDescriptor instead')
const StoreServiceListRequest$json = {
  '1': 'StoreServiceListRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'page_size', '3': 2, '4': 1, '5': 5, '10': 'pageSize'},
    {'1': 'page_token', '3': 3, '4': 1, '5': 9, '10': 'pageToken'},
    {
      '1': 'status_filter',
      '3': 4,
      '4': 1,
      '5': 14,
      '6': '.creativanta.commerce.v1.StorePageStatus',
      '10': 'statusFilter'
    },
  ],
};

/// Descriptor for `StoreServiceListRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List storeServiceListRequestDescriptor = $convert.base64Decode(
    'ChdTdG9yZVNlcnZpY2VMaXN0UmVxdWVzdBIhCgx3b3Jrc3BhY2VfaWQYASABKAlSC3dvcmtzcG'
    'FjZUlkEhsKCXBhZ2Vfc2l6ZRgCIAEoBVIIcGFnZVNpemUSHQoKcGFnZV90b2tlbhgDIAEoCVIJ'
    'cGFnZVRva2VuEk0KDXN0YXR1c19maWx0ZXIYBCABKA4yKC5jcmVhdGl2YW50YS5jb21tZXJjZS'
    '52MS5TdG9yZVBhZ2VTdGF0dXNSDHN0YXR1c0ZpbHRlcg==');

@$core.Deprecated('Use storeServiceListResponseDescriptor instead')
const StoreServiceListResponse$json = {
  '1': 'StoreServiceListResponse',
  '2': [
    {
      '1': 'pages',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.creativanta.commerce.v1.StorePage',
      '10': 'pages'
    },
    {'1': 'next_page_token', '3': 2, '4': 1, '5': 9, '10': 'nextPageToken'},
    {'1': 'total_count', '3': 3, '4': 1, '5': 3, '10': 'totalCount'},
  ],
};

/// Descriptor for `StoreServiceListResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List storeServiceListResponseDescriptor = $convert.base64Decode(
    'ChhTdG9yZVNlcnZpY2VMaXN0UmVzcG9uc2USOAoFcGFnZXMYASADKAsyIi5jcmVhdGl2YW50YS'
    '5jb21tZXJjZS52MS5TdG9yZVBhZ2VSBXBhZ2VzEiYKD25leHRfcGFnZV90b2tlbhgCIAEoCVIN'
    'bmV4dFBhZ2VUb2tlbhIfCgt0b3RhbF9jb3VudBgDIAEoA1IKdG90YWxDb3VudA==');

@$core.Deprecated('Use storeServiceListPagesRequestDescriptor instead')
const StoreServiceListPagesRequest$json = {
  '1': 'StoreServiceListPagesRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'page_size', '3': 2, '4': 1, '5': 5, '10': 'pageSize'},
    {'1': 'page_token', '3': 3, '4': 1, '5': 9, '10': 'pageToken'},
    {
      '1': 'status_filter',
      '3': 4,
      '4': 1,
      '5': 14,
      '6': '.creativanta.commerce.v1.StorePageStatus',
      '10': 'statusFilter'
    },
  ],
};

/// Descriptor for `StoreServiceListPagesRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List storeServiceListPagesRequestDescriptor = $convert.base64Decode(
    'ChxTdG9yZVNlcnZpY2VMaXN0UGFnZXNSZXF1ZXN0EiEKDHdvcmtzcGFjZV9pZBgBIAEoCVILd2'
    '9ya3NwYWNlSWQSGwoJcGFnZV9zaXplGAIgASgFUghwYWdlU2l6ZRIdCgpwYWdlX3Rva2VuGAMg'
    'ASgJUglwYWdlVG9rZW4STQoNc3RhdHVzX2ZpbHRlchgEIAEoDjIoLmNyZWF0aXZhbnRhLmNvbW'
    '1lcmNlLnYxLlN0b3JlUGFnZVN0YXR1c1IMc3RhdHVzRmlsdGVy');

@$core.Deprecated('Use storeServiceListPagesResponseDescriptor instead')
const StoreServiceListPagesResponse$json = {
  '1': 'StoreServiceListPagesResponse',
  '2': [
    {
      '1': 'pages',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.creativanta.commerce.v1.StorePage',
      '10': 'pages'
    },
    {'1': 'next_page_token', '3': 2, '4': 1, '5': 9, '10': 'nextPageToken'},
    {'1': 'total_count', '3': 3, '4': 1, '5': 3, '10': 'totalCount'},
  ],
};

/// Descriptor for `StoreServiceListPagesResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List storeServiceListPagesResponseDescriptor =
    $convert.base64Decode(
        'Ch1TdG9yZVNlcnZpY2VMaXN0UGFnZXNSZXNwb25zZRI4CgVwYWdlcxgBIAMoCzIiLmNyZWF0aX'
        'ZhbnRhLmNvbW1lcmNlLnYxLlN0b3JlUGFnZVIFcGFnZXMSJgoPbmV4dF9wYWdlX3Rva2VuGAIg'
        'ASgJUg1uZXh0UGFnZVRva2VuEh8KC3RvdGFsX2NvdW50GAMgASgDUgp0b3RhbENvdW50');

@$core.Deprecated('Use storeServiceUpdatePageRequestDescriptor instead')
const StoreServiceUpdatePageRequest$json = {
  '1': 'StoreServiceUpdatePageRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'store_page_id', '3': 2, '4': 1, '5': 9, '10': 'storePageId'},
    {'1': 'title', '3': 3, '4': 1, '5': 9, '10': 'title'},
    {'1': 'slug', '3': 4, '4': 1, '5': 9, '10': 'slug'},
    {'1': 'description', '3': 5, '4': 1, '5': 9, '10': 'description'},
    {'1': 'layout_json', '3': 6, '4': 1, '5': 9, '10': 'layoutJson'},
    {
      '1': 'theme_overrides_json',
      '3': 7,
      '4': 1,
      '5': 9,
      '10': 'themeOverridesJson'
    },
    {'1': 'custom_domain', '3': 8, '4': 1, '5': 9, '10': 'customDomain'},
    {'1': 'seo_config_json', '3': 9, '4': 1, '5': 9, '10': 'seoConfigJson'},
    {
      '1': 'widget_config_json',
      '3': 10,
      '4': 1,
      '5': 9,
      '10': 'widgetConfigJson'
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

/// Descriptor for `StoreServiceUpdatePageRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List storeServiceUpdatePageRequestDescriptor = $convert.base64Decode(
    'Ch1TdG9yZVNlcnZpY2VVcGRhdGVQYWdlUmVxdWVzdBIhCgx3b3Jrc3BhY2VfaWQYASABKAlSC3'
    'dvcmtzcGFjZUlkEiIKDXN0b3JlX3BhZ2VfaWQYAiABKAlSC3N0b3JlUGFnZUlkEhQKBXRpdGxl'
    'GAMgASgJUgV0aXRsZRISCgRzbHVnGAQgASgJUgRzbHVnEiAKC2Rlc2NyaXB0aW9uGAUgASgJUg'
    'tkZXNjcmlwdGlvbhIfCgtsYXlvdXRfanNvbhgGIAEoCVIKbGF5b3V0SnNvbhIwChR0aGVtZV9v'
    'dmVycmlkZXNfanNvbhgHIAEoCVISdGhlbWVPdmVycmlkZXNKc29uEiMKDWN1c3RvbV9kb21haW'
    '4YCCABKAlSDGN1c3RvbURvbWFpbhImCg9zZW9fY29uZmlnX2pzb24YCSABKAlSDXNlb0NvbmZp'
    'Z0pzb24SLAoSd2lkZ2V0X2NvbmZpZ19qc29uGAogASgJUhB3aWRnZXRDb25maWdKc29uEk4KD2'
    'NvbW1hbmRfY29udGV4dBgLIAEoCzIlLmNyZWF0aXZhbnRhLmNvbW1vbi52MS5Db21tYW5kQ29u'
    'dGV4dFIOY29tbWFuZENvbnRleHQ=');

@$core.Deprecated('Use storeServiceUpdatePageResponseDescriptor instead')
const StoreServiceUpdatePageResponse$json = {
  '1': 'StoreServiceUpdatePageResponse',
  '2': [
    {
      '1': 'page',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.commerce.v1.StorePage',
      '10': 'page'
    },
  ],
};

/// Descriptor for `StoreServiceUpdatePageResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List storeServiceUpdatePageResponseDescriptor =
    $convert.base64Decode(
        'Ch5TdG9yZVNlcnZpY2VVcGRhdGVQYWdlUmVzcG9uc2USNgoEcGFnZRgBIAEoCzIiLmNyZWF0aX'
        'ZhbnRhLmNvbW1lcmNlLnYxLlN0b3JlUGFnZVIEcGFnZQ==');

@$core.Deprecated('Use storeServicePublishPageRequestDescriptor instead')
const StoreServicePublishPageRequest$json = {
  '1': 'StoreServicePublishPageRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'store_page_id', '3': 2, '4': 1, '5': 9, '10': 'storePageId'},
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

/// Descriptor for `StoreServicePublishPageRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List storeServicePublishPageRequestDescriptor =
    $convert.base64Decode(
        'Ch5TdG9yZVNlcnZpY2VQdWJsaXNoUGFnZVJlcXVlc3QSIQoMd29ya3NwYWNlX2lkGAEgASgJUg'
        't3b3Jrc3BhY2VJZBIiCg1zdG9yZV9wYWdlX2lkGAIgASgJUgtzdG9yZVBhZ2VJZBJOCg9jb21t'
        'YW5kX2NvbnRleHQYAyABKAsyJS5jcmVhdGl2YW50YS5jb21tb24udjEuQ29tbWFuZENvbnRleH'
        'RSDmNvbW1hbmRDb250ZXh0');

@$core.Deprecated('Use storeServicePublishPageResponseDescriptor instead')
const StoreServicePublishPageResponse$json = {
  '1': 'StoreServicePublishPageResponse',
  '2': [
    {
      '1': 'page',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.commerce.v1.StorePage',
      '10': 'page'
    },
    {'1': 'public_url', '3': 2, '4': 1, '5': 9, '10': 'publicUrl'},
  ],
};

/// Descriptor for `StoreServicePublishPageResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List storeServicePublishPageResponseDescriptor =
    $convert.base64Decode(
        'Ch9TdG9yZVNlcnZpY2VQdWJsaXNoUGFnZVJlc3BvbnNlEjYKBHBhZ2UYASABKAsyIi5jcmVhdG'
        'l2YW50YS5jb21tZXJjZS52MS5TdG9yZVBhZ2VSBHBhZ2USHQoKcHVibGljX3VybBgCIAEoCVIJ'
        'cHVibGljVXJs');

@$core.Deprecated('Use storeServicePublishRequestDescriptor instead')
const StoreServicePublishRequest$json = {
  '1': 'StoreServicePublishRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'store_page_id', '3': 2, '4': 1, '5': 9, '10': 'storePageId'},
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

/// Descriptor for `StoreServicePublishRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List storeServicePublishRequestDescriptor = $convert.base64Decode(
    'ChpTdG9yZVNlcnZpY2VQdWJsaXNoUmVxdWVzdBIhCgx3b3Jrc3BhY2VfaWQYASABKAlSC3dvcm'
    'tzcGFjZUlkEiIKDXN0b3JlX3BhZ2VfaWQYAiABKAlSC3N0b3JlUGFnZUlkEk4KD2NvbW1hbmRf'
    'Y29udGV4dBgDIAEoCzIlLmNyZWF0aXZhbnRhLmNvbW1vbi52MS5Db21tYW5kQ29udGV4dFIOY2'
    '9tbWFuZENvbnRleHQ=');

@$core.Deprecated('Use storeServicePublishResponseDescriptor instead')
const StoreServicePublishResponse$json = {
  '1': 'StoreServicePublishResponse',
  '2': [
    {
      '1': 'page',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.commerce.v1.StorePage',
      '10': 'page'
    },
    {'1': 'public_url', '3': 2, '4': 1, '5': 9, '10': 'publicUrl'},
  ],
};

/// Descriptor for `StoreServicePublishResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List storeServicePublishResponseDescriptor =
    $convert.base64Decode(
        'ChtTdG9yZVNlcnZpY2VQdWJsaXNoUmVzcG9uc2USNgoEcGFnZRgBIAEoCzIiLmNyZWF0aXZhbn'
        'RhLmNvbW1lcmNlLnYxLlN0b3JlUGFnZVIEcGFnZRIdCgpwdWJsaWNfdXJsGAIgASgJUglwdWJs'
        'aWNVcmw=');

@$core.Deprecated('Use storeServiceUnpublishRequestDescriptor instead')
const StoreServiceUnpublishRequest$json = {
  '1': 'StoreServiceUnpublishRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'store_page_id', '3': 2, '4': 1, '5': 9, '10': 'storePageId'},
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

/// Descriptor for `StoreServiceUnpublishRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List storeServiceUnpublishRequestDescriptor = $convert.base64Decode(
    'ChxTdG9yZVNlcnZpY2VVbnB1Ymxpc2hSZXF1ZXN0EiEKDHdvcmtzcGFjZV9pZBgBIAEoCVILd2'
    '9ya3NwYWNlSWQSIgoNc3RvcmVfcGFnZV9pZBgCIAEoCVILc3RvcmVQYWdlSWQSTgoPY29tbWFu'
    'ZF9jb250ZXh0GAMgASgLMiUuY3JlYXRpdmFudGEuY29tbW9uLnYxLkNvbW1hbmRDb250ZXh0Ug'
    '5jb21tYW5kQ29udGV4dA==');

@$core.Deprecated('Use storeServiceUnpublishResponseDescriptor instead')
const StoreServiceUnpublishResponse$json = {
  '1': 'StoreServiceUnpublishResponse',
  '2': [
    {
      '1': 'page',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.commerce.v1.StorePage',
      '10': 'page'
    },
  ],
};

/// Descriptor for `StoreServiceUnpublishResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List storeServiceUnpublishResponseDescriptor =
    $convert.base64Decode(
        'Ch1TdG9yZVNlcnZpY2VVbnB1Ymxpc2hSZXNwb25zZRI2CgRwYWdlGAEgASgLMiIuY3JlYXRpdm'
        'FudGEuY29tbWVyY2UudjEuU3RvcmVQYWdlUgRwYWdl');

@$core.Deprecated('Use storeServiceDeletePageRequestDescriptor instead')
const StoreServiceDeletePageRequest$json = {
  '1': 'StoreServiceDeletePageRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'store_page_id', '3': 2, '4': 1, '5': 9, '10': 'storePageId'},
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

/// Descriptor for `StoreServiceDeletePageRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List storeServiceDeletePageRequestDescriptor = $convert.base64Decode(
    'Ch1TdG9yZVNlcnZpY2VEZWxldGVQYWdlUmVxdWVzdBIhCgx3b3Jrc3BhY2VfaWQYASABKAlSC3'
    'dvcmtzcGFjZUlkEiIKDXN0b3JlX3BhZ2VfaWQYAiABKAlSC3N0b3JlUGFnZUlkEk4KD2NvbW1h'
    'bmRfY29udGV4dBgDIAEoCzIlLmNyZWF0aXZhbnRhLmNvbW1vbi52MS5Db21tYW5kQ29udGV4dF'
    'IOY29tbWFuZENvbnRleHQ=');

@$core.Deprecated('Use storeServiceDeletePageResponseDescriptor instead')
const StoreServiceDeletePageResponse$json = {
  '1': 'StoreServiceDeletePageResponse',
  '2': [
    {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
  ],
};

/// Descriptor for `StoreServiceDeletePageResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List storeServiceDeletePageResponseDescriptor =
    $convert.base64Decode(
        'Ch5TdG9yZVNlcnZpY2VEZWxldGVQYWdlUmVzcG9uc2USGAoHc3VjY2VzcxgBIAEoCFIHc3VjY2'
        'Vzcw==');

@$core.Deprecated('Use storeServiceDuplicatePageRequestDescriptor instead')
const StoreServiceDuplicatePageRequest$json = {
  '1': 'StoreServiceDuplicatePageRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'store_page_id', '3': 2, '4': 1, '5': 9, '10': 'storePageId'},
    {'1': 'new_title', '3': 3, '4': 1, '5': 9, '10': 'newTitle'},
    {'1': 'new_slug', '3': 4, '4': 1, '5': 9, '10': 'newSlug'},
    {
      '1': 'command_context',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.CommandContext',
      '10': 'commandContext'
    },
  ],
};

/// Descriptor for `StoreServiceDuplicatePageRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List storeServiceDuplicatePageRequestDescriptor = $convert.base64Decode(
    'CiBTdG9yZVNlcnZpY2VEdXBsaWNhdGVQYWdlUmVxdWVzdBIhCgx3b3Jrc3BhY2VfaWQYASABKA'
    'lSC3dvcmtzcGFjZUlkEiIKDXN0b3JlX3BhZ2VfaWQYAiABKAlSC3N0b3JlUGFnZUlkEhsKCW5l'
    'd190aXRsZRgDIAEoCVIIbmV3VGl0bGUSGQoIbmV3X3NsdWcYBCABKAlSB25ld1NsdWcSTgoPY2'
    '9tbWFuZF9jb250ZXh0GAUgASgLMiUuY3JlYXRpdmFudGEuY29tbW9uLnYxLkNvbW1hbmRDb250'
    'ZXh0Ug5jb21tYW5kQ29udGV4dA==');

@$core.Deprecated('Use storeServiceDuplicatePageResponseDescriptor instead')
const StoreServiceDuplicatePageResponse$json = {
  '1': 'StoreServiceDuplicatePageResponse',
  '2': [
    {
      '1': 'page',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.commerce.v1.StorePage',
      '10': 'page'
    },
  ],
};

/// Descriptor for `StoreServiceDuplicatePageResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List storeServiceDuplicatePageResponseDescriptor =
    $convert.base64Decode(
        'CiFTdG9yZVNlcnZpY2VEdXBsaWNhdGVQYWdlUmVzcG9uc2USNgoEcGFnZRgBIAEoCzIiLmNyZW'
        'F0aXZhbnRhLmNvbW1lcmNlLnYxLlN0b3JlUGFnZVIEcGFnZQ==');

@$core.Deprecated('Use storeServiceGetThemesRequestDescriptor instead')
const StoreServiceGetThemesRequest$json = {
  '1': 'StoreServiceGetThemesRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
  ],
};

/// Descriptor for `StoreServiceGetThemesRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List storeServiceGetThemesRequestDescriptor =
    $convert.base64Decode(
        'ChxTdG9yZVNlcnZpY2VHZXRUaGVtZXNSZXF1ZXN0EiEKDHdvcmtzcGFjZV9pZBgBIAEoCVILd2'
        '9ya3NwYWNlSWQ=');

@$core.Deprecated('Use storeServiceGetThemesResponseDescriptor instead')
const StoreServiceGetThemesResponse$json = {
  '1': 'StoreServiceGetThemesResponse',
  '2': [
    {
      '1': 'themes',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.creativanta.commerce.v1.StoreTheme',
      '10': 'themes'
    },
  ],
};

/// Descriptor for `StoreServiceGetThemesResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List storeServiceGetThemesResponseDescriptor =
    $convert.base64Decode(
        'Ch1TdG9yZVNlcnZpY2VHZXRUaGVtZXNSZXNwb25zZRI7CgZ0aGVtZXMYASADKAsyIy5jcmVhdG'
        'l2YW50YS5jb21tZXJjZS52MS5TdG9yZVRoZW1lUgZ0aGVtZXM=');

@$core.Deprecated('Use storeServiceGetPageStatsRequestDescriptor instead')
const StoreServiceGetPageStatsRequest$json = {
  '1': 'StoreServiceGetPageStatsRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'store_page_id', '3': 2, '4': 1, '5': 9, '10': 'storePageId'},
  ],
};

/// Descriptor for `StoreServiceGetPageStatsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List storeServiceGetPageStatsRequestDescriptor =
    $convert.base64Decode(
        'Ch9TdG9yZVNlcnZpY2VHZXRQYWdlU3RhdHNSZXF1ZXN0EiEKDHdvcmtzcGFjZV9pZBgBIAEoCV'
        'ILd29ya3NwYWNlSWQSIgoNc3RvcmVfcGFnZV9pZBgCIAEoCVILc3RvcmVQYWdlSWQ=');

@$core.Deprecated('Use storeServiceGetPageStatsResponseDescriptor instead')
const StoreServiceGetPageStatsResponse$json = {
  '1': 'StoreServiceGetPageStatsResponse',
  '2': [
    {
      '1': 'stats',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.commerce.v1.PageStats',
      '10': 'stats'
    },
  ],
};

/// Descriptor for `StoreServiceGetPageStatsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List storeServiceGetPageStatsResponseDescriptor =
    $convert.base64Decode(
        'CiBTdG9yZVNlcnZpY2VHZXRQYWdlU3RhdHNSZXNwb25zZRI4CgVzdGF0cxgBIAEoCzIiLmNyZW'
        'F0aXZhbnRhLmNvbW1lcmNlLnYxLlBhZ2VTdGF0c1IFc3RhdHM=');

@$core.Deprecated('Use storeServiceCheckoutRequestDescriptor instead')
const StoreServiceCheckoutRequest$json = {
  '1': 'StoreServiceCheckoutRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {
      '1': 'customer_entity_id',
      '3': 2,
      '4': 1,
      '5': 9,
      '10': 'customerEntityId'
    },
    {'1': 'idempotency_key', '3': 3, '4': 1, '5': 9, '10': 'idempotencyKey'},
    {'1': 'payment_intent_id', '3': 4, '4': 1, '5': 9, '10': 'paymentIntentId'},
    {'1': 'offer_id', '3': 5, '4': 1, '5': 9, '10': 'offerId'},
    {'1': 'bundle_id', '3': 6, '4': 1, '5': 9, '10': 'bundleId'},
    {
      '1': 'membership_plan_id',
      '3': 7,
      '4': 1,
      '5': 9,
      '10': 'membershipPlanId'
    },
    {'1': 'product_ids', '3': 8, '4': 3, '5': 9, '10': 'productIds'},
    {'1': 'order_amount', '3': 9, '4': 1, '5': 9, '10': 'orderAmount'},
    {'1': 'currency', '3': 10, '4': 1, '5': 9, '10': 'currency'},
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

/// Descriptor for `StoreServiceCheckoutRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List storeServiceCheckoutRequestDescriptor = $convert.base64Decode(
    'ChtTdG9yZVNlcnZpY2VDaGVja291dFJlcXVlc3QSIQoMd29ya3NwYWNlX2lkGAEgASgJUgt3b3'
    'Jrc3BhY2VJZBIsChJjdXN0b21lcl9lbnRpdHlfaWQYAiABKAlSEGN1c3RvbWVyRW50aXR5SWQS'
    'JwoPaWRlbXBvdGVuY3lfa2V5GAMgASgJUg5pZGVtcG90ZW5jeUtleRIqChFwYXltZW50X2ludG'
    'VudF9pZBgEIAEoCVIPcGF5bWVudEludGVudElkEhkKCG9mZmVyX2lkGAUgASgJUgdvZmZlcklk'
    'EhsKCWJ1bmRsZV9pZBgGIAEoCVIIYnVuZGxlSWQSLAoSbWVtYmVyc2hpcF9wbGFuX2lkGAcgAS'
    'gJUhBtZW1iZXJzaGlwUGxhbklkEh8KC3Byb2R1Y3RfaWRzGAggAygJUgpwcm9kdWN0SWRzEiEK'
    'DG9yZGVyX2Ftb3VudBgJIAEoCVILb3JkZXJBbW91bnQSGgoIY3VycmVuY3kYCiABKAlSCGN1cn'
    'JlbmN5Ek4KD2NvbW1hbmRfY29udGV4dBgLIAEoCzIlLmNyZWF0aXZhbnRhLmNvbW1vbi52MS5D'
    'b21tYW5kQ29udGV4dFIOY29tbWFuZENvbnRleHQ=');

@$core.Deprecated('Use storeServiceCheckoutResponseDescriptor instead')
const StoreServiceCheckoutResponse$json = {
  '1': 'StoreServiceCheckoutResponse',
  '2': [
    {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
    {'1': 'order_id', '3': 2, '4': 1, '5': 9, '10': 'orderId'},
    {'1': 'status', '3': 3, '4': 1, '5': 9, '10': 'status'},
    {
      '1': 'deliveries',
      '3': 4,
      '4': 3,
      '5': 11,
      '6': '.creativanta.commerce.v1.DigitalDelivery',
      '10': 'deliveries'
    },
    {
      '1': 'subscription',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.creativanta.commerce.v1.MembershipSubscription',
      '10': 'subscription'
    },
    {'1': 'is_replayed', '3': 6, '4': 1, '5': 8, '10': 'isReplayed'},
  ],
};

/// Descriptor for `StoreServiceCheckoutResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List storeServiceCheckoutResponseDescriptor = $convert.base64Decode(
    'ChxTdG9yZVNlcnZpY2VDaGVja291dFJlc3BvbnNlEhgKB3N1Y2Nlc3MYASABKAhSB3N1Y2Nlc3'
    'MSGQoIb3JkZXJfaWQYAiABKAlSB29yZGVySWQSFgoGc3RhdHVzGAMgASgJUgZzdGF0dXMSSAoK'
    'ZGVsaXZlcmllcxgEIAMoCzIoLmNyZWF0aXZhbnRhLmNvbW1lcmNlLnYxLkRpZ2l0YWxEZWxpdm'
    'VyeVIKZGVsaXZlcmllcxJTCgxzdWJzY3JpcHRpb24YBSABKAsyLy5jcmVhdGl2YW50YS5jb21t'
    'ZXJjZS52MS5NZW1iZXJzaGlwU3Vic2NyaXB0aW9uUgxzdWJzY3JpcHRpb24SHwoLaXNfcmVwbG'
    'F5ZWQYBiABKAhSCmlzUmVwbGF5ZWQ=');

@$core
    .Deprecated('Use storeServiceGetBuyerEntitlementsRequestDescriptor instead')
const StoreServiceGetBuyerEntitlementsRequest$json = {
  '1': 'StoreServiceGetBuyerEntitlementsRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {
      '1': 'customer_entity_id',
      '3': 2,
      '4': 1,
      '5': 9,
      '10': 'customerEntityId'
    },
  ],
};

/// Descriptor for `StoreServiceGetBuyerEntitlementsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List storeServiceGetBuyerEntitlementsRequestDescriptor =
    $convert.base64Decode(
        'CidTdG9yZVNlcnZpY2VHZXRCdXllckVudGl0bGVtZW50c1JlcXVlc3QSIQoMd29ya3NwYWNlX2'
        'lkGAEgASgJUgt3b3Jrc3BhY2VJZBIsChJjdXN0b21lcl9lbnRpdHlfaWQYAiABKAlSEGN1c3Rv'
        'bWVyRW50aXR5SWQ=');

@$core.Deprecated(
    'Use storeServiceGetBuyerEntitlementsResponseDescriptor instead')
const StoreServiceGetBuyerEntitlementsResponse$json = {
  '1': 'StoreServiceGetBuyerEntitlementsResponse',
  '2': [
    {
      '1': 'entitlements',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.commerce.v1.BuyerEntitlements',
      '10': 'entitlements'
    },
  ],
};

/// Descriptor for `StoreServiceGetBuyerEntitlementsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List storeServiceGetBuyerEntitlementsResponseDescriptor =
    $convert.base64Decode(
        'CihTdG9yZVNlcnZpY2VHZXRCdXllckVudGl0bGVtZW50c1Jlc3BvbnNlEk4KDGVudGl0bGVtZW'
        '50cxgBIAEoCzIqLmNyZWF0aXZhbnRhLmNvbW1lcmNlLnYxLkJ1eWVyRW50aXRsZW1lbnRzUgxl'
        'bnRpdGxlbWVudHM=');

@$core.Deprecated('Use membershipServiceCreatePlanRequestDescriptor instead')
const MembershipServiceCreatePlanRequest$json = {
  '1': 'MembershipServiceCreatePlanRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'title', '3': 2, '4': 1, '5': 9, '10': 'title'},
    {'1': 'description', '3': 3, '4': 1, '5': 9, '10': 'description'},
    {'1': 'price', '3': 4, '4': 1, '5': 9, '10': 'price'},
    {'1': 'currency', '3': 5, '4': 1, '5': 9, '10': 'currency'},
    {'1': 'billing_interval', '3': 6, '4': 1, '5': 9, '10': 'billingInterval'},
    {'1': 'benefits_json', '3': 7, '4': 1, '5': 9, '10': 'benefitsJson'},
    {
      '1': 'entitlement_config_json',
      '3': 8,
      '4': 1,
      '5': 9,
      '10': 'entitlementConfigJson'
    },
    {
      '1': 'command_context',
      '3': 9,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.CommandContext',
      '10': 'commandContext'
    },
  ],
};

/// Descriptor for `MembershipServiceCreatePlanRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List membershipServiceCreatePlanRequestDescriptor = $convert.base64Decode(
    'CiJNZW1iZXJzaGlwU2VydmljZUNyZWF0ZVBsYW5SZXF1ZXN0EiEKDHdvcmtzcGFjZV9pZBgBIA'
    'EoCVILd29ya3NwYWNlSWQSFAoFdGl0bGUYAiABKAlSBXRpdGxlEiAKC2Rlc2NyaXB0aW9uGAMg'
    'ASgJUgtkZXNjcmlwdGlvbhIUCgVwcmljZRgEIAEoCVIFcHJpY2USGgoIY3VycmVuY3kYBSABKA'
    'lSCGN1cnJlbmN5EikKEGJpbGxpbmdfaW50ZXJ2YWwYBiABKAlSD2JpbGxpbmdJbnRlcnZhbBIj'
    'Cg1iZW5lZml0c19qc29uGAcgASgJUgxiZW5lZml0c0pzb24SNgoXZW50aXRsZW1lbnRfY29uZm'
    'lnX2pzb24YCCABKAlSFWVudGl0bGVtZW50Q29uZmlnSnNvbhJOCg9jb21tYW5kX2NvbnRleHQY'
    'CSABKAsyJS5jcmVhdGl2YW50YS5jb21tb24udjEuQ29tbWFuZENvbnRleHRSDmNvbW1hbmRDb2'
    '50ZXh0');

@$core.Deprecated('Use membershipServiceCreatePlanResponseDescriptor instead')
const MembershipServiceCreatePlanResponse$json = {
  '1': 'MembershipServiceCreatePlanResponse',
  '2': [
    {
      '1': 'plan',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.commerce.v1.MembershipPlan',
      '10': 'plan'
    },
  ],
};

/// Descriptor for `MembershipServiceCreatePlanResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List membershipServiceCreatePlanResponseDescriptor =
    $convert.base64Decode(
        'CiNNZW1iZXJzaGlwU2VydmljZUNyZWF0ZVBsYW5SZXNwb25zZRI7CgRwbGFuGAEgASgLMicuY3'
        'JlYXRpdmFudGEuY29tbWVyY2UudjEuTWVtYmVyc2hpcFBsYW5SBHBsYW4=');

@$core.Deprecated('Use membershipServiceGetPlanRequestDescriptor instead')
const MembershipServiceGetPlanRequest$json = {
  '1': 'MembershipServiceGetPlanRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'plan_id', '3': 2, '4': 1, '5': 9, '10': 'planId'},
  ],
};

/// Descriptor for `MembershipServiceGetPlanRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List membershipServiceGetPlanRequestDescriptor =
    $convert.base64Decode(
        'Ch9NZW1iZXJzaGlwU2VydmljZUdldFBsYW5SZXF1ZXN0EiEKDHdvcmtzcGFjZV9pZBgBIAEoCV'
        'ILd29ya3NwYWNlSWQSFwoHcGxhbl9pZBgCIAEoCVIGcGxhbklk');

@$core.Deprecated('Use membershipServiceGetPlanResponseDescriptor instead')
const MembershipServiceGetPlanResponse$json = {
  '1': 'MembershipServiceGetPlanResponse',
  '2': [
    {
      '1': 'plan',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.commerce.v1.MembershipPlan',
      '10': 'plan'
    },
  ],
};

/// Descriptor for `MembershipServiceGetPlanResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List membershipServiceGetPlanResponseDescriptor =
    $convert.base64Decode(
        'CiBNZW1iZXJzaGlwU2VydmljZUdldFBsYW5SZXNwb25zZRI7CgRwbGFuGAEgASgLMicuY3JlYX'
        'RpdmFudGEuY29tbWVyY2UudjEuTWVtYmVyc2hpcFBsYW5SBHBsYW4=');

@$core.Deprecated('Use membershipServiceListPlansRequestDescriptor instead')
const MembershipServiceListPlansRequest$json = {
  '1': 'MembershipServiceListPlansRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'page_size', '3': 2, '4': 1, '5': 5, '10': 'pageSize'},
    {'1': 'page_token', '3': 3, '4': 1, '5': 9, '10': 'pageToken'},
    {
      '1': 'status_filter',
      '3': 4,
      '4': 1,
      '5': 14,
      '6': '.creativanta.commerce.v1.MembershipPlanStatus',
      '10': 'statusFilter'
    },
  ],
};

/// Descriptor for `MembershipServiceListPlansRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List membershipServiceListPlansRequestDescriptor =
    $convert.base64Decode(
        'CiFNZW1iZXJzaGlwU2VydmljZUxpc3RQbGFuc1JlcXVlc3QSIQoMd29ya3NwYWNlX2lkGAEgAS'
        'gJUgt3b3Jrc3BhY2VJZBIbCglwYWdlX3NpemUYAiABKAVSCHBhZ2VTaXplEh0KCnBhZ2VfdG9r'
        'ZW4YAyABKAlSCXBhZ2VUb2tlbhJSCg1zdGF0dXNfZmlsdGVyGAQgASgOMi0uY3JlYXRpdmFudG'
        'EuY29tbWVyY2UudjEuTWVtYmVyc2hpcFBsYW5TdGF0dXNSDHN0YXR1c0ZpbHRlcg==');

@$core.Deprecated('Use membershipServiceListPlansResponseDescriptor instead')
const MembershipServiceListPlansResponse$json = {
  '1': 'MembershipServiceListPlansResponse',
  '2': [
    {
      '1': 'plans',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.creativanta.commerce.v1.MembershipPlan',
      '10': 'plans'
    },
    {'1': 'next_page_token', '3': 2, '4': 1, '5': 9, '10': 'nextPageToken'},
    {'1': 'total_count', '3': 3, '4': 1, '5': 3, '10': 'totalCount'},
  ],
};

/// Descriptor for `MembershipServiceListPlansResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List membershipServiceListPlansResponseDescriptor =
    $convert.base64Decode(
        'CiJNZW1iZXJzaGlwU2VydmljZUxpc3RQbGFuc1Jlc3BvbnNlEj0KBXBsYW5zGAEgAygLMicuY3'
        'JlYXRpdmFudGEuY29tbWVyY2UudjEuTWVtYmVyc2hpcFBsYW5SBXBsYW5zEiYKD25leHRfcGFn'
        'ZV90b2tlbhgCIAEoCVINbmV4dFBhZ2VUb2tlbhIfCgt0b3RhbF9jb3VudBgDIAEoA1IKdG90YW'
        'xDb3VudA==');

@$core.Deprecated('Use membershipServiceUpdatePlanRequestDescriptor instead')
const MembershipServiceUpdatePlanRequest$json = {
  '1': 'MembershipServiceUpdatePlanRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'plan_id', '3': 2, '4': 1, '5': 9, '10': 'planId'},
    {'1': 'title', '3': 3, '4': 1, '5': 9, '10': 'title'},
    {'1': 'description', '3': 4, '4': 1, '5': 9, '10': 'description'},
    {'1': 'price', '3': 5, '4': 1, '5': 9, '10': 'price'},
    {'1': 'currency', '3': 6, '4': 1, '5': 9, '10': 'currency'},
    {'1': 'billing_interval', '3': 7, '4': 1, '5': 9, '10': 'billingInterval'},
    {'1': 'benefits_json', '3': 8, '4': 1, '5': 9, '10': 'benefitsJson'},
    {
      '1': 'entitlement_config_json',
      '3': 9,
      '4': 1,
      '5': 9,
      '10': 'entitlementConfigJson'
    },
    {
      '1': 'command_context',
      '3': 10,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.CommandContext',
      '10': 'commandContext'
    },
  ],
};

/// Descriptor for `MembershipServiceUpdatePlanRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List membershipServiceUpdatePlanRequestDescriptor = $convert.base64Decode(
    'CiJNZW1iZXJzaGlwU2VydmljZVVwZGF0ZVBsYW5SZXF1ZXN0EiEKDHdvcmtzcGFjZV9pZBgBIA'
    'EoCVILd29ya3NwYWNlSWQSFwoHcGxhbl9pZBgCIAEoCVIGcGxhbklkEhQKBXRpdGxlGAMgASgJ'
    'UgV0aXRsZRIgCgtkZXNjcmlwdGlvbhgEIAEoCVILZGVzY3JpcHRpb24SFAoFcHJpY2UYBSABKA'
    'lSBXByaWNlEhoKCGN1cnJlbmN5GAYgASgJUghjdXJyZW5jeRIpChBiaWxsaW5nX2ludGVydmFs'
    'GAcgASgJUg9iaWxsaW5nSW50ZXJ2YWwSIwoNYmVuZWZpdHNfanNvbhgIIAEoCVIMYmVuZWZpdH'
    'NKc29uEjYKF2VudGl0bGVtZW50X2NvbmZpZ19qc29uGAkgASgJUhVlbnRpdGxlbWVudENvbmZp'
    'Z0pzb24STgoPY29tbWFuZF9jb250ZXh0GAogASgLMiUuY3JlYXRpdmFudGEuY29tbW9uLnYxLk'
    'NvbW1hbmRDb250ZXh0Ug5jb21tYW5kQ29udGV4dA==');

@$core.Deprecated('Use membershipServiceUpdatePlanResponseDescriptor instead')
const MembershipServiceUpdatePlanResponse$json = {
  '1': 'MembershipServiceUpdatePlanResponse',
  '2': [
    {
      '1': 'plan',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.commerce.v1.MembershipPlan',
      '10': 'plan'
    },
  ],
};

/// Descriptor for `MembershipServiceUpdatePlanResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List membershipServiceUpdatePlanResponseDescriptor =
    $convert.base64Decode(
        'CiNNZW1iZXJzaGlwU2VydmljZVVwZGF0ZVBsYW5SZXNwb25zZRI7CgRwbGFuGAEgASgLMicuY3'
        'JlYXRpdmFudGEuY29tbWVyY2UudjEuTWVtYmVyc2hpcFBsYW5SBHBsYW4=');

@$core.Deprecated('Use membershipServiceDuplicatePlanRequestDescriptor instead')
const MembershipServiceDuplicatePlanRequest$json = {
  '1': 'MembershipServiceDuplicatePlanRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'plan_id', '3': 2, '4': 1, '5': 9, '10': 'planId'},
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

/// Descriptor for `MembershipServiceDuplicatePlanRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List membershipServiceDuplicatePlanRequestDescriptor =
    $convert.base64Decode(
        'CiVNZW1iZXJzaGlwU2VydmljZUR1cGxpY2F0ZVBsYW5SZXF1ZXN0EiEKDHdvcmtzcGFjZV9pZB'
        'gBIAEoCVILd29ya3NwYWNlSWQSFwoHcGxhbl9pZBgCIAEoCVIGcGxhbklkEhsKCW5ld190aXRs'
        'ZRgDIAEoCVIIbmV3VGl0bGUSTgoPY29tbWFuZF9jb250ZXh0GAQgASgLMiUuY3JlYXRpdmFudG'
        'EuY29tbW9uLnYxLkNvbW1hbmRDb250ZXh0Ug5jb21tYW5kQ29udGV4dA==');

@$core
    .Deprecated('Use membershipServiceDuplicatePlanResponseDescriptor instead')
const MembershipServiceDuplicatePlanResponse$json = {
  '1': 'MembershipServiceDuplicatePlanResponse',
  '2': [
    {
      '1': 'plan',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.commerce.v1.MembershipPlan',
      '10': 'plan'
    },
  ],
};

/// Descriptor for `MembershipServiceDuplicatePlanResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List membershipServiceDuplicatePlanResponseDescriptor =
    $convert.base64Decode(
        'CiZNZW1iZXJzaGlwU2VydmljZUR1cGxpY2F0ZVBsYW5SZXNwb25zZRI7CgRwbGFuGAEgASgLMi'
        'cuY3JlYXRpdmFudGEuY29tbWVyY2UudjEuTWVtYmVyc2hpcFBsYW5SBHBsYW4=');

@$core.Deprecated('Use membershipServiceDeleteRequestDescriptor instead')
const MembershipServiceDeleteRequest$json = {
  '1': 'MembershipServiceDeleteRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'plan_id', '3': 2, '4': 1, '5': 9, '10': 'planId'},
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

/// Descriptor for `MembershipServiceDeleteRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List membershipServiceDeleteRequestDescriptor =
    $convert.base64Decode(
        'Ch5NZW1iZXJzaGlwU2VydmljZURlbGV0ZVJlcXVlc3QSIQoMd29ya3NwYWNlX2lkGAEgASgJUg'
        't3b3Jrc3BhY2VJZBIXCgdwbGFuX2lkGAIgASgJUgZwbGFuSWQSTgoPY29tbWFuZF9jb250ZXh0'
        'GAMgASgLMiUuY3JlYXRpdmFudGEuY29tbW9uLnYxLkNvbW1hbmRDb250ZXh0Ug5jb21tYW5kQ2'
        '9udGV4dA==');

@$core.Deprecated('Use membershipServiceDeleteResponseDescriptor instead')
const MembershipServiceDeleteResponse$json = {
  '1': 'MembershipServiceDeleteResponse',
  '2': [
    {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
  ],
};

/// Descriptor for `MembershipServiceDeleteResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List membershipServiceDeleteResponseDescriptor =
    $convert.base64Decode(
        'Ch9NZW1iZXJzaGlwU2VydmljZURlbGV0ZVJlc3BvbnNlEhgKB3N1Y2Nlc3MYASABKAhSB3N1Y2'
        'Nlc3M=');

@$core.Deprecated('Use membershipServiceArchiveRequestDescriptor instead')
const MembershipServiceArchiveRequest$json = {
  '1': 'MembershipServiceArchiveRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'plan_id', '3': 2, '4': 1, '5': 9, '10': 'planId'},
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

/// Descriptor for `MembershipServiceArchiveRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List membershipServiceArchiveRequestDescriptor =
    $convert.base64Decode(
        'Ch9NZW1iZXJzaGlwU2VydmljZUFyY2hpdmVSZXF1ZXN0EiEKDHdvcmtzcGFjZV9pZBgBIAEoCV'
        'ILd29ya3NwYWNlSWQSFwoHcGxhbl9pZBgCIAEoCVIGcGxhbklkEk4KD2NvbW1hbmRfY29udGV4'
        'dBgDIAEoCzIlLmNyZWF0aXZhbnRhLmNvbW1vbi52MS5Db21tYW5kQ29udGV4dFIOY29tbWFuZE'
        'NvbnRleHQ=');

@$core.Deprecated('Use membershipServiceArchiveResponseDescriptor instead')
const MembershipServiceArchiveResponse$json = {
  '1': 'MembershipServiceArchiveResponse',
  '2': [
    {
      '1': 'plan',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.commerce.v1.MembershipPlan',
      '10': 'plan'
    },
  ],
};

/// Descriptor for `MembershipServiceArchiveResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List membershipServiceArchiveResponseDescriptor =
    $convert.base64Decode(
        'CiBNZW1iZXJzaGlwU2VydmljZUFyY2hpdmVSZXNwb25zZRI7CgRwbGFuGAEgASgLMicuY3JlYX'
        'RpdmFudGEuY29tbWVyY2UudjEuTWVtYmVyc2hpcFBsYW5SBHBsYW4=');

@$core.Deprecated('Use membershipServicePublishRequestDescriptor instead')
const MembershipServicePublishRequest$json = {
  '1': 'MembershipServicePublishRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'plan_id', '3': 2, '4': 1, '5': 9, '10': 'planId'},
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

/// Descriptor for `MembershipServicePublishRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List membershipServicePublishRequestDescriptor =
    $convert.base64Decode(
        'Ch9NZW1iZXJzaGlwU2VydmljZVB1Ymxpc2hSZXF1ZXN0EiEKDHdvcmtzcGFjZV9pZBgBIAEoCV'
        'ILd29ya3NwYWNlSWQSFwoHcGxhbl9pZBgCIAEoCVIGcGxhbklkEk4KD2NvbW1hbmRfY29udGV4'
        'dBgDIAEoCzIlLmNyZWF0aXZhbnRhLmNvbW1vbi52MS5Db21tYW5kQ29udGV4dFIOY29tbWFuZE'
        'NvbnRleHQ=');

@$core.Deprecated('Use membershipServicePublishResponseDescriptor instead')
const MembershipServicePublishResponse$json = {
  '1': 'MembershipServicePublishResponse',
  '2': [
    {
      '1': 'plan',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.commerce.v1.MembershipPlan',
      '10': 'plan'
    },
  ],
};

/// Descriptor for `MembershipServicePublishResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List membershipServicePublishResponseDescriptor =
    $convert.base64Decode(
        'CiBNZW1iZXJzaGlwU2VydmljZVB1Ymxpc2hSZXNwb25zZRI7CgRwbGFuGAEgASgLMicuY3JlYX'
        'RpdmFudGEuY29tbWVyY2UudjEuTWVtYmVyc2hpcFBsYW5SBHBsYW4=');

@$core.Deprecated('Use membershipServicePauseRequestDescriptor instead')
const MembershipServicePauseRequest$json = {
  '1': 'MembershipServicePauseRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'plan_id', '3': 2, '4': 1, '5': 9, '10': 'planId'},
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

/// Descriptor for `MembershipServicePauseRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List membershipServicePauseRequestDescriptor = $convert.base64Decode(
    'Ch1NZW1iZXJzaGlwU2VydmljZVBhdXNlUmVxdWVzdBIhCgx3b3Jrc3BhY2VfaWQYASABKAlSC3'
    'dvcmtzcGFjZUlkEhcKB3BsYW5faWQYAiABKAlSBnBsYW5JZBJOCg9jb21tYW5kX2NvbnRleHQY'
    'AyABKAsyJS5jcmVhdGl2YW50YS5jb21tb24udjEuQ29tbWFuZENvbnRleHRSDmNvbW1hbmRDb2'
    '50ZXh0');

@$core.Deprecated('Use membershipServicePauseResponseDescriptor instead')
const MembershipServicePauseResponse$json = {
  '1': 'MembershipServicePauseResponse',
  '2': [
    {
      '1': 'plan',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.commerce.v1.MembershipPlan',
      '10': 'plan'
    },
  ],
};

/// Descriptor for `MembershipServicePauseResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List membershipServicePauseResponseDescriptor =
    $convert.base64Decode(
        'Ch5NZW1iZXJzaGlwU2VydmljZVBhdXNlUmVzcG9uc2USOwoEcGxhbhgBIAEoCzInLmNyZWF0aX'
        'ZhbnRhLmNvbW1lcmNlLnYxLk1lbWJlcnNoaXBQbGFuUgRwbGFu');

@$core.Deprecated('Use membershipServiceResumeRequestDescriptor instead')
const MembershipServiceResumeRequest$json = {
  '1': 'MembershipServiceResumeRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'plan_id', '3': 2, '4': 1, '5': 9, '10': 'planId'},
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

/// Descriptor for `MembershipServiceResumeRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List membershipServiceResumeRequestDescriptor =
    $convert.base64Decode(
        'Ch5NZW1iZXJzaGlwU2VydmljZVJlc3VtZVJlcXVlc3QSIQoMd29ya3NwYWNlX2lkGAEgASgJUg'
        't3b3Jrc3BhY2VJZBIXCgdwbGFuX2lkGAIgASgJUgZwbGFuSWQSTgoPY29tbWFuZF9jb250ZXh0'
        'GAMgASgLMiUuY3JlYXRpdmFudGEuY29tbW9uLnYxLkNvbW1hbmRDb250ZXh0Ug5jb21tYW5kQ2'
        '9udGV4dA==');

@$core.Deprecated('Use membershipServiceResumeResponseDescriptor instead')
const MembershipServiceResumeResponse$json = {
  '1': 'MembershipServiceResumeResponse',
  '2': [
    {
      '1': 'plan',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.commerce.v1.MembershipPlan',
      '10': 'plan'
    },
  ],
};

/// Descriptor for `MembershipServiceResumeResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List membershipServiceResumeResponseDescriptor =
    $convert.base64Decode(
        'Ch9NZW1iZXJzaGlwU2VydmljZVJlc3VtZVJlc3BvbnNlEjsKBHBsYW4YASABKAsyJy5jcmVhdG'
        'l2YW50YS5jb21tZXJjZS52MS5NZW1iZXJzaGlwUGxhblIEcGxhbg==');

@$core.Deprecated('Use membershipServiceGetMRRSummaryRequestDescriptor instead')
const MembershipServiceGetMRRSummaryRequest$json = {
  '1': 'MembershipServiceGetMRRSummaryRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
  ],
};

/// Descriptor for `MembershipServiceGetMRRSummaryRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List membershipServiceGetMRRSummaryRequestDescriptor =
    $convert.base64Decode(
        'CiVNZW1iZXJzaGlwU2VydmljZUdldE1SUlN1bW1hcnlSZXF1ZXN0EiEKDHdvcmtzcGFjZV9pZB'
        'gBIAEoCVILd29ya3NwYWNlSWQ=');

@$core
    .Deprecated('Use membershipServiceGetMRRSummaryResponseDescriptor instead')
const MembershipServiceGetMRRSummaryResponse$json = {
  '1': 'MembershipServiceGetMRRSummaryResponse',
  '2': [
    {'1': 'current_mrr', '3': 1, '4': 1, '5': 9, '10': 'currentMrr'},
    {'1': 'currency', '3': 2, '4': 1, '5': 9, '10': 'currency'},
    {
      '1': 'active_subscribers',
      '3': 3,
      '4': 1,
      '5': 5,
      '10': 'activeSubscribers'
    },
    {'1': 'churn_rate', '3': 4, '4': 1, '5': 1, '10': 'churnRate'},
    {'1': 'average_ltv', '3': 5, '4': 1, '5': 9, '10': 'averageLtv'},
    {
      '1': 'trial_conversion_rate',
      '3': 6,
      '4': 1,
      '5': 1,
      '10': 'trialConversionRate'
    },
  ],
};

/// Descriptor for `MembershipServiceGetMRRSummaryResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List membershipServiceGetMRRSummaryResponseDescriptor =
    $convert.base64Decode(
        'CiZNZW1iZXJzaGlwU2VydmljZUdldE1SUlN1bW1hcnlSZXNwb25zZRIfCgtjdXJyZW50X21ych'
        'gBIAEoCVIKY3VycmVudE1ychIaCghjdXJyZW5jeRgCIAEoCVIIY3VycmVuY3kSLQoSYWN0aXZl'
        'X3N1YnNjcmliZXJzGAMgASgFUhFhY3RpdmVTdWJzY3JpYmVycxIdCgpjaHVybl9yYXRlGAQgAS'
        'gBUgljaHVyblJhdGUSHwoLYXZlcmFnZV9sdHYYBSABKAlSCmF2ZXJhZ2VMdHYSMgoVdHJpYWxf'
        'Y29udmVyc2lvbl9yYXRlGAYgASgBUhN0cmlhbENvbnZlcnNpb25SYXRl');

@$core.Deprecated('Use membershipServiceGetMRRTrendRequestDescriptor instead')
const MembershipServiceGetMRRTrendRequest$json = {
  '1': 'MembershipServiceGetMRRTrendRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'months', '3': 2, '4': 1, '5': 5, '10': 'months'},
  ],
};

/// Descriptor for `MembershipServiceGetMRRTrendRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List membershipServiceGetMRRTrendRequestDescriptor =
    $convert.base64Decode(
        'CiNNZW1iZXJzaGlwU2VydmljZUdldE1SUlRyZW5kUmVxdWVzdBIhCgx3b3Jrc3BhY2VfaWQYAS'
        'ABKAlSC3dvcmtzcGFjZUlkEhYKBm1vbnRocxgCIAEoBVIGbW9udGhz');

@$core.Deprecated('Use mRRMonthPointDescriptor instead')
const MRRMonthPoint$json = {
  '1': 'MRRMonthPoint',
  '2': [
    {'1': 'month_label', '3': 1, '4': 1, '5': 9, '10': 'monthLabel'},
    {'1': 'mrr', '3': 2, '4': 1, '5': 9, '10': 'mrr'},
    {'1': 'subscribers', '3': 3, '4': 1, '5': 5, '10': 'subscribers'},
  ],
};

/// Descriptor for `MRRMonthPoint`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List mRRMonthPointDescriptor = $convert.base64Decode(
    'Cg1NUlJNb250aFBvaW50Eh8KC21vbnRoX2xhYmVsGAEgASgJUgptb250aExhYmVsEhAKA21ych'
    'gCIAEoCVIDbXJyEiAKC3N1YnNjcmliZXJzGAMgASgFUgtzdWJzY3JpYmVycw==');

@$core.Deprecated('Use membershipServiceGetMRRTrendResponseDescriptor instead')
const MembershipServiceGetMRRTrendResponse$json = {
  '1': 'MembershipServiceGetMRRTrendResponse',
  '2': [
    {
      '1': 'trend_points',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.creativanta.commerce.v1.MRRMonthPoint',
      '10': 'trendPoints'
    },
  ],
};

/// Descriptor for `MembershipServiceGetMRRTrendResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List membershipServiceGetMRRTrendResponseDescriptor =
    $convert.base64Decode(
        'CiRNZW1iZXJzaGlwU2VydmljZUdldE1SUlRyZW5kUmVzcG9uc2USSQoMdHJlbmRfcG9pbnRzGA'
        'EgAygLMiYuY3JlYXRpdmFudGEuY29tbWVyY2UudjEuTVJSTW9udGhQb2ludFILdHJlbmRQb2lu'
        'dHM=');

@$core.Deprecated('Use bundleServiceCreateBundleRequestDescriptor instead')
const BundleServiceCreateBundleRequest$json = {
  '1': 'BundleServiceCreateBundleRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'title', '3': 2, '4': 1, '5': 9, '10': 'title'},
    {'1': 'offer_id', '3': 3, '4': 1, '5': 9, '10': 'offerId'},
    {'1': 'bundle_price', '3': 4, '4': 1, '5': 9, '10': 'bundlePrice'},
    {'1': 'discount_pct', '3': 5, '4': 1, '5': 1, '10': 'discountPct'},
    {
      '1': 'items',
      '3': 6,
      '4': 3,
      '5': 11,
      '6': '.creativanta.commerce.v1.BundleItem',
      '10': 'items'
    },
    {
      '1': 'command_context',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.CommandContext',
      '10': 'commandContext'
    },
  ],
};

/// Descriptor for `BundleServiceCreateBundleRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List bundleServiceCreateBundleRequestDescriptor = $convert.base64Decode(
    'CiBCdW5kbGVTZXJ2aWNlQ3JlYXRlQnVuZGxlUmVxdWVzdBIhCgx3b3Jrc3BhY2VfaWQYASABKA'
    'lSC3dvcmtzcGFjZUlkEhQKBXRpdGxlGAIgASgJUgV0aXRsZRIZCghvZmZlcl9pZBgDIAEoCVIH'
    'b2ZmZXJJZBIhCgxidW5kbGVfcHJpY2UYBCABKAlSC2J1bmRsZVByaWNlEiEKDGRpc2NvdW50X3'
    'BjdBgFIAEoAVILZGlzY291bnRQY3QSOQoFaXRlbXMYBiADKAsyIy5jcmVhdGl2YW50YS5jb21t'
    'ZXJjZS52MS5CdW5kbGVJdGVtUgVpdGVtcxJOCg9jb21tYW5kX2NvbnRleHQYByABKAsyJS5jcm'
    'VhdGl2YW50YS5jb21tb24udjEuQ29tbWFuZENvbnRleHRSDmNvbW1hbmRDb250ZXh0');

@$core.Deprecated('Use bundleServiceCreateBundleResponseDescriptor instead')
const BundleServiceCreateBundleResponse$json = {
  '1': 'BundleServiceCreateBundleResponse',
  '2': [
    {
      '1': 'bundle',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.commerce.v1.Bundle',
      '10': 'bundle'
    },
  ],
};

/// Descriptor for `BundleServiceCreateBundleResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List bundleServiceCreateBundleResponseDescriptor =
    $convert.base64Decode(
        'CiFCdW5kbGVTZXJ2aWNlQ3JlYXRlQnVuZGxlUmVzcG9uc2USNwoGYnVuZGxlGAEgASgLMh8uY3'
        'JlYXRpdmFudGEuY29tbWVyY2UudjEuQnVuZGxlUgZidW5kbGU=');

@$core.Deprecated('Use bundleServiceGetBundleRequestDescriptor instead')
const BundleServiceGetBundleRequest$json = {
  '1': 'BundleServiceGetBundleRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'bundle_id', '3': 2, '4': 1, '5': 9, '10': 'bundleId'},
  ],
};

/// Descriptor for `BundleServiceGetBundleRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List bundleServiceGetBundleRequestDescriptor =
    $convert.base64Decode(
        'Ch1CdW5kbGVTZXJ2aWNlR2V0QnVuZGxlUmVxdWVzdBIhCgx3b3Jrc3BhY2VfaWQYASABKAlSC3'
        'dvcmtzcGFjZUlkEhsKCWJ1bmRsZV9pZBgCIAEoCVIIYnVuZGxlSWQ=');

@$core.Deprecated('Use bundleServiceGetBundleResponseDescriptor instead')
const BundleServiceGetBundleResponse$json = {
  '1': 'BundleServiceGetBundleResponse',
  '2': [
    {
      '1': 'bundle',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.commerce.v1.Bundle',
      '10': 'bundle'
    },
  ],
};

/// Descriptor for `BundleServiceGetBundleResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List bundleServiceGetBundleResponseDescriptor =
    $convert.base64Decode(
        'Ch5CdW5kbGVTZXJ2aWNlR2V0QnVuZGxlUmVzcG9uc2USNwoGYnVuZGxlGAEgASgLMh8uY3JlYX'
        'RpdmFudGEuY29tbWVyY2UudjEuQnVuZGxlUgZidW5kbGU=');

@$core.Deprecated('Use bundleServiceListBundlesRequestDescriptor instead')
const BundleServiceListBundlesRequest$json = {
  '1': 'BundleServiceListBundlesRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
  ],
};

/// Descriptor for `BundleServiceListBundlesRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List bundleServiceListBundlesRequestDescriptor =
    $convert.base64Decode(
        'Ch9CdW5kbGVTZXJ2aWNlTGlzdEJ1bmRsZXNSZXF1ZXN0EiEKDHdvcmtzcGFjZV9pZBgBIAEoCV'
        'ILd29ya3NwYWNlSWQ=');

@$core.Deprecated('Use bundleServiceListBundlesResponseDescriptor instead')
const BundleServiceListBundlesResponse$json = {
  '1': 'BundleServiceListBundlesResponse',
  '2': [
    {
      '1': 'bundles',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.creativanta.commerce.v1.Bundle',
      '10': 'bundles'
    },
  ],
};

/// Descriptor for `BundleServiceListBundlesResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List bundleServiceListBundlesResponseDescriptor =
    $convert.base64Decode(
        'CiBCdW5kbGVTZXJ2aWNlTGlzdEJ1bmRsZXNSZXNwb25zZRI5CgdidW5kbGVzGAEgAygLMh8uY3'
        'JlYXRpdmFudGEuY29tbWVyY2UudjEuQnVuZGxlUgdidW5kbGVz');

@$core.Deprecated('Use bundleServiceCheckBundleStockRequestDescriptor instead')
const BundleServiceCheckBundleStockRequest$json = {
  '1': 'BundleServiceCheckBundleStockRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'bundle_id', '3': 2, '4': 1, '5': 9, '10': 'bundleId'},
    {
      '1': 'requested_quantity',
      '3': 3,
      '4': 1,
      '5': 5,
      '10': 'requestedQuantity'
    },
  ],
};

/// Descriptor for `BundleServiceCheckBundleStockRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List bundleServiceCheckBundleStockRequestDescriptor =
    $convert.base64Decode(
        'CiRCdW5kbGVTZXJ2aWNlQ2hlY2tCdW5kbGVTdG9ja1JlcXVlc3QSIQoMd29ya3NwYWNlX2lkGA'
        'EgASgJUgt3b3Jrc3BhY2VJZBIbCglidW5kbGVfaWQYAiABKAlSCGJ1bmRsZUlkEi0KEnJlcXVl'
        'c3RlZF9xdWFudGl0eRgDIAEoBVIRcmVxdWVzdGVkUXVhbnRpdHk=');

@$core.Deprecated('Use bundleServiceCheckBundleStockResponseDescriptor instead')
const BundleServiceCheckBundleStockResponse$json = {
  '1': 'BundleServiceCheckBundleStockResponse',
  '2': [
    {'1': 'bundle_id', '3': 1, '4': 1, '5': 9, '10': 'bundleId'},
    {'1': 'is_available', '3': 2, '4': 1, '5': 8, '10': 'isAvailable'},
    {'1': 'reason', '3': 3, '4': 1, '5': 9, '10': 'reason'},
    {
      '1': 'stock_breakdown',
      '3': 4,
      '4': 3,
      '5': 11,
      '6': '.creativanta.commerce.v1.BundleItem',
      '10': 'stockBreakdown'
    },
  ],
};

/// Descriptor for `BundleServiceCheckBundleStockResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List bundleServiceCheckBundleStockResponseDescriptor =
    $convert.base64Decode(
        'CiVCdW5kbGVTZXJ2aWNlQ2hlY2tCdW5kbGVTdG9ja1Jlc3BvbnNlEhsKCWJ1bmRsZV9pZBgBIA'
        'EoCVIIYnVuZGxlSWQSIQoMaXNfYXZhaWxhYmxlGAIgASgIUgtpc0F2YWlsYWJsZRIWCgZyZWFz'
        'b24YAyABKAlSBnJlYXNvbhJMCg9zdG9ja19icmVha2Rvd24YBCADKAsyIy5jcmVhdGl2YW50YS'
        '5jb21tZXJjZS52MS5CdW5kbGVJdGVtUg5zdG9ja0JyZWFrZG93bg==');

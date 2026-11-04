// This is a generated file - do not edit.
//
// Generated from creativanta/commerce/v1/creator_pro.proto.

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

@$core.Deprecated('Use brandDealStatusDescriptor instead')
const BrandDealStatus$json = {
  '1': 'BrandDealStatus',
  '2': [
    {'1': 'BRAND_DEAL_STATUS_UNSPECIFIED', '2': 0},
    {'1': 'BRAND_DEAL_STATUS_NEGOTIATING', '2': 1},
    {'1': 'BRAND_DEAL_STATUS_AGREED', '2': 2},
    {'1': 'BRAND_DEAL_STATUS_IN_PROGRESS', '2': 3},
    {'1': 'BRAND_DEAL_STATUS_DELIVERED', '2': 4},
    {'1': 'BRAND_DEAL_STATUS_PAID', '2': 5},
    {'1': 'BRAND_DEAL_STATUS_COMPLETED', '2': 6},
    {'1': 'BRAND_DEAL_STATUS_CANCELLED', '2': 7},
  ],
};

/// Descriptor for `BrandDealStatus`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List brandDealStatusDescriptor = $convert.base64Decode(
    'Cg9CcmFuZERlYWxTdGF0dXMSIQodQlJBTkRfREVBTF9TVEFUVVNfVU5TUEVDSUZJRUQQABIhCh'
    '1CUkFORF9ERUFMX1NUQVRVU19ORUdPVElBVElORxABEhwKGEJSQU5EX0RFQUxfU1RBVFVTX0FH'
    'UkVFRBACEiEKHUJSQU5EX0RFQUxfU1RBVFVTX0lOX1BST0dSRVNTEAMSHwobQlJBTkRfREVBTF'
    '9TVEFUVVNfREVMSVZFUkVEEAQSGgoWQlJBTkRfREVBTF9TVEFUVVNfUEFJRBAFEh8KG0JSQU5E'
    'X0RFQUxfU1RBVFVTX0NPTVBMRVRFRBAGEh8KG0JSQU5EX0RFQUxfU1RBVFVTX0NBTkNFTExFRB'
    'AH');

@$core.Deprecated('Use brandDealTypeDescriptor instead')
const BrandDealType$json = {
  '1': 'BrandDealType',
  '2': [
    {'1': 'BRAND_DEAL_TYPE_UNSPECIFIED', '2': 0},
    {'1': 'BRAND_DEAL_TYPE_SPONSORED_POST', '2': 1},
    {'1': 'BRAND_DEAL_TYPE_PRODUCT_REVIEW', '2': 2},
    {'1': 'BRAND_DEAL_TYPE_AMBASSADOR', '2': 3},
    {'1': 'BRAND_DEAL_TYPE_AFFILIATE', '2': 4},
    {'1': 'BRAND_DEAL_TYPE_CUSTOM', '2': 5},
  ],
};

/// Descriptor for `BrandDealType`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List brandDealTypeDescriptor = $convert.base64Decode(
    'Cg1CcmFuZERlYWxUeXBlEh8KG0JSQU5EX0RFQUxfVFlQRV9VTlNQRUNJRklFRBAAEiIKHkJSQU'
    '5EX0RFQUxfVFlQRV9TUE9OU09SRURfUE9TVBABEiIKHkJSQU5EX0RFQUxfVFlQRV9QUk9EVUNU'
    'X1JFVklFVxACEh4KGkJSQU5EX0RFQUxfVFlQRV9BTUJBU1NBRE9SEAMSHQoZQlJBTkRfREVBTF'
    '9UWVBFX0FGRklMSUFURRAEEhoKFkJSQU5EX0RFQUxfVFlQRV9DVVNUT00QBQ==');

@$core.Deprecated('Use linkTypeDescriptor instead')
const LinkType$json = {
  '1': 'LinkType',
  '2': [
    {'1': 'LINK_TYPE_UNSPECIFIED', '2': 0},
    {'1': 'LINK_TYPE_URL', '2': 1},
    {'1': 'LINK_TYPE_PRODUCT', '2': 2},
    {'1': 'LINK_TYPE_VIDEO', '2': 3},
    {'1': 'LINK_TYPE_SOCIAL', '2': 4},
    {'1': 'LINK_TYPE_DOWNLOAD', '2': 5},
    {'1': 'LINK_TYPE_EMAIL', '2': 6},
  ],
};

/// Descriptor for `LinkType`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List linkTypeDescriptor = $convert.base64Decode(
    'CghMaW5rVHlwZRIZChVMSU5LX1RZUEVfVU5TUEVDSUZJRUQQABIRCg1MSU5LX1RZUEVfVVJMEA'
    'ESFQoRTElOS19UWVBFX1BST0RVQ1QQAhITCg9MSU5LX1RZUEVfVklERU8QAxIUChBMSU5LX1RZ'
    'UEVfU09DSUFMEAQSFgoSTElOS19UWVBFX0RPV05MT0FEEAUSEwoPTElOS19UWVBFX0VNQUlMEA'
    'Y=');

@$core.Deprecated('Use linkInBioPageStatusDescriptor instead')
const LinkInBioPageStatus$json = {
  '1': 'LinkInBioPageStatus',
  '2': [
    {'1': 'LINK_IN_BIO_PAGE_STATUS_UNSPECIFIED', '2': 0},
    {'1': 'LINK_IN_BIO_PAGE_STATUS_ACTIVE', '2': 1},
    {'1': 'LINK_IN_BIO_PAGE_STATUS_SUSPENDED', '2': 2},
    {'1': 'LINK_IN_BIO_PAGE_STATUS_ARCHIVED', '2': 3},
  ],
};

/// Descriptor for `LinkInBioPageStatus`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List linkInBioPageStatusDescriptor = $convert.base64Decode(
    'ChNMaW5rSW5CaW9QYWdlU3RhdHVzEicKI0xJTktfSU5fQklPX1BBR0VfU1RBVFVTX1VOU1BFQ0'
    'lGSUVEEAASIgoeTElOS19JTl9CSU9fUEFHRV9TVEFUVVNfQUNUSVZFEAESJQohTElOS19JTl9C'
    'SU9fUEFHRV9TVEFUVVNfU1VTUEVOREVEEAISJAogTElOS19JTl9CSU9fUEFHRV9TVEFUVVNfQV'
    'JDSElWRUQQAw==');

@$core.Deprecated('Use linkSecurityScanStatusDescriptor instead')
const LinkSecurityScanStatus$json = {
  '1': 'LinkSecurityScanStatus',
  '2': [
    {'1': 'LINK_SECURITY_SCAN_STATUS_UNSPECIFIED', '2': 0},
    {'1': 'LINK_SECURITY_SCAN_STATUS_SAFE', '2': 1},
    {'1': 'LINK_SECURITY_SCAN_STATUS_SUSPICIOUS', '2': 2},
    {'1': 'LINK_SECURITY_SCAN_STATUS_PHISHING', '2': 3},
    {'1': 'LINK_SECURITY_SCAN_STATUS_MALWARE', '2': 4},
    {'1': 'LINK_SECURITY_SCAN_STATUS_BLOCKED', '2': 5},
  ],
};

/// Descriptor for `LinkSecurityScanStatus`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List linkSecurityScanStatusDescriptor = $convert.base64Decode(
    'ChZMaW5rU2VjdXJpdHlTY2FuU3RhdHVzEikKJUxJTktfU0VDVVJJVFlfU0NBTl9TVEFUVVNfVU'
    '5TUEVDSUZJRUQQABIiCh5MSU5LX1NFQ1VSSVRZX1NDQU5fU1RBVFVTX1NBRkUQARIoCiRMSU5L'
    'X1NFQ1VSSVRZX1NDQU5fU1RBVFVTX1NVU1BJQ0lPVVMQAhImCiJMSU5LX1NFQ1VSSVRZX1NDQU'
    '5fU1RBVFVTX1BISVNISU5HEAMSJQohTElOS19TRUNVUklUWV9TQ0FOX1NUQVRVU19NQUxXQVJF'
    'EAQSJQohTElOS19TRUNVUklUWV9TQ0FOX1NUQVRVU19CTE9DS0VEEAU=');

@$core.Deprecated('Use mediaKitDirectoryStatusDescriptor instead')
const MediaKitDirectoryStatus$json = {
  '1': 'MediaKitDirectoryStatus',
  '2': [
    {'1': 'MEDIA_KIT_DIRECTORY_STATUS_UNSPECIFIED', '2': 0},
    {'1': 'MEDIA_KIT_DIRECTORY_STATUS_HIDDEN', '2': 1},
    {'1': 'MEDIA_KIT_DIRECTORY_STATUS_PENDING_REVIEW', '2': 2},
    {'1': 'MEDIA_KIT_DIRECTORY_STATUS_PUBLISHED', '2': 3},
  ],
};

/// Descriptor for `MediaKitDirectoryStatus`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List mediaKitDirectoryStatusDescriptor = $convert.base64Decode(
    'ChdNZWRpYUtpdERpcmVjdG9yeVN0YXR1cxIqCiZNRURJQV9LSVRfRElSRUNUT1JZX1NUQVRVU1'
    '9VTlNQRUNJRklFRBAAEiUKIU1FRElBX0tJVF9ESVJFQ1RPUllfU1RBVFVTX0hJRERFThABEi0K'
    'KU1FRElBX0tJVF9ESVJFQ1RPUllfU1RBVFVTX1BFTkRJTkdfUkVWSUVXEAISKAokTUVESUFfS0'
    'lUX0RJUkVDVE9SWV9TVEFUVVNfUFVCTElTSEVEEAM=');

@$core.Deprecated('Use taxReportPeriodDescriptor instead')
const TaxReportPeriod$json = {
  '1': 'TaxReportPeriod',
  '2': [
    {'1': 'TAX_REPORT_PERIOD_UNSPECIFIED', '2': 0},
    {'1': 'TAX_REPORT_PERIOD_MONTHLY', '2': 1},
    {'1': 'TAX_REPORT_PERIOD_QUARTERLY', '2': 2},
    {'1': 'TAX_REPORT_PERIOD_YEARLY', '2': 3},
  ],
};

/// Descriptor for `TaxReportPeriod`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List taxReportPeriodDescriptor = $convert.base64Decode(
    'Cg9UYXhSZXBvcnRQZXJpb2QSIQodVEFYX1JFUE9SVF9QRVJJT0RfVU5TUEVDSUZJRUQQABIdCh'
    'lUQVhfUkVQT1JUX1BFUklPRF9NT05USExZEAESHwobVEFYX1JFUE9SVF9QRVJJT0RfUVVBUlRF'
    'UkxZEAISHAoYVEFYX1JFUE9SVF9QRVJJT0RfWUVBUkxZEAM=');

@$core.Deprecated('Use taxReportFormatDescriptor instead')
const TaxReportFormat$json = {
  '1': 'TaxReportFormat',
  '2': [
    {'1': 'TAX_REPORT_FORMAT_UNSPECIFIED', '2': 0},
    {'1': 'TAX_REPORT_FORMAT_PDF', '2': 1},
    {'1': 'TAX_REPORT_FORMAT_XLSX', '2': 2},
    {'1': 'TAX_REPORT_FORMAT_CSV', '2': 3},
  ],
};

/// Descriptor for `TaxReportFormat`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List taxReportFormatDescriptor = $convert.base64Decode(
    'Cg9UYXhSZXBvcnRGb3JtYXQSIQodVEFYX1JFUE9SVF9GT1JNQVRfVU5TUEVDSUZJRUQQABIZCh'
    'VUQVhfUkVQT1JUX0ZPUk1BVF9QREYQARIaChZUQVhfUkVQT1JUX0ZPUk1BVF9YTFNYEAISGQoV'
    'VEFYX1JFUE9SVF9GT1JNQVRfQ1NWEAM=');

@$core.Deprecated('Use linkInBioPageDescriptor instead')
const LinkInBioPage$json = {
  '1': 'LinkInBioPage',
  '2': [
    {'1': 'page_id', '3': 1, '4': 1, '5': 9, '10': 'pageId'},
    {'1': 'workspace_id', '3': 2, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'slug', '3': 3, '4': 1, '5': 9, '10': 'slug'},
    {'1': 'title', '3': 4, '4': 1, '5': 9, '10': 'title'},
    {'1': 'bio', '3': 5, '4': 1, '5': 9, '10': 'bio'},
    {'1': 'avatar_url', '3': 6, '4': 1, '5': 9, '10': 'avatarUrl'},
    {'1': 'theme', '3': 7, '4': 1, '5': 9, '10': 'theme'},
    {'1': 'custom_css', '3': 8, '4': 1, '5': 9, '10': 'customCss'},
    {'1': 'custom_domain', '3': 9, '4': 1, '5': 9, '10': 'customDomain'},
    {
      '1': 'custom_domain_verified',
      '3': 10,
      '4': 1,
      '5': 8,
      '10': 'customDomainVerified'
    },
    {
      '1': 'analytics_enabled',
      '3': 11,
      '4': 1,
      '5': 8,
      '10': 'analyticsEnabled'
    },
    {'1': 'total_views', '3': 12, '4': 1, '5': 5, '10': 'totalViews'},
    {
      '1': 'status',
      '3': 13,
      '4': 1,
      '5': 14,
      '6': '.creativanta.commerce.v1.LinkInBioPageStatus',
      '10': 'status'
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
    {
      '1': 'items',
      '3': 16,
      '4': 3,
      '5': 11,
      '6': '.creativanta.commerce.v1.LinkItem',
      '10': 'items'
    },
  ],
};

/// Descriptor for `LinkInBioPage`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List linkInBioPageDescriptor = $convert.base64Decode(
    'Cg1MaW5rSW5CaW9QYWdlEhcKB3BhZ2VfaWQYASABKAlSBnBhZ2VJZBIhCgx3b3Jrc3BhY2VfaW'
    'QYAiABKAlSC3dvcmtzcGFjZUlkEhIKBHNsdWcYAyABKAlSBHNsdWcSFAoFdGl0bGUYBCABKAlS'
    'BXRpdGxlEhAKA2JpbxgFIAEoCVIDYmlvEh0KCmF2YXRhcl91cmwYBiABKAlSCWF2YXRhclVybB'
    'IUCgV0aGVtZRgHIAEoCVIFdGhlbWUSHQoKY3VzdG9tX2NzcxgIIAEoCVIJY3VzdG9tQ3NzEiMK'
    'DWN1c3RvbV9kb21haW4YCSABKAlSDGN1c3RvbURvbWFpbhI0ChZjdXN0b21fZG9tYWluX3Zlcm'
    'lmaWVkGAogASgIUhRjdXN0b21Eb21haW5WZXJpZmllZBIrChFhbmFseXRpY3NfZW5hYmxlZBgL'
    'IAEoCFIQYW5hbHl0aWNzRW5hYmxlZBIfCgt0b3RhbF92aWV3cxgMIAEoBVIKdG90YWxWaWV3cx'
    'JECgZzdGF0dXMYDSABKA4yLC5jcmVhdGl2YW50YS5jb21tZXJjZS52MS5MaW5rSW5CaW9QYWdl'
    'U3RhdHVzUgZzdGF0dXMSOQoKY3JlYXRlZF9hdBgOIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW'
    '1lc3RhbXBSCWNyZWF0ZWRBdBI5Cgp1cGRhdGVkX2F0GA8gASgLMhouZ29vZ2xlLnByb3RvYnVm'
    'LlRpbWVzdGFtcFIJdXBkYXRlZEF0EjcKBWl0ZW1zGBAgAygLMiEuY3JlYXRpdmFudGEuY29tbW'
    'VyY2UudjEuTGlua0l0ZW1SBWl0ZW1z');

@$core.Deprecated('Use linkItemDescriptor instead')
const LinkItem$json = {
  '1': 'LinkItem',
  '2': [
    {'1': 'link_item_id', '3': 1, '4': 1, '5': 9, '10': 'linkItemId'},
    {'1': 'page_id', '3': 2, '4': 1, '5': 9, '10': 'pageId'},
    {'1': 'workspace_id', '3': 3, '4': 1, '5': 9, '10': 'workspaceId'},
    {
      '1': 'link_type',
      '3': 4,
      '4': 1,
      '5': 14,
      '6': '.creativanta.commerce.v1.LinkType',
      '10': 'linkType'
    },
    {'1': 'label', '3': 5, '4': 1, '5': 9, '10': 'label'},
    {'1': 'url', '3': 6, '4': 1, '5': 9, '10': 'url'},
    {'1': 'icon', '3': 7, '4': 1, '5': 9, '10': 'icon'},
    {'1': 'thumbnail_url', '3': 8, '4': 1, '5': 9, '10': 'thumbnailUrl'},
    {'1': 'position', '3': 9, '4': 1, '5': 5, '10': 'position'},
    {'1': 'clicks', '3': 10, '4': 1, '5': 5, '10': 'clicks'},
    {'1': 'is_active', '3': 11, '4': 1, '5': 8, '10': 'isActive'},
    {
      '1': 'scan_status',
      '3': 12,
      '4': 1,
      '5': 14,
      '6': '.creativanta.commerce.v1.LinkSecurityScanStatus',
      '10': 'scanStatus'
    },
    {
      '1': 'phishing_detected',
      '3': 13,
      '4': 1,
      '5': 8,
      '10': 'phishingDetected'
    },
    {
      '1': 'scan_threat_details',
      '3': 14,
      '4': 1,
      '5': 9,
      '10': 'scanThreatDetails'
    },
    {
      '1': 'created_at',
      '3': 15,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'createdAt'
    },
  ],
};

/// Descriptor for `LinkItem`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List linkItemDescriptor = $convert.base64Decode(
    'CghMaW5rSXRlbRIgCgxsaW5rX2l0ZW1faWQYASABKAlSCmxpbmtJdGVtSWQSFwoHcGFnZV9pZB'
    'gCIAEoCVIGcGFnZUlkEiEKDHdvcmtzcGFjZV9pZBgDIAEoCVILd29ya3NwYWNlSWQSPgoJbGlu'
    'a190eXBlGAQgASgOMiEuY3JlYXRpdmFudGEuY29tbWVyY2UudjEuTGlua1R5cGVSCGxpbmtUeX'
    'BlEhQKBWxhYmVsGAUgASgJUgVsYWJlbBIQCgN1cmwYBiABKAlSA3VybBISCgRpY29uGAcgASgJ'
    'UgRpY29uEiMKDXRodW1ibmFpbF91cmwYCCABKAlSDHRodW1ibmFpbFVybBIaCghwb3NpdGlvbh'
    'gJIAEoBVIIcG9zaXRpb24SFgoGY2xpY2tzGAogASgFUgZjbGlja3MSGwoJaXNfYWN0aXZlGAsg'
    'ASgIUghpc0FjdGl2ZRJQCgtzY2FuX3N0YXR1cxgMIAEoDjIvLmNyZWF0aXZhbnRhLmNvbW1lcm'
    'NlLnYxLkxpbmtTZWN1cml0eVNjYW5TdGF0dXNSCnNjYW5TdGF0dXMSKwoRcGhpc2hpbmdfZGV0'
    'ZWN0ZWQYDSABKAhSEHBoaXNoaW5nRGV0ZWN0ZWQSLgoTc2Nhbl90aHJlYXRfZGV0YWlscxgOIA'
    'EoCVIRc2NhblRocmVhdERldGFpbHMSOQoKY3JlYXRlZF9hdBgPIAEoCzIaLmdvb2dsZS5wcm90'
    'b2J1Zi5UaW1lc3RhbXBSCWNyZWF0ZWRBdA==');

@$core.Deprecated('Use linkInBioAnalyticsDescriptor instead')
const LinkInBioAnalytics$json = {
  '1': 'LinkInBioAnalytics',
  '2': [
    {'1': 'page_id', '3': 1, '4': 1, '5': 9, '10': 'pageId'},
    {'1': 'workspace_id', '3': 2, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'total_views', '3': 3, '4': 1, '5': 5, '10': 'totalViews'},
    {'1': 'total_clicks', '3': 4, '4': 1, '5': 5, '10': 'totalClicks'},
    {
      '1': 'click_through_rate',
      '3': 5,
      '4': 1,
      '5': 1,
      '10': 'clickThroughRate'
    },
    {
      '1': 'item_metrics',
      '3': 6,
      '4': 3,
      '5': 11,
      '6': '.creativanta.commerce.v1.LinkItemMetric',
      '10': 'itemMetrics'
    },
  ],
};

/// Descriptor for `LinkInBioAnalytics`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List linkInBioAnalyticsDescriptor = $convert.base64Decode(
    'ChJMaW5rSW5CaW9BbmFseXRpY3MSFwoHcGFnZV9pZBgBIAEoCVIGcGFnZUlkEiEKDHdvcmtzcG'
    'FjZV9pZBgCIAEoCVILd29ya3NwYWNlSWQSHwoLdG90YWxfdmlld3MYAyABKAVSCnRvdGFsVmll'
    'd3MSIQoMdG90YWxfY2xpY2tzGAQgASgFUgt0b3RhbENsaWNrcxIsChJjbGlja190aHJvdWdoX3'
    'JhdGUYBSABKAFSEGNsaWNrVGhyb3VnaFJhdGUSSgoMaXRlbV9tZXRyaWNzGAYgAygLMicuY3Jl'
    'YXRpdmFudGEuY29tbWVyY2UudjEuTGlua0l0ZW1NZXRyaWNSC2l0ZW1NZXRyaWNz');

@$core.Deprecated('Use linkItemMetricDescriptor instead')
const LinkItemMetric$json = {
  '1': 'LinkItemMetric',
  '2': [
    {'1': 'link_item_id', '3': 1, '4': 1, '5': 9, '10': 'linkItemId'},
    {'1': 'label', '3': 2, '4': 1, '5': 9, '10': 'label'},
    {'1': 'url', '3': 3, '4': 1, '5': 9, '10': 'url'},
    {'1': 'clicks', '3': 4, '4': 1, '5': 5, '10': 'clicks'},
    {'1': 'conversions', '3': 5, '4': 1, '5': 5, '10': 'conversions'},
    {'1': 'revenue', '3': 6, '4': 1, '5': 1, '10': 'revenue'},
  ],
};

/// Descriptor for `LinkItemMetric`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List linkItemMetricDescriptor = $convert.base64Decode(
    'Cg5MaW5rSXRlbU1ldHJpYxIgCgxsaW5rX2l0ZW1faWQYASABKAlSCmxpbmtJdGVtSWQSFAoFbG'
    'FiZWwYAiABKAlSBWxhYmVsEhAKA3VybBgDIAEoCVIDdXJsEhYKBmNsaWNrcxgEIAEoBVIGY2xp'
    'Y2tzEiAKC2NvbnZlcnNpb25zGAUgASgFUgtjb252ZXJzaW9ucxIYCgdyZXZlbnVlGAYgASgBUg'
    'dyZXZlbnVl');

@$core.Deprecated('Use mediaKitDescriptor instead')
const MediaKit$json = {
  '1': 'MediaKit',
  '2': [
    {'1': 'media_kit_id', '3': 1, '4': 1, '5': 9, '10': 'mediaKitId'},
    {'1': 'workspace_id', '3': 2, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'template', '3': 3, '4': 1, '5': 9, '10': 'template'},
    {'1': 'sections_json', '3': 4, '4': 1, '5': 9, '10': 'sectionsJson'},
    {'1': 'brand_profile_id', '3': 5, '4': 1, '5': 9, '10': 'brandProfileId'},
    {'1': 'share_url', '3': 6, '4': 1, '5': 9, '10': 'shareUrl'},
    {'1': 'directory_opt_in', '3': 7, '4': 1, '5': 8, '10': 'directoryOptIn'},
    {
      '1': 'directory_status',
      '3': 8,
      '4': 1,
      '5': 14,
      '6': '.creativanta.commerce.v1.MediaKitDirectoryStatus',
      '10': 'directoryStatus'
    },
    {
      '1': 'directory_profile_json',
      '3': 9,
      '4': 1,
      '5': 9,
      '10': 'directoryProfileJson'
    },
    {
      '1': 'directory_consented_at',
      '3': 10,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'directoryConsentedAt'
    },
    {
      '1': 'last_generated_at',
      '3': 11,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'lastGeneratedAt'
    },
    {
      '1': 'generation_credits_used',
      '3': 12,
      '4': 1,
      '5': 1,
      '10': 'generationCreditsUsed'
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

/// Descriptor for `MediaKit`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List mediaKitDescriptor = $convert.base64Decode(
    'CghNZWRpYUtpdBIgCgxtZWRpYV9raXRfaWQYASABKAlSCm1lZGlhS2l0SWQSIQoMd29ya3NwYW'
    'NlX2lkGAIgASgJUgt3b3Jrc3BhY2VJZBIaCgh0ZW1wbGF0ZRgDIAEoCVIIdGVtcGxhdGUSIwoN'
    'c2VjdGlvbnNfanNvbhgEIAEoCVIMc2VjdGlvbnNKc29uEigKEGJyYW5kX3Byb2ZpbGVfaWQYBS'
    'ABKAlSDmJyYW5kUHJvZmlsZUlkEhsKCXNoYXJlX3VybBgGIAEoCVIIc2hhcmVVcmwSKAoQZGly'
    'ZWN0b3J5X29wdF9pbhgHIAEoCFIOZGlyZWN0b3J5T3B0SW4SWwoQZGlyZWN0b3J5X3N0YXR1cx'
    'gIIAEoDjIwLmNyZWF0aXZhbnRhLmNvbW1lcmNlLnYxLk1lZGlhS2l0RGlyZWN0b3J5U3RhdHVz'
    'Ug9kaXJlY3RvcnlTdGF0dXMSNAoWZGlyZWN0b3J5X3Byb2ZpbGVfanNvbhgJIAEoCVIUZGlyZW'
    'N0b3J5UHJvZmlsZUpzb24SUAoWZGlyZWN0b3J5X2NvbnNlbnRlZF9hdBgKIAEoCzIaLmdvb2ds'
    'ZS5wcm90b2J1Zi5UaW1lc3RhbXBSFGRpcmVjdG9yeUNvbnNlbnRlZEF0EkYKEWxhc3RfZ2VuZX'
    'JhdGVkX2F0GAsgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIPbGFzdEdlbmVyYXRl'
    'ZEF0EjYKF2dlbmVyYXRpb25fY3JlZGl0c191c2VkGAwgASgBUhVnZW5lcmF0aW9uQ3JlZGl0c1'
    'VzZWQSOQoKY3JlYXRlZF9hdBgNIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSCWNy'
    'ZWF0ZWRBdBI5Cgp1cGRhdGVkX2F0GA4gASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcF'
    'IJdXBkYXRlZEF0');

@$core.Deprecated('Use rateCardDescriptor instead')
const RateCard$json = {
  '1': 'RateCard',
  '2': [
    {'1': 'rate_card_id', '3': 1, '4': 1, '5': 9, '10': 'rateCardId'},
    {'1': 'workspace_id', '3': 2, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'currency', '3': 3, '4': 1, '5': 9, '10': 'currency'},
    {'1': 'custom_note', '3': 4, '4': 1, '5': 9, '10': 'customNote'},
    {
      '1': 'ai_suggested_at',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'aiSuggestedAt'
    },
    {
      '1': 'items',
      '3': 6,
      '4': 3,
      '5': 11,
      '6': '.creativanta.commerce.v1.RateCardItem',
      '10': 'items'
    },
    {
      '1': 'created_at',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'createdAt'
    },
    {
      '1': 'updated_at',
      '3': 8,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'updatedAt'
    },
  ],
};

/// Descriptor for `RateCard`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List rateCardDescriptor = $convert.base64Decode(
    'CghSYXRlQ2FyZBIgCgxyYXRlX2NhcmRfaWQYASABKAlSCnJhdGVDYXJkSWQSIQoMd29ya3NwYW'
    'NlX2lkGAIgASgJUgt3b3Jrc3BhY2VJZBIaCghjdXJyZW5jeRgDIAEoCVIIY3VycmVuY3kSHwoL'
    'Y3VzdG9tX25vdGUYBCABKAlSCmN1c3RvbU5vdGUSQgoPYWlfc3VnZ2VzdGVkX2F0GAUgASgLMh'
    'ouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFINYWlTdWdnZXN0ZWRBdBI7CgVpdGVtcxgGIAMo'
    'CzIlLmNyZWF0aXZhbnRhLmNvbW1lcmNlLnYxLlJhdGVDYXJkSXRlbVIFaXRlbXMSOQoKY3JlYX'
    'RlZF9hdBgHIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSCWNyZWF0ZWRBdBI5Cgp1'
    'cGRhdGVkX2F0GAggASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIJdXBkYXRlZEF0');

@$core.Deprecated('Use rateCardItemDescriptor instead')
const RateCardItem$json = {
  '1': 'RateCardItem',
  '2': [
    {'1': 'item_id', '3': 1, '4': 1, '5': 9, '10': 'itemId'},
    {'1': 'rate_card_id', '3': 2, '4': 1, '5': 9, '10': 'rateCardId'},
    {'1': 'workspace_id', '3': 3, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'service_type', '3': 4, '4': 1, '5': 9, '10': 'serviceType'},
    {'1': 'price_min', '3': 5, '4': 1, '5': 1, '10': 'priceMin'},
    {'1': 'price_max', '3': 6, '4': 1, '5': 1, '10': 'priceMax'},
    {
      '1': 'ai_suggested_price',
      '3': 7,
      '4': 1,
      '5': 1,
      '10': 'aiSuggestedPrice'
    },
    {'1': 'description', '3': 8, '4': 1, '5': 9, '10': 'description'},
    {'1': 'delivery_time', '3': 9, '4': 1, '5': 9, '10': 'deliveryTime'},
    {'1': 'position', '3': 10, '4': 1, '5': 5, '10': 'position'},
    {
      '1': 'created_at',
      '3': 11,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'createdAt'
    },
    {
      '1': 'updated_at',
      '3': 12,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'updatedAt'
    },
  ],
};

/// Descriptor for `RateCardItem`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List rateCardItemDescriptor = $convert.base64Decode(
    'CgxSYXRlQ2FyZEl0ZW0SFwoHaXRlbV9pZBgBIAEoCVIGaXRlbUlkEiAKDHJhdGVfY2FyZF9pZB'
    'gCIAEoCVIKcmF0ZUNhcmRJZBIhCgx3b3Jrc3BhY2VfaWQYAyABKAlSC3dvcmtzcGFjZUlkEiEK'
    'DHNlcnZpY2VfdHlwZRgEIAEoCVILc2VydmljZVR5cGUSGwoJcHJpY2VfbWluGAUgASgBUghwcm'
    'ljZU1pbhIbCglwcmljZV9tYXgYBiABKAFSCHByaWNlTWF4EiwKEmFpX3N1Z2dlc3RlZF9wcmlj'
    'ZRgHIAEoAVIQYWlTdWdnZXN0ZWRQcmljZRIgCgtkZXNjcmlwdGlvbhgIIAEoCVILZGVzY3JpcH'
    'Rpb24SIwoNZGVsaXZlcnlfdGltZRgJIAEoCVIMZGVsaXZlcnlUaW1lEhoKCHBvc2l0aW9uGAog'
    'ASgFUghwb3NpdGlvbhI5CgpjcmVhdGVkX2F0GAsgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbW'
    'VzdGFtcFIJY3JlYXRlZEF0EjkKCnVwZGF0ZWRfYXQYDCABKAsyGi5nb29nbGUucHJvdG9idWYu'
    'VGltZXN0YW1wUgl1cGRhdGVkQXQ=');

@$core.Deprecated('Use brandDealDescriptor instead')
const BrandDeal$json = {
  '1': 'BrandDeal',
  '2': [
    {'1': 'deal_id', '3': 1, '4': 1, '5': 9, '10': 'dealId'},
    {'1': 'workspace_id', '3': 2, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'brand_name', '3': 3, '4': 1, '5': 9, '10': 'brandName'},
    {'1': 'contact_email', '3': 4, '4': 1, '5': 9, '10': 'contactEmail'},
    {
      '1': 'deal_type',
      '3': 5,
      '4': 1,
      '5': 14,
      '6': '.creativanta.commerce.v1.BrandDealType',
      '10': 'dealType'
    },
    {'1': 'value', '3': 6, '4': 1, '5': 1, '10': 'value'},
    {'1': 'currency', '3': 7, '4': 1, '5': 9, '10': 'currency'},
    {
      '1': 'status',
      '3': 8,
      '4': 1,
      '5': 14,
      '6': '.creativanta.commerce.v1.BrandDealStatus',
      '10': 'status'
    },
    {'1': 'deadline', '3': 9, '4': 1, '5': 9, '10': 'deadline'},
    {'1': 'deliverables', '3': 10, '4': 1, '5': 9, '10': 'deliverables'},
    {
      '1': 'contract_evidence_ids',
      '3': 11,
      '4': 3,
      '5': 9,
      '10': 'contractEvidenceIds'
    },
    {
      '1': 'inquiry_thread_id',
      '3': 12,
      '4': 1,
      '5': 9,
      '10': 'inquiryThreadId'
    },
    {'1': 'notes', '3': 13, '4': 1, '5': 9, '10': 'notes'},
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

/// Descriptor for `BrandDeal`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List brandDealDescriptor = $convert.base64Decode(
    'CglCcmFuZERlYWwSFwoHZGVhbF9pZBgBIAEoCVIGZGVhbElkEiEKDHdvcmtzcGFjZV9pZBgCIA'
    'EoCVILd29ya3NwYWNlSWQSHQoKYnJhbmRfbmFtZRgDIAEoCVIJYnJhbmROYW1lEiMKDWNvbnRh'
    'Y3RfZW1haWwYBCABKAlSDGNvbnRhY3RFbWFpbBJDCglkZWFsX3R5cGUYBSABKA4yJi5jcmVhdG'
    'l2YW50YS5jb21tZXJjZS52MS5CcmFuZERlYWxUeXBlUghkZWFsVHlwZRIUCgV2YWx1ZRgGIAEo'
    'AVIFdmFsdWUSGgoIY3VycmVuY3kYByABKAlSCGN1cnJlbmN5EkAKBnN0YXR1cxgIIAEoDjIoLm'
    'NyZWF0aXZhbnRhLmNvbW1lcmNlLnYxLkJyYW5kRGVhbFN0YXR1c1IGc3RhdHVzEhoKCGRlYWRs'
    'aW5lGAkgASgJUghkZWFkbGluZRIiCgxkZWxpdmVyYWJsZXMYCiABKAlSDGRlbGl2ZXJhYmxlcx'
    'IyChVjb250cmFjdF9ldmlkZW5jZV9pZHMYCyADKAlSE2NvbnRyYWN0RXZpZGVuY2VJZHMSKgoR'
    'aW5xdWlyeV90aHJlYWRfaWQYDCABKAlSD2lucXVpcnlUaHJlYWRJZBIUCgVub3RlcxgNIAEoCV'
    'IFbm90ZXMSOQoKY3JlYXRlZF9hdBgOIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBS'
    'CWNyZWF0ZWRBdBI5Cgp1cGRhdGVkX2F0GA8gASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdG'
    'FtcFIJdXBkYXRlZEF0');

@$core.Deprecated('Use brandDealPipelineStatsDescriptor instead')
const BrandDealPipelineStats$json = {
  '1': 'BrandDealPipelineStats',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {
      '1': 'negotiating_count',
      '3': 2,
      '4': 1,
      '5': 5,
      '10': 'negotiatingCount'
    },
    {'1': 'agreed_count', '3': 3, '4': 1, '5': 5, '10': 'agreedCount'},
    {'1': 'in_progress_count', '3': 4, '4': 1, '5': 5, '10': 'inProgressCount'},
    {'1': 'delivered_count', '3': 5, '4': 1, '5': 5, '10': 'deliveredCount'},
    {'1': 'paid_count', '3': 6, '4': 1, '5': 5, '10': 'paidCount'},
    {'1': 'completed_count', '3': 7, '4': 1, '5': 5, '10': 'completedCount'},
    {'1': 'cancelled_count', '3': 8, '4': 1, '5': 5, '10': 'cancelledCount'},
    {
      '1': 'total_active_value',
      '3': 9,
      '4': 1,
      '5': 1,
      '10': 'totalActiveValue'
    },
    {
      '1': 'total_completed_value',
      '3': 10,
      '4': 1,
      '5': 1,
      '10': 'totalCompletedValue'
    },
    {'1': 'currency', '3': 11, '4': 1, '5': 9, '10': 'currency'},
  ],
};

/// Descriptor for `BrandDealPipelineStats`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List brandDealPipelineStatsDescriptor = $convert.base64Decode(
    'ChZCcmFuZERlYWxQaXBlbGluZVN0YXRzEiEKDHdvcmtzcGFjZV9pZBgBIAEoCVILd29ya3NwYW'
    'NlSWQSKwoRbmVnb3RpYXRpbmdfY291bnQYAiABKAVSEG5lZ290aWF0aW5nQ291bnQSIQoMYWdy'
    'ZWVkX2NvdW50GAMgASgFUgthZ3JlZWRDb3VudBIqChFpbl9wcm9ncmVzc19jb3VudBgEIAEoBV'
    'IPaW5Qcm9ncmVzc0NvdW50EicKD2RlbGl2ZXJlZF9jb3VudBgFIAEoBVIOZGVsaXZlcmVkQ291'
    'bnQSHQoKcGFpZF9jb3VudBgGIAEoBVIJcGFpZENvdW50EicKD2NvbXBsZXRlZF9jb3VudBgHIA'
    'EoBVIOY29tcGxldGVkQ291bnQSJwoPY2FuY2VsbGVkX2NvdW50GAggASgFUg5jYW5jZWxsZWRD'
    'b3VudBIsChJ0b3RhbF9hY3RpdmVfdmFsdWUYCSABKAFSEHRvdGFsQWN0aXZlVmFsdWUSMgoVdG'
    '90YWxfY29tcGxldGVkX3ZhbHVlGAogASgBUhN0b3RhbENvbXBsZXRlZFZhbHVlEhoKCGN1cnJl'
    'bmN5GAsgASgJUghjdXJyZW5jeQ==');

@$core.Deprecated('Use contentROIMetricDescriptor instead')
const ContentROIMetric$json = {
  '1': 'ContentROIMetric',
  '2': [
    {'1': 'content_id', '3': 1, '4': 1, '5': 9, '10': 'contentId'},
    {'1': 'title', '3': 2, '4': 1, '5': 9, '10': 'title'},
    {'1': 'platform', '3': 3, '4': 1, '5': 9, '10': 'platform'},
    {'1': 'views', '3': 4, '4': 1, '5': 3, '10': 'views'},
    {'1': 'engagement', '3': 5, '4': 1, '5': 3, '10': 'engagement'},
    {'1': 'link_clicks', '3': 6, '4': 1, '5': 3, '10': 'linkClicks'},
    {
      '1': 'orders_attributed',
      '3': 7,
      '4': 1,
      '5': 3,
      '10': 'ordersAttributed'
    },
    {
      '1': 'revenue_attributed',
      '3': 8,
      '4': 1,
      '5': 1,
      '10': 'revenueAttributed'
    },
    {'1': 'cost_to_produce', '3': 9, '4': 1, '5': 1, '10': 'costToProduce'},
    {'1': 'roi_percentage', '3': 10, '4': 1, '5': 1, '10': 'roiPercentage'},
    {'1': 'rpm', '3': 11, '4': 1, '5': 1, '10': 'rpm'},
    {'1': 'rpm_is_undefined', '3': 12, '4': 1, '5': 8, '10': 'rpmIsUndefined'},
    {'1': 'production_mode', '3': 13, '4': 1, '5': 9, '10': 'productionMode'},
    {'1': 'is_derivative', '3': 14, '4': 1, '5': 8, '10': 'isDerivative'},
    {
      '1': 'source_content_id',
      '3': 15,
      '4': 1,
      '5': 9,
      '10': 'sourceContentId'
    },
    {'1': 'derivative_count', '3': 16, '4': 1, '5': 5, '10': 'derivativeCount'},
    {
      '1': 'derivative_total_revenue',
      '3': 17,
      '4': 1,
      '5': 1,
      '10': 'derivativeTotalRevenue'
    },
    {
      '1': 'published_at',
      '3': 18,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'publishedAt'
    },
  ],
};

/// Descriptor for `ContentROIMetric`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List contentROIMetricDescriptor = $convert.base64Decode(
    'ChBDb250ZW50Uk9JTWV0cmljEh0KCmNvbnRlbnRfaWQYASABKAlSCWNvbnRlbnRJZBIUCgV0aX'
    'RsZRgCIAEoCVIFdGl0bGUSGgoIcGxhdGZvcm0YAyABKAlSCHBsYXRmb3JtEhQKBXZpZXdzGAQg'
    'ASgDUgV2aWV3cxIeCgplbmdhZ2VtZW50GAUgASgDUgplbmdhZ2VtZW50Eh8KC2xpbmtfY2xpY2'
    'tzGAYgASgDUgpsaW5rQ2xpY2tzEisKEW9yZGVyc19hdHRyaWJ1dGVkGAcgASgDUhBvcmRlcnNB'
    'dHRyaWJ1dGVkEi0KEnJldmVudWVfYXR0cmlidXRlZBgIIAEoAVIRcmV2ZW51ZUF0dHJpYnV0ZW'
    'QSJgoPY29zdF90b19wcm9kdWNlGAkgASgBUg1jb3N0VG9Qcm9kdWNlEiUKDnJvaV9wZXJjZW50'
    'YWdlGAogASgBUg1yb2lQZXJjZW50YWdlEhAKA3JwbRgLIAEoAVIDcnBtEigKEHJwbV9pc191bm'
    'RlZmluZWQYDCABKAhSDnJwbUlzVW5kZWZpbmVkEicKD3Byb2R1Y3Rpb25fbW9kZRgNIAEoCVIO'
    'cHJvZHVjdGlvbk1vZGUSIwoNaXNfZGVyaXZhdGl2ZRgOIAEoCFIMaXNEZXJpdmF0aXZlEioKEX'
    'NvdXJjZV9jb250ZW50X2lkGA8gASgJUg9zb3VyY2VDb250ZW50SWQSKQoQZGVyaXZhdGl2ZV9j'
    'b3VudBgQIAEoBVIPZGVyaXZhdGl2ZUNvdW50EjgKGGRlcml2YXRpdmVfdG90YWxfcmV2ZW51ZR'
    'gRIAEoAVIWZGVyaXZhdGl2ZVRvdGFsUmV2ZW51ZRI9CgxwdWJsaXNoZWRfYXQYEiABKAsyGi5n'
    'b29nbGUucHJvdG9idWYuVGltZXN0YW1wUgtwdWJsaXNoZWRBdA==');

@$core.Deprecated('Use rPMTrendPointDescriptor instead')
const RPMTrendPoint$json = {
  '1': 'RPMTrendPoint',
  '2': [
    {'1': 'period_label', '3': 1, '4': 1, '5': 9, '10': 'periodLabel'},
    {'1': 'platform', '3': 2, '4': 1, '5': 9, '10': 'platform'},
    {'1': 'rpm', '3': 3, '4': 1, '5': 1, '10': 'rpm'},
    {'1': 'rpm_is_undefined', '3': 4, '4': 1, '5': 8, '10': 'rpmIsUndefined'},
    {'1': 'views', '3': 5, '4': 1, '5': 3, '10': 'views'},
    {'1': 'revenue', '3': 6, '4': 1, '5': 1, '10': 'revenue'},
    {'1': 'change_percent', '3': 7, '4': 1, '5': 1, '10': 'changePercent'},
    {
      '1': 'drop_alert_triggered',
      '3': 8,
      '4': 1,
      '5': 8,
      '10': 'dropAlertTriggered'
    },
  ],
};

/// Descriptor for `RPMTrendPoint`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List rPMTrendPointDescriptor = $convert.base64Decode(
    'Cg1SUE1UcmVuZFBvaW50EiEKDHBlcmlvZF9sYWJlbBgBIAEoCVILcGVyaW9kTGFiZWwSGgoIcG'
    'xhdGZvcm0YAiABKAlSCHBsYXRmb3JtEhAKA3JwbRgDIAEoAVIDcnBtEigKEHJwbV9pc191bmRl'
    'ZmluZWQYBCABKAhSDnJwbUlzVW5kZWZpbmVkEhQKBXZpZXdzGAUgASgDUgV2aWV3cxIYCgdyZX'
    'ZlbnVlGAYgASgBUgdyZXZlbnVlEiUKDmNoYW5nZV9wZXJjZW50GAcgASgBUg1jaGFuZ2VQZXJj'
    'ZW50EjAKFGRyb3BfYWxlcnRfdHJpZ2dlcmVkGAggASgIUhJkcm9wQWxlcnRUcmlnZ2VyZWQ=');

@$core.Deprecated('Use taxReportSummaryDescriptor instead')
const TaxReportSummary$json = {
  '1': 'TaxReportSummary',
  '2': [
    {'1': 'report_id', '3': 1, '4': 1, '5': 9, '10': 'reportId'},
    {'1': 'workspace_id', '3': 2, '4': 1, '5': 9, '10': 'workspaceId'},
    {
      '1': 'period',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.creativanta.commerce.v1.TaxReportPeriod',
      '10': 'period'
    },
    {'1': 'year', '3': 4, '4': 1, '5': 5, '10': 'year'},
    {'1': 'period_number', '3': 5, '4': 1, '5': 5, '10': 'periodNumber'},
    {'1': 'total_revenue', '3': 6, '4': 1, '5': 1, '10': 'totalRevenue'},
    {
      '1': 'affiliate_revenue',
      '3': 7,
      '4': 1,
      '5': 1,
      '10': 'affiliateRevenue'
    },
    {
      '1': 'sponsorship_revenue',
      '3': 8,
      '4': 1,
      '5': 1,
      '10': 'sponsorshipRevenue'
    },
    {
      '1': 'product_sales_revenue',
      '3': 9,
      '4': 1,
      '5': 1,
      '10': 'productSalesRevenue'
    },
    {
      '1': 'ai_credit_expenses',
      '3': 10,
      '4': 1,
      '5': 1,
      '10': 'aiCreditExpenses'
    },
    {
      '1': 'subscription_expenses',
      '3': 11,
      '4': 1,
      '5': 1,
      '10': 'subscriptionExpenses'
    },
    {
      '1': 'net_income_before_tax',
      '3': 12,
      '4': 1,
      '5': 1,
      '10': 'netIncomeBeforeTax'
    },
    {'1': 'currency', '3': 13, '4': 1, '5': 9, '10': 'currency'},
    {
      '1': 'format',
      '3': 14,
      '4': 1,
      '5': 14,
      '6': '.creativanta.commerce.v1.TaxReportFormat',
      '10': 'format'
    },
    {'1': 'download_url', '3': 15, '4': 1, '5': 9, '10': 'downloadUrl'},
    {
      '1': 'generated_at',
      '3': 16,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'generatedAt'
    },
  ],
};

/// Descriptor for `TaxReportSummary`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List taxReportSummaryDescriptor = $convert.base64Decode(
    'ChBUYXhSZXBvcnRTdW1tYXJ5EhsKCXJlcG9ydF9pZBgBIAEoCVIIcmVwb3J0SWQSIQoMd29ya3'
    'NwYWNlX2lkGAIgASgJUgt3b3Jrc3BhY2VJZBJACgZwZXJpb2QYAyABKA4yKC5jcmVhdGl2YW50'
    'YS5jb21tZXJjZS52MS5UYXhSZXBvcnRQZXJpb2RSBnBlcmlvZBISCgR5ZWFyGAQgASgFUgR5ZW'
    'FyEiMKDXBlcmlvZF9udW1iZXIYBSABKAVSDHBlcmlvZE51bWJlchIjCg10b3RhbF9yZXZlbnVl'
    'GAYgASgBUgx0b3RhbFJldmVudWUSKwoRYWZmaWxpYXRlX3JldmVudWUYByABKAFSEGFmZmlsaW'
    'F0ZVJldmVudWUSLwoTc3BvbnNvcnNoaXBfcmV2ZW51ZRgIIAEoAVISc3BvbnNvcnNoaXBSZXZl'
    'bnVlEjIKFXByb2R1Y3Rfc2FsZXNfcmV2ZW51ZRgJIAEoAVITcHJvZHVjdFNhbGVzUmV2ZW51ZR'
    'IsChJhaV9jcmVkaXRfZXhwZW5zZXMYCiABKAFSEGFpQ3JlZGl0RXhwZW5zZXMSMwoVc3Vic2Ny'
    'aXB0aW9uX2V4cGVuc2VzGAsgASgBUhRzdWJzY3JpcHRpb25FeHBlbnNlcxIxChVuZXRfaW5jb2'
    '1lX2JlZm9yZV90YXgYDCABKAFSEm5ldEluY29tZUJlZm9yZVRheBIaCghjdXJyZW5jeRgNIAEo'
    'CVIIY3VycmVuY3kSQAoGZm9ybWF0GA4gASgOMiguY3JlYXRpdmFudGEuY29tbWVyY2UudjEuVG'
    'F4UmVwb3J0Rm9ybWF0UgZmb3JtYXQSIQoMZG93bmxvYWRfdXJsGA8gASgJUgtkb3dubG9hZFVy'
    'bBI9CgxnZW5lcmF0ZWRfYXQYECABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUgtnZW'
    '5lcmF0ZWRBdA==');

@$core.Deprecated('Use createPageRequestDescriptor instead')
const CreatePageRequest$json = {
  '1': 'CreatePageRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'slug', '3': 2, '4': 1, '5': 9, '10': 'slug'},
    {'1': 'title', '3': 3, '4': 1, '5': 9, '10': 'title'},
    {'1': 'bio', '3': 4, '4': 1, '5': 9, '10': 'bio'},
    {'1': 'avatar_url', '3': 5, '4': 1, '5': 9, '10': 'avatarUrl'},
    {'1': 'theme', '3': 6, '4': 1, '5': 9, '10': 'theme'},
  ],
};

/// Descriptor for `CreatePageRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createPageRequestDescriptor = $convert.base64Decode(
    'ChFDcmVhdGVQYWdlUmVxdWVzdBIhCgx3b3Jrc3BhY2VfaWQYASABKAlSC3dvcmtzcGFjZUlkEh'
    'IKBHNsdWcYAiABKAlSBHNsdWcSFAoFdGl0bGUYAyABKAlSBXRpdGxlEhAKA2JpbxgEIAEoCVID'
    'YmlvEh0KCmF2YXRhcl91cmwYBSABKAlSCWF2YXRhclVybBIUCgV0aGVtZRgGIAEoCVIFdGhlbW'
    'U=');

@$core.Deprecated('Use createPageResponseDescriptor instead')
const CreatePageResponse$json = {
  '1': 'CreatePageResponse',
  '2': [
    {
      '1': 'page',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.commerce.v1.LinkInBioPage',
      '10': 'page'
    },
  ],
};

/// Descriptor for `CreatePageResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createPageResponseDescriptor = $convert.base64Decode(
    'ChJDcmVhdGVQYWdlUmVzcG9uc2USOgoEcGFnZRgBIAEoCzImLmNyZWF0aXZhbnRhLmNvbW1lcm'
    'NlLnYxLkxpbmtJbkJpb1BhZ2VSBHBhZ2U=');

@$core.Deprecated('Use getPageRequestDescriptor instead')
const GetPageRequest$json = {
  '1': 'GetPageRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'page_id', '3': 2, '4': 1, '5': 9, '10': 'pageId'},
    {'1': 'slug', '3': 3, '4': 1, '5': 9, '10': 'slug'},
  ],
};

/// Descriptor for `GetPageRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getPageRequestDescriptor = $convert.base64Decode(
    'Cg5HZXRQYWdlUmVxdWVzdBIhCgx3b3Jrc3BhY2VfaWQYASABKAlSC3dvcmtzcGFjZUlkEhcKB3'
    'BhZ2VfaWQYAiABKAlSBnBhZ2VJZBISCgRzbHVnGAMgASgJUgRzbHVn');

@$core.Deprecated('Use getPageResponseDescriptor instead')
const GetPageResponse$json = {
  '1': 'GetPageResponse',
  '2': [
    {
      '1': 'page',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.commerce.v1.LinkInBioPage',
      '10': 'page'
    },
  ],
};

/// Descriptor for `GetPageResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getPageResponseDescriptor = $convert.base64Decode(
    'Cg9HZXRQYWdlUmVzcG9uc2USOgoEcGFnZRgBIAEoCzImLmNyZWF0aXZhbnRhLmNvbW1lcmNlLn'
    'YxLkxpbmtJbkJpb1BhZ2VSBHBhZ2U=');

@$core.Deprecated('Use updatePageRequestDescriptor instead')
const UpdatePageRequest$json = {
  '1': 'UpdatePageRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'page_id', '3': 2, '4': 1, '5': 9, '10': 'pageId'},
    {'1': 'title', '3': 3, '4': 1, '5': 9, '10': 'title'},
    {'1': 'bio', '3': 4, '4': 1, '5': 9, '10': 'bio'},
    {'1': 'avatar_url', '3': 5, '4': 1, '5': 9, '10': 'avatarUrl'},
    {'1': 'theme', '3': 6, '4': 1, '5': 9, '10': 'theme'},
    {'1': 'custom_css', '3': 7, '4': 1, '5': 9, '10': 'customCss'},
    {'1': 'custom_domain', '3': 8, '4': 1, '5': 9, '10': 'customDomain'},
  ],
};

/// Descriptor for `UpdatePageRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updatePageRequestDescriptor = $convert.base64Decode(
    'ChFVcGRhdGVQYWdlUmVxdWVzdBIhCgx3b3Jrc3BhY2VfaWQYASABKAlSC3dvcmtzcGFjZUlkEh'
    'cKB3BhZ2VfaWQYAiABKAlSBnBhZ2VJZBIUCgV0aXRsZRgDIAEoCVIFdGl0bGUSEAoDYmlvGAQg'
    'ASgJUgNiaW8SHQoKYXZhdGFyX3VybBgFIAEoCVIJYXZhdGFyVXJsEhQKBXRoZW1lGAYgASgJUg'
    'V0aGVtZRIdCgpjdXN0b21fY3NzGAcgASgJUgljdXN0b21Dc3MSIwoNY3VzdG9tX2RvbWFpbhgI'
    'IAEoCVIMY3VzdG9tRG9tYWlu');

@$core.Deprecated('Use updatePageResponseDescriptor instead')
const UpdatePageResponse$json = {
  '1': 'UpdatePageResponse',
  '2': [
    {
      '1': 'page',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.commerce.v1.LinkInBioPage',
      '10': 'page'
    },
  ],
};

/// Descriptor for `UpdatePageResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updatePageResponseDescriptor = $convert.base64Decode(
    'ChJVcGRhdGVQYWdlUmVzcG9uc2USOgoEcGFnZRgBIAEoCzImLmNyZWF0aXZhbnRhLmNvbW1lcm'
    'NlLnYxLkxpbmtJbkJpb1BhZ2VSBHBhZ2U=');

@$core.Deprecated('Use linkInBioServiceSaveRequestDescriptor instead')
const LinkInBioServiceSaveRequest$json = {
  '1': 'LinkInBioServiceSaveRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'page_id', '3': 2, '4': 1, '5': 9, '10': 'pageId'},
    {'1': 'title', '3': 3, '4': 1, '5': 9, '10': 'title'},
    {'1': 'bio', '3': 4, '4': 1, '5': 9, '10': 'bio'},
    {
      '1': 'items',
      '3': 5,
      '4': 3,
      '5': 11,
      '6': '.creativanta.commerce.v1.LinkItem',
      '10': 'items'
    },
  ],
};

/// Descriptor for `LinkInBioServiceSaveRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List linkInBioServiceSaveRequestDescriptor = $convert.base64Decode(
    'ChtMaW5rSW5CaW9TZXJ2aWNlU2F2ZVJlcXVlc3QSIQoMd29ya3NwYWNlX2lkGAEgASgJUgt3b3'
    'Jrc3BhY2VJZBIXCgdwYWdlX2lkGAIgASgJUgZwYWdlSWQSFAoFdGl0bGUYAyABKAlSBXRpdGxl'
    'EhAKA2JpbxgEIAEoCVIDYmlvEjcKBWl0ZW1zGAUgAygLMiEuY3JlYXRpdmFudGEuY29tbWVyY2'
    'UudjEuTGlua0l0ZW1SBWl0ZW1z');

@$core.Deprecated('Use linkInBioServiceSaveResponseDescriptor instead')
const LinkInBioServiceSaveResponse$json = {
  '1': 'LinkInBioServiceSaveResponse',
  '2': [
    {
      '1': 'page',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.commerce.v1.LinkInBioPage',
      '10': 'page'
    },
  ],
};

/// Descriptor for `LinkInBioServiceSaveResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List linkInBioServiceSaveResponseDescriptor =
    $convert.base64Decode(
        'ChxMaW5rSW5CaW9TZXJ2aWNlU2F2ZVJlc3BvbnNlEjoKBHBhZ2UYASABKAsyJi5jcmVhdGl2YW'
        '50YS5jb21tZXJjZS52MS5MaW5rSW5CaW9QYWdlUgRwYWdl');

@$core.Deprecated('Use getAnalyticsRequestDescriptor instead')
const GetAnalyticsRequest$json = {
  '1': 'GetAnalyticsRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'page_id', '3': 2, '4': 1, '5': 9, '10': 'pageId'},
    {'1': 'lookback_days', '3': 3, '4': 1, '5': 5, '10': 'lookbackDays'},
  ],
};

/// Descriptor for `GetAnalyticsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getAnalyticsRequestDescriptor = $convert.base64Decode(
    'ChNHZXRBbmFseXRpY3NSZXF1ZXN0EiEKDHdvcmtzcGFjZV9pZBgBIAEoCVILd29ya3NwYWNlSW'
    'QSFwoHcGFnZV9pZBgCIAEoCVIGcGFnZUlkEiMKDWxvb2tiYWNrX2RheXMYAyABKAVSDGxvb2ti'
    'YWNrRGF5cw==');

@$core.Deprecated('Use getAnalyticsResponseDescriptor instead')
const GetAnalyticsResponse$json = {
  '1': 'GetAnalyticsResponse',
  '2': [
    {
      '1': 'analytics',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.commerce.v1.LinkInBioAnalytics',
      '10': 'analytics'
    },
  ],
};

/// Descriptor for `GetAnalyticsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getAnalyticsResponseDescriptor = $convert.base64Decode(
    'ChRHZXRBbmFseXRpY3NSZXNwb25zZRJJCglhbmFseXRpY3MYASABKAsyKy5jcmVhdGl2YW50YS'
    '5jb21tZXJjZS52MS5MaW5rSW5CaW9BbmFseXRpY3NSCWFuYWx5dGljcw==');

@$core.Deprecated('Use linkInBioServiceReorderRequestDescriptor instead')
const LinkInBioServiceReorderRequest$json = {
  '1': 'LinkInBioServiceReorderRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'page_id', '3': 2, '4': 1, '5': 9, '10': 'pageId'},
    {'1': 'item_ids_in_order', '3': 3, '4': 3, '5': 9, '10': 'itemIdsInOrder'},
  ],
};

/// Descriptor for `LinkInBioServiceReorderRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List linkInBioServiceReorderRequestDescriptor =
    $convert.base64Decode(
        'Ch5MaW5rSW5CaW9TZXJ2aWNlUmVvcmRlclJlcXVlc3QSIQoMd29ya3NwYWNlX2lkGAEgASgJUg'
        't3b3Jrc3BhY2VJZBIXCgdwYWdlX2lkGAIgASgJUgZwYWdlSWQSKQoRaXRlbV9pZHNfaW5fb3Jk'
        'ZXIYAyADKAlSDml0ZW1JZHNJbk9yZGVy');

@$core.Deprecated('Use linkInBioServiceReorderResponseDescriptor instead')
const LinkInBioServiceReorderResponse$json = {
  '1': 'LinkInBioServiceReorderResponse',
  '2': [
    {
      '1': 'items',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.creativanta.commerce.v1.LinkItem',
      '10': 'items'
    },
  ],
};

/// Descriptor for `LinkInBioServiceReorderResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List linkInBioServiceReorderResponseDescriptor =
    $convert.base64Decode(
        'Ch9MaW5rSW5CaW9TZXJ2aWNlUmVvcmRlclJlc3BvbnNlEjcKBWl0ZW1zGAEgAygLMiEuY3JlYX'
        'RpdmFudGEuY29tbWVyY2UudjEuTGlua0l0ZW1SBWl0ZW1z');

@$core.Deprecated('Use toggleLinkRequestDescriptor instead')
const ToggleLinkRequest$json = {
  '1': 'ToggleLinkRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'link_item_id', '3': 2, '4': 1, '5': 9, '10': 'linkItemId'},
    {'1': 'is_active', '3': 3, '4': 1, '5': 8, '10': 'isActive'},
  ],
};

/// Descriptor for `ToggleLinkRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List toggleLinkRequestDescriptor = $convert.base64Decode(
    'ChFUb2dnbGVMaW5rUmVxdWVzdBIhCgx3b3Jrc3BhY2VfaWQYASABKAlSC3dvcmtzcGFjZUlkEi'
    'AKDGxpbmtfaXRlbV9pZBgCIAEoCVIKbGlua0l0ZW1JZBIbCglpc19hY3RpdmUYAyABKAhSCGlz'
    'QWN0aXZl');

@$core.Deprecated('Use toggleLinkResponseDescriptor instead')
const ToggleLinkResponse$json = {
  '1': 'ToggleLinkResponse',
  '2': [
    {
      '1': 'item',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.commerce.v1.LinkItem',
      '10': 'item'
    },
  ],
};

/// Descriptor for `ToggleLinkResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List toggleLinkResponseDescriptor = $convert.base64Decode(
    'ChJUb2dnbGVMaW5rUmVzcG9uc2USNQoEaXRlbRgBIAEoCzIhLmNyZWF0aXZhbnRhLmNvbW1lcm'
    'NlLnYxLkxpbmtJdGVtUgRpdGVt');

@$core.Deprecated('Use updateThemeRequestDescriptor instead')
const UpdateThemeRequest$json = {
  '1': 'UpdateThemeRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'page_id', '3': 2, '4': 1, '5': 9, '10': 'pageId'},
    {'1': 'theme', '3': 3, '4': 1, '5': 9, '10': 'theme'},
    {'1': 'custom_css', '3': 4, '4': 1, '5': 9, '10': 'customCss'},
  ],
};

/// Descriptor for `UpdateThemeRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateThemeRequestDescriptor = $convert.base64Decode(
    'ChJVcGRhdGVUaGVtZVJlcXVlc3QSIQoMd29ya3NwYWNlX2lkGAEgASgJUgt3b3Jrc3BhY2VJZB'
    'IXCgdwYWdlX2lkGAIgASgJUgZwYWdlSWQSFAoFdGhlbWUYAyABKAlSBXRoZW1lEh0KCmN1c3Rv'
    'bV9jc3MYBCABKAlSCWN1c3RvbUNzcw==');

@$core.Deprecated('Use updateThemeResponseDescriptor instead')
const UpdateThemeResponse$json = {
  '1': 'UpdateThemeResponse',
  '2': [
    {
      '1': 'page',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.commerce.v1.LinkInBioPage',
      '10': 'page'
    },
  ],
};

/// Descriptor for `UpdateThemeResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateThemeResponseDescriptor = $convert.base64Decode(
    'ChNVcGRhdGVUaGVtZVJlc3BvbnNlEjoKBHBhZ2UYASABKAsyJi5jcmVhdGl2YW50YS5jb21tZX'
    'JjZS52MS5MaW5rSW5CaW9QYWdlUgRwYWdl');

@$core.Deprecated('Use scanLinkRequestDescriptor instead')
const ScanLinkRequest$json = {
  '1': 'ScanLinkRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'url', '3': 2, '4': 1, '5': 9, '10': 'url'},
  ],
};

/// Descriptor for `ScanLinkRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List scanLinkRequestDescriptor = $convert.base64Decode(
    'Cg9TY2FuTGlua1JlcXVlc3QSIQoMd29ya3NwYWNlX2lkGAEgASgJUgt3b3Jrc3BhY2VJZBIQCg'
    'N1cmwYAiABKAlSA3VybA==');

@$core.Deprecated('Use scanLinkResponseDescriptor instead')
const ScanLinkResponse$json = {
  '1': 'ScanLinkResponse',
  '2': [
    {'1': 'url', '3': 1, '4': 1, '5': 9, '10': 'url'},
    {
      '1': 'scan_status',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.creativanta.commerce.v1.LinkSecurityScanStatus',
      '10': 'scanStatus'
    },
    {
      '1': 'phishing_detected',
      '3': 3,
      '4': 1,
      '5': 8,
      '10': 'phishingDetected'
    },
    {'1': 'threat_details', '3': 4, '4': 1, '5': 9, '10': 'threatDetails'},
    {'1': 'can_be_published', '3': 5, '4': 1, '5': 8, '10': 'canBePublished'},
  ],
};

/// Descriptor for `ScanLinkResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List scanLinkResponseDescriptor = $convert.base64Decode(
    'ChBTY2FuTGlua1Jlc3BvbnNlEhAKA3VybBgBIAEoCVIDdXJsElAKC3NjYW5fc3RhdHVzGAIgAS'
    'gOMi8uY3JlYXRpdmFudGEuY29tbWVyY2UudjEuTGlua1NlY3VyaXR5U2NhblN0YXR1c1IKc2Nh'
    'blN0YXR1cxIrChFwaGlzaGluZ19kZXRlY3RlZBgDIAEoCFIQcGhpc2hpbmdEZXRlY3RlZBIlCg'
    '50aHJlYXRfZGV0YWlscxgEIAEoCVINdGhyZWF0RGV0YWlscxIoChBjYW5fYmVfcHVibGlzaGVk'
    'GAUgASgIUg5jYW5CZVB1Ymxpc2hlZA==');

@$core.Deprecated('Use reportLinkRequestDescriptor instead')
const ReportLinkRequest$json = {
  '1': 'ReportLinkRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'link_item_id', '3': 2, '4': 1, '5': 9, '10': 'linkItemId'},
    {'1': 'reason', '3': 3, '4': 1, '5': 9, '10': 'reason'},
    {'1': 'reporter_email', '3': 4, '4': 1, '5': 9, '10': 'reporterEmail'},
  ],
};

/// Descriptor for `ReportLinkRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List reportLinkRequestDescriptor = $convert.base64Decode(
    'ChFSZXBvcnRMaW5rUmVxdWVzdBIhCgx3b3Jrc3BhY2VfaWQYASABKAlSC3dvcmtzcGFjZUlkEi'
    'AKDGxpbmtfaXRlbV9pZBgCIAEoCVIKbGlua0l0ZW1JZBIWCgZyZWFzb24YAyABKAlSBnJlYXNv'
    'bhIlCg5yZXBvcnRlcl9lbWFpbBgEIAEoCVINcmVwb3J0ZXJFbWFpbA==');

@$core.Deprecated('Use reportLinkResponseDescriptor instead')
const ReportLinkResponse$json = {
  '1': 'ReportLinkResponse',
  '2': [
    {'1': 'accepted', '3': 1, '4': 1, '5': 8, '10': 'accepted'},
    {'1': 'incident_id', '3': 2, '4': 1, '5': 9, '10': 'incidentId'},
  ],
};

/// Descriptor for `ReportLinkResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List reportLinkResponseDescriptor = $convert.base64Decode(
    'ChJSZXBvcnRMaW5rUmVzcG9uc2USGgoIYWNjZXB0ZWQYASABKAhSCGFjY2VwdGVkEh8KC2luY2'
    'lkZW50X2lkGAIgASgJUgppbmNpZGVudElk');

@$core.Deprecated('Use verifyCustomDomainRequestDescriptor instead')
const VerifyCustomDomainRequest$json = {
  '1': 'VerifyCustomDomainRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'page_id', '3': 2, '4': 1, '5': 9, '10': 'pageId'},
    {'1': 'custom_domain', '3': 3, '4': 1, '5': 9, '10': 'customDomain'},
  ],
};

/// Descriptor for `VerifyCustomDomainRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List verifyCustomDomainRequestDescriptor = $convert.base64Decode(
    'ChlWZXJpZnlDdXN0b21Eb21haW5SZXF1ZXN0EiEKDHdvcmtzcGFjZV9pZBgBIAEoCVILd29ya3'
    'NwYWNlSWQSFwoHcGFnZV9pZBgCIAEoCVIGcGFnZUlkEiMKDWN1c3RvbV9kb21haW4YAyABKAlS'
    'DGN1c3RvbURvbWFpbg==');

@$core.Deprecated('Use verifyCustomDomainResponseDescriptor instead')
const VerifyCustomDomainResponse$json = {
  '1': 'VerifyCustomDomainResponse',
  '2': [
    {'1': 'verified', '3': 1, '4': 1, '5': 8, '10': 'verified'},
    {'1': 'status_message', '3': 2, '4': 1, '5': 9, '10': 'statusMessage'},
    {'1': 'ssl_provisioned', '3': 3, '4': 1, '5': 8, '10': 'sslProvisioned'},
  ],
};

/// Descriptor for `VerifyCustomDomainResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List verifyCustomDomainResponseDescriptor =
    $convert.base64Decode(
        'ChpWZXJpZnlDdXN0b21Eb21haW5SZXNwb25zZRIaCgh2ZXJpZmllZBgBIAEoCFIIdmVyaWZpZW'
        'QSJQoOc3RhdHVzX21lc3NhZ2UYAiABKAlSDXN0YXR1c01lc3NhZ2USJwoPc3NsX3Byb3Zpc2lv'
        'bmVkGAMgASgIUg5zc2xQcm92aXNpb25lZA==');

@$core.Deprecated('Use mediaKitServiceGenerateRequestDescriptor instead')
const MediaKitServiceGenerateRequest$json = {
  '1': 'MediaKitServiceGenerateRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'template', '3': 2, '4': 1, '5': 9, '10': 'template'},
    {'1': 'brand_profile_id', '3': 3, '4': 1, '5': 9, '10': 'brandProfileId'},
  ],
};

/// Descriptor for `MediaKitServiceGenerateRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List mediaKitServiceGenerateRequestDescriptor =
    $convert.base64Decode(
        'Ch5NZWRpYUtpdFNlcnZpY2VHZW5lcmF0ZVJlcXVlc3QSIQoMd29ya3NwYWNlX2lkGAEgASgJUg'
        't3b3Jrc3BhY2VJZBIaCgh0ZW1wbGF0ZRgCIAEoCVIIdGVtcGxhdGUSKAoQYnJhbmRfcHJvZmls'
        'ZV9pZBgDIAEoCVIOYnJhbmRQcm9maWxlSWQ=');

@$core.Deprecated('Use mediaKitServiceGenerateResponseDescriptor instead')
const MediaKitServiceGenerateResponse$json = {
  '1': 'MediaKitServiceGenerateResponse',
  '2': [
    {
      '1': 'media_kit',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.commerce.v1.MediaKit',
      '10': 'mediaKit'
    },
  ],
};

/// Descriptor for `MediaKitServiceGenerateResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List mediaKitServiceGenerateResponseDescriptor =
    $convert.base64Decode(
        'Ch9NZWRpYUtpdFNlcnZpY2VHZW5lcmF0ZVJlc3BvbnNlEj4KCW1lZGlhX2tpdBgBIAEoCzIhLm'
        'NyZWF0aXZhbnRhLmNvbW1lcmNlLnYxLk1lZGlhS2l0UghtZWRpYUtpdA==');

@$core.Deprecated('Use mediaKitServiceGetRequestDescriptor instead')
const MediaKitServiceGetRequest$json = {
  '1': 'MediaKitServiceGetRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'media_kit_id', '3': 2, '4': 1, '5': 9, '10': 'mediaKitId'},
  ],
};

/// Descriptor for `MediaKitServiceGetRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List mediaKitServiceGetRequestDescriptor =
    $convert.base64Decode(
        'ChlNZWRpYUtpdFNlcnZpY2VHZXRSZXF1ZXN0EiEKDHdvcmtzcGFjZV9pZBgBIAEoCVILd29ya3'
        'NwYWNlSWQSIAoMbWVkaWFfa2l0X2lkGAIgASgJUgptZWRpYUtpdElk');

@$core.Deprecated('Use mediaKitServiceGetResponseDescriptor instead')
const MediaKitServiceGetResponse$json = {
  '1': 'MediaKitServiceGetResponse',
  '2': [
    {
      '1': 'media_kit',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.commerce.v1.MediaKit',
      '10': 'mediaKit'
    },
  ],
};

/// Descriptor for `MediaKitServiceGetResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List mediaKitServiceGetResponseDescriptor =
    $convert.base64Decode(
        'ChpNZWRpYUtpdFNlcnZpY2VHZXRSZXNwb25zZRI+CgltZWRpYV9raXQYASABKAsyIS5jcmVhdG'
        'l2YW50YS5jb21tZXJjZS52MS5NZWRpYUtpdFIIbWVkaWFLaXQ=');

@$core.Deprecated('Use getKitRequestDescriptor instead')
const GetKitRequest$json = {
  '1': 'GetKitRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'media_kit_id', '3': 2, '4': 1, '5': 9, '10': 'mediaKitId'},
  ],
};

/// Descriptor for `GetKitRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getKitRequestDescriptor = $convert.base64Decode(
    'Cg1HZXRLaXRSZXF1ZXN0EiEKDHdvcmtzcGFjZV9pZBgBIAEoCVILd29ya3NwYWNlSWQSIAoMbW'
    'VkaWFfa2l0X2lkGAIgASgJUgptZWRpYUtpdElk');

@$core.Deprecated('Use getKitResponseDescriptor instead')
const GetKitResponse$json = {
  '1': 'GetKitResponse',
  '2': [
    {
      '1': 'media_kit',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.commerce.v1.MediaKit',
      '10': 'mediaKit'
    },
  ],
};

/// Descriptor for `GetKitResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getKitResponseDescriptor = $convert.base64Decode(
    'Cg5HZXRLaXRSZXNwb25zZRI+CgltZWRpYV9raXQYASABKAsyIS5jcmVhdGl2YW50YS5jb21tZX'
    'JjZS52MS5NZWRpYUtpdFIIbWVkaWFLaXQ=');

@$core.Deprecated('Use mediaKitServiceExportRequestDescriptor instead')
const MediaKitServiceExportRequest$json = {
  '1': 'MediaKitServiceExportRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'media_kit_id', '3': 2, '4': 1, '5': 9, '10': 'mediaKitId'},
    {'1': 'format', '3': 3, '4': 1, '5': 9, '10': 'format'},
  ],
};

/// Descriptor for `MediaKitServiceExportRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List mediaKitServiceExportRequestDescriptor =
    $convert.base64Decode(
        'ChxNZWRpYUtpdFNlcnZpY2VFeHBvcnRSZXF1ZXN0EiEKDHdvcmtzcGFjZV9pZBgBIAEoCVILd2'
        '9ya3NwYWNlSWQSIAoMbWVkaWFfa2l0X2lkGAIgASgJUgptZWRpYUtpdElkEhYKBmZvcm1hdBgD'
        'IAEoCVIGZm9ybWF0');

@$core.Deprecated('Use mediaKitServiceExportResponseDescriptor instead')
const MediaKitServiceExportResponse$json = {
  '1': 'MediaKitServiceExportResponse',
  '2': [
    {'1': 'export_url', '3': 1, '4': 1, '5': 9, '10': 'exportUrl'},
    {'1': 'file_name', '3': 2, '4': 1, '5': 9, '10': 'fileName'},
  ],
};

/// Descriptor for `MediaKitServiceExportResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List mediaKitServiceExportResponseDescriptor =
    $convert.base64Decode(
        'Ch1NZWRpYUtpdFNlcnZpY2VFeHBvcnRSZXNwb25zZRIdCgpleHBvcnRfdXJsGAEgASgJUglleH'
        'BvcnRVcmwSGwoJZmlsZV9uYW1lGAIgASgJUghmaWxlTmFtZQ==');

@$core.Deprecated('Use publicRateItemDescriptor instead')
const PublicRateItem$json = {
  '1': 'PublicRateItem',
  '2': [
    {'1': 'service_type', '3': 1, '4': 1, '5': 9, '10': 'serviceType'},
    {'1': 'amount', '3': 2, '4': 1, '5': 9, '10': 'amount'},
    {'1': 'currency', '3': 3, '4': 1, '5': 9, '10': 'currency'},
  ],
};

/// Descriptor for `PublicRateItem`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List publicRateItemDescriptor = $convert.base64Decode(
    'Cg5QdWJsaWNSYXRlSXRlbRIhCgxzZXJ2aWNlX3R5cGUYASABKAlSC3NlcnZpY2VUeXBlEhYKBm'
    'Ftb3VudBgCIAEoCVIGYW1vdW50EhoKCGN1cnJlbmN5GAMgASgJUghjdXJyZW5jeQ==');

@$core.Deprecated('Use publicCreatorProfileDescriptor instead')
const PublicCreatorProfile$json = {
  '1': 'PublicCreatorProfile',
  '2': [
    {'1': 'display_name', '3': 1, '4': 1, '5': 9, '10': 'displayName'},
    {'1': 'bio', '3': 2, '4': 1, '5': 9, '10': 'bio'},
    {'1': 'categories', '3': 3, '4': 3, '5': 9, '10': 'categories'},
    {'1': 'languages', '3': 4, '4': 3, '5': 9, '10': 'languages'},
    {'1': 'portfolio_urls', '3': 5, '4': 3, '5': 9, '10': 'portfolioUrls'},
    {
      '1': 'public_rates',
      '3': 6,
      '4': 3,
      '5': 11,
      '6': '.creativanta.commerce.v1.PublicRateItem',
      '10': 'publicRates'
    },
  ],
};

/// Descriptor for `PublicCreatorProfile`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List publicCreatorProfileDescriptor = $convert.base64Decode(
    'ChRQdWJsaWNDcmVhdG9yUHJvZmlsZRIhCgxkaXNwbGF5X25hbWUYASABKAlSC2Rpc3BsYXlOYW'
    '1lEhAKA2JpbxgCIAEoCVIDYmlvEh4KCmNhdGVnb3JpZXMYAyADKAlSCmNhdGVnb3JpZXMSHAoJ'
    'bGFuZ3VhZ2VzGAQgAygJUglsYW5ndWFnZXMSJQoOcG9ydGZvbGlvX3VybHMYBSADKAlSDXBvcn'
    'Rmb2xpb1VybHMSSgoMcHVibGljX3JhdGVzGAYgAygLMicuY3JlYXRpdmFudGEuY29tbWVyY2Uu'
    'djEuUHVibGljUmF0ZUl0ZW1SC3B1YmxpY1JhdGVz');

@$core.Deprecated('Use setDirectoryProfileRequestDescriptor instead')
const SetDirectoryProfileRequest$json = {
  '1': 'SetDirectoryProfileRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'media_kit_id', '3': 2, '4': 1, '5': 9, '10': 'mediaKitId'},
    {'1': 'directory_opt_in', '3': 3, '4': 1, '5': 8, '10': 'directoryOptIn'},
    {
      '1': 'directory_profile_json',
      '3': 4,
      '4': 1,
      '5': 9,
      '10': 'directoryProfileJson'
    },
    {
      '1': 'profile',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.creativanta.commerce.v1.PublicCreatorProfile',
      '10': 'profile'
    },
  ],
};

/// Descriptor for `SetDirectoryProfileRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List setDirectoryProfileRequestDescriptor = $convert.base64Decode(
    'ChpTZXREaXJlY3RvcnlQcm9maWxlUmVxdWVzdBIhCgx3b3Jrc3BhY2VfaWQYASABKAlSC3dvcm'
    'tzcGFjZUlkEiAKDG1lZGlhX2tpdF9pZBgCIAEoCVIKbWVkaWFLaXRJZBIoChBkaXJlY3Rvcnlf'
    'b3B0X2luGAMgASgIUg5kaXJlY3RvcnlPcHRJbhI0ChZkaXJlY3RvcnlfcHJvZmlsZV9qc29uGA'
    'QgASgJUhRkaXJlY3RvcnlQcm9maWxlSnNvbhJHCgdwcm9maWxlGAUgASgLMi0uY3JlYXRpdmFu'
    'dGEuY29tbWVyY2UudjEuUHVibGljQ3JlYXRvclByb2ZpbGVSB3Byb2ZpbGU=');

@$core.Deprecated('Use setDirectoryProfileResponseDescriptor instead')
const SetDirectoryProfileResponse$json = {
  '1': 'SetDirectoryProfileResponse',
  '2': [
    {
      '1': 'media_kit',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.commerce.v1.MediaKit',
      '10': 'mediaKit'
    },
    {'1': 'media_kit_id', '3': 2, '4': 1, '5': 9, '10': 'mediaKitId'},
    {
      '1': 'directory_status',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.creativanta.commerce.v1.MediaKitDirectoryStatus',
      '10': 'directoryStatus'
    },
  ],
};

/// Descriptor for `SetDirectoryProfileResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List setDirectoryProfileResponseDescriptor = $convert.base64Decode(
    'ChtTZXREaXJlY3RvcnlQcm9maWxlUmVzcG9uc2USPgoJbWVkaWFfa2l0GAEgASgLMiEuY3JlYX'
    'RpdmFudGEuY29tbWVyY2UudjEuTWVkaWFLaXRSCG1lZGlhS2l0EiAKDG1lZGlhX2tpdF9pZBgC'
    'IAEoCVIKbWVkaWFLaXRJZBJbChBkaXJlY3Rvcnlfc3RhdHVzGAMgASgOMjAuY3JlYXRpdmFudG'
    'EuY29tbWVyY2UudjEuTWVkaWFLaXREaXJlY3RvcnlTdGF0dXNSD2RpcmVjdG9yeVN0YXR1cw==');

@$core.Deprecated('Use rateCardServiceCreateRequestDescriptor instead')
const RateCardServiceCreateRequest$json = {
  '1': 'RateCardServiceCreateRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'currency', '3': 2, '4': 1, '5': 9, '10': 'currency'},
    {'1': 'custom_note', '3': 3, '4': 1, '5': 9, '10': 'customNote'},
    {
      '1': 'items',
      '3': 4,
      '4': 3,
      '5': 11,
      '6': '.creativanta.commerce.v1.RateCardItem',
      '10': 'items'
    },
  ],
};

/// Descriptor for `RateCardServiceCreateRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List rateCardServiceCreateRequestDescriptor = $convert.base64Decode(
    'ChxSYXRlQ2FyZFNlcnZpY2VDcmVhdGVSZXF1ZXN0EiEKDHdvcmtzcGFjZV9pZBgBIAEoCVILd2'
    '9ya3NwYWNlSWQSGgoIY3VycmVuY3kYAiABKAlSCGN1cnJlbmN5Eh8KC2N1c3RvbV9ub3RlGAMg'
    'ASgJUgpjdXN0b21Ob3RlEjsKBWl0ZW1zGAQgAygLMiUuY3JlYXRpdmFudGEuY29tbWVyY2Uudj'
    'EuUmF0ZUNhcmRJdGVtUgVpdGVtcw==');

@$core.Deprecated('Use rateCardServiceCreateResponseDescriptor instead')
const RateCardServiceCreateResponse$json = {
  '1': 'RateCardServiceCreateResponse',
  '2': [
    {
      '1': 'rate_card',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.commerce.v1.RateCard',
      '10': 'rateCard'
    },
  ],
};

/// Descriptor for `RateCardServiceCreateResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List rateCardServiceCreateResponseDescriptor =
    $convert.base64Decode(
        'Ch1SYXRlQ2FyZFNlcnZpY2VDcmVhdGVSZXNwb25zZRI+CglyYXRlX2NhcmQYASABKAsyIS5jcm'
        'VhdGl2YW50YS5jb21tZXJjZS52MS5SYXRlQ2FyZFIIcmF0ZUNhcmQ=');

@$core.Deprecated('Use getRateCardRequestDescriptor instead')
const GetRateCardRequest$json = {
  '1': 'GetRateCardRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'rate_card_id', '3': 2, '4': 1, '5': 9, '10': 'rateCardId'},
  ],
};

/// Descriptor for `GetRateCardRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getRateCardRequestDescriptor = $convert.base64Decode(
    'ChJHZXRSYXRlQ2FyZFJlcXVlc3QSIQoMd29ya3NwYWNlX2lkGAEgASgJUgt3b3Jrc3BhY2VJZB'
    'IgCgxyYXRlX2NhcmRfaWQYAiABKAlSCnJhdGVDYXJkSWQ=');

@$core.Deprecated('Use getRateCardResponseDescriptor instead')
const GetRateCardResponse$json = {
  '1': 'GetRateCardResponse',
  '2': [
    {
      '1': 'rate_card',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.commerce.v1.RateCard',
      '10': 'rateCard'
    },
  ],
};

/// Descriptor for `GetRateCardResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getRateCardResponseDescriptor = $convert.base64Decode(
    'ChNHZXRSYXRlQ2FyZFJlc3BvbnNlEj4KCXJhdGVfY2FyZBgBIAEoCzIhLmNyZWF0aXZhbnRhLm'
    'NvbW1lcmNlLnYxLlJhdGVDYXJkUghyYXRlQ2FyZA==');

@$core.Deprecated('Use rateCardServiceListRequestDescriptor instead')
const RateCardServiceListRequest$json = {
  '1': 'RateCardServiceListRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
  ],
};

/// Descriptor for `RateCardServiceListRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List rateCardServiceListRequestDescriptor =
    $convert.base64Decode(
        'ChpSYXRlQ2FyZFNlcnZpY2VMaXN0UmVxdWVzdBIhCgx3b3Jrc3BhY2VfaWQYASABKAlSC3dvcm'
        'tzcGFjZUlk');

@$core.Deprecated('Use rateCardServiceListResponseDescriptor instead')
const RateCardServiceListResponse$json = {
  '1': 'RateCardServiceListResponse',
  '2': [
    {
      '1': 'rate_cards',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.creativanta.commerce.v1.RateCard',
      '10': 'rateCards'
    },
  ],
};

/// Descriptor for `RateCardServiceListResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List rateCardServiceListResponseDescriptor =
    $convert.base64Decode(
        'ChtSYXRlQ2FyZFNlcnZpY2VMaXN0UmVzcG9uc2USQAoKcmF0ZV9jYXJkcxgBIAMoCzIhLmNyZW'
        'F0aXZhbnRhLmNvbW1lcmNlLnYxLlJhdGVDYXJkUglyYXRlQ2FyZHM=');

@$core.Deprecated('Use rateCardServiceSaveRequestDescriptor instead')
const RateCardServiceSaveRequest$json = {
  '1': 'RateCardServiceSaveRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'rate_card_id', '3': 2, '4': 1, '5': 9, '10': 'rateCardId'},
    {'1': 'currency', '3': 3, '4': 1, '5': 9, '10': 'currency'},
    {'1': 'custom_note', '3': 4, '4': 1, '5': 9, '10': 'customNote'},
    {
      '1': 'items',
      '3': 5,
      '4': 3,
      '5': 11,
      '6': '.creativanta.commerce.v1.RateCardItem',
      '10': 'items'
    },
  ],
};

/// Descriptor for `RateCardServiceSaveRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List rateCardServiceSaveRequestDescriptor = $convert.base64Decode(
    'ChpSYXRlQ2FyZFNlcnZpY2VTYXZlUmVxdWVzdBIhCgx3b3Jrc3BhY2VfaWQYASABKAlSC3dvcm'
    'tzcGFjZUlkEiAKDHJhdGVfY2FyZF9pZBgCIAEoCVIKcmF0ZUNhcmRJZBIaCghjdXJyZW5jeRgD'
    'IAEoCVIIY3VycmVuY3kSHwoLY3VzdG9tX25vdGUYBCABKAlSCmN1c3RvbU5vdGUSOwoFaXRlbX'
    'MYBSADKAsyJS5jcmVhdGl2YW50YS5jb21tZXJjZS52MS5SYXRlQ2FyZEl0ZW1SBWl0ZW1z');

@$core.Deprecated('Use rateCardServiceSaveResponseDescriptor instead')
const RateCardServiceSaveResponse$json = {
  '1': 'RateCardServiceSaveResponse',
  '2': [
    {
      '1': 'rate_card',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.commerce.v1.RateCard',
      '10': 'rateCard'
    },
  ],
};

/// Descriptor for `RateCardServiceSaveResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List rateCardServiceSaveResponseDescriptor =
    $convert.base64Decode(
        'ChtSYXRlQ2FyZFNlcnZpY2VTYXZlUmVzcG9uc2USPgoJcmF0ZV9jYXJkGAEgASgLMiEuY3JlYX'
        'RpdmFudGEuY29tbWVyY2UudjEuUmF0ZUNhcmRSCHJhdGVDYXJk');

@$core.Deprecated('Use rateCardServiceDeleteItemRequestDescriptor instead')
const RateCardServiceDeleteItemRequest$json = {
  '1': 'RateCardServiceDeleteItemRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'item_id', '3': 2, '4': 1, '5': 9, '10': 'itemId'},
  ],
};

/// Descriptor for `RateCardServiceDeleteItemRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List rateCardServiceDeleteItemRequestDescriptor =
    $convert.base64Decode(
        'CiBSYXRlQ2FyZFNlcnZpY2VEZWxldGVJdGVtUmVxdWVzdBIhCgx3b3Jrc3BhY2VfaWQYASABKA'
        'lSC3dvcmtzcGFjZUlkEhcKB2l0ZW1faWQYAiABKAlSBml0ZW1JZA==');

@$core.Deprecated('Use rateCardServiceDeleteItemResponseDescriptor instead')
const RateCardServiceDeleteItemResponse$json = {
  '1': 'RateCardServiceDeleteItemResponse',
  '2': [
    {'1': 'deleted', '3': 1, '4': 1, '5': 8, '10': 'deleted'},
  ],
};

/// Descriptor for `RateCardServiceDeleteItemResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List rateCardServiceDeleteItemResponseDescriptor =
    $convert.base64Decode(
        'CiFSYXRlQ2FyZFNlcnZpY2VEZWxldGVJdGVtUmVzcG9uc2USGAoHZGVsZXRlZBgBIAEoCFIHZG'
        'VsZXRlZA==');

@$core.Deprecated('Use rateCardServiceReorderRequestDescriptor instead')
const RateCardServiceReorderRequest$json = {
  '1': 'RateCardServiceReorderRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'rate_card_id', '3': 2, '4': 1, '5': 9, '10': 'rateCardId'},
    {'1': 'item_ids_in_order', '3': 3, '4': 3, '5': 9, '10': 'itemIdsInOrder'},
  ],
};

/// Descriptor for `RateCardServiceReorderRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List rateCardServiceReorderRequestDescriptor =
    $convert.base64Decode(
        'Ch1SYXRlQ2FyZFNlcnZpY2VSZW9yZGVyUmVxdWVzdBIhCgx3b3Jrc3BhY2VfaWQYASABKAlSC3'
        'dvcmtzcGFjZUlkEiAKDHJhdGVfY2FyZF9pZBgCIAEoCVIKcmF0ZUNhcmRJZBIpChFpdGVtX2lk'
        'c19pbl9vcmRlchgDIAMoCVIOaXRlbUlkc0luT3JkZXI=');

@$core.Deprecated('Use rateCardServiceReorderResponseDescriptor instead')
const RateCardServiceReorderResponse$json = {
  '1': 'RateCardServiceReorderResponse',
  '2': [
    {
      '1': 'items',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.creativanta.commerce.v1.RateCardItem',
      '10': 'items'
    },
  ],
};

/// Descriptor for `RateCardServiceReorderResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List rateCardServiceReorderResponseDescriptor =
    $convert.base64Decode(
        'Ch5SYXRlQ2FyZFNlcnZpY2VSZW9yZGVyUmVzcG9uc2USOwoFaXRlbXMYASADKAsyJS5jcmVhdG'
        'l2YW50YS5jb21tZXJjZS52MS5SYXRlQ2FyZEl0ZW1SBWl0ZW1z');

@$core.Deprecated('Use compareScopeRequestDescriptor instead')
const CompareScopeRequest$json = {
  '1': 'CompareScopeRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'service_type', '3': 2, '4': 1, '5': 9, '10': 'serviceType'},
  ],
};

/// Descriptor for `CompareScopeRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List compareScopeRequestDescriptor = $convert.base64Decode(
    'ChNDb21wYXJlU2NvcGVSZXF1ZXN0EiEKDHdvcmtzcGFjZV9pZBgBIAEoCVILd29ya3NwYWNlSW'
    'QSIQoMc2VydmljZV90eXBlGAIgASgJUgtzZXJ2aWNlVHlwZQ==');

@$core.Deprecated('Use compareScopeResponseDescriptor instead')
const CompareScopeResponse$json = {
  '1': 'CompareScopeResponse',
  '2': [
    {'1': 'service_type', '3': 1, '4': 1, '5': 9, '10': 'serviceType'},
    {'1': 'benchmark_min', '3': 2, '4': 1, '5': 1, '10': 'benchmarkMin'},
    {'1': 'benchmark_avg', '3': 3, '4': 1, '5': 1, '10': 'benchmarkAvg'},
    {'1': 'benchmark_max', '3': 4, '4': 1, '5': 1, '10': 'benchmarkMax'},
    {'1': 'currency', '3': 5, '4': 1, '5': 9, '10': 'currency'},
  ],
};

/// Descriptor for `CompareScopeResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List compareScopeResponseDescriptor = $convert.base64Decode(
    'ChRDb21wYXJlU2NvcGVSZXNwb25zZRIhCgxzZXJ2aWNlX3R5cGUYASABKAlSC3NlcnZpY2VUeX'
    'BlEiMKDWJlbmNobWFya19taW4YAiABKAFSDGJlbmNobWFya01pbhIjCg1iZW5jaG1hcmtfYXZn'
    'GAMgASgBUgxiZW5jaG1hcmtBdmcSIwoNYmVuY2htYXJrX21heBgEIAEoAVIMYmVuY2htYXJrTW'
    'F4EhoKCGN1cnJlbmN5GAUgASgJUghjdXJyZW5jeQ==');

@$core.Deprecated('Use rateCardServiceAISuggestRequestDescriptor instead')
const RateCardServiceAISuggestRequest$json = {
  '1': 'RateCardServiceAISuggestRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'platform', '3': 2, '4': 1, '5': 9, '10': 'platform'},
    {'1': 'service_type', '3': 3, '4': 1, '5': 9, '10': 'serviceType'},
  ],
};

/// Descriptor for `RateCardServiceAISuggestRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List rateCardServiceAISuggestRequestDescriptor =
    $convert.base64Decode(
        'Ch9SYXRlQ2FyZFNlcnZpY2VBSVN1Z2dlc3RSZXF1ZXN0EiEKDHdvcmtzcGFjZV9pZBgBIAEoCV'
        'ILd29ya3NwYWNlSWQSGgoIcGxhdGZvcm0YAiABKAlSCHBsYXRmb3JtEiEKDHNlcnZpY2VfdHlw'
        'ZRgDIAEoCVILc2VydmljZVR5cGU=');

@$core.Deprecated('Use rateCardServiceAISuggestResponseDescriptor instead')
const RateCardServiceAISuggestResponse$json = {
  '1': 'RateCardServiceAISuggestResponse',
  '2': [
    {'1': 'suggested_price', '3': 1, '4': 1, '5': 1, '10': 'suggestedPrice'},
    {'1': 'price_range_low', '3': 2, '4': 1, '5': 1, '10': 'priceRangeLow'},
    {'1': 'price_range_high', '3': 3, '4': 1, '5': 1, '10': 'priceRangeHigh'},
    {'1': 'rationale', '3': 4, '4': 1, '5': 9, '10': 'rationale'},
    {'1': 'currency', '3': 5, '4': 1, '5': 9, '10': 'currency'},
  ],
};

/// Descriptor for `RateCardServiceAISuggestResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List rateCardServiceAISuggestResponseDescriptor =
    $convert.base64Decode(
        'CiBSYXRlQ2FyZFNlcnZpY2VBSVN1Z2dlc3RSZXNwb25zZRInCg9zdWdnZXN0ZWRfcHJpY2UYAS'
        'ABKAFSDnN1Z2dlc3RlZFByaWNlEiYKD3ByaWNlX3JhbmdlX2xvdxgCIAEoAVINcHJpY2VSYW5n'
        'ZUxvdxIoChBwcmljZV9yYW5nZV9oaWdoGAMgASgBUg5wcmljZVJhbmdlSGlnaBIcCglyYXRpb2'
        '5hbGUYBCABKAlSCXJhdGlvbmFsZRIaCghjdXJyZW5jeRgFIAEoCVIIY3VycmVuY3k=');

@$core.Deprecated('Use brandDealServiceCreateRequestDescriptor instead')
const BrandDealServiceCreateRequest$json = {
  '1': 'BrandDealServiceCreateRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'brand_name', '3': 2, '4': 1, '5': 9, '10': 'brandName'},
    {'1': 'contact_email', '3': 3, '4': 1, '5': 9, '10': 'contactEmail'},
    {
      '1': 'deal_type',
      '3': 4,
      '4': 1,
      '5': 14,
      '6': '.creativanta.commerce.v1.BrandDealType',
      '10': 'dealType'
    },
    {'1': 'value', '3': 5, '4': 1, '5': 1, '10': 'value'},
    {'1': 'currency', '3': 6, '4': 1, '5': 9, '10': 'currency'},
    {'1': 'deadline', '3': 7, '4': 1, '5': 9, '10': 'deadline'},
    {'1': 'deliverables', '3': 8, '4': 1, '5': 9, '10': 'deliverables'},
    {'1': 'inquiry_thread_id', '3': 9, '4': 1, '5': 9, '10': 'inquiryThreadId'},
    {'1': 'notes', '3': 10, '4': 1, '5': 9, '10': 'notes'},
  ],
};

/// Descriptor for `BrandDealServiceCreateRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List brandDealServiceCreateRequestDescriptor = $convert.base64Decode(
    'Ch1CcmFuZERlYWxTZXJ2aWNlQ3JlYXRlUmVxdWVzdBIhCgx3b3Jrc3BhY2VfaWQYASABKAlSC3'
    'dvcmtzcGFjZUlkEh0KCmJyYW5kX25hbWUYAiABKAlSCWJyYW5kTmFtZRIjCg1jb250YWN0X2Vt'
    'YWlsGAMgASgJUgxjb250YWN0RW1haWwSQwoJZGVhbF90eXBlGAQgASgOMiYuY3JlYXRpdmFudG'
    'EuY29tbWVyY2UudjEuQnJhbmREZWFsVHlwZVIIZGVhbFR5cGUSFAoFdmFsdWUYBSABKAFSBXZh'
    'bHVlEhoKCGN1cnJlbmN5GAYgASgJUghjdXJyZW5jeRIaCghkZWFkbGluZRgHIAEoCVIIZGVhZG'
    'xpbmUSIgoMZGVsaXZlcmFibGVzGAggASgJUgxkZWxpdmVyYWJsZXMSKgoRaW5xdWlyeV90aHJl'
    'YWRfaWQYCSABKAlSD2lucXVpcnlUaHJlYWRJZBIUCgVub3RlcxgKIAEoCVIFbm90ZXM=');

@$core.Deprecated('Use brandDealServiceCreateResponseDescriptor instead')
const BrandDealServiceCreateResponse$json = {
  '1': 'BrandDealServiceCreateResponse',
  '2': [
    {
      '1': 'deal',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.commerce.v1.BrandDeal',
      '10': 'deal'
    },
  ],
};

/// Descriptor for `BrandDealServiceCreateResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List brandDealServiceCreateResponseDescriptor =
    $convert.base64Decode(
        'Ch5CcmFuZERlYWxTZXJ2aWNlQ3JlYXRlUmVzcG9uc2USNgoEZGVhbBgBIAEoCzIiLmNyZWF0aX'
        'ZhbnRhLmNvbW1lcmNlLnYxLkJyYW5kRGVhbFIEZGVhbA==');

@$core.Deprecated('Use brandDealServiceUpdateStatusRequestDescriptor instead')
const BrandDealServiceUpdateStatusRequest$json = {
  '1': 'BrandDealServiceUpdateStatusRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'deal_id', '3': 2, '4': 1, '5': 9, '10': 'dealId'},
    {
      '1': 'target_status',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.creativanta.commerce.v1.BrandDealStatus',
      '10': 'targetStatus'
    },
    {
      '1': 'cancellation_reason',
      '3': 4,
      '4': 1,
      '5': 9,
      '10': 'cancellationReason'
    },
    {
      '1': 'requires_financial_reversal',
      '3': 5,
      '4': 1,
      '5': 8,
      '10': 'requiresFinancialReversal'
    },
    {
      '1': 'expected_updated_at',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'expectedUpdatedAt'
    },
    {'1': 'idempotency_key', '3': 7, '4': 1, '5': 9, '10': 'idempotencyKey'},
  ],
};

/// Descriptor for `BrandDealServiceUpdateStatusRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List brandDealServiceUpdateStatusRequestDescriptor = $convert.base64Decode(
    'CiNCcmFuZERlYWxTZXJ2aWNlVXBkYXRlU3RhdHVzUmVxdWVzdBIhCgx3b3Jrc3BhY2VfaWQYAS'
    'ABKAlSC3dvcmtzcGFjZUlkEhcKB2RlYWxfaWQYAiABKAlSBmRlYWxJZBJNCg10YXJnZXRfc3Rh'
    'dHVzGAMgASgOMiguY3JlYXRpdmFudGEuY29tbWVyY2UudjEuQnJhbmREZWFsU3RhdHVzUgx0YX'
    'JnZXRTdGF0dXMSLwoTY2FuY2VsbGF0aW9uX3JlYXNvbhgEIAEoCVISY2FuY2VsbGF0aW9uUmVh'
    'c29uEj4KG3JlcXVpcmVzX2ZpbmFuY2lhbF9yZXZlcnNhbBgFIAEoCFIZcmVxdWlyZXNGaW5hbm'
    'NpYWxSZXZlcnNhbBJKChNleHBlY3RlZF91cGRhdGVkX2F0GAYgASgLMhouZ29vZ2xlLnByb3Rv'
    'YnVmLlRpbWVzdGFtcFIRZXhwZWN0ZWRVcGRhdGVkQXQSJwoPaWRlbXBvdGVuY3lfa2V5GAcgAS'
    'gJUg5pZGVtcG90ZW5jeUtleQ==');

@$core.Deprecated('Use brandDealServiceUpdateStatusResponseDescriptor instead')
const BrandDealServiceUpdateStatusResponse$json = {
  '1': 'BrandDealServiceUpdateStatusResponse',
  '2': [
    {
      '1': 'deal',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.commerce.v1.BrandDeal',
      '10': 'deal'
    },
  ],
};

/// Descriptor for `BrandDealServiceUpdateStatusResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List brandDealServiceUpdateStatusResponseDescriptor =
    $convert.base64Decode(
        'CiRCcmFuZERlYWxTZXJ2aWNlVXBkYXRlU3RhdHVzUmVzcG9uc2USNgoEZGVhbBgBIAEoCzIiLm'
        'NyZWF0aXZhbnRhLmNvbW1lcmNlLnYxLkJyYW5kRGVhbFIEZGVhbA==');

@$core.Deprecated('Use brandDealServiceListRequestDescriptor instead')
const BrandDealServiceListRequest$json = {
  '1': 'BrandDealServiceListRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {
      '1': 'status_filter',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.creativanta.commerce.v1.BrandDealStatus',
      '10': 'statusFilter'
    },
  ],
};

/// Descriptor for `BrandDealServiceListRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List brandDealServiceListRequestDescriptor =
    $convert.base64Decode(
        'ChtCcmFuZERlYWxTZXJ2aWNlTGlzdFJlcXVlc3QSIQoMd29ya3NwYWNlX2lkGAEgASgJUgt3b3'
        'Jrc3BhY2VJZBJNCg1zdGF0dXNfZmlsdGVyGAIgASgOMiguY3JlYXRpdmFudGEuY29tbWVyY2Uu'
        'djEuQnJhbmREZWFsU3RhdHVzUgxzdGF0dXNGaWx0ZXI=');

@$core.Deprecated('Use brandDealServiceListResponseDescriptor instead')
const BrandDealServiceListResponse$json = {
  '1': 'BrandDealServiceListResponse',
  '2': [
    {
      '1': 'deals',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.creativanta.commerce.v1.BrandDeal',
      '10': 'deals'
    },
  ],
};

/// Descriptor for `BrandDealServiceListResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List brandDealServiceListResponseDescriptor =
    $convert.base64Decode(
        'ChxCcmFuZERlYWxTZXJ2aWNlTGlzdFJlc3BvbnNlEjgKBWRlYWxzGAEgAygLMiIuY3JlYXRpdm'
        'FudGEuY29tbWVyY2UudjEuQnJhbmREZWFsUgVkZWFscw==');

@$core.Deprecated('Use listDealsRequestDescriptor instead')
const ListDealsRequest$json = {
  '1': 'ListDealsRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {
      '1': 'status_filter',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.creativanta.commerce.v1.BrandDealStatus',
      '10': 'statusFilter'
    },
  ],
};

/// Descriptor for `ListDealsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listDealsRequestDescriptor = $convert.base64Decode(
    'ChBMaXN0RGVhbHNSZXF1ZXN0EiEKDHdvcmtzcGFjZV9pZBgBIAEoCVILd29ya3NwYWNlSWQSTQ'
    'oNc3RhdHVzX2ZpbHRlchgCIAEoDjIoLmNyZWF0aXZhbnRhLmNvbW1lcmNlLnYxLkJyYW5kRGVh'
    'bFN0YXR1c1IMc3RhdHVzRmlsdGVy');

@$core.Deprecated('Use listDealsResponseDescriptor instead')
const ListDealsResponse$json = {
  '1': 'ListDealsResponse',
  '2': [
    {
      '1': 'deals',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.creativanta.commerce.v1.BrandDeal',
      '10': 'deals'
    },
  ],
};

/// Descriptor for `ListDealsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listDealsResponseDescriptor = $convert.base64Decode(
    'ChFMaXN0RGVhbHNSZXNwb25zZRI4CgVkZWFscxgBIAMoCzIiLmNyZWF0aXZhbnRhLmNvbW1lcm'
    'NlLnYxLkJyYW5kRGVhbFIFZGVhbHM=');

@$core.Deprecated('Use listPartnershipsRequestDescriptor instead')
const ListPartnershipsRequest$json = {
  '1': 'ListPartnershipsRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
  ],
};

/// Descriptor for `ListPartnershipsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listPartnershipsRequestDescriptor =
    $convert.base64Decode(
        'ChdMaXN0UGFydG5lcnNoaXBzUmVxdWVzdBIhCgx3b3Jrc3BhY2VfaWQYASABKAlSC3dvcmtzcG'
        'FjZUlk');

@$core.Deprecated('Use listPartnershipsResponseDescriptor instead')
const ListPartnershipsResponse$json = {
  '1': 'ListPartnershipsResponse',
  '2': [
    {
      '1': 'partnerships',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.creativanta.commerce.v1.BrandDeal',
      '10': 'partnerships'
    },
  ],
};

/// Descriptor for `ListPartnershipsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listPartnershipsResponseDescriptor =
    $convert.base64Decode(
        'ChhMaXN0UGFydG5lcnNoaXBzUmVzcG9uc2USRgoMcGFydG5lcnNoaXBzGAEgAygLMiIuY3JlYX'
        'RpdmFudGEuY29tbWVyY2UudjEuQnJhbmREZWFsUgxwYXJ0bmVyc2hpcHM=');

@$core.Deprecated('Use getPipelineStatsRequestDescriptor instead')
const GetPipelineStatsRequest$json = {
  '1': 'GetPipelineStatsRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
  ],
};

/// Descriptor for `GetPipelineStatsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getPipelineStatsRequestDescriptor =
    $convert.base64Decode(
        'ChdHZXRQaXBlbGluZVN0YXRzUmVxdWVzdBIhCgx3b3Jrc3BhY2VfaWQYASABKAlSC3dvcmtzcG'
        'FjZUlk');

@$core.Deprecated('Use getPipelineStatsResponseDescriptor instead')
const GetPipelineStatsResponse$json = {
  '1': 'GetPipelineStatsResponse',
  '2': [
    {
      '1': 'stats',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.commerce.v1.BrandDealPipelineStats',
      '10': 'stats'
    },
  ],
};

/// Descriptor for `GetPipelineStatsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getPipelineStatsResponseDescriptor =
    $convert.base64Decode(
        'ChhHZXRQaXBlbGluZVN0YXRzUmVzcG9uc2USRQoFc3RhdHMYASABKAsyLy5jcmVhdGl2YW50YS'
        '5jb21tZXJjZS52MS5CcmFuZERlYWxQaXBlbGluZVN0YXRzUgVzdGF0cw==');

@$core.Deprecated('Use brandDealServiceGetSummaryRequestDescriptor instead')
const BrandDealServiceGetSummaryRequest$json = {
  '1': 'BrandDealServiceGetSummaryRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'deal_id', '3': 2, '4': 1, '5': 9, '10': 'dealId'},
  ],
};

/// Descriptor for `BrandDealServiceGetSummaryRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List brandDealServiceGetSummaryRequestDescriptor =
    $convert.base64Decode(
        'CiFCcmFuZERlYWxTZXJ2aWNlR2V0U3VtbWFyeVJlcXVlc3QSIQoMd29ya3NwYWNlX2lkGAEgAS'
        'gJUgt3b3Jrc3BhY2VJZBIXCgdkZWFsX2lkGAIgASgJUgZkZWFsSWQ=');

@$core.Deprecated('Use brandDealServiceGetSummaryResponseDescriptor instead')
const BrandDealServiceGetSummaryResponse$json = {
  '1': 'BrandDealServiceGetSummaryResponse',
  '2': [
    {
      '1': 'deal',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.commerce.v1.BrandDeal',
      '10': 'deal'
    },
  ],
};

/// Descriptor for `BrandDealServiceGetSummaryResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List brandDealServiceGetSummaryResponseDescriptor =
    $convert.base64Decode(
        'CiJCcmFuZERlYWxTZXJ2aWNlR2V0U3VtbWFyeVJlc3BvbnNlEjYKBGRlYWwYASABKAsyIi5jcm'
        'VhdGl2YW50YS5jb21tZXJjZS52MS5CcmFuZERlYWxSBGRlYWw=');

@$core.Deprecated('Use updateDeliverableRequestDescriptor instead')
const UpdateDeliverableRequest$json = {
  '1': 'UpdateDeliverableRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'deal_id', '3': 2, '4': 1, '5': 9, '10': 'dealId'},
    {'1': 'deliverables', '3': 3, '4': 1, '5': 9, '10': 'deliverables'},
    {
      '1': 'proof_publish_item_id',
      '3': 4,
      '4': 1,
      '5': 9,
      '10': 'proofPublishItemId'
    },
  ],
};

/// Descriptor for `UpdateDeliverableRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateDeliverableRequestDescriptor = $convert.base64Decode(
    'ChhVcGRhdGVEZWxpdmVyYWJsZVJlcXVlc3QSIQoMd29ya3NwYWNlX2lkGAEgASgJUgt3b3Jrc3'
    'BhY2VJZBIXCgdkZWFsX2lkGAIgASgJUgZkZWFsSWQSIgoMZGVsaXZlcmFibGVzGAMgASgJUgxk'
    'ZWxpdmVyYWJsZXMSMQoVcHJvb2ZfcHVibGlzaF9pdGVtX2lkGAQgASgJUhJwcm9vZlB1Ymxpc2'
    'hJdGVtSWQ=');

@$core.Deprecated('Use updateDeliverableResponseDescriptor instead')
const UpdateDeliverableResponse$json = {
  '1': 'UpdateDeliverableResponse',
  '2': [
    {
      '1': 'deal',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.commerce.v1.BrandDeal',
      '10': 'deal'
    },
  ],
};

/// Descriptor for `UpdateDeliverableResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateDeliverableResponseDescriptor =
    $convert.base64Decode(
        'ChlVcGRhdGVEZWxpdmVyYWJsZVJlc3BvbnNlEjYKBGRlYWwYASABKAsyIi5jcmVhdGl2YW50YS'
        '5jb21tZXJjZS52MS5CcmFuZERlYWxSBGRlYWw=');

@$core.Deprecated('Use updatePaymentRequestDescriptor instead')
const UpdatePaymentRequest$json = {
  '1': 'UpdatePaymentRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'deal_id', '3': 2, '4': 1, '5': 9, '10': 'dealId'},
    {'1': 'amount_paid', '3': 3, '4': 1, '5': 1, '10': 'amountPaid'},
    {
      '1': 'settlement_reference',
      '3': 4,
      '4': 1,
      '5': 9,
      '10': 'settlementReference'
    },
  ],
};

/// Descriptor for `UpdatePaymentRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updatePaymentRequestDescriptor = $convert.base64Decode(
    'ChRVcGRhdGVQYXltZW50UmVxdWVzdBIhCgx3b3Jrc3BhY2VfaWQYASABKAlSC3dvcmtzcGFjZU'
    'lkEhcKB2RlYWxfaWQYAiABKAlSBmRlYWxJZBIfCgthbW91bnRfcGFpZBgDIAEoAVIKYW1vdW50'
    'UGFpZBIxChRzZXR0bGVtZW50X3JlZmVyZW5jZRgEIAEoCVITc2V0dGxlbWVudFJlZmVyZW5jZQ'
    '==');

@$core.Deprecated('Use updatePaymentResponseDescriptor instead')
const UpdatePaymentResponse$json = {
  '1': 'UpdatePaymentResponse',
  '2': [
    {
      '1': 'deal',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.commerce.v1.BrandDeal',
      '10': 'deal'
    },
  ],
};

/// Descriptor for `UpdatePaymentResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updatePaymentResponseDescriptor = $convert.base64Decode(
    'ChVVcGRhdGVQYXltZW50UmVzcG9uc2USNgoEZGVhbBgBIAEoCzIiLmNyZWF0aXZhbnRhLmNvbW'
    '1lcmNlLnYxLkJyYW5kRGVhbFIEZGVhbA==');

@$core.Deprecated('Use listContractTemplatesRequestDescriptor instead')
const ListContractTemplatesRequest$json = {
  '1': 'ListContractTemplatesRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
  ],
};

/// Descriptor for `ListContractTemplatesRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listContractTemplatesRequestDescriptor =
    $convert.base64Decode(
        'ChxMaXN0Q29udHJhY3RUZW1wbGF0ZXNSZXF1ZXN0EiEKDHdvcmtzcGFjZV9pZBgBIAEoCVILd2'
        '9ya3NwYWNlSWQ=');

@$core.Deprecated('Use contractTemplateDescriptor instead')
const ContractTemplate$json = {
  '1': 'ContractTemplate',
  '2': [
    {'1': 'template_id', '3': 1, '4': 1, '5': 9, '10': 'templateId'},
    {'1': 'title', '3': 2, '4': 1, '5': 9, '10': 'title'},
    {'1': 'description', '3': 3, '4': 1, '5': 9, '10': 'description'},
    {'1': 'default_terms', '3': 4, '4': 1, '5': 9, '10': 'defaultTerms'},
    {'1': 'version', '3': 5, '4': 1, '5': 9, '10': 'version'},
    {'1': 'source_article_id', '3': 6, '4': 1, '5': 9, '10': 'sourceArticleId'},
    {'1': 'body_markdown', '3': 7, '4': 1, '5': 9, '10': 'bodyMarkdown'},
    {'1': 'disclaimer', '3': 8, '4': 1, '5': 9, '10': 'disclaimer'},
  ],
};

/// Descriptor for `ContractTemplate`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List contractTemplateDescriptor = $convert.base64Decode(
    'ChBDb250cmFjdFRlbXBsYXRlEh8KC3RlbXBsYXRlX2lkGAEgASgJUgp0ZW1wbGF0ZUlkEhQKBX'
    'RpdGxlGAIgASgJUgV0aXRsZRIgCgtkZXNjcmlwdGlvbhgDIAEoCVILZGVzY3JpcHRpb24SIwoN'
    'ZGVmYXVsdF90ZXJtcxgEIAEoCVIMZGVmYXVsdFRlcm1zEhgKB3ZlcnNpb24YBSABKAlSB3Zlcn'
    'Npb24SKgoRc291cmNlX2FydGljbGVfaWQYBiABKAlSD3NvdXJjZUFydGljbGVJZBIjCg1ib2R5'
    'X21hcmtkb3duGAcgASgJUgxib2R5TWFya2Rvd24SHgoKZGlzY2xhaW1lchgIIAEoCVIKZGlzY2'
    'xhaW1lcg==');

@$core.Deprecated('Use listContractTemplatesResponseDescriptor instead')
const ListContractTemplatesResponse$json = {
  '1': 'ListContractTemplatesResponse',
  '2': [
    {
      '1': 'templates',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.creativanta.commerce.v1.ContractTemplate',
      '10': 'templates'
    },
    {'1': 'disclaimer', '3': 2, '4': 1, '5': 9, '10': 'disclaimer'},
  ],
};

/// Descriptor for `ListContractTemplatesResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listContractTemplatesResponseDescriptor =
    $convert.base64Decode(
        'Ch1MaXN0Q29udHJhY3RUZW1wbGF0ZXNSZXNwb25zZRJHCgl0ZW1wbGF0ZXMYASADKAsyKS5jcm'
        'VhdGl2YW50YS5jb21tZXJjZS52MS5Db250cmFjdFRlbXBsYXRlUgl0ZW1wbGF0ZXMSHgoKZGlz'
        'Y2xhaW1lchgCIAEoCVIKZGlzY2xhaW1lcg==');

@$core.Deprecated('Use attachContractRequestDescriptor instead')
const AttachContractRequest$json = {
  '1': 'AttachContractRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'deal_id', '3': 2, '4': 1, '5': 9, '10': 'dealId'},
    {'1': 'evidence_id', '3': 3, '4': 1, '5': 9, '10': 'evidenceId'},
  ],
};

/// Descriptor for `AttachContractRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List attachContractRequestDescriptor = $convert.base64Decode(
    'ChVBdHRhY2hDb250cmFjdFJlcXVlc3QSIQoMd29ya3NwYWNlX2lkGAEgASgJUgt3b3Jrc3BhY2'
    'VJZBIXCgdkZWFsX2lkGAIgASgJUgZkZWFsSWQSHwoLZXZpZGVuY2VfaWQYAyABKAlSCmV2aWRl'
    'bmNlSWQ=');

@$core.Deprecated('Use attachContractResponseDescriptor instead')
const AttachContractResponse$json = {
  '1': 'AttachContractResponse',
  '2': [
    {
      '1': 'deal',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.commerce.v1.BrandDeal',
      '10': 'deal'
    },
  ],
};

/// Descriptor for `AttachContractResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List attachContractResponseDescriptor =
    $convert.base64Decode(
        'ChZBdHRhY2hDb250cmFjdFJlc3BvbnNlEjYKBGRlYWwYASABKAsyIi5jcmVhdGl2YW50YS5jb2'
        '1tZXJjZS52MS5CcmFuZERlYWxSBGRlYWw=');

@$core.Deprecated('Use listInquiriesRequestDescriptor instead')
const ListInquiriesRequest$json = {
  '1': 'ListInquiriesRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
  ],
};

/// Descriptor for `ListInquiriesRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listInquiriesRequestDescriptor = $convert.base64Decode(
    'ChRMaXN0SW5xdWlyaWVzUmVxdWVzdBIhCgx3b3Jrc3BhY2VfaWQYASABKAlSC3dvcmtzcGFjZU'
    'lk');

@$core.Deprecated('Use sponsorInquiryDescriptor instead')
const SponsorInquiry$json = {
  '1': 'SponsorInquiry',
  '2': [
    {'1': 'inquiry_id', '3': 1, '4': 1, '5': 9, '10': 'inquiryId'},
    {'1': 'workspace_id', '3': 2, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'brand_name', '3': 3, '4': 1, '5': 9, '10': 'brandName'},
    {'1': 'contact_email', '3': 4, '4': 1, '5': 9, '10': 'contactEmail'},
    {'1': 'message', '3': 5, '4': 1, '5': 9, '10': 'message'},
    {'1': 'estimated_budget', '3': 6, '4': 1, '5': 1, '10': 'estimatedBudget'},
    {'1': 'status', '3': 7, '4': 1, '5': 9, '10': 'status'},
    {'1': 'thread_id', '3': 8, '4': 1, '5': 9, '10': 'threadId'},
    {
      '1': 'received_at',
      '3': 9,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'receivedAt'
    },
  ],
};

/// Descriptor for `SponsorInquiry`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List sponsorInquiryDescriptor = $convert.base64Decode(
    'Cg5TcG9uc29ySW5xdWlyeRIdCgppbnF1aXJ5X2lkGAEgASgJUglpbnF1aXJ5SWQSIQoMd29ya3'
    'NwYWNlX2lkGAIgASgJUgt3b3Jrc3BhY2VJZBIdCgpicmFuZF9uYW1lGAMgASgJUglicmFuZE5h'
    'bWUSIwoNY29udGFjdF9lbWFpbBgEIAEoCVIMY29udGFjdEVtYWlsEhgKB21lc3NhZ2UYBSABKA'
    'lSB21lc3NhZ2USKQoQZXN0aW1hdGVkX2J1ZGdldBgGIAEoAVIPZXN0aW1hdGVkQnVkZ2V0EhYK'
    'BnN0YXR1cxgHIAEoCVIGc3RhdHVzEhsKCXRocmVhZF9pZBgIIAEoCVIIdGhyZWFkSWQSOwoLcm'
    'VjZWl2ZWRfYXQYCSABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUgpyZWNlaXZlZEF0');

@$core.Deprecated('Use listInquiriesResponseDescriptor instead')
const ListInquiriesResponse$json = {
  '1': 'ListInquiriesResponse',
  '2': [
    {
      '1': 'inquiries',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.creativanta.commerce.v1.SponsorInquiry',
      '10': 'inquiries'
    },
  ],
};

/// Descriptor for `ListInquiriesResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listInquiriesResponseDescriptor = $convert.base64Decode(
    'ChVMaXN0SW5xdWlyaWVzUmVzcG9uc2USRQoJaW5xdWlyaWVzGAEgAygLMicuY3JlYXRpdmFudG'
    'EuY29tbWVyY2UudjEuU3BvbnNvcklucXVpcnlSCWlucXVpcmllcw==');

@$core.Deprecated('Use sponsorInquiryServiceAcceptRequestDescriptor instead')
const SponsorInquiryServiceAcceptRequest$json = {
  '1': 'SponsorInquiryServiceAcceptRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'inquiry_id', '3': 2, '4': 1, '5': 9, '10': 'inquiryId'},
    {'1': 'deal_type', '3': 3, '4': 1, '5': 9, '10': 'dealType'},
    {'1': 'agreed_value', '3': 4, '4': 1, '5': 1, '10': 'agreedValue'},
  ],
};

/// Descriptor for `SponsorInquiryServiceAcceptRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List sponsorInquiryServiceAcceptRequestDescriptor =
    $convert.base64Decode(
        'CiJTcG9uc29ySW5xdWlyeVNlcnZpY2VBY2NlcHRSZXF1ZXN0EiEKDHdvcmtzcGFjZV9pZBgBIA'
        'EoCVILd29ya3NwYWNlSWQSHQoKaW5xdWlyeV9pZBgCIAEoCVIJaW5xdWlyeUlkEhsKCWRlYWxf'
        'dHlwZRgDIAEoCVIIZGVhbFR5cGUSIQoMYWdyZWVkX3ZhbHVlGAQgASgBUgthZ3JlZWRWYWx1ZQ'
        '==');

@$core.Deprecated('Use sponsorInquiryServiceAcceptResponseDescriptor instead')
const SponsorInquiryServiceAcceptResponse$json = {
  '1': 'SponsorInquiryServiceAcceptResponse',
  '2': [
    {
      '1': 'inquiry',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.commerce.v1.SponsorInquiry',
      '10': 'inquiry'
    },
    {
      '1': 'deal',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.creativanta.commerce.v1.BrandDeal',
      '10': 'deal'
    },
  ],
};

/// Descriptor for `SponsorInquiryServiceAcceptResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List sponsorInquiryServiceAcceptResponseDescriptor =
    $convert.base64Decode(
        'CiNTcG9uc29ySW5xdWlyeVNlcnZpY2VBY2NlcHRSZXNwb25zZRJBCgdpbnF1aXJ5GAEgASgLMi'
        'cuY3JlYXRpdmFudGEuY29tbWVyY2UudjEuU3BvbnNvcklucXVpcnlSB2lucXVpcnkSNgoEZGVh'
        'bBgCIAEoCzIiLmNyZWF0aXZhbnRhLmNvbW1lcmNlLnYxLkJyYW5kRGVhbFIEZGVhbA==');

@$core.Deprecated('Use sponsorInquiryServiceDeclineRequestDescriptor instead')
const SponsorInquiryServiceDeclineRequest$json = {
  '1': 'SponsorInquiryServiceDeclineRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'inquiry_id', '3': 2, '4': 1, '5': 9, '10': 'inquiryId'},
    {'1': 'reason', '3': 3, '4': 1, '5': 9, '10': 'reason'},
  ],
};

/// Descriptor for `SponsorInquiryServiceDeclineRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List sponsorInquiryServiceDeclineRequestDescriptor =
    $convert.base64Decode(
        'CiNTcG9uc29ySW5xdWlyeVNlcnZpY2VEZWNsaW5lUmVxdWVzdBIhCgx3b3Jrc3BhY2VfaWQYAS'
        'ABKAlSC3dvcmtzcGFjZUlkEh0KCmlucXVpcnlfaWQYAiABKAlSCWlucXVpcnlJZBIWCgZyZWFz'
        'b24YAyABKAlSBnJlYXNvbg==');

@$core.Deprecated('Use sponsorInquiryServiceDeclineResponseDescriptor instead')
const SponsorInquiryServiceDeclineResponse$json = {
  '1': 'SponsorInquiryServiceDeclineResponse',
  '2': [
    {
      '1': 'inquiry',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.commerce.v1.SponsorInquiry',
      '10': 'inquiry'
    },
  ],
};

/// Descriptor for `SponsorInquiryServiceDeclineResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List sponsorInquiryServiceDeclineResponseDescriptor =
    $convert.base64Decode(
        'CiRTcG9uc29ySW5xdWlyeVNlcnZpY2VEZWNsaW5lUmVzcG9uc2USQQoHaW5xdWlyeRgBIAEoCz'
        'InLmNyZWF0aXZhbnRhLmNvbW1lcmNlLnYxLlNwb25zb3JJbnF1aXJ5UgdpbnF1aXJ5');

@$core.Deprecated('Use sponsorInquiryServiceFlagRequestDescriptor instead')
const SponsorInquiryServiceFlagRequest$json = {
  '1': 'SponsorInquiryServiceFlagRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'inquiry_id', '3': 2, '4': 1, '5': 9, '10': 'inquiryId'},
    {'1': 'flag_reason', '3': 3, '4': 1, '5': 9, '10': 'flagReason'},
  ],
};

/// Descriptor for `SponsorInquiryServiceFlagRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List sponsorInquiryServiceFlagRequestDescriptor =
    $convert.base64Decode(
        'CiBTcG9uc29ySW5xdWlyeVNlcnZpY2VGbGFnUmVxdWVzdBIhCgx3b3Jrc3BhY2VfaWQYASABKA'
        'lSC3dvcmtzcGFjZUlkEh0KCmlucXVpcnlfaWQYAiABKAlSCWlucXVpcnlJZBIfCgtmbGFnX3Jl'
        'YXNvbhgDIAEoCVIKZmxhZ1JlYXNvbg==');

@$core.Deprecated('Use sponsorInquiryServiceFlagResponseDescriptor instead')
const SponsorInquiryServiceFlagResponse$json = {
  '1': 'SponsorInquiryServiceFlagResponse',
  '2': [
    {
      '1': 'inquiry',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.commerce.v1.SponsorInquiry',
      '10': 'inquiry'
    },
  ],
};

/// Descriptor for `SponsorInquiryServiceFlagResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List sponsorInquiryServiceFlagResponseDescriptor =
    $convert.base64Decode(
        'CiFTcG9uc29ySW5xdWlyeVNlcnZpY2VGbGFnUmVzcG9uc2USQQoHaW5xdWlyeRgBIAEoCzInLm'
        'NyZWF0aXZhbnRhLmNvbW1lcmNlLnYxLlNwb25zb3JJbnF1aXJ5UgdpbnF1aXJ5');

@$core.Deprecated('Use sponsorInquiryServiceGetStatsRequestDescriptor instead')
const SponsorInquiryServiceGetStatsRequest$json = {
  '1': 'SponsorInquiryServiceGetStatsRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
  ],
};

/// Descriptor for `SponsorInquiryServiceGetStatsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List sponsorInquiryServiceGetStatsRequestDescriptor =
    $convert.base64Decode(
        'CiRTcG9uc29ySW5xdWlyeVNlcnZpY2VHZXRTdGF0c1JlcXVlc3QSIQoMd29ya3NwYWNlX2lkGA'
        'EgASgJUgt3b3Jrc3BhY2VJZA==');

@$core.Deprecated('Use sponsorInquiryServiceGetStatsResponseDescriptor instead')
const SponsorInquiryServiceGetStatsResponse$json = {
  '1': 'SponsorInquiryServiceGetStatsResponse',
  '2': [
    {'1': 'total_inquiries', '3': 1, '4': 1, '5': 5, '10': 'totalInquiries'},
    {
      '1': 'pending_inquiries',
      '3': 2,
      '4': 1,
      '5': 5,
      '10': 'pendingInquiries'
    },
    {
      '1': 'converted_inquiries',
      '3': 3,
      '4': 1,
      '5': 5,
      '10': 'convertedInquiries'
    },
    {
      '1': 'declined_inquiries',
      '3': 4,
      '4': 1,
      '5': 5,
      '10': 'declinedInquiries'
    },
  ],
};

/// Descriptor for `SponsorInquiryServiceGetStatsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List sponsorInquiryServiceGetStatsResponseDescriptor =
    $convert.base64Decode(
        'CiVTcG9uc29ySW5xdWlyeVNlcnZpY2VHZXRTdGF0c1Jlc3BvbnNlEicKD3RvdGFsX2lucXVpcm'
        'llcxgBIAEoBVIOdG90YWxJbnF1aXJpZXMSKwoRcGVuZGluZ19pbnF1aXJpZXMYAiABKAVSEHBl'
        'bmRpbmdJbnF1aXJpZXMSLwoTY29udmVydGVkX2lucXVpcmllcxgDIAEoBVISY29udmVydGVkSW'
        '5xdWlyaWVzEi0KEmRlY2xpbmVkX2lucXVpcmllcxgEIAEoBVIRZGVjbGluZWRJbnF1aXJpZXM=');

@$core.Deprecated('Use sponsorInquiryServiceSubmitRequestDescriptor instead')
const SponsorInquiryServiceSubmitRequest$json = {
  '1': 'SponsorInquiryServiceSubmitRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'brand_name', '3': 2, '4': 1, '5': 9, '10': 'brandName'},
    {'1': 'contact_email', '3': 3, '4': 1, '5': 9, '10': 'contactEmail'},
    {'1': 'message', '3': 4, '4': 1, '5': 9, '10': 'message'},
    {'1': 'proposed_budget', '3': 5, '4': 1, '5': 1, '10': 'proposedBudget'},
    {'1': 'media_kit_id', '3': 6, '4': 1, '5': 9, '10': 'mediaKitId'},
    {'1': 'challenge_token', '3': 7, '4': 1, '5': 9, '10': 'challengeToken'},
    {'1': 'idempotency_key', '3': 8, '4': 1, '5': 9, '10': 'idempotencyKey'},
  ],
};

/// Descriptor for `SponsorInquiryServiceSubmitRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List sponsorInquiryServiceSubmitRequestDescriptor = $convert.base64Decode(
    'CiJTcG9uc29ySW5xdWlyeVNlcnZpY2VTdWJtaXRSZXF1ZXN0EiEKDHdvcmtzcGFjZV9pZBgBIA'
    'EoCVILd29ya3NwYWNlSWQSHQoKYnJhbmRfbmFtZRgCIAEoCVIJYnJhbmROYW1lEiMKDWNvbnRh'
    'Y3RfZW1haWwYAyABKAlSDGNvbnRhY3RFbWFpbBIYCgdtZXNzYWdlGAQgASgJUgdtZXNzYWdlEi'
    'cKD3Byb3Bvc2VkX2J1ZGdldBgFIAEoAVIOcHJvcG9zZWRCdWRnZXQSIAoMbWVkaWFfa2l0X2lk'
    'GAYgASgJUgptZWRpYUtpdElkEicKD2NoYWxsZW5nZV90b2tlbhgHIAEoCVIOY2hhbGxlbmdlVG'
    '9rZW4SJwoPaWRlbXBvdGVuY3lfa2V5GAggASgJUg5pZGVtcG90ZW5jeUtleQ==');

@$core.Deprecated('Use sponsorInquiryServiceSubmitResponseDescriptor instead')
const SponsorInquiryServiceSubmitResponse$json = {
  '1': 'SponsorInquiryServiceSubmitResponse',
  '2': [
    {'1': 'accepted', '3': 1, '4': 1, '5': 8, '10': 'accepted'},
    {'1': 'inquiry_id', '3': 2, '4': 1, '5': 9, '10': 'inquiryId'},
    {
      '1': 'submission_receipt',
      '3': 3,
      '4': 1,
      '5': 9,
      '10': 'submissionReceipt'
    },
    {'1': 'status', '3': 4, '4': 1, '5': 9, '10': 'status'},
  ],
};

/// Descriptor for `SponsorInquiryServiceSubmitResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List sponsorInquiryServiceSubmitResponseDescriptor =
    $convert.base64Decode(
        'CiNTcG9uc29ySW5xdWlyeVNlcnZpY2VTdWJtaXRSZXNwb25zZRIaCghhY2NlcHRlZBgBIAEoCF'
        'IIYWNjZXB0ZWQSHQoKaW5xdWlyeV9pZBgCIAEoCVIJaW5xdWlyeUlkEi0KEnN1Ym1pc3Npb25f'
        'cmVjZWlwdBgDIAEoCVIRc3VibWlzc2lvblJlY2VpcHQSFgoGc3RhdHVzGAQgASgJUgZzdGF0dX'
        'M=');

@$core.Deprecated('Use getPerContentRequestDescriptor instead')
const GetPerContentRequest$json = {
  '1': 'GetPerContentRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'platform', '3': 2, '4': 1, '5': 9, '10': 'platform'},
    {'1': 'lookback_days', '3': 3, '4': 1, '5': 5, '10': 'lookbackDays'},
  ],
};

/// Descriptor for `GetPerContentRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getPerContentRequestDescriptor = $convert.base64Decode(
    'ChRHZXRQZXJDb250ZW50UmVxdWVzdBIhCgx3b3Jrc3BhY2VfaWQYASABKAlSC3dvcmtzcGFjZU'
    'lkEhoKCHBsYXRmb3JtGAIgASgJUghwbGF0Zm9ybRIjCg1sb29rYmFja19kYXlzGAMgASgFUgxs'
    'b29rYmFja0RheXM=');

@$core.Deprecated('Use getPerContentResponseDescriptor instead')
const GetPerContentResponse$json = {
  '1': 'GetPerContentResponse',
  '2': [
    {
      '1': 'metrics',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.creativanta.commerce.v1.ContentROIMetric',
      '10': 'metrics'
    },
  ],
};

/// Descriptor for `GetPerContentResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getPerContentResponseDescriptor = $convert.base64Decode(
    'ChVHZXRQZXJDb250ZW50UmVzcG9uc2USQwoHbWV0cmljcxgBIAMoCzIpLmNyZWF0aXZhbnRhLm'
    'NvbW1lcmNlLnYxLkNvbnRlbnRST0lNZXRyaWNSB21ldHJpY3M=');

@$core.Deprecated('Use getRPMTrendsRequestDescriptor instead')
const GetRPMTrendsRequest$json = {
  '1': 'GetRPMTrendsRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'platform', '3': 2, '4': 1, '5': 9, '10': 'platform'},
    {'1': 'periods', '3': 3, '4': 1, '5': 5, '10': 'periods'},
  ],
};

/// Descriptor for `GetRPMTrendsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getRPMTrendsRequestDescriptor = $convert.base64Decode(
    'ChNHZXRSUE1UcmVuZHNSZXF1ZXN0EiEKDHdvcmtzcGFjZV9pZBgBIAEoCVILd29ya3NwYWNlSW'
    'QSGgoIcGxhdGZvcm0YAiABKAlSCHBsYXRmb3JtEhgKB3BlcmlvZHMYAyABKAVSB3BlcmlvZHM=');

@$core.Deprecated('Use getRPMTrendsResponseDescriptor instead')
const GetRPMTrendsResponse$json = {
  '1': 'GetRPMTrendsResponse',
  '2': [
    {
      '1': 'trend_points',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.creativanta.commerce.v1.RPMTrendPoint',
      '10': 'trendPoints'
    },
    {'1': 'average_rpm', '3': 2, '4': 1, '5': 1, '10': 'averageRpm'},
    {'1': 'alert_active', '3': 3, '4': 1, '5': 8, '10': 'alertActive'},
  ],
};

/// Descriptor for `GetRPMTrendsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getRPMTrendsResponseDescriptor = $convert.base64Decode(
    'ChRHZXRSUE1UcmVuZHNSZXNwb25zZRJJCgx0cmVuZF9wb2ludHMYASADKAsyJi5jcmVhdGl2YW'
    '50YS5jb21tZXJjZS52MS5SUE1UcmVuZFBvaW50Ugt0cmVuZFBvaW50cxIfCgthdmVyYWdlX3Jw'
    'bRgCIAEoAVIKYXZlcmFnZVJwbRIhCgxhbGVydF9hY3RpdmUYAyABKAhSC2FsZXJ0QWN0aXZl');

@$core.Deprecated('Use getROIRequestDescriptor instead')
const GetROIRequest$json = {
  '1': 'GetROIRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'content_id', '3': 2, '4': 1, '5': 9, '10': 'contentId'},
  ],
};

/// Descriptor for `GetROIRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getROIRequestDescriptor = $convert.base64Decode(
    'Cg1HZXRST0lSZXF1ZXN0EiEKDHdvcmtzcGFjZV9pZBgBIAEoCVILd29ya3NwYWNlSWQSHQoKY2'
    '9udGVudF9pZBgCIAEoCVIJY29udGVudElk');

@$core.Deprecated('Use getROIResponseDescriptor instead')
const GetROIResponse$json = {
  '1': 'GetROIResponse',
  '2': [
    {
      '1': 'metric',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.commerce.v1.ContentROIMetric',
      '10': 'metric'
    },
  ],
};

/// Descriptor for `GetROIResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getROIResponseDescriptor = $convert.base64Decode(
    'Cg5HZXRST0lSZXNwb25zZRJBCgZtZXRyaWMYASABKAsyKS5jcmVhdGl2YW50YS5jb21tZXJjZS'
    '52MS5Db250ZW50Uk9JTWV0cmljUgZtZXRyaWM=');

@$core.Deprecated('Use getTopPerformersRequestDescriptor instead')
const GetTopPerformersRequest$json = {
  '1': 'GetTopPerformersRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'sort_by', '3': 2, '4': 1, '5': 9, '10': 'sortBy'},
    {'1': 'limit', '3': 3, '4': 1, '5': 5, '10': 'limit'},
  ],
};

/// Descriptor for `GetTopPerformersRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getTopPerformersRequestDescriptor = $convert.base64Decode(
    'ChdHZXRUb3BQZXJmb3JtZXJzUmVxdWVzdBIhCgx3b3Jrc3BhY2VfaWQYASABKAlSC3dvcmtzcG'
    'FjZUlkEhcKB3NvcnRfYnkYAiABKAlSBnNvcnRCeRIUCgVsaW1pdBgDIAEoBVIFbGltaXQ=');

@$core.Deprecated('Use getTopPerformersResponseDescriptor instead')
const GetTopPerformersResponse$json = {
  '1': 'GetTopPerformersResponse',
  '2': [
    {
      '1': 'top_performers',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.creativanta.commerce.v1.ContentROIMetric',
      '10': 'topPerformers'
    },
  ],
};

/// Descriptor for `GetTopPerformersResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getTopPerformersResponseDescriptor =
    $convert.base64Decode(
        'ChhHZXRUb3BQZXJmb3JtZXJzUmVzcG9uc2USUAoOdG9wX3BlcmZvcm1lcnMYASADKAsyKS5jcm'
        'VhdGl2YW50YS5jb21tZXJjZS52MS5Db250ZW50Uk9JTWV0cmljUg10b3BQZXJmb3JtZXJz');

@$core.Deprecated('Use taxReportServiceGetReportRequestDescriptor instead')
const TaxReportServiceGetReportRequest$json = {
  '1': 'TaxReportServiceGetReportRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {
      '1': 'period',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.creativanta.commerce.v1.TaxReportPeriod',
      '10': 'period'
    },
    {'1': 'year', '3': 3, '4': 1, '5': 5, '10': 'year'},
    {'1': 'period_number', '3': 4, '4': 1, '5': 5, '10': 'periodNumber'},
  ],
};

/// Descriptor for `TaxReportServiceGetReportRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List taxReportServiceGetReportRequestDescriptor =
    $convert.base64Decode(
        'CiBUYXhSZXBvcnRTZXJ2aWNlR2V0UmVwb3J0UmVxdWVzdBIhCgx3b3Jrc3BhY2VfaWQYASABKA'
        'lSC3dvcmtzcGFjZUlkEkAKBnBlcmlvZBgCIAEoDjIoLmNyZWF0aXZhbnRhLmNvbW1lcmNlLnYx'
        'LlRheFJlcG9ydFBlcmlvZFIGcGVyaW9kEhIKBHllYXIYAyABKAVSBHllYXISIwoNcGVyaW9kX2'
        '51bWJlchgEIAEoBVIMcGVyaW9kTnVtYmVy');

@$core.Deprecated('Use taxReportServiceGetReportResponseDescriptor instead')
const TaxReportServiceGetReportResponse$json = {
  '1': 'TaxReportServiceGetReportResponse',
  '2': [
    {
      '1': 'summary',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.commerce.v1.TaxReportSummary',
      '10': 'summary'
    },
  ],
};

/// Descriptor for `TaxReportServiceGetReportResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List taxReportServiceGetReportResponseDescriptor =
    $convert.base64Decode(
        'CiFUYXhSZXBvcnRTZXJ2aWNlR2V0UmVwb3J0UmVzcG9uc2USQwoHc3VtbWFyeRgBIAEoCzIpLm'
        'NyZWF0aXZhbnRhLmNvbW1lcmNlLnYxLlRheFJlcG9ydFN1bW1hcnlSB3N1bW1hcnk=');

@$core.Deprecated('Use exportTaxReportRequestDescriptor instead')
const ExportTaxReportRequest$json = {
  '1': 'ExportTaxReportRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {
      '1': 'period',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.creativanta.commerce.v1.TaxReportPeriod',
      '10': 'period'
    },
    {'1': 'year', '3': 3, '4': 1, '5': 5, '10': 'year'},
    {'1': 'period_number', '3': 4, '4': 1, '5': 5, '10': 'periodNumber'},
    {
      '1': 'format',
      '3': 5,
      '4': 1,
      '5': 14,
      '6': '.creativanta.commerce.v1.TaxReportFormat',
      '10': 'format'
    },
  ],
};

/// Descriptor for `ExportTaxReportRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List exportTaxReportRequestDescriptor = $convert.base64Decode(
    'ChZFeHBvcnRUYXhSZXBvcnRSZXF1ZXN0EiEKDHdvcmtzcGFjZV9pZBgBIAEoCVILd29ya3NwYW'
    'NlSWQSQAoGcGVyaW9kGAIgASgOMiguY3JlYXRpdmFudGEuY29tbWVyY2UudjEuVGF4UmVwb3J0'
    'UGVyaW9kUgZwZXJpb2QSEgoEeWVhchgDIAEoBVIEeWVhchIjCg1wZXJpb2RfbnVtYmVyGAQgAS'
    'gFUgxwZXJpb2ROdW1iZXISQAoGZm9ybWF0GAUgASgOMiguY3JlYXRpdmFudGEuY29tbWVyY2Uu'
    'djEuVGF4UmVwb3J0Rm9ybWF0UgZmb3JtYXQ=');

@$core.Deprecated('Use exportTaxReportResponseDescriptor instead')
const ExportTaxReportResponse$json = {
  '1': 'ExportTaxReportResponse',
  '2': [
    {
      '1': 'summary',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.commerce.v1.TaxReportSummary',
      '10': 'summary'
    },
    {'1': 'report_data', '3': 2, '4': 1, '5': 12, '10': 'reportData'},
    {'1': 'file_name', '3': 3, '4': 1, '5': 9, '10': 'fileName'},
  ],
};

/// Descriptor for `ExportTaxReportResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List exportTaxReportResponseDescriptor = $convert.base64Decode(
    'ChdFeHBvcnRUYXhSZXBvcnRSZXNwb25zZRJDCgdzdW1tYXJ5GAEgASgLMikuY3JlYXRpdmFudG'
    'EuY29tbWVyY2UudjEuVGF4UmVwb3J0U3VtbWFyeVIHc3VtbWFyeRIfCgtyZXBvcnRfZGF0YRgC'
    'IAEoDFIKcmVwb3J0RGF0YRIbCglmaWxlX25hbWUYAyABKAlSCGZpbGVOYW1l');

@$core.Deprecated('Use creatorDirectoryEntryDescriptor instead')
const CreatorDirectoryEntry$json = {
  '1': 'CreatorDirectoryEntry',
  '2': [
    {'1': 'media_kit_id', '3': 1, '4': 1, '5': 9, '10': 'mediaKitId'},
    {
      '1': 'profile',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.creativanta.commerce.v1.PublicCreatorProfile',
      '10': 'profile'
    },
    {
      '1': 'published_at',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'publishedAt'
    },
  ],
};

/// Descriptor for `CreatorDirectoryEntry`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List creatorDirectoryEntryDescriptor = $convert.base64Decode(
    'ChVDcmVhdG9yRGlyZWN0b3J5RW50cnkSIAoMbWVkaWFfa2l0X2lkGAEgASgJUgptZWRpYUtpdE'
    'lkEkcKB3Byb2ZpbGUYAiABKAsyLS5jcmVhdGl2YW50YS5jb21tZXJjZS52MS5QdWJsaWNDcmVh'
    'dG9yUHJvZmlsZVIHcHJvZmlsZRI9CgxwdWJsaXNoZWRfYXQYAyABKAsyGi5nb29nbGUucHJvdG'
    '9idWYuVGltZXN0YW1wUgtwdWJsaXNoZWRBdA==');

@$core.Deprecated('Use creatorDirectoryServiceSearchRequestDescriptor instead')
const CreatorDirectoryServiceSearchRequest$json = {
  '1': 'CreatorDirectoryServiceSearchRequest',
  '2': [
    {'1': 'query', '3': 1, '4': 1, '5': 9, '10': 'query'},
    {'1': 'categories', '3': 2, '4': 3, '5': 9, '10': 'categories'},
    {'1': 'languages', '3': 3, '4': 3, '5': 9, '10': 'languages'},
    {'1': 'page_size', '3': 4, '4': 1, '5': 5, '10': 'pageSize'},
    {'1': 'page_token', '3': 5, '4': 1, '5': 9, '10': 'pageToken'},
  ],
};

/// Descriptor for `CreatorDirectoryServiceSearchRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List creatorDirectoryServiceSearchRequestDescriptor =
    $convert.base64Decode(
        'CiRDcmVhdG9yRGlyZWN0b3J5U2VydmljZVNlYXJjaFJlcXVlc3QSFAoFcXVlcnkYASABKAlSBX'
        'F1ZXJ5Eh4KCmNhdGVnb3JpZXMYAiADKAlSCmNhdGVnb3JpZXMSHAoJbGFuZ3VhZ2VzGAMgAygJ'
        'UglsYW5ndWFnZXMSGwoJcGFnZV9zaXplGAQgASgFUghwYWdlU2l6ZRIdCgpwYWdlX3Rva2VuGA'
        'UgASgJUglwYWdlVG9rZW4=');

@$core.Deprecated('Use creatorDirectoryServiceSearchResponseDescriptor instead')
const CreatorDirectoryServiceSearchResponse$json = {
  '1': 'CreatorDirectoryServiceSearchResponse',
  '2': [
    {
      '1': 'entries',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.creativanta.commerce.v1.CreatorDirectoryEntry',
      '10': 'entries'
    },
    {'1': 'next_page_token', '3': 2, '4': 1, '5': 9, '10': 'nextPageToken'},
    {'1': 'has_more', '3': 3, '4': 1, '5': 8, '10': 'hasMore'},
    {'1': 'total_count', '3': 4, '4': 1, '5': 3, '10': 'totalCount'},
  ],
};

/// Descriptor for `CreatorDirectoryServiceSearchResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List creatorDirectoryServiceSearchResponseDescriptor =
    $convert.base64Decode(
        'CiVDcmVhdG9yRGlyZWN0b3J5U2VydmljZVNlYXJjaFJlc3BvbnNlEkgKB2VudHJpZXMYASADKA'
        'syLi5jcmVhdGl2YW50YS5jb21tZXJjZS52MS5DcmVhdG9yRGlyZWN0b3J5RW50cnlSB2VudHJp'
        'ZXMSJgoPbmV4dF9wYWdlX3Rva2VuGAIgASgJUg1uZXh0UGFnZVRva2VuEhkKCGhhc19tb3JlGA'
        'MgASgIUgdoYXNNb3JlEh8KC3RvdGFsX2NvdW50GAQgASgDUgp0b3RhbENvdW50');

@$core.Deprecated('Use creatorDirectoryServiceGetRequestDescriptor instead')
const CreatorDirectoryServiceGetRequest$json = {
  '1': 'CreatorDirectoryServiceGetRequest',
  '2': [
    {'1': 'media_kit_id', '3': 1, '4': 1, '5': 9, '10': 'mediaKitId'},
  ],
};

/// Descriptor for `CreatorDirectoryServiceGetRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List creatorDirectoryServiceGetRequestDescriptor =
    $convert.base64Decode(
        'CiFDcmVhdG9yRGlyZWN0b3J5U2VydmljZUdldFJlcXVlc3QSIAoMbWVkaWFfa2l0X2lkGAEgAS'
        'gJUgptZWRpYUtpdElk');

@$core.Deprecated('Use creatorDirectoryServiceGetResponseDescriptor instead')
const CreatorDirectoryServiceGetResponse$json = {
  '1': 'CreatorDirectoryServiceGetResponse',
  '2': [
    {
      '1': 'entry',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.commerce.v1.CreatorDirectoryEntry',
      '10': 'entry'
    },
  ],
};

/// Descriptor for `CreatorDirectoryServiceGetResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List creatorDirectoryServiceGetResponseDescriptor =
    $convert.base64Decode(
        'CiJDcmVhdG9yRGlyZWN0b3J5U2VydmljZUdldFJlc3BvbnNlEkQKBWVudHJ5GAEgASgLMi4uY3'
        'JlYXRpdmFudGEuY29tbWVyY2UudjEuQ3JlYXRvckRpcmVjdG9yeUVudHJ5UgVlbnRyeQ==');

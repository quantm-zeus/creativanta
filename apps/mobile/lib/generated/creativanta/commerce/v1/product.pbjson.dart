// This is a generated file - do not edit.
//
// Generated from creativanta/commerce/v1/product.proto.

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

@$core.Deprecated('Use productTypeDescriptor instead')
const ProductType$json = {
  '1': 'ProductType',
  '2': [
    {'1': 'PRODUCT_TYPE_UNSPECIFIED', '2': 0},
    {'1': 'PRODUCT_TYPE_PHYSICAL', '2': 1},
    {'1': 'PRODUCT_TYPE_DIGITAL', '2': 2},
    {'1': 'PRODUCT_TYPE_SERVICE', '2': 3},
    {'1': 'PRODUCT_TYPE_MEMBERSHIP', '2': 4},
    {'1': 'PRODUCT_TYPE_BUNDLE', '2': 5},
  ],
};

/// Descriptor for `ProductType`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List productTypeDescriptor = $convert.base64Decode(
    'CgtQcm9kdWN0VHlwZRIcChhQUk9EVUNUX1RZUEVfVU5TUEVDSUZJRUQQABIZChVQUk9EVUNUX1'
    'RZUEVfUEhZU0lDQUwQARIYChRQUk9EVUNUX1RZUEVfRElHSVRBTBACEhgKFFBST0RVQ1RfVFlQ'
    'RV9TRVJWSUNFEAMSGwoXUFJPRFVDVF9UWVBFX01FTUJFUlNISVAQBBIXChNQUk9EVUNUX1RZUE'
    'VfQlVORExFEAU=');

@$core.Deprecated('Use catalogStatusDescriptor instead')
const CatalogStatus$json = {
  '1': 'CatalogStatus',
  '2': [
    {'1': 'CATALOG_STATUS_UNSPECIFIED', '2': 0},
    {'1': 'CATALOG_STATUS_DRAFT', '2': 1},
    {'1': 'CATALOG_STATUS_ACTIVE', '2': 2},
    {'1': 'CATALOG_STATUS_ARCHIVED', '2': 3},
    {'1': 'CATALOG_STATUS_DISCONTINUED', '2': 4},
  ],
};

/// Descriptor for `CatalogStatus`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List catalogStatusDescriptor = $convert.base64Decode(
    'Cg1DYXRhbG9nU3RhdHVzEh4KGkNBVEFMT0dfU1RBVFVTX1VOU1BFQ0lGSUVEEAASGAoUQ0FUQU'
    'xPR19TVEFUVVNfRFJBRlQQARIZChVDQVRBTE9HX1NUQVRVU19BQ1RJVkUQAhIbChdDQVRBTE9H'
    'X1NUQVRVU19BUkNISVZFRBADEh8KG0NBVEFMT0dfU1RBVFVTX0RJU0NPTlRJTlVFRBAE');

@$core.Deprecated('Use externalRefDescriptor instead')
const ExternalRef$json = {
  '1': 'ExternalRef',
  '2': [
    {'1': 'platform', '3': 1, '4': 1, '5': 9, '10': 'platform'},
    {'1': 'external_id', '3': 2, '4': 1, '5': 9, '10': 'externalId'},
    {'1': 'url', '3': 3, '4': 1, '5': 9, '10': 'url'},
    {
      '1': 'connected_account_id',
      '3': 4,
      '4': 1,
      '5': 9,
      '10': 'connectedAccountId'
    },
  ],
};

/// Descriptor for `ExternalRef`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List externalRefDescriptor = $convert.base64Decode(
    'CgtFeHRlcm5hbFJlZhIaCghwbGF0Zm9ybRgBIAEoCVIIcGxhdGZvcm0SHwoLZXh0ZXJuYWxfaW'
    'QYAiABKAlSCmV4dGVybmFsSWQSEAoDdXJsGAMgASgJUgN1cmwSMAoUY29ubmVjdGVkX2FjY291'
    'bnRfaWQYBCABKAlSEmNvbm5lY3RlZEFjY291bnRJZA==');

@$core.Deprecated('Use productSkuDescriptor instead')
const ProductSku$json = {
  '1': 'ProductSku',
  '2': [
    {'1': 'sku_id', '3': 1, '4': 1, '5': 9, '10': 'skuId'},
    {'1': 'workspace_id', '3': 2, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'product_id', '3': 3, '4': 1, '5': 9, '10': 'productId'},
    {'1': 'sku_code', '3': 4, '4': 1, '5': 9, '10': 'skuCode'},
    {
      '1': 'variant_attributes',
      '3': 5,
      '4': 3,
      '5': 11,
      '6': '.creativanta.commerce.v1.ProductSku.VariantAttributesEntry',
      '10': 'variantAttributes'
    },
    {
      '1': 'price_override',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.Money',
      '10': 'priceOverride'
    },
    {
      '1': 'cogs_override',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.Money',
      '10': 'cogsOverride'
    },
    {'1': 'currency', '3': 8, '4': 1, '5': 9, '10': 'currency'},
    {'1': 'stock_quantity', '3': 9, '4': 1, '5': 5, '10': 'stockQuantity'},
    {'1': 'stock_reserved', '3': 10, '4': 1, '5': 5, '10': 'stockReserved'},
    {
      '1': 'low_stock_threshold',
      '3': 11,
      '4': 1,
      '5': 5,
      '10': 'lowStockThreshold'
    },
    {'1': 'barcode', '3': 12, '4': 1, '5': 9, '10': 'barcode'},
    {'1': 'weight_grams', '3': 13, '4': 1, '5': 5, '10': 'weightGrams'},
    {'1': 'is_active', '3': 14, '4': 1, '5': 8, '10': 'isActive'},
    {
      '1': 'external_refs',
      '3': 15,
      '4': 3,
      '5': 11,
      '6': '.creativanta.commerce.v1.ExternalRef',
      '10': 'externalRefs'
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
    {
      '1': 'deleted_at',
      '3': 18,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'deletedAt'
    },
  ],
  '3': [ProductSku_VariantAttributesEntry$json],
};

@$core.Deprecated('Use productSkuDescriptor instead')
const ProductSku_VariantAttributesEntry$json = {
  '1': 'VariantAttributesEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {'1': 'value', '3': 2, '4': 1, '5': 9, '10': 'value'},
  ],
  '7': {'7': true},
};

/// Descriptor for `ProductSku`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List productSkuDescriptor = $convert.base64Decode(
    'CgpQcm9kdWN0U2t1EhUKBnNrdV9pZBgBIAEoCVIFc2t1SWQSIQoMd29ya3NwYWNlX2lkGAIgAS'
    'gJUgt3b3Jrc3BhY2VJZBIdCgpwcm9kdWN0X2lkGAMgASgJUglwcm9kdWN0SWQSGQoIc2t1X2Nv'
    'ZGUYBCABKAlSB3NrdUNvZGUSaQoSdmFyaWFudF9hdHRyaWJ1dGVzGAUgAygLMjouY3JlYXRpdm'
    'FudGEuY29tbWVyY2UudjEuUHJvZHVjdFNrdS5WYXJpYW50QXR0cmlidXRlc0VudHJ5UhF2YXJp'
    'YW50QXR0cmlidXRlcxJDCg5wcmljZV9vdmVycmlkZRgGIAEoCzIcLmNyZWF0aXZhbnRhLmNvbW'
    '1vbi52MS5Nb25leVINcHJpY2VPdmVycmlkZRJBCg1jb2dzX292ZXJyaWRlGAcgASgLMhwuY3Jl'
    'YXRpdmFudGEuY29tbW9uLnYxLk1vbmV5Ugxjb2dzT3ZlcnJpZGUSGgoIY3VycmVuY3kYCCABKA'
    'lSCGN1cnJlbmN5EiUKDnN0b2NrX3F1YW50aXR5GAkgASgFUg1zdG9ja1F1YW50aXR5EiUKDnN0'
    'b2NrX3Jlc2VydmVkGAogASgFUg1zdG9ja1Jlc2VydmVkEi4KE2xvd19zdG9ja190aHJlc2hvbG'
    'QYCyABKAVSEWxvd1N0b2NrVGhyZXNob2xkEhgKB2JhcmNvZGUYDCABKAlSB2JhcmNvZGUSIQoM'
    'd2VpZ2h0X2dyYW1zGA0gASgFUgt3ZWlnaHRHcmFtcxIbCglpc19hY3RpdmUYDiABKAhSCGlzQW'
    'N0aXZlEkkKDWV4dGVybmFsX3JlZnMYDyADKAsyJC5jcmVhdGl2YW50YS5jb21tZXJjZS52MS5F'
    'eHRlcm5hbFJlZlIMZXh0ZXJuYWxSZWZzEjkKCmNyZWF0ZWRfYXQYECABKAsyGi5nb29nbGUucH'
    'JvdG9idWYuVGltZXN0YW1wUgljcmVhdGVkQXQSOQoKdXBkYXRlZF9hdBgRIAEoCzIaLmdvb2ds'
    'ZS5wcm90b2J1Zi5UaW1lc3RhbXBSCXVwZGF0ZWRBdBI5CgpkZWxldGVkX2F0GBIgASgLMhouZ2'
    '9vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIJZGVsZXRlZEF0GkQKFlZhcmlhbnRBdHRyaWJ1dGVz'
    'RW50cnkSEAoDa2V5GAEgASgJUgNrZXkSFAoFdmFsdWUYAiABKAlSBXZhbHVlOgI4AQ==');

@$core.Deprecated('Use productDescriptor instead')
const Product$json = {
  '1': 'Product',
  '2': [
    {'1': 'product_id', '3': 1, '4': 1, '5': 9, '10': 'productId'},
    {'1': 'workspace_id', '3': 2, '4': 1, '5': 9, '10': 'workspaceId'},
    {
      '1': 'product_type',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.creativanta.commerce.v1.ProductType',
      '10': 'productType'
    },
    {'1': 'title', '3': 4, '4': 1, '5': 9, '10': 'title'},
    {'1': 'description', '3': 5, '4': 1, '5': 9, '10': 'description'},
    {'1': 'category', '3': 6, '4': 1, '5': 9, '10': 'category'},
    {
      '1': 'base_price',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.Money',
      '10': 'basePrice'
    },
    {'1': 'currency', '3': 8, '4': 1, '5': 9, '10': 'currency'},
    {
      '1': 'cogs',
      '3': 9,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.Money',
      '10': 'cogs'
    },
    {
      '1': 'catalog_status',
      '3': 10,
      '4': 1,
      '5': 14,
      '6': '.creativanta.commerce.v1.CatalogStatus',
      '10': 'catalogStatus'
    },
    {
      '1': 'inventory_enabled',
      '3': 11,
      '4': 1,
      '5': 8,
      '10': 'inventoryEnabled'
    },
    {
      '1': 'external_refs',
      '3': 12,
      '4': 3,
      '5': 11,
      '6': '.creativanta.commerce.v1.ExternalRef',
      '10': 'externalRefs'
    },
    {'1': 'images', '3': 13, '4': 3, '5': 9, '10': 'images'},
    {'1': 'metadata_json', '3': 14, '4': 1, '5': 9, '10': 'metadataJson'},
    {
      '1': 'skus',
      '3': 15,
      '4': 3,
      '5': 11,
      '6': '.creativanta.commerce.v1.ProductSku',
      '10': 'skus'
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
    {
      '1': 'deleted_at',
      '3': 18,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'deletedAt'
    },
  ],
};

/// Descriptor for `Product`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List productDescriptor = $convert.base64Decode(
    'CgdQcm9kdWN0Eh0KCnByb2R1Y3RfaWQYASABKAlSCXByb2R1Y3RJZBIhCgx3b3Jrc3BhY2VfaW'
    'QYAiABKAlSC3dvcmtzcGFjZUlkEkcKDHByb2R1Y3RfdHlwZRgDIAEoDjIkLmNyZWF0aXZhbnRh'
    'LmNvbW1lcmNlLnYxLlByb2R1Y3RUeXBlUgtwcm9kdWN0VHlwZRIUCgV0aXRsZRgEIAEoCVIFdG'
    'l0bGUSIAoLZGVzY3JpcHRpb24YBSABKAlSC2Rlc2NyaXB0aW9uEhoKCGNhdGVnb3J5GAYgASgJ'
    'UghjYXRlZ29yeRI7CgpiYXNlX3ByaWNlGAcgASgLMhwuY3JlYXRpdmFudGEuY29tbW9uLnYxLk'
    '1vbmV5UgliYXNlUHJpY2USGgoIY3VycmVuY3kYCCABKAlSCGN1cnJlbmN5EjAKBGNvZ3MYCSAB'
    'KAsyHC5jcmVhdGl2YW50YS5jb21tb24udjEuTW9uZXlSBGNvZ3MSTQoOY2F0YWxvZ19zdGF0dX'
    'MYCiABKA4yJi5jcmVhdGl2YW50YS5jb21tZXJjZS52MS5DYXRhbG9nU3RhdHVzUg1jYXRhbG9n'
    'U3RhdHVzEisKEWludmVudG9yeV9lbmFibGVkGAsgASgIUhBpbnZlbnRvcnlFbmFibGVkEkkKDW'
    'V4dGVybmFsX3JlZnMYDCADKAsyJC5jcmVhdGl2YW50YS5jb21tZXJjZS52MS5FeHRlcm5hbFJl'
    'ZlIMZXh0ZXJuYWxSZWZzEhYKBmltYWdlcxgNIAMoCVIGaW1hZ2VzEiMKDW1ldGFkYXRhX2pzb2'
    '4YDiABKAlSDG1ldGFkYXRhSnNvbhI3CgRza3VzGA8gAygLMiMuY3JlYXRpdmFudGEuY29tbWVy'
    'Y2UudjEuUHJvZHVjdFNrdVIEc2t1cxI5CgpjcmVhdGVkX2F0GBAgASgLMhouZ29vZ2xlLnByb3'
    'RvYnVmLlRpbWVzdGFtcFIJY3JlYXRlZEF0EjkKCnVwZGF0ZWRfYXQYESABKAsyGi5nb29nbGUu'
    'cHJvdG9idWYuVGltZXN0YW1wUgl1cGRhdGVkQXQSOQoKZGVsZXRlZF9hdBgSIAEoCzIaLmdvb2'
    'dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSCWRlbGV0ZWRBdA==');

@$core.Deprecated('Use contentRefDescriptor instead')
const ContentRef$json = {
  '1': 'ContentRef',
  '2': [
    {'1': 'content_id', '3': 1, '4': 1, '5': 9, '10': 'contentId'},
    {'1': 'content_type', '3': 2, '4': 1, '5': 9, '10': 'contentType'},
    {'1': 'title', '3': 3, '4': 1, '5': 9, '10': 'title'},
    {'1': 'url', '3': 4, '4': 1, '5': 9, '10': 'url'},
    {
      '1': 'linked_at',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'linkedAt'
    },
    {'1': 'metadata_json', '3': 6, '4': 1, '5': 9, '10': 'metadataJson'},
  ],
};

/// Descriptor for `ContentRef`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List contentRefDescriptor = $convert.base64Decode(
    'CgpDb250ZW50UmVmEh0KCmNvbnRlbnRfaWQYASABKAlSCWNvbnRlbnRJZBIhCgxjb250ZW50X3'
    'R5cGUYAiABKAlSC2NvbnRlbnRUeXBlEhQKBXRpdGxlGAMgASgJUgV0aXRsZRIQCgN1cmwYBCAB'
    'KAlSA3VybBI3CglsaW5rZWRfYXQYBSABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUg'
    'hsaW5rZWRBdBIjCg1tZXRhZGF0YV9qc29uGAYgASgJUgxtZXRhZGF0YUpzb24=');

@$core.Deprecated('Use createRequestDescriptor instead')
const CreateRequest$json = {
  '1': 'CreateRequest',
  '2': [
    {
      '1': 'context',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.CommandContext',
      '10': 'context'
    },
    {
      '1': 'product_type',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.creativanta.commerce.v1.ProductType',
      '10': 'productType'
    },
    {'1': 'title', '3': 3, '4': 1, '5': 9, '10': 'title'},
    {'1': 'description', '3': 4, '4': 1, '5': 9, '10': 'description'},
    {'1': 'category', '3': 5, '4': 1, '5': 9, '10': 'category'},
    {
      '1': 'base_price',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.Money',
      '10': 'basePrice'
    },
    {
      '1': 'cogs',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.Money',
      '10': 'cogs'
    },
    {'1': 'currency', '3': 8, '4': 1, '5': 9, '10': 'currency'},
    {
      '1': 'catalog_status',
      '3': 9,
      '4': 1,
      '5': 14,
      '6': '.creativanta.commerce.v1.CatalogStatus',
      '10': 'catalogStatus'
    },
    {
      '1': 'inventory_enabled',
      '3': 10,
      '4': 1,
      '5': 8,
      '10': 'inventoryEnabled'
    },
    {
      '1': 'external_refs',
      '3': 11,
      '4': 3,
      '5': 11,
      '6': '.creativanta.commerce.v1.ExternalRef',
      '10': 'externalRefs'
    },
    {'1': 'images', '3': 12, '4': 3, '5': 9, '10': 'images'},
    {'1': 'metadata_json', '3': 13, '4': 1, '5': 9, '10': 'metadataJson'},
    {
      '1': 'initial_skus',
      '3': 14,
      '4': 3,
      '5': 11,
      '6': '.creativanta.commerce.v1.ProductSku',
      '10': 'initialSkus'
    },
  ],
};

/// Descriptor for `CreateRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createRequestDescriptor = $convert.base64Decode(
    'Cg1DcmVhdGVSZXF1ZXN0Ej8KB2NvbnRleHQYASABKAsyJS5jcmVhdGl2YW50YS5jb21tb24udj'
    'EuQ29tbWFuZENvbnRleHRSB2NvbnRleHQSRwoMcHJvZHVjdF90eXBlGAIgASgOMiQuY3JlYXRp'
    'dmFudGEuY29tbWVyY2UudjEuUHJvZHVjdFR5cGVSC3Byb2R1Y3RUeXBlEhQKBXRpdGxlGAMgAS'
    'gJUgV0aXRsZRIgCgtkZXNjcmlwdGlvbhgEIAEoCVILZGVzY3JpcHRpb24SGgoIY2F0ZWdvcnkY'
    'BSABKAlSCGNhdGVnb3J5EjsKCmJhc2VfcHJpY2UYBiABKAsyHC5jcmVhdGl2YW50YS5jb21tb2'
    '4udjEuTW9uZXlSCWJhc2VQcmljZRIwCgRjb2dzGAcgASgLMhwuY3JlYXRpdmFudGEuY29tbW9u'
    'LnYxLk1vbmV5UgRjb2dzEhoKCGN1cnJlbmN5GAggASgJUghjdXJyZW5jeRJNCg5jYXRhbG9nX3'
    'N0YXR1cxgJIAEoDjImLmNyZWF0aXZhbnRhLmNvbW1lcmNlLnYxLkNhdGFsb2dTdGF0dXNSDWNh'
    'dGFsb2dTdGF0dXMSKwoRaW52ZW50b3J5X2VuYWJsZWQYCiABKAhSEGludmVudG9yeUVuYWJsZW'
    'QSSQoNZXh0ZXJuYWxfcmVmcxgLIAMoCzIkLmNyZWF0aXZhbnRhLmNvbW1lcmNlLnYxLkV4dGVy'
    'bmFsUmVmUgxleHRlcm5hbFJlZnMSFgoGaW1hZ2VzGAwgAygJUgZpbWFnZXMSIwoNbWV0YWRhdG'
    'FfanNvbhgNIAEoCVIMbWV0YWRhdGFKc29uEkYKDGluaXRpYWxfc2t1cxgOIAMoCzIjLmNyZWF0'
    'aXZhbnRhLmNvbW1lcmNlLnYxLlByb2R1Y3RTa3VSC2luaXRpYWxTa3Vz');

@$core.Deprecated('Use createResponseDescriptor instead')
const CreateResponse$json = {
  '1': 'CreateResponse',
  '2': [
    {
      '1': 'product',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.commerce.v1.Product',
      '10': 'product'
    },
  ],
};

/// Descriptor for `CreateResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createResponseDescriptor = $convert.base64Decode(
    'Cg5DcmVhdGVSZXNwb25zZRI6Cgdwcm9kdWN0GAEgASgLMiAuY3JlYXRpdmFudGEuY29tbWVyY2'
    'UudjEuUHJvZHVjdFIHcHJvZHVjdA==');

@$core.Deprecated('Use getRequestDescriptor instead')
const GetRequest$json = {
  '1': 'GetRequest',
  '2': [
    {'1': 'product_id', '3': 1, '4': 1, '5': 9, '10': 'productId'},
  ],
};

/// Descriptor for `GetRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getRequestDescriptor = $convert.base64Decode(
    'CgpHZXRSZXF1ZXN0Eh0KCnByb2R1Y3RfaWQYASABKAlSCXByb2R1Y3RJZA==');

@$core.Deprecated('Use getResponseDescriptor instead')
const GetResponse$json = {
  '1': 'GetResponse',
  '2': [
    {
      '1': 'product',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.commerce.v1.Product',
      '10': 'product'
    },
  ],
};

/// Descriptor for `GetResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getResponseDescriptor = $convert.base64Decode(
    'CgtHZXRSZXNwb25zZRI6Cgdwcm9kdWN0GAEgASgLMiAuY3JlYXRpdmFudGEuY29tbWVyY2Uudj'
    'EuUHJvZHVjdFIHcHJvZHVjdA==');

@$core.Deprecated('Use listRequestDescriptor instead')
const ListRequest$json = {
  '1': 'ListRequest',
  '2': [
    {
      '1': 'pagination',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.Pagination',
      '10': 'pagination'
    },
    {
      '1': 'status_filter',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.creativanta.commerce.v1.CatalogStatus',
      '10': 'statusFilter'
    },
    {
      '1': 'type_filter',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.creativanta.commerce.v1.ProductType',
      '10': 'typeFilter'
    },
    {'1': 'category_filter', '3': 4, '4': 1, '5': 9, '10': 'categoryFilter'},
    {'1': 'search_query', '3': 5, '4': 1, '5': 9, '10': 'searchQuery'},
  ],
};

/// Descriptor for `ListRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listRequestDescriptor = $convert.base64Decode(
    'CgtMaXN0UmVxdWVzdBJBCgpwYWdpbmF0aW9uGAEgASgLMiEuY3JlYXRpdmFudGEuY29tbW9uLn'
    'YxLlBhZ2luYXRpb25SCnBhZ2luYXRpb24SSwoNc3RhdHVzX2ZpbHRlchgCIAEoDjImLmNyZWF0'
    'aXZhbnRhLmNvbW1lcmNlLnYxLkNhdGFsb2dTdGF0dXNSDHN0YXR1c0ZpbHRlchJFCgt0eXBlX2'
    'ZpbHRlchgDIAEoDjIkLmNyZWF0aXZhbnRhLmNvbW1lcmNlLnYxLlByb2R1Y3RUeXBlUgp0eXBl'
    'RmlsdGVyEicKD2NhdGVnb3J5X2ZpbHRlchgEIAEoCVIOY2F0ZWdvcnlGaWx0ZXISIQoMc2Vhcm'
    'NoX3F1ZXJ5GAUgASgJUgtzZWFyY2hRdWVyeQ==');

@$core.Deprecated('Use listResponseDescriptor instead')
const ListResponse$json = {
  '1': 'ListResponse',
  '2': [
    {
      '1': 'products',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.creativanta.commerce.v1.Product',
      '10': 'products'
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

/// Descriptor for `ListResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listResponseDescriptor = $convert.base64Decode(
    'CgxMaXN0UmVzcG9uc2USPAoIcHJvZHVjdHMYASADKAsyIC5jcmVhdGl2YW50YS5jb21tZXJjZS'
    '52MS5Qcm9kdWN0Ughwcm9kdWN0cxJICgpwYWdpbmF0aW9uGAIgASgLMiguY3JlYXRpdmFudGEu'
    'Y29tbW9uLnYxLlBhZ2luYXRlZFJlc3BvbnNlUgpwYWdpbmF0aW9u');

@$core.Deprecated('Use updateRequestDescriptor instead')
const UpdateRequest$json = {
  '1': 'UpdateRequest',
  '2': [
    {
      '1': 'context',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.CommandContext',
      '10': 'context'
    },
    {'1': 'product_id', '3': 2, '4': 1, '5': 9, '10': 'productId'},
    {'1': 'title', '3': 3, '4': 1, '5': 9, '9': 0, '10': 'title', '17': true},
    {
      '1': 'description',
      '3': 4,
      '4': 1,
      '5': 9,
      '9': 1,
      '10': 'description',
      '17': true
    },
    {
      '1': 'category',
      '3': 5,
      '4': 1,
      '5': 9,
      '9': 2,
      '10': 'category',
      '17': true
    },
    {
      '1': 'base_price',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.Money',
      '10': 'basePrice'
    },
    {
      '1': 'cogs',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.Money',
      '10': 'cogs'
    },
    {
      '1': 'catalog_status',
      '3': 8,
      '4': 1,
      '5': 14,
      '6': '.creativanta.commerce.v1.CatalogStatus',
      '9': 3,
      '10': 'catalogStatus',
      '17': true
    },
    {
      '1': 'inventory_enabled',
      '3': 9,
      '4': 1,
      '5': 8,
      '9': 4,
      '10': 'inventoryEnabled',
      '17': true
    },
    {
      '1': 'external_refs',
      '3': 10,
      '4': 3,
      '5': 11,
      '6': '.creativanta.commerce.v1.ExternalRef',
      '10': 'externalRefs'
    },
    {'1': 'images', '3': 11, '4': 3, '5': 9, '10': 'images'},
    {
      '1': 'metadata_json',
      '3': 12,
      '4': 1,
      '5': 9,
      '9': 5,
      '10': 'metadataJson',
      '17': true
    },
  ],
  '8': [
    {'1': '_title'},
    {'1': '_description'},
    {'1': '_category'},
    {'1': '_catalog_status'},
    {'1': '_inventory_enabled'},
    {'1': '_metadata_json'},
  ],
};

/// Descriptor for `UpdateRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateRequestDescriptor = $convert.base64Decode(
    'Cg1VcGRhdGVSZXF1ZXN0Ej8KB2NvbnRleHQYASABKAsyJS5jcmVhdGl2YW50YS5jb21tb24udj'
    'EuQ29tbWFuZENvbnRleHRSB2NvbnRleHQSHQoKcHJvZHVjdF9pZBgCIAEoCVIJcHJvZHVjdElk'
    'EhkKBXRpdGxlGAMgASgJSABSBXRpdGxliAEBEiUKC2Rlc2NyaXB0aW9uGAQgASgJSAFSC2Rlc2'
    'NyaXB0aW9uiAEBEh8KCGNhdGVnb3J5GAUgASgJSAJSCGNhdGVnb3J5iAEBEjsKCmJhc2VfcHJp'
    'Y2UYBiABKAsyHC5jcmVhdGl2YW50YS5jb21tb24udjEuTW9uZXlSCWJhc2VQcmljZRIwCgRjb2'
    'dzGAcgASgLMhwuY3JlYXRpdmFudGEuY29tbW9uLnYxLk1vbmV5UgRjb2dzElIKDmNhdGFsb2df'
    'c3RhdHVzGAggASgOMiYuY3JlYXRpdmFudGEuY29tbWVyY2UudjEuQ2F0YWxvZ1N0YXR1c0gDUg'
    '1jYXRhbG9nU3RhdHVziAEBEjAKEWludmVudG9yeV9lbmFibGVkGAkgASgISARSEGludmVudG9y'
    'eUVuYWJsZWSIAQESSQoNZXh0ZXJuYWxfcmVmcxgKIAMoCzIkLmNyZWF0aXZhbnRhLmNvbW1lcm'
    'NlLnYxLkV4dGVybmFsUmVmUgxleHRlcm5hbFJlZnMSFgoGaW1hZ2VzGAsgAygJUgZpbWFnZXMS'
    'KAoNbWV0YWRhdGFfanNvbhgMIAEoCUgFUgxtZXRhZGF0YUpzb26IAQFCCAoGX3RpdGxlQg4KDF'
    '9kZXNjcmlwdGlvbkILCglfY2F0ZWdvcnlCEQoPX2NhdGFsb2dfc3RhdHVzQhQKEl9pbnZlbnRv'
    'cnlfZW5hYmxlZEIQCg5fbWV0YWRhdGFfanNvbg==');

@$core.Deprecated('Use updateResponseDescriptor instead')
const UpdateResponse$json = {
  '1': 'UpdateResponse',
  '2': [
    {
      '1': 'product',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.commerce.v1.Product',
      '10': 'product'
    },
  ],
};

/// Descriptor for `UpdateResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateResponseDescriptor = $convert.base64Decode(
    'Cg5VcGRhdGVSZXNwb25zZRI6Cgdwcm9kdWN0GAEgASgLMiAuY3JlYXRpdmFudGEuY29tbWVyY2'
    'UudjEuUHJvZHVjdFIHcHJvZHVjdA==');

@$core.Deprecated('Use deleteRequestDescriptor instead')
const DeleteRequest$json = {
  '1': 'DeleteRequest',
  '2': [
    {
      '1': 'context',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.CommandContext',
      '10': 'context'
    },
    {'1': 'product_id', '3': 2, '4': 1, '5': 9, '10': 'productId'},
  ],
};

/// Descriptor for `DeleteRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deleteRequestDescriptor = $convert.base64Decode(
    'Cg1EZWxldGVSZXF1ZXN0Ej8KB2NvbnRleHQYASABKAsyJS5jcmVhdGl2YW50YS5jb21tb24udj'
    'EuQ29tbWFuZENvbnRleHRSB2NvbnRleHQSHQoKcHJvZHVjdF9pZBgCIAEoCVIJcHJvZHVjdElk');

@$core.Deprecated('Use deleteResponseDescriptor instead')
const DeleteResponse$json = {
  '1': 'DeleteResponse',
  '2': [
    {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
  ],
};

/// Descriptor for `DeleteResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deleteResponseDescriptor = $convert
    .base64Decode('Cg5EZWxldGVSZXNwb25zZRIYCgdzdWNjZXNzGAEgASgIUgdzdWNjZXNz');

@$core.Deprecated('Use archiveRequestDescriptor instead')
const ArchiveRequest$json = {
  '1': 'ArchiveRequest',
  '2': [
    {
      '1': 'context',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.CommandContext',
      '10': 'context'
    },
    {'1': 'product_id', '3': 2, '4': 1, '5': 9, '10': 'productId'},
  ],
};

/// Descriptor for `ArchiveRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List archiveRequestDescriptor = $convert.base64Decode(
    'Cg5BcmNoaXZlUmVxdWVzdBI/Cgdjb250ZXh0GAEgASgLMiUuY3JlYXRpdmFudGEuY29tbW9uLn'
    'YxLkNvbW1hbmRDb250ZXh0Ugdjb250ZXh0Eh0KCnByb2R1Y3RfaWQYAiABKAlSCXByb2R1Y3RJ'
    'ZA==');

@$core.Deprecated('Use archiveResponseDescriptor instead')
const ArchiveResponse$json = {
  '1': 'ArchiveResponse',
  '2': [
    {
      '1': 'product',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.commerce.v1.Product',
      '10': 'product'
    },
  ],
};

/// Descriptor for `ArchiveResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List archiveResponseDescriptor = $convert.base64Decode(
    'Cg9BcmNoaXZlUmVzcG9uc2USOgoHcHJvZHVjdBgBIAEoCzIgLmNyZWF0aXZhbnRhLmNvbW1lcm'
    'NlLnYxLlByb2R1Y3RSB3Byb2R1Y3Q=');

@$core.Deprecated('Use batchTagRequestDescriptor instead')
const BatchTagRequest$json = {
  '1': 'BatchTagRequest',
  '2': [
    {
      '1': 'context',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.CommandContext',
      '10': 'context'
    },
    {'1': 'product_ids', '3': 2, '4': 3, '5': 9, '10': 'productIds'},
    {'1': 'tags_to_add', '3': 3, '4': 3, '5': 9, '10': 'tagsToAdd'},
    {'1': 'tags_to_remove', '3': 4, '4': 3, '5': 9, '10': 'tagsToRemove'},
  ],
};

/// Descriptor for `BatchTagRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List batchTagRequestDescriptor = $convert.base64Decode(
    'Cg9CYXRjaFRhZ1JlcXVlc3QSPwoHY29udGV4dBgBIAEoCzIlLmNyZWF0aXZhbnRhLmNvbW1vbi'
    '52MS5Db21tYW5kQ29udGV4dFIHY29udGV4dBIfCgtwcm9kdWN0X2lkcxgCIAMoCVIKcHJvZHVj'
    'dElkcxIeCgt0YWdzX3RvX2FkZBgDIAMoCVIJdGFnc1RvQWRkEiQKDnRhZ3NfdG9fcmVtb3ZlGA'
    'QgAygJUgx0YWdzVG9SZW1vdmU=');

@$core.Deprecated('Use batchTagResponseDescriptor instead')
const BatchTagResponse$json = {
  '1': 'BatchTagResponse',
  '2': [
    {'1': 'updated_count', '3': 1, '4': 1, '5': 5, '10': 'updatedCount'},
  ],
};

/// Descriptor for `BatchTagResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List batchTagResponseDescriptor = $convert.base64Decode(
    'ChBCYXRjaFRhZ1Jlc3BvbnNlEiMKDXVwZGF0ZWRfY291bnQYASABKAVSDHVwZGF0ZWRDb3VudA'
    '==');

@$core.Deprecated('Use importRowResultDescriptor instead')
const ImportRowResult$json = {
  '1': 'ImportRowResult',
  '2': [
    {'1': 'row_number', '3': 1, '4': 1, '5': 5, '10': 'rowNumber'},
    {'1': 'source_id', '3': 2, '4': 1, '5': 9, '10': 'sourceId'},
    {'1': 'title', '3': 3, '4': 1, '5': 9, '10': 'title'},
    {'1': 'action', '3': 4, '4': 1, '5': 9, '10': 'action'},
    {'1': 'error_message', '3': 5, '4': 1, '5': 9, '10': 'errorMessage'},
    {'1': 'product_id', '3': 6, '4': 1, '5': 9, '10': 'productId'},
    {'1': 'sku_code', '3': 7, '4': 1, '5': 9, '10': 'skuCode'},
  ],
};

/// Descriptor for `ImportRowResult`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List importRowResultDescriptor = $convert.base64Decode(
    'Cg9JbXBvcnRSb3dSZXN1bHQSHQoKcm93X251bWJlchgBIAEoBVIJcm93TnVtYmVyEhsKCXNvdX'
    'JjZV9pZBgCIAEoCVIIc291cmNlSWQSFAoFdGl0bGUYAyABKAlSBXRpdGxlEhYKBmFjdGlvbhgE'
    'IAEoCVIGYWN0aW9uEiMKDWVycm9yX21lc3NhZ2UYBSABKAlSDGVycm9yTWVzc2FnZRIdCgpwcm'
    '9kdWN0X2lkGAYgASgJUglwcm9kdWN0SWQSGQoIc2t1X2NvZGUYByABKAlSB3NrdUNvZGU=');

@$core.Deprecated('Use importRequestDescriptor instead')
const ImportRequest$json = {
  '1': 'ImportRequest',
  '2': [
    {
      '1': 'context',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.CommandContext',
      '10': 'context'
    },
    {'1': 'source_platform', '3': 2, '4': 1, '5': 9, '10': 'sourcePlatform'},
    {
      '1': 'connected_account_id',
      '3': 3,
      '4': 1,
      '5': 9,
      '10': 'connectedAccountId'
    },
    {'1': 'raw_data', '3': 4, '4': 1, '5': 9, '10': 'rawData'},
    {'1': 'file_name', '3': 5, '4': 1, '5': 9, '10': 'fileName'},
    {
      '1': 'column_mappings',
      '3': 6,
      '4': 3,
      '5': 11,
      '6': '.creativanta.commerce.v1.ImportRequest.ColumnMappingsEntry',
      '10': 'columnMappings'
    },
    {'1': 'default_currency', '3': 7, '4': 1, '5': 9, '10': 'defaultCurrency'},
    {'1': 'preview_only', '3': 8, '4': 1, '5': 8, '10': 'previewOnly'},
    {'1': 'preview_token', '3': 9, '4': 1, '5': 9, '10': 'previewToken'},
    {'1': 'dry_run', '3': 10, '4': 1, '5': 8, '10': 'dryRun'},
  ],
  '3': [ImportRequest_ColumnMappingsEntry$json],
};

@$core.Deprecated('Use importRequestDescriptor instead')
const ImportRequest_ColumnMappingsEntry$json = {
  '1': 'ColumnMappingsEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {'1': 'value', '3': 2, '4': 1, '5': 9, '10': 'value'},
  ],
  '7': {'7': true},
};

/// Descriptor for `ImportRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List importRequestDescriptor = $convert.base64Decode(
    'Cg1JbXBvcnRSZXF1ZXN0Ej8KB2NvbnRleHQYASABKAsyJS5jcmVhdGl2YW50YS5jb21tb24udj'
    'EuQ29tbWFuZENvbnRleHRSB2NvbnRleHQSJwoPc291cmNlX3BsYXRmb3JtGAIgASgJUg5zb3Vy'
    'Y2VQbGF0Zm9ybRIwChRjb25uZWN0ZWRfYWNjb3VudF9pZBgDIAEoCVISY29ubmVjdGVkQWNjb3'
    'VudElkEhkKCHJhd19kYXRhGAQgASgJUgdyYXdEYXRhEhsKCWZpbGVfbmFtZRgFIAEoCVIIZmls'
    'ZU5hbWUSYwoPY29sdW1uX21hcHBpbmdzGAYgAygLMjouY3JlYXRpdmFudGEuY29tbWVyY2Uudj'
    'EuSW1wb3J0UmVxdWVzdC5Db2x1bW5NYXBwaW5nc0VudHJ5Ug5jb2x1bW5NYXBwaW5ncxIpChBk'
    'ZWZhdWx0X2N1cnJlbmN5GAcgASgJUg9kZWZhdWx0Q3VycmVuY3kSIQoMcHJldmlld19vbmx5GA'
    'ggASgIUgtwcmV2aWV3T25seRIjCg1wcmV2aWV3X3Rva2VuGAkgASgJUgxwcmV2aWV3VG9rZW4S'
    'FwoHZHJ5X3J1bhgKIAEoCFIGZHJ5UnVuGkEKE0NvbHVtbk1hcHBpbmdzRW50cnkSEAoDa2V5GA'
    'EgASgJUgNrZXkSFAoFdmFsdWUYAiABKAlSBXZhbHVlOgI4AQ==');

@$core.Deprecated('Use importResponseDescriptor instead')
const ImportResponse$json = {
  '1': 'ImportResponse',
  '2': [
    {'1': 'is_preview', '3': 1, '4': 1, '5': 8, '10': 'isPreview'},
    {'1': 'preview_token', '3': 2, '4': 1, '5': 9, '10': 'previewToken'},
    {'1': 'total_rows', '3': 3, '4': 1, '5': 5, '10': 'totalRows'},
    {'1': 'create_count', '3': 4, '4': 1, '5': 5, '10': 'createCount'},
    {'1': 'update_count', '3': 5, '4': 1, '5': 5, '10': 'updateCount'},
    {'1': 'unchanged_count', '3': 6, '4': 1, '5': 5, '10': 'unchangedCount'},
    {'1': 'error_count', '3': 7, '4': 1, '5': 5, '10': 'errorCount'},
    {
      '1': 'requires_mapping_correction',
      '3': 8,
      '4': 1,
      '5': 8,
      '10': 'requiresMappingCorrection'
    },
    {'1': 'mapping_errors', '3': 9, '4': 3, '5': 9, '10': 'mappingErrors'},
    {
      '1': 'rows',
      '3': 10,
      '4': 3,
      '5': 11,
      '6': '.creativanta.commerce.v1.ImportRowResult',
      '10': 'rows'
    },
    {
      '1': 'created_products',
      '3': 11,
      '4': 3,
      '5': 11,
      '6': '.creativanta.commerce.v1.Product',
      '10': 'createdProducts'
    },
    {
      '1': 'import_fingerprint',
      '3': 12,
      '4': 1,
      '5': 9,
      '10': 'importFingerprint'
    },
    {
      '1': 'downloadable_error_csv',
      '3': 13,
      '4': 1,
      '5': 9,
      '10': 'downloadableErrorCsv'
    },
  ],
};

/// Descriptor for `ImportResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List importResponseDescriptor = $convert.base64Decode(
    'Cg5JbXBvcnRSZXNwb25zZRIdCgppc19wcmV2aWV3GAEgASgIUglpc1ByZXZpZXcSIwoNcHJldm'
    'lld190b2tlbhgCIAEoCVIMcHJldmlld1Rva2VuEh0KCnRvdGFsX3Jvd3MYAyABKAVSCXRvdGFs'
    'Um93cxIhCgxjcmVhdGVfY291bnQYBCABKAVSC2NyZWF0ZUNvdW50EiEKDHVwZGF0ZV9jb3VudB'
    'gFIAEoBVILdXBkYXRlQ291bnQSJwoPdW5jaGFuZ2VkX2NvdW50GAYgASgFUg51bmNoYW5nZWRD'
    'b3VudBIfCgtlcnJvcl9jb3VudBgHIAEoBVIKZXJyb3JDb3VudBI+ChtyZXF1aXJlc19tYXBwaW'
    '5nX2NvcnJlY3Rpb24YCCABKAhSGXJlcXVpcmVzTWFwcGluZ0NvcnJlY3Rpb24SJQoObWFwcGlu'
    'Z19lcnJvcnMYCSADKAlSDW1hcHBpbmdFcnJvcnMSPAoEcm93cxgKIAMoCzIoLmNyZWF0aXZhbn'
    'RhLmNvbW1lcmNlLnYxLkltcG9ydFJvd1Jlc3VsdFIEcm93cxJLChBjcmVhdGVkX3Byb2R1Y3Rz'
    'GAsgAygLMiAuY3JlYXRpdmFudGEuY29tbWVyY2UudjEuUHJvZHVjdFIPY3JlYXRlZFByb2R1Y3'
    'RzEi0KEmltcG9ydF9maW5nZXJwcmludBgMIAEoCVIRaW1wb3J0RmluZ2VycHJpbnQSNAoWZG93'
    'bmxvYWRhYmxlX2Vycm9yX2NzdhgNIAEoCVIUZG93bmxvYWRhYmxlRXJyb3JDc3Y=');

@$core.Deprecated('Use searchRequestDescriptor instead')
const SearchRequest$json = {
  '1': 'SearchRequest',
  '2': [
    {'1': 'query', '3': 1, '4': 1, '5': 9, '10': 'query'},
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

/// Descriptor for `SearchRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List searchRequestDescriptor = $convert.base64Decode(
    'Cg1TZWFyY2hSZXF1ZXN0EhQKBXF1ZXJ5GAEgASgJUgVxdWVyeRJBCgpwYWdpbmF0aW9uGAIgAS'
    'gLMiEuY3JlYXRpdmFudGEuY29tbW9uLnYxLlBhZ2luYXRpb25SCnBhZ2luYXRpb24=');

@$core.Deprecated('Use searchResponseDescriptor instead')
const SearchResponse$json = {
  '1': 'SearchResponse',
  '2': [
    {
      '1': 'products',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.creativanta.commerce.v1.Product',
      '10': 'products'
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

/// Descriptor for `SearchResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List searchResponseDescriptor = $convert.base64Decode(
    'Cg5TZWFyY2hSZXNwb25zZRI8Cghwcm9kdWN0cxgBIAMoCzIgLmNyZWF0aXZhbnRhLmNvbW1lcm'
    'NlLnYxLlByb2R1Y3RSCHByb2R1Y3RzEkgKCnBhZ2luYXRpb24YAiABKAsyKC5jcmVhdGl2YW50'
    'YS5jb21tb24udjEuUGFnaW5hdGVkUmVzcG9uc2VSCnBhZ2luYXRpb24=');

@$core.Deprecated('Use getStatsRequestDescriptor instead')
const GetStatsRequest$json = {
  '1': 'GetStatsRequest',
  '2': [
    {'1': 'product_id', '3': 1, '4': 1, '5': 9, '10': 'productId'},
  ],
};

/// Descriptor for `GetStatsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getStatsRequestDescriptor = $convert.base64Decode(
    'Cg9HZXRTdGF0c1JlcXVlc3QSHQoKcHJvZHVjdF9pZBgBIAEoCVIJcHJvZHVjdElk');

@$core.Deprecated('Use getStatsResponseDescriptor instead')
const GetStatsResponse$json = {
  '1': 'GetStatsResponse',
  '2': [
    {'1': 'product_id', '3': 1, '4': 1, '5': 9, '10': 'productId'},
    {'1': 'total_orders', '3': 2, '4': 1, '5': 5, '10': 'totalOrders'},
    {
      '1': 'total_revenue',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.Money',
      '10': 'totalRevenue'
    },
    {'1': 'active_skus_count', '3': 4, '4': 1, '5': 5, '10': 'activeSkusCount'},
    {'1': 'on_hand_stock', '3': 5, '4': 1, '5': 5, '10': 'onHandStock'},
    {'1': 'reserved_stock', '3': 6, '4': 1, '5': 5, '10': 'reservedStock'},
  ],
};

/// Descriptor for `GetStatsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getStatsResponseDescriptor = $convert.base64Decode(
    'ChBHZXRTdGF0c1Jlc3BvbnNlEh0KCnByb2R1Y3RfaWQYASABKAlSCXByb2R1Y3RJZBIhCgx0b3'
    'RhbF9vcmRlcnMYAiABKAVSC3RvdGFsT3JkZXJzEkEKDXRvdGFsX3JldmVudWUYAyABKAsyHC5j'
    'cmVhdGl2YW50YS5jb21tb24udjEuTW9uZXlSDHRvdGFsUmV2ZW51ZRIqChFhY3RpdmVfc2t1c1'
    '9jb3VudBgEIAEoBVIPYWN0aXZlU2t1c0NvdW50EiIKDW9uX2hhbmRfc3RvY2sYBSABKAVSC29u'
    'SGFuZFN0b2NrEiUKDnJlc2VydmVkX3N0b2NrGAYgASgFUg1yZXNlcnZlZFN0b2Nr');

@$core.Deprecated('Use getSalesStatsRequestDescriptor instead')
const GetSalesStatsRequest$json = {
  '1': 'GetSalesStatsRequest',
  '2': [
    {'1': 'product_id', '3': 1, '4': 1, '5': 9, '10': 'productId'},
    {'1': 'period', '3': 2, '4': 1, '5': 9, '10': 'period'},
  ],
};

/// Descriptor for `GetSalesStatsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getSalesStatsRequestDescriptor = $convert.base64Decode(
    'ChRHZXRTYWxlc1N0YXRzUmVxdWVzdBIdCgpwcm9kdWN0X2lkGAEgASgJUglwcm9kdWN0SWQSFg'
    'oGcGVyaW9kGAIgASgJUgZwZXJpb2Q=');

@$core.Deprecated('Use getSalesStatsResponseDescriptor instead')
const GetSalesStatsResponse$json = {
  '1': 'GetSalesStatsResponse',
  '2': [
    {'1': 'product_id', '3': 1, '4': 1, '5': 9, '10': 'productId'},
    {
      '1': 'gross_sales',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.Money',
      '10': 'grossSales'
    },
    {
      '1': 'net_sales',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.Money',
      '10': 'netSales'
    },
    {'1': 'units_sold', '3': 4, '4': 1, '5': 5, '10': 'unitsSold'},
    {'1': 'refund_count', '3': 5, '4': 1, '5': 5, '10': 'refundCount'},
  ],
};

/// Descriptor for `GetSalesStatsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getSalesStatsResponseDescriptor = $convert.base64Decode(
    'ChVHZXRTYWxlc1N0YXRzUmVzcG9uc2USHQoKcHJvZHVjdF9pZBgBIAEoCVIJcHJvZHVjdElkEj'
    '0KC2dyb3NzX3NhbGVzGAIgASgLMhwuY3JlYXRpdmFudGEuY29tbW9uLnYxLk1vbmV5Ugpncm9z'
    'c1NhbGVzEjkKCW5ldF9zYWxlcxgDIAEoCzIcLmNyZWF0aXZhbnRhLmNvbW1vbi52MS5Nb25leV'
    'IIbmV0U2FsZXMSHQoKdW5pdHNfc29sZBgEIAEoBVIJdW5pdHNTb2xkEiEKDHJlZnVuZF9jb3Vu'
    'dBgFIAEoBVILcmVmdW5kQ291bnQ=');

@$core.Deprecated('Use salesChartPointDescriptor instead')
const SalesChartPoint$json = {
  '1': 'SalesChartPoint',
  '2': [
    {'1': 'timestamp', '3': 1, '4': 1, '5': 9, '10': 'timestamp'},
    {
      '1': 'amount',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.Money',
      '10': 'amount'
    },
    {'1': 'order_count', '3': 3, '4': 1, '5': 5, '10': 'orderCount'},
  ],
};

/// Descriptor for `SalesChartPoint`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List salesChartPointDescriptor = $convert.base64Decode(
    'Cg9TYWxlc0NoYXJ0UG9pbnQSHAoJdGltZXN0YW1wGAEgASgJUgl0aW1lc3RhbXASNAoGYW1vdW'
    '50GAIgASgLMhwuY3JlYXRpdmFudGEuY29tbW9uLnYxLk1vbmV5UgZhbW91bnQSHwoLb3JkZXJf'
    'Y291bnQYAyABKAVSCm9yZGVyQ291bnQ=');

@$core.Deprecated('Use getSalesChartRequestDescriptor instead')
const GetSalesChartRequest$json = {
  '1': 'GetSalesChartRequest',
  '2': [
    {'1': 'product_id', '3': 1, '4': 1, '5': 9, '10': 'productId'},
    {'1': 'interval', '3': 2, '4': 1, '5': 9, '10': 'interval'},
  ],
};

/// Descriptor for `GetSalesChartRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getSalesChartRequestDescriptor = $convert.base64Decode(
    'ChRHZXRTYWxlc0NoYXJ0UmVxdWVzdBIdCgpwcm9kdWN0X2lkGAEgASgJUglwcm9kdWN0SWQSGg'
    'oIaW50ZXJ2YWwYAiABKAlSCGludGVydmFs');

@$core.Deprecated('Use getSalesChartResponseDescriptor instead')
const GetSalesChartResponse$json = {
  '1': 'GetSalesChartResponse',
  '2': [
    {'1': 'product_id', '3': 1, '4': 1, '5': 9, '10': 'productId'},
    {
      '1': 'data_points',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.creativanta.commerce.v1.SalesChartPoint',
      '10': 'dataPoints'
    },
  ],
};

/// Descriptor for `GetSalesChartResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getSalesChartResponseDescriptor = $convert.base64Decode(
    'ChVHZXRTYWxlc0NoYXJ0UmVzcG9uc2USHQoKcHJvZHVjdF9pZBgBIAEoCVIJcHJvZHVjdElkEk'
    'kKC2RhdGFfcG9pbnRzGAIgAygLMiguY3JlYXRpdmFudGEuY29tbWVyY2UudjEuU2FsZXNDaGFy'
    'dFBvaW50UgpkYXRhUG9pbnRz');

@$core.Deprecated('Use productReviewItemDescriptor instead')
const ProductReviewItem$json = {
  '1': 'ProductReviewItem',
  '2': [
    {'1': 'review_id', '3': 1, '4': 1, '5': 9, '10': 'reviewId'},
    {'1': 'author_name', '3': 2, '4': 1, '5': 9, '10': 'authorName'},
    {'1': 'rating', '3': 3, '4': 1, '5': 5, '10': 'rating'},
    {'1': 'comment', '3': 4, '4': 1, '5': 9, '10': 'comment'},
    {
      '1': 'created_at',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'createdAt'
    },
  ],
};

/// Descriptor for `ProductReviewItem`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List productReviewItemDescriptor = $convert.base64Decode(
    'ChFQcm9kdWN0UmV2aWV3SXRlbRIbCglyZXZpZXdfaWQYASABKAlSCHJldmlld0lkEh8KC2F1dG'
    'hvcl9uYW1lGAIgASgJUgphdXRob3JOYW1lEhYKBnJhdGluZxgDIAEoBVIGcmF0aW5nEhgKB2Nv'
    'bW1lbnQYBCABKAlSB2NvbW1lbnQSOQoKY3JlYXRlZF9hdBgFIAEoCzIaLmdvb2dsZS5wcm90b2'
    'J1Zi5UaW1lc3RhbXBSCWNyZWF0ZWRBdA==');

@$core.Deprecated('Use getReviewsRequestDescriptor instead')
const GetReviewsRequest$json = {
  '1': 'GetReviewsRequest',
  '2': [
    {'1': 'product_id', '3': 1, '4': 1, '5': 9, '10': 'productId'},
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

/// Descriptor for `GetReviewsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getReviewsRequestDescriptor = $convert.base64Decode(
    'ChFHZXRSZXZpZXdzUmVxdWVzdBIdCgpwcm9kdWN0X2lkGAEgASgJUglwcm9kdWN0SWQSQQoKcG'
    'FnaW5hdGlvbhgCIAEoCzIhLmNyZWF0aXZhbnRhLmNvbW1vbi52MS5QYWdpbmF0aW9uUgpwYWdp'
    'bmF0aW9u');

@$core.Deprecated('Use getReviewsResponseDescriptor instead')
const GetReviewsResponse$json = {
  '1': 'GetReviewsResponse',
  '2': [
    {'1': 'product_id', '3': 1, '4': 1, '5': 9, '10': 'productId'},
    {
      '1': 'reviews',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.creativanta.commerce.v1.ProductReviewItem',
      '10': 'reviews'
    },
    {
      '1': 'pagination',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.PaginatedResponse',
      '10': 'pagination'
    },
  ],
};

/// Descriptor for `GetReviewsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getReviewsResponseDescriptor = $convert.base64Decode(
    'ChJHZXRSZXZpZXdzUmVzcG9uc2USHQoKcHJvZHVjdF9pZBgBIAEoCVIJcHJvZHVjdElkEkQKB3'
    'Jldmlld3MYAiADKAsyKi5jcmVhdGl2YW50YS5jb21tZXJjZS52MS5Qcm9kdWN0UmV2aWV3SXRl'
    'bVIHcmV2aWV3cxJICgpwYWdpbmF0aW9uGAMgASgLMiguY3JlYXRpdmFudGEuY29tbW9uLnYxLl'
    'BhZ2luYXRlZFJlc3BvbnNlUgpwYWdpbmF0aW9u');

@$core.Deprecated('Use getRankRequestDescriptor instead')
const GetRankRequest$json = {
  '1': 'GetRankRequest',
  '2': [
    {'1': 'product_id', '3': 1, '4': 1, '5': 9, '10': 'productId'},
    {'1': 'category', '3': 2, '4': 1, '5': 9, '10': 'category'},
  ],
};

/// Descriptor for `GetRankRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getRankRequestDescriptor = $convert.base64Decode(
    'Cg5HZXRSYW5rUmVxdWVzdBIdCgpwcm9kdWN0X2lkGAEgASgJUglwcm9kdWN0SWQSGgoIY2F0ZW'
    'dvcnkYAiABKAlSCGNhdGVnb3J5');

@$core.Deprecated('Use getRankResponseDescriptor instead')
const GetRankResponse$json = {
  '1': 'GetRankResponse',
  '2': [
    {'1': 'product_id', '3': 1, '4': 1, '5': 9, '10': 'productId'},
    {'1': 'rank_in_category', '3': 2, '4': 1, '5': 5, '10': 'rankInCategory'},
    {'1': 'rank_in_workspace', '3': 3, '4': 1, '5': 5, '10': 'rankInWorkspace'},
  ],
};

/// Descriptor for `GetRankResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getRankResponseDescriptor = $convert.base64Decode(
    'Cg9HZXRSYW5rUmVzcG9uc2USHQoKcHJvZHVjdF9pZBgBIAEoCVIJcHJvZHVjdElkEigKEHJhbm'
    'tfaW5fY2F0ZWdvcnkYAiABKAVSDnJhbmtJbkNhdGVnb3J5EioKEXJhbmtfaW5fd29ya3NwYWNl'
    'GAMgASgFUg9yYW5rSW5Xb3Jrc3BhY2U=');

@$core.Deprecated('Use getLinkedContentRequestDescriptor instead')
const GetLinkedContentRequest$json = {
  '1': 'GetLinkedContentRequest',
  '2': [
    {'1': 'product_id', '3': 1, '4': 1, '5': 9, '10': 'productId'},
  ],
};

/// Descriptor for `GetLinkedContentRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getLinkedContentRequestDescriptor =
    $convert.base64Decode(
        'ChdHZXRMaW5rZWRDb250ZW50UmVxdWVzdBIdCgpwcm9kdWN0X2lkGAEgASgJUglwcm9kdWN0SW'
        'Q=');

@$core.Deprecated('Use getLinkedContentResponseDescriptor instead')
const GetLinkedContentResponse$json = {
  '1': 'GetLinkedContentResponse',
  '2': [
    {'1': 'product_id', '3': 1, '4': 1, '5': 9, '10': 'productId'},
    {
      '1': 'linked_contents',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.creativanta.commerce.v1.ContentRef',
      '10': 'linkedContents'
    },
  ],
};

/// Descriptor for `GetLinkedContentResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getLinkedContentResponseDescriptor = $convert.base64Decode(
    'ChhHZXRMaW5rZWRDb250ZW50UmVzcG9uc2USHQoKcHJvZHVjdF9pZBgBIAEoCVIJcHJvZHVjdE'
    'lkEkwKD2xpbmtlZF9jb250ZW50cxgCIAMoCzIjLmNyZWF0aXZhbnRhLmNvbW1lcmNlLnYxLkNv'
    'bnRlbnRSZWZSDmxpbmtlZENvbnRlbnRz');

@$core.Deprecated('Use linkContentRequestDescriptor instead')
const LinkContentRequest$json = {
  '1': 'LinkContentRequest',
  '2': [
    {
      '1': 'context',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.CommandContext',
      '10': 'context'
    },
    {'1': 'product_id', '3': 2, '4': 1, '5': 9, '10': 'productId'},
    {'1': 'content_id', '3': 3, '4': 1, '5': 9, '10': 'contentId'},
    {'1': 'content_type', '3': 4, '4': 1, '5': 9, '10': 'contentType'},
    {'1': 'title', '3': 5, '4': 1, '5': 9, '10': 'title'},
    {'1': 'url', '3': 6, '4': 1, '5': 9, '10': 'url'},
    {'1': 'metadata_json', '3': 7, '4': 1, '5': 9, '10': 'metadataJson'},
  ],
};

/// Descriptor for `LinkContentRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List linkContentRequestDescriptor = $convert.base64Decode(
    'ChJMaW5rQ29udGVudFJlcXVlc3QSPwoHY29udGV4dBgBIAEoCzIlLmNyZWF0aXZhbnRhLmNvbW'
    '1vbi52MS5Db21tYW5kQ29udGV4dFIHY29udGV4dBIdCgpwcm9kdWN0X2lkGAIgASgJUglwcm9k'
    'dWN0SWQSHQoKY29udGVudF9pZBgDIAEoCVIJY29udGVudElkEiEKDGNvbnRlbnRfdHlwZRgEIA'
    'EoCVILY29udGVudFR5cGUSFAoFdGl0bGUYBSABKAlSBXRpdGxlEhAKA3VybBgGIAEoCVIDdXJs'
    'EiMKDW1ldGFkYXRhX2pzb24YByABKAlSDG1ldGFkYXRhSnNvbg==');

@$core.Deprecated('Use linkContentResponseDescriptor instead')
const LinkContentResponse$json = {
  '1': 'LinkContentResponse',
  '2': [
    {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
    {
      '1': 'linked_content',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.creativanta.commerce.v1.ContentRef',
      '10': 'linkedContent'
    },
  ],
};

/// Descriptor for `LinkContentResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List linkContentResponseDescriptor = $convert.base64Decode(
    'ChNMaW5rQ29udGVudFJlc3BvbnNlEhgKB3N1Y2Nlc3MYASABKAhSB3N1Y2Nlc3MSSgoObGlua2'
    'VkX2NvbnRlbnQYAiABKAsyIy5jcmVhdGl2YW50YS5jb21tZXJjZS52MS5Db250ZW50UmVmUg1s'
    'aW5rZWRDb250ZW50');

@$core.Deprecated('Use updateStockRequestDescriptor instead')
const UpdateStockRequest$json = {
  '1': 'UpdateStockRequest',
  '2': [
    {
      '1': 'context',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.CommandContext',
      '10': 'context'
    },
    {'1': 'product_id', '3': 2, '4': 1, '5': 9, '10': 'productId'},
    {'1': 'sku_id', '3': 3, '4': 1, '5': 9, '10': 'skuId'},
    {'1': 'delta_quantity', '3': 4, '4': 1, '5': 5, '10': 'deltaQuantity'},
    {'1': 'reason', '3': 5, '4': 1, '5': 9, '10': 'reason'},
  ],
};

/// Descriptor for `UpdateStockRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateStockRequestDescriptor = $convert.base64Decode(
    'ChJVcGRhdGVTdG9ja1JlcXVlc3QSPwoHY29udGV4dBgBIAEoCzIlLmNyZWF0aXZhbnRhLmNvbW'
    '1vbi52MS5Db21tYW5kQ29udGV4dFIHY29udGV4dBIdCgpwcm9kdWN0X2lkGAIgASgJUglwcm9k'
    'dWN0SWQSFQoGc2t1X2lkGAMgASgJUgVza3VJZBIlCg5kZWx0YV9xdWFudGl0eRgEIAEoBVINZG'
    'VsdGFRdWFudGl0eRIWCgZyZWFzb24YBSABKAlSBnJlYXNvbg==');

@$core.Deprecated('Use updateStockResponseDescriptor instead')
const UpdateStockResponse$json = {
  '1': 'UpdateStockResponse',
  '2': [
    {'1': 'sku_id', '3': 1, '4': 1, '5': 9, '10': 'skuId'},
    {
      '1': 'new_stock_quantity',
      '3': 2,
      '4': 1,
      '5': 5,
      '10': 'newStockQuantity'
    },
  ],
};

/// Descriptor for `UpdateStockResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateStockResponseDescriptor = $convert.base64Decode(
    'ChNVcGRhdGVTdG9ja1Jlc3BvbnNlEhUKBnNrdV9pZBgBIAEoCVIFc2t1SWQSLAoSbmV3X3N0b2'
    'NrX3F1YW50aXR5GAIgASgFUhBuZXdTdG9ja1F1YW50aXR5');

@$core.Deprecated('Use setAlertThresholdRequestDescriptor instead')
const SetAlertThresholdRequest$json = {
  '1': 'SetAlertThresholdRequest',
  '2': [
    {
      '1': 'context',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.CommandContext',
      '10': 'context'
    },
    {'1': 'product_id', '3': 2, '4': 1, '5': 9, '10': 'productId'},
    {'1': 'sku_id', '3': 3, '4': 1, '5': 9, '10': 'skuId'},
    {
      '1': 'low_stock_threshold',
      '3': 4,
      '4': 1,
      '5': 5,
      '10': 'lowStockThreshold'
    },
  ],
};

/// Descriptor for `SetAlertThresholdRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List setAlertThresholdRequestDescriptor = $convert.base64Decode(
    'ChhTZXRBbGVydFRocmVzaG9sZFJlcXVlc3QSPwoHY29udGV4dBgBIAEoCzIlLmNyZWF0aXZhbn'
    'RhLmNvbW1vbi52MS5Db21tYW5kQ29udGV4dFIHY29udGV4dBIdCgpwcm9kdWN0X2lkGAIgASgJ'
    'Uglwcm9kdWN0SWQSFQoGc2t1X2lkGAMgASgJUgVza3VJZBIuChNsb3dfc3RvY2tfdGhyZXNob2'
    'xkGAQgASgFUhFsb3dTdG9ja1RocmVzaG9sZA==');

@$core.Deprecated('Use setAlertThresholdResponseDescriptor instead')
const SetAlertThresholdResponse$json = {
  '1': 'SetAlertThresholdResponse',
  '2': [
    {'1': 'sku_id', '3': 1, '4': 1, '5': 9, '10': 'skuId'},
    {
      '1': 'low_stock_threshold',
      '3': 2,
      '4': 1,
      '5': 5,
      '10': 'lowStockThreshold'
    },
  ],
};

/// Descriptor for `SetAlertThresholdResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List setAlertThresholdResponseDescriptor =
    $convert.base64Decode(
        'ChlTZXRBbGVydFRocmVzaG9sZFJlc3BvbnNlEhUKBnNrdV9pZBgBIAEoCVIFc2t1SWQSLgoTbG'
        '93X3N0b2NrX3RocmVzaG9sZBgCIAEoBVIRbG93U3RvY2tUaHJlc2hvbGQ=');

@$core.Deprecated('Use bulkArchiveRequestDescriptor instead')
const BulkArchiveRequest$json = {
  '1': 'BulkArchiveRequest',
  '2': [
    {
      '1': 'context',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.CommandContext',
      '10': 'context'
    },
    {'1': 'product_ids', '3': 2, '4': 3, '5': 9, '10': 'productIds'},
  ],
};

/// Descriptor for `BulkArchiveRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List bulkArchiveRequestDescriptor = $convert.base64Decode(
    'ChJCdWxrQXJjaGl2ZVJlcXVlc3QSPwoHY29udGV4dBgBIAEoCzIlLmNyZWF0aXZhbnRhLmNvbW'
    '1vbi52MS5Db21tYW5kQ29udGV4dFIHY29udGV4dBIfCgtwcm9kdWN0X2lkcxgCIAMoCVIKcHJv'
    'ZHVjdElkcw==');

@$core.Deprecated('Use bulkArchiveResponseDescriptor instead')
const BulkArchiveResponse$json = {
  '1': 'BulkArchiveResponse',
  '2': [
    {'1': 'archived_count', '3': 1, '4': 1, '5': 5, '10': 'archivedCount'},
  ],
};

/// Descriptor for `BulkArchiveResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List bulkArchiveResponseDescriptor = $convert.base64Decode(
    'ChNCdWxrQXJjaGl2ZVJlc3BvbnNlEiUKDmFyY2hpdmVkX2NvdW50GAEgASgFUg1hcmNoaXZlZE'
    'NvdW50');

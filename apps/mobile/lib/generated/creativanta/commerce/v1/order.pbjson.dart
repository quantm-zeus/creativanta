// This is a generated file - do not edit.
//
// Generated from creativanta/commerce/v1/order.proto.

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

@$core.Deprecated('Use orderSourceClassDescriptor instead')
const OrderSourceClass$json = {
  '1': 'OrderSourceClass',
  '2': [
    {'1': 'ORDER_SOURCE_CLASS_UNSPECIFIED', '2': 0},
    {'1': 'ORDER_SOURCE_CLASS_OFFICIAL', '2': 1},
    {'1': 'ORDER_SOURCE_CLASS_IMPORTED', '2': 2},
    {'1': 'ORDER_SOURCE_CLASS_INFERRED', '2': 3},
    {'1': 'ORDER_SOURCE_CLASS_ESTIMATED', '2': 4},
    {'1': 'ORDER_SOURCE_CLASS_UNRECONCILED', '2': 5},
  ],
};

/// Descriptor for `OrderSourceClass`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List orderSourceClassDescriptor = $convert.base64Decode(
    'ChBPcmRlclNvdXJjZUNsYXNzEiIKHk9SREVSX1NPVVJDRV9DTEFTU19VTlNQRUNJRklFRBAAEh'
    '8KG09SREVSX1NPVVJDRV9DTEFTU19PRkZJQ0lBTBABEh8KG09SREVSX1NPVVJDRV9DTEFTU19J'
    'TVBPUlRFRBACEh8KG09SREVSX1NPVVJDRV9DTEFTU19JTkZFUlJFRBADEiAKHE9SREVSX1NPVV'
    'JDRV9DTEFTU19FU1RJTUFURUQQBBIjCh9PUkRFUl9TT1VSQ0VfQ0xBU1NfVU5SRUNPTkNJTEVE'
    'EAU=');

@$core.Deprecated('Use orderLifecycleStateDescriptor instead')
const OrderLifecycleState$json = {
  '1': 'OrderLifecycleState',
  '2': [
    {'1': 'ORDER_LIFECYCLE_STATE_UNSPECIFIED', '2': 0},
    {'1': 'ORDER_LIFECYCLE_STATE_CREATED', '2': 1},
    {'1': 'ORDER_LIFECYCLE_STATE_CONFIRMED', '2': 2},
    {'1': 'ORDER_LIFECYCLE_STATE_FULFILLED', '2': 3},
    {'1': 'ORDER_LIFECYCLE_STATE_COMPLETED', '2': 4},
    {'1': 'ORDER_LIFECYCLE_STATE_REFUNDED', '2': 5},
    {'1': 'ORDER_LIFECYCLE_STATE_PARTIALLY_REFUNDED', '2': 6},
    {'1': 'ORDER_LIFECYCLE_STATE_RETURNED', '2': 7},
    {'1': 'ORDER_LIFECYCLE_STATE_CANCELLED', '2': 8},
  ],
};

/// Descriptor for `OrderLifecycleState`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List orderLifecycleStateDescriptor = $convert.base64Decode(
    'ChNPcmRlckxpZmVjeWNsZVN0YXRlEiUKIU9SREVSX0xJRkVDWUNMRV9TVEFURV9VTlNQRUNJRk'
    'lFRBAAEiEKHU9SREVSX0xJRkVDWUNMRV9TVEFURV9DUkVBVEVEEAESIwofT1JERVJfTElGRUNZ'
    'Q0xFX1NUQVRFX0NPTkZJUk1FRBACEiMKH09SREVSX0xJRkVDWUNMRV9TVEFURV9GVUxGSUxMRU'
    'QQAxIjCh9PUkRFUl9MSUZFQ1lDTEVfU1RBVEVfQ09NUExFVEVEEAQSIgoeT1JERVJfTElGRUNZ'
    'Q0xFX1NUQVRFX1JFRlVOREVEEAUSLAooT1JERVJfTElGRUNZQ0xFX1NUQVRFX1BBUlRJQUxMWV'
    '9SRUZVTkRFRBAGEiIKHk9SREVSX0xJRkVDWUNMRV9TVEFURV9SRVRVUk5FRBAHEiMKH09SREVS'
    'X0xJRkVDWUNMRV9TVEFURV9DQU5DRUxMRUQQCA==');

@$core.Deprecated('Use refundLifecycleStateDescriptor instead')
const RefundLifecycleState$json = {
  '1': 'RefundLifecycleState',
  '2': [
    {'1': 'REFUND_LIFECYCLE_STATE_UNSPECIFIED', '2': 0},
    {'1': 'REFUND_LIFECYCLE_STATE_REQUESTED', '2': 1},
    {'1': 'REFUND_LIFECYCLE_STATE_APPROVED', '2': 2},
    {'1': 'REFUND_LIFECYCLE_STATE_REJECTED', '2': 3},
    {'1': 'REFUND_LIFECYCLE_STATE_PROCESSING', '2': 4},
    {'1': 'REFUND_LIFECYCLE_STATE_COMPLETED', '2': 5},
    {'1': 'REFUND_LIFECYCLE_STATE_FAILED', '2': 6},
    {'1': 'REFUND_LIFECYCLE_STATE_CANCELLED', '2': 7},
  ],
};

/// Descriptor for `RefundLifecycleState`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List refundLifecycleStateDescriptor = $convert.base64Decode(
    'ChRSZWZ1bmRMaWZlY3ljbGVTdGF0ZRImCiJSRUZVTkRfTElGRUNZQ0xFX1NUQVRFX1VOU1BFQ0'
    'lGSUVEEAASJAogUkVGVU5EX0xJRkVDWUNMRV9TVEFURV9SRVFVRVNURUQQARIjCh9SRUZVTkRf'
    'TElGRUNZQ0xFX1NUQVRFX0FQUFJPVkVEEAISIwofUkVGVU5EX0xJRkVDWUNMRV9TVEFURV9SRU'
    'pFQ1RFRBADEiUKIVJFRlVORF9MSUZFQ1lDTEVfU1RBVEVfUFJPQ0VTU0lORxAEEiQKIFJFRlVO'
    'RF9MSUZFQ1lDTEVfU1RBVEVfQ09NUExFVEVEEAUSIQodUkVGVU5EX0xJRkVDWUNMRV9TVEFURV'
    '9GQUlMRUQQBhIkCiBSRUZVTkRfTElGRUNZQ0xFX1NUQVRFX0NBTkNFTExFRBAH');

@$core.Deprecated('Use returnLifecycleStateDescriptor instead')
const ReturnLifecycleState$json = {
  '1': 'ReturnLifecycleState',
  '2': [
    {'1': 'RETURN_LIFECYCLE_STATE_UNSPECIFIED', '2': 0},
    {'1': 'RETURN_LIFECYCLE_STATE_INITIATED', '2': 1},
    {'1': 'RETURN_LIFECYCLE_STATE_APPROVED', '2': 2},
    {'1': 'RETURN_LIFECYCLE_STATE_SHIPPED_BACK', '2': 3},
    {'1': 'RETURN_LIFECYCLE_STATE_RECEIVED', '2': 4},
    {'1': 'RETURN_LIFECYCLE_STATE_INSPECTED', '2': 5},
    {'1': 'RETURN_LIFECYCLE_STATE_CLOSED', '2': 6},
    {'1': 'RETURN_LIFECYCLE_STATE_REJECTED', '2': 7},
  ],
};

/// Descriptor for `ReturnLifecycleState`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List returnLifecycleStateDescriptor = $convert.base64Decode(
    'ChRSZXR1cm5MaWZlY3ljbGVTdGF0ZRImCiJSRVRVUk5fTElGRUNZQ0xFX1NUQVRFX1VOU1BFQ0'
    'lGSUVEEAASJAogUkVUVVJOX0xJRkVDWUNMRV9TVEFURV9JTklUSUFURUQQARIjCh9SRVRVUk5f'
    'TElGRUNZQ0xFX1NUQVRFX0FQUFJPVkVEEAISJwojUkVUVVJOX0xJRkVDWUNMRV9TVEFURV9TSE'
    'lQUEVEX0JBQ0sQAxIjCh9SRVRVUk5fTElGRUNZQ0xFX1NUQVRFX1JFQ0VJVkVEEAQSJAogUkVU'
    'VVJOX0xJRkVDWUNMRV9TVEFURV9JTlNQRUNURUQQBRIhCh1SRVRVUk5fTElGRUNZQ0xFX1NUQV'
    'RFX0NMT1NFRBAGEiMKH1JFVFVSTl9MSUZFQ1lDTEVfU1RBVEVfUkVKRUNURUQQBw==');

@$core.Deprecated('Use stockMovementTypeDescriptor instead')
const StockMovementType$json = {
  '1': 'StockMovementType',
  '2': [
    {'1': 'STOCK_MOVEMENT_TYPE_UNSPECIFIED', '2': 0},
    {'1': 'STOCK_MOVEMENT_TYPE_PURCHASE', '2': 1},
    {'1': 'STOCK_MOVEMENT_TYPE_SALE', '2': 2},
    {'1': 'STOCK_MOVEMENT_TYPE_RETURN', '2': 3},
    {'1': 'STOCK_MOVEMENT_TYPE_ADJUSTMENT', '2': 4},
    {'1': 'STOCK_MOVEMENT_TYPE_TRANSFER', '2': 5},
    {'1': 'STOCK_MOVEMENT_TYPE_DAMAGE', '2': 6},
    {'1': 'STOCK_MOVEMENT_TYPE_PLATFORM_SYNC', '2': 7},
  ],
};

/// Descriptor for `StockMovementType`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List stockMovementTypeDescriptor = $convert.base64Decode(
    'ChFTdG9ja01vdmVtZW50VHlwZRIjCh9TVE9DS19NT1ZFTUVOVF9UWVBFX1VOU1BFQ0lGSUVEEA'
    'ASIAocU1RPQ0tfTU9WRU1FTlRfVFlQRV9QVVJDSEFTRRABEhwKGFNUT0NLX01PVkVNRU5UX1RZ'
    'UEVfU0FMRRACEh4KGlNUT0NLX01PVkVNRU5UX1RZUEVfUkVUVVJOEAMSIgoeU1RPQ0tfTU9WRU'
    '1FTlRfVFlQRV9BREpVU1RNRU5UEAQSIAocU1RPQ0tfTU9WRU1FTlRfVFlQRV9UUkFOU0ZFUhAF'
    'Eh4KGlNUT0NLX01PVkVNRU5UX1RZUEVfREFNQUdFEAYSJQohU1RPQ0tfTU9WRU1FTlRfVFlQRV'
    '9QTEFURk9STV9TWU5DEAc=');

@$core.Deprecated('Use stockReservationStatusDescriptor instead')
const StockReservationStatus$json = {
  '1': 'StockReservationStatus',
  '2': [
    {'1': 'STOCK_RESERVATION_STATUS_UNSPECIFIED', '2': 0},
    {'1': 'STOCK_RESERVATION_STATUS_HELD', '2': 1},
    {'1': 'STOCK_RESERVATION_STATUS_CONSUMED', '2': 2},
    {'1': 'STOCK_RESERVATION_STATUS_RELEASED', '2': 3},
    {'1': 'STOCK_RESERVATION_STATUS_EXPIRED', '2': 4},
  ],
};

/// Descriptor for `StockReservationStatus`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List stockReservationStatusDescriptor = $convert.base64Decode(
    'ChZTdG9ja1Jlc2VydmF0aW9uU3RhdHVzEigKJFNUT0NLX1JFU0VSVkFUSU9OX1NUQVRVU19VTl'
    'NQRUNJRklFRBAAEiEKHVNUT0NLX1JFU0VSVkFUSU9OX1NUQVRVU19IRUxEEAESJQohU1RPQ0tf'
    'UkVTRVJWQVRJT05fU1RBVFVTX0NPTlNVTUVEEAISJQohU1RPQ0tfUkVTRVJWQVRJT05fU1RBVF'
    'VTX1JFTEVBU0VEEAMSJAogU1RPQ0tfUkVTRVJWQVRJT05fU1RBVFVTX0VYUElSRUQQBA==');

@$core.Deprecated('Use orderItemDescriptor instead')
const OrderItem$json = {
  '1': 'OrderItem',
  '2': [
    {'1': 'sku', '3': 1, '4': 1, '5': 9, '10': 'sku'},
    {'1': 'product_id', '3': 2, '4': 1, '5': 9, '10': 'productId'},
    {'1': 'name', '3': 3, '4': 1, '5': 9, '10': 'name'},
    {'1': 'quantity', '3': 4, '4': 1, '5': 5, '10': 'quantity'},
    {
      '1': 'unit_price',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.Money',
      '10': 'unitPrice'
    },
    {
      '1': 'discount',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.Money',
      '10': 'discount'
    },
    {
      '1': 'total',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.Money',
      '10': 'total'
    },
    {
      '1': 'unit_cogs',
      '3': 8,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.Money',
      '10': 'unitCogs'
    },
    {
      '1': 'cogs_source_class',
      '3': 9,
      '4': 1,
      '5': 14,
      '6': '.creativanta.commerce.v1.OrderSourceClass',
      '10': 'cogsSourceClass'
    },
    {'1': 'variation', '3': 10, '4': 1, '5': 9, '10': 'variation'},
    {'1': 'platform_item_id', '3': 11, '4': 1, '5': 9, '10': 'platformItemId'},
  ],
};

/// Descriptor for `OrderItem`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List orderItemDescriptor = $convert.base64Decode(
    'CglPcmRlckl0ZW0SEAoDc2t1GAEgASgJUgNza3USHQoKcHJvZHVjdF9pZBgCIAEoCVIJcHJvZH'
    'VjdElkEhIKBG5hbWUYAyABKAlSBG5hbWUSGgoIcXVhbnRpdHkYBCABKAVSCHF1YW50aXR5EjsK'
    'CnVuaXRfcHJpY2UYBSABKAsyHC5jcmVhdGl2YW50YS5jb21tb24udjEuTW9uZXlSCXVuaXRQcm'
    'ljZRI4CghkaXNjb3VudBgGIAEoCzIcLmNyZWF0aXZhbnRhLmNvbW1vbi52MS5Nb25leVIIZGlz'
    'Y291bnQSMgoFdG90YWwYByABKAsyHC5jcmVhdGl2YW50YS5jb21tb24udjEuTW9uZXlSBXRvdG'
    'FsEjkKCXVuaXRfY29ncxgIIAEoCzIcLmNyZWF0aXZhbnRhLmNvbW1vbi52MS5Nb25leVIIdW5p'
    'dENvZ3MSVQoRY29nc19zb3VyY2VfY2xhc3MYCSABKA4yKS5jcmVhdGl2YW50YS5jb21tZXJjZS'
    '52MS5PcmRlclNvdXJjZUNsYXNzUg9jb2dzU291cmNlQ2xhc3MSHAoJdmFyaWF0aW9uGAogASgJ'
    'Ugl2YXJpYXRpb24SKAoQcGxhdGZvcm1faXRlbV9pZBgLIAEoCVIOcGxhdGZvcm1JdGVtSWQ=');

@$core.Deprecated('Use otherFeeDescriptor instead')
const OtherFee$json = {
  '1': 'OtherFee',
  '2': [
    {'1': 'name', '3': 1, '4': 1, '5': 9, '10': 'name'},
    {
      '1': 'amount',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.Money',
      '10': 'amount'
    },
  ],
};

/// Descriptor for `OtherFee`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List otherFeeDescriptor = $convert.base64Decode(
    'CghPdGhlckZlZRISCgRuYW1lGAEgASgJUgRuYW1lEjQKBmFtb3VudBgCIAEoCzIcLmNyZWF0aX'
    'ZhbnRhLmNvbW1vbi52MS5Nb25leVIGYW1vdW50');

@$core.Deprecated('Use feeBreakdownDescriptor instead')
const FeeBreakdown$json = {
  '1': 'FeeBreakdown',
  '2': [
    {
      '1': 'platform_fee',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.Money',
      '10': 'platformFee'
    },
    {
      '1': 'payment_processing_fee',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.Money',
      '10': 'paymentProcessingFee'
    },
    {
      '1': 'shipping_fee',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.Money',
      '10': 'shippingFee'
    },
    {
      '1': 'tax',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.Money',
      '10': 'tax'
    },
    {
      '1': 'commission',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.Money',
      '10': 'commission'
    },
    {
      '1': 'promo_discount',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.Money',
      '10': 'promoDiscount'
    },
    {
      '1': 'other_fees',
      '3': 7,
      '4': 3,
      '5': 11,
      '6': '.creativanta.commerce.v1.OtherFee',
      '10': 'otherFees'
    },
    {
      '1': 'total_fees',
      '3': 8,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.Money',
      '10': 'totalFees'
    },
    {'1': 'currency', '3': 9, '4': 1, '5': 9, '10': 'currency'},
  ],
};

/// Descriptor for `FeeBreakdown`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List feeBreakdownDescriptor = $convert.base64Decode(
    'CgxGZWVCcmVha2Rvd24SPwoMcGxhdGZvcm1fZmVlGAEgASgLMhwuY3JlYXRpdmFudGEuY29tbW'
    '9uLnYxLk1vbmV5UgtwbGF0Zm9ybUZlZRJSChZwYXltZW50X3Byb2Nlc3NpbmdfZmVlGAIgASgL'
    'MhwuY3JlYXRpdmFudGEuY29tbW9uLnYxLk1vbmV5UhRwYXltZW50UHJvY2Vzc2luZ0ZlZRI/Cg'
    'xzaGlwcGluZ19mZWUYAyABKAsyHC5jcmVhdGl2YW50YS5jb21tb24udjEuTW9uZXlSC3NoaXBw'
    'aW5nRmVlEi4KA3RheBgEIAEoCzIcLmNyZWF0aXZhbnRhLmNvbW1vbi52MS5Nb25leVIDdGF4Ej'
    'wKCmNvbW1pc3Npb24YBSABKAsyHC5jcmVhdGl2YW50YS5jb21tb24udjEuTW9uZXlSCmNvbW1p'
    'c3Npb24SQwoOcHJvbW9fZGlzY291bnQYBiABKAsyHC5jcmVhdGl2YW50YS5jb21tb24udjEuTW'
    '9uZXlSDXByb21vRGlzY291bnQSQAoKb3RoZXJfZmVlcxgHIAMoCzIhLmNyZWF0aXZhbnRhLmNv'
    'bW1lcmNlLnYxLk90aGVyRmVlUglvdGhlckZlZXMSOwoKdG90YWxfZmVlcxgIIAEoCzIcLmNyZW'
    'F0aXZhbnRhLmNvbW1vbi52MS5Nb25leVIJdG90YWxGZWVzEhoKCGN1cnJlbmN5GAkgASgJUghj'
    'dXJyZW5jeQ==');

@$core.Deprecated('Use orderDescriptor instead')
const Order$json = {
  '1': 'Order',
  '2': [
    {'1': 'order_id', '3': 1, '4': 1, '5': 9, '10': 'orderId'},
    {'1': 'workspace_id', '3': 2, '4': 1, '5': 9, '10': 'workspaceId'},
    {
      '1': 'source_class',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.creativanta.commerce.v1.OrderSourceClass',
      '10': 'sourceClass'
    },
    {'1': 'source_platform', '3': 4, '4': 1, '5': 9, '10': 'sourcePlatform'},
    {'1': 'external_order_id', '3': 5, '4': 1, '5': 9, '10': 'externalOrderId'},
    {
      '1': 'connected_account_id',
      '3': 6,
      '4': 1,
      '5': 9,
      '10': 'connectedAccountId'
    },
    {
      '1': 'tax_amount',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.Money',
      '10': 'taxAmount'
    },
    {'1': 'tax_jurisdiction', '3': 8, '4': 1, '5': 9, '10': 'taxJurisdiction'},
    {'1': 'tax_note', '3': 9, '4': 1, '5': 9, '10': 'taxNote'},
    {
      '1': 'exchange_rate_snapshot_json',
      '3': 10,
      '4': 1,
      '5': 9,
      '10': 'exchangeRateSnapshotJson'
    },
    {
      '1': 'recognized_at',
      '3': 11,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'recognizedAt'
    },
    {
      '1': 'source_updated_at',
      '3': 12,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'sourceUpdatedAt'
    },
    {
      '1': 'import_fingerprint',
      '3': 13,
      '4': 1,
      '5': 9,
      '10': 'importFingerprint'
    },
    {
      '1': 'lifecycle_state',
      '3': 14,
      '4': 1,
      '5': 14,
      '6': '.creativanta.commerce.v1.OrderLifecycleState',
      '10': 'lifecycleState'
    },
    {
      '1': 'amount',
      '3': 15,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.Money',
      '10': 'amount'
    },
    {'1': 'currency', '3': 16, '4': 1, '5': 9, '10': 'currency'},
    {'1': 'product_id', '3': 17, '4': 1, '5': 9, '10': 'productId'},
    {'1': 'offer_id', '3': 18, '4': 1, '5': 9, '10': 'offerId'},
    {'1': 'campaign_id', '3': 19, '4': 1, '5': 9, '10': 'campaignId'},
    {'1': 'post_id', '3': 20, '4': 1, '5': 9, '10': 'postId'},
    {'1': 'live_session_id', '3': 21, '4': 1, '5': 9, '10': 'liveSessionId'},
    {
      '1': 'customer_entity_id',
      '3': 22,
      '4': 1,
      '5': 9,
      '10': 'customerEntityId'
    },
    {
      '1': 'items',
      '3': 23,
      '4': 3,
      '5': 11,
      '6': '.creativanta.commerce.v1.OrderItem',
      '10': 'items'
    },
    {
      '1': 'fee_breakdown',
      '3': 24,
      '4': 1,
      '5': 11,
      '6': '.creativanta.commerce.v1.FeeBreakdown',
      '10': 'feeBreakdown'
    },
    {
      '1': 'shipping_address_json',
      '3': 25,
      '4': 1,
      '5': 9,
      '10': 'shippingAddressJson'
    },
    {
      '1': 'reconciliation_state',
      '3': 26,
      '4': 1,
      '5': 9,
      '10': 'reconciliationState'
    },
    {'1': 'evidence_refs', '3': 27, '4': 3, '5': 9, '10': 'evidenceRefs'},
    {'1': 'metadata_json', '3': 28, '4': 1, '5': 9, '10': 'metadataJson'},
    {
      '1': 'ordered_at',
      '3': 29,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'orderedAt'
    },
    {
      '1': 'created_at',
      '3': 30,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'createdAt'
    },
    {
      '1': 'updated_at',
      '3': 31,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'updatedAt'
    },
    {
      '1': 'deleted_at',
      '3': 32,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'deletedAt'
    },
  ],
};

/// Descriptor for `Order`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List orderDescriptor = $convert.base64Decode(
    'CgVPcmRlchIZCghvcmRlcl9pZBgBIAEoCVIHb3JkZXJJZBIhCgx3b3Jrc3BhY2VfaWQYAiABKA'
    'lSC3dvcmtzcGFjZUlkEkwKDHNvdXJjZV9jbGFzcxgDIAEoDjIpLmNyZWF0aXZhbnRhLmNvbW1l'
    'cmNlLnYxLk9yZGVyU291cmNlQ2xhc3NSC3NvdXJjZUNsYXNzEicKD3NvdXJjZV9wbGF0Zm9ybR'
    'gEIAEoCVIOc291cmNlUGxhdGZvcm0SKgoRZXh0ZXJuYWxfb3JkZXJfaWQYBSABKAlSD2V4dGVy'
    'bmFsT3JkZXJJZBIwChRjb25uZWN0ZWRfYWNjb3VudF9pZBgGIAEoCVISY29ubmVjdGVkQWNjb3'
    'VudElkEjsKCnRheF9hbW91bnQYByABKAsyHC5jcmVhdGl2YW50YS5jb21tb24udjEuTW9uZXlS'
    'CXRheEFtb3VudBIpChB0YXhfanVyaXNkaWN0aW9uGAggASgJUg90YXhKdXJpc2RpY3Rpb24SGQ'
    'oIdGF4X25vdGUYCSABKAlSB3RheE5vdGUSPQobZXhjaGFuZ2VfcmF0ZV9zbmFwc2hvdF9qc29u'
    'GAogASgJUhhleGNoYW5nZVJhdGVTbmFwc2hvdEpzb24SPwoNcmVjb2duaXplZF9hdBgLIAEoCz'
    'IaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSDHJlY29nbml6ZWRBdBJGChFzb3VyY2VfdXBk'
    'YXRlZF9hdBgMIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSD3NvdXJjZVVwZGF0ZW'
    'RBdBItChJpbXBvcnRfZmluZ2VycHJpbnQYDSABKAlSEWltcG9ydEZpbmdlcnByaW50ElUKD2xp'
    'ZmVjeWNsZV9zdGF0ZRgOIAEoDjIsLmNyZWF0aXZhbnRhLmNvbW1lcmNlLnYxLk9yZGVyTGlmZW'
    'N5Y2xlU3RhdGVSDmxpZmVjeWNsZVN0YXRlEjQKBmFtb3VudBgPIAEoCzIcLmNyZWF0aXZhbnRh'
    'LmNvbW1vbi52MS5Nb25leVIGYW1vdW50EhoKCGN1cnJlbmN5GBAgASgJUghjdXJyZW5jeRIdCg'
    'pwcm9kdWN0X2lkGBEgASgJUglwcm9kdWN0SWQSGQoIb2ZmZXJfaWQYEiABKAlSB29mZmVySWQS'
    'HwoLY2FtcGFpZ25faWQYEyABKAlSCmNhbXBhaWduSWQSFwoHcG9zdF9pZBgUIAEoCVIGcG9zdE'
    'lkEiYKD2xpdmVfc2Vzc2lvbl9pZBgVIAEoCVINbGl2ZVNlc3Npb25JZBIsChJjdXN0b21lcl9l'
    'bnRpdHlfaWQYFiABKAlSEGN1c3RvbWVyRW50aXR5SWQSOAoFaXRlbXMYFyADKAsyIi5jcmVhdG'
    'l2YW50YS5jb21tZXJjZS52MS5PcmRlckl0ZW1SBWl0ZW1zEkoKDWZlZV9icmVha2Rvd24YGCAB'
    'KAsyJS5jcmVhdGl2YW50YS5jb21tZXJjZS52MS5GZWVCcmVha2Rvd25SDGZlZUJyZWFrZG93bh'
    'IyChVzaGlwcGluZ19hZGRyZXNzX2pzb24YGSABKAlSE3NoaXBwaW5nQWRkcmVzc0pzb24SMQoU'
    'cmVjb25jaWxpYXRpb25fc3RhdGUYGiABKAlSE3JlY29uY2lsaWF0aW9uU3RhdGUSIwoNZXZpZG'
    'VuY2VfcmVmcxgbIAMoCVIMZXZpZGVuY2VSZWZzEiMKDW1ldGFkYXRhX2pzb24YHCABKAlSDG1l'
    'dGFkYXRhSnNvbhI5CgpvcmRlcmVkX2F0GB0gASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdG'
    'FtcFIJb3JkZXJlZEF0EjkKCmNyZWF0ZWRfYXQYHiABKAsyGi5nb29nbGUucHJvdG9idWYuVGlt'
    'ZXN0YW1wUgljcmVhdGVkQXQSOQoKdXBkYXRlZF9hdBgfIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi'
    '5UaW1lc3RhbXBSCXVwZGF0ZWRBdBI5CgpkZWxldGVkX2F0GCAgASgLMhouZ29vZ2xlLnByb3Rv'
    'YnVmLlRpbWVzdGFtcFIJZGVsZXRlZEF0');

@$core.Deprecated('Use inventoryLocationDescriptor instead')
const InventoryLocation$json = {
  '1': 'InventoryLocation',
  '2': [
    {'1': 'location_id', '3': 1, '4': 1, '5': 9, '10': 'locationId'},
    {'1': 'workspace_id', '3': 2, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'name', '3': 3, '4': 1, '5': 9, '10': 'name'},
    {'1': 'location_type', '3': 4, '4': 1, '5': 9, '10': 'locationType'},
    {'1': 'address_json', '3': 5, '4': 1, '5': 9, '10': 'addressJson'},
    {'1': 'is_default', '3': 6, '4': 1, '5': 8, '10': 'isDefault'},
    {'1': 'status', '3': 7, '4': 1, '5': 9, '10': 'status'},
    {
      '1': 'created_at',
      '3': 8,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'createdAt'
    },
  ],
};

/// Descriptor for `InventoryLocation`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List inventoryLocationDescriptor = $convert.base64Decode(
    'ChFJbnZlbnRvcnlMb2NhdGlvbhIfCgtsb2NhdGlvbl9pZBgBIAEoCVIKbG9jYXRpb25JZBIhCg'
    'x3b3Jrc3BhY2VfaWQYAiABKAlSC3dvcmtzcGFjZUlkEhIKBG5hbWUYAyABKAlSBG5hbWUSIwoN'
    'bG9jYXRpb25fdHlwZRgEIAEoCVIMbG9jYXRpb25UeXBlEiEKDGFkZHJlc3NfanNvbhgFIAEoCV'
    'ILYWRkcmVzc0pzb24SHQoKaXNfZGVmYXVsdBgGIAEoCFIJaXNEZWZhdWx0EhYKBnN0YXR1cxgH'
    'IAEoCVIGc3RhdHVzEjkKCmNyZWF0ZWRfYXQYCCABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZX'
    'N0YW1wUgljcmVhdGVkQXQ=');

@$core.Deprecated('Use stockMovementDescriptor instead')
const StockMovement$json = {
  '1': 'StockMovement',
  '2': [
    {'1': 'movement_id', '3': 1, '4': 1, '5': 9, '10': 'movementId'},
    {'1': 'workspace_id', '3': 2, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'sku_id', '3': 3, '4': 1, '5': 9, '10': 'skuId'},
    {'1': 'location_id', '3': 4, '4': 1, '5': 9, '10': 'locationId'},
    {
      '1': 'movement_type',
      '3': 5,
      '4': 1,
      '5': 14,
      '6': '.creativanta.commerce.v1.StockMovementType',
      '10': 'movementType'
    },
    {'1': 'movement_key', '3': 6, '4': 1, '5': 9, '10': 'movementKey'},
    {'1': 'quantity', '3': 7, '4': 1, '5': 5, '10': 'quantity'},
    {'1': 'reference_type', '3': 8, '4': 1, '5': 9, '10': 'referenceType'},
    {'1': 'reference_id', '3': 9, '4': 1, '5': 9, '10': 'referenceId'},
    {
      '1': 'source_created_at',
      '3': 10,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'sourceCreatedAt'
    },
    {'1': 'reason', '3': 11, '4': 1, '5': 9, '10': 'reason'},
    {'1': 'metadata_json', '3': 12, '4': 1, '5': 9, '10': 'metadataJson'},
    {
      '1': 'created_at',
      '3': 13,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'createdAt'
    },
  ],
};

/// Descriptor for `StockMovement`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List stockMovementDescriptor = $convert.base64Decode(
    'Cg1TdG9ja01vdmVtZW50Eh8KC21vdmVtZW50X2lkGAEgASgJUgptb3ZlbWVudElkEiEKDHdvcm'
    'tzcGFjZV9pZBgCIAEoCVILd29ya3NwYWNlSWQSFQoGc2t1X2lkGAMgASgJUgVza3VJZBIfCgts'
    'b2NhdGlvbl9pZBgEIAEoCVIKbG9jYXRpb25JZBJPCg1tb3ZlbWVudF90eXBlGAUgASgOMiouY3'
    'JlYXRpdmFudGEuY29tbWVyY2UudjEuU3RvY2tNb3ZlbWVudFR5cGVSDG1vdmVtZW50VHlwZRIh'
    'Cgxtb3ZlbWVudF9rZXkYBiABKAlSC21vdmVtZW50S2V5EhoKCHF1YW50aXR5GAcgASgFUghxdW'
    'FudGl0eRIlCg5yZWZlcmVuY2VfdHlwZRgIIAEoCVINcmVmZXJlbmNlVHlwZRIhCgxyZWZlcmVu'
    'Y2VfaWQYCSABKAlSC3JlZmVyZW5jZUlkEkYKEXNvdXJjZV9jcmVhdGVkX2F0GAogASgLMhouZ2'
    '9vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIPc291cmNlQ3JlYXRlZEF0EhYKBnJlYXNvbhgLIAEo'
    'CVIGcmVhc29uEiMKDW1ldGFkYXRhX2pzb24YDCABKAlSDG1ldGFkYXRhSnNvbhI5CgpjcmVhdG'
    'VkX2F0GA0gASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIJY3JlYXRlZEF0');

@$core.Deprecated('Use inventoryBalanceDescriptor instead')
const InventoryBalance$json = {
  '1': 'InventoryBalance',
  '2': [
    {'1': 'balance_id', '3': 1, '4': 1, '5': 9, '10': 'balanceId'},
    {'1': 'workspace_id', '3': 2, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'sku_id', '3': 3, '4': 1, '5': 9, '10': 'skuId'},
    {'1': 'location_id', '3': 4, '4': 1, '5': 9, '10': 'locationId'},
    {'1': 'on_hand', '3': 5, '4': 1, '5': 5, '10': 'onHand'},
    {'1': 'reserved', '3': 6, '4': 1, '5': 5, '10': 'reserved'},
    {
      '1': 'opening_at',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'openingAt'
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

/// Descriptor for `InventoryBalance`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List inventoryBalanceDescriptor = $convert.base64Decode(
    'ChBJbnZlbnRvcnlCYWxhbmNlEh0KCmJhbGFuY2VfaWQYASABKAlSCWJhbGFuY2VJZBIhCgx3b3'
    'Jrc3BhY2VfaWQYAiABKAlSC3dvcmtzcGFjZUlkEhUKBnNrdV9pZBgDIAEoCVIFc2t1SWQSHwoL'
    'bG9jYXRpb25faWQYBCABKAlSCmxvY2F0aW9uSWQSFwoHb25faGFuZBgFIAEoBVIGb25IYW5kEh'
    'oKCHJlc2VydmVkGAYgASgFUghyZXNlcnZlZBI5CgpvcGVuaW5nX2F0GAcgASgLMhouZ29vZ2xl'
    'LnByb3RvYnVmLlRpbWVzdGFtcFIJb3BlbmluZ0F0EjkKCnVwZGF0ZWRfYXQYCCABKAsyGi5nb2'
    '9nbGUucHJvdG9idWYuVGltZXN0YW1wUgl1cGRhdGVkQXQ=');

@$core.Deprecated('Use stockReservationDescriptor instead')
const StockReservation$json = {
  '1': 'StockReservation',
  '2': [
    {'1': 'reservation_id', '3': 1, '4': 1, '5': 9, '10': 'reservationId'},
    {'1': 'workspace_id', '3': 2, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'order_id', '3': 3, '4': 1, '5': 9, '10': 'orderId'},
    {'1': 'sku_id', '3': 4, '4': 1, '5': 9, '10': 'skuId'},
    {'1': 'location_id', '3': 5, '4': 1, '5': 9, '10': 'locationId'},
    {'1': 'reservation_key', '3': 6, '4': 1, '5': 9, '10': 'reservationKey'},
    {'1': 'quantity', '3': 7, '4': 1, '5': 5, '10': 'quantity'},
    {
      '1': 'status',
      '3': 8,
      '4': 1,
      '5': 14,
      '6': '.creativanta.commerce.v1.StockReservationStatus',
      '10': 'status'
    },
    {
      '1': 'expires_at',
      '3': 9,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'expiresAt'
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

/// Descriptor for `StockReservation`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List stockReservationDescriptor = $convert.base64Decode(
    'ChBTdG9ja1Jlc2VydmF0aW9uEiUKDnJlc2VydmF0aW9uX2lkGAEgASgJUg1yZXNlcnZhdGlvbk'
    'lkEiEKDHdvcmtzcGFjZV9pZBgCIAEoCVILd29ya3NwYWNlSWQSGQoIb3JkZXJfaWQYAyABKAlS'
    'B29yZGVySWQSFQoGc2t1X2lkGAQgASgJUgVza3VJZBIfCgtsb2NhdGlvbl9pZBgFIAEoCVIKbG'
    '9jYXRpb25JZBInCg9yZXNlcnZhdGlvbl9rZXkYBiABKAlSDnJlc2VydmF0aW9uS2V5EhoKCHF1'
    'YW50aXR5GAcgASgFUghxdWFudGl0eRJHCgZzdGF0dXMYCCABKA4yLy5jcmVhdGl2YW50YS5jb2'
    '1tZXJjZS52MS5TdG9ja1Jlc2VydmF0aW9uU3RhdHVzUgZzdGF0dXMSOQoKZXhwaXJlc19hdBgJ'
    'IAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSCWV4cGlyZXNBdBI5CgpjcmVhdGVkX2'
    'F0GAogASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIJY3JlYXRlZEF0EjkKCnVwZGF0'
    'ZWRfYXQYCyABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUgl1cGRhdGVkQXQ=');

@$core.Deprecated('Use refundDescriptor instead')
const Refund$json = {
  '1': 'Refund',
  '2': [
    {'1': 'refund_id', '3': 1, '4': 1, '5': 9, '10': 'refundId'},
    {'1': 'workspace_id', '3': 2, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'order_id', '3': 3, '4': 1, '5': 9, '10': 'orderId'},
    {'1': 'refund_type', '3': 4, '4': 1, '5': 9, '10': 'refundType'},
    {
      '1': 'amount',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.Money',
      '10': 'amount'
    },
    {'1': 'currency', '3': 6, '4': 1, '5': 9, '10': 'currency'},
    {'1': 'reason', '3': 7, '4': 1, '5': 9, '10': 'reason'},
    {
      '1': 'lifecycle_state',
      '3': 8,
      '4': 1,
      '5': 14,
      '6': '.creativanta.commerce.v1.RefundLifecycleState',
      '10': 'lifecycleState'
    },
    {
      '1': 'source_class',
      '3': 9,
      '4': 1,
      '5': 14,
      '6': '.creativanta.commerce.v1.OrderSourceClass',
      '10': 'sourceClass'
    },
    {'1': 'source_platform', '3': 10, '4': 1, '5': 9, '10': 'sourcePlatform'},
    {
      '1': 'external_refund_id',
      '3': 11,
      '4': 1,
      '5': 9,
      '10': 'externalRefundId'
    },
    {'1': 'settlement_id', '3': 12, '4': 1, '5': 9, '10': 'settlementId'},
    {'1': 'evidence_refs', '3': 13, '4': 3, '5': 9, '10': 'evidenceRefs'},
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
      '1': 'deleted_at',
      '3': 16,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'deletedAt'
    },
  ],
};

/// Descriptor for `Refund`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List refundDescriptor = $convert.base64Decode(
    'CgZSZWZ1bmQSGwoJcmVmdW5kX2lkGAEgASgJUghyZWZ1bmRJZBIhCgx3b3Jrc3BhY2VfaWQYAi'
    'ABKAlSC3dvcmtzcGFjZUlkEhkKCG9yZGVyX2lkGAMgASgJUgdvcmRlcklkEh8KC3JlZnVuZF90'
    'eXBlGAQgASgJUgpyZWZ1bmRUeXBlEjQKBmFtb3VudBgFIAEoCzIcLmNyZWF0aXZhbnRhLmNvbW'
    '1vbi52MS5Nb25leVIGYW1vdW50EhoKCGN1cnJlbmN5GAYgASgJUghjdXJyZW5jeRIWCgZyZWFz'
    'b24YByABKAlSBnJlYXNvbhJWCg9saWZlY3ljbGVfc3RhdGUYCCABKA4yLS5jcmVhdGl2YW50YS'
    '5jb21tZXJjZS52MS5SZWZ1bmRMaWZlY3ljbGVTdGF0ZVIObGlmZWN5Y2xlU3RhdGUSTAoMc291'
    'cmNlX2NsYXNzGAkgASgOMikuY3JlYXRpdmFudGEuY29tbWVyY2UudjEuT3JkZXJTb3VyY2VDbG'
    'Fzc1ILc291cmNlQ2xhc3MSJwoPc291cmNlX3BsYXRmb3JtGAogASgJUg5zb3VyY2VQbGF0Zm9y'
    'bRIsChJleHRlcm5hbF9yZWZ1bmRfaWQYCyABKAlSEGV4dGVybmFsUmVmdW5kSWQSIwoNc2V0dG'
    'xlbWVudF9pZBgMIAEoCVIMc2V0dGxlbWVudElkEiMKDWV2aWRlbmNlX3JlZnMYDSADKAlSDGV2'
    'aWRlbmNlUmVmcxI5CgpjcmVhdGVkX2F0GA4gASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdG'
    'FtcFIJY3JlYXRlZEF0EjkKCnVwZGF0ZWRfYXQYDyABKAsyGi5nb29nbGUucHJvdG9idWYuVGlt'
    'ZXN0YW1wUgl1cGRhdGVkQXQSOQoKZGVsZXRlZF9hdBgQIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi'
    '5UaW1lc3RhbXBSCWRlbGV0ZWRBdA==');

@$core.Deprecated('Use returnItemDescriptor instead')
const ReturnItem$json = {
  '1': 'ReturnItem',
  '2': [
    {'1': 'sku', '3': 1, '4': 1, '5': 9, '10': 'sku'},
    {'1': 'quantity', '3': 2, '4': 1, '5': 5, '10': 'quantity'},
    {'1': 'reason', '3': 3, '4': 1, '5': 9, '10': 'reason'},
  ],
};

/// Descriptor for `ReturnItem`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List returnItemDescriptor = $convert.base64Decode(
    'CgpSZXR1cm5JdGVtEhAKA3NrdRgBIAEoCVIDc2t1EhoKCHF1YW50aXR5GAIgASgFUghxdWFudG'
    'l0eRIWCgZyZWFzb24YAyABKAlSBnJlYXNvbg==');

@$core.Deprecated('Use returnDescriptor instead')
const Return$json = {
  '1': 'Return',
  '2': [
    {'1': 'return_id', '3': 1, '4': 1, '5': 9, '10': 'returnId'},
    {'1': 'workspace_id', '3': 2, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'order_id', '3': 3, '4': 1, '5': 9, '10': 'orderId'},
    {'1': 'refund_id', '3': 4, '4': 1, '5': 9, '10': 'refundId'},
    {'1': 'return_type', '3': 5, '4': 1, '5': 9, '10': 'returnType'},
    {
      '1': 'items',
      '3': 6,
      '4': 3,
      '5': 11,
      '6': '.creativanta.commerce.v1.ReturnItem',
      '10': 'items'
    },
    {
      '1': 'lifecycle_state',
      '3': 7,
      '4': 1,
      '5': 14,
      '6': '.creativanta.commerce.v1.ReturnLifecycleState',
      '10': 'lifecycleState'
    },
    {'1': 'tracking_number', '3': 8, '4': 1, '5': 9, '10': 'trackingNumber'},
    {
      '1': 'evidence_photo_url',
      '3': 9,
      '4': 1,
      '5': 9,
      '10': 'evidencePhotoUrl'
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
    {
      '1': 'deleted_at',
      '3': 12,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'deletedAt'
    },
  ],
};

/// Descriptor for `Return`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List returnDescriptor = $convert.base64Decode(
    'CgZSZXR1cm4SGwoJcmV0dXJuX2lkGAEgASgJUghyZXR1cm5JZBIhCgx3b3Jrc3BhY2VfaWQYAi'
    'ABKAlSC3dvcmtzcGFjZUlkEhkKCG9yZGVyX2lkGAMgASgJUgdvcmRlcklkEhsKCXJlZnVuZF9p'
    'ZBgEIAEoCVIIcmVmdW5kSWQSHwoLcmV0dXJuX3R5cGUYBSABKAlSCnJldHVyblR5cGUSOQoFaX'
    'RlbXMYBiADKAsyIy5jcmVhdGl2YW50YS5jb21tZXJjZS52MS5SZXR1cm5JdGVtUgVpdGVtcxJW'
    'Cg9saWZlY3ljbGVfc3RhdGUYByABKA4yLS5jcmVhdGl2YW50YS5jb21tZXJjZS52MS5SZXR1cm'
    '5MaWZlY3ljbGVTdGF0ZVIObGlmZWN5Y2xlU3RhdGUSJwoPdHJhY2tpbmdfbnVtYmVyGAggASgJ'
    'Ug50cmFja2luZ051bWJlchIsChJldmlkZW5jZV9waG90b191cmwYCSABKAlSEGV2aWRlbmNlUG'
    'hvdG9VcmwSOQoKY3JlYXRlZF9hdBgKIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBS'
    'CWNyZWF0ZWRBdBI5Cgp1cGRhdGVkX2F0GAsgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdG'
    'FtcFIJdXBkYXRlZEF0EjkKCmRlbGV0ZWRfYXQYDCABKAsyGi5nb29nbGUucHJvdG9idWYuVGlt'
    'ZXN0YW1wUglkZWxldGVkQXQ=');

@$core.Deprecated('Use stockMovementItemDescriptor instead')
const StockMovementItem$json = {
  '1': 'StockMovementItem',
  '2': [
    {'1': 'sku_id', '3': 1, '4': 1, '5': 9, '10': 'skuId'},
    {'1': 'quantity', '3': 2, '4': 1, '5': 5, '10': 'quantity'},
  ],
};

/// Descriptor for `StockMovementItem`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List stockMovementItemDescriptor = $convert.base64Decode(
    'ChFTdG9ja01vdmVtZW50SXRlbRIVCgZza3VfaWQYASABKAlSBXNrdUlkEhoKCHF1YW50aXR5GA'
    'IgASgFUghxdWFudGl0eQ==');

@$core.Deprecated('Use inventoryAlertDescriptor instead')
const InventoryAlert$json = {
  '1': 'InventoryAlert',
  '2': [
    {'1': 'sku_id', '3': 1, '4': 1, '5': 9, '10': 'skuId'},
    {'1': 'product_title', '3': 2, '4': 1, '5': 9, '10': 'productTitle'},
    {'1': 'sku_code', '3': 3, '4': 1, '5': 9, '10': 'skuCode'},
    {'1': 'current_stock', '3': 4, '4': 1, '5': 5, '10': 'currentStock'},
    {'1': 'threshold', '3': 5, '4': 1, '5': 5, '10': 'threshold'},
    {'1': 'alert_level', '3': 6, '4': 1, '5': 9, '10': 'alertLevel'},
  ],
};

/// Descriptor for `InventoryAlert`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List inventoryAlertDescriptor = $convert.base64Decode(
    'Cg5JbnZlbnRvcnlBbGVydBIVCgZza3VfaWQYASABKAlSBXNrdUlkEiMKDXByb2R1Y3RfdGl0bG'
    'UYAiABKAlSDHByb2R1Y3RUaXRsZRIZCghza3VfY29kZRgDIAEoCVIHc2t1Q29kZRIjCg1jdXJy'
    'ZW50X3N0b2NrGAQgASgFUgxjdXJyZW50U3RvY2sSHAoJdGhyZXNob2xkGAUgASgFUgl0aHJlc2'
    'hvbGQSHwoLYWxlcnRfbGV2ZWwYBiABKAlSCmFsZXJ0TGV2ZWw=');

@$core.Deprecated('Use orderServiceListRequestDescriptor instead')
const OrderServiceListRequest$json = {
  '1': 'OrderServiceListRequest',
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
      '1': 'state',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.creativanta.commerce.v1.OrderLifecycleState',
      '10': 'state'
    },
    {'1': 'source_platform', '3': 3, '4': 1, '5': 9, '10': 'sourcePlatform'},
    {'1': 'date_from', '3': 4, '4': 1, '5': 9, '10': 'dateFrom'},
    {'1': 'date_to', '3': 5, '4': 1, '5': 9, '10': 'dateTo'},
  ],
};

/// Descriptor for `OrderServiceListRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List orderServiceListRequestDescriptor = $convert.base64Decode(
    'ChdPcmRlclNlcnZpY2VMaXN0UmVxdWVzdBJBCgpwYWdpbmF0aW9uGAEgASgLMiEuY3JlYXRpdm'
    'FudGEuY29tbW9uLnYxLlBhZ2luYXRpb25SCnBhZ2luYXRpb24SQgoFc3RhdGUYAiABKA4yLC5j'
    'cmVhdGl2YW50YS5jb21tZXJjZS52MS5PcmRlckxpZmVjeWNsZVN0YXRlUgVzdGF0ZRInCg9zb3'
    'VyY2VfcGxhdGZvcm0YAyABKAlSDnNvdXJjZVBsYXRmb3JtEhsKCWRhdGVfZnJvbRgEIAEoCVII'
    'ZGF0ZUZyb20SFwoHZGF0ZV90bxgFIAEoCVIGZGF0ZVRv');

@$core.Deprecated('Use orderServiceListResponseDescriptor instead')
const OrderServiceListResponse$json = {
  '1': 'OrderServiceListResponse',
  '2': [
    {
      '1': 'orders',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.creativanta.commerce.v1.Order',
      '10': 'orders'
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

/// Descriptor for `OrderServiceListResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List orderServiceListResponseDescriptor = $convert.base64Decode(
    'ChhPcmRlclNlcnZpY2VMaXN0UmVzcG9uc2USNgoGb3JkZXJzGAEgAygLMh4uY3JlYXRpdmFudG'
    'EuY29tbWVyY2UudjEuT3JkZXJSBm9yZGVycxJICgpwYWdpbmF0aW9uGAIgASgLMiguY3JlYXRp'
    'dmFudGEuY29tbW9uLnYxLlBhZ2luYXRlZFJlc3BvbnNlUgpwYWdpbmF0aW9u');

@$core.Deprecated('Use orderServiceGetRequestDescriptor instead')
const OrderServiceGetRequest$json = {
  '1': 'OrderServiceGetRequest',
  '2': [
    {'1': 'order_id', '3': 1, '4': 1, '5': 9, '10': 'orderId'},
  ],
};

/// Descriptor for `OrderServiceGetRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List orderServiceGetRequestDescriptor =
    $convert.base64Decode(
        'ChZPcmRlclNlcnZpY2VHZXRSZXF1ZXN0EhkKCG9yZGVyX2lkGAEgASgJUgdvcmRlcklk');

@$core.Deprecated('Use orderServiceGetResponseDescriptor instead')
const OrderServiceGetResponse$json = {
  '1': 'OrderServiceGetResponse',
  '2': [
    {
      '1': 'order',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.commerce.v1.Order',
      '10': 'order'
    },
    {
      '1': 'refunds',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.creativanta.commerce.v1.Refund',
      '10': 'refunds'
    },
    {
      '1': 'returns',
      '3': 3,
      '4': 3,
      '5': 11,
      '6': '.creativanta.commerce.v1.Return',
      '10': 'returns'
    },
    {
      '1': 'reservations',
      '3': 4,
      '4': 3,
      '5': 11,
      '6': '.creativanta.commerce.v1.StockReservation',
      '10': 'reservations'
    },
  ],
};

/// Descriptor for `OrderServiceGetResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List orderServiceGetResponseDescriptor = $convert.base64Decode(
    'ChdPcmRlclNlcnZpY2VHZXRSZXNwb25zZRI0CgVvcmRlchgBIAEoCzIeLmNyZWF0aXZhbnRhLm'
    'NvbW1lcmNlLnYxLk9yZGVyUgVvcmRlchI5CgdyZWZ1bmRzGAIgAygLMh8uY3JlYXRpdmFudGEu'
    'Y29tbWVyY2UudjEuUmVmdW5kUgdyZWZ1bmRzEjkKB3JldHVybnMYAyADKAsyHy5jcmVhdGl2YW'
    '50YS5jb21tZXJjZS52MS5SZXR1cm5SB3JldHVybnMSTQoMcmVzZXJ2YXRpb25zGAQgAygLMiku'
    'Y3JlYXRpdmFudGEuY29tbWVyY2UudjEuU3RvY2tSZXNlcnZhdGlvblIMcmVzZXJ2YXRpb25z');

@$core.Deprecated('Use orderServiceImportRequestDescriptor instead')
const OrderServiceImportRequest$json = {
  '1': 'OrderServiceImportRequest',
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
      '1': 'connected_account_id',
      '3': 2,
      '4': 1,
      '5': 9,
      '10': 'connectedAccountId'
    },
    {'1': 'platform', '3': 3, '4': 1, '5': 9, '10': 'platform'},
    {'1': 'source_data', '3': 4, '4': 1, '5': 9, '10': 'sourceData'},
    {'1': 'format', '3': 5, '4': 1, '5': 9, '10': 'format'},
    {'1': 'preview_token', '3': 6, '4': 1, '5': 9, '10': 'previewToken'},
    {'1': 'dry_run', '3': 7, '4': 1, '5': 8, '10': 'dryRun'},
    {
      '1': 'column_mappings',
      '3': 8,
      '4': 3,
      '5': 11,
      '6':
          '.creativanta.commerce.v1.OrderServiceImportRequest.ColumnMappingsEntry',
      '10': 'columnMappings'
    },
  ],
  '3': [OrderServiceImportRequest_ColumnMappingsEntry$json],
};

@$core.Deprecated('Use orderServiceImportRequestDescriptor instead')
const OrderServiceImportRequest_ColumnMappingsEntry$json = {
  '1': 'ColumnMappingsEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {'1': 'value', '3': 2, '4': 1, '5': 9, '10': 'value'},
  ],
  '7': {'7': true},
};

/// Descriptor for `OrderServiceImportRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List orderServiceImportRequestDescriptor = $convert.base64Decode(
    'ChlPcmRlclNlcnZpY2VJbXBvcnRSZXF1ZXN0Ej8KB2NvbnRleHQYASABKAsyJS5jcmVhdGl2YW'
    '50YS5jb21tb24udjEuQ29tbWFuZENvbnRleHRSB2NvbnRleHQSMAoUY29ubmVjdGVkX2FjY291'
    'bnRfaWQYAiABKAlSEmNvbm5lY3RlZEFjY291bnRJZBIaCghwbGF0Zm9ybRgDIAEoCVIIcGxhdG'
    'Zvcm0SHwoLc291cmNlX2RhdGEYBCABKAlSCnNvdXJjZURhdGESFgoGZm9ybWF0GAUgASgJUgZm'
    'b3JtYXQSIwoNcHJldmlld190b2tlbhgGIAEoCVIMcHJldmlld1Rva2VuEhcKB2RyeV9ydW4YBy'
    'ABKAhSBmRyeVJ1bhJvCg9jb2x1bW5fbWFwcGluZ3MYCCADKAsyRi5jcmVhdGl2YW50YS5jb21t'
    'ZXJjZS52MS5PcmRlclNlcnZpY2VJbXBvcnRSZXF1ZXN0LkNvbHVtbk1hcHBpbmdzRW50cnlSDm'
    'NvbHVtbk1hcHBpbmdzGkEKE0NvbHVtbk1hcHBpbmdzRW50cnkSEAoDa2V5GAEgASgJUgNrZXkS'
    'FAoFdmFsdWUYAiABKAlSBXZhbHVlOgI4AQ==');

@$core.Deprecated('Use orderServiceImportResponseDescriptor instead')
const OrderServiceImportResponse$json = {
  '1': 'OrderServiceImportResponse',
  '2': [
    {'1': 'is_preview', '3': 1, '4': 1, '5': 8, '10': 'isPreview'},
    {'1': 'preview_token', '3': 2, '4': 1, '5': 9, '10': 'previewToken'},
    {'1': 'total_rows', '3': 3, '4': 1, '5': 5, '10': 'totalRows'},
    {'1': 'create_count', '3': 4, '4': 1, '5': 5, '10': 'createCount'},
    {'1': 'update_count', '3': 5, '4': 1, '5': 5, '10': 'updateCount'},
    {'1': 'unchanged_count', '3': 6, '4': 1, '5': 5, '10': 'unchangedCount'},
    {'1': 'error_count', '3': 7, '4': 1, '5': 5, '10': 'errorCount'},
    {
      '1': 'created_orders',
      '3': 8,
      '4': 3,
      '5': 11,
      '6': '.creativanta.commerce.v1.Order',
      '10': 'createdOrders'
    },
    {
      '1': 'import_fingerprint',
      '3': 9,
      '4': 1,
      '5': 9,
      '10': 'importFingerprint'
    },
  ],
};

/// Descriptor for `OrderServiceImportResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List orderServiceImportResponseDescriptor = $convert.base64Decode(
    'ChpPcmRlclNlcnZpY2VJbXBvcnRSZXNwb25zZRIdCgppc19wcmV2aWV3GAEgASgIUglpc1ByZX'
    'ZpZXcSIwoNcHJldmlld190b2tlbhgCIAEoCVIMcHJldmlld1Rva2VuEh0KCnRvdGFsX3Jvd3MY'
    'AyABKAVSCXRvdGFsUm93cxIhCgxjcmVhdGVfY291bnQYBCABKAVSC2NyZWF0ZUNvdW50EiEKDH'
    'VwZGF0ZV9jb3VudBgFIAEoBVILdXBkYXRlQ291bnQSJwoPdW5jaGFuZ2VkX2NvdW50GAYgASgF'
    'Ug51bmNoYW5nZWRDb3VudBIfCgtlcnJvcl9jb3VudBgHIAEoBVIKZXJyb3JDb3VudBJFCg5jcm'
    'VhdGVkX29yZGVycxgIIAMoCzIeLmNyZWF0aXZhbnRhLmNvbW1lcmNlLnYxLk9yZGVyUg1jcmVh'
    'dGVkT3JkZXJzEi0KEmltcG9ydF9maW5nZXJwcmludBgJIAEoCVIRaW1wb3J0RmluZ2VycHJpbn'
    'Q=');

@$core.Deprecated('Use orderServiceExportRequestDescriptor instead')
const OrderServiceExportRequest$json = {
  '1': 'OrderServiceExportRequest',
  '2': [
    {'1': 'format', '3': 1, '4': 1, '5': 9, '10': 'format'},
    {
      '1': 'state',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.creativanta.commerce.v1.OrderLifecycleState',
      '10': 'state'
    },
    {'1': 'date_from', '3': 3, '4': 1, '5': 9, '10': 'dateFrom'},
    {'1': 'date_to', '3': 4, '4': 1, '5': 9, '10': 'dateTo'},
  ],
};

/// Descriptor for `OrderServiceExportRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List orderServiceExportRequestDescriptor = $convert.base64Decode(
    'ChlPcmRlclNlcnZpY2VFeHBvcnRSZXF1ZXN0EhYKBmZvcm1hdBgBIAEoCVIGZm9ybWF0EkIKBX'
    'N0YXRlGAIgASgOMiwuY3JlYXRpdmFudGEuY29tbWVyY2UudjEuT3JkZXJMaWZlY3ljbGVTdGF0'
    'ZVIFc3RhdGUSGwoJZGF0ZV9mcm9tGAMgASgJUghkYXRlRnJvbRIXCgdkYXRlX3RvGAQgASgJUg'
    'ZkYXRlVG8=');

@$core.Deprecated('Use orderServiceExportResponseDescriptor instead')
const OrderServiceExportResponse$json = {
  '1': 'OrderServiceExportResponse',
  '2': [
    {'1': 'download_url', '3': 1, '4': 1, '5': 9, '10': 'downloadUrl'},
    {'1': 'row_count', '3': 2, '4': 1, '5': 5, '10': 'rowCount'},
  ],
};

/// Descriptor for `OrderServiceExportResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List orderServiceExportResponseDescriptor =
    $convert.base64Decode(
        'ChpPcmRlclNlcnZpY2VFeHBvcnRSZXNwb25zZRIhCgxkb3dubG9hZF91cmwYASABKAlSC2Rvd2'
        '5sb2FkVXJsEhsKCXJvd19jb3VudBgCIAEoBVIIcm93Q291bnQ=');

@$core.Deprecated('Use orderServiceUpdateStatusRequestDescriptor instead')
const OrderServiceUpdateStatusRequest$json = {
  '1': 'OrderServiceUpdateStatusRequest',
  '2': [
    {
      '1': 'context',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.CommandContext',
      '10': 'context'
    },
    {'1': 'order_id', '3': 2, '4': 1, '5': 9, '10': 'orderId'},
    {
      '1': 'target_state',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.creativanta.commerce.v1.OrderLifecycleState',
      '10': 'targetState'
    },
    {'1': 'reason', '3': 4, '4': 1, '5': 9, '10': 'reason'},
  ],
};

/// Descriptor for `OrderServiceUpdateStatusRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List orderServiceUpdateStatusRequestDescriptor = $convert.base64Decode(
    'Ch9PcmRlclNlcnZpY2VVcGRhdGVTdGF0dXNSZXF1ZXN0Ej8KB2NvbnRleHQYASABKAsyJS5jcm'
    'VhdGl2YW50YS5jb21tb24udjEuQ29tbWFuZENvbnRleHRSB2NvbnRleHQSGQoIb3JkZXJfaWQY'
    'AiABKAlSB29yZGVySWQSTwoMdGFyZ2V0X3N0YXRlGAMgASgOMiwuY3JlYXRpdmFudGEuY29tbW'
    'VyY2UudjEuT3JkZXJMaWZlY3ljbGVTdGF0ZVILdGFyZ2V0U3RhdGUSFgoGcmVhc29uGAQgASgJ'
    'UgZyZWFzb24=');

@$core.Deprecated('Use orderServiceUpdateStatusResponseDescriptor instead')
const OrderServiceUpdateStatusResponse$json = {
  '1': 'OrderServiceUpdateStatusResponse',
  '2': [
    {
      '1': 'order',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.commerce.v1.Order',
      '10': 'order'
    },
  ],
};

/// Descriptor for `OrderServiceUpdateStatusResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List orderServiceUpdateStatusResponseDescriptor =
    $convert.base64Decode(
        'CiBPcmRlclNlcnZpY2VVcGRhdGVTdGF0dXNSZXNwb25zZRI0CgVvcmRlchgBIAEoCzIeLmNyZW'
        'F0aXZhbnRhLmNvbW1lcmNlLnYxLk9yZGVyUgVvcmRlcg==');

@$core.Deprecated('Use orderServiceSearchRequestDescriptor instead')
const OrderServiceSearchRequest$json = {
  '1': 'OrderServiceSearchRequest',
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

/// Descriptor for `OrderServiceSearchRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List orderServiceSearchRequestDescriptor = $convert.base64Decode(
    'ChlPcmRlclNlcnZpY2VTZWFyY2hSZXF1ZXN0EhQKBXF1ZXJ5GAEgASgJUgVxdWVyeRJBCgpwYW'
    'dpbmF0aW9uGAIgASgLMiEuY3JlYXRpdmFudGEuY29tbW9uLnYxLlBhZ2luYXRpb25SCnBhZ2lu'
    'YXRpb24=');

@$core.Deprecated('Use orderServiceSearchResponseDescriptor instead')
const OrderServiceSearchResponse$json = {
  '1': 'OrderServiceSearchResponse',
  '2': [
    {
      '1': 'orders',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.creativanta.commerce.v1.Order',
      '10': 'orders'
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

/// Descriptor for `OrderServiceSearchResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List orderServiceSearchResponseDescriptor =
    $convert.base64Decode(
        'ChpPcmRlclNlcnZpY2VTZWFyY2hSZXNwb25zZRI2CgZvcmRlcnMYASADKAsyHi5jcmVhdGl2YW'
        '50YS5jb21tZXJjZS52MS5PcmRlclIGb3JkZXJzEkgKCnBhZ2luYXRpb24YAiABKAsyKC5jcmVh'
        'dGl2YW50YS5jb21tb24udjEuUGFnaW5hdGVkUmVzcG9uc2VSCnBhZ2luYXRpb24=');

@$core.Deprecated('Use orderServiceConfirmRequestDescriptor instead')
const OrderServiceConfirmRequest$json = {
  '1': 'OrderServiceConfirmRequest',
  '2': [
    {
      '1': 'context',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.CommandContext',
      '10': 'context'
    },
    {'1': 'order_id', '3': 2, '4': 1, '5': 9, '10': 'orderId'},
  ],
};

/// Descriptor for `OrderServiceConfirmRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List orderServiceConfirmRequestDescriptor =
    $convert.base64Decode(
        'ChpPcmRlclNlcnZpY2VDb25maXJtUmVxdWVzdBI/Cgdjb250ZXh0GAEgASgLMiUuY3JlYXRpdm'
        'FudGEuY29tbW9uLnYxLkNvbW1hbmRDb250ZXh0Ugdjb250ZXh0EhkKCG9yZGVyX2lkGAIgASgJ'
        'UgdvcmRlcklk');

@$core.Deprecated('Use orderServiceConfirmResponseDescriptor instead')
const OrderServiceConfirmResponse$json = {
  '1': 'OrderServiceConfirmResponse',
  '2': [
    {
      '1': 'order',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.commerce.v1.Order',
      '10': 'order'
    },
  ],
};

/// Descriptor for `OrderServiceConfirmResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List orderServiceConfirmResponseDescriptor =
    $convert.base64Decode(
        'ChtPcmRlclNlcnZpY2VDb25maXJtUmVzcG9uc2USNAoFb3JkZXIYASABKAsyHi5jcmVhdGl2YW'
        '50YS5jb21tZXJjZS52MS5PcmRlclIFb3JkZXI=');

@$core.Deprecated('Use orderServiceGetTodayStatsRequestDescriptor instead')
const OrderServiceGetTodayStatsRequest$json = {
  '1': 'OrderServiceGetTodayStatsRequest',
};

/// Descriptor for `OrderServiceGetTodayStatsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List orderServiceGetTodayStatsRequestDescriptor =
    $convert.base64Decode('CiBPcmRlclNlcnZpY2VHZXRUb2RheVN0YXRzUmVxdWVzdA==');

@$core.Deprecated('Use orderServiceGetTodayStatsResponseDescriptor instead')
const OrderServiceGetTodayStatsResponse$json = {
  '1': 'OrderServiceGetTodayStatsResponse',
  '2': [
    {'1': 'order_count', '3': 1, '4': 1, '5': 5, '10': 'orderCount'},
    {
      '1': 'total_amount',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.Money',
      '10': 'totalAmount'
    },
    {
      '1': 'pending_fulfillment_count',
      '3': 3,
      '4': 1,
      '5': 5,
      '10': 'pendingFulfillmentCount'
    },
  ],
};

/// Descriptor for `OrderServiceGetTodayStatsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List orderServiceGetTodayStatsResponseDescriptor =
    $convert.base64Decode(
        'CiFPcmRlclNlcnZpY2VHZXRUb2RheVN0YXRzUmVzcG9uc2USHwoLb3JkZXJfY291bnQYASABKA'
        'VSCm9yZGVyQ291bnQSPwoMdG90YWxfYW1vdW50GAIgASgLMhwuY3JlYXRpdmFudGEuY29tbW9u'
        'LnYxLk1vbmV5Ugt0b3RhbEFtb3VudBI6ChlwZW5kaW5nX2Z1bGZpbGxtZW50X2NvdW50GAMgAS'
        'gFUhdwZW5kaW5nRnVsZmlsbG1lbnRDb3VudA==');

@$core.Deprecated('Use orderServiceGetDailyStatsRequestDescriptor instead')
const OrderServiceGetDailyStatsRequest$json = {
  '1': 'OrderServiceGetDailyStatsRequest',
  '2': [
    {'1': 'date', '3': 1, '4': 1, '5': 9, '10': 'date'},
  ],
};

/// Descriptor for `OrderServiceGetDailyStatsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List orderServiceGetDailyStatsRequestDescriptor =
    $convert.base64Decode(
        'CiBPcmRlclNlcnZpY2VHZXREYWlseVN0YXRzUmVxdWVzdBISCgRkYXRlGAEgASgJUgRkYXRl');

@$core.Deprecated('Use orderServiceGetDailyStatsResponseDescriptor instead')
const OrderServiceGetDailyStatsResponse$json = {
  '1': 'OrderServiceGetDailyStatsResponse',
  '2': [
    {'1': 'order_count', '3': 1, '4': 1, '5': 5, '10': 'orderCount'},
    {
      '1': 'total_amount',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.Money',
      '10': 'totalAmount'
    },
  ],
};

/// Descriptor for `OrderServiceGetDailyStatsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List orderServiceGetDailyStatsResponseDescriptor =
    $convert.base64Decode(
        'CiFPcmRlclNlcnZpY2VHZXREYWlseVN0YXRzUmVzcG9uc2USHwoLb3JkZXJfY291bnQYASABKA'
        'VSCm9yZGVyQ291bnQSPwoMdG90YWxfYW1vdW50GAIgASgLMhwuY3JlYXRpdmFudGEuY29tbW9u'
        'LnYxLk1vbmV5Ugt0b3RhbEFtb3VudA==');

@$core.Deprecated('Use orderServiceGetLabelRequestDescriptor instead')
const OrderServiceGetLabelRequest$json = {
  '1': 'OrderServiceGetLabelRequest',
  '2': [
    {'1': 'order_id', '3': 1, '4': 1, '5': 9, '10': 'orderId'},
  ],
};

/// Descriptor for `OrderServiceGetLabelRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List orderServiceGetLabelRequestDescriptor =
    $convert.base64Decode(
        'ChtPcmRlclNlcnZpY2VHZXRMYWJlbFJlcXVlc3QSGQoIb3JkZXJfaWQYASABKAlSB29yZGVySW'
        'Q=');

@$core.Deprecated('Use orderServiceGetLabelResponseDescriptor instead')
const OrderServiceGetLabelResponse$json = {
  '1': 'OrderServiceGetLabelResponse',
  '2': [
    {'1': 'label_url', '3': 1, '4': 1, '5': 9, '10': 'labelUrl'},
    {'1': 'tracking_number', '3': 2, '4': 1, '5': 9, '10': 'trackingNumber'},
    {'1': 'carrier', '3': 3, '4': 1, '5': 9, '10': 'carrier'},
  ],
};

/// Descriptor for `OrderServiceGetLabelResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List orderServiceGetLabelResponseDescriptor =
    $convert.base64Decode(
        'ChxPcmRlclNlcnZpY2VHZXRMYWJlbFJlc3BvbnNlEhsKCWxhYmVsX3VybBgBIAEoCVIIbGFiZW'
        'xVcmwSJwoPdHJhY2tpbmdfbnVtYmVyGAIgASgJUg50cmFja2luZ051bWJlchIYCgdjYXJyaWVy'
        'GAMgASgJUgdjYXJyaWVy');

@$core.Deprecated('Use orderServiceListRecentRequestDescriptor instead')
const OrderServiceListRecentRequest$json = {
  '1': 'OrderServiceListRecentRequest',
  '2': [
    {'1': 'limit', '3': 1, '4': 1, '5': 5, '10': 'limit'},
  ],
};

/// Descriptor for `OrderServiceListRecentRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List orderServiceListRecentRequestDescriptor =
    $convert.base64Decode(
        'Ch1PcmRlclNlcnZpY2VMaXN0UmVjZW50UmVxdWVzdBIUCgVsaW1pdBgBIAEoBVIFbGltaXQ=');

@$core.Deprecated('Use orderServiceListRecentResponseDescriptor instead')
const OrderServiceListRecentResponse$json = {
  '1': 'OrderServiceListRecentResponse',
  '2': [
    {
      '1': 'orders',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.creativanta.commerce.v1.Order',
      '10': 'orders'
    },
  ],
};

/// Descriptor for `OrderServiceListRecentResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List orderServiceListRecentResponseDescriptor =
    $convert.base64Decode(
        'Ch5PcmRlclNlcnZpY2VMaXN0UmVjZW50UmVzcG9uc2USNgoGb3JkZXJzGAEgAygLMh4uY3JlYX'
        'RpdmFudGEuY29tbWVyY2UudjEuT3JkZXJSBm9yZGVycw==');

@$core.Deprecated('Use orderServiceBulkCancelRequestDescriptor instead')
const OrderServiceBulkCancelRequest$json = {
  '1': 'OrderServiceBulkCancelRequest',
  '2': [
    {
      '1': 'context',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.CommandContext',
      '10': 'context'
    },
    {'1': 'order_ids', '3': 2, '4': 3, '5': 9, '10': 'orderIds'},
    {'1': 'reason', '3': 3, '4': 1, '5': 9, '10': 'reason'},
  ],
};

/// Descriptor for `OrderServiceBulkCancelRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List orderServiceBulkCancelRequestDescriptor =
    $convert.base64Decode(
        'Ch1PcmRlclNlcnZpY2VCdWxrQ2FuY2VsUmVxdWVzdBI/Cgdjb250ZXh0GAEgASgLMiUuY3JlYX'
        'RpdmFudGEuY29tbW9uLnYxLkNvbW1hbmRDb250ZXh0Ugdjb250ZXh0EhsKCW9yZGVyX2lkcxgC'
        'IAMoCVIIb3JkZXJJZHMSFgoGcmVhc29uGAMgASgJUgZyZWFzb24=');

@$core.Deprecated('Use orderServiceBulkCancelResponseDescriptor instead')
const OrderServiceBulkCancelResponse$json = {
  '1': 'OrderServiceBulkCancelResponse',
  '2': [
    {'1': 'cancelled_count', '3': 1, '4': 1, '5': 5, '10': 'cancelledCount'},
    {'1': 'failed_order_ids', '3': 2, '4': 3, '5': 9, '10': 'failedOrderIds'},
  ],
};

/// Descriptor for `OrderServiceBulkCancelResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List orderServiceBulkCancelResponseDescriptor =
    $convert.base64Decode(
        'Ch5PcmRlclNlcnZpY2VCdWxrQ2FuY2VsUmVzcG9uc2USJwoPY2FuY2VsbGVkX2NvdW50GAEgAS'
        'gFUg5jYW5jZWxsZWRDb3VudBIoChBmYWlsZWRfb3JkZXJfaWRzGAIgAygJUg5mYWlsZWRPcmRl'
        'cklkcw==');

@$core.Deprecated('Use orderServiceBulkUpdateStatusRequestDescriptor instead')
const OrderServiceBulkUpdateStatusRequest$json = {
  '1': 'OrderServiceBulkUpdateStatusRequest',
  '2': [
    {
      '1': 'context',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.CommandContext',
      '10': 'context'
    },
    {'1': 'order_ids', '3': 2, '4': 3, '5': 9, '10': 'orderIds'},
    {
      '1': 'target_state',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.creativanta.commerce.v1.OrderLifecycleState',
      '10': 'targetState'
    },
  ],
};

/// Descriptor for `OrderServiceBulkUpdateStatusRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List orderServiceBulkUpdateStatusRequestDescriptor =
    $convert.base64Decode(
        'CiNPcmRlclNlcnZpY2VCdWxrVXBkYXRlU3RhdHVzUmVxdWVzdBI/Cgdjb250ZXh0GAEgASgLMi'
        'UuY3JlYXRpdmFudGEuY29tbW9uLnYxLkNvbW1hbmRDb250ZXh0Ugdjb250ZXh0EhsKCW9yZGVy'
        'X2lkcxgCIAMoCVIIb3JkZXJJZHMSTwoMdGFyZ2V0X3N0YXRlGAMgASgOMiwuY3JlYXRpdmFudG'
        'EuY29tbWVyY2UudjEuT3JkZXJMaWZlY3ljbGVTdGF0ZVILdGFyZ2V0U3RhdGU=');

@$core.Deprecated('Use orderServiceBulkUpdateStatusResponseDescriptor instead')
const OrderServiceBulkUpdateStatusResponse$json = {
  '1': 'OrderServiceBulkUpdateStatusResponse',
  '2': [
    {'1': 'updated_count', '3': 1, '4': 1, '5': 5, '10': 'updatedCount'},
    {'1': 'failed_order_ids', '3': 2, '4': 3, '5': 9, '10': 'failedOrderIds'},
  ],
};

/// Descriptor for `OrderServiceBulkUpdateStatusResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List orderServiceBulkUpdateStatusResponseDescriptor =
    $convert.base64Decode(
        'CiRPcmRlclNlcnZpY2VCdWxrVXBkYXRlU3RhdHVzUmVzcG9uc2USIwoNdXBkYXRlZF9jb3VudB'
        'gBIAEoBVIMdXBkYXRlZENvdW50EigKEGZhaWxlZF9vcmRlcl9pZHMYAiADKAlSDmZhaWxlZE9y'
        'ZGVySWRz');

@$core.Deprecated('Use inventoryServiceGetSummaryRequestDescriptor instead')
const InventoryServiceGetSummaryRequest$json = {
  '1': 'InventoryServiceGetSummaryRequest',
};

/// Descriptor for `InventoryServiceGetSummaryRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List inventoryServiceGetSummaryRequestDescriptor =
    $convert.base64Decode('CiFJbnZlbnRvcnlTZXJ2aWNlR2V0U3VtbWFyeVJlcXVlc3Q=');

@$core.Deprecated('Use inventoryServiceGetSummaryResponseDescriptor instead')
const InventoryServiceGetSummaryResponse$json = {
  '1': 'InventoryServiceGetSummaryResponse',
  '2': [
    {'1': 'total_skus', '3': 1, '4': 1, '5': 5, '10': 'totalSkus'},
    {'1': 'total_on_hand', '3': 2, '4': 1, '5': 5, '10': 'totalOnHand'},
    {'1': 'total_reserved', '3': 3, '4': 1, '5': 5, '10': 'totalReserved'},
    {'1': 'low_stock_alerts', '3': 4, '4': 1, '5': 5, '10': 'lowStockAlerts'},
  ],
};

/// Descriptor for `InventoryServiceGetSummaryResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List inventoryServiceGetSummaryResponseDescriptor =
    $convert.base64Decode(
        'CiJJbnZlbnRvcnlTZXJ2aWNlR2V0U3VtbWFyeVJlc3BvbnNlEh0KCnRvdGFsX3NrdXMYASABKA'
        'VSCXRvdGFsU2t1cxIiCg10b3RhbF9vbl9oYW5kGAIgASgFUgt0b3RhbE9uSGFuZBIlCg50b3Rh'
        'bF9yZXNlcnZlZBgDIAEoBVINdG90YWxSZXNlcnZlZBIoChBsb3dfc3RvY2tfYWxlcnRzGAQgAS'
        'gFUg5sb3dTdG9ja0FsZXJ0cw==');

@$core.Deprecated('Use inventoryServiceListStockRequestDescriptor instead')
const InventoryServiceListStockRequest$json = {
  '1': 'InventoryServiceListStockRequest',
  '2': [
    {'1': 'location_id', '3': 1, '4': 1, '5': 9, '10': 'locationId'},
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

/// Descriptor for `InventoryServiceListStockRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List inventoryServiceListStockRequestDescriptor =
    $convert.base64Decode(
        'CiBJbnZlbnRvcnlTZXJ2aWNlTGlzdFN0b2NrUmVxdWVzdBIfCgtsb2NhdGlvbl9pZBgBIAEoCV'
        'IKbG9jYXRpb25JZBJBCgpwYWdpbmF0aW9uGAIgASgLMiEuY3JlYXRpdmFudGEuY29tbW9uLnYx'
        'LlBhZ2luYXRpb25SCnBhZ2luYXRpb24=');

@$core.Deprecated('Use inventoryServiceListStockResponseDescriptor instead')
const InventoryServiceListStockResponse$json = {
  '1': 'InventoryServiceListStockResponse',
  '2': [
    {
      '1': 'items',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.creativanta.commerce.v1.InventoryBalance',
      '10': 'items'
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

/// Descriptor for `InventoryServiceListStockResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List inventoryServiceListStockResponseDescriptor =
    $convert.base64Decode(
        'CiFJbnZlbnRvcnlTZXJ2aWNlTGlzdFN0b2NrUmVzcG9uc2USPwoFaXRlbXMYASADKAsyKS5jcm'
        'VhdGl2YW50YS5jb21tZXJjZS52MS5JbnZlbnRvcnlCYWxhbmNlUgVpdGVtcxJICgpwYWdpbmF0'
        'aW9uGAIgASgLMiguY3JlYXRpdmFudGEuY29tbW9uLnYxLlBhZ2luYXRlZFJlc3BvbnNlUgpwYW'
        'dpbmF0aW9u');

@$core.Deprecated('Use inventoryServiceListMovementsRequestDescriptor instead')
const InventoryServiceListMovementsRequest$json = {
  '1': 'InventoryServiceListMovementsRequest',
  '2': [
    {'1': 'sku_id', '3': 1, '4': 1, '5': 9, '10': 'skuId'},
    {'1': 'location_id', '3': 2, '4': 1, '5': 9, '10': 'locationId'},
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

/// Descriptor for `InventoryServiceListMovementsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List inventoryServiceListMovementsRequestDescriptor =
    $convert.base64Decode(
        'CiRJbnZlbnRvcnlTZXJ2aWNlTGlzdE1vdmVtZW50c1JlcXVlc3QSFQoGc2t1X2lkGAEgASgJUg'
        'Vza3VJZBIfCgtsb2NhdGlvbl9pZBgCIAEoCVIKbG9jYXRpb25JZBJBCgpwYWdpbmF0aW9uGAMg'
        'ASgLMiEuY3JlYXRpdmFudGEuY29tbW9uLnYxLlBhZ2luYXRpb25SCnBhZ2luYXRpb24=');

@$core.Deprecated('Use inventoryServiceListMovementsResponseDescriptor instead')
const InventoryServiceListMovementsResponse$json = {
  '1': 'InventoryServiceListMovementsResponse',
  '2': [
    {
      '1': 'movements',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.creativanta.commerce.v1.StockMovement',
      '10': 'movements'
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

/// Descriptor for `InventoryServiceListMovementsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List inventoryServiceListMovementsResponseDescriptor =
    $convert.base64Decode(
        'CiVJbnZlbnRvcnlTZXJ2aWNlTGlzdE1vdmVtZW50c1Jlc3BvbnNlEkQKCW1vdmVtZW50cxgBIA'
        'MoCzImLmNyZWF0aXZhbnRhLmNvbW1lcmNlLnYxLlN0b2NrTW92ZW1lbnRSCW1vdmVtZW50cxJI'
        'CgpwYWdpbmF0aW9uGAIgASgLMiguY3JlYXRpdmFudGEuY29tbW9uLnYxLlBhZ2luYXRlZFJlc3'
        'BvbnNlUgpwYWdpbmF0aW9u');

@$core.Deprecated(
    'Use inventoryServiceCreateStockMovementRequestDescriptor instead')
const InventoryServiceCreateStockMovementRequest$json = {
  '1': 'InventoryServiceCreateStockMovementRequest',
  '2': [
    {
      '1': 'context',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.CommandContext',
      '10': 'context'
    },
    {'1': 'sku_id', '3': 2, '4': 1, '5': 9, '10': 'skuId'},
    {'1': 'location_id', '3': 3, '4': 1, '5': 9, '10': 'locationId'},
    {
      '1': 'movement_type',
      '3': 4,
      '4': 1,
      '5': 14,
      '6': '.creativanta.commerce.v1.StockMovementType',
      '10': 'movementType'
    },
    {'1': 'quantity', '3': 5, '4': 1, '5': 5, '10': 'quantity'},
    {'1': 'reason', '3': 6, '4': 1, '5': 9, '10': 'reason'},
    {'1': 'reference_type', '3': 7, '4': 1, '5': 9, '10': 'referenceType'},
    {'1': 'reference_id', '3': 8, '4': 1, '5': 9, '10': 'referenceId'},
  ],
};

/// Descriptor for `InventoryServiceCreateStockMovementRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List
    inventoryServiceCreateStockMovementRequestDescriptor =
    $convert.base64Decode(
        'CipJbnZlbnRvcnlTZXJ2aWNlQ3JlYXRlU3RvY2tNb3ZlbWVudFJlcXVlc3QSPwoHY29udGV4dB'
        'gBIAEoCzIlLmNyZWF0aXZhbnRhLmNvbW1vbi52MS5Db21tYW5kQ29udGV4dFIHY29udGV4dBIV'
        'CgZza3VfaWQYAiABKAlSBXNrdUlkEh8KC2xvY2F0aW9uX2lkGAMgASgJUgpsb2NhdGlvbklkEk'
        '8KDW1vdmVtZW50X3R5cGUYBCABKA4yKi5jcmVhdGl2YW50YS5jb21tZXJjZS52MS5TdG9ja01v'
        'dmVtZW50VHlwZVIMbW92ZW1lbnRUeXBlEhoKCHF1YW50aXR5GAUgASgFUghxdWFudGl0eRIWCg'
        'ZyZWFzb24YBiABKAlSBnJlYXNvbhIlCg5yZWZlcmVuY2VfdHlwZRgHIAEoCVINcmVmZXJlbmNl'
        'VHlwZRIhCgxyZWZlcmVuY2VfaWQYCCABKAlSC3JlZmVyZW5jZUlk');

@$core.Deprecated(
    'Use inventoryServiceCreateStockMovementResponseDescriptor instead')
const InventoryServiceCreateStockMovementResponse$json = {
  '1': 'InventoryServiceCreateStockMovementResponse',
  '2': [
    {
      '1': 'movement',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.commerce.v1.StockMovement',
      '10': 'movement'
    },
    {
      '1': 'new_balance',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.creativanta.commerce.v1.InventoryBalance',
      '10': 'newBalance'
    },
  ],
};

/// Descriptor for `InventoryServiceCreateStockMovementResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List
    inventoryServiceCreateStockMovementResponseDescriptor =
    $convert.base64Decode(
        'CitJbnZlbnRvcnlTZXJ2aWNlQ3JlYXRlU3RvY2tNb3ZlbWVudFJlc3BvbnNlEkIKCG1vdmVtZW'
        '50GAEgASgLMiYuY3JlYXRpdmFudGEuY29tbWVyY2UudjEuU3RvY2tNb3ZlbWVudFIIbW92ZW1l'
        'bnQSSgoLbmV3X2JhbGFuY2UYAiABKAsyKS5jcmVhdGl2YW50YS5jb21tZXJjZS52MS5JbnZlbn'
        'RvcnlCYWxhbmNlUgpuZXdCYWxhbmNl');

@$core.Deprecated('Use inventoryServiceBulkStockInRequestDescriptor instead')
const InventoryServiceBulkStockInRequest$json = {
  '1': 'InventoryServiceBulkStockInRequest',
  '2': [
    {
      '1': 'context',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.CommandContext',
      '10': 'context'
    },
    {'1': 'location_id', '3': 2, '4': 1, '5': 9, '10': 'locationId'},
    {
      '1': 'items',
      '3': 3,
      '4': 3,
      '5': 11,
      '6': '.creativanta.commerce.v1.StockMovementItem',
      '10': 'items'
    },
    {'1': 'reason', '3': 4, '4': 1, '5': 9, '10': 'reason'},
  ],
};

/// Descriptor for `InventoryServiceBulkStockInRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List inventoryServiceBulkStockInRequestDescriptor =
    $convert.base64Decode(
        'CiJJbnZlbnRvcnlTZXJ2aWNlQnVsa1N0b2NrSW5SZXF1ZXN0Ej8KB2NvbnRleHQYASABKAsyJS'
        '5jcmVhdGl2YW50YS5jb21tb24udjEuQ29tbWFuZENvbnRleHRSB2NvbnRleHQSHwoLbG9jYXRp'
        'b25faWQYAiABKAlSCmxvY2F0aW9uSWQSQAoFaXRlbXMYAyADKAsyKi5jcmVhdGl2YW50YS5jb2'
        '1tZXJjZS52MS5TdG9ja01vdmVtZW50SXRlbVIFaXRlbXMSFgoGcmVhc29uGAQgASgJUgZyZWFz'
        'b24=');

@$core.Deprecated('Use inventoryServiceBulkStockInResponseDescriptor instead')
const InventoryServiceBulkStockInResponse$json = {
  '1': 'InventoryServiceBulkStockInResponse',
  '2': [
    {'1': 'processed_count', '3': 1, '4': 1, '5': 5, '10': 'processedCount'},
    {
      '1': 'movements',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.creativanta.commerce.v1.StockMovement',
      '10': 'movements'
    },
  ],
};

/// Descriptor for `InventoryServiceBulkStockInResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List inventoryServiceBulkStockInResponseDescriptor =
    $convert.base64Decode(
        'CiNJbnZlbnRvcnlTZXJ2aWNlQnVsa1N0b2NrSW5SZXNwb25zZRInCg9wcm9jZXNzZWRfY291bn'
        'QYASABKAVSDnByb2Nlc3NlZENvdW50EkQKCW1vdmVtZW50cxgCIAMoCzImLmNyZWF0aXZhbnRh'
        'LmNvbW1lcmNlLnYxLlN0b2NrTW92ZW1lbnRSCW1vdmVtZW50cw==');

@$core.Deprecated('Use inventoryServiceGetAlertsRequestDescriptor instead')
const InventoryServiceGetAlertsRequest$json = {
  '1': 'InventoryServiceGetAlertsRequest',
};

/// Descriptor for `InventoryServiceGetAlertsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List inventoryServiceGetAlertsRequestDescriptor =
    $convert.base64Decode('CiBJbnZlbnRvcnlTZXJ2aWNlR2V0QWxlcnRzUmVxdWVzdA==');

@$core.Deprecated('Use inventoryServiceGetAlertsResponseDescriptor instead')
const InventoryServiceGetAlertsResponse$json = {
  '1': 'InventoryServiceGetAlertsResponse',
  '2': [
    {
      '1': 'alerts',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.creativanta.commerce.v1.InventoryAlert',
      '10': 'alerts'
    },
  ],
};

/// Descriptor for `InventoryServiceGetAlertsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List inventoryServiceGetAlertsResponseDescriptor =
    $convert.base64Decode(
        'CiFJbnZlbnRvcnlTZXJ2aWNlR2V0QWxlcnRzUmVzcG9uc2USPwoGYWxlcnRzGAEgAygLMicuY3'
        'JlYXRpdmFudGEuY29tbWVyY2UudjEuSW52ZW50b3J5QWxlcnRSBmFsZXJ0cw==');

@$core
    .Deprecated('Use inventoryServiceUpdateThresholdsRequestDescriptor instead')
const InventoryServiceUpdateThresholdsRequest$json = {
  '1': 'InventoryServiceUpdateThresholdsRequest',
  '2': [
    {
      '1': 'context',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.CommandContext',
      '10': 'context'
    },
    {'1': 'sku_id', '3': 2, '4': 1, '5': 9, '10': 'skuId'},
    {
      '1': 'low_stock_threshold',
      '3': 3,
      '4': 1,
      '5': 5,
      '10': 'lowStockThreshold'
    },
  ],
};

/// Descriptor for `InventoryServiceUpdateThresholdsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List inventoryServiceUpdateThresholdsRequestDescriptor =
    $convert.base64Decode(
        'CidJbnZlbnRvcnlTZXJ2aWNlVXBkYXRlVGhyZXNob2xkc1JlcXVlc3QSPwoHY29udGV4dBgBIA'
        'EoCzIlLmNyZWF0aXZhbnRhLmNvbW1vbi52MS5Db21tYW5kQ29udGV4dFIHY29udGV4dBIVCgZz'
        'a3VfaWQYAiABKAlSBXNrdUlkEi4KE2xvd19zdG9ja190aHJlc2hvbGQYAyABKAVSEWxvd1N0b2'
        'NrVGhyZXNob2xk');

@$core.Deprecated(
    'Use inventoryServiceUpdateThresholdsResponseDescriptor instead')
const InventoryServiceUpdateThresholdsResponse$json = {
  '1': 'InventoryServiceUpdateThresholdsResponse',
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

/// Descriptor for `InventoryServiceUpdateThresholdsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List inventoryServiceUpdateThresholdsResponseDescriptor =
    $convert.base64Decode(
        'CihJbnZlbnRvcnlTZXJ2aWNlVXBkYXRlVGhyZXNob2xkc1Jlc3BvbnNlEhUKBnNrdV9pZBgBIA'
        'EoCVIFc2t1SWQSLgoTbG93X3N0b2NrX3RocmVzaG9sZBgCIAEoBVIRbG93U3RvY2tUaHJlc2hv'
        'bGQ=');

@$core.Deprecated('Use inventoryServiceExportRequestDescriptor instead')
const InventoryServiceExportRequest$json = {
  '1': 'InventoryServiceExportRequest',
  '2': [
    {'1': 'location_id', '3': 1, '4': 1, '5': 9, '10': 'locationId'},
    {'1': 'format', '3': 2, '4': 1, '5': 9, '10': 'format'},
  ],
};

/// Descriptor for `InventoryServiceExportRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List inventoryServiceExportRequestDescriptor =
    $convert.base64Decode(
        'Ch1JbnZlbnRvcnlTZXJ2aWNlRXhwb3J0UmVxdWVzdBIfCgtsb2NhdGlvbl9pZBgBIAEoCVIKbG'
        '9jYXRpb25JZBIWCgZmb3JtYXQYAiABKAlSBmZvcm1hdA==');

@$core.Deprecated('Use inventoryServiceExportResponseDescriptor instead')
const InventoryServiceExportResponse$json = {
  '1': 'InventoryServiceExportResponse',
  '2': [
    {'1': 'download_url', '3': 1, '4': 1, '5': 9, '10': 'downloadUrl'},
    {'1': 'row_count', '3': 2, '4': 1, '5': 5, '10': 'rowCount'},
  ],
};

/// Descriptor for `InventoryServiceExportResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List inventoryServiceExportResponseDescriptor =
    $convert.base64Decode(
        'Ch5JbnZlbnRvcnlTZXJ2aWNlRXhwb3J0UmVzcG9uc2USIQoMZG93bmxvYWRfdXJsGAEgASgJUg'
        'tkb3dubG9hZFVybBIbCglyb3dfY291bnQYAiABKAVSCHJvd0NvdW50');

@$core.Deprecated('Use refundServiceCreateRequestDescriptor instead')
const RefundServiceCreateRequest$json = {
  '1': 'RefundServiceCreateRequest',
  '2': [
    {
      '1': 'context',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.CommandContext',
      '10': 'context'
    },
    {'1': 'order_id', '3': 2, '4': 1, '5': 9, '10': 'orderId'},
    {
      '1': 'amount',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.Money',
      '10': 'amount'
    },
    {'1': 'reason', '3': 4, '4': 1, '5': 9, '10': 'reason'},
    {'1': 'refund_type', '3': 5, '4': 1, '5': 9, '10': 'refundType'},
  ],
};

/// Descriptor for `RefundServiceCreateRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List refundServiceCreateRequestDescriptor = $convert.base64Decode(
    'ChpSZWZ1bmRTZXJ2aWNlQ3JlYXRlUmVxdWVzdBI/Cgdjb250ZXh0GAEgASgLMiUuY3JlYXRpdm'
    'FudGEuY29tbW9uLnYxLkNvbW1hbmRDb250ZXh0Ugdjb250ZXh0EhkKCG9yZGVyX2lkGAIgASgJ'
    'UgdvcmRlcklkEjQKBmFtb3VudBgDIAEoCzIcLmNyZWF0aXZhbnRhLmNvbW1vbi52MS5Nb25leV'
    'IGYW1vdW50EhYKBnJlYXNvbhgEIAEoCVIGcmVhc29uEh8KC3JlZnVuZF90eXBlGAUgASgJUgpy'
    'ZWZ1bmRUeXBl');

@$core.Deprecated('Use refundServiceCreateResponseDescriptor instead')
const RefundServiceCreateResponse$json = {
  '1': 'RefundServiceCreateResponse',
  '2': [
    {
      '1': 'refund',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.commerce.v1.Refund',
      '10': 'refund'
    },
    {
      '1': 'updated_order',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.creativanta.commerce.v1.Order',
      '10': 'updatedOrder'
    },
  ],
};

/// Descriptor for `RefundServiceCreateResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List refundServiceCreateResponseDescriptor =
    $convert.base64Decode(
        'ChtSZWZ1bmRTZXJ2aWNlQ3JlYXRlUmVzcG9uc2USNwoGcmVmdW5kGAEgASgLMh8uY3JlYXRpdm'
        'FudGEuY29tbWVyY2UudjEuUmVmdW5kUgZyZWZ1bmQSQwoNdXBkYXRlZF9vcmRlchgCIAEoCzIe'
        'LmNyZWF0aXZhbnRhLmNvbW1lcmNlLnYxLk9yZGVyUgx1cGRhdGVkT3JkZXI=');

@$core.Deprecated('Use refundServiceGetRequestDescriptor instead')
const RefundServiceGetRequest$json = {
  '1': 'RefundServiceGetRequest',
  '2': [
    {'1': 'refund_id', '3': 1, '4': 1, '5': 9, '10': 'refundId'},
  ],
};

/// Descriptor for `RefundServiceGetRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List refundServiceGetRequestDescriptor =
    $convert.base64Decode(
        'ChdSZWZ1bmRTZXJ2aWNlR2V0UmVxdWVzdBIbCglyZWZ1bmRfaWQYASABKAlSCHJlZnVuZElk');

@$core.Deprecated('Use refundServiceGetResponseDescriptor instead')
const RefundServiceGetResponse$json = {
  '1': 'RefundServiceGetResponse',
  '2': [
    {
      '1': 'refund',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.commerce.v1.Refund',
      '10': 'refund'
    },
  ],
};

/// Descriptor for `RefundServiceGetResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List refundServiceGetResponseDescriptor =
    $convert.base64Decode(
        'ChhSZWZ1bmRTZXJ2aWNlR2V0UmVzcG9uc2USNwoGcmVmdW5kGAEgASgLMh8uY3JlYXRpdmFudG'
        'EuY29tbWVyY2UudjEuUmVmdW5kUgZyZWZ1bmQ=');

@$core.Deprecated('Use refundServiceListRequestDescriptor instead')
const RefundServiceListRequest$json = {
  '1': 'RefundServiceListRequest',
  '2': [
    {'1': 'order_id', '3': 1, '4': 1, '5': 9, '10': 'orderId'},
    {
      '1': 'state',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.creativanta.commerce.v1.RefundLifecycleState',
      '10': 'state'
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

/// Descriptor for `RefundServiceListRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List refundServiceListRequestDescriptor = $convert.base64Decode(
    'ChhSZWZ1bmRTZXJ2aWNlTGlzdFJlcXVlc3QSGQoIb3JkZXJfaWQYASABKAlSB29yZGVySWQSQw'
    'oFc3RhdGUYAiABKA4yLS5jcmVhdGl2YW50YS5jb21tZXJjZS52MS5SZWZ1bmRMaWZlY3ljbGVT'
    'dGF0ZVIFc3RhdGUSQQoKcGFnaW5hdGlvbhgDIAEoCzIhLmNyZWF0aXZhbnRhLmNvbW1vbi52MS'
    '5QYWdpbmF0aW9uUgpwYWdpbmF0aW9u');

@$core.Deprecated('Use refundServiceListResponseDescriptor instead')
const RefundServiceListResponse$json = {
  '1': 'RefundServiceListResponse',
  '2': [
    {
      '1': 'refunds',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.creativanta.commerce.v1.Refund',
      '10': 'refunds'
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

/// Descriptor for `RefundServiceListResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List refundServiceListResponseDescriptor = $convert.base64Decode(
    'ChlSZWZ1bmRTZXJ2aWNlTGlzdFJlc3BvbnNlEjkKB3JlZnVuZHMYASADKAsyHy5jcmVhdGl2YW'
    '50YS5jb21tZXJjZS52MS5SZWZ1bmRSB3JlZnVuZHMSSAoKcGFnaW5hdGlvbhgCIAEoCzIoLmNy'
    'ZWF0aXZhbnRhLmNvbW1vbi52MS5QYWdpbmF0ZWRSZXNwb25zZVIKcGFnaW5hdGlvbg==');

@$core.Deprecated('Use refundServiceApproveRequestDescriptor instead')
const RefundServiceApproveRequest$json = {
  '1': 'RefundServiceApproveRequest',
  '2': [
    {
      '1': 'context',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.CommandContext',
      '10': 'context'
    },
    {'1': 'refund_id', '3': 2, '4': 1, '5': 9, '10': 'refundId'},
    {'1': 'reason', '3': 3, '4': 1, '5': 9, '10': 'reason'},
  ],
};

/// Descriptor for `RefundServiceApproveRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List refundServiceApproveRequestDescriptor =
    $convert.base64Decode(
        'ChtSZWZ1bmRTZXJ2aWNlQXBwcm92ZVJlcXVlc3QSPwoHY29udGV4dBgBIAEoCzIlLmNyZWF0aX'
        'ZhbnRhLmNvbW1vbi52MS5Db21tYW5kQ29udGV4dFIHY29udGV4dBIbCglyZWZ1bmRfaWQYAiAB'
        'KAlSCHJlZnVuZElkEhYKBnJlYXNvbhgDIAEoCVIGcmVhc29u');

@$core.Deprecated('Use refundServiceApproveResponseDescriptor instead')
const RefundServiceApproveResponse$json = {
  '1': 'RefundServiceApproveResponse',
  '2': [
    {
      '1': 'refund',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.commerce.v1.Refund',
      '10': 'refund'
    },
    {
      '1': 'updated_order',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.creativanta.commerce.v1.Order',
      '10': 'updatedOrder'
    },
  ],
};

/// Descriptor for `RefundServiceApproveResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List refundServiceApproveResponseDescriptor =
    $convert.base64Decode(
        'ChxSZWZ1bmRTZXJ2aWNlQXBwcm92ZVJlc3BvbnNlEjcKBnJlZnVuZBgBIAEoCzIfLmNyZWF0aX'
        'ZhbnRhLmNvbW1lcmNlLnYxLlJlZnVuZFIGcmVmdW5kEkMKDXVwZGF0ZWRfb3JkZXIYAiABKAsy'
        'Hi5jcmVhdGl2YW50YS5jb21tZXJjZS52MS5PcmRlclIMdXBkYXRlZE9yZGVy');

@$core.Deprecated('Use refundServiceRejectRequestDescriptor instead')
const RefundServiceRejectRequest$json = {
  '1': 'RefundServiceRejectRequest',
  '2': [
    {
      '1': 'context',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.CommandContext',
      '10': 'context'
    },
    {'1': 'refund_id', '3': 2, '4': 1, '5': 9, '10': 'refundId'},
    {'1': 'reason', '3': 3, '4': 1, '5': 9, '10': 'reason'},
  ],
};

/// Descriptor for `RefundServiceRejectRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List refundServiceRejectRequestDescriptor =
    $convert.base64Decode(
        'ChpSZWZ1bmRTZXJ2aWNlUmVqZWN0UmVxdWVzdBI/Cgdjb250ZXh0GAEgASgLMiUuY3JlYXRpdm'
        'FudGEuY29tbW9uLnYxLkNvbW1hbmRDb250ZXh0Ugdjb250ZXh0EhsKCXJlZnVuZF9pZBgCIAEo'
        'CVIIcmVmdW5kSWQSFgoGcmVhc29uGAMgASgJUgZyZWFzb24=');

@$core.Deprecated('Use refundServiceRejectResponseDescriptor instead')
const RefundServiceRejectResponse$json = {
  '1': 'RefundServiceRejectResponse',
  '2': [
    {
      '1': 'refund',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.commerce.v1.Refund',
      '10': 'refund'
    },
  ],
};

/// Descriptor for `RefundServiceRejectResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List refundServiceRejectResponseDescriptor =
    $convert.base64Decode(
        'ChtSZWZ1bmRTZXJ2aWNlUmVqZWN0UmVzcG9uc2USNwoGcmVmdW5kGAEgASgLMh8uY3JlYXRpdm'
        'FudGEuY29tbWVyY2UudjEuUmVmdW5kUgZyZWZ1bmQ=');

@$core.Deprecated('Use refundServiceGetStatsRequestDescriptor instead')
const RefundServiceGetStatsRequest$json = {
  '1': 'RefundServiceGetStatsRequest',
};

/// Descriptor for `RefundServiceGetStatsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List refundServiceGetStatsRequestDescriptor =
    $convert.base64Decode('ChxSZWZ1bmRTZXJ2aWNlR2V0U3RhdHNSZXF1ZXN0');

@$core.Deprecated('Use refundServiceGetStatsResponseDescriptor instead')
const RefundServiceGetStatsResponse$json = {
  '1': 'RefundServiceGetStatsResponse',
  '2': [
    {'1': 'total_refunds', '3': 1, '4': 1, '5': 5, '10': 'totalRefunds'},
    {
      '1': 'total_refunded_amount',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.Money',
      '10': 'totalRefundedAmount'
    },
    {
      '1': 'pending_approval_count',
      '3': 3,
      '4': 1,
      '5': 5,
      '10': 'pendingApprovalCount'
    },
  ],
};

/// Descriptor for `RefundServiceGetStatsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List refundServiceGetStatsResponseDescriptor = $convert.base64Decode(
    'Ch1SZWZ1bmRTZXJ2aWNlR2V0U3RhdHNSZXNwb25zZRIjCg10b3RhbF9yZWZ1bmRzGAEgASgFUg'
    'x0b3RhbFJlZnVuZHMSUAoVdG90YWxfcmVmdW5kZWRfYW1vdW50GAIgASgLMhwuY3JlYXRpdmFu'
    'dGEuY29tbW9uLnYxLk1vbmV5UhN0b3RhbFJlZnVuZGVkQW1vdW50EjQKFnBlbmRpbmdfYXBwcm'
    '92YWxfY291bnQYAyABKAVSFHBlbmRpbmdBcHByb3ZhbENvdW50');

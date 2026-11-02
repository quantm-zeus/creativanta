// This is a generated file - do not edit.
//
// Generated from creativanta/finance/v1/finance.proto.

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

@$core.Deprecated('Use financialComponentDescriptor instead')
const FinancialComponent$json = {
  '1': 'FinancialComponent',
  '2': [
    {'1': 'FINANCIAL_COMPONENT_UNSPECIFIED', '2': 0},
    {'1': 'FINANCIAL_COMPONENT_REVENUE', '2': 1},
    {'1': 'FINANCIAL_COMPONENT_PLATFORM_FEE', '2': 2},
    {'1': 'FINANCIAL_COMPONENT_SHIPPING', '2': 3},
    {'1': 'FINANCIAL_COMPONENT_COGS', '2': 4},
    {'1': 'FINANCIAL_COMPONENT_AI_CREDITS', '2': 5},
    {'1': 'FINANCIAL_COMPONENT_COMMISSION', '2': 6},
    {'1': 'FINANCIAL_COMPONENT_ADS_SPEND', '2': 7},
    {'1': 'FINANCIAL_COMPONENT_SEEDING', '2': 8},
    {'1': 'FINANCIAL_COMPONENT_REFUND', '2': 9},
    {'1': 'FINANCIAL_COMPONENT_OTHER', '2': 10},
  ],
};

/// Descriptor for `FinancialComponent`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List financialComponentDescriptor = $convert.base64Decode(
    'ChJGaW5hbmNpYWxDb21wb25lbnQSIwofRklOQU5DSUFMX0NPTVBPTkVOVF9VTlNQRUNJRklFRB'
    'AAEh8KG0ZJTkFOQ0lBTF9DT01QT05FTlRfUkVWRU5VRRABEiQKIEZJTkFOQ0lBTF9DT01QT05F'
    'TlRfUExBVEZPUk1fRkVFEAISIAocRklOQU5DSUFMX0NPTVBPTkVOVF9TSElQUElORxADEhwKGE'
    'ZJTkFOQ0lBTF9DT01QT05FTlRfQ09HUxAEEiIKHkZJTkFOQ0lBTF9DT01QT05FTlRfQUlfQ1JF'
    'RElUUxAFEiIKHkZJTkFOQ0lBTF9DT01QT05FTlRfQ09NTUlTU0lPThAGEiEKHUZJTkFOQ0lBTF'
    '9DT01QT05FTlRfQURTX1NQRU5EEAcSHwobRklOQU5DSUFMX0NPTVBPTkVOVF9TRUVESU5HEAgS'
    'HgoaRklOQU5DSUFMX0NPTVBPTkVOVF9SRUZVTkQQCRIdChlGSU5BTkNJQUxfQ09NUE9ORU5UX0'
    '9USEVSEAo=');

@$core.Deprecated('Use reconciliationStateDescriptor instead')
const ReconciliationState$json = {
  '1': 'ReconciliationState',
  '2': [
    {'1': 'RECONCILIATION_STATE_UNSPECIFIED', '2': 0},
    {'1': 'RECONCILIATION_STATE_IMPORTED_ONLY', '2': 1},
    {'1': 'RECONCILIATION_STATE_AWAITING_EVIDENCE', '2': 2},
    {'1': 'RECONCILIATION_STATE_INFERRED_PENDING_CONFIRMATION', '2': 3},
    {'1': 'RECONCILIATION_STATE_PARTIALLY_RECONCILED', '2': 4},
    {'1': 'RECONCILIATION_STATE_FULLY_RECONCILED', '2': 5},
    {'1': 'RECONCILIATION_STATE_CONFLICT_DETECTED', '2': 6},
    {'1': 'RECONCILIATION_STATE_MANUALLY_OVERRIDDEN', '2': 7},
  ],
};

/// Descriptor for `ReconciliationState`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List reconciliationStateDescriptor = $convert.base64Decode(
    'ChNSZWNvbmNpbGlhdGlvblN0YXRlEiQKIFJFQ09OQ0lMSUFUSU9OX1NUQVRFX1VOU1BFQ0lGSU'
    'VEEAASJgoiUkVDT05DSUxJQVRJT05fU1RBVEVfSU1QT1JURURfT05MWRABEioKJlJFQ09OQ0lM'
    'SUFUSU9OX1NUQVRFX0FXQUlUSU5HX0VWSURFTkNFEAISNgoyUkVDT05DSUxJQVRJT05fU1RBVE'
    'VfSU5GRVJSRURfUEVORElOR19DT05GSVJNQVRJT04QAxItCilSRUNPTkNJTElBVElPTl9TVEFU'
    'RV9QQVJUSUFMTFlfUkVDT05DSUxFRBAEEikKJVJFQ09OQ0lMSUFUSU9OX1NUQVRFX0ZVTExZX1'
    'JFQ09OQ0lMRUQQBRIqCiZSRUNPTkNJTElBVElPTl9TVEFURV9DT05GTElDVF9ERVRFQ1RFRBAG'
    'EiwKKFJFQ09OQ0lMSUFUSU9OX1NUQVRFX01BTlVBTExZX09WRVJSSURERU4QBw==');

@$core.Deprecated('Use settlementStateDescriptor instead')
const SettlementState$json = {
  '1': 'SettlementState',
  '2': [
    {'1': 'SETTLEMENT_STATE_UNSPECIFIED', '2': 0},
    {'1': 'SETTLEMENT_STATE_IMPORTED', '2': 1},
    {'1': 'SETTLEMENT_STATE_NORMALIZED', '2': 2},
    {'1': 'SETTLEMENT_STATE_READY_FOR_MATCHING', '2': 3},
    {'1': 'SETTLEMENT_STATE_ARCHIVED', '2': 4},
  ],
};

/// Descriptor for `SettlementState`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List settlementStateDescriptor = $convert.base64Decode(
    'Cg9TZXR0bGVtZW50U3RhdGUSIAocU0VUVExFTUVOVF9TVEFURV9VTlNQRUNJRklFRBAAEh0KGV'
    'NFVFRMRU1FTlRfU1RBVEVfSU1QT1JURUQQARIfChtTRVRUTEVNRU5UX1NUQVRFX05PUk1BTEla'
    'RUQQAhInCiNTRVRUTEVNRU5UX1NUQVRFX1JFQURZX0ZPUl9NQVRDSElORxADEh0KGVNFVFRMRU'
    '1FTlRfU1RBVEVfQVJDSElWRUQQBA==');

@$core.Deprecated('Use costStateDescriptor instead')
const CostState$json = {
  '1': 'CostState',
  '2': [
    {'1': 'COST_STATE_UNSPECIFIED', '2': 0},
    {'1': 'COST_STATE_RECORDED', '2': 1},
    {'1': 'COST_STATE_PENDING_EVIDENCE', '2': 2},
    {'1': 'COST_STATE_RECONCILED', '2': 3},
    {'1': 'COST_STATE_ESTIMATED', '2': 4},
    {'1': 'COST_STATE_SUPERSEDED', '2': 5},
  ],
};

/// Descriptor for `CostState`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List costStateDescriptor = $convert.base64Decode(
    'CglDb3N0U3RhdGUSGgoWQ09TVF9TVEFURV9VTlNQRUNJRklFRBAAEhcKE0NPU1RfU1RBVEVfUk'
    'VDT1JERUQQARIfChtDT1NUX1NUQVRFX1BFTkRJTkdfRVZJREVOQ0UQAhIZChVDT1NUX1NUQVRF'
    'X1JFQ09OQ0lMRUQQAxIYChRDT1NUX1NUQVRFX0VTVElNQVRFRBAEEhkKFUNPU1RfU1RBVEVfU1'
    'VQRVJTRURFRBAF');

@$core.Deprecated('Use exchangeRateSnapshotDescriptor instead')
const ExchangeRateSnapshot$json = {
  '1': 'ExchangeRateSnapshot',
  '2': [
    {'1': 'base_currency', '3': 1, '4': 1, '5': 9, '10': 'baseCurrency'},
    {'1': 'quote_currency', '3': 2, '4': 1, '5': 9, '10': 'quoteCurrency'},
    {'1': 'rate_to_base', '3': 3, '4': 1, '5': 9, '10': 'rateToBase'},
    {'1': 'provider', '3': 4, '4': 1, '5': 9, '10': 'provider'},
    {
      '1': 'captured_at',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'capturedAt'
    },
    {
      '1': 'effective_at',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'effectiveAt'
    },
    {
      '1': 'source_class',
      '3': 7,
      '4': 1,
      '5': 14,
      '6': '.creativanta.common.v1.SourceClass',
      '10': 'sourceClass'
    },
  ],
};

/// Descriptor for `ExchangeRateSnapshot`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List exchangeRateSnapshotDescriptor = $convert.base64Decode(
    'ChRFeGNoYW5nZVJhdGVTbmFwc2hvdBIjCg1iYXNlX2N1cnJlbmN5GAEgASgJUgxiYXNlQ3Vycm'
    'VuY3kSJQoOcXVvdGVfY3VycmVuY3kYAiABKAlSDXF1b3RlQ3VycmVuY3kSIAoMcmF0ZV90b19i'
    'YXNlGAMgASgJUgpyYXRlVG9CYXNlEhoKCHByb3ZpZGVyGAQgASgJUghwcm92aWRlchI7CgtjYX'
    'B0dXJlZF9hdBgFIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSCmNhcHR1cmVkQXQS'
    'PQoMZWZmZWN0aXZlX2F0GAYgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFILZWZmZW'
    'N0aXZlQXQSRQoMc291cmNlX2NsYXNzGAcgASgOMiIuY3JlYXRpdmFudGEuY29tbW9uLnYxLlNv'
    'dXJjZUNsYXNzUgtzb3VyY2VDbGFzcw==');

@$core.Deprecated('Use financialPostingDescriptor instead')
const FinancialPosting$json = {
  '1': 'FinancialPosting',
  '2': [
    {'1': 'posting_id', '3': 1, '4': 1, '5': 9, '10': 'postingId'},
    {'1': 'workspace_id', '3': 2, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'origin_type', '3': 3, '4': 1, '5': 9, '10': 'originType'},
    {'1': 'origin_id', '3': 4, '4': 1, '5': 9, '10': 'originId'},
    {'1': 'origin_version', '3': 5, '4': 1, '5': 9, '10': 'originVersion'},
    {
      '1': 'component',
      '3': 6,
      '4': 1,
      '5': 14,
      '6': '.creativanta.finance.v1.FinancialComponent',
      '10': 'component'
    },
    {
      '1': 'amount',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.Money',
      '10': 'amount'
    },
    {
      '1': 'source_class',
      '3': 8,
      '4': 1,
      '5': 14,
      '6': '.creativanta.common.v1.SourceClass',
      '10': 'sourceClass'
    },
    {
      '1': 'confidence',
      '3': 9,
      '4': 1,
      '5': 14,
      '6': '.creativanta.common.v1.ConfidenceBand',
      '10': 'confidence'
    },
    {
      '1': 'exchange_rate',
      '3': 10,
      '4': 1,
      '5': 11,
      '6': '.creativanta.finance.v1.ExchangeRateSnapshot',
      '10': 'exchangeRate'
    },
    {'1': 'reversal_of', '3': 11, '4': 1, '5': 9, '10': 'reversalOf'},
    {
      '1': 'effective_at',
      '3': 12,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'effectiveAt'
    },
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

/// Descriptor for `FinancialPosting`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List financialPostingDescriptor = $convert.base64Decode(
    'ChBGaW5hbmNpYWxQb3N0aW5nEh0KCnBvc3RpbmdfaWQYASABKAlSCXBvc3RpbmdJZBIhCgx3b3'
    'Jrc3BhY2VfaWQYAiABKAlSC3dvcmtzcGFjZUlkEh8KC29yaWdpbl90eXBlGAMgASgJUgpvcmln'
    'aW5UeXBlEhsKCW9yaWdpbl9pZBgEIAEoCVIIb3JpZ2luSWQSJQoOb3JpZ2luX3ZlcnNpb24YBS'
    'ABKAlSDW9yaWdpblZlcnNpb24SSAoJY29tcG9uZW50GAYgASgOMiouY3JlYXRpdmFudGEuZmlu'
    'YW5jZS52MS5GaW5hbmNpYWxDb21wb25lbnRSCWNvbXBvbmVudBI0CgZhbW91bnQYByABKAsyHC'
    '5jcmVhdGl2YW50YS5jb21tb24udjEuTW9uZXlSBmFtb3VudBJFCgxzb3VyY2VfY2xhc3MYCCAB'
    'KA4yIi5jcmVhdGl2YW50YS5jb21tb24udjEuU291cmNlQ2xhc3NSC3NvdXJjZUNsYXNzEkUKCm'
    'NvbmZpZGVuY2UYCSABKA4yJS5jcmVhdGl2YW50YS5jb21tb24udjEuQ29uZmlkZW5jZUJhbmRS'
    'CmNvbmZpZGVuY2USUQoNZXhjaGFuZ2VfcmF0ZRgKIAEoCzIsLmNyZWF0aXZhbnRhLmZpbmFuY2'
    'UudjEuRXhjaGFuZ2VSYXRlU25hcHNob3RSDGV4Y2hhbmdlUmF0ZRIfCgtyZXZlcnNhbF9vZhgL'
    'IAEoCVIKcmV2ZXJzYWxPZhI9CgxlZmZlY3RpdmVfYXQYDCABKAsyGi5nb29nbGUucHJvdG9idW'
    'YuVGltZXN0YW1wUgtlZmZlY3RpdmVBdBI5CgpjcmVhdGVkX2F0GA0gASgLMhouZ29vZ2xlLnBy'
    'b3RvYnVmLlRpbWVzdGFtcFIJY3JlYXRlZEF0');

@$core.Deprecated('Use costItemDescriptor instead')
const CostItem$json = {
  '1': 'CostItem',
  '2': [
    {'1': 'cost_item_id', '3': 1, '4': 1, '5': 9, '10': 'costItemId'},
    {'1': 'workspace_id', '3': 2, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'cost_type', '3': 3, '4': 1, '5': 9, '10': 'costType'},
    {
      '1': 'amount',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.Money',
      '10': 'amount'
    },
    {'1': 'description', '3': 5, '4': 1, '5': 9, '10': 'description'},
    {
      '1': 'related_scope_type',
      '3': 6,
      '4': 1,
      '5': 9,
      '10': 'relatedScopeType'
    },
    {'1': 'related_scope_id', '3': 7, '4': 1, '5': 9, '10': 'relatedScopeId'},
    {
      '1': 'source_class',
      '3': 8,
      '4': 1,
      '5': 14,
      '6': '.creativanta.common.v1.SourceClass',
      '10': 'sourceClass'
    },
    {'1': 'evidence_id', '3': 9, '4': 1, '5': 9, '10': 'evidenceId'},
    {
      '1': 'confidence_reason',
      '3': 10,
      '4': 1,
      '5': 9,
      '10': 'confidenceReason'
    },
    {
      '1': 'cost_state',
      '3': 11,
      '4': 1,
      '5': 14,
      '6': '.creativanta.finance.v1.CostState',
      '10': 'costState'
    },
    {'1': 'effective_date', '3': 12, '4': 1, '5': 9, '10': 'effectiveDate'},
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

/// Descriptor for `CostItem`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List costItemDescriptor = $convert.base64Decode(
    'CghDb3N0SXRlbRIgCgxjb3N0X2l0ZW1faWQYASABKAlSCmNvc3RJdGVtSWQSIQoMd29ya3NwYW'
    'NlX2lkGAIgASgJUgt3b3Jrc3BhY2VJZBIbCgljb3N0X3R5cGUYAyABKAlSCGNvc3RUeXBlEjQK'
    'BmFtb3VudBgEIAEoCzIcLmNyZWF0aXZhbnRhLmNvbW1vbi52MS5Nb25leVIGYW1vdW50EiAKC2'
    'Rlc2NyaXB0aW9uGAUgASgJUgtkZXNjcmlwdGlvbhIsChJyZWxhdGVkX3Njb3BlX3R5cGUYBiAB'
    'KAlSEHJlbGF0ZWRTY29wZVR5cGUSKAoQcmVsYXRlZF9zY29wZV9pZBgHIAEoCVIOcmVsYXRlZF'
    'Njb3BlSWQSRQoMc291cmNlX2NsYXNzGAggASgOMiIuY3JlYXRpdmFudGEuY29tbW9uLnYxLlNv'
    'dXJjZUNsYXNzUgtzb3VyY2VDbGFzcxIfCgtldmlkZW5jZV9pZBgJIAEoCVIKZXZpZGVuY2VJZB'
    'IrChFjb25maWRlbmNlX3JlYXNvbhgKIAEoCVIQY29uZmlkZW5jZVJlYXNvbhJACgpjb3N0X3N0'
    'YXRlGAsgASgOMiEuY3JlYXRpdmFudGEuZmluYW5jZS52MS5Db3N0U3RhdGVSCWNvc3RTdGF0ZR'
    'IlCg5lZmZlY3RpdmVfZGF0ZRgMIAEoCVINZWZmZWN0aXZlRGF0ZRI5CgpjcmVhdGVkX2F0GA0g'
    'ASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIJY3JlYXRlZEF0EjkKCnVwZGF0ZWRfYX'
    'QYDiABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUgl1cGRhdGVkQXQ=');

@$core.Deprecated('Use settlementLineDescriptor instead')
const SettlementLine$json = {
  '1': 'SettlementLine',
  '2': [
    {'1': 'line_id', '3': 1, '4': 1, '5': 9, '10': 'lineId'},
    {'1': 'workspace_id', '3': 2, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'settlement_id', '3': 3, '4': 1, '5': 9, '10': 'settlementId'},
    {'1': 'external_line_id', '3': 4, '4': 1, '5': 9, '10': 'externalLineId'},
    {'1': 'external_order_id', '3': 5, '4': 1, '5': 9, '10': 'externalOrderId'},
    {'1': 'order_id', '3': 6, '4': 1, '5': 9, '10': 'orderId'},
    {
      '1': 'gross_amount',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.Money',
      '10': 'grossAmount'
    },
    {
      '1': 'fee_amount',
      '3': 8,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.Money',
      '10': 'feeAmount'
    },
    {
      '1': 'refund_amount',
      '3': 9,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.Money',
      '10': 'refundAmount'
    },
    {
      '1': 'net_amount',
      '3': 10,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.Money',
      '10': 'netAmount'
    },
    {
      '1': 'matched_amount',
      '3': 11,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.Money',
      '10': 'matchedAmount'
    },
    {'1': 'currency', '3': 12, '4': 1, '5': 9, '10': 'currency'},
    {
      '1': 'reconciliation_state',
      '3': 13,
      '4': 1,
      '5': 14,
      '6': '.creativanta.finance.v1.ReconciliationState',
      '10': 'reconciliationState'
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

/// Descriptor for `SettlementLine`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List settlementLineDescriptor = $convert.base64Decode(
    'Cg5TZXR0bGVtZW50TGluZRIXCgdsaW5lX2lkGAEgASgJUgZsaW5lSWQSIQoMd29ya3NwYWNlX2'
    'lkGAIgASgJUgt3b3Jrc3BhY2VJZBIjCg1zZXR0bGVtZW50X2lkGAMgASgJUgxzZXR0bGVtZW50'
    'SWQSKAoQZXh0ZXJuYWxfbGluZV9pZBgEIAEoCVIOZXh0ZXJuYWxMaW5lSWQSKgoRZXh0ZXJuYW'
    'xfb3JkZXJfaWQYBSABKAlSD2V4dGVybmFsT3JkZXJJZBIZCghvcmRlcl9pZBgGIAEoCVIHb3Jk'
    'ZXJJZBI/Cgxncm9zc19hbW91bnQYByABKAsyHC5jcmVhdGl2YW50YS5jb21tb24udjEuTW9uZX'
    'lSC2dyb3NzQW1vdW50EjsKCmZlZV9hbW91bnQYCCABKAsyHC5jcmVhdGl2YW50YS5jb21tb24u'
    'djEuTW9uZXlSCWZlZUFtb3VudBJBCg1yZWZ1bmRfYW1vdW50GAkgASgLMhwuY3JlYXRpdmFudG'
    'EuY29tbW9uLnYxLk1vbmV5UgxyZWZ1bmRBbW91bnQSOwoKbmV0X2Ftb3VudBgKIAEoCzIcLmNy'
    'ZWF0aXZhbnRhLmNvbW1vbi52MS5Nb25leVIJbmV0QW1vdW50EkMKDm1hdGNoZWRfYW1vdW50GA'
    'sgASgLMhwuY3JlYXRpdmFudGEuY29tbW9uLnYxLk1vbmV5Ug1tYXRjaGVkQW1vdW50EhoKCGN1'
    'cnJlbmN5GAwgASgJUghjdXJyZW5jeRJeChRyZWNvbmNpbGlhdGlvbl9zdGF0ZRgNIAEoDjIrLm'
    'NyZWF0aXZhbnRhLmZpbmFuY2UudjEuUmVjb25jaWxpYXRpb25TdGF0ZVITcmVjb25jaWxpYXRp'
    'b25TdGF0ZRI5CgpjcmVhdGVkX2F0GA4gASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcF'
    'IJY3JlYXRlZEF0');

@$core.Deprecated('Use settlementDescriptor instead')
const Settlement$json = {
  '1': 'Settlement',
  '2': [
    {'1': 'settlement_id', '3': 1, '4': 1, '5': 9, '10': 'settlementId'},
    {'1': 'workspace_id', '3': 2, '4': 1, '5': 9, '10': 'workspaceId'},
    {
      '1': 'source_class',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.creativanta.common.v1.SourceClass',
      '10': 'sourceClass'
    },
    {'1': 'source_platform', '3': 4, '4': 1, '5': 9, '10': 'sourcePlatform'},
    {
      '1': 'external_settlement_id',
      '3': 5,
      '4': 1,
      '5': 9,
      '10': 'externalSettlementId'
    },
    {
      '1': 'connected_account_id',
      '3': 6,
      '4': 1,
      '5': 9,
      '10': 'connectedAccountId'
    },
    {
      '1': 'exchange_rate',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.creativanta.finance.v1.ExchangeRateSnapshot',
      '10': 'exchangeRate'
    },
    {
      '1': 'import_fingerprint',
      '3': 8,
      '4': 1,
      '5': 9,
      '10': 'importFingerprint'
    },
    {
      '1': 'gross_amount',
      '3': 9,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.Money',
      '10': 'grossAmount'
    },
    {
      '1': 'net_amount',
      '3': 10,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.Money',
      '10': 'netAmount'
    },
    {'1': 'fees_json', '3': 11, '4': 1, '5': 9, '10': 'feesJson'},
    {'1': 'deductions_json', '3': 12, '4': 1, '5': 9, '10': 'deductionsJson'},
    {'1': 'currency', '3': 13, '4': 1, '5': 9, '10': 'currency'},
    {
      '1': 'settlement_state',
      '3': 14,
      '4': 1,
      '5': 14,
      '6': '.creativanta.finance.v1.SettlementState',
      '10': 'settlementState'
    },
    {
      '1': 'reconciliation_state',
      '3': 15,
      '4': 1,
      '5': 14,
      '6': '.creativanta.finance.v1.ReconciliationState',
      '10': 'reconciliationState'
    },
    {
      '1': 'related_order_ids',
      '3': 16,
      '4': 3,
      '5': 9,
      '10': 'relatedOrderIds'
    },
    {'1': 'effective_date', '3': 17, '4': 1, '5': 9, '10': 'effectiveDate'},
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
      '1': 'lines',
      '3': 20,
      '4': 3,
      '5': 11,
      '6': '.creativanta.finance.v1.SettlementLine',
      '10': 'lines'
    },
  ],
};

/// Descriptor for `Settlement`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List settlementDescriptor = $convert.base64Decode(
    'CgpTZXR0bGVtZW50EiMKDXNldHRsZW1lbnRfaWQYASABKAlSDHNldHRsZW1lbnRJZBIhCgx3b3'
    'Jrc3BhY2VfaWQYAiABKAlSC3dvcmtzcGFjZUlkEkUKDHNvdXJjZV9jbGFzcxgDIAEoDjIiLmNy'
    'ZWF0aXZhbnRhLmNvbW1vbi52MS5Tb3VyY2VDbGFzc1ILc291cmNlQ2xhc3MSJwoPc291cmNlX3'
    'BsYXRmb3JtGAQgASgJUg5zb3VyY2VQbGF0Zm9ybRI0ChZleHRlcm5hbF9zZXR0bGVtZW50X2lk'
    'GAUgASgJUhRleHRlcm5hbFNldHRsZW1lbnRJZBIwChRjb25uZWN0ZWRfYWNjb3VudF9pZBgGIA'
    'EoCVISY29ubmVjdGVkQWNjb3VudElkElEKDWV4Y2hhbmdlX3JhdGUYByABKAsyLC5jcmVhdGl2'
    'YW50YS5maW5hbmNlLnYxLkV4Y2hhbmdlUmF0ZVNuYXBzaG90UgxleGNoYW5nZVJhdGUSLQoSaW'
    '1wb3J0X2ZpbmdlcnByaW50GAggASgJUhFpbXBvcnRGaW5nZXJwcmludBI/Cgxncm9zc19hbW91'
    'bnQYCSABKAsyHC5jcmVhdGl2YW50YS5jb21tb24udjEuTW9uZXlSC2dyb3NzQW1vdW50EjsKCm'
    '5ldF9hbW91bnQYCiABKAsyHC5jcmVhdGl2YW50YS5jb21tb24udjEuTW9uZXlSCW5ldEFtb3Vu'
    'dBIbCglmZWVzX2pzb24YCyABKAlSCGZlZXNKc29uEicKD2RlZHVjdGlvbnNfanNvbhgMIAEoCV'
    'IOZGVkdWN0aW9uc0pzb24SGgoIY3VycmVuY3kYDSABKAlSCGN1cnJlbmN5ElIKEHNldHRsZW1l'
    'bnRfc3RhdGUYDiABKA4yJy5jcmVhdGl2YW50YS5maW5hbmNlLnYxLlNldHRsZW1lbnRTdGF0ZV'
    'IPc2V0dGxlbWVudFN0YXRlEl4KFHJlY29uY2lsaWF0aW9uX3N0YXRlGA8gASgOMisuY3JlYXRp'
    'dmFudGEuZmluYW5jZS52MS5SZWNvbmNpbGlhdGlvblN0YXRlUhNyZWNvbmNpbGlhdGlvblN0YX'
    'RlEioKEXJlbGF0ZWRfb3JkZXJfaWRzGBAgAygJUg9yZWxhdGVkT3JkZXJJZHMSJQoOZWZmZWN0'
    'aXZlX2RhdGUYESABKAlSDWVmZmVjdGl2ZURhdGUSOQoKY3JlYXRlZF9hdBgSIAEoCzIaLmdvb2'
    'dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSCWNyZWF0ZWRBdBI5Cgp1cGRhdGVkX2F0GBMgASgLMhou'
    'Z29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIJdXBkYXRlZEF0EjwKBWxpbmVzGBQgAygLMiYuY3'
    'JlYXRpdmFudGEuZmluYW5jZS52MS5TZXR0bGVtZW50TGluZVIFbGluZXM=');

@$core.Deprecated('Use profitSnapshotDescriptor instead')
const ProfitSnapshot$json = {
  '1': 'ProfitSnapshot',
  '2': [
    {'1': 'snapshot_id', '3': 1, '4': 1, '5': 9, '10': 'snapshotId'},
    {'1': 'workspace_id', '3': 2, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'scope_type', '3': 3, '4': 1, '5': 9, '10': 'scopeType'},
    {'1': 'scope_id', '3': 4, '4': 1, '5': 9, '10': 'scopeId'},
    {'1': 'period_start', '3': 5, '4': 1, '5': 9, '10': 'periodStart'},
    {'1': 'period_end', '3': 6, '4': 1, '5': 9, '10': 'periodEnd'},
    {
      '1': 'gross_revenue',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.Money',
      '10': 'grossRevenue'
    },
    {
      '1': 'platform_fees',
      '3': 8,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.Money',
      '10': 'platformFees'
    },
    {
      '1': 'shipping_costs',
      '3': 9,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.Money',
      '10': 'shippingCosts'
    },
    {
      '1': 'affiliate_commissions',
      '3': 10,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.Money',
      '10': 'affiliateCommissions'
    },
    {
      '1': 'refund_deductions',
      '3': 11,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.Money',
      '10': 'refundDeductions'
    },
    {
      '1': 'cogs',
      '3': 12,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.Money',
      '10': 'cogs'
    },
    {
      '1': 'ads_spend',
      '3': 13,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.Money',
      '10': 'adsSpend'
    },
    {
      '1': 'ai_credit_costs',
      '3': 14,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.Money',
      '10': 'aiCreditCosts'
    },
    {
      '1': 'seeding_costs',
      '3': 15,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.Money',
      '10': 'seedingCosts'
    },
    {
      '1': 'other_costs',
      '3': 16,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.Money',
      '10': 'otherCosts'
    },
    {
      '1': 'net_profit',
      '3': 17,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.Money',
      '10': 'netProfit'
    },
    {'1': 'margin_pct', '3': 18, '4': 1, '5': 9, '10': 'marginPct'},
    {
      '1': 'source_class_mix_json',
      '3': 19,
      '4': 1,
      '5': 9,
      '10': 'sourceClassMixJson'
    },
    {
      '1': 'confidence',
      '3': 20,
      '4': 1,
      '5': 14,
      '6': '.creativanta.common.v1.ConfidenceBand',
      '10': 'confidence'
    },
    {
      '1': 'freshness_at',
      '3': 21,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'freshnessAt'
    },
    {'1': 'currency', '3': 22, '4': 1, '5': 9, '10': 'currency'},
    {
      '1': 'created_at',
      '3': 23,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'createdAt'
    },
    {'1': 'is_incomplete', '3': 24, '4': 1, '5': 8, '10': 'isIncomplete'},
    {
      '1': 'unknown_required_components_count',
      '3': 25,
      '4': 1,
      '5': 5,
      '10': 'unknownRequiredComponentsCount'
    },
    {
      '1': 'pending_revenue',
      '3': 26,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.Money',
      '10': 'pendingRevenue'
    },
    {
      '1': 'unreconciled_amount',
      '3': 27,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.Money',
      '10': 'unreconciledAmount'
    },
    {
      '1': 'unreconciled_count',
      '3': 28,
      '4': 1,
      '5': 5,
      '10': 'unreconciledCount'
    },
  ],
};

/// Descriptor for `ProfitSnapshot`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List profitSnapshotDescriptor = $convert.base64Decode(
    'Cg5Qcm9maXRTbmFwc2hvdBIfCgtzbmFwc2hvdF9pZBgBIAEoCVIKc25hcHNob3RJZBIhCgx3b3'
    'Jrc3BhY2VfaWQYAiABKAlSC3dvcmtzcGFjZUlkEh0KCnNjb3BlX3R5cGUYAyABKAlSCXNjb3Bl'
    'VHlwZRIZCghzY29wZV9pZBgEIAEoCVIHc2NvcGVJZBIhCgxwZXJpb2Rfc3RhcnQYBSABKAlSC3'
    'BlcmlvZFN0YXJ0Eh0KCnBlcmlvZF9lbmQYBiABKAlSCXBlcmlvZEVuZBJBCg1ncm9zc19yZXZl'
    'bnVlGAcgASgLMhwuY3JlYXRpdmFudGEuY29tbW9uLnYxLk1vbmV5Ugxncm9zc1JldmVudWUSQQ'
    'oNcGxhdGZvcm1fZmVlcxgIIAEoCzIcLmNyZWF0aXZhbnRhLmNvbW1vbi52MS5Nb25leVIMcGxh'
    'dGZvcm1GZWVzEkMKDnNoaXBwaW5nX2Nvc3RzGAkgASgLMhwuY3JlYXRpdmFudGEuY29tbW9uLn'
    'YxLk1vbmV5Ug1zaGlwcGluZ0Nvc3RzElEKFWFmZmlsaWF0ZV9jb21taXNzaW9ucxgKIAEoCzIc'
    'LmNyZWF0aXZhbnRhLmNvbW1vbi52MS5Nb25leVIUYWZmaWxpYXRlQ29tbWlzc2lvbnMSSQoRcm'
    'VmdW5kX2RlZHVjdGlvbnMYCyABKAsyHC5jcmVhdGl2YW50YS5jb21tb24udjEuTW9uZXlSEHJl'
    'ZnVuZERlZHVjdGlvbnMSMAoEY29ncxgMIAEoCzIcLmNyZWF0aXZhbnRhLmNvbW1vbi52MS5Nb2'
    '5leVIEY29ncxI5CglhZHNfc3BlbmQYDSABKAsyHC5jcmVhdGl2YW50YS5jb21tb24udjEuTW9u'
    'ZXlSCGFkc1NwZW5kEkQKD2FpX2NyZWRpdF9jb3N0cxgOIAEoCzIcLmNyZWF0aXZhbnRhLmNvbW'
    '1vbi52MS5Nb25leVINYWlDcmVkaXRDb3N0cxJBCg1zZWVkaW5nX2Nvc3RzGA8gASgLMhwuY3Jl'
    'YXRpdmFudGEuY29tbW9uLnYxLk1vbmV5UgxzZWVkaW5nQ29zdHMSPQoLb3RoZXJfY29zdHMYEC'
    'ABKAsyHC5jcmVhdGl2YW50YS5jb21tb24udjEuTW9uZXlSCm90aGVyQ29zdHMSOwoKbmV0X3By'
    'b2ZpdBgRIAEoCzIcLmNyZWF0aXZhbnRhLmNvbW1vbi52MS5Nb25leVIJbmV0UHJvZml0Eh0KCm'
    '1hcmdpbl9wY3QYEiABKAlSCW1hcmdpblBjdBIxChVzb3VyY2VfY2xhc3NfbWl4X2pzb24YEyAB'
    'KAlSEnNvdXJjZUNsYXNzTWl4SnNvbhJFCgpjb25maWRlbmNlGBQgASgOMiUuY3JlYXRpdmFudG'
    'EuY29tbW9uLnYxLkNvbmZpZGVuY2VCYW5kUgpjb25maWRlbmNlEj0KDGZyZXNobmVzc19hdBgV'
    'IAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSC2ZyZXNobmVzc0F0EhoKCGN1cnJlbm'
    'N5GBYgASgJUghjdXJyZW5jeRI5CgpjcmVhdGVkX2F0GBcgASgLMhouZ29vZ2xlLnByb3RvYnVm'
    'LlRpbWVzdGFtcFIJY3JlYXRlZEF0EiMKDWlzX2luY29tcGxldGUYGCABKAhSDGlzSW5jb21wbG'
    'V0ZRJJCiF1bmtub3duX3JlcXVpcmVkX2NvbXBvbmVudHNfY291bnQYGSABKAVSHnVua25vd25S'
    'ZXF1aXJlZENvbXBvbmVudHNDb3VudBJFCg9wZW5kaW5nX3JldmVudWUYGiABKAsyHC5jcmVhdG'
    'l2YW50YS5jb21tb24udjEuTW9uZXlSDnBlbmRpbmdSZXZlbnVlEk0KE3VucmVjb25jaWxlZF9h'
    'bW91bnQYGyABKAsyHC5jcmVhdGl2YW50YS5jb21tb24udjEuTW9uZXlSEnVucmVjb25jaWxlZE'
    'Ftb3VudBItChJ1bnJlY29uY2lsZWRfY291bnQYHCABKAVSEXVucmVjb25jaWxlZENvdW50');

@$core.Deprecated('Use profitAnomalyDescriptor instead')
const ProfitAnomaly$json = {
  '1': 'ProfitAnomaly',
  '2': [
    {'1': 'anomaly_id', '3': 1, '4': 1, '5': 9, '10': 'anomalyId'},
    {'1': 'workspace_id', '3': 2, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'anomaly_type', '3': 3, '4': 1, '5': 9, '10': 'anomalyType'},
    {'1': 'severity', '3': 4, '4': 1, '5': 9, '10': 'severity'},
    {'1': 'description', '3': 5, '4': 1, '5': 9, '10': 'description'},
    {
      '1': 'expected_amount',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.Money',
      '10': 'expectedAmount'
    },
    {
      '1': 'actual_amount',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.Money',
      '10': 'actualAmount'
    },
    {
      '1': 'detected_at',
      '3': 8,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'detectedAt'
    },
  ],
};

/// Descriptor for `ProfitAnomaly`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List profitAnomalyDescriptor = $convert.base64Decode(
    'Cg1Qcm9maXRBbm9tYWx5Eh0KCmFub21hbHlfaWQYASABKAlSCWFub21hbHlJZBIhCgx3b3Jrc3'
    'BhY2VfaWQYAiABKAlSC3dvcmtzcGFjZUlkEiEKDGFub21hbHlfdHlwZRgDIAEoCVILYW5vbWFs'
    'eVR5cGUSGgoIc2V2ZXJpdHkYBCABKAlSCHNldmVyaXR5EiAKC2Rlc2NyaXB0aW9uGAUgASgJUg'
    'tkZXNjcmlwdGlvbhJFCg9leHBlY3RlZF9hbW91bnQYBiABKAsyHC5jcmVhdGl2YW50YS5jb21t'
    'b24udjEuTW9uZXlSDmV4cGVjdGVkQW1vdW50EkEKDWFjdHVhbF9hbW91bnQYByABKAsyHC5jcm'
    'VhdGl2YW50YS5jb21tb24udjEuTW9uZXlSDGFjdHVhbEFtb3VudBI7CgtkZXRlY3RlZF9hdBgI'
    'IAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSCmRldGVjdGVkQXQ=');

@$core.Deprecated('Use profitServiceGetSummaryRequestDescriptor instead')
const ProfitServiceGetSummaryRequest$json = {
  '1': 'ProfitServiceGetSummaryRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'scope_type', '3': 2, '4': 1, '5': 9, '10': 'scopeType'},
    {'1': 'scope_id', '3': 3, '4': 1, '5': 9, '10': 'scopeId'},
    {'1': 'period_start', '3': 4, '4': 1, '5': 9, '10': 'periodStart'},
    {'1': 'period_end', '3': 5, '4': 1, '5': 9, '10': 'periodEnd'},
  ],
};

/// Descriptor for `ProfitServiceGetSummaryRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List profitServiceGetSummaryRequestDescriptor =
    $convert.base64Decode(
        'Ch5Qcm9maXRTZXJ2aWNlR2V0U3VtbWFyeVJlcXVlc3QSIQoMd29ya3NwYWNlX2lkGAEgASgJUg'
        't3b3Jrc3BhY2VJZBIdCgpzY29wZV90eXBlGAIgASgJUglzY29wZVR5cGUSGQoIc2NvcGVfaWQY'
        'AyABKAlSB3Njb3BlSWQSIQoMcGVyaW9kX3N0YXJ0GAQgASgJUgtwZXJpb2RTdGFydBIdCgpwZX'
        'Jpb2RfZW5kGAUgASgJUglwZXJpb2RFbmQ=');

@$core.Deprecated('Use profitServiceGetSummaryResponseDescriptor instead')
const ProfitServiceGetSummaryResponse$json = {
  '1': 'ProfitServiceGetSummaryResponse',
  '2': [
    {
      '1': 'snapshot',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.finance.v1.ProfitSnapshot',
      '10': 'snapshot'
    },
    {
      '1': 'component_breakdown',
      '3': 2,
      '4': 3,
      '5': 11,
      '6':
          '.creativanta.finance.v1.ProfitServiceGetSummaryResponse.ComponentBreakdownEntry',
      '10': 'componentBreakdown'
    },
    {
      '1': 'source_class_percentages',
      '3': 3,
      '4': 3,
      '5': 11,
      '6':
          '.creativanta.finance.v1.ProfitServiceGetSummaryResponse.SourceClassPercentagesEntry',
      '10': 'sourceClassPercentages'
    },
  ],
  '3': [
    ProfitServiceGetSummaryResponse_ComponentBreakdownEntry$json,
    ProfitServiceGetSummaryResponse_SourceClassPercentagesEntry$json
  ],
};

@$core.Deprecated('Use profitServiceGetSummaryResponseDescriptor instead')
const ProfitServiceGetSummaryResponse_ComponentBreakdownEntry$json = {
  '1': 'ComponentBreakdownEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {'1': 'value', '3': 2, '4': 1, '5': 9, '10': 'value'},
  ],
  '7': {'7': true},
};

@$core.Deprecated('Use profitServiceGetSummaryResponseDescriptor instead')
const ProfitServiceGetSummaryResponse_SourceClassPercentagesEntry$json = {
  '1': 'SourceClassPercentagesEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {'1': 'value', '3': 2, '4': 1, '5': 1, '10': 'value'},
  ],
  '7': {'7': true},
};

/// Descriptor for `ProfitServiceGetSummaryResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List profitServiceGetSummaryResponseDescriptor = $convert.base64Decode(
    'Ch9Qcm9maXRTZXJ2aWNlR2V0U3VtbWFyeVJlc3BvbnNlEkIKCHNuYXBzaG90GAEgASgLMiYuY3'
    'JlYXRpdmFudGEuZmluYW5jZS52MS5Qcm9maXRTbmFwc2hvdFIIc25hcHNob3QSgAEKE2NvbXBv'
    'bmVudF9icmVha2Rvd24YAiADKAsyTy5jcmVhdGl2YW50YS5maW5hbmNlLnYxLlByb2ZpdFNlcn'
    'ZpY2VHZXRTdW1tYXJ5UmVzcG9uc2UuQ29tcG9uZW50QnJlYWtkb3duRW50cnlSEmNvbXBvbmVu'
    'dEJyZWFrZG93bhKNAQoYc291cmNlX2NsYXNzX3BlcmNlbnRhZ2VzGAMgAygLMlMuY3JlYXRpdm'
    'FudGEuZmluYW5jZS52MS5Qcm9maXRTZXJ2aWNlR2V0U3VtbWFyeVJlc3BvbnNlLlNvdXJjZUNs'
    'YXNzUGVyY2VudGFnZXNFbnRyeVIWc291cmNlQ2xhc3NQZXJjZW50YWdlcxpFChdDb21wb25lbn'
    'RCcmVha2Rvd25FbnRyeRIQCgNrZXkYASABKAlSA2tleRIUCgV2YWx1ZRgCIAEoCVIFdmFsdWU6'
    'AjgBGkkKG1NvdXJjZUNsYXNzUGVyY2VudGFnZXNFbnRyeRIQCgNrZXkYASABKAlSA2tleRIUCg'
    'V2YWx1ZRgCIAEoAVIFdmFsdWU6AjgB');

@$core.Deprecated('Use profitServiceDrillDownRequestDescriptor instead')
const ProfitServiceDrillDownRequest$json = {
  '1': 'ProfitServiceDrillDownRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'scope_type', '3': 2, '4': 1, '5': 9, '10': 'scopeType'},
    {'1': 'scope_id', '3': 3, '4': 1, '5': 9, '10': 'scopeId'},
    {'1': 'period_start', '3': 4, '4': 1, '5': 9, '10': 'periodStart'},
    {'1': 'period_end', '3': 5, '4': 1, '5': 9, '10': 'periodEnd'},
    {'1': 'drilldown_by', '3': 6, '4': 1, '5': 9, '10': 'drilldownBy'},
  ],
};

/// Descriptor for `ProfitServiceDrillDownRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List profitServiceDrillDownRequestDescriptor = $convert.base64Decode(
    'Ch1Qcm9maXRTZXJ2aWNlRHJpbGxEb3duUmVxdWVzdBIhCgx3b3Jrc3BhY2VfaWQYASABKAlSC3'
    'dvcmtzcGFjZUlkEh0KCnNjb3BlX3R5cGUYAiABKAlSCXNjb3BlVHlwZRIZCghzY29wZV9pZBgD'
    'IAEoCVIHc2NvcGVJZBIhCgxwZXJpb2Rfc3RhcnQYBCABKAlSC3BlcmlvZFN0YXJ0Eh0KCnBlcm'
    'lvZF9lbmQYBSABKAlSCXBlcmlvZEVuZBIhCgxkcmlsbGRvd25fYnkYBiABKAlSC2RyaWxsZG93'
    'bkJ5');

@$core.Deprecated('Use profitDrillDownItemDescriptor instead')
const ProfitDrillDownItem$json = {
  '1': 'ProfitDrillDownItem',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {'1': 'label', '3': 2, '4': 1, '5': 9, '10': 'label'},
    {
      '1': 'revenue',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.Money',
      '10': 'revenue'
    },
    {
      '1': 'costs',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.Money',
      '10': 'costs'
    },
    {
      '1': 'net_profit',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.Money',
      '10': 'netProfit'
    },
    {
      '1': 'confidence',
      '3': 6,
      '4': 1,
      '5': 14,
      '6': '.creativanta.common.v1.ConfidenceBand',
      '10': 'confidence'
    },
    {
      '1': 'primary_source_class',
      '3': 7,
      '4': 1,
      '5': 14,
      '6': '.creativanta.common.v1.SourceClass',
      '10': 'primarySourceClass'
    },
  ],
};

/// Descriptor for `ProfitDrillDownItem`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List profitDrillDownItemDescriptor = $convert.base64Decode(
    'ChNQcm9maXREcmlsbERvd25JdGVtEhAKA2tleRgBIAEoCVIDa2V5EhQKBWxhYmVsGAIgASgJUg'
    'VsYWJlbBI2CgdyZXZlbnVlGAMgASgLMhwuY3JlYXRpdmFudGEuY29tbW9uLnYxLk1vbmV5Ugdy'
    'ZXZlbnVlEjIKBWNvc3RzGAQgASgLMhwuY3JlYXRpdmFudGEuY29tbW9uLnYxLk1vbmV5UgVjb3'
    'N0cxI7CgpuZXRfcHJvZml0GAUgASgLMhwuY3JlYXRpdmFudGEuY29tbW9uLnYxLk1vbmV5Uglu'
    'ZXRQcm9maXQSRQoKY29uZmlkZW5jZRgGIAEoDjIlLmNyZWF0aXZhbnRhLmNvbW1vbi52MS5Db2'
    '5maWRlbmNlQmFuZFIKY29uZmlkZW5jZRJUChRwcmltYXJ5X3NvdXJjZV9jbGFzcxgHIAEoDjIi'
    'LmNyZWF0aXZhbnRhLmNvbW1vbi52MS5Tb3VyY2VDbGFzc1IScHJpbWFyeVNvdXJjZUNsYXNz');

@$core.Deprecated('Use profitServiceDrillDownResponseDescriptor instead')
const ProfitServiceDrillDownResponse$json = {
  '1': 'ProfitServiceDrillDownResponse',
  '2': [
    {
      '1': 'items',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.creativanta.finance.v1.ProfitDrillDownItem',
      '10': 'items'
    },
    {'1': 'currency', '3': 2, '4': 1, '5': 9, '10': 'currency'},
  ],
};

/// Descriptor for `ProfitServiceDrillDownResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List profitServiceDrillDownResponseDescriptor =
    $convert.base64Decode(
        'Ch5Qcm9maXRTZXJ2aWNlRHJpbGxEb3duUmVzcG9uc2USQQoFaXRlbXMYASADKAsyKy5jcmVhdG'
        'l2YW50YS5maW5hbmNlLnYxLlByb2ZpdERyaWxsRG93bkl0ZW1SBWl0ZW1zEhoKCGN1cnJlbmN5'
        'GAIgASgJUghjdXJyZW5jeQ==');

@$core.Deprecated('Use profitServiceGetAnomaliesRequestDescriptor instead')
const ProfitServiceGetAnomaliesRequest$json = {
  '1': 'ProfitServiceGetAnomaliesRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'period_start', '3': 2, '4': 1, '5': 9, '10': 'periodStart'},
    {'1': 'period_end', '3': 3, '4': 1, '5': 9, '10': 'periodEnd'},
  ],
};

/// Descriptor for `ProfitServiceGetAnomaliesRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List profitServiceGetAnomaliesRequestDescriptor =
    $convert.base64Decode(
        'CiBQcm9maXRTZXJ2aWNlR2V0QW5vbWFsaWVzUmVxdWVzdBIhCgx3b3Jrc3BhY2VfaWQYASABKA'
        'lSC3dvcmtzcGFjZUlkEiEKDHBlcmlvZF9zdGFydBgCIAEoCVILcGVyaW9kU3RhcnQSHQoKcGVy'
        'aW9kX2VuZBgDIAEoCVIJcGVyaW9kRW5k');

@$core.Deprecated('Use profitServiceGetAnomaliesResponseDescriptor instead')
const ProfitServiceGetAnomaliesResponse$json = {
  '1': 'ProfitServiceGetAnomaliesResponse',
  '2': [
    {
      '1': 'anomalies',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.creativanta.finance.v1.ProfitAnomaly',
      '10': 'anomalies'
    },
  ],
};

/// Descriptor for `ProfitServiceGetAnomaliesResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List profitServiceGetAnomaliesResponseDescriptor =
    $convert.base64Decode(
        'CiFQcm9maXRTZXJ2aWNlR2V0QW5vbWFsaWVzUmVzcG9uc2USQwoJYW5vbWFsaWVzGAEgAygLMi'
        'UuY3JlYXRpdmFudGEuZmluYW5jZS52MS5Qcm9maXRBbm9tYWx5Uglhbm9tYWxpZXM=');

@$core.Deprecated('Use profitServiceGetSnapshotRequestDescriptor instead')
const ProfitServiceGetSnapshotRequest$json = {
  '1': 'ProfitServiceGetSnapshotRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'snapshot_id', '3': 2, '4': 1, '5': 9, '10': 'snapshotId'},
    {'1': 'scope_type', '3': 3, '4': 1, '5': 9, '10': 'scopeType'},
    {'1': 'scope_id', '3': 4, '4': 1, '5': 9, '10': 'scopeId'},
    {'1': 'period_start', '3': 5, '4': 1, '5': 9, '10': 'periodStart'},
    {'1': 'period_end', '3': 6, '4': 1, '5': 9, '10': 'periodEnd'},
  ],
};

/// Descriptor for `ProfitServiceGetSnapshotRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List profitServiceGetSnapshotRequestDescriptor = $convert.base64Decode(
    'Ch9Qcm9maXRTZXJ2aWNlR2V0U25hcHNob3RSZXF1ZXN0EiEKDHdvcmtzcGFjZV9pZBgBIAEoCV'
    'ILd29ya3NwYWNlSWQSHwoLc25hcHNob3RfaWQYAiABKAlSCnNuYXBzaG90SWQSHQoKc2NvcGVf'
    'dHlwZRgDIAEoCVIJc2NvcGVUeXBlEhkKCHNjb3BlX2lkGAQgASgJUgdzY29wZUlkEiEKDHBlcm'
    'lvZF9zdGFydBgFIAEoCVILcGVyaW9kU3RhcnQSHQoKcGVyaW9kX2VuZBgGIAEoCVIJcGVyaW9k'
    'RW5k');

@$core.Deprecated('Use profitServiceGetSnapshotResponseDescriptor instead')
const ProfitServiceGetSnapshotResponse$json = {
  '1': 'ProfitServiceGetSnapshotResponse',
  '2': [
    {
      '1': 'snapshot',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.finance.v1.ProfitSnapshot',
      '10': 'snapshot'
    },
  ],
};

/// Descriptor for `ProfitServiceGetSnapshotResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List profitServiceGetSnapshotResponseDescriptor =
    $convert.base64Decode(
        'CiBQcm9maXRTZXJ2aWNlR2V0U25hcHNob3RSZXNwb25zZRJCCghzbmFwc2hvdBgBIAEoCzImLm'
        'NyZWF0aXZhbnRhLmZpbmFuY2UudjEuUHJvZml0U25hcHNob3RSCHNuYXBzaG90');

@$core.Deprecated('Use profitServiceRefreshSnapshotRequestDescriptor instead')
const ProfitServiceRefreshSnapshotRequest$json = {
  '1': 'ProfitServiceRefreshSnapshotRequest',
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
    {'1': 'scope_type', '3': 3, '4': 1, '5': 9, '10': 'scopeType'},
    {'1': 'scope_id', '3': 4, '4': 1, '5': 9, '10': 'scopeId'},
    {'1': 'period_start', '3': 5, '4': 1, '5': 9, '10': 'periodStart'},
    {'1': 'period_end', '3': 6, '4': 1, '5': 9, '10': 'periodEnd'},
  ],
};

/// Descriptor for `ProfitServiceRefreshSnapshotRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List profitServiceRefreshSnapshotRequestDescriptor =
    $convert.base64Decode(
        'CiNQcm9maXRTZXJ2aWNlUmVmcmVzaFNuYXBzaG90UmVxdWVzdBI/Cgdjb250ZXh0GAEgASgLMi'
        'UuY3JlYXRpdmFudGEuY29tbW9uLnYxLkNvbW1hbmRDb250ZXh0Ugdjb250ZXh0EiEKDHdvcmtz'
        'cGFjZV9pZBgCIAEoCVILd29ya3NwYWNlSWQSHQoKc2NvcGVfdHlwZRgDIAEoCVIJc2NvcGVUeX'
        'BlEhkKCHNjb3BlX2lkGAQgASgJUgdzY29wZUlkEiEKDHBlcmlvZF9zdGFydBgFIAEoCVILcGVy'
        'aW9kU3RhcnQSHQoKcGVyaW9kX2VuZBgGIAEoCVIJcGVyaW9kRW5k');

@$core.Deprecated('Use profitServiceRefreshSnapshotResponseDescriptor instead')
const ProfitServiceRefreshSnapshotResponse$json = {
  '1': 'ProfitServiceRefreshSnapshotResponse',
  '2': [
    {
      '1': 'snapshot',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.finance.v1.ProfitSnapshot',
      '10': 'snapshot'
    },
  ],
};

/// Descriptor for `ProfitServiceRefreshSnapshotResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List profitServiceRefreshSnapshotResponseDescriptor =
    $convert.base64Decode(
        'CiRQcm9maXRTZXJ2aWNlUmVmcmVzaFNuYXBzaG90UmVzcG9uc2USQgoIc25hcHNob3QYASABKA'
        'syJi5jcmVhdGl2YW50YS5maW5hbmNlLnYxLlByb2ZpdFNuYXBzaG90UghzbmFwc2hvdA==');

@$core.Deprecated('Use settlementLineInputDescriptor instead')
const SettlementLineInput$json = {
  '1': 'SettlementLineInput',
  '2': [
    {'1': 'external_line_id', '3': 1, '4': 1, '5': 9, '10': 'externalLineId'},
    {'1': 'external_order_id', '3': 2, '4': 1, '5': 9, '10': 'externalOrderId'},
    {
      '1': 'gross_amount',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.Money',
      '10': 'grossAmount'
    },
    {
      '1': 'fee_amount',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.Money',
      '10': 'feeAmount'
    },
    {
      '1': 'refund_amount',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.Money',
      '10': 'refundAmount'
    },
    {
      '1': 'net_amount',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.Money',
      '10': 'netAmount'
    },
  ],
};

/// Descriptor for `SettlementLineInput`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List settlementLineInputDescriptor = $convert.base64Decode(
    'ChNTZXR0bGVtZW50TGluZUlucHV0EigKEGV4dGVybmFsX2xpbmVfaWQYASABKAlSDmV4dGVybm'
    'FsTGluZUlkEioKEWV4dGVybmFsX29yZGVyX2lkGAIgASgJUg9leHRlcm5hbE9yZGVySWQSPwoM'
    'Z3Jvc3NfYW1vdW50GAMgASgLMhwuY3JlYXRpdmFudGEuY29tbW9uLnYxLk1vbmV5Ugtncm9zc0'
    'Ftb3VudBI7CgpmZWVfYW1vdW50GAQgASgLMhwuY3JlYXRpdmFudGEuY29tbW9uLnYxLk1vbmV5'
    'UglmZWVBbW91bnQSQQoNcmVmdW5kX2Ftb3VudBgFIAEoCzIcLmNyZWF0aXZhbnRhLmNvbW1vbi'
    '52MS5Nb25leVIMcmVmdW5kQW1vdW50EjsKCm5ldF9hbW91bnQYBiABKAsyHC5jcmVhdGl2YW50'
    'YS5jb21tb24udjEuTW9uZXlSCW5ldEFtb3VudA==');

@$core.Deprecated('Use settlementServiceImportRequestDescriptor instead')
const SettlementServiceImportRequest$json = {
  '1': 'SettlementServiceImportRequest',
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
    {'1': 'source_platform', '3': 3, '4': 1, '5': 9, '10': 'sourcePlatform'},
    {
      '1': 'external_settlement_id',
      '3': 4,
      '4': 1,
      '5': 9,
      '10': 'externalSettlementId'
    },
    {
      '1': 'connected_account_id',
      '3': 5,
      '4': 1,
      '5': 9,
      '10': 'connectedAccountId'
    },
    {
      '1': 'gross_amount',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.Money',
      '10': 'grossAmount'
    },
    {
      '1': 'net_amount',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.Money',
      '10': 'netAmount'
    },
    {'1': 'currency', '3': 8, '4': 1, '5': 9, '10': 'currency'},
    {'1': 'effective_date', '3': 9, '4': 1, '5': 9, '10': 'effectiveDate'},
    {
      '1': 'import_fingerprint',
      '3': 10,
      '4': 1,
      '5': 9,
      '10': 'importFingerprint'
    },
    {
      '1': 'lines',
      '3': 11,
      '4': 3,
      '5': 11,
      '6': '.creativanta.finance.v1.SettlementLineInput',
      '10': 'lines'
    },
    {
      '1': 'exchange_rate',
      '3': 12,
      '4': 1,
      '5': 11,
      '6': '.creativanta.finance.v1.ExchangeRateSnapshot',
      '10': 'exchangeRate'
    },
  ],
};

/// Descriptor for `SettlementServiceImportRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List settlementServiceImportRequestDescriptor = $convert.base64Decode(
    'Ch5TZXR0bGVtZW50U2VydmljZUltcG9ydFJlcXVlc3QSPwoHY29udGV4dBgBIAEoCzIlLmNyZW'
    'F0aXZhbnRhLmNvbW1vbi52MS5Db21tYW5kQ29udGV4dFIHY29udGV4dBIhCgx3b3Jrc3BhY2Vf'
    'aWQYAiABKAlSC3dvcmtzcGFjZUlkEicKD3NvdXJjZV9wbGF0Zm9ybRgDIAEoCVIOc291cmNlUG'
    'xhdGZvcm0SNAoWZXh0ZXJuYWxfc2V0dGxlbWVudF9pZBgEIAEoCVIUZXh0ZXJuYWxTZXR0bGVt'
    'ZW50SWQSMAoUY29ubmVjdGVkX2FjY291bnRfaWQYBSABKAlSEmNvbm5lY3RlZEFjY291bnRJZB'
    'I/Cgxncm9zc19hbW91bnQYBiABKAsyHC5jcmVhdGl2YW50YS5jb21tb24udjEuTW9uZXlSC2dy'
    'b3NzQW1vdW50EjsKCm5ldF9hbW91bnQYByABKAsyHC5jcmVhdGl2YW50YS5jb21tb24udjEuTW'
    '9uZXlSCW5ldEFtb3VudBIaCghjdXJyZW5jeRgIIAEoCVIIY3VycmVuY3kSJQoOZWZmZWN0aXZl'
    'X2RhdGUYCSABKAlSDWVmZmVjdGl2ZURhdGUSLQoSaW1wb3J0X2ZpbmdlcnByaW50GAogASgJUh'
    'FpbXBvcnRGaW5nZXJwcmludBJBCgVsaW5lcxgLIAMoCzIrLmNyZWF0aXZhbnRhLmZpbmFuY2Uu'
    'djEuU2V0dGxlbWVudExpbmVJbnB1dFIFbGluZXMSUQoNZXhjaGFuZ2VfcmF0ZRgMIAEoCzIsLm'
    'NyZWF0aXZhbnRhLmZpbmFuY2UudjEuRXhjaGFuZ2VSYXRlU25hcHNob3RSDGV4Y2hhbmdlUmF0'
    'ZQ==');

@$core.Deprecated('Use settlementServiceImportResponseDescriptor instead')
const SettlementServiceImportResponse$json = {
  '1': 'SettlementServiceImportResponse',
  '2': [
    {
      '1': 'settlement',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.finance.v1.Settlement',
      '10': 'settlement'
    },
    {
      '1': 'imported_lines_count',
      '3': 2,
      '4': 1,
      '5': 5,
      '10': 'importedLinesCount'
    },
    {'1': 'already_existed', '3': 3, '4': 1, '5': 8, '10': 'alreadyExisted'},
  ],
};

/// Descriptor for `SettlementServiceImportResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List settlementServiceImportResponseDescriptor =
    $convert.base64Decode(
        'Ch9TZXR0bGVtZW50U2VydmljZUltcG9ydFJlc3BvbnNlEkIKCnNldHRsZW1lbnQYASABKAsyIi'
        '5jcmVhdGl2YW50YS5maW5hbmNlLnYxLlNldHRsZW1lbnRSCnNldHRsZW1lbnQSMAoUaW1wb3J0'
        'ZWRfbGluZXNfY291bnQYAiABKAVSEmltcG9ydGVkTGluZXNDb3VudBInCg9hbHJlYWR5X2V4aX'
        'N0ZWQYAyABKAhSDmFscmVhZHlFeGlzdGVk');

@$core.Deprecated('Use settlementServiceListRequestDescriptor instead')
const SettlementServiceListRequest$json = {
  '1': 'SettlementServiceListRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {
      '1': 'pagination',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.Pagination',
      '10': 'pagination'
    },
    {'1': 'source_platform', '3': 3, '4': 1, '5': 9, '10': 'sourcePlatform'},
    {
      '1': 'settlement_state',
      '3': 4,
      '4': 1,
      '5': 14,
      '6': '.creativanta.finance.v1.SettlementState',
      '10': 'settlementState'
    },
    {
      '1': 'reconciliation_state',
      '3': 5,
      '4': 1,
      '5': 14,
      '6': '.creativanta.finance.v1.ReconciliationState',
      '10': 'reconciliationState'
    },
  ],
};

/// Descriptor for `SettlementServiceListRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List settlementServiceListRequestDescriptor = $convert.base64Decode(
    'ChxTZXR0bGVtZW50U2VydmljZUxpc3RSZXF1ZXN0EiEKDHdvcmtzcGFjZV9pZBgBIAEoCVILd2'
    '9ya3NwYWNlSWQSQQoKcGFnaW5hdGlvbhgCIAEoCzIhLmNyZWF0aXZhbnRhLmNvbW1vbi52MS5Q'
    'YWdpbmF0aW9uUgpwYWdpbmF0aW9uEicKD3NvdXJjZV9wbGF0Zm9ybRgDIAEoCVIOc291cmNlUG'
    'xhdGZvcm0SUgoQc2V0dGxlbWVudF9zdGF0ZRgEIAEoDjInLmNyZWF0aXZhbnRhLmZpbmFuY2Uu'
    'djEuU2V0dGxlbWVudFN0YXRlUg9zZXR0bGVtZW50U3RhdGUSXgoUcmVjb25jaWxpYXRpb25fc3'
    'RhdGUYBSABKA4yKy5jcmVhdGl2YW50YS5maW5hbmNlLnYxLlJlY29uY2lsaWF0aW9uU3RhdGVS'
    'E3JlY29uY2lsaWF0aW9uU3RhdGU=');

@$core.Deprecated('Use settlementServiceListResponseDescriptor instead')
const SettlementServiceListResponse$json = {
  '1': 'SettlementServiceListResponse',
  '2': [
    {
      '1': 'settlements',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.creativanta.finance.v1.Settlement',
      '10': 'settlements'
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

/// Descriptor for `SettlementServiceListResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List settlementServiceListResponseDescriptor = $convert.base64Decode(
    'Ch1TZXR0bGVtZW50U2VydmljZUxpc3RSZXNwb25zZRJECgtzZXR0bGVtZW50cxgBIAMoCzIiLm'
    'NyZWF0aXZhbnRhLmZpbmFuY2UudjEuU2V0dGxlbWVudFILc2V0dGxlbWVudHMSSAoKcGFnaW5h'
    'dGlvbhgCIAEoCzIoLmNyZWF0aXZhbnRhLmNvbW1vbi52MS5QYWdpbmF0ZWRSZXNwb25zZVIKcG'
    'FnaW5hdGlvbg==');

@$core.Deprecated('Use settlementServiceGetRequestDescriptor instead')
const SettlementServiceGetRequest$json = {
  '1': 'SettlementServiceGetRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'settlement_id', '3': 2, '4': 1, '5': 9, '10': 'settlementId'},
  ],
};

/// Descriptor for `SettlementServiceGetRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List settlementServiceGetRequestDescriptor =
    $convert.base64Decode(
        'ChtTZXR0bGVtZW50U2VydmljZUdldFJlcXVlc3QSIQoMd29ya3NwYWNlX2lkGAEgASgJUgt3b3'
        'Jrc3BhY2VJZBIjCg1zZXR0bGVtZW50X2lkGAIgASgJUgxzZXR0bGVtZW50SWQ=');

@$core.Deprecated('Use settlementServiceGetResponseDescriptor instead')
const SettlementServiceGetResponse$json = {
  '1': 'SettlementServiceGetResponse',
  '2': [
    {
      '1': 'settlement',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.finance.v1.Settlement',
      '10': 'settlement'
    },
  ],
};

/// Descriptor for `SettlementServiceGetResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List settlementServiceGetResponseDescriptor =
    $convert.base64Decode(
        'ChxTZXR0bGVtZW50U2VydmljZUdldFJlc3BvbnNlEkIKCnNldHRsZW1lbnQYASABKAsyIi5jcm'
        'VhdGl2YW50YS5maW5hbmNlLnYxLlNldHRsZW1lbnRSCnNldHRsZW1lbnQ=');

@$core.Deprecated('Use costServiceCreateRequestDescriptor instead')
const CostServiceCreateRequest$json = {
  '1': 'CostServiceCreateRequest',
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
    {'1': 'cost_type', '3': 3, '4': 1, '5': 9, '10': 'costType'},
    {
      '1': 'amount',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.Money',
      '10': 'amount'
    },
    {'1': 'description', '3': 5, '4': 1, '5': 9, '10': 'description'},
    {
      '1': 'related_scope_type',
      '3': 6,
      '4': 1,
      '5': 9,
      '10': 'relatedScopeType'
    },
    {'1': 'related_scope_id', '3': 7, '4': 1, '5': 9, '10': 'relatedScopeId'},
    {
      '1': 'source_class',
      '3': 8,
      '4': 1,
      '5': 14,
      '6': '.creativanta.common.v1.SourceClass',
      '10': 'sourceClass'
    },
    {'1': 'evidence_id', '3': 9, '4': 1, '5': 9, '10': 'evidenceId'},
    {
      '1': 'confidence_reason',
      '3': 10,
      '4': 1,
      '5': 9,
      '10': 'confidenceReason'
    },
    {'1': 'effective_date', '3': 11, '4': 1, '5': 9, '10': 'effectiveDate'},
  ],
};

/// Descriptor for `CostServiceCreateRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List costServiceCreateRequestDescriptor = $convert.base64Decode(
    'ChhDb3N0U2VydmljZUNyZWF0ZVJlcXVlc3QSPwoHY29udGV4dBgBIAEoCzIlLmNyZWF0aXZhbn'
    'RhLmNvbW1vbi52MS5Db21tYW5kQ29udGV4dFIHY29udGV4dBIhCgx3b3Jrc3BhY2VfaWQYAiAB'
    'KAlSC3dvcmtzcGFjZUlkEhsKCWNvc3RfdHlwZRgDIAEoCVIIY29zdFR5cGUSNAoGYW1vdW50GA'
    'QgASgLMhwuY3JlYXRpdmFudGEuY29tbW9uLnYxLk1vbmV5UgZhbW91bnQSIAoLZGVzY3JpcHRp'
    'b24YBSABKAlSC2Rlc2NyaXB0aW9uEiwKEnJlbGF0ZWRfc2NvcGVfdHlwZRgGIAEoCVIQcmVsYX'
    'RlZFNjb3BlVHlwZRIoChByZWxhdGVkX3Njb3BlX2lkGAcgASgJUg5yZWxhdGVkU2NvcGVJZBJF'
    'Cgxzb3VyY2VfY2xhc3MYCCABKA4yIi5jcmVhdGl2YW50YS5jb21tb24udjEuU291cmNlQ2xhc3'
    'NSC3NvdXJjZUNsYXNzEh8KC2V2aWRlbmNlX2lkGAkgASgJUgpldmlkZW5jZUlkEisKEWNvbmZp'
    'ZGVuY2VfcmVhc29uGAogASgJUhBjb25maWRlbmNlUmVhc29uEiUKDmVmZmVjdGl2ZV9kYXRlGA'
    'sgASgJUg1lZmZlY3RpdmVEYXRl');

@$core.Deprecated('Use costServiceCreateResponseDescriptor instead')
const CostServiceCreateResponse$json = {
  '1': 'CostServiceCreateResponse',
  '2': [
    {
      '1': 'cost_item',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.finance.v1.CostItem',
      '10': 'costItem'
    },
  ],
};

/// Descriptor for `CostServiceCreateResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List costServiceCreateResponseDescriptor =
    $convert.base64Decode(
        'ChlDb3N0U2VydmljZUNyZWF0ZVJlc3BvbnNlEj0KCWNvc3RfaXRlbRgBIAEoCzIgLmNyZWF0aX'
        'ZhbnRhLmZpbmFuY2UudjEuQ29zdEl0ZW1SCGNvc3RJdGVt');

@$core.Deprecated('Use costServiceListRequestDescriptor instead')
const CostServiceListRequest$json = {
  '1': 'CostServiceListRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {
      '1': 'pagination',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.Pagination',
      '10': 'pagination'
    },
    {'1': 'cost_type', '3': 3, '4': 1, '5': 9, '10': 'costType'},
    {
      '1': 'related_scope_type',
      '3': 4,
      '4': 1,
      '5': 9,
      '10': 'relatedScopeType'
    },
    {'1': 'related_scope_id', '3': 5, '4': 1, '5': 9, '10': 'relatedScopeId'},
    {'1': 'period_start', '3': 6, '4': 1, '5': 9, '10': 'periodStart'},
    {'1': 'period_end', '3': 7, '4': 1, '5': 9, '10': 'periodEnd'},
  ],
};

/// Descriptor for `CostServiceListRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List costServiceListRequestDescriptor = $convert.base64Decode(
    'ChZDb3N0U2VydmljZUxpc3RSZXF1ZXN0EiEKDHdvcmtzcGFjZV9pZBgBIAEoCVILd29ya3NwYW'
    'NlSWQSQQoKcGFnaW5hdGlvbhgCIAEoCzIhLmNyZWF0aXZhbnRhLmNvbW1vbi52MS5QYWdpbmF0'
    'aW9uUgpwYWdpbmF0aW9uEhsKCWNvc3RfdHlwZRgDIAEoCVIIY29zdFR5cGUSLAoScmVsYXRlZF'
    '9zY29wZV90eXBlGAQgASgJUhByZWxhdGVkU2NvcGVUeXBlEigKEHJlbGF0ZWRfc2NvcGVfaWQY'
    'BSABKAlSDnJlbGF0ZWRTY29wZUlkEiEKDHBlcmlvZF9zdGFydBgGIAEoCVILcGVyaW9kU3Rhcn'
    'QSHQoKcGVyaW9kX2VuZBgHIAEoCVIJcGVyaW9kRW5k');

@$core.Deprecated('Use costServiceListResponseDescriptor instead')
const CostServiceListResponse$json = {
  '1': 'CostServiceListResponse',
  '2': [
    {
      '1': 'cost_items',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.creativanta.finance.v1.CostItem',
      '10': 'costItems'
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

/// Descriptor for `CostServiceListResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List costServiceListResponseDescriptor = $convert.base64Decode(
    'ChdDb3N0U2VydmljZUxpc3RSZXNwb25zZRI/Cgpjb3N0X2l0ZW1zGAEgAygLMiAuY3JlYXRpdm'
    'FudGEuZmluYW5jZS52MS5Db3N0SXRlbVIJY29zdEl0ZW1zEkgKCnBhZ2luYXRpb24YAiABKAsy'
    'KC5jcmVhdGl2YW50YS5jb21tb24udjEuUGFnaW5hdGVkUmVzcG9uc2VSCnBhZ2luYXRpb24=');

@$core.Deprecated('Use costServiceUpdateRequestDescriptor instead')
const CostServiceUpdateRequest$json = {
  '1': 'CostServiceUpdateRequest',
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
    {'1': 'cost_item_id', '3': 3, '4': 1, '5': 9, '10': 'costItemId'},
    {
      '1': 'amount',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.Money',
      '10': 'amount'
    },
    {'1': 'description', '3': 5, '4': 1, '5': 9, '10': 'description'},
    {'1': 'cost_type', '3': 6, '4': 1, '5': 9, '10': 'costType'},
    {
      '1': 'source_class',
      '3': 7,
      '4': 1,
      '5': 14,
      '6': '.creativanta.common.v1.SourceClass',
      '10': 'sourceClass'
    },
    {
      '1': 'cost_state',
      '3': 8,
      '4': 1,
      '5': 14,
      '6': '.creativanta.finance.v1.CostState',
      '10': 'costState'
    },
  ],
};

/// Descriptor for `CostServiceUpdateRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List costServiceUpdateRequestDescriptor = $convert.base64Decode(
    'ChhDb3N0U2VydmljZVVwZGF0ZVJlcXVlc3QSPwoHY29udGV4dBgBIAEoCzIlLmNyZWF0aXZhbn'
    'RhLmNvbW1vbi52MS5Db21tYW5kQ29udGV4dFIHY29udGV4dBIhCgx3b3Jrc3BhY2VfaWQYAiAB'
    'KAlSC3dvcmtzcGFjZUlkEiAKDGNvc3RfaXRlbV9pZBgDIAEoCVIKY29zdEl0ZW1JZBI0CgZhbW'
    '91bnQYBCABKAsyHC5jcmVhdGl2YW50YS5jb21tb24udjEuTW9uZXlSBmFtb3VudBIgCgtkZXNj'
    'cmlwdGlvbhgFIAEoCVILZGVzY3JpcHRpb24SGwoJY29zdF90eXBlGAYgASgJUghjb3N0VHlwZR'
    'JFCgxzb3VyY2VfY2xhc3MYByABKA4yIi5jcmVhdGl2YW50YS5jb21tb24udjEuU291cmNlQ2xh'
    'c3NSC3NvdXJjZUNsYXNzEkAKCmNvc3Rfc3RhdGUYCCABKA4yIS5jcmVhdGl2YW50YS5maW5hbm'
    'NlLnYxLkNvc3RTdGF0ZVIJY29zdFN0YXRl');

@$core.Deprecated('Use costServiceUpdateResponseDescriptor instead')
const CostServiceUpdateResponse$json = {
  '1': 'CostServiceUpdateResponse',
  '2': [
    {
      '1': 'cost_item',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.finance.v1.CostItem',
      '10': 'costItem'
    },
  ],
};

/// Descriptor for `CostServiceUpdateResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List costServiceUpdateResponseDescriptor =
    $convert.base64Decode(
        'ChlDb3N0U2VydmljZVVwZGF0ZVJlc3BvbnNlEj0KCWNvc3RfaXRlbRgBIAEoCzIgLmNyZWF0aX'
        'ZhbnRhLmZpbmFuY2UudjEuQ29zdEl0ZW1SCGNvc3RJdGVt');

@$core.Deprecated('Use costServiceDeleteRequestDescriptor instead')
const CostServiceDeleteRequest$json = {
  '1': 'CostServiceDeleteRequest',
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
    {'1': 'cost_item_id', '3': 3, '4': 1, '5': 9, '10': 'costItemId'},
  ],
};

/// Descriptor for `CostServiceDeleteRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List costServiceDeleteRequestDescriptor = $convert.base64Decode(
    'ChhDb3N0U2VydmljZURlbGV0ZVJlcXVlc3QSPwoHY29udGV4dBgBIAEoCzIlLmNyZWF0aXZhbn'
    'RhLmNvbW1vbi52MS5Db21tYW5kQ29udGV4dFIHY29udGV4dBIhCgx3b3Jrc3BhY2VfaWQYAiAB'
    'KAlSC3dvcmtzcGFjZUlkEiAKDGNvc3RfaXRlbV9pZBgDIAEoCVIKY29zdEl0ZW1JZA==');

@$core.Deprecated('Use costServiceDeleteResponseDescriptor instead')
const CostServiceDeleteResponse$json = {
  '1': 'CostServiceDeleteResponse',
  '2': [
    {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
  ],
};

/// Descriptor for `CostServiceDeleteResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List costServiceDeleteResponseDescriptor =
    $convert.base64Decode(
        'ChlDb3N0U2VydmljZURlbGV0ZVJlc3BvbnNlEhgKB3N1Y2Nlc3MYASABKAhSB3N1Y2Nlc3M=');

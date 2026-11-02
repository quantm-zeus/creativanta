// This is a generated file - do not edit.
//
// Generated from creativanta/admin/v1/billing.proto.

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

@$core.Deprecated('Use creditSourceTypeDescriptor instead')
const CreditSourceType$json = {
  '1': 'CreditSourceType',
  '2': [
    {'1': 'CREDIT_SOURCE_TYPE_UNSPECIFIED', '2': 0},
    {'1': 'CREDIT_SOURCE_TYPE_SUBSCRIPTION', '2': 1},
    {'1': 'CREDIT_SOURCE_TYPE_PURCHASED', '2': 2},
    {'1': 'CREDIT_SOURCE_TYPE_PROMOTIONAL', '2': 3},
    {'1': 'CREDIT_SOURCE_TYPE_OVERAGE', '2': 4},
  ],
};

/// Descriptor for `CreditSourceType`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List creditSourceTypeDescriptor = $convert.base64Decode(
    'ChBDcmVkaXRTb3VyY2VUeXBlEiIKHkNSRURJVF9TT1VSQ0VfVFlQRV9VTlNQRUNJRklFRBAAEi'
    'MKH0NSRURJVF9TT1VSQ0VfVFlQRV9TVUJTQ1JJUFRJT04QARIgChxDUkVESVRfU09VUkNFX1RZ'
    'UEVfUFVSQ0hBU0VEEAISIgoeQ1JFRElUX1NPVVJDRV9UWVBFX1BST01PVElPTkFMEAMSHgoaQ1'
    'JFRElUX1NPVVJDRV9UWVBFX09WRVJBR0UQBA==');

@$core.Deprecated('Use creditReservationStatusDescriptor instead')
const CreditReservationStatus$json = {
  '1': 'CreditReservationStatus',
  '2': [
    {'1': 'CREDIT_RESERVATION_STATUS_UNSPECIFIED', '2': 0},
    {'1': 'CREDIT_RESERVATION_STATUS_HELD', '2': 1},
    {'1': 'CREDIT_RESERVATION_STATUS_IN_FLIGHT', '2': 2},
    {'1': 'CREDIT_RESERVATION_STATUS_RECONCILING', '2': 3},
    {'1': 'CREDIT_RESERVATION_STATUS_COMMITTED', '2': 4},
    {'1': 'CREDIT_RESERVATION_STATUS_RELEASED', '2': 5},
    {'1': 'CREDIT_RESERVATION_STATUS_EXPIRED', '2': 6},
  ],
};

/// Descriptor for `CreditReservationStatus`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List creditReservationStatusDescriptor = $convert.base64Decode(
    'ChdDcmVkaXRSZXNlcnZhdGlvblN0YXR1cxIpCiVDUkVESVRfUkVTRVJWQVRJT05fU1RBVFVTX1'
    'VOU1BFQ0lGSUVEEAASIgoeQ1JFRElUX1JFU0VSVkFUSU9OX1NUQVRVU19IRUxEEAESJwojQ1JF'
    'RElUX1JFU0VSVkFUSU9OX1NUQVRVU19JTl9GTElHSFQQAhIpCiVDUkVESVRfUkVTRVJWQVRJT0'
    '5fU1RBVFVTX1JFQ09OQ0lMSU5HEAMSJwojQ1JFRElUX1JFU0VSVkFUSU9OX1NUQVRVU19DT01N'
    'SVRURUQQBBImCiJDUkVESVRfUkVTRVJWQVRJT05fU1RBVFVTX1JFTEVBU0VEEAUSJQohQ1JFRE'
    'lUX1JFU0VSVkFUSU9OX1NUQVRVU19FWFBJUkVEEAY=');

@$core.Deprecated('Use subscriptionStatusDescriptor instead')
const SubscriptionStatus$json = {
  '1': 'SubscriptionStatus',
  '2': [
    {'1': 'SUBSCRIPTION_STATUS_UNSPECIFIED', '2': 0},
    {'1': 'SUBSCRIPTION_STATUS_ACTIVE', '2': 1},
    {'1': 'SUBSCRIPTION_STATUS_PAST_DUE', '2': 2},
    {'1': 'SUBSCRIPTION_STATUS_CANCELED', '2': 3},
    {'1': 'SUBSCRIPTION_STATUS_TRIALING', '2': 4},
    {'1': 'SUBSCRIPTION_STATUS_INCOMPLETE', '2': 5},
    {'1': 'SUBSCRIPTION_STATUS_PAUSED', '2': 6},
  ],
};

/// Descriptor for `SubscriptionStatus`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List subscriptionStatusDescriptor = $convert.base64Decode(
    'ChJTdWJzY3JpcHRpb25TdGF0dXMSIwofU1VCU0NSSVBUSU9OX1NUQVRVU19VTlNQRUNJRklFRB'
    'AAEh4KGlNVQlNDUklQVElPTl9TVEFUVVNfQUNUSVZFEAESIAocU1VCU0NSSVBUSU9OX1NUQVRV'
    'U19QQVNUX0RVRRACEiAKHFNVQlNDUklQVElPTl9TVEFUVVNfQ0FOQ0VMRUQQAxIgChxTVUJTQ1'
    'JJUFRJT05fU1RBVFVTX1RSSUFMSU5HEAQSIgoeU1VCU0NSSVBUSU9OX1NUQVRVU19JTkNPTVBM'
    'RVRFEAUSHgoaU1VCU0NSSVBUSU9OX1NUQVRVU19QQVVTRUQQBg==');

@$core.Deprecated('Use invoiceStatusDescriptor instead')
const InvoiceStatus$json = {
  '1': 'InvoiceStatus',
  '2': [
    {'1': 'INVOICE_STATUS_UNSPECIFIED', '2': 0},
    {'1': 'INVOICE_STATUS_DRAFT', '2': 1},
    {'1': 'INVOICE_STATUS_OPEN', '2': 2},
    {'1': 'INVOICE_STATUS_PAID', '2': 3},
    {'1': 'INVOICE_STATUS_VOID', '2': 4},
    {'1': 'INVOICE_STATUS_UNCOLLECTIBLE', '2': 5},
  ],
};

/// Descriptor for `InvoiceStatus`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List invoiceStatusDescriptor = $convert.base64Decode(
    'Cg1JbnZvaWNlU3RhdHVzEh4KGklOVk9JQ0VfU1RBVFVTX1VOU1BFQ0lGSUVEEAASGAoUSU5WT0'
    'lDRV9TVEFUVVNfRFJBRlQQARIXChNJTlZPSUNFX1NUQVRVU19PUEVOEAISFwoTSU5WT0lDRV9T'
    'VEFUVVNfUEFJRBADEhcKE0lOVk9JQ0VfU1RBVFVTX1ZPSUQQBBIgChxJTlZPSUNFX1NUQVRVU1'
    '9VTkNPTExFQ1RJQkxFEAU=');

@$core.Deprecated('Use creditQuoteDescriptor instead')
const CreditQuote$json = {
  '1': 'CreditQuote',
  '2': [
    {
      '1': 'quote_id',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.UUID',
      '10': 'quoteId'
    },
    {'1': 'operation_type', '3': 2, '4': 1, '5': 9, '10': 'operationType'},
    {'1': 'rate_version', '3': 3, '4': 1, '5': 9, '10': 'rateVersion'},
    {'1': 'request_hash', '3': 4, '4': 1, '5': 9, '10': 'requestHash'},
    {'1': 'cost_ceiling_usd', '3': 5, '4': 1, '5': 9, '10': 'costCeilingUsd'},
    {
      '1': 'usd_per_credit_floor',
      '3': 6,
      '4': 1,
      '5': 9,
      '10': 'usdPerCreditFloor'
    },
    {
      '1': 'gross_margin_floor',
      '3': 7,
      '4': 1,
      '5': 9,
      '10': 'grossMarginFloor'
    },
    {'1': 'quoted_credits', '3': 8, '4': 1, '5': 9, '10': 'quotedCredits'},
    {
      '1': 'expires_at',
      '3': 9,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'expiresAt'
    },
    {
      '1': 'provider_plan_json',
      '3': 10,
      '4': 1,
      '5': 9,
      '10': 'providerPlanJson'
    },
  ],
};

/// Descriptor for `CreditQuote`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List creditQuoteDescriptor = $convert.base64Decode(
    'CgtDcmVkaXRRdW90ZRI2CghxdW90ZV9pZBgBIAEoCzIbLmNyZWF0aXZhbnRhLmNvbW1vbi52MS'
    '5VVUlEUgdxdW90ZUlkEiUKDm9wZXJhdGlvbl90eXBlGAIgASgJUg1vcGVyYXRpb25UeXBlEiEK'
    'DHJhdGVfdmVyc2lvbhgDIAEoCVILcmF0ZVZlcnNpb24SIQoMcmVxdWVzdF9oYXNoGAQgASgJUg'
    'tyZXF1ZXN0SGFzaBIoChBjb3N0X2NlaWxpbmdfdXNkGAUgASgJUg5jb3N0Q2VpbGluZ1VzZBIv'
    'ChR1c2RfcGVyX2NyZWRpdF9mbG9vchgGIAEoCVIRdXNkUGVyQ3JlZGl0Rmxvb3ISLAoSZ3Jvc3'
    'NfbWFyZ2luX2Zsb29yGAcgASgJUhBncm9zc01hcmdpbkZsb29yEiUKDnF1b3RlZF9jcmVkaXRz'
    'GAggASgJUg1xdW90ZWRDcmVkaXRzEjkKCmV4cGlyZXNfYXQYCSABKAsyGi5nb29nbGUucHJvdG'
    '9idWYuVGltZXN0YW1wUglleHBpcmVzQXQSLAoScHJvdmlkZXJfcGxhbl9qc29uGAogASgJUhBw'
    'cm92aWRlclBsYW5Kc29u');

@$core.Deprecated('Use creditLotSummaryDescriptor instead')
const CreditLotSummary$json = {
  '1': 'CreditLotSummary',
  '2': [
    {
      '1': 'lot_id',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.UUID',
      '10': 'lotId'
    },
    {
      '1': 'source_type',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.creativanta.admin.v1.CreditSourceType',
      '10': 'sourceType'
    },
    {'1': 'granted_credits', '3': 3, '4': 1, '5': 9, '10': 'grantedCredits'},
    {
      '1': 'remaining_credits',
      '3': 4,
      '4': 1,
      '5': 9,
      '10': 'remainingCredits'
    },
    {'1': 'reserved_credits', '3': 5, '4': 1, '5': 9, '10': 'reservedCredits'},
    {
      '1': 'available_credits',
      '3': 6,
      '4': 1,
      '5': 9,
      '10': 'availableCredits'
    },
    {
      '1': 'expires_at',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'expiresAt'
    },
    {
      '1': 'external_grant_key',
      '3': 8,
      '4': 1,
      '5': 9,
      '10': 'externalGrantKey'
    },
    {
      '1': 'created_at',
      '3': 9,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'createdAt'
    },
  ],
};

/// Descriptor for `CreditLotSummary`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List creditLotSummaryDescriptor = $convert.base64Decode(
    'ChBDcmVkaXRMb3RTdW1tYXJ5EjIKBmxvdF9pZBgBIAEoCzIbLmNyZWF0aXZhbnRhLmNvbW1vbi'
    '52MS5VVUlEUgVsb3RJZBJHCgtzb3VyY2VfdHlwZRgCIAEoDjImLmNyZWF0aXZhbnRhLmFkbWlu'
    'LnYxLkNyZWRpdFNvdXJjZVR5cGVSCnNvdXJjZVR5cGUSJwoPZ3JhbnRlZF9jcmVkaXRzGAMgAS'
    'gJUg5ncmFudGVkQ3JlZGl0cxIrChFyZW1haW5pbmdfY3JlZGl0cxgEIAEoCVIQcmVtYWluaW5n'
    'Q3JlZGl0cxIpChByZXNlcnZlZF9jcmVkaXRzGAUgASgJUg9yZXNlcnZlZENyZWRpdHMSKwoRYX'
    'ZhaWxhYmxlX2NyZWRpdHMYBiABKAlSEGF2YWlsYWJsZUNyZWRpdHMSOQoKZXhwaXJlc19hdBgH'
    'IAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSCWV4cGlyZXNBdBIsChJleHRlcm5hbF'
    '9ncmFudF9rZXkYCCABKAlSEGV4dGVybmFsR3JhbnRLZXkSOQoKY3JlYXRlZF9hdBgJIAEoCzIa'
    'Lmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSCWNyZWF0ZWRBdA==');

@$core.Deprecated('Use creditBalanceDescriptor instead')
const CreditBalance$json = {
  '1': 'CreditBalance',
  '2': [
    {'1': 'total_remaining', '3': 1, '4': 1, '5': 9, '10': 'totalRemaining'},
    {'1': 'reserved', '3': 2, '4': 1, '5': 9, '10': 'reserved'},
    {'1': 'available', '3': 3, '4': 1, '5': 9, '10': 'available'},
    {
      '1': 'subscription_remaining',
      '3': 4,
      '4': 1,
      '5': 9,
      '10': 'subscriptionRemaining'
    },
    {
      '1': 'purchased_remaining',
      '3': 5,
      '4': 1,
      '5': 9,
      '10': 'purchasedRemaining'
    },
    {
      '1': 'promotional_remaining',
      '3': 6,
      '4': 1,
      '5': 9,
      '10': 'promotionalRemaining'
    },
    {
      '1': 'overage_remaining',
      '3': 7,
      '4': 1,
      '5': 9,
      '10': 'overageRemaining'
    },
    {
      '1': 'next_allocation_at',
      '3': 8,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'nextAllocationAt'
    },
    {
      '1': 'subscription_tier',
      '3': 9,
      '4': 1,
      '5': 9,
      '10': 'subscriptionTier'
    },
    {
      '1': 'active_lots',
      '3': 10,
      '4': 3,
      '5': 11,
      '6': '.creativanta.admin.v1.CreditLotSummary',
      '10': 'activeLots'
    },
  ],
};

/// Descriptor for `CreditBalance`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List creditBalanceDescriptor = $convert.base64Decode(
    'Cg1DcmVkaXRCYWxhbmNlEicKD3RvdGFsX3JlbWFpbmluZxgBIAEoCVIOdG90YWxSZW1haW5pbm'
    'cSGgoIcmVzZXJ2ZWQYAiABKAlSCHJlc2VydmVkEhwKCWF2YWlsYWJsZRgDIAEoCVIJYXZhaWxh'
    'YmxlEjUKFnN1YnNjcmlwdGlvbl9yZW1haW5pbmcYBCABKAlSFXN1YnNjcmlwdGlvblJlbWFpbm'
    'luZxIvChNwdXJjaGFzZWRfcmVtYWluaW5nGAUgASgJUhJwdXJjaGFzZWRSZW1haW5pbmcSMwoV'
    'cHJvbW90aW9uYWxfcmVtYWluaW5nGAYgASgJUhRwcm9tb3Rpb25hbFJlbWFpbmluZxIrChFvdm'
    'VyYWdlX3JlbWFpbmluZxgHIAEoCVIQb3ZlcmFnZVJlbWFpbmluZxJIChJuZXh0X2FsbG9jYXRp'
    'b25fYXQYCCABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUhBuZXh0QWxsb2NhdGlvbk'
    'F0EisKEXN1YnNjcmlwdGlvbl90aWVyGAkgASgJUhBzdWJzY3JpcHRpb25UaWVyEkcKC2FjdGl2'
    'ZV9sb3RzGAogAygLMiYuY3JlYXRpdmFudGEuYWRtaW4udjEuQ3JlZGl0TG90U3VtbWFyeVIKYW'
    'N0aXZlTG90cw==');

@$core.Deprecated('Use creditTransactionEntryDescriptor instead')
const CreditTransactionEntry$json = {
  '1': 'CreditTransactionEntry',
  '2': [
    {
      '1': 'transaction_id',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.UUID',
      '10': 'transactionId'
    },
    {
      '1': 'workspace_id',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.UUID',
      '10': 'workspaceId'
    },
    {
      '1': 'user_id',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.UUID',
      '10': 'userId'
    },
    {'1': 'operation_type', '3': 4, '4': 1, '5': 9, '10': 'operationType'},
    {'1': 'credits_delta', '3': 5, '4': 1, '5': 9, '10': 'creditsDelta'},
    {'1': 'balance_after', '3': 6, '4': 1, '5': 9, '10': 'balanceAfter'},
    {'1': 'source', '3': 7, '4': 1, '5': 9, '10': 'source'},
    {
      '1': 'reference_id',
      '3': 8,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.UUID',
      '10': 'referenceId'
    },
    {
      '1': 'reservation_id',
      '3': 9,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.UUID',
      '10': 'reservationId'
    },
    {
      '1': 'lot_id',
      '3': 10,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.UUID',
      '10': 'lotId'
    },
    {
      '1': 'quote_id',
      '3': 11,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.UUID',
      '10': 'quoteId'
    },
    {
      '1': 'reference_transaction_id',
      '3': 12,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.UUID',
      '10': 'referenceTransactionId'
    },
    {
      '1': 'provider_cost_usd',
      '3': 13,
      '4': 1,
      '5': 9,
      '10': 'providerCostUsd'
    },
    {'1': 'rate_version', '3': 14, '4': 1, '5': 9, '10': 'rateVersion'},
    {'1': 'idempotency_key', '3': 15, '4': 1, '5': 9, '10': 'idempotencyKey'},
    {'1': 'description', '3': 16, '4': 1, '5': 9, '10': 'description'},
    {
      '1': 'created_at',
      '3': 17,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'createdAt'
    },
  ],
};

/// Descriptor for `CreditTransactionEntry`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List creditTransactionEntryDescriptor = $convert.base64Decode(
    'ChZDcmVkaXRUcmFuc2FjdGlvbkVudHJ5EkIKDnRyYW5zYWN0aW9uX2lkGAEgASgLMhsuY3JlYX'
    'RpdmFudGEuY29tbW9uLnYxLlVVSURSDXRyYW5zYWN0aW9uSWQSPgoMd29ya3NwYWNlX2lkGAIg'
    'ASgLMhsuY3JlYXRpdmFudGEuY29tbW9uLnYxLlVVSURSC3dvcmtzcGFjZUlkEjQKB3VzZXJfaW'
    'QYAyABKAsyGy5jcmVhdGl2YW50YS5jb21tb24udjEuVVVJRFIGdXNlcklkEiUKDm9wZXJhdGlv'
    'bl90eXBlGAQgASgJUg1vcGVyYXRpb25UeXBlEiMKDWNyZWRpdHNfZGVsdGEYBSABKAlSDGNyZW'
    'RpdHNEZWx0YRIjCg1iYWxhbmNlX2FmdGVyGAYgASgJUgxiYWxhbmNlQWZ0ZXISFgoGc291cmNl'
    'GAcgASgJUgZzb3VyY2USPgoMcmVmZXJlbmNlX2lkGAggASgLMhsuY3JlYXRpdmFudGEuY29tbW'
    '9uLnYxLlVVSURSC3JlZmVyZW5jZUlkEkIKDnJlc2VydmF0aW9uX2lkGAkgASgLMhsuY3JlYXRp'
    'dmFudGEuY29tbW9uLnYxLlVVSURSDXJlc2VydmF0aW9uSWQSMgoGbG90X2lkGAogASgLMhsuY3'
    'JlYXRpdmFudGEuY29tbW9uLnYxLlVVSURSBWxvdElkEjYKCHF1b3RlX2lkGAsgASgLMhsuY3Jl'
    'YXRpdmFudGEuY29tbW9uLnYxLlVVSURSB3F1b3RlSWQSVQoYcmVmZXJlbmNlX3RyYW5zYWN0aW'
    '9uX2lkGAwgASgLMhsuY3JlYXRpdmFudGEuY29tbW9uLnYxLlVVSURSFnJlZmVyZW5jZVRyYW5z'
    'YWN0aW9uSWQSKgoRcHJvdmlkZXJfY29zdF91c2QYDSABKAlSD3Byb3ZpZGVyQ29zdFVzZBIhCg'
    'xyYXRlX3ZlcnNpb24YDiABKAlSC3JhdGVWZXJzaW9uEicKD2lkZW1wb3RlbmN5X2tleRgPIAEo'
    'CVIOaWRlbXBvdGVuY3lLZXkSIAoLZGVzY3JpcHRpb24YECABKAlSC2Rlc2NyaXB0aW9uEjkKCm'
    'NyZWF0ZWRfYXQYESABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUgljcmVhdGVkQXQ=');

@$core.Deprecated('Use planCatalogEntryDescriptor instead')
const PlanCatalogEntry$json = {
  '1': 'PlanCatalogEntry',
  '2': [
    {'1': 'tier_code', '3': 1, '4': 1, '5': 9, '10': 'tierCode'},
    {'1': 'display_name', '3': 2, '4': 1, '5': 9, '10': 'displayName'},
    {
      '1': 'monthly_price_usd',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.Money',
      '10': 'monthlyPriceUsd'
    },
    {
      '1': 'annual_price_usd',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.Money',
      '10': 'annualPriceUsd'
    },
    {
      '1': 'monthly_price_vnd',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.Money',
      '10': 'monthlyPriceVnd'
    },
    {
      '1': 'annual_price_vnd',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.Money',
      '10': 'annualPriceVnd'
    },
    {'1': 'monthly_credits', '3': 7, '4': 1, '5': 9, '10': 'monthlyCredits'},
    {
      '1': 'rollover_fraction',
      '3': 8,
      '4': 1,
      '5': 9,
      '10': 'rolloverFraction'
    },
    {'1': 'max_seats', '3': 9, '4': 1, '5': 5, '10': 'maxSeats'},
    {'1': 'max_channels', '3': 10, '4': 1, '5': 5, '10': 'maxChannels'},
    {'1': 'max_storage_gb', '3': 11, '4': 1, '5': 5, '10': 'maxStorageGb'},
    {'1': 'overage_eligible', '3': 12, '4': 1, '5': 8, '10': 'overageEligible'},
  ],
};

/// Descriptor for `PlanCatalogEntry`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List planCatalogEntryDescriptor = $convert.base64Decode(
    'ChBQbGFuQ2F0YWxvZ0VudHJ5EhsKCXRpZXJfY29kZRgBIAEoCVIIdGllckNvZGUSIQoMZGlzcG'
    'xheV9uYW1lGAIgASgJUgtkaXNwbGF5TmFtZRJIChFtb250aGx5X3ByaWNlX3VzZBgDIAEoCzIc'
    'LmNyZWF0aXZhbnRhLmNvbW1vbi52MS5Nb25leVIPbW9udGhseVByaWNlVXNkEkYKEGFubnVhbF'
    '9wcmljZV91c2QYBCABKAsyHC5jcmVhdGl2YW50YS5jb21tb24udjEuTW9uZXlSDmFubnVhbFBy'
    'aWNlVXNkEkgKEW1vbnRobHlfcHJpY2Vfdm5kGAUgASgLMhwuY3JlYXRpdmFudGEuY29tbW9uLn'
    'YxLk1vbmV5Ug9tb250aGx5UHJpY2VWbmQSRgoQYW5udWFsX3ByaWNlX3ZuZBgGIAEoCzIcLmNy'
    'ZWF0aXZhbnRhLmNvbW1vbi52MS5Nb25leVIOYW5udWFsUHJpY2VWbmQSJwoPbW9udGhseV9jcm'
    'VkaXRzGAcgASgJUg5tb250aGx5Q3JlZGl0cxIrChFyb2xsb3Zlcl9mcmFjdGlvbhgIIAEoCVIQ'
    'cm9sbG92ZXJGcmFjdGlvbhIbCgltYXhfc2VhdHMYCSABKAVSCG1heFNlYXRzEiEKDG1heF9jaG'
    'FubmVscxgKIAEoBVILbWF4Q2hhbm5lbHMSJAoObWF4X3N0b3JhZ2VfZ2IYCyABKAVSDG1heFN0'
    'b3JhZ2VHYhIpChBvdmVyYWdlX2VsaWdpYmxlGAwgASgIUg9vdmVyYWdlRWxpZ2libGU=');

@$core.Deprecated('Use creditPackEntryDescriptor instead')
const CreditPackEntry$json = {
  '1': 'CreditPackEntry',
  '2': [
    {'1': 'pack_code', '3': 1, '4': 1, '5': 9, '10': 'packCode'},
    {'1': 'display_name', '3': 2, '4': 1, '5': 9, '10': 'displayName'},
    {'1': 'credits', '3': 3, '4': 1, '5': 9, '10': 'credits'},
    {
      '1': 'price_usd',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.Money',
      '10': 'priceUsd'
    },
    {
      '1': 'price_vnd',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.Money',
      '10': 'priceVnd'
    },
    {'1': 'never_expires', '3': 6, '4': 1, '5': 8, '10': 'neverExpires'},
  ],
};

/// Descriptor for `CreditPackEntry`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List creditPackEntryDescriptor = $convert.base64Decode(
    'Cg9DcmVkaXRQYWNrRW50cnkSGwoJcGFja19jb2RlGAEgASgJUghwYWNrQ29kZRIhCgxkaXNwbG'
    'F5X25hbWUYAiABKAlSC2Rpc3BsYXlOYW1lEhgKB2NyZWRpdHMYAyABKAlSB2NyZWRpdHMSOQoJ'
    'cHJpY2VfdXNkGAQgASgLMhwuY3JlYXRpdmFudGEuY29tbW9uLnYxLk1vbmV5UghwcmljZVVzZB'
    'I5CglwcmljZV92bmQYBSABKAsyHC5jcmVhdGl2YW50YS5jb21tb24udjEuTW9uZXlSCHByaWNl'
    'Vm5kEiMKDW5ldmVyX2V4cGlyZXMYBiABKAhSDG5ldmVyRXhwaXJlcw==');

@$core.Deprecated('Use addonCatalogEntryDescriptor instead')
const AddonCatalogEntry$json = {
  '1': 'AddonCatalogEntry',
  '2': [
    {'1': 'addon_code', '3': 1, '4': 1, '5': 9, '10': 'addonCode'},
    {'1': 'display_name', '3': 2, '4': 1, '5': 9, '10': 'displayName'},
    {
      '1': 'monthly_price_usd',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.Money',
      '10': 'monthlyPriceUsd'
    },
    {
      '1': 'monthly_price_vnd',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.Money',
      '10': 'monthlyPriceVnd'
    },
    {'1': 'eligible_tiers', '3': 5, '4': 3, '5': 9, '10': 'eligibleTiers'},
  ],
};

/// Descriptor for `AddonCatalogEntry`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List addonCatalogEntryDescriptor = $convert.base64Decode(
    'ChFBZGRvbkNhdGFsb2dFbnRyeRIdCgphZGRvbl9jb2RlGAEgASgJUglhZGRvbkNvZGUSIQoMZG'
    'lzcGxheV9uYW1lGAIgASgJUgtkaXNwbGF5TmFtZRJIChFtb250aGx5X3ByaWNlX3VzZBgDIAEo'
    'CzIcLmNyZWF0aXZhbnRhLmNvbW1vbi52MS5Nb25leVIPbW9udGhseVByaWNlVXNkEkgKEW1vbn'
    'RobHlfcHJpY2Vfdm5kGAQgASgLMhwuY3JlYXRpdmFudGEuY29tbW9uLnYxLk1vbmV5Ug9tb250'
    'aGx5UHJpY2VWbmQSJQoOZWxpZ2libGVfdGllcnMYBSADKAlSDWVsaWdpYmxlVGllcnM=');

@$core.Deprecated('Use subscriptionSummaryDescriptor instead')
const SubscriptionSummary$json = {
  '1': 'SubscriptionSummary',
  '2': [
    {
      '1': 'subscription_id',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.UUID',
      '10': 'subscriptionId'
    },
    {
      '1': 'workspace_id',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.UUID',
      '10': 'workspaceId'
    },
    {'1': 'plan', '3': 3, '4': 1, '5': 9, '10': 'plan'},
    {'1': 'billing_interval', '3': 4, '4': 1, '5': 9, '10': 'billingInterval'},
    {
      '1': 'status',
      '3': 5,
      '4': 1,
      '5': 14,
      '6': '.creativanta.admin.v1.SubscriptionStatus',
      '10': 'status'
    },
    {
      '1': 'amount',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.Money',
      '10': 'amount'
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
      '1': 'cancel_at_period_end',
      '3': 9,
      '4': 1,
      '5': 8,
      '10': 'cancelAtPeriodEnd'
    },
    {
      '1': 'canceled_at',
      '3': 10,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'canceledAt'
    },
    {'1': 'addons', '3': 11, '4': 3, '5': 9, '10': 'addons'},
  ],
};

/// Descriptor for `SubscriptionSummary`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List subscriptionSummaryDescriptor = $convert.base64Decode(
    'ChNTdWJzY3JpcHRpb25TdW1tYXJ5EkQKD3N1YnNjcmlwdGlvbl9pZBgBIAEoCzIbLmNyZWF0aX'
    'ZhbnRhLmNvbW1vbi52MS5VVUlEUg5zdWJzY3JpcHRpb25JZBI+Cgx3b3Jrc3BhY2VfaWQYAiAB'
    'KAsyGy5jcmVhdGl2YW50YS5jb21tb24udjEuVVVJRFILd29ya3NwYWNlSWQSEgoEcGxhbhgDIA'
    'EoCVIEcGxhbhIpChBiaWxsaW5nX2ludGVydmFsGAQgASgJUg9iaWxsaW5nSW50ZXJ2YWwSQAoG'
    'c3RhdHVzGAUgASgOMiguY3JlYXRpdmFudGEuYWRtaW4udjEuU3Vic2NyaXB0aW9uU3RhdHVzUg'
    'ZzdGF0dXMSNAoGYW1vdW50GAYgASgLMhwuY3JlYXRpdmFudGEuY29tbW9uLnYxLk1vbmV5UgZh'
    'bW91bnQSTAoUY3VycmVudF9wZXJpb2Rfc3RhcnQYByABKAsyGi5nb29nbGUucHJvdG9idWYuVG'
    'ltZXN0YW1wUhJjdXJyZW50UGVyaW9kU3RhcnQSSAoSY3VycmVudF9wZXJpb2RfZW5kGAggASgL'
    'MhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIQY3VycmVudFBlcmlvZEVuZBIvChRjYW5jZW'
    'xfYXRfcGVyaW9kX2VuZBgJIAEoCFIRY2FuY2VsQXRQZXJpb2RFbmQSOwoLY2FuY2VsZWRfYXQY'
    'CiABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUgpjYW5jZWxlZEF0EhYKBmFkZG9ucx'
    'gLIAMoCVIGYWRkb25z');

@$core.Deprecated('Use paymentMethodSummaryDescriptor instead')
const PaymentMethodSummary$json = {
  '1': 'PaymentMethodSummary',
  '2': [
    {
      '1': 'payment_method_id',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.UUID',
      '10': 'paymentMethodId'
    },
    {
      '1': 'stripe_payment_method_id',
      '3': 2,
      '4': 1,
      '5': 9,
      '10': 'stripePaymentMethodId'
    },
    {'1': 'type', '3': 3, '4': 1, '5': 9, '10': 'type'},
    {'1': 'card_brand', '3': 4, '4': 1, '5': 9, '10': 'cardBrand'},
    {'1': 'card_last4', '3': 5, '4': 1, '5': 9, '10': 'cardLast4'},
    {'1': 'card_exp_month', '3': 6, '4': 1, '5': 5, '10': 'cardExpMonth'},
    {'1': 'card_exp_year', '3': 7, '4': 1, '5': 5, '10': 'cardExpYear'},
    {'1': 'is_default', '3': 8, '4': 1, '5': 8, '10': 'isDefault'},
  ],
};

/// Descriptor for `PaymentMethodSummary`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List paymentMethodSummaryDescriptor = $convert.base64Decode(
    'ChRQYXltZW50TWV0aG9kU3VtbWFyeRJHChFwYXltZW50X21ldGhvZF9pZBgBIAEoCzIbLmNyZW'
    'F0aXZhbnRhLmNvbW1vbi52MS5VVUlEUg9wYXltZW50TWV0aG9kSWQSNwoYc3RyaXBlX3BheW1l'
    'bnRfbWV0aG9kX2lkGAIgASgJUhVzdHJpcGVQYXltZW50TWV0aG9kSWQSEgoEdHlwZRgDIAEoCV'
    'IEdHlwZRIdCgpjYXJkX2JyYW5kGAQgASgJUgljYXJkQnJhbmQSHQoKY2FyZF9sYXN0NBgFIAEo'
    'CVIJY2FyZExhc3Q0EiQKDmNhcmRfZXhwX21vbnRoGAYgASgFUgxjYXJkRXhwTW9udGgSIgoNY2'
    'FyZF9leHBfeWVhchgHIAEoBVILY2FyZEV4cFllYXISHQoKaXNfZGVmYXVsdBgIIAEoCFIJaXNE'
    'ZWZhdWx0');

@$core.Deprecated('Use invoiceSummaryDescriptor instead')
const InvoiceSummary$json = {
  '1': 'InvoiceSummary',
  '2': [
    {
      '1': 'invoice_id',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.UUID',
      '10': 'invoiceId'
    },
    {'1': 'invoice_number', '3': 2, '4': 1, '5': 9, '10': 'invoiceNumber'},
    {
      '1': 'status',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.creativanta.admin.v1.InvoiceStatus',
      '10': 'status'
    },
    {
      '1': 'subtotal',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.Money',
      '10': 'subtotal'
    },
    {
      '1': 'discount_amount',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.Money',
      '10': 'discountAmount'
    },
    {
      '1': 'tax_amount',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.Money',
      '10': 'taxAmount'
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
      '1': 'amount_paid',
      '3': 8,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.Money',
      '10': 'amountPaid'
    },
    {
      '1': 'amount_due',
      '3': 9,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.Money',
      '10': 'amountDue'
    },
    {'1': 'invoice_pdf_url', '3': 10, '4': 1, '5': 9, '10': 'invoicePdfUrl'},
    {
      '1': 'hosted_invoice_url',
      '3': 11,
      '4': 1,
      '5': 9,
      '10': 'hostedInvoiceUrl'
    },
    {
      '1': 'period_start',
      '3': 12,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'periodStart'
    },
    {
      '1': 'period_end',
      '3': 13,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'periodEnd'
    },
    {
      '1': 'paid_at',
      '3': 14,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'paidAt'
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

/// Descriptor for `InvoiceSummary`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List invoiceSummaryDescriptor = $convert.base64Decode(
    'Cg5JbnZvaWNlU3VtbWFyeRI6CgppbnZvaWNlX2lkGAEgASgLMhsuY3JlYXRpdmFudGEuY29tbW'
    '9uLnYxLlVVSURSCWludm9pY2VJZBIlCg5pbnZvaWNlX251bWJlchgCIAEoCVINaW52b2ljZU51'
    'bWJlchI7CgZzdGF0dXMYAyABKA4yIy5jcmVhdGl2YW50YS5hZG1pbi52MS5JbnZvaWNlU3RhdH'
    'VzUgZzdGF0dXMSOAoIc3VidG90YWwYBCABKAsyHC5jcmVhdGl2YW50YS5jb21tb24udjEuTW9u'
    'ZXlSCHN1YnRvdGFsEkUKD2Rpc2NvdW50X2Ftb3VudBgFIAEoCzIcLmNyZWF0aXZhbnRhLmNvbW'
    '1vbi52MS5Nb25leVIOZGlzY291bnRBbW91bnQSOwoKdGF4X2Ftb3VudBgGIAEoCzIcLmNyZWF0'
    'aXZhbnRhLmNvbW1vbi52MS5Nb25leVIJdGF4QW1vdW50EjIKBXRvdGFsGAcgASgLMhwuY3JlYX'
    'RpdmFudGEuY29tbW9uLnYxLk1vbmV5UgV0b3RhbBI9CgthbW91bnRfcGFpZBgIIAEoCzIcLmNy'
    'ZWF0aXZhbnRhLmNvbW1vbi52MS5Nb25leVIKYW1vdW50UGFpZBI7CgphbW91bnRfZHVlGAkgAS'
    'gLMhwuY3JlYXRpdmFudGEuY29tbW9uLnYxLk1vbmV5UglhbW91bnREdWUSJgoPaW52b2ljZV9w'
    'ZGZfdXJsGAogASgJUg1pbnZvaWNlUGRmVXJsEiwKEmhvc3RlZF9pbnZvaWNlX3VybBgLIAEoCV'
    'IQaG9zdGVkSW52b2ljZVVybBI9CgxwZXJpb2Rfc3RhcnQYDCABKAsyGi5nb29nbGUucHJvdG9i'
    'dWYuVGltZXN0YW1wUgtwZXJpb2RTdGFydBI5CgpwZXJpb2RfZW5kGA0gASgLMhouZ29vZ2xlLn'
    'Byb3RvYnVmLlRpbWVzdGFtcFIJcGVyaW9kRW5kEjMKB3BhaWRfYXQYDiABKAsyGi5nb29nbGUu'
    'cHJvdG9idWYuVGltZXN0YW1wUgZwYWlkQXQSOQoKY3JlYXRlZF9hdBgPIAEoCzIaLmdvb2dsZS'
    '5wcm90b2J1Zi5UaW1lc3RhbXBSCWNyZWF0ZWRBdA==');

@$core.Deprecated('Use autoRefillConfigDescriptor instead')
const AutoRefillConfig$json = {
  '1': 'AutoRefillConfig',
  '2': [
    {'1': 'enabled', '3': 1, '4': 1, '5': 8, '10': 'enabled'},
    {
      '1': 'threshold_credits',
      '3': 2,
      '4': 1,
      '5': 9,
      '10': 'thresholdCredits'
    },
    {'1': 'pack_code', '3': 3, '4': 1, '5': 9, '10': 'packCode'},
  ],
};

/// Descriptor for `AutoRefillConfig`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List autoRefillConfigDescriptor = $convert.base64Decode(
    'ChBBdXRvUmVmaWxsQ29uZmlnEhgKB2VuYWJsZWQYASABKAhSB2VuYWJsZWQSKwoRdGhyZXNob2'
    'xkX2NyZWRpdHMYAiABKAlSEHRocmVzaG9sZENyZWRpdHMSGwoJcGFja19jb2RlGAMgASgJUghw'
    'YWNrQ29kZQ==');

@$core.Deprecated('Use operationUsageBreakdownDescriptor instead')
const OperationUsageBreakdown$json = {
  '1': 'OperationUsageBreakdown',
  '2': [
    {'1': 'operation_type', '3': 1, '4': 1, '5': 9, '10': 'operationType'},
    {'1': 'credits_used', '3': 2, '4': 1, '5': 9, '10': 'creditsUsed'},
    {'1': 'operation_count', '3': 3, '4': 1, '5': 3, '10': 'operationCount'},
  ],
};

/// Descriptor for `OperationUsageBreakdown`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List operationUsageBreakdownDescriptor = $convert.base64Decode(
    'ChdPcGVyYXRpb25Vc2FnZUJyZWFrZG93bhIlCg5vcGVyYXRpb25fdHlwZRgBIAEoCVINb3Blcm'
    'F0aW9uVHlwZRIhCgxjcmVkaXRzX3VzZWQYAiABKAlSC2NyZWRpdHNVc2VkEicKD29wZXJhdGlv'
    'bl9jb3VudBgDIAEoA1IOb3BlcmF0aW9uQ291bnQ=');

@$core.Deprecated('Use getBillingSummaryRequestDescriptor instead')
const GetBillingSummaryRequest$json = {
  '1': 'GetBillingSummaryRequest',
  '2': [
    {
      '1': 'workspace_id',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.UUID',
      '10': 'workspaceId'
    },
  ],
};

/// Descriptor for `GetBillingSummaryRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getBillingSummaryRequestDescriptor =
    $convert.base64Decode(
        'ChhHZXRCaWxsaW5nU3VtbWFyeVJlcXVlc3QSPgoMd29ya3NwYWNlX2lkGAEgASgLMhsuY3JlYX'
        'RpdmFudGEuY29tbW9uLnYxLlVVSURSC3dvcmtzcGFjZUlk');

@$core.Deprecated('Use getBillingSummaryResponseDescriptor instead')
const GetBillingSummaryResponse$json = {
  '1': 'GetBillingSummaryResponse',
  '2': [
    {
      '1': 'subscription',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.admin.v1.SubscriptionSummary',
      '10': 'subscription'
    },
    {
      '1': 'credit_balance',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.creativanta.admin.v1.CreditBalance',
      '10': 'creditBalance'
    },
    {
      '1': 'default_payment_method',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.creativanta.admin.v1.PaymentMethodSummary',
      '10': 'defaultPaymentMethod'
    },
    {
      '1': 'recent_invoices',
      '3': 4,
      '4': 3,
      '5': 11,
      '6': '.creativanta.admin.v1.InvoiceSummary',
      '10': 'recentInvoices'
    },
    {
      '1': 'pricebook_version',
      '3': 5,
      '4': 1,
      '5': 9,
      '10': 'pricebookVersion'
    },
  ],
};

/// Descriptor for `GetBillingSummaryResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getBillingSummaryResponseDescriptor = $convert.base64Decode(
    'ChlHZXRCaWxsaW5nU3VtbWFyeVJlc3BvbnNlEk0KDHN1YnNjcmlwdGlvbhgBIAEoCzIpLmNyZW'
    'F0aXZhbnRhLmFkbWluLnYxLlN1YnNjcmlwdGlvblN1bW1hcnlSDHN1YnNjcmlwdGlvbhJKCg5j'
    'cmVkaXRfYmFsYW5jZRgCIAEoCzIjLmNyZWF0aXZhbnRhLmFkbWluLnYxLkNyZWRpdEJhbGFuY2'
    'VSDWNyZWRpdEJhbGFuY2USYAoWZGVmYXVsdF9wYXltZW50X21ldGhvZBgDIAEoCzIqLmNyZWF0'
    'aXZhbnRhLmFkbWluLnYxLlBheW1lbnRNZXRob2RTdW1tYXJ5UhRkZWZhdWx0UGF5bWVudE1ldG'
    'hvZBJNCg9yZWNlbnRfaW52b2ljZXMYBCADKAsyJC5jcmVhdGl2YW50YS5hZG1pbi52MS5JbnZv'
    'aWNlU3VtbWFyeVIOcmVjZW50SW52b2ljZXMSKwoRcHJpY2Vib29rX3ZlcnNpb24YBSABKAlSEH'
    'ByaWNlYm9va1ZlcnNpb24=');

@$core.Deprecated('Use getCreditBalanceRequestDescriptor instead')
const GetCreditBalanceRequest$json = {
  '1': 'GetCreditBalanceRequest',
  '2': [
    {
      '1': 'workspace_id',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.UUID',
      '10': 'workspaceId'
    },
  ],
};

/// Descriptor for `GetCreditBalanceRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getCreditBalanceRequestDescriptor =
    $convert.base64Decode(
        'ChdHZXRDcmVkaXRCYWxhbmNlUmVxdWVzdBI+Cgx3b3Jrc3BhY2VfaWQYASABKAsyGy5jcmVhdG'
        'l2YW50YS5jb21tb24udjEuVVVJRFILd29ya3NwYWNlSWQ=');

@$core.Deprecated('Use getCreditBalanceResponseDescriptor instead')
const GetCreditBalanceResponse$json = {
  '1': 'GetCreditBalanceResponse',
  '2': [
    {
      '1': 'balance',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.admin.v1.CreditBalance',
      '10': 'balance'
    },
  ],
};

/// Descriptor for `GetCreditBalanceResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getCreditBalanceResponseDescriptor =
    $convert.base64Decode(
        'ChhHZXRDcmVkaXRCYWxhbmNlUmVzcG9uc2USPQoHYmFsYW5jZRgBIAEoCzIjLmNyZWF0aXZhbn'
        'RhLmFkbWluLnYxLkNyZWRpdEJhbGFuY2VSB2JhbGFuY2U=');

@$core.Deprecated('Use getCreditLedgerRequestDescriptor instead')
const GetCreditLedgerRequest$json = {
  '1': 'GetCreditLedgerRequest',
  '2': [
    {
      '1': 'workspace_id',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.UUID',
      '10': 'workspaceId'
    },
    {
      '1': 'pagination',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.Pagination',
      '10': 'pagination'
    },
    {
      '1': 'operation_type_filter',
      '3': 3,
      '4': 1,
      '5': 9,
      '10': 'operationTypeFilter'
    },
    {'1': 'source_filter', '3': 4, '4': 1, '5': 9, '10': 'sourceFilter'},
  ],
};

/// Descriptor for `GetCreditLedgerRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getCreditLedgerRequestDescriptor = $convert.base64Decode(
    'ChZHZXRDcmVkaXRMZWRnZXJSZXF1ZXN0Ej4KDHdvcmtzcGFjZV9pZBgBIAEoCzIbLmNyZWF0aX'
    'ZhbnRhLmNvbW1vbi52MS5VVUlEUgt3b3Jrc3BhY2VJZBJBCgpwYWdpbmF0aW9uGAIgASgLMiEu'
    'Y3JlYXRpdmFudGEuY29tbW9uLnYxLlBhZ2luYXRpb25SCnBhZ2luYXRpb24SMgoVb3BlcmF0aW'
    '9uX3R5cGVfZmlsdGVyGAMgASgJUhNvcGVyYXRpb25UeXBlRmlsdGVyEiMKDXNvdXJjZV9maWx0'
    'ZXIYBCABKAlSDHNvdXJjZUZpbHRlcg==');

@$core.Deprecated('Use getCreditLedgerResponseDescriptor instead')
const GetCreditLedgerResponse$json = {
  '1': 'GetCreditLedgerResponse',
  '2': [
    {
      '1': 'entries',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.creativanta.admin.v1.CreditTransactionEntry',
      '10': 'entries'
    },
    {
      '1': 'page_info',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.PaginatedResponse',
      '10': 'pageInfo'
    },
  ],
};

/// Descriptor for `GetCreditLedgerResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getCreditLedgerResponseDescriptor = $convert.base64Decode(
    'ChdHZXRDcmVkaXRMZWRnZXJSZXNwb25zZRJGCgdlbnRyaWVzGAEgAygLMiwuY3JlYXRpdmFudG'
    'EuYWRtaW4udjEuQ3JlZGl0VHJhbnNhY3Rpb25FbnRyeVIHZW50cmllcxJFCglwYWdlX2luZm8Y'
    'AiABKAsyKC5jcmVhdGl2YW50YS5jb21tb24udjEuUGFnaW5hdGVkUmVzcG9uc2VSCHBhZ2VJbm'
    'Zv');

@$core.Deprecated('Use purchaseCreditsRequestDescriptor instead')
const PurchaseCreditsRequest$json = {
  '1': 'PurchaseCreditsRequest',
  '2': [
    {
      '1': 'context',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.CommandContext',
      '10': 'context'
    },
    {'1': 'pack_code', '3': 2, '4': 1, '5': 9, '10': 'packCode'},
    {'1': 'currency', '3': 3, '4': 1, '5': 9, '10': 'currency'},
    {'1': 'success_url', '3': 4, '4': 1, '5': 9, '10': 'successUrl'},
    {'1': 'cancel_url', '3': 5, '4': 1, '5': 9, '10': 'cancelUrl'},
  ],
};

/// Descriptor for `PurchaseCreditsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List purchaseCreditsRequestDescriptor = $convert.base64Decode(
    'ChZQdXJjaGFzZUNyZWRpdHNSZXF1ZXN0Ej8KB2NvbnRleHQYASABKAsyJS5jcmVhdGl2YW50YS'
    '5jb21tb24udjEuQ29tbWFuZENvbnRleHRSB2NvbnRleHQSGwoJcGFja19jb2RlGAIgASgJUghw'
    'YWNrQ29kZRIaCghjdXJyZW5jeRgDIAEoCVIIY3VycmVuY3kSHwoLc3VjY2Vzc191cmwYBCABKA'
    'lSCnN1Y2Nlc3NVcmwSHQoKY2FuY2VsX3VybBgFIAEoCVIJY2FuY2VsVXJs');

@$core.Deprecated('Use purchaseCreditsResponseDescriptor instead')
const PurchaseCreditsResponse$json = {
  '1': 'PurchaseCreditsResponse',
  '2': [
    {
      '1': 'checkout_session_id',
      '3': 1,
      '4': 1,
      '5': 9,
      '10': 'checkoutSessionId'
    },
    {'1': 'checkout_url', '3': 2, '4': 1, '5': 9, '10': 'checkoutUrl'},
    {'1': 'status', '3': 3, '4': 1, '5': 9, '10': 'status'},
    {
      '1': 'pack',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.creativanta.admin.v1.CreditPackEntry',
      '10': 'pack'
    },
  ],
};

/// Descriptor for `PurchaseCreditsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List purchaseCreditsResponseDescriptor = $convert.base64Decode(
    'ChdQdXJjaGFzZUNyZWRpdHNSZXNwb25zZRIuChNjaGVja291dF9zZXNzaW9uX2lkGAEgASgJUh'
    'FjaGVja291dFNlc3Npb25JZBIhCgxjaGVja291dF91cmwYAiABKAlSC2NoZWNrb3V0VXJsEhYK'
    'BnN0YXR1cxgDIAEoCVIGc3RhdHVzEjkKBHBhY2sYBCABKAsyJS5jcmVhdGl2YW50YS5hZG1pbi'
    '52MS5DcmVkaXRQYWNrRW50cnlSBHBhY2s=');

@$core.Deprecated('Use changePlanRequestDescriptor instead')
const ChangePlanRequest$json = {
  '1': 'ChangePlanRequest',
  '2': [
    {
      '1': 'context',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.CommandContext',
      '10': 'context'
    },
    {'1': 'target_plan', '3': 2, '4': 1, '5': 9, '10': 'targetPlan'},
    {'1': 'billing_interval', '3': 3, '4': 1, '5': 9, '10': 'billingInterval'},
    {'1': 'currency', '3': 4, '4': 1, '5': 9, '10': 'currency'},
    {'1': 'addons', '3': 5, '4': 3, '5': 9, '10': 'addons'},
  ],
};

/// Descriptor for `ChangePlanRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List changePlanRequestDescriptor = $convert.base64Decode(
    'ChFDaGFuZ2VQbGFuUmVxdWVzdBI/Cgdjb250ZXh0GAEgASgLMiUuY3JlYXRpdmFudGEuY29tbW'
    '9uLnYxLkNvbW1hbmRDb250ZXh0Ugdjb250ZXh0Eh8KC3RhcmdldF9wbGFuGAIgASgJUgp0YXJn'
    'ZXRQbGFuEikKEGJpbGxpbmdfaW50ZXJ2YWwYAyABKAlSD2JpbGxpbmdJbnRlcnZhbBIaCghjdX'
    'JyZW5jeRgEIAEoCVIIY3VycmVuY3kSFgoGYWRkb25zGAUgAygJUgZhZGRvbnM=');

@$core.Deprecated('Use changePlanResponseDescriptor instead')
const ChangePlanResponse$json = {
  '1': 'ChangePlanResponse',
  '2': [
    {
      '1': 'subscription',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.admin.v1.SubscriptionSummary',
      '10': 'subscription'
    },
    {'1': 'effective_mode', '3': 2, '4': 1, '5': 9, '10': 'effectiveMode'},
    {
      '1': 'checkout_session_id',
      '3': 3,
      '4': 1,
      '5': 9,
      '10': 'checkoutSessionId'
    },
    {'1': 'checkout_url', '3': 4, '4': 1, '5': 9, '10': 'checkoutUrl'},
  ],
};

/// Descriptor for `ChangePlanResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List changePlanResponseDescriptor = $convert.base64Decode(
    'ChJDaGFuZ2VQbGFuUmVzcG9uc2USTQoMc3Vic2NyaXB0aW9uGAEgASgLMikuY3JlYXRpdmFudG'
    'EuYWRtaW4udjEuU3Vic2NyaXB0aW9uU3VtbWFyeVIMc3Vic2NyaXB0aW9uEiUKDmVmZmVjdGl2'
    'ZV9tb2RlGAIgASgJUg1lZmZlY3RpdmVNb2RlEi4KE2NoZWNrb3V0X3Nlc3Npb25faWQYAyABKA'
    'lSEWNoZWNrb3V0U2Vzc2lvbklkEiEKDGNoZWNrb3V0X3VybBgEIAEoCVILY2hlY2tvdXRVcmw=');

@$core.Deprecated('Use cancelSubscriptionRequestDescriptor instead')
const CancelSubscriptionRequest$json = {
  '1': 'CancelSubscriptionRequest',
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
      '1': 'cancellation_reason',
      '3': 2,
      '4': 1,
      '5': 9,
      '10': 'cancellationReason'
    },
    {'1': 'pause_instead', '3': 3, '4': 1, '5': 8, '10': 'pauseInstead'},
    {'1': 'pause_months', '3': 4, '4': 1, '5': 5, '10': 'pauseMonths'},
  ],
};

/// Descriptor for `CancelSubscriptionRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List cancelSubscriptionRequestDescriptor = $convert.base64Decode(
    'ChlDYW5jZWxTdWJzY3JpcHRpb25SZXF1ZXN0Ej8KB2NvbnRleHQYASABKAsyJS5jcmVhdGl2YW'
    '50YS5jb21tb24udjEuQ29tbWFuZENvbnRleHRSB2NvbnRleHQSLwoTY2FuY2VsbGF0aW9uX3Jl'
    'YXNvbhgCIAEoCVISY2FuY2VsbGF0aW9uUmVhc29uEiMKDXBhdXNlX2luc3RlYWQYAyABKAhSDH'
    'BhdXNlSW5zdGVhZBIhCgxwYXVzZV9tb250aHMYBCABKAVSC3BhdXNlTW9udGhz');

@$core.Deprecated('Use cancelSubscriptionResponseDescriptor instead')
const CancelSubscriptionResponse$json = {
  '1': 'CancelSubscriptionResponse',
  '2': [
    {
      '1': 'subscription',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.admin.v1.SubscriptionSummary',
      '10': 'subscription'
    },
  ],
};

/// Descriptor for `CancelSubscriptionResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List cancelSubscriptionResponseDescriptor =
    $convert.base64Decode(
        'ChpDYW5jZWxTdWJzY3JpcHRpb25SZXNwb25zZRJNCgxzdWJzY3JpcHRpb24YASABKAsyKS5jcm'
        'VhdGl2YW50YS5hZG1pbi52MS5TdWJzY3JpcHRpb25TdW1tYXJ5UgxzdWJzY3JpcHRpb24=');

@$core.Deprecated('Use updatePaymentMethodRequestDescriptor instead')
const UpdatePaymentMethodRequest$json = {
  '1': 'UpdatePaymentMethodRequest',
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
      '1': 'stripe_payment_method_id',
      '3': 2,
      '4': 1,
      '5': 9,
      '10': 'stripePaymentMethodId'
    },
    {'1': 'set_default', '3': 3, '4': 1, '5': 8, '10': 'setDefault'},
    {'1': 'remove', '3': 4, '4': 1, '5': 8, '10': 'remove'},
  ],
};

/// Descriptor for `UpdatePaymentMethodRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updatePaymentMethodRequestDescriptor = $convert.base64Decode(
    'ChpVcGRhdGVQYXltZW50TWV0aG9kUmVxdWVzdBI/Cgdjb250ZXh0GAEgASgLMiUuY3JlYXRpdm'
    'FudGEuY29tbW9uLnYxLkNvbW1hbmRDb250ZXh0Ugdjb250ZXh0EjcKGHN0cmlwZV9wYXltZW50'
    'X21ldGhvZF9pZBgCIAEoCVIVc3RyaXBlUGF5bWVudE1ldGhvZElkEh8KC3NldF9kZWZhdWx0GA'
    'MgASgIUgpzZXREZWZhdWx0EhYKBnJlbW92ZRgEIAEoCFIGcmVtb3Zl');

@$core.Deprecated('Use updatePaymentMethodResponseDescriptor instead')
const UpdatePaymentMethodResponse$json = {
  '1': 'UpdatePaymentMethodResponse',
  '2': [
    {
      '1': 'payment_method',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.admin.v1.PaymentMethodSummary',
      '10': 'paymentMethod'
    },
    {
      '1': 'payment_methods',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.creativanta.admin.v1.PaymentMethodSummary',
      '10': 'paymentMethods'
    },
  ],
};

/// Descriptor for `UpdatePaymentMethodResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updatePaymentMethodResponseDescriptor = $convert.base64Decode(
    'ChtVcGRhdGVQYXltZW50TWV0aG9kUmVzcG9uc2USUQoOcGF5bWVudF9tZXRob2QYASABKAsyKi'
    '5jcmVhdGl2YW50YS5hZG1pbi52MS5QYXltZW50TWV0aG9kU3VtbWFyeVINcGF5bWVudE1ldGhv'
    'ZBJTCg9wYXltZW50X21ldGhvZHMYAiADKAsyKi5jcmVhdGl2YW50YS5hZG1pbi52MS5QYXltZW'
    '50TWV0aG9kU3VtbWFyeVIOcGF5bWVudE1ldGhvZHM=');

@$core.Deprecated('Use getPaymentMethodRequestDescriptor instead')
const GetPaymentMethodRequest$json = {
  '1': 'GetPaymentMethodRequest',
  '2': [
    {
      '1': 'workspace_id',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.UUID',
      '10': 'workspaceId'
    },
  ],
};

/// Descriptor for `GetPaymentMethodRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getPaymentMethodRequestDescriptor =
    $convert.base64Decode(
        'ChdHZXRQYXltZW50TWV0aG9kUmVxdWVzdBI+Cgx3b3Jrc3BhY2VfaWQYASABKAsyGy5jcmVhdG'
        'l2YW50YS5jb21tb24udjEuVVVJRFILd29ya3NwYWNlSWQ=');

@$core.Deprecated('Use getPaymentMethodResponseDescriptor instead')
const GetPaymentMethodResponse$json = {
  '1': 'GetPaymentMethodResponse',
  '2': [
    {
      '1': 'default_payment_method',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.admin.v1.PaymentMethodSummary',
      '10': 'defaultPaymentMethod'
    },
    {
      '1': 'payment_methods',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.creativanta.admin.v1.PaymentMethodSummary',
      '10': 'paymentMethods'
    },
  ],
};

/// Descriptor for `GetPaymentMethodResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getPaymentMethodResponseDescriptor = $convert.base64Decode(
    'ChhHZXRQYXltZW50TWV0aG9kUmVzcG9uc2USYAoWZGVmYXVsdF9wYXltZW50X21ldGhvZBgBIA'
    'EoCzIqLmNyZWF0aXZhbnRhLmFkbWluLnYxLlBheW1lbnRNZXRob2RTdW1tYXJ5UhRkZWZhdWx0'
    'UGF5bWVudE1ldGhvZBJTCg9wYXltZW50X21ldGhvZHMYAiADKAsyKi5jcmVhdGl2YW50YS5hZG'
    '1pbi52MS5QYXltZW50TWV0aG9kU3VtbWFyeVIOcGF5bWVudE1ldGhvZHM=');

@$core.Deprecated('Use estimateCostRequestDescriptor instead')
const EstimateCostRequest$json = {
  '1': 'EstimateCostRequest',
  '2': [
    {
      '1': 'context',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.CommandContext',
      '10': 'context'
    },
    {'1': 'operation_type', '3': 2, '4': 1, '5': 9, '10': 'operationType'},
    {'1': 'provider', '3': 3, '4': 1, '5': 9, '10': 'provider'},
    {'1': 'model_id', '3': 4, '4': 1, '5': 9, '10': 'modelId'},
    {
      '1': 'fallback_provider',
      '3': 5,
      '4': 1,
      '5': 9,
      '10': 'fallbackProvider'
    },
    {'1': 'fallback_model_id', '3': 6, '4': 1, '5': 9, '10': 'fallbackModelId'},
    {
      '1': 'max_provider_attempts',
      '3': 7,
      '4': 1,
      '5': 5,
      '10': 'maxProviderAttempts'
    },
    {
      '1': 'measured_units',
      '3': 8,
      '4': 3,
      '5': 11,
      '6': '.creativanta.admin.v1.EstimateCostRequest.MeasuredUnitsEntry',
      '10': 'measuredUnits'
    },
  ],
  '3': [EstimateCostRequest_MeasuredUnitsEntry$json],
};

@$core.Deprecated('Use estimateCostRequestDescriptor instead')
const EstimateCostRequest_MeasuredUnitsEntry$json = {
  '1': 'MeasuredUnitsEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {'1': 'value', '3': 2, '4': 1, '5': 9, '10': 'value'},
  ],
  '7': {'7': true},
};

/// Descriptor for `EstimateCostRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List estimateCostRequestDescriptor = $convert.base64Decode(
    'ChNFc3RpbWF0ZUNvc3RSZXF1ZXN0Ej8KB2NvbnRleHQYASABKAsyJS5jcmVhdGl2YW50YS5jb2'
    '1tb24udjEuQ29tbWFuZENvbnRleHRSB2NvbnRleHQSJQoOb3BlcmF0aW9uX3R5cGUYAiABKAlS'
    'DW9wZXJhdGlvblR5cGUSGgoIcHJvdmlkZXIYAyABKAlSCHByb3ZpZGVyEhkKCG1vZGVsX2lkGA'
    'QgASgJUgdtb2RlbElkEisKEWZhbGxiYWNrX3Byb3ZpZGVyGAUgASgJUhBmYWxsYmFja1Byb3Zp'
    'ZGVyEioKEWZhbGxiYWNrX21vZGVsX2lkGAYgASgJUg9mYWxsYmFja01vZGVsSWQSMgoVbWF4X3'
    'Byb3ZpZGVyX2F0dGVtcHRzGAcgASgFUhNtYXhQcm92aWRlckF0dGVtcHRzEmMKDm1lYXN1cmVk'
    'X3VuaXRzGAggAygLMjwuY3JlYXRpdmFudGEuYWRtaW4udjEuRXN0aW1hdGVDb3N0UmVxdWVzdC'
    '5NZWFzdXJlZFVuaXRzRW50cnlSDW1lYXN1cmVkVW5pdHMaQAoSTWVhc3VyZWRVbml0c0VudHJ5'
    'EhAKA2tleRgBIAEoCVIDa2V5EhQKBXZhbHVlGAIgASgJUgV2YWx1ZToCOAE=');

@$core.Deprecated('Use estimateCostResponseDescriptor instead')
const EstimateCostResponse$json = {
  '1': 'EstimateCostResponse',
  '2': [
    {
      '1': 'quote',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.admin.v1.CreditQuote',
      '10': 'quote'
    },
    {
      '1': 'current_balance',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.creativanta.admin.v1.CreditBalance',
      '10': 'currentBalance'
    },
    {
      '1': 'sufficient_credits',
      '3': 3,
      '4': 1,
      '5': 8,
      '10': 'sufficientCredits'
    },
  ],
};

/// Descriptor for `EstimateCostResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List estimateCostResponseDescriptor = $convert.base64Decode(
    'ChRFc3RpbWF0ZUNvc3RSZXNwb25zZRI3CgVxdW90ZRgBIAEoCzIhLmNyZWF0aXZhbnRhLmFkbW'
    'luLnYxLkNyZWRpdFF1b3RlUgVxdW90ZRJMCg9jdXJyZW50X2JhbGFuY2UYAiABKAsyIy5jcmVh'
    'dGl2YW50YS5hZG1pbi52MS5DcmVkaXRCYWxhbmNlUg5jdXJyZW50QmFsYW5jZRItChJzdWZmaW'
    'NpZW50X2NyZWRpdHMYAyABKAhSEXN1ZmZpY2llbnRDcmVkaXRz');

@$core.Deprecated('Use getBalanceRequestDescriptor instead')
const GetBalanceRequest$json = {
  '1': 'GetBalanceRequest',
  '2': [
    {
      '1': 'workspace_id',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.UUID',
      '10': 'workspaceId'
    },
  ],
};

/// Descriptor for `GetBalanceRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getBalanceRequestDescriptor = $convert.base64Decode(
    'ChFHZXRCYWxhbmNlUmVxdWVzdBI+Cgx3b3Jrc3BhY2VfaWQYASABKAsyGy5jcmVhdGl2YW50YS'
    '5jb21tb24udjEuVVVJRFILd29ya3NwYWNlSWQ=');

@$core.Deprecated('Use getBalanceResponseDescriptor instead')
const GetBalanceResponse$json = {
  '1': 'GetBalanceResponse',
  '2': [
    {
      '1': 'balance',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.admin.v1.CreditBalance',
      '10': 'balance'
    },
  ],
};

/// Descriptor for `GetBalanceResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getBalanceResponseDescriptor = $convert.base64Decode(
    'ChJHZXRCYWxhbmNlUmVzcG9uc2USPQoHYmFsYW5jZRgBIAEoCzIjLmNyZWF0aXZhbnRhLmFkbW'
    'luLnYxLkNyZWRpdEJhbGFuY2VSB2JhbGFuY2U=');

@$core.Deprecated('Use getUsageStatsRequestDescriptor instead')
const GetUsageStatsRequest$json = {
  '1': 'GetUsageStatsRequest',
  '2': [
    {
      '1': 'workspace_id',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.UUID',
      '10': 'workspaceId'
    },
  ],
};

/// Descriptor for `GetUsageStatsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getUsageStatsRequestDescriptor = $convert.base64Decode(
    'ChRHZXRVc2FnZVN0YXRzUmVxdWVzdBI+Cgx3b3Jrc3BhY2VfaWQYASABKAsyGy5jcmVhdGl2YW'
    '50YS5jb21tb24udjEuVVVJRFILd29ya3NwYWNlSWQ=');

@$core.Deprecated('Use getUsageStatsResponseDescriptor instead')
const GetUsageStatsResponse$json = {
  '1': 'GetUsageStatsResponse',
  '2': [
    {
      '1': 'credits_used_this_period',
      '3': 1,
      '4': 1,
      '5': 9,
      '10': 'creditsUsedThisPeriod'
    },
    {
      '1': 'credits_remaining',
      '3': 2,
      '4': 1,
      '5': 9,
      '10': 'creditsRemaining'
    },
    {
      '1': 'breakdown',
      '3': 3,
      '4': 3,
      '5': 11,
      '6': '.creativanta.admin.v1.OperationUsageBreakdown',
      '10': 'breakdown'
    },
  ],
};

/// Descriptor for `GetUsageStatsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getUsageStatsResponseDescriptor = $convert.base64Decode(
    'ChVHZXRVc2FnZVN0YXRzUmVzcG9uc2USNwoYY3JlZGl0c191c2VkX3RoaXNfcGVyaW9kGAEgAS'
    'gJUhVjcmVkaXRzVXNlZFRoaXNQZXJpb2QSKwoRY3JlZGl0c19yZW1haW5pbmcYAiABKAlSEGNy'
    'ZWRpdHNSZW1haW5pbmcSSwoJYnJlYWtkb3duGAMgAygLMi0uY3JlYXRpdmFudGEuYWRtaW4udj'
    'EuT3BlcmF0aW9uVXNhZ2VCcmVha2Rvd25SCWJyZWFrZG93bg==');

@$core.Deprecated('Use getMonthlyUsageRequestDescriptor instead')
const GetMonthlyUsageRequest$json = {
  '1': 'GetMonthlyUsageRequest',
  '2': [
    {
      '1': 'workspace_id',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.UUID',
      '10': 'workspaceId'
    },
    {'1': 'year_month', '3': 2, '4': 1, '5': 9, '10': 'yearMonth'},
  ],
};

/// Descriptor for `GetMonthlyUsageRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getMonthlyUsageRequestDescriptor = $convert.base64Decode(
    'ChZHZXRNb250aGx5VXNhZ2VSZXF1ZXN0Ej4KDHdvcmtzcGFjZV9pZBgBIAEoCzIbLmNyZWF0aX'
    'ZhbnRhLmNvbW1vbi52MS5VVUlEUgt3b3Jrc3BhY2VJZBIdCgp5ZWFyX21vbnRoGAIgASgJUgl5'
    'ZWFyTW9udGg=');

@$core.Deprecated('Use getMonthlyUsageResponseDescriptor instead')
const GetMonthlyUsageResponse$json = {
  '1': 'GetMonthlyUsageResponse',
  '2': [
    {'1': 'year_month', '3': 1, '4': 1, '5': 9, '10': 'yearMonth'},
    {
      '1': 'total_credits_used',
      '3': 2,
      '4': 1,
      '5': 9,
      '10': 'totalCreditsUsed'
    },
    {
      '1': 'breakdown',
      '3': 3,
      '4': 3,
      '5': 11,
      '6': '.creativanta.admin.v1.OperationUsageBreakdown',
      '10': 'breakdown'
    },
  ],
};

/// Descriptor for `GetMonthlyUsageResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getMonthlyUsageResponseDescriptor = $convert.base64Decode(
    'ChdHZXRNb250aGx5VXNhZ2VSZXNwb25zZRIdCgp5ZWFyX21vbnRoGAEgASgJUgl5ZWFyTW9udG'
    'gSLAoSdG90YWxfY3JlZGl0c191c2VkGAIgASgJUhB0b3RhbENyZWRpdHNVc2VkEksKCWJyZWFr'
    'ZG93bhgDIAMoCzItLmNyZWF0aXZhbnRhLmFkbWluLnYxLk9wZXJhdGlvblVzYWdlQnJlYWtkb3'
    'duUglicmVha2Rvd24=');

@$core.Deprecated('Use listTransactionsRequestDescriptor instead')
const ListTransactionsRequest$json = {
  '1': 'ListTransactionsRequest',
  '2': [
    {
      '1': 'workspace_id',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.UUID',
      '10': 'workspaceId'
    },
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

/// Descriptor for `ListTransactionsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listTransactionsRequestDescriptor = $convert.base64Decode(
    'ChdMaXN0VHJhbnNhY3Rpb25zUmVxdWVzdBI+Cgx3b3Jrc3BhY2VfaWQYASABKAsyGy5jcmVhdG'
    'l2YW50YS5jb21tb24udjEuVVVJRFILd29ya3NwYWNlSWQSQQoKcGFnaW5hdGlvbhgCIAEoCzIh'
    'LmNyZWF0aXZhbnRhLmNvbW1vbi52MS5QYWdpbmF0aW9uUgpwYWdpbmF0aW9u');

@$core.Deprecated('Use listTransactionsResponseDescriptor instead')
const ListTransactionsResponse$json = {
  '1': 'ListTransactionsResponse',
  '2': [
    {
      '1': 'transactions',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.creativanta.admin.v1.CreditTransactionEntry',
      '10': 'transactions'
    },
    {
      '1': 'page_info',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.PaginatedResponse',
      '10': 'pageInfo'
    },
  ],
};

/// Descriptor for `ListTransactionsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listTransactionsResponseDescriptor = $convert.base64Decode(
    'ChhMaXN0VHJhbnNhY3Rpb25zUmVzcG9uc2USUAoMdHJhbnNhY3Rpb25zGAEgAygLMiwuY3JlYX'
    'RpdmFudGEuYWRtaW4udjEuQ3JlZGl0VHJhbnNhY3Rpb25FbnRyeVIMdHJhbnNhY3Rpb25zEkUK'
    'CXBhZ2VfaW5mbxgCIAEoCzIoLmNyZWF0aXZhbnRhLmNvbW1vbi52MS5QYWdpbmF0ZWRSZXNwb2'
    '5zZVIIcGFnZUluZm8=');

@$core.Deprecated('Use listRecentUsageRequestDescriptor instead')
const ListRecentUsageRequest$json = {
  '1': 'ListRecentUsageRequest',
  '2': [
    {
      '1': 'workspace_id',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.UUID',
      '10': 'workspaceId'
    },
    {'1': 'limit', '3': 2, '4': 1, '5': 5, '10': 'limit'},
  ],
};

/// Descriptor for `ListRecentUsageRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listRecentUsageRequestDescriptor = $convert.base64Decode(
    'ChZMaXN0UmVjZW50VXNhZ2VSZXF1ZXN0Ej4KDHdvcmtzcGFjZV9pZBgBIAEoCzIbLmNyZWF0aX'
    'ZhbnRhLmNvbW1vbi52MS5VVUlEUgt3b3Jrc3BhY2VJZBIUCgVsaW1pdBgCIAEoBVIFbGltaXQ=');

@$core.Deprecated('Use listRecentUsageResponseDescriptor instead')
const ListRecentUsageResponse$json = {
  '1': 'ListRecentUsageResponse',
  '2': [
    {
      '1': 'usage_entries',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.creativanta.admin.v1.CreditTransactionEntry',
      '10': 'usageEntries'
    },
  ],
};

/// Descriptor for `ListRecentUsageResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listRecentUsageResponseDescriptor = $convert.base64Decode(
    'ChdMaXN0UmVjZW50VXNhZ2VSZXNwb25zZRJRCg11c2FnZV9lbnRyaWVzGAEgAygLMiwuY3JlYX'
    'RpdmFudGEuYWRtaW4udjEuQ3JlZGl0VHJhbnNhY3Rpb25FbnRyeVIMdXNhZ2VFbnRyaWVz');

@$core.Deprecated('Use listPackagesRequestDescriptor instead')
const ListPackagesRequest$json = {
  '1': 'ListPackagesRequest',
  '2': [
    {'1': 'currency', '3': 1, '4': 1, '5': 9, '10': 'currency'},
  ],
};

/// Descriptor for `ListPackagesRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listPackagesRequestDescriptor =
    $convert.base64Decode(
        'ChNMaXN0UGFja2FnZXNSZXF1ZXN0EhoKCGN1cnJlbmN5GAEgASgJUghjdXJyZW5jeQ==');

@$core.Deprecated('Use listPackagesResponseDescriptor instead')
const ListPackagesResponse$json = {
  '1': 'ListPackagesResponse',
  '2': [
    {
      '1': 'packages',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.creativanta.admin.v1.CreditPackEntry',
      '10': 'packages'
    },
    {
      '1': 'pricebook_version',
      '3': 2,
      '4': 1,
      '5': 9,
      '10': 'pricebookVersion'
    },
  ],
};

/// Descriptor for `ListPackagesResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listPackagesResponseDescriptor = $convert.base64Decode(
    'ChRMaXN0UGFja2FnZXNSZXNwb25zZRJBCghwYWNrYWdlcxgBIAMoCzIlLmNyZWF0aXZhbnRhLm'
    'FkbWluLnYxLkNyZWRpdFBhY2tFbnRyeVIIcGFja2FnZXMSKwoRcHJpY2Vib29rX3ZlcnNpb24Y'
    'AiABKAlSEHByaWNlYm9va1ZlcnNpb24=');

@$core.Deprecated('Use purchaseRequestDescriptor instead')
const PurchaseRequest$json = {
  '1': 'PurchaseRequest',
  '2': [
    {
      '1': 'context',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.CommandContext',
      '10': 'context'
    },
    {'1': 'pack_code', '3': 2, '4': 1, '5': 9, '10': 'packCode'},
    {'1': 'currency', '3': 3, '4': 1, '5': 9, '10': 'currency'},
    {'1': 'success_url', '3': 4, '4': 1, '5': 9, '10': 'successUrl'},
    {'1': 'cancel_url', '3': 5, '4': 1, '5': 9, '10': 'cancelUrl'},
  ],
};

/// Descriptor for `PurchaseRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List purchaseRequestDescriptor = $convert.base64Decode(
    'Cg9QdXJjaGFzZVJlcXVlc3QSPwoHY29udGV4dBgBIAEoCzIlLmNyZWF0aXZhbnRhLmNvbW1vbi'
    '52MS5Db21tYW5kQ29udGV4dFIHY29udGV4dBIbCglwYWNrX2NvZGUYAiABKAlSCHBhY2tDb2Rl'
    'EhoKCGN1cnJlbmN5GAMgASgJUghjdXJyZW5jeRIfCgtzdWNjZXNzX3VybBgEIAEoCVIKc3VjY2'
    'Vzc1VybBIdCgpjYW5jZWxfdXJsGAUgASgJUgljYW5jZWxVcmw=');

@$core.Deprecated('Use purchaseResponseDescriptor instead')
const PurchaseResponse$json = {
  '1': 'PurchaseResponse',
  '2': [
    {
      '1': 'checkout_session_id',
      '3': 1,
      '4': 1,
      '5': 9,
      '10': 'checkoutSessionId'
    },
    {'1': 'checkout_url', '3': 2, '4': 1, '5': 9, '10': 'checkoutUrl'},
    {'1': 'status', '3': 3, '4': 1, '5': 9, '10': 'status'},
    {
      '1': 'pack',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.creativanta.admin.v1.CreditPackEntry',
      '10': 'pack'
    },
  ],
};

/// Descriptor for `PurchaseResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List purchaseResponseDescriptor = $convert.base64Decode(
    'ChBQdXJjaGFzZVJlc3BvbnNlEi4KE2NoZWNrb3V0X3Nlc3Npb25faWQYASABKAlSEWNoZWNrb3'
    'V0U2Vzc2lvbklkEiEKDGNoZWNrb3V0X3VybBgCIAEoCVILY2hlY2tvdXRVcmwSFgoGc3RhdHVz'
    'GAMgASgJUgZzdGF0dXMSOQoEcGFjaxgEIAEoCzIlLmNyZWF0aXZhbnRhLmFkbWluLnYxLkNyZW'
    'RpdFBhY2tFbnRyeVIEcGFjaw==');

@$core.Deprecated('Use getAutoRefillConfigRequestDescriptor instead')
const GetAutoRefillConfigRequest$json = {
  '1': 'GetAutoRefillConfigRequest',
  '2': [
    {
      '1': 'workspace_id',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.UUID',
      '10': 'workspaceId'
    },
  ],
};

/// Descriptor for `GetAutoRefillConfigRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getAutoRefillConfigRequestDescriptor =
    $convert.base64Decode(
        'ChpHZXRBdXRvUmVmaWxsQ29uZmlnUmVxdWVzdBI+Cgx3b3Jrc3BhY2VfaWQYASABKAsyGy5jcm'
        'VhdGl2YW50YS5jb21tb24udjEuVVVJRFILd29ya3NwYWNlSWQ=');

@$core.Deprecated('Use getAutoRefillConfigResponseDescriptor instead')
const GetAutoRefillConfigResponse$json = {
  '1': 'GetAutoRefillConfigResponse',
  '2': [
    {
      '1': 'config',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.admin.v1.AutoRefillConfig',
      '10': 'config'
    },
  ],
};

/// Descriptor for `GetAutoRefillConfigResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getAutoRefillConfigResponseDescriptor =
    $convert.base64Decode(
        'ChtHZXRBdXRvUmVmaWxsQ29uZmlnUmVzcG9uc2USPgoGY29uZmlnGAEgASgLMiYuY3JlYXRpdm'
        'FudGEuYWRtaW4udjEuQXV0b1JlZmlsbENvbmZpZ1IGY29uZmln');

@$core.Deprecated('Use updateAutoRefillRequestDescriptor instead')
const UpdateAutoRefillRequest$json = {
  '1': 'UpdateAutoRefillRequest',
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
      '1': 'config',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.creativanta.admin.v1.AutoRefillConfig',
      '10': 'config'
    },
  ],
};

/// Descriptor for `UpdateAutoRefillRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateAutoRefillRequestDescriptor = $convert.base64Decode(
    'ChdVcGRhdGVBdXRvUmVmaWxsUmVxdWVzdBI/Cgdjb250ZXh0GAEgASgLMiUuY3JlYXRpdmFudG'
    'EuY29tbW9uLnYxLkNvbW1hbmRDb250ZXh0Ugdjb250ZXh0Ej4KBmNvbmZpZxgCIAEoCzImLmNy'
    'ZWF0aXZhbnRhLmFkbWluLnYxLkF1dG9SZWZpbGxDb25maWdSBmNvbmZpZw==');

@$core.Deprecated('Use updateAutoRefillResponseDescriptor instead')
const UpdateAutoRefillResponse$json = {
  '1': 'UpdateAutoRefillResponse',
  '2': [
    {
      '1': 'config',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.admin.v1.AutoRefillConfig',
      '10': 'config'
    },
  ],
};

/// Descriptor for `UpdateAutoRefillResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateAutoRefillResponseDescriptor =
    $convert.base64Decode(
        'ChhVcGRhdGVBdXRvUmVmaWxsUmVzcG9uc2USPgoGY29uZmlnGAEgASgLMiYuY3JlYXRpdmFudG'
        'EuYWRtaW4udjEuQXV0b1JlZmlsbENvbmZpZ1IGY29uZmln');

@$core.Deprecated('Use getCurrentPlanRequestDescriptor instead')
const GetCurrentPlanRequest$json = {
  '1': 'GetCurrentPlanRequest',
  '2': [
    {
      '1': 'workspace_id',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.UUID',
      '10': 'workspaceId'
    },
  ],
};

/// Descriptor for `GetCurrentPlanRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getCurrentPlanRequestDescriptor = $convert.base64Decode(
    'ChVHZXRDdXJyZW50UGxhblJlcXVlc3QSPgoMd29ya3NwYWNlX2lkGAEgASgLMhsuY3JlYXRpdm'
    'FudGEuY29tbW9uLnYxLlVVSURSC3dvcmtzcGFjZUlk');

@$core.Deprecated('Use getCurrentPlanResponseDescriptor instead')
const GetCurrentPlanResponse$json = {
  '1': 'GetCurrentPlanResponse',
  '2': [
    {
      '1': 'current_plan',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.admin.v1.PlanCatalogEntry',
      '10': 'currentPlan'
    },
    {
      '1': 'subscription',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.creativanta.admin.v1.SubscriptionSummary',
      '10': 'subscription'
    },
  ],
};

/// Descriptor for `GetCurrentPlanResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getCurrentPlanResponseDescriptor = $convert.base64Decode(
    'ChZHZXRDdXJyZW50UGxhblJlc3BvbnNlEkkKDGN1cnJlbnRfcGxhbhgBIAEoCzImLmNyZWF0aX'
    'ZhbnRhLmFkbWluLnYxLlBsYW5DYXRhbG9nRW50cnlSC2N1cnJlbnRQbGFuEk0KDHN1YnNjcmlw'
    'dGlvbhgCIAEoCzIpLmNyZWF0aXZhbnRhLmFkbWluLnYxLlN1YnNjcmlwdGlvblN1bW1hcnlSDH'
    'N1YnNjcmlwdGlvbg==');

@$core.Deprecated('Use listPlansRequestDescriptor instead')
const ListPlansRequest$json = {
  '1': 'ListPlansRequest',
  '2': [
    {'1': 'currency', '3': 1, '4': 1, '5': 9, '10': 'currency'},
  ],
};

/// Descriptor for `ListPlansRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listPlansRequestDescriptor = $convert.base64Decode(
    'ChBMaXN0UGxhbnNSZXF1ZXN0EhoKCGN1cnJlbmN5GAEgASgJUghjdXJyZW5jeQ==');

@$core.Deprecated('Use listPlansResponseDescriptor instead')
const ListPlansResponse$json = {
  '1': 'ListPlansResponse',
  '2': [
    {
      '1': 'plans',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.creativanta.admin.v1.PlanCatalogEntry',
      '10': 'plans'
    },
    {
      '1': 'addons',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.creativanta.admin.v1.AddonCatalogEntry',
      '10': 'addons'
    },
    {
      '1': 'pricebook_version',
      '3': 3,
      '4': 1,
      '5': 9,
      '10': 'pricebookVersion'
    },
  ],
};

/// Descriptor for `ListPlansResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listPlansResponseDescriptor = $convert.base64Decode(
    'ChFMaXN0UGxhbnNSZXNwb25zZRI8CgVwbGFucxgBIAMoCzImLmNyZWF0aXZhbnRhLmFkbWluLn'
    'YxLlBsYW5DYXRhbG9nRW50cnlSBXBsYW5zEj8KBmFkZG9ucxgCIAMoCzInLmNyZWF0aXZhbnRh'
    'LmFkbWluLnYxLkFkZG9uQ2F0YWxvZ0VudHJ5UgZhZGRvbnMSKwoRcHJpY2Vib29rX3ZlcnNpb2'
    '4YAyABKAlSEHByaWNlYm9va1ZlcnNpb24=');

@$core.Deprecated('Use getSubscriptionRequestDescriptor instead')
const GetSubscriptionRequest$json = {
  '1': 'GetSubscriptionRequest',
  '2': [
    {
      '1': 'workspace_id',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.UUID',
      '10': 'workspaceId'
    },
  ],
};

/// Descriptor for `GetSubscriptionRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getSubscriptionRequestDescriptor =
    $convert.base64Decode(
        'ChZHZXRTdWJzY3JpcHRpb25SZXF1ZXN0Ej4KDHdvcmtzcGFjZV9pZBgBIAEoCzIbLmNyZWF0aX'
        'ZhbnRhLmNvbW1vbi52MS5VVUlEUgt3b3Jrc3BhY2VJZA==');

@$core.Deprecated('Use getSubscriptionResponseDescriptor instead')
const GetSubscriptionResponse$json = {
  '1': 'GetSubscriptionResponse',
  '2': [
    {
      '1': 'subscription',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.admin.v1.SubscriptionSummary',
      '10': 'subscription'
    },
  ],
};

/// Descriptor for `GetSubscriptionResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getSubscriptionResponseDescriptor =
    $convert.base64Decode(
        'ChdHZXRTdWJzY3JpcHRpb25SZXNwb25zZRJNCgxzdWJzY3JpcHRpb24YASABKAsyKS5jcmVhdG'
        'l2YW50YS5hZG1pbi52MS5TdWJzY3JpcHRpb25TdW1tYXJ5UgxzdWJzY3JpcHRpb24=');

@$core.Deprecated('Use getPaymentMethodsRequestDescriptor instead')
const GetPaymentMethodsRequest$json = {
  '1': 'GetPaymentMethodsRequest',
  '2': [
    {
      '1': 'workspace_id',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.UUID',
      '10': 'workspaceId'
    },
  ],
};

/// Descriptor for `GetPaymentMethodsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getPaymentMethodsRequestDescriptor =
    $convert.base64Decode(
        'ChhHZXRQYXltZW50TWV0aG9kc1JlcXVlc3QSPgoMd29ya3NwYWNlX2lkGAEgASgLMhsuY3JlYX'
        'RpdmFudGEuY29tbW9uLnYxLlVVSURSC3dvcmtzcGFjZUlk');

@$core.Deprecated('Use getPaymentMethodsResponseDescriptor instead')
const GetPaymentMethodsResponse$json = {
  '1': 'GetPaymentMethodsResponse',
  '2': [
    {
      '1': 'payment_methods',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.creativanta.admin.v1.PaymentMethodSummary',
      '10': 'paymentMethods'
    },
  ],
};

/// Descriptor for `GetPaymentMethodsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getPaymentMethodsResponseDescriptor = $convert.base64Decode(
    'ChlHZXRQYXltZW50TWV0aG9kc1Jlc3BvbnNlElMKD3BheW1lbnRfbWV0aG9kcxgBIAMoCzIqLm'
    'NyZWF0aXZhbnRhLmFkbWluLnYxLlBheW1lbnRNZXRob2RTdW1tYXJ5Ug5wYXltZW50TWV0aG9k'
    'cw==');

@$core.Deprecated('Use cancelPlanRequestDescriptor instead')
const CancelPlanRequest$json = {
  '1': 'CancelPlanRequest',
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
      '1': 'cancellation_reason',
      '3': 2,
      '4': 1,
      '5': 9,
      '10': 'cancellationReason'
    },
    {'1': 'pause_instead', '3': 3, '4': 1, '5': 8, '10': 'pauseInstead'},
    {'1': 'pause_months', '3': 4, '4': 1, '5': 5, '10': 'pauseMonths'},
  ],
};

/// Descriptor for `CancelPlanRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List cancelPlanRequestDescriptor = $convert.base64Decode(
    'ChFDYW5jZWxQbGFuUmVxdWVzdBI/Cgdjb250ZXh0GAEgASgLMiUuY3JlYXRpdmFudGEuY29tbW'
    '9uLnYxLkNvbW1hbmRDb250ZXh0Ugdjb250ZXh0Ei8KE2NhbmNlbGxhdGlvbl9yZWFzb24YAiAB'
    'KAlSEmNhbmNlbGxhdGlvblJlYXNvbhIjCg1wYXVzZV9pbnN0ZWFkGAMgASgIUgxwYXVzZUluc3'
    'RlYWQSIQoMcGF1c2VfbW9udGhzGAQgASgFUgtwYXVzZU1vbnRocw==');

@$core.Deprecated('Use cancelPlanResponseDescriptor instead')
const CancelPlanResponse$json = {
  '1': 'CancelPlanResponse',
  '2': [
    {
      '1': 'subscription',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.admin.v1.SubscriptionSummary',
      '10': 'subscription'
    },
  ],
};

/// Descriptor for `CancelPlanResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List cancelPlanResponseDescriptor = $convert.base64Decode(
    'ChJDYW5jZWxQbGFuUmVzcG9uc2USTQoMc3Vic2NyaXB0aW9uGAEgASgLMikuY3JlYXRpdmFudG'
    'EuYWRtaW4udjEuU3Vic2NyaXB0aW9uU3VtbWFyeVIMc3Vic2NyaXB0aW9u');

@$core.Deprecated('Use listInvoicesRequestDescriptor instead')
const ListInvoicesRequest$json = {
  '1': 'ListInvoicesRequest',
  '2': [
    {
      '1': 'workspace_id',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.UUID',
      '10': 'workspaceId'
    },
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

/// Descriptor for `ListInvoicesRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listInvoicesRequestDescriptor = $convert.base64Decode(
    'ChNMaXN0SW52b2ljZXNSZXF1ZXN0Ej4KDHdvcmtzcGFjZV9pZBgBIAEoCzIbLmNyZWF0aXZhbn'
    'RhLmNvbW1vbi52MS5VVUlEUgt3b3Jrc3BhY2VJZBJBCgpwYWdpbmF0aW9uGAIgASgLMiEuY3Jl'
    'YXRpdmFudGEuY29tbW9uLnYxLlBhZ2luYXRpb25SCnBhZ2luYXRpb24=');

@$core.Deprecated('Use listInvoicesResponseDescriptor instead')
const ListInvoicesResponse$json = {
  '1': 'ListInvoicesResponse',
  '2': [
    {
      '1': 'invoices',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.creativanta.admin.v1.InvoiceSummary',
      '10': 'invoices'
    },
    {
      '1': 'page_info',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.PaginatedResponse',
      '10': 'pageInfo'
    },
  ],
};

/// Descriptor for `ListInvoicesResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listInvoicesResponseDescriptor = $convert.base64Decode(
    'ChRMaXN0SW52b2ljZXNSZXNwb25zZRJACghpbnZvaWNlcxgBIAMoCzIkLmNyZWF0aXZhbnRhLm'
    'FkbWluLnYxLkludm9pY2VTdW1tYXJ5UghpbnZvaWNlcxJFCglwYWdlX2luZm8YAiABKAsyKC5j'
    'cmVhdGl2YW50YS5jb21tb24udjEuUGFnaW5hdGVkUmVzcG9uc2VSCHBhZ2VJbmZv');

@$core.Deprecated('Use getInvoiceUrlRequestDescriptor instead')
const GetInvoiceUrlRequest$json = {
  '1': 'GetInvoiceUrlRequest',
  '2': [
    {
      '1': 'workspace_id',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.UUID',
      '10': 'workspaceId'
    },
    {
      '1': 'invoice_id',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.UUID',
      '10': 'invoiceId'
    },
  ],
};

/// Descriptor for `GetInvoiceUrlRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getInvoiceUrlRequestDescriptor = $convert.base64Decode(
    'ChRHZXRJbnZvaWNlVXJsUmVxdWVzdBI+Cgx3b3Jrc3BhY2VfaWQYASABKAsyGy5jcmVhdGl2YW'
    '50YS5jb21tb24udjEuVVVJRFILd29ya3NwYWNlSWQSOgoKaW52b2ljZV9pZBgCIAEoCzIbLmNy'
    'ZWF0aXZhbnRhLmNvbW1vbi52MS5VVUlEUglpbnZvaWNlSWQ=');

@$core.Deprecated('Use getInvoiceUrlResponseDescriptor instead')
const GetInvoiceUrlResponse$json = {
  '1': 'GetInvoiceUrlResponse',
  '2': [
    {'1': 'invoice_pdf_url', '3': 1, '4': 1, '5': 9, '10': 'invoicePdfUrl'},
    {
      '1': 'hosted_invoice_url',
      '3': 2,
      '4': 1,
      '5': 9,
      '10': 'hostedInvoiceUrl'
    },
  ],
};

/// Descriptor for `GetInvoiceUrlResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getInvoiceUrlResponseDescriptor = $convert.base64Decode(
    'ChVHZXRJbnZvaWNlVXJsUmVzcG9uc2USJgoPaW52b2ljZV9wZGZfdXJsGAEgASgJUg1pbnZvaW'
    'NlUGRmVXJsEiwKEmhvc3RlZF9pbnZvaWNlX3VybBgCIAEoCVIQaG9zdGVkSW52b2ljZVVybA==');

@$core.Deprecated('Use getCheckoutStatusRequestDescriptor instead')
const GetCheckoutStatusRequest$json = {
  '1': 'GetCheckoutStatusRequest',
  '2': [
    {
      '1': 'workspace_id',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.UUID',
      '10': 'workspaceId'
    },
    {
      '1': 'checkout_session_id',
      '3': 2,
      '4': 1,
      '5': 9,
      '10': 'checkoutSessionId'
    },
  ],
};

/// Descriptor for `GetCheckoutStatusRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getCheckoutStatusRequestDescriptor = $convert.base64Decode(
    'ChhHZXRDaGVja291dFN0YXR1c1JlcXVlc3QSPgoMd29ya3NwYWNlX2lkGAEgASgLMhsuY3JlYX'
    'RpdmFudGEuY29tbW9uLnYxLlVVSURSC3dvcmtzcGFjZUlkEi4KE2NoZWNrb3V0X3Nlc3Npb25f'
    'aWQYAiABKAlSEWNoZWNrb3V0U2Vzc2lvbklk');

@$core.Deprecated('Use getCheckoutStatusResponseDescriptor instead')
const GetCheckoutStatusResponse$json = {
  '1': 'GetCheckoutStatusResponse',
  '2': [
    {
      '1': 'checkout_session_id',
      '3': 1,
      '4': 1,
      '5': 9,
      '10': 'checkoutSessionId'
    },
    {'1': 'status', '3': 2, '4': 1, '5': 9, '10': 'status'},
    {'1': 'settled', '3': 3, '4': 1, '5': 8, '10': 'settled'},
    {
      '1': 'balance',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.creativanta.admin.v1.CreditBalance',
      '10': 'balance'
    },
  ],
};

/// Descriptor for `GetCheckoutStatusResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getCheckoutStatusResponseDescriptor = $convert.base64Decode(
    'ChlHZXRDaGVja291dFN0YXR1c1Jlc3BvbnNlEi4KE2NoZWNrb3V0X3Nlc3Npb25faWQYASABKA'
    'lSEWNoZWNrb3V0U2Vzc2lvbklkEhYKBnN0YXR1cxgCIAEoCVIGc3RhdHVzEhgKB3NldHRsZWQY'
    'AyABKAhSB3NldHRsZWQSPQoHYmFsYW5jZRgEIAEoCzIjLmNyZWF0aXZhbnRhLmFkbWluLnYxLk'
    'NyZWRpdEJhbGFuY2VSB2JhbGFuY2U=');

@$core.Deprecated('Use listCreditPackagesRequestDescriptor instead')
const ListCreditPackagesRequest$json = {
  '1': 'ListCreditPackagesRequest',
  '2': [
    {'1': 'currency', '3': 1, '4': 1, '5': 9, '10': 'currency'},
  ],
};

/// Descriptor for `ListCreditPackagesRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listCreditPackagesRequestDescriptor =
    $convert.base64Decode(
        'ChlMaXN0Q3JlZGl0UGFja2FnZXNSZXF1ZXN0EhoKCGN1cnJlbmN5GAEgASgJUghjdXJyZW5jeQ'
        '==');

@$core.Deprecated('Use listCreditPackagesResponseDescriptor instead')
const ListCreditPackagesResponse$json = {
  '1': 'ListCreditPackagesResponse',
  '2': [
    {
      '1': 'packages',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.creativanta.admin.v1.CreditPackEntry',
      '10': 'packages'
    },
    {
      '1': 'pricebook_version',
      '3': 2,
      '4': 1,
      '5': 9,
      '10': 'pricebookVersion'
    },
  ],
};

/// Descriptor for `ListCreditPackagesResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listCreditPackagesResponseDescriptor =
    $convert.base64Decode(
        'ChpMaXN0Q3JlZGl0UGFja2FnZXNSZXNwb25zZRJBCghwYWNrYWdlcxgBIAMoCzIlLmNyZWF0aX'
        'ZhbnRhLmFkbWluLnYxLkNyZWRpdFBhY2tFbnRyeVIIcGFja2FnZXMSKwoRcHJpY2Vib29rX3Zl'
        'cnNpb24YAiABKAlSEHByaWNlYm9va1ZlcnNpb24=');

@$core.Deprecated('Use listCreditPurchasesRequestDescriptor instead')
const ListCreditPurchasesRequest$json = {
  '1': 'ListCreditPurchasesRequest',
  '2': [
    {
      '1': 'workspace_id',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.UUID',
      '10': 'workspaceId'
    },
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

/// Descriptor for `ListCreditPurchasesRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listCreditPurchasesRequestDescriptor =
    $convert.base64Decode(
        'ChpMaXN0Q3JlZGl0UHVyY2hhc2VzUmVxdWVzdBI+Cgx3b3Jrc3BhY2VfaWQYASABKAsyGy5jcm'
        'VhdGl2YW50YS5jb21tb24udjEuVVVJRFILd29ya3NwYWNlSWQSQQoKcGFnaW5hdGlvbhgCIAEo'
        'CzIhLmNyZWF0aXZhbnRhLmNvbW1vbi52MS5QYWdpbmF0aW9uUgpwYWdpbmF0aW9u');

@$core.Deprecated('Use listCreditPurchasesResponseDescriptor instead')
const ListCreditPurchasesResponse$json = {
  '1': 'ListCreditPurchasesResponse',
  '2': [
    {
      '1': 'purchases',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.creativanta.admin.v1.CreditTransactionEntry',
      '10': 'purchases'
    },
    {
      '1': 'page_info',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.PaginatedResponse',
      '10': 'pageInfo'
    },
  ],
};

/// Descriptor for `ListCreditPurchasesResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listCreditPurchasesResponseDescriptor = $convert.base64Decode(
    'ChtMaXN0Q3JlZGl0UHVyY2hhc2VzUmVzcG9uc2USSgoJcHVyY2hhc2VzGAEgAygLMiwuY3JlYX'
    'RpdmFudGEuYWRtaW4udjEuQ3JlZGl0VHJhbnNhY3Rpb25FbnRyeVIJcHVyY2hhc2VzEkUKCXBh'
    'Z2VfaW5mbxgCIAEoCzIoLmNyZWF0aXZhbnRhLmNvbW1vbi52MS5QYWdpbmF0ZWRSZXNwb25zZV'
    'IIcGFnZUluZm8=');

@$core.Deprecated('Use applyRetentionDiscountRequestDescriptor instead')
const ApplyRetentionDiscountRequest$json = {
  '1': 'ApplyRetentionDiscountRequest',
  '2': [
    {
      '1': 'context',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.CommandContext',
      '10': 'context'
    },
    {'1': 'reason_code', '3': 2, '4': 1, '5': 9, '10': 'reasonCode'},
  ],
};

/// Descriptor for `ApplyRetentionDiscountRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List applyRetentionDiscountRequestDescriptor =
    $convert.base64Decode(
        'Ch1BcHBseVJldGVudGlvbkRpc2NvdW50UmVxdWVzdBI/Cgdjb250ZXh0GAEgASgLMiUuY3JlYX'
        'RpdmFudGEuY29tbW9uLnYxLkNvbW1hbmRDb250ZXh0Ugdjb250ZXh0Eh8KC3JlYXNvbl9jb2Rl'
        'GAIgASgJUgpyZWFzb25Db2Rl');

@$core.Deprecated('Use applyRetentionDiscountResponseDescriptor instead')
const ApplyRetentionDiscountResponse$json = {
  '1': 'ApplyRetentionDiscountResponse',
  '2': [
    {
      '1': 'subscription',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.admin.v1.SubscriptionSummary',
      '10': 'subscription'
    },
    {'1': 'discount_percent', '3': 2, '4': 1, '5': 9, '10': 'discountPercent'},
    {'1': 'duration_months', '3': 3, '4': 1, '5': 5, '10': 'durationMonths'},
  ],
};

/// Descriptor for `ApplyRetentionDiscountResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List applyRetentionDiscountResponseDescriptor =
    $convert.base64Decode(
        'Ch5BcHBseVJldGVudGlvbkRpc2NvdW50UmVzcG9uc2USTQoMc3Vic2NyaXB0aW9uGAEgASgLMi'
        'kuY3JlYXRpdmFudGEuYWRtaW4udjEuU3Vic2NyaXB0aW9uU3VtbWFyeVIMc3Vic2NyaXB0aW9u'
        'EikKEGRpc2NvdW50X3BlcmNlbnQYAiABKAlSD2Rpc2NvdW50UGVyY2VudBInCg9kdXJhdGlvbl'
        '9tb250aHMYAyABKAVSDmR1cmF0aW9uTW9udGhz');

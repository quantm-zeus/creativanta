// This is a generated file - do not edit.
//
// Generated from creativanta/finance/v1/finance.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

/// Financial component breakdown per DB Schema §26.10 & Financial computation contract.
class FinancialComponent extends $pb.ProtobufEnum {
  static const FinancialComponent FINANCIAL_COMPONENT_UNSPECIFIED =
      FinancialComponent._(
          0, _omitEnumNames ? '' : 'FINANCIAL_COMPONENT_UNSPECIFIED');
  static const FinancialComponent FINANCIAL_COMPONENT_REVENUE =
      FinancialComponent._(
          1, _omitEnumNames ? '' : 'FINANCIAL_COMPONENT_REVENUE');
  static const FinancialComponent FINANCIAL_COMPONENT_PLATFORM_FEE =
      FinancialComponent._(
          2, _omitEnumNames ? '' : 'FINANCIAL_COMPONENT_PLATFORM_FEE');
  static const FinancialComponent FINANCIAL_COMPONENT_SHIPPING =
      FinancialComponent._(
          3, _omitEnumNames ? '' : 'FINANCIAL_COMPONENT_SHIPPING');
  static const FinancialComponent FINANCIAL_COMPONENT_COGS =
      FinancialComponent._(4, _omitEnumNames ? '' : 'FINANCIAL_COMPONENT_COGS');
  static const FinancialComponent FINANCIAL_COMPONENT_AI_CREDITS =
      FinancialComponent._(
          5, _omitEnumNames ? '' : 'FINANCIAL_COMPONENT_AI_CREDITS');
  static const FinancialComponent FINANCIAL_COMPONENT_COMMISSION =
      FinancialComponent._(
          6, _omitEnumNames ? '' : 'FINANCIAL_COMPONENT_COMMISSION');
  static const FinancialComponent FINANCIAL_COMPONENT_ADS_SPEND =
      FinancialComponent._(
          7, _omitEnumNames ? '' : 'FINANCIAL_COMPONENT_ADS_SPEND');
  static const FinancialComponent FINANCIAL_COMPONENT_SEEDING =
      FinancialComponent._(
          8, _omitEnumNames ? '' : 'FINANCIAL_COMPONENT_SEEDING');
  static const FinancialComponent FINANCIAL_COMPONENT_REFUND =
      FinancialComponent._(
          9, _omitEnumNames ? '' : 'FINANCIAL_COMPONENT_REFUND');
  static const FinancialComponent FINANCIAL_COMPONENT_OTHER =
      FinancialComponent._(
          10, _omitEnumNames ? '' : 'FINANCIAL_COMPONENT_OTHER');

  static const $core.List<FinancialComponent> values = <FinancialComponent>[
    FINANCIAL_COMPONENT_UNSPECIFIED,
    FINANCIAL_COMPONENT_REVENUE,
    FINANCIAL_COMPONENT_PLATFORM_FEE,
    FINANCIAL_COMPONENT_SHIPPING,
    FINANCIAL_COMPONENT_COGS,
    FINANCIAL_COMPONENT_AI_CREDITS,
    FINANCIAL_COMPONENT_COMMISSION,
    FINANCIAL_COMPONENT_ADS_SPEND,
    FINANCIAL_COMPONENT_SEEDING,
    FINANCIAL_COMPONENT_REFUND,
    FINANCIAL_COMPONENT_OTHER,
  ];

  static final $core.List<FinancialComponent?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 10);
  static FinancialComponent? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const FinancialComponent._(super.value, super.name);
}

/// Canonical reconciliation truth state machine per RULE-M19-007.
class ReconciliationState extends $pb.ProtobufEnum {
  static const ReconciliationState RECONCILIATION_STATE_UNSPECIFIED =
      ReconciliationState._(
          0, _omitEnumNames ? '' : 'RECONCILIATION_STATE_UNSPECIFIED');
  static const ReconciliationState RECONCILIATION_STATE_IMPORTED_ONLY =
      ReconciliationState._(
          1, _omitEnumNames ? '' : 'RECONCILIATION_STATE_IMPORTED_ONLY');
  static const ReconciliationState RECONCILIATION_STATE_AWAITING_EVIDENCE =
      ReconciliationState._(
          2, _omitEnumNames ? '' : 'RECONCILIATION_STATE_AWAITING_EVIDENCE');
  static const ReconciliationState
      RECONCILIATION_STATE_INFERRED_PENDING_CONFIRMATION =
      ReconciliationState._(
          3,
          _omitEnumNames
              ? ''
              : 'RECONCILIATION_STATE_INFERRED_PENDING_CONFIRMATION');
  static const ReconciliationState RECONCILIATION_STATE_PARTIALLY_RECONCILED =
      ReconciliationState._(
          4, _omitEnumNames ? '' : 'RECONCILIATION_STATE_PARTIALLY_RECONCILED');
  static const ReconciliationState RECONCILIATION_STATE_FULLY_RECONCILED =
      ReconciliationState._(
          5, _omitEnumNames ? '' : 'RECONCILIATION_STATE_FULLY_RECONCILED');
  static const ReconciliationState RECONCILIATION_STATE_CONFLICT_DETECTED =
      ReconciliationState._(
          6, _omitEnumNames ? '' : 'RECONCILIATION_STATE_CONFLICT_DETECTED');
  static const ReconciliationState RECONCILIATION_STATE_MANUALLY_OVERRIDDEN =
      ReconciliationState._(
          7, _omitEnumNames ? '' : 'RECONCILIATION_STATE_MANUALLY_OVERRIDDEN');

  static const $core.List<ReconciliationState> values = <ReconciliationState>[
    RECONCILIATION_STATE_UNSPECIFIED,
    RECONCILIATION_STATE_IMPORTED_ONLY,
    RECONCILIATION_STATE_AWAITING_EVIDENCE,
    RECONCILIATION_STATE_INFERRED_PENDING_CONFIRMATION,
    RECONCILIATION_STATE_PARTIALLY_RECONCILED,
    RECONCILIATION_STATE_FULLY_RECONCILED,
    RECONCILIATION_STATE_CONFLICT_DETECTED,
    RECONCILIATION_STATE_MANUALLY_OVERRIDDEN,
  ];

  static final $core.List<ReconciliationState?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 7);
  static ReconciliationState? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const ReconciliationState._(super.value, super.name);
}

/// Ingestion lifecycle for settlements per DB Schema §11.1.
class SettlementState extends $pb.ProtobufEnum {
  static const SettlementState SETTLEMENT_STATE_UNSPECIFIED = SettlementState._(
      0, _omitEnumNames ? '' : 'SETTLEMENT_STATE_UNSPECIFIED');
  static const SettlementState SETTLEMENT_STATE_IMPORTED =
      SettlementState._(1, _omitEnumNames ? '' : 'SETTLEMENT_STATE_IMPORTED');
  static const SettlementState SETTLEMENT_STATE_NORMALIZED =
      SettlementState._(2, _omitEnumNames ? '' : 'SETTLEMENT_STATE_NORMALIZED');
  static const SettlementState SETTLEMENT_STATE_READY_FOR_MATCHING =
      SettlementState._(
          3, _omitEnumNames ? '' : 'SETTLEMENT_STATE_READY_FOR_MATCHING');
  static const SettlementState SETTLEMENT_STATE_ARCHIVED =
      SettlementState._(4, _omitEnumNames ? '' : 'SETTLEMENT_STATE_ARCHIVED');

  static const $core.List<SettlementState> values = <SettlementState>[
    SETTLEMENT_STATE_UNSPECIFIED,
    SETTLEMENT_STATE_IMPORTED,
    SETTLEMENT_STATE_NORMALIZED,
    SETTLEMENT_STATE_READY_FOR_MATCHING,
    SETTLEMENT_STATE_ARCHIVED,
  ];

  static final $core.List<SettlementState?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 4);
  static SettlementState? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const SettlementState._(super.value, super.name);
}

/// Cost item state per DB Schema §11.2.
class CostState extends $pb.ProtobufEnum {
  static const CostState COST_STATE_UNSPECIFIED =
      CostState._(0, _omitEnumNames ? '' : 'COST_STATE_UNSPECIFIED');
  static const CostState COST_STATE_RECORDED =
      CostState._(1, _omitEnumNames ? '' : 'COST_STATE_RECORDED');
  static const CostState COST_STATE_PENDING_EVIDENCE =
      CostState._(2, _omitEnumNames ? '' : 'COST_STATE_PENDING_EVIDENCE');
  static const CostState COST_STATE_RECONCILED =
      CostState._(3, _omitEnumNames ? '' : 'COST_STATE_RECONCILED');
  static const CostState COST_STATE_ESTIMATED =
      CostState._(4, _omitEnumNames ? '' : 'COST_STATE_ESTIMATED');
  static const CostState COST_STATE_SUPERSEDED =
      CostState._(5, _omitEnumNames ? '' : 'COST_STATE_SUPERSEDED');

  static const $core.List<CostState> values = <CostState>[
    COST_STATE_UNSPECIFIED,
    COST_STATE_RECORDED,
    COST_STATE_PENDING_EVIDENCE,
    COST_STATE_RECONCILED,
    COST_STATE_ESTIMATED,
    COST_STATE_SUPERSEDED,
  ];

  static final $core.List<CostState?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 5);
  static CostState? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const CostState._(super.value, super.name);
}

/// Verification status for evidence objects per DB Schema §3.
class VerificationStatus extends $pb.ProtobufEnum {
  static const VerificationStatus VERIFICATION_STATUS_UNSPECIFIED =
      VerificationStatus._(
          0, _omitEnumNames ? '' : 'VERIFICATION_STATUS_UNSPECIFIED');
  static const VerificationStatus VERIFICATION_STATUS_PENDING =
      VerificationStatus._(
          1, _omitEnumNames ? '' : 'VERIFICATION_STATUS_PENDING');
  static const VerificationStatus VERIFICATION_STATUS_VERIFIED =
      VerificationStatus._(
          2, _omitEnumNames ? '' : 'VERIFICATION_STATUS_VERIFIED');
  static const VerificationStatus VERIFICATION_STATUS_RE_VERIFY =
      VerificationStatus._(
          3, _omitEnumNames ? '' : 'VERIFICATION_STATUS_RE_VERIFY');
  static const VerificationStatus VERIFICATION_STATUS_FAILED =
      VerificationStatus._(
          4, _omitEnumNames ? '' : 'VERIFICATION_STATUS_FAILED');

  static const $core.List<VerificationStatus> values = <VerificationStatus>[
    VERIFICATION_STATUS_UNSPECIFIED,
    VERIFICATION_STATUS_PENDING,
    VERIFICATION_STATUS_VERIFIED,
    VERIFICATION_STATUS_RE_VERIFY,
    VERIFICATION_STATUS_FAILED,
  ];

  static final $core.List<VerificationStatus?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 4);
  static VerificationStatus? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const VerificationStatus._(super.value, super.name);
}

const $core.bool _omitEnumNames =
    $core.bool.fromEnvironment('protobuf.omit_enum_names');

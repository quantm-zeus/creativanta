// This is a generated file - do not edit.
//
// Generated from creativanta/admin/v1/billing.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;
import 'package:protobuf/well_known_types/google/protobuf/timestamp.pb.dart'
    as $2;

import '../../common/v1/types.pb.dart' as $1;
import 'billing.pbenum.dart';

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'billing.pbenum.dart';

/// Versioned cost-based quote projection (§26.2 & api_behavior_contracts.md §2).
/// All decimal credit and USD amounts use exact base-10 string representations (never float).
class CreditQuote extends $pb.GeneratedMessage {
  factory CreditQuote({
    $1.UUID? quoteId,
    $core.String? operationType,
    $core.String? rateVersion,
    $core.String? requestHash,
    $core.String? costCeilingUsd,
    $core.String? usdPerCreditFloor,
    $core.String? grossMarginFloor,
    $core.String? quotedCredits,
    $2.Timestamp? expiresAt,
    $core.String? providerPlanJson,
  }) {
    final result = CreditQuote._();
    if (quoteId != null) result.quoteId = quoteId;
    if (operationType != null) result.operationType = operationType;
    if (rateVersion != null) result.rateVersion = rateVersion;
    if (requestHash != null) result.requestHash = requestHash;
    if (costCeilingUsd != null) result.costCeilingUsd = costCeilingUsd;
    if (usdPerCreditFloor != null) result.usdPerCreditFloor = usdPerCreditFloor;
    if (grossMarginFloor != null) result.grossMarginFloor = grossMarginFloor;
    if (quotedCredits != null) result.quotedCredits = quotedCredits;
    if (expiresAt != null) result.expiresAt = expiresAt;
    if (providerPlanJson != null) result.providerPlanJson = providerPlanJson;
    return result;
  }

  CreditQuote._();

  factory CreditQuote.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CreditQuote()..mergeFromBuffer(data, registry);
  factory CreditQuote.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CreditQuote()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CreditQuote',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.admin.v1'),
      createEmptyInstance: CreditQuote.$_createMessage)
    ..aOM<$1.UUID>(1, _omitFieldNames ? '' : 'quoteId',
        subBuilder: $1.UUID.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'operationType')
    ..aOS(3, _omitFieldNames ? '' : 'rateVersion')
    ..aOS(4, _omitFieldNames ? '' : 'requestHash')
    ..aOS(5, _omitFieldNames ? '' : 'costCeilingUsd')
    ..aOS(6, _omitFieldNames ? '' : 'usdPerCreditFloor')
    ..aOS(7, _omitFieldNames ? '' : 'grossMarginFloor')
    ..aOS(8, _omitFieldNames ? '' : 'quotedCredits')
    ..aOM<$2.Timestamp>(9, _omitFieldNames ? '' : 'expiresAt',
        subBuilder: $2.Timestamp.$_createMessage)
    ..aOS(10, _omitFieldNames ? '' : 'providerPlanJson')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreditQuote clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreditQuote copyWith(void Function(CreditQuote) updates) =>
      super.copyWith((message) => updates(message as CreditQuote))
          as CreditQuote;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use CreditQuote() / CreditQuote.new instead')
  static CreditQuote create() => CreditQuote._();
  static $pb.GeneratedMessage $_createMessage() => CreditQuote._();
  @$core.override
  CreditQuote createEmptyInstance() => CreditQuote._();
  @$core.pragma('dart2js:noInline')
  static CreditQuote getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CreditQuote>(
          CreditQuote.$_createMessage);
  static CreditQuote? _defaultInstance;

  @$pb.TagNumber(1)
  $1.UUID get quoteId => $_getN(0);
  @$pb.TagNumber(1)
  set quoteId($1.UUID value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasQuoteId() => $_has(0);
  @$pb.TagNumber(1)
  void clearQuoteId() => $_clearField(1);
  @$pb.TagNumber(1)
  $1.UUID ensureQuoteId() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get operationType => $_getSZ(1);
  @$pb.TagNumber(2)
  set operationType($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasOperationType() => $_has(1);
  @$pb.TagNumber(2)
  void clearOperationType() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get rateVersion => $_getSZ(2);
  @$pb.TagNumber(3)
  set rateVersion($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasRateVersion() => $_has(2);
  @$pb.TagNumber(3)
  void clearRateVersion() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get requestHash => $_getSZ(3);
  @$pb.TagNumber(4)
  set requestHash($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasRequestHash() => $_has(3);
  @$pb.TagNumber(4)
  void clearRequestHash() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get costCeilingUsd => $_getSZ(4);
  @$pb.TagNumber(5)
  set costCeilingUsd($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasCostCeilingUsd() => $_has(4);
  @$pb.TagNumber(5)
  void clearCostCeilingUsd() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get usdPerCreditFloor => $_getSZ(5);
  @$pb.TagNumber(6)
  set usdPerCreditFloor($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasUsdPerCreditFloor() => $_has(5);
  @$pb.TagNumber(6)
  void clearUsdPerCreditFloor() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get grossMarginFloor => $_getSZ(6);
  @$pb.TagNumber(7)
  set grossMarginFloor($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasGrossMarginFloor() => $_has(6);
  @$pb.TagNumber(7)
  void clearGrossMarginFloor() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get quotedCredits => $_getSZ(7);
  @$pb.TagNumber(8)
  set quotedCredits($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasQuotedCredits() => $_has(7);
  @$pb.TagNumber(8)
  void clearQuotedCredits() => $_clearField(8);

  @$pb.TagNumber(9)
  $2.Timestamp get expiresAt => $_getN(8);
  @$pb.TagNumber(9)
  set expiresAt($2.Timestamp value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasExpiresAt() => $_has(8);
  @$pb.TagNumber(9)
  void clearExpiresAt() => $_clearField(9);
  @$pb.TagNumber(9)
  $2.Timestamp ensureExpiresAt() => $_ensure(8);

  @$pb.TagNumber(10)
  $core.String get providerPlanJson => $_getSZ(9);
  @$pb.TagNumber(10)
  set providerPlanJson($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasProviderPlanJson() => $_has(9);
  @$pb.TagNumber(10)
  void clearProviderPlanJson() => $_clearField(10);
}

/// Durable credit lot projection (§26.3).
class CreditLotSummary extends $pb.GeneratedMessage {
  factory CreditLotSummary({
    $1.UUID? lotId,
    CreditSourceType? sourceType,
    $core.String? grantedCredits,
    $core.String? remainingCredits,
    $core.String? reservedCredits,
    $core.String? availableCredits,
    $2.Timestamp? expiresAt,
    $core.String? externalGrantKey,
    $2.Timestamp? createdAt,
  }) {
    final result = CreditLotSummary._();
    if (lotId != null) result.lotId = lotId;
    if (sourceType != null) result.sourceType = sourceType;
    if (grantedCredits != null) result.grantedCredits = grantedCredits;
    if (remainingCredits != null) result.remainingCredits = remainingCredits;
    if (reservedCredits != null) result.reservedCredits = reservedCredits;
    if (availableCredits != null) result.availableCredits = availableCredits;
    if (expiresAt != null) result.expiresAt = expiresAt;
    if (externalGrantKey != null) result.externalGrantKey = externalGrantKey;
    if (createdAt != null) result.createdAt = createdAt;
    return result;
  }

  CreditLotSummary._();

  factory CreditLotSummary.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CreditLotSummary()..mergeFromBuffer(data, registry);
  factory CreditLotSummary.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CreditLotSummary()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CreditLotSummary',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.admin.v1'),
      createEmptyInstance: CreditLotSummary.$_createMessage)
    ..aOM<$1.UUID>(1, _omitFieldNames ? '' : 'lotId',
        subBuilder: $1.UUID.$_createMessage)
    ..aE<CreditSourceType>(2, _omitFieldNames ? '' : 'sourceType',
        enumValues: CreditSourceType.values)
    ..aOS(3, _omitFieldNames ? '' : 'grantedCredits')
    ..aOS(4, _omitFieldNames ? '' : 'remainingCredits')
    ..aOS(5, _omitFieldNames ? '' : 'reservedCredits')
    ..aOS(6, _omitFieldNames ? '' : 'availableCredits')
    ..aOM<$2.Timestamp>(7, _omitFieldNames ? '' : 'expiresAt',
        subBuilder: $2.Timestamp.$_createMessage)
    ..aOS(8, _omitFieldNames ? '' : 'externalGrantKey')
    ..aOM<$2.Timestamp>(9, _omitFieldNames ? '' : 'createdAt',
        subBuilder: $2.Timestamp.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreditLotSummary clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreditLotSummary copyWith(void Function(CreditLotSummary) updates) =>
      super.copyWith((message) => updates(message as CreditLotSummary))
          as CreditLotSummary;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use CreditLotSummary() / CreditLotSummary.new instead')
  static CreditLotSummary create() => CreditLotSummary._();
  static $pb.GeneratedMessage $_createMessage() => CreditLotSummary._();
  @$core.override
  CreditLotSummary createEmptyInstance() => CreditLotSummary._();
  @$core.pragma('dart2js:noInline')
  static CreditLotSummary getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CreditLotSummary>(
          CreditLotSummary.$_createMessage);
  static CreditLotSummary? _defaultInstance;

  @$pb.TagNumber(1)
  $1.UUID get lotId => $_getN(0);
  @$pb.TagNumber(1)
  set lotId($1.UUID value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasLotId() => $_has(0);
  @$pb.TagNumber(1)
  void clearLotId() => $_clearField(1);
  @$pb.TagNumber(1)
  $1.UUID ensureLotId() => $_ensure(0);

  @$pb.TagNumber(2)
  CreditSourceType get sourceType => $_getN(1);
  @$pb.TagNumber(2)
  set sourceType(CreditSourceType value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasSourceType() => $_has(1);
  @$pb.TagNumber(2)
  void clearSourceType() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get grantedCredits => $_getSZ(2);
  @$pb.TagNumber(3)
  set grantedCredits($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasGrantedCredits() => $_has(2);
  @$pb.TagNumber(3)
  void clearGrantedCredits() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get remainingCredits => $_getSZ(3);
  @$pb.TagNumber(4)
  set remainingCredits($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasRemainingCredits() => $_has(3);
  @$pb.TagNumber(4)
  void clearRemainingCredits() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get reservedCredits => $_getSZ(4);
  @$pb.TagNumber(5)
  set reservedCredits($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasReservedCredits() => $_has(4);
  @$pb.TagNumber(5)
  void clearReservedCredits() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get availableCredits => $_getSZ(5);
  @$pb.TagNumber(6)
  set availableCredits($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasAvailableCredits() => $_has(5);
  @$pb.TagNumber(6)
  void clearAvailableCredits() => $_clearField(6);

  @$pb.TagNumber(7)
  $2.Timestamp get expiresAt => $_getN(6);
  @$pb.TagNumber(7)
  set expiresAt($2.Timestamp value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasExpiresAt() => $_has(6);
  @$pb.TagNumber(7)
  void clearExpiresAt() => $_clearField(7);
  @$pb.TagNumber(7)
  $2.Timestamp ensureExpiresAt() => $_ensure(6);

  @$pb.TagNumber(8)
  $core.String get externalGrantKey => $_getSZ(7);
  @$pb.TagNumber(8)
  set externalGrantKey($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasExternalGrantKey() => $_has(7);
  @$pb.TagNumber(8)
  void clearExternalGrantKey() => $_clearField(8);

  @$pb.TagNumber(9)
  $2.Timestamp get createdAt => $_getN(8);
  @$pb.TagNumber(9)
  set createdAt($2.Timestamp value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasCreatedAt() => $_has(8);
  @$pb.TagNumber(9)
  void clearCreatedAt() => $_clearField(9);
  @$pb.TagNumber(9)
  $2.Timestamp ensureCreatedAt() => $_ensure(8);
}

/// Canonical CreditBalance projection (api_behavior_contracts.md §2).
class CreditBalance extends $pb.GeneratedMessage {
  factory CreditBalance({
    $core.String? totalRemaining,
    $core.String? reserved,
    $core.String? available,
    $core.String? subscriptionRemaining,
    $core.String? purchasedRemaining,
    $core.String? promotionalRemaining,
    $core.String? overageRemaining,
    $2.Timestamp? nextAllocationAt,
    $core.String? subscriptionTier,
    $core.Iterable<CreditLotSummary>? activeLots,
  }) {
    final result = CreditBalance._();
    if (totalRemaining != null) result.totalRemaining = totalRemaining;
    if (reserved != null) result.reserved = reserved;
    if (available != null) result.available = available;
    if (subscriptionRemaining != null)
      result.subscriptionRemaining = subscriptionRemaining;
    if (purchasedRemaining != null)
      result.purchasedRemaining = purchasedRemaining;
    if (promotionalRemaining != null)
      result.promotionalRemaining = promotionalRemaining;
    if (overageRemaining != null) result.overageRemaining = overageRemaining;
    if (nextAllocationAt != null) result.nextAllocationAt = nextAllocationAt;
    if (subscriptionTier != null) result.subscriptionTier = subscriptionTier;
    if (activeLots != null) result.activeLots.addAll(activeLots);
    return result;
  }

  CreditBalance._();

  factory CreditBalance.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CreditBalance()..mergeFromBuffer(data, registry);
  factory CreditBalance.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CreditBalance()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CreditBalance',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.admin.v1'),
      createEmptyInstance: CreditBalance.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'totalRemaining')
    ..aOS(2, _omitFieldNames ? '' : 'reserved')
    ..aOS(3, _omitFieldNames ? '' : 'available')
    ..aOS(4, _omitFieldNames ? '' : 'subscriptionRemaining')
    ..aOS(5, _omitFieldNames ? '' : 'purchasedRemaining')
    ..aOS(6, _omitFieldNames ? '' : 'promotionalRemaining')
    ..aOS(7, _omitFieldNames ? '' : 'overageRemaining')
    ..aOM<$2.Timestamp>(8, _omitFieldNames ? '' : 'nextAllocationAt',
        subBuilder: $2.Timestamp.$_createMessage)
    ..aOS(9, _omitFieldNames ? '' : 'subscriptionTier')
    ..pPM<CreditLotSummary>(10, _omitFieldNames ? '' : 'activeLots',
        subBuilder: CreditLotSummary.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreditBalance clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreditBalance copyWith(void Function(CreditBalance) updates) =>
      super.copyWith((message) => updates(message as CreditBalance))
          as CreditBalance;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use CreditBalance() / CreditBalance.new instead')
  static CreditBalance create() => CreditBalance._();
  static $pb.GeneratedMessage $_createMessage() => CreditBalance._();
  @$core.override
  CreditBalance createEmptyInstance() => CreditBalance._();
  @$core.pragma('dart2js:noInline')
  static CreditBalance getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CreditBalance>(
          CreditBalance.$_createMessage);
  static CreditBalance? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get totalRemaining => $_getSZ(0);
  @$pb.TagNumber(1)
  set totalRemaining($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTotalRemaining() => $_has(0);
  @$pb.TagNumber(1)
  void clearTotalRemaining() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get reserved => $_getSZ(1);
  @$pb.TagNumber(2)
  set reserved($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasReserved() => $_has(1);
  @$pb.TagNumber(2)
  void clearReserved() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get available => $_getSZ(2);
  @$pb.TagNumber(3)
  set available($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasAvailable() => $_has(2);
  @$pb.TagNumber(3)
  void clearAvailable() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get subscriptionRemaining => $_getSZ(3);
  @$pb.TagNumber(4)
  set subscriptionRemaining($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasSubscriptionRemaining() => $_has(3);
  @$pb.TagNumber(4)
  void clearSubscriptionRemaining() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get purchasedRemaining => $_getSZ(4);
  @$pb.TagNumber(5)
  set purchasedRemaining($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasPurchasedRemaining() => $_has(4);
  @$pb.TagNumber(5)
  void clearPurchasedRemaining() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get promotionalRemaining => $_getSZ(5);
  @$pb.TagNumber(6)
  set promotionalRemaining($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasPromotionalRemaining() => $_has(5);
  @$pb.TagNumber(6)
  void clearPromotionalRemaining() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get overageRemaining => $_getSZ(6);
  @$pb.TagNumber(7)
  set overageRemaining($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasOverageRemaining() => $_has(6);
  @$pb.TagNumber(7)
  void clearOverageRemaining() => $_clearField(7);

  @$pb.TagNumber(8)
  $2.Timestamp get nextAllocationAt => $_getN(7);
  @$pb.TagNumber(8)
  set nextAllocationAt($2.Timestamp value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasNextAllocationAt() => $_has(7);
  @$pb.TagNumber(8)
  void clearNextAllocationAt() => $_clearField(8);
  @$pb.TagNumber(8)
  $2.Timestamp ensureNextAllocationAt() => $_ensure(7);

  @$pb.TagNumber(9)
  $core.String get subscriptionTier => $_getSZ(8);
  @$pb.TagNumber(9)
  set subscriptionTier($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasSubscriptionTier() => $_has(8);
  @$pb.TagNumber(9)
  void clearSubscriptionTier() => $_clearField(9);

  @$pb.TagNumber(10)
  $pb.PbList<CreditLotSummary> get activeLots => $_getList(9);
}

/// Append-only AI credit transaction projection (§13.2).
class CreditTransactionEntry extends $pb.GeneratedMessage {
  factory CreditTransactionEntry({
    $1.UUID? transactionId,
    $1.UUID? workspaceId,
    $1.UUID? userId,
    $core.String? operationType,
    $core.String? creditsDelta,
    $core.String? balanceAfter,
    $core.String? source,
    $1.UUID? referenceId,
    $1.UUID? reservationId,
    $1.UUID? lotId,
    $1.UUID? quoteId,
    $1.UUID? referenceTransactionId,
    $core.String? providerCostUsd,
    $core.String? rateVersion,
    $core.String? idempotencyKey,
    $core.String? description,
    $2.Timestamp? createdAt,
  }) {
    final result = CreditTransactionEntry._();
    if (transactionId != null) result.transactionId = transactionId;
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (userId != null) result.userId = userId;
    if (operationType != null) result.operationType = operationType;
    if (creditsDelta != null) result.creditsDelta = creditsDelta;
    if (balanceAfter != null) result.balanceAfter = balanceAfter;
    if (source != null) result.source = source;
    if (referenceId != null) result.referenceId = referenceId;
    if (reservationId != null) result.reservationId = reservationId;
    if (lotId != null) result.lotId = lotId;
    if (quoteId != null) result.quoteId = quoteId;
    if (referenceTransactionId != null)
      result.referenceTransactionId = referenceTransactionId;
    if (providerCostUsd != null) result.providerCostUsd = providerCostUsd;
    if (rateVersion != null) result.rateVersion = rateVersion;
    if (idempotencyKey != null) result.idempotencyKey = idempotencyKey;
    if (description != null) result.description = description;
    if (createdAt != null) result.createdAt = createdAt;
    return result;
  }

  CreditTransactionEntry._();

  factory CreditTransactionEntry.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CreditTransactionEntry()..mergeFromBuffer(data, registry);
  factory CreditTransactionEntry.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CreditTransactionEntry()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CreditTransactionEntry',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.admin.v1'),
      createEmptyInstance: CreditTransactionEntry.$_createMessage)
    ..aOM<$1.UUID>(1, _omitFieldNames ? '' : 'transactionId',
        subBuilder: $1.UUID.$_createMessage)
    ..aOM<$1.UUID>(2, _omitFieldNames ? '' : 'workspaceId',
        subBuilder: $1.UUID.$_createMessage)
    ..aOM<$1.UUID>(3, _omitFieldNames ? '' : 'userId',
        subBuilder: $1.UUID.$_createMessage)
    ..aOS(4, _omitFieldNames ? '' : 'operationType')
    ..aOS(5, _omitFieldNames ? '' : 'creditsDelta')
    ..aOS(6, _omitFieldNames ? '' : 'balanceAfter')
    ..aOS(7, _omitFieldNames ? '' : 'source')
    ..aOM<$1.UUID>(8, _omitFieldNames ? '' : 'referenceId',
        subBuilder: $1.UUID.$_createMessage)
    ..aOM<$1.UUID>(9, _omitFieldNames ? '' : 'reservationId',
        subBuilder: $1.UUID.$_createMessage)
    ..aOM<$1.UUID>(10, _omitFieldNames ? '' : 'lotId',
        subBuilder: $1.UUID.$_createMessage)
    ..aOM<$1.UUID>(11, _omitFieldNames ? '' : 'quoteId',
        subBuilder: $1.UUID.$_createMessage)
    ..aOM<$1.UUID>(12, _omitFieldNames ? '' : 'referenceTransactionId',
        subBuilder: $1.UUID.$_createMessage)
    ..aOS(13, _omitFieldNames ? '' : 'providerCostUsd')
    ..aOS(14, _omitFieldNames ? '' : 'rateVersion')
    ..aOS(15, _omitFieldNames ? '' : 'idempotencyKey')
    ..aOS(16, _omitFieldNames ? '' : 'description')
    ..aOM<$2.Timestamp>(17, _omitFieldNames ? '' : 'createdAt',
        subBuilder: $2.Timestamp.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreditTransactionEntry clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreditTransactionEntry copyWith(
          void Function(CreditTransactionEntry) updates) =>
      super.copyWith((message) => updates(message as CreditTransactionEntry))
          as CreditTransactionEntry;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use CreditTransactionEntry() / CreditTransactionEntry.new instead')
  static CreditTransactionEntry create() => CreditTransactionEntry._();
  static $pb.GeneratedMessage $_createMessage() => CreditTransactionEntry._();
  @$core.override
  CreditTransactionEntry createEmptyInstance() => CreditTransactionEntry._();
  @$core.pragma('dart2js:noInline')
  static CreditTransactionEntry getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CreditTransactionEntry>(
          CreditTransactionEntry.$_createMessage);
  static CreditTransactionEntry? _defaultInstance;

  @$pb.TagNumber(1)
  $1.UUID get transactionId => $_getN(0);
  @$pb.TagNumber(1)
  set transactionId($1.UUID value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasTransactionId() => $_has(0);
  @$pb.TagNumber(1)
  void clearTransactionId() => $_clearField(1);
  @$pb.TagNumber(1)
  $1.UUID ensureTransactionId() => $_ensure(0);

  @$pb.TagNumber(2)
  $1.UUID get workspaceId => $_getN(1);
  @$pb.TagNumber(2)
  set workspaceId($1.UUID value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasWorkspaceId() => $_has(1);
  @$pb.TagNumber(2)
  void clearWorkspaceId() => $_clearField(2);
  @$pb.TagNumber(2)
  $1.UUID ensureWorkspaceId() => $_ensure(1);

  @$pb.TagNumber(3)
  $1.UUID get userId => $_getN(2);
  @$pb.TagNumber(3)
  set userId($1.UUID value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasUserId() => $_has(2);
  @$pb.TagNumber(3)
  void clearUserId() => $_clearField(3);
  @$pb.TagNumber(3)
  $1.UUID ensureUserId() => $_ensure(2);

  @$pb.TagNumber(4)
  $core.String get operationType => $_getSZ(3);
  @$pb.TagNumber(4)
  set operationType($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasOperationType() => $_has(3);
  @$pb.TagNumber(4)
  void clearOperationType() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get creditsDelta => $_getSZ(4);
  @$pb.TagNumber(5)
  set creditsDelta($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasCreditsDelta() => $_has(4);
  @$pb.TagNumber(5)
  void clearCreditsDelta() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get balanceAfter => $_getSZ(5);
  @$pb.TagNumber(6)
  set balanceAfter($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasBalanceAfter() => $_has(5);
  @$pb.TagNumber(6)
  void clearBalanceAfter() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get source => $_getSZ(6);
  @$pb.TagNumber(7)
  set source($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasSource() => $_has(6);
  @$pb.TagNumber(7)
  void clearSource() => $_clearField(7);

  @$pb.TagNumber(8)
  $1.UUID get referenceId => $_getN(7);
  @$pb.TagNumber(8)
  set referenceId($1.UUID value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasReferenceId() => $_has(7);
  @$pb.TagNumber(8)
  void clearReferenceId() => $_clearField(8);
  @$pb.TagNumber(8)
  $1.UUID ensureReferenceId() => $_ensure(7);

  @$pb.TagNumber(9)
  $1.UUID get reservationId => $_getN(8);
  @$pb.TagNumber(9)
  set reservationId($1.UUID value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasReservationId() => $_has(8);
  @$pb.TagNumber(9)
  void clearReservationId() => $_clearField(9);
  @$pb.TagNumber(9)
  $1.UUID ensureReservationId() => $_ensure(8);

  @$pb.TagNumber(10)
  $1.UUID get lotId => $_getN(9);
  @$pb.TagNumber(10)
  set lotId($1.UUID value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasLotId() => $_has(9);
  @$pb.TagNumber(10)
  void clearLotId() => $_clearField(10);
  @$pb.TagNumber(10)
  $1.UUID ensureLotId() => $_ensure(9);

  @$pb.TagNumber(11)
  $1.UUID get quoteId => $_getN(10);
  @$pb.TagNumber(11)
  set quoteId($1.UUID value) => $_setField(11, value);
  @$pb.TagNumber(11)
  $core.bool hasQuoteId() => $_has(10);
  @$pb.TagNumber(11)
  void clearQuoteId() => $_clearField(11);
  @$pb.TagNumber(11)
  $1.UUID ensureQuoteId() => $_ensure(10);

  @$pb.TagNumber(12)
  $1.UUID get referenceTransactionId => $_getN(11);
  @$pb.TagNumber(12)
  set referenceTransactionId($1.UUID value) => $_setField(12, value);
  @$pb.TagNumber(12)
  $core.bool hasReferenceTransactionId() => $_has(11);
  @$pb.TagNumber(12)
  void clearReferenceTransactionId() => $_clearField(12);
  @$pb.TagNumber(12)
  $1.UUID ensureReferenceTransactionId() => $_ensure(11);

  @$pb.TagNumber(13)
  $core.String get providerCostUsd => $_getSZ(12);
  @$pb.TagNumber(13)
  set providerCostUsd($core.String value) => $_setString(12, value);
  @$pb.TagNumber(13)
  $core.bool hasProviderCostUsd() => $_has(12);
  @$pb.TagNumber(13)
  void clearProviderCostUsd() => $_clearField(13);

  @$pb.TagNumber(14)
  $core.String get rateVersion => $_getSZ(13);
  @$pb.TagNumber(14)
  set rateVersion($core.String value) => $_setString(13, value);
  @$pb.TagNumber(14)
  $core.bool hasRateVersion() => $_has(13);
  @$pb.TagNumber(14)
  void clearRateVersion() => $_clearField(14);

  @$pb.TagNumber(15)
  $core.String get idempotencyKey => $_getSZ(14);
  @$pb.TagNumber(15)
  set idempotencyKey($core.String value) => $_setString(14, value);
  @$pb.TagNumber(15)
  $core.bool hasIdempotencyKey() => $_has(14);
  @$pb.TagNumber(15)
  void clearIdempotencyKey() => $_clearField(15);

  @$pb.TagNumber(16)
  $core.String get description => $_getSZ(15);
  @$pb.TagNumber(16)
  set description($core.String value) => $_setString(15, value);
  @$pb.TagNumber(16)
  $core.bool hasDescription() => $_has(15);
  @$pb.TagNumber(16)
  void clearDescription() => $_clearField(16);

  @$pb.TagNumber(17)
  $2.Timestamp get createdAt => $_getN(16);
  @$pb.TagNumber(17)
  set createdAt($2.Timestamp value) => $_setField(17, value);
  @$pb.TagNumber(17)
  $core.bool hasCreatedAt() => $_has(16);
  @$pb.TagNumber(17)
  void clearCreatedAt() => $_clearField(17);
  @$pb.TagNumber(17)
  $2.Timestamp ensureCreatedAt() => $_ensure(16);
}

/// Canonical subscription tier entry from the versioned pricebook (pricing_and_credits.md §1.1).
class PlanCatalogEntry extends $pb.GeneratedMessage {
  factory PlanCatalogEntry({
    $core.String? tierCode,
    $core.String? displayName,
    $1.Money? monthlyPriceUsd,
    $1.Money? annualPriceUsd,
    $1.Money? monthlyPriceVnd,
    $1.Money? annualPriceVnd,
    $core.String? monthlyCredits,
    $core.String? rolloverFraction,
    $core.int? maxSeats,
    $core.int? maxChannels,
    $core.int? maxStorageGb,
    $core.bool? overageEligible,
  }) {
    final result = PlanCatalogEntry._();
    if (tierCode != null) result.tierCode = tierCode;
    if (displayName != null) result.displayName = displayName;
    if (monthlyPriceUsd != null) result.monthlyPriceUsd = monthlyPriceUsd;
    if (annualPriceUsd != null) result.annualPriceUsd = annualPriceUsd;
    if (monthlyPriceVnd != null) result.monthlyPriceVnd = monthlyPriceVnd;
    if (annualPriceVnd != null) result.annualPriceVnd = annualPriceVnd;
    if (monthlyCredits != null) result.monthlyCredits = monthlyCredits;
    if (rolloverFraction != null) result.rolloverFraction = rolloverFraction;
    if (maxSeats != null) result.maxSeats = maxSeats;
    if (maxChannels != null) result.maxChannels = maxChannels;
    if (maxStorageGb != null) result.maxStorageGb = maxStorageGb;
    if (overageEligible != null) result.overageEligible = overageEligible;
    return result;
  }

  PlanCatalogEntry._();

  factory PlanCatalogEntry.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PlanCatalogEntry()..mergeFromBuffer(data, registry);
  factory PlanCatalogEntry.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PlanCatalogEntry()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PlanCatalogEntry',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.admin.v1'),
      createEmptyInstance: PlanCatalogEntry.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'tierCode')
    ..aOS(2, _omitFieldNames ? '' : 'displayName')
    ..aOM<$1.Money>(3, _omitFieldNames ? '' : 'monthlyPriceUsd',
        subBuilder: $1.Money.$_createMessage)
    ..aOM<$1.Money>(4, _omitFieldNames ? '' : 'annualPriceUsd',
        subBuilder: $1.Money.$_createMessage)
    ..aOM<$1.Money>(5, _omitFieldNames ? '' : 'monthlyPriceVnd',
        subBuilder: $1.Money.$_createMessage)
    ..aOM<$1.Money>(6, _omitFieldNames ? '' : 'annualPriceVnd',
        subBuilder: $1.Money.$_createMessage)
    ..aOS(7, _omitFieldNames ? '' : 'monthlyCredits')
    ..aOS(8, _omitFieldNames ? '' : 'rolloverFraction')
    ..aI(9, _omitFieldNames ? '' : 'maxSeats')
    ..aI(10, _omitFieldNames ? '' : 'maxChannels')
    ..aI(11, _omitFieldNames ? '' : 'maxStorageGb')
    ..aOB(12, _omitFieldNames ? '' : 'overageEligible')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PlanCatalogEntry clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PlanCatalogEntry copyWith(void Function(PlanCatalogEntry) updates) =>
      super.copyWith((message) => updates(message as PlanCatalogEntry))
          as PlanCatalogEntry;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use PlanCatalogEntry() / PlanCatalogEntry.new instead')
  static PlanCatalogEntry create() => PlanCatalogEntry._();
  static $pb.GeneratedMessage $_createMessage() => PlanCatalogEntry._();
  @$core.override
  PlanCatalogEntry createEmptyInstance() => PlanCatalogEntry._();
  @$core.pragma('dart2js:noInline')
  static PlanCatalogEntry getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PlanCatalogEntry>(
          PlanCatalogEntry.$_createMessage);
  static PlanCatalogEntry? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get tierCode => $_getSZ(0);
  @$pb.TagNumber(1)
  set tierCode($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTierCode() => $_has(0);
  @$pb.TagNumber(1)
  void clearTierCode() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get displayName => $_getSZ(1);
  @$pb.TagNumber(2)
  set displayName($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasDisplayName() => $_has(1);
  @$pb.TagNumber(2)
  void clearDisplayName() => $_clearField(2);

  @$pb.TagNumber(3)
  $1.Money get monthlyPriceUsd => $_getN(2);
  @$pb.TagNumber(3)
  set monthlyPriceUsd($1.Money value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasMonthlyPriceUsd() => $_has(2);
  @$pb.TagNumber(3)
  void clearMonthlyPriceUsd() => $_clearField(3);
  @$pb.TagNumber(3)
  $1.Money ensureMonthlyPriceUsd() => $_ensure(2);

  @$pb.TagNumber(4)
  $1.Money get annualPriceUsd => $_getN(3);
  @$pb.TagNumber(4)
  set annualPriceUsd($1.Money value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasAnnualPriceUsd() => $_has(3);
  @$pb.TagNumber(4)
  void clearAnnualPriceUsd() => $_clearField(4);
  @$pb.TagNumber(4)
  $1.Money ensureAnnualPriceUsd() => $_ensure(3);

  @$pb.TagNumber(5)
  $1.Money get monthlyPriceVnd => $_getN(4);
  @$pb.TagNumber(5)
  set monthlyPriceVnd($1.Money value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasMonthlyPriceVnd() => $_has(4);
  @$pb.TagNumber(5)
  void clearMonthlyPriceVnd() => $_clearField(5);
  @$pb.TagNumber(5)
  $1.Money ensureMonthlyPriceVnd() => $_ensure(4);

  @$pb.TagNumber(6)
  $1.Money get annualPriceVnd => $_getN(5);
  @$pb.TagNumber(6)
  set annualPriceVnd($1.Money value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasAnnualPriceVnd() => $_has(5);
  @$pb.TagNumber(6)
  void clearAnnualPriceVnd() => $_clearField(6);
  @$pb.TagNumber(6)
  $1.Money ensureAnnualPriceVnd() => $_ensure(5);

  @$pb.TagNumber(7)
  $core.String get monthlyCredits => $_getSZ(6);
  @$pb.TagNumber(7)
  set monthlyCredits($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasMonthlyCredits() => $_has(6);
  @$pb.TagNumber(7)
  void clearMonthlyCredits() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get rolloverFraction => $_getSZ(7);
  @$pb.TagNumber(8)
  set rolloverFraction($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasRolloverFraction() => $_has(7);
  @$pb.TagNumber(8)
  void clearRolloverFraction() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.int get maxSeats => $_getIZ(8);
  @$pb.TagNumber(9)
  set maxSeats($core.int value) => $_setSignedInt32(8, value);
  @$pb.TagNumber(9)
  $core.bool hasMaxSeats() => $_has(8);
  @$pb.TagNumber(9)
  void clearMaxSeats() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.int get maxChannels => $_getIZ(9);
  @$pb.TagNumber(10)
  set maxChannels($core.int value) => $_setSignedInt32(9, value);
  @$pb.TagNumber(10)
  $core.bool hasMaxChannels() => $_has(9);
  @$pb.TagNumber(10)
  void clearMaxChannels() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.int get maxStorageGb => $_getIZ(10);
  @$pb.TagNumber(11)
  set maxStorageGb($core.int value) => $_setSignedInt32(10, value);
  @$pb.TagNumber(11)
  $core.bool hasMaxStorageGb() => $_has(10);
  @$pb.TagNumber(11)
  void clearMaxStorageGb() => $_clearField(11);

  @$pb.TagNumber(12)
  $core.bool get overageEligible => $_getBF(11);
  @$pb.TagNumber(12)
  set overageEligible($core.bool value) => $_setBool(11, value);
  @$pb.TagNumber(12)
  $core.bool hasOverageEligible() => $_has(11);
  @$pb.TagNumber(12)
  void clearOverageEligible() => $_clearField(12);
}

/// Canonical credit top-up pack entry (pricing_and_credits.md §5.7).
class CreditPackEntry extends $pb.GeneratedMessage {
  factory CreditPackEntry({
    $core.String? packCode,
    $core.String? displayName,
    $core.String? credits,
    $1.Money? priceUsd,
    $1.Money? priceVnd,
    $core.bool? neverExpires,
  }) {
    final result = CreditPackEntry._();
    if (packCode != null) result.packCode = packCode;
    if (displayName != null) result.displayName = displayName;
    if (credits != null) result.credits = credits;
    if (priceUsd != null) result.priceUsd = priceUsd;
    if (priceVnd != null) result.priceVnd = priceVnd;
    if (neverExpires != null) result.neverExpires = neverExpires;
    return result;
  }

  CreditPackEntry._();

  factory CreditPackEntry.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CreditPackEntry()..mergeFromBuffer(data, registry);
  factory CreditPackEntry.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CreditPackEntry()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CreditPackEntry',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.admin.v1'),
      createEmptyInstance: CreditPackEntry.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'packCode')
    ..aOS(2, _omitFieldNames ? '' : 'displayName')
    ..aOS(3, _omitFieldNames ? '' : 'credits')
    ..aOM<$1.Money>(4, _omitFieldNames ? '' : 'priceUsd',
        subBuilder: $1.Money.$_createMessage)
    ..aOM<$1.Money>(5, _omitFieldNames ? '' : 'priceVnd',
        subBuilder: $1.Money.$_createMessage)
    ..aOB(6, _omitFieldNames ? '' : 'neverExpires')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreditPackEntry clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreditPackEntry copyWith(void Function(CreditPackEntry) updates) =>
      super.copyWith((message) => updates(message as CreditPackEntry))
          as CreditPackEntry;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use CreditPackEntry() / CreditPackEntry.new instead')
  static CreditPackEntry create() => CreditPackEntry._();
  static $pb.GeneratedMessage $_createMessage() => CreditPackEntry._();
  @$core.override
  CreditPackEntry createEmptyInstance() => CreditPackEntry._();
  @$core.pragma('dart2js:noInline')
  static CreditPackEntry getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CreditPackEntry>(
          CreditPackEntry.$_createMessage);
  static CreditPackEntry? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get packCode => $_getSZ(0);
  @$pb.TagNumber(1)
  set packCode($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPackCode() => $_has(0);
  @$pb.TagNumber(1)
  void clearPackCode() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get displayName => $_getSZ(1);
  @$pb.TagNumber(2)
  set displayName($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasDisplayName() => $_has(1);
  @$pb.TagNumber(2)
  void clearDisplayName() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get credits => $_getSZ(2);
  @$pb.TagNumber(3)
  set credits($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasCredits() => $_has(2);
  @$pb.TagNumber(3)
  void clearCredits() => $_clearField(3);

  @$pb.TagNumber(4)
  $1.Money get priceUsd => $_getN(3);
  @$pb.TagNumber(4)
  set priceUsd($1.Money value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasPriceUsd() => $_has(3);
  @$pb.TagNumber(4)
  void clearPriceUsd() => $_clearField(4);
  @$pb.TagNumber(4)
  $1.Money ensurePriceUsd() => $_ensure(3);

  @$pb.TagNumber(5)
  $1.Money get priceVnd => $_getN(4);
  @$pb.TagNumber(5)
  set priceVnd($1.Money value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasPriceVnd() => $_has(4);
  @$pb.TagNumber(5)
  void clearPriceVnd() => $_clearField(5);
  @$pb.TagNumber(5)
  $1.Money ensurePriceVnd() => $_ensure(4);

  @$pb.TagNumber(6)
  $core.bool get neverExpires => $_getBF(5);
  @$pb.TagNumber(6)
  set neverExpires($core.bool value) => $_setBool(5, value);
  @$pb.TagNumber(6)
  $core.bool hasNeverExpires() => $_has(5);
  @$pb.TagNumber(6)
  void clearNeverExpires() => $_clearField(6);
}

/// Canonical module add-on entry (pricing_and_credits.md §4).
class AddonCatalogEntry extends $pb.GeneratedMessage {
  factory AddonCatalogEntry({
    $core.String? addonCode,
    $core.String? displayName,
    $1.Money? monthlyPriceUsd,
    $1.Money? monthlyPriceVnd,
    $core.Iterable<$core.String>? eligibleTiers,
    $1.Money? annualPriceUsd,
    $1.Money? annualPriceVnd,
  }) {
    final result = AddonCatalogEntry._();
    if (addonCode != null) result.addonCode = addonCode;
    if (displayName != null) result.displayName = displayName;
    if (monthlyPriceUsd != null) result.monthlyPriceUsd = monthlyPriceUsd;
    if (monthlyPriceVnd != null) result.monthlyPriceVnd = monthlyPriceVnd;
    if (eligibleTiers != null) result.eligibleTiers.addAll(eligibleTiers);
    if (annualPriceUsd != null) result.annualPriceUsd = annualPriceUsd;
    if (annualPriceVnd != null) result.annualPriceVnd = annualPriceVnd;
    return result;
  }

  AddonCatalogEntry._();

  factory AddonCatalogEntry.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      AddonCatalogEntry()..mergeFromBuffer(data, registry);
  factory AddonCatalogEntry.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      AddonCatalogEntry()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AddonCatalogEntry',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.admin.v1'),
      createEmptyInstance: AddonCatalogEntry.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'addonCode')
    ..aOS(2, _omitFieldNames ? '' : 'displayName')
    ..aOM<$1.Money>(3, _omitFieldNames ? '' : 'monthlyPriceUsd',
        subBuilder: $1.Money.$_createMessage)
    ..aOM<$1.Money>(4, _omitFieldNames ? '' : 'monthlyPriceVnd',
        subBuilder: $1.Money.$_createMessage)
    ..pPS(5, _omitFieldNames ? '' : 'eligibleTiers')
    ..aOM<$1.Money>(6, _omitFieldNames ? '' : 'annualPriceUsd',
        subBuilder: $1.Money.$_createMessage)
    ..aOM<$1.Money>(7, _omitFieldNames ? '' : 'annualPriceVnd',
        subBuilder: $1.Money.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AddonCatalogEntry clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AddonCatalogEntry copyWith(void Function(AddonCatalogEntry) updates) =>
      super.copyWith((message) => updates(message as AddonCatalogEntry))
          as AddonCatalogEntry;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use AddonCatalogEntry() / AddonCatalogEntry.new instead')
  static AddonCatalogEntry create() => AddonCatalogEntry._();
  static $pb.GeneratedMessage $_createMessage() => AddonCatalogEntry._();
  @$core.override
  AddonCatalogEntry createEmptyInstance() => AddonCatalogEntry._();
  @$core.pragma('dart2js:noInline')
  static AddonCatalogEntry getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AddonCatalogEntry>(
          AddonCatalogEntry.$_createMessage);
  static AddonCatalogEntry? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get addonCode => $_getSZ(0);
  @$pb.TagNumber(1)
  set addonCode($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAddonCode() => $_has(0);
  @$pb.TagNumber(1)
  void clearAddonCode() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get displayName => $_getSZ(1);
  @$pb.TagNumber(2)
  set displayName($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasDisplayName() => $_has(1);
  @$pb.TagNumber(2)
  void clearDisplayName() => $_clearField(2);

  @$pb.TagNumber(3)
  $1.Money get monthlyPriceUsd => $_getN(2);
  @$pb.TagNumber(3)
  set monthlyPriceUsd($1.Money value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasMonthlyPriceUsd() => $_has(2);
  @$pb.TagNumber(3)
  void clearMonthlyPriceUsd() => $_clearField(3);
  @$pb.TagNumber(3)
  $1.Money ensureMonthlyPriceUsd() => $_ensure(2);

  @$pb.TagNumber(4)
  $1.Money get monthlyPriceVnd => $_getN(3);
  @$pb.TagNumber(4)
  set monthlyPriceVnd($1.Money value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasMonthlyPriceVnd() => $_has(3);
  @$pb.TagNumber(4)
  void clearMonthlyPriceVnd() => $_clearField(4);
  @$pb.TagNumber(4)
  $1.Money ensureMonthlyPriceVnd() => $_ensure(3);

  @$pb.TagNumber(5)
  $pb.PbList<$core.String> get eligibleTiers => $_getList(4);

  @$pb.TagNumber(6)
  $1.Money get annualPriceUsd => $_getN(5);
  @$pb.TagNumber(6)
  set annualPriceUsd($1.Money value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasAnnualPriceUsd() => $_has(5);
  @$pb.TagNumber(6)
  void clearAnnualPriceUsd() => $_clearField(6);
  @$pb.TagNumber(6)
  $1.Money ensureAnnualPriceUsd() => $_ensure(5);

  @$pb.TagNumber(7)
  $1.Money get annualPriceVnd => $_getN(6);
  @$pb.TagNumber(7)
  set annualPriceVnd($1.Money value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasAnnualPriceVnd() => $_has(6);
  @$pb.TagNumber(7)
  void clearAnnualPriceVnd() => $_clearField(7);
  @$pb.TagNumber(7)
  $1.Money ensureAnnualPriceVnd() => $_ensure(6);
}

/// Payment method access gate descriptor (P8-02 all payment methods behind access gates).
class PaymentMethodAccessGate extends $pb.GeneratedMessage {
  factory PaymentMethodAccessGate({
    $core.String? methodType,
    $core.String? displayName,
    $core.String? providerCode,
    $core.String? capabilityState,
    $core.bool? accessGranted,
    $core.Iterable<$core.String>? eligibleTiers,
    $core.Iterable<$core.String>? supportedCurrencies,
    $core.String? gateReason,
  }) {
    final result = PaymentMethodAccessGate._();
    if (methodType != null) result.methodType = methodType;
    if (displayName != null) result.displayName = displayName;
    if (providerCode != null) result.providerCode = providerCode;
    if (capabilityState != null) result.capabilityState = capabilityState;
    if (accessGranted != null) result.accessGranted = accessGranted;
    if (eligibleTiers != null) result.eligibleTiers.addAll(eligibleTiers);
    if (supportedCurrencies != null)
      result.supportedCurrencies.addAll(supportedCurrencies);
    if (gateReason != null) result.gateReason = gateReason;
    return result;
  }

  PaymentMethodAccessGate._();

  factory PaymentMethodAccessGate.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PaymentMethodAccessGate()..mergeFromBuffer(data, registry);
  factory PaymentMethodAccessGate.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PaymentMethodAccessGate()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PaymentMethodAccessGate',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.admin.v1'),
      createEmptyInstance: PaymentMethodAccessGate.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'methodType')
    ..aOS(2, _omitFieldNames ? '' : 'displayName')
    ..aOS(3, _omitFieldNames ? '' : 'providerCode')
    ..aOS(4, _omitFieldNames ? '' : 'capabilityState')
    ..aOB(5, _omitFieldNames ? '' : 'accessGranted')
    ..pPS(6, _omitFieldNames ? '' : 'eligibleTiers')
    ..pPS(7, _omitFieldNames ? '' : 'supportedCurrencies')
    ..aOS(8, _omitFieldNames ? '' : 'gateReason')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PaymentMethodAccessGate clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PaymentMethodAccessGate copyWith(
          void Function(PaymentMethodAccessGate) updates) =>
      super.copyWith((message) => updates(message as PaymentMethodAccessGate))
          as PaymentMethodAccessGate;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use PaymentMethodAccessGate() / PaymentMethodAccessGate.new instead')
  static PaymentMethodAccessGate create() => PaymentMethodAccessGate._();
  static $pb.GeneratedMessage $_createMessage() => PaymentMethodAccessGate._();
  @$core.override
  PaymentMethodAccessGate createEmptyInstance() => PaymentMethodAccessGate._();
  @$core.pragma('dart2js:noInline')
  static PaymentMethodAccessGate getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PaymentMethodAccessGate>(
          PaymentMethodAccessGate.$_createMessage);
  static PaymentMethodAccessGate? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get methodType => $_getSZ(0);
  @$pb.TagNumber(1)
  set methodType($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasMethodType() => $_has(0);
  @$pb.TagNumber(1)
  void clearMethodType() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get displayName => $_getSZ(1);
  @$pb.TagNumber(2)
  set displayName($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasDisplayName() => $_has(1);
  @$pb.TagNumber(2)
  void clearDisplayName() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get providerCode => $_getSZ(2);
  @$pb.TagNumber(3)
  set providerCode($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasProviderCode() => $_has(2);
  @$pb.TagNumber(3)
  void clearProviderCode() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get capabilityState => $_getSZ(3);
  @$pb.TagNumber(4)
  set capabilityState($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasCapabilityState() => $_has(3);
  @$pb.TagNumber(4)
  void clearCapabilityState() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.bool get accessGranted => $_getBF(4);
  @$pb.TagNumber(5)
  set accessGranted($core.bool value) => $_setBool(4, value);
  @$pb.TagNumber(5)
  $core.bool hasAccessGranted() => $_has(4);
  @$pb.TagNumber(5)
  void clearAccessGranted() => $_clearField(5);

  @$pb.TagNumber(6)
  $pb.PbList<$core.String> get eligibleTiers => $_getList(5);

  @$pb.TagNumber(7)
  $pb.PbList<$core.String> get supportedCurrencies => $_getList(6);

  @$pb.TagNumber(8)
  $core.String get gateReason => $_getSZ(7);
  @$pb.TagNumber(8)
  set gateReason($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasGateReason() => $_has(7);
  @$pb.TagNumber(8)
  void clearGateReason() => $_clearField(8);
}

/// Subscription summary projection (§19.1 & P8-02 trial/dunning/pause/cancellation retention).
class SubscriptionSummary extends $pb.GeneratedMessage {
  factory SubscriptionSummary({
    $1.UUID? subscriptionId,
    $1.UUID? workspaceId,
    $core.String? plan,
    $core.String? billingInterval,
    SubscriptionStatus? status,
    $1.Money? amount,
    $2.Timestamp? currentPeriodStart,
    $2.Timestamp? currentPeriodEnd,
    $core.bool? cancelAtPeriodEnd,
    $2.Timestamp? canceledAt,
    $core.Iterable<$core.String>? addons,
    $core.Iterable<$core.String>? scheduledAddonRemovals,
    $2.Timestamp? trialEndsAt,
    $core.int? dunningDay,
    $core.int? dunningAttempt,
    $2.Timestamp? gracePeriodEndsAt,
    $core.bool? readOnlyMode,
    $core.String? readOnlyReason,
    $core.String? retentionPhase,
    $core.bool? retentionOfferApplied,
    $2.Timestamp? pausedAt,
    $2.Timestamp? pauseAutoResumesAt,
    $core.bool? overageTermsAccepted,
    $core.String? overageUsedCredits,
    $core.String? preservedPurchasedCredits,
  }) {
    final result = SubscriptionSummary._();
    if (subscriptionId != null) result.subscriptionId = subscriptionId;
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (plan != null) result.plan = plan;
    if (billingInterval != null) result.billingInterval = billingInterval;
    if (status != null) result.status = status;
    if (amount != null) result.amount = amount;
    if (currentPeriodStart != null)
      result.currentPeriodStart = currentPeriodStart;
    if (currentPeriodEnd != null) result.currentPeriodEnd = currentPeriodEnd;
    if (cancelAtPeriodEnd != null) result.cancelAtPeriodEnd = cancelAtPeriodEnd;
    if (canceledAt != null) result.canceledAt = canceledAt;
    if (addons != null) result.addons.addAll(addons);
    if (scheduledAddonRemovals != null)
      result.scheduledAddonRemovals.addAll(scheduledAddonRemovals);
    if (trialEndsAt != null) result.trialEndsAt = trialEndsAt;
    if (dunningDay != null) result.dunningDay = dunningDay;
    if (dunningAttempt != null) result.dunningAttempt = dunningAttempt;
    if (gracePeriodEndsAt != null) result.gracePeriodEndsAt = gracePeriodEndsAt;
    if (readOnlyMode != null) result.readOnlyMode = readOnlyMode;
    if (readOnlyReason != null) result.readOnlyReason = readOnlyReason;
    if (retentionPhase != null) result.retentionPhase = retentionPhase;
    if (retentionOfferApplied != null)
      result.retentionOfferApplied = retentionOfferApplied;
    if (pausedAt != null) result.pausedAt = pausedAt;
    if (pauseAutoResumesAt != null)
      result.pauseAutoResumesAt = pauseAutoResumesAt;
    if (overageTermsAccepted != null)
      result.overageTermsAccepted = overageTermsAccepted;
    if (overageUsedCredits != null)
      result.overageUsedCredits = overageUsedCredits;
    if (preservedPurchasedCredits != null)
      result.preservedPurchasedCredits = preservedPurchasedCredits;
    return result;
  }

  SubscriptionSummary._();

  factory SubscriptionSummary.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SubscriptionSummary()..mergeFromBuffer(data, registry);
  factory SubscriptionSummary.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SubscriptionSummary()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SubscriptionSummary',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.admin.v1'),
      createEmptyInstance: SubscriptionSummary.$_createMessage)
    ..aOM<$1.UUID>(1, _omitFieldNames ? '' : 'subscriptionId',
        subBuilder: $1.UUID.$_createMessage)
    ..aOM<$1.UUID>(2, _omitFieldNames ? '' : 'workspaceId',
        subBuilder: $1.UUID.$_createMessage)
    ..aOS(3, _omitFieldNames ? '' : 'plan')
    ..aOS(4, _omitFieldNames ? '' : 'billingInterval')
    ..aE<SubscriptionStatus>(5, _omitFieldNames ? '' : 'status',
        enumValues: SubscriptionStatus.values)
    ..aOM<$1.Money>(6, _omitFieldNames ? '' : 'amount',
        subBuilder: $1.Money.$_createMessage)
    ..aOM<$2.Timestamp>(7, _omitFieldNames ? '' : 'currentPeriodStart',
        subBuilder: $2.Timestamp.$_createMessage)
    ..aOM<$2.Timestamp>(8, _omitFieldNames ? '' : 'currentPeriodEnd',
        subBuilder: $2.Timestamp.$_createMessage)
    ..aOB(9, _omitFieldNames ? '' : 'cancelAtPeriodEnd')
    ..aOM<$2.Timestamp>(10, _omitFieldNames ? '' : 'canceledAt',
        subBuilder: $2.Timestamp.$_createMessage)
    ..pPS(11, _omitFieldNames ? '' : 'addons')
    ..pPS(12, _omitFieldNames ? '' : 'scheduledAddonRemovals')
    ..aOM<$2.Timestamp>(13, _omitFieldNames ? '' : 'trialEndsAt',
        subBuilder: $2.Timestamp.$_createMessage)
    ..aI(14, _omitFieldNames ? '' : 'dunningDay')
    ..aI(15, _omitFieldNames ? '' : 'dunningAttempt')
    ..aOM<$2.Timestamp>(16, _omitFieldNames ? '' : 'gracePeriodEndsAt',
        subBuilder: $2.Timestamp.$_createMessage)
    ..aOB(17, _omitFieldNames ? '' : 'readOnlyMode')
    ..aOS(18, _omitFieldNames ? '' : 'readOnlyReason')
    ..aOS(19, _omitFieldNames ? '' : 'retentionPhase')
    ..aOB(20, _omitFieldNames ? '' : 'retentionOfferApplied')
    ..aOM<$2.Timestamp>(21, _omitFieldNames ? '' : 'pausedAt',
        subBuilder: $2.Timestamp.$_createMessage)
    ..aOM<$2.Timestamp>(22, _omitFieldNames ? '' : 'pauseAutoResumesAt',
        subBuilder: $2.Timestamp.$_createMessage)
    ..aOB(23, _omitFieldNames ? '' : 'overageTermsAccepted')
    ..aOS(24, _omitFieldNames ? '' : 'overageUsedCredits')
    ..aOS(25, _omitFieldNames ? '' : 'preservedPurchasedCredits')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SubscriptionSummary clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SubscriptionSummary copyWith(void Function(SubscriptionSummary) updates) =>
      super.copyWith((message) => updates(message as SubscriptionSummary))
          as SubscriptionSummary;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core
      .Deprecated('Use SubscriptionSummary() / SubscriptionSummary.new instead')
  static SubscriptionSummary create() => SubscriptionSummary._();
  static $pb.GeneratedMessage $_createMessage() => SubscriptionSummary._();
  @$core.override
  SubscriptionSummary createEmptyInstance() => SubscriptionSummary._();
  @$core.pragma('dart2js:noInline')
  static SubscriptionSummary getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SubscriptionSummary>(
          SubscriptionSummary.$_createMessage);
  static SubscriptionSummary? _defaultInstance;

  @$pb.TagNumber(1)
  $1.UUID get subscriptionId => $_getN(0);
  @$pb.TagNumber(1)
  set subscriptionId($1.UUID value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasSubscriptionId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSubscriptionId() => $_clearField(1);
  @$pb.TagNumber(1)
  $1.UUID ensureSubscriptionId() => $_ensure(0);

  @$pb.TagNumber(2)
  $1.UUID get workspaceId => $_getN(1);
  @$pb.TagNumber(2)
  set workspaceId($1.UUID value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasWorkspaceId() => $_has(1);
  @$pb.TagNumber(2)
  void clearWorkspaceId() => $_clearField(2);
  @$pb.TagNumber(2)
  $1.UUID ensureWorkspaceId() => $_ensure(1);

  @$pb.TagNumber(3)
  $core.String get plan => $_getSZ(2);
  @$pb.TagNumber(3)
  set plan($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPlan() => $_has(2);
  @$pb.TagNumber(3)
  void clearPlan() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get billingInterval => $_getSZ(3);
  @$pb.TagNumber(4)
  set billingInterval($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasBillingInterval() => $_has(3);
  @$pb.TagNumber(4)
  void clearBillingInterval() => $_clearField(4);

  @$pb.TagNumber(5)
  SubscriptionStatus get status => $_getN(4);
  @$pb.TagNumber(5)
  set status(SubscriptionStatus value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasStatus() => $_has(4);
  @$pb.TagNumber(5)
  void clearStatus() => $_clearField(5);

  @$pb.TagNumber(6)
  $1.Money get amount => $_getN(5);
  @$pb.TagNumber(6)
  set amount($1.Money value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasAmount() => $_has(5);
  @$pb.TagNumber(6)
  void clearAmount() => $_clearField(6);
  @$pb.TagNumber(6)
  $1.Money ensureAmount() => $_ensure(5);

  @$pb.TagNumber(7)
  $2.Timestamp get currentPeriodStart => $_getN(6);
  @$pb.TagNumber(7)
  set currentPeriodStart($2.Timestamp value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasCurrentPeriodStart() => $_has(6);
  @$pb.TagNumber(7)
  void clearCurrentPeriodStart() => $_clearField(7);
  @$pb.TagNumber(7)
  $2.Timestamp ensureCurrentPeriodStart() => $_ensure(6);

  @$pb.TagNumber(8)
  $2.Timestamp get currentPeriodEnd => $_getN(7);
  @$pb.TagNumber(8)
  set currentPeriodEnd($2.Timestamp value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasCurrentPeriodEnd() => $_has(7);
  @$pb.TagNumber(8)
  void clearCurrentPeriodEnd() => $_clearField(8);
  @$pb.TagNumber(8)
  $2.Timestamp ensureCurrentPeriodEnd() => $_ensure(7);

  @$pb.TagNumber(9)
  $core.bool get cancelAtPeriodEnd => $_getBF(8);
  @$pb.TagNumber(9)
  set cancelAtPeriodEnd($core.bool value) => $_setBool(8, value);
  @$pb.TagNumber(9)
  $core.bool hasCancelAtPeriodEnd() => $_has(8);
  @$pb.TagNumber(9)
  void clearCancelAtPeriodEnd() => $_clearField(9);

  @$pb.TagNumber(10)
  $2.Timestamp get canceledAt => $_getN(9);
  @$pb.TagNumber(10)
  set canceledAt($2.Timestamp value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasCanceledAt() => $_has(9);
  @$pb.TagNumber(10)
  void clearCanceledAt() => $_clearField(10);
  @$pb.TagNumber(10)
  $2.Timestamp ensureCanceledAt() => $_ensure(9);

  @$pb.TagNumber(11)
  $pb.PbList<$core.String> get addons => $_getList(10);

  @$pb.TagNumber(12)
  $pb.PbList<$core.String> get scheduledAddonRemovals => $_getList(11);

  @$pb.TagNumber(13)
  $2.Timestamp get trialEndsAt => $_getN(12);
  @$pb.TagNumber(13)
  set trialEndsAt($2.Timestamp value) => $_setField(13, value);
  @$pb.TagNumber(13)
  $core.bool hasTrialEndsAt() => $_has(12);
  @$pb.TagNumber(13)
  void clearTrialEndsAt() => $_clearField(13);
  @$pb.TagNumber(13)
  $2.Timestamp ensureTrialEndsAt() => $_ensure(12);

  @$pb.TagNumber(14)
  $core.int get dunningDay => $_getIZ(13);
  @$pb.TagNumber(14)
  set dunningDay($core.int value) => $_setSignedInt32(13, value);
  @$pb.TagNumber(14)
  $core.bool hasDunningDay() => $_has(13);
  @$pb.TagNumber(14)
  void clearDunningDay() => $_clearField(14);

  @$pb.TagNumber(15)
  $core.int get dunningAttempt => $_getIZ(14);
  @$pb.TagNumber(15)
  set dunningAttempt($core.int value) => $_setSignedInt32(14, value);
  @$pb.TagNumber(15)
  $core.bool hasDunningAttempt() => $_has(14);
  @$pb.TagNumber(15)
  void clearDunningAttempt() => $_clearField(15);

  @$pb.TagNumber(16)
  $2.Timestamp get gracePeriodEndsAt => $_getN(15);
  @$pb.TagNumber(16)
  set gracePeriodEndsAt($2.Timestamp value) => $_setField(16, value);
  @$pb.TagNumber(16)
  $core.bool hasGracePeriodEndsAt() => $_has(15);
  @$pb.TagNumber(16)
  void clearGracePeriodEndsAt() => $_clearField(16);
  @$pb.TagNumber(16)
  $2.Timestamp ensureGracePeriodEndsAt() => $_ensure(15);

  @$pb.TagNumber(17)
  $core.bool get readOnlyMode => $_getBF(16);
  @$pb.TagNumber(17)
  set readOnlyMode($core.bool value) => $_setBool(16, value);
  @$pb.TagNumber(17)
  $core.bool hasReadOnlyMode() => $_has(16);
  @$pb.TagNumber(17)
  void clearReadOnlyMode() => $_clearField(17);

  @$pb.TagNumber(18)
  $core.String get readOnlyReason => $_getSZ(17);
  @$pb.TagNumber(18)
  set readOnlyReason($core.String value) => $_setString(17, value);
  @$pb.TagNumber(18)
  $core.bool hasReadOnlyReason() => $_has(17);
  @$pb.TagNumber(18)
  void clearReadOnlyReason() => $_clearField(18);

  @$pb.TagNumber(19)
  $core.String get retentionPhase => $_getSZ(18);
  @$pb.TagNumber(19)
  set retentionPhase($core.String value) => $_setString(18, value);
  @$pb.TagNumber(19)
  $core.bool hasRetentionPhase() => $_has(18);
  @$pb.TagNumber(19)
  void clearRetentionPhase() => $_clearField(19);

  @$pb.TagNumber(20)
  $core.bool get retentionOfferApplied => $_getBF(19);
  @$pb.TagNumber(20)
  set retentionOfferApplied($core.bool value) => $_setBool(19, value);
  @$pb.TagNumber(20)
  $core.bool hasRetentionOfferApplied() => $_has(19);
  @$pb.TagNumber(20)
  void clearRetentionOfferApplied() => $_clearField(20);

  @$pb.TagNumber(21)
  $2.Timestamp get pausedAt => $_getN(20);
  @$pb.TagNumber(21)
  set pausedAt($2.Timestamp value) => $_setField(21, value);
  @$pb.TagNumber(21)
  $core.bool hasPausedAt() => $_has(20);
  @$pb.TagNumber(21)
  void clearPausedAt() => $_clearField(21);
  @$pb.TagNumber(21)
  $2.Timestamp ensurePausedAt() => $_ensure(20);

  @$pb.TagNumber(22)
  $2.Timestamp get pauseAutoResumesAt => $_getN(21);
  @$pb.TagNumber(22)
  set pauseAutoResumesAt($2.Timestamp value) => $_setField(22, value);
  @$pb.TagNumber(22)
  $core.bool hasPauseAutoResumesAt() => $_has(21);
  @$pb.TagNumber(22)
  void clearPauseAutoResumesAt() => $_clearField(22);
  @$pb.TagNumber(22)
  $2.Timestamp ensurePauseAutoResumesAt() => $_ensure(21);

  @$pb.TagNumber(23)
  $core.bool get overageTermsAccepted => $_getBF(22);
  @$pb.TagNumber(23)
  set overageTermsAccepted($core.bool value) => $_setBool(22, value);
  @$pb.TagNumber(23)
  $core.bool hasOverageTermsAccepted() => $_has(22);
  @$pb.TagNumber(23)
  void clearOverageTermsAccepted() => $_clearField(23);

  @$pb.TagNumber(24)
  $core.String get overageUsedCredits => $_getSZ(23);
  @$pb.TagNumber(24)
  set overageUsedCredits($core.String value) => $_setString(23, value);
  @$pb.TagNumber(24)
  $core.bool hasOverageUsedCredits() => $_has(23);
  @$pb.TagNumber(24)
  void clearOverageUsedCredits() => $_clearField(24);

  @$pb.TagNumber(25)
  $core.String get preservedPurchasedCredits => $_getSZ(24);
  @$pb.TagNumber(25)
  set preservedPurchasedCredits($core.String value) => $_setString(24, value);
  @$pb.TagNumber(25)
  $core.bool hasPreservedPurchasedCredits() => $_has(24);
  @$pb.TagNumber(25)
  void clearPreservedPurchasedCredits() => $_clearField(25);
}

/// Payment method summary projection (§19.1C).
class PaymentMethodSummary extends $pb.GeneratedMessage {
  factory PaymentMethodSummary({
    $1.UUID? paymentMethodId,
    $core.String? stripePaymentMethodId,
    $core.String? type,
    $core.String? cardBrand,
    $core.String? cardLast4,
    $core.int? cardExpMonth,
    $core.int? cardExpYear,
    $core.bool? isDefault,
    $core.String? accessGateStatus,
    $core.String? billingName,
    $core.String? billingEmail,
  }) {
    final result = PaymentMethodSummary._();
    if (paymentMethodId != null) result.paymentMethodId = paymentMethodId;
    if (stripePaymentMethodId != null)
      result.stripePaymentMethodId = stripePaymentMethodId;
    if (type != null) result.type = type;
    if (cardBrand != null) result.cardBrand = cardBrand;
    if (cardLast4 != null) result.cardLast4 = cardLast4;
    if (cardExpMonth != null) result.cardExpMonth = cardExpMonth;
    if (cardExpYear != null) result.cardExpYear = cardExpYear;
    if (isDefault != null) result.isDefault = isDefault;
    if (accessGateStatus != null) result.accessGateStatus = accessGateStatus;
    if (billingName != null) result.billingName = billingName;
    if (billingEmail != null) result.billingEmail = billingEmail;
    return result;
  }

  PaymentMethodSummary._();

  factory PaymentMethodSummary.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PaymentMethodSummary()..mergeFromBuffer(data, registry);
  factory PaymentMethodSummary.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PaymentMethodSummary()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PaymentMethodSummary',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.admin.v1'),
      createEmptyInstance: PaymentMethodSummary.$_createMessage)
    ..aOM<$1.UUID>(1, _omitFieldNames ? '' : 'paymentMethodId',
        subBuilder: $1.UUID.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'stripePaymentMethodId')
    ..aOS(3, _omitFieldNames ? '' : 'type')
    ..aOS(4, _omitFieldNames ? '' : 'cardBrand')
    ..aOS(5, _omitFieldNames ? '' : 'cardLast4')
    ..aI(6, _omitFieldNames ? '' : 'cardExpMonth')
    ..aI(7, _omitFieldNames ? '' : 'cardExpYear')
    ..aOB(8, _omitFieldNames ? '' : 'isDefault')
    ..aOS(9, _omitFieldNames ? '' : 'accessGateStatus')
    ..aOS(10, _omitFieldNames ? '' : 'billingName')
    ..aOS(11, _omitFieldNames ? '' : 'billingEmail')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PaymentMethodSummary clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PaymentMethodSummary copyWith(void Function(PaymentMethodSummary) updates) =>
      super.copyWith((message) => updates(message as PaymentMethodSummary))
          as PaymentMethodSummary;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use PaymentMethodSummary() / PaymentMethodSummary.new instead')
  static PaymentMethodSummary create() => PaymentMethodSummary._();
  static $pb.GeneratedMessage $_createMessage() => PaymentMethodSummary._();
  @$core.override
  PaymentMethodSummary createEmptyInstance() => PaymentMethodSummary._();
  @$core.pragma('dart2js:noInline')
  static PaymentMethodSummary getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PaymentMethodSummary>(
          PaymentMethodSummary.$_createMessage);
  static PaymentMethodSummary? _defaultInstance;

  @$pb.TagNumber(1)
  $1.UUID get paymentMethodId => $_getN(0);
  @$pb.TagNumber(1)
  set paymentMethodId($1.UUID value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasPaymentMethodId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPaymentMethodId() => $_clearField(1);
  @$pb.TagNumber(1)
  $1.UUID ensurePaymentMethodId() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get stripePaymentMethodId => $_getSZ(1);
  @$pb.TagNumber(2)
  set stripePaymentMethodId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasStripePaymentMethodId() => $_has(1);
  @$pb.TagNumber(2)
  void clearStripePaymentMethodId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get type => $_getSZ(2);
  @$pb.TagNumber(3)
  set type($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasType() => $_has(2);
  @$pb.TagNumber(3)
  void clearType() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get cardBrand => $_getSZ(3);
  @$pb.TagNumber(4)
  set cardBrand($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasCardBrand() => $_has(3);
  @$pb.TagNumber(4)
  void clearCardBrand() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get cardLast4 => $_getSZ(4);
  @$pb.TagNumber(5)
  set cardLast4($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasCardLast4() => $_has(4);
  @$pb.TagNumber(5)
  void clearCardLast4() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.int get cardExpMonth => $_getIZ(5);
  @$pb.TagNumber(6)
  set cardExpMonth($core.int value) => $_setSignedInt32(5, value);
  @$pb.TagNumber(6)
  $core.bool hasCardExpMonth() => $_has(5);
  @$pb.TagNumber(6)
  void clearCardExpMonth() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.int get cardExpYear => $_getIZ(6);
  @$pb.TagNumber(7)
  set cardExpYear($core.int value) => $_setSignedInt32(6, value);
  @$pb.TagNumber(7)
  $core.bool hasCardExpYear() => $_has(6);
  @$pb.TagNumber(7)
  void clearCardExpYear() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.bool get isDefault => $_getBF(7);
  @$pb.TagNumber(8)
  set isDefault($core.bool value) => $_setBool(7, value);
  @$pb.TagNumber(8)
  $core.bool hasIsDefault() => $_has(7);
  @$pb.TagNumber(8)
  void clearIsDefault() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get accessGateStatus => $_getSZ(8);
  @$pb.TagNumber(9)
  set accessGateStatus($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasAccessGateStatus() => $_has(8);
  @$pb.TagNumber(9)
  void clearAccessGateStatus() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.String get billingName => $_getSZ(9);
  @$pb.TagNumber(10)
  set billingName($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasBillingName() => $_has(9);
  @$pb.TagNumber(10)
  void clearBillingName() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.String get billingEmail => $_getSZ(10);
  @$pb.TagNumber(11)
  set billingEmail($core.String value) => $_setString(10, value);
  @$pb.TagNumber(11)
  $core.bool hasBillingEmail() => $_has(10);
  @$pb.TagNumber(11)
  void clearBillingEmail() => $_clearField(11);
}

/// Invoice summary projection (§19.1B).
class InvoiceSummary extends $pb.GeneratedMessage {
  factory InvoiceSummary({
    $1.UUID? invoiceId,
    $core.String? invoiceNumber,
    InvoiceStatus? status,
    $1.Money? subtotal,
    $1.Money? discountAmount,
    $1.Money? taxAmount,
    $1.Money? total,
    $1.Money? amountPaid,
    $1.Money? amountDue,
    $core.String? invoicePdfUrl,
    $core.String? hostedInvoiceUrl,
    $2.Timestamp? periodStart,
    $2.Timestamp? periodEnd,
    $2.Timestamp? paidAt,
    $2.Timestamp? createdAt,
  }) {
    final result = InvoiceSummary._();
    if (invoiceId != null) result.invoiceId = invoiceId;
    if (invoiceNumber != null) result.invoiceNumber = invoiceNumber;
    if (status != null) result.status = status;
    if (subtotal != null) result.subtotal = subtotal;
    if (discountAmount != null) result.discountAmount = discountAmount;
    if (taxAmount != null) result.taxAmount = taxAmount;
    if (total != null) result.total = total;
    if (amountPaid != null) result.amountPaid = amountPaid;
    if (amountDue != null) result.amountDue = amountDue;
    if (invoicePdfUrl != null) result.invoicePdfUrl = invoicePdfUrl;
    if (hostedInvoiceUrl != null) result.hostedInvoiceUrl = hostedInvoiceUrl;
    if (periodStart != null) result.periodStart = periodStart;
    if (periodEnd != null) result.periodEnd = periodEnd;
    if (paidAt != null) result.paidAt = paidAt;
    if (createdAt != null) result.createdAt = createdAt;
    return result;
  }

  InvoiceSummary._();

  factory InvoiceSummary.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      InvoiceSummary()..mergeFromBuffer(data, registry);
  factory InvoiceSummary.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      InvoiceSummary()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'InvoiceSummary',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.admin.v1'),
      createEmptyInstance: InvoiceSummary.$_createMessage)
    ..aOM<$1.UUID>(1, _omitFieldNames ? '' : 'invoiceId',
        subBuilder: $1.UUID.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'invoiceNumber')
    ..aE<InvoiceStatus>(3, _omitFieldNames ? '' : 'status',
        enumValues: InvoiceStatus.values)
    ..aOM<$1.Money>(4, _omitFieldNames ? '' : 'subtotal',
        subBuilder: $1.Money.$_createMessage)
    ..aOM<$1.Money>(5, _omitFieldNames ? '' : 'discountAmount',
        subBuilder: $1.Money.$_createMessage)
    ..aOM<$1.Money>(6, _omitFieldNames ? '' : 'taxAmount',
        subBuilder: $1.Money.$_createMessage)
    ..aOM<$1.Money>(7, _omitFieldNames ? '' : 'total',
        subBuilder: $1.Money.$_createMessage)
    ..aOM<$1.Money>(8, _omitFieldNames ? '' : 'amountPaid',
        subBuilder: $1.Money.$_createMessage)
    ..aOM<$1.Money>(9, _omitFieldNames ? '' : 'amountDue',
        subBuilder: $1.Money.$_createMessage)
    ..aOS(10, _omitFieldNames ? '' : 'invoicePdfUrl')
    ..aOS(11, _omitFieldNames ? '' : 'hostedInvoiceUrl')
    ..aOM<$2.Timestamp>(12, _omitFieldNames ? '' : 'periodStart',
        subBuilder: $2.Timestamp.$_createMessage)
    ..aOM<$2.Timestamp>(13, _omitFieldNames ? '' : 'periodEnd',
        subBuilder: $2.Timestamp.$_createMessage)
    ..aOM<$2.Timestamp>(14, _omitFieldNames ? '' : 'paidAt',
        subBuilder: $2.Timestamp.$_createMessage)
    ..aOM<$2.Timestamp>(15, _omitFieldNames ? '' : 'createdAt',
        subBuilder: $2.Timestamp.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  InvoiceSummary clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  InvoiceSummary copyWith(void Function(InvoiceSummary) updates) =>
      super.copyWith((message) => updates(message as InvoiceSummary))
          as InvoiceSummary;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use InvoiceSummary() / InvoiceSummary.new instead')
  static InvoiceSummary create() => InvoiceSummary._();
  static $pb.GeneratedMessage $_createMessage() => InvoiceSummary._();
  @$core.override
  InvoiceSummary createEmptyInstance() => InvoiceSummary._();
  @$core.pragma('dart2js:noInline')
  static InvoiceSummary getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<InvoiceSummary>(
          InvoiceSummary.$_createMessage);
  static InvoiceSummary? _defaultInstance;

  @$pb.TagNumber(1)
  $1.UUID get invoiceId => $_getN(0);
  @$pb.TagNumber(1)
  set invoiceId($1.UUID value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasInvoiceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearInvoiceId() => $_clearField(1);
  @$pb.TagNumber(1)
  $1.UUID ensureInvoiceId() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get invoiceNumber => $_getSZ(1);
  @$pb.TagNumber(2)
  set invoiceNumber($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasInvoiceNumber() => $_has(1);
  @$pb.TagNumber(2)
  void clearInvoiceNumber() => $_clearField(2);

  @$pb.TagNumber(3)
  InvoiceStatus get status => $_getN(2);
  @$pb.TagNumber(3)
  set status(InvoiceStatus value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasStatus() => $_has(2);
  @$pb.TagNumber(3)
  void clearStatus() => $_clearField(3);

  @$pb.TagNumber(4)
  $1.Money get subtotal => $_getN(3);
  @$pb.TagNumber(4)
  set subtotal($1.Money value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasSubtotal() => $_has(3);
  @$pb.TagNumber(4)
  void clearSubtotal() => $_clearField(4);
  @$pb.TagNumber(4)
  $1.Money ensureSubtotal() => $_ensure(3);

  @$pb.TagNumber(5)
  $1.Money get discountAmount => $_getN(4);
  @$pb.TagNumber(5)
  set discountAmount($1.Money value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasDiscountAmount() => $_has(4);
  @$pb.TagNumber(5)
  void clearDiscountAmount() => $_clearField(5);
  @$pb.TagNumber(5)
  $1.Money ensureDiscountAmount() => $_ensure(4);

  @$pb.TagNumber(6)
  $1.Money get taxAmount => $_getN(5);
  @$pb.TagNumber(6)
  set taxAmount($1.Money value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasTaxAmount() => $_has(5);
  @$pb.TagNumber(6)
  void clearTaxAmount() => $_clearField(6);
  @$pb.TagNumber(6)
  $1.Money ensureTaxAmount() => $_ensure(5);

  @$pb.TagNumber(7)
  $1.Money get total => $_getN(6);
  @$pb.TagNumber(7)
  set total($1.Money value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasTotal() => $_has(6);
  @$pb.TagNumber(7)
  void clearTotal() => $_clearField(7);
  @$pb.TagNumber(7)
  $1.Money ensureTotal() => $_ensure(6);

  @$pb.TagNumber(8)
  $1.Money get amountPaid => $_getN(7);
  @$pb.TagNumber(8)
  set amountPaid($1.Money value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasAmountPaid() => $_has(7);
  @$pb.TagNumber(8)
  void clearAmountPaid() => $_clearField(8);
  @$pb.TagNumber(8)
  $1.Money ensureAmountPaid() => $_ensure(7);

  @$pb.TagNumber(9)
  $1.Money get amountDue => $_getN(8);
  @$pb.TagNumber(9)
  set amountDue($1.Money value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasAmountDue() => $_has(8);
  @$pb.TagNumber(9)
  void clearAmountDue() => $_clearField(9);
  @$pb.TagNumber(9)
  $1.Money ensureAmountDue() => $_ensure(8);

  @$pb.TagNumber(10)
  $core.String get invoicePdfUrl => $_getSZ(9);
  @$pb.TagNumber(10)
  set invoicePdfUrl($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasInvoicePdfUrl() => $_has(9);
  @$pb.TagNumber(10)
  void clearInvoicePdfUrl() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.String get hostedInvoiceUrl => $_getSZ(10);
  @$pb.TagNumber(11)
  set hostedInvoiceUrl($core.String value) => $_setString(10, value);
  @$pb.TagNumber(11)
  $core.bool hasHostedInvoiceUrl() => $_has(10);
  @$pb.TagNumber(11)
  void clearHostedInvoiceUrl() => $_clearField(11);

  @$pb.TagNumber(12)
  $2.Timestamp get periodStart => $_getN(11);
  @$pb.TagNumber(12)
  set periodStart($2.Timestamp value) => $_setField(12, value);
  @$pb.TagNumber(12)
  $core.bool hasPeriodStart() => $_has(11);
  @$pb.TagNumber(12)
  void clearPeriodStart() => $_clearField(12);
  @$pb.TagNumber(12)
  $2.Timestamp ensurePeriodStart() => $_ensure(11);

  @$pb.TagNumber(13)
  $2.Timestamp get periodEnd => $_getN(12);
  @$pb.TagNumber(13)
  set periodEnd($2.Timestamp value) => $_setField(13, value);
  @$pb.TagNumber(13)
  $core.bool hasPeriodEnd() => $_has(12);
  @$pb.TagNumber(13)
  void clearPeriodEnd() => $_clearField(13);
  @$pb.TagNumber(13)
  $2.Timestamp ensurePeriodEnd() => $_ensure(12);

  @$pb.TagNumber(14)
  $2.Timestamp get paidAt => $_getN(13);
  @$pb.TagNumber(14)
  set paidAt($2.Timestamp value) => $_setField(14, value);
  @$pb.TagNumber(14)
  $core.bool hasPaidAt() => $_has(13);
  @$pb.TagNumber(14)
  void clearPaidAt() => $_clearField(14);
  @$pb.TagNumber(14)
  $2.Timestamp ensurePaidAt() => $_ensure(13);

  @$pb.TagNumber(15)
  $2.Timestamp get createdAt => $_getN(14);
  @$pb.TagNumber(15)
  set createdAt($2.Timestamp value) => $_setField(15, value);
  @$pb.TagNumber(15)
  $core.bool hasCreatedAt() => $_has(14);
  @$pb.TagNumber(15)
  void clearCreatedAt() => $_clearField(15);
  @$pb.TagNumber(15)
  $2.Timestamp ensureCreatedAt() => $_ensure(14);
}

/// Auto-refill configuration for workspace credit top-ups (W120).
class AutoRefillConfig extends $pb.GeneratedMessage {
  factory AutoRefillConfig({
    $core.bool? enabled,
    $core.String? thresholdCredits,
    $core.String? packCode,
  }) {
    final result = AutoRefillConfig._();
    if (enabled != null) result.enabled = enabled;
    if (thresholdCredits != null) result.thresholdCredits = thresholdCredits;
    if (packCode != null) result.packCode = packCode;
    return result;
  }

  AutoRefillConfig._();

  factory AutoRefillConfig.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      AutoRefillConfig()..mergeFromBuffer(data, registry);
  factory AutoRefillConfig.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      AutoRefillConfig()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AutoRefillConfig',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.admin.v1'),
      createEmptyInstance: AutoRefillConfig.$_createMessage)
    ..aOB(1, _omitFieldNames ? '' : 'enabled')
    ..aOS(2, _omitFieldNames ? '' : 'thresholdCredits')
    ..aOS(3, _omitFieldNames ? '' : 'packCode')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AutoRefillConfig clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AutoRefillConfig copyWith(void Function(AutoRefillConfig) updates) =>
      super.copyWith((message) => updates(message as AutoRefillConfig))
          as AutoRefillConfig;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use AutoRefillConfig() / AutoRefillConfig.new instead')
  static AutoRefillConfig create() => AutoRefillConfig._();
  static $pb.GeneratedMessage $_createMessage() => AutoRefillConfig._();
  @$core.override
  AutoRefillConfig createEmptyInstance() => AutoRefillConfig._();
  @$core.pragma('dart2js:noInline')
  static AutoRefillConfig getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AutoRefillConfig>(
          AutoRefillConfig.$_createMessage);
  static AutoRefillConfig? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get enabled => $_getBF(0);
  @$pb.TagNumber(1)
  set enabled($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasEnabled() => $_has(0);
  @$pb.TagNumber(1)
  void clearEnabled() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get thresholdCredits => $_getSZ(1);
  @$pb.TagNumber(2)
  set thresholdCredits($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasThresholdCredits() => $_has(1);
  @$pb.TagNumber(2)
  void clearThresholdCredits() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get packCode => $_getSZ(2);
  @$pb.TagNumber(3)
  set packCode($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPackCode() => $_has(2);
  @$pb.TagNumber(3)
  void clearPackCode() => $_clearField(3);
}

/// Usage breakdown entry by operation type (W121).
class OperationUsageBreakdown extends $pb.GeneratedMessage {
  factory OperationUsageBreakdown({
    $core.String? operationType,
    $core.String? creditsUsed,
    $fixnum.Int64? operationCount,
  }) {
    final result = OperationUsageBreakdown._();
    if (operationType != null) result.operationType = operationType;
    if (creditsUsed != null) result.creditsUsed = creditsUsed;
    if (operationCount != null) result.operationCount = operationCount;
    return result;
  }

  OperationUsageBreakdown._();

  factory OperationUsageBreakdown.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      OperationUsageBreakdown()..mergeFromBuffer(data, registry);
  factory OperationUsageBreakdown.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      OperationUsageBreakdown()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'OperationUsageBreakdown',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.admin.v1'),
      createEmptyInstance: OperationUsageBreakdown.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'operationType')
    ..aOS(2, _omitFieldNames ? '' : 'creditsUsed')
    ..aInt64(3, _omitFieldNames ? '' : 'operationCount')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OperationUsageBreakdown clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OperationUsageBreakdown copyWith(
          void Function(OperationUsageBreakdown) updates) =>
      super.copyWith((message) => updates(message as OperationUsageBreakdown))
          as OperationUsageBreakdown;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use OperationUsageBreakdown() / OperationUsageBreakdown.new instead')
  static OperationUsageBreakdown create() => OperationUsageBreakdown._();
  static $pb.GeneratedMessage $_createMessage() => OperationUsageBreakdown._();
  @$core.override
  OperationUsageBreakdown createEmptyInstance() => OperationUsageBreakdown._();
  @$core.pragma('dart2js:noInline')
  static OperationUsageBreakdown getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<OperationUsageBreakdown>(
          OperationUsageBreakdown.$_createMessage);
  static OperationUsageBreakdown? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get operationType => $_getSZ(0);
  @$pb.TagNumber(1)
  set operationType($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasOperationType() => $_has(0);
  @$pb.TagNumber(1)
  void clearOperationType() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get creditsUsed => $_getSZ(1);
  @$pb.TagNumber(2)
  set creditsUsed($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCreditsUsed() => $_has(1);
  @$pb.TagNumber(2)
  void clearCreditsUsed() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get operationCount => $_getI64(2);
  @$pb.TagNumber(3)
  set operationCount($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasOperationCount() => $_has(2);
  @$pb.TagNumber(3)
  void clearOperationCount() => $_clearField(3);
}

class GetBillingSummaryRequest extends $pb.GeneratedMessage {
  factory GetBillingSummaryRequest({
    $1.UUID? workspaceId,
  }) {
    final result = GetBillingSummaryRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    return result;
  }

  GetBillingSummaryRequest._();

  factory GetBillingSummaryRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetBillingSummaryRequest()..mergeFromBuffer(data, registry);
  factory GetBillingSummaryRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetBillingSummaryRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetBillingSummaryRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.admin.v1'),
      createEmptyInstance: GetBillingSummaryRequest.$_createMessage)
    ..aOM<$1.UUID>(1, _omitFieldNames ? '' : 'workspaceId',
        subBuilder: $1.UUID.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetBillingSummaryRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetBillingSummaryRequest copyWith(
          void Function(GetBillingSummaryRequest) updates) =>
      super.copyWith((message) => updates(message as GetBillingSummaryRequest))
          as GetBillingSummaryRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use GetBillingSummaryRequest() / GetBillingSummaryRequest.new instead')
  static GetBillingSummaryRequest create() => GetBillingSummaryRequest._();
  static $pb.GeneratedMessage $_createMessage() => GetBillingSummaryRequest._();
  @$core.override
  GetBillingSummaryRequest createEmptyInstance() =>
      GetBillingSummaryRequest._();
  @$core.pragma('dart2js:noInline')
  static GetBillingSummaryRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetBillingSummaryRequest>(
          GetBillingSummaryRequest.$_createMessage);
  static GetBillingSummaryRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $1.UUID get workspaceId => $_getN(0);
  @$pb.TagNumber(1)
  set workspaceId($1.UUID value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);
  @$pb.TagNumber(1)
  $1.UUID ensureWorkspaceId() => $_ensure(0);
}

class GetBillingSummaryResponse extends $pb.GeneratedMessage {
  factory GetBillingSummaryResponse({
    SubscriptionSummary? subscription,
    CreditBalance? creditBalance,
    PaymentMethodSummary? defaultPaymentMethod,
    $core.Iterable<InvoiceSummary>? recentInvoices,
    $core.String? pricebookVersion,
  }) {
    final result = GetBillingSummaryResponse._();
    if (subscription != null) result.subscription = subscription;
    if (creditBalance != null) result.creditBalance = creditBalance;
    if (defaultPaymentMethod != null)
      result.defaultPaymentMethod = defaultPaymentMethod;
    if (recentInvoices != null) result.recentInvoices.addAll(recentInvoices);
    if (pricebookVersion != null) result.pricebookVersion = pricebookVersion;
    return result;
  }

  GetBillingSummaryResponse._();

  factory GetBillingSummaryResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetBillingSummaryResponse()..mergeFromBuffer(data, registry);
  factory GetBillingSummaryResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetBillingSummaryResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetBillingSummaryResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.admin.v1'),
      createEmptyInstance: GetBillingSummaryResponse.$_createMessage)
    ..aOM<SubscriptionSummary>(1, _omitFieldNames ? '' : 'subscription',
        subBuilder: SubscriptionSummary.$_createMessage)
    ..aOM<CreditBalance>(2, _omitFieldNames ? '' : 'creditBalance',
        subBuilder: CreditBalance.$_createMessage)
    ..aOM<PaymentMethodSummary>(
        3, _omitFieldNames ? '' : 'defaultPaymentMethod',
        subBuilder: PaymentMethodSummary.$_createMessage)
    ..pPM<InvoiceSummary>(4, _omitFieldNames ? '' : 'recentInvoices',
        subBuilder: InvoiceSummary.$_createMessage)
    ..aOS(5, _omitFieldNames ? '' : 'pricebookVersion')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetBillingSummaryResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetBillingSummaryResponse copyWith(
          void Function(GetBillingSummaryResponse) updates) =>
      super.copyWith((message) => updates(message as GetBillingSummaryResponse))
          as GetBillingSummaryResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use GetBillingSummaryResponse() / GetBillingSummaryResponse.new instead')
  static GetBillingSummaryResponse create() => GetBillingSummaryResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      GetBillingSummaryResponse._();
  @$core.override
  GetBillingSummaryResponse createEmptyInstance() =>
      GetBillingSummaryResponse._();
  @$core.pragma('dart2js:noInline')
  static GetBillingSummaryResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetBillingSummaryResponse>(
          GetBillingSummaryResponse.$_createMessage);
  static GetBillingSummaryResponse? _defaultInstance;

  @$pb.TagNumber(1)
  SubscriptionSummary get subscription => $_getN(0);
  @$pb.TagNumber(1)
  set subscription(SubscriptionSummary value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasSubscription() => $_has(0);
  @$pb.TagNumber(1)
  void clearSubscription() => $_clearField(1);
  @$pb.TagNumber(1)
  SubscriptionSummary ensureSubscription() => $_ensure(0);

  @$pb.TagNumber(2)
  CreditBalance get creditBalance => $_getN(1);
  @$pb.TagNumber(2)
  set creditBalance(CreditBalance value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasCreditBalance() => $_has(1);
  @$pb.TagNumber(2)
  void clearCreditBalance() => $_clearField(2);
  @$pb.TagNumber(2)
  CreditBalance ensureCreditBalance() => $_ensure(1);

  @$pb.TagNumber(3)
  PaymentMethodSummary get defaultPaymentMethod => $_getN(2);
  @$pb.TagNumber(3)
  set defaultPaymentMethod(PaymentMethodSummary value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasDefaultPaymentMethod() => $_has(2);
  @$pb.TagNumber(3)
  void clearDefaultPaymentMethod() => $_clearField(3);
  @$pb.TagNumber(3)
  PaymentMethodSummary ensureDefaultPaymentMethod() => $_ensure(2);

  @$pb.TagNumber(4)
  $pb.PbList<InvoiceSummary> get recentInvoices => $_getList(3);

  @$pb.TagNumber(5)
  $core.String get pricebookVersion => $_getSZ(4);
  @$pb.TagNumber(5)
  set pricebookVersion($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasPricebookVersion() => $_has(4);
  @$pb.TagNumber(5)
  void clearPricebookVersion() => $_clearField(5);
}

class GetCreditBalanceRequest extends $pb.GeneratedMessage {
  factory GetCreditBalanceRequest({
    $1.UUID? workspaceId,
  }) {
    final result = GetCreditBalanceRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    return result;
  }

  GetCreditBalanceRequest._();

  factory GetCreditBalanceRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetCreditBalanceRequest()..mergeFromBuffer(data, registry);
  factory GetCreditBalanceRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetCreditBalanceRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetCreditBalanceRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.admin.v1'),
      createEmptyInstance: GetCreditBalanceRequest.$_createMessage)
    ..aOM<$1.UUID>(1, _omitFieldNames ? '' : 'workspaceId',
        subBuilder: $1.UUID.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetCreditBalanceRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetCreditBalanceRequest copyWith(
          void Function(GetCreditBalanceRequest) updates) =>
      super.copyWith((message) => updates(message as GetCreditBalanceRequest))
          as GetCreditBalanceRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use GetCreditBalanceRequest() / GetCreditBalanceRequest.new instead')
  static GetCreditBalanceRequest create() => GetCreditBalanceRequest._();
  static $pb.GeneratedMessage $_createMessage() => GetCreditBalanceRequest._();
  @$core.override
  GetCreditBalanceRequest createEmptyInstance() => GetCreditBalanceRequest._();
  @$core.pragma('dart2js:noInline')
  static GetCreditBalanceRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetCreditBalanceRequest>(
          GetCreditBalanceRequest.$_createMessage);
  static GetCreditBalanceRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $1.UUID get workspaceId => $_getN(0);
  @$pb.TagNumber(1)
  set workspaceId($1.UUID value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);
  @$pb.TagNumber(1)
  $1.UUID ensureWorkspaceId() => $_ensure(0);
}

class GetCreditBalanceResponse extends $pb.GeneratedMessage {
  factory GetCreditBalanceResponse({
    CreditBalance? balance,
  }) {
    final result = GetCreditBalanceResponse._();
    if (balance != null) result.balance = balance;
    return result;
  }

  GetCreditBalanceResponse._();

  factory GetCreditBalanceResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetCreditBalanceResponse()..mergeFromBuffer(data, registry);
  factory GetCreditBalanceResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetCreditBalanceResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetCreditBalanceResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.admin.v1'),
      createEmptyInstance: GetCreditBalanceResponse.$_createMessage)
    ..aOM<CreditBalance>(1, _omitFieldNames ? '' : 'balance',
        subBuilder: CreditBalance.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetCreditBalanceResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetCreditBalanceResponse copyWith(
          void Function(GetCreditBalanceResponse) updates) =>
      super.copyWith((message) => updates(message as GetCreditBalanceResponse))
          as GetCreditBalanceResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use GetCreditBalanceResponse() / GetCreditBalanceResponse.new instead')
  static GetCreditBalanceResponse create() => GetCreditBalanceResponse._();
  static $pb.GeneratedMessage $_createMessage() => GetCreditBalanceResponse._();
  @$core.override
  GetCreditBalanceResponse createEmptyInstance() =>
      GetCreditBalanceResponse._();
  @$core.pragma('dart2js:noInline')
  static GetCreditBalanceResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetCreditBalanceResponse>(
          GetCreditBalanceResponse.$_createMessage);
  static GetCreditBalanceResponse? _defaultInstance;

  @$pb.TagNumber(1)
  CreditBalance get balance => $_getN(0);
  @$pb.TagNumber(1)
  set balance(CreditBalance value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasBalance() => $_has(0);
  @$pb.TagNumber(1)
  void clearBalance() => $_clearField(1);
  @$pb.TagNumber(1)
  CreditBalance ensureBalance() => $_ensure(0);
}

class GetCreditLedgerRequest extends $pb.GeneratedMessage {
  factory GetCreditLedgerRequest({
    $1.UUID? workspaceId,
    $1.Pagination? pagination,
    $core.String? operationTypeFilter,
    $core.String? sourceFilter,
  }) {
    final result = GetCreditLedgerRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (pagination != null) result.pagination = pagination;
    if (operationTypeFilter != null)
      result.operationTypeFilter = operationTypeFilter;
    if (sourceFilter != null) result.sourceFilter = sourceFilter;
    return result;
  }

  GetCreditLedgerRequest._();

  factory GetCreditLedgerRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetCreditLedgerRequest()..mergeFromBuffer(data, registry);
  factory GetCreditLedgerRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetCreditLedgerRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetCreditLedgerRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.admin.v1'),
      createEmptyInstance: GetCreditLedgerRequest.$_createMessage)
    ..aOM<$1.UUID>(1, _omitFieldNames ? '' : 'workspaceId',
        subBuilder: $1.UUID.$_createMessage)
    ..aOM<$1.Pagination>(2, _omitFieldNames ? '' : 'pagination',
        subBuilder: $1.Pagination.$_createMessage)
    ..aOS(3, _omitFieldNames ? '' : 'operationTypeFilter')
    ..aOS(4, _omitFieldNames ? '' : 'sourceFilter')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetCreditLedgerRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetCreditLedgerRequest copyWith(
          void Function(GetCreditLedgerRequest) updates) =>
      super.copyWith((message) => updates(message as GetCreditLedgerRequest))
          as GetCreditLedgerRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use GetCreditLedgerRequest() / GetCreditLedgerRequest.new instead')
  static GetCreditLedgerRequest create() => GetCreditLedgerRequest._();
  static $pb.GeneratedMessage $_createMessage() => GetCreditLedgerRequest._();
  @$core.override
  GetCreditLedgerRequest createEmptyInstance() => GetCreditLedgerRequest._();
  @$core.pragma('dart2js:noInline')
  static GetCreditLedgerRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetCreditLedgerRequest>(
          GetCreditLedgerRequest.$_createMessage);
  static GetCreditLedgerRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $1.UUID get workspaceId => $_getN(0);
  @$pb.TagNumber(1)
  set workspaceId($1.UUID value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);
  @$pb.TagNumber(1)
  $1.UUID ensureWorkspaceId() => $_ensure(0);

  @$pb.TagNumber(2)
  $1.Pagination get pagination => $_getN(1);
  @$pb.TagNumber(2)
  set pagination($1.Pagination value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasPagination() => $_has(1);
  @$pb.TagNumber(2)
  void clearPagination() => $_clearField(2);
  @$pb.TagNumber(2)
  $1.Pagination ensurePagination() => $_ensure(1);

  @$pb.TagNumber(3)
  $core.String get operationTypeFilter => $_getSZ(2);
  @$pb.TagNumber(3)
  set operationTypeFilter($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasOperationTypeFilter() => $_has(2);
  @$pb.TagNumber(3)
  void clearOperationTypeFilter() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get sourceFilter => $_getSZ(3);
  @$pb.TagNumber(4)
  set sourceFilter($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasSourceFilter() => $_has(3);
  @$pb.TagNumber(4)
  void clearSourceFilter() => $_clearField(4);
}

class GetCreditLedgerResponse extends $pb.GeneratedMessage {
  factory GetCreditLedgerResponse({
    $core.Iterable<CreditTransactionEntry>? entries,
    $1.PaginatedResponse? pageInfo,
  }) {
    final result = GetCreditLedgerResponse._();
    if (entries != null) result.entries.addAll(entries);
    if (pageInfo != null) result.pageInfo = pageInfo;
    return result;
  }

  GetCreditLedgerResponse._();

  factory GetCreditLedgerResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetCreditLedgerResponse()..mergeFromBuffer(data, registry);
  factory GetCreditLedgerResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetCreditLedgerResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetCreditLedgerResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.admin.v1'),
      createEmptyInstance: GetCreditLedgerResponse.$_createMessage)
    ..pPM<CreditTransactionEntry>(1, _omitFieldNames ? '' : 'entries',
        subBuilder: CreditTransactionEntry.$_createMessage)
    ..aOM<$1.PaginatedResponse>(2, _omitFieldNames ? '' : 'pageInfo',
        subBuilder: $1.PaginatedResponse.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetCreditLedgerResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetCreditLedgerResponse copyWith(
          void Function(GetCreditLedgerResponse) updates) =>
      super.copyWith((message) => updates(message as GetCreditLedgerResponse))
          as GetCreditLedgerResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use GetCreditLedgerResponse() / GetCreditLedgerResponse.new instead')
  static GetCreditLedgerResponse create() => GetCreditLedgerResponse._();
  static $pb.GeneratedMessage $_createMessage() => GetCreditLedgerResponse._();
  @$core.override
  GetCreditLedgerResponse createEmptyInstance() => GetCreditLedgerResponse._();
  @$core.pragma('dart2js:noInline')
  static GetCreditLedgerResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetCreditLedgerResponse>(
          GetCreditLedgerResponse.$_createMessage);
  static GetCreditLedgerResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<CreditTransactionEntry> get entries => $_getList(0);

  @$pb.TagNumber(2)
  $1.PaginatedResponse get pageInfo => $_getN(1);
  @$pb.TagNumber(2)
  set pageInfo($1.PaginatedResponse value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasPageInfo() => $_has(1);
  @$pb.TagNumber(2)
  void clearPageInfo() => $_clearField(2);
  @$pb.TagNumber(2)
  $1.PaginatedResponse ensurePageInfo() => $_ensure(1);
}

class PurchaseCreditsRequest extends $pb.GeneratedMessage {
  factory PurchaseCreditsRequest({
    $1.CommandContext? context,
    $core.String? packCode,
    $core.String? currency,
    $core.String? successUrl,
    $core.String? cancelUrl,
  }) {
    final result = PurchaseCreditsRequest._();
    if (context != null) result.context = context;
    if (packCode != null) result.packCode = packCode;
    if (currency != null) result.currency = currency;
    if (successUrl != null) result.successUrl = successUrl;
    if (cancelUrl != null) result.cancelUrl = cancelUrl;
    return result;
  }

  PurchaseCreditsRequest._();

  factory PurchaseCreditsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PurchaseCreditsRequest()..mergeFromBuffer(data, registry);
  factory PurchaseCreditsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PurchaseCreditsRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PurchaseCreditsRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.admin.v1'),
      createEmptyInstance: PurchaseCreditsRequest.$_createMessage)
    ..aOM<$1.CommandContext>(1, _omitFieldNames ? '' : 'context',
        subBuilder: $1.CommandContext.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'packCode')
    ..aOS(3, _omitFieldNames ? '' : 'currency')
    ..aOS(4, _omitFieldNames ? '' : 'successUrl')
    ..aOS(5, _omitFieldNames ? '' : 'cancelUrl')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PurchaseCreditsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PurchaseCreditsRequest copyWith(
          void Function(PurchaseCreditsRequest) updates) =>
      super.copyWith((message) => updates(message as PurchaseCreditsRequest))
          as PurchaseCreditsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use PurchaseCreditsRequest() / PurchaseCreditsRequest.new instead')
  static PurchaseCreditsRequest create() => PurchaseCreditsRequest._();
  static $pb.GeneratedMessage $_createMessage() => PurchaseCreditsRequest._();
  @$core.override
  PurchaseCreditsRequest createEmptyInstance() => PurchaseCreditsRequest._();
  @$core.pragma('dart2js:noInline')
  static PurchaseCreditsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PurchaseCreditsRequest>(
          PurchaseCreditsRequest.$_createMessage);
  static PurchaseCreditsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $1.CommandContext get context => $_getN(0);
  @$pb.TagNumber(1)
  set context($1.CommandContext value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasContext() => $_has(0);
  @$pb.TagNumber(1)
  void clearContext() => $_clearField(1);
  @$pb.TagNumber(1)
  $1.CommandContext ensureContext() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get packCode => $_getSZ(1);
  @$pb.TagNumber(2)
  set packCode($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPackCode() => $_has(1);
  @$pb.TagNumber(2)
  void clearPackCode() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get currency => $_getSZ(2);
  @$pb.TagNumber(3)
  set currency($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasCurrency() => $_has(2);
  @$pb.TagNumber(3)
  void clearCurrency() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get successUrl => $_getSZ(3);
  @$pb.TagNumber(4)
  set successUrl($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasSuccessUrl() => $_has(3);
  @$pb.TagNumber(4)
  void clearSuccessUrl() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get cancelUrl => $_getSZ(4);
  @$pb.TagNumber(5)
  set cancelUrl($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasCancelUrl() => $_has(4);
  @$pb.TagNumber(5)
  void clearCancelUrl() => $_clearField(5);
}

class PurchaseCreditsResponse extends $pb.GeneratedMessage {
  factory PurchaseCreditsResponse({
    $core.String? checkoutSessionId,
    $core.String? checkoutUrl,
    $core.String? status,
    CreditPackEntry? pack,
  }) {
    final result = PurchaseCreditsResponse._();
    if (checkoutSessionId != null) result.checkoutSessionId = checkoutSessionId;
    if (checkoutUrl != null) result.checkoutUrl = checkoutUrl;
    if (status != null) result.status = status;
    if (pack != null) result.pack = pack;
    return result;
  }

  PurchaseCreditsResponse._();

  factory PurchaseCreditsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PurchaseCreditsResponse()..mergeFromBuffer(data, registry);
  factory PurchaseCreditsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PurchaseCreditsResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PurchaseCreditsResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.admin.v1'),
      createEmptyInstance: PurchaseCreditsResponse.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'checkoutSessionId')
    ..aOS(2, _omitFieldNames ? '' : 'checkoutUrl')
    ..aOS(3, _omitFieldNames ? '' : 'status')
    ..aOM<CreditPackEntry>(4, _omitFieldNames ? '' : 'pack',
        subBuilder: CreditPackEntry.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PurchaseCreditsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PurchaseCreditsResponse copyWith(
          void Function(PurchaseCreditsResponse) updates) =>
      super.copyWith((message) => updates(message as PurchaseCreditsResponse))
          as PurchaseCreditsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use PurchaseCreditsResponse() / PurchaseCreditsResponse.new instead')
  static PurchaseCreditsResponse create() => PurchaseCreditsResponse._();
  static $pb.GeneratedMessage $_createMessage() => PurchaseCreditsResponse._();
  @$core.override
  PurchaseCreditsResponse createEmptyInstance() => PurchaseCreditsResponse._();
  @$core.pragma('dart2js:noInline')
  static PurchaseCreditsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PurchaseCreditsResponse>(
          PurchaseCreditsResponse.$_createMessage);
  static PurchaseCreditsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get checkoutSessionId => $_getSZ(0);
  @$pb.TagNumber(1)
  set checkoutSessionId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCheckoutSessionId() => $_has(0);
  @$pb.TagNumber(1)
  void clearCheckoutSessionId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get checkoutUrl => $_getSZ(1);
  @$pb.TagNumber(2)
  set checkoutUrl($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCheckoutUrl() => $_has(1);
  @$pb.TagNumber(2)
  void clearCheckoutUrl() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get status => $_getSZ(2);
  @$pb.TagNumber(3)
  set status($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasStatus() => $_has(2);
  @$pb.TagNumber(3)
  void clearStatus() => $_clearField(3);

  @$pb.TagNumber(4)
  CreditPackEntry get pack => $_getN(3);
  @$pb.TagNumber(4)
  set pack(CreditPackEntry value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasPack() => $_has(3);
  @$pb.TagNumber(4)
  void clearPack() => $_clearField(4);
  @$pb.TagNumber(4)
  CreditPackEntry ensurePack() => $_ensure(3);
}

class ChangePlanRequest extends $pb.GeneratedMessage {
  factory ChangePlanRequest({
    $1.CommandContext? context,
    $core.String? targetPlan,
    $core.String? billingInterval,
    $core.String? currency,
    $core.Iterable<$core.String>? addons,
    $core.Iterable<$core.String>? removeAddons,
    $core.bool? acceptOverageTerms,
    $core.bool? startTrial,
  }) {
    final result = ChangePlanRequest._();
    if (context != null) result.context = context;
    if (targetPlan != null) result.targetPlan = targetPlan;
    if (billingInterval != null) result.billingInterval = billingInterval;
    if (currency != null) result.currency = currency;
    if (addons != null) result.addons.addAll(addons);
    if (removeAddons != null) result.removeAddons.addAll(removeAddons);
    if (acceptOverageTerms != null)
      result.acceptOverageTerms = acceptOverageTerms;
    if (startTrial != null) result.startTrial = startTrial;
    return result;
  }

  ChangePlanRequest._();

  factory ChangePlanRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ChangePlanRequest()..mergeFromBuffer(data, registry);
  factory ChangePlanRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ChangePlanRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ChangePlanRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.admin.v1'),
      createEmptyInstance: ChangePlanRequest.$_createMessage)
    ..aOM<$1.CommandContext>(1, _omitFieldNames ? '' : 'context',
        subBuilder: $1.CommandContext.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'targetPlan')
    ..aOS(3, _omitFieldNames ? '' : 'billingInterval')
    ..aOS(4, _omitFieldNames ? '' : 'currency')
    ..pPS(5, _omitFieldNames ? '' : 'addons')
    ..pPS(6, _omitFieldNames ? '' : 'removeAddons')
    ..aOB(7, _omitFieldNames ? '' : 'acceptOverageTerms')
    ..aOB(8, _omitFieldNames ? '' : 'startTrial')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ChangePlanRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ChangePlanRequest copyWith(void Function(ChangePlanRequest) updates) =>
      super.copyWith((message) => updates(message as ChangePlanRequest))
          as ChangePlanRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ChangePlanRequest() / ChangePlanRequest.new instead')
  static ChangePlanRequest create() => ChangePlanRequest._();
  static $pb.GeneratedMessage $_createMessage() => ChangePlanRequest._();
  @$core.override
  ChangePlanRequest createEmptyInstance() => ChangePlanRequest._();
  @$core.pragma('dart2js:noInline')
  static ChangePlanRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ChangePlanRequest>(
          ChangePlanRequest.$_createMessage);
  static ChangePlanRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $1.CommandContext get context => $_getN(0);
  @$pb.TagNumber(1)
  set context($1.CommandContext value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasContext() => $_has(0);
  @$pb.TagNumber(1)
  void clearContext() => $_clearField(1);
  @$pb.TagNumber(1)
  $1.CommandContext ensureContext() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get targetPlan => $_getSZ(1);
  @$pb.TagNumber(2)
  set targetPlan($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTargetPlan() => $_has(1);
  @$pb.TagNumber(2)
  void clearTargetPlan() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get billingInterval => $_getSZ(2);
  @$pb.TagNumber(3)
  set billingInterval($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasBillingInterval() => $_has(2);
  @$pb.TagNumber(3)
  void clearBillingInterval() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get currency => $_getSZ(3);
  @$pb.TagNumber(4)
  set currency($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasCurrency() => $_has(3);
  @$pb.TagNumber(4)
  void clearCurrency() => $_clearField(4);

  @$pb.TagNumber(5)
  $pb.PbList<$core.String> get addons => $_getList(4);

  @$pb.TagNumber(6)
  $pb.PbList<$core.String> get removeAddons => $_getList(5);

  @$pb.TagNumber(7)
  $core.bool get acceptOverageTerms => $_getBF(6);
  @$pb.TagNumber(7)
  set acceptOverageTerms($core.bool value) => $_setBool(6, value);
  @$pb.TagNumber(7)
  $core.bool hasAcceptOverageTerms() => $_has(6);
  @$pb.TagNumber(7)
  void clearAcceptOverageTerms() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.bool get startTrial => $_getBF(7);
  @$pb.TagNumber(8)
  set startTrial($core.bool value) => $_setBool(7, value);
  @$pb.TagNumber(8)
  $core.bool hasStartTrial() => $_has(7);
  @$pb.TagNumber(8)
  void clearStartTrial() => $_clearField(8);
}

class ChangePlanResponse extends $pb.GeneratedMessage {
  factory ChangePlanResponse({
    SubscriptionSummary? subscription,
    $core.String? effectiveMode,
    $core.String? checkoutSessionId,
    $core.String? checkoutUrl,
    $1.Money? proratedAddonCharge,
    $core.Iterable<$core.String>? scheduledAddonRemovals,
  }) {
    final result = ChangePlanResponse._();
    if (subscription != null) result.subscription = subscription;
    if (effectiveMode != null) result.effectiveMode = effectiveMode;
    if (checkoutSessionId != null) result.checkoutSessionId = checkoutSessionId;
    if (checkoutUrl != null) result.checkoutUrl = checkoutUrl;
    if (proratedAddonCharge != null)
      result.proratedAddonCharge = proratedAddonCharge;
    if (scheduledAddonRemovals != null)
      result.scheduledAddonRemovals.addAll(scheduledAddonRemovals);
    return result;
  }

  ChangePlanResponse._();

  factory ChangePlanResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ChangePlanResponse()..mergeFromBuffer(data, registry);
  factory ChangePlanResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ChangePlanResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ChangePlanResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.admin.v1'),
      createEmptyInstance: ChangePlanResponse.$_createMessage)
    ..aOM<SubscriptionSummary>(1, _omitFieldNames ? '' : 'subscription',
        subBuilder: SubscriptionSummary.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'effectiveMode')
    ..aOS(3, _omitFieldNames ? '' : 'checkoutSessionId')
    ..aOS(4, _omitFieldNames ? '' : 'checkoutUrl')
    ..aOM<$1.Money>(5, _omitFieldNames ? '' : 'proratedAddonCharge',
        subBuilder: $1.Money.$_createMessage)
    ..pPS(6, _omitFieldNames ? '' : 'scheduledAddonRemovals')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ChangePlanResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ChangePlanResponse copyWith(void Function(ChangePlanResponse) updates) =>
      super.copyWith((message) => updates(message as ChangePlanResponse))
          as ChangePlanResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ChangePlanResponse() / ChangePlanResponse.new instead')
  static ChangePlanResponse create() => ChangePlanResponse._();
  static $pb.GeneratedMessage $_createMessage() => ChangePlanResponse._();
  @$core.override
  ChangePlanResponse createEmptyInstance() => ChangePlanResponse._();
  @$core.pragma('dart2js:noInline')
  static ChangePlanResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ChangePlanResponse>(
          ChangePlanResponse.$_createMessage);
  static ChangePlanResponse? _defaultInstance;

  @$pb.TagNumber(1)
  SubscriptionSummary get subscription => $_getN(0);
  @$pb.TagNumber(1)
  set subscription(SubscriptionSummary value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasSubscription() => $_has(0);
  @$pb.TagNumber(1)
  void clearSubscription() => $_clearField(1);
  @$pb.TagNumber(1)
  SubscriptionSummary ensureSubscription() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get effectiveMode => $_getSZ(1);
  @$pb.TagNumber(2)
  set effectiveMode($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasEffectiveMode() => $_has(1);
  @$pb.TagNumber(2)
  void clearEffectiveMode() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get checkoutSessionId => $_getSZ(2);
  @$pb.TagNumber(3)
  set checkoutSessionId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasCheckoutSessionId() => $_has(2);
  @$pb.TagNumber(3)
  void clearCheckoutSessionId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get checkoutUrl => $_getSZ(3);
  @$pb.TagNumber(4)
  set checkoutUrl($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasCheckoutUrl() => $_has(3);
  @$pb.TagNumber(4)
  void clearCheckoutUrl() => $_clearField(4);

  @$pb.TagNumber(5)
  $1.Money get proratedAddonCharge => $_getN(4);
  @$pb.TagNumber(5)
  set proratedAddonCharge($1.Money value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasProratedAddonCharge() => $_has(4);
  @$pb.TagNumber(5)
  void clearProratedAddonCharge() => $_clearField(5);
  @$pb.TagNumber(5)
  $1.Money ensureProratedAddonCharge() => $_ensure(4);

  @$pb.TagNumber(6)
  $pb.PbList<$core.String> get scheduledAddonRemovals => $_getList(5);
}

class CancelSubscriptionRequest extends $pb.GeneratedMessage {
  factory CancelSubscriptionRequest({
    $1.CommandContext? context,
    $core.String? cancellationReason,
    $core.bool? pauseInstead,
    $core.int? pauseMonths,
    $core.bool? acceptRetentionOffer,
    $core.int? pauseDays,
  }) {
    final result = CancelSubscriptionRequest._();
    if (context != null) result.context = context;
    if (cancellationReason != null)
      result.cancellationReason = cancellationReason;
    if (pauseInstead != null) result.pauseInstead = pauseInstead;
    if (pauseMonths != null) result.pauseMonths = pauseMonths;
    if (acceptRetentionOffer != null)
      result.acceptRetentionOffer = acceptRetentionOffer;
    if (pauseDays != null) result.pauseDays = pauseDays;
    return result;
  }

  CancelSubscriptionRequest._();

  factory CancelSubscriptionRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CancelSubscriptionRequest()..mergeFromBuffer(data, registry);
  factory CancelSubscriptionRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CancelSubscriptionRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CancelSubscriptionRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.admin.v1'),
      createEmptyInstance: CancelSubscriptionRequest.$_createMessage)
    ..aOM<$1.CommandContext>(1, _omitFieldNames ? '' : 'context',
        subBuilder: $1.CommandContext.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'cancellationReason')
    ..aOB(3, _omitFieldNames ? '' : 'pauseInstead')
    ..aI(4, _omitFieldNames ? '' : 'pauseMonths')
    ..aOB(5, _omitFieldNames ? '' : 'acceptRetentionOffer')
    ..aI(6, _omitFieldNames ? '' : 'pauseDays')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CancelSubscriptionRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CancelSubscriptionRequest copyWith(
          void Function(CancelSubscriptionRequest) updates) =>
      super.copyWith((message) => updates(message as CancelSubscriptionRequest))
          as CancelSubscriptionRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use CancelSubscriptionRequest() / CancelSubscriptionRequest.new instead')
  static CancelSubscriptionRequest create() => CancelSubscriptionRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      CancelSubscriptionRequest._();
  @$core.override
  CancelSubscriptionRequest createEmptyInstance() =>
      CancelSubscriptionRequest._();
  @$core.pragma('dart2js:noInline')
  static CancelSubscriptionRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CancelSubscriptionRequest>(
          CancelSubscriptionRequest.$_createMessage);
  static CancelSubscriptionRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $1.CommandContext get context => $_getN(0);
  @$pb.TagNumber(1)
  set context($1.CommandContext value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasContext() => $_has(0);
  @$pb.TagNumber(1)
  void clearContext() => $_clearField(1);
  @$pb.TagNumber(1)
  $1.CommandContext ensureContext() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get cancellationReason => $_getSZ(1);
  @$pb.TagNumber(2)
  set cancellationReason($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCancellationReason() => $_has(1);
  @$pb.TagNumber(2)
  void clearCancellationReason() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.bool get pauseInstead => $_getBF(2);
  @$pb.TagNumber(3)
  set pauseInstead($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPauseInstead() => $_has(2);
  @$pb.TagNumber(3)
  void clearPauseInstead() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get pauseMonths => $_getIZ(3);
  @$pb.TagNumber(4)
  set pauseMonths($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasPauseMonths() => $_has(3);
  @$pb.TagNumber(4)
  void clearPauseMonths() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.bool get acceptRetentionOffer => $_getBF(4);
  @$pb.TagNumber(5)
  set acceptRetentionOffer($core.bool value) => $_setBool(4, value);
  @$pb.TagNumber(5)
  $core.bool hasAcceptRetentionOffer() => $_has(4);
  @$pb.TagNumber(5)
  void clearAcceptRetentionOffer() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.int get pauseDays => $_getIZ(5);
  @$pb.TagNumber(6)
  set pauseDays($core.int value) => $_setSignedInt32(5, value);
  @$pb.TagNumber(6)
  $core.bool hasPauseDays() => $_has(5);
  @$pb.TagNumber(6)
  void clearPauseDays() => $_clearField(6);
}

class CancelSubscriptionResponse extends $pb.GeneratedMessage {
  factory CancelSubscriptionResponse({
    SubscriptionSummary? subscription,
    $core.bool? retentionOfferApplied,
    $core.String? retentionDiscountPct,
    $core.int? retentionDiscountMonths,
    $core.String? retentionPhase,
  }) {
    final result = CancelSubscriptionResponse._();
    if (subscription != null) result.subscription = subscription;
    if (retentionOfferApplied != null)
      result.retentionOfferApplied = retentionOfferApplied;
    if (retentionDiscountPct != null)
      result.retentionDiscountPct = retentionDiscountPct;
    if (retentionDiscountMonths != null)
      result.retentionDiscountMonths = retentionDiscountMonths;
    if (retentionPhase != null) result.retentionPhase = retentionPhase;
    return result;
  }

  CancelSubscriptionResponse._();

  factory CancelSubscriptionResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CancelSubscriptionResponse()..mergeFromBuffer(data, registry);
  factory CancelSubscriptionResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CancelSubscriptionResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CancelSubscriptionResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.admin.v1'),
      createEmptyInstance: CancelSubscriptionResponse.$_createMessage)
    ..aOM<SubscriptionSummary>(1, _omitFieldNames ? '' : 'subscription',
        subBuilder: SubscriptionSummary.$_createMessage)
    ..aOB(2, _omitFieldNames ? '' : 'retentionOfferApplied')
    ..aOS(3, _omitFieldNames ? '' : 'retentionDiscountPct')
    ..aI(4, _omitFieldNames ? '' : 'retentionDiscountMonths')
    ..aOS(5, _omitFieldNames ? '' : 'retentionPhase')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CancelSubscriptionResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CancelSubscriptionResponse copyWith(
          void Function(CancelSubscriptionResponse) updates) =>
      super.copyWith(
              (message) => updates(message as CancelSubscriptionResponse))
          as CancelSubscriptionResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use CancelSubscriptionResponse() / CancelSubscriptionResponse.new instead')
  static CancelSubscriptionResponse create() => CancelSubscriptionResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      CancelSubscriptionResponse._();
  @$core.override
  CancelSubscriptionResponse createEmptyInstance() =>
      CancelSubscriptionResponse._();
  @$core.pragma('dart2js:noInline')
  static CancelSubscriptionResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CancelSubscriptionResponse>(
          CancelSubscriptionResponse.$_createMessage);
  static CancelSubscriptionResponse? _defaultInstance;

  @$pb.TagNumber(1)
  SubscriptionSummary get subscription => $_getN(0);
  @$pb.TagNumber(1)
  set subscription(SubscriptionSummary value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasSubscription() => $_has(0);
  @$pb.TagNumber(1)
  void clearSubscription() => $_clearField(1);
  @$pb.TagNumber(1)
  SubscriptionSummary ensureSubscription() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.bool get retentionOfferApplied => $_getBF(1);
  @$pb.TagNumber(2)
  set retentionOfferApplied($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasRetentionOfferApplied() => $_has(1);
  @$pb.TagNumber(2)
  void clearRetentionOfferApplied() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get retentionDiscountPct => $_getSZ(2);
  @$pb.TagNumber(3)
  set retentionDiscountPct($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasRetentionDiscountPct() => $_has(2);
  @$pb.TagNumber(3)
  void clearRetentionDiscountPct() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get retentionDiscountMonths => $_getIZ(3);
  @$pb.TagNumber(4)
  set retentionDiscountMonths($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasRetentionDiscountMonths() => $_has(3);
  @$pb.TagNumber(4)
  void clearRetentionDiscountMonths() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get retentionPhase => $_getSZ(4);
  @$pb.TagNumber(5)
  set retentionPhase($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasRetentionPhase() => $_has(4);
  @$pb.TagNumber(5)
  void clearRetentionPhase() => $_clearField(5);
}

class UpdatePaymentMethodRequest extends $pb.GeneratedMessage {
  factory UpdatePaymentMethodRequest({
    $1.CommandContext? context,
    $core.String? stripePaymentMethodId,
    $core.bool? setDefault,
    $core.bool? remove,
    $core.String? methodType,
    $core.String? billingName,
    $core.String? billingEmail,
  }) {
    final result = UpdatePaymentMethodRequest._();
    if (context != null) result.context = context;
    if (stripePaymentMethodId != null)
      result.stripePaymentMethodId = stripePaymentMethodId;
    if (setDefault != null) result.setDefault = setDefault;
    if (remove != null) result.remove = remove;
    if (methodType != null) result.methodType = methodType;
    if (billingName != null) result.billingName = billingName;
    if (billingEmail != null) result.billingEmail = billingEmail;
    return result;
  }

  UpdatePaymentMethodRequest._();

  factory UpdatePaymentMethodRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      UpdatePaymentMethodRequest()..mergeFromBuffer(data, registry);
  factory UpdatePaymentMethodRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      UpdatePaymentMethodRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UpdatePaymentMethodRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.admin.v1'),
      createEmptyInstance: UpdatePaymentMethodRequest.$_createMessage)
    ..aOM<$1.CommandContext>(1, _omitFieldNames ? '' : 'context',
        subBuilder: $1.CommandContext.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'stripePaymentMethodId')
    ..aOB(3, _omitFieldNames ? '' : 'setDefault')
    ..aOB(4, _omitFieldNames ? '' : 'remove')
    ..aOS(5, _omitFieldNames ? '' : 'methodType')
    ..aOS(6, _omitFieldNames ? '' : 'billingName')
    ..aOS(7, _omitFieldNames ? '' : 'billingEmail')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdatePaymentMethodRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdatePaymentMethodRequest copyWith(
          void Function(UpdatePaymentMethodRequest) updates) =>
      super.copyWith(
              (message) => updates(message as UpdatePaymentMethodRequest))
          as UpdatePaymentMethodRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use UpdatePaymentMethodRequest() / UpdatePaymentMethodRequest.new instead')
  static UpdatePaymentMethodRequest create() => UpdatePaymentMethodRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      UpdatePaymentMethodRequest._();
  @$core.override
  UpdatePaymentMethodRequest createEmptyInstance() =>
      UpdatePaymentMethodRequest._();
  @$core.pragma('dart2js:noInline')
  static UpdatePaymentMethodRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UpdatePaymentMethodRequest>(
          UpdatePaymentMethodRequest.$_createMessage);
  static UpdatePaymentMethodRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $1.CommandContext get context => $_getN(0);
  @$pb.TagNumber(1)
  set context($1.CommandContext value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasContext() => $_has(0);
  @$pb.TagNumber(1)
  void clearContext() => $_clearField(1);
  @$pb.TagNumber(1)
  $1.CommandContext ensureContext() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get stripePaymentMethodId => $_getSZ(1);
  @$pb.TagNumber(2)
  set stripePaymentMethodId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasStripePaymentMethodId() => $_has(1);
  @$pb.TagNumber(2)
  void clearStripePaymentMethodId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.bool get setDefault => $_getBF(2);
  @$pb.TagNumber(3)
  set setDefault($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasSetDefault() => $_has(2);
  @$pb.TagNumber(3)
  void clearSetDefault() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.bool get remove => $_getBF(3);
  @$pb.TagNumber(4)
  set remove($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(4)
  $core.bool hasRemove() => $_has(3);
  @$pb.TagNumber(4)
  void clearRemove() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get methodType => $_getSZ(4);
  @$pb.TagNumber(5)
  set methodType($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasMethodType() => $_has(4);
  @$pb.TagNumber(5)
  void clearMethodType() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get billingName => $_getSZ(5);
  @$pb.TagNumber(6)
  set billingName($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasBillingName() => $_has(5);
  @$pb.TagNumber(6)
  void clearBillingName() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get billingEmail => $_getSZ(6);
  @$pb.TagNumber(7)
  set billingEmail($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasBillingEmail() => $_has(6);
  @$pb.TagNumber(7)
  void clearBillingEmail() => $_clearField(7);
}

class UpdatePaymentMethodResponse extends $pb.GeneratedMessage {
  factory UpdatePaymentMethodResponse({
    PaymentMethodSummary? paymentMethod,
    $core.Iterable<PaymentMethodSummary>? paymentMethods,
    $core.Iterable<PaymentMethodAccessGate>? methodAccessGates,
  }) {
    final result = UpdatePaymentMethodResponse._();
    if (paymentMethod != null) result.paymentMethod = paymentMethod;
    if (paymentMethods != null) result.paymentMethods.addAll(paymentMethods);
    if (methodAccessGates != null)
      result.methodAccessGates.addAll(methodAccessGates);
    return result;
  }

  UpdatePaymentMethodResponse._();

  factory UpdatePaymentMethodResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      UpdatePaymentMethodResponse()..mergeFromBuffer(data, registry);
  factory UpdatePaymentMethodResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      UpdatePaymentMethodResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UpdatePaymentMethodResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.admin.v1'),
      createEmptyInstance: UpdatePaymentMethodResponse.$_createMessage)
    ..aOM<PaymentMethodSummary>(1, _omitFieldNames ? '' : 'paymentMethod',
        subBuilder: PaymentMethodSummary.$_createMessage)
    ..pPM<PaymentMethodSummary>(2, _omitFieldNames ? '' : 'paymentMethods',
        subBuilder: PaymentMethodSummary.$_createMessage)
    ..pPM<PaymentMethodAccessGate>(
        3, _omitFieldNames ? '' : 'methodAccessGates',
        subBuilder: PaymentMethodAccessGate.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdatePaymentMethodResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdatePaymentMethodResponse copyWith(
          void Function(UpdatePaymentMethodResponse) updates) =>
      super.copyWith(
              (message) => updates(message as UpdatePaymentMethodResponse))
          as UpdatePaymentMethodResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use UpdatePaymentMethodResponse() / UpdatePaymentMethodResponse.new instead')
  static UpdatePaymentMethodResponse create() =>
      UpdatePaymentMethodResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      UpdatePaymentMethodResponse._();
  @$core.override
  UpdatePaymentMethodResponse createEmptyInstance() =>
      UpdatePaymentMethodResponse._();
  @$core.pragma('dart2js:noInline')
  static UpdatePaymentMethodResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UpdatePaymentMethodResponse>(
          UpdatePaymentMethodResponse.$_createMessage);
  static UpdatePaymentMethodResponse? _defaultInstance;

  @$pb.TagNumber(1)
  PaymentMethodSummary get paymentMethod => $_getN(0);
  @$pb.TagNumber(1)
  set paymentMethod(PaymentMethodSummary value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasPaymentMethod() => $_has(0);
  @$pb.TagNumber(1)
  void clearPaymentMethod() => $_clearField(1);
  @$pb.TagNumber(1)
  PaymentMethodSummary ensurePaymentMethod() => $_ensure(0);

  @$pb.TagNumber(2)
  $pb.PbList<PaymentMethodSummary> get paymentMethods => $_getList(1);

  @$pb.TagNumber(3)
  $pb.PbList<PaymentMethodAccessGate> get methodAccessGates => $_getList(2);
}

class GetPaymentMethodRequest extends $pb.GeneratedMessage {
  factory GetPaymentMethodRequest({
    $1.UUID? workspaceId,
  }) {
    final result = GetPaymentMethodRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    return result;
  }

  GetPaymentMethodRequest._();

  factory GetPaymentMethodRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetPaymentMethodRequest()..mergeFromBuffer(data, registry);
  factory GetPaymentMethodRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetPaymentMethodRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetPaymentMethodRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.admin.v1'),
      createEmptyInstance: GetPaymentMethodRequest.$_createMessage)
    ..aOM<$1.UUID>(1, _omitFieldNames ? '' : 'workspaceId',
        subBuilder: $1.UUID.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetPaymentMethodRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetPaymentMethodRequest copyWith(
          void Function(GetPaymentMethodRequest) updates) =>
      super.copyWith((message) => updates(message as GetPaymentMethodRequest))
          as GetPaymentMethodRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use GetPaymentMethodRequest() / GetPaymentMethodRequest.new instead')
  static GetPaymentMethodRequest create() => GetPaymentMethodRequest._();
  static $pb.GeneratedMessage $_createMessage() => GetPaymentMethodRequest._();
  @$core.override
  GetPaymentMethodRequest createEmptyInstance() => GetPaymentMethodRequest._();
  @$core.pragma('dart2js:noInline')
  static GetPaymentMethodRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetPaymentMethodRequest>(
          GetPaymentMethodRequest.$_createMessage);
  static GetPaymentMethodRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $1.UUID get workspaceId => $_getN(0);
  @$pb.TagNumber(1)
  set workspaceId($1.UUID value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);
  @$pb.TagNumber(1)
  $1.UUID ensureWorkspaceId() => $_ensure(0);
}

class GetPaymentMethodResponse extends $pb.GeneratedMessage {
  factory GetPaymentMethodResponse({
    PaymentMethodSummary? defaultPaymentMethod,
    $core.Iterable<PaymentMethodSummary>? paymentMethods,
    $core.Iterable<PaymentMethodAccessGate>? methodAccessGates,
  }) {
    final result = GetPaymentMethodResponse._();
    if (defaultPaymentMethod != null)
      result.defaultPaymentMethod = defaultPaymentMethod;
    if (paymentMethods != null) result.paymentMethods.addAll(paymentMethods);
    if (methodAccessGates != null)
      result.methodAccessGates.addAll(methodAccessGates);
    return result;
  }

  GetPaymentMethodResponse._();

  factory GetPaymentMethodResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetPaymentMethodResponse()..mergeFromBuffer(data, registry);
  factory GetPaymentMethodResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetPaymentMethodResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetPaymentMethodResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.admin.v1'),
      createEmptyInstance: GetPaymentMethodResponse.$_createMessage)
    ..aOM<PaymentMethodSummary>(
        1, _omitFieldNames ? '' : 'defaultPaymentMethod',
        subBuilder: PaymentMethodSummary.$_createMessage)
    ..pPM<PaymentMethodSummary>(2, _omitFieldNames ? '' : 'paymentMethods',
        subBuilder: PaymentMethodSummary.$_createMessage)
    ..pPM<PaymentMethodAccessGate>(
        3, _omitFieldNames ? '' : 'methodAccessGates',
        subBuilder: PaymentMethodAccessGate.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetPaymentMethodResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetPaymentMethodResponse copyWith(
          void Function(GetPaymentMethodResponse) updates) =>
      super.copyWith((message) => updates(message as GetPaymentMethodResponse))
          as GetPaymentMethodResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use GetPaymentMethodResponse() / GetPaymentMethodResponse.new instead')
  static GetPaymentMethodResponse create() => GetPaymentMethodResponse._();
  static $pb.GeneratedMessage $_createMessage() => GetPaymentMethodResponse._();
  @$core.override
  GetPaymentMethodResponse createEmptyInstance() =>
      GetPaymentMethodResponse._();
  @$core.pragma('dart2js:noInline')
  static GetPaymentMethodResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetPaymentMethodResponse>(
          GetPaymentMethodResponse.$_createMessage);
  static GetPaymentMethodResponse? _defaultInstance;

  @$pb.TagNumber(1)
  PaymentMethodSummary get defaultPaymentMethod => $_getN(0);
  @$pb.TagNumber(1)
  set defaultPaymentMethod(PaymentMethodSummary value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasDefaultPaymentMethod() => $_has(0);
  @$pb.TagNumber(1)
  void clearDefaultPaymentMethod() => $_clearField(1);
  @$pb.TagNumber(1)
  PaymentMethodSummary ensureDefaultPaymentMethod() => $_ensure(0);

  @$pb.TagNumber(2)
  $pb.PbList<PaymentMethodSummary> get paymentMethods => $_getList(1);

  @$pb.TagNumber(3)
  $pb.PbList<PaymentMethodAccessGate> get methodAccessGates => $_getList(2);
}

class ListSubscriptionsRequest extends $pb.GeneratedMessage {
  factory ListSubscriptionsRequest({
    $1.UUID? workspaceId,
    $1.Pagination? pagination,
  }) {
    final result = ListSubscriptionsRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (pagination != null) result.pagination = pagination;
    return result;
  }

  ListSubscriptionsRequest._();

  factory ListSubscriptionsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListSubscriptionsRequest()..mergeFromBuffer(data, registry);
  factory ListSubscriptionsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListSubscriptionsRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListSubscriptionsRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.admin.v1'),
      createEmptyInstance: ListSubscriptionsRequest.$_createMessage)
    ..aOM<$1.UUID>(1, _omitFieldNames ? '' : 'workspaceId',
        subBuilder: $1.UUID.$_createMessage)
    ..aOM<$1.Pagination>(2, _omitFieldNames ? '' : 'pagination',
        subBuilder: $1.Pagination.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListSubscriptionsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListSubscriptionsRequest copyWith(
          void Function(ListSubscriptionsRequest) updates) =>
      super.copyWith((message) => updates(message as ListSubscriptionsRequest))
          as ListSubscriptionsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ListSubscriptionsRequest() / ListSubscriptionsRequest.new instead')
  static ListSubscriptionsRequest create() => ListSubscriptionsRequest._();
  static $pb.GeneratedMessage $_createMessage() => ListSubscriptionsRequest._();
  @$core.override
  ListSubscriptionsRequest createEmptyInstance() =>
      ListSubscriptionsRequest._();
  @$core.pragma('dart2js:noInline')
  static ListSubscriptionsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListSubscriptionsRequest>(
          ListSubscriptionsRequest.$_createMessage);
  static ListSubscriptionsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $1.UUID get workspaceId => $_getN(0);
  @$pb.TagNumber(1)
  set workspaceId($1.UUID value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);
  @$pb.TagNumber(1)
  $1.UUID ensureWorkspaceId() => $_ensure(0);

  @$pb.TagNumber(2)
  $1.Pagination get pagination => $_getN(1);
  @$pb.TagNumber(2)
  set pagination($1.Pagination value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasPagination() => $_has(1);
  @$pb.TagNumber(2)
  void clearPagination() => $_clearField(2);
  @$pb.TagNumber(2)
  $1.Pagination ensurePagination() => $_ensure(1);
}

class ListSubscriptionsResponse extends $pb.GeneratedMessage {
  factory ListSubscriptionsResponse({
    $core.Iterable<SubscriptionSummary>? subscriptions,
    $1.PaginatedResponse? pageInfo,
  }) {
    final result = ListSubscriptionsResponse._();
    if (subscriptions != null) result.subscriptions.addAll(subscriptions);
    if (pageInfo != null) result.pageInfo = pageInfo;
    return result;
  }

  ListSubscriptionsResponse._();

  factory ListSubscriptionsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListSubscriptionsResponse()..mergeFromBuffer(data, registry);
  factory ListSubscriptionsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListSubscriptionsResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListSubscriptionsResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.admin.v1'),
      createEmptyInstance: ListSubscriptionsResponse.$_createMessage)
    ..pPM<SubscriptionSummary>(1, _omitFieldNames ? '' : 'subscriptions',
        subBuilder: SubscriptionSummary.$_createMessage)
    ..aOM<$1.PaginatedResponse>(2, _omitFieldNames ? '' : 'pageInfo',
        subBuilder: $1.PaginatedResponse.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListSubscriptionsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListSubscriptionsResponse copyWith(
          void Function(ListSubscriptionsResponse) updates) =>
      super.copyWith((message) => updates(message as ListSubscriptionsResponse))
          as ListSubscriptionsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ListSubscriptionsResponse() / ListSubscriptionsResponse.new instead')
  static ListSubscriptionsResponse create() => ListSubscriptionsResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      ListSubscriptionsResponse._();
  @$core.override
  ListSubscriptionsResponse createEmptyInstance() =>
      ListSubscriptionsResponse._();
  @$core.pragma('dart2js:noInline')
  static ListSubscriptionsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListSubscriptionsResponse>(
          ListSubscriptionsResponse.$_createMessage);
  static ListSubscriptionsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<SubscriptionSummary> get subscriptions => $_getList(0);

  @$pb.TagNumber(2)
  $1.PaginatedResponse get pageInfo => $_getN(1);
  @$pb.TagNumber(2)
  set pageInfo($1.PaginatedResponse value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasPageInfo() => $_has(1);
  @$pb.TagNumber(2)
  void clearPageInfo() => $_clearField(2);
  @$pb.TagNumber(2)
  $1.PaginatedResponse ensurePageInfo() => $_ensure(1);
}

class BillingEventEntry extends $pb.GeneratedMessage {
  factory BillingEventEntry({
    $1.UUID? billingEventId,
    $1.UUID? workspaceId,
    $core.String? eventType,
    $core.String? stripeEventId,
    $1.Money? amount,
    $core.String? subscriptionTier,
    $core.String? creditsChange,
    $core.String? description,
    $core.String? metadataJson,
    $2.Timestamp? createdAt,
  }) {
    final result = BillingEventEntry._();
    if (billingEventId != null) result.billingEventId = billingEventId;
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (eventType != null) result.eventType = eventType;
    if (stripeEventId != null) result.stripeEventId = stripeEventId;
    if (amount != null) result.amount = amount;
    if (subscriptionTier != null) result.subscriptionTier = subscriptionTier;
    if (creditsChange != null) result.creditsChange = creditsChange;
    if (description != null) result.description = description;
    if (metadataJson != null) result.metadataJson = metadataJson;
    if (createdAt != null) result.createdAt = createdAt;
    return result;
  }

  BillingEventEntry._();

  factory BillingEventEntry.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      BillingEventEntry()..mergeFromBuffer(data, registry);
  factory BillingEventEntry.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      BillingEventEntry()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'BillingEventEntry',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.admin.v1'),
      createEmptyInstance: BillingEventEntry.$_createMessage)
    ..aOM<$1.UUID>(1, _omitFieldNames ? '' : 'billingEventId',
        subBuilder: $1.UUID.$_createMessage)
    ..aOM<$1.UUID>(2, _omitFieldNames ? '' : 'workspaceId',
        subBuilder: $1.UUID.$_createMessage)
    ..aOS(3, _omitFieldNames ? '' : 'eventType')
    ..aOS(4, _omitFieldNames ? '' : 'stripeEventId')
    ..aOM<$1.Money>(5, _omitFieldNames ? '' : 'amount',
        subBuilder: $1.Money.$_createMessage)
    ..aOS(6, _omitFieldNames ? '' : 'subscriptionTier')
    ..aOS(7, _omitFieldNames ? '' : 'creditsChange')
    ..aOS(8, _omitFieldNames ? '' : 'description')
    ..aOS(9, _omitFieldNames ? '' : 'metadataJson')
    ..aOM<$2.Timestamp>(10, _omitFieldNames ? '' : 'createdAt',
        subBuilder: $2.Timestamp.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BillingEventEntry clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BillingEventEntry copyWith(void Function(BillingEventEntry) updates) =>
      super.copyWith((message) => updates(message as BillingEventEntry))
          as BillingEventEntry;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use BillingEventEntry() / BillingEventEntry.new instead')
  static BillingEventEntry create() => BillingEventEntry._();
  static $pb.GeneratedMessage $_createMessage() => BillingEventEntry._();
  @$core.override
  BillingEventEntry createEmptyInstance() => BillingEventEntry._();
  @$core.pragma('dart2js:noInline')
  static BillingEventEntry getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<BillingEventEntry>(
          BillingEventEntry.$_createMessage);
  static BillingEventEntry? _defaultInstance;

  @$pb.TagNumber(1)
  $1.UUID get billingEventId => $_getN(0);
  @$pb.TagNumber(1)
  set billingEventId($1.UUID value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasBillingEventId() => $_has(0);
  @$pb.TagNumber(1)
  void clearBillingEventId() => $_clearField(1);
  @$pb.TagNumber(1)
  $1.UUID ensureBillingEventId() => $_ensure(0);

  @$pb.TagNumber(2)
  $1.UUID get workspaceId => $_getN(1);
  @$pb.TagNumber(2)
  set workspaceId($1.UUID value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasWorkspaceId() => $_has(1);
  @$pb.TagNumber(2)
  void clearWorkspaceId() => $_clearField(2);
  @$pb.TagNumber(2)
  $1.UUID ensureWorkspaceId() => $_ensure(1);

  @$pb.TagNumber(3)
  $core.String get eventType => $_getSZ(2);
  @$pb.TagNumber(3)
  set eventType($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasEventType() => $_has(2);
  @$pb.TagNumber(3)
  void clearEventType() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get stripeEventId => $_getSZ(3);
  @$pb.TagNumber(4)
  set stripeEventId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasStripeEventId() => $_has(3);
  @$pb.TagNumber(4)
  void clearStripeEventId() => $_clearField(4);

  @$pb.TagNumber(5)
  $1.Money get amount => $_getN(4);
  @$pb.TagNumber(5)
  set amount($1.Money value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasAmount() => $_has(4);
  @$pb.TagNumber(5)
  void clearAmount() => $_clearField(5);
  @$pb.TagNumber(5)
  $1.Money ensureAmount() => $_ensure(4);

  @$pb.TagNumber(6)
  $core.String get subscriptionTier => $_getSZ(5);
  @$pb.TagNumber(6)
  set subscriptionTier($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasSubscriptionTier() => $_has(5);
  @$pb.TagNumber(6)
  void clearSubscriptionTier() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get creditsChange => $_getSZ(6);
  @$pb.TagNumber(7)
  set creditsChange($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasCreditsChange() => $_has(6);
  @$pb.TagNumber(7)
  void clearCreditsChange() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get description => $_getSZ(7);
  @$pb.TagNumber(8)
  set description($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasDescription() => $_has(7);
  @$pb.TagNumber(8)
  void clearDescription() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get metadataJson => $_getSZ(8);
  @$pb.TagNumber(9)
  set metadataJson($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasMetadataJson() => $_has(8);
  @$pb.TagNumber(9)
  void clearMetadataJson() => $_clearField(9);

  @$pb.TagNumber(10)
  $2.Timestamp get createdAt => $_getN(9);
  @$pb.TagNumber(10)
  set createdAt($2.Timestamp value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasCreatedAt() => $_has(9);
  @$pb.TagNumber(10)
  void clearCreatedAt() => $_clearField(10);
  @$pb.TagNumber(10)
  $2.Timestamp ensureCreatedAt() => $_ensure(9);
}

class ListBillingEventsRequest extends $pb.GeneratedMessage {
  factory ListBillingEventsRequest({
    $1.UUID? workspaceId,
    $1.Pagination? pagination,
    $core.String? eventTypeFilter,
  }) {
    final result = ListBillingEventsRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (pagination != null) result.pagination = pagination;
    if (eventTypeFilter != null) result.eventTypeFilter = eventTypeFilter;
    return result;
  }

  ListBillingEventsRequest._();

  factory ListBillingEventsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListBillingEventsRequest()..mergeFromBuffer(data, registry);
  factory ListBillingEventsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListBillingEventsRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListBillingEventsRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.admin.v1'),
      createEmptyInstance: ListBillingEventsRequest.$_createMessage)
    ..aOM<$1.UUID>(1, _omitFieldNames ? '' : 'workspaceId',
        subBuilder: $1.UUID.$_createMessage)
    ..aOM<$1.Pagination>(2, _omitFieldNames ? '' : 'pagination',
        subBuilder: $1.Pagination.$_createMessage)
    ..aOS(3, _omitFieldNames ? '' : 'eventTypeFilter')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListBillingEventsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListBillingEventsRequest copyWith(
          void Function(ListBillingEventsRequest) updates) =>
      super.copyWith((message) => updates(message as ListBillingEventsRequest))
          as ListBillingEventsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ListBillingEventsRequest() / ListBillingEventsRequest.new instead')
  static ListBillingEventsRequest create() => ListBillingEventsRequest._();
  static $pb.GeneratedMessage $_createMessage() => ListBillingEventsRequest._();
  @$core.override
  ListBillingEventsRequest createEmptyInstance() =>
      ListBillingEventsRequest._();
  @$core.pragma('dart2js:noInline')
  static ListBillingEventsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListBillingEventsRequest>(
          ListBillingEventsRequest.$_createMessage);
  static ListBillingEventsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $1.UUID get workspaceId => $_getN(0);
  @$pb.TagNumber(1)
  set workspaceId($1.UUID value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);
  @$pb.TagNumber(1)
  $1.UUID ensureWorkspaceId() => $_ensure(0);

  @$pb.TagNumber(2)
  $1.Pagination get pagination => $_getN(1);
  @$pb.TagNumber(2)
  set pagination($1.Pagination value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasPagination() => $_has(1);
  @$pb.TagNumber(2)
  void clearPagination() => $_clearField(2);
  @$pb.TagNumber(2)
  $1.Pagination ensurePagination() => $_ensure(1);

  @$pb.TagNumber(3)
  $core.String get eventTypeFilter => $_getSZ(2);
  @$pb.TagNumber(3)
  set eventTypeFilter($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasEventTypeFilter() => $_has(2);
  @$pb.TagNumber(3)
  void clearEventTypeFilter() => $_clearField(3);
}

class ListBillingEventsResponse extends $pb.GeneratedMessage {
  factory ListBillingEventsResponse({
    $core.Iterable<BillingEventEntry>? events,
    $1.PaginatedResponse? pageInfo,
  }) {
    final result = ListBillingEventsResponse._();
    if (events != null) result.events.addAll(events);
    if (pageInfo != null) result.pageInfo = pageInfo;
    return result;
  }

  ListBillingEventsResponse._();

  factory ListBillingEventsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListBillingEventsResponse()..mergeFromBuffer(data, registry);
  factory ListBillingEventsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListBillingEventsResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListBillingEventsResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.admin.v1'),
      createEmptyInstance: ListBillingEventsResponse.$_createMessage)
    ..pPM<BillingEventEntry>(1, _omitFieldNames ? '' : 'events',
        subBuilder: BillingEventEntry.$_createMessage)
    ..aOM<$1.PaginatedResponse>(2, _omitFieldNames ? '' : 'pageInfo',
        subBuilder: $1.PaginatedResponse.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListBillingEventsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListBillingEventsResponse copyWith(
          void Function(ListBillingEventsResponse) updates) =>
      super.copyWith((message) => updates(message as ListBillingEventsResponse))
          as ListBillingEventsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ListBillingEventsResponse() / ListBillingEventsResponse.new instead')
  static ListBillingEventsResponse create() => ListBillingEventsResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      ListBillingEventsResponse._();
  @$core.override
  ListBillingEventsResponse createEmptyInstance() =>
      ListBillingEventsResponse._();
  @$core.pragma('dart2js:noInline')
  static ListBillingEventsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListBillingEventsResponse>(
          ListBillingEventsResponse.$_createMessage);
  static ListBillingEventsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<BillingEventEntry> get events => $_getList(0);

  @$pb.TagNumber(2)
  $1.PaginatedResponse get pageInfo => $_getN(1);
  @$pb.TagNumber(2)
  set pageInfo($1.PaginatedResponse value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasPageInfo() => $_has(1);
  @$pb.TagNumber(2)
  void clearPageInfo() => $_clearField(2);
  @$pb.TagNumber(2)
  $1.PaginatedResponse ensurePageInfo() => $_ensure(1);
}

class GetInvoiceHistoryRequest extends $pb.GeneratedMessage {
  factory GetInvoiceHistoryRequest({
    $1.UUID? workspaceId,
    $1.Pagination? pagination,
  }) {
    final result = GetInvoiceHistoryRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (pagination != null) result.pagination = pagination;
    return result;
  }

  GetInvoiceHistoryRequest._();

  factory GetInvoiceHistoryRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetInvoiceHistoryRequest()..mergeFromBuffer(data, registry);
  factory GetInvoiceHistoryRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetInvoiceHistoryRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetInvoiceHistoryRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.admin.v1'),
      createEmptyInstance: GetInvoiceHistoryRequest.$_createMessage)
    ..aOM<$1.UUID>(1, _omitFieldNames ? '' : 'workspaceId',
        subBuilder: $1.UUID.$_createMessage)
    ..aOM<$1.Pagination>(2, _omitFieldNames ? '' : 'pagination',
        subBuilder: $1.Pagination.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetInvoiceHistoryRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetInvoiceHistoryRequest copyWith(
          void Function(GetInvoiceHistoryRequest) updates) =>
      super.copyWith((message) => updates(message as GetInvoiceHistoryRequest))
          as GetInvoiceHistoryRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use GetInvoiceHistoryRequest() / GetInvoiceHistoryRequest.new instead')
  static GetInvoiceHistoryRequest create() => GetInvoiceHistoryRequest._();
  static $pb.GeneratedMessage $_createMessage() => GetInvoiceHistoryRequest._();
  @$core.override
  GetInvoiceHistoryRequest createEmptyInstance() =>
      GetInvoiceHistoryRequest._();
  @$core.pragma('dart2js:noInline')
  static GetInvoiceHistoryRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetInvoiceHistoryRequest>(
          GetInvoiceHistoryRequest.$_createMessage);
  static GetInvoiceHistoryRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $1.UUID get workspaceId => $_getN(0);
  @$pb.TagNumber(1)
  set workspaceId($1.UUID value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);
  @$pb.TagNumber(1)
  $1.UUID ensureWorkspaceId() => $_ensure(0);

  @$pb.TagNumber(2)
  $1.Pagination get pagination => $_getN(1);
  @$pb.TagNumber(2)
  set pagination($1.Pagination value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasPagination() => $_has(1);
  @$pb.TagNumber(2)
  void clearPagination() => $_clearField(2);
  @$pb.TagNumber(2)
  $1.Pagination ensurePagination() => $_ensure(1);
}

class GetInvoiceHistoryResponse extends $pb.GeneratedMessage {
  factory GetInvoiceHistoryResponse({
    $core.Iterable<InvoiceSummary>? invoices,
    $1.PaginatedResponse? pageInfo,
  }) {
    final result = GetInvoiceHistoryResponse._();
    if (invoices != null) result.invoices.addAll(invoices);
    if (pageInfo != null) result.pageInfo = pageInfo;
    return result;
  }

  GetInvoiceHistoryResponse._();

  factory GetInvoiceHistoryResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetInvoiceHistoryResponse()..mergeFromBuffer(data, registry);
  factory GetInvoiceHistoryResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetInvoiceHistoryResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetInvoiceHistoryResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.admin.v1'),
      createEmptyInstance: GetInvoiceHistoryResponse.$_createMessage)
    ..pPM<InvoiceSummary>(1, _omitFieldNames ? '' : 'invoices',
        subBuilder: InvoiceSummary.$_createMessage)
    ..aOM<$1.PaginatedResponse>(2, _omitFieldNames ? '' : 'pageInfo',
        subBuilder: $1.PaginatedResponse.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetInvoiceHistoryResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetInvoiceHistoryResponse copyWith(
          void Function(GetInvoiceHistoryResponse) updates) =>
      super.copyWith((message) => updates(message as GetInvoiceHistoryResponse))
          as GetInvoiceHistoryResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use GetInvoiceHistoryResponse() / GetInvoiceHistoryResponse.new instead')
  static GetInvoiceHistoryResponse create() => GetInvoiceHistoryResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      GetInvoiceHistoryResponse._();
  @$core.override
  GetInvoiceHistoryResponse createEmptyInstance() =>
      GetInvoiceHistoryResponse._();
  @$core.pragma('dart2js:noInline')
  static GetInvoiceHistoryResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetInvoiceHistoryResponse>(
          GetInvoiceHistoryResponse.$_createMessage);
  static GetInvoiceHistoryResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<InvoiceSummary> get invoices => $_getList(0);

  @$pb.TagNumber(2)
  $1.PaginatedResponse get pageInfo => $_getN(1);
  @$pb.TagNumber(2)
  set pageInfo($1.PaginatedResponse value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasPageInfo() => $_has(1);
  @$pb.TagNumber(2)
  void clearPageInfo() => $_clearField(2);
  @$pb.TagNumber(2)
  $1.PaginatedResponse ensurePageInfo() => $_ensure(1);
}

class DownloadInvoiceRequest extends $pb.GeneratedMessage {
  factory DownloadInvoiceRequest({
    $1.CommandContext? context,
    $1.UUID? invoiceId,
  }) {
    final result = DownloadInvoiceRequest._();
    if (context != null) result.context = context;
    if (invoiceId != null) result.invoiceId = invoiceId;
    return result;
  }

  DownloadInvoiceRequest._();

  factory DownloadInvoiceRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      DownloadInvoiceRequest()..mergeFromBuffer(data, registry);
  factory DownloadInvoiceRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      DownloadInvoiceRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DownloadInvoiceRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.admin.v1'),
      createEmptyInstance: DownloadInvoiceRequest.$_createMessage)
    ..aOM<$1.CommandContext>(1, _omitFieldNames ? '' : 'context',
        subBuilder: $1.CommandContext.$_createMessage)
    ..aOM<$1.UUID>(2, _omitFieldNames ? '' : 'invoiceId',
        subBuilder: $1.UUID.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DownloadInvoiceRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DownloadInvoiceRequest copyWith(
          void Function(DownloadInvoiceRequest) updates) =>
      super.copyWith((message) => updates(message as DownloadInvoiceRequest))
          as DownloadInvoiceRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use DownloadInvoiceRequest() / DownloadInvoiceRequest.new instead')
  static DownloadInvoiceRequest create() => DownloadInvoiceRequest._();
  static $pb.GeneratedMessage $_createMessage() => DownloadInvoiceRequest._();
  @$core.override
  DownloadInvoiceRequest createEmptyInstance() => DownloadInvoiceRequest._();
  @$core.pragma('dart2js:noInline')
  static DownloadInvoiceRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DownloadInvoiceRequest>(
          DownloadInvoiceRequest.$_createMessage);
  static DownloadInvoiceRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $1.CommandContext get context => $_getN(0);
  @$pb.TagNumber(1)
  set context($1.CommandContext value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasContext() => $_has(0);
  @$pb.TagNumber(1)
  void clearContext() => $_clearField(1);
  @$pb.TagNumber(1)
  $1.CommandContext ensureContext() => $_ensure(0);

  @$pb.TagNumber(2)
  $1.UUID get invoiceId => $_getN(1);
  @$pb.TagNumber(2)
  set invoiceId($1.UUID value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasInvoiceId() => $_has(1);
  @$pb.TagNumber(2)
  void clearInvoiceId() => $_clearField(2);
  @$pb.TagNumber(2)
  $1.UUID ensureInvoiceId() => $_ensure(1);
}

class DownloadInvoiceResponse extends $pb.GeneratedMessage {
  factory DownloadInvoiceResponse({
    $core.String? invoicePdfUrl,
    $core.String? hostedInvoiceUrl,
    InvoiceSummary? invoice,
  }) {
    final result = DownloadInvoiceResponse._();
    if (invoicePdfUrl != null) result.invoicePdfUrl = invoicePdfUrl;
    if (hostedInvoiceUrl != null) result.hostedInvoiceUrl = hostedInvoiceUrl;
    if (invoice != null) result.invoice = invoice;
    return result;
  }

  DownloadInvoiceResponse._();

  factory DownloadInvoiceResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      DownloadInvoiceResponse()..mergeFromBuffer(data, registry);
  factory DownloadInvoiceResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      DownloadInvoiceResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DownloadInvoiceResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.admin.v1'),
      createEmptyInstance: DownloadInvoiceResponse.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'invoicePdfUrl')
    ..aOS(2, _omitFieldNames ? '' : 'hostedInvoiceUrl')
    ..aOM<InvoiceSummary>(3, _omitFieldNames ? '' : 'invoice',
        subBuilder: InvoiceSummary.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DownloadInvoiceResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DownloadInvoiceResponse copyWith(
          void Function(DownloadInvoiceResponse) updates) =>
      super.copyWith((message) => updates(message as DownloadInvoiceResponse))
          as DownloadInvoiceResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use DownloadInvoiceResponse() / DownloadInvoiceResponse.new instead')
  static DownloadInvoiceResponse create() => DownloadInvoiceResponse._();
  static $pb.GeneratedMessage $_createMessage() => DownloadInvoiceResponse._();
  @$core.override
  DownloadInvoiceResponse createEmptyInstance() => DownloadInvoiceResponse._();
  @$core.pragma('dart2js:noInline')
  static DownloadInvoiceResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DownloadInvoiceResponse>(
          DownloadInvoiceResponse.$_createMessage);
  static DownloadInvoiceResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get invoicePdfUrl => $_getSZ(0);
  @$pb.TagNumber(1)
  set invoicePdfUrl($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasInvoicePdfUrl() => $_has(0);
  @$pb.TagNumber(1)
  void clearInvoicePdfUrl() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get hostedInvoiceUrl => $_getSZ(1);
  @$pb.TagNumber(2)
  set hostedInvoiceUrl($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasHostedInvoiceUrl() => $_has(1);
  @$pb.TagNumber(2)
  void clearHostedInvoiceUrl() => $_clearField(2);

  @$pb.TagNumber(3)
  InvoiceSummary get invoice => $_getN(2);
  @$pb.TagNumber(3)
  set invoice(InvoiceSummary value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasInvoice() => $_has(2);
  @$pb.TagNumber(3)
  void clearInvoice() => $_clearField(3);
  @$pb.TagNumber(3)
  InvoiceSummary ensureInvoice() => $_ensure(2);
}

class GetUsageReportRequest extends $pb.GeneratedMessage {
  factory GetUsageReportRequest({
    $1.UUID? workspaceId,
    $core.String? periodStart,
    $core.String? periodEnd,
  }) {
    final result = GetUsageReportRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (periodStart != null) result.periodStart = periodStart;
    if (periodEnd != null) result.periodEnd = periodEnd;
    return result;
  }

  GetUsageReportRequest._();

  factory GetUsageReportRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetUsageReportRequest()..mergeFromBuffer(data, registry);
  factory GetUsageReportRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetUsageReportRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetUsageReportRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.admin.v1'),
      createEmptyInstance: GetUsageReportRequest.$_createMessage)
    ..aOM<$1.UUID>(1, _omitFieldNames ? '' : 'workspaceId',
        subBuilder: $1.UUID.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'periodStart')
    ..aOS(3, _omitFieldNames ? '' : 'periodEnd')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetUsageReportRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetUsageReportRequest copyWith(
          void Function(GetUsageReportRequest) updates) =>
      super.copyWith((message) => updates(message as GetUsageReportRequest))
          as GetUsageReportRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use GetUsageReportRequest() / GetUsageReportRequest.new instead')
  static GetUsageReportRequest create() => GetUsageReportRequest._();
  static $pb.GeneratedMessage $_createMessage() => GetUsageReportRequest._();
  @$core.override
  GetUsageReportRequest createEmptyInstance() => GetUsageReportRequest._();
  @$core.pragma('dart2js:noInline')
  static GetUsageReportRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetUsageReportRequest>(
          GetUsageReportRequest.$_createMessage);
  static GetUsageReportRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $1.UUID get workspaceId => $_getN(0);
  @$pb.TagNumber(1)
  set workspaceId($1.UUID value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);
  @$pb.TagNumber(1)
  $1.UUID ensureWorkspaceId() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get periodStart => $_getSZ(1);
  @$pb.TagNumber(2)
  set periodStart($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPeriodStart() => $_has(1);
  @$pb.TagNumber(2)
  void clearPeriodStart() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get periodEnd => $_getSZ(2);
  @$pb.TagNumber(3)
  set periodEnd($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPeriodEnd() => $_has(2);
  @$pb.TagNumber(3)
  void clearPeriodEnd() => $_clearField(3);
}

class GetUsageReportResponse extends $pb.GeneratedMessage {
  factory GetUsageReportResponse({
    CreditBalance? balance,
    $core.Iterable<OperationUsageBreakdown>? breakdown,
    $core.String? overageCreditsUsed,
    $core.String? overageLimitCredits,
    $1.Money? overageChargeUsd,
    $core.Iterable<$core.String>? triggeredThresholdAlerts,
  }) {
    final result = GetUsageReportResponse._();
    if (balance != null) result.balance = balance;
    if (breakdown != null) result.breakdown.addAll(breakdown);
    if (overageCreditsUsed != null)
      result.overageCreditsUsed = overageCreditsUsed;
    if (overageLimitCredits != null)
      result.overageLimitCredits = overageLimitCredits;
    if (overageChargeUsd != null) result.overageChargeUsd = overageChargeUsd;
    if (triggeredThresholdAlerts != null)
      result.triggeredThresholdAlerts.addAll(triggeredThresholdAlerts);
    return result;
  }

  GetUsageReportResponse._();

  factory GetUsageReportResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetUsageReportResponse()..mergeFromBuffer(data, registry);
  factory GetUsageReportResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetUsageReportResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetUsageReportResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.admin.v1'),
      createEmptyInstance: GetUsageReportResponse.$_createMessage)
    ..aOM<CreditBalance>(1, _omitFieldNames ? '' : 'balance',
        subBuilder: CreditBalance.$_createMessage)
    ..pPM<OperationUsageBreakdown>(2, _omitFieldNames ? '' : 'breakdown',
        subBuilder: OperationUsageBreakdown.$_createMessage)
    ..aOS(3, _omitFieldNames ? '' : 'overageCreditsUsed')
    ..aOS(4, _omitFieldNames ? '' : 'overageLimitCredits')
    ..aOM<$1.Money>(5, _omitFieldNames ? '' : 'overageChargeUsd',
        subBuilder: $1.Money.$_createMessage)
    ..pPS(6, _omitFieldNames ? '' : 'triggeredThresholdAlerts')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetUsageReportResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetUsageReportResponse copyWith(
          void Function(GetUsageReportResponse) updates) =>
      super.copyWith((message) => updates(message as GetUsageReportResponse))
          as GetUsageReportResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use GetUsageReportResponse() / GetUsageReportResponse.new instead')
  static GetUsageReportResponse create() => GetUsageReportResponse._();
  static $pb.GeneratedMessage $_createMessage() => GetUsageReportResponse._();
  @$core.override
  GetUsageReportResponse createEmptyInstance() => GetUsageReportResponse._();
  @$core.pragma('dart2js:noInline')
  static GetUsageReportResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetUsageReportResponse>(
          GetUsageReportResponse.$_createMessage);
  static GetUsageReportResponse? _defaultInstance;

  @$pb.TagNumber(1)
  CreditBalance get balance => $_getN(0);
  @$pb.TagNumber(1)
  set balance(CreditBalance value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasBalance() => $_has(0);
  @$pb.TagNumber(1)
  void clearBalance() => $_clearField(1);
  @$pb.TagNumber(1)
  CreditBalance ensureBalance() => $_ensure(0);

  @$pb.TagNumber(2)
  $pb.PbList<OperationUsageBreakdown> get breakdown => $_getList(1);

  @$pb.TagNumber(3)
  $core.String get overageCreditsUsed => $_getSZ(2);
  @$pb.TagNumber(3)
  set overageCreditsUsed($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasOverageCreditsUsed() => $_has(2);
  @$pb.TagNumber(3)
  void clearOverageCreditsUsed() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get overageLimitCredits => $_getSZ(3);
  @$pb.TagNumber(4)
  set overageLimitCredits($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasOverageLimitCredits() => $_has(3);
  @$pb.TagNumber(4)
  void clearOverageLimitCredits() => $_clearField(4);

  @$pb.TagNumber(5)
  $1.Money get overageChargeUsd => $_getN(4);
  @$pb.TagNumber(5)
  set overageChargeUsd($1.Money value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasOverageChargeUsd() => $_has(4);
  @$pb.TagNumber(5)
  void clearOverageChargeUsd() => $_clearField(5);
  @$pb.TagNumber(5)
  $1.Money ensureOverageChargeUsd() => $_ensure(4);

  @$pb.TagNumber(6)
  $pb.PbList<$core.String> get triggeredThresholdAlerts => $_getList(5);
}

/// Data Export & Retention Evidence Messages (P8-02 Acceptance Target #3)
class DataExportJobSummary extends $pb.GeneratedMessage {
  factory DataExportJobSummary({
    $1.UUID? exportId,
    $1.UUID? workspaceId,
    $1.UUID? userId,
    $core.String? exportType,
    $core.String? format,
    $core.String? status,
    $core.int? progressPct,
    $core.String? fileUrl,
    $fixnum.Int64? fileSizeBytes,
    $core.String? contentHashSha512,
    $2.Timestamp? expiresAt,
    $2.Timestamp? completedAt,
    $2.Timestamp? createdAt,
  }) {
    final result = DataExportJobSummary._();
    if (exportId != null) result.exportId = exportId;
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (userId != null) result.userId = userId;
    if (exportType != null) result.exportType = exportType;
    if (format != null) result.format = format;
    if (status != null) result.status = status;
    if (progressPct != null) result.progressPct = progressPct;
    if (fileUrl != null) result.fileUrl = fileUrl;
    if (fileSizeBytes != null) result.fileSizeBytes = fileSizeBytes;
    if (contentHashSha512 != null) result.contentHashSha512 = contentHashSha512;
    if (expiresAt != null) result.expiresAt = expiresAt;
    if (completedAt != null) result.completedAt = completedAt;
    if (createdAt != null) result.createdAt = createdAt;
    return result;
  }

  DataExportJobSummary._();

  factory DataExportJobSummary.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      DataExportJobSummary()..mergeFromBuffer(data, registry);
  factory DataExportJobSummary.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      DataExportJobSummary()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DataExportJobSummary',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.admin.v1'),
      createEmptyInstance: DataExportJobSummary.$_createMessage)
    ..aOM<$1.UUID>(1, _omitFieldNames ? '' : 'exportId',
        subBuilder: $1.UUID.$_createMessage)
    ..aOM<$1.UUID>(2, _omitFieldNames ? '' : 'workspaceId',
        subBuilder: $1.UUID.$_createMessage)
    ..aOM<$1.UUID>(3, _omitFieldNames ? '' : 'userId',
        subBuilder: $1.UUID.$_createMessage)
    ..aOS(4, _omitFieldNames ? '' : 'exportType')
    ..aOS(5, _omitFieldNames ? '' : 'format')
    ..aOS(6, _omitFieldNames ? '' : 'status')
    ..aI(7, _omitFieldNames ? '' : 'progressPct')
    ..aOS(8, _omitFieldNames ? '' : 'fileUrl')
    ..aInt64(9, _omitFieldNames ? '' : 'fileSizeBytes')
    ..aOS(10, _omitFieldNames ? '' : 'contentHashSha512')
    ..aOM<$2.Timestamp>(11, _omitFieldNames ? '' : 'expiresAt',
        subBuilder: $2.Timestamp.$_createMessage)
    ..aOM<$2.Timestamp>(12, _omitFieldNames ? '' : 'completedAt',
        subBuilder: $2.Timestamp.$_createMessage)
    ..aOM<$2.Timestamp>(13, _omitFieldNames ? '' : 'createdAt',
        subBuilder: $2.Timestamp.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DataExportJobSummary clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DataExportJobSummary copyWith(void Function(DataExportJobSummary) updates) =>
      super.copyWith((message) => updates(message as DataExportJobSummary))
          as DataExportJobSummary;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use DataExportJobSummary() / DataExportJobSummary.new instead')
  static DataExportJobSummary create() => DataExportJobSummary._();
  static $pb.GeneratedMessage $_createMessage() => DataExportJobSummary._();
  @$core.override
  DataExportJobSummary createEmptyInstance() => DataExportJobSummary._();
  @$core.pragma('dart2js:noInline')
  static DataExportJobSummary getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DataExportJobSummary>(
          DataExportJobSummary.$_createMessage);
  static DataExportJobSummary? _defaultInstance;

  @$pb.TagNumber(1)
  $1.UUID get exportId => $_getN(0);
  @$pb.TagNumber(1)
  set exportId($1.UUID value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasExportId() => $_has(0);
  @$pb.TagNumber(1)
  void clearExportId() => $_clearField(1);
  @$pb.TagNumber(1)
  $1.UUID ensureExportId() => $_ensure(0);

  @$pb.TagNumber(2)
  $1.UUID get workspaceId => $_getN(1);
  @$pb.TagNumber(2)
  set workspaceId($1.UUID value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasWorkspaceId() => $_has(1);
  @$pb.TagNumber(2)
  void clearWorkspaceId() => $_clearField(2);
  @$pb.TagNumber(2)
  $1.UUID ensureWorkspaceId() => $_ensure(1);

  @$pb.TagNumber(3)
  $1.UUID get userId => $_getN(2);
  @$pb.TagNumber(3)
  set userId($1.UUID value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasUserId() => $_has(2);
  @$pb.TagNumber(3)
  void clearUserId() => $_clearField(3);
  @$pb.TagNumber(3)
  $1.UUID ensureUserId() => $_ensure(2);

  @$pb.TagNumber(4)
  $core.String get exportType => $_getSZ(3);
  @$pb.TagNumber(4)
  set exportType($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasExportType() => $_has(3);
  @$pb.TagNumber(4)
  void clearExportType() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get format => $_getSZ(4);
  @$pb.TagNumber(5)
  set format($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasFormat() => $_has(4);
  @$pb.TagNumber(5)
  void clearFormat() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get status => $_getSZ(5);
  @$pb.TagNumber(6)
  set status($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasStatus() => $_has(5);
  @$pb.TagNumber(6)
  void clearStatus() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.int get progressPct => $_getIZ(6);
  @$pb.TagNumber(7)
  set progressPct($core.int value) => $_setSignedInt32(6, value);
  @$pb.TagNumber(7)
  $core.bool hasProgressPct() => $_has(6);
  @$pb.TagNumber(7)
  void clearProgressPct() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get fileUrl => $_getSZ(7);
  @$pb.TagNumber(8)
  set fileUrl($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasFileUrl() => $_has(7);
  @$pb.TagNumber(8)
  void clearFileUrl() => $_clearField(8);

  @$pb.TagNumber(9)
  $fixnum.Int64 get fileSizeBytes => $_getI64(8);
  @$pb.TagNumber(9)
  set fileSizeBytes($fixnum.Int64 value) => $_setInt64(8, value);
  @$pb.TagNumber(9)
  $core.bool hasFileSizeBytes() => $_has(8);
  @$pb.TagNumber(9)
  void clearFileSizeBytes() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.String get contentHashSha512 => $_getSZ(9);
  @$pb.TagNumber(10)
  set contentHashSha512($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasContentHashSha512() => $_has(9);
  @$pb.TagNumber(10)
  void clearContentHashSha512() => $_clearField(10);

  @$pb.TagNumber(11)
  $2.Timestamp get expiresAt => $_getN(10);
  @$pb.TagNumber(11)
  set expiresAt($2.Timestamp value) => $_setField(11, value);
  @$pb.TagNumber(11)
  $core.bool hasExpiresAt() => $_has(10);
  @$pb.TagNumber(11)
  void clearExpiresAt() => $_clearField(11);
  @$pb.TagNumber(11)
  $2.Timestamp ensureExpiresAt() => $_ensure(10);

  @$pb.TagNumber(12)
  $2.Timestamp get completedAt => $_getN(11);
  @$pb.TagNumber(12)
  set completedAt($2.Timestamp value) => $_setField(12, value);
  @$pb.TagNumber(12)
  $core.bool hasCompletedAt() => $_has(11);
  @$pb.TagNumber(12)
  void clearCompletedAt() => $_clearField(12);
  @$pb.TagNumber(12)
  $2.Timestamp ensureCompletedAt() => $_ensure(11);

  @$pb.TagNumber(13)
  $2.Timestamp get createdAt => $_getN(12);
  @$pb.TagNumber(13)
  set createdAt($2.Timestamp value) => $_setField(13, value);
  @$pb.TagNumber(13)
  $core.bool hasCreatedAt() => $_has(12);
  @$pb.TagNumber(13)
  void clearCreatedAt() => $_clearField(13);
  @$pb.TagNumber(13)
  $2.Timestamp ensureCreatedAt() => $_ensure(12);
}

class RequestExportRequest extends $pb.GeneratedMessage {
  factory RequestExportRequest({
    $1.CommandContext? context,
    $core.String? exportType,
    $core.String? format,
  }) {
    final result = RequestExportRequest._();
    if (context != null) result.context = context;
    if (exportType != null) result.exportType = exportType;
    if (format != null) result.format = format;
    return result;
  }

  RequestExportRequest._();

  factory RequestExportRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RequestExportRequest()..mergeFromBuffer(data, registry);
  factory RequestExportRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RequestExportRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RequestExportRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.admin.v1'),
      createEmptyInstance: RequestExportRequest.$_createMessage)
    ..aOM<$1.CommandContext>(1, _omitFieldNames ? '' : 'context',
        subBuilder: $1.CommandContext.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'exportType')
    ..aOS(3, _omitFieldNames ? '' : 'format')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestExportRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestExportRequest copyWith(void Function(RequestExportRequest) updates) =>
      super.copyWith((message) => updates(message as RequestExportRequest))
          as RequestExportRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use RequestExportRequest() / RequestExportRequest.new instead')
  static RequestExportRequest create() => RequestExportRequest._();
  static $pb.GeneratedMessage $_createMessage() => RequestExportRequest._();
  @$core.override
  RequestExportRequest createEmptyInstance() => RequestExportRequest._();
  @$core.pragma('dart2js:noInline')
  static RequestExportRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RequestExportRequest>(
          RequestExportRequest.$_createMessage);
  static RequestExportRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $1.CommandContext get context => $_getN(0);
  @$pb.TagNumber(1)
  set context($1.CommandContext value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasContext() => $_has(0);
  @$pb.TagNumber(1)
  void clearContext() => $_clearField(1);
  @$pb.TagNumber(1)
  $1.CommandContext ensureContext() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get exportType => $_getSZ(1);
  @$pb.TagNumber(2)
  set exportType($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasExportType() => $_has(1);
  @$pb.TagNumber(2)
  void clearExportType() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get format => $_getSZ(2);
  @$pb.TagNumber(3)
  set format($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasFormat() => $_has(2);
  @$pb.TagNumber(3)
  void clearFormat() => $_clearField(3);
}

class RequestExportResponse extends $pb.GeneratedMessage {
  factory RequestExportResponse({
    DataExportJobSummary? exportJob,
  }) {
    final result = RequestExportResponse._();
    if (exportJob != null) result.exportJob = exportJob;
    return result;
  }

  RequestExportResponse._();

  factory RequestExportResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RequestExportResponse()..mergeFromBuffer(data, registry);
  factory RequestExportResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RequestExportResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RequestExportResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.admin.v1'),
      createEmptyInstance: RequestExportResponse.$_createMessage)
    ..aOM<DataExportJobSummary>(1, _omitFieldNames ? '' : 'exportJob',
        subBuilder: DataExportJobSummary.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestExportResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequestExportResponse copyWith(
          void Function(RequestExportResponse) updates) =>
      super.copyWith((message) => updates(message as RequestExportResponse))
          as RequestExportResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use RequestExportResponse() / RequestExportResponse.new instead')
  static RequestExportResponse create() => RequestExportResponse._();
  static $pb.GeneratedMessage $_createMessage() => RequestExportResponse._();
  @$core.override
  RequestExportResponse createEmptyInstance() => RequestExportResponse._();
  @$core.pragma('dart2js:noInline')
  static RequestExportResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RequestExportResponse>(
          RequestExportResponse.$_createMessage);
  static RequestExportResponse? _defaultInstance;

  @$pb.TagNumber(1)
  DataExportJobSummary get exportJob => $_getN(0);
  @$pb.TagNumber(1)
  set exportJob(DataExportJobSummary value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasExportJob() => $_has(0);
  @$pb.TagNumber(1)
  void clearExportJob() => $_clearField(1);
  @$pb.TagNumber(1)
  DataExportJobSummary ensureExportJob() => $_ensure(0);
}

class GetExportUrlRequest extends $pb.GeneratedMessage {
  factory GetExportUrlRequest({
    $1.UUID? workspaceId,
    $1.UUID? exportId,
  }) {
    final result = GetExportUrlRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (exportId != null) result.exportId = exportId;
    return result;
  }

  GetExportUrlRequest._();

  factory GetExportUrlRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetExportUrlRequest()..mergeFromBuffer(data, registry);
  factory GetExportUrlRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetExportUrlRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetExportUrlRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.admin.v1'),
      createEmptyInstance: GetExportUrlRequest.$_createMessage)
    ..aOM<$1.UUID>(1, _omitFieldNames ? '' : 'workspaceId',
        subBuilder: $1.UUID.$_createMessage)
    ..aOM<$1.UUID>(2, _omitFieldNames ? '' : 'exportId',
        subBuilder: $1.UUID.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetExportUrlRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetExportUrlRequest copyWith(void Function(GetExportUrlRequest) updates) =>
      super.copyWith((message) => updates(message as GetExportUrlRequest))
          as GetExportUrlRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core
      .Deprecated('Use GetExportUrlRequest() / GetExportUrlRequest.new instead')
  static GetExportUrlRequest create() => GetExportUrlRequest._();
  static $pb.GeneratedMessage $_createMessage() => GetExportUrlRequest._();
  @$core.override
  GetExportUrlRequest createEmptyInstance() => GetExportUrlRequest._();
  @$core.pragma('dart2js:noInline')
  static GetExportUrlRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetExportUrlRequest>(
          GetExportUrlRequest.$_createMessage);
  static GetExportUrlRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $1.UUID get workspaceId => $_getN(0);
  @$pb.TagNumber(1)
  set workspaceId($1.UUID value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);
  @$pb.TagNumber(1)
  $1.UUID ensureWorkspaceId() => $_ensure(0);

  @$pb.TagNumber(2)
  $1.UUID get exportId => $_getN(1);
  @$pb.TagNumber(2)
  set exportId($1.UUID value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasExportId() => $_has(1);
  @$pb.TagNumber(2)
  void clearExportId() => $_clearField(2);
  @$pb.TagNumber(2)
  $1.UUID ensureExportId() => $_ensure(1);
}

class GetExportUrlResponse extends $pb.GeneratedMessage {
  factory GetExportUrlResponse({
    DataExportJobSummary? exportJob,
    $core.String? downloadUrl,
  }) {
    final result = GetExportUrlResponse._();
    if (exportJob != null) result.exportJob = exportJob;
    if (downloadUrl != null) result.downloadUrl = downloadUrl;
    return result;
  }

  GetExportUrlResponse._();

  factory GetExportUrlResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetExportUrlResponse()..mergeFromBuffer(data, registry);
  factory GetExportUrlResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetExportUrlResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetExportUrlResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.admin.v1'),
      createEmptyInstance: GetExportUrlResponse.$_createMessage)
    ..aOM<DataExportJobSummary>(1, _omitFieldNames ? '' : 'exportJob',
        subBuilder: DataExportJobSummary.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'downloadUrl')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetExportUrlResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetExportUrlResponse copyWith(void Function(GetExportUrlResponse) updates) =>
      super.copyWith((message) => updates(message as GetExportUrlResponse))
          as GetExportUrlResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use GetExportUrlResponse() / GetExportUrlResponse.new instead')
  static GetExportUrlResponse create() => GetExportUrlResponse._();
  static $pb.GeneratedMessage $_createMessage() => GetExportUrlResponse._();
  @$core.override
  GetExportUrlResponse createEmptyInstance() => GetExportUrlResponse._();
  @$core.pragma('dart2js:noInline')
  static GetExportUrlResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetExportUrlResponse>(
          GetExportUrlResponse.$_createMessage);
  static GetExportUrlResponse? _defaultInstance;

  @$pb.TagNumber(1)
  DataExportJobSummary get exportJob => $_getN(0);
  @$pb.TagNumber(1)
  set exportJob(DataExportJobSummary value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasExportJob() => $_has(0);
  @$pb.TagNumber(1)
  void clearExportJob() => $_clearField(1);
  @$pb.TagNumber(1)
  DataExportJobSummary ensureExportJob() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get downloadUrl => $_getSZ(1);
  @$pb.TagNumber(2)
  set downloadUrl($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasDownloadUrl() => $_has(1);
  @$pb.TagNumber(2)
  void clearDownloadUrl() => $_clearField(2);
}

class EstimateCostRequest extends $pb.GeneratedMessage {
  factory EstimateCostRequest({
    $1.CommandContext? context,
    $core.String? operationType,
    $core.String? provider,
    $core.String? modelId,
    $core.String? fallbackProvider,
    $core.String? fallbackModelId,
    $core.int? maxProviderAttempts,
    $core.Iterable<$core.MapEntry<$core.String, $core.String>>? measuredUnits,
  }) {
    final result = EstimateCostRequest._();
    if (context != null) result.context = context;
    if (operationType != null) result.operationType = operationType;
    if (provider != null) result.provider = provider;
    if (modelId != null) result.modelId = modelId;
    if (fallbackProvider != null) result.fallbackProvider = fallbackProvider;
    if (fallbackModelId != null) result.fallbackModelId = fallbackModelId;
    if (maxProviderAttempts != null)
      result.maxProviderAttempts = maxProviderAttempts;
    if (measuredUnits != null) result.measuredUnits.addEntries(measuredUnits);
    return result;
  }

  EstimateCostRequest._();

  factory EstimateCostRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      EstimateCostRequest()..mergeFromBuffer(data, registry);
  factory EstimateCostRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      EstimateCostRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'EstimateCostRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.admin.v1'),
      createEmptyInstance: EstimateCostRequest.$_createMessage)
    ..aOM<$1.CommandContext>(1, _omitFieldNames ? '' : 'context',
        subBuilder: $1.CommandContext.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'operationType')
    ..aOS(3, _omitFieldNames ? '' : 'provider')
    ..aOS(4, _omitFieldNames ? '' : 'modelId')
    ..aOS(5, _omitFieldNames ? '' : 'fallbackProvider')
    ..aOS(6, _omitFieldNames ? '' : 'fallbackModelId')
    ..aI(7, _omitFieldNames ? '' : 'maxProviderAttempts')
    ..m<$core.String, $core.String>(8, _omitFieldNames ? '' : 'measuredUnits',
        entryClassName: 'EstimateCostRequest.MeasuredUnitsEntry',
        keyFieldType: $pb.PbFieldType.OS,
        valueFieldType: $pb.PbFieldType.OS,
        packageName: const $pb.PackageName('creativanta.admin.v1'))
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EstimateCostRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EstimateCostRequest copyWith(void Function(EstimateCostRequest) updates) =>
      super.copyWith((message) => updates(message as EstimateCostRequest))
          as EstimateCostRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core
      .Deprecated('Use EstimateCostRequest() / EstimateCostRequest.new instead')
  static EstimateCostRequest create() => EstimateCostRequest._();
  static $pb.GeneratedMessage $_createMessage() => EstimateCostRequest._();
  @$core.override
  EstimateCostRequest createEmptyInstance() => EstimateCostRequest._();
  @$core.pragma('dart2js:noInline')
  static EstimateCostRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<EstimateCostRequest>(
          EstimateCostRequest.$_createMessage);
  static EstimateCostRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $1.CommandContext get context => $_getN(0);
  @$pb.TagNumber(1)
  set context($1.CommandContext value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasContext() => $_has(0);
  @$pb.TagNumber(1)
  void clearContext() => $_clearField(1);
  @$pb.TagNumber(1)
  $1.CommandContext ensureContext() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get operationType => $_getSZ(1);
  @$pb.TagNumber(2)
  set operationType($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasOperationType() => $_has(1);
  @$pb.TagNumber(2)
  void clearOperationType() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get provider => $_getSZ(2);
  @$pb.TagNumber(3)
  set provider($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasProvider() => $_has(2);
  @$pb.TagNumber(3)
  void clearProvider() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get modelId => $_getSZ(3);
  @$pb.TagNumber(4)
  set modelId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasModelId() => $_has(3);
  @$pb.TagNumber(4)
  void clearModelId() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get fallbackProvider => $_getSZ(4);
  @$pb.TagNumber(5)
  set fallbackProvider($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasFallbackProvider() => $_has(4);
  @$pb.TagNumber(5)
  void clearFallbackProvider() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get fallbackModelId => $_getSZ(5);
  @$pb.TagNumber(6)
  set fallbackModelId($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasFallbackModelId() => $_has(5);
  @$pb.TagNumber(6)
  void clearFallbackModelId() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.int get maxProviderAttempts => $_getIZ(6);
  @$pb.TagNumber(7)
  set maxProviderAttempts($core.int value) => $_setSignedInt32(6, value);
  @$pb.TagNumber(7)
  $core.bool hasMaxProviderAttempts() => $_has(6);
  @$pb.TagNumber(7)
  void clearMaxProviderAttempts() => $_clearField(7);

  @$pb.TagNumber(8)
  $pb.PbMap<$core.String, $core.String> get measuredUnits => $_getMap(7);
}

class EstimateCostResponse extends $pb.GeneratedMessage {
  factory EstimateCostResponse({
    CreditQuote? quote,
    CreditBalance? currentBalance,
    $core.bool? sufficientCredits,
  }) {
    final result = EstimateCostResponse._();
    if (quote != null) result.quote = quote;
    if (currentBalance != null) result.currentBalance = currentBalance;
    if (sufficientCredits != null) result.sufficientCredits = sufficientCredits;
    return result;
  }

  EstimateCostResponse._();

  factory EstimateCostResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      EstimateCostResponse()..mergeFromBuffer(data, registry);
  factory EstimateCostResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      EstimateCostResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'EstimateCostResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.admin.v1'),
      createEmptyInstance: EstimateCostResponse.$_createMessage)
    ..aOM<CreditQuote>(1, _omitFieldNames ? '' : 'quote',
        subBuilder: CreditQuote.$_createMessage)
    ..aOM<CreditBalance>(2, _omitFieldNames ? '' : 'currentBalance',
        subBuilder: CreditBalance.$_createMessage)
    ..aOB(3, _omitFieldNames ? '' : 'sufficientCredits')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EstimateCostResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EstimateCostResponse copyWith(void Function(EstimateCostResponse) updates) =>
      super.copyWith((message) => updates(message as EstimateCostResponse))
          as EstimateCostResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use EstimateCostResponse() / EstimateCostResponse.new instead')
  static EstimateCostResponse create() => EstimateCostResponse._();
  static $pb.GeneratedMessage $_createMessage() => EstimateCostResponse._();
  @$core.override
  EstimateCostResponse createEmptyInstance() => EstimateCostResponse._();
  @$core.pragma('dart2js:noInline')
  static EstimateCostResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<EstimateCostResponse>(
          EstimateCostResponse.$_createMessage);
  static EstimateCostResponse? _defaultInstance;

  @$pb.TagNumber(1)
  CreditQuote get quote => $_getN(0);
  @$pb.TagNumber(1)
  set quote(CreditQuote value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasQuote() => $_has(0);
  @$pb.TagNumber(1)
  void clearQuote() => $_clearField(1);
  @$pb.TagNumber(1)
  CreditQuote ensureQuote() => $_ensure(0);

  @$pb.TagNumber(2)
  CreditBalance get currentBalance => $_getN(1);
  @$pb.TagNumber(2)
  set currentBalance(CreditBalance value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasCurrentBalance() => $_has(1);
  @$pb.TagNumber(2)
  void clearCurrentBalance() => $_clearField(2);
  @$pb.TagNumber(2)
  CreditBalance ensureCurrentBalance() => $_ensure(1);

  @$pb.TagNumber(3)
  $core.bool get sufficientCredits => $_getBF(2);
  @$pb.TagNumber(3)
  set sufficientCredits($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasSufficientCredits() => $_has(2);
  @$pb.TagNumber(3)
  void clearSufficientCredits() => $_clearField(3);
}

class GetBalanceRequest extends $pb.GeneratedMessage {
  factory GetBalanceRequest({
    $1.UUID? workspaceId,
  }) {
    final result = GetBalanceRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    return result;
  }

  GetBalanceRequest._();

  factory GetBalanceRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetBalanceRequest()..mergeFromBuffer(data, registry);
  factory GetBalanceRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetBalanceRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetBalanceRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.admin.v1'),
      createEmptyInstance: GetBalanceRequest.$_createMessage)
    ..aOM<$1.UUID>(1, _omitFieldNames ? '' : 'workspaceId',
        subBuilder: $1.UUID.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetBalanceRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetBalanceRequest copyWith(void Function(GetBalanceRequest) updates) =>
      super.copyWith((message) => updates(message as GetBalanceRequest))
          as GetBalanceRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use GetBalanceRequest() / GetBalanceRequest.new instead')
  static GetBalanceRequest create() => GetBalanceRequest._();
  static $pb.GeneratedMessage $_createMessage() => GetBalanceRequest._();
  @$core.override
  GetBalanceRequest createEmptyInstance() => GetBalanceRequest._();
  @$core.pragma('dart2js:noInline')
  static GetBalanceRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetBalanceRequest>(
          GetBalanceRequest.$_createMessage);
  static GetBalanceRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $1.UUID get workspaceId => $_getN(0);
  @$pb.TagNumber(1)
  set workspaceId($1.UUID value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);
  @$pb.TagNumber(1)
  $1.UUID ensureWorkspaceId() => $_ensure(0);
}

class GetBalanceResponse extends $pb.GeneratedMessage {
  factory GetBalanceResponse({
    CreditBalance? balance,
  }) {
    final result = GetBalanceResponse._();
    if (balance != null) result.balance = balance;
    return result;
  }

  GetBalanceResponse._();

  factory GetBalanceResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetBalanceResponse()..mergeFromBuffer(data, registry);
  factory GetBalanceResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetBalanceResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetBalanceResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.admin.v1'),
      createEmptyInstance: GetBalanceResponse.$_createMessage)
    ..aOM<CreditBalance>(1, _omitFieldNames ? '' : 'balance',
        subBuilder: CreditBalance.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetBalanceResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetBalanceResponse copyWith(void Function(GetBalanceResponse) updates) =>
      super.copyWith((message) => updates(message as GetBalanceResponse))
          as GetBalanceResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use GetBalanceResponse() / GetBalanceResponse.new instead')
  static GetBalanceResponse create() => GetBalanceResponse._();
  static $pb.GeneratedMessage $_createMessage() => GetBalanceResponse._();
  @$core.override
  GetBalanceResponse createEmptyInstance() => GetBalanceResponse._();
  @$core.pragma('dart2js:noInline')
  static GetBalanceResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetBalanceResponse>(
          GetBalanceResponse.$_createMessage);
  static GetBalanceResponse? _defaultInstance;

  @$pb.TagNumber(1)
  CreditBalance get balance => $_getN(0);
  @$pb.TagNumber(1)
  set balance(CreditBalance value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasBalance() => $_has(0);
  @$pb.TagNumber(1)
  void clearBalance() => $_clearField(1);
  @$pb.TagNumber(1)
  CreditBalance ensureBalance() => $_ensure(0);
}

class GetUsageStatsRequest extends $pb.GeneratedMessage {
  factory GetUsageStatsRequest({
    $1.UUID? workspaceId,
  }) {
    final result = GetUsageStatsRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    return result;
  }

  GetUsageStatsRequest._();

  factory GetUsageStatsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetUsageStatsRequest()..mergeFromBuffer(data, registry);
  factory GetUsageStatsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetUsageStatsRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetUsageStatsRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.admin.v1'),
      createEmptyInstance: GetUsageStatsRequest.$_createMessage)
    ..aOM<$1.UUID>(1, _omitFieldNames ? '' : 'workspaceId',
        subBuilder: $1.UUID.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetUsageStatsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetUsageStatsRequest copyWith(void Function(GetUsageStatsRequest) updates) =>
      super.copyWith((message) => updates(message as GetUsageStatsRequest))
          as GetUsageStatsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use GetUsageStatsRequest() / GetUsageStatsRequest.new instead')
  static GetUsageStatsRequest create() => GetUsageStatsRequest._();
  static $pb.GeneratedMessage $_createMessage() => GetUsageStatsRequest._();
  @$core.override
  GetUsageStatsRequest createEmptyInstance() => GetUsageStatsRequest._();
  @$core.pragma('dart2js:noInline')
  static GetUsageStatsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetUsageStatsRequest>(
          GetUsageStatsRequest.$_createMessage);
  static GetUsageStatsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $1.UUID get workspaceId => $_getN(0);
  @$pb.TagNumber(1)
  set workspaceId($1.UUID value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);
  @$pb.TagNumber(1)
  $1.UUID ensureWorkspaceId() => $_ensure(0);
}

class GetUsageStatsResponse extends $pb.GeneratedMessage {
  factory GetUsageStatsResponse({
    $core.String? creditsUsedThisPeriod,
    $core.String? creditsRemaining,
    $core.Iterable<OperationUsageBreakdown>? breakdown,
  }) {
    final result = GetUsageStatsResponse._();
    if (creditsUsedThisPeriod != null)
      result.creditsUsedThisPeriod = creditsUsedThisPeriod;
    if (creditsRemaining != null) result.creditsRemaining = creditsRemaining;
    if (breakdown != null) result.breakdown.addAll(breakdown);
    return result;
  }

  GetUsageStatsResponse._();

  factory GetUsageStatsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetUsageStatsResponse()..mergeFromBuffer(data, registry);
  factory GetUsageStatsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetUsageStatsResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetUsageStatsResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.admin.v1'),
      createEmptyInstance: GetUsageStatsResponse.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'creditsUsedThisPeriod')
    ..aOS(2, _omitFieldNames ? '' : 'creditsRemaining')
    ..pPM<OperationUsageBreakdown>(3, _omitFieldNames ? '' : 'breakdown',
        subBuilder: OperationUsageBreakdown.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetUsageStatsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetUsageStatsResponse copyWith(
          void Function(GetUsageStatsResponse) updates) =>
      super.copyWith((message) => updates(message as GetUsageStatsResponse))
          as GetUsageStatsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use GetUsageStatsResponse() / GetUsageStatsResponse.new instead')
  static GetUsageStatsResponse create() => GetUsageStatsResponse._();
  static $pb.GeneratedMessage $_createMessage() => GetUsageStatsResponse._();
  @$core.override
  GetUsageStatsResponse createEmptyInstance() => GetUsageStatsResponse._();
  @$core.pragma('dart2js:noInline')
  static GetUsageStatsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetUsageStatsResponse>(
          GetUsageStatsResponse.$_createMessage);
  static GetUsageStatsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get creditsUsedThisPeriod => $_getSZ(0);
  @$pb.TagNumber(1)
  set creditsUsedThisPeriod($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCreditsUsedThisPeriod() => $_has(0);
  @$pb.TagNumber(1)
  void clearCreditsUsedThisPeriod() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get creditsRemaining => $_getSZ(1);
  @$pb.TagNumber(2)
  set creditsRemaining($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCreditsRemaining() => $_has(1);
  @$pb.TagNumber(2)
  void clearCreditsRemaining() => $_clearField(2);

  @$pb.TagNumber(3)
  $pb.PbList<OperationUsageBreakdown> get breakdown => $_getList(2);
}

class GetMonthlyUsageRequest extends $pb.GeneratedMessage {
  factory GetMonthlyUsageRequest({
    $1.UUID? workspaceId,
    $core.String? yearMonth,
  }) {
    final result = GetMonthlyUsageRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (yearMonth != null) result.yearMonth = yearMonth;
    return result;
  }

  GetMonthlyUsageRequest._();

  factory GetMonthlyUsageRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetMonthlyUsageRequest()..mergeFromBuffer(data, registry);
  factory GetMonthlyUsageRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetMonthlyUsageRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetMonthlyUsageRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.admin.v1'),
      createEmptyInstance: GetMonthlyUsageRequest.$_createMessage)
    ..aOM<$1.UUID>(1, _omitFieldNames ? '' : 'workspaceId',
        subBuilder: $1.UUID.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'yearMonth')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetMonthlyUsageRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetMonthlyUsageRequest copyWith(
          void Function(GetMonthlyUsageRequest) updates) =>
      super.copyWith((message) => updates(message as GetMonthlyUsageRequest))
          as GetMonthlyUsageRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use GetMonthlyUsageRequest() / GetMonthlyUsageRequest.new instead')
  static GetMonthlyUsageRequest create() => GetMonthlyUsageRequest._();
  static $pb.GeneratedMessage $_createMessage() => GetMonthlyUsageRequest._();
  @$core.override
  GetMonthlyUsageRequest createEmptyInstance() => GetMonthlyUsageRequest._();
  @$core.pragma('dart2js:noInline')
  static GetMonthlyUsageRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetMonthlyUsageRequest>(
          GetMonthlyUsageRequest.$_createMessage);
  static GetMonthlyUsageRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $1.UUID get workspaceId => $_getN(0);
  @$pb.TagNumber(1)
  set workspaceId($1.UUID value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);
  @$pb.TagNumber(1)
  $1.UUID ensureWorkspaceId() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get yearMonth => $_getSZ(1);
  @$pb.TagNumber(2)
  set yearMonth($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasYearMonth() => $_has(1);
  @$pb.TagNumber(2)
  void clearYearMonth() => $_clearField(2);
}

class GetMonthlyUsageResponse extends $pb.GeneratedMessage {
  factory GetMonthlyUsageResponse({
    $core.String? yearMonth,
    $core.String? totalCreditsUsed,
    $core.Iterable<OperationUsageBreakdown>? breakdown,
  }) {
    final result = GetMonthlyUsageResponse._();
    if (yearMonth != null) result.yearMonth = yearMonth;
    if (totalCreditsUsed != null) result.totalCreditsUsed = totalCreditsUsed;
    if (breakdown != null) result.breakdown.addAll(breakdown);
    return result;
  }

  GetMonthlyUsageResponse._();

  factory GetMonthlyUsageResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetMonthlyUsageResponse()..mergeFromBuffer(data, registry);
  factory GetMonthlyUsageResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetMonthlyUsageResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetMonthlyUsageResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.admin.v1'),
      createEmptyInstance: GetMonthlyUsageResponse.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'yearMonth')
    ..aOS(2, _omitFieldNames ? '' : 'totalCreditsUsed')
    ..pPM<OperationUsageBreakdown>(3, _omitFieldNames ? '' : 'breakdown',
        subBuilder: OperationUsageBreakdown.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetMonthlyUsageResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetMonthlyUsageResponse copyWith(
          void Function(GetMonthlyUsageResponse) updates) =>
      super.copyWith((message) => updates(message as GetMonthlyUsageResponse))
          as GetMonthlyUsageResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use GetMonthlyUsageResponse() / GetMonthlyUsageResponse.new instead')
  static GetMonthlyUsageResponse create() => GetMonthlyUsageResponse._();
  static $pb.GeneratedMessage $_createMessage() => GetMonthlyUsageResponse._();
  @$core.override
  GetMonthlyUsageResponse createEmptyInstance() => GetMonthlyUsageResponse._();
  @$core.pragma('dart2js:noInline')
  static GetMonthlyUsageResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetMonthlyUsageResponse>(
          GetMonthlyUsageResponse.$_createMessage);
  static GetMonthlyUsageResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get yearMonth => $_getSZ(0);
  @$pb.TagNumber(1)
  set yearMonth($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasYearMonth() => $_has(0);
  @$pb.TagNumber(1)
  void clearYearMonth() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get totalCreditsUsed => $_getSZ(1);
  @$pb.TagNumber(2)
  set totalCreditsUsed($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTotalCreditsUsed() => $_has(1);
  @$pb.TagNumber(2)
  void clearTotalCreditsUsed() => $_clearField(2);

  @$pb.TagNumber(3)
  $pb.PbList<OperationUsageBreakdown> get breakdown => $_getList(2);
}

class ListTransactionsRequest extends $pb.GeneratedMessage {
  factory ListTransactionsRequest({
    $1.UUID? workspaceId,
    $1.Pagination? pagination,
  }) {
    final result = ListTransactionsRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (pagination != null) result.pagination = pagination;
    return result;
  }

  ListTransactionsRequest._();

  factory ListTransactionsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListTransactionsRequest()..mergeFromBuffer(data, registry);
  factory ListTransactionsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListTransactionsRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListTransactionsRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.admin.v1'),
      createEmptyInstance: ListTransactionsRequest.$_createMessage)
    ..aOM<$1.UUID>(1, _omitFieldNames ? '' : 'workspaceId',
        subBuilder: $1.UUID.$_createMessage)
    ..aOM<$1.Pagination>(2, _omitFieldNames ? '' : 'pagination',
        subBuilder: $1.Pagination.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListTransactionsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListTransactionsRequest copyWith(
          void Function(ListTransactionsRequest) updates) =>
      super.copyWith((message) => updates(message as ListTransactionsRequest))
          as ListTransactionsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ListTransactionsRequest() / ListTransactionsRequest.new instead')
  static ListTransactionsRequest create() => ListTransactionsRequest._();
  static $pb.GeneratedMessage $_createMessage() => ListTransactionsRequest._();
  @$core.override
  ListTransactionsRequest createEmptyInstance() => ListTransactionsRequest._();
  @$core.pragma('dart2js:noInline')
  static ListTransactionsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListTransactionsRequest>(
          ListTransactionsRequest.$_createMessage);
  static ListTransactionsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $1.UUID get workspaceId => $_getN(0);
  @$pb.TagNumber(1)
  set workspaceId($1.UUID value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);
  @$pb.TagNumber(1)
  $1.UUID ensureWorkspaceId() => $_ensure(0);

  @$pb.TagNumber(2)
  $1.Pagination get pagination => $_getN(1);
  @$pb.TagNumber(2)
  set pagination($1.Pagination value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasPagination() => $_has(1);
  @$pb.TagNumber(2)
  void clearPagination() => $_clearField(2);
  @$pb.TagNumber(2)
  $1.Pagination ensurePagination() => $_ensure(1);
}

class ListTransactionsResponse extends $pb.GeneratedMessage {
  factory ListTransactionsResponse({
    $core.Iterable<CreditTransactionEntry>? transactions,
    $1.PaginatedResponse? pageInfo,
  }) {
    final result = ListTransactionsResponse._();
    if (transactions != null) result.transactions.addAll(transactions);
    if (pageInfo != null) result.pageInfo = pageInfo;
    return result;
  }

  ListTransactionsResponse._();

  factory ListTransactionsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListTransactionsResponse()..mergeFromBuffer(data, registry);
  factory ListTransactionsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListTransactionsResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListTransactionsResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.admin.v1'),
      createEmptyInstance: ListTransactionsResponse.$_createMessage)
    ..pPM<CreditTransactionEntry>(1, _omitFieldNames ? '' : 'transactions',
        subBuilder: CreditTransactionEntry.$_createMessage)
    ..aOM<$1.PaginatedResponse>(2, _omitFieldNames ? '' : 'pageInfo',
        subBuilder: $1.PaginatedResponse.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListTransactionsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListTransactionsResponse copyWith(
          void Function(ListTransactionsResponse) updates) =>
      super.copyWith((message) => updates(message as ListTransactionsResponse))
          as ListTransactionsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ListTransactionsResponse() / ListTransactionsResponse.new instead')
  static ListTransactionsResponse create() => ListTransactionsResponse._();
  static $pb.GeneratedMessage $_createMessage() => ListTransactionsResponse._();
  @$core.override
  ListTransactionsResponse createEmptyInstance() =>
      ListTransactionsResponse._();
  @$core.pragma('dart2js:noInline')
  static ListTransactionsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListTransactionsResponse>(
          ListTransactionsResponse.$_createMessage);
  static ListTransactionsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<CreditTransactionEntry> get transactions => $_getList(0);

  @$pb.TagNumber(2)
  $1.PaginatedResponse get pageInfo => $_getN(1);
  @$pb.TagNumber(2)
  set pageInfo($1.PaginatedResponse value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasPageInfo() => $_has(1);
  @$pb.TagNumber(2)
  void clearPageInfo() => $_clearField(2);
  @$pb.TagNumber(2)
  $1.PaginatedResponse ensurePageInfo() => $_ensure(1);
}

class ListRecentUsageRequest extends $pb.GeneratedMessage {
  factory ListRecentUsageRequest({
    $1.UUID? workspaceId,
    $core.int? limit,
  }) {
    final result = ListRecentUsageRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (limit != null) result.limit = limit;
    return result;
  }

  ListRecentUsageRequest._();

  factory ListRecentUsageRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListRecentUsageRequest()..mergeFromBuffer(data, registry);
  factory ListRecentUsageRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListRecentUsageRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListRecentUsageRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.admin.v1'),
      createEmptyInstance: ListRecentUsageRequest.$_createMessage)
    ..aOM<$1.UUID>(1, _omitFieldNames ? '' : 'workspaceId',
        subBuilder: $1.UUID.$_createMessage)
    ..aI(2, _omitFieldNames ? '' : 'limit')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListRecentUsageRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListRecentUsageRequest copyWith(
          void Function(ListRecentUsageRequest) updates) =>
      super.copyWith((message) => updates(message as ListRecentUsageRequest))
          as ListRecentUsageRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ListRecentUsageRequest() / ListRecentUsageRequest.new instead')
  static ListRecentUsageRequest create() => ListRecentUsageRequest._();
  static $pb.GeneratedMessage $_createMessage() => ListRecentUsageRequest._();
  @$core.override
  ListRecentUsageRequest createEmptyInstance() => ListRecentUsageRequest._();
  @$core.pragma('dart2js:noInline')
  static ListRecentUsageRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListRecentUsageRequest>(
          ListRecentUsageRequest.$_createMessage);
  static ListRecentUsageRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $1.UUID get workspaceId => $_getN(0);
  @$pb.TagNumber(1)
  set workspaceId($1.UUID value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);
  @$pb.TagNumber(1)
  $1.UUID ensureWorkspaceId() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.int get limit => $_getIZ(1);
  @$pb.TagNumber(2)
  set limit($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasLimit() => $_has(1);
  @$pb.TagNumber(2)
  void clearLimit() => $_clearField(2);
}

class ListRecentUsageResponse extends $pb.GeneratedMessage {
  factory ListRecentUsageResponse({
    $core.Iterable<CreditTransactionEntry>? usageEntries,
  }) {
    final result = ListRecentUsageResponse._();
    if (usageEntries != null) result.usageEntries.addAll(usageEntries);
    return result;
  }

  ListRecentUsageResponse._();

  factory ListRecentUsageResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListRecentUsageResponse()..mergeFromBuffer(data, registry);
  factory ListRecentUsageResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListRecentUsageResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListRecentUsageResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.admin.v1'),
      createEmptyInstance: ListRecentUsageResponse.$_createMessage)
    ..pPM<CreditTransactionEntry>(1, _omitFieldNames ? '' : 'usageEntries',
        subBuilder: CreditTransactionEntry.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListRecentUsageResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListRecentUsageResponse copyWith(
          void Function(ListRecentUsageResponse) updates) =>
      super.copyWith((message) => updates(message as ListRecentUsageResponse))
          as ListRecentUsageResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ListRecentUsageResponse() / ListRecentUsageResponse.new instead')
  static ListRecentUsageResponse create() => ListRecentUsageResponse._();
  static $pb.GeneratedMessage $_createMessage() => ListRecentUsageResponse._();
  @$core.override
  ListRecentUsageResponse createEmptyInstance() => ListRecentUsageResponse._();
  @$core.pragma('dart2js:noInline')
  static ListRecentUsageResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListRecentUsageResponse>(
          ListRecentUsageResponse.$_createMessage);
  static ListRecentUsageResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<CreditTransactionEntry> get usageEntries => $_getList(0);
}

class ListPackagesRequest extends $pb.GeneratedMessage {
  factory ListPackagesRequest({
    $core.String? currency,
  }) {
    final result = ListPackagesRequest._();
    if (currency != null) result.currency = currency;
    return result;
  }

  ListPackagesRequest._();

  factory ListPackagesRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListPackagesRequest()..mergeFromBuffer(data, registry);
  factory ListPackagesRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListPackagesRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListPackagesRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.admin.v1'),
      createEmptyInstance: ListPackagesRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'currency')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListPackagesRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListPackagesRequest copyWith(void Function(ListPackagesRequest) updates) =>
      super.copyWith((message) => updates(message as ListPackagesRequest))
          as ListPackagesRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core
      .Deprecated('Use ListPackagesRequest() / ListPackagesRequest.new instead')
  static ListPackagesRequest create() => ListPackagesRequest._();
  static $pb.GeneratedMessage $_createMessage() => ListPackagesRequest._();
  @$core.override
  ListPackagesRequest createEmptyInstance() => ListPackagesRequest._();
  @$core.pragma('dart2js:noInline')
  static ListPackagesRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListPackagesRequest>(
          ListPackagesRequest.$_createMessage);
  static ListPackagesRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get currency => $_getSZ(0);
  @$pb.TagNumber(1)
  set currency($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCurrency() => $_has(0);
  @$pb.TagNumber(1)
  void clearCurrency() => $_clearField(1);
}

class ListPackagesResponse extends $pb.GeneratedMessage {
  factory ListPackagesResponse({
    $core.Iterable<CreditPackEntry>? packages,
    $core.String? pricebookVersion,
  }) {
    final result = ListPackagesResponse._();
    if (packages != null) result.packages.addAll(packages);
    if (pricebookVersion != null) result.pricebookVersion = pricebookVersion;
    return result;
  }

  ListPackagesResponse._();

  factory ListPackagesResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListPackagesResponse()..mergeFromBuffer(data, registry);
  factory ListPackagesResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListPackagesResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListPackagesResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.admin.v1'),
      createEmptyInstance: ListPackagesResponse.$_createMessage)
    ..pPM<CreditPackEntry>(1, _omitFieldNames ? '' : 'packages',
        subBuilder: CreditPackEntry.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'pricebookVersion')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListPackagesResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListPackagesResponse copyWith(void Function(ListPackagesResponse) updates) =>
      super.copyWith((message) => updates(message as ListPackagesResponse))
          as ListPackagesResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ListPackagesResponse() / ListPackagesResponse.new instead')
  static ListPackagesResponse create() => ListPackagesResponse._();
  static $pb.GeneratedMessage $_createMessage() => ListPackagesResponse._();
  @$core.override
  ListPackagesResponse createEmptyInstance() => ListPackagesResponse._();
  @$core.pragma('dart2js:noInline')
  static ListPackagesResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListPackagesResponse>(
          ListPackagesResponse.$_createMessage);
  static ListPackagesResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<CreditPackEntry> get packages => $_getList(0);

  @$pb.TagNumber(2)
  $core.String get pricebookVersion => $_getSZ(1);
  @$pb.TagNumber(2)
  set pricebookVersion($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPricebookVersion() => $_has(1);
  @$pb.TagNumber(2)
  void clearPricebookVersion() => $_clearField(2);
}

class PurchaseRequest extends $pb.GeneratedMessage {
  factory PurchaseRequest({
    $1.CommandContext? context,
    $core.String? packCode,
    $core.String? currency,
    $core.String? successUrl,
    $core.String? cancelUrl,
  }) {
    final result = PurchaseRequest._();
    if (context != null) result.context = context;
    if (packCode != null) result.packCode = packCode;
    if (currency != null) result.currency = currency;
    if (successUrl != null) result.successUrl = successUrl;
    if (cancelUrl != null) result.cancelUrl = cancelUrl;
    return result;
  }

  PurchaseRequest._();

  factory PurchaseRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PurchaseRequest()..mergeFromBuffer(data, registry);
  factory PurchaseRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PurchaseRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PurchaseRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.admin.v1'),
      createEmptyInstance: PurchaseRequest.$_createMessage)
    ..aOM<$1.CommandContext>(1, _omitFieldNames ? '' : 'context',
        subBuilder: $1.CommandContext.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'packCode')
    ..aOS(3, _omitFieldNames ? '' : 'currency')
    ..aOS(4, _omitFieldNames ? '' : 'successUrl')
    ..aOS(5, _omitFieldNames ? '' : 'cancelUrl')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PurchaseRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PurchaseRequest copyWith(void Function(PurchaseRequest) updates) =>
      super.copyWith((message) => updates(message as PurchaseRequest))
          as PurchaseRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use PurchaseRequest() / PurchaseRequest.new instead')
  static PurchaseRequest create() => PurchaseRequest._();
  static $pb.GeneratedMessage $_createMessage() => PurchaseRequest._();
  @$core.override
  PurchaseRequest createEmptyInstance() => PurchaseRequest._();
  @$core.pragma('dart2js:noInline')
  static PurchaseRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PurchaseRequest>(
          PurchaseRequest.$_createMessage);
  static PurchaseRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $1.CommandContext get context => $_getN(0);
  @$pb.TagNumber(1)
  set context($1.CommandContext value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasContext() => $_has(0);
  @$pb.TagNumber(1)
  void clearContext() => $_clearField(1);
  @$pb.TagNumber(1)
  $1.CommandContext ensureContext() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get packCode => $_getSZ(1);
  @$pb.TagNumber(2)
  set packCode($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPackCode() => $_has(1);
  @$pb.TagNumber(2)
  void clearPackCode() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get currency => $_getSZ(2);
  @$pb.TagNumber(3)
  set currency($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasCurrency() => $_has(2);
  @$pb.TagNumber(3)
  void clearCurrency() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get successUrl => $_getSZ(3);
  @$pb.TagNumber(4)
  set successUrl($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasSuccessUrl() => $_has(3);
  @$pb.TagNumber(4)
  void clearSuccessUrl() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get cancelUrl => $_getSZ(4);
  @$pb.TagNumber(5)
  set cancelUrl($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasCancelUrl() => $_has(4);
  @$pb.TagNumber(5)
  void clearCancelUrl() => $_clearField(5);
}

class PurchaseResponse extends $pb.GeneratedMessage {
  factory PurchaseResponse({
    $core.String? checkoutSessionId,
    $core.String? checkoutUrl,
    $core.String? status,
    CreditPackEntry? pack,
  }) {
    final result = PurchaseResponse._();
    if (checkoutSessionId != null) result.checkoutSessionId = checkoutSessionId;
    if (checkoutUrl != null) result.checkoutUrl = checkoutUrl;
    if (status != null) result.status = status;
    if (pack != null) result.pack = pack;
    return result;
  }

  PurchaseResponse._();

  factory PurchaseResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PurchaseResponse()..mergeFromBuffer(data, registry);
  factory PurchaseResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PurchaseResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PurchaseResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.admin.v1'),
      createEmptyInstance: PurchaseResponse.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'checkoutSessionId')
    ..aOS(2, _omitFieldNames ? '' : 'checkoutUrl')
    ..aOS(3, _omitFieldNames ? '' : 'status')
    ..aOM<CreditPackEntry>(4, _omitFieldNames ? '' : 'pack',
        subBuilder: CreditPackEntry.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PurchaseResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PurchaseResponse copyWith(void Function(PurchaseResponse) updates) =>
      super.copyWith((message) => updates(message as PurchaseResponse))
          as PurchaseResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use PurchaseResponse() / PurchaseResponse.new instead')
  static PurchaseResponse create() => PurchaseResponse._();
  static $pb.GeneratedMessage $_createMessage() => PurchaseResponse._();
  @$core.override
  PurchaseResponse createEmptyInstance() => PurchaseResponse._();
  @$core.pragma('dart2js:noInline')
  static PurchaseResponse getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PurchaseResponse>(
          PurchaseResponse.$_createMessage);
  static PurchaseResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get checkoutSessionId => $_getSZ(0);
  @$pb.TagNumber(1)
  set checkoutSessionId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCheckoutSessionId() => $_has(0);
  @$pb.TagNumber(1)
  void clearCheckoutSessionId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get checkoutUrl => $_getSZ(1);
  @$pb.TagNumber(2)
  set checkoutUrl($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCheckoutUrl() => $_has(1);
  @$pb.TagNumber(2)
  void clearCheckoutUrl() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get status => $_getSZ(2);
  @$pb.TagNumber(3)
  set status($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasStatus() => $_has(2);
  @$pb.TagNumber(3)
  void clearStatus() => $_clearField(3);

  @$pb.TagNumber(4)
  CreditPackEntry get pack => $_getN(3);
  @$pb.TagNumber(4)
  set pack(CreditPackEntry value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasPack() => $_has(3);
  @$pb.TagNumber(4)
  void clearPack() => $_clearField(4);
  @$pb.TagNumber(4)
  CreditPackEntry ensurePack() => $_ensure(3);
}

class GetAutoRefillConfigRequest extends $pb.GeneratedMessage {
  factory GetAutoRefillConfigRequest({
    $1.UUID? workspaceId,
  }) {
    final result = GetAutoRefillConfigRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    return result;
  }

  GetAutoRefillConfigRequest._();

  factory GetAutoRefillConfigRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetAutoRefillConfigRequest()..mergeFromBuffer(data, registry);
  factory GetAutoRefillConfigRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetAutoRefillConfigRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetAutoRefillConfigRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.admin.v1'),
      createEmptyInstance: GetAutoRefillConfigRequest.$_createMessage)
    ..aOM<$1.UUID>(1, _omitFieldNames ? '' : 'workspaceId',
        subBuilder: $1.UUID.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetAutoRefillConfigRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetAutoRefillConfigRequest copyWith(
          void Function(GetAutoRefillConfigRequest) updates) =>
      super.copyWith(
              (message) => updates(message as GetAutoRefillConfigRequest))
          as GetAutoRefillConfigRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use GetAutoRefillConfigRequest() / GetAutoRefillConfigRequest.new instead')
  static GetAutoRefillConfigRequest create() => GetAutoRefillConfigRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      GetAutoRefillConfigRequest._();
  @$core.override
  GetAutoRefillConfigRequest createEmptyInstance() =>
      GetAutoRefillConfigRequest._();
  @$core.pragma('dart2js:noInline')
  static GetAutoRefillConfigRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetAutoRefillConfigRequest>(
          GetAutoRefillConfigRequest.$_createMessage);
  static GetAutoRefillConfigRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $1.UUID get workspaceId => $_getN(0);
  @$pb.TagNumber(1)
  set workspaceId($1.UUID value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);
  @$pb.TagNumber(1)
  $1.UUID ensureWorkspaceId() => $_ensure(0);
}

class GetAutoRefillConfigResponse extends $pb.GeneratedMessage {
  factory GetAutoRefillConfigResponse({
    AutoRefillConfig? config,
  }) {
    final result = GetAutoRefillConfigResponse._();
    if (config != null) result.config = config;
    return result;
  }

  GetAutoRefillConfigResponse._();

  factory GetAutoRefillConfigResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetAutoRefillConfigResponse()..mergeFromBuffer(data, registry);
  factory GetAutoRefillConfigResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetAutoRefillConfigResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetAutoRefillConfigResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.admin.v1'),
      createEmptyInstance: GetAutoRefillConfigResponse.$_createMessage)
    ..aOM<AutoRefillConfig>(1, _omitFieldNames ? '' : 'config',
        subBuilder: AutoRefillConfig.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetAutoRefillConfigResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetAutoRefillConfigResponse copyWith(
          void Function(GetAutoRefillConfigResponse) updates) =>
      super.copyWith(
              (message) => updates(message as GetAutoRefillConfigResponse))
          as GetAutoRefillConfigResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use GetAutoRefillConfigResponse() / GetAutoRefillConfigResponse.new instead')
  static GetAutoRefillConfigResponse create() =>
      GetAutoRefillConfigResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      GetAutoRefillConfigResponse._();
  @$core.override
  GetAutoRefillConfigResponse createEmptyInstance() =>
      GetAutoRefillConfigResponse._();
  @$core.pragma('dart2js:noInline')
  static GetAutoRefillConfigResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetAutoRefillConfigResponse>(
          GetAutoRefillConfigResponse.$_createMessage);
  static GetAutoRefillConfigResponse? _defaultInstance;

  @$pb.TagNumber(1)
  AutoRefillConfig get config => $_getN(0);
  @$pb.TagNumber(1)
  set config(AutoRefillConfig value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasConfig() => $_has(0);
  @$pb.TagNumber(1)
  void clearConfig() => $_clearField(1);
  @$pb.TagNumber(1)
  AutoRefillConfig ensureConfig() => $_ensure(0);
}

class UpdateAutoRefillRequest extends $pb.GeneratedMessage {
  factory UpdateAutoRefillRequest({
    $1.CommandContext? context,
    AutoRefillConfig? config,
  }) {
    final result = UpdateAutoRefillRequest._();
    if (context != null) result.context = context;
    if (config != null) result.config = config;
    return result;
  }

  UpdateAutoRefillRequest._();

  factory UpdateAutoRefillRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      UpdateAutoRefillRequest()..mergeFromBuffer(data, registry);
  factory UpdateAutoRefillRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      UpdateAutoRefillRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UpdateAutoRefillRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.admin.v1'),
      createEmptyInstance: UpdateAutoRefillRequest.$_createMessage)
    ..aOM<$1.CommandContext>(1, _omitFieldNames ? '' : 'context',
        subBuilder: $1.CommandContext.$_createMessage)
    ..aOM<AutoRefillConfig>(2, _omitFieldNames ? '' : 'config',
        subBuilder: AutoRefillConfig.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateAutoRefillRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateAutoRefillRequest copyWith(
          void Function(UpdateAutoRefillRequest) updates) =>
      super.copyWith((message) => updates(message as UpdateAutoRefillRequest))
          as UpdateAutoRefillRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use UpdateAutoRefillRequest() / UpdateAutoRefillRequest.new instead')
  static UpdateAutoRefillRequest create() => UpdateAutoRefillRequest._();
  static $pb.GeneratedMessage $_createMessage() => UpdateAutoRefillRequest._();
  @$core.override
  UpdateAutoRefillRequest createEmptyInstance() => UpdateAutoRefillRequest._();
  @$core.pragma('dart2js:noInline')
  static UpdateAutoRefillRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UpdateAutoRefillRequest>(
          UpdateAutoRefillRequest.$_createMessage);
  static UpdateAutoRefillRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $1.CommandContext get context => $_getN(0);
  @$pb.TagNumber(1)
  set context($1.CommandContext value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasContext() => $_has(0);
  @$pb.TagNumber(1)
  void clearContext() => $_clearField(1);
  @$pb.TagNumber(1)
  $1.CommandContext ensureContext() => $_ensure(0);

  @$pb.TagNumber(2)
  AutoRefillConfig get config => $_getN(1);
  @$pb.TagNumber(2)
  set config(AutoRefillConfig value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasConfig() => $_has(1);
  @$pb.TagNumber(2)
  void clearConfig() => $_clearField(2);
  @$pb.TagNumber(2)
  AutoRefillConfig ensureConfig() => $_ensure(1);
}

class UpdateAutoRefillResponse extends $pb.GeneratedMessage {
  factory UpdateAutoRefillResponse({
    AutoRefillConfig? config,
  }) {
    final result = UpdateAutoRefillResponse._();
    if (config != null) result.config = config;
    return result;
  }

  UpdateAutoRefillResponse._();

  factory UpdateAutoRefillResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      UpdateAutoRefillResponse()..mergeFromBuffer(data, registry);
  factory UpdateAutoRefillResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      UpdateAutoRefillResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UpdateAutoRefillResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.admin.v1'),
      createEmptyInstance: UpdateAutoRefillResponse.$_createMessage)
    ..aOM<AutoRefillConfig>(1, _omitFieldNames ? '' : 'config',
        subBuilder: AutoRefillConfig.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateAutoRefillResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateAutoRefillResponse copyWith(
          void Function(UpdateAutoRefillResponse) updates) =>
      super.copyWith((message) => updates(message as UpdateAutoRefillResponse))
          as UpdateAutoRefillResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use UpdateAutoRefillResponse() / UpdateAutoRefillResponse.new instead')
  static UpdateAutoRefillResponse create() => UpdateAutoRefillResponse._();
  static $pb.GeneratedMessage $_createMessage() => UpdateAutoRefillResponse._();
  @$core.override
  UpdateAutoRefillResponse createEmptyInstance() =>
      UpdateAutoRefillResponse._();
  @$core.pragma('dart2js:noInline')
  static UpdateAutoRefillResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UpdateAutoRefillResponse>(
          UpdateAutoRefillResponse.$_createMessage);
  static UpdateAutoRefillResponse? _defaultInstance;

  @$pb.TagNumber(1)
  AutoRefillConfig get config => $_getN(0);
  @$pb.TagNumber(1)
  set config(AutoRefillConfig value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasConfig() => $_has(0);
  @$pb.TagNumber(1)
  void clearConfig() => $_clearField(1);
  @$pb.TagNumber(1)
  AutoRefillConfig ensureConfig() => $_ensure(0);
}

class GetCurrentPlanRequest extends $pb.GeneratedMessage {
  factory GetCurrentPlanRequest({
    $1.UUID? workspaceId,
  }) {
    final result = GetCurrentPlanRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    return result;
  }

  GetCurrentPlanRequest._();

  factory GetCurrentPlanRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetCurrentPlanRequest()..mergeFromBuffer(data, registry);
  factory GetCurrentPlanRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetCurrentPlanRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetCurrentPlanRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.admin.v1'),
      createEmptyInstance: GetCurrentPlanRequest.$_createMessage)
    ..aOM<$1.UUID>(1, _omitFieldNames ? '' : 'workspaceId',
        subBuilder: $1.UUID.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetCurrentPlanRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetCurrentPlanRequest copyWith(
          void Function(GetCurrentPlanRequest) updates) =>
      super.copyWith((message) => updates(message as GetCurrentPlanRequest))
          as GetCurrentPlanRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use GetCurrentPlanRequest() / GetCurrentPlanRequest.new instead')
  static GetCurrentPlanRequest create() => GetCurrentPlanRequest._();
  static $pb.GeneratedMessage $_createMessage() => GetCurrentPlanRequest._();
  @$core.override
  GetCurrentPlanRequest createEmptyInstance() => GetCurrentPlanRequest._();
  @$core.pragma('dart2js:noInline')
  static GetCurrentPlanRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetCurrentPlanRequest>(
          GetCurrentPlanRequest.$_createMessage);
  static GetCurrentPlanRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $1.UUID get workspaceId => $_getN(0);
  @$pb.TagNumber(1)
  set workspaceId($1.UUID value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);
  @$pb.TagNumber(1)
  $1.UUID ensureWorkspaceId() => $_ensure(0);
}

class GetCurrentPlanResponse extends $pb.GeneratedMessage {
  factory GetCurrentPlanResponse({
    PlanCatalogEntry? currentPlan,
    SubscriptionSummary? subscription,
  }) {
    final result = GetCurrentPlanResponse._();
    if (currentPlan != null) result.currentPlan = currentPlan;
    if (subscription != null) result.subscription = subscription;
    return result;
  }

  GetCurrentPlanResponse._();

  factory GetCurrentPlanResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetCurrentPlanResponse()..mergeFromBuffer(data, registry);
  factory GetCurrentPlanResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetCurrentPlanResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetCurrentPlanResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.admin.v1'),
      createEmptyInstance: GetCurrentPlanResponse.$_createMessage)
    ..aOM<PlanCatalogEntry>(1, _omitFieldNames ? '' : 'currentPlan',
        subBuilder: PlanCatalogEntry.$_createMessage)
    ..aOM<SubscriptionSummary>(2, _omitFieldNames ? '' : 'subscription',
        subBuilder: SubscriptionSummary.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetCurrentPlanResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetCurrentPlanResponse copyWith(
          void Function(GetCurrentPlanResponse) updates) =>
      super.copyWith((message) => updates(message as GetCurrentPlanResponse))
          as GetCurrentPlanResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use GetCurrentPlanResponse() / GetCurrentPlanResponse.new instead')
  static GetCurrentPlanResponse create() => GetCurrentPlanResponse._();
  static $pb.GeneratedMessage $_createMessage() => GetCurrentPlanResponse._();
  @$core.override
  GetCurrentPlanResponse createEmptyInstance() => GetCurrentPlanResponse._();
  @$core.pragma('dart2js:noInline')
  static GetCurrentPlanResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetCurrentPlanResponse>(
          GetCurrentPlanResponse.$_createMessage);
  static GetCurrentPlanResponse? _defaultInstance;

  @$pb.TagNumber(1)
  PlanCatalogEntry get currentPlan => $_getN(0);
  @$pb.TagNumber(1)
  set currentPlan(PlanCatalogEntry value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasCurrentPlan() => $_has(0);
  @$pb.TagNumber(1)
  void clearCurrentPlan() => $_clearField(1);
  @$pb.TagNumber(1)
  PlanCatalogEntry ensureCurrentPlan() => $_ensure(0);

  @$pb.TagNumber(2)
  SubscriptionSummary get subscription => $_getN(1);
  @$pb.TagNumber(2)
  set subscription(SubscriptionSummary value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasSubscription() => $_has(1);
  @$pb.TagNumber(2)
  void clearSubscription() => $_clearField(2);
  @$pb.TagNumber(2)
  SubscriptionSummary ensureSubscription() => $_ensure(1);
}

class ListPlansRequest extends $pb.GeneratedMessage {
  factory ListPlansRequest({
    $core.String? currency,
  }) {
    final result = ListPlansRequest._();
    if (currency != null) result.currency = currency;
    return result;
  }

  ListPlansRequest._();

  factory ListPlansRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListPlansRequest()..mergeFromBuffer(data, registry);
  factory ListPlansRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListPlansRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListPlansRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.admin.v1'),
      createEmptyInstance: ListPlansRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'currency')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListPlansRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListPlansRequest copyWith(void Function(ListPlansRequest) updates) =>
      super.copyWith((message) => updates(message as ListPlansRequest))
          as ListPlansRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ListPlansRequest() / ListPlansRequest.new instead')
  static ListPlansRequest create() => ListPlansRequest._();
  static $pb.GeneratedMessage $_createMessage() => ListPlansRequest._();
  @$core.override
  ListPlansRequest createEmptyInstance() => ListPlansRequest._();
  @$core.pragma('dart2js:noInline')
  static ListPlansRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ListPlansRequest>(
          ListPlansRequest.$_createMessage);
  static ListPlansRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get currency => $_getSZ(0);
  @$pb.TagNumber(1)
  set currency($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCurrency() => $_has(0);
  @$pb.TagNumber(1)
  void clearCurrency() => $_clearField(1);
}

class ListPlansResponse extends $pb.GeneratedMessage {
  factory ListPlansResponse({
    $core.Iterable<PlanCatalogEntry>? plans,
    $core.Iterable<AddonCatalogEntry>? addons,
    $core.String? pricebookVersion,
  }) {
    final result = ListPlansResponse._();
    if (plans != null) result.plans.addAll(plans);
    if (addons != null) result.addons.addAll(addons);
    if (pricebookVersion != null) result.pricebookVersion = pricebookVersion;
    return result;
  }

  ListPlansResponse._();

  factory ListPlansResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListPlansResponse()..mergeFromBuffer(data, registry);
  factory ListPlansResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListPlansResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListPlansResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.admin.v1'),
      createEmptyInstance: ListPlansResponse.$_createMessage)
    ..pPM<PlanCatalogEntry>(1, _omitFieldNames ? '' : 'plans',
        subBuilder: PlanCatalogEntry.$_createMessage)
    ..pPM<AddonCatalogEntry>(2, _omitFieldNames ? '' : 'addons',
        subBuilder: AddonCatalogEntry.$_createMessage)
    ..aOS(3, _omitFieldNames ? '' : 'pricebookVersion')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListPlansResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListPlansResponse copyWith(void Function(ListPlansResponse) updates) =>
      super.copyWith((message) => updates(message as ListPlansResponse))
          as ListPlansResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ListPlansResponse() / ListPlansResponse.new instead')
  static ListPlansResponse create() => ListPlansResponse._();
  static $pb.GeneratedMessage $_createMessage() => ListPlansResponse._();
  @$core.override
  ListPlansResponse createEmptyInstance() => ListPlansResponse._();
  @$core.pragma('dart2js:noInline')
  static ListPlansResponse getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ListPlansResponse>(
          ListPlansResponse.$_createMessage);
  static ListPlansResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<PlanCatalogEntry> get plans => $_getList(0);

  @$pb.TagNumber(2)
  $pb.PbList<AddonCatalogEntry> get addons => $_getList(1);

  @$pb.TagNumber(3)
  $core.String get pricebookVersion => $_getSZ(2);
  @$pb.TagNumber(3)
  set pricebookVersion($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPricebookVersion() => $_has(2);
  @$pb.TagNumber(3)
  void clearPricebookVersion() => $_clearField(3);
}

class GetSubscriptionRequest extends $pb.GeneratedMessage {
  factory GetSubscriptionRequest({
    $1.UUID? workspaceId,
  }) {
    final result = GetSubscriptionRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    return result;
  }

  GetSubscriptionRequest._();

  factory GetSubscriptionRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetSubscriptionRequest()..mergeFromBuffer(data, registry);
  factory GetSubscriptionRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetSubscriptionRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetSubscriptionRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.admin.v1'),
      createEmptyInstance: GetSubscriptionRequest.$_createMessage)
    ..aOM<$1.UUID>(1, _omitFieldNames ? '' : 'workspaceId',
        subBuilder: $1.UUID.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetSubscriptionRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetSubscriptionRequest copyWith(
          void Function(GetSubscriptionRequest) updates) =>
      super.copyWith((message) => updates(message as GetSubscriptionRequest))
          as GetSubscriptionRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use GetSubscriptionRequest() / GetSubscriptionRequest.new instead')
  static GetSubscriptionRequest create() => GetSubscriptionRequest._();
  static $pb.GeneratedMessage $_createMessage() => GetSubscriptionRequest._();
  @$core.override
  GetSubscriptionRequest createEmptyInstance() => GetSubscriptionRequest._();
  @$core.pragma('dart2js:noInline')
  static GetSubscriptionRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetSubscriptionRequest>(
          GetSubscriptionRequest.$_createMessage);
  static GetSubscriptionRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $1.UUID get workspaceId => $_getN(0);
  @$pb.TagNumber(1)
  set workspaceId($1.UUID value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);
  @$pb.TagNumber(1)
  $1.UUID ensureWorkspaceId() => $_ensure(0);
}

class GetSubscriptionResponse extends $pb.GeneratedMessage {
  factory GetSubscriptionResponse({
    SubscriptionSummary? subscription,
  }) {
    final result = GetSubscriptionResponse._();
    if (subscription != null) result.subscription = subscription;
    return result;
  }

  GetSubscriptionResponse._();

  factory GetSubscriptionResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetSubscriptionResponse()..mergeFromBuffer(data, registry);
  factory GetSubscriptionResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetSubscriptionResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetSubscriptionResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.admin.v1'),
      createEmptyInstance: GetSubscriptionResponse.$_createMessage)
    ..aOM<SubscriptionSummary>(1, _omitFieldNames ? '' : 'subscription',
        subBuilder: SubscriptionSummary.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetSubscriptionResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetSubscriptionResponse copyWith(
          void Function(GetSubscriptionResponse) updates) =>
      super.copyWith((message) => updates(message as GetSubscriptionResponse))
          as GetSubscriptionResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use GetSubscriptionResponse() / GetSubscriptionResponse.new instead')
  static GetSubscriptionResponse create() => GetSubscriptionResponse._();
  static $pb.GeneratedMessage $_createMessage() => GetSubscriptionResponse._();
  @$core.override
  GetSubscriptionResponse createEmptyInstance() => GetSubscriptionResponse._();
  @$core.pragma('dart2js:noInline')
  static GetSubscriptionResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetSubscriptionResponse>(
          GetSubscriptionResponse.$_createMessage);
  static GetSubscriptionResponse? _defaultInstance;

  @$pb.TagNumber(1)
  SubscriptionSummary get subscription => $_getN(0);
  @$pb.TagNumber(1)
  set subscription(SubscriptionSummary value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasSubscription() => $_has(0);
  @$pb.TagNumber(1)
  void clearSubscription() => $_clearField(1);
  @$pb.TagNumber(1)
  SubscriptionSummary ensureSubscription() => $_ensure(0);
}

class GetPaymentMethodsRequest extends $pb.GeneratedMessage {
  factory GetPaymentMethodsRequest({
    $1.UUID? workspaceId,
  }) {
    final result = GetPaymentMethodsRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    return result;
  }

  GetPaymentMethodsRequest._();

  factory GetPaymentMethodsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetPaymentMethodsRequest()..mergeFromBuffer(data, registry);
  factory GetPaymentMethodsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetPaymentMethodsRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetPaymentMethodsRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.admin.v1'),
      createEmptyInstance: GetPaymentMethodsRequest.$_createMessage)
    ..aOM<$1.UUID>(1, _omitFieldNames ? '' : 'workspaceId',
        subBuilder: $1.UUID.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetPaymentMethodsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetPaymentMethodsRequest copyWith(
          void Function(GetPaymentMethodsRequest) updates) =>
      super.copyWith((message) => updates(message as GetPaymentMethodsRequest))
          as GetPaymentMethodsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use GetPaymentMethodsRequest() / GetPaymentMethodsRequest.new instead')
  static GetPaymentMethodsRequest create() => GetPaymentMethodsRequest._();
  static $pb.GeneratedMessage $_createMessage() => GetPaymentMethodsRequest._();
  @$core.override
  GetPaymentMethodsRequest createEmptyInstance() =>
      GetPaymentMethodsRequest._();
  @$core.pragma('dart2js:noInline')
  static GetPaymentMethodsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetPaymentMethodsRequest>(
          GetPaymentMethodsRequest.$_createMessage);
  static GetPaymentMethodsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $1.UUID get workspaceId => $_getN(0);
  @$pb.TagNumber(1)
  set workspaceId($1.UUID value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);
  @$pb.TagNumber(1)
  $1.UUID ensureWorkspaceId() => $_ensure(0);
}

class GetPaymentMethodsResponse extends $pb.GeneratedMessage {
  factory GetPaymentMethodsResponse({
    $core.Iterable<PaymentMethodSummary>? paymentMethods,
  }) {
    final result = GetPaymentMethodsResponse._();
    if (paymentMethods != null) result.paymentMethods.addAll(paymentMethods);
    return result;
  }

  GetPaymentMethodsResponse._();

  factory GetPaymentMethodsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetPaymentMethodsResponse()..mergeFromBuffer(data, registry);
  factory GetPaymentMethodsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetPaymentMethodsResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetPaymentMethodsResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.admin.v1'),
      createEmptyInstance: GetPaymentMethodsResponse.$_createMessage)
    ..pPM<PaymentMethodSummary>(1, _omitFieldNames ? '' : 'paymentMethods',
        subBuilder: PaymentMethodSummary.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetPaymentMethodsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetPaymentMethodsResponse copyWith(
          void Function(GetPaymentMethodsResponse) updates) =>
      super.copyWith((message) => updates(message as GetPaymentMethodsResponse))
          as GetPaymentMethodsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use GetPaymentMethodsResponse() / GetPaymentMethodsResponse.new instead')
  static GetPaymentMethodsResponse create() => GetPaymentMethodsResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      GetPaymentMethodsResponse._();
  @$core.override
  GetPaymentMethodsResponse createEmptyInstance() =>
      GetPaymentMethodsResponse._();
  @$core.pragma('dart2js:noInline')
  static GetPaymentMethodsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetPaymentMethodsResponse>(
          GetPaymentMethodsResponse.$_createMessage);
  static GetPaymentMethodsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<PaymentMethodSummary> get paymentMethods => $_getList(0);
}

class CancelPlanRequest extends $pb.GeneratedMessage {
  factory CancelPlanRequest({
    $1.CommandContext? context,
    $core.String? cancellationReason,
    $core.bool? pauseInstead,
    $core.int? pauseMonths,
  }) {
    final result = CancelPlanRequest._();
    if (context != null) result.context = context;
    if (cancellationReason != null)
      result.cancellationReason = cancellationReason;
    if (pauseInstead != null) result.pauseInstead = pauseInstead;
    if (pauseMonths != null) result.pauseMonths = pauseMonths;
    return result;
  }

  CancelPlanRequest._();

  factory CancelPlanRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CancelPlanRequest()..mergeFromBuffer(data, registry);
  factory CancelPlanRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CancelPlanRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CancelPlanRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.admin.v1'),
      createEmptyInstance: CancelPlanRequest.$_createMessage)
    ..aOM<$1.CommandContext>(1, _omitFieldNames ? '' : 'context',
        subBuilder: $1.CommandContext.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'cancellationReason')
    ..aOB(3, _omitFieldNames ? '' : 'pauseInstead')
    ..aI(4, _omitFieldNames ? '' : 'pauseMonths')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CancelPlanRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CancelPlanRequest copyWith(void Function(CancelPlanRequest) updates) =>
      super.copyWith((message) => updates(message as CancelPlanRequest))
          as CancelPlanRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use CancelPlanRequest() / CancelPlanRequest.new instead')
  static CancelPlanRequest create() => CancelPlanRequest._();
  static $pb.GeneratedMessage $_createMessage() => CancelPlanRequest._();
  @$core.override
  CancelPlanRequest createEmptyInstance() => CancelPlanRequest._();
  @$core.pragma('dart2js:noInline')
  static CancelPlanRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CancelPlanRequest>(
          CancelPlanRequest.$_createMessage);
  static CancelPlanRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $1.CommandContext get context => $_getN(0);
  @$pb.TagNumber(1)
  set context($1.CommandContext value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasContext() => $_has(0);
  @$pb.TagNumber(1)
  void clearContext() => $_clearField(1);
  @$pb.TagNumber(1)
  $1.CommandContext ensureContext() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get cancellationReason => $_getSZ(1);
  @$pb.TagNumber(2)
  set cancellationReason($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCancellationReason() => $_has(1);
  @$pb.TagNumber(2)
  void clearCancellationReason() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.bool get pauseInstead => $_getBF(2);
  @$pb.TagNumber(3)
  set pauseInstead($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPauseInstead() => $_has(2);
  @$pb.TagNumber(3)
  void clearPauseInstead() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get pauseMonths => $_getIZ(3);
  @$pb.TagNumber(4)
  set pauseMonths($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasPauseMonths() => $_has(3);
  @$pb.TagNumber(4)
  void clearPauseMonths() => $_clearField(4);
}

class CancelPlanResponse extends $pb.GeneratedMessage {
  factory CancelPlanResponse({
    SubscriptionSummary? subscription,
  }) {
    final result = CancelPlanResponse._();
    if (subscription != null) result.subscription = subscription;
    return result;
  }

  CancelPlanResponse._();

  factory CancelPlanResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CancelPlanResponse()..mergeFromBuffer(data, registry);
  factory CancelPlanResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CancelPlanResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CancelPlanResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.admin.v1'),
      createEmptyInstance: CancelPlanResponse.$_createMessage)
    ..aOM<SubscriptionSummary>(1, _omitFieldNames ? '' : 'subscription',
        subBuilder: SubscriptionSummary.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CancelPlanResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CancelPlanResponse copyWith(void Function(CancelPlanResponse) updates) =>
      super.copyWith((message) => updates(message as CancelPlanResponse))
          as CancelPlanResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use CancelPlanResponse() / CancelPlanResponse.new instead')
  static CancelPlanResponse create() => CancelPlanResponse._();
  static $pb.GeneratedMessage $_createMessage() => CancelPlanResponse._();
  @$core.override
  CancelPlanResponse createEmptyInstance() => CancelPlanResponse._();
  @$core.pragma('dart2js:noInline')
  static CancelPlanResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CancelPlanResponse>(
          CancelPlanResponse.$_createMessage);
  static CancelPlanResponse? _defaultInstance;

  @$pb.TagNumber(1)
  SubscriptionSummary get subscription => $_getN(0);
  @$pb.TagNumber(1)
  set subscription(SubscriptionSummary value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasSubscription() => $_has(0);
  @$pb.TagNumber(1)
  void clearSubscription() => $_clearField(1);
  @$pb.TagNumber(1)
  SubscriptionSummary ensureSubscription() => $_ensure(0);
}

class ListInvoicesRequest extends $pb.GeneratedMessage {
  factory ListInvoicesRequest({
    $1.UUID? workspaceId,
    $1.Pagination? pagination,
  }) {
    final result = ListInvoicesRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (pagination != null) result.pagination = pagination;
    return result;
  }

  ListInvoicesRequest._();

  factory ListInvoicesRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListInvoicesRequest()..mergeFromBuffer(data, registry);
  factory ListInvoicesRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListInvoicesRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListInvoicesRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.admin.v1'),
      createEmptyInstance: ListInvoicesRequest.$_createMessage)
    ..aOM<$1.UUID>(1, _omitFieldNames ? '' : 'workspaceId',
        subBuilder: $1.UUID.$_createMessage)
    ..aOM<$1.Pagination>(2, _omitFieldNames ? '' : 'pagination',
        subBuilder: $1.Pagination.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListInvoicesRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListInvoicesRequest copyWith(void Function(ListInvoicesRequest) updates) =>
      super.copyWith((message) => updates(message as ListInvoicesRequest))
          as ListInvoicesRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core
      .Deprecated('Use ListInvoicesRequest() / ListInvoicesRequest.new instead')
  static ListInvoicesRequest create() => ListInvoicesRequest._();
  static $pb.GeneratedMessage $_createMessage() => ListInvoicesRequest._();
  @$core.override
  ListInvoicesRequest createEmptyInstance() => ListInvoicesRequest._();
  @$core.pragma('dart2js:noInline')
  static ListInvoicesRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListInvoicesRequest>(
          ListInvoicesRequest.$_createMessage);
  static ListInvoicesRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $1.UUID get workspaceId => $_getN(0);
  @$pb.TagNumber(1)
  set workspaceId($1.UUID value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);
  @$pb.TagNumber(1)
  $1.UUID ensureWorkspaceId() => $_ensure(0);

  @$pb.TagNumber(2)
  $1.Pagination get pagination => $_getN(1);
  @$pb.TagNumber(2)
  set pagination($1.Pagination value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasPagination() => $_has(1);
  @$pb.TagNumber(2)
  void clearPagination() => $_clearField(2);
  @$pb.TagNumber(2)
  $1.Pagination ensurePagination() => $_ensure(1);
}

class ListInvoicesResponse extends $pb.GeneratedMessage {
  factory ListInvoicesResponse({
    $core.Iterable<InvoiceSummary>? invoices,
    $1.PaginatedResponse? pageInfo,
  }) {
    final result = ListInvoicesResponse._();
    if (invoices != null) result.invoices.addAll(invoices);
    if (pageInfo != null) result.pageInfo = pageInfo;
    return result;
  }

  ListInvoicesResponse._();

  factory ListInvoicesResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListInvoicesResponse()..mergeFromBuffer(data, registry);
  factory ListInvoicesResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListInvoicesResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListInvoicesResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.admin.v1'),
      createEmptyInstance: ListInvoicesResponse.$_createMessage)
    ..pPM<InvoiceSummary>(1, _omitFieldNames ? '' : 'invoices',
        subBuilder: InvoiceSummary.$_createMessage)
    ..aOM<$1.PaginatedResponse>(2, _omitFieldNames ? '' : 'pageInfo',
        subBuilder: $1.PaginatedResponse.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListInvoicesResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListInvoicesResponse copyWith(void Function(ListInvoicesResponse) updates) =>
      super.copyWith((message) => updates(message as ListInvoicesResponse))
          as ListInvoicesResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ListInvoicesResponse() / ListInvoicesResponse.new instead')
  static ListInvoicesResponse create() => ListInvoicesResponse._();
  static $pb.GeneratedMessage $_createMessage() => ListInvoicesResponse._();
  @$core.override
  ListInvoicesResponse createEmptyInstance() => ListInvoicesResponse._();
  @$core.pragma('dart2js:noInline')
  static ListInvoicesResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListInvoicesResponse>(
          ListInvoicesResponse.$_createMessage);
  static ListInvoicesResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<InvoiceSummary> get invoices => $_getList(0);

  @$pb.TagNumber(2)
  $1.PaginatedResponse get pageInfo => $_getN(1);
  @$pb.TagNumber(2)
  set pageInfo($1.PaginatedResponse value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasPageInfo() => $_has(1);
  @$pb.TagNumber(2)
  void clearPageInfo() => $_clearField(2);
  @$pb.TagNumber(2)
  $1.PaginatedResponse ensurePageInfo() => $_ensure(1);
}

class GetInvoiceUrlRequest extends $pb.GeneratedMessage {
  factory GetInvoiceUrlRequest({
    $1.UUID? workspaceId,
    $1.UUID? invoiceId,
  }) {
    final result = GetInvoiceUrlRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (invoiceId != null) result.invoiceId = invoiceId;
    return result;
  }

  GetInvoiceUrlRequest._();

  factory GetInvoiceUrlRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetInvoiceUrlRequest()..mergeFromBuffer(data, registry);
  factory GetInvoiceUrlRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetInvoiceUrlRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetInvoiceUrlRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.admin.v1'),
      createEmptyInstance: GetInvoiceUrlRequest.$_createMessage)
    ..aOM<$1.UUID>(1, _omitFieldNames ? '' : 'workspaceId',
        subBuilder: $1.UUID.$_createMessage)
    ..aOM<$1.UUID>(2, _omitFieldNames ? '' : 'invoiceId',
        subBuilder: $1.UUID.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetInvoiceUrlRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetInvoiceUrlRequest copyWith(void Function(GetInvoiceUrlRequest) updates) =>
      super.copyWith((message) => updates(message as GetInvoiceUrlRequest))
          as GetInvoiceUrlRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use GetInvoiceUrlRequest() / GetInvoiceUrlRequest.new instead')
  static GetInvoiceUrlRequest create() => GetInvoiceUrlRequest._();
  static $pb.GeneratedMessage $_createMessage() => GetInvoiceUrlRequest._();
  @$core.override
  GetInvoiceUrlRequest createEmptyInstance() => GetInvoiceUrlRequest._();
  @$core.pragma('dart2js:noInline')
  static GetInvoiceUrlRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetInvoiceUrlRequest>(
          GetInvoiceUrlRequest.$_createMessage);
  static GetInvoiceUrlRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $1.UUID get workspaceId => $_getN(0);
  @$pb.TagNumber(1)
  set workspaceId($1.UUID value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);
  @$pb.TagNumber(1)
  $1.UUID ensureWorkspaceId() => $_ensure(0);

  @$pb.TagNumber(2)
  $1.UUID get invoiceId => $_getN(1);
  @$pb.TagNumber(2)
  set invoiceId($1.UUID value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasInvoiceId() => $_has(1);
  @$pb.TagNumber(2)
  void clearInvoiceId() => $_clearField(2);
  @$pb.TagNumber(2)
  $1.UUID ensureInvoiceId() => $_ensure(1);
}

class GetInvoiceUrlResponse extends $pb.GeneratedMessage {
  factory GetInvoiceUrlResponse({
    $core.String? invoicePdfUrl,
    $core.String? hostedInvoiceUrl,
  }) {
    final result = GetInvoiceUrlResponse._();
    if (invoicePdfUrl != null) result.invoicePdfUrl = invoicePdfUrl;
    if (hostedInvoiceUrl != null) result.hostedInvoiceUrl = hostedInvoiceUrl;
    return result;
  }

  GetInvoiceUrlResponse._();

  factory GetInvoiceUrlResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetInvoiceUrlResponse()..mergeFromBuffer(data, registry);
  factory GetInvoiceUrlResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetInvoiceUrlResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetInvoiceUrlResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.admin.v1'),
      createEmptyInstance: GetInvoiceUrlResponse.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'invoicePdfUrl')
    ..aOS(2, _omitFieldNames ? '' : 'hostedInvoiceUrl')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetInvoiceUrlResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetInvoiceUrlResponse copyWith(
          void Function(GetInvoiceUrlResponse) updates) =>
      super.copyWith((message) => updates(message as GetInvoiceUrlResponse))
          as GetInvoiceUrlResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use GetInvoiceUrlResponse() / GetInvoiceUrlResponse.new instead')
  static GetInvoiceUrlResponse create() => GetInvoiceUrlResponse._();
  static $pb.GeneratedMessage $_createMessage() => GetInvoiceUrlResponse._();
  @$core.override
  GetInvoiceUrlResponse createEmptyInstance() => GetInvoiceUrlResponse._();
  @$core.pragma('dart2js:noInline')
  static GetInvoiceUrlResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetInvoiceUrlResponse>(
          GetInvoiceUrlResponse.$_createMessage);
  static GetInvoiceUrlResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get invoicePdfUrl => $_getSZ(0);
  @$pb.TagNumber(1)
  set invoicePdfUrl($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasInvoicePdfUrl() => $_has(0);
  @$pb.TagNumber(1)
  void clearInvoicePdfUrl() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get hostedInvoiceUrl => $_getSZ(1);
  @$pb.TagNumber(2)
  set hostedInvoiceUrl($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasHostedInvoiceUrl() => $_has(1);
  @$pb.TagNumber(2)
  void clearHostedInvoiceUrl() => $_clearField(2);
}

class GetCheckoutStatusRequest extends $pb.GeneratedMessage {
  factory GetCheckoutStatusRequest({
    $1.UUID? workspaceId,
    $core.String? checkoutSessionId,
  }) {
    final result = GetCheckoutStatusRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (checkoutSessionId != null) result.checkoutSessionId = checkoutSessionId;
    return result;
  }

  GetCheckoutStatusRequest._();

  factory GetCheckoutStatusRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetCheckoutStatusRequest()..mergeFromBuffer(data, registry);
  factory GetCheckoutStatusRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetCheckoutStatusRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetCheckoutStatusRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.admin.v1'),
      createEmptyInstance: GetCheckoutStatusRequest.$_createMessage)
    ..aOM<$1.UUID>(1, _omitFieldNames ? '' : 'workspaceId',
        subBuilder: $1.UUID.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'checkoutSessionId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetCheckoutStatusRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetCheckoutStatusRequest copyWith(
          void Function(GetCheckoutStatusRequest) updates) =>
      super.copyWith((message) => updates(message as GetCheckoutStatusRequest))
          as GetCheckoutStatusRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use GetCheckoutStatusRequest() / GetCheckoutStatusRequest.new instead')
  static GetCheckoutStatusRequest create() => GetCheckoutStatusRequest._();
  static $pb.GeneratedMessage $_createMessage() => GetCheckoutStatusRequest._();
  @$core.override
  GetCheckoutStatusRequest createEmptyInstance() =>
      GetCheckoutStatusRequest._();
  @$core.pragma('dart2js:noInline')
  static GetCheckoutStatusRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetCheckoutStatusRequest>(
          GetCheckoutStatusRequest.$_createMessage);
  static GetCheckoutStatusRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $1.UUID get workspaceId => $_getN(0);
  @$pb.TagNumber(1)
  set workspaceId($1.UUID value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);
  @$pb.TagNumber(1)
  $1.UUID ensureWorkspaceId() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get checkoutSessionId => $_getSZ(1);
  @$pb.TagNumber(2)
  set checkoutSessionId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCheckoutSessionId() => $_has(1);
  @$pb.TagNumber(2)
  void clearCheckoutSessionId() => $_clearField(2);
}

class GetCheckoutStatusResponse extends $pb.GeneratedMessage {
  factory GetCheckoutStatusResponse({
    $core.String? checkoutSessionId,
    $core.String? status,
    $core.bool? settled,
    CreditBalance? balance,
  }) {
    final result = GetCheckoutStatusResponse._();
    if (checkoutSessionId != null) result.checkoutSessionId = checkoutSessionId;
    if (status != null) result.status = status;
    if (settled != null) result.settled = settled;
    if (balance != null) result.balance = balance;
    return result;
  }

  GetCheckoutStatusResponse._();

  factory GetCheckoutStatusResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetCheckoutStatusResponse()..mergeFromBuffer(data, registry);
  factory GetCheckoutStatusResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetCheckoutStatusResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetCheckoutStatusResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.admin.v1'),
      createEmptyInstance: GetCheckoutStatusResponse.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'checkoutSessionId')
    ..aOS(2, _omitFieldNames ? '' : 'status')
    ..aOB(3, _omitFieldNames ? '' : 'settled')
    ..aOM<CreditBalance>(4, _omitFieldNames ? '' : 'balance',
        subBuilder: CreditBalance.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetCheckoutStatusResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetCheckoutStatusResponse copyWith(
          void Function(GetCheckoutStatusResponse) updates) =>
      super.copyWith((message) => updates(message as GetCheckoutStatusResponse))
          as GetCheckoutStatusResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use GetCheckoutStatusResponse() / GetCheckoutStatusResponse.new instead')
  static GetCheckoutStatusResponse create() => GetCheckoutStatusResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      GetCheckoutStatusResponse._();
  @$core.override
  GetCheckoutStatusResponse createEmptyInstance() =>
      GetCheckoutStatusResponse._();
  @$core.pragma('dart2js:noInline')
  static GetCheckoutStatusResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetCheckoutStatusResponse>(
          GetCheckoutStatusResponse.$_createMessage);
  static GetCheckoutStatusResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get checkoutSessionId => $_getSZ(0);
  @$pb.TagNumber(1)
  set checkoutSessionId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCheckoutSessionId() => $_has(0);
  @$pb.TagNumber(1)
  void clearCheckoutSessionId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get status => $_getSZ(1);
  @$pb.TagNumber(2)
  set status($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasStatus() => $_has(1);
  @$pb.TagNumber(2)
  void clearStatus() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.bool get settled => $_getBF(2);
  @$pb.TagNumber(3)
  set settled($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasSettled() => $_has(2);
  @$pb.TagNumber(3)
  void clearSettled() => $_clearField(3);

  @$pb.TagNumber(4)
  CreditBalance get balance => $_getN(3);
  @$pb.TagNumber(4)
  set balance(CreditBalance value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasBalance() => $_has(3);
  @$pb.TagNumber(4)
  void clearBalance() => $_clearField(4);
  @$pb.TagNumber(4)
  CreditBalance ensureBalance() => $_ensure(3);
}

class ListCreditPackagesRequest extends $pb.GeneratedMessage {
  factory ListCreditPackagesRequest({
    $core.String? currency,
  }) {
    final result = ListCreditPackagesRequest._();
    if (currency != null) result.currency = currency;
    return result;
  }

  ListCreditPackagesRequest._();

  factory ListCreditPackagesRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListCreditPackagesRequest()..mergeFromBuffer(data, registry);
  factory ListCreditPackagesRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListCreditPackagesRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListCreditPackagesRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.admin.v1'),
      createEmptyInstance: ListCreditPackagesRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'currency')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListCreditPackagesRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListCreditPackagesRequest copyWith(
          void Function(ListCreditPackagesRequest) updates) =>
      super.copyWith((message) => updates(message as ListCreditPackagesRequest))
          as ListCreditPackagesRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ListCreditPackagesRequest() / ListCreditPackagesRequest.new instead')
  static ListCreditPackagesRequest create() => ListCreditPackagesRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      ListCreditPackagesRequest._();
  @$core.override
  ListCreditPackagesRequest createEmptyInstance() =>
      ListCreditPackagesRequest._();
  @$core.pragma('dart2js:noInline')
  static ListCreditPackagesRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListCreditPackagesRequest>(
          ListCreditPackagesRequest.$_createMessage);
  static ListCreditPackagesRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get currency => $_getSZ(0);
  @$pb.TagNumber(1)
  set currency($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCurrency() => $_has(0);
  @$pb.TagNumber(1)
  void clearCurrency() => $_clearField(1);
}

class ListCreditPackagesResponse extends $pb.GeneratedMessage {
  factory ListCreditPackagesResponse({
    $core.Iterable<CreditPackEntry>? packages,
    $core.String? pricebookVersion,
  }) {
    final result = ListCreditPackagesResponse._();
    if (packages != null) result.packages.addAll(packages);
    if (pricebookVersion != null) result.pricebookVersion = pricebookVersion;
    return result;
  }

  ListCreditPackagesResponse._();

  factory ListCreditPackagesResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListCreditPackagesResponse()..mergeFromBuffer(data, registry);
  factory ListCreditPackagesResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListCreditPackagesResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListCreditPackagesResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.admin.v1'),
      createEmptyInstance: ListCreditPackagesResponse.$_createMessage)
    ..pPM<CreditPackEntry>(1, _omitFieldNames ? '' : 'packages',
        subBuilder: CreditPackEntry.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'pricebookVersion')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListCreditPackagesResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListCreditPackagesResponse copyWith(
          void Function(ListCreditPackagesResponse) updates) =>
      super.copyWith(
              (message) => updates(message as ListCreditPackagesResponse))
          as ListCreditPackagesResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ListCreditPackagesResponse() / ListCreditPackagesResponse.new instead')
  static ListCreditPackagesResponse create() => ListCreditPackagesResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      ListCreditPackagesResponse._();
  @$core.override
  ListCreditPackagesResponse createEmptyInstance() =>
      ListCreditPackagesResponse._();
  @$core.pragma('dart2js:noInline')
  static ListCreditPackagesResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListCreditPackagesResponse>(
          ListCreditPackagesResponse.$_createMessage);
  static ListCreditPackagesResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<CreditPackEntry> get packages => $_getList(0);

  @$pb.TagNumber(2)
  $core.String get pricebookVersion => $_getSZ(1);
  @$pb.TagNumber(2)
  set pricebookVersion($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPricebookVersion() => $_has(1);
  @$pb.TagNumber(2)
  void clearPricebookVersion() => $_clearField(2);
}

class ListCreditPurchasesRequest extends $pb.GeneratedMessage {
  factory ListCreditPurchasesRequest({
    $1.UUID? workspaceId,
    $1.Pagination? pagination,
  }) {
    final result = ListCreditPurchasesRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (pagination != null) result.pagination = pagination;
    return result;
  }

  ListCreditPurchasesRequest._();

  factory ListCreditPurchasesRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListCreditPurchasesRequest()..mergeFromBuffer(data, registry);
  factory ListCreditPurchasesRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListCreditPurchasesRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListCreditPurchasesRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.admin.v1'),
      createEmptyInstance: ListCreditPurchasesRequest.$_createMessage)
    ..aOM<$1.UUID>(1, _omitFieldNames ? '' : 'workspaceId',
        subBuilder: $1.UUID.$_createMessage)
    ..aOM<$1.Pagination>(2, _omitFieldNames ? '' : 'pagination',
        subBuilder: $1.Pagination.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListCreditPurchasesRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListCreditPurchasesRequest copyWith(
          void Function(ListCreditPurchasesRequest) updates) =>
      super.copyWith(
              (message) => updates(message as ListCreditPurchasesRequest))
          as ListCreditPurchasesRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ListCreditPurchasesRequest() / ListCreditPurchasesRequest.new instead')
  static ListCreditPurchasesRequest create() => ListCreditPurchasesRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      ListCreditPurchasesRequest._();
  @$core.override
  ListCreditPurchasesRequest createEmptyInstance() =>
      ListCreditPurchasesRequest._();
  @$core.pragma('dart2js:noInline')
  static ListCreditPurchasesRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListCreditPurchasesRequest>(
          ListCreditPurchasesRequest.$_createMessage);
  static ListCreditPurchasesRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $1.UUID get workspaceId => $_getN(0);
  @$pb.TagNumber(1)
  set workspaceId($1.UUID value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);
  @$pb.TagNumber(1)
  $1.UUID ensureWorkspaceId() => $_ensure(0);

  @$pb.TagNumber(2)
  $1.Pagination get pagination => $_getN(1);
  @$pb.TagNumber(2)
  set pagination($1.Pagination value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasPagination() => $_has(1);
  @$pb.TagNumber(2)
  void clearPagination() => $_clearField(2);
  @$pb.TagNumber(2)
  $1.Pagination ensurePagination() => $_ensure(1);
}

class ListCreditPurchasesResponse extends $pb.GeneratedMessage {
  factory ListCreditPurchasesResponse({
    $core.Iterable<CreditTransactionEntry>? purchases,
    $1.PaginatedResponse? pageInfo,
  }) {
    final result = ListCreditPurchasesResponse._();
    if (purchases != null) result.purchases.addAll(purchases);
    if (pageInfo != null) result.pageInfo = pageInfo;
    return result;
  }

  ListCreditPurchasesResponse._();

  factory ListCreditPurchasesResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListCreditPurchasesResponse()..mergeFromBuffer(data, registry);
  factory ListCreditPurchasesResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListCreditPurchasesResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListCreditPurchasesResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.admin.v1'),
      createEmptyInstance: ListCreditPurchasesResponse.$_createMessage)
    ..pPM<CreditTransactionEntry>(1, _omitFieldNames ? '' : 'purchases',
        subBuilder: CreditTransactionEntry.$_createMessage)
    ..aOM<$1.PaginatedResponse>(2, _omitFieldNames ? '' : 'pageInfo',
        subBuilder: $1.PaginatedResponse.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListCreditPurchasesResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListCreditPurchasesResponse copyWith(
          void Function(ListCreditPurchasesResponse) updates) =>
      super.copyWith(
              (message) => updates(message as ListCreditPurchasesResponse))
          as ListCreditPurchasesResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ListCreditPurchasesResponse() / ListCreditPurchasesResponse.new instead')
  static ListCreditPurchasesResponse create() =>
      ListCreditPurchasesResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      ListCreditPurchasesResponse._();
  @$core.override
  ListCreditPurchasesResponse createEmptyInstance() =>
      ListCreditPurchasesResponse._();
  @$core.pragma('dart2js:noInline')
  static ListCreditPurchasesResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListCreditPurchasesResponse>(
          ListCreditPurchasesResponse.$_createMessage);
  static ListCreditPurchasesResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<CreditTransactionEntry> get purchases => $_getList(0);

  @$pb.TagNumber(2)
  $1.PaginatedResponse get pageInfo => $_getN(1);
  @$pb.TagNumber(2)
  set pageInfo($1.PaginatedResponse value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasPageInfo() => $_has(1);
  @$pb.TagNumber(2)
  void clearPageInfo() => $_clearField(2);
  @$pb.TagNumber(2)
  $1.PaginatedResponse ensurePageInfo() => $_ensure(1);
}

class ApplyRetentionDiscountRequest extends $pb.GeneratedMessage {
  factory ApplyRetentionDiscountRequest({
    $1.CommandContext? context,
    $core.String? reasonCode,
  }) {
    final result = ApplyRetentionDiscountRequest._();
    if (context != null) result.context = context;
    if (reasonCode != null) result.reasonCode = reasonCode;
    return result;
  }

  ApplyRetentionDiscountRequest._();

  factory ApplyRetentionDiscountRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ApplyRetentionDiscountRequest()..mergeFromBuffer(data, registry);
  factory ApplyRetentionDiscountRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ApplyRetentionDiscountRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ApplyRetentionDiscountRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.admin.v1'),
      createEmptyInstance: ApplyRetentionDiscountRequest.$_createMessage)
    ..aOM<$1.CommandContext>(1, _omitFieldNames ? '' : 'context',
        subBuilder: $1.CommandContext.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'reasonCode')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ApplyRetentionDiscountRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ApplyRetentionDiscountRequest copyWith(
          void Function(ApplyRetentionDiscountRequest) updates) =>
      super.copyWith(
              (message) => updates(message as ApplyRetentionDiscountRequest))
          as ApplyRetentionDiscountRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ApplyRetentionDiscountRequest() / ApplyRetentionDiscountRequest.new instead')
  static ApplyRetentionDiscountRequest create() =>
      ApplyRetentionDiscountRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      ApplyRetentionDiscountRequest._();
  @$core.override
  ApplyRetentionDiscountRequest createEmptyInstance() =>
      ApplyRetentionDiscountRequest._();
  @$core.pragma('dart2js:noInline')
  static ApplyRetentionDiscountRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ApplyRetentionDiscountRequest>(
          ApplyRetentionDiscountRequest.$_createMessage);
  static ApplyRetentionDiscountRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $1.CommandContext get context => $_getN(0);
  @$pb.TagNumber(1)
  set context($1.CommandContext value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasContext() => $_has(0);
  @$pb.TagNumber(1)
  void clearContext() => $_clearField(1);
  @$pb.TagNumber(1)
  $1.CommandContext ensureContext() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get reasonCode => $_getSZ(1);
  @$pb.TagNumber(2)
  set reasonCode($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasReasonCode() => $_has(1);
  @$pb.TagNumber(2)
  void clearReasonCode() => $_clearField(2);
}

class ApplyRetentionDiscountResponse extends $pb.GeneratedMessage {
  factory ApplyRetentionDiscountResponse({
    SubscriptionSummary? subscription,
    $core.String? discountPercent,
    $core.int? durationMonths,
  }) {
    final result = ApplyRetentionDiscountResponse._();
    if (subscription != null) result.subscription = subscription;
    if (discountPercent != null) result.discountPercent = discountPercent;
    if (durationMonths != null) result.durationMonths = durationMonths;
    return result;
  }

  ApplyRetentionDiscountResponse._();

  factory ApplyRetentionDiscountResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ApplyRetentionDiscountResponse()..mergeFromBuffer(data, registry);
  factory ApplyRetentionDiscountResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ApplyRetentionDiscountResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ApplyRetentionDiscountResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.admin.v1'),
      createEmptyInstance: ApplyRetentionDiscountResponse.$_createMessage)
    ..aOM<SubscriptionSummary>(1, _omitFieldNames ? '' : 'subscription',
        subBuilder: SubscriptionSummary.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'discountPercent')
    ..aI(3, _omitFieldNames ? '' : 'durationMonths')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ApplyRetentionDiscountResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ApplyRetentionDiscountResponse copyWith(
          void Function(ApplyRetentionDiscountResponse) updates) =>
      super.copyWith(
              (message) => updates(message as ApplyRetentionDiscountResponse))
          as ApplyRetentionDiscountResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ApplyRetentionDiscountResponse() / ApplyRetentionDiscountResponse.new instead')
  static ApplyRetentionDiscountResponse create() =>
      ApplyRetentionDiscountResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      ApplyRetentionDiscountResponse._();
  @$core.override
  ApplyRetentionDiscountResponse createEmptyInstance() =>
      ApplyRetentionDiscountResponse._();
  @$core.pragma('dart2js:noInline')
  static ApplyRetentionDiscountResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ApplyRetentionDiscountResponse>(
          ApplyRetentionDiscountResponse.$_createMessage);
  static ApplyRetentionDiscountResponse? _defaultInstance;

  @$pb.TagNumber(1)
  SubscriptionSummary get subscription => $_getN(0);
  @$pb.TagNumber(1)
  set subscription(SubscriptionSummary value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasSubscription() => $_has(0);
  @$pb.TagNumber(1)
  void clearSubscription() => $_clearField(1);
  @$pb.TagNumber(1)
  SubscriptionSummary ensureSubscription() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get discountPercent => $_getSZ(1);
  @$pb.TagNumber(2)
  set discountPercent($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasDiscountPercent() => $_has(1);
  @$pb.TagNumber(2)
  void clearDiscountPercent() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get durationMonths => $_getIZ(2);
  @$pb.TagNumber(3)
  set durationMonths($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasDurationMonths() => $_has(2);
  @$pb.TagNumber(3)
  void clearDurationMonths() => $_clearField(3);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');

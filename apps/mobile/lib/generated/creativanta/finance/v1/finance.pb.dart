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
import 'package:protobuf/well_known_types/google/protobuf/timestamp.pb.dart'
    as $1;

import '../../common/v1/types.pb.dart' as $2;
import 'finance.pbenum.dart';

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'finance.pbenum.dart';

/// Reference to related domain object (§11.4).
class ObjectRef extends $pb.GeneratedMessage {
  factory ObjectRef({
    $core.String? type,
    $core.String? id,
  }) {
    final result = ObjectRef._();
    if (type != null) result.type = type;
    if (id != null) result.id = id;
    return result;
  }

  ObjectRef._();

  factory ObjectRef.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ObjectRef()..mergeFromBuffer(data, registry);
  factory ObjectRef.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ObjectRef()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ObjectRef',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.finance.v1'),
      createEmptyInstance: ObjectRef.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'type')
    ..aOS(2, _omitFieldNames ? '' : 'id')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ObjectRef clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ObjectRef copyWith(void Function(ObjectRef) updates) =>
      super.copyWith((message) => updates(message as ObjectRef)) as ObjectRef;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ObjectRef() / ObjectRef.new instead')
  static ObjectRef create() => ObjectRef._();
  static $pb.GeneratedMessage $_createMessage() => ObjectRef._();
  @$core.override
  ObjectRef createEmptyInstance() => ObjectRef._();
  @$core.pragma('dart2js:noInline')
  static ObjectRef getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ObjectRef>(ObjectRef.$_createMessage);
  static ObjectRef? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get type => $_getSZ(0);
  @$pb.TagNumber(1)
  set type($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasType() => $_has(0);
  @$pb.TagNumber(1)
  void clearType() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get id => $_getSZ(1);
  @$pb.TagNumber(2)
  set id($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasId() => $_has(1);
  @$pb.TagNumber(2)
  void clearId() => $_clearField(2);
}

/// Immutable exchange rate snapshot captured at transaction time (§25.1).
class ExchangeRateSnapshot extends $pb.GeneratedMessage {
  factory ExchangeRateSnapshot({
    $core.String? baseCurrency,
    $core.String? quoteCurrency,
    $core.String? rateToBase,
    $core.String? provider,
    $1.Timestamp? capturedAt,
    $1.Timestamp? effectiveAt,
    $2.SourceClass? sourceClass,
  }) {
    final result = ExchangeRateSnapshot._();
    if (baseCurrency != null) result.baseCurrency = baseCurrency;
    if (quoteCurrency != null) result.quoteCurrency = quoteCurrency;
    if (rateToBase != null) result.rateToBase = rateToBase;
    if (provider != null) result.provider = provider;
    if (capturedAt != null) result.capturedAt = capturedAt;
    if (effectiveAt != null) result.effectiveAt = effectiveAt;
    if (sourceClass != null) result.sourceClass = sourceClass;
    return result;
  }

  ExchangeRateSnapshot._();

  factory ExchangeRateSnapshot.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ExchangeRateSnapshot()..mergeFromBuffer(data, registry);
  factory ExchangeRateSnapshot.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ExchangeRateSnapshot()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ExchangeRateSnapshot',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.finance.v1'),
      createEmptyInstance: ExchangeRateSnapshot.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'baseCurrency')
    ..aOS(2, _omitFieldNames ? '' : 'quoteCurrency')
    ..aOS(3, _omitFieldNames ? '' : 'rateToBase')
    ..aOS(4, _omitFieldNames ? '' : 'provider')
    ..aOM<$1.Timestamp>(5, _omitFieldNames ? '' : 'capturedAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..aOM<$1.Timestamp>(6, _omitFieldNames ? '' : 'effectiveAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..aE<$2.SourceClass>(7, _omitFieldNames ? '' : 'sourceClass',
        enumValues: $2.SourceClass.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ExchangeRateSnapshot clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ExchangeRateSnapshot copyWith(void Function(ExchangeRateSnapshot) updates) =>
      super.copyWith((message) => updates(message as ExchangeRateSnapshot))
          as ExchangeRateSnapshot;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ExchangeRateSnapshot() / ExchangeRateSnapshot.new instead')
  static ExchangeRateSnapshot create() => ExchangeRateSnapshot._();
  static $pb.GeneratedMessage $_createMessage() => ExchangeRateSnapshot._();
  @$core.override
  ExchangeRateSnapshot createEmptyInstance() => ExchangeRateSnapshot._();
  @$core.pragma('dart2js:noInline')
  static ExchangeRateSnapshot getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ExchangeRateSnapshot>(
          ExchangeRateSnapshot.$_createMessage);
  static ExchangeRateSnapshot? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get baseCurrency => $_getSZ(0);
  @$pb.TagNumber(1)
  set baseCurrency($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasBaseCurrency() => $_has(0);
  @$pb.TagNumber(1)
  void clearBaseCurrency() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get quoteCurrency => $_getSZ(1);
  @$pb.TagNumber(2)
  set quoteCurrency($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasQuoteCurrency() => $_has(1);
  @$pb.TagNumber(2)
  void clearQuoteCurrency() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get rateToBase => $_getSZ(2);
  @$pb.TagNumber(3)
  set rateToBase($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasRateToBase() => $_has(2);
  @$pb.TagNumber(3)
  void clearRateToBase() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get provider => $_getSZ(3);
  @$pb.TagNumber(4)
  set provider($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasProvider() => $_has(3);
  @$pb.TagNumber(4)
  void clearProvider() => $_clearField(4);

  @$pb.TagNumber(5)
  $1.Timestamp get capturedAt => $_getN(4);
  @$pb.TagNumber(5)
  set capturedAt($1.Timestamp value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasCapturedAt() => $_has(4);
  @$pb.TagNumber(5)
  void clearCapturedAt() => $_clearField(5);
  @$pb.TagNumber(5)
  $1.Timestamp ensureCapturedAt() => $_ensure(4);

  @$pb.TagNumber(6)
  $1.Timestamp get effectiveAt => $_getN(5);
  @$pb.TagNumber(6)
  set effectiveAt($1.Timestamp value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasEffectiveAt() => $_has(5);
  @$pb.TagNumber(6)
  void clearEffectiveAt() => $_clearField(6);
  @$pb.TagNumber(6)
  $1.Timestamp ensureEffectiveAt() => $_ensure(5);

  @$pb.TagNumber(7)
  $2.SourceClass get sourceClass => $_getN(6);
  @$pb.TagNumber(7)
  set sourceClass($2.SourceClass value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasSourceClass() => $_has(6);
  @$pb.TagNumber(7)
  void clearSourceClass() => $_clearField(7);
}

/// Financial posting record (append-only ledger §26.10).
class FinancialPosting extends $pb.GeneratedMessage {
  factory FinancialPosting({
    $core.String? postingId,
    $core.String? workspaceId,
    $core.String? originType,
    $core.String? originId,
    $core.String? originVersion,
    FinancialComponent? component,
    $2.Money? amount,
    $2.SourceClass? sourceClass,
    $2.ConfidenceBand? confidence,
    ExchangeRateSnapshot? exchangeRate,
    $core.String? reversalOf,
    $1.Timestamp? effectiveAt,
    $1.Timestamp? createdAt,
  }) {
    final result = FinancialPosting._();
    if (postingId != null) result.postingId = postingId;
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (originType != null) result.originType = originType;
    if (originId != null) result.originId = originId;
    if (originVersion != null) result.originVersion = originVersion;
    if (component != null) result.component = component;
    if (amount != null) result.amount = amount;
    if (sourceClass != null) result.sourceClass = sourceClass;
    if (confidence != null) result.confidence = confidence;
    if (exchangeRate != null) result.exchangeRate = exchangeRate;
    if (reversalOf != null) result.reversalOf = reversalOf;
    if (effectiveAt != null) result.effectiveAt = effectiveAt;
    if (createdAt != null) result.createdAt = createdAt;
    return result;
  }

  FinancialPosting._();

  factory FinancialPosting.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      FinancialPosting()..mergeFromBuffer(data, registry);
  factory FinancialPosting.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      FinancialPosting()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'FinancialPosting',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.finance.v1'),
      createEmptyInstance: FinancialPosting.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'postingId')
    ..aOS(2, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(3, _omitFieldNames ? '' : 'originType')
    ..aOS(4, _omitFieldNames ? '' : 'originId')
    ..aOS(5, _omitFieldNames ? '' : 'originVersion')
    ..aE<FinancialComponent>(6, _omitFieldNames ? '' : 'component',
        enumValues: FinancialComponent.values)
    ..aOM<$2.Money>(7, _omitFieldNames ? '' : 'amount',
        subBuilder: $2.Money.$_createMessage)
    ..aE<$2.SourceClass>(8, _omitFieldNames ? '' : 'sourceClass',
        enumValues: $2.SourceClass.values)
    ..aE<$2.ConfidenceBand>(9, _omitFieldNames ? '' : 'confidence',
        enumValues: $2.ConfidenceBand.values)
    ..aOM<ExchangeRateSnapshot>(10, _omitFieldNames ? '' : 'exchangeRate',
        subBuilder: ExchangeRateSnapshot.$_createMessage)
    ..aOS(11, _omitFieldNames ? '' : 'reversalOf')
    ..aOM<$1.Timestamp>(12, _omitFieldNames ? '' : 'effectiveAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..aOM<$1.Timestamp>(13, _omitFieldNames ? '' : 'createdAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FinancialPosting clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FinancialPosting copyWith(void Function(FinancialPosting) updates) =>
      super.copyWith((message) => updates(message as FinancialPosting))
          as FinancialPosting;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use FinancialPosting() / FinancialPosting.new instead')
  static FinancialPosting create() => FinancialPosting._();
  static $pb.GeneratedMessage $_createMessage() => FinancialPosting._();
  @$core.override
  FinancialPosting createEmptyInstance() => FinancialPosting._();
  @$core.pragma('dart2js:noInline')
  static FinancialPosting getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<FinancialPosting>(
          FinancialPosting.$_createMessage);
  static FinancialPosting? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get postingId => $_getSZ(0);
  @$pb.TagNumber(1)
  set postingId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPostingId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPostingId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get workspaceId => $_getSZ(1);
  @$pb.TagNumber(2)
  set workspaceId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasWorkspaceId() => $_has(1);
  @$pb.TagNumber(2)
  void clearWorkspaceId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get originType => $_getSZ(2);
  @$pb.TagNumber(3)
  set originType($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasOriginType() => $_has(2);
  @$pb.TagNumber(3)
  void clearOriginType() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get originId => $_getSZ(3);
  @$pb.TagNumber(4)
  set originId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasOriginId() => $_has(3);
  @$pb.TagNumber(4)
  void clearOriginId() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get originVersion => $_getSZ(4);
  @$pb.TagNumber(5)
  set originVersion($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasOriginVersion() => $_has(4);
  @$pb.TagNumber(5)
  void clearOriginVersion() => $_clearField(5);

  @$pb.TagNumber(6)
  FinancialComponent get component => $_getN(5);
  @$pb.TagNumber(6)
  set component(FinancialComponent value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasComponent() => $_has(5);
  @$pb.TagNumber(6)
  void clearComponent() => $_clearField(6);

  @$pb.TagNumber(7)
  $2.Money get amount => $_getN(6);
  @$pb.TagNumber(7)
  set amount($2.Money value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasAmount() => $_has(6);
  @$pb.TagNumber(7)
  void clearAmount() => $_clearField(7);
  @$pb.TagNumber(7)
  $2.Money ensureAmount() => $_ensure(6);

  @$pb.TagNumber(8)
  $2.SourceClass get sourceClass => $_getN(7);
  @$pb.TagNumber(8)
  set sourceClass($2.SourceClass value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasSourceClass() => $_has(7);
  @$pb.TagNumber(8)
  void clearSourceClass() => $_clearField(8);

  @$pb.TagNumber(9)
  $2.ConfidenceBand get confidence => $_getN(8);
  @$pb.TagNumber(9)
  set confidence($2.ConfidenceBand value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasConfidence() => $_has(8);
  @$pb.TagNumber(9)
  void clearConfidence() => $_clearField(9);

  @$pb.TagNumber(10)
  ExchangeRateSnapshot get exchangeRate => $_getN(9);
  @$pb.TagNumber(10)
  set exchangeRate(ExchangeRateSnapshot value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasExchangeRate() => $_has(9);
  @$pb.TagNumber(10)
  void clearExchangeRate() => $_clearField(10);
  @$pb.TagNumber(10)
  ExchangeRateSnapshot ensureExchangeRate() => $_ensure(9);

  @$pb.TagNumber(11)
  $core.String get reversalOf => $_getSZ(10);
  @$pb.TagNumber(11)
  set reversalOf($core.String value) => $_setString(10, value);
  @$pb.TagNumber(11)
  $core.bool hasReversalOf() => $_has(10);
  @$pb.TagNumber(11)
  void clearReversalOf() => $_clearField(11);

  @$pb.TagNumber(12)
  $1.Timestamp get effectiveAt => $_getN(11);
  @$pb.TagNumber(12)
  set effectiveAt($1.Timestamp value) => $_setField(12, value);
  @$pb.TagNumber(12)
  $core.bool hasEffectiveAt() => $_has(11);
  @$pb.TagNumber(12)
  void clearEffectiveAt() => $_clearField(12);
  @$pb.TagNumber(12)
  $1.Timestamp ensureEffectiveAt() => $_ensure(11);

  @$pb.TagNumber(13)
  $1.Timestamp get createdAt => $_getN(12);
  @$pb.TagNumber(13)
  set createdAt($1.Timestamp value) => $_setField(13, value);
  @$pb.TagNumber(13)
  $core.bool hasCreatedAt() => $_has(12);
  @$pb.TagNumber(13)
  void clearCreatedAt() => $_clearField(13);
  @$pb.TagNumber(13)
  $1.Timestamp ensureCreatedAt() => $_ensure(12);
}

/// Cost item record (§11.2).
class CostItem extends $pb.GeneratedMessage {
  factory CostItem({
    $core.String? costItemId,
    $core.String? workspaceId,
    $core.String? costType,
    $2.Money? amount,
    $core.String? description,
    $core.String? relatedScopeType,
    $core.String? relatedScopeId,
    $2.SourceClass? sourceClass,
    $core.String? evidenceId,
    $core.String? confidenceReason,
    CostState? costState,
    $core.String? effectiveDate,
    $1.Timestamp? createdAt,
    $1.Timestamp? updatedAt,
  }) {
    final result = CostItem._();
    if (costItemId != null) result.costItemId = costItemId;
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (costType != null) result.costType = costType;
    if (amount != null) result.amount = amount;
    if (description != null) result.description = description;
    if (relatedScopeType != null) result.relatedScopeType = relatedScopeType;
    if (relatedScopeId != null) result.relatedScopeId = relatedScopeId;
    if (sourceClass != null) result.sourceClass = sourceClass;
    if (evidenceId != null) result.evidenceId = evidenceId;
    if (confidenceReason != null) result.confidenceReason = confidenceReason;
    if (costState != null) result.costState = costState;
    if (effectiveDate != null) result.effectiveDate = effectiveDate;
    if (createdAt != null) result.createdAt = createdAt;
    if (updatedAt != null) result.updatedAt = updatedAt;
    return result;
  }

  CostItem._();

  factory CostItem.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CostItem()..mergeFromBuffer(data, registry);
  factory CostItem.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CostItem()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CostItem',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.finance.v1'),
      createEmptyInstance: CostItem.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'costItemId')
    ..aOS(2, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(3, _omitFieldNames ? '' : 'costType')
    ..aOM<$2.Money>(4, _omitFieldNames ? '' : 'amount',
        subBuilder: $2.Money.$_createMessage)
    ..aOS(5, _omitFieldNames ? '' : 'description')
    ..aOS(6, _omitFieldNames ? '' : 'relatedScopeType')
    ..aOS(7, _omitFieldNames ? '' : 'relatedScopeId')
    ..aE<$2.SourceClass>(8, _omitFieldNames ? '' : 'sourceClass',
        enumValues: $2.SourceClass.values)
    ..aOS(9, _omitFieldNames ? '' : 'evidenceId')
    ..aOS(10, _omitFieldNames ? '' : 'confidenceReason')
    ..aE<CostState>(11, _omitFieldNames ? '' : 'costState',
        enumValues: CostState.values)
    ..aOS(12, _omitFieldNames ? '' : 'effectiveDate')
    ..aOM<$1.Timestamp>(13, _omitFieldNames ? '' : 'createdAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..aOM<$1.Timestamp>(14, _omitFieldNames ? '' : 'updatedAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CostItem clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CostItem copyWith(void Function(CostItem) updates) =>
      super.copyWith((message) => updates(message as CostItem)) as CostItem;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use CostItem() / CostItem.new instead')
  static CostItem create() => CostItem._();
  static $pb.GeneratedMessage $_createMessage() => CostItem._();
  @$core.override
  CostItem createEmptyInstance() => CostItem._();
  @$core.pragma('dart2js:noInline')
  static CostItem getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CostItem>(CostItem.$_createMessage);
  static CostItem? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get costItemId => $_getSZ(0);
  @$pb.TagNumber(1)
  set costItemId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCostItemId() => $_has(0);
  @$pb.TagNumber(1)
  void clearCostItemId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get workspaceId => $_getSZ(1);
  @$pb.TagNumber(2)
  set workspaceId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasWorkspaceId() => $_has(1);
  @$pb.TagNumber(2)
  void clearWorkspaceId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get costType => $_getSZ(2);
  @$pb.TagNumber(3)
  set costType($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasCostType() => $_has(2);
  @$pb.TagNumber(3)
  void clearCostType() => $_clearField(3);

  @$pb.TagNumber(4)
  $2.Money get amount => $_getN(3);
  @$pb.TagNumber(4)
  set amount($2.Money value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasAmount() => $_has(3);
  @$pb.TagNumber(4)
  void clearAmount() => $_clearField(4);
  @$pb.TagNumber(4)
  $2.Money ensureAmount() => $_ensure(3);

  @$pb.TagNumber(5)
  $core.String get description => $_getSZ(4);
  @$pb.TagNumber(5)
  set description($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasDescription() => $_has(4);
  @$pb.TagNumber(5)
  void clearDescription() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get relatedScopeType => $_getSZ(5);
  @$pb.TagNumber(6)
  set relatedScopeType($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasRelatedScopeType() => $_has(5);
  @$pb.TagNumber(6)
  void clearRelatedScopeType() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get relatedScopeId => $_getSZ(6);
  @$pb.TagNumber(7)
  set relatedScopeId($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasRelatedScopeId() => $_has(6);
  @$pb.TagNumber(7)
  void clearRelatedScopeId() => $_clearField(7);

  @$pb.TagNumber(8)
  $2.SourceClass get sourceClass => $_getN(7);
  @$pb.TagNumber(8)
  set sourceClass($2.SourceClass value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasSourceClass() => $_has(7);
  @$pb.TagNumber(8)
  void clearSourceClass() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get evidenceId => $_getSZ(8);
  @$pb.TagNumber(9)
  set evidenceId($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasEvidenceId() => $_has(8);
  @$pb.TagNumber(9)
  void clearEvidenceId() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.String get confidenceReason => $_getSZ(9);
  @$pb.TagNumber(10)
  set confidenceReason($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasConfidenceReason() => $_has(9);
  @$pb.TagNumber(10)
  void clearConfidenceReason() => $_clearField(10);

  @$pb.TagNumber(11)
  CostState get costState => $_getN(10);
  @$pb.TagNumber(11)
  set costState(CostState value) => $_setField(11, value);
  @$pb.TagNumber(11)
  $core.bool hasCostState() => $_has(10);
  @$pb.TagNumber(11)
  void clearCostState() => $_clearField(11);

  @$pb.TagNumber(12)
  $core.String get effectiveDate => $_getSZ(11);
  @$pb.TagNumber(12)
  set effectiveDate($core.String value) => $_setString(11, value);
  @$pb.TagNumber(12)
  $core.bool hasEffectiveDate() => $_has(11);
  @$pb.TagNumber(12)
  void clearEffectiveDate() => $_clearField(12);

  @$pb.TagNumber(13)
  $1.Timestamp get createdAt => $_getN(12);
  @$pb.TagNumber(13)
  set createdAt($1.Timestamp value) => $_setField(13, value);
  @$pb.TagNumber(13)
  $core.bool hasCreatedAt() => $_has(12);
  @$pb.TagNumber(13)
  void clearCreatedAt() => $_clearField(13);
  @$pb.TagNumber(13)
  $1.Timestamp ensureCreatedAt() => $_ensure(12);

  @$pb.TagNumber(14)
  $1.Timestamp get updatedAt => $_getN(13);
  @$pb.TagNumber(14)
  set updatedAt($1.Timestamp value) => $_setField(14, value);
  @$pb.TagNumber(14)
  $core.bool hasUpdatedAt() => $_has(13);
  @$pb.TagNumber(14)
  void clearUpdatedAt() => $_clearField(14);
  @$pb.TagNumber(14)
  $1.Timestamp ensureUpdatedAt() => $_ensure(13);
}

/// Settlement line record (§26.9).
class SettlementLine extends $pb.GeneratedMessage {
  factory SettlementLine({
    $core.String? lineId,
    $core.String? workspaceId,
    $core.String? settlementId,
    $core.String? externalLineId,
    $core.String? externalOrderId,
    $core.String? orderId,
    $2.Money? grossAmount,
    $2.Money? feeAmount,
    $2.Money? refundAmount,
    $2.Money? netAmount,
    $2.Money? matchedAmount,
    $core.String? currency,
    ReconciliationState? reconciliationState,
    $1.Timestamp? createdAt,
  }) {
    final result = SettlementLine._();
    if (lineId != null) result.lineId = lineId;
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (settlementId != null) result.settlementId = settlementId;
    if (externalLineId != null) result.externalLineId = externalLineId;
    if (externalOrderId != null) result.externalOrderId = externalOrderId;
    if (orderId != null) result.orderId = orderId;
    if (grossAmount != null) result.grossAmount = grossAmount;
    if (feeAmount != null) result.feeAmount = feeAmount;
    if (refundAmount != null) result.refundAmount = refundAmount;
    if (netAmount != null) result.netAmount = netAmount;
    if (matchedAmount != null) result.matchedAmount = matchedAmount;
    if (currency != null) result.currency = currency;
    if (reconciliationState != null)
      result.reconciliationState = reconciliationState;
    if (createdAt != null) result.createdAt = createdAt;
    return result;
  }

  SettlementLine._();

  factory SettlementLine.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SettlementLine()..mergeFromBuffer(data, registry);
  factory SettlementLine.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SettlementLine()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SettlementLine',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.finance.v1'),
      createEmptyInstance: SettlementLine.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'lineId')
    ..aOS(2, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(3, _omitFieldNames ? '' : 'settlementId')
    ..aOS(4, _omitFieldNames ? '' : 'externalLineId')
    ..aOS(5, _omitFieldNames ? '' : 'externalOrderId')
    ..aOS(6, _omitFieldNames ? '' : 'orderId')
    ..aOM<$2.Money>(7, _omitFieldNames ? '' : 'grossAmount',
        subBuilder: $2.Money.$_createMessage)
    ..aOM<$2.Money>(8, _omitFieldNames ? '' : 'feeAmount',
        subBuilder: $2.Money.$_createMessage)
    ..aOM<$2.Money>(9, _omitFieldNames ? '' : 'refundAmount',
        subBuilder: $2.Money.$_createMessage)
    ..aOM<$2.Money>(10, _omitFieldNames ? '' : 'netAmount',
        subBuilder: $2.Money.$_createMessage)
    ..aOM<$2.Money>(11, _omitFieldNames ? '' : 'matchedAmount',
        subBuilder: $2.Money.$_createMessage)
    ..aOS(12, _omitFieldNames ? '' : 'currency')
    ..aE<ReconciliationState>(13, _omitFieldNames ? '' : 'reconciliationState',
        enumValues: ReconciliationState.values)
    ..aOM<$1.Timestamp>(14, _omitFieldNames ? '' : 'createdAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SettlementLine clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SettlementLine copyWith(void Function(SettlementLine) updates) =>
      super.copyWith((message) => updates(message as SettlementLine))
          as SettlementLine;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use SettlementLine() / SettlementLine.new instead')
  static SettlementLine create() => SettlementLine._();
  static $pb.GeneratedMessage $_createMessage() => SettlementLine._();
  @$core.override
  SettlementLine createEmptyInstance() => SettlementLine._();
  @$core.pragma('dart2js:noInline')
  static SettlementLine getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SettlementLine>(
          SettlementLine.$_createMessage);
  static SettlementLine? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get lineId => $_getSZ(0);
  @$pb.TagNumber(1)
  set lineId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasLineId() => $_has(0);
  @$pb.TagNumber(1)
  void clearLineId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get workspaceId => $_getSZ(1);
  @$pb.TagNumber(2)
  set workspaceId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasWorkspaceId() => $_has(1);
  @$pb.TagNumber(2)
  void clearWorkspaceId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get settlementId => $_getSZ(2);
  @$pb.TagNumber(3)
  set settlementId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasSettlementId() => $_has(2);
  @$pb.TagNumber(3)
  void clearSettlementId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get externalLineId => $_getSZ(3);
  @$pb.TagNumber(4)
  set externalLineId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasExternalLineId() => $_has(3);
  @$pb.TagNumber(4)
  void clearExternalLineId() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get externalOrderId => $_getSZ(4);
  @$pb.TagNumber(5)
  set externalOrderId($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasExternalOrderId() => $_has(4);
  @$pb.TagNumber(5)
  void clearExternalOrderId() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get orderId => $_getSZ(5);
  @$pb.TagNumber(6)
  set orderId($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasOrderId() => $_has(5);
  @$pb.TagNumber(6)
  void clearOrderId() => $_clearField(6);

  @$pb.TagNumber(7)
  $2.Money get grossAmount => $_getN(6);
  @$pb.TagNumber(7)
  set grossAmount($2.Money value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasGrossAmount() => $_has(6);
  @$pb.TagNumber(7)
  void clearGrossAmount() => $_clearField(7);
  @$pb.TagNumber(7)
  $2.Money ensureGrossAmount() => $_ensure(6);

  @$pb.TagNumber(8)
  $2.Money get feeAmount => $_getN(7);
  @$pb.TagNumber(8)
  set feeAmount($2.Money value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasFeeAmount() => $_has(7);
  @$pb.TagNumber(8)
  void clearFeeAmount() => $_clearField(8);
  @$pb.TagNumber(8)
  $2.Money ensureFeeAmount() => $_ensure(7);

  @$pb.TagNumber(9)
  $2.Money get refundAmount => $_getN(8);
  @$pb.TagNumber(9)
  set refundAmount($2.Money value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasRefundAmount() => $_has(8);
  @$pb.TagNumber(9)
  void clearRefundAmount() => $_clearField(9);
  @$pb.TagNumber(9)
  $2.Money ensureRefundAmount() => $_ensure(8);

  @$pb.TagNumber(10)
  $2.Money get netAmount => $_getN(9);
  @$pb.TagNumber(10)
  set netAmount($2.Money value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasNetAmount() => $_has(9);
  @$pb.TagNumber(10)
  void clearNetAmount() => $_clearField(10);
  @$pb.TagNumber(10)
  $2.Money ensureNetAmount() => $_ensure(9);

  @$pb.TagNumber(11)
  $2.Money get matchedAmount => $_getN(10);
  @$pb.TagNumber(11)
  set matchedAmount($2.Money value) => $_setField(11, value);
  @$pb.TagNumber(11)
  $core.bool hasMatchedAmount() => $_has(10);
  @$pb.TagNumber(11)
  void clearMatchedAmount() => $_clearField(11);
  @$pb.TagNumber(11)
  $2.Money ensureMatchedAmount() => $_ensure(10);

  @$pb.TagNumber(12)
  $core.String get currency => $_getSZ(11);
  @$pb.TagNumber(12)
  set currency($core.String value) => $_setString(11, value);
  @$pb.TagNumber(12)
  $core.bool hasCurrency() => $_has(11);
  @$pb.TagNumber(12)
  void clearCurrency() => $_clearField(12);

  @$pb.TagNumber(13)
  ReconciliationState get reconciliationState => $_getN(12);
  @$pb.TagNumber(13)
  set reconciliationState(ReconciliationState value) => $_setField(13, value);
  @$pb.TagNumber(13)
  $core.bool hasReconciliationState() => $_has(12);
  @$pb.TagNumber(13)
  void clearReconciliationState() => $_clearField(13);

  @$pb.TagNumber(14)
  $1.Timestamp get createdAt => $_getN(13);
  @$pb.TagNumber(14)
  set createdAt($1.Timestamp value) => $_setField(14, value);
  @$pb.TagNumber(14)
  $core.bool hasCreatedAt() => $_has(13);
  @$pb.TagNumber(14)
  void clearCreatedAt() => $_clearField(14);
  @$pb.TagNumber(14)
  $1.Timestamp ensureCreatedAt() => $_ensure(13);
}

/// Platform settlement record (§11.1).
class Settlement extends $pb.GeneratedMessage {
  factory Settlement({
    $core.String? settlementId,
    $core.String? workspaceId,
    $2.SourceClass? sourceClass,
    $core.String? sourcePlatform,
    $core.String? externalSettlementId,
    $core.String? connectedAccountId,
    ExchangeRateSnapshot? exchangeRate,
    $core.String? importFingerprint,
    $2.Money? grossAmount,
    $2.Money? netAmount,
    $core.String? feesJson,
    $core.String? deductionsJson,
    $core.String? currency,
    SettlementState? settlementState,
    ReconciliationState? reconciliationState,
    $core.Iterable<$core.String>? relatedOrderIds,
    $core.String? effectiveDate,
    $1.Timestamp? createdAt,
    $1.Timestamp? updatedAt,
    $core.Iterable<SettlementLine>? lines,
  }) {
    final result = Settlement._();
    if (settlementId != null) result.settlementId = settlementId;
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (sourceClass != null) result.sourceClass = sourceClass;
    if (sourcePlatform != null) result.sourcePlatform = sourcePlatform;
    if (externalSettlementId != null)
      result.externalSettlementId = externalSettlementId;
    if (connectedAccountId != null)
      result.connectedAccountId = connectedAccountId;
    if (exchangeRate != null) result.exchangeRate = exchangeRate;
    if (importFingerprint != null) result.importFingerprint = importFingerprint;
    if (grossAmount != null) result.grossAmount = grossAmount;
    if (netAmount != null) result.netAmount = netAmount;
    if (feesJson != null) result.feesJson = feesJson;
    if (deductionsJson != null) result.deductionsJson = deductionsJson;
    if (currency != null) result.currency = currency;
    if (settlementState != null) result.settlementState = settlementState;
    if (reconciliationState != null)
      result.reconciliationState = reconciliationState;
    if (relatedOrderIds != null) result.relatedOrderIds.addAll(relatedOrderIds);
    if (effectiveDate != null) result.effectiveDate = effectiveDate;
    if (createdAt != null) result.createdAt = createdAt;
    if (updatedAt != null) result.updatedAt = updatedAt;
    if (lines != null) result.lines.addAll(lines);
    return result;
  }

  Settlement._();

  factory Settlement.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Settlement()..mergeFromBuffer(data, registry);
  factory Settlement.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Settlement()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Settlement',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.finance.v1'),
      createEmptyInstance: Settlement.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'settlementId')
    ..aOS(2, _omitFieldNames ? '' : 'workspaceId')
    ..aE<$2.SourceClass>(3, _omitFieldNames ? '' : 'sourceClass',
        enumValues: $2.SourceClass.values)
    ..aOS(4, _omitFieldNames ? '' : 'sourcePlatform')
    ..aOS(5, _omitFieldNames ? '' : 'externalSettlementId')
    ..aOS(6, _omitFieldNames ? '' : 'connectedAccountId')
    ..aOM<ExchangeRateSnapshot>(7, _omitFieldNames ? '' : 'exchangeRate',
        subBuilder: ExchangeRateSnapshot.$_createMessage)
    ..aOS(8, _omitFieldNames ? '' : 'importFingerprint')
    ..aOM<$2.Money>(9, _omitFieldNames ? '' : 'grossAmount',
        subBuilder: $2.Money.$_createMessage)
    ..aOM<$2.Money>(10, _omitFieldNames ? '' : 'netAmount',
        subBuilder: $2.Money.$_createMessage)
    ..aOS(11, _omitFieldNames ? '' : 'feesJson')
    ..aOS(12, _omitFieldNames ? '' : 'deductionsJson')
    ..aOS(13, _omitFieldNames ? '' : 'currency')
    ..aE<SettlementState>(14, _omitFieldNames ? '' : 'settlementState',
        enumValues: SettlementState.values)
    ..aE<ReconciliationState>(15, _omitFieldNames ? '' : 'reconciliationState',
        enumValues: ReconciliationState.values)
    ..pPS(16, _omitFieldNames ? '' : 'relatedOrderIds')
    ..aOS(17, _omitFieldNames ? '' : 'effectiveDate')
    ..aOM<$1.Timestamp>(18, _omitFieldNames ? '' : 'createdAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..aOM<$1.Timestamp>(19, _omitFieldNames ? '' : 'updatedAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..pPM<SettlementLine>(20, _omitFieldNames ? '' : 'lines',
        subBuilder: SettlementLine.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Settlement clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Settlement copyWith(void Function(Settlement) updates) =>
      super.copyWith((message) => updates(message as Settlement)) as Settlement;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use Settlement() / Settlement.new instead')
  static Settlement create() => Settlement._();
  static $pb.GeneratedMessage $_createMessage() => Settlement._();
  @$core.override
  Settlement createEmptyInstance() => Settlement._();
  @$core.pragma('dart2js:noInline')
  static Settlement getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Settlement>(Settlement.$_createMessage);
  static Settlement? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get settlementId => $_getSZ(0);
  @$pb.TagNumber(1)
  set settlementId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSettlementId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSettlementId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get workspaceId => $_getSZ(1);
  @$pb.TagNumber(2)
  set workspaceId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasWorkspaceId() => $_has(1);
  @$pb.TagNumber(2)
  void clearWorkspaceId() => $_clearField(2);

  @$pb.TagNumber(3)
  $2.SourceClass get sourceClass => $_getN(2);
  @$pb.TagNumber(3)
  set sourceClass($2.SourceClass value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasSourceClass() => $_has(2);
  @$pb.TagNumber(3)
  void clearSourceClass() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get sourcePlatform => $_getSZ(3);
  @$pb.TagNumber(4)
  set sourcePlatform($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasSourcePlatform() => $_has(3);
  @$pb.TagNumber(4)
  void clearSourcePlatform() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get externalSettlementId => $_getSZ(4);
  @$pb.TagNumber(5)
  set externalSettlementId($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasExternalSettlementId() => $_has(4);
  @$pb.TagNumber(5)
  void clearExternalSettlementId() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get connectedAccountId => $_getSZ(5);
  @$pb.TagNumber(6)
  set connectedAccountId($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasConnectedAccountId() => $_has(5);
  @$pb.TagNumber(6)
  void clearConnectedAccountId() => $_clearField(6);

  @$pb.TagNumber(7)
  ExchangeRateSnapshot get exchangeRate => $_getN(6);
  @$pb.TagNumber(7)
  set exchangeRate(ExchangeRateSnapshot value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasExchangeRate() => $_has(6);
  @$pb.TagNumber(7)
  void clearExchangeRate() => $_clearField(7);
  @$pb.TagNumber(7)
  ExchangeRateSnapshot ensureExchangeRate() => $_ensure(6);

  @$pb.TagNumber(8)
  $core.String get importFingerprint => $_getSZ(7);
  @$pb.TagNumber(8)
  set importFingerprint($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasImportFingerprint() => $_has(7);
  @$pb.TagNumber(8)
  void clearImportFingerprint() => $_clearField(8);

  @$pb.TagNumber(9)
  $2.Money get grossAmount => $_getN(8);
  @$pb.TagNumber(9)
  set grossAmount($2.Money value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasGrossAmount() => $_has(8);
  @$pb.TagNumber(9)
  void clearGrossAmount() => $_clearField(9);
  @$pb.TagNumber(9)
  $2.Money ensureGrossAmount() => $_ensure(8);

  @$pb.TagNumber(10)
  $2.Money get netAmount => $_getN(9);
  @$pb.TagNumber(10)
  set netAmount($2.Money value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasNetAmount() => $_has(9);
  @$pb.TagNumber(10)
  void clearNetAmount() => $_clearField(10);
  @$pb.TagNumber(10)
  $2.Money ensureNetAmount() => $_ensure(9);

  @$pb.TagNumber(11)
  $core.String get feesJson => $_getSZ(10);
  @$pb.TagNumber(11)
  set feesJson($core.String value) => $_setString(10, value);
  @$pb.TagNumber(11)
  $core.bool hasFeesJson() => $_has(10);
  @$pb.TagNumber(11)
  void clearFeesJson() => $_clearField(11);

  @$pb.TagNumber(12)
  $core.String get deductionsJson => $_getSZ(11);
  @$pb.TagNumber(12)
  set deductionsJson($core.String value) => $_setString(11, value);
  @$pb.TagNumber(12)
  $core.bool hasDeductionsJson() => $_has(11);
  @$pb.TagNumber(12)
  void clearDeductionsJson() => $_clearField(12);

  @$pb.TagNumber(13)
  $core.String get currency => $_getSZ(12);
  @$pb.TagNumber(13)
  set currency($core.String value) => $_setString(12, value);
  @$pb.TagNumber(13)
  $core.bool hasCurrency() => $_has(12);
  @$pb.TagNumber(13)
  void clearCurrency() => $_clearField(13);

  @$pb.TagNumber(14)
  SettlementState get settlementState => $_getN(13);
  @$pb.TagNumber(14)
  set settlementState(SettlementState value) => $_setField(14, value);
  @$pb.TagNumber(14)
  $core.bool hasSettlementState() => $_has(13);
  @$pb.TagNumber(14)
  void clearSettlementState() => $_clearField(14);

  @$pb.TagNumber(15)
  ReconciliationState get reconciliationState => $_getN(14);
  @$pb.TagNumber(15)
  set reconciliationState(ReconciliationState value) => $_setField(15, value);
  @$pb.TagNumber(15)
  $core.bool hasReconciliationState() => $_has(14);
  @$pb.TagNumber(15)
  void clearReconciliationState() => $_clearField(15);

  @$pb.TagNumber(16)
  $pb.PbList<$core.String> get relatedOrderIds => $_getList(15);

  @$pb.TagNumber(17)
  $core.String get effectiveDate => $_getSZ(16);
  @$pb.TagNumber(17)
  set effectiveDate($core.String value) => $_setString(16, value);
  @$pb.TagNumber(17)
  $core.bool hasEffectiveDate() => $_has(16);
  @$pb.TagNumber(17)
  void clearEffectiveDate() => $_clearField(17);

  @$pb.TagNumber(18)
  $1.Timestamp get createdAt => $_getN(17);
  @$pb.TagNumber(18)
  set createdAt($1.Timestamp value) => $_setField(18, value);
  @$pb.TagNumber(18)
  $core.bool hasCreatedAt() => $_has(17);
  @$pb.TagNumber(18)
  void clearCreatedAt() => $_clearField(18);
  @$pb.TagNumber(18)
  $1.Timestamp ensureCreatedAt() => $_ensure(17);

  @$pb.TagNumber(19)
  $1.Timestamp get updatedAt => $_getN(18);
  @$pb.TagNumber(19)
  set updatedAt($1.Timestamp value) => $_setField(19, value);
  @$pb.TagNumber(19)
  $core.bool hasUpdatedAt() => $_has(18);
  @$pb.TagNumber(19)
  void clearUpdatedAt() => $_clearField(19);
  @$pb.TagNumber(19)
  $1.Timestamp ensureUpdatedAt() => $_ensure(18);

  @$pb.TagNumber(20)
  $pb.PbList<SettlementLine> get lines => $_getList(19);
}

/// Profit snapshot projection (§11.3).
class ProfitSnapshot extends $pb.GeneratedMessage {
  factory ProfitSnapshot({
    $core.String? snapshotId,
    $core.String? workspaceId,
    $core.String? scopeType,
    $core.String? scopeId,
    $core.String? periodStart,
    $core.String? periodEnd,
    $2.Money? grossRevenue,
    $2.Money? platformFees,
    $2.Money? shippingCosts,
    $2.Money? affiliateCommissions,
    $2.Money? refundDeductions,
    $2.Money? cogs,
    $2.Money? adsSpend,
    $2.Money? aiCreditCosts,
    $2.Money? seedingCosts,
    $2.Money? otherCosts,
    $2.Money? netProfit,
    $core.String? marginPct,
    $core.String? sourceClassMixJson,
    $2.ConfidenceBand? confidence,
    $1.Timestamp? freshnessAt,
    $core.String? currency,
    $1.Timestamp? createdAt,
    $core.bool? isIncomplete,
    $core.int? unknownRequiredComponentsCount,
    $2.Money? pendingRevenue,
    $2.Money? unreconciledAmount,
    $core.int? unreconciledCount,
  }) {
    final result = ProfitSnapshot._();
    if (snapshotId != null) result.snapshotId = snapshotId;
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (scopeType != null) result.scopeType = scopeType;
    if (scopeId != null) result.scopeId = scopeId;
    if (periodStart != null) result.periodStart = periodStart;
    if (periodEnd != null) result.periodEnd = periodEnd;
    if (grossRevenue != null) result.grossRevenue = grossRevenue;
    if (platformFees != null) result.platformFees = platformFees;
    if (shippingCosts != null) result.shippingCosts = shippingCosts;
    if (affiliateCommissions != null)
      result.affiliateCommissions = affiliateCommissions;
    if (refundDeductions != null) result.refundDeductions = refundDeductions;
    if (cogs != null) result.cogs = cogs;
    if (adsSpend != null) result.adsSpend = adsSpend;
    if (aiCreditCosts != null) result.aiCreditCosts = aiCreditCosts;
    if (seedingCosts != null) result.seedingCosts = seedingCosts;
    if (otherCosts != null) result.otherCosts = otherCosts;
    if (netProfit != null) result.netProfit = netProfit;
    if (marginPct != null) result.marginPct = marginPct;
    if (sourceClassMixJson != null)
      result.sourceClassMixJson = sourceClassMixJson;
    if (confidence != null) result.confidence = confidence;
    if (freshnessAt != null) result.freshnessAt = freshnessAt;
    if (currency != null) result.currency = currency;
    if (createdAt != null) result.createdAt = createdAt;
    if (isIncomplete != null) result.isIncomplete = isIncomplete;
    if (unknownRequiredComponentsCount != null)
      result.unknownRequiredComponentsCount = unknownRequiredComponentsCount;
    if (pendingRevenue != null) result.pendingRevenue = pendingRevenue;
    if (unreconciledAmount != null)
      result.unreconciledAmount = unreconciledAmount;
    if (unreconciledCount != null) result.unreconciledCount = unreconciledCount;
    return result;
  }

  ProfitSnapshot._();

  factory ProfitSnapshot.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ProfitSnapshot()..mergeFromBuffer(data, registry);
  factory ProfitSnapshot.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ProfitSnapshot()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ProfitSnapshot',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.finance.v1'),
      createEmptyInstance: ProfitSnapshot.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'snapshotId')
    ..aOS(2, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(3, _omitFieldNames ? '' : 'scopeType')
    ..aOS(4, _omitFieldNames ? '' : 'scopeId')
    ..aOS(5, _omitFieldNames ? '' : 'periodStart')
    ..aOS(6, _omitFieldNames ? '' : 'periodEnd')
    ..aOM<$2.Money>(7, _omitFieldNames ? '' : 'grossRevenue',
        subBuilder: $2.Money.$_createMessage)
    ..aOM<$2.Money>(8, _omitFieldNames ? '' : 'platformFees',
        subBuilder: $2.Money.$_createMessage)
    ..aOM<$2.Money>(9, _omitFieldNames ? '' : 'shippingCosts',
        subBuilder: $2.Money.$_createMessage)
    ..aOM<$2.Money>(10, _omitFieldNames ? '' : 'affiliateCommissions',
        subBuilder: $2.Money.$_createMessage)
    ..aOM<$2.Money>(11, _omitFieldNames ? '' : 'refundDeductions',
        subBuilder: $2.Money.$_createMessage)
    ..aOM<$2.Money>(12, _omitFieldNames ? '' : 'cogs',
        subBuilder: $2.Money.$_createMessage)
    ..aOM<$2.Money>(13, _omitFieldNames ? '' : 'adsSpend',
        subBuilder: $2.Money.$_createMessage)
    ..aOM<$2.Money>(14, _omitFieldNames ? '' : 'aiCreditCosts',
        subBuilder: $2.Money.$_createMessage)
    ..aOM<$2.Money>(15, _omitFieldNames ? '' : 'seedingCosts',
        subBuilder: $2.Money.$_createMessage)
    ..aOM<$2.Money>(16, _omitFieldNames ? '' : 'otherCosts',
        subBuilder: $2.Money.$_createMessage)
    ..aOM<$2.Money>(17, _omitFieldNames ? '' : 'netProfit',
        subBuilder: $2.Money.$_createMessage)
    ..aOS(18, _omitFieldNames ? '' : 'marginPct')
    ..aOS(19, _omitFieldNames ? '' : 'sourceClassMixJson')
    ..aE<$2.ConfidenceBand>(20, _omitFieldNames ? '' : 'confidence',
        enumValues: $2.ConfidenceBand.values)
    ..aOM<$1.Timestamp>(21, _omitFieldNames ? '' : 'freshnessAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..aOS(22, _omitFieldNames ? '' : 'currency')
    ..aOM<$1.Timestamp>(23, _omitFieldNames ? '' : 'createdAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..aOB(24, _omitFieldNames ? '' : 'isIncomplete')
    ..aI(25, _omitFieldNames ? '' : 'unknownRequiredComponentsCount')
    ..aOM<$2.Money>(26, _omitFieldNames ? '' : 'pendingRevenue',
        subBuilder: $2.Money.$_createMessage)
    ..aOM<$2.Money>(27, _omitFieldNames ? '' : 'unreconciledAmount',
        subBuilder: $2.Money.$_createMessage)
    ..aI(28, _omitFieldNames ? '' : 'unreconciledCount')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ProfitSnapshot clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ProfitSnapshot copyWith(void Function(ProfitSnapshot) updates) =>
      super.copyWith((message) => updates(message as ProfitSnapshot))
          as ProfitSnapshot;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ProfitSnapshot() / ProfitSnapshot.new instead')
  static ProfitSnapshot create() => ProfitSnapshot._();
  static $pb.GeneratedMessage $_createMessage() => ProfitSnapshot._();
  @$core.override
  ProfitSnapshot createEmptyInstance() => ProfitSnapshot._();
  @$core.pragma('dart2js:noInline')
  static ProfitSnapshot getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ProfitSnapshot>(
          ProfitSnapshot.$_createMessage);
  static ProfitSnapshot? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get snapshotId => $_getSZ(0);
  @$pb.TagNumber(1)
  set snapshotId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSnapshotId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSnapshotId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get workspaceId => $_getSZ(1);
  @$pb.TagNumber(2)
  set workspaceId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasWorkspaceId() => $_has(1);
  @$pb.TagNumber(2)
  void clearWorkspaceId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get scopeType => $_getSZ(2);
  @$pb.TagNumber(3)
  set scopeType($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasScopeType() => $_has(2);
  @$pb.TagNumber(3)
  void clearScopeType() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get scopeId => $_getSZ(3);
  @$pb.TagNumber(4)
  set scopeId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasScopeId() => $_has(3);
  @$pb.TagNumber(4)
  void clearScopeId() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get periodStart => $_getSZ(4);
  @$pb.TagNumber(5)
  set periodStart($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasPeriodStart() => $_has(4);
  @$pb.TagNumber(5)
  void clearPeriodStart() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get periodEnd => $_getSZ(5);
  @$pb.TagNumber(6)
  set periodEnd($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasPeriodEnd() => $_has(5);
  @$pb.TagNumber(6)
  void clearPeriodEnd() => $_clearField(6);

  @$pb.TagNumber(7)
  $2.Money get grossRevenue => $_getN(6);
  @$pb.TagNumber(7)
  set grossRevenue($2.Money value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasGrossRevenue() => $_has(6);
  @$pb.TagNumber(7)
  void clearGrossRevenue() => $_clearField(7);
  @$pb.TagNumber(7)
  $2.Money ensureGrossRevenue() => $_ensure(6);

  @$pb.TagNumber(8)
  $2.Money get platformFees => $_getN(7);
  @$pb.TagNumber(8)
  set platformFees($2.Money value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasPlatformFees() => $_has(7);
  @$pb.TagNumber(8)
  void clearPlatformFees() => $_clearField(8);
  @$pb.TagNumber(8)
  $2.Money ensurePlatformFees() => $_ensure(7);

  @$pb.TagNumber(9)
  $2.Money get shippingCosts => $_getN(8);
  @$pb.TagNumber(9)
  set shippingCosts($2.Money value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasShippingCosts() => $_has(8);
  @$pb.TagNumber(9)
  void clearShippingCosts() => $_clearField(9);
  @$pb.TagNumber(9)
  $2.Money ensureShippingCosts() => $_ensure(8);

  @$pb.TagNumber(10)
  $2.Money get affiliateCommissions => $_getN(9);
  @$pb.TagNumber(10)
  set affiliateCommissions($2.Money value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasAffiliateCommissions() => $_has(9);
  @$pb.TagNumber(10)
  void clearAffiliateCommissions() => $_clearField(10);
  @$pb.TagNumber(10)
  $2.Money ensureAffiliateCommissions() => $_ensure(9);

  @$pb.TagNumber(11)
  $2.Money get refundDeductions => $_getN(10);
  @$pb.TagNumber(11)
  set refundDeductions($2.Money value) => $_setField(11, value);
  @$pb.TagNumber(11)
  $core.bool hasRefundDeductions() => $_has(10);
  @$pb.TagNumber(11)
  void clearRefundDeductions() => $_clearField(11);
  @$pb.TagNumber(11)
  $2.Money ensureRefundDeductions() => $_ensure(10);

  @$pb.TagNumber(12)
  $2.Money get cogs => $_getN(11);
  @$pb.TagNumber(12)
  set cogs($2.Money value) => $_setField(12, value);
  @$pb.TagNumber(12)
  $core.bool hasCogs() => $_has(11);
  @$pb.TagNumber(12)
  void clearCogs() => $_clearField(12);
  @$pb.TagNumber(12)
  $2.Money ensureCogs() => $_ensure(11);

  @$pb.TagNumber(13)
  $2.Money get adsSpend => $_getN(12);
  @$pb.TagNumber(13)
  set adsSpend($2.Money value) => $_setField(13, value);
  @$pb.TagNumber(13)
  $core.bool hasAdsSpend() => $_has(12);
  @$pb.TagNumber(13)
  void clearAdsSpend() => $_clearField(13);
  @$pb.TagNumber(13)
  $2.Money ensureAdsSpend() => $_ensure(12);

  @$pb.TagNumber(14)
  $2.Money get aiCreditCosts => $_getN(13);
  @$pb.TagNumber(14)
  set aiCreditCosts($2.Money value) => $_setField(14, value);
  @$pb.TagNumber(14)
  $core.bool hasAiCreditCosts() => $_has(13);
  @$pb.TagNumber(14)
  void clearAiCreditCosts() => $_clearField(14);
  @$pb.TagNumber(14)
  $2.Money ensureAiCreditCosts() => $_ensure(13);

  @$pb.TagNumber(15)
  $2.Money get seedingCosts => $_getN(14);
  @$pb.TagNumber(15)
  set seedingCosts($2.Money value) => $_setField(15, value);
  @$pb.TagNumber(15)
  $core.bool hasSeedingCosts() => $_has(14);
  @$pb.TagNumber(15)
  void clearSeedingCosts() => $_clearField(15);
  @$pb.TagNumber(15)
  $2.Money ensureSeedingCosts() => $_ensure(14);

  @$pb.TagNumber(16)
  $2.Money get otherCosts => $_getN(15);
  @$pb.TagNumber(16)
  set otherCosts($2.Money value) => $_setField(16, value);
  @$pb.TagNumber(16)
  $core.bool hasOtherCosts() => $_has(15);
  @$pb.TagNumber(16)
  void clearOtherCosts() => $_clearField(16);
  @$pb.TagNumber(16)
  $2.Money ensureOtherCosts() => $_ensure(15);

  @$pb.TagNumber(17)
  $2.Money get netProfit => $_getN(16);
  @$pb.TagNumber(17)
  set netProfit($2.Money value) => $_setField(17, value);
  @$pb.TagNumber(17)
  $core.bool hasNetProfit() => $_has(16);
  @$pb.TagNumber(17)
  void clearNetProfit() => $_clearField(17);
  @$pb.TagNumber(17)
  $2.Money ensureNetProfit() => $_ensure(16);

  @$pb.TagNumber(18)
  $core.String get marginPct => $_getSZ(17);
  @$pb.TagNumber(18)
  set marginPct($core.String value) => $_setString(17, value);
  @$pb.TagNumber(18)
  $core.bool hasMarginPct() => $_has(17);
  @$pb.TagNumber(18)
  void clearMarginPct() => $_clearField(18);

  @$pb.TagNumber(19)
  $core.String get sourceClassMixJson => $_getSZ(18);
  @$pb.TagNumber(19)
  set sourceClassMixJson($core.String value) => $_setString(18, value);
  @$pb.TagNumber(19)
  $core.bool hasSourceClassMixJson() => $_has(18);
  @$pb.TagNumber(19)
  void clearSourceClassMixJson() => $_clearField(19);

  @$pb.TagNumber(20)
  $2.ConfidenceBand get confidence => $_getN(19);
  @$pb.TagNumber(20)
  set confidence($2.ConfidenceBand value) => $_setField(20, value);
  @$pb.TagNumber(20)
  $core.bool hasConfidence() => $_has(19);
  @$pb.TagNumber(20)
  void clearConfidence() => $_clearField(20);

  @$pb.TagNumber(21)
  $1.Timestamp get freshnessAt => $_getN(20);
  @$pb.TagNumber(21)
  set freshnessAt($1.Timestamp value) => $_setField(21, value);
  @$pb.TagNumber(21)
  $core.bool hasFreshnessAt() => $_has(20);
  @$pb.TagNumber(21)
  void clearFreshnessAt() => $_clearField(21);
  @$pb.TagNumber(21)
  $1.Timestamp ensureFreshnessAt() => $_ensure(20);

  @$pb.TagNumber(22)
  $core.String get currency => $_getSZ(21);
  @$pb.TagNumber(22)
  set currency($core.String value) => $_setString(21, value);
  @$pb.TagNumber(22)
  $core.bool hasCurrency() => $_has(21);
  @$pb.TagNumber(22)
  void clearCurrency() => $_clearField(22);

  @$pb.TagNumber(23)
  $1.Timestamp get createdAt => $_getN(22);
  @$pb.TagNumber(23)
  set createdAt($1.Timestamp value) => $_setField(23, value);
  @$pb.TagNumber(23)
  $core.bool hasCreatedAt() => $_has(22);
  @$pb.TagNumber(23)
  void clearCreatedAt() => $_clearField(23);
  @$pb.TagNumber(23)
  $1.Timestamp ensureCreatedAt() => $_ensure(22);

  @$pb.TagNumber(24)
  $core.bool get isIncomplete => $_getBF(23);
  @$pb.TagNumber(24)
  set isIncomplete($core.bool value) => $_setBool(23, value);
  @$pb.TagNumber(24)
  $core.bool hasIsIncomplete() => $_has(23);
  @$pb.TagNumber(24)
  void clearIsIncomplete() => $_clearField(24);

  @$pb.TagNumber(25)
  $core.int get unknownRequiredComponentsCount => $_getIZ(24);
  @$pb.TagNumber(25)
  set unknownRequiredComponentsCount($core.int value) =>
      $_setSignedInt32(24, value);
  @$pb.TagNumber(25)
  $core.bool hasUnknownRequiredComponentsCount() => $_has(24);
  @$pb.TagNumber(25)
  void clearUnknownRequiredComponentsCount() => $_clearField(25);

  @$pb.TagNumber(26)
  $2.Money get pendingRevenue => $_getN(25);
  @$pb.TagNumber(26)
  set pendingRevenue($2.Money value) => $_setField(26, value);
  @$pb.TagNumber(26)
  $core.bool hasPendingRevenue() => $_has(25);
  @$pb.TagNumber(26)
  void clearPendingRevenue() => $_clearField(26);
  @$pb.TagNumber(26)
  $2.Money ensurePendingRevenue() => $_ensure(25);

  @$pb.TagNumber(27)
  $2.Money get unreconciledAmount => $_getN(26);
  @$pb.TagNumber(27)
  set unreconciledAmount($2.Money value) => $_setField(27, value);
  @$pb.TagNumber(27)
  $core.bool hasUnreconciledAmount() => $_has(26);
  @$pb.TagNumber(27)
  void clearUnreconciledAmount() => $_clearField(27);
  @$pb.TagNumber(27)
  $2.Money ensureUnreconciledAmount() => $_ensure(26);

  @$pb.TagNumber(28)
  $core.int get unreconciledCount => $_getIZ(27);
  @$pb.TagNumber(28)
  set unreconciledCount($core.int value) => $_setSignedInt32(27, value);
  @$pb.TagNumber(28)
  $core.bool hasUnreconciledCount() => $_has(27);
  @$pb.TagNumber(28)
  void clearUnreconciledCount() => $_clearField(28);
}

/// Anomaly alert detected in profit/cost stream (§2.7.1).
class ProfitAnomaly extends $pb.GeneratedMessage {
  factory ProfitAnomaly({
    $core.String? anomalyId,
    $core.String? workspaceId,
    $core.String? anomalyType,
    $core.String? severity,
    $core.String? description,
    $2.Money? expectedAmount,
    $2.Money? actualAmount,
    $1.Timestamp? detectedAt,
  }) {
    final result = ProfitAnomaly._();
    if (anomalyId != null) result.anomalyId = anomalyId;
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (anomalyType != null) result.anomalyType = anomalyType;
    if (severity != null) result.severity = severity;
    if (description != null) result.description = description;
    if (expectedAmount != null) result.expectedAmount = expectedAmount;
    if (actualAmount != null) result.actualAmount = actualAmount;
    if (detectedAt != null) result.detectedAt = detectedAt;
    return result;
  }

  ProfitAnomaly._();

  factory ProfitAnomaly.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ProfitAnomaly()..mergeFromBuffer(data, registry);
  factory ProfitAnomaly.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ProfitAnomaly()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ProfitAnomaly',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.finance.v1'),
      createEmptyInstance: ProfitAnomaly.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'anomalyId')
    ..aOS(2, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(3, _omitFieldNames ? '' : 'anomalyType')
    ..aOS(4, _omitFieldNames ? '' : 'severity')
    ..aOS(5, _omitFieldNames ? '' : 'description')
    ..aOM<$2.Money>(6, _omitFieldNames ? '' : 'expectedAmount',
        subBuilder: $2.Money.$_createMessage)
    ..aOM<$2.Money>(7, _omitFieldNames ? '' : 'actualAmount',
        subBuilder: $2.Money.$_createMessage)
    ..aOM<$1.Timestamp>(8, _omitFieldNames ? '' : 'detectedAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ProfitAnomaly clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ProfitAnomaly copyWith(void Function(ProfitAnomaly) updates) =>
      super.copyWith((message) => updates(message as ProfitAnomaly))
          as ProfitAnomaly;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ProfitAnomaly() / ProfitAnomaly.new instead')
  static ProfitAnomaly create() => ProfitAnomaly._();
  static $pb.GeneratedMessage $_createMessage() => ProfitAnomaly._();
  @$core.override
  ProfitAnomaly createEmptyInstance() => ProfitAnomaly._();
  @$core.pragma('dart2js:noInline')
  static ProfitAnomaly getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ProfitAnomaly>(
          ProfitAnomaly.$_createMessage);
  static ProfitAnomaly? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get anomalyId => $_getSZ(0);
  @$pb.TagNumber(1)
  set anomalyId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAnomalyId() => $_has(0);
  @$pb.TagNumber(1)
  void clearAnomalyId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get workspaceId => $_getSZ(1);
  @$pb.TagNumber(2)
  set workspaceId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasWorkspaceId() => $_has(1);
  @$pb.TagNumber(2)
  void clearWorkspaceId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get anomalyType => $_getSZ(2);
  @$pb.TagNumber(3)
  set anomalyType($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasAnomalyType() => $_has(2);
  @$pb.TagNumber(3)
  void clearAnomalyType() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get severity => $_getSZ(3);
  @$pb.TagNumber(4)
  set severity($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasSeverity() => $_has(3);
  @$pb.TagNumber(4)
  void clearSeverity() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get description => $_getSZ(4);
  @$pb.TagNumber(5)
  set description($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasDescription() => $_has(4);
  @$pb.TagNumber(5)
  void clearDescription() => $_clearField(5);

  @$pb.TagNumber(6)
  $2.Money get expectedAmount => $_getN(5);
  @$pb.TagNumber(6)
  set expectedAmount($2.Money value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasExpectedAmount() => $_has(5);
  @$pb.TagNumber(6)
  void clearExpectedAmount() => $_clearField(6);
  @$pb.TagNumber(6)
  $2.Money ensureExpectedAmount() => $_ensure(5);

  @$pb.TagNumber(7)
  $2.Money get actualAmount => $_getN(6);
  @$pb.TagNumber(7)
  set actualAmount($2.Money value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasActualAmount() => $_has(6);
  @$pb.TagNumber(7)
  void clearActualAmount() => $_clearField(7);
  @$pb.TagNumber(7)
  $2.Money ensureActualAmount() => $_ensure(6);

  @$pb.TagNumber(8)
  $1.Timestamp get detectedAt => $_getN(7);
  @$pb.TagNumber(8)
  set detectedAt($1.Timestamp value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasDetectedAt() => $_has(7);
  @$pb.TagNumber(8)
  void clearDetectedAt() => $_clearField(8);
  @$pb.TagNumber(8)
  $1.Timestamp ensureDetectedAt() => $_ensure(7);
}

/// Canonical reconciliation record per DB Schema §19.9E.
class ReconciliationRecord extends $pb.GeneratedMessage {
  factory ReconciliationRecord({
    $core.String? recordId,
    $core.String? workspaceId,
    $core.String? scopeType,
    $core.String? scopeDescription,
    $core.Iterable<$core.String>? relatedOrderIds,
    $core.Iterable<$core.String>? relatedSettlementIds,
    $2.Money? matchedAmount,
    $2.Money? discrepancyAmount,
    $core.String? discrepancyReason,
    ReconciliationState? reconciliationState,
    $core.String? currency,
    $core.String? mismatchesJson,
    $core.String? overrideReason,
    $core.String? overrideBy,
    $1.Timestamp? overrideAt,
    $core.String? periodStart,
    $core.String? periodEnd,
    $1.Timestamp? createdAt,
    $1.Timestamp? updatedAt,
  }) {
    final result = ReconciliationRecord._();
    if (recordId != null) result.recordId = recordId;
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (scopeType != null) result.scopeType = scopeType;
    if (scopeDescription != null) result.scopeDescription = scopeDescription;
    if (relatedOrderIds != null) result.relatedOrderIds.addAll(relatedOrderIds);
    if (relatedSettlementIds != null)
      result.relatedSettlementIds.addAll(relatedSettlementIds);
    if (matchedAmount != null) result.matchedAmount = matchedAmount;
    if (discrepancyAmount != null) result.discrepancyAmount = discrepancyAmount;
    if (discrepancyReason != null) result.discrepancyReason = discrepancyReason;
    if (reconciliationState != null)
      result.reconciliationState = reconciliationState;
    if (currency != null) result.currency = currency;
    if (mismatchesJson != null) result.mismatchesJson = mismatchesJson;
    if (overrideReason != null) result.overrideReason = overrideReason;
    if (overrideBy != null) result.overrideBy = overrideBy;
    if (overrideAt != null) result.overrideAt = overrideAt;
    if (periodStart != null) result.periodStart = periodStart;
    if (periodEnd != null) result.periodEnd = periodEnd;
    if (createdAt != null) result.createdAt = createdAt;
    if (updatedAt != null) result.updatedAt = updatedAt;
    return result;
  }

  ReconciliationRecord._();

  factory ReconciliationRecord.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ReconciliationRecord()..mergeFromBuffer(data, registry);
  factory ReconciliationRecord.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ReconciliationRecord()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ReconciliationRecord',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.finance.v1'),
      createEmptyInstance: ReconciliationRecord.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'recordId')
    ..aOS(2, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(3, _omitFieldNames ? '' : 'scopeType')
    ..aOS(4, _omitFieldNames ? '' : 'scopeDescription')
    ..pPS(5, _omitFieldNames ? '' : 'relatedOrderIds')
    ..pPS(6, _omitFieldNames ? '' : 'relatedSettlementIds')
    ..aOM<$2.Money>(7, _omitFieldNames ? '' : 'matchedAmount',
        subBuilder: $2.Money.$_createMessage)
    ..aOM<$2.Money>(8, _omitFieldNames ? '' : 'discrepancyAmount',
        subBuilder: $2.Money.$_createMessage)
    ..aOS(9, _omitFieldNames ? '' : 'discrepancyReason')
    ..aE<ReconciliationState>(10, _omitFieldNames ? '' : 'reconciliationState',
        enumValues: ReconciliationState.values)
    ..aOS(11, _omitFieldNames ? '' : 'currency')
    ..aOS(12, _omitFieldNames ? '' : 'mismatchesJson')
    ..aOS(13, _omitFieldNames ? '' : 'overrideReason')
    ..aOS(14, _omitFieldNames ? '' : 'overrideBy')
    ..aOM<$1.Timestamp>(15, _omitFieldNames ? '' : 'overrideAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..aOS(16, _omitFieldNames ? '' : 'periodStart')
    ..aOS(17, _omitFieldNames ? '' : 'periodEnd')
    ..aOM<$1.Timestamp>(18, _omitFieldNames ? '' : 'createdAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..aOM<$1.Timestamp>(19, _omitFieldNames ? '' : 'updatedAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReconciliationRecord clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReconciliationRecord copyWith(void Function(ReconciliationRecord) updates) =>
      super.copyWith((message) => updates(message as ReconciliationRecord))
          as ReconciliationRecord;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ReconciliationRecord() / ReconciliationRecord.new instead')
  static ReconciliationRecord create() => ReconciliationRecord._();
  static $pb.GeneratedMessage $_createMessage() => ReconciliationRecord._();
  @$core.override
  ReconciliationRecord createEmptyInstance() => ReconciliationRecord._();
  @$core.pragma('dart2js:noInline')
  static ReconciliationRecord getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ReconciliationRecord>(
          ReconciliationRecord.$_createMessage);
  static ReconciliationRecord? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get recordId => $_getSZ(0);
  @$pb.TagNumber(1)
  set recordId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRecordId() => $_has(0);
  @$pb.TagNumber(1)
  void clearRecordId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get workspaceId => $_getSZ(1);
  @$pb.TagNumber(2)
  set workspaceId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasWorkspaceId() => $_has(1);
  @$pb.TagNumber(2)
  void clearWorkspaceId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get scopeType => $_getSZ(2);
  @$pb.TagNumber(3)
  set scopeType($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasScopeType() => $_has(2);
  @$pb.TagNumber(3)
  void clearScopeType() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get scopeDescription => $_getSZ(3);
  @$pb.TagNumber(4)
  set scopeDescription($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasScopeDescription() => $_has(3);
  @$pb.TagNumber(4)
  void clearScopeDescription() => $_clearField(4);

  @$pb.TagNumber(5)
  $pb.PbList<$core.String> get relatedOrderIds => $_getList(4);

  @$pb.TagNumber(6)
  $pb.PbList<$core.String> get relatedSettlementIds => $_getList(5);

  @$pb.TagNumber(7)
  $2.Money get matchedAmount => $_getN(6);
  @$pb.TagNumber(7)
  set matchedAmount($2.Money value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasMatchedAmount() => $_has(6);
  @$pb.TagNumber(7)
  void clearMatchedAmount() => $_clearField(7);
  @$pb.TagNumber(7)
  $2.Money ensureMatchedAmount() => $_ensure(6);

  @$pb.TagNumber(8)
  $2.Money get discrepancyAmount => $_getN(7);
  @$pb.TagNumber(8)
  set discrepancyAmount($2.Money value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasDiscrepancyAmount() => $_has(7);
  @$pb.TagNumber(8)
  void clearDiscrepancyAmount() => $_clearField(8);
  @$pb.TagNumber(8)
  $2.Money ensureDiscrepancyAmount() => $_ensure(7);

  @$pb.TagNumber(9)
  $core.String get discrepancyReason => $_getSZ(8);
  @$pb.TagNumber(9)
  set discrepancyReason($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasDiscrepancyReason() => $_has(8);
  @$pb.TagNumber(9)
  void clearDiscrepancyReason() => $_clearField(9);

  @$pb.TagNumber(10)
  ReconciliationState get reconciliationState => $_getN(9);
  @$pb.TagNumber(10)
  set reconciliationState(ReconciliationState value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasReconciliationState() => $_has(9);
  @$pb.TagNumber(10)
  void clearReconciliationState() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.String get currency => $_getSZ(10);
  @$pb.TagNumber(11)
  set currency($core.String value) => $_setString(10, value);
  @$pb.TagNumber(11)
  $core.bool hasCurrency() => $_has(10);
  @$pb.TagNumber(11)
  void clearCurrency() => $_clearField(11);

  @$pb.TagNumber(12)
  $core.String get mismatchesJson => $_getSZ(11);
  @$pb.TagNumber(12)
  set mismatchesJson($core.String value) => $_setString(11, value);
  @$pb.TagNumber(12)
  $core.bool hasMismatchesJson() => $_has(11);
  @$pb.TagNumber(12)
  void clearMismatchesJson() => $_clearField(12);

  @$pb.TagNumber(13)
  $core.String get overrideReason => $_getSZ(12);
  @$pb.TagNumber(13)
  set overrideReason($core.String value) => $_setString(12, value);
  @$pb.TagNumber(13)
  $core.bool hasOverrideReason() => $_has(12);
  @$pb.TagNumber(13)
  void clearOverrideReason() => $_clearField(13);

  @$pb.TagNumber(14)
  $core.String get overrideBy => $_getSZ(13);
  @$pb.TagNumber(14)
  set overrideBy($core.String value) => $_setString(13, value);
  @$pb.TagNumber(14)
  $core.bool hasOverrideBy() => $_has(13);
  @$pb.TagNumber(14)
  void clearOverrideBy() => $_clearField(14);

  @$pb.TagNumber(15)
  $1.Timestamp get overrideAt => $_getN(14);
  @$pb.TagNumber(15)
  set overrideAt($1.Timestamp value) => $_setField(15, value);
  @$pb.TagNumber(15)
  $core.bool hasOverrideAt() => $_has(14);
  @$pb.TagNumber(15)
  void clearOverrideAt() => $_clearField(15);
  @$pb.TagNumber(15)
  $1.Timestamp ensureOverrideAt() => $_ensure(14);

  @$pb.TagNumber(16)
  $core.String get periodStart => $_getSZ(15);
  @$pb.TagNumber(16)
  set periodStart($core.String value) => $_setString(15, value);
  @$pb.TagNumber(16)
  $core.bool hasPeriodStart() => $_has(15);
  @$pb.TagNumber(16)
  void clearPeriodStart() => $_clearField(16);

  @$pb.TagNumber(17)
  $core.String get periodEnd => $_getSZ(16);
  @$pb.TagNumber(17)
  set periodEnd($core.String value) => $_setString(16, value);
  @$pb.TagNumber(17)
  $core.bool hasPeriodEnd() => $_has(16);
  @$pb.TagNumber(17)
  void clearPeriodEnd() => $_clearField(17);

  @$pb.TagNumber(18)
  $1.Timestamp get createdAt => $_getN(17);
  @$pb.TagNumber(18)
  set createdAt($1.Timestamp value) => $_setField(18, value);
  @$pb.TagNumber(18)
  $core.bool hasCreatedAt() => $_has(17);
  @$pb.TagNumber(18)
  void clearCreatedAt() => $_clearField(18);
  @$pb.TagNumber(18)
  $1.Timestamp ensureCreatedAt() => $_ensure(17);

  @$pb.TagNumber(19)
  $1.Timestamp get updatedAt => $_getN(18);
  @$pb.TagNumber(19)
  set updatedAt($1.Timestamp value) => $_setField(19, value);
  @$pb.TagNumber(19)
  $core.bool hasUpdatedAt() => $_has(18);
  @$pb.TagNumber(19)
  void clearUpdatedAt() => $_clearField(19);
  @$pb.TagNumber(19)
  $1.Timestamp ensureUpdatedAt() => $_ensure(18);
}

/// Partial match allocation linking a settlement line to an order (§4 capacity contract).
class ReconciliationMatch extends $pb.GeneratedMessage {
  factory ReconciliationMatch({
    $core.String? matchId,
    $core.String? workspaceId,
    $core.String? recordId,
    $core.String? settlementId,
    $core.String? lineId,
    $core.String? orderId,
    $2.Money? allocatedAmount,
    $core.String? currency,
    $1.Timestamp? createdAt,
  }) {
    final result = ReconciliationMatch._();
    if (matchId != null) result.matchId = matchId;
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (recordId != null) result.recordId = recordId;
    if (settlementId != null) result.settlementId = settlementId;
    if (lineId != null) result.lineId = lineId;
    if (orderId != null) result.orderId = orderId;
    if (allocatedAmount != null) result.allocatedAmount = allocatedAmount;
    if (currency != null) result.currency = currency;
    if (createdAt != null) result.createdAt = createdAt;
    return result;
  }

  ReconciliationMatch._();

  factory ReconciliationMatch.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ReconciliationMatch()..mergeFromBuffer(data, registry);
  factory ReconciliationMatch.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ReconciliationMatch()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ReconciliationMatch',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.finance.v1'),
      createEmptyInstance: ReconciliationMatch.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'matchId')
    ..aOS(2, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(3, _omitFieldNames ? '' : 'recordId')
    ..aOS(4, _omitFieldNames ? '' : 'settlementId')
    ..aOS(5, _omitFieldNames ? '' : 'lineId')
    ..aOS(6, _omitFieldNames ? '' : 'orderId')
    ..aOM<$2.Money>(7, _omitFieldNames ? '' : 'allocatedAmount',
        subBuilder: $2.Money.$_createMessage)
    ..aOS(8, _omitFieldNames ? '' : 'currency')
    ..aOM<$1.Timestamp>(9, _omitFieldNames ? '' : 'createdAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReconciliationMatch clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReconciliationMatch copyWith(void Function(ReconciliationMatch) updates) =>
      super.copyWith((message) => updates(message as ReconciliationMatch))
          as ReconciliationMatch;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core
      .Deprecated('Use ReconciliationMatch() / ReconciliationMatch.new instead')
  static ReconciliationMatch create() => ReconciliationMatch._();
  static $pb.GeneratedMessage $_createMessage() => ReconciliationMatch._();
  @$core.override
  ReconciliationMatch createEmptyInstance() => ReconciliationMatch._();
  @$core.pragma('dart2js:noInline')
  static ReconciliationMatch getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ReconciliationMatch>(
          ReconciliationMatch.$_createMessage);
  static ReconciliationMatch? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get matchId => $_getSZ(0);
  @$pb.TagNumber(1)
  set matchId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasMatchId() => $_has(0);
  @$pb.TagNumber(1)
  void clearMatchId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get workspaceId => $_getSZ(1);
  @$pb.TagNumber(2)
  set workspaceId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasWorkspaceId() => $_has(1);
  @$pb.TagNumber(2)
  void clearWorkspaceId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get recordId => $_getSZ(2);
  @$pb.TagNumber(3)
  set recordId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasRecordId() => $_has(2);
  @$pb.TagNumber(3)
  void clearRecordId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get settlementId => $_getSZ(3);
  @$pb.TagNumber(4)
  set settlementId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasSettlementId() => $_has(3);
  @$pb.TagNumber(4)
  void clearSettlementId() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get lineId => $_getSZ(4);
  @$pb.TagNumber(5)
  set lineId($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasLineId() => $_has(4);
  @$pb.TagNumber(5)
  void clearLineId() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get orderId => $_getSZ(5);
  @$pb.TagNumber(6)
  set orderId($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasOrderId() => $_has(5);
  @$pb.TagNumber(6)
  void clearOrderId() => $_clearField(6);

  @$pb.TagNumber(7)
  $2.Money get allocatedAmount => $_getN(6);
  @$pb.TagNumber(7)
  set allocatedAmount($2.Money value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasAllocatedAmount() => $_has(6);
  @$pb.TagNumber(7)
  void clearAllocatedAmount() => $_clearField(7);
  @$pb.TagNumber(7)
  $2.Money ensureAllocatedAmount() => $_ensure(6);

  @$pb.TagNumber(8)
  $core.String get currency => $_getSZ(7);
  @$pb.TagNumber(8)
  set currency($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasCurrency() => $_has(7);
  @$pb.TagNumber(8)
  void clearCurrency() => $_clearField(8);

  @$pb.TagNumber(9)
  $1.Timestamp get createdAt => $_getN(8);
  @$pb.TagNumber(9)
  set createdAt($1.Timestamp value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasCreatedAt() => $_has(8);
  @$pb.TagNumber(9)
  void clearCreatedAt() => $_clearField(9);
  @$pb.TagNumber(9)
  $1.Timestamp ensureCreatedAt() => $_ensure(8);
}

/// Immutable evidence object with content_hash (SHA-512) per DB Schema §11.4 & RULE-M19-005.
class EvidenceObject extends $pb.GeneratedMessage {
  factory EvidenceObject({
    $core.String? evidenceId,
    $core.String? workspaceId,
    $core.String? evidenceType,
    $core.String? sourceProvenance,
    $core.String? contentHash,
    $core.String? fileUrl,
    $core.String? payloadJson,
    $1.Timestamp? collectedAt,
    VerificationStatus? verificationStatus,
    $core.Iterable<ObjectRef>? relatedObjectRefs,
    $1.Timestamp? createdAt,
  }) {
    final result = EvidenceObject._();
    if (evidenceId != null) result.evidenceId = evidenceId;
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (evidenceType != null) result.evidenceType = evidenceType;
    if (sourceProvenance != null) result.sourceProvenance = sourceProvenance;
    if (contentHash != null) result.contentHash = contentHash;
    if (fileUrl != null) result.fileUrl = fileUrl;
    if (payloadJson != null) result.payloadJson = payloadJson;
    if (collectedAt != null) result.collectedAt = collectedAt;
    if (verificationStatus != null)
      result.verificationStatus = verificationStatus;
    if (relatedObjectRefs != null)
      result.relatedObjectRefs.addAll(relatedObjectRefs);
    if (createdAt != null) result.createdAt = createdAt;
    return result;
  }

  EvidenceObject._();

  factory EvidenceObject.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      EvidenceObject()..mergeFromBuffer(data, registry);
  factory EvidenceObject.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      EvidenceObject()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'EvidenceObject',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.finance.v1'),
      createEmptyInstance: EvidenceObject.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'evidenceId')
    ..aOS(2, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(3, _omitFieldNames ? '' : 'evidenceType')
    ..aOS(4, _omitFieldNames ? '' : 'sourceProvenance')
    ..aOS(5, _omitFieldNames ? '' : 'contentHash')
    ..aOS(6, _omitFieldNames ? '' : 'fileUrl')
    ..aOS(7, _omitFieldNames ? '' : 'payloadJson')
    ..aOM<$1.Timestamp>(8, _omitFieldNames ? '' : 'collectedAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..aE<VerificationStatus>(9, _omitFieldNames ? '' : 'verificationStatus',
        enumValues: VerificationStatus.values)
    ..pPM<ObjectRef>(10, _omitFieldNames ? '' : 'relatedObjectRefs',
        subBuilder: ObjectRef.$_createMessage)
    ..aOM<$1.Timestamp>(11, _omitFieldNames ? '' : 'createdAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EvidenceObject clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EvidenceObject copyWith(void Function(EvidenceObject) updates) =>
      super.copyWith((message) => updates(message as EvidenceObject))
          as EvidenceObject;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use EvidenceObject() / EvidenceObject.new instead')
  static EvidenceObject create() => EvidenceObject._();
  static $pb.GeneratedMessage $_createMessage() => EvidenceObject._();
  @$core.override
  EvidenceObject createEmptyInstance() => EvidenceObject._();
  @$core.pragma('dart2js:noInline')
  static EvidenceObject getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<EvidenceObject>(
          EvidenceObject.$_createMessage);
  static EvidenceObject? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get evidenceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set evidenceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasEvidenceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearEvidenceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get workspaceId => $_getSZ(1);
  @$pb.TagNumber(2)
  set workspaceId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasWorkspaceId() => $_has(1);
  @$pb.TagNumber(2)
  void clearWorkspaceId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get evidenceType => $_getSZ(2);
  @$pb.TagNumber(3)
  set evidenceType($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasEvidenceType() => $_has(2);
  @$pb.TagNumber(3)
  void clearEvidenceType() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get sourceProvenance => $_getSZ(3);
  @$pb.TagNumber(4)
  set sourceProvenance($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasSourceProvenance() => $_has(3);
  @$pb.TagNumber(4)
  void clearSourceProvenance() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get contentHash => $_getSZ(4);
  @$pb.TagNumber(5)
  set contentHash($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasContentHash() => $_has(4);
  @$pb.TagNumber(5)
  void clearContentHash() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get fileUrl => $_getSZ(5);
  @$pb.TagNumber(6)
  set fileUrl($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasFileUrl() => $_has(5);
  @$pb.TagNumber(6)
  void clearFileUrl() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get payloadJson => $_getSZ(6);
  @$pb.TagNumber(7)
  set payloadJson($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasPayloadJson() => $_has(6);
  @$pb.TagNumber(7)
  void clearPayloadJson() => $_clearField(7);

  @$pb.TagNumber(8)
  $1.Timestamp get collectedAt => $_getN(7);
  @$pb.TagNumber(8)
  set collectedAt($1.Timestamp value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasCollectedAt() => $_has(7);
  @$pb.TagNumber(8)
  void clearCollectedAt() => $_clearField(8);
  @$pb.TagNumber(8)
  $1.Timestamp ensureCollectedAt() => $_ensure(7);

  @$pb.TagNumber(9)
  VerificationStatus get verificationStatus => $_getN(8);
  @$pb.TagNumber(9)
  set verificationStatus(VerificationStatus value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasVerificationStatus() => $_has(8);
  @$pb.TagNumber(9)
  void clearVerificationStatus() => $_clearField(9);

  @$pb.TagNumber(10)
  $pb.PbList<ObjectRef> get relatedObjectRefs => $_getList(9);

  @$pb.TagNumber(11)
  $1.Timestamp get createdAt => $_getN(10);
  @$pb.TagNumber(11)
  set createdAt($1.Timestamp value) => $_setField(11, value);
  @$pb.TagNumber(11)
  $core.bool hasCreatedAt() => $_has(10);
  @$pb.TagNumber(11)
  void clearCreatedAt() => $_clearField(11);
  @$pb.TagNumber(11)
  $1.Timestamp ensureCreatedAt() => $_ensure(10);
}

/// Proof bundle assembling claims and evidence per DB Schema §11.5 & RULE-M19-006.
class ProofBundle extends $pb.GeneratedMessage {
  factory ProofBundle({
    $core.String? proofBundleId,
    $core.String? workspaceId,
    $core.String? claimScope,
    $core.String? claimSummary,
    $core.Iterable<$core.String>? supportingEvidenceIds,
    $core.String? sourceClassContextJson,
    $2.ConfidenceBand? confidence,
    $core.String? coverageSummary,
    $core.String? unresolvedGaps,
    $1.Timestamp? createdAt,
    $1.Timestamp? updatedAt,
  }) {
    final result = ProofBundle._();
    if (proofBundleId != null) result.proofBundleId = proofBundleId;
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (claimScope != null) result.claimScope = claimScope;
    if (claimSummary != null) result.claimSummary = claimSummary;
    if (supportingEvidenceIds != null)
      result.supportingEvidenceIds.addAll(supportingEvidenceIds);
    if (sourceClassContextJson != null)
      result.sourceClassContextJson = sourceClassContextJson;
    if (confidence != null) result.confidence = confidence;
    if (coverageSummary != null) result.coverageSummary = coverageSummary;
    if (unresolvedGaps != null) result.unresolvedGaps = unresolvedGaps;
    if (createdAt != null) result.createdAt = createdAt;
    if (updatedAt != null) result.updatedAt = updatedAt;
    return result;
  }

  ProofBundle._();

  factory ProofBundle.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ProofBundle()..mergeFromBuffer(data, registry);
  factory ProofBundle.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ProofBundle()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ProofBundle',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.finance.v1'),
      createEmptyInstance: ProofBundle.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'proofBundleId')
    ..aOS(2, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(3, _omitFieldNames ? '' : 'claimScope')
    ..aOS(4, _omitFieldNames ? '' : 'claimSummary')
    ..pPS(5, _omitFieldNames ? '' : 'supportingEvidenceIds')
    ..aOS(6, _omitFieldNames ? '' : 'sourceClassContextJson')
    ..aE<$2.ConfidenceBand>(7, _omitFieldNames ? '' : 'confidence',
        enumValues: $2.ConfidenceBand.values)
    ..aOS(8, _omitFieldNames ? '' : 'coverageSummary')
    ..aOS(9, _omitFieldNames ? '' : 'unresolvedGaps')
    ..aOM<$1.Timestamp>(10, _omitFieldNames ? '' : 'createdAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..aOM<$1.Timestamp>(11, _omitFieldNames ? '' : 'updatedAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ProofBundle clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ProofBundle copyWith(void Function(ProofBundle) updates) =>
      super.copyWith((message) => updates(message as ProofBundle))
          as ProofBundle;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ProofBundle() / ProofBundle.new instead')
  static ProofBundle create() => ProofBundle._();
  static $pb.GeneratedMessage $_createMessage() => ProofBundle._();
  @$core.override
  ProofBundle createEmptyInstance() => ProofBundle._();
  @$core.pragma('dart2js:noInline')
  static ProofBundle getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ProofBundle>(
          ProofBundle.$_createMessage);
  static ProofBundle? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get proofBundleId => $_getSZ(0);
  @$pb.TagNumber(1)
  set proofBundleId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasProofBundleId() => $_has(0);
  @$pb.TagNumber(1)
  void clearProofBundleId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get workspaceId => $_getSZ(1);
  @$pb.TagNumber(2)
  set workspaceId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasWorkspaceId() => $_has(1);
  @$pb.TagNumber(2)
  void clearWorkspaceId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get claimScope => $_getSZ(2);
  @$pb.TagNumber(3)
  set claimScope($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasClaimScope() => $_has(2);
  @$pb.TagNumber(3)
  void clearClaimScope() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get claimSummary => $_getSZ(3);
  @$pb.TagNumber(4)
  set claimSummary($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasClaimSummary() => $_has(3);
  @$pb.TagNumber(4)
  void clearClaimSummary() => $_clearField(4);

  @$pb.TagNumber(5)
  $pb.PbList<$core.String> get supportingEvidenceIds => $_getList(4);

  @$pb.TagNumber(6)
  $core.String get sourceClassContextJson => $_getSZ(5);
  @$pb.TagNumber(6)
  set sourceClassContextJson($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasSourceClassContextJson() => $_has(5);
  @$pb.TagNumber(6)
  void clearSourceClassContextJson() => $_clearField(6);

  @$pb.TagNumber(7)
  $2.ConfidenceBand get confidence => $_getN(6);
  @$pb.TagNumber(7)
  set confidence($2.ConfidenceBand value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasConfidence() => $_has(6);
  @$pb.TagNumber(7)
  void clearConfidence() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get coverageSummary => $_getSZ(7);
  @$pb.TagNumber(8)
  set coverageSummary($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasCoverageSummary() => $_has(7);
  @$pb.TagNumber(8)
  void clearCoverageSummary() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get unresolvedGaps => $_getSZ(8);
  @$pb.TagNumber(9)
  set unresolvedGaps($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasUnresolvedGaps() => $_has(8);
  @$pb.TagNumber(9)
  void clearUnresolvedGaps() => $_clearField(9);

  @$pb.TagNumber(10)
  $1.Timestamp get createdAt => $_getN(9);
  @$pb.TagNumber(10)
  set createdAt($1.Timestamp value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasCreatedAt() => $_has(9);
  @$pb.TagNumber(10)
  void clearCreatedAt() => $_clearField(10);
  @$pb.TagNumber(10)
  $1.Timestamp ensureCreatedAt() => $_ensure(9);

  @$pb.TagNumber(11)
  $1.Timestamp get updatedAt => $_getN(10);
  @$pb.TagNumber(11)
  set updatedAt($1.Timestamp value) => $_setField(11, value);
  @$pb.TagNumber(11)
  $core.bool hasUpdatedAt() => $_has(10);
  @$pb.TagNumber(11)
  void clearUpdatedAt() => $_clearField(11);
  @$pb.TagNumber(11)
  $1.Timestamp ensureUpdatedAt() => $_ensure(10);
}

/// Permission-filtered data gap item in the repair queue (RULE-M19-001, M01).
class DataGapItem extends $pb.GeneratedMessage {
  factory DataGapItem({
    $core.String? gapId,
    $core.String? gapType,
    $core.String? severity,
    $core.String? title,
    $core.String? description,
    $core.String? relatedObjectType,
    $core.String? relatedObjectId,
    $2.Money? monetaryAmount,
    $1.Timestamp? unresolvedSince,
    $core.String? repairCtaLabel,
    $core.String? repairCtaRoute,
    $core.String? requiredPermission,
  }) {
    final result = DataGapItem._();
    if (gapId != null) result.gapId = gapId;
    if (gapType != null) result.gapType = gapType;
    if (severity != null) result.severity = severity;
    if (title != null) result.title = title;
    if (description != null) result.description = description;
    if (relatedObjectType != null) result.relatedObjectType = relatedObjectType;
    if (relatedObjectId != null) result.relatedObjectId = relatedObjectId;
    if (monetaryAmount != null) result.monetaryAmount = monetaryAmount;
    if (unresolvedSince != null) result.unresolvedSince = unresolvedSince;
    if (repairCtaLabel != null) result.repairCtaLabel = repairCtaLabel;
    if (repairCtaRoute != null) result.repairCtaRoute = repairCtaRoute;
    if (requiredPermission != null)
      result.requiredPermission = requiredPermission;
    return result;
  }

  DataGapItem._();

  factory DataGapItem.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      DataGapItem()..mergeFromBuffer(data, registry);
  factory DataGapItem.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      DataGapItem()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DataGapItem',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.finance.v1'),
      createEmptyInstance: DataGapItem.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'gapId')
    ..aOS(2, _omitFieldNames ? '' : 'gapType')
    ..aOS(3, _omitFieldNames ? '' : 'severity')
    ..aOS(4, _omitFieldNames ? '' : 'title')
    ..aOS(5, _omitFieldNames ? '' : 'description')
    ..aOS(6, _omitFieldNames ? '' : 'relatedObjectType')
    ..aOS(7, _omitFieldNames ? '' : 'relatedObjectId')
    ..aOM<$2.Money>(8, _omitFieldNames ? '' : 'monetaryAmount',
        subBuilder: $2.Money.$_createMessage)
    ..aOM<$1.Timestamp>(9, _omitFieldNames ? '' : 'unresolvedSince',
        subBuilder: $1.Timestamp.$_createMessage)
    ..aOS(10, _omitFieldNames ? '' : 'repairCtaLabel')
    ..aOS(11, _omitFieldNames ? '' : 'repairCtaRoute')
    ..aOS(12, _omitFieldNames ? '' : 'requiredPermission')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DataGapItem clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DataGapItem copyWith(void Function(DataGapItem) updates) =>
      super.copyWith((message) => updates(message as DataGapItem))
          as DataGapItem;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use DataGapItem() / DataGapItem.new instead')
  static DataGapItem create() => DataGapItem._();
  static $pb.GeneratedMessage $_createMessage() => DataGapItem._();
  @$core.override
  DataGapItem createEmptyInstance() => DataGapItem._();
  @$core.pragma('dart2js:noInline')
  static DataGapItem getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DataGapItem>(
          DataGapItem.$_createMessage);
  static DataGapItem? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get gapId => $_getSZ(0);
  @$pb.TagNumber(1)
  set gapId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasGapId() => $_has(0);
  @$pb.TagNumber(1)
  void clearGapId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get gapType => $_getSZ(1);
  @$pb.TagNumber(2)
  set gapType($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasGapType() => $_has(1);
  @$pb.TagNumber(2)
  void clearGapType() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get severity => $_getSZ(2);
  @$pb.TagNumber(3)
  set severity($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasSeverity() => $_has(2);
  @$pb.TagNumber(3)
  void clearSeverity() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get title => $_getSZ(3);
  @$pb.TagNumber(4)
  set title($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasTitle() => $_has(3);
  @$pb.TagNumber(4)
  void clearTitle() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get description => $_getSZ(4);
  @$pb.TagNumber(5)
  set description($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasDescription() => $_has(4);
  @$pb.TagNumber(5)
  void clearDescription() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get relatedObjectType => $_getSZ(5);
  @$pb.TagNumber(6)
  set relatedObjectType($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasRelatedObjectType() => $_has(5);
  @$pb.TagNumber(6)
  void clearRelatedObjectType() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get relatedObjectId => $_getSZ(6);
  @$pb.TagNumber(7)
  set relatedObjectId($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasRelatedObjectId() => $_has(6);
  @$pb.TagNumber(7)
  void clearRelatedObjectId() => $_clearField(7);

  @$pb.TagNumber(8)
  $2.Money get monetaryAmount => $_getN(7);
  @$pb.TagNumber(8)
  set monetaryAmount($2.Money value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasMonetaryAmount() => $_has(7);
  @$pb.TagNumber(8)
  void clearMonetaryAmount() => $_clearField(8);
  @$pb.TagNumber(8)
  $2.Money ensureMonetaryAmount() => $_ensure(7);

  @$pb.TagNumber(9)
  $1.Timestamp get unresolvedSince => $_getN(8);
  @$pb.TagNumber(9)
  set unresolvedSince($1.Timestamp value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasUnresolvedSince() => $_has(8);
  @$pb.TagNumber(9)
  void clearUnresolvedSince() => $_clearField(9);
  @$pb.TagNumber(9)
  $1.Timestamp ensureUnresolvedSince() => $_ensure(8);

  @$pb.TagNumber(10)
  $core.String get repairCtaLabel => $_getSZ(9);
  @$pb.TagNumber(10)
  set repairCtaLabel($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasRepairCtaLabel() => $_has(9);
  @$pb.TagNumber(10)
  void clearRepairCtaLabel() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.String get repairCtaRoute => $_getSZ(10);
  @$pb.TagNumber(11)
  set repairCtaRoute($core.String value) => $_setString(10, value);
  @$pb.TagNumber(11)
  $core.bool hasRepairCtaRoute() => $_has(10);
  @$pb.TagNumber(11)
  void clearRepairCtaRoute() => $_clearField(11);

  @$pb.TagNumber(12)
  $core.String get requiredPermission => $_getSZ(11);
  @$pb.TagNumber(12)
  set requiredPermission($core.String value) => $_setString(11, value);
  @$pb.TagNumber(12)
  $core.bool hasRequiredPermission() => $_has(11);
  @$pb.TagNumber(12)
  void clearRequiredPermission() => $_clearField(12);
}

/// ProfitService/GetSummary
class ProfitServiceGetSummaryRequest extends $pb.GeneratedMessage {
  factory ProfitServiceGetSummaryRequest({
    $core.String? workspaceId,
    $core.String? scopeType,
    $core.String? scopeId,
    $core.String? periodStart,
    $core.String? periodEnd,
  }) {
    final result = ProfitServiceGetSummaryRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (scopeType != null) result.scopeType = scopeType;
    if (scopeId != null) result.scopeId = scopeId;
    if (periodStart != null) result.periodStart = periodStart;
    if (periodEnd != null) result.periodEnd = periodEnd;
    return result;
  }

  ProfitServiceGetSummaryRequest._();

  factory ProfitServiceGetSummaryRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ProfitServiceGetSummaryRequest()..mergeFromBuffer(data, registry);
  factory ProfitServiceGetSummaryRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ProfitServiceGetSummaryRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ProfitServiceGetSummaryRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.finance.v1'),
      createEmptyInstance: ProfitServiceGetSummaryRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'scopeType')
    ..aOS(3, _omitFieldNames ? '' : 'scopeId')
    ..aOS(4, _omitFieldNames ? '' : 'periodStart')
    ..aOS(5, _omitFieldNames ? '' : 'periodEnd')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ProfitServiceGetSummaryRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ProfitServiceGetSummaryRequest copyWith(
          void Function(ProfitServiceGetSummaryRequest) updates) =>
      super.copyWith(
              (message) => updates(message as ProfitServiceGetSummaryRequest))
          as ProfitServiceGetSummaryRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ProfitServiceGetSummaryRequest() / ProfitServiceGetSummaryRequest.new instead')
  static ProfitServiceGetSummaryRequest create() =>
      ProfitServiceGetSummaryRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      ProfitServiceGetSummaryRequest._();
  @$core.override
  ProfitServiceGetSummaryRequest createEmptyInstance() =>
      ProfitServiceGetSummaryRequest._();
  @$core.pragma('dart2js:noInline')
  static ProfitServiceGetSummaryRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ProfitServiceGetSummaryRequest>(
          ProfitServiceGetSummaryRequest.$_createMessage);
  static ProfitServiceGetSummaryRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get scopeType => $_getSZ(1);
  @$pb.TagNumber(2)
  set scopeType($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasScopeType() => $_has(1);
  @$pb.TagNumber(2)
  void clearScopeType() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get scopeId => $_getSZ(2);
  @$pb.TagNumber(3)
  set scopeId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasScopeId() => $_has(2);
  @$pb.TagNumber(3)
  void clearScopeId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get periodStart => $_getSZ(3);
  @$pb.TagNumber(4)
  set periodStart($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasPeriodStart() => $_has(3);
  @$pb.TagNumber(4)
  void clearPeriodStart() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get periodEnd => $_getSZ(4);
  @$pb.TagNumber(5)
  set periodEnd($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasPeriodEnd() => $_has(4);
  @$pb.TagNumber(5)
  void clearPeriodEnd() => $_clearField(5);
}

class ProfitServiceGetSummaryResponse extends $pb.GeneratedMessage {
  factory ProfitServiceGetSummaryResponse({
    ProfitSnapshot? snapshot,
    $core.Iterable<$core.MapEntry<$core.String, $core.String>>?
        componentBreakdown,
    $core.Iterable<$core.MapEntry<$core.String, $core.double>>?
        sourceClassPercentages,
  }) {
    final result = ProfitServiceGetSummaryResponse._();
    if (snapshot != null) result.snapshot = snapshot;
    if (componentBreakdown != null)
      result.componentBreakdown.addEntries(componentBreakdown);
    if (sourceClassPercentages != null)
      result.sourceClassPercentages.addEntries(sourceClassPercentages);
    return result;
  }

  ProfitServiceGetSummaryResponse._();

  factory ProfitServiceGetSummaryResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ProfitServiceGetSummaryResponse()..mergeFromBuffer(data, registry);
  factory ProfitServiceGetSummaryResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ProfitServiceGetSummaryResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ProfitServiceGetSummaryResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.finance.v1'),
      createEmptyInstance: ProfitServiceGetSummaryResponse.$_createMessage)
    ..aOM<ProfitSnapshot>(1, _omitFieldNames ? '' : 'snapshot',
        subBuilder: ProfitSnapshot.$_createMessage)
    ..m<$core.String, $core.String>(
        2, _omitFieldNames ? '' : 'componentBreakdown',
        entryClassName:
            'ProfitServiceGetSummaryResponse.ComponentBreakdownEntry',
        keyFieldType: $pb.PbFieldType.OS,
        valueFieldType: $pb.PbFieldType.OS,
        packageName: const $pb.PackageName('creativanta.finance.v1'))
    ..m<$core.String, $core.double>(
        3, _omitFieldNames ? '' : 'sourceClassPercentages',
        entryClassName:
            'ProfitServiceGetSummaryResponse.SourceClassPercentagesEntry',
        keyFieldType: $pb.PbFieldType.OS,
        valueFieldType: $pb.PbFieldType.OD,
        packageName: const $pb.PackageName('creativanta.finance.v1'))
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ProfitServiceGetSummaryResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ProfitServiceGetSummaryResponse copyWith(
          void Function(ProfitServiceGetSummaryResponse) updates) =>
      super.copyWith(
              (message) => updates(message as ProfitServiceGetSummaryResponse))
          as ProfitServiceGetSummaryResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ProfitServiceGetSummaryResponse() / ProfitServiceGetSummaryResponse.new instead')
  static ProfitServiceGetSummaryResponse create() =>
      ProfitServiceGetSummaryResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      ProfitServiceGetSummaryResponse._();
  @$core.override
  ProfitServiceGetSummaryResponse createEmptyInstance() =>
      ProfitServiceGetSummaryResponse._();
  @$core.pragma('dart2js:noInline')
  static ProfitServiceGetSummaryResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ProfitServiceGetSummaryResponse>(
          ProfitServiceGetSummaryResponse.$_createMessage);
  static ProfitServiceGetSummaryResponse? _defaultInstance;

  @$pb.TagNumber(1)
  ProfitSnapshot get snapshot => $_getN(0);
  @$pb.TagNumber(1)
  set snapshot(ProfitSnapshot value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasSnapshot() => $_has(0);
  @$pb.TagNumber(1)
  void clearSnapshot() => $_clearField(1);
  @$pb.TagNumber(1)
  ProfitSnapshot ensureSnapshot() => $_ensure(0);

  @$pb.TagNumber(2)
  $pb.PbMap<$core.String, $core.String> get componentBreakdown => $_getMap(1);

  @$pb.TagNumber(3)
  $pb.PbMap<$core.String, $core.double> get sourceClassPercentages =>
      $_getMap(2);
}

/// ProfitService/DrillDown
class ProfitServiceDrillDownRequest extends $pb.GeneratedMessage {
  factory ProfitServiceDrillDownRequest({
    $core.String? workspaceId,
    $core.String? scopeType,
    $core.String? scopeId,
    $core.String? periodStart,
    $core.String? periodEnd,
    $core.String? drilldownBy,
  }) {
    final result = ProfitServiceDrillDownRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (scopeType != null) result.scopeType = scopeType;
    if (scopeId != null) result.scopeId = scopeId;
    if (periodStart != null) result.periodStart = periodStart;
    if (periodEnd != null) result.periodEnd = periodEnd;
    if (drilldownBy != null) result.drilldownBy = drilldownBy;
    return result;
  }

  ProfitServiceDrillDownRequest._();

  factory ProfitServiceDrillDownRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ProfitServiceDrillDownRequest()..mergeFromBuffer(data, registry);
  factory ProfitServiceDrillDownRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ProfitServiceDrillDownRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ProfitServiceDrillDownRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.finance.v1'),
      createEmptyInstance: ProfitServiceDrillDownRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'scopeType')
    ..aOS(3, _omitFieldNames ? '' : 'scopeId')
    ..aOS(4, _omitFieldNames ? '' : 'periodStart')
    ..aOS(5, _omitFieldNames ? '' : 'periodEnd')
    ..aOS(6, _omitFieldNames ? '' : 'drilldownBy')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ProfitServiceDrillDownRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ProfitServiceDrillDownRequest copyWith(
          void Function(ProfitServiceDrillDownRequest) updates) =>
      super.copyWith(
              (message) => updates(message as ProfitServiceDrillDownRequest))
          as ProfitServiceDrillDownRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ProfitServiceDrillDownRequest() / ProfitServiceDrillDownRequest.new instead')
  static ProfitServiceDrillDownRequest create() =>
      ProfitServiceDrillDownRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      ProfitServiceDrillDownRequest._();
  @$core.override
  ProfitServiceDrillDownRequest createEmptyInstance() =>
      ProfitServiceDrillDownRequest._();
  @$core.pragma('dart2js:noInline')
  static ProfitServiceDrillDownRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ProfitServiceDrillDownRequest>(
          ProfitServiceDrillDownRequest.$_createMessage);
  static ProfitServiceDrillDownRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get scopeType => $_getSZ(1);
  @$pb.TagNumber(2)
  set scopeType($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasScopeType() => $_has(1);
  @$pb.TagNumber(2)
  void clearScopeType() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get scopeId => $_getSZ(2);
  @$pb.TagNumber(3)
  set scopeId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasScopeId() => $_has(2);
  @$pb.TagNumber(3)
  void clearScopeId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get periodStart => $_getSZ(3);
  @$pb.TagNumber(4)
  set periodStart($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasPeriodStart() => $_has(3);
  @$pb.TagNumber(4)
  void clearPeriodStart() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get periodEnd => $_getSZ(4);
  @$pb.TagNumber(5)
  set periodEnd($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasPeriodEnd() => $_has(4);
  @$pb.TagNumber(5)
  void clearPeriodEnd() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get drilldownBy => $_getSZ(5);
  @$pb.TagNumber(6)
  set drilldownBy($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasDrilldownBy() => $_has(5);
  @$pb.TagNumber(6)
  void clearDrilldownBy() => $_clearField(6);
}

class ProfitDrillDownItem extends $pb.GeneratedMessage {
  factory ProfitDrillDownItem({
    $core.String? key,
    $core.String? label,
    $2.Money? revenue,
    $2.Money? costs,
    $2.Money? netProfit,
    $2.ConfidenceBand? confidence,
    $2.SourceClass? primarySourceClass,
  }) {
    final result = ProfitDrillDownItem._();
    if (key != null) result.key = key;
    if (label != null) result.label = label;
    if (revenue != null) result.revenue = revenue;
    if (costs != null) result.costs = costs;
    if (netProfit != null) result.netProfit = netProfit;
    if (confidence != null) result.confidence = confidence;
    if (primarySourceClass != null)
      result.primarySourceClass = primarySourceClass;
    return result;
  }

  ProfitDrillDownItem._();

  factory ProfitDrillDownItem.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ProfitDrillDownItem()..mergeFromBuffer(data, registry);
  factory ProfitDrillDownItem.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ProfitDrillDownItem()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ProfitDrillDownItem',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.finance.v1'),
      createEmptyInstance: ProfitDrillDownItem.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'key')
    ..aOS(2, _omitFieldNames ? '' : 'label')
    ..aOM<$2.Money>(3, _omitFieldNames ? '' : 'revenue',
        subBuilder: $2.Money.$_createMessage)
    ..aOM<$2.Money>(4, _omitFieldNames ? '' : 'costs',
        subBuilder: $2.Money.$_createMessage)
    ..aOM<$2.Money>(5, _omitFieldNames ? '' : 'netProfit',
        subBuilder: $2.Money.$_createMessage)
    ..aE<$2.ConfidenceBand>(6, _omitFieldNames ? '' : 'confidence',
        enumValues: $2.ConfidenceBand.values)
    ..aE<$2.SourceClass>(7, _omitFieldNames ? '' : 'primarySourceClass',
        enumValues: $2.SourceClass.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ProfitDrillDownItem clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ProfitDrillDownItem copyWith(void Function(ProfitDrillDownItem) updates) =>
      super.copyWith((message) => updates(message as ProfitDrillDownItem))
          as ProfitDrillDownItem;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core
      .Deprecated('Use ProfitDrillDownItem() / ProfitDrillDownItem.new instead')
  static ProfitDrillDownItem create() => ProfitDrillDownItem._();
  static $pb.GeneratedMessage $_createMessage() => ProfitDrillDownItem._();
  @$core.override
  ProfitDrillDownItem createEmptyInstance() => ProfitDrillDownItem._();
  @$core.pragma('dart2js:noInline')
  static ProfitDrillDownItem getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ProfitDrillDownItem>(
          ProfitDrillDownItem.$_createMessage);
  static ProfitDrillDownItem? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get key => $_getSZ(0);
  @$pb.TagNumber(1)
  set key($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasKey() => $_has(0);
  @$pb.TagNumber(1)
  void clearKey() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get label => $_getSZ(1);
  @$pb.TagNumber(2)
  set label($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasLabel() => $_has(1);
  @$pb.TagNumber(2)
  void clearLabel() => $_clearField(2);

  @$pb.TagNumber(3)
  $2.Money get revenue => $_getN(2);
  @$pb.TagNumber(3)
  set revenue($2.Money value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasRevenue() => $_has(2);
  @$pb.TagNumber(3)
  void clearRevenue() => $_clearField(3);
  @$pb.TagNumber(3)
  $2.Money ensureRevenue() => $_ensure(2);

  @$pb.TagNumber(4)
  $2.Money get costs => $_getN(3);
  @$pb.TagNumber(4)
  set costs($2.Money value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasCosts() => $_has(3);
  @$pb.TagNumber(4)
  void clearCosts() => $_clearField(4);
  @$pb.TagNumber(4)
  $2.Money ensureCosts() => $_ensure(3);

  @$pb.TagNumber(5)
  $2.Money get netProfit => $_getN(4);
  @$pb.TagNumber(5)
  set netProfit($2.Money value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasNetProfit() => $_has(4);
  @$pb.TagNumber(5)
  void clearNetProfit() => $_clearField(5);
  @$pb.TagNumber(5)
  $2.Money ensureNetProfit() => $_ensure(4);

  @$pb.TagNumber(6)
  $2.ConfidenceBand get confidence => $_getN(5);
  @$pb.TagNumber(6)
  set confidence($2.ConfidenceBand value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasConfidence() => $_has(5);
  @$pb.TagNumber(6)
  void clearConfidence() => $_clearField(6);

  @$pb.TagNumber(7)
  $2.SourceClass get primarySourceClass => $_getN(6);
  @$pb.TagNumber(7)
  set primarySourceClass($2.SourceClass value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasPrimarySourceClass() => $_has(6);
  @$pb.TagNumber(7)
  void clearPrimarySourceClass() => $_clearField(7);
}

class ProfitServiceDrillDownResponse extends $pb.GeneratedMessage {
  factory ProfitServiceDrillDownResponse({
    $core.Iterable<ProfitDrillDownItem>? items,
    $core.String? currency,
  }) {
    final result = ProfitServiceDrillDownResponse._();
    if (items != null) result.items.addAll(items);
    if (currency != null) result.currency = currency;
    return result;
  }

  ProfitServiceDrillDownResponse._();

  factory ProfitServiceDrillDownResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ProfitServiceDrillDownResponse()..mergeFromBuffer(data, registry);
  factory ProfitServiceDrillDownResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ProfitServiceDrillDownResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ProfitServiceDrillDownResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.finance.v1'),
      createEmptyInstance: ProfitServiceDrillDownResponse.$_createMessage)
    ..pPM<ProfitDrillDownItem>(1, _omitFieldNames ? '' : 'items',
        subBuilder: ProfitDrillDownItem.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'currency')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ProfitServiceDrillDownResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ProfitServiceDrillDownResponse copyWith(
          void Function(ProfitServiceDrillDownResponse) updates) =>
      super.copyWith(
              (message) => updates(message as ProfitServiceDrillDownResponse))
          as ProfitServiceDrillDownResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ProfitServiceDrillDownResponse() / ProfitServiceDrillDownResponse.new instead')
  static ProfitServiceDrillDownResponse create() =>
      ProfitServiceDrillDownResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      ProfitServiceDrillDownResponse._();
  @$core.override
  ProfitServiceDrillDownResponse createEmptyInstance() =>
      ProfitServiceDrillDownResponse._();
  @$core.pragma('dart2js:noInline')
  static ProfitServiceDrillDownResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ProfitServiceDrillDownResponse>(
          ProfitServiceDrillDownResponse.$_createMessage);
  static ProfitServiceDrillDownResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<ProfitDrillDownItem> get items => $_getList(0);

  @$pb.TagNumber(2)
  $core.String get currency => $_getSZ(1);
  @$pb.TagNumber(2)
  set currency($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCurrency() => $_has(1);
  @$pb.TagNumber(2)
  void clearCurrency() => $_clearField(2);
}

/// ProfitService/GetAnomalies
class ProfitServiceGetAnomaliesRequest extends $pb.GeneratedMessage {
  factory ProfitServiceGetAnomaliesRequest({
    $core.String? workspaceId,
    $core.String? periodStart,
    $core.String? periodEnd,
  }) {
    final result = ProfitServiceGetAnomaliesRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (periodStart != null) result.periodStart = periodStart;
    if (periodEnd != null) result.periodEnd = periodEnd;
    return result;
  }

  ProfitServiceGetAnomaliesRequest._();

  factory ProfitServiceGetAnomaliesRequest.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ProfitServiceGetAnomaliesRequest()..mergeFromBuffer(data, registry);
  factory ProfitServiceGetAnomaliesRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ProfitServiceGetAnomaliesRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ProfitServiceGetAnomaliesRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.finance.v1'),
      createEmptyInstance: ProfitServiceGetAnomaliesRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'periodStart')
    ..aOS(3, _omitFieldNames ? '' : 'periodEnd')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ProfitServiceGetAnomaliesRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ProfitServiceGetAnomaliesRequest copyWith(
          void Function(ProfitServiceGetAnomaliesRequest) updates) =>
      super.copyWith(
              (message) => updates(message as ProfitServiceGetAnomaliesRequest))
          as ProfitServiceGetAnomaliesRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ProfitServiceGetAnomaliesRequest() / ProfitServiceGetAnomaliesRequest.new instead')
  static ProfitServiceGetAnomaliesRequest create() =>
      ProfitServiceGetAnomaliesRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      ProfitServiceGetAnomaliesRequest._();
  @$core.override
  ProfitServiceGetAnomaliesRequest createEmptyInstance() =>
      ProfitServiceGetAnomaliesRequest._();
  @$core.pragma('dart2js:noInline')
  static ProfitServiceGetAnomaliesRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ProfitServiceGetAnomaliesRequest>(
          ProfitServiceGetAnomaliesRequest.$_createMessage);
  static ProfitServiceGetAnomaliesRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

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

class ProfitServiceGetAnomaliesResponse extends $pb.GeneratedMessage {
  factory ProfitServiceGetAnomaliesResponse({
    $core.Iterable<ProfitAnomaly>? anomalies,
  }) {
    final result = ProfitServiceGetAnomaliesResponse._();
    if (anomalies != null) result.anomalies.addAll(anomalies);
    return result;
  }

  ProfitServiceGetAnomaliesResponse._();

  factory ProfitServiceGetAnomaliesResponse.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ProfitServiceGetAnomaliesResponse()..mergeFromBuffer(data, registry);
  factory ProfitServiceGetAnomaliesResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ProfitServiceGetAnomaliesResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ProfitServiceGetAnomaliesResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.finance.v1'),
      createEmptyInstance: ProfitServiceGetAnomaliesResponse.$_createMessage)
    ..pPM<ProfitAnomaly>(1, _omitFieldNames ? '' : 'anomalies',
        subBuilder: ProfitAnomaly.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ProfitServiceGetAnomaliesResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ProfitServiceGetAnomaliesResponse copyWith(
          void Function(ProfitServiceGetAnomaliesResponse) updates) =>
      super.copyWith((message) =>
              updates(message as ProfitServiceGetAnomaliesResponse))
          as ProfitServiceGetAnomaliesResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ProfitServiceGetAnomaliesResponse() / ProfitServiceGetAnomaliesResponse.new instead')
  static ProfitServiceGetAnomaliesResponse create() =>
      ProfitServiceGetAnomaliesResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      ProfitServiceGetAnomaliesResponse._();
  @$core.override
  ProfitServiceGetAnomaliesResponse createEmptyInstance() =>
      ProfitServiceGetAnomaliesResponse._();
  @$core.pragma('dart2js:noInline')
  static ProfitServiceGetAnomaliesResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ProfitServiceGetAnomaliesResponse>(
          ProfitServiceGetAnomaliesResponse.$_createMessage);
  static ProfitServiceGetAnomaliesResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<ProfitAnomaly> get anomalies => $_getList(0);
}

/// ProfitService/GetSnapshot
class ProfitServiceGetSnapshotRequest extends $pb.GeneratedMessage {
  factory ProfitServiceGetSnapshotRequest({
    $core.String? workspaceId,
    $core.String? snapshotId,
    $core.String? scopeType,
    $core.String? scopeId,
    $core.String? periodStart,
    $core.String? periodEnd,
  }) {
    final result = ProfitServiceGetSnapshotRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (snapshotId != null) result.snapshotId = snapshotId;
    if (scopeType != null) result.scopeType = scopeType;
    if (scopeId != null) result.scopeId = scopeId;
    if (periodStart != null) result.periodStart = periodStart;
    if (periodEnd != null) result.periodEnd = periodEnd;
    return result;
  }

  ProfitServiceGetSnapshotRequest._();

  factory ProfitServiceGetSnapshotRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ProfitServiceGetSnapshotRequest()..mergeFromBuffer(data, registry);
  factory ProfitServiceGetSnapshotRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ProfitServiceGetSnapshotRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ProfitServiceGetSnapshotRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.finance.v1'),
      createEmptyInstance: ProfitServiceGetSnapshotRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'snapshotId')
    ..aOS(3, _omitFieldNames ? '' : 'scopeType')
    ..aOS(4, _omitFieldNames ? '' : 'scopeId')
    ..aOS(5, _omitFieldNames ? '' : 'periodStart')
    ..aOS(6, _omitFieldNames ? '' : 'periodEnd')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ProfitServiceGetSnapshotRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ProfitServiceGetSnapshotRequest copyWith(
          void Function(ProfitServiceGetSnapshotRequest) updates) =>
      super.copyWith(
              (message) => updates(message as ProfitServiceGetSnapshotRequest))
          as ProfitServiceGetSnapshotRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ProfitServiceGetSnapshotRequest() / ProfitServiceGetSnapshotRequest.new instead')
  static ProfitServiceGetSnapshotRequest create() =>
      ProfitServiceGetSnapshotRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      ProfitServiceGetSnapshotRequest._();
  @$core.override
  ProfitServiceGetSnapshotRequest createEmptyInstance() =>
      ProfitServiceGetSnapshotRequest._();
  @$core.pragma('dart2js:noInline')
  static ProfitServiceGetSnapshotRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ProfitServiceGetSnapshotRequest>(
          ProfitServiceGetSnapshotRequest.$_createMessage);
  static ProfitServiceGetSnapshotRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get snapshotId => $_getSZ(1);
  @$pb.TagNumber(2)
  set snapshotId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSnapshotId() => $_has(1);
  @$pb.TagNumber(2)
  void clearSnapshotId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get scopeType => $_getSZ(2);
  @$pb.TagNumber(3)
  set scopeType($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasScopeType() => $_has(2);
  @$pb.TagNumber(3)
  void clearScopeType() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get scopeId => $_getSZ(3);
  @$pb.TagNumber(4)
  set scopeId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasScopeId() => $_has(3);
  @$pb.TagNumber(4)
  void clearScopeId() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get periodStart => $_getSZ(4);
  @$pb.TagNumber(5)
  set periodStart($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasPeriodStart() => $_has(4);
  @$pb.TagNumber(5)
  void clearPeriodStart() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get periodEnd => $_getSZ(5);
  @$pb.TagNumber(6)
  set periodEnd($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasPeriodEnd() => $_has(5);
  @$pb.TagNumber(6)
  void clearPeriodEnd() => $_clearField(6);
}

class ProfitServiceGetSnapshotResponse extends $pb.GeneratedMessage {
  factory ProfitServiceGetSnapshotResponse({
    ProfitSnapshot? snapshot,
  }) {
    final result = ProfitServiceGetSnapshotResponse._();
    if (snapshot != null) result.snapshot = snapshot;
    return result;
  }

  ProfitServiceGetSnapshotResponse._();

  factory ProfitServiceGetSnapshotResponse.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ProfitServiceGetSnapshotResponse()..mergeFromBuffer(data, registry);
  factory ProfitServiceGetSnapshotResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ProfitServiceGetSnapshotResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ProfitServiceGetSnapshotResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.finance.v1'),
      createEmptyInstance: ProfitServiceGetSnapshotResponse.$_createMessage)
    ..aOM<ProfitSnapshot>(1, _omitFieldNames ? '' : 'snapshot',
        subBuilder: ProfitSnapshot.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ProfitServiceGetSnapshotResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ProfitServiceGetSnapshotResponse copyWith(
          void Function(ProfitServiceGetSnapshotResponse) updates) =>
      super.copyWith(
              (message) => updates(message as ProfitServiceGetSnapshotResponse))
          as ProfitServiceGetSnapshotResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ProfitServiceGetSnapshotResponse() / ProfitServiceGetSnapshotResponse.new instead')
  static ProfitServiceGetSnapshotResponse create() =>
      ProfitServiceGetSnapshotResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      ProfitServiceGetSnapshotResponse._();
  @$core.override
  ProfitServiceGetSnapshotResponse createEmptyInstance() =>
      ProfitServiceGetSnapshotResponse._();
  @$core.pragma('dart2js:noInline')
  static ProfitServiceGetSnapshotResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ProfitServiceGetSnapshotResponse>(
          ProfitServiceGetSnapshotResponse.$_createMessage);
  static ProfitServiceGetSnapshotResponse? _defaultInstance;

  @$pb.TagNumber(1)
  ProfitSnapshot get snapshot => $_getN(0);
  @$pb.TagNumber(1)
  set snapshot(ProfitSnapshot value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasSnapshot() => $_has(0);
  @$pb.TagNumber(1)
  void clearSnapshot() => $_clearField(1);
  @$pb.TagNumber(1)
  ProfitSnapshot ensureSnapshot() => $_ensure(0);
}

/// ProfitService/RefreshSnapshot
class ProfitServiceRefreshSnapshotRequest extends $pb.GeneratedMessage {
  factory ProfitServiceRefreshSnapshotRequest({
    $2.CommandContext? context,
    $core.String? workspaceId,
    $core.String? scopeType,
    $core.String? scopeId,
    $core.String? periodStart,
    $core.String? periodEnd,
  }) {
    final result = ProfitServiceRefreshSnapshotRequest._();
    if (context != null) result.context = context;
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (scopeType != null) result.scopeType = scopeType;
    if (scopeId != null) result.scopeId = scopeId;
    if (periodStart != null) result.periodStart = periodStart;
    if (periodEnd != null) result.periodEnd = periodEnd;
    return result;
  }

  ProfitServiceRefreshSnapshotRequest._();

  factory ProfitServiceRefreshSnapshotRequest.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ProfitServiceRefreshSnapshotRequest()..mergeFromBuffer(data, registry);
  factory ProfitServiceRefreshSnapshotRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ProfitServiceRefreshSnapshotRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ProfitServiceRefreshSnapshotRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.finance.v1'),
      createEmptyInstance: ProfitServiceRefreshSnapshotRequest.$_createMessage)
    ..aOM<$2.CommandContext>(1, _omitFieldNames ? '' : 'context',
        subBuilder: $2.CommandContext.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(3, _omitFieldNames ? '' : 'scopeType')
    ..aOS(4, _omitFieldNames ? '' : 'scopeId')
    ..aOS(5, _omitFieldNames ? '' : 'periodStart')
    ..aOS(6, _omitFieldNames ? '' : 'periodEnd')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ProfitServiceRefreshSnapshotRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ProfitServiceRefreshSnapshotRequest copyWith(
          void Function(ProfitServiceRefreshSnapshotRequest) updates) =>
      super.copyWith((message) =>
              updates(message as ProfitServiceRefreshSnapshotRequest))
          as ProfitServiceRefreshSnapshotRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ProfitServiceRefreshSnapshotRequest() / ProfitServiceRefreshSnapshotRequest.new instead')
  static ProfitServiceRefreshSnapshotRequest create() =>
      ProfitServiceRefreshSnapshotRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      ProfitServiceRefreshSnapshotRequest._();
  @$core.override
  ProfitServiceRefreshSnapshotRequest createEmptyInstance() =>
      ProfitServiceRefreshSnapshotRequest._();
  @$core.pragma('dart2js:noInline')
  static ProfitServiceRefreshSnapshotRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
              ProfitServiceRefreshSnapshotRequest>(
          ProfitServiceRefreshSnapshotRequest.$_createMessage);
  static ProfitServiceRefreshSnapshotRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $2.CommandContext get context => $_getN(0);
  @$pb.TagNumber(1)
  set context($2.CommandContext value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasContext() => $_has(0);
  @$pb.TagNumber(1)
  void clearContext() => $_clearField(1);
  @$pb.TagNumber(1)
  $2.CommandContext ensureContext() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get workspaceId => $_getSZ(1);
  @$pb.TagNumber(2)
  set workspaceId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasWorkspaceId() => $_has(1);
  @$pb.TagNumber(2)
  void clearWorkspaceId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get scopeType => $_getSZ(2);
  @$pb.TagNumber(3)
  set scopeType($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasScopeType() => $_has(2);
  @$pb.TagNumber(3)
  void clearScopeType() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get scopeId => $_getSZ(3);
  @$pb.TagNumber(4)
  set scopeId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasScopeId() => $_has(3);
  @$pb.TagNumber(4)
  void clearScopeId() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get periodStart => $_getSZ(4);
  @$pb.TagNumber(5)
  set periodStart($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasPeriodStart() => $_has(4);
  @$pb.TagNumber(5)
  void clearPeriodStart() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get periodEnd => $_getSZ(5);
  @$pb.TagNumber(6)
  set periodEnd($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasPeriodEnd() => $_has(5);
  @$pb.TagNumber(6)
  void clearPeriodEnd() => $_clearField(6);
}

class ProfitServiceRefreshSnapshotResponse extends $pb.GeneratedMessage {
  factory ProfitServiceRefreshSnapshotResponse({
    ProfitSnapshot? snapshot,
  }) {
    final result = ProfitServiceRefreshSnapshotResponse._();
    if (snapshot != null) result.snapshot = snapshot;
    return result;
  }

  ProfitServiceRefreshSnapshotResponse._();

  factory ProfitServiceRefreshSnapshotResponse.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ProfitServiceRefreshSnapshotResponse()..mergeFromBuffer(data, registry);
  factory ProfitServiceRefreshSnapshotResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ProfitServiceRefreshSnapshotResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ProfitServiceRefreshSnapshotResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.finance.v1'),
      createEmptyInstance: ProfitServiceRefreshSnapshotResponse.$_createMessage)
    ..aOM<ProfitSnapshot>(1, _omitFieldNames ? '' : 'snapshot',
        subBuilder: ProfitSnapshot.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ProfitServiceRefreshSnapshotResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ProfitServiceRefreshSnapshotResponse copyWith(
          void Function(ProfitServiceRefreshSnapshotResponse) updates) =>
      super.copyWith((message) =>
              updates(message as ProfitServiceRefreshSnapshotResponse))
          as ProfitServiceRefreshSnapshotResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ProfitServiceRefreshSnapshotResponse() / ProfitServiceRefreshSnapshotResponse.new instead')
  static ProfitServiceRefreshSnapshotResponse create() =>
      ProfitServiceRefreshSnapshotResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      ProfitServiceRefreshSnapshotResponse._();
  @$core.override
  ProfitServiceRefreshSnapshotResponse createEmptyInstance() =>
      ProfitServiceRefreshSnapshotResponse._();
  @$core.pragma('dart2js:noInline')
  static ProfitServiceRefreshSnapshotResponse getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
              ProfitServiceRefreshSnapshotResponse>(
          ProfitServiceRefreshSnapshotResponse.$_createMessage);
  static ProfitServiceRefreshSnapshotResponse? _defaultInstance;

  @$pb.TagNumber(1)
  ProfitSnapshot get snapshot => $_getN(0);
  @$pb.TagNumber(1)
  set snapshot(ProfitSnapshot value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasSnapshot() => $_has(0);
  @$pb.TagNumber(1)
  void clearSnapshot() => $_clearField(1);
  @$pb.TagNumber(1)
  ProfitSnapshot ensureSnapshot() => $_ensure(0);
}

/// SettlementService/Import
class SettlementLineInput extends $pb.GeneratedMessage {
  factory SettlementLineInput({
    $core.String? externalLineId,
    $core.String? externalOrderId,
    $2.Money? grossAmount,
    $2.Money? feeAmount,
    $2.Money? refundAmount,
    $2.Money? netAmount,
  }) {
    final result = SettlementLineInput._();
    if (externalLineId != null) result.externalLineId = externalLineId;
    if (externalOrderId != null) result.externalOrderId = externalOrderId;
    if (grossAmount != null) result.grossAmount = grossAmount;
    if (feeAmount != null) result.feeAmount = feeAmount;
    if (refundAmount != null) result.refundAmount = refundAmount;
    if (netAmount != null) result.netAmount = netAmount;
    return result;
  }

  SettlementLineInput._();

  factory SettlementLineInput.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SettlementLineInput()..mergeFromBuffer(data, registry);
  factory SettlementLineInput.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SettlementLineInput()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SettlementLineInput',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.finance.v1'),
      createEmptyInstance: SettlementLineInput.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'externalLineId')
    ..aOS(2, _omitFieldNames ? '' : 'externalOrderId')
    ..aOM<$2.Money>(3, _omitFieldNames ? '' : 'grossAmount',
        subBuilder: $2.Money.$_createMessage)
    ..aOM<$2.Money>(4, _omitFieldNames ? '' : 'feeAmount',
        subBuilder: $2.Money.$_createMessage)
    ..aOM<$2.Money>(5, _omitFieldNames ? '' : 'refundAmount',
        subBuilder: $2.Money.$_createMessage)
    ..aOM<$2.Money>(6, _omitFieldNames ? '' : 'netAmount',
        subBuilder: $2.Money.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SettlementLineInput clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SettlementLineInput copyWith(void Function(SettlementLineInput) updates) =>
      super.copyWith((message) => updates(message as SettlementLineInput))
          as SettlementLineInput;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core
      .Deprecated('Use SettlementLineInput() / SettlementLineInput.new instead')
  static SettlementLineInput create() => SettlementLineInput._();
  static $pb.GeneratedMessage $_createMessage() => SettlementLineInput._();
  @$core.override
  SettlementLineInput createEmptyInstance() => SettlementLineInput._();
  @$core.pragma('dart2js:noInline')
  static SettlementLineInput getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SettlementLineInput>(
          SettlementLineInput.$_createMessage);
  static SettlementLineInput? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get externalLineId => $_getSZ(0);
  @$pb.TagNumber(1)
  set externalLineId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasExternalLineId() => $_has(0);
  @$pb.TagNumber(1)
  void clearExternalLineId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get externalOrderId => $_getSZ(1);
  @$pb.TagNumber(2)
  set externalOrderId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasExternalOrderId() => $_has(1);
  @$pb.TagNumber(2)
  void clearExternalOrderId() => $_clearField(2);

  @$pb.TagNumber(3)
  $2.Money get grossAmount => $_getN(2);
  @$pb.TagNumber(3)
  set grossAmount($2.Money value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasGrossAmount() => $_has(2);
  @$pb.TagNumber(3)
  void clearGrossAmount() => $_clearField(3);
  @$pb.TagNumber(3)
  $2.Money ensureGrossAmount() => $_ensure(2);

  @$pb.TagNumber(4)
  $2.Money get feeAmount => $_getN(3);
  @$pb.TagNumber(4)
  set feeAmount($2.Money value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasFeeAmount() => $_has(3);
  @$pb.TagNumber(4)
  void clearFeeAmount() => $_clearField(4);
  @$pb.TagNumber(4)
  $2.Money ensureFeeAmount() => $_ensure(3);

  @$pb.TagNumber(5)
  $2.Money get refundAmount => $_getN(4);
  @$pb.TagNumber(5)
  set refundAmount($2.Money value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasRefundAmount() => $_has(4);
  @$pb.TagNumber(5)
  void clearRefundAmount() => $_clearField(5);
  @$pb.TagNumber(5)
  $2.Money ensureRefundAmount() => $_ensure(4);

  @$pb.TagNumber(6)
  $2.Money get netAmount => $_getN(5);
  @$pb.TagNumber(6)
  set netAmount($2.Money value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasNetAmount() => $_has(5);
  @$pb.TagNumber(6)
  void clearNetAmount() => $_clearField(6);
  @$pb.TagNumber(6)
  $2.Money ensureNetAmount() => $_ensure(5);
}

class SettlementServiceImportRequest extends $pb.GeneratedMessage {
  factory SettlementServiceImportRequest({
    $2.CommandContext? context,
    $core.String? workspaceId,
    $core.String? sourcePlatform,
    $core.String? externalSettlementId,
    $core.String? connectedAccountId,
    $2.Money? grossAmount,
    $2.Money? netAmount,
    $core.String? currency,
    $core.String? effectiveDate,
    $core.String? importFingerprint,
    $core.Iterable<SettlementLineInput>? lines,
    ExchangeRateSnapshot? exchangeRate,
  }) {
    final result = SettlementServiceImportRequest._();
    if (context != null) result.context = context;
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (sourcePlatform != null) result.sourcePlatform = sourcePlatform;
    if (externalSettlementId != null)
      result.externalSettlementId = externalSettlementId;
    if (connectedAccountId != null)
      result.connectedAccountId = connectedAccountId;
    if (grossAmount != null) result.grossAmount = grossAmount;
    if (netAmount != null) result.netAmount = netAmount;
    if (currency != null) result.currency = currency;
    if (effectiveDate != null) result.effectiveDate = effectiveDate;
    if (importFingerprint != null) result.importFingerprint = importFingerprint;
    if (lines != null) result.lines.addAll(lines);
    if (exchangeRate != null) result.exchangeRate = exchangeRate;
    return result;
  }

  SettlementServiceImportRequest._();

  factory SettlementServiceImportRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SettlementServiceImportRequest()..mergeFromBuffer(data, registry);
  factory SettlementServiceImportRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SettlementServiceImportRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SettlementServiceImportRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.finance.v1'),
      createEmptyInstance: SettlementServiceImportRequest.$_createMessage)
    ..aOM<$2.CommandContext>(1, _omitFieldNames ? '' : 'context',
        subBuilder: $2.CommandContext.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(3, _omitFieldNames ? '' : 'sourcePlatform')
    ..aOS(4, _omitFieldNames ? '' : 'externalSettlementId')
    ..aOS(5, _omitFieldNames ? '' : 'connectedAccountId')
    ..aOM<$2.Money>(6, _omitFieldNames ? '' : 'grossAmount',
        subBuilder: $2.Money.$_createMessage)
    ..aOM<$2.Money>(7, _omitFieldNames ? '' : 'netAmount',
        subBuilder: $2.Money.$_createMessage)
    ..aOS(8, _omitFieldNames ? '' : 'currency')
    ..aOS(9, _omitFieldNames ? '' : 'effectiveDate')
    ..aOS(10, _omitFieldNames ? '' : 'importFingerprint')
    ..pPM<SettlementLineInput>(11, _omitFieldNames ? '' : 'lines',
        subBuilder: SettlementLineInput.$_createMessage)
    ..aOM<ExchangeRateSnapshot>(12, _omitFieldNames ? '' : 'exchangeRate',
        subBuilder: ExchangeRateSnapshot.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SettlementServiceImportRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SettlementServiceImportRequest copyWith(
          void Function(SettlementServiceImportRequest) updates) =>
      super.copyWith(
              (message) => updates(message as SettlementServiceImportRequest))
          as SettlementServiceImportRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use SettlementServiceImportRequest() / SettlementServiceImportRequest.new instead')
  static SettlementServiceImportRequest create() =>
      SettlementServiceImportRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      SettlementServiceImportRequest._();
  @$core.override
  SettlementServiceImportRequest createEmptyInstance() =>
      SettlementServiceImportRequest._();
  @$core.pragma('dart2js:noInline')
  static SettlementServiceImportRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SettlementServiceImportRequest>(
          SettlementServiceImportRequest.$_createMessage);
  static SettlementServiceImportRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $2.CommandContext get context => $_getN(0);
  @$pb.TagNumber(1)
  set context($2.CommandContext value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasContext() => $_has(0);
  @$pb.TagNumber(1)
  void clearContext() => $_clearField(1);
  @$pb.TagNumber(1)
  $2.CommandContext ensureContext() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get workspaceId => $_getSZ(1);
  @$pb.TagNumber(2)
  set workspaceId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasWorkspaceId() => $_has(1);
  @$pb.TagNumber(2)
  void clearWorkspaceId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get sourcePlatform => $_getSZ(2);
  @$pb.TagNumber(3)
  set sourcePlatform($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasSourcePlatform() => $_has(2);
  @$pb.TagNumber(3)
  void clearSourcePlatform() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get externalSettlementId => $_getSZ(3);
  @$pb.TagNumber(4)
  set externalSettlementId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasExternalSettlementId() => $_has(3);
  @$pb.TagNumber(4)
  void clearExternalSettlementId() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get connectedAccountId => $_getSZ(4);
  @$pb.TagNumber(5)
  set connectedAccountId($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasConnectedAccountId() => $_has(4);
  @$pb.TagNumber(5)
  void clearConnectedAccountId() => $_clearField(5);

  @$pb.TagNumber(6)
  $2.Money get grossAmount => $_getN(5);
  @$pb.TagNumber(6)
  set grossAmount($2.Money value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasGrossAmount() => $_has(5);
  @$pb.TagNumber(6)
  void clearGrossAmount() => $_clearField(6);
  @$pb.TagNumber(6)
  $2.Money ensureGrossAmount() => $_ensure(5);

  @$pb.TagNumber(7)
  $2.Money get netAmount => $_getN(6);
  @$pb.TagNumber(7)
  set netAmount($2.Money value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasNetAmount() => $_has(6);
  @$pb.TagNumber(7)
  void clearNetAmount() => $_clearField(7);
  @$pb.TagNumber(7)
  $2.Money ensureNetAmount() => $_ensure(6);

  @$pb.TagNumber(8)
  $core.String get currency => $_getSZ(7);
  @$pb.TagNumber(8)
  set currency($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasCurrency() => $_has(7);
  @$pb.TagNumber(8)
  void clearCurrency() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get effectiveDate => $_getSZ(8);
  @$pb.TagNumber(9)
  set effectiveDate($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasEffectiveDate() => $_has(8);
  @$pb.TagNumber(9)
  void clearEffectiveDate() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.String get importFingerprint => $_getSZ(9);
  @$pb.TagNumber(10)
  set importFingerprint($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasImportFingerprint() => $_has(9);
  @$pb.TagNumber(10)
  void clearImportFingerprint() => $_clearField(10);

  @$pb.TagNumber(11)
  $pb.PbList<SettlementLineInput> get lines => $_getList(10);

  @$pb.TagNumber(12)
  ExchangeRateSnapshot get exchangeRate => $_getN(11);
  @$pb.TagNumber(12)
  set exchangeRate(ExchangeRateSnapshot value) => $_setField(12, value);
  @$pb.TagNumber(12)
  $core.bool hasExchangeRate() => $_has(11);
  @$pb.TagNumber(12)
  void clearExchangeRate() => $_clearField(12);
  @$pb.TagNumber(12)
  ExchangeRateSnapshot ensureExchangeRate() => $_ensure(11);
}

class SettlementServiceImportResponse extends $pb.GeneratedMessage {
  factory SettlementServiceImportResponse({
    Settlement? settlement,
    $core.int? importedLinesCount,
    $core.bool? alreadyExisted,
  }) {
    final result = SettlementServiceImportResponse._();
    if (settlement != null) result.settlement = settlement;
    if (importedLinesCount != null)
      result.importedLinesCount = importedLinesCount;
    if (alreadyExisted != null) result.alreadyExisted = alreadyExisted;
    return result;
  }

  SettlementServiceImportResponse._();

  factory SettlementServiceImportResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SettlementServiceImportResponse()..mergeFromBuffer(data, registry);
  factory SettlementServiceImportResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SettlementServiceImportResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SettlementServiceImportResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.finance.v1'),
      createEmptyInstance: SettlementServiceImportResponse.$_createMessage)
    ..aOM<Settlement>(1, _omitFieldNames ? '' : 'settlement',
        subBuilder: Settlement.$_createMessage)
    ..aI(2, _omitFieldNames ? '' : 'importedLinesCount')
    ..aOB(3, _omitFieldNames ? '' : 'alreadyExisted')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SettlementServiceImportResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SettlementServiceImportResponse copyWith(
          void Function(SettlementServiceImportResponse) updates) =>
      super.copyWith(
              (message) => updates(message as SettlementServiceImportResponse))
          as SettlementServiceImportResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use SettlementServiceImportResponse() / SettlementServiceImportResponse.new instead')
  static SettlementServiceImportResponse create() =>
      SettlementServiceImportResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      SettlementServiceImportResponse._();
  @$core.override
  SettlementServiceImportResponse createEmptyInstance() =>
      SettlementServiceImportResponse._();
  @$core.pragma('dart2js:noInline')
  static SettlementServiceImportResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SettlementServiceImportResponse>(
          SettlementServiceImportResponse.$_createMessage);
  static SettlementServiceImportResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Settlement get settlement => $_getN(0);
  @$pb.TagNumber(1)
  set settlement(Settlement value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasSettlement() => $_has(0);
  @$pb.TagNumber(1)
  void clearSettlement() => $_clearField(1);
  @$pb.TagNumber(1)
  Settlement ensureSettlement() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.int get importedLinesCount => $_getIZ(1);
  @$pb.TagNumber(2)
  set importedLinesCount($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasImportedLinesCount() => $_has(1);
  @$pb.TagNumber(2)
  void clearImportedLinesCount() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.bool get alreadyExisted => $_getBF(2);
  @$pb.TagNumber(3)
  set alreadyExisted($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasAlreadyExisted() => $_has(2);
  @$pb.TagNumber(3)
  void clearAlreadyExisted() => $_clearField(3);
}

/// SettlementService/List
class SettlementServiceListRequest extends $pb.GeneratedMessage {
  factory SettlementServiceListRequest({
    $core.String? workspaceId,
    $2.Pagination? pagination,
    $core.String? sourcePlatform,
    SettlementState? settlementState,
    ReconciliationState? reconciliationState,
  }) {
    final result = SettlementServiceListRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (pagination != null) result.pagination = pagination;
    if (sourcePlatform != null) result.sourcePlatform = sourcePlatform;
    if (settlementState != null) result.settlementState = settlementState;
    if (reconciliationState != null)
      result.reconciliationState = reconciliationState;
    return result;
  }

  SettlementServiceListRequest._();

  factory SettlementServiceListRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SettlementServiceListRequest()..mergeFromBuffer(data, registry);
  factory SettlementServiceListRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SettlementServiceListRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SettlementServiceListRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.finance.v1'),
      createEmptyInstance: SettlementServiceListRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOM<$2.Pagination>(2, _omitFieldNames ? '' : 'pagination',
        subBuilder: $2.Pagination.$_createMessage)
    ..aOS(3, _omitFieldNames ? '' : 'sourcePlatform')
    ..aE<SettlementState>(4, _omitFieldNames ? '' : 'settlementState',
        enumValues: SettlementState.values)
    ..aE<ReconciliationState>(5, _omitFieldNames ? '' : 'reconciliationState',
        enumValues: ReconciliationState.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SettlementServiceListRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SettlementServiceListRequest copyWith(
          void Function(SettlementServiceListRequest) updates) =>
      super.copyWith(
              (message) => updates(message as SettlementServiceListRequest))
          as SettlementServiceListRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use SettlementServiceListRequest() / SettlementServiceListRequest.new instead')
  static SettlementServiceListRequest create() =>
      SettlementServiceListRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      SettlementServiceListRequest._();
  @$core.override
  SettlementServiceListRequest createEmptyInstance() =>
      SettlementServiceListRequest._();
  @$core.pragma('dart2js:noInline')
  static SettlementServiceListRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SettlementServiceListRequest>(
          SettlementServiceListRequest.$_createMessage);
  static SettlementServiceListRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $2.Pagination get pagination => $_getN(1);
  @$pb.TagNumber(2)
  set pagination($2.Pagination value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasPagination() => $_has(1);
  @$pb.TagNumber(2)
  void clearPagination() => $_clearField(2);
  @$pb.TagNumber(2)
  $2.Pagination ensurePagination() => $_ensure(1);

  @$pb.TagNumber(3)
  $core.String get sourcePlatform => $_getSZ(2);
  @$pb.TagNumber(3)
  set sourcePlatform($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasSourcePlatform() => $_has(2);
  @$pb.TagNumber(3)
  void clearSourcePlatform() => $_clearField(3);

  @$pb.TagNumber(4)
  SettlementState get settlementState => $_getN(3);
  @$pb.TagNumber(4)
  set settlementState(SettlementState value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasSettlementState() => $_has(3);
  @$pb.TagNumber(4)
  void clearSettlementState() => $_clearField(4);

  @$pb.TagNumber(5)
  ReconciliationState get reconciliationState => $_getN(4);
  @$pb.TagNumber(5)
  set reconciliationState(ReconciliationState value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasReconciliationState() => $_has(4);
  @$pb.TagNumber(5)
  void clearReconciliationState() => $_clearField(5);
}

class SettlementServiceListResponse extends $pb.GeneratedMessage {
  factory SettlementServiceListResponse({
    $core.Iterable<Settlement>? settlements,
    $2.PaginatedResponse? pagination,
  }) {
    final result = SettlementServiceListResponse._();
    if (settlements != null) result.settlements.addAll(settlements);
    if (pagination != null) result.pagination = pagination;
    return result;
  }

  SettlementServiceListResponse._();

  factory SettlementServiceListResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SettlementServiceListResponse()..mergeFromBuffer(data, registry);
  factory SettlementServiceListResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SettlementServiceListResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SettlementServiceListResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.finance.v1'),
      createEmptyInstance: SettlementServiceListResponse.$_createMessage)
    ..pPM<Settlement>(1, _omitFieldNames ? '' : 'settlements',
        subBuilder: Settlement.$_createMessage)
    ..aOM<$2.PaginatedResponse>(2, _omitFieldNames ? '' : 'pagination',
        subBuilder: $2.PaginatedResponse.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SettlementServiceListResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SettlementServiceListResponse copyWith(
          void Function(SettlementServiceListResponse) updates) =>
      super.copyWith(
              (message) => updates(message as SettlementServiceListResponse))
          as SettlementServiceListResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use SettlementServiceListResponse() / SettlementServiceListResponse.new instead')
  static SettlementServiceListResponse create() =>
      SettlementServiceListResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      SettlementServiceListResponse._();
  @$core.override
  SettlementServiceListResponse createEmptyInstance() =>
      SettlementServiceListResponse._();
  @$core.pragma('dart2js:noInline')
  static SettlementServiceListResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SettlementServiceListResponse>(
          SettlementServiceListResponse.$_createMessage);
  static SettlementServiceListResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Settlement> get settlements => $_getList(0);

  @$pb.TagNumber(2)
  $2.PaginatedResponse get pagination => $_getN(1);
  @$pb.TagNumber(2)
  set pagination($2.PaginatedResponse value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasPagination() => $_has(1);
  @$pb.TagNumber(2)
  void clearPagination() => $_clearField(2);
  @$pb.TagNumber(2)
  $2.PaginatedResponse ensurePagination() => $_ensure(1);
}

/// SettlementService/Get
class SettlementServiceGetRequest extends $pb.GeneratedMessage {
  factory SettlementServiceGetRequest({
    $core.String? workspaceId,
    $core.String? settlementId,
  }) {
    final result = SettlementServiceGetRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (settlementId != null) result.settlementId = settlementId;
    return result;
  }

  SettlementServiceGetRequest._();

  factory SettlementServiceGetRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SettlementServiceGetRequest()..mergeFromBuffer(data, registry);
  factory SettlementServiceGetRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SettlementServiceGetRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SettlementServiceGetRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.finance.v1'),
      createEmptyInstance: SettlementServiceGetRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'settlementId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SettlementServiceGetRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SettlementServiceGetRequest copyWith(
          void Function(SettlementServiceGetRequest) updates) =>
      super.copyWith(
              (message) => updates(message as SettlementServiceGetRequest))
          as SettlementServiceGetRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use SettlementServiceGetRequest() / SettlementServiceGetRequest.new instead')
  static SettlementServiceGetRequest create() =>
      SettlementServiceGetRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      SettlementServiceGetRequest._();
  @$core.override
  SettlementServiceGetRequest createEmptyInstance() =>
      SettlementServiceGetRequest._();
  @$core.pragma('dart2js:noInline')
  static SettlementServiceGetRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SettlementServiceGetRequest>(
          SettlementServiceGetRequest.$_createMessage);
  static SettlementServiceGetRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get settlementId => $_getSZ(1);
  @$pb.TagNumber(2)
  set settlementId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSettlementId() => $_has(1);
  @$pb.TagNumber(2)
  void clearSettlementId() => $_clearField(2);
}

class SettlementServiceGetResponse extends $pb.GeneratedMessage {
  factory SettlementServiceGetResponse({
    Settlement? settlement,
  }) {
    final result = SettlementServiceGetResponse._();
    if (settlement != null) result.settlement = settlement;
    return result;
  }

  SettlementServiceGetResponse._();

  factory SettlementServiceGetResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SettlementServiceGetResponse()..mergeFromBuffer(data, registry);
  factory SettlementServiceGetResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SettlementServiceGetResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SettlementServiceGetResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.finance.v1'),
      createEmptyInstance: SettlementServiceGetResponse.$_createMessage)
    ..aOM<Settlement>(1, _omitFieldNames ? '' : 'settlement',
        subBuilder: Settlement.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SettlementServiceGetResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SettlementServiceGetResponse copyWith(
          void Function(SettlementServiceGetResponse) updates) =>
      super.copyWith(
              (message) => updates(message as SettlementServiceGetResponse))
          as SettlementServiceGetResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use SettlementServiceGetResponse() / SettlementServiceGetResponse.new instead')
  static SettlementServiceGetResponse create() =>
      SettlementServiceGetResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      SettlementServiceGetResponse._();
  @$core.override
  SettlementServiceGetResponse createEmptyInstance() =>
      SettlementServiceGetResponse._();
  @$core.pragma('dart2js:noInline')
  static SettlementServiceGetResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SettlementServiceGetResponse>(
          SettlementServiceGetResponse.$_createMessage);
  static SettlementServiceGetResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Settlement get settlement => $_getN(0);
  @$pb.TagNumber(1)
  set settlement(Settlement value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasSettlement() => $_has(0);
  @$pb.TagNumber(1)
  void clearSettlement() => $_clearField(1);
  @$pb.TagNumber(1)
  Settlement ensureSettlement() => $_ensure(0);
}

/// CostService/Create
class CostServiceCreateRequest extends $pb.GeneratedMessage {
  factory CostServiceCreateRequest({
    $2.CommandContext? context,
    $core.String? workspaceId,
    $core.String? costType,
    $2.Money? amount,
    $core.String? description,
    $core.String? relatedScopeType,
    $core.String? relatedScopeId,
    $2.SourceClass? sourceClass,
    $core.String? evidenceId,
    $core.String? confidenceReason,
    $core.String? effectiveDate,
  }) {
    final result = CostServiceCreateRequest._();
    if (context != null) result.context = context;
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (costType != null) result.costType = costType;
    if (amount != null) result.amount = amount;
    if (description != null) result.description = description;
    if (relatedScopeType != null) result.relatedScopeType = relatedScopeType;
    if (relatedScopeId != null) result.relatedScopeId = relatedScopeId;
    if (sourceClass != null) result.sourceClass = sourceClass;
    if (evidenceId != null) result.evidenceId = evidenceId;
    if (confidenceReason != null) result.confidenceReason = confidenceReason;
    if (effectiveDate != null) result.effectiveDate = effectiveDate;
    return result;
  }

  CostServiceCreateRequest._();

  factory CostServiceCreateRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CostServiceCreateRequest()..mergeFromBuffer(data, registry);
  factory CostServiceCreateRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CostServiceCreateRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CostServiceCreateRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.finance.v1'),
      createEmptyInstance: CostServiceCreateRequest.$_createMessage)
    ..aOM<$2.CommandContext>(1, _omitFieldNames ? '' : 'context',
        subBuilder: $2.CommandContext.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(3, _omitFieldNames ? '' : 'costType')
    ..aOM<$2.Money>(4, _omitFieldNames ? '' : 'amount',
        subBuilder: $2.Money.$_createMessage)
    ..aOS(5, _omitFieldNames ? '' : 'description')
    ..aOS(6, _omitFieldNames ? '' : 'relatedScopeType')
    ..aOS(7, _omitFieldNames ? '' : 'relatedScopeId')
    ..aE<$2.SourceClass>(8, _omitFieldNames ? '' : 'sourceClass',
        enumValues: $2.SourceClass.values)
    ..aOS(9, _omitFieldNames ? '' : 'evidenceId')
    ..aOS(10, _omitFieldNames ? '' : 'confidenceReason')
    ..aOS(11, _omitFieldNames ? '' : 'effectiveDate')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CostServiceCreateRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CostServiceCreateRequest copyWith(
          void Function(CostServiceCreateRequest) updates) =>
      super.copyWith((message) => updates(message as CostServiceCreateRequest))
          as CostServiceCreateRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use CostServiceCreateRequest() / CostServiceCreateRequest.new instead')
  static CostServiceCreateRequest create() => CostServiceCreateRequest._();
  static $pb.GeneratedMessage $_createMessage() => CostServiceCreateRequest._();
  @$core.override
  CostServiceCreateRequest createEmptyInstance() =>
      CostServiceCreateRequest._();
  @$core.pragma('dart2js:noInline')
  static CostServiceCreateRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CostServiceCreateRequest>(
          CostServiceCreateRequest.$_createMessage);
  static CostServiceCreateRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $2.CommandContext get context => $_getN(0);
  @$pb.TagNumber(1)
  set context($2.CommandContext value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasContext() => $_has(0);
  @$pb.TagNumber(1)
  void clearContext() => $_clearField(1);
  @$pb.TagNumber(1)
  $2.CommandContext ensureContext() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get workspaceId => $_getSZ(1);
  @$pb.TagNumber(2)
  set workspaceId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasWorkspaceId() => $_has(1);
  @$pb.TagNumber(2)
  void clearWorkspaceId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get costType => $_getSZ(2);
  @$pb.TagNumber(3)
  set costType($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasCostType() => $_has(2);
  @$pb.TagNumber(3)
  void clearCostType() => $_clearField(3);

  @$pb.TagNumber(4)
  $2.Money get amount => $_getN(3);
  @$pb.TagNumber(4)
  set amount($2.Money value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasAmount() => $_has(3);
  @$pb.TagNumber(4)
  void clearAmount() => $_clearField(4);
  @$pb.TagNumber(4)
  $2.Money ensureAmount() => $_ensure(3);

  @$pb.TagNumber(5)
  $core.String get description => $_getSZ(4);
  @$pb.TagNumber(5)
  set description($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasDescription() => $_has(4);
  @$pb.TagNumber(5)
  void clearDescription() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get relatedScopeType => $_getSZ(5);
  @$pb.TagNumber(6)
  set relatedScopeType($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasRelatedScopeType() => $_has(5);
  @$pb.TagNumber(6)
  void clearRelatedScopeType() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get relatedScopeId => $_getSZ(6);
  @$pb.TagNumber(7)
  set relatedScopeId($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasRelatedScopeId() => $_has(6);
  @$pb.TagNumber(7)
  void clearRelatedScopeId() => $_clearField(7);

  @$pb.TagNumber(8)
  $2.SourceClass get sourceClass => $_getN(7);
  @$pb.TagNumber(8)
  set sourceClass($2.SourceClass value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasSourceClass() => $_has(7);
  @$pb.TagNumber(8)
  void clearSourceClass() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get evidenceId => $_getSZ(8);
  @$pb.TagNumber(9)
  set evidenceId($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasEvidenceId() => $_has(8);
  @$pb.TagNumber(9)
  void clearEvidenceId() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.String get confidenceReason => $_getSZ(9);
  @$pb.TagNumber(10)
  set confidenceReason($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasConfidenceReason() => $_has(9);
  @$pb.TagNumber(10)
  void clearConfidenceReason() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.String get effectiveDate => $_getSZ(10);
  @$pb.TagNumber(11)
  set effectiveDate($core.String value) => $_setString(10, value);
  @$pb.TagNumber(11)
  $core.bool hasEffectiveDate() => $_has(10);
  @$pb.TagNumber(11)
  void clearEffectiveDate() => $_clearField(11);
}

class CostServiceCreateResponse extends $pb.GeneratedMessage {
  factory CostServiceCreateResponse({
    CostItem? costItem,
  }) {
    final result = CostServiceCreateResponse._();
    if (costItem != null) result.costItem = costItem;
    return result;
  }

  CostServiceCreateResponse._();

  factory CostServiceCreateResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CostServiceCreateResponse()..mergeFromBuffer(data, registry);
  factory CostServiceCreateResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CostServiceCreateResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CostServiceCreateResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.finance.v1'),
      createEmptyInstance: CostServiceCreateResponse.$_createMessage)
    ..aOM<CostItem>(1, _omitFieldNames ? '' : 'costItem',
        subBuilder: CostItem.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CostServiceCreateResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CostServiceCreateResponse copyWith(
          void Function(CostServiceCreateResponse) updates) =>
      super.copyWith((message) => updates(message as CostServiceCreateResponse))
          as CostServiceCreateResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use CostServiceCreateResponse() / CostServiceCreateResponse.new instead')
  static CostServiceCreateResponse create() => CostServiceCreateResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      CostServiceCreateResponse._();
  @$core.override
  CostServiceCreateResponse createEmptyInstance() =>
      CostServiceCreateResponse._();
  @$core.pragma('dart2js:noInline')
  static CostServiceCreateResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CostServiceCreateResponse>(
          CostServiceCreateResponse.$_createMessage);
  static CostServiceCreateResponse? _defaultInstance;

  @$pb.TagNumber(1)
  CostItem get costItem => $_getN(0);
  @$pb.TagNumber(1)
  set costItem(CostItem value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasCostItem() => $_has(0);
  @$pb.TagNumber(1)
  void clearCostItem() => $_clearField(1);
  @$pb.TagNumber(1)
  CostItem ensureCostItem() => $_ensure(0);
}

/// CostService/List
class CostServiceListRequest extends $pb.GeneratedMessage {
  factory CostServiceListRequest({
    $core.String? workspaceId,
    $2.Pagination? pagination,
    $core.String? costType,
    $core.String? relatedScopeType,
    $core.String? relatedScopeId,
    $core.String? periodStart,
    $core.String? periodEnd,
  }) {
    final result = CostServiceListRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (pagination != null) result.pagination = pagination;
    if (costType != null) result.costType = costType;
    if (relatedScopeType != null) result.relatedScopeType = relatedScopeType;
    if (relatedScopeId != null) result.relatedScopeId = relatedScopeId;
    if (periodStart != null) result.periodStart = periodStart;
    if (periodEnd != null) result.periodEnd = periodEnd;
    return result;
  }

  CostServiceListRequest._();

  factory CostServiceListRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CostServiceListRequest()..mergeFromBuffer(data, registry);
  factory CostServiceListRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CostServiceListRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CostServiceListRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.finance.v1'),
      createEmptyInstance: CostServiceListRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOM<$2.Pagination>(2, _omitFieldNames ? '' : 'pagination',
        subBuilder: $2.Pagination.$_createMessage)
    ..aOS(3, _omitFieldNames ? '' : 'costType')
    ..aOS(4, _omitFieldNames ? '' : 'relatedScopeType')
    ..aOS(5, _omitFieldNames ? '' : 'relatedScopeId')
    ..aOS(6, _omitFieldNames ? '' : 'periodStart')
    ..aOS(7, _omitFieldNames ? '' : 'periodEnd')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CostServiceListRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CostServiceListRequest copyWith(
          void Function(CostServiceListRequest) updates) =>
      super.copyWith((message) => updates(message as CostServiceListRequest))
          as CostServiceListRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use CostServiceListRequest() / CostServiceListRequest.new instead')
  static CostServiceListRequest create() => CostServiceListRequest._();
  static $pb.GeneratedMessage $_createMessage() => CostServiceListRequest._();
  @$core.override
  CostServiceListRequest createEmptyInstance() => CostServiceListRequest._();
  @$core.pragma('dart2js:noInline')
  static CostServiceListRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CostServiceListRequest>(
          CostServiceListRequest.$_createMessage);
  static CostServiceListRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $2.Pagination get pagination => $_getN(1);
  @$pb.TagNumber(2)
  set pagination($2.Pagination value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasPagination() => $_has(1);
  @$pb.TagNumber(2)
  void clearPagination() => $_clearField(2);
  @$pb.TagNumber(2)
  $2.Pagination ensurePagination() => $_ensure(1);

  @$pb.TagNumber(3)
  $core.String get costType => $_getSZ(2);
  @$pb.TagNumber(3)
  set costType($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasCostType() => $_has(2);
  @$pb.TagNumber(3)
  void clearCostType() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get relatedScopeType => $_getSZ(3);
  @$pb.TagNumber(4)
  set relatedScopeType($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasRelatedScopeType() => $_has(3);
  @$pb.TagNumber(4)
  void clearRelatedScopeType() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get relatedScopeId => $_getSZ(4);
  @$pb.TagNumber(5)
  set relatedScopeId($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasRelatedScopeId() => $_has(4);
  @$pb.TagNumber(5)
  void clearRelatedScopeId() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get periodStart => $_getSZ(5);
  @$pb.TagNumber(6)
  set periodStart($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasPeriodStart() => $_has(5);
  @$pb.TagNumber(6)
  void clearPeriodStart() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get periodEnd => $_getSZ(6);
  @$pb.TagNumber(7)
  set periodEnd($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasPeriodEnd() => $_has(6);
  @$pb.TagNumber(7)
  void clearPeriodEnd() => $_clearField(7);
}

class CostServiceListResponse extends $pb.GeneratedMessage {
  factory CostServiceListResponse({
    $core.Iterable<CostItem>? costItems,
    $2.PaginatedResponse? pagination,
  }) {
    final result = CostServiceListResponse._();
    if (costItems != null) result.costItems.addAll(costItems);
    if (pagination != null) result.pagination = pagination;
    return result;
  }

  CostServiceListResponse._();

  factory CostServiceListResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CostServiceListResponse()..mergeFromBuffer(data, registry);
  factory CostServiceListResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CostServiceListResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CostServiceListResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.finance.v1'),
      createEmptyInstance: CostServiceListResponse.$_createMessage)
    ..pPM<CostItem>(1, _omitFieldNames ? '' : 'costItems',
        subBuilder: CostItem.$_createMessage)
    ..aOM<$2.PaginatedResponse>(2, _omitFieldNames ? '' : 'pagination',
        subBuilder: $2.PaginatedResponse.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CostServiceListResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CostServiceListResponse copyWith(
          void Function(CostServiceListResponse) updates) =>
      super.copyWith((message) => updates(message as CostServiceListResponse))
          as CostServiceListResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use CostServiceListResponse() / CostServiceListResponse.new instead')
  static CostServiceListResponse create() => CostServiceListResponse._();
  static $pb.GeneratedMessage $_createMessage() => CostServiceListResponse._();
  @$core.override
  CostServiceListResponse createEmptyInstance() => CostServiceListResponse._();
  @$core.pragma('dart2js:noInline')
  static CostServiceListResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CostServiceListResponse>(
          CostServiceListResponse.$_createMessage);
  static CostServiceListResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<CostItem> get costItems => $_getList(0);

  @$pb.TagNumber(2)
  $2.PaginatedResponse get pagination => $_getN(1);
  @$pb.TagNumber(2)
  set pagination($2.PaginatedResponse value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasPagination() => $_has(1);
  @$pb.TagNumber(2)
  void clearPagination() => $_clearField(2);
  @$pb.TagNumber(2)
  $2.PaginatedResponse ensurePagination() => $_ensure(1);
}

/// CostService/Update
class CostServiceUpdateRequest extends $pb.GeneratedMessage {
  factory CostServiceUpdateRequest({
    $2.CommandContext? context,
    $core.String? workspaceId,
    $core.String? costItemId,
    $2.Money? amount,
    $core.String? description,
    $core.String? costType,
    $2.SourceClass? sourceClass,
    CostState? costState,
  }) {
    final result = CostServiceUpdateRequest._();
    if (context != null) result.context = context;
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (costItemId != null) result.costItemId = costItemId;
    if (amount != null) result.amount = amount;
    if (description != null) result.description = description;
    if (costType != null) result.costType = costType;
    if (sourceClass != null) result.sourceClass = sourceClass;
    if (costState != null) result.costState = costState;
    return result;
  }

  CostServiceUpdateRequest._();

  factory CostServiceUpdateRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CostServiceUpdateRequest()..mergeFromBuffer(data, registry);
  factory CostServiceUpdateRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CostServiceUpdateRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CostServiceUpdateRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.finance.v1'),
      createEmptyInstance: CostServiceUpdateRequest.$_createMessage)
    ..aOM<$2.CommandContext>(1, _omitFieldNames ? '' : 'context',
        subBuilder: $2.CommandContext.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(3, _omitFieldNames ? '' : 'costItemId')
    ..aOM<$2.Money>(4, _omitFieldNames ? '' : 'amount',
        subBuilder: $2.Money.$_createMessage)
    ..aOS(5, _omitFieldNames ? '' : 'description')
    ..aOS(6, _omitFieldNames ? '' : 'costType')
    ..aE<$2.SourceClass>(7, _omitFieldNames ? '' : 'sourceClass',
        enumValues: $2.SourceClass.values)
    ..aE<CostState>(8, _omitFieldNames ? '' : 'costState',
        enumValues: CostState.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CostServiceUpdateRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CostServiceUpdateRequest copyWith(
          void Function(CostServiceUpdateRequest) updates) =>
      super.copyWith((message) => updates(message as CostServiceUpdateRequest))
          as CostServiceUpdateRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use CostServiceUpdateRequest() / CostServiceUpdateRequest.new instead')
  static CostServiceUpdateRequest create() => CostServiceUpdateRequest._();
  static $pb.GeneratedMessage $_createMessage() => CostServiceUpdateRequest._();
  @$core.override
  CostServiceUpdateRequest createEmptyInstance() =>
      CostServiceUpdateRequest._();
  @$core.pragma('dart2js:noInline')
  static CostServiceUpdateRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CostServiceUpdateRequest>(
          CostServiceUpdateRequest.$_createMessage);
  static CostServiceUpdateRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $2.CommandContext get context => $_getN(0);
  @$pb.TagNumber(1)
  set context($2.CommandContext value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasContext() => $_has(0);
  @$pb.TagNumber(1)
  void clearContext() => $_clearField(1);
  @$pb.TagNumber(1)
  $2.CommandContext ensureContext() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get workspaceId => $_getSZ(1);
  @$pb.TagNumber(2)
  set workspaceId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasWorkspaceId() => $_has(1);
  @$pb.TagNumber(2)
  void clearWorkspaceId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get costItemId => $_getSZ(2);
  @$pb.TagNumber(3)
  set costItemId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasCostItemId() => $_has(2);
  @$pb.TagNumber(3)
  void clearCostItemId() => $_clearField(3);

  @$pb.TagNumber(4)
  $2.Money get amount => $_getN(3);
  @$pb.TagNumber(4)
  set amount($2.Money value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasAmount() => $_has(3);
  @$pb.TagNumber(4)
  void clearAmount() => $_clearField(4);
  @$pb.TagNumber(4)
  $2.Money ensureAmount() => $_ensure(3);

  @$pb.TagNumber(5)
  $core.String get description => $_getSZ(4);
  @$pb.TagNumber(5)
  set description($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasDescription() => $_has(4);
  @$pb.TagNumber(5)
  void clearDescription() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get costType => $_getSZ(5);
  @$pb.TagNumber(6)
  set costType($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasCostType() => $_has(5);
  @$pb.TagNumber(6)
  void clearCostType() => $_clearField(6);

  @$pb.TagNumber(7)
  $2.SourceClass get sourceClass => $_getN(6);
  @$pb.TagNumber(7)
  set sourceClass($2.SourceClass value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasSourceClass() => $_has(6);
  @$pb.TagNumber(7)
  void clearSourceClass() => $_clearField(7);

  @$pb.TagNumber(8)
  CostState get costState => $_getN(7);
  @$pb.TagNumber(8)
  set costState(CostState value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasCostState() => $_has(7);
  @$pb.TagNumber(8)
  void clearCostState() => $_clearField(8);
}

class CostServiceUpdateResponse extends $pb.GeneratedMessage {
  factory CostServiceUpdateResponse({
    CostItem? costItem,
  }) {
    final result = CostServiceUpdateResponse._();
    if (costItem != null) result.costItem = costItem;
    return result;
  }

  CostServiceUpdateResponse._();

  factory CostServiceUpdateResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CostServiceUpdateResponse()..mergeFromBuffer(data, registry);
  factory CostServiceUpdateResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CostServiceUpdateResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CostServiceUpdateResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.finance.v1'),
      createEmptyInstance: CostServiceUpdateResponse.$_createMessage)
    ..aOM<CostItem>(1, _omitFieldNames ? '' : 'costItem',
        subBuilder: CostItem.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CostServiceUpdateResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CostServiceUpdateResponse copyWith(
          void Function(CostServiceUpdateResponse) updates) =>
      super.copyWith((message) => updates(message as CostServiceUpdateResponse))
          as CostServiceUpdateResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use CostServiceUpdateResponse() / CostServiceUpdateResponse.new instead')
  static CostServiceUpdateResponse create() => CostServiceUpdateResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      CostServiceUpdateResponse._();
  @$core.override
  CostServiceUpdateResponse createEmptyInstance() =>
      CostServiceUpdateResponse._();
  @$core.pragma('dart2js:noInline')
  static CostServiceUpdateResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CostServiceUpdateResponse>(
          CostServiceUpdateResponse.$_createMessage);
  static CostServiceUpdateResponse? _defaultInstance;

  @$pb.TagNumber(1)
  CostItem get costItem => $_getN(0);
  @$pb.TagNumber(1)
  set costItem(CostItem value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasCostItem() => $_has(0);
  @$pb.TagNumber(1)
  void clearCostItem() => $_clearField(1);
  @$pb.TagNumber(1)
  CostItem ensureCostItem() => $_ensure(0);
}

/// CostService/Delete
class CostServiceDeleteRequest extends $pb.GeneratedMessage {
  factory CostServiceDeleteRequest({
    $2.CommandContext? context,
    $core.String? workspaceId,
    $core.String? costItemId,
  }) {
    final result = CostServiceDeleteRequest._();
    if (context != null) result.context = context;
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (costItemId != null) result.costItemId = costItemId;
    return result;
  }

  CostServiceDeleteRequest._();

  factory CostServiceDeleteRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CostServiceDeleteRequest()..mergeFromBuffer(data, registry);
  factory CostServiceDeleteRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CostServiceDeleteRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CostServiceDeleteRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.finance.v1'),
      createEmptyInstance: CostServiceDeleteRequest.$_createMessage)
    ..aOM<$2.CommandContext>(1, _omitFieldNames ? '' : 'context',
        subBuilder: $2.CommandContext.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(3, _omitFieldNames ? '' : 'costItemId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CostServiceDeleteRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CostServiceDeleteRequest copyWith(
          void Function(CostServiceDeleteRequest) updates) =>
      super.copyWith((message) => updates(message as CostServiceDeleteRequest))
          as CostServiceDeleteRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use CostServiceDeleteRequest() / CostServiceDeleteRequest.new instead')
  static CostServiceDeleteRequest create() => CostServiceDeleteRequest._();
  static $pb.GeneratedMessage $_createMessage() => CostServiceDeleteRequest._();
  @$core.override
  CostServiceDeleteRequest createEmptyInstance() =>
      CostServiceDeleteRequest._();
  @$core.pragma('dart2js:noInline')
  static CostServiceDeleteRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CostServiceDeleteRequest>(
          CostServiceDeleteRequest.$_createMessage);
  static CostServiceDeleteRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $2.CommandContext get context => $_getN(0);
  @$pb.TagNumber(1)
  set context($2.CommandContext value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasContext() => $_has(0);
  @$pb.TagNumber(1)
  void clearContext() => $_clearField(1);
  @$pb.TagNumber(1)
  $2.CommandContext ensureContext() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get workspaceId => $_getSZ(1);
  @$pb.TagNumber(2)
  set workspaceId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasWorkspaceId() => $_has(1);
  @$pb.TagNumber(2)
  void clearWorkspaceId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get costItemId => $_getSZ(2);
  @$pb.TagNumber(3)
  set costItemId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasCostItemId() => $_has(2);
  @$pb.TagNumber(3)
  void clearCostItemId() => $_clearField(3);
}

class CostServiceDeleteResponse extends $pb.GeneratedMessage {
  factory CostServiceDeleteResponse({
    $core.bool? success,
  }) {
    final result = CostServiceDeleteResponse._();
    if (success != null) result.success = success;
    return result;
  }

  CostServiceDeleteResponse._();

  factory CostServiceDeleteResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CostServiceDeleteResponse()..mergeFromBuffer(data, registry);
  factory CostServiceDeleteResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CostServiceDeleteResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CostServiceDeleteResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.finance.v1'),
      createEmptyInstance: CostServiceDeleteResponse.$_createMessage)
    ..aOB(1, _omitFieldNames ? '' : 'success')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CostServiceDeleteResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CostServiceDeleteResponse copyWith(
          void Function(CostServiceDeleteResponse) updates) =>
      super.copyWith((message) => updates(message as CostServiceDeleteResponse))
          as CostServiceDeleteResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use CostServiceDeleteResponse() / CostServiceDeleteResponse.new instead')
  static CostServiceDeleteResponse create() => CostServiceDeleteResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      CostServiceDeleteResponse._();
  @$core.override
  CostServiceDeleteResponse createEmptyInstance() =>
      CostServiceDeleteResponse._();
  @$core.pragma('dart2js:noInline')
  static CostServiceDeleteResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CostServiceDeleteResponse>(
          CostServiceDeleteResponse.$_createMessage);
  static CostServiceDeleteResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get success => $_getBF(0);
  @$pb.TagNumber(1)
  set success($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSuccess() => $_has(0);
  @$pb.TagNumber(1)
  void clearSuccess() => $_clearField(1);
}

class ReconciliationServiceQueueRequest extends $pb.GeneratedMessage {
  factory ReconciliationServiceQueueRequest({
    $2.CommandContext? context,
    $core.String? workspaceId,
    $core.String? scopeType,
    $core.String? scopeDescription,
    $core.Iterable<$core.String>? orderIds,
    $core.Iterable<$core.String>? settlementIds,
    $core.String? periodStart,
    $core.String? periodEnd,
  }) {
    final result = ReconciliationServiceQueueRequest._();
    if (context != null) result.context = context;
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (scopeType != null) result.scopeType = scopeType;
    if (scopeDescription != null) result.scopeDescription = scopeDescription;
    if (orderIds != null) result.orderIds.addAll(orderIds);
    if (settlementIds != null) result.settlementIds.addAll(settlementIds);
    if (periodStart != null) result.periodStart = periodStart;
    if (periodEnd != null) result.periodEnd = periodEnd;
    return result;
  }

  ReconciliationServiceQueueRequest._();

  factory ReconciliationServiceQueueRequest.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ReconciliationServiceQueueRequest()..mergeFromBuffer(data, registry);
  factory ReconciliationServiceQueueRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ReconciliationServiceQueueRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ReconciliationServiceQueueRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.finance.v1'),
      createEmptyInstance: ReconciliationServiceQueueRequest.$_createMessage)
    ..aOM<$2.CommandContext>(1, _omitFieldNames ? '' : 'context',
        subBuilder: $2.CommandContext.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(3, _omitFieldNames ? '' : 'scopeType')
    ..aOS(4, _omitFieldNames ? '' : 'scopeDescription')
    ..pPS(5, _omitFieldNames ? '' : 'orderIds')
    ..pPS(6, _omitFieldNames ? '' : 'settlementIds')
    ..aOS(7, _omitFieldNames ? '' : 'periodStart')
    ..aOS(8, _omitFieldNames ? '' : 'periodEnd')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReconciliationServiceQueueRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReconciliationServiceQueueRequest copyWith(
          void Function(ReconciliationServiceQueueRequest) updates) =>
      super.copyWith((message) =>
              updates(message as ReconciliationServiceQueueRequest))
          as ReconciliationServiceQueueRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ReconciliationServiceQueueRequest() / ReconciliationServiceQueueRequest.new instead')
  static ReconciliationServiceQueueRequest create() =>
      ReconciliationServiceQueueRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      ReconciliationServiceQueueRequest._();
  @$core.override
  ReconciliationServiceQueueRequest createEmptyInstance() =>
      ReconciliationServiceQueueRequest._();
  @$core.pragma('dart2js:noInline')
  static ReconciliationServiceQueueRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ReconciliationServiceQueueRequest>(
          ReconciliationServiceQueueRequest.$_createMessage);
  static ReconciliationServiceQueueRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $2.CommandContext get context => $_getN(0);
  @$pb.TagNumber(1)
  set context($2.CommandContext value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasContext() => $_has(0);
  @$pb.TagNumber(1)
  void clearContext() => $_clearField(1);
  @$pb.TagNumber(1)
  $2.CommandContext ensureContext() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get workspaceId => $_getSZ(1);
  @$pb.TagNumber(2)
  set workspaceId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasWorkspaceId() => $_has(1);
  @$pb.TagNumber(2)
  void clearWorkspaceId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get scopeType => $_getSZ(2);
  @$pb.TagNumber(3)
  set scopeType($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasScopeType() => $_has(2);
  @$pb.TagNumber(3)
  void clearScopeType() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get scopeDescription => $_getSZ(3);
  @$pb.TagNumber(4)
  set scopeDescription($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasScopeDescription() => $_has(3);
  @$pb.TagNumber(4)
  void clearScopeDescription() => $_clearField(4);

  @$pb.TagNumber(5)
  $pb.PbList<$core.String> get orderIds => $_getList(4);

  @$pb.TagNumber(6)
  $pb.PbList<$core.String> get settlementIds => $_getList(5);

  @$pb.TagNumber(7)
  $core.String get periodStart => $_getSZ(6);
  @$pb.TagNumber(7)
  set periodStart($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasPeriodStart() => $_has(6);
  @$pb.TagNumber(7)
  void clearPeriodStart() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get periodEnd => $_getSZ(7);
  @$pb.TagNumber(8)
  set periodEnd($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasPeriodEnd() => $_has(7);
  @$pb.TagNumber(8)
  void clearPeriodEnd() => $_clearField(8);
}

class ReconciliationServiceQueueResponse extends $pb.GeneratedMessage {
  factory ReconciliationServiceQueueResponse({
    ReconciliationRecord? record,
  }) {
    final result = ReconciliationServiceQueueResponse._();
    if (record != null) result.record = record;
    return result;
  }

  ReconciliationServiceQueueResponse._();

  factory ReconciliationServiceQueueResponse.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ReconciliationServiceQueueResponse()..mergeFromBuffer(data, registry);
  factory ReconciliationServiceQueueResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ReconciliationServiceQueueResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ReconciliationServiceQueueResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.finance.v1'),
      createEmptyInstance: ReconciliationServiceQueueResponse.$_createMessage)
    ..aOM<ReconciliationRecord>(1, _omitFieldNames ? '' : 'record',
        subBuilder: ReconciliationRecord.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReconciliationServiceQueueResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReconciliationServiceQueueResponse copyWith(
          void Function(ReconciliationServiceQueueResponse) updates) =>
      super.copyWith((message) =>
              updates(message as ReconciliationServiceQueueResponse))
          as ReconciliationServiceQueueResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ReconciliationServiceQueueResponse() / ReconciliationServiceQueueResponse.new instead')
  static ReconciliationServiceQueueResponse create() =>
      ReconciliationServiceQueueResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      ReconciliationServiceQueueResponse._();
  @$core.override
  ReconciliationServiceQueueResponse createEmptyInstance() =>
      ReconciliationServiceQueueResponse._();
  @$core.pragma('dart2js:noInline')
  static ReconciliationServiceQueueResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ReconciliationServiceQueueResponse>(
          ReconciliationServiceQueueResponse.$_createMessage);
  static ReconciliationServiceQueueResponse? _defaultInstance;

  @$pb.TagNumber(1)
  ReconciliationRecord get record => $_getN(0);
  @$pb.TagNumber(1)
  set record(ReconciliationRecord value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasRecord() => $_has(0);
  @$pb.TagNumber(1)
  void clearRecord() => $_clearField(1);
  @$pb.TagNumber(1)
  ReconciliationRecord ensureRecord() => $_ensure(0);
}

class ReconciliationServiceMatchRequest extends $pb.GeneratedMessage {
  factory ReconciliationServiceMatchRequest({
    $2.CommandContext? context,
    $core.String? workspaceId,
    $core.String? settlementId,
    $core.String? lineId,
    $core.String? orderId,
    $2.Money? allocationAmount,
    $core.String? recordId,
  }) {
    final result = ReconciliationServiceMatchRequest._();
    if (context != null) result.context = context;
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (settlementId != null) result.settlementId = settlementId;
    if (lineId != null) result.lineId = lineId;
    if (orderId != null) result.orderId = orderId;
    if (allocationAmount != null) result.allocationAmount = allocationAmount;
    if (recordId != null) result.recordId = recordId;
    return result;
  }

  ReconciliationServiceMatchRequest._();

  factory ReconciliationServiceMatchRequest.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ReconciliationServiceMatchRequest()..mergeFromBuffer(data, registry);
  factory ReconciliationServiceMatchRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ReconciliationServiceMatchRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ReconciliationServiceMatchRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.finance.v1'),
      createEmptyInstance: ReconciliationServiceMatchRequest.$_createMessage)
    ..aOM<$2.CommandContext>(1, _omitFieldNames ? '' : 'context',
        subBuilder: $2.CommandContext.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(3, _omitFieldNames ? '' : 'settlementId')
    ..aOS(4, _omitFieldNames ? '' : 'lineId')
    ..aOS(5, _omitFieldNames ? '' : 'orderId')
    ..aOM<$2.Money>(6, _omitFieldNames ? '' : 'allocationAmount',
        subBuilder: $2.Money.$_createMessage)
    ..aOS(7, _omitFieldNames ? '' : 'recordId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReconciliationServiceMatchRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReconciliationServiceMatchRequest copyWith(
          void Function(ReconciliationServiceMatchRequest) updates) =>
      super.copyWith((message) =>
              updates(message as ReconciliationServiceMatchRequest))
          as ReconciliationServiceMatchRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ReconciliationServiceMatchRequest() / ReconciliationServiceMatchRequest.new instead')
  static ReconciliationServiceMatchRequest create() =>
      ReconciliationServiceMatchRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      ReconciliationServiceMatchRequest._();
  @$core.override
  ReconciliationServiceMatchRequest createEmptyInstance() =>
      ReconciliationServiceMatchRequest._();
  @$core.pragma('dart2js:noInline')
  static ReconciliationServiceMatchRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ReconciliationServiceMatchRequest>(
          ReconciliationServiceMatchRequest.$_createMessage);
  static ReconciliationServiceMatchRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $2.CommandContext get context => $_getN(0);
  @$pb.TagNumber(1)
  set context($2.CommandContext value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasContext() => $_has(0);
  @$pb.TagNumber(1)
  void clearContext() => $_clearField(1);
  @$pb.TagNumber(1)
  $2.CommandContext ensureContext() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get workspaceId => $_getSZ(1);
  @$pb.TagNumber(2)
  set workspaceId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasWorkspaceId() => $_has(1);
  @$pb.TagNumber(2)
  void clearWorkspaceId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get settlementId => $_getSZ(2);
  @$pb.TagNumber(3)
  set settlementId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasSettlementId() => $_has(2);
  @$pb.TagNumber(3)
  void clearSettlementId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get lineId => $_getSZ(3);
  @$pb.TagNumber(4)
  set lineId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasLineId() => $_has(3);
  @$pb.TagNumber(4)
  void clearLineId() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get orderId => $_getSZ(4);
  @$pb.TagNumber(5)
  set orderId($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasOrderId() => $_has(4);
  @$pb.TagNumber(5)
  void clearOrderId() => $_clearField(5);

  @$pb.TagNumber(6)
  $2.Money get allocationAmount => $_getN(5);
  @$pb.TagNumber(6)
  set allocationAmount($2.Money value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasAllocationAmount() => $_has(5);
  @$pb.TagNumber(6)
  void clearAllocationAmount() => $_clearField(6);
  @$pb.TagNumber(6)
  $2.Money ensureAllocationAmount() => $_ensure(5);

  @$pb.TagNumber(7)
  $core.String get recordId => $_getSZ(6);
  @$pb.TagNumber(7)
  set recordId($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasRecordId() => $_has(6);
  @$pb.TagNumber(7)
  void clearRecordId() => $_clearField(7);
}

class ReconciliationServiceMatchResponse extends $pb.GeneratedMessage {
  factory ReconciliationServiceMatchResponse({
    $core.bool? success,
    SettlementLine? line,
    ReconciliationState? orderReconciliationState,
    $2.Money? lineRemainingCapacity,
    $2.Money? orderRemainingCapacity,
    ReconciliationRecord? record,
    ReconciliationMatch? match,
  }) {
    final result = ReconciliationServiceMatchResponse._();
    if (success != null) result.success = success;
    if (line != null) result.line = line;
    if (orderReconciliationState != null)
      result.orderReconciliationState = orderReconciliationState;
    if (lineRemainingCapacity != null)
      result.lineRemainingCapacity = lineRemainingCapacity;
    if (orderRemainingCapacity != null)
      result.orderRemainingCapacity = orderRemainingCapacity;
    if (record != null) result.record = record;
    if (match != null) result.match = match;
    return result;
  }

  ReconciliationServiceMatchResponse._();

  factory ReconciliationServiceMatchResponse.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ReconciliationServiceMatchResponse()..mergeFromBuffer(data, registry);
  factory ReconciliationServiceMatchResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ReconciliationServiceMatchResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ReconciliationServiceMatchResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.finance.v1'),
      createEmptyInstance: ReconciliationServiceMatchResponse.$_createMessage)
    ..aOB(1, _omitFieldNames ? '' : 'success')
    ..aOM<SettlementLine>(2, _omitFieldNames ? '' : 'line',
        subBuilder: SettlementLine.$_createMessage)
    ..aE<ReconciliationState>(
        3, _omitFieldNames ? '' : 'orderReconciliationState',
        enumValues: ReconciliationState.values)
    ..aOM<$2.Money>(4, _omitFieldNames ? '' : 'lineRemainingCapacity',
        subBuilder: $2.Money.$_createMessage)
    ..aOM<$2.Money>(5, _omitFieldNames ? '' : 'orderRemainingCapacity',
        subBuilder: $2.Money.$_createMessage)
    ..aOM<ReconciliationRecord>(6, _omitFieldNames ? '' : 'record',
        subBuilder: ReconciliationRecord.$_createMessage)
    ..aOM<ReconciliationMatch>(7, _omitFieldNames ? '' : 'match',
        subBuilder: ReconciliationMatch.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReconciliationServiceMatchResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReconciliationServiceMatchResponse copyWith(
          void Function(ReconciliationServiceMatchResponse) updates) =>
      super.copyWith((message) =>
              updates(message as ReconciliationServiceMatchResponse))
          as ReconciliationServiceMatchResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ReconciliationServiceMatchResponse() / ReconciliationServiceMatchResponse.new instead')
  static ReconciliationServiceMatchResponse create() =>
      ReconciliationServiceMatchResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      ReconciliationServiceMatchResponse._();
  @$core.override
  ReconciliationServiceMatchResponse createEmptyInstance() =>
      ReconciliationServiceMatchResponse._();
  @$core.pragma('dart2js:noInline')
  static ReconciliationServiceMatchResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ReconciliationServiceMatchResponse>(
          ReconciliationServiceMatchResponse.$_createMessage);
  static ReconciliationServiceMatchResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get success => $_getBF(0);
  @$pb.TagNumber(1)
  set success($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSuccess() => $_has(0);
  @$pb.TagNumber(1)
  void clearSuccess() => $_clearField(1);

  @$pb.TagNumber(2)
  SettlementLine get line => $_getN(1);
  @$pb.TagNumber(2)
  set line(SettlementLine value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasLine() => $_has(1);
  @$pb.TagNumber(2)
  void clearLine() => $_clearField(2);
  @$pb.TagNumber(2)
  SettlementLine ensureLine() => $_ensure(1);

  @$pb.TagNumber(3)
  ReconciliationState get orderReconciliationState => $_getN(2);
  @$pb.TagNumber(3)
  set orderReconciliationState(ReconciliationState value) =>
      $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasOrderReconciliationState() => $_has(2);
  @$pb.TagNumber(3)
  void clearOrderReconciliationState() => $_clearField(3);

  @$pb.TagNumber(4)
  $2.Money get lineRemainingCapacity => $_getN(3);
  @$pb.TagNumber(4)
  set lineRemainingCapacity($2.Money value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasLineRemainingCapacity() => $_has(3);
  @$pb.TagNumber(4)
  void clearLineRemainingCapacity() => $_clearField(4);
  @$pb.TagNumber(4)
  $2.Money ensureLineRemainingCapacity() => $_ensure(3);

  @$pb.TagNumber(5)
  $2.Money get orderRemainingCapacity => $_getN(4);
  @$pb.TagNumber(5)
  set orderRemainingCapacity($2.Money value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasOrderRemainingCapacity() => $_has(4);
  @$pb.TagNumber(5)
  void clearOrderRemainingCapacity() => $_clearField(5);
  @$pb.TagNumber(5)
  $2.Money ensureOrderRemainingCapacity() => $_ensure(4);

  @$pb.TagNumber(6)
  ReconciliationRecord get record => $_getN(5);
  @$pb.TagNumber(6)
  set record(ReconciliationRecord value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasRecord() => $_has(5);
  @$pb.TagNumber(6)
  void clearRecord() => $_clearField(6);
  @$pb.TagNumber(6)
  ReconciliationRecord ensureRecord() => $_ensure(5);

  @$pb.TagNumber(7)
  ReconciliationMatch get match => $_getN(6);
  @$pb.TagNumber(7)
  set match(ReconciliationMatch value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasMatch() => $_has(6);
  @$pb.TagNumber(7)
  void clearMatch() => $_clearField(7);
  @$pb.TagNumber(7)
  ReconciliationMatch ensureMatch() => $_ensure(6);
}

class ReconciliationServiceManualMatchRequest extends $pb.GeneratedMessage {
  factory ReconciliationServiceManualMatchRequest({
    $2.CommandContext? context,
    $core.String? workspaceId,
    $core.String? settlementId,
    $core.String? lineId,
    $core.String? orderId,
    $2.Money? allocationAmount,
    $core.String? recordId,
  }) {
    final result = ReconciliationServiceManualMatchRequest._();
    if (context != null) result.context = context;
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (settlementId != null) result.settlementId = settlementId;
    if (lineId != null) result.lineId = lineId;
    if (orderId != null) result.orderId = orderId;
    if (allocationAmount != null) result.allocationAmount = allocationAmount;
    if (recordId != null) result.recordId = recordId;
    return result;
  }

  ReconciliationServiceManualMatchRequest._();

  factory ReconciliationServiceManualMatchRequest.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ReconciliationServiceManualMatchRequest()
        ..mergeFromBuffer(data, registry);
  factory ReconciliationServiceManualMatchRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ReconciliationServiceManualMatchRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ReconciliationServiceManualMatchRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.finance.v1'),
      createEmptyInstance:
          ReconciliationServiceManualMatchRequest.$_createMessage)
    ..aOM<$2.CommandContext>(1, _omitFieldNames ? '' : 'context',
        subBuilder: $2.CommandContext.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(3, _omitFieldNames ? '' : 'settlementId')
    ..aOS(4, _omitFieldNames ? '' : 'lineId')
    ..aOS(5, _omitFieldNames ? '' : 'orderId')
    ..aOM<$2.Money>(6, _omitFieldNames ? '' : 'allocationAmount',
        subBuilder: $2.Money.$_createMessage)
    ..aOS(7, _omitFieldNames ? '' : 'recordId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReconciliationServiceManualMatchRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReconciliationServiceManualMatchRequest copyWith(
          void Function(ReconciliationServiceManualMatchRequest) updates) =>
      super.copyWith((message) =>
              updates(message as ReconciliationServiceManualMatchRequest))
          as ReconciliationServiceManualMatchRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ReconciliationServiceManualMatchRequest() / ReconciliationServiceManualMatchRequest.new instead')
  static ReconciliationServiceManualMatchRequest create() =>
      ReconciliationServiceManualMatchRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      ReconciliationServiceManualMatchRequest._();
  @$core.override
  ReconciliationServiceManualMatchRequest createEmptyInstance() =>
      ReconciliationServiceManualMatchRequest._();
  @$core.pragma('dart2js:noInline')
  static ReconciliationServiceManualMatchRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
              ReconciliationServiceManualMatchRequest>(
          ReconciliationServiceManualMatchRequest.$_createMessage);
  static ReconciliationServiceManualMatchRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $2.CommandContext get context => $_getN(0);
  @$pb.TagNumber(1)
  set context($2.CommandContext value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasContext() => $_has(0);
  @$pb.TagNumber(1)
  void clearContext() => $_clearField(1);
  @$pb.TagNumber(1)
  $2.CommandContext ensureContext() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get workspaceId => $_getSZ(1);
  @$pb.TagNumber(2)
  set workspaceId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasWorkspaceId() => $_has(1);
  @$pb.TagNumber(2)
  void clearWorkspaceId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get settlementId => $_getSZ(2);
  @$pb.TagNumber(3)
  set settlementId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasSettlementId() => $_has(2);
  @$pb.TagNumber(3)
  void clearSettlementId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get lineId => $_getSZ(3);
  @$pb.TagNumber(4)
  set lineId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasLineId() => $_has(3);
  @$pb.TagNumber(4)
  void clearLineId() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get orderId => $_getSZ(4);
  @$pb.TagNumber(5)
  set orderId($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasOrderId() => $_has(4);
  @$pb.TagNumber(5)
  void clearOrderId() => $_clearField(5);

  @$pb.TagNumber(6)
  $2.Money get allocationAmount => $_getN(5);
  @$pb.TagNumber(6)
  set allocationAmount($2.Money value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasAllocationAmount() => $_has(5);
  @$pb.TagNumber(6)
  void clearAllocationAmount() => $_clearField(6);
  @$pb.TagNumber(6)
  $2.Money ensureAllocationAmount() => $_ensure(5);

  @$pb.TagNumber(7)
  $core.String get recordId => $_getSZ(6);
  @$pb.TagNumber(7)
  set recordId($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasRecordId() => $_has(6);
  @$pb.TagNumber(7)
  void clearRecordId() => $_clearField(7);
}

class ReconciliationServiceManualMatchResponse extends $pb.GeneratedMessage {
  factory ReconciliationServiceManualMatchResponse({
    $core.bool? success,
    SettlementLine? line,
    ReconciliationState? orderReconciliationState,
    $2.Money? lineRemainingCapacity,
    $2.Money? orderRemainingCapacity,
    ReconciliationRecord? record,
    ReconciliationMatch? match,
  }) {
    final result = ReconciliationServiceManualMatchResponse._();
    if (success != null) result.success = success;
    if (line != null) result.line = line;
    if (orderReconciliationState != null)
      result.orderReconciliationState = orderReconciliationState;
    if (lineRemainingCapacity != null)
      result.lineRemainingCapacity = lineRemainingCapacity;
    if (orderRemainingCapacity != null)
      result.orderRemainingCapacity = orderRemainingCapacity;
    if (record != null) result.record = record;
    if (match != null) result.match = match;
    return result;
  }

  ReconciliationServiceManualMatchResponse._();

  factory ReconciliationServiceManualMatchResponse.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ReconciliationServiceManualMatchResponse()
        ..mergeFromBuffer(data, registry);
  factory ReconciliationServiceManualMatchResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ReconciliationServiceManualMatchResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ReconciliationServiceManualMatchResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.finance.v1'),
      createEmptyInstance:
          ReconciliationServiceManualMatchResponse.$_createMessage)
    ..aOB(1, _omitFieldNames ? '' : 'success')
    ..aOM<SettlementLine>(2, _omitFieldNames ? '' : 'line',
        subBuilder: SettlementLine.$_createMessage)
    ..aE<ReconciliationState>(
        3, _omitFieldNames ? '' : 'orderReconciliationState',
        enumValues: ReconciliationState.values)
    ..aOM<$2.Money>(4, _omitFieldNames ? '' : 'lineRemainingCapacity',
        subBuilder: $2.Money.$_createMessage)
    ..aOM<$2.Money>(5, _omitFieldNames ? '' : 'orderRemainingCapacity',
        subBuilder: $2.Money.$_createMessage)
    ..aOM<ReconciliationRecord>(6, _omitFieldNames ? '' : 'record',
        subBuilder: ReconciliationRecord.$_createMessage)
    ..aOM<ReconciliationMatch>(7, _omitFieldNames ? '' : 'match',
        subBuilder: ReconciliationMatch.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReconciliationServiceManualMatchResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReconciliationServiceManualMatchResponse copyWith(
          void Function(ReconciliationServiceManualMatchResponse) updates) =>
      super.copyWith((message) =>
              updates(message as ReconciliationServiceManualMatchResponse))
          as ReconciliationServiceManualMatchResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ReconciliationServiceManualMatchResponse() / ReconciliationServiceManualMatchResponse.new instead')
  static ReconciliationServiceManualMatchResponse create() =>
      ReconciliationServiceManualMatchResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      ReconciliationServiceManualMatchResponse._();
  @$core.override
  ReconciliationServiceManualMatchResponse createEmptyInstance() =>
      ReconciliationServiceManualMatchResponse._();
  @$core.pragma('dart2js:noInline')
  static ReconciliationServiceManualMatchResponse getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
              ReconciliationServiceManualMatchResponse>(
          ReconciliationServiceManualMatchResponse.$_createMessage);
  static ReconciliationServiceManualMatchResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get success => $_getBF(0);
  @$pb.TagNumber(1)
  set success($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSuccess() => $_has(0);
  @$pb.TagNumber(1)
  void clearSuccess() => $_clearField(1);

  @$pb.TagNumber(2)
  SettlementLine get line => $_getN(1);
  @$pb.TagNumber(2)
  set line(SettlementLine value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasLine() => $_has(1);
  @$pb.TagNumber(2)
  void clearLine() => $_clearField(2);
  @$pb.TagNumber(2)
  SettlementLine ensureLine() => $_ensure(1);

  @$pb.TagNumber(3)
  ReconciliationState get orderReconciliationState => $_getN(2);
  @$pb.TagNumber(3)
  set orderReconciliationState(ReconciliationState value) =>
      $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasOrderReconciliationState() => $_has(2);
  @$pb.TagNumber(3)
  void clearOrderReconciliationState() => $_clearField(3);

  @$pb.TagNumber(4)
  $2.Money get lineRemainingCapacity => $_getN(3);
  @$pb.TagNumber(4)
  set lineRemainingCapacity($2.Money value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasLineRemainingCapacity() => $_has(3);
  @$pb.TagNumber(4)
  void clearLineRemainingCapacity() => $_clearField(4);
  @$pb.TagNumber(4)
  $2.Money ensureLineRemainingCapacity() => $_ensure(3);

  @$pb.TagNumber(5)
  $2.Money get orderRemainingCapacity => $_getN(4);
  @$pb.TagNumber(5)
  set orderRemainingCapacity($2.Money value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasOrderRemainingCapacity() => $_has(4);
  @$pb.TagNumber(5)
  void clearOrderRemainingCapacity() => $_clearField(5);
  @$pb.TagNumber(5)
  $2.Money ensureOrderRemainingCapacity() => $_ensure(4);

  @$pb.TagNumber(6)
  ReconciliationRecord get record => $_getN(5);
  @$pb.TagNumber(6)
  set record(ReconciliationRecord value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasRecord() => $_has(5);
  @$pb.TagNumber(6)
  void clearRecord() => $_clearField(6);
  @$pb.TagNumber(6)
  ReconciliationRecord ensureRecord() => $_ensure(5);

  @$pb.TagNumber(7)
  ReconciliationMatch get match => $_getN(6);
  @$pb.TagNumber(7)
  set match(ReconciliationMatch value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasMatch() => $_has(6);
  @$pb.TagNumber(7)
  void clearMatch() => $_clearField(7);
  @$pb.TagNumber(7)
  ReconciliationMatch ensureMatch() => $_ensure(6);
}

class ReconciliationServiceOverrideRequest extends $pb.GeneratedMessage {
  factory ReconciliationServiceOverrideRequest({
    $2.CommandContext? context,
    $core.String? workspaceId,
    $core.String? recordId,
    $core.String? decision,
    $core.String? reason,
    $core.Iterable<$core.String>? evidenceIds,
  }) {
    final result = ReconciliationServiceOverrideRequest._();
    if (context != null) result.context = context;
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (recordId != null) result.recordId = recordId;
    if (decision != null) result.decision = decision;
    if (reason != null) result.reason = reason;
    if (evidenceIds != null) result.evidenceIds.addAll(evidenceIds);
    return result;
  }

  ReconciliationServiceOverrideRequest._();

  factory ReconciliationServiceOverrideRequest.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ReconciliationServiceOverrideRequest()..mergeFromBuffer(data, registry);
  factory ReconciliationServiceOverrideRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ReconciliationServiceOverrideRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ReconciliationServiceOverrideRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.finance.v1'),
      createEmptyInstance: ReconciliationServiceOverrideRequest.$_createMessage)
    ..aOM<$2.CommandContext>(1, _omitFieldNames ? '' : 'context',
        subBuilder: $2.CommandContext.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(3, _omitFieldNames ? '' : 'recordId')
    ..aOS(4, _omitFieldNames ? '' : 'decision')
    ..aOS(5, _omitFieldNames ? '' : 'reason')
    ..pPS(6, _omitFieldNames ? '' : 'evidenceIds')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReconciliationServiceOverrideRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReconciliationServiceOverrideRequest copyWith(
          void Function(ReconciliationServiceOverrideRequest) updates) =>
      super.copyWith((message) =>
              updates(message as ReconciliationServiceOverrideRequest))
          as ReconciliationServiceOverrideRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ReconciliationServiceOverrideRequest() / ReconciliationServiceOverrideRequest.new instead')
  static ReconciliationServiceOverrideRequest create() =>
      ReconciliationServiceOverrideRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      ReconciliationServiceOverrideRequest._();
  @$core.override
  ReconciliationServiceOverrideRequest createEmptyInstance() =>
      ReconciliationServiceOverrideRequest._();
  @$core.pragma('dart2js:noInline')
  static ReconciliationServiceOverrideRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
              ReconciliationServiceOverrideRequest>(
          ReconciliationServiceOverrideRequest.$_createMessage);
  static ReconciliationServiceOverrideRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $2.CommandContext get context => $_getN(0);
  @$pb.TagNumber(1)
  set context($2.CommandContext value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasContext() => $_has(0);
  @$pb.TagNumber(1)
  void clearContext() => $_clearField(1);
  @$pb.TagNumber(1)
  $2.CommandContext ensureContext() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get workspaceId => $_getSZ(1);
  @$pb.TagNumber(2)
  set workspaceId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasWorkspaceId() => $_has(1);
  @$pb.TagNumber(2)
  void clearWorkspaceId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get recordId => $_getSZ(2);
  @$pb.TagNumber(3)
  set recordId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasRecordId() => $_has(2);
  @$pb.TagNumber(3)
  void clearRecordId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get decision => $_getSZ(3);
  @$pb.TagNumber(4)
  set decision($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasDecision() => $_has(3);
  @$pb.TagNumber(4)
  void clearDecision() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get reason => $_getSZ(4);
  @$pb.TagNumber(5)
  set reason($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasReason() => $_has(4);
  @$pb.TagNumber(5)
  void clearReason() => $_clearField(5);

  @$pb.TagNumber(6)
  $pb.PbList<$core.String> get evidenceIds => $_getList(5);
}

class ReconciliationServiceOverrideResponse extends $pb.GeneratedMessage {
  factory ReconciliationServiceOverrideResponse({
    ReconciliationRecord? record,
  }) {
    final result = ReconciliationServiceOverrideResponse._();
    if (record != null) result.record = record;
    return result;
  }

  ReconciliationServiceOverrideResponse._();

  factory ReconciliationServiceOverrideResponse.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ReconciliationServiceOverrideResponse()..mergeFromBuffer(data, registry);
  factory ReconciliationServiceOverrideResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ReconciliationServiceOverrideResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ReconciliationServiceOverrideResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.finance.v1'),
      createEmptyInstance:
          ReconciliationServiceOverrideResponse.$_createMessage)
    ..aOM<ReconciliationRecord>(1, _omitFieldNames ? '' : 'record',
        subBuilder: ReconciliationRecord.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReconciliationServiceOverrideResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReconciliationServiceOverrideResponse copyWith(
          void Function(ReconciliationServiceOverrideResponse) updates) =>
      super.copyWith((message) =>
              updates(message as ReconciliationServiceOverrideResponse))
          as ReconciliationServiceOverrideResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ReconciliationServiceOverrideResponse() / ReconciliationServiceOverrideResponse.new instead')
  static ReconciliationServiceOverrideResponse create() =>
      ReconciliationServiceOverrideResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      ReconciliationServiceOverrideResponse._();
  @$core.override
  ReconciliationServiceOverrideResponse createEmptyInstance() =>
      ReconciliationServiceOverrideResponse._();
  @$core.pragma('dart2js:noInline')
  static ReconciliationServiceOverrideResponse getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
              ReconciliationServiceOverrideResponse>(
          ReconciliationServiceOverrideResponse.$_createMessage);
  static ReconciliationServiceOverrideResponse? _defaultInstance;

  @$pb.TagNumber(1)
  ReconciliationRecord get record => $_getN(0);
  @$pb.TagNumber(1)
  set record(ReconciliationRecord value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasRecord() => $_has(0);
  @$pb.TagNumber(1)
  void clearRecord() => $_clearField(1);
  @$pb.TagNumber(1)
  ReconciliationRecord ensureRecord() => $_ensure(0);
}

class ReconciliationServiceGetRecordRequest extends $pb.GeneratedMessage {
  factory ReconciliationServiceGetRecordRequest({
    $core.String? workspaceId,
    $core.String? recordId,
  }) {
    final result = ReconciliationServiceGetRecordRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (recordId != null) result.recordId = recordId;
    return result;
  }

  ReconciliationServiceGetRecordRequest._();

  factory ReconciliationServiceGetRecordRequest.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ReconciliationServiceGetRecordRequest()..mergeFromBuffer(data, registry);
  factory ReconciliationServiceGetRecordRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ReconciliationServiceGetRecordRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ReconciliationServiceGetRecordRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.finance.v1'),
      createEmptyInstance:
          ReconciliationServiceGetRecordRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'recordId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReconciliationServiceGetRecordRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReconciliationServiceGetRecordRequest copyWith(
          void Function(ReconciliationServiceGetRecordRequest) updates) =>
      super.copyWith((message) =>
              updates(message as ReconciliationServiceGetRecordRequest))
          as ReconciliationServiceGetRecordRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ReconciliationServiceGetRecordRequest() / ReconciliationServiceGetRecordRequest.new instead')
  static ReconciliationServiceGetRecordRequest create() =>
      ReconciliationServiceGetRecordRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      ReconciliationServiceGetRecordRequest._();
  @$core.override
  ReconciliationServiceGetRecordRequest createEmptyInstance() =>
      ReconciliationServiceGetRecordRequest._();
  @$core.pragma('dart2js:noInline')
  static ReconciliationServiceGetRecordRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
              ReconciliationServiceGetRecordRequest>(
          ReconciliationServiceGetRecordRequest.$_createMessage);
  static ReconciliationServiceGetRecordRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get recordId => $_getSZ(1);
  @$pb.TagNumber(2)
  set recordId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasRecordId() => $_has(1);
  @$pb.TagNumber(2)
  void clearRecordId() => $_clearField(2);
}

class ReconciliationServiceGetRecordResponse extends $pb.GeneratedMessage {
  factory ReconciliationServiceGetRecordResponse({
    ReconciliationRecord? record,
    $core.Iterable<ReconciliationMatch>? matches,
  }) {
    final result = ReconciliationServiceGetRecordResponse._();
    if (record != null) result.record = record;
    if (matches != null) result.matches.addAll(matches);
    return result;
  }

  ReconciliationServiceGetRecordResponse._();

  factory ReconciliationServiceGetRecordResponse.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ReconciliationServiceGetRecordResponse()..mergeFromBuffer(data, registry);
  factory ReconciliationServiceGetRecordResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ReconciliationServiceGetRecordResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ReconciliationServiceGetRecordResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.finance.v1'),
      createEmptyInstance:
          ReconciliationServiceGetRecordResponse.$_createMessage)
    ..aOM<ReconciliationRecord>(1, _omitFieldNames ? '' : 'record',
        subBuilder: ReconciliationRecord.$_createMessage)
    ..pPM<ReconciliationMatch>(2, _omitFieldNames ? '' : 'matches',
        subBuilder: ReconciliationMatch.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReconciliationServiceGetRecordResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReconciliationServiceGetRecordResponse copyWith(
          void Function(ReconciliationServiceGetRecordResponse) updates) =>
      super.copyWith((message) =>
              updates(message as ReconciliationServiceGetRecordResponse))
          as ReconciliationServiceGetRecordResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ReconciliationServiceGetRecordResponse() / ReconciliationServiceGetRecordResponse.new instead')
  static ReconciliationServiceGetRecordResponse create() =>
      ReconciliationServiceGetRecordResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      ReconciliationServiceGetRecordResponse._();
  @$core.override
  ReconciliationServiceGetRecordResponse createEmptyInstance() =>
      ReconciliationServiceGetRecordResponse._();
  @$core.pragma('dart2js:noInline')
  static ReconciliationServiceGetRecordResponse getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
              ReconciliationServiceGetRecordResponse>(
          ReconciliationServiceGetRecordResponse.$_createMessage);
  static ReconciliationServiceGetRecordResponse? _defaultInstance;

  @$pb.TagNumber(1)
  ReconciliationRecord get record => $_getN(0);
  @$pb.TagNumber(1)
  set record(ReconciliationRecord value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasRecord() => $_has(0);
  @$pb.TagNumber(1)
  void clearRecord() => $_clearField(1);
  @$pb.TagNumber(1)
  ReconciliationRecord ensureRecord() => $_ensure(0);

  @$pb.TagNumber(2)
  $pb.PbList<ReconciliationMatch> get matches => $_getList(1);
}

class ReconciliationServiceListRecordsRequest extends $pb.GeneratedMessage {
  factory ReconciliationServiceListRecordsRequest({
    $core.String? workspaceId,
    $2.Pagination? pagination,
    ReconciliationState? reconciliationState,
    $core.String? periodStart,
    $core.String? periodEnd,
  }) {
    final result = ReconciliationServiceListRecordsRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (pagination != null) result.pagination = pagination;
    if (reconciliationState != null)
      result.reconciliationState = reconciliationState;
    if (periodStart != null) result.periodStart = periodStart;
    if (periodEnd != null) result.periodEnd = periodEnd;
    return result;
  }

  ReconciliationServiceListRecordsRequest._();

  factory ReconciliationServiceListRecordsRequest.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ReconciliationServiceListRecordsRequest()
        ..mergeFromBuffer(data, registry);
  factory ReconciliationServiceListRecordsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ReconciliationServiceListRecordsRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ReconciliationServiceListRecordsRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.finance.v1'),
      createEmptyInstance:
          ReconciliationServiceListRecordsRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOM<$2.Pagination>(2, _omitFieldNames ? '' : 'pagination',
        subBuilder: $2.Pagination.$_createMessage)
    ..aE<ReconciliationState>(3, _omitFieldNames ? '' : 'reconciliationState',
        enumValues: ReconciliationState.values)
    ..aOS(4, _omitFieldNames ? '' : 'periodStart')
    ..aOS(5, _omitFieldNames ? '' : 'periodEnd')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReconciliationServiceListRecordsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReconciliationServiceListRecordsRequest copyWith(
          void Function(ReconciliationServiceListRecordsRequest) updates) =>
      super.copyWith((message) =>
              updates(message as ReconciliationServiceListRecordsRequest))
          as ReconciliationServiceListRecordsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ReconciliationServiceListRecordsRequest() / ReconciliationServiceListRecordsRequest.new instead')
  static ReconciliationServiceListRecordsRequest create() =>
      ReconciliationServiceListRecordsRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      ReconciliationServiceListRecordsRequest._();
  @$core.override
  ReconciliationServiceListRecordsRequest createEmptyInstance() =>
      ReconciliationServiceListRecordsRequest._();
  @$core.pragma('dart2js:noInline')
  static ReconciliationServiceListRecordsRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
              ReconciliationServiceListRecordsRequest>(
          ReconciliationServiceListRecordsRequest.$_createMessage);
  static ReconciliationServiceListRecordsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $2.Pagination get pagination => $_getN(1);
  @$pb.TagNumber(2)
  set pagination($2.Pagination value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasPagination() => $_has(1);
  @$pb.TagNumber(2)
  void clearPagination() => $_clearField(2);
  @$pb.TagNumber(2)
  $2.Pagination ensurePagination() => $_ensure(1);

  @$pb.TagNumber(3)
  ReconciliationState get reconciliationState => $_getN(2);
  @$pb.TagNumber(3)
  set reconciliationState(ReconciliationState value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasReconciliationState() => $_has(2);
  @$pb.TagNumber(3)
  void clearReconciliationState() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get periodStart => $_getSZ(3);
  @$pb.TagNumber(4)
  set periodStart($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasPeriodStart() => $_has(3);
  @$pb.TagNumber(4)
  void clearPeriodStart() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get periodEnd => $_getSZ(4);
  @$pb.TagNumber(5)
  set periodEnd($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasPeriodEnd() => $_has(4);
  @$pb.TagNumber(5)
  void clearPeriodEnd() => $_clearField(5);
}

class ReconciliationServiceListRecordsResponse extends $pb.GeneratedMessage {
  factory ReconciliationServiceListRecordsResponse({
    $core.Iterable<ReconciliationRecord>? records,
    $2.PaginatedResponse? pagination,
  }) {
    final result = ReconciliationServiceListRecordsResponse._();
    if (records != null) result.records.addAll(records);
    if (pagination != null) result.pagination = pagination;
    return result;
  }

  ReconciliationServiceListRecordsResponse._();

  factory ReconciliationServiceListRecordsResponse.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ReconciliationServiceListRecordsResponse()
        ..mergeFromBuffer(data, registry);
  factory ReconciliationServiceListRecordsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ReconciliationServiceListRecordsResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ReconciliationServiceListRecordsResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.finance.v1'),
      createEmptyInstance:
          ReconciliationServiceListRecordsResponse.$_createMessage)
    ..pPM<ReconciliationRecord>(1, _omitFieldNames ? '' : 'records',
        subBuilder: ReconciliationRecord.$_createMessage)
    ..aOM<$2.PaginatedResponse>(2, _omitFieldNames ? '' : 'pagination',
        subBuilder: $2.PaginatedResponse.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReconciliationServiceListRecordsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReconciliationServiceListRecordsResponse copyWith(
          void Function(ReconciliationServiceListRecordsResponse) updates) =>
      super.copyWith((message) =>
              updates(message as ReconciliationServiceListRecordsResponse))
          as ReconciliationServiceListRecordsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ReconciliationServiceListRecordsResponse() / ReconciliationServiceListRecordsResponse.new instead')
  static ReconciliationServiceListRecordsResponse create() =>
      ReconciliationServiceListRecordsResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      ReconciliationServiceListRecordsResponse._();
  @$core.override
  ReconciliationServiceListRecordsResponse createEmptyInstance() =>
      ReconciliationServiceListRecordsResponse._();
  @$core.pragma('dart2js:noInline')
  static ReconciliationServiceListRecordsResponse getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
              ReconciliationServiceListRecordsResponse>(
          ReconciliationServiceListRecordsResponse.$_createMessage);
  static ReconciliationServiceListRecordsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<ReconciliationRecord> get records => $_getList(0);

  @$pb.TagNumber(2)
  $2.PaginatedResponse get pagination => $_getN(1);
  @$pb.TagNumber(2)
  set pagination($2.PaginatedResponse value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasPagination() => $_has(1);
  @$pb.TagNumber(2)
  void clearPagination() => $_clearField(2);
  @$pb.TagNumber(2)
  $2.PaginatedResponse ensurePagination() => $_ensure(1);
}

class ReconciliationServiceListPendingRequest extends $pb.GeneratedMessage {
  factory ReconciliationServiceListPendingRequest({
    $core.String? workspaceId,
    $2.Pagination? pagination,
    $core.String? severity,
    $core.String? gapType,
    $core.String? periodStart,
    $core.String? periodEnd,
    $core.String? productId,
  }) {
    final result = ReconciliationServiceListPendingRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (pagination != null) result.pagination = pagination;
    if (severity != null) result.severity = severity;
    if (gapType != null) result.gapType = gapType;
    if (periodStart != null) result.periodStart = periodStart;
    if (periodEnd != null) result.periodEnd = periodEnd;
    if (productId != null) result.productId = productId;
    return result;
  }

  ReconciliationServiceListPendingRequest._();

  factory ReconciliationServiceListPendingRequest.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ReconciliationServiceListPendingRequest()
        ..mergeFromBuffer(data, registry);
  factory ReconciliationServiceListPendingRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ReconciliationServiceListPendingRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ReconciliationServiceListPendingRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.finance.v1'),
      createEmptyInstance:
          ReconciliationServiceListPendingRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOM<$2.Pagination>(2, _omitFieldNames ? '' : 'pagination',
        subBuilder: $2.Pagination.$_createMessage)
    ..aOS(3, _omitFieldNames ? '' : 'severity')
    ..aOS(4, _omitFieldNames ? '' : 'gapType')
    ..aOS(5, _omitFieldNames ? '' : 'periodStart')
    ..aOS(6, _omitFieldNames ? '' : 'periodEnd')
    ..aOS(7, _omitFieldNames ? '' : 'productId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReconciliationServiceListPendingRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReconciliationServiceListPendingRequest copyWith(
          void Function(ReconciliationServiceListPendingRequest) updates) =>
      super.copyWith((message) =>
              updates(message as ReconciliationServiceListPendingRequest))
          as ReconciliationServiceListPendingRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ReconciliationServiceListPendingRequest() / ReconciliationServiceListPendingRequest.new instead')
  static ReconciliationServiceListPendingRequest create() =>
      ReconciliationServiceListPendingRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      ReconciliationServiceListPendingRequest._();
  @$core.override
  ReconciliationServiceListPendingRequest createEmptyInstance() =>
      ReconciliationServiceListPendingRequest._();
  @$core.pragma('dart2js:noInline')
  static ReconciliationServiceListPendingRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
              ReconciliationServiceListPendingRequest>(
          ReconciliationServiceListPendingRequest.$_createMessage);
  static ReconciliationServiceListPendingRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $2.Pagination get pagination => $_getN(1);
  @$pb.TagNumber(2)
  set pagination($2.Pagination value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasPagination() => $_has(1);
  @$pb.TagNumber(2)
  void clearPagination() => $_clearField(2);
  @$pb.TagNumber(2)
  $2.Pagination ensurePagination() => $_ensure(1);

  @$pb.TagNumber(3)
  $core.String get severity => $_getSZ(2);
  @$pb.TagNumber(3)
  set severity($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasSeverity() => $_has(2);
  @$pb.TagNumber(3)
  void clearSeverity() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get gapType => $_getSZ(3);
  @$pb.TagNumber(4)
  set gapType($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasGapType() => $_has(3);
  @$pb.TagNumber(4)
  void clearGapType() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get periodStart => $_getSZ(4);
  @$pb.TagNumber(5)
  set periodStart($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasPeriodStart() => $_has(4);
  @$pb.TagNumber(5)
  void clearPeriodStart() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get periodEnd => $_getSZ(5);
  @$pb.TagNumber(6)
  set periodEnd($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasPeriodEnd() => $_has(5);
  @$pb.TagNumber(6)
  void clearPeriodEnd() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get productId => $_getSZ(6);
  @$pb.TagNumber(7)
  set productId($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasProductId() => $_has(6);
  @$pb.TagNumber(7)
  void clearProductId() => $_clearField(7);
}

class ReconciliationServiceListPendingResponse extends $pb.GeneratedMessage {
  factory ReconciliationServiceListPendingResponse({
    $core.Iterable<DataGapItem>? items,
    $2.PaginatedResponse? pagination,
    $core.int? missingComponentsCount,
    $2.Money? totalUnreconciledAmount,
    $core.int? unreconciledCount,
  }) {
    final result = ReconciliationServiceListPendingResponse._();
    if (items != null) result.items.addAll(items);
    if (pagination != null) result.pagination = pagination;
    if (missingComponentsCount != null)
      result.missingComponentsCount = missingComponentsCount;
    if (totalUnreconciledAmount != null)
      result.totalUnreconciledAmount = totalUnreconciledAmount;
    if (unreconciledCount != null) result.unreconciledCount = unreconciledCount;
    return result;
  }

  ReconciliationServiceListPendingResponse._();

  factory ReconciliationServiceListPendingResponse.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ReconciliationServiceListPendingResponse()
        ..mergeFromBuffer(data, registry);
  factory ReconciliationServiceListPendingResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ReconciliationServiceListPendingResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ReconciliationServiceListPendingResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.finance.v1'),
      createEmptyInstance:
          ReconciliationServiceListPendingResponse.$_createMessage)
    ..pPM<DataGapItem>(1, _omitFieldNames ? '' : 'items',
        subBuilder: DataGapItem.$_createMessage)
    ..aOM<$2.PaginatedResponse>(2, _omitFieldNames ? '' : 'pagination',
        subBuilder: $2.PaginatedResponse.$_createMessage)
    ..aI(3, _omitFieldNames ? '' : 'missingComponentsCount')
    ..aOM<$2.Money>(4, _omitFieldNames ? '' : 'totalUnreconciledAmount',
        subBuilder: $2.Money.$_createMessage)
    ..aI(5, _omitFieldNames ? '' : 'unreconciledCount')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReconciliationServiceListPendingResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReconciliationServiceListPendingResponse copyWith(
          void Function(ReconciliationServiceListPendingResponse) updates) =>
      super.copyWith((message) =>
              updates(message as ReconciliationServiceListPendingResponse))
          as ReconciliationServiceListPendingResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ReconciliationServiceListPendingResponse() / ReconciliationServiceListPendingResponse.new instead')
  static ReconciliationServiceListPendingResponse create() =>
      ReconciliationServiceListPendingResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      ReconciliationServiceListPendingResponse._();
  @$core.override
  ReconciliationServiceListPendingResponse createEmptyInstance() =>
      ReconciliationServiceListPendingResponse._();
  @$core.pragma('dart2js:noInline')
  static ReconciliationServiceListPendingResponse getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
              ReconciliationServiceListPendingResponse>(
          ReconciliationServiceListPendingResponse.$_createMessage);
  static ReconciliationServiceListPendingResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<DataGapItem> get items => $_getList(0);

  @$pb.TagNumber(2)
  $2.PaginatedResponse get pagination => $_getN(1);
  @$pb.TagNumber(2)
  set pagination($2.PaginatedResponse value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasPagination() => $_has(1);
  @$pb.TagNumber(2)
  void clearPagination() => $_clearField(2);
  @$pb.TagNumber(2)
  $2.PaginatedResponse ensurePagination() => $_ensure(1);

  @$pb.TagNumber(3)
  $core.int get missingComponentsCount => $_getIZ(2);
  @$pb.TagNumber(3)
  set missingComponentsCount($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasMissingComponentsCount() => $_has(2);
  @$pb.TagNumber(3)
  void clearMissingComponentsCount() => $_clearField(3);

  @$pb.TagNumber(4)
  $2.Money get totalUnreconciledAmount => $_getN(3);
  @$pb.TagNumber(4)
  set totalUnreconciledAmount($2.Money value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasTotalUnreconciledAmount() => $_has(3);
  @$pb.TagNumber(4)
  void clearTotalUnreconciledAmount() => $_clearField(4);
  @$pb.TagNumber(4)
  $2.Money ensureTotalUnreconciledAmount() => $_ensure(3);

  @$pb.TagNumber(5)
  $core.int get unreconciledCount => $_getIZ(4);
  @$pb.TagNumber(5)
  set unreconciledCount($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasUnreconciledCount() => $_has(4);
  @$pb.TagNumber(5)
  void clearUnreconciledCount() => $_clearField(5);
}

class EvidenceServiceSubmitRequest extends $pb.GeneratedMessage {
  factory EvidenceServiceSubmitRequest({
    $2.CommandContext? context,
    $core.String? workspaceId,
    $core.String? evidenceType,
    $core.String? sourceProvenance,
    $core.String? contentHash,
    $core.String? fileUrl,
    $core.String? payloadJson,
    $core.Iterable<ObjectRef>? relatedObjectRefs,
    $core.List<$core.int>? rawContent,
  }) {
    final result = EvidenceServiceSubmitRequest._();
    if (context != null) result.context = context;
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (evidenceType != null) result.evidenceType = evidenceType;
    if (sourceProvenance != null) result.sourceProvenance = sourceProvenance;
    if (contentHash != null) result.contentHash = contentHash;
    if (fileUrl != null) result.fileUrl = fileUrl;
    if (payloadJson != null) result.payloadJson = payloadJson;
    if (relatedObjectRefs != null)
      result.relatedObjectRefs.addAll(relatedObjectRefs);
    if (rawContent != null) result.rawContent = rawContent;
    return result;
  }

  EvidenceServiceSubmitRequest._();

  factory EvidenceServiceSubmitRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      EvidenceServiceSubmitRequest()..mergeFromBuffer(data, registry);
  factory EvidenceServiceSubmitRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      EvidenceServiceSubmitRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'EvidenceServiceSubmitRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.finance.v1'),
      createEmptyInstance: EvidenceServiceSubmitRequest.$_createMessage)
    ..aOM<$2.CommandContext>(1, _omitFieldNames ? '' : 'context',
        subBuilder: $2.CommandContext.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(3, _omitFieldNames ? '' : 'evidenceType')
    ..aOS(4, _omitFieldNames ? '' : 'sourceProvenance')
    ..aOS(5, _omitFieldNames ? '' : 'contentHash')
    ..aOS(6, _omitFieldNames ? '' : 'fileUrl')
    ..aOS(7, _omitFieldNames ? '' : 'payloadJson')
    ..pPM<ObjectRef>(8, _omitFieldNames ? '' : 'relatedObjectRefs',
        subBuilder: ObjectRef.$_createMessage)
    ..a<$core.List<$core.int>>(
        9, _omitFieldNames ? '' : 'rawContent', $pb.PbFieldType.OY)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EvidenceServiceSubmitRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EvidenceServiceSubmitRequest copyWith(
          void Function(EvidenceServiceSubmitRequest) updates) =>
      super.copyWith(
              (message) => updates(message as EvidenceServiceSubmitRequest))
          as EvidenceServiceSubmitRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use EvidenceServiceSubmitRequest() / EvidenceServiceSubmitRequest.new instead')
  static EvidenceServiceSubmitRequest create() =>
      EvidenceServiceSubmitRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      EvidenceServiceSubmitRequest._();
  @$core.override
  EvidenceServiceSubmitRequest createEmptyInstance() =>
      EvidenceServiceSubmitRequest._();
  @$core.pragma('dart2js:noInline')
  static EvidenceServiceSubmitRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<EvidenceServiceSubmitRequest>(
          EvidenceServiceSubmitRequest.$_createMessage);
  static EvidenceServiceSubmitRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $2.CommandContext get context => $_getN(0);
  @$pb.TagNumber(1)
  set context($2.CommandContext value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasContext() => $_has(0);
  @$pb.TagNumber(1)
  void clearContext() => $_clearField(1);
  @$pb.TagNumber(1)
  $2.CommandContext ensureContext() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get workspaceId => $_getSZ(1);
  @$pb.TagNumber(2)
  set workspaceId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasWorkspaceId() => $_has(1);
  @$pb.TagNumber(2)
  void clearWorkspaceId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get evidenceType => $_getSZ(2);
  @$pb.TagNumber(3)
  set evidenceType($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasEvidenceType() => $_has(2);
  @$pb.TagNumber(3)
  void clearEvidenceType() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get sourceProvenance => $_getSZ(3);
  @$pb.TagNumber(4)
  set sourceProvenance($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasSourceProvenance() => $_has(3);
  @$pb.TagNumber(4)
  void clearSourceProvenance() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get contentHash => $_getSZ(4);
  @$pb.TagNumber(5)
  set contentHash($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasContentHash() => $_has(4);
  @$pb.TagNumber(5)
  void clearContentHash() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get fileUrl => $_getSZ(5);
  @$pb.TagNumber(6)
  set fileUrl($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasFileUrl() => $_has(5);
  @$pb.TagNumber(6)
  void clearFileUrl() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get payloadJson => $_getSZ(6);
  @$pb.TagNumber(7)
  set payloadJson($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasPayloadJson() => $_has(6);
  @$pb.TagNumber(7)
  void clearPayloadJson() => $_clearField(7);

  @$pb.TagNumber(8)
  $pb.PbList<ObjectRef> get relatedObjectRefs => $_getList(7);

  @$pb.TagNumber(9)
  $core.List<$core.int> get rawContent => $_getN(8);
  @$pb.TagNumber(9)
  set rawContent($core.List<$core.int> value) => $_setBytes(8, value);
  @$pb.TagNumber(9)
  $core.bool hasRawContent() => $_has(8);
  @$pb.TagNumber(9)
  void clearRawContent() => $_clearField(9);
}

class EvidenceServiceSubmitResponse extends $pb.GeneratedMessage {
  factory EvidenceServiceSubmitResponse({
    EvidenceObject? evidence,
  }) {
    final result = EvidenceServiceSubmitResponse._();
    if (evidence != null) result.evidence = evidence;
    return result;
  }

  EvidenceServiceSubmitResponse._();

  factory EvidenceServiceSubmitResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      EvidenceServiceSubmitResponse()..mergeFromBuffer(data, registry);
  factory EvidenceServiceSubmitResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      EvidenceServiceSubmitResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'EvidenceServiceSubmitResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.finance.v1'),
      createEmptyInstance: EvidenceServiceSubmitResponse.$_createMessage)
    ..aOM<EvidenceObject>(1, _omitFieldNames ? '' : 'evidence',
        subBuilder: EvidenceObject.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EvidenceServiceSubmitResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EvidenceServiceSubmitResponse copyWith(
          void Function(EvidenceServiceSubmitResponse) updates) =>
      super.copyWith(
              (message) => updates(message as EvidenceServiceSubmitResponse))
          as EvidenceServiceSubmitResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use EvidenceServiceSubmitResponse() / EvidenceServiceSubmitResponse.new instead')
  static EvidenceServiceSubmitResponse create() =>
      EvidenceServiceSubmitResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      EvidenceServiceSubmitResponse._();
  @$core.override
  EvidenceServiceSubmitResponse createEmptyInstance() =>
      EvidenceServiceSubmitResponse._();
  @$core.pragma('dart2js:noInline')
  static EvidenceServiceSubmitResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<EvidenceServiceSubmitResponse>(
          EvidenceServiceSubmitResponse.$_createMessage);
  static EvidenceServiceSubmitResponse? _defaultInstance;

  @$pb.TagNumber(1)
  EvidenceObject get evidence => $_getN(0);
  @$pb.TagNumber(1)
  set evidence(EvidenceObject value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasEvidence() => $_has(0);
  @$pb.TagNumber(1)
  void clearEvidence() => $_clearField(1);
  @$pb.TagNumber(1)
  EvidenceObject ensureEvidence() => $_ensure(0);
}

class EvidenceServiceGetRequest extends $pb.GeneratedMessage {
  factory EvidenceServiceGetRequest({
    $core.String? workspaceId,
    $core.String? evidenceId,
  }) {
    final result = EvidenceServiceGetRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (evidenceId != null) result.evidenceId = evidenceId;
    return result;
  }

  EvidenceServiceGetRequest._();

  factory EvidenceServiceGetRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      EvidenceServiceGetRequest()..mergeFromBuffer(data, registry);
  factory EvidenceServiceGetRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      EvidenceServiceGetRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'EvidenceServiceGetRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.finance.v1'),
      createEmptyInstance: EvidenceServiceGetRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'evidenceId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EvidenceServiceGetRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EvidenceServiceGetRequest copyWith(
          void Function(EvidenceServiceGetRequest) updates) =>
      super.copyWith((message) => updates(message as EvidenceServiceGetRequest))
          as EvidenceServiceGetRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use EvidenceServiceGetRequest() / EvidenceServiceGetRequest.new instead')
  static EvidenceServiceGetRequest create() => EvidenceServiceGetRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      EvidenceServiceGetRequest._();
  @$core.override
  EvidenceServiceGetRequest createEmptyInstance() =>
      EvidenceServiceGetRequest._();
  @$core.pragma('dart2js:noInline')
  static EvidenceServiceGetRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<EvidenceServiceGetRequest>(
          EvidenceServiceGetRequest.$_createMessage);
  static EvidenceServiceGetRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get evidenceId => $_getSZ(1);
  @$pb.TagNumber(2)
  set evidenceId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasEvidenceId() => $_has(1);
  @$pb.TagNumber(2)
  void clearEvidenceId() => $_clearField(2);
}

class EvidenceServiceGetResponse extends $pb.GeneratedMessage {
  factory EvidenceServiceGetResponse({
    EvidenceObject? evidence,
  }) {
    final result = EvidenceServiceGetResponse._();
    if (evidence != null) result.evidence = evidence;
    return result;
  }

  EvidenceServiceGetResponse._();

  factory EvidenceServiceGetResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      EvidenceServiceGetResponse()..mergeFromBuffer(data, registry);
  factory EvidenceServiceGetResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      EvidenceServiceGetResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'EvidenceServiceGetResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.finance.v1'),
      createEmptyInstance: EvidenceServiceGetResponse.$_createMessage)
    ..aOM<EvidenceObject>(1, _omitFieldNames ? '' : 'evidence',
        subBuilder: EvidenceObject.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EvidenceServiceGetResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EvidenceServiceGetResponse copyWith(
          void Function(EvidenceServiceGetResponse) updates) =>
      super.copyWith(
              (message) => updates(message as EvidenceServiceGetResponse))
          as EvidenceServiceGetResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use EvidenceServiceGetResponse() / EvidenceServiceGetResponse.new instead')
  static EvidenceServiceGetResponse create() => EvidenceServiceGetResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      EvidenceServiceGetResponse._();
  @$core.override
  EvidenceServiceGetResponse createEmptyInstance() =>
      EvidenceServiceGetResponse._();
  @$core.pragma('dart2js:noInline')
  static EvidenceServiceGetResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<EvidenceServiceGetResponse>(
          EvidenceServiceGetResponse.$_createMessage);
  static EvidenceServiceGetResponse? _defaultInstance;

  @$pb.TagNumber(1)
  EvidenceObject get evidence => $_getN(0);
  @$pb.TagNumber(1)
  set evidence(EvidenceObject value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasEvidence() => $_has(0);
  @$pb.TagNumber(1)
  void clearEvidence() => $_clearField(1);
  @$pb.TagNumber(1)
  EvidenceObject ensureEvidence() => $_ensure(0);
}

class EvidenceServiceListRequest extends $pb.GeneratedMessage {
  factory EvidenceServiceListRequest({
    $core.String? workspaceId,
    $2.Pagination? pagination,
    $core.String? evidenceType,
    $core.String? verificationStatus,
  }) {
    final result = EvidenceServiceListRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (pagination != null) result.pagination = pagination;
    if (evidenceType != null) result.evidenceType = evidenceType;
    if (verificationStatus != null)
      result.verificationStatus = verificationStatus;
    return result;
  }

  EvidenceServiceListRequest._();

  factory EvidenceServiceListRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      EvidenceServiceListRequest()..mergeFromBuffer(data, registry);
  factory EvidenceServiceListRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      EvidenceServiceListRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'EvidenceServiceListRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.finance.v1'),
      createEmptyInstance: EvidenceServiceListRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOM<$2.Pagination>(2, _omitFieldNames ? '' : 'pagination',
        subBuilder: $2.Pagination.$_createMessage)
    ..aOS(3, _omitFieldNames ? '' : 'evidenceType')
    ..aOS(4, _omitFieldNames ? '' : 'verificationStatus')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EvidenceServiceListRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EvidenceServiceListRequest copyWith(
          void Function(EvidenceServiceListRequest) updates) =>
      super.copyWith(
              (message) => updates(message as EvidenceServiceListRequest))
          as EvidenceServiceListRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use EvidenceServiceListRequest() / EvidenceServiceListRequest.new instead')
  static EvidenceServiceListRequest create() => EvidenceServiceListRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      EvidenceServiceListRequest._();
  @$core.override
  EvidenceServiceListRequest createEmptyInstance() =>
      EvidenceServiceListRequest._();
  @$core.pragma('dart2js:noInline')
  static EvidenceServiceListRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<EvidenceServiceListRequest>(
          EvidenceServiceListRequest.$_createMessage);
  static EvidenceServiceListRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $2.Pagination get pagination => $_getN(1);
  @$pb.TagNumber(2)
  set pagination($2.Pagination value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasPagination() => $_has(1);
  @$pb.TagNumber(2)
  void clearPagination() => $_clearField(2);
  @$pb.TagNumber(2)
  $2.Pagination ensurePagination() => $_ensure(1);

  @$pb.TagNumber(3)
  $core.String get evidenceType => $_getSZ(2);
  @$pb.TagNumber(3)
  set evidenceType($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasEvidenceType() => $_has(2);
  @$pb.TagNumber(3)
  void clearEvidenceType() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get verificationStatus => $_getSZ(3);
  @$pb.TagNumber(4)
  set verificationStatus($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasVerificationStatus() => $_has(3);
  @$pb.TagNumber(4)
  void clearVerificationStatus() => $_clearField(4);
}

class EvidenceServiceListResponse extends $pb.GeneratedMessage {
  factory EvidenceServiceListResponse({
    $core.Iterable<EvidenceObject>? items,
    $2.PaginatedResponse? pagination,
  }) {
    final result = EvidenceServiceListResponse._();
    if (items != null) result.items.addAll(items);
    if (pagination != null) result.pagination = pagination;
    return result;
  }

  EvidenceServiceListResponse._();

  factory EvidenceServiceListResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      EvidenceServiceListResponse()..mergeFromBuffer(data, registry);
  factory EvidenceServiceListResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      EvidenceServiceListResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'EvidenceServiceListResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.finance.v1'),
      createEmptyInstance: EvidenceServiceListResponse.$_createMessage)
    ..pPM<EvidenceObject>(1, _omitFieldNames ? '' : 'items',
        subBuilder: EvidenceObject.$_createMessage)
    ..aOM<$2.PaginatedResponse>(2, _omitFieldNames ? '' : 'pagination',
        subBuilder: $2.PaginatedResponse.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EvidenceServiceListResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EvidenceServiceListResponse copyWith(
          void Function(EvidenceServiceListResponse) updates) =>
      super.copyWith(
              (message) => updates(message as EvidenceServiceListResponse))
          as EvidenceServiceListResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use EvidenceServiceListResponse() / EvidenceServiceListResponse.new instead')
  static EvidenceServiceListResponse create() =>
      EvidenceServiceListResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      EvidenceServiceListResponse._();
  @$core.override
  EvidenceServiceListResponse createEmptyInstance() =>
      EvidenceServiceListResponse._();
  @$core.pragma('dart2js:noInline')
  static EvidenceServiceListResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<EvidenceServiceListResponse>(
          EvidenceServiceListResponse.$_createMessage);
  static EvidenceServiceListResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<EvidenceObject> get items => $_getList(0);

  @$pb.TagNumber(2)
  $2.PaginatedResponse get pagination => $_getN(1);
  @$pb.TagNumber(2)
  set pagination($2.PaginatedResponse value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasPagination() => $_has(1);
  @$pb.TagNumber(2)
  void clearPagination() => $_clearField(2);
  @$pb.TagNumber(2)
  $2.PaginatedResponse ensurePagination() => $_ensure(1);
}

class ProofServiceAssembleRequest extends $pb.GeneratedMessage {
  factory ProofServiceAssembleRequest({
    $2.CommandContext? context,
    $core.String? workspaceId,
    $core.String? claimScope,
    $core.String? claimSummary,
    $core.Iterable<$core.String>? supportingEvidenceIds,
    $2.ConfidenceBand? confidence,
    $core.String? coverageSummary,
    $core.String? unresolvedGaps,
  }) {
    final result = ProofServiceAssembleRequest._();
    if (context != null) result.context = context;
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (claimScope != null) result.claimScope = claimScope;
    if (claimSummary != null) result.claimSummary = claimSummary;
    if (supportingEvidenceIds != null)
      result.supportingEvidenceIds.addAll(supportingEvidenceIds);
    if (confidence != null) result.confidence = confidence;
    if (coverageSummary != null) result.coverageSummary = coverageSummary;
    if (unresolvedGaps != null) result.unresolvedGaps = unresolvedGaps;
    return result;
  }

  ProofServiceAssembleRequest._();

  factory ProofServiceAssembleRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ProofServiceAssembleRequest()..mergeFromBuffer(data, registry);
  factory ProofServiceAssembleRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ProofServiceAssembleRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ProofServiceAssembleRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.finance.v1'),
      createEmptyInstance: ProofServiceAssembleRequest.$_createMessage)
    ..aOM<$2.CommandContext>(1, _omitFieldNames ? '' : 'context',
        subBuilder: $2.CommandContext.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(3, _omitFieldNames ? '' : 'claimScope')
    ..aOS(4, _omitFieldNames ? '' : 'claimSummary')
    ..pPS(5, _omitFieldNames ? '' : 'supportingEvidenceIds')
    ..aE<$2.ConfidenceBand>(6, _omitFieldNames ? '' : 'confidence',
        enumValues: $2.ConfidenceBand.values)
    ..aOS(7, _omitFieldNames ? '' : 'coverageSummary')
    ..aOS(8, _omitFieldNames ? '' : 'unresolvedGaps')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ProofServiceAssembleRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ProofServiceAssembleRequest copyWith(
          void Function(ProofServiceAssembleRequest) updates) =>
      super.copyWith(
              (message) => updates(message as ProofServiceAssembleRequest))
          as ProofServiceAssembleRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ProofServiceAssembleRequest() / ProofServiceAssembleRequest.new instead')
  static ProofServiceAssembleRequest create() =>
      ProofServiceAssembleRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      ProofServiceAssembleRequest._();
  @$core.override
  ProofServiceAssembleRequest createEmptyInstance() =>
      ProofServiceAssembleRequest._();
  @$core.pragma('dart2js:noInline')
  static ProofServiceAssembleRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ProofServiceAssembleRequest>(
          ProofServiceAssembleRequest.$_createMessage);
  static ProofServiceAssembleRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $2.CommandContext get context => $_getN(0);
  @$pb.TagNumber(1)
  set context($2.CommandContext value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasContext() => $_has(0);
  @$pb.TagNumber(1)
  void clearContext() => $_clearField(1);
  @$pb.TagNumber(1)
  $2.CommandContext ensureContext() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get workspaceId => $_getSZ(1);
  @$pb.TagNumber(2)
  set workspaceId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasWorkspaceId() => $_has(1);
  @$pb.TagNumber(2)
  void clearWorkspaceId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get claimScope => $_getSZ(2);
  @$pb.TagNumber(3)
  set claimScope($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasClaimScope() => $_has(2);
  @$pb.TagNumber(3)
  void clearClaimScope() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get claimSummary => $_getSZ(3);
  @$pb.TagNumber(4)
  set claimSummary($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasClaimSummary() => $_has(3);
  @$pb.TagNumber(4)
  void clearClaimSummary() => $_clearField(4);

  @$pb.TagNumber(5)
  $pb.PbList<$core.String> get supportingEvidenceIds => $_getList(4);

  @$pb.TagNumber(6)
  $2.ConfidenceBand get confidence => $_getN(5);
  @$pb.TagNumber(6)
  set confidence($2.ConfidenceBand value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasConfidence() => $_has(5);
  @$pb.TagNumber(6)
  void clearConfidence() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get coverageSummary => $_getSZ(6);
  @$pb.TagNumber(7)
  set coverageSummary($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasCoverageSummary() => $_has(6);
  @$pb.TagNumber(7)
  void clearCoverageSummary() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get unresolvedGaps => $_getSZ(7);
  @$pb.TagNumber(8)
  set unresolvedGaps($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasUnresolvedGaps() => $_has(7);
  @$pb.TagNumber(8)
  void clearUnresolvedGaps() => $_clearField(8);
}

class ProofServiceAssembleResponse extends $pb.GeneratedMessage {
  factory ProofServiceAssembleResponse({
    ProofBundle? proofBundle,
  }) {
    final result = ProofServiceAssembleResponse._();
    if (proofBundle != null) result.proofBundle = proofBundle;
    return result;
  }

  ProofServiceAssembleResponse._();

  factory ProofServiceAssembleResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ProofServiceAssembleResponse()..mergeFromBuffer(data, registry);
  factory ProofServiceAssembleResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ProofServiceAssembleResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ProofServiceAssembleResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.finance.v1'),
      createEmptyInstance: ProofServiceAssembleResponse.$_createMessage)
    ..aOM<ProofBundle>(1, _omitFieldNames ? '' : 'proofBundle',
        subBuilder: ProofBundle.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ProofServiceAssembleResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ProofServiceAssembleResponse copyWith(
          void Function(ProofServiceAssembleResponse) updates) =>
      super.copyWith(
              (message) => updates(message as ProofServiceAssembleResponse))
          as ProofServiceAssembleResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ProofServiceAssembleResponse() / ProofServiceAssembleResponse.new instead')
  static ProofServiceAssembleResponse create() =>
      ProofServiceAssembleResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      ProofServiceAssembleResponse._();
  @$core.override
  ProofServiceAssembleResponse createEmptyInstance() =>
      ProofServiceAssembleResponse._();
  @$core.pragma('dart2js:noInline')
  static ProofServiceAssembleResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ProofServiceAssembleResponse>(
          ProofServiceAssembleResponse.$_createMessage);
  static ProofServiceAssembleResponse? _defaultInstance;

  @$pb.TagNumber(1)
  ProofBundle get proofBundle => $_getN(0);
  @$pb.TagNumber(1)
  set proofBundle(ProofBundle value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasProofBundle() => $_has(0);
  @$pb.TagNumber(1)
  void clearProofBundle() => $_clearField(1);
  @$pb.TagNumber(1)
  ProofBundle ensureProofBundle() => $_ensure(0);
}

class ProofServiceGetRequest extends $pb.GeneratedMessage {
  factory ProofServiceGetRequest({
    $core.String? workspaceId,
    $core.String? proofBundleId,
  }) {
    final result = ProofServiceGetRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (proofBundleId != null) result.proofBundleId = proofBundleId;
    return result;
  }

  ProofServiceGetRequest._();

  factory ProofServiceGetRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ProofServiceGetRequest()..mergeFromBuffer(data, registry);
  factory ProofServiceGetRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ProofServiceGetRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ProofServiceGetRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.finance.v1'),
      createEmptyInstance: ProofServiceGetRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'proofBundleId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ProofServiceGetRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ProofServiceGetRequest copyWith(
          void Function(ProofServiceGetRequest) updates) =>
      super.copyWith((message) => updates(message as ProofServiceGetRequest))
          as ProofServiceGetRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ProofServiceGetRequest() / ProofServiceGetRequest.new instead')
  static ProofServiceGetRequest create() => ProofServiceGetRequest._();
  static $pb.GeneratedMessage $_createMessage() => ProofServiceGetRequest._();
  @$core.override
  ProofServiceGetRequest createEmptyInstance() => ProofServiceGetRequest._();
  @$core.pragma('dart2js:noInline')
  static ProofServiceGetRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ProofServiceGetRequest>(
          ProofServiceGetRequest.$_createMessage);
  static ProofServiceGetRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get proofBundleId => $_getSZ(1);
  @$pb.TagNumber(2)
  set proofBundleId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasProofBundleId() => $_has(1);
  @$pb.TagNumber(2)
  void clearProofBundleId() => $_clearField(2);
}

class ProofServiceGetResponse extends $pb.GeneratedMessage {
  factory ProofServiceGetResponse({
    ProofBundle? proofBundle,
  }) {
    final result = ProofServiceGetResponse._();
    if (proofBundle != null) result.proofBundle = proofBundle;
    return result;
  }

  ProofServiceGetResponse._();

  factory ProofServiceGetResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ProofServiceGetResponse()..mergeFromBuffer(data, registry);
  factory ProofServiceGetResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ProofServiceGetResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ProofServiceGetResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.finance.v1'),
      createEmptyInstance: ProofServiceGetResponse.$_createMessage)
    ..aOM<ProofBundle>(1, _omitFieldNames ? '' : 'proofBundle',
        subBuilder: ProofBundle.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ProofServiceGetResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ProofServiceGetResponse copyWith(
          void Function(ProofServiceGetResponse) updates) =>
      super.copyWith((message) => updates(message as ProofServiceGetResponse))
          as ProofServiceGetResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ProofServiceGetResponse() / ProofServiceGetResponse.new instead')
  static ProofServiceGetResponse create() => ProofServiceGetResponse._();
  static $pb.GeneratedMessage $_createMessage() => ProofServiceGetResponse._();
  @$core.override
  ProofServiceGetResponse createEmptyInstance() => ProofServiceGetResponse._();
  @$core.pragma('dart2js:noInline')
  static ProofServiceGetResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ProofServiceGetResponse>(
          ProofServiceGetResponse.$_createMessage);
  static ProofServiceGetResponse? _defaultInstance;

  @$pb.TagNumber(1)
  ProofBundle get proofBundle => $_getN(0);
  @$pb.TagNumber(1)
  set proofBundle(ProofBundle value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasProofBundle() => $_has(0);
  @$pb.TagNumber(1)
  void clearProofBundle() => $_clearField(1);
  @$pb.TagNumber(1)
  ProofBundle ensureProofBundle() => $_ensure(0);
}

class ProofServiceListRequest extends $pb.GeneratedMessage {
  factory ProofServiceListRequest({
    $core.String? workspaceId,
    $2.Pagination? pagination,
    $core.String? claimScope,
  }) {
    final result = ProofServiceListRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (pagination != null) result.pagination = pagination;
    if (claimScope != null) result.claimScope = claimScope;
    return result;
  }

  ProofServiceListRequest._();

  factory ProofServiceListRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ProofServiceListRequest()..mergeFromBuffer(data, registry);
  factory ProofServiceListRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ProofServiceListRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ProofServiceListRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.finance.v1'),
      createEmptyInstance: ProofServiceListRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOM<$2.Pagination>(2, _omitFieldNames ? '' : 'pagination',
        subBuilder: $2.Pagination.$_createMessage)
    ..aOS(3, _omitFieldNames ? '' : 'claimScope')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ProofServiceListRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ProofServiceListRequest copyWith(
          void Function(ProofServiceListRequest) updates) =>
      super.copyWith((message) => updates(message as ProofServiceListRequest))
          as ProofServiceListRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ProofServiceListRequest() / ProofServiceListRequest.new instead')
  static ProofServiceListRequest create() => ProofServiceListRequest._();
  static $pb.GeneratedMessage $_createMessage() => ProofServiceListRequest._();
  @$core.override
  ProofServiceListRequest createEmptyInstance() => ProofServiceListRequest._();
  @$core.pragma('dart2js:noInline')
  static ProofServiceListRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ProofServiceListRequest>(
          ProofServiceListRequest.$_createMessage);
  static ProofServiceListRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $2.Pagination get pagination => $_getN(1);
  @$pb.TagNumber(2)
  set pagination($2.Pagination value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasPagination() => $_has(1);
  @$pb.TagNumber(2)
  void clearPagination() => $_clearField(2);
  @$pb.TagNumber(2)
  $2.Pagination ensurePagination() => $_ensure(1);

  @$pb.TagNumber(3)
  $core.String get claimScope => $_getSZ(2);
  @$pb.TagNumber(3)
  set claimScope($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasClaimScope() => $_has(2);
  @$pb.TagNumber(3)
  void clearClaimScope() => $_clearField(3);
}

class ProofServiceListResponse extends $pb.GeneratedMessage {
  factory ProofServiceListResponse({
    $core.Iterable<ProofBundle>? proofBundles,
    $2.PaginatedResponse? pagination,
  }) {
    final result = ProofServiceListResponse._();
    if (proofBundles != null) result.proofBundles.addAll(proofBundles);
    if (pagination != null) result.pagination = pagination;
    return result;
  }

  ProofServiceListResponse._();

  factory ProofServiceListResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ProofServiceListResponse()..mergeFromBuffer(data, registry);
  factory ProofServiceListResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ProofServiceListResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ProofServiceListResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.finance.v1'),
      createEmptyInstance: ProofServiceListResponse.$_createMessage)
    ..pPM<ProofBundle>(1, _omitFieldNames ? '' : 'proofBundles',
        subBuilder: ProofBundle.$_createMessage)
    ..aOM<$2.PaginatedResponse>(2, _omitFieldNames ? '' : 'pagination',
        subBuilder: $2.PaginatedResponse.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ProofServiceListResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ProofServiceListResponse copyWith(
          void Function(ProofServiceListResponse) updates) =>
      super.copyWith((message) => updates(message as ProofServiceListResponse))
          as ProofServiceListResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ProofServiceListResponse() / ProofServiceListResponse.new instead')
  static ProofServiceListResponse create() => ProofServiceListResponse._();
  static $pb.GeneratedMessage $_createMessage() => ProofServiceListResponse._();
  @$core.override
  ProofServiceListResponse createEmptyInstance() =>
      ProofServiceListResponse._();
  @$core.pragma('dart2js:noInline')
  static ProofServiceListResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ProofServiceListResponse>(
          ProofServiceListResponse.$_createMessage);
  static ProofServiceListResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<ProofBundle> get proofBundles => $_getList(0);

  @$pb.TagNumber(2)
  $2.PaginatedResponse get pagination => $_getN(1);
  @$pb.TagNumber(2)
  set pagination($2.PaginatedResponse value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasPagination() => $_has(1);
  @$pb.TagNumber(2)
  void clearPagination() => $_clearField(2);
  @$pb.TagNumber(2)
  $2.PaginatedResponse ensurePagination() => $_ensure(1);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');

// This is a generated file - do not edit.
//
// Generated from creativanta/intelligence/v1/opportunity.proto.

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
    as $1;

import 'opportunity.pbenum.dart';
import 'trend.pbenum.dart' as $2;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'opportunity.pbenum.dart';

/// ExpectedImpact defines impact estimation per database_schema.md §5.4.
class ExpectedImpact extends $pb.GeneratedMessage {
  factory ExpectedImpact({
    $core.int? score,
    $core.String? description,
    $core.String? revenueEstimate,
  }) {
    final result = ExpectedImpact._();
    if (score != null) result.score = score;
    if (description != null) result.description = description;
    if (revenueEstimate != null) result.revenueEstimate = revenueEstimate;
    return result;
  }

  ExpectedImpact._();

  factory ExpectedImpact.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ExpectedImpact()..mergeFromBuffer(data, registry);
  factory ExpectedImpact.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ExpectedImpact()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ExpectedImpact',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.intelligence.v1'),
      createEmptyInstance: ExpectedImpact.$_createMessage)
    ..aI(1, _omitFieldNames ? '' : 'score')
    ..aOS(2, _omitFieldNames ? '' : 'description')
    ..aOS(3, _omitFieldNames ? '' : 'revenueEstimate')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ExpectedImpact clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ExpectedImpact copyWith(void Function(ExpectedImpact) updates) =>
      super.copyWith((message) => updates(message as ExpectedImpact))
          as ExpectedImpact;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ExpectedImpact() / ExpectedImpact.new instead')
  static ExpectedImpact create() => ExpectedImpact._();
  static $pb.GeneratedMessage $_createMessage() => ExpectedImpact._();
  @$core.override
  ExpectedImpact createEmptyInstance() => ExpectedImpact._();
  @$core.pragma('dart2js:noInline')
  static ExpectedImpact getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ExpectedImpact>(
          ExpectedImpact.$_createMessage);
  static ExpectedImpact? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get score => $_getIZ(0);
  @$pb.TagNumber(1)
  set score($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasScore() => $_has(0);
  @$pb.TagNumber(1)
  void clearScore() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get description => $_getSZ(1);
  @$pb.TagNumber(2)
  set description($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasDescription() => $_has(1);
  @$pb.TagNumber(2)
  void clearDescription() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get revenueEstimate => $_getSZ(2);
  @$pb.TagNumber(3)
  set revenueEstimate($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasRevenueEstimate() => $_has(2);
  @$pb.TagNumber(3)
  void clearRevenueEstimate() => $_clearField(3);
}

/// ExpectedEffort defines effort estimation per database_schema.md §5.4.
class ExpectedEffort extends $pb.GeneratedMessage {
  factory ExpectedEffort({
    $core.int? score,
    $core.String? description,
    $core.String? timeEstimate,
  }) {
    final result = ExpectedEffort._();
    if (score != null) result.score = score;
    if (description != null) result.description = description;
    if (timeEstimate != null) result.timeEstimate = timeEstimate;
    return result;
  }

  ExpectedEffort._();

  factory ExpectedEffort.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ExpectedEffort()..mergeFromBuffer(data, registry);
  factory ExpectedEffort.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ExpectedEffort()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ExpectedEffort',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.intelligence.v1'),
      createEmptyInstance: ExpectedEffort.$_createMessage)
    ..aI(1, _omitFieldNames ? '' : 'score')
    ..aOS(2, _omitFieldNames ? '' : 'description')
    ..aOS(3, _omitFieldNames ? '' : 'timeEstimate')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ExpectedEffort clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ExpectedEffort copyWith(void Function(ExpectedEffort) updates) =>
      super.copyWith((message) => updates(message as ExpectedEffort))
          as ExpectedEffort;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ExpectedEffort() / ExpectedEffort.new instead')
  static ExpectedEffort create() => ExpectedEffort._();
  static $pb.GeneratedMessage $_createMessage() => ExpectedEffort._();
  @$core.override
  ExpectedEffort createEmptyInstance() => ExpectedEffort._();
  @$core.pragma('dart2js:noInline')
  static ExpectedEffort getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ExpectedEffort>(
          ExpectedEffort.$_createMessage);
  static ExpectedEffort? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get score => $_getIZ(0);
  @$pb.TagNumber(1)
  set score($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasScore() => $_has(0);
  @$pb.TagNumber(1)
  void clearScore() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get description => $_getSZ(1);
  @$pb.TagNumber(2)
  set description($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasDescription() => $_has(1);
  @$pb.TagNumber(2)
  void clearDescription() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get timeEstimate => $_getSZ(2);
  @$pb.TagNumber(3)
  set timeEstimate($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasTimeEstimate() => $_has(2);
  @$pb.TagNumber(3)
  void clearTimeEstimate() => $_clearField(3);
}

/// EstimatedProfit defines expected profit estimation with confidence & source class per RULE-M04-005.
class EstimatedProfit extends $pb.GeneratedMessage {
  factory EstimatedProfit({
    $fixnum.Int64? amountCents,
    $core.String? currency,
    $2.ConfidenceBand? confidence,
    $2.SourceClass? sourceClass,
    $core.bool? isEstimate,
    $core.String? explanation,
  }) {
    final result = EstimatedProfit._();
    if (amountCents != null) result.amountCents = amountCents;
    if (currency != null) result.currency = currency;
    if (confidence != null) result.confidence = confidence;
    if (sourceClass != null) result.sourceClass = sourceClass;
    if (isEstimate != null) result.isEstimate = isEstimate;
    if (explanation != null) result.explanation = explanation;
    return result;
  }

  EstimatedProfit._();

  factory EstimatedProfit.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      EstimatedProfit()..mergeFromBuffer(data, registry);
  factory EstimatedProfit.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      EstimatedProfit()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'EstimatedProfit',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.intelligence.v1'),
      createEmptyInstance: EstimatedProfit.$_createMessage)
    ..aInt64(1, _omitFieldNames ? '' : 'amountCents')
    ..aOS(2, _omitFieldNames ? '' : 'currency')
    ..aE<$2.ConfidenceBand>(3, _omitFieldNames ? '' : 'confidence',
        enumValues: $2.ConfidenceBand.values)
    ..aE<$2.SourceClass>(4, _omitFieldNames ? '' : 'sourceClass',
        enumValues: $2.SourceClass.values)
    ..aOB(5, _omitFieldNames ? '' : 'isEstimate')
    ..aOS(6, _omitFieldNames ? '' : 'explanation')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EstimatedProfit clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EstimatedProfit copyWith(void Function(EstimatedProfit) updates) =>
      super.copyWith((message) => updates(message as EstimatedProfit))
          as EstimatedProfit;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use EstimatedProfit() / EstimatedProfit.new instead')
  static EstimatedProfit create() => EstimatedProfit._();
  static $pb.GeneratedMessage $_createMessage() => EstimatedProfit._();
  @$core.override
  EstimatedProfit createEmptyInstance() => EstimatedProfit._();
  @$core.pragma('dart2js:noInline')
  static EstimatedProfit getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<EstimatedProfit>(
          EstimatedProfit.$_createMessage);
  static EstimatedProfit? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get amountCents => $_getI64(0);
  @$pb.TagNumber(1)
  set amountCents($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAmountCents() => $_has(0);
  @$pb.TagNumber(1)
  void clearAmountCents() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get currency => $_getSZ(1);
  @$pb.TagNumber(2)
  set currency($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCurrency() => $_has(1);
  @$pb.TagNumber(2)
  void clearCurrency() => $_clearField(2);

  @$pb.TagNumber(3)
  $2.ConfidenceBand get confidence => $_getN(2);
  @$pb.TagNumber(3)
  set confidence($2.ConfidenceBand value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasConfidence() => $_has(2);
  @$pb.TagNumber(3)
  void clearConfidence() => $_clearField(3);

  @$pb.TagNumber(4)
  $2.SourceClass get sourceClass => $_getN(3);
  @$pb.TagNumber(4)
  set sourceClass($2.SourceClass value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasSourceClass() => $_has(3);
  @$pb.TagNumber(4)
  void clearSourceClass() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.bool get isEstimate => $_getBF(4);
  @$pb.TagNumber(5)
  set isEstimate($core.bool value) => $_setBool(4, value);
  @$pb.TagNumber(5)
  $core.bool hasIsEstimate() => $_has(4);
  @$pb.TagNumber(5)
  void clearIsEstimate() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get explanation => $_getSZ(5);
  @$pb.TagNumber(6)
  set explanation($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasExplanation() => $_has(5);
  @$pb.TagNumber(6)
  void clearExplanation() => $_clearField(6);
}

/// OpportunitySourceRef represents a provenance source link per RULE-M04-001 and EC-M04-001.
class OpportunitySourceRef extends $pb.GeneratedMessage {
  factory OpportunitySourceRef({
    $core.String? sourceType,
    $core.String? sourceId,
    $core.String? sourceName,
    $core.String? sourceUrl,
    $core.bool? isExpired,
    $core.String? archiveNotice,
  }) {
    final result = OpportunitySourceRef._();
    if (sourceType != null) result.sourceType = sourceType;
    if (sourceId != null) result.sourceId = sourceId;
    if (sourceName != null) result.sourceName = sourceName;
    if (sourceUrl != null) result.sourceUrl = sourceUrl;
    if (isExpired != null) result.isExpired = isExpired;
    if (archiveNotice != null) result.archiveNotice = archiveNotice;
    return result;
  }

  OpportunitySourceRef._();

  factory OpportunitySourceRef.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      OpportunitySourceRef()..mergeFromBuffer(data, registry);
  factory OpportunitySourceRef.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      OpportunitySourceRef()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'OpportunitySourceRef',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.intelligence.v1'),
      createEmptyInstance: OpportunitySourceRef.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'sourceType')
    ..aOS(2, _omitFieldNames ? '' : 'sourceId')
    ..aOS(3, _omitFieldNames ? '' : 'sourceName')
    ..aOS(4, _omitFieldNames ? '' : 'sourceUrl')
    ..aOB(5, _omitFieldNames ? '' : 'isExpired')
    ..aOS(6, _omitFieldNames ? '' : 'archiveNotice')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OpportunitySourceRef clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OpportunitySourceRef copyWith(void Function(OpportunitySourceRef) updates) =>
      super.copyWith((message) => updates(message as OpportunitySourceRef))
          as OpportunitySourceRef;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use OpportunitySourceRef() / OpportunitySourceRef.new instead')
  static OpportunitySourceRef create() => OpportunitySourceRef._();
  static $pb.GeneratedMessage $_createMessage() => OpportunitySourceRef._();
  @$core.override
  OpportunitySourceRef createEmptyInstance() => OpportunitySourceRef._();
  @$core.pragma('dart2js:noInline')
  static OpportunitySourceRef getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<OpportunitySourceRef>(
          OpportunitySourceRef.$_createMessage);
  static OpportunitySourceRef? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get sourceType => $_getSZ(0);
  @$pb.TagNumber(1)
  set sourceType($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSourceType() => $_has(0);
  @$pb.TagNumber(1)
  void clearSourceType() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get sourceId => $_getSZ(1);
  @$pb.TagNumber(2)
  set sourceId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSourceId() => $_has(1);
  @$pb.TagNumber(2)
  void clearSourceId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get sourceName => $_getSZ(2);
  @$pb.TagNumber(3)
  set sourceName($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasSourceName() => $_has(2);
  @$pb.TagNumber(3)
  void clearSourceName() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get sourceUrl => $_getSZ(3);
  @$pb.TagNumber(4)
  set sourceUrl($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasSourceUrl() => $_has(3);
  @$pb.TagNumber(4)
  void clearSourceUrl() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.bool get isExpired => $_getBF(4);
  @$pb.TagNumber(5)
  set isExpired($core.bool value) => $_setBool(4, value);
  @$pb.TagNumber(5)
  $core.bool hasIsExpired() => $_has(4);
  @$pb.TagNumber(5)
  void clearIsExpired() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get archiveNotice => $_getSZ(5);
  @$pb.TagNumber(6)
  set archiveNotice($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasArchiveNotice() => $_has(5);
  @$pb.TagNumber(6)
  void clearArchiveNotice() => $_clearField(6);
}

/// Opportunity represents an actionable opportunity record per database_schema.md §5.4.
class Opportunity extends $pb.GeneratedMessage {
  factory Opportunity({
    $core.String? opportunityId,
    $core.String? workspaceId,
    $core.String? opportunityType,
    $core.String? title,
    $core.String? summary,
    $core.String? whyItMatters,
    ExpectedImpact? expectedImpact,
    ExpectedEffort? expectedEffort,
    PriorityState? priorityState,
    $core.String? priorityReason,
    $core.String? suggestedNextStep,
    $core.String? ownerUserId,
    $2.ConfidenceBand? confidence,
    $2.SourceClass? sourceClass,
    $core.String? convertedToType,
    $core.String? convertedToId,
    $core.Iterable<OpportunitySourceRef>? sources,
    $1.Timestamp? createdAt,
    $1.Timestamp? updatedAt,
    $core.bool? isRepairable,
    $core.Iterable<$core.String>? repairReasons,
    EstimatedProfit? estimatedProfit,
    $core.bool? isSaved,
    $core.bool? isDismissed,
    $core.int? overallScore,
  }) {
    final result = Opportunity._();
    if (opportunityId != null) result.opportunityId = opportunityId;
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (opportunityType != null) result.opportunityType = opportunityType;
    if (title != null) result.title = title;
    if (summary != null) result.summary = summary;
    if (whyItMatters != null) result.whyItMatters = whyItMatters;
    if (expectedImpact != null) result.expectedImpact = expectedImpact;
    if (expectedEffort != null) result.expectedEffort = expectedEffort;
    if (priorityState != null) result.priorityState = priorityState;
    if (priorityReason != null) result.priorityReason = priorityReason;
    if (suggestedNextStep != null) result.suggestedNextStep = suggestedNextStep;
    if (ownerUserId != null) result.ownerUserId = ownerUserId;
    if (confidence != null) result.confidence = confidence;
    if (sourceClass != null) result.sourceClass = sourceClass;
    if (convertedToType != null) result.convertedToType = convertedToType;
    if (convertedToId != null) result.convertedToId = convertedToId;
    if (sources != null) result.sources.addAll(sources);
    if (createdAt != null) result.createdAt = createdAt;
    if (updatedAt != null) result.updatedAt = updatedAt;
    if (isRepairable != null) result.isRepairable = isRepairable;
    if (repairReasons != null) result.repairReasons.addAll(repairReasons);
    if (estimatedProfit != null) result.estimatedProfit = estimatedProfit;
    if (isSaved != null) result.isSaved = isSaved;
    if (isDismissed != null) result.isDismissed = isDismissed;
    if (overallScore != null) result.overallScore = overallScore;
    return result;
  }

  Opportunity._();

  factory Opportunity.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Opportunity()..mergeFromBuffer(data, registry);
  factory Opportunity.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Opportunity()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Opportunity',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.intelligence.v1'),
      createEmptyInstance: Opportunity.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'opportunityId')
    ..aOS(2, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(3, _omitFieldNames ? '' : 'opportunityType')
    ..aOS(4, _omitFieldNames ? '' : 'title')
    ..aOS(5, _omitFieldNames ? '' : 'summary')
    ..aOS(6, _omitFieldNames ? '' : 'whyItMatters')
    ..aOM<ExpectedImpact>(7, _omitFieldNames ? '' : 'expectedImpact',
        subBuilder: ExpectedImpact.$_createMessage)
    ..aOM<ExpectedEffort>(8, _omitFieldNames ? '' : 'expectedEffort',
        subBuilder: ExpectedEffort.$_createMessage)
    ..aE<PriorityState>(9, _omitFieldNames ? '' : 'priorityState',
        enumValues: PriorityState.values)
    ..aOS(10, _omitFieldNames ? '' : 'priorityReason')
    ..aOS(11, _omitFieldNames ? '' : 'suggestedNextStep')
    ..aOS(12, _omitFieldNames ? '' : 'ownerUserId')
    ..aE<$2.ConfidenceBand>(13, _omitFieldNames ? '' : 'confidence',
        enumValues: $2.ConfidenceBand.values)
    ..aE<$2.SourceClass>(14, _omitFieldNames ? '' : 'sourceClass',
        enumValues: $2.SourceClass.values)
    ..aOS(15, _omitFieldNames ? '' : 'convertedToType')
    ..aOS(16, _omitFieldNames ? '' : 'convertedToId')
    ..pPM<OpportunitySourceRef>(17, _omitFieldNames ? '' : 'sources',
        subBuilder: OpportunitySourceRef.$_createMessage)
    ..aOM<$1.Timestamp>(18, _omitFieldNames ? '' : 'createdAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..aOM<$1.Timestamp>(19, _omitFieldNames ? '' : 'updatedAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..aOB(20, _omitFieldNames ? '' : 'isRepairable')
    ..pPS(21, _omitFieldNames ? '' : 'repairReasons')
    ..aOM<EstimatedProfit>(22, _omitFieldNames ? '' : 'estimatedProfit',
        subBuilder: EstimatedProfit.$_createMessage)
    ..aOB(23, _omitFieldNames ? '' : 'isSaved')
    ..aOB(24, _omitFieldNames ? '' : 'isDismissed')
    ..aI(25, _omitFieldNames ? '' : 'overallScore')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Opportunity clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Opportunity copyWith(void Function(Opportunity) updates) =>
      super.copyWith((message) => updates(message as Opportunity))
          as Opportunity;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use Opportunity() / Opportunity.new instead')
  static Opportunity create() => Opportunity._();
  static $pb.GeneratedMessage $_createMessage() => Opportunity._();
  @$core.override
  Opportunity createEmptyInstance() => Opportunity._();
  @$core.pragma('dart2js:noInline')
  static Opportunity getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Opportunity>(
          Opportunity.$_createMessage);
  static Opportunity? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get opportunityId => $_getSZ(0);
  @$pb.TagNumber(1)
  set opportunityId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasOpportunityId() => $_has(0);
  @$pb.TagNumber(1)
  void clearOpportunityId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get workspaceId => $_getSZ(1);
  @$pb.TagNumber(2)
  set workspaceId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasWorkspaceId() => $_has(1);
  @$pb.TagNumber(2)
  void clearWorkspaceId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get opportunityType => $_getSZ(2);
  @$pb.TagNumber(3)
  set opportunityType($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasOpportunityType() => $_has(2);
  @$pb.TagNumber(3)
  void clearOpportunityType() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get title => $_getSZ(3);
  @$pb.TagNumber(4)
  set title($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasTitle() => $_has(3);
  @$pb.TagNumber(4)
  void clearTitle() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get summary => $_getSZ(4);
  @$pb.TagNumber(5)
  set summary($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasSummary() => $_has(4);
  @$pb.TagNumber(5)
  void clearSummary() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get whyItMatters => $_getSZ(5);
  @$pb.TagNumber(6)
  set whyItMatters($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasWhyItMatters() => $_has(5);
  @$pb.TagNumber(6)
  void clearWhyItMatters() => $_clearField(6);

  @$pb.TagNumber(7)
  ExpectedImpact get expectedImpact => $_getN(6);
  @$pb.TagNumber(7)
  set expectedImpact(ExpectedImpact value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasExpectedImpact() => $_has(6);
  @$pb.TagNumber(7)
  void clearExpectedImpact() => $_clearField(7);
  @$pb.TagNumber(7)
  ExpectedImpact ensureExpectedImpact() => $_ensure(6);

  @$pb.TagNumber(8)
  ExpectedEffort get expectedEffort => $_getN(7);
  @$pb.TagNumber(8)
  set expectedEffort(ExpectedEffort value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasExpectedEffort() => $_has(7);
  @$pb.TagNumber(8)
  void clearExpectedEffort() => $_clearField(8);
  @$pb.TagNumber(8)
  ExpectedEffort ensureExpectedEffort() => $_ensure(7);

  @$pb.TagNumber(9)
  PriorityState get priorityState => $_getN(8);
  @$pb.TagNumber(9)
  set priorityState(PriorityState value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasPriorityState() => $_has(8);
  @$pb.TagNumber(9)
  void clearPriorityState() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.String get priorityReason => $_getSZ(9);
  @$pb.TagNumber(10)
  set priorityReason($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasPriorityReason() => $_has(9);
  @$pb.TagNumber(10)
  void clearPriorityReason() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.String get suggestedNextStep => $_getSZ(10);
  @$pb.TagNumber(11)
  set suggestedNextStep($core.String value) => $_setString(10, value);
  @$pb.TagNumber(11)
  $core.bool hasSuggestedNextStep() => $_has(10);
  @$pb.TagNumber(11)
  void clearSuggestedNextStep() => $_clearField(11);

  @$pb.TagNumber(12)
  $core.String get ownerUserId => $_getSZ(11);
  @$pb.TagNumber(12)
  set ownerUserId($core.String value) => $_setString(11, value);
  @$pb.TagNumber(12)
  $core.bool hasOwnerUserId() => $_has(11);
  @$pb.TagNumber(12)
  void clearOwnerUserId() => $_clearField(12);

  @$pb.TagNumber(13)
  $2.ConfidenceBand get confidence => $_getN(12);
  @$pb.TagNumber(13)
  set confidence($2.ConfidenceBand value) => $_setField(13, value);
  @$pb.TagNumber(13)
  $core.bool hasConfidence() => $_has(12);
  @$pb.TagNumber(13)
  void clearConfidence() => $_clearField(13);

  @$pb.TagNumber(14)
  $2.SourceClass get sourceClass => $_getN(13);
  @$pb.TagNumber(14)
  set sourceClass($2.SourceClass value) => $_setField(14, value);
  @$pb.TagNumber(14)
  $core.bool hasSourceClass() => $_has(13);
  @$pb.TagNumber(14)
  void clearSourceClass() => $_clearField(14);

  @$pb.TagNumber(15)
  $core.String get convertedToType => $_getSZ(14);
  @$pb.TagNumber(15)
  set convertedToType($core.String value) => $_setString(14, value);
  @$pb.TagNumber(15)
  $core.bool hasConvertedToType() => $_has(14);
  @$pb.TagNumber(15)
  void clearConvertedToType() => $_clearField(15);

  @$pb.TagNumber(16)
  $core.String get convertedToId => $_getSZ(15);
  @$pb.TagNumber(16)
  set convertedToId($core.String value) => $_setString(15, value);
  @$pb.TagNumber(16)
  $core.bool hasConvertedToId() => $_has(15);
  @$pb.TagNumber(16)
  void clearConvertedToId() => $_clearField(16);

  @$pb.TagNumber(17)
  $pb.PbList<OpportunitySourceRef> get sources => $_getList(16);

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
  $core.bool get isRepairable => $_getBF(19);
  @$pb.TagNumber(20)
  set isRepairable($core.bool value) => $_setBool(19, value);
  @$pb.TagNumber(20)
  $core.bool hasIsRepairable() => $_has(19);
  @$pb.TagNumber(20)
  void clearIsRepairable() => $_clearField(20);

  @$pb.TagNumber(21)
  $pb.PbList<$core.String> get repairReasons => $_getList(20);

  @$pb.TagNumber(22)
  EstimatedProfit get estimatedProfit => $_getN(21);
  @$pb.TagNumber(22)
  set estimatedProfit(EstimatedProfit value) => $_setField(22, value);
  @$pb.TagNumber(22)
  $core.bool hasEstimatedProfit() => $_has(21);
  @$pb.TagNumber(22)
  void clearEstimatedProfit() => $_clearField(22);
  @$pb.TagNumber(22)
  EstimatedProfit ensureEstimatedProfit() => $_ensure(21);

  @$pb.TagNumber(23)
  $core.bool get isSaved => $_getBF(22);
  @$pb.TagNumber(23)
  set isSaved($core.bool value) => $_setBool(22, value);
  @$pb.TagNumber(23)
  $core.bool hasIsSaved() => $_has(22);
  @$pb.TagNumber(23)
  void clearIsSaved() => $_clearField(23);

  @$pb.TagNumber(24)
  $core.bool get isDismissed => $_getBF(23);
  @$pb.TagNumber(24)
  set isDismissed($core.bool value) => $_setBool(23, value);
  @$pb.TagNumber(24)
  $core.bool hasIsDismissed() => $_has(23);
  @$pb.TagNumber(24)
  void clearIsDismissed() => $_clearField(24);

  @$pb.TagNumber(25)
  $core.int get overallScore => $_getIZ(24);
  @$pb.TagNumber(25)
  set overallScore($core.int value) => $_setSignedInt32(24, value);
  @$pb.TagNumber(25)
  $core.bool hasOverallScore() => $_has(24);
  @$pb.TagNumber(25)
  void clearOverallScore() => $_clearField(25);
}

class OpportunityServiceListRequest extends $pb.GeneratedMessage {
  factory OpportunityServiceListRequest({
    $core.String? workspaceId,
    PriorityState? priorityState,
    $core.String? opportunityType,
    $core.String? ownerUserId,
    $2.ConfidenceBand? confidence,
    $core.int? pageSize,
    $core.String? pageToken,
  }) {
    final result = OpportunityServiceListRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (priorityState != null) result.priorityState = priorityState;
    if (opportunityType != null) result.opportunityType = opportunityType;
    if (ownerUserId != null) result.ownerUserId = ownerUserId;
    if (confidence != null) result.confidence = confidence;
    if (pageSize != null) result.pageSize = pageSize;
    if (pageToken != null) result.pageToken = pageToken;
    return result;
  }

  OpportunityServiceListRequest._();

  factory OpportunityServiceListRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      OpportunityServiceListRequest()..mergeFromBuffer(data, registry);
  factory OpportunityServiceListRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      OpportunityServiceListRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'OpportunityServiceListRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.intelligence.v1'),
      createEmptyInstance: OpportunityServiceListRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aE<PriorityState>(2, _omitFieldNames ? '' : 'priorityState',
        enumValues: PriorityState.values)
    ..aOS(3, _omitFieldNames ? '' : 'opportunityType')
    ..aOS(4, _omitFieldNames ? '' : 'ownerUserId')
    ..aE<$2.ConfidenceBand>(5, _omitFieldNames ? '' : 'confidence',
        enumValues: $2.ConfidenceBand.values)
    ..aI(6, _omitFieldNames ? '' : 'pageSize')
    ..aOS(7, _omitFieldNames ? '' : 'pageToken')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OpportunityServiceListRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OpportunityServiceListRequest copyWith(
          void Function(OpportunityServiceListRequest) updates) =>
      super.copyWith(
              (message) => updates(message as OpportunityServiceListRequest))
          as OpportunityServiceListRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use OpportunityServiceListRequest() / OpportunityServiceListRequest.new instead')
  static OpportunityServiceListRequest create() =>
      OpportunityServiceListRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      OpportunityServiceListRequest._();
  @$core.override
  OpportunityServiceListRequest createEmptyInstance() =>
      OpportunityServiceListRequest._();
  @$core.pragma('dart2js:noInline')
  static OpportunityServiceListRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<OpportunityServiceListRequest>(
          OpportunityServiceListRequest.$_createMessage);
  static OpportunityServiceListRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  PriorityState get priorityState => $_getN(1);
  @$pb.TagNumber(2)
  set priorityState(PriorityState value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasPriorityState() => $_has(1);
  @$pb.TagNumber(2)
  void clearPriorityState() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get opportunityType => $_getSZ(2);
  @$pb.TagNumber(3)
  set opportunityType($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasOpportunityType() => $_has(2);
  @$pb.TagNumber(3)
  void clearOpportunityType() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get ownerUserId => $_getSZ(3);
  @$pb.TagNumber(4)
  set ownerUserId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasOwnerUserId() => $_has(3);
  @$pb.TagNumber(4)
  void clearOwnerUserId() => $_clearField(4);

  @$pb.TagNumber(5)
  $2.ConfidenceBand get confidence => $_getN(4);
  @$pb.TagNumber(5)
  set confidence($2.ConfidenceBand value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasConfidence() => $_has(4);
  @$pb.TagNumber(5)
  void clearConfidence() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.int get pageSize => $_getIZ(5);
  @$pb.TagNumber(6)
  set pageSize($core.int value) => $_setSignedInt32(5, value);
  @$pb.TagNumber(6)
  $core.bool hasPageSize() => $_has(5);
  @$pb.TagNumber(6)
  void clearPageSize() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get pageToken => $_getSZ(6);
  @$pb.TagNumber(7)
  set pageToken($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasPageToken() => $_has(6);
  @$pb.TagNumber(7)
  void clearPageToken() => $_clearField(7);
}

class OpportunityServiceListResponse extends $pb.GeneratedMessage {
  factory OpportunityServiceListResponse({
    $core.Iterable<Opportunity>? opportunities,
    $core.String? nextPageToken,
    $core.int? totalCount,
    $core.double? avgScore,
    $core.int? newTodayCount,
  }) {
    final result = OpportunityServiceListResponse._();
    if (opportunities != null) result.opportunities.addAll(opportunities);
    if (nextPageToken != null) result.nextPageToken = nextPageToken;
    if (totalCount != null) result.totalCount = totalCount;
    if (avgScore != null) result.avgScore = avgScore;
    if (newTodayCount != null) result.newTodayCount = newTodayCount;
    return result;
  }

  OpportunityServiceListResponse._();

  factory OpportunityServiceListResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      OpportunityServiceListResponse()..mergeFromBuffer(data, registry);
  factory OpportunityServiceListResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      OpportunityServiceListResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'OpportunityServiceListResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.intelligence.v1'),
      createEmptyInstance: OpportunityServiceListResponse.$_createMessage)
    ..pPM<Opportunity>(1, _omitFieldNames ? '' : 'opportunities',
        subBuilder: Opportunity.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'nextPageToken')
    ..aI(3, _omitFieldNames ? '' : 'totalCount')
    ..aD(4, _omitFieldNames ? '' : 'avgScore', fieldType: $pb.PbFieldType.OF)
    ..aI(5, _omitFieldNames ? '' : 'newTodayCount')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OpportunityServiceListResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OpportunityServiceListResponse copyWith(
          void Function(OpportunityServiceListResponse) updates) =>
      super.copyWith(
              (message) => updates(message as OpportunityServiceListResponse))
          as OpportunityServiceListResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use OpportunityServiceListResponse() / OpportunityServiceListResponse.new instead')
  static OpportunityServiceListResponse create() =>
      OpportunityServiceListResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      OpportunityServiceListResponse._();
  @$core.override
  OpportunityServiceListResponse createEmptyInstance() =>
      OpportunityServiceListResponse._();
  @$core.pragma('dart2js:noInline')
  static OpportunityServiceListResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<OpportunityServiceListResponse>(
          OpportunityServiceListResponse.$_createMessage);
  static OpportunityServiceListResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Opportunity> get opportunities => $_getList(0);

  @$pb.TagNumber(2)
  $core.String get nextPageToken => $_getSZ(1);
  @$pb.TagNumber(2)
  set nextPageToken($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasNextPageToken() => $_has(1);
  @$pb.TagNumber(2)
  void clearNextPageToken() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get totalCount => $_getIZ(2);
  @$pb.TagNumber(3)
  set totalCount($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasTotalCount() => $_has(2);
  @$pb.TagNumber(3)
  void clearTotalCount() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.double get avgScore => $_getN(3);
  @$pb.TagNumber(4)
  set avgScore($core.double value) => $_setFloat(3, value);
  @$pb.TagNumber(4)
  $core.bool hasAvgScore() => $_has(3);
  @$pb.TagNumber(4)
  void clearAvgScore() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get newTodayCount => $_getIZ(4);
  @$pb.TagNumber(5)
  set newTodayCount($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasNewTodayCount() => $_has(4);
  @$pb.TagNumber(5)
  void clearNewTodayCount() => $_clearField(5);
}

class OpportunityServiceGetRequest extends $pb.GeneratedMessage {
  factory OpportunityServiceGetRequest({
    $core.String? workspaceId,
    $core.String? opportunityId,
  }) {
    final result = OpportunityServiceGetRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (opportunityId != null) result.opportunityId = opportunityId;
    return result;
  }

  OpportunityServiceGetRequest._();

  factory OpportunityServiceGetRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      OpportunityServiceGetRequest()..mergeFromBuffer(data, registry);
  factory OpportunityServiceGetRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      OpportunityServiceGetRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'OpportunityServiceGetRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.intelligence.v1'),
      createEmptyInstance: OpportunityServiceGetRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'opportunityId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OpportunityServiceGetRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OpportunityServiceGetRequest copyWith(
          void Function(OpportunityServiceGetRequest) updates) =>
      super.copyWith(
              (message) => updates(message as OpportunityServiceGetRequest))
          as OpportunityServiceGetRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use OpportunityServiceGetRequest() / OpportunityServiceGetRequest.new instead')
  static OpportunityServiceGetRequest create() =>
      OpportunityServiceGetRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      OpportunityServiceGetRequest._();
  @$core.override
  OpportunityServiceGetRequest createEmptyInstance() =>
      OpportunityServiceGetRequest._();
  @$core.pragma('dart2js:noInline')
  static OpportunityServiceGetRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<OpportunityServiceGetRequest>(
          OpportunityServiceGetRequest.$_createMessage);
  static OpportunityServiceGetRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get opportunityId => $_getSZ(1);
  @$pb.TagNumber(2)
  set opportunityId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasOpportunityId() => $_has(1);
  @$pb.TagNumber(2)
  void clearOpportunityId() => $_clearField(2);
}

class OpportunityServiceGetResponse extends $pb.GeneratedMessage {
  factory OpportunityServiceGetResponse({
    Opportunity? opportunity,
  }) {
    final result = OpportunityServiceGetResponse._();
    if (opportunity != null) result.opportunity = opportunity;
    return result;
  }

  OpportunityServiceGetResponse._();

  factory OpportunityServiceGetResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      OpportunityServiceGetResponse()..mergeFromBuffer(data, registry);
  factory OpportunityServiceGetResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      OpportunityServiceGetResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'OpportunityServiceGetResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.intelligence.v1'),
      createEmptyInstance: OpportunityServiceGetResponse.$_createMessage)
    ..aOM<Opportunity>(1, _omitFieldNames ? '' : 'opportunity',
        subBuilder: Opportunity.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OpportunityServiceGetResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OpportunityServiceGetResponse copyWith(
          void Function(OpportunityServiceGetResponse) updates) =>
      super.copyWith(
              (message) => updates(message as OpportunityServiceGetResponse))
          as OpportunityServiceGetResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use OpportunityServiceGetResponse() / OpportunityServiceGetResponse.new instead')
  static OpportunityServiceGetResponse create() =>
      OpportunityServiceGetResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      OpportunityServiceGetResponse._();
  @$core.override
  OpportunityServiceGetResponse createEmptyInstance() =>
      OpportunityServiceGetResponse._();
  @$core.pragma('dart2js:noInline')
  static OpportunityServiceGetResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<OpportunityServiceGetResponse>(
          OpportunityServiceGetResponse.$_createMessage);
  static OpportunityServiceGetResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Opportunity get opportunity => $_getN(0);
  @$pb.TagNumber(1)
  set opportunity(Opportunity value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasOpportunity() => $_has(0);
  @$pb.TagNumber(1)
  void clearOpportunity() => $_clearField(1);
  @$pb.TagNumber(1)
  Opportunity ensureOpportunity() => $_ensure(0);
}

class OpportunityServiceCreateRequest extends $pb.GeneratedMessage {
  factory OpportunityServiceCreateRequest({
    $core.String? workspaceId,
    $core.String? opportunityType,
    $core.String? title,
    $core.String? summary,
    $core.String? whyItMatters,
    ExpectedImpact? expectedImpact,
    ExpectedEffort? expectedEffort,
    $core.String? priorityReason,
    $2.ConfidenceBand? confidence,
    $core.Iterable<OpportunitySourceRef>? sourceRefs,
    $core.String? suggestedNextStep,
  }) {
    final result = OpportunityServiceCreateRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (opportunityType != null) result.opportunityType = opportunityType;
    if (title != null) result.title = title;
    if (summary != null) result.summary = summary;
    if (whyItMatters != null) result.whyItMatters = whyItMatters;
    if (expectedImpact != null) result.expectedImpact = expectedImpact;
    if (expectedEffort != null) result.expectedEffort = expectedEffort;
    if (priorityReason != null) result.priorityReason = priorityReason;
    if (confidence != null) result.confidence = confidence;
    if (sourceRefs != null) result.sourceRefs.addAll(sourceRefs);
    if (suggestedNextStep != null) result.suggestedNextStep = suggestedNextStep;
    return result;
  }

  OpportunityServiceCreateRequest._();

  factory OpportunityServiceCreateRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      OpportunityServiceCreateRequest()..mergeFromBuffer(data, registry);
  factory OpportunityServiceCreateRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      OpportunityServiceCreateRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'OpportunityServiceCreateRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.intelligence.v1'),
      createEmptyInstance: OpportunityServiceCreateRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'opportunityType')
    ..aOS(3, _omitFieldNames ? '' : 'title')
    ..aOS(4, _omitFieldNames ? '' : 'summary')
    ..aOS(5, _omitFieldNames ? '' : 'whyItMatters')
    ..aOM<ExpectedImpact>(6, _omitFieldNames ? '' : 'expectedImpact',
        subBuilder: ExpectedImpact.$_createMessage)
    ..aOM<ExpectedEffort>(7, _omitFieldNames ? '' : 'expectedEffort',
        subBuilder: ExpectedEffort.$_createMessage)
    ..aOS(8, _omitFieldNames ? '' : 'priorityReason')
    ..aE<$2.ConfidenceBand>(9, _omitFieldNames ? '' : 'confidence',
        enumValues: $2.ConfidenceBand.values)
    ..pPM<OpportunitySourceRef>(10, _omitFieldNames ? '' : 'sourceRefs',
        subBuilder: OpportunitySourceRef.$_createMessage)
    ..aOS(11, _omitFieldNames ? '' : 'suggestedNextStep')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OpportunityServiceCreateRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OpportunityServiceCreateRequest copyWith(
          void Function(OpportunityServiceCreateRequest) updates) =>
      super.copyWith(
              (message) => updates(message as OpportunityServiceCreateRequest))
          as OpportunityServiceCreateRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use OpportunityServiceCreateRequest() / OpportunityServiceCreateRequest.new instead')
  static OpportunityServiceCreateRequest create() =>
      OpportunityServiceCreateRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      OpportunityServiceCreateRequest._();
  @$core.override
  OpportunityServiceCreateRequest createEmptyInstance() =>
      OpportunityServiceCreateRequest._();
  @$core.pragma('dart2js:noInline')
  static OpportunityServiceCreateRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<OpportunityServiceCreateRequest>(
          OpportunityServiceCreateRequest.$_createMessage);
  static OpportunityServiceCreateRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get opportunityType => $_getSZ(1);
  @$pb.TagNumber(2)
  set opportunityType($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasOpportunityType() => $_has(1);
  @$pb.TagNumber(2)
  void clearOpportunityType() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get title => $_getSZ(2);
  @$pb.TagNumber(3)
  set title($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasTitle() => $_has(2);
  @$pb.TagNumber(3)
  void clearTitle() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get summary => $_getSZ(3);
  @$pb.TagNumber(4)
  set summary($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasSummary() => $_has(3);
  @$pb.TagNumber(4)
  void clearSummary() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get whyItMatters => $_getSZ(4);
  @$pb.TagNumber(5)
  set whyItMatters($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasWhyItMatters() => $_has(4);
  @$pb.TagNumber(5)
  void clearWhyItMatters() => $_clearField(5);

  @$pb.TagNumber(6)
  ExpectedImpact get expectedImpact => $_getN(5);
  @$pb.TagNumber(6)
  set expectedImpact(ExpectedImpact value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasExpectedImpact() => $_has(5);
  @$pb.TagNumber(6)
  void clearExpectedImpact() => $_clearField(6);
  @$pb.TagNumber(6)
  ExpectedImpact ensureExpectedImpact() => $_ensure(5);

  @$pb.TagNumber(7)
  ExpectedEffort get expectedEffort => $_getN(6);
  @$pb.TagNumber(7)
  set expectedEffort(ExpectedEffort value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasExpectedEffort() => $_has(6);
  @$pb.TagNumber(7)
  void clearExpectedEffort() => $_clearField(7);
  @$pb.TagNumber(7)
  ExpectedEffort ensureExpectedEffort() => $_ensure(6);

  @$pb.TagNumber(8)
  $core.String get priorityReason => $_getSZ(7);
  @$pb.TagNumber(8)
  set priorityReason($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasPriorityReason() => $_has(7);
  @$pb.TagNumber(8)
  void clearPriorityReason() => $_clearField(8);

  @$pb.TagNumber(9)
  $2.ConfidenceBand get confidence => $_getN(8);
  @$pb.TagNumber(9)
  set confidence($2.ConfidenceBand value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasConfidence() => $_has(8);
  @$pb.TagNumber(9)
  void clearConfidence() => $_clearField(9);

  @$pb.TagNumber(10)
  $pb.PbList<OpportunitySourceRef> get sourceRefs => $_getList(9);

  @$pb.TagNumber(11)
  $core.String get suggestedNextStep => $_getSZ(10);
  @$pb.TagNumber(11)
  set suggestedNextStep($core.String value) => $_setString(10, value);
  @$pb.TagNumber(11)
  $core.bool hasSuggestedNextStep() => $_has(10);
  @$pb.TagNumber(11)
  void clearSuggestedNextStep() => $_clearField(11);
}

class OpportunityServiceCreateResponse extends $pb.GeneratedMessage {
  factory OpportunityServiceCreateResponse({
    Opportunity? opportunity,
  }) {
    final result = OpportunityServiceCreateResponse._();
    if (opportunity != null) result.opportunity = opportunity;
    return result;
  }

  OpportunityServiceCreateResponse._();

  factory OpportunityServiceCreateResponse.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      OpportunityServiceCreateResponse()..mergeFromBuffer(data, registry);
  factory OpportunityServiceCreateResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      OpportunityServiceCreateResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'OpportunityServiceCreateResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.intelligence.v1'),
      createEmptyInstance: OpportunityServiceCreateResponse.$_createMessage)
    ..aOM<Opportunity>(1, _omitFieldNames ? '' : 'opportunity',
        subBuilder: Opportunity.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OpportunityServiceCreateResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OpportunityServiceCreateResponse copyWith(
          void Function(OpportunityServiceCreateResponse) updates) =>
      super.copyWith(
              (message) => updates(message as OpportunityServiceCreateResponse))
          as OpportunityServiceCreateResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use OpportunityServiceCreateResponse() / OpportunityServiceCreateResponse.new instead')
  static OpportunityServiceCreateResponse create() =>
      OpportunityServiceCreateResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      OpportunityServiceCreateResponse._();
  @$core.override
  OpportunityServiceCreateResponse createEmptyInstance() =>
      OpportunityServiceCreateResponse._();
  @$core.pragma('dart2js:noInline')
  static OpportunityServiceCreateResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<OpportunityServiceCreateResponse>(
          OpportunityServiceCreateResponse.$_createMessage);
  static OpportunityServiceCreateResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Opportunity get opportunity => $_getN(0);
  @$pb.TagNumber(1)
  set opportunity(Opportunity value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasOpportunity() => $_has(0);
  @$pb.TagNumber(1)
  void clearOpportunity() => $_clearField(1);
  @$pb.TagNumber(1)
  Opportunity ensureOpportunity() => $_ensure(0);
}

class OpportunityServiceUpdateStateRequest extends $pb.GeneratedMessage {
  factory OpportunityServiceUpdateStateRequest({
    $core.String? workspaceId,
    $core.String? opportunityId,
    $1.Timestamp? expectedUpdatedAt,
    PriorityState? newState,
    $core.String? reason,
    ExpectedImpact? expectedImpact,
    ExpectedEffort? expectedEffort,
    $core.String? priorityReason,
    $2.ConfidenceBand? confidence,
  }) {
    final result = OpportunityServiceUpdateStateRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (opportunityId != null) result.opportunityId = opportunityId;
    if (expectedUpdatedAt != null) result.expectedUpdatedAt = expectedUpdatedAt;
    if (newState != null) result.newState = newState;
    if (reason != null) result.reason = reason;
    if (expectedImpact != null) result.expectedImpact = expectedImpact;
    if (expectedEffort != null) result.expectedEffort = expectedEffort;
    if (priorityReason != null) result.priorityReason = priorityReason;
    if (confidence != null) result.confidence = confidence;
    return result;
  }

  OpportunityServiceUpdateStateRequest._();

  factory OpportunityServiceUpdateStateRequest.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      OpportunityServiceUpdateStateRequest()..mergeFromBuffer(data, registry);
  factory OpportunityServiceUpdateStateRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      OpportunityServiceUpdateStateRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'OpportunityServiceUpdateStateRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.intelligence.v1'),
      createEmptyInstance: OpportunityServiceUpdateStateRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'opportunityId')
    ..aOM<$1.Timestamp>(3, _omitFieldNames ? '' : 'expectedUpdatedAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..aE<PriorityState>(4, _omitFieldNames ? '' : 'newState',
        enumValues: PriorityState.values)
    ..aOS(5, _omitFieldNames ? '' : 'reason')
    ..aOM<ExpectedImpact>(6, _omitFieldNames ? '' : 'expectedImpact',
        subBuilder: ExpectedImpact.$_createMessage)
    ..aOM<ExpectedEffort>(7, _omitFieldNames ? '' : 'expectedEffort',
        subBuilder: ExpectedEffort.$_createMessage)
    ..aOS(8, _omitFieldNames ? '' : 'priorityReason')
    ..aE<$2.ConfidenceBand>(9, _omitFieldNames ? '' : 'confidence',
        enumValues: $2.ConfidenceBand.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OpportunityServiceUpdateStateRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OpportunityServiceUpdateStateRequest copyWith(
          void Function(OpportunityServiceUpdateStateRequest) updates) =>
      super.copyWith((message) =>
              updates(message as OpportunityServiceUpdateStateRequest))
          as OpportunityServiceUpdateStateRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use OpportunityServiceUpdateStateRequest() / OpportunityServiceUpdateStateRequest.new instead')
  static OpportunityServiceUpdateStateRequest create() =>
      OpportunityServiceUpdateStateRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      OpportunityServiceUpdateStateRequest._();
  @$core.override
  OpportunityServiceUpdateStateRequest createEmptyInstance() =>
      OpportunityServiceUpdateStateRequest._();
  @$core.pragma('dart2js:noInline')
  static OpportunityServiceUpdateStateRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
              OpportunityServiceUpdateStateRequest>(
          OpportunityServiceUpdateStateRequest.$_createMessage);
  static OpportunityServiceUpdateStateRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get opportunityId => $_getSZ(1);
  @$pb.TagNumber(2)
  set opportunityId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasOpportunityId() => $_has(1);
  @$pb.TagNumber(2)
  void clearOpportunityId() => $_clearField(2);

  @$pb.TagNumber(3)
  $1.Timestamp get expectedUpdatedAt => $_getN(2);
  @$pb.TagNumber(3)
  set expectedUpdatedAt($1.Timestamp value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasExpectedUpdatedAt() => $_has(2);
  @$pb.TagNumber(3)
  void clearExpectedUpdatedAt() => $_clearField(3);
  @$pb.TagNumber(3)
  $1.Timestamp ensureExpectedUpdatedAt() => $_ensure(2);

  @$pb.TagNumber(4)
  PriorityState get newState => $_getN(3);
  @$pb.TagNumber(4)
  set newState(PriorityState value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasNewState() => $_has(3);
  @$pb.TagNumber(4)
  void clearNewState() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get reason => $_getSZ(4);
  @$pb.TagNumber(5)
  set reason($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasReason() => $_has(4);
  @$pb.TagNumber(5)
  void clearReason() => $_clearField(5);

  @$pb.TagNumber(6)
  ExpectedImpact get expectedImpact => $_getN(5);
  @$pb.TagNumber(6)
  set expectedImpact(ExpectedImpact value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasExpectedImpact() => $_has(5);
  @$pb.TagNumber(6)
  void clearExpectedImpact() => $_clearField(6);
  @$pb.TagNumber(6)
  ExpectedImpact ensureExpectedImpact() => $_ensure(5);

  @$pb.TagNumber(7)
  ExpectedEffort get expectedEffort => $_getN(6);
  @$pb.TagNumber(7)
  set expectedEffort(ExpectedEffort value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasExpectedEffort() => $_has(6);
  @$pb.TagNumber(7)
  void clearExpectedEffort() => $_clearField(7);
  @$pb.TagNumber(7)
  ExpectedEffort ensureExpectedEffort() => $_ensure(6);

  @$pb.TagNumber(8)
  $core.String get priorityReason => $_getSZ(7);
  @$pb.TagNumber(8)
  set priorityReason($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasPriorityReason() => $_has(7);
  @$pb.TagNumber(8)
  void clearPriorityReason() => $_clearField(8);

  @$pb.TagNumber(9)
  $2.ConfidenceBand get confidence => $_getN(8);
  @$pb.TagNumber(9)
  set confidence($2.ConfidenceBand value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasConfidence() => $_has(8);
  @$pb.TagNumber(9)
  void clearConfidence() => $_clearField(9);
}

class OpportunityServiceUpdateStateResponse extends $pb.GeneratedMessage {
  factory OpportunityServiceUpdateStateResponse({
    Opportunity? opportunity,
  }) {
    final result = OpportunityServiceUpdateStateResponse._();
    if (opportunity != null) result.opportunity = opportunity;
    return result;
  }

  OpportunityServiceUpdateStateResponse._();

  factory OpportunityServiceUpdateStateResponse.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      OpportunityServiceUpdateStateResponse()..mergeFromBuffer(data, registry);
  factory OpportunityServiceUpdateStateResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      OpportunityServiceUpdateStateResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'OpportunityServiceUpdateStateResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.intelligence.v1'),
      createEmptyInstance:
          OpportunityServiceUpdateStateResponse.$_createMessage)
    ..aOM<Opportunity>(1, _omitFieldNames ? '' : 'opportunity',
        subBuilder: Opportunity.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OpportunityServiceUpdateStateResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OpportunityServiceUpdateStateResponse copyWith(
          void Function(OpportunityServiceUpdateStateResponse) updates) =>
      super.copyWith((message) =>
              updates(message as OpportunityServiceUpdateStateResponse))
          as OpportunityServiceUpdateStateResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use OpportunityServiceUpdateStateResponse() / OpportunityServiceUpdateStateResponse.new instead')
  static OpportunityServiceUpdateStateResponse create() =>
      OpportunityServiceUpdateStateResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      OpportunityServiceUpdateStateResponse._();
  @$core.override
  OpportunityServiceUpdateStateResponse createEmptyInstance() =>
      OpportunityServiceUpdateStateResponse._();
  @$core.pragma('dart2js:noInline')
  static OpportunityServiceUpdateStateResponse getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
              OpportunityServiceUpdateStateResponse>(
          OpportunityServiceUpdateStateResponse.$_createMessage);
  static OpportunityServiceUpdateStateResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Opportunity get opportunity => $_getN(0);
  @$pb.TagNumber(1)
  set opportunity(Opportunity value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasOpportunity() => $_has(0);
  @$pb.TagNumber(1)
  void clearOpportunity() => $_clearField(1);
  @$pb.TagNumber(1)
  Opportunity ensureOpportunity() => $_ensure(0);
}

class OpportunityServiceAssignRequest extends $pb.GeneratedMessage {
  factory OpportunityServiceAssignRequest({
    $core.String? workspaceId,
    $core.String? opportunityId,
    $1.Timestamp? expectedUpdatedAt,
    $core.String? ownerUserId,
  }) {
    final result = OpportunityServiceAssignRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (opportunityId != null) result.opportunityId = opportunityId;
    if (expectedUpdatedAt != null) result.expectedUpdatedAt = expectedUpdatedAt;
    if (ownerUserId != null) result.ownerUserId = ownerUserId;
    return result;
  }

  OpportunityServiceAssignRequest._();

  factory OpportunityServiceAssignRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      OpportunityServiceAssignRequest()..mergeFromBuffer(data, registry);
  factory OpportunityServiceAssignRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      OpportunityServiceAssignRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'OpportunityServiceAssignRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.intelligence.v1'),
      createEmptyInstance: OpportunityServiceAssignRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'opportunityId')
    ..aOM<$1.Timestamp>(3, _omitFieldNames ? '' : 'expectedUpdatedAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..aOS(4, _omitFieldNames ? '' : 'ownerUserId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OpportunityServiceAssignRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OpportunityServiceAssignRequest copyWith(
          void Function(OpportunityServiceAssignRequest) updates) =>
      super.copyWith(
              (message) => updates(message as OpportunityServiceAssignRequest))
          as OpportunityServiceAssignRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use OpportunityServiceAssignRequest() / OpportunityServiceAssignRequest.new instead')
  static OpportunityServiceAssignRequest create() =>
      OpportunityServiceAssignRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      OpportunityServiceAssignRequest._();
  @$core.override
  OpportunityServiceAssignRequest createEmptyInstance() =>
      OpportunityServiceAssignRequest._();
  @$core.pragma('dart2js:noInline')
  static OpportunityServiceAssignRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<OpportunityServiceAssignRequest>(
          OpportunityServiceAssignRequest.$_createMessage);
  static OpportunityServiceAssignRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get opportunityId => $_getSZ(1);
  @$pb.TagNumber(2)
  set opportunityId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasOpportunityId() => $_has(1);
  @$pb.TagNumber(2)
  void clearOpportunityId() => $_clearField(2);

  @$pb.TagNumber(3)
  $1.Timestamp get expectedUpdatedAt => $_getN(2);
  @$pb.TagNumber(3)
  set expectedUpdatedAt($1.Timestamp value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasExpectedUpdatedAt() => $_has(2);
  @$pb.TagNumber(3)
  void clearExpectedUpdatedAt() => $_clearField(3);
  @$pb.TagNumber(3)
  $1.Timestamp ensureExpectedUpdatedAt() => $_ensure(2);

  @$pb.TagNumber(4)
  $core.String get ownerUserId => $_getSZ(3);
  @$pb.TagNumber(4)
  set ownerUserId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasOwnerUserId() => $_has(3);
  @$pb.TagNumber(4)
  void clearOwnerUserId() => $_clearField(4);
}

class OpportunityServiceAssignResponse extends $pb.GeneratedMessage {
  factory OpportunityServiceAssignResponse({
    Opportunity? opportunity,
  }) {
    final result = OpportunityServiceAssignResponse._();
    if (opportunity != null) result.opportunity = opportunity;
    return result;
  }

  OpportunityServiceAssignResponse._();

  factory OpportunityServiceAssignResponse.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      OpportunityServiceAssignResponse()..mergeFromBuffer(data, registry);
  factory OpportunityServiceAssignResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      OpportunityServiceAssignResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'OpportunityServiceAssignResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.intelligence.v1'),
      createEmptyInstance: OpportunityServiceAssignResponse.$_createMessage)
    ..aOM<Opportunity>(1, _omitFieldNames ? '' : 'opportunity',
        subBuilder: Opportunity.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OpportunityServiceAssignResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OpportunityServiceAssignResponse copyWith(
          void Function(OpportunityServiceAssignResponse) updates) =>
      super.copyWith(
              (message) => updates(message as OpportunityServiceAssignResponse))
          as OpportunityServiceAssignResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use OpportunityServiceAssignResponse() / OpportunityServiceAssignResponse.new instead')
  static OpportunityServiceAssignResponse create() =>
      OpportunityServiceAssignResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      OpportunityServiceAssignResponse._();
  @$core.override
  OpportunityServiceAssignResponse createEmptyInstance() =>
      OpportunityServiceAssignResponse._();
  @$core.pragma('dart2js:noInline')
  static OpportunityServiceAssignResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<OpportunityServiceAssignResponse>(
          OpportunityServiceAssignResponse.$_createMessage);
  static OpportunityServiceAssignResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Opportunity get opportunity => $_getN(0);
  @$pb.TagNumber(1)
  set opportunity(Opportunity value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasOpportunity() => $_has(0);
  @$pb.TagNumber(1)
  void clearOpportunity() => $_clearField(1);
  @$pb.TagNumber(1)
  Opportunity ensureOpportunity() => $_ensure(0);
}

class OpportunityServiceConvertRequest extends $pb.GeneratedMessage {
  factory OpportunityServiceConvertRequest({
    $core.String? workspaceId,
    $core.String? opportunityId,
    $1.Timestamp? expectedUpdatedAt,
    $core.String? conversionType,
    $core.String? title,
    $core.String? notes,
  }) {
    final result = OpportunityServiceConvertRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (opportunityId != null) result.opportunityId = opportunityId;
    if (expectedUpdatedAt != null) result.expectedUpdatedAt = expectedUpdatedAt;
    if (conversionType != null) result.conversionType = conversionType;
    if (title != null) result.title = title;
    if (notes != null) result.notes = notes;
    return result;
  }

  OpportunityServiceConvertRequest._();

  factory OpportunityServiceConvertRequest.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      OpportunityServiceConvertRequest()..mergeFromBuffer(data, registry);
  factory OpportunityServiceConvertRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      OpportunityServiceConvertRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'OpportunityServiceConvertRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.intelligence.v1'),
      createEmptyInstance: OpportunityServiceConvertRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'opportunityId')
    ..aOM<$1.Timestamp>(3, _omitFieldNames ? '' : 'expectedUpdatedAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..aOS(4, _omitFieldNames ? '' : 'conversionType')
    ..aOS(5, _omitFieldNames ? '' : 'title')
    ..aOS(6, _omitFieldNames ? '' : 'notes')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OpportunityServiceConvertRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OpportunityServiceConvertRequest copyWith(
          void Function(OpportunityServiceConvertRequest) updates) =>
      super.copyWith(
              (message) => updates(message as OpportunityServiceConvertRequest))
          as OpportunityServiceConvertRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use OpportunityServiceConvertRequest() / OpportunityServiceConvertRequest.new instead')
  static OpportunityServiceConvertRequest create() =>
      OpportunityServiceConvertRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      OpportunityServiceConvertRequest._();
  @$core.override
  OpportunityServiceConvertRequest createEmptyInstance() =>
      OpportunityServiceConvertRequest._();
  @$core.pragma('dart2js:noInline')
  static OpportunityServiceConvertRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<OpportunityServiceConvertRequest>(
          OpportunityServiceConvertRequest.$_createMessage);
  static OpportunityServiceConvertRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get opportunityId => $_getSZ(1);
  @$pb.TagNumber(2)
  set opportunityId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasOpportunityId() => $_has(1);
  @$pb.TagNumber(2)
  void clearOpportunityId() => $_clearField(2);

  @$pb.TagNumber(3)
  $1.Timestamp get expectedUpdatedAt => $_getN(2);
  @$pb.TagNumber(3)
  set expectedUpdatedAt($1.Timestamp value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasExpectedUpdatedAt() => $_has(2);
  @$pb.TagNumber(3)
  void clearExpectedUpdatedAt() => $_clearField(3);
  @$pb.TagNumber(3)
  $1.Timestamp ensureExpectedUpdatedAt() => $_ensure(2);

  @$pb.TagNumber(4)
  $core.String get conversionType => $_getSZ(3);
  @$pb.TagNumber(4)
  set conversionType($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasConversionType() => $_has(3);
  @$pb.TagNumber(4)
  void clearConversionType() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get title => $_getSZ(4);
  @$pb.TagNumber(5)
  set title($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasTitle() => $_has(4);
  @$pb.TagNumber(5)
  void clearTitle() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get notes => $_getSZ(5);
  @$pb.TagNumber(6)
  set notes($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasNotes() => $_has(5);
  @$pb.TagNumber(6)
  void clearNotes() => $_clearField(6);
}

class OpportunityServiceConvertResponse extends $pb.GeneratedMessage {
  factory OpportunityServiceConvertResponse({
    Opportunity? opportunity,
    $core.String? convertedToType,
    $core.String? convertedToId,
    $core.String? targetRoute,
  }) {
    final result = OpportunityServiceConvertResponse._();
    if (opportunity != null) result.opportunity = opportunity;
    if (convertedToType != null) result.convertedToType = convertedToType;
    if (convertedToId != null) result.convertedToId = convertedToId;
    if (targetRoute != null) result.targetRoute = targetRoute;
    return result;
  }

  OpportunityServiceConvertResponse._();

  factory OpportunityServiceConvertResponse.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      OpportunityServiceConvertResponse()..mergeFromBuffer(data, registry);
  factory OpportunityServiceConvertResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      OpportunityServiceConvertResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'OpportunityServiceConvertResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.intelligence.v1'),
      createEmptyInstance: OpportunityServiceConvertResponse.$_createMessage)
    ..aOM<Opportunity>(1, _omitFieldNames ? '' : 'opportunity',
        subBuilder: Opportunity.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'convertedToType')
    ..aOS(3, _omitFieldNames ? '' : 'convertedToId')
    ..aOS(4, _omitFieldNames ? '' : 'targetRoute')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OpportunityServiceConvertResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OpportunityServiceConvertResponse copyWith(
          void Function(OpportunityServiceConvertResponse) updates) =>
      super.copyWith((message) =>
              updates(message as OpportunityServiceConvertResponse))
          as OpportunityServiceConvertResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use OpportunityServiceConvertResponse() / OpportunityServiceConvertResponse.new instead')
  static OpportunityServiceConvertResponse create() =>
      OpportunityServiceConvertResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      OpportunityServiceConvertResponse._();
  @$core.override
  OpportunityServiceConvertResponse createEmptyInstance() =>
      OpportunityServiceConvertResponse._();
  @$core.pragma('dart2js:noInline')
  static OpportunityServiceConvertResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<OpportunityServiceConvertResponse>(
          OpportunityServiceConvertResponse.$_createMessage);
  static OpportunityServiceConvertResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Opportunity get opportunity => $_getN(0);
  @$pb.TagNumber(1)
  set opportunity(Opportunity value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasOpportunity() => $_has(0);
  @$pb.TagNumber(1)
  void clearOpportunity() => $_clearField(1);
  @$pb.TagNumber(1)
  Opportunity ensureOpportunity() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get convertedToType => $_getSZ(1);
  @$pb.TagNumber(2)
  set convertedToType($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasConvertedToType() => $_has(1);
  @$pb.TagNumber(2)
  void clearConvertedToType() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get convertedToId => $_getSZ(2);
  @$pb.TagNumber(3)
  set convertedToId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasConvertedToId() => $_has(2);
  @$pb.TagNumber(3)
  void clearConvertedToId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get targetRoute => $_getSZ(3);
  @$pb.TagNumber(4)
  set targetRoute($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasTargetRoute() => $_has(3);
  @$pb.TagNumber(4)
  void clearTargetRoute() => $_clearField(4);
}

class OpportunityServiceSaveRequest extends $pb.GeneratedMessage {
  factory OpportunityServiceSaveRequest({
    $core.String? workspaceId,
    $core.String? opportunityId,
  }) {
    final result = OpportunityServiceSaveRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (opportunityId != null) result.opportunityId = opportunityId;
    return result;
  }

  OpportunityServiceSaveRequest._();

  factory OpportunityServiceSaveRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      OpportunityServiceSaveRequest()..mergeFromBuffer(data, registry);
  factory OpportunityServiceSaveRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      OpportunityServiceSaveRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'OpportunityServiceSaveRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.intelligence.v1'),
      createEmptyInstance: OpportunityServiceSaveRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'opportunityId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OpportunityServiceSaveRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OpportunityServiceSaveRequest copyWith(
          void Function(OpportunityServiceSaveRequest) updates) =>
      super.copyWith(
              (message) => updates(message as OpportunityServiceSaveRequest))
          as OpportunityServiceSaveRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use OpportunityServiceSaveRequest() / OpportunityServiceSaveRequest.new instead')
  static OpportunityServiceSaveRequest create() =>
      OpportunityServiceSaveRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      OpportunityServiceSaveRequest._();
  @$core.override
  OpportunityServiceSaveRequest createEmptyInstance() =>
      OpportunityServiceSaveRequest._();
  @$core.pragma('dart2js:noInline')
  static OpportunityServiceSaveRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<OpportunityServiceSaveRequest>(
          OpportunityServiceSaveRequest.$_createMessage);
  static OpportunityServiceSaveRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get opportunityId => $_getSZ(1);
  @$pb.TagNumber(2)
  set opportunityId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasOpportunityId() => $_has(1);
  @$pb.TagNumber(2)
  void clearOpportunityId() => $_clearField(2);
}

class OpportunityServiceSaveResponse extends $pb.GeneratedMessage {
  factory OpportunityServiceSaveResponse({
    Opportunity? opportunity,
  }) {
    final result = OpportunityServiceSaveResponse._();
    if (opportunity != null) result.opportunity = opportunity;
    return result;
  }

  OpportunityServiceSaveResponse._();

  factory OpportunityServiceSaveResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      OpportunityServiceSaveResponse()..mergeFromBuffer(data, registry);
  factory OpportunityServiceSaveResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      OpportunityServiceSaveResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'OpportunityServiceSaveResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.intelligence.v1'),
      createEmptyInstance: OpportunityServiceSaveResponse.$_createMessage)
    ..aOM<Opportunity>(1, _omitFieldNames ? '' : 'opportunity',
        subBuilder: Opportunity.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OpportunityServiceSaveResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OpportunityServiceSaveResponse copyWith(
          void Function(OpportunityServiceSaveResponse) updates) =>
      super.copyWith(
              (message) => updates(message as OpportunityServiceSaveResponse))
          as OpportunityServiceSaveResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use OpportunityServiceSaveResponse() / OpportunityServiceSaveResponse.new instead')
  static OpportunityServiceSaveResponse create() =>
      OpportunityServiceSaveResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      OpportunityServiceSaveResponse._();
  @$core.override
  OpportunityServiceSaveResponse createEmptyInstance() =>
      OpportunityServiceSaveResponse._();
  @$core.pragma('dart2js:noInline')
  static OpportunityServiceSaveResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<OpportunityServiceSaveResponse>(
          OpportunityServiceSaveResponse.$_createMessage);
  static OpportunityServiceSaveResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Opportunity get opportunity => $_getN(0);
  @$pb.TagNumber(1)
  set opportunity(Opportunity value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasOpportunity() => $_has(0);
  @$pb.TagNumber(1)
  void clearOpportunity() => $_clearField(1);
  @$pb.TagNumber(1)
  Opportunity ensureOpportunity() => $_ensure(0);
}

class OpportunityServiceDismissRequest extends $pb.GeneratedMessage {
  factory OpportunityServiceDismissRequest({
    $core.String? workspaceId,
    $core.String? opportunityId,
    $core.String? reason,
  }) {
    final result = OpportunityServiceDismissRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (opportunityId != null) result.opportunityId = opportunityId;
    if (reason != null) result.reason = reason;
    return result;
  }

  OpportunityServiceDismissRequest._();

  factory OpportunityServiceDismissRequest.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      OpportunityServiceDismissRequest()..mergeFromBuffer(data, registry);
  factory OpportunityServiceDismissRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      OpportunityServiceDismissRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'OpportunityServiceDismissRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.intelligence.v1'),
      createEmptyInstance: OpportunityServiceDismissRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'opportunityId')
    ..aOS(3, _omitFieldNames ? '' : 'reason')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OpportunityServiceDismissRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OpportunityServiceDismissRequest copyWith(
          void Function(OpportunityServiceDismissRequest) updates) =>
      super.copyWith(
              (message) => updates(message as OpportunityServiceDismissRequest))
          as OpportunityServiceDismissRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use OpportunityServiceDismissRequest() / OpportunityServiceDismissRequest.new instead')
  static OpportunityServiceDismissRequest create() =>
      OpportunityServiceDismissRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      OpportunityServiceDismissRequest._();
  @$core.override
  OpportunityServiceDismissRequest createEmptyInstance() =>
      OpportunityServiceDismissRequest._();
  @$core.pragma('dart2js:noInline')
  static OpportunityServiceDismissRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<OpportunityServiceDismissRequest>(
          OpportunityServiceDismissRequest.$_createMessage);
  static OpportunityServiceDismissRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get opportunityId => $_getSZ(1);
  @$pb.TagNumber(2)
  set opportunityId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasOpportunityId() => $_has(1);
  @$pb.TagNumber(2)
  void clearOpportunityId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get reason => $_getSZ(2);
  @$pb.TagNumber(3)
  set reason($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasReason() => $_has(2);
  @$pb.TagNumber(3)
  void clearReason() => $_clearField(3);
}

class OpportunityServiceDismissResponse extends $pb.GeneratedMessage {
  factory OpportunityServiceDismissResponse({
    Opportunity? opportunity,
  }) {
    final result = OpportunityServiceDismissResponse._();
    if (opportunity != null) result.opportunity = opportunity;
    return result;
  }

  OpportunityServiceDismissResponse._();

  factory OpportunityServiceDismissResponse.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      OpportunityServiceDismissResponse()..mergeFromBuffer(data, registry);
  factory OpportunityServiceDismissResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      OpportunityServiceDismissResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'OpportunityServiceDismissResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.intelligence.v1'),
      createEmptyInstance: OpportunityServiceDismissResponse.$_createMessage)
    ..aOM<Opportunity>(1, _omitFieldNames ? '' : 'opportunity',
        subBuilder: Opportunity.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OpportunityServiceDismissResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OpportunityServiceDismissResponse copyWith(
          void Function(OpportunityServiceDismissResponse) updates) =>
      super.copyWith((message) =>
              updates(message as OpportunityServiceDismissResponse))
          as OpportunityServiceDismissResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use OpportunityServiceDismissResponse() / OpportunityServiceDismissResponse.new instead')
  static OpportunityServiceDismissResponse create() =>
      OpportunityServiceDismissResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      OpportunityServiceDismissResponse._();
  @$core.override
  OpportunityServiceDismissResponse createEmptyInstance() =>
      OpportunityServiceDismissResponse._();
  @$core.pragma('dart2js:noInline')
  static OpportunityServiceDismissResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<OpportunityServiceDismissResponse>(
          OpportunityServiceDismissResponse.$_createMessage);
  static OpportunityServiceDismissResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Opportunity get opportunity => $_getN(0);
  @$pb.TagNumber(1)
  set opportunity(Opportunity value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasOpportunity() => $_has(0);
  @$pb.TagNumber(1)
  void clearOpportunity() => $_clearField(1);
  @$pb.TagNumber(1)
  Opportunity ensureOpportunity() => $_ensure(0);
}

class OpportunityServiceListRelatedRequest extends $pb.GeneratedMessage {
  factory OpportunityServiceListRelatedRequest({
    $core.String? workspaceId,
    $core.String? opportunityId,
    $core.int? limit,
  }) {
    final result = OpportunityServiceListRelatedRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (opportunityId != null) result.opportunityId = opportunityId;
    if (limit != null) result.limit = limit;
    return result;
  }

  OpportunityServiceListRelatedRequest._();

  factory OpportunityServiceListRelatedRequest.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      OpportunityServiceListRelatedRequest()..mergeFromBuffer(data, registry);
  factory OpportunityServiceListRelatedRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      OpportunityServiceListRelatedRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'OpportunityServiceListRelatedRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.intelligence.v1'),
      createEmptyInstance: OpportunityServiceListRelatedRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'opportunityId')
    ..aI(3, _omitFieldNames ? '' : 'limit')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OpportunityServiceListRelatedRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OpportunityServiceListRelatedRequest copyWith(
          void Function(OpportunityServiceListRelatedRequest) updates) =>
      super.copyWith((message) =>
              updates(message as OpportunityServiceListRelatedRequest))
          as OpportunityServiceListRelatedRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use OpportunityServiceListRelatedRequest() / OpportunityServiceListRelatedRequest.new instead')
  static OpportunityServiceListRelatedRequest create() =>
      OpportunityServiceListRelatedRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      OpportunityServiceListRelatedRequest._();
  @$core.override
  OpportunityServiceListRelatedRequest createEmptyInstance() =>
      OpportunityServiceListRelatedRequest._();
  @$core.pragma('dart2js:noInline')
  static OpportunityServiceListRelatedRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
              OpportunityServiceListRelatedRequest>(
          OpportunityServiceListRelatedRequest.$_createMessage);
  static OpportunityServiceListRelatedRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get opportunityId => $_getSZ(1);
  @$pb.TagNumber(2)
  set opportunityId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasOpportunityId() => $_has(1);
  @$pb.TagNumber(2)
  void clearOpportunityId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get limit => $_getIZ(2);
  @$pb.TagNumber(3)
  set limit($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasLimit() => $_has(2);
  @$pb.TagNumber(3)
  void clearLimit() => $_clearField(3);
}

class OpportunityServiceListRelatedResponse extends $pb.GeneratedMessage {
  factory OpportunityServiceListRelatedResponse({
    $core.Iterable<Opportunity>? relatedOpportunities,
  }) {
    final result = OpportunityServiceListRelatedResponse._();
    if (relatedOpportunities != null)
      result.relatedOpportunities.addAll(relatedOpportunities);
    return result;
  }

  OpportunityServiceListRelatedResponse._();

  factory OpportunityServiceListRelatedResponse.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      OpportunityServiceListRelatedResponse()..mergeFromBuffer(data, registry);
  factory OpportunityServiceListRelatedResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      OpportunityServiceListRelatedResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'OpportunityServiceListRelatedResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.intelligence.v1'),
      createEmptyInstance:
          OpportunityServiceListRelatedResponse.$_createMessage)
    ..pPM<Opportunity>(1, _omitFieldNames ? '' : 'relatedOpportunities',
        subBuilder: Opportunity.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OpportunityServiceListRelatedResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OpportunityServiceListRelatedResponse copyWith(
          void Function(OpportunityServiceListRelatedResponse) updates) =>
      super.copyWith((message) =>
              updates(message as OpportunityServiceListRelatedResponse))
          as OpportunityServiceListRelatedResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use OpportunityServiceListRelatedResponse() / OpportunityServiceListRelatedResponse.new instead')
  static OpportunityServiceListRelatedResponse create() =>
      OpportunityServiceListRelatedResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      OpportunityServiceListRelatedResponse._();
  @$core.override
  OpportunityServiceListRelatedResponse createEmptyInstance() =>
      OpportunityServiceListRelatedResponse._();
  @$core.pragma('dart2js:noInline')
  static OpportunityServiceListRelatedResponse getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
              OpportunityServiceListRelatedResponse>(
          OpportunityServiceListRelatedResponse.$_createMessage);
  static OpportunityServiceListRelatedResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Opportunity> get relatedOpportunities => $_getList(0);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');

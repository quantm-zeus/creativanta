// This is a generated file - do not edit.
//
// Generated from creativanta/admin/v1/dashboard.proto.

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
import 'dashboard.pbenum.dart';

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'dashboard.pbenum.dart';

class DecisionCard extends $pb.GeneratedMessage {
  factory DecisionCard({
    $core.String? cardId,
    $core.String? cardFamily,
    $core.String? title,
    $core.String? description,
    $core.String? primaryCtaLabel,
    $core.String? primaryCtaRoute,
    $core.bool? isActionAvailable,
    $core.String? unavailableReason,
    DataSourceBadge? dataSource,
    ConfidenceLevel? confidence,
    $core.String? whyThisMatters,
    $core.int? priorityRank,
    $core.String? moduleRef,
    UIStateType? stateType,
    $core.String? repairInstructions,
  }) {
    final result = DecisionCard._();
    if (cardId != null) result.cardId = cardId;
    if (cardFamily != null) result.cardFamily = cardFamily;
    if (title != null) result.title = title;
    if (description != null) result.description = description;
    if (primaryCtaLabel != null) result.primaryCtaLabel = primaryCtaLabel;
    if (primaryCtaRoute != null) result.primaryCtaRoute = primaryCtaRoute;
    if (isActionAvailable != null) result.isActionAvailable = isActionAvailable;
    if (unavailableReason != null) result.unavailableReason = unavailableReason;
    if (dataSource != null) result.dataSource = dataSource;
    if (confidence != null) result.confidence = confidence;
    if (whyThisMatters != null) result.whyThisMatters = whyThisMatters;
    if (priorityRank != null) result.priorityRank = priorityRank;
    if (moduleRef != null) result.moduleRef = moduleRef;
    if (stateType != null) result.stateType = stateType;
    if (repairInstructions != null)
      result.repairInstructions = repairInstructions;
    return result;
  }

  DecisionCard._();

  factory DecisionCard.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      DecisionCard()..mergeFromBuffer(data, registry);
  factory DecisionCard.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      DecisionCard()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DecisionCard',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.admin.v1'),
      createEmptyInstance: DecisionCard.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'cardId')
    ..aOS(2, _omitFieldNames ? '' : 'cardFamily')
    ..aOS(3, _omitFieldNames ? '' : 'title')
    ..aOS(4, _omitFieldNames ? '' : 'description')
    ..aOS(5, _omitFieldNames ? '' : 'primaryCtaLabel')
    ..aOS(6, _omitFieldNames ? '' : 'primaryCtaRoute')
    ..aOB(7, _omitFieldNames ? '' : 'isActionAvailable')
    ..aOS(8, _omitFieldNames ? '' : 'unavailableReason')
    ..aE<DataSourceBadge>(9, _omitFieldNames ? '' : 'dataSource',
        enumValues: DataSourceBadge.values)
    ..aE<ConfidenceLevel>(10, _omitFieldNames ? '' : 'confidence',
        enumValues: ConfidenceLevel.values)
    ..aOS(11, _omitFieldNames ? '' : 'whyThisMatters')
    ..aI(12, _omitFieldNames ? '' : 'priorityRank')
    ..aOS(13, _omitFieldNames ? '' : 'moduleRef')
    ..aE<UIStateType>(14, _omitFieldNames ? '' : 'stateType',
        enumValues: UIStateType.values)
    ..aOS(15, _omitFieldNames ? '' : 'repairInstructions')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DecisionCard clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DecisionCard copyWith(void Function(DecisionCard) updates) =>
      super.copyWith((message) => updates(message as DecisionCard))
          as DecisionCard;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use DecisionCard() / DecisionCard.new instead')
  static DecisionCard create() => DecisionCard._();
  static $pb.GeneratedMessage $_createMessage() => DecisionCard._();
  @$core.override
  DecisionCard createEmptyInstance() => DecisionCard._();
  @$core.pragma('dart2js:noInline')
  static DecisionCard getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DecisionCard>(
          DecisionCard.$_createMessage);
  static DecisionCard? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get cardId => $_getSZ(0);
  @$pb.TagNumber(1)
  set cardId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCardId() => $_has(0);
  @$pb.TagNumber(1)
  void clearCardId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get cardFamily => $_getSZ(1);
  @$pb.TagNumber(2)
  set cardFamily($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCardFamily() => $_has(1);
  @$pb.TagNumber(2)
  void clearCardFamily() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get title => $_getSZ(2);
  @$pb.TagNumber(3)
  set title($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasTitle() => $_has(2);
  @$pb.TagNumber(3)
  void clearTitle() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get description => $_getSZ(3);
  @$pb.TagNumber(4)
  set description($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasDescription() => $_has(3);
  @$pb.TagNumber(4)
  void clearDescription() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get primaryCtaLabel => $_getSZ(4);
  @$pb.TagNumber(5)
  set primaryCtaLabel($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasPrimaryCtaLabel() => $_has(4);
  @$pb.TagNumber(5)
  void clearPrimaryCtaLabel() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get primaryCtaRoute => $_getSZ(5);
  @$pb.TagNumber(6)
  set primaryCtaRoute($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasPrimaryCtaRoute() => $_has(5);
  @$pb.TagNumber(6)
  void clearPrimaryCtaRoute() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.bool get isActionAvailable => $_getBF(6);
  @$pb.TagNumber(7)
  set isActionAvailable($core.bool value) => $_setBool(6, value);
  @$pb.TagNumber(7)
  $core.bool hasIsActionAvailable() => $_has(6);
  @$pb.TagNumber(7)
  void clearIsActionAvailable() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get unavailableReason => $_getSZ(7);
  @$pb.TagNumber(8)
  set unavailableReason($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasUnavailableReason() => $_has(7);
  @$pb.TagNumber(8)
  void clearUnavailableReason() => $_clearField(8);

  @$pb.TagNumber(9)
  DataSourceBadge get dataSource => $_getN(8);
  @$pb.TagNumber(9)
  set dataSource(DataSourceBadge value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasDataSource() => $_has(8);
  @$pb.TagNumber(9)
  void clearDataSource() => $_clearField(9);

  @$pb.TagNumber(10)
  ConfidenceLevel get confidence => $_getN(9);
  @$pb.TagNumber(10)
  set confidence(ConfidenceLevel value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasConfidence() => $_has(9);
  @$pb.TagNumber(10)
  void clearConfidence() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.String get whyThisMatters => $_getSZ(10);
  @$pb.TagNumber(11)
  set whyThisMatters($core.String value) => $_setString(10, value);
  @$pb.TagNumber(11)
  $core.bool hasWhyThisMatters() => $_has(10);
  @$pb.TagNumber(11)
  void clearWhyThisMatters() => $_clearField(11);

  @$pb.TagNumber(12)
  $core.int get priorityRank => $_getIZ(11);
  @$pb.TagNumber(12)
  set priorityRank($core.int value) => $_setSignedInt32(11, value);
  @$pb.TagNumber(12)
  $core.bool hasPriorityRank() => $_has(11);
  @$pb.TagNumber(12)
  void clearPriorityRank() => $_clearField(12);

  @$pb.TagNumber(13)
  $core.String get moduleRef => $_getSZ(12);
  @$pb.TagNumber(13)
  set moduleRef($core.String value) => $_setString(12, value);
  @$pb.TagNumber(13)
  $core.bool hasModuleRef() => $_has(12);
  @$pb.TagNumber(13)
  void clearModuleRef() => $_clearField(13);

  @$pb.TagNumber(14)
  UIStateType get stateType => $_getN(13);
  @$pb.TagNumber(14)
  set stateType(UIStateType value) => $_setField(14, value);
  @$pb.TagNumber(14)
  $core.bool hasStateType() => $_has(13);
  @$pb.TagNumber(14)
  void clearStateType() => $_clearField(14);

  @$pb.TagNumber(15)
  $core.String get repairInstructions => $_getSZ(14);
  @$pb.TagNumber(15)
  set repairInstructions($core.String value) => $_setString(14, value);
  @$pb.TagNumber(15)
  $core.bool hasRepairInstructions() => $_has(14);
  @$pb.TagNumber(15)
  void clearRepairInstructions() => $_clearField(15);
}

class OnboardingStepProgress extends $pb.GeneratedMessage {
  factory OnboardingStepProgress({
    $core.int? stepNumber,
    $core.String? stepKey,
    $core.String? title,
    $core.String? description,
    $core.bool? isCompleted,
    $core.bool? isAvailable,
    $core.String? unavailableReason,
  }) {
    final result = OnboardingStepProgress._();
    if (stepNumber != null) result.stepNumber = stepNumber;
    if (stepKey != null) result.stepKey = stepKey;
    if (title != null) result.title = title;
    if (description != null) result.description = description;
    if (isCompleted != null) result.isCompleted = isCompleted;
    if (isAvailable != null) result.isAvailable = isAvailable;
    if (unavailableReason != null) result.unavailableReason = unavailableReason;
    return result;
  }

  OnboardingStepProgress._();

  factory OnboardingStepProgress.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      OnboardingStepProgress()..mergeFromBuffer(data, registry);
  factory OnboardingStepProgress.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      OnboardingStepProgress()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'OnboardingStepProgress',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.admin.v1'),
      createEmptyInstance: OnboardingStepProgress.$_createMessage)
    ..aI(1, _omitFieldNames ? '' : 'stepNumber')
    ..aOS(2, _omitFieldNames ? '' : 'stepKey')
    ..aOS(3, _omitFieldNames ? '' : 'title')
    ..aOS(4, _omitFieldNames ? '' : 'description')
    ..aOB(5, _omitFieldNames ? '' : 'isCompleted')
    ..aOB(6, _omitFieldNames ? '' : 'isAvailable')
    ..aOS(7, _omitFieldNames ? '' : 'unavailableReason')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OnboardingStepProgress clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OnboardingStepProgress copyWith(
          void Function(OnboardingStepProgress) updates) =>
      super.copyWith((message) => updates(message as OnboardingStepProgress))
          as OnboardingStepProgress;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use OnboardingStepProgress() / OnboardingStepProgress.new instead')
  static OnboardingStepProgress create() => OnboardingStepProgress._();
  static $pb.GeneratedMessage $_createMessage() => OnboardingStepProgress._();
  @$core.override
  OnboardingStepProgress createEmptyInstance() => OnboardingStepProgress._();
  @$core.pragma('dart2js:noInline')
  static OnboardingStepProgress getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<OnboardingStepProgress>(
          OnboardingStepProgress.$_createMessage);
  static OnboardingStepProgress? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get stepNumber => $_getIZ(0);
  @$pb.TagNumber(1)
  set stepNumber($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasStepNumber() => $_has(0);
  @$pb.TagNumber(1)
  void clearStepNumber() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get stepKey => $_getSZ(1);
  @$pb.TagNumber(2)
  set stepKey($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasStepKey() => $_has(1);
  @$pb.TagNumber(2)
  void clearStepKey() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get title => $_getSZ(2);
  @$pb.TagNumber(3)
  set title($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasTitle() => $_has(2);
  @$pb.TagNumber(3)
  void clearTitle() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get description => $_getSZ(3);
  @$pb.TagNumber(4)
  set description($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasDescription() => $_has(3);
  @$pb.TagNumber(4)
  void clearDescription() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.bool get isCompleted => $_getBF(4);
  @$pb.TagNumber(5)
  set isCompleted($core.bool value) => $_setBool(4, value);
  @$pb.TagNumber(5)
  $core.bool hasIsCompleted() => $_has(4);
  @$pb.TagNumber(5)
  void clearIsCompleted() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.bool get isAvailable => $_getBF(5);
  @$pb.TagNumber(6)
  set isAvailable($core.bool value) => $_setBool(5, value);
  @$pb.TagNumber(6)
  $core.bool hasIsAvailable() => $_has(5);
  @$pb.TagNumber(6)
  void clearIsAvailable() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get unavailableReason => $_getSZ(6);
  @$pb.TagNumber(7)
  set unavailableReason($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasUnavailableReason() => $_has(6);
  @$pb.TagNumber(7)
  void clearUnavailableReason() => $_clearField(7);
}

class OnboardingChecklist extends $pb.GeneratedMessage {
  factory OnboardingChecklist({
    $core.Iterable<OnboardingStepProgress>? steps,
    $core.int? completedCount,
    $core.int? totalSteps,
    $core.bool? isClosedLoopComplete,
  }) {
    final result = OnboardingChecklist._();
    if (steps != null) result.steps.addAll(steps);
    if (completedCount != null) result.completedCount = completedCount;
    if (totalSteps != null) result.totalSteps = totalSteps;
    if (isClosedLoopComplete != null)
      result.isClosedLoopComplete = isClosedLoopComplete;
    return result;
  }

  OnboardingChecklist._();

  factory OnboardingChecklist.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      OnboardingChecklist()..mergeFromBuffer(data, registry);
  factory OnboardingChecklist.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      OnboardingChecklist()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'OnboardingChecklist',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.admin.v1'),
      createEmptyInstance: OnboardingChecklist.$_createMessage)
    ..pPM<OnboardingStepProgress>(1, _omitFieldNames ? '' : 'steps',
        subBuilder: OnboardingStepProgress.$_createMessage)
    ..aI(2, _omitFieldNames ? '' : 'completedCount')
    ..aI(3, _omitFieldNames ? '' : 'totalSteps')
    ..aOB(4, _omitFieldNames ? '' : 'isClosedLoopComplete')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OnboardingChecklist clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OnboardingChecklist copyWith(void Function(OnboardingChecklist) updates) =>
      super.copyWith((message) => updates(message as OnboardingChecklist))
          as OnboardingChecklist;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core
      .Deprecated('Use OnboardingChecklist() / OnboardingChecklist.new instead')
  static OnboardingChecklist create() => OnboardingChecklist._();
  static $pb.GeneratedMessage $_createMessage() => OnboardingChecklist._();
  @$core.override
  OnboardingChecklist createEmptyInstance() => OnboardingChecklist._();
  @$core.pragma('dart2js:noInline')
  static OnboardingChecklist getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<OnboardingChecklist>(
          OnboardingChecklist.$_createMessage);
  static OnboardingChecklist? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<OnboardingStepProgress> get steps => $_getList(0);

  @$pb.TagNumber(2)
  $core.int get completedCount => $_getIZ(1);
  @$pb.TagNumber(2)
  set completedCount($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCompletedCount() => $_has(1);
  @$pb.TagNumber(2)
  void clearCompletedCount() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get totalSteps => $_getIZ(2);
  @$pb.TagNumber(3)
  set totalSteps($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasTotalSteps() => $_has(2);
  @$pb.TagNumber(3)
  void clearTotalSteps() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.bool get isClosedLoopComplete => $_getBF(3);
  @$pb.TagNumber(4)
  set isClosedLoopComplete($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(4)
  $core.bool hasIsClosedLoopComplete() => $_has(3);
  @$pb.TagNumber(4)
  void clearIsClosedLoopComplete() => $_clearField(4);
}

class WhyThisNumberDetails extends $pb.GeneratedMessage {
  factory WhyThisNumberDetails({
    $core.String? metricKey,
    $core.String? displayName,
    $core.String? formattedValue,
    DataSourceBadge? dataSource,
    ConfidenceLevel? confidence,
    $1.Timestamp? lastSyncedAt,
    $core.Iterable<$core.String>? dataOrigins,
    $core.Iterable<$core.String>? missingDataCaveats,
    $core.Iterable<$core.String>? recommendedNextSteps,
    $core.bool? containsDemoData,
  }) {
    final result = WhyThisNumberDetails._();
    if (metricKey != null) result.metricKey = metricKey;
    if (displayName != null) result.displayName = displayName;
    if (formattedValue != null) result.formattedValue = formattedValue;
    if (dataSource != null) result.dataSource = dataSource;
    if (confidence != null) result.confidence = confidence;
    if (lastSyncedAt != null) result.lastSyncedAt = lastSyncedAt;
    if (dataOrigins != null) result.dataOrigins.addAll(dataOrigins);
    if (missingDataCaveats != null)
      result.missingDataCaveats.addAll(missingDataCaveats);
    if (recommendedNextSteps != null)
      result.recommendedNextSteps.addAll(recommendedNextSteps);
    if (containsDemoData != null) result.containsDemoData = containsDemoData;
    return result;
  }

  WhyThisNumberDetails._();

  factory WhyThisNumberDetails.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      WhyThisNumberDetails()..mergeFromBuffer(data, registry);
  factory WhyThisNumberDetails.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      WhyThisNumberDetails()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'WhyThisNumberDetails',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.admin.v1'),
      createEmptyInstance: WhyThisNumberDetails.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'metricKey')
    ..aOS(2, _omitFieldNames ? '' : 'displayName')
    ..aOS(3, _omitFieldNames ? '' : 'formattedValue')
    ..aE<DataSourceBadge>(4, _omitFieldNames ? '' : 'dataSource',
        enumValues: DataSourceBadge.values)
    ..aE<ConfidenceLevel>(5, _omitFieldNames ? '' : 'confidence',
        enumValues: ConfidenceLevel.values)
    ..aOM<$1.Timestamp>(6, _omitFieldNames ? '' : 'lastSyncedAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..pPS(7, _omitFieldNames ? '' : 'dataOrigins')
    ..pPS(8, _omitFieldNames ? '' : 'missingDataCaveats')
    ..pPS(9, _omitFieldNames ? '' : 'recommendedNextSteps')
    ..aOB(10, _omitFieldNames ? '' : 'containsDemoData')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WhyThisNumberDetails clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WhyThisNumberDetails copyWith(void Function(WhyThisNumberDetails) updates) =>
      super.copyWith((message) => updates(message as WhyThisNumberDetails))
          as WhyThisNumberDetails;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use WhyThisNumberDetails() / WhyThisNumberDetails.new instead')
  static WhyThisNumberDetails create() => WhyThisNumberDetails._();
  static $pb.GeneratedMessage $_createMessage() => WhyThisNumberDetails._();
  @$core.override
  WhyThisNumberDetails createEmptyInstance() => WhyThisNumberDetails._();
  @$core.pragma('dart2js:noInline')
  static WhyThisNumberDetails getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<WhyThisNumberDetails>(
          WhyThisNumberDetails.$_createMessage);
  static WhyThisNumberDetails? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get metricKey => $_getSZ(0);
  @$pb.TagNumber(1)
  set metricKey($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasMetricKey() => $_has(0);
  @$pb.TagNumber(1)
  void clearMetricKey() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get displayName => $_getSZ(1);
  @$pb.TagNumber(2)
  set displayName($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasDisplayName() => $_has(1);
  @$pb.TagNumber(2)
  void clearDisplayName() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get formattedValue => $_getSZ(2);
  @$pb.TagNumber(3)
  set formattedValue($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasFormattedValue() => $_has(2);
  @$pb.TagNumber(3)
  void clearFormattedValue() => $_clearField(3);

  @$pb.TagNumber(4)
  DataSourceBadge get dataSource => $_getN(3);
  @$pb.TagNumber(4)
  set dataSource(DataSourceBadge value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasDataSource() => $_has(3);
  @$pb.TagNumber(4)
  void clearDataSource() => $_clearField(4);

  @$pb.TagNumber(5)
  ConfidenceLevel get confidence => $_getN(4);
  @$pb.TagNumber(5)
  set confidence(ConfidenceLevel value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasConfidence() => $_has(4);
  @$pb.TagNumber(5)
  void clearConfidence() => $_clearField(5);

  @$pb.TagNumber(6)
  $1.Timestamp get lastSyncedAt => $_getN(5);
  @$pb.TagNumber(6)
  set lastSyncedAt($1.Timestamp value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasLastSyncedAt() => $_has(5);
  @$pb.TagNumber(6)
  void clearLastSyncedAt() => $_clearField(6);
  @$pb.TagNumber(6)
  $1.Timestamp ensureLastSyncedAt() => $_ensure(5);

  @$pb.TagNumber(7)
  $pb.PbList<$core.String> get dataOrigins => $_getList(6);

  @$pb.TagNumber(8)
  $pb.PbList<$core.String> get missingDataCaveats => $_getList(7);

  @$pb.TagNumber(9)
  $pb.PbList<$core.String> get recommendedNextSteps => $_getList(8);

  @$pb.TagNumber(10)
  $core.bool get containsDemoData => $_getBF(9);
  @$pb.TagNumber(10)
  set containsDemoData($core.bool value) => $_setBool(9, value);
  @$pb.TagNumber(10)
  $core.bool hasContainsDemoData() => $_has(9);
  @$pb.TagNumber(10)
  void clearContainsDemoData() => $_clearField(10);
}

class GetMobileHomeRequest extends $pb.GeneratedMessage {
  factory GetMobileHomeRequest({
    $2.UUID? workspaceId,
    OperatorModeId? activeMode,
  }) {
    final result = GetMobileHomeRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (activeMode != null) result.activeMode = activeMode;
    return result;
  }

  GetMobileHomeRequest._();

  factory GetMobileHomeRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetMobileHomeRequest()..mergeFromBuffer(data, registry);
  factory GetMobileHomeRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetMobileHomeRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetMobileHomeRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.admin.v1'),
      createEmptyInstance: GetMobileHomeRequest.$_createMessage)
    ..aOM<$2.UUID>(1, _omitFieldNames ? '' : 'workspaceId',
        subBuilder: $2.UUID.$_createMessage)
    ..aE<OperatorModeId>(2, _omitFieldNames ? '' : 'activeMode',
        enumValues: OperatorModeId.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetMobileHomeRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetMobileHomeRequest copyWith(void Function(GetMobileHomeRequest) updates) =>
      super.copyWith((message) => updates(message as GetMobileHomeRequest))
          as GetMobileHomeRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use GetMobileHomeRequest() / GetMobileHomeRequest.new instead')
  static GetMobileHomeRequest create() => GetMobileHomeRequest._();
  static $pb.GeneratedMessage $_createMessage() => GetMobileHomeRequest._();
  @$core.override
  GetMobileHomeRequest createEmptyInstance() => GetMobileHomeRequest._();
  @$core.pragma('dart2js:noInline')
  static GetMobileHomeRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetMobileHomeRequest>(
          GetMobileHomeRequest.$_createMessage);
  static GetMobileHomeRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $2.UUID get workspaceId => $_getN(0);
  @$pb.TagNumber(1)
  set workspaceId($2.UUID value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);
  @$pb.TagNumber(1)
  $2.UUID ensureWorkspaceId() => $_ensure(0);

  @$pb.TagNumber(2)
  OperatorModeId get activeMode => $_getN(1);
  @$pb.TagNumber(2)
  set activeMode(OperatorModeId value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasActiveMode() => $_has(1);
  @$pb.TagNumber(2)
  void clearActiveMode() => $_clearField(2);
}

class GetMobileHomeResponse extends $pb.GeneratedMessage {
  factory GetMobileHomeResponse({
    $2.UUID? workspaceId,
    OperatorModeId? activeMode,
    $core.String? morningBriefHeadline,
    $core.Iterable<DecisionCard>? decisionCards,
    OnboardingChecklist? onboarding,
    $core.int? unreadNotificationCount,
    $core.String? customerVerifiedTotalRevenue,
    DataSourceBadge? revenueSourceBadge,
    $1.Timestamp? generatedAt,
  }) {
    final result = GetMobileHomeResponse._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (activeMode != null) result.activeMode = activeMode;
    if (morningBriefHeadline != null)
      result.morningBriefHeadline = morningBriefHeadline;
    if (decisionCards != null) result.decisionCards.addAll(decisionCards);
    if (onboarding != null) result.onboarding = onboarding;
    if (unreadNotificationCount != null)
      result.unreadNotificationCount = unreadNotificationCount;
    if (customerVerifiedTotalRevenue != null)
      result.customerVerifiedTotalRevenue = customerVerifiedTotalRevenue;
    if (revenueSourceBadge != null)
      result.revenueSourceBadge = revenueSourceBadge;
    if (generatedAt != null) result.generatedAt = generatedAt;
    return result;
  }

  GetMobileHomeResponse._();

  factory GetMobileHomeResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetMobileHomeResponse()..mergeFromBuffer(data, registry);
  factory GetMobileHomeResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetMobileHomeResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetMobileHomeResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.admin.v1'),
      createEmptyInstance: GetMobileHomeResponse.$_createMessage)
    ..aOM<$2.UUID>(1, _omitFieldNames ? '' : 'workspaceId',
        subBuilder: $2.UUID.$_createMessage)
    ..aE<OperatorModeId>(2, _omitFieldNames ? '' : 'activeMode',
        enumValues: OperatorModeId.values)
    ..aOS(3, _omitFieldNames ? '' : 'morningBriefHeadline')
    ..pPM<DecisionCard>(4, _omitFieldNames ? '' : 'decisionCards',
        subBuilder: DecisionCard.$_createMessage)
    ..aOM<OnboardingChecklist>(5, _omitFieldNames ? '' : 'onboarding',
        subBuilder: OnboardingChecklist.$_createMessage)
    ..aI(6, _omitFieldNames ? '' : 'unreadNotificationCount')
    ..aOS(7, _omitFieldNames ? '' : 'customerVerifiedTotalRevenue')
    ..aE<DataSourceBadge>(8, _omitFieldNames ? '' : 'revenueSourceBadge',
        enumValues: DataSourceBadge.values)
    ..aOM<$1.Timestamp>(9, _omitFieldNames ? '' : 'generatedAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetMobileHomeResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetMobileHomeResponse copyWith(
          void Function(GetMobileHomeResponse) updates) =>
      super.copyWith((message) => updates(message as GetMobileHomeResponse))
          as GetMobileHomeResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use GetMobileHomeResponse() / GetMobileHomeResponse.new instead')
  static GetMobileHomeResponse create() => GetMobileHomeResponse._();
  static $pb.GeneratedMessage $_createMessage() => GetMobileHomeResponse._();
  @$core.override
  GetMobileHomeResponse createEmptyInstance() => GetMobileHomeResponse._();
  @$core.pragma('dart2js:noInline')
  static GetMobileHomeResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetMobileHomeResponse>(
          GetMobileHomeResponse.$_createMessage);
  static GetMobileHomeResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $2.UUID get workspaceId => $_getN(0);
  @$pb.TagNumber(1)
  set workspaceId($2.UUID value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);
  @$pb.TagNumber(1)
  $2.UUID ensureWorkspaceId() => $_ensure(0);

  @$pb.TagNumber(2)
  OperatorModeId get activeMode => $_getN(1);
  @$pb.TagNumber(2)
  set activeMode(OperatorModeId value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasActiveMode() => $_has(1);
  @$pb.TagNumber(2)
  void clearActiveMode() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get morningBriefHeadline => $_getSZ(2);
  @$pb.TagNumber(3)
  set morningBriefHeadline($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasMorningBriefHeadline() => $_has(2);
  @$pb.TagNumber(3)
  void clearMorningBriefHeadline() => $_clearField(3);

  @$pb.TagNumber(4)
  $pb.PbList<DecisionCard> get decisionCards => $_getList(3);

  @$pb.TagNumber(5)
  OnboardingChecklist get onboarding => $_getN(4);
  @$pb.TagNumber(5)
  set onboarding(OnboardingChecklist value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasOnboarding() => $_has(4);
  @$pb.TagNumber(5)
  void clearOnboarding() => $_clearField(5);
  @$pb.TagNumber(5)
  OnboardingChecklist ensureOnboarding() => $_ensure(4);

  @$pb.TagNumber(6)
  $core.int get unreadNotificationCount => $_getIZ(5);
  @$pb.TagNumber(6)
  set unreadNotificationCount($core.int value) => $_setSignedInt32(5, value);
  @$pb.TagNumber(6)
  $core.bool hasUnreadNotificationCount() => $_has(5);
  @$pb.TagNumber(6)
  void clearUnreadNotificationCount() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get customerVerifiedTotalRevenue => $_getSZ(6);
  @$pb.TagNumber(7)
  set customerVerifiedTotalRevenue($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasCustomerVerifiedTotalRevenue() => $_has(6);
  @$pb.TagNumber(7)
  void clearCustomerVerifiedTotalRevenue() => $_clearField(7);

  @$pb.TagNumber(8)
  DataSourceBadge get revenueSourceBadge => $_getN(7);
  @$pb.TagNumber(8)
  set revenueSourceBadge(DataSourceBadge value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasRevenueSourceBadge() => $_has(7);
  @$pb.TagNumber(8)
  void clearRevenueSourceBadge() => $_clearField(8);

  @$pb.TagNumber(9)
  $1.Timestamp get generatedAt => $_getN(8);
  @$pb.TagNumber(9)
  set generatedAt($1.Timestamp value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasGeneratedAt() => $_has(8);
  @$pb.TagNumber(9)
  void clearGeneratedAt() => $_clearField(9);
  @$pb.TagNumber(9)
  $1.Timestamp ensureGeneratedAt() => $_ensure(8);
}

class GetPipelineRequest extends $pb.GeneratedMessage {
  factory GetPipelineRequest({
    $2.UUID? workspaceId,
  }) {
    final result = GetPipelineRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    return result;
  }

  GetPipelineRequest._();

  factory GetPipelineRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetPipelineRequest()..mergeFromBuffer(data, registry);
  factory GetPipelineRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetPipelineRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetPipelineRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.admin.v1'),
      createEmptyInstance: GetPipelineRequest.$_createMessage)
    ..aOM<$2.UUID>(1, _omitFieldNames ? '' : 'workspaceId',
        subBuilder: $2.UUID.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetPipelineRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetPipelineRequest copyWith(void Function(GetPipelineRequest) updates) =>
      super.copyWith((message) => updates(message as GetPipelineRequest))
          as GetPipelineRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use GetPipelineRequest() / GetPipelineRequest.new instead')
  static GetPipelineRequest create() => GetPipelineRequest._();
  static $pb.GeneratedMessage $_createMessage() => GetPipelineRequest._();
  @$core.override
  GetPipelineRequest createEmptyInstance() => GetPipelineRequest._();
  @$core.pragma('dart2js:noInline')
  static GetPipelineRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetPipelineRequest>(
          GetPipelineRequest.$_createMessage);
  static GetPipelineRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $2.UUID get workspaceId => $_getN(0);
  @$pb.TagNumber(1)
  set workspaceId($2.UUID value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);
  @$pb.TagNumber(1)
  $2.UUID ensureWorkspaceId() => $_ensure(0);
}

class GetPipelineResponse extends $pb.GeneratedMessage {
  factory GetPipelineResponse({
    $2.UUID? workspaceId,
    $core.int? ideasCount,
    $core.int? scriptsCount,
    $core.int? assetsGeneratingCount,
    $core.int? queuedPublishCount,
    $core.int? pendingApprovalsCount,
  }) {
    final result = GetPipelineResponse._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (ideasCount != null) result.ideasCount = ideasCount;
    if (scriptsCount != null) result.scriptsCount = scriptsCount;
    if (assetsGeneratingCount != null)
      result.assetsGeneratingCount = assetsGeneratingCount;
    if (queuedPublishCount != null)
      result.queuedPublishCount = queuedPublishCount;
    if (pendingApprovalsCount != null)
      result.pendingApprovalsCount = pendingApprovalsCount;
    return result;
  }

  GetPipelineResponse._();

  factory GetPipelineResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetPipelineResponse()..mergeFromBuffer(data, registry);
  factory GetPipelineResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetPipelineResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetPipelineResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.admin.v1'),
      createEmptyInstance: GetPipelineResponse.$_createMessage)
    ..aOM<$2.UUID>(1, _omitFieldNames ? '' : 'workspaceId',
        subBuilder: $2.UUID.$_createMessage)
    ..aI(2, _omitFieldNames ? '' : 'ideasCount')
    ..aI(3, _omitFieldNames ? '' : 'scriptsCount')
    ..aI(4, _omitFieldNames ? '' : 'assetsGeneratingCount')
    ..aI(5, _omitFieldNames ? '' : 'queuedPublishCount')
    ..aI(6, _omitFieldNames ? '' : 'pendingApprovalsCount')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetPipelineResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetPipelineResponse copyWith(void Function(GetPipelineResponse) updates) =>
      super.copyWith((message) => updates(message as GetPipelineResponse))
          as GetPipelineResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core
      .Deprecated('Use GetPipelineResponse() / GetPipelineResponse.new instead')
  static GetPipelineResponse create() => GetPipelineResponse._();
  static $pb.GeneratedMessage $_createMessage() => GetPipelineResponse._();
  @$core.override
  GetPipelineResponse createEmptyInstance() => GetPipelineResponse._();
  @$core.pragma('dart2js:noInline')
  static GetPipelineResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetPipelineResponse>(
          GetPipelineResponse.$_createMessage);
  static GetPipelineResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $2.UUID get workspaceId => $_getN(0);
  @$pb.TagNumber(1)
  set workspaceId($2.UUID value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);
  @$pb.TagNumber(1)
  $2.UUID ensureWorkspaceId() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.int get ideasCount => $_getIZ(1);
  @$pb.TagNumber(2)
  set ideasCount($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasIdeasCount() => $_has(1);
  @$pb.TagNumber(2)
  void clearIdeasCount() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get scriptsCount => $_getIZ(2);
  @$pb.TagNumber(3)
  set scriptsCount($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasScriptsCount() => $_has(2);
  @$pb.TagNumber(3)
  void clearScriptsCount() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get assetsGeneratingCount => $_getIZ(3);
  @$pb.TagNumber(4)
  set assetsGeneratingCount($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasAssetsGeneratingCount() => $_has(3);
  @$pb.TagNumber(4)
  void clearAssetsGeneratingCount() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get queuedPublishCount => $_getIZ(4);
  @$pb.TagNumber(5)
  set queuedPublishCount($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasQueuedPublishCount() => $_has(4);
  @$pb.TagNumber(5)
  void clearQueuedPublishCount() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.int get pendingApprovalsCount => $_getIZ(5);
  @$pb.TagNumber(6)
  set pendingApprovalsCount($core.int value) => $_setSignedInt32(5, value);
  @$pb.TagNumber(6)
  $core.bool hasPendingApprovalsCount() => $_has(5);
  @$pb.TagNumber(6)
  void clearPendingApprovalsCount() => $_clearField(6);
}

class GetDecisionCardsRequest extends $pb.GeneratedMessage {
  factory GetDecisionCardsRequest({
    $2.UUID? workspaceId,
    OperatorModeId? operatorMode,
    $core.bool? includeDemoFixtures,
  }) {
    final result = GetDecisionCardsRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (operatorMode != null) result.operatorMode = operatorMode;
    if (includeDemoFixtures != null)
      result.includeDemoFixtures = includeDemoFixtures;
    return result;
  }

  GetDecisionCardsRequest._();

  factory GetDecisionCardsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetDecisionCardsRequest()..mergeFromBuffer(data, registry);
  factory GetDecisionCardsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetDecisionCardsRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetDecisionCardsRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.admin.v1'),
      createEmptyInstance: GetDecisionCardsRequest.$_createMessage)
    ..aOM<$2.UUID>(1, _omitFieldNames ? '' : 'workspaceId',
        subBuilder: $2.UUID.$_createMessage)
    ..aE<OperatorModeId>(2, _omitFieldNames ? '' : 'operatorMode',
        enumValues: OperatorModeId.values)
    ..aOB(3, _omitFieldNames ? '' : 'includeDemoFixtures')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetDecisionCardsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetDecisionCardsRequest copyWith(
          void Function(GetDecisionCardsRequest) updates) =>
      super.copyWith((message) => updates(message as GetDecisionCardsRequest))
          as GetDecisionCardsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use GetDecisionCardsRequest() / GetDecisionCardsRequest.new instead')
  static GetDecisionCardsRequest create() => GetDecisionCardsRequest._();
  static $pb.GeneratedMessage $_createMessage() => GetDecisionCardsRequest._();
  @$core.override
  GetDecisionCardsRequest createEmptyInstance() => GetDecisionCardsRequest._();
  @$core.pragma('dart2js:noInline')
  static GetDecisionCardsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetDecisionCardsRequest>(
          GetDecisionCardsRequest.$_createMessage);
  static GetDecisionCardsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $2.UUID get workspaceId => $_getN(0);
  @$pb.TagNumber(1)
  set workspaceId($2.UUID value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);
  @$pb.TagNumber(1)
  $2.UUID ensureWorkspaceId() => $_ensure(0);

  @$pb.TagNumber(2)
  OperatorModeId get operatorMode => $_getN(1);
  @$pb.TagNumber(2)
  set operatorMode(OperatorModeId value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasOperatorMode() => $_has(1);
  @$pb.TagNumber(2)
  void clearOperatorMode() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.bool get includeDemoFixtures => $_getBF(2);
  @$pb.TagNumber(3)
  set includeDemoFixtures($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasIncludeDemoFixtures() => $_has(2);
  @$pb.TagNumber(3)
  void clearIncludeDemoFixtures() => $_clearField(3);
}

class GetDecisionCardsResponse extends $pb.GeneratedMessage {
  factory GetDecisionCardsResponse({
    OperatorModeId? operatorMode,
    $core.Iterable<DecisionCard>? cards,
    $1.Timestamp? asOf,
  }) {
    final result = GetDecisionCardsResponse._();
    if (operatorMode != null) result.operatorMode = operatorMode;
    if (cards != null) result.cards.addAll(cards);
    if (asOf != null) result.asOf = asOf;
    return result;
  }

  GetDecisionCardsResponse._();

  factory GetDecisionCardsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetDecisionCardsResponse()..mergeFromBuffer(data, registry);
  factory GetDecisionCardsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetDecisionCardsResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetDecisionCardsResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.admin.v1'),
      createEmptyInstance: GetDecisionCardsResponse.$_createMessage)
    ..aE<OperatorModeId>(1, _omitFieldNames ? '' : 'operatorMode',
        enumValues: OperatorModeId.values)
    ..pPM<DecisionCard>(2, _omitFieldNames ? '' : 'cards',
        subBuilder: DecisionCard.$_createMessage)
    ..aOM<$1.Timestamp>(3, _omitFieldNames ? '' : 'asOf',
        subBuilder: $1.Timestamp.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetDecisionCardsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetDecisionCardsResponse copyWith(
          void Function(GetDecisionCardsResponse) updates) =>
      super.copyWith((message) => updates(message as GetDecisionCardsResponse))
          as GetDecisionCardsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use GetDecisionCardsResponse() / GetDecisionCardsResponse.new instead')
  static GetDecisionCardsResponse create() => GetDecisionCardsResponse._();
  static $pb.GeneratedMessage $_createMessage() => GetDecisionCardsResponse._();
  @$core.override
  GetDecisionCardsResponse createEmptyInstance() =>
      GetDecisionCardsResponse._();
  @$core.pragma('dart2js:noInline')
  static GetDecisionCardsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetDecisionCardsResponse>(
          GetDecisionCardsResponse.$_createMessage);
  static GetDecisionCardsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  OperatorModeId get operatorMode => $_getN(0);
  @$pb.TagNumber(1)
  set operatorMode(OperatorModeId value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasOperatorMode() => $_has(0);
  @$pb.TagNumber(1)
  void clearOperatorMode() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbList<DecisionCard> get cards => $_getList(1);

  @$pb.TagNumber(3)
  $1.Timestamp get asOf => $_getN(2);
  @$pb.TagNumber(3)
  set asOf($1.Timestamp value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasAsOf() => $_has(2);
  @$pb.TagNumber(3)
  void clearAsOf() => $_clearField(3);
  @$pb.TagNumber(3)
  $1.Timestamp ensureAsOf() => $_ensure(2);
}

class GetWhyThisNumberRequest extends $pb.GeneratedMessage {
  factory GetWhyThisNumberRequest({
    $2.UUID? workspaceId,
    $core.String? metricKey,
  }) {
    final result = GetWhyThisNumberRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (metricKey != null) result.metricKey = metricKey;
    return result;
  }

  GetWhyThisNumberRequest._();

  factory GetWhyThisNumberRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetWhyThisNumberRequest()..mergeFromBuffer(data, registry);
  factory GetWhyThisNumberRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetWhyThisNumberRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetWhyThisNumberRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.admin.v1'),
      createEmptyInstance: GetWhyThisNumberRequest.$_createMessage)
    ..aOM<$2.UUID>(1, _omitFieldNames ? '' : 'workspaceId',
        subBuilder: $2.UUID.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'metricKey')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetWhyThisNumberRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetWhyThisNumberRequest copyWith(
          void Function(GetWhyThisNumberRequest) updates) =>
      super.copyWith((message) => updates(message as GetWhyThisNumberRequest))
          as GetWhyThisNumberRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use GetWhyThisNumberRequest() / GetWhyThisNumberRequest.new instead')
  static GetWhyThisNumberRequest create() => GetWhyThisNumberRequest._();
  static $pb.GeneratedMessage $_createMessage() => GetWhyThisNumberRequest._();
  @$core.override
  GetWhyThisNumberRequest createEmptyInstance() => GetWhyThisNumberRequest._();
  @$core.pragma('dart2js:noInline')
  static GetWhyThisNumberRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetWhyThisNumberRequest>(
          GetWhyThisNumberRequest.$_createMessage);
  static GetWhyThisNumberRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $2.UUID get workspaceId => $_getN(0);
  @$pb.TagNumber(1)
  set workspaceId($2.UUID value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);
  @$pb.TagNumber(1)
  $2.UUID ensureWorkspaceId() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get metricKey => $_getSZ(1);
  @$pb.TagNumber(2)
  set metricKey($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasMetricKey() => $_has(1);
  @$pb.TagNumber(2)
  void clearMetricKey() => $_clearField(2);
}

class GetWhyThisNumberResponse extends $pb.GeneratedMessage {
  factory GetWhyThisNumberResponse({
    WhyThisNumberDetails? details,
  }) {
    final result = GetWhyThisNumberResponse._();
    if (details != null) result.details = details;
    return result;
  }

  GetWhyThisNumberResponse._();

  factory GetWhyThisNumberResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetWhyThisNumberResponse()..mergeFromBuffer(data, registry);
  factory GetWhyThisNumberResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetWhyThisNumberResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetWhyThisNumberResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.admin.v1'),
      createEmptyInstance: GetWhyThisNumberResponse.$_createMessage)
    ..aOM<WhyThisNumberDetails>(1, _omitFieldNames ? '' : 'details',
        subBuilder: WhyThisNumberDetails.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetWhyThisNumberResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetWhyThisNumberResponse copyWith(
          void Function(GetWhyThisNumberResponse) updates) =>
      super.copyWith((message) => updates(message as GetWhyThisNumberResponse))
          as GetWhyThisNumberResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use GetWhyThisNumberResponse() / GetWhyThisNumberResponse.new instead')
  static GetWhyThisNumberResponse create() => GetWhyThisNumberResponse._();
  static $pb.GeneratedMessage $_createMessage() => GetWhyThisNumberResponse._();
  @$core.override
  GetWhyThisNumberResponse createEmptyInstance() =>
      GetWhyThisNumberResponse._();
  @$core.pragma('dart2js:noInline')
  static GetWhyThisNumberResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetWhyThisNumberResponse>(
          GetWhyThisNumberResponse.$_createMessage);
  static GetWhyThisNumberResponse? _defaultInstance;

  @$pb.TagNumber(1)
  WhyThisNumberDetails get details => $_getN(0);
  @$pb.TagNumber(1)
  set details(WhyThisNumberDetails value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasDetails() => $_has(0);
  @$pb.TagNumber(1)
  void clearDetails() => $_clearField(1);
  @$pb.TagNumber(1)
  WhyThisNumberDetails ensureDetails() => $_ensure(0);
}

class CompleteOnboardingStepRequest extends $pb.GeneratedMessage {
  factory CompleteOnboardingStepRequest({
    $2.UUID? workspaceId,
    $core.int? stepNumber,
  }) {
    final result = CompleteOnboardingStepRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (stepNumber != null) result.stepNumber = stepNumber;
    return result;
  }

  CompleteOnboardingStepRequest._();

  factory CompleteOnboardingStepRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CompleteOnboardingStepRequest()..mergeFromBuffer(data, registry);
  factory CompleteOnboardingStepRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CompleteOnboardingStepRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CompleteOnboardingStepRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.admin.v1'),
      createEmptyInstance: CompleteOnboardingStepRequest.$_createMessage)
    ..aOM<$2.UUID>(1, _omitFieldNames ? '' : 'workspaceId',
        subBuilder: $2.UUID.$_createMessage)
    ..aI(2, _omitFieldNames ? '' : 'stepNumber')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CompleteOnboardingStepRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CompleteOnboardingStepRequest copyWith(
          void Function(CompleteOnboardingStepRequest) updates) =>
      super.copyWith(
              (message) => updates(message as CompleteOnboardingStepRequest))
          as CompleteOnboardingStepRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use CompleteOnboardingStepRequest() / CompleteOnboardingStepRequest.new instead')
  static CompleteOnboardingStepRequest create() =>
      CompleteOnboardingStepRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      CompleteOnboardingStepRequest._();
  @$core.override
  CompleteOnboardingStepRequest createEmptyInstance() =>
      CompleteOnboardingStepRequest._();
  @$core.pragma('dart2js:noInline')
  static CompleteOnboardingStepRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CompleteOnboardingStepRequest>(
          CompleteOnboardingStepRequest.$_createMessage);
  static CompleteOnboardingStepRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $2.UUID get workspaceId => $_getN(0);
  @$pb.TagNumber(1)
  set workspaceId($2.UUID value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);
  @$pb.TagNumber(1)
  $2.UUID ensureWorkspaceId() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.int get stepNumber => $_getIZ(1);
  @$pb.TagNumber(2)
  set stepNumber($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasStepNumber() => $_has(1);
  @$pb.TagNumber(2)
  void clearStepNumber() => $_clearField(2);
}

class CompleteOnboardingStepResponse extends $pb.GeneratedMessage {
  factory CompleteOnboardingStepResponse({
    OnboardingChecklist? updatedChecklist,
  }) {
    final result = CompleteOnboardingStepResponse._();
    if (updatedChecklist != null) result.updatedChecklist = updatedChecklist;
    return result;
  }

  CompleteOnboardingStepResponse._();

  factory CompleteOnboardingStepResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CompleteOnboardingStepResponse()..mergeFromBuffer(data, registry);
  factory CompleteOnboardingStepResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CompleteOnboardingStepResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CompleteOnboardingStepResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.admin.v1'),
      createEmptyInstance: CompleteOnboardingStepResponse.$_createMessage)
    ..aOM<OnboardingChecklist>(1, _omitFieldNames ? '' : 'updatedChecklist',
        subBuilder: OnboardingChecklist.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CompleteOnboardingStepResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CompleteOnboardingStepResponse copyWith(
          void Function(CompleteOnboardingStepResponse) updates) =>
      super.copyWith(
              (message) => updates(message as CompleteOnboardingStepResponse))
          as CompleteOnboardingStepResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use CompleteOnboardingStepResponse() / CompleteOnboardingStepResponse.new instead')
  static CompleteOnboardingStepResponse create() =>
      CompleteOnboardingStepResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      CompleteOnboardingStepResponse._();
  @$core.override
  CompleteOnboardingStepResponse createEmptyInstance() =>
      CompleteOnboardingStepResponse._();
  @$core.pragma('dart2js:noInline')
  static CompleteOnboardingStepResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CompleteOnboardingStepResponse>(
          CompleteOnboardingStepResponse.$_createMessage);
  static CompleteOnboardingStepResponse? _defaultInstance;

  @$pb.TagNumber(1)
  OnboardingChecklist get updatedChecklist => $_getN(0);
  @$pb.TagNumber(1)
  set updatedChecklist(OnboardingChecklist value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasUpdatedChecklist() => $_has(0);
  @$pb.TagNumber(1)
  void clearUpdatedChecklist() => $_clearField(1);
  @$pb.TagNumber(1)
  OnboardingChecklist ensureUpdatedChecklist() => $_ensure(0);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');

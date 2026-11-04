// This is a generated file - do not edit.
//
// Generated from creativanta/automation/v1/agent.proto.

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

import 'agent.pbenum.dart';

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'agent.pbenum.dart';

/// AgentStep represents a single discrete planned or executed step in an agent run.
class AgentStep extends $pb.GeneratedMessage {
  factory AgentStep({
    $core.String? stepId,
    $core.String? agentRunId,
    $core.int? stepOrder,
    $core.String? phase,
    $core.String? title,
    AgentStepStatus? status,
    $core.String? expectedOutcome,
    $core.String? observedOutcome,
    $core.String? requiredPermission,
    $core.String? requiredCapability,
    $core.bool? isHighRisk,
    $core.String? estimatedCredits,
    $core.String? actualCredits,
    $core.String? inputContextJson,
    $core.String? outputContextJson,
    $core.String? diagnosticsRef,
    $1.Timestamp? startedAt,
    $1.Timestamp? completedAt,
  }) {
    final result = AgentStep._();
    if (stepId != null) result.stepId = stepId;
    if (agentRunId != null) result.agentRunId = agentRunId;
    if (stepOrder != null) result.stepOrder = stepOrder;
    if (phase != null) result.phase = phase;
    if (title != null) result.title = title;
    if (status != null) result.status = status;
    if (expectedOutcome != null) result.expectedOutcome = expectedOutcome;
    if (observedOutcome != null) result.observedOutcome = observedOutcome;
    if (requiredPermission != null)
      result.requiredPermission = requiredPermission;
    if (requiredCapability != null)
      result.requiredCapability = requiredCapability;
    if (isHighRisk != null) result.isHighRisk = isHighRisk;
    if (estimatedCredits != null) result.estimatedCredits = estimatedCredits;
    if (actualCredits != null) result.actualCredits = actualCredits;
    if (inputContextJson != null) result.inputContextJson = inputContextJson;
    if (outputContextJson != null) result.outputContextJson = outputContextJson;
    if (diagnosticsRef != null) result.diagnosticsRef = diagnosticsRef;
    if (startedAt != null) result.startedAt = startedAt;
    if (completedAt != null) result.completedAt = completedAt;
    return result;
  }

  AgentStep._();

  factory AgentStep.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      AgentStep()..mergeFromBuffer(data, registry);
  factory AgentStep.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      AgentStep()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AgentStep',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.automation.v1'),
      createEmptyInstance: AgentStep.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'stepId')
    ..aOS(2, _omitFieldNames ? '' : 'agentRunId')
    ..aI(3, _omitFieldNames ? '' : 'stepOrder')
    ..aOS(4, _omitFieldNames ? '' : 'phase')
    ..aOS(5, _omitFieldNames ? '' : 'title')
    ..aE<AgentStepStatus>(6, _omitFieldNames ? '' : 'status',
        enumValues: AgentStepStatus.values)
    ..aOS(7, _omitFieldNames ? '' : 'expectedOutcome')
    ..aOS(8, _omitFieldNames ? '' : 'observedOutcome')
    ..aOS(9, _omitFieldNames ? '' : 'requiredPermission')
    ..aOS(10, _omitFieldNames ? '' : 'requiredCapability')
    ..aOB(11, _omitFieldNames ? '' : 'isHighRisk')
    ..aOS(12, _omitFieldNames ? '' : 'estimatedCredits')
    ..aOS(13, _omitFieldNames ? '' : 'actualCredits')
    ..aOS(14, _omitFieldNames ? '' : 'inputContextJson')
    ..aOS(15, _omitFieldNames ? '' : 'outputContextJson')
    ..aOS(16, _omitFieldNames ? '' : 'diagnosticsRef')
    ..aOM<$1.Timestamp>(17, _omitFieldNames ? '' : 'startedAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..aOM<$1.Timestamp>(18, _omitFieldNames ? '' : 'completedAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AgentStep clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AgentStep copyWith(void Function(AgentStep) updates) =>
      super.copyWith((message) => updates(message as AgentStep)) as AgentStep;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use AgentStep() / AgentStep.new instead')
  static AgentStep create() => AgentStep._();
  static $pb.GeneratedMessage $_createMessage() => AgentStep._();
  @$core.override
  AgentStep createEmptyInstance() => AgentStep._();
  @$core.pragma('dart2js:noInline')
  static AgentStep getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AgentStep>(AgentStep.$_createMessage);
  static AgentStep? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get stepId => $_getSZ(0);
  @$pb.TagNumber(1)
  set stepId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasStepId() => $_has(0);
  @$pb.TagNumber(1)
  void clearStepId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get agentRunId => $_getSZ(1);
  @$pb.TagNumber(2)
  set agentRunId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasAgentRunId() => $_has(1);
  @$pb.TagNumber(2)
  void clearAgentRunId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get stepOrder => $_getIZ(2);
  @$pb.TagNumber(3)
  set stepOrder($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasStepOrder() => $_has(2);
  @$pb.TagNumber(3)
  void clearStepOrder() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get phase => $_getSZ(3);
  @$pb.TagNumber(4)
  set phase($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasPhase() => $_has(3);
  @$pb.TagNumber(4)
  void clearPhase() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get title => $_getSZ(4);
  @$pb.TagNumber(5)
  set title($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasTitle() => $_has(4);
  @$pb.TagNumber(5)
  void clearTitle() => $_clearField(5);

  @$pb.TagNumber(6)
  AgentStepStatus get status => $_getN(5);
  @$pb.TagNumber(6)
  set status(AgentStepStatus value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasStatus() => $_has(5);
  @$pb.TagNumber(6)
  void clearStatus() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get expectedOutcome => $_getSZ(6);
  @$pb.TagNumber(7)
  set expectedOutcome($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasExpectedOutcome() => $_has(6);
  @$pb.TagNumber(7)
  void clearExpectedOutcome() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get observedOutcome => $_getSZ(7);
  @$pb.TagNumber(8)
  set observedOutcome($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasObservedOutcome() => $_has(7);
  @$pb.TagNumber(8)
  void clearObservedOutcome() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get requiredPermission => $_getSZ(8);
  @$pb.TagNumber(9)
  set requiredPermission($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasRequiredPermission() => $_has(8);
  @$pb.TagNumber(9)
  void clearRequiredPermission() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.String get requiredCapability => $_getSZ(9);
  @$pb.TagNumber(10)
  set requiredCapability($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasRequiredCapability() => $_has(9);
  @$pb.TagNumber(10)
  void clearRequiredCapability() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.bool get isHighRisk => $_getBF(10);
  @$pb.TagNumber(11)
  set isHighRisk($core.bool value) => $_setBool(10, value);
  @$pb.TagNumber(11)
  $core.bool hasIsHighRisk() => $_has(10);
  @$pb.TagNumber(11)
  void clearIsHighRisk() => $_clearField(11);

  @$pb.TagNumber(12)
  $core.String get estimatedCredits => $_getSZ(11);
  @$pb.TagNumber(12)
  set estimatedCredits($core.String value) => $_setString(11, value);
  @$pb.TagNumber(12)
  $core.bool hasEstimatedCredits() => $_has(11);
  @$pb.TagNumber(12)
  void clearEstimatedCredits() => $_clearField(12);

  @$pb.TagNumber(13)
  $core.String get actualCredits => $_getSZ(12);
  @$pb.TagNumber(13)
  set actualCredits($core.String value) => $_setString(12, value);
  @$pb.TagNumber(13)
  $core.bool hasActualCredits() => $_has(12);
  @$pb.TagNumber(13)
  void clearActualCredits() => $_clearField(13);

  @$pb.TagNumber(14)
  $core.String get inputContextJson => $_getSZ(13);
  @$pb.TagNumber(14)
  set inputContextJson($core.String value) => $_setString(13, value);
  @$pb.TagNumber(14)
  $core.bool hasInputContextJson() => $_has(13);
  @$pb.TagNumber(14)
  void clearInputContextJson() => $_clearField(14);

  @$pb.TagNumber(15)
  $core.String get outputContextJson => $_getSZ(14);
  @$pb.TagNumber(15)
  set outputContextJson($core.String value) => $_setString(14, value);
  @$pb.TagNumber(15)
  $core.bool hasOutputContextJson() => $_has(14);
  @$pb.TagNumber(15)
  void clearOutputContextJson() => $_clearField(15);

  @$pb.TagNumber(16)
  $core.String get diagnosticsRef => $_getSZ(15);
  @$pb.TagNumber(16)
  set diagnosticsRef($core.String value) => $_setString(15, value);
  @$pb.TagNumber(16)
  $core.bool hasDiagnosticsRef() => $_has(15);
  @$pb.TagNumber(16)
  void clearDiagnosticsRef() => $_clearField(16);

  @$pb.TagNumber(17)
  $1.Timestamp get startedAt => $_getN(16);
  @$pb.TagNumber(17)
  set startedAt($1.Timestamp value) => $_setField(17, value);
  @$pb.TagNumber(17)
  $core.bool hasStartedAt() => $_has(16);
  @$pb.TagNumber(17)
  void clearStartedAt() => $_clearField(17);
  @$pb.TagNumber(17)
  $1.Timestamp ensureStartedAt() => $_ensure(16);

  @$pb.TagNumber(18)
  $1.Timestamp get completedAt => $_getN(17);
  @$pb.TagNumber(18)
  set completedAt($1.Timestamp value) => $_setField(18, value);
  @$pb.TagNumber(18)
  $core.bool hasCompletedAt() => $_has(17);
  @$pb.TagNumber(18)
  void clearCompletedAt() => $_clearField(18);
  @$pb.TagNumber(18)
  $1.Timestamp ensureCompletedAt() => $_ensure(17);
}

/// AgentOutput represents an artifact produced by an agent run (§12.4B).
class AgentOutput extends $pb.GeneratedMessage {
  factory AgentOutput({
    $core.String? outputId,
    $core.String? agentRunId,
    AgentOutputType? outputType,
    $core.String? title,
    $core.String? summary,
    $core.String? objectRefsJson,
    $core.String? downloadableRefsJson,
    $core.String? previewPayloadJson,
    $core.String? approvalState,
    $1.Timestamp? createdAt,
  }) {
    final result = AgentOutput._();
    if (outputId != null) result.outputId = outputId;
    if (agentRunId != null) result.agentRunId = agentRunId;
    if (outputType != null) result.outputType = outputType;
    if (title != null) result.title = title;
    if (summary != null) result.summary = summary;
    if (objectRefsJson != null) result.objectRefsJson = objectRefsJson;
    if (downloadableRefsJson != null)
      result.downloadableRefsJson = downloadableRefsJson;
    if (previewPayloadJson != null)
      result.previewPayloadJson = previewPayloadJson;
    if (approvalState != null) result.approvalState = approvalState;
    if (createdAt != null) result.createdAt = createdAt;
    return result;
  }

  AgentOutput._();

  factory AgentOutput.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      AgentOutput()..mergeFromBuffer(data, registry);
  factory AgentOutput.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      AgentOutput()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AgentOutput',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.automation.v1'),
      createEmptyInstance: AgentOutput.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'outputId')
    ..aOS(2, _omitFieldNames ? '' : 'agentRunId')
    ..aE<AgentOutputType>(3, _omitFieldNames ? '' : 'outputType',
        enumValues: AgentOutputType.values)
    ..aOS(4, _omitFieldNames ? '' : 'title')
    ..aOS(5, _omitFieldNames ? '' : 'summary')
    ..aOS(6, _omitFieldNames ? '' : 'objectRefsJson')
    ..aOS(7, _omitFieldNames ? '' : 'downloadableRefsJson')
    ..aOS(8, _omitFieldNames ? '' : 'previewPayloadJson')
    ..aOS(9, _omitFieldNames ? '' : 'approvalState')
    ..aOM<$1.Timestamp>(10, _omitFieldNames ? '' : 'createdAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AgentOutput clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AgentOutput copyWith(void Function(AgentOutput) updates) =>
      super.copyWith((message) => updates(message as AgentOutput))
          as AgentOutput;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use AgentOutput() / AgentOutput.new instead')
  static AgentOutput create() => AgentOutput._();
  static $pb.GeneratedMessage $_createMessage() => AgentOutput._();
  @$core.override
  AgentOutput createEmptyInstance() => AgentOutput._();
  @$core.pragma('dart2js:noInline')
  static AgentOutput getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AgentOutput>(
          AgentOutput.$_createMessage);
  static AgentOutput? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get outputId => $_getSZ(0);
  @$pb.TagNumber(1)
  set outputId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasOutputId() => $_has(0);
  @$pb.TagNumber(1)
  void clearOutputId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get agentRunId => $_getSZ(1);
  @$pb.TagNumber(2)
  set agentRunId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasAgentRunId() => $_has(1);
  @$pb.TagNumber(2)
  void clearAgentRunId() => $_clearField(2);

  @$pb.TagNumber(3)
  AgentOutputType get outputType => $_getN(2);
  @$pb.TagNumber(3)
  set outputType(AgentOutputType value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasOutputType() => $_has(2);
  @$pb.TagNumber(3)
  void clearOutputType() => $_clearField(3);

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
  $core.String get objectRefsJson => $_getSZ(5);
  @$pb.TagNumber(6)
  set objectRefsJson($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasObjectRefsJson() => $_has(5);
  @$pb.TagNumber(6)
  void clearObjectRefsJson() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get downloadableRefsJson => $_getSZ(6);
  @$pb.TagNumber(7)
  set downloadableRefsJson($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasDownloadableRefsJson() => $_has(6);
  @$pb.TagNumber(7)
  void clearDownloadableRefsJson() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get previewPayloadJson => $_getSZ(7);
  @$pb.TagNumber(8)
  set previewPayloadJson($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasPreviewPayloadJson() => $_has(7);
  @$pb.TagNumber(8)
  void clearPreviewPayloadJson() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get approvalState => $_getSZ(8);
  @$pb.TagNumber(9)
  set approvalState($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasApprovalState() => $_has(8);
  @$pb.TagNumber(9)
  void clearApprovalState() => $_clearField(9);

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
}

/// AgentMemoryEntry represents an ephemeral observation in working memory.
class AgentMemoryEntry extends $pb.GeneratedMessage {
  factory AgentMemoryEntry({
    $core.String? key,
    $core.String? value,
    $core.int? byteSize,
    $1.Timestamp? observedAt,
  }) {
    final result = AgentMemoryEntry._();
    if (key != null) result.key = key;
    if (value != null) result.value = value;
    if (byteSize != null) result.byteSize = byteSize;
    if (observedAt != null) result.observedAt = observedAt;
    return result;
  }

  AgentMemoryEntry._();

  factory AgentMemoryEntry.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      AgentMemoryEntry()..mergeFromBuffer(data, registry);
  factory AgentMemoryEntry.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      AgentMemoryEntry()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AgentMemoryEntry',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.automation.v1'),
      createEmptyInstance: AgentMemoryEntry.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'key')
    ..aOS(2, _omitFieldNames ? '' : 'value')
    ..aI(3, _omitFieldNames ? '' : 'byteSize')
    ..aOM<$1.Timestamp>(4, _omitFieldNames ? '' : 'observedAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AgentMemoryEntry clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AgentMemoryEntry copyWith(void Function(AgentMemoryEntry) updates) =>
      super.copyWith((message) => updates(message as AgentMemoryEntry))
          as AgentMemoryEntry;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use AgentMemoryEntry() / AgentMemoryEntry.new instead')
  static AgentMemoryEntry create() => AgentMemoryEntry._();
  static $pb.GeneratedMessage $_createMessage() => AgentMemoryEntry._();
  @$core.override
  AgentMemoryEntry createEmptyInstance() => AgentMemoryEntry._();
  @$core.pragma('dart2js:noInline')
  static AgentMemoryEntry getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AgentMemoryEntry>(
          AgentMemoryEntry.$_createMessage);
  static AgentMemoryEntry? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get key => $_getSZ(0);
  @$pb.TagNumber(1)
  set key($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasKey() => $_has(0);
  @$pb.TagNumber(1)
  void clearKey() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get value => $_getSZ(1);
  @$pb.TagNumber(2)
  set value($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasValue() => $_has(1);
  @$pb.TagNumber(2)
  void clearValue() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get byteSize => $_getIZ(2);
  @$pb.TagNumber(3)
  set byteSize($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasByteSize() => $_has(2);
  @$pb.TagNumber(3)
  void clearByteSize() => $_clearField(3);

  @$pb.TagNumber(4)
  $1.Timestamp get observedAt => $_getN(3);
  @$pb.TagNumber(4)
  set observedAt($1.Timestamp value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasObservedAt() => $_has(3);
  @$pb.TagNumber(4)
  void clearObservedAt() => $_clearField(4);
  @$pb.TagNumber(4)
  $1.Timestamp ensureObservedAt() => $_ensure(3);
}

/// AgentMemory represents bounded session-scoped working memory (RULE-M21-003, EC-M21-003).
class AgentMemory extends $pb.GeneratedMessage {
  factory AgentMemory({
    $fixnum.Int64? totalBytes,
    $fixnum.Int64? maxBytes,
    $core.bool? isCompressed,
    $core.Iterable<AgentMemoryEntry>? entries,
    $core.String? summary,
  }) {
    final result = AgentMemory._();
    if (totalBytes != null) result.totalBytes = totalBytes;
    if (maxBytes != null) result.maxBytes = maxBytes;
    if (isCompressed != null) result.isCompressed = isCompressed;
    if (entries != null) result.entries.addAll(entries);
    if (summary != null) result.summary = summary;
    return result;
  }

  AgentMemory._();

  factory AgentMemory.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      AgentMemory()..mergeFromBuffer(data, registry);
  factory AgentMemory.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      AgentMemory()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AgentMemory',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.automation.v1'),
      createEmptyInstance: AgentMemory.$_createMessage)
    ..aInt64(1, _omitFieldNames ? '' : 'totalBytes')
    ..aInt64(2, _omitFieldNames ? '' : 'maxBytes')
    ..aOB(3, _omitFieldNames ? '' : 'isCompressed')
    ..pPM<AgentMemoryEntry>(4, _omitFieldNames ? '' : 'entries',
        subBuilder: AgentMemoryEntry.$_createMessage)
    ..aOS(5, _omitFieldNames ? '' : 'summary')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AgentMemory clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AgentMemory copyWith(void Function(AgentMemory) updates) =>
      super.copyWith((message) => updates(message as AgentMemory))
          as AgentMemory;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use AgentMemory() / AgentMemory.new instead')
  static AgentMemory create() => AgentMemory._();
  static $pb.GeneratedMessage $_createMessage() => AgentMemory._();
  @$core.override
  AgentMemory createEmptyInstance() => AgentMemory._();
  @$core.pragma('dart2js:noInline')
  static AgentMemory getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AgentMemory>(
          AgentMemory.$_createMessage);
  static AgentMemory? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get totalBytes => $_getI64(0);
  @$pb.TagNumber(1)
  set totalBytes($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTotalBytes() => $_has(0);
  @$pb.TagNumber(1)
  void clearTotalBytes() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get maxBytes => $_getI64(1);
  @$pb.TagNumber(2)
  set maxBytes($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasMaxBytes() => $_has(1);
  @$pb.TagNumber(2)
  void clearMaxBytes() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.bool get isCompressed => $_getBF(2);
  @$pb.TagNumber(3)
  set isCompressed($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasIsCompressed() => $_has(2);
  @$pb.TagNumber(3)
  void clearIsCompressed() => $_clearField(3);

  @$pb.TagNumber(4)
  $pb.PbList<AgentMemoryEntry> get entries => $_getList(3);

  @$pb.TagNumber(5)
  $core.String get summary => $_getSZ(4);
  @$pb.TagNumber(5)
  set summary($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasSummary() => $_has(4);
  @$pb.TagNumber(5)
  void clearSummary() => $_clearField(5);
}

/// AgentHandoffContext captures structured context for human escalation (§28.2).
class AgentHandoffContext extends $pb.GeneratedMessage {
  factory AgentHandoffContext({
    $core.String? handoffTargetUserId,
    $core.String? reason,
    $core.String? summaryOfCompletedWork,
    $core.Iterable<$core.String>? unresolvedActions,
    $core.String? diagnosticsRef,
    $core.String? auditRef,
  }) {
    final result = AgentHandoffContext._();
    if (handoffTargetUserId != null)
      result.handoffTargetUserId = handoffTargetUserId;
    if (reason != null) result.reason = reason;
    if (summaryOfCompletedWork != null)
      result.summaryOfCompletedWork = summaryOfCompletedWork;
    if (unresolvedActions != null)
      result.unresolvedActions.addAll(unresolvedActions);
    if (diagnosticsRef != null) result.diagnosticsRef = diagnosticsRef;
    if (auditRef != null) result.auditRef = auditRef;
    return result;
  }

  AgentHandoffContext._();

  factory AgentHandoffContext.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      AgentHandoffContext()..mergeFromBuffer(data, registry);
  factory AgentHandoffContext.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      AgentHandoffContext()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AgentHandoffContext',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.automation.v1'),
      createEmptyInstance: AgentHandoffContext.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'handoffTargetUserId')
    ..aOS(2, _omitFieldNames ? '' : 'reason')
    ..aOS(3, _omitFieldNames ? '' : 'summaryOfCompletedWork')
    ..pPS(4, _omitFieldNames ? '' : 'unresolvedActions')
    ..aOS(5, _omitFieldNames ? '' : 'diagnosticsRef')
    ..aOS(6, _omitFieldNames ? '' : 'auditRef')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AgentHandoffContext clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AgentHandoffContext copyWith(void Function(AgentHandoffContext) updates) =>
      super.copyWith((message) => updates(message as AgentHandoffContext))
          as AgentHandoffContext;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core
      .Deprecated('Use AgentHandoffContext() / AgentHandoffContext.new instead')
  static AgentHandoffContext create() => AgentHandoffContext._();
  static $pb.GeneratedMessage $_createMessage() => AgentHandoffContext._();
  @$core.override
  AgentHandoffContext createEmptyInstance() => AgentHandoffContext._();
  @$core.pragma('dart2js:noInline')
  static AgentHandoffContext getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AgentHandoffContext>(
          AgentHandoffContext.$_createMessage);
  static AgentHandoffContext? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get handoffTargetUserId => $_getSZ(0);
  @$pb.TagNumber(1)
  set handoffTargetUserId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasHandoffTargetUserId() => $_has(0);
  @$pb.TagNumber(1)
  void clearHandoffTargetUserId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get reason => $_getSZ(1);
  @$pb.TagNumber(2)
  set reason($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasReason() => $_has(1);
  @$pb.TagNumber(2)
  void clearReason() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get summaryOfCompletedWork => $_getSZ(2);
  @$pb.TagNumber(3)
  set summaryOfCompletedWork($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasSummaryOfCompletedWork() => $_has(2);
  @$pb.TagNumber(3)
  void clearSummaryOfCompletedWork() => $_clearField(3);

  @$pb.TagNumber(4)
  $pb.PbList<$core.String> get unresolvedActions => $_getList(3);

  @$pb.TagNumber(5)
  $core.String get diagnosticsRef => $_getSZ(4);
  @$pb.TagNumber(5)
  set diagnosticsRef($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasDiagnosticsRef() => $_has(4);
  @$pb.TagNumber(5)
  void clearDiagnosticsRef() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get auditRef => $_getSZ(5);
  @$pb.TagNumber(6)
  set auditRef($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasAuditRef() => $_has(5);
  @$pb.TagNumber(6)
  void clearAuditRef() => $_clearField(6);
}

/// AgentRun represents an autonomous execution graph per database_schema.md §12.4.
class AgentRun extends $pb.GeneratedMessage {
  factory AgentRun({
    $core.String? agentRunId,
    $core.String? workspaceId,
    AgentType? agentType,
    $core.String? recipeId,
    $core.String? workflowId,
    $core.String? planSummary,
    $core.String? executionScopeJson,
    AgentApprovalState? approvalState,
    AgentRunState? currentState,
    $core.String? sideEffectsSummaryJson,
    AgentHandoffContext? handoffContext,
    $core.String? diagnosticsRef,
    $core.String? auditRef,
    $core.String? creditsUsed,
    $core.String? budgetCeiling,
    AgentMemory? memory,
    $core.Iterable<AgentStep>? steps,
    $core.Iterable<AgentOutput>? outputs,
    $core.String? createdBy,
    $1.Timestamp? startedAt,
    $1.Timestamp? completedAt,
    $1.Timestamp? createdAt,
    $1.Timestamp? updatedAt,
  }) {
    final result = AgentRun._();
    if (agentRunId != null) result.agentRunId = agentRunId;
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (agentType != null) result.agentType = agentType;
    if (recipeId != null) result.recipeId = recipeId;
    if (workflowId != null) result.workflowId = workflowId;
    if (planSummary != null) result.planSummary = planSummary;
    if (executionScopeJson != null)
      result.executionScopeJson = executionScopeJson;
    if (approvalState != null) result.approvalState = approvalState;
    if (currentState != null) result.currentState = currentState;
    if (sideEffectsSummaryJson != null)
      result.sideEffectsSummaryJson = sideEffectsSummaryJson;
    if (handoffContext != null) result.handoffContext = handoffContext;
    if (diagnosticsRef != null) result.diagnosticsRef = diagnosticsRef;
    if (auditRef != null) result.auditRef = auditRef;
    if (creditsUsed != null) result.creditsUsed = creditsUsed;
    if (budgetCeiling != null) result.budgetCeiling = budgetCeiling;
    if (memory != null) result.memory = memory;
    if (steps != null) result.steps.addAll(steps);
    if (outputs != null) result.outputs.addAll(outputs);
    if (createdBy != null) result.createdBy = createdBy;
    if (startedAt != null) result.startedAt = startedAt;
    if (completedAt != null) result.completedAt = completedAt;
    if (createdAt != null) result.createdAt = createdAt;
    if (updatedAt != null) result.updatedAt = updatedAt;
    return result;
  }

  AgentRun._();

  factory AgentRun.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      AgentRun()..mergeFromBuffer(data, registry);
  factory AgentRun.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      AgentRun()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AgentRun',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.automation.v1'),
      createEmptyInstance: AgentRun.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'agentRunId')
    ..aOS(2, _omitFieldNames ? '' : 'workspaceId')
    ..aE<AgentType>(3, _omitFieldNames ? '' : 'agentType',
        enumValues: AgentType.values)
    ..aOS(4, _omitFieldNames ? '' : 'recipeId')
    ..aOS(5, _omitFieldNames ? '' : 'workflowId')
    ..aOS(6, _omitFieldNames ? '' : 'planSummary')
    ..aOS(7, _omitFieldNames ? '' : 'executionScopeJson')
    ..aE<AgentApprovalState>(8, _omitFieldNames ? '' : 'approvalState',
        enumValues: AgentApprovalState.values)
    ..aE<AgentRunState>(9, _omitFieldNames ? '' : 'currentState',
        enumValues: AgentRunState.values)
    ..aOS(10, _omitFieldNames ? '' : 'sideEffectsSummaryJson')
    ..aOM<AgentHandoffContext>(11, _omitFieldNames ? '' : 'handoffContext',
        subBuilder: AgentHandoffContext.$_createMessage)
    ..aOS(12, _omitFieldNames ? '' : 'diagnosticsRef')
    ..aOS(13, _omitFieldNames ? '' : 'auditRef')
    ..aOS(14, _omitFieldNames ? '' : 'creditsUsed')
    ..aOS(15, _omitFieldNames ? '' : 'budgetCeiling')
    ..aOM<AgentMemory>(16, _omitFieldNames ? '' : 'memory',
        subBuilder: AgentMemory.$_createMessage)
    ..pPM<AgentStep>(17, _omitFieldNames ? '' : 'steps',
        subBuilder: AgentStep.$_createMessage)
    ..pPM<AgentOutput>(18, _omitFieldNames ? '' : 'outputs',
        subBuilder: AgentOutput.$_createMessage)
    ..aOS(19, _omitFieldNames ? '' : 'createdBy')
    ..aOM<$1.Timestamp>(20, _omitFieldNames ? '' : 'startedAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..aOM<$1.Timestamp>(21, _omitFieldNames ? '' : 'completedAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..aOM<$1.Timestamp>(22, _omitFieldNames ? '' : 'createdAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..aOM<$1.Timestamp>(23, _omitFieldNames ? '' : 'updatedAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AgentRun clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AgentRun copyWith(void Function(AgentRun) updates) =>
      super.copyWith((message) => updates(message as AgentRun)) as AgentRun;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use AgentRun() / AgentRun.new instead')
  static AgentRun create() => AgentRun._();
  static $pb.GeneratedMessage $_createMessage() => AgentRun._();
  @$core.override
  AgentRun createEmptyInstance() => AgentRun._();
  @$core.pragma('dart2js:noInline')
  static AgentRun getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AgentRun>(AgentRun.$_createMessage);
  static AgentRun? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get agentRunId => $_getSZ(0);
  @$pb.TagNumber(1)
  set agentRunId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAgentRunId() => $_has(0);
  @$pb.TagNumber(1)
  void clearAgentRunId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get workspaceId => $_getSZ(1);
  @$pb.TagNumber(2)
  set workspaceId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasWorkspaceId() => $_has(1);
  @$pb.TagNumber(2)
  void clearWorkspaceId() => $_clearField(2);

  @$pb.TagNumber(3)
  AgentType get agentType => $_getN(2);
  @$pb.TagNumber(3)
  set agentType(AgentType value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasAgentType() => $_has(2);
  @$pb.TagNumber(3)
  void clearAgentType() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get recipeId => $_getSZ(3);
  @$pb.TagNumber(4)
  set recipeId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasRecipeId() => $_has(3);
  @$pb.TagNumber(4)
  void clearRecipeId() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get workflowId => $_getSZ(4);
  @$pb.TagNumber(5)
  set workflowId($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasWorkflowId() => $_has(4);
  @$pb.TagNumber(5)
  void clearWorkflowId() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get planSummary => $_getSZ(5);
  @$pb.TagNumber(6)
  set planSummary($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasPlanSummary() => $_has(5);
  @$pb.TagNumber(6)
  void clearPlanSummary() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get executionScopeJson => $_getSZ(6);
  @$pb.TagNumber(7)
  set executionScopeJson($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasExecutionScopeJson() => $_has(6);
  @$pb.TagNumber(7)
  void clearExecutionScopeJson() => $_clearField(7);

  @$pb.TagNumber(8)
  AgentApprovalState get approvalState => $_getN(7);
  @$pb.TagNumber(8)
  set approvalState(AgentApprovalState value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasApprovalState() => $_has(7);
  @$pb.TagNumber(8)
  void clearApprovalState() => $_clearField(8);

  @$pb.TagNumber(9)
  AgentRunState get currentState => $_getN(8);
  @$pb.TagNumber(9)
  set currentState(AgentRunState value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasCurrentState() => $_has(8);
  @$pb.TagNumber(9)
  void clearCurrentState() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.String get sideEffectsSummaryJson => $_getSZ(9);
  @$pb.TagNumber(10)
  set sideEffectsSummaryJson($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasSideEffectsSummaryJson() => $_has(9);
  @$pb.TagNumber(10)
  void clearSideEffectsSummaryJson() => $_clearField(10);

  @$pb.TagNumber(11)
  AgentHandoffContext get handoffContext => $_getN(10);
  @$pb.TagNumber(11)
  set handoffContext(AgentHandoffContext value) => $_setField(11, value);
  @$pb.TagNumber(11)
  $core.bool hasHandoffContext() => $_has(10);
  @$pb.TagNumber(11)
  void clearHandoffContext() => $_clearField(11);
  @$pb.TagNumber(11)
  AgentHandoffContext ensureHandoffContext() => $_ensure(10);

  @$pb.TagNumber(12)
  $core.String get diagnosticsRef => $_getSZ(11);
  @$pb.TagNumber(12)
  set diagnosticsRef($core.String value) => $_setString(11, value);
  @$pb.TagNumber(12)
  $core.bool hasDiagnosticsRef() => $_has(11);
  @$pb.TagNumber(12)
  void clearDiagnosticsRef() => $_clearField(12);

  @$pb.TagNumber(13)
  $core.String get auditRef => $_getSZ(12);
  @$pb.TagNumber(13)
  set auditRef($core.String value) => $_setString(12, value);
  @$pb.TagNumber(13)
  $core.bool hasAuditRef() => $_has(12);
  @$pb.TagNumber(13)
  void clearAuditRef() => $_clearField(13);

  @$pb.TagNumber(14)
  $core.String get creditsUsed => $_getSZ(13);
  @$pb.TagNumber(14)
  set creditsUsed($core.String value) => $_setString(13, value);
  @$pb.TagNumber(14)
  $core.bool hasCreditsUsed() => $_has(13);
  @$pb.TagNumber(14)
  void clearCreditsUsed() => $_clearField(14);

  @$pb.TagNumber(15)
  $core.String get budgetCeiling => $_getSZ(14);
  @$pb.TagNumber(15)
  set budgetCeiling($core.String value) => $_setString(14, value);
  @$pb.TagNumber(15)
  $core.bool hasBudgetCeiling() => $_has(14);
  @$pb.TagNumber(15)
  void clearBudgetCeiling() => $_clearField(15);

  @$pb.TagNumber(16)
  AgentMemory get memory => $_getN(15);
  @$pb.TagNumber(16)
  set memory(AgentMemory value) => $_setField(16, value);
  @$pb.TagNumber(16)
  $core.bool hasMemory() => $_has(15);
  @$pb.TagNumber(16)
  void clearMemory() => $_clearField(16);
  @$pb.TagNumber(16)
  AgentMemory ensureMemory() => $_ensure(15);

  @$pb.TagNumber(17)
  $pb.PbList<AgentStep> get steps => $_getList(16);

  @$pb.TagNumber(18)
  $pb.PbList<AgentOutput> get outputs => $_getList(17);

  @$pb.TagNumber(19)
  $core.String get createdBy => $_getSZ(18);
  @$pb.TagNumber(19)
  set createdBy($core.String value) => $_setString(18, value);
  @$pb.TagNumber(19)
  $core.bool hasCreatedBy() => $_has(18);
  @$pb.TagNumber(19)
  void clearCreatedBy() => $_clearField(19);

  @$pb.TagNumber(20)
  $1.Timestamp get startedAt => $_getN(19);
  @$pb.TagNumber(20)
  set startedAt($1.Timestamp value) => $_setField(20, value);
  @$pb.TagNumber(20)
  $core.bool hasStartedAt() => $_has(19);
  @$pb.TagNumber(20)
  void clearStartedAt() => $_clearField(20);
  @$pb.TagNumber(20)
  $1.Timestamp ensureStartedAt() => $_ensure(19);

  @$pb.TagNumber(21)
  $1.Timestamp get completedAt => $_getN(20);
  @$pb.TagNumber(21)
  set completedAt($1.Timestamp value) => $_setField(21, value);
  @$pb.TagNumber(21)
  $core.bool hasCompletedAt() => $_has(20);
  @$pb.TagNumber(21)
  void clearCompletedAt() => $_clearField(21);
  @$pb.TagNumber(21)
  $1.Timestamp ensureCompletedAt() => $_ensure(20);

  @$pb.TagNumber(22)
  $1.Timestamp get createdAt => $_getN(21);
  @$pb.TagNumber(22)
  set createdAt($1.Timestamp value) => $_setField(22, value);
  @$pb.TagNumber(22)
  $core.bool hasCreatedAt() => $_has(21);
  @$pb.TagNumber(22)
  void clearCreatedAt() => $_clearField(22);
  @$pb.TagNumber(22)
  $1.Timestamp ensureCreatedAt() => $_ensure(21);

  @$pb.TagNumber(23)
  $1.Timestamp get updatedAt => $_getN(22);
  @$pb.TagNumber(23)
  set updatedAt($1.Timestamp value) => $_setField(23, value);
  @$pb.TagNumber(23)
  $core.bool hasUpdatedAt() => $_has(22);
  @$pb.TagNumber(23)
  void clearUpdatedAt() => $_clearField(23);
  @$pb.TagNumber(23)
  $1.Timestamp ensureUpdatedAt() => $_ensure(22);
}

class AgentServiceLaunchAgentRequest extends $pb.GeneratedMessage {
  factory AgentServiceLaunchAgentRequest({
    $core.String? idempotencyKey,
    $core.String? workspaceId,
    AgentType? agentType,
    $core.String? taskPrompt,
    $core.String? recipeId,
    $core.String? workflowId,
    $core.String? budgetCeilingCredits,
    $core.String? executionScopeJson,
    $core.bool? autoExecute,
    $core.Iterable<$core.MapEntry<$core.String, $core.String>>? parameters,
  }) {
    final result = AgentServiceLaunchAgentRequest._();
    if (idempotencyKey != null) result.idempotencyKey = idempotencyKey;
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (agentType != null) result.agentType = agentType;
    if (taskPrompt != null) result.taskPrompt = taskPrompt;
    if (recipeId != null) result.recipeId = recipeId;
    if (workflowId != null) result.workflowId = workflowId;
    if (budgetCeilingCredits != null)
      result.budgetCeilingCredits = budgetCeilingCredits;
    if (executionScopeJson != null)
      result.executionScopeJson = executionScopeJson;
    if (autoExecute != null) result.autoExecute = autoExecute;
    if (parameters != null) result.parameters.addEntries(parameters);
    return result;
  }

  AgentServiceLaunchAgentRequest._();

  factory AgentServiceLaunchAgentRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      AgentServiceLaunchAgentRequest()..mergeFromBuffer(data, registry);
  factory AgentServiceLaunchAgentRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      AgentServiceLaunchAgentRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AgentServiceLaunchAgentRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.automation.v1'),
      createEmptyInstance: AgentServiceLaunchAgentRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'idempotencyKey')
    ..aOS(2, _omitFieldNames ? '' : 'workspaceId')
    ..aE<AgentType>(3, _omitFieldNames ? '' : 'agentType',
        enumValues: AgentType.values)
    ..aOS(4, _omitFieldNames ? '' : 'taskPrompt')
    ..aOS(5, _omitFieldNames ? '' : 'recipeId')
    ..aOS(6, _omitFieldNames ? '' : 'workflowId')
    ..aOS(7, _omitFieldNames ? '' : 'budgetCeilingCredits')
    ..aOS(8, _omitFieldNames ? '' : 'executionScopeJson')
    ..aOB(9, _omitFieldNames ? '' : 'autoExecute')
    ..m<$core.String, $core.String>(10, _omitFieldNames ? '' : 'parameters',
        entryClassName: 'AgentServiceLaunchAgentRequest.ParametersEntry',
        keyFieldType: $pb.PbFieldType.OS,
        valueFieldType: $pb.PbFieldType.OS,
        packageName: const $pb.PackageName('creativanta.automation.v1'))
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AgentServiceLaunchAgentRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AgentServiceLaunchAgentRequest copyWith(
          void Function(AgentServiceLaunchAgentRequest) updates) =>
      super.copyWith(
              (message) => updates(message as AgentServiceLaunchAgentRequest))
          as AgentServiceLaunchAgentRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use AgentServiceLaunchAgentRequest() / AgentServiceLaunchAgentRequest.new instead')
  static AgentServiceLaunchAgentRequest create() =>
      AgentServiceLaunchAgentRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      AgentServiceLaunchAgentRequest._();
  @$core.override
  AgentServiceLaunchAgentRequest createEmptyInstance() =>
      AgentServiceLaunchAgentRequest._();
  @$core.pragma('dart2js:noInline')
  static AgentServiceLaunchAgentRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AgentServiceLaunchAgentRequest>(
          AgentServiceLaunchAgentRequest.$_createMessage);
  static AgentServiceLaunchAgentRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get idempotencyKey => $_getSZ(0);
  @$pb.TagNumber(1)
  set idempotencyKey($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasIdempotencyKey() => $_has(0);
  @$pb.TagNumber(1)
  void clearIdempotencyKey() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get workspaceId => $_getSZ(1);
  @$pb.TagNumber(2)
  set workspaceId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasWorkspaceId() => $_has(1);
  @$pb.TagNumber(2)
  void clearWorkspaceId() => $_clearField(2);

  @$pb.TagNumber(3)
  AgentType get agentType => $_getN(2);
  @$pb.TagNumber(3)
  set agentType(AgentType value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasAgentType() => $_has(2);
  @$pb.TagNumber(3)
  void clearAgentType() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get taskPrompt => $_getSZ(3);
  @$pb.TagNumber(4)
  set taskPrompt($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasTaskPrompt() => $_has(3);
  @$pb.TagNumber(4)
  void clearTaskPrompt() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get recipeId => $_getSZ(4);
  @$pb.TagNumber(5)
  set recipeId($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasRecipeId() => $_has(4);
  @$pb.TagNumber(5)
  void clearRecipeId() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get workflowId => $_getSZ(5);
  @$pb.TagNumber(6)
  set workflowId($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasWorkflowId() => $_has(5);
  @$pb.TagNumber(6)
  void clearWorkflowId() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get budgetCeilingCredits => $_getSZ(6);
  @$pb.TagNumber(7)
  set budgetCeilingCredits($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasBudgetCeilingCredits() => $_has(6);
  @$pb.TagNumber(7)
  void clearBudgetCeilingCredits() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get executionScopeJson => $_getSZ(7);
  @$pb.TagNumber(8)
  set executionScopeJson($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasExecutionScopeJson() => $_has(7);
  @$pb.TagNumber(8)
  void clearExecutionScopeJson() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.bool get autoExecute => $_getBF(8);
  @$pb.TagNumber(9)
  set autoExecute($core.bool value) => $_setBool(8, value);
  @$pb.TagNumber(9)
  $core.bool hasAutoExecute() => $_has(8);
  @$pb.TagNumber(9)
  void clearAutoExecute() => $_clearField(9);

  @$pb.TagNumber(10)
  $pb.PbMap<$core.String, $core.String> get parameters => $_getMap(9);
}

class AgentServiceLaunchAgentResponse extends $pb.GeneratedMessage {
  factory AgentServiceLaunchAgentResponse({
    $core.bool? success,
    AgentRun? run,
    $core.Iterable<$core.String>? permissionWarnings,
    $core.bool? requiresApproval,
    $core.String? rejectionReason,
  }) {
    final result = AgentServiceLaunchAgentResponse._();
    if (success != null) result.success = success;
    if (run != null) result.run = run;
    if (permissionWarnings != null)
      result.permissionWarnings.addAll(permissionWarnings);
    if (requiresApproval != null) result.requiresApproval = requiresApproval;
    if (rejectionReason != null) result.rejectionReason = rejectionReason;
    return result;
  }

  AgentServiceLaunchAgentResponse._();

  factory AgentServiceLaunchAgentResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      AgentServiceLaunchAgentResponse()..mergeFromBuffer(data, registry);
  factory AgentServiceLaunchAgentResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      AgentServiceLaunchAgentResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AgentServiceLaunchAgentResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.automation.v1'),
      createEmptyInstance: AgentServiceLaunchAgentResponse.$_createMessage)
    ..aOB(1, _omitFieldNames ? '' : 'success')
    ..aOM<AgentRun>(2, _omitFieldNames ? '' : 'run',
        subBuilder: AgentRun.$_createMessage)
    ..pPS(3, _omitFieldNames ? '' : 'permissionWarnings')
    ..aOB(4, _omitFieldNames ? '' : 'requiresApproval')
    ..aOS(5, _omitFieldNames ? '' : 'rejectionReason')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AgentServiceLaunchAgentResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AgentServiceLaunchAgentResponse copyWith(
          void Function(AgentServiceLaunchAgentResponse) updates) =>
      super.copyWith(
              (message) => updates(message as AgentServiceLaunchAgentResponse))
          as AgentServiceLaunchAgentResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use AgentServiceLaunchAgentResponse() / AgentServiceLaunchAgentResponse.new instead')
  static AgentServiceLaunchAgentResponse create() =>
      AgentServiceLaunchAgentResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      AgentServiceLaunchAgentResponse._();
  @$core.override
  AgentServiceLaunchAgentResponse createEmptyInstance() =>
      AgentServiceLaunchAgentResponse._();
  @$core.pragma('dart2js:noInline')
  static AgentServiceLaunchAgentResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AgentServiceLaunchAgentResponse>(
          AgentServiceLaunchAgentResponse.$_createMessage);
  static AgentServiceLaunchAgentResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get success => $_getBF(0);
  @$pb.TagNumber(1)
  set success($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSuccess() => $_has(0);
  @$pb.TagNumber(1)
  void clearSuccess() => $_clearField(1);

  @$pb.TagNumber(2)
  AgentRun get run => $_getN(1);
  @$pb.TagNumber(2)
  set run(AgentRun value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasRun() => $_has(1);
  @$pb.TagNumber(2)
  void clearRun() => $_clearField(2);
  @$pb.TagNumber(2)
  AgentRun ensureRun() => $_ensure(1);

  @$pb.TagNumber(3)
  $pb.PbList<$core.String> get permissionWarnings => $_getList(2);

  @$pb.TagNumber(4)
  $core.bool get requiresApproval => $_getBF(3);
  @$pb.TagNumber(4)
  set requiresApproval($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(4)
  $core.bool hasRequiresApproval() => $_has(3);
  @$pb.TagNumber(4)
  void clearRequiresApproval() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get rejectionReason => $_getSZ(4);
  @$pb.TagNumber(5)
  set rejectionReason($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasRejectionReason() => $_has(4);
  @$pb.TagNumber(5)
  void clearRejectionReason() => $_clearField(5);
}

class AgentServiceListRunsRequest extends $pb.GeneratedMessage {
  factory AgentServiceListRunsRequest({
    $core.String? workspaceId,
    AgentType? agentType,
    AgentRunState? stateFilter,
    $core.int? pageSize,
    $core.String? pageToken,
  }) {
    final result = AgentServiceListRunsRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (agentType != null) result.agentType = agentType;
    if (stateFilter != null) result.stateFilter = stateFilter;
    if (pageSize != null) result.pageSize = pageSize;
    if (pageToken != null) result.pageToken = pageToken;
    return result;
  }

  AgentServiceListRunsRequest._();

  factory AgentServiceListRunsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      AgentServiceListRunsRequest()..mergeFromBuffer(data, registry);
  factory AgentServiceListRunsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      AgentServiceListRunsRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AgentServiceListRunsRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.automation.v1'),
      createEmptyInstance: AgentServiceListRunsRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aE<AgentType>(2, _omitFieldNames ? '' : 'agentType',
        enumValues: AgentType.values)
    ..aE<AgentRunState>(3, _omitFieldNames ? '' : 'stateFilter',
        enumValues: AgentRunState.values)
    ..aI(4, _omitFieldNames ? '' : 'pageSize')
    ..aOS(5, _omitFieldNames ? '' : 'pageToken')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AgentServiceListRunsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AgentServiceListRunsRequest copyWith(
          void Function(AgentServiceListRunsRequest) updates) =>
      super.copyWith(
              (message) => updates(message as AgentServiceListRunsRequest))
          as AgentServiceListRunsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use AgentServiceListRunsRequest() / AgentServiceListRunsRequest.new instead')
  static AgentServiceListRunsRequest create() =>
      AgentServiceListRunsRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      AgentServiceListRunsRequest._();
  @$core.override
  AgentServiceListRunsRequest createEmptyInstance() =>
      AgentServiceListRunsRequest._();
  @$core.pragma('dart2js:noInline')
  static AgentServiceListRunsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AgentServiceListRunsRequest>(
          AgentServiceListRunsRequest.$_createMessage);
  static AgentServiceListRunsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  AgentType get agentType => $_getN(1);
  @$pb.TagNumber(2)
  set agentType(AgentType value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasAgentType() => $_has(1);
  @$pb.TagNumber(2)
  void clearAgentType() => $_clearField(2);

  @$pb.TagNumber(3)
  AgentRunState get stateFilter => $_getN(2);
  @$pb.TagNumber(3)
  set stateFilter(AgentRunState value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasStateFilter() => $_has(2);
  @$pb.TagNumber(3)
  void clearStateFilter() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get pageSize => $_getIZ(3);
  @$pb.TagNumber(4)
  set pageSize($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasPageSize() => $_has(3);
  @$pb.TagNumber(4)
  void clearPageSize() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get pageToken => $_getSZ(4);
  @$pb.TagNumber(5)
  set pageToken($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasPageToken() => $_has(4);
  @$pb.TagNumber(5)
  void clearPageToken() => $_clearField(5);
}

class AgentServiceListRunsResponse extends $pb.GeneratedMessage {
  factory AgentServiceListRunsResponse({
    $core.Iterable<AgentRun>? runs,
    $core.String? nextPageToken,
    $core.int? totalCount,
  }) {
    final result = AgentServiceListRunsResponse._();
    if (runs != null) result.runs.addAll(runs);
    if (nextPageToken != null) result.nextPageToken = nextPageToken;
    if (totalCount != null) result.totalCount = totalCount;
    return result;
  }

  AgentServiceListRunsResponse._();

  factory AgentServiceListRunsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      AgentServiceListRunsResponse()..mergeFromBuffer(data, registry);
  factory AgentServiceListRunsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      AgentServiceListRunsResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AgentServiceListRunsResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.automation.v1'),
      createEmptyInstance: AgentServiceListRunsResponse.$_createMessage)
    ..pPM<AgentRun>(1, _omitFieldNames ? '' : 'runs',
        subBuilder: AgentRun.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'nextPageToken')
    ..aI(3, _omitFieldNames ? '' : 'totalCount')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AgentServiceListRunsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AgentServiceListRunsResponse copyWith(
          void Function(AgentServiceListRunsResponse) updates) =>
      super.copyWith(
              (message) => updates(message as AgentServiceListRunsResponse))
          as AgentServiceListRunsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use AgentServiceListRunsResponse() / AgentServiceListRunsResponse.new instead')
  static AgentServiceListRunsResponse create() =>
      AgentServiceListRunsResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      AgentServiceListRunsResponse._();
  @$core.override
  AgentServiceListRunsResponse createEmptyInstance() =>
      AgentServiceListRunsResponse._();
  @$core.pragma('dart2js:noInline')
  static AgentServiceListRunsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AgentServiceListRunsResponse>(
          AgentServiceListRunsResponse.$_createMessage);
  static AgentServiceListRunsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<AgentRun> get runs => $_getList(0);

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
}

class AgentServiceCancelRunRequest extends $pb.GeneratedMessage {
  factory AgentServiceCancelRunRequest({
    $core.String? idempotencyKey,
    $core.String? workspaceId,
    $core.String? agentRunId,
    $core.String? reason,
  }) {
    final result = AgentServiceCancelRunRequest._();
    if (idempotencyKey != null) result.idempotencyKey = idempotencyKey;
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (agentRunId != null) result.agentRunId = agentRunId;
    if (reason != null) result.reason = reason;
    return result;
  }

  AgentServiceCancelRunRequest._();

  factory AgentServiceCancelRunRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      AgentServiceCancelRunRequest()..mergeFromBuffer(data, registry);
  factory AgentServiceCancelRunRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      AgentServiceCancelRunRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AgentServiceCancelRunRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.automation.v1'),
      createEmptyInstance: AgentServiceCancelRunRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'idempotencyKey')
    ..aOS(2, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(3, _omitFieldNames ? '' : 'agentRunId')
    ..aOS(4, _omitFieldNames ? '' : 'reason')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AgentServiceCancelRunRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AgentServiceCancelRunRequest copyWith(
          void Function(AgentServiceCancelRunRequest) updates) =>
      super.copyWith(
              (message) => updates(message as AgentServiceCancelRunRequest))
          as AgentServiceCancelRunRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use AgentServiceCancelRunRequest() / AgentServiceCancelRunRequest.new instead')
  static AgentServiceCancelRunRequest create() =>
      AgentServiceCancelRunRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      AgentServiceCancelRunRequest._();
  @$core.override
  AgentServiceCancelRunRequest createEmptyInstance() =>
      AgentServiceCancelRunRequest._();
  @$core.pragma('dart2js:noInline')
  static AgentServiceCancelRunRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AgentServiceCancelRunRequest>(
          AgentServiceCancelRunRequest.$_createMessage);
  static AgentServiceCancelRunRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get idempotencyKey => $_getSZ(0);
  @$pb.TagNumber(1)
  set idempotencyKey($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasIdempotencyKey() => $_has(0);
  @$pb.TagNumber(1)
  void clearIdempotencyKey() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get workspaceId => $_getSZ(1);
  @$pb.TagNumber(2)
  set workspaceId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasWorkspaceId() => $_has(1);
  @$pb.TagNumber(2)
  void clearWorkspaceId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get agentRunId => $_getSZ(2);
  @$pb.TagNumber(3)
  set agentRunId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasAgentRunId() => $_has(2);
  @$pb.TagNumber(3)
  void clearAgentRunId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get reason => $_getSZ(3);
  @$pb.TagNumber(4)
  set reason($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasReason() => $_has(3);
  @$pb.TagNumber(4)
  void clearReason() => $_clearField(4);
}

class AgentServiceCancelRunResponse extends $pb.GeneratedMessage {
  factory AgentServiceCancelRunResponse({
    $core.bool? success,
    AgentRun? run,
  }) {
    final result = AgentServiceCancelRunResponse._();
    if (success != null) result.success = success;
    if (run != null) result.run = run;
    return result;
  }

  AgentServiceCancelRunResponse._();

  factory AgentServiceCancelRunResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      AgentServiceCancelRunResponse()..mergeFromBuffer(data, registry);
  factory AgentServiceCancelRunResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      AgentServiceCancelRunResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AgentServiceCancelRunResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.automation.v1'),
      createEmptyInstance: AgentServiceCancelRunResponse.$_createMessage)
    ..aOB(1, _omitFieldNames ? '' : 'success')
    ..aOM<AgentRun>(2, _omitFieldNames ? '' : 'run',
        subBuilder: AgentRun.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AgentServiceCancelRunResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AgentServiceCancelRunResponse copyWith(
          void Function(AgentServiceCancelRunResponse) updates) =>
      super.copyWith(
              (message) => updates(message as AgentServiceCancelRunResponse))
          as AgentServiceCancelRunResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use AgentServiceCancelRunResponse() / AgentServiceCancelRunResponse.new instead')
  static AgentServiceCancelRunResponse create() =>
      AgentServiceCancelRunResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      AgentServiceCancelRunResponse._();
  @$core.override
  AgentServiceCancelRunResponse createEmptyInstance() =>
      AgentServiceCancelRunResponse._();
  @$core.pragma('dart2js:noInline')
  static AgentServiceCancelRunResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AgentServiceCancelRunResponse>(
          AgentServiceCancelRunResponse.$_createMessage);
  static AgentServiceCancelRunResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get success => $_getBF(0);
  @$pb.TagNumber(1)
  set success($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSuccess() => $_has(0);
  @$pb.TagNumber(1)
  void clearSuccess() => $_clearField(1);

  @$pb.TagNumber(2)
  AgentRun get run => $_getN(1);
  @$pb.TagNumber(2)
  set run(AgentRun value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasRun() => $_has(1);
  @$pb.TagNumber(2)
  void clearRun() => $_clearField(2);
  @$pb.TagNumber(2)
  AgentRun ensureRun() => $_ensure(1);
}

class AgentServiceStreamRunRequest extends $pb.GeneratedMessage {
  factory AgentServiceStreamRunRequest({
    $core.String? workspaceId,
    $core.String? agentRunId,
  }) {
    final result = AgentServiceStreamRunRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (agentRunId != null) result.agentRunId = agentRunId;
    return result;
  }

  AgentServiceStreamRunRequest._();

  factory AgentServiceStreamRunRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      AgentServiceStreamRunRequest()..mergeFromBuffer(data, registry);
  factory AgentServiceStreamRunRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      AgentServiceStreamRunRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AgentServiceStreamRunRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.automation.v1'),
      createEmptyInstance: AgentServiceStreamRunRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'agentRunId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AgentServiceStreamRunRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AgentServiceStreamRunRequest copyWith(
          void Function(AgentServiceStreamRunRequest) updates) =>
      super.copyWith(
              (message) => updates(message as AgentServiceStreamRunRequest))
          as AgentServiceStreamRunRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use AgentServiceStreamRunRequest() / AgentServiceStreamRunRequest.new instead')
  static AgentServiceStreamRunRequest create() =>
      AgentServiceStreamRunRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      AgentServiceStreamRunRequest._();
  @$core.override
  AgentServiceStreamRunRequest createEmptyInstance() =>
      AgentServiceStreamRunRequest._();
  @$core.pragma('dart2js:noInline')
  static AgentServiceStreamRunRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AgentServiceStreamRunRequest>(
          AgentServiceStreamRunRequest.$_createMessage);
  static AgentServiceStreamRunRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get agentRunId => $_getSZ(1);
  @$pb.TagNumber(2)
  set agentRunId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasAgentRunId() => $_has(1);
  @$pb.TagNumber(2)
  void clearAgentRunId() => $_clearField(2);
}

class AgentServiceStreamRunResponse extends $pb.GeneratedMessage {
  factory AgentServiceStreamRunResponse({
    AgentRun? run,
    AgentStep? currentStep,
    $core.String? progressMessage,
    $core.int? progressPercent,
  }) {
    final result = AgentServiceStreamRunResponse._();
    if (run != null) result.run = run;
    if (currentStep != null) result.currentStep = currentStep;
    if (progressMessage != null) result.progressMessage = progressMessage;
    if (progressPercent != null) result.progressPercent = progressPercent;
    return result;
  }

  AgentServiceStreamRunResponse._();

  factory AgentServiceStreamRunResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      AgentServiceStreamRunResponse()..mergeFromBuffer(data, registry);
  factory AgentServiceStreamRunResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      AgentServiceStreamRunResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AgentServiceStreamRunResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.automation.v1'),
      createEmptyInstance: AgentServiceStreamRunResponse.$_createMessage)
    ..aOM<AgentRun>(1, _omitFieldNames ? '' : 'run',
        subBuilder: AgentRun.$_createMessage)
    ..aOM<AgentStep>(2, _omitFieldNames ? '' : 'currentStep',
        subBuilder: AgentStep.$_createMessage)
    ..aOS(3, _omitFieldNames ? '' : 'progressMessage')
    ..aI(4, _omitFieldNames ? '' : 'progressPercent')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AgentServiceStreamRunResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AgentServiceStreamRunResponse copyWith(
          void Function(AgentServiceStreamRunResponse) updates) =>
      super.copyWith(
              (message) => updates(message as AgentServiceStreamRunResponse))
          as AgentServiceStreamRunResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use AgentServiceStreamRunResponse() / AgentServiceStreamRunResponse.new instead')
  static AgentServiceStreamRunResponse create() =>
      AgentServiceStreamRunResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      AgentServiceStreamRunResponse._();
  @$core.override
  AgentServiceStreamRunResponse createEmptyInstance() =>
      AgentServiceStreamRunResponse._();
  @$core.pragma('dart2js:noInline')
  static AgentServiceStreamRunResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AgentServiceStreamRunResponse>(
          AgentServiceStreamRunResponse.$_createMessage);
  static AgentServiceStreamRunResponse? _defaultInstance;

  @$pb.TagNumber(1)
  AgentRun get run => $_getN(0);
  @$pb.TagNumber(1)
  set run(AgentRun value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasRun() => $_has(0);
  @$pb.TagNumber(1)
  void clearRun() => $_clearField(1);
  @$pb.TagNumber(1)
  AgentRun ensureRun() => $_ensure(0);

  @$pb.TagNumber(2)
  AgentStep get currentStep => $_getN(1);
  @$pb.TagNumber(2)
  set currentStep(AgentStep value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasCurrentStep() => $_has(1);
  @$pb.TagNumber(2)
  void clearCurrentStep() => $_clearField(2);
  @$pb.TagNumber(2)
  AgentStep ensureCurrentStep() => $_ensure(1);

  @$pb.TagNumber(3)
  $core.String get progressMessage => $_getSZ(2);
  @$pb.TagNumber(3)
  set progressMessage($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasProgressMessage() => $_has(2);
  @$pb.TagNumber(3)
  void clearProgressMessage() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get progressPercent => $_getIZ(3);
  @$pb.TagNumber(4)
  set progressPercent($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasProgressPercent() => $_has(3);
  @$pb.TagNumber(4)
  void clearProgressPercent() => $_clearField(4);
}

class AgentServiceProvideInputRequest extends $pb.GeneratedMessage {
  factory AgentServiceProvideInputRequest({
    $core.String? idempotencyKey,
    $core.String? workspaceId,
    $core.String? agentRunId,
    $core.String? inputText,
    $core.String? inputJson,
    $core.bool? approvePlan,
    $core.String? budgetCeilingIncrease,
    $core.String? handoffTargetUserId,
  }) {
    final result = AgentServiceProvideInputRequest._();
    if (idempotencyKey != null) result.idempotencyKey = idempotencyKey;
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (agentRunId != null) result.agentRunId = agentRunId;
    if (inputText != null) result.inputText = inputText;
    if (inputJson != null) result.inputJson = inputJson;
    if (approvePlan != null) result.approvePlan = approvePlan;
    if (budgetCeilingIncrease != null)
      result.budgetCeilingIncrease = budgetCeilingIncrease;
    if (handoffTargetUserId != null)
      result.handoffTargetUserId = handoffTargetUserId;
    return result;
  }

  AgentServiceProvideInputRequest._();

  factory AgentServiceProvideInputRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      AgentServiceProvideInputRequest()..mergeFromBuffer(data, registry);
  factory AgentServiceProvideInputRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      AgentServiceProvideInputRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AgentServiceProvideInputRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.automation.v1'),
      createEmptyInstance: AgentServiceProvideInputRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'idempotencyKey')
    ..aOS(2, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(3, _omitFieldNames ? '' : 'agentRunId')
    ..aOS(4, _omitFieldNames ? '' : 'inputText')
    ..aOS(5, _omitFieldNames ? '' : 'inputJson')
    ..aOB(6, _omitFieldNames ? '' : 'approvePlan')
    ..aOS(7, _omitFieldNames ? '' : 'budgetCeilingIncrease')
    ..aOS(8, _omitFieldNames ? '' : 'handoffTargetUserId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AgentServiceProvideInputRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AgentServiceProvideInputRequest copyWith(
          void Function(AgentServiceProvideInputRequest) updates) =>
      super.copyWith(
              (message) => updates(message as AgentServiceProvideInputRequest))
          as AgentServiceProvideInputRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use AgentServiceProvideInputRequest() / AgentServiceProvideInputRequest.new instead')
  static AgentServiceProvideInputRequest create() =>
      AgentServiceProvideInputRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      AgentServiceProvideInputRequest._();
  @$core.override
  AgentServiceProvideInputRequest createEmptyInstance() =>
      AgentServiceProvideInputRequest._();
  @$core.pragma('dart2js:noInline')
  static AgentServiceProvideInputRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AgentServiceProvideInputRequest>(
          AgentServiceProvideInputRequest.$_createMessage);
  static AgentServiceProvideInputRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get idempotencyKey => $_getSZ(0);
  @$pb.TagNumber(1)
  set idempotencyKey($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasIdempotencyKey() => $_has(0);
  @$pb.TagNumber(1)
  void clearIdempotencyKey() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get workspaceId => $_getSZ(1);
  @$pb.TagNumber(2)
  set workspaceId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasWorkspaceId() => $_has(1);
  @$pb.TagNumber(2)
  void clearWorkspaceId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get agentRunId => $_getSZ(2);
  @$pb.TagNumber(3)
  set agentRunId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasAgentRunId() => $_has(2);
  @$pb.TagNumber(3)
  void clearAgentRunId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get inputText => $_getSZ(3);
  @$pb.TagNumber(4)
  set inputText($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasInputText() => $_has(3);
  @$pb.TagNumber(4)
  void clearInputText() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get inputJson => $_getSZ(4);
  @$pb.TagNumber(5)
  set inputJson($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasInputJson() => $_has(4);
  @$pb.TagNumber(5)
  void clearInputJson() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.bool get approvePlan => $_getBF(5);
  @$pb.TagNumber(6)
  set approvePlan($core.bool value) => $_setBool(5, value);
  @$pb.TagNumber(6)
  $core.bool hasApprovePlan() => $_has(5);
  @$pb.TagNumber(6)
  void clearApprovePlan() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get budgetCeilingIncrease => $_getSZ(6);
  @$pb.TagNumber(7)
  set budgetCeilingIncrease($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasBudgetCeilingIncrease() => $_has(6);
  @$pb.TagNumber(7)
  void clearBudgetCeilingIncrease() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get handoffTargetUserId => $_getSZ(7);
  @$pb.TagNumber(8)
  set handoffTargetUserId($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasHandoffTargetUserId() => $_has(7);
  @$pb.TagNumber(8)
  void clearHandoffTargetUserId() => $_clearField(8);
}

class AgentServiceProvideInputResponse extends $pb.GeneratedMessage {
  factory AgentServiceProvideInputResponse({
    $core.bool? success,
    AgentRun? run,
  }) {
    final result = AgentServiceProvideInputResponse._();
    if (success != null) result.success = success;
    if (run != null) result.run = run;
    return result;
  }

  AgentServiceProvideInputResponse._();

  factory AgentServiceProvideInputResponse.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      AgentServiceProvideInputResponse()..mergeFromBuffer(data, registry);
  factory AgentServiceProvideInputResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      AgentServiceProvideInputResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AgentServiceProvideInputResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.automation.v1'),
      createEmptyInstance: AgentServiceProvideInputResponse.$_createMessage)
    ..aOB(1, _omitFieldNames ? '' : 'success')
    ..aOM<AgentRun>(2, _omitFieldNames ? '' : 'run',
        subBuilder: AgentRun.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AgentServiceProvideInputResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AgentServiceProvideInputResponse copyWith(
          void Function(AgentServiceProvideInputResponse) updates) =>
      super.copyWith(
              (message) => updates(message as AgentServiceProvideInputResponse))
          as AgentServiceProvideInputResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use AgentServiceProvideInputResponse() / AgentServiceProvideInputResponse.new instead')
  static AgentServiceProvideInputResponse create() =>
      AgentServiceProvideInputResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      AgentServiceProvideInputResponse._();
  @$core.override
  AgentServiceProvideInputResponse createEmptyInstance() =>
      AgentServiceProvideInputResponse._();
  @$core.pragma('dart2js:noInline')
  static AgentServiceProvideInputResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AgentServiceProvideInputResponse>(
          AgentServiceProvideInputResponse.$_createMessage);
  static AgentServiceProvideInputResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get success => $_getBF(0);
  @$pb.TagNumber(1)
  set success($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSuccess() => $_has(0);
  @$pb.TagNumber(1)
  void clearSuccess() => $_clearField(1);

  @$pb.TagNumber(2)
  AgentRun get run => $_getN(1);
  @$pb.TagNumber(2)
  set run(AgentRun value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasRun() => $_has(1);
  @$pb.TagNumber(2)
  void clearRun() => $_clearField(2);
  @$pb.TagNumber(2)
  AgentRun ensureRun() => $_ensure(1);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');

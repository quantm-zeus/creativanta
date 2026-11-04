// This is a generated file - do not edit.
//
// Generated from creativanta/automation/v1/workflow.proto.

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

import 'workflow.pbenum.dart';

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'workflow.pbenum.dart';

class TriggerFilter extends $pb.GeneratedMessage {
  factory TriggerFilter({
    $core.String? field_1,
    $core.String? operator,
    $core.String? valueJson,
  }) {
    final result = TriggerFilter._();
    if (field_1 != null) result.field_1 = field_1;
    if (operator != null) result.operator = operator;
    if (valueJson != null) result.valueJson = valueJson;
    return result;
  }

  TriggerFilter._();

  factory TriggerFilter.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      TriggerFilter()..mergeFromBuffer(data, registry);
  factory TriggerFilter.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      TriggerFilter()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TriggerFilter',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.automation.v1'),
      createEmptyInstance: TriggerFilter.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'field')
    ..aOS(2, _omitFieldNames ? '' : 'operator')
    ..aOS(3, _omitFieldNames ? '' : 'valueJson')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TriggerFilter clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TriggerFilter copyWith(void Function(TriggerFilter) updates) =>
      super.copyWith((message) => updates(message as TriggerFilter))
          as TriggerFilter;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use TriggerFilter() / TriggerFilter.new instead')
  static TriggerFilter create() => TriggerFilter._();
  static $pb.GeneratedMessage $_createMessage() => TriggerFilter._();
  @$core.override
  TriggerFilter createEmptyInstance() => TriggerFilter._();
  @$core.pragma('dart2js:noInline')
  static TriggerFilter getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<TriggerFilter>(
          TriggerFilter.$_createMessage);
  static TriggerFilter? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get field_1 => $_getSZ(0);
  @$pb.TagNumber(1)
  set field_1($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasField_1() => $_has(0);
  @$pb.TagNumber(1)
  void clearField_1() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get operator => $_getSZ(1);
  @$pb.TagNumber(2)
  set operator($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasOperator() => $_has(1);
  @$pb.TagNumber(2)
  void clearOperator() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get valueJson => $_getSZ(2);
  @$pb.TagNumber(3)
  set valueJson($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasValueJson() => $_has(2);
  @$pb.TagNumber(3)
  void clearValueJson() => $_clearField(3);
}

class TriggerConfig extends $pb.GeneratedMessage {
  factory TriggerConfig({
    TriggerType? type,
    $core.String? eventType,
    $core.String? cronExpression,
    $core.String? webhookPath,
    $core.Iterable<TriggerFilter>? filters,
  }) {
    final result = TriggerConfig._();
    if (type != null) result.type = type;
    if (eventType != null) result.eventType = eventType;
    if (cronExpression != null) result.cronExpression = cronExpression;
    if (webhookPath != null) result.webhookPath = webhookPath;
    if (filters != null) result.filters.addAll(filters);
    return result;
  }

  TriggerConfig._();

  factory TriggerConfig.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      TriggerConfig()..mergeFromBuffer(data, registry);
  factory TriggerConfig.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      TriggerConfig()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TriggerConfig',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.automation.v1'),
      createEmptyInstance: TriggerConfig.$_createMessage)
    ..aE<TriggerType>(1, _omitFieldNames ? '' : 'type',
        enumValues: TriggerType.values)
    ..aOS(2, _omitFieldNames ? '' : 'eventType')
    ..aOS(3, _omitFieldNames ? '' : 'cronExpression')
    ..aOS(4, _omitFieldNames ? '' : 'webhookPath')
    ..pPM<TriggerFilter>(5, _omitFieldNames ? '' : 'filters',
        subBuilder: TriggerFilter.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TriggerConfig clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TriggerConfig copyWith(void Function(TriggerConfig) updates) =>
      super.copyWith((message) => updates(message as TriggerConfig))
          as TriggerConfig;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use TriggerConfig() / TriggerConfig.new instead')
  static TriggerConfig create() => TriggerConfig._();
  static $pb.GeneratedMessage $_createMessage() => TriggerConfig._();
  @$core.override
  TriggerConfig createEmptyInstance() => TriggerConfig._();
  @$core.pragma('dart2js:noInline')
  static TriggerConfig getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<TriggerConfig>(
          TriggerConfig.$_createMessage);
  static TriggerConfig? _defaultInstance;

  @$pb.TagNumber(1)
  TriggerType get type => $_getN(0);
  @$pb.TagNumber(1)
  set type(TriggerType value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasType() => $_has(0);
  @$pb.TagNumber(1)
  void clearType() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get eventType => $_getSZ(1);
  @$pb.TagNumber(2)
  set eventType($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasEventType() => $_has(1);
  @$pb.TagNumber(2)
  void clearEventType() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get cronExpression => $_getSZ(2);
  @$pb.TagNumber(3)
  set cronExpression($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasCronExpression() => $_has(2);
  @$pb.TagNumber(3)
  void clearCronExpression() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get webhookPath => $_getSZ(3);
  @$pb.TagNumber(4)
  set webhookPath($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasWebhookPath() => $_has(3);
  @$pb.TagNumber(4)
  void clearWebhookPath() => $_clearField(4);

  @$pb.TagNumber(5)
  $pb.PbList<TriggerFilter> get filters => $_getList(4);
}

class TriggerNodeConfig extends $pb.GeneratedMessage {
  factory TriggerNodeConfig({
    TriggerConfig? config,
  }) {
    final result = TriggerNodeConfig._();
    if (config != null) result.config = config;
    return result;
  }

  TriggerNodeConfig._();

  factory TriggerNodeConfig.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      TriggerNodeConfig()..mergeFromBuffer(data, registry);
  factory TriggerNodeConfig.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      TriggerNodeConfig()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TriggerNodeConfig',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.automation.v1'),
      createEmptyInstance: TriggerNodeConfig.$_createMessage)
    ..aOM<TriggerConfig>(1, _omitFieldNames ? '' : 'config',
        subBuilder: TriggerConfig.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TriggerNodeConfig clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TriggerNodeConfig copyWith(void Function(TriggerNodeConfig) updates) =>
      super.copyWith((message) => updates(message as TriggerNodeConfig))
          as TriggerNodeConfig;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use TriggerNodeConfig() / TriggerNodeConfig.new instead')
  static TriggerNodeConfig create() => TriggerNodeConfig._();
  static $pb.GeneratedMessage $_createMessage() => TriggerNodeConfig._();
  @$core.override
  TriggerNodeConfig createEmptyInstance() => TriggerNodeConfig._();
  @$core.pragma('dart2js:noInline')
  static TriggerNodeConfig getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<TriggerNodeConfig>(
          TriggerNodeConfig.$_createMessage);
  static TriggerNodeConfig? _defaultInstance;

  @$pb.TagNumber(1)
  TriggerConfig get config => $_getN(0);
  @$pb.TagNumber(1)
  set config(TriggerConfig value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasConfig() => $_has(0);
  @$pb.TagNumber(1)
  void clearConfig() => $_clearField(1);
  @$pb.TagNumber(1)
  TriggerConfig ensureConfig() => $_ensure(0);
}

class ConditionNodeConfig extends $pb.GeneratedMessage {
  factory ConditionNodeConfig({
    $core.String? field_1,
    $core.String? operator,
    $core.String? valueJson,
  }) {
    final result = ConditionNodeConfig._();
    if (field_1 != null) result.field_1 = field_1;
    if (operator != null) result.operator = operator;
    if (valueJson != null) result.valueJson = valueJson;
    return result;
  }

  ConditionNodeConfig._();

  factory ConditionNodeConfig.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ConditionNodeConfig()..mergeFromBuffer(data, registry);
  factory ConditionNodeConfig.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ConditionNodeConfig()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ConditionNodeConfig',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.automation.v1'),
      createEmptyInstance: ConditionNodeConfig.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'field')
    ..aOS(2, _omitFieldNames ? '' : 'operator')
    ..aOS(3, _omitFieldNames ? '' : 'valueJson')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ConditionNodeConfig clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ConditionNodeConfig copyWith(void Function(ConditionNodeConfig) updates) =>
      super.copyWith((message) => updates(message as ConditionNodeConfig))
          as ConditionNodeConfig;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core
      .Deprecated('Use ConditionNodeConfig() / ConditionNodeConfig.new instead')
  static ConditionNodeConfig create() => ConditionNodeConfig._();
  static $pb.GeneratedMessage $_createMessage() => ConditionNodeConfig._();
  @$core.override
  ConditionNodeConfig createEmptyInstance() => ConditionNodeConfig._();
  @$core.pragma('dart2js:noInline')
  static ConditionNodeConfig getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ConditionNodeConfig>(
          ConditionNodeConfig.$_createMessage);
  static ConditionNodeConfig? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get field_1 => $_getSZ(0);
  @$pb.TagNumber(1)
  set field_1($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasField_1() => $_has(0);
  @$pb.TagNumber(1)
  void clearField_1() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get operator => $_getSZ(1);
  @$pb.TagNumber(2)
  set operator($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasOperator() => $_has(1);
  @$pb.TagNumber(2)
  void clearOperator() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get valueJson => $_getSZ(2);
  @$pb.TagNumber(3)
  set valueJson($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasValueJson() => $_has(2);
  @$pb.TagNumber(3)
  void clearValueJson() => $_clearField(3);
}

class TransformMapping extends $pb.GeneratedMessage {
  factory TransformMapping({
    $core.String? targetField,
    $core.String? sourceField,
    $core.String? defaultValue,
    $core.String? template,
  }) {
    final result = TransformMapping._();
    if (targetField != null) result.targetField = targetField;
    if (sourceField != null) result.sourceField = sourceField;
    if (defaultValue != null) result.defaultValue = defaultValue;
    if (template != null) result.template = template;
    return result;
  }

  TransformMapping._();

  factory TransformMapping.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      TransformMapping()..mergeFromBuffer(data, registry);
  factory TransformMapping.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      TransformMapping()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TransformMapping',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.automation.v1'),
      createEmptyInstance: TransformMapping.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'targetField')
    ..aOS(2, _omitFieldNames ? '' : 'sourceField')
    ..aOS(3, _omitFieldNames ? '' : 'defaultValue')
    ..aOS(4, _omitFieldNames ? '' : 'template')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TransformMapping clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TransformMapping copyWith(void Function(TransformMapping) updates) =>
      super.copyWith((message) => updates(message as TransformMapping))
          as TransformMapping;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use TransformMapping() / TransformMapping.new instead')
  static TransformMapping create() => TransformMapping._();
  static $pb.GeneratedMessage $_createMessage() => TransformMapping._();
  @$core.override
  TransformMapping createEmptyInstance() => TransformMapping._();
  @$core.pragma('dart2js:noInline')
  static TransformMapping getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<TransformMapping>(
          TransformMapping.$_createMessage);
  static TransformMapping? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get targetField => $_getSZ(0);
  @$pb.TagNumber(1)
  set targetField($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTargetField() => $_has(0);
  @$pb.TagNumber(1)
  void clearTargetField() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get sourceField => $_getSZ(1);
  @$pb.TagNumber(2)
  set sourceField($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSourceField() => $_has(1);
  @$pb.TagNumber(2)
  void clearSourceField() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get defaultValue => $_getSZ(2);
  @$pb.TagNumber(3)
  set defaultValue($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasDefaultValue() => $_has(2);
  @$pb.TagNumber(3)
  void clearDefaultValue() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get template => $_getSZ(3);
  @$pb.TagNumber(4)
  set template($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasTemplate() => $_has(3);
  @$pb.TagNumber(4)
  void clearTemplate() => $_clearField(4);
}

class TransformNodeConfig extends $pb.GeneratedMessage {
  factory TransformNodeConfig({
    $core.Iterable<TransformMapping>? mappings,
  }) {
    final result = TransformNodeConfig._();
    if (mappings != null) result.mappings.addAll(mappings);
    return result;
  }

  TransformNodeConfig._();

  factory TransformNodeConfig.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      TransformNodeConfig()..mergeFromBuffer(data, registry);
  factory TransformNodeConfig.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      TransformNodeConfig()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TransformNodeConfig',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.automation.v1'),
      createEmptyInstance: TransformNodeConfig.$_createMessage)
    ..pPM<TransformMapping>(1, _omitFieldNames ? '' : 'mappings',
        subBuilder: TransformMapping.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TransformNodeConfig clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TransformNodeConfig copyWith(void Function(TransformNodeConfig) updates) =>
      super.copyWith((message) => updates(message as TransformNodeConfig))
          as TransformNodeConfig;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core
      .Deprecated('Use TransformNodeConfig() / TransformNodeConfig.new instead')
  static TransformNodeConfig create() => TransformNodeConfig._();
  static $pb.GeneratedMessage $_createMessage() => TransformNodeConfig._();
  @$core.override
  TransformNodeConfig createEmptyInstance() => TransformNodeConfig._();
  @$core.pragma('dart2js:noInline')
  static TransformNodeConfig getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<TransformNodeConfig>(
          TransformNodeConfig.$_createMessage);
  static TransformNodeConfig? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<TransformMapping> get mappings => $_getList(0);
}

class ActionNodeConfig extends $pb.GeneratedMessage {
  factory ActionNodeConfig({
    $core.String? rpcName,
    $core.String? inputJson,
    $core.int? timeoutSeconds,
    $core.int? maxRetries,
    $core.int? backoffSeconds,
  }) {
    final result = ActionNodeConfig._();
    if (rpcName != null) result.rpcName = rpcName;
    if (inputJson != null) result.inputJson = inputJson;
    if (timeoutSeconds != null) result.timeoutSeconds = timeoutSeconds;
    if (maxRetries != null) result.maxRetries = maxRetries;
    if (backoffSeconds != null) result.backoffSeconds = backoffSeconds;
    return result;
  }

  ActionNodeConfig._();

  factory ActionNodeConfig.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ActionNodeConfig()..mergeFromBuffer(data, registry);
  factory ActionNodeConfig.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ActionNodeConfig()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ActionNodeConfig',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.automation.v1'),
      createEmptyInstance: ActionNodeConfig.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'rpcName')
    ..aOS(2, _omitFieldNames ? '' : 'inputJson')
    ..aI(3, _omitFieldNames ? '' : 'timeoutSeconds')
    ..aI(4, _omitFieldNames ? '' : 'maxRetries')
    ..aI(5, _omitFieldNames ? '' : 'backoffSeconds')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ActionNodeConfig clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ActionNodeConfig copyWith(void Function(ActionNodeConfig) updates) =>
      super.copyWith((message) => updates(message as ActionNodeConfig))
          as ActionNodeConfig;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ActionNodeConfig() / ActionNodeConfig.new instead')
  static ActionNodeConfig create() => ActionNodeConfig._();
  static $pb.GeneratedMessage $_createMessage() => ActionNodeConfig._();
  @$core.override
  ActionNodeConfig createEmptyInstance() => ActionNodeConfig._();
  @$core.pragma('dart2js:noInline')
  static ActionNodeConfig getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ActionNodeConfig>(
          ActionNodeConfig.$_createMessage);
  static ActionNodeConfig? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get rpcName => $_getSZ(0);
  @$pb.TagNumber(1)
  set rpcName($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRpcName() => $_has(0);
  @$pb.TagNumber(1)
  void clearRpcName() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get inputJson => $_getSZ(1);
  @$pb.TagNumber(2)
  set inputJson($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasInputJson() => $_has(1);
  @$pb.TagNumber(2)
  void clearInputJson() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get timeoutSeconds => $_getIZ(2);
  @$pb.TagNumber(3)
  set timeoutSeconds($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasTimeoutSeconds() => $_has(2);
  @$pb.TagNumber(3)
  void clearTimeoutSeconds() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get maxRetries => $_getIZ(3);
  @$pb.TagNumber(4)
  set maxRetries($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasMaxRetries() => $_has(3);
  @$pb.TagNumber(4)
  void clearMaxRetries() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get backoffSeconds => $_getIZ(4);
  @$pb.TagNumber(5)
  set backoffSeconds($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasBackoffSeconds() => $_has(4);
  @$pb.TagNumber(5)
  void clearBackoffSeconds() => $_clearField(5);
}

class ApprovalNodeConfig extends $pb.GeneratedMessage {
  factory ApprovalNodeConfig({
    $core.Iterable<$core.String>? approverIds,
    $core.int? requiredApprovals,
    $fixnum.Int64? expiresAtDurationSeconds,
    $core.String? autoActionOnTimeout,
  }) {
    final result = ApprovalNodeConfig._();
    if (approverIds != null) result.approverIds.addAll(approverIds);
    if (requiredApprovals != null) result.requiredApprovals = requiredApprovals;
    if (expiresAtDurationSeconds != null)
      result.expiresAtDurationSeconds = expiresAtDurationSeconds;
    if (autoActionOnTimeout != null)
      result.autoActionOnTimeout = autoActionOnTimeout;
    return result;
  }

  ApprovalNodeConfig._();

  factory ApprovalNodeConfig.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ApprovalNodeConfig()..mergeFromBuffer(data, registry);
  factory ApprovalNodeConfig.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ApprovalNodeConfig()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ApprovalNodeConfig',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.automation.v1'),
      createEmptyInstance: ApprovalNodeConfig.$_createMessage)
    ..pPS(1, _omitFieldNames ? '' : 'approverIds')
    ..aI(2, _omitFieldNames ? '' : 'requiredApprovals')
    ..aInt64(3, _omitFieldNames ? '' : 'expiresAtDurationSeconds')
    ..aOS(4, _omitFieldNames ? '' : 'autoActionOnTimeout')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ApprovalNodeConfig clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ApprovalNodeConfig copyWith(void Function(ApprovalNodeConfig) updates) =>
      super.copyWith((message) => updates(message as ApprovalNodeConfig))
          as ApprovalNodeConfig;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ApprovalNodeConfig() / ApprovalNodeConfig.new instead')
  static ApprovalNodeConfig create() => ApprovalNodeConfig._();
  static $pb.GeneratedMessage $_createMessage() => ApprovalNodeConfig._();
  @$core.override
  ApprovalNodeConfig createEmptyInstance() => ApprovalNodeConfig._();
  @$core.pragma('dart2js:noInline')
  static ApprovalNodeConfig getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ApprovalNodeConfig>(
          ApprovalNodeConfig.$_createMessage);
  static ApprovalNodeConfig? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<$core.String> get approverIds => $_getList(0);

  @$pb.TagNumber(2)
  $core.int get requiredApprovals => $_getIZ(1);
  @$pb.TagNumber(2)
  set requiredApprovals($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasRequiredApprovals() => $_has(1);
  @$pb.TagNumber(2)
  void clearRequiredApprovals() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get expiresAtDurationSeconds => $_getI64(2);
  @$pb.TagNumber(3)
  set expiresAtDurationSeconds($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasExpiresAtDurationSeconds() => $_has(2);
  @$pb.TagNumber(3)
  void clearExpiresAtDurationSeconds() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get autoActionOnTimeout => $_getSZ(3);
  @$pb.TagNumber(4)
  set autoActionOnTimeout($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasAutoActionOnTimeout() => $_has(3);
  @$pb.TagNumber(4)
  void clearAutoActionOnTimeout() => $_clearField(4);
}

class WaitNodeConfig extends $pb.GeneratedMessage {
  factory WaitNodeConfig({
    $core.String? waitType,
    $fixnum.Int64? durationSeconds,
    $core.String? resumeCondition,
    $core.String? untilTimestamp,
  }) {
    final result = WaitNodeConfig._();
    if (waitType != null) result.waitType = waitType;
    if (durationSeconds != null) result.durationSeconds = durationSeconds;
    if (resumeCondition != null) result.resumeCondition = resumeCondition;
    if (untilTimestamp != null) result.untilTimestamp = untilTimestamp;
    return result;
  }

  WaitNodeConfig._();

  factory WaitNodeConfig.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      WaitNodeConfig()..mergeFromBuffer(data, registry);
  factory WaitNodeConfig.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      WaitNodeConfig()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'WaitNodeConfig',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.automation.v1'),
      createEmptyInstance: WaitNodeConfig.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'waitType')
    ..aInt64(2, _omitFieldNames ? '' : 'durationSeconds')
    ..aOS(3, _omitFieldNames ? '' : 'resumeCondition')
    ..aOS(4, _omitFieldNames ? '' : 'untilTimestamp')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WaitNodeConfig clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WaitNodeConfig copyWith(void Function(WaitNodeConfig) updates) =>
      super.copyWith((message) => updates(message as WaitNodeConfig))
          as WaitNodeConfig;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use WaitNodeConfig() / WaitNodeConfig.new instead')
  static WaitNodeConfig create() => WaitNodeConfig._();
  static $pb.GeneratedMessage $_createMessage() => WaitNodeConfig._();
  @$core.override
  WaitNodeConfig createEmptyInstance() => WaitNodeConfig._();
  @$core.pragma('dart2js:noInline')
  static WaitNodeConfig getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<WaitNodeConfig>(
          WaitNodeConfig.$_createMessage);
  static WaitNodeConfig? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get waitType => $_getSZ(0);
  @$pb.TagNumber(1)
  set waitType($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWaitType() => $_has(0);
  @$pb.TagNumber(1)
  void clearWaitType() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get durationSeconds => $_getI64(1);
  @$pb.TagNumber(2)
  set durationSeconds($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasDurationSeconds() => $_has(1);
  @$pb.TagNumber(2)
  void clearDurationSeconds() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get resumeCondition => $_getSZ(2);
  @$pb.TagNumber(3)
  set resumeCondition($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasResumeCondition() => $_has(2);
  @$pb.TagNumber(3)
  void clearResumeCondition() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get untilTimestamp => $_getSZ(3);
  @$pb.TagNumber(4)
  set untilTimestamp($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasUntilTimestamp() => $_has(3);
  @$pb.TagNumber(4)
  void clearUntilTimestamp() => $_clearField(4);
}

class FallbackNodeConfig extends $pb.GeneratedMessage {
  factory FallbackNodeConfig({
    $core.String? fallbackNodeId,
    $core.String? reasonTemplate,
    $core.String? logLevel,
  }) {
    final result = FallbackNodeConfig._();
    if (fallbackNodeId != null) result.fallbackNodeId = fallbackNodeId;
    if (reasonTemplate != null) result.reasonTemplate = reasonTemplate;
    if (logLevel != null) result.logLevel = logLevel;
    return result;
  }

  FallbackNodeConfig._();

  factory FallbackNodeConfig.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      FallbackNodeConfig()..mergeFromBuffer(data, registry);
  factory FallbackNodeConfig.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      FallbackNodeConfig()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'FallbackNodeConfig',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.automation.v1'),
      createEmptyInstance: FallbackNodeConfig.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'fallbackNodeId')
    ..aOS(2, _omitFieldNames ? '' : 'reasonTemplate')
    ..aOS(3, _omitFieldNames ? '' : 'logLevel')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FallbackNodeConfig clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FallbackNodeConfig copyWith(void Function(FallbackNodeConfig) updates) =>
      super.copyWith((message) => updates(message as FallbackNodeConfig))
          as FallbackNodeConfig;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use FallbackNodeConfig() / FallbackNodeConfig.new instead')
  static FallbackNodeConfig create() => FallbackNodeConfig._();
  static $pb.GeneratedMessage $_createMessage() => FallbackNodeConfig._();
  @$core.override
  FallbackNodeConfig createEmptyInstance() => FallbackNodeConfig._();
  @$core.pragma('dart2js:noInline')
  static FallbackNodeConfig getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<FallbackNodeConfig>(
          FallbackNodeConfig.$_createMessage);
  static FallbackNodeConfig? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get fallbackNodeId => $_getSZ(0);
  @$pb.TagNumber(1)
  set fallbackNodeId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasFallbackNodeId() => $_has(0);
  @$pb.TagNumber(1)
  void clearFallbackNodeId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get reasonTemplate => $_getSZ(1);
  @$pb.TagNumber(2)
  set reasonTemplate($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasReasonTemplate() => $_has(1);
  @$pb.TagNumber(2)
  void clearReasonTemplate() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get logLevel => $_getSZ(2);
  @$pb.TagNumber(3)
  set logLevel($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasLogLevel() => $_has(2);
  @$pb.TagNumber(3)
  void clearLogLevel() => $_clearField(3);
}

class DiagnosticsNodeConfig extends $pb.GeneratedMessage {
  factory DiagnosticsNodeConfig({
    $core.String? severity,
    $core.String? userMessage,
    $core.String? operatorMessage,
    $core.String? recommendedNextStep,
  }) {
    final result = DiagnosticsNodeConfig._();
    if (severity != null) result.severity = severity;
    if (userMessage != null) result.userMessage = userMessage;
    if (operatorMessage != null) result.operatorMessage = operatorMessage;
    if (recommendedNextStep != null)
      result.recommendedNextStep = recommendedNextStep;
    return result;
  }

  DiagnosticsNodeConfig._();

  factory DiagnosticsNodeConfig.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      DiagnosticsNodeConfig()..mergeFromBuffer(data, registry);
  factory DiagnosticsNodeConfig.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      DiagnosticsNodeConfig()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DiagnosticsNodeConfig',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.automation.v1'),
      createEmptyInstance: DiagnosticsNodeConfig.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'severity')
    ..aOS(2, _omitFieldNames ? '' : 'userMessage')
    ..aOS(3, _omitFieldNames ? '' : 'operatorMessage')
    ..aOS(4, _omitFieldNames ? '' : 'recommendedNextStep')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DiagnosticsNodeConfig clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DiagnosticsNodeConfig copyWith(
          void Function(DiagnosticsNodeConfig) updates) =>
      super.copyWith((message) => updates(message as DiagnosticsNodeConfig))
          as DiagnosticsNodeConfig;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use DiagnosticsNodeConfig() / DiagnosticsNodeConfig.new instead')
  static DiagnosticsNodeConfig create() => DiagnosticsNodeConfig._();
  static $pb.GeneratedMessage $_createMessage() => DiagnosticsNodeConfig._();
  @$core.override
  DiagnosticsNodeConfig createEmptyInstance() => DiagnosticsNodeConfig._();
  @$core.pragma('dart2js:noInline')
  static DiagnosticsNodeConfig getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DiagnosticsNodeConfig>(
          DiagnosticsNodeConfig.$_createMessage);
  static DiagnosticsNodeConfig? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get severity => $_getSZ(0);
  @$pb.TagNumber(1)
  set severity($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSeverity() => $_has(0);
  @$pb.TagNumber(1)
  void clearSeverity() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get userMessage => $_getSZ(1);
  @$pb.TagNumber(2)
  set userMessage($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasUserMessage() => $_has(1);
  @$pb.TagNumber(2)
  void clearUserMessage() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get operatorMessage => $_getSZ(2);
  @$pb.TagNumber(3)
  set operatorMessage($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasOperatorMessage() => $_has(2);
  @$pb.TagNumber(3)
  void clearOperatorMessage() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get recommendedNextStep => $_getSZ(3);
  @$pb.TagNumber(4)
  set recommendedNextStep($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasRecommendedNextStep() => $_has(3);
  @$pb.TagNumber(4)
  void clearRecommendedNextStep() => $_clearField(4);
}

class HandoffNodeConfig extends $pb.GeneratedMessage {
  factory HandoffNodeConfig({
    $core.String? targetUserId,
    $core.String? targetRole,
    $core.String? contextNote,
  }) {
    final result = HandoffNodeConfig._();
    if (targetUserId != null) result.targetUserId = targetUserId;
    if (targetRole != null) result.targetRole = targetRole;
    if (contextNote != null) result.contextNote = contextNote;
    return result;
  }

  HandoffNodeConfig._();

  factory HandoffNodeConfig.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      HandoffNodeConfig()..mergeFromBuffer(data, registry);
  factory HandoffNodeConfig.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      HandoffNodeConfig()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'HandoffNodeConfig',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.automation.v1'),
      createEmptyInstance: HandoffNodeConfig.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'targetUserId')
    ..aOS(2, _omitFieldNames ? '' : 'targetRole')
    ..aOS(3, _omitFieldNames ? '' : 'contextNote')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  HandoffNodeConfig clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  HandoffNodeConfig copyWith(void Function(HandoffNodeConfig) updates) =>
      super.copyWith((message) => updates(message as HandoffNodeConfig))
          as HandoffNodeConfig;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use HandoffNodeConfig() / HandoffNodeConfig.new instead')
  static HandoffNodeConfig create() => HandoffNodeConfig._();
  static $pb.GeneratedMessage $_createMessage() => HandoffNodeConfig._();
  @$core.override
  HandoffNodeConfig createEmptyInstance() => HandoffNodeConfig._();
  @$core.pragma('dart2js:noInline')
  static HandoffNodeConfig getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<HandoffNodeConfig>(
          HandoffNodeConfig.$_createMessage);
  static HandoffNodeConfig? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get targetUserId => $_getSZ(0);
  @$pb.TagNumber(1)
  set targetUserId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTargetUserId() => $_has(0);
  @$pb.TagNumber(1)
  void clearTargetUserId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get targetRole => $_getSZ(1);
  @$pb.TagNumber(2)
  set targetRole($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTargetRole() => $_has(1);
  @$pb.TagNumber(2)
  void clearTargetRole() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get contextNote => $_getSZ(2);
  @$pb.TagNumber(3)
  set contextNote($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasContextNote() => $_has(2);
  @$pb.TagNumber(3)
  void clearContextNote() => $_clearField(3);
}

class TerminalNodeConfig extends $pb.GeneratedMessage {
  factory TerminalNodeConfig({
    $core.String? outcome,
    $core.String? resultTemplate,
  }) {
    final result = TerminalNodeConfig._();
    if (outcome != null) result.outcome = outcome;
    if (resultTemplate != null) result.resultTemplate = resultTemplate;
    return result;
  }

  TerminalNodeConfig._();

  factory TerminalNodeConfig.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      TerminalNodeConfig()..mergeFromBuffer(data, registry);
  factory TerminalNodeConfig.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      TerminalNodeConfig()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TerminalNodeConfig',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.automation.v1'),
      createEmptyInstance: TerminalNodeConfig.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'outcome')
    ..aOS(2, _omitFieldNames ? '' : 'resultTemplate')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TerminalNodeConfig clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TerminalNodeConfig copyWith(void Function(TerminalNodeConfig) updates) =>
      super.copyWith((message) => updates(message as TerminalNodeConfig))
          as TerminalNodeConfig;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use TerminalNodeConfig() / TerminalNodeConfig.new instead')
  static TerminalNodeConfig create() => TerminalNodeConfig._();
  static $pb.GeneratedMessage $_createMessage() => TerminalNodeConfig._();
  @$core.override
  TerminalNodeConfig createEmptyInstance() => TerminalNodeConfig._();
  @$core.pragma('dart2js:noInline')
  static TerminalNodeConfig getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<TerminalNodeConfig>(
          TerminalNodeConfig.$_createMessage);
  static TerminalNodeConfig? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get outcome => $_getSZ(0);
  @$pb.TagNumber(1)
  set outcome($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasOutcome() => $_has(0);
  @$pb.TagNumber(1)
  void clearOutcome() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get resultTemplate => $_getSZ(1);
  @$pb.TagNumber(2)
  set resultTemplate($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasResultTemplate() => $_has(1);
  @$pb.TagNumber(2)
  void clearResultTemplate() => $_clearField(2);
}

enum WorkflowNode_Config {
  triggerConfig,
  conditionConfig,
  transformConfig,
  actionConfig,
  approvalConfig,
  waitConfig,
  fallbackConfig,
  diagnosticsConfig,
  handoffConfig,
  terminalConfig,
  notSet
}

class WorkflowNode extends $pb.GeneratedMessage {
  factory WorkflowNode({
    $core.String? nodeId,
    NodeType? nodeType,
    $core.String? title,
    $core.String? description,
    TriggerNodeConfig? triggerConfig,
    ConditionNodeConfig? conditionConfig,
    TransformNodeConfig? transformConfig,
    ActionNodeConfig? actionConfig,
    ApprovalNodeConfig? approvalConfig,
    WaitNodeConfig? waitConfig,
    FallbackNodeConfig? fallbackConfig,
    DiagnosticsNodeConfig? diagnosticsConfig,
    HandoffNodeConfig? handoffConfig,
    TerminalNodeConfig? terminalConfig,
    $core.String? rawConfigJson,
  }) {
    final result = WorkflowNode._();
    if (nodeId != null) result.nodeId = nodeId;
    if (nodeType != null) result.nodeType = nodeType;
    if (title != null) result.title = title;
    if (description != null) result.description = description;
    if (triggerConfig != null) result.triggerConfig = triggerConfig;
    if (conditionConfig != null) result.conditionConfig = conditionConfig;
    if (transformConfig != null) result.transformConfig = transformConfig;
    if (actionConfig != null) result.actionConfig = actionConfig;
    if (approvalConfig != null) result.approvalConfig = approvalConfig;
    if (waitConfig != null) result.waitConfig = waitConfig;
    if (fallbackConfig != null) result.fallbackConfig = fallbackConfig;
    if (diagnosticsConfig != null) result.diagnosticsConfig = diagnosticsConfig;
    if (handoffConfig != null) result.handoffConfig = handoffConfig;
    if (terminalConfig != null) result.terminalConfig = terminalConfig;
    if (rawConfigJson != null) result.rawConfigJson = rawConfigJson;
    return result;
  }

  WorkflowNode._();

  factory WorkflowNode.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      WorkflowNode()..mergeFromBuffer(data, registry);
  factory WorkflowNode.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      WorkflowNode()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, WorkflowNode_Config>
      _WorkflowNode_ConfigByTag = {
    5: WorkflowNode_Config.triggerConfig,
    6: WorkflowNode_Config.conditionConfig,
    7: WorkflowNode_Config.transformConfig,
    8: WorkflowNode_Config.actionConfig,
    9: WorkflowNode_Config.approvalConfig,
    10: WorkflowNode_Config.waitConfig,
    11: WorkflowNode_Config.fallbackConfig,
    12: WorkflowNode_Config.diagnosticsConfig,
    13: WorkflowNode_Config.handoffConfig,
    14: WorkflowNode_Config.terminalConfig,
    0: WorkflowNode_Config.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'WorkflowNode',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.automation.v1'),
      createEmptyInstance: WorkflowNode.$_createMessage)
    ..oo(0, [5, 6, 7, 8, 9, 10, 11, 12, 13, 14])
    ..aOS(1, _omitFieldNames ? '' : 'nodeId')
    ..aE<NodeType>(2, _omitFieldNames ? '' : 'nodeType',
        enumValues: NodeType.values)
    ..aOS(3, _omitFieldNames ? '' : 'title')
    ..aOS(4, _omitFieldNames ? '' : 'description')
    ..aOM<TriggerNodeConfig>(5, _omitFieldNames ? '' : 'triggerConfig',
        subBuilder: TriggerNodeConfig.$_createMessage)
    ..aOM<ConditionNodeConfig>(6, _omitFieldNames ? '' : 'conditionConfig',
        subBuilder: ConditionNodeConfig.$_createMessage)
    ..aOM<TransformNodeConfig>(7, _omitFieldNames ? '' : 'transformConfig',
        subBuilder: TransformNodeConfig.$_createMessage)
    ..aOM<ActionNodeConfig>(8, _omitFieldNames ? '' : 'actionConfig',
        subBuilder: ActionNodeConfig.$_createMessage)
    ..aOM<ApprovalNodeConfig>(9, _omitFieldNames ? '' : 'approvalConfig',
        subBuilder: ApprovalNodeConfig.$_createMessage)
    ..aOM<WaitNodeConfig>(10, _omitFieldNames ? '' : 'waitConfig',
        subBuilder: WaitNodeConfig.$_createMessage)
    ..aOM<FallbackNodeConfig>(11, _omitFieldNames ? '' : 'fallbackConfig',
        subBuilder: FallbackNodeConfig.$_createMessage)
    ..aOM<DiagnosticsNodeConfig>(12, _omitFieldNames ? '' : 'diagnosticsConfig',
        subBuilder: DiagnosticsNodeConfig.$_createMessage)
    ..aOM<HandoffNodeConfig>(13, _omitFieldNames ? '' : 'handoffConfig',
        subBuilder: HandoffNodeConfig.$_createMessage)
    ..aOM<TerminalNodeConfig>(14, _omitFieldNames ? '' : 'terminalConfig',
        subBuilder: TerminalNodeConfig.$_createMessage)
    ..aOS(15, _omitFieldNames ? '' : 'rawConfigJson')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WorkflowNode clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WorkflowNode copyWith(void Function(WorkflowNode) updates) =>
      super.copyWith((message) => updates(message as WorkflowNode))
          as WorkflowNode;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use WorkflowNode() / WorkflowNode.new instead')
  static WorkflowNode create() => WorkflowNode._();
  static $pb.GeneratedMessage $_createMessage() => WorkflowNode._();
  @$core.override
  WorkflowNode createEmptyInstance() => WorkflowNode._();
  @$core.pragma('dart2js:noInline')
  static WorkflowNode getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<WorkflowNode>(
          WorkflowNode.$_createMessage);
  static WorkflowNode? _defaultInstance;

  @$pb.TagNumber(5)
  @$pb.TagNumber(6)
  @$pb.TagNumber(7)
  @$pb.TagNumber(8)
  @$pb.TagNumber(9)
  @$pb.TagNumber(10)
  @$pb.TagNumber(11)
  @$pb.TagNumber(12)
  @$pb.TagNumber(13)
  @$pb.TagNumber(14)
  WorkflowNode_Config whichConfig() =>
      _WorkflowNode_ConfigByTag[$_whichOneof(0)]!;
  @$pb.TagNumber(5)
  @$pb.TagNumber(6)
  @$pb.TagNumber(7)
  @$pb.TagNumber(8)
  @$pb.TagNumber(9)
  @$pb.TagNumber(10)
  @$pb.TagNumber(11)
  @$pb.TagNumber(12)
  @$pb.TagNumber(13)
  @$pb.TagNumber(14)
  void clearConfig() => $_clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  $core.String get nodeId => $_getSZ(0);
  @$pb.TagNumber(1)
  set nodeId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasNodeId() => $_has(0);
  @$pb.TagNumber(1)
  void clearNodeId() => $_clearField(1);

  @$pb.TagNumber(2)
  NodeType get nodeType => $_getN(1);
  @$pb.TagNumber(2)
  set nodeType(NodeType value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasNodeType() => $_has(1);
  @$pb.TagNumber(2)
  void clearNodeType() => $_clearField(2);

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
  TriggerNodeConfig get triggerConfig => $_getN(4);
  @$pb.TagNumber(5)
  set triggerConfig(TriggerNodeConfig value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasTriggerConfig() => $_has(4);
  @$pb.TagNumber(5)
  void clearTriggerConfig() => $_clearField(5);
  @$pb.TagNumber(5)
  TriggerNodeConfig ensureTriggerConfig() => $_ensure(4);

  @$pb.TagNumber(6)
  ConditionNodeConfig get conditionConfig => $_getN(5);
  @$pb.TagNumber(6)
  set conditionConfig(ConditionNodeConfig value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasConditionConfig() => $_has(5);
  @$pb.TagNumber(6)
  void clearConditionConfig() => $_clearField(6);
  @$pb.TagNumber(6)
  ConditionNodeConfig ensureConditionConfig() => $_ensure(5);

  @$pb.TagNumber(7)
  TransformNodeConfig get transformConfig => $_getN(6);
  @$pb.TagNumber(7)
  set transformConfig(TransformNodeConfig value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasTransformConfig() => $_has(6);
  @$pb.TagNumber(7)
  void clearTransformConfig() => $_clearField(7);
  @$pb.TagNumber(7)
  TransformNodeConfig ensureTransformConfig() => $_ensure(6);

  @$pb.TagNumber(8)
  ActionNodeConfig get actionConfig => $_getN(7);
  @$pb.TagNumber(8)
  set actionConfig(ActionNodeConfig value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasActionConfig() => $_has(7);
  @$pb.TagNumber(8)
  void clearActionConfig() => $_clearField(8);
  @$pb.TagNumber(8)
  ActionNodeConfig ensureActionConfig() => $_ensure(7);

  @$pb.TagNumber(9)
  ApprovalNodeConfig get approvalConfig => $_getN(8);
  @$pb.TagNumber(9)
  set approvalConfig(ApprovalNodeConfig value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasApprovalConfig() => $_has(8);
  @$pb.TagNumber(9)
  void clearApprovalConfig() => $_clearField(9);
  @$pb.TagNumber(9)
  ApprovalNodeConfig ensureApprovalConfig() => $_ensure(8);

  @$pb.TagNumber(10)
  WaitNodeConfig get waitConfig => $_getN(9);
  @$pb.TagNumber(10)
  set waitConfig(WaitNodeConfig value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasWaitConfig() => $_has(9);
  @$pb.TagNumber(10)
  void clearWaitConfig() => $_clearField(10);
  @$pb.TagNumber(10)
  WaitNodeConfig ensureWaitConfig() => $_ensure(9);

  @$pb.TagNumber(11)
  FallbackNodeConfig get fallbackConfig => $_getN(10);
  @$pb.TagNumber(11)
  set fallbackConfig(FallbackNodeConfig value) => $_setField(11, value);
  @$pb.TagNumber(11)
  $core.bool hasFallbackConfig() => $_has(10);
  @$pb.TagNumber(11)
  void clearFallbackConfig() => $_clearField(11);
  @$pb.TagNumber(11)
  FallbackNodeConfig ensureFallbackConfig() => $_ensure(10);

  @$pb.TagNumber(12)
  DiagnosticsNodeConfig get diagnosticsConfig => $_getN(11);
  @$pb.TagNumber(12)
  set diagnosticsConfig(DiagnosticsNodeConfig value) => $_setField(12, value);
  @$pb.TagNumber(12)
  $core.bool hasDiagnosticsConfig() => $_has(11);
  @$pb.TagNumber(12)
  void clearDiagnosticsConfig() => $_clearField(12);
  @$pb.TagNumber(12)
  DiagnosticsNodeConfig ensureDiagnosticsConfig() => $_ensure(11);

  @$pb.TagNumber(13)
  HandoffNodeConfig get handoffConfig => $_getN(12);
  @$pb.TagNumber(13)
  set handoffConfig(HandoffNodeConfig value) => $_setField(13, value);
  @$pb.TagNumber(13)
  $core.bool hasHandoffConfig() => $_has(12);
  @$pb.TagNumber(13)
  void clearHandoffConfig() => $_clearField(13);
  @$pb.TagNumber(13)
  HandoffNodeConfig ensureHandoffConfig() => $_ensure(12);

  @$pb.TagNumber(14)
  TerminalNodeConfig get terminalConfig => $_getN(13);
  @$pb.TagNumber(14)
  set terminalConfig(TerminalNodeConfig value) => $_setField(14, value);
  @$pb.TagNumber(14)
  $core.bool hasTerminalConfig() => $_has(13);
  @$pb.TagNumber(14)
  void clearTerminalConfig() => $_clearField(14);
  @$pb.TagNumber(14)
  TerminalNodeConfig ensureTerminalConfig() => $_ensure(13);

  @$pb.TagNumber(15)
  $core.String get rawConfigJson => $_getSZ(14);
  @$pb.TagNumber(15)
  set rawConfigJson($core.String value) => $_setString(14, value);
  @$pb.TagNumber(15)
  $core.bool hasRawConfigJson() => $_has(14);
  @$pb.TagNumber(15)
  void clearRawConfigJson() => $_clearField(15);
}

class WorkflowEdge extends $pb.GeneratedMessage {
  factory WorkflowEdge({
    $core.String? fromNodeId,
    $core.String? toNodeId,
    EdgeBranch? branch,
  }) {
    final result = WorkflowEdge._();
    if (fromNodeId != null) result.fromNodeId = fromNodeId;
    if (toNodeId != null) result.toNodeId = toNodeId;
    if (branch != null) result.branch = branch;
    return result;
  }

  WorkflowEdge._();

  factory WorkflowEdge.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      WorkflowEdge()..mergeFromBuffer(data, registry);
  factory WorkflowEdge.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      WorkflowEdge()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'WorkflowEdge',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.automation.v1'),
      createEmptyInstance: WorkflowEdge.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'fromNodeId')
    ..aOS(2, _omitFieldNames ? '' : 'toNodeId')
    ..aE<EdgeBranch>(3, _omitFieldNames ? '' : 'branch',
        enumValues: EdgeBranch.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WorkflowEdge clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WorkflowEdge copyWith(void Function(WorkflowEdge) updates) =>
      super.copyWith((message) => updates(message as WorkflowEdge))
          as WorkflowEdge;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use WorkflowEdge() / WorkflowEdge.new instead')
  static WorkflowEdge create() => WorkflowEdge._();
  static $pb.GeneratedMessage $_createMessage() => WorkflowEdge._();
  @$core.override
  WorkflowEdge createEmptyInstance() => WorkflowEdge._();
  @$core.pragma('dart2js:noInline')
  static WorkflowEdge getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<WorkflowEdge>(
          WorkflowEdge.$_createMessage);
  static WorkflowEdge? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get fromNodeId => $_getSZ(0);
  @$pb.TagNumber(1)
  set fromNodeId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasFromNodeId() => $_has(0);
  @$pb.TagNumber(1)
  void clearFromNodeId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get toNodeId => $_getSZ(1);
  @$pb.TagNumber(2)
  set toNodeId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasToNodeId() => $_has(1);
  @$pb.TagNumber(2)
  void clearToNodeId() => $_clearField(2);

  @$pb.TagNumber(3)
  EdgeBranch get branch => $_getN(2);
  @$pb.TagNumber(3)
  set branch(EdgeBranch value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasBranch() => $_has(2);
  @$pb.TagNumber(3)
  void clearBranch() => $_clearField(3);
}

class WorkflowGraph extends $pb.GeneratedMessage {
  factory WorkflowGraph({
    $core.int? schemaVersion,
    $core.Iterable<WorkflowNode>? nodes,
    $core.Iterable<WorkflowEdge>? edges,
  }) {
    final result = WorkflowGraph._();
    if (schemaVersion != null) result.schemaVersion = schemaVersion;
    if (nodes != null) result.nodes.addAll(nodes);
    if (edges != null) result.edges.addAll(edges);
    return result;
  }

  WorkflowGraph._();

  factory WorkflowGraph.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      WorkflowGraph()..mergeFromBuffer(data, registry);
  factory WorkflowGraph.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      WorkflowGraph()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'WorkflowGraph',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.automation.v1'),
      createEmptyInstance: WorkflowGraph.$_createMessage)
    ..aI(1, _omitFieldNames ? '' : 'schemaVersion')
    ..pPM<WorkflowNode>(2, _omitFieldNames ? '' : 'nodes',
        subBuilder: WorkflowNode.$_createMessage)
    ..pPM<WorkflowEdge>(3, _omitFieldNames ? '' : 'edges',
        subBuilder: WorkflowEdge.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WorkflowGraph clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WorkflowGraph copyWith(void Function(WorkflowGraph) updates) =>
      super.copyWith((message) => updates(message as WorkflowGraph))
          as WorkflowGraph;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use WorkflowGraph() / WorkflowGraph.new instead')
  static WorkflowGraph create() => WorkflowGraph._();
  static $pb.GeneratedMessage $_createMessage() => WorkflowGraph._();
  @$core.override
  WorkflowGraph createEmptyInstance() => WorkflowGraph._();
  @$core.pragma('dart2js:noInline')
  static WorkflowGraph getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<WorkflowGraph>(
          WorkflowGraph.$_createMessage);
  static WorkflowGraph? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get schemaVersion => $_getIZ(0);
  @$pb.TagNumber(1)
  set schemaVersion($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSchemaVersion() => $_has(0);
  @$pb.TagNumber(1)
  void clearSchemaVersion() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbList<WorkflowNode> get nodes => $_getList(1);

  @$pb.TagNumber(3)
  $pb.PbList<WorkflowEdge> get edges => $_getList(2);
}

class Workflow extends $pb.GeneratedMessage {
  factory Workflow({
    $core.String? workflowId,
    $core.String? workspaceId,
    $core.String? title,
    $core.String? description,
    $core.String? workflowType,
    WorkflowStatus? status,
    $core.int? version,
    TriggerConfig? triggerConfig,
    WorkflowGraph? actionChain,
    $core.String? actionChainJson,
    $core.String? approvalRequirementsJson,
    $core.String? activepiecesFlowId,
    $core.bool? tierLimitCheck,
    $core.int? runCount,
    $core.String? createdBy,
    $1.Timestamp? createdAt,
    $1.Timestamp? updatedAt,
  }) {
    final result = Workflow._();
    if (workflowId != null) result.workflowId = workflowId;
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (title != null) result.title = title;
    if (description != null) result.description = description;
    if (workflowType != null) result.workflowType = workflowType;
    if (status != null) result.status = status;
    if (version != null) result.version = version;
    if (triggerConfig != null) result.triggerConfig = triggerConfig;
    if (actionChain != null) result.actionChain = actionChain;
    if (actionChainJson != null) result.actionChainJson = actionChainJson;
    if (approvalRequirementsJson != null)
      result.approvalRequirementsJson = approvalRequirementsJson;
    if (activepiecesFlowId != null)
      result.activepiecesFlowId = activepiecesFlowId;
    if (tierLimitCheck != null) result.tierLimitCheck = tierLimitCheck;
    if (runCount != null) result.runCount = runCount;
    if (createdBy != null) result.createdBy = createdBy;
    if (createdAt != null) result.createdAt = createdAt;
    if (updatedAt != null) result.updatedAt = updatedAt;
    return result;
  }

  Workflow._();

  factory Workflow.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Workflow()..mergeFromBuffer(data, registry);
  factory Workflow.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      Workflow()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Workflow',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.automation.v1'),
      createEmptyInstance: Workflow.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workflowId')
    ..aOS(2, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(3, _omitFieldNames ? '' : 'title')
    ..aOS(4, _omitFieldNames ? '' : 'description')
    ..aOS(5, _omitFieldNames ? '' : 'workflowType')
    ..aE<WorkflowStatus>(6, _omitFieldNames ? '' : 'status',
        enumValues: WorkflowStatus.values)
    ..aI(7, _omitFieldNames ? '' : 'version')
    ..aOM<TriggerConfig>(8, _omitFieldNames ? '' : 'triggerConfig',
        subBuilder: TriggerConfig.$_createMessage)
    ..aOM<WorkflowGraph>(9, _omitFieldNames ? '' : 'actionChain',
        subBuilder: WorkflowGraph.$_createMessage)
    ..aOS(10, _omitFieldNames ? '' : 'actionChainJson')
    ..aOS(11, _omitFieldNames ? '' : 'approvalRequirementsJson')
    ..aOS(12, _omitFieldNames ? '' : 'activepiecesFlowId')
    ..aOB(13, _omitFieldNames ? '' : 'tierLimitCheck')
    ..aI(14, _omitFieldNames ? '' : 'runCount')
    ..aOS(15, _omitFieldNames ? '' : 'createdBy')
    ..aOM<$1.Timestamp>(16, _omitFieldNames ? '' : 'createdAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..aOM<$1.Timestamp>(17, _omitFieldNames ? '' : 'updatedAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Workflow clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Workflow copyWith(void Function(Workflow) updates) =>
      super.copyWith((message) => updates(message as Workflow)) as Workflow;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use Workflow() / Workflow.new instead')
  static Workflow create() => Workflow._();
  static $pb.GeneratedMessage $_createMessage() => Workflow._();
  @$core.override
  Workflow createEmptyInstance() => Workflow._();
  @$core.pragma('dart2js:noInline')
  static Workflow getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Workflow>(Workflow.$_createMessage);
  static Workflow? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workflowId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workflowId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkflowId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkflowId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get workspaceId => $_getSZ(1);
  @$pb.TagNumber(2)
  set workspaceId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasWorkspaceId() => $_has(1);
  @$pb.TagNumber(2)
  void clearWorkspaceId() => $_clearField(2);

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
  $core.String get workflowType => $_getSZ(4);
  @$pb.TagNumber(5)
  set workflowType($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasWorkflowType() => $_has(4);
  @$pb.TagNumber(5)
  void clearWorkflowType() => $_clearField(5);

  @$pb.TagNumber(6)
  WorkflowStatus get status => $_getN(5);
  @$pb.TagNumber(6)
  set status(WorkflowStatus value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasStatus() => $_has(5);
  @$pb.TagNumber(6)
  void clearStatus() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.int get version => $_getIZ(6);
  @$pb.TagNumber(7)
  set version($core.int value) => $_setSignedInt32(6, value);
  @$pb.TagNumber(7)
  $core.bool hasVersion() => $_has(6);
  @$pb.TagNumber(7)
  void clearVersion() => $_clearField(7);

  @$pb.TagNumber(8)
  TriggerConfig get triggerConfig => $_getN(7);
  @$pb.TagNumber(8)
  set triggerConfig(TriggerConfig value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasTriggerConfig() => $_has(7);
  @$pb.TagNumber(8)
  void clearTriggerConfig() => $_clearField(8);
  @$pb.TagNumber(8)
  TriggerConfig ensureTriggerConfig() => $_ensure(7);

  @$pb.TagNumber(9)
  WorkflowGraph get actionChain => $_getN(8);
  @$pb.TagNumber(9)
  set actionChain(WorkflowGraph value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasActionChain() => $_has(8);
  @$pb.TagNumber(9)
  void clearActionChain() => $_clearField(9);
  @$pb.TagNumber(9)
  WorkflowGraph ensureActionChain() => $_ensure(8);

  @$pb.TagNumber(10)
  $core.String get actionChainJson => $_getSZ(9);
  @$pb.TagNumber(10)
  set actionChainJson($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasActionChainJson() => $_has(9);
  @$pb.TagNumber(10)
  void clearActionChainJson() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.String get approvalRequirementsJson => $_getSZ(10);
  @$pb.TagNumber(11)
  set approvalRequirementsJson($core.String value) => $_setString(10, value);
  @$pb.TagNumber(11)
  $core.bool hasApprovalRequirementsJson() => $_has(10);
  @$pb.TagNumber(11)
  void clearApprovalRequirementsJson() => $_clearField(11);

  @$pb.TagNumber(12)
  $core.String get activepiecesFlowId => $_getSZ(11);
  @$pb.TagNumber(12)
  set activepiecesFlowId($core.String value) => $_setString(11, value);
  @$pb.TagNumber(12)
  $core.bool hasActivepiecesFlowId() => $_has(11);
  @$pb.TagNumber(12)
  void clearActivepiecesFlowId() => $_clearField(12);

  @$pb.TagNumber(13)
  $core.bool get tierLimitCheck => $_getBF(12);
  @$pb.TagNumber(13)
  set tierLimitCheck($core.bool value) => $_setBool(12, value);
  @$pb.TagNumber(13)
  $core.bool hasTierLimitCheck() => $_has(12);
  @$pb.TagNumber(13)
  void clearTierLimitCheck() => $_clearField(13);

  @$pb.TagNumber(14)
  $core.int get runCount => $_getIZ(13);
  @$pb.TagNumber(14)
  set runCount($core.int value) => $_setSignedInt32(13, value);
  @$pb.TagNumber(14)
  $core.bool hasRunCount() => $_has(13);
  @$pb.TagNumber(14)
  void clearRunCount() => $_clearField(14);

  @$pb.TagNumber(15)
  $core.String get createdBy => $_getSZ(14);
  @$pb.TagNumber(15)
  set createdBy($core.String value) => $_setString(14, value);
  @$pb.TagNumber(15)
  $core.bool hasCreatedBy() => $_has(14);
  @$pb.TagNumber(15)
  void clearCreatedBy() => $_clearField(15);

  @$pb.TagNumber(16)
  $1.Timestamp get createdAt => $_getN(15);
  @$pb.TagNumber(16)
  set createdAt($1.Timestamp value) => $_setField(16, value);
  @$pb.TagNumber(16)
  $core.bool hasCreatedAt() => $_has(15);
  @$pb.TagNumber(16)
  void clearCreatedAt() => $_clearField(16);
  @$pb.TagNumber(16)
  $1.Timestamp ensureCreatedAt() => $_ensure(15);

  @$pb.TagNumber(17)
  $1.Timestamp get updatedAt => $_getN(16);
  @$pb.TagNumber(17)
  set updatedAt($1.Timestamp value) => $_setField(17, value);
  @$pb.TagNumber(17)
  $core.bool hasUpdatedAt() => $_has(16);
  @$pb.TagNumber(17)
  void clearUpdatedAt() => $_clearField(17);
  @$pb.TagNumber(17)
  $1.Timestamp ensureUpdatedAt() => $_ensure(16);
}

class WorkflowSummary extends $pb.GeneratedMessage {
  factory WorkflowSummary({
    $core.String? workflowId,
    $core.String? workspaceId,
    $core.String? title,
    $core.String? workflowType,
    WorkflowStatus? status,
    $core.int? version,
    TriggerType? triggerType,
    $core.int? nodeCount,
    $core.int? runCount,
    $1.Timestamp? createdAt,
    $1.Timestamp? updatedAt,
  }) {
    final result = WorkflowSummary._();
    if (workflowId != null) result.workflowId = workflowId;
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (title != null) result.title = title;
    if (workflowType != null) result.workflowType = workflowType;
    if (status != null) result.status = status;
    if (version != null) result.version = version;
    if (triggerType != null) result.triggerType = triggerType;
    if (nodeCount != null) result.nodeCount = nodeCount;
    if (runCount != null) result.runCount = runCount;
    if (createdAt != null) result.createdAt = createdAt;
    if (updatedAt != null) result.updatedAt = updatedAt;
    return result;
  }

  WorkflowSummary._();

  factory WorkflowSummary.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      WorkflowSummary()..mergeFromBuffer(data, registry);
  factory WorkflowSummary.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      WorkflowSummary()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'WorkflowSummary',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.automation.v1'),
      createEmptyInstance: WorkflowSummary.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workflowId')
    ..aOS(2, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(3, _omitFieldNames ? '' : 'title')
    ..aOS(4, _omitFieldNames ? '' : 'workflowType')
    ..aE<WorkflowStatus>(5, _omitFieldNames ? '' : 'status',
        enumValues: WorkflowStatus.values)
    ..aI(6, _omitFieldNames ? '' : 'version')
    ..aE<TriggerType>(7, _omitFieldNames ? '' : 'triggerType',
        enumValues: TriggerType.values)
    ..aI(8, _omitFieldNames ? '' : 'nodeCount')
    ..aI(9, _omitFieldNames ? '' : 'runCount')
    ..aOM<$1.Timestamp>(10, _omitFieldNames ? '' : 'createdAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..aOM<$1.Timestamp>(11, _omitFieldNames ? '' : 'updatedAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WorkflowSummary clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WorkflowSummary copyWith(void Function(WorkflowSummary) updates) =>
      super.copyWith((message) => updates(message as WorkflowSummary))
          as WorkflowSummary;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use WorkflowSummary() / WorkflowSummary.new instead')
  static WorkflowSummary create() => WorkflowSummary._();
  static $pb.GeneratedMessage $_createMessage() => WorkflowSummary._();
  @$core.override
  WorkflowSummary createEmptyInstance() => WorkflowSummary._();
  @$core.pragma('dart2js:noInline')
  static WorkflowSummary getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<WorkflowSummary>(
          WorkflowSummary.$_createMessage);
  static WorkflowSummary? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workflowId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workflowId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkflowId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkflowId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get workspaceId => $_getSZ(1);
  @$pb.TagNumber(2)
  set workspaceId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasWorkspaceId() => $_has(1);
  @$pb.TagNumber(2)
  void clearWorkspaceId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get title => $_getSZ(2);
  @$pb.TagNumber(3)
  set title($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasTitle() => $_has(2);
  @$pb.TagNumber(3)
  void clearTitle() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get workflowType => $_getSZ(3);
  @$pb.TagNumber(4)
  set workflowType($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasWorkflowType() => $_has(3);
  @$pb.TagNumber(4)
  void clearWorkflowType() => $_clearField(4);

  @$pb.TagNumber(5)
  WorkflowStatus get status => $_getN(4);
  @$pb.TagNumber(5)
  set status(WorkflowStatus value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasStatus() => $_has(4);
  @$pb.TagNumber(5)
  void clearStatus() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.int get version => $_getIZ(5);
  @$pb.TagNumber(6)
  set version($core.int value) => $_setSignedInt32(5, value);
  @$pb.TagNumber(6)
  $core.bool hasVersion() => $_has(5);
  @$pb.TagNumber(6)
  void clearVersion() => $_clearField(6);

  @$pb.TagNumber(7)
  TriggerType get triggerType => $_getN(6);
  @$pb.TagNumber(7)
  set triggerType(TriggerType value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasTriggerType() => $_has(6);
  @$pb.TagNumber(7)
  void clearTriggerType() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.int get nodeCount => $_getIZ(7);
  @$pb.TagNumber(8)
  set nodeCount($core.int value) => $_setSignedInt32(7, value);
  @$pb.TagNumber(8)
  $core.bool hasNodeCount() => $_has(7);
  @$pb.TagNumber(8)
  void clearNodeCount() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.int get runCount => $_getIZ(8);
  @$pb.TagNumber(9)
  set runCount($core.int value) => $_setSignedInt32(8, value);
  @$pb.TagNumber(9)
  $core.bool hasRunCount() => $_has(8);
  @$pb.TagNumber(9)
  void clearRunCount() => $_clearField(9);

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

class WorkflowRun extends $pb.GeneratedMessage {
  factory WorkflowRun({
    $core.String? runId,
    $core.String? workspaceId,
    $core.String? workflowId,
    WorkflowRunStatus? status,
    $core.String? currentNode,
    $core.String? triggerEventJson,
    $core.String? resultSummaryJson,
    $core.String? executionLogJson,
    $core.String? affectedObjectRefsJson,
    $core.String? sideEffectsSummaryJson,
    $core.String? activepiecesRunId,
    $1.Timestamp? startedAt,
    $1.Timestamp? completedAt,
    $1.Timestamp? createdAt,
    $1.Timestamp? updatedAt,
  }) {
    final result = WorkflowRun._();
    if (runId != null) result.runId = runId;
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (workflowId != null) result.workflowId = workflowId;
    if (status != null) result.status = status;
    if (currentNode != null) result.currentNode = currentNode;
    if (triggerEventJson != null) result.triggerEventJson = triggerEventJson;
    if (resultSummaryJson != null) result.resultSummaryJson = resultSummaryJson;
    if (executionLogJson != null) result.executionLogJson = executionLogJson;
    if (affectedObjectRefsJson != null)
      result.affectedObjectRefsJson = affectedObjectRefsJson;
    if (sideEffectsSummaryJson != null)
      result.sideEffectsSummaryJson = sideEffectsSummaryJson;
    if (activepiecesRunId != null) result.activepiecesRunId = activepiecesRunId;
    if (startedAt != null) result.startedAt = startedAt;
    if (completedAt != null) result.completedAt = completedAt;
    if (createdAt != null) result.createdAt = createdAt;
    if (updatedAt != null) result.updatedAt = updatedAt;
    return result;
  }

  WorkflowRun._();

  factory WorkflowRun.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      WorkflowRun()..mergeFromBuffer(data, registry);
  factory WorkflowRun.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      WorkflowRun()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'WorkflowRun',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.automation.v1'),
      createEmptyInstance: WorkflowRun.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'runId')
    ..aOS(2, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(3, _omitFieldNames ? '' : 'workflowId')
    ..aE<WorkflowRunStatus>(4, _omitFieldNames ? '' : 'status',
        enumValues: WorkflowRunStatus.values)
    ..aOS(5, _omitFieldNames ? '' : 'currentNode')
    ..aOS(6, _omitFieldNames ? '' : 'triggerEventJson')
    ..aOS(7, _omitFieldNames ? '' : 'resultSummaryJson')
    ..aOS(8, _omitFieldNames ? '' : 'executionLogJson')
    ..aOS(9, _omitFieldNames ? '' : 'affectedObjectRefsJson')
    ..aOS(10, _omitFieldNames ? '' : 'sideEffectsSummaryJson')
    ..aOS(11, _omitFieldNames ? '' : 'activepiecesRunId')
    ..aOM<$1.Timestamp>(12, _omitFieldNames ? '' : 'startedAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..aOM<$1.Timestamp>(13, _omitFieldNames ? '' : 'completedAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..aOM<$1.Timestamp>(14, _omitFieldNames ? '' : 'createdAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..aOM<$1.Timestamp>(15, _omitFieldNames ? '' : 'updatedAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WorkflowRun clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WorkflowRun copyWith(void Function(WorkflowRun) updates) =>
      super.copyWith((message) => updates(message as WorkflowRun))
          as WorkflowRun;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use WorkflowRun() / WorkflowRun.new instead')
  static WorkflowRun create() => WorkflowRun._();
  static $pb.GeneratedMessage $_createMessage() => WorkflowRun._();
  @$core.override
  WorkflowRun createEmptyInstance() => WorkflowRun._();
  @$core.pragma('dart2js:noInline')
  static WorkflowRun getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<WorkflowRun>(
          WorkflowRun.$_createMessage);
  static WorkflowRun? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get runId => $_getSZ(0);
  @$pb.TagNumber(1)
  set runId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRunId() => $_has(0);
  @$pb.TagNumber(1)
  void clearRunId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get workspaceId => $_getSZ(1);
  @$pb.TagNumber(2)
  set workspaceId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasWorkspaceId() => $_has(1);
  @$pb.TagNumber(2)
  void clearWorkspaceId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get workflowId => $_getSZ(2);
  @$pb.TagNumber(3)
  set workflowId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasWorkflowId() => $_has(2);
  @$pb.TagNumber(3)
  void clearWorkflowId() => $_clearField(3);

  @$pb.TagNumber(4)
  WorkflowRunStatus get status => $_getN(3);
  @$pb.TagNumber(4)
  set status(WorkflowRunStatus value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasStatus() => $_has(3);
  @$pb.TagNumber(4)
  void clearStatus() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get currentNode => $_getSZ(4);
  @$pb.TagNumber(5)
  set currentNode($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasCurrentNode() => $_has(4);
  @$pb.TagNumber(5)
  void clearCurrentNode() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get triggerEventJson => $_getSZ(5);
  @$pb.TagNumber(6)
  set triggerEventJson($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasTriggerEventJson() => $_has(5);
  @$pb.TagNumber(6)
  void clearTriggerEventJson() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get resultSummaryJson => $_getSZ(6);
  @$pb.TagNumber(7)
  set resultSummaryJson($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasResultSummaryJson() => $_has(6);
  @$pb.TagNumber(7)
  void clearResultSummaryJson() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get executionLogJson => $_getSZ(7);
  @$pb.TagNumber(8)
  set executionLogJson($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasExecutionLogJson() => $_has(7);
  @$pb.TagNumber(8)
  void clearExecutionLogJson() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get affectedObjectRefsJson => $_getSZ(8);
  @$pb.TagNumber(9)
  set affectedObjectRefsJson($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasAffectedObjectRefsJson() => $_has(8);
  @$pb.TagNumber(9)
  void clearAffectedObjectRefsJson() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.String get sideEffectsSummaryJson => $_getSZ(9);
  @$pb.TagNumber(10)
  set sideEffectsSummaryJson($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasSideEffectsSummaryJson() => $_has(9);
  @$pb.TagNumber(10)
  void clearSideEffectsSummaryJson() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.String get activepiecesRunId => $_getSZ(10);
  @$pb.TagNumber(11)
  set activepiecesRunId($core.String value) => $_setString(10, value);
  @$pb.TagNumber(11)
  $core.bool hasActivepiecesRunId() => $_has(10);
  @$pb.TagNumber(11)
  void clearActivepiecesRunId() => $_clearField(11);

  @$pb.TagNumber(12)
  $1.Timestamp get startedAt => $_getN(11);
  @$pb.TagNumber(12)
  set startedAt($1.Timestamp value) => $_setField(12, value);
  @$pb.TagNumber(12)
  $core.bool hasStartedAt() => $_has(11);
  @$pb.TagNumber(12)
  void clearStartedAt() => $_clearField(12);
  @$pb.TagNumber(12)
  $1.Timestamp ensureStartedAt() => $_ensure(11);

  @$pb.TagNumber(13)
  $1.Timestamp get completedAt => $_getN(12);
  @$pb.TagNumber(13)
  set completedAt($1.Timestamp value) => $_setField(13, value);
  @$pb.TagNumber(13)
  $core.bool hasCompletedAt() => $_has(12);
  @$pb.TagNumber(13)
  void clearCompletedAt() => $_clearField(13);
  @$pb.TagNumber(13)
  $1.Timestamp ensureCompletedAt() => $_ensure(12);

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

  @$pb.TagNumber(15)
  $1.Timestamp get updatedAt => $_getN(14);
  @$pb.TagNumber(15)
  set updatedAt($1.Timestamp value) => $_setField(15, value);
  @$pb.TagNumber(15)
  $core.bool hasUpdatedAt() => $_has(14);
  @$pb.TagNumber(15)
  void clearUpdatedAt() => $_clearField(15);
  @$pb.TagNumber(15)
  $1.Timestamp ensureUpdatedAt() => $_ensure(14);
}

class WorkflowRunStep extends $pb.GeneratedMessage {
  factory WorkflowRunStep({
    $core.String? stepId,
    $core.String? workspaceId,
    $core.String? runId,
    $core.String? nodeId,
    NodeType? nodeType,
    $core.int? stepOrder,
    $core.String? status,
    $core.String? inputSnapshotJson,
    $core.String? outputSnapshotJson,
    $core.String? diagnosticsRef,
    $core.String? sideEffectRefsJson,
    $1.Timestamp? startedAt,
    $1.Timestamp? completedAt,
    $1.Timestamp? createdAt,
    $1.Timestamp? updatedAt,
  }) {
    final result = WorkflowRunStep._();
    if (stepId != null) result.stepId = stepId;
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (runId != null) result.runId = runId;
    if (nodeId != null) result.nodeId = nodeId;
    if (nodeType != null) result.nodeType = nodeType;
    if (stepOrder != null) result.stepOrder = stepOrder;
    if (status != null) result.status = status;
    if (inputSnapshotJson != null) result.inputSnapshotJson = inputSnapshotJson;
    if (outputSnapshotJson != null)
      result.outputSnapshotJson = outputSnapshotJson;
    if (diagnosticsRef != null) result.diagnosticsRef = diagnosticsRef;
    if (sideEffectRefsJson != null)
      result.sideEffectRefsJson = sideEffectRefsJson;
    if (startedAt != null) result.startedAt = startedAt;
    if (completedAt != null) result.completedAt = completedAt;
    if (createdAt != null) result.createdAt = createdAt;
    if (updatedAt != null) result.updatedAt = updatedAt;
    return result;
  }

  WorkflowRunStep._();

  factory WorkflowRunStep.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      WorkflowRunStep()..mergeFromBuffer(data, registry);
  factory WorkflowRunStep.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      WorkflowRunStep()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'WorkflowRunStep',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.automation.v1'),
      createEmptyInstance: WorkflowRunStep.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'stepId')
    ..aOS(2, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(3, _omitFieldNames ? '' : 'runId')
    ..aOS(4, _omitFieldNames ? '' : 'nodeId')
    ..aE<NodeType>(5, _omitFieldNames ? '' : 'nodeType',
        enumValues: NodeType.values)
    ..aI(6, _omitFieldNames ? '' : 'stepOrder')
    ..aOS(7, _omitFieldNames ? '' : 'status')
    ..aOS(8, _omitFieldNames ? '' : 'inputSnapshotJson')
    ..aOS(9, _omitFieldNames ? '' : 'outputSnapshotJson')
    ..aOS(10, _omitFieldNames ? '' : 'diagnosticsRef')
    ..aOS(11, _omitFieldNames ? '' : 'sideEffectRefsJson')
    ..aOM<$1.Timestamp>(12, _omitFieldNames ? '' : 'startedAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..aOM<$1.Timestamp>(13, _omitFieldNames ? '' : 'completedAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..aOM<$1.Timestamp>(14, _omitFieldNames ? '' : 'createdAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..aOM<$1.Timestamp>(15, _omitFieldNames ? '' : 'updatedAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WorkflowRunStep clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WorkflowRunStep copyWith(void Function(WorkflowRunStep) updates) =>
      super.copyWith((message) => updates(message as WorkflowRunStep))
          as WorkflowRunStep;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use WorkflowRunStep() / WorkflowRunStep.new instead')
  static WorkflowRunStep create() => WorkflowRunStep._();
  static $pb.GeneratedMessage $_createMessage() => WorkflowRunStep._();
  @$core.override
  WorkflowRunStep createEmptyInstance() => WorkflowRunStep._();
  @$core.pragma('dart2js:noInline')
  static WorkflowRunStep getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<WorkflowRunStep>(
          WorkflowRunStep.$_createMessage);
  static WorkflowRunStep? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get stepId => $_getSZ(0);
  @$pb.TagNumber(1)
  set stepId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasStepId() => $_has(0);
  @$pb.TagNumber(1)
  void clearStepId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get workspaceId => $_getSZ(1);
  @$pb.TagNumber(2)
  set workspaceId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasWorkspaceId() => $_has(1);
  @$pb.TagNumber(2)
  void clearWorkspaceId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get runId => $_getSZ(2);
  @$pb.TagNumber(3)
  set runId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasRunId() => $_has(2);
  @$pb.TagNumber(3)
  void clearRunId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get nodeId => $_getSZ(3);
  @$pb.TagNumber(4)
  set nodeId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasNodeId() => $_has(3);
  @$pb.TagNumber(4)
  void clearNodeId() => $_clearField(4);

  @$pb.TagNumber(5)
  NodeType get nodeType => $_getN(4);
  @$pb.TagNumber(5)
  set nodeType(NodeType value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasNodeType() => $_has(4);
  @$pb.TagNumber(5)
  void clearNodeType() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.int get stepOrder => $_getIZ(5);
  @$pb.TagNumber(6)
  set stepOrder($core.int value) => $_setSignedInt32(5, value);
  @$pb.TagNumber(6)
  $core.bool hasStepOrder() => $_has(5);
  @$pb.TagNumber(6)
  void clearStepOrder() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get status => $_getSZ(6);
  @$pb.TagNumber(7)
  set status($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasStatus() => $_has(6);
  @$pb.TagNumber(7)
  void clearStatus() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get inputSnapshotJson => $_getSZ(7);
  @$pb.TagNumber(8)
  set inputSnapshotJson($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasInputSnapshotJson() => $_has(7);
  @$pb.TagNumber(8)
  void clearInputSnapshotJson() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get outputSnapshotJson => $_getSZ(8);
  @$pb.TagNumber(9)
  set outputSnapshotJson($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasOutputSnapshotJson() => $_has(8);
  @$pb.TagNumber(9)
  void clearOutputSnapshotJson() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.String get diagnosticsRef => $_getSZ(9);
  @$pb.TagNumber(10)
  set diagnosticsRef($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasDiagnosticsRef() => $_has(9);
  @$pb.TagNumber(10)
  void clearDiagnosticsRef() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.String get sideEffectRefsJson => $_getSZ(10);
  @$pb.TagNumber(11)
  set sideEffectRefsJson($core.String value) => $_setString(10, value);
  @$pb.TagNumber(11)
  $core.bool hasSideEffectRefsJson() => $_has(10);
  @$pb.TagNumber(11)
  void clearSideEffectRefsJson() => $_clearField(11);

  @$pb.TagNumber(12)
  $1.Timestamp get startedAt => $_getN(11);
  @$pb.TagNumber(12)
  set startedAt($1.Timestamp value) => $_setField(12, value);
  @$pb.TagNumber(12)
  $core.bool hasStartedAt() => $_has(11);
  @$pb.TagNumber(12)
  void clearStartedAt() => $_clearField(12);
  @$pb.TagNumber(12)
  $1.Timestamp ensureStartedAt() => $_ensure(11);

  @$pb.TagNumber(13)
  $1.Timestamp get completedAt => $_getN(12);
  @$pb.TagNumber(13)
  set completedAt($1.Timestamp value) => $_setField(13, value);
  @$pb.TagNumber(13)
  $core.bool hasCompletedAt() => $_has(12);
  @$pb.TagNumber(13)
  void clearCompletedAt() => $_clearField(13);
  @$pb.TagNumber(13)
  $1.Timestamp ensureCompletedAt() => $_ensure(12);

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

  @$pb.TagNumber(15)
  $1.Timestamp get updatedAt => $_getN(14);
  @$pb.TagNumber(15)
  set updatedAt($1.Timestamp value) => $_setField(15, value);
  @$pb.TagNumber(15)
  $core.bool hasUpdatedAt() => $_has(14);
  @$pb.TagNumber(15)
  void clearUpdatedAt() => $_clearField(15);
  @$pb.TagNumber(15)
  $1.Timestamp ensureUpdatedAt() => $_ensure(14);
}

class PortableWorkflowPayload extends $pb.GeneratedMessage {
  factory PortableWorkflowPayload({
    $core.int? schemaVersion,
    $core.String? title,
    $core.String? description,
    $core.String? workflowType,
    TriggerConfig? triggerConfig,
    WorkflowGraph? graph,
    $core.String? licenseNotice,
    $core.String? parametersJson,
  }) {
    final result = PortableWorkflowPayload._();
    if (schemaVersion != null) result.schemaVersion = schemaVersion;
    if (title != null) result.title = title;
    if (description != null) result.description = description;
    if (workflowType != null) result.workflowType = workflowType;
    if (triggerConfig != null) result.triggerConfig = triggerConfig;
    if (graph != null) result.graph = graph;
    if (licenseNotice != null) result.licenseNotice = licenseNotice;
    if (parametersJson != null) result.parametersJson = parametersJson;
    return result;
  }

  PortableWorkflowPayload._();

  factory PortableWorkflowPayload.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PortableWorkflowPayload()..mergeFromBuffer(data, registry);
  factory PortableWorkflowPayload.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PortableWorkflowPayload()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PortableWorkflowPayload',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.automation.v1'),
      createEmptyInstance: PortableWorkflowPayload.$_createMessage)
    ..aI(1, _omitFieldNames ? '' : 'schemaVersion')
    ..aOS(2, _omitFieldNames ? '' : 'title')
    ..aOS(3, _omitFieldNames ? '' : 'description')
    ..aOS(4, _omitFieldNames ? '' : 'workflowType')
    ..aOM<TriggerConfig>(5, _omitFieldNames ? '' : 'triggerConfig',
        subBuilder: TriggerConfig.$_createMessage)
    ..aOM<WorkflowGraph>(6, _omitFieldNames ? '' : 'graph',
        subBuilder: WorkflowGraph.$_createMessage)
    ..aOS(7, _omitFieldNames ? '' : 'licenseNotice')
    ..aOS(8, _omitFieldNames ? '' : 'parametersJson')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PortableWorkflowPayload clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PortableWorkflowPayload copyWith(
          void Function(PortableWorkflowPayload) updates) =>
      super.copyWith((message) => updates(message as PortableWorkflowPayload))
          as PortableWorkflowPayload;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use PortableWorkflowPayload() / PortableWorkflowPayload.new instead')
  static PortableWorkflowPayload create() => PortableWorkflowPayload._();
  static $pb.GeneratedMessage $_createMessage() => PortableWorkflowPayload._();
  @$core.override
  PortableWorkflowPayload createEmptyInstance() => PortableWorkflowPayload._();
  @$core.pragma('dart2js:noInline')
  static PortableWorkflowPayload getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PortableWorkflowPayload>(
          PortableWorkflowPayload.$_createMessage);
  static PortableWorkflowPayload? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get schemaVersion => $_getIZ(0);
  @$pb.TagNumber(1)
  set schemaVersion($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSchemaVersion() => $_has(0);
  @$pb.TagNumber(1)
  void clearSchemaVersion() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get title => $_getSZ(1);
  @$pb.TagNumber(2)
  set title($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTitle() => $_has(1);
  @$pb.TagNumber(2)
  void clearTitle() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get description => $_getSZ(2);
  @$pb.TagNumber(3)
  set description($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasDescription() => $_has(2);
  @$pb.TagNumber(3)
  void clearDescription() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get workflowType => $_getSZ(3);
  @$pb.TagNumber(4)
  set workflowType($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasWorkflowType() => $_has(3);
  @$pb.TagNumber(4)
  void clearWorkflowType() => $_clearField(4);

  @$pb.TagNumber(5)
  TriggerConfig get triggerConfig => $_getN(4);
  @$pb.TagNumber(5)
  set triggerConfig(TriggerConfig value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasTriggerConfig() => $_has(4);
  @$pb.TagNumber(5)
  void clearTriggerConfig() => $_clearField(5);
  @$pb.TagNumber(5)
  TriggerConfig ensureTriggerConfig() => $_ensure(4);

  @$pb.TagNumber(6)
  WorkflowGraph get graph => $_getN(5);
  @$pb.TagNumber(6)
  set graph(WorkflowGraph value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasGraph() => $_has(5);
  @$pb.TagNumber(6)
  void clearGraph() => $_clearField(6);
  @$pb.TagNumber(6)
  WorkflowGraph ensureGraph() => $_ensure(5);

  @$pb.TagNumber(7)
  $core.String get licenseNotice => $_getSZ(6);
  @$pb.TagNumber(7)
  set licenseNotice($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasLicenseNotice() => $_has(6);
  @$pb.TagNumber(7)
  void clearLicenseNotice() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get parametersJson => $_getSZ(7);
  @$pb.TagNumber(8)
  set parametersJson($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasParametersJson() => $_has(7);
  @$pb.TagNumber(8)
  void clearParametersJson() => $_clearField(8);
}

class WorkflowServiceCreateRequest extends $pb.GeneratedMessage {
  factory WorkflowServiceCreateRequest({
    $core.String? idempotencyKey,
    $core.String? workspaceId,
    $core.String? title,
    $core.String? description,
    $core.String? workflowType,
    TriggerConfig? triggerConfig,
    WorkflowGraph? actionChain,
    $core.String? approvalRequirementsJson,
  }) {
    final result = WorkflowServiceCreateRequest._();
    if (idempotencyKey != null) result.idempotencyKey = idempotencyKey;
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (title != null) result.title = title;
    if (description != null) result.description = description;
    if (workflowType != null) result.workflowType = workflowType;
    if (triggerConfig != null) result.triggerConfig = triggerConfig;
    if (actionChain != null) result.actionChain = actionChain;
    if (approvalRequirementsJson != null)
      result.approvalRequirementsJson = approvalRequirementsJson;
    return result;
  }

  WorkflowServiceCreateRequest._();

  factory WorkflowServiceCreateRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      WorkflowServiceCreateRequest()..mergeFromBuffer(data, registry);
  factory WorkflowServiceCreateRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      WorkflowServiceCreateRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'WorkflowServiceCreateRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.automation.v1'),
      createEmptyInstance: WorkflowServiceCreateRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'idempotencyKey')
    ..aOS(2, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(3, _omitFieldNames ? '' : 'title')
    ..aOS(4, _omitFieldNames ? '' : 'description')
    ..aOS(5, _omitFieldNames ? '' : 'workflowType')
    ..aOM<TriggerConfig>(6, _omitFieldNames ? '' : 'triggerConfig',
        subBuilder: TriggerConfig.$_createMessage)
    ..aOM<WorkflowGraph>(7, _omitFieldNames ? '' : 'actionChain',
        subBuilder: WorkflowGraph.$_createMessage)
    ..aOS(8, _omitFieldNames ? '' : 'approvalRequirementsJson')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WorkflowServiceCreateRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WorkflowServiceCreateRequest copyWith(
          void Function(WorkflowServiceCreateRequest) updates) =>
      super.copyWith(
              (message) => updates(message as WorkflowServiceCreateRequest))
          as WorkflowServiceCreateRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use WorkflowServiceCreateRequest() / WorkflowServiceCreateRequest.new instead')
  static WorkflowServiceCreateRequest create() =>
      WorkflowServiceCreateRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      WorkflowServiceCreateRequest._();
  @$core.override
  WorkflowServiceCreateRequest createEmptyInstance() =>
      WorkflowServiceCreateRequest._();
  @$core.pragma('dart2js:noInline')
  static WorkflowServiceCreateRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<WorkflowServiceCreateRequest>(
          WorkflowServiceCreateRequest.$_createMessage);
  static WorkflowServiceCreateRequest? _defaultInstance;

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
  $core.String get workflowType => $_getSZ(4);
  @$pb.TagNumber(5)
  set workflowType($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasWorkflowType() => $_has(4);
  @$pb.TagNumber(5)
  void clearWorkflowType() => $_clearField(5);

  @$pb.TagNumber(6)
  TriggerConfig get triggerConfig => $_getN(5);
  @$pb.TagNumber(6)
  set triggerConfig(TriggerConfig value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasTriggerConfig() => $_has(5);
  @$pb.TagNumber(6)
  void clearTriggerConfig() => $_clearField(6);
  @$pb.TagNumber(6)
  TriggerConfig ensureTriggerConfig() => $_ensure(5);

  @$pb.TagNumber(7)
  WorkflowGraph get actionChain => $_getN(6);
  @$pb.TagNumber(7)
  set actionChain(WorkflowGraph value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasActionChain() => $_has(6);
  @$pb.TagNumber(7)
  void clearActionChain() => $_clearField(7);
  @$pb.TagNumber(7)
  WorkflowGraph ensureActionChain() => $_ensure(6);

  @$pb.TagNumber(8)
  $core.String get approvalRequirementsJson => $_getSZ(7);
  @$pb.TagNumber(8)
  set approvalRequirementsJson($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasApprovalRequirementsJson() => $_has(7);
  @$pb.TagNumber(8)
  void clearApprovalRequirementsJson() => $_clearField(8);
}

class WorkflowServiceCreateResponse extends $pb.GeneratedMessage {
  factory WorkflowServiceCreateResponse({
    $core.String? id,
    $core.String? workspaceId,
    $core.String? title,
    $core.String? status,
    $core.int? nodeCount,
    $core.int? version,
    $1.Timestamp? createdAt,
    Workflow? workflow,
  }) {
    final result = WorkflowServiceCreateResponse._();
    if (id != null) result.id = id;
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (title != null) result.title = title;
    if (status != null) result.status = status;
    if (nodeCount != null) result.nodeCount = nodeCount;
    if (version != null) result.version = version;
    if (createdAt != null) result.createdAt = createdAt;
    if (workflow != null) result.workflow = workflow;
    return result;
  }

  WorkflowServiceCreateResponse._();

  factory WorkflowServiceCreateResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      WorkflowServiceCreateResponse()..mergeFromBuffer(data, registry);
  factory WorkflowServiceCreateResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      WorkflowServiceCreateResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'WorkflowServiceCreateResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.automation.v1'),
      createEmptyInstance: WorkflowServiceCreateResponse.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(3, _omitFieldNames ? '' : 'title')
    ..aOS(4, _omitFieldNames ? '' : 'status')
    ..aI(5, _omitFieldNames ? '' : 'nodeCount')
    ..aI(6, _omitFieldNames ? '' : 'version')
    ..aOM<$1.Timestamp>(7, _omitFieldNames ? '' : 'createdAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..aOM<Workflow>(8, _omitFieldNames ? '' : 'workflow',
        subBuilder: Workflow.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WorkflowServiceCreateResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WorkflowServiceCreateResponse copyWith(
          void Function(WorkflowServiceCreateResponse) updates) =>
      super.copyWith(
              (message) => updates(message as WorkflowServiceCreateResponse))
          as WorkflowServiceCreateResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use WorkflowServiceCreateResponse() / WorkflowServiceCreateResponse.new instead')
  static WorkflowServiceCreateResponse create() =>
      WorkflowServiceCreateResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      WorkflowServiceCreateResponse._();
  @$core.override
  WorkflowServiceCreateResponse createEmptyInstance() =>
      WorkflowServiceCreateResponse._();
  @$core.pragma('dart2js:noInline')
  static WorkflowServiceCreateResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<WorkflowServiceCreateResponse>(
          WorkflowServiceCreateResponse.$_createMessage);
  static WorkflowServiceCreateResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get workspaceId => $_getSZ(1);
  @$pb.TagNumber(2)
  set workspaceId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasWorkspaceId() => $_has(1);
  @$pb.TagNumber(2)
  void clearWorkspaceId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get title => $_getSZ(2);
  @$pb.TagNumber(3)
  set title($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasTitle() => $_has(2);
  @$pb.TagNumber(3)
  void clearTitle() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get status => $_getSZ(3);
  @$pb.TagNumber(4)
  set status($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasStatus() => $_has(3);
  @$pb.TagNumber(4)
  void clearStatus() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get nodeCount => $_getIZ(4);
  @$pb.TagNumber(5)
  set nodeCount($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasNodeCount() => $_has(4);
  @$pb.TagNumber(5)
  void clearNodeCount() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.int get version => $_getIZ(5);
  @$pb.TagNumber(6)
  set version($core.int value) => $_setSignedInt32(5, value);
  @$pb.TagNumber(6)
  $core.bool hasVersion() => $_has(5);
  @$pb.TagNumber(6)
  void clearVersion() => $_clearField(6);

  @$pb.TagNumber(7)
  $1.Timestamp get createdAt => $_getN(6);
  @$pb.TagNumber(7)
  set createdAt($1.Timestamp value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasCreatedAt() => $_has(6);
  @$pb.TagNumber(7)
  void clearCreatedAt() => $_clearField(7);
  @$pb.TagNumber(7)
  $1.Timestamp ensureCreatedAt() => $_ensure(6);

  @$pb.TagNumber(8)
  Workflow get workflow => $_getN(7);
  @$pb.TagNumber(8)
  set workflow(Workflow value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasWorkflow() => $_has(7);
  @$pb.TagNumber(8)
  void clearWorkflow() => $_clearField(8);
  @$pb.TagNumber(8)
  Workflow ensureWorkflow() => $_ensure(7);
}

class WorkflowServiceGetRequest extends $pb.GeneratedMessage {
  factory WorkflowServiceGetRequest({
    $core.String? workspaceId,
    $core.String? workflowId,
  }) {
    final result = WorkflowServiceGetRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (workflowId != null) result.workflowId = workflowId;
    return result;
  }

  WorkflowServiceGetRequest._();

  factory WorkflowServiceGetRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      WorkflowServiceGetRequest()..mergeFromBuffer(data, registry);
  factory WorkflowServiceGetRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      WorkflowServiceGetRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'WorkflowServiceGetRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.automation.v1'),
      createEmptyInstance: WorkflowServiceGetRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'workflowId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WorkflowServiceGetRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WorkflowServiceGetRequest copyWith(
          void Function(WorkflowServiceGetRequest) updates) =>
      super.copyWith((message) => updates(message as WorkflowServiceGetRequest))
          as WorkflowServiceGetRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use WorkflowServiceGetRequest() / WorkflowServiceGetRequest.new instead')
  static WorkflowServiceGetRequest create() => WorkflowServiceGetRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      WorkflowServiceGetRequest._();
  @$core.override
  WorkflowServiceGetRequest createEmptyInstance() =>
      WorkflowServiceGetRequest._();
  @$core.pragma('dart2js:noInline')
  static WorkflowServiceGetRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<WorkflowServiceGetRequest>(
          WorkflowServiceGetRequest.$_createMessage);
  static WorkflowServiceGetRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get workflowId => $_getSZ(1);
  @$pb.TagNumber(2)
  set workflowId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasWorkflowId() => $_has(1);
  @$pb.TagNumber(2)
  void clearWorkflowId() => $_clearField(2);
}

class WorkflowServiceGetResponse extends $pb.GeneratedMessage {
  factory WorkflowServiceGetResponse({
    Workflow? workflow,
  }) {
    final result = WorkflowServiceGetResponse._();
    if (workflow != null) result.workflow = workflow;
    return result;
  }

  WorkflowServiceGetResponse._();

  factory WorkflowServiceGetResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      WorkflowServiceGetResponse()..mergeFromBuffer(data, registry);
  factory WorkflowServiceGetResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      WorkflowServiceGetResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'WorkflowServiceGetResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.automation.v1'),
      createEmptyInstance: WorkflowServiceGetResponse.$_createMessage)
    ..aOM<Workflow>(1, _omitFieldNames ? '' : 'workflow',
        subBuilder: Workflow.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WorkflowServiceGetResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WorkflowServiceGetResponse copyWith(
          void Function(WorkflowServiceGetResponse) updates) =>
      super.copyWith(
              (message) => updates(message as WorkflowServiceGetResponse))
          as WorkflowServiceGetResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use WorkflowServiceGetResponse() / WorkflowServiceGetResponse.new instead')
  static WorkflowServiceGetResponse create() => WorkflowServiceGetResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      WorkflowServiceGetResponse._();
  @$core.override
  WorkflowServiceGetResponse createEmptyInstance() =>
      WorkflowServiceGetResponse._();
  @$core.pragma('dart2js:noInline')
  static WorkflowServiceGetResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<WorkflowServiceGetResponse>(
          WorkflowServiceGetResponse.$_createMessage);
  static WorkflowServiceGetResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Workflow get workflow => $_getN(0);
  @$pb.TagNumber(1)
  set workflow(Workflow value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkflow() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkflow() => $_clearField(1);
  @$pb.TagNumber(1)
  Workflow ensureWorkflow() => $_ensure(0);
}

class WorkflowServiceListRequest extends $pb.GeneratedMessage {
  factory WorkflowServiceListRequest({
    $core.String? workspaceId,
    $core.String? status,
    $core.int? limit,
    $core.int? offset,
  }) {
    final result = WorkflowServiceListRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (status != null) result.status = status;
    if (limit != null) result.limit = limit;
    if (offset != null) result.offset = offset;
    return result;
  }

  WorkflowServiceListRequest._();

  factory WorkflowServiceListRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      WorkflowServiceListRequest()..mergeFromBuffer(data, registry);
  factory WorkflowServiceListRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      WorkflowServiceListRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'WorkflowServiceListRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.automation.v1'),
      createEmptyInstance: WorkflowServiceListRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'status')
    ..aI(3, _omitFieldNames ? '' : 'limit')
    ..aI(4, _omitFieldNames ? '' : 'offset')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WorkflowServiceListRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WorkflowServiceListRequest copyWith(
          void Function(WorkflowServiceListRequest) updates) =>
      super.copyWith(
              (message) => updates(message as WorkflowServiceListRequest))
          as WorkflowServiceListRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use WorkflowServiceListRequest() / WorkflowServiceListRequest.new instead')
  static WorkflowServiceListRequest create() => WorkflowServiceListRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      WorkflowServiceListRequest._();
  @$core.override
  WorkflowServiceListRequest createEmptyInstance() =>
      WorkflowServiceListRequest._();
  @$core.pragma('dart2js:noInline')
  static WorkflowServiceListRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<WorkflowServiceListRequest>(
          WorkflowServiceListRequest.$_createMessage);
  static WorkflowServiceListRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get status => $_getSZ(1);
  @$pb.TagNumber(2)
  set status($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasStatus() => $_has(1);
  @$pb.TagNumber(2)
  void clearStatus() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get limit => $_getIZ(2);
  @$pb.TagNumber(3)
  set limit($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasLimit() => $_has(2);
  @$pb.TagNumber(3)
  void clearLimit() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get offset => $_getIZ(3);
  @$pb.TagNumber(4)
  set offset($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasOffset() => $_has(3);
  @$pb.TagNumber(4)
  void clearOffset() => $_clearField(4);
}

class WorkflowServiceListResponse extends $pb.GeneratedMessage {
  factory WorkflowServiceListResponse({
    $core.Iterable<WorkflowSummary>? workflows,
    $core.int? totalCount,
  }) {
    final result = WorkflowServiceListResponse._();
    if (workflows != null) result.workflows.addAll(workflows);
    if (totalCount != null) result.totalCount = totalCount;
    return result;
  }

  WorkflowServiceListResponse._();

  factory WorkflowServiceListResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      WorkflowServiceListResponse()..mergeFromBuffer(data, registry);
  factory WorkflowServiceListResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      WorkflowServiceListResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'WorkflowServiceListResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.automation.v1'),
      createEmptyInstance: WorkflowServiceListResponse.$_createMessage)
    ..pPM<WorkflowSummary>(1, _omitFieldNames ? '' : 'workflows',
        subBuilder: WorkflowSummary.$_createMessage)
    ..aI(2, _omitFieldNames ? '' : 'totalCount')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WorkflowServiceListResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WorkflowServiceListResponse copyWith(
          void Function(WorkflowServiceListResponse) updates) =>
      super.copyWith(
              (message) => updates(message as WorkflowServiceListResponse))
          as WorkflowServiceListResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use WorkflowServiceListResponse() / WorkflowServiceListResponse.new instead')
  static WorkflowServiceListResponse create() =>
      WorkflowServiceListResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      WorkflowServiceListResponse._();
  @$core.override
  WorkflowServiceListResponse createEmptyInstance() =>
      WorkflowServiceListResponse._();
  @$core.pragma('dart2js:noInline')
  static WorkflowServiceListResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<WorkflowServiceListResponse>(
          WorkflowServiceListResponse.$_createMessage);
  static WorkflowServiceListResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<WorkflowSummary> get workflows => $_getList(0);

  @$pb.TagNumber(2)
  $core.int get totalCount => $_getIZ(1);
  @$pb.TagNumber(2)
  set totalCount($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTotalCount() => $_has(1);
  @$pb.TagNumber(2)
  void clearTotalCount() => $_clearField(2);
}

class WorkflowServiceUpdateRequest extends $pb.GeneratedMessage {
  factory WorkflowServiceUpdateRequest({
    $core.String? idempotencyKey,
    $core.String? workspaceId,
    $core.String? workflowId,
    $core.String? title,
    $core.String? description,
    TriggerConfig? triggerConfig,
    WorkflowGraph? actionChain,
    $core.String? approvalRequirementsJson,
    $core.int? expectedVersion,
  }) {
    final result = WorkflowServiceUpdateRequest._();
    if (idempotencyKey != null) result.idempotencyKey = idempotencyKey;
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (workflowId != null) result.workflowId = workflowId;
    if (title != null) result.title = title;
    if (description != null) result.description = description;
    if (triggerConfig != null) result.triggerConfig = triggerConfig;
    if (actionChain != null) result.actionChain = actionChain;
    if (approvalRequirementsJson != null)
      result.approvalRequirementsJson = approvalRequirementsJson;
    if (expectedVersion != null) result.expectedVersion = expectedVersion;
    return result;
  }

  WorkflowServiceUpdateRequest._();

  factory WorkflowServiceUpdateRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      WorkflowServiceUpdateRequest()..mergeFromBuffer(data, registry);
  factory WorkflowServiceUpdateRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      WorkflowServiceUpdateRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'WorkflowServiceUpdateRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.automation.v1'),
      createEmptyInstance: WorkflowServiceUpdateRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'idempotencyKey')
    ..aOS(2, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(3, _omitFieldNames ? '' : 'workflowId')
    ..aOS(4, _omitFieldNames ? '' : 'title')
    ..aOS(5, _omitFieldNames ? '' : 'description')
    ..aOM<TriggerConfig>(6, _omitFieldNames ? '' : 'triggerConfig',
        subBuilder: TriggerConfig.$_createMessage)
    ..aOM<WorkflowGraph>(7, _omitFieldNames ? '' : 'actionChain',
        subBuilder: WorkflowGraph.$_createMessage)
    ..aOS(8, _omitFieldNames ? '' : 'approvalRequirementsJson')
    ..aI(9, _omitFieldNames ? '' : 'expectedVersion')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WorkflowServiceUpdateRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WorkflowServiceUpdateRequest copyWith(
          void Function(WorkflowServiceUpdateRequest) updates) =>
      super.copyWith(
              (message) => updates(message as WorkflowServiceUpdateRequest))
          as WorkflowServiceUpdateRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use WorkflowServiceUpdateRequest() / WorkflowServiceUpdateRequest.new instead')
  static WorkflowServiceUpdateRequest create() =>
      WorkflowServiceUpdateRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      WorkflowServiceUpdateRequest._();
  @$core.override
  WorkflowServiceUpdateRequest createEmptyInstance() =>
      WorkflowServiceUpdateRequest._();
  @$core.pragma('dart2js:noInline')
  static WorkflowServiceUpdateRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<WorkflowServiceUpdateRequest>(
          WorkflowServiceUpdateRequest.$_createMessage);
  static WorkflowServiceUpdateRequest? _defaultInstance;

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
  $core.String get workflowId => $_getSZ(2);
  @$pb.TagNumber(3)
  set workflowId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasWorkflowId() => $_has(2);
  @$pb.TagNumber(3)
  void clearWorkflowId() => $_clearField(3);

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
  TriggerConfig get triggerConfig => $_getN(5);
  @$pb.TagNumber(6)
  set triggerConfig(TriggerConfig value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasTriggerConfig() => $_has(5);
  @$pb.TagNumber(6)
  void clearTriggerConfig() => $_clearField(6);
  @$pb.TagNumber(6)
  TriggerConfig ensureTriggerConfig() => $_ensure(5);

  @$pb.TagNumber(7)
  WorkflowGraph get actionChain => $_getN(6);
  @$pb.TagNumber(7)
  set actionChain(WorkflowGraph value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasActionChain() => $_has(6);
  @$pb.TagNumber(7)
  void clearActionChain() => $_clearField(7);
  @$pb.TagNumber(7)
  WorkflowGraph ensureActionChain() => $_ensure(6);

  @$pb.TagNumber(8)
  $core.String get approvalRequirementsJson => $_getSZ(7);
  @$pb.TagNumber(8)
  set approvalRequirementsJson($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasApprovalRequirementsJson() => $_has(7);
  @$pb.TagNumber(8)
  void clearApprovalRequirementsJson() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.int get expectedVersion => $_getIZ(8);
  @$pb.TagNumber(9)
  set expectedVersion($core.int value) => $_setSignedInt32(8, value);
  @$pb.TagNumber(9)
  $core.bool hasExpectedVersion() => $_has(8);
  @$pb.TagNumber(9)
  void clearExpectedVersion() => $_clearField(9);
}

class WorkflowServiceUpdateResponse extends $pb.GeneratedMessage {
  factory WorkflowServiceUpdateResponse({
    Workflow? workflow,
  }) {
    final result = WorkflowServiceUpdateResponse._();
    if (workflow != null) result.workflow = workflow;
    return result;
  }

  WorkflowServiceUpdateResponse._();

  factory WorkflowServiceUpdateResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      WorkflowServiceUpdateResponse()..mergeFromBuffer(data, registry);
  factory WorkflowServiceUpdateResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      WorkflowServiceUpdateResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'WorkflowServiceUpdateResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.automation.v1'),
      createEmptyInstance: WorkflowServiceUpdateResponse.$_createMessage)
    ..aOM<Workflow>(1, _omitFieldNames ? '' : 'workflow',
        subBuilder: Workflow.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WorkflowServiceUpdateResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WorkflowServiceUpdateResponse copyWith(
          void Function(WorkflowServiceUpdateResponse) updates) =>
      super.copyWith(
              (message) => updates(message as WorkflowServiceUpdateResponse))
          as WorkflowServiceUpdateResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use WorkflowServiceUpdateResponse() / WorkflowServiceUpdateResponse.new instead')
  static WorkflowServiceUpdateResponse create() =>
      WorkflowServiceUpdateResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      WorkflowServiceUpdateResponse._();
  @$core.override
  WorkflowServiceUpdateResponse createEmptyInstance() =>
      WorkflowServiceUpdateResponse._();
  @$core.pragma('dart2js:noInline')
  static WorkflowServiceUpdateResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<WorkflowServiceUpdateResponse>(
          WorkflowServiceUpdateResponse.$_createMessage);
  static WorkflowServiceUpdateResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Workflow get workflow => $_getN(0);
  @$pb.TagNumber(1)
  set workflow(Workflow value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkflow() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkflow() => $_clearField(1);
  @$pb.TagNumber(1)
  Workflow ensureWorkflow() => $_ensure(0);
}

class WorkflowServiceActivateRequest extends $pb.GeneratedMessage {
  factory WorkflowServiceActivateRequest({
    $core.String? idempotencyKey,
    $core.String? workspaceId,
    $core.String? workflowId,
  }) {
    final result = WorkflowServiceActivateRequest._();
    if (idempotencyKey != null) result.idempotencyKey = idempotencyKey;
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (workflowId != null) result.workflowId = workflowId;
    return result;
  }

  WorkflowServiceActivateRequest._();

  factory WorkflowServiceActivateRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      WorkflowServiceActivateRequest()..mergeFromBuffer(data, registry);
  factory WorkflowServiceActivateRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      WorkflowServiceActivateRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'WorkflowServiceActivateRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.automation.v1'),
      createEmptyInstance: WorkflowServiceActivateRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'idempotencyKey')
    ..aOS(2, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(3, _omitFieldNames ? '' : 'workflowId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WorkflowServiceActivateRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WorkflowServiceActivateRequest copyWith(
          void Function(WorkflowServiceActivateRequest) updates) =>
      super.copyWith(
              (message) => updates(message as WorkflowServiceActivateRequest))
          as WorkflowServiceActivateRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use WorkflowServiceActivateRequest() / WorkflowServiceActivateRequest.new instead')
  static WorkflowServiceActivateRequest create() =>
      WorkflowServiceActivateRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      WorkflowServiceActivateRequest._();
  @$core.override
  WorkflowServiceActivateRequest createEmptyInstance() =>
      WorkflowServiceActivateRequest._();
  @$core.pragma('dart2js:noInline')
  static WorkflowServiceActivateRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<WorkflowServiceActivateRequest>(
          WorkflowServiceActivateRequest.$_createMessage);
  static WorkflowServiceActivateRequest? _defaultInstance;

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
  $core.String get workflowId => $_getSZ(2);
  @$pb.TagNumber(3)
  set workflowId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasWorkflowId() => $_has(2);
  @$pb.TagNumber(3)
  void clearWorkflowId() => $_clearField(3);
}

class WorkflowServiceActivateResponse extends $pb.GeneratedMessage {
  factory WorkflowServiceActivateResponse({
    Workflow? workflow,
  }) {
    final result = WorkflowServiceActivateResponse._();
    if (workflow != null) result.workflow = workflow;
    return result;
  }

  WorkflowServiceActivateResponse._();

  factory WorkflowServiceActivateResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      WorkflowServiceActivateResponse()..mergeFromBuffer(data, registry);
  factory WorkflowServiceActivateResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      WorkflowServiceActivateResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'WorkflowServiceActivateResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.automation.v1'),
      createEmptyInstance: WorkflowServiceActivateResponse.$_createMessage)
    ..aOM<Workflow>(1, _omitFieldNames ? '' : 'workflow',
        subBuilder: Workflow.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WorkflowServiceActivateResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WorkflowServiceActivateResponse copyWith(
          void Function(WorkflowServiceActivateResponse) updates) =>
      super.copyWith(
              (message) => updates(message as WorkflowServiceActivateResponse))
          as WorkflowServiceActivateResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use WorkflowServiceActivateResponse() / WorkflowServiceActivateResponse.new instead')
  static WorkflowServiceActivateResponse create() =>
      WorkflowServiceActivateResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      WorkflowServiceActivateResponse._();
  @$core.override
  WorkflowServiceActivateResponse createEmptyInstance() =>
      WorkflowServiceActivateResponse._();
  @$core.pragma('dart2js:noInline')
  static WorkflowServiceActivateResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<WorkflowServiceActivateResponse>(
          WorkflowServiceActivateResponse.$_createMessage);
  static WorkflowServiceActivateResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Workflow get workflow => $_getN(0);
  @$pb.TagNumber(1)
  set workflow(Workflow value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkflow() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkflow() => $_clearField(1);
  @$pb.TagNumber(1)
  Workflow ensureWorkflow() => $_ensure(0);
}

class WorkflowServiceDeactivateRequest extends $pb.GeneratedMessage {
  factory WorkflowServiceDeactivateRequest({
    $core.String? idempotencyKey,
    $core.String? workspaceId,
    $core.String? workflowId,
  }) {
    final result = WorkflowServiceDeactivateRequest._();
    if (idempotencyKey != null) result.idempotencyKey = idempotencyKey;
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (workflowId != null) result.workflowId = workflowId;
    return result;
  }

  WorkflowServiceDeactivateRequest._();

  factory WorkflowServiceDeactivateRequest.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      WorkflowServiceDeactivateRequest()..mergeFromBuffer(data, registry);
  factory WorkflowServiceDeactivateRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      WorkflowServiceDeactivateRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'WorkflowServiceDeactivateRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.automation.v1'),
      createEmptyInstance: WorkflowServiceDeactivateRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'idempotencyKey')
    ..aOS(2, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(3, _omitFieldNames ? '' : 'workflowId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WorkflowServiceDeactivateRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WorkflowServiceDeactivateRequest copyWith(
          void Function(WorkflowServiceDeactivateRequest) updates) =>
      super.copyWith(
              (message) => updates(message as WorkflowServiceDeactivateRequest))
          as WorkflowServiceDeactivateRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use WorkflowServiceDeactivateRequest() / WorkflowServiceDeactivateRequest.new instead')
  static WorkflowServiceDeactivateRequest create() =>
      WorkflowServiceDeactivateRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      WorkflowServiceDeactivateRequest._();
  @$core.override
  WorkflowServiceDeactivateRequest createEmptyInstance() =>
      WorkflowServiceDeactivateRequest._();
  @$core.pragma('dart2js:noInline')
  static WorkflowServiceDeactivateRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<WorkflowServiceDeactivateRequest>(
          WorkflowServiceDeactivateRequest.$_createMessage);
  static WorkflowServiceDeactivateRequest? _defaultInstance;

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
  $core.String get workflowId => $_getSZ(2);
  @$pb.TagNumber(3)
  set workflowId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasWorkflowId() => $_has(2);
  @$pb.TagNumber(3)
  void clearWorkflowId() => $_clearField(3);
}

class WorkflowServiceDeactivateResponse extends $pb.GeneratedMessage {
  factory WorkflowServiceDeactivateResponse({
    Workflow? workflow,
  }) {
    final result = WorkflowServiceDeactivateResponse._();
    if (workflow != null) result.workflow = workflow;
    return result;
  }

  WorkflowServiceDeactivateResponse._();

  factory WorkflowServiceDeactivateResponse.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      WorkflowServiceDeactivateResponse()..mergeFromBuffer(data, registry);
  factory WorkflowServiceDeactivateResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      WorkflowServiceDeactivateResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'WorkflowServiceDeactivateResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.automation.v1'),
      createEmptyInstance: WorkflowServiceDeactivateResponse.$_createMessage)
    ..aOM<Workflow>(1, _omitFieldNames ? '' : 'workflow',
        subBuilder: Workflow.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WorkflowServiceDeactivateResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WorkflowServiceDeactivateResponse copyWith(
          void Function(WorkflowServiceDeactivateResponse) updates) =>
      super.copyWith((message) =>
              updates(message as WorkflowServiceDeactivateResponse))
          as WorkflowServiceDeactivateResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use WorkflowServiceDeactivateResponse() / WorkflowServiceDeactivateResponse.new instead')
  static WorkflowServiceDeactivateResponse create() =>
      WorkflowServiceDeactivateResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      WorkflowServiceDeactivateResponse._();
  @$core.override
  WorkflowServiceDeactivateResponse createEmptyInstance() =>
      WorkflowServiceDeactivateResponse._();
  @$core.pragma('dart2js:noInline')
  static WorkflowServiceDeactivateResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<WorkflowServiceDeactivateResponse>(
          WorkflowServiceDeactivateResponse.$_createMessage);
  static WorkflowServiceDeactivateResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Workflow get workflow => $_getN(0);
  @$pb.TagNumber(1)
  set workflow(Workflow value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkflow() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkflow() => $_clearField(1);
  @$pb.TagNumber(1)
  Workflow ensureWorkflow() => $_ensure(0);
}

class WorkflowServiceRunRequest extends $pb.GeneratedMessage {
  factory WorkflowServiceRunRequest({
    $core.String? idempotencyKey,
    $core.String? workspaceId,
    $core.String? workflowId,
    $core.String? triggerContextJson,
  }) {
    final result = WorkflowServiceRunRequest._();
    if (idempotencyKey != null) result.idempotencyKey = idempotencyKey;
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (workflowId != null) result.workflowId = workflowId;
    if (triggerContextJson != null)
      result.triggerContextJson = triggerContextJson;
    return result;
  }

  WorkflowServiceRunRequest._();

  factory WorkflowServiceRunRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      WorkflowServiceRunRequest()..mergeFromBuffer(data, registry);
  factory WorkflowServiceRunRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      WorkflowServiceRunRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'WorkflowServiceRunRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.automation.v1'),
      createEmptyInstance: WorkflowServiceRunRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'idempotencyKey')
    ..aOS(2, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(3, _omitFieldNames ? '' : 'workflowId')
    ..aOS(4, _omitFieldNames ? '' : 'triggerContextJson')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WorkflowServiceRunRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WorkflowServiceRunRequest copyWith(
          void Function(WorkflowServiceRunRequest) updates) =>
      super.copyWith((message) => updates(message as WorkflowServiceRunRequest))
          as WorkflowServiceRunRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use WorkflowServiceRunRequest() / WorkflowServiceRunRequest.new instead')
  static WorkflowServiceRunRequest create() => WorkflowServiceRunRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      WorkflowServiceRunRequest._();
  @$core.override
  WorkflowServiceRunRequest createEmptyInstance() =>
      WorkflowServiceRunRequest._();
  @$core.pragma('dart2js:noInline')
  static WorkflowServiceRunRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<WorkflowServiceRunRequest>(
          WorkflowServiceRunRequest.$_createMessage);
  static WorkflowServiceRunRequest? _defaultInstance;

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
  $core.String get workflowId => $_getSZ(2);
  @$pb.TagNumber(3)
  set workflowId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasWorkflowId() => $_has(2);
  @$pb.TagNumber(3)
  void clearWorkflowId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get triggerContextJson => $_getSZ(3);
  @$pb.TagNumber(4)
  set triggerContextJson($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasTriggerContextJson() => $_has(3);
  @$pb.TagNumber(4)
  void clearTriggerContextJson() => $_clearField(4);
}

class WorkflowServiceRunResponse extends $pb.GeneratedMessage {
  factory WorkflowServiceRunResponse({
    $core.String? runId,
    $core.String? workflowId,
    $core.String? status,
    $core.String? currentNode,
    $1.Timestamp? createdAt,
    WorkflowRun? run,
  }) {
    final result = WorkflowServiceRunResponse._();
    if (runId != null) result.runId = runId;
    if (workflowId != null) result.workflowId = workflowId;
    if (status != null) result.status = status;
    if (currentNode != null) result.currentNode = currentNode;
    if (createdAt != null) result.createdAt = createdAt;
    if (run != null) result.run = run;
    return result;
  }

  WorkflowServiceRunResponse._();

  factory WorkflowServiceRunResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      WorkflowServiceRunResponse()..mergeFromBuffer(data, registry);
  factory WorkflowServiceRunResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      WorkflowServiceRunResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'WorkflowServiceRunResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.automation.v1'),
      createEmptyInstance: WorkflowServiceRunResponse.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'runId')
    ..aOS(2, _omitFieldNames ? '' : 'workflowId')
    ..aOS(3, _omitFieldNames ? '' : 'status')
    ..aOS(4, _omitFieldNames ? '' : 'currentNode')
    ..aOM<$1.Timestamp>(5, _omitFieldNames ? '' : 'createdAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..aOM<WorkflowRun>(6, _omitFieldNames ? '' : 'run',
        subBuilder: WorkflowRun.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WorkflowServiceRunResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WorkflowServiceRunResponse copyWith(
          void Function(WorkflowServiceRunResponse) updates) =>
      super.copyWith(
              (message) => updates(message as WorkflowServiceRunResponse))
          as WorkflowServiceRunResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use WorkflowServiceRunResponse() / WorkflowServiceRunResponse.new instead')
  static WorkflowServiceRunResponse create() => WorkflowServiceRunResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      WorkflowServiceRunResponse._();
  @$core.override
  WorkflowServiceRunResponse createEmptyInstance() =>
      WorkflowServiceRunResponse._();
  @$core.pragma('dart2js:noInline')
  static WorkflowServiceRunResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<WorkflowServiceRunResponse>(
          WorkflowServiceRunResponse.$_createMessage);
  static WorkflowServiceRunResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get runId => $_getSZ(0);
  @$pb.TagNumber(1)
  set runId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRunId() => $_has(0);
  @$pb.TagNumber(1)
  void clearRunId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get workflowId => $_getSZ(1);
  @$pb.TagNumber(2)
  set workflowId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasWorkflowId() => $_has(1);
  @$pb.TagNumber(2)
  void clearWorkflowId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get status => $_getSZ(2);
  @$pb.TagNumber(3)
  set status($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasStatus() => $_has(2);
  @$pb.TagNumber(3)
  void clearStatus() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get currentNode => $_getSZ(3);
  @$pb.TagNumber(4)
  set currentNode($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasCurrentNode() => $_has(3);
  @$pb.TagNumber(4)
  void clearCurrentNode() => $_clearField(4);

  @$pb.TagNumber(5)
  $1.Timestamp get createdAt => $_getN(4);
  @$pb.TagNumber(5)
  set createdAt($1.Timestamp value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasCreatedAt() => $_has(4);
  @$pb.TagNumber(5)
  void clearCreatedAt() => $_clearField(5);
  @$pb.TagNumber(5)
  $1.Timestamp ensureCreatedAt() => $_ensure(4);

  @$pb.TagNumber(6)
  WorkflowRun get run => $_getN(5);
  @$pb.TagNumber(6)
  set run(WorkflowRun value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasRun() => $_has(5);
  @$pb.TagNumber(6)
  void clearRun() => $_clearField(6);
  @$pb.TagNumber(6)
  WorkflowRun ensureRun() => $_ensure(5);
}

class WorkflowServiceGetRunDetailRequest extends $pb.GeneratedMessage {
  factory WorkflowServiceGetRunDetailRequest({
    $core.String? workspaceId,
    $core.String? runId,
  }) {
    final result = WorkflowServiceGetRunDetailRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (runId != null) result.runId = runId;
    return result;
  }

  WorkflowServiceGetRunDetailRequest._();

  factory WorkflowServiceGetRunDetailRequest.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      WorkflowServiceGetRunDetailRequest()..mergeFromBuffer(data, registry);
  factory WorkflowServiceGetRunDetailRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      WorkflowServiceGetRunDetailRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'WorkflowServiceGetRunDetailRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.automation.v1'),
      createEmptyInstance: WorkflowServiceGetRunDetailRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'runId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WorkflowServiceGetRunDetailRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WorkflowServiceGetRunDetailRequest copyWith(
          void Function(WorkflowServiceGetRunDetailRequest) updates) =>
      super.copyWith((message) =>
              updates(message as WorkflowServiceGetRunDetailRequest))
          as WorkflowServiceGetRunDetailRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use WorkflowServiceGetRunDetailRequest() / WorkflowServiceGetRunDetailRequest.new instead')
  static WorkflowServiceGetRunDetailRequest create() =>
      WorkflowServiceGetRunDetailRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      WorkflowServiceGetRunDetailRequest._();
  @$core.override
  WorkflowServiceGetRunDetailRequest createEmptyInstance() =>
      WorkflowServiceGetRunDetailRequest._();
  @$core.pragma('dart2js:noInline')
  static WorkflowServiceGetRunDetailRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<WorkflowServiceGetRunDetailRequest>(
          WorkflowServiceGetRunDetailRequest.$_createMessage);
  static WorkflowServiceGetRunDetailRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get runId => $_getSZ(1);
  @$pb.TagNumber(2)
  set runId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasRunId() => $_has(1);
  @$pb.TagNumber(2)
  void clearRunId() => $_clearField(2);
}

class WorkflowServiceGetRunDetailResponse extends $pb.GeneratedMessage {
  factory WorkflowServiceGetRunDetailResponse({
    WorkflowRun? run,
    $core.Iterable<WorkflowRunStep>? steps,
  }) {
    final result = WorkflowServiceGetRunDetailResponse._();
    if (run != null) result.run = run;
    if (steps != null) result.steps.addAll(steps);
    return result;
  }

  WorkflowServiceGetRunDetailResponse._();

  factory WorkflowServiceGetRunDetailResponse.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      WorkflowServiceGetRunDetailResponse()..mergeFromBuffer(data, registry);
  factory WorkflowServiceGetRunDetailResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      WorkflowServiceGetRunDetailResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'WorkflowServiceGetRunDetailResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.automation.v1'),
      createEmptyInstance: WorkflowServiceGetRunDetailResponse.$_createMessage)
    ..aOM<WorkflowRun>(1, _omitFieldNames ? '' : 'run',
        subBuilder: WorkflowRun.$_createMessage)
    ..pPM<WorkflowRunStep>(2, _omitFieldNames ? '' : 'steps',
        subBuilder: WorkflowRunStep.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WorkflowServiceGetRunDetailResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WorkflowServiceGetRunDetailResponse copyWith(
          void Function(WorkflowServiceGetRunDetailResponse) updates) =>
      super.copyWith((message) =>
              updates(message as WorkflowServiceGetRunDetailResponse))
          as WorkflowServiceGetRunDetailResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use WorkflowServiceGetRunDetailResponse() / WorkflowServiceGetRunDetailResponse.new instead')
  static WorkflowServiceGetRunDetailResponse create() =>
      WorkflowServiceGetRunDetailResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      WorkflowServiceGetRunDetailResponse._();
  @$core.override
  WorkflowServiceGetRunDetailResponse createEmptyInstance() =>
      WorkflowServiceGetRunDetailResponse._();
  @$core.pragma('dart2js:noInline')
  static WorkflowServiceGetRunDetailResponse getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
              WorkflowServiceGetRunDetailResponse>(
          WorkflowServiceGetRunDetailResponse.$_createMessage);
  static WorkflowServiceGetRunDetailResponse? _defaultInstance;

  @$pb.TagNumber(1)
  WorkflowRun get run => $_getN(0);
  @$pb.TagNumber(1)
  set run(WorkflowRun value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasRun() => $_has(0);
  @$pb.TagNumber(1)
  void clearRun() => $_clearField(1);
  @$pb.TagNumber(1)
  WorkflowRun ensureRun() => $_ensure(0);

  @$pb.TagNumber(2)
  $pb.PbList<WorkflowRunStep> get steps => $_getList(1);
}

class WorkflowServiceGetRunLogsRequest extends $pb.GeneratedMessage {
  factory WorkflowServiceGetRunLogsRequest({
    $core.String? workspaceId,
    $core.String? runId,
  }) {
    final result = WorkflowServiceGetRunLogsRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (runId != null) result.runId = runId;
    return result;
  }

  WorkflowServiceGetRunLogsRequest._();

  factory WorkflowServiceGetRunLogsRequest.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      WorkflowServiceGetRunLogsRequest()..mergeFromBuffer(data, registry);
  factory WorkflowServiceGetRunLogsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      WorkflowServiceGetRunLogsRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'WorkflowServiceGetRunLogsRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.automation.v1'),
      createEmptyInstance: WorkflowServiceGetRunLogsRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'runId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WorkflowServiceGetRunLogsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WorkflowServiceGetRunLogsRequest copyWith(
          void Function(WorkflowServiceGetRunLogsRequest) updates) =>
      super.copyWith(
              (message) => updates(message as WorkflowServiceGetRunLogsRequest))
          as WorkflowServiceGetRunLogsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use WorkflowServiceGetRunLogsRequest() / WorkflowServiceGetRunLogsRequest.new instead')
  static WorkflowServiceGetRunLogsRequest create() =>
      WorkflowServiceGetRunLogsRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      WorkflowServiceGetRunLogsRequest._();
  @$core.override
  WorkflowServiceGetRunLogsRequest createEmptyInstance() =>
      WorkflowServiceGetRunLogsRequest._();
  @$core.pragma('dart2js:noInline')
  static WorkflowServiceGetRunLogsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<WorkflowServiceGetRunLogsRequest>(
          WorkflowServiceGetRunLogsRequest.$_createMessage);
  static WorkflowServiceGetRunLogsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get runId => $_getSZ(1);
  @$pb.TagNumber(2)
  set runId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasRunId() => $_has(1);
  @$pb.TagNumber(2)
  void clearRunId() => $_clearField(2);
}

class WorkflowServiceGetRunLogsResponse extends $pb.GeneratedMessage {
  factory WorkflowServiceGetRunLogsResponse({
    $core.String? executionLogJson,
    $core.Iterable<WorkflowRunStep>? steps,
  }) {
    final result = WorkflowServiceGetRunLogsResponse._();
    if (executionLogJson != null) result.executionLogJson = executionLogJson;
    if (steps != null) result.steps.addAll(steps);
    return result;
  }

  WorkflowServiceGetRunLogsResponse._();

  factory WorkflowServiceGetRunLogsResponse.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      WorkflowServiceGetRunLogsResponse()..mergeFromBuffer(data, registry);
  factory WorkflowServiceGetRunLogsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      WorkflowServiceGetRunLogsResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'WorkflowServiceGetRunLogsResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.automation.v1'),
      createEmptyInstance: WorkflowServiceGetRunLogsResponse.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'executionLogJson')
    ..pPM<WorkflowRunStep>(2, _omitFieldNames ? '' : 'steps',
        subBuilder: WorkflowRunStep.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WorkflowServiceGetRunLogsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WorkflowServiceGetRunLogsResponse copyWith(
          void Function(WorkflowServiceGetRunLogsResponse) updates) =>
      super.copyWith((message) =>
              updates(message as WorkflowServiceGetRunLogsResponse))
          as WorkflowServiceGetRunLogsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use WorkflowServiceGetRunLogsResponse() / WorkflowServiceGetRunLogsResponse.new instead')
  static WorkflowServiceGetRunLogsResponse create() =>
      WorkflowServiceGetRunLogsResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      WorkflowServiceGetRunLogsResponse._();
  @$core.override
  WorkflowServiceGetRunLogsResponse createEmptyInstance() =>
      WorkflowServiceGetRunLogsResponse._();
  @$core.pragma('dart2js:noInline')
  static WorkflowServiceGetRunLogsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<WorkflowServiceGetRunLogsResponse>(
          WorkflowServiceGetRunLogsResponse.$_createMessage);
  static WorkflowServiceGetRunLogsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get executionLogJson => $_getSZ(0);
  @$pb.TagNumber(1)
  set executionLogJson($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasExecutionLogJson() => $_has(0);
  @$pb.TagNumber(1)
  void clearExecutionLogJson() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbList<WorkflowRunStep> get steps => $_getList(1);
}

class WorkflowServiceListRunsRequest extends $pb.GeneratedMessage {
  factory WorkflowServiceListRunsRequest({
    $core.String? workspaceId,
    $core.String? workflowId,
    $core.String? status,
    $core.int? limit,
    $core.int? offset,
  }) {
    final result = WorkflowServiceListRunsRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (workflowId != null) result.workflowId = workflowId;
    if (status != null) result.status = status;
    if (limit != null) result.limit = limit;
    if (offset != null) result.offset = offset;
    return result;
  }

  WorkflowServiceListRunsRequest._();

  factory WorkflowServiceListRunsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      WorkflowServiceListRunsRequest()..mergeFromBuffer(data, registry);
  factory WorkflowServiceListRunsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      WorkflowServiceListRunsRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'WorkflowServiceListRunsRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.automation.v1'),
      createEmptyInstance: WorkflowServiceListRunsRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'workflowId')
    ..aOS(3, _omitFieldNames ? '' : 'status')
    ..aI(4, _omitFieldNames ? '' : 'limit')
    ..aI(5, _omitFieldNames ? '' : 'offset')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WorkflowServiceListRunsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WorkflowServiceListRunsRequest copyWith(
          void Function(WorkflowServiceListRunsRequest) updates) =>
      super.copyWith(
              (message) => updates(message as WorkflowServiceListRunsRequest))
          as WorkflowServiceListRunsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use WorkflowServiceListRunsRequest() / WorkflowServiceListRunsRequest.new instead')
  static WorkflowServiceListRunsRequest create() =>
      WorkflowServiceListRunsRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      WorkflowServiceListRunsRequest._();
  @$core.override
  WorkflowServiceListRunsRequest createEmptyInstance() =>
      WorkflowServiceListRunsRequest._();
  @$core.pragma('dart2js:noInline')
  static WorkflowServiceListRunsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<WorkflowServiceListRunsRequest>(
          WorkflowServiceListRunsRequest.$_createMessage);
  static WorkflowServiceListRunsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get workflowId => $_getSZ(1);
  @$pb.TagNumber(2)
  set workflowId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasWorkflowId() => $_has(1);
  @$pb.TagNumber(2)
  void clearWorkflowId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get status => $_getSZ(2);
  @$pb.TagNumber(3)
  set status($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasStatus() => $_has(2);
  @$pb.TagNumber(3)
  void clearStatus() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get limit => $_getIZ(3);
  @$pb.TagNumber(4)
  set limit($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasLimit() => $_has(3);
  @$pb.TagNumber(4)
  void clearLimit() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get offset => $_getIZ(4);
  @$pb.TagNumber(5)
  set offset($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasOffset() => $_has(4);
  @$pb.TagNumber(5)
  void clearOffset() => $_clearField(5);
}

class WorkflowServiceListRunsResponse extends $pb.GeneratedMessage {
  factory WorkflowServiceListRunsResponse({
    $core.Iterable<WorkflowRun>? runs,
    $core.int? totalCount,
  }) {
    final result = WorkflowServiceListRunsResponse._();
    if (runs != null) result.runs.addAll(runs);
    if (totalCount != null) result.totalCount = totalCount;
    return result;
  }

  WorkflowServiceListRunsResponse._();

  factory WorkflowServiceListRunsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      WorkflowServiceListRunsResponse()..mergeFromBuffer(data, registry);
  factory WorkflowServiceListRunsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      WorkflowServiceListRunsResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'WorkflowServiceListRunsResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.automation.v1'),
      createEmptyInstance: WorkflowServiceListRunsResponse.$_createMessage)
    ..pPM<WorkflowRun>(1, _omitFieldNames ? '' : 'runs',
        subBuilder: WorkflowRun.$_createMessage)
    ..aI(2, _omitFieldNames ? '' : 'totalCount')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WorkflowServiceListRunsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WorkflowServiceListRunsResponse copyWith(
          void Function(WorkflowServiceListRunsResponse) updates) =>
      super.copyWith(
              (message) => updates(message as WorkflowServiceListRunsResponse))
          as WorkflowServiceListRunsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use WorkflowServiceListRunsResponse() / WorkflowServiceListRunsResponse.new instead')
  static WorkflowServiceListRunsResponse create() =>
      WorkflowServiceListRunsResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      WorkflowServiceListRunsResponse._();
  @$core.override
  WorkflowServiceListRunsResponse createEmptyInstance() =>
      WorkflowServiceListRunsResponse._();
  @$core.pragma('dart2js:noInline')
  static WorkflowServiceListRunsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<WorkflowServiceListRunsResponse>(
          WorkflowServiceListRunsResponse.$_createMessage);
  static WorkflowServiceListRunsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<WorkflowRun> get runs => $_getList(0);

  @$pb.TagNumber(2)
  $core.int get totalCount => $_getIZ(1);
  @$pb.TagNumber(2)
  set totalCount($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTotalCount() => $_has(1);
  @$pb.TagNumber(2)
  void clearTotalCount() => $_clearField(2);
}

class WorkflowServiceCloneRequest extends $pb.GeneratedMessage {
  factory WorkflowServiceCloneRequest({
    $core.String? idempotencyKey,
    $core.String? workspaceId,
    $core.String? workflowId,
    $core.String? newTitle,
  }) {
    final result = WorkflowServiceCloneRequest._();
    if (idempotencyKey != null) result.idempotencyKey = idempotencyKey;
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (workflowId != null) result.workflowId = workflowId;
    if (newTitle != null) result.newTitle = newTitle;
    return result;
  }

  WorkflowServiceCloneRequest._();

  factory WorkflowServiceCloneRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      WorkflowServiceCloneRequest()..mergeFromBuffer(data, registry);
  factory WorkflowServiceCloneRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      WorkflowServiceCloneRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'WorkflowServiceCloneRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.automation.v1'),
      createEmptyInstance: WorkflowServiceCloneRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'idempotencyKey')
    ..aOS(2, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(3, _omitFieldNames ? '' : 'workflowId')
    ..aOS(4, _omitFieldNames ? '' : 'newTitle')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WorkflowServiceCloneRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WorkflowServiceCloneRequest copyWith(
          void Function(WorkflowServiceCloneRequest) updates) =>
      super.copyWith(
              (message) => updates(message as WorkflowServiceCloneRequest))
          as WorkflowServiceCloneRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use WorkflowServiceCloneRequest() / WorkflowServiceCloneRequest.new instead')
  static WorkflowServiceCloneRequest create() =>
      WorkflowServiceCloneRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      WorkflowServiceCloneRequest._();
  @$core.override
  WorkflowServiceCloneRequest createEmptyInstance() =>
      WorkflowServiceCloneRequest._();
  @$core.pragma('dart2js:noInline')
  static WorkflowServiceCloneRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<WorkflowServiceCloneRequest>(
          WorkflowServiceCloneRequest.$_createMessage);
  static WorkflowServiceCloneRequest? _defaultInstance;

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
  $core.String get workflowId => $_getSZ(2);
  @$pb.TagNumber(3)
  set workflowId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasWorkflowId() => $_has(2);
  @$pb.TagNumber(3)
  void clearWorkflowId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get newTitle => $_getSZ(3);
  @$pb.TagNumber(4)
  set newTitle($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasNewTitle() => $_has(3);
  @$pb.TagNumber(4)
  void clearNewTitle() => $_clearField(4);
}

class WorkflowServiceCloneResponse extends $pb.GeneratedMessage {
  factory WorkflowServiceCloneResponse({
    Workflow? workflow,
  }) {
    final result = WorkflowServiceCloneResponse._();
    if (workflow != null) result.workflow = workflow;
    return result;
  }

  WorkflowServiceCloneResponse._();

  factory WorkflowServiceCloneResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      WorkflowServiceCloneResponse()..mergeFromBuffer(data, registry);
  factory WorkflowServiceCloneResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      WorkflowServiceCloneResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'WorkflowServiceCloneResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.automation.v1'),
      createEmptyInstance: WorkflowServiceCloneResponse.$_createMessage)
    ..aOM<Workflow>(1, _omitFieldNames ? '' : 'workflow',
        subBuilder: Workflow.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WorkflowServiceCloneResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WorkflowServiceCloneResponse copyWith(
          void Function(WorkflowServiceCloneResponse) updates) =>
      super.copyWith(
              (message) => updates(message as WorkflowServiceCloneResponse))
          as WorkflowServiceCloneResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use WorkflowServiceCloneResponse() / WorkflowServiceCloneResponse.new instead')
  static WorkflowServiceCloneResponse create() =>
      WorkflowServiceCloneResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      WorkflowServiceCloneResponse._();
  @$core.override
  WorkflowServiceCloneResponse createEmptyInstance() =>
      WorkflowServiceCloneResponse._();
  @$core.pragma('dart2js:noInline')
  static WorkflowServiceCloneResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<WorkflowServiceCloneResponse>(
          WorkflowServiceCloneResponse.$_createMessage);
  static WorkflowServiceCloneResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Workflow get workflow => $_getN(0);
  @$pb.TagNumber(1)
  set workflow(Workflow value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkflow() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkflow() => $_clearField(1);
  @$pb.TagNumber(1)
  Workflow ensureWorkflow() => $_ensure(0);
}

class WorkflowServiceExportRequest extends $pb.GeneratedMessage {
  factory WorkflowServiceExportRequest({
    $core.String? workspaceId,
    $core.String? workflowId,
  }) {
    final result = WorkflowServiceExportRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (workflowId != null) result.workflowId = workflowId;
    return result;
  }

  WorkflowServiceExportRequest._();

  factory WorkflowServiceExportRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      WorkflowServiceExportRequest()..mergeFromBuffer(data, registry);
  factory WorkflowServiceExportRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      WorkflowServiceExportRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'WorkflowServiceExportRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.automation.v1'),
      createEmptyInstance: WorkflowServiceExportRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'workflowId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WorkflowServiceExportRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WorkflowServiceExportRequest copyWith(
          void Function(WorkflowServiceExportRequest) updates) =>
      super.copyWith(
              (message) => updates(message as WorkflowServiceExportRequest))
          as WorkflowServiceExportRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use WorkflowServiceExportRequest() / WorkflowServiceExportRequest.new instead')
  static WorkflowServiceExportRequest create() =>
      WorkflowServiceExportRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      WorkflowServiceExportRequest._();
  @$core.override
  WorkflowServiceExportRequest createEmptyInstance() =>
      WorkflowServiceExportRequest._();
  @$core.pragma('dart2js:noInline')
  static WorkflowServiceExportRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<WorkflowServiceExportRequest>(
          WorkflowServiceExportRequest.$_createMessage);
  static WorkflowServiceExportRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get workflowId => $_getSZ(1);
  @$pb.TagNumber(2)
  set workflowId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasWorkflowId() => $_has(1);
  @$pb.TagNumber(2)
  void clearWorkflowId() => $_clearField(2);
}

class WorkflowServiceExportResponse extends $pb.GeneratedMessage {
  factory WorkflowServiceExportResponse({
    PortableWorkflowPayload? payload,
    $core.String? payloadJson,
  }) {
    final result = WorkflowServiceExportResponse._();
    if (payload != null) result.payload = payload;
    if (payloadJson != null) result.payloadJson = payloadJson;
    return result;
  }

  WorkflowServiceExportResponse._();

  factory WorkflowServiceExportResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      WorkflowServiceExportResponse()..mergeFromBuffer(data, registry);
  factory WorkflowServiceExportResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      WorkflowServiceExportResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'WorkflowServiceExportResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.automation.v1'),
      createEmptyInstance: WorkflowServiceExportResponse.$_createMessage)
    ..aOM<PortableWorkflowPayload>(1, _omitFieldNames ? '' : 'payload',
        subBuilder: PortableWorkflowPayload.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'payloadJson')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WorkflowServiceExportResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WorkflowServiceExportResponse copyWith(
          void Function(WorkflowServiceExportResponse) updates) =>
      super.copyWith(
              (message) => updates(message as WorkflowServiceExportResponse))
          as WorkflowServiceExportResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use WorkflowServiceExportResponse() / WorkflowServiceExportResponse.new instead')
  static WorkflowServiceExportResponse create() =>
      WorkflowServiceExportResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      WorkflowServiceExportResponse._();
  @$core.override
  WorkflowServiceExportResponse createEmptyInstance() =>
      WorkflowServiceExportResponse._();
  @$core.pragma('dart2js:noInline')
  static WorkflowServiceExportResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<WorkflowServiceExportResponse>(
          WorkflowServiceExportResponse.$_createMessage);
  static WorkflowServiceExportResponse? _defaultInstance;

  @$pb.TagNumber(1)
  PortableWorkflowPayload get payload => $_getN(0);
  @$pb.TagNumber(1)
  set payload(PortableWorkflowPayload value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasPayload() => $_has(0);
  @$pb.TagNumber(1)
  void clearPayload() => $_clearField(1);
  @$pb.TagNumber(1)
  PortableWorkflowPayload ensurePayload() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get payloadJson => $_getSZ(1);
  @$pb.TagNumber(2)
  set payloadJson($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPayloadJson() => $_has(1);
  @$pb.TagNumber(2)
  void clearPayloadJson() => $_clearField(2);
}

class WorkflowServiceImportRequest extends $pb.GeneratedMessage {
  factory WorkflowServiceImportRequest({
    $core.String? idempotencyKey,
    $core.String? workspaceId,
    $core.String? payloadJson,
    PortableWorkflowPayload? payload,
  }) {
    final result = WorkflowServiceImportRequest._();
    if (idempotencyKey != null) result.idempotencyKey = idempotencyKey;
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (payloadJson != null) result.payloadJson = payloadJson;
    if (payload != null) result.payload = payload;
    return result;
  }

  WorkflowServiceImportRequest._();

  factory WorkflowServiceImportRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      WorkflowServiceImportRequest()..mergeFromBuffer(data, registry);
  factory WorkflowServiceImportRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      WorkflowServiceImportRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'WorkflowServiceImportRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.automation.v1'),
      createEmptyInstance: WorkflowServiceImportRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'idempotencyKey')
    ..aOS(2, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(3, _omitFieldNames ? '' : 'payloadJson')
    ..aOM<PortableWorkflowPayload>(4, _omitFieldNames ? '' : 'payload',
        subBuilder: PortableWorkflowPayload.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WorkflowServiceImportRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WorkflowServiceImportRequest copyWith(
          void Function(WorkflowServiceImportRequest) updates) =>
      super.copyWith(
              (message) => updates(message as WorkflowServiceImportRequest))
          as WorkflowServiceImportRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use WorkflowServiceImportRequest() / WorkflowServiceImportRequest.new instead')
  static WorkflowServiceImportRequest create() =>
      WorkflowServiceImportRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      WorkflowServiceImportRequest._();
  @$core.override
  WorkflowServiceImportRequest createEmptyInstance() =>
      WorkflowServiceImportRequest._();
  @$core.pragma('dart2js:noInline')
  static WorkflowServiceImportRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<WorkflowServiceImportRequest>(
          WorkflowServiceImportRequest.$_createMessage);
  static WorkflowServiceImportRequest? _defaultInstance;

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
  $core.String get payloadJson => $_getSZ(2);
  @$pb.TagNumber(3)
  set payloadJson($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPayloadJson() => $_has(2);
  @$pb.TagNumber(3)
  void clearPayloadJson() => $_clearField(3);

  @$pb.TagNumber(4)
  PortableWorkflowPayload get payload => $_getN(3);
  @$pb.TagNumber(4)
  set payload(PortableWorkflowPayload value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasPayload() => $_has(3);
  @$pb.TagNumber(4)
  void clearPayload() => $_clearField(4);
  @$pb.TagNumber(4)
  PortableWorkflowPayload ensurePayload() => $_ensure(3);
}

class WorkflowServiceImportResponse extends $pb.GeneratedMessage {
  factory WorkflowServiceImportResponse({
    Workflow? workflow,
  }) {
    final result = WorkflowServiceImportResponse._();
    if (workflow != null) result.workflow = workflow;
    return result;
  }

  WorkflowServiceImportResponse._();

  factory WorkflowServiceImportResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      WorkflowServiceImportResponse()..mergeFromBuffer(data, registry);
  factory WorkflowServiceImportResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      WorkflowServiceImportResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'WorkflowServiceImportResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.automation.v1'),
      createEmptyInstance: WorkflowServiceImportResponse.$_createMessage)
    ..aOM<Workflow>(1, _omitFieldNames ? '' : 'workflow',
        subBuilder: Workflow.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WorkflowServiceImportResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WorkflowServiceImportResponse copyWith(
          void Function(WorkflowServiceImportResponse) updates) =>
      super.copyWith(
              (message) => updates(message as WorkflowServiceImportResponse))
          as WorkflowServiceImportResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use WorkflowServiceImportResponse() / WorkflowServiceImportResponse.new instead')
  static WorkflowServiceImportResponse create() =>
      WorkflowServiceImportResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      WorkflowServiceImportResponse._();
  @$core.override
  WorkflowServiceImportResponse createEmptyInstance() =>
      WorkflowServiceImportResponse._();
  @$core.pragma('dart2js:noInline')
  static WorkflowServiceImportResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<WorkflowServiceImportResponse>(
          WorkflowServiceImportResponse.$_createMessage);
  static WorkflowServiceImportResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Workflow get workflow => $_getN(0);
  @$pb.TagNumber(1)
  set workflow(Workflow value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkflow() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkflow() => $_clearField(1);
  @$pb.TagNumber(1)
  Workflow ensureWorkflow() => $_ensure(0);
}

class WorkflowServiceTestRequest extends $pb.GeneratedMessage {
  factory WorkflowServiceTestRequest({
    $core.String? workspaceId,
    $core.String? workflowId,
    WorkflowGraph? draftGraph,
    $core.String? sampleContextJson,
  }) {
    final result = WorkflowServiceTestRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (workflowId != null) result.workflowId = workflowId;
    if (draftGraph != null) result.draftGraph = draftGraph;
    if (sampleContextJson != null) result.sampleContextJson = sampleContextJson;
    return result;
  }

  WorkflowServiceTestRequest._();

  factory WorkflowServiceTestRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      WorkflowServiceTestRequest()..mergeFromBuffer(data, registry);
  factory WorkflowServiceTestRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      WorkflowServiceTestRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'WorkflowServiceTestRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.automation.v1'),
      createEmptyInstance: WorkflowServiceTestRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'workflowId')
    ..aOM<WorkflowGraph>(3, _omitFieldNames ? '' : 'draftGraph',
        subBuilder: WorkflowGraph.$_createMessage)
    ..aOS(4, _omitFieldNames ? '' : 'sampleContextJson')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WorkflowServiceTestRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WorkflowServiceTestRequest copyWith(
          void Function(WorkflowServiceTestRequest) updates) =>
      super.copyWith(
              (message) => updates(message as WorkflowServiceTestRequest))
          as WorkflowServiceTestRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use WorkflowServiceTestRequest() / WorkflowServiceTestRequest.new instead')
  static WorkflowServiceTestRequest create() => WorkflowServiceTestRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      WorkflowServiceTestRequest._();
  @$core.override
  WorkflowServiceTestRequest createEmptyInstance() =>
      WorkflowServiceTestRequest._();
  @$core.pragma('dart2js:noInline')
  static WorkflowServiceTestRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<WorkflowServiceTestRequest>(
          WorkflowServiceTestRequest.$_createMessage);
  static WorkflowServiceTestRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get workflowId => $_getSZ(1);
  @$pb.TagNumber(2)
  set workflowId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasWorkflowId() => $_has(1);
  @$pb.TagNumber(2)
  void clearWorkflowId() => $_clearField(2);

  @$pb.TagNumber(3)
  WorkflowGraph get draftGraph => $_getN(2);
  @$pb.TagNumber(3)
  set draftGraph(WorkflowGraph value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasDraftGraph() => $_has(2);
  @$pb.TagNumber(3)
  void clearDraftGraph() => $_clearField(3);
  @$pb.TagNumber(3)
  WorkflowGraph ensureDraftGraph() => $_ensure(2);

  @$pb.TagNumber(4)
  $core.String get sampleContextJson => $_getSZ(3);
  @$pb.TagNumber(4)
  set sampleContextJson($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasSampleContextJson() => $_has(3);
  @$pb.TagNumber(4)
  void clearSampleContextJson() => $_clearField(4);
}

class WorkflowServiceTestStepResult extends $pb.GeneratedMessage {
  factory WorkflowServiceTestStepResult({
    $core.String? nodeId,
    NodeType? nodeType,
    $core.String? status,
    $core.String? simulatedOutputJson,
    $core.String? diagnosticMessage,
    $core.double? estimatedCredits,
  }) {
    final result = WorkflowServiceTestStepResult._();
    if (nodeId != null) result.nodeId = nodeId;
    if (nodeType != null) result.nodeType = nodeType;
    if (status != null) result.status = status;
    if (simulatedOutputJson != null)
      result.simulatedOutputJson = simulatedOutputJson;
    if (diagnosticMessage != null) result.diagnosticMessage = diagnosticMessage;
    if (estimatedCredits != null) result.estimatedCredits = estimatedCredits;
    return result;
  }

  WorkflowServiceTestStepResult._();

  factory WorkflowServiceTestStepResult.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      WorkflowServiceTestStepResult()..mergeFromBuffer(data, registry);
  factory WorkflowServiceTestStepResult.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      WorkflowServiceTestStepResult()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'WorkflowServiceTestStepResult',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.automation.v1'),
      createEmptyInstance: WorkflowServiceTestStepResult.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'nodeId')
    ..aE<NodeType>(2, _omitFieldNames ? '' : 'nodeType',
        enumValues: NodeType.values)
    ..aOS(3, _omitFieldNames ? '' : 'status')
    ..aOS(4, _omitFieldNames ? '' : 'simulatedOutputJson')
    ..aOS(5, _omitFieldNames ? '' : 'diagnosticMessage')
    ..aD(6, _omitFieldNames ? '' : 'estimatedCredits')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WorkflowServiceTestStepResult clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WorkflowServiceTestStepResult copyWith(
          void Function(WorkflowServiceTestStepResult) updates) =>
      super.copyWith(
              (message) => updates(message as WorkflowServiceTestStepResult))
          as WorkflowServiceTestStepResult;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use WorkflowServiceTestStepResult() / WorkflowServiceTestStepResult.new instead')
  static WorkflowServiceTestStepResult create() =>
      WorkflowServiceTestStepResult._();
  static $pb.GeneratedMessage $_createMessage() =>
      WorkflowServiceTestStepResult._();
  @$core.override
  WorkflowServiceTestStepResult createEmptyInstance() =>
      WorkflowServiceTestStepResult._();
  @$core.pragma('dart2js:noInline')
  static WorkflowServiceTestStepResult getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<WorkflowServiceTestStepResult>(
          WorkflowServiceTestStepResult.$_createMessage);
  static WorkflowServiceTestStepResult? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get nodeId => $_getSZ(0);
  @$pb.TagNumber(1)
  set nodeId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasNodeId() => $_has(0);
  @$pb.TagNumber(1)
  void clearNodeId() => $_clearField(1);

  @$pb.TagNumber(2)
  NodeType get nodeType => $_getN(1);
  @$pb.TagNumber(2)
  set nodeType(NodeType value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasNodeType() => $_has(1);
  @$pb.TagNumber(2)
  void clearNodeType() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get status => $_getSZ(2);
  @$pb.TagNumber(3)
  set status($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasStatus() => $_has(2);
  @$pb.TagNumber(3)
  void clearStatus() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get simulatedOutputJson => $_getSZ(3);
  @$pb.TagNumber(4)
  set simulatedOutputJson($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasSimulatedOutputJson() => $_has(3);
  @$pb.TagNumber(4)
  void clearSimulatedOutputJson() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get diagnosticMessage => $_getSZ(4);
  @$pb.TagNumber(5)
  set diagnosticMessage($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasDiagnosticMessage() => $_has(4);
  @$pb.TagNumber(5)
  void clearDiagnosticMessage() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.double get estimatedCredits => $_getN(5);
  @$pb.TagNumber(6)
  set estimatedCredits($core.double value) => $_setDouble(5, value);
  @$pb.TagNumber(6)
  $core.bool hasEstimatedCredits() => $_has(5);
  @$pb.TagNumber(6)
  void clearEstimatedCredits() => $_clearField(6);
}

class WorkflowServiceTestResponse extends $pb.GeneratedMessage {
  factory WorkflowServiceTestResponse({
    $core.bool? success,
    $core.Iterable<WorkflowServiceTestStepResult>? stepResults,
    $core.double? totalEstimatedCredits,
    $core.String? simulationSummary,
  }) {
    final result = WorkflowServiceTestResponse._();
    if (success != null) result.success = success;
    if (stepResults != null) result.stepResults.addAll(stepResults);
    if (totalEstimatedCredits != null)
      result.totalEstimatedCredits = totalEstimatedCredits;
    if (simulationSummary != null) result.simulationSummary = simulationSummary;
    return result;
  }

  WorkflowServiceTestResponse._();

  factory WorkflowServiceTestResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      WorkflowServiceTestResponse()..mergeFromBuffer(data, registry);
  factory WorkflowServiceTestResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      WorkflowServiceTestResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'WorkflowServiceTestResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.automation.v1'),
      createEmptyInstance: WorkflowServiceTestResponse.$_createMessage)
    ..aOB(1, _omitFieldNames ? '' : 'success')
    ..pPM<WorkflowServiceTestStepResult>(
        2, _omitFieldNames ? '' : 'stepResults',
        subBuilder: WorkflowServiceTestStepResult.$_createMessage)
    ..aD(3, _omitFieldNames ? '' : 'totalEstimatedCredits')
    ..aOS(4, _omitFieldNames ? '' : 'simulationSummary')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WorkflowServiceTestResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WorkflowServiceTestResponse copyWith(
          void Function(WorkflowServiceTestResponse) updates) =>
      super.copyWith(
              (message) => updates(message as WorkflowServiceTestResponse))
          as WorkflowServiceTestResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use WorkflowServiceTestResponse() / WorkflowServiceTestResponse.new instead')
  static WorkflowServiceTestResponse create() =>
      WorkflowServiceTestResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      WorkflowServiceTestResponse._();
  @$core.override
  WorkflowServiceTestResponse createEmptyInstance() =>
      WorkflowServiceTestResponse._();
  @$core.pragma('dart2js:noInline')
  static WorkflowServiceTestResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<WorkflowServiceTestResponse>(
          WorkflowServiceTestResponse.$_createMessage);
  static WorkflowServiceTestResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get success => $_getBF(0);
  @$pb.TagNumber(1)
  set success($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSuccess() => $_has(0);
  @$pb.TagNumber(1)
  void clearSuccess() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbList<WorkflowServiceTestStepResult> get stepResults => $_getList(1);

  @$pb.TagNumber(3)
  $core.double get totalEstimatedCredits => $_getN(2);
  @$pb.TagNumber(3)
  set totalEstimatedCredits($core.double value) => $_setDouble(2, value);
  @$pb.TagNumber(3)
  $core.bool hasTotalEstimatedCredits() => $_has(2);
  @$pb.TagNumber(3)
  void clearTotalEstimatedCredits() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get simulationSummary => $_getSZ(3);
  @$pb.TagNumber(4)
  set simulationSummary($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasSimulationSummary() => $_has(3);
  @$pb.TagNumber(4)
  void clearSimulationSummary() => $_clearField(4);
}

class WorkflowServiceGetRunStatsRequest extends $pb.GeneratedMessage {
  factory WorkflowServiceGetRunStatsRequest({
    $core.String? workspaceId,
    $core.String? workflowId,
  }) {
    final result = WorkflowServiceGetRunStatsRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (workflowId != null) result.workflowId = workflowId;
    return result;
  }

  WorkflowServiceGetRunStatsRequest._();

  factory WorkflowServiceGetRunStatsRequest.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      WorkflowServiceGetRunStatsRequest()..mergeFromBuffer(data, registry);
  factory WorkflowServiceGetRunStatsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      WorkflowServiceGetRunStatsRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'WorkflowServiceGetRunStatsRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.automation.v1'),
      createEmptyInstance: WorkflowServiceGetRunStatsRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'workflowId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WorkflowServiceGetRunStatsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WorkflowServiceGetRunStatsRequest copyWith(
          void Function(WorkflowServiceGetRunStatsRequest) updates) =>
      super.copyWith((message) =>
              updates(message as WorkflowServiceGetRunStatsRequest))
          as WorkflowServiceGetRunStatsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use WorkflowServiceGetRunStatsRequest() / WorkflowServiceGetRunStatsRequest.new instead')
  static WorkflowServiceGetRunStatsRequest create() =>
      WorkflowServiceGetRunStatsRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      WorkflowServiceGetRunStatsRequest._();
  @$core.override
  WorkflowServiceGetRunStatsRequest createEmptyInstance() =>
      WorkflowServiceGetRunStatsRequest._();
  @$core.pragma('dart2js:noInline')
  static WorkflowServiceGetRunStatsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<WorkflowServiceGetRunStatsRequest>(
          WorkflowServiceGetRunStatsRequest.$_createMessage);
  static WorkflowServiceGetRunStatsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get workflowId => $_getSZ(1);
  @$pb.TagNumber(2)
  set workflowId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasWorkflowId() => $_has(1);
  @$pb.TagNumber(2)
  void clearWorkflowId() => $_clearField(2);
}

class WorkflowServiceGetRunStatsResponse extends $pb.GeneratedMessage {
  factory WorkflowServiceGetRunStatsResponse({
    $core.int? totalRuns,
    $core.int? successfulRuns,
    $core.int? failedRuns,
    $core.int? pendingApprovals,
    $core.double? avgDurationSeconds,
  }) {
    final result = WorkflowServiceGetRunStatsResponse._();
    if (totalRuns != null) result.totalRuns = totalRuns;
    if (successfulRuns != null) result.successfulRuns = successfulRuns;
    if (failedRuns != null) result.failedRuns = failedRuns;
    if (pendingApprovals != null) result.pendingApprovals = pendingApprovals;
    if (avgDurationSeconds != null)
      result.avgDurationSeconds = avgDurationSeconds;
    return result;
  }

  WorkflowServiceGetRunStatsResponse._();

  factory WorkflowServiceGetRunStatsResponse.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      WorkflowServiceGetRunStatsResponse()..mergeFromBuffer(data, registry);
  factory WorkflowServiceGetRunStatsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      WorkflowServiceGetRunStatsResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'WorkflowServiceGetRunStatsResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.automation.v1'),
      createEmptyInstance: WorkflowServiceGetRunStatsResponse.$_createMessage)
    ..aI(1, _omitFieldNames ? '' : 'totalRuns')
    ..aI(2, _omitFieldNames ? '' : 'successfulRuns')
    ..aI(3, _omitFieldNames ? '' : 'failedRuns')
    ..aI(4, _omitFieldNames ? '' : 'pendingApprovals')
    ..aD(5, _omitFieldNames ? '' : 'avgDurationSeconds')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WorkflowServiceGetRunStatsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WorkflowServiceGetRunStatsResponse copyWith(
          void Function(WorkflowServiceGetRunStatsResponse) updates) =>
      super.copyWith((message) =>
              updates(message as WorkflowServiceGetRunStatsResponse))
          as WorkflowServiceGetRunStatsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use WorkflowServiceGetRunStatsResponse() / WorkflowServiceGetRunStatsResponse.new instead')
  static WorkflowServiceGetRunStatsResponse create() =>
      WorkflowServiceGetRunStatsResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      WorkflowServiceGetRunStatsResponse._();
  @$core.override
  WorkflowServiceGetRunStatsResponse createEmptyInstance() =>
      WorkflowServiceGetRunStatsResponse._();
  @$core.pragma('dart2js:noInline')
  static WorkflowServiceGetRunStatsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<WorkflowServiceGetRunStatsResponse>(
          WorkflowServiceGetRunStatsResponse.$_createMessage);
  static WorkflowServiceGetRunStatsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get totalRuns => $_getIZ(0);
  @$pb.TagNumber(1)
  set totalRuns($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTotalRuns() => $_has(0);
  @$pb.TagNumber(1)
  void clearTotalRuns() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get successfulRuns => $_getIZ(1);
  @$pb.TagNumber(2)
  set successfulRuns($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSuccessfulRuns() => $_has(1);
  @$pb.TagNumber(2)
  void clearSuccessfulRuns() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get failedRuns => $_getIZ(2);
  @$pb.TagNumber(3)
  set failedRuns($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasFailedRuns() => $_has(2);
  @$pb.TagNumber(3)
  void clearFailedRuns() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get pendingApprovals => $_getIZ(3);
  @$pb.TagNumber(4)
  set pendingApprovals($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasPendingApprovals() => $_has(3);
  @$pb.TagNumber(4)
  void clearPendingApprovals() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.double get avgDurationSeconds => $_getN(4);
  @$pb.TagNumber(5)
  set avgDurationSeconds($core.double value) => $_setDouble(4, value);
  @$pb.TagNumber(5)
  $core.bool hasAvgDurationSeconds() => $_has(4);
  @$pb.TagNumber(5)
  void clearAvgDurationSeconds() => $_clearField(5);
}

class WorkflowServiceCancelRunRequest extends $pb.GeneratedMessage {
  factory WorkflowServiceCancelRunRequest({
    $core.String? idempotencyKey,
    $core.String? workspaceId,
    $core.String? runId,
    $core.String? reason,
  }) {
    final result = WorkflowServiceCancelRunRequest._();
    if (idempotencyKey != null) result.idempotencyKey = idempotencyKey;
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (runId != null) result.runId = runId;
    if (reason != null) result.reason = reason;
    return result;
  }

  WorkflowServiceCancelRunRequest._();

  factory WorkflowServiceCancelRunRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      WorkflowServiceCancelRunRequest()..mergeFromBuffer(data, registry);
  factory WorkflowServiceCancelRunRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      WorkflowServiceCancelRunRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'WorkflowServiceCancelRunRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.automation.v1'),
      createEmptyInstance: WorkflowServiceCancelRunRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'idempotencyKey')
    ..aOS(2, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(3, _omitFieldNames ? '' : 'runId')
    ..aOS(4, _omitFieldNames ? '' : 'reason')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WorkflowServiceCancelRunRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WorkflowServiceCancelRunRequest copyWith(
          void Function(WorkflowServiceCancelRunRequest) updates) =>
      super.copyWith(
              (message) => updates(message as WorkflowServiceCancelRunRequest))
          as WorkflowServiceCancelRunRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use WorkflowServiceCancelRunRequest() / WorkflowServiceCancelRunRequest.new instead')
  static WorkflowServiceCancelRunRequest create() =>
      WorkflowServiceCancelRunRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      WorkflowServiceCancelRunRequest._();
  @$core.override
  WorkflowServiceCancelRunRequest createEmptyInstance() =>
      WorkflowServiceCancelRunRequest._();
  @$core.pragma('dart2js:noInline')
  static WorkflowServiceCancelRunRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<WorkflowServiceCancelRunRequest>(
          WorkflowServiceCancelRunRequest.$_createMessage);
  static WorkflowServiceCancelRunRequest? _defaultInstance;

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
  $core.String get runId => $_getSZ(2);
  @$pb.TagNumber(3)
  set runId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasRunId() => $_has(2);
  @$pb.TagNumber(3)
  void clearRunId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get reason => $_getSZ(3);
  @$pb.TagNumber(4)
  set reason($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasReason() => $_has(3);
  @$pb.TagNumber(4)
  void clearReason() => $_clearField(4);
}

class WorkflowServiceCancelRunResponse extends $pb.GeneratedMessage {
  factory WorkflowServiceCancelRunResponse({
    WorkflowRun? run,
  }) {
    final result = WorkflowServiceCancelRunResponse._();
    if (run != null) result.run = run;
    return result;
  }

  WorkflowServiceCancelRunResponse._();

  factory WorkflowServiceCancelRunResponse.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      WorkflowServiceCancelRunResponse()..mergeFromBuffer(data, registry);
  factory WorkflowServiceCancelRunResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      WorkflowServiceCancelRunResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'WorkflowServiceCancelRunResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.automation.v1'),
      createEmptyInstance: WorkflowServiceCancelRunResponse.$_createMessage)
    ..aOM<WorkflowRun>(1, _omitFieldNames ? '' : 'run',
        subBuilder: WorkflowRun.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WorkflowServiceCancelRunResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WorkflowServiceCancelRunResponse copyWith(
          void Function(WorkflowServiceCancelRunResponse) updates) =>
      super.copyWith(
              (message) => updates(message as WorkflowServiceCancelRunResponse))
          as WorkflowServiceCancelRunResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use WorkflowServiceCancelRunResponse() / WorkflowServiceCancelRunResponse.new instead')
  static WorkflowServiceCancelRunResponse create() =>
      WorkflowServiceCancelRunResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      WorkflowServiceCancelRunResponse._();
  @$core.override
  WorkflowServiceCancelRunResponse createEmptyInstance() =>
      WorkflowServiceCancelRunResponse._();
  @$core.pragma('dart2js:noInline')
  static WorkflowServiceCancelRunResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<WorkflowServiceCancelRunResponse>(
          WorkflowServiceCancelRunResponse.$_createMessage);
  static WorkflowServiceCancelRunResponse? _defaultInstance;

  @$pb.TagNumber(1)
  WorkflowRun get run => $_getN(0);
  @$pb.TagNumber(1)
  set run(WorkflowRun value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasRun() => $_has(0);
  @$pb.TagNumber(1)
  void clearRun() => $_clearField(1);
  @$pb.TagNumber(1)
  WorkflowRun ensureRun() => $_ensure(0);
}

class WorkflowServiceRetryRunRequest extends $pb.GeneratedMessage {
  factory WorkflowServiceRetryRunRequest({
    $core.String? idempotencyKey,
    $core.String? workspaceId,
    $core.String? runId,
    $core.String? repairContextJson,
  }) {
    final result = WorkflowServiceRetryRunRequest._();
    if (idempotencyKey != null) result.idempotencyKey = idempotencyKey;
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (runId != null) result.runId = runId;
    if (repairContextJson != null) result.repairContextJson = repairContextJson;
    return result;
  }

  WorkflowServiceRetryRunRequest._();

  factory WorkflowServiceRetryRunRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      WorkflowServiceRetryRunRequest()..mergeFromBuffer(data, registry);
  factory WorkflowServiceRetryRunRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      WorkflowServiceRetryRunRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'WorkflowServiceRetryRunRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.automation.v1'),
      createEmptyInstance: WorkflowServiceRetryRunRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'idempotencyKey')
    ..aOS(2, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(3, _omitFieldNames ? '' : 'runId')
    ..aOS(4, _omitFieldNames ? '' : 'repairContextJson')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WorkflowServiceRetryRunRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WorkflowServiceRetryRunRequest copyWith(
          void Function(WorkflowServiceRetryRunRequest) updates) =>
      super.copyWith(
              (message) => updates(message as WorkflowServiceRetryRunRequest))
          as WorkflowServiceRetryRunRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use WorkflowServiceRetryRunRequest() / WorkflowServiceRetryRunRequest.new instead')
  static WorkflowServiceRetryRunRequest create() =>
      WorkflowServiceRetryRunRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      WorkflowServiceRetryRunRequest._();
  @$core.override
  WorkflowServiceRetryRunRequest createEmptyInstance() =>
      WorkflowServiceRetryRunRequest._();
  @$core.pragma('dart2js:noInline')
  static WorkflowServiceRetryRunRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<WorkflowServiceRetryRunRequest>(
          WorkflowServiceRetryRunRequest.$_createMessage);
  static WorkflowServiceRetryRunRequest? _defaultInstance;

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
  $core.String get runId => $_getSZ(2);
  @$pb.TagNumber(3)
  set runId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasRunId() => $_has(2);
  @$pb.TagNumber(3)
  void clearRunId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get repairContextJson => $_getSZ(3);
  @$pb.TagNumber(4)
  set repairContextJson($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasRepairContextJson() => $_has(3);
  @$pb.TagNumber(4)
  void clearRepairContextJson() => $_clearField(4);
}

class WorkflowServiceRetryRunResponse extends $pb.GeneratedMessage {
  factory WorkflowServiceRetryRunResponse({
    WorkflowRun? run,
  }) {
    final result = WorkflowServiceRetryRunResponse._();
    if (run != null) result.run = run;
    return result;
  }

  WorkflowServiceRetryRunResponse._();

  factory WorkflowServiceRetryRunResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      WorkflowServiceRetryRunResponse()..mergeFromBuffer(data, registry);
  factory WorkflowServiceRetryRunResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      WorkflowServiceRetryRunResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'WorkflowServiceRetryRunResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.automation.v1'),
      createEmptyInstance: WorkflowServiceRetryRunResponse.$_createMessage)
    ..aOM<WorkflowRun>(1, _omitFieldNames ? '' : 'run',
        subBuilder: WorkflowRun.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WorkflowServiceRetryRunResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WorkflowServiceRetryRunResponse copyWith(
          void Function(WorkflowServiceRetryRunResponse) updates) =>
      super.copyWith(
              (message) => updates(message as WorkflowServiceRetryRunResponse))
          as WorkflowServiceRetryRunResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use WorkflowServiceRetryRunResponse() / WorkflowServiceRetryRunResponse.new instead')
  static WorkflowServiceRetryRunResponse create() =>
      WorkflowServiceRetryRunResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      WorkflowServiceRetryRunResponse._();
  @$core.override
  WorkflowServiceRetryRunResponse createEmptyInstance() =>
      WorkflowServiceRetryRunResponse._();
  @$core.pragma('dart2js:noInline')
  static WorkflowServiceRetryRunResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<WorkflowServiceRetryRunResponse>(
          WorkflowServiceRetryRunResponse.$_createMessage);
  static WorkflowServiceRetryRunResponse? _defaultInstance;

  @$pb.TagNumber(1)
  WorkflowRun get run => $_getN(0);
  @$pb.TagNumber(1)
  set run(WorkflowRun value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasRun() => $_has(0);
  @$pb.TagNumber(1)
  void clearRun() => $_clearField(1);
  @$pb.TagNumber(1)
  WorkflowRun ensureRun() => $_ensure(0);
}

class WorkflowServiceDismissRunRequest extends $pb.GeneratedMessage {
  factory WorkflowServiceDismissRunRequest({
    $core.String? workspaceId,
    $core.String? runId,
    $core.String? dismissalReason,
  }) {
    final result = WorkflowServiceDismissRunRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (runId != null) result.runId = runId;
    if (dismissalReason != null) result.dismissalReason = dismissalReason;
    return result;
  }

  WorkflowServiceDismissRunRequest._();

  factory WorkflowServiceDismissRunRequest.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      WorkflowServiceDismissRunRequest()..mergeFromBuffer(data, registry);
  factory WorkflowServiceDismissRunRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      WorkflowServiceDismissRunRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'WorkflowServiceDismissRunRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.automation.v1'),
      createEmptyInstance: WorkflowServiceDismissRunRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'runId')
    ..aOS(3, _omitFieldNames ? '' : 'dismissalReason')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WorkflowServiceDismissRunRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WorkflowServiceDismissRunRequest copyWith(
          void Function(WorkflowServiceDismissRunRequest) updates) =>
      super.copyWith(
              (message) => updates(message as WorkflowServiceDismissRunRequest))
          as WorkflowServiceDismissRunRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use WorkflowServiceDismissRunRequest() / WorkflowServiceDismissRunRequest.new instead')
  static WorkflowServiceDismissRunRequest create() =>
      WorkflowServiceDismissRunRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      WorkflowServiceDismissRunRequest._();
  @$core.override
  WorkflowServiceDismissRunRequest createEmptyInstance() =>
      WorkflowServiceDismissRunRequest._();
  @$core.pragma('dart2js:noInline')
  static WorkflowServiceDismissRunRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<WorkflowServiceDismissRunRequest>(
          WorkflowServiceDismissRunRequest.$_createMessage);
  static WorkflowServiceDismissRunRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get runId => $_getSZ(1);
  @$pb.TagNumber(2)
  set runId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasRunId() => $_has(1);
  @$pb.TagNumber(2)
  void clearRunId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get dismissalReason => $_getSZ(2);
  @$pb.TagNumber(3)
  set dismissalReason($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasDismissalReason() => $_has(2);
  @$pb.TagNumber(3)
  void clearDismissalReason() => $_clearField(3);
}

class WorkflowServiceDismissRunResponse extends $pb.GeneratedMessage {
  factory WorkflowServiceDismissRunResponse({
    $core.bool? dismissed,
  }) {
    final result = WorkflowServiceDismissRunResponse._();
    if (dismissed != null) result.dismissed = dismissed;
    return result;
  }

  WorkflowServiceDismissRunResponse._();

  factory WorkflowServiceDismissRunResponse.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      WorkflowServiceDismissRunResponse()..mergeFromBuffer(data, registry);
  factory WorkflowServiceDismissRunResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      WorkflowServiceDismissRunResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'WorkflowServiceDismissRunResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.automation.v1'),
      createEmptyInstance: WorkflowServiceDismissRunResponse.$_createMessage)
    ..aOB(1, _omitFieldNames ? '' : 'dismissed')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WorkflowServiceDismissRunResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WorkflowServiceDismissRunResponse copyWith(
          void Function(WorkflowServiceDismissRunResponse) updates) =>
      super.copyWith((message) =>
              updates(message as WorkflowServiceDismissRunResponse))
          as WorkflowServiceDismissRunResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use WorkflowServiceDismissRunResponse() / WorkflowServiceDismissRunResponse.new instead')
  static WorkflowServiceDismissRunResponse create() =>
      WorkflowServiceDismissRunResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      WorkflowServiceDismissRunResponse._();
  @$core.override
  WorkflowServiceDismissRunResponse createEmptyInstance() =>
      WorkflowServiceDismissRunResponse._();
  @$core.pragma('dart2js:noInline')
  static WorkflowServiceDismissRunResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<WorkflowServiceDismissRunResponse>(
          WorkflowServiceDismissRunResponse.$_createMessage);
  static WorkflowServiceDismissRunResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get dismissed => $_getBF(0);
  @$pb.TagNumber(1)
  set dismissed($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasDismissed() => $_has(0);
  @$pb.TagNumber(1)
  void clearDismissed() => $_clearField(1);
}

class WorkflowServiceSkipStepRequest extends $pb.GeneratedMessage {
  factory WorkflowServiceSkipStepRequest({
    $core.String? idempotencyKey,
    $core.String? workspaceId,
    $core.String? runId,
    $core.String? nodeId,
    $core.String? reason,
  }) {
    final result = WorkflowServiceSkipStepRequest._();
    if (idempotencyKey != null) result.idempotencyKey = idempotencyKey;
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (runId != null) result.runId = runId;
    if (nodeId != null) result.nodeId = nodeId;
    if (reason != null) result.reason = reason;
    return result;
  }

  WorkflowServiceSkipStepRequest._();

  factory WorkflowServiceSkipStepRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      WorkflowServiceSkipStepRequest()..mergeFromBuffer(data, registry);
  factory WorkflowServiceSkipStepRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      WorkflowServiceSkipStepRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'WorkflowServiceSkipStepRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.automation.v1'),
      createEmptyInstance: WorkflowServiceSkipStepRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'idempotencyKey')
    ..aOS(2, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(3, _omitFieldNames ? '' : 'runId')
    ..aOS(4, _omitFieldNames ? '' : 'nodeId')
    ..aOS(5, _omitFieldNames ? '' : 'reason')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WorkflowServiceSkipStepRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WorkflowServiceSkipStepRequest copyWith(
          void Function(WorkflowServiceSkipStepRequest) updates) =>
      super.copyWith(
              (message) => updates(message as WorkflowServiceSkipStepRequest))
          as WorkflowServiceSkipStepRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use WorkflowServiceSkipStepRequest() / WorkflowServiceSkipStepRequest.new instead')
  static WorkflowServiceSkipStepRequest create() =>
      WorkflowServiceSkipStepRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      WorkflowServiceSkipStepRequest._();
  @$core.override
  WorkflowServiceSkipStepRequest createEmptyInstance() =>
      WorkflowServiceSkipStepRequest._();
  @$core.pragma('dart2js:noInline')
  static WorkflowServiceSkipStepRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<WorkflowServiceSkipStepRequest>(
          WorkflowServiceSkipStepRequest.$_createMessage);
  static WorkflowServiceSkipStepRequest? _defaultInstance;

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
  $core.String get runId => $_getSZ(2);
  @$pb.TagNumber(3)
  set runId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasRunId() => $_has(2);
  @$pb.TagNumber(3)
  void clearRunId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get nodeId => $_getSZ(3);
  @$pb.TagNumber(4)
  set nodeId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasNodeId() => $_has(3);
  @$pb.TagNumber(4)
  void clearNodeId() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get reason => $_getSZ(4);
  @$pb.TagNumber(5)
  set reason($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasReason() => $_has(4);
  @$pb.TagNumber(5)
  void clearReason() => $_clearField(5);
}

class WorkflowServiceSkipStepResponse extends $pb.GeneratedMessage {
  factory WorkflowServiceSkipStepResponse({
    WorkflowRunStep? step,
  }) {
    final result = WorkflowServiceSkipStepResponse._();
    if (step != null) result.step = step;
    return result;
  }

  WorkflowServiceSkipStepResponse._();

  factory WorkflowServiceSkipStepResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      WorkflowServiceSkipStepResponse()..mergeFromBuffer(data, registry);
  factory WorkflowServiceSkipStepResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      WorkflowServiceSkipStepResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'WorkflowServiceSkipStepResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.automation.v1'),
      createEmptyInstance: WorkflowServiceSkipStepResponse.$_createMessage)
    ..aOM<WorkflowRunStep>(1, _omitFieldNames ? '' : 'step',
        subBuilder: WorkflowRunStep.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WorkflowServiceSkipStepResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WorkflowServiceSkipStepResponse copyWith(
          void Function(WorkflowServiceSkipStepResponse) updates) =>
      super.copyWith(
              (message) => updates(message as WorkflowServiceSkipStepResponse))
          as WorkflowServiceSkipStepResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use WorkflowServiceSkipStepResponse() / WorkflowServiceSkipStepResponse.new instead')
  static WorkflowServiceSkipStepResponse create() =>
      WorkflowServiceSkipStepResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      WorkflowServiceSkipStepResponse._();
  @$core.override
  WorkflowServiceSkipStepResponse createEmptyInstance() =>
      WorkflowServiceSkipStepResponse._();
  @$core.pragma('dart2js:noInline')
  static WorkflowServiceSkipStepResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<WorkflowServiceSkipStepResponse>(
          WorkflowServiceSkipStepResponse.$_createMessage);
  static WorkflowServiceSkipStepResponse? _defaultInstance;

  @$pb.TagNumber(1)
  WorkflowRunStep get step => $_getN(0);
  @$pb.TagNumber(1)
  set step(WorkflowRunStep value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasStep() => $_has(0);
  @$pb.TagNumber(1)
  void clearStep() => $_clearField(1);
  @$pb.TagNumber(1)
  WorkflowRunStep ensureStep() => $_ensure(0);
}

class WorkflowServiceProvideInputRequest extends $pb.GeneratedMessage {
  factory WorkflowServiceProvideInputRequest({
    $core.String? idempotencyKey,
    $core.String? workspaceId,
    $core.String? runId,
    $core.String? nodeId,
    $core.String? inputJson,
  }) {
    final result = WorkflowServiceProvideInputRequest._();
    if (idempotencyKey != null) result.idempotencyKey = idempotencyKey;
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (runId != null) result.runId = runId;
    if (nodeId != null) result.nodeId = nodeId;
    if (inputJson != null) result.inputJson = inputJson;
    return result;
  }

  WorkflowServiceProvideInputRequest._();

  factory WorkflowServiceProvideInputRequest.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      WorkflowServiceProvideInputRequest()..mergeFromBuffer(data, registry);
  factory WorkflowServiceProvideInputRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      WorkflowServiceProvideInputRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'WorkflowServiceProvideInputRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.automation.v1'),
      createEmptyInstance: WorkflowServiceProvideInputRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'idempotencyKey')
    ..aOS(2, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(3, _omitFieldNames ? '' : 'runId')
    ..aOS(4, _omitFieldNames ? '' : 'nodeId')
    ..aOS(5, _omitFieldNames ? '' : 'inputJson')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WorkflowServiceProvideInputRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WorkflowServiceProvideInputRequest copyWith(
          void Function(WorkflowServiceProvideInputRequest) updates) =>
      super.copyWith((message) =>
              updates(message as WorkflowServiceProvideInputRequest))
          as WorkflowServiceProvideInputRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use WorkflowServiceProvideInputRequest() / WorkflowServiceProvideInputRequest.new instead')
  static WorkflowServiceProvideInputRequest create() =>
      WorkflowServiceProvideInputRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      WorkflowServiceProvideInputRequest._();
  @$core.override
  WorkflowServiceProvideInputRequest createEmptyInstance() =>
      WorkflowServiceProvideInputRequest._();
  @$core.pragma('dart2js:noInline')
  static WorkflowServiceProvideInputRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<WorkflowServiceProvideInputRequest>(
          WorkflowServiceProvideInputRequest.$_createMessage);
  static WorkflowServiceProvideInputRequest? _defaultInstance;

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
  $core.String get runId => $_getSZ(2);
  @$pb.TagNumber(3)
  set runId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasRunId() => $_has(2);
  @$pb.TagNumber(3)
  void clearRunId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get nodeId => $_getSZ(3);
  @$pb.TagNumber(4)
  set nodeId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasNodeId() => $_has(3);
  @$pb.TagNumber(4)
  void clearNodeId() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get inputJson => $_getSZ(4);
  @$pb.TagNumber(5)
  set inputJson($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasInputJson() => $_has(4);
  @$pb.TagNumber(5)
  void clearInputJson() => $_clearField(5);
}

class WorkflowServiceProvideInputResponse extends $pb.GeneratedMessage {
  factory WorkflowServiceProvideInputResponse({
    WorkflowRunStep? step,
  }) {
    final result = WorkflowServiceProvideInputResponse._();
    if (step != null) result.step = step;
    return result;
  }

  WorkflowServiceProvideInputResponse._();

  factory WorkflowServiceProvideInputResponse.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      WorkflowServiceProvideInputResponse()..mergeFromBuffer(data, registry);
  factory WorkflowServiceProvideInputResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      WorkflowServiceProvideInputResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'WorkflowServiceProvideInputResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.automation.v1'),
      createEmptyInstance: WorkflowServiceProvideInputResponse.$_createMessage)
    ..aOM<WorkflowRunStep>(1, _omitFieldNames ? '' : 'step',
        subBuilder: WorkflowRunStep.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WorkflowServiceProvideInputResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WorkflowServiceProvideInputResponse copyWith(
          void Function(WorkflowServiceProvideInputResponse) updates) =>
      super.copyWith((message) =>
              updates(message as WorkflowServiceProvideInputResponse))
          as WorkflowServiceProvideInputResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use WorkflowServiceProvideInputResponse() / WorkflowServiceProvideInputResponse.new instead')
  static WorkflowServiceProvideInputResponse create() =>
      WorkflowServiceProvideInputResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      WorkflowServiceProvideInputResponse._();
  @$core.override
  WorkflowServiceProvideInputResponse createEmptyInstance() =>
      WorkflowServiceProvideInputResponse._();
  @$core.pragma('dart2js:noInline')
  static WorkflowServiceProvideInputResponse getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
              WorkflowServiceProvideInputResponse>(
          WorkflowServiceProvideInputResponse.$_createMessage);
  static WorkflowServiceProvideInputResponse? _defaultInstance;

  @$pb.TagNumber(1)
  WorkflowRunStep get step => $_getN(0);
  @$pb.TagNumber(1)
  set step(WorkflowRunStep value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasStep() => $_has(0);
  @$pb.TagNumber(1)
  void clearStep() => $_clearField(1);
  @$pb.TagNumber(1)
  WorkflowRunStep ensureStep() => $_ensure(0);
}

class WorkflowServiceExportRunsRequest extends $pb.GeneratedMessage {
  factory WorkflowServiceExportRunsRequest({
    $core.String? workspaceId,
    $core.String? workflowId,
    $core.String? format,
  }) {
    final result = WorkflowServiceExportRunsRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (workflowId != null) result.workflowId = workflowId;
    if (format != null) result.format = format;
    return result;
  }

  WorkflowServiceExportRunsRequest._();

  factory WorkflowServiceExportRunsRequest.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      WorkflowServiceExportRunsRequest()..mergeFromBuffer(data, registry);
  factory WorkflowServiceExportRunsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      WorkflowServiceExportRunsRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'WorkflowServiceExportRunsRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.automation.v1'),
      createEmptyInstance: WorkflowServiceExportRunsRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'workflowId')
    ..aOS(3, _omitFieldNames ? '' : 'format')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WorkflowServiceExportRunsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WorkflowServiceExportRunsRequest copyWith(
          void Function(WorkflowServiceExportRunsRequest) updates) =>
      super.copyWith(
              (message) => updates(message as WorkflowServiceExportRunsRequest))
          as WorkflowServiceExportRunsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use WorkflowServiceExportRunsRequest() / WorkflowServiceExportRunsRequest.new instead')
  static WorkflowServiceExportRunsRequest create() =>
      WorkflowServiceExportRunsRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      WorkflowServiceExportRunsRequest._();
  @$core.override
  WorkflowServiceExportRunsRequest createEmptyInstance() =>
      WorkflowServiceExportRunsRequest._();
  @$core.pragma('dart2js:noInline')
  static WorkflowServiceExportRunsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<WorkflowServiceExportRunsRequest>(
          WorkflowServiceExportRunsRequest.$_createMessage);
  static WorkflowServiceExportRunsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get workflowId => $_getSZ(1);
  @$pb.TagNumber(2)
  set workflowId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasWorkflowId() => $_has(1);
  @$pb.TagNumber(2)
  void clearWorkflowId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get format => $_getSZ(2);
  @$pb.TagNumber(3)
  set format($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasFormat() => $_has(2);
  @$pb.TagNumber(3)
  void clearFormat() => $_clearField(3);
}

class WorkflowServiceExportRunsResponse extends $pb.GeneratedMessage {
  factory WorkflowServiceExportRunsResponse({
    $core.String? fileUrl,
    $core.String? content,
  }) {
    final result = WorkflowServiceExportRunsResponse._();
    if (fileUrl != null) result.fileUrl = fileUrl;
    if (content != null) result.content = content;
    return result;
  }

  WorkflowServiceExportRunsResponse._();

  factory WorkflowServiceExportRunsResponse.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      WorkflowServiceExportRunsResponse()..mergeFromBuffer(data, registry);
  factory WorkflowServiceExportRunsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      WorkflowServiceExportRunsResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'WorkflowServiceExportRunsResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.automation.v1'),
      createEmptyInstance: WorkflowServiceExportRunsResponse.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'fileUrl')
    ..aOS(2, _omitFieldNames ? '' : 'content')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WorkflowServiceExportRunsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WorkflowServiceExportRunsResponse copyWith(
          void Function(WorkflowServiceExportRunsResponse) updates) =>
      super.copyWith((message) =>
              updates(message as WorkflowServiceExportRunsResponse))
          as WorkflowServiceExportRunsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use WorkflowServiceExportRunsResponse() / WorkflowServiceExportRunsResponse.new instead')
  static WorkflowServiceExportRunsResponse create() =>
      WorkflowServiceExportRunsResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      WorkflowServiceExportRunsResponse._();
  @$core.override
  WorkflowServiceExportRunsResponse createEmptyInstance() =>
      WorkflowServiceExportRunsResponse._();
  @$core.pragma('dart2js:noInline')
  static WorkflowServiceExportRunsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<WorkflowServiceExportRunsResponse>(
          WorkflowServiceExportRunsResponse.$_createMessage);
  static WorkflowServiceExportRunsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get fileUrl => $_getSZ(0);
  @$pb.TagNumber(1)
  set fileUrl($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasFileUrl() => $_has(0);
  @$pb.TagNumber(1)
  void clearFileUrl() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get content => $_getSZ(1);
  @$pb.TagNumber(2)
  set content($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasContent() => $_has(1);
  @$pb.TagNumber(2)
  void clearContent() => $_clearField(2);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');

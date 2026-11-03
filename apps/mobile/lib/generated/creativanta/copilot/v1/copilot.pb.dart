// This is a generated file - do not edit.
//
// Generated from creativanta/copilot/v1/copilot.proto.

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

import 'copilot.pbenum.dart';

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'copilot.pbenum.dart';

/// ActionQuote represents a durable credit cost preview before executing generative/side-effect actions.
class ActionQuote extends $pb.GeneratedMessage {
  factory ActionQuote({
    $core.String? quoteId,
    $core.String? workspaceId,
    $core.String? operationType,
    $fixnum.Int64? quotedCredits,
    $core.String? costCeilingUsd,
    ActionQuoteStatus? status,
    $1.Timestamp? expiresAt,
    $1.Timestamp? createdAt,
    $core.String? actionPreview,
  }) {
    final result = ActionQuote._();
    if (quoteId != null) result.quoteId = quoteId;
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (operationType != null) result.operationType = operationType;
    if (quotedCredits != null) result.quotedCredits = quotedCredits;
    if (costCeilingUsd != null) result.costCeilingUsd = costCeilingUsd;
    if (status != null) result.status = status;
    if (expiresAt != null) result.expiresAt = expiresAt;
    if (createdAt != null) result.createdAt = createdAt;
    if (actionPreview != null) result.actionPreview = actionPreview;
    return result;
  }

  ActionQuote._();

  factory ActionQuote.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ActionQuote()..mergeFromBuffer(data, registry);
  factory ActionQuote.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ActionQuote()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ActionQuote',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.copilot.v1'),
      createEmptyInstance: ActionQuote.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'quoteId')
    ..aOS(2, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(3, _omitFieldNames ? '' : 'operationType')
    ..aInt64(4, _omitFieldNames ? '' : 'quotedCredits')
    ..aOS(5, _omitFieldNames ? '' : 'costCeilingUsd')
    ..aE<ActionQuoteStatus>(6, _omitFieldNames ? '' : 'status',
        enumValues: ActionQuoteStatus.values)
    ..aOM<$1.Timestamp>(7, _omitFieldNames ? '' : 'expiresAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..aOM<$1.Timestamp>(8, _omitFieldNames ? '' : 'createdAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..aOS(9, _omitFieldNames ? '' : 'actionPreview')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ActionQuote clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ActionQuote copyWith(void Function(ActionQuote) updates) =>
      super.copyWith((message) => updates(message as ActionQuote))
          as ActionQuote;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ActionQuote() / ActionQuote.new instead')
  static ActionQuote create() => ActionQuote._();
  static $pb.GeneratedMessage $_createMessage() => ActionQuote._();
  @$core.override
  ActionQuote createEmptyInstance() => ActionQuote._();
  @$core.pragma('dart2js:noInline')
  static ActionQuote getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ActionQuote>(
          ActionQuote.$_createMessage);
  static ActionQuote? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get quoteId => $_getSZ(0);
  @$pb.TagNumber(1)
  set quoteId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasQuoteId() => $_has(0);
  @$pb.TagNumber(1)
  void clearQuoteId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get workspaceId => $_getSZ(1);
  @$pb.TagNumber(2)
  set workspaceId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasWorkspaceId() => $_has(1);
  @$pb.TagNumber(2)
  void clearWorkspaceId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get operationType => $_getSZ(2);
  @$pb.TagNumber(3)
  set operationType($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasOperationType() => $_has(2);
  @$pb.TagNumber(3)
  void clearOperationType() => $_clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get quotedCredits => $_getI64(3);
  @$pb.TagNumber(4)
  set quotedCredits($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasQuotedCredits() => $_has(3);
  @$pb.TagNumber(4)
  void clearQuotedCredits() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get costCeilingUsd => $_getSZ(4);
  @$pb.TagNumber(5)
  set costCeilingUsd($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasCostCeilingUsd() => $_has(4);
  @$pb.TagNumber(5)
  void clearCostCeilingUsd() => $_clearField(5);

  @$pb.TagNumber(6)
  ActionQuoteStatus get status => $_getN(5);
  @$pb.TagNumber(6)
  set status(ActionQuoteStatus value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasStatus() => $_has(5);
  @$pb.TagNumber(6)
  void clearStatus() => $_clearField(6);

  @$pb.TagNumber(7)
  $1.Timestamp get expiresAt => $_getN(6);
  @$pb.TagNumber(7)
  set expiresAt($1.Timestamp value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasExpiresAt() => $_has(6);
  @$pb.TagNumber(7)
  void clearExpiresAt() => $_clearField(7);
  @$pb.TagNumber(7)
  $1.Timestamp ensureExpiresAt() => $_ensure(6);

  @$pb.TagNumber(8)
  $1.Timestamp get createdAt => $_getN(7);
  @$pb.TagNumber(8)
  set createdAt($1.Timestamp value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasCreatedAt() => $_has(7);
  @$pb.TagNumber(8)
  void clearCreatedAt() => $_clearField(8);
  @$pb.TagNumber(8)
  $1.Timestamp ensureCreatedAt() => $_ensure(7);

  @$pb.TagNumber(9)
  $core.String get actionPreview => $_getSZ(8);
  @$pb.TagNumber(9)
  set actionPreview($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasActionPreview() => $_has(8);
  @$pb.TagNumber(9)
  void clearActionPreview() => $_clearField(9);
}

/// ActionCard represents an executable or proposed action button in Copilot response.
class ActionCard extends $pb.GeneratedMessage {
  factory ActionCard({
    $core.String? actionId,
    $core.String? actionType,
    $core.String? title,
    $core.String? description,
    $core.String? requiredPermission,
    $core.bool? requiresConfirmation,
    ActionQuote? quote,
    $core.Iterable<$core.MapEntry<$core.String, $core.String>>? parameters,
  }) {
    final result = ActionCard._();
    if (actionId != null) result.actionId = actionId;
    if (actionType != null) result.actionType = actionType;
    if (title != null) result.title = title;
    if (description != null) result.description = description;
    if (requiredPermission != null)
      result.requiredPermission = requiredPermission;
    if (requiresConfirmation != null)
      result.requiresConfirmation = requiresConfirmation;
    if (quote != null) result.quote = quote;
    if (parameters != null) result.parameters.addEntries(parameters);
    return result;
  }

  ActionCard._();

  factory ActionCard.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ActionCard()..mergeFromBuffer(data, registry);
  factory ActionCard.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ActionCard()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ActionCard',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.copilot.v1'),
      createEmptyInstance: ActionCard.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'actionId')
    ..aOS(2, _omitFieldNames ? '' : 'actionType')
    ..aOS(3, _omitFieldNames ? '' : 'title')
    ..aOS(4, _omitFieldNames ? '' : 'description')
    ..aOS(5, _omitFieldNames ? '' : 'requiredPermission')
    ..aOB(6, _omitFieldNames ? '' : 'requiresConfirmation')
    ..aOM<ActionQuote>(7, _omitFieldNames ? '' : 'quote',
        subBuilder: ActionQuote.$_createMessage)
    ..m<$core.String, $core.String>(8, _omitFieldNames ? '' : 'parameters',
        entryClassName: 'ActionCard.ParametersEntry',
        keyFieldType: $pb.PbFieldType.OS,
        valueFieldType: $pb.PbFieldType.OS,
        packageName: const $pb.PackageName('creativanta.copilot.v1'))
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ActionCard clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ActionCard copyWith(void Function(ActionCard) updates) =>
      super.copyWith((message) => updates(message as ActionCard)) as ActionCard;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ActionCard() / ActionCard.new instead')
  static ActionCard create() => ActionCard._();
  static $pb.GeneratedMessage $_createMessage() => ActionCard._();
  @$core.override
  ActionCard createEmptyInstance() => ActionCard._();
  @$core.pragma('dart2js:noInline')
  static ActionCard getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ActionCard>(ActionCard.$_createMessage);
  static ActionCard? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get actionId => $_getSZ(0);
  @$pb.TagNumber(1)
  set actionId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasActionId() => $_has(0);
  @$pb.TagNumber(1)
  void clearActionId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get actionType => $_getSZ(1);
  @$pb.TagNumber(2)
  set actionType($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasActionType() => $_has(1);
  @$pb.TagNumber(2)
  void clearActionType() => $_clearField(2);

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
  $core.String get requiredPermission => $_getSZ(4);
  @$pb.TagNumber(5)
  set requiredPermission($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasRequiredPermission() => $_has(4);
  @$pb.TagNumber(5)
  void clearRequiredPermission() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.bool get requiresConfirmation => $_getBF(5);
  @$pb.TagNumber(6)
  set requiresConfirmation($core.bool value) => $_setBool(5, value);
  @$pb.TagNumber(6)
  $core.bool hasRequiresConfirmation() => $_has(5);
  @$pb.TagNumber(6)
  void clearRequiresConfirmation() => $_clearField(6);

  @$pb.TagNumber(7)
  ActionQuote get quote => $_getN(6);
  @$pb.TagNumber(7)
  set quote(ActionQuote value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasQuote() => $_has(6);
  @$pb.TagNumber(7)
  void clearQuote() => $_clearField(7);
  @$pb.TagNumber(7)
  ActionQuote ensureQuote() => $_ensure(6);

  @$pb.TagNumber(8)
  $pb.PbMap<$core.String, $core.String> get parameters => $_getMap(7);
}

/// DataCard represents structured evidence, analytics, or metrics returned in Copilot response.
class DataCard extends $pb.GeneratedMessage {
  factory DataCard({
    $core.String? cardId,
    $core.String? title,
    $core.String? summary,
    $core.bool? isFinancial,
    $core.bool? isRedacted,
    $core.String? redactionReason,
    $core.Iterable<$core.String>? sourceBadges,
    $core.Iterable<$core.MapEntry<$core.String, $core.String>>? metrics,
  }) {
    final result = DataCard._();
    if (cardId != null) result.cardId = cardId;
    if (title != null) result.title = title;
    if (summary != null) result.summary = summary;
    if (isFinancial != null) result.isFinancial = isFinancial;
    if (isRedacted != null) result.isRedacted = isRedacted;
    if (redactionReason != null) result.redactionReason = redactionReason;
    if (sourceBadges != null) result.sourceBadges.addAll(sourceBadges);
    if (metrics != null) result.metrics.addEntries(metrics);
    return result;
  }

  DataCard._();

  factory DataCard.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      DataCard()..mergeFromBuffer(data, registry);
  factory DataCard.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      DataCard()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DataCard',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.copilot.v1'),
      createEmptyInstance: DataCard.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'cardId')
    ..aOS(2, _omitFieldNames ? '' : 'title')
    ..aOS(3, _omitFieldNames ? '' : 'summary')
    ..aOB(4, _omitFieldNames ? '' : 'isFinancial')
    ..aOB(5, _omitFieldNames ? '' : 'isRedacted')
    ..aOS(6, _omitFieldNames ? '' : 'redactionReason')
    ..pPS(7, _omitFieldNames ? '' : 'sourceBadges')
    ..m<$core.String, $core.String>(8, _omitFieldNames ? '' : 'metrics',
        entryClassName: 'DataCard.MetricsEntry',
        keyFieldType: $pb.PbFieldType.OS,
        valueFieldType: $pb.PbFieldType.OS,
        packageName: const $pb.PackageName('creativanta.copilot.v1'))
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DataCard clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DataCard copyWith(void Function(DataCard) updates) =>
      super.copyWith((message) => updates(message as DataCard)) as DataCard;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use DataCard() / DataCard.new instead')
  static DataCard create() => DataCard._();
  static $pb.GeneratedMessage $_createMessage() => DataCard._();
  @$core.override
  DataCard createEmptyInstance() => DataCard._();
  @$core.pragma('dart2js:noInline')
  static DataCard getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DataCard>(DataCard.$_createMessage);
  static DataCard? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get cardId => $_getSZ(0);
  @$pb.TagNumber(1)
  set cardId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCardId() => $_has(0);
  @$pb.TagNumber(1)
  void clearCardId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get title => $_getSZ(1);
  @$pb.TagNumber(2)
  set title($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTitle() => $_has(1);
  @$pb.TagNumber(2)
  void clearTitle() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get summary => $_getSZ(2);
  @$pb.TagNumber(3)
  set summary($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasSummary() => $_has(2);
  @$pb.TagNumber(3)
  void clearSummary() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.bool get isFinancial => $_getBF(3);
  @$pb.TagNumber(4)
  set isFinancial($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(4)
  $core.bool hasIsFinancial() => $_has(3);
  @$pb.TagNumber(4)
  void clearIsFinancial() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.bool get isRedacted => $_getBF(4);
  @$pb.TagNumber(5)
  set isRedacted($core.bool value) => $_setBool(4, value);
  @$pb.TagNumber(5)
  $core.bool hasIsRedacted() => $_has(4);
  @$pb.TagNumber(5)
  void clearIsRedacted() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get redactionReason => $_getSZ(5);
  @$pb.TagNumber(6)
  set redactionReason($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasRedactionReason() => $_has(5);
  @$pb.TagNumber(6)
  void clearRedactionReason() => $_clearField(6);

  @$pb.TagNumber(7)
  $pb.PbList<$core.String> get sourceBadges => $_getList(6);

  @$pb.TagNumber(8)
  $pb.PbMap<$core.String, $core.String> get metrics => $_getMap(7);
}

/// CopilotMessage represents a single turn in a Copilot conversation.
class CopilotMessage extends $pb.GeneratedMessage {
  factory CopilotMessage({
    $core.String? messageId,
    $core.String? sessionId,
    $core.String? role,
    $core.String? content,
    $core.Iterable<ActionCard>? actionCards,
    $core.Iterable<DataCard>? dataCards,
    ActionQuote? pendingQuote,
    $core.bool? permissionDenied,
    $core.String? denialReason,
    $1.Timestamp? createdAt,
  }) {
    final result = CopilotMessage._();
    if (messageId != null) result.messageId = messageId;
    if (sessionId != null) result.sessionId = sessionId;
    if (role != null) result.role = role;
    if (content != null) result.content = content;
    if (actionCards != null) result.actionCards.addAll(actionCards);
    if (dataCards != null) result.dataCards.addAll(dataCards);
    if (pendingQuote != null) result.pendingQuote = pendingQuote;
    if (permissionDenied != null) result.permissionDenied = permissionDenied;
    if (denialReason != null) result.denialReason = denialReason;
    if (createdAt != null) result.createdAt = createdAt;
    return result;
  }

  CopilotMessage._();

  factory CopilotMessage.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CopilotMessage()..mergeFromBuffer(data, registry);
  factory CopilotMessage.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CopilotMessage()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CopilotMessage',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.copilot.v1'),
      createEmptyInstance: CopilotMessage.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'messageId')
    ..aOS(2, _omitFieldNames ? '' : 'sessionId')
    ..aOS(3, _omitFieldNames ? '' : 'role')
    ..aOS(4, _omitFieldNames ? '' : 'content')
    ..pPM<ActionCard>(5, _omitFieldNames ? '' : 'actionCards',
        subBuilder: ActionCard.$_createMessage)
    ..pPM<DataCard>(6, _omitFieldNames ? '' : 'dataCards',
        subBuilder: DataCard.$_createMessage)
    ..aOM<ActionQuote>(7, _omitFieldNames ? '' : 'pendingQuote',
        subBuilder: ActionQuote.$_createMessage)
    ..aOB(8, _omitFieldNames ? '' : 'permissionDenied')
    ..aOS(9, _omitFieldNames ? '' : 'denialReason')
    ..aOM<$1.Timestamp>(10, _omitFieldNames ? '' : 'createdAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CopilotMessage clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CopilotMessage copyWith(void Function(CopilotMessage) updates) =>
      super.copyWith((message) => updates(message as CopilotMessage))
          as CopilotMessage;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use CopilotMessage() / CopilotMessage.new instead')
  static CopilotMessage create() => CopilotMessage._();
  static $pb.GeneratedMessage $_createMessage() => CopilotMessage._();
  @$core.override
  CopilotMessage createEmptyInstance() => CopilotMessage._();
  @$core.pragma('dart2js:noInline')
  static CopilotMessage getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CopilotMessage>(
          CopilotMessage.$_createMessage);
  static CopilotMessage? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get messageId => $_getSZ(0);
  @$pb.TagNumber(1)
  set messageId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasMessageId() => $_has(0);
  @$pb.TagNumber(1)
  void clearMessageId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get sessionId => $_getSZ(1);
  @$pb.TagNumber(2)
  set sessionId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSessionId() => $_has(1);
  @$pb.TagNumber(2)
  void clearSessionId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get role => $_getSZ(2);
  @$pb.TagNumber(3)
  set role($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasRole() => $_has(2);
  @$pb.TagNumber(3)
  void clearRole() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get content => $_getSZ(3);
  @$pb.TagNumber(4)
  set content($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasContent() => $_has(3);
  @$pb.TagNumber(4)
  void clearContent() => $_clearField(4);

  @$pb.TagNumber(5)
  $pb.PbList<ActionCard> get actionCards => $_getList(4);

  @$pb.TagNumber(6)
  $pb.PbList<DataCard> get dataCards => $_getList(5);

  @$pb.TagNumber(7)
  ActionQuote get pendingQuote => $_getN(6);
  @$pb.TagNumber(7)
  set pendingQuote(ActionQuote value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasPendingQuote() => $_has(6);
  @$pb.TagNumber(7)
  void clearPendingQuote() => $_clearField(7);
  @$pb.TagNumber(7)
  ActionQuote ensurePendingQuote() => $_ensure(6);

  @$pb.TagNumber(8)
  $core.bool get permissionDenied => $_getBF(7);
  @$pb.TagNumber(8)
  set permissionDenied($core.bool value) => $_setBool(7, value);
  @$pb.TagNumber(8)
  $core.bool hasPermissionDenied() => $_has(7);
  @$pb.TagNumber(8)
  void clearPermissionDenied() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get denialReason => $_getSZ(8);
  @$pb.TagNumber(9)
  set denialReason($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasDenialReason() => $_has(8);
  @$pb.TagNumber(9)
  void clearDenialReason() => $_clearField(9);

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

/// CopilotSession represents a workspace-scoped conversation session per database_schema.md §19.12.
class CopilotSession extends $pb.GeneratedMessage {
  factory CopilotSession({
    $core.String? sessionId,
    $core.String? workspaceId,
    $core.String? userId,
    CopilotMode? mode,
    $core.String? contextScope,
    $core.Iterable<CopilotMessage>? messages,
    $core.String? totalCreditsUsed,
    $1.Timestamp? endedAt,
    $1.Timestamp? createdAt,
    $1.Timestamp? updatedAt,
  }) {
    final result = CopilotSession._();
    if (sessionId != null) result.sessionId = sessionId;
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (userId != null) result.userId = userId;
    if (mode != null) result.mode = mode;
    if (contextScope != null) result.contextScope = contextScope;
    if (messages != null) result.messages.addAll(messages);
    if (totalCreditsUsed != null) result.totalCreditsUsed = totalCreditsUsed;
    if (endedAt != null) result.endedAt = endedAt;
    if (createdAt != null) result.createdAt = createdAt;
    if (updatedAt != null) result.updatedAt = updatedAt;
    return result;
  }

  CopilotSession._();

  factory CopilotSession.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CopilotSession()..mergeFromBuffer(data, registry);
  factory CopilotSession.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CopilotSession()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CopilotSession',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.copilot.v1'),
      createEmptyInstance: CopilotSession.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'sessionId')
    ..aOS(2, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(3, _omitFieldNames ? '' : 'userId')
    ..aE<CopilotMode>(4, _omitFieldNames ? '' : 'mode',
        enumValues: CopilotMode.values)
    ..aOS(5, _omitFieldNames ? '' : 'contextScope')
    ..pPM<CopilotMessage>(6, _omitFieldNames ? '' : 'messages',
        subBuilder: CopilotMessage.$_createMessage)
    ..aOS(7, _omitFieldNames ? '' : 'totalCreditsUsed')
    ..aOM<$1.Timestamp>(8, _omitFieldNames ? '' : 'endedAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..aOM<$1.Timestamp>(9, _omitFieldNames ? '' : 'createdAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..aOM<$1.Timestamp>(10, _omitFieldNames ? '' : 'updatedAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CopilotSession clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CopilotSession copyWith(void Function(CopilotSession) updates) =>
      super.copyWith((message) => updates(message as CopilotSession))
          as CopilotSession;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use CopilotSession() / CopilotSession.new instead')
  static CopilotSession create() => CopilotSession._();
  static $pb.GeneratedMessage $_createMessage() => CopilotSession._();
  @$core.override
  CopilotSession createEmptyInstance() => CopilotSession._();
  @$core.pragma('dart2js:noInline')
  static CopilotSession getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CopilotSession>(
          CopilotSession.$_createMessage);
  static CopilotSession? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get sessionId => $_getSZ(0);
  @$pb.TagNumber(1)
  set sessionId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSessionId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSessionId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get workspaceId => $_getSZ(1);
  @$pb.TagNumber(2)
  set workspaceId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasWorkspaceId() => $_has(1);
  @$pb.TagNumber(2)
  void clearWorkspaceId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get userId => $_getSZ(2);
  @$pb.TagNumber(3)
  set userId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasUserId() => $_has(2);
  @$pb.TagNumber(3)
  void clearUserId() => $_clearField(3);

  @$pb.TagNumber(4)
  CopilotMode get mode => $_getN(3);
  @$pb.TagNumber(4)
  set mode(CopilotMode value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasMode() => $_has(3);
  @$pb.TagNumber(4)
  void clearMode() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get contextScope => $_getSZ(4);
  @$pb.TagNumber(5)
  set contextScope($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasContextScope() => $_has(4);
  @$pb.TagNumber(5)
  void clearContextScope() => $_clearField(5);

  @$pb.TagNumber(6)
  $pb.PbList<CopilotMessage> get messages => $_getList(5);

  @$pb.TagNumber(7)
  $core.String get totalCreditsUsed => $_getSZ(6);
  @$pb.TagNumber(7)
  set totalCreditsUsed($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasTotalCreditsUsed() => $_has(6);
  @$pb.TagNumber(7)
  void clearTotalCreditsUsed() => $_clearField(7);

  @$pb.TagNumber(8)
  $1.Timestamp get endedAt => $_getN(7);
  @$pb.TagNumber(8)
  set endedAt($1.Timestamp value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasEndedAt() => $_has(7);
  @$pb.TagNumber(8)
  void clearEndedAt() => $_clearField(8);
  @$pb.TagNumber(8)
  $1.Timestamp ensureEndedAt() => $_ensure(7);

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

  @$pb.TagNumber(10)
  $1.Timestamp get updatedAt => $_getN(9);
  @$pb.TagNumber(10)
  set updatedAt($1.Timestamp value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasUpdatedAt() => $_has(9);
  @$pb.TagNumber(10)
  void clearUpdatedAt() => $_clearField(10);
  @$pb.TagNumber(10)
  $1.Timestamp ensureUpdatedAt() => $_ensure(9);
}

/// SuggestionItem represents a recommended quick prompt or action.
class SuggestionItem extends $pb.GeneratedMessage {
  factory SuggestionItem({
    $core.String? suggestionId,
    $core.String? label,
    $core.String? promptText,
    $core.String? category,
    $core.String? targetModule,
  }) {
    final result = SuggestionItem._();
    if (suggestionId != null) result.suggestionId = suggestionId;
    if (label != null) result.label = label;
    if (promptText != null) result.promptText = promptText;
    if (category != null) result.category = category;
    if (targetModule != null) result.targetModule = targetModule;
    return result;
  }

  SuggestionItem._();

  factory SuggestionItem.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SuggestionItem()..mergeFromBuffer(data, registry);
  factory SuggestionItem.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SuggestionItem()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SuggestionItem',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.copilot.v1'),
      createEmptyInstance: SuggestionItem.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'suggestionId')
    ..aOS(2, _omitFieldNames ? '' : 'label')
    ..aOS(3, _omitFieldNames ? '' : 'promptText')
    ..aOS(4, _omitFieldNames ? '' : 'category')
    ..aOS(5, _omitFieldNames ? '' : 'targetModule')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SuggestionItem clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SuggestionItem copyWith(void Function(SuggestionItem) updates) =>
      super.copyWith((message) => updates(message as SuggestionItem))
          as SuggestionItem;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use SuggestionItem() / SuggestionItem.new instead')
  static SuggestionItem create() => SuggestionItem._();
  static $pb.GeneratedMessage $_createMessage() => SuggestionItem._();
  @$core.override
  SuggestionItem createEmptyInstance() => SuggestionItem._();
  @$core.pragma('dart2js:noInline')
  static SuggestionItem getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SuggestionItem>(
          SuggestionItem.$_createMessage);
  static SuggestionItem? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get suggestionId => $_getSZ(0);
  @$pb.TagNumber(1)
  set suggestionId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSuggestionId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSuggestionId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get label => $_getSZ(1);
  @$pb.TagNumber(2)
  set label($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasLabel() => $_has(1);
  @$pb.TagNumber(2)
  void clearLabel() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get promptText => $_getSZ(2);
  @$pb.TagNumber(3)
  set promptText($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPromptText() => $_has(2);
  @$pb.TagNumber(3)
  void clearPromptText() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get category => $_getSZ(3);
  @$pb.TagNumber(4)
  set category($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasCategory() => $_has(3);
  @$pb.TagNumber(4)
  void clearCategory() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get targetModule => $_getSZ(4);
  @$pb.TagNumber(5)
  set targetModule($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasTargetModule() => $_has(4);
  @$pb.TagNumber(5)
  void clearTargetModule() => $_clearField(5);
}

class CopilotServiceQueryRequest extends $pb.GeneratedMessage {
  factory CopilotServiceQueryRequest({
    $core.String? workspaceId,
    $core.String? sessionId,
    $core.String? query,
    CopilotMode? mode,
    $core.String? contextScope,
    $core.Iterable<$core.String>? contextIds,
    $core.String? confirmedQuoteId,
  }) {
    final result = CopilotServiceQueryRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (sessionId != null) result.sessionId = sessionId;
    if (query != null) result.query = query;
    if (mode != null) result.mode = mode;
    if (contextScope != null) result.contextScope = contextScope;
    if (contextIds != null) result.contextIds.addAll(contextIds);
    if (confirmedQuoteId != null) result.confirmedQuoteId = confirmedQuoteId;
    return result;
  }

  CopilotServiceQueryRequest._();

  factory CopilotServiceQueryRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CopilotServiceQueryRequest()..mergeFromBuffer(data, registry);
  factory CopilotServiceQueryRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CopilotServiceQueryRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CopilotServiceQueryRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.copilot.v1'),
      createEmptyInstance: CopilotServiceQueryRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'sessionId')
    ..aOS(3, _omitFieldNames ? '' : 'query')
    ..aE<CopilotMode>(4, _omitFieldNames ? '' : 'mode',
        enumValues: CopilotMode.values)
    ..aOS(5, _omitFieldNames ? '' : 'contextScope')
    ..pPS(6, _omitFieldNames ? '' : 'contextIds')
    ..aOS(7, _omitFieldNames ? '' : 'confirmedQuoteId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CopilotServiceQueryRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CopilotServiceQueryRequest copyWith(
          void Function(CopilotServiceQueryRequest) updates) =>
      super.copyWith(
              (message) => updates(message as CopilotServiceQueryRequest))
          as CopilotServiceQueryRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use CopilotServiceQueryRequest() / CopilotServiceQueryRequest.new instead')
  static CopilotServiceQueryRequest create() => CopilotServiceQueryRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      CopilotServiceQueryRequest._();
  @$core.override
  CopilotServiceQueryRequest createEmptyInstance() =>
      CopilotServiceQueryRequest._();
  @$core.pragma('dart2js:noInline')
  static CopilotServiceQueryRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CopilotServiceQueryRequest>(
          CopilotServiceQueryRequest.$_createMessage);
  static CopilotServiceQueryRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get sessionId => $_getSZ(1);
  @$pb.TagNumber(2)
  set sessionId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSessionId() => $_has(1);
  @$pb.TagNumber(2)
  void clearSessionId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get query => $_getSZ(2);
  @$pb.TagNumber(3)
  set query($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasQuery() => $_has(2);
  @$pb.TagNumber(3)
  void clearQuery() => $_clearField(3);

  @$pb.TagNumber(4)
  CopilotMode get mode => $_getN(3);
  @$pb.TagNumber(4)
  set mode(CopilotMode value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasMode() => $_has(3);
  @$pb.TagNumber(4)
  void clearMode() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get contextScope => $_getSZ(4);
  @$pb.TagNumber(5)
  set contextScope($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasContextScope() => $_has(4);
  @$pb.TagNumber(5)
  void clearContextScope() => $_clearField(5);

  @$pb.TagNumber(6)
  $pb.PbList<$core.String> get contextIds => $_getList(5);

  @$pb.TagNumber(7)
  $core.String get confirmedQuoteId => $_getSZ(6);
  @$pb.TagNumber(7)
  set confirmedQuoteId($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasConfirmedQuoteId() => $_has(6);
  @$pb.TagNumber(7)
  void clearConfirmedQuoteId() => $_clearField(7);
}

class CopilotServiceQueryResponse extends $pb.GeneratedMessage {
  factory CopilotServiceQueryResponse({
    CopilotSession? session,
    CopilotMessage? message,
    $core.bool? requiresQuoteConfirmation,
    ActionQuote? quote,
    $core.bool? isFinancialQuery,
    $core.bool? financialDataRedacted,
  }) {
    final result = CopilotServiceQueryResponse._();
    if (session != null) result.session = session;
    if (message != null) result.message = message;
    if (requiresQuoteConfirmation != null)
      result.requiresQuoteConfirmation = requiresQuoteConfirmation;
    if (quote != null) result.quote = quote;
    if (isFinancialQuery != null) result.isFinancialQuery = isFinancialQuery;
    if (financialDataRedacted != null)
      result.financialDataRedacted = financialDataRedacted;
    return result;
  }

  CopilotServiceQueryResponse._();

  factory CopilotServiceQueryResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CopilotServiceQueryResponse()..mergeFromBuffer(data, registry);
  factory CopilotServiceQueryResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CopilotServiceQueryResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CopilotServiceQueryResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.copilot.v1'),
      createEmptyInstance: CopilotServiceQueryResponse.$_createMessage)
    ..aOM<CopilotSession>(1, _omitFieldNames ? '' : 'session',
        subBuilder: CopilotSession.$_createMessage)
    ..aOM<CopilotMessage>(2, _omitFieldNames ? '' : 'message',
        subBuilder: CopilotMessage.$_createMessage)
    ..aOB(3, _omitFieldNames ? '' : 'requiresQuoteConfirmation')
    ..aOM<ActionQuote>(4, _omitFieldNames ? '' : 'quote',
        subBuilder: ActionQuote.$_createMessage)
    ..aOB(5, _omitFieldNames ? '' : 'isFinancialQuery')
    ..aOB(6, _omitFieldNames ? '' : 'financialDataRedacted')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CopilotServiceQueryResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CopilotServiceQueryResponse copyWith(
          void Function(CopilotServiceQueryResponse) updates) =>
      super.copyWith(
              (message) => updates(message as CopilotServiceQueryResponse))
          as CopilotServiceQueryResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use CopilotServiceQueryResponse() / CopilotServiceQueryResponse.new instead')
  static CopilotServiceQueryResponse create() =>
      CopilotServiceQueryResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      CopilotServiceQueryResponse._();
  @$core.override
  CopilotServiceQueryResponse createEmptyInstance() =>
      CopilotServiceQueryResponse._();
  @$core.pragma('dart2js:noInline')
  static CopilotServiceQueryResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CopilotServiceQueryResponse>(
          CopilotServiceQueryResponse.$_createMessage);
  static CopilotServiceQueryResponse? _defaultInstance;

  @$pb.TagNumber(1)
  CopilotSession get session => $_getN(0);
  @$pb.TagNumber(1)
  set session(CopilotSession value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasSession() => $_has(0);
  @$pb.TagNumber(1)
  void clearSession() => $_clearField(1);
  @$pb.TagNumber(1)
  CopilotSession ensureSession() => $_ensure(0);

  @$pb.TagNumber(2)
  CopilotMessage get message => $_getN(1);
  @$pb.TagNumber(2)
  set message(CopilotMessage value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasMessage() => $_has(1);
  @$pb.TagNumber(2)
  void clearMessage() => $_clearField(2);
  @$pb.TagNumber(2)
  CopilotMessage ensureMessage() => $_ensure(1);

  @$pb.TagNumber(3)
  $core.bool get requiresQuoteConfirmation => $_getBF(2);
  @$pb.TagNumber(3)
  set requiresQuoteConfirmation($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasRequiresQuoteConfirmation() => $_has(2);
  @$pb.TagNumber(3)
  void clearRequiresQuoteConfirmation() => $_clearField(3);

  @$pb.TagNumber(4)
  ActionQuote get quote => $_getN(3);
  @$pb.TagNumber(4)
  set quote(ActionQuote value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasQuote() => $_has(3);
  @$pb.TagNumber(4)
  void clearQuote() => $_clearField(4);
  @$pb.TagNumber(4)
  ActionQuote ensureQuote() => $_ensure(3);

  @$pb.TagNumber(5)
  $core.bool get isFinancialQuery => $_getBF(4);
  @$pb.TagNumber(5)
  set isFinancialQuery($core.bool value) => $_setBool(4, value);
  @$pb.TagNumber(5)
  $core.bool hasIsFinancialQuery() => $_has(4);
  @$pb.TagNumber(5)
  void clearIsFinancialQuery() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.bool get financialDataRedacted => $_getBF(5);
  @$pb.TagNumber(6)
  set financialDataRedacted($core.bool value) => $_setBool(5, value);
  @$pb.TagNumber(6)
  $core.bool hasFinancialDataRedacted() => $_has(5);
  @$pb.TagNumber(6)
  void clearFinancialDataRedacted() => $_clearField(6);
}

class CopilotServiceSendMessageRequest extends $pb.GeneratedMessage {
  factory CopilotServiceSendMessageRequest({
    $core.String? workspaceId,
    $core.String? sessionId,
    $core.String? content,
    CopilotMode? mode,
    $core.String? contextScope,
    $core.String? confirmedQuoteId,
  }) {
    final result = CopilotServiceSendMessageRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (sessionId != null) result.sessionId = sessionId;
    if (content != null) result.content = content;
    if (mode != null) result.mode = mode;
    if (contextScope != null) result.contextScope = contextScope;
    if (confirmedQuoteId != null) result.confirmedQuoteId = confirmedQuoteId;
    return result;
  }

  CopilotServiceSendMessageRequest._();

  factory CopilotServiceSendMessageRequest.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CopilotServiceSendMessageRequest()..mergeFromBuffer(data, registry);
  factory CopilotServiceSendMessageRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CopilotServiceSendMessageRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CopilotServiceSendMessageRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.copilot.v1'),
      createEmptyInstance: CopilotServiceSendMessageRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'sessionId')
    ..aOS(3, _omitFieldNames ? '' : 'content')
    ..aE<CopilotMode>(4, _omitFieldNames ? '' : 'mode',
        enumValues: CopilotMode.values)
    ..aOS(5, _omitFieldNames ? '' : 'contextScope')
    ..aOS(6, _omitFieldNames ? '' : 'confirmedQuoteId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CopilotServiceSendMessageRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CopilotServiceSendMessageRequest copyWith(
          void Function(CopilotServiceSendMessageRequest) updates) =>
      super.copyWith(
              (message) => updates(message as CopilotServiceSendMessageRequest))
          as CopilotServiceSendMessageRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use CopilotServiceSendMessageRequest() / CopilotServiceSendMessageRequest.new instead')
  static CopilotServiceSendMessageRequest create() =>
      CopilotServiceSendMessageRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      CopilotServiceSendMessageRequest._();
  @$core.override
  CopilotServiceSendMessageRequest createEmptyInstance() =>
      CopilotServiceSendMessageRequest._();
  @$core.pragma('dart2js:noInline')
  static CopilotServiceSendMessageRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CopilotServiceSendMessageRequest>(
          CopilotServiceSendMessageRequest.$_createMessage);
  static CopilotServiceSendMessageRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get sessionId => $_getSZ(1);
  @$pb.TagNumber(2)
  set sessionId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSessionId() => $_has(1);
  @$pb.TagNumber(2)
  void clearSessionId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get content => $_getSZ(2);
  @$pb.TagNumber(3)
  set content($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasContent() => $_has(2);
  @$pb.TagNumber(3)
  void clearContent() => $_clearField(3);

  @$pb.TagNumber(4)
  CopilotMode get mode => $_getN(3);
  @$pb.TagNumber(4)
  set mode(CopilotMode value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasMode() => $_has(3);
  @$pb.TagNumber(4)
  void clearMode() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get contextScope => $_getSZ(4);
  @$pb.TagNumber(5)
  set contextScope($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasContextScope() => $_has(4);
  @$pb.TagNumber(5)
  void clearContextScope() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get confirmedQuoteId => $_getSZ(5);
  @$pb.TagNumber(6)
  set confirmedQuoteId($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasConfirmedQuoteId() => $_has(5);
  @$pb.TagNumber(6)
  void clearConfirmedQuoteId() => $_clearField(6);
}

class CopilotServiceSendMessageResponse extends $pb.GeneratedMessage {
  factory CopilotServiceSendMessageResponse({
    CopilotSession? session,
    CopilotMessage? reply,
    $core.bool? requiresQuoteConfirmation,
    ActionQuote? quote,
  }) {
    final result = CopilotServiceSendMessageResponse._();
    if (session != null) result.session = session;
    if (reply != null) result.reply = reply;
    if (requiresQuoteConfirmation != null)
      result.requiresQuoteConfirmation = requiresQuoteConfirmation;
    if (quote != null) result.quote = quote;
    return result;
  }

  CopilotServiceSendMessageResponse._();

  factory CopilotServiceSendMessageResponse.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CopilotServiceSendMessageResponse()..mergeFromBuffer(data, registry);
  factory CopilotServiceSendMessageResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CopilotServiceSendMessageResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CopilotServiceSendMessageResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.copilot.v1'),
      createEmptyInstance: CopilotServiceSendMessageResponse.$_createMessage)
    ..aOM<CopilotSession>(1, _omitFieldNames ? '' : 'session',
        subBuilder: CopilotSession.$_createMessage)
    ..aOM<CopilotMessage>(2, _omitFieldNames ? '' : 'reply',
        subBuilder: CopilotMessage.$_createMessage)
    ..aOB(3, _omitFieldNames ? '' : 'requiresQuoteConfirmation')
    ..aOM<ActionQuote>(4, _omitFieldNames ? '' : 'quote',
        subBuilder: ActionQuote.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CopilotServiceSendMessageResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CopilotServiceSendMessageResponse copyWith(
          void Function(CopilotServiceSendMessageResponse) updates) =>
      super.copyWith((message) =>
              updates(message as CopilotServiceSendMessageResponse))
          as CopilotServiceSendMessageResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use CopilotServiceSendMessageResponse() / CopilotServiceSendMessageResponse.new instead')
  static CopilotServiceSendMessageResponse create() =>
      CopilotServiceSendMessageResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      CopilotServiceSendMessageResponse._();
  @$core.override
  CopilotServiceSendMessageResponse createEmptyInstance() =>
      CopilotServiceSendMessageResponse._();
  @$core.pragma('dart2js:noInline')
  static CopilotServiceSendMessageResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CopilotServiceSendMessageResponse>(
          CopilotServiceSendMessageResponse.$_createMessage);
  static CopilotServiceSendMessageResponse? _defaultInstance;

  @$pb.TagNumber(1)
  CopilotSession get session => $_getN(0);
  @$pb.TagNumber(1)
  set session(CopilotSession value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasSession() => $_has(0);
  @$pb.TagNumber(1)
  void clearSession() => $_clearField(1);
  @$pb.TagNumber(1)
  CopilotSession ensureSession() => $_ensure(0);

  @$pb.TagNumber(2)
  CopilotMessage get reply => $_getN(1);
  @$pb.TagNumber(2)
  set reply(CopilotMessage value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasReply() => $_has(1);
  @$pb.TagNumber(2)
  void clearReply() => $_clearField(2);
  @$pb.TagNumber(2)
  CopilotMessage ensureReply() => $_ensure(1);

  @$pb.TagNumber(3)
  $core.bool get requiresQuoteConfirmation => $_getBF(2);
  @$pb.TagNumber(3)
  set requiresQuoteConfirmation($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasRequiresQuoteConfirmation() => $_has(2);
  @$pb.TagNumber(3)
  void clearRequiresQuoteConfirmation() => $_clearField(3);

  @$pb.TagNumber(4)
  ActionQuote get quote => $_getN(3);
  @$pb.TagNumber(4)
  set quote(ActionQuote value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasQuote() => $_has(3);
  @$pb.TagNumber(4)
  void clearQuote() => $_clearField(4);
  @$pb.TagNumber(4)
  ActionQuote ensureQuote() => $_ensure(3);
}

class CopilotServiceChatRequest extends $pb.GeneratedMessage {
  factory CopilotServiceChatRequest({
    $core.String? workspaceId,
    $core.String? sessionId,
    $core.String? message,
    CopilotMode? mode,
    $core.String? contextScope,
  }) {
    final result = CopilotServiceChatRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (sessionId != null) result.sessionId = sessionId;
    if (message != null) result.message = message;
    if (mode != null) result.mode = mode;
    if (contextScope != null) result.contextScope = contextScope;
    return result;
  }

  CopilotServiceChatRequest._();

  factory CopilotServiceChatRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CopilotServiceChatRequest()..mergeFromBuffer(data, registry);
  factory CopilotServiceChatRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CopilotServiceChatRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CopilotServiceChatRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.copilot.v1'),
      createEmptyInstance: CopilotServiceChatRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'sessionId')
    ..aOS(3, _omitFieldNames ? '' : 'message')
    ..aE<CopilotMode>(4, _omitFieldNames ? '' : 'mode',
        enumValues: CopilotMode.values)
    ..aOS(5, _omitFieldNames ? '' : 'contextScope')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CopilotServiceChatRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CopilotServiceChatRequest copyWith(
          void Function(CopilotServiceChatRequest) updates) =>
      super.copyWith((message) => updates(message as CopilotServiceChatRequest))
          as CopilotServiceChatRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use CopilotServiceChatRequest() / CopilotServiceChatRequest.new instead')
  static CopilotServiceChatRequest create() => CopilotServiceChatRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      CopilotServiceChatRequest._();
  @$core.override
  CopilotServiceChatRequest createEmptyInstance() =>
      CopilotServiceChatRequest._();
  @$core.pragma('dart2js:noInline')
  static CopilotServiceChatRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CopilotServiceChatRequest>(
          CopilotServiceChatRequest.$_createMessage);
  static CopilotServiceChatRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get sessionId => $_getSZ(1);
  @$pb.TagNumber(2)
  set sessionId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSessionId() => $_has(1);
  @$pb.TagNumber(2)
  void clearSessionId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get message => $_getSZ(2);
  @$pb.TagNumber(3)
  set message($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasMessage() => $_has(2);
  @$pb.TagNumber(3)
  void clearMessage() => $_clearField(3);

  @$pb.TagNumber(4)
  CopilotMode get mode => $_getN(3);
  @$pb.TagNumber(4)
  set mode(CopilotMode value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasMode() => $_has(3);
  @$pb.TagNumber(4)
  void clearMode() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get contextScope => $_getSZ(4);
  @$pb.TagNumber(5)
  set contextScope($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasContextScope() => $_has(4);
  @$pb.TagNumber(5)
  void clearContextScope() => $_clearField(5);
}

class CopilotServiceChatResponse extends $pb.GeneratedMessage {
  factory CopilotServiceChatResponse({
    CopilotSession? session,
    CopilotMessage? reply,
  }) {
    final result = CopilotServiceChatResponse._();
    if (session != null) result.session = session;
    if (reply != null) result.reply = reply;
    return result;
  }

  CopilotServiceChatResponse._();

  factory CopilotServiceChatResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CopilotServiceChatResponse()..mergeFromBuffer(data, registry);
  factory CopilotServiceChatResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CopilotServiceChatResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CopilotServiceChatResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.copilot.v1'),
      createEmptyInstance: CopilotServiceChatResponse.$_createMessage)
    ..aOM<CopilotSession>(1, _omitFieldNames ? '' : 'session',
        subBuilder: CopilotSession.$_createMessage)
    ..aOM<CopilotMessage>(2, _omitFieldNames ? '' : 'reply',
        subBuilder: CopilotMessage.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CopilotServiceChatResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CopilotServiceChatResponse copyWith(
          void Function(CopilotServiceChatResponse) updates) =>
      super.copyWith(
              (message) => updates(message as CopilotServiceChatResponse))
          as CopilotServiceChatResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use CopilotServiceChatResponse() / CopilotServiceChatResponse.new instead')
  static CopilotServiceChatResponse create() => CopilotServiceChatResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      CopilotServiceChatResponse._();
  @$core.override
  CopilotServiceChatResponse createEmptyInstance() =>
      CopilotServiceChatResponse._();
  @$core.pragma('dart2js:noInline')
  static CopilotServiceChatResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CopilotServiceChatResponse>(
          CopilotServiceChatResponse.$_createMessage);
  static CopilotServiceChatResponse? _defaultInstance;

  @$pb.TagNumber(1)
  CopilotSession get session => $_getN(0);
  @$pb.TagNumber(1)
  set session(CopilotSession value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasSession() => $_has(0);
  @$pb.TagNumber(1)
  void clearSession() => $_clearField(1);
  @$pb.TagNumber(1)
  CopilotSession ensureSession() => $_ensure(0);

  @$pb.TagNumber(2)
  CopilotMessage get reply => $_getN(1);
  @$pb.TagNumber(2)
  set reply(CopilotMessage value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasReply() => $_has(1);
  @$pb.TagNumber(2)
  void clearReply() => $_clearField(2);
  @$pb.TagNumber(2)
  CopilotMessage ensureReply() => $_ensure(1);
}

class CopilotServiceGetSessionRequest extends $pb.GeneratedMessage {
  factory CopilotServiceGetSessionRequest({
    $core.String? workspaceId,
    $core.String? sessionId,
  }) {
    final result = CopilotServiceGetSessionRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (sessionId != null) result.sessionId = sessionId;
    return result;
  }

  CopilotServiceGetSessionRequest._();

  factory CopilotServiceGetSessionRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CopilotServiceGetSessionRequest()..mergeFromBuffer(data, registry);
  factory CopilotServiceGetSessionRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CopilotServiceGetSessionRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CopilotServiceGetSessionRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.copilot.v1'),
      createEmptyInstance: CopilotServiceGetSessionRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'sessionId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CopilotServiceGetSessionRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CopilotServiceGetSessionRequest copyWith(
          void Function(CopilotServiceGetSessionRequest) updates) =>
      super.copyWith(
              (message) => updates(message as CopilotServiceGetSessionRequest))
          as CopilotServiceGetSessionRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use CopilotServiceGetSessionRequest() / CopilotServiceGetSessionRequest.new instead')
  static CopilotServiceGetSessionRequest create() =>
      CopilotServiceGetSessionRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      CopilotServiceGetSessionRequest._();
  @$core.override
  CopilotServiceGetSessionRequest createEmptyInstance() =>
      CopilotServiceGetSessionRequest._();
  @$core.pragma('dart2js:noInline')
  static CopilotServiceGetSessionRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CopilotServiceGetSessionRequest>(
          CopilotServiceGetSessionRequest.$_createMessage);
  static CopilotServiceGetSessionRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get sessionId => $_getSZ(1);
  @$pb.TagNumber(2)
  set sessionId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSessionId() => $_has(1);
  @$pb.TagNumber(2)
  void clearSessionId() => $_clearField(2);
}

class CopilotServiceGetSessionResponse extends $pb.GeneratedMessage {
  factory CopilotServiceGetSessionResponse({
    CopilotSession? session,
  }) {
    final result = CopilotServiceGetSessionResponse._();
    if (session != null) result.session = session;
    return result;
  }

  CopilotServiceGetSessionResponse._();

  factory CopilotServiceGetSessionResponse.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CopilotServiceGetSessionResponse()..mergeFromBuffer(data, registry);
  factory CopilotServiceGetSessionResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CopilotServiceGetSessionResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CopilotServiceGetSessionResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.copilot.v1'),
      createEmptyInstance: CopilotServiceGetSessionResponse.$_createMessage)
    ..aOM<CopilotSession>(1, _omitFieldNames ? '' : 'session',
        subBuilder: CopilotSession.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CopilotServiceGetSessionResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CopilotServiceGetSessionResponse copyWith(
          void Function(CopilotServiceGetSessionResponse) updates) =>
      super.copyWith(
              (message) => updates(message as CopilotServiceGetSessionResponse))
          as CopilotServiceGetSessionResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use CopilotServiceGetSessionResponse() / CopilotServiceGetSessionResponse.new instead')
  static CopilotServiceGetSessionResponse create() =>
      CopilotServiceGetSessionResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      CopilotServiceGetSessionResponse._();
  @$core.override
  CopilotServiceGetSessionResponse createEmptyInstance() =>
      CopilotServiceGetSessionResponse._();
  @$core.pragma('dart2js:noInline')
  static CopilotServiceGetSessionResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CopilotServiceGetSessionResponse>(
          CopilotServiceGetSessionResponse.$_createMessage);
  static CopilotServiceGetSessionResponse? _defaultInstance;

  @$pb.TagNumber(1)
  CopilotSession get session => $_getN(0);
  @$pb.TagNumber(1)
  set session(CopilotSession value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasSession() => $_has(0);
  @$pb.TagNumber(1)
  void clearSession() => $_clearField(1);
  @$pb.TagNumber(1)
  CopilotSession ensureSession() => $_ensure(0);
}

class CopilotServiceClearSessionRequest extends $pb.GeneratedMessage {
  factory CopilotServiceClearSessionRequest({
    $core.String? workspaceId,
    $core.String? sessionId,
  }) {
    final result = CopilotServiceClearSessionRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (sessionId != null) result.sessionId = sessionId;
    return result;
  }

  CopilotServiceClearSessionRequest._();

  factory CopilotServiceClearSessionRequest.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CopilotServiceClearSessionRequest()..mergeFromBuffer(data, registry);
  factory CopilotServiceClearSessionRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CopilotServiceClearSessionRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CopilotServiceClearSessionRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.copilot.v1'),
      createEmptyInstance: CopilotServiceClearSessionRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'sessionId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CopilotServiceClearSessionRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CopilotServiceClearSessionRequest copyWith(
          void Function(CopilotServiceClearSessionRequest) updates) =>
      super.copyWith((message) =>
              updates(message as CopilotServiceClearSessionRequest))
          as CopilotServiceClearSessionRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use CopilotServiceClearSessionRequest() / CopilotServiceClearSessionRequest.new instead')
  static CopilotServiceClearSessionRequest create() =>
      CopilotServiceClearSessionRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      CopilotServiceClearSessionRequest._();
  @$core.override
  CopilotServiceClearSessionRequest createEmptyInstance() =>
      CopilotServiceClearSessionRequest._();
  @$core.pragma('dart2js:noInline')
  static CopilotServiceClearSessionRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CopilotServiceClearSessionRequest>(
          CopilotServiceClearSessionRequest.$_createMessage);
  static CopilotServiceClearSessionRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get sessionId => $_getSZ(1);
  @$pb.TagNumber(2)
  set sessionId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSessionId() => $_has(1);
  @$pb.TagNumber(2)
  void clearSessionId() => $_clearField(2);
}

class CopilotServiceClearSessionResponse extends $pb.GeneratedMessage {
  factory CopilotServiceClearSessionResponse({
    $core.bool? cleared,
    $core.String? sessionId,
  }) {
    final result = CopilotServiceClearSessionResponse._();
    if (cleared != null) result.cleared = cleared;
    if (sessionId != null) result.sessionId = sessionId;
    return result;
  }

  CopilotServiceClearSessionResponse._();

  factory CopilotServiceClearSessionResponse.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CopilotServiceClearSessionResponse()..mergeFromBuffer(data, registry);
  factory CopilotServiceClearSessionResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CopilotServiceClearSessionResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CopilotServiceClearSessionResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.copilot.v1'),
      createEmptyInstance: CopilotServiceClearSessionResponse.$_createMessage)
    ..aOB(1, _omitFieldNames ? '' : 'cleared')
    ..aOS(2, _omitFieldNames ? '' : 'sessionId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CopilotServiceClearSessionResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CopilotServiceClearSessionResponse copyWith(
          void Function(CopilotServiceClearSessionResponse) updates) =>
      super.copyWith((message) =>
              updates(message as CopilotServiceClearSessionResponse))
          as CopilotServiceClearSessionResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use CopilotServiceClearSessionResponse() / CopilotServiceClearSessionResponse.new instead')
  static CopilotServiceClearSessionResponse create() =>
      CopilotServiceClearSessionResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      CopilotServiceClearSessionResponse._();
  @$core.override
  CopilotServiceClearSessionResponse createEmptyInstance() =>
      CopilotServiceClearSessionResponse._();
  @$core.pragma('dart2js:noInline')
  static CopilotServiceClearSessionResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CopilotServiceClearSessionResponse>(
          CopilotServiceClearSessionResponse.$_createMessage);
  static CopilotServiceClearSessionResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get cleared => $_getBF(0);
  @$pb.TagNumber(1)
  set cleared($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCleared() => $_has(0);
  @$pb.TagNumber(1)
  void clearCleared() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get sessionId => $_getSZ(1);
  @$pb.TagNumber(2)
  set sessionId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSessionId() => $_has(1);
  @$pb.TagNumber(2)
  void clearSessionId() => $_clearField(2);
}

class CopilotServiceGetSuggestionsRequest extends $pb.GeneratedMessage {
  factory CopilotServiceGetSuggestionsRequest({
    $core.String? workspaceId,
    $core.String? contextScope,
    CopilotMode? mode,
  }) {
    final result = CopilotServiceGetSuggestionsRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (contextScope != null) result.contextScope = contextScope;
    if (mode != null) result.mode = mode;
    return result;
  }

  CopilotServiceGetSuggestionsRequest._();

  factory CopilotServiceGetSuggestionsRequest.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CopilotServiceGetSuggestionsRequest()..mergeFromBuffer(data, registry);
  factory CopilotServiceGetSuggestionsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CopilotServiceGetSuggestionsRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CopilotServiceGetSuggestionsRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.copilot.v1'),
      createEmptyInstance: CopilotServiceGetSuggestionsRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'contextScope')
    ..aE<CopilotMode>(3, _omitFieldNames ? '' : 'mode',
        enumValues: CopilotMode.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CopilotServiceGetSuggestionsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CopilotServiceGetSuggestionsRequest copyWith(
          void Function(CopilotServiceGetSuggestionsRequest) updates) =>
      super.copyWith((message) =>
              updates(message as CopilotServiceGetSuggestionsRequest))
          as CopilotServiceGetSuggestionsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use CopilotServiceGetSuggestionsRequest() / CopilotServiceGetSuggestionsRequest.new instead')
  static CopilotServiceGetSuggestionsRequest create() =>
      CopilotServiceGetSuggestionsRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      CopilotServiceGetSuggestionsRequest._();
  @$core.override
  CopilotServiceGetSuggestionsRequest createEmptyInstance() =>
      CopilotServiceGetSuggestionsRequest._();
  @$core.pragma('dart2js:noInline')
  static CopilotServiceGetSuggestionsRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
              CopilotServiceGetSuggestionsRequest>(
          CopilotServiceGetSuggestionsRequest.$_createMessage);
  static CopilotServiceGetSuggestionsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get contextScope => $_getSZ(1);
  @$pb.TagNumber(2)
  set contextScope($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasContextScope() => $_has(1);
  @$pb.TagNumber(2)
  void clearContextScope() => $_clearField(2);

  @$pb.TagNumber(3)
  CopilotMode get mode => $_getN(2);
  @$pb.TagNumber(3)
  set mode(CopilotMode value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasMode() => $_has(2);
  @$pb.TagNumber(3)
  void clearMode() => $_clearField(3);
}

class CopilotServiceGetSuggestionsResponse extends $pb.GeneratedMessage {
  factory CopilotServiceGetSuggestionsResponse({
    $core.Iterable<SuggestionItem>? suggestions,
  }) {
    final result = CopilotServiceGetSuggestionsResponse._();
    if (suggestions != null) result.suggestions.addAll(suggestions);
    return result;
  }

  CopilotServiceGetSuggestionsResponse._();

  factory CopilotServiceGetSuggestionsResponse.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CopilotServiceGetSuggestionsResponse()..mergeFromBuffer(data, registry);
  factory CopilotServiceGetSuggestionsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CopilotServiceGetSuggestionsResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CopilotServiceGetSuggestionsResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.copilot.v1'),
      createEmptyInstance: CopilotServiceGetSuggestionsResponse.$_createMessage)
    ..pPM<SuggestionItem>(1, _omitFieldNames ? '' : 'suggestions',
        subBuilder: SuggestionItem.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CopilotServiceGetSuggestionsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CopilotServiceGetSuggestionsResponse copyWith(
          void Function(CopilotServiceGetSuggestionsResponse) updates) =>
      super.copyWith((message) =>
              updates(message as CopilotServiceGetSuggestionsResponse))
          as CopilotServiceGetSuggestionsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use CopilotServiceGetSuggestionsResponse() / CopilotServiceGetSuggestionsResponse.new instead')
  static CopilotServiceGetSuggestionsResponse create() =>
      CopilotServiceGetSuggestionsResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      CopilotServiceGetSuggestionsResponse._();
  @$core.override
  CopilotServiceGetSuggestionsResponse createEmptyInstance() =>
      CopilotServiceGetSuggestionsResponse._();
  @$core.pragma('dart2js:noInline')
  static CopilotServiceGetSuggestionsResponse getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
              CopilotServiceGetSuggestionsResponse>(
          CopilotServiceGetSuggestionsResponse.$_createMessage);
  static CopilotServiceGetSuggestionsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<SuggestionItem> get suggestions => $_getList(0);
}

class CopilotServiceGetContextualActionsRequest extends $pb.GeneratedMessage {
  factory CopilotServiceGetContextualActionsRequest({
    $core.String? workspaceId,
    $core.String? screenRoute,
    $core.String? objectId,
  }) {
    final result = CopilotServiceGetContextualActionsRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (screenRoute != null) result.screenRoute = screenRoute;
    if (objectId != null) result.objectId = objectId;
    return result;
  }

  CopilotServiceGetContextualActionsRequest._();

  factory CopilotServiceGetContextualActionsRequest.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CopilotServiceGetContextualActionsRequest()
        ..mergeFromBuffer(data, registry);
  factory CopilotServiceGetContextualActionsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CopilotServiceGetContextualActionsRequest()
        ..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CopilotServiceGetContextualActionsRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.copilot.v1'),
      createEmptyInstance:
          CopilotServiceGetContextualActionsRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'screenRoute')
    ..aOS(3, _omitFieldNames ? '' : 'objectId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CopilotServiceGetContextualActionsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CopilotServiceGetContextualActionsRequest copyWith(
          void Function(CopilotServiceGetContextualActionsRequest) updates) =>
      super.copyWith((message) =>
              updates(message as CopilotServiceGetContextualActionsRequest))
          as CopilotServiceGetContextualActionsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use CopilotServiceGetContextualActionsRequest() / CopilotServiceGetContextualActionsRequest.new instead')
  static CopilotServiceGetContextualActionsRequest create() =>
      CopilotServiceGetContextualActionsRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      CopilotServiceGetContextualActionsRequest._();
  @$core.override
  CopilotServiceGetContextualActionsRequest createEmptyInstance() =>
      CopilotServiceGetContextualActionsRequest._();
  @$core.pragma('dart2js:noInline')
  static CopilotServiceGetContextualActionsRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
              CopilotServiceGetContextualActionsRequest>(
          CopilotServiceGetContextualActionsRequest.$_createMessage);
  static CopilotServiceGetContextualActionsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get screenRoute => $_getSZ(1);
  @$pb.TagNumber(2)
  set screenRoute($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasScreenRoute() => $_has(1);
  @$pb.TagNumber(2)
  void clearScreenRoute() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get objectId => $_getSZ(2);
  @$pb.TagNumber(3)
  set objectId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasObjectId() => $_has(2);
  @$pb.TagNumber(3)
  void clearObjectId() => $_clearField(3);
}

class CopilotServiceGetContextualActionsResponse extends $pb.GeneratedMessage {
  factory CopilotServiceGetContextualActionsResponse({
    $core.Iterable<ActionCard>? actions,
  }) {
    final result = CopilotServiceGetContextualActionsResponse._();
    if (actions != null) result.actions.addAll(actions);
    return result;
  }

  CopilotServiceGetContextualActionsResponse._();

  factory CopilotServiceGetContextualActionsResponse.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CopilotServiceGetContextualActionsResponse()
        ..mergeFromBuffer(data, registry);
  factory CopilotServiceGetContextualActionsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CopilotServiceGetContextualActionsResponse()
        ..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CopilotServiceGetContextualActionsResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.copilot.v1'),
      createEmptyInstance:
          CopilotServiceGetContextualActionsResponse.$_createMessage)
    ..pPM<ActionCard>(1, _omitFieldNames ? '' : 'actions',
        subBuilder: ActionCard.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CopilotServiceGetContextualActionsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CopilotServiceGetContextualActionsResponse copyWith(
          void Function(CopilotServiceGetContextualActionsResponse) updates) =>
      super.copyWith((message) =>
              updates(message as CopilotServiceGetContextualActionsResponse))
          as CopilotServiceGetContextualActionsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use CopilotServiceGetContextualActionsResponse() / CopilotServiceGetContextualActionsResponse.new instead')
  static CopilotServiceGetContextualActionsResponse create() =>
      CopilotServiceGetContextualActionsResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      CopilotServiceGetContextualActionsResponse._();
  @$core.override
  CopilotServiceGetContextualActionsResponse createEmptyInstance() =>
      CopilotServiceGetContextualActionsResponse._();
  @$core.pragma('dart2js:noInline')
  static CopilotServiceGetContextualActionsResponse getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
              CopilotServiceGetContextualActionsResponse>(
          CopilotServiceGetContextualActionsResponse.$_createMessage);
  static CopilotServiceGetContextualActionsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<ActionCard> get actions => $_getList(0);
}

class CopilotServiceSetContextRequest extends $pb.GeneratedMessage {
  factory CopilotServiceSetContextRequest({
    $core.String? workspaceId,
    $core.String? sessionId,
    $core.String? contextScope,
    CopilotMode? mode,
  }) {
    final result = CopilotServiceSetContextRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (sessionId != null) result.sessionId = sessionId;
    if (contextScope != null) result.contextScope = contextScope;
    if (mode != null) result.mode = mode;
    return result;
  }

  CopilotServiceSetContextRequest._();

  factory CopilotServiceSetContextRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CopilotServiceSetContextRequest()..mergeFromBuffer(data, registry);
  factory CopilotServiceSetContextRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CopilotServiceSetContextRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CopilotServiceSetContextRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.copilot.v1'),
      createEmptyInstance: CopilotServiceSetContextRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'sessionId')
    ..aOS(3, _omitFieldNames ? '' : 'contextScope')
    ..aE<CopilotMode>(4, _omitFieldNames ? '' : 'mode',
        enumValues: CopilotMode.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CopilotServiceSetContextRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CopilotServiceSetContextRequest copyWith(
          void Function(CopilotServiceSetContextRequest) updates) =>
      super.copyWith(
              (message) => updates(message as CopilotServiceSetContextRequest))
          as CopilotServiceSetContextRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use CopilotServiceSetContextRequest() / CopilotServiceSetContextRequest.new instead')
  static CopilotServiceSetContextRequest create() =>
      CopilotServiceSetContextRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      CopilotServiceSetContextRequest._();
  @$core.override
  CopilotServiceSetContextRequest createEmptyInstance() =>
      CopilotServiceSetContextRequest._();
  @$core.pragma('dart2js:noInline')
  static CopilotServiceSetContextRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CopilotServiceSetContextRequest>(
          CopilotServiceSetContextRequest.$_createMessage);
  static CopilotServiceSetContextRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get sessionId => $_getSZ(1);
  @$pb.TagNumber(2)
  set sessionId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSessionId() => $_has(1);
  @$pb.TagNumber(2)
  void clearSessionId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get contextScope => $_getSZ(2);
  @$pb.TagNumber(3)
  set contextScope($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasContextScope() => $_has(2);
  @$pb.TagNumber(3)
  void clearContextScope() => $_clearField(3);

  @$pb.TagNumber(4)
  CopilotMode get mode => $_getN(3);
  @$pb.TagNumber(4)
  set mode(CopilotMode value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasMode() => $_has(3);
  @$pb.TagNumber(4)
  void clearMode() => $_clearField(4);
}

class CopilotServiceSetContextResponse extends $pb.GeneratedMessage {
  factory CopilotServiceSetContextResponse({
    CopilotSession? session,
  }) {
    final result = CopilotServiceSetContextResponse._();
    if (session != null) result.session = session;
    return result;
  }

  CopilotServiceSetContextResponse._();

  factory CopilotServiceSetContextResponse.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CopilotServiceSetContextResponse()..mergeFromBuffer(data, registry);
  factory CopilotServiceSetContextResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CopilotServiceSetContextResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CopilotServiceSetContextResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.copilot.v1'),
      createEmptyInstance: CopilotServiceSetContextResponse.$_createMessage)
    ..aOM<CopilotSession>(1, _omitFieldNames ? '' : 'session',
        subBuilder: CopilotSession.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CopilotServiceSetContextResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CopilotServiceSetContextResponse copyWith(
          void Function(CopilotServiceSetContextResponse) updates) =>
      super.copyWith(
              (message) => updates(message as CopilotServiceSetContextResponse))
          as CopilotServiceSetContextResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use CopilotServiceSetContextResponse() / CopilotServiceSetContextResponse.new instead')
  static CopilotServiceSetContextResponse create() =>
      CopilotServiceSetContextResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      CopilotServiceSetContextResponse._();
  @$core.override
  CopilotServiceSetContextResponse createEmptyInstance() =>
      CopilotServiceSetContextResponse._();
  @$core.pragma('dart2js:noInline')
  static CopilotServiceSetContextResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CopilotServiceSetContextResponse>(
          CopilotServiceSetContextResponse.$_createMessage);
  static CopilotServiceSetContextResponse? _defaultInstance;

  @$pb.TagNumber(1)
  CopilotSession get session => $_getN(0);
  @$pb.TagNumber(1)
  set session(CopilotSession value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasSession() => $_has(0);
  @$pb.TagNumber(1)
  void clearSession() => $_clearField(1);
  @$pb.TagNumber(1)
  CopilotSession ensureSession() => $_ensure(0);
}

class CopilotServiceGetHistoryRequest extends $pb.GeneratedMessage {
  factory CopilotServiceGetHistoryRequest({
    $core.String? workspaceId,
    $core.int? limit,
    $core.String? pageToken,
  }) {
    final result = CopilotServiceGetHistoryRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (limit != null) result.limit = limit;
    if (pageToken != null) result.pageToken = pageToken;
    return result;
  }

  CopilotServiceGetHistoryRequest._();

  factory CopilotServiceGetHistoryRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CopilotServiceGetHistoryRequest()..mergeFromBuffer(data, registry);
  factory CopilotServiceGetHistoryRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CopilotServiceGetHistoryRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CopilotServiceGetHistoryRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.copilot.v1'),
      createEmptyInstance: CopilotServiceGetHistoryRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aI(2, _omitFieldNames ? '' : 'limit')
    ..aOS(3, _omitFieldNames ? '' : 'pageToken')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CopilotServiceGetHistoryRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CopilotServiceGetHistoryRequest copyWith(
          void Function(CopilotServiceGetHistoryRequest) updates) =>
      super.copyWith(
              (message) => updates(message as CopilotServiceGetHistoryRequest))
          as CopilotServiceGetHistoryRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use CopilotServiceGetHistoryRequest() / CopilotServiceGetHistoryRequest.new instead')
  static CopilotServiceGetHistoryRequest create() =>
      CopilotServiceGetHistoryRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      CopilotServiceGetHistoryRequest._();
  @$core.override
  CopilotServiceGetHistoryRequest createEmptyInstance() =>
      CopilotServiceGetHistoryRequest._();
  @$core.pragma('dart2js:noInline')
  static CopilotServiceGetHistoryRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CopilotServiceGetHistoryRequest>(
          CopilotServiceGetHistoryRequest.$_createMessage);
  static CopilotServiceGetHistoryRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get limit => $_getIZ(1);
  @$pb.TagNumber(2)
  set limit($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasLimit() => $_has(1);
  @$pb.TagNumber(2)
  void clearLimit() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get pageToken => $_getSZ(2);
  @$pb.TagNumber(3)
  set pageToken($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPageToken() => $_has(2);
  @$pb.TagNumber(3)
  void clearPageToken() => $_clearField(3);
}

class CopilotServiceGetHistoryResponse extends $pb.GeneratedMessage {
  factory CopilotServiceGetHistoryResponse({
    $core.Iterable<CopilotSession>? sessions,
    $core.String? nextPageToken,
  }) {
    final result = CopilotServiceGetHistoryResponse._();
    if (sessions != null) result.sessions.addAll(sessions);
    if (nextPageToken != null) result.nextPageToken = nextPageToken;
    return result;
  }

  CopilotServiceGetHistoryResponse._();

  factory CopilotServiceGetHistoryResponse.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CopilotServiceGetHistoryResponse()..mergeFromBuffer(data, registry);
  factory CopilotServiceGetHistoryResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CopilotServiceGetHistoryResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CopilotServiceGetHistoryResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.copilot.v1'),
      createEmptyInstance: CopilotServiceGetHistoryResponse.$_createMessage)
    ..pPM<CopilotSession>(1, _omitFieldNames ? '' : 'sessions',
        subBuilder: CopilotSession.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'nextPageToken')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CopilotServiceGetHistoryResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CopilotServiceGetHistoryResponse copyWith(
          void Function(CopilotServiceGetHistoryResponse) updates) =>
      super.copyWith(
              (message) => updates(message as CopilotServiceGetHistoryResponse))
          as CopilotServiceGetHistoryResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use CopilotServiceGetHistoryResponse() / CopilotServiceGetHistoryResponse.new instead')
  static CopilotServiceGetHistoryResponse create() =>
      CopilotServiceGetHistoryResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      CopilotServiceGetHistoryResponse._();
  @$core.override
  CopilotServiceGetHistoryResponse createEmptyInstance() =>
      CopilotServiceGetHistoryResponse._();
  @$core.pragma('dart2js:noInline')
  static CopilotServiceGetHistoryResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CopilotServiceGetHistoryResponse>(
          CopilotServiceGetHistoryResponse.$_createMessage);
  static CopilotServiceGetHistoryResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<CopilotSession> get sessions => $_getList(0);

  @$pb.TagNumber(2)
  $core.String get nextPageToken => $_getSZ(1);
  @$pb.TagNumber(2)
  set nextPageToken($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasNextPageToken() => $_has(1);
  @$pb.TagNumber(2)
  void clearNextPageToken() => $_clearField(2);
}

class CopilotServiceFeedbackRequest extends $pb.GeneratedMessage {
  factory CopilotServiceFeedbackRequest({
    $core.String? workspaceId,
    $core.String? sessionId,
    $core.String? messageId,
    $core.bool? isPositive,
    $core.String? feedbackText,
  }) {
    final result = CopilotServiceFeedbackRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (sessionId != null) result.sessionId = sessionId;
    if (messageId != null) result.messageId = messageId;
    if (isPositive != null) result.isPositive = isPositive;
    if (feedbackText != null) result.feedbackText = feedbackText;
    return result;
  }

  CopilotServiceFeedbackRequest._();

  factory CopilotServiceFeedbackRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CopilotServiceFeedbackRequest()..mergeFromBuffer(data, registry);
  factory CopilotServiceFeedbackRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CopilotServiceFeedbackRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CopilotServiceFeedbackRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.copilot.v1'),
      createEmptyInstance: CopilotServiceFeedbackRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'sessionId')
    ..aOS(3, _omitFieldNames ? '' : 'messageId')
    ..aOB(4, _omitFieldNames ? '' : 'isPositive')
    ..aOS(5, _omitFieldNames ? '' : 'feedbackText')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CopilotServiceFeedbackRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CopilotServiceFeedbackRequest copyWith(
          void Function(CopilotServiceFeedbackRequest) updates) =>
      super.copyWith(
              (message) => updates(message as CopilotServiceFeedbackRequest))
          as CopilotServiceFeedbackRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use CopilotServiceFeedbackRequest() / CopilotServiceFeedbackRequest.new instead')
  static CopilotServiceFeedbackRequest create() =>
      CopilotServiceFeedbackRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      CopilotServiceFeedbackRequest._();
  @$core.override
  CopilotServiceFeedbackRequest createEmptyInstance() =>
      CopilotServiceFeedbackRequest._();
  @$core.pragma('dart2js:noInline')
  static CopilotServiceFeedbackRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CopilotServiceFeedbackRequest>(
          CopilotServiceFeedbackRequest.$_createMessage);
  static CopilotServiceFeedbackRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get sessionId => $_getSZ(1);
  @$pb.TagNumber(2)
  set sessionId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSessionId() => $_has(1);
  @$pb.TagNumber(2)
  void clearSessionId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get messageId => $_getSZ(2);
  @$pb.TagNumber(3)
  set messageId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasMessageId() => $_has(2);
  @$pb.TagNumber(3)
  void clearMessageId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.bool get isPositive => $_getBF(3);
  @$pb.TagNumber(4)
  set isPositive($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(4)
  $core.bool hasIsPositive() => $_has(3);
  @$pb.TagNumber(4)
  void clearIsPositive() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get feedbackText => $_getSZ(4);
  @$pb.TagNumber(5)
  set feedbackText($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasFeedbackText() => $_has(4);
  @$pb.TagNumber(5)
  void clearFeedbackText() => $_clearField(5);
}

class CopilotServiceFeedbackResponse extends $pb.GeneratedMessage {
  factory CopilotServiceFeedbackResponse({
    $core.bool? recorded,
  }) {
    final result = CopilotServiceFeedbackResponse._();
    if (recorded != null) result.recorded = recorded;
    return result;
  }

  CopilotServiceFeedbackResponse._();

  factory CopilotServiceFeedbackResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CopilotServiceFeedbackResponse()..mergeFromBuffer(data, registry);
  factory CopilotServiceFeedbackResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CopilotServiceFeedbackResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CopilotServiceFeedbackResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.copilot.v1'),
      createEmptyInstance: CopilotServiceFeedbackResponse.$_createMessage)
    ..aOB(1, _omitFieldNames ? '' : 'recorded')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CopilotServiceFeedbackResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CopilotServiceFeedbackResponse copyWith(
          void Function(CopilotServiceFeedbackResponse) updates) =>
      super.copyWith(
              (message) => updates(message as CopilotServiceFeedbackResponse))
          as CopilotServiceFeedbackResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use CopilotServiceFeedbackResponse() / CopilotServiceFeedbackResponse.new instead')
  static CopilotServiceFeedbackResponse create() =>
      CopilotServiceFeedbackResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      CopilotServiceFeedbackResponse._();
  @$core.override
  CopilotServiceFeedbackResponse createEmptyInstance() =>
      CopilotServiceFeedbackResponse._();
  @$core.pragma('dart2js:noInline')
  static CopilotServiceFeedbackResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CopilotServiceFeedbackResponse>(
          CopilotServiceFeedbackResponse.$_createMessage);
  static CopilotServiceFeedbackResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get recorded => $_getBF(0);
  @$pb.TagNumber(1)
  set recorded($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRecorded() => $_has(0);
  @$pb.TagNumber(1)
  void clearRecorded() => $_clearField(1);
}

class CopilotServiceGenerateIdeasRequest extends $pb.GeneratedMessage {
  factory CopilotServiceGenerateIdeasRequest({
    $core.String? workspaceId,
    $core.String? topic,
    $core.int? count,
    $core.String? confirmedQuoteId,
  }) {
    final result = CopilotServiceGenerateIdeasRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (topic != null) result.topic = topic;
    if (count != null) result.count = count;
    if (confirmedQuoteId != null) result.confirmedQuoteId = confirmedQuoteId;
    return result;
  }

  CopilotServiceGenerateIdeasRequest._();

  factory CopilotServiceGenerateIdeasRequest.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CopilotServiceGenerateIdeasRequest()..mergeFromBuffer(data, registry);
  factory CopilotServiceGenerateIdeasRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CopilotServiceGenerateIdeasRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CopilotServiceGenerateIdeasRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.copilot.v1'),
      createEmptyInstance: CopilotServiceGenerateIdeasRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'topic')
    ..aI(3, _omitFieldNames ? '' : 'count')
    ..aOS(4, _omitFieldNames ? '' : 'confirmedQuoteId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CopilotServiceGenerateIdeasRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CopilotServiceGenerateIdeasRequest copyWith(
          void Function(CopilotServiceGenerateIdeasRequest) updates) =>
      super.copyWith((message) =>
              updates(message as CopilotServiceGenerateIdeasRequest))
          as CopilotServiceGenerateIdeasRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use CopilotServiceGenerateIdeasRequest() / CopilotServiceGenerateIdeasRequest.new instead')
  static CopilotServiceGenerateIdeasRequest create() =>
      CopilotServiceGenerateIdeasRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      CopilotServiceGenerateIdeasRequest._();
  @$core.override
  CopilotServiceGenerateIdeasRequest createEmptyInstance() =>
      CopilotServiceGenerateIdeasRequest._();
  @$core.pragma('dart2js:noInline')
  static CopilotServiceGenerateIdeasRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CopilotServiceGenerateIdeasRequest>(
          CopilotServiceGenerateIdeasRequest.$_createMessage);
  static CopilotServiceGenerateIdeasRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get topic => $_getSZ(1);
  @$pb.TagNumber(2)
  set topic($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTopic() => $_has(1);
  @$pb.TagNumber(2)
  void clearTopic() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get count => $_getIZ(2);
  @$pb.TagNumber(3)
  set count($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasCount() => $_has(2);
  @$pb.TagNumber(3)
  void clearCount() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get confirmedQuoteId => $_getSZ(3);
  @$pb.TagNumber(4)
  set confirmedQuoteId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasConfirmedQuoteId() => $_has(3);
  @$pb.TagNumber(4)
  void clearConfirmedQuoteId() => $_clearField(4);
}

class CopilotServiceGenerateIdeasResponse extends $pb.GeneratedMessage {
  factory CopilotServiceGenerateIdeasResponse({
    $core.Iterable<$core.String>? ideas,
    ActionQuote? quote,
    $core.bool? requiresConfirmation,
  }) {
    final result = CopilotServiceGenerateIdeasResponse._();
    if (ideas != null) result.ideas.addAll(ideas);
    if (quote != null) result.quote = quote;
    if (requiresConfirmation != null)
      result.requiresConfirmation = requiresConfirmation;
    return result;
  }

  CopilotServiceGenerateIdeasResponse._();

  factory CopilotServiceGenerateIdeasResponse.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CopilotServiceGenerateIdeasResponse()..mergeFromBuffer(data, registry);
  factory CopilotServiceGenerateIdeasResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CopilotServiceGenerateIdeasResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CopilotServiceGenerateIdeasResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.copilot.v1'),
      createEmptyInstance: CopilotServiceGenerateIdeasResponse.$_createMessage)
    ..pPS(1, _omitFieldNames ? '' : 'ideas')
    ..aOM<ActionQuote>(2, _omitFieldNames ? '' : 'quote',
        subBuilder: ActionQuote.$_createMessage)
    ..aOB(3, _omitFieldNames ? '' : 'requiresConfirmation')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CopilotServiceGenerateIdeasResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CopilotServiceGenerateIdeasResponse copyWith(
          void Function(CopilotServiceGenerateIdeasResponse) updates) =>
      super.copyWith((message) =>
              updates(message as CopilotServiceGenerateIdeasResponse))
          as CopilotServiceGenerateIdeasResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use CopilotServiceGenerateIdeasResponse() / CopilotServiceGenerateIdeasResponse.new instead')
  static CopilotServiceGenerateIdeasResponse create() =>
      CopilotServiceGenerateIdeasResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      CopilotServiceGenerateIdeasResponse._();
  @$core.override
  CopilotServiceGenerateIdeasResponse createEmptyInstance() =>
      CopilotServiceGenerateIdeasResponse._();
  @$core.pragma('dart2js:noInline')
  static CopilotServiceGenerateIdeasResponse getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
              CopilotServiceGenerateIdeasResponse>(
          CopilotServiceGenerateIdeasResponse.$_createMessage);
  static CopilotServiceGenerateIdeasResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<$core.String> get ideas => $_getList(0);

  @$pb.TagNumber(2)
  ActionQuote get quote => $_getN(1);
  @$pb.TagNumber(2)
  set quote(ActionQuote value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasQuote() => $_has(1);
  @$pb.TagNumber(2)
  void clearQuote() => $_clearField(2);
  @$pb.TagNumber(2)
  ActionQuote ensureQuote() => $_ensure(1);

  @$pb.TagNumber(3)
  $core.bool get requiresConfirmation => $_getBF(2);
  @$pb.TagNumber(3)
  set requiresConfirmation($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasRequiresConfirmation() => $_has(2);
  @$pb.TagNumber(3)
  void clearRequiresConfirmation() => $_clearField(3);
}

class CopilotServiceGenerateCaptionRequest extends $pb.GeneratedMessage {
  factory CopilotServiceGenerateCaptionRequest({
    $core.String? workspaceId,
    $core.String? contentSummary,
    $core.String? platform,
  }) {
    final result = CopilotServiceGenerateCaptionRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (contentSummary != null) result.contentSummary = contentSummary;
    if (platform != null) result.platform = platform;
    return result;
  }

  CopilotServiceGenerateCaptionRequest._();

  factory CopilotServiceGenerateCaptionRequest.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CopilotServiceGenerateCaptionRequest()..mergeFromBuffer(data, registry);
  factory CopilotServiceGenerateCaptionRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CopilotServiceGenerateCaptionRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CopilotServiceGenerateCaptionRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.copilot.v1'),
      createEmptyInstance: CopilotServiceGenerateCaptionRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'contentSummary')
    ..aOS(3, _omitFieldNames ? '' : 'platform')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CopilotServiceGenerateCaptionRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CopilotServiceGenerateCaptionRequest copyWith(
          void Function(CopilotServiceGenerateCaptionRequest) updates) =>
      super.copyWith((message) =>
              updates(message as CopilotServiceGenerateCaptionRequest))
          as CopilotServiceGenerateCaptionRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use CopilotServiceGenerateCaptionRequest() / CopilotServiceGenerateCaptionRequest.new instead')
  static CopilotServiceGenerateCaptionRequest create() =>
      CopilotServiceGenerateCaptionRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      CopilotServiceGenerateCaptionRequest._();
  @$core.override
  CopilotServiceGenerateCaptionRequest createEmptyInstance() =>
      CopilotServiceGenerateCaptionRequest._();
  @$core.pragma('dart2js:noInline')
  static CopilotServiceGenerateCaptionRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
              CopilotServiceGenerateCaptionRequest>(
          CopilotServiceGenerateCaptionRequest.$_createMessage);
  static CopilotServiceGenerateCaptionRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get contentSummary => $_getSZ(1);
  @$pb.TagNumber(2)
  set contentSummary($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasContentSummary() => $_has(1);
  @$pb.TagNumber(2)
  void clearContentSummary() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get platform => $_getSZ(2);
  @$pb.TagNumber(3)
  set platform($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPlatform() => $_has(2);
  @$pb.TagNumber(3)
  void clearPlatform() => $_clearField(3);
}

class CopilotServiceGenerateCaptionResponse extends $pb.GeneratedMessage {
  factory CopilotServiceGenerateCaptionResponse({
    $core.String? caption,
    $core.Iterable<$core.String>? hashtags,
  }) {
    final result = CopilotServiceGenerateCaptionResponse._();
    if (caption != null) result.caption = caption;
    if (hashtags != null) result.hashtags.addAll(hashtags);
    return result;
  }

  CopilotServiceGenerateCaptionResponse._();

  factory CopilotServiceGenerateCaptionResponse.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CopilotServiceGenerateCaptionResponse()..mergeFromBuffer(data, registry);
  factory CopilotServiceGenerateCaptionResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CopilotServiceGenerateCaptionResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CopilotServiceGenerateCaptionResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.copilot.v1'),
      createEmptyInstance:
          CopilotServiceGenerateCaptionResponse.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'caption')
    ..pPS(2, _omitFieldNames ? '' : 'hashtags')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CopilotServiceGenerateCaptionResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CopilotServiceGenerateCaptionResponse copyWith(
          void Function(CopilotServiceGenerateCaptionResponse) updates) =>
      super.copyWith((message) =>
              updates(message as CopilotServiceGenerateCaptionResponse))
          as CopilotServiceGenerateCaptionResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use CopilotServiceGenerateCaptionResponse() / CopilotServiceGenerateCaptionResponse.new instead')
  static CopilotServiceGenerateCaptionResponse create() =>
      CopilotServiceGenerateCaptionResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      CopilotServiceGenerateCaptionResponse._();
  @$core.override
  CopilotServiceGenerateCaptionResponse createEmptyInstance() =>
      CopilotServiceGenerateCaptionResponse._();
  @$core.pragma('dart2js:noInline')
  static CopilotServiceGenerateCaptionResponse getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
              CopilotServiceGenerateCaptionResponse>(
          CopilotServiceGenerateCaptionResponse.$_createMessage);
  static CopilotServiceGenerateCaptionResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get caption => $_getSZ(0);
  @$pb.TagNumber(1)
  set caption($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCaption() => $_has(0);
  @$pb.TagNumber(1)
  void clearCaption() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbList<$core.String> get hashtags => $_getList(1);
}

class CopilotServiceGenerateReplyRequest extends $pb.GeneratedMessage {
  factory CopilotServiceGenerateReplyRequest({
    $core.String? workspaceId,
    $core.String? incomingMessage,
    $core.String? platform,
  }) {
    final result = CopilotServiceGenerateReplyRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (incomingMessage != null) result.incomingMessage = incomingMessage;
    if (platform != null) result.platform = platform;
    return result;
  }

  CopilotServiceGenerateReplyRequest._();

  factory CopilotServiceGenerateReplyRequest.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CopilotServiceGenerateReplyRequest()..mergeFromBuffer(data, registry);
  factory CopilotServiceGenerateReplyRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CopilotServiceGenerateReplyRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CopilotServiceGenerateReplyRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.copilot.v1'),
      createEmptyInstance: CopilotServiceGenerateReplyRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'incomingMessage')
    ..aOS(3, _omitFieldNames ? '' : 'platform')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CopilotServiceGenerateReplyRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CopilotServiceGenerateReplyRequest copyWith(
          void Function(CopilotServiceGenerateReplyRequest) updates) =>
      super.copyWith((message) =>
              updates(message as CopilotServiceGenerateReplyRequest))
          as CopilotServiceGenerateReplyRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use CopilotServiceGenerateReplyRequest() / CopilotServiceGenerateReplyRequest.new instead')
  static CopilotServiceGenerateReplyRequest create() =>
      CopilotServiceGenerateReplyRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      CopilotServiceGenerateReplyRequest._();
  @$core.override
  CopilotServiceGenerateReplyRequest createEmptyInstance() =>
      CopilotServiceGenerateReplyRequest._();
  @$core.pragma('dart2js:noInline')
  static CopilotServiceGenerateReplyRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CopilotServiceGenerateReplyRequest>(
          CopilotServiceGenerateReplyRequest.$_createMessage);
  static CopilotServiceGenerateReplyRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get incomingMessage => $_getSZ(1);
  @$pb.TagNumber(2)
  set incomingMessage($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasIncomingMessage() => $_has(1);
  @$pb.TagNumber(2)
  void clearIncomingMessage() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get platform => $_getSZ(2);
  @$pb.TagNumber(3)
  set platform($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPlatform() => $_has(2);
  @$pb.TagNumber(3)
  void clearPlatform() => $_clearField(3);
}

class CopilotServiceGenerateReplyResponse extends $pb.GeneratedMessage {
  factory CopilotServiceGenerateReplyResponse({
    $core.String? suggestedReply,
  }) {
    final result = CopilotServiceGenerateReplyResponse._();
    if (suggestedReply != null) result.suggestedReply = suggestedReply;
    return result;
  }

  CopilotServiceGenerateReplyResponse._();

  factory CopilotServiceGenerateReplyResponse.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CopilotServiceGenerateReplyResponse()..mergeFromBuffer(data, registry);
  factory CopilotServiceGenerateReplyResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CopilotServiceGenerateReplyResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CopilotServiceGenerateReplyResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.copilot.v1'),
      createEmptyInstance: CopilotServiceGenerateReplyResponse.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'suggestedReply')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CopilotServiceGenerateReplyResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CopilotServiceGenerateReplyResponse copyWith(
          void Function(CopilotServiceGenerateReplyResponse) updates) =>
      super.copyWith((message) =>
              updates(message as CopilotServiceGenerateReplyResponse))
          as CopilotServiceGenerateReplyResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use CopilotServiceGenerateReplyResponse() / CopilotServiceGenerateReplyResponse.new instead')
  static CopilotServiceGenerateReplyResponse create() =>
      CopilotServiceGenerateReplyResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      CopilotServiceGenerateReplyResponse._();
  @$core.override
  CopilotServiceGenerateReplyResponse createEmptyInstance() =>
      CopilotServiceGenerateReplyResponse._();
  @$core.pragma('dart2js:noInline')
  static CopilotServiceGenerateReplyResponse getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
              CopilotServiceGenerateReplyResponse>(
          CopilotServiceGenerateReplyResponse.$_createMessage);
  static CopilotServiceGenerateReplyResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get suggestedReply => $_getSZ(0);
  @$pb.TagNumber(1)
  set suggestedReply($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSuggestedReply() => $_has(0);
  @$pb.TagNumber(1)
  void clearSuggestedReply() => $_clearField(1);
}

class CopilotServiceGenerateAvatarRequest extends $pb.GeneratedMessage {
  factory CopilotServiceGenerateAvatarRequest({
    $core.String? workspaceId,
    $core.String? prompt,
    $core.String? style,
  }) {
    final result = CopilotServiceGenerateAvatarRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (prompt != null) result.prompt = prompt;
    if (style != null) result.style = style;
    return result;
  }

  CopilotServiceGenerateAvatarRequest._();

  factory CopilotServiceGenerateAvatarRequest.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CopilotServiceGenerateAvatarRequest()..mergeFromBuffer(data, registry);
  factory CopilotServiceGenerateAvatarRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CopilotServiceGenerateAvatarRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CopilotServiceGenerateAvatarRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.copilot.v1'),
      createEmptyInstance: CopilotServiceGenerateAvatarRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'prompt')
    ..aOS(3, _omitFieldNames ? '' : 'style')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CopilotServiceGenerateAvatarRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CopilotServiceGenerateAvatarRequest copyWith(
          void Function(CopilotServiceGenerateAvatarRequest) updates) =>
      super.copyWith((message) =>
              updates(message as CopilotServiceGenerateAvatarRequest))
          as CopilotServiceGenerateAvatarRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use CopilotServiceGenerateAvatarRequest() / CopilotServiceGenerateAvatarRequest.new instead')
  static CopilotServiceGenerateAvatarRequest create() =>
      CopilotServiceGenerateAvatarRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      CopilotServiceGenerateAvatarRequest._();
  @$core.override
  CopilotServiceGenerateAvatarRequest createEmptyInstance() =>
      CopilotServiceGenerateAvatarRequest._();
  @$core.pragma('dart2js:noInline')
  static CopilotServiceGenerateAvatarRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
              CopilotServiceGenerateAvatarRequest>(
          CopilotServiceGenerateAvatarRequest.$_createMessage);
  static CopilotServiceGenerateAvatarRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get prompt => $_getSZ(1);
  @$pb.TagNumber(2)
  set prompt($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPrompt() => $_has(1);
  @$pb.TagNumber(2)
  void clearPrompt() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get style => $_getSZ(2);
  @$pb.TagNumber(3)
  set style($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasStyle() => $_has(2);
  @$pb.TagNumber(3)
  void clearStyle() => $_clearField(3);
}

class CopilotServiceGenerateAvatarResponse extends $pb.GeneratedMessage {
  factory CopilotServiceGenerateAvatarResponse({
    $core.String? avatarUrl,
  }) {
    final result = CopilotServiceGenerateAvatarResponse._();
    if (avatarUrl != null) result.avatarUrl = avatarUrl;
    return result;
  }

  CopilotServiceGenerateAvatarResponse._();

  factory CopilotServiceGenerateAvatarResponse.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CopilotServiceGenerateAvatarResponse()..mergeFromBuffer(data, registry);
  factory CopilotServiceGenerateAvatarResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CopilotServiceGenerateAvatarResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CopilotServiceGenerateAvatarResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.copilot.v1'),
      createEmptyInstance: CopilotServiceGenerateAvatarResponse.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'avatarUrl')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CopilotServiceGenerateAvatarResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CopilotServiceGenerateAvatarResponse copyWith(
          void Function(CopilotServiceGenerateAvatarResponse) updates) =>
      super.copyWith((message) =>
              updates(message as CopilotServiceGenerateAvatarResponse))
          as CopilotServiceGenerateAvatarResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use CopilotServiceGenerateAvatarResponse() / CopilotServiceGenerateAvatarResponse.new instead')
  static CopilotServiceGenerateAvatarResponse create() =>
      CopilotServiceGenerateAvatarResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      CopilotServiceGenerateAvatarResponse._();
  @$core.override
  CopilotServiceGenerateAvatarResponse createEmptyInstance() =>
      CopilotServiceGenerateAvatarResponse._();
  @$core.pragma('dart2js:noInline')
  static CopilotServiceGenerateAvatarResponse getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
              CopilotServiceGenerateAvatarResponse>(
          CopilotServiceGenerateAvatarResponse.$_createMessage);
  static CopilotServiceGenerateAvatarResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get avatarUrl => $_getSZ(0);
  @$pb.TagNumber(1)
  set avatarUrl($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAvatarUrl() => $_has(0);
  @$pb.TagNumber(1)
  void clearAvatarUrl() => $_clearField(1);
}

class CopilotServiceShortenCaptionRequest extends $pb.GeneratedMessage {
  factory CopilotServiceShortenCaptionRequest({
    $core.String? workspaceId,
    $core.String? text,
    $core.int? maxLength,
  }) {
    final result = CopilotServiceShortenCaptionRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (text != null) result.text = text;
    if (maxLength != null) result.maxLength = maxLength;
    return result;
  }

  CopilotServiceShortenCaptionRequest._();

  factory CopilotServiceShortenCaptionRequest.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CopilotServiceShortenCaptionRequest()..mergeFromBuffer(data, registry);
  factory CopilotServiceShortenCaptionRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CopilotServiceShortenCaptionRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CopilotServiceShortenCaptionRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.copilot.v1'),
      createEmptyInstance: CopilotServiceShortenCaptionRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'text')
    ..aI(3, _omitFieldNames ? '' : 'maxLength')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CopilotServiceShortenCaptionRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CopilotServiceShortenCaptionRequest copyWith(
          void Function(CopilotServiceShortenCaptionRequest) updates) =>
      super.copyWith((message) =>
              updates(message as CopilotServiceShortenCaptionRequest))
          as CopilotServiceShortenCaptionRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use CopilotServiceShortenCaptionRequest() / CopilotServiceShortenCaptionRequest.new instead')
  static CopilotServiceShortenCaptionRequest create() =>
      CopilotServiceShortenCaptionRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      CopilotServiceShortenCaptionRequest._();
  @$core.override
  CopilotServiceShortenCaptionRequest createEmptyInstance() =>
      CopilotServiceShortenCaptionRequest._();
  @$core.pragma('dart2js:noInline')
  static CopilotServiceShortenCaptionRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
              CopilotServiceShortenCaptionRequest>(
          CopilotServiceShortenCaptionRequest.$_createMessage);
  static CopilotServiceShortenCaptionRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get text => $_getSZ(1);
  @$pb.TagNumber(2)
  set text($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasText() => $_has(1);
  @$pb.TagNumber(2)
  void clearText() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get maxLength => $_getIZ(2);
  @$pb.TagNumber(3)
  set maxLength($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasMaxLength() => $_has(2);
  @$pb.TagNumber(3)
  void clearMaxLength() => $_clearField(3);
}

class CopilotServiceShortenCaptionResponse extends $pb.GeneratedMessage {
  factory CopilotServiceShortenCaptionResponse({
    $core.String? shortenedText,
  }) {
    final result = CopilotServiceShortenCaptionResponse._();
    if (shortenedText != null) result.shortenedText = shortenedText;
    return result;
  }

  CopilotServiceShortenCaptionResponse._();

  factory CopilotServiceShortenCaptionResponse.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CopilotServiceShortenCaptionResponse()..mergeFromBuffer(data, registry);
  factory CopilotServiceShortenCaptionResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CopilotServiceShortenCaptionResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CopilotServiceShortenCaptionResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.copilot.v1'),
      createEmptyInstance: CopilotServiceShortenCaptionResponse.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'shortenedText')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CopilotServiceShortenCaptionResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CopilotServiceShortenCaptionResponse copyWith(
          void Function(CopilotServiceShortenCaptionResponse) updates) =>
      super.copyWith((message) =>
              updates(message as CopilotServiceShortenCaptionResponse))
          as CopilotServiceShortenCaptionResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use CopilotServiceShortenCaptionResponse() / CopilotServiceShortenCaptionResponse.new instead')
  static CopilotServiceShortenCaptionResponse create() =>
      CopilotServiceShortenCaptionResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      CopilotServiceShortenCaptionResponse._();
  @$core.override
  CopilotServiceShortenCaptionResponse createEmptyInstance() =>
      CopilotServiceShortenCaptionResponse._();
  @$core.pragma('dart2js:noInline')
  static CopilotServiceShortenCaptionResponse getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
              CopilotServiceShortenCaptionResponse>(
          CopilotServiceShortenCaptionResponse.$_createMessage);
  static CopilotServiceShortenCaptionResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get shortenedText => $_getSZ(0);
  @$pb.TagNumber(1)
  set shortenedText($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasShortenedText() => $_has(0);
  @$pb.TagNumber(1)
  void clearShortenedText() => $_clearField(1);
}

class CopilotServiceSuggestHashtagsRequest extends $pb.GeneratedMessage {
  factory CopilotServiceSuggestHashtagsRequest({
    $core.String? workspaceId,
    $core.String? topic,
    $core.int? count,
  }) {
    final result = CopilotServiceSuggestHashtagsRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (topic != null) result.topic = topic;
    if (count != null) result.count = count;
    return result;
  }

  CopilotServiceSuggestHashtagsRequest._();

  factory CopilotServiceSuggestHashtagsRequest.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CopilotServiceSuggestHashtagsRequest()..mergeFromBuffer(data, registry);
  factory CopilotServiceSuggestHashtagsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CopilotServiceSuggestHashtagsRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CopilotServiceSuggestHashtagsRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.copilot.v1'),
      createEmptyInstance: CopilotServiceSuggestHashtagsRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'topic')
    ..aI(3, _omitFieldNames ? '' : 'count')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CopilotServiceSuggestHashtagsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CopilotServiceSuggestHashtagsRequest copyWith(
          void Function(CopilotServiceSuggestHashtagsRequest) updates) =>
      super.copyWith((message) =>
              updates(message as CopilotServiceSuggestHashtagsRequest))
          as CopilotServiceSuggestHashtagsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use CopilotServiceSuggestHashtagsRequest() / CopilotServiceSuggestHashtagsRequest.new instead')
  static CopilotServiceSuggestHashtagsRequest create() =>
      CopilotServiceSuggestHashtagsRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      CopilotServiceSuggestHashtagsRequest._();
  @$core.override
  CopilotServiceSuggestHashtagsRequest createEmptyInstance() =>
      CopilotServiceSuggestHashtagsRequest._();
  @$core.pragma('dart2js:noInline')
  static CopilotServiceSuggestHashtagsRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
              CopilotServiceSuggestHashtagsRequest>(
          CopilotServiceSuggestHashtagsRequest.$_createMessage);
  static CopilotServiceSuggestHashtagsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get topic => $_getSZ(1);
  @$pb.TagNumber(2)
  set topic($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTopic() => $_has(1);
  @$pb.TagNumber(2)
  void clearTopic() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get count => $_getIZ(2);
  @$pb.TagNumber(3)
  set count($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasCount() => $_has(2);
  @$pb.TagNumber(3)
  void clearCount() => $_clearField(3);
}

class CopilotServiceSuggestHashtagsResponse extends $pb.GeneratedMessage {
  factory CopilotServiceSuggestHashtagsResponse({
    $core.Iterable<$core.String>? hashtags,
  }) {
    final result = CopilotServiceSuggestHashtagsResponse._();
    if (hashtags != null) result.hashtags.addAll(hashtags);
    return result;
  }

  CopilotServiceSuggestHashtagsResponse._();

  factory CopilotServiceSuggestHashtagsResponse.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CopilotServiceSuggestHashtagsResponse()..mergeFromBuffer(data, registry);
  factory CopilotServiceSuggestHashtagsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CopilotServiceSuggestHashtagsResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CopilotServiceSuggestHashtagsResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.copilot.v1'),
      createEmptyInstance:
          CopilotServiceSuggestHashtagsResponse.$_createMessage)
    ..pPS(1, _omitFieldNames ? '' : 'hashtags')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CopilotServiceSuggestHashtagsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CopilotServiceSuggestHashtagsResponse copyWith(
          void Function(CopilotServiceSuggestHashtagsResponse) updates) =>
      super.copyWith((message) =>
              updates(message as CopilotServiceSuggestHashtagsResponse))
          as CopilotServiceSuggestHashtagsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use CopilotServiceSuggestHashtagsResponse() / CopilotServiceSuggestHashtagsResponse.new instead')
  static CopilotServiceSuggestHashtagsResponse create() =>
      CopilotServiceSuggestHashtagsResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      CopilotServiceSuggestHashtagsResponse._();
  @$core.override
  CopilotServiceSuggestHashtagsResponse createEmptyInstance() =>
      CopilotServiceSuggestHashtagsResponse._();
  @$core.pragma('dart2js:noInline')
  static CopilotServiceSuggestHashtagsResponse getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
              CopilotServiceSuggestHashtagsResponse>(
          CopilotServiceSuggestHashtagsResponse.$_createMessage);
  static CopilotServiceSuggestHashtagsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<$core.String> get hashtags => $_getList(0);
}

class CopilotServiceDismissReplyRequest extends $pb.GeneratedMessage {
  factory CopilotServiceDismissReplyRequest({
    $core.String? workspaceId,
    $core.String? replyId,
  }) {
    final result = CopilotServiceDismissReplyRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (replyId != null) result.replyId = replyId;
    return result;
  }

  CopilotServiceDismissReplyRequest._();

  factory CopilotServiceDismissReplyRequest.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CopilotServiceDismissReplyRequest()..mergeFromBuffer(data, registry);
  factory CopilotServiceDismissReplyRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CopilotServiceDismissReplyRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CopilotServiceDismissReplyRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.copilot.v1'),
      createEmptyInstance: CopilotServiceDismissReplyRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'replyId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CopilotServiceDismissReplyRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CopilotServiceDismissReplyRequest copyWith(
          void Function(CopilotServiceDismissReplyRequest) updates) =>
      super.copyWith((message) =>
              updates(message as CopilotServiceDismissReplyRequest))
          as CopilotServiceDismissReplyRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use CopilotServiceDismissReplyRequest() / CopilotServiceDismissReplyRequest.new instead')
  static CopilotServiceDismissReplyRequest create() =>
      CopilotServiceDismissReplyRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      CopilotServiceDismissReplyRequest._();
  @$core.override
  CopilotServiceDismissReplyRequest createEmptyInstance() =>
      CopilotServiceDismissReplyRequest._();
  @$core.pragma('dart2js:noInline')
  static CopilotServiceDismissReplyRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CopilotServiceDismissReplyRequest>(
          CopilotServiceDismissReplyRequest.$_createMessage);
  static CopilotServiceDismissReplyRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get replyId => $_getSZ(1);
  @$pb.TagNumber(2)
  set replyId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasReplyId() => $_has(1);
  @$pb.TagNumber(2)
  void clearReplyId() => $_clearField(2);
}

class CopilotServiceDismissReplyResponse extends $pb.GeneratedMessage {
  factory CopilotServiceDismissReplyResponse({
    $core.bool? dismissed,
  }) {
    final result = CopilotServiceDismissReplyResponse._();
    if (dismissed != null) result.dismissed = dismissed;
    return result;
  }

  CopilotServiceDismissReplyResponse._();

  factory CopilotServiceDismissReplyResponse.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CopilotServiceDismissReplyResponse()..mergeFromBuffer(data, registry);
  factory CopilotServiceDismissReplyResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CopilotServiceDismissReplyResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CopilotServiceDismissReplyResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.copilot.v1'),
      createEmptyInstance: CopilotServiceDismissReplyResponse.$_createMessage)
    ..aOB(1, _omitFieldNames ? '' : 'dismissed')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CopilotServiceDismissReplyResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CopilotServiceDismissReplyResponse copyWith(
          void Function(CopilotServiceDismissReplyResponse) updates) =>
      super.copyWith((message) =>
              updates(message as CopilotServiceDismissReplyResponse))
          as CopilotServiceDismissReplyResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use CopilotServiceDismissReplyResponse() / CopilotServiceDismissReplyResponse.new instead')
  static CopilotServiceDismissReplyResponse create() =>
      CopilotServiceDismissReplyResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      CopilotServiceDismissReplyResponse._();
  @$core.override
  CopilotServiceDismissReplyResponse createEmptyInstance() =>
      CopilotServiceDismissReplyResponse._();
  @$core.pragma('dart2js:noInline')
  static CopilotServiceDismissReplyResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CopilotServiceDismissReplyResponse>(
          CopilotServiceDismissReplyResponse.$_createMessage);
  static CopilotServiceDismissReplyResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get dismissed => $_getBF(0);
  @$pb.TagNumber(1)
  set dismissed($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasDismissed() => $_has(0);
  @$pb.TagNumber(1)
  void clearDismissed() => $_clearField(1);
}

class CopilotServiceRegenerateSectionRequest extends $pb.GeneratedMessage {
  factory CopilotServiceRegenerateSectionRequest({
    $core.String? workspaceId,
    $core.String? sectionText,
    $core.String? instruction,
  }) {
    final result = CopilotServiceRegenerateSectionRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (sectionText != null) result.sectionText = sectionText;
    if (instruction != null) result.instruction = instruction;
    return result;
  }

  CopilotServiceRegenerateSectionRequest._();

  factory CopilotServiceRegenerateSectionRequest.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CopilotServiceRegenerateSectionRequest()..mergeFromBuffer(data, registry);
  factory CopilotServiceRegenerateSectionRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CopilotServiceRegenerateSectionRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CopilotServiceRegenerateSectionRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.copilot.v1'),
      createEmptyInstance:
          CopilotServiceRegenerateSectionRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'sectionText')
    ..aOS(3, _omitFieldNames ? '' : 'instruction')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CopilotServiceRegenerateSectionRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CopilotServiceRegenerateSectionRequest copyWith(
          void Function(CopilotServiceRegenerateSectionRequest) updates) =>
      super.copyWith((message) =>
              updates(message as CopilotServiceRegenerateSectionRequest))
          as CopilotServiceRegenerateSectionRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use CopilotServiceRegenerateSectionRequest() / CopilotServiceRegenerateSectionRequest.new instead')
  static CopilotServiceRegenerateSectionRequest create() =>
      CopilotServiceRegenerateSectionRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      CopilotServiceRegenerateSectionRequest._();
  @$core.override
  CopilotServiceRegenerateSectionRequest createEmptyInstance() =>
      CopilotServiceRegenerateSectionRequest._();
  @$core.pragma('dart2js:noInline')
  static CopilotServiceRegenerateSectionRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
              CopilotServiceRegenerateSectionRequest>(
          CopilotServiceRegenerateSectionRequest.$_createMessage);
  static CopilotServiceRegenerateSectionRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get sectionText => $_getSZ(1);
  @$pb.TagNumber(2)
  set sectionText($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSectionText() => $_has(1);
  @$pb.TagNumber(2)
  void clearSectionText() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get instruction => $_getSZ(2);
  @$pb.TagNumber(3)
  set instruction($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasInstruction() => $_has(2);
  @$pb.TagNumber(3)
  void clearInstruction() => $_clearField(3);
}

class CopilotServiceRegenerateSectionResponse extends $pb.GeneratedMessage {
  factory CopilotServiceRegenerateSectionResponse({
    $core.String? regeneratedText,
  }) {
    final result = CopilotServiceRegenerateSectionResponse._();
    if (regeneratedText != null) result.regeneratedText = regeneratedText;
    return result;
  }

  CopilotServiceRegenerateSectionResponse._();

  factory CopilotServiceRegenerateSectionResponse.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CopilotServiceRegenerateSectionResponse()
        ..mergeFromBuffer(data, registry);
  factory CopilotServiceRegenerateSectionResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CopilotServiceRegenerateSectionResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CopilotServiceRegenerateSectionResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.copilot.v1'),
      createEmptyInstance:
          CopilotServiceRegenerateSectionResponse.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'regeneratedText')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CopilotServiceRegenerateSectionResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CopilotServiceRegenerateSectionResponse copyWith(
          void Function(CopilotServiceRegenerateSectionResponse) updates) =>
      super.copyWith((message) =>
              updates(message as CopilotServiceRegenerateSectionResponse))
          as CopilotServiceRegenerateSectionResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use CopilotServiceRegenerateSectionResponse() / CopilotServiceRegenerateSectionResponse.new instead')
  static CopilotServiceRegenerateSectionResponse create() =>
      CopilotServiceRegenerateSectionResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      CopilotServiceRegenerateSectionResponse._();
  @$core.override
  CopilotServiceRegenerateSectionResponse createEmptyInstance() =>
      CopilotServiceRegenerateSectionResponse._();
  @$core.pragma('dart2js:noInline')
  static CopilotServiceRegenerateSectionResponse getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
              CopilotServiceRegenerateSectionResponse>(
          CopilotServiceRegenerateSectionResponse.$_createMessage);
  static CopilotServiceRegenerateSectionResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get regeneratedText => $_getSZ(0);
  @$pb.TagNumber(1)
  set regeneratedText($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRegeneratedText() => $_has(0);
  @$pb.TagNumber(1)
  void clearRegeneratedText() => $_clearField(1);
}

class CopilotServiceScoreIdeaRequest extends $pb.GeneratedMessage {
  factory CopilotServiceScoreIdeaRequest({
    $core.String? workspaceId,
    $core.String? ideaText,
  }) {
    final result = CopilotServiceScoreIdeaRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (ideaText != null) result.ideaText = ideaText;
    return result;
  }

  CopilotServiceScoreIdeaRequest._();

  factory CopilotServiceScoreIdeaRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CopilotServiceScoreIdeaRequest()..mergeFromBuffer(data, registry);
  factory CopilotServiceScoreIdeaRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CopilotServiceScoreIdeaRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CopilotServiceScoreIdeaRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.copilot.v1'),
      createEmptyInstance: CopilotServiceScoreIdeaRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'ideaText')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CopilotServiceScoreIdeaRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CopilotServiceScoreIdeaRequest copyWith(
          void Function(CopilotServiceScoreIdeaRequest) updates) =>
      super.copyWith(
              (message) => updates(message as CopilotServiceScoreIdeaRequest))
          as CopilotServiceScoreIdeaRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use CopilotServiceScoreIdeaRequest() / CopilotServiceScoreIdeaRequest.new instead')
  static CopilotServiceScoreIdeaRequest create() =>
      CopilotServiceScoreIdeaRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      CopilotServiceScoreIdeaRequest._();
  @$core.override
  CopilotServiceScoreIdeaRequest createEmptyInstance() =>
      CopilotServiceScoreIdeaRequest._();
  @$core.pragma('dart2js:noInline')
  static CopilotServiceScoreIdeaRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CopilotServiceScoreIdeaRequest>(
          CopilotServiceScoreIdeaRequest.$_createMessage);
  static CopilotServiceScoreIdeaRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get ideaText => $_getSZ(1);
  @$pb.TagNumber(2)
  set ideaText($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasIdeaText() => $_has(1);
  @$pb.TagNumber(2)
  void clearIdeaText() => $_clearField(2);
}

class CopilotServiceScoreIdeaResponse extends $pb.GeneratedMessage {
  factory CopilotServiceScoreIdeaResponse({
    $core.int? viralityScore,
    $core.String? critique,
  }) {
    final result = CopilotServiceScoreIdeaResponse._();
    if (viralityScore != null) result.viralityScore = viralityScore;
    if (critique != null) result.critique = critique;
    return result;
  }

  CopilotServiceScoreIdeaResponse._();

  factory CopilotServiceScoreIdeaResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CopilotServiceScoreIdeaResponse()..mergeFromBuffer(data, registry);
  factory CopilotServiceScoreIdeaResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CopilotServiceScoreIdeaResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CopilotServiceScoreIdeaResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.copilot.v1'),
      createEmptyInstance: CopilotServiceScoreIdeaResponse.$_createMessage)
    ..aI(1, _omitFieldNames ? '' : 'viralityScore')
    ..aOS(2, _omitFieldNames ? '' : 'critique')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CopilotServiceScoreIdeaResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CopilotServiceScoreIdeaResponse copyWith(
          void Function(CopilotServiceScoreIdeaResponse) updates) =>
      super.copyWith(
              (message) => updates(message as CopilotServiceScoreIdeaResponse))
          as CopilotServiceScoreIdeaResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use CopilotServiceScoreIdeaResponse() / CopilotServiceScoreIdeaResponse.new instead')
  static CopilotServiceScoreIdeaResponse create() =>
      CopilotServiceScoreIdeaResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      CopilotServiceScoreIdeaResponse._();
  @$core.override
  CopilotServiceScoreIdeaResponse createEmptyInstance() =>
      CopilotServiceScoreIdeaResponse._();
  @$core.pragma('dart2js:noInline')
  static CopilotServiceScoreIdeaResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CopilotServiceScoreIdeaResponse>(
          CopilotServiceScoreIdeaResponse.$_createMessage);
  static CopilotServiceScoreIdeaResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get viralityScore => $_getIZ(0);
  @$pb.TagNumber(1)
  set viralityScore($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasViralityScore() => $_has(0);
  @$pb.TagNumber(1)
  void clearViralityScore() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get critique => $_getSZ(1);
  @$pb.TagNumber(2)
  set critique($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCritique() => $_has(1);
  @$pb.TagNumber(2)
  void clearCritique() => $_clearField(2);
}

class CopilotServiceCheckBrandVoiceRequest extends $pb.GeneratedMessage {
  factory CopilotServiceCheckBrandVoiceRequest({
    $core.String? workspaceId,
    $core.String? text,
    $core.String? brandPackId,
  }) {
    final result = CopilotServiceCheckBrandVoiceRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (text != null) result.text = text;
    if (brandPackId != null) result.brandPackId = brandPackId;
    return result;
  }

  CopilotServiceCheckBrandVoiceRequest._();

  factory CopilotServiceCheckBrandVoiceRequest.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CopilotServiceCheckBrandVoiceRequest()..mergeFromBuffer(data, registry);
  factory CopilotServiceCheckBrandVoiceRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CopilotServiceCheckBrandVoiceRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CopilotServiceCheckBrandVoiceRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.copilot.v1'),
      createEmptyInstance: CopilotServiceCheckBrandVoiceRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'text')
    ..aOS(3, _omitFieldNames ? '' : 'brandPackId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CopilotServiceCheckBrandVoiceRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CopilotServiceCheckBrandVoiceRequest copyWith(
          void Function(CopilotServiceCheckBrandVoiceRequest) updates) =>
      super.copyWith((message) =>
              updates(message as CopilotServiceCheckBrandVoiceRequest))
          as CopilotServiceCheckBrandVoiceRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use CopilotServiceCheckBrandVoiceRequest() / CopilotServiceCheckBrandVoiceRequest.new instead')
  static CopilotServiceCheckBrandVoiceRequest create() =>
      CopilotServiceCheckBrandVoiceRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      CopilotServiceCheckBrandVoiceRequest._();
  @$core.override
  CopilotServiceCheckBrandVoiceRequest createEmptyInstance() =>
      CopilotServiceCheckBrandVoiceRequest._();
  @$core.pragma('dart2js:noInline')
  static CopilotServiceCheckBrandVoiceRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
              CopilotServiceCheckBrandVoiceRequest>(
          CopilotServiceCheckBrandVoiceRequest.$_createMessage);
  static CopilotServiceCheckBrandVoiceRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get text => $_getSZ(1);
  @$pb.TagNumber(2)
  set text($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasText() => $_has(1);
  @$pb.TagNumber(2)
  void clearText() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get brandPackId => $_getSZ(2);
  @$pb.TagNumber(3)
  set brandPackId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasBrandPackId() => $_has(2);
  @$pb.TagNumber(3)
  void clearBrandPackId() => $_clearField(3);
}

class CopilotServiceCheckBrandVoiceResponse extends $pb.GeneratedMessage {
  factory CopilotServiceCheckBrandVoiceResponse({
    $core.int? consistencyScore,
    $core.Iterable<$core.String>? recommendations,
  }) {
    final result = CopilotServiceCheckBrandVoiceResponse._();
    if (consistencyScore != null) result.consistencyScore = consistencyScore;
    if (recommendations != null) result.recommendations.addAll(recommendations);
    return result;
  }

  CopilotServiceCheckBrandVoiceResponse._();

  factory CopilotServiceCheckBrandVoiceResponse.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CopilotServiceCheckBrandVoiceResponse()..mergeFromBuffer(data, registry);
  factory CopilotServiceCheckBrandVoiceResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CopilotServiceCheckBrandVoiceResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CopilotServiceCheckBrandVoiceResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.copilot.v1'),
      createEmptyInstance:
          CopilotServiceCheckBrandVoiceResponse.$_createMessage)
    ..aI(1, _omitFieldNames ? '' : 'consistencyScore')
    ..pPS(2, _omitFieldNames ? '' : 'recommendations')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CopilotServiceCheckBrandVoiceResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CopilotServiceCheckBrandVoiceResponse copyWith(
          void Function(CopilotServiceCheckBrandVoiceResponse) updates) =>
      super.copyWith((message) =>
              updates(message as CopilotServiceCheckBrandVoiceResponse))
          as CopilotServiceCheckBrandVoiceResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use CopilotServiceCheckBrandVoiceResponse() / CopilotServiceCheckBrandVoiceResponse.new instead')
  static CopilotServiceCheckBrandVoiceResponse create() =>
      CopilotServiceCheckBrandVoiceResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      CopilotServiceCheckBrandVoiceResponse._();
  @$core.override
  CopilotServiceCheckBrandVoiceResponse createEmptyInstance() =>
      CopilotServiceCheckBrandVoiceResponse._();
  @$core.pragma('dart2js:noInline')
  static CopilotServiceCheckBrandVoiceResponse getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
              CopilotServiceCheckBrandVoiceResponse>(
          CopilotServiceCheckBrandVoiceResponse.$_createMessage);
  static CopilotServiceCheckBrandVoiceResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get consistencyScore => $_getIZ(0);
  @$pb.TagNumber(1)
  set consistencyScore($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasConsistencyScore() => $_has(0);
  @$pb.TagNumber(1)
  void clearConsistencyScore() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbList<$core.String> get recommendations => $_getList(1);
}

class CopilotServiceAnalyzeAnalyticsRequest extends $pb.GeneratedMessage {
  factory CopilotServiceAnalyzeAnalyticsRequest({
    $core.String? workspaceId,
    $core.String? timeframe,
  }) {
    final result = CopilotServiceAnalyzeAnalyticsRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (timeframe != null) result.timeframe = timeframe;
    return result;
  }

  CopilotServiceAnalyzeAnalyticsRequest._();

  factory CopilotServiceAnalyzeAnalyticsRequest.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CopilotServiceAnalyzeAnalyticsRequest()..mergeFromBuffer(data, registry);
  factory CopilotServiceAnalyzeAnalyticsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CopilotServiceAnalyzeAnalyticsRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CopilotServiceAnalyzeAnalyticsRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.copilot.v1'),
      createEmptyInstance:
          CopilotServiceAnalyzeAnalyticsRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'timeframe')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CopilotServiceAnalyzeAnalyticsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CopilotServiceAnalyzeAnalyticsRequest copyWith(
          void Function(CopilotServiceAnalyzeAnalyticsRequest) updates) =>
      super.copyWith((message) =>
              updates(message as CopilotServiceAnalyzeAnalyticsRequest))
          as CopilotServiceAnalyzeAnalyticsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use CopilotServiceAnalyzeAnalyticsRequest() / CopilotServiceAnalyzeAnalyticsRequest.new instead')
  static CopilotServiceAnalyzeAnalyticsRequest create() =>
      CopilotServiceAnalyzeAnalyticsRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      CopilotServiceAnalyzeAnalyticsRequest._();
  @$core.override
  CopilotServiceAnalyzeAnalyticsRequest createEmptyInstance() =>
      CopilotServiceAnalyzeAnalyticsRequest._();
  @$core.pragma('dart2js:noInline')
  static CopilotServiceAnalyzeAnalyticsRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
              CopilotServiceAnalyzeAnalyticsRequest>(
          CopilotServiceAnalyzeAnalyticsRequest.$_createMessage);
  static CopilotServiceAnalyzeAnalyticsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get timeframe => $_getSZ(1);
  @$pb.TagNumber(2)
  set timeframe($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTimeframe() => $_has(1);
  @$pb.TagNumber(2)
  void clearTimeframe() => $_clearField(2);
}

class CopilotServiceAnalyzeAnalyticsResponse extends $pb.GeneratedMessage {
  factory CopilotServiceAnalyzeAnalyticsResponse({
    $core.String? summary,
    $core.Iterable<$core.String>? findings,
    $core.bool? isRedacted,
  }) {
    final result = CopilotServiceAnalyzeAnalyticsResponse._();
    if (summary != null) result.summary = summary;
    if (findings != null) result.findings.addAll(findings);
    if (isRedacted != null) result.isRedacted = isRedacted;
    return result;
  }

  CopilotServiceAnalyzeAnalyticsResponse._();

  factory CopilotServiceAnalyzeAnalyticsResponse.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CopilotServiceAnalyzeAnalyticsResponse()..mergeFromBuffer(data, registry);
  factory CopilotServiceAnalyzeAnalyticsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CopilotServiceAnalyzeAnalyticsResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CopilotServiceAnalyzeAnalyticsResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.copilot.v1'),
      createEmptyInstance:
          CopilotServiceAnalyzeAnalyticsResponse.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'summary')
    ..pPS(2, _omitFieldNames ? '' : 'findings')
    ..aOB(3, _omitFieldNames ? '' : 'isRedacted')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CopilotServiceAnalyzeAnalyticsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CopilotServiceAnalyzeAnalyticsResponse copyWith(
          void Function(CopilotServiceAnalyzeAnalyticsResponse) updates) =>
      super.copyWith((message) =>
              updates(message as CopilotServiceAnalyzeAnalyticsResponse))
          as CopilotServiceAnalyzeAnalyticsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use CopilotServiceAnalyzeAnalyticsResponse() / CopilotServiceAnalyzeAnalyticsResponse.new instead')
  static CopilotServiceAnalyzeAnalyticsResponse create() =>
      CopilotServiceAnalyzeAnalyticsResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      CopilotServiceAnalyzeAnalyticsResponse._();
  @$core.override
  CopilotServiceAnalyzeAnalyticsResponse createEmptyInstance() =>
      CopilotServiceAnalyzeAnalyticsResponse._();
  @$core.pragma('dart2js:noInline')
  static CopilotServiceAnalyzeAnalyticsResponse getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
              CopilotServiceAnalyzeAnalyticsResponse>(
          CopilotServiceAnalyzeAnalyticsResponse.$_createMessage);
  static CopilotServiceAnalyzeAnalyticsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get summary => $_getSZ(0);
  @$pb.TagNumber(1)
  set summary($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSummary() => $_has(0);
  @$pb.TagNumber(1)
  void clearSummary() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbList<$core.String> get findings => $_getList(1);

  @$pb.TagNumber(3)
  $core.bool get isRedacted => $_getBF(2);
  @$pb.TagNumber(3)
  set isRedacted($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasIsRedacted() => $_has(2);
  @$pb.TagNumber(3)
  void clearIsRedacted() => $_clearField(3);
}

class CopilotServiceAnalyzePipelineRequest extends $pb.GeneratedMessage {
  factory CopilotServiceAnalyzePipelineRequest({
    $core.String? workspaceId,
  }) {
    final result = CopilotServiceAnalyzePipelineRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    return result;
  }

  CopilotServiceAnalyzePipelineRequest._();

  factory CopilotServiceAnalyzePipelineRequest.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CopilotServiceAnalyzePipelineRequest()..mergeFromBuffer(data, registry);
  factory CopilotServiceAnalyzePipelineRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CopilotServiceAnalyzePipelineRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CopilotServiceAnalyzePipelineRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.copilot.v1'),
      createEmptyInstance: CopilotServiceAnalyzePipelineRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CopilotServiceAnalyzePipelineRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CopilotServiceAnalyzePipelineRequest copyWith(
          void Function(CopilotServiceAnalyzePipelineRequest) updates) =>
      super.copyWith((message) =>
              updates(message as CopilotServiceAnalyzePipelineRequest))
          as CopilotServiceAnalyzePipelineRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use CopilotServiceAnalyzePipelineRequest() / CopilotServiceAnalyzePipelineRequest.new instead')
  static CopilotServiceAnalyzePipelineRequest create() =>
      CopilotServiceAnalyzePipelineRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      CopilotServiceAnalyzePipelineRequest._();
  @$core.override
  CopilotServiceAnalyzePipelineRequest createEmptyInstance() =>
      CopilotServiceAnalyzePipelineRequest._();
  @$core.pragma('dart2js:noInline')
  static CopilotServiceAnalyzePipelineRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
              CopilotServiceAnalyzePipelineRequest>(
          CopilotServiceAnalyzePipelineRequest.$_createMessage);
  static CopilotServiceAnalyzePipelineRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);
}

class CopilotServiceAnalyzePipelineResponse extends $pb.GeneratedMessage {
  factory CopilotServiceAnalyzePipelineResponse({
    $core.String? pipelineHealth,
    $core.Iterable<$core.String>? bottlenecks,
  }) {
    final result = CopilotServiceAnalyzePipelineResponse._();
    if (pipelineHealth != null) result.pipelineHealth = pipelineHealth;
    if (bottlenecks != null) result.bottlenecks.addAll(bottlenecks);
    return result;
  }

  CopilotServiceAnalyzePipelineResponse._();

  factory CopilotServiceAnalyzePipelineResponse.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CopilotServiceAnalyzePipelineResponse()..mergeFromBuffer(data, registry);
  factory CopilotServiceAnalyzePipelineResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CopilotServiceAnalyzePipelineResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CopilotServiceAnalyzePipelineResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.copilot.v1'),
      createEmptyInstance:
          CopilotServiceAnalyzePipelineResponse.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'pipelineHealth')
    ..pPS(2, _omitFieldNames ? '' : 'bottlenecks')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CopilotServiceAnalyzePipelineResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CopilotServiceAnalyzePipelineResponse copyWith(
          void Function(CopilotServiceAnalyzePipelineResponse) updates) =>
      super.copyWith((message) =>
              updates(message as CopilotServiceAnalyzePipelineResponse))
          as CopilotServiceAnalyzePipelineResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use CopilotServiceAnalyzePipelineResponse() / CopilotServiceAnalyzePipelineResponse.new instead')
  static CopilotServiceAnalyzePipelineResponse create() =>
      CopilotServiceAnalyzePipelineResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      CopilotServiceAnalyzePipelineResponse._();
  @$core.override
  CopilotServiceAnalyzePipelineResponse createEmptyInstance() =>
      CopilotServiceAnalyzePipelineResponse._();
  @$core.pragma('dart2js:noInline')
  static CopilotServiceAnalyzePipelineResponse getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
              CopilotServiceAnalyzePipelineResponse>(
          CopilotServiceAnalyzePipelineResponse.$_createMessage);
  static CopilotServiceAnalyzePipelineResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get pipelineHealth => $_getSZ(0);
  @$pb.TagNumber(1)
  set pipelineHealth($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPipelineHealth() => $_has(0);
  @$pb.TagNumber(1)
  void clearPipelineHealth() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbList<$core.String> get bottlenecks => $_getList(1);
}

class CopilotServiceAnalyticsInsightsRequest extends $pb.GeneratedMessage {
  factory CopilotServiceAnalyticsInsightsRequest({
    $core.String? workspaceId,
    $core.String? module,
  }) {
    final result = CopilotServiceAnalyticsInsightsRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (module != null) result.module = module;
    return result;
  }

  CopilotServiceAnalyticsInsightsRequest._();

  factory CopilotServiceAnalyticsInsightsRequest.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CopilotServiceAnalyticsInsightsRequest()..mergeFromBuffer(data, registry);
  factory CopilotServiceAnalyticsInsightsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CopilotServiceAnalyticsInsightsRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CopilotServiceAnalyticsInsightsRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.copilot.v1'),
      createEmptyInstance:
          CopilotServiceAnalyticsInsightsRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'module')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CopilotServiceAnalyticsInsightsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CopilotServiceAnalyticsInsightsRequest copyWith(
          void Function(CopilotServiceAnalyticsInsightsRequest) updates) =>
      super.copyWith((message) =>
              updates(message as CopilotServiceAnalyticsInsightsRequest))
          as CopilotServiceAnalyticsInsightsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use CopilotServiceAnalyticsInsightsRequest() / CopilotServiceAnalyticsInsightsRequest.new instead')
  static CopilotServiceAnalyticsInsightsRequest create() =>
      CopilotServiceAnalyticsInsightsRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      CopilotServiceAnalyticsInsightsRequest._();
  @$core.override
  CopilotServiceAnalyticsInsightsRequest createEmptyInstance() =>
      CopilotServiceAnalyticsInsightsRequest._();
  @$core.pragma('dart2js:noInline')
  static CopilotServiceAnalyticsInsightsRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
              CopilotServiceAnalyticsInsightsRequest>(
          CopilotServiceAnalyticsInsightsRequest.$_createMessage);
  static CopilotServiceAnalyticsInsightsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get module => $_getSZ(1);
  @$pb.TagNumber(2)
  set module($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasModule() => $_has(1);
  @$pb.TagNumber(2)
  void clearModule() => $_clearField(2);
}

class CopilotServiceAnalyticsInsightsResponse extends $pb.GeneratedMessage {
  factory CopilotServiceAnalyticsInsightsResponse({
    $core.Iterable<$core.String>? insights,
  }) {
    final result = CopilotServiceAnalyticsInsightsResponse._();
    if (insights != null) result.insights.addAll(insights);
    return result;
  }

  CopilotServiceAnalyticsInsightsResponse._();

  factory CopilotServiceAnalyticsInsightsResponse.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CopilotServiceAnalyticsInsightsResponse()
        ..mergeFromBuffer(data, registry);
  factory CopilotServiceAnalyticsInsightsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CopilotServiceAnalyticsInsightsResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CopilotServiceAnalyticsInsightsResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.copilot.v1'),
      createEmptyInstance:
          CopilotServiceAnalyticsInsightsResponse.$_createMessage)
    ..pPS(1, _omitFieldNames ? '' : 'insights')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CopilotServiceAnalyticsInsightsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CopilotServiceAnalyticsInsightsResponse copyWith(
          void Function(CopilotServiceAnalyticsInsightsResponse) updates) =>
      super.copyWith((message) =>
              updates(message as CopilotServiceAnalyticsInsightsResponse))
          as CopilotServiceAnalyticsInsightsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use CopilotServiceAnalyticsInsightsResponse() / CopilotServiceAnalyticsInsightsResponse.new instead')
  static CopilotServiceAnalyticsInsightsResponse create() =>
      CopilotServiceAnalyticsInsightsResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      CopilotServiceAnalyticsInsightsResponse._();
  @$core.override
  CopilotServiceAnalyticsInsightsResponse createEmptyInstance() =>
      CopilotServiceAnalyticsInsightsResponse._();
  @$core.pragma('dart2js:noInline')
  static CopilotServiceAnalyticsInsightsResponse getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
              CopilotServiceAnalyticsInsightsResponse>(
          CopilotServiceAnalyticsInsightsResponse.$_createMessage);
  static CopilotServiceAnalyticsInsightsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<$core.String> get insights => $_getList(0);
}

class CopilotServiceFinanceInsightRequest extends $pb.GeneratedMessage {
  factory CopilotServiceFinanceInsightRequest({
    $core.String? workspaceId,
    $core.String? period,
  }) {
    final result = CopilotServiceFinanceInsightRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (period != null) result.period = period;
    return result;
  }

  CopilotServiceFinanceInsightRequest._();

  factory CopilotServiceFinanceInsightRequest.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CopilotServiceFinanceInsightRequest()..mergeFromBuffer(data, registry);
  factory CopilotServiceFinanceInsightRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CopilotServiceFinanceInsightRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CopilotServiceFinanceInsightRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.copilot.v1'),
      createEmptyInstance: CopilotServiceFinanceInsightRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'period')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CopilotServiceFinanceInsightRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CopilotServiceFinanceInsightRequest copyWith(
          void Function(CopilotServiceFinanceInsightRequest) updates) =>
      super.copyWith((message) =>
              updates(message as CopilotServiceFinanceInsightRequest))
          as CopilotServiceFinanceInsightRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use CopilotServiceFinanceInsightRequest() / CopilotServiceFinanceInsightRequest.new instead')
  static CopilotServiceFinanceInsightRequest create() =>
      CopilotServiceFinanceInsightRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      CopilotServiceFinanceInsightRequest._();
  @$core.override
  CopilotServiceFinanceInsightRequest createEmptyInstance() =>
      CopilotServiceFinanceInsightRequest._();
  @$core.pragma('dart2js:noInline')
  static CopilotServiceFinanceInsightRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
              CopilotServiceFinanceInsightRequest>(
          CopilotServiceFinanceInsightRequest.$_createMessage);
  static CopilotServiceFinanceInsightRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get period => $_getSZ(1);
  @$pb.TagNumber(2)
  set period($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPeriod() => $_has(1);
  @$pb.TagNumber(2)
  void clearPeriod() => $_clearField(2);
}

class CopilotServiceFinanceInsightResponse extends $pb.GeneratedMessage {
  factory CopilotServiceFinanceInsightResponse({
    $core.String? insight,
    $core.bool? isRedacted,
    $core.String? redactionReason,
  }) {
    final result = CopilotServiceFinanceInsightResponse._();
    if (insight != null) result.insight = insight;
    if (isRedacted != null) result.isRedacted = isRedacted;
    if (redactionReason != null) result.redactionReason = redactionReason;
    return result;
  }

  CopilotServiceFinanceInsightResponse._();

  factory CopilotServiceFinanceInsightResponse.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CopilotServiceFinanceInsightResponse()..mergeFromBuffer(data, registry);
  factory CopilotServiceFinanceInsightResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CopilotServiceFinanceInsightResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CopilotServiceFinanceInsightResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.copilot.v1'),
      createEmptyInstance: CopilotServiceFinanceInsightResponse.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'insight')
    ..aOB(2, _omitFieldNames ? '' : 'isRedacted')
    ..aOS(3, _omitFieldNames ? '' : 'redactionReason')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CopilotServiceFinanceInsightResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CopilotServiceFinanceInsightResponse copyWith(
          void Function(CopilotServiceFinanceInsightResponse) updates) =>
      super.copyWith((message) =>
              updates(message as CopilotServiceFinanceInsightResponse))
          as CopilotServiceFinanceInsightResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use CopilotServiceFinanceInsightResponse() / CopilotServiceFinanceInsightResponse.new instead')
  static CopilotServiceFinanceInsightResponse create() =>
      CopilotServiceFinanceInsightResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      CopilotServiceFinanceInsightResponse._();
  @$core.override
  CopilotServiceFinanceInsightResponse createEmptyInstance() =>
      CopilotServiceFinanceInsightResponse._();
  @$core.pragma('dart2js:noInline')
  static CopilotServiceFinanceInsightResponse getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
              CopilotServiceFinanceInsightResponse>(
          CopilotServiceFinanceInsightResponse.$_createMessage);
  static CopilotServiceFinanceInsightResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get insight => $_getSZ(0);
  @$pb.TagNumber(1)
  set insight($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasInsight() => $_has(0);
  @$pb.TagNumber(1)
  void clearInsight() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.bool get isRedacted => $_getBF(1);
  @$pb.TagNumber(2)
  set isRedacted($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasIsRedacted() => $_has(1);
  @$pb.TagNumber(2)
  void clearIsRedacted() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get redactionReason => $_getSZ(2);
  @$pb.TagNumber(3)
  set redactionReason($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasRedactionReason() => $_has(2);
  @$pb.TagNumber(3)
  void clearRedactionReason() => $_clearField(3);
}

class CopilotServiceTrendInsightRequest extends $pb.GeneratedMessage {
  factory CopilotServiceTrendInsightRequest({
    $core.String? workspaceId,
    $core.String? category,
  }) {
    final result = CopilotServiceTrendInsightRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (category != null) result.category = category;
    return result;
  }

  CopilotServiceTrendInsightRequest._();

  factory CopilotServiceTrendInsightRequest.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CopilotServiceTrendInsightRequest()..mergeFromBuffer(data, registry);
  factory CopilotServiceTrendInsightRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CopilotServiceTrendInsightRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CopilotServiceTrendInsightRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.copilot.v1'),
      createEmptyInstance: CopilotServiceTrendInsightRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'category')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CopilotServiceTrendInsightRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CopilotServiceTrendInsightRequest copyWith(
          void Function(CopilotServiceTrendInsightRequest) updates) =>
      super.copyWith((message) =>
              updates(message as CopilotServiceTrendInsightRequest))
          as CopilotServiceTrendInsightRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use CopilotServiceTrendInsightRequest() / CopilotServiceTrendInsightRequest.new instead')
  static CopilotServiceTrendInsightRequest create() =>
      CopilotServiceTrendInsightRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      CopilotServiceTrendInsightRequest._();
  @$core.override
  CopilotServiceTrendInsightRequest createEmptyInstance() =>
      CopilotServiceTrendInsightRequest._();
  @$core.pragma('dart2js:noInline')
  static CopilotServiceTrendInsightRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CopilotServiceTrendInsightRequest>(
          CopilotServiceTrendInsightRequest.$_createMessage);
  static CopilotServiceTrendInsightRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get category => $_getSZ(1);
  @$pb.TagNumber(2)
  set category($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCategory() => $_has(1);
  @$pb.TagNumber(2)
  void clearCategory() => $_clearField(2);
}

class CopilotServiceTrendInsightResponse extends $pb.GeneratedMessage {
  factory CopilotServiceTrendInsightResponse({
    $core.Iterable<$core.String>? trendRecommendations,
  }) {
    final result = CopilotServiceTrendInsightResponse._();
    if (trendRecommendations != null)
      result.trendRecommendations.addAll(trendRecommendations);
    return result;
  }

  CopilotServiceTrendInsightResponse._();

  factory CopilotServiceTrendInsightResponse.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CopilotServiceTrendInsightResponse()..mergeFromBuffer(data, registry);
  factory CopilotServiceTrendInsightResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CopilotServiceTrendInsightResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CopilotServiceTrendInsightResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.copilot.v1'),
      createEmptyInstance: CopilotServiceTrendInsightResponse.$_createMessage)
    ..pPS(1, _omitFieldNames ? '' : 'trendRecommendations')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CopilotServiceTrendInsightResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CopilotServiceTrendInsightResponse copyWith(
          void Function(CopilotServiceTrendInsightResponse) updates) =>
      super.copyWith((message) =>
              updates(message as CopilotServiceTrendInsightResponse))
          as CopilotServiceTrendInsightResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use CopilotServiceTrendInsightResponse() / CopilotServiceTrendInsightResponse.new instead')
  static CopilotServiceTrendInsightResponse create() =>
      CopilotServiceTrendInsightResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      CopilotServiceTrendInsightResponse._();
  @$core.override
  CopilotServiceTrendInsightResponse createEmptyInstance() =>
      CopilotServiceTrendInsightResponse._();
  @$core.pragma('dart2js:noInline')
  static CopilotServiceTrendInsightResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CopilotServiceTrendInsightResponse>(
          CopilotServiceTrendInsightResponse.$_createMessage);
  static CopilotServiceTrendInsightResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<$core.String> get trendRecommendations => $_getList(0);
}

class CopilotServiceGetContentOptimizationRequest extends $pb.GeneratedMessage {
  factory CopilotServiceGetContentOptimizationRequest({
    $core.String? workspaceId,
    $core.String? contentId,
  }) {
    final result = CopilotServiceGetContentOptimizationRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (contentId != null) result.contentId = contentId;
    return result;
  }

  CopilotServiceGetContentOptimizationRequest._();

  factory CopilotServiceGetContentOptimizationRequest.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CopilotServiceGetContentOptimizationRequest()
        ..mergeFromBuffer(data, registry);
  factory CopilotServiceGetContentOptimizationRequest.fromJson(
          $core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CopilotServiceGetContentOptimizationRequest()
        ..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CopilotServiceGetContentOptimizationRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.copilot.v1'),
      createEmptyInstance:
          CopilotServiceGetContentOptimizationRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'contentId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CopilotServiceGetContentOptimizationRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CopilotServiceGetContentOptimizationRequest copyWith(
          void Function(CopilotServiceGetContentOptimizationRequest) updates) =>
      super.copyWith((message) =>
              updates(message as CopilotServiceGetContentOptimizationRequest))
          as CopilotServiceGetContentOptimizationRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use CopilotServiceGetContentOptimizationRequest() / CopilotServiceGetContentOptimizationRequest.new instead')
  static CopilotServiceGetContentOptimizationRequest create() =>
      CopilotServiceGetContentOptimizationRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      CopilotServiceGetContentOptimizationRequest._();
  @$core.override
  CopilotServiceGetContentOptimizationRequest createEmptyInstance() =>
      CopilotServiceGetContentOptimizationRequest._();
  @$core.pragma('dart2js:noInline')
  static CopilotServiceGetContentOptimizationRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
              CopilotServiceGetContentOptimizationRequest>(
          CopilotServiceGetContentOptimizationRequest.$_createMessage);
  static CopilotServiceGetContentOptimizationRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get contentId => $_getSZ(1);
  @$pb.TagNumber(2)
  set contentId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasContentId() => $_has(1);
  @$pb.TagNumber(2)
  void clearContentId() => $_clearField(2);
}

class CopilotServiceGetContentOptimizationResponse
    extends $pb.GeneratedMessage {
  factory CopilotServiceGetContentOptimizationResponse({
    $core.Iterable<$core.String>? suggestions,
  }) {
    final result = CopilotServiceGetContentOptimizationResponse._();
    if (suggestions != null) result.suggestions.addAll(suggestions);
    return result;
  }

  CopilotServiceGetContentOptimizationResponse._();

  factory CopilotServiceGetContentOptimizationResponse.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CopilotServiceGetContentOptimizationResponse()
        ..mergeFromBuffer(data, registry);
  factory CopilotServiceGetContentOptimizationResponse.fromJson(
          $core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CopilotServiceGetContentOptimizationResponse()
        ..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CopilotServiceGetContentOptimizationResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.copilot.v1'),
      createEmptyInstance:
          CopilotServiceGetContentOptimizationResponse.$_createMessage)
    ..pPS(1, _omitFieldNames ? '' : 'suggestions')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CopilotServiceGetContentOptimizationResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CopilotServiceGetContentOptimizationResponse copyWith(
          void Function(CopilotServiceGetContentOptimizationResponse)
              updates) =>
      super.copyWith((message) =>
              updates(message as CopilotServiceGetContentOptimizationResponse))
          as CopilotServiceGetContentOptimizationResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use CopilotServiceGetContentOptimizationResponse() / CopilotServiceGetContentOptimizationResponse.new instead')
  static CopilotServiceGetContentOptimizationResponse create() =>
      CopilotServiceGetContentOptimizationResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      CopilotServiceGetContentOptimizationResponse._();
  @$core.override
  CopilotServiceGetContentOptimizationResponse createEmptyInstance() =>
      CopilotServiceGetContentOptimizationResponse._();
  @$core.pragma('dart2js:noInline')
  static CopilotServiceGetContentOptimizationResponse getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
              CopilotServiceGetContentOptimizationResponse>(
          CopilotServiceGetContentOptimizationResponse.$_createMessage);
  static CopilotServiceGetContentOptimizationResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<$core.String> get suggestions => $_getList(0);
}

class CopilotServiceGetCostOptimizationRequest extends $pb.GeneratedMessage {
  factory CopilotServiceGetCostOptimizationRequest({
    $core.String? workspaceId,
  }) {
    final result = CopilotServiceGetCostOptimizationRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    return result;
  }

  CopilotServiceGetCostOptimizationRequest._();

  factory CopilotServiceGetCostOptimizationRequest.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CopilotServiceGetCostOptimizationRequest()
        ..mergeFromBuffer(data, registry);
  factory CopilotServiceGetCostOptimizationRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CopilotServiceGetCostOptimizationRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CopilotServiceGetCostOptimizationRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.copilot.v1'),
      createEmptyInstance:
          CopilotServiceGetCostOptimizationRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CopilotServiceGetCostOptimizationRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CopilotServiceGetCostOptimizationRequest copyWith(
          void Function(CopilotServiceGetCostOptimizationRequest) updates) =>
      super.copyWith((message) =>
              updates(message as CopilotServiceGetCostOptimizationRequest))
          as CopilotServiceGetCostOptimizationRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use CopilotServiceGetCostOptimizationRequest() / CopilotServiceGetCostOptimizationRequest.new instead')
  static CopilotServiceGetCostOptimizationRequest create() =>
      CopilotServiceGetCostOptimizationRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      CopilotServiceGetCostOptimizationRequest._();
  @$core.override
  CopilotServiceGetCostOptimizationRequest createEmptyInstance() =>
      CopilotServiceGetCostOptimizationRequest._();
  @$core.pragma('dart2js:noInline')
  static CopilotServiceGetCostOptimizationRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
              CopilotServiceGetCostOptimizationRequest>(
          CopilotServiceGetCostOptimizationRequest.$_createMessage);
  static CopilotServiceGetCostOptimizationRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);
}

class CopilotServiceGetCostOptimizationResponse extends $pb.GeneratedMessage {
  factory CopilotServiceGetCostOptimizationResponse({
    $core.Iterable<$core.String>? suggestions,
    $core.bool? isRedacted,
  }) {
    final result = CopilotServiceGetCostOptimizationResponse._();
    if (suggestions != null) result.suggestions.addAll(suggestions);
    if (isRedacted != null) result.isRedacted = isRedacted;
    return result;
  }

  CopilotServiceGetCostOptimizationResponse._();

  factory CopilotServiceGetCostOptimizationResponse.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CopilotServiceGetCostOptimizationResponse()
        ..mergeFromBuffer(data, registry);
  factory CopilotServiceGetCostOptimizationResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CopilotServiceGetCostOptimizationResponse()
        ..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CopilotServiceGetCostOptimizationResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.copilot.v1'),
      createEmptyInstance:
          CopilotServiceGetCostOptimizationResponse.$_createMessage)
    ..pPS(1, _omitFieldNames ? '' : 'suggestions')
    ..aOB(2, _omitFieldNames ? '' : 'isRedacted')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CopilotServiceGetCostOptimizationResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CopilotServiceGetCostOptimizationResponse copyWith(
          void Function(CopilotServiceGetCostOptimizationResponse) updates) =>
      super.copyWith((message) =>
              updates(message as CopilotServiceGetCostOptimizationResponse))
          as CopilotServiceGetCostOptimizationResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use CopilotServiceGetCostOptimizationResponse() / CopilotServiceGetCostOptimizationResponse.new instead')
  static CopilotServiceGetCostOptimizationResponse create() =>
      CopilotServiceGetCostOptimizationResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      CopilotServiceGetCostOptimizationResponse._();
  @$core.override
  CopilotServiceGetCostOptimizationResponse createEmptyInstance() =>
      CopilotServiceGetCostOptimizationResponse._();
  @$core.pragma('dart2js:noInline')
  static CopilotServiceGetCostOptimizationResponse getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
              CopilotServiceGetCostOptimizationResponse>(
          CopilotServiceGetCostOptimizationResponse.$_createMessage);
  static CopilotServiceGetCostOptimizationResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<$core.String> get suggestions => $_getList(0);

  @$pb.TagNumber(2)
  $core.bool get isRedacted => $_getBF(1);
  @$pb.TagNumber(2)
  set isRedacted($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasIsRedacted() => $_has(1);
  @$pb.TagNumber(2)
  void clearIsRedacted() => $_clearField(2);
}

class CopilotServiceGetOptimalTimesRequest extends $pb.GeneratedMessage {
  factory CopilotServiceGetOptimalTimesRequest({
    $core.String? workspaceId,
    $core.String? platform,
  }) {
    final result = CopilotServiceGetOptimalTimesRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (platform != null) result.platform = platform;
    return result;
  }

  CopilotServiceGetOptimalTimesRequest._();

  factory CopilotServiceGetOptimalTimesRequest.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CopilotServiceGetOptimalTimesRequest()..mergeFromBuffer(data, registry);
  factory CopilotServiceGetOptimalTimesRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CopilotServiceGetOptimalTimesRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CopilotServiceGetOptimalTimesRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.copilot.v1'),
      createEmptyInstance: CopilotServiceGetOptimalTimesRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'platform')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CopilotServiceGetOptimalTimesRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CopilotServiceGetOptimalTimesRequest copyWith(
          void Function(CopilotServiceGetOptimalTimesRequest) updates) =>
      super.copyWith((message) =>
              updates(message as CopilotServiceGetOptimalTimesRequest))
          as CopilotServiceGetOptimalTimesRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use CopilotServiceGetOptimalTimesRequest() / CopilotServiceGetOptimalTimesRequest.new instead')
  static CopilotServiceGetOptimalTimesRequest create() =>
      CopilotServiceGetOptimalTimesRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      CopilotServiceGetOptimalTimesRequest._();
  @$core.override
  CopilotServiceGetOptimalTimesRequest createEmptyInstance() =>
      CopilotServiceGetOptimalTimesRequest._();
  @$core.pragma('dart2js:noInline')
  static CopilotServiceGetOptimalTimesRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
              CopilotServiceGetOptimalTimesRequest>(
          CopilotServiceGetOptimalTimesRequest.$_createMessage);
  static CopilotServiceGetOptimalTimesRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get platform => $_getSZ(1);
  @$pb.TagNumber(2)
  set platform($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPlatform() => $_has(1);
  @$pb.TagNumber(2)
  void clearPlatform() => $_clearField(2);
}

class CopilotServiceGetOptimalTimesResponse extends $pb.GeneratedMessage {
  factory CopilotServiceGetOptimalTimesResponse({
    $core.Iterable<$core.String>? optimalTimeSlots,
  }) {
    final result = CopilotServiceGetOptimalTimesResponse._();
    if (optimalTimeSlots != null)
      result.optimalTimeSlots.addAll(optimalTimeSlots);
    return result;
  }

  CopilotServiceGetOptimalTimesResponse._();

  factory CopilotServiceGetOptimalTimesResponse.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CopilotServiceGetOptimalTimesResponse()..mergeFromBuffer(data, registry);
  factory CopilotServiceGetOptimalTimesResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      CopilotServiceGetOptimalTimesResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CopilotServiceGetOptimalTimesResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.copilot.v1'),
      createEmptyInstance:
          CopilotServiceGetOptimalTimesResponse.$_createMessage)
    ..pPS(1, _omitFieldNames ? '' : 'optimalTimeSlots')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CopilotServiceGetOptimalTimesResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CopilotServiceGetOptimalTimesResponse copyWith(
          void Function(CopilotServiceGetOptimalTimesResponse) updates) =>
      super.copyWith((message) =>
              updates(message as CopilotServiceGetOptimalTimesResponse))
          as CopilotServiceGetOptimalTimesResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use CopilotServiceGetOptimalTimesResponse() / CopilotServiceGetOptimalTimesResponse.new instead')
  static CopilotServiceGetOptimalTimesResponse create() =>
      CopilotServiceGetOptimalTimesResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      CopilotServiceGetOptimalTimesResponse._();
  @$core.override
  CopilotServiceGetOptimalTimesResponse createEmptyInstance() =>
      CopilotServiceGetOptimalTimesResponse._();
  @$core.pragma('dart2js:noInline')
  static CopilotServiceGetOptimalTimesResponse getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
              CopilotServiceGetOptimalTimesResponse>(
          CopilotServiceGetOptimalTimesResponse.$_createMessage);
  static CopilotServiceGetOptimalTimesResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<$core.String> get optimalTimeSlots => $_getList(0);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');

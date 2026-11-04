// This is a generated file - do not edit.
//
// Generated from creativanta/automation/v1/recipe.proto.

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

import 'recipe.pbenum.dart';
import 'workflow.pb.dart' as $2;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'recipe.pbenum.dart';

/// RecipeParameter defines a user-configurable parameter in a recipe template.
class RecipeParameter extends $pb.GeneratedMessage {
  factory RecipeParameter({
    $core.String? name,
    $core.String? type,
    $core.String? defaultValue,
    $core.bool? required,
    $core.String? description,
  }) {
    final result = RecipeParameter._();
    if (name != null) result.name = name;
    if (type != null) result.type = type;
    if (defaultValue != null) result.defaultValue = defaultValue;
    if (required != null) result.required = required;
    if (description != null) result.description = description;
    return result;
  }

  RecipeParameter._();

  factory RecipeParameter.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RecipeParameter()..mergeFromBuffer(data, registry);
  factory RecipeParameter.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RecipeParameter()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RecipeParameter',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.automation.v1'),
      createEmptyInstance: RecipeParameter.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'name')
    ..aOS(2, _omitFieldNames ? '' : 'type')
    ..aOS(3, _omitFieldNames ? '' : 'defaultValue')
    ..aOB(4, _omitFieldNames ? '' : 'required')
    ..aOS(5, _omitFieldNames ? '' : 'description')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecipeParameter clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecipeParameter copyWith(void Function(RecipeParameter) updates) =>
      super.copyWith((message) => updates(message as RecipeParameter))
          as RecipeParameter;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use RecipeParameter() / RecipeParameter.new instead')
  static RecipeParameter create() => RecipeParameter._();
  static $pb.GeneratedMessage $_createMessage() => RecipeParameter._();
  @$core.override
  RecipeParameter createEmptyInstance() => RecipeParameter._();
  @$core.pragma('dart2js:noInline')
  static RecipeParameter getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<RecipeParameter>(
          RecipeParameter.$_createMessage);
  static RecipeParameter? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get name => $_getSZ(0);
  @$pb.TagNumber(1)
  set name($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasName() => $_has(0);
  @$pb.TagNumber(1)
  void clearName() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get type => $_getSZ(1);
  @$pb.TagNumber(2)
  set type($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasType() => $_has(1);
  @$pb.TagNumber(2)
  void clearType() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get defaultValue => $_getSZ(2);
  @$pb.TagNumber(3)
  set defaultValue($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasDefaultValue() => $_has(2);
  @$pb.TagNumber(3)
  void clearDefaultValue() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.bool get required => $_getBF(3);
  @$pb.TagNumber(4)
  set required($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(4)
  $core.bool hasRequired() => $_has(3);
  @$pb.TagNumber(4)
  void clearRequired() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get description => $_getSZ(4);
  @$pb.TagNumber(5)
  set description($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasDescription() => $_has(4);
  @$pb.TagNumber(5)
  void clearDescription() => $_clearField(5);
}

/// MissingCapabilityExplanation provides structured user-facing diagnostic for missing requirements.
class MissingCapabilityExplanation extends $pb.GeneratedMessage {
  factory MissingCapabilityExplanation({
    $core.String? capabilityKey,
    $core.String? platform,
    $core.String? reason,
    $core.String? resolutionGuidance,
    $core.String? connectUrl,
  }) {
    final result = MissingCapabilityExplanation._();
    if (capabilityKey != null) result.capabilityKey = capabilityKey;
    if (platform != null) result.platform = platform;
    if (reason != null) result.reason = reason;
    if (resolutionGuidance != null)
      result.resolutionGuidance = resolutionGuidance;
    if (connectUrl != null) result.connectUrl = connectUrl;
    return result;
  }

  MissingCapabilityExplanation._();

  factory MissingCapabilityExplanation.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      MissingCapabilityExplanation()..mergeFromBuffer(data, registry);
  factory MissingCapabilityExplanation.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      MissingCapabilityExplanation()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MissingCapabilityExplanation',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.automation.v1'),
      createEmptyInstance: MissingCapabilityExplanation.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'capabilityKey')
    ..aOS(2, _omitFieldNames ? '' : 'platform')
    ..aOS(3, _omitFieldNames ? '' : 'reason')
    ..aOS(4, _omitFieldNames ? '' : 'resolutionGuidance')
    ..aOS(5, _omitFieldNames ? '' : 'connectUrl')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MissingCapabilityExplanation clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MissingCapabilityExplanation copyWith(
          void Function(MissingCapabilityExplanation) updates) =>
      super.copyWith(
              (message) => updates(message as MissingCapabilityExplanation))
          as MissingCapabilityExplanation;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use MissingCapabilityExplanation() / MissingCapabilityExplanation.new instead')
  static MissingCapabilityExplanation create() =>
      MissingCapabilityExplanation._();
  static $pb.GeneratedMessage $_createMessage() =>
      MissingCapabilityExplanation._();
  @$core.override
  MissingCapabilityExplanation createEmptyInstance() =>
      MissingCapabilityExplanation._();
  @$core.pragma('dart2js:noInline')
  static MissingCapabilityExplanation getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<MissingCapabilityExplanation>(
          MissingCapabilityExplanation.$_createMessage);
  static MissingCapabilityExplanation? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get capabilityKey => $_getSZ(0);
  @$pb.TagNumber(1)
  set capabilityKey($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCapabilityKey() => $_has(0);
  @$pb.TagNumber(1)
  void clearCapabilityKey() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get platform => $_getSZ(1);
  @$pb.TagNumber(2)
  set platform($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPlatform() => $_has(1);
  @$pb.TagNumber(2)
  void clearPlatform() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get reason => $_getSZ(2);
  @$pb.TagNumber(3)
  set reason($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasReason() => $_has(2);
  @$pb.TagNumber(3)
  void clearReason() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get resolutionGuidance => $_getSZ(3);
  @$pb.TagNumber(4)
  set resolutionGuidance($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasResolutionGuidance() => $_has(3);
  @$pb.TagNumber(4)
  void clearResolutionGuidance() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get connectUrl => $_getSZ(4);
  @$pb.TagNumber(5)
  set connectUrl($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasConnectUrl() => $_has(4);
  @$pb.TagNumber(5)
  void clearConnectUrl() => $_clearField(5);
}

/// RecipeTemplate represents a reusable workflow template in the marketplace.
class RecipeTemplate extends $pb.GeneratedMessage {
  factory RecipeTemplate({
    $core.String? recipeId,
    $core.String? workspaceId,
    $core.String? authorWorkspaceId,
    $core.String? title,
    $core.String? description,
    $core.String? category,
    $core.String? activepiecesTemplateId,
    TemplateKind? templateKind,
    $core.int? templateVersion,
    $core.String? templatePayloadJson,
    $core.Iterable<RecipeParameter>? parameters,
    $core.Iterable<$core.String>? requiredCapabilities,
    $core.int? installCount,
    $core.double? ratingAvg,
    $core.int? reviewCount,
    $core.String? priceUsd,
    RecipeStatus? status,
    $1.Timestamp? createdAt,
    $1.Timestamp? updatedAt,
  }) {
    final result = RecipeTemplate._();
    if (recipeId != null) result.recipeId = recipeId;
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (authorWorkspaceId != null) result.authorWorkspaceId = authorWorkspaceId;
    if (title != null) result.title = title;
    if (description != null) result.description = description;
    if (category != null) result.category = category;
    if (activepiecesTemplateId != null)
      result.activepiecesTemplateId = activepiecesTemplateId;
    if (templateKind != null) result.templateKind = templateKind;
    if (templateVersion != null) result.templateVersion = templateVersion;
    if (templatePayloadJson != null)
      result.templatePayloadJson = templatePayloadJson;
    if (parameters != null) result.parameters.addAll(parameters);
    if (requiredCapabilities != null)
      result.requiredCapabilities.addAll(requiredCapabilities);
    if (installCount != null) result.installCount = installCount;
    if (ratingAvg != null) result.ratingAvg = ratingAvg;
    if (reviewCount != null) result.reviewCount = reviewCount;
    if (priceUsd != null) result.priceUsd = priceUsd;
    if (status != null) result.status = status;
    if (createdAt != null) result.createdAt = createdAt;
    if (updatedAt != null) result.updatedAt = updatedAt;
    return result;
  }

  RecipeTemplate._();

  factory RecipeTemplate.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RecipeTemplate()..mergeFromBuffer(data, registry);
  factory RecipeTemplate.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RecipeTemplate()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RecipeTemplate',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.automation.v1'),
      createEmptyInstance: RecipeTemplate.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'recipeId')
    ..aOS(2, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(3, _omitFieldNames ? '' : 'authorWorkspaceId')
    ..aOS(4, _omitFieldNames ? '' : 'title')
    ..aOS(5, _omitFieldNames ? '' : 'description')
    ..aOS(6, _omitFieldNames ? '' : 'category')
    ..aOS(7, _omitFieldNames ? '' : 'activepiecesTemplateId')
    ..aE<TemplateKind>(8, _omitFieldNames ? '' : 'templateKind',
        enumValues: TemplateKind.values)
    ..aI(9, _omitFieldNames ? '' : 'templateVersion')
    ..aOS(10, _omitFieldNames ? '' : 'templatePayloadJson')
    ..pPM<RecipeParameter>(11, _omitFieldNames ? '' : 'parameters',
        subBuilder: RecipeParameter.$_createMessage)
    ..pPS(12, _omitFieldNames ? '' : 'requiredCapabilities')
    ..aI(13, _omitFieldNames ? '' : 'installCount')
    ..aD(14, _omitFieldNames ? '' : 'ratingAvg', fieldType: $pb.PbFieldType.OF)
    ..aI(15, _omitFieldNames ? '' : 'reviewCount')
    ..aOS(16, _omitFieldNames ? '' : 'priceUsd')
    ..aE<RecipeStatus>(17, _omitFieldNames ? '' : 'status',
        enumValues: RecipeStatus.values)
    ..aOM<$1.Timestamp>(18, _omitFieldNames ? '' : 'createdAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..aOM<$1.Timestamp>(19, _omitFieldNames ? '' : 'updatedAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecipeTemplate clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecipeTemplate copyWith(void Function(RecipeTemplate) updates) =>
      super.copyWith((message) => updates(message as RecipeTemplate))
          as RecipeTemplate;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use RecipeTemplate() / RecipeTemplate.new instead')
  static RecipeTemplate create() => RecipeTemplate._();
  static $pb.GeneratedMessage $_createMessage() => RecipeTemplate._();
  @$core.override
  RecipeTemplate createEmptyInstance() => RecipeTemplate._();
  @$core.pragma('dart2js:noInline')
  static RecipeTemplate getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<RecipeTemplate>(
          RecipeTemplate.$_createMessage);
  static RecipeTemplate? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get recipeId => $_getSZ(0);
  @$pb.TagNumber(1)
  set recipeId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRecipeId() => $_has(0);
  @$pb.TagNumber(1)
  void clearRecipeId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get workspaceId => $_getSZ(1);
  @$pb.TagNumber(2)
  set workspaceId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasWorkspaceId() => $_has(1);
  @$pb.TagNumber(2)
  void clearWorkspaceId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get authorWorkspaceId => $_getSZ(2);
  @$pb.TagNumber(3)
  set authorWorkspaceId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasAuthorWorkspaceId() => $_has(2);
  @$pb.TagNumber(3)
  void clearAuthorWorkspaceId() => $_clearField(3);

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
  $core.String get category => $_getSZ(5);
  @$pb.TagNumber(6)
  set category($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasCategory() => $_has(5);
  @$pb.TagNumber(6)
  void clearCategory() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get activepiecesTemplateId => $_getSZ(6);
  @$pb.TagNumber(7)
  set activepiecesTemplateId($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasActivepiecesTemplateId() => $_has(6);
  @$pb.TagNumber(7)
  void clearActivepiecesTemplateId() => $_clearField(7);

  @$pb.TagNumber(8)
  TemplateKind get templateKind => $_getN(7);
  @$pb.TagNumber(8)
  set templateKind(TemplateKind value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasTemplateKind() => $_has(7);
  @$pb.TagNumber(8)
  void clearTemplateKind() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.int get templateVersion => $_getIZ(8);
  @$pb.TagNumber(9)
  set templateVersion($core.int value) => $_setSignedInt32(8, value);
  @$pb.TagNumber(9)
  $core.bool hasTemplateVersion() => $_has(8);
  @$pb.TagNumber(9)
  void clearTemplateVersion() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.String get templatePayloadJson => $_getSZ(9);
  @$pb.TagNumber(10)
  set templatePayloadJson($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasTemplatePayloadJson() => $_has(9);
  @$pb.TagNumber(10)
  void clearTemplatePayloadJson() => $_clearField(10);

  @$pb.TagNumber(11)
  $pb.PbList<RecipeParameter> get parameters => $_getList(10);

  @$pb.TagNumber(12)
  $pb.PbList<$core.String> get requiredCapabilities => $_getList(11);

  @$pb.TagNumber(13)
  $core.int get installCount => $_getIZ(12);
  @$pb.TagNumber(13)
  set installCount($core.int value) => $_setSignedInt32(12, value);
  @$pb.TagNumber(13)
  $core.bool hasInstallCount() => $_has(12);
  @$pb.TagNumber(13)
  void clearInstallCount() => $_clearField(13);

  @$pb.TagNumber(14)
  $core.double get ratingAvg => $_getN(13);
  @$pb.TagNumber(14)
  set ratingAvg($core.double value) => $_setFloat(13, value);
  @$pb.TagNumber(14)
  $core.bool hasRatingAvg() => $_has(13);
  @$pb.TagNumber(14)
  void clearRatingAvg() => $_clearField(14);

  @$pb.TagNumber(15)
  $core.int get reviewCount => $_getIZ(14);
  @$pb.TagNumber(15)
  set reviewCount($core.int value) => $_setSignedInt32(14, value);
  @$pb.TagNumber(15)
  $core.bool hasReviewCount() => $_has(14);
  @$pb.TagNumber(15)
  void clearReviewCount() => $_clearField(15);

  @$pb.TagNumber(16)
  $core.String get priceUsd => $_getSZ(15);
  @$pb.TagNumber(16)
  set priceUsd($core.String value) => $_setString(15, value);
  @$pb.TagNumber(16)
  $core.bool hasPriceUsd() => $_has(15);
  @$pb.TagNumber(16)
  void clearPriceUsd() => $_clearField(16);

  @$pb.TagNumber(17)
  RecipeStatus get status => $_getN(16);
  @$pb.TagNumber(17)
  set status(RecipeStatus value) => $_setField(17, value);
  @$pb.TagNumber(17)
  $core.bool hasStatus() => $_has(16);
  @$pb.TagNumber(17)
  void clearStatus() => $_clearField(17);

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

/// RecipeInstallation tracks an installed recipe instance in a destination workspace.
class RecipeInstallation extends $pb.GeneratedMessage {
  factory RecipeInstallation({
    $core.String? installationId,
    $core.String? workspaceId,
    $core.String? recipeId,
    $core.String? workflowId,
    $core.int? installedVersion,
    RecipeInstallationStatus? status,
    $core.String? parameterValuesJson,
    $core.String? installedBy,
    $1.Timestamp? createdAt,
    $1.Timestamp? updatedAt,
  }) {
    final result = RecipeInstallation._();
    if (installationId != null) result.installationId = installationId;
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (recipeId != null) result.recipeId = recipeId;
    if (workflowId != null) result.workflowId = workflowId;
    if (installedVersion != null) result.installedVersion = installedVersion;
    if (status != null) result.status = status;
    if (parameterValuesJson != null)
      result.parameterValuesJson = parameterValuesJson;
    if (installedBy != null) result.installedBy = installedBy;
    if (createdAt != null) result.createdAt = createdAt;
    if (updatedAt != null) result.updatedAt = updatedAt;
    return result;
  }

  RecipeInstallation._();

  factory RecipeInstallation.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RecipeInstallation()..mergeFromBuffer(data, registry);
  factory RecipeInstallation.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RecipeInstallation()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RecipeInstallation',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.automation.v1'),
      createEmptyInstance: RecipeInstallation.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'installationId')
    ..aOS(2, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(3, _omitFieldNames ? '' : 'recipeId')
    ..aOS(4, _omitFieldNames ? '' : 'workflowId')
    ..aI(5, _omitFieldNames ? '' : 'installedVersion')
    ..aE<RecipeInstallationStatus>(6, _omitFieldNames ? '' : 'status',
        enumValues: RecipeInstallationStatus.values)
    ..aOS(7, _omitFieldNames ? '' : 'parameterValuesJson')
    ..aOS(8, _omitFieldNames ? '' : 'installedBy')
    ..aOM<$1.Timestamp>(9, _omitFieldNames ? '' : 'createdAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..aOM<$1.Timestamp>(10, _omitFieldNames ? '' : 'updatedAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecipeInstallation clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecipeInstallation copyWith(void Function(RecipeInstallation) updates) =>
      super.copyWith((message) => updates(message as RecipeInstallation))
          as RecipeInstallation;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use RecipeInstallation() / RecipeInstallation.new instead')
  static RecipeInstallation create() => RecipeInstallation._();
  static $pb.GeneratedMessage $_createMessage() => RecipeInstallation._();
  @$core.override
  RecipeInstallation createEmptyInstance() => RecipeInstallation._();
  @$core.pragma('dart2js:noInline')
  static RecipeInstallation getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RecipeInstallation>(
          RecipeInstallation.$_createMessage);
  static RecipeInstallation? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get installationId => $_getSZ(0);
  @$pb.TagNumber(1)
  set installationId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasInstallationId() => $_has(0);
  @$pb.TagNumber(1)
  void clearInstallationId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get workspaceId => $_getSZ(1);
  @$pb.TagNumber(2)
  set workspaceId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasWorkspaceId() => $_has(1);
  @$pb.TagNumber(2)
  void clearWorkspaceId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get recipeId => $_getSZ(2);
  @$pb.TagNumber(3)
  set recipeId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasRecipeId() => $_has(2);
  @$pb.TagNumber(3)
  void clearRecipeId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get workflowId => $_getSZ(3);
  @$pb.TagNumber(4)
  set workflowId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasWorkflowId() => $_has(3);
  @$pb.TagNumber(4)
  void clearWorkflowId() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get installedVersion => $_getIZ(4);
  @$pb.TagNumber(5)
  set installedVersion($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasInstalledVersion() => $_has(4);
  @$pb.TagNumber(5)
  void clearInstalledVersion() => $_clearField(5);

  @$pb.TagNumber(6)
  RecipeInstallationStatus get status => $_getN(5);
  @$pb.TagNumber(6)
  set status(RecipeInstallationStatus value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasStatus() => $_has(5);
  @$pb.TagNumber(6)
  void clearStatus() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get parameterValuesJson => $_getSZ(6);
  @$pb.TagNumber(7)
  set parameterValuesJson($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasParameterValuesJson() => $_has(6);
  @$pb.TagNumber(7)
  void clearParameterValuesJson() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get installedBy => $_getSZ(7);
  @$pb.TagNumber(8)
  set installedBy($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasInstalledBy() => $_has(7);
  @$pb.TagNumber(8)
  void clearInstalledBy() => $_clearField(8);

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

/// RecipeReview represents a creator/user review and rating.
class RecipeReview extends $pb.GeneratedMessage {
  factory RecipeReview({
    $core.String? reviewId,
    $core.String? recipeId,
    $core.String? workspaceId,
    $core.String? userId,
    $core.int? rating,
    $core.String? reviewText,
    $core.String? authorName,
    $1.Timestamp? createdAt,
    $1.Timestamp? updatedAt,
  }) {
    final result = RecipeReview._();
    if (reviewId != null) result.reviewId = reviewId;
    if (recipeId != null) result.recipeId = recipeId;
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (userId != null) result.userId = userId;
    if (rating != null) result.rating = rating;
    if (reviewText != null) result.reviewText = reviewText;
    if (authorName != null) result.authorName = authorName;
    if (createdAt != null) result.createdAt = createdAt;
    if (updatedAt != null) result.updatedAt = updatedAt;
    return result;
  }

  RecipeReview._();

  factory RecipeReview.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RecipeReview()..mergeFromBuffer(data, registry);
  factory RecipeReview.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RecipeReview()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RecipeReview',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.automation.v1'),
      createEmptyInstance: RecipeReview.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'reviewId')
    ..aOS(2, _omitFieldNames ? '' : 'recipeId')
    ..aOS(3, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(4, _omitFieldNames ? '' : 'userId')
    ..aI(5, _omitFieldNames ? '' : 'rating')
    ..aOS(6, _omitFieldNames ? '' : 'reviewText')
    ..aOS(7, _omitFieldNames ? '' : 'authorName')
    ..aOM<$1.Timestamp>(8, _omitFieldNames ? '' : 'createdAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..aOM<$1.Timestamp>(9, _omitFieldNames ? '' : 'updatedAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecipeReview clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecipeReview copyWith(void Function(RecipeReview) updates) =>
      super.copyWith((message) => updates(message as RecipeReview))
          as RecipeReview;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use RecipeReview() / RecipeReview.new instead')
  static RecipeReview create() => RecipeReview._();
  static $pb.GeneratedMessage $_createMessage() => RecipeReview._();
  @$core.override
  RecipeReview createEmptyInstance() => RecipeReview._();
  @$core.pragma('dart2js:noInline')
  static RecipeReview getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<RecipeReview>(
          RecipeReview.$_createMessage);
  static RecipeReview? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get reviewId => $_getSZ(0);
  @$pb.TagNumber(1)
  set reviewId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasReviewId() => $_has(0);
  @$pb.TagNumber(1)
  void clearReviewId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get recipeId => $_getSZ(1);
  @$pb.TagNumber(2)
  set recipeId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasRecipeId() => $_has(1);
  @$pb.TagNumber(2)
  void clearRecipeId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get workspaceId => $_getSZ(2);
  @$pb.TagNumber(3)
  set workspaceId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasWorkspaceId() => $_has(2);
  @$pb.TagNumber(3)
  void clearWorkspaceId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get userId => $_getSZ(3);
  @$pb.TagNumber(4)
  set userId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasUserId() => $_has(3);
  @$pb.TagNumber(4)
  void clearUserId() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get rating => $_getIZ(4);
  @$pb.TagNumber(5)
  set rating($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasRating() => $_has(4);
  @$pb.TagNumber(5)
  void clearRating() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get reviewText => $_getSZ(5);
  @$pb.TagNumber(6)
  set reviewText($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasReviewText() => $_has(5);
  @$pb.TagNumber(6)
  void clearReviewText() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get authorName => $_getSZ(6);
  @$pb.TagNumber(7)
  set authorName($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasAuthorName() => $_has(6);
  @$pb.TagNumber(7)
  void clearAuthorName() => $_clearField(7);

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
  $1.Timestamp get updatedAt => $_getN(8);
  @$pb.TagNumber(9)
  set updatedAt($1.Timestamp value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasUpdatedAt() => $_has(8);
  @$pb.TagNumber(9)
  void clearUpdatedAt() => $_clearField(9);
  @$pb.TagNumber(9)
  $1.Timestamp ensureUpdatedAt() => $_ensure(8);
}

/// RecipeSubmission represents a recipe submitted for marketplace governance review.
class RecipeSubmission extends $pb.GeneratedMessage {
  factory RecipeSubmission({
    $core.String? submissionId,
    $core.String? recipeId,
    $core.String? authorWorkspaceId,
    $core.int? submittedVersion,
    SubmissionStatus? status,
    $core.String? reviewNotes,
    $core.String? reviewedBy,
    $1.Timestamp? reviewedAt,
    $core.String? takedownReason,
    $core.String? takedownTicketRef,
    $1.Timestamp? createdAt,
    $1.Timestamp? updatedAt,
  }) {
    final result = RecipeSubmission._();
    if (submissionId != null) result.submissionId = submissionId;
    if (recipeId != null) result.recipeId = recipeId;
    if (authorWorkspaceId != null) result.authorWorkspaceId = authorWorkspaceId;
    if (submittedVersion != null) result.submittedVersion = submittedVersion;
    if (status != null) result.status = status;
    if (reviewNotes != null) result.reviewNotes = reviewNotes;
    if (reviewedBy != null) result.reviewedBy = reviewedBy;
    if (reviewedAt != null) result.reviewedAt = reviewedAt;
    if (takedownReason != null) result.takedownReason = takedownReason;
    if (takedownTicketRef != null) result.takedownTicketRef = takedownTicketRef;
    if (createdAt != null) result.createdAt = createdAt;
    if (updatedAt != null) result.updatedAt = updatedAt;
    return result;
  }

  RecipeSubmission._();

  factory RecipeSubmission.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RecipeSubmission()..mergeFromBuffer(data, registry);
  factory RecipeSubmission.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RecipeSubmission()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RecipeSubmission',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.automation.v1'),
      createEmptyInstance: RecipeSubmission.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'submissionId')
    ..aOS(2, _omitFieldNames ? '' : 'recipeId')
    ..aOS(3, _omitFieldNames ? '' : 'authorWorkspaceId')
    ..aI(4, _omitFieldNames ? '' : 'submittedVersion')
    ..aE<SubmissionStatus>(5, _omitFieldNames ? '' : 'status',
        enumValues: SubmissionStatus.values)
    ..aOS(6, _omitFieldNames ? '' : 'reviewNotes')
    ..aOS(7, _omitFieldNames ? '' : 'reviewedBy')
    ..aOM<$1.Timestamp>(8, _omitFieldNames ? '' : 'reviewedAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..aOS(9, _omitFieldNames ? '' : 'takedownReason')
    ..aOS(10, _omitFieldNames ? '' : 'takedownTicketRef')
    ..aOM<$1.Timestamp>(11, _omitFieldNames ? '' : 'createdAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..aOM<$1.Timestamp>(12, _omitFieldNames ? '' : 'updatedAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecipeSubmission clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecipeSubmission copyWith(void Function(RecipeSubmission) updates) =>
      super.copyWith((message) => updates(message as RecipeSubmission))
          as RecipeSubmission;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use RecipeSubmission() / RecipeSubmission.new instead')
  static RecipeSubmission create() => RecipeSubmission._();
  static $pb.GeneratedMessage $_createMessage() => RecipeSubmission._();
  @$core.override
  RecipeSubmission createEmptyInstance() => RecipeSubmission._();
  @$core.pragma('dart2js:noInline')
  static RecipeSubmission getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<RecipeSubmission>(
          RecipeSubmission.$_createMessage);
  static RecipeSubmission? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get submissionId => $_getSZ(0);
  @$pb.TagNumber(1)
  set submissionId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSubmissionId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSubmissionId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get recipeId => $_getSZ(1);
  @$pb.TagNumber(2)
  set recipeId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasRecipeId() => $_has(1);
  @$pb.TagNumber(2)
  void clearRecipeId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get authorWorkspaceId => $_getSZ(2);
  @$pb.TagNumber(3)
  set authorWorkspaceId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasAuthorWorkspaceId() => $_has(2);
  @$pb.TagNumber(3)
  void clearAuthorWorkspaceId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get submittedVersion => $_getIZ(3);
  @$pb.TagNumber(4)
  set submittedVersion($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasSubmittedVersion() => $_has(3);
  @$pb.TagNumber(4)
  void clearSubmittedVersion() => $_clearField(4);

  @$pb.TagNumber(5)
  SubmissionStatus get status => $_getN(4);
  @$pb.TagNumber(5)
  set status(SubmissionStatus value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasStatus() => $_has(4);
  @$pb.TagNumber(5)
  void clearStatus() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get reviewNotes => $_getSZ(5);
  @$pb.TagNumber(6)
  set reviewNotes($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasReviewNotes() => $_has(5);
  @$pb.TagNumber(6)
  void clearReviewNotes() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get reviewedBy => $_getSZ(6);
  @$pb.TagNumber(7)
  set reviewedBy($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasReviewedBy() => $_has(6);
  @$pb.TagNumber(7)
  void clearReviewedBy() => $_clearField(7);

  @$pb.TagNumber(8)
  $1.Timestamp get reviewedAt => $_getN(7);
  @$pb.TagNumber(8)
  set reviewedAt($1.Timestamp value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasReviewedAt() => $_has(7);
  @$pb.TagNumber(8)
  void clearReviewedAt() => $_clearField(8);
  @$pb.TagNumber(8)
  $1.Timestamp ensureReviewedAt() => $_ensure(7);

  @$pb.TagNumber(9)
  $core.String get takedownReason => $_getSZ(8);
  @$pb.TagNumber(9)
  set takedownReason($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasTakedownReason() => $_has(8);
  @$pb.TagNumber(9)
  void clearTakedownReason() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.String get takedownTicketRef => $_getSZ(9);
  @$pb.TagNumber(10)
  set takedownTicketRef($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasTakedownTicketRef() => $_has(9);
  @$pb.TagNumber(10)
  void clearTakedownTicketRef() => $_clearField(10);

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

  @$pb.TagNumber(12)
  $1.Timestamp get updatedAt => $_getN(11);
  @$pb.TagNumber(12)
  set updatedAt($1.Timestamp value) => $_setField(12, value);
  @$pb.TagNumber(12)
  $core.bool hasUpdatedAt() => $_has(11);
  @$pb.TagNumber(12)
  void clearUpdatedAt() => $_clearField(12);
  @$pb.TagNumber(12)
  $1.Timestamp ensureUpdatedAt() => $_ensure(11);
}

/// RecipeRevenueShare represents a 70/30 creator/platform split for paid recipes.
class RecipeRevenueShare extends $pb.GeneratedMessage {
  factory RecipeRevenueShare({
    $core.String? revenueShareId,
    $core.String? recipeId,
    $core.String? authorWorkspaceId,
    $core.String? purchaserWorkspaceId,
    $core.String? grossAmount,
    $core.String? creatorAmount,
    $core.String? platformAmount,
    $core.String? currency,
    RevenueShareStatus? status,
    $1.Timestamp? refundEligibleUntil,
    $1.Timestamp? createdAt,
    $1.Timestamp? updatedAt,
  }) {
    final result = RecipeRevenueShare._();
    if (revenueShareId != null) result.revenueShareId = revenueShareId;
    if (recipeId != null) result.recipeId = recipeId;
    if (authorWorkspaceId != null) result.authorWorkspaceId = authorWorkspaceId;
    if (purchaserWorkspaceId != null)
      result.purchaserWorkspaceId = purchaserWorkspaceId;
    if (grossAmount != null) result.grossAmount = grossAmount;
    if (creatorAmount != null) result.creatorAmount = creatorAmount;
    if (platformAmount != null) result.platformAmount = platformAmount;
    if (currency != null) result.currency = currency;
    if (status != null) result.status = status;
    if (refundEligibleUntil != null)
      result.refundEligibleUntil = refundEligibleUntil;
    if (createdAt != null) result.createdAt = createdAt;
    if (updatedAt != null) result.updatedAt = updatedAt;
    return result;
  }

  RecipeRevenueShare._();

  factory RecipeRevenueShare.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RecipeRevenueShare()..mergeFromBuffer(data, registry);
  factory RecipeRevenueShare.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RecipeRevenueShare()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RecipeRevenueShare',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.automation.v1'),
      createEmptyInstance: RecipeRevenueShare.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'revenueShareId')
    ..aOS(2, _omitFieldNames ? '' : 'recipeId')
    ..aOS(3, _omitFieldNames ? '' : 'authorWorkspaceId')
    ..aOS(4, _omitFieldNames ? '' : 'purchaserWorkspaceId')
    ..aOS(5, _omitFieldNames ? '' : 'grossAmount')
    ..aOS(6, _omitFieldNames ? '' : 'creatorAmount')
    ..aOS(7, _omitFieldNames ? '' : 'platformAmount')
    ..aOS(8, _omitFieldNames ? '' : 'currency')
    ..aE<RevenueShareStatus>(9, _omitFieldNames ? '' : 'status',
        enumValues: RevenueShareStatus.values)
    ..aOM<$1.Timestamp>(10, _omitFieldNames ? '' : 'refundEligibleUntil',
        subBuilder: $1.Timestamp.$_createMessage)
    ..aOM<$1.Timestamp>(11, _omitFieldNames ? '' : 'createdAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..aOM<$1.Timestamp>(12, _omitFieldNames ? '' : 'updatedAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecipeRevenueShare clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecipeRevenueShare copyWith(void Function(RecipeRevenueShare) updates) =>
      super.copyWith((message) => updates(message as RecipeRevenueShare))
          as RecipeRevenueShare;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use RecipeRevenueShare() / RecipeRevenueShare.new instead')
  static RecipeRevenueShare create() => RecipeRevenueShare._();
  static $pb.GeneratedMessage $_createMessage() => RecipeRevenueShare._();
  @$core.override
  RecipeRevenueShare createEmptyInstance() => RecipeRevenueShare._();
  @$core.pragma('dart2js:noInline')
  static RecipeRevenueShare getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RecipeRevenueShare>(
          RecipeRevenueShare.$_createMessage);
  static RecipeRevenueShare? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get revenueShareId => $_getSZ(0);
  @$pb.TagNumber(1)
  set revenueShareId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRevenueShareId() => $_has(0);
  @$pb.TagNumber(1)
  void clearRevenueShareId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get recipeId => $_getSZ(1);
  @$pb.TagNumber(2)
  set recipeId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasRecipeId() => $_has(1);
  @$pb.TagNumber(2)
  void clearRecipeId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get authorWorkspaceId => $_getSZ(2);
  @$pb.TagNumber(3)
  set authorWorkspaceId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasAuthorWorkspaceId() => $_has(2);
  @$pb.TagNumber(3)
  void clearAuthorWorkspaceId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get purchaserWorkspaceId => $_getSZ(3);
  @$pb.TagNumber(4)
  set purchaserWorkspaceId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasPurchaserWorkspaceId() => $_has(3);
  @$pb.TagNumber(4)
  void clearPurchaserWorkspaceId() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get grossAmount => $_getSZ(4);
  @$pb.TagNumber(5)
  set grossAmount($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasGrossAmount() => $_has(4);
  @$pb.TagNumber(5)
  void clearGrossAmount() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get creatorAmount => $_getSZ(5);
  @$pb.TagNumber(6)
  set creatorAmount($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasCreatorAmount() => $_has(5);
  @$pb.TagNumber(6)
  void clearCreatorAmount() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get platformAmount => $_getSZ(6);
  @$pb.TagNumber(7)
  set platformAmount($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasPlatformAmount() => $_has(6);
  @$pb.TagNumber(7)
  void clearPlatformAmount() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get currency => $_getSZ(7);
  @$pb.TagNumber(8)
  set currency($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasCurrency() => $_has(7);
  @$pb.TagNumber(8)
  void clearCurrency() => $_clearField(8);

  @$pb.TagNumber(9)
  RevenueShareStatus get status => $_getN(8);
  @$pb.TagNumber(9)
  set status(RevenueShareStatus value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasStatus() => $_has(8);
  @$pb.TagNumber(9)
  void clearStatus() => $_clearField(9);

  @$pb.TagNumber(10)
  $1.Timestamp get refundEligibleUntil => $_getN(9);
  @$pb.TagNumber(10)
  set refundEligibleUntil($1.Timestamp value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasRefundEligibleUntil() => $_has(9);
  @$pb.TagNumber(10)
  void clearRefundEligibleUntil() => $_clearField(10);
  @$pb.TagNumber(10)
  $1.Timestamp ensureRefundEligibleUntil() => $_ensure(9);

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

  @$pb.TagNumber(12)
  $1.Timestamp get updatedAt => $_getN(11);
  @$pb.TagNumber(12)
  set updatedAt($1.Timestamp value) => $_setField(12, value);
  @$pb.TagNumber(12)
  $core.bool hasUpdatedAt() => $_has(11);
  @$pb.TagNumber(12)
  void clearUpdatedAt() => $_clearField(12);
  @$pb.TagNumber(12)
  $1.Timestamp ensureUpdatedAt() => $_ensure(11);
}

class RecipeServiceInstallRequest extends $pb.GeneratedMessage {
  factory RecipeServiceInstallRequest({
    $core.String? idempotencyKey,
    $core.String? workspaceId,
    $core.String? recipeId,
    $core.String? parameterValuesJson,
    $core.String? titleOverride,
  }) {
    final result = RecipeServiceInstallRequest._();
    if (idempotencyKey != null) result.idempotencyKey = idempotencyKey;
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (recipeId != null) result.recipeId = recipeId;
    if (parameterValuesJson != null)
      result.parameterValuesJson = parameterValuesJson;
    if (titleOverride != null) result.titleOverride = titleOverride;
    return result;
  }

  RecipeServiceInstallRequest._();

  factory RecipeServiceInstallRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RecipeServiceInstallRequest()..mergeFromBuffer(data, registry);
  factory RecipeServiceInstallRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RecipeServiceInstallRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RecipeServiceInstallRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.automation.v1'),
      createEmptyInstance: RecipeServiceInstallRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'idempotencyKey')
    ..aOS(2, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(3, _omitFieldNames ? '' : 'recipeId')
    ..aOS(4, _omitFieldNames ? '' : 'parameterValuesJson')
    ..aOS(5, _omitFieldNames ? '' : 'titleOverride')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecipeServiceInstallRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecipeServiceInstallRequest copyWith(
          void Function(RecipeServiceInstallRequest) updates) =>
      super.copyWith(
              (message) => updates(message as RecipeServiceInstallRequest))
          as RecipeServiceInstallRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use RecipeServiceInstallRequest() / RecipeServiceInstallRequest.new instead')
  static RecipeServiceInstallRequest create() =>
      RecipeServiceInstallRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      RecipeServiceInstallRequest._();
  @$core.override
  RecipeServiceInstallRequest createEmptyInstance() =>
      RecipeServiceInstallRequest._();
  @$core.pragma('dart2js:noInline')
  static RecipeServiceInstallRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RecipeServiceInstallRequest>(
          RecipeServiceInstallRequest.$_createMessage);
  static RecipeServiceInstallRequest? _defaultInstance;

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
  $core.String get recipeId => $_getSZ(2);
  @$pb.TagNumber(3)
  set recipeId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasRecipeId() => $_has(2);
  @$pb.TagNumber(3)
  void clearRecipeId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get parameterValuesJson => $_getSZ(3);
  @$pb.TagNumber(4)
  set parameterValuesJson($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasParameterValuesJson() => $_has(3);
  @$pb.TagNumber(4)
  void clearParameterValuesJson() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get titleOverride => $_getSZ(4);
  @$pb.TagNumber(5)
  set titleOverride($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasTitleOverride() => $_has(4);
  @$pb.TagNumber(5)
  void clearTitleOverride() => $_clearField(5);
}

class RecipeServiceInstallResponse extends $pb.GeneratedMessage {
  factory RecipeServiceInstallResponse({
    $core.bool? success,
    RecipeInstallation? installation,
    $2.Workflow? createdWorkflow,
    $core.Iterable<MissingCapabilityExplanation>? missingCapabilities,
  }) {
    final result = RecipeServiceInstallResponse._();
    if (success != null) result.success = success;
    if (installation != null) result.installation = installation;
    if (createdWorkflow != null) result.createdWorkflow = createdWorkflow;
    if (missingCapabilities != null)
      result.missingCapabilities.addAll(missingCapabilities);
    return result;
  }

  RecipeServiceInstallResponse._();

  factory RecipeServiceInstallResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RecipeServiceInstallResponse()..mergeFromBuffer(data, registry);
  factory RecipeServiceInstallResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RecipeServiceInstallResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RecipeServiceInstallResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.automation.v1'),
      createEmptyInstance: RecipeServiceInstallResponse.$_createMessage)
    ..aOB(1, _omitFieldNames ? '' : 'success')
    ..aOM<RecipeInstallation>(2, _omitFieldNames ? '' : 'installation',
        subBuilder: RecipeInstallation.$_createMessage)
    ..aOM<$2.Workflow>(3, _omitFieldNames ? '' : 'createdWorkflow',
        subBuilder: $2.Workflow.$_createMessage)
    ..pPM<MissingCapabilityExplanation>(
        4, _omitFieldNames ? '' : 'missingCapabilities',
        subBuilder: MissingCapabilityExplanation.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecipeServiceInstallResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecipeServiceInstallResponse copyWith(
          void Function(RecipeServiceInstallResponse) updates) =>
      super.copyWith(
              (message) => updates(message as RecipeServiceInstallResponse))
          as RecipeServiceInstallResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use RecipeServiceInstallResponse() / RecipeServiceInstallResponse.new instead')
  static RecipeServiceInstallResponse create() =>
      RecipeServiceInstallResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      RecipeServiceInstallResponse._();
  @$core.override
  RecipeServiceInstallResponse createEmptyInstance() =>
      RecipeServiceInstallResponse._();
  @$core.pragma('dart2js:noInline')
  static RecipeServiceInstallResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RecipeServiceInstallResponse>(
          RecipeServiceInstallResponse.$_createMessage);
  static RecipeServiceInstallResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get success => $_getBF(0);
  @$pb.TagNumber(1)
  set success($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSuccess() => $_has(0);
  @$pb.TagNumber(1)
  void clearSuccess() => $_clearField(1);

  @$pb.TagNumber(2)
  RecipeInstallation get installation => $_getN(1);
  @$pb.TagNumber(2)
  set installation(RecipeInstallation value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasInstallation() => $_has(1);
  @$pb.TagNumber(2)
  void clearInstallation() => $_clearField(2);
  @$pb.TagNumber(2)
  RecipeInstallation ensureInstallation() => $_ensure(1);

  @$pb.TagNumber(3)
  $2.Workflow get createdWorkflow => $_getN(2);
  @$pb.TagNumber(3)
  set createdWorkflow($2.Workflow value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasCreatedWorkflow() => $_has(2);
  @$pb.TagNumber(3)
  void clearCreatedWorkflow() => $_clearField(3);
  @$pb.TagNumber(3)
  $2.Workflow ensureCreatedWorkflow() => $_ensure(2);

  @$pb.TagNumber(4)
  $pb.PbList<MissingCapabilityExplanation> get missingCapabilities =>
      $_getList(3);
}

class RecipeServiceUninstallRequest extends $pb.GeneratedMessage {
  factory RecipeServiceUninstallRequest({
    $core.String? idempotencyKey,
    $core.String? workspaceId,
    $core.String? installationId,
    $core.bool? deleteWorkflow,
  }) {
    final result = RecipeServiceUninstallRequest._();
    if (idempotencyKey != null) result.idempotencyKey = idempotencyKey;
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (installationId != null) result.installationId = installationId;
    if (deleteWorkflow != null) result.deleteWorkflow = deleteWorkflow;
    return result;
  }

  RecipeServiceUninstallRequest._();

  factory RecipeServiceUninstallRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RecipeServiceUninstallRequest()..mergeFromBuffer(data, registry);
  factory RecipeServiceUninstallRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RecipeServiceUninstallRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RecipeServiceUninstallRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.automation.v1'),
      createEmptyInstance: RecipeServiceUninstallRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'idempotencyKey')
    ..aOS(2, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(3, _omitFieldNames ? '' : 'installationId')
    ..aOB(4, _omitFieldNames ? '' : 'deleteWorkflow')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecipeServiceUninstallRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecipeServiceUninstallRequest copyWith(
          void Function(RecipeServiceUninstallRequest) updates) =>
      super.copyWith(
              (message) => updates(message as RecipeServiceUninstallRequest))
          as RecipeServiceUninstallRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use RecipeServiceUninstallRequest() / RecipeServiceUninstallRequest.new instead')
  static RecipeServiceUninstallRequest create() =>
      RecipeServiceUninstallRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      RecipeServiceUninstallRequest._();
  @$core.override
  RecipeServiceUninstallRequest createEmptyInstance() =>
      RecipeServiceUninstallRequest._();
  @$core.pragma('dart2js:noInline')
  static RecipeServiceUninstallRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RecipeServiceUninstallRequest>(
          RecipeServiceUninstallRequest.$_createMessage);
  static RecipeServiceUninstallRequest? _defaultInstance;

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
  $core.String get installationId => $_getSZ(2);
  @$pb.TagNumber(3)
  set installationId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasInstallationId() => $_has(2);
  @$pb.TagNumber(3)
  void clearInstallationId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.bool get deleteWorkflow => $_getBF(3);
  @$pb.TagNumber(4)
  set deleteWorkflow($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(4)
  $core.bool hasDeleteWorkflow() => $_has(3);
  @$pb.TagNumber(4)
  void clearDeleteWorkflow() => $_clearField(4);
}

class RecipeServiceUninstallResponse extends $pb.GeneratedMessage {
  factory RecipeServiceUninstallResponse({
    $core.bool? success,
  }) {
    final result = RecipeServiceUninstallResponse._();
    if (success != null) result.success = success;
    return result;
  }

  RecipeServiceUninstallResponse._();

  factory RecipeServiceUninstallResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RecipeServiceUninstallResponse()..mergeFromBuffer(data, registry);
  factory RecipeServiceUninstallResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RecipeServiceUninstallResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RecipeServiceUninstallResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.automation.v1'),
      createEmptyInstance: RecipeServiceUninstallResponse.$_createMessage)
    ..aOB(1, _omitFieldNames ? '' : 'success')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecipeServiceUninstallResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecipeServiceUninstallResponse copyWith(
          void Function(RecipeServiceUninstallResponse) updates) =>
      super.copyWith(
              (message) => updates(message as RecipeServiceUninstallResponse))
          as RecipeServiceUninstallResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use RecipeServiceUninstallResponse() / RecipeServiceUninstallResponse.new instead')
  static RecipeServiceUninstallResponse create() =>
      RecipeServiceUninstallResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      RecipeServiceUninstallResponse._();
  @$core.override
  RecipeServiceUninstallResponse createEmptyInstance() =>
      RecipeServiceUninstallResponse._();
  @$core.pragma('dart2js:noInline')
  static RecipeServiceUninstallResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RecipeServiceUninstallResponse>(
          RecipeServiceUninstallResponse.$_createMessage);
  static RecipeServiceUninstallResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get success => $_getBF(0);
  @$pb.TagNumber(1)
  set success($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSuccess() => $_has(0);
  @$pb.TagNumber(1)
  void clearSuccess() => $_clearField(1);
}

class RecipeServiceListRequest extends $pb.GeneratedMessage {
  factory RecipeServiceListRequest({
    $core.String? workspaceId,
    $core.String? category,
    $core.String? statusFilter,
    $core.bool? includeSystem,
    $core.int? pageSize,
    $core.String? pageToken,
  }) {
    final result = RecipeServiceListRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (category != null) result.category = category;
    if (statusFilter != null) result.statusFilter = statusFilter;
    if (includeSystem != null) result.includeSystem = includeSystem;
    if (pageSize != null) result.pageSize = pageSize;
    if (pageToken != null) result.pageToken = pageToken;
    return result;
  }

  RecipeServiceListRequest._();

  factory RecipeServiceListRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RecipeServiceListRequest()..mergeFromBuffer(data, registry);
  factory RecipeServiceListRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RecipeServiceListRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RecipeServiceListRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.automation.v1'),
      createEmptyInstance: RecipeServiceListRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'category')
    ..aOS(3, _omitFieldNames ? '' : 'statusFilter')
    ..aOB(4, _omitFieldNames ? '' : 'includeSystem')
    ..aI(5, _omitFieldNames ? '' : 'pageSize')
    ..aOS(6, _omitFieldNames ? '' : 'pageToken')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecipeServiceListRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecipeServiceListRequest copyWith(
          void Function(RecipeServiceListRequest) updates) =>
      super.copyWith((message) => updates(message as RecipeServiceListRequest))
          as RecipeServiceListRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use RecipeServiceListRequest() / RecipeServiceListRequest.new instead')
  static RecipeServiceListRequest create() => RecipeServiceListRequest._();
  static $pb.GeneratedMessage $_createMessage() => RecipeServiceListRequest._();
  @$core.override
  RecipeServiceListRequest createEmptyInstance() =>
      RecipeServiceListRequest._();
  @$core.pragma('dart2js:noInline')
  static RecipeServiceListRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RecipeServiceListRequest>(
          RecipeServiceListRequest.$_createMessage);
  static RecipeServiceListRequest? _defaultInstance;

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

  @$pb.TagNumber(3)
  $core.String get statusFilter => $_getSZ(2);
  @$pb.TagNumber(3)
  set statusFilter($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasStatusFilter() => $_has(2);
  @$pb.TagNumber(3)
  void clearStatusFilter() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.bool get includeSystem => $_getBF(3);
  @$pb.TagNumber(4)
  set includeSystem($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(4)
  $core.bool hasIncludeSystem() => $_has(3);
  @$pb.TagNumber(4)
  void clearIncludeSystem() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get pageSize => $_getIZ(4);
  @$pb.TagNumber(5)
  set pageSize($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasPageSize() => $_has(4);
  @$pb.TagNumber(5)
  void clearPageSize() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get pageToken => $_getSZ(5);
  @$pb.TagNumber(6)
  set pageToken($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasPageToken() => $_has(5);
  @$pb.TagNumber(6)
  void clearPageToken() => $_clearField(6);
}

class RecipeServiceListResponse extends $pb.GeneratedMessage {
  factory RecipeServiceListResponse({
    $core.Iterable<RecipeTemplate>? recipes,
    $core.Iterable<RecipeInstallation>? installations,
    $core.String? nextPageToken,
    $core.int? totalCount,
  }) {
    final result = RecipeServiceListResponse._();
    if (recipes != null) result.recipes.addAll(recipes);
    if (installations != null) result.installations.addAll(installations);
    if (nextPageToken != null) result.nextPageToken = nextPageToken;
    if (totalCount != null) result.totalCount = totalCount;
    return result;
  }

  RecipeServiceListResponse._();

  factory RecipeServiceListResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RecipeServiceListResponse()..mergeFromBuffer(data, registry);
  factory RecipeServiceListResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RecipeServiceListResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RecipeServiceListResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.automation.v1'),
      createEmptyInstance: RecipeServiceListResponse.$_createMessage)
    ..pPM<RecipeTemplate>(1, _omitFieldNames ? '' : 'recipes',
        subBuilder: RecipeTemplate.$_createMessage)
    ..pPM<RecipeInstallation>(2, _omitFieldNames ? '' : 'installations',
        subBuilder: RecipeInstallation.$_createMessage)
    ..aOS(3, _omitFieldNames ? '' : 'nextPageToken')
    ..aI(4, _omitFieldNames ? '' : 'totalCount')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecipeServiceListResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecipeServiceListResponse copyWith(
          void Function(RecipeServiceListResponse) updates) =>
      super.copyWith((message) => updates(message as RecipeServiceListResponse))
          as RecipeServiceListResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use RecipeServiceListResponse() / RecipeServiceListResponse.new instead')
  static RecipeServiceListResponse create() => RecipeServiceListResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      RecipeServiceListResponse._();
  @$core.override
  RecipeServiceListResponse createEmptyInstance() =>
      RecipeServiceListResponse._();
  @$core.pragma('dart2js:noInline')
  static RecipeServiceListResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RecipeServiceListResponse>(
          RecipeServiceListResponse.$_createMessage);
  static RecipeServiceListResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<RecipeTemplate> get recipes => $_getList(0);

  @$pb.TagNumber(2)
  $pb.PbList<RecipeInstallation> get installations => $_getList(1);

  @$pb.TagNumber(3)
  $core.String get nextPageToken => $_getSZ(2);
  @$pb.TagNumber(3)
  set nextPageToken($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasNextPageToken() => $_has(2);
  @$pb.TagNumber(3)
  void clearNextPageToken() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get totalCount => $_getIZ(3);
  @$pb.TagNumber(4)
  set totalCount($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasTotalCount() => $_has(3);
  @$pb.TagNumber(4)
  void clearTotalCount() => $_clearField(4);
}

class RecipeServiceGetRequest extends $pb.GeneratedMessage {
  factory RecipeServiceGetRequest({
    $core.String? workspaceId,
    $core.String? recipeId,
  }) {
    final result = RecipeServiceGetRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (recipeId != null) result.recipeId = recipeId;
    return result;
  }

  RecipeServiceGetRequest._();

  factory RecipeServiceGetRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RecipeServiceGetRequest()..mergeFromBuffer(data, registry);
  factory RecipeServiceGetRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RecipeServiceGetRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RecipeServiceGetRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.automation.v1'),
      createEmptyInstance: RecipeServiceGetRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'recipeId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecipeServiceGetRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecipeServiceGetRequest copyWith(
          void Function(RecipeServiceGetRequest) updates) =>
      super.copyWith((message) => updates(message as RecipeServiceGetRequest))
          as RecipeServiceGetRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use RecipeServiceGetRequest() / RecipeServiceGetRequest.new instead')
  static RecipeServiceGetRequest create() => RecipeServiceGetRequest._();
  static $pb.GeneratedMessage $_createMessage() => RecipeServiceGetRequest._();
  @$core.override
  RecipeServiceGetRequest createEmptyInstance() => RecipeServiceGetRequest._();
  @$core.pragma('dart2js:noInline')
  static RecipeServiceGetRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RecipeServiceGetRequest>(
          RecipeServiceGetRequest.$_createMessage);
  static RecipeServiceGetRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get recipeId => $_getSZ(1);
  @$pb.TagNumber(2)
  set recipeId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasRecipeId() => $_has(1);
  @$pb.TagNumber(2)
  void clearRecipeId() => $_clearField(2);
}

class RecipeServiceGetResponse extends $pb.GeneratedMessage {
  factory RecipeServiceGetResponse({
    RecipeTemplate? recipe,
    $core.Iterable<MissingCapabilityExplanation>? missingCapabilities,
    RecipeInstallation? activeInstallation,
  }) {
    final result = RecipeServiceGetResponse._();
    if (recipe != null) result.recipe = recipe;
    if (missingCapabilities != null)
      result.missingCapabilities.addAll(missingCapabilities);
    if (activeInstallation != null)
      result.activeInstallation = activeInstallation;
    return result;
  }

  RecipeServiceGetResponse._();

  factory RecipeServiceGetResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RecipeServiceGetResponse()..mergeFromBuffer(data, registry);
  factory RecipeServiceGetResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RecipeServiceGetResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RecipeServiceGetResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.automation.v1'),
      createEmptyInstance: RecipeServiceGetResponse.$_createMessage)
    ..aOM<RecipeTemplate>(1, _omitFieldNames ? '' : 'recipe',
        subBuilder: RecipeTemplate.$_createMessage)
    ..pPM<MissingCapabilityExplanation>(
        2, _omitFieldNames ? '' : 'missingCapabilities',
        subBuilder: MissingCapabilityExplanation.$_createMessage)
    ..aOM<RecipeInstallation>(3, _omitFieldNames ? '' : 'activeInstallation',
        subBuilder: RecipeInstallation.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecipeServiceGetResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecipeServiceGetResponse copyWith(
          void Function(RecipeServiceGetResponse) updates) =>
      super.copyWith((message) => updates(message as RecipeServiceGetResponse))
          as RecipeServiceGetResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use RecipeServiceGetResponse() / RecipeServiceGetResponse.new instead')
  static RecipeServiceGetResponse create() => RecipeServiceGetResponse._();
  static $pb.GeneratedMessage $_createMessage() => RecipeServiceGetResponse._();
  @$core.override
  RecipeServiceGetResponse createEmptyInstance() =>
      RecipeServiceGetResponse._();
  @$core.pragma('dart2js:noInline')
  static RecipeServiceGetResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RecipeServiceGetResponse>(
          RecipeServiceGetResponse.$_createMessage);
  static RecipeServiceGetResponse? _defaultInstance;

  @$pb.TagNumber(1)
  RecipeTemplate get recipe => $_getN(0);
  @$pb.TagNumber(1)
  set recipe(RecipeTemplate value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasRecipe() => $_has(0);
  @$pb.TagNumber(1)
  void clearRecipe() => $_clearField(1);
  @$pb.TagNumber(1)
  RecipeTemplate ensureRecipe() => $_ensure(0);

  @$pb.TagNumber(2)
  $pb.PbList<MissingCapabilityExplanation> get missingCapabilities =>
      $_getList(1);

  @$pb.TagNumber(3)
  RecipeInstallation get activeInstallation => $_getN(2);
  @$pb.TagNumber(3)
  set activeInstallation(RecipeInstallation value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasActiveInstallation() => $_has(2);
  @$pb.TagNumber(3)
  void clearActiveInstallation() => $_clearField(3);
  @$pb.TagNumber(3)
  RecipeInstallation ensureActiveInstallation() => $_ensure(2);
}

class RecipeServiceRunRequest extends $pb.GeneratedMessage {
  factory RecipeServiceRunRequest({
    $core.String? idempotencyKey,
    $core.String? workspaceId,
    $core.String? recipeId,
    $core.String? parameterOverridesJson,
  }) {
    final result = RecipeServiceRunRequest._();
    if (idempotencyKey != null) result.idempotencyKey = idempotencyKey;
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (recipeId != null) result.recipeId = recipeId;
    if (parameterOverridesJson != null)
      result.parameterOverridesJson = parameterOverridesJson;
    return result;
  }

  RecipeServiceRunRequest._();

  factory RecipeServiceRunRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RecipeServiceRunRequest()..mergeFromBuffer(data, registry);
  factory RecipeServiceRunRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RecipeServiceRunRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RecipeServiceRunRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.automation.v1'),
      createEmptyInstance: RecipeServiceRunRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'idempotencyKey')
    ..aOS(2, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(3, _omitFieldNames ? '' : 'recipeId')
    ..aOS(4, _omitFieldNames ? '' : 'parameterOverridesJson')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecipeServiceRunRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecipeServiceRunRequest copyWith(
          void Function(RecipeServiceRunRequest) updates) =>
      super.copyWith((message) => updates(message as RecipeServiceRunRequest))
          as RecipeServiceRunRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use RecipeServiceRunRequest() / RecipeServiceRunRequest.new instead')
  static RecipeServiceRunRequest create() => RecipeServiceRunRequest._();
  static $pb.GeneratedMessage $_createMessage() => RecipeServiceRunRequest._();
  @$core.override
  RecipeServiceRunRequest createEmptyInstance() => RecipeServiceRunRequest._();
  @$core.pragma('dart2js:noInline')
  static RecipeServiceRunRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RecipeServiceRunRequest>(
          RecipeServiceRunRequest.$_createMessage);
  static RecipeServiceRunRequest? _defaultInstance;

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
  $core.String get recipeId => $_getSZ(2);
  @$pb.TagNumber(3)
  set recipeId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasRecipeId() => $_has(2);
  @$pb.TagNumber(3)
  void clearRecipeId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get parameterOverridesJson => $_getSZ(3);
  @$pb.TagNumber(4)
  set parameterOverridesJson($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasParameterOverridesJson() => $_has(3);
  @$pb.TagNumber(4)
  void clearParameterOverridesJson() => $_clearField(4);
}

class RecipeServiceRunResponse extends $pb.GeneratedMessage {
  factory RecipeServiceRunResponse({
    $core.String? workflowRunId,
    $2.WorkflowRunStatus? status,
  }) {
    final result = RecipeServiceRunResponse._();
    if (workflowRunId != null) result.workflowRunId = workflowRunId;
    if (status != null) result.status = status;
    return result;
  }

  RecipeServiceRunResponse._();

  factory RecipeServiceRunResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RecipeServiceRunResponse()..mergeFromBuffer(data, registry);
  factory RecipeServiceRunResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RecipeServiceRunResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RecipeServiceRunResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.automation.v1'),
      createEmptyInstance: RecipeServiceRunResponse.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workflowRunId')
    ..aE<$2.WorkflowRunStatus>(2, _omitFieldNames ? '' : 'status',
        enumValues: $2.WorkflowRunStatus.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecipeServiceRunResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecipeServiceRunResponse copyWith(
          void Function(RecipeServiceRunResponse) updates) =>
      super.copyWith((message) => updates(message as RecipeServiceRunResponse))
          as RecipeServiceRunResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use RecipeServiceRunResponse() / RecipeServiceRunResponse.new instead')
  static RecipeServiceRunResponse create() => RecipeServiceRunResponse._();
  static $pb.GeneratedMessage $_createMessage() => RecipeServiceRunResponse._();
  @$core.override
  RecipeServiceRunResponse createEmptyInstance() =>
      RecipeServiceRunResponse._();
  @$core.pragma('dart2js:noInline')
  static RecipeServiceRunResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RecipeServiceRunResponse>(
          RecipeServiceRunResponse.$_createMessage);
  static RecipeServiceRunResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workflowRunId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workflowRunId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkflowRunId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkflowRunId() => $_clearField(1);

  @$pb.TagNumber(2)
  $2.WorkflowRunStatus get status => $_getN(1);
  @$pb.TagNumber(2)
  set status($2.WorkflowRunStatus value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasStatus() => $_has(1);
  @$pb.TagNumber(2)
  void clearStatus() => $_clearField(2);
}

class RecipeServiceGetRunStatusRequest extends $pb.GeneratedMessage {
  factory RecipeServiceGetRunStatusRequest({
    $core.String? workspaceId,
    $core.String? runId,
  }) {
    final result = RecipeServiceGetRunStatusRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (runId != null) result.runId = runId;
    return result;
  }

  RecipeServiceGetRunStatusRequest._();

  factory RecipeServiceGetRunStatusRequest.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RecipeServiceGetRunStatusRequest()..mergeFromBuffer(data, registry);
  factory RecipeServiceGetRunStatusRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RecipeServiceGetRunStatusRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RecipeServiceGetRunStatusRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.automation.v1'),
      createEmptyInstance: RecipeServiceGetRunStatusRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'runId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecipeServiceGetRunStatusRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecipeServiceGetRunStatusRequest copyWith(
          void Function(RecipeServiceGetRunStatusRequest) updates) =>
      super.copyWith(
              (message) => updates(message as RecipeServiceGetRunStatusRequest))
          as RecipeServiceGetRunStatusRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use RecipeServiceGetRunStatusRequest() / RecipeServiceGetRunStatusRequest.new instead')
  static RecipeServiceGetRunStatusRequest create() =>
      RecipeServiceGetRunStatusRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      RecipeServiceGetRunStatusRequest._();
  @$core.override
  RecipeServiceGetRunStatusRequest createEmptyInstance() =>
      RecipeServiceGetRunStatusRequest._();
  @$core.pragma('dart2js:noInline')
  static RecipeServiceGetRunStatusRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RecipeServiceGetRunStatusRequest>(
          RecipeServiceGetRunStatusRequest.$_createMessage);
  static RecipeServiceGetRunStatusRequest? _defaultInstance;

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

class RecipeServiceGetRunStatusResponse extends $pb.GeneratedMessage {
  factory RecipeServiceGetRunStatusResponse({
    $core.String? runId,
    $2.WorkflowRunStatus? status,
    $core.String? currentNode,
    $1.Timestamp? completedAt,
    $core.String? errorMessage,
  }) {
    final result = RecipeServiceGetRunStatusResponse._();
    if (runId != null) result.runId = runId;
    if (status != null) result.status = status;
    if (currentNode != null) result.currentNode = currentNode;
    if (completedAt != null) result.completedAt = completedAt;
    if (errorMessage != null) result.errorMessage = errorMessage;
    return result;
  }

  RecipeServiceGetRunStatusResponse._();

  factory RecipeServiceGetRunStatusResponse.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RecipeServiceGetRunStatusResponse()..mergeFromBuffer(data, registry);
  factory RecipeServiceGetRunStatusResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RecipeServiceGetRunStatusResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RecipeServiceGetRunStatusResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.automation.v1'),
      createEmptyInstance: RecipeServiceGetRunStatusResponse.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'runId')
    ..aE<$2.WorkflowRunStatus>(2, _omitFieldNames ? '' : 'status',
        enumValues: $2.WorkflowRunStatus.values)
    ..aOS(3, _omitFieldNames ? '' : 'currentNode')
    ..aOM<$1.Timestamp>(4, _omitFieldNames ? '' : 'completedAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..aOS(5, _omitFieldNames ? '' : 'errorMessage')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecipeServiceGetRunStatusResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecipeServiceGetRunStatusResponse copyWith(
          void Function(RecipeServiceGetRunStatusResponse) updates) =>
      super.copyWith((message) =>
              updates(message as RecipeServiceGetRunStatusResponse))
          as RecipeServiceGetRunStatusResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use RecipeServiceGetRunStatusResponse() / RecipeServiceGetRunStatusResponse.new instead')
  static RecipeServiceGetRunStatusResponse create() =>
      RecipeServiceGetRunStatusResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      RecipeServiceGetRunStatusResponse._();
  @$core.override
  RecipeServiceGetRunStatusResponse createEmptyInstance() =>
      RecipeServiceGetRunStatusResponse._();
  @$core.pragma('dart2js:noInline')
  static RecipeServiceGetRunStatusResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RecipeServiceGetRunStatusResponse>(
          RecipeServiceGetRunStatusResponse.$_createMessage);
  static RecipeServiceGetRunStatusResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get runId => $_getSZ(0);
  @$pb.TagNumber(1)
  set runId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRunId() => $_has(0);
  @$pb.TagNumber(1)
  void clearRunId() => $_clearField(1);

  @$pb.TagNumber(2)
  $2.WorkflowRunStatus get status => $_getN(1);
  @$pb.TagNumber(2)
  set status($2.WorkflowRunStatus value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasStatus() => $_has(1);
  @$pb.TagNumber(2)
  void clearStatus() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get currentNode => $_getSZ(2);
  @$pb.TagNumber(3)
  set currentNode($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasCurrentNode() => $_has(2);
  @$pb.TagNumber(3)
  void clearCurrentNode() => $_clearField(3);

  @$pb.TagNumber(4)
  $1.Timestamp get completedAt => $_getN(3);
  @$pb.TagNumber(4)
  set completedAt($1.Timestamp value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasCompletedAt() => $_has(3);
  @$pb.TagNumber(4)
  void clearCompletedAt() => $_clearField(4);
  @$pb.TagNumber(4)
  $1.Timestamp ensureCompletedAt() => $_ensure(3);

  @$pb.TagNumber(5)
  $core.String get errorMessage => $_getSZ(4);
  @$pb.TagNumber(5)
  set errorMessage($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasErrorMessage() => $_has(4);
  @$pb.TagNumber(5)
  void clearErrorMessage() => $_clearField(5);
}

class RecipeServiceListRunsRequest extends $pb.GeneratedMessage {
  factory RecipeServiceListRunsRequest({
    $core.String? workspaceId,
    $core.String? recipeId,
    $core.int? pageSize,
    $core.String? pageToken,
  }) {
    final result = RecipeServiceListRunsRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (recipeId != null) result.recipeId = recipeId;
    if (pageSize != null) result.pageSize = pageSize;
    if (pageToken != null) result.pageToken = pageToken;
    return result;
  }

  RecipeServiceListRunsRequest._();

  factory RecipeServiceListRunsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RecipeServiceListRunsRequest()..mergeFromBuffer(data, registry);
  factory RecipeServiceListRunsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RecipeServiceListRunsRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RecipeServiceListRunsRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.automation.v1'),
      createEmptyInstance: RecipeServiceListRunsRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'recipeId')
    ..aI(3, _omitFieldNames ? '' : 'pageSize')
    ..aOS(4, _omitFieldNames ? '' : 'pageToken')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecipeServiceListRunsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecipeServiceListRunsRequest copyWith(
          void Function(RecipeServiceListRunsRequest) updates) =>
      super.copyWith(
              (message) => updates(message as RecipeServiceListRunsRequest))
          as RecipeServiceListRunsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use RecipeServiceListRunsRequest() / RecipeServiceListRunsRequest.new instead')
  static RecipeServiceListRunsRequest create() =>
      RecipeServiceListRunsRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      RecipeServiceListRunsRequest._();
  @$core.override
  RecipeServiceListRunsRequest createEmptyInstance() =>
      RecipeServiceListRunsRequest._();
  @$core.pragma('dart2js:noInline')
  static RecipeServiceListRunsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RecipeServiceListRunsRequest>(
          RecipeServiceListRunsRequest.$_createMessage);
  static RecipeServiceListRunsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get recipeId => $_getSZ(1);
  @$pb.TagNumber(2)
  set recipeId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasRecipeId() => $_has(1);
  @$pb.TagNumber(2)
  void clearRecipeId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get pageSize => $_getIZ(2);
  @$pb.TagNumber(3)
  set pageSize($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPageSize() => $_has(2);
  @$pb.TagNumber(3)
  void clearPageSize() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get pageToken => $_getSZ(3);
  @$pb.TagNumber(4)
  set pageToken($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasPageToken() => $_has(3);
  @$pb.TagNumber(4)
  void clearPageToken() => $_clearField(4);
}

class RecipeServiceListRunsResponse extends $pb.GeneratedMessage {
  factory RecipeServiceListRunsResponse({
    $core.Iterable<$2.WorkflowRun>? runs,
    $core.String? nextPageToken,
    $core.int? totalCount,
  }) {
    final result = RecipeServiceListRunsResponse._();
    if (runs != null) result.runs.addAll(runs);
    if (nextPageToken != null) result.nextPageToken = nextPageToken;
    if (totalCount != null) result.totalCount = totalCount;
    return result;
  }

  RecipeServiceListRunsResponse._();

  factory RecipeServiceListRunsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RecipeServiceListRunsResponse()..mergeFromBuffer(data, registry);
  factory RecipeServiceListRunsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RecipeServiceListRunsResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RecipeServiceListRunsResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.automation.v1'),
      createEmptyInstance: RecipeServiceListRunsResponse.$_createMessage)
    ..pPM<$2.WorkflowRun>(1, _omitFieldNames ? '' : 'runs',
        subBuilder: $2.WorkflowRun.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'nextPageToken')
    ..aI(3, _omitFieldNames ? '' : 'totalCount')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecipeServiceListRunsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecipeServiceListRunsResponse copyWith(
          void Function(RecipeServiceListRunsResponse) updates) =>
      super.copyWith(
              (message) => updates(message as RecipeServiceListRunsResponse))
          as RecipeServiceListRunsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use RecipeServiceListRunsResponse() / RecipeServiceListRunsResponse.new instead')
  static RecipeServiceListRunsResponse create() =>
      RecipeServiceListRunsResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      RecipeServiceListRunsResponse._();
  @$core.override
  RecipeServiceListRunsResponse createEmptyInstance() =>
      RecipeServiceListRunsResponse._();
  @$core.pragma('dart2js:noInline')
  static RecipeServiceListRunsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RecipeServiceListRunsResponse>(
          RecipeServiceListRunsResponse.$_createMessage);
  static RecipeServiceListRunsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<$2.WorkflowRun> get runs => $_getList(0);

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

class RecipeServiceConfigureRequest extends $pb.GeneratedMessage {
  factory RecipeServiceConfigureRequest({
    $core.String? idempotencyKey,
    $core.String? workspaceId,
    $core.String? installationId,
    $core.String? parameterValuesJson,
    $core.int? pinnedVersion,
    $core.bool? autoUpdate,
  }) {
    final result = RecipeServiceConfigureRequest._();
    if (idempotencyKey != null) result.idempotencyKey = idempotencyKey;
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (installationId != null) result.installationId = installationId;
    if (parameterValuesJson != null)
      result.parameterValuesJson = parameterValuesJson;
    if (pinnedVersion != null) result.pinnedVersion = pinnedVersion;
    if (autoUpdate != null) result.autoUpdate = autoUpdate;
    return result;
  }

  RecipeServiceConfigureRequest._();

  factory RecipeServiceConfigureRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RecipeServiceConfigureRequest()..mergeFromBuffer(data, registry);
  factory RecipeServiceConfigureRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RecipeServiceConfigureRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RecipeServiceConfigureRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.automation.v1'),
      createEmptyInstance: RecipeServiceConfigureRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'idempotencyKey')
    ..aOS(2, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(3, _omitFieldNames ? '' : 'installationId')
    ..aOS(4, _omitFieldNames ? '' : 'parameterValuesJson')
    ..aI(5, _omitFieldNames ? '' : 'pinnedVersion')
    ..aOB(6, _omitFieldNames ? '' : 'autoUpdate')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecipeServiceConfigureRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecipeServiceConfigureRequest copyWith(
          void Function(RecipeServiceConfigureRequest) updates) =>
      super.copyWith(
              (message) => updates(message as RecipeServiceConfigureRequest))
          as RecipeServiceConfigureRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use RecipeServiceConfigureRequest() / RecipeServiceConfigureRequest.new instead')
  static RecipeServiceConfigureRequest create() =>
      RecipeServiceConfigureRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      RecipeServiceConfigureRequest._();
  @$core.override
  RecipeServiceConfigureRequest createEmptyInstance() =>
      RecipeServiceConfigureRequest._();
  @$core.pragma('dart2js:noInline')
  static RecipeServiceConfigureRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RecipeServiceConfigureRequest>(
          RecipeServiceConfigureRequest.$_createMessage);
  static RecipeServiceConfigureRequest? _defaultInstance;

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
  $core.String get installationId => $_getSZ(2);
  @$pb.TagNumber(3)
  set installationId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasInstallationId() => $_has(2);
  @$pb.TagNumber(3)
  void clearInstallationId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get parameterValuesJson => $_getSZ(3);
  @$pb.TagNumber(4)
  set parameterValuesJson($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasParameterValuesJson() => $_has(3);
  @$pb.TagNumber(4)
  void clearParameterValuesJson() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get pinnedVersion => $_getIZ(4);
  @$pb.TagNumber(5)
  set pinnedVersion($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasPinnedVersion() => $_has(4);
  @$pb.TagNumber(5)
  void clearPinnedVersion() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.bool get autoUpdate => $_getBF(5);
  @$pb.TagNumber(6)
  set autoUpdate($core.bool value) => $_setBool(5, value);
  @$pb.TagNumber(6)
  $core.bool hasAutoUpdate() => $_has(5);
  @$pb.TagNumber(6)
  void clearAutoUpdate() => $_clearField(6);
}

class RecipeServiceConfigureResponse extends $pb.GeneratedMessage {
  factory RecipeServiceConfigureResponse({
    RecipeInstallation? installation,
  }) {
    final result = RecipeServiceConfigureResponse._();
    if (installation != null) result.installation = installation;
    return result;
  }

  RecipeServiceConfigureResponse._();

  factory RecipeServiceConfigureResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RecipeServiceConfigureResponse()..mergeFromBuffer(data, registry);
  factory RecipeServiceConfigureResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RecipeServiceConfigureResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RecipeServiceConfigureResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.automation.v1'),
      createEmptyInstance: RecipeServiceConfigureResponse.$_createMessage)
    ..aOM<RecipeInstallation>(1, _omitFieldNames ? '' : 'installation',
        subBuilder: RecipeInstallation.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecipeServiceConfigureResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecipeServiceConfigureResponse copyWith(
          void Function(RecipeServiceConfigureResponse) updates) =>
      super.copyWith(
              (message) => updates(message as RecipeServiceConfigureResponse))
          as RecipeServiceConfigureResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use RecipeServiceConfigureResponse() / RecipeServiceConfigureResponse.new instead')
  static RecipeServiceConfigureResponse create() =>
      RecipeServiceConfigureResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      RecipeServiceConfigureResponse._();
  @$core.override
  RecipeServiceConfigureResponse createEmptyInstance() =>
      RecipeServiceConfigureResponse._();
  @$core.pragma('dart2js:noInline')
  static RecipeServiceConfigureResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RecipeServiceConfigureResponse>(
          RecipeServiceConfigureResponse.$_createMessage);
  static RecipeServiceConfigureResponse? _defaultInstance;

  @$pb.TagNumber(1)
  RecipeInstallation get installation => $_getN(0);
  @$pb.TagNumber(1)
  set installation(RecipeInstallation value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasInstallation() => $_has(0);
  @$pb.TagNumber(1)
  void clearInstallation() => $_clearField(1);
  @$pb.TagNumber(1)
  RecipeInstallation ensureInstallation() => $_ensure(0);
}

class TemplateServiceListTemplatesRequest extends $pb.GeneratedMessage {
  factory TemplateServiceListTemplatesRequest({
    $core.String? workspaceId,
    $core.String? category,
    $core.int? pageSize,
    $core.String? pageToken,
  }) {
    final result = TemplateServiceListTemplatesRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (category != null) result.category = category;
    if (pageSize != null) result.pageSize = pageSize;
    if (pageToken != null) result.pageToken = pageToken;
    return result;
  }

  TemplateServiceListTemplatesRequest._();

  factory TemplateServiceListTemplatesRequest.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      TemplateServiceListTemplatesRequest()..mergeFromBuffer(data, registry);
  factory TemplateServiceListTemplatesRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      TemplateServiceListTemplatesRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TemplateServiceListTemplatesRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.automation.v1'),
      createEmptyInstance: TemplateServiceListTemplatesRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'category')
    ..aI(3, _omitFieldNames ? '' : 'pageSize')
    ..aOS(4, _omitFieldNames ? '' : 'pageToken')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TemplateServiceListTemplatesRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TemplateServiceListTemplatesRequest copyWith(
          void Function(TemplateServiceListTemplatesRequest) updates) =>
      super.copyWith((message) =>
              updates(message as TemplateServiceListTemplatesRequest))
          as TemplateServiceListTemplatesRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use TemplateServiceListTemplatesRequest() / TemplateServiceListTemplatesRequest.new instead')
  static TemplateServiceListTemplatesRequest create() =>
      TemplateServiceListTemplatesRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      TemplateServiceListTemplatesRequest._();
  @$core.override
  TemplateServiceListTemplatesRequest createEmptyInstance() =>
      TemplateServiceListTemplatesRequest._();
  @$core.pragma('dart2js:noInline')
  static TemplateServiceListTemplatesRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
              TemplateServiceListTemplatesRequest>(
          TemplateServiceListTemplatesRequest.$_createMessage);
  static TemplateServiceListTemplatesRequest? _defaultInstance;

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

  @$pb.TagNumber(3)
  $core.int get pageSize => $_getIZ(2);
  @$pb.TagNumber(3)
  set pageSize($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPageSize() => $_has(2);
  @$pb.TagNumber(3)
  void clearPageSize() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get pageToken => $_getSZ(3);
  @$pb.TagNumber(4)
  set pageToken($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasPageToken() => $_has(3);
  @$pb.TagNumber(4)
  void clearPageToken() => $_clearField(4);
}

class TemplateServiceListTemplatesResponse extends $pb.GeneratedMessage {
  factory TemplateServiceListTemplatesResponse({
    $core.Iterable<RecipeTemplate>? templates,
    $core.String? nextPageToken,
    $core.int? totalCount,
  }) {
    final result = TemplateServiceListTemplatesResponse._();
    if (templates != null) result.templates.addAll(templates);
    if (nextPageToken != null) result.nextPageToken = nextPageToken;
    if (totalCount != null) result.totalCount = totalCount;
    return result;
  }

  TemplateServiceListTemplatesResponse._();

  factory TemplateServiceListTemplatesResponse.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      TemplateServiceListTemplatesResponse()..mergeFromBuffer(data, registry);
  factory TemplateServiceListTemplatesResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      TemplateServiceListTemplatesResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TemplateServiceListTemplatesResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.automation.v1'),
      createEmptyInstance: TemplateServiceListTemplatesResponse.$_createMessage)
    ..pPM<RecipeTemplate>(1, _omitFieldNames ? '' : 'templates',
        subBuilder: RecipeTemplate.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'nextPageToken')
    ..aI(3, _omitFieldNames ? '' : 'totalCount')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TemplateServiceListTemplatesResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TemplateServiceListTemplatesResponse copyWith(
          void Function(TemplateServiceListTemplatesResponse) updates) =>
      super.copyWith((message) =>
              updates(message as TemplateServiceListTemplatesResponse))
          as TemplateServiceListTemplatesResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use TemplateServiceListTemplatesResponse() / TemplateServiceListTemplatesResponse.new instead')
  static TemplateServiceListTemplatesResponse create() =>
      TemplateServiceListTemplatesResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      TemplateServiceListTemplatesResponse._();
  @$core.override
  TemplateServiceListTemplatesResponse createEmptyInstance() =>
      TemplateServiceListTemplatesResponse._();
  @$core.pragma('dart2js:noInline')
  static TemplateServiceListTemplatesResponse getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
              TemplateServiceListTemplatesResponse>(
          TemplateServiceListTemplatesResponse.$_createMessage);
  static TemplateServiceListTemplatesResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<RecipeTemplate> get templates => $_getList(0);

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

class TemplateServiceGetTemplateRequest extends $pb.GeneratedMessage {
  factory TemplateServiceGetTemplateRequest({
    $core.String? workspaceId,
    $core.String? templateId,
  }) {
    final result = TemplateServiceGetTemplateRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (templateId != null) result.templateId = templateId;
    return result;
  }

  TemplateServiceGetTemplateRequest._();

  factory TemplateServiceGetTemplateRequest.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      TemplateServiceGetTemplateRequest()..mergeFromBuffer(data, registry);
  factory TemplateServiceGetTemplateRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      TemplateServiceGetTemplateRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TemplateServiceGetTemplateRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.automation.v1'),
      createEmptyInstance: TemplateServiceGetTemplateRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'templateId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TemplateServiceGetTemplateRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TemplateServiceGetTemplateRequest copyWith(
          void Function(TemplateServiceGetTemplateRequest) updates) =>
      super.copyWith((message) =>
              updates(message as TemplateServiceGetTemplateRequest))
          as TemplateServiceGetTemplateRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use TemplateServiceGetTemplateRequest() / TemplateServiceGetTemplateRequest.new instead')
  static TemplateServiceGetTemplateRequest create() =>
      TemplateServiceGetTemplateRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      TemplateServiceGetTemplateRequest._();
  @$core.override
  TemplateServiceGetTemplateRequest createEmptyInstance() =>
      TemplateServiceGetTemplateRequest._();
  @$core.pragma('dart2js:noInline')
  static TemplateServiceGetTemplateRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<TemplateServiceGetTemplateRequest>(
          TemplateServiceGetTemplateRequest.$_createMessage);
  static TemplateServiceGetTemplateRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get templateId => $_getSZ(1);
  @$pb.TagNumber(2)
  set templateId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTemplateId() => $_has(1);
  @$pb.TagNumber(2)
  void clearTemplateId() => $_clearField(2);
}

class TemplateServiceGetTemplateResponse extends $pb.GeneratedMessage {
  factory TemplateServiceGetTemplateResponse({
    RecipeTemplate? template,
    $core.Iterable<MissingCapabilityExplanation>? missingCapabilities,
  }) {
    final result = TemplateServiceGetTemplateResponse._();
    if (template != null) result.template = template;
    if (missingCapabilities != null)
      result.missingCapabilities.addAll(missingCapabilities);
    return result;
  }

  TemplateServiceGetTemplateResponse._();

  factory TemplateServiceGetTemplateResponse.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      TemplateServiceGetTemplateResponse()..mergeFromBuffer(data, registry);
  factory TemplateServiceGetTemplateResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      TemplateServiceGetTemplateResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TemplateServiceGetTemplateResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.automation.v1'),
      createEmptyInstance: TemplateServiceGetTemplateResponse.$_createMessage)
    ..aOM<RecipeTemplate>(1, _omitFieldNames ? '' : 'template',
        subBuilder: RecipeTemplate.$_createMessage)
    ..pPM<MissingCapabilityExplanation>(
        2, _omitFieldNames ? '' : 'missingCapabilities',
        subBuilder: MissingCapabilityExplanation.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TemplateServiceGetTemplateResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TemplateServiceGetTemplateResponse copyWith(
          void Function(TemplateServiceGetTemplateResponse) updates) =>
      super.copyWith((message) =>
              updates(message as TemplateServiceGetTemplateResponse))
          as TemplateServiceGetTemplateResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use TemplateServiceGetTemplateResponse() / TemplateServiceGetTemplateResponse.new instead')
  static TemplateServiceGetTemplateResponse create() =>
      TemplateServiceGetTemplateResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      TemplateServiceGetTemplateResponse._();
  @$core.override
  TemplateServiceGetTemplateResponse createEmptyInstance() =>
      TemplateServiceGetTemplateResponse._();
  @$core.pragma('dart2js:noInline')
  static TemplateServiceGetTemplateResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<TemplateServiceGetTemplateResponse>(
          TemplateServiceGetTemplateResponse.$_createMessage);
  static TemplateServiceGetTemplateResponse? _defaultInstance;

  @$pb.TagNumber(1)
  RecipeTemplate get template => $_getN(0);
  @$pb.TagNumber(1)
  set template(RecipeTemplate value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasTemplate() => $_has(0);
  @$pb.TagNumber(1)
  void clearTemplate() => $_clearField(1);
  @$pb.TagNumber(1)
  RecipeTemplate ensureTemplate() => $_ensure(0);

  @$pb.TagNumber(2)
  $pb.PbList<MissingCapabilityExplanation> get missingCapabilities =>
      $_getList(1);
}

class TemplateServiceSearchTemplatesRequest extends $pb.GeneratedMessage {
  factory TemplateServiceSearchTemplatesRequest({
    $core.String? workspaceId,
    $core.String? query,
    $core.String? category,
    $core.Iterable<$core.String>? tags,
    $core.int? pageSize,
    $core.String? pageToken,
  }) {
    final result = TemplateServiceSearchTemplatesRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (query != null) result.query = query;
    if (category != null) result.category = category;
    if (tags != null) result.tags.addAll(tags);
    if (pageSize != null) result.pageSize = pageSize;
    if (pageToken != null) result.pageToken = pageToken;
    return result;
  }

  TemplateServiceSearchTemplatesRequest._();

  factory TemplateServiceSearchTemplatesRequest.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      TemplateServiceSearchTemplatesRequest()..mergeFromBuffer(data, registry);
  factory TemplateServiceSearchTemplatesRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      TemplateServiceSearchTemplatesRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TemplateServiceSearchTemplatesRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.automation.v1'),
      createEmptyInstance:
          TemplateServiceSearchTemplatesRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'query')
    ..aOS(3, _omitFieldNames ? '' : 'category')
    ..pPS(4, _omitFieldNames ? '' : 'tags')
    ..aI(5, _omitFieldNames ? '' : 'pageSize')
    ..aOS(6, _omitFieldNames ? '' : 'pageToken')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TemplateServiceSearchTemplatesRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TemplateServiceSearchTemplatesRequest copyWith(
          void Function(TemplateServiceSearchTemplatesRequest) updates) =>
      super.copyWith((message) =>
              updates(message as TemplateServiceSearchTemplatesRequest))
          as TemplateServiceSearchTemplatesRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use TemplateServiceSearchTemplatesRequest() / TemplateServiceSearchTemplatesRequest.new instead')
  static TemplateServiceSearchTemplatesRequest create() =>
      TemplateServiceSearchTemplatesRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      TemplateServiceSearchTemplatesRequest._();
  @$core.override
  TemplateServiceSearchTemplatesRequest createEmptyInstance() =>
      TemplateServiceSearchTemplatesRequest._();
  @$core.pragma('dart2js:noInline')
  static TemplateServiceSearchTemplatesRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
              TemplateServiceSearchTemplatesRequest>(
          TemplateServiceSearchTemplatesRequest.$_createMessage);
  static TemplateServiceSearchTemplatesRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get query => $_getSZ(1);
  @$pb.TagNumber(2)
  set query($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasQuery() => $_has(1);
  @$pb.TagNumber(2)
  void clearQuery() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get category => $_getSZ(2);
  @$pb.TagNumber(3)
  set category($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasCategory() => $_has(2);
  @$pb.TagNumber(3)
  void clearCategory() => $_clearField(3);

  @$pb.TagNumber(4)
  $pb.PbList<$core.String> get tags => $_getList(3);

  @$pb.TagNumber(5)
  $core.int get pageSize => $_getIZ(4);
  @$pb.TagNumber(5)
  set pageSize($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasPageSize() => $_has(4);
  @$pb.TagNumber(5)
  void clearPageSize() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get pageToken => $_getSZ(5);
  @$pb.TagNumber(6)
  set pageToken($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasPageToken() => $_has(5);
  @$pb.TagNumber(6)
  void clearPageToken() => $_clearField(6);
}

class TemplateServiceSearchTemplatesResponse extends $pb.GeneratedMessage {
  factory TemplateServiceSearchTemplatesResponse({
    $core.Iterable<RecipeTemplate>? templates,
    $core.String? nextPageToken,
    $core.int? totalCount,
  }) {
    final result = TemplateServiceSearchTemplatesResponse._();
    if (templates != null) result.templates.addAll(templates);
    if (nextPageToken != null) result.nextPageToken = nextPageToken;
    if (totalCount != null) result.totalCount = totalCount;
    return result;
  }

  TemplateServiceSearchTemplatesResponse._();

  factory TemplateServiceSearchTemplatesResponse.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      TemplateServiceSearchTemplatesResponse()..mergeFromBuffer(data, registry);
  factory TemplateServiceSearchTemplatesResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      TemplateServiceSearchTemplatesResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TemplateServiceSearchTemplatesResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.automation.v1'),
      createEmptyInstance:
          TemplateServiceSearchTemplatesResponse.$_createMessage)
    ..pPM<RecipeTemplate>(1, _omitFieldNames ? '' : 'templates',
        subBuilder: RecipeTemplate.$_createMessage)
    ..aOS(2, _omitFieldNames ? '' : 'nextPageToken')
    ..aI(3, _omitFieldNames ? '' : 'totalCount')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TemplateServiceSearchTemplatesResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TemplateServiceSearchTemplatesResponse copyWith(
          void Function(TemplateServiceSearchTemplatesResponse) updates) =>
      super.copyWith((message) =>
              updates(message as TemplateServiceSearchTemplatesResponse))
          as TemplateServiceSearchTemplatesResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use TemplateServiceSearchTemplatesResponse() / TemplateServiceSearchTemplatesResponse.new instead')
  static TemplateServiceSearchTemplatesResponse create() =>
      TemplateServiceSearchTemplatesResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      TemplateServiceSearchTemplatesResponse._();
  @$core.override
  TemplateServiceSearchTemplatesResponse createEmptyInstance() =>
      TemplateServiceSearchTemplatesResponse._();
  @$core.pragma('dart2js:noInline')
  static TemplateServiceSearchTemplatesResponse getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
              TemplateServiceSearchTemplatesResponse>(
          TemplateServiceSearchTemplatesResponse.$_createMessage);
  static TemplateServiceSearchTemplatesResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<RecipeTemplate> get templates => $_getList(0);

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

class TemplateServiceGetFeaturedRequest extends $pb.GeneratedMessage {
  factory TemplateServiceGetFeaturedRequest({
    $core.String? workspaceId,
    $core.String? category,
  }) {
    final result = TemplateServiceGetFeaturedRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (category != null) result.category = category;
    return result;
  }

  TemplateServiceGetFeaturedRequest._();

  factory TemplateServiceGetFeaturedRequest.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      TemplateServiceGetFeaturedRequest()..mergeFromBuffer(data, registry);
  factory TemplateServiceGetFeaturedRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      TemplateServiceGetFeaturedRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TemplateServiceGetFeaturedRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.automation.v1'),
      createEmptyInstance: TemplateServiceGetFeaturedRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'category')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TemplateServiceGetFeaturedRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TemplateServiceGetFeaturedRequest copyWith(
          void Function(TemplateServiceGetFeaturedRequest) updates) =>
      super.copyWith((message) =>
              updates(message as TemplateServiceGetFeaturedRequest))
          as TemplateServiceGetFeaturedRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use TemplateServiceGetFeaturedRequest() / TemplateServiceGetFeaturedRequest.new instead')
  static TemplateServiceGetFeaturedRequest create() =>
      TemplateServiceGetFeaturedRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      TemplateServiceGetFeaturedRequest._();
  @$core.override
  TemplateServiceGetFeaturedRequest createEmptyInstance() =>
      TemplateServiceGetFeaturedRequest._();
  @$core.pragma('dart2js:noInline')
  static TemplateServiceGetFeaturedRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<TemplateServiceGetFeaturedRequest>(
          TemplateServiceGetFeaturedRequest.$_createMessage);
  static TemplateServiceGetFeaturedRequest? _defaultInstance;

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

class TemplateServiceGetFeaturedResponse extends $pb.GeneratedMessage {
  factory TemplateServiceGetFeaturedResponse({
    $core.Iterable<RecipeTemplate>? featuredTemplates,
    RecipeTemplate? weeklyHighlight,
  }) {
    final result = TemplateServiceGetFeaturedResponse._();
    if (featuredTemplates != null)
      result.featuredTemplates.addAll(featuredTemplates);
    if (weeklyHighlight != null) result.weeklyHighlight = weeklyHighlight;
    return result;
  }

  TemplateServiceGetFeaturedResponse._();

  factory TemplateServiceGetFeaturedResponse.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      TemplateServiceGetFeaturedResponse()..mergeFromBuffer(data, registry);
  factory TemplateServiceGetFeaturedResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      TemplateServiceGetFeaturedResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TemplateServiceGetFeaturedResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.automation.v1'),
      createEmptyInstance: TemplateServiceGetFeaturedResponse.$_createMessage)
    ..pPM<RecipeTemplate>(1, _omitFieldNames ? '' : 'featuredTemplates',
        subBuilder: RecipeTemplate.$_createMessage)
    ..aOM<RecipeTemplate>(2, _omitFieldNames ? '' : 'weeklyHighlight',
        subBuilder: RecipeTemplate.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TemplateServiceGetFeaturedResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TemplateServiceGetFeaturedResponse copyWith(
          void Function(TemplateServiceGetFeaturedResponse) updates) =>
      super.copyWith((message) =>
              updates(message as TemplateServiceGetFeaturedResponse))
          as TemplateServiceGetFeaturedResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use TemplateServiceGetFeaturedResponse() / TemplateServiceGetFeaturedResponse.new instead')
  static TemplateServiceGetFeaturedResponse create() =>
      TemplateServiceGetFeaturedResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      TemplateServiceGetFeaturedResponse._();
  @$core.override
  TemplateServiceGetFeaturedResponse createEmptyInstance() =>
      TemplateServiceGetFeaturedResponse._();
  @$core.pragma('dart2js:noInline')
  static TemplateServiceGetFeaturedResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<TemplateServiceGetFeaturedResponse>(
          TemplateServiceGetFeaturedResponse.$_createMessage);
  static TemplateServiceGetFeaturedResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<RecipeTemplate> get featuredTemplates => $_getList(0);

  @$pb.TagNumber(2)
  RecipeTemplate get weeklyHighlight => $_getN(1);
  @$pb.TagNumber(2)
  set weeklyHighlight(RecipeTemplate value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasWeeklyHighlight() => $_has(1);
  @$pb.TagNumber(2)
  void clearWeeklyHighlight() => $_clearField(2);
  @$pb.TagNumber(2)
  RecipeTemplate ensureWeeklyHighlight() => $_ensure(1);
}

class TemplateServiceGetReviewsRequest extends $pb.GeneratedMessage {
  factory TemplateServiceGetReviewsRequest({
    $core.String? workspaceId,
    $core.String? templateId,
    $core.int? pageSize,
    $core.String? pageToken,
  }) {
    final result = TemplateServiceGetReviewsRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (templateId != null) result.templateId = templateId;
    if (pageSize != null) result.pageSize = pageSize;
    if (pageToken != null) result.pageToken = pageToken;
    return result;
  }

  TemplateServiceGetReviewsRequest._();

  factory TemplateServiceGetReviewsRequest.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      TemplateServiceGetReviewsRequest()..mergeFromBuffer(data, registry);
  factory TemplateServiceGetReviewsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      TemplateServiceGetReviewsRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TemplateServiceGetReviewsRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.automation.v1'),
      createEmptyInstance: TemplateServiceGetReviewsRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'templateId')
    ..aI(3, _omitFieldNames ? '' : 'pageSize')
    ..aOS(4, _omitFieldNames ? '' : 'pageToken')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TemplateServiceGetReviewsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TemplateServiceGetReviewsRequest copyWith(
          void Function(TemplateServiceGetReviewsRequest) updates) =>
      super.copyWith(
              (message) => updates(message as TemplateServiceGetReviewsRequest))
          as TemplateServiceGetReviewsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use TemplateServiceGetReviewsRequest() / TemplateServiceGetReviewsRequest.new instead')
  static TemplateServiceGetReviewsRequest create() =>
      TemplateServiceGetReviewsRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      TemplateServiceGetReviewsRequest._();
  @$core.override
  TemplateServiceGetReviewsRequest createEmptyInstance() =>
      TemplateServiceGetReviewsRequest._();
  @$core.pragma('dart2js:noInline')
  static TemplateServiceGetReviewsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<TemplateServiceGetReviewsRequest>(
          TemplateServiceGetReviewsRequest.$_createMessage);
  static TemplateServiceGetReviewsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get templateId => $_getSZ(1);
  @$pb.TagNumber(2)
  set templateId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTemplateId() => $_has(1);
  @$pb.TagNumber(2)
  void clearTemplateId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get pageSize => $_getIZ(2);
  @$pb.TagNumber(3)
  set pageSize($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPageSize() => $_has(2);
  @$pb.TagNumber(3)
  void clearPageSize() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get pageToken => $_getSZ(3);
  @$pb.TagNumber(4)
  set pageToken($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasPageToken() => $_has(3);
  @$pb.TagNumber(4)
  void clearPageToken() => $_clearField(4);
}

class TemplateServiceGetReviewsResponse extends $pb.GeneratedMessage {
  factory TemplateServiceGetReviewsResponse({
    $core.Iterable<RecipeReview>? reviews,
    $core.double? ratingAvg,
    $core.int? reviewCount,
    $core.String? nextPageToken,
  }) {
    final result = TemplateServiceGetReviewsResponse._();
    if (reviews != null) result.reviews.addAll(reviews);
    if (ratingAvg != null) result.ratingAvg = ratingAvg;
    if (reviewCount != null) result.reviewCount = reviewCount;
    if (nextPageToken != null) result.nextPageToken = nextPageToken;
    return result;
  }

  TemplateServiceGetReviewsResponse._();

  factory TemplateServiceGetReviewsResponse.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      TemplateServiceGetReviewsResponse()..mergeFromBuffer(data, registry);
  factory TemplateServiceGetReviewsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      TemplateServiceGetReviewsResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TemplateServiceGetReviewsResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.automation.v1'),
      createEmptyInstance: TemplateServiceGetReviewsResponse.$_createMessage)
    ..pPM<RecipeReview>(1, _omitFieldNames ? '' : 'reviews',
        subBuilder: RecipeReview.$_createMessage)
    ..aD(2, _omitFieldNames ? '' : 'ratingAvg', fieldType: $pb.PbFieldType.OF)
    ..aI(3, _omitFieldNames ? '' : 'reviewCount')
    ..aOS(4, _omitFieldNames ? '' : 'nextPageToken')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TemplateServiceGetReviewsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TemplateServiceGetReviewsResponse copyWith(
          void Function(TemplateServiceGetReviewsResponse) updates) =>
      super.copyWith((message) =>
              updates(message as TemplateServiceGetReviewsResponse))
          as TemplateServiceGetReviewsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use TemplateServiceGetReviewsResponse() / TemplateServiceGetReviewsResponse.new instead')
  static TemplateServiceGetReviewsResponse create() =>
      TemplateServiceGetReviewsResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      TemplateServiceGetReviewsResponse._();
  @$core.override
  TemplateServiceGetReviewsResponse createEmptyInstance() =>
      TemplateServiceGetReviewsResponse._();
  @$core.pragma('dart2js:noInline')
  static TemplateServiceGetReviewsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<TemplateServiceGetReviewsResponse>(
          TemplateServiceGetReviewsResponse.$_createMessage);
  static TemplateServiceGetReviewsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<RecipeReview> get reviews => $_getList(0);

  @$pb.TagNumber(2)
  $core.double get ratingAvg => $_getN(1);
  @$pb.TagNumber(2)
  set ratingAvg($core.double value) => $_setFloat(1, value);
  @$pb.TagNumber(2)
  $core.bool hasRatingAvg() => $_has(1);
  @$pb.TagNumber(2)
  void clearRatingAvg() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get reviewCount => $_getIZ(2);
  @$pb.TagNumber(3)
  set reviewCount($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasReviewCount() => $_has(2);
  @$pb.TagNumber(3)
  void clearReviewCount() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get nextPageToken => $_getSZ(3);
  @$pb.TagNumber(4)
  set nextPageToken($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasNextPageToken() => $_has(3);
  @$pb.TagNumber(4)
  void clearNextPageToken() => $_clearField(4);
}

class TemplateServiceDeployRequest extends $pb.GeneratedMessage {
  factory TemplateServiceDeployRequest({
    $core.String? idempotencyKey,
    $core.String? workspaceId,
    $core.String? templateId,
    $core.String? parameterValuesJson,
    $core.String? titleOverride,
  }) {
    final result = TemplateServiceDeployRequest._();
    if (idempotencyKey != null) result.idempotencyKey = idempotencyKey;
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (templateId != null) result.templateId = templateId;
    if (parameterValuesJson != null)
      result.parameterValuesJson = parameterValuesJson;
    if (titleOverride != null) result.titleOverride = titleOverride;
    return result;
  }

  TemplateServiceDeployRequest._();

  factory TemplateServiceDeployRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      TemplateServiceDeployRequest()..mergeFromBuffer(data, registry);
  factory TemplateServiceDeployRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      TemplateServiceDeployRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TemplateServiceDeployRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.automation.v1'),
      createEmptyInstance: TemplateServiceDeployRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'idempotencyKey')
    ..aOS(2, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(3, _omitFieldNames ? '' : 'templateId')
    ..aOS(4, _omitFieldNames ? '' : 'parameterValuesJson')
    ..aOS(5, _omitFieldNames ? '' : 'titleOverride')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TemplateServiceDeployRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TemplateServiceDeployRequest copyWith(
          void Function(TemplateServiceDeployRequest) updates) =>
      super.copyWith(
              (message) => updates(message as TemplateServiceDeployRequest))
          as TemplateServiceDeployRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use TemplateServiceDeployRequest() / TemplateServiceDeployRequest.new instead')
  static TemplateServiceDeployRequest create() =>
      TemplateServiceDeployRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      TemplateServiceDeployRequest._();
  @$core.override
  TemplateServiceDeployRequest createEmptyInstance() =>
      TemplateServiceDeployRequest._();
  @$core.pragma('dart2js:noInline')
  static TemplateServiceDeployRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<TemplateServiceDeployRequest>(
          TemplateServiceDeployRequest.$_createMessage);
  static TemplateServiceDeployRequest? _defaultInstance;

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
  $core.String get templateId => $_getSZ(2);
  @$pb.TagNumber(3)
  set templateId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasTemplateId() => $_has(2);
  @$pb.TagNumber(3)
  void clearTemplateId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get parameterValuesJson => $_getSZ(3);
  @$pb.TagNumber(4)
  set parameterValuesJson($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasParameterValuesJson() => $_has(3);
  @$pb.TagNumber(4)
  void clearParameterValuesJson() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get titleOverride => $_getSZ(4);
  @$pb.TagNumber(5)
  set titleOverride($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasTitleOverride() => $_has(4);
  @$pb.TagNumber(5)
  void clearTitleOverride() => $_clearField(5);
}

class TemplateServiceDeployResponse extends $pb.GeneratedMessage {
  factory TemplateServiceDeployResponse({
    $core.bool? success,
    $core.String? workflowId,
    $2.Workflow? createdWorkflow,
    $core.String? installationId,
    $core.Iterable<MissingCapabilityExplanation>? missingCapabilities,
  }) {
    final result = TemplateServiceDeployResponse._();
    if (success != null) result.success = success;
    if (workflowId != null) result.workflowId = workflowId;
    if (createdWorkflow != null) result.createdWorkflow = createdWorkflow;
    if (installationId != null) result.installationId = installationId;
    if (missingCapabilities != null)
      result.missingCapabilities.addAll(missingCapabilities);
    return result;
  }

  TemplateServiceDeployResponse._();

  factory TemplateServiceDeployResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      TemplateServiceDeployResponse()..mergeFromBuffer(data, registry);
  factory TemplateServiceDeployResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      TemplateServiceDeployResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TemplateServiceDeployResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.automation.v1'),
      createEmptyInstance: TemplateServiceDeployResponse.$_createMessage)
    ..aOB(1, _omitFieldNames ? '' : 'success')
    ..aOS(2, _omitFieldNames ? '' : 'workflowId')
    ..aOM<$2.Workflow>(3, _omitFieldNames ? '' : 'createdWorkflow',
        subBuilder: $2.Workflow.$_createMessage)
    ..aOS(4, _omitFieldNames ? '' : 'installationId')
    ..pPM<MissingCapabilityExplanation>(
        5, _omitFieldNames ? '' : 'missingCapabilities',
        subBuilder: MissingCapabilityExplanation.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TemplateServiceDeployResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TemplateServiceDeployResponse copyWith(
          void Function(TemplateServiceDeployResponse) updates) =>
      super.copyWith(
              (message) => updates(message as TemplateServiceDeployResponse))
          as TemplateServiceDeployResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use TemplateServiceDeployResponse() / TemplateServiceDeployResponse.new instead')
  static TemplateServiceDeployResponse create() =>
      TemplateServiceDeployResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      TemplateServiceDeployResponse._();
  @$core.override
  TemplateServiceDeployResponse createEmptyInstance() =>
      TemplateServiceDeployResponse._();
  @$core.pragma('dart2js:noInline')
  static TemplateServiceDeployResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<TemplateServiceDeployResponse>(
          TemplateServiceDeployResponse.$_createMessage);
  static TemplateServiceDeployResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get success => $_getBF(0);
  @$pb.TagNumber(1)
  set success($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSuccess() => $_has(0);
  @$pb.TagNumber(1)
  void clearSuccess() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get workflowId => $_getSZ(1);
  @$pb.TagNumber(2)
  set workflowId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasWorkflowId() => $_has(1);
  @$pb.TagNumber(2)
  void clearWorkflowId() => $_clearField(2);

  @$pb.TagNumber(3)
  $2.Workflow get createdWorkflow => $_getN(2);
  @$pb.TagNumber(3)
  set createdWorkflow($2.Workflow value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasCreatedWorkflow() => $_has(2);
  @$pb.TagNumber(3)
  void clearCreatedWorkflow() => $_clearField(3);
  @$pb.TagNumber(3)
  $2.Workflow ensureCreatedWorkflow() => $_ensure(2);

  @$pb.TagNumber(4)
  $core.String get installationId => $_getSZ(3);
  @$pb.TagNumber(4)
  set installationId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasInstallationId() => $_has(3);
  @$pb.TagNumber(4)
  void clearInstallationId() => $_clearField(4);

  @$pb.TagNumber(5)
  $pb.PbList<MissingCapabilityExplanation> get missingCapabilities =>
      $_getList(4);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');

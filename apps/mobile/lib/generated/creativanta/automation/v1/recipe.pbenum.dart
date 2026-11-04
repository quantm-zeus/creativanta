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

/// RecipeStatus defines the lifecycle of a recipe template per database_schema.md §12.3B.
class RecipeStatus extends $pb.ProtobufEnum {
  static const RecipeStatus RECIPE_STATUS_UNSPECIFIED =
      RecipeStatus._(0, _omitEnumNames ? '' : 'RECIPE_STATUS_UNSPECIFIED');
  static const RecipeStatus RECIPE_STATUS_DRAFT =
      RecipeStatus._(1, _omitEnumNames ? '' : 'RECIPE_STATUS_DRAFT');
  static const RecipeStatus RECIPE_STATUS_REVIEW_REQUIRED =
      RecipeStatus._(2, _omitEnumNames ? '' : 'RECIPE_STATUS_REVIEW_REQUIRED');
  static const RecipeStatus RECIPE_STATUS_PUBLISHED =
      RecipeStatus._(3, _omitEnumNames ? '' : 'RECIPE_STATUS_PUBLISHED');
  static const RecipeStatus RECIPE_STATUS_DEPRECATED =
      RecipeStatus._(4, _omitEnumNames ? '' : 'RECIPE_STATUS_DEPRECATED');
  static const RecipeStatus RECIPE_STATUS_RETIRED =
      RecipeStatus._(5, _omitEnumNames ? '' : 'RECIPE_STATUS_RETIRED');
  static const RecipeStatus RECIPE_STATUS_TAKEN_DOWN =
      RecipeStatus._(6, _omitEnumNames ? '' : 'RECIPE_STATUS_TAKEN_DOWN');

  static const $core.List<RecipeStatus> values = <RecipeStatus>[
    RECIPE_STATUS_UNSPECIFIED,
    RECIPE_STATUS_DRAFT,
    RECIPE_STATUS_REVIEW_REQUIRED,
    RECIPE_STATUS_PUBLISHED,
    RECIPE_STATUS_DEPRECATED,
    RECIPE_STATUS_RETIRED,
    RECIPE_STATUS_TAKEN_DOWN,
  ];

  static final $core.List<RecipeStatus?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 6);
  static RecipeStatus? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const RecipeStatus._(super.value, super.name);
}

/// TemplateKind defines the variant of the template snapshot per database_schema.md §12.3B.
class TemplateKind extends $pb.ProtobufEnum {
  static const TemplateKind TEMPLATE_KIND_UNSPECIFIED =
      TemplateKind._(0, _omitEnumNames ? '' : 'TEMPLATE_KIND_UNSPECIFIED');
  static const TemplateKind TEMPLATE_KIND_WORKFLOW =
      TemplateKind._(1, _omitEnumNames ? '' : 'TEMPLATE_KIND_WORKFLOW');
  static const TemplateKind TEMPLATE_KIND_STYLE_WORKFLOW =
      TemplateKind._(2, _omitEnumNames ? '' : 'TEMPLATE_KIND_STYLE_WORKFLOW');

  static const $core.List<TemplateKind> values = <TemplateKind>[
    TEMPLATE_KIND_UNSPECIFIED,
    TEMPLATE_KIND_WORKFLOW,
    TEMPLATE_KIND_STYLE_WORKFLOW,
  ];

  static final $core.List<TemplateKind?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 2);
  static TemplateKind? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const TemplateKind._(super.value, super.name);
}

/// RecipeInstallationStatus defines per-workspace install state per recipe_agent_center.md.
class RecipeInstallationStatus extends $pb.ProtobufEnum {
  static const RecipeInstallationStatus RECIPE_INSTALLATION_STATUS_UNSPECIFIED =
      RecipeInstallationStatus._(
          0, _omitEnumNames ? '' : 'RECIPE_INSTALLATION_STATUS_UNSPECIFIED');
  static const RecipeInstallationStatus RECIPE_INSTALLATION_STATUS_INSTALLED =
      RecipeInstallationStatus._(
          1, _omitEnumNames ? '' : 'RECIPE_INSTALLATION_STATUS_INSTALLED');
  static const RecipeInstallationStatus RECIPE_INSTALLATION_STATUS_CUSTOMIZED =
      RecipeInstallationStatus._(
          2, _omitEnumNames ? '' : 'RECIPE_INSTALLATION_STATUS_CUSTOMIZED');
  static const RecipeInstallationStatus
      RECIPE_INSTALLATION_STATUS_UPDATE_AVAILABLE = RecipeInstallationStatus._(
          3,
          _omitEnumNames ? '' : 'RECIPE_INSTALLATION_STATUS_UPDATE_AVAILABLE');
  static const RecipeInstallationStatus RECIPE_INSTALLATION_STATUS_PINNED =
      RecipeInstallationStatus._(
          4, _omitEnumNames ? '' : 'RECIPE_INSTALLATION_STATUS_PINNED');
  static const RecipeInstallationStatus RECIPE_INSTALLATION_STATUS_DEPRECATED =
      RecipeInstallationStatus._(
          5, _omitEnumNames ? '' : 'RECIPE_INSTALLATION_STATUS_DEPRECATED');
  static const RecipeInstallationStatus
      RECIPE_INSTALLATION_STATUS_WORKFLOW_DELETED = RecipeInstallationStatus._(
          6,
          _omitEnumNames ? '' : 'RECIPE_INSTALLATION_STATUS_WORKFLOW_DELETED');

  static const $core.List<RecipeInstallationStatus> values =
      <RecipeInstallationStatus>[
    RECIPE_INSTALLATION_STATUS_UNSPECIFIED,
    RECIPE_INSTALLATION_STATUS_INSTALLED,
    RECIPE_INSTALLATION_STATUS_CUSTOMIZED,
    RECIPE_INSTALLATION_STATUS_UPDATE_AVAILABLE,
    RECIPE_INSTALLATION_STATUS_PINNED,
    RECIPE_INSTALLATION_STATUS_DEPRECATED,
    RECIPE_INSTALLATION_STATUS_WORKFLOW_DELETED,
  ];

  static final $core.List<RecipeInstallationStatus?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 6);
  static RecipeInstallationStatus? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const RecipeInstallationStatus._(super.value, super.name);
}

/// SubmissionStatus defines creator recipe review status per Pack 06 S22.
class SubmissionStatus extends $pb.ProtobufEnum {
  static const SubmissionStatus SUBMISSION_STATUS_UNSPECIFIED =
      SubmissionStatus._(
          0, _omitEnumNames ? '' : 'SUBMISSION_STATUS_UNSPECIFIED');
  static const SubmissionStatus SUBMISSION_STATUS_PENDING =
      SubmissionStatus._(1, _omitEnumNames ? '' : 'SUBMISSION_STATUS_PENDING');
  static const SubmissionStatus SUBMISSION_STATUS_APPROVED =
      SubmissionStatus._(2, _omitEnumNames ? '' : 'SUBMISSION_STATUS_APPROVED');
  static const SubmissionStatus SUBMISSION_STATUS_REJECTED =
      SubmissionStatus._(3, _omitEnumNames ? '' : 'SUBMISSION_STATUS_REJECTED');
  static const SubmissionStatus SUBMISSION_STATUS_CHANGES_REQUESTED =
      SubmissionStatus._(
          4, _omitEnumNames ? '' : 'SUBMISSION_STATUS_CHANGES_REQUESTED');
  static const SubmissionStatus SUBMISSION_STATUS_TAKEN_DOWN =
      SubmissionStatus._(
          5, _omitEnumNames ? '' : 'SUBMISSION_STATUS_TAKEN_DOWN');

  static const $core.List<SubmissionStatus> values = <SubmissionStatus>[
    SUBMISSION_STATUS_UNSPECIFIED,
    SUBMISSION_STATUS_PENDING,
    SUBMISSION_STATUS_APPROVED,
    SUBMISSION_STATUS_REJECTED,
    SUBMISSION_STATUS_CHANGES_REQUESTED,
    SUBMISSION_STATUS_TAKEN_DOWN,
  ];

  static final $core.List<SubmissionStatus?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 5);
  static SubmissionStatus? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const SubmissionStatus._(super.value, super.name);
}

/// RevenueShareStatus defines marketplace 70/30 split settlement state.
class RevenueShareStatus extends $pb.ProtobufEnum {
  static const RevenueShareStatus REVENUE_SHARE_STATUS_UNSPECIFIED =
      RevenueShareStatus._(
          0, _omitEnumNames ? '' : 'REVENUE_SHARE_STATUS_UNSPECIFIED');
  static const RevenueShareStatus REVENUE_SHARE_STATUS_SETTLED =
      RevenueShareStatus._(
          1, _omitEnumNames ? '' : 'REVENUE_SHARE_STATUS_SETTLED');
  static const RevenueShareStatus REVENUE_SHARE_STATUS_REFUNDED =
      RevenueShareStatus._(
          2, _omitEnumNames ? '' : 'REVENUE_SHARE_STATUS_REFUNDED');
  static const RevenueShareStatus REVENUE_SHARE_STATUS_DISPUTED =
      RevenueShareStatus._(
          3, _omitEnumNames ? '' : 'REVENUE_SHARE_STATUS_DISPUTED');

  static const $core.List<RevenueShareStatus> values = <RevenueShareStatus>[
    REVENUE_SHARE_STATUS_UNSPECIFIED,
    REVENUE_SHARE_STATUS_SETTLED,
    REVENUE_SHARE_STATUS_REFUNDED,
    REVENUE_SHARE_STATUS_DISPUTED,
  ];

  static final $core.List<RevenueShareStatus?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 3);
  static RevenueShareStatus? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const RevenueShareStatus._(super.value, super.name);
}

const $core.bool _omitEnumNames =
    $core.bool.fromEnvironment('protobuf.omit_enum_names');

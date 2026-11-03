// This is a generated file - do not edit.
//
// Generated from creativanta/content/v1/script.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

/// ScriptLifecycleState tracks script creation progression per database_schema.md §6.4.
class ScriptLifecycleState extends $pb.ProtobufEnum {
  static const ScriptLifecycleState SCRIPT_LIFECYCLE_STATE_UNSPECIFIED =
      ScriptLifecycleState._(
          0, _omitEnumNames ? '' : 'SCRIPT_LIFECYCLE_STATE_UNSPECIFIED');
  static const ScriptLifecycleState SCRIPT_LIFECYCLE_STATE_DRAFT =
      ScriptLifecycleState._(
          1, _omitEnumNames ? '' : 'SCRIPT_LIFECYCLE_STATE_DRAFT');
  static const ScriptLifecycleState SCRIPT_LIFECYCLE_STATE_IN_REVIEW =
      ScriptLifecycleState._(
          2, _omitEnumNames ? '' : 'SCRIPT_LIFECYCLE_STATE_IN_REVIEW');
  static const ScriptLifecycleState SCRIPT_LIFECYCLE_STATE_APPROVED =
      ScriptLifecycleState._(
          3, _omitEnumNames ? '' : 'SCRIPT_LIFECYCLE_STATE_APPROVED');
  static const ScriptLifecycleState SCRIPT_LIFECYCLE_STATE_REVISION_REQUIRED =
      ScriptLifecycleState._(
          4, _omitEnumNames ? '' : 'SCRIPT_LIFECYCLE_STATE_REVISION_REQUIRED');
  static const ScriptLifecycleState
      SCRIPT_LIFECYCLE_STATE_READY_FOR_PRODUCTION = ScriptLifecycleState._(5,
          _omitEnumNames ? '' : 'SCRIPT_LIFECYCLE_STATE_READY_FOR_PRODUCTION');
  static const ScriptLifecycleState SCRIPT_LIFECYCLE_STATE_ARCHIVED =
      ScriptLifecycleState._(
          6, _omitEnumNames ? '' : 'SCRIPT_LIFECYCLE_STATE_ARCHIVED');

  static const $core.List<ScriptLifecycleState> values = <ScriptLifecycleState>[
    SCRIPT_LIFECYCLE_STATE_UNSPECIFIED,
    SCRIPT_LIFECYCLE_STATE_DRAFT,
    SCRIPT_LIFECYCLE_STATE_IN_REVIEW,
    SCRIPT_LIFECYCLE_STATE_APPROVED,
    SCRIPT_LIFECYCLE_STATE_REVISION_REQUIRED,
    SCRIPT_LIFECYCLE_STATE_READY_FOR_PRODUCTION,
    SCRIPT_LIFECYCLE_STATE_ARCHIVED,
  ];

  static final $core.List<ScriptLifecycleState?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 6);
  static ScriptLifecycleState? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const ScriptLifecycleState._(super.value, super.name);
}

/// ScriptApprovalState tracks independent approval review state per database_schema.md §6.4.
class ScriptApprovalState extends $pb.ProtobufEnum {
  static const ScriptApprovalState SCRIPT_APPROVAL_STATE_UNSPECIFIED =
      ScriptApprovalState._(
          0, _omitEnumNames ? '' : 'SCRIPT_APPROVAL_STATE_UNSPECIFIED');
  static const ScriptApprovalState SCRIPT_APPROVAL_STATE_NOT_SUBMITTED =
      ScriptApprovalState._(
          1, _omitEnumNames ? '' : 'SCRIPT_APPROVAL_STATE_NOT_SUBMITTED');
  static const ScriptApprovalState SCRIPT_APPROVAL_STATE_PENDING_APPROVAL =
      ScriptApprovalState._(
          2, _omitEnumNames ? '' : 'SCRIPT_APPROVAL_STATE_PENDING_APPROVAL');
  static const ScriptApprovalState SCRIPT_APPROVAL_STATE_APPROVED =
      ScriptApprovalState._(
          3, _omitEnumNames ? '' : 'SCRIPT_APPROVAL_STATE_APPROVED');
  static const ScriptApprovalState SCRIPT_APPROVAL_STATE_REJECTED =
      ScriptApprovalState._(
          4, _omitEnumNames ? '' : 'SCRIPT_APPROVAL_STATE_REJECTED');

  static const $core.List<ScriptApprovalState> values = <ScriptApprovalState>[
    SCRIPT_APPROVAL_STATE_UNSPECIFIED,
    SCRIPT_APPROVAL_STATE_NOT_SUBMITTED,
    SCRIPT_APPROVAL_STATE_PENDING_APPROVAL,
    SCRIPT_APPROVAL_STATE_APPROVED,
    SCRIPT_APPROVAL_STATE_REJECTED,
  ];

  static final $core.List<ScriptApprovalState?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 4);
  static ScriptApprovalState? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const ScriptApprovalState._(super.value, super.name);
}

/// AssetBriefStatus tracks the readiness of the production Asset Brief per database_schema.md §6.5.
class AssetBriefStatus extends $pb.ProtobufEnum {
  static const AssetBriefStatus ASSET_BRIEF_STATUS_UNSPECIFIED =
      AssetBriefStatus._(
          0, _omitEnumNames ? '' : 'ASSET_BRIEF_STATUS_UNSPECIFIED');
  static const AssetBriefStatus ASSET_BRIEF_STATUS_DRAFT =
      AssetBriefStatus._(1, _omitEnumNames ? '' : 'ASSET_BRIEF_STATUS_DRAFT');
  static const AssetBriefStatus ASSET_BRIEF_STATUS_READY =
      AssetBriefStatus._(2, _omitEnumNames ? '' : 'ASSET_BRIEF_STATUS_READY');
  static const AssetBriefStatus ASSET_BRIEF_STATUS_LOCKED =
      AssetBriefStatus._(3, _omitEnumNames ? '' : 'ASSET_BRIEF_STATUS_LOCKED');
  static const AssetBriefStatus ASSET_BRIEF_STATUS_SUPERSEDED =
      AssetBriefStatus._(
          4, _omitEnumNames ? '' : 'ASSET_BRIEF_STATUS_SUPERSEDED');

  static const $core.List<AssetBriefStatus> values = <AssetBriefStatus>[
    ASSET_BRIEF_STATUS_UNSPECIFIED,
    ASSET_BRIEF_STATUS_DRAFT,
    ASSET_BRIEF_STATUS_READY,
    ASSET_BRIEF_STATUS_LOCKED,
    ASSET_BRIEF_STATUS_SUPERSEDED,
  ];

  static final $core.List<AssetBriefStatus?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 4);
  static AssetBriefStatus? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const AssetBriefStatus._(super.value, super.name);
}

const $core.bool _omitEnumNames =
    $core.bool.fromEnvironment('protobuf.omit_enum_names');

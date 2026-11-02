// This is a generated file - do not edit.
//
// Generated from creativanta/admin/v1/diagnostics.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

/// Overall health state for a workspace or diagnostic category.
class DiagnosticHealthStatus extends $pb.ProtobufEnum {
  static const DiagnosticHealthStatus DIAGNOSTIC_HEALTH_STATUS_UNSPECIFIED =
      DiagnosticHealthStatus._(
          0, _omitEnumNames ? '' : 'DIAGNOSTIC_HEALTH_STATUS_UNSPECIFIED');
  static const DiagnosticHealthStatus DIAGNOSTIC_HEALTH_STATUS_HEALTHY =
      DiagnosticHealthStatus._(
          1, _omitEnumNames ? '' : 'DIAGNOSTIC_HEALTH_STATUS_HEALTHY');
  static const DiagnosticHealthStatus DIAGNOSTIC_HEALTH_STATUS_WARNING =
      DiagnosticHealthStatus._(
          2, _omitEnumNames ? '' : 'DIAGNOSTIC_HEALTH_STATUS_WARNING');
  static const DiagnosticHealthStatus DIAGNOSTIC_HEALTH_STATUS_ERROR =
      DiagnosticHealthStatus._(
          3, _omitEnumNames ? '' : 'DIAGNOSTIC_HEALTH_STATUS_ERROR');
  static const DiagnosticHealthStatus DIAGNOSTIC_HEALTH_STATUS_CRITICAL =
      DiagnosticHealthStatus._(
          4, _omitEnumNames ? '' : 'DIAGNOSTIC_HEALTH_STATUS_CRITICAL');

  static const $core.List<DiagnosticHealthStatus> values =
      <DiagnosticHealthStatus>[
    DIAGNOSTIC_HEALTH_STATUS_UNSPECIFIED,
    DIAGNOSTIC_HEALTH_STATUS_HEALTHY,
    DIAGNOSTIC_HEALTH_STATUS_WARNING,
    DIAGNOSTIC_HEALTH_STATUS_ERROR,
    DIAGNOSTIC_HEALTH_STATUS_CRITICAL,
  ];

  static final $core.List<DiagnosticHealthStatus?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 4);
  static DiagnosticHealthStatus? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const DiagnosticHealthStatus._(super.value, super.name);
}

/// Severity level for a diagnostic issue record.
class DiagnosticSeverity extends $pb.ProtobufEnum {
  static const DiagnosticSeverity DIAGNOSTIC_SEVERITY_UNSPECIFIED =
      DiagnosticSeverity._(
          0, _omitEnumNames ? '' : 'DIAGNOSTIC_SEVERITY_UNSPECIFIED');
  static const DiagnosticSeverity DIAGNOSTIC_SEVERITY_INFO =
      DiagnosticSeverity._(1, _omitEnumNames ? '' : 'DIAGNOSTIC_SEVERITY_INFO');
  static const DiagnosticSeverity DIAGNOSTIC_SEVERITY_WARNING =
      DiagnosticSeverity._(
          2, _omitEnumNames ? '' : 'DIAGNOSTIC_SEVERITY_WARNING');
  static const DiagnosticSeverity DIAGNOSTIC_SEVERITY_ERROR =
      DiagnosticSeverity._(
          3, _omitEnumNames ? '' : 'DIAGNOSTIC_SEVERITY_ERROR');
  static const DiagnosticSeverity DIAGNOSTIC_SEVERITY_CRITICAL =
      DiagnosticSeverity._(
          4, _omitEnumNames ? '' : 'DIAGNOSTIC_SEVERITY_CRITICAL');

  static const $core.List<DiagnosticSeverity> values = <DiagnosticSeverity>[
    DIAGNOSTIC_SEVERITY_UNSPECIFIED,
    DIAGNOSTIC_SEVERITY_INFO,
    DIAGNOSTIC_SEVERITY_WARNING,
    DIAGNOSTIC_SEVERITY_ERROR,
    DIAGNOSTIC_SEVERITY_CRITICAL,
  ];

  static final $core.List<DiagnosticSeverity?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 4);
  static DiagnosticSeverity? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const DiagnosticSeverity._(super.value, super.name);
}

/// Lifecycle status of a diagnostic issue record.
class DiagnosticIssueStatus extends $pb.ProtobufEnum {
  static const DiagnosticIssueStatus DIAGNOSTIC_ISSUE_STATUS_UNSPECIFIED =
      DiagnosticIssueStatus._(
          0, _omitEnumNames ? '' : 'DIAGNOSTIC_ISSUE_STATUS_UNSPECIFIED');
  static const DiagnosticIssueStatus DIAGNOSTIC_ISSUE_STATUS_OPEN =
      DiagnosticIssueStatus._(
          1, _omitEnumNames ? '' : 'DIAGNOSTIC_ISSUE_STATUS_OPEN');
  static const DiagnosticIssueStatus DIAGNOSTIC_ISSUE_STATUS_ACKNOWLEDGED =
      DiagnosticIssueStatus._(
          2, _omitEnumNames ? '' : 'DIAGNOSTIC_ISSUE_STATUS_ACKNOWLEDGED');
  static const DiagnosticIssueStatus DIAGNOSTIC_ISSUE_STATUS_RESOLVING =
      DiagnosticIssueStatus._(
          3, _omitEnumNames ? '' : 'DIAGNOSTIC_ISSUE_STATUS_RESOLVING');
  static const DiagnosticIssueStatus DIAGNOSTIC_ISSUE_STATUS_RESOLVED =
      DiagnosticIssueStatus._(
          4, _omitEnumNames ? '' : 'DIAGNOSTIC_ISSUE_STATUS_RESOLVED');
  static const DiagnosticIssueStatus DIAGNOSTIC_ISSUE_STATUS_CLOSED =
      DiagnosticIssueStatus._(
          5, _omitEnumNames ? '' : 'DIAGNOSTIC_ISSUE_STATUS_CLOSED');

  static const $core.List<DiagnosticIssueStatus> values =
      <DiagnosticIssueStatus>[
    DIAGNOSTIC_ISSUE_STATUS_UNSPECIFIED,
    DIAGNOSTIC_ISSUE_STATUS_OPEN,
    DIAGNOSTIC_ISSUE_STATUS_ACKNOWLEDGED,
    DIAGNOSTIC_ISSUE_STATUS_RESOLVING,
    DIAGNOSTIC_ISSUE_STATUS_RESOLVED,
    DIAGNOSTIC_ISSUE_STATUS_CLOSED,
  ];

  static final $core.List<DiagnosticIssueStatus?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 5);
  static DiagnosticIssueStatus? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const DiagnosticIssueStatus._(super.value, super.name);
}

/// Step identifier in the 4-step guided repair wizard (W125 / M059).
class RepairWizardStep extends $pb.ProtobufEnum {
  static const RepairWizardStep REPAIR_WIZARD_STEP_UNSPECIFIED =
      RepairWizardStep._(
          0, _omitEnumNames ? '' : 'REPAIR_WIZARD_STEP_UNSPECIFIED');
  static const RepairWizardStep REPAIR_WIZARD_STEP_VERIFY =
      RepairWizardStep._(1, _omitEnumNames ? '' : 'REPAIR_WIZARD_STEP_VERIFY');
  static const RepairWizardStep REPAIR_WIZARD_STEP_DIAGNOSE =
      RepairWizardStep._(
          2, _omitEnumNames ? '' : 'REPAIR_WIZARD_STEP_DIAGNOSE');
  static const RepairWizardStep REPAIR_WIZARD_STEP_FIX =
      RepairWizardStep._(3, _omitEnumNames ? '' : 'REPAIR_WIZARD_STEP_FIX');
  static const RepairWizardStep REPAIR_WIZARD_STEP_CONFIRM =
      RepairWizardStep._(4, _omitEnumNames ? '' : 'REPAIR_WIZARD_STEP_CONFIRM');

  static const $core.List<RepairWizardStep> values = <RepairWizardStep>[
    REPAIR_WIZARD_STEP_UNSPECIFIED,
    REPAIR_WIZARD_STEP_VERIFY,
    REPAIR_WIZARD_STEP_DIAGNOSE,
    REPAIR_WIZARD_STEP_FIX,
    REPAIR_WIZARD_STEP_CONFIRM,
  ];

  static final $core.List<RepairWizardStep?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 4);
  static RepairWizardStep? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const RepairWizardStep._(super.value, super.name);
}

const $core.bool _omitEnumNames =
    $core.bool.fromEnvironment('protobuf.omit_enum_names');

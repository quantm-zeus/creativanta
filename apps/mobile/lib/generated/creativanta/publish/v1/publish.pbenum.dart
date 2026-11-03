// This is a generated file - do not edit.
//
// Generated from creativanta/publish/v1/publish.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

/// PublishMode represents the execution mode for a publish item.
class PublishMode extends $pb.ProtobufEnum {
  static const PublishMode PUBLISH_MODE_UNSPECIFIED =
      PublishMode._(0, _omitEnumNames ? '' : 'PUBLISH_MODE_UNSPECIFIED');
  static const PublishMode PUBLISH_MODE_DIRECT =
      PublishMode._(1, _omitEnumNames ? '' : 'PUBLISH_MODE_DIRECT');
  static const PublishMode PUBLISH_MODE_DRAFT =
      PublishMode._(2, _omitEnumNames ? '' : 'PUBLISH_MODE_DRAFT');
  static const PublishMode PUBLISH_MODE_EXPORT =
      PublishMode._(3, _omitEnumNames ? '' : 'PUBLISH_MODE_EXPORT');
  static const PublishMode PUBLISH_MODE_MANUAL =
      PublishMode._(4, _omitEnumNames ? '' : 'PUBLISH_MODE_MANUAL');

  static const $core.List<PublishMode> values = <PublishMode>[
    PUBLISH_MODE_UNSPECIFIED,
    PUBLISH_MODE_DIRECT,
    PUBLISH_MODE_DRAFT,
    PUBLISH_MODE_EXPORT,
    PUBLISH_MODE_MANUAL,
  ];

  static final $core.List<PublishMode?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 4);
  static PublishMode? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const PublishMode._(super.value, super.name);
}

/// PublishItemLifecycleState matches database_schema.md §8.1 publish_items.lifecycle_state.
class PublishItemLifecycleState extends $pb.ProtobufEnum {
  static const PublishItemLifecycleState
      PUBLISH_ITEM_LIFECYCLE_STATE_UNSPECIFIED = PublishItemLifecycleState._(
          0, _omitEnumNames ? '' : 'PUBLISH_ITEM_LIFECYCLE_STATE_UNSPECIFIED');
  static const PublishItemLifecycleState PUBLISH_ITEM_LIFECYCLE_STATE_DRAFT =
      PublishItemLifecycleState._(
          1, _omitEnumNames ? '' : 'PUBLISH_ITEM_LIFECYCLE_STATE_DRAFT');
  static const PublishItemLifecycleState PUBLISH_ITEM_LIFECYCLE_STATE_QUEUED =
      PublishItemLifecycleState._(
          2, _omitEnumNames ? '' : 'PUBLISH_ITEM_LIFECYCLE_STATE_QUEUED');
  static const PublishItemLifecycleState
      PUBLISH_ITEM_LIFECYCLE_STATE_SCHEDULED = PublishItemLifecycleState._(
          3, _omitEnumNames ? '' : 'PUBLISH_ITEM_LIFECYCLE_STATE_SCHEDULED');
  static const PublishItemLifecycleState
      PUBLISH_ITEM_LIFECYCLE_STATE_READY_TO_EXECUTE =
      PublishItemLifecycleState._(
          4,
          _omitEnumNames
              ? ''
              : 'PUBLISH_ITEM_LIFECYCLE_STATE_READY_TO_EXECUTE');
  static const PublishItemLifecycleState
      PUBLISH_ITEM_LIFECYCLE_STATE_EXECUTING = PublishItemLifecycleState._(
          5, _omitEnumNames ? '' : 'PUBLISH_ITEM_LIFECYCLE_STATE_EXECUTING');
  static const PublishItemLifecycleState
      PUBLISH_ITEM_LIFECYCLE_STATE_PUBLISHED = PublishItemLifecycleState._(
          6, _omitEnumNames ? '' : 'PUBLISH_ITEM_LIFECYCLE_STATE_PUBLISHED');
  static const PublishItemLifecycleState
      PUBLISH_ITEM_LIFECYCLE_STATE_PARTIALLY_PUBLISHED =
      PublishItemLifecycleState._(
          7,
          _omitEnumNames
              ? ''
              : 'PUBLISH_ITEM_LIFECYCLE_STATE_PARTIALLY_PUBLISHED');
  static const PublishItemLifecycleState PUBLISH_ITEM_LIFECYCLE_STATE_FAILED =
      PublishItemLifecycleState._(
          8, _omitEnumNames ? '' : 'PUBLISH_ITEM_LIFECYCLE_STATE_FAILED');
  static const PublishItemLifecycleState
      PUBLISH_ITEM_LIFECYCLE_STATE_CANCELLED = PublishItemLifecycleState._(
          9, _omitEnumNames ? '' : 'PUBLISH_ITEM_LIFECYCLE_STATE_CANCELLED');
  static const PublishItemLifecycleState
      PUBLISH_ITEM_LIFECYCLE_STATE_REQUIRES_MANUAL_FALLBACK =
      PublishItemLifecycleState._(
          10,
          _omitEnumNames
              ? ''
              : 'PUBLISH_ITEM_LIFECYCLE_STATE_REQUIRES_MANUAL_FALLBACK');

  static const $core.List<PublishItemLifecycleState> values =
      <PublishItemLifecycleState>[
    PUBLISH_ITEM_LIFECYCLE_STATE_UNSPECIFIED,
    PUBLISH_ITEM_LIFECYCLE_STATE_DRAFT,
    PUBLISH_ITEM_LIFECYCLE_STATE_QUEUED,
    PUBLISH_ITEM_LIFECYCLE_STATE_SCHEDULED,
    PUBLISH_ITEM_LIFECYCLE_STATE_READY_TO_EXECUTE,
    PUBLISH_ITEM_LIFECYCLE_STATE_EXECUTING,
    PUBLISH_ITEM_LIFECYCLE_STATE_PUBLISHED,
    PUBLISH_ITEM_LIFECYCLE_STATE_PARTIALLY_PUBLISHED,
    PUBLISH_ITEM_LIFECYCLE_STATE_FAILED,
    PUBLISH_ITEM_LIFECYCLE_STATE_CANCELLED,
    PUBLISH_ITEM_LIFECYCLE_STATE_REQUIRES_MANUAL_FALLBACK,
  ];

  static final $core.List<PublishItemLifecycleState?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 10);
  static PublishItemLifecycleState? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const PublishItemLifecycleState._(super.value, super.name);
}

/// PublishJobLifecycleState matches database_schema.md §8.2 publish_jobs.lifecycle_state.
class PublishJobLifecycleState extends $pb.ProtobufEnum {
  static const PublishJobLifecycleState
      PUBLISH_JOB_LIFECYCLE_STATE_UNSPECIFIED = PublishJobLifecycleState._(
          0, _omitEnumNames ? '' : 'PUBLISH_JOB_LIFECYCLE_STATE_UNSPECIFIED');
  static const PublishJobLifecycleState PUBLISH_JOB_LIFECYCLE_STATE_CREATED =
      PublishJobLifecycleState._(
          1, _omitEnumNames ? '' : 'PUBLISH_JOB_LIFECYCLE_STATE_CREATED');
  static const PublishJobLifecycleState PUBLISH_JOB_LIFECYCLE_STATE_QUEUED =
      PublishJobLifecycleState._(
          2, _omitEnumNames ? '' : 'PUBLISH_JOB_LIFECYCLE_STATE_QUEUED');
  static const PublishJobLifecycleState PUBLISH_JOB_LIFECYCLE_STATE_DISPATCHED =
      PublishJobLifecycleState._(
          3, _omitEnumNames ? '' : 'PUBLISH_JOB_LIFECYCLE_STATE_DISPATCHED');
  static const PublishJobLifecycleState PUBLISH_JOB_LIFECYCLE_STATE_EXECUTING =
      PublishJobLifecycleState._(
          4, _omitEnumNames ? '' : 'PUBLISH_JOB_LIFECYCLE_STATE_EXECUTING');
  static const PublishJobLifecycleState
      PUBLISH_JOB_LIFECYCLE_STATE_PARTIALLY_SUCCEEDED =
      PublishJobLifecycleState._(
          5,
          _omitEnumNames
              ? ''
              : 'PUBLISH_JOB_LIFECYCLE_STATE_PARTIALLY_SUCCEEDED');
  static const PublishJobLifecycleState PUBLISH_JOB_LIFECYCLE_STATE_SUCCEEDED =
      PublishJobLifecycleState._(
          6, _omitEnumNames ? '' : 'PUBLISH_JOB_LIFECYCLE_STATE_SUCCEEDED');
  static const PublishJobLifecycleState PUBLISH_JOB_LIFECYCLE_STATE_FAILED =
      PublishJobLifecycleState._(
          7, _omitEnumNames ? '' : 'PUBLISH_JOB_LIFECYCLE_STATE_FAILED');
  static const PublishJobLifecycleState PUBLISH_JOB_LIFECYCLE_STATE_CANCELLED =
      PublishJobLifecycleState._(
          8, _omitEnumNames ? '' : 'PUBLISH_JOB_LIFECYCLE_STATE_CANCELLED');
  static const PublishJobLifecycleState
      PUBLISH_JOB_LIFECYCLE_STATE_REQUIRES_MANUAL_FALLBACK =
      PublishJobLifecycleState._(
          9,
          _omitEnumNames
              ? ''
              : 'PUBLISH_JOB_LIFECYCLE_STATE_REQUIRES_MANUAL_FALLBACK');

  static const $core.List<PublishJobLifecycleState> values =
      <PublishJobLifecycleState>[
    PUBLISH_JOB_LIFECYCLE_STATE_UNSPECIFIED,
    PUBLISH_JOB_LIFECYCLE_STATE_CREATED,
    PUBLISH_JOB_LIFECYCLE_STATE_QUEUED,
    PUBLISH_JOB_LIFECYCLE_STATE_DISPATCHED,
    PUBLISH_JOB_LIFECYCLE_STATE_EXECUTING,
    PUBLISH_JOB_LIFECYCLE_STATE_PARTIALLY_SUCCEEDED,
    PUBLISH_JOB_LIFECYCLE_STATE_SUCCEEDED,
    PUBLISH_JOB_LIFECYCLE_STATE_FAILED,
    PUBLISH_JOB_LIFECYCLE_STATE_CANCELLED,
    PUBLISH_JOB_LIFECYCLE_STATE_REQUIRES_MANUAL_FALLBACK,
  ];

  static final $core.List<PublishJobLifecycleState?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 9);
  static PublishJobLifecycleState? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const PublishJobLifecycleState._(super.value, super.name);
}

/// PublishResultStatus matches database_schema.md §8.3 publish_logs.result_status.
class PublishResultStatus extends $pb.ProtobufEnum {
  static const PublishResultStatus PUBLISH_RESULT_STATUS_UNSPECIFIED =
      PublishResultStatus._(
          0, _omitEnumNames ? '' : 'PUBLISH_RESULT_STATUS_UNSPECIFIED');
  static const PublishResultStatus PUBLISH_RESULT_STATUS_SUCCESS =
      PublishResultStatus._(
          1, _omitEnumNames ? '' : 'PUBLISH_RESULT_STATUS_SUCCESS');
  static const PublishResultStatus PUBLISH_RESULT_STATUS_PARTIAL_SUCCESS =
      PublishResultStatus._(
          2, _omitEnumNames ? '' : 'PUBLISH_RESULT_STATUS_PARTIAL_SUCCESS');
  static const PublishResultStatus PUBLISH_RESULT_STATUS_FAILED =
      PublishResultStatus._(
          3, _omitEnumNames ? '' : 'PUBLISH_RESULT_STATUS_FAILED');
  static const PublishResultStatus PUBLISH_RESULT_STATUS_TIMEOUT =
      PublishResultStatus._(
          4, _omitEnumNames ? '' : 'PUBLISH_RESULT_STATUS_TIMEOUT');

  static const $core.List<PublishResultStatus> values = <PublishResultStatus>[
    PUBLISH_RESULT_STATUS_UNSPECIFIED,
    PUBLISH_RESULT_STATUS_SUCCESS,
    PUBLISH_RESULT_STATUS_PARTIAL_SUCCESS,
    PUBLISH_RESULT_STATUS_FAILED,
    PUBLISH_RESULT_STATUS_TIMEOUT,
  ];

  static final $core.List<PublishResultStatus?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 4);
  static PublishResultStatus? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const PublishResultStatus._(super.value, super.name);
}

/// ExecutionPath matches database_schema.md §8.3 publish_logs.execution_path.
class ExecutionPath extends $pb.ProtobufEnum {
  static const ExecutionPath EXECUTION_PATH_UNSPECIFIED =
      ExecutionPath._(0, _omitEnumNames ? '' : 'EXECUTION_PATH_UNSPECIFIED');
  static const ExecutionPath EXECUTION_PATH_NATIVE_API =
      ExecutionPath._(1, _omitEnumNames ? '' : 'EXECUTION_PATH_NATIVE_API');
  static const ExecutionPath EXECUTION_PATH_MANUAL_UPLOAD =
      ExecutionPath._(2, _omitEnumNames ? '' : 'EXECUTION_PATH_MANUAL_UPLOAD');
  static const ExecutionPath EXECUTION_PATH_EXPORT_PACKAGE =
      ExecutionPath._(3, _omitEnumNames ? '' : 'EXECUTION_PATH_EXPORT_PACKAGE');

  static const $core.List<ExecutionPath> values = <ExecutionPath>[
    EXECUTION_PATH_UNSPECIFIED,
    EXECUTION_PATH_NATIVE_API,
    EXECUTION_PATH_MANUAL_UPLOAD,
    EXECUTION_PATH_EXPORT_PACKAGE,
  ];

  static final $core.List<ExecutionPath?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 3);
  static ExecutionPath? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const ExecutionPath._(super.value, super.name);
}

/// DiagnosticsState matches database_schema.md §8.1 publish_items.diagnostics_state.
class DiagnosticsState extends $pb.ProtobufEnum {
  static const DiagnosticsState DIAGNOSTICS_STATE_UNSPECIFIED =
      DiagnosticsState._(
          0, _omitEnumNames ? '' : 'DIAGNOSTICS_STATE_UNSPECIFIED');
  static const DiagnosticsState DIAGNOSTICS_STATE_HEALTHY =
      DiagnosticsState._(1, _omitEnumNames ? '' : 'DIAGNOSTICS_STATE_HEALTHY');
  static const DiagnosticsState DIAGNOSTICS_STATE_WARNING =
      DiagnosticsState._(2, _omitEnumNames ? '' : 'DIAGNOSTICS_STATE_WARNING');
  static const DiagnosticsState DIAGNOSTICS_STATE_DEGRADED =
      DiagnosticsState._(3, _omitEnumNames ? '' : 'DIAGNOSTICS_STATE_DEGRADED');
  static const DiagnosticsState DIAGNOSTICS_STATE_BLOCKED =
      DiagnosticsState._(4, _omitEnumNames ? '' : 'DIAGNOSTICS_STATE_BLOCKED');

  static const $core.List<DiagnosticsState> values = <DiagnosticsState>[
    DIAGNOSTICS_STATE_UNSPECIFIED,
    DIAGNOSTICS_STATE_HEALTHY,
    DIAGNOSTICS_STATE_WARNING,
    DIAGNOSTICS_STATE_DEGRADED,
    DIAGNOSTICS_STATE_BLOCKED,
  ];

  static final $core.List<DiagnosticsState?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 4);
  static DiagnosticsState? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const DiagnosticsState._(super.value, super.name);
}

/// PublishCapabilityState matches capability.Service State values.
class PublishCapabilityState extends $pb.ProtobufEnum {
  static const PublishCapabilityState PUBLISH_CAPABILITY_STATE_UNSPECIFIED =
      PublishCapabilityState._(
          0, _omitEnumNames ? '' : 'PUBLISH_CAPABILITY_STATE_UNSPECIFIED');
  static const PublishCapabilityState PUBLISH_CAPABILITY_STATE_NATIVE =
      PublishCapabilityState._(
          1, _omitEnumNames ? '' : 'PUBLISH_CAPABILITY_STATE_NATIVE');
  static const PublishCapabilityState PUBLISH_CAPABILITY_STATE_READ_ONLY =
      PublishCapabilityState._(
          2, _omitEnumNames ? '' : 'PUBLISH_CAPABILITY_STATE_READ_ONLY');
  static const PublishCapabilityState PUBLISH_CAPABILITY_STATE_MANUAL =
      PublishCapabilityState._(
          3, _omitEnumNames ? '' : 'PUBLISH_CAPABILITY_STATE_MANUAL');
  static const PublishCapabilityState PUBLISH_CAPABILITY_STATE_DEGRADED =
      PublishCapabilityState._(
          4, _omitEnumNames ? '' : 'PUBLISH_CAPABILITY_STATE_DEGRADED');
  static const PublishCapabilityState PUBLISH_CAPABILITY_STATE_UNSUPPORTED =
      PublishCapabilityState._(
          5, _omitEnumNames ? '' : 'PUBLISH_CAPABILITY_STATE_UNSUPPORTED');

  static const $core.List<PublishCapabilityState> values =
      <PublishCapabilityState>[
    PUBLISH_CAPABILITY_STATE_UNSPECIFIED,
    PUBLISH_CAPABILITY_STATE_NATIVE,
    PUBLISH_CAPABILITY_STATE_READ_ONLY,
    PUBLISH_CAPABILITY_STATE_MANUAL,
    PUBLISH_CAPABILITY_STATE_DEGRADED,
    PUBLISH_CAPABILITY_STATE_UNSUPPORTED,
  ];

  static final $core.List<PublishCapabilityState?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 5);
  static PublishCapabilityState? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const PublishCapabilityState._(super.value, super.name);
}

const $core.bool _omitEnumNames =
    $core.bool.fromEnvironment('protobuf.omit_enum_names');

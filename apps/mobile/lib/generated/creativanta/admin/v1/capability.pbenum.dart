// This is a generated file - do not edit.
//
// Generated from creativanta/admin/v1/capability.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

/// Canonical 5 capability states from database_schema.md §3.
class CapabilityState extends $pb.ProtobufEnum {
  static const CapabilityState CAPABILITY_STATE_UNSPECIFIED = CapabilityState._(
      0, _omitEnumNames ? '' : 'CAPABILITY_STATE_UNSPECIFIED');
  static const CapabilityState CAPABILITY_STATE_NATIVE =
      CapabilityState._(1, _omitEnumNames ? '' : 'CAPABILITY_STATE_NATIVE');
  static const CapabilityState CAPABILITY_STATE_READ_ONLY =
      CapabilityState._(2, _omitEnumNames ? '' : 'CAPABILITY_STATE_READ_ONLY');
  static const CapabilityState CAPABILITY_STATE_MANUAL =
      CapabilityState._(3, _omitEnumNames ? '' : 'CAPABILITY_STATE_MANUAL');
  static const CapabilityState CAPABILITY_STATE_DEGRADED =
      CapabilityState._(4, _omitEnumNames ? '' : 'CAPABILITY_STATE_DEGRADED');
  static const CapabilityState CAPABILITY_STATE_UNSUPPORTED = CapabilityState._(
      5, _omitEnumNames ? '' : 'CAPABILITY_STATE_UNSUPPORTED');

  static const $core.List<CapabilityState> values = <CapabilityState>[
    CAPABILITY_STATE_UNSPECIFIED,
    CAPABILITY_STATE_NATIVE,
    CAPABILITY_STATE_READ_ONLY,
    CAPABILITY_STATE_MANUAL,
    CAPABILITY_STATE_DEGRADED,
    CAPABILITY_STATE_UNSUPPORTED,
  ];

  static final $core.List<CapabilityState?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 5);
  static CapabilityState? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const CapabilityState._(super.value, super.name);
}

/// Fallback mechanism type from database_schema.md §18.2C.
class FallbackType extends $pb.ProtobufEnum {
  static const FallbackType FALLBACK_TYPE_UNSPECIFIED =
      FallbackType._(0, _omitEnumNames ? '' : 'FALLBACK_TYPE_UNSPECIFIED');
  static const FallbackType FALLBACK_TYPE_MANUAL_UPLOAD =
      FallbackType._(1, _omitEnumNames ? '' : 'FALLBACK_TYPE_MANUAL_UPLOAD');
  static const FallbackType FALLBACK_TYPE_CSV_IMPORT =
      FallbackType._(2, _omitEnumNames ? '' : 'FALLBACK_TYPE_CSV_IMPORT');
  static const FallbackType FALLBACK_TYPE_WEBHOOK_WORKAROUND = FallbackType._(
      3, _omitEnumNames ? '' : 'FALLBACK_TYPE_WEBHOOK_WORKAROUND');
  static const FallbackType FALLBACK_TYPE_BROWSER_ASSIST =
      FallbackType._(4, _omitEnumNames ? '' : 'FALLBACK_TYPE_BROWSER_ASSIST');
  static const FallbackType FALLBACK_TYPE_UNSUPPORTED =
      FallbackType._(5, _omitEnumNames ? '' : 'FALLBACK_TYPE_UNSUPPORTED');

  static const $core.List<FallbackType> values = <FallbackType>[
    FALLBACK_TYPE_UNSPECIFIED,
    FALLBACK_TYPE_MANUAL_UPLOAD,
    FALLBACK_TYPE_CSV_IMPORT,
    FALLBACK_TYPE_WEBHOOK_WORKAROUND,
    FALLBACK_TYPE_BROWSER_ASSIST,
    FALLBACK_TYPE_UNSUPPORTED,
  ];

  static final $core.List<FallbackType?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 5);
  static FallbackType? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const FallbackType._(super.value, super.name);
}

const $core.bool _omitEnumNames =
    $core.bool.fromEnvironment('protobuf.omit_enum_names');

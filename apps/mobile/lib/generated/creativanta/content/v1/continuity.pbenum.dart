// This is a generated file - do not edit.
//
// Generated from creativanta/content/v1/continuity.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

/// CharacterType denotes the category of character avatar per database_schema.md §7.1.
class CharacterType extends $pb.ProtobufEnum {
  static const CharacterType CHARACTER_TYPE_UNSPECIFIED =
      CharacterType._(0, _omitEnumNames ? '' : 'CHARACTER_TYPE_UNSPECIFIED');
  static const CharacterType CHARACTER_TYPE_DIGITAL_TWIN =
      CharacterType._(1, _omitEnumNames ? '' : 'CHARACTER_TYPE_DIGITAL_TWIN');
  static const CharacterType CHARACTER_TYPE_AI_GENERATED =
      CharacterType._(2, _omitEnumNames ? '' : 'CHARACTER_TYPE_AI_GENERATED');
  static const CharacterType CHARACTER_TYPE_STOCK =
      CharacterType._(3, _omitEnumNames ? '' : 'CHARACTER_TYPE_STOCK');

  static const $core.List<CharacterType> values = <CharacterType>[
    CHARACTER_TYPE_UNSPECIFIED,
    CHARACTER_TYPE_DIGITAL_TWIN,
    CHARACTER_TYPE_AI_GENERATED,
    CHARACTER_TYPE_STOCK,
  ];

  static final $core.List<CharacterType?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 3);
  static CharacterType? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const CharacterType._(super.value, super.name);
}

/// CharacterStatus tracks the lifecycle status of a character per database_schema.md §7.1.
class CharacterStatus extends $pb.ProtobufEnum {
  static const CharacterStatus CHARACTER_STATUS_UNSPECIFIED = CharacterStatus._(
      0, _omitEnumNames ? '' : 'CHARACTER_STATUS_UNSPECIFIED');
  static const CharacterStatus CHARACTER_STATUS_CREATING =
      CharacterStatus._(1, _omitEnumNames ? '' : 'CHARACTER_STATUS_CREATING');
  static const CharacterStatus CHARACTER_STATUS_READY =
      CharacterStatus._(2, _omitEnumNames ? '' : 'CHARACTER_STATUS_READY');
  static const CharacterStatus CHARACTER_STATUS_FAILED =
      CharacterStatus._(3, _omitEnumNames ? '' : 'CHARACTER_STATUS_FAILED');
  static const CharacterStatus CHARACTER_STATUS_ARCHIVED =
      CharacterStatus._(4, _omitEnumNames ? '' : 'CHARACTER_STATUS_ARCHIVED');

  static const $core.List<CharacterStatus> values = <CharacterStatus>[
    CHARACTER_STATUS_UNSPECIFIED,
    CHARACTER_STATUS_CREATING,
    CHARACTER_STATUS_READY,
    CHARACTER_STATUS_FAILED,
    CHARACTER_STATUS_ARCHIVED,
  ];

  static final $core.List<CharacterStatus?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 4);
  static CharacterStatus? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const CharacterStatus._(super.value, super.name);
}

/// PackType denotes the category of continuity pack per database_schema.md §7.2.
class PackType extends $pb.ProtobufEnum {
  static const PackType PACK_TYPE_UNSPECIFIED =
      PackType._(0, _omitEnumNames ? '' : 'PACK_TYPE_UNSPECIFIED');
  static const PackType PACK_TYPE_CHARACTER =
      PackType._(1, _omitEnumNames ? '' : 'PACK_TYPE_CHARACTER');
  static const PackType PACK_TYPE_BRAND =
      PackType._(2, _omitEnumNames ? '' : 'PACK_TYPE_BRAND');
  static const PackType PACK_TYPE_VOICE =
      PackType._(3, _omitEnumNames ? '' : 'PACK_TYPE_VOICE');
  static const PackType PACK_TYPE_STYLE =
      PackType._(4, _omitEnumNames ? '' : 'PACK_TYPE_STYLE');
  static const PackType PACK_TYPE_LOOKBOOK =
      PackType._(5, _omitEnumNames ? '' : 'PACK_TYPE_LOOKBOOK');
  static const PackType PACK_TYPE_SCENE_MEMORY =
      PackType._(6, _omitEnumNames ? '' : 'PACK_TYPE_SCENE_MEMORY');

  static const $core.List<PackType> values = <PackType>[
    PACK_TYPE_UNSPECIFIED,
    PACK_TYPE_CHARACTER,
    PACK_TYPE_BRAND,
    PACK_TYPE_VOICE,
    PACK_TYPE_STYLE,
    PACK_TYPE_LOOKBOOK,
    PACK_TYPE_SCENE_MEMORY,
  ];

  static final $core.List<PackType?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 6);
  static PackType? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const PackType._(super.value, super.name);
}

/// PackStatus tracks the status of a continuity pack per database_schema.md §7.2.
class PackStatus extends $pb.ProtobufEnum {
  static const PackStatus PACK_STATUS_UNSPECIFIED =
      PackStatus._(0, _omitEnumNames ? '' : 'PACK_STATUS_UNSPECIFIED');
  static const PackStatus PACK_STATUS_DRAFT =
      PackStatus._(1, _omitEnumNames ? '' : 'PACK_STATUS_DRAFT');
  static const PackStatus PACK_STATUS_ACTIVE =
      PackStatus._(2, _omitEnumNames ? '' : 'PACK_STATUS_ACTIVE');
  static const PackStatus PACK_STATUS_DEPRECATED =
      PackStatus._(3, _omitEnumNames ? '' : 'PACK_STATUS_DEPRECATED');
  static const PackStatus PACK_STATUS_RETIRED =
      PackStatus._(4, _omitEnumNames ? '' : 'PACK_STATUS_RETIRED');

  static const $core.List<PackStatus> values = <PackStatus>[
    PACK_STATUS_UNSPECIFIED,
    PACK_STATUS_DRAFT,
    PACK_STATUS_ACTIVE,
    PACK_STATUS_DEPRECATED,
    PACK_STATUS_RETIRED,
  ];

  static final $core.List<PackStatus?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 4);
  static PackStatus? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const PackStatus._(super.value, super.name);
}

/// DriftSeverity defines the deviation tier of generated output against canonical references per RULE-M08-005.
class DriftSeverity extends $pb.ProtobufEnum {
  static const DriftSeverity DRIFT_SEVERITY_UNSPECIFIED =
      DriftSeverity._(0, _omitEnumNames ? '' : 'DRIFT_SEVERITY_UNSPECIFIED');
  static const DriftSeverity DRIFT_SEVERITY_NONE =
      DriftSeverity._(1, _omitEnumNames ? '' : 'DRIFT_SEVERITY_NONE');
  static const DriftSeverity DRIFT_SEVERITY_LOW =
      DriftSeverity._(2, _omitEnumNames ? '' : 'DRIFT_SEVERITY_LOW');
  static const DriftSeverity DRIFT_SEVERITY_MODERATE =
      DriftSeverity._(3, _omitEnumNames ? '' : 'DRIFT_SEVERITY_MODERATE');
  static const DriftSeverity DRIFT_SEVERITY_HIGH =
      DriftSeverity._(4, _omitEnumNames ? '' : 'DRIFT_SEVERITY_HIGH');

  static const $core.List<DriftSeverity> values = <DriftSeverity>[
    DRIFT_SEVERITY_UNSPECIFIED,
    DRIFT_SEVERITY_NONE,
    DRIFT_SEVERITY_LOW,
    DRIFT_SEVERITY_MODERATE,
    DRIFT_SEVERITY_HIGH,
  ];

  static final $core.List<DriftSeverity?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 4);
  static DriftSeverity? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const DriftSeverity._(super.value, super.name);
}

/// ConsentType defines the category of user or likeness consent per database_schema.md §18.3.
class ConsentType extends $pb.ProtobufEnum {
  static const ConsentType CONSENT_TYPE_UNSPECIFIED =
      ConsentType._(0, _omitEnumNames ? '' : 'CONSENT_TYPE_UNSPECIFIED');
  static const ConsentType CONSENT_TYPE_DIGITAL_TWIN =
      ConsentType._(1, _omitEnumNames ? '' : 'CONSENT_TYPE_DIGITAL_TWIN');
  static const ConsentType CONSENT_TYPE_VOICE_CLONE =
      ConsentType._(2, _omitEnumNames ? '' : 'CONSENT_TYPE_VOICE_CLONE');
  static const ConsentType CONSENT_TYPE_AI_PROCESSING =
      ConsentType._(3, _omitEnumNames ? '' : 'CONSENT_TYPE_AI_PROCESSING');
  static const ConsentType CONSENT_TYPE_TOS =
      ConsentType._(4, _omitEnumNames ? '' : 'CONSENT_TYPE_TOS');
  static const ConsentType CONSENT_TYPE_PRIVACY =
      ConsentType._(5, _omitEnumNames ? '' : 'CONSENT_TYPE_PRIVACY');

  static const $core.List<ConsentType> values = <ConsentType>[
    CONSENT_TYPE_UNSPECIFIED,
    CONSENT_TYPE_DIGITAL_TWIN,
    CONSENT_TYPE_VOICE_CLONE,
    CONSENT_TYPE_AI_PROCESSING,
    CONSENT_TYPE_TOS,
    CONSENT_TYPE_PRIVACY,
  ];

  static final $core.List<ConsentType?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 5);
  static ConsentType? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const ConsentType._(super.value, super.name);
}

const $core.bool _omitEnumNames =
    $core.bool.fromEnvironment('protobuf.omit_enum_names');

// This is a generated file - do not edit.
//
// Generated from creativanta/content/v1/idea.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

/// IdeaStatus defines canonical idea lifecycle states per database_schema.md §6.1 and idea_engine.md.
class IdeaStatus extends $pb.ProtobufEnum {
  static const IdeaStatus IDEA_STATUS_UNSPECIFIED =
      IdeaStatus._(0, _omitEnumNames ? '' : 'IDEA_STATUS_UNSPECIFIED');
  static const IdeaStatus IDEA_STATUS_DRAFT =
      IdeaStatus._(1, _omitEnumNames ? '' : 'IDEA_STATUS_DRAFT');
  static const IdeaStatus IDEA_STATUS_CANDIDATE =
      IdeaStatus._(2, _omitEnumNames ? '' : 'IDEA_STATUS_CANDIDATE');
  static const IdeaStatus IDEA_STATUS_SELECTED =
      IdeaStatus._(3, _omitEnumNames ? '' : 'IDEA_STATUS_SELECTED');
  static const IdeaStatus IDEA_STATUS_CONVERTED =
      IdeaStatus._(4, _omitEnumNames ? '' : 'IDEA_STATUS_CONVERTED');
  static const IdeaStatus IDEA_STATUS_ARCHIVED =
      IdeaStatus._(5, _omitEnumNames ? '' : 'IDEA_STATUS_ARCHIVED');

  static const $core.List<IdeaStatus> values = <IdeaStatus>[
    IDEA_STATUS_UNSPECIFIED,
    IDEA_STATUS_DRAFT,
    IDEA_STATUS_CANDIDATE,
    IDEA_STATUS_SELECTED,
    IDEA_STATUS_CONVERTED,
    IDEA_STATUS_ARCHIVED,
  ];

  static final $core.List<IdeaStatus?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 5);
  static IdeaStatus? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const IdeaStatus._(super.value, super.name);
}

/// HookType defines classification for hooks in hook bank per database_schema.md §6.3.
class HookType extends $pb.ProtobufEnum {
  static const HookType HOOK_TYPE_UNSPECIFIED =
      HookType._(0, _omitEnumNames ? '' : 'HOOK_TYPE_UNSPECIFIED');
  static const HookType HOOK_TYPE_QUESTION =
      HookType._(1, _omitEnumNames ? '' : 'HOOK_TYPE_QUESTION');
  static const HookType HOOK_TYPE_SHOCK =
      HookType._(2, _omitEnumNames ? '' : 'HOOK_TYPE_SHOCK');
  static const HookType HOOK_TYPE_STORY =
      HookType._(3, _omitEnumNames ? '' : 'HOOK_TYPE_STORY');
  static const HookType HOOK_TYPE_POV =
      HookType._(4, _omitEnumNames ? '' : 'HOOK_TYPE_POV');
  static const HookType HOOK_TYPE_LISTICLE =
      HookType._(5, _omitEnumNames ? '' : 'HOOK_TYPE_LISTICLE');
  static const HookType HOOK_TYPE_CONTRAST =
      HookType._(6, _omitEnumNames ? '' : 'HOOK_TYPE_CONTRAST');

  static const $core.List<HookType> values = <HookType>[
    HOOK_TYPE_UNSPECIFIED,
    HOOK_TYPE_QUESTION,
    HOOK_TYPE_SHOCK,
    HOOK_TYPE_STORY,
    HOOK_TYPE_POV,
    HOOK_TYPE_LISTICLE,
    HOOK_TYPE_CONTRAST,
  ];

  static final $core.List<HookType?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 6);
  static HookType? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const HookType._(super.value, super.name);
}

/// HookSource defines attribution for hooks per database_schema.md §6.3.
class HookSource extends $pb.ProtobufEnum {
  static const HookSource HOOK_SOURCE_UNSPECIFIED =
      HookSource._(0, _omitEnumNames ? '' : 'HOOK_SOURCE_UNSPECIFIED');
  static const HookSource HOOK_SOURCE_MANUAL =
      HookSource._(1, _omitEnumNames ? '' : 'HOOK_SOURCE_MANUAL');
  static const HookSource HOOK_SOURCE_AI_GENERATED =
      HookSource._(2, _omitEnumNames ? '' : 'HOOK_SOURCE_AI_GENERATED');
  static const HookSource HOOK_SOURCE_LIBRARY =
      HookSource._(3, _omitEnumNames ? '' : 'HOOK_SOURCE_LIBRARY');

  static const $core.List<HookSource> values = <HookSource>[
    HOOK_SOURCE_UNSPECIFIED,
    HOOK_SOURCE_MANUAL,
    HOOK_SOURCE_AI_GENERATED,
    HOOK_SOURCE_LIBRARY,
  ];

  static final $core.List<HookSource?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 3);
  static HookSource? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const HookSource._(super.value, super.name);
}

const $core.bool _omitEnumNames =
    $core.bool.fromEnvironment('protobuf.omit_enum_names');

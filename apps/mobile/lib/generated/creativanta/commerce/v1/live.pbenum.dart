// This is a generated file - do not edit.
//
// Generated from creativanta/commerce/v1/live.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

/// LiveSessionStatus tracks the canonical state machine of a live session.
/// RULE-M17-001: planned -> ready -> live -> paused -> ended -> post_live_processing -> closed.
class LiveSessionStatus extends $pb.ProtobufEnum {
  static const LiveSessionStatus LIVE_SESSION_STATUS_UNSPECIFIED =
      LiveSessionStatus._(
          0, _omitEnumNames ? '' : 'LIVE_SESSION_STATUS_UNSPECIFIED');
  static const LiveSessionStatus LIVE_SESSION_STATUS_PLANNED =
      LiveSessionStatus._(
          1, _omitEnumNames ? '' : 'LIVE_SESSION_STATUS_PLANNED');
  static const LiveSessionStatus LIVE_SESSION_STATUS_READY =
      LiveSessionStatus._(2, _omitEnumNames ? '' : 'LIVE_SESSION_STATUS_READY');
  static const LiveSessionStatus LIVE_SESSION_STATUS_LIVE =
      LiveSessionStatus._(3, _omitEnumNames ? '' : 'LIVE_SESSION_STATUS_LIVE');
  static const LiveSessionStatus LIVE_SESSION_STATUS_PAUSED =
      LiveSessionStatus._(
          4, _omitEnumNames ? '' : 'LIVE_SESSION_STATUS_PAUSED');
  static const LiveSessionStatus LIVE_SESSION_STATUS_ENDED =
      LiveSessionStatus._(5, _omitEnumNames ? '' : 'LIVE_SESSION_STATUS_ENDED');
  static const LiveSessionStatus LIVE_SESSION_STATUS_POST_LIVE_PROCESSING =
      LiveSessionStatus._(
          6, _omitEnumNames ? '' : 'LIVE_SESSION_STATUS_POST_LIVE_PROCESSING');
  static const LiveSessionStatus LIVE_SESSION_STATUS_CLOSED =
      LiveSessionStatus._(
          7, _omitEnumNames ? '' : 'LIVE_SESSION_STATUS_CLOSED');

  static const $core.List<LiveSessionStatus> values = <LiveSessionStatus>[
    LIVE_SESSION_STATUS_UNSPECIFIED,
    LIVE_SESSION_STATUS_PLANNED,
    LIVE_SESSION_STATUS_READY,
    LIVE_SESSION_STATUS_LIVE,
    LIVE_SESSION_STATUS_PAUSED,
    LIVE_SESSION_STATUS_ENDED,
    LIVE_SESSION_STATUS_POST_LIVE_PROCESSING,
    LIVE_SESSION_STATUS_CLOSED,
  ];

  static final $core.List<LiveSessionStatus?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 7);
  static LiveSessionStatus? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const LiveSessionStatus._(super.value, super.name);
}

/// CueCardStatus tracks operational state of cue prompts.
class CueCardStatus extends $pb.ProtobufEnum {
  static const CueCardStatus CUE_CARD_STATUS_UNSPECIFIED =
      CueCardStatus._(0, _omitEnumNames ? '' : 'CUE_CARD_STATUS_UNSPECIFIED');
  static const CueCardStatus CUE_CARD_STATUS_PENDING =
      CueCardStatus._(1, _omitEnumNames ? '' : 'CUE_CARD_STATUS_PENDING');
  static const CueCardStatus CUE_CARD_STATUS_ACTIVE =
      CueCardStatus._(2, _omitEnumNames ? '' : 'CUE_CARD_STATUS_ACTIVE');
  static const CueCardStatus CUE_CARD_STATUS_USED =
      CueCardStatus._(3, _omitEnumNames ? '' : 'CUE_CARD_STATUS_USED');
  static const CueCardStatus CUE_CARD_STATUS_SKIPPED =
      CueCardStatus._(4, _omitEnumNames ? '' : 'CUE_CARD_STATUS_SKIPPED');

  static const $core.List<CueCardStatus> values = <CueCardStatus>[
    CUE_CARD_STATUS_UNSPECIFIED,
    CUE_CARD_STATUS_PENDING,
    CUE_CARD_STATUS_ACTIVE,
    CUE_CARD_STATUS_USED,
    CUE_CARD_STATUS_SKIPPED,
  ];

  static final $core.List<CueCardStatus?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 4);
  static CueCardStatus? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const CueCardStatus._(super.value, super.name);
}

const $core.bool _omitEnumNames =
    $core.bool.fromEnvironment('protobuf.omit_enum_names');

// This is a generated file - do not edit.
//
// Generated from creativanta/admin/v1/help.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class KBArticleStatus extends $pb.ProtobufEnum {
  static const KBArticleStatus KB_ARTICLE_STATUS_UNSPECIFIED =
      KBArticleStatus._(
          0, _omitEnumNames ? '' : 'KB_ARTICLE_STATUS_UNSPECIFIED');
  static const KBArticleStatus KB_ARTICLE_STATUS_DRAFT =
      KBArticleStatus._(1, _omitEnumNames ? '' : 'KB_ARTICLE_STATUS_DRAFT');
  static const KBArticleStatus KB_ARTICLE_STATUS_REVIEW =
      KBArticleStatus._(2, _omitEnumNames ? '' : 'KB_ARTICLE_STATUS_REVIEW');
  static const KBArticleStatus KB_ARTICLE_STATUS_PUBLISHED =
      KBArticleStatus._(3, _omitEnumNames ? '' : 'KB_ARTICLE_STATUS_PUBLISHED');
  static const KBArticleStatus KB_ARTICLE_STATUS_ARCHIVED =
      KBArticleStatus._(4, _omitEnumNames ? '' : 'KB_ARTICLE_STATUS_ARCHIVED');

  static const $core.List<KBArticleStatus> values = <KBArticleStatus>[
    KB_ARTICLE_STATUS_UNSPECIFIED,
    KB_ARTICLE_STATUS_DRAFT,
    KB_ARTICLE_STATUS_REVIEW,
    KB_ARTICLE_STATUS_PUBLISHED,
    KB_ARTICLE_STATUS_ARCHIVED,
  ];

  static final $core.List<KBArticleStatus?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 4);
  static KBArticleStatus? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const KBArticleStatus._(super.value, super.name);
}

class KBArticleType extends $pb.ProtobufEnum {
  static const KBArticleType KB_ARTICLE_TYPE_UNSPECIFIED =
      KBArticleType._(0, _omitEnumNames ? '' : 'KB_ARTICLE_TYPE_UNSPECIFIED');
  static const KBArticleType KB_ARTICLE_TYPE_GETTING_STARTED = KBArticleType._(
      1, _omitEnumNames ? '' : 'KB_ARTICLE_TYPE_GETTING_STARTED');
  static const KBArticleType KB_ARTICLE_TYPE_HOW_TO =
      KBArticleType._(2, _omitEnumNames ? '' : 'KB_ARTICLE_TYPE_HOW_TO');
  static const KBArticleType KB_ARTICLE_TYPE_FAQ =
      KBArticleType._(3, _omitEnumNames ? '' : 'KB_ARTICLE_TYPE_FAQ');
  static const KBArticleType KB_ARTICLE_TYPE_TROUBLESHOOTING = KBArticleType._(
      4, _omitEnumNames ? '' : 'KB_ARTICLE_TYPE_TROUBLESHOOTING');
  static const KBArticleType KB_ARTICLE_TYPE_API_REFERENCE =
      KBArticleType._(5, _omitEnumNames ? '' : 'KB_ARTICLE_TYPE_API_REFERENCE');
  static const KBArticleType KB_ARTICLE_TYPE_CHANGELOG =
      KBArticleType._(6, _omitEnumNames ? '' : 'KB_ARTICLE_TYPE_CHANGELOG');

  static const $core.List<KBArticleType> values = <KBArticleType>[
    KB_ARTICLE_TYPE_UNSPECIFIED,
    KB_ARTICLE_TYPE_GETTING_STARTED,
    KB_ARTICLE_TYPE_HOW_TO,
    KB_ARTICLE_TYPE_FAQ,
    KB_ARTICLE_TYPE_TROUBLESHOOTING,
    KB_ARTICLE_TYPE_API_REFERENCE,
    KB_ARTICLE_TYPE_CHANGELOG,
  ];

  static final $core.List<KBArticleType?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 6);
  static KBArticleType? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const KBArticleType._(super.value, super.name);
}

const $core.bool _omitEnumNames =
    $core.bool.fromEnvironment('protobuf.omit_enum_names');

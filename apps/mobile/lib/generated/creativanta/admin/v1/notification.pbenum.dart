// This is a generated file - do not edit.
//
// Generated from creativanta/admin/v1/notification.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

/// Notification priority levels per database_schema.md §13.5
class NotificationPriority extends $pb.ProtobufEnum {
  static const NotificationPriority NOTIFICATION_PRIORITY_UNSPECIFIED =
      NotificationPriority._(
          0, _omitEnumNames ? '' : 'NOTIFICATION_PRIORITY_UNSPECIFIED');
  static const NotificationPriority NOTIFICATION_PRIORITY_LOW =
      NotificationPriority._(
          1, _omitEnumNames ? '' : 'NOTIFICATION_PRIORITY_LOW');
  static const NotificationPriority NOTIFICATION_PRIORITY_NORMAL =
      NotificationPriority._(
          2, _omitEnumNames ? '' : 'NOTIFICATION_PRIORITY_NORMAL');
  static const NotificationPriority NOTIFICATION_PRIORITY_HIGH =
      NotificationPriority._(
          3, _omitEnumNames ? '' : 'NOTIFICATION_PRIORITY_HIGH');
  static const NotificationPriority NOTIFICATION_PRIORITY_URGENT =
      NotificationPriority._(
          4, _omitEnumNames ? '' : 'NOTIFICATION_PRIORITY_URGENT');

  static const $core.List<NotificationPriority> values = <NotificationPriority>[
    NOTIFICATION_PRIORITY_UNSPECIFIED,
    NOTIFICATION_PRIORITY_LOW,
    NOTIFICATION_PRIORITY_NORMAL,
    NOTIFICATION_PRIORITY_HIGH,
    NOTIFICATION_PRIORITY_URGENT,
  ];

  static final $core.List<NotificationPriority?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 4);
  static NotificationPriority? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const NotificationPriority._(super.value, super.name);
}

/// Notification delivery channels per database_schema.md §13.5
class NotificationChannel extends $pb.ProtobufEnum {
  static const NotificationChannel NOTIFICATION_CHANNEL_UNSPECIFIED =
      NotificationChannel._(
          0, _omitEnumNames ? '' : 'NOTIFICATION_CHANNEL_UNSPECIFIED');
  static const NotificationChannel NOTIFICATION_CHANNEL_IN_APP =
      NotificationChannel._(
          1, _omitEnumNames ? '' : 'NOTIFICATION_CHANNEL_IN_APP');
  static const NotificationChannel NOTIFICATION_CHANNEL_PUSH =
      NotificationChannel._(
          2, _omitEnumNames ? '' : 'NOTIFICATION_CHANNEL_PUSH');
  static const NotificationChannel NOTIFICATION_CHANNEL_EMAIL =
      NotificationChannel._(
          3, _omitEnumNames ? '' : 'NOTIFICATION_CHANNEL_EMAIL');

  static const $core.List<NotificationChannel> values = <NotificationChannel>[
    NOTIFICATION_CHANNEL_UNSPECIFIED,
    NOTIFICATION_CHANNEL_IN_APP,
    NOTIFICATION_CHANNEL_PUSH,
    NOTIFICATION_CHANNEL_EMAIL,
  ];

  static final $core.List<NotificationChannel?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 3);
  static NotificationChannel? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const NotificationChannel._(super.value, super.name);
}

const $core.bool _omitEnumNames =
    $core.bool.fromEnvironment('protobuf.omit_enum_names');

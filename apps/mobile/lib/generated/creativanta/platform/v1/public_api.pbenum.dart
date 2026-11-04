// This is a generated file - do not edit.
//
// Generated from creativanta/platform/v1/public_api.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class APIKeyStatus extends $pb.ProtobufEnum {
  static const APIKeyStatus API_KEY_STATUS_UNSPECIFIED =
      APIKeyStatus._(0, _omitEnumNames ? '' : 'API_KEY_STATUS_UNSPECIFIED');
  static const APIKeyStatus API_KEY_STATUS_ACTIVE =
      APIKeyStatus._(1, _omitEnumNames ? '' : 'API_KEY_STATUS_ACTIVE');
  static const APIKeyStatus API_KEY_STATUS_ROTATING =
      APIKeyStatus._(2, _omitEnumNames ? '' : 'API_KEY_STATUS_ROTATING');
  static const APIKeyStatus API_KEY_STATUS_SUSPENDED =
      APIKeyStatus._(3, _omitEnumNames ? '' : 'API_KEY_STATUS_SUSPENDED');
  static const APIKeyStatus API_KEY_STATUS_REVOKED =
      APIKeyStatus._(4, _omitEnumNames ? '' : 'API_KEY_STATUS_REVOKED');
  static const APIKeyStatus API_KEY_STATUS_EXPIRED =
      APIKeyStatus._(5, _omitEnumNames ? '' : 'API_KEY_STATUS_EXPIRED');

  static const $core.List<APIKeyStatus> values = <APIKeyStatus>[
    API_KEY_STATUS_UNSPECIFIED,
    API_KEY_STATUS_ACTIVE,
    API_KEY_STATUS_ROTATING,
    API_KEY_STATUS_SUSPENDED,
    API_KEY_STATUS_REVOKED,
    API_KEY_STATUS_EXPIRED,
  ];

  static final $core.List<APIKeyStatus?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 5);
  static APIKeyStatus? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const APIKeyStatus._(super.value, super.name);
}

class WebhookSubscriptionStatus extends $pb.ProtobufEnum {
  static const WebhookSubscriptionStatus
      WEBHOOK_SUBSCRIPTION_STATUS_UNSPECIFIED = WebhookSubscriptionStatus._(
          0, _omitEnumNames ? '' : 'WEBHOOK_SUBSCRIPTION_STATUS_UNSPECIFIED');
  static const WebhookSubscriptionStatus WEBHOOK_SUBSCRIPTION_STATUS_ACTIVE =
      WebhookSubscriptionStatus._(
          1, _omitEnumNames ? '' : 'WEBHOOK_SUBSCRIPTION_STATUS_ACTIVE');
  static const WebhookSubscriptionStatus WEBHOOK_SUBSCRIPTION_STATUS_SUSPENDED =
      WebhookSubscriptionStatus._(
          2, _omitEnumNames ? '' : 'WEBHOOK_SUBSCRIPTION_STATUS_SUSPENDED');
  static const WebhookSubscriptionStatus WEBHOOK_SUBSCRIPTION_STATUS_REVOKED =
      WebhookSubscriptionStatus._(
          3, _omitEnumNames ? '' : 'WEBHOOK_SUBSCRIPTION_STATUS_REVOKED');

  static const $core.List<WebhookSubscriptionStatus> values =
      <WebhookSubscriptionStatus>[
    WEBHOOK_SUBSCRIPTION_STATUS_UNSPECIFIED,
    WEBHOOK_SUBSCRIPTION_STATUS_ACTIVE,
    WEBHOOK_SUBSCRIPTION_STATUS_SUSPENDED,
    WEBHOOK_SUBSCRIPTION_STATUS_REVOKED,
  ];

  static final $core.List<WebhookSubscriptionStatus?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 3);
  static WebhookSubscriptionStatus? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const WebhookSubscriptionStatus._(super.value, super.name);
}

const $core.bool _omitEnumNames =
    $core.bool.fromEnvironment('protobuf.omit_enum_names');

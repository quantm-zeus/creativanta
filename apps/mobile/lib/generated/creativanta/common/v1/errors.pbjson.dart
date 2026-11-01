// This is a generated file - do not edit.
//
// Generated from creativanta/common/v1/errors.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports
// ignore_for_file: unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use fieldErrorDescriptor instead')
const FieldError$json = {
  '1': 'FieldError',
  '2': [
    {'1': 'field', '3': 1, '4': 1, '5': 9, '10': 'field'},
    {'1': 'reason', '3': 2, '4': 1, '5': 9, '10': 'reason'},
  ],
};

/// Descriptor for `FieldError`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List fieldErrorDescriptor = $convert.base64Decode(
    'CgpGaWVsZEVycm9yEhQKBWZpZWxkGAEgASgJUgVmaWVsZBIWCgZyZWFzb24YAiABKAlSBnJlYX'
    'Nvbg==');

@$core.Deprecated('Use errorDetailDescriptor instead')
const ErrorDetail$json = {
  '1': 'ErrorDetail',
  '2': [
    {'1': 'code', '3': 1, '4': 1, '5': 9, '10': 'code'},
    {'1': 'message', '3': 2, '4': 1, '5': 9, '10': 'message'},
    {
      '1': 'correlation_id',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.UUID',
      '10': 'correlationId'
    },
    {
      '1': 'field_errors',
      '3': 4,
      '4': 3,
      '5': 11,
      '6': '.creativanta.common.v1.FieldError',
      '10': 'fieldErrors'
    },
    {
      '1': 'retry_after_ms',
      '3': 5,
      '4': 1,
      '5': 3,
      '9': 0,
      '10': 'retryAfterMs',
      '17': true
    },
    {'1': 'fallback_action', '3': 6, '4': 1, '5': 9, '10': 'fallbackAction'},
  ],
  '8': [
    {'1': '_retry_after_ms'},
  ],
};

/// Descriptor for `ErrorDetail`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List errorDetailDescriptor = $convert.base64Decode(
    'CgtFcnJvckRldGFpbBISCgRjb2RlGAEgASgJUgRjb2RlEhgKB21lc3NhZ2UYAiABKAlSB21lc3'
    'NhZ2USQgoOY29ycmVsYXRpb25faWQYAyABKAsyGy5jcmVhdGl2YW50YS5jb21tb24udjEuVVVJ'
    'RFINY29ycmVsYXRpb25JZBJECgxmaWVsZF9lcnJvcnMYBCADKAsyIS5jcmVhdGl2YW50YS5jb2'
    '1tb24udjEuRmllbGRFcnJvclILZmllbGRFcnJvcnMSKQoOcmV0cnlfYWZ0ZXJfbXMYBSABKANI'
    'AFIMcmV0cnlBZnRlck1ziAEBEicKD2ZhbGxiYWNrX2FjdGlvbhgGIAEoCVIOZmFsbGJhY2tBY3'
    'Rpb25CEQoPX3JldHJ5X2FmdGVyX21z');

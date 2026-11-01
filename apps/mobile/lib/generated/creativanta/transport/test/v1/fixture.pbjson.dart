// This is a generated file - do not edit.
//
// Generated from creativanta/transport/test/v1/fixture.proto.

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

@$core.Deprecated('Use echoRequestDescriptor instead')
const EchoRequest$json = {
  '1': 'EchoRequest',
  '2': [
    {'1': 'text', '3': 1, '4': 1, '5': 9, '10': 'text'},
    {'1': 'workspace_id', '3': 2, '4': 1, '5': 9, '10': 'workspaceId'},
  ],
};

/// Descriptor for `EchoRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List echoRequestDescriptor = $convert.base64Decode(
    'CgtFY2hvUmVxdWVzdBISCgR0ZXh0GAEgASgJUgR0ZXh0EiEKDHdvcmtzcGFjZV9pZBgCIAEoCV'
    'ILd29ya3NwYWNlSWQ=');

@$core.Deprecated('Use echoResponseDescriptor instead')
const EchoResponse$json = {
  '1': 'EchoResponse',
  '2': [
    {'1': 'text', '3': 1, '4': 1, '5': 9, '10': 'text'},
    {'1': 'workspace_id', '3': 2, '4': 1, '5': 9, '10': 'workspaceId'},
  ],
};

/// Descriptor for `EchoResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List echoResponseDescriptor = $convert.base64Decode(
    'CgxFY2hvUmVzcG9uc2USEgoEdGV4dBgBIAEoCVIEdGV4dBIhCgx3b3Jrc3BhY2VfaWQYAiABKA'
    'lSC3dvcmtzcGFjZUlk');

@$core.Deprecated('Use executeRequestDescriptor instead')
const ExecuteRequest$json = {
  '1': 'ExecuteRequest',
  '2': [
    {
      '1': 'context',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.CommandContext',
      '10': 'context'
    },
    {'1': 'payload', '3': 2, '4': 1, '5': 9, '10': 'payload'},
  ],
};

/// Descriptor for `ExecuteRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List executeRequestDescriptor = $convert.base64Decode(
    'Cg5FeGVjdXRlUmVxdWVzdBI/Cgdjb250ZXh0GAEgASgLMiUuY3JlYXRpdmFudGEuY29tbW9uLn'
    'YxLkNvbW1hbmRDb250ZXh0Ugdjb250ZXh0EhgKB3BheWxvYWQYAiABKAlSB3BheWxvYWQ=');

@$core.Deprecated('Use executeResponseDescriptor instead')
const ExecuteResponse$json = {
  '1': 'ExecuteResponse',
  '2': [
    {'1': 'payload', '3': 1, '4': 1, '5': 9, '10': 'payload'},
    {'1': 'replayed', '3': 2, '4': 1, '5': 8, '10': 'replayed'},
  ],
};

/// Descriptor for `ExecuteResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List executeResponseDescriptor = $convert.base64Decode(
    'Cg9FeGVjdXRlUmVzcG9uc2USGAoHcGF5bG9hZBgBIAEoCVIHcGF5bG9hZBIaCghyZXBsYXllZB'
    'gCIAEoCFIIcmVwbGF5ZWQ=');

@$core.Deprecated('Use listRequestDescriptor instead')
const ListRequest$json = {
  '1': 'ListRequest',
  '2': [
    {
      '1': 'pagination',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.Pagination',
      '10': 'pagination'
    },
    {'1': 'workspace_id', '3': 2, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'filter', '3': 3, '4': 1, '5': 9, '10': 'filter'},
    {'1': 'sort', '3': 4, '4': 1, '5': 9, '10': 'sort'},
  ],
};

/// Descriptor for `ListRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listRequestDescriptor = $convert.base64Decode(
    'CgtMaXN0UmVxdWVzdBJBCgpwYWdpbmF0aW9uGAEgASgLMiEuY3JlYXRpdmFudGEuY29tbW9uLn'
    'YxLlBhZ2luYXRpb25SCnBhZ2luYXRpb24SIQoMd29ya3NwYWNlX2lkGAIgASgJUgt3b3Jrc3Bh'
    'Y2VJZBIWCgZmaWx0ZXIYAyABKAlSBmZpbHRlchISCgRzb3J0GAQgASgJUgRzb3J0');

@$core.Deprecated('Use listResponseDescriptor instead')
const ListResponse$json = {
  '1': 'ListResponse',
  '2': [
    {'1': 'items', '3': 1, '4': 3, '5': 9, '10': 'items'},
    {
      '1': 'pagination',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.PaginatedResponse',
      '10': 'pagination'
    },
  ],
};

/// Descriptor for `ListResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listResponseDescriptor = $convert.base64Decode(
    'CgxMaXN0UmVzcG9uc2USFAoFaXRlbXMYASADKAlSBWl0ZW1zEkgKCnBhZ2luYXRpb24YAiABKA'
    'syKC5jcmVhdGl2YW50YS5jb21tb24udjEuUGFnaW5hdGVkUmVzcG9uc2VSCnBhZ2luYXRpb24=');

@$core.Deprecated('Use watchRequestDescriptor instead')
const WatchRequest$json = {
  '1': 'WatchRequest',
  '2': [
    {'1': 'max_events', '3': 1, '4': 1, '5': 5, '10': 'maxEvents'},
  ],
};

/// Descriptor for `WatchRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List watchRequestDescriptor = $convert.base64Decode(
    'CgxXYXRjaFJlcXVlc3QSHQoKbWF4X2V2ZW50cxgBIAEoBVIJbWF4RXZlbnRz');

@$core.Deprecated('Use watchResponseDescriptor instead')
const WatchResponse$json = {
  '1': 'WatchResponse',
  '2': [
    {'1': 'sequence', '3': 1, '4': 1, '5': 5, '10': 'sequence'},
    {'1': 'message', '3': 2, '4': 1, '5': 9, '10': 'message'},
  ],
};

/// Descriptor for `WatchResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List watchResponseDescriptor = $convert.base64Decode(
    'Cg1XYXRjaFJlc3BvbnNlEhoKCHNlcXVlbmNlGAEgASgFUghzZXF1ZW5jZRIYCgdtZXNzYWdlGA'
    'IgASgJUgdtZXNzYWdl');

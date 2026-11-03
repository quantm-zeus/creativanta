// This is a generated file - do not edit.
//
// Generated from creativanta/content/v1/continuity.proto.

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

@$core.Deprecated('Use characterTypeDescriptor instead')
const CharacterType$json = {
  '1': 'CharacterType',
  '2': [
    {'1': 'CHARACTER_TYPE_UNSPECIFIED', '2': 0},
    {'1': 'CHARACTER_TYPE_DIGITAL_TWIN', '2': 1},
    {'1': 'CHARACTER_TYPE_AI_GENERATED', '2': 2},
    {'1': 'CHARACTER_TYPE_STOCK', '2': 3},
  ],
};

/// Descriptor for `CharacterType`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List characterTypeDescriptor = $convert.base64Decode(
    'Cg1DaGFyYWN0ZXJUeXBlEh4KGkNIQVJBQ1RFUl9UWVBFX1VOU1BFQ0lGSUVEEAASHwobQ0hBUk'
    'FDVEVSX1RZUEVfRElHSVRBTF9UV0lOEAESHwobQ0hBUkFDVEVSX1RZUEVfQUlfR0VORVJBVEVE'
    'EAISGAoUQ0hBUkFDVEVSX1RZUEVfU1RPQ0sQAw==');

@$core.Deprecated('Use characterStatusDescriptor instead')
const CharacterStatus$json = {
  '1': 'CharacterStatus',
  '2': [
    {'1': 'CHARACTER_STATUS_UNSPECIFIED', '2': 0},
    {'1': 'CHARACTER_STATUS_CREATING', '2': 1},
    {'1': 'CHARACTER_STATUS_READY', '2': 2},
    {'1': 'CHARACTER_STATUS_FAILED', '2': 3},
    {'1': 'CHARACTER_STATUS_ARCHIVED', '2': 4},
  ],
};

/// Descriptor for `CharacterStatus`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List characterStatusDescriptor = $convert.base64Decode(
    'Cg9DaGFyYWN0ZXJTdGF0dXMSIAocQ0hBUkFDVEVSX1NUQVRVU19VTlNQRUNJRklFRBAAEh0KGU'
    'NIQVJBQ1RFUl9TVEFUVVNfQ1JFQVRJTkcQARIaChZDSEFSQUNURVJfU1RBVFVTX1JFQURZEAIS'
    'GwoXQ0hBUkFDVEVSX1NUQVRVU19GQUlMRUQQAxIdChlDSEFSQUNURVJfU1RBVFVTX0FSQ0hJVk'
    'VEEAQ=');

@$core.Deprecated('Use packTypeDescriptor instead')
const PackType$json = {
  '1': 'PackType',
  '2': [
    {'1': 'PACK_TYPE_UNSPECIFIED', '2': 0},
    {'1': 'PACK_TYPE_CHARACTER', '2': 1},
    {'1': 'PACK_TYPE_BRAND', '2': 2},
    {'1': 'PACK_TYPE_VOICE', '2': 3},
    {'1': 'PACK_TYPE_STYLE', '2': 4},
    {'1': 'PACK_TYPE_LOOKBOOK', '2': 5},
    {'1': 'PACK_TYPE_SCENE_MEMORY', '2': 6},
  ],
};

/// Descriptor for `PackType`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List packTypeDescriptor = $convert.base64Decode(
    'CghQYWNrVHlwZRIZChVQQUNLX1RZUEVfVU5TUEVDSUZJRUQQABIXChNQQUNLX1RZUEVfQ0hBUk'
    'FDVEVSEAESEwoPUEFDS19UWVBFX0JSQU5EEAISEwoPUEFDS19UWVBFX1ZPSUNFEAMSEwoPUEFD'
    'S19UWVBFX1NUWUxFEAQSFgoSUEFDS19UWVBFX0xPT0tCT09LEAUSGgoWUEFDS19UWVBFX1NDRU'
    '5FX01FTU9SWRAG');

@$core.Deprecated('Use packStatusDescriptor instead')
const PackStatus$json = {
  '1': 'PackStatus',
  '2': [
    {'1': 'PACK_STATUS_UNSPECIFIED', '2': 0},
    {'1': 'PACK_STATUS_DRAFT', '2': 1},
    {'1': 'PACK_STATUS_ACTIVE', '2': 2},
    {'1': 'PACK_STATUS_DEPRECATED', '2': 3},
    {'1': 'PACK_STATUS_RETIRED', '2': 4},
  ],
};

/// Descriptor for `PackStatus`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List packStatusDescriptor = $convert.base64Decode(
    'CgpQYWNrU3RhdHVzEhsKF1BBQ0tfU1RBVFVTX1VOU1BFQ0lGSUVEEAASFQoRUEFDS19TVEFUVV'
    'NfRFJBRlQQARIWChJQQUNLX1NUQVRVU19BQ1RJVkUQAhIaChZQQUNLX1NUQVRVU19ERVBSRUNB'
    'VEVEEAMSFwoTUEFDS19TVEFUVVNfUkVUSVJFRBAE');

@$core.Deprecated('Use driftSeverityDescriptor instead')
const DriftSeverity$json = {
  '1': 'DriftSeverity',
  '2': [
    {'1': 'DRIFT_SEVERITY_UNSPECIFIED', '2': 0},
    {'1': 'DRIFT_SEVERITY_NONE', '2': 1},
    {'1': 'DRIFT_SEVERITY_LOW', '2': 2},
    {'1': 'DRIFT_SEVERITY_MODERATE', '2': 3},
    {'1': 'DRIFT_SEVERITY_HIGH', '2': 4},
  ],
};

/// Descriptor for `DriftSeverity`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List driftSeverityDescriptor = $convert.base64Decode(
    'Cg1EcmlmdFNldmVyaXR5Eh4KGkRSSUZUX1NFVkVSSVRZX1VOU1BFQ0lGSUVEEAASFwoTRFJJRl'
    'RfU0VWRVJJVFlfTk9ORRABEhYKEkRSSUZUX1NFVkVSSVRZX0xPVxACEhsKF0RSSUZUX1NFVkVS'
    'SVRZX01PREVSQVRFEAMSFwoTRFJJRlRfU0VWRVJJVFlfSElHSBAE');

@$core.Deprecated('Use consentTypeDescriptor instead')
const ConsentType$json = {
  '1': 'ConsentType',
  '2': [
    {'1': 'CONSENT_TYPE_UNSPECIFIED', '2': 0},
    {'1': 'CONSENT_TYPE_DIGITAL_TWIN', '2': 1},
    {'1': 'CONSENT_TYPE_VOICE_CLONE', '2': 2},
    {'1': 'CONSENT_TYPE_AI_PROCESSING', '2': 3},
    {'1': 'CONSENT_TYPE_TOS', '2': 4},
    {'1': 'CONSENT_TYPE_PRIVACY', '2': 5},
  ],
};

/// Descriptor for `ConsentType`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List consentTypeDescriptor = $convert.base64Decode(
    'CgtDb25zZW50VHlwZRIcChhDT05TRU5UX1RZUEVfVU5TUEVDSUZJRUQQABIdChlDT05TRU5UX1'
    'RZUEVfRElHSVRBTF9UV0lOEAESHAoYQ09OU0VOVF9UWVBFX1ZPSUNFX0NMT05FEAISHgoaQ09O'
    'U0VOVF9UWVBFX0FJX1BST0NFU1NJTkcQAxIUChBDT05TRU5UX1RZUEVfVE9TEAQSGAoUQ09OU0'
    'VOVF9UWVBFX1BSSVZBQ1kQBQ==');

@$core.Deprecated('Use approvedReferenceDescriptor instead')
const ApprovedReference$json = {
  '1': 'ApprovedReference',
  '2': [
    {'1': 'reference_id', '3': 1, '4': 1, '5': 9, '10': 'referenceId'},
    {'1': 'pack_id', '3': 2, '4': 1, '5': 9, '10': 'packId'},
    {'1': 'asset_id', '3': 3, '4': 1, '5': 9, '10': 'assetId'},
    {'1': 'script_id', '3': 4, '4': 1, '5': 9, '10': 'scriptId'},
    {'1': 'name', '3': 5, '4': 1, '5': 9, '10': 'name'},
    {'1': 'media_url', '3': 6, '4': 1, '5': 9, '10': 'mediaUrl'},
    {'1': 'reference_type', '3': 7, '4': 1, '5': 9, '10': 'referenceType'},
    {'1': 'source_context', '3': 8, '4': 1, '5': 9, '10': 'sourceContext'},
    {'1': 'status', '3': 9, '4': 1, '5': 9, '10': 'status'},
    {
      '1': 'created_at',
      '3': 10,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'createdAt'
    },
  ],
};

/// Descriptor for `ApprovedReference`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List approvedReferenceDescriptor = $convert.base64Decode(
    'ChFBcHByb3ZlZFJlZmVyZW5jZRIhCgxyZWZlcmVuY2VfaWQYASABKAlSC3JlZmVyZW5jZUlkEh'
    'cKB3BhY2tfaWQYAiABKAlSBnBhY2tJZBIZCghhc3NldF9pZBgDIAEoCVIHYXNzZXRJZBIbCglz'
    'Y3JpcHRfaWQYBCABKAlSCHNjcmlwdElkEhIKBG5hbWUYBSABKAlSBG5hbWUSGwoJbWVkaWFfdX'
    'JsGAYgASgJUghtZWRpYVVybBIlCg5yZWZlcmVuY2VfdHlwZRgHIAEoCVINcmVmZXJlbmNlVHlw'
    'ZRIlCg5zb3VyY2VfY29udGV4dBgIIAEoCVINc291cmNlQ29udGV4dBIWCgZzdGF0dXMYCSABKA'
    'lSBnN0YXR1cxI5CgpjcmVhdGVkX2F0GAogASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFt'
    'cFIJY3JlYXRlZEF0');

@$core.Deprecated('Use packVersionDescriptor instead')
const PackVersion$json = {
  '1': 'PackVersion',
  '2': [
    {'1': 'version_id', '3': 1, '4': 1, '5': 9, '10': 'versionId'},
    {'1': 'workspace_id', '3': 2, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'pack_id', '3': 3, '4': 1, '5': 9, '10': 'packId'},
    {'1': 'version_index', '3': 4, '4': 1, '5': 5, '10': 'versionIndex'},
    {'1': 'name', '3': 5, '4': 1, '5': 9, '10': 'name'},
    {
      '1': 'pack_type',
      '3': 6,
      '4': 1,
      '5': 14,
      '6': '.creativanta.content.v1.PackType',
      '10': 'packType'
    },
    {
      '1': 'approved_references',
      '3': 7,
      '4': 3,
      '5': 11,
      '6': '.creativanta.content.v1.ApprovedReference',
      '10': 'approvedReferences'
    },
    {'1': 'rules_summary', '3': 8, '4': 1, '5': 9, '10': 'rulesSummary'},
    {'1': 'settings_json', '3': 9, '4': 1, '5': 9, '10': 'settingsJson'},
    {
      '1': 'allowed_use_scope_json',
      '3': 10,
      '4': 1,
      '5': 9,
      '10': 'allowedUseScopeJson'
    },
    {
      '1': 'status',
      '3': 11,
      '4': 1,
      '5': 14,
      '6': '.creativanta.content.v1.PackStatus',
      '10': 'status'
    },
    {'1': 'snapshot_reason', '3': 12, '4': 1, '5': 9, '10': 'snapshotReason'},
    {
      '1': 'created_at',
      '3': 13,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'createdAt'
    },
  ],
};

/// Descriptor for `PackVersion`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List packVersionDescriptor = $convert.base64Decode(
    'CgtQYWNrVmVyc2lvbhIdCgp2ZXJzaW9uX2lkGAEgASgJUgl2ZXJzaW9uSWQSIQoMd29ya3NwYW'
    'NlX2lkGAIgASgJUgt3b3Jrc3BhY2VJZBIXCgdwYWNrX2lkGAMgASgJUgZwYWNrSWQSIwoNdmVy'
    'c2lvbl9pbmRleBgEIAEoBVIMdmVyc2lvbkluZGV4EhIKBG5hbWUYBSABKAlSBG5hbWUSPQoJcG'
    'Fja190eXBlGAYgASgOMiAuY3JlYXRpdmFudGEuY29udGVudC52MS5QYWNrVHlwZVIIcGFja1R5'
    'cGUSWgoTYXBwcm92ZWRfcmVmZXJlbmNlcxgHIAMoCzIpLmNyZWF0aXZhbnRhLmNvbnRlbnQudj'
    'EuQXBwcm92ZWRSZWZlcmVuY2VSEmFwcHJvdmVkUmVmZXJlbmNlcxIjCg1ydWxlc19zdW1tYXJ5'
    'GAggASgJUgxydWxlc1N1bW1hcnkSIwoNc2V0dGluZ3NfanNvbhgJIAEoCVIMc2V0dGluZ3NKc2'
    '9uEjMKFmFsbG93ZWRfdXNlX3Njb3BlX2pzb24YCiABKAlSE2FsbG93ZWRVc2VTY29wZUpzb24S'
    'OgoGc3RhdHVzGAsgASgOMiIuY3JlYXRpdmFudGEuY29udGVudC52MS5QYWNrU3RhdHVzUgZzdG'
    'F0dXMSJwoPc25hcHNob3RfcmVhc29uGAwgASgJUg5zbmFwc2hvdFJlYXNvbhI5CgpjcmVhdGVk'
    'X2F0GA0gASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIJY3JlYXRlZEF0');

@$core.Deprecated('Use continuityPackDescriptor instead')
const ContinuityPack$json = {
  '1': 'ContinuityPack',
  '2': [
    {'1': 'pack_id', '3': 1, '4': 1, '5': 9, '10': 'packId'},
    {'1': 'workspace_id', '3': 2, '4': 1, '5': 9, '10': 'workspaceId'},
    {
      '1': 'pack_type',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.creativanta.content.v1.PackType',
      '10': 'packType'
    },
    {'1': 'name', '3': 4, '4': 1, '5': 9, '10': 'name'},
    {'1': 'character_id', '3': 5, '4': 1, '5': 9, '10': 'characterId'},
    {
      '1': 'approved_references',
      '3': 6,
      '4': 3,
      '5': 11,
      '6': '.creativanta.content.v1.ApprovedReference',
      '10': 'approvedReferences'
    },
    {'1': 'rules_summary', '3': 7, '4': 1, '5': 9, '10': 'rulesSummary'},
    {'1': 'settings_json', '3': 8, '4': 1, '5': 9, '10': 'settingsJson'},
    {
      '1': 'allowed_use_scope_json',
      '3': 9,
      '4': 1,
      '5': 9,
      '10': 'allowedUseScopeJson'
    },
    {'1': 'version', '3': 10, '4': 1, '5': 5, '10': 'version'},
    {'1': 'parent_pack_id', '3': 11, '4': 1, '5': 9, '10': 'parentPackId'},
    {
      '1': 'status',
      '3': 12,
      '4': 1,
      '5': 14,
      '6': '.creativanta.content.v1.PackStatus',
      '10': 'status'
    },
    {
      '1': 'created_at',
      '3': 13,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'createdAt'
    },
    {
      '1': 'updated_at',
      '3': 14,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'updatedAt'
    },
  ],
};

/// Descriptor for `ContinuityPack`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List continuityPackDescriptor = $convert.base64Decode(
    'Cg5Db250aW51aXR5UGFjaxIXCgdwYWNrX2lkGAEgASgJUgZwYWNrSWQSIQoMd29ya3NwYWNlX2'
    'lkGAIgASgJUgt3b3Jrc3BhY2VJZBI9CglwYWNrX3R5cGUYAyABKA4yIC5jcmVhdGl2YW50YS5j'
    'b250ZW50LnYxLlBhY2tUeXBlUghwYWNrVHlwZRISCgRuYW1lGAQgASgJUgRuYW1lEiEKDGNoYX'
    'JhY3Rlcl9pZBgFIAEoCVILY2hhcmFjdGVySWQSWgoTYXBwcm92ZWRfcmVmZXJlbmNlcxgGIAMo'
    'CzIpLmNyZWF0aXZhbnRhLmNvbnRlbnQudjEuQXBwcm92ZWRSZWZlcmVuY2VSEmFwcHJvdmVkUm'
    'VmZXJlbmNlcxIjCg1ydWxlc19zdW1tYXJ5GAcgASgJUgxydWxlc1N1bW1hcnkSIwoNc2V0dGlu'
    'Z3NfanNvbhgIIAEoCVIMc2V0dGluZ3NKc29uEjMKFmFsbG93ZWRfdXNlX3Njb3BlX2pzb24YCS'
    'ABKAlSE2FsbG93ZWRVc2VTY29wZUpzb24SGAoHdmVyc2lvbhgKIAEoBVIHdmVyc2lvbhIkCg5w'
    'YXJlbnRfcGFja19pZBgLIAEoCVIMcGFyZW50UGFja0lkEjoKBnN0YXR1cxgMIAEoDjIiLmNyZW'
    'F0aXZhbnRhLmNvbnRlbnQudjEuUGFja1N0YXR1c1IGc3RhdHVzEjkKCmNyZWF0ZWRfYXQYDSAB'
    'KAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUgljcmVhdGVkQXQSOQoKdXBkYXRlZF9hdB'
    'gOIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSCXVwZGF0ZWRBdA==');

@$core.Deprecated('Use consentRecordDescriptor instead')
const ConsentRecord$json = {
  '1': 'ConsentRecord',
  '2': [
    {'1': 'consent_id', '3': 1, '4': 1, '5': 9, '10': 'consentId'},
    {'1': 'user_id', '3': 2, '4': 1, '5': 9, '10': 'userId'},
    {'1': 'workspace_id', '3': 3, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'consent_type', '3': 4, '4': 1, '5': 9, '10': 'consentType'},
    {'1': 'version', '3': 5, '4': 1, '5': 9, '10': 'version'},
    {'1': 'granted', '3': 6, '4': 1, '5': 8, '10': 'granted'},
    {
      '1': 'granted_at',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'grantedAt'
    },
    {
      '1': 'revoked_at',
      '3': 8,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'revokedAt'
    },
    {'1': 'ip_address', '3': 9, '4': 1, '5': 9, '10': 'ipAddress'},
    {'1': 'user_agent', '3': 10, '4': 1, '5': 9, '10': 'userAgent'},
    {
      '1': 'created_at',
      '3': 11,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'createdAt'
    },
  ],
};

/// Descriptor for `ConsentRecord`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List consentRecordDescriptor = $convert.base64Decode(
    'Cg1Db25zZW50UmVjb3JkEh0KCmNvbnNlbnRfaWQYASABKAlSCWNvbnNlbnRJZBIXCgd1c2VyX2'
    'lkGAIgASgJUgZ1c2VySWQSIQoMd29ya3NwYWNlX2lkGAMgASgJUgt3b3Jrc3BhY2VJZBIhCgxj'
    'b25zZW50X3R5cGUYBCABKAlSC2NvbnNlbnRUeXBlEhgKB3ZlcnNpb24YBSABKAlSB3ZlcnNpb2'
    '4SGAoHZ3JhbnRlZBgGIAEoCFIHZ3JhbnRlZBI5CgpncmFudGVkX2F0GAcgASgLMhouZ29vZ2xl'
    'LnByb3RvYnVmLlRpbWVzdGFtcFIJZ3JhbnRlZEF0EjkKCnJldm9rZWRfYXQYCCABKAsyGi5nb2'
    '9nbGUucHJvdG9idWYuVGltZXN0YW1wUglyZXZva2VkQXQSHQoKaXBfYWRkcmVzcxgJIAEoCVIJ'
    'aXBBZGRyZXNzEh0KCnVzZXJfYWdlbnQYCiABKAlSCXVzZXJBZ2VudBI5CgpjcmVhdGVkX2F0GA'
    'sgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIJY3JlYXRlZEF0');

@$core.Deprecated('Use characterDescriptor instead')
const Character$json = {
  '1': 'Character',
  '2': [
    {'1': 'character_id', '3': 1, '4': 1, '5': 9, '10': 'characterId'},
    {'1': 'workspace_id', '3': 2, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'name', '3': 3, '4': 1, '5': 9, '10': 'name'},
    {
      '1': 'character_type',
      '3': 4,
      '4': 1,
      '5': 14,
      '6': '.creativanta.content.v1.CharacterType',
      '10': 'characterType'
    },
    {'1': 'description', '3': 5, '4': 1, '5': 9, '10': 'description'},
    {
      '1': 'reference_images_json',
      '3': 6,
      '4': 1,
      '5': 9,
      '10': 'referenceImagesJson'
    },
    {
      '1': 'voice_settings_json',
      '3': 7,
      '4': 1,
      '5': 9,
      '10': 'voiceSettingsJson'
    },
    {
      '1': 'visual_settings_json',
      '3': 8,
      '4': 1,
      '5': 9,
      '10': 'visualSettingsJson'
    },
    {'1': 'consent_verified', '3': 9, '4': 1, '5': 8, '10': 'consentVerified'},
    {
      '1': 'consent_record_id',
      '3': 10,
      '4': 1,
      '5': 9,
      '10': 'consentRecordId'
    },
    {'1': 'is_default', '3': 11, '4': 1, '5': 8, '10': 'isDefault'},
    {
      '1': 'status',
      '3': 12,
      '4': 1,
      '5': 14,
      '6': '.creativanta.content.v1.CharacterStatus',
      '10': 'status'
    },
    {
      '1': 'character_pack_id',
      '3': 13,
      '4': 1,
      '5': 9,
      '10': 'characterPackId'
    },
    {
      '1': 'created_at',
      '3': 14,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'createdAt'
    },
    {
      '1': 'updated_at',
      '3': 15,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'updatedAt'
    },
  ],
};

/// Descriptor for `Character`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List characterDescriptor = $convert.base64Decode(
    'CglDaGFyYWN0ZXISIQoMY2hhcmFjdGVyX2lkGAEgASgJUgtjaGFyYWN0ZXJJZBIhCgx3b3Jrc3'
    'BhY2VfaWQYAiABKAlSC3dvcmtzcGFjZUlkEhIKBG5hbWUYAyABKAlSBG5hbWUSTAoOY2hhcmFj'
    'dGVyX3R5cGUYBCABKA4yJS5jcmVhdGl2YW50YS5jb250ZW50LnYxLkNoYXJhY3RlclR5cGVSDW'
    'NoYXJhY3RlclR5cGUSIAoLZGVzY3JpcHRpb24YBSABKAlSC2Rlc2NyaXB0aW9uEjIKFXJlZmVy'
    'ZW5jZV9pbWFnZXNfanNvbhgGIAEoCVITcmVmZXJlbmNlSW1hZ2VzSnNvbhIuChN2b2ljZV9zZX'
    'R0aW5nc19qc29uGAcgASgJUhF2b2ljZVNldHRpbmdzSnNvbhIwChR2aXN1YWxfc2V0dGluZ3Nf'
    'anNvbhgIIAEoCVISdmlzdWFsU2V0dGluZ3NKc29uEikKEGNvbnNlbnRfdmVyaWZpZWQYCSABKA'
    'hSD2NvbnNlbnRWZXJpZmllZBIqChFjb25zZW50X3JlY29yZF9pZBgKIAEoCVIPY29uc2VudFJl'
    'Y29yZElkEh0KCmlzX2RlZmF1bHQYCyABKAhSCWlzRGVmYXVsdBI/CgZzdGF0dXMYDCABKA4yJy'
    '5jcmVhdGl2YW50YS5jb250ZW50LnYxLkNoYXJhY3RlclN0YXR1c1IGc3RhdHVzEioKEWNoYXJh'
    'Y3Rlcl9wYWNrX2lkGA0gASgJUg9jaGFyYWN0ZXJQYWNrSWQSOQoKY3JlYXRlZF9hdBgOIAEoCz'
    'IaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSCWNyZWF0ZWRBdBI5Cgp1cGRhdGVkX2F0GA8g'
    'ASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIJdXBkYXRlZEF0');

@$core.Deprecated('Use characterServiceCreateRequestDescriptor instead')
const CharacterServiceCreateRequest$json = {
  '1': 'CharacterServiceCreateRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    {
      '1': 'character_type',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.creativanta.content.v1.CharacterType',
      '10': 'characterType'
    },
    {'1': 'description', '3': 4, '4': 1, '5': 9, '10': 'description'},
    {
      '1': 'reference_images_json',
      '3': 5,
      '4': 1,
      '5': 9,
      '10': 'referenceImagesJson'
    },
    {
      '1': 'voice_settings_json',
      '3': 6,
      '4': 1,
      '5': 9,
      '10': 'voiceSettingsJson'
    },
    {
      '1': 'visual_settings_json',
      '3': 7,
      '4': 1,
      '5': 9,
      '10': 'visualSettingsJson'
    },
    {'1': 'is_default', '3': 8, '4': 1, '5': 8, '10': 'isDefault'},
    {'1': 'consent_record_id', '3': 9, '4': 1, '5': 9, '10': 'consentRecordId'},
    {'1': 'wizard_step', '3': 10, '4': 1, '5': 5, '10': 'wizardStep'},
    {'1': 'preview_verified', '3': 11, '4': 1, '5': 8, '10': 'previewVerified'},
    {
      '1': 'preview_video_url',
      '3': 12,
      '4': 1,
      '5': 9,
      '10': 'previewVideoUrl'
    },
  ],
};

/// Descriptor for `CharacterServiceCreateRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List characterServiceCreateRequestDescriptor = $convert.base64Decode(
    'Ch1DaGFyYWN0ZXJTZXJ2aWNlQ3JlYXRlUmVxdWVzdBIhCgx3b3Jrc3BhY2VfaWQYASABKAlSC3'
    'dvcmtzcGFjZUlkEhIKBG5hbWUYAiABKAlSBG5hbWUSTAoOY2hhcmFjdGVyX3R5cGUYAyABKA4y'
    'JS5jcmVhdGl2YW50YS5jb250ZW50LnYxLkNoYXJhY3RlclR5cGVSDWNoYXJhY3RlclR5cGUSIA'
    'oLZGVzY3JpcHRpb24YBCABKAlSC2Rlc2NyaXB0aW9uEjIKFXJlZmVyZW5jZV9pbWFnZXNfanNv'
    'bhgFIAEoCVITcmVmZXJlbmNlSW1hZ2VzSnNvbhIuChN2b2ljZV9zZXR0aW5nc19qc29uGAYgAS'
    'gJUhF2b2ljZVNldHRpbmdzSnNvbhIwChR2aXN1YWxfc2V0dGluZ3NfanNvbhgHIAEoCVISdmlz'
    'dWFsU2V0dGluZ3NKc29uEh0KCmlzX2RlZmF1bHQYCCABKAhSCWlzRGVmYXVsdBIqChFjb25zZW'
    '50X3JlY29yZF9pZBgJIAEoCVIPY29uc2VudFJlY29yZElkEh8KC3dpemFyZF9zdGVwGAogASgF'
    'Ugp3aXphcmRTdGVwEikKEHByZXZpZXdfdmVyaWZpZWQYCyABKAhSD3ByZXZpZXdWZXJpZmllZB'
    'IqChFwcmV2aWV3X3ZpZGVvX3VybBgMIAEoCVIPcHJldmlld1ZpZGVvVXJs');

@$core.Deprecated('Use characterServiceCreateResponseDescriptor instead')
const CharacterServiceCreateResponse$json = {
  '1': 'CharacterServiceCreateResponse',
  '2': [
    {
      '1': 'character',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.content.v1.Character',
      '10': 'character'
    },
    {
      '1': 'character_pack',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.creativanta.content.v1.ContinuityPack',
      '10': 'characterPack'
    },
  ],
};

/// Descriptor for `CharacterServiceCreateResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List characterServiceCreateResponseDescriptor =
    $convert.base64Decode(
        'Ch5DaGFyYWN0ZXJTZXJ2aWNlQ3JlYXRlUmVzcG9uc2USPwoJY2hhcmFjdGVyGAEgASgLMiEuY3'
        'JlYXRpdmFudGEuY29udGVudC52MS5DaGFyYWN0ZXJSCWNoYXJhY3RlchJNCg5jaGFyYWN0ZXJf'
        'cGFjaxgCIAEoCzImLmNyZWF0aXZhbnRhLmNvbnRlbnQudjEuQ29udGludWl0eVBhY2tSDWNoYX'
        'JhY3RlclBhY2s=');

@$core.Deprecated('Use characterServiceGetRequestDescriptor instead')
const CharacterServiceGetRequest$json = {
  '1': 'CharacterServiceGetRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'character_id', '3': 2, '4': 1, '5': 9, '10': 'characterId'},
  ],
};

/// Descriptor for `CharacterServiceGetRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List characterServiceGetRequestDescriptor =
    $convert.base64Decode(
        'ChpDaGFyYWN0ZXJTZXJ2aWNlR2V0UmVxdWVzdBIhCgx3b3Jrc3BhY2VfaWQYASABKAlSC3dvcm'
        'tzcGFjZUlkEiEKDGNoYXJhY3Rlcl9pZBgCIAEoCVILY2hhcmFjdGVySWQ=');

@$core.Deprecated('Use characterServiceGetResponseDescriptor instead')
const CharacterServiceGetResponse$json = {
  '1': 'CharacterServiceGetResponse',
  '2': [
    {
      '1': 'character',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.content.v1.Character',
      '10': 'character'
    },
    {
      '1': 'character_pack',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.creativanta.content.v1.ContinuityPack',
      '10': 'characterPack'
    },
  ],
};

/// Descriptor for `CharacterServiceGetResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List characterServiceGetResponseDescriptor = $convert.base64Decode(
    'ChtDaGFyYWN0ZXJTZXJ2aWNlR2V0UmVzcG9uc2USPwoJY2hhcmFjdGVyGAEgASgLMiEuY3JlYX'
    'RpdmFudGEuY29udGVudC52MS5DaGFyYWN0ZXJSCWNoYXJhY3RlchJNCg5jaGFyYWN0ZXJfcGFj'
    'axgCIAEoCzImLmNyZWF0aXZhbnRhLmNvbnRlbnQudjEuQ29udGludWl0eVBhY2tSDWNoYXJhY3'
    'RlclBhY2s=');

@$core.Deprecated('Use characterServiceListRequestDescriptor instead')
const CharacterServiceListRequest$json = {
  '1': 'CharacterServiceListRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {
      '1': 'status_filter',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.creativanta.content.v1.CharacterStatus',
      '10': 'statusFilter'
    },
    {'1': 'page_size', '3': 3, '4': 1, '5': 5, '10': 'pageSize'},
    {'1': 'page_token', '3': 4, '4': 1, '5': 9, '10': 'pageToken'},
  ],
};

/// Descriptor for `CharacterServiceListRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List characterServiceListRequestDescriptor = $convert.base64Decode(
    'ChtDaGFyYWN0ZXJTZXJ2aWNlTGlzdFJlcXVlc3QSIQoMd29ya3NwYWNlX2lkGAEgASgJUgt3b3'
    'Jrc3BhY2VJZBJMCg1zdGF0dXNfZmlsdGVyGAIgASgOMicuY3JlYXRpdmFudGEuY29udGVudC52'
    'MS5DaGFyYWN0ZXJTdGF0dXNSDHN0YXR1c0ZpbHRlchIbCglwYWdlX3NpemUYAyABKAVSCHBhZ2'
    'VTaXplEh0KCnBhZ2VfdG9rZW4YBCABKAlSCXBhZ2VUb2tlbg==');

@$core.Deprecated('Use characterServiceListResponseDescriptor instead')
const CharacterServiceListResponse$json = {
  '1': 'CharacterServiceListResponse',
  '2': [
    {
      '1': 'characters',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.creativanta.content.v1.Character',
      '10': 'characters'
    },
    {'1': 'next_page_token', '3': 2, '4': 1, '5': 9, '10': 'nextPageToken'},
    {'1': 'total_count', '3': 3, '4': 1, '5': 5, '10': 'totalCount'},
    {
      '1': 'active_character_count',
      '3': 4,
      '4': 1,
      '5': 5,
      '10': 'activeCharacterCount'
    },
    {'1': 'slot_quota', '3': 5, '4': 1, '5': 5, '10': 'slotQuota'},
  ],
};

/// Descriptor for `CharacterServiceListResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List characterServiceListResponseDescriptor = $convert.base64Decode(
    'ChxDaGFyYWN0ZXJTZXJ2aWNlTGlzdFJlc3BvbnNlEkEKCmNoYXJhY3RlcnMYASADKAsyIS5jcm'
    'VhdGl2YW50YS5jb250ZW50LnYxLkNoYXJhY3RlclIKY2hhcmFjdGVycxImCg9uZXh0X3BhZ2Vf'
    'dG9rZW4YAiABKAlSDW5leHRQYWdlVG9rZW4SHwoLdG90YWxfY291bnQYAyABKAVSCnRvdGFsQ2'
    '91bnQSNAoWYWN0aXZlX2NoYXJhY3Rlcl9jb3VudBgEIAEoBVIUYWN0aXZlQ2hhcmFjdGVyQ291'
    'bnQSHQoKc2xvdF9xdW90YRgFIAEoBVIJc2xvdFF1b3Rh');

@$core.Deprecated('Use characterServiceUpdateRequestDescriptor instead')
const CharacterServiceUpdateRequest$json = {
  '1': 'CharacterServiceUpdateRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'character_id', '3': 2, '4': 1, '5': 9, '10': 'characterId'},
    {'1': 'name', '3': 3, '4': 1, '5': 9, '10': 'name'},
    {'1': 'description', '3': 4, '4': 1, '5': 9, '10': 'description'},
    {
      '1': 'reference_images_json',
      '3': 5,
      '4': 1,
      '5': 9,
      '10': 'referenceImagesJson'
    },
    {
      '1': 'voice_settings_json',
      '3': 6,
      '4': 1,
      '5': 9,
      '10': 'voiceSettingsJson'
    },
    {
      '1': 'visual_settings_json',
      '3': 7,
      '4': 1,
      '5': 9,
      '10': 'visualSettingsJson'
    },
    {'1': 'is_default', '3': 8, '4': 1, '5': 8, '10': 'isDefault'},
    {
      '1': 'status',
      '3': 9,
      '4': 1,
      '5': 14,
      '6': '.creativanta.content.v1.CharacterStatus',
      '10': 'status'
    },
  ],
};

/// Descriptor for `CharacterServiceUpdateRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List characterServiceUpdateRequestDescriptor = $convert.base64Decode(
    'Ch1DaGFyYWN0ZXJTZXJ2aWNlVXBkYXRlUmVxdWVzdBIhCgx3b3Jrc3BhY2VfaWQYASABKAlSC3'
    'dvcmtzcGFjZUlkEiEKDGNoYXJhY3Rlcl9pZBgCIAEoCVILY2hhcmFjdGVySWQSEgoEbmFtZRgD'
    'IAEoCVIEbmFtZRIgCgtkZXNjcmlwdGlvbhgEIAEoCVILZGVzY3JpcHRpb24SMgoVcmVmZXJlbm'
    'NlX2ltYWdlc19qc29uGAUgASgJUhNyZWZlcmVuY2VJbWFnZXNKc29uEi4KE3ZvaWNlX3NldHRp'
    'bmdzX2pzb24YBiABKAlSEXZvaWNlU2V0dGluZ3NKc29uEjAKFHZpc3VhbF9zZXR0aW5nc19qc2'
    '9uGAcgASgJUhJ2aXN1YWxTZXR0aW5nc0pzb24SHQoKaXNfZGVmYXVsdBgIIAEoCFIJaXNEZWZh'
    'dWx0Ej8KBnN0YXR1cxgJIAEoDjInLmNyZWF0aXZhbnRhLmNvbnRlbnQudjEuQ2hhcmFjdGVyU3'
    'RhdHVzUgZzdGF0dXM=');

@$core.Deprecated('Use characterServiceUpdateResponseDescriptor instead')
const CharacterServiceUpdateResponse$json = {
  '1': 'CharacterServiceUpdateResponse',
  '2': [
    {
      '1': 'character',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.content.v1.Character',
      '10': 'character'
    },
  ],
};

/// Descriptor for `CharacterServiceUpdateResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List characterServiceUpdateResponseDescriptor =
    $convert.base64Decode(
        'Ch5DaGFyYWN0ZXJTZXJ2aWNlVXBkYXRlUmVzcG9uc2USPwoJY2hhcmFjdGVyGAEgASgLMiEuY3'
        'JlYXRpdmFudGEuY29udGVudC52MS5DaGFyYWN0ZXJSCWNoYXJhY3Rlcg==');

@$core.Deprecated('Use characterServiceDeleteRequestDescriptor instead')
const CharacterServiceDeleteRequest$json = {
  '1': 'CharacterServiceDeleteRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'character_id', '3': 2, '4': 1, '5': 9, '10': 'characterId'},
    {'1': 'hard_delete', '3': 3, '4': 1, '5': 8, '10': 'hardDelete'},
  ],
};

/// Descriptor for `CharacterServiceDeleteRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List characterServiceDeleteRequestDescriptor =
    $convert.base64Decode(
        'Ch1DaGFyYWN0ZXJTZXJ2aWNlRGVsZXRlUmVxdWVzdBIhCgx3b3Jrc3BhY2VfaWQYASABKAlSC3'
        'dvcmtzcGFjZUlkEiEKDGNoYXJhY3Rlcl9pZBgCIAEoCVILY2hhcmFjdGVySWQSHwoLaGFyZF9k'
        'ZWxldGUYAyABKAhSCmhhcmREZWxldGU=');

@$core.Deprecated('Use characterServiceDeleteResponseDescriptor instead')
const CharacterServiceDeleteResponse$json = {
  '1': 'CharacterServiceDeleteResponse',
  '2': [
    {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
    {
      '1': 'new_status',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.creativanta.content.v1.CharacterStatus',
      '10': 'newStatus'
    },
  ],
};

/// Descriptor for `CharacterServiceDeleteResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List characterServiceDeleteResponseDescriptor =
    $convert.base64Decode(
        'Ch5DaGFyYWN0ZXJTZXJ2aWNlRGVsZXRlUmVzcG9uc2USGAoHc3VjY2VzcxgBIAEoCFIHc3VjY2'
        'VzcxJGCgpuZXdfc3RhdHVzGAIgASgOMicuY3JlYXRpdmFudGEuY29udGVudC52MS5DaGFyYWN0'
        'ZXJTdGF0dXNSCW5ld1N0YXR1cw==');

@$core.Deprecated('Use continuityServiceCreateRequestDescriptor instead')
const ContinuityServiceCreateRequest$json = {
  '1': 'ContinuityServiceCreateRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {
      '1': 'pack_type',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.creativanta.content.v1.PackType',
      '10': 'packType'
    },
    {'1': 'name', '3': 3, '4': 1, '5': 9, '10': 'name'},
    {'1': 'character_id', '3': 4, '4': 1, '5': 9, '10': 'characterId'},
    {
      '1': 'approved_references',
      '3': 5,
      '4': 3,
      '5': 11,
      '6': '.creativanta.content.v1.ApprovedReference',
      '10': 'approvedReferences'
    },
    {'1': 'rules_summary', '3': 6, '4': 1, '5': 9, '10': 'rulesSummary'},
    {'1': 'settings_json', '3': 7, '4': 1, '5': 9, '10': 'settingsJson'},
    {
      '1': 'allowed_use_scope_json',
      '3': 8,
      '4': 1,
      '5': 9,
      '10': 'allowedUseScopeJson'
    },
  ],
};

/// Descriptor for `ContinuityServiceCreateRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List continuityServiceCreateRequestDescriptor = $convert.base64Decode(
    'Ch5Db250aW51aXR5U2VydmljZUNyZWF0ZVJlcXVlc3QSIQoMd29ya3NwYWNlX2lkGAEgASgJUg'
    't3b3Jrc3BhY2VJZBI9CglwYWNrX3R5cGUYAiABKA4yIC5jcmVhdGl2YW50YS5jb250ZW50LnYx'
    'LlBhY2tUeXBlUghwYWNrVHlwZRISCgRuYW1lGAMgASgJUgRuYW1lEiEKDGNoYXJhY3Rlcl9pZB'
    'gEIAEoCVILY2hhcmFjdGVySWQSWgoTYXBwcm92ZWRfcmVmZXJlbmNlcxgFIAMoCzIpLmNyZWF0'
    'aXZhbnRhLmNvbnRlbnQudjEuQXBwcm92ZWRSZWZlcmVuY2VSEmFwcHJvdmVkUmVmZXJlbmNlcx'
    'IjCg1ydWxlc19zdW1tYXJ5GAYgASgJUgxydWxlc1N1bW1hcnkSIwoNc2V0dGluZ3NfanNvbhgH'
    'IAEoCVIMc2V0dGluZ3NKc29uEjMKFmFsbG93ZWRfdXNlX3Njb3BlX2pzb24YCCABKAlSE2FsbG'
    '93ZWRVc2VTY29wZUpzb24=');

@$core.Deprecated('Use continuityServiceCreateResponseDescriptor instead')
const ContinuityServiceCreateResponse$json = {
  '1': 'ContinuityServiceCreateResponse',
  '2': [
    {
      '1': 'pack',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.content.v1.ContinuityPack',
      '10': 'pack'
    },
  ],
};

/// Descriptor for `ContinuityServiceCreateResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List continuityServiceCreateResponseDescriptor =
    $convert.base64Decode(
        'Ch9Db250aW51aXR5U2VydmljZUNyZWF0ZVJlc3BvbnNlEjoKBHBhY2sYASABKAsyJi5jcmVhdG'
        'l2YW50YS5jb250ZW50LnYxLkNvbnRpbnVpdHlQYWNrUgRwYWNr');

@$core.Deprecated('Use continuityServiceGetRequestDescriptor instead')
const ContinuityServiceGetRequest$json = {
  '1': 'ContinuityServiceGetRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'pack_id', '3': 2, '4': 1, '5': 9, '10': 'packId'},
  ],
};

/// Descriptor for `ContinuityServiceGetRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List continuityServiceGetRequestDescriptor =
    $convert.base64Decode(
        'ChtDb250aW51aXR5U2VydmljZUdldFJlcXVlc3QSIQoMd29ya3NwYWNlX2lkGAEgASgJUgt3b3'
        'Jrc3BhY2VJZBIXCgdwYWNrX2lkGAIgASgJUgZwYWNrSWQ=');

@$core.Deprecated('Use continuityServiceGetResponseDescriptor instead')
const ContinuityServiceGetResponse$json = {
  '1': 'ContinuityServiceGetResponse',
  '2': [
    {
      '1': 'pack',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.content.v1.ContinuityPack',
      '10': 'pack'
    },
    {
      '1': 'version_history',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.creativanta.content.v1.PackVersion',
      '10': 'versionHistory'
    },
  ],
};

/// Descriptor for `ContinuityServiceGetResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List continuityServiceGetResponseDescriptor = $convert.base64Decode(
    'ChxDb250aW51aXR5U2VydmljZUdldFJlc3BvbnNlEjoKBHBhY2sYASABKAsyJi5jcmVhdGl2YW'
    '50YS5jb250ZW50LnYxLkNvbnRpbnVpdHlQYWNrUgRwYWNrEkwKD3ZlcnNpb25faGlzdG9yeRgC'
    'IAMoCzIjLmNyZWF0aXZhbnRhLmNvbnRlbnQudjEuUGFja1ZlcnNpb25SDnZlcnNpb25IaXN0b3'
    'J5');

@$core.Deprecated('Use continuityServiceGetPackRequestDescriptor instead')
const ContinuityServiceGetPackRequest$json = {
  '1': 'ContinuityServiceGetPackRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'pack_id', '3': 2, '4': 1, '5': 9, '10': 'packId'},
  ],
};

/// Descriptor for `ContinuityServiceGetPackRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List continuityServiceGetPackRequestDescriptor =
    $convert.base64Decode(
        'Ch9Db250aW51aXR5U2VydmljZUdldFBhY2tSZXF1ZXN0EiEKDHdvcmtzcGFjZV9pZBgBIAEoCV'
        'ILd29ya3NwYWNlSWQSFwoHcGFja19pZBgCIAEoCVIGcGFja0lk');

@$core.Deprecated('Use continuityServiceGetPackResponseDescriptor instead')
const ContinuityServiceGetPackResponse$json = {
  '1': 'ContinuityServiceGetPackResponse',
  '2': [
    {
      '1': 'pack',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.content.v1.ContinuityPack',
      '10': 'pack'
    },
    {
      '1': 'version_history',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.creativanta.content.v1.PackVersion',
      '10': 'versionHistory'
    },
  ],
};

/// Descriptor for `ContinuityServiceGetPackResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List continuityServiceGetPackResponseDescriptor =
    $convert.base64Decode(
        'CiBDb250aW51aXR5U2VydmljZUdldFBhY2tSZXNwb25zZRI6CgRwYWNrGAEgASgLMiYuY3JlYX'
        'RpdmFudGEuY29udGVudC52MS5Db250aW51aXR5UGFja1IEcGFjaxJMCg92ZXJzaW9uX2hpc3Rv'
        'cnkYAiADKAsyIy5jcmVhdGl2YW50YS5jb250ZW50LnYxLlBhY2tWZXJzaW9uUg52ZXJzaW9uSG'
        'lzdG9yeQ==');

@$core.Deprecated('Use continuityServiceUpdatePackRequestDescriptor instead')
const ContinuityServiceUpdatePackRequest$json = {
  '1': 'ContinuityServiceUpdatePackRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'pack_id', '3': 2, '4': 1, '5': 9, '10': 'packId'},
    {'1': 'name', '3': 3, '4': 1, '5': 9, '10': 'name'},
    {
      '1': 'approved_references',
      '3': 4,
      '4': 3,
      '5': 11,
      '6': '.creativanta.content.v1.ApprovedReference',
      '10': 'approvedReferences'
    },
    {'1': 'rules_summary', '3': 5, '4': 1, '5': 9, '10': 'rulesSummary'},
    {'1': 'settings_json', '3': 6, '4': 1, '5': 9, '10': 'settingsJson'},
    {
      '1': 'allowed_use_scope_json',
      '3': 7,
      '4': 1,
      '5': 9,
      '10': 'allowedUseScopeJson'
    },
    {
      '1': 'status',
      '3': 8,
      '4': 1,
      '5': 14,
      '6': '.creativanta.content.v1.PackStatus',
      '10': 'status'
    },
    {'1': 'update_reason', '3': 9, '4': 1, '5': 9, '10': 'updateReason'},
  ],
};

/// Descriptor for `ContinuityServiceUpdatePackRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List continuityServiceUpdatePackRequestDescriptor = $convert.base64Decode(
    'CiJDb250aW51aXR5U2VydmljZVVwZGF0ZVBhY2tSZXF1ZXN0EiEKDHdvcmtzcGFjZV9pZBgBIA'
    'EoCVILd29ya3NwYWNlSWQSFwoHcGFja19pZBgCIAEoCVIGcGFja0lkEhIKBG5hbWUYAyABKAlS'
    'BG5hbWUSWgoTYXBwcm92ZWRfcmVmZXJlbmNlcxgEIAMoCzIpLmNyZWF0aXZhbnRhLmNvbnRlbn'
    'QudjEuQXBwcm92ZWRSZWZlcmVuY2VSEmFwcHJvdmVkUmVmZXJlbmNlcxIjCg1ydWxlc19zdW1t'
    'YXJ5GAUgASgJUgxydWxlc1N1bW1hcnkSIwoNc2V0dGluZ3NfanNvbhgGIAEoCVIMc2V0dGluZ3'
    'NKc29uEjMKFmFsbG93ZWRfdXNlX3Njb3BlX2pzb24YByABKAlSE2FsbG93ZWRVc2VTY29wZUpz'
    'b24SOgoGc3RhdHVzGAggASgOMiIuY3JlYXRpdmFudGEuY29udGVudC52MS5QYWNrU3RhdHVzUg'
    'ZzdGF0dXMSIwoNdXBkYXRlX3JlYXNvbhgJIAEoCVIMdXBkYXRlUmVhc29u');

@$core.Deprecated('Use continuityServiceUpdatePackResponseDescriptor instead')
const ContinuityServiceUpdatePackResponse$json = {
  '1': 'ContinuityServiceUpdatePackResponse',
  '2': [
    {
      '1': 'pack',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.content.v1.ContinuityPack',
      '10': 'pack'
    },
    {
      '1': 'archived_version',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.creativanta.content.v1.PackVersion',
      '10': 'archivedVersion'
    },
  ],
};

/// Descriptor for `ContinuityServiceUpdatePackResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List continuityServiceUpdatePackResponseDescriptor =
    $convert.base64Decode(
        'CiNDb250aW51aXR5U2VydmljZVVwZGF0ZVBhY2tSZXNwb25zZRI6CgRwYWNrGAEgASgLMiYuY3'
        'JlYXRpdmFudGEuY29udGVudC52MS5Db250aW51aXR5UGFja1IEcGFjaxJOChBhcmNoaXZlZF92'
        'ZXJzaW9uGAIgASgLMiMuY3JlYXRpdmFudGEuY29udGVudC52MS5QYWNrVmVyc2lvblIPYXJjaG'
        'l2ZWRWZXJzaW9u');

@$core.Deprecated('Use continuityServiceCloneRequestDescriptor instead')
const ContinuityServiceCloneRequest$json = {
  '1': 'ContinuityServiceCloneRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'source_pack_id', '3': 2, '4': 1, '5': 9, '10': 'sourcePackId'},
    {'1': 'new_name', '3': 3, '4': 1, '5': 9, '10': 'newName'},
  ],
};

/// Descriptor for `ContinuityServiceCloneRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List continuityServiceCloneRequestDescriptor =
    $convert.base64Decode(
        'Ch1Db250aW51aXR5U2VydmljZUNsb25lUmVxdWVzdBIhCgx3b3Jrc3BhY2VfaWQYASABKAlSC3'
        'dvcmtzcGFjZUlkEiQKDnNvdXJjZV9wYWNrX2lkGAIgASgJUgxzb3VyY2VQYWNrSWQSGQoIbmV3'
        'X25hbWUYAyABKAlSB25ld05hbWU=');

@$core.Deprecated('Use continuityServiceCloneResponseDescriptor instead')
const ContinuityServiceCloneResponse$json = {
  '1': 'ContinuityServiceCloneResponse',
  '2': [
    {
      '1': 'pack',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.content.v1.ContinuityPack',
      '10': 'pack'
    },
  ],
};

/// Descriptor for `ContinuityServiceCloneResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List continuityServiceCloneResponseDescriptor =
    $convert.base64Decode(
        'Ch5Db250aW51aXR5U2VydmljZUNsb25lUmVzcG9uc2USOgoEcGFjaxgBIAEoCzImLmNyZWF0aX'
        'ZhbnRhLmNvbnRlbnQudjEuQ29udGludWl0eVBhY2tSBHBhY2s=');

@$core.Deprecated('Use continuityServiceDeleteRequestDescriptor instead')
const ContinuityServiceDeleteRequest$json = {
  '1': 'ContinuityServiceDeleteRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'pack_id', '3': 2, '4': 1, '5': 9, '10': 'packId'},
  ],
};

/// Descriptor for `ContinuityServiceDeleteRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List continuityServiceDeleteRequestDescriptor =
    $convert.base64Decode(
        'Ch5Db250aW51aXR5U2VydmljZURlbGV0ZVJlcXVlc3QSIQoMd29ya3NwYWNlX2lkGAEgASgJUg'
        't3b3Jrc3BhY2VJZBIXCgdwYWNrX2lkGAIgASgJUgZwYWNrSWQ=');

@$core.Deprecated('Use continuityServiceDeleteResponseDescriptor instead')
const ContinuityServiceDeleteResponse$json = {
  '1': 'ContinuityServiceDeleteResponse',
  '2': [
    {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
  ],
};

/// Descriptor for `ContinuityServiceDeleteResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List continuityServiceDeleteResponseDescriptor =
    $convert.base64Decode(
        'Ch9Db250aW51aXR5U2VydmljZURlbGV0ZVJlc3BvbnNlEhgKB3N1Y2Nlc3MYASABKAhSB3N1Y2'
        'Nlc3M=');

@$core.Deprecated('Use continuityServiceGetUsageStatsRequestDescriptor instead')
const ContinuityServiceGetUsageStatsRequest$json = {
  '1': 'ContinuityServiceGetUsageStatsRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'pack_id', '3': 2, '4': 1, '5': 9, '10': 'packId'},
  ],
};

/// Descriptor for `ContinuityServiceGetUsageStatsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List continuityServiceGetUsageStatsRequestDescriptor =
    $convert.base64Decode(
        'CiVDb250aW51aXR5U2VydmljZUdldFVzYWdlU3RhdHNSZXF1ZXN0EiEKDHdvcmtzcGFjZV9pZB'
        'gBIAEoCVILd29ya3NwYWNlSWQSFwoHcGFja19pZBgCIAEoCVIGcGFja0lk');

@$core
    .Deprecated('Use continuityServiceGetUsageStatsResponseDescriptor instead')
const ContinuityServiceGetUsageStatsResponse$json = {
  '1': 'ContinuityServiceGetUsageStatsResponse',
  '2': [
    {'1': 'pack_id', '3': 1, '4': 1, '5': 9, '10': 'packId'},
    {
      '1': 'total_assets_generated',
      '3': 2,
      '4': 1,
      '5': 5,
      '10': 'totalAssetsGenerated'
    },
    {
      '1': 'drift_warnings_count',
      '3': 3,
      '4': 1,
      '5': 5,
      '10': 'driftWarningsCount'
    },
    {'1': 'recent_asset_ids', '3': 4, '4': 3, '5': 9, '10': 'recentAssetIds'},
  ],
};

/// Descriptor for `ContinuityServiceGetUsageStatsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List continuityServiceGetUsageStatsResponseDescriptor =
    $convert.base64Decode(
        'CiZDb250aW51aXR5U2VydmljZUdldFVzYWdlU3RhdHNSZXNwb25zZRIXCgdwYWNrX2lkGAEgAS'
        'gJUgZwYWNrSWQSNAoWdG90YWxfYXNzZXRzX2dlbmVyYXRlZBgCIAEoBVIUdG90YWxBc3NldHNH'
        'ZW5lcmF0ZWQSMAoUZHJpZnRfd2FybmluZ3NfY291bnQYAyABKAVSEmRyaWZ0V2FybmluZ3NDb3'
        'VudBIoChByZWNlbnRfYXNzZXRfaWRzGAQgAygJUg5yZWNlbnRBc3NldElkcw==');

@$core
    .Deprecated('Use continuityServiceListBrandPacksRequestDescriptor instead')
const ContinuityServiceListBrandPacksRequest$json = {
  '1': 'ContinuityServiceListBrandPacksRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
  ],
};

/// Descriptor for `ContinuityServiceListBrandPacksRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List continuityServiceListBrandPacksRequestDescriptor =
    $convert.base64Decode(
        'CiZDb250aW51aXR5U2VydmljZUxpc3RCcmFuZFBhY2tzUmVxdWVzdBIhCgx3b3Jrc3BhY2VfaW'
        'QYASABKAlSC3dvcmtzcGFjZUlk');

@$core
    .Deprecated('Use continuityServiceListBrandPacksResponseDescriptor instead')
const ContinuityServiceListBrandPacksResponse$json = {
  '1': 'ContinuityServiceListBrandPacksResponse',
  '2': [
    {
      '1': 'brand_packs',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.creativanta.content.v1.ContinuityPack',
      '10': 'brandPacks'
    },
  ],
};

/// Descriptor for `ContinuityServiceListBrandPacksResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List continuityServiceListBrandPacksResponseDescriptor =
    $convert.base64Decode(
        'CidDb250aW51aXR5U2VydmljZUxpc3RCcmFuZFBhY2tzUmVzcG9uc2USRwoLYnJhbmRfcGFja3'
        'MYASADKAsyJi5jcmVhdGl2YW50YS5jb250ZW50LnYxLkNvbnRpbnVpdHlQYWNrUgpicmFuZFBh'
        'Y2tz');

@$core
    .Deprecated('Use continuityServiceListCharactersRequestDescriptor instead')
const ContinuityServiceListCharactersRequest$json = {
  '1': 'ContinuityServiceListCharactersRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'pack_id', '3': 2, '4': 1, '5': 9, '10': 'packId'},
  ],
};

/// Descriptor for `ContinuityServiceListCharactersRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List continuityServiceListCharactersRequestDescriptor =
    $convert.base64Decode(
        'CiZDb250aW51aXR5U2VydmljZUxpc3RDaGFyYWN0ZXJzUmVxdWVzdBIhCgx3b3Jrc3BhY2VfaW'
        'QYASABKAlSC3dvcmtzcGFjZUlkEhcKB3BhY2tfaWQYAiABKAlSBnBhY2tJZA==');

@$core
    .Deprecated('Use continuityServiceListCharactersResponseDescriptor instead')
const ContinuityServiceListCharactersResponse$json = {
  '1': 'ContinuityServiceListCharactersResponse',
  '2': [
    {
      '1': 'characters',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.creativanta.content.v1.Character',
      '10': 'characters'
    },
  ],
};

/// Descriptor for `ContinuityServiceListCharactersResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List continuityServiceListCharactersResponseDescriptor =
    $convert.base64Decode(
        'CidDb250aW51aXR5U2VydmljZUxpc3RDaGFyYWN0ZXJzUmVzcG9uc2USQQoKY2hhcmFjdGVycx'
        'gBIAMoCzIhLmNyZWF0aXZhbnRhLmNvbnRlbnQudjEuQ2hhcmFjdGVyUgpjaGFyYWN0ZXJz');

@$core.Deprecated('Use continuityServiceListVoicesRequestDescriptor instead')
const ContinuityServiceListVoicesRequest$json = {
  '1': 'ContinuityServiceListVoicesRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'pack_id', '3': 2, '4': 1, '5': 9, '10': 'packId'},
  ],
};

/// Descriptor for `ContinuityServiceListVoicesRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List continuityServiceListVoicesRequestDescriptor =
    $convert.base64Decode(
        'CiJDb250aW51aXR5U2VydmljZUxpc3RWb2ljZXNSZXF1ZXN0EiEKDHdvcmtzcGFjZV9pZBgBIA'
        'EoCVILd29ya3NwYWNlSWQSFwoHcGFja19pZBgCIAEoCVIGcGFja0lk');

@$core.Deprecated('Use continuityServiceListVoicesResponseDescriptor instead')
const ContinuityServiceListVoicesResponse$json = {
  '1': 'ContinuityServiceListVoicesResponse',
  '2': [
    {
      '1': 'voice_packs',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.creativanta.content.v1.ContinuityPack',
      '10': 'voicePacks'
    },
  ],
};

/// Descriptor for `ContinuityServiceListVoicesResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List continuityServiceListVoicesResponseDescriptor =
    $convert.base64Decode(
        'CiNDb250aW51aXR5U2VydmljZUxpc3RWb2ljZXNSZXNwb25zZRJHCgt2b2ljZV9wYWNrcxgBIA'
        'MoCzImLmNyZWF0aXZhbnRhLmNvbnRlbnQudjEuQ29udGludWl0eVBhY2tSCnZvaWNlUGFja3M=');

@$core.Deprecated('Use consentServiceGrantRequestDescriptor instead')
const ConsentServiceGrantRequest$json = {
  '1': 'ConsentServiceGrantRequest',
  '2': [
    {'1': 'user_id', '3': 1, '4': 1, '5': 9, '10': 'userId'},
    {'1': 'workspace_id', '3': 2, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'consent_type', '3': 3, '4': 1, '5': 9, '10': 'consentType'},
    {'1': 'version', '3': 4, '4': 1, '5': 9, '10': 'version'},
    {
      '1': 'source_footage_url',
      '3': 5,
      '4': 1,
      '5': 9,
      '10': 'sourceFootageUrl'
    },
    {'1': 'consent_video_url', '3': 6, '4': 1, '5': 9, '10': 'consentVideoUrl'},
    {
      '1': 'declaration_signed',
      '3': 7,
      '4': 1,
      '5': 8,
      '10': 'declarationSigned'
    },
  ],
};

/// Descriptor for `ConsentServiceGrantRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List consentServiceGrantRequestDescriptor = $convert.base64Decode(
    'ChpDb25zZW50U2VydmljZUdyYW50UmVxdWVzdBIXCgd1c2VyX2lkGAEgASgJUgZ1c2VySWQSIQ'
    'oMd29ya3NwYWNlX2lkGAIgASgJUgt3b3Jrc3BhY2VJZBIhCgxjb25zZW50X3R5cGUYAyABKAlS'
    'C2NvbnNlbnRUeXBlEhgKB3ZlcnNpb24YBCABKAlSB3ZlcnNpb24SLAoSc291cmNlX2Zvb3RhZ2'
    'VfdXJsGAUgASgJUhBzb3VyY2VGb290YWdlVXJsEioKEWNvbnNlbnRfdmlkZW9fdXJsGAYgASgJ'
    'Ug9jb25zZW50VmlkZW9VcmwSLQoSZGVjbGFyYXRpb25fc2lnbmVkGAcgASgIUhFkZWNsYXJhdG'
    'lvblNpZ25lZA==');

@$core.Deprecated('Use consentServiceGrantResponseDescriptor instead')
const ConsentServiceGrantResponse$json = {
  '1': 'ConsentServiceGrantResponse',
  '2': [
    {
      '1': 'record',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.content.v1.ConsentRecord',
      '10': 'record'
    },
    {
      '1': 'face_match_verified',
      '3': 2,
      '4': 1,
      '5': 8,
      '10': 'faceMatchVerified'
    },
  ],
};

/// Descriptor for `ConsentServiceGrantResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List consentServiceGrantResponseDescriptor =
    $convert.base64Decode(
        'ChtDb25zZW50U2VydmljZUdyYW50UmVzcG9uc2USPQoGcmVjb3JkGAEgASgLMiUuY3JlYXRpdm'
        'FudGEuY29udGVudC52MS5Db25zZW50UmVjb3JkUgZyZWNvcmQSLgoTZmFjZV9tYXRjaF92ZXJp'
        'ZmllZBgCIAEoCFIRZmFjZU1hdGNoVmVyaWZpZWQ=');

@$core.Deprecated('Use consentServiceRevokeRequestDescriptor instead')
const ConsentServiceRevokeRequest$json = {
  '1': 'ConsentServiceRevokeRequest',
  '2': [
    {'1': 'user_id', '3': 1, '4': 1, '5': 9, '10': 'userId'},
    {'1': 'workspace_id', '3': 2, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'consent_type', '3': 3, '4': 1, '5': 9, '10': 'consentType'},
    {'1': 'reason', '3': 4, '4': 1, '5': 9, '10': 'reason'},
  ],
};

/// Descriptor for `ConsentServiceRevokeRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List consentServiceRevokeRequestDescriptor =
    $convert.base64Decode(
        'ChtDb25zZW50U2VydmljZVJldm9rZVJlcXVlc3QSFwoHdXNlcl9pZBgBIAEoCVIGdXNlcklkEi'
        'EKDHdvcmtzcGFjZV9pZBgCIAEoCVILd29ya3NwYWNlSWQSIQoMY29uc2VudF90eXBlGAMgASgJ'
        'Ugtjb25zZW50VHlwZRIWCgZyZWFzb24YBCABKAlSBnJlYXNvbg==');

@$core.Deprecated('Use consentServiceRevokeResponseDescriptor instead')
const ConsentServiceRevokeResponse$json = {
  '1': 'ConsentServiceRevokeResponse',
  '2': [
    {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
    {
      '1': 'record',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.creativanta.content.v1.ConsentRecord',
      '10': 'record'
    },
    {
      '1': 'characters_disabled_count',
      '3': 3,
      '4': 1,
      '5': 5,
      '10': 'charactersDisabledCount'
    },
  ],
};

/// Descriptor for `ConsentServiceRevokeResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List consentServiceRevokeResponseDescriptor = $convert.base64Decode(
    'ChxDb25zZW50U2VydmljZVJldm9rZVJlc3BvbnNlEhgKB3N1Y2Nlc3MYASABKAhSB3N1Y2Nlc3'
    'MSPQoGcmVjb3JkGAIgASgLMiUuY3JlYXRpdmFudGEuY29udGVudC52MS5Db25zZW50UmVjb3Jk'
    'UgZyZWNvcmQSOgoZY2hhcmFjdGVyc19kaXNhYmxlZF9jb3VudBgDIAEoBVIXY2hhcmFjdGVyc0'
    'Rpc2FibGVkQ291bnQ=');

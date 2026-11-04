// This is a generated file - do not edit.
//
// Generated from creativanta/automation/v1/recipe.proto.

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

@$core.Deprecated('Use recipeStatusDescriptor instead')
const RecipeStatus$json = {
  '1': 'RecipeStatus',
  '2': [
    {'1': 'RECIPE_STATUS_UNSPECIFIED', '2': 0},
    {'1': 'RECIPE_STATUS_DRAFT', '2': 1},
    {'1': 'RECIPE_STATUS_REVIEW_REQUIRED', '2': 2},
    {'1': 'RECIPE_STATUS_PUBLISHED', '2': 3},
    {'1': 'RECIPE_STATUS_DEPRECATED', '2': 4},
    {'1': 'RECIPE_STATUS_RETIRED', '2': 5},
    {'1': 'RECIPE_STATUS_TAKEN_DOWN', '2': 6},
  ],
};

/// Descriptor for `RecipeStatus`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List recipeStatusDescriptor = $convert.base64Decode(
    'CgxSZWNpcGVTdGF0dXMSHQoZUkVDSVBFX1NUQVRVU19VTlNQRUNJRklFRBAAEhcKE1JFQ0lQRV'
    '9TVEFUVVNfRFJBRlQQARIhCh1SRUNJUEVfU1RBVFVTX1JFVklFV19SRVFVSVJFRBACEhsKF1JF'
    'Q0lQRV9TVEFUVVNfUFVCTElTSEVEEAMSHAoYUkVDSVBFX1NUQVRVU19ERVBSRUNBVEVEEAQSGQ'
    'oVUkVDSVBFX1NUQVRVU19SRVRJUkVEEAUSHAoYUkVDSVBFX1NUQVRVU19UQUtFTl9ET1dOEAY=');

@$core.Deprecated('Use templateKindDescriptor instead')
const TemplateKind$json = {
  '1': 'TemplateKind',
  '2': [
    {'1': 'TEMPLATE_KIND_UNSPECIFIED', '2': 0},
    {'1': 'TEMPLATE_KIND_WORKFLOW', '2': 1},
    {'1': 'TEMPLATE_KIND_STYLE_WORKFLOW', '2': 2},
  ],
};

/// Descriptor for `TemplateKind`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List templateKindDescriptor = $convert.base64Decode(
    'CgxUZW1wbGF0ZUtpbmQSHQoZVEVNUExBVEVfS0lORF9VTlNQRUNJRklFRBAAEhoKFlRFTVBMQV'
    'RFX0tJTkRfV09SS0ZMT1cQARIgChxURU1QTEFURV9LSU5EX1NUWUxFX1dPUktGTE9XEAI=');

@$core.Deprecated('Use recipeInstallationStatusDescriptor instead')
const RecipeInstallationStatus$json = {
  '1': 'RecipeInstallationStatus',
  '2': [
    {'1': 'RECIPE_INSTALLATION_STATUS_UNSPECIFIED', '2': 0},
    {'1': 'RECIPE_INSTALLATION_STATUS_INSTALLED', '2': 1},
    {'1': 'RECIPE_INSTALLATION_STATUS_CUSTOMIZED', '2': 2},
    {'1': 'RECIPE_INSTALLATION_STATUS_UPDATE_AVAILABLE', '2': 3},
    {'1': 'RECIPE_INSTALLATION_STATUS_PINNED', '2': 4},
    {'1': 'RECIPE_INSTALLATION_STATUS_DEPRECATED', '2': 5},
    {'1': 'RECIPE_INSTALLATION_STATUS_WORKFLOW_DELETED', '2': 6},
  ],
};

/// Descriptor for `RecipeInstallationStatus`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List recipeInstallationStatusDescriptor = $convert.base64Decode(
    'ChhSZWNpcGVJbnN0YWxsYXRpb25TdGF0dXMSKgomUkVDSVBFX0lOU1RBTExBVElPTl9TVEFUVV'
    'NfVU5TUEVDSUZJRUQQABIoCiRSRUNJUEVfSU5TVEFMTEFUSU9OX1NUQVRVU19JTlNUQUxMRUQQ'
    'ARIpCiVSRUNJUEVfSU5TVEFMTEFUSU9OX1NUQVRVU19DVVNUT01JWkVEEAISLworUkVDSVBFX0'
    'lOU1RBTExBVElPTl9TVEFUVVNfVVBEQVRFX0FWQUlMQUJMRRADEiUKIVJFQ0lQRV9JTlNUQUxM'
    'QVRJT05fU1RBVFVTX1BJTk5FRBAEEikKJVJFQ0lQRV9JTlNUQUxMQVRJT05fU1RBVFVTX0RFUF'
    'JFQ0FURUQQBRIvCitSRUNJUEVfSU5TVEFMTEFUSU9OX1NUQVRVU19XT1JLRkxPV19ERUxFVEVE'
    'EAY=');

@$core.Deprecated('Use submissionStatusDescriptor instead')
const SubmissionStatus$json = {
  '1': 'SubmissionStatus',
  '2': [
    {'1': 'SUBMISSION_STATUS_UNSPECIFIED', '2': 0},
    {'1': 'SUBMISSION_STATUS_PENDING', '2': 1},
    {'1': 'SUBMISSION_STATUS_APPROVED', '2': 2},
    {'1': 'SUBMISSION_STATUS_REJECTED', '2': 3},
    {'1': 'SUBMISSION_STATUS_CHANGES_REQUESTED', '2': 4},
    {'1': 'SUBMISSION_STATUS_TAKEN_DOWN', '2': 5},
  ],
};

/// Descriptor for `SubmissionStatus`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List submissionStatusDescriptor = $convert.base64Decode(
    'ChBTdWJtaXNzaW9uU3RhdHVzEiEKHVNVQk1JU1NJT05fU1RBVFVTX1VOU1BFQ0lGSUVEEAASHQ'
    'oZU1VCTUlTU0lPTl9TVEFUVVNfUEVORElORxABEh4KGlNVQk1JU1NJT05fU1RBVFVTX0FQUFJP'
    'VkVEEAISHgoaU1VCTUlTU0lPTl9TVEFUVVNfUkVKRUNURUQQAxInCiNTVUJNSVNTSU9OX1NUQV'
    'RVU19DSEFOR0VTX1JFUVVFU1RFRBAEEiAKHFNVQk1JU1NJT05fU1RBVFVTX1RBS0VOX0RPV04Q'
    'BQ==');

@$core.Deprecated('Use revenueShareStatusDescriptor instead')
const RevenueShareStatus$json = {
  '1': 'RevenueShareStatus',
  '2': [
    {'1': 'REVENUE_SHARE_STATUS_UNSPECIFIED', '2': 0},
    {'1': 'REVENUE_SHARE_STATUS_SETTLED', '2': 1},
    {'1': 'REVENUE_SHARE_STATUS_REFUNDED', '2': 2},
    {'1': 'REVENUE_SHARE_STATUS_DISPUTED', '2': 3},
  ],
};

/// Descriptor for `RevenueShareStatus`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List revenueShareStatusDescriptor = $convert.base64Decode(
    'ChJSZXZlbnVlU2hhcmVTdGF0dXMSJAogUkVWRU5VRV9TSEFSRV9TVEFUVVNfVU5TUEVDSUZJRU'
    'QQABIgChxSRVZFTlVFX1NIQVJFX1NUQVRVU19TRVRUTEVEEAESIQodUkVWRU5VRV9TSEFSRV9T'
    'VEFUVVNfUkVGVU5ERUQQAhIhCh1SRVZFTlVFX1NIQVJFX1NUQVRVU19ESVNQVVRFRBAD');

@$core.Deprecated('Use recipeParameterDescriptor instead')
const RecipeParameter$json = {
  '1': 'RecipeParameter',
  '2': [
    {'1': 'name', '3': 1, '4': 1, '5': 9, '10': 'name'},
    {'1': 'type', '3': 2, '4': 1, '5': 9, '10': 'type'},
    {'1': 'default_value', '3': 3, '4': 1, '5': 9, '10': 'defaultValue'},
    {'1': 'required', '3': 4, '4': 1, '5': 8, '10': 'required'},
    {'1': 'description', '3': 5, '4': 1, '5': 9, '10': 'description'},
  ],
};

/// Descriptor for `RecipeParameter`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List recipeParameterDescriptor = $convert.base64Decode(
    'Cg9SZWNpcGVQYXJhbWV0ZXISEgoEbmFtZRgBIAEoCVIEbmFtZRISCgR0eXBlGAIgASgJUgR0eX'
    'BlEiMKDWRlZmF1bHRfdmFsdWUYAyABKAlSDGRlZmF1bHRWYWx1ZRIaCghyZXF1aXJlZBgEIAEo'
    'CFIIcmVxdWlyZWQSIAoLZGVzY3JpcHRpb24YBSABKAlSC2Rlc2NyaXB0aW9u');

@$core.Deprecated('Use missingCapabilityExplanationDescriptor instead')
const MissingCapabilityExplanation$json = {
  '1': 'MissingCapabilityExplanation',
  '2': [
    {'1': 'capability_key', '3': 1, '4': 1, '5': 9, '10': 'capabilityKey'},
    {'1': 'platform', '3': 2, '4': 1, '5': 9, '10': 'platform'},
    {'1': 'reason', '3': 3, '4': 1, '5': 9, '10': 'reason'},
    {
      '1': 'resolution_guidance',
      '3': 4,
      '4': 1,
      '5': 9,
      '10': 'resolutionGuidance'
    },
    {'1': 'connect_url', '3': 5, '4': 1, '5': 9, '10': 'connectUrl'},
  ],
};

/// Descriptor for `MissingCapabilityExplanation`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List missingCapabilityExplanationDescriptor = $convert.base64Decode(
    'ChxNaXNzaW5nQ2FwYWJpbGl0eUV4cGxhbmF0aW9uEiUKDmNhcGFiaWxpdHlfa2V5GAEgASgJUg'
    '1jYXBhYmlsaXR5S2V5EhoKCHBsYXRmb3JtGAIgASgJUghwbGF0Zm9ybRIWCgZyZWFzb24YAyAB'
    'KAlSBnJlYXNvbhIvChNyZXNvbHV0aW9uX2d1aWRhbmNlGAQgASgJUhJyZXNvbHV0aW9uR3VpZG'
    'FuY2USHwoLY29ubmVjdF91cmwYBSABKAlSCmNvbm5lY3RVcmw=');

@$core.Deprecated('Use recipeTemplateDescriptor instead')
const RecipeTemplate$json = {
  '1': 'RecipeTemplate',
  '2': [
    {'1': 'recipe_id', '3': 1, '4': 1, '5': 9, '10': 'recipeId'},
    {'1': 'workspace_id', '3': 2, '4': 1, '5': 9, '10': 'workspaceId'},
    {
      '1': 'author_workspace_id',
      '3': 3,
      '4': 1,
      '5': 9,
      '10': 'authorWorkspaceId'
    },
    {'1': 'title', '3': 4, '4': 1, '5': 9, '10': 'title'},
    {'1': 'description', '3': 5, '4': 1, '5': 9, '10': 'description'},
    {'1': 'category', '3': 6, '4': 1, '5': 9, '10': 'category'},
    {
      '1': 'activepieces_template_id',
      '3': 7,
      '4': 1,
      '5': 9,
      '10': 'activepiecesTemplateId'
    },
    {
      '1': 'template_kind',
      '3': 8,
      '4': 1,
      '5': 14,
      '6': '.creativanta.automation.v1.TemplateKind',
      '10': 'templateKind'
    },
    {'1': 'template_version', '3': 9, '4': 1, '5': 5, '10': 'templateVersion'},
    {
      '1': 'template_payload_json',
      '3': 10,
      '4': 1,
      '5': 9,
      '10': 'templatePayloadJson'
    },
    {
      '1': 'parameters',
      '3': 11,
      '4': 3,
      '5': 11,
      '6': '.creativanta.automation.v1.RecipeParameter',
      '10': 'parameters'
    },
    {
      '1': 'required_capabilities',
      '3': 12,
      '4': 3,
      '5': 9,
      '10': 'requiredCapabilities'
    },
    {'1': 'install_count', '3': 13, '4': 1, '5': 5, '10': 'installCount'},
    {'1': 'rating_avg', '3': 14, '4': 1, '5': 2, '10': 'ratingAvg'},
    {'1': 'review_count', '3': 15, '4': 1, '5': 5, '10': 'reviewCount'},
    {'1': 'price_usd', '3': 16, '4': 1, '5': 9, '10': 'priceUsd'},
    {
      '1': 'status',
      '3': 17,
      '4': 1,
      '5': 14,
      '6': '.creativanta.automation.v1.RecipeStatus',
      '10': 'status'
    },
    {
      '1': 'created_at',
      '3': 18,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'createdAt'
    },
    {
      '1': 'updated_at',
      '3': 19,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'updatedAt'
    },
  ],
};

/// Descriptor for `RecipeTemplate`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List recipeTemplateDescriptor = $convert.base64Decode(
    'Cg5SZWNpcGVUZW1wbGF0ZRIbCglyZWNpcGVfaWQYASABKAlSCHJlY2lwZUlkEiEKDHdvcmtzcG'
    'FjZV9pZBgCIAEoCVILd29ya3NwYWNlSWQSLgoTYXV0aG9yX3dvcmtzcGFjZV9pZBgDIAEoCVIR'
    'YXV0aG9yV29ya3NwYWNlSWQSFAoFdGl0bGUYBCABKAlSBXRpdGxlEiAKC2Rlc2NyaXB0aW9uGA'
    'UgASgJUgtkZXNjcmlwdGlvbhIaCghjYXRlZ29yeRgGIAEoCVIIY2F0ZWdvcnkSOAoYYWN0aXZl'
    'cGllY2VzX3RlbXBsYXRlX2lkGAcgASgJUhZhY3RpdmVwaWVjZXNUZW1wbGF0ZUlkEkwKDXRlbX'
    'BsYXRlX2tpbmQYCCABKA4yJy5jcmVhdGl2YW50YS5hdXRvbWF0aW9uLnYxLlRlbXBsYXRlS2lu'
    'ZFIMdGVtcGxhdGVLaW5kEikKEHRlbXBsYXRlX3ZlcnNpb24YCSABKAVSD3RlbXBsYXRlVmVyc2'
    'lvbhIyChV0ZW1wbGF0ZV9wYXlsb2FkX2pzb24YCiABKAlSE3RlbXBsYXRlUGF5bG9hZEpzb24S'
    'SgoKcGFyYW1ldGVycxgLIAMoCzIqLmNyZWF0aXZhbnRhLmF1dG9tYXRpb24udjEuUmVjaXBlUG'
    'FyYW1ldGVyUgpwYXJhbWV0ZXJzEjMKFXJlcXVpcmVkX2NhcGFiaWxpdGllcxgMIAMoCVIUcmVx'
    'dWlyZWRDYXBhYmlsaXRpZXMSIwoNaW5zdGFsbF9jb3VudBgNIAEoBVIMaW5zdGFsbENvdW50Eh'
    '0KCnJhdGluZ19hdmcYDiABKAJSCXJhdGluZ0F2ZxIhCgxyZXZpZXdfY291bnQYDyABKAVSC3Jl'
    'dmlld0NvdW50EhsKCXByaWNlX3VzZBgQIAEoCVIIcHJpY2VVc2QSPwoGc3RhdHVzGBEgASgOMi'
    'cuY3JlYXRpdmFudGEuYXV0b21hdGlvbi52MS5SZWNpcGVTdGF0dXNSBnN0YXR1cxI5CgpjcmVh'
    'dGVkX2F0GBIgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIJY3JlYXRlZEF0EjkKCn'
    'VwZGF0ZWRfYXQYEyABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUgl1cGRhdGVkQXQ=');

@$core.Deprecated('Use recipeInstallationDescriptor instead')
const RecipeInstallation$json = {
  '1': 'RecipeInstallation',
  '2': [
    {'1': 'installation_id', '3': 1, '4': 1, '5': 9, '10': 'installationId'},
    {'1': 'workspace_id', '3': 2, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'recipe_id', '3': 3, '4': 1, '5': 9, '10': 'recipeId'},
    {'1': 'workflow_id', '3': 4, '4': 1, '5': 9, '10': 'workflowId'},
    {
      '1': 'installed_version',
      '3': 5,
      '4': 1,
      '5': 5,
      '10': 'installedVersion'
    },
    {
      '1': 'status',
      '3': 6,
      '4': 1,
      '5': 14,
      '6': '.creativanta.automation.v1.RecipeInstallationStatus',
      '10': 'status'
    },
    {
      '1': 'parameter_values_json',
      '3': 7,
      '4': 1,
      '5': 9,
      '10': 'parameterValuesJson'
    },
    {'1': 'installed_by', '3': 8, '4': 1, '5': 9, '10': 'installedBy'},
    {
      '1': 'created_at',
      '3': 9,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'createdAt'
    },
    {
      '1': 'updated_at',
      '3': 10,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'updatedAt'
    },
  ],
};

/// Descriptor for `RecipeInstallation`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List recipeInstallationDescriptor = $convert.base64Decode(
    'ChJSZWNpcGVJbnN0YWxsYXRpb24SJwoPaW5zdGFsbGF0aW9uX2lkGAEgASgJUg5pbnN0YWxsYX'
    'Rpb25JZBIhCgx3b3Jrc3BhY2VfaWQYAiABKAlSC3dvcmtzcGFjZUlkEhsKCXJlY2lwZV9pZBgD'
    'IAEoCVIIcmVjaXBlSWQSHwoLd29ya2Zsb3dfaWQYBCABKAlSCndvcmtmbG93SWQSKwoRaW5zdG'
    'FsbGVkX3ZlcnNpb24YBSABKAVSEGluc3RhbGxlZFZlcnNpb24SSwoGc3RhdHVzGAYgASgOMjMu'
    'Y3JlYXRpdmFudGEuYXV0b21hdGlvbi52MS5SZWNpcGVJbnN0YWxsYXRpb25TdGF0dXNSBnN0YX'
    'R1cxIyChVwYXJhbWV0ZXJfdmFsdWVzX2pzb24YByABKAlSE3BhcmFtZXRlclZhbHVlc0pzb24S'
    'IQoMaW5zdGFsbGVkX2J5GAggASgJUgtpbnN0YWxsZWRCeRI5CgpjcmVhdGVkX2F0GAkgASgLMh'
    'ouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIJY3JlYXRlZEF0EjkKCnVwZGF0ZWRfYXQYCiAB'
    'KAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUgl1cGRhdGVkQXQ=');

@$core.Deprecated('Use recipeReviewDescriptor instead')
const RecipeReview$json = {
  '1': 'RecipeReview',
  '2': [
    {'1': 'review_id', '3': 1, '4': 1, '5': 9, '10': 'reviewId'},
    {'1': 'recipe_id', '3': 2, '4': 1, '5': 9, '10': 'recipeId'},
    {'1': 'workspace_id', '3': 3, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'user_id', '3': 4, '4': 1, '5': 9, '10': 'userId'},
    {'1': 'rating', '3': 5, '4': 1, '5': 5, '10': 'rating'},
    {'1': 'review_text', '3': 6, '4': 1, '5': 9, '10': 'reviewText'},
    {'1': 'author_name', '3': 7, '4': 1, '5': 9, '10': 'authorName'},
    {
      '1': 'created_at',
      '3': 8,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'createdAt'
    },
    {
      '1': 'updated_at',
      '3': 9,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'updatedAt'
    },
  ],
};

/// Descriptor for `RecipeReview`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List recipeReviewDescriptor = $convert.base64Decode(
    'CgxSZWNpcGVSZXZpZXcSGwoJcmV2aWV3X2lkGAEgASgJUghyZXZpZXdJZBIbCglyZWNpcGVfaW'
    'QYAiABKAlSCHJlY2lwZUlkEiEKDHdvcmtzcGFjZV9pZBgDIAEoCVILd29ya3NwYWNlSWQSFwoH'
    'dXNlcl9pZBgEIAEoCVIGdXNlcklkEhYKBnJhdGluZxgFIAEoBVIGcmF0aW5nEh8KC3Jldmlld1'
    '90ZXh0GAYgASgJUgpyZXZpZXdUZXh0Eh8KC2F1dGhvcl9uYW1lGAcgASgJUgphdXRob3JOYW1l'
    'EjkKCmNyZWF0ZWRfYXQYCCABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUgljcmVhdG'
    'VkQXQSOQoKdXBkYXRlZF9hdBgJIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSCXVw'
    'ZGF0ZWRBdA==');

@$core.Deprecated('Use recipeSubmissionDescriptor instead')
const RecipeSubmission$json = {
  '1': 'RecipeSubmission',
  '2': [
    {'1': 'submission_id', '3': 1, '4': 1, '5': 9, '10': 'submissionId'},
    {'1': 'recipe_id', '3': 2, '4': 1, '5': 9, '10': 'recipeId'},
    {
      '1': 'author_workspace_id',
      '3': 3,
      '4': 1,
      '5': 9,
      '10': 'authorWorkspaceId'
    },
    {
      '1': 'submitted_version',
      '3': 4,
      '4': 1,
      '5': 5,
      '10': 'submittedVersion'
    },
    {
      '1': 'status',
      '3': 5,
      '4': 1,
      '5': 14,
      '6': '.creativanta.automation.v1.SubmissionStatus',
      '10': 'status'
    },
    {'1': 'review_notes', '3': 6, '4': 1, '5': 9, '10': 'reviewNotes'},
    {'1': 'reviewed_by', '3': 7, '4': 1, '5': 9, '10': 'reviewedBy'},
    {
      '1': 'reviewed_at',
      '3': 8,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'reviewedAt'
    },
    {'1': 'takedown_reason', '3': 9, '4': 1, '5': 9, '10': 'takedownReason'},
    {
      '1': 'takedown_ticket_ref',
      '3': 10,
      '4': 1,
      '5': 9,
      '10': 'takedownTicketRef'
    },
    {
      '1': 'created_at',
      '3': 11,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'createdAt'
    },
    {
      '1': 'updated_at',
      '3': 12,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'updatedAt'
    },
  ],
};

/// Descriptor for `RecipeSubmission`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List recipeSubmissionDescriptor = $convert.base64Decode(
    'ChBSZWNpcGVTdWJtaXNzaW9uEiMKDXN1Ym1pc3Npb25faWQYASABKAlSDHN1Ym1pc3Npb25JZB'
    'IbCglyZWNpcGVfaWQYAiABKAlSCHJlY2lwZUlkEi4KE2F1dGhvcl93b3Jrc3BhY2VfaWQYAyAB'
    'KAlSEWF1dGhvcldvcmtzcGFjZUlkEisKEXN1Ym1pdHRlZF92ZXJzaW9uGAQgASgFUhBzdWJtaX'
    'R0ZWRWZXJzaW9uEkMKBnN0YXR1cxgFIAEoDjIrLmNyZWF0aXZhbnRhLmF1dG9tYXRpb24udjEu'
    'U3VibWlzc2lvblN0YXR1c1IGc3RhdHVzEiEKDHJldmlld19ub3RlcxgGIAEoCVILcmV2aWV3Tm'
    '90ZXMSHwoLcmV2aWV3ZWRfYnkYByABKAlSCnJldmlld2VkQnkSOwoLcmV2aWV3ZWRfYXQYCCAB'
    'KAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUgpyZXZpZXdlZEF0EicKD3Rha2Vkb3duX3'
    'JlYXNvbhgJIAEoCVIOdGFrZWRvd25SZWFzb24SLgoTdGFrZWRvd25fdGlja2V0X3JlZhgKIAEo'
    'CVIRdGFrZWRvd25UaWNrZXRSZWYSOQoKY3JlYXRlZF9hdBgLIAEoCzIaLmdvb2dsZS5wcm90b2'
    'J1Zi5UaW1lc3RhbXBSCWNyZWF0ZWRBdBI5Cgp1cGRhdGVkX2F0GAwgASgLMhouZ29vZ2xlLnBy'
    'b3RvYnVmLlRpbWVzdGFtcFIJdXBkYXRlZEF0');

@$core.Deprecated('Use recipeRevenueShareDescriptor instead')
const RecipeRevenueShare$json = {
  '1': 'RecipeRevenueShare',
  '2': [
    {'1': 'revenue_share_id', '3': 1, '4': 1, '5': 9, '10': 'revenueShareId'},
    {'1': 'recipe_id', '3': 2, '4': 1, '5': 9, '10': 'recipeId'},
    {
      '1': 'author_workspace_id',
      '3': 3,
      '4': 1,
      '5': 9,
      '10': 'authorWorkspaceId'
    },
    {
      '1': 'purchaser_workspace_id',
      '3': 4,
      '4': 1,
      '5': 9,
      '10': 'purchaserWorkspaceId'
    },
    {'1': 'gross_amount', '3': 5, '4': 1, '5': 9, '10': 'grossAmount'},
    {'1': 'creator_amount', '3': 6, '4': 1, '5': 9, '10': 'creatorAmount'},
    {'1': 'platform_amount', '3': 7, '4': 1, '5': 9, '10': 'platformAmount'},
    {'1': 'currency', '3': 8, '4': 1, '5': 9, '10': 'currency'},
    {
      '1': 'status',
      '3': 9,
      '4': 1,
      '5': 14,
      '6': '.creativanta.automation.v1.RevenueShareStatus',
      '10': 'status'
    },
    {
      '1': 'refund_eligible_until',
      '3': 10,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'refundEligibleUntil'
    },
    {
      '1': 'created_at',
      '3': 11,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'createdAt'
    },
    {
      '1': 'updated_at',
      '3': 12,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'updatedAt'
    },
  ],
};

/// Descriptor for `RecipeRevenueShare`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List recipeRevenueShareDescriptor = $convert.base64Decode(
    'ChJSZWNpcGVSZXZlbnVlU2hhcmUSKAoQcmV2ZW51ZV9zaGFyZV9pZBgBIAEoCVIOcmV2ZW51ZV'
    'NoYXJlSWQSGwoJcmVjaXBlX2lkGAIgASgJUghyZWNpcGVJZBIuChNhdXRob3Jfd29ya3NwYWNl'
    'X2lkGAMgASgJUhFhdXRob3JXb3Jrc3BhY2VJZBI0ChZwdXJjaGFzZXJfd29ya3NwYWNlX2lkGA'
    'QgASgJUhRwdXJjaGFzZXJXb3Jrc3BhY2VJZBIhCgxncm9zc19hbW91bnQYBSABKAlSC2dyb3Nz'
    'QW1vdW50EiUKDmNyZWF0b3JfYW1vdW50GAYgASgJUg1jcmVhdG9yQW1vdW50EicKD3BsYXRmb3'
    'JtX2Ftb3VudBgHIAEoCVIOcGxhdGZvcm1BbW91bnQSGgoIY3VycmVuY3kYCCABKAlSCGN1cnJl'
    'bmN5EkUKBnN0YXR1cxgJIAEoDjItLmNyZWF0aXZhbnRhLmF1dG9tYXRpb24udjEuUmV2ZW51ZV'
    'NoYXJlU3RhdHVzUgZzdGF0dXMSTgoVcmVmdW5kX2VsaWdpYmxlX3VudGlsGAogASgLMhouZ29v'
    'Z2xlLnByb3RvYnVmLlRpbWVzdGFtcFITcmVmdW5kRWxpZ2libGVVbnRpbBI5CgpjcmVhdGVkX2'
    'F0GAsgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIJY3JlYXRlZEF0EjkKCnVwZGF0'
    'ZWRfYXQYDCABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUgl1cGRhdGVkQXQ=');

@$core.Deprecated('Use recipeServiceInstallRequestDescriptor instead')
const RecipeServiceInstallRequest$json = {
  '1': 'RecipeServiceInstallRequest',
  '2': [
    {'1': 'idempotency_key', '3': 1, '4': 1, '5': 9, '10': 'idempotencyKey'},
    {'1': 'workspace_id', '3': 2, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'recipe_id', '3': 3, '4': 1, '5': 9, '10': 'recipeId'},
    {
      '1': 'parameter_values_json',
      '3': 4,
      '4': 1,
      '5': 9,
      '10': 'parameterValuesJson'
    },
    {'1': 'title_override', '3': 5, '4': 1, '5': 9, '10': 'titleOverride'},
  ],
};

/// Descriptor for `RecipeServiceInstallRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List recipeServiceInstallRequestDescriptor = $convert.base64Decode(
    'ChtSZWNpcGVTZXJ2aWNlSW5zdGFsbFJlcXVlc3QSJwoPaWRlbXBvdGVuY3lfa2V5GAEgASgJUg'
    '5pZGVtcG90ZW5jeUtleRIhCgx3b3Jrc3BhY2VfaWQYAiABKAlSC3dvcmtzcGFjZUlkEhsKCXJl'
    'Y2lwZV9pZBgDIAEoCVIIcmVjaXBlSWQSMgoVcGFyYW1ldGVyX3ZhbHVlc19qc29uGAQgASgJUh'
    'NwYXJhbWV0ZXJWYWx1ZXNKc29uEiUKDnRpdGxlX292ZXJyaWRlGAUgASgJUg10aXRsZU92ZXJy'
    'aWRl');

@$core.Deprecated('Use recipeServiceInstallResponseDescriptor instead')
const RecipeServiceInstallResponse$json = {
  '1': 'RecipeServiceInstallResponse',
  '2': [
    {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
    {
      '1': 'installation',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.creativanta.automation.v1.RecipeInstallation',
      '10': 'installation'
    },
    {
      '1': 'created_workflow',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.creativanta.automation.v1.Workflow',
      '10': 'createdWorkflow'
    },
    {
      '1': 'missing_capabilities',
      '3': 4,
      '4': 3,
      '5': 11,
      '6': '.creativanta.automation.v1.MissingCapabilityExplanation',
      '10': 'missingCapabilities'
    },
  ],
};

/// Descriptor for `RecipeServiceInstallResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List recipeServiceInstallResponseDescriptor = $convert.base64Decode(
    'ChxSZWNpcGVTZXJ2aWNlSW5zdGFsbFJlc3BvbnNlEhgKB3N1Y2Nlc3MYASABKAhSB3N1Y2Nlc3'
    'MSUQoMaW5zdGFsbGF0aW9uGAIgASgLMi0uY3JlYXRpdmFudGEuYXV0b21hdGlvbi52MS5SZWNp'
    'cGVJbnN0YWxsYXRpb25SDGluc3RhbGxhdGlvbhJOChBjcmVhdGVkX3dvcmtmbG93GAMgASgLMi'
    'MuY3JlYXRpdmFudGEuYXV0b21hdGlvbi52MS5Xb3JrZmxvd1IPY3JlYXRlZFdvcmtmbG93EmoK'
    'FG1pc3NpbmdfY2FwYWJpbGl0aWVzGAQgAygLMjcuY3JlYXRpdmFudGEuYXV0b21hdGlvbi52MS'
    '5NaXNzaW5nQ2FwYWJpbGl0eUV4cGxhbmF0aW9uUhNtaXNzaW5nQ2FwYWJpbGl0aWVz');

@$core.Deprecated('Use recipeServiceUninstallRequestDescriptor instead')
const RecipeServiceUninstallRequest$json = {
  '1': 'RecipeServiceUninstallRequest',
  '2': [
    {'1': 'idempotency_key', '3': 1, '4': 1, '5': 9, '10': 'idempotencyKey'},
    {'1': 'workspace_id', '3': 2, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'installation_id', '3': 3, '4': 1, '5': 9, '10': 'installationId'},
    {'1': 'delete_workflow', '3': 4, '4': 1, '5': 8, '10': 'deleteWorkflow'},
  ],
};

/// Descriptor for `RecipeServiceUninstallRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List recipeServiceUninstallRequestDescriptor = $convert.base64Decode(
    'Ch1SZWNpcGVTZXJ2aWNlVW5pbnN0YWxsUmVxdWVzdBInCg9pZGVtcG90ZW5jeV9rZXkYASABKA'
    'lSDmlkZW1wb3RlbmN5S2V5EiEKDHdvcmtzcGFjZV9pZBgCIAEoCVILd29ya3NwYWNlSWQSJwoP'
    'aW5zdGFsbGF0aW9uX2lkGAMgASgJUg5pbnN0YWxsYXRpb25JZBInCg9kZWxldGVfd29ya2Zsb3'
    'cYBCABKAhSDmRlbGV0ZVdvcmtmbG93');

@$core.Deprecated('Use recipeServiceUninstallResponseDescriptor instead')
const RecipeServiceUninstallResponse$json = {
  '1': 'RecipeServiceUninstallResponse',
  '2': [
    {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
  ],
};

/// Descriptor for `RecipeServiceUninstallResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List recipeServiceUninstallResponseDescriptor =
    $convert.base64Decode(
        'Ch5SZWNpcGVTZXJ2aWNlVW5pbnN0YWxsUmVzcG9uc2USGAoHc3VjY2VzcxgBIAEoCFIHc3VjY2'
        'Vzcw==');

@$core.Deprecated('Use recipeServiceListRequestDescriptor instead')
const RecipeServiceListRequest$json = {
  '1': 'RecipeServiceListRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'category', '3': 2, '4': 1, '5': 9, '10': 'category'},
    {'1': 'status_filter', '3': 3, '4': 1, '5': 9, '10': 'statusFilter'},
    {'1': 'include_system', '3': 4, '4': 1, '5': 8, '10': 'includeSystem'},
    {'1': 'page_size', '3': 5, '4': 1, '5': 5, '10': 'pageSize'},
    {'1': 'page_token', '3': 6, '4': 1, '5': 9, '10': 'pageToken'},
  ],
};

/// Descriptor for `RecipeServiceListRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List recipeServiceListRequestDescriptor = $convert.base64Decode(
    'ChhSZWNpcGVTZXJ2aWNlTGlzdFJlcXVlc3QSIQoMd29ya3NwYWNlX2lkGAEgASgJUgt3b3Jrc3'
    'BhY2VJZBIaCghjYXRlZ29yeRgCIAEoCVIIY2F0ZWdvcnkSIwoNc3RhdHVzX2ZpbHRlchgDIAEo'
    'CVIMc3RhdHVzRmlsdGVyEiUKDmluY2x1ZGVfc3lzdGVtGAQgASgIUg1pbmNsdWRlU3lzdGVtEh'
    'sKCXBhZ2Vfc2l6ZRgFIAEoBVIIcGFnZVNpemUSHQoKcGFnZV90b2tlbhgGIAEoCVIJcGFnZVRv'
    'a2Vu');

@$core.Deprecated('Use recipeServiceListResponseDescriptor instead')
const RecipeServiceListResponse$json = {
  '1': 'RecipeServiceListResponse',
  '2': [
    {
      '1': 'recipes',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.creativanta.automation.v1.RecipeTemplate',
      '10': 'recipes'
    },
    {
      '1': 'installations',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.creativanta.automation.v1.RecipeInstallation',
      '10': 'installations'
    },
    {'1': 'next_page_token', '3': 3, '4': 1, '5': 9, '10': 'nextPageToken'},
    {'1': 'total_count', '3': 4, '4': 1, '5': 5, '10': 'totalCount'},
  ],
};

/// Descriptor for `RecipeServiceListResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List recipeServiceListResponseDescriptor = $convert.base64Decode(
    'ChlSZWNpcGVTZXJ2aWNlTGlzdFJlc3BvbnNlEkMKB3JlY2lwZXMYASADKAsyKS5jcmVhdGl2YW'
    '50YS5hdXRvbWF0aW9uLnYxLlJlY2lwZVRlbXBsYXRlUgdyZWNpcGVzElMKDWluc3RhbGxhdGlv'
    'bnMYAiADKAsyLS5jcmVhdGl2YW50YS5hdXRvbWF0aW9uLnYxLlJlY2lwZUluc3RhbGxhdGlvbl'
    'INaW5zdGFsbGF0aW9ucxImCg9uZXh0X3BhZ2VfdG9rZW4YAyABKAlSDW5leHRQYWdlVG9rZW4S'
    'HwoLdG90YWxfY291bnQYBCABKAVSCnRvdGFsQ291bnQ=');

@$core.Deprecated('Use recipeServiceGetRequestDescriptor instead')
const RecipeServiceGetRequest$json = {
  '1': 'RecipeServiceGetRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'recipe_id', '3': 2, '4': 1, '5': 9, '10': 'recipeId'},
  ],
};

/// Descriptor for `RecipeServiceGetRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List recipeServiceGetRequestDescriptor =
    $convert.base64Decode(
        'ChdSZWNpcGVTZXJ2aWNlR2V0UmVxdWVzdBIhCgx3b3Jrc3BhY2VfaWQYASABKAlSC3dvcmtzcG'
        'FjZUlkEhsKCXJlY2lwZV9pZBgCIAEoCVIIcmVjaXBlSWQ=');

@$core.Deprecated('Use recipeServiceGetResponseDescriptor instead')
const RecipeServiceGetResponse$json = {
  '1': 'RecipeServiceGetResponse',
  '2': [
    {
      '1': 'recipe',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.automation.v1.RecipeTemplate',
      '10': 'recipe'
    },
    {
      '1': 'missing_capabilities',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.creativanta.automation.v1.MissingCapabilityExplanation',
      '10': 'missingCapabilities'
    },
    {
      '1': 'active_installation',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.creativanta.automation.v1.RecipeInstallation',
      '10': 'activeInstallation'
    },
  ],
};

/// Descriptor for `RecipeServiceGetResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List recipeServiceGetResponseDescriptor = $convert.base64Decode(
    'ChhSZWNpcGVTZXJ2aWNlR2V0UmVzcG9uc2USQQoGcmVjaXBlGAEgASgLMikuY3JlYXRpdmFudG'
    'EuYXV0b21hdGlvbi52MS5SZWNpcGVUZW1wbGF0ZVIGcmVjaXBlEmoKFG1pc3NpbmdfY2FwYWJp'
    'bGl0aWVzGAIgAygLMjcuY3JlYXRpdmFudGEuYXV0b21hdGlvbi52MS5NaXNzaW5nQ2FwYWJpbG'
    'l0eUV4cGxhbmF0aW9uUhNtaXNzaW5nQ2FwYWJpbGl0aWVzEl4KE2FjdGl2ZV9pbnN0YWxsYXRp'
    'b24YAyABKAsyLS5jcmVhdGl2YW50YS5hdXRvbWF0aW9uLnYxLlJlY2lwZUluc3RhbGxhdGlvbl'
    'ISYWN0aXZlSW5zdGFsbGF0aW9u');

@$core.Deprecated('Use recipeServiceRunRequestDescriptor instead')
const RecipeServiceRunRequest$json = {
  '1': 'RecipeServiceRunRequest',
  '2': [
    {'1': 'idempotency_key', '3': 1, '4': 1, '5': 9, '10': 'idempotencyKey'},
    {'1': 'workspace_id', '3': 2, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'recipe_id', '3': 3, '4': 1, '5': 9, '10': 'recipeId'},
    {
      '1': 'parameter_overrides_json',
      '3': 4,
      '4': 1,
      '5': 9,
      '10': 'parameterOverridesJson'
    },
  ],
};

/// Descriptor for `RecipeServiceRunRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List recipeServiceRunRequestDescriptor = $convert.base64Decode(
    'ChdSZWNpcGVTZXJ2aWNlUnVuUmVxdWVzdBInCg9pZGVtcG90ZW5jeV9rZXkYASABKAlSDmlkZW'
    '1wb3RlbmN5S2V5EiEKDHdvcmtzcGFjZV9pZBgCIAEoCVILd29ya3NwYWNlSWQSGwoJcmVjaXBl'
    'X2lkGAMgASgJUghyZWNpcGVJZBI4ChhwYXJhbWV0ZXJfb3ZlcnJpZGVzX2pzb24YBCABKAlSFn'
    'BhcmFtZXRlck92ZXJyaWRlc0pzb24=');

@$core.Deprecated('Use recipeServiceRunResponseDescriptor instead')
const RecipeServiceRunResponse$json = {
  '1': 'RecipeServiceRunResponse',
  '2': [
    {'1': 'workflow_run_id', '3': 1, '4': 1, '5': 9, '10': 'workflowRunId'},
    {
      '1': 'status',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.creativanta.automation.v1.WorkflowRunStatus',
      '10': 'status'
    },
  ],
};

/// Descriptor for `RecipeServiceRunResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List recipeServiceRunResponseDescriptor = $convert.base64Decode(
    'ChhSZWNpcGVTZXJ2aWNlUnVuUmVzcG9uc2USJgoPd29ya2Zsb3dfcnVuX2lkGAEgASgJUg13b3'
    'JrZmxvd1J1bklkEkQKBnN0YXR1cxgCIAEoDjIsLmNyZWF0aXZhbnRhLmF1dG9tYXRpb24udjEu'
    'V29ya2Zsb3dSdW5TdGF0dXNSBnN0YXR1cw==');

@$core.Deprecated('Use recipeServiceGetRunStatusRequestDescriptor instead')
const RecipeServiceGetRunStatusRequest$json = {
  '1': 'RecipeServiceGetRunStatusRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'run_id', '3': 2, '4': 1, '5': 9, '10': 'runId'},
  ],
};

/// Descriptor for `RecipeServiceGetRunStatusRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List recipeServiceGetRunStatusRequestDescriptor =
    $convert.base64Decode(
        'CiBSZWNpcGVTZXJ2aWNlR2V0UnVuU3RhdHVzUmVxdWVzdBIhCgx3b3Jrc3BhY2VfaWQYASABKA'
        'lSC3dvcmtzcGFjZUlkEhUKBnJ1bl9pZBgCIAEoCVIFcnVuSWQ=');

@$core.Deprecated('Use recipeServiceGetRunStatusResponseDescriptor instead')
const RecipeServiceGetRunStatusResponse$json = {
  '1': 'RecipeServiceGetRunStatusResponse',
  '2': [
    {'1': 'run_id', '3': 1, '4': 1, '5': 9, '10': 'runId'},
    {
      '1': 'status',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.creativanta.automation.v1.WorkflowRunStatus',
      '10': 'status'
    },
    {'1': 'current_node', '3': 3, '4': 1, '5': 9, '10': 'currentNode'},
    {
      '1': 'completed_at',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'completedAt'
    },
    {'1': 'error_message', '3': 5, '4': 1, '5': 9, '10': 'errorMessage'},
  ],
};

/// Descriptor for `RecipeServiceGetRunStatusResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List recipeServiceGetRunStatusResponseDescriptor = $convert.base64Decode(
    'CiFSZWNpcGVTZXJ2aWNlR2V0UnVuU3RhdHVzUmVzcG9uc2USFQoGcnVuX2lkGAEgASgJUgVydW'
    '5JZBJECgZzdGF0dXMYAiABKA4yLC5jcmVhdGl2YW50YS5hdXRvbWF0aW9uLnYxLldvcmtmbG93'
    'UnVuU3RhdHVzUgZzdGF0dXMSIQoMY3VycmVudF9ub2RlGAMgASgJUgtjdXJyZW50Tm9kZRI9Cg'
    'xjb21wbGV0ZWRfYXQYBCABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUgtjb21wbGV0'
    'ZWRBdBIjCg1lcnJvcl9tZXNzYWdlGAUgASgJUgxlcnJvck1lc3NhZ2U=');

@$core.Deprecated('Use recipeServiceListRunsRequestDescriptor instead')
const RecipeServiceListRunsRequest$json = {
  '1': 'RecipeServiceListRunsRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'recipe_id', '3': 2, '4': 1, '5': 9, '10': 'recipeId'},
    {'1': 'page_size', '3': 3, '4': 1, '5': 5, '10': 'pageSize'},
    {'1': 'page_token', '3': 4, '4': 1, '5': 9, '10': 'pageToken'},
  ],
};

/// Descriptor for `RecipeServiceListRunsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List recipeServiceListRunsRequestDescriptor =
    $convert.base64Decode(
        'ChxSZWNpcGVTZXJ2aWNlTGlzdFJ1bnNSZXF1ZXN0EiEKDHdvcmtzcGFjZV9pZBgBIAEoCVILd2'
        '9ya3NwYWNlSWQSGwoJcmVjaXBlX2lkGAIgASgJUghyZWNpcGVJZBIbCglwYWdlX3NpemUYAyAB'
        'KAVSCHBhZ2VTaXplEh0KCnBhZ2VfdG9rZW4YBCABKAlSCXBhZ2VUb2tlbg==');

@$core.Deprecated('Use recipeServiceListRunsResponseDescriptor instead')
const RecipeServiceListRunsResponse$json = {
  '1': 'RecipeServiceListRunsResponse',
  '2': [
    {
      '1': 'runs',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.creativanta.automation.v1.WorkflowRun',
      '10': 'runs'
    },
    {'1': 'next_page_token', '3': 2, '4': 1, '5': 9, '10': 'nextPageToken'},
    {'1': 'total_count', '3': 3, '4': 1, '5': 5, '10': 'totalCount'},
  ],
};

/// Descriptor for `RecipeServiceListRunsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List recipeServiceListRunsResponseDescriptor = $convert.base64Decode(
    'Ch1SZWNpcGVTZXJ2aWNlTGlzdFJ1bnNSZXNwb25zZRI6CgRydW5zGAEgAygLMiYuY3JlYXRpdm'
    'FudGEuYXV0b21hdGlvbi52MS5Xb3JrZmxvd1J1blIEcnVucxImCg9uZXh0X3BhZ2VfdG9rZW4Y'
    'AiABKAlSDW5leHRQYWdlVG9rZW4SHwoLdG90YWxfY291bnQYAyABKAVSCnRvdGFsQ291bnQ=');

@$core.Deprecated('Use recipeServiceConfigureRequestDescriptor instead')
const RecipeServiceConfigureRequest$json = {
  '1': 'RecipeServiceConfigureRequest',
  '2': [
    {'1': 'idempotency_key', '3': 1, '4': 1, '5': 9, '10': 'idempotencyKey'},
    {'1': 'workspace_id', '3': 2, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'installation_id', '3': 3, '4': 1, '5': 9, '10': 'installationId'},
    {
      '1': 'parameter_values_json',
      '3': 4,
      '4': 1,
      '5': 9,
      '10': 'parameterValuesJson'
    },
    {'1': 'pinned_version', '3': 5, '4': 1, '5': 5, '10': 'pinnedVersion'},
    {'1': 'auto_update', '3': 6, '4': 1, '5': 8, '10': 'autoUpdate'},
  ],
};

/// Descriptor for `RecipeServiceConfigureRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List recipeServiceConfigureRequestDescriptor = $convert.base64Decode(
    'Ch1SZWNpcGVTZXJ2aWNlQ29uZmlndXJlUmVxdWVzdBInCg9pZGVtcG90ZW5jeV9rZXkYASABKA'
    'lSDmlkZW1wb3RlbmN5S2V5EiEKDHdvcmtzcGFjZV9pZBgCIAEoCVILd29ya3NwYWNlSWQSJwoP'
    'aW5zdGFsbGF0aW9uX2lkGAMgASgJUg5pbnN0YWxsYXRpb25JZBIyChVwYXJhbWV0ZXJfdmFsdW'
    'VzX2pzb24YBCABKAlSE3BhcmFtZXRlclZhbHVlc0pzb24SJQoOcGlubmVkX3ZlcnNpb24YBSAB'
    'KAVSDXBpbm5lZFZlcnNpb24SHwoLYXV0b191cGRhdGUYBiABKAhSCmF1dG9VcGRhdGU=');

@$core.Deprecated('Use recipeServiceConfigureResponseDescriptor instead')
const RecipeServiceConfigureResponse$json = {
  '1': 'RecipeServiceConfigureResponse',
  '2': [
    {
      '1': 'installation',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.automation.v1.RecipeInstallation',
      '10': 'installation'
    },
  ],
};

/// Descriptor for `RecipeServiceConfigureResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List recipeServiceConfigureResponseDescriptor =
    $convert.base64Decode(
        'Ch5SZWNpcGVTZXJ2aWNlQ29uZmlndXJlUmVzcG9uc2USUQoMaW5zdGFsbGF0aW9uGAEgASgLMi'
        '0uY3JlYXRpdmFudGEuYXV0b21hdGlvbi52MS5SZWNpcGVJbnN0YWxsYXRpb25SDGluc3RhbGxh'
        'dGlvbg==');

@$core.Deprecated('Use templateServiceListTemplatesRequestDescriptor instead')
const TemplateServiceListTemplatesRequest$json = {
  '1': 'TemplateServiceListTemplatesRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'category', '3': 2, '4': 1, '5': 9, '10': 'category'},
    {'1': 'page_size', '3': 3, '4': 1, '5': 5, '10': 'pageSize'},
    {'1': 'page_token', '3': 4, '4': 1, '5': 9, '10': 'pageToken'},
  ],
};

/// Descriptor for `TemplateServiceListTemplatesRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List templateServiceListTemplatesRequestDescriptor =
    $convert.base64Decode(
        'CiNUZW1wbGF0ZVNlcnZpY2VMaXN0VGVtcGxhdGVzUmVxdWVzdBIhCgx3b3Jrc3BhY2VfaWQYAS'
        'ABKAlSC3dvcmtzcGFjZUlkEhoKCGNhdGVnb3J5GAIgASgJUghjYXRlZ29yeRIbCglwYWdlX3Np'
        'emUYAyABKAVSCHBhZ2VTaXplEh0KCnBhZ2VfdG9rZW4YBCABKAlSCXBhZ2VUb2tlbg==');

@$core.Deprecated('Use templateServiceListTemplatesResponseDescriptor instead')
const TemplateServiceListTemplatesResponse$json = {
  '1': 'TemplateServiceListTemplatesResponse',
  '2': [
    {
      '1': 'templates',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.creativanta.automation.v1.RecipeTemplate',
      '10': 'templates'
    },
    {'1': 'next_page_token', '3': 2, '4': 1, '5': 9, '10': 'nextPageToken'},
    {'1': 'total_count', '3': 3, '4': 1, '5': 5, '10': 'totalCount'},
  ],
};

/// Descriptor for `TemplateServiceListTemplatesResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List templateServiceListTemplatesResponseDescriptor =
    $convert.base64Decode(
        'CiRUZW1wbGF0ZVNlcnZpY2VMaXN0VGVtcGxhdGVzUmVzcG9uc2USRwoJdGVtcGxhdGVzGAEgAy'
        'gLMikuY3JlYXRpdmFudGEuYXV0b21hdGlvbi52MS5SZWNpcGVUZW1wbGF0ZVIJdGVtcGxhdGVz'
        'EiYKD25leHRfcGFnZV90b2tlbhgCIAEoCVINbmV4dFBhZ2VUb2tlbhIfCgt0b3RhbF9jb3VudB'
        'gDIAEoBVIKdG90YWxDb3VudA==');

@$core.Deprecated('Use templateServiceGetTemplateRequestDescriptor instead')
const TemplateServiceGetTemplateRequest$json = {
  '1': 'TemplateServiceGetTemplateRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'template_id', '3': 2, '4': 1, '5': 9, '10': 'templateId'},
  ],
};

/// Descriptor for `TemplateServiceGetTemplateRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List templateServiceGetTemplateRequestDescriptor =
    $convert.base64Decode(
        'CiFUZW1wbGF0ZVNlcnZpY2VHZXRUZW1wbGF0ZVJlcXVlc3QSIQoMd29ya3NwYWNlX2lkGAEgAS'
        'gJUgt3b3Jrc3BhY2VJZBIfCgt0ZW1wbGF0ZV9pZBgCIAEoCVIKdGVtcGxhdGVJZA==');

@$core.Deprecated('Use templateServiceGetTemplateResponseDescriptor instead')
const TemplateServiceGetTemplateResponse$json = {
  '1': 'TemplateServiceGetTemplateResponse',
  '2': [
    {
      '1': 'template',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.automation.v1.RecipeTemplate',
      '10': 'template'
    },
    {
      '1': 'missing_capabilities',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.creativanta.automation.v1.MissingCapabilityExplanation',
      '10': 'missingCapabilities'
    },
  ],
};

/// Descriptor for `TemplateServiceGetTemplateResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List templateServiceGetTemplateResponseDescriptor =
    $convert.base64Decode(
        'CiJUZW1wbGF0ZVNlcnZpY2VHZXRUZW1wbGF0ZVJlc3BvbnNlEkUKCHRlbXBsYXRlGAEgASgLMi'
        'kuY3JlYXRpdmFudGEuYXV0b21hdGlvbi52MS5SZWNpcGVUZW1wbGF0ZVIIdGVtcGxhdGUSagoU'
        'bWlzc2luZ19jYXBhYmlsaXRpZXMYAiADKAsyNy5jcmVhdGl2YW50YS5hdXRvbWF0aW9uLnYxLk'
        '1pc3NpbmdDYXBhYmlsaXR5RXhwbGFuYXRpb25SE21pc3NpbmdDYXBhYmlsaXRpZXM=');

@$core.Deprecated('Use templateServiceSearchTemplatesRequestDescriptor instead')
const TemplateServiceSearchTemplatesRequest$json = {
  '1': 'TemplateServiceSearchTemplatesRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'query', '3': 2, '4': 1, '5': 9, '10': 'query'},
    {'1': 'category', '3': 3, '4': 1, '5': 9, '10': 'category'},
    {'1': 'tags', '3': 4, '4': 3, '5': 9, '10': 'tags'},
    {'1': 'page_size', '3': 5, '4': 1, '5': 5, '10': 'pageSize'},
    {'1': 'page_token', '3': 6, '4': 1, '5': 9, '10': 'pageToken'},
  ],
};

/// Descriptor for `TemplateServiceSearchTemplatesRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List templateServiceSearchTemplatesRequestDescriptor =
    $convert.base64Decode(
        'CiVUZW1wbGF0ZVNlcnZpY2VTZWFyY2hUZW1wbGF0ZXNSZXF1ZXN0EiEKDHdvcmtzcGFjZV9pZB'
        'gBIAEoCVILd29ya3NwYWNlSWQSFAoFcXVlcnkYAiABKAlSBXF1ZXJ5EhoKCGNhdGVnb3J5GAMg'
        'ASgJUghjYXRlZ29yeRISCgR0YWdzGAQgAygJUgR0YWdzEhsKCXBhZ2Vfc2l6ZRgFIAEoBVIIcG'
        'FnZVNpemUSHQoKcGFnZV90b2tlbhgGIAEoCVIJcGFnZVRva2Vu');

@$core
    .Deprecated('Use templateServiceSearchTemplatesResponseDescriptor instead')
const TemplateServiceSearchTemplatesResponse$json = {
  '1': 'TemplateServiceSearchTemplatesResponse',
  '2': [
    {
      '1': 'templates',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.creativanta.automation.v1.RecipeTemplate',
      '10': 'templates'
    },
    {'1': 'next_page_token', '3': 2, '4': 1, '5': 9, '10': 'nextPageToken'},
    {'1': 'total_count', '3': 3, '4': 1, '5': 5, '10': 'totalCount'},
  ],
};

/// Descriptor for `TemplateServiceSearchTemplatesResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List templateServiceSearchTemplatesResponseDescriptor =
    $convert.base64Decode(
        'CiZUZW1wbGF0ZVNlcnZpY2VTZWFyY2hUZW1wbGF0ZXNSZXNwb25zZRJHCgl0ZW1wbGF0ZXMYAS'
        'ADKAsyKS5jcmVhdGl2YW50YS5hdXRvbWF0aW9uLnYxLlJlY2lwZVRlbXBsYXRlUgl0ZW1wbGF0'
        'ZXMSJgoPbmV4dF9wYWdlX3Rva2VuGAIgASgJUg1uZXh0UGFnZVRva2VuEh8KC3RvdGFsX2NvdW'
        '50GAMgASgFUgp0b3RhbENvdW50');

@$core.Deprecated('Use templateServiceGetFeaturedRequestDescriptor instead')
const TemplateServiceGetFeaturedRequest$json = {
  '1': 'TemplateServiceGetFeaturedRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'category', '3': 2, '4': 1, '5': 9, '10': 'category'},
  ],
};

/// Descriptor for `TemplateServiceGetFeaturedRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List templateServiceGetFeaturedRequestDescriptor =
    $convert.base64Decode(
        'CiFUZW1wbGF0ZVNlcnZpY2VHZXRGZWF0dXJlZFJlcXVlc3QSIQoMd29ya3NwYWNlX2lkGAEgAS'
        'gJUgt3b3Jrc3BhY2VJZBIaCghjYXRlZ29yeRgCIAEoCVIIY2F0ZWdvcnk=');

@$core.Deprecated('Use templateServiceGetFeaturedResponseDescriptor instead')
const TemplateServiceGetFeaturedResponse$json = {
  '1': 'TemplateServiceGetFeaturedResponse',
  '2': [
    {
      '1': 'featured_templates',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.creativanta.automation.v1.RecipeTemplate',
      '10': 'featuredTemplates'
    },
    {
      '1': 'weekly_highlight',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.creativanta.automation.v1.RecipeTemplate',
      '10': 'weeklyHighlight'
    },
  ],
};

/// Descriptor for `TemplateServiceGetFeaturedResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List templateServiceGetFeaturedResponseDescriptor =
    $convert.base64Decode(
        'CiJUZW1wbGF0ZVNlcnZpY2VHZXRGZWF0dXJlZFJlc3BvbnNlElgKEmZlYXR1cmVkX3RlbXBsYX'
        'RlcxgBIAMoCzIpLmNyZWF0aXZhbnRhLmF1dG9tYXRpb24udjEuUmVjaXBlVGVtcGxhdGVSEWZl'
        'YXR1cmVkVGVtcGxhdGVzElQKEHdlZWtseV9oaWdobGlnaHQYAiABKAsyKS5jcmVhdGl2YW50YS'
        '5hdXRvbWF0aW9uLnYxLlJlY2lwZVRlbXBsYXRlUg93ZWVrbHlIaWdobGlnaHQ=');

@$core.Deprecated('Use templateServiceGetReviewsRequestDescriptor instead')
const TemplateServiceGetReviewsRequest$json = {
  '1': 'TemplateServiceGetReviewsRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'template_id', '3': 2, '4': 1, '5': 9, '10': 'templateId'},
    {'1': 'page_size', '3': 3, '4': 1, '5': 5, '10': 'pageSize'},
    {'1': 'page_token', '3': 4, '4': 1, '5': 9, '10': 'pageToken'},
  ],
};

/// Descriptor for `TemplateServiceGetReviewsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List templateServiceGetReviewsRequestDescriptor =
    $convert.base64Decode(
        'CiBUZW1wbGF0ZVNlcnZpY2VHZXRSZXZpZXdzUmVxdWVzdBIhCgx3b3Jrc3BhY2VfaWQYASABKA'
        'lSC3dvcmtzcGFjZUlkEh8KC3RlbXBsYXRlX2lkGAIgASgJUgp0ZW1wbGF0ZUlkEhsKCXBhZ2Vf'
        'c2l6ZRgDIAEoBVIIcGFnZVNpemUSHQoKcGFnZV90b2tlbhgEIAEoCVIJcGFnZVRva2Vu');

@$core.Deprecated('Use templateServiceGetReviewsResponseDescriptor instead')
const TemplateServiceGetReviewsResponse$json = {
  '1': 'TemplateServiceGetReviewsResponse',
  '2': [
    {
      '1': 'reviews',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.creativanta.automation.v1.RecipeReview',
      '10': 'reviews'
    },
    {'1': 'rating_avg', '3': 2, '4': 1, '5': 2, '10': 'ratingAvg'},
    {'1': 'review_count', '3': 3, '4': 1, '5': 5, '10': 'reviewCount'},
    {'1': 'next_page_token', '3': 4, '4': 1, '5': 9, '10': 'nextPageToken'},
  ],
};

/// Descriptor for `TemplateServiceGetReviewsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List templateServiceGetReviewsResponseDescriptor =
    $convert.base64Decode(
        'CiFUZW1wbGF0ZVNlcnZpY2VHZXRSZXZpZXdzUmVzcG9uc2USQQoHcmV2aWV3cxgBIAMoCzInLm'
        'NyZWF0aXZhbnRhLmF1dG9tYXRpb24udjEuUmVjaXBlUmV2aWV3UgdyZXZpZXdzEh0KCnJhdGlu'
        'Z19hdmcYAiABKAJSCXJhdGluZ0F2ZxIhCgxyZXZpZXdfY291bnQYAyABKAVSC3Jldmlld0NvdW'
        '50EiYKD25leHRfcGFnZV90b2tlbhgEIAEoCVINbmV4dFBhZ2VUb2tlbg==');

@$core.Deprecated('Use templateServiceDeployRequestDescriptor instead')
const TemplateServiceDeployRequest$json = {
  '1': 'TemplateServiceDeployRequest',
  '2': [
    {'1': 'idempotency_key', '3': 1, '4': 1, '5': 9, '10': 'idempotencyKey'},
    {'1': 'workspace_id', '3': 2, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'template_id', '3': 3, '4': 1, '5': 9, '10': 'templateId'},
    {
      '1': 'parameter_values_json',
      '3': 4,
      '4': 1,
      '5': 9,
      '10': 'parameterValuesJson'
    },
    {'1': 'title_override', '3': 5, '4': 1, '5': 9, '10': 'titleOverride'},
  ],
};

/// Descriptor for `TemplateServiceDeployRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List templateServiceDeployRequestDescriptor = $convert.base64Decode(
    'ChxUZW1wbGF0ZVNlcnZpY2VEZXBsb3lSZXF1ZXN0EicKD2lkZW1wb3RlbmN5X2tleRgBIAEoCV'
    'IOaWRlbXBvdGVuY3lLZXkSIQoMd29ya3NwYWNlX2lkGAIgASgJUgt3b3Jrc3BhY2VJZBIfCgt0'
    'ZW1wbGF0ZV9pZBgDIAEoCVIKdGVtcGxhdGVJZBIyChVwYXJhbWV0ZXJfdmFsdWVzX2pzb24YBC'
    'ABKAlSE3BhcmFtZXRlclZhbHVlc0pzb24SJQoOdGl0bGVfb3ZlcnJpZGUYBSABKAlSDXRpdGxl'
    'T3ZlcnJpZGU=');

@$core.Deprecated('Use templateServiceDeployResponseDescriptor instead')
const TemplateServiceDeployResponse$json = {
  '1': 'TemplateServiceDeployResponse',
  '2': [
    {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
    {'1': 'workflow_id', '3': 2, '4': 1, '5': 9, '10': 'workflowId'},
    {
      '1': 'created_workflow',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.creativanta.automation.v1.Workflow',
      '10': 'createdWorkflow'
    },
    {'1': 'installation_id', '3': 4, '4': 1, '5': 9, '10': 'installationId'},
    {
      '1': 'missing_capabilities',
      '3': 5,
      '4': 3,
      '5': 11,
      '6': '.creativanta.automation.v1.MissingCapabilityExplanation',
      '10': 'missingCapabilities'
    },
  ],
};

/// Descriptor for `TemplateServiceDeployResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List templateServiceDeployResponseDescriptor = $convert.base64Decode(
    'Ch1UZW1wbGF0ZVNlcnZpY2VEZXBsb3lSZXNwb25zZRIYCgdzdWNjZXNzGAEgASgIUgdzdWNjZX'
    'NzEh8KC3dvcmtmbG93X2lkGAIgASgJUgp3b3JrZmxvd0lkEk4KEGNyZWF0ZWRfd29ya2Zsb3cY'
    'AyABKAsyIy5jcmVhdGl2YW50YS5hdXRvbWF0aW9uLnYxLldvcmtmbG93Ug9jcmVhdGVkV29ya2'
    'Zsb3cSJwoPaW5zdGFsbGF0aW9uX2lkGAQgASgJUg5pbnN0YWxsYXRpb25JZBJqChRtaXNzaW5n'
    'X2NhcGFiaWxpdGllcxgFIAMoCzI3LmNyZWF0aXZhbnRhLmF1dG9tYXRpb24udjEuTWlzc2luZ0'
    'NhcGFiaWxpdHlFeHBsYW5hdGlvblITbWlzc2luZ0NhcGFiaWxpdGllcw==');

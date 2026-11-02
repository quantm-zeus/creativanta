// This is a generated file - do not edit.
//
// Generated from creativanta/admin/v1/help.proto.

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

@$core.Deprecated('Use kBArticleStatusDescriptor instead')
const KBArticleStatus$json = {
  '1': 'KBArticleStatus',
  '2': [
    {'1': 'KB_ARTICLE_STATUS_UNSPECIFIED', '2': 0},
    {'1': 'KB_ARTICLE_STATUS_DRAFT', '2': 1},
    {'1': 'KB_ARTICLE_STATUS_REVIEW', '2': 2},
    {'1': 'KB_ARTICLE_STATUS_PUBLISHED', '2': 3},
    {'1': 'KB_ARTICLE_STATUS_ARCHIVED', '2': 4},
  ],
};

/// Descriptor for `KBArticleStatus`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List kBArticleStatusDescriptor = $convert.base64Decode(
    'Cg9LQkFydGljbGVTdGF0dXMSIQodS0JfQVJUSUNMRV9TVEFUVVNfVU5TUEVDSUZJRUQQABIbCh'
    'dLQl9BUlRJQ0xFX1NUQVRVU19EUkFGVBABEhwKGEtCX0FSVElDTEVfU1RBVFVTX1JFVklFVxAC'
    'Eh8KG0tCX0FSVElDTEVfU1RBVFVTX1BVQkxJU0hFRBADEh4KGktCX0FSVElDTEVfU1RBVFVTX0'
    'FSQ0hJVkVEEAQ=');

@$core.Deprecated('Use kBArticleTypeDescriptor instead')
const KBArticleType$json = {
  '1': 'KBArticleType',
  '2': [
    {'1': 'KB_ARTICLE_TYPE_UNSPECIFIED', '2': 0},
    {'1': 'KB_ARTICLE_TYPE_GETTING_STARTED', '2': 1},
    {'1': 'KB_ARTICLE_TYPE_HOW_TO', '2': 2},
    {'1': 'KB_ARTICLE_TYPE_FAQ', '2': 3},
    {'1': 'KB_ARTICLE_TYPE_TROUBLESHOOTING', '2': 4},
    {'1': 'KB_ARTICLE_TYPE_API_REFERENCE', '2': 5},
    {'1': 'KB_ARTICLE_TYPE_CHANGELOG', '2': 6},
  ],
};

/// Descriptor for `KBArticleType`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List kBArticleTypeDescriptor = $convert.base64Decode(
    'Cg1LQkFydGljbGVUeXBlEh8KG0tCX0FSVElDTEVfVFlQRV9VTlNQRUNJRklFRBAAEiMKH0tCX0'
    'FSVElDTEVfVFlQRV9HRVRUSU5HX1NUQVJURUQQARIaChZLQl9BUlRJQ0xFX1RZUEVfSE9XX1RP'
    'EAISFwoTS0JfQVJUSUNMRV9UWVBFX0ZBURADEiMKH0tCX0FSVElDTEVfVFlQRV9UUk9VQkxFU0'
    'hPT1RJTkcQBBIhCh1LQl9BUlRJQ0xFX1RZUEVfQVBJX1JFRkVSRU5DRRAFEh0KGUtCX0FSVElD'
    'TEVfVFlQRV9DSEFOR0VMT0cQBg==');

@$core.Deprecated('Use kBCategoryDescriptor instead')
const KBCategory$json = {
  '1': 'KBCategory',
  '2': [
    {
      '1': 'category_id',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.UUID',
      '10': 'categoryId'
    },
    {'1': 'slug', '3': 2, '4': 1, '5': 9, '10': 'slug'},
    {'1': 'display_name', '3': 3, '4': 1, '5': 9, '10': 'displayName'},
    {'1': 'description', '3': 4, '4': 1, '5': 9, '10': 'description'},
    {'1': 'icon_key', '3': 5, '4': 1, '5': 9, '10': 'iconKey'},
    {'1': 'sort_order', '3': 6, '4': 1, '5': 5, '10': 'sortOrder'},
    {'1': 'is_active', '3': 7, '4': 1, '5': 8, '10': 'isActive'},
    {'1': 'article_count', '3': 8, '4': 1, '5': 5, '10': 'articleCount'},
  ],
};

/// Descriptor for `KBCategory`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List kBCategoryDescriptor = $convert.base64Decode(
    'CgpLQkNhdGVnb3J5EjwKC2NhdGVnb3J5X2lkGAEgASgLMhsuY3JlYXRpdmFudGEuY29tbW9uLn'
    'YxLlVVSURSCmNhdGVnb3J5SWQSEgoEc2x1ZxgCIAEoCVIEc2x1ZxIhCgxkaXNwbGF5X25hbWUY'
    'AyABKAlSC2Rpc3BsYXlOYW1lEiAKC2Rlc2NyaXB0aW9uGAQgASgJUgtkZXNjcmlwdGlvbhIZCg'
    'hpY29uX2tleRgFIAEoCVIHaWNvbktleRIdCgpzb3J0X29yZGVyGAYgASgFUglzb3J0T3JkZXIS'
    'GwoJaXNfYWN0aXZlGAcgASgIUghpc0FjdGl2ZRIjCg1hcnRpY2xlX2NvdW50GAggASgFUgxhcn'
    'RpY2xlQ291bnQ=');

@$core.Deprecated('Use kBArticleSummaryDescriptor instead')
const KBArticleSummary$json = {
  '1': 'KBArticleSummary',
  '2': [
    {
      '1': 'article_id',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.UUID',
      '10': 'articleId'
    },
    {
      '1': 'category_id',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.UUID',
      '10': 'categoryId'
    },
    {'1': 'slug', '3': 3, '4': 1, '5': 9, '10': 'slug'},
    {'1': 'locale', '3': 4, '4': 1, '5': 9, '10': 'locale'},
    {'1': 'title', '3': 5, '4': 1, '5': 9, '10': 'title'},
    {'1': 'summary', '3': 6, '4': 1, '5': 9, '10': 'summary'},
    {
      '1': 'status',
      '3': 7,
      '4': 1,
      '5': 14,
      '6': '.creativanta.admin.v1.KBArticleStatus',
      '10': 'status'
    },
    {
      '1': 'article_type',
      '3': 8,
      '4': 1,
      '5': 14,
      '6': '.creativanta.admin.v1.KBArticleType',
      '10': 'articleType'
    },
    {'1': 'target_modules', '3': 9, '4': 3, '5': 9, '10': 'targetModules'},
    {
      '1': 'target_operator_modes',
      '3': 10,
      '4': 3,
      '5': 9,
      '10': 'targetOperatorModes'
    },
    {'1': 'tags', '3': 11, '4': 3, '5': 9, '10': 'tags'},
    {
      '1': 'estimated_read_minutes',
      '3': 12,
      '4': 1,
      '5': 5,
      '10': 'estimatedReadMinutes'
    },
    {'1': 'helpful_votes', '3': 13, '4': 1, '5': 5, '10': 'helpfulVotes'},
    {'1': 'unhelpful_votes', '3': 14, '4': 1, '5': 5, '10': 'unhelpfulVotes'},
    {'1': 'view_count', '3': 15, '4': 1, '5': 5, '10': 'viewCount'},
    {
      '1': 'last_reviewed_at',
      '3': 16,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'lastReviewedAt'
    },
    {
      '1': 'published_at',
      '3': 17,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '9': 0,
      '10': 'publishedAt',
      '17': true
    },
    {
      '1': 'is_stale_for_review',
      '3': 18,
      '4': 1,
      '5': 8,
      '10': 'isStaleForReview'
    },
  ],
  '8': [
    {'1': '_published_at'},
  ],
};

/// Descriptor for `KBArticleSummary`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List kBArticleSummaryDescriptor = $convert.base64Decode(
    'ChBLQkFydGljbGVTdW1tYXJ5EjoKCmFydGljbGVfaWQYASABKAsyGy5jcmVhdGl2YW50YS5jb2'
    '1tb24udjEuVVVJRFIJYXJ0aWNsZUlkEjwKC2NhdGVnb3J5X2lkGAIgASgLMhsuY3JlYXRpdmFu'
    'dGEuY29tbW9uLnYxLlVVSURSCmNhdGVnb3J5SWQSEgoEc2x1ZxgDIAEoCVIEc2x1ZxIWCgZsb2'
    'NhbGUYBCABKAlSBmxvY2FsZRIUCgV0aXRsZRgFIAEoCVIFdGl0bGUSGAoHc3VtbWFyeRgGIAEo'
    'CVIHc3VtbWFyeRI9CgZzdGF0dXMYByABKA4yJS5jcmVhdGl2YW50YS5hZG1pbi52MS5LQkFydG'
    'ljbGVTdGF0dXNSBnN0YXR1cxJGCgxhcnRpY2xlX3R5cGUYCCABKA4yIy5jcmVhdGl2YW50YS5h'
    'ZG1pbi52MS5LQkFydGljbGVUeXBlUgthcnRpY2xlVHlwZRIlCg50YXJnZXRfbW9kdWxlcxgJIA'
    'MoCVINdGFyZ2V0TW9kdWxlcxIyChV0YXJnZXRfb3BlcmF0b3JfbW9kZXMYCiADKAlSE3Rhcmdl'
    'dE9wZXJhdG9yTW9kZXMSEgoEdGFncxgLIAMoCVIEdGFncxI0ChZlc3RpbWF0ZWRfcmVhZF9taW'
    '51dGVzGAwgASgFUhRlc3RpbWF0ZWRSZWFkTWludXRlcxIjCg1oZWxwZnVsX3ZvdGVzGA0gASgF'
    'UgxoZWxwZnVsVm90ZXMSJwoPdW5oZWxwZnVsX3ZvdGVzGA4gASgFUg51bmhlbHBmdWxWb3Rlcx'
    'IdCgp2aWV3X2NvdW50GA8gASgFUgl2aWV3Q291bnQSRAoQbGFzdF9yZXZpZXdlZF9hdBgQIAEo'
    'CzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSDmxhc3RSZXZpZXdlZEF0EkIKDHB1Ymxpc2'
    'hlZF9hdBgRIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBIAFILcHVibGlzaGVkQXSI'
    'AQESLQoTaXNfc3RhbGVfZm9yX3JldmlldxgSIAEoCFIQaXNTdGFsZUZvclJldmlld0IPCg1fcH'
    'VibGlzaGVkX2F0');

@$core.Deprecated('Use kBArticleDetailDescriptor instead')
const KBArticleDetail$json = {
  '1': 'KBArticleDetail',
  '2': [
    {
      '1': 'summary',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.admin.v1.KBArticleSummary',
      '10': 'summary'
    },
    {'1': 'body_markdown', '3': 2, '4': 1, '5': 9, '10': 'bodyMarkdown'},
    {
      '1': 'related_article_ids',
      '3': 3,
      '4': 3,
      '5': 11,
      '6': '.creativanta.common.v1.UUID',
      '10': 'relatedArticleIds'
    },
    {'1': 'target_tiers', '3': 4, '4': 3, '5': 9, '10': 'targetTiers'},
  ],
};

/// Descriptor for `KBArticleDetail`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List kBArticleDetailDescriptor = $convert.base64Decode(
    'Cg9LQkFydGljbGVEZXRhaWwSQAoHc3VtbWFyeRgBIAEoCzImLmNyZWF0aXZhbnRhLmFkbWluLn'
    'YxLktCQXJ0aWNsZVN1bW1hcnlSB3N1bW1hcnkSIwoNYm9keV9tYXJrZG93bhgCIAEoCVIMYm9k'
    'eU1hcmtkb3duEksKE3JlbGF0ZWRfYXJ0aWNsZV9pZHMYAyADKAsyGy5jcmVhdGl2YW50YS5jb2'
    '1tb24udjEuVVVJRFIRcmVsYXRlZEFydGljbGVJZHMSIQoMdGFyZ2V0X3RpZXJzGAQgAygJUgt0'
    'YXJnZXRUaWVycw==');

@$core.Deprecated('Use searchRequestDescriptor instead')
const SearchRequest$json = {
  '1': 'SearchRequest',
  '2': [
    {'1': 'query', '3': 1, '4': 1, '5': 9, '10': 'query'},
    {'1': 'locale', '3': 2, '4': 1, '5': 9, '10': 'locale'},
    {'1': 'module_filter', '3': 3, '4': 1, '5': 9, '10': 'moduleFilter'},
    {
      '1': 'operator_mode_filter',
      '3': 4,
      '4': 1,
      '5': 9,
      '10': 'operatorModeFilter'
    },
    {
      '1': 'category_id',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.UUID',
      '9': 0,
      '10': 'categoryId',
      '17': true
    },
    {
      '1': 'pagination',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.Pagination',
      '10': 'pagination'
    },
  ],
  '8': [
    {'1': '_category_id'},
  ],
};

/// Descriptor for `SearchRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List searchRequestDescriptor = $convert.base64Decode(
    'Cg1TZWFyY2hSZXF1ZXN0EhQKBXF1ZXJ5GAEgASgJUgVxdWVyeRIWCgZsb2NhbGUYAiABKAlSBm'
    'xvY2FsZRIjCg1tb2R1bGVfZmlsdGVyGAMgASgJUgxtb2R1bGVGaWx0ZXISMAoUb3BlcmF0b3Jf'
    'bW9kZV9maWx0ZXIYBCABKAlSEm9wZXJhdG9yTW9kZUZpbHRlchJBCgtjYXRlZ29yeV9pZBgFIA'
    'EoCzIbLmNyZWF0aXZhbnRhLmNvbW1vbi52MS5VVUlESABSCmNhdGVnb3J5SWSIAQESQQoKcGFn'
    'aW5hdGlvbhgGIAEoCzIhLmNyZWF0aXZhbnRhLmNvbW1vbi52MS5QYWdpbmF0aW9uUgpwYWdpbm'
    'F0aW9uQg4KDF9jYXRlZ29yeV9pZA==');

@$core.Deprecated('Use searchResponseDescriptor instead')
const SearchResponse$json = {
  '1': 'SearchResponse',
  '2': [
    {
      '1': 'articles',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.creativanta.admin.v1.KBArticleSummary',
      '10': 'articles'
    },
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

/// Descriptor for `SearchResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List searchResponseDescriptor = $convert.base64Decode(
    'Cg5TZWFyY2hSZXNwb25zZRJCCghhcnRpY2xlcxgBIAMoCzImLmNyZWF0aXZhbnRhLmFkbWluLn'
    'YxLktCQXJ0aWNsZVN1bW1hcnlSCGFydGljbGVzEkgKCnBhZ2luYXRpb24YAiABKAsyKC5jcmVh'
    'dGl2YW50YS5jb21tb24udjEuUGFnaW5hdGVkUmVzcG9uc2VSCnBhZ2luYXRpb24=');

@$core.Deprecated('Use getCategoriesRequestDescriptor instead')
const GetCategoriesRequest$json = {
  '1': 'GetCategoriesRequest',
  '2': [
    {'1': 'locale', '3': 1, '4': 1, '5': 9, '10': 'locale'},
    {'1': 'active_only', '3': 2, '4': 1, '5': 8, '10': 'activeOnly'},
  ],
};

/// Descriptor for `GetCategoriesRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getCategoriesRequestDescriptor = $convert.base64Decode(
    'ChRHZXRDYXRlZ29yaWVzUmVxdWVzdBIWCgZsb2NhbGUYASABKAlSBmxvY2FsZRIfCgthY3Rpdm'
    'Vfb25seRgCIAEoCFIKYWN0aXZlT25seQ==');

@$core.Deprecated('Use getCategoriesResponseDescriptor instead')
const GetCategoriesResponse$json = {
  '1': 'GetCategoriesResponse',
  '2': [
    {
      '1': 'categories',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.creativanta.admin.v1.KBCategory',
      '10': 'categories'
    },
  ],
};

/// Descriptor for `GetCategoriesResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getCategoriesResponseDescriptor = $convert.base64Decode(
    'ChVHZXRDYXRlZ29yaWVzUmVzcG9uc2USQAoKY2F0ZWdvcmllcxgBIAMoCzIgLmNyZWF0aXZhbn'
    'RhLmFkbWluLnYxLktCQ2F0ZWdvcnlSCmNhdGVnb3JpZXM=');

@$core.Deprecated('Use getArticleRequestDescriptor instead')
const GetArticleRequest$json = {
  '1': 'GetArticleRequest',
  '2': [
    {'1': 'slug_or_id', '3': 1, '4': 1, '5': 9, '10': 'slugOrId'},
    {'1': 'locale', '3': 2, '4': 1, '5': 9, '10': 'locale'},
  ],
};

/// Descriptor for `GetArticleRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getArticleRequestDescriptor = $convert.base64Decode(
    'ChFHZXRBcnRpY2xlUmVxdWVzdBIcCgpzbHVnX29yX2lkGAEgASgJUghzbHVnT3JJZBIWCgZsb2'
    'NhbGUYAiABKAlSBmxvY2FsZQ==');

@$core.Deprecated('Use getArticleResponseDescriptor instead')
const GetArticleResponse$json = {
  '1': 'GetArticleResponse',
  '2': [
    {
      '1': 'article',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.admin.v1.KBArticleDetail',
      '10': 'article'
    },
  ],
};

/// Descriptor for `GetArticleResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getArticleResponseDescriptor = $convert.base64Decode(
    'ChJHZXRBcnRpY2xlUmVzcG9uc2USPwoHYXJ0aWNsZRgBIAEoCzIlLmNyZWF0aXZhbnRhLmFkbW'
    'luLnYxLktCQXJ0aWNsZURldGFpbFIHYXJ0aWNsZQ==');

@$core.Deprecated('Use rateArticleRequestDescriptor instead')
const RateArticleRequest$json = {
  '1': 'RateArticleRequest',
  '2': [
    {
      '1': 'article_id',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.UUID',
      '10': 'articleId'
    },
    {
      '1': 'user_id',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.UUID',
      '10': 'userId'
    },
    {'1': 'helpful', '3': 3, '4': 1, '5': 8, '10': 'helpful'},
    {'1': 'feedback_text', '3': 4, '4': 1, '5': 9, '10': 'feedbackText'},
  ],
};

/// Descriptor for `RateArticleRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List rateArticleRequestDescriptor = $convert.base64Decode(
    'ChJSYXRlQXJ0aWNsZVJlcXVlc3QSOgoKYXJ0aWNsZV9pZBgBIAEoCzIbLmNyZWF0aXZhbnRhLm'
    'NvbW1vbi52MS5VVUlEUglhcnRpY2xlSWQSNAoHdXNlcl9pZBgCIAEoCzIbLmNyZWF0aXZhbnRh'
    'LmNvbW1vbi52MS5VVUlEUgZ1c2VySWQSGAoHaGVscGZ1bBgDIAEoCFIHaGVscGZ1bBIjCg1mZW'
    'VkYmFja190ZXh0GAQgASgJUgxmZWVkYmFja1RleHQ=');

@$core.Deprecated('Use rateArticleResponseDescriptor instead')
const RateArticleResponse$json = {
  '1': 'RateArticleResponse',
  '2': [
    {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
    {'1': 'helpful_votes', '3': 2, '4': 1, '5': 5, '10': 'helpfulVotes'},
    {'1': 'unhelpful_votes', '3': 3, '4': 1, '5': 5, '10': 'unhelpfulVotes'},
  ],
};

/// Descriptor for `RateArticleResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List rateArticleResponseDescriptor = $convert.base64Decode(
    'ChNSYXRlQXJ0aWNsZVJlc3BvbnNlEhgKB3N1Y2Nlc3MYASABKAhSB3N1Y2Nlc3MSIwoNaGVscG'
    'Z1bF92b3RlcxgCIAEoBVIMaGVscGZ1bFZvdGVzEicKD3VuaGVscGZ1bF92b3RlcxgDIAEoBVIO'
    'dW5oZWxwZnVsVm90ZXM=');

@$core.Deprecated('Use listRecentRequestDescriptor instead')
const ListRecentRequest$json = {
  '1': 'ListRecentRequest',
  '2': [
    {'1': 'locale', '3': 1, '4': 1, '5': 9, '10': 'locale'},
    {'1': 'module_filter', '3': 2, '4': 1, '5': 9, '10': 'moduleFilter'},
    {'1': 'limit', '3': 3, '4': 1, '5': 5, '10': 'limit'},
  ],
};

/// Descriptor for `ListRecentRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listRecentRequestDescriptor = $convert.base64Decode(
    'ChFMaXN0UmVjZW50UmVxdWVzdBIWCgZsb2NhbGUYASABKAlSBmxvY2FsZRIjCg1tb2R1bGVfZm'
    'lsdGVyGAIgASgJUgxtb2R1bGVGaWx0ZXISFAoFbGltaXQYAyABKAVSBWxpbWl0');

@$core.Deprecated('Use listRecentResponseDescriptor instead')
const ListRecentResponse$json = {
  '1': 'ListRecentResponse',
  '2': [
    {
      '1': 'articles',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.creativanta.admin.v1.KBArticleSummary',
      '10': 'articles'
    },
  ],
};

/// Descriptor for `ListRecentResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listRecentResponseDescriptor = $convert.base64Decode(
    'ChJMaXN0UmVjZW50UmVzcG9uc2USQgoIYXJ0aWNsZXMYASADKAsyJi5jcmVhdGl2YW50YS5hZG'
    '1pbi52MS5LQkFydGljbGVTdW1tYXJ5UghhcnRpY2xlcw==');

@$core.Deprecated('Use listArticlesRequestDescriptor instead')
const ListArticlesRequest$json = {
  '1': 'ListArticlesRequest',
  '2': [
    {
      '1': 'status_filter',
      '3': 1,
      '4': 1,
      '5': 14,
      '6': '.creativanta.admin.v1.KBArticleStatus',
      '10': 'statusFilter'
    },
    {
      '1': 'type_filter',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.creativanta.admin.v1.KBArticleType',
      '10': 'typeFilter'
    },
    {'1': 'module_filter', '3': 3, '4': 1, '5': 9, '10': 'moduleFilter'},
    {'1': 'stale_only', '3': 4, '4': 1, '5': 8, '10': 'staleOnly'},
    {
      '1': 'pagination',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.Pagination',
      '10': 'pagination'
    },
  ],
};

/// Descriptor for `ListArticlesRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listArticlesRequestDescriptor = $convert.base64Decode(
    'ChNMaXN0QXJ0aWNsZXNSZXF1ZXN0EkoKDXN0YXR1c19maWx0ZXIYASABKA4yJS5jcmVhdGl2YW'
    '50YS5hZG1pbi52MS5LQkFydGljbGVTdGF0dXNSDHN0YXR1c0ZpbHRlchJECgt0eXBlX2ZpbHRl'
    'chgCIAEoDjIjLmNyZWF0aXZhbnRhLmFkbWluLnYxLktCQXJ0aWNsZVR5cGVSCnR5cGVGaWx0ZX'
    'ISIwoNbW9kdWxlX2ZpbHRlchgDIAEoCVIMbW9kdWxlRmlsdGVyEh0KCnN0YWxlX29ubHkYBCAB'
    'KAhSCXN0YWxlT25seRJBCgpwYWdpbmF0aW9uGAUgASgLMiEuY3JlYXRpdmFudGEuY29tbW9uLn'
    'YxLlBhZ2luYXRpb25SCnBhZ2luYXRpb24=');

@$core.Deprecated('Use listArticlesResponseDescriptor instead')
const ListArticlesResponse$json = {
  '1': 'ListArticlesResponse',
  '2': [
    {
      '1': 'articles',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.creativanta.admin.v1.KBArticleSummary',
      '10': 'articles'
    },
    {
      '1': 'pagination',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.PaginatedResponse',
      '10': 'pagination'
    },
    {'1': 'total_stale_count', '3': 3, '4': 1, '5': 5, '10': 'totalStaleCount'},
  ],
};

/// Descriptor for `ListArticlesResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listArticlesResponseDescriptor = $convert.base64Decode(
    'ChRMaXN0QXJ0aWNsZXNSZXNwb25zZRJCCghhcnRpY2xlcxgBIAMoCzImLmNyZWF0aXZhbnRhLm'
    'FkbWluLnYxLktCQXJ0aWNsZVN1bW1hcnlSCGFydGljbGVzEkgKCnBhZ2luYXRpb24YAiABKAsy'
    'KC5jcmVhdGl2YW50YS5jb21tb24udjEuUGFnaW5hdGVkUmVzcG9uc2VSCnBhZ2luYXRpb24SKg'
    'oRdG90YWxfc3RhbGVfY291bnQYAyABKAVSD3RvdGFsU3RhbGVDb3VudA==');

@$core.Deprecated('Use kBAdminServiceGetArticleRequestDescriptor instead')
const KBAdminServiceGetArticleRequest$json = {
  '1': 'KBAdminServiceGetArticleRequest',
  '2': [
    {
      '1': 'article_id',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.UUID',
      '10': 'articleId'
    },
  ],
};

/// Descriptor for `KBAdminServiceGetArticleRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List kBAdminServiceGetArticleRequestDescriptor =
    $convert.base64Decode(
        'Ch9LQkFkbWluU2VydmljZUdldEFydGljbGVSZXF1ZXN0EjoKCmFydGljbGVfaWQYASABKAsyGy'
        '5jcmVhdGl2YW50YS5jb21tb24udjEuVVVJRFIJYXJ0aWNsZUlk');

@$core.Deprecated('Use kBAdminServiceGetArticleResponseDescriptor instead')
const KBAdminServiceGetArticleResponse$json = {
  '1': 'KBAdminServiceGetArticleResponse',
  '2': [
    {
      '1': 'article',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.admin.v1.KBArticleDetail',
      '10': 'article'
    },
  ],
};

/// Descriptor for `KBAdminServiceGetArticleResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List kBAdminServiceGetArticleResponseDescriptor =
    $convert.base64Decode(
        'CiBLQkFkbWluU2VydmljZUdldEFydGljbGVSZXNwb25zZRI/CgdhcnRpY2xlGAEgASgLMiUuY3'
        'JlYXRpdmFudGEuYWRtaW4udjEuS0JBcnRpY2xlRGV0YWlsUgdhcnRpY2xl');

@$core.Deprecated('Use createArticleRequestDescriptor instead')
const CreateArticleRequest$json = {
  '1': 'CreateArticleRequest',
  '2': [
    {
      '1': 'category_id',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.UUID',
      '10': 'categoryId'
    },
    {'1': 'slug', '3': 2, '4': 1, '5': 9, '10': 'slug'},
    {'1': 'locale', '3': 3, '4': 1, '5': 9, '10': 'locale'},
    {'1': 'title', '3': 4, '4': 1, '5': 9, '10': 'title'},
    {'1': 'summary', '3': 5, '4': 1, '5': 9, '10': 'summary'},
    {'1': 'body_markdown', '3': 6, '4': 1, '5': 9, '10': 'bodyMarkdown'},
    {
      '1': 'article_type',
      '3': 7,
      '4': 1,
      '5': 14,
      '6': '.creativanta.admin.v1.KBArticleType',
      '10': 'articleType'
    },
    {'1': 'target_modules', '3': 8, '4': 3, '5': 9, '10': 'targetModules'},
    {
      '1': 'target_operator_modes',
      '3': 9,
      '4': 3,
      '5': 9,
      '10': 'targetOperatorModes'
    },
    {'1': 'tags', '3': 10, '4': 3, '5': 9, '10': 'tags'},
    {
      '1': 'estimated_read_minutes',
      '3': 11,
      '4': 1,
      '5': 5,
      '10': 'estimatedReadMinutes'
    },
  ],
};

/// Descriptor for `CreateArticleRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createArticleRequestDescriptor = $convert.base64Decode(
    'ChRDcmVhdGVBcnRpY2xlUmVxdWVzdBI8CgtjYXRlZ29yeV9pZBgBIAEoCzIbLmNyZWF0aXZhbn'
    'RhLmNvbW1vbi52MS5VVUlEUgpjYXRlZ29yeUlkEhIKBHNsdWcYAiABKAlSBHNsdWcSFgoGbG9j'
    'YWxlGAMgASgJUgZsb2NhbGUSFAoFdGl0bGUYBCABKAlSBXRpdGxlEhgKB3N1bW1hcnkYBSABKA'
    'lSB3N1bW1hcnkSIwoNYm9keV9tYXJrZG93bhgGIAEoCVIMYm9keU1hcmtkb3duEkYKDGFydGlj'
    'bGVfdHlwZRgHIAEoDjIjLmNyZWF0aXZhbnRhLmFkbWluLnYxLktCQXJ0aWNsZVR5cGVSC2FydG'
    'ljbGVUeXBlEiUKDnRhcmdldF9tb2R1bGVzGAggAygJUg10YXJnZXRNb2R1bGVzEjIKFXRhcmdl'
    'dF9vcGVyYXRvcl9tb2RlcxgJIAMoCVITdGFyZ2V0T3BlcmF0b3JNb2RlcxISCgR0YWdzGAogAy'
    'gJUgR0YWdzEjQKFmVzdGltYXRlZF9yZWFkX21pbnV0ZXMYCyABKAVSFGVzdGltYXRlZFJlYWRN'
    'aW51dGVz');

@$core.Deprecated('Use createArticleResponseDescriptor instead')
const CreateArticleResponse$json = {
  '1': 'CreateArticleResponse',
  '2': [
    {
      '1': 'article',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.admin.v1.KBArticleDetail',
      '10': 'article'
    },
  ],
};

/// Descriptor for `CreateArticleResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createArticleResponseDescriptor = $convert.base64Decode(
    'ChVDcmVhdGVBcnRpY2xlUmVzcG9uc2USPwoHYXJ0aWNsZRgBIAEoCzIlLmNyZWF0aXZhbnRhLm'
    'FkbWluLnYxLktCQXJ0aWNsZURldGFpbFIHYXJ0aWNsZQ==');

@$core.Deprecated('Use updateArticleRequestDescriptor instead')
const UpdateArticleRequest$json = {
  '1': 'UpdateArticleRequest',
  '2': [
    {
      '1': 'article_id',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.UUID',
      '10': 'articleId'
    },
    {'1': 'title', '3': 2, '4': 1, '5': 9, '10': 'title'},
    {'1': 'summary', '3': 3, '4': 1, '5': 9, '10': 'summary'},
    {'1': 'body_markdown', '3': 4, '4': 1, '5': 9, '10': 'bodyMarkdown'},
    {
      '1': 'article_type',
      '3': 5,
      '4': 1,
      '5': 14,
      '6': '.creativanta.admin.v1.KBArticleType',
      '10': 'articleType'
    },
    {'1': 'target_modules', '3': 6, '4': 3, '5': 9, '10': 'targetModules'},
    {
      '1': 'target_operator_modes',
      '3': 7,
      '4': 3,
      '5': 9,
      '10': 'targetOperatorModes'
    },
    {'1': 'tags', '3': 8, '4': 3, '5': 9, '10': 'tags'},
    {
      '1': 'estimated_read_minutes',
      '3': 9,
      '4': 1,
      '5': 5,
      '10': 'estimatedReadMinutes'
    },
    {'1': 'change_note', '3': 10, '4': 1, '5': 9, '10': 'changeNote'},
  ],
};

/// Descriptor for `UpdateArticleRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateArticleRequestDescriptor = $convert.base64Decode(
    'ChRVcGRhdGVBcnRpY2xlUmVxdWVzdBI6CgphcnRpY2xlX2lkGAEgASgLMhsuY3JlYXRpdmFudG'
    'EuY29tbW9uLnYxLlVVSURSCWFydGljbGVJZBIUCgV0aXRsZRgCIAEoCVIFdGl0bGUSGAoHc3Vt'
    'bWFyeRgDIAEoCVIHc3VtbWFyeRIjCg1ib2R5X21hcmtkb3duGAQgASgJUgxib2R5TWFya2Rvd2'
    '4SRgoMYXJ0aWNsZV90eXBlGAUgASgOMiMuY3JlYXRpdmFudGEuYWRtaW4udjEuS0JBcnRpY2xl'
    'VHlwZVILYXJ0aWNsZVR5cGUSJQoOdGFyZ2V0X21vZHVsZXMYBiADKAlSDXRhcmdldE1vZHVsZX'
    'MSMgoVdGFyZ2V0X29wZXJhdG9yX21vZGVzGAcgAygJUhN0YXJnZXRPcGVyYXRvck1vZGVzEhIK'
    'BHRhZ3MYCCADKAlSBHRhZ3MSNAoWZXN0aW1hdGVkX3JlYWRfbWludXRlcxgJIAEoBVIUZXN0aW'
    '1hdGVkUmVhZE1pbnV0ZXMSHwoLY2hhbmdlX25vdGUYCiABKAlSCmNoYW5nZU5vdGU=');

@$core.Deprecated('Use updateArticleResponseDescriptor instead')
const UpdateArticleResponse$json = {
  '1': 'UpdateArticleResponse',
  '2': [
    {
      '1': 'article',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.admin.v1.KBArticleDetail',
      '10': 'article'
    },
  ],
};

/// Descriptor for `UpdateArticleResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateArticleResponseDescriptor = $convert.base64Decode(
    'ChVVcGRhdGVBcnRpY2xlUmVzcG9uc2USPwoHYXJ0aWNsZRgBIAEoCzIlLmNyZWF0aXZhbnRhLm'
    'FkbWluLnYxLktCQXJ0aWNsZURldGFpbFIHYXJ0aWNsZQ==');

@$core.Deprecated('Use publishArticleRequestDescriptor instead')
const PublishArticleRequest$json = {
  '1': 'PublishArticleRequest',
  '2': [
    {
      '1': 'article_id',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.UUID',
      '10': 'articleId'
    },
  ],
};

/// Descriptor for `PublishArticleRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List publishArticleRequestDescriptor = $convert.base64Decode(
    'ChVQdWJsaXNoQXJ0aWNsZVJlcXVlc3QSOgoKYXJ0aWNsZV9pZBgBIAEoCzIbLmNyZWF0aXZhbn'
    'RhLmNvbW1vbi52MS5VVUlEUglhcnRpY2xlSWQ=');

@$core.Deprecated('Use publishArticleResponseDescriptor instead')
const PublishArticleResponse$json = {
  '1': 'PublishArticleResponse',
  '2': [
    {
      '1': 'article',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.admin.v1.KBArticleDetail',
      '10': 'article'
    },
  ],
};

/// Descriptor for `PublishArticleResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List publishArticleResponseDescriptor =
    $convert.base64Decode(
        'ChZQdWJsaXNoQXJ0aWNsZVJlc3BvbnNlEj8KB2FydGljbGUYASABKAsyJS5jcmVhdGl2YW50YS'
        '5hZG1pbi52MS5LQkFydGljbGVEZXRhaWxSB2FydGljbGU=');

@$core.Deprecated('Use archiveArticleRequestDescriptor instead')
const ArchiveArticleRequest$json = {
  '1': 'ArchiveArticleRequest',
  '2': [
    {
      '1': 'article_id',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.UUID',
      '10': 'articleId'
    },
    {'1': 'reason', '3': 2, '4': 1, '5': 9, '10': 'reason'},
  ],
};

/// Descriptor for `ArchiveArticleRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List archiveArticleRequestDescriptor = $convert.base64Decode(
    'ChVBcmNoaXZlQXJ0aWNsZVJlcXVlc3QSOgoKYXJ0aWNsZV9pZBgBIAEoCzIbLmNyZWF0aXZhbn'
    'RhLmNvbW1vbi52MS5VVUlEUglhcnRpY2xlSWQSFgoGcmVhc29uGAIgASgJUgZyZWFzb24=');

@$core.Deprecated('Use archiveArticleResponseDescriptor instead')
const ArchiveArticleResponse$json = {
  '1': 'ArchiveArticleResponse',
  '2': [
    {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
  ],
};

/// Descriptor for `ArchiveArticleResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List archiveArticleResponseDescriptor =
    $convert.base64Decode(
        'ChZBcmNoaXZlQXJ0aWNsZVJlc3BvbnNlEhgKB3N1Y2Nlc3MYASABKAhSB3N1Y2Nlc3M=');

@$core.Deprecated('Use listStaleArticlesRequestDescriptor instead')
const ListStaleArticlesRequest$json = {
  '1': 'ListStaleArticlesRequest',
  '2': [
    {'1': 'days_threshold', '3': 1, '4': 1, '5': 5, '10': 'daysThreshold'},
    {
      '1': 'pagination',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.Pagination',
      '10': 'pagination'
    },
  ],
};

/// Descriptor for `ListStaleArticlesRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listStaleArticlesRequestDescriptor = $convert.base64Decode(
    'ChhMaXN0U3RhbGVBcnRpY2xlc1JlcXVlc3QSJQoOZGF5c190aHJlc2hvbGQYASABKAVSDWRheX'
    'NUaHJlc2hvbGQSQQoKcGFnaW5hdGlvbhgCIAEoCzIhLmNyZWF0aXZhbnRhLmNvbW1vbi52MS5Q'
    'YWdpbmF0aW9uUgpwYWdpbmF0aW9u');

@$core.Deprecated('Use listStaleArticlesResponseDescriptor instead')
const ListStaleArticlesResponse$json = {
  '1': 'ListStaleArticlesResponse',
  '2': [
    {
      '1': 'stale_articles',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.creativanta.admin.v1.KBArticleSummary',
      '10': 'staleArticles'
    },
    {
      '1': 'pagination',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.PaginatedResponse',
      '10': 'pagination'
    },
    {'1': 'stale_count', '3': 3, '4': 1, '5': 5, '10': 'staleCount'},
  ],
};

/// Descriptor for `ListStaleArticlesResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listStaleArticlesResponseDescriptor = $convert.base64Decode(
    'ChlMaXN0U3RhbGVBcnRpY2xlc1Jlc3BvbnNlEk0KDnN0YWxlX2FydGljbGVzGAEgAygLMiYuY3'
    'JlYXRpdmFudGEuYWRtaW4udjEuS0JBcnRpY2xlU3VtbWFyeVINc3RhbGVBcnRpY2xlcxJICgpw'
    'YWdpbmF0aW9uGAIgASgLMiguY3JlYXRpdmFudGEuY29tbW9uLnYxLlBhZ2luYXRlZFJlc3Bvbn'
    'NlUgpwYWdpbmF0aW9uEh8KC3N0YWxlX2NvdW50GAMgASgFUgpzdGFsZUNvdW50');

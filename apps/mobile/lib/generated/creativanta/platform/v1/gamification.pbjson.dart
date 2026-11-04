// This is a generated file - do not edit.
//
// Generated from creativanta/platform/v1/gamification.proto.

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

@$core.Deprecated('Use challengeStatusDescriptor instead')
const ChallengeStatus$json = {
  '1': 'ChallengeStatus',
  '2': [
    {'1': 'CHALLENGE_STATUS_UNSPECIFIED', '2': 0},
    {'1': 'CHALLENGE_STATUS_DRAFT', '2': 1},
    {'1': 'CHALLENGE_STATUS_ENROLLING', '2': 2},
    {'1': 'CHALLENGE_STATUS_ACTIVE', '2': 3},
    {'1': 'CHALLENGE_STATUS_COMPLETED', '2': 4},
    {'1': 'CHALLENGE_STATUS_REWARDED', '2': 5},
    {'1': 'CHALLENGE_STATUS_CANCELLED', '2': 6},
  ],
};

/// Descriptor for `ChallengeStatus`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List challengeStatusDescriptor = $convert.base64Decode(
    'Cg9DaGFsbGVuZ2VTdGF0dXMSIAocQ0hBTExFTkdFX1NUQVRVU19VTlNQRUNJRklFRBAAEhoKFk'
    'NIQUxMRU5HRV9TVEFUVVNfRFJBRlQQARIeChpDSEFMTEVOR0VfU1RBVFVTX0VOUk9MTElORxAC'
    'EhsKF0NIQUxMRU5HRV9TVEFUVVNfQUNUSVZFEAMSHgoaQ0hBTExFTkdFX1NUQVRVU19DT01QTE'
    'VURUQQBBIdChlDSEFMTEVOR0VfU1RBVFVTX1JFV0FSREVEEAUSHgoaQ0hBTExFTkdFX1NUQVRV'
    'U19DQU5DRUxMRUQQBg==');

@$core.Deprecated('Use challengeTypeDescriptor instead')
const ChallengeType$json = {
  '1': 'ChallengeType',
  '2': [
    {'1': 'CHALLENGE_TYPE_UNSPECIFIED', '2': 0},
    {'1': 'CHALLENGE_TYPE_PUBLISH_COUNT', '2': 1},
    {'1': 'CHALLENGE_TYPE_REVENUE_TARGET', '2': 2},
    {'1': 'CHALLENGE_TYPE_ENGAGEMENT_TARGET', '2': 3},
    {'1': 'CHALLENGE_TYPE_STREAK', '2': 4},
    {'1': 'CHALLENGE_TYPE_CUSTOM', '2': 5},
  ],
};

/// Descriptor for `ChallengeType`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List challengeTypeDescriptor = $convert.base64Decode(
    'Cg1DaGFsbGVuZ2VUeXBlEh4KGkNIQUxMRU5HRV9UWVBFX1VOU1BFQ0lGSUVEEAASIAocQ0hBTE'
    'xFTkdFX1RZUEVfUFVCTElTSF9DT1VOVBABEiEKHUNIQUxMRU5HRV9UWVBFX1JFVkVOVUVfVEFS'
    'R0VUEAISJAogQ0hBTExFTkdFX1RZUEVfRU5HQUdFTUVOVF9UQVJHRVQQAxIZChVDSEFMTEVOR0'
    'VfVFlQRV9TVFJFQUsQBBIZChVDSEFMTEVOR0VfVFlQRV9DVVNUT00QBQ==');

@$core.Deprecated('Use creatorProgressDescriptor instead')
const CreatorProgress$json = {
  '1': 'CreatorProgress',
  '2': [
    {'1': 'progress_id', '3': 1, '4': 1, '5': 9, '10': 'progressId'},
    {
      '1': 'workspace_id',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.UUID',
      '10': 'workspaceId'
    },
    {'1': 'user_id', '3': 3, '4': 1, '5': 9, '10': 'userId'},
    {'1': 'level', '3': 4, '4': 1, '5': 5, '10': 'level'},
    {'1': 'xp', '3': 5, '4': 1, '5': 5, '10': 'xp'},
    {'1': 'xp_to_next_level', '3': 6, '4': 1, '5': 5, '10': 'xpToNextLevel'},
    {'1': 'streak_days', '3': 7, '4': 1, '5': 5, '10': 'streakDays'},
    {
      '1': 'streak_last_activity_date',
      '3': 8,
      '4': 1,
      '5': 9,
      '10': 'streakLastActivityDate'
    },
    {'1': 'creator_score', '3': 9, '4': 1, '5': 2, '10': 'creatorScore'},
    {
      '1': 'total_achievements',
      '3': 10,
      '4': 1,
      '5': 5,
      '10': 'totalAchievements'
    },
    {'1': 'season_id', '3': 11, '4': 1, '5': 9, '10': 'seasonId'},
    {
      '1': 'created_at',
      '3': 12,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'createdAt'
    },
    {
      '1': 'updated_at',
      '3': 13,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'updatedAt'
    },
  ],
};

/// Descriptor for `CreatorProgress`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List creatorProgressDescriptor = $convert.base64Decode(
    'Cg9DcmVhdG9yUHJvZ3Jlc3MSHwoLcHJvZ3Jlc3NfaWQYASABKAlSCnByb2dyZXNzSWQSPgoMd2'
    '9ya3NwYWNlX2lkGAIgASgLMhsuY3JlYXRpdmFudGEuY29tbW9uLnYxLlVVSURSC3dvcmtzcGFj'
    'ZUlkEhcKB3VzZXJfaWQYAyABKAlSBnVzZXJJZBIUCgVsZXZlbBgEIAEoBVIFbGV2ZWwSDgoCeH'
    'AYBSABKAVSAnhwEicKEHhwX3RvX25leHRfbGV2ZWwYBiABKAVSDXhwVG9OZXh0TGV2ZWwSHwoL'
    'c3RyZWFrX2RheXMYByABKAVSCnN0cmVha0RheXMSOQoZc3RyZWFrX2xhc3RfYWN0aXZpdHlfZG'
    'F0ZRgIIAEoCVIWc3RyZWFrTGFzdEFjdGl2aXR5RGF0ZRIjCg1jcmVhdG9yX3Njb3JlGAkgASgC'
    'UgxjcmVhdG9yU2NvcmUSLQoSdG90YWxfYWNoaWV2ZW1lbnRzGAogASgFUhF0b3RhbEFjaGlldm'
    'VtZW50cxIbCglzZWFzb25faWQYCyABKAlSCHNlYXNvbklkEjkKCmNyZWF0ZWRfYXQYDCABKAsy'
    'Gi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUgljcmVhdGVkQXQSOQoKdXBkYXRlZF9hdBgNIA'
    'EoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSCXVwZGF0ZWRBdA==');

@$core.Deprecated('Use achievementDefinitionDescriptor instead')
const AchievementDefinition$json = {
  '1': 'AchievementDefinition',
  '2': [
    {'1': 'achievement_id', '3': 1, '4': 1, '5': 9, '10': 'achievementId'},
    {'1': 'code', '3': 2, '4': 1, '5': 9, '10': 'code'},
    {'1': 'title', '3': 3, '4': 1, '5': 9, '10': 'title'},
    {'1': 'description', '3': 4, '4': 1, '5': 9, '10': 'description'},
    {
      '1': 'trigger_condition_json',
      '3': 5,
      '4': 1,
      '5': 9,
      '10': 'triggerConditionJson'
    },
    {'1': 'reward_credits', '3': 6, '4': 1, '5': 5, '10': 'rewardCredits'},
    {'1': 'badge_image_url', '3': 7, '4': 1, '5': 9, '10': 'badgeImageUrl'},
    {'1': 'category', '3': 8, '4': 1, '5': 9, '10': 'category'},
    {'1': 'sort_order', '3': 9, '4': 1, '5': 5, '10': 'sortOrder'},
    {'1': 'active', '3': 10, '4': 1, '5': 8, '10': 'active'},
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

/// Descriptor for `AchievementDefinition`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List achievementDefinitionDescriptor = $convert.base64Decode(
    'ChVBY2hpZXZlbWVudERlZmluaXRpb24SJQoOYWNoaWV2ZW1lbnRfaWQYASABKAlSDWFjaGlldm'
    'VtZW50SWQSEgoEY29kZRgCIAEoCVIEY29kZRIUCgV0aXRsZRgDIAEoCVIFdGl0bGUSIAoLZGVz'
    'Y3JpcHRpb24YBCABKAlSC2Rlc2NyaXB0aW9uEjQKFnRyaWdnZXJfY29uZGl0aW9uX2pzb24YBS'
    'ABKAlSFHRyaWdnZXJDb25kaXRpb25Kc29uEiUKDnJld2FyZF9jcmVkaXRzGAYgASgFUg1yZXdh'
    'cmRDcmVkaXRzEiYKD2JhZGdlX2ltYWdlX3VybBgHIAEoCVINYmFkZ2VJbWFnZVVybBIaCghjYX'
    'RlZ29yeRgIIAEoCVIIY2F0ZWdvcnkSHQoKc29ydF9vcmRlchgJIAEoBVIJc29ydE9yZGVyEhYK'
    'BmFjdGl2ZRgKIAEoCFIGYWN0aXZlEjkKCmNyZWF0ZWRfYXQYCyABKAsyGi5nb29nbGUucHJvdG'
    '9idWYuVGltZXN0YW1wUgljcmVhdGVkQXQSOQoKdXBkYXRlZF9hdBgMIAEoCzIaLmdvb2dsZS5w'
    'cm90b2J1Zi5UaW1lc3RhbXBSCXVwZGF0ZWRBdA==');

@$core.Deprecated('Use achievementRecordDescriptor instead')
const AchievementRecord$json = {
  '1': 'AchievementRecord',
  '2': [
    {'1': 'record_id', '3': 1, '4': 1, '5': 9, '10': 'recordId'},
    {
      '1': 'workspace_id',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.UUID',
      '10': 'workspaceId'
    },
    {'1': 'user_id', '3': 3, '4': 1, '5': 9, '10': 'userId'},
    {'1': 'achievement_id', '3': 4, '4': 1, '5': 9, '10': 'achievementId'},
    {'1': 'achievement_code', '3': 5, '4': 1, '5': 9, '10': 'achievementCode'},
    {
      '1': 'earned_at',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'earnedAt'
    },
    {'1': 'credits_awarded', '3': 7, '4': 1, '5': 9, '10': 'creditsAwarded'},
  ],
};

/// Descriptor for `AchievementRecord`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List achievementRecordDescriptor = $convert.base64Decode(
    'ChFBY2hpZXZlbWVudFJlY29yZBIbCglyZWNvcmRfaWQYASABKAlSCHJlY29yZElkEj4KDHdvcm'
    'tzcGFjZV9pZBgCIAEoCzIbLmNyZWF0aXZhbnRhLmNvbW1vbi52MS5VVUlEUgt3b3Jrc3BhY2VJ'
    'ZBIXCgd1c2VyX2lkGAMgASgJUgZ1c2VySWQSJQoOYWNoaWV2ZW1lbnRfaWQYBCABKAlSDWFjaG'
    'lldmVtZW50SWQSKQoQYWNoaWV2ZW1lbnRfY29kZRgFIAEoCVIPYWNoaWV2ZW1lbnRDb2RlEjcK'
    'CWVhcm5lZF9hdBgGIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSCGVhcm5lZEF0Ei'
    'cKD2NyZWRpdHNfYXdhcmRlZBgHIAEoCVIOY3JlZGl0c0F3YXJkZWQ=');

@$core.Deprecated('Use achievementItemDescriptor instead')
const AchievementItem$json = {
  '1': 'AchievementItem',
  '2': [
    {
      '1': 'definition',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.platform.v1.AchievementDefinition',
      '10': 'definition'
    },
    {'1': 'unlocked', '3': 2, '4': 1, '5': 8, '10': 'unlocked'},
    {
      '1': 'earned_at',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'earnedAt'
    },
    {'1': 'credits_awarded', '3': 4, '4': 1, '5': 9, '10': 'creditsAwarded'},
    {'1': 'current_progress', '3': 5, '4': 1, '5': 5, '10': 'currentProgress'},
    {'1': 'target_progress', '3': 6, '4': 1, '5': 5, '10': 'targetProgress'},
  ],
};

/// Descriptor for `AchievementItem`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List achievementItemDescriptor = $convert.base64Decode(
    'Cg9BY2hpZXZlbWVudEl0ZW0STgoKZGVmaW5pdGlvbhgBIAEoCzIuLmNyZWF0aXZhbnRhLnBsYX'
    'Rmb3JtLnYxLkFjaGlldmVtZW50RGVmaW5pdGlvblIKZGVmaW5pdGlvbhIaCgh1bmxvY2tlZBgC'
    'IAEoCFIIdW5sb2NrZWQSNwoJZWFybmVkX2F0GAMgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbW'
    'VzdGFtcFIIZWFybmVkQXQSJwoPY3JlZGl0c19hd2FyZGVkGAQgASgJUg5jcmVkaXRzQXdhcmRl'
    'ZBIpChBjdXJyZW50X3Byb2dyZXNzGAUgASgFUg9jdXJyZW50UHJvZ3Jlc3MSJwoPdGFyZ2V0X3'
    'Byb2dyZXNzGAYgASgFUg50YXJnZXRQcm9ncmVzcw==');

@$core.Deprecated('Use challengeDefinitionDescriptor instead')
const ChallengeDefinition$json = {
  '1': 'ChallengeDefinition',
  '2': [
    {'1': 'challenge_id', '3': 1, '4': 1, '5': 9, '10': 'challengeId'},
    {'1': 'title', '3': 2, '4': 1, '5': 9, '10': 'title'},
    {'1': 'description', '3': 3, '4': 1, '5': 9, '10': 'description'},
    {
      '1': 'challenge_type',
      '3': 4,
      '4': 1,
      '5': 14,
      '6': '.creativanta.platform.v1.ChallengeType',
      '10': 'challengeType'
    },
    {'1': 'target_value', '3': 5, '4': 1, '5': 5, '10': 'targetValue'},
    {'1': 'reward_credits', '3': 6, '4': 1, '5': 5, '10': 'rewardCredits'},
    {'1': 'start_date', '3': 7, '4': 1, '5': 9, '10': 'startDate'},
    {'1': 'end_date', '3': 8, '4': 1, '5': 9, '10': 'endDate'},
    {
      '1': 'status',
      '3': 9,
      '4': 1,
      '5': 14,
      '6': '.creativanta.platform.v1.ChallengeStatus',
      '10': 'status'
    },
    {'1': 'is_active', '3': 10, '4': 1, '5': 8, '10': 'isActive'},
    {'1': 'sort_order', '3': 11, '4': 1, '5': 5, '10': 'sortOrder'},
    {
      '1': 'created_at',
      '3': 12,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'createdAt'
    },
  ],
};

/// Descriptor for `ChallengeDefinition`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List challengeDefinitionDescriptor = $convert.base64Decode(
    'ChNDaGFsbGVuZ2VEZWZpbml0aW9uEiEKDGNoYWxsZW5nZV9pZBgBIAEoCVILY2hhbGxlbmdlSW'
    'QSFAoFdGl0bGUYAiABKAlSBXRpdGxlEiAKC2Rlc2NyaXB0aW9uGAMgASgJUgtkZXNjcmlwdGlv'
    'bhJNCg5jaGFsbGVuZ2VfdHlwZRgEIAEoDjImLmNyZWF0aXZhbnRhLnBsYXRmb3JtLnYxLkNoYW'
    'xsZW5nZVR5cGVSDWNoYWxsZW5nZVR5cGUSIQoMdGFyZ2V0X3ZhbHVlGAUgASgFUgt0YXJnZXRW'
    'YWx1ZRIlCg5yZXdhcmRfY3JlZGl0cxgGIAEoBVINcmV3YXJkQ3JlZGl0cxIdCgpzdGFydF9kYX'
    'RlGAcgASgJUglzdGFydERhdGUSGQoIZW5kX2RhdGUYCCABKAlSB2VuZERhdGUSQAoGc3RhdHVz'
    'GAkgASgOMiguY3JlYXRpdmFudGEucGxhdGZvcm0udjEuQ2hhbGxlbmdlU3RhdHVzUgZzdGF0dX'
    'MSGwoJaXNfYWN0aXZlGAogASgIUghpc0FjdGl2ZRIdCgpzb3J0X29yZGVyGAsgASgFUglzb3J0'
    'T3JkZXISOQoKY3JlYXRlZF9hdBgMIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSCW'
    'NyZWF0ZWRBdA==');

@$core.Deprecated('Use challengeProgressDescriptor instead')
const ChallengeProgress$json = {
  '1': 'ChallengeProgress',
  '2': [
    {'1': 'progress_id', '3': 1, '4': 1, '5': 9, '10': 'progressId'},
    {
      '1': 'workspace_id',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.UUID',
      '10': 'workspaceId'
    },
    {'1': 'user_id', '3': 3, '4': 1, '5': 9, '10': 'userId'},
    {'1': 'challenge_id', '3': 4, '4': 1, '5': 9, '10': 'challengeId'},
    {'1': 'current_value', '3': 5, '4': 1, '5': 5, '10': 'currentValue'},
    {'1': 'target_value', '3': 6, '4': 1, '5': 5, '10': 'targetValue'},
    {'1': 'completed', '3': 7, '4': 1, '5': 8, '10': 'completed'},
    {
      '1': 'completed_at',
      '3': 8,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'completedAt'
    },
    {'1': 'reward_credited', '3': 9, '4': 1, '5': 8, '10': 'rewardCredited'},
    {
      '1': 'reward_transaction_id',
      '3': 10,
      '4': 1,
      '5': 9,
      '10': 'rewardTransactionId'
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

/// Descriptor for `ChallengeProgress`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List challengeProgressDescriptor = $convert.base64Decode(
    'ChFDaGFsbGVuZ2VQcm9ncmVzcxIfCgtwcm9ncmVzc19pZBgBIAEoCVIKcHJvZ3Jlc3NJZBI+Cg'
    'x3b3Jrc3BhY2VfaWQYAiABKAsyGy5jcmVhdGl2YW50YS5jb21tb24udjEuVVVJRFILd29ya3Nw'
    'YWNlSWQSFwoHdXNlcl9pZBgDIAEoCVIGdXNlcklkEiEKDGNoYWxsZW5nZV9pZBgEIAEoCVILY2'
    'hhbGxlbmdlSWQSIwoNY3VycmVudF92YWx1ZRgFIAEoBVIMY3VycmVudFZhbHVlEiEKDHRhcmdl'
    'dF92YWx1ZRgGIAEoBVILdGFyZ2V0VmFsdWUSHAoJY29tcGxldGVkGAcgASgIUgljb21wbGV0ZW'
    'QSPQoMY29tcGxldGVkX2F0GAggASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFILY29t'
    'cGxldGVkQXQSJwoPcmV3YXJkX2NyZWRpdGVkGAkgASgIUg5yZXdhcmRDcmVkaXRlZBIyChVyZX'
    'dhcmRfdHJhbnNhY3Rpb25faWQYCiABKAlSE3Jld2FyZFRyYW5zYWN0aW9uSWQSOQoKY3JlYXRl'
    'ZF9hdBgLIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSCWNyZWF0ZWRBdBI5Cgp1cG'
    'RhdGVkX2F0GAwgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIJdXBkYXRlZEF0');

@$core.Deprecated('Use challengeItemDescriptor instead')
const ChallengeItem$json = {
  '1': 'ChallengeItem',
  '2': [
    {
      '1': 'challenge',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.platform.v1.ChallengeDefinition',
      '10': 'challenge'
    },
    {
      '1': 'progress',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.creativanta.platform.v1.ChallengeProgress',
      '10': 'progress'
    },
    {'1': 'enrolled', '3': 3, '4': 1, '5': 8, '10': 'enrolled'},
  ],
};

/// Descriptor for `ChallengeItem`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List challengeItemDescriptor = $convert.base64Decode(
    'Cg1DaGFsbGVuZ2VJdGVtEkoKCWNoYWxsZW5nZRgBIAEoCzIsLmNyZWF0aXZhbnRhLnBsYXRmb3'
    'JtLnYxLkNoYWxsZW5nZURlZmluaXRpb25SCWNoYWxsZW5nZRJGCghwcm9ncmVzcxgCIAEoCzIq'
    'LmNyZWF0aXZhbnRhLnBsYXRmb3JtLnYxLkNoYWxsZW5nZVByb2dyZXNzUghwcm9ncmVzcxIaCg'
    'hlbnJvbGxlZBgDIAEoCFIIZW5yb2xsZWQ=');

@$core.Deprecated('Use leaderboardEntryDescriptor instead')
const LeaderboardEntry$json = {
  '1': 'LeaderboardEntry',
  '2': [
    {'1': 'rank', '3': 1, '4': 1, '5': 5, '10': 'rank'},
    {'1': 'user_id', '3': 2, '4': 1, '5': 9, '10': 'userId'},
    {'1': 'user_name', '3': 3, '4': 1, '5': 9, '10': 'userName'},
    {'1': 'avatar_url', '3': 4, '4': 1, '5': 9, '10': 'avatarUrl'},
    {'1': 'score', '3': 5, '4': 1, '5': 5, '10': 'score'},
    {'1': 'level', '3': 6, '4': 1, '5': 5, '10': 'level'},
    {'1': 'streak_days', '3': 7, '4': 1, '5': 5, '10': 'streakDays'},
  ],
};

/// Descriptor for `LeaderboardEntry`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List leaderboardEntryDescriptor = $convert.base64Decode(
    'ChBMZWFkZXJib2FyZEVudHJ5EhIKBHJhbmsYASABKAVSBHJhbmsSFwoHdXNlcl9pZBgCIAEoCV'
    'IGdXNlcklkEhsKCXVzZXJfbmFtZRgDIAEoCVIIdXNlck5hbWUSHQoKYXZhdGFyX3VybBgEIAEo'
    'CVIJYXZhdGFyVXJsEhQKBXNjb3JlGAUgASgFUgVzY29yZRIUCgVsZXZlbBgGIAEoBVIFbGV2ZW'
    'wSHwoLc3RyZWFrX2RheXMYByABKAVSCnN0cmVha0RheXM=');

@$core.Deprecated('Use getProgressRequestDescriptor instead')
const GetProgressRequest$json = {
  '1': 'GetProgressRequest',
  '2': [
    {
      '1': 'workspace_id',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.UUID',
      '10': 'workspaceId'
    },
    {'1': 'user_id', '3': 2, '4': 1, '5': 9, '10': 'userId'},
  ],
};

/// Descriptor for `GetProgressRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getProgressRequestDescriptor = $convert.base64Decode(
    'ChJHZXRQcm9ncmVzc1JlcXVlc3QSPgoMd29ya3NwYWNlX2lkGAEgASgLMhsuY3JlYXRpdmFudG'
    'EuY29tbW9uLnYxLlVVSURSC3dvcmtzcGFjZUlkEhcKB3VzZXJfaWQYAiABKAlSBnVzZXJJZA==');

@$core.Deprecated('Use getProgressResponseDescriptor instead')
const GetProgressResponse$json = {
  '1': 'GetProgressResponse',
  '2': [
    {
      '1': 'progress',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.platform.v1.CreatorProgress',
      '10': 'progress'
    },
  ],
};

/// Descriptor for `GetProgressResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getProgressResponseDescriptor = $convert.base64Decode(
    'ChNHZXRQcm9ncmVzc1Jlc3BvbnNlEkQKCHByb2dyZXNzGAEgASgLMiguY3JlYXRpdmFudGEucG'
    'xhdGZvcm0udjEuQ3JlYXRvclByb2dyZXNzUghwcm9ncmVzcw==');

@$core.Deprecated('Use listAchievementsRequestDescriptor instead')
const ListAchievementsRequest$json = {
  '1': 'ListAchievementsRequest',
  '2': [
    {
      '1': 'workspace_id',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.UUID',
      '10': 'workspaceId'
    },
    {'1': 'user_id', '3': 2, '4': 1, '5': 9, '10': 'userId'},
    {'1': 'category', '3': 3, '4': 1, '5': 9, '10': 'category'},
  ],
};

/// Descriptor for `ListAchievementsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listAchievementsRequestDescriptor = $convert.base64Decode(
    'ChdMaXN0QWNoaWV2ZW1lbnRzUmVxdWVzdBI+Cgx3b3Jrc3BhY2VfaWQYASABKAsyGy5jcmVhdG'
    'l2YW50YS5jb21tb24udjEuVVVJRFILd29ya3NwYWNlSWQSFwoHdXNlcl9pZBgCIAEoCVIGdXNl'
    'cklkEhoKCGNhdGVnb3J5GAMgASgJUghjYXRlZ29yeQ==');

@$core.Deprecated('Use listAchievementsResponseDescriptor instead')
const ListAchievementsResponse$json = {
  '1': 'ListAchievementsResponse',
  '2': [
    {
      '1': 'achievements',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.creativanta.platform.v1.AchievementItem',
      '10': 'achievements'
    },
    {'1': 'total_unlocked', '3': 2, '4': 1, '5': 5, '10': 'totalUnlocked'},
    {'1': 'total_available', '3': 3, '4': 1, '5': 5, '10': 'totalAvailable'},
  ],
};

/// Descriptor for `ListAchievementsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listAchievementsResponseDescriptor = $convert.base64Decode(
    'ChhMaXN0QWNoaWV2ZW1lbnRzUmVzcG9uc2USTAoMYWNoaWV2ZW1lbnRzGAEgAygLMiguY3JlYX'
    'RpdmFudGEucGxhdGZvcm0udjEuQWNoaWV2ZW1lbnRJdGVtUgxhY2hpZXZlbWVudHMSJQoOdG90'
    'YWxfdW5sb2NrZWQYAiABKAVSDXRvdGFsVW5sb2NrZWQSJwoPdG90YWxfYXZhaWxhYmxlGAMgAS'
    'gFUg50b3RhbEF2YWlsYWJsZQ==');

@$core.Deprecated('Use listChallengesRequestDescriptor instead')
const ListChallengesRequest$json = {
  '1': 'ListChallengesRequest',
  '2': [
    {
      '1': 'workspace_id',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.UUID',
      '10': 'workspaceId'
    },
    {'1': 'user_id', '3': 2, '4': 1, '5': 9, '10': 'userId'},
    {
      '1': 'status_filter',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.creativanta.platform.v1.ChallengeStatus',
      '10': 'statusFilter'
    },
  ],
};

/// Descriptor for `ListChallengesRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listChallengesRequestDescriptor = $convert.base64Decode(
    'ChVMaXN0Q2hhbGxlbmdlc1JlcXVlc3QSPgoMd29ya3NwYWNlX2lkGAEgASgLMhsuY3JlYXRpdm'
    'FudGEuY29tbW9uLnYxLlVVSURSC3dvcmtzcGFjZUlkEhcKB3VzZXJfaWQYAiABKAlSBnVzZXJJ'
    'ZBJNCg1zdGF0dXNfZmlsdGVyGAMgASgOMiguY3JlYXRpdmFudGEucGxhdGZvcm0udjEuQ2hhbG'
    'xlbmdlU3RhdHVzUgxzdGF0dXNGaWx0ZXI=');

@$core.Deprecated('Use listChallengesResponseDescriptor instead')
const ListChallengesResponse$json = {
  '1': 'ListChallengesResponse',
  '2': [
    {
      '1': 'challenges',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.creativanta.platform.v1.ChallengeItem',
      '10': 'challenges'
    },
  ],
};

/// Descriptor for `ListChallengesResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listChallengesResponseDescriptor =
    $convert.base64Decode(
        'ChZMaXN0Q2hhbGxlbmdlc1Jlc3BvbnNlEkYKCmNoYWxsZW5nZXMYASADKAsyJi5jcmVhdGl2YW'
        '50YS5wbGF0Zm9ybS52MS5DaGFsbGVuZ2VJdGVtUgpjaGFsbGVuZ2Vz');

@$core.Deprecated('Use getChallengeProgressRequestDescriptor instead')
const GetChallengeProgressRequest$json = {
  '1': 'GetChallengeProgressRequest',
  '2': [
    {
      '1': 'workspace_id',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.UUID',
      '10': 'workspaceId'
    },
    {'1': 'user_id', '3': 2, '4': 1, '5': 9, '10': 'userId'},
    {'1': 'challenge_id', '3': 3, '4': 1, '5': 9, '10': 'challengeId'},
  ],
};

/// Descriptor for `GetChallengeProgressRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getChallengeProgressRequestDescriptor =
    $convert.base64Decode(
        'ChtHZXRDaGFsbGVuZ2VQcm9ncmVzc1JlcXVlc3QSPgoMd29ya3NwYWNlX2lkGAEgASgLMhsuY3'
        'JlYXRpdmFudGEuY29tbW9uLnYxLlVVSURSC3dvcmtzcGFjZUlkEhcKB3VzZXJfaWQYAiABKAlS'
        'BnVzZXJJZBIhCgxjaGFsbGVuZ2VfaWQYAyABKAlSC2NoYWxsZW5nZUlk');

@$core.Deprecated('Use getChallengeProgressResponseDescriptor instead')
const GetChallengeProgressResponse$json = {
  '1': 'GetChallengeProgressResponse',
  '2': [
    {
      '1': 'challenge',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.platform.v1.ChallengeDefinition',
      '10': 'challenge'
    },
    {
      '1': 'progress',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.creativanta.platform.v1.ChallengeProgress',
      '10': 'progress'
    },
  ],
};

/// Descriptor for `GetChallengeProgressResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getChallengeProgressResponseDescriptor = $convert.base64Decode(
    'ChxHZXRDaGFsbGVuZ2VQcm9ncmVzc1Jlc3BvbnNlEkoKCWNoYWxsZW5nZRgBIAEoCzIsLmNyZW'
    'F0aXZhbnRhLnBsYXRmb3JtLnYxLkNoYWxsZW5nZURlZmluaXRpb25SCWNoYWxsZW5nZRJGCghw'
    'cm9ncmVzcxgCIAEoCzIqLmNyZWF0aXZhbnRhLnBsYXRmb3JtLnYxLkNoYWxsZW5nZVByb2dyZX'
    'NzUghwcm9ncmVzcw==');

@$core.Deprecated('Use shareAchievementRequestDescriptor instead')
const ShareAchievementRequest$json = {
  '1': 'ShareAchievementRequest',
  '2': [
    {
      '1': 'context',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.CommandContext',
      '10': 'context'
    },
    {'1': 'achievement_code', '3': 2, '4': 1, '5': 9, '10': 'achievementCode'},
    {'1': 'target_channel', '3': 3, '4': 1, '5': 9, '10': 'targetChannel'},
  ],
};

/// Descriptor for `ShareAchievementRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List shareAchievementRequestDescriptor = $convert.base64Decode(
    'ChdTaGFyZUFjaGlldmVtZW50UmVxdWVzdBI/Cgdjb250ZXh0GAEgASgLMiUuY3JlYXRpdmFudG'
    'EuY29tbW9uLnYxLkNvbW1hbmRDb250ZXh0Ugdjb250ZXh0EikKEGFjaGlldmVtZW50X2NvZGUY'
    'AiABKAlSD2FjaGlldmVtZW50Q29kZRIlCg50YXJnZXRfY2hhbm5lbBgDIAEoCVINdGFyZ2V0Q2'
    'hhbm5lbA==');

@$core.Deprecated('Use shareAchievementResponseDescriptor instead')
const ShareAchievementResponse$json = {
  '1': 'ShareAchievementResponse',
  '2': [
    {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
    {'1': 'share_url', '3': 2, '4': 1, '5': 9, '10': 'shareUrl'},
    {'1': 'share_card_url', '3': 3, '4': 1, '5': 9, '10': 'shareCardUrl'},
    {'1': 'message', '3': 4, '4': 1, '5': 9, '10': 'message'},
  ],
};

/// Descriptor for `ShareAchievementResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List shareAchievementResponseDescriptor = $convert.base64Decode(
    'ChhTaGFyZUFjaGlldmVtZW50UmVzcG9uc2USGAoHc3VjY2VzcxgBIAEoCFIHc3VjY2VzcxIbCg'
    'lzaGFyZV91cmwYAiABKAlSCHNoYXJlVXJsEiQKDnNoYXJlX2NhcmRfdXJsGAMgASgJUgxzaGFy'
    'ZUNhcmRVcmwSGAoHbWVzc2FnZRgEIAEoCVIHbWVzc2FnZQ==');

@$core
    .Deprecated('Use gamificationServiceGetDashboardRequestDescriptor instead')
const GamificationServiceGetDashboardRequest$json = {
  '1': 'GamificationServiceGetDashboardRequest',
  '2': [
    {
      '1': 'workspace_id',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.UUID',
      '10': 'workspaceId'
    },
    {'1': 'user_id', '3': 2, '4': 1, '5': 9, '10': 'userId'},
  ],
};

/// Descriptor for `GamificationServiceGetDashboardRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List gamificationServiceGetDashboardRequestDescriptor =
    $convert.base64Decode(
        'CiZHYW1pZmljYXRpb25TZXJ2aWNlR2V0RGFzaGJvYXJkUmVxdWVzdBI+Cgx3b3Jrc3BhY2VfaW'
        'QYASABKAsyGy5jcmVhdGl2YW50YS5jb21tb24udjEuVVVJRFILd29ya3NwYWNlSWQSFwoHdXNl'
        'cl9pZBgCIAEoCVIGdXNlcklk');

@$core
    .Deprecated('Use gamificationServiceGetDashboardResponseDescriptor instead')
const GamificationServiceGetDashboardResponse$json = {
  '1': 'GamificationServiceGetDashboardResponse',
  '2': [
    {
      '1': 'progress',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.platform.v1.CreatorProgress',
      '10': 'progress'
    },
    {
      '1': 'recent_achievements',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.creativanta.platform.v1.AchievementItem',
      '10': 'recentAchievements'
    },
    {
      '1': 'active_challenges',
      '3': 3,
      '4': 3,
      '5': 11,
      '6': '.creativanta.platform.v1.ChallengeItem',
      '10': 'activeChallenges'
    },
    {
      '1': 'top_creators',
      '3': 4,
      '4': 3,
      '5': 11,
      '6': '.creativanta.platform.v1.LeaderboardEntry',
      '10': 'topCreators'
    },
    {
      '1': 'current_streak_days',
      '3': 5,
      '4': 1,
      '5': 5,
      '10': 'currentStreakDays'
    },
    {
      '1': 'streak_milestone_target',
      '3': 6,
      '4': 1,
      '5': 9,
      '10': 'streakMilestoneTarget'
    },
    {
      '1': 'streak_milestone_reward_credits',
      '3': 7,
      '4': 1,
      '5': 5,
      '10': 'streakMilestoneRewardCredits'
    },
  ],
};

/// Descriptor for `GamificationServiceGetDashboardResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List gamificationServiceGetDashboardResponseDescriptor = $convert.base64Decode(
    'CidHYW1pZmljYXRpb25TZXJ2aWNlR2V0RGFzaGJvYXJkUmVzcG9uc2USRAoIcHJvZ3Jlc3MYAS'
    'ABKAsyKC5jcmVhdGl2YW50YS5wbGF0Zm9ybS52MS5DcmVhdG9yUHJvZ3Jlc3NSCHByb2dyZXNz'
    'ElkKE3JlY2VudF9hY2hpZXZlbWVudHMYAiADKAsyKC5jcmVhdGl2YW50YS5wbGF0Zm9ybS52MS'
    '5BY2hpZXZlbWVudEl0ZW1SEnJlY2VudEFjaGlldmVtZW50cxJTChFhY3RpdmVfY2hhbGxlbmdl'
    'cxgDIAMoCzImLmNyZWF0aXZhbnRhLnBsYXRmb3JtLnYxLkNoYWxsZW5nZUl0ZW1SEGFjdGl2ZU'
    'NoYWxsZW5nZXMSTAoMdG9wX2NyZWF0b3JzGAQgAygLMikuY3JlYXRpdmFudGEucGxhdGZvcm0u'
    'djEuTGVhZGVyYm9hcmRFbnRyeVILdG9wQ3JlYXRvcnMSLgoTY3VycmVudF9zdHJlYWtfZGF5cx'
    'gFIAEoBVIRY3VycmVudFN0cmVha0RheXMSNgoXc3RyZWFrX21pbGVzdG9uZV90YXJnZXQYBiAB'
    'KAlSFXN0cmVha01pbGVzdG9uZVRhcmdldBJFCh9zdHJlYWtfbWlsZXN0b25lX3Jld2FyZF9jcm'
    'VkaXRzGAcgASgFUhxzdHJlYWtNaWxlc3RvbmVSZXdhcmRDcmVkaXRz');

@$core.Deprecated('Use getAchievementsRequestDescriptor instead')
const GetAchievementsRequest$json = {
  '1': 'GetAchievementsRequest',
  '2': [
    {
      '1': 'workspace_id',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.UUID',
      '10': 'workspaceId'
    },
    {'1': 'user_id', '3': 2, '4': 1, '5': 9, '10': 'userId'},
  ],
};

/// Descriptor for `GetAchievementsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getAchievementsRequestDescriptor = $convert.base64Decode(
    'ChZHZXRBY2hpZXZlbWVudHNSZXF1ZXN0Ej4KDHdvcmtzcGFjZV9pZBgBIAEoCzIbLmNyZWF0aX'
    'ZhbnRhLmNvbW1vbi52MS5VVUlEUgt3b3Jrc3BhY2VJZBIXCgd1c2VyX2lkGAIgASgJUgZ1c2Vy'
    'SWQ=');

@$core.Deprecated('Use getAchievementsResponseDescriptor instead')
const GetAchievementsResponse$json = {
  '1': 'GetAchievementsResponse',
  '2': [
    {
      '1': 'achievements',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.creativanta.platform.v1.AchievementItem',
      '10': 'achievements'
    },
  ],
};

/// Descriptor for `GetAchievementsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getAchievementsResponseDescriptor =
    $convert.base64Decode(
        'ChdHZXRBY2hpZXZlbWVudHNSZXNwb25zZRJMCgxhY2hpZXZlbWVudHMYASADKAsyKC5jcmVhdG'
        'l2YW50YS5wbGF0Zm9ybS52MS5BY2hpZXZlbWVudEl0ZW1SDGFjaGlldmVtZW50cw==');

@$core.Deprecated('Use getActiveQuestsRequestDescriptor instead')
const GetActiveQuestsRequest$json = {
  '1': 'GetActiveQuestsRequest',
  '2': [
    {
      '1': 'workspace_id',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.UUID',
      '10': 'workspaceId'
    },
    {'1': 'user_id', '3': 2, '4': 1, '5': 9, '10': 'userId'},
  ],
};

/// Descriptor for `GetActiveQuestsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getActiveQuestsRequestDescriptor = $convert.base64Decode(
    'ChZHZXRBY3RpdmVRdWVzdHNSZXF1ZXN0Ej4KDHdvcmtzcGFjZV9pZBgBIAEoCzIbLmNyZWF0aX'
    'ZhbnRhLmNvbW1vbi52MS5VVUlEUgt3b3Jrc3BhY2VJZBIXCgd1c2VyX2lkGAIgASgJUgZ1c2Vy'
    'SWQ=');

@$core.Deprecated('Use getActiveQuestsResponseDescriptor instead')
const GetActiveQuestsResponse$json = {
  '1': 'GetActiveQuestsResponse',
  '2': [
    {
      '1': 'quests',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.creativanta.platform.v1.ChallengeItem',
      '10': 'quests'
    },
  ],
};

/// Descriptor for `GetActiveQuestsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getActiveQuestsResponseDescriptor =
    $convert.base64Decode(
        'ChdHZXRBY3RpdmVRdWVzdHNSZXNwb25zZRI+CgZxdWVzdHMYASADKAsyJi5jcmVhdGl2YW50YS'
        '5wbGF0Zm9ybS52MS5DaGFsbGVuZ2VJdGVtUgZxdWVzdHM=');

@$core.Deprecated('Use getLeaderboardRequestDescriptor instead')
const GetLeaderboardRequest$json = {
  '1': 'GetLeaderboardRequest',
  '2': [
    {
      '1': 'workspace_id',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.UUID',
      '10': 'workspaceId'
    },
    {'1': 'timeframe', '3': 2, '4': 1, '5': 9, '10': 'timeframe'},
    {'1': 'limit', '3': 3, '4': 1, '5': 5, '10': 'limit'},
  ],
};

/// Descriptor for `GetLeaderboardRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getLeaderboardRequestDescriptor = $convert.base64Decode(
    'ChVHZXRMZWFkZXJib2FyZFJlcXVlc3QSPgoMd29ya3NwYWNlX2lkGAEgASgLMhsuY3JlYXRpdm'
    'FudGEuY29tbW9uLnYxLlVVSURSC3dvcmtzcGFjZUlkEhwKCXRpbWVmcmFtZRgCIAEoCVIJdGlt'
    'ZWZyYW1lEhQKBWxpbWl0GAMgASgFUgVsaW1pdA==');

@$core.Deprecated('Use getLeaderboardResponseDescriptor instead')
const GetLeaderboardResponse$json = {
  '1': 'GetLeaderboardResponse',
  '2': [
    {
      '1': 'entries',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.creativanta.platform.v1.LeaderboardEntry',
      '10': 'entries'
    },
    {
      '1': 'user_entry',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.creativanta.platform.v1.LeaderboardEntry',
      '10': 'userEntry'
    },
  ],
};

/// Descriptor for `GetLeaderboardResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getLeaderboardResponseDescriptor = $convert.base64Decode(
    'ChZHZXRMZWFkZXJib2FyZFJlc3BvbnNlEkMKB2VudHJpZXMYASADKAsyKS5jcmVhdGl2YW50YS'
    '5wbGF0Zm9ybS52MS5MZWFkZXJib2FyZEVudHJ5UgdlbnRyaWVzEkgKCnVzZXJfZW50cnkYAiAB'
    'KAsyKS5jcmVhdGl2YW50YS5wbGF0Zm9ybS52MS5MZWFkZXJib2FyZEVudHJ5Ugl1c2VyRW50cn'
    'k=');

@$core.Deprecated('Use getStreakRequestDescriptor instead')
const GetStreakRequest$json = {
  '1': 'GetStreakRequest',
  '2': [
    {
      '1': 'workspace_id',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.UUID',
      '10': 'workspaceId'
    },
    {'1': 'user_id', '3': 2, '4': 1, '5': 9, '10': 'userId'},
  ],
};

/// Descriptor for `GetStreakRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getStreakRequestDescriptor = $convert.base64Decode(
    'ChBHZXRTdHJlYWtSZXF1ZXN0Ej4KDHdvcmtzcGFjZV9pZBgBIAEoCzIbLmNyZWF0aXZhbnRhLm'
    'NvbW1vbi52MS5VVUlEUgt3b3Jrc3BhY2VJZBIXCgd1c2VyX2lkGAIgASgJUgZ1c2VySWQ=');

@$core.Deprecated('Use getStreakResponseDescriptor instead')
const GetStreakResponse$json = {
  '1': 'GetStreakResponse',
  '2': [
    {'1': 'streak_days', '3': 1, '4': 1, '5': 5, '10': 'streakDays'},
    {
      '1': 'last_activity_date',
      '3': 2,
      '4': 1,
      '5': 9,
      '10': 'lastActivityDate'
    },
    {'1': 'is_active_today', '3': 3, '4': 1, '5': 8, '10': 'isActiveToday'},
    {
      '1': 'next_milestone_days',
      '3': 4,
      '4': 1,
      '5': 5,
      '10': 'nextMilestoneDays'
    },
    {
      '1': 'next_milestone_reward_credits',
      '3': 5,
      '4': 1,
      '5': 5,
      '10': 'nextMilestoneRewardCredits'
    },
  ],
};

/// Descriptor for `GetStreakResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getStreakResponseDescriptor = $convert.base64Decode(
    'ChFHZXRTdHJlYWtSZXNwb25zZRIfCgtzdHJlYWtfZGF5cxgBIAEoBVIKc3RyZWFrRGF5cxIsCh'
    'JsYXN0X2FjdGl2aXR5X2RhdGUYAiABKAlSEGxhc3RBY3Rpdml0eURhdGUSJgoPaXNfYWN0aXZl'
    'X3RvZGF5GAMgASgIUg1pc0FjdGl2ZVRvZGF5Ei4KE25leHRfbWlsZXN0b25lX2RheXMYBCABKA'
    'VSEW5leHRNaWxlc3RvbmVEYXlzEkEKHW5leHRfbWlsZXN0b25lX3Jld2FyZF9jcmVkaXRzGAUg'
    'ASgFUhpuZXh0TWlsZXN0b25lUmV3YXJkQ3JlZGl0cw==');

@$core.Deprecated('Use adminRestoreStreakRequestDescriptor instead')
const AdminRestoreStreakRequest$json = {
  '1': 'AdminRestoreStreakRequest',
  '2': [
    {
      '1': 'context',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.CommandContext',
      '10': 'context'
    },
    {'1': 'target_user_id', '3': 2, '4': 1, '5': 9, '10': 'targetUserId'},
    {
      '1': 'restored_streak_days',
      '3': 3,
      '4': 1,
      '5': 5,
      '10': 'restoredStreakDays'
    },
    {'1': 'reason', '3': 4, '4': 1, '5': 9, '10': 'reason'},
  ],
};

/// Descriptor for `AdminRestoreStreakRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List adminRestoreStreakRequestDescriptor = $convert.base64Decode(
    'ChlBZG1pblJlc3RvcmVTdHJlYWtSZXF1ZXN0Ej8KB2NvbnRleHQYASABKAsyJS5jcmVhdGl2YW'
    '50YS5jb21tb24udjEuQ29tbWFuZENvbnRleHRSB2NvbnRleHQSJAoOdGFyZ2V0X3VzZXJfaWQY'
    'AiABKAlSDHRhcmdldFVzZXJJZBIwChRyZXN0b3JlZF9zdHJlYWtfZGF5cxgDIAEoBVIScmVzdG'
    '9yZWRTdHJlYWtEYXlzEhYKBnJlYXNvbhgEIAEoCVIGcmVhc29u');

@$core.Deprecated('Use adminRestoreStreakResponseDescriptor instead')
const AdminRestoreStreakResponse$json = {
  '1': 'AdminRestoreStreakResponse',
  '2': [
    {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
    {
      '1': 'progress',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.creativanta.platform.v1.CreatorProgress',
      '10': 'progress'
    },
    {'1': 'message', '3': 3, '4': 1, '5': 9, '10': 'message'},
  ],
};

/// Descriptor for `AdminRestoreStreakResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List adminRestoreStreakResponseDescriptor =
    $convert.base64Decode(
        'ChpBZG1pblJlc3RvcmVTdHJlYWtSZXNwb25zZRIYCgdzdWNjZXNzGAEgASgIUgdzdWNjZXNzEk'
        'QKCHByb2dyZXNzGAIgASgLMiguY3JlYXRpdmFudGEucGxhdGZvcm0udjEuQ3JlYXRvclByb2dy'
        'ZXNzUghwcm9ncmVzcxIYCgdtZXNzYWdlGAMgASgJUgdtZXNzYWdl');

// This is a generated file - do not edit.
//
// Generated from creativanta/platform/v1/referral.proto.

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

@$core.Deprecated('Use referralStatusDescriptor instead')
const ReferralStatus$json = {
  '1': 'ReferralStatus',
  '2': [
    {'1': 'REFERRAL_STATUS_UNSPECIFIED', '2': 0},
    {'1': 'REFERRAL_STATUS_PENDING', '2': 1},
    {'1': 'REFERRAL_STATUS_QUALIFIED', '2': 2},
    {'1': 'REFERRAL_STATUS_REWARDED', '2': 3},
    {'1': 'REFERRAL_STATUS_REVOKED', '2': 4},
    {'1': 'REFERRAL_STATUS_EXPIRED', '2': 5},
    {'1': 'REFERRAL_STATUS_FRAUD_FLAGGED', '2': 6},
    {'1': 'REFERRAL_STATUS_FORFEITED', '2': 7},
  ],
};

/// Descriptor for `ReferralStatus`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List referralStatusDescriptor = $convert.base64Decode(
    'Cg5SZWZlcnJhbFN0YXR1cxIfChtSRUZFUlJBTF9TVEFUVVNfVU5TUEVDSUZJRUQQABIbChdSRU'
    'ZFUlJBTF9TVEFUVVNfUEVORElORxABEh0KGVJFRkVSUkFMX1NUQVRVU19RVUFMSUZJRUQQAhIc'
    'ChhSRUZFUlJBTF9TVEFUVVNfUkVXQVJERUQQAxIbChdSRUZFUlJBTF9TVEFUVVNfUkVWT0tFRB'
    'AEEhsKF1JFRkVSUkFMX1NUQVRVU19FWFBJUkVEEAUSIQodUkVGRVJSQUxfU1RBVFVTX0ZSQVVE'
    'X0ZMQUdHRUQQBhIdChlSRUZFUlJBTF9TVEFUVVNfRk9SRkVJVEVEEAc=');

@$core.Deprecated('Use referralTierDescriptor instead')
const ReferralTier$json = {
  '1': 'ReferralTier',
  '2': [
    {'1': 'REFERRAL_TIER_UNSPECIFIED', '2': 0},
    {'1': 'REFERRAL_TIER_BRONZE', '2': 1},
    {'1': 'REFERRAL_TIER_SILVER', '2': 2},
    {'1': 'REFERRAL_TIER_GOLD', '2': 3},
    {'1': 'REFERRAL_TIER_PLATINUM', '2': 4},
  ],
};

/// Descriptor for `ReferralTier`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List referralTierDescriptor = $convert.base64Decode(
    'CgxSZWZlcnJhbFRpZXISHQoZUkVGRVJSQUxfVElFUl9VTlNQRUNJRklFRBAAEhgKFFJFRkVSUk'
    'FMX1RJRVJfQlJPTlpFEAESGAoUUkVGRVJSQUxfVElFUl9TSUxWRVIQAhIWChJSRUZFUlJBTF9U'
    'SUVSX0dPTEQQAxIaChZSRUZFUlJBTF9USUVSX1BMQVRJTlVNEAQ=');

@$core.Deprecated('Use growthTriggerTypeDescriptor instead')
const GrowthTriggerType$json = {
  '1': 'GrowthTriggerType',
  '2': [
    {'1': 'GROWTH_TRIGGER_TYPE_UNSPECIFIED', '2': 0},
    {'1': 'GROWTH_TRIGGER_TYPE_FIRST_PUBLISH', '2': 1},
    {'1': 'GROWTH_TRIGGER_TYPE_FIRST_PROFIT', '2': 2},
    {'1': 'GROWTH_TRIGGER_TYPE_FOLLOWER_MILESTONE', '2': 3},
    {'1': 'GROWTH_TRIGGER_TYPE_TEAM_INVITE', '2': 4},
    {'1': 'GROWTH_TRIGGER_TYPE_RECIPE_SUBMIT', '2': 5},
    {'1': 'GROWTH_TRIGGER_TYPE_FEATURE_UPVOTE', '2': 6},
  ],
};

/// Descriptor for `GrowthTriggerType`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List growthTriggerTypeDescriptor = $convert.base64Decode(
    'ChFHcm93dGhUcmlnZ2VyVHlwZRIjCh9HUk9XVEhfVFJJR0dFUl9UWVBFX1VOU1BFQ0lGSUVEEA'
    'ASJQohR1JPV1RIX1RSSUdHRVJfVFlQRV9GSVJTVF9QVUJMSVNIEAESJAogR1JPV1RIX1RSSUdH'
    'RVJfVFlQRV9GSVJTVF9QUk9GSVQQAhIqCiZHUk9XVEhfVFJJR0dFUl9UWVBFX0ZPTExPV0VSX0'
    '1JTEVTVE9ORRADEiMKH0dST1dUSF9UUklHR0VSX1RZUEVfVEVBTV9JTlZJVEUQBBIlCiFHUk9X'
    'VEhfVFJJR0dFUl9UWVBFX1JFQ0lQRV9TVUJNSVQQBRImCiJHUk9XVEhfVFJJR0dFUl9UWVBFX0'
    'ZFQVRVUkVfVVBWT1RFEAY=');

@$core.Deprecated('Use referralRecordDescriptor instead')
const ReferralRecord$json = {
  '1': 'ReferralRecord',
  '2': [
    {'1': 'referral_id', '3': 1, '4': 1, '5': 9, '10': 'referralId'},
    {'1': 'workspace_id', '3': 2, '4': 1, '5': 9, '10': 'workspaceId'},
    {
      '1': 'referee_workspace_id',
      '3': 3,
      '4': 1,
      '5': 9,
      '10': 'refereeWorkspaceId'
    },
    {'1': 'referrer_user_id', '3': 4, '4': 1, '5': 9, '10': 'referrerUserId'},
    {'1': 'referee_user_id', '3': 5, '4': 1, '5': 9, '10': 'refereeUserId'},
    {'1': 'referee_name', '3': 6, '4': 1, '5': 9, '10': 'refereeName'},
    {
      '1': 'referee_email_masked',
      '3': 7,
      '4': 1,
      '5': 9,
      '10': 'refereeEmailMasked'
    },
    {'1': 'referral_code', '3': 8, '4': 1, '5': 9, '10': 'referralCode'},
    {
      '1': 'status',
      '3': 9,
      '4': 1,
      '5': 14,
      '6': '.creativanta.platform.v1.ReferralStatus',
      '10': 'status'
    },
    {
      '1': 'referrer_credits_awarded',
      '3': 10,
      '4': 1,
      '5': 9,
      '10': 'referrerCreditsAwarded'
    },
    {
      '1': 'referee_credits_awarded',
      '3': 11,
      '4': 1,
      '5': 9,
      '10': 'refereeCreditsAwarded'
    },
    {'1': 'plan_tier', '3': 12, '4': 1, '5': 9, '10': 'planTier'},
    {'1': 'payment_status', '3': 13, '4': 1, '5': 9, '10': 'paymentStatus'},
    {
      '1': 'fraud_check_passed',
      '3': 14,
      '4': 1,
      '5': 8,
      '10': 'fraudCheckPassed'
    },
    {'1': 'fraud_reason', '3': 15, '4': 1, '5': 9, '10': 'fraudReason'},
    {
      '1': 'recurring_commission_rate',
      '3': 16,
      '4': 1,
      '5': 9,
      '10': 'recurringCommissionRate'
    },
    {
      '1': 'recurring_commission_earned',
      '3': 17,
      '4': 1,
      '5': 9,
      '10': 'recurringCommissionEarned'
    },
    {
      '1': 'qualified_at',
      '3': 18,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'qualifiedAt'
    },
    {
      '1': 'rewarded_at',
      '3': 19,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'rewardedAt'
    },
    {
      '1': 'created_at',
      '3': 20,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'createdAt'
    },
    {
      '1': 'updated_at',
      '3': 21,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'updatedAt'
    },
  ],
};

/// Descriptor for `ReferralRecord`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List referralRecordDescriptor = $convert.base64Decode(
    'Cg5SZWZlcnJhbFJlY29yZBIfCgtyZWZlcnJhbF9pZBgBIAEoCVIKcmVmZXJyYWxJZBIhCgx3b3'
    'Jrc3BhY2VfaWQYAiABKAlSC3dvcmtzcGFjZUlkEjAKFHJlZmVyZWVfd29ya3NwYWNlX2lkGAMg'
    'ASgJUhJyZWZlcmVlV29ya3NwYWNlSWQSKAoQcmVmZXJyZXJfdXNlcl9pZBgEIAEoCVIOcmVmZX'
    'JyZXJVc2VySWQSJgoPcmVmZXJlZV91c2VyX2lkGAUgASgJUg1yZWZlcmVlVXNlcklkEiEKDHJl'
    'ZmVyZWVfbmFtZRgGIAEoCVILcmVmZXJlZU5hbWUSMAoUcmVmZXJlZV9lbWFpbF9tYXNrZWQYBy'
    'ABKAlSEnJlZmVyZWVFbWFpbE1hc2tlZBIjCg1yZWZlcnJhbF9jb2RlGAggASgJUgxyZWZlcnJh'
    'bENvZGUSPwoGc3RhdHVzGAkgASgOMicuY3JlYXRpdmFudGEucGxhdGZvcm0udjEuUmVmZXJyYW'
    'xTdGF0dXNSBnN0YXR1cxI4ChhyZWZlcnJlcl9jcmVkaXRzX2F3YXJkZWQYCiABKAlSFnJlZmVy'
    'cmVyQ3JlZGl0c0F3YXJkZWQSNgoXcmVmZXJlZV9jcmVkaXRzX2F3YXJkZWQYCyABKAlSFXJlZm'
    'VyZWVDcmVkaXRzQXdhcmRlZBIbCglwbGFuX3RpZXIYDCABKAlSCHBsYW5UaWVyEiUKDnBheW1l'
    'bnRfc3RhdHVzGA0gASgJUg1wYXltZW50U3RhdHVzEiwKEmZyYXVkX2NoZWNrX3Bhc3NlZBgOIA'
    'EoCFIQZnJhdWRDaGVja1Bhc3NlZBIhCgxmcmF1ZF9yZWFzb24YDyABKAlSC2ZyYXVkUmVhc29u'
    'EjoKGXJlY3VycmluZ19jb21taXNzaW9uX3JhdGUYECABKAlSF3JlY3VycmluZ0NvbW1pc3Npb2'
    '5SYXRlEj4KG3JlY3VycmluZ19jb21taXNzaW9uX2Vhcm5lZBgRIAEoCVIZcmVjdXJyaW5nQ29t'
    'bWlzc2lvbkVhcm5lZBI9CgxxdWFsaWZpZWRfYXQYEiABKAsyGi5nb29nbGUucHJvdG9idWYuVG'
    'ltZXN0YW1wUgtxdWFsaWZpZWRBdBI7CgtyZXdhcmRlZF9hdBgTIAEoCzIaLmdvb2dsZS5wcm90'
    'b2J1Zi5UaW1lc3RhbXBSCnJld2FyZGVkQXQSOQoKY3JlYXRlZF9hdBgUIAEoCzIaLmdvb2dsZS'
    '5wcm90b2J1Zi5UaW1lc3RhbXBSCWNyZWF0ZWRBdBI5Cgp1cGRhdGVkX2F0GBUgASgLMhouZ29v'
    'Z2xlLnByb3RvYnVmLlRpbWVzdGFtcFIJdXBkYXRlZEF0');

@$core.Deprecated('Use referralFunnelDescriptor instead')
const ReferralFunnel$json = {
  '1': 'ReferralFunnel',
  '2': [
    {'1': 'total_clicks', '3': 1, '4': 1, '5': 3, '10': 'totalClicks'},
    {'1': 'total_signups', '3': 2, '4': 1, '5': 3, '10': 'totalSignups'},
    {'1': 'total_paid', '3': 3, '4': 1, '5': 3, '10': 'totalPaid'},
    {
      '1': 'click_to_signup_rate',
      '3': 4,
      '4': 1,
      '5': 1,
      '10': 'clickToSignupRate'
    },
    {
      '1': 'signup_to_paid_rate',
      '3': 5,
      '4': 1,
      '5': 1,
      '10': 'signupToPaidRate'
    },
    {
      '1': 'credits_earned_total',
      '3': 6,
      '4': 1,
      '5': 9,
      '10': 'creditsEarnedTotal'
    },
    {
      '1': 'credits_pending_total',
      '3': 7,
      '4': 1,
      '5': 9,
      '10': 'creditsPendingTotal'
    },
  ],
};

/// Descriptor for `ReferralFunnel`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List referralFunnelDescriptor = $convert.base64Decode(
    'Cg5SZWZlcnJhbEZ1bm5lbBIhCgx0b3RhbF9jbGlja3MYASABKANSC3RvdGFsQ2xpY2tzEiMKDX'
    'RvdGFsX3NpZ251cHMYAiABKANSDHRvdGFsU2lnbnVwcxIdCgp0b3RhbF9wYWlkGAMgASgDUgl0'
    'b3RhbFBhaWQSLwoUY2xpY2tfdG9fc2lnbnVwX3JhdGUYBCABKAFSEWNsaWNrVG9TaWdudXBSYX'
    'RlEi0KE3NpZ251cF90b19wYWlkX3JhdGUYBSABKAFSEHNpZ251cFRvUGFpZFJhdGUSMAoUY3Jl'
    'ZGl0c19lYXJuZWRfdG90YWwYBiABKAlSEmNyZWRpdHNFYXJuZWRUb3RhbBIyChVjcmVkaXRzX3'
    'BlbmRpbmdfdG90YWwYByABKAlSE2NyZWRpdHNQZW5kaW5nVG90YWw=');

@$core.Deprecated('Use tierProgressDescriptor instead')
const TierProgress$json = {
  '1': 'TierProgress',
  '2': [
    {
      '1': 'current_tier',
      '3': 1,
      '4': 1,
      '5': 14,
      '6': '.creativanta.platform.v1.ReferralTier',
      '10': 'currentTier'
    },
    {
      '1': 'next_tier',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.creativanta.platform.v1.ReferralTier',
      '10': 'nextTier'
    },
    {
      '1': 'qualified_referrals_count',
      '3': 3,
      '4': 1,
      '5': 5,
      '10': 'qualifiedReferralsCount'
    },
    {
      '1': 'referrals_to_next_tier',
      '3': 4,
      '4': 1,
      '5': 5,
      '10': 'referralsToNextTier'
    },
    {
      '1': 'progress_percentage',
      '3': 5,
      '4': 1,
      '5': 1,
      '10': 'progressPercentage'
    },
    {
      '1': 'current_reward_multiplier',
      '3': 6,
      '4': 1,
      '5': 9,
      '10': 'currentRewardMultiplier'
    },
    {
      '1': 'recurring_commission_rate',
      '3': 7,
      '4': 1,
      '5': 9,
      '10': 'recurringCommissionRate'
    },
  ],
};

/// Descriptor for `TierProgress`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List tierProgressDescriptor = $convert.base64Decode(
    'CgxUaWVyUHJvZ3Jlc3MSSAoMY3VycmVudF90aWVyGAEgASgOMiUuY3JlYXRpdmFudGEucGxhdG'
    'Zvcm0udjEuUmVmZXJyYWxUaWVyUgtjdXJyZW50VGllchJCCgluZXh0X3RpZXIYAiABKA4yJS5j'
    'cmVhdGl2YW50YS5wbGF0Zm9ybS52MS5SZWZlcnJhbFRpZXJSCG5leHRUaWVyEjoKGXF1YWxpZm'
    'llZF9yZWZlcnJhbHNfY291bnQYAyABKAVSF3F1YWxpZmllZFJlZmVycmFsc0NvdW50EjMKFnJl'
    'ZmVycmFsc190b19uZXh0X3RpZXIYBCABKAVSE3JlZmVycmFsc1RvTmV4dFRpZXISLwoTcHJvZ3'
    'Jlc3NfcGVyY2VudGFnZRgFIAEoAVIScHJvZ3Jlc3NQZXJjZW50YWdlEjoKGWN1cnJlbnRfcmV3'
    'YXJkX211bHRpcGxpZXIYBiABKAlSF2N1cnJlbnRSZXdhcmRNdWx0aXBsaWVyEjoKGXJlY3Vycm'
    'luZ19jb21taXNzaW9uX3JhdGUYByABKAlSF3JlY3VycmluZ0NvbW1pc3Npb25SYXRl');

@$core.Deprecated('Use growthPromptDescriptor instead')
const GrowthPrompt$json = {
  '1': 'GrowthPrompt',
  '2': [
    {'1': 'prompt_id', '3': 1, '4': 1, '5': 9, '10': 'promptId'},
    {
      '1': 'trigger_type',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.creativanta.platform.v1.GrowthTriggerType',
      '10': 'triggerType'
    },
    {'1': 'title', '3': 3, '4': 1, '5': 9, '10': 'title'},
    {'1': 'description', '3': 4, '4': 1, '5': 9, '10': 'description'},
    {'1': 'credit_reward', '3': 5, '4': 1, '5': 9, '10': 'creditReward'},
    {'1': 'share_url', '3': 6, '4': 1, '5': 9, '10': 'shareUrl'},
    {'1': 'is_completed', '3': 7, '4': 1, '5': 8, '10': 'isCompleted'},
  ],
};

/// Descriptor for `GrowthPrompt`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List growthPromptDescriptor = $convert.base64Decode(
    'CgxHcm93dGhQcm9tcHQSGwoJcHJvbXB0X2lkGAEgASgJUghwcm9tcHRJZBJNCgx0cmlnZ2VyX3'
    'R5cGUYAiABKA4yKi5jcmVhdGl2YW50YS5wbGF0Zm9ybS52MS5Hcm93dGhUcmlnZ2VyVHlwZVIL'
    'dHJpZ2dlclR5cGUSFAoFdGl0bGUYAyABKAlSBXRpdGxlEiAKC2Rlc2NyaXB0aW9uGAQgASgJUg'
    'tkZXNjcmlwdGlvbhIjCg1jcmVkaXRfcmV3YXJkGAUgASgJUgxjcmVkaXRSZXdhcmQSGwoJc2hh'
    'cmVfdXJsGAYgASgJUghzaGFyZVVybBIhCgxpc19jb21wbGV0ZWQYByABKAhSC2lzQ29tcGxldG'
    'Vk');

@$core.Deprecated('Use promotionalCampaignDescriptor instead')
const PromotionalCampaign$json = {
  '1': 'PromotionalCampaign',
  '2': [
    {'1': 'campaign_id', '3': 1, '4': 1, '5': 9, '10': 'campaignId'},
    {'1': 'code', '3': 2, '4': 1, '5': 9, '10': 'code'},
    {'1': 'title', '3': 3, '4': 1, '5': 9, '10': 'title'},
    {'1': 'description', '3': 4, '4': 1, '5': 9, '10': 'description'},
    {'1': 'credit_bonus', '3': 5, '4': 1, '5': 9, '10': 'creditBonus'},
    {
      '1': 'expires_at',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'expiresAt'
    },
    {'1': 'is_active', '3': 7, '4': 1, '5': 8, '10': 'isActive'},
  ],
};

/// Descriptor for `PromotionalCampaign`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List promotionalCampaignDescriptor = $convert.base64Decode(
    'ChNQcm9tb3Rpb25hbENhbXBhaWduEh8KC2NhbXBhaWduX2lkGAEgASgJUgpjYW1wYWlnbklkEh'
    'IKBGNvZGUYAiABKAlSBGNvZGUSFAoFdGl0bGUYAyABKAlSBXRpdGxlEiAKC2Rlc2NyaXB0aW9u'
    'GAQgASgJUgtkZXNjcmlwdGlvbhIhCgxjcmVkaXRfYm9udXMYBSABKAlSC2NyZWRpdEJvbnVzEj'
    'kKCmV4cGlyZXNfYXQYBiABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUglleHBpcmVz'
    'QXQSGwoJaXNfYWN0aXZlGAcgASgIUghpc0FjdGl2ZQ==');

@$core.Deprecated('Use getMyReferralCodeRequestDescriptor instead')
const GetMyReferralCodeRequest$json = {
  '1': 'GetMyReferralCodeRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
  ],
};

/// Descriptor for `GetMyReferralCodeRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getMyReferralCodeRequestDescriptor =
    $convert.base64Decode(
        'ChhHZXRNeVJlZmVycmFsQ29kZVJlcXVlc3QSIQoMd29ya3NwYWNlX2lkGAEgASgJUgt3b3Jrc3'
        'BhY2VJZA==');

@$core.Deprecated('Use getMyReferralCodeResponseDescriptor instead')
const GetMyReferralCodeResponse$json = {
  '1': 'GetMyReferralCodeResponse',
  '2': [
    {'1': 'referral_code', '3': 1, '4': 1, '5': 9, '10': 'referralCode'},
    {'1': 'share_url', '3': 2, '4': 1, '5': 9, '10': 'shareUrl'},
    {'1': 'qr_code_url', '3': 3, '4': 1, '5': 9, '10': 'qrCodeUrl'},
    {'1': 'workspace_id', '3': 4, '4': 1, '5': 9, '10': 'workspaceId'},
  ],
};

/// Descriptor for `GetMyReferralCodeResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getMyReferralCodeResponseDescriptor = $convert.base64Decode(
    'ChlHZXRNeVJlZmVycmFsQ29kZVJlc3BvbnNlEiMKDXJlZmVycmFsX2NvZGUYASABKAlSDHJlZm'
    'VycmFsQ29kZRIbCglzaGFyZV91cmwYAiABKAlSCHNoYXJlVXJsEh4KC3FyX2NvZGVfdXJsGAMg'
    'ASgJUglxckNvZGVVcmwSIQoMd29ya3NwYWNlX2lkGAQgASgJUgt3b3Jrc3BhY2VJZA==');

@$core.Deprecated('Use getReferralStatsRequestDescriptor instead')
const GetReferralStatsRequest$json = {
  '1': 'GetReferralStatsRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
  ],
};

/// Descriptor for `GetReferralStatsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getReferralStatsRequestDescriptor =
    $convert.base64Decode(
        'ChdHZXRSZWZlcnJhbFN0YXRzUmVxdWVzdBIhCgx3b3Jrc3BhY2VfaWQYASABKAlSC3dvcmtzcG'
        'FjZUlk');

@$core.Deprecated('Use getReferralStatsResponseDescriptor instead')
const GetReferralStatsResponse$json = {
  '1': 'GetReferralStatsResponse',
  '2': [
    {
      '1': 'funnel',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.platform.v1.ReferralFunnel',
      '10': 'funnel'
    },
    {
      '1': 'tier',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.creativanta.platform.v1.TierProgress',
      '10': 'tier'
    },
  ],
};

/// Descriptor for `GetReferralStatsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getReferralStatsResponseDescriptor = $convert.base64Decode(
    'ChhHZXRSZWZlcnJhbFN0YXRzUmVzcG9uc2USPwoGZnVubmVsGAEgASgLMicuY3JlYXRpdmFudG'
    'EucGxhdGZvcm0udjEuUmVmZXJyYWxGdW5uZWxSBmZ1bm5lbBI5CgR0aWVyGAIgASgLMiUuY3Jl'
    'YXRpdmFudGEucGxhdGZvcm0udjEuVGllclByb2dyZXNzUgR0aWVy');

@$core.Deprecated('Use listReferralsRequestDescriptor instead')
const ListReferralsRequest$json = {
  '1': 'ListReferralsRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {
      '1': 'status_filter',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.creativanta.platform.v1.ReferralStatus',
      '10': 'statusFilter'
    },
    {
      '1': 'pagination',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.creativanta.common.v1.Pagination',
      '10': 'pagination'
    },
  ],
};

/// Descriptor for `ListReferralsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listReferralsRequestDescriptor = $convert.base64Decode(
    'ChRMaXN0UmVmZXJyYWxzUmVxdWVzdBIhCgx3b3Jrc3BhY2VfaWQYASABKAlSC3dvcmtzcGFjZU'
    'lkEkwKDXN0YXR1c19maWx0ZXIYAiABKA4yJy5jcmVhdGl2YW50YS5wbGF0Zm9ybS52MS5SZWZl'
    'cnJhbFN0YXR1c1IMc3RhdHVzRmlsdGVyEkEKCnBhZ2luYXRpb24YAyABKAsyIS5jcmVhdGl2YW'
    '50YS5jb21tb24udjEuUGFnaW5hdGlvblIKcGFnaW5hdGlvbg==');

@$core.Deprecated('Use listReferralsResponseDescriptor instead')
const ListReferralsResponse$json = {
  '1': 'ListReferralsResponse',
  '2': [
    {
      '1': 'referrals',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.creativanta.platform.v1.ReferralRecord',
      '10': 'referrals'
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

/// Descriptor for `ListReferralsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listReferralsResponseDescriptor = $convert.base64Decode(
    'ChVMaXN0UmVmZXJyYWxzUmVzcG9uc2USRQoJcmVmZXJyYWxzGAEgAygLMicuY3JlYXRpdmFudG'
    'EucGxhdGZvcm0udjEuUmVmZXJyYWxSZWNvcmRSCXJlZmVycmFscxJICgpwYWdpbmF0aW9uGAIg'
    'ASgLMiguY3JlYXRpdmFudGEuY29tbW9uLnYxLlBhZ2luYXRlZFJlc3BvbnNlUgpwYWdpbmF0aW'
    '9u');

@$core.Deprecated('Use claimRewardRequestDescriptor instead')
const ClaimRewardRequest$json = {
  '1': 'ClaimRewardRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'referral_id', '3': 2, '4': 1, '5': 9, '10': 'referralId'},
    {'1': 'idempotency_key', '3': 3, '4': 1, '5': 9, '10': 'idempotencyKey'},
  ],
};

/// Descriptor for `ClaimRewardRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List claimRewardRequestDescriptor = $convert.base64Decode(
    'ChJDbGFpbVJld2FyZFJlcXVlc3QSIQoMd29ya3NwYWNlX2lkGAEgASgJUgt3b3Jrc3BhY2VJZB'
    'IfCgtyZWZlcnJhbF9pZBgCIAEoCVIKcmVmZXJyYWxJZBInCg9pZGVtcG90ZW5jeV9rZXkYAyAB'
    'KAlSDmlkZW1wb3RlbmN5S2V5');

@$core.Deprecated('Use claimRewardResponseDescriptor instead')
const ClaimRewardResponse$json = {
  '1': 'ClaimRewardResponse',
  '2': [
    {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
    {'1': 'credits_awarded', '3': 2, '4': 1, '5': 9, '10': 'creditsAwarded'},
    {'1': 'transaction_id', '3': 3, '4': 1, '5': 9, '10': 'transactionId'},
    {'1': 'new_balance', '3': 4, '4': 1, '5': 9, '10': 'newBalance'},
  ],
};

/// Descriptor for `ClaimRewardResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List claimRewardResponseDescriptor = $convert.base64Decode(
    'ChNDbGFpbVJld2FyZFJlc3BvbnNlEhgKB3N1Y2Nlc3MYASABKAhSB3N1Y2Nlc3MSJwoPY3JlZG'
    'l0c19hd2FyZGVkGAIgASgJUg5jcmVkaXRzQXdhcmRlZBIlCg50cmFuc2FjdGlvbl9pZBgDIAEo'
    'CVINdHJhbnNhY3Rpb25JZBIfCgtuZXdfYmFsYW5jZRgEIAEoCVIKbmV3QmFsYW5jZQ==');

@$core.Deprecated('Use validateCodeRequestDescriptor instead')
const ValidateCodeRequest$json = {
  '1': 'ValidateCodeRequest',
  '2': [
    {'1': 'referral_code', '3': 1, '4': 1, '5': 9, '10': 'referralCode'},
  ],
};

/// Descriptor for `ValidateCodeRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List validateCodeRequestDescriptor = $convert.base64Decode(
    'ChNWYWxpZGF0ZUNvZGVSZXF1ZXN0EiMKDXJlZmVycmFsX2NvZGUYASABKAlSDHJlZmVycmFsQ2'
    '9kZQ==');

@$core.Deprecated('Use validateCodeResponseDescriptor instead')
const ValidateCodeResponse$json = {
  '1': 'ValidateCodeResponse',
  '2': [
    {'1': 'is_valid', '3': 1, '4': 1, '5': 8, '10': 'isValid'},
    {'1': 'referrer_name', '3': 2, '4': 1, '5': 9, '10': 'referrerName'},
    {'1': 'bonus_credits', '3': 3, '4': 1, '5': 9, '10': 'bonusCredits'},
    {'1': 'error_message', '3': 4, '4': 1, '5': 9, '10': 'errorMessage'},
  ],
};

/// Descriptor for `ValidateCodeResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List validateCodeResponseDescriptor = $convert.base64Decode(
    'ChRWYWxpZGF0ZUNvZGVSZXNwb25zZRIZCghpc192YWxpZBgBIAEoCFIHaXNWYWxpZBIjCg1yZW'
    'ZlcnJlcl9uYW1lGAIgASgJUgxyZWZlcnJlck5hbWUSIwoNYm9udXNfY3JlZGl0cxgDIAEoCVIM'
    'Ym9udXNDcmVkaXRzEiMKDWVycm9yX21lc3NhZ2UYBCABKAlSDGVycm9yTWVzc2FnZQ==');

@$core.Deprecated('Use getDashboardRequestDescriptor instead')
const GetDashboardRequest$json = {
  '1': 'GetDashboardRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
  ],
};

/// Descriptor for `GetDashboardRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getDashboardRequestDescriptor = $convert.base64Decode(
    'ChNHZXREYXNoYm9hcmRSZXF1ZXN0EiEKDHdvcmtzcGFjZV9pZBgBIAEoCVILd29ya3NwYWNlSW'
    'Q=');

@$core.Deprecated('Use getDashboardResponseDescriptor instead')
const GetDashboardResponse$json = {
  '1': 'GetDashboardResponse',
  '2': [
    {'1': 'referral_code', '3': 1, '4': 1, '5': 9, '10': 'referralCode'},
    {'1': 'share_url', '3': 2, '4': 1, '5': 9, '10': 'shareUrl'},
    {
      '1': 'funnel',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.creativanta.platform.v1.ReferralFunnel',
      '10': 'funnel'
    },
    {
      '1': 'tier',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.creativanta.platform.v1.TierProgress',
      '10': 'tier'
    },
    {
      '1': 'recent_referrals',
      '3': 5,
      '4': 3,
      '5': 11,
      '6': '.creativanta.platform.v1.ReferralRecord',
      '10': 'recentReferrals'
    },
    {
      '1': 'prompts',
      '3': 6,
      '4': 3,
      '5': 11,
      '6': '.creativanta.platform.v1.GrowthPrompt',
      '10': 'prompts'
    },
  ],
};

/// Descriptor for `GetDashboardResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getDashboardResponseDescriptor = $convert.base64Decode(
    'ChRHZXREYXNoYm9hcmRSZXNwb25zZRIjCg1yZWZlcnJhbF9jb2RlGAEgASgJUgxyZWZlcnJhbE'
    'NvZGUSGwoJc2hhcmVfdXJsGAIgASgJUghzaGFyZVVybBI/CgZmdW5uZWwYAyABKAsyJy5jcmVh'
    'dGl2YW50YS5wbGF0Zm9ybS52MS5SZWZlcnJhbEZ1bm5lbFIGZnVubmVsEjkKBHRpZXIYBCABKA'
    'syJS5jcmVhdGl2YW50YS5wbGF0Zm9ybS52MS5UaWVyUHJvZ3Jlc3NSBHRpZXISUgoQcmVjZW50'
    'X3JlZmVycmFscxgFIAMoCzInLmNyZWF0aXZhbnRhLnBsYXRmb3JtLnYxLlJlZmVycmFsUmVjb3'
    'JkUg9yZWNlbnRSZWZlcnJhbHMSPwoHcHJvbXB0cxgGIAMoCzIlLmNyZWF0aXZhbnRhLnBsYXRm'
    'b3JtLnYxLkdyb3d0aFByb21wdFIHcHJvbXB0cw==');

@$core.Deprecated('Use getReferralLinkRequestDescriptor instead')
const GetReferralLinkRequest$json = {
  '1': 'GetReferralLinkRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
  ],
};

/// Descriptor for `GetReferralLinkRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getReferralLinkRequestDescriptor =
    $convert.base64Decode(
        'ChZHZXRSZWZlcnJhbExpbmtSZXF1ZXN0EiEKDHdvcmtzcGFjZV9pZBgBIAEoCVILd29ya3NwYW'
        'NlSWQ=');

@$core.Deprecated('Use getReferralLinkResponseDescriptor instead')
const GetReferralLinkResponse$json = {
  '1': 'GetReferralLinkResponse',
  '2': [
    {'1': 'referral_code', '3': 1, '4': 1, '5': 9, '10': 'referralCode'},
    {'1': 'share_url', '3': 2, '4': 1, '5': 9, '10': 'shareUrl'},
  ],
};

/// Descriptor for `GetReferralLinkResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getReferralLinkResponseDescriptor =
    $convert.base64Decode(
        'ChdHZXRSZWZlcnJhbExpbmtSZXNwb25zZRIjCg1yZWZlcnJhbF9jb2RlGAEgASgJUgxyZWZlcn'
        'JhbENvZGUSGwoJc2hhcmVfdXJsGAIgASgJUghzaGFyZVVybA==');

@$core.Deprecated('Use getStatsRequestDescriptor instead')
const GetStatsRequest$json = {
  '1': 'GetStatsRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
  ],
};

/// Descriptor for `GetStatsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getStatsRequestDescriptor = $convert.base64Decode(
    'Cg9HZXRTdGF0c1JlcXVlc3QSIQoMd29ya3NwYWNlX2lkGAEgASgJUgt3b3Jrc3BhY2VJZA==');

@$core.Deprecated('Use getStatsResponseDescriptor instead')
const GetStatsResponse$json = {
  '1': 'GetStatsResponse',
  '2': [
    {
      '1': 'funnel',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.platform.v1.ReferralFunnel',
      '10': 'funnel'
    },
    {
      '1': 'tier',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.creativanta.platform.v1.TierProgress',
      '10': 'tier'
    },
  ],
};

/// Descriptor for `GetStatsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getStatsResponseDescriptor = $convert.base64Decode(
    'ChBHZXRTdGF0c1Jlc3BvbnNlEj8KBmZ1bm5lbBgBIAEoCzInLmNyZWF0aXZhbnRhLnBsYXRmb3'
    'JtLnYxLlJlZmVycmFsRnVubmVsUgZmdW5uZWwSOQoEdGllchgCIAEoCzIlLmNyZWF0aXZhbnRh'
    'LnBsYXRmb3JtLnYxLlRpZXJQcm9ncmVzc1IEdGllcg==');

@$core.Deprecated('Use sendReminderRequestDescriptor instead')
const SendReminderRequest$json = {
  '1': 'SendReminderRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'referral_id', '3': 2, '4': 1, '5': 9, '10': 'referralId'},
  ],
};

/// Descriptor for `SendReminderRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List sendReminderRequestDescriptor = $convert.base64Decode(
    'ChNTZW5kUmVtaW5kZXJSZXF1ZXN0EiEKDHdvcmtzcGFjZV9pZBgBIAEoCVILd29ya3NwYWNlSW'
    'QSHwoLcmVmZXJyYWxfaWQYAiABKAlSCnJlZmVycmFsSWQ=');

@$core.Deprecated('Use sendReminderResponseDescriptor instead')
const SendReminderResponse$json = {
  '1': 'SendReminderResponse',
  '2': [
    {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
    {'1': 'message', '3': 2, '4': 1, '5': 9, '10': 'message'},
  ],
};

/// Descriptor for `SendReminderResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List sendReminderResponseDescriptor = $convert.base64Decode(
    'ChRTZW5kUmVtaW5kZXJSZXNwb25zZRIYCgdzdWNjZXNzGAEgASgIUgdzdWNjZXNzEhgKB21lc3'
    'NhZ2UYAiABKAlSB21lc3NhZ2U=');

@$core.Deprecated('Use processPaymentSettlementRequestDescriptor instead')
const ProcessPaymentSettlementRequest$json = {
  '1': 'ProcessPaymentSettlementRequest',
  '2': [
    {'1': 'referral_id', '3': 1, '4': 1, '5': 9, '10': 'referralId'},
    {'1': 'payment_status', '3': 2, '4': 1, '5': 9, '10': 'paymentStatus'},
    {'1': 'plan_tier', '3': 3, '4': 1, '5': 9, '10': 'planTier'},
    {'1': 'paid_amount', '3': 4, '4': 1, '5': 9, '10': 'paidAmount'},
    {
      '1': 'payment_reference_id',
      '3': 5,
      '4': 1,
      '5': 9,
      '10': 'paymentReferenceId'
    },
    {'1': 'idempotency_key', '3': 6, '4': 1, '5': 9, '10': 'idempotencyKey'},
  ],
};

/// Descriptor for `ProcessPaymentSettlementRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List processPaymentSettlementRequestDescriptor = $convert.base64Decode(
    'Ch9Qcm9jZXNzUGF5bWVudFNldHRsZW1lbnRSZXF1ZXN0Eh8KC3JlZmVycmFsX2lkGAEgASgJUg'
    'pyZWZlcnJhbElkEiUKDnBheW1lbnRfc3RhdHVzGAIgASgJUg1wYXltZW50U3RhdHVzEhsKCXBs'
    'YW5fdGllchgDIAEoCVIIcGxhblRpZXISHwoLcGFpZF9hbW91bnQYBCABKAlSCnBhaWRBbW91bn'
    'QSMAoUcGF5bWVudF9yZWZlcmVuY2VfaWQYBSABKAlSEnBheW1lbnRSZWZlcmVuY2VJZBInCg9p'
    'ZGVtcG90ZW5jeV9rZXkYBiABKAlSDmlkZW1wb3RlbmN5S2V5');

@$core.Deprecated('Use processPaymentSettlementResponseDescriptor instead')
const ProcessPaymentSettlementResponse$json = {
  '1': 'ProcessPaymentSettlementResponse',
  '2': [
    {'1': 'qualified', '3': 1, '4': 1, '5': 8, '10': 'qualified'},
    {
      '1': 'status',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.creativanta.platform.v1.ReferralStatus',
      '10': 'status'
    },
    {'1': 'credits_awarded', '3': 3, '4': 1, '5': 9, '10': 'creditsAwarded'},
    {'1': 'message', '3': 4, '4': 1, '5': 9, '10': 'message'},
  ],
};

/// Descriptor for `ProcessPaymentSettlementResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List processPaymentSettlementResponseDescriptor =
    $convert.base64Decode(
        'CiBQcm9jZXNzUGF5bWVudFNldHRsZW1lbnRSZXNwb25zZRIcCglxdWFsaWZpZWQYASABKAhSCX'
        'F1YWxpZmllZBI/CgZzdGF0dXMYAiABKA4yJy5jcmVhdGl2YW50YS5wbGF0Zm9ybS52MS5SZWZl'
        'cnJhbFN0YXR1c1IGc3RhdHVzEicKD2NyZWRpdHNfYXdhcmRlZBgDIAEoCVIOY3JlZGl0c0F3YX'
        'JkZWQSGAoHbWVzc2FnZRgEIAEoCVIHbWVzc2FnZQ==');

@$core.Deprecated('Use processRefundReversalRequestDescriptor instead')
const ProcessRefundReversalRequest$json = {
  '1': 'ProcessRefundReversalRequest',
  '2': [
    {'1': 'referral_id', '3': 1, '4': 1, '5': 9, '10': 'referralId'},
    {'1': 'refund_reason', '3': 2, '4': 1, '5': 9, '10': 'refundReason'},
    {
      '1': 'refund_reference_id',
      '3': 3,
      '4': 1,
      '5': 9,
      '10': 'refundReferenceId'
    },
    {'1': 'idempotency_key', '3': 4, '4': 1, '5': 9, '10': 'idempotencyKey'},
  ],
};

/// Descriptor for `ProcessRefundReversalRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List processRefundReversalRequestDescriptor = $convert.base64Decode(
    'ChxQcm9jZXNzUmVmdW5kUmV2ZXJzYWxSZXF1ZXN0Eh8KC3JlZmVycmFsX2lkGAEgASgJUgpyZW'
    'ZlcnJhbElkEiMKDXJlZnVuZF9yZWFzb24YAiABKAlSDHJlZnVuZFJlYXNvbhIuChNyZWZ1bmRf'
    'cmVmZXJlbmNlX2lkGAMgASgJUhFyZWZ1bmRSZWZlcmVuY2VJZBInCg9pZGVtcG90ZW5jeV9rZX'
    'kYBCABKAlSDmlkZW1wb3RlbmN5S2V5');

@$core.Deprecated('Use processRefundReversalResponseDescriptor instead')
const ProcessRefundReversalResponse$json = {
  '1': 'ProcessRefundReversalResponse',
  '2': [
    {'1': 'reversed', '3': 1, '4': 1, '5': 8, '10': 'reversed'},
    {'1': 'duplicate_replay', '3': 2, '4': 1, '5': 8, '10': 'duplicateReplay'},
    {
      '1': 'status',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.creativanta.platform.v1.ReferralStatus',
      '10': 'status'
    },
    {'1': 'credits_reversed', '3': 4, '4': 1, '5': 9, '10': 'creditsReversed'},
    {
      '1': 'reversal_transaction_id',
      '3': 5,
      '4': 1,
      '5': 9,
      '10': 'reversalTransactionId'
    },
  ],
};

/// Descriptor for `ProcessRefundReversalResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List processRefundReversalResponseDescriptor = $convert.base64Decode(
    'Ch1Qcm9jZXNzUmVmdW5kUmV2ZXJzYWxSZXNwb25zZRIaCghyZXZlcnNlZBgBIAEoCFIIcmV2ZX'
    'JzZWQSKQoQZHVwbGljYXRlX3JlcGxheRgCIAEoCFIPZHVwbGljYXRlUmVwbGF5Ej8KBnN0YXR1'
    'cxgDIAEoDjInLmNyZWF0aXZhbnRhLnBsYXRmb3JtLnYxLlJlZmVycmFsU3RhdHVzUgZzdGF0dX'
    'MSKQoQY3JlZGl0c19yZXZlcnNlZBgEIAEoCVIPY3JlZGl0c1JldmVyc2VkEjYKF3JldmVyc2Fs'
    'X3RyYW5zYWN0aW9uX2lkGAUgASgJUhVyZXZlcnNhbFRyYW5zYWN0aW9uSWQ=');

@$core.Deprecated('Use reviewFraudCaseRequestDescriptor instead')
const ReviewFraudCaseRequest$json = {
  '1': 'ReviewFraudCaseRequest',
  '2': [
    {'1': 'referral_id', '3': 1, '4': 1, '5': 9, '10': 'referralId'},
    {'1': 'admin_action', '3': 2, '4': 1, '5': 9, '10': 'adminAction'},
    {'1': 'notes', '3': 3, '4': 1, '5': 9, '10': 'notes'},
  ],
};

/// Descriptor for `ReviewFraudCaseRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List reviewFraudCaseRequestDescriptor = $convert.base64Decode(
    'ChZSZXZpZXdGcmF1ZENhc2VSZXF1ZXN0Eh8KC3JlZmVycmFsX2lkGAEgASgJUgpyZWZlcnJhbE'
    'lkEiEKDGFkbWluX2FjdGlvbhgCIAEoCVILYWRtaW5BY3Rpb24SFAoFbm90ZXMYAyABKAlSBW5v'
    'dGVz');

@$core.Deprecated('Use reviewFraudCaseResponseDescriptor instead')
const ReviewFraudCaseResponse$json = {
  '1': 'ReviewFraudCaseResponse',
  '2': [
    {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
    {
      '1': 'status',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.creativanta.platform.v1.ReferralStatus',
      '10': 'status'
    },
    {
      '1': 'resolution_action',
      '3': 3,
      '4': 1,
      '5': 9,
      '10': 'resolutionAction'
    },
  ],
};

/// Descriptor for `ReviewFraudCaseResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List reviewFraudCaseResponseDescriptor = $convert.base64Decode(
    'ChdSZXZpZXdGcmF1ZENhc2VSZXNwb25zZRIYCgdzdWNjZXNzGAEgASgIUgdzdWNjZXNzEj8KBn'
    'N0YXR1cxgCIAEoDjInLmNyZWF0aXZhbnRhLnBsYXRmb3JtLnYxLlJlZmVycmFsU3RhdHVzUgZz'
    'dGF0dXMSKwoRcmVzb2x1dGlvbl9hY3Rpb24YAyABKAlSEHJlc29sdXRpb25BY3Rpb24=');

@$core.Deprecated('Use redeemPromoCodeRequestDescriptor instead')
const RedeemPromoCodeRequest$json = {
  '1': 'RedeemPromoCodeRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
    {'1': 'promo_code', '3': 2, '4': 1, '5': 9, '10': 'promoCode'},
    {'1': 'idempotency_key', '3': 3, '4': 1, '5': 9, '10': 'idempotencyKey'},
  ],
};

/// Descriptor for `RedeemPromoCodeRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List redeemPromoCodeRequestDescriptor = $convert.base64Decode(
    'ChZSZWRlZW1Qcm9tb0NvZGVSZXF1ZXN0EiEKDHdvcmtzcGFjZV9pZBgBIAEoCVILd29ya3NwYW'
    'NlSWQSHQoKcHJvbW9fY29kZRgCIAEoCVIJcHJvbW9Db2RlEicKD2lkZW1wb3RlbmN5X2tleRgD'
    'IAEoCVIOaWRlbXBvdGVuY3lLZXk=');

@$core.Deprecated('Use redeemPromoCodeResponseDescriptor instead')
const RedeemPromoCodeResponse$json = {
  '1': 'RedeemPromoCodeResponse',
  '2': [
    {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
    {'1': 'credits_awarded', '3': 2, '4': 1, '5': 9, '10': 'creditsAwarded'},
    {'1': 'new_balance', '3': 3, '4': 1, '5': 9, '10': 'newBalance'},
    {'1': 'transaction_id', '3': 4, '4': 1, '5': 9, '10': 'transactionId'},
  ],
};

/// Descriptor for `RedeemPromoCodeResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List redeemPromoCodeResponseDescriptor = $convert.base64Decode(
    'ChdSZWRlZW1Qcm9tb0NvZGVSZXNwb25zZRIYCgdzdWNjZXNzGAEgASgIUgdzdWNjZXNzEicKD2'
    'NyZWRpdHNfYXdhcmRlZBgCIAEoCVIOY3JlZGl0c0F3YXJkZWQSHwoLbmV3X2JhbGFuY2UYAyAB'
    'KAlSCm5ld0JhbGFuY2USJQoOdHJhbnNhY3Rpb25faWQYBCABKAlSDXRyYW5zYWN0aW9uSWQ=');

@$core.Deprecated('Use getActivePromotionsRequestDescriptor instead')
const GetActivePromotionsRequest$json = {
  '1': 'GetActivePromotionsRequest',
  '2': [
    {'1': 'workspace_id', '3': 1, '4': 1, '5': 9, '10': 'workspaceId'},
  ],
};

/// Descriptor for `GetActivePromotionsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getActivePromotionsRequestDescriptor =
    $convert.base64Decode(
        'ChpHZXRBY3RpdmVQcm9tb3Rpb25zUmVxdWVzdBIhCgx3b3Jrc3BhY2VfaWQYASABKAlSC3dvcm'
        'tzcGFjZUlk');

@$core.Deprecated('Use getActivePromotionsResponseDescriptor instead')
const GetActivePromotionsResponse$json = {
  '1': 'GetActivePromotionsResponse',
  '2': [
    {
      '1': 'campaigns',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.creativanta.platform.v1.PromotionalCampaign',
      '10': 'campaigns'
    },
  ],
};

/// Descriptor for `GetActivePromotionsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getActivePromotionsResponseDescriptor =
    $convert.base64Decode(
        'ChtHZXRBY3RpdmVQcm9tb3Rpb25zUmVzcG9uc2USSgoJY2FtcGFpZ25zGAEgAygLMiwuY3JlYX'
        'RpdmFudGEucGxhdGZvcm0udjEuUHJvbW90aW9uYWxDYW1wYWlnblIJY2FtcGFpZ25z');

@$core.Deprecated('Use getPromotionDetailRequestDescriptor instead')
const GetPromotionDetailRequest$json = {
  '1': 'GetPromotionDetailRequest',
  '2': [
    {'1': 'campaign_id', '3': 1, '4': 1, '5': 9, '10': 'campaignId'},
  ],
};

/// Descriptor for `GetPromotionDetailRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getPromotionDetailRequestDescriptor =
    $convert.base64Decode(
        'ChlHZXRQcm9tb3Rpb25EZXRhaWxSZXF1ZXN0Eh8KC2NhbXBhaWduX2lkGAEgASgJUgpjYW1wYW'
        'lnbklk');

@$core.Deprecated('Use getPromotionDetailResponseDescriptor instead')
const GetPromotionDetailResponse$json = {
  '1': 'GetPromotionDetailResponse',
  '2': [
    {
      '1': 'campaign',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.creativanta.platform.v1.PromotionalCampaign',
      '10': 'campaign'
    },
    {'1': 'is_eligible', '3': 2, '4': 1, '5': 8, '10': 'isEligible'},
  ],
};

/// Descriptor for `GetPromotionDetailResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getPromotionDetailResponseDescriptor =
    $convert.base64Decode(
        'ChpHZXRQcm9tb3Rpb25EZXRhaWxSZXNwb25zZRJICghjYW1wYWlnbhgBIAEoCzIsLmNyZWF0aX'
        'ZhbnRhLnBsYXRmb3JtLnYxLlByb21vdGlvbmFsQ2FtcGFpZ25SCGNhbXBhaWduEh8KC2lzX2Vs'
        'aWdpYmxlGAIgASgIUgppc0VsaWdpYmxl');

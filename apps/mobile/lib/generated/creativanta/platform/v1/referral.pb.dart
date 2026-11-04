// This is a generated file - do not edit.
//
// Generated from creativanta/platform/v1/referral.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;
import 'package:protobuf/well_known_types/google/protobuf/timestamp.pb.dart'
    as $1;

import '../../common/v1/types.pb.dart' as $2;
import 'referral.pbenum.dart';

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'referral.pbenum.dart';

class ReferralRecord extends $pb.GeneratedMessage {
  factory ReferralRecord({
    $core.String? referralId,
    $core.String? workspaceId,
    $core.String? refereeWorkspaceId,
    $core.String? referrerUserId,
    $core.String? refereeUserId,
    $core.String? refereeName,
    $core.String? refereeEmailMasked,
    $core.String? referralCode,
    ReferralStatus? status,
    $core.String? referrerCreditsAwarded,
    $core.String? refereeCreditsAwarded,
    $core.String? planTier,
    $core.String? paymentStatus,
    $core.bool? fraudCheckPassed,
    $core.String? fraudReason,
    $core.String? recurringCommissionRate,
    $core.String? recurringCommissionEarned,
    $1.Timestamp? qualifiedAt,
    $1.Timestamp? rewardedAt,
    $1.Timestamp? createdAt,
    $1.Timestamp? updatedAt,
  }) {
    final result = ReferralRecord._();
    if (referralId != null) result.referralId = referralId;
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (refereeWorkspaceId != null)
      result.refereeWorkspaceId = refereeWorkspaceId;
    if (referrerUserId != null) result.referrerUserId = referrerUserId;
    if (refereeUserId != null) result.refereeUserId = refereeUserId;
    if (refereeName != null) result.refereeName = refereeName;
    if (refereeEmailMasked != null)
      result.refereeEmailMasked = refereeEmailMasked;
    if (referralCode != null) result.referralCode = referralCode;
    if (status != null) result.status = status;
    if (referrerCreditsAwarded != null)
      result.referrerCreditsAwarded = referrerCreditsAwarded;
    if (refereeCreditsAwarded != null)
      result.refereeCreditsAwarded = refereeCreditsAwarded;
    if (planTier != null) result.planTier = planTier;
    if (paymentStatus != null) result.paymentStatus = paymentStatus;
    if (fraudCheckPassed != null) result.fraudCheckPassed = fraudCheckPassed;
    if (fraudReason != null) result.fraudReason = fraudReason;
    if (recurringCommissionRate != null)
      result.recurringCommissionRate = recurringCommissionRate;
    if (recurringCommissionEarned != null)
      result.recurringCommissionEarned = recurringCommissionEarned;
    if (qualifiedAt != null) result.qualifiedAt = qualifiedAt;
    if (rewardedAt != null) result.rewardedAt = rewardedAt;
    if (createdAt != null) result.createdAt = createdAt;
    if (updatedAt != null) result.updatedAt = updatedAt;
    return result;
  }

  ReferralRecord._();

  factory ReferralRecord.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ReferralRecord()..mergeFromBuffer(data, registry);
  factory ReferralRecord.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ReferralRecord()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ReferralRecord',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.platform.v1'),
      createEmptyInstance: ReferralRecord.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'referralId')
    ..aOS(2, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(3, _omitFieldNames ? '' : 'refereeWorkspaceId')
    ..aOS(4, _omitFieldNames ? '' : 'referrerUserId')
    ..aOS(5, _omitFieldNames ? '' : 'refereeUserId')
    ..aOS(6, _omitFieldNames ? '' : 'refereeName')
    ..aOS(7, _omitFieldNames ? '' : 'refereeEmailMasked')
    ..aOS(8, _omitFieldNames ? '' : 'referralCode')
    ..aE<ReferralStatus>(9, _omitFieldNames ? '' : 'status',
        enumValues: ReferralStatus.values)
    ..aOS(10, _omitFieldNames ? '' : 'referrerCreditsAwarded')
    ..aOS(11, _omitFieldNames ? '' : 'refereeCreditsAwarded')
    ..aOS(12, _omitFieldNames ? '' : 'planTier')
    ..aOS(13, _omitFieldNames ? '' : 'paymentStatus')
    ..aOB(14, _omitFieldNames ? '' : 'fraudCheckPassed')
    ..aOS(15, _omitFieldNames ? '' : 'fraudReason')
    ..aOS(16, _omitFieldNames ? '' : 'recurringCommissionRate')
    ..aOS(17, _omitFieldNames ? '' : 'recurringCommissionEarned')
    ..aOM<$1.Timestamp>(18, _omitFieldNames ? '' : 'qualifiedAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..aOM<$1.Timestamp>(19, _omitFieldNames ? '' : 'rewardedAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..aOM<$1.Timestamp>(20, _omitFieldNames ? '' : 'createdAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..aOM<$1.Timestamp>(21, _omitFieldNames ? '' : 'updatedAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReferralRecord clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReferralRecord copyWith(void Function(ReferralRecord) updates) =>
      super.copyWith((message) => updates(message as ReferralRecord))
          as ReferralRecord;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ReferralRecord() / ReferralRecord.new instead')
  static ReferralRecord create() => ReferralRecord._();
  static $pb.GeneratedMessage $_createMessage() => ReferralRecord._();
  @$core.override
  ReferralRecord createEmptyInstance() => ReferralRecord._();
  @$core.pragma('dart2js:noInline')
  static ReferralRecord getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ReferralRecord>(
          ReferralRecord.$_createMessage);
  static ReferralRecord? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get referralId => $_getSZ(0);
  @$pb.TagNumber(1)
  set referralId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasReferralId() => $_has(0);
  @$pb.TagNumber(1)
  void clearReferralId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get workspaceId => $_getSZ(1);
  @$pb.TagNumber(2)
  set workspaceId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasWorkspaceId() => $_has(1);
  @$pb.TagNumber(2)
  void clearWorkspaceId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get refereeWorkspaceId => $_getSZ(2);
  @$pb.TagNumber(3)
  set refereeWorkspaceId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasRefereeWorkspaceId() => $_has(2);
  @$pb.TagNumber(3)
  void clearRefereeWorkspaceId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get referrerUserId => $_getSZ(3);
  @$pb.TagNumber(4)
  set referrerUserId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasReferrerUserId() => $_has(3);
  @$pb.TagNumber(4)
  void clearReferrerUserId() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get refereeUserId => $_getSZ(4);
  @$pb.TagNumber(5)
  set refereeUserId($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasRefereeUserId() => $_has(4);
  @$pb.TagNumber(5)
  void clearRefereeUserId() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get refereeName => $_getSZ(5);
  @$pb.TagNumber(6)
  set refereeName($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasRefereeName() => $_has(5);
  @$pb.TagNumber(6)
  void clearRefereeName() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get refereeEmailMasked => $_getSZ(6);
  @$pb.TagNumber(7)
  set refereeEmailMasked($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasRefereeEmailMasked() => $_has(6);
  @$pb.TagNumber(7)
  void clearRefereeEmailMasked() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get referralCode => $_getSZ(7);
  @$pb.TagNumber(8)
  set referralCode($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasReferralCode() => $_has(7);
  @$pb.TagNumber(8)
  void clearReferralCode() => $_clearField(8);

  @$pb.TagNumber(9)
  ReferralStatus get status => $_getN(8);
  @$pb.TagNumber(9)
  set status(ReferralStatus value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasStatus() => $_has(8);
  @$pb.TagNumber(9)
  void clearStatus() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.String get referrerCreditsAwarded => $_getSZ(9);
  @$pb.TagNumber(10)
  set referrerCreditsAwarded($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasReferrerCreditsAwarded() => $_has(9);
  @$pb.TagNumber(10)
  void clearReferrerCreditsAwarded() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.String get refereeCreditsAwarded => $_getSZ(10);
  @$pb.TagNumber(11)
  set refereeCreditsAwarded($core.String value) => $_setString(10, value);
  @$pb.TagNumber(11)
  $core.bool hasRefereeCreditsAwarded() => $_has(10);
  @$pb.TagNumber(11)
  void clearRefereeCreditsAwarded() => $_clearField(11);

  @$pb.TagNumber(12)
  $core.String get planTier => $_getSZ(11);
  @$pb.TagNumber(12)
  set planTier($core.String value) => $_setString(11, value);
  @$pb.TagNumber(12)
  $core.bool hasPlanTier() => $_has(11);
  @$pb.TagNumber(12)
  void clearPlanTier() => $_clearField(12);

  @$pb.TagNumber(13)
  $core.String get paymentStatus => $_getSZ(12);
  @$pb.TagNumber(13)
  set paymentStatus($core.String value) => $_setString(12, value);
  @$pb.TagNumber(13)
  $core.bool hasPaymentStatus() => $_has(12);
  @$pb.TagNumber(13)
  void clearPaymentStatus() => $_clearField(13);

  @$pb.TagNumber(14)
  $core.bool get fraudCheckPassed => $_getBF(13);
  @$pb.TagNumber(14)
  set fraudCheckPassed($core.bool value) => $_setBool(13, value);
  @$pb.TagNumber(14)
  $core.bool hasFraudCheckPassed() => $_has(13);
  @$pb.TagNumber(14)
  void clearFraudCheckPassed() => $_clearField(14);

  @$pb.TagNumber(15)
  $core.String get fraudReason => $_getSZ(14);
  @$pb.TagNumber(15)
  set fraudReason($core.String value) => $_setString(14, value);
  @$pb.TagNumber(15)
  $core.bool hasFraudReason() => $_has(14);
  @$pb.TagNumber(15)
  void clearFraudReason() => $_clearField(15);

  @$pb.TagNumber(16)
  $core.String get recurringCommissionRate => $_getSZ(15);
  @$pb.TagNumber(16)
  set recurringCommissionRate($core.String value) => $_setString(15, value);
  @$pb.TagNumber(16)
  $core.bool hasRecurringCommissionRate() => $_has(15);
  @$pb.TagNumber(16)
  void clearRecurringCommissionRate() => $_clearField(16);

  @$pb.TagNumber(17)
  $core.String get recurringCommissionEarned => $_getSZ(16);
  @$pb.TagNumber(17)
  set recurringCommissionEarned($core.String value) => $_setString(16, value);
  @$pb.TagNumber(17)
  $core.bool hasRecurringCommissionEarned() => $_has(16);
  @$pb.TagNumber(17)
  void clearRecurringCommissionEarned() => $_clearField(17);

  @$pb.TagNumber(18)
  $1.Timestamp get qualifiedAt => $_getN(17);
  @$pb.TagNumber(18)
  set qualifiedAt($1.Timestamp value) => $_setField(18, value);
  @$pb.TagNumber(18)
  $core.bool hasQualifiedAt() => $_has(17);
  @$pb.TagNumber(18)
  void clearQualifiedAt() => $_clearField(18);
  @$pb.TagNumber(18)
  $1.Timestamp ensureQualifiedAt() => $_ensure(17);

  @$pb.TagNumber(19)
  $1.Timestamp get rewardedAt => $_getN(18);
  @$pb.TagNumber(19)
  set rewardedAt($1.Timestamp value) => $_setField(19, value);
  @$pb.TagNumber(19)
  $core.bool hasRewardedAt() => $_has(18);
  @$pb.TagNumber(19)
  void clearRewardedAt() => $_clearField(19);
  @$pb.TagNumber(19)
  $1.Timestamp ensureRewardedAt() => $_ensure(18);

  @$pb.TagNumber(20)
  $1.Timestamp get createdAt => $_getN(19);
  @$pb.TagNumber(20)
  set createdAt($1.Timestamp value) => $_setField(20, value);
  @$pb.TagNumber(20)
  $core.bool hasCreatedAt() => $_has(19);
  @$pb.TagNumber(20)
  void clearCreatedAt() => $_clearField(20);
  @$pb.TagNumber(20)
  $1.Timestamp ensureCreatedAt() => $_ensure(19);

  @$pb.TagNumber(21)
  $1.Timestamp get updatedAt => $_getN(20);
  @$pb.TagNumber(21)
  set updatedAt($1.Timestamp value) => $_setField(21, value);
  @$pb.TagNumber(21)
  $core.bool hasUpdatedAt() => $_has(20);
  @$pb.TagNumber(21)
  void clearUpdatedAt() => $_clearField(21);
  @$pb.TagNumber(21)
  $1.Timestamp ensureUpdatedAt() => $_ensure(20);
}

class ReferralFunnel extends $pb.GeneratedMessage {
  factory ReferralFunnel({
    $fixnum.Int64? totalClicks,
    $fixnum.Int64? totalSignups,
    $fixnum.Int64? totalPaid,
    $core.double? clickToSignupRate,
    $core.double? signupToPaidRate,
    $core.String? creditsEarnedTotal,
    $core.String? creditsPendingTotal,
  }) {
    final result = ReferralFunnel._();
    if (totalClicks != null) result.totalClicks = totalClicks;
    if (totalSignups != null) result.totalSignups = totalSignups;
    if (totalPaid != null) result.totalPaid = totalPaid;
    if (clickToSignupRate != null) result.clickToSignupRate = clickToSignupRate;
    if (signupToPaidRate != null) result.signupToPaidRate = signupToPaidRate;
    if (creditsEarnedTotal != null)
      result.creditsEarnedTotal = creditsEarnedTotal;
    if (creditsPendingTotal != null)
      result.creditsPendingTotal = creditsPendingTotal;
    return result;
  }

  ReferralFunnel._();

  factory ReferralFunnel.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ReferralFunnel()..mergeFromBuffer(data, registry);
  factory ReferralFunnel.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ReferralFunnel()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ReferralFunnel',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.platform.v1'),
      createEmptyInstance: ReferralFunnel.$_createMessage)
    ..aInt64(1, _omitFieldNames ? '' : 'totalClicks')
    ..aInt64(2, _omitFieldNames ? '' : 'totalSignups')
    ..aInt64(3, _omitFieldNames ? '' : 'totalPaid')
    ..aD(4, _omitFieldNames ? '' : 'clickToSignupRate')
    ..aD(5, _omitFieldNames ? '' : 'signupToPaidRate')
    ..aOS(6, _omitFieldNames ? '' : 'creditsEarnedTotal')
    ..aOS(7, _omitFieldNames ? '' : 'creditsPendingTotal')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReferralFunnel clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReferralFunnel copyWith(void Function(ReferralFunnel) updates) =>
      super.copyWith((message) => updates(message as ReferralFunnel))
          as ReferralFunnel;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ReferralFunnel() / ReferralFunnel.new instead')
  static ReferralFunnel create() => ReferralFunnel._();
  static $pb.GeneratedMessage $_createMessage() => ReferralFunnel._();
  @$core.override
  ReferralFunnel createEmptyInstance() => ReferralFunnel._();
  @$core.pragma('dart2js:noInline')
  static ReferralFunnel getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ReferralFunnel>(
          ReferralFunnel.$_createMessage);
  static ReferralFunnel? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get totalClicks => $_getI64(0);
  @$pb.TagNumber(1)
  set totalClicks($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTotalClicks() => $_has(0);
  @$pb.TagNumber(1)
  void clearTotalClicks() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get totalSignups => $_getI64(1);
  @$pb.TagNumber(2)
  set totalSignups($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTotalSignups() => $_has(1);
  @$pb.TagNumber(2)
  void clearTotalSignups() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get totalPaid => $_getI64(2);
  @$pb.TagNumber(3)
  set totalPaid($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasTotalPaid() => $_has(2);
  @$pb.TagNumber(3)
  void clearTotalPaid() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.double get clickToSignupRate => $_getN(3);
  @$pb.TagNumber(4)
  set clickToSignupRate($core.double value) => $_setDouble(3, value);
  @$pb.TagNumber(4)
  $core.bool hasClickToSignupRate() => $_has(3);
  @$pb.TagNumber(4)
  void clearClickToSignupRate() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.double get signupToPaidRate => $_getN(4);
  @$pb.TagNumber(5)
  set signupToPaidRate($core.double value) => $_setDouble(4, value);
  @$pb.TagNumber(5)
  $core.bool hasSignupToPaidRate() => $_has(4);
  @$pb.TagNumber(5)
  void clearSignupToPaidRate() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get creditsEarnedTotal => $_getSZ(5);
  @$pb.TagNumber(6)
  set creditsEarnedTotal($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasCreditsEarnedTotal() => $_has(5);
  @$pb.TagNumber(6)
  void clearCreditsEarnedTotal() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get creditsPendingTotal => $_getSZ(6);
  @$pb.TagNumber(7)
  set creditsPendingTotal($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasCreditsPendingTotal() => $_has(6);
  @$pb.TagNumber(7)
  void clearCreditsPendingTotal() => $_clearField(7);
}

class TierProgress extends $pb.GeneratedMessage {
  factory TierProgress({
    ReferralTier? currentTier,
    ReferralTier? nextTier,
    $core.int? qualifiedReferralsCount,
    $core.int? referralsToNextTier,
    $core.double? progressPercentage,
    $core.String? currentRewardMultiplier,
    $core.String? recurringCommissionRate,
  }) {
    final result = TierProgress._();
    if (currentTier != null) result.currentTier = currentTier;
    if (nextTier != null) result.nextTier = nextTier;
    if (qualifiedReferralsCount != null)
      result.qualifiedReferralsCount = qualifiedReferralsCount;
    if (referralsToNextTier != null)
      result.referralsToNextTier = referralsToNextTier;
    if (progressPercentage != null)
      result.progressPercentage = progressPercentage;
    if (currentRewardMultiplier != null)
      result.currentRewardMultiplier = currentRewardMultiplier;
    if (recurringCommissionRate != null)
      result.recurringCommissionRate = recurringCommissionRate;
    return result;
  }

  TierProgress._();

  factory TierProgress.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      TierProgress()..mergeFromBuffer(data, registry);
  factory TierProgress.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      TierProgress()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TierProgress',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.platform.v1'),
      createEmptyInstance: TierProgress.$_createMessage)
    ..aE<ReferralTier>(1, _omitFieldNames ? '' : 'currentTier',
        enumValues: ReferralTier.values)
    ..aE<ReferralTier>(2, _omitFieldNames ? '' : 'nextTier',
        enumValues: ReferralTier.values)
    ..aI(3, _omitFieldNames ? '' : 'qualifiedReferralsCount')
    ..aI(4, _omitFieldNames ? '' : 'referralsToNextTier')
    ..aD(5, _omitFieldNames ? '' : 'progressPercentage')
    ..aOS(6, _omitFieldNames ? '' : 'currentRewardMultiplier')
    ..aOS(7, _omitFieldNames ? '' : 'recurringCommissionRate')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TierProgress clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TierProgress copyWith(void Function(TierProgress) updates) =>
      super.copyWith((message) => updates(message as TierProgress))
          as TierProgress;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use TierProgress() / TierProgress.new instead')
  static TierProgress create() => TierProgress._();
  static $pb.GeneratedMessage $_createMessage() => TierProgress._();
  @$core.override
  TierProgress createEmptyInstance() => TierProgress._();
  @$core.pragma('dart2js:noInline')
  static TierProgress getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<TierProgress>(
          TierProgress.$_createMessage);
  static TierProgress? _defaultInstance;

  @$pb.TagNumber(1)
  ReferralTier get currentTier => $_getN(0);
  @$pb.TagNumber(1)
  set currentTier(ReferralTier value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasCurrentTier() => $_has(0);
  @$pb.TagNumber(1)
  void clearCurrentTier() => $_clearField(1);

  @$pb.TagNumber(2)
  ReferralTier get nextTier => $_getN(1);
  @$pb.TagNumber(2)
  set nextTier(ReferralTier value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasNextTier() => $_has(1);
  @$pb.TagNumber(2)
  void clearNextTier() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get qualifiedReferralsCount => $_getIZ(2);
  @$pb.TagNumber(3)
  set qualifiedReferralsCount($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasQualifiedReferralsCount() => $_has(2);
  @$pb.TagNumber(3)
  void clearQualifiedReferralsCount() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get referralsToNextTier => $_getIZ(3);
  @$pb.TagNumber(4)
  set referralsToNextTier($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasReferralsToNextTier() => $_has(3);
  @$pb.TagNumber(4)
  void clearReferralsToNextTier() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.double get progressPercentage => $_getN(4);
  @$pb.TagNumber(5)
  set progressPercentage($core.double value) => $_setDouble(4, value);
  @$pb.TagNumber(5)
  $core.bool hasProgressPercentage() => $_has(4);
  @$pb.TagNumber(5)
  void clearProgressPercentage() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get currentRewardMultiplier => $_getSZ(5);
  @$pb.TagNumber(6)
  set currentRewardMultiplier($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasCurrentRewardMultiplier() => $_has(5);
  @$pb.TagNumber(6)
  void clearCurrentRewardMultiplier() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get recurringCommissionRate => $_getSZ(6);
  @$pb.TagNumber(7)
  set recurringCommissionRate($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasRecurringCommissionRate() => $_has(6);
  @$pb.TagNumber(7)
  void clearRecurringCommissionRate() => $_clearField(7);
}

class GrowthPrompt extends $pb.GeneratedMessage {
  factory GrowthPrompt({
    $core.String? promptId,
    GrowthTriggerType? triggerType,
    $core.String? title,
    $core.String? description,
    $core.String? creditReward,
    $core.String? shareUrl,
    $core.bool? isCompleted,
  }) {
    final result = GrowthPrompt._();
    if (promptId != null) result.promptId = promptId;
    if (triggerType != null) result.triggerType = triggerType;
    if (title != null) result.title = title;
    if (description != null) result.description = description;
    if (creditReward != null) result.creditReward = creditReward;
    if (shareUrl != null) result.shareUrl = shareUrl;
    if (isCompleted != null) result.isCompleted = isCompleted;
    return result;
  }

  GrowthPrompt._();

  factory GrowthPrompt.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GrowthPrompt()..mergeFromBuffer(data, registry);
  factory GrowthPrompt.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GrowthPrompt()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GrowthPrompt',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.platform.v1'),
      createEmptyInstance: GrowthPrompt.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'promptId')
    ..aE<GrowthTriggerType>(2, _omitFieldNames ? '' : 'triggerType',
        enumValues: GrowthTriggerType.values)
    ..aOS(3, _omitFieldNames ? '' : 'title')
    ..aOS(4, _omitFieldNames ? '' : 'description')
    ..aOS(5, _omitFieldNames ? '' : 'creditReward')
    ..aOS(6, _omitFieldNames ? '' : 'shareUrl')
    ..aOB(7, _omitFieldNames ? '' : 'isCompleted')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GrowthPrompt clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GrowthPrompt copyWith(void Function(GrowthPrompt) updates) =>
      super.copyWith((message) => updates(message as GrowthPrompt))
          as GrowthPrompt;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use GrowthPrompt() / GrowthPrompt.new instead')
  static GrowthPrompt create() => GrowthPrompt._();
  static $pb.GeneratedMessage $_createMessage() => GrowthPrompt._();
  @$core.override
  GrowthPrompt createEmptyInstance() => GrowthPrompt._();
  @$core.pragma('dart2js:noInline')
  static GrowthPrompt getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GrowthPrompt>(
          GrowthPrompt.$_createMessage);
  static GrowthPrompt? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get promptId => $_getSZ(0);
  @$pb.TagNumber(1)
  set promptId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPromptId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPromptId() => $_clearField(1);

  @$pb.TagNumber(2)
  GrowthTriggerType get triggerType => $_getN(1);
  @$pb.TagNumber(2)
  set triggerType(GrowthTriggerType value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasTriggerType() => $_has(1);
  @$pb.TagNumber(2)
  void clearTriggerType() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get title => $_getSZ(2);
  @$pb.TagNumber(3)
  set title($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasTitle() => $_has(2);
  @$pb.TagNumber(3)
  void clearTitle() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get description => $_getSZ(3);
  @$pb.TagNumber(4)
  set description($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasDescription() => $_has(3);
  @$pb.TagNumber(4)
  void clearDescription() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get creditReward => $_getSZ(4);
  @$pb.TagNumber(5)
  set creditReward($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasCreditReward() => $_has(4);
  @$pb.TagNumber(5)
  void clearCreditReward() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get shareUrl => $_getSZ(5);
  @$pb.TagNumber(6)
  set shareUrl($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasShareUrl() => $_has(5);
  @$pb.TagNumber(6)
  void clearShareUrl() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.bool get isCompleted => $_getBF(6);
  @$pb.TagNumber(7)
  set isCompleted($core.bool value) => $_setBool(6, value);
  @$pb.TagNumber(7)
  $core.bool hasIsCompleted() => $_has(6);
  @$pb.TagNumber(7)
  void clearIsCompleted() => $_clearField(7);
}

class PromotionalCampaign extends $pb.GeneratedMessage {
  factory PromotionalCampaign({
    $core.String? campaignId,
    $core.String? code,
    $core.String? title,
    $core.String? description,
    $core.String? creditBonus,
    $1.Timestamp? expiresAt,
    $core.bool? isActive,
  }) {
    final result = PromotionalCampaign._();
    if (campaignId != null) result.campaignId = campaignId;
    if (code != null) result.code = code;
    if (title != null) result.title = title;
    if (description != null) result.description = description;
    if (creditBonus != null) result.creditBonus = creditBonus;
    if (expiresAt != null) result.expiresAt = expiresAt;
    if (isActive != null) result.isActive = isActive;
    return result;
  }

  PromotionalCampaign._();

  factory PromotionalCampaign.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PromotionalCampaign()..mergeFromBuffer(data, registry);
  factory PromotionalCampaign.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      PromotionalCampaign()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PromotionalCampaign',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.platform.v1'),
      createEmptyInstance: PromotionalCampaign.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'campaignId')
    ..aOS(2, _omitFieldNames ? '' : 'code')
    ..aOS(3, _omitFieldNames ? '' : 'title')
    ..aOS(4, _omitFieldNames ? '' : 'description')
    ..aOS(5, _omitFieldNames ? '' : 'creditBonus')
    ..aOM<$1.Timestamp>(6, _omitFieldNames ? '' : 'expiresAt',
        subBuilder: $1.Timestamp.$_createMessage)
    ..aOB(7, _omitFieldNames ? '' : 'isActive')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PromotionalCampaign clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PromotionalCampaign copyWith(void Function(PromotionalCampaign) updates) =>
      super.copyWith((message) => updates(message as PromotionalCampaign))
          as PromotionalCampaign;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core
      .Deprecated('Use PromotionalCampaign() / PromotionalCampaign.new instead')
  static PromotionalCampaign create() => PromotionalCampaign._();
  static $pb.GeneratedMessage $_createMessage() => PromotionalCampaign._();
  @$core.override
  PromotionalCampaign createEmptyInstance() => PromotionalCampaign._();
  @$core.pragma('dart2js:noInline')
  static PromotionalCampaign getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PromotionalCampaign>(
          PromotionalCampaign.$_createMessage);
  static PromotionalCampaign? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get campaignId => $_getSZ(0);
  @$pb.TagNumber(1)
  set campaignId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCampaignId() => $_has(0);
  @$pb.TagNumber(1)
  void clearCampaignId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get code => $_getSZ(1);
  @$pb.TagNumber(2)
  set code($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCode() => $_has(1);
  @$pb.TagNumber(2)
  void clearCode() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get title => $_getSZ(2);
  @$pb.TagNumber(3)
  set title($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasTitle() => $_has(2);
  @$pb.TagNumber(3)
  void clearTitle() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get description => $_getSZ(3);
  @$pb.TagNumber(4)
  set description($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasDescription() => $_has(3);
  @$pb.TagNumber(4)
  void clearDescription() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get creditBonus => $_getSZ(4);
  @$pb.TagNumber(5)
  set creditBonus($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasCreditBonus() => $_has(4);
  @$pb.TagNumber(5)
  void clearCreditBonus() => $_clearField(5);

  @$pb.TagNumber(6)
  $1.Timestamp get expiresAt => $_getN(5);
  @$pb.TagNumber(6)
  set expiresAt($1.Timestamp value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasExpiresAt() => $_has(5);
  @$pb.TagNumber(6)
  void clearExpiresAt() => $_clearField(6);
  @$pb.TagNumber(6)
  $1.Timestamp ensureExpiresAt() => $_ensure(5);

  @$pb.TagNumber(7)
  $core.bool get isActive => $_getBF(6);
  @$pb.TagNumber(7)
  set isActive($core.bool value) => $_setBool(6, value);
  @$pb.TagNumber(7)
  $core.bool hasIsActive() => $_has(6);
  @$pb.TagNumber(7)
  void clearIsActive() => $_clearField(7);
}

class GetMyReferralCodeRequest extends $pb.GeneratedMessage {
  factory GetMyReferralCodeRequest({
    $core.String? workspaceId,
  }) {
    final result = GetMyReferralCodeRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    return result;
  }

  GetMyReferralCodeRequest._();

  factory GetMyReferralCodeRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetMyReferralCodeRequest()..mergeFromBuffer(data, registry);
  factory GetMyReferralCodeRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetMyReferralCodeRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetMyReferralCodeRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.platform.v1'),
      createEmptyInstance: GetMyReferralCodeRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetMyReferralCodeRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetMyReferralCodeRequest copyWith(
          void Function(GetMyReferralCodeRequest) updates) =>
      super.copyWith((message) => updates(message as GetMyReferralCodeRequest))
          as GetMyReferralCodeRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use GetMyReferralCodeRequest() / GetMyReferralCodeRequest.new instead')
  static GetMyReferralCodeRequest create() => GetMyReferralCodeRequest._();
  static $pb.GeneratedMessage $_createMessage() => GetMyReferralCodeRequest._();
  @$core.override
  GetMyReferralCodeRequest createEmptyInstance() =>
      GetMyReferralCodeRequest._();
  @$core.pragma('dart2js:noInline')
  static GetMyReferralCodeRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetMyReferralCodeRequest>(
          GetMyReferralCodeRequest.$_createMessage);
  static GetMyReferralCodeRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);
}

class GetMyReferralCodeResponse extends $pb.GeneratedMessage {
  factory GetMyReferralCodeResponse({
    $core.String? referralCode,
    $core.String? shareUrl,
    $core.String? qrCodeUrl,
    $core.String? workspaceId,
  }) {
    final result = GetMyReferralCodeResponse._();
    if (referralCode != null) result.referralCode = referralCode;
    if (shareUrl != null) result.shareUrl = shareUrl;
    if (qrCodeUrl != null) result.qrCodeUrl = qrCodeUrl;
    if (workspaceId != null) result.workspaceId = workspaceId;
    return result;
  }

  GetMyReferralCodeResponse._();

  factory GetMyReferralCodeResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetMyReferralCodeResponse()..mergeFromBuffer(data, registry);
  factory GetMyReferralCodeResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetMyReferralCodeResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetMyReferralCodeResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.platform.v1'),
      createEmptyInstance: GetMyReferralCodeResponse.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'referralCode')
    ..aOS(2, _omitFieldNames ? '' : 'shareUrl')
    ..aOS(3, _omitFieldNames ? '' : 'qrCodeUrl')
    ..aOS(4, _omitFieldNames ? '' : 'workspaceId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetMyReferralCodeResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetMyReferralCodeResponse copyWith(
          void Function(GetMyReferralCodeResponse) updates) =>
      super.copyWith((message) => updates(message as GetMyReferralCodeResponse))
          as GetMyReferralCodeResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use GetMyReferralCodeResponse() / GetMyReferralCodeResponse.new instead')
  static GetMyReferralCodeResponse create() => GetMyReferralCodeResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      GetMyReferralCodeResponse._();
  @$core.override
  GetMyReferralCodeResponse createEmptyInstance() =>
      GetMyReferralCodeResponse._();
  @$core.pragma('dart2js:noInline')
  static GetMyReferralCodeResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetMyReferralCodeResponse>(
          GetMyReferralCodeResponse.$_createMessage);
  static GetMyReferralCodeResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get referralCode => $_getSZ(0);
  @$pb.TagNumber(1)
  set referralCode($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasReferralCode() => $_has(0);
  @$pb.TagNumber(1)
  void clearReferralCode() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get shareUrl => $_getSZ(1);
  @$pb.TagNumber(2)
  set shareUrl($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasShareUrl() => $_has(1);
  @$pb.TagNumber(2)
  void clearShareUrl() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get qrCodeUrl => $_getSZ(2);
  @$pb.TagNumber(3)
  set qrCodeUrl($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasQrCodeUrl() => $_has(2);
  @$pb.TagNumber(3)
  void clearQrCodeUrl() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get workspaceId => $_getSZ(3);
  @$pb.TagNumber(4)
  set workspaceId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasWorkspaceId() => $_has(3);
  @$pb.TagNumber(4)
  void clearWorkspaceId() => $_clearField(4);
}

class GetReferralStatsRequest extends $pb.GeneratedMessage {
  factory GetReferralStatsRequest({
    $core.String? workspaceId,
  }) {
    final result = GetReferralStatsRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    return result;
  }

  GetReferralStatsRequest._();

  factory GetReferralStatsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetReferralStatsRequest()..mergeFromBuffer(data, registry);
  factory GetReferralStatsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetReferralStatsRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetReferralStatsRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.platform.v1'),
      createEmptyInstance: GetReferralStatsRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetReferralStatsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetReferralStatsRequest copyWith(
          void Function(GetReferralStatsRequest) updates) =>
      super.copyWith((message) => updates(message as GetReferralStatsRequest))
          as GetReferralStatsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use GetReferralStatsRequest() / GetReferralStatsRequest.new instead')
  static GetReferralStatsRequest create() => GetReferralStatsRequest._();
  static $pb.GeneratedMessage $_createMessage() => GetReferralStatsRequest._();
  @$core.override
  GetReferralStatsRequest createEmptyInstance() => GetReferralStatsRequest._();
  @$core.pragma('dart2js:noInline')
  static GetReferralStatsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetReferralStatsRequest>(
          GetReferralStatsRequest.$_createMessage);
  static GetReferralStatsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);
}

class GetReferralStatsResponse extends $pb.GeneratedMessage {
  factory GetReferralStatsResponse({
    ReferralFunnel? funnel,
    TierProgress? tier,
  }) {
    final result = GetReferralStatsResponse._();
    if (funnel != null) result.funnel = funnel;
    if (tier != null) result.tier = tier;
    return result;
  }

  GetReferralStatsResponse._();

  factory GetReferralStatsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetReferralStatsResponse()..mergeFromBuffer(data, registry);
  factory GetReferralStatsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetReferralStatsResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetReferralStatsResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.platform.v1'),
      createEmptyInstance: GetReferralStatsResponse.$_createMessage)
    ..aOM<ReferralFunnel>(1, _omitFieldNames ? '' : 'funnel',
        subBuilder: ReferralFunnel.$_createMessage)
    ..aOM<TierProgress>(2, _omitFieldNames ? '' : 'tier',
        subBuilder: TierProgress.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetReferralStatsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetReferralStatsResponse copyWith(
          void Function(GetReferralStatsResponse) updates) =>
      super.copyWith((message) => updates(message as GetReferralStatsResponse))
          as GetReferralStatsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use GetReferralStatsResponse() / GetReferralStatsResponse.new instead')
  static GetReferralStatsResponse create() => GetReferralStatsResponse._();
  static $pb.GeneratedMessage $_createMessage() => GetReferralStatsResponse._();
  @$core.override
  GetReferralStatsResponse createEmptyInstance() =>
      GetReferralStatsResponse._();
  @$core.pragma('dart2js:noInline')
  static GetReferralStatsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetReferralStatsResponse>(
          GetReferralStatsResponse.$_createMessage);
  static GetReferralStatsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  ReferralFunnel get funnel => $_getN(0);
  @$pb.TagNumber(1)
  set funnel(ReferralFunnel value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasFunnel() => $_has(0);
  @$pb.TagNumber(1)
  void clearFunnel() => $_clearField(1);
  @$pb.TagNumber(1)
  ReferralFunnel ensureFunnel() => $_ensure(0);

  @$pb.TagNumber(2)
  TierProgress get tier => $_getN(1);
  @$pb.TagNumber(2)
  set tier(TierProgress value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasTier() => $_has(1);
  @$pb.TagNumber(2)
  void clearTier() => $_clearField(2);
  @$pb.TagNumber(2)
  TierProgress ensureTier() => $_ensure(1);
}

class ListReferralsRequest extends $pb.GeneratedMessage {
  factory ListReferralsRequest({
    $core.String? workspaceId,
    ReferralStatus? statusFilter,
    $2.Pagination? pagination,
  }) {
    final result = ListReferralsRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (statusFilter != null) result.statusFilter = statusFilter;
    if (pagination != null) result.pagination = pagination;
    return result;
  }

  ListReferralsRequest._();

  factory ListReferralsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListReferralsRequest()..mergeFromBuffer(data, registry);
  factory ListReferralsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListReferralsRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListReferralsRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.platform.v1'),
      createEmptyInstance: ListReferralsRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aE<ReferralStatus>(2, _omitFieldNames ? '' : 'statusFilter',
        enumValues: ReferralStatus.values)
    ..aOM<$2.Pagination>(3, _omitFieldNames ? '' : 'pagination',
        subBuilder: $2.Pagination.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListReferralsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListReferralsRequest copyWith(void Function(ListReferralsRequest) updates) =>
      super.copyWith((message) => updates(message as ListReferralsRequest))
          as ListReferralsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ListReferralsRequest() / ListReferralsRequest.new instead')
  static ListReferralsRequest create() => ListReferralsRequest._();
  static $pb.GeneratedMessage $_createMessage() => ListReferralsRequest._();
  @$core.override
  ListReferralsRequest createEmptyInstance() => ListReferralsRequest._();
  @$core.pragma('dart2js:noInline')
  static ListReferralsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListReferralsRequest>(
          ListReferralsRequest.$_createMessage);
  static ListReferralsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  ReferralStatus get statusFilter => $_getN(1);
  @$pb.TagNumber(2)
  set statusFilter(ReferralStatus value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasStatusFilter() => $_has(1);
  @$pb.TagNumber(2)
  void clearStatusFilter() => $_clearField(2);

  @$pb.TagNumber(3)
  $2.Pagination get pagination => $_getN(2);
  @$pb.TagNumber(3)
  set pagination($2.Pagination value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasPagination() => $_has(2);
  @$pb.TagNumber(3)
  void clearPagination() => $_clearField(3);
  @$pb.TagNumber(3)
  $2.Pagination ensurePagination() => $_ensure(2);
}

class ListReferralsResponse extends $pb.GeneratedMessage {
  factory ListReferralsResponse({
    $core.Iterable<ReferralRecord>? referrals,
    $2.PaginatedResponse? pagination,
  }) {
    final result = ListReferralsResponse._();
    if (referrals != null) result.referrals.addAll(referrals);
    if (pagination != null) result.pagination = pagination;
    return result;
  }

  ListReferralsResponse._();

  factory ListReferralsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListReferralsResponse()..mergeFromBuffer(data, registry);
  factory ListReferralsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ListReferralsResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListReferralsResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.platform.v1'),
      createEmptyInstance: ListReferralsResponse.$_createMessage)
    ..pPM<ReferralRecord>(1, _omitFieldNames ? '' : 'referrals',
        subBuilder: ReferralRecord.$_createMessage)
    ..aOM<$2.PaginatedResponse>(2, _omitFieldNames ? '' : 'pagination',
        subBuilder: $2.PaginatedResponse.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListReferralsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListReferralsResponse copyWith(
          void Function(ListReferralsResponse) updates) =>
      super.copyWith((message) => updates(message as ListReferralsResponse))
          as ListReferralsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ListReferralsResponse() / ListReferralsResponse.new instead')
  static ListReferralsResponse create() => ListReferralsResponse._();
  static $pb.GeneratedMessage $_createMessage() => ListReferralsResponse._();
  @$core.override
  ListReferralsResponse createEmptyInstance() => ListReferralsResponse._();
  @$core.pragma('dart2js:noInline')
  static ListReferralsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListReferralsResponse>(
          ListReferralsResponse.$_createMessage);
  static ListReferralsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<ReferralRecord> get referrals => $_getList(0);

  @$pb.TagNumber(2)
  $2.PaginatedResponse get pagination => $_getN(1);
  @$pb.TagNumber(2)
  set pagination($2.PaginatedResponse value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasPagination() => $_has(1);
  @$pb.TagNumber(2)
  void clearPagination() => $_clearField(2);
  @$pb.TagNumber(2)
  $2.PaginatedResponse ensurePagination() => $_ensure(1);
}

class ClaimRewardRequest extends $pb.GeneratedMessage {
  factory ClaimRewardRequest({
    $core.String? workspaceId,
    $core.String? referralId,
    $core.String? idempotencyKey,
  }) {
    final result = ClaimRewardRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (referralId != null) result.referralId = referralId;
    if (idempotencyKey != null) result.idempotencyKey = idempotencyKey;
    return result;
  }

  ClaimRewardRequest._();

  factory ClaimRewardRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ClaimRewardRequest()..mergeFromBuffer(data, registry);
  factory ClaimRewardRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ClaimRewardRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ClaimRewardRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.platform.v1'),
      createEmptyInstance: ClaimRewardRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'referralId')
    ..aOS(3, _omitFieldNames ? '' : 'idempotencyKey')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ClaimRewardRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ClaimRewardRequest copyWith(void Function(ClaimRewardRequest) updates) =>
      super.copyWith((message) => updates(message as ClaimRewardRequest))
          as ClaimRewardRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use ClaimRewardRequest() / ClaimRewardRequest.new instead')
  static ClaimRewardRequest create() => ClaimRewardRequest._();
  static $pb.GeneratedMessage $_createMessage() => ClaimRewardRequest._();
  @$core.override
  ClaimRewardRequest createEmptyInstance() => ClaimRewardRequest._();
  @$core.pragma('dart2js:noInline')
  static ClaimRewardRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ClaimRewardRequest>(
          ClaimRewardRequest.$_createMessage);
  static ClaimRewardRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get referralId => $_getSZ(1);
  @$pb.TagNumber(2)
  set referralId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasReferralId() => $_has(1);
  @$pb.TagNumber(2)
  void clearReferralId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get idempotencyKey => $_getSZ(2);
  @$pb.TagNumber(3)
  set idempotencyKey($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasIdempotencyKey() => $_has(2);
  @$pb.TagNumber(3)
  void clearIdempotencyKey() => $_clearField(3);
}

class ClaimRewardResponse extends $pb.GeneratedMessage {
  factory ClaimRewardResponse({
    $core.bool? success,
    $core.String? creditsAwarded,
    $core.String? transactionId,
    $core.String? newBalance,
  }) {
    final result = ClaimRewardResponse._();
    if (success != null) result.success = success;
    if (creditsAwarded != null) result.creditsAwarded = creditsAwarded;
    if (transactionId != null) result.transactionId = transactionId;
    if (newBalance != null) result.newBalance = newBalance;
    return result;
  }

  ClaimRewardResponse._();

  factory ClaimRewardResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ClaimRewardResponse()..mergeFromBuffer(data, registry);
  factory ClaimRewardResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ClaimRewardResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ClaimRewardResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.platform.v1'),
      createEmptyInstance: ClaimRewardResponse.$_createMessage)
    ..aOB(1, _omitFieldNames ? '' : 'success')
    ..aOS(2, _omitFieldNames ? '' : 'creditsAwarded')
    ..aOS(3, _omitFieldNames ? '' : 'transactionId')
    ..aOS(4, _omitFieldNames ? '' : 'newBalance')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ClaimRewardResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ClaimRewardResponse copyWith(void Function(ClaimRewardResponse) updates) =>
      super.copyWith((message) => updates(message as ClaimRewardResponse))
          as ClaimRewardResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core
      .Deprecated('Use ClaimRewardResponse() / ClaimRewardResponse.new instead')
  static ClaimRewardResponse create() => ClaimRewardResponse._();
  static $pb.GeneratedMessage $_createMessage() => ClaimRewardResponse._();
  @$core.override
  ClaimRewardResponse createEmptyInstance() => ClaimRewardResponse._();
  @$core.pragma('dart2js:noInline')
  static ClaimRewardResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ClaimRewardResponse>(
          ClaimRewardResponse.$_createMessage);
  static ClaimRewardResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get success => $_getBF(0);
  @$pb.TagNumber(1)
  set success($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSuccess() => $_has(0);
  @$pb.TagNumber(1)
  void clearSuccess() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get creditsAwarded => $_getSZ(1);
  @$pb.TagNumber(2)
  set creditsAwarded($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCreditsAwarded() => $_has(1);
  @$pb.TagNumber(2)
  void clearCreditsAwarded() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get transactionId => $_getSZ(2);
  @$pb.TagNumber(3)
  set transactionId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasTransactionId() => $_has(2);
  @$pb.TagNumber(3)
  void clearTransactionId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get newBalance => $_getSZ(3);
  @$pb.TagNumber(4)
  set newBalance($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasNewBalance() => $_has(3);
  @$pb.TagNumber(4)
  void clearNewBalance() => $_clearField(4);
}

class ValidateCodeRequest extends $pb.GeneratedMessage {
  factory ValidateCodeRequest({
    $core.String? referralCode,
  }) {
    final result = ValidateCodeRequest._();
    if (referralCode != null) result.referralCode = referralCode;
    return result;
  }

  ValidateCodeRequest._();

  factory ValidateCodeRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ValidateCodeRequest()..mergeFromBuffer(data, registry);
  factory ValidateCodeRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ValidateCodeRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ValidateCodeRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.platform.v1'),
      createEmptyInstance: ValidateCodeRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'referralCode')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ValidateCodeRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ValidateCodeRequest copyWith(void Function(ValidateCodeRequest) updates) =>
      super.copyWith((message) => updates(message as ValidateCodeRequest))
          as ValidateCodeRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core
      .Deprecated('Use ValidateCodeRequest() / ValidateCodeRequest.new instead')
  static ValidateCodeRequest create() => ValidateCodeRequest._();
  static $pb.GeneratedMessage $_createMessage() => ValidateCodeRequest._();
  @$core.override
  ValidateCodeRequest createEmptyInstance() => ValidateCodeRequest._();
  @$core.pragma('dart2js:noInline')
  static ValidateCodeRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ValidateCodeRequest>(
          ValidateCodeRequest.$_createMessage);
  static ValidateCodeRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get referralCode => $_getSZ(0);
  @$pb.TagNumber(1)
  set referralCode($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasReferralCode() => $_has(0);
  @$pb.TagNumber(1)
  void clearReferralCode() => $_clearField(1);
}

class ValidateCodeResponse extends $pb.GeneratedMessage {
  factory ValidateCodeResponse({
    $core.bool? isValid,
    $core.String? referrerName,
    $core.String? bonusCredits,
    $core.String? errorMessage,
  }) {
    final result = ValidateCodeResponse._();
    if (isValid != null) result.isValid = isValid;
    if (referrerName != null) result.referrerName = referrerName;
    if (bonusCredits != null) result.bonusCredits = bonusCredits;
    if (errorMessage != null) result.errorMessage = errorMessage;
    return result;
  }

  ValidateCodeResponse._();

  factory ValidateCodeResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ValidateCodeResponse()..mergeFromBuffer(data, registry);
  factory ValidateCodeResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ValidateCodeResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ValidateCodeResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.platform.v1'),
      createEmptyInstance: ValidateCodeResponse.$_createMessage)
    ..aOB(1, _omitFieldNames ? '' : 'isValid')
    ..aOS(2, _omitFieldNames ? '' : 'referrerName')
    ..aOS(3, _omitFieldNames ? '' : 'bonusCredits')
    ..aOS(4, _omitFieldNames ? '' : 'errorMessage')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ValidateCodeResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ValidateCodeResponse copyWith(void Function(ValidateCodeResponse) updates) =>
      super.copyWith((message) => updates(message as ValidateCodeResponse))
          as ValidateCodeResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ValidateCodeResponse() / ValidateCodeResponse.new instead')
  static ValidateCodeResponse create() => ValidateCodeResponse._();
  static $pb.GeneratedMessage $_createMessage() => ValidateCodeResponse._();
  @$core.override
  ValidateCodeResponse createEmptyInstance() => ValidateCodeResponse._();
  @$core.pragma('dart2js:noInline')
  static ValidateCodeResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ValidateCodeResponse>(
          ValidateCodeResponse.$_createMessage);
  static ValidateCodeResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get isValid => $_getBF(0);
  @$pb.TagNumber(1)
  set isValid($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasIsValid() => $_has(0);
  @$pb.TagNumber(1)
  void clearIsValid() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get referrerName => $_getSZ(1);
  @$pb.TagNumber(2)
  set referrerName($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasReferrerName() => $_has(1);
  @$pb.TagNumber(2)
  void clearReferrerName() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get bonusCredits => $_getSZ(2);
  @$pb.TagNumber(3)
  set bonusCredits($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasBonusCredits() => $_has(2);
  @$pb.TagNumber(3)
  void clearBonusCredits() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get errorMessage => $_getSZ(3);
  @$pb.TagNumber(4)
  set errorMessage($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasErrorMessage() => $_has(3);
  @$pb.TagNumber(4)
  void clearErrorMessage() => $_clearField(4);
}

class GetDashboardRequest extends $pb.GeneratedMessage {
  factory GetDashboardRequest({
    $core.String? workspaceId,
  }) {
    final result = GetDashboardRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    return result;
  }

  GetDashboardRequest._();

  factory GetDashboardRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetDashboardRequest()..mergeFromBuffer(data, registry);
  factory GetDashboardRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetDashboardRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetDashboardRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.platform.v1'),
      createEmptyInstance: GetDashboardRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetDashboardRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetDashboardRequest copyWith(void Function(GetDashboardRequest) updates) =>
      super.copyWith((message) => updates(message as GetDashboardRequest))
          as GetDashboardRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core
      .Deprecated('Use GetDashboardRequest() / GetDashboardRequest.new instead')
  static GetDashboardRequest create() => GetDashboardRequest._();
  static $pb.GeneratedMessage $_createMessage() => GetDashboardRequest._();
  @$core.override
  GetDashboardRequest createEmptyInstance() => GetDashboardRequest._();
  @$core.pragma('dart2js:noInline')
  static GetDashboardRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetDashboardRequest>(
          GetDashboardRequest.$_createMessage);
  static GetDashboardRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);
}

class GetDashboardResponse extends $pb.GeneratedMessage {
  factory GetDashboardResponse({
    $core.String? referralCode,
    $core.String? shareUrl,
    ReferralFunnel? funnel,
    TierProgress? tier,
    $core.Iterable<ReferralRecord>? recentReferrals,
    $core.Iterable<GrowthPrompt>? prompts,
  }) {
    final result = GetDashboardResponse._();
    if (referralCode != null) result.referralCode = referralCode;
    if (shareUrl != null) result.shareUrl = shareUrl;
    if (funnel != null) result.funnel = funnel;
    if (tier != null) result.tier = tier;
    if (recentReferrals != null) result.recentReferrals.addAll(recentReferrals);
    if (prompts != null) result.prompts.addAll(prompts);
    return result;
  }

  GetDashboardResponse._();

  factory GetDashboardResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetDashboardResponse()..mergeFromBuffer(data, registry);
  factory GetDashboardResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetDashboardResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetDashboardResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.platform.v1'),
      createEmptyInstance: GetDashboardResponse.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'referralCode')
    ..aOS(2, _omitFieldNames ? '' : 'shareUrl')
    ..aOM<ReferralFunnel>(3, _omitFieldNames ? '' : 'funnel',
        subBuilder: ReferralFunnel.$_createMessage)
    ..aOM<TierProgress>(4, _omitFieldNames ? '' : 'tier',
        subBuilder: TierProgress.$_createMessage)
    ..pPM<ReferralRecord>(5, _omitFieldNames ? '' : 'recentReferrals',
        subBuilder: ReferralRecord.$_createMessage)
    ..pPM<GrowthPrompt>(6, _omitFieldNames ? '' : 'prompts',
        subBuilder: GrowthPrompt.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetDashboardResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetDashboardResponse copyWith(void Function(GetDashboardResponse) updates) =>
      super.copyWith((message) => updates(message as GetDashboardResponse))
          as GetDashboardResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use GetDashboardResponse() / GetDashboardResponse.new instead')
  static GetDashboardResponse create() => GetDashboardResponse._();
  static $pb.GeneratedMessage $_createMessage() => GetDashboardResponse._();
  @$core.override
  GetDashboardResponse createEmptyInstance() => GetDashboardResponse._();
  @$core.pragma('dart2js:noInline')
  static GetDashboardResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetDashboardResponse>(
          GetDashboardResponse.$_createMessage);
  static GetDashboardResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get referralCode => $_getSZ(0);
  @$pb.TagNumber(1)
  set referralCode($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasReferralCode() => $_has(0);
  @$pb.TagNumber(1)
  void clearReferralCode() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get shareUrl => $_getSZ(1);
  @$pb.TagNumber(2)
  set shareUrl($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasShareUrl() => $_has(1);
  @$pb.TagNumber(2)
  void clearShareUrl() => $_clearField(2);

  @$pb.TagNumber(3)
  ReferralFunnel get funnel => $_getN(2);
  @$pb.TagNumber(3)
  set funnel(ReferralFunnel value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasFunnel() => $_has(2);
  @$pb.TagNumber(3)
  void clearFunnel() => $_clearField(3);
  @$pb.TagNumber(3)
  ReferralFunnel ensureFunnel() => $_ensure(2);

  @$pb.TagNumber(4)
  TierProgress get tier => $_getN(3);
  @$pb.TagNumber(4)
  set tier(TierProgress value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasTier() => $_has(3);
  @$pb.TagNumber(4)
  void clearTier() => $_clearField(4);
  @$pb.TagNumber(4)
  TierProgress ensureTier() => $_ensure(3);

  @$pb.TagNumber(5)
  $pb.PbList<ReferralRecord> get recentReferrals => $_getList(4);

  @$pb.TagNumber(6)
  $pb.PbList<GrowthPrompt> get prompts => $_getList(5);
}

class GetReferralLinkRequest extends $pb.GeneratedMessage {
  factory GetReferralLinkRequest({
    $core.String? workspaceId,
  }) {
    final result = GetReferralLinkRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    return result;
  }

  GetReferralLinkRequest._();

  factory GetReferralLinkRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetReferralLinkRequest()..mergeFromBuffer(data, registry);
  factory GetReferralLinkRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetReferralLinkRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetReferralLinkRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.platform.v1'),
      createEmptyInstance: GetReferralLinkRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetReferralLinkRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetReferralLinkRequest copyWith(
          void Function(GetReferralLinkRequest) updates) =>
      super.copyWith((message) => updates(message as GetReferralLinkRequest))
          as GetReferralLinkRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use GetReferralLinkRequest() / GetReferralLinkRequest.new instead')
  static GetReferralLinkRequest create() => GetReferralLinkRequest._();
  static $pb.GeneratedMessage $_createMessage() => GetReferralLinkRequest._();
  @$core.override
  GetReferralLinkRequest createEmptyInstance() => GetReferralLinkRequest._();
  @$core.pragma('dart2js:noInline')
  static GetReferralLinkRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetReferralLinkRequest>(
          GetReferralLinkRequest.$_createMessage);
  static GetReferralLinkRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);
}

class GetReferralLinkResponse extends $pb.GeneratedMessage {
  factory GetReferralLinkResponse({
    $core.String? referralCode,
    $core.String? shareUrl,
  }) {
    final result = GetReferralLinkResponse._();
    if (referralCode != null) result.referralCode = referralCode;
    if (shareUrl != null) result.shareUrl = shareUrl;
    return result;
  }

  GetReferralLinkResponse._();

  factory GetReferralLinkResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetReferralLinkResponse()..mergeFromBuffer(data, registry);
  factory GetReferralLinkResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetReferralLinkResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetReferralLinkResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.platform.v1'),
      createEmptyInstance: GetReferralLinkResponse.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'referralCode')
    ..aOS(2, _omitFieldNames ? '' : 'shareUrl')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetReferralLinkResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetReferralLinkResponse copyWith(
          void Function(GetReferralLinkResponse) updates) =>
      super.copyWith((message) => updates(message as GetReferralLinkResponse))
          as GetReferralLinkResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use GetReferralLinkResponse() / GetReferralLinkResponse.new instead')
  static GetReferralLinkResponse create() => GetReferralLinkResponse._();
  static $pb.GeneratedMessage $_createMessage() => GetReferralLinkResponse._();
  @$core.override
  GetReferralLinkResponse createEmptyInstance() => GetReferralLinkResponse._();
  @$core.pragma('dart2js:noInline')
  static GetReferralLinkResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetReferralLinkResponse>(
          GetReferralLinkResponse.$_createMessage);
  static GetReferralLinkResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get referralCode => $_getSZ(0);
  @$pb.TagNumber(1)
  set referralCode($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasReferralCode() => $_has(0);
  @$pb.TagNumber(1)
  void clearReferralCode() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get shareUrl => $_getSZ(1);
  @$pb.TagNumber(2)
  set shareUrl($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasShareUrl() => $_has(1);
  @$pb.TagNumber(2)
  void clearShareUrl() => $_clearField(2);
}

class GetStatsRequest extends $pb.GeneratedMessage {
  factory GetStatsRequest({
    $core.String? workspaceId,
  }) {
    final result = GetStatsRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    return result;
  }

  GetStatsRequest._();

  factory GetStatsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetStatsRequest()..mergeFromBuffer(data, registry);
  factory GetStatsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetStatsRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetStatsRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.platform.v1'),
      createEmptyInstance: GetStatsRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetStatsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetStatsRequest copyWith(void Function(GetStatsRequest) updates) =>
      super.copyWith((message) => updates(message as GetStatsRequest))
          as GetStatsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use GetStatsRequest() / GetStatsRequest.new instead')
  static GetStatsRequest create() => GetStatsRequest._();
  static $pb.GeneratedMessage $_createMessage() => GetStatsRequest._();
  @$core.override
  GetStatsRequest createEmptyInstance() => GetStatsRequest._();
  @$core.pragma('dart2js:noInline')
  static GetStatsRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetStatsRequest>(
          GetStatsRequest.$_createMessage);
  static GetStatsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);
}

class GetStatsResponse extends $pb.GeneratedMessage {
  factory GetStatsResponse({
    ReferralFunnel? funnel,
    TierProgress? tier,
  }) {
    final result = GetStatsResponse._();
    if (funnel != null) result.funnel = funnel;
    if (tier != null) result.tier = tier;
    return result;
  }

  GetStatsResponse._();

  factory GetStatsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetStatsResponse()..mergeFromBuffer(data, registry);
  factory GetStatsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetStatsResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetStatsResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.platform.v1'),
      createEmptyInstance: GetStatsResponse.$_createMessage)
    ..aOM<ReferralFunnel>(1, _omitFieldNames ? '' : 'funnel',
        subBuilder: ReferralFunnel.$_createMessage)
    ..aOM<TierProgress>(2, _omitFieldNames ? '' : 'tier',
        subBuilder: TierProgress.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetStatsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetStatsResponse copyWith(void Function(GetStatsResponse) updates) =>
      super.copyWith((message) => updates(message as GetStatsResponse))
          as GetStatsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use GetStatsResponse() / GetStatsResponse.new instead')
  static GetStatsResponse create() => GetStatsResponse._();
  static $pb.GeneratedMessage $_createMessage() => GetStatsResponse._();
  @$core.override
  GetStatsResponse createEmptyInstance() => GetStatsResponse._();
  @$core.pragma('dart2js:noInline')
  static GetStatsResponse getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetStatsResponse>(
          GetStatsResponse.$_createMessage);
  static GetStatsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  ReferralFunnel get funnel => $_getN(0);
  @$pb.TagNumber(1)
  set funnel(ReferralFunnel value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasFunnel() => $_has(0);
  @$pb.TagNumber(1)
  void clearFunnel() => $_clearField(1);
  @$pb.TagNumber(1)
  ReferralFunnel ensureFunnel() => $_ensure(0);

  @$pb.TagNumber(2)
  TierProgress get tier => $_getN(1);
  @$pb.TagNumber(2)
  set tier(TierProgress value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasTier() => $_has(1);
  @$pb.TagNumber(2)
  void clearTier() => $_clearField(2);
  @$pb.TagNumber(2)
  TierProgress ensureTier() => $_ensure(1);
}

class SendReminderRequest extends $pb.GeneratedMessage {
  factory SendReminderRequest({
    $core.String? workspaceId,
    $core.String? referralId,
  }) {
    final result = SendReminderRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (referralId != null) result.referralId = referralId;
    return result;
  }

  SendReminderRequest._();

  factory SendReminderRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SendReminderRequest()..mergeFromBuffer(data, registry);
  factory SendReminderRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SendReminderRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SendReminderRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.platform.v1'),
      createEmptyInstance: SendReminderRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'referralId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SendReminderRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SendReminderRequest copyWith(void Function(SendReminderRequest) updates) =>
      super.copyWith((message) => updates(message as SendReminderRequest))
          as SendReminderRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core
      .Deprecated('Use SendReminderRequest() / SendReminderRequest.new instead')
  static SendReminderRequest create() => SendReminderRequest._();
  static $pb.GeneratedMessage $_createMessage() => SendReminderRequest._();
  @$core.override
  SendReminderRequest createEmptyInstance() => SendReminderRequest._();
  @$core.pragma('dart2js:noInline')
  static SendReminderRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SendReminderRequest>(
          SendReminderRequest.$_createMessage);
  static SendReminderRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get referralId => $_getSZ(1);
  @$pb.TagNumber(2)
  set referralId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasReferralId() => $_has(1);
  @$pb.TagNumber(2)
  void clearReferralId() => $_clearField(2);
}

class SendReminderResponse extends $pb.GeneratedMessage {
  factory SendReminderResponse({
    $core.bool? success,
    $core.String? message,
  }) {
    final result = SendReminderResponse._();
    if (success != null) result.success = success;
    if (message != null) result.message = message;
    return result;
  }

  SendReminderResponse._();

  factory SendReminderResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SendReminderResponse()..mergeFromBuffer(data, registry);
  factory SendReminderResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      SendReminderResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SendReminderResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.platform.v1'),
      createEmptyInstance: SendReminderResponse.$_createMessage)
    ..aOB(1, _omitFieldNames ? '' : 'success')
    ..aOS(2, _omitFieldNames ? '' : 'message')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SendReminderResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SendReminderResponse copyWith(void Function(SendReminderResponse) updates) =>
      super.copyWith((message) => updates(message as SendReminderResponse))
          as SendReminderResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use SendReminderResponse() / SendReminderResponse.new instead')
  static SendReminderResponse create() => SendReminderResponse._();
  static $pb.GeneratedMessage $_createMessage() => SendReminderResponse._();
  @$core.override
  SendReminderResponse createEmptyInstance() => SendReminderResponse._();
  @$core.pragma('dart2js:noInline')
  static SendReminderResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SendReminderResponse>(
          SendReminderResponse.$_createMessage);
  static SendReminderResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get success => $_getBF(0);
  @$pb.TagNumber(1)
  set success($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSuccess() => $_has(0);
  @$pb.TagNumber(1)
  void clearSuccess() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get message => $_getSZ(1);
  @$pb.TagNumber(2)
  set message($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasMessage() => $_has(1);
  @$pb.TagNumber(2)
  void clearMessage() => $_clearField(2);
}

class ProcessPaymentSettlementRequest extends $pb.GeneratedMessage {
  factory ProcessPaymentSettlementRequest({
    $core.String? referralId,
    $core.String? paymentStatus,
    $core.String? planTier,
    $core.String? paidAmount,
    $core.String? paymentReferenceId,
    $core.String? idempotencyKey,
  }) {
    final result = ProcessPaymentSettlementRequest._();
    if (referralId != null) result.referralId = referralId;
    if (paymentStatus != null) result.paymentStatus = paymentStatus;
    if (planTier != null) result.planTier = planTier;
    if (paidAmount != null) result.paidAmount = paidAmount;
    if (paymentReferenceId != null)
      result.paymentReferenceId = paymentReferenceId;
    if (idempotencyKey != null) result.idempotencyKey = idempotencyKey;
    return result;
  }

  ProcessPaymentSettlementRequest._();

  factory ProcessPaymentSettlementRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ProcessPaymentSettlementRequest()..mergeFromBuffer(data, registry);
  factory ProcessPaymentSettlementRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ProcessPaymentSettlementRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ProcessPaymentSettlementRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.platform.v1'),
      createEmptyInstance: ProcessPaymentSettlementRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'referralId')
    ..aOS(2, _omitFieldNames ? '' : 'paymentStatus')
    ..aOS(3, _omitFieldNames ? '' : 'planTier')
    ..aOS(4, _omitFieldNames ? '' : 'paidAmount')
    ..aOS(5, _omitFieldNames ? '' : 'paymentReferenceId')
    ..aOS(6, _omitFieldNames ? '' : 'idempotencyKey')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ProcessPaymentSettlementRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ProcessPaymentSettlementRequest copyWith(
          void Function(ProcessPaymentSettlementRequest) updates) =>
      super.copyWith(
              (message) => updates(message as ProcessPaymentSettlementRequest))
          as ProcessPaymentSettlementRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ProcessPaymentSettlementRequest() / ProcessPaymentSettlementRequest.new instead')
  static ProcessPaymentSettlementRequest create() =>
      ProcessPaymentSettlementRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      ProcessPaymentSettlementRequest._();
  @$core.override
  ProcessPaymentSettlementRequest createEmptyInstance() =>
      ProcessPaymentSettlementRequest._();
  @$core.pragma('dart2js:noInline')
  static ProcessPaymentSettlementRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ProcessPaymentSettlementRequest>(
          ProcessPaymentSettlementRequest.$_createMessage);
  static ProcessPaymentSettlementRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get referralId => $_getSZ(0);
  @$pb.TagNumber(1)
  set referralId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasReferralId() => $_has(0);
  @$pb.TagNumber(1)
  void clearReferralId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get paymentStatus => $_getSZ(1);
  @$pb.TagNumber(2)
  set paymentStatus($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPaymentStatus() => $_has(1);
  @$pb.TagNumber(2)
  void clearPaymentStatus() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get planTier => $_getSZ(2);
  @$pb.TagNumber(3)
  set planTier($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPlanTier() => $_has(2);
  @$pb.TagNumber(3)
  void clearPlanTier() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get paidAmount => $_getSZ(3);
  @$pb.TagNumber(4)
  set paidAmount($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasPaidAmount() => $_has(3);
  @$pb.TagNumber(4)
  void clearPaidAmount() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get paymentReferenceId => $_getSZ(4);
  @$pb.TagNumber(5)
  set paymentReferenceId($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasPaymentReferenceId() => $_has(4);
  @$pb.TagNumber(5)
  void clearPaymentReferenceId() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get idempotencyKey => $_getSZ(5);
  @$pb.TagNumber(6)
  set idempotencyKey($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasIdempotencyKey() => $_has(5);
  @$pb.TagNumber(6)
  void clearIdempotencyKey() => $_clearField(6);
}

class ProcessPaymentSettlementResponse extends $pb.GeneratedMessage {
  factory ProcessPaymentSettlementResponse({
    $core.bool? qualified,
    ReferralStatus? status,
    $core.String? creditsAwarded,
    $core.String? message,
  }) {
    final result = ProcessPaymentSettlementResponse._();
    if (qualified != null) result.qualified = qualified;
    if (status != null) result.status = status;
    if (creditsAwarded != null) result.creditsAwarded = creditsAwarded;
    if (message != null) result.message = message;
    return result;
  }

  ProcessPaymentSettlementResponse._();

  factory ProcessPaymentSettlementResponse.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ProcessPaymentSettlementResponse()..mergeFromBuffer(data, registry);
  factory ProcessPaymentSettlementResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ProcessPaymentSettlementResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ProcessPaymentSettlementResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.platform.v1'),
      createEmptyInstance: ProcessPaymentSettlementResponse.$_createMessage)
    ..aOB(1, _omitFieldNames ? '' : 'qualified')
    ..aE<ReferralStatus>(2, _omitFieldNames ? '' : 'status',
        enumValues: ReferralStatus.values)
    ..aOS(3, _omitFieldNames ? '' : 'creditsAwarded')
    ..aOS(4, _omitFieldNames ? '' : 'message')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ProcessPaymentSettlementResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ProcessPaymentSettlementResponse copyWith(
          void Function(ProcessPaymentSettlementResponse) updates) =>
      super.copyWith(
              (message) => updates(message as ProcessPaymentSettlementResponse))
          as ProcessPaymentSettlementResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ProcessPaymentSettlementResponse() / ProcessPaymentSettlementResponse.new instead')
  static ProcessPaymentSettlementResponse create() =>
      ProcessPaymentSettlementResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      ProcessPaymentSettlementResponse._();
  @$core.override
  ProcessPaymentSettlementResponse createEmptyInstance() =>
      ProcessPaymentSettlementResponse._();
  @$core.pragma('dart2js:noInline')
  static ProcessPaymentSettlementResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ProcessPaymentSettlementResponse>(
          ProcessPaymentSettlementResponse.$_createMessage);
  static ProcessPaymentSettlementResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get qualified => $_getBF(0);
  @$pb.TagNumber(1)
  set qualified($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasQualified() => $_has(0);
  @$pb.TagNumber(1)
  void clearQualified() => $_clearField(1);

  @$pb.TagNumber(2)
  ReferralStatus get status => $_getN(1);
  @$pb.TagNumber(2)
  set status(ReferralStatus value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasStatus() => $_has(1);
  @$pb.TagNumber(2)
  void clearStatus() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get creditsAwarded => $_getSZ(2);
  @$pb.TagNumber(3)
  set creditsAwarded($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasCreditsAwarded() => $_has(2);
  @$pb.TagNumber(3)
  void clearCreditsAwarded() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get message => $_getSZ(3);
  @$pb.TagNumber(4)
  set message($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasMessage() => $_has(3);
  @$pb.TagNumber(4)
  void clearMessage() => $_clearField(4);
}

class ProcessRefundReversalRequest extends $pb.GeneratedMessage {
  factory ProcessRefundReversalRequest({
    $core.String? referralId,
    $core.String? refundReason,
    $core.String? refundReferenceId,
    $core.String? idempotencyKey,
  }) {
    final result = ProcessRefundReversalRequest._();
    if (referralId != null) result.referralId = referralId;
    if (refundReason != null) result.refundReason = refundReason;
    if (refundReferenceId != null) result.refundReferenceId = refundReferenceId;
    if (idempotencyKey != null) result.idempotencyKey = idempotencyKey;
    return result;
  }

  ProcessRefundReversalRequest._();

  factory ProcessRefundReversalRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ProcessRefundReversalRequest()..mergeFromBuffer(data, registry);
  factory ProcessRefundReversalRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ProcessRefundReversalRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ProcessRefundReversalRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.platform.v1'),
      createEmptyInstance: ProcessRefundReversalRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'referralId')
    ..aOS(2, _omitFieldNames ? '' : 'refundReason')
    ..aOS(3, _omitFieldNames ? '' : 'refundReferenceId')
    ..aOS(4, _omitFieldNames ? '' : 'idempotencyKey')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ProcessRefundReversalRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ProcessRefundReversalRequest copyWith(
          void Function(ProcessRefundReversalRequest) updates) =>
      super.copyWith(
              (message) => updates(message as ProcessRefundReversalRequest))
          as ProcessRefundReversalRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ProcessRefundReversalRequest() / ProcessRefundReversalRequest.new instead')
  static ProcessRefundReversalRequest create() =>
      ProcessRefundReversalRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      ProcessRefundReversalRequest._();
  @$core.override
  ProcessRefundReversalRequest createEmptyInstance() =>
      ProcessRefundReversalRequest._();
  @$core.pragma('dart2js:noInline')
  static ProcessRefundReversalRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ProcessRefundReversalRequest>(
          ProcessRefundReversalRequest.$_createMessage);
  static ProcessRefundReversalRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get referralId => $_getSZ(0);
  @$pb.TagNumber(1)
  set referralId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasReferralId() => $_has(0);
  @$pb.TagNumber(1)
  void clearReferralId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get refundReason => $_getSZ(1);
  @$pb.TagNumber(2)
  set refundReason($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasRefundReason() => $_has(1);
  @$pb.TagNumber(2)
  void clearRefundReason() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get refundReferenceId => $_getSZ(2);
  @$pb.TagNumber(3)
  set refundReferenceId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasRefundReferenceId() => $_has(2);
  @$pb.TagNumber(3)
  void clearRefundReferenceId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get idempotencyKey => $_getSZ(3);
  @$pb.TagNumber(4)
  set idempotencyKey($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasIdempotencyKey() => $_has(3);
  @$pb.TagNumber(4)
  void clearIdempotencyKey() => $_clearField(4);
}

class ProcessRefundReversalResponse extends $pb.GeneratedMessage {
  factory ProcessRefundReversalResponse({
    $core.bool? reversed,
    $core.bool? duplicateReplay,
    ReferralStatus? status,
    $core.String? creditsReversed,
    $core.String? reversalTransactionId,
  }) {
    final result = ProcessRefundReversalResponse._();
    if (reversed != null) result.reversed = reversed;
    if (duplicateReplay != null) result.duplicateReplay = duplicateReplay;
    if (status != null) result.status = status;
    if (creditsReversed != null) result.creditsReversed = creditsReversed;
    if (reversalTransactionId != null)
      result.reversalTransactionId = reversalTransactionId;
    return result;
  }

  ProcessRefundReversalResponse._();

  factory ProcessRefundReversalResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ProcessRefundReversalResponse()..mergeFromBuffer(data, registry);
  factory ProcessRefundReversalResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ProcessRefundReversalResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ProcessRefundReversalResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.platform.v1'),
      createEmptyInstance: ProcessRefundReversalResponse.$_createMessage)
    ..aOB(1, _omitFieldNames ? '' : 'reversed')
    ..aOB(2, _omitFieldNames ? '' : 'duplicateReplay')
    ..aE<ReferralStatus>(3, _omitFieldNames ? '' : 'status',
        enumValues: ReferralStatus.values)
    ..aOS(4, _omitFieldNames ? '' : 'creditsReversed')
    ..aOS(5, _omitFieldNames ? '' : 'reversalTransactionId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ProcessRefundReversalResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ProcessRefundReversalResponse copyWith(
          void Function(ProcessRefundReversalResponse) updates) =>
      super.copyWith(
              (message) => updates(message as ProcessRefundReversalResponse))
          as ProcessRefundReversalResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ProcessRefundReversalResponse() / ProcessRefundReversalResponse.new instead')
  static ProcessRefundReversalResponse create() =>
      ProcessRefundReversalResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      ProcessRefundReversalResponse._();
  @$core.override
  ProcessRefundReversalResponse createEmptyInstance() =>
      ProcessRefundReversalResponse._();
  @$core.pragma('dart2js:noInline')
  static ProcessRefundReversalResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ProcessRefundReversalResponse>(
          ProcessRefundReversalResponse.$_createMessage);
  static ProcessRefundReversalResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get reversed => $_getBF(0);
  @$pb.TagNumber(1)
  set reversed($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasReversed() => $_has(0);
  @$pb.TagNumber(1)
  void clearReversed() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.bool get duplicateReplay => $_getBF(1);
  @$pb.TagNumber(2)
  set duplicateReplay($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasDuplicateReplay() => $_has(1);
  @$pb.TagNumber(2)
  void clearDuplicateReplay() => $_clearField(2);

  @$pb.TagNumber(3)
  ReferralStatus get status => $_getN(2);
  @$pb.TagNumber(3)
  set status(ReferralStatus value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasStatus() => $_has(2);
  @$pb.TagNumber(3)
  void clearStatus() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get creditsReversed => $_getSZ(3);
  @$pb.TagNumber(4)
  set creditsReversed($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasCreditsReversed() => $_has(3);
  @$pb.TagNumber(4)
  void clearCreditsReversed() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get reversalTransactionId => $_getSZ(4);
  @$pb.TagNumber(5)
  set reversalTransactionId($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasReversalTransactionId() => $_has(4);
  @$pb.TagNumber(5)
  void clearReversalTransactionId() => $_clearField(5);
}

class ReviewFraudCaseRequest extends $pb.GeneratedMessage {
  factory ReviewFraudCaseRequest({
    $core.String? referralId,
    $core.String? adminAction,
    $core.String? notes,
  }) {
    final result = ReviewFraudCaseRequest._();
    if (referralId != null) result.referralId = referralId;
    if (adminAction != null) result.adminAction = adminAction;
    if (notes != null) result.notes = notes;
    return result;
  }

  ReviewFraudCaseRequest._();

  factory ReviewFraudCaseRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ReviewFraudCaseRequest()..mergeFromBuffer(data, registry);
  factory ReviewFraudCaseRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ReviewFraudCaseRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ReviewFraudCaseRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.platform.v1'),
      createEmptyInstance: ReviewFraudCaseRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'referralId')
    ..aOS(2, _omitFieldNames ? '' : 'adminAction')
    ..aOS(3, _omitFieldNames ? '' : 'notes')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReviewFraudCaseRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReviewFraudCaseRequest copyWith(
          void Function(ReviewFraudCaseRequest) updates) =>
      super.copyWith((message) => updates(message as ReviewFraudCaseRequest))
          as ReviewFraudCaseRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ReviewFraudCaseRequest() / ReviewFraudCaseRequest.new instead')
  static ReviewFraudCaseRequest create() => ReviewFraudCaseRequest._();
  static $pb.GeneratedMessage $_createMessage() => ReviewFraudCaseRequest._();
  @$core.override
  ReviewFraudCaseRequest createEmptyInstance() => ReviewFraudCaseRequest._();
  @$core.pragma('dart2js:noInline')
  static ReviewFraudCaseRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ReviewFraudCaseRequest>(
          ReviewFraudCaseRequest.$_createMessage);
  static ReviewFraudCaseRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get referralId => $_getSZ(0);
  @$pb.TagNumber(1)
  set referralId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasReferralId() => $_has(0);
  @$pb.TagNumber(1)
  void clearReferralId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get adminAction => $_getSZ(1);
  @$pb.TagNumber(2)
  set adminAction($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasAdminAction() => $_has(1);
  @$pb.TagNumber(2)
  void clearAdminAction() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get notes => $_getSZ(2);
  @$pb.TagNumber(3)
  set notes($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasNotes() => $_has(2);
  @$pb.TagNumber(3)
  void clearNotes() => $_clearField(3);
}

class ReviewFraudCaseResponse extends $pb.GeneratedMessage {
  factory ReviewFraudCaseResponse({
    $core.bool? success,
    ReferralStatus? status,
    $core.String? resolutionAction,
  }) {
    final result = ReviewFraudCaseResponse._();
    if (success != null) result.success = success;
    if (status != null) result.status = status;
    if (resolutionAction != null) result.resolutionAction = resolutionAction;
    return result;
  }

  ReviewFraudCaseResponse._();

  factory ReviewFraudCaseResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ReviewFraudCaseResponse()..mergeFromBuffer(data, registry);
  factory ReviewFraudCaseResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      ReviewFraudCaseResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ReviewFraudCaseResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.platform.v1'),
      createEmptyInstance: ReviewFraudCaseResponse.$_createMessage)
    ..aOB(1, _omitFieldNames ? '' : 'success')
    ..aE<ReferralStatus>(2, _omitFieldNames ? '' : 'status',
        enumValues: ReferralStatus.values)
    ..aOS(3, _omitFieldNames ? '' : 'resolutionAction')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReviewFraudCaseResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReviewFraudCaseResponse copyWith(
          void Function(ReviewFraudCaseResponse) updates) =>
      super.copyWith((message) => updates(message as ReviewFraudCaseResponse))
          as ReviewFraudCaseResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use ReviewFraudCaseResponse() / ReviewFraudCaseResponse.new instead')
  static ReviewFraudCaseResponse create() => ReviewFraudCaseResponse._();
  static $pb.GeneratedMessage $_createMessage() => ReviewFraudCaseResponse._();
  @$core.override
  ReviewFraudCaseResponse createEmptyInstance() => ReviewFraudCaseResponse._();
  @$core.pragma('dart2js:noInline')
  static ReviewFraudCaseResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ReviewFraudCaseResponse>(
          ReviewFraudCaseResponse.$_createMessage);
  static ReviewFraudCaseResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get success => $_getBF(0);
  @$pb.TagNumber(1)
  set success($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSuccess() => $_has(0);
  @$pb.TagNumber(1)
  void clearSuccess() => $_clearField(1);

  @$pb.TagNumber(2)
  ReferralStatus get status => $_getN(1);
  @$pb.TagNumber(2)
  set status(ReferralStatus value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasStatus() => $_has(1);
  @$pb.TagNumber(2)
  void clearStatus() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get resolutionAction => $_getSZ(2);
  @$pb.TagNumber(3)
  set resolutionAction($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasResolutionAction() => $_has(2);
  @$pb.TagNumber(3)
  void clearResolutionAction() => $_clearField(3);
}

class RedeemPromoCodeRequest extends $pb.GeneratedMessage {
  factory RedeemPromoCodeRequest({
    $core.String? workspaceId,
    $core.String? promoCode,
    $core.String? idempotencyKey,
  }) {
    final result = RedeemPromoCodeRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    if (promoCode != null) result.promoCode = promoCode;
    if (idempotencyKey != null) result.idempotencyKey = idempotencyKey;
    return result;
  }

  RedeemPromoCodeRequest._();

  factory RedeemPromoCodeRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RedeemPromoCodeRequest()..mergeFromBuffer(data, registry);
  factory RedeemPromoCodeRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RedeemPromoCodeRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RedeemPromoCodeRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.platform.v1'),
      createEmptyInstance: RedeemPromoCodeRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..aOS(2, _omitFieldNames ? '' : 'promoCode')
    ..aOS(3, _omitFieldNames ? '' : 'idempotencyKey')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RedeemPromoCodeRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RedeemPromoCodeRequest copyWith(
          void Function(RedeemPromoCodeRequest) updates) =>
      super.copyWith((message) => updates(message as RedeemPromoCodeRequest))
          as RedeemPromoCodeRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use RedeemPromoCodeRequest() / RedeemPromoCodeRequest.new instead')
  static RedeemPromoCodeRequest create() => RedeemPromoCodeRequest._();
  static $pb.GeneratedMessage $_createMessage() => RedeemPromoCodeRequest._();
  @$core.override
  RedeemPromoCodeRequest createEmptyInstance() => RedeemPromoCodeRequest._();
  @$core.pragma('dart2js:noInline')
  static RedeemPromoCodeRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RedeemPromoCodeRequest>(
          RedeemPromoCodeRequest.$_createMessage);
  static RedeemPromoCodeRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get promoCode => $_getSZ(1);
  @$pb.TagNumber(2)
  set promoCode($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPromoCode() => $_has(1);
  @$pb.TagNumber(2)
  void clearPromoCode() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get idempotencyKey => $_getSZ(2);
  @$pb.TagNumber(3)
  set idempotencyKey($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasIdempotencyKey() => $_has(2);
  @$pb.TagNumber(3)
  void clearIdempotencyKey() => $_clearField(3);
}

class RedeemPromoCodeResponse extends $pb.GeneratedMessage {
  factory RedeemPromoCodeResponse({
    $core.bool? success,
    $core.String? creditsAwarded,
    $core.String? newBalance,
    $core.String? transactionId,
  }) {
    final result = RedeemPromoCodeResponse._();
    if (success != null) result.success = success;
    if (creditsAwarded != null) result.creditsAwarded = creditsAwarded;
    if (newBalance != null) result.newBalance = newBalance;
    if (transactionId != null) result.transactionId = transactionId;
    return result;
  }

  RedeemPromoCodeResponse._();

  factory RedeemPromoCodeResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RedeemPromoCodeResponse()..mergeFromBuffer(data, registry);
  factory RedeemPromoCodeResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      RedeemPromoCodeResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RedeemPromoCodeResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.platform.v1'),
      createEmptyInstance: RedeemPromoCodeResponse.$_createMessage)
    ..aOB(1, _omitFieldNames ? '' : 'success')
    ..aOS(2, _omitFieldNames ? '' : 'creditsAwarded')
    ..aOS(3, _omitFieldNames ? '' : 'newBalance')
    ..aOS(4, _omitFieldNames ? '' : 'transactionId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RedeemPromoCodeResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RedeemPromoCodeResponse copyWith(
          void Function(RedeemPromoCodeResponse) updates) =>
      super.copyWith((message) => updates(message as RedeemPromoCodeResponse))
          as RedeemPromoCodeResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use RedeemPromoCodeResponse() / RedeemPromoCodeResponse.new instead')
  static RedeemPromoCodeResponse create() => RedeemPromoCodeResponse._();
  static $pb.GeneratedMessage $_createMessage() => RedeemPromoCodeResponse._();
  @$core.override
  RedeemPromoCodeResponse createEmptyInstance() => RedeemPromoCodeResponse._();
  @$core.pragma('dart2js:noInline')
  static RedeemPromoCodeResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RedeemPromoCodeResponse>(
          RedeemPromoCodeResponse.$_createMessage);
  static RedeemPromoCodeResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get success => $_getBF(0);
  @$pb.TagNumber(1)
  set success($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSuccess() => $_has(0);
  @$pb.TagNumber(1)
  void clearSuccess() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get creditsAwarded => $_getSZ(1);
  @$pb.TagNumber(2)
  set creditsAwarded($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCreditsAwarded() => $_has(1);
  @$pb.TagNumber(2)
  void clearCreditsAwarded() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get newBalance => $_getSZ(2);
  @$pb.TagNumber(3)
  set newBalance($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasNewBalance() => $_has(2);
  @$pb.TagNumber(3)
  void clearNewBalance() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get transactionId => $_getSZ(3);
  @$pb.TagNumber(4)
  set transactionId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasTransactionId() => $_has(3);
  @$pb.TagNumber(4)
  void clearTransactionId() => $_clearField(4);
}

class GetActivePromotionsRequest extends $pb.GeneratedMessage {
  factory GetActivePromotionsRequest({
    $core.String? workspaceId,
  }) {
    final result = GetActivePromotionsRequest._();
    if (workspaceId != null) result.workspaceId = workspaceId;
    return result;
  }

  GetActivePromotionsRequest._();

  factory GetActivePromotionsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetActivePromotionsRequest()..mergeFromBuffer(data, registry);
  factory GetActivePromotionsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetActivePromotionsRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetActivePromotionsRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.platform.v1'),
      createEmptyInstance: GetActivePromotionsRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetActivePromotionsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetActivePromotionsRequest copyWith(
          void Function(GetActivePromotionsRequest) updates) =>
      super.copyWith(
              (message) => updates(message as GetActivePromotionsRequest))
          as GetActivePromotionsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use GetActivePromotionsRequest() / GetActivePromotionsRequest.new instead')
  static GetActivePromotionsRequest create() => GetActivePromotionsRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      GetActivePromotionsRequest._();
  @$core.override
  GetActivePromotionsRequest createEmptyInstance() =>
      GetActivePromotionsRequest._();
  @$core.pragma('dart2js:noInline')
  static GetActivePromotionsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetActivePromotionsRequest>(
          GetActivePromotionsRequest.$_createMessage);
  static GetActivePromotionsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workspaceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceId() => $_clearField(1);
}

class GetActivePromotionsResponse extends $pb.GeneratedMessage {
  factory GetActivePromotionsResponse({
    $core.Iterable<PromotionalCampaign>? campaigns,
  }) {
    final result = GetActivePromotionsResponse._();
    if (campaigns != null) result.campaigns.addAll(campaigns);
    return result;
  }

  GetActivePromotionsResponse._();

  factory GetActivePromotionsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetActivePromotionsResponse()..mergeFromBuffer(data, registry);
  factory GetActivePromotionsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetActivePromotionsResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetActivePromotionsResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.platform.v1'),
      createEmptyInstance: GetActivePromotionsResponse.$_createMessage)
    ..pPM<PromotionalCampaign>(1, _omitFieldNames ? '' : 'campaigns',
        subBuilder: PromotionalCampaign.$_createMessage)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetActivePromotionsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetActivePromotionsResponse copyWith(
          void Function(GetActivePromotionsResponse) updates) =>
      super.copyWith(
              (message) => updates(message as GetActivePromotionsResponse))
          as GetActivePromotionsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use GetActivePromotionsResponse() / GetActivePromotionsResponse.new instead')
  static GetActivePromotionsResponse create() =>
      GetActivePromotionsResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      GetActivePromotionsResponse._();
  @$core.override
  GetActivePromotionsResponse createEmptyInstance() =>
      GetActivePromotionsResponse._();
  @$core.pragma('dart2js:noInline')
  static GetActivePromotionsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetActivePromotionsResponse>(
          GetActivePromotionsResponse.$_createMessage);
  static GetActivePromotionsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<PromotionalCampaign> get campaigns => $_getList(0);
}

class GetPromotionDetailRequest extends $pb.GeneratedMessage {
  factory GetPromotionDetailRequest({
    $core.String? campaignId,
  }) {
    final result = GetPromotionDetailRequest._();
    if (campaignId != null) result.campaignId = campaignId;
    return result;
  }

  GetPromotionDetailRequest._();

  factory GetPromotionDetailRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetPromotionDetailRequest()..mergeFromBuffer(data, registry);
  factory GetPromotionDetailRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetPromotionDetailRequest()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetPromotionDetailRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.platform.v1'),
      createEmptyInstance: GetPromotionDetailRequest.$_createMessage)
    ..aOS(1, _omitFieldNames ? '' : 'campaignId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetPromotionDetailRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetPromotionDetailRequest copyWith(
          void Function(GetPromotionDetailRequest) updates) =>
      super.copyWith((message) => updates(message as GetPromotionDetailRequest))
          as GetPromotionDetailRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use GetPromotionDetailRequest() / GetPromotionDetailRequest.new instead')
  static GetPromotionDetailRequest create() => GetPromotionDetailRequest._();
  static $pb.GeneratedMessage $_createMessage() =>
      GetPromotionDetailRequest._();
  @$core.override
  GetPromotionDetailRequest createEmptyInstance() =>
      GetPromotionDetailRequest._();
  @$core.pragma('dart2js:noInline')
  static GetPromotionDetailRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetPromotionDetailRequest>(
          GetPromotionDetailRequest.$_createMessage);
  static GetPromotionDetailRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get campaignId => $_getSZ(0);
  @$pb.TagNumber(1)
  set campaignId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCampaignId() => $_has(0);
  @$pb.TagNumber(1)
  void clearCampaignId() => $_clearField(1);
}

class GetPromotionDetailResponse extends $pb.GeneratedMessage {
  factory GetPromotionDetailResponse({
    PromotionalCampaign? campaign,
    $core.bool? isEligible,
  }) {
    final result = GetPromotionDetailResponse._();
    if (campaign != null) result.campaign = campaign;
    if (isEligible != null) result.isEligible = isEligible;
    return result;
  }

  GetPromotionDetailResponse._();

  factory GetPromotionDetailResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetPromotionDetailResponse()..mergeFromBuffer(data, registry);
  factory GetPromotionDetailResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      GetPromotionDetailResponse()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetPromotionDetailResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'creativanta.platform.v1'),
      createEmptyInstance: GetPromotionDetailResponse.$_createMessage)
    ..aOM<PromotionalCampaign>(1, _omitFieldNames ? '' : 'campaign',
        subBuilder: PromotionalCampaign.$_createMessage)
    ..aOB(2, _omitFieldNames ? '' : 'isEligible')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetPromotionDetailResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetPromotionDetailResponse copyWith(
          void Function(GetPromotionDetailResponse) updates) =>
      super.copyWith(
              (message) => updates(message as GetPromotionDetailResponse))
          as GetPromotionDetailResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated(
      'Use GetPromotionDetailResponse() / GetPromotionDetailResponse.new instead')
  static GetPromotionDetailResponse create() => GetPromotionDetailResponse._();
  static $pb.GeneratedMessage $_createMessage() =>
      GetPromotionDetailResponse._();
  @$core.override
  GetPromotionDetailResponse createEmptyInstance() =>
      GetPromotionDetailResponse._();
  @$core.pragma('dart2js:noInline')
  static GetPromotionDetailResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetPromotionDetailResponse>(
          GetPromotionDetailResponse.$_createMessage);
  static GetPromotionDetailResponse? _defaultInstance;

  @$pb.TagNumber(1)
  PromotionalCampaign get campaign => $_getN(0);
  @$pb.TagNumber(1)
  set campaign(PromotionalCampaign value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasCampaign() => $_has(0);
  @$pb.TagNumber(1)
  void clearCampaign() => $_clearField(1);
  @$pb.TagNumber(1)
  PromotionalCampaign ensureCampaign() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.bool get isEligible => $_getBF(1);
  @$pb.TagNumber(2)
  set isEligible($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasIsEligible() => $_has(1);
  @$pb.TagNumber(2)
  void clearIsEligible() => $_clearField(2);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');

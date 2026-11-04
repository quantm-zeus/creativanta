import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:creativanta_mobile/generated/creativanta/platform/v1/referral.pb.dart' as pb;
import 'package:creativanta_mobile/referral/referral_models.dart';
import 'package:creativanta_mobile/ui/referral/referral_screen.dart';

void main() {
  group('P8-05 Mobile Referral Center (M062)', () {
    // ------------------------------------------------------------------------
    // Target 1: No immediate qualified reward on pending payment
    // ------------------------------------------------------------------------
    test('Target 1: withholds reward on pending or unpaid payment', () {
      final pendingResult = evaluatePaymentQualification(
        paymentStatus: 'pending',
        currentStatus: MobileReferralStatus.pending,
      );
      expect(pendingResult.canReward, isFalse);
      expect(pendingResult.nextStatus, equals(MobileReferralStatus.pending));
      expect(pendingResult.heldReason, contains('đang chờ xử lý'));

      final unpaidResult = evaluatePaymentQualification(
        paymentStatus: 'unpaid',
        currentStatus: MobileReferralStatus.pending,
      );
      expect(unpaidResult.canReward, isFalse);
      expect(unpaidResult.nextStatus, equals(MobileReferralStatus.pending));

      final paidResult = evaluatePaymentQualification(
        paymentStatus: 'paid',
        currentStatus: MobileReferralStatus.pending,
      );
      expect(paidResult.canReward, isTrue);
      expect(paidResult.nextStatus, equals(MobileReferralStatus.rewarded));
    });

    // ------------------------------------------------------------------------
    // Target 2: Self-referral held for review
    // ------------------------------------------------------------------------
    test('Target 2: flags self-referral for review on matching signals', () {
      // Same user ID
      final userMatch = evaluateSelfReferral(
        referrerWorkspaceId: 'ws-1',
        refereeWorkspaceId: 'ws-2',
        referrerUserId: 'usr-same',
        refereeUserId: 'usr-same',
      );
      expect(userMatch.isSelfReferral, isTrue);
      expect(userMatch.reason, contains('người dùng'));

      // Same workspace ID
      final wsMatch = evaluateSelfReferral(
        referrerWorkspaceId: 'ws-same',
        refereeWorkspaceId: 'ws-same',
      );
      expect(wsMatch.isSelfReferral, isTrue);
      expect(wsMatch.reason, contains('Không gian làm việc'));

      // IP match
      final ipMatch = evaluateSelfReferral(
        referrerWorkspaceId: 'ws-1',
        refereeWorkspaceId: 'ws-2',
        ipMatch: true,
      );
      expect(ipMatch.isSelfReferral, isTrue);
      expect(ipMatch.reason, contains('IP'));

      // Device match
      final devMatch = evaluateSelfReferral(
        referrerWorkspaceId: 'ws-1',
        refereeWorkspaceId: 'ws-2',
        deviceMatch: true,
      );
      expect(devMatch.isSelfReferral, isTrue);
      expect(devMatch.reason, contains('thiết bị'));

      // Card match
      final cardMatch = evaluateSelfReferral(
        referrerWorkspaceId: 'ws-1',
        refereeWorkspaceId: 'ws-2',
        cardMatch: true,
      );
      expect(cardMatch.isSelfReferral, isTrue);
      expect(cardMatch.reason, contains('thẻ'));

      // Clean referral
      final clean = evaluateSelfReferral(
        referrerWorkspaceId: 'ws-1',
        refereeWorkspaceId: 'ws-2',
        referrerUserId: 'usr-1',
        refereeUserId: 'usr-2',
      );
      expect(clean.isSelfReferral, isFalse);
    });

    // ------------------------------------------------------------------------
    // Target 3: Replay / refund reverses once
    // ------------------------------------------------------------------------
    test('Target 3: refund reverses once and prevents duplicate debits', () {
      final firstReversal = evaluateRefundReversal(MobileReferralStatus.rewarded);
      expect(firstReversal.canReverse, isTrue);
      expect(firstReversal.isDuplicateReplay, isFalse);
      expect(firstReversal.nextStatus, equals(MobileReferralStatus.revoked));

      // Duplicate replay
      final duplicateReplay = evaluateRefundReversal(MobileReferralStatus.revoked);
      expect(duplicateReplay.canReverse, isFalse);
      expect(duplicateReplay.isDuplicateReplay, isTrue);
      expect(duplicateReplay.nextStatus, equals(MobileReferralStatus.revoked));
      expect(duplicateReplay.message, contains('Idempotent Replay'));
    });

    // ------------------------------------------------------------------------
    // Tier Progression
    // ------------------------------------------------------------------------
    test('computes mobile tier progression and recurring commission rates', () {
      final bronze = calculateMobileTier(3);
      expect(bronze.currentTier, equals(MobileReferralTier.bronze));
      expect(bronze.rewardMultiplier, equals('1.0x'));
      expect(bronze.recurringCommissionPercent, equals(0.0));

      final silver = calculateMobileTier(12);
      expect(silver.currentTier, equals(MobileReferralTier.silver));
      expect(silver.rewardMultiplier, equals('1.5x'));
      expect(silver.referralsToNextTier, equals(9));

      final gold = calculateMobileTier(25);
      expect(gold.currentTier, equals(MobileReferralTier.gold));
      expect(gold.rewardMultiplier, equals('2.0x'));
      expect(gold.recurringCommissionPercent, equals(10.0));

      final platinum = calculateMobileTier(60);
      expect(platinum.currentTier, equals(MobileReferralTier.platinum));
      expect(platinum.rewardMultiplier, equals('2.5x'));
      expect(platinum.recurringCommissionPercent, equals(15.0));
      expect(platinum.progressPercent, equals(1.0));
    });

    // ------------------------------------------------------------------------
    // Protobuf Serialization Roundtrip
    // ------------------------------------------------------------------------
    test('protobuf GetDashboardResponse roundtrips cleanly', () {
      final pbMsg = pb.GetDashboardResponse(
        referralCode: 'QUANNG2026',
        shareUrl: 'https://creativanta.vn/r/QUANNG2026',
        funnel: pb.ReferralFunnel(
          totalClicks: Int64(45),
          totalSignups: Int64(12),
          totalPaid: Int64(3),
          clickToSignupRate: 0.266,
          signupToPaidRate: 0.25,
          creditsEarnedTotal: '150.000000',
          creditsPendingTotal: '75.000000',
        ),
        tier: pb.TierProgress(
          currentTier: pb.ReferralTier.REFERRAL_TIER_SILVER,
          nextTier: pb.ReferralTier.REFERRAL_TIER_GOLD,
          qualifiedReferralsCount: 12,
          referralsToNextTier: 9,
          progressPercentage: 80.0,
          currentRewardMultiplier: '1.5',
          recurringCommissionRate: '0.000000',
        ),
        recentReferrals: [
          pb.ReferralRecord(
            referralId: 'ref-001',
            refereeName: 'Nguyễn Văn A',
            planTier: 'pro',
            status: pb.ReferralStatus.REFERRAL_STATUS_REWARDED,
            referrerCreditsAwarded: '75.000000',
          ),
        ],
      );

      final bytes = pbMsg.writeToBuffer();
      final roundtripped = pb.GetDashboardResponse.fromBuffer(bytes);

      expect(roundtripped.referralCode, equals('QUANNG2026'));
      expect(roundtripped.funnel.totalClicks.toInt(), equals(45));
      expect(roundtripped.funnel.totalSignups.toInt(), equals(12));
      expect(roundtripped.tier.currentTier, equals(pb.ReferralTier.REFERRAL_TIER_SILVER));
      expect(roundtripped.recentReferrals.length, equals(1));
      expect(roundtripped.recentReferrals.first.refereeName, equals('Nguyễn Văn A'));
    });

    // ------------------------------------------------------------------------
    // Widget Rendering Test (M062)
    // ------------------------------------------------------------------------
    testWidgets('renders MobileReferralScreen with link, funnel, and tiers', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: MobileReferralScreen(
            initialReferralCode: 'TESTREF2026',
            initialQualifiedCount: 12,
          ),
        ),
      );

      // Verify AppBar
      expect(find.text('Giới thiệu bạn bè'), findsOneWidget);

      // Verify Referral Link card
      expect(find.text('creativanta.vn/r/TESTREF2026'), findsOneWidget);
      expect(find.byKey(const Key('copy_button')), findsOneWidget);

      // Verify Funnel
      expect(find.text('📊 Phễu chuyển đổi tăng trưởng'), findsOneWidget);
      expect(find.text('👆 Lượt Click'), findsOneWidget);
      expect(find.text('45'), findsOneWidget);
      expect(find.text('12'), findsOneWidget);
      expect(find.text('3'), findsOneWidget);

      // Verify History
      expect(find.text('👥 Lịch sử giới thiệu'), findsOneWidget);
      expect(find.text('👤 Nguyễn A'), findsOneWidget);
    });
  });
}

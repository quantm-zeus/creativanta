import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:creativanta_mobile/production/ab_test_coach_models.dart';
import 'package:creativanta_mobile/ui/production/performance_coach_view.dart';

void main() {
  group('P5-05: Experiment Lab & Performance Coach (Mobile Acceptance Targets)', () {
    // ========================================================================
    // Acceptance Target 1: Low Exposure -> Inconclusive
    // Under canonical threshold (<1,000 views per variant or duration < 48h or zero views),
    // experiment MUST yield status = completed, resultStatus = inconclusive, winner = null.
    // ========================================================================
    test('Acceptance Target 1: returns inconclusive when variants have low exposure (<1000 views per variant)', () {
      final now = DateTime.now();
      final exp = ABExperimentModel(
        id: 'exp-low-01',
        title: 'Low views experiment',
        baseAssetId: 'asset-base-01',
        targetPlatform: 'tiktok',
        status: 'running',
        resultStatus: 'pending',
        confidenceLevel: 0.0,
        startedAt: now.subtract(const Duration(hours: 72)),
        criteria: const AutoWinnerCriteriaModel(
          metric: 'ctr',
          minDurationHours: 48,
          minSamplePerVariant: 1000,
          liftThresholdPercent: 10.0,
        ),
        variants: const [
          ABVariantModel(
            variantId: 'var-a',
            assetId: 'asset-var-a',
            label: 'Thumbnail A',
            variantType: 'thumbnail',
            impressions: 450,
            views: 450,
            clicks: 45,
            conversions: 10,
            clickThroughRate: 0.10,
            conversionRate: 0.022,
            isWinner: false,
          ),
          ABVariantModel(
            variantId: 'var-b',
            assetId: 'asset-var-b',
            label: 'Thumbnail B',
            variantType: 'thumbnail',
            impressions: 480,
            views: 480,
            clicks: 20,
            conversions: 5,
            clickThroughRate: 0.041,
            conversionRate: 0.010,
            isWinner: false,
          ),
        ],
      );

      final result = evaluateABExperiment(exp, evaluatedAt: now);

      expect(result.status, equals('completed'));
      expect(result.resultStatus, equals('inconclusive'));
      expect(result.winnerAssetId, isNull);
      expect(result.confidenceLevel, equals(0.0));
      expect(result.isObservational, isTrue);
      expect(result.observationalNotice, equals(kStandardObservationalNotice));
    });

    test('Acceptance Target 1: returns inconclusive when experiment duration is under 48 hours', () {
      final now = DateTime.now();
      final exp = ABExperimentModel(
        id: 'exp-short-01',
        title: 'Short duration experiment',
        baseAssetId: 'asset-base-01',
        targetPlatform: 'tiktok',
        status: 'running',
        resultStatus: 'pending',
        confidenceLevel: 0.0,
        startedAt: now.subtract(const Duration(hours: 24)), // Only 24h
        criteria: const AutoWinnerCriteriaModel(
          metric: 'ctr',
          minDurationHours: 48,
          minSamplePerVariant: 1000,
        ),
        variants: const [
          ABVariantModel(
            variantId: 'var-a',
            assetId: 'asset-var-a',
            label: 'Thumbnail A',
            variantType: 'thumbnail',
            impressions: 2500,
            views: 2500,
            clicks: 250,
            conversions: 50,
            clickThroughRate: 0.10,
            conversionRate: 0.02,
            isWinner: false,
          ),
          ABVariantModel(
            variantId: 'var-b',
            assetId: 'asset-var-b',
            label: 'Thumbnail B',
            variantType: 'thumbnail',
            impressions: 2600,
            views: 2600,
            clicks: 120,
            conversions: 20,
            clickThroughRate: 0.046,
            conversionRate: 0.007,
            isWinner: false,
          ),
        ],
      );

      final result = evaluateABExperiment(exp, evaluatedAt: now);

      expect(result.status, equals('completed'));
      expect(result.resultStatus, equals('inconclusive'));
      expect(result.winnerAssetId, isNull);
      expect(result.isObservational, isTrue);
    });

    test('Acceptance Target 1: safely handles zero exposure / empty variants without division by zero', () {
      final now = DateTime.now();
      final exp = ABExperimentModel(
        id: 'exp-zero-01',
        title: 'Zero views test',
        baseAssetId: 'asset-base-01',
        targetPlatform: 'tiktok',
        status: 'running',
        resultStatus: 'pending',
        confidenceLevel: 0.0,
        criteria: const AutoWinnerCriteriaModel(),
        variants: const [
          ABVariantModel(
            variantId: 'var-a',
            assetId: 'asset-var-a',
            label: 'Thumbnail A',
            variantType: 'thumbnail',
            impressions: 0,
            views: 0,
            clicks: 0,
            conversions: 0,
            clickThroughRate: 0.0,
            conversionRate: 0.0,
            isWinner: false,
          ),
        ],
      );

      final result = evaluateABExperiment(exp, evaluatedAt: now);

      expect(result.status, equals('completed'));
      expect(result.resultStatus, equals('inconclusive'));
      expect(result.winnerAssetId, isNull);
      expect(result.isObservational, isTrue);
    });

    // ========================================================================
    // Acceptance Target 2: Observational Label Retained
    // All scorecards, benchmarks, and conclusive results must retain isObservational: true.
    // ========================================================================
    test('Acceptance Target 2: retains observational label even when test is statistically conclusive with a winner', () {
      final now = DateTime.now();
      final exp = ABExperimentModel(
        id: 'exp-conclusive-01',
        title: 'Adequate sample experiment',
        baseAssetId: 'asset-base-01',
        targetPlatform: 'tiktok',
        status: 'running',
        resultStatus: 'pending',
        confidenceLevel: 0.0,
        startedAt: now.subtract(const Duration(hours: 72)),
        criteria: const AutoWinnerCriteriaModel(
          metric: 'ctr',
          minDurationHours: 48,
          minSamplePerVariant: 1000,
          liftThresholdPercent: 10.0,
        ),
        variants: const [
          ABVariantModel(
            variantId: 'var-a',
            assetId: 'asset-var-a',
            label: 'Thumbnail A',
            variantType: 'thumbnail',
            impressions: 5000,
            views: 5000,
            clicks: 500, // CTR: 10%
            conversions: 100,
            clickThroughRate: 0.10,
            conversionRate: 0.02,
            isWinner: false,
          ),
          ABVariantModel(
            variantId: 'var-b',
            assetId: 'asset-var-b',
            label: 'Thumbnail B',
            variantType: 'thumbnail',
            impressions: 5200,
            views: 5200,
            clicks: 260, // CTR: 5%
            conversions: 50,
            clickThroughRate: 0.05,
            conversionRate: 0.009,
            isWinner: false,
          ),
        ],
      );

      final result = evaluateABExperiment(exp, evaluatedAt: now);

      expect(result.status, equals('completed'));
      expect(result.resultStatus, equals('conclusive'));
      expect(result.winnerAssetId, equals('asset-var-a'));
      expect(result.confidenceLevel, equals(0.95));
      expect(result.isObservational, isTrue);
      expect(result.observationalNotice, equals(kStandardObservationalNotice));
      expect(result.variants.firstWhere((v) => v.variantId == 'var-a').isWinner, isTrue);
      expect(result.variants.firstWhere((v) => v.variantId == 'var-b').isWinner, isFalse);
    });

    test('Acceptance Target 2: validates scorecard and benchmark comparison retain observational label', () {
      const scorecard = VideoScorecardModel(
        videoId: 'vid-01',
        title: 'Video Title',
        overallScore: 82.0,
        letterGrade: 'A-',
        engagementRate: 8.2,
        retentionRate: 58.0,
        clickThroughRate: 6.4,
        isObservational: true,
        keyObservations: ['Observation 1'],
      );
      expect(scorecard.isObservational, isTrue);
      expect(scorecard.observationalNotice, equals(kStandardObservationalNotice));

      const comparison = IndustryComparisonModel(
        accountRate: 8.2,
        industryP50: 4.8,
        percentileRank: 84.0,
        deltaVsMedian: 3.4,
        isObservational: true,
      );
      expect(comparison.isObservational, isTrue);
      expect(comparison.observationalNotice, equals(kStandardObservationalNotice));
    });

    // ========================================================================
    // Acceptance Target 3: Scaling Rechecks M11 Gates
    // Gate 1: Permission (publish:execute / Editor+)
    // Gate 2: Platform Capability (connector active & supported)
    // Gate 3: Policy Compliance (Packaging QA scan free of hard blocks)
    // Gate 4: Duplicate-post Gate (cooldown 24h)
    // ========================================================================
    final conclusiveExp = ABExperimentModel(
      id: 'exp-winner-01',
      title: 'Winner Experiment',
      baseAssetId: 'asset-base-01',
      targetPlatform: 'tiktok',
      status: 'completed',
      resultStatus: 'conclusive',
      winnerAssetId: 'asset-winner-01',
      confidenceLevel: 0.95,
      isObservational: true,
      criteria: const AutoWinnerCriteriaModel(),
      variants: const [],
    );

    test('Acceptance Target 3: Gate 1 failure rejects scaling if caller lacks publish permission', () {
      expect(
        () => scaleExperimentWinner(
          experiment: conclusiveExp,
          callerRole: 'Contributor',
          platformConnectorActive: true,
          platformConnectorSupported: true,
          packagingQaBlocked: false,
          lastPostTime: null,
        ),
        throwsA(isA<ScalingGateException>().having((e) => e.gate, 'gate', 'M11-GATE-1-PERMISSION')),
      );
    });

    test('Acceptance Target 3: Gate 2 failure rejects scaling if platform connector is inactive or unsupported', () {
      expect(
        () => scaleExperimentWinner(
          experiment: conclusiveExp,
          callerRole: 'Editor',
          platformConnectorActive: false, // inactive
          platformConnectorSupported: true,
          packagingQaBlocked: false,
          lastPostTime: null,
        ),
        throwsA(isA<ScalingGateException>().having((e) => e.gate, 'gate', 'M11-GATE-2-CAPABILITY')),
      );
    });

    test('Acceptance Target 3: Gate 3 failure rejects scaling if packaging QA compliance is blocked', () {
      expect(
        () => scaleExperimentWinner(
          experiment: conclusiveExp,
          callerRole: 'Editor',
          platformConnectorActive: true,
          platformConnectorSupported: true,
          packagingQaBlocked: true, // hard blocked
          lastPostTime: null,
        ),
        throwsA(isA<ScalingGateException>().having((e) => e.gate, 'gate', 'M11-GATE-3-POLICY')),
      );
    });

    test('Acceptance Target 3: Gate 4 failure rejects scaling if duplicate post is within 24h cooldown', () {
      final now = DateTime.now();
      expect(
        () => scaleExperimentWinner(
          experiment: conclusiveExp,
          callerRole: 'Editor',
          platformConnectorActive: true,
          platformConnectorSupported: true,
          packagingQaBlocked: false,
          lastPostTime: now.subtract(const Duration(hours: 6)), // 6h ago < 24h
          currentTime: now,
        ),
        throwsA(isA<ScalingGateException>().having((e) => e.gate, 'gate', 'M11-GATE-4-COOLDOWN')),
      );
    });

    test('Acceptance Target 3: All 4 Gates Pass allows scaling and retains observational label', () {
      final now = DateTime.now();
      final scaled = scaleExperimentWinner(
        experiment: conclusiveExp,
        callerRole: 'Editor',
        platformConnectorActive: true,
        platformConnectorSupported: true,
        packagingQaBlocked: false,
        lastPostTime: now.subtract(const Duration(hours: 36)), // > 24h
        currentTime: now,
      );

      expect(scaled.resultStatus, equals('scaled'));
      expect(scaled.isObservational, isTrue);
    });

    // ========================================================================
    // Widget Test: Screen M039 Performance Coach
    // ========================================================================
    testWidgets('Screen M039: Performance Coach renders score, observational badge, and recommendations', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        const MaterialApp(
          home: PerformanceCoachView(),
        ),
      );
      await tester.pump();

      // Verify Screen title
      expect(find.text('Performance Coach'), findsOneWidget);

      // Verify Weekly Score & Grade
      expect(find.text('📊 Weekly Quality Score'), findsOneWidget);
      expect(find.text('82/100'), findsOneWidget);
      expect(find.text('A-'), findsOneWidget);

      // Verify Observational Notice
      expect(find.text(kStandardObservationalNotice), findsOneWidget);

      // Verify Recommendations
      expect(find.text('Post more "tips" content'), findsOneWidget);
      expect(find.text('Post at 19:00'), findsOneWidget);
      expect(find.text('Add CTA overlay at 0:15'), findsOneWidget);
    });
  });
}

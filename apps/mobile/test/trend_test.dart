import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:creativanta_mobile/generated/creativanta/intelligence/v1/trend.pbenum.dart';
import 'package:creativanta_mobile/trend/trend_models.dart';
import 'package:creativanta_mobile/ui/trend/trend_radar_view.dart';

void main() {
  group('Mobile Trend Fusion Radar (M02) Unit Tests', () {
    test('Multi-dimensional scoring calculation (RULE-M02-002)', () {
      // 100 vel, 100 freshness, 0 saturation => 100
      expect(TrendSummary.calculateStrengthScore(100.0, 100.0, 0.0), 100.0);

      // 0 vel, 0 freshness, 100 saturation => 0
      expect(TrendSummary.calculateStrengthScore(0.0, 0.0, 100.0), 0.0);

      // 80 vel, 60 freshness, 30 saturation => 0.45*80 + 0.35*60 + 0.20*70 = 36 + 21 + 14 = 71
      expect(TrendSummary.calculateStrengthScore(80.0, 60.0, 30.0), 71.0);

      // High saturation penalizes composite score:
      // 80 vel, 60 freshness, 90 saturation => 36 + 21 + 0.20*10 = 59
      expect(TrendSummary.calculateStrengthScore(80.0, 60.0, 90.0), 59.0);
    });

    test('Acceptance Target 1: Source unavailable marks degraded data', () {
      final baseTrend = TrendSummary(
        id: 'tr-01',
        workspaceId: 'ws-alpha',
        title: 'Review đồ gia dụng thông minh',
        category: 'Home & Living',
        platform: 'TikTok',
        velocity: 85.0,
        freshnessScore: 90.0,
        saturationScore: 25.0,
        strengthScore: 84.8,
        confidence: ConfidenceBand.CONFIDENCE_BAND_HIGH,
        sourceClass: SourceClass.SOURCE_CLASS_OFFICIAL,
        isDegraded: false,
        sampleSize: 450,
        whyNow: 'Mùa tiệc cuối năm',
        relevanceDescription: 'Tương tác cao',
      );

      // When TikTok is disconnected:
      final degraded = baseTrend.copyWithDegradation(false, 'TikTok');
      expect(degraded.isDegraded, isTrue);
      expect(degraded.confidence, equals(ConfidenceBand.CONFIDENCE_BAND_LOW));
      expect(degraded.sourceClass, equals(SourceClass.SOURCE_CLASS_ESTIMATED));
      expect(degraded.degradedReason, contains('gián đoạn'));

      // When TikTok is connected:
      final connected = baseTrend.copyWithDegradation(true, 'TikTok');
      expect(connected.isDegraded, isFalse);
      expect(connected.confidence, equals(ConfidenceBand.CONFIDENCE_BAND_HIGH));
      expect(connected.sourceClass, equals(SourceClass.SOURCE_CLASS_OFFICIAL));
    });

    test('Acceptance Target 2: Threshold alerts deduplicate and batch storms', () {
      final now = DateTime(2026, 11, 2, 12, 0);
      final breach = {
        'workspaceId': 'ws-1',
        'watchlistId': 'wl-1',
        'trendId': 'tr-test',
        'title': 'Nồi chiên hơi nước',
        'metric': 'velocity',
        'threshold': 80.0,
        'actual': 92.0,
      };

      // 1. Initial breach passes
      final firstRun = evaluateMobileAlerts(
        breaches: [breach],
        existingFingerprints: {},
        cooldownMinutes: 60,
        now: now,
      );
      expect(firstRun.emittedAlerts.length, 1);
      expect(firstRun.suppressedCount, 0);

      // 2. Duplicate breach within 60 min cooldown is suppressed
      final secondRun = evaluateMobileAlerts(
        breaches: [breach],
        existingFingerprints: firstRun.updatedFingerprints,
        cooldownMinutes: 60,
        now: now.add(const Duration(minutes: 20)),
      );
      expect(secondRun.emittedAlerts.length, 0);
      expect(secondRun.suppressedCount, 1);

      // 3. Breach after cooldown passes
      final thirdRun = evaluateMobileAlerts(
        breaches: [breach],
        existingFingerprints: firstRun.updatedFingerprints,
        cooldownMinutes: 60,
        now: now.add(const Duration(minutes: 65)),
      );
      expect(thirdRun.emittedAlerts.length, 1);
      expect(thirdRun.suppressedCount, 0);

      // 4. Alert storm (>5 simultaneous breaches) collapses into summary alert
      final stormBreaches = List.generate(
        8,
        (i) => {
          'workspaceId': 'ws-1',
          'watchlistId': 'wl-1',
          'trendId': 'storm-$i',
          'title': 'Bão $i',
          'metric': 'velocity',
          'threshold': 80.0,
          'actual': 90.0 + i,
        },
      );
      final stormResult = evaluateMobileAlerts(
        breaches: stormBreaches,
        existingFingerprints: {},
        cooldownMinutes: 60,
        now: now,
      );
      expect(stormResult.emittedAlerts.length, 1);
      final summary = stormResult.emittedAlerts.first;
      expect(summary.isBatchedSummary, isTrue);
      expect(summary.batchedAlertCount, 8);
      expect(summary.trendTitle, contains('8 xu hướng cùng lúc vượt ngưỡng'));
    });

    test('Acceptance Target 3: Tenant-scoped search & filtering', () {
      final trends = [
        TrendSummary(
          id: 't-1',
          workspaceId: 'ws-own',
          title: 'Cà phê muối đóng lon',
          category: 'Food & Cooking',
          platform: 'TikTok',
          velocity: 90.0,
          freshnessScore: 85.0,
          saturationScore: 30.0,
          strengthScore: 84.0,
          confidence: ConfidenceBand.CONFIDENCE_BAND_HIGH,
          sourceClass: SourceClass.SOURCE_CLASS_OFFICIAL,
          isDegraded: false,
          sampleSize: 800,
          whyNow: 'Đồ uống tiện lợi',
          relevanceDescription: 'F&B',
        ),
        TrendSummary(
          id: 't-2',
          workspaceId: 'ws-foreign',
          title: 'Bàn phím cơ văn phòng',
          category: 'Tech & Gadgets',
          platform: 'YouTube',
          velocity: 95.0,
          freshnessScore: 90.0,
          saturationScore: 20.0,
          strengthScore: 90.0,
          confidence: ConfidenceBand.CONFIDENCE_BAND_HIGH,
          sourceClass: SourceClass.SOURCE_CLASS_OFFICIAL,
          isDegraded: false,
          sampleSize: 1000,
          whyNow: 'Công thái học',
          relevanceDescription: 'Tech',
        ),
      ];

      // Strict tenant isolation: ws-own gets t-1 only, never t-2
      final ownResults = searchAndFilterMobileTrends(
        trends: trends,
        currentWorkspaceId: 'ws-own',
      );
      expect(ownResults.length, 1);
      expect(ownResults.first.id, 't-1');

      // Foreign tenant query gets zero items from ws-own
      final foreignResults = searchAndFilterMobileTrends(
        trends: trends,
        currentWorkspaceId: 'ws-foreign',
      );
      expect(foreignResults.length, 1);
      expect(foreignResults.first.id, 't-2');

      // Unknown workspace gets zero items
      final emptyResults = searchAndFilterMobileTrends(
        trends: trends,
        currentWorkspaceId: 'ws-unknown',
      );
      expect(emptyResults.isEmpty, isTrue);

      // Search keyword filter within tenant
      final searchResult = searchAndFilterMobileTrends(
        trends: trends,
        currentWorkspaceId: 'ws-own',
        query: 'Cà phê',
      );
      expect(searchResult.length, 1);

      final noMatch = searchAndFilterMobileTrends(
        trends: trends,
        currentWorkspaceId: 'ws-own',
        query: 'Bàn phím',
      );
      expect(noMatch.isEmpty, isTrue);
    });
  });

  group('TrendRadarView Widget Tests', () {
    testWidgets('renders trend cards, degraded toggle, and search filter', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: TrendRadarView(
                currentWorkspaceId: 'ws-test-01',
                currentUserId: 'usr-test-01',
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Verify header and radar widgets
      expect(find.text('Trend Fusion Radar (M02)'), findsOneWidget);
      expect(find.text('Review nồi chiên không dầu hơi nước 15L'), findsOneWidget);
      expect(find.text('Serum phục hồi B5 + Rau má hữu cơ'), findsOneWidget);
      expect(find.text('Bàn phím cơ công thái học Alice layout'), findsOneWidget);

      // Test Target 1: Toggle degradation
      expect(find.byKey(const Key('mobile_degraded_banner')), findsNothing);
      await tester.tap(find.byKey(const Key('mobile_toggle_degrade_btn')));
      await tester.pumpAndSettle();

      // Degraded banner appears
      expect(find.byKey(const Key('mobile_degraded_banner')), findsOneWidget);
      expect(find.textContaining('Nguồn TikTok bị gián đoạn'), findsOneWidget);
      expect(find.text('DỮ LIỆU ƯỚC TÍNH (DEGRADED)'), findsWidgets);

      // Toggle back
      await tester.tap(find.text('Kết nối lại nguồn'));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('mobile_degraded_banner')), findsNothing);

      // Test Watchlist save
      expect(find.text('Watchlist (0)'), findsOneWidget);
      await tester.tap(find.byKey(const Key('mobile_save_wl_m-tr-01')));
      await tester.pumpAndSettle();
      expect(find.text('Watchlist (1)'), findsOneWidget);
      expect(find.text('Đã lưu'), findsOneWidget);

      // Test Watchlist sheet & alert evaluation
      await tester.tap(find.byKey(const Key('mobile_open_wl_sheet')));
      await tester.pumpAndSettle();
      expect(find.text('Watchlist & Cảnh báo bứt phá'), findsOneWidget);

      // Run alerts
      await tester.tap(find.byKey(const Key('mobile_run_alerts_btn')));
      await tester.pumpAndSettle();
      expect(find.text('Đã phát'), findsOneWidget);

      // Run duplicate alert immediately (tests deduplication suppression: 3 breaches suppressed)
      await tester.tap(find.byKey(const Key('mobile_run_alerts_btn')));
      await tester.pumpAndSettle();
      expect(find.text('3'), findsWidgets); // suppressed count incremented to 3

      // Simulate storm (>5 simultaneous breaches)
      await tester.tap(find.byKey(const Key('mobile_simulate_storm_btn')));
      await tester.pumpAndSettle();
      expect(find.textContaining('EC-M02-004'), findsOneWidget);
    });
  });
}

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:creativanta_mobile/competitor/competitor_models.dart';
import 'package:creativanta_mobile/generated/creativanta/intelligence/v1/trend.pbenum.dart';
import 'package:creativanta_mobile/ui/competitor/competitor_registry_view.dart';
import 'package:creativanta_mobile/ui/competitor/benchmark_comparison_view.dart';

void main() {
  group('Mobile Competitor Registry & Benchmark (M03) Unit Tests', () {
    // ------------------------------------------------------------------------
    // Acceptance Target 1: Inferred Insight Labeled & Why Explanation (RULE-M03-001, RULE-M03-002)
    // ------------------------------------------------------------------------
    test('Acceptance Target 1: Inferred Insight Labeled with Why Explanation', () {
      const why = WhyExplanationModel(
        basisSummary: 'Chỉ số được suy luận qua 30 bài đăng công khai gần nhất.',
        dataSources: ['TikTok Public API', 'Tương tác 30 ngày qua'],
        limitations: ['Không bao gồm các bài viết đã bị đối thủ xóa'],
        dataGaps: ['Không có số liệu doanh thu / GMV thực tế'],
      );

      final snapshot = BenchmarkSnapshot(
        id: 'snap-001',
        workspaceId: 'ws-mobile',
        competitorId: 'comp-101',
        capturedAt: DateTime.now(),
        sourceClass: SourceClass.SOURCE_CLASS_INFERRED,
        confidence: ConfidenceBand.CONFIDENCE_BAND_HIGH,
        whyExplanation: why,
        followers: 245000,
        engagementRate: 9.5,
        avgViews: 120000,
        growthRate30d: 14.2,
        postingFrequency: 2.3,
      );

      // Invariant RULE-M03-001: Must carry SOURCE_CLASS_INFERRED
      expect(snapshot.sourceClass, equals(SourceClass.SOURCE_CLASS_INFERRED));
      expect(snapshot.confidence, equals(ConfidenceBand.CONFIDENCE_BAND_HIGH));

      // Invariant RULE-M03-002: WhyExplanation must contain all 3 fields
      expect(snapshot.whyExplanation.dataSources.length, greaterThan(0));
      expect(snapshot.whyExplanation.limitations.length, greaterThan(0));
      expect(snapshot.whyExplanation.dataGaps.length, greaterThan(0));
      expect(snapshot.whyExplanation.dataGaps.first, contains('doanh thu'));
    });

    // ------------------------------------------------------------------------
    // Acceptance Target 2: Stale Snapshots Visible (RULE-M03-004)
    // ------------------------------------------------------------------------
    test('Acceptance Target 2: Stale Snapshots Visible (>30 days threshold)', () {
      final now = DateTime(2026, 11, 3, 12, 0);

      // 45 days old -> Stale
      final staleSnapshot = BenchmarkSnapshot(
        id: 'snap-stale',
        workspaceId: 'ws-mobile',
        competitorId: 'comp-101',
        capturedAt: now.subtract(const Duration(days: 45)),
        whyExplanation: const WhyExplanationModel(
          basisSummary: 'test',
          dataSources: [],
          limitations: [],
          dataGaps: [],
        ),
        followers: 200000,
        engagementRate: 8.0,
        avgViews: 90000,
        growthRate30d: 10.0,
        postingFrequency: 1.5,
      );

      expect(staleSnapshot.isStale(now), isTrue);
      expect(staleSnapshot.daysSinceCapture(now), equals(45));
      expect(staleSnapshot.staleWarning(now), contains('45 ngày trước'));
      expect(staleSnapshot.staleWarning(now), contains('vượt ngưỡng 30 ngày'));

      // 7 days old -> Fresh
      final freshSnapshot = BenchmarkSnapshot(
        id: 'snap-fresh',
        workspaceId: 'ws-mobile',
        competitorId: 'comp-101',
        capturedAt: now.subtract(const Duration(days: 7)),
        whyExplanation: const WhyExplanationModel(
          basisSummary: 'test',
          dataSources: [],
          limitations: [],
          dataGaps: [],
        ),
        followers: 245000,
        engagementRate: 9.5,
        avgViews: 120000,
        growthRate30d: 14.2,
        postingFrequency: 2.3,
      );

      expect(freshSnapshot.isStale(now), isFalse);
      expect(freshSnapshot.daysSinceCapture(now), equals(7));
      expect(freshSnapshot.staleWarning(now), isEmpty);
    });

    // ------------------------------------------------------------------------
    // Acceptance Target 3: No Assumed Access to Competitor Finance (RULE-M03-003)
    // ------------------------------------------------------------------------
    test('Acceptance Target 3: Revenue Guard & Non-conflation with Finance', () {
      // Competitor revenue display is strictly '—'
      expect(RevenueMetricGuard.privateDisplayValue, equals('—'));
      expect(RevenueMetricGuard.status, equals('PRIVATE_NOT_COMPARED'));

      // Conflation with financial ledger is blocked
      final ledgerBlocked = RevenueMetricGuard.validateNonConflationWithFinance(
        SourceClass.SOURCE_CLASS_INFERRED,
        'operating_ledger',
      );
      expect(ledgerBlocked, isFalse);

      final cogsBlocked = RevenueMetricGuard.validateNonConflationWithFinance(
        SourceClass.SOURCE_CLASS_ESTIMATED,
        'cogs',
      );
      expect(cogsBlocked, isFalse);

      // Operational domains are permitted
      final calendarAllowed = RevenueMetricGuard.validateNonConflationWithFinance(
        SourceClass.SOURCE_CLASS_INFERRED,
        'content_calendar',
      );
      expect(calendarAllowed, isTrue);
    });

    test('formatCompactNumber formats integers concisely', () {
      expect(formatCompactNumber(245000), equals('245.0K'));
      expect(formatCompactNumber(1250000), equals('1.3M'));
      expect(formatCompactNumber(850), equals('850'));
    });
  });

  group('Mobile Competitor UI Widget Tests', () {
    testWidgets('CompetitorRegistryView renders title, cards, and AI relevance', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: CompetitorRegistryView(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('🏆 Đối thủ cạnh tranh (M03)'), findsOneWidget);
      expect(find.text('Skincare Queen VN'), findsOneWidget);
      expect(find.text('Beauty Guru Official'), findsOneWidget);
      expect(find.textContaining('Độ tương quan: 92/100'), findsOneWidget);
    });

    testWidgets('BenchmarkComparisonView renders stale banner, podium, and private revenue', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        const MaterialApp(
          home: BenchmarkComparisonView(),
        ),
      );
      await tester.pumpAndSettle();

      // Acceptance Target 2: Stale snapshot warning is visible
      expect(find.text('DỮ LIỆU ĐÃ CŨ (>30 NGÀY)'), findsOneWidget);
      expect(find.text('Làm mới'), findsOneWidget);

      // Acceptance Target 3: Strictly private revenue row '—'
      expect(find.text('—'), findsOneWidget);
      expect(find.text('Doanh thu*'), findsOneWidget);

      // Acceptance Target 1: White-space opportunity with INFERRED badge
      expect(find.text('🏷️ INFERRED'), findsOneWidget);
      expect(find.textContaining('Phân tích thành phần B5'), findsOneWidget);

      // Refresh button clears stale banner
      await tester.tap(find.text('Làm mới'));
      await tester.pumpAndSettle();
      expect(find.text('DỮ LIỆU ĐÃ CŨ (>30 NGÀY)'), findsNothing);
    });
  });
}

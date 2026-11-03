import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:creativanta_mobile/generated/creativanta/intelligence/v1/opportunity.pbenum.dart';
import 'package:creativanta_mobile/generated/creativanta/intelligence/v1/trend.pbenum.dart';
import 'package:creativanta_mobile/opportunity/opportunity_models.dart';
import 'package:creativanta_mobile/ui/opportunity/opportunity_board_view.dart';

void main() {
  group('Mobile Opportunity Board (M04) Unit Tests', () {
    test('Multi-dimensional composite scoring calculation', () {
      // 85 impact, 30 effort => (85 * 0.7) + ((100 - 30) * 0.3) = 59.5 + 21 = 80.5 => 81
      expect(OpportunityItem.calculateOverallScore(85, 30), equals(81));

      // 100 impact, 0 effort => 100
      expect(OpportunityItem.calculateOverallScore(100, 0), equals(100));

      // 0 impact, 100 effort => 1
      expect(OpportunityItem.calculateOverallScore(0, 100), equals(1));
    });

    test('Acceptance Target 1: Unassigned open items remain repairable', () {
      final opp = OpportunityItem(
        id: 'opp-1',
        workspaceId: 'ws-1',
        opportunityType: 'content',
        title: 'Morning skincare routine',
        summary: 'High potential',
        whyItMatters: 'Competitor gap',
        expectedImpactScore: 80,
        expectedImpactDesc: 'High reach',
        expectedEffortScore: 40,
        expectedEffortDesc: 'Low effort',
        priorityState: PriorityState.PRIORITY_STATE_OPEN,
        priorityReason: '',
        suggestedNextStep: 'Write script',
        ownerUserId: '', // Unassigned
        confidence: ConfidenceBand.CONFIDENCE_BAND_HIGH,
        sourceClass: SourceClass.SOURCE_CLASS_INFERRED,
        sources: [
          const OpportunitySourceItem(sourceType: 'trend', sourceId: 't-1', sourceName: 'Trend 1'),
        ],
        overallScore: 74,
        estimatedProfitAmountCents: 15000000,
        profitExplanation: 'Estimate basis',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        isRepairable: false,
        repairReasons: const [],
      );

      final status = OpportunityItem.computeRepairStatus(opp);
      expect(status.isRepairable, isTrue);
      expect(status.repairReasons.any((r) => r.contains('Chưa phân công người phụ trách')), isTrue);
    });

    test('Acceptance Target 2: State transitions and concurrency conflict detection', () {
      final opp = OpportunityItem(
        id: 'opp-2',
        workspaceId: 'ws-1',
        opportunityType: 'content',
        title: 'Retinol review',
        summary: 'Competitor stopped posting',
        whyItMatters: 'Gap opportunity',
        expectedImpactScore: 75,
        expectedImpactDesc: 'Moderate reach',
        expectedEffortScore: 50,
        expectedEffortDesc: 'Average effort',
        priorityState: PriorityState.PRIORITY_STATE_OPEN,
        priorityReason: '',
        suggestedNextStep: 'Create video',
        ownerUserId: '',
        confidence: ConfidenceBand.CONFIDENCE_BAND_UNSPECIFIED,
        sourceClass: SourceClass.SOURCE_CLASS_INFERRED,
        sources: [
          const OpportunitySourceItem(sourceType: 'competitor', sourceId: 'c-1', sourceName: 'Comp 1'),
        ],
        overallScore: 68,
        estimatedProfitAmountCents: 10000000,
        profitExplanation: 'Estimate basis',
        createdAt: DateTime.now(),
        updatedAt: DateTime.parse('2026-11-03T02:00:00.000Z'),
        isRepairable: true,
        repairReasons: const ['Needs owner'],
      );

      // Transition OPEN -> PRIORITIZED fails without justification (RULE-M04-003)
      final failJustification = OpportunityItem.validateStateTransition(
        PriorityState.PRIORITY_STATE_OPEN,
        PriorityState.PRIORITY_STATE_PRIORITIZED,
        opp,
      );
      expect(failJustification.allowed, isFalse);
      expect(failJustification.error, contains('RULE-M04-003'));

      // Transition PRIORITIZED -> ASSIGNED fails without owner (RULE-M04-002)
      opp.priorityReason = 'Strong competitor gap';
      final failOwner = OpportunityItem.validateStateTransition(
        PriorityState.PRIORITY_STATE_PRIORITIZED,
        PriorityState.PRIORITY_STATE_ASSIGNED,
        opp,
      );
      expect(failOwner.allowed, isFalse);
      expect(failOwner.error, contains('RULE-M04-002'));

      // With targetOwner, transition succeeds
      final passOwner = OpportunityItem.validateStateTransition(
        PriorityState.PRIORITY_STATE_PRIORITIZED,
        PriorityState.PRIORITY_STATE_ASSIGNED,
        opp,
        targetOwner: 'user-valid-owner',
      );
      expect(passOwner.allowed, isTrue);

      // Concurrency conflict detection (EC-M04-003)
      final current = DateTime.parse('2026-11-03T02:05:00.000Z');
      final stale = DateTime.parse('2026-11-03T02:00:00.000Z');
      expect(OpportunityItem.isConcurrentConflict(current, stale), isTrue);
      expect(OpportunityItem.isConcurrentConflict(current, current), isFalse);
    });

    test('Acceptance Target 3: No orphan opportunity provenance', () {
      final opp = OpportunityItem(
        id: 'opp-3',
        workspaceId: 'ws-1',
        opportunityType: 'product',
        title: 'Cushion SPF50',
        summary: 'Search trend spike',
        whyItMatters: 'Summer demand',
        expectedImpactScore: 90,
        expectedImpactDesc: 'Very high',
        expectedEffortScore: 20,
        expectedEffortDesc: 'Easy',
        priorityState: PriorityState.PRIORITY_STATE_OPEN,
        priorityReason: 'Trending +150%',
        suggestedNextStep: 'Sample testing',
        ownerUserId: 'user-1',
        confidence: ConfidenceBand.CONFIDENCE_BAND_HIGH,
        sourceClass: SourceClass.SOURCE_CLASS_OFFICIAL,
        sources: [
          const OpportunitySourceItem(sourceType: 'trend', sourceId: 'tr-cushion', sourceName: 'SPF Cushion'),
          const OpportunitySourceItem(sourceType: 'signal', sourceId: 'sig-tiktok', sourceName: 'TikTok Search Spike'),
        ],
        overallScore: 87,
        estimatedProfitAmountCents: 30000000,
        profitExplanation: 'GMV estimate',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        isRepairable: false,
        repairReasons: const [],
      );

      expect(opp.sources, isNotEmpty);
      expect(opp.sources.length, equals(2));
      expect(opp.isEstimate, isTrue); // RULE-M04-005
    });

    testWidgets('OpportunityBoardView renders score, title, and repair banner', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: OpportunityBoardView(workspaceId: 'ws-test-mobile'),
        ),
      );

      // Verify Screen title
      expect(find.text('💎 Cơ hội (Opportunity Board)'), findsOneWidget);

      // Verify Score badge
      expect(find.text('⭐ 89/100'), findsOneWidget);

      // Verify Repair banner for unassigned item
      expect(find.text('Cần phân công người phụ trách (Repair Required)'), findsOneWidget);

      // Verify action buttons
      expect(find.text('💡 Tạo ý tưởng'), findsWidgets);
      expect(find.text('📝 Viết script'), findsWidgets);
    });
  });
}

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:creativanta_mobile/content/idea_models.dart';
import 'package:creativanta_mobile/generated/creativanta/content/v1/idea.pbenum.dart';
import 'package:creativanta_mobile/ui/content/idea_board_view.dart';
import 'package:creativanta_mobile/ui/content/quick_capture_sheet.dart';

void main() {
  group('Mobile Idea Engine (M05) - Acceptance Target Tests', () {
    test('Acceptance Target 1: Duplicate idea warns without silent merge', () {
      final existingIdeas = [
        IdeaItem(
          ideaId: 'idea-001',
          workspaceId: 'ws-demo',
          title: 'Chiến dịch Skincare mùa hè cho da dầu mụn',
          description: 'Top các sản phẩm kiềm dầu và chống nắng',
          suggestedFormat: 'video_short',
          status: IdeaStatus.IDEA_STATUS_CANDIDATE,
          ideaScore: 82.0,
          createdBy: 'usr-001',
          sources: [
            const IdeaSourceItem(
              sourceType: 'trend',
              sourceId: 'tr-summer-skin',
              sourceTitle: 'Skincare Hè 2026',
            ),
          ],
          createdAt: DateTime(2026, 11, 1),
          updatedAt: DateTime(2026, 11, 1),
        ),
      ];

      // Exact title matches 1.0 > 0.85 threshold
      final exactWarning = IdeaItem.checkDuplicate(
        title: 'Chiến dịch Skincare mùa hè cho da dầu mụn',
        existingIdeas: existingIdeas,
      );
      expect(exactWarning, isNotNull);
      expect(exactWarning!.isDuplicate, isTrue);
      expect(exactWarning.similarityScore, 1.0);
      expect(exactWarning.existingIdeaId, 'idea-001');
      expect(exactWarning.warningMessage, contains('Đã có ý tưởng tương tự'));

      // Substring containment or high lexical match > 0.85
      final similarWarning = IdeaItem.checkDuplicate(
        title: 'Skincare mùa hè cho da dầu mụn',
        existingIdeas: existingIdeas,
      );
      expect(similarWarning, isNotNull);
      expect(similarWarning!.isDuplicate, isTrue);
      expect(similarWarning.similarityScore, greaterThanOrEqualTo(0.85));

      // Distinct idea does not warn
      final distinctWarning = IdeaItem.checkDuplicate(
        title: 'Mẹo pha cà phê Cold Brew tại nhà nhanh gọn',
        existingIdeas: existingIdeas,
      );
      expect(distinctWarning, isNull);

      // Verify no silent merge: even with high similarity, creating new item creates distinct object with own ID
      final newIdea = IdeaItem.createMobileQuickCapture(
        workspaceId: 'ws-demo',
        userId: 'usr-002',
        title: 'Chiến dịch Skincare mùa hè cho da dầu mụn',
        ideaId: 'idea-new-duplicate',
      );
      expect(newIdea.ideaId, 'idea-new-duplicate');
      expect(newIdea.ideaId, isNot(equals(existingIdeas[0].ideaId)));
      expect(newIdea.status, equals(IdeaStatus.IDEA_STATUS_DRAFT));
    });

    test('Acceptance Target 2: Source lineage retained across types & archive', () {
      final now = DateTime(2026, 11, 3);

      final sources = [
        const IdeaSourceItem(
          sourceType: 'trend',
          sourceId: 'tr-100',
          sourceTitle: 'AI Automation Video 2026',
          sourceUrl: 'https://tiktok.com/@trend/100',
        ),
        const IdeaSourceItem(
          sourceType: 'opportunity',
          sourceId: 'opp-200',
          sourceTitle: 'Nhu cầu làm video ngắn tự động',
        ),
        const IdeaSourceItem(
          sourceType: 'product',
          sourceId: 'prod-300',
          sourceTitle: 'Khóa học Prompt Engineering',
        ),
        const IdeaSourceItem(
          sourceType: 'manual',
          sourceId: 'usr-400',
          sourceTitle: 'Ý tưởng ghi chép từ hội thảo',
        ),
        const IdeaSourceItem(
          sourceType: 'trend',
          sourceId: 'tr-expired',
          sourceTitle: 'Xu hướng đã hết hạn Q3/2026',
          isArchived: true,
          archiveNotice: 'Nguồn xu hướng đã lưu trữ hoặc hết hạn',
        ),
      ];

      final idea = IdeaItem(
        ideaId: 'idea-lineage-01',
        workspaceId: 'ws-demo',
        title: 'Quy trình tạo video AI tự động',
        status: IdeaStatus.IDEA_STATUS_CANDIDATE,
        ideaScore: 88.0,
        createdBy: 'usr-400',
        sources: sources,
        createdAt: now,
        updatedAt: now,
      );

      // Validate all sources retained
      expect(idea.sources.length, 5);
      expect(idea.sources[0].displayLabel, 'Xu hướng (Trend)');
      expect(idea.sources[1].displayLabel, 'Cơ hội (Opportunity)');
      expect(idea.sources[2].displayLabel, 'Sản phẩm (Product)');
      expect(idea.sources[3].displayLabel, 'Ghi chú thủ công');

      // Validate expired source retains lineage and shows archive notice (EC-M05-002)
      final expired = idea.sources[4];
      expect(expired.isArchived, isTrue);
      expect(expired.archiveNotice, isNotNull);
      expect(expired.archiveNotice, contains('đã lưu trữ hoặc hết hạn'));
    });

    test('Acceptance Target 3: Mobile title-only draft works', () {
      // Given a mobile user enters only a title and saves:
      final draft = IdeaItem.createMobileQuickCapture(
        workspaceId: 'ws-mobile',
        userId: 'usr-creator-99',
        title: 'Review chi tiết micro thu âm không dây giá rẻ',
      );

      // Verify draft status
      expect(draft.status, equals(IdeaStatus.IDEA_STATUS_DRAFT));

      // Verify title is preserved
      expect(draft.title, 'Review chi tiết micro thu âm không dây giá rẻ');

      // Verify description and format are empty (not required for draft capture!)
      expect(draft.description, isEmpty);
      expect(draft.suggestedFormat, isEmpty);

      // Verify provenance is attached to user manual capture (RULE-M05-001)
      expect(draft.sources.length, 1);
      expect(draft.sources[0].sourceType, 'manual');
      expect(draft.sources[0].sourceId, 'usr-creator-99');
      expect(draft.sources[0].displayLabel, 'Ghi chú thủ công');
    });

    test('RULE-M05-002: Canonical state machine progression', () {
      final idea = IdeaItem(
        ideaId: 'idea-state-01',
        workspaceId: 'ws-demo',
        title: 'Test State Transitions',
        status: IdeaStatus.IDEA_STATUS_DRAFT,
        ideaScore: 75.0,
        createdBy: 'usr-1',
        sources: const [],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      // From draft: can transition to candidate or archived
      expect(idea.canTransitionTo(IdeaStatus.IDEA_STATUS_CANDIDATE), isTrue);
      expect(idea.canTransitionTo(IdeaStatus.IDEA_STATUS_ARCHIVED), isTrue);
      expect(idea.canTransitionTo(IdeaStatus.IDEA_STATUS_SELECTED), isFalse);
      expect(idea.canTransitionTo(IdeaStatus.IDEA_STATUS_CONVERTED), isFalse);

      // From candidate: can transition to selected or archived
      idea.status = IdeaStatus.IDEA_STATUS_CANDIDATE;
      expect(idea.canTransitionTo(IdeaStatus.IDEA_STATUS_SELECTED), isTrue);
      expect(idea.canTransitionTo(IdeaStatus.IDEA_STATUS_ARCHIVED), isTrue);
      expect(idea.canTransitionTo(IdeaStatus.IDEA_STATUS_DRAFT), isFalse);
      expect(idea.canTransitionTo(IdeaStatus.IDEA_STATUS_CONVERTED), isFalse);

      // From selected: can transition to converted or archived
      idea.status = IdeaStatus.IDEA_STATUS_SELECTED;
      expect(idea.canTransitionTo(IdeaStatus.IDEA_STATUS_CONVERTED), isTrue);
      expect(idea.canTransitionTo(IdeaStatus.IDEA_STATUS_ARCHIVED), isTrue);
      expect(idea.canTransitionTo(IdeaStatus.IDEA_STATUS_DRAFT), isFalse);

      // From archived: can reactivate to draft
      idea.status = IdeaStatus.IDEA_STATUS_ARCHIVED;
      expect(idea.canTransitionTo(IdeaStatus.IDEA_STATUS_DRAFT), isTrue);
      expect(idea.canTransitionTo(IdeaStatus.IDEA_STATUS_CANDIDATE), isFalse);

      // From converted: terminal state, no further transitions
      idea.status = IdeaStatus.IDEA_STATUS_CONVERTED;
      expect(idea.canTransitionTo(IdeaStatus.IDEA_STATUS_ARCHIVED), isFalse);
      expect(idea.canTransitionTo(IdeaStatus.IDEA_STATUS_DRAFT), isFalse);
    });

    test('EC-M05-004: Validate required fields before script conversion', () {
      final idea = IdeaItem(
        ideaId: 'idea-val-01',
        workspaceId: 'ws-demo',
        title: 'Title only',
        description: '',
        suggestedFormat: '',
        status: IdeaStatus.IDEA_STATUS_SELECTED,
        ideaScore: 80.0,
        createdBy: 'usr-1',
        sources: const [],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      // Title-only draft fails conversion validation
      final errNoDesc = idea.validateConversionEligibility();
      expect(errNoDesc, contains('cần có mô tả'));

      // With description but without format
      idea.description = 'Detailed overview of the topic';
      final errNoFormat = idea.validateConversionEligibility();
      expect(errNoFormat, contains('cần có định dạng'));

      // With both populated: succeeds
      idea.suggestedFormat = 'video_short';
      expect(idea.validateConversionEligibility(), isNull);
    });
  });

  group('Mobile Idea Engine Widget Tests', () {
    testWidgets('QuickCaptureSheet creates title-only draft', (
      WidgetTester tester,
    ) async {
      IdeaItem? savedIdea;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: QuickCaptureSheet(
              workspaceId: 'ws-quick',
              userId: 'usr-mobile-user',
              existingIdeas: const [],
              onIdeaSaved: (idea) {
                savedIdea = idea;
              },
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('⚡ Ghi ý tưởng nhanh'), findsOneWidget);
      expect(find.text('M05'), findsOneWidget);

      // Enter title only
      await tester.enterText(
        find.byType(TextField),
        'Ý tưởng video viral 60 giây',
      );
      await tester.pumpAndSettle();

      // Tap save draft button
      await tester.tap(find.text('Lưu bản nháp (Draft)'));
      await tester.pumpAndSettle();

      // Verify callback received title-only draft
      expect(savedIdea, isNotNull);
      expect(savedIdea!.title, 'Ý tưởng video viral 60 giây');
      expect(savedIdea!.status, equals(IdeaStatus.IDEA_STATUS_DRAFT));
      expect(savedIdea!.description, isEmpty);
      expect(savedIdea!.sources.first.sourceType, 'manual');
    });

    testWidgets('QuickCaptureSheet shows duplicate warning and allows proceeding without merge', (
      WidgetTester tester,
    ) async {
      IdeaItem? savedIdea;
      final existing = [
        IdeaItem(
          ideaId: 'idea-exist-01',
          workspaceId: 'ws-quick',
          title: 'Review tai nghe chống ồn Sony WH-1000XM5',
          status: IdeaStatus.IDEA_STATUS_CANDIDATE,
          ideaScore: 85.0,
          createdBy: 'usr-1',
          sources: const [],
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: QuickCaptureSheet(
              workspaceId: 'ws-quick',
              userId: 'usr-mobile-user',
              existingIdeas: existing,
              onIdeaSaved: (idea) {
                savedIdea = idea;
              },
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Type title similar to existing
      await tester.enterText(
        find.byType(TextField),
        'Review tai nghe chống ồn Sony WH-1000XM5 mới nhất',
      );
      await tester.pumpAndSettle();

      // Expect duplicate warning banner
      expect(find.textContaining('Ý tưởng tương tự đã tồn tại'), findsOneWidget);
      expect(find.textContaining('Review tai nghe chống ồn Sony WH-1000XM5'), findsWidgets);
      expect(find.text('Vẫn lưu (Không gộp)'), findsOneWidget);

      // Tap "Vẫn lưu (Không gộp)"
      await tester.tap(find.text('Vẫn lưu (Không gộp)'));
      await tester.pumpAndSettle();

      // Verify that new idea was saved independently with its own new ID (no silent merge!)
      expect(savedIdea, isNotNull);
      expect(savedIdea!.ideaId, isNot(equals('idea-exist-01')));
      expect(savedIdea!.title, 'Review tai nghe chống ồn Sony WH-1000XM5 mới nhất');
      expect(savedIdea!.status, equals(IdeaStatus.IDEA_STATUS_DRAFT));
    });

    testWidgets('IdeaBoardView renders ideas, provenance, status filter and quick capture CTA', (
      WidgetTester tester,
    ) async {
      final ideas = [
        IdeaItem(
          ideaId: 'idea-01',
          workspaceId: 'ws-board',
          title: 'Top 5 công cụ AI năm 2026',
          description: 'So sánh các công cụ tạo video và ảnh',
          status: IdeaStatus.IDEA_STATUS_DRAFT,
          ideaScore: 80.0,
          createdBy: 'usr-1',
          sources: [
            const IdeaSourceItem(
              sourceType: 'trend',
              sourceId: 'tr-01',
              sourceTitle: 'AI Tools 2026',
            ),
          ],
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
        IdeaItem(
          ideaId: 'idea-02',
          workspaceId: 'ws-board',
          title: 'Chiến thuật Live Commerce chốt đơn',
          description: 'Kịch bản livestream chốt sale hiệu quả',
          status: IdeaStatus.IDEA_STATUS_CANDIDATE,
          ideaScore: 92.0,
          createdBy: 'usr-2',
          sources: [
            const IdeaSourceItem(
              sourceType: 'trend',
              sourceId: 'tr-expired',
              sourceTitle: 'Livestream Q2/2026',
              isArchived: true,
              archiveNotice: 'Xu hướng đã hết hạn',
            ),
          ],
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: IdeaBoardView(
            workspaceId: 'ws-board',
            userId: 'usr-tester',
            initialIdeas: ideas,
          ),
        ),
      );
      await tester.pumpAndSettle();

      // App bar & items
      expect(find.text('💡 Kho ý tưởng'), findsOneWidget);
      expect(find.text('Top 5 công cụ AI năm 2026'), findsOneWidget);
      expect(find.text('Chiến thuật Live Commerce chốt đơn'), findsOneWidget);

      // Scores
      expect(find.text('80 đ'), findsOneWidget);
      expect(find.text('92 đ'), findsOneWidget);

      // Lineage chips
      expect(find.text('🔗 Xu hướng (Trend): AI Tools 2026'), findsOneWidget);
      expect(find.text('🔗 Xu hướng (Trend): Livestream Q2/2026'), findsOneWidget);

      // Filter by "Bản nháp"
      await tester.tap(find.text('Bản nháp'));
      await tester.pumpAndSettle();
      expect(find.text('Top 5 công cụ AI năm 2026'), findsOneWidget);
      expect(find.text('Chiến thuật Live Commerce chốt đơn'), findsNothing);

      // Filter back to "Tất cả"
      await tester.tap(find.text('Tất cả'));
      await tester.pumpAndSettle();
      expect(find.text('Top 5 công cụ AI năm 2026'), findsOneWidget);
      expect(find.text('Chiến thuật Live Commerce chốt đơn'), findsOneWidget);

      // Floating action button exists
      expect(find.text('Ghi nhanh'), findsOneWidget);
    });
  });
}

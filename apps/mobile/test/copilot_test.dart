import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:creativanta_mobile/copilot/copilot_models.dart';
import 'package:creativanta_mobile/ui/copilot/copilot_view.dart';

void main() {
  group('Mobile Copilot (M23) Unit Tests & Acceptance Targets', () {
    test('Acceptance Target 1: Contributor cannot delete product', () {
      // Role checks
      expect(canDeleteProduct(CopilotRole.contributor), isFalse);
      expect(canDeleteProduct(CopilotRole.viewer), isFalse);
      expect(canDeleteProduct(CopilotRole.external), isFalse);
      expect(canDeleteProduct(CopilotRole.editor), isFalse);
      expect(canDeleteProduct(CopilotRole.manager), isFalse);
      expect(canDeleteProduct(CopilotRole.admin), isTrue);
      expect(canDeleteProduct(CopilotRole.owner), isTrue);

      // Evaluator with Contributor
      final evalContributor = evaluateCopilotCommand(
        'Vui lòng xóa sản phẩm SP-100',
        CopilotRole.contributor,
        50,
      );
      expect(evalContributor.isRefusal, isTrue);
      expect(evalContributor.messageContent, equals(kRefusalProductDelete));
      expect(evalContributor.actions.first.actionType, equals('refusal'));

      // Evaluator with Admin
      final evalAdmin = evaluateCopilotCommand(
        'Xóa sản phẩm SP-100',
        CopilotRole.admin,
        50,
      );
      expect(evalAdmin.isRefusal, isFalse);
      expect(evalAdmin.messageContent, contains('Bạn có quyền xóa sản phẩm'));
      expect(evalAdmin.actions.first.actionType, equals('navigate'));
    });

    test('Acceptance Target 2: Read query cannot expose finance', () {
      // Role checks
      expect(canAccessFinance(CopilotRole.contributor), isFalse);
      expect(canAccessFinance(CopilotRole.viewer), isFalse);
      expect(canAccessFinance(CopilotRole.external), isFalse);
      expect(canAccessFinance(CopilotRole.manager), isTrue);
      expect(canAccessFinance(CopilotRole.admin), isTrue);
      expect(canAccessFinance(CopilotRole.owner), isTrue);

      // Financial query with Contributor
      final evalContributor = evaluateCopilotCommand(
        'Cho tôi biết doanh thu và lợi nhuận tháng này',
        CopilotRole.contributor,
        50,
      );
      expect(evalContributor.isRefusal, isTrue);
      expect(evalContributor.messageContent, equals(kRefusalFinanceAccess));

      // Financial query with Viewer
      final evalViewer = evaluateCopilotCommand(
        'Báo cáo doanh thu',
        CopilotRole.viewer,
        50,
      );
      expect(evalViewer.isRefusal, isTrue);
      expect(evalViewer.messageContent, equals(kRefusalFinanceAccess));

      // Financial query with Manager
      final evalManager = evaluateCopilotCommand(
        'Báo cáo doanh thu',
        CopilotRole.manager,
        50,
      );
      expect(evalManager.isRefusal, isFalse);
      expect(evalManager.messageContent, contains('45,200,000 VND'));
    });

    test('Acceptance Target 3: Generated script needs quote confirmation', () {
      final prompt = 'Viết kịch bản video TikTok 30s';
      final evalScript = evaluateCopilotCommand(
        prompt,
        CopilotRole.contributor,
        30,
      );

      expect(evalScript.isRefusal, isFalse);
      expect(evalScript.requiresQuote, isTrue);
      expect(evalScript.quotePreview, isNotNull);
      expect(evalScript.quotePreview!.costCredits, equals(5));
      expect(evalScript.quotePreview!.status, equals(QuoteStatus.pending));
      expect(evalScript.quotePreview!.confirmed, isFalse);

      // Rejection of confirmation
      final cancelResult = confirmScriptQuote(evalScript.quotePreview!, false);
      expect(cancelResult.success, isFalse);
      expect(cancelResult.updatedQuote.status, equals(QuoteStatus.cancelled));
      expect(cancelResult.updatedQuote.confirmed, isFalse);

      // Insufficient credits
      final brokeQuote = createScriptQuotePreview('Kịch bản', 2);
      final failResult = confirmScriptQuote(brokeQuote, true);
      expect(failResult.success, isFalse);
      expect(failResult.error, contains('Không đủ credits'));

      // Successful confirmation
      final okQuote = createScriptQuotePreview('Kịch bản viral', 20);
      final okResult = confirmScriptQuote(okQuote, true);
      expect(okResult.success, isTrue);
      expect(okResult.updatedQuote.status, equals(QuoteStatus.confirmed));
      expect(okResult.updatedQuote.confirmed, isTrue);
      expect(okResult.updatedQuote.currentBalance, equals(15)); // 20 - 5
    });
  });

  group('Mobile Copilot Widget Tests', () {
    testWidgets('Target 1: Contributor triggers deletion refusal UI',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: CopilotView(
            workspaceId: 'ws-test',
            userId: 'user-test',
            initialRole: CopilotRole.contributor,
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Find quick chip for delete product and tap it
      final chipDelete = find.byKey(const Key('chip-delete-product'));
      expect(chipDelete, findsOneWidget);
      await tester.tap(chipDelete);
      await tester.pumpAndSettle();

      // Verify refusal badge and refusal text are rendered
      expect(find.byKey(const Key('refusal-badge')), findsOneWidget);
      expect(find.text(kRefusalProductDelete), findsOneWidget);
    });

    testWidgets('Target 2: Contributor triggers finance access refusal UI',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: CopilotView(
            workspaceId: 'ws-test',
            userId: 'user-test',
            initialRole: CopilotRole.contributor,
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Tap quick chip for finance query
      final chipFinance = find.byKey(const Key('chip-query-finance'));
      expect(chipFinance, findsOneWidget);
      await tester.tap(chipFinance);
      await tester.pumpAndSettle();

      // Verify refusal message
      expect(find.byKey(const Key('refusal-badge')), findsOneWidget);
      expect(find.text(kRefusalFinanceAccess), findsOneWidget);
    });

    testWidgets('Target 3: Script generation shows quote card & debits on confirm',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: CopilotView(
            workspaceId: 'ws-test',
            userId: 'user-test',
            initialRole: CopilotRole.contributor,
            initialCredits: 100,
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Verify initial credits
      expect(find.text('100 cr'), findsOneWidget);

      // Tap quick chip for script generation
      final chipScript = find.byKey(const Key('chip-generate-script'));
      expect(chipScript, findsOneWidget);
      await tester.tap(chipScript);
      await tester.pumpAndSettle();

      // Verify quote preview card is rendered
      expect(find.text('Chờ xác nhận'), findsOneWidget);
      expect(find.text('5 credits'), findsOneWidget);

      // Tap Confirm Quote button
      final btnConfirm = find.byKey(const Key('btn-quote-confirm'));
      expect(btnConfirm, findsOneWidget);
      await tester.tap(btnConfirm);
      await tester.pumpAndSettle();

      // Verify credits debited to 95 cr and status changed to Đã xác nhận
      expect(find.text('95 cr'), findsOneWidget);
      expect(find.text('Đã xác nhận'), findsOneWidget);
      expect(find.textContaining('Đã xác nhận báo giá!'), findsOneWidget);
    });
  });
}

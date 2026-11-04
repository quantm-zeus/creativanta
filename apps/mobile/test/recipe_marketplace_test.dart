import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:creativanta_mobile/automation/recipe_models.dart';
import 'package:creativanta_mobile/automation/recipe_templates_view.dart';

void main() {
  group('P7-03 Recipe Marketplace & Governance Mobile Suite (M21)', () {
    final testTemplate = RecipeTemplate(
      recipeId: 'rec-test-01',
      title: 'Auto Order Notification',
      description: 'Notify customer on Shopee order placement',
      category: 'commerce',
      templateKind: 'workflow',
      templateVersion: 1,
      templatePayload: const {'schema_version': 1, 'nodes': [], 'edges': []},
      parameters: const [
        RecipeParameter(
          name: 'message',
          type: 'string',
          defaultValue: 'Thank you!',
          required: true,
          description: 'Thank you message',
        )
      ],
      requiredCapabilities: const ['shopee.order.sync', 'tiktok.publish'],
      installCount: 350,
      ratingAvg: 4.9,
      reviewCount: 42,
      priceUSD: '100.000000',
      status: RecipeStatus.published,
      createdAt: DateTime.utc(2026, 10, 1),
      updatedAt: DateTime.utc(2026, 10, 15),
    );

    test('Target 2: checkMissingCapabilities explains missing platform requirements', () {
      final caps = {
        'tiktok.publish': 'supported',
        'shopee.order.sync': 'unsupported',
      };

      final missing = checkMissingCapabilities(testTemplate, caps);
      expect(missing.length, 1);
      expect(missing.first.capabilityKey, 'shopee.order.sync');
      expect(missing.first.platform, 'shopee');
      expect(missing.first.reason, contains('active Shopee connector'));
      expect(missing.first.resolutionGuidance, contains('Settings -> Integrations'));
      expect(missing.first.connectUrl, '/settings/integrations/shopee');
    });

    test('Target 2: checkMissingCapabilities passes when all capabilities are active', () {
      final caps = {
        'tiktok.publish': 'supported',
        'shopee.order.sync': 'supported',
      };

      final missing = checkMissingCapabilities(testTemplate, caps);
      expect(missing.isEmpty, true);
    });

    test('Revenue Share (RULE-M21-006): calculates 70/30 split and 7-day refund window', () {
      final split = calculateRevenueShare('100.000000');
      expect(split.grossUSD, '100.000000');
      expect(split.creatorUSD, '70.000000');
      expect(split.platformUSD, '30.000000');
      expect(split.refundWindowDays, 7);

      final splitFraction = calculateRevenueShare('49.990000');
      expect(splitFraction.creatorUSD, '34.993000');
      expect(splitFraction.platformUSD, '14.997000');
    });

    testWidgets('M054 RecipeTemplatesView renders cards, missing capability warning and deploy action', (tester) async {
      bool deployed = false;

      final freeTemplate = RecipeTemplate(
        recipeId: 'rec-free-02',
        title: 'Daily Content Generator',
        description: 'Auto-generate 3 video scripts every morning',
        category: 'content',
        templateKind: 'workflow',
        templateVersion: 1,
        templatePayload: const {'schema_version': 1, 'nodes': [], 'edges': []},
        parameters: const [],
        requiredCapabilities: const ['tiktok.publish'],
        installCount: 120,
        ratingAvg: 4.7,
        reviewCount: 15,
        priceUSD: '0.000000',
        status: RecipeStatus.published,
        createdAt: DateTime.utc(2026, 10, 5),
        updatedAt: DateTime.utc(2026, 10, 10),
      );

      // Shopee unsupported, TikTok supported
      final caps = {
        'tiktok.publish': 'supported',
        'shopee.order.sync': 'unsupported',
      };

      await tester.pumpWidget(
        MaterialApp(
          home: RecipeTemplatesView(
            templates: [testTemplate, freeTemplate],
            workspaceCapabilities: caps,
            onDeploy: (t) {
              deployed = true;
            },
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Check title and cards rendered
      expect(find.text('📋 Workflow Recipes'), findsOneWidget);
      expect(find.text('Auto Order Notification'), findsOneWidget);
      expect(find.text('Daily Content Generator'), findsOneWidget);

      // Verify missing capability warning on first template
      expect(find.text('Thiếu kết nối SHOPEE'), findsOneWidget);

      // Verify deploy on eligible free template
      final deployButtons = find.widgetWithText(ElevatedButton, '📥 Dùng template');
      expect(deployButtons, findsNWidgets(2));

      // Scroll to and tap deploy on the second (eligible) template
      await tester.ensureVisible(deployButtons.last);
      await tester.pumpAndSettle();
      await tester.tap(deployButtons.last);
      await tester.pumpAndSettle();

      expect(deployed, true);
      expect(find.textContaining('Đã cài đặt "Daily Content Generator"'), findsOneWidget);
    });
  });
}

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:creativanta_mobile/commerce/affiliate_models.dart';
import 'package:creativanta_mobile/generated/creativanta/commerce/v1/affiliate.pb.dart';
import 'package:creativanta_mobile/ui/commerce/affiliate_view.dart';

void main() {
  const wsId = 'ws-test-mobile-p6-03';

  group('P6-03 Mobile Affiliate Acceptance Tests', () {
    // ------------------------------------------------------------------------
    // Acceptance Target 1: Creator Income Distinct from Seller Expense
    // ------------------------------------------------------------------------
    test('Target 1: Creator income is pure revenue without COGS deduction', () {
      final creatorPosting = evaluateMobileLedgerImpact(
        workspaceId: wsId,
        commissionAmount: '350000.000000',
        currency: 'VND',
        role: WorkspaceEconomicRole.WORKSPACE_ECONOMIC_ROLE_CREATOR,
      );

      expect(creatorPosting.postingType, equals('creator_income'));
      expect(creatorPosting.cogsDeducted, isFalse); // Acceptance Target 1!
      expect(creatorPosting.netProfitImpact, equals('+350000.000000'));

      final sellerPosting = evaluateMobileLedgerImpact(
        workspaceId: wsId,
        commissionAmount: '350000.000000',
        currency: 'VND',
        role: WorkspaceEconomicRole.WORKSPACE_ECONOMIC_ROLE_SELLER,
      );

      expect(sellerPosting.postingType, equals('seller_commission_expense'));
      expect(sellerPosting.cogsDeducted, isTrue);
      expect(sellerPosting.netProfitImpact, equals('-350000.000000'));
    });

    // ------------------------------------------------------------------------
    // Acceptance Target 2: Ambiguous Attribution Labeled
    // ------------------------------------------------------------------------
    test('Target 2: Ambiguous multi-touch attribution labeled inferred', () {
      // Official single touch
      final official = evaluateMobileAttribution(
        workspaceId: wsId,
        orderId: 'ord-mob-001',
        affiliateLinkId: 'link-001',
        orderAmount: '500000.000000',
        commissionRate: '10.00',
        currency: 'VND',
        touchpointCount: 1,
        isMultiTouch: false,
        isOfficialAPI: true,
      );

      expect(official.sourceClass,
          equals(AttributionSourceClass.ATTRIBUTION_SOURCE_CLASS_OFFICIAL));
      expect(official.confidence,
          equals(AttributionConfidence.ATTRIBUTION_CONFIDENCE_HIGH));

      // Multi-touch ambiguous
      final inferred = evaluateMobileAttribution(
        workspaceId: wsId,
        orderId: 'ord-mob-002',
        affiliateLinkId: 'link-001',
        orderAmount: '800000.000000',
        commissionRate: '10.00',
        currency: 'VND',
        touchpointCount: 2,
        isMultiTouch: true,
        isOfficialAPI: false,
      );

      expect(inferred.sourceClass,
          equals(AttributionSourceClass.ATTRIBUTION_SOURCE_CLASS_INFERRED));
      expect(inferred.confidence,
          equals(AttributionConfidence.ATTRIBUTION_CONFIDENCE_MEDIUM));
      expect(inferred.attributionNote,
          contains('last click rule applied'));
    });

    // ------------------------------------------------------------------------
    // Acceptance Target 3: Broken Link Repair
    // ------------------------------------------------------------------------
    test('Target 3: Broken link repaired recovers healthy status', () {
      const brokenLink = MobileAffiliateLink(
        affiliateLinkId: 'link-broken-test',
        workspaceId: wsId,
        platform: 'shopee',
        originalUrl: 'https://shopee.vn/old-broken',
        trackedUrl: 'https://creativanta.link/brk',
        shortCode: 'brk',
        commissionRate: '12.00',
        lifecycleState:
            AffiliateLinkLifecycleState.AFFILIATE_LINK_LIFECYCLE_STATE_ACTIVE,
        healthStatus: LinkHealthStatus.LINK_HEALTH_STATUS_BROKEN,
        revenueAttributed: '0.000000',
      );

      final repaired = repairMobileBrokenLink(
        brokenLink,
        'https://shopee.vn/new-working',
        replacementProductId: 'prod-new-99',
      );

      expect(
          repaired.healthStatus, equals(LinkHealthStatus.LINK_HEALTH_STATUS_HEALTHY));
      expect(repaired.originalUrl, equals('https://shopee.vn/new-working'));
      expect(repaired.productId, equals('prod-new-99'));

      // Policy revoked link CANNOT be repaired!
      const revokedLink = MobileAffiliateLink(
        affiliateLinkId: 'link-revoked-test',
        workspaceId: wsId,
        platform: 'shopee',
        originalUrl: 'https://shopee.vn/revoked',
        trackedUrl: 'https://creativanta.link/rev',
        shortCode: 'rev',
        commissionRate: '12.00',
        lifecycleState:
            AffiliateLinkLifecycleState.AFFILIATE_LINK_LIFECYCLE_STATE_REVOKED,
        healthStatus: LinkHealthStatus.LINK_HEALTH_STATUS_BROKEN,
        revenueAttributed: '0.000000',
      );

      expect(
        () => repairMobileBrokenLink(revokedLink, 'https://shopee.vn/try-fix'),
        throwsStateError,
      );
    });

    // ------------------------------------------------------------------------
    // Widget Test: Dashboard View Renders & Repairs Link
    // ------------------------------------------------------------------------
    testWidgets('Target 1, 2, 3: Widget test renders dashboard and executes repair',
        (WidgetTester tester) async {
      final links = [
        const MobileAffiliateLink(
          affiliateLinkId: 'link-broken-widget',
          workspaceId: wsId,
          platform: 'tiktok',
          originalUrl: 'https://shop.tiktok.com/dead-item',
          trackedUrl: 'https://creativanta.link/tt-dead',
          shortCode: 'tt-dead',
          commissionRate: '15.00',
          lifecycleState:
              AffiliateLinkLifecycleState.AFFILIATE_LINK_LIFECYCLE_STATE_ACTIVE,
          healthStatus: LinkHealthStatus.LINK_HEALTH_STATUS_BROKEN,
          revenueAttributed: '1500000.000000',
        ),
      ];

      await tester.pumpWidget(MaterialApp(
        home: AffiliateDashboardView(
          workspaceId: wsId,
          initialLinks: links,
        ),
      ));
      await tester.pumpAndSettle();

      // Check Target 1 UI elements
      expect(find.byKey(const Key('ledgerPostingType')), findsOneWidget);
      expect(find.textContaining('creator_income'), findsOneWidget);
      expect(find.textContaining('NO (Pure Creator Income)'), findsOneWidget);

      // Check Target 2 Banner
      expect(find.textContaining('Ambiguous Attribution Notice'), findsOneWidget);

      // Check Target 3 Broken Link & Repair Action
      expect(find.byKey(const Key('repairButton_link-broken-widget')), findsOneWidget);

      // Tap Repair
      await tester.tap(find.byKey(const Key('repairButton_link-broken-widget')));
      await tester.pumpAndSettle();

      // Verify health restored to healthy
      expect(find.byKey(const Key('statusMessageText')), findsOneWidget);
      expect(find.textContaining('repaired successfully'), findsOneWidget);
    });
  });
}

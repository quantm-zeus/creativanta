import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:creativanta_mobile/commerce/commerce_hub_models.dart';
import 'package:creativanta_mobile/ui/commerce/commerce_dashboard_view.dart';

void main() {
  group('P6-09 Mobile Commerce Acceptance Suite', () {
    const wsId = 'ws-p6-mobile-test';

    group('Acceptance Target 1: No Function Lost Between Modules', () {
      test('verifies all 12 modules are present, healthy, and linked', () {
        final modules = MobileCommerceHubStore.getModuleIntegritySummaries();
        expect(modules.length, 12);

        final moduleIds = modules.map((m) => m.moduleId).toList();
        expect(moduleIds, containsAll(['M04', 'M05', 'M09', 'M12', 'M13', 'M14', 'M15', 'M16', 'M17', 'M18', 'S16', 'M19']));

        for (final mod in modules) {
          expect(mod.status, 'HEALTHY');
          expect(mod.connectedLinks, greaterThan(0));
          expect(mod.activeEntities, greaterThan(0));
        }
      });

      test('verifies cross-domain lineage connections across commerce loop', () {
        final links = MobileCommerceHubStore.getCrossModuleLinks();
        expect(links.length, greaterThanOrEqualTo(10));

        final conversions = links.where((l) => l.linkType == 'conversion').toList();
        expect(conversions.length, greaterThanOrEqualTo(3));

        for (final link in links) {
          expect(link.verified, isTrue);
          expect(link.description.length, greaterThan(10));
        }
      });

      testWidgets('renders Overview tab with 12 modules and cross-module linkages', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: CommerceDashboardView(workspaceId: wsId),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('Kinh doanh & Vận hành'), findsOneWidget);
        expect(find.text('TARGET 1: KHÔNG THẤT THOÁT TÍNH NĂNG'), findsOneWidget);
        expect(find.text('Opportunity Board'), findsOneWidget);
        expect(find.text('Monetization OS'), findsOneWidget);
        expect(find.text('Creator Store'), findsOneWidget);
        expect(find.text('Affiliate Network'), findsOneWidget);
        expect(find.text('Live War Room'), findsOneWidget);
        expect(find.text('Seeding CRM'), findsOneWidget);
        expect(find.text('Creator Pro Tools'), findsOneWidget);
      });
    });

    group('Acceptance Target 2: Partial & Unreconciled Outcomes Visible', () {
      test('surfaces partial refunds, physical returns, stock discrepancies, and seeding pending proof', () {
        final outcomes = MobileCommerceHubStore.getInitialUnreconciledOutcomes(wsId);
        expect(outcomes.length, greaterThanOrEqualTo(6));

        // 1. Partial refund
        final partRefund = outcomes.firstWhere((o) => o.id == 'unrec-refund-001');
        expect(partRefund.status, 'partially_refunded');
        expect(partRefund.refundedAmountExact, '200000.000000');
        expect(partRefund.originalCapturedExact, '500000.000000');
        expect(partRefund.physicalReturnState, 'not_returned');

        // 2. Physical return only (RULE-M13-006)
        final retOnly = outcomes.firstWhere((o) => o.id == 'unrec-return-002');
        expect(retOnly.status, 'returned');
        expect(retOnly.refundedAmountExact, '0.000000');
        expect(retOnly.physicalReturnState, 'returned');

        // 3. Stock discrepancy
        final stock = outcomes.firstWhere((o) => o.id == 'unrec-stock-003');
        expect(stock.status, 'stock_discrepancy');
        expect(stock.sourceClass, CommerceSourceClass.unreconciled);
        expect(stock.requiresAuditReason, isTrue);

        // 4. Seeding pending outcome (RULE-M18-002)
        final seeding = outcomes.firstWhere((o) => o.id == 'unrec-seeding-004');
        expect(seeding.status, 'pending_outcome');
        expect(seeding.sourceClass, CommerceSourceClass.estimated);
        expect(seeding.confidenceScore, 0.50);

        // 5. Affiliate statement unmatched
        final aff = outcomes.firstWhere((o) => o.id == 'unrec-affiliate-005');
        expect(aff.status, 'unmatched_statement_item');
        expect(aff.sourceClass, CommerceSourceClass.unreconciled);

        // 6. Brand deal dispute
        final deal = outcomes.firstWhere((o) => o.id == 'unrec-deal-006');
        expect(deal.status, 'disputed_deliverable');
      });

      test('operational repair requires mandatory audit reason', () {
        final outcomes = MobileCommerceHubStore.getInitialUnreconciledOutcomes(wsId);
        const invalidReq = MobileOperationalRepairRequest(
          workspaceId: wsId,
          unreconciledId: 'unrec-stock-003',
          repairType: 'reconcile_stock_adjustment',
          auditReason: '', // Empty
          actorId: 'user-01',
          actorRole: 'manager',
        );

        expect(
          () => MobileCommerceHubStore.applyOperationalRepair(outcomes, invalidReq),
          throwsArgumentError,
        );
      });

      test('operational repair resolves item and prevents duplicate repair', () {
        final outcomes = MobileCommerceHubStore.getInitialUnreconciledOutcomes(wsId);
        const validReq = MobileOperationalRepairRequest(
          workspaceId: wsId,
          unreconciledId: 'unrec-stock-003',
          repairType: 'reconcile_stock_adjustment',
          auditReason: 'Đã xuất kho bù 1 áo mẫu seeding sau kiểm kê',
          actorId: 'user-01',
          actorRole: 'manager',
        );

        final resultObj = MobileCommerceHubStore.applyOperationalRepair(outcomes, validReq);
        expect(resultObj.result.success, isTrue);
        expect(resultObj.result.unreconciledId, 'unrec-stock-003');
        expect(resultObj.result.ledgerPostingId, isNotNull);

        final repaired = resultObj.updatedOutcomes.firstWhere((o) => o.id == 'unrec-stock-003');
        expect(repaired.resolved, isTrue);
        expect(repaired.status, 'reconciled');
        expect(repaired.sourceClass, CommerceSourceClass.official);
        expect(repaired.confidenceScore, 1.0);

        // Duplicate repair throws StateError
        expect(
          () => MobileCommerceHubStore.applyOperationalRepair(resultObj.updatedOutcomes, validReq),
          throwsStateError,
        );
      });

      testWidgets('renders Unreconciled tab and executes operational repair via modal', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: CommerceDashboardView(workspaceId: wsId),
          ),
        );
        await tester.pumpAndSettle();

        // Switch to Tab 1 (Cần Đối soát)
        await tester.tap(find.textContaining('Cần Đối soát (T2)'));
        await tester.pumpAndSettle();

        expect(find.text('TARGET 2: MINH BẠCH KẾT QUẢ BÁN PHẦN & CHƯA ĐỐI SOÁT'), findsOneWidget);
        expect(find.textContaining('Đơn #99 hoàn tiền một phần'), findsOneWidget);
        expect(find.textContaining('Lệch tồn kho Áo thun XL'), findsOneWidget);

        // Tap repair on stock item
        final repairBtn = find.byKey(const Key('repair-btn-unrec-stock-003'));
        expect(repairBtn, findsOneWidget);
        await tester.tap(repairBtn);
        await tester.pumpAndSettle();

        // Modal should appear
        expect(find.text('Sửa chữa vận hành đối soát'), findsOneWidget);
        expect(find.byKey(const Key('repair-audit-reason-field')), findsOneWidget);

        // Submit without reason shows error
        await tester.tap(find.byKey(const Key('submit-repair-button')));
        await tester.pumpAndSettle();
        expect(find.text('Lý do kiểm toán (audit_reason) là bắt buộc'), findsOneWidget);

        // Enter valid reason and submit
        await tester.enterText(find.byKey(const Key('repair-audit-reason-field')), 'Đối chiếu kiểm kê kho xuất bù 1 cái');
        await tester.tap(find.byKey(const Key('submit-repair-button')));
        await tester.pumpAndSettle();

        // Modal dismissed and success banner visible
        expect(find.textContaining('Đã đối soát thành công!'), findsOneWidget);
      });
    });

    group('Acceptance Target 3: Actual Provider / Payment / Shipping Gate Evidence', () {
      test('verifies payment providers with HMAC verification and late recovery', () {
        final summary = MobileCommerceHubStore.getProviderAndShippingGateSummary(wsId);
        expect(summary.paymentGates.length, 4);

        final stripe = summary.paymentGates.firstWhere((p) => p.provider == 'stripe');
        expect(stripe.webhookHmacVerified, isTrue);
        expect(stripe.replayDeduplicated, isTrue);
        expect(stripe.latePaymentRecovery, isTrue);
        expect(stripe.gateStatus, 'VERIFIED_LOCAL_ADAPTER');

        final tiktok = summary.paymentGates.firstWhere((p) => p.provider == 'tiktok_shop');
        expect(tiktok.webhookHmacVerified, isTrue);
      });

      test('verifies shipping carrier logistics tracking and cost posting', () {
        final summary = MobileCommerceHubStore.getProviderAndShippingGateSummary(wsId);
        expect(summary.shippingGates.length, greaterThanOrEqualTo(2));

        final ghn = summary.shippingGates.firstWhere((p) => p.carrier == 'ghn');
        expect(ghn.state, 'delivered');
        expect(ghn.signatureVerified, isTrue);
        expect(ghn.shippingCostExact, '32000.000000');
        expect(ghn.destinationProvince, 'TP. Hồ Chí Minh');

        final ghtk = summary.shippingGates.firstWhere((p) => p.carrier == 'ghtk');
        expect(ghtk.sampleRequestId, 'smp-req-creator-linh');
      });

      test('honestly records external gates without mock pretending to be production keys', () {
        final summary = MobileCommerceHubStore.getProviderAndShippingGateSummary(wsId);
        expect(summary.externalGates.length, 4);

        final gateMap = {for (var g in summary.externalGates) g.gateId: g.status};
        expect(gateMap['EXT-GATE-PAYMENT-STRIPE-LIVE'], 'PENDING_PRODUCTION_KEY');
        expect(gateMap['EXT-GATE-PLATFORM-TIKTOK-PARTNER'], 'PENDING_EXTERNAL_PROVIDER_APPROVAL');
        expect(gateMap['EXT-GATE-SHIPPING-CARRIER-API'], 'PENDING_CARRIER_PRODUCTION_KEY');
        expect(gateMap['EXT-GATE-POSTGRES-LIVE-RLS'], 'PENDING_CI_LIVE_POSTGRES');
      });

      testWidgets('renders Provider and Shipping Gates tab with HMAC and external gate status', (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: CommerceDashboardView(workspaceId: wsId),
          ),
        );
        await tester.pumpAndSettle();

        // Switch to Tab 2 (Cổng Dịch vụ)
        await tester.tap(find.text('Cổng Dịch vụ (T3)'));
        await tester.pumpAndSettle();

        expect(find.text('TARGET 3: BẰNG CHỨNG CỔNG THANH TOÁN & VẬN CHUYỂN'), findsOneWidget);
        expect(find.text('STRIPE'), findsOneWidget);
        expect(find.text('TIKTOK_SHOP'), findsOneWidget);
        expect(find.textContaining('Xác minh chữ ký HMAC: ĐẠT'), findsWidgets);

        // Scroll down to see shipping and external gates
        await tester.drag(find.byType(ListView), const Offset(0, -400));
        await tester.pumpAndSettle();

        expect(find.textContaining('GHN • GHN-8829103-ORD-99'), findsOneWidget);

        await tester.drag(find.byType(ListView), const Offset(0, -300));
        await tester.pumpAndSettle();

        expect(find.text('EXT-GATE-PAYMENT-STRIPE-LIVE'), findsOneWidget);
        expect(find.text('PENDING_PRODUCTION_KEY'), findsOneWidget);
      });
    });
  });
}

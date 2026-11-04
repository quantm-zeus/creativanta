import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:creativanta_mobile/commerce/seeding_models.dart';
import 'package:creativanta_mobile/ui/commerce/seeding_view.dart';

void main() {
  group('P6-06 Mobile Seeding CRM, Shipments & Costs/Outcomes Acceptance Suite (M18)', () {
    const workspaceId = 'ws-mobile-seeding-test-01';

    // ------------------------------------------------------------------------
    // TARGET 1: Request, shipment, outcome, and follow-up states separate
    // ------------------------------------------------------------------------
    test('Target 1: Lifecycle, shipment, outcome, and follow-up states remain strictly orthogonal', () {
      final req = MobileSampleRequest(
        requestId: 'req-target-1',
        workspaceId: workspaceId,
        productId: 'prod-t1',
        productTitle: 'Serum HA',
        productCogs: '150000.000000',
        creatorEntityId: 'creator-t1',
        creatorName: 'Nguyen Van A',
        creatorHandle: '@nguyenvana',
        status: MobileSampleRequestStatus.requested,
        quantity: 2,
        outcomeStatus: MobileSampleOutcomeStatus.pending,
        followUpStatus: MobileFollowUpStatus.pendingFollowup,
        shippingAddress: const MobileShippingAddress(
          name: 'Nguyen Van A',
          phone: '0901234567',
          addressLine1: '123 Le Loi',
          city: 'Ho Chi Minh',
          country: 'VN',
        ),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      // 1. Initial states
      expect(req.status, MobileSampleRequestStatus.requested);
      expect(req.outcomeStatus, MobileSampleOutcomeStatus.pending);
      expect(req.followUpStatus, MobileFollowUpStatus.pendingFollowup);
      expect(req.shipment, isNull);

      // 2. Approve: transitions request status only, outcome remains pending
      final approved = req.copyWith(
        status: MobileSampleRequestStatus.approved,
      );
      expect(approved.status, MobileSampleRequestStatus.approved);
      expect(approved.outcomeStatus, MobileSampleOutcomeStatus.pending);
      expect(approved.followUpStatus, MobileFollowUpStatus.pendingFollowup);

      // 3. Ship: adds shipment with shipped status, outcome still pending
      final shipped = approved.copyWith(
        shipment: MobileSampleShipment(
          shipmentId: 'ship-t1',
          requestId: req.requestId,
          workspaceId: workspaceId,
          trackingNumber: 'GHTK123456',
          carrier: 'GHTK',
          shippingCost: '30000.000000',
          status: MobileSampleShipmentStatus.shipped,
          shippedAt: DateTime.now(),
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      );
      expect(shipped.status, MobileSampleRequestStatus.approved);
      expect(shipped.shipment!.status, MobileSampleShipmentStatus.shipped);
      expect(shipped.outcomeStatus, MobileSampleOutcomeStatus.pending);

      // 4. Mark Received: logistics fulfilled, follow-up starts, outcome remains pending!
      final delivered = shipped.copyWith(
        status: MobileSampleRequestStatus.fulfilled,
        shipment: shipped.shipment!.copyWith(
          status: MobileSampleShipmentStatus.delivered,
          deliveredAt: DateTime.now(),
        ),
        followUpStatus: MobileFollowUpStatus.contacted,
      );
      expect(delivered.status, MobileSampleRequestStatus.fulfilled);
      expect(delivered.shipment!.status, MobileSampleShipmentStatus.delivered);
      expect(delivered.followUpStatus, MobileFollowUpStatus.contacted);
      // TARGET 1 CRITICAL: Outcome status is STILL PENDING!
      expect(delivered.outcomeStatus, MobileSampleOutcomeStatus.pending);

      // 5. Link Content Outcome independently
      final completed = delivered.copyWith(
        outcomeStatus: MobileSampleOutcomeStatus.logged,
        outcome: MobileSampleOutcome(
          contentUrl: 'https://tiktok.com/@nguyenvana/video/1',
          contentType: 'video',
          publishItemId: 'pub-1',
          conversionsCount: 10,
          attributableRevenue: '1200000.000000',
          sourceClass: MobileSeedingSourceClass.official,
          confidenceLevel: MobileConfidenceLevel.high,
          loggedAt: DateTime.now(),
        ),
      );
      expect(completed.outcomeStatus, MobileSampleOutcomeStatus.logged);
      expect(completed.outcome!.attributableRevenue, '1200000.000000');
      // Request logistics remains fulfilled
      expect(completed.status, MobileSampleRequestStatus.fulfilled);
      expect(completed.shipment!.status, MobileSampleShipmentStatus.delivered);
    });

    // ------------------------------------------------------------------------
    // TARGET 2: Missing outcome not definitive zero
    // ------------------------------------------------------------------------
    test('Target 2: Missing outcome on delivered samples is qualified as pending, not definitive zero', () {
      final reqs = [
        MobileSampleRequest(
          requestId: 'req-pending-outcome',
          workspaceId: workspaceId,
          productId: 'prod-t2',
          productTitle: 'Skincare Kit',
          productCogs: '200000.000000',
          creatorEntityId: 'creator-t2',
          creatorName: 'Tran Thi B',
          creatorHandle: '@tranthib',
          status: MobileSampleRequestStatus.fulfilled,
          quantity: 1,
          outcomeStatus: MobileSampleOutcomeStatus.pending, // Delivered 30d ago, no content yet
          followUpStatus: MobileFollowUpStatus.noResponse,
          shippingAddress: const MobileShippingAddress(
            name: 'Tran Thi B',
            phone: '0912345678',
            addressLine1: '456 Le Duan',
            city: 'Da Nang',
            country: 'VN',
          ),
          shipment: MobileSampleShipment(
            shipmentId: 'ship-t2',
            requestId: 'req-pending-outcome',
            workspaceId: workspaceId,
            trackingNumber: 'VN654321',
            carrier: 'ViettelPost',
            shippingCost: '35000.000000',
            status: MobileSampleShipmentStatus.delivered,
            shippedAt: DateTime.now().subtract(const Duration(days: 32)),
            deliveredAt: DateTime.now().subtract(const Duration(days: 30)),
            createdAt: DateTime.now().subtract(const Duration(days: 32)),
            updatedAt: DateTime.now().subtract(const Duration(days: 30)),
          ),
          createdAt: DateTime.now().subtract(const Duration(days: 35)),
          updatedAt: DateTime.now().subtract(const Duration(days: 30)),
        ),
      ];

      final report = computeMobileSeedingReport(
        requests: reqs,
        workspaceId: workspaceId,
      );

      // Total cost = 1 * 200,000 + 35,000 = 235,000 VND
      expect(report.totalCost, '235000.000000');
      expect(report.totalSamplesDelivered, 1);
      expect(report.outcomesLoggedCount, 0);
      expect(report.pendingOutcomesCount, 1);
      expect(report.isMissingOutcomePending, isTrue);

      // Must qualify overall confidence: cannot be High
      expect(report.overallConfidence, isNot(MobileConfidenceLevel.high));
      expect(report.overallConfidence, MobileConfidenceLevel.medium);

      // Must explicitly note that missing outcome is not counted as zero revenue
      final noteStr = report.confidenceNotes.join(' ').toLowerCase();
      expect(noteStr, contains('pending'));
      expect(noteStr, contains('not counted as zero revenue'));
    });

    // ------------------------------------------------------------------------
    // TARGET 3: Replay no duplicate sample cost
    // ------------------------------------------------------------------------
    test('Target 3: Idempotent cost evaluation prevents duplicate cost items on replay', () {
      final List<MobileSeedingCostItem> costLedger = [];
      const reqId = 'req-replay-001';
      const idempApprove = 'idemp-appr-key-99';

      // 1. First approval: creates provisional cost item (2 * 100,000 = 200,000 VND)
      final res1 = evaluateMobileIdempotentCost(
        existingCostItems: costLedger,
        requestId: reqId,
        workspaceId: workspaceId,
        quantity: 2,
        unitCogs: '100000.000000',
        shippingCost: '0.000000',
        idempotencyKey: idempApprove,
        isShippingUpdate: false,
      );
      expect(res1.isReplay, isFalse);
      expect(res1.costItems.length, 1);
      expect(res1.totalCost, '200000.000000');

      // 2. Replay approval: must return existing item without duplicating
      final res2 = evaluateMobileIdempotentCost(
        existingCostItems: res1.costItems,
        requestId: reqId,
        workspaceId: workspaceId,
        quantity: 2,
        unitCogs: '100000.000000',
        shippingCost: '0.000000',
        idempotencyKey: idempApprove,
        isShippingUpdate: false,
      );
      expect(res2.isReplay, isTrue);
      expect(res2.costItems.length, 1); // STILL 1!
      expect(res2.totalCost, '200000.000000');

      // 3. Shipping update: updates cost item in-place with actual shipping (200,000 + 40,000 = 240,000 VND)
      final res3 = evaluateMobileIdempotentCost(
        existingCostItems: res2.costItems,
        requestId: reqId,
        workspaceId: workspaceId,
        quantity: 2,
        unitCogs: '100000.000000',
        shippingCost: '40000.000000',
        idempotencyKey: 'idemp-ship-key-100',
        isShippingUpdate: true,
      );
      expect(res3.isReplay, isTrue);
      expect(res3.costItems.length, 1); // STILL 1!
      expect(res3.totalCost, '240000.000000');
      expect(res3.activeCostItem.sourceClass, MobileSeedingSourceClass.imported);
    });

    // ------------------------------------------------------------------------
    // Edge Cases EC-M18-001 to EC-M18-004
    // ------------------------------------------------------------------------
    test('Edge Case EC-M18-001: Sample delivered but no creator response preserves pending outcome', () {
      final req = MobileSampleRequest(
        requestId: 'req-ec-001',
        workspaceId: workspaceId,
        productId: 'prod-001',
        productTitle: 'Lipstick',
        productCogs: '80000.000000',
        creatorEntityId: 'creator-unresp',
        creatorName: 'Ghost Creator',
        creatorHandle: '@ghost',
        status: MobileSampleRequestStatus.fulfilled,
        quantity: 1,
        outcomeStatus: MobileSampleOutcomeStatus.pending,
        followUpStatus: MobileFollowUpStatus.noResponse,
        shippingAddress: const MobileShippingAddress(
          name: 'Ghost',
          phone: '0900000000',
          addressLine1: 'Line 1',
          city: 'City',
          country: 'VN',
        ),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      expect(req.followUpStatus, MobileFollowUpStatus.noResponse);
      expect(req.outcomeStatus, MobileSampleOutcomeStatus.pending); // Not failed
    });

    // ------------------------------------------------------------------------
    // Widget Test: MobileSeedingView UI
    // ------------------------------------------------------------------------
    testWidgets('MobileSeedingView renders summary card, chips, request cards and triggers actions', (tester) async {
      tester.view.physicalSize = const Size(1200, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        const MaterialApp(
          home: MobileSeedingView(),
        ),
      );
      await tester.pumpAndSettle();

      // 1. Verify summary card renders
      expect(find.byKey(const Key('seeding-summary-card')), findsOneWidget);
      expect(find.text('Hiệu quả Seeding (ROI)'), findsOneWidget);
      expect(find.text('Tổng chi phí'), findsOneWidget);
      expect(find.text('Doanh thu gán'), findsOneWidget);

      // 2. Verify filter chips render
      expect(find.byKey(const Key('chip-filter-all')), findsOneWidget);
      expect(find.byKey(const Key('chip-filter-pending')), findsOneWidget);
      expect(find.byKey(const Key('chip-filter-shipped')), findsOneWidget);
      expect(find.byKey(const Key('chip-filter-received')), findsOneWidget);
      expect(find.byKey(const Key('chip-filter-content')), findsOneWidget);

      // 3. Verify request cards render
      expect(find.byKey(const Key('card-request-req-beauty-girl')), findsOneWidget);
      expect(find.byKey(const Key('card-request-req-skincare-tips')), findsOneWidget);
      expect(find.byKey(const Key('card-request-req-makeup-daily')), findsOneWidget);

      // 4. Test Approve Action on requested card
      final approveBtn = find.byKey(const Key('btn-approve-req-makeup-daily'));
      expect(approveBtn, findsOneWidget);
      await tester.tap(approveBtn);
      await tester.pumpAndSettle();

      // Status message updated
      expect(find.byKey(const Key('status-banner')), findsOneWidget);
      expect(find.text('Đã duyệt yêu cầu và tạo chi phí ước tính'), findsOneWidget);

      // 5. Test Ship Action on approved card
      final shipBtn = find.byKey(const Key('btn-ship-req-makeup-daily'));
      expect(shipBtn, findsOneWidget);
      await tester.tap(shipBtn);
      await tester.pumpAndSettle();
      expect(find.text('Đã gửi hàng & cập nhật chi phí vận chuyển'), findsOneWidget);

      // 6. Test Deliver Action on shipped card
      final deliverBtn = find.byKey(const Key('btn-deliver-req-makeup-daily'));
      expect(deliverBtn, findsOneWidget);
      await tester.tap(deliverBtn);
      await tester.pumpAndSettle();
      expect(find.text('Xác nhận creator đã nhận hàng (outcome đang chờ)'), findsOneWidget);

      // 7. Test Link Outcome Action on delivered card
      final linkOutcomeBtn = find.byKey(const Key('btn-link-outcome-req-makeup-daily'));
      expect(linkOutcomeBtn, findsOneWidget);
      await tester.tap(linkOutcomeBtn);
      await tester.pumpAndSettle();
      expect(find.text('Đã ghi nhận video review và doanh thu quy đổi'), findsOneWidget);
    });
  });
}

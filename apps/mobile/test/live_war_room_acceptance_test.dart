import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:creativanta_mobile/commerce/live_war_room_models.dart';
import 'package:creativanta_mobile/generated/creativanta/commerce/v1/live.pb.dart';
import 'package:creativanta_mobile/ui/commerce/live_war_room_view.dart';

void main() {
  const workspaceId = '019086a1-7c3e-7000-8000-000000000001';

  group('M17 Live War Room Mobile Acceptance Suite', () {
    test('Target 1: Reconnect does not duplicate commands', () {
      final controller = MobileLiveWarRoomController();

      // 1. Create Session with idempotency key
      const idempCreate = 'mob-idemp-create-001';
      final create1 = controller.createSession(
        workspaceId: workspaceId,
        title: 'Mega TikTok Live',
        idempotencyKey: idempCreate,
      );
      expect(create1.isDuplicate, isFalse);
      expect(create1.session.status, equals(LiveSessionStatus.LIVE_SESSION_STATUS_PLANNED));

      // Reconnect and replay
      final create2 = controller.createSession(
        workspaceId: workspaceId,
        title: 'Mega TikTok Live',
        idempotencyKey: idempCreate,
      );
      expect(create2.isDuplicate, isTrue);
      expect(create2.session.sessionId, equals(create1.session.sessionId));

      // 2. Start Session with idempotency key
      const idempStart = 'mob-idemp-start-001';
      final start1 = controller.startSession(idempotencyKey: idempStart);
      expect(start1.isDuplicate, isFalse);
      expect(start1.session.status, equals(LiveSessionStatus.LIVE_SESSION_STATUS_LIVE));

      final start2 = controller.startSession(idempotencyKey: idempStart);
      expect(start2.isDuplicate, isTrue);
      expect(start2.session.status, equals(LiveSessionStatus.LIVE_SESSION_STATUS_LIVE));

      // 3. Add Cue Card with idempotency key
      const idempCue = 'mob-idemp-cue-001';
      final cue1 = controller.addCue(
        cueType: 'product_highlight',
        title: 'Serum HA 30% Off',
        body: 'Mention discount code now',
        pinnedProductId: 'prod-001',
        idempotencyKey: idempCue,
      );
      expect(cue1.isDuplicate, isFalse);
      expect(controller.cueCards.length, equals(1));

      final cue2 = controller.addCue(
        cueType: 'product_highlight',
        title: 'Serum HA 30% Off',
        body: 'Mention discount code now',
        pinnedProductId: 'prod-001',
        idempotencyKey: idempCue,
      );
      expect(cue2.isDuplicate, isTrue);
      expect(controller.cueCards.length, equals(1));

      // 4. Trigger Cue Card with idempotency key
      const idempTrig = 'mob-idemp-trig-001';
      final trig1 = controller.triggerCue(cue1.cueCard.cueCardId, idempotencyKey: idempTrig);
      expect(trig1.isDuplicate, isFalse);
      expect(trig1.cueCard.status, equals(CueCardStatus.CUE_CARD_STATUS_USED));

      final trig2 = controller.triggerCue(cue1.cueCard.cueCardId, idempotencyKey: idempTrig);
      expect(trig2.isDuplicate, isTrue);

      // 5. Highlight Product Pin
      const idempPin = 'mob-idemp-pin-001';
      final pin1 = controller.highlightProduct(
        productId: 'prod-001',
        offerId: 'off-001',
        isPinned: true,
        idempotencyKey: idempPin,
      );
      expect(pin1.isDuplicate, isFalse);

      final pin2 = controller.highlightProduct(
        productId: 'prod-001',
        offerId: 'off-001',
        isPinned: true,
        idempotencyKey: idempPin,
      );
      expect(pin2.isDuplicate, isTrue);

      // 6. Create Highlight
      const idempHl = 'mob-idemp-hl-001';
      final hl1 = controller.createHighlight(
        title: 'Flash Sale Peak',
        highlightType: 'viral_moment',
        startSec: 100,
        endSec: 140,
        idempotencyKey: idempHl,
      );
      expect(hl1.isDuplicate, isFalse);
      expect(controller.highlights.length, equals(1));

      final hl2 = controller.createHighlight(
        title: 'Flash Sale Peak',
        highlightType: 'viral_moment',
        startSec: 100,
        endSec: 140,
        idempotencyKey: idempHl,
      );
      expect(hl2.isDuplicate, isTrue);
      expect(controller.highlights.length, equals(1));
    });

    test('Target 2: M07 extracts, M09 registers clips', () {
      final controller = MobileLiveWarRoomController();
      controller.createSession(workspaceId: workspaceId, title: 'Extraction Test');
      controller.startSession();

      controller.createHighlight(title: 'Intro Drop', highlightType: 'intro', startSec: 0, endSec: 30);
      controller.createHighlight(title: 'Product Showcase', highlightType: 'product_demo', startSec: 100, endSec: 160);
      controller.createHighlight(title: 'Q&A Answer', highlightType: 'qa_prompt', startSec: 200, endSec: 240);

      expect(controller.highlights.length, equals(3));
      for (final hl in controller.highlights) {
        expect(hl.assetId, isNull);
      }

      // Execute extraction
      const sourceAssetId = 'rec-source-001';
      final ext = controller.extractHighlights(sourceAssetId: sourceAssetId, idempotencyKey: 'ext-001');

      expect(ext.isDuplicate, isFalse);
      expect(ext.extractedCount, equals(3));
      expect(ext.registeredAssetIds.length, equals(3));

      // Highlights must have derivative asset IDs linked
      for (final hl in controller.highlights) {
        expect(hl.assetId, isNotNull);
        expect(hl.assetId, startsWith('m09-clip-'));
      }
    });

    test('Target 3: Revenue traceable and labeled', () {
      final controller = MobileLiveWarRoomController();
      controller.createSession(workspaceId: workspaceId, title: 'Revenue Traceability');
      controller.startSession();

      // Attach 3 orders arriving during live
      controller.attachOrder(const MobileTraceableOrder(
        orderId: 'ORD-M-101',
        productId: 'prod-001',
        offerId: 'off-001',
        customerId: 'cust-101',
        amount: '250000.000000',
        currency: 'VND',
        reconciliationState: 'matched',
      ));
      controller.attachOrder(const MobileTraceableOrder(
        orderId: 'ORD-M-102',
        productId: 'prod-002',
        offerId: 'off-002',
        customerId: 'cust-102',
        amount: '350000.000000',
        currency: 'VND',
        reconciliationState: 'matched',
      ));
      controller.attachOrder(const MobileTraceableOrder(
        orderId: 'ORD-M-103',
        productId: 'prod-001',
        offerId: 'off-001',
        customerId: 'cust-103',
        amount: '150000.000000',
        currency: 'VND',
        reconciliationState: 'matched',
      ));

      final summary = controller.generateProofSummary();

      expect(summary.sourceClass, equals('live_attributed'));
      expect(summary.totalOrders, equals(3));
      // 250,000 + 350,000 + 150,000 = 750,000.000000
      expect(summary.totalRevenue, equals('750000.000000'));
      expect(summary.orders.length, equals(3));

      for (final order in summary.orders) {
        expect(order.orderId.isNotEmpty, isTrue);
        expect(order.productId.isNotEmpty, isTrue);
        expect(order.offerId.isNotEmpty, isTrue);
        expect(order.amount.isNotEmpty, isTrue);
      }
    });

    testWidgets('Renders MobileLiveWarRoomView widget successfully', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: MobileLiveWarRoomView(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('🔴 LIVE'), findsOneWidget);
      expect(find.text('📊 Chỉ số thời gian thực'), findsOneWidget);
      expect(find.text('📌 Sản phẩm đang ghim'), findsOneWidget);
      expect(find.text('ĐANG GHIM'), findsOneWidget);
      expect(find.text('Thẻ nhắc bài (Cue Cards)'), findsOneWidget);
      expect(find.text('Serum HA 50ml — Giảm 30%'), findsOneWidget);

      // Tap on Trigger Cue
      await tester.tap(find.text('Nhắc'));
      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.check_circle), findsOneWidget);

      // Tap on Analytics Summary button in AppBar
      await tester.tap(find.byIcon(Icons.analytics_outlined));
      await tester.pumpAndSettle();
      expect(find.text('📜 BÁO CÁO CHỨNG THỰC M19 (PROVED)'), findsOneWidget);
      expect(find.text('Nhãn nguồn thu: live_attributed'), findsOneWidget);
    });
  });
}

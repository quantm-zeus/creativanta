import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:creativanta_mobile/commerce/store_models.dart';
import 'package:creativanta_mobile/ui/commerce/store_view.dart';

void main() {
  group('P6-02 Mobile Creator Store, Bundles & Memberships Acceptance Suite (M15)', () {
    const workspaceId = 'ws-mobile-store-test-01';

    // ------------------------------------------------------------------------
    // TARGET 1: Bundle stock atomic
    // ------------------------------------------------------------------------
    test('Target 1: Bundle stock check succeeds when all components have inventory', () {
      const bundle = MobileBundle(
        bundleId: 'bun-starter',
        workspaceId: workspaceId,
        title: 'Starter Pack',
        bundlePrice: '990000.000000',
        currency: 'VND',
        items: [
          MobileBundleItem(productId: 'item-1', productTitle: 'Item 1', quantity: 1),
          MobileBundleItem(productId: 'item-2', productTitle: 'Item 2', quantity: 2),
        ],
      );

      final stock = {'item-1': 10, 'item-2': 10}; // 10/2 = 5 bundles
      final res = checkMobileBundleStock(bundle, stock, 1);

      expect(res.isAvailable, isTrue);
      expect(res.reason, isNull);
      expect(res.maxPossibleUnits, 5);
    });

    test('Target 1: Any component out-of-stock marks bundle unavailable atomically', () {
      const bundle = MobileBundle(
        bundleId: 'bun-starter',
        workspaceId: workspaceId,
        title: 'Starter Pack',
        bundlePrice: '990000.000000',
        currency: 'VND',
        items: [
          MobileBundleItem(productId: 'item-1', productTitle: 'Microphone', quantity: 1),
          MobileBundleItem(productId: 'item-2', productTitle: 'Audio Cable', quantity: 1),
        ],
      );

      final stock = {'item-1': 5, 'item-2': 0}; // item-2 is empty
      final res = checkMobileBundleStock(bundle, stock, 1);

      expect(res.isAvailable, isFalse);
      expect(res.reason, contains("Component 'Audio Cable' has insufficient stock"));
      expect(res.maxPossibleUnits, 0);
    });

    test('Target 1: Checkout ledger fails closed without leaking inventory reservations', () {
      final ledger = MobileCheckoutLedger();
      ledger.stockMap['item-1'] = 5;
      ledger.stockMap['item-2'] = 0;

      const bundle = MobileBundle(
        bundleId: 'bun-starter',
        workspaceId: workspaceId,
        title: 'Starter Pack',
        bundlePrice: '990000.000000',
        currency: 'VND',
        items: [
          MobileBundleItem(productId: 'item-1', productTitle: 'Item 1', quantity: 1),
          MobileBundleItem(productId: 'item-2', productTitle: 'Item 2', quantity: 1),
        ],
      );

      const req = MobileCheckoutRequest(
        workspaceId: workspaceId,
        customerEntityId: 'cust-1',
        idempotencyKey: 'idem-fail-stock',
        paymentIntentId: 'pi-fail-stock',
        bundleId: 'bun-starter',
        orderAmount: '990000.000000',
        currency: 'VND',
      );

      expect(
        () => ledger.processCheckout(req, bundle: bundle),
        throwsA(isA<StateError>()),
      );

      // Verify no stock was deducted
      expect(ledger.stockMap['item-1'], 5);
      expect(ledger.stockMap['item-2'], 0);
    });

    // ------------------------------------------------------------------------
    // TARGET 2: Payment replay no duplicate delivery
    // ------------------------------------------------------------------------
    test('Target 2: Payment replay returns existing order and tokens without duplication', () {
      final ledger = MobileCheckoutLedger();
      const req = MobileCheckoutRequest(
        workspaceId: workspaceId,
        customerEntityId: 'cust-replay-1',
        idempotencyKey: 'idem-mobile-pay-1',
        paymentIntentId: 'pi-mobile-stripe-1',
        orderAmount: '199000.000000',
        currency: 'VND',
      );

      // Initial checkout
      final res1 = ledger.processCheckout(req, digitalProductIds: ['digital-asset-1']);
      expect(res1.success, isTrue);
      expect(res1.isReplayed, isFalse);
      expect(res1.deliveries.length, 1);
      final token = res1.deliveries.first.downloadToken;

      // Replay same idempotency key
      final res2 = ledger.processCheckout(req, digitalProductIds: ['digital-asset-1']);
      expect(res2.success, isTrue);
      expect(res2.isReplayed, isTrue);
      expect(res2.orderId, res1.orderId);
      expect(res2.deliveries.first.downloadToken, token);

      // Replay different key but same paymentIntentId
      const reqSamePI = MobileCheckoutRequest(
        workspaceId: workspaceId,
        customerEntityId: 'cust-replay-1',
        idempotencyKey: 'idem-different-key',
        paymentIntentId: 'pi-mobile-stripe-1',
        orderAmount: '199000.000000',
        currency: 'VND',
      );
      final res3 = ledger.processCheckout(reqSamePI, digitalProductIds: ['digital-asset-1']);
      expect(res3.isReplayed, isTrue);
      expect(res3.orderId, res1.orderId);
    });

    // ------------------------------------------------------------------------
    // TARGET 3: Buyer subscription cannot unlock SaaS privileges
    // ------------------------------------------------------------------------
    test('Target 3: Buyer store membership strictly rejected for SaaS workspace privileges', () {
      const saasActions = [
        'store:manage',
        'product:manage',
        'workspace:admin',
        'workspace:read',
        'workspace:write',
        'workspace:delete',
        'billing:manage',
        'team:invite',
        'campaign:manage',
        'order:fulfill',
      ];

      for (final action in saasActions) {
        final check = validateMobileBuyerPrivilegeBoundary(true, action);
        expect(check.allowed, isFalse);
        expect(check.denialReason, contains('Privilege escalation blocked'));
      }
    });

    test('Target 3: Buyer store membership permits store customer perks', () {
      final allowedPerks = ['content:access', 'discount:view', 'store:browse'];
      for (final perk in allowedPerks) {
        final check = validateMobileBuyerPrivilegeBoundary(true, perk);
        expect(check.allowed, isTrue);
        expect(check.denialReason, isNull);
      }
    });

    test('Target 3: Workspace team member role is not blocked by buyer privilege barrier', () {
      final check = validateMobileBuyerPrivilegeBoundary(false, 'store:manage');
      expect(check.allowed, isTrue);
    });

    // ------------------------------------------------------------------------
    // UI Widget Test: MobileStoreView renders and displays targets
    // ------------------------------------------------------------------------
    testWidgets('MobileStoreView renders and displays all acceptance targets correctly', (tester) async {
      tester.view.physicalSize = const Size(1200, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        const MaterialApp(
          home: MobileStoreView(),
        ),
      );
      await tester.pumpAndSettle();

      // Verify title
      expect(find.text('Creator Store & Memberships (M15)'), findsOneWidget);
      expect(find.text('Cửa hàng chính (Creator Store)'), findsOneWidget);

      // Verify Target 1 indicator
      expect(find.text('Target 1: Bundle Stock Atomic'), findsOneWidget);
      expect(find.text('HẾT HÀNG TẠM THỜI'), findsOneWidget);

      // Verify Target 2 buttons
      expect(find.text('Thanh toán mới'), findsOneWidget);
      expect(find.text('Replay cùng Key'), findsOneWidget);

      // Tap 'Replay cùng Key'
      await tester.tap(find.text('Replay cùng Key'));
      await tester.pumpAndSettle();
      expect(find.textContaining('Đơn hàng: ord-pi-stripe-mob-001'), findsOneWidget);

      // Verify Target 3 privilege barrier
      expect(find.text('Target 3: Buyer Privilege Barrier (Hội viên không mở quyền SaaS)'), findsOneWidget);
      expect(find.textContaining('Privilege escalation blocked'), findsOneWidget);
    });
  });
}

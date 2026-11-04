import 'package:flutter_test/flutter_test.dart';
import 'package:creativanta_mobile/commerce/fulfillment_adapter_models.dart';

void main() {
  group('P6-07 Mobile Fulfillment, Returns, Refunds and Operating Ledger Suite', () {
    // ------------------------------------------------------------------------
    // TARGET 1: Stock Sync & Polling Delta (I10)
    // ------------------------------------------------------------------------
    test('Target 1: computeStockDelta correctly handles delta and duplicate poll no-ops', () {
      final delta1 = computeStockDelta(10, 15);
      expect(delta1['delta'], equals(5));
      expect(delta1['isNoOp'], isFalse);

      final delta2 = computeStockDelta(15, 15);
      expect(delta2['delta'], equals(0));
      expect(delta2['isNoOp'], isTrue);
    });

    test('Target 1: evaluatePlatformCapability falls back gracefully when unverified', () {
      final verified = evaluatePlatformCapability(MobileCommercePlatform.tiktok, true);
      expect(verified.status, equals('verified'));
      expect(verified.isNative, isTrue);

      final manual = evaluatePlatformCapability(MobileCommercePlatform.lazada, false);
      expect(manual.status, equals('manual'));
      expect(manual.isNative, isFalse);
      expect(manual.reason, contains('fallback to authorized CSV'));
    });

    // ------------------------------------------------------------------------
    // TARGET 2: Correcting Fees Preserve Proof (F06)
    // ------------------------------------------------------------------------
    test('Target 2: calculateNetProfit exact micros deduction matches operating ledger formula', () {
      final net = calculateNetProfit(
        grossRevenue: '1000000',
        platformFee: '100000',
        shippingCost: '20000',
        affiliateCommission: '50000',
        cogs: '400000',
        refundDeductions: '0',
      );
      // 1,000,000 - 100,000 - 20,000 - 50,000 - 400,000 = 430,000
      expect(net, equals('430000'));
    });

    // ------------------------------------------------------------------------
    // TARGET 3: No Double Refund or Restock (Cumulative Bounds & Orthogonality)
    // ------------------------------------------------------------------------
    test('Target 3: validateReturnBounds prevents returning more than purchased line quantity', () {
      const orderItems = [
        MobileOrderItem(sku: 'sku-jacket-m', name: 'Winter Jacket', quantity: 2, unitPrice: '800000'),
      ];

      final priorReturns = [
        MobileReturnRecord(
          returnId: 'ret-01',
          orderId: 'ord-01',
          items: const [MobileReturnItem(sku: 'sku-jacket-m', quantity: 1)],
          lifecycleState: MobileReturnLifecycleState.received,
          createdAt: DateTime.utc(2026, 11, 4),
        ),
      ];

      // Second return of 1 item -> Allowed (1 + 1 = 2)
      expect(
        validateReturnBounds(orderItems, priorReturns, const [MobileReturnItem(sku: 'sku-jacket-m', quantity: 1)]),
        isTrue,
      );

      // Return of 2 items -> Rejected (1 + 2 = 3 > 2)
      expect(
        validateReturnBounds(orderItems, priorReturns, const [MobileReturnItem(sku: 'sku-jacket-m', quantity: 2)]),
        isFalse,
      );
    });

    test('Target 3: validateRefundBounds enforces cumulative refund <= captured amount', () {
      const orderAmount = '500000'; // 500,000 VND
      final priorRefunds = [
        MobileRefundRecord(
          refundId: 'ref-01',
          orderId: 'ord-01',
          amount: '200000',
          currency: 'VND',
          lifecycleState: MobileRefundLifecycleState.completed,
          reason: 'Customer complaint',
          createdAt: DateTime.utc(2026, 11, 4),
        ),
      ];

      // Remaining is 300,000. Refund of 300,000 is allowed:
      expect(validateRefundBounds(orderAmount, priorRefunds, '300000'), isTrue);

      // Refund of 350,000 exceeds 300,000 -> Rejected:
      expect(validateRefundBounds(orderAmount, priorRefunds, '350000'), isFalse);
    });
  });
}

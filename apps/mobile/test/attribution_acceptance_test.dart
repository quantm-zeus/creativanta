import 'package:flutter_test/flutter_test.dart';
import 'package:creativanta_mobile/attribution/attribution_models.dart';
import 'package:creativanta_mobile/attribution/attribution_service.dart';

void main() {
  group('P5-03 Mobile Attribution Acceptance Tests', () {
    test('Target 1: Workspace revenue counted once and order net capacity enforced', () {
      const wsId = 'ws-mobile-test';
      final orders = [
        const CanonicalOrder(
          orderId: 'ord-1',
          workspaceId: wsId,
          grossRevenue: '100000.000000',
          refundDeductions: '0.000000',
          netRevenue: '100000.000000',
          currency: 'VND',
          sourceClass: SourceClass.official,
          confidence: ConfidenceBand.high,
          isRecognized: true,
        ),
        const CanonicalOrder(
          orderId: 'ord-2',
          workspaceId: wsId,
          grossRevenue: '200000.000000',
          refundDeductions: '0.000000',
          netRevenue: '200000.000000',
          currency: 'VND',
          sourceClass: SourceClass.official,
          confidence: ConfidenceBand.high,
          isRecognized: true,
        ),
      ];

      // Multiple attributions across derivatives/posts pointing to ord-1
      final attributions = [
        const AttributionRecord(
          attributionId: 'a1',
          workspaceId: wsId,
          orderId: 'ord-1',
          attributionType: 'direct_click',
          revenueAttributed: '60000.000000',
          sourceClass: SourceClass.official,
          confidence: ConfidenceBand.high,
        ),
        const AttributionRecord(
          attributionId: 'a2',
          workspaceId: wsId,
          orderId: 'ord-1',
          attributionType: 'utm_match',
          revenueAttributed: '40000.000000',
          sourceClass: SourceClass.official,
          confidence: ConfidenceBand.high,
        ),
        const AttributionRecord(
          attributionId: 'a3',
          workspaceId: wsId,
          orderId: 'ord-2',
          attributionType: 'affiliate',
          revenueAttributed: '150000.000000',
          sourceClass: SourceClass.official,
          confidence: ConfidenceBand.high,
        ),
      ];

      final summary = AttributionService.deduplicateWorkspaceRevenue(wsId, orders, attributions);

      // Target 1 Verification:
      // Canonical workspace revenue = 100,000 + 200,000 = 300,000.000000 (COUNTED ONCE!)
      expect(summary.uniqueOrdersCounted, equals(2));
      expect(summary.canonicalWorkspaceRevenue, equals('300000.000000'));
      expect(summary.sumAttributionLines, equals('250000.000000'));
      expect(summary.isRevenueCountedOnce, isTrue);
      expect(summary.aggregateConfidence, equals(ConfidenceBand.high));
      expect(summary.includesEstimatedOrImported, isFalse);
    });

    test('Target 1: Enforces order capacity and prevents over-allocation', () {
      final valid = AttributionService.validateAttributionCapacity(80000.0, [50000.0], 30000.0);
      expect(valid.isValid, isTrue);
      expect(valid.remainingCapacity, equals(0.0));

      final invalid = AttributionService.validateAttributionCapacity(80000.0, [50000.0], 40000.0);
      expect(invalid.isValid, isFalse);
      expect(invalid.error, contains('exceeds order net recognized revenue capacity'));
    });

    test('Target 2: Missing denominators remain unknown and low exposure (<100 views) is inconclusive', () {
      // Nil views
      final nilRpm = AttributionService.calculateSafeRPM(500000.0, null, isViewsUnknown: true);
      expect(nilRpm.isUnknown, isTrue);
      expect(nilRpm.value, isNull);
      expect(nilRpm.unknownReason, equals('MISSING_DENOMINATOR_VIEWS'));

      // Zero views
      final zeroRpm = AttributionService.calculateSafeRPM(500000.0, 0);
      expect(zeroRpm.isUnknown, isTrue);
      expect(zeroRpm.value, isNull);
      expect(zeroRpm.unknownReason, equals('MISSING_DENOMINATOR_VIEWS'));

      // Low exposure < 100 views (resolves EXP-2026-02)
      final lowRpm = AttributionService.calculateSafeRPM(500000.0, 45);
      expect(lowRpm.isUnknown, isTrue);
      expect(lowRpm.value, isNull);
      expect(lowRpm.status, equals('low_exposure_inconclusive'));
      expect(lowRpm.unknownReason, equals('LOW_EXPOSURE_INCONCLUSIVE'));

      // Sufficient exposure >= 100 views
      final validRpm = AttributionService.calculateSafeRPM(500000.0, 1000);
      expect(validRpm.isUnknown, isFalse);
      expect(validRpm.value, equals('500000.000000'));
      expect(validRpm.status, equals('calculated'));

      // CTR and Conversion Rate safety
      final lowCtr = AttributionService.calculateSafeCTR(5, 45);
      expect(lowCtr.isUnknown, isTrue);
      expect(lowCtr.status, equals('low_exposure_inconclusive'));

      final validCtr = AttributionService.calculateSafeCTR(50, 1000);
      expect(validCtr.isUnknown, isFalse);
      expect(validCtr.value, equals('5.0000%'));

      final missingClicksConv = AttributionService.calculateSafeConversionRate(5, null, isClicksUnknown: true);
      expect(missingClicksConv.isUnknown, isTrue);
      expect(missingClicksConv.unknownReason, equals('MISSING_DENOMINATOR_CLICKS'));
    });

    test('Target 3: Imported proof cannot be upgraded to official and mixed confidence caps at medium', () {
      // Attempt upgrade from imported to official
      final upgradeAttempt = AttributionService.enforceSourceClassIntegrity(
        SourceClass.imported,
        SourceClass.official,
        isLiveAPIVerified: false,
      );
      expect(upgradeAttempt.sourceClass, equals(SourceClass.imported));
      expect(upgradeAttempt.error, contains('cannot be upgraded to official'));

      // Mixed official + imported confidence
      final pureOfficial = AttributionService.resolveAggregateConfidence(
        [ConfidenceBand.high, ConfidenceBand.high],
        false,
      );
      expect(pureOfficial, equals(ConfidenceBand.high));

      final mixedConfidence = AttributionService.resolveAggregateConfidence(
        [ConfidenceBand.high, ConfidenceBand.high],
        true, // Contains imported
      );
      expect(mixedConfidence, equals(ConfidenceBand.medium));
    });
  });
}

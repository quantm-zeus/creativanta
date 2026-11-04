import 'package:flutter_test/flutter_test.dart';
import 'package:creativanta_mobile/core/a11y_i18n_release.dart';

void main() {
  group('P8-08 Mobile Full-Surface A11y, i18n, Security & Release Rehearsal', () {
    test('Target 1: real restore checksum & ledger reconciliation and failing smoke slot rollback', () {
      const sha = 'e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855';

      final healthy = MobileReleaseRehearsalEvaluator.evaluateRestoreAndSmoke(
        expectedSha256: sha,
        actualSha256: sha,
        debitMicroUnits: 15000000000,
        creditMicroUnits: 15000000000,
        rpoSeconds: 0,
        rtoSeconds: 420,
        previousSlot: 'blue',
        candidateSlot: 'green',
        smokePassed: true,
      );
      expect(healthy['promoted'], isTrue);
      expect(healthy['rollbackTriggered'], isFalse);
      expect(healthy['activeSlot'], equals('green'));

      final failedSmoke = MobileReleaseRehearsalEvaluator.evaluateRestoreAndSmoke(
        expectedSha256: sha,
        actualSha256: sha,
        debitMicroUnits: 15000000000,
        creditMicroUnits: 15000000000,
        rpoSeconds: 0,
        rtoSeconds: 420,
        previousSlot: 'blue',
        candidateSlot: 'green',
        smokePassed: false,
      );
      expect(failedSmoke['promoted'], isFalse);
      expect(failedSmoke['rollbackTriggered'], isTrue);
      expect(failedSmoke['activeSlot'], equals('blue'));
    });

    test('Target 2: rejects stale provider/connector evidence and preserves LOCAL_IMPLEMENTED state', () {
      final now = DateTime.utc(2026, 11, 4, 21, 0);
      final fresh = MobileReleaseRehearsalEvaluator.evaluateProviderAndLicenseFreshness(
        now: now,
        rateVerifiedAt: now.subtract(const Duration(days: 3)),
        rateValidUntil: now.add(const Duration(days: 27)),
        connectorScopeAndReviewVerified: true,
        externalLegalSignoffComplete: false,
      );
      expect(fresh['noStaleEvidence'], isTrue);
      expect(fresh['maxEvidenceState'], equals('LOCAL_IMPLEMENTED'));
      expect(fresh['externalGateLegH001Open'], isTrue);

      final stale = MobileReleaseRehearsalEvaluator.evaluateProviderAndLicenseFreshness(
        now: now,
        rateVerifiedAt: now.subtract(const Duration(days: 45)),
        rateValidUntil: now.subtract(const Duration(hours: 1)),
        connectorScopeAndReviewVerified: false,
        externalLegalSignoffComplete: false,
      );
      expect(stale['noStaleEvidence'], isFalse);
      expect(stale['effectiveConnectorState'], equals('manual'));
    });

    test('Target 3: enforces SSRF blocking and WCAG 2.1 AA >=48dp touch targets & vi/en localization parity', () {
      expect(
        MobileReleaseRehearsalEvaluator.isAllowedOutboundHttpsUrl(
          'https://hooks.partner-commerce.vn/v1/orders',
        ),
        isTrue,
      );
      expect(
        MobileReleaseRehearsalEvaluator.isAllowedOutboundHttpsUrl(
          'http://hooks.partner-commerce.vn/v1/orders',
        ),
        isFalse,
      );
      expect(
        MobileReleaseRehearsalEvaluator.isAllowedOutboundHttpsUrl(
          'https://169.254.169.254/latest/meta-data/',
        ),
        isFalse,
      );

      // Localization key parity & VND/USD formatting
      expect(MobileI18nCatalog.hasCompleteKeyParity(), isTrue);
      expect(MobileI18nCatalog.formatCurrency(1234567, 'VND'), equals('1.234.567đ'));
      expect(MobileI18nCatalog.formatCurrency(1234567, 'USD'), equals('\$1,234,567'));

      // WCAG 2.1 AA touch target >=48x48dp, >=8dp spacing, and single-tap gesture alternative
      const validControl = MobileSemanticsContract(
        componentId: 'publish-post-btn',
        semanticLabel: 'Tạo bài đăng mới',
        widthDp: 48.0,
        heightDp: 48.0,
        adjacentSpacingDp: 8.0,
        usesGesture: true,
        hasSingleTapAlternative: true,
      );
      expect(validControl.meetsWcagMobileTouchAndSemantics, isTrue);

      const undersizedControl = MobileSemanticsContract(
        componentId: 'tiny-icon-btn',
        semanticLabel: 'Xóa',
        widthDp: 36.0,
        heightDp: 36.0,
        adjacentSpacingDp: 8.0,
      );
      expect(undersizedControl.meetsWcagMobileTouchAndSemantics, isFalse);

      const gestureWithoutTapFallback = MobileSemanticsContract(
        componentId: 'swipe-card',
        semanticLabel: 'Thẻ đơn hàng',
        widthDp: 120.0,
        heightDp: 64.0,
        adjacentSpacingDp: 12.0,
        usesGesture: true,
        hasSingleTapAlternative: false,
      );
      expect(gestureWithoutTapFallback.meetsWcagMobileTouchAndSemantics, isFalse);
    });
  });
}

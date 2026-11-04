import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:creativanta_mobile/commerce/creator_pro_models.dart';
import 'package:creativanta_mobile/generated/creativanta/commerce/v1/creator_pro.pb.dart';
import 'package:creativanta_mobile/ui/commerce/creator_pro_view.dart';

void main() {
  const wsId = 'ws-test-mobile-p6-04';

  group('P6-04 Mobile Creator Pro Acceptance Tests', () {
    // ------------------------------------------------------------------------
    // Acceptance Target 1: Canonical Deal Lifecycle
    // Sequence: negotiating -> agreed -> in_progress -> delivered -> paid -> completed
    // ------------------------------------------------------------------------
    test('Target 1: Canonical deal lifecycle sequential progression and terminal states', () {
      const sequence = [
        MobileBrandDealStatus.negotiating,
        MobileBrandDealStatus.agreed,
        MobileBrandDealStatus.inProgress,
        MobileBrandDealStatus.delivered,
        MobileBrandDealStatus.paid,
        MobileBrandDealStatus.completed,
      ];

      for (var i = 0; i < sequence.length - 1; i++) {
        final res = CanonicalDealLifecycle.validateTransition(sequence[i], sequence[i + 1]);
        expect(res.isValid, isTrue);
        expect(res.errorMessage, isNull);
      }

      // Skipping steps is rejected
      final skip = CanonicalDealLifecycle.validateTransition(
        MobileBrandDealStatus.negotiating,
        MobileBrandDealStatus.delivered,
      );
      expect(skip.isValid, isFalse);
      expect(skip.errorMessage, contains('Must follow canonical sequence'));

      // Completed is terminal
      final reopen = CanonicalDealLifecycle.validateTransition(
        MobileBrandDealStatus.completed,
        MobileBrandDealStatus.negotiating,
      );
      expect(reopen.isValid, isFalse);
      expect(reopen.errorMessage, contains('Completed deals cannot transition'));

      // Cancellation requires reason
      final noReason = CanonicalDealLifecycle.validateTransition(
        MobileBrandDealStatus.inProgress,
        MobileBrandDealStatus.cancelled,
      );
      expect(noReason.isValid, isFalse);
      expect(noReason.errorMessage, contains('Cancellation requires a non-empty reason'));

      // Paid cancellation requires financial reversal audit
      final paidNoReversal = CanonicalDealLifecycle.validateTransition(
        MobileBrandDealStatus.paid,
        MobileBrandDealStatus.cancelled,
        cancellationReason: 'Creator failed to deliver video',
        financialReversalConfirmed: false,
      );
      expect(paidNoReversal.isValid, isFalse);
      expect(paidNoReversal.errorMessage, contains('explicit financial reversal confirmation'));

      final paidWithReversal = CanonicalDealLifecycle.validateTransition(
        MobileBrandDealStatus.paid,
        MobileBrandDealStatus.cancelled,
        cancellationReason: 'Creator failed to deliver video',
        financialReversalConfirmed: true,
      );
      expect(paidWithReversal.isValid, isTrue);
    });

    // ------------------------------------------------------------------------
    // Acceptance Target 2: Phishing Cannot Be Acknowledged Away & Throttle
    // ------------------------------------------------------------------------
    test('Target 2: Threat scan flags phishing and AUP cannot bypass publishing block', () {
      final scanPhishing = evaluateLinkThreat('https://steal-login.fake-bank-phishing.com/login');
      expect(scanPhishing.scanStatus, equals('phishing'));
      expect(scanPhishing.phishingDetected, isTrue);
      expect(scanPhishing.blockedFromPublishing, isTrue);

      final scanSafe = evaluateLinkThreat('https://store.brand.vn/shop');
      expect(scanSafe.scanStatus, equals('safe'));
      expect(scanSafe.phishingDetected, isFalse);
      expect(scanSafe.blockedFromPublishing, isFalse);

      final safeItem = LinkItem()
        ..linkItemId = 'item-1'
        ..label = 'Store'
        ..url = 'https://store.brand.vn/shop'
        ..isActive = true
        ..phishingDetected = false
        ..scanStatus = LinkSecurityScanStatus.LINK_SECURITY_SCAN_STATUS_SAFE;

      final phishingItem = LinkItem()
        ..linkItemId = 'item-2'
        ..label = 'Claim Prize'
        ..url = 'https://steal-login.fake-bank-phishing.com/login'
        ..isActive = false
        ..phishingDetected = true
        ..scanStatus = LinkSecurityScanStatus.LINK_SECURITY_SCAN_STATUS_PHISHING;

      // Acceptance Target 2: Phishing cannot be acknowledged away!
      final blocked = canPublishBioPage(
        items: [safeItem, phishingItem],
        aupAcknowledged: true, // User accepts AUP checkbox
      );
      expect(blocked.allowed, isFalse);
      expect(blocked.rejectionReason, contains('confirmed phishing threat'));
      expect(blocked.rejectionReason, contains('AUP acknowledgment cannot bypass'));

      // Only clean items allowed
      final clean = canPublishBioPage(
        items: [safeItem],
        aupAcknowledged: false,
      );
      expect(clean.allowed, isTrue);

      // Verify daily throttle limit constant
      expect(maxDailyLinksPerWorkspace, equals(20));
    });

    // ------------------------------------------------------------------------
    // Acceptance Target 3: Zero-View RPM Undefined Representation
    // ------------------------------------------------------------------------
    test('Target 3: Zero-view RPM strictly undefined and drop alert triggers on >20% drop', () {
      final revenue = parseMicros('1500000.0'); // 1,500,000 VND

      // Zero-views representation strictly undefined
      final zeroView = computeRPM(views: 0, revenueMicros: revenue);
      expect(zeroView.rpmIsUndefined, isTrue);
      expect(zeroView.rpmMicros, equals(BigInt.zero));
      expect(zeroView.formatted, contains('undefined'));

      final negativeView = computeRPM(views: -5, revenueMicros: revenue);
      expect(negativeView.rpmIsUndefined, isTrue);

      // Non-zero views calculates correctly
      // 30,000 views, 1,500,000 VND revenue => RPM = (1,500,000 / 30) = 50,000 VND
      final definedRPM = computeRPM(views: 30000, revenueMicros: revenue);
      expect(definedRPM.rpmIsUndefined, isFalse);
      expect(definedRPM.rpmMicros, equals(parseMicros('50000.0')));

      // Drop alert triggers on > 20% decline when both periods defined
      final prevPeriod = definedRPM; // 50,000 VND
      final currPeriod = computeRPM(views: 30000, revenueMicros: parseMicros('35000.0')); // 35,000 VND (-30% drop)

      final alert = checkRPMDropAlert(previous: prevPeriod, current: currPeriod);
      expect(alert.alertTriggered, isTrue);
      expect(alert.changePercent, lessThan(-20.0));

      // No drop alert when undefined
      final alertUndef = checkRPMDropAlert(previous: zeroView, current: currPeriod);
      expect(alertUndef.alertTriggered, isFalse);
    });

    // ------------------------------------------------------------------------
    // Acceptance Target 4: All Six Modes Can Reach Entitled Tools
    // ------------------------------------------------------------------------
    test('Target 4: All six modes can reach entitled tools per S16 §8.2', () {
      for (final mode in MobileWorkspaceMode.values) {
        final tools = modeEntitledTools[mode]!;
        expect(tools.isNotEmpty, isTrue);
        for (final tool in tools) {
          expect(isToolEntitledForMobileMode(mode, tool), isTrue);
        }
      }

      // Creator has all 6 tools
      expect(modeEntitledTools[MobileWorkspaceMode.creator]!.length, equals(6));

      // Seller has rateCards, brandDeals, contentRoi
      expect(isToolEntitledForMobileMode(MobileWorkspaceMode.seller, MobileCreatorProTool.rateCards), isTrue);
      expect(isToolEntitledForMobileMode(MobileWorkspaceMode.seller, MobileCreatorProTool.brandDeals), isTrue);
      expect(isToolEntitledForMobileMode(MobileWorkspaceMode.seller, MobileCreatorProTool.contentRoi), isTrue);
      expect(isToolEntitledForMobileMode(MobileWorkspaceMode.seller, MobileCreatorProTool.bioPages), isFalse);

      // Agency has all 6 tools
      expect(modeEntitledTools[MobileWorkspaceMode.agency]!.length, equals(6));

      // Affiliate has bioPages, contentRoi, taxReports
      expect(isToolEntitledForMobileMode(MobileWorkspaceMode.affiliate, MobileCreatorProTool.bioPages), isTrue);
      expect(isToolEntitledForMobileMode(MobileWorkspaceMode.affiliate, MobileCreatorProTool.contentRoi), isTrue);
      expect(isToolEntitledForMobileMode(MobileWorkspaceMode.affiliate, MobileCreatorProTool.taxReports), isTrue);
      expect(isToolEntitledForMobileMode(MobileWorkspaceMode.affiliate, MobileCreatorProTool.rateCards), isFalse);

      // Brand collab has mediaKits, rateCards, brandDeals
      expect(isToolEntitledForMobileMode(MobileWorkspaceMode.brandCollab, MobileCreatorProTool.mediaKits), isTrue);
      expect(isToolEntitledForMobileMode(MobileWorkspaceMode.brandCollab, MobileCreatorProTool.rateCards), isTrue);
      expect(isToolEntitledForMobileMode(MobileWorkspaceMode.brandCollab, MobileCreatorProTool.brandDeals), isTrue);
      expect(isToolEntitledForMobileMode(MobileWorkspaceMode.brandCollab, MobileCreatorProTool.taxReports), isFalse);

      // Live operator has bioPages, contentRoi
      expect(isToolEntitledForMobileMode(MobileWorkspaceMode.liveOperator, MobileCreatorProTool.bioPages), isTrue);
      expect(isToolEntitledForMobileMode(MobileWorkspaceMode.liveOperator, MobileCreatorProTool.contentRoi), isTrue);
      expect(isToolEntitledForMobileMode(MobileWorkspaceMode.liveOperator, MobileCreatorProTool.mediaKits), isFalse);
    });

    // ------------------------------------------------------------------------
    // UI Acceptance Test: Dashboard View Renders & Operates
    // ------------------------------------------------------------------------
    testWidgets('Dashboard UI renders and updates deal status & RPM toggle', (WidgetTester tester) async {
      final safeItem = LinkItem()
        ..linkItemId = 'item-ui-1'
        ..label = 'Shop Merch'
        ..url = 'https://merch.example.com'
        ..isActive = true
        ..phishingDetected = false
        ..scanStatus = LinkSecurityScanStatus.LINK_SECURITY_SCAN_STATUS_SAFE;

      await tester.pumpWidget(MaterialApp(
        home: CreatorProDashboardView(
          workspaceId: wsId,
          initialItems: [safeItem],
        ),
      ));

      expect(find.text('Creator Pro v1'), findsOneWidget);
      expect(find.text('Active Mode: CREATOR'), findsOneWidget);
      expect(find.text('Deal Lifecycle: NEGOTIATING'), findsOneWidget);
      expect(find.text('RPM: — (undefined, 0 views)'), findsOneWidget);

      // Advance deal to Agreed
      await tester.tap(find.text('Advance to Agreed'));
      await tester.pumpAndSettle();
      expect(find.text('Deal Lifecycle: AGREED'), findsOneWidget);

      // Scroll and toggle views to 25k (defined RPM)
      final definedButton = find.text('Set 25k Views (Defined)');
      await tester.scrollUntilVisible(definedButton, 100.0);
      await tester.tap(definedButton);
      await tester.pumpAndSettle();
      expect(find.text('RPM: 20000.0 VND'), findsOneWidget);
    });
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:creativanta_mobile/core/a11y_i18n_release.dart';

void main() {
  group('P8-09 Mobile Full-Scope Acceptance & Release Decision Tests', () {
    test('Target 1: all 31 modules, 6 operator modes, 60 tasks and zero untracked scope pass with CONDITIONAL_READY_LOCAL', () {
      final verdict = MobileFullScopeAcceptanceEvaluator.evaluateFullScopeRelease(
        verifiedModuleCount: 31,
        verifiedModes: [
          'creator',
          'seller',
          'affiliate_operator',
          'live_operator',
          'agency_mcn',
          'brand_collaboration',
        ],
        verifiedTaskCount: 60,
        untrackedRemainingScopeCount: 0,
        legalSignoffGranted: false, // LEG-H-001 open
        liveProviderApproved: false, // EXT-GATE open
        stagingDrRehearsalPassed: false, // EXT-GATE open
        assertProductionLaunch: false,
      );

      expect(verdict['allowed'], isTrue);
      expect(verdict['releaseDecision'], equals('CONDITIONAL_READY_LOCAL'));
      expect(verdict['productionLaunchApproved'], isFalse);
      expect(verdict['zeroUntrackedScope'], isTrue);
      expect((verdict['openGates'] as List).length, equals(3));
    });

    test('Target 2: missing module or collapsed mode (<6) blocks release with RELEASE_BLOCKED', () {
      // 1. Missing module (30 instead of 31)
      final missingModule = MobileFullScopeAcceptanceEvaluator.evaluateFullScopeRelease(
        verifiedModuleCount: 30,
        verifiedModes: [
          'creator',
          'seller',
          'affiliate_operator',
          'live_operator',
          'agency_mcn',
          'brand_collaboration',
        ],
        verifiedTaskCount: 60,
        untrackedRemainingScopeCount: 0,
        legalSignoffGranted: false,
        liveProviderApproved: false,
        stagingDrRehearsalPassed: false,
        assertProductionLaunch: false,
      );
      expect(missingModule['allowed'], isFalse);
      expect(missingModule['releaseDecision'], equals('RELEASE_BLOCKED'));

      // 2. Collapsed mode (only 5 modes)
      final collapsedMode = MobileFullScopeAcceptanceEvaluator.evaluateFullScopeRelease(
        verifiedModuleCount: 31,
        verifiedModes: [
          'creator',
          'seller',
          'affiliate_operator',
          'live_operator',
          'agency_mcn',
        ],
        verifiedTaskCount: 60,
        untrackedRemainingScopeCount: 0,
        legalSignoffGranted: false,
        liveProviderApproved: false,
        stagingDrRehearsalPassed: false,
        assertProductionLaunch: false,
      );
      expect(collapsedMode['allowed'], isFalse);
      expect(collapsedMode['releaseDecision'], equals('RELEASE_BLOCKED'));

      // 3. Untracked remaining scope
      final untrackedScope = MobileFullScopeAcceptanceEvaluator.evaluateFullScopeRelease(
        verifiedModuleCount: 31,
        verifiedModes: [
          'creator',
          'seller',
          'affiliate_operator',
          'live_operator',
          'agency_mcn',
          'brand_collaboration',
        ],
        verifiedTaskCount: 60,
        untrackedRemainingScopeCount: 1,
        legalSignoffGranted: false,
        liveProviderApproved: false,
        stagingDrRehearsalPassed: false,
        assertProductionLaunch: false,
      );
      expect(untrackedScope['allowed'], isFalse);
      expect(untrackedScope['releaseDecision'], equals('RELEASE_BLOCKED'));
      expect(untrackedScope['zeroUntrackedScope'], isFalse);
    });

    test('Target 3: fake production launch assertion while external gates open is rejected', () {
      final fakeLaunch = MobileFullScopeAcceptanceEvaluator.evaluateFullScopeRelease(
        verifiedModuleCount: 31,
        verifiedModes: [
          'creator',
          'seller',
          'affiliate_operator',
          'live_operator',
          'agency_mcn',
          'brand_collaboration',
        ],
        verifiedTaskCount: 60,
        untrackedRemainingScopeCount: 0,
        legalSignoffGranted: false,
        liveProviderApproved: false,
        stagingDrRehearsalPassed: false,
        assertProductionLaunch: true, // asserting production launch!
      );

      expect(fakeLaunch['allowed'], isFalse);
      expect(fakeLaunch['releaseDecision'], equals('RELEASE_BLOCKED'));
      expect(fakeLaunch['productionLaunchApproved'], isFalse);
    });
  });
}

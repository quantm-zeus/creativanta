import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:creativanta_mobile/intelligence/intelligence_models.dart';
import 'package:creativanta_mobile/ui/intelligence/access_proof_widget.dart';

void main() {
  group('P2-04 Intelligence Acceptance and Access Proof (Mobile)', () {
    test('Acceptance Target 1: Live source fails closed without valid access evidence', () {
      final unverified = verifyLiveSourceAccess(
        platform: 'tiktok',
        actionKey: 'intelligence.trends.fetch_live',
        evidenceRef: '',
        grantedScopes: [],
        requiredScopes: ['video.list', 'trend.read'],
      );

      expect(unverified.status, SourceVerificationStatus.unsupported);
      expect(unverified.isVerified, false);
      expect(unverified.reconnectRequired, true);
      expect(unverified.degradedReason, contains('Thiếu quyền truy cập OAuth'));
    });

    test('Acceptance Target 1: Expired token transitions to degraded state with reconnect flag', () {
      final past = DateTime.now().toUtc().subtract(const Duration(hours: 2));
      final degraded = verifyLiveSourceAccess(
        platform: 'shopee',
        actionKey: 'competitor.shop.inspect_live',
        evidenceRef: 'shopee-oauth-vn-992',
        grantedScopes: ['shop.read'],
        requiredScopes: ['shop.read'],
        validUntil: past,
      );

      expect(degraded.status, SourceVerificationStatus.degraded);
      expect(degraded.isVerified, true);
      expect(degraded.isDegraded, true);
      expect(degraded.reconnectRequired, true);
      expect(degraded.fallbackNote, contains('bộ nhớ đệm'));
    });

    test('Acceptance Target 1: Valid evidence and scopes mark verified', () {
      final future = DateTime.now().toUtc().add(const Duration(days: 30));
      final verified = verifyLiveSourceAccess(
        platform: 'meta',
        actionKey: 'intelligence.competitors.ads_library',
        evidenceRef: 'meta-token-live-883',
        grantedScopes: ['ads_read'],
        requiredScopes: ['ads_read'],
        validUntil: future,
      );

      expect(verified.status, SourceVerificationStatus.verified);
      expect(verified.isVerified, true);
      expect(verified.isDegraded, false);
      expect(verified.reconnectRequired, false);
    });

    test('Acceptance Target 2: Downstream conversions assigned to P3 and P6 (gated in P2)', () {
      final ideaPolicy = getDownstreamGatePolicy('idea');
      expect(ideaPolicy.phaseAssigned, 'P3');
      expect(ideaPolicy.targetModule, 'M05');
      expect(ideaPolicy.isExecutableInP2, false);

      final scriptPolicy = getDownstreamGatePolicy('script');
      expect(scriptPolicy.phaseAssigned, 'P3');
      expect(scriptPolicy.targetModule, 'M06');
      expect(scriptPolicy.isExecutableInP2, false);

      final campaignPolicy = getDownstreamGatePolicy('campaign');
      expect(campaignPolicy.phaseAssigned, 'P6');
      expect(campaignPolicy.targetModule, 'M14');
      expect(campaignPolicy.isExecutableInP2, false);

      final livePlanPolicy = getDownstreamGatePolicy('live_plan');
      expect(livePlanPolicy.phaseAssigned, 'P6');
      expect(livePlanPolicy.targetModule, 'M17');
      expect(livePlanPolicy.isExecutableInP2, false);

      expect(() => getDownstreamGatePolicy('unknown_future_target'), throwsArgumentError);
    });

    test('Acceptance Target 3: Empty and degraded state summary evaluator', () {
      final emptySummary = evaluateEmptyOrDegraded([
        {'platform': 'tiktok', 'isConnected': false},
        {'platform': 'shopee', 'isConnected': false},
      ]);

      expect(emptySummary.hasEmptyState, true);
      expect(emptySummary.connectedCount, 0);
      expect(emptySummary.emptyStateCtas.length, greaterThanOrEqualTo(3));

      final degradedSummary = evaluateEmptyOrDegraded([
        {'platform': 'tiktok', 'isConnected': true, 'tokenExpired': true},
        {'platform': 'shopee', 'isConnected': true, 'tokenExpired': false},
      ]);

      expect(degradedSummary.hasEmptyState, false);
      expect(degradedSummary.connectedCount, 1);
      expect(degradedSummary.degradedCount, 1);
      expect(degradedSummary.degradedPlatforms, contains('tiktok'));
    });

    test('Formula neutralization protects against spreadsheet injection', () {
      expect(neutralizeSpreadsheetFormula('=1+2'), "'=1+2");
      expect(neutralizeSpreadsheetFormula('+CMD|foo'), "'+CMD|foo");
      expect(neutralizeSpreadsheetFormula('-EXEC|bar'), "'-EXEC|bar");
      expect(neutralizeSpreadsheetFormula('@HYPERLINK("evil")'), "'@HYPERLINK(\"evil\")");
      expect(neutralizeSpreadsheetFormula('Clean Organic Trend'), 'Clean Organic Trend');
    });

    test('Financial non-conflation guard blocks M02/M03/M04 entering M19 ledger', () {
      expect(validateFinancialNonConflation('M02', true), false);
      expect(validateFinancialNonConflation('M03', true), false);
      expect(validateFinancialNonConflation('M04', true), false);
      expect(validateFinancialNonConflation('M19', true), true);
      expect(validateFinancialNonConflation('M04', false), true);
    });

    testWidgets('Widget Test: AccessEvidenceBadge renders verified and degraded states', (tester) async {
      final verifiedResult = verifyLiveSourceAccess(
        platform: 'meta',
        actionKey: 'ads_library',
        evidenceRef: 'meta-token-live',
        grantedScopes: ['ads_read'],
        requiredScopes: ['ads_read'],
        validUntil: DateTime.now().toUtc().add(const Duration(days: 10)),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AccessEvidenceBadge(result: verifiedResult),
          ),
        ),
      );

      expect(find.text('Xác minh chính thức'), findsOneWidget);

      final degradedResult = verifyLiveSourceAccess(
        platform: 'shopee',
        actionKey: 'shop.read',
        evidenceRef: 'shopee-token',
        grantedScopes: ['shop.read'],
        requiredScopes: ['shop.read'],
        validUntil: DateTime.now().toUtc().subtract(const Duration(hours: 1)),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AccessEvidenceBadge(result: degradedResult),
          ),
        ),
      );

      expect(find.text('Suy thoái kết nối'), findsOneWidget);
    });

    testWidgets('Widget Test: DownstreamGatingNoticeCard renders phase assignment & lineage', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: DownstreamGatingNoticeCard(
              targetType: 'idea',
              opportunityId: 'opp-101',
              convertedDraftId: 'draft-idea-001',
            ),
          ),
        ),
      );

      expect(find.textContaining('Giai đoạn P3'), findsOneWidget);
      expect(find.text('P3-01'), findsOneWidget);
      expect(find.text('Gốc: opp-101'), findsOneWidget);
      expect(find.text('Nháp: draft-idea-001'), findsOneWidget);
      expect(find.text('draft_linked'), findsOneWidget);
    });
  });
}

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:creativanta_mobile/commerce/conversion_lineage_models.dart';
import 'package:creativanta_mobile/ui/commerce/conversion_lineage_sheet.dart';

void main() {
  group('P6-08 Cross-Domain Commerce Conversions Acceptance Suite', () {
    const wsId = 'ws-test-p608';
    const userId = 'usr-operator-01';

    // -------------------------------------------------------------------------
    // Target 1: Each target permission rechecked
    // -------------------------------------------------------------------------
    group('Target 1: Each target permission rechecked', () {
      test('Editor role is DENIED when converting to Brand Deal (requires brand_deal:manage)', () async {
        final opp = SourceItem(
          id: 'opp-t1-01',
          workspaceId: wsId,
          sourceType: ConversionSourceType.opportunity,
          title: 'High Growth AI Video Opportunity',
          status: 'validated',
        );

        final result = await executeCrossDomainConversion(
          workspaceId: wsId,
          userRole: 'editor',
          userId: userId,
          source: opp,
          targetType: ConversionTargetType.brandDeal,
          targetTitle: 'Exclusive AI Creator Sponsorship',
        );

        expect(result.success, isFalse);
        expect(result.errorCode, equals('ERR_TARGET_PERMISSION_DENIED'));
        expect(result.errorMessage, contains('brand_deal:manage'));
      });

      test('Editor role is ALLOWED to convert to Campaign, LiveSession, Offer, SeedingRequest', () async {
        final idea = SourceItem(
          id: 'idea-t1-02',
          workspaceId: wsId,
          sourceType: ConversionSourceType.idea,
          title: 'Viral Hook Series for Holiday Sale',
          status: 'approved',
        );

        final allowedTargets = [
          ConversionTargetType.campaign,
          ConversionTargetType.liveSession,
          ConversionTargetType.offer,
          ConversionTargetType.seedingRequest,
        ];

        for (final target in allowedTargets) {
          final result = await executeCrossDomainConversion(
            workspaceId: wsId,
            userRole: 'editor',
            userId: userId,
            source: idea,
            targetType: target,
            targetTitle: 'Target for ${target.value}',
          );

          expect(result.success, isTrue, reason: 'Failed for target ${target.value}');
          expect(result.createdTarget, isNotNull);
          expect(result.createdTarget!.targetType, equals(target));
          expect(result.lineage, isNotNull);
        }
      });

      test('Manager role possesses brand_deal:manage and CAN convert to Brand Deal', () async {
        final thread = SourceItem(
          id: 'th-t1-03',
          workspaceId: wsId,
          sourceType: ConversionSourceType.thread,
          title: 'Inbound brand partnership inquiry',
          status: 'triaged',
        );

        final result = await executeCrossDomainConversion(
          workspaceId: wsId,
          userRole: 'manager',
          userId: userId,
          source: thread,
          targetType: ConversionTargetType.brandDeal,
          targetTitle: 'Global Brand Deal Q4',
        );

        expect(result.success, isTrue);
        expect(result.createdTarget!.targetType, equals(ConversionTargetType.brandDeal));
        expect(result.lineage!.targetType, equals(ConversionTargetType.brandDeal));
      });

      test('Contributor role lacks source convert permissions and is DENIED', () async {
        final opp = SourceItem(
          id: 'opp-t1-04',
          workspaceId: wsId,
          sourceType: ConversionSourceType.opportunity,
          title: 'Opportunity by Contributor',
          status: 'draft',
        );

        final result = await executeCrossDomainConversion(
          workspaceId: wsId,
          userRole: 'contributor',
          userId: userId,
          source: opp,
          targetType: ConversionTargetType.campaign,
          targetTitle: 'Campaign Attempt',
        );

        expect(result.success, isFalse);
        expect(result.errorCode, equals('ERR_SOURCE_PERMISSION_DENIED'));
      });
    });

    // -------------------------------------------------------------------------
    // Target 2: Failed conversion is atomic
    // -------------------------------------------------------------------------
    group('Target 2: Failed conversion is atomic', () {
      test('Downstream target creation failure leaves source completely unmodified', () async {
        final opp = SourceItem(
          id: 'opp-t2-01',
          workspaceId: wsId,
          sourceType: ConversionSourceType.opportunity,
          title: 'Target Fail Opp',
          status: 'validated',
        );

        final result = await executeCrossDomainConversion(
          workspaceId: wsId,
          userRole: 'manager',
          userId: userId,
          source: opp,
          targetType: ConversionTargetType.campaign,
          targetTitle: 'Fail Target',
          targetCreator: (draft) async {
            throw Exception('Database constraint violation in campaign table');
          },
        );

        expect(result.success, isFalse);
        expect(result.errorCode, equals('ERR_TARGET_CREATION_FAILED'));
        expect(result.updatedSource, isNull);
        expect(result.createdTarget, isNull);
        expect(result.lineage, isNull);
        // Original source status remains 'validated'
        expect(opp.status, equals('validated'));
        expect(opp.isConverted, isFalse);
      });

      test('Source update failure triggers compensation rollback on target', () async {
        final opp = SourceItem(
          id: 'opp-t2-02',
          workspaceId: wsId,
          sourceType: ConversionSourceType.opportunity,
          title: 'Source Fail Opp',
          status: 'validated',
        );

        var compensatedTargetId = '';

        final result = await executeCrossDomainConversion(
          workspaceId: wsId,
          userRole: 'manager',
          userId: userId,
          source: opp,
          targetType: ConversionTargetType.liveSession,
          targetTitle: 'Compensate Live Session',
          sourceUpdater: (updated) async {
            throw Exception('Optimistic concurrency lock failed on source');
          },
          targetCompensator: (targetId) async {
            compensatedTargetId = targetId;
          },
        );

        expect(result.success, isFalse);
        expect(result.errorCode, equals('ERR_SOURCE_UPDATE_FAILED'));
        expect(result.rollbackPerformed, isTrue);
        expect(compensatedTargetId, isNotEmpty);
        // Source status was NOT modified
        expect(opp.status, equals('validated'));
      });

      test('Lineage recording failure compensates target and restores source', () async {
        final idea = SourceItem(
          id: 'idea-t2-03',
          workspaceId: wsId,
          sourceType: ConversionSourceType.idea,
          title: 'Lineage Fail Idea',
          status: 'approved',
        );

        var compensatedTargetId = '';
        var restoredSourceId = '';

        final result = await executeCrossDomainConversion(
          workspaceId: wsId,
          userRole: 'manager',
          userId: userId,
          source: idea,
          targetType: ConversionTargetType.offer,
          targetTitle: 'Compensate Offer',
          lineageRecorder: (lin) async {
            throw Exception('Lineage store disk full');
          },
          targetCompensator: (targetId) async {
            compensatedTargetId = targetId;
          },
          sourceCompensator: (original) async {
            restoredSourceId = original.id;
          },
        );

        expect(result.success, isFalse);
        expect(result.errorCode, equals('ERR_LINEAGE_RECORD_FAILED'));
        expect(result.rollbackPerformed, isTrue);
        expect(compensatedTargetId, isNotEmpty);
        expect(restoredSourceId, equals(idea.id));
      });
    });

    // -------------------------------------------------------------------------
    // Target 3: Source survives conversion
    // -------------------------------------------------------------------------
    group('Target 3: Source survives conversion', () {
      test('Originating Opportunity survives with updated converted status and pointer', () async {
        final opp = SourceItem(
          id: 'opp-t3-01',
          workspaceId: wsId,
          sourceType: ConversionSourceType.opportunity,
          title: 'Survivor Opportunity',
          status: 'validated',
        );

        final result = await executeCrossDomainConversion(
          workspaceId: wsId,
          userRole: 'manager',
          userId: userId,
          source: opp,
          targetType: ConversionTargetType.seedingRequest,
          targetTitle: 'Seeding Campaign for Top Influencer',
        );

        expect(result.success, isTrue);
        expect(result.updatedSource, isNotNull);
        // Source survives and is not null or deleted
        expect(result.updatedSource!.id, equals(opp.id));
        expect(result.updatedSource!.title, equals(opp.title));
        expect(result.updatedSource!.status, equals('converted'));
        expect(result.updatedSource!.convertedToType, equals('seeding_request'));
        expect(result.updatedSource!.convertedToId, equals(result.createdTarget!.id));
        expect(result.updatedSource!.convertedAt, isNotNull);

        // Lineage points back to source
        expect(result.lineage!.sourceId, equals(opp.id));
        expect(result.lineage!.sourceType, equals(ConversionSourceType.opportunity));
      });

      test('Originating Thread transitions to converted_to_task and survives', () async {
        final thread = SourceItem(
          id: 'th-t3-02',
          workspaceId: wsId,
          sourceType: ConversionSourceType.thread,
          title: 'Customer Wholesale Order Inquiry',
          status: 'triaged',
        );

        final result = await executeCrossDomainConversion(
          workspaceId: wsId,
          userRole: 'owner',
          userId: userId,
          source: thread,
          targetType: ConversionTargetType.offer,
          targetTitle: 'Wholesale B2B Offer',
        );

        expect(result.success, isTrue);
        expect(result.updatedSource!.status, equals('converted_to_task'));
        expect(result.updatedSource!.convertedToType, equals('offer'));
        expect(result.updatedSource!.id, equals(thread.id));
      });

      test('Already converted source cannot be converted again', () async {
        final convertedOpp = SourceItem(
          id: 'opp-t3-03',
          workspaceId: wsId,
          sourceType: ConversionSourceType.opportunity,
          title: 'Already Converted Opp',
          status: 'converted',
          convertedToId: 'tgt-prior-1',
          convertedToType: 'campaign',
        );

        final result = await executeCrossDomainConversion(
          workspaceId: wsId,
          userRole: 'owner',
          userId: userId,
          source: convertedOpp,
          targetType: ConversionTargetType.brandDeal,
          targetTitle: 'Second Conversion Attempt',
        );

        expect(result.success, isFalse);
        expect(result.errorCode, equals('ERR_SOURCE_ALREADY_CONVERTED'));
      });
    });

    // -------------------------------------------------------------------------
    // Mobile UI Widget: ConversionLineageSheet
    // -------------------------------------------------------------------------
    group('Mobile UI Widget: ConversionLineageSheet', () {
      testWidgets('Editor sees denial warning for Brand Deal and submit is disabled', (tester) async {
        final opp = SourceItem(
          id: 'opp-ui-01',
          workspaceId: wsId,
          sourceType: ConversionSourceType.opportunity,
          title: 'Viral Opportunity for UI test',
          status: 'validated',
        );

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ConversionLineageSheet(
                workspaceId: wsId,
                userRole: 'editor',
                userId: userId,
                source: opp,
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Default target is Campaign: Editor is allowed
        expect(find.byKey(const Key('permission-granted-info')), findsOneWidget);
        expect(find.byKey(const Key('permission-denial-warning')), findsNothing);

        // Switch dropdown to Brand Deal
        await tester.tap(find.byKey(const Key('conversion-target-selector')));
        await tester.pumpAndSettle();

        await tester.tap(find.text('Hợp tác thương hiệu (Brand Deal - Manager+)').last);
        await tester.pumpAndSettle();

        // Permission denial warning should now be visible
        expect(find.byKey(const Key('permission-denial-warning')), findsOneWidget);
        expect(find.textContaining('brand_deal:manage'), findsOneWidget);

        // Submit button should be disabled
        final submitButton = tester.widget<ElevatedButton>(
          find.byKey(const Key('submit-conversion-button')),
        );
        expect(submitButton.onPressed, isNull);
      });

      testWidgets('Manager sees permission granted for Brand Deal and can submit', (tester) async {
        final opp = SourceItem(
          id: 'opp-ui-02',
          workspaceId: wsId,
          sourceType: ConversionSourceType.opportunity,
          title: 'Manager Deal Test',
          status: 'validated',
        );

        ConversionExecutionResult? convertedResult;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ConversionLineageSheet(
                workspaceId: wsId,
                userRole: 'manager',
                userId: userId,
                source: opp,
                onConverted: (res) {
                  convertedResult = res;
                },
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Select Brand Deal
        await tester.tap(find.byKey(const Key('conversion-target-selector')));
        await tester.pumpAndSettle();

        await tester.tap(find.text('Hợp tác thương hiệu (Brand Deal - Manager+)').last);
        await tester.pumpAndSettle();

        // Permission granted info visible
        expect(find.byKey(const Key('permission-granted-info')), findsOneWidget);
        expect(find.byKey(const Key('permission-denial-warning')), findsNothing);

        // Submit button is active
        final submitButton = tester.widget<ElevatedButton>(
          find.byKey(const Key('submit-conversion-button')),
        );
        expect(submitButton.onPressed, isNotNull);

        // Tap submit
        await tester.tap(find.byKey(const Key('submit-conversion-button')));
        await tester.pumpAndSettle();

        expect(convertedResult, isNotNull);
        expect(convertedResult!.success, isTrue);
        expect(convertedResult!.createdTarget!.targetType, equals(ConversionTargetType.brandDeal));
      });
    });
  });
}

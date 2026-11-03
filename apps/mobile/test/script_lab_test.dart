import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:creativanta_mobile/content/script_models.dart';
import 'package:creativanta_mobile/generated/creativanta/content/v1/script.pbenum.dart';
import 'package:creativanta_mobile/ui/content/mobile_script_review_view.dart';

void main() {
  group('M06 Script Lab Business Rules & Acceptance Targets', () {
    // -------------------------------------------------------------------------
    // Acceptance Target 1: Stale approval fails (EC-M06-003)
    // -------------------------------------------------------------------------
    group('Acceptance Target 1: Stale approval fails (EC-M06-003)', () {
      test('isReviewStale identifies version mismatches', () {
        expect(isReviewStale(2, 1), isTrue);
        expect(isReviewStale(3, 2), isTrue);
        expect(isReviewStale(2, 2), isFalse);
        expect(isReviewStale(1, 1), isFalse);
      });

      testWidgets('MobileScriptReviewView displays stale banner and disables actions when stale', (tester) async {
        final script = ScriptItem(
          scriptId: 'scr-1',
          workspaceId: 'ws-1',
          title: 'Review Stale Test Script',
          formatType: '9:16 vertical short',
          versionIndex: 2, // Script is at v2
          createdBy: 'user-editor',
          scenes: const [
            SceneItem(
              sceneId: 'sc-1',
              scriptId: 'scr-1',
              workspaceId: 'ws-1',
              sceneIndex: 0,
              description: 'Hook',
              content: 'Check out this routine.',
              durationSeconds: 5,
            ),
          ],
        );

        var approved = false;

        await tester.pumpWidget(
          MaterialApp(
            home: MobileScriptReviewView(
              script: script,
              reviewerExpectedVersion: 1, // Reviewer expected v1 (STALE)
              onApprove: () => approved = true,
              onReject: (_) {},
            ),
          ),
        );

        // Stale banner must be shown
        expect(find.byKey(const Key('stale-review-banner')), findsOneWidget);

        // Action buttons must be disabled
        final approveButton = tester.widget<ElevatedButton>(find.byKey(const Key('approve-script-button')));
        expect(approveButton.onPressed, isNull);

        final rejectButton = tester.widget<OutlinedButton>(find.byKey(const Key('reject-script-button')));
        expect(rejectButton.onPressed, isNull);

        expect(approved, isFalse);
      });
    });

    // -------------------------------------------------------------------------
    // Acceptance Target 2: Rejection reason validated (RULE-M06-002, EC-M06-002)
    // -------------------------------------------------------------------------
    group('Acceptance Target 2: Rejection reason validated (RULE-M06-002, EC-M06-002)', () {
      test('validateRejectionReason requires at least 10 characters', () {
        final invalidShort = validateRejectionReason('too slow');
        expect(invalidShort.isValid, isFalse);
        expect(invalidShort.characterCount, 8);
        expect(invalidShort.errorMessage, contains('ít nhất 10 ký tự'));

        final validLong = validateRejectionReason('Hook is too slow; cut 3 seconds.');
        expect(validLong.isValid, isTrue);
        expect(validLong.characterCount, greaterThanOrEqualTo(10));
        expect(validLong.errorMessage, isNull);
      });

      testWidgets('Rejection dialog enforces >= 10 characters before allowing confirm', (tester) async {
        final script = ScriptItem(
          scriptId: 'scr-1',
          workspaceId: 'ws-1',
          title: 'Rejection Modal Test',
          formatType: '9:16 vertical short',
          versionIndex: 1,
          createdBy: 'user-editor',
          scenes: const [
            SceneItem(
              sceneId: 'sc-1',
              scriptId: 'scr-1',
              workspaceId: 'ws-1',
              sceneIndex: 0,
              description: 'Hook',
              content: 'Valid content here.',
              durationSeconds: 5,
            ),
          ],
        );

        String? rejectedReason;

        await tester.pumpWidget(
          MaterialApp(
            home: MobileScriptReviewView(
              script: script,
              reviewerExpectedVersion: 1,
              onApprove: () {},
              onReject: (reason) => rejectedReason = reason,
            ),
          ),
        );

        // Open rejection dialog
        await tester.tap(find.byKey(const Key('reject-script-button')));
        await tester.pumpAndSettle();

        expect(find.byKey(const Key('mobile-rejection-dialog')), findsOneWidget);

        // Type short reason (< 10 chars)
        await tester.enterText(find.byKey(const Key('rejection-reason-input')), 'bad');
        await tester.pumpAndSettle();

        // Confirm button should be disabled
        final confirmBtnDisabled = tester.widget<ElevatedButton>(find.byKey(const Key('confirm-rejection-btn')));
        expect(confirmBtnDisabled.onPressed, isNull);

        // Type valid reason (>= 10 chars)
        const validFeedback = 'Pacing in scene 1 is too slow. Shorten by 3s.';
        await tester.enterText(find.byKey(const Key('rejection-reason-input')), validFeedback);
        await tester.pumpAndSettle();

        // Confirm button should be enabled
        final confirmBtnEnabled = tester.widget<ElevatedButton>(find.byKey(const Key('confirm-rejection-btn')));
        expect(confirmBtnEnabled.onPressed, isNotNull);

        // Tap confirm
        await tester.tap(find.byKey(const Key('confirm-rejection-btn')));
        await tester.pumpAndSettle();

        expect(rejectedReason, equals(validFeedback));
      });
    });

    // -------------------------------------------------------------------------
    // Acceptance Target 3: Ready-for-production requires approval and complete brief
    // (RULE-M06-005, RULE-M06-006, AC-2)
    // -------------------------------------------------------------------------
    group('Acceptance Target 3: Ready for production requires approval and complete brief', () {
      const completeBrief = AssetBriefItem(
        assetBriefId: 'brief-1',
        workspaceId: 'ws-1',
        scriptId: 'scr-prod-1',
        outputType: 'video',
        targetFormat: '9:16 vertical short',
        targetDurationSeconds: 45,
        continuityRequirementsJson: '{"lighting": "natural ring light", "talent": "female 20s"}',
      );

      test('isAssetBriefComplete validates all mandatory fields', () {
        expect(isAssetBriefComplete(completeBrief), isTrue);
        expect(isAssetBriefComplete(null), isFalse);
        expect(
          isAssetBriefComplete(const AssetBriefItem(
            assetBriefId: 'b-inc',
            workspaceId: 'ws-1',
            scriptId: 'scr-1',
            outputType: '',
            targetFormat: '9:16',
            targetDurationSeconds: 30,
            continuityRequirementsJson: '{"setting": "studio"}',
          )),
          isFalse,
        );
        expect(
          isAssetBriefComplete(const AssetBriefItem(
            assetBriefId: 'b-inc',
            workspaceId: 'ws-1',
            scriptId: 'scr-1',
            outputType: 'video',
            targetFormat: '9:16',
            targetDurationSeconds: 0,
            continuityRequirementsJson: '{"setting": "studio"}',
          )),
          isFalse,
        );
        expect(
          isAssetBriefComplete(const AssetBriefItem(
            assetBriefId: 'b-inc',
            workspaceId: 'ws-1',
            scriptId: 'scr-1',
            outputType: 'video',
            targetFormat: '9:16',
            targetDurationSeconds: 30,
            continuityRequirementsJson: '{}', // empty json
          )),
          isFalse,
        );
      });

      test('denies ready for production if script is unapproved', () {
        final unapprovedScript = ScriptItem(
          scriptId: 'scr-prod-1',
          workspaceId: 'ws-1',
          title: 'Unapproved Script',
          formatType: '9:16',
          approvalState: ScriptApprovalState.SCRIPT_APPROVAL_STATE_PENDING_APPROVAL,
          createdBy: 'user-editor',
        );

        final result = isReadyForProductionEligible(unapprovedScript, completeBrief);
        expect(result.isEligible, isFalse);
        expect(result.reasons, anyElement(contains('chưa được người quản lý duyệt')));
      });

      test('denies ready for production if asset brief is missing or incomplete', () {
        final approvedScript = ScriptItem(
          scriptId: 'scr-prod-1',
          workspaceId: 'ws-1',
          title: 'Approved Script',
          formatType: '9:16',
          approvalState: ScriptApprovalState.SCRIPT_APPROVAL_STATE_APPROVED,
          lifecycleState: ScriptLifecycleState.SCRIPT_LIFECYCLE_STATE_APPROVED,
          createdBy: 'user-editor',
        );

        final resultMissing = isReadyForProductionEligible(approvedScript, null);
        expect(resultMissing.isEligible, isFalse);
        expect(resultMissing.reasons, anyElement(contains('Chưa tạo Bản tóm tắt')));

        const incompleteBrief = AssetBriefItem(
          assetBriefId: 'brief-inc',
          workspaceId: 'ws-1',
          scriptId: 'scr-prod-1',
          outputType: 'video',
          targetFormat: '9:16',
          targetDurationSeconds: 0, // missing duration
          continuityRequirementsJson: '{}',
        );
        final resultIncomplete = isReadyForProductionEligible(approvedScript, incompleteBrief);
        expect(resultIncomplete.isEligible, isFalse);
        expect(resultIncomplete.reasons, anyElement(contains('chưa hoàn chỉnh')));
      });

      test('allows ready for production when approved and complete brief linked', () {
        final approvedScript = ScriptItem(
          scriptId: 'scr-prod-1',
          workspaceId: 'ws-1',
          title: 'Approved Script',
          formatType: '9:16',
          approvalState: ScriptApprovalState.SCRIPT_APPROVAL_STATE_APPROVED,
          lifecycleState: ScriptLifecycleState.SCRIPT_LIFECYCLE_STATE_APPROVED,
          createdBy: 'user-editor',
        );

        final result = isReadyForProductionEligible(approvedScript, completeBrief);
        expect(result.isEligible, isTrue);
        expect(result.reasons, isEmpty);
      });
    });

    // -------------------------------------------------------------------------
    // Error Condition EC-M06-001: Empty scenes block submission
    // -------------------------------------------------------------------------
    group('EC-M06-001: Empty scenes block submission', () {
      test('validateScenesForSubmission blocks empty scene list', () {
        final result = validateScenesForSubmission([]);
        expect(result.isValid, isFalse);
        expect(result.errorMessage, contains('ít nhất 1 phân cảnh'));
      });

      test('validateScenesForSubmission blocks scene with empty content', () {
        final scenes = [
          const SceneItem(
            sceneId: 'sc-1',
            scriptId: 'scr-1',
            workspaceId: 'ws-1',
            sceneIndex: 0,
            description: 'Opening',
            content: '    ', // whitespace only
            durationSeconds: 5,
          ),
        ];
        final result = validateScenesForSubmission(scenes);
        expect(result.isValid, isFalse);
        expect(result.errorMessage, contains('Phân cảnh #1 chưa có nội dung'));
      });

      test('validateScenesForSubmission passes when all scenes have content', () {
        final scenes = [
          const SceneItem(
            sceneId: 'sc-1',
            scriptId: 'scr-1',
            workspaceId: 'ws-1',
            sceneIndex: 0,
            description: 'Opening',
            content: 'Real script dialogue content here.',
            durationSeconds: 10,
          ),
        ];
        final result = validateScenesForSubmission(scenes);
        expect(result.isValid, isTrue);
        expect(result.errorMessage, isNull);
      });
    });

    // -------------------------------------------------------------------------
    // Metric Calculations
    // -------------------------------------------------------------------------
    group('Duration & Word Count Metrics', () {
      final scenes = [
        const SceneItem(
          sceneId: 'sc-1',
          scriptId: 'scr-1',
          workspaceId: 'ws-1',
          sceneIndex: 0,
          description: 'C1',
          content: 'One two three four',
          durationSeconds: 8,
        ),
        const SceneItem(
          sceneId: 'sc-2',
          scriptId: 'scr-1',
          workspaceId: 'ws-1',
          sceneIndex: 1,
          description: 'C2',
          content: 'Five six seven',
          durationSeconds: 12,
        ),
      ];

      test('computes total duration', () {
        expect(calculateTotalDuration(scenes), 20);
      });

      test('computes total word count', () {
        expect(calculateWordCount(scenes), 7);
      });
    });
  });
}

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:creativanta_mobile/content/content_handoff_models.dart';
import 'package:creativanta_mobile/content/script_models.dart';
import 'package:creativanta_mobile/generated/creativanta/content/v1/script.pbenum.dart';
import 'package:creativanta_mobile/ui/content/mobile_script_editor_view.dart';
import 'package:creativanta_mobile/ui/content/mobile_script_review_view.dart';
import 'package:creativanta_mobile/ui/content/source_chain_lineage_widget.dart';

void main() {
  group('P3-05 Content Handoffs & Mobile Review Acceptance Tests', () {
    // -------------------------------------------------------------------------
    // Target 1: Source chain reaches approved brief
    // -------------------------------------------------------------------------
    group('Target 1: Source chain reaches approved brief', () {
      test('Complete source chain reaches approved brief and validates ready-for-production', () {
        final lineage = SourceChainLineage(
          workspaceId: 'ws-acc-01',
          scriptId: 'scr-acc-01',
          trend: const SourceChainNode(
            stage: ContentPipelineStage.trend,
            id: 'trd-101',
            title: 'TikTok AI Workflow Trend',
            status: 'active',
            score: 92.5,
          ),
          opportunity: const SourceChainNode(
            stage: ContentPipelineStage.opportunity,
            id: 'opp-202',
            title: 'AI Video Productivity for Creators',
            status: 'validated',
            score: 88.0,
          ),
          idea: const SourceChainNode(
            stage: ContentPipelineStage.idea,
            id: 'idea-303',
            title: '5 Steps to Automate Short-form Video',
            status: 'approved',
            score: 90.0,
          ),
          script: ScriptItem(
            scriptId: 'scr-acc-01',
            workspaceId: 'ws-acc-01',
            ideaId: 'idea-303',
            sourceIdeaTitle: '5 Steps to Automate Short-form Video',
            title: '5 Steps to Automate Short-form Video',
            formatType: '9:16 vertical short',
            durationTargetSeconds: 60,
            lifecycleState: ScriptLifecycleState.SCRIPT_LIFECYCLE_STATE_APPROVED,
            approvalState: ScriptApprovalState.SCRIPT_APPROVAL_STATE_APPROVED,
            createdBy: 'usr-author-1',
            versionIndex: 2,
            scenes: const [
              SceneItem(
                sceneId: 'sc-1',
                scriptId: 'scr-acc-01',
                workspaceId: 'ws-acc-01',
                sceneIndex: 0,
                description: 'Hook',
                content: 'Bạn có biết cách tự động hóa video ngắn?',
                durationSeconds: 5,
              ),
            ],
          ),
          assetBrief: const AssetBriefItem(
            assetBriefId: 'ab-404',
            workspaceId: 'ws-acc-01',
            scriptId: 'scr-acc-01',
            outputType: 'video',
            targetFormat: '9:16 vertical video',
            targetDurationSeconds: 60,
            targetPlatforms: ['tiktok', 'reels'],
            continuityRequirementsJson: '{"character_ids":["char-1"],"visual_tone":"high-energy"}',
            status: AssetBriefStatus.ASSET_BRIEF_STATUS_READY,
          ),
        );

        // Verify full 5 nodes in chain
        expect(lineage.nodes.length, 5);
        expect(lineage.nodes[0].stage, ContentPipelineStage.trend);
        expect(lineage.nodes[1].stage, ContentPipelineStage.opportunity);
        expect(lineage.nodes[2].stage, ContentPipelineStage.idea);
        expect(lineage.nodes[3].stage, ContentPipelineStage.script);
        expect(lineage.nodes[4].stage, ContentPipelineStage.assetBrief);

        // Reaches approved brief must be true
        expect(lineage.reachesApprovedBrief, isTrue);

        // Evaluates ready for production
        final readiness = lineage.evaluateProductionReadiness();
        expect(readiness.isEligible, isTrue);
        expect(readiness.reasons, isEmpty);
      });

      test('Lineage blocks ready-for-production if script is pending approval or brief is incomplete', () {
        // Case A: Pending approval
        final pendingScript = ScriptItem(
          scriptId: 'scr-pending',
          workspaceId: 'ws-acc-01',
          title: 'Pending Script',
          formatType: '9:16',
          lifecycleState: ScriptLifecycleState.SCRIPT_LIFECYCLE_STATE_IN_REVIEW,
          approvalState: ScriptApprovalState.SCRIPT_APPROVAL_STATE_PENDING_APPROVAL,
          createdBy: 'usr-author-1',
          scenes: const [
            SceneItem(
              sceneId: 'sc-1',
              scriptId: 'scr-pending',
              workspaceId: 'ws-acc-01',
              sceneIndex: 0,
              description: 'Hook',
              content: 'Pending hook',
              durationSeconds: 5,
            ),
          ],
        );

        final completeBrief = const AssetBriefItem(
          assetBriefId: 'ab-505',
          workspaceId: 'ws-acc-01',
          scriptId: 'scr-pending',
          outputType: 'video',
          targetFormat: '9:16',
          targetDurationSeconds: 60,
          continuityRequirementsJson: '{"lighting":"studio"}',
        );

        final pendingLineage = SourceChainLineage(
          workspaceId: 'ws-acc-01',
          scriptId: 'scr-pending',
          script: pendingScript,
          assetBrief: completeBrief,
        );

        expect(pendingLineage.reachesApprovedBrief, isFalse);
        final pendingReadiness = pendingLineage.evaluateProductionReadiness();
        expect(pendingReadiness.isEligible, isFalse);
        expect(pendingReadiness.reasons.first, contains('chưa được người quản lý duyệt'));

        // Case B: Approved script but incomplete brief (missing continuity)
        final approvedScript = ScriptItem(
          scriptId: 'scr-approved',
          workspaceId: 'ws-acc-01',
          title: 'Approved Script',
          formatType: '9:16',
          lifecycleState: ScriptLifecycleState.SCRIPT_LIFECYCLE_STATE_APPROVED,
          approvalState: ScriptApprovalState.SCRIPT_APPROVAL_STATE_APPROVED,
          createdBy: 'usr-author-1',
          scenes: const [
            SceneItem(
              sceneId: 'sc-1',
              scriptId: 'scr-approved',
              workspaceId: 'ws-acc-01',
              sceneIndex: 0,
              description: 'Hook',
              content: 'Approved hook',
              durationSeconds: 5,
            ),
          ],
        );

        final incompleteBrief = const AssetBriefItem(
          assetBriefId: 'ab-empty',
          workspaceId: 'ws-acc-01',
          scriptId: 'scr-approved',
          outputType: 'video',
          targetFormat: '9:16',
          targetDurationSeconds: 60,
          continuityRequirementsJson: '{}', // empty continuity violates RULE-M06-005
        );

        final incompleteLineage = SourceChainLineage(
          workspaceId: 'ws-acc-01',
          scriptId: 'scr-approved',
          script: approvedScript,
          assetBrief: incompleteBrief,
        );

        expect(incompleteLineage.reachesApprovedBrief, isFalse);
        final incompleteReadiness = incompleteLineage.evaluateProductionReadiness();
        expect(incompleteReadiness.isEligible, isFalse);
        expect(incompleteReadiness.reasons.first, contains('chưa hoàn chỉnh'));
      });

      testWidgets('SourceChainLineageWidget renders nodes, badges and blockers properly', (tester) async {
        final lineage = SourceChainLineage(
          workspaceId: 'ws-acc-01',
          scriptId: 'scr-acc-01',
          trend: const SourceChainNode(
            stage: ContentPipelineStage.trend,
            id: 'trd-101',
            title: 'TikTok AI Workflow Trend',
            status: 'active',
          ),
          script: ScriptItem(
            scriptId: 'scr-acc-01',
            workspaceId: 'ws-acc-01',
            title: '5 Steps to Automate',
            formatType: '9:16 vertical short',
            approvalState: ScriptApprovalState.SCRIPT_APPROVAL_STATE_APPROVED,
            createdBy: 'usr-author-1',
            scenes: const [
              SceneItem(
                sceneId: 'sc-1',
                scriptId: 'scr-acc-01',
                workspaceId: 'ws-acc-01',
                sceneIndex: 0,
                description: 'Hook',
                content: 'Test content',
                durationSeconds: 5,
              ),
            ],
          ),
          assetBrief: const AssetBriefItem(
            assetBriefId: 'ab-404',
            workspaceId: 'ws-acc-01',
            scriptId: 'scr-acc-01',
            outputType: 'video',
            targetFormat: '9:16',
            targetDurationSeconds: 60,
            continuityRequirementsJson: '{"mood":"energetic"}',
          ),
        );

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: SourceChainLineageWidget(lineage: lineage),
            ),
          ),
        );

        expect(find.byKey(const Key('source-chain-lineage-card')), findsOneWidget);
        expect(find.byKey(const Key('production-ready-badge')), findsOneWidget);
        expect(find.text('Chuỗi nguồn & Xuất xứ (Source Chain)'), findsOneWidget);
        expect(find.text('TikTok AI Workflow Trend'), findsOneWidget);
        expect(find.text('5 Steps to Automate'), findsOneWidget);
      });
    });

    // -------------------------------------------------------------------------
    // Target 2: Concurrent edits preserve data & Stale review conflict
    // -------------------------------------------------------------------------
    group('Target 2: Concurrent edits preserve data', () {
      test('ConcurrentReviewStatus evaluates version conflicts accurately', () {
        final conflict = ConcurrentReviewStatus.evaluate(
          scriptId: 'scr-001',
          currentVersion: 3,
          reviewerExpectedVersion: 2,
        );

        expect(conflict.hasConflict, isTrue);
        expect(conflict.conflictMessage, contains('Xung đột phiên bản'));
        expect(conflict.conflictMessage, contains('EC-M06-003'));

        final ok = ConcurrentReviewStatus.evaluate(
          scriptId: 'scr-001',
          currentVersion: 2,
          reviewerExpectedVersion: 2,
        );
        expect(ok.hasConflict, isFalse);
        expect(ok.conflictMessage, isNull);
      });

      testWidgets('MobileScriptReviewView displays stale warning and blocks approval on conflict', (tester) async {
        final script = ScriptItem(
          scriptId: 'scr-001',
          workspaceId: 'ws-001',
          title: 'Concurrent Review Test',
          formatType: '9:16',
          versionIndex: 3, // Script has advanced to v3
          createdBy: 'author-1',
          approvalState: ScriptApprovalState.SCRIPT_APPROVAL_STATE_PENDING_APPROVAL,
          scenes: const [
            SceneItem(
              sceneId: 'sc-1',
              scriptId: 'scr-001',
              workspaceId: 'ws-001',
              sceneIndex: 0,
              description: 'Hook',
              content: 'Author updated content for v3',
              durationSeconds: 5,
            ),
          ],
        );

        var approveInvoked = false;

        await tester.pumpWidget(
          MaterialApp(
            home: MobileScriptReviewView(
              script: script,
              reviewerExpectedVersion: 2, // Reviewer holds stale v2
              onApprove: () => approveInvoked = true,
              onReject: (_) {},
            ),
          ),
        );

        // Stale banner must appear
        expect(find.byKey(const Key('stale-review-banner')), findsOneWidget);

        // Approval button must be disabled
        final approveBtn = tester.widget<ElevatedButton>(find.byKey(const Key('approve-script-button')));
        expect(approveBtn.onPressed, isNull);

        // Reject button must also be disabled
        final rejectBtn = tester.widget<OutlinedButton>(find.byKey(const Key('reject-script-button')));
        expect(rejectBtn.onPressed, isNull);

        expect(approveInvoked, isFalse);
      });

      testWidgets('MobileScriptEditorView displays conflict banner and disables save when stale', (tester) async {
        final script = ScriptItem(
          scriptId: 'scr-001',
          workspaceId: 'ws-001',
          title: 'Author Editing Script',
          formatType: '9:16',
          versionIndex: 3, // Current version is 3
          createdBy: 'author-1',
          scenes: const [
            SceneItem(
              sceneId: 'sc-1',
              scriptId: 'scr-001',
              workspaceId: 'ws-001',
              sceneIndex: 0,
              description: 'Hook',
              content: 'Original scene text',
              durationSeconds: 5,
            ),
          ],
        );

        await tester.pumpWidget(
          MaterialApp(
            home: MobileScriptEditorView(
              script: script,
              initialVersion: 2, // Editor loaded v2 but database is at v3
              onSaveScript: (_) async {},
              onSubmitForReview: () async {},
            ),
          ),
        );

        expect(find.byKey(const Key('editor-concurrency-conflict-banner')), findsOneWidget);
        final saveBtn = tester.widget<IconButton>(find.byKey(const Key('save-script-icon-btn')));
        expect(saveBtn.onPressed, isNull);
      });
    });

    // -------------------------------------------------------------------------
    // Target 3: No publish side effects from creative assistant
    // -------------------------------------------------------------------------
    group('Target 3: No publish side effects from creative assistant', () {
      test('CreativeAssistantPublishCheck detects publish intents across English and Vietnamese', () {
        final blockedPrompts = [
          'Publish this video to TikTok immediately',
          'Đăng bài này lên TikTok ngay lập tức',
          'Đăng video lên fanpage Facebook lúc 18h',
          'Schedule post for tomorrow at 9 AM',
          'Lên lịch phát video này vào thứ Hai',
          'Auto-post to Instagram reels',
          'Broadcast now',
        ];

        for (final p in blockedPrompts) {
          final check = CreativeAssistantPublishCheck.inspect(p);
          expect(check.hasPublishIntent, isTrue, reason: 'Prompt "$p" should be flagged');
          expect(check.blockedReason, contains('Trợ lý sáng tạo chỉ hỗ trợ soạn thảo'));
          expect(check.blockedReason, contains('Phase P5'));
        }

        final safePrompts = [
          'Viết lại phân cảnh hook ngắn gọn hơn trong 3 giây',
          'Thêm lời thoại kịch tính cho cảnh 2',
          'Tạo một CTA kêu gọi tương tác comment',
          'Make the narrative rhythm punchier',
        ];

        for (final p in safePrompts) {
          final check = CreativeAssistantPublishCheck.inspect(p);
          expect(check.hasPublishIntent, isFalse, reason: 'Prompt "$p" should be allowed');
          expect(check.blockedReason, isNull);
        }
      });

      testWidgets('MobileScriptEditorView creative assistant blocks publish command in sheet', (tester) async {
        final script = ScriptItem(
          scriptId: 'scr-001',
          workspaceId: 'ws-001',
          title: 'Editor Script',
          formatType: '9:16',
          createdBy: 'author-1',
          scenes: const [
            SceneItem(
              sceneId: 'sc-1',
              scriptId: 'scr-001',
              workspaceId: 'ws-001',
              sceneIndex: 0,
              description: 'Hook',
              content: 'Scene content',
              durationSeconds: 5,
            ),
          ],
        );

        await tester.pumpWidget(
          MaterialApp(
            home: MobileScriptEditorView(
              script: script,
              onSaveScript: (_) async {},
              onSubmitForReview: () async {},
            ),
          ),
        );

        // Tap creative assistant icon
        await tester.tap(find.byKey(const Key('assistant-icon-btn')));
        await tester.pumpAndSettle();

        // Enter publish prompt
        await tester.enterText(
          find.byKey(const Key('assistant-prompt-input')),
          'Đăng video này lên TikTok ngay lập tức',
        );
        await tester.tap(find.byKey(const Key('assistant-submit-btn')));
        await tester.pumpAndSettle();

        // Blocked banner must be displayed
        expect(find.byKey(const Key('assistant-blocked-banner')), findsOneWidget);
        expect(find.textContaining('Trợ lý sáng tạo chỉ hỗ trợ soạn thảo'), findsOneWidget);
      });
    });

    // -------------------------------------------------------------------------
    // M011 Mobile Script Editor Full Lifecycle & Readthrough Timer
    // -------------------------------------------------------------------------
    group('M011 Mobile Script Editor Lifecycle & Readthrough Timer', () {
      testWidgets('Timer starts, updates display, and resets properly', (tester) async {
        final script = ScriptItem(
          scriptId: 'scr-timer',
          workspaceId: 'ws-001',
          title: 'Timer Script',
          formatType: '9:16',
          durationTargetSeconds: 30,
          createdBy: 'author-1',
          scenes: const [
            SceneItem(
              sceneId: 'sc-1',
              scriptId: 'scr-timer',
              workspaceId: 'ws-001',
              sceneIndex: 0,
              description: 'Hook',
              content: 'Test content for timer',
              durationSeconds: 5,
            ),
          ],
        );

        await tester.pumpWidget(
          MaterialApp(
            home: MobileScriptEditorView(
              script: script,
              onSaveScript: (_) async {},
              onSubmitForReview: () async {},
            ),
          ),
        );

        expect(find.byKey(const Key('readthrough-timer-card')), findsOneWidget);
        expect(find.text('0 s / 30s target'), findsOneWidget);

        // Tap start timer
        await tester.tap(find.byKey(const Key('timer-toggle-btn')));
        await tester.pump(const Duration(seconds: 2));

        expect(find.text('2 s / 30s target'), findsOneWidget);

        // Reset timer
        await tester.tap(find.byKey(const Key('timer-reset-btn')));
        await tester.pump();

        expect(find.text('0 s / 30s target'), findsOneWidget);
      });

      testWidgets('Saving script calls onSaveScript and bumps versionIndex', (tester) async {
        ScriptItem? savedScript;

        final script = ScriptItem(
          scriptId: 'scr-save',
          workspaceId: 'ws-001',
          title: 'Save Test Script',
          formatType: '9:16',
          versionIndex: 1,
          createdBy: 'author-1',
          scenes: const [
            SceneItem(
              sceneId: 'sc-1',
              scriptId: 'scr-save',
              workspaceId: 'ws-001',
              sceneIndex: 0,
              description: 'Hook',
              content: 'Initial scene text',
              durationSeconds: 5,
            ),
          ],
        );

        await tester.pumpWidget(
          MaterialApp(
            home: MobileScriptEditorView(
              script: script,
              onSaveScript: (updated) async {
                savedScript = updated;
              },
              onSubmitForReview: () async {},
            ),
          ),
        );

        // Edit scene text
        await tester.enterText(
          find.byKey(const Key('scene-content-input-0')),
          'Edited scene text with more detail',
        );
        await tester.pump();

        // Tap save button
        await tester.tap(find.byKey(const Key('save-script-icon-btn')));
        await tester.pumpAndSettle();

        expect(savedScript, isNotNull);
        expect(savedScript!.versionIndex, 2);
        expect(savedScript!.scenes.first.content, 'Edited scene text with more detail');
        expect(find.text('💾 Đã lưu phiên bản mới'), findsOneWidget);
      });

      testWidgets('Goto production button is disabled if ready-for-production prerequisites not met', (tester) async {
        final draftScript = ScriptItem(
          scriptId: 'scr-prod-test',
          workspaceId: 'ws-001',
          title: 'Draft Script',
          formatType: '9:16',
          lifecycleState: ScriptLifecycleState.SCRIPT_LIFECYCLE_STATE_DRAFT,
          approvalState: ScriptApprovalState.SCRIPT_APPROVAL_STATE_UNSPECIFIED,
          createdBy: 'author-1',
          scenes: const [
            SceneItem(
              sceneId: 'sc-1',
              scriptId: 'scr-prod-test',
              workspaceId: 'ws-001',
              sceneIndex: 0,
              description: 'Hook',
              content: 'Draft content',
              durationSeconds: 5,
            ),
          ],
        );

        var productionNavigated = false;

        await tester.pumpWidget(
          MaterialApp(
            home: MobileScriptEditorView(
              script: draftScript,
              onSaveScript: (_) async {},
              onSubmitForReview: () async {},
              onNavigateToProduction: () => productionNavigated = true,
            ),
          ),
        );

        final prodBtn = tester.widget<ElevatedButton>(find.byKey(const Key('goto-production-btn')));
        expect(prodBtn.onPressed, isNull);
        expect(productionNavigated, isFalse);
      });
    });
  });
}

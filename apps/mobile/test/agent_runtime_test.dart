import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:creativanta_mobile/automation/agent_models.dart';
import 'package:creativanta_mobile/ui/automation/agent_runtime_view.dart';

void main() {
  group('P7-04 Mobile Agent Runtime, Video Agent & Copilot Actions', () {
    test('Target 1 Acceptance: Delegated permissions checked per step', () {
      final run = MobileAgentRun.createVideoAgentPlan(
        workspaceId: 'ws-demo-01',
        userId: 'usr-viewer-01',
        prompt: 'Review serum Vitamin C 30ml',
      );

      // 1. Viewer lacks 'content:write' permission for step 1
      final resDenied = run.executeStep(
        stepIndex: 0,
        callerRole: 'viewer',
        availableBalance: 100.0,
      );

      expect(resDenied.success, isFalse);
      expect(resDenied.error, contains('Từ chối ủy quyền'));
      expect(resDenied.run.currentState, equals(MobileAgentRunState.failed));
      expect(resDenied.run.diagnosticsRef, isNotNull);
      expect(resDenied.run.auditRef, isNotNull);
      expect(resDenied.run.creditsUsed, equals(0.0));

      // 2. Editor has 'content:write' and can execute step 1
      final resPermitted = run.executeStep(
        stepIndex: 0,
        callerRole: 'editor',
        availableBalance: 100.0,
      );

      expect(resPermitted.success, isTrue);
      expect(resPermitted.run.steps[0].status, equals(MobileAgentStepStatus.completed));
      expect(resPermitted.run.creditsUsed, equals(3.0));
      expect(resPermitted.run.outputs.length, equals(1));
      expect(resPermitted.run.outputs[0].outputType, equals(MobileAgentOutputType.text));

      // 3. High risk step requires approval
      final highRiskRun = MobileAgentRun.createVideoAgentPlan(
        workspaceId: 'ws-demo-01',
        userId: 'usr-mgr-01',
        prompt: 'Auto publish video to TikTok',
        autoPublish: true,
      );

      final resHighRisk = highRiskRun.executeStep(
        stepIndex: 5, // autoPublish step
        callerRole: 'manager',
        availableBalance: 100.0,
      );

      expect(resHighRisk.success, isFalse);
      expect(resHighRisk.pausedReason, contains('cần phê duyệt'));
      expect(resHighRisk.run.currentState, equals(MobileAgentRunState.awaitingApproval));

      // After manager approves, step can execute
      final approvedRun = resHighRisk.run.approveRun('manager');
      expect(approvedRun.approvalState, equals('approved'));

      final resPostApproval = approvedRun.executeStep(
        stepIndex: 5,
        callerRole: 'manager',
        availableBalance: 100.0,
      );
      expect(resPostApproval.success, isTrue);
      expect(resPostApproval.run.steps[5].status, equals(MobileAgentStepStatus.completed));
    });

    test('Target 2 Acceptance: Budget ceiling pauses without overdraft', () {
      // Set ceiling to 10 credits
      final run = MobileAgentRun.createVideoAgentPlan(
        workspaceId: 'ws-demo-01',
        userId: 'usr-01',
        prompt: 'Review serum Vitamin C',
        budgetCeiling: 10.0,
      );

      // Step 1: 3 cr (total 3 <= 10) -> OK
      final r1 = run.executeStep(stepIndex: 0, callerRole: 'editor', availableBalance: 100.0);
      expect(r1.success, isTrue);
      expect(r1.run.creditsUsed, equals(3.0));

      // Step 2: 2 cr (total 5 <= 10) -> OK
      final r2 = r1.run.executeStep(stepIndex: 1, callerRole: 'editor', availableBalance: 100.0);
      expect(r2.success, isTrue);
      expect(r2.run.creditsUsed, equals(5.0));

      // Step 3: 25 cr (total 30 > ceiling 10) -> Must PAUSE without overdraft
      final r3 = r2.run.executeStep(stepIndex: 2, callerRole: 'editor', availableBalance: 100.0);
      expect(r3.success, isFalse);
      expect(r3.pausedReason, contains('chạm hạn mức tín dụng'));
      expect(r3.run.currentState, equals(MobileAgentRunState.waitingContext));
      expect(r3.run.steps[2].status, equals(MobileAgentStepStatus.waitingContext));
      // Zero overdraft: creditsUsed remains 5.0
      expect(r3.run.creditsUsed, equals(5.0));

      // Increasing budget ceiling allows resumption
      final resumed = r3.run.increaseCeiling(50.0);
      expect(resumed.budgetCeiling, equals(60.0));
      expect(resumed.currentState, equals(MobileAgentRunState.executing));

      final r3Resumed = resumed.executeStep(stepIndex: 2, callerRole: 'editor', availableBalance: 100.0);
      expect(r3Resumed.success, isTrue);
      expect(r3Resumed.run.creditsUsed, equals(30.0));
    });

    test('Target 3 Acceptance: Partial failure has audited handoff', () {
      final run = MobileAgentRun.createVideoAgentPlan(
        workspaceId: 'ws-demo-01',
        userId: 'usr-01',
        prompt: 'Review serum Vitamin C',
      );

      // Execute step 1 and step 2
      final r1 = run.executeStep(stepIndex: 0, callerRole: 'editor', availableBalance: 100.0);
      final r2 = r1.run.executeStep(stepIndex: 1, callerRole: 'editor', availableBalance: 100.0);
      expect(r2.run.outputs.length, equals(1)); // 1 preserved output

      // Step 3 fails due to external AI provider timeout
      final handedOff = r2.run.recordPartialFailureHandoff(
        failedStepIndex: 2,
        errorReason: 'Veo video rendering gateway 504 Gateway Timeout',
        targetUserId: 'ops-lead-07',
      );

      // Verify states
      expect(handedOff.currentState, equals(MobileAgentRunState.handedOff));
      expect(handedOff.steps[0].status, equals(MobileAgentStepStatus.completed));
      expect(handedOff.steps[1].status, equals(MobileAgentStepStatus.completed));
      expect(handedOff.steps[2].status, equals(MobileAgentStepStatus.failed));
      expect(handedOff.steps[3].status, equals(MobileAgentStepStatus.skipped));

      // Succeeded outputs preserved
      expect(handedOff.outputs.length, equals(1));
      expect(handedOff.outputs[0].outputType, equals(MobileAgentOutputType.text));

      // Handoff context & audit trails populated
      expect(handedOff.handoffContext, isNotNull);
      expect(handedOff.handoffContext!.handoffTargetUserId, equals('ops-lead-07'));
      expect(handedOff.handoffContext!.summaryOfCompletedWork, contains('Đã hoàn thành 2/6 bước'));
      expect(handedOff.handoffContext!.diagnosticsRef, contains('diag-p7-04'));
      expect(handedOff.handoffContext!.auditRef, contains('audit-handoff'));
      expect(handedOff.handoffContext!.unresolvedActions.length, equals(4));
    });

    test('Bounded memory compresses when exceeding 80% capacity', () {
      var mem = const MobileAgentMemory(maxBytes: 150);

      for (int i = 1; i <= 5; i++) {
        mem = mem.append('step_$i', 'Chi tiết nhật ký thực thi quan sát bước số $i');
      }

      expect(mem.totalBytes, lessThanOrEqualTo(mem.maxBytes));
      expect(mem.isCompressed, isTrue);
      expect(mem.summary, contains('[Compressed memory'));
    });

    testWidgets('AgentRuntimeView widget renders pipeline stages and interactions',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final run = MobileAgentRun.createVideoAgentPlan(
        workspaceId: 'ws-demo-01',
        userId: 'usr-01',
        prompt: 'Review serum Vitamin C',
      );

      await tester.pumpWidget(MaterialApp(
        home: AgentRuntimeView(
          initialRun: run,
          callerRole: 'editor',
          initialBalance: 150.0,
        ),
      ));

      await tester.pumpAndSettle();

      // Check header and stages
      expect(find.text('🤖 AI Agent Studio'), findsOneWidget);
      expect(find.text('AI Video Agent (M07)'), findsOneWidget);
      expect(find.text('Các giai đoạn thực thi (6 Stages)'), findsOneWidget);
      expect(find.text('1. Tạo kịch bản & phân cảnh'), findsOneWidget);
      expect(find.text('3. Sinh hình ảnh đa cảnh (Veo 720p)'), findsOneWidget);

      // Trigger first step
      final playButtons = find.byIcon(Icons.play_arrow);
      expect(playButtons, findsWidgets);

      await tester.tap(playButtons.at(1)); // Tap first step run button
      await tester.pumpAndSettle();

      // Step 1 completed: check icon appears
      expect(find.byIcon(Icons.check), findsOneWidget);
      expect(find.text('📦 Sản phẩm thành phẩm (Outputs)'), findsOneWidget);
      expect(find.text('Bản thảo kịch bản phân đoạn'), findsOneWidget);
    });
  });
}

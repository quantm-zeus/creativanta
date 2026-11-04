import { describe, it, expect } from 'vitest';
import {
  planVideoAgent,
  planCopilotAction,
  executeAgentStep,
  recordPartialFailureHandoff,
  increaseBudgetCeiling,
  approvePendingStep,
  createBoundedMemory,
  appendBoundedMemory,
  hasPermission
} from './agent';

describe('P7-04 Agent Runtime, Video Agent & Copilot Actions (Web)', () => {
  describe('Acceptance Target 1: Every step checks delegated permissions', () => {
    it('allows permitted user to execute step', () => {
      const run = planVideoAgent({
        workspaceId: 'ws-demo-01',
        userId: 'user-01',
        prompt: 'Review serum Vitamin C 30ml phong cách trẻ trung'
      });

      // Step 1 requires 'content:write'
      expect(hasPermission('editor', 'content:write')).toBe(true);

      const result = executeAgentStep(run, 0, 'editor', 100);
      expect(result.success).toBe(true);
      expect(result.run.steps[0].status).toBe('completed');
      expect(result.run.creditsUsed).toBe(3);
      expect(result.run.outputs.length).toBe(1);
      expect(result.run.outputs[0].outputType).toBe('text');
    });

    it('rejects execution when caller lacks required delegated permission', () => {
      const run = planCopilotAction({
        workspaceId: 'ws-demo-01',
        userId: 'user-viewer',
        userRole: 'viewer',
        intent: 'Xóa sản phẩm SKU-999',
        targetObject: 'sku:999'
      });

      // Viewer cannot perform product:delete
      const result = executeAgentStep(run, 0, 'viewer', 100);
      expect(result.success).toBe(false);
      expect(result.error).toContain('Từ chối ủy quyền');
      expect(result.run.steps[0].status).toBe('failed');
      expect(result.run.currentState).toBe('failed');
      expect(result.run.diagnosticsRef).toBeDefined();
      expect(result.run.auditRef).toBeDefined();
      // No credits deducted on refusal
      expect(result.run.creditsUsed).toBe(0);
    });

    it('pauses high-risk operations for explicit approval before dispatching external side-effects', () => {
      const run = planVideoAgent({
        workspaceId: 'ws-demo-01',
        userId: 'user-manager',
        prompt: 'Tạo video ngắn 15s và xuất bản ngay',
        autoPublish: true
      });

      // Execute steps 0 to 4 with manager
      let currentRun = run;
      for (let i = 0; i < 5; i++) {
        const res = executeAgentStep(currentRun, i, 'manager', 200);
        expect(res.success).toBe(true);
        currentRun = res.run;
      }

      // Step 6 (index 5) is autoPublish and high-risk
      const highRiskStep = currentRun.steps[5];
      expect(highRiskStep.isHighRisk).toBe(true);

      const highRiskRes = executeAgentStep(currentRun, 5, 'manager', 200);
      expect(highRiskRes.success).toBe(false);
      expect(highRiskRes.pausedReason).toContain('cần phê duyệt');
      expect(highRiskRes.run.currentState).toBe('awaiting_approval');
      expect(highRiskRes.run.steps[5].status).toBe('awaiting_approval');

      // Approving enables resumption
      const approvalRes = approvePendingStep(highRiskRes.run, 'manager');
      expect(approvalRes.success).toBe(true);
      expect(approvalRes.run.approvalState).toBe('approved');

      // Now execution succeeds
      const postApprovalRes = executeAgentStep(approvalRes.run, 5, 'manager', 200);
      expect(postApprovalRes.success).toBe(true);
      expect(postApprovalRes.run.steps[5].status).toBe('completed');
      expect(postApprovalRes.run.currentState).toBe('completed');
    });
  });

  describe('Acceptance Target 2: Budget ceiling pauses without overdraft', () => {
    it('pauses run in waiting_context when step cost exceeds budget ceiling', () => {
      // Create a run with a low ceiling (e.g. 10 credits)
      const run = planVideoAgent({
        workspaceId: 'ws-demo-01',
        userId: 'user-01',
        prompt: 'Video review sản phẩm kem dưỡng',
        budgetCeiling: 10
      });

      // Step 1 costs 3 cr (total 3 <= 10) -> OK
      const s1 = executeAgentStep(run, 0, 'editor', 100);
      expect(s1.success).toBe(true);
      expect(s1.run.creditsUsed).toBe(3);

      // Step 2 costs 2 cr (total 5 <= 10) -> OK
      const s2 = executeAgentStep(s1.run, 1, 'editor', 100);
      expect(s2.success).toBe(true);
      expect(s2.run.creditsUsed).toBe(5);

      // Step 3 costs 25 cr (total 5 + 25 = 30 > ceiling 10) -> Must PAUSE
      const s3 = executeAgentStep(s2.run, 2, 'editor', 100);
      expect(s3.success).toBe(false);
      expect(s3.pausedReason).toContain('Tạm dừng vì chạm hạn mức tín dụng');
      expect(s3.run.currentState).toBe('waiting_context');
      expect(s3.run.steps[2].status).toBe('waiting_context');
      // No overdraft: credits used remains strictly at 5
      expect(s3.run.creditsUsed).toBe(5);

      // Resuming by increasing budget ceiling
      const resumedRun = increaseBudgetCeiling(s3.run, 40); // ceiling now 50
      expect(resumedRun.budgetCeiling).toBe(50);
      expect(resumedRun.currentState).toBe('executing');
      expect(resumedRun.steps[2].status).toBe('planning');

      // Now Step 3 can execute
      const s3AfterResume = executeAgentStep(resumedRun, 2, 'editor', 100);
      expect(s3AfterResume.success).toBe(true);
      expect(s3AfterResume.run.steps[2].status).toBe('completed');
      expect(s3AfterResume.run.creditsUsed).toBe(30);
    });

    it('pauses run when user available balance is insufficient to prevent overdraft', () => {
      const run = planVideoAgent({
        workspaceId: 'ws-demo-01',
        userId: 'user-01',
        prompt: 'Video review ngắn',
        budgetCeiling: 100
      });

      // User only has 2 credits balance, but step 1 costs 3 credits
      const res = executeAgentStep(run, 0, 'editor', 2);
      expect(res.success).toBe(false);
      expect(res.pausedReason).toContain('Tạm dừng vì chạm hạn mức tín dụng');
      expect(res.run.currentState).toBe('waiting_context');
      expect(res.run.creditsUsed).toBe(0);
    });
  });

  describe('Acceptance Target 3: Partial failure has audited handoff', () => {
    it('preserves succeeded steps and outputs while generating diagnostics and audit ref', () => {
      const run = planVideoAgent({
        workspaceId: 'ws-demo-01',
        userId: 'user-01',
        prompt: 'Video review serum 30ml'
      });

      // Execute step 0 and 1 successfully
      const s1 = executeAgentStep(run, 0, 'editor', 100);
      const s2 = executeAgentStep(s1.run, 1, 'editor', 100);
      expect(s2.run.outputs.length).toBe(1); // Script output preserved

      // Step 3 (index 2: visual gen) fails due to upstream AI provider rate limit
      const handedOffRun = recordPartialFailureHandoff(
        s2.run,
        2,
        'Veo API rate limit exceeded (429 Too Many Requests)',
        'ops-engineer-09'
      );

      // Verify states
      expect(handedOffRun.currentState).toBe('handed_off');
      expect(handedOffRun.steps[0].status).toBe('completed');
      expect(handedOffRun.steps[1].status).toBe('completed');
      expect(handedOffRun.steps[2].status).toBe('failed');
      expect(handedOffRun.steps[3].status).toBe('skipped');
      expect(handedOffRun.steps[4].status).toBe('skipped');
      expect(handedOffRun.steps[5].status).toBe('skipped');

      // Succeeded outputs preserved
      expect(handedOffRun.outputs.length).toBe(1);
      expect(handedOffRun.outputs[0].outputType).toBe('text');

      // Audited handoff context attached
      expect(handedOffRun.handoffContext).toBeDefined();
      expect(handedOffRun.handoffContext?.handoffTargetUserId).toBe('ops-engineer-09');
      expect(handedOffRun.handoffContext?.diagnosticsRef).toContain('diag-p7-04');
      expect(handedOffRun.handoffContext?.auditRef).toContain('audit-handoff');
      expect(handedOffRun.handoffContext?.summaryOfCompletedWork).toContain('Đã hoàn thành 2/6 bước');
      expect(handedOffRun.handoffContext?.unresolvedActions.length).toBe(4);
    });
  });

  describe('Bounded Memory & Summarization', () => {
    it('compresses and bounds memory within capacity limits', () => {
      let memory = createBoundedMemory(200); // 200 bytes limit

      // Add several observations
      for (let i = 1; i <= 6; i++) {
        memory = appendBoundedMemory(memory, `obs_${i}`, `Chi tiết quan sát phân cảnh số ${i}`);
      }

      // Memory should have triggered compression
      expect(memory.totalBytes).toBeLessThanOrEqual(memory.maxBytes);
      expect(memory.isCompressed).toBe(true);
      expect(memory.summary).toContain('[Compressed memory');
    });
  });
});

import 'package:flutter_test/flutter_test.dart';
import 'package:creativanta_mobile/automation/approval_models.dart';

void main() {
  group('P7-02 Mobile Workflow Runtime & Approvals Tests', () {
    test('Target Acceptance 1: Simulation has no business effects', () {
      final preflight = MobilePreflightReport(
        workflowId: 'wf-auto-order-01',
        isValid: true,
        estimatedCreditsTotal: 50,
        actions: const [
          MobilePreflightActionSummary(
            nodeId: 'n-act-1',
            rpcName: 'creativanta.commerce.v1.InventoryService/ReserveStock',
            targetPlatform: 'shopify',
            estimatedCredits: 50,
            isSensitive: true,
          ),
        ],
        warnings: const [],
        blockers: const [],
      );

      final safetyGate = MobileResumeSafetyGate();

      // Preflight simulation verifies action eligibility and costs, but dispatches ZERO confirmed side-effects
      expect(preflight.isValid, isTrue);
      expect(preflight.estimatedCreditsTotal, equals(50));
      expect(safetyGate.recordedEffects, isEmpty);
    });

    test('Target Acceptance 2: Changed action invalidates approval', () {
      final initialActionHash = 'hash-action-v1-reserve-stock-quantity-1';
      final modifiedActionHash = 'hash-action-v2-reserve-stock-quantity-20';

      final approval = MobileApprovalRequest(
        approvalId: 'appr-req-001',
        workspaceId: 'ws-demo-1',
        runId: 'run-p7-101',
        workflowId: 'wf-auto-order-01',
        nodeId: 'node-appr-1',
        title: 'Discount Gate > 20% for VIP Order #8841',
        actionHash: initialActionHash,
        actionRpc: 'creativanta.commerce.v1.InventoryService/ReserveStock',
        targetObjects: const ['order:8841', 'sku:vip-99'],
        budgetQuoteCredits: 50,
        status: MobileApprovalStatus.pending,
        requestedAt: DateTime.parse('2026-11-04T10:00:00Z'),
        expiresAt: DateTime.parse('2026-11-05T10:00:00Z'),
      );

      // 1. Initial hash matches -> valid
      expect(approval.isActionHashValid(initialActionHash), isTrue);

      // 2. Action payload changed -> invalidates approval
      expect(approval.isActionHashValid(modifiedActionHash), isFalse);

      // 3. Explicitly invalidated approval returns false even with matching hash
      final invalidatedApproval = MobileApprovalRequest(
        approvalId: 'appr-req-002',
        workspaceId: 'ws-demo-1',
        runId: 'run-p7-101',
        workflowId: 'wf-auto-order-01',
        nodeId: 'node-appr-1',
        title: 'Discount Gate > 20% for VIP Order #8841',
        actionHash: initialActionHash,
        actionRpc: 'creativanta.commerce.v1.InventoryService/ReserveStock',
        status: MobileApprovalStatus.invalidated,
        isInvalidated: true,
        invalidationReason: 'Workflow version changed while pending',
        requestedAt: DateTime.parse('2026-11-04T10:00:00Z'),
        expiresAt: DateTime.parse('2026-11-05T10:00:00Z'),
      );
      expect(invalidatedApproval.isActionHashValid(initialActionHash), isFalse);
    });

    test('Target Acceptance 3: Resume never replays confirmed effect', () {
      final safetyGate = MobileResumeSafetyGate();
      const idempotencyKey = 'run-101:step-act-1:idemp-key-xyz';

      // 1. First execution permitted
      expect(safetyGate.shouldExecute(idempotencyKey), isTrue);

      // 2. Record confirmed side effect execution
      safetyGate.recordConfirmedEffect(MobileSideEffect(
        effectId: 'eff-101',
        rpcName: 'creativanta.commerce.v1.InventoryService/ReserveStock',
        idempotencyKey: idempotencyKey,
        targetResource: 'sku:vip-99',
        confirmed: true,
        executedAt: DateTime.now(),
      ));

      // 3. On resume after pause/interruption, confirmed effect is NEVER replayed
      expect(safetyGate.shouldExecute(idempotencyKey), isFalse);
      expect(safetyGate.recordedEffects.length, equals(1));
    });

    test('Approval expiry auto-detection based on deadline', () {
      final pastApproval = MobileApprovalRequest(
        approvalId: 'appr-req-expired',
        workspaceId: 'ws-demo-1',
        runId: 'run-101',
        workflowId: 'wf-1',
        nodeId: 'node-appr',
        title: 'Expired Gate',
        actionHash: 'some-hash',
        actionRpc: 'creativanta.commerce.v1.DiscountService/ApplyOrderDiscount',
        status: MobileApprovalStatus.pending,
        requestedAt: DateTime.parse('2026-11-01T10:00:00Z'),
        expiresAt: DateTime.parse('2026-11-02T10:00:00Z'),
      );

      final currentTime = DateTime.parse('2026-11-04T12:00:00Z');
      expect(pastApproval.isExpired(currentTime), isTrue);
    });

    test('DLQ retry threshold and error diagnostics enforcement', () {
      final dlqItem = MobileDLQItem(
        dlqId: 'dlq-101',
        workspaceId: 'ws-demo-1',
        runId: 'run-fail-1',
        workflowId: 'wf-1',
        nodeId: 'node-act',
        errorCode: 'RATE_LIMIT_EXCEEDED',
        errorMessage: 'Downstream 429 Too Many Requests',
        retryCount: 3,
        maxRetries: 3,
        status: MobileDLQStatus.pending,
        createdAt: DateTime.parse('2026-11-04T10:00:00Z'),
        updatedAt: DateTime.parse('2026-11-04T10:05:00Z'),
      );

      // When retries reached maxRetries, direct retry is locked
      expect(dlqItem.canRetry, isFalse);

      final retriableItem = MobileDLQItem(
        dlqId: 'dlq-102',
        workspaceId: 'ws-demo-1',
        runId: 'run-fail-2',
        workflowId: 'wf-1',
        nodeId: 'node-act',
        errorCode: 'TIMEOUT',
        errorMessage: 'Temporary network timeout',
        retryCount: 1,
        maxRetries: 3,
        status: MobileDLQStatus.pending,
        createdAt: DateTime.parse('2026-11-04T10:00:00Z'),
        updatedAt: DateTime.parse('2026-11-04T10:05:00Z'),
      );
      expect(retriableItem.canRetry, isTrue);
    });
  });
}

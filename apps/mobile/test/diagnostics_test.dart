import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:creativanta_mobile/diagnostics/diagnostics_models.dart';
import 'package:creativanta_mobile/generated/creativanta/admin/v1/diagnostics.pb.dart';
import 'package:creativanta_mobile/generated/creativanta/common/v1/types.pb.dart';
import 'package:creativanta_mobile/ui/diagnostics/diagnostics_screen.dart';

void main() {
  group('P0-05 Mobile Diagnostics & Generated Protobuf (M059)', () {
    test('DiagnosticsService protobuf roundtrip for ExecuteRepairStepRequest', () {
      final req = ExecuteRepairStepRequest(
        context: CommandContext(
          idempotencyKey: 'mob_repair_01',
          workspaceId: UUID(value: 'aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa'),
        ),
        diagnosticsId: UUID(value: 'd1111111-1111-4111-8111-111111111111'),
        step: RepairWizardStep.REPAIR_WIZARD_STEP_FIX,
        actionKey: 'confirm_succeeded',
        verificationReference: 'tiktok_post_9988',
      );

      final bytes = req.writeToBuffer();
      final decoded = ExecuteRepairStepRequest.fromBuffer(bytes);
      expect(decoded.context.idempotencyKey, 'mob_repair_01');
      expect(decoded.step, RepairWizardStep.REPAIR_WIZARD_STEP_FIX);
      expect(decoded.verificationReference, 'tiktok_post_9988');
    });

    test('blocks blind retry when external_effects status is unknown or submitted', () {
      final unk = evaluateMobileExternalEffectGuard(
        MobileExternalEffectStatus.unknown,
      );
      expect(unk.allowBlindRetry, isFalse);
      expect(unk.decisionKey, 'blocked_requires_reconciliation');

      final sub = evaluateMobileExternalEffectGuard(
        MobileExternalEffectStatus.submitted,
      );
      expect(sub.allowBlindRetry, isFalse);

      final prep = evaluateMobileExternalEffectGuard(
        MobileExternalEffectStatus.prepared,
      );
      expect(prep.allowBlindRetry, isTrue);
    });

    test('sanitizes raw SQL and secrets per RULE-M23-A04 and enforces Step 3 proof', () {
      final sanitized = sanitizeMobileDiagnosticExplanation(
        "SELECT * FROM connected_accounts WHERE access_token = 'secret'",
      );
      expect(sanitized.toLowerCase().contains('select '), isFalse);
      expect(sanitized.toLowerCase().contains('access_token'), isFalse);

      expect(
        canExecuteMobileRepairStep(
          step: RepairWizardStep.REPAIR_WIZARD_STEP_FIX,
          requiresManualReconciliation: true,
          verificationReference: '',
        ),
        isFalse,
      );
      expect(
        canExecuteMobileRepairStep(
          step: RepairWizardStep.REPAIR_WIZARD_STEP_FIX,
          requiresManualReconciliation: true,
          verificationReference: 'verified_post_001',
        ),
        isTrue,
      );
    });

    testWidgets('MobileDiagnosticsScreen renders M059 unknown external effect guard', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: MobileDiagnosticsScreen(
            effectStatus: MobileExternalEffectStatus.unknown,
          ),
        ),
      );

      expect(find.text('Chẩn đoán Hệ thống (M059)'), findsOneWidget);
      expect(
        find.textContaining('blocked_requires_reconciliation'),
        findsOneWidget,
      );
    });
  });
}

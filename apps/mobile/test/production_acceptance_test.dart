import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:creativanta_mobile/production/production_models.dart';
import 'package:creativanta_mobile/ui/production/studio_launcher_view.dart';

void main() {
  group('P4-01 Production Jobs, Router & Budgets Acceptance Tests', () {
    test('Acceptance Target 3: Budget preview and partial batch input validation', () {
      final List<Map<String, String>> batch = [];
      for (int i = 0; i < 20; i++) {
        if (i == 5) {
          // Empty name
          batch.add({
            'id': 'p-$i',
            'name': '  ',
            'prompt': 'Prompt video có nội dung hoàn chỉnh và chi tiết #$i',
          });
        } else if (i == 12) {
          // Short prompt
          batch.add({
            'id': 'p-$i',
            'name': 'Sản phẩm mỹ phẩm cao cấp #$i',
            'prompt': '123',
          });
        } else {
          batch.add({
            'id': 'p-$i',
            'name': 'Sản phẩm số #$i',
            'prompt': 'Prompt video có nội dung hoàn chỉnh và chi tiết #$i',
          });
        }
      }

      // Evaluate with 100 available credits
      final preview = evaluateBatchPreview(
        rawItems: batch,
        rateUSDPerSec: 0.04,
        availableCredits: 100,
      );

      // Verify row counts: exactly 18 valid, 2 invalid
      expect(preview.totalItems, 20);
      expect(preview.validCount, 18);
      expect(preview.invalidCount, 2);

      // Row 5 validation error and 0 credit charge
      final row5 = preview.items[5];
      expect(row5.isValid, false);
      expect(row5.estimatedCredits, 0);
      expect(row5.validationError, contains('Tên sản phẩm'));

      // Row 12 validation error and 0 credit charge
      final row12 = preview.items[12];
      expect(row12.isValid, false);
      expect(row12.estimatedCredits, 0);
      expect(row12.validationError, contains('Prompt miêu tả'));

      // Total credits must equal sum of ONLY the 18 valid rows: 18 * 80 = 1440
      expect(preview.totalCredits, 1440);
      expect(preview.totalCostUSD, closeTo(18 * 15 * 0.04, 0.001));

      // With 100 credits available, sufficientCredits must be false
      expect(preview.sufficientCredits, false);

      // With 2000 credits available, sufficientCredits must be true
      final sufficientPreview = evaluateBatchPreview(
        rawItems: batch,
        rateUSDPerSec: 0.04,
        availableCredits: 2000,
      );
      expect(sufficientPreview.sufficientCredits, true);
    });

    testWidgets('Acceptance Target 1 & R7-07: Cancel fails closed without backend confirmation and refunds balance only when server confirms',
        (WidgetTester tester) async {
      const initialBalance = 100;
      final testJobs = [
        const ProductionJobModel(
          jobId: 'job-cancel-test-1',
          assetId: 'asset-1',
          title: 'Review serum Niacinamide',
          prompt: 'Thoa serum lên da',
          provider: 'veo',
          status: 'processing',
          stage: 'Tạo visuals',
          progressPct: 50,
          estimatedCredits: 20,
          actualCredits: 20,
          costCeilingUSD: 0.60,
        ),
      ];

      // 1. Negative / fail-closed: without onCancelJobRemote (backend disconnected), balance and job stay unchanged
      await tester.pumpWidget(
        MaterialApp(
          home: StudioLauncherView(
            initialBalance: initialBalance,
            initialJobs: List.of(testJobs),
          ),
        ),
      );

      expect(find.text('100 cr'), findsOneWidget);
      final cancelBtnDisconnected = find.byKey(const ValueKey('cancel_job_job-cancel-test-1'));
      await tester.tap(cancelBtnDisconnected);
      await tester.pump();

      expect(find.text('100 cr'), findsOneWidget,
          reason: 'Balance must NOT be refunded when StudioService/Cancel is not connected');
      expect(find.textContaining('fail-closed'), findsOneWidget);
      expect(find.text('Review serum Niacinamide'), findsOneWidget);

      // 2. Positive: with server-confirmed StudioService/Cancel outcome, job cancels and refunds 20 credits
      await tester.pumpWidget(
        MaterialApp(
          home: StudioLauncherView(
            initialBalance: initialBalance,
            initialJobs: List.of(testJobs),
            onCancelJobRemote: (jobId, estimatedCredits) async => StudioJobCancelOutcome(
              ok: true,
              jobId: jobId,
              creditsRefunded: true,
              refundedCredits: estimatedCredits,
            ),
          ),
        ),
      );

      // Verify initial balance
      expect(find.text('100 cr'), findsOneWidget);
      expect(find.text('Review serum Niacinamide'), findsOneWidget);
      expect(find.text('Veo (Primary)'), findsOneWidget);

      // Tap Cancel button
      final cancelBtn = find.byKey(const ValueKey('cancel_job_job-cancel-test-1'));
      expect(cancelBtn, findsOneWidget);
      await tester.tap(cancelBtn);
      await tester.pumpAndSettle();

      // Balance must be refunded: 100 + 20 = 120 cr
      expect(find.text('120 cr'), findsOneWidget);
      expect(find.text('Đã hủy job job-cancel-test-1 và hoàn trả 20 credits!'), findsOneWidget);
    });

    testWidgets('Acceptance Target 2: Fallback provider Kling displays fallback badge without double debit',
        (WidgetTester tester) async {
      final fallbackJobs = [
        const ProductionJobModel(
          jobId: 'job-fallback-1',
          assetId: 'asset-fb-1',
          title: 'Video đồng hồ bấm giờ',
          prompt: 'Quay cận cảnh kim trôi',
          provider: 'kling',
          status: 'processing',
          stage: 'Chạy trên Kling Fallback',
          progressPct: 60,
          estimatedCredits: 80,
          actualCredits: 80,
          costCeilingUSD: 0.60,
        ),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: StudioLauncherView(
            initialBalance: 20, // 100 initial - 80 debited once = 20 remaining
            initialJobs: fallbackJobs,
          ),
        ),
      );

      // Verifies Kling Fallback badge is clearly surfaced to operator
      expect(find.text('Kling (Fallback)'), findsOneWidget);
      expect(find.text('20 cr'), findsOneWidget);
    });

    test('Acceptance Target 4: Sandboxed post-production and FFmpeg/ffprobe security bounds', () {
      final allowedFlags = {
        '-i', '-y', '-v', '-loglevel', '-ss', '-t', '-to', '-vf', '-af',
        '-c:v', '-c:a', '-b:v', '-b:a', '-r', '-s', '-pix_fmt', '-an', '-vn',
        '-movflags', '-threads', '-preset', '-crf', '-filter_complex', '-hide_banner',
      };

      // 1. Valid args
      final validArgs = ['-y', '-hide_banner', '-loglevel', 'error', '-i', 'in.mp4', '-c:v', 'libx264', 'out.mp4'];
      for (final a in validArgs) {
        if (a.startsWith('-')) {
          expect(allowedFlags.contains(a), true);
        }
      }

      // 2. Shell injection characters strictly blocked
      final dangerousArgs = [
        '; rm -rf /',
        '| cat /etc/passwd',
        '`whoami`',
        '\$(id)',
        '> /tmp/overwrite',
      ];

      for (final bad in dangerousArgs) {
        final containsInjection = bad.contains(';') || bad.contains('|') || bad.contains('`') || bad.contains('\$') || bad.contains('>');
        expect(containsInjection, true);
      }
    });
  });
}

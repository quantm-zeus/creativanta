import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:creativanta_mobile/production/quick_edit_models.dart';
import 'package:creativanta_mobile/ui/production/studio_quick_edit_view.dart';

void main() {
  group('Mobile Quick Edit (Screen M014 · Module M07) - Acceptance Targets', () {
    // ========================================================================
    // Target 1: Poor ASR can be repaired (EC-M07-Q01)
    // ========================================================================
    test('Acceptance Target 1: Detects Vietnamese fillers and supports ASR repair with fallback', () {
      final rawWords = [
        const QuickEditWordModel(wordId: 'w1', text: 'ừm', startMs: 500, endMs: 900),
        const QuickEditWordModel(wordId: 'w2', text: 'xin chào', startMs: 1000, endMs: 1400),
        const QuickEditWordModel(wordId: 'w3', text: 'kiểu', startMs: 1500, endMs: 1800),
        const QuickEditWordModel(wordId: 'w4', text: 'sản phẩm lỗi', startMs: 1900, endMs: 2500),
      ];

      expect(checkIsFiller('ừm'), isTrue);
      expect(checkIsFiller('kiểu'), isTrue);
      expect(checkIsFiller('xin chào'), isFalse);

      // Valid repair: fixes text and timecode
      final validRepair = repairMobileWordTranscript(rawWords, 'w4', 'sản phẩm chuẩn', 1900, 2600);
      expect(validRepair.fallbackMode, isFalse);
      expect(validRepair.error, isNull);
      expect(validRepair.words.firstWhere((w) => w.wordId == 'w4').text, equals('sản phẩm chuẩn'));

      // Edge Case EC-M07-Q01: Invalid temporal alignment triggers fallback mode
      final invalidRepair = repairMobileWordTranscript(rawWords, 'w2', 'thời gian lỗi', 5000, 2000);
      expect(invalidRepair.fallbackMode, isTrue);
      expect(invalidRepair.error, equals('Auto-alignment failed. [Try segment mode] or [Manual cut].'));
    });

    // ========================================================================
    // Target 2: Correct ratio/audio/subtitles & Credit confirmation
    // ========================================================================
    test('Acceptance Target 2: Accurate credit calculation for base + add-ons', () {
      const baseAddons = QuickEditAddonsModel();
      expect(calculateMobileQuickEditCredits(baseAddons), equals(15)); // Base 15

      // Add hook (+3), beat-sync (+5), b-roll (+10), preset (+3), audio (+3)
      final fullAddons = baseAddons.copyWith(
        addHook: true,
        beatSync: true,
        bRoll: true,
        platformPreset: 'tiktok',
        audioEnhancement: true,
      );
      // Total: 15 + 3 + 5 + 10 + 3 + 3 = 39
      expect(calculateMobileQuickEditCredits(fullAddons), equals(39));
    });

    // ========================================================================
    // Target 3: Deleted text maps to intended segment with zero drift
    // ========================================================================
    test('Acceptance Target 3: Strikethrough words map to cuts with adjacent coalescing and zero drift', () {
      const totalDuration = 10000;
      final words = [
        const QuickEditWordModel(wordId: 'w1', text: 'Xin chào', startMs: 0, endMs: 1200),
        const QuickEditWordModel(wordId: 'w2', text: 'ừm', startMs: 1300, endMs: 1600, isFiller: true),
        const QuickEditWordModel(wordId: 'w3', text: 'à', startMs: 1650, endMs: 1900, isFiller: true), // 50ms gap -> coalesce!
        const QuickEditWordModel(wordId: 'w4', text: 'bạn', startMs: 2500, endMs: 5000),
        const QuickEditWordModel(wordId: 'w5', text: 'thừa', startMs: 5500, endMs: 7000, isDeleted: true), // Cut
        const QuickEditWordModel(wordId: 'w6', text: 'hết', startMs: 8000, endMs: 10000),
      ];

      final pauses = [
        const QuickEditPauseModel(startMs: 7000, endMs: 8000, durationMs: 1000),
      ];

      final timeline = computeMobileRetainedTimeline(totalDuration, words, pauses, true, true);

      // Verifies zero cumulative drift
      expect(timeline.hasZeroDrift, isTrue);

      // Retained + cuts = total
      final sumRetained = timeline.segments.fold(0, (acc, s) => acc + s.durationMs);
      expect(sumRetained, equals(timeline.finalDurationMs));
      expect(sumRetained + timeline.timeSavedMs, equals(totalDuration));
    });

    // ========================================================================
    // Widget Interaction Test: StudioQuickEditView
    // ========================================================================
    testWidgets('Renders Quick Edit view, allows strikethrough, and shows confirmation dialog', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: StudioQuickEditView(
            initialBalance: 320,
          ),
        ),
      );

      // 1. Check title and balance
      expect(find.text('Quick Edit'), findsOneWidget);
      expect(find.text('🪙 320'), findsOneWidget);

      // 2. Check TabBar items
      expect(find.text('Transcript'), findsOneWidget);
      expect(find.text('Edit Plan'), findsOneWidget);
      expect(find.text('Settings'), findsOneWidget);

      // 3. Transcript tab shows words
      expect(find.text('ừm'), findsOneWidget);

      // 4. Tap word to strike through
      await tester.tap(find.text('ừm'));
      await tester.pumpAndSettle();

      // 5. Switch to Edit Plan tab
      await tester.tap(find.text('Edit Plan'));
      await tester.pumpAndSettle();

      expect(find.text('💬 Phụ đề hoạt họa'), findsOneWidget);
      expect(find.text('🎯 Thêm Hook mở đầu'), findsOneWidget);

      // 6. Tap Apply button to open confirmation dialog (Acceptance Criterion 1)
      await tester.tap(find.textContaining('Apply'));
      await tester.pumpAndSettle();

      expect(find.text('Xác nhận tạo video'), findsOneWidget);
      expect(find.textContaining('Estimated cost: 15 credits'), findsOneWidget);
      expect(find.textContaining('Your balance: 320 credits'), findsOneWidget);
      expect(find.text('Generate'), findsOneWidget);
      expect(find.text('Cancel'), findsOneWidget);

      // 7. Tap Generate
      await tester.tap(find.text('Generate'));
      await tester.pumpAndSettle();

      // Balance reduced from 320 to 305
      expect(find.text('🪙 305'), findsOneWidget);
    });
  });
}

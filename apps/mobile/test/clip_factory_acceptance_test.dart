import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:creativanta_mobile/production/clip_factory_models.dart';
import 'package:creativanta_mobile/ui/production/studio_clip_factory_view.dart';

void main() {
  group('Mobile Clip Factory (Screen M015 · Module M07) - Acceptance Targets', () {
    // ========================================================================
    // Acceptance Target 1: No speech uses visual path (EC-M07-C01)
    // ========================================================================
    test('Acceptance Target 1: Falls back to visual scene detection + beat analysis when speech is absent', () {
      // Case 1: Music-only video / hasSpeech is false
      final visualStrategy = deriveHookStrategy(
        hasSpeech: false,
        visualBeatPattern: 'Fast cuts & visual beat drop',
      );
      expect(visualStrategy['hookType'], equals('visual_hook'));
      expect(visualStrategy['hookDescription'], contains('Fast cuts & visual beat drop'));
      expect(visualStrategy['hookStrengthScore'], greaterThan(70.0));

      // Case 2: hasSpeech is true but transcript snippet is empty
      final emptySpeechStrategy = deriveHookStrategy(
        hasSpeech: true,
        transcriptSnippet: '   ',
        visualBeatPattern: 'Cinematic color shift',
      );
      expect(emptySpeechStrategy['hookType'], equals('visual_hook'));
      expect(emptySpeechStrategy['hookDescription'], contains('Cinematic color shift'));

      // Case 3: Speech present
      final speechStrategy = deriveHookStrategy(
        hasSpeech: true,
        transcriptSnippet: 'Bí quyết x3 doanh số bán hàng trong tuần đầu tiên',
      );
      expect(speechStrategy['hookType'], equals('speech_hook'));
      expect(speechStrategy['hookDescription'], contains('Bí quyết x3 doanh số'));
    });

    // ========================================================================
    // Acceptance Target 2: Missing trend data labeled
    // ========================================================================
    test('Acceptance Target 2: Labels virality score without trend data with "⚠️ Pattern-only" badge', () {
      // Case A: Missing trend data -> hasTrendData = false, contentRelevance = 0.0, badge = "⚠️ Pattern-only"
      final scoreNoTrend = calculateViralityScore(
        engagement: 90,
        hook: 85,
        pacing: 80,
        audio: 75,
        relevance: 95, // Supplied, but must be ignored/zeroed out
        hasTrendData: false,
      );

      expect(scoreNoTrend.hasTrendData, isFalse);
      expect(scoreNoTrend.contentRelevance, equals(0.0));
      expect(scoreNoTrend.scoreBadge, equals(kCanonicalPatternOnlyBadge));
      expect(scoreNoTrend.scoreBadge, equals('⚠️ Pattern-only'));

      // Case B: With trend data -> hasTrendData = true, contentRelevance accounted for
      final scoreWithTrend = calculateViralityScore(
        engagement: 90,
        hook: 85,
        pacing: 80,
        audio: 75,
        relevance: 95,
        hasTrendData: true,
      );

      expect(scoreWithTrend.hasTrendData, isTrue);
      expect(scoreWithTrend.contentRelevance, equals(95.0));
      expect(scoreWithTrend.scoreBadge, isNot(equals(kCanonicalPatternOnlyBadge)));
      expect(scoreWithTrend.scoreBadge, equals('🔥 Viral Candidate'));
    });

    // ========================================================================
    // Acceptance Target 3: Each clip has source lineage
    // ========================================================================
    test('Acceptance Target 3: Builds source lineage payload referencing parent asset and -14.0 LUFS', () {
      const sourceAssetId = 'asset-long-interview-m015';
      const clipId = 'clip-part-01';
      const startS = 25.0;
      const endS = 70.0;
      const ratio = '9:16';
      const ctaText = 'Đăng ký ngay link bio!';

      final lineage = buildClipLineagePayload(
        sourceAssetId: sourceAssetId,
        clipId: clipId,
        startS: startS,
        endS: endS,
        ratio: ratio,
        hasTrendData: true,
        ctaText: ctaText,
      );

      expect(lineage['parent_id'], equals(sourceAssetId));
      expect(lineage['source_asset_id'], equals(sourceAssetId));
      expect(lineage['clip_id'], equals(clipId));
      expect(lineage['derivative_type'], equals('clip'));
      expect(lineage['aspect_ratio'], equals('9:16'));

      final timecodes = lineage['timecodes'] as Map<String, dynamic>;
      expect(timecodes['start_s'], equals(25.0));
      expect(timecodes['end_s'], equals(70.0));
      expect(timecodes['duration_s'], equals(45.0));

      // Audio normalization compliance (-14.0 LUFS per AC-5)
      expect(lineage['audio_lufs'], equals(kCanonicalAudioLufs));
      expect(lineage['audio_lufs'], equals(-14.0));
      expect(lineage['audio_normalized'], isTrue);

      expect(lineage['cta_overlay'], equals(ctaText));
      expect(lineage['extracted_at'], isA<String>());
    });

    // ========================================================================
    // Tier Concurrency Limits (EC-M07-004)
    // ========================================================================
    test('Enforces tier-based concurrent clip extraction limits', () {
      expect(getTierMaxConcurrentClipJobs('Free'), equals(1));
      expect(getTierMaxConcurrentClipJobs('Starter'), equals(2));
      expect(getTierMaxConcurrentClipJobs('Pro'), equals(5));
      expect(getTierMaxConcurrentClipJobs('Business'), equals(10));
      expect(getTierMaxConcurrentClipJobs('Enterprise'), equals(10));
    });

    // ========================================================================
    // Widget Test: StudioClipFactoryView renders proposals and badges
    // ========================================================================
    testWidgets('Widget Test: Renders proposals, toggles visual path and pattern-only badges', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: StudioClipFactoryView(
            initialBalance: 300,
            sourceTitle: 'Sản Phẩm Mới 2026',
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify Screen M015 AppBar and initial elements
      expect(find.text('Clip Factory (1→N)'), findsOneWidget);
      expect(find.textContaining('Sản Phẩm Mới 2026'), findsOneWidget);
      expect(find.text('🪙 300'), findsOneWidget);

      // Verify Target 2: By default hasTrendData is false -> "⚠️ Pattern-only" badge is visible
      expect(find.text('⚠️ Pattern-only'), findsWidgets);

      // Verify Hook tags initially present
      expect(find.text('🗣️ Speech Hook'), findsWidgets);

      // Tap Speech Mode toggle to switch to Visual Path (Target 1)
      final speechButton = find.text('Speech Mode');
      expect(speechButton, findsOneWidget);
      await tester.tap(speechButton);
      await tester.pumpAndSettle();

      // Now button switches to 'Visual Path' and cards show '👁️ Visual Hook'
      expect(find.text('Visual Path'), findsOneWidget);
      expect(find.text('👁️ Visual Hook'), findsWidgets);

      // Verify batch button
      expect(find.textContaining('Xuất hàng loạt'), findsOneWidget);
    });
  });
}

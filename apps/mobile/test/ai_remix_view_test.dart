import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:creativanta_mobile/production/production_models.dart';
import 'package:creativanta_mobile/ui/production/ai_remix_view.dart';

void main() {
  group('P4-04 Mobile AI Remix & Multi-Merge Acceptance Tests', () {
    // ========================================================================
    // Target 1: One canonical similarity threshold (<30%)
    // ========================================================================
    test('Target 1: Canonical similarity threshold is strictly < 30.0%', () {
      expect(kCanonicalSimilarityThreshold, 30.0);

      // 29.9% passes
      final resPass = evaluateRemixOriginality(29.9);
      expect(resPass.passed, isTrue);
      expect(resPass.similarityPercentage, 29.9);
      expect(resPass.originalityScore, closeTo(70.1, 0.01));
      expect(resPass.actionableAlternatives, isEmpty);

      // 30.0% fails strictly
      final resExact = evaluateRemixOriginality(30.0);
      expect(resExact.passed, isFalse);
      expect(resExact.actionableAlternatives.length, greaterThanOrEqualTo(2));
      expect(resExact.explanation, contains('max 30.0%'));

      // 35.0% fails with actionable alternatives
      final resFail = evaluateRemixOriginality(35.0);
      expect(resFail.passed, isFalse);
      expect(resFail.actionableAlternatives, contains("Adjust to 'Loose Inspiration' fidelity"));
      expect(resFail.actionableAlternatives, contains('Edit script manually'));
    });

    // ========================================================================
    // Target 2: No unlicensed media bypass (SAFE-2026-02)
    // ========================================================================
    test('Target 2: Confirmed copyrighted media cannot be bypassed by risk', () {
      // Tier limits
      expect(getTierMaxMedia('free'), 5);
      expect(getTierMaxMedia('starter'), 10);
      expect(getTierMaxMedia('pro'), 20);
      expect(getTierMaxMedia('business'), 50);

      // Unlicensed track without proof must be hard blocked
      final unverified = [
        const MultiMergeItemModel(itemId: 'v1', assetId: 'vid1', mediaType: 'video', title: 'V1', durationSeconds: 5),
        const MultiMergeItemModel(
          itemId: 'a1',
          assetId: 'audio-hit',
          mediaType: 'audio',
          title: 'Sony Hit 2026',
          durationSeconds: 10,
          hasCopyrightHit: true,
          licenseProofKey: '', // Unlicensed!
        ),
      ];

      final failedRes = validateMultiMergeTimeline('pro', unverified);
      expect(failedRes.isValid, isFalse);
      expect(failedRes.hasUnlicensedCopyrightBlock, isTrue);
      expect(failedRes.errors.first, contains('SAFE-2026-02'));

      // Licensed track with proof must pass
      final licensed = [
        const MultiMergeItemModel(itemId: 'v1', assetId: 'vid1', mediaType: 'video', title: 'V1', durationSeconds: 5),
        const MultiMergeItemModel(
          itemId: 'a1',
          assetId: 'audio-hit',
          mediaType: 'audio',
          title: 'Sony Hit 2026',
          durationSeconds: 10,
          hasCopyrightHit: true,
          licenseProofKey: 'https://licensing.example.com/certs/AUTH-12345',
        ),
      ];
      final passRes = validateMultiMergeTimeline('pro', licensed);
      expect(passRes.isValid, isTrue);
      expect(passRes.hasUnlicensedCopyrightBlock, isFalse);

      // Auto-transitions: Image->Image ken_burns, Image->Video fade_in, Video->Video crossfade
      final transItems = [
        const MultiMergeItemModel(itemId: 'i1', assetId: 'img1', mediaType: 'image', title: 'I1', durationSeconds: 3),
        const MultiMergeItemModel(itemId: 'i2', assetId: 'img2', mediaType: 'image', title: 'I2', durationSeconds: 3),
        const MultiMergeItemModel(itemId: 'v1', assetId: 'vid1', mediaType: 'video', title: 'V1', durationSeconds: 5),
        const MultiMergeItemModel(itemId: 'v2', assetId: 'vid2', mediaType: 'video', title: 'V2', durationSeconds: 5),
      ];
      final transRes = validateMultiMergeTimeline('pro', transItems, autoTransitions: true);
      expect(transRes.processedItems[0].transitionToNext, 'ken_burns');
      expect(transRes.processedItems[1].transitionToNext, 'fade_in');
      expect(transRes.processedItems[2].transitionToNext, 'crossfade');
    });

    // ========================================================================
    // Target 3: Foreign/DRM source has usable error and SSRF block
    // ========================================================================
    test('Target 3: Usable error on DRM, Geo-blocked and SSRF URLs', () {
      // DRM
      final drm = validateReferenceUrl('https://www.netflix.com/watch/81234567');
      expect(drm.isValid, isFalse);
      expect(drm.isDRM, isTrue);
      expect(drm.actionableAdvice, contains('Cannot access video at this URL. [Upload video file instead] or [Try different URL].'));

      // Geo-blocked
      final geo = validateReferenceUrl('https://hulu.com/watch/georestricted');
      expect(geo.isValid, isFalse);
      expect(geo.isGeoBlocked, isTrue);
      expect(geo.actionableAdvice, contains('Cannot access video at this URL. [Upload video file instead] or [Try different URL].'));

      // SSRF
      final ssrf = validateReferenceUrl('http://127.0.0.1:9090/admin');
      expect(ssrf.isValid, isFalse);
      expect(ssrf.errorMessage, contains('SSRF'));
    });

    // ========================================================================
    // Widget Test: AI Remix View with DRM Error Banner and Phase transitions
    // ========================================================================
    testWidgets('Widget Test: Entering DRM URL shows usable error banner with actionable advice', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: AiRemixView()));

      // Enter DRM URL
      final urlField = find.byKey(const Key('remix-url-input'));
      expect(urlField, findsOneWidget);

      await tester.enterText(urlField, 'https://www.netflix.com/watch/81234567');
      await tester.pump();

      // Error banner must appear
      final errorBox = find.byKey(const Key('url-error-box'));
      expect(errorBox, findsOneWidget);
      expect(find.textContaining('Cannot access video at this URL. [Upload video file instead] or [Try different URL].'), findsOneWidget);

      // Now enter valid URL
      await tester.enterText(urlField, 'https://tiktok.com/@creator/video/73918274912');
      await tester.pump();

      expect(find.byKey(const Key('url-error-box')), findsNothing);

      // Tap analyze button
      final analyzeBtn = find.byKey(const Key('analyze-button'));
      expect(analyzeBtn, findsOneWidget);
      await tester.tap(analyzeBtn);
      await tester.pump(const Duration(milliseconds: 400));

      // Phase 2 DNA report should be active
      expect(find.byKey(const Key('tile-pacing')), findsOneWidget);
      expect(find.byKey(const Key('tile-visual')), findsOneWidget);
      expect(find.byKey(const Key('tile-audio')), findsOneWidget);

      // Tap generate button
      final genBtn = find.byKey(const Key('generate-button'));
      expect(genBtn, findsOneWidget);
      await tester.tap(genBtn);
      await tester.pump(const Duration(milliseconds: 400));

      // Phase 3 Polish should be active with Originality Card
      expect(find.byKey(const Key('originality-card')), findsOneWidget);
      expect(find.textContaining('Originality'), findsWidgets);
    });
  });
}

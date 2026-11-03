import 'package:flutter_test/flutter_test.dart';
import 'package:creativanta_mobile/content/continuity_models.dart';
import 'package:creativanta_mobile/generated/creativanta/content/v1/continuity.pbenum.dart';

void main() {
  group('P4-07 Style Learning & Continuity Drift QA Acceptance Tests', () {
    // ------------------------------------------------------------------------
    // ACCEPTANCE TARGET 1: 15s preview quoted
    // ------------------------------------------------------------------------
    group('Acceptance Target 1: 15s Preview Quoted (RULE-M08-001, AC 1)', () {
      test('Character builder Step 3 quotes 15s duration and 5 credits', () {
        final quote = CharacterPreviewQuoteItem.calculate(
          balance: 20.0,
          durationSeconds: 15,
        );

        expect(quote.durationSeconds, equals(15));
        expect(quote.creditsRequired, equals('5.000000'));
        expect(quote.provider, equals('veo-preview-fast'));
        expect(quote.canAfford, isTrue, reason: 'Balance of 20 exceeds 5 credits cost');
      });

      test('Verifies spend authority: insufficient balance blocks preview', () {
        final quote = CharacterPreviewQuoteItem.calculate(
          balance: 3.5,
          durationSeconds: 15,
        );

        expect(quote.creditsRequired, equals('5.000000'));
        expect(quote.canAfford, isFalse, reason: 'Balance of 3.5 is less than required 5 credits');
      });

      test('Default duration clamped to 15s for preview test', () {
        final quote = CharacterPreviewQuoteItem.calculate(
          balance: 100.0,
          durationSeconds: 0,
        );
        expect(quote.durationSeconds, equals(15));
      });
    });

    // ------------------------------------------------------------------------
    // ACCEPTANCE TARGET 2: High drift blocks readiness
    // ------------------------------------------------------------------------
    group('Acceptance Target 2: High Drift Blocks Readiness (RULE-M08-005, AC 4)', () {
      test('Drift score <= 60 is within allowable tolerance', () {
        final low = DriftEvaluationResultItem.evaluate(
          assetId: 'asset-01',
          packId: 'pack-01',
          driftScore: 12.0,
        );
        expect(low.driftSeverity, equals('none'));
        expect(low.isBlocked, isFalse);

        final moderate = DriftEvaluationResultItem.evaluate(
          assetId: 'asset-02',
          packId: 'pack-01',
          driftScore: 48.0,
        );
        expect(moderate.driftSeverity, equals('moderate_drift'));
        expect(moderate.isBlocked, isFalse);
      });

      test('Drift score > 60 triggers high_drift severity and blocking violation', () {
        final high = DriftEvaluationResultItem.evaluate(
          assetId: 'asset-03',
          packId: 'pack-01',
          driftScore: 78.5,
        );

        expect(high.driftSeverity, equals('high_drift'));
        expect(high.isBlocked, isTrue);
        expect(high.violationReasons, isNotEmpty);
        expect(high.violationId, isNotNull);

        // Readiness is blocked
        final canApprove = canApproveAssetMobile(
          driftSeverity: high.driftSeverity,
          hasUnresolvedBlockingViolation: true,
        );
        expect(canApprove, isFalse, reason: 'High drift (>60) must block approval/readiness');
      });

      test('Manager override resolves blocking violation and allows approval', () {
        // Initially blocked
        final violation = ContinuityViolationItem(
          violationId: 'viol-99',
          workspaceId: 'ws-main',
          packId: 'pack-01',
          assetId: 'asset-03',
          ruleType: 'high_drift',
          severity: 'high_drift',
          detailsJson: '{"drift_score": 78.5}',
        );
        expect(violation.isResolved, isFalse);
        expect(violation.isBlocking, isTrue);

        final initialCheck = canApproveAssetMobile(
          driftSeverity: violation.severity,
          hasUnresolvedBlockingViolation: !violation.isResolved,
        );
        expect(initialCheck, isFalse);

        // Manager provides override justification
        final resolvedViolation = ContinuityViolationItem(
          violationId: violation.violationId,
          workspaceId: violation.workspaceId,
          packId: violation.packId,
          assetId: violation.assetId,
          ruleType: violation.ruleType,
          severity: violation.severity,
          detailsJson: violation.detailsJson,
          overrideReason: 'Intentional cinematic flashback lighting approved by Creative Director',
          resolvedAt: DateTime.now(),
        );

        expect(resolvedViolation.isResolved, isTrue);
        final unblockedCheck = canApproveAssetMobile(
          driftSeverity: resolvedViolation.severity,
          hasUnresolvedBlockingViolation: !resolvedViolation.isResolved,
        );
        expect(unblockedCheck, isTrue, reason: 'Manager override unblocks asset approval');
      });
    });

    // ------------------------------------------------------------------------
    // ACCEPTANCE TARGET 3: Consent withdrawal prevents new use
    // ------------------------------------------------------------------------
    group('Acceptance Target 3: Consent Withdrawal Prevents New Use (RULE-M08-002, EC-M08-001)', () {
      test('Active digital twin with verified consent is usable', () {
        final digitalTwin = CharacterItem(
          characterId: 'char-dt-1',
          workspaceId: 'ws-main',
          name: 'CEO Digital Twin',
          characterType: CharacterType.CHARACTER_TYPE_DIGITAL_TWIN,
          isDefault: true,
          consentVerified: true,
          consentRecordId: 'consent-rec-01',
          status: CharacterStatus.CHARACTER_STATUS_READY,
        );

        expect(digitalTwin.canGenerate, isTrue);
      });

      test('Consent revocation immediately invalidates digital twin use', () {
        final consent = ConsentRecordItem(
          consentId: 'consent-rec-01',
          userId: 'user-spokesperson',
          workspaceId: 'ws-main',
          consentType: 'digital_twin_likeness',
          version: '1.0',
          granted: false, // Revoked!
          faceMatchVerified: true,
          revokedAt: DateTime.now(),
          revokedReason: 'Talent contract terminated',
        );

        expect(consent.isValid, isFalse, reason: 'Revoked consent is immediately invalid');

        // Digital twin model reflecting revocation
        final revokedTwin = CharacterItem(
          characterId: 'char-dt-1',
          workspaceId: 'ws-main',
          name: 'CEO Digital Twin',
          characterType: CharacterType.CHARACTER_TYPE_DIGITAL_TWIN,
          isDefault: true,
          consentVerified: false, // Cascade invalidated
          consentRecordId: consent.consentId,
          status: CharacterStatus.CHARACTER_STATUS_READY,
        );

        expect(revokedTwin.canGenerate, isFalse,
            reason: 'Digital twin with revoked consent MUST block generation (Target 3)');
      });

      test('Standard AI character does not require likeness consent', () {
        final aiChar = CharacterItem(
          characterId: 'char-ai-1',
          workspaceId: 'ws-main',
          name: 'Virtual Host Maya',
          characterType: CharacterType.CHARACTER_TYPE_AI_GENERATED,
          isDefault: false,
          consentVerified: false,
          status: CharacterStatus.CHARACTER_STATUS_READY,
        );

        expect(aiChar.canGenerate, isTrue);
      });
    });

    // ------------------------------------------------------------------------
    // EF-07: Style Extraction & Transfer
    // ------------------------------------------------------------------------
    group('EF-07: Style Extraction & Transfer Models (Screen W032)', () {
      test('StyleElementsItem encapsulates 7 core aesthetic parameters', () {
        const elements = StyleElementsItem(
          colorGrading: 'Moody cinematic Teal & Orange with lifted blacks',
          lighting: 'Dramatic high-contrast rim light, soft warm fill',
          cameraMovement: 'Smooth slow dolly-in with subtle handheld parallax',
          paceCadence: 'Deliberate rhythmic cutting at beat drops',
          composition: 'Golden ratio rule of thirds, clean negative headroom',
          textureGrain: 'Fine 35mm film grain, gentle anamorphic lens flare',
          audioAtmosphere: 'Subtle ambient reverb with warm proximity effect',
        );

        expect(elements.colorGrading, contains('Teal & Orange'));
        expect(elements.lighting, contains('high-contrast'));
        expect(elements.cameraMovement, contains('dolly-in'));
        expect(elements.paceCadence, contains('rhythmic'));
        expect(elements.composition, contains('Golden ratio'));
        expect(elements.textureGrain, contains('35mm film grain'));
        expect(elements.audioAtmosphere, contains('proximity effect'));
      });

      test('StylePackItem captures reference videos and ready status', () {
        final pack = StylePackItem(
          stylePackId: 'spk-nordic-01',
          workspaceId: 'ws-main',
          name: 'Nordic Minimalist Aesthetic',
          description: 'Desaturated tones for scandinavian furniture promos',
          elements: const StyleElementsItem(
            colorGrading: 'Cool desaturated scandinavian palette',
            lighting: 'Soft diffused overcast window daylight',
            cameraMovement: 'Static locked-off architectural shots',
            paceCadence: 'Slow meditative pacing',
            composition: 'Symmetrical center-weighted framing',
            textureGrain: 'Clean digital with zero noise',
            audioAtmosphere: 'Quiet room tone with soft piano chords',
          ),
          sourceVideoUrls: const [
            'https://storage.creativanta.io/ref/nordic_1.mp4',
            'https://storage.creativanta.io/ref/nordic_2.mp4',
          ],
          status: 'ready',
        );

        expect(pack.stylePackId, equals('spk-nordic-01'));
        expect(pack.sourceVideoUrls.length, equals(2));
        expect(pack.status, equals('ready'));
      });
    });
  });
}

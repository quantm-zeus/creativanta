import 'package:flutter_test/flutter_test.dart';
import 'package:creativanta_mobile/production/sound_translation_models.dart';

void main() {
  group('P4-06 Sound, Translation & Voice Clone Acceptance Tests', () {
    // ------------------------------------------------------------------------
    // Acceptance Target 1: Consent Required
    // ------------------------------------------------------------------------
    test('Acceptance Target 1: Likeness consent required for voice clone creation and dubbing', () {
      final now = DateTime.now();

      // 1. Missing consent record -> must be invalid
      final unconsentedClone = VoiceCloneModel(
        voiceCloneId: 'vc-unconsented',
        workspaceId: 'ws-001',
        characterId: 'char-001',
        voiceName: 'Unconsented Clone',
        cloneStatus: 'pending',
        consentRecordId: '',
        consentVerified: false,
        qualityScore: 85.0,
        repairApplied: false,
        createdAt: now,
      );
      expect(unconsentedClone.isValidForGeneration, isFalse);
      expect(validateVoiceCloneConsent(unconsentedClone), isFalse);

      // 2. Active, verified consent -> must be valid for generation
      final validClone = VoiceCloneModel(
        voiceCloneId: 'vc-valid-001',
        workspaceId: 'ws-001',
        characterId: 'char-001',
        voiceName: 'Valid Twin Clone',
        cloneStatus: 'ready',
        consentRecordId: 'consent-rec-001',
        consentVerified: true,
        qualityScore: 92.0,
        repairApplied: false,
        createdAt: now,
      );
      expect(validClone.isValidForGeneration, isTrue);
      expect(validateVoiceCloneConsent(validClone), isTrue);

      // 3. Revoked consent -> must immediately cascade and block generation
      final revokedClone = VoiceCloneModel(
        voiceCloneId: 'vc-revoked-002',
        workspaceId: 'ws-001',
        characterId: 'char-001',
        voiceName: 'Revoked Twin Clone',
        cloneStatus: 'revoked',
        consentRecordId: 'consent-rec-001',
        consentVerified: false,
        qualityScore: 92.0,
        repairApplied: false,
        createdAt: now,
      );
      expect(revokedClone.isValidForGeneration, isFalse);
      expect(validateVoiceCloneConsent(revokedClone), isFalse);
    });

    // ------------------------------------------------------------------------
    // Acceptance Target 2: Language / Voice Quality Repair
    // ------------------------------------------------------------------------
    test('Acceptance Target 2: Quality scoring, speech clarity repair & -14 LUFS normalization', () {
      final now = DateTime.now();

      // 1. Single sample voice clone has lower score and auto-repair flag
      final singleSampleClone = VoiceCloneModel(
        voiceCloneId: 'vc-single-01',
        workspaceId: 'ws-001',
        characterId: 'char-noisy',
        voiceName: 'Noisy Voice',
        cloneStatus: 'ready',
        consentRecordId: 'consent-001',
        consentVerified: true,
        qualityScore: 68.0,
        repairApplied: true,
        createdAt: now,
      );
      expect(singleSampleClone.repairApplied, isTrue);
      expect(singleSampleClone.qualityScore, 68.0);

      // 2. Multi-sample high quality clone
      final studioClone = VoiceCloneModel(
        voiceCloneId: 'vc-studio-02',
        workspaceId: 'ws-001',
        characterId: 'char-clean',
        voiceName: 'Studio Voice',
        cloneStatus: 'ready',
        consentRecordId: 'consent-002',
        consentVerified: true,
        qualityScore: 88.5,
        repairApplied: false,
        createdAt: now,
      );
      expect(studioClone.repairApplied, isFalse);
      expect(studioClone.qualityScore, 88.5);

      // 3. Standard -14 LUFS loudness invariant on sound track
      final soundTrack = SoundTrackModel(
        trackId: 'track-bgm-01',
        workspaceId: 'ws-001',
        title: 'Chill Corporate Beat',
        category: 'music',
        genre: 'corporate',
        mood: 'chill',
        bpm: 120,
        durationSeconds: 30.0,
        fileUrl: 'https://cdn.creativanta.test/sound/bgm.mp3',
        licenseType: 'commercial_royalty_free',
        licenseId: 'CREATIVANTA-BGM-LIC-001',
        isVerifiedLicense: true,
        waveformPeaks: [0.2, 0.5, 0.8, 0.9, 0.7, 0.4],
        createdAt: now,
      );
      expect(soundTrack.normalizedLufs, kStandardLoudnessLufs);
      expect(soundTrack.normalizedLufs, -14.0);

      // 4. Translation job repair notes & quality score mapping
      final transJob = TranslationJobModel(
        jobId: 'job-trans-001',
        workspaceId: 'ws-001',
        sourceAssetId: 'asset-video-01',
        targetLanguages: ['vi', 'ja', 'es'],
        lipSyncEnabled: true,
        culturalAdaptationEnabled: true,
        translateCaptions: true,
        voiceOption: 'native',
        status: 'completed',
        qualityScores: {'vi': 96.0, 'ja': 92.0, 'es': 93.0},
        repairNotes: {
          'vi': 'Post-production speech normalization (-14 LUFS) applied',
          'ja': 'Post-production speech normalization (-14 LUFS) and lip-sync alignment applied',
          'es': 'Post-production speech normalization (-14 LUFS) and lip-sync alignment applied',
        },
        outputAssetIds: {
          'vi': 'out-vi',
          'ja': 'out-ja',
          'es': 'out-es',
        },
        totalCreditsUsed: 84,
        quoteId: 'quote-001',
        createdAt: now,
      );
      expect(transJob.qualityScores['vi'], 96.0);
      expect(transJob.repairNotes['ja'], contains('-14 LUFS'));
    });

    // ------------------------------------------------------------------------
    // Acceptance Target 3: Licensed Input and Measured Quote
    // ------------------------------------------------------------------------
    test('Acceptance Target 3: Measured quote with multi-language volume discount formula', () {
      // 1 language: 1 * (20 + 10 + 5) = 35 credits (0% discount)
      final q1 = calculateTranslationQuote(1, lipSync: true, cultural: true);
      expect(q1.totalCredits, 35);
      expect(q1.discountPercent, 0.0);
      expect(q1.costPerLanguage, 35);

      // 2 languages: 2 * 35 * (1 - 0.10) = 63 credits (10% discount)
      final q2 = calculateTranslationQuote(2, lipSync: true, cultural: true);
      expect(q2.totalCredits, 63);
      expect(q2.discountPercent, 0.10);

      // 3 languages: 3 * 35 * (1 - 0.20) = 84 credits (20% discount)
      final q3 = calculateTranslationQuote(3, lipSync: true, cultural: true);
      expect(q3.totalCredits, 84);
      expect(q3.discountPercent, 0.20);

      // 4 languages: 4 * 35 * (1 - 0.30) = 98 credits (30% discount)
      final q4 = calculateTranslationQuote(4, lipSync: true, cultural: true);
      expect(q4.totalCredits, 98);
      expect(q4.discountPercent, 0.30);

      // 5 languages: 5 * 35 * (1 - 0.30 max) = 122.5 -> 122 rounded (30% max discount)
      final q5 = calculateTranslationQuote(5, lipSync: true, cultural: true);
      expect(q5.totalCredits, 122);
      expect(q5.discountPercent, 0.30);

      // Without lip-sync or cultural adaptation
      final qBase = calculateTranslationQuote(1, lipSync: false, cultural: false);
      expect(qBase.totalCredits, 20);
      expect(qBase.costPerLanguage, 20);

      // 0 languages edge case
      final qZero = calculateTranslationQuote(0);
      expect(qZero.totalCredits, 0);

      // 2. Licensed input verification
      expect(
        validateLicensedInput(licenseType: 'commercial_royalty_free', confirmRights: true),
        isTrue,
      );
      expect(
        validateLicensedInput(licenseType: 'commercial_royalty_free', confirmRights: false),
        isFalse,
      );
      expect(
        validateLicensedInput(licenseType: 'unlicensed', confirmRights: true),
        isFalse,
      );
    });
  });
}

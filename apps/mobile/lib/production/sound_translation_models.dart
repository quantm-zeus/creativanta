/// Sound, Music, Voice Clone & Localization Models (P4-06: EF-05 & EF-06)
library;

const double kStandardLoudnessLufs = -14.0;

/// Sound Track model for AI Sound Studio (EF-06 / W028)
class SoundTrackModel {
  final String trackId;
  final String workspaceId;
  final String title;
  final String category; // 'music' | 'sfx' | 'ambient'
  final String genre;
  final String mood;
  final int bpm;
  final double durationSeconds;
  final String fileUrl;
  final String licenseType;
  final String licenseId;
  final bool isVerifiedLicense;
  final List<double> waveformPeaks;
  final double normalizedLufs;
  final DateTime createdAt;

  const SoundTrackModel({
    required this.trackId,
    required this.workspaceId,
    required this.title,
    required this.category,
    required this.genre,
    required this.mood,
    required this.bpm,
    required this.durationSeconds,
    required this.fileUrl,
    required this.licenseType,
    required this.licenseId,
    required this.isVerifiedLicense,
    required this.waveformPeaks,
    this.normalizedLufs = kStandardLoudnessLufs,
    required this.createdAt,
  });
}

/// Voice Clone Record for Digital Twin & Dubbing (EF-05 / M08)
class VoiceCloneModel {
  final String voiceCloneId;
  final String workspaceId;
  final String characterId;
  final String voiceName;
  final String cloneStatus; // 'ready' | 'pending' | 'revoked'
  final String consentRecordId;
  final bool consentVerified;
  final double qualityScore;
  final bool repairApplied;
  final DateTime createdAt;

  const VoiceCloneModel({
    required this.voiceCloneId,
    required this.workspaceId,
    required this.characterId,
    required this.voiceName,
    required this.cloneStatus,
    required this.consentRecordId,
    required this.consentVerified,
    required this.qualityScore,
    required this.repairApplied,
    required this.createdAt,
  });

  bool get isValidForGeneration =>
      cloneStatus == 'ready' &&
      consentVerified &&
      consentRecordId.isNotEmpty;
}

/// Translation Job Model for Video Localization (EF-05 / W033)
class TranslationJobModel {
  final String jobId;
  final String workspaceId;
  final String sourceAssetId;
  final List<String> targetLanguages;
  final bool lipSyncEnabled;
  final bool culturalAdaptationEnabled;
  final bool translateCaptions;
  final String voiceOption; // 'native' | 'cloned'
  final String? voiceCloneId;
  final String status; // 'queued' | 'processing' | 'completed' | 'failed'
  final Map<String, double> qualityScores;
  final Map<String, String> repairNotes;
  final Map<String, String> outputAssetIds;
  final int totalCreditsUsed;
  final String quoteId;
  final DateTime createdAt;

  const TranslationJobModel({
    required this.jobId,
    required this.workspaceId,
    required this.sourceAssetId,
    required this.targetLanguages,
    required this.lipSyncEnabled,
    required this.culturalAdaptationEnabled,
    required this.translateCaptions,
    required this.voiceOption,
    this.voiceCloneId,
    required this.status,
    required this.qualityScores,
    required this.repairNotes,
    required this.outputAssetIds,
    required this.totalCreditsUsed,
    required this.quoteId,
    required this.createdAt,
  });
}

/// Result of measured quote calculation for translation
class TranslationQuoteResult {
  final int languagesCount;
  final bool lipSync;
  final bool cultural;
  final int totalCredits;
  final double discountPercent;
  final int costPerLanguage;

  const TranslationQuoteResult({
    required this.languagesCount,
    required this.lipSync,
    required this.cultural,
    required this.totalCredits,
    required this.discountPercent,
    required this.costPerLanguage,
  });
}

/// Multi-language volume discount formula
/// Formula per screen_web_studio_translation.md §5:
/// base = 20 cr/lang, lip_sync = +10 cr/lang, cultural = +5 cr/lang
/// discount = 10% per additional language (max 30%)
/// total = round(languages * (base + lip_sync + cultural) * (1 - discount))
TranslationQuoteResult calculateTranslationQuote(
  int languagesCount, {
  bool lipSync = true,
  bool cultural = true,
}) {
  if (languagesCount <= 0) {
    return const TranslationQuoteResult(
      languagesCount: 0,
      lipSync: false,
      cultural: false,
      totalCredits: 0,
      discountPercent: 0.0,
      costPerLanguage: 0,
    );
  }

  int costPerLang = 20;
  if (lipSync) costPerLang += 10;
  if (cultural) costPerLang += 5;

  double discount = 0.0;
  if (languagesCount > 1) {
    discount = (languagesCount - 1) * 0.10;
    if (discount > 0.30) {
      discount = 0.30;
    }
  }

  final double gross = (languagesCount * costPerLang).toDouble();
  final double net = gross * (1.0 - discount);
  final int total = net.round();

  return TranslationQuoteResult(
    languagesCount: languagesCount,
    lipSync: lipSync,
    cultural: cultural,
    totalCredits: total,
    discountPercent: discount,
    costPerLanguage: costPerLang,
  );
}

/// Acceptance Target 1: Consent validation for voice clone usage
bool validateVoiceCloneConsent(VoiceCloneModel clone) {
  if (clone.consentRecordId.isEmpty) {
    return false;
  }
  if (!clone.consentVerified) {
    return false;
  }
  if (clone.cloneStatus == 'revoked') {
    return false;
  }
  return true;
}

/// Acceptance Target 3: Licensed input validation for sound generation
bool validateLicensedInput({
  required String licenseType,
  required bool confirmRights,
}) {
  if (!confirmRights) {
    return false;
  }
  if (licenseType == 'unlicensed' || licenseType == 'prohibited') {
    return false;
  }
  return true;
}

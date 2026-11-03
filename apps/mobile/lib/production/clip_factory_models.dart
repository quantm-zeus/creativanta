// Clip Factory Mobile Domain Models (Screen M015 · Module M07)
// Canonical Sources: docs/02_features/production/ai_video_studio.md §Mode 2
//                    docs/04_contracts/database_schema.md §22.3

const String kCanonicalPatternOnlyBadge = '⚠️ Pattern-only';
const double kCanonicalAudioLufs = -14.0;

class ViralityScoreModel {
  final double engagementPrediction; // 0.0 - 100.0
  final double hookStrength;         // 0.0 - 100.0
  final double pacingScore;          // 0.0 - 100.0
  final double audioEnergy;          // 0.0 - 100.0
  final double contentRelevance;     // 0.0 - 100.0 (0.0 when hasTrendData is false)
  final double compositeScore;       // 0.0 - 100.0
  final bool hasTrendData;
  final String scoreBadge;

  const ViralityScoreModel({
    required this.engagementPrediction,
    required this.hookStrength,
    required this.pacingScore,
    required this.audioEnergy,
    required this.contentRelevance,
    required this.compositeScore,
    required this.hasTrendData,
    required this.scoreBadge,
  });

  ViralityScoreModel copyWith({
    double? engagementPrediction,
    double? hookStrength,
    double? pacingScore,
    double? audioEnergy,
    double? contentRelevance,
    double? compositeScore,
    bool? hasTrendData,
    String? scoreBadge,
  }) {
    return ViralityScoreModel(
      engagementPrediction: engagementPrediction ?? this.engagementPrediction,
      hookStrength: hookStrength ?? this.hookStrength,
      pacingScore: pacingScore ?? this.pacingScore,
      audioEnergy: audioEnergy ?? this.audioEnergy,
      contentRelevance: contentRelevance ?? this.contentRelevance,
      compositeScore: compositeScore ?? this.compositeScore,
      hasTrendData: hasTrendData ?? this.hasTrendData,
      scoreBadge: scoreBadge ?? this.scoreBadge,
    );
  }
}

class ClipProposalModel {
  final String clipId;
  final double startS;
  final double endS;
  final double durationS;
  final String title;
  final String hookType; // 'visual_hook' or 'speech_hook'
  final String hookDescription;
  final ViralityScoreModel viralityScore;
  final String transcriptSnippet;
  final bool isSelected;

  const ClipProposalModel({
    required this.clipId,
    required this.startS,
    required this.endS,
    required this.durationS,
    required this.title,
    required this.hookType,
    required this.hookDescription,
    required this.viralityScore,
    this.transcriptSnippet = '',
    this.isSelected = true,
  });

  ClipProposalModel copyWith({
    String? clipId,
    double? startS,
    double? endS,
    double? durationS,
    String? title,
    String? hookType,
    String? hookDescription,
    ViralityScoreModel? viralityScore,
    String? transcriptSnippet,
    bool? isSelected,
  }) {
    return ClipProposalModel(
      clipId: clipId ?? this.clipId,
      startS: startS ?? this.startS,
      endS: endS ?? this.endS,
      durationS: durationS ?? this.durationS,
      title: title ?? this.title,
      hookType: hookType ?? this.hookType,
      hookDescription: hookDescription ?? this.hookDescription,
      viralityScore: viralityScore ?? this.viralityScore,
      transcriptSnippet: transcriptSnippet ?? this.transcriptSnippet,
      isSelected: isSelected ?? this.isSelected,
    );
  }
}

class ClipVariantConfigModel {
  final String clipId;
  final List<String> targetRatios;
  final bool subtitleFirst;
  final String ctaText;
  final bool generateHighlightReel;
  final List<String> targetPlatforms;

  const ClipVariantConfigModel({
    required this.clipId,
    required this.targetRatios,
    this.subtitleFirst = true,
    this.ctaText = '',
    this.generateHighlightReel = false,
    this.targetPlatforms = const ['tiktok', 'reels', 'shorts'],
  });

  ClipVariantConfigModel copyWith({
    String? clipId,
    List<String>? targetRatios,
    bool? subtitleFirst,
    String? ctaText,
    bool? generateHighlightReel,
    List<String>? targetPlatforms,
  }) {
    return ClipVariantConfigModel(
      clipId: clipId ?? this.clipId,
      targetRatios: targetRatios ?? this.targetRatios,
      subtitleFirst: subtitleFirst ?? this.subtitleFirst,
      ctaText: ctaText ?? this.ctaText,
      generateHighlightReel: generateHighlightReel ?? this.generateHighlightReel,
      targetPlatforms: targetPlatforms ?? this.targetPlatforms,
    );
  }
}

class ProcessedClipOutputModel {
  final String outputAssetId;
  final String clipId;
  final String ratio;
  final String title;
  final double durationS;
  final String videoUrl;
  final String lineageJson;
  final double audioLufs;

  const ProcessedClipOutputModel({
    required this.outputAssetId,
    required this.clipId,
    required this.ratio,
    required this.title,
    required this.durationS,
    required this.videoUrl,
    required this.lineageJson,
    this.audioLufs = kCanonicalAudioLufs,
  });
}

/// Acceptance Target 2: Virality score calculation with 5 weights.
/// If hasTrendData is false, contentRelevance MUST be 0.0 and scoreBadge MUST be "⚠️ Pattern-only".
ViralityScoreModel calculateViralityScore({
  required double engagement,
  required double hook,
  required double pacing,
  required double audio,
  required double relevance,
  required bool hasTrendData,
}) {
  final clampedEng = engagement.clamp(0.0, 100.0);
  final clampedHook = hook.clamp(0.0, 100.0);
  final clampedPacing = pacing.clamp(0.0, 100.0);
  final clampedAudio = audio.clamp(0.0, 100.0);
  final clampedRel = hasTrendData ? relevance.clamp(0.0, 100.0) : 0.0;

  final composite = 0.30 * clampedEng +
      0.25 * clampedHook +
      0.20 * clampedPacing +
      0.15 * clampedAudio +
      0.10 * clampedRel;

  final roundedComposite = (composite * 10).round() / 10.0;

  String badge;
  if (!hasTrendData) {
    badge = kCanonicalPatternOnlyBadge;
  } else if (roundedComposite >= 85.0) {
    badge = '🔥 Viral Candidate';
  } else if (roundedComposite >= 70.0) {
    badge = '⚡ High Potential';
  } else {
    badge = 'Standard';
  }

  return ViralityScoreModel(
    engagementPrediction: clampedEng,
    hookStrength: clampedHook,
    pacingScore: clampedPacing,
    audioEnergy: clampedAudio,
    contentRelevance: clampedRel,
    compositeScore: roundedComposite,
    hasTrendData: hasTrendData,
    scoreBadge: badge,
  );
}

/// Acceptance Target 1 (EC-M07-C01):
/// When speech is absent or transcript snippet is empty, system falls back to
/// visual scene detection + beat analysis.
Map<String, dynamic> deriveHookStrategy({
  required bool hasSpeech,
  String? transcriptSnippet,
  String visualBeatPattern = 'Visual beat & scene motion detection',
}) {
  final cleanSnippet = (transcriptSnippet ?? '').trim();
  if (!hasSpeech || cleanSnippet.isEmpty) {
    return {
      'hookType': 'visual_hook',
      'hookDescription': 'Visual hook: $visualBeatPattern',
      'hookStrengthScore': 82.0,
    };
  }

  final truncated = cleanSnippet.length > 40
      ? '${cleanSnippet.substring(0, 37)}...'
      : cleanSnippet;

  return {
    'hookType': 'speech_hook',
    'hookDescription': 'Speech hook: "$truncated"',
    'hookStrengthScore': 88.0,
  };
}

/// Acceptance Target 3: Source lineage dictionary builder.
Map<String, dynamic> buildClipLineagePayload({
  required String sourceAssetId,
  required String clipId,
  required double startS,
  required double endS,
  required String ratio,
  required bool hasTrendData,
  String? ctaText,
}) {
  return {
    'parent_id': sourceAssetId,
    'source_asset_id': sourceAssetId,
    'clip_id': clipId,
    'derivative_type': 'clip',
    'aspect_ratio': ratio,
    'timecodes': {
      'start_s': startS,
      'end_s': endS,
      'duration_s': ((endS - startS) * 100).round() / 100.0,
    },
    'audio_lufs': kCanonicalAudioLufs,
    'audio_normalized': true,
    'trend_data_included': hasTrendData,
    'cta_overlay': (ctaText != null && ctaText.trim().isNotEmpty) ? ctaText.trim() : null,
    'extracted_at': DateTime.now().toUtc().toIso8601String(),
  };
}

/// Concurrency limits by workspace tier per EC-M07-004
int getTierMaxConcurrentClipJobs(String tier) {
  switch (tier.toLowerCase()) {
    case 'free':
      return 1;
    case 'starter':
      return 2;
    case 'pro':
      return 5;
    case 'business':
    case 'enterprise':
      return 10;
    default:
      return 2;
  }
}

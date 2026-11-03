// Quick Edit Mobile Domain Models (Screen M014 · Module M07)
// Canonical Sources: docs/02_features/production/ai_video_studio.md
//                    docs/03_screens/mobile/screen_mobile_studio_quick_edit.md

class QuickEditWordModel {
  final String wordId;
  final String text;
  final int startMs;
  final int endMs;
  final double confidence;
  final bool isFiller;
  final bool isDeleted;

  const QuickEditWordModel({
    required this.wordId,
    required this.text,
    required this.startMs,
    required this.endMs,
    this.confidence = 0.95,
    this.isFiller = false,
    this.isDeleted = false,
  });

  QuickEditWordModel copyWith({
    String? text,
    int? startMs,
    int? endMs,
    double? confidence,
    bool? isFiller,
    bool? isDeleted,
  }) {
    return QuickEditWordModel(
      wordId: wordId,
      text: text ?? this.text,
      startMs: startMs ?? this.startMs,
      endMs: endMs ?? this.endMs,
      confidence: confidence ?? this.confidence,
      isFiller: isFiller ?? this.isFiller,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }
}

class QuickEditPauseModel {
  final int startMs;
  final int endMs;
  final int durationMs;

  const QuickEditPauseModel({
    required this.startMs,
    required this.endMs,
    required this.durationMs,
  });
}

class QuickEditAddonsModel {
  final bool autoCaptions;
  final String captionStyle; // bounce, karaoke, highlight, typewriter
  final bool addHook;
  final String hookType; // question, shock, story, pov, listicle, contrast
  final bool beatSync;
  final String soundGenre; // chill, upbeat, electronic, dramatic, acoustic, tech_pulse
  final bool bRoll;
  final String platformPreset; // none, tiktok, youtube_shorts, reels
  final bool audioEnhancement;
  final double targetLufs; // -14.0 LUFS
  final String reframeRatio; // 9:16, 16:9, 1:1

  const QuickEditAddonsModel({
    this.autoCaptions = true,
    this.captionStyle = 'bounce',
    this.addHook = false,
    this.hookType = 'question',
    this.beatSync = false,
    this.soundGenre = 'chill',
    this.bRoll = false,
    this.platformPreset = 'none',
    this.audioEnhancement = false,
    this.targetLufs = -14.0,
    this.reframeRatio = '9:16',
  });

  QuickEditAddonsModel copyWith({
    bool? autoCaptions,
    String? captionStyle,
    bool? addHook,
    String? hookType,
    bool? beatSync,
    String? soundGenre,
    bool? bRoll,
    String? platformPreset,
    bool? audioEnhancement,
    double? targetLufs,
    String? reframeRatio,
  }) {
    return QuickEditAddonsModel(
      autoCaptions: autoCaptions ?? this.autoCaptions,
      captionStyle: captionStyle ?? this.captionStyle,
      addHook: addHook ?? this.addHook,
      hookType: hookType ?? this.hookType,
      beatSync: beatSync ?? this.beatSync,
      soundGenre: soundGenre ?? this.soundGenre,
      bRoll: bRoll ?? this.bRoll,
      platformPreset: platformPreset ?? this.platformPreset,
      audioEnhancement: audioEnhancement ?? this.audioEnhancement,
      targetLufs: targetLufs ?? this.targetLufs,
      reframeRatio: reframeRatio ?? this.reframeRatio,
    );
  }
}

/// Calculate credit cost: 15 base + add-ons
int calculateMobileQuickEditCredits(QuickEditAddonsModel addons) {
  int total = 15; // Base quick edit
  if (addons.addHook) total += 3;
  if (addons.beatSync) total += 5;
  if (addons.bRoll) total += 10;
  if (addons.platformPreset != 'none') total += 3;
  if (addons.audioEnhancement) total += 3;
  return total;
}

const Set<String> kVietnameseFillers = {
  'ừm', 'à', 'ờ', 'kiểu', 'thì là', 'như là', 'thì', 'là', 'nói chung là', 'cái này',
  'um', 'uh', 'like', 'you know', 'basically'
};

bool checkIsFiller(String text) {
  final clean = text.toLowerCase().replaceAll(RegExp(r'[^\w\sàáảãạăằắẳẵặâầấẩẫậèéẻẽẹêềếểễệìíỉĩịòóỏõọôồốổỗộơờớởỡợùúủũụưừứửữựỳýỷỹỵđ]'), '').trim();
  return kVietnameseFillers.contains(clean);
}

/// Repair transcript word per EC-M07-Q01.
/// Returns updated words or throws error string with fallback.
({List<QuickEditWordModel> words, String? error, bool fallbackMode}) repairMobileWordTranscript(
  List<QuickEditWordModel> original,
  String wordId,
  String newText,
  int? newStartMs,
  int? newEndMs,
) {
  final updated = original.map((w) {
    if (w.wordId != wordId) return w;
    return w.copyWith(
      text: newText,
      startMs: newStartMs ?? w.startMs,
      endMs: newEndMs ?? w.endMs,
      isFiller: checkIsFiller(newText),
    );
  }).toList();

  // Validate alignment order
  for (int i = 0; i < updated.length; i++) {
    final w = updated[i];
    if (w.startMs >= w.endMs) {
      return (
        words: updated,
        error: 'Auto-alignment failed. [Try segment mode] or [Manual cut].',
        fallbackMode: true,
      );
    }
    if (i > 0 && w.startMs < updated[i - 1].startMs) {
      return (
        words: updated,
        error: 'Auto-alignment failed. [Try segment mode] or [Manual cut].',
        fallbackMode: true,
      );
    }
  }

  return (words: updated, error: null, fallbackMode: false);
}

/// Compute retained timeline and prove zero cumulative drift
({List<({int startMs, int endMs, int durationMs})> segments, int timeSavedMs, int finalDurationMs, bool hasZeroDrift})
    computeMobileRetainedTimeline(
  int totalDurationMs,
  List<QuickEditWordModel> words,
  List<QuickEditPauseModel> pauses,
  bool removeFillers,
  bool removePauses,
) {
  final rawCuts = <({int startMs, int endMs})>[];

  for (final w in words) {
    if (w.isDeleted || (removeFillers && w.isFiller)) {
      rawCuts.add((startMs: w.startMs, endMs: w.endMs));
    }
  }

  if (removePauses) {
    for (final p in pauses) {
      rawCuts.add((startMs: p.startMs, endMs: p.endMs));
    }
  }

  if (rawCuts.isEmpty) {
    return (
      segments: [(startMs: 0, endMs: totalDurationMs, durationMs: totalDurationMs)],
      timeSavedMs: 0,
      finalDurationMs: totalDurationMs,
      hasZeroDrift: true,
    );
  }

  // Sort and coalesce
  rawCuts.sort((a, b) => a.startMs.compareTo(b.startMs));
  final coalesced = <({int startMs, int endMs})>[];
  var current = rawCuts[0];

  for (int i = 1; i < rawCuts.length; i++) {
    final next = rawCuts[i];
    if (next.startMs <= current.endMs + 80) {
      current = (
        startMs: current.startMs,
        endMs: next.endMs > current.endMs ? next.endMs : current.endMs,
      );
    } else {
      coalesced.add(current);
      current = next;
    }
  }
  coalesced.add(current);

  // Invert cuts
  final segments = <({int startMs, int endMs, int durationMs})>[];
  int cursor = 0;
  int timeSavedMs = 0;

  for (final cut in coalesced) {
    final cStart = cut.startMs.clamp(0, totalDurationMs);
    final cEnd = cut.endMs.clamp(0, totalDurationMs);
    if (cStart >= cEnd) continue;

    if (cStart > cursor) {
      segments.add((
        startMs: cursor,
        endMs: cStart,
        durationMs: cStart - cursor,
      ));
    }
    timeSavedMs += (cEnd - cStart);
    cursor = cEnd;
  }

  if (cursor < totalDurationMs) {
    segments.add((
      startMs: cursor,
      endMs: totalDurationMs,
      durationMs: totalDurationMs - cursor,
    ));
  }

  final finalDurationMs = totalDurationMs - timeSavedMs;
  final sumRetained = segments.fold(0, (acc, s) => acc + s.durationMs);
  final hasZeroDrift = sumRetained == finalDurationMs && (sumRetained + timeSavedMs == totalDurationMs);

  return (
    segments: segments,
    timeSavedMs: timeSavedMs,
    finalDurationMs: finalDurationMs,
    hasZeroDrift: hasZeroDrift,
  );
}

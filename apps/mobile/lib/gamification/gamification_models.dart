// Creativanta Mobile Gamification Models & Domain Logic (M038)
// Upstream: docs/02_features/platform/gamification.md
// Screen: docs/03_screens/mobile/screen_mobile_gamification.md
// Deliverables: EF-11 (Creator Gamification) & EF-07A (Style Template Sharing)

import 'dart:convert';

// ---------------------------------------------------------------------------
// 1. Level Progression & Thresholds (EF-11)
// ---------------------------------------------------------------------------

class MobileLevelMilestone {
  final int level;
  final int xpRequired;
  final String title;

  const MobileLevelMilestone({
    required this.level,
    required this.xpRequired,
    required this.title,
  });
}

const List<MobileLevelMilestone> canonicalLevelMilestones = [
  MobileLevelMilestone(level: 1, xpRequired: 0, title: 'Tập sự (Novice Creator)'),
  MobileLevelMilestone(level: 5, xpRequired: 100, title: 'Sáng tạo trẻ (Rising Creator)'),
  MobileLevelMilestone(level: 10, xpRequired: 500, title: 'Content Pro'),
  MobileLevelMilestone(level: 20, xpRequired: 2000, title: 'Chuyên gia nội dung (Master Storyteller)'),
  MobileLevelMilestone(level: 50, xpRequired: 25000, title: 'Huyền thoại sáng tạo (Creative Legend)'),
];

int getMobileXPForLevel(int level) {
  if (level <= 1) return 0;
  if (level > 50) level = 50;

  if (level <= 5) {
    return (level - 1) * 25;
  }
  if (level <= 10) {
    return 100 + (level - 5) * 80;
  }
  if (level <= 20) {
    return 500 + (level - 10) * 150;
  }
  return 2000 + (((level - 20) * (25000 - 2000)) ~/ 30);
}

String getMobileTitleForLevel(int level) {
  if (level >= 50) return 'Huyền thoại sáng tạo (Creative Legend)';
  if (level >= 35) return 'Đạo diễn kỹ thuật số (Digital Director)';
  if (level >= 20) return 'Chuyên gia nội dung (Master Storyteller)';
  if (level >= 10) return 'Content Pro';
  if (level >= 5) return 'Sáng tạo trẻ (Rising Creator)';
  return 'Tập sự (Novice Creator)';
}

class MobileLevelProgress {
  final int currentLevel;
  final int totalXP;
  final int currentLevelBaseXP;
  final int nextLevelXP;
  final int xpInCurrentLevel;
  final int xpNeededForNextLevel;
  final double progressPercent;
  final String title;
  final bool isMaxLevel;

  const MobileLevelProgress({
    required this.currentLevel,
    required this.totalXP,
    required this.currentLevelBaseXP,
    required this.nextLevelXP,
    required this.xpInCurrentLevel,
    required this.xpNeededForNextLevel,
    required this.progressPercent,
    required this.title,
    required this.isMaxLevel,
  });
}

MobileLevelProgress calculateMobileLevel(int totalXP) {
  final safeXP = totalXP < 0 ? 0 : totalXP;

  int currentLevel = 1;
  while (currentLevel < 50 && getMobileXPForLevel(currentLevel + 1) <= safeXP) {
    currentLevel++;
  }

  final currentLevelBaseXP = getMobileXPForLevel(currentLevel);
  final isMaxLevel = currentLevel >= 50;
  final nextLevelXP = isMaxLevel ? getMobileXPForLevel(50) : getMobileXPForLevel(currentLevel + 1);

  final xpInCurrentLevel = safeXP - currentLevelBaseXP;
  final xpNeededForNextLevel = isMaxLevel ? 0 : nextLevelXP - currentLevelBaseXP;
  final progressPercent = isMaxLevel
      ? 100.0
      : xpNeededForNextLevel > 0
          ? (xpInCurrentLevel / xpNeededForNextLevel * 100.0).clamp(0.0, 100.0)
          : 100.0;

  return MobileLevelProgress(
    currentLevel: currentLevel,
    totalXP: safeXP,
    currentLevelBaseXP: currentLevelBaseXP,
    nextLevelXP: nextLevelXP,
    xpInCurrentLevel: xpInCurrentLevel,
    xpNeededForNextLevel: xpNeededForNextLevel,
    progressPercent: progressPercent,
    title: getMobileTitleForLevel(currentLevel),
    isMaxLevel: isMaxLevel,
  );
}

// ---------------------------------------------------------------------------
// 2. Streaks, Milestones & Downtime Grace Period (RULE-GAM-001..003, EC-GAM-001)
// ---------------------------------------------------------------------------

class MobileStreakMilestone {
  final int dayCount;
  final int bonusCredits;
  final int bonusXP;
  final String badgeName;

  const MobileStreakMilestone({
    required this.dayCount,
    required this.bonusCredits,
    required this.bonusXP,
    required this.badgeName,
  });
}

const List<MobileStreakMilestone> canonicalStreakMilestones = [
  MobileStreakMilestone(dayCount: 7, bonusCredits: 10, bonusXP: 100, badgeName: 'streak_7_days'),
  MobileStreakMilestone(dayCount: 30, bonusCredits: 50, bonusXP: 500, badgeName: 'streak_30_days'),
  MobileStreakMilestone(dayCount: 90, bonusCredits: 200, bonusXP: 2000, badgeName: 'streak_90_days'),
];

class MobileStreakStatus {
  final int currentStreak;
  final int bestStreak;
  final DateTime? lastActivityAt;
  final DateTime? streakGraceUntil;
  final bool isActive;
  final bool isGraceActive;
  final MobileStreakMilestone? nextMilestone;
  final int daysToNextMilestone;
  final bool todayCompleted;

  const MobileStreakStatus({
    required this.currentStreak,
    required this.bestStreak,
    this.lastActivityAt,
    this.streakGraceUntil,
    required this.isActive,
    required this.isGraceActive,
    this.nextMilestone,
    required this.daysToNextMilestone,
    required this.todayCompleted,
  });
}

MobileStreakStatus evaluateMobileStreak({
  required int currentStreak,
  required int bestStreak,
  DateTime? lastActivityAt,
  DateTime? streakGraceUntil,
  DateTime? now,
}) {
  final currentNow = now ?? DateTime.now().toUtc();

  if (lastActivityAt == null) {
    return MobileStreakStatus(
      currentStreak: 0,
      bestStreak: bestStreak < 0 ? 0 : bestStreak,
      lastActivityAt: null,
      streakGraceUntil: null,
      isActive: false,
      isGraceActive: false,
      nextMilestone: canonicalStreakMilestones.first,
      daysToNextMilestone: 7,
      todayCompleted: false,
    );
  }

  final nowDateOnly = DateTime.utc(currentNow.year, currentNow.month, currentNow.day);
  final lastDateOnly = DateTime.utc(lastActivityAt.year, lastActivityAt.month, lastActivityAt.day);
  final diffDays = nowDateOnly.difference(lastDateOnly).inDays;
  final todayCompleted = diffDays == 0;

  bool isGraceActive = false;
  if (streakGraceUntil != null && currentNow.isBefore(streakGraceUntil)) {
    isGraceActive = true;
  }

  final isActive = diffDays <= 1 || isGraceActive;
  final effectiveStreak = isActive ? currentStreak : 0;

  MobileStreakMilestone? nextMilestone;
  for (final m in canonicalStreakMilestones) {
    if (effectiveStreak < m.dayCount) {
      nextMilestone = m;
      break;
    }
  }

  final daysToNext = nextMilestone != null ? (nextMilestone.dayCount - effectiveStreak).clamp(0, 999) : 0;

  return MobileStreakStatus(
    currentStreak: effectiveStreak,
    bestStreak: effectiveStreak > bestStreak ? effectiveStreak : bestStreak,
    lastActivityAt: lastActivityAt,
    streakGraceUntil: streakGraceUntil,
    isActive: isActive,
    isGraceActive: isGraceActive,
    nextMilestone: nextMilestone,
    daysToNextMilestone: daysToNext,
    todayCompleted: todayCompleted,
  );
}

// ---------------------------------------------------------------------------
// 3. Quests & Achievements
// ---------------------------------------------------------------------------

enum MobileQuestType { daily, weekly, monthly }

class MobileQuest {
  final String questId;
  final String title;
  final String description;
  final MobileQuestType questType;
  final int targetCount;
  final int currentProgress;
  final int xpReward;
  final int creditReward;
  final bool isCompleted;

  const MobileQuest({
    required this.questId,
    required this.title,
    required this.description,
    required this.questType,
    required this.targetCount,
    required this.currentProgress,
    required this.xpReward,
    this.creditReward = 0,
    required this.isCompleted,
  });

  double get progressRatio => targetCount > 0 ? (currentProgress / targetCount).clamp(0.0, 1.0) : 1.0;
}

enum MobileBadgeRarity { common, rare, epic, legendary }

class MobileAchievementBadge {
  final String badgeId;
  final String name;
  final String description;
  final MobileBadgeRarity rarity;
  final int xpReward;
  final bool isUnlocked;

  const MobileAchievementBadge({
    required this.badgeId,
    required this.name,
    required this.description,
    required this.rarity,
    required this.xpReward,
    required this.isUnlocked,
  });
}

const List<MobileAchievementBadge> canonicalMobileBadges = [
  MobileAchievementBadge(
    badgeId: 'first_render',
    name: '🌟 First Creation',
    description: 'Render video AI đầu tiên',
    rarity: MobileBadgeRarity.common,
    xpReward: 50,
    isUnlocked: true,
  ),
  MobileAchievementBadge(
    badgeId: 'streak_7_days',
    name: '🔥 Consistency King',
    description: 'Chuỗi 7 ngày liên tục',
    rarity: MobileBadgeRarity.rare,
    xpReward: 100,
    isUnlocked: true,
  ),
  MobileAchievementBadge(
    badgeId: 'recipe_creator',
    name: '🍳 Master Chef',
    description: 'Chia sẻ style template cho cộng đồng',
    rarity: MobileBadgeRarity.rare,
    xpReward: 150,
    isUnlocked: false,
  ),
  MobileAchievementBadge(
    badgeId: 'hundred_club',
    name: '💯 Century Club',
    description: 'Render 100 video chuẩn thương mại',
    rarity: MobileBadgeRarity.epic,
    xpReward: 500,
    isUnlocked: false,
  ),
  MobileAchievementBadge(
    badgeId: 'viral_sensation',
    name: '👑 Viral Sensation',
    description: 'Đạt cấp 50 hoặc 1M lượt xem',
    rarity: MobileBadgeRarity.legendary,
    xpReward: 2500,
    isUnlocked: false,
  ),
];

// ---------------------------------------------------------------------------
// 4. Target 2: Reward Event Replay Idempotency
// ---------------------------------------------------------------------------

class MobileRewardEvent {
  final String eventId;
  final String workspaceId;
  final String userId;
  final String sourceType;
  final int creditsEarned;
  final int xpEarned;

  const MobileRewardEvent({
    required this.eventId,
    required this.workspaceId,
    required this.userId,
    required this.sourceType,
    required this.creditsEarned,
    required this.xpEarned,
  });
}

class MobileRewardReplayResult {
  final bool isDuplicate;
  final int creditsAwarded;
  final int xpAwarded;
  final String message;

  const MobileRewardReplayResult({
    required this.isDuplicate,
    required this.creditsAwarded,
    required this.xpAwarded,
    required this.message,
  });
}

MobileRewardReplayResult evaluateMobileRewardReplay({
  required MobileRewardEvent event,
  required Set<String> processedEventIds,
}) {
  if (processedEventIds.contains(event.eventId)) {
    return MobileRewardReplayResult(
      isDuplicate: true,
      creditsAwarded: 0,
      xpAwarded: 0,
      message: 'Sự kiện ${event.eventId} đã được nhận trước đó. Replay bị từ chối.',
    );
  }

  return MobileRewardReplayResult(
    isDuplicate: false,
    creditsAwarded: event.creditsEarned,
    xpAwarded: event.xpEarned,
    message: 'Nhận thành công ${event.creditsEarned} credits và ${event.xpEarned} XP.',
  );
}

// ---------------------------------------------------------------------------
// 5. Target 4: Style Template Payload Governance Validation
// ---------------------------------------------------------------------------

class MobileStyleValidationResult {
  final bool isValid;
  final List<String> issues;

  const MobileStyleValidationResult({
    required this.isValid,
    required this.issues,
  });
}

final List<RegExp> prohibitedMobilePatterns = [
  RegExp(r'file://', caseSensitive: false),
  RegExp(r'http://localhost', caseSensitive: false),
  RegExp(r'http://127\.0\.0\.1', caseSensitive: false),
  RegExp(r'raw_footage', caseSensitive: false),
  RegExp(r'private_media_url', caseSensitive: false),
  RegExp(r'unedited_camera_roll', caseSensitive: false),
  RegExp(r'X-Amz-Credential', caseSensitive: false),
  RegExp(r'AWSAccessKeyId', caseSensitive: false),
  RegExp(r'voice_sample_url', caseSensitive: false),
  RegExp(r'voice_clone_embedding', caseSensitive: false),
  RegExp(r'biometric_voice_data', caseSensitive: false),
  RegExp(r'face_embedding', caseSensitive: false),
  RegExp(r'biometric_face_mesh', caseSensitive: false),
  RegExp(r'facial_feature_vector', caseSensitive: false),
  RegExp(r'bearer\s+[A-Za-z0-9_\-\.]{15,}', caseSensitive: false),
  RegExp(r'api[_\-]?key\s*[:=]\s*["\x27][A-Za-z0-9_\-]{15,}["\x27]', caseSensitive: false),
  RegExp(r'secret[_\-]?key\s*[:=]\s*["\x27][A-Za-z0-9_\-]{15,}["\x27]', caseSensitive: false),
];

MobileStyleValidationResult validateMobileStyleTemplate({
  required int schemaVersion,
  required String licenseNotice,
  required Map<String, dynamic> styleSettings,
}) {
  final issues = <String>[];

  if (schemaVersion < 1) {
    issues.add('schema_version phải >= 1 theo database_schema.md §27.4');
  }

  if (licenseNotice.trim().isEmpty) {
    issues.add('Style template phải có thông báo bản quyền/license notice');
  }

  if (styleSettings.isEmpty) {
    issues.add('Style template phải chứa tham số phong cách (style_settings)');
  }

  final serialized = jsonEncode(styleSettings);
  for (final pattern in prohibitedMobilePatterns) {
    if (pattern.hasMatch(serialized)) {
      issues.add('Phát hiện nội dung bị cấm (media riêng tư, sinh trắc khuôn mặt/giọng nói, hoặc API token)');
      break;
    }
  }

  return MobileStyleValidationResult(
    isValid: issues.isEmpty,
    issues: issues,
  );
}

// ---------------------------------------------------------------------------
// 6. Target 3: Cloned Tenant-Owned Style Pack
// ---------------------------------------------------------------------------

class MobileClonedStylePack {
  final String clonedPackId;
  final String destinationWorkspaceId;
  final String name;
  final Map<String, dynamic> clonedSettings;
  final Map<String, dynamic> immutableInstallAudit;

  const MobileClonedStylePack({
    required this.clonedPackId,
    required this.destinationWorkspaceId,
    required this.name,
    required this.clonedSettings,
    required this.immutableInstallAudit,
  });
}

MobileClonedStylePack cloneMobileStyleTemplateToTenant({
  required String authorRecipeId,
  required int templateVersion,
  required Map<String, dynamic> sourceSettings,
  required String destinationWorkspaceId,
  required String packName,
}) {
  final now = DateTime.now().toUtc();
  final clonedPackId = 'sp-mobile-cloned-${now.millisecondsSinceEpoch}';

  return MobileClonedStylePack(
    clonedPackId: clonedPackId,
    destinationWorkspaceId: destinationWorkspaceId,
    name: packName,
    clonedSettings: Map<String, dynamic>.from(sourceSettings),
    immutableInstallAudit: {
      'recipe_id': authorRecipeId,
      'template_version': templateVersion,
      'installed_at': now.toIso8601String(),
      'destination_workspace_id': destinationWorkspaceId,
    },
  );
}

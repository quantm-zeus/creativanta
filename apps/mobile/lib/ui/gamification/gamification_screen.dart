import 'package:flutter/material.dart';
import '../../gamification/gamification_models.dart';

/// Screen M038 — Mobile Gamification Dashboard
/// Upstream: docs/03_screens/mobile/screen_mobile_gamification.md
/// Route: /gamification
class MobileGamificationScreen extends StatefulWidget {
  final int initialTotalXP;
  final int initialCurrentStreak;
  final int initialBestStreak;
  final DateTime? initialLastActivityAt;
  final DateTime? initialStreakGraceUntil;

  const MobileGamificationScreen({
    super.key,
    this.initialTotalXP = 2840,
    this.initialCurrentStreak = 14,
    this.initialBestStreak = 21,
    this.initialLastActivityAt,
    this.initialStreakGraceUntil,
  });

  @override
  State<MobileGamificationScreen> createState() => _MobileGamificationScreenState();
}

class _MobileGamificationScreenState extends State<MobileGamificationScreen> {
  late int totalXP;
  late int currentStreak;
  late int bestStreak;
  late DateTime? lastActivityAt;
  late DateTime? streakGraceUntil;

  late MobileLevelProgress levelProgress;
  late MobileStreakStatus streakStatus;

  final Set<String> processedRewardIds = {'evt-initial-claimed'};
  String? feedbackBanner;

  final List<MobileQuest> quests = const [
    MobileQuest(
      questId: 'q1',
      title: 'Xuất bản 3 video AI',
      description: 'Render và đăng 3 clip hoàn chỉnh',
      questType: MobileQuestType.weekly,
      targetCount: 3,
      currentProgress: 2,
      xpReward: 50,
      creditReward: 5,
      isCompleted: false,
    ),
    MobileQuest(
      questId: 'q2',
      title: 'Phản hồi 10 bình luận',
      description: 'Trả lời người xem trong Unified Inbox',
      questType: MobileQuestType.daily,
      targetCount: 10,
      currentProgress: 7,
      xpReward: 30,
      creditReward: 0,
      isCompleted: false,
    ),
    MobileQuest(
      questId: 'q3',
      title: 'Phiên live đầu tiên',
      description: 'Thực hiện livestream bán hàng với AI Co-host',
      questType: MobileQuestType.monthly,
      targetCount: 1,
      currentProgress: 0,
      xpReward: 100,
      creditReward: 20,
      isCompleted: false,
    ),
  ];

  @override
  void initState() {
    super.initState();
    totalXP = widget.initialTotalXP;
    currentStreak = widget.initialCurrentStreak;
    bestStreak = widget.initialBestStreak;
    lastActivityAt = widget.initialLastActivityAt ?? DateTime.now().toUtc();
    streakGraceUntil = widget.initialStreakGraceUntil;

    _recomputeState();
  }

  void _recomputeState() {
    levelProgress = calculateMobileLevel(totalXP);
    streakStatus = evaluateMobileStreak(
      currentStreak: currentStreak,
      bestStreak: bestStreak,
      lastActivityAt: lastActivityAt,
      streakGraceUntil: streakGraceUntil,
    );
  }

  void _triggerRewardReplayTest(String eventId, int credits, int xp) {
    final event = MobileRewardEvent(
      eventId: eventId,
      workspaceId: 'ws-mobile',
      userId: 'usr-mobile',
      sourceType: 'streak_milestone',
      creditsEarned: credits,
      xpEarned: xp,
    );

    final result = evaluateMobileRewardReplay(
      event: event,
      processedEventIds: processedRewardIds,
    );

    setState(() {
      if (!result.isDuplicate) {
        processedRewardIds.add(eventId);
        totalXP += result.xpAwarded;
        _recomputeState();
        feedbackBanner = '✅ ${result.message}';
      } else {
        feedbackBanner = '⚠️ ${result.message}';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E293B),
        title: const Text(
          'Level & Thành Tích (M038)',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Level Card (ASCII Wireframe)
            _buildLevelCard(),
            const SizedBox(height: 16),

            // Feedback Banner (Replay or Action)
            if (feedbackBanner != null) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.indigoAccent),
                ),
                child: Text(
                  feedbackBanner!,
                  style: const TextStyle(color: Colors.white, fontSize: 13),
                ),
              ),
              const SizedBox(height: 16),
            ],

            // 2. Active Quests
            _buildQuestsSection(),
            const SizedBox(height: 20),

            // 3. Achievements Grid (3x3)
            _buildAchievementsSection(),
            const SizedBox(height: 20),

            // 4. Target 2 Replay Tester Button
            _buildReplayIdempotencyTester(),
          ],
        ),
      ),
    );
  }

  Widget _buildLevelCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF334155)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '⭐ Level ${levelProgress.currentLevel} "${levelProgress.title}"',
                      style: const TextStyle(
                        color: Colors.amberAccent,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'XP: ${levelProgress.totalXP} / ${levelProgress.nextLevelXP}',
                      style: const TextStyle(color: Colors.white70, fontSize: 13),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.deepOrange.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.deepOrangeAccent),
                ),
                child: Row(
                  children: [
                    const Text('🔥', style: TextStyle(fontSize: 18)),
                    const SizedBox(width: 4),
                    Text(
                      '${streakStatus.currentStreak} ngày',
                      style: const TextStyle(
                        color: Colors.orangeAccent,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Progress Bar
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: levelProgress.progressPercent / 100.0,
              minHeight: 10,
              backgroundColor: Colors.black26,
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.indigoAccent),
            ),
          ),
          const SizedBox(height: 8),

          Text(
            levelProgress.isMaxLevel
                ? 'Đã đạt cấp tối đa!'
                : 'Tiếp theo: Level ${levelProgress.currentLevel + 1} — còn ${levelProgress.xpNeededForNextLevel - levelProgress.xpInCurrentLevel} XP',
            style: const TextStyle(color: Colors.white60, fontSize: 12),
          ),
          const SizedBox(height: 8),
          Text(
            'Kỷ lục streak: ${streakStatus.bestStreak} ngày · Bonus: +20% XP hôm nay',
            style: const TextStyle(color: Colors.white54, fontSize: 11),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestsSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '🎯 Nhiệm Vụ Hoạt Động (Quests)',
            style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          ...quests.map((q) => Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            q.title,
                            style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600),
                          ),
                        ),
                        Text(
                          '+${q.xpReward} XP',
                          style: const TextStyle(color: Colors.amberAccent, fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: q.progressRatio,
                        minHeight: 6,
                        backgroundColor: Colors.black26,
                        valueColor: const AlwaysStoppedAnimation<Color>(Colors.tealAccent),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Tiến độ: ${q.currentProgress}/${q.targetCount}',
                      style: const TextStyle(color: Colors.white54, fontSize: 11),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildAchievementsSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '🏅 Huy Hiệu Thành Tích (3×3 Grid)',
            style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: canonicalMobileBadges.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 0.9,
            ),
            itemBuilder: (context, index) {
              final badge = canonicalMobileBadges[index];
              return Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: badge.isUnlocked ? const Color(0xFF334155) : const Color(0xFF0F172A),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: badge.isUnlocked ? Colors.amber.shade700 : const Color(0xFF334155),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      badge.isUnlocked ? '🌟' : '🔒',
                      style: const TextStyle(fontSize: 22),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      badge.name,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: badge.isUnlocked ? Colors.white : Colors.white38,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildReplayIdempotencyTester() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '🔄 Thử Nghiệm Replay Idempotency (Target 2)',
            style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Bấm nhận thưởng lần 1 thành công; bấm nhận lại cùng eventId sẽ bị chặn duplicate:',
            style: TextStyle(color: Colors.white70, fontSize: 12),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                  onPressed: () => _triggerRewardReplayTest('evt-streak-bonus-1', 10, 100),
                  child: const Text('Nhận Thưởng (Lần 1)', style: TextStyle(fontSize: 11)),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.orange.shade800),
                  onPressed: () => _triggerRewardReplayTest('evt-streak-bonus-1', 10, 100),
                  child: const Text('Replay Lần 2 (Chặn)', style: TextStyle(fontSize: 11)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

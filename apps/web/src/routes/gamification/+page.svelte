<script lang="ts">
  import {
    calculateLevelProgress,
    evaluateStreakStatus,
    CANONICAL_ACHIEVEMENTS,
    STREAK_MILESTONES,
    validateStyleTemplatePayload,
    cloneStyleTemplateToTenant,
    evaluateRewardReplay,
    type Quest,
    type CommunityChallenge,
    type RewardEvent,
    type StyleTemplatePayload
  } from '$lib/gamification';

  // Current User Gamification State (Screen W079)
  let totalXP = $state(2840);
  let currentStreak = $state(14);
  let bestStreak = $state(21);
  let lastActivityAt = $state(new Date().toISOString());
  let streakGraceUntil = $state<string | null>(null);

  // Derived Level & Streak
  let levelProgress = $derived(calculateLevelProgress(totalXP));
  let streakStatus = $derived(
    evaluateStreakStatus(currentStreak, bestStreak, lastActivityAt, streakGraceUntil)
  );

  // Active Quests (Daily & Weekly)
  let quests = $state<Quest[]>([
    {
      questId: 'q-daily-01',
      title: 'Đăng 1 nội dung hôm nay (Post 1 content)',
      description: 'Xuất bản tối thiểu 1 clip hoặc bài viết lên kênh xã hội',
      questType: 'daily',
      targetCount: 1,
      currentProgress: 1,
      xpReward: 15,
      creditReward: 0,
      status: 'completed',
      expiresAt: '2026-11-05T00:00:00Z'
    },
    {
      questId: 'q-daily-02',
      title: 'Phản hồi 5 bình luận (Reply 5 comments)',
      description: 'Tương tác và trả lời người xem trong Unified Inbox',
      questType: 'daily',
      targetCount: 5,
      currentProgress: 3,
      xpReward: 20,
      creditReward: 0,
      status: 'in_progress',
      expiresAt: '2026-11-05T00:00:00Z'
    },
    {
      questId: 'q-weekly-01',
      title: 'Xuất bản 3 video AI (Publish 3 videos)',
      description: 'Render và đăng tải 3 clip hoàn chỉnh từ Video Studio',
      questType: 'weekly',
      targetCount: 3,
      currentProgress: 2,
      xpReward: 50,
      creditReward: 5,
      status: 'in_progress',
      expiresAt: '2026-11-09T00:00:00Z'
    }
  ]);

  // Monthly Challenge
  let monthlyChallenge = $state<CommunityChallenge>({
    challengeId: 'ch-nov-100k',
    title: 'Cột mốc 100K lượt xem (100K Views Milestone)',
    description: 'Đạt tổng 100.000 lượt xem tự nhiên trên tất cả các kênh trong tháng 11',
    xpReward: 200,
    creditReward: 50,
    participantCount: 42,
    status: 'active',
    createdAt: '2026-11-01T00:00:00Z',
    endsAt: '2026-11-30T23:59:59Z'
  });

  // Achievements
  let unlockedBadgeIds = $state<string[]>(['first_render', 'streak_7_days']);

  // Target 2: Reward Replay State
  let processedEventIds = $state<string[]>(['evt-daily-claimed']);
  let testRewardEventId = $state('evt-daily-claimed');
  let testRewardCredits = $state(10);
  let testRewardXP = $state(100);
  let rewardFeedback = $state('');

  function handleTestRewardDeposit() {
    const event: RewardEvent = {
      eventId: testRewardEventId,
      workspaceId: 'ws-creator-01',
      userId: 'usr-creator-01',
      sourceType: 'streak_milestone',
      sourceId: 'streak-7',
      creditsEarned: testRewardCredits,
      xpEarned: testRewardXP
    };
    const set = new Set(processedEventIds);
    const result = evaluateRewardReplay(event, set);
    if (!result.isDuplicate) {
      processedEventIds = [...processedEventIds, event.eventId];
      totalXP += result.xpAwarded;
      rewardFeedback = `✅ Thành công: Cộng ${result.creditsAwarded} credits và ${result.xpAwarded} XP!`;
    } else {
      rewardFeedback = `⚠️ Idempotent: Sự kiện "${testRewardEventId}" đã được ghi nhận trước đó. Không thưởng trùng!`;
    }
  }

  // Target 4: Style Template Sharing & Governance Tester State
  let templateTitle = $state('Cinematic Golden Hour Style');
  let templateColorGrade = $state('golden_warmth_3200k');
  let templatePacing = $state('rhythmic_cuts_110bpm');
  let templateLicense = $state('Creativanta Community Style License v1.0');
  let templatePrivateMediaSample = $state('');
  let templateBiometricSample = $state('');
  let templateCredentialSample = $state('');

  let computedTemplatePayload = $derived<StyleTemplatePayload>({
    schemaVersion: 1,
    title: templateTitle,
    licenseNotice: templateLicense,
    styleSettings: {
      color_grade: templateColorGrade,
      pacing: templatePacing,
      ...(templatePrivateMediaSample ? { test_media: templatePrivateMediaSample } : {}),
      ...(templateBiometricSample ? { test_biometric: templateBiometricSample } : {}),
      ...(templateCredentialSample ? { test_credential: templateCredentialSample } : {})
    }
  });

  let templateValidationResult = $derived(validateStyleTemplatePayload(computedTemplatePayload));

  // Target 3: Install Template Cloner Simulation
  let destinationWorkspace = $state('ws-buyer-destination');
  let clonedPackFeedback = $state('');

  function handleSimulateTemplateInstall() {
    if (!templateValidationResult.isValid) {
      clonedPackFeedback = '❌ Không thể cài đặt style template vi phạm quy chuẩn chia sẻ!';
      return;
    }
    const cloned = cloneStyleTemplateToTenant(
      'rec-style-golden-01',
      1,
      computedTemplatePayload.styleSettings,
      destinationWorkspace,
      `${templateTitle} (Tenant Pack)`
    );
    clonedPackFeedback = `✅ Đã clone thành công sang workspace: "${cloned.destinationWorkspaceId}" | Pack ID mới: ${cloned.clonedPackId} | Draft Workflow gắn kết`;
  }
</script>

<div class="min-h-screen bg-slate-950 text-slate-100 p-6 lg:p-10 font-sans">
  <!-- Header Bar -->
  <header class="mb-8 flex flex-col md:flex-row md:items-center md:justify-between gap-4 border-b border-slate-800 pb-6">
    <div>
      <div class="flex items-center gap-3">
        <span class="text-3xl">🎮</span>
        <h1 class="text-2xl lg:text-3xl font-bold tracking-tight text-white">
          Level & Thành Tích Sáng Tạo (Gamification)
        </h1>
      </div>
      <p class="text-sm text-slate-400 mt-1">
        Screen W079 · Tiến trình cấp độ 1–50, chuỗi hoạt động streak, thử thách cộng đồng và chia sẻ style template
      </p>
    </div>
    <div class="flex items-center gap-3">
      <span class="inline-flex items-center px-3 py-1 rounded-full text-xs font-semibold bg-emerald-500/10 text-emerald-400 border border-emerald-500/30">
        ● Trực tuyến · Idempotent Replay Active
      </span>
    </div>
  </header>

  <div class="grid grid-cols-1 lg:grid-cols-3 gap-8">
    <!-- Left Column: Level Card & Streaks & Quests -->
    <div class="lg:col-span-2 space-y-6">
      <!-- 1. Creator Level & Streak Card -->
      <section class="bg-slate-900 border border-slate-800 rounded-2xl p-6 shadow-xl relative overflow-hidden">
        <div class="flex flex-col sm:flex-row sm:items-center justify-between gap-4 mb-6">
          <div>
            <div class="flex items-center gap-2">
              <span class="text-amber-400 text-xl font-bold">⭐ Level {levelProgress.currentLevel}</span>
              <span class="text-slate-400">—</span>
              <span class="text-white font-semibold">{levelProgress.title}</span>
            </div>
            <p class="text-xs text-slate-400 mt-0.5">
              Tổng kinh nghiệm: <span class="text-indigo-400 font-mono font-medium">{levelProgress.totalXP.toLocaleString()} XP</span>
            </p>
          </div>

          <div class="flex items-center gap-3 bg-slate-800/80 px-4 py-2 rounded-xl border border-slate-700/60">
            <span class="text-2xl animate-pulse">🔥</span>
            <div>
              <div class="text-sm font-bold text-orange-400">
                Chuỗi {streakStatus.currentStreak} ngày
              </div>
              <div class="text-xs text-slate-400">
                Kỷ lục: {streakStatus.bestStreak} ngày
              </div>
            </div>
          </div>
        </div>

        <!-- Level XP Progress Bar -->
        <div class="space-y-2">
          <div class="flex justify-between text-xs text-slate-400 font-medium">
            <span>Tiến trình cấp độ</span>
            <span>{levelProgress.xpInCurrentLevel} / {levelProgress.xpNeededForNextLevel} XP ({levelProgress.progressPercent}%)</span>
          </div>
          <div class="w-full h-3 bg-slate-800 rounded-full overflow-hidden p-0.5 border border-slate-700">
            <div
              class="h-full bg-gradient-to-r from-indigo-500 via-purple-500 to-amber-400 rounded-full transition-all duration-500"
              style="width: {levelProgress.progressPercent}%"
            ></div>
          </div>
          <div class="flex justify-between text-xs text-slate-500">
            <span>Cấp {levelProgress.currentLevel} ({levelProgress.currentLevelBaseXP} XP)</span>
            <span>
              {levelProgress.isMaxLevel
                ? 'Đã đạt cấp tối đa'
                : `Còn ${levelProgress.xpNeededForNextLevel - levelProgress.xpInCurrentLevel} XP để lên Level ${levelProgress.currentLevel + 1}`}
            </span>
          </div>
        </div>

        <!-- Streak Milestone Info -->
        {#if streakStatus.nextMilestone}
          <div class="mt-4 pt-4 border-t border-slate-800/80 flex items-center justify-between text-xs">
            <span class="text-slate-400">
              🎯 Mốc thưởng tiếp theo: <strong class="text-amber-300">{streakStatus.nextMilestone.dayCount} ngày</strong> (+{streakStatus.nextMilestone.bonusCredits} credits, +{streakStatus.nextMilestone.bonusXP} XP)
            </span>
            <span class="text-slate-500">
              Còn {streakStatus.daysToNextMilestone} ngày nữa
            </span>
          </div>
        {/if}

        {#if streakStatus.isGraceActive}
          <div class="mt-3 p-2 bg-amber-500/10 border border-amber-500/30 rounded-lg text-xs text-amber-300">
            🛡️ <strong>Bảo vệ downtime đang kích hoạt (EC-GAM-001):</strong> Chuỗi streak của bạn được bảo lưu trong thời gian bảo trì hệ thống.
          </div>
        {/if}
      </section>

      <!-- 2. Active Quests & Challenges -->
      <section class="bg-slate-900 border border-slate-800 rounded-2xl p-6 shadow-xl">
        <h2 class="text-lg font-bold text-white mb-4 flex items-center gap-2">
          <span>🎯</span> Nhiệm Vụ Hoạt Động (Active Quests)
        </h2>

        <div class="space-y-3">
          {#each quests as q}
            <div class="p-4 bg-slate-800/60 rounded-xl border border-slate-700/60 flex flex-col sm:flex-row sm:items-center justify-between gap-3">
              <div class="space-y-1">
                <div class="flex items-center gap-2">
                  <span class="text-xs px-2 py-0.5 rounded font-mono uppercase {q.questType === 'daily' ? 'bg-blue-500/20 text-blue-400' : 'bg-purple-500/20 text-purple-400'}">
                    {q.questType}
                  </span>
                  <span class="font-semibold text-sm text-slate-100">{q.title}</span>
                </div>
                <p class="text-xs text-slate-400">{q.description}</p>
                <div class="text-xs text-slate-500">
                  Tiến độ: {q.currentProgress} / {q.targetCount}
                </div>
              </div>

              <div class="flex items-center gap-3">
                <div class="text-right">
                  <div class="text-xs font-mono font-bold text-indigo-400">+{q.xpReward} XP</div>
                  {#if q.creditReward > 0}
                    <div class="text-xs font-mono text-amber-400">+{q.creditReward} credits</div>
                  {/if}
                </div>
                {#if q.status === 'completed'}
                  <span class="px-3 py-1 bg-emerald-500/20 text-emerald-400 text-xs rounded-lg font-medium border border-emerald-500/30">
                    Đã hoàn tất
                  </span>
                {:else}
                  <span class="px-3 py-1 bg-slate-700 text-slate-300 text-xs rounded-lg font-medium">
                    Đang làm
                  </span>
                {/if}
              </div>
            </div>
          {/each}
        </div>

        <!-- Monthly Community Challenge -->
        <div class="mt-6 p-4 bg-indigo-950/40 rounded-xl border border-indigo-800/50">
          <div class="flex items-center justify-between mb-2">
            <div class="flex items-center gap-2">
              <span class="text-base">🏆</span>
              <h3 class="text-sm font-bold text-indigo-200">{monthlyChallenge.title}</h3>
            </div>
            <span class="text-xs text-indigo-300 font-mono">+{monthlyChallenge.xpReward} XP · +{monthlyChallenge.creditReward} credits</span>
          </div>
          <p class="text-xs text-indigo-300/80 mb-3">{monthlyChallenge.description}</p>
          <div class="flex items-center justify-between text-xs text-indigo-400">
            <span>Người tham gia: {monthlyChallenge.participantCount} creator</span>
            <span>Hạn chót: 30/11</span>
          </div>
        </div>
      </section>

      <!-- 3. Achievement Badges Grid -->
      <section class="bg-slate-900 border border-slate-800 rounded-2xl p-6 shadow-xl">
        <div class="flex items-center justify-between mb-4">
          <h2 class="text-lg font-bold text-white flex items-center gap-2">
            <span>🏅</span> Bộ Sưu Tập Huy Hiệu (Achievements)
          </h2>
          <span class="text-xs text-slate-400">
            Đã mở khóa: {unlockedBadgeIds.length} / {CANONICAL_ACHIEVEMENTS.length}
          </span>
        </div>

        <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-4">
          {#each CANONICAL_ACHIEVEMENTS as badge}
            {@const isUnlocked = unlockedBadgeIds.includes(badge.badgeId)}
            <div class="p-4 rounded-xl border transition-all {isUnlocked ? 'bg-slate-800/80 border-amber-500/40 shadow-amber-500/5' : 'bg-slate-900/50 border-slate-800 opacity-60'}">
              <div class="flex items-start justify-between">
                <span class="text-2xl">{isUnlocked ? '🌟' : '🔒'}</span>
                <span class="text-[10px] uppercase font-mono px-2 py-0.5 rounded font-semibold {badge.rarity === 'legendary' ? 'bg-amber-500/20 text-amber-300' : badge.rarity === 'epic' ? 'bg-purple-500/20 text-purple-300' : badge.rarity === 'rare' ? 'bg-blue-500/20 text-blue-300' : 'bg-slate-700 text-slate-300'}">
                  {badge.rarity}
                </span>
              </div>
              <h4 class="text-sm font-bold text-white mt-2">{badge.name}</h4>
              <p class="text-xs text-slate-400 mt-1 line-clamp-2">{badge.description}</p>
              <div class="mt-3 text-xs font-mono text-indigo-400">+{badge.xpReward} XP</div>
            </div>
          {/each}
        </div>
      </section>
    </div>

    <!-- Right Column: Target 4 Governance Validator & Target 2 Replay Tester -->
    <div class="space-y-6">
      <!-- Target 4: Style Template Sharing & Governance Review (Target 4 & Target 3) -->
      <section class="bg-slate-900 border border-slate-800 rounded-2xl p-6 shadow-xl">
        <h2 class="text-base font-bold text-white mb-2 flex items-center gap-2">
          <span>🛡️</span> Kiểm Duyệt Style Template (Target 4)
        </h2>
        <p class="text-xs text-slate-400 mb-4">
          Đảm bảo không chứa media riêng tư, không chứa sinh trắc khuôn mặt/giọng nói, không lộ API key.
        </p>

        <div class="space-y-3">
          <div>
            <label for="template-title-input" class="text-xs text-slate-400 block mb-1">Tên Style Template</label>
            <input
              id="template-title-input"
              type="text"
              bind:value={templateTitle}
              class="w-full bg-slate-800 border border-slate-700 rounded-lg px-3 py-1.5 text-xs text-white focus:outline-none focus:border-indigo-500"
            />
          </div>

          <div>
            <label for="color-grade-preset" class="text-xs text-slate-400 block mb-1">Preset Màu (Color Grade)</label>
            <input
              id="color-grade-preset"
              type="text"
              bind:value={templateColorGrade}
              class="w-full bg-slate-800 border border-slate-700 rounded-lg px-3 py-1.5 text-xs text-white focus:outline-none focus:border-indigo-500"
            />
          </div>

          <div>
            <label for="license-notice-input" class="text-xs text-slate-400 block mb-1">Giấy Phép Bản Quyền (License Notice)</label>
            <input
              id="license-notice-input"
              type="text"
              bind:value={templateLicense}
              class="w-full bg-slate-800 border border-slate-700 rounded-lg px-3 py-1.5 text-xs text-white focus:outline-none focus:border-indigo-500"
            />
          </div>

          <!-- Prohibited fields test triggers -->
          <div class="pt-2 border-t border-slate-800 space-y-2">
            <div class="text-xs font-semibold text-slate-300">Thử nghiệm vi phạm (Target 4 Gate):</div>
            <div>
              <label for="test-private-media-input" class="text-[11px] text-slate-400 block">Thử tiêm link media cá nhân (file://, raw_footage):</label>
              <input
                id="test-private-media-input"
                type="text"
                bind:value={templatePrivateMediaSample}
                placeholder="file:///var/private/clip.mp4"
                class="w-full bg-slate-800 border border-slate-700 rounded-lg px-2.5 py-1 text-xs text-rose-300 focus:outline-none"
              />
            </div>
            <div>
              <label for="test-biometric-input" class="text-[11px] text-slate-400 block">Thử tiêm dữ liệu sinh trắc (face_embedding):</label>
              <input
                id="test-biometric-input"
                type="text"
                bind:value={templateBiometricSample}
                placeholder="face_embedding_vector_data"
                class="w-full bg-slate-800 border border-slate-700 rounded-lg px-2.5 py-1 text-xs text-rose-300 focus:outline-none"
              />
            </div>
            <div>
              <label for="test-api-key-input" class="text-[11px] text-slate-400 block">Thử tiêm Auth Token (Bearer ...):</label>
              <input
                id="test-api-key-input"
                type="text"
                bind:value={templateCredentialSample}
                placeholder="Bearer eyJhbGciOi..."
                class="w-full bg-slate-800 border border-slate-700 rounded-lg px-2.5 py-1 text-xs text-rose-300 focus:outline-none"
              />
            </div>
          </div>

          <!-- Gate Result -->
          <div class="mt-4 p-3 rounded-xl border {templateValidationResult.isValid ? 'bg-emerald-950/30 border-emerald-800/60' : 'bg-rose-950/30 border-rose-800/60'}">
            <div class="flex items-center gap-2">
              <span class="text-sm">{templateValidationResult.isValid ? '✅' : '❌'}</span>
              <span class="text-xs font-bold {templateValidationResult.isValid ? 'text-emerald-400' : 'text-rose-400'}">
                {templateValidationResult.isValid ? 'Đạt chuẩn kiểm duyệt chia sẻ' : 'Vi phạm quy chuẩn an toàn'}
              </span>
            </div>
            {#if !templateValidationResult.isValid}
              <ul class="mt-2 space-y-1 text-[11px] text-rose-300">
                {#each templateValidationResult.issues as issue}
                  <li>• {issue.message}</li>
                {/each}
              </ul>
            {/if}
          </div>

          <!-- Target 3: Clone Template Simulation -->
          <div class="mt-4 pt-3 border-t border-slate-800">
            <label for="destination-ws-input" class="text-xs text-slate-400 block mb-1">Cài đặt sang Workspace (Target 3):</label>
            <input
              id="destination-ws-input"
              type="text"
              bind:value={destinationWorkspace}
              class="w-full bg-slate-800 border border-slate-700 rounded-lg px-3 py-1.5 text-xs text-white mb-2 focus:outline-none"
            />
            <button
              onclick={handleSimulateTemplateInstall}
              class="w-full py-2 bg-indigo-600 hover:bg-indigo-500 text-white rounded-lg text-xs font-semibold transition"
            >
              📥 Cài Đặt & Clone Pack Độc Lập
            </button>
            {#if clonedPackFeedback}
              <p class="mt-2 text-[11px] text-indigo-300 break-words">{clonedPackFeedback}</p>
            {/if}
          </div>
        </div>
      </section>

      <!-- Target 2: Reward Event Replay Idempotency Simulator -->
      <section class="bg-slate-900 border border-slate-800 rounded-2xl p-6 shadow-xl">
        <h2 class="text-base font-bold text-white mb-2 flex items-center gap-2">
          <span>🔄</span> Replay Idempotency (Target 2)
        </h2>
        <p class="text-xs text-slate-400 mb-4">
          Xác minh sự kiện nhận thưởng chỉ được cộng credits/XP đúng 1 lần duy nhất dù replayed.
        </p>

        <div class="space-y-3">
          <div>
            <label for="reward-event-id-input" class="text-xs text-slate-400 block mb-1">Reward Event ID</label>
            <input
              id="reward-event-id-input"
              type="text"
              bind:value={testRewardEventId}
              class="w-full bg-slate-800 border border-slate-700 rounded-lg px-3 py-1.5 text-xs text-white focus:outline-none"
            />
          </div>

          <div class="flex gap-2">
            <div class="flex-1">
              <label for="reward-credits-input" class="text-xs text-slate-400 block mb-1">Credits</label>
              <input
                id="reward-credits-input"
                type="number"
                bind:value={testRewardCredits}
                class="w-full bg-slate-800 border border-slate-700 rounded-lg px-3 py-1.5 text-xs text-white focus:outline-none"
              />
            </div>
            <div class="flex-1">
              <label for="reward-xp-input" class="text-xs text-slate-400 block mb-1">XP</label>
              <input
                id="reward-xp-input"
                type="number"
                bind:value={testRewardXP}
                class="w-full bg-slate-800 border border-slate-700 rounded-lg px-3 py-1.5 text-xs text-white focus:outline-none"
              />
            </div>
          </div>

          <button
            onclick={handleTestRewardDeposit}
            class="w-full py-2 bg-emerald-600 hover:bg-emerald-500 text-white rounded-lg text-xs font-semibold transition"
          >
            Nhận Thưởng (Thử Nghiệm Replay)
          </button>

          {#if rewardFeedback}
            <div class="p-3 bg-slate-800 rounded-xl text-xs text-slate-200 mt-2">
              {rewardFeedback}
            </div>
          {/if}

          <div class="text-[11px] text-slate-500 mt-2">
            Lịch sử Event IDs đã ghi nhận: {processedEventIds.join(', ')}
          </div>
        </div>
      </section>
    </div>
  </div>
</div>

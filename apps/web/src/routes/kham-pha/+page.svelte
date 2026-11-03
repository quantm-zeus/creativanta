<script lang="ts">
  import UnavailableNotice from '$lib/components/UnavailableNotice.svelte';
  import JobCard from '$lib/components/JobCard.svelte';
  import {
    calculateStrengthScore,
    evaluateSourceDegradation,
    evaluateAndDeduplicateAlerts,
    searchAndFilterTrends,
    convertTrendToOpportunity,
    type TrendItem,
    type PlatformConnectionStatus,
    type Watchlist,
    type WatchlistAlert,
    type ConfidenceBand
  } from '$lib/trend';

  // Workspace context (active tenant)
  const currentWorkspaceId = 'ws-current-tenant';
  const currentUserId = 'usr-creator-01';

  // Platform connector status state (Acceptance Target 1)
  let platformStatuses = $state<PlatformConnectionStatus[]>([
    {
      platform: 'TikTok',
      label: 'TikTok Shop & Video',
      isConnected: true,
      statusNote: 'Đã kết nối qua OAuth 2.0',
      lastSyncAt: '5 phút trước'
    },
    {
      platform: 'YouTube',
      label: 'YouTube Shorts',
      isConnected: true,
      statusNote: 'API quota còn 82%',
      lastSyncAt: '12 phút trước'
    },
    {
      platform: 'Shopee',
      label: 'Shopee Trends',
      isConnected: true,
      statusNote: 'Đồng bộ danh mục GMV',
      lastSyncAt: '20 phút trước'
    },
    {
      platform: 'Google Trends',
      label: 'Google Search Trends',
      isConnected: true,
      statusNote: 'Dữ liệu thời gian thực',
      lastSyncAt: '1 giờ trước'
    }
  ]);

  // Master trend seed data for current tenant
  let rawTrends = $state<TrendItem[]>([
    {
      id: 'tr-001',
      workspaceId: currentWorkspaceId,
      title: 'Review nồi chiên không dầu hơi nước 15L',
      category: 'Home & Living',
      platform: 'TikTok',
      velocity: 94,
      freshnessScore: 92,
      saturationScore: 20,
      strengthScore: calculateStrengthScore(94, 92, 20),
      confidence: 'high',
      sourceClass: 'official',
      isDegraded: false,
      sampleSize: 1420,
      signals: [
        { signalId: 'sig-1', platform: 'TikTok', weight: 0.65, sampleSize: 1200, observedAt: '2026-11-02T10:00:00Z' },
        { signalId: 'sig-2', platform: 'Shopee', weight: 0.35, sampleSize: 220, observedAt: '2026-11-02T09:30:00Z' }
      ],
      whyNow: 'Chuyển dịch từ nồi chiên cơ sang nồi chiên hơi nước chống khô đồ ăn trong mùa tiệc cuối năm',
      relevanceDescription: 'Lượng tìm kiếm tăng vọt 340% trên TikTok Shop trong 7 ngày qua',
      isSavedToWatchlist: false,
      createdAt: '2026-11-02T08:00:00Z'
    },
    {
      id: 'tr-002',
      workspaceId: currentWorkspaceId,
      title: 'Serum phục hồi B5 + Rau má hữu cơ',
      category: 'Beauty',
      platform: 'Shopee',
      velocity: 86,
      freshnessScore: 88,
      saturationScore: 35,
      strengthScore: calculateStrengthScore(86, 88, 35),
      confidence: 'high',
      sourceClass: 'official',
      isDegraded: false,
      sampleSize: 980,
      signals: [
        { signalId: 'sig-3', platform: 'Shopee', weight: 0.7, sampleSize: 750, observedAt: '2026-11-02T11:00:00Z' },
        { signalId: 'sig-4', platform: 'TikTok', weight: 0.3, sampleSize: 230, observedAt: '2026-11-02T10:15:00Z' }
      ],
      whyNow: 'Thời tiết giao mùa hanh khô, người dùng tìm kiếm sản phẩm dịu nhẹ không kích ứng',
      relevanceDescription: 'Tỷ lệ chốt đơn live stream tăng 180% so với tuần trước',
      isSavedToWatchlist: false,
      createdAt: '2026-11-02T07:30:00Z'
    },
    {
      id: 'tr-003',
      workspaceId: currentWorkspaceId,
      title: 'Bàn phím cơ công thái học Alice layout',
      category: 'Tech & Gadgets',
      platform: 'YouTube',
      velocity: 80,
      freshnessScore: 85,
      saturationScore: 28,
      strengthScore: calculateStrengthScore(80, 85, 28),
      confidence: 'medium_high',
      sourceClass: 'official',
      isDegraded: false,
      sampleSize: 540,
      signals: [
        { signalId: 'sig-5', platform: 'YouTube', weight: 0.8, sampleSize: 450, observedAt: '2026-11-02T06:00:00Z' },
        { signalId: 'sig-6', platform: 'Google Trends', weight: 0.2, sampleSize: 90, observedAt: '2026-11-02T05:30:00Z' }
      ],
      whyNow: 'Dân văn phòng và lập trình viên chú trọng sức khỏe cổ tay khi làm việc hybrid',
      relevanceDescription: 'Video unboxing trên YouTube Shorts đạt CTR trung bình 8.4%',
      isSavedToWatchlist: false,
      createdAt: '2026-11-01T22:00:00Z'
    },
    {
      id: 'tr-004',
      workspaceId: currentWorkspaceId,
      title: 'Cà phê muối đóng lon tiệt trùng',
      category: 'Food & Cooking',
      platform: 'TikTok',
      velocity: 91,
      freshnessScore: 78,
      saturationScore: 45,
      strengthScore: calculateStrengthScore(91, 78, 45),
      confidence: 'medium_high',
      sourceClass: 'official',
      isDegraded: false,
      sampleSize: 1100,
      signals: [
        { signalId: 'sig-7', platform: 'TikTok', weight: 0.9, sampleSize: 1000, observedAt: '2026-11-02T12:00:00Z' }
      ],
      whyNow: 'Xu hướng đồ uống đường phố Huế được đóng lon để ship toàn quốc',
      relevanceDescription: 'Hashtag #caphemuoi đạt 45M views trong tháng',
      isSavedToWatchlist: false,
      createdAt: '2026-11-01T18:00:00Z'
    },
    {
      id: 'tr-005',
      workspaceId: currentWorkspaceId,
      title: 'Áo khoác gió trượt nước gập gọn',
      category: 'Fashion',
      platform: 'Google Trends',
      velocity: 74,
      freshnessScore: 70,
      saturationScore: 50,
      strengthScore: calculateStrengthScore(74, 70, 50),
      confidence: 'medium',
      sourceClass: 'official',
      isDegraded: false,
      sampleSize: 320,
      signals: [
        { signalId: 'sig-8', platform: 'Google Trends', weight: 1.0, sampleSize: 320, observedAt: '2026-11-01T15:00:00Z' }
      ],
      whyNow: 'Dự báo không khí lạnh tràn về miền Bắc trong 48h tới',
      relevanceDescription: 'Khối lượng tìm kiếm tăng 210% tại khu vực Hà Nội',
      isSavedToWatchlist: false,
      createdAt: '2026-11-01T14:00:00Z'
    }
  ]);

  // UI state: Search and filters (Acceptance Target 3)
  let searchQuery = $state('');
  let selectedPlatform = $state('all');
  let selectedCategory = $state('all');
  let selectedConfidence = $state<ConfidenceBand | 'all'>('all');
  let selectedSort = $state<'score_desc' | 'velocity_desc' | 'freshness_desc'>('score_desc');
  let viewMode = $state<'grid' | 'list'>('grid');

  // Watchlist & Alerts state (Acceptance Target 2)
  let isWatchlistDrawerOpen = $state(false);
  let activeWatchlist = $state<Watchlist>({
    id: 'wl-default-01',
    workspaceId: currentWorkspaceId,
    name: 'Top xu hướng bứt phá',
    itemCount: 0,
    alertsEnabled: true,
    minVelocityThreshold: 80,
    maxSaturationThreshold: 50,
    cooldownMinutes: 60,
    trendIds: []
  });

  let recentAlertFingerprints = $state<Map<string, number>>(new Map());
  let emittedAlerts = $state<WatchlistAlert[]>([]);
  let suppressedAlertsCount = $state(0);
  let alertStormNotification = $state<string | null>(null);

  // Conversion toast state
  let convertedOpportunityNotice = $state<string | null>(null);

  // Reactive degraded trends computation (Acceptance Target 1)
  let degradedTrends = $derived(
    rawTrends.map((t) => evaluateSourceDegradation(t, platformStatuses))
  );

  // Any platform currently disconnected?
  let disconnectedPlatforms = $derived(
    platformStatuses.filter((p) => !p.isConnected)
  );

  // Filtered and searched trends (Acceptance Target 3)
  let visibleTrends = $derived(
    searchAndFilterTrends(degradedTrends, currentWorkspaceId, {
      query: searchQuery,
      platform: selectedPlatform,
      category: selectedCategory,
      confidence: selectedConfidence,
      sortBy: selectedSort
    })
  );

  // Quick summary numbers
  let totalTrendsCount = $derived(rawTrends.length);
  let topTrend = $derived(
    [...rawTrends].sort((a, b) => b.strengthScore - a.strengthScore)[0]
  );

  // Toggle platform connection for Acceptance Target 1 verification
  function togglePlatformConnection(platformName: string) {
    platformStatuses = platformStatuses.map((p) => {
      if (p.platform.toLowerCase() === platformName.toLowerCase()) {
        const nextState = !p.isConnected;
        return {
          ...p,
          isConnected: nextState,
          statusNote: nextState
            ? 'Đã kết nối lại thành công'
            : 'Mô phỏng ngắt kết nối / token hết hạn (P2-01 Verification)'
        };
      }
      return p;
    });
  }

  // Toggle watchlist item (Acceptance Target 2)
  function toggleSaveWatchlist(trend: TrendItem) {
    const isSaved = activeWatchlist.trendIds.includes(trend.id);
    if (isSaved) {
      activeWatchlist.trendIds = activeWatchlist.trendIds.filter((id) => id !== trend.id);
    } else {
      activeWatchlist.trendIds = [...activeWatchlist.trendIds, trend.id];
    }
    activeWatchlist.itemCount = activeWatchlist.trendIds.length;

    // Update raw trend saved flag
    rawTrends = rawTrends.map((t) =>
      t.id === trend.id ? { ...t, isSavedToWatchlist: !isSaved } : t
    );
  }

  // Evaluate alerts with deduplication and storm batching (Acceptance Target 2)
  function runWatchlistAlertEvaluation(simulateStorm: boolean = false) {
    const breaches = [];
    const watchedTrends = degradedTrends.filter((t) =>
      activeWatchlist.trendIds.includes(t.id)
    );

    const trendsToCheck = watchedTrends.length > 0 ? watchedTrends : degradedTrends;

    for (const t of trendsToCheck) {
      if (t.velocity >= activeWatchlist.minVelocityThreshold) {
        breaches.push({
          workspaceId: currentWorkspaceId,
          watchlistId: activeWatchlist.id,
          trendId: t.id,
          trendTitle: t.title,
          metricName: 'velocity',
          thresholdValue: activeWatchlist.minVelocityThreshold,
          actualValue: t.velocity
        });
      }
    }

    if (simulateStorm) {
      // Simulate storm with 7 simultaneous breaches
      for (let i = 1; i <= 7; i++) {
        breaches.push({
          workspaceId: currentWorkspaceId,
          watchlistId: activeWatchlist.id,
          trendId: `t-storm-${i}`,
          trendTitle: `Tín hiệu bão xu hướng #${i}`,
          metricName: 'velocity',
          thresholdValue: activeWatchlist.minVelocityThreshold,
          actualValue: 85 + i
        });
      }
    }

    const result = evaluateAndDeduplicateAlerts(
      breaches,
      recentAlertFingerprints,
      activeWatchlist.cooldownMinutes
    );

    emittedAlerts = [...result.emittedAlerts, ...emittedAlerts];
    suppressedAlertsCount += result.suppressedCount;
    recentAlertFingerprints = result.updatedFingerprints;

    if (result.emittedAlerts.some((a) => a.isBatchedSummary)) {
      alertStormNotification = `Đã phát hiện bão cảnh báo (>5 vi phạm đồng thời)! Hệ thống đã gộp thành 1 thông báo tổng hợp theo hợp đồng EC-M02-004.`;
    } else {
      alertStormNotification = null;
    }
  }

  // Convert trend to Opportunity (Module M04 integration)
  function handleConvertToOpportunity(trend: TrendItem) {
    try {
      const opp = convertTrendToOpportunity(trend, currentWorkspaceId, currentUserId);
      convertedOpportunityNotice = `Đã chuyển đổi "${trend.title}" thành Cơ hội kinh doanh (#${opp.opportunityId}) thành công. Sẵn sàng tạo chiến dịch!`;
      setTimeout(() => {
        convertedOpportunityNotice = null;
      }, 6000);
    } catch (err: unknown) {
      const msg = err instanceof Error ? err.message : String(err);
      alert(`Không thể chuyển đổi: ${msg}`);
    }
  }
</script>

<svelte:head>
  <title>Khám phá — Trend Fusion Radar — Creativanta</title>
</svelte:head>

<div class="space-y-6">
  <!-- Top Navigation & Header -->
  <div class="flex flex-col gap-4 sm:flex-row sm:items-center sm:justify-between border-b border-[#e7e2d7] pb-5">
    <div>
      <div class="flex items-center gap-2">
        <span class="rounded bg-[#274333] px-2 py-0.5 text-xs font-semibold text-[#fbf9f5]">
          Job 2
        </span>
        <h1 class="text-2xl font-bold tracking-tight text-[#242924] sm:text-3xl">
          Khám phá — Trend Fusion Radar
        </h1>
        <span class="rounded-sm bg-[#eef3f0] px-2 py-0.5 text-xs font-semibold text-[#274333] border border-[#274333]/20">
          M02 Khả dụng (P2)
        </span>
      </div>
      <p class="text-sm text-[#616c63] mt-1">
        Radar phát hiện xu hướng đa nền tảng, chấm điểm độ mạnh đa chiều và cảnh báo ngưỡng tự động.
      </p>
    </div>

    <div class="flex flex-wrap items-center gap-2">
      <!-- Competitor & Benchmark Navigation Links (M03) -->
      <a
        href="/intelligence/competitors"
        class="inline-flex items-center gap-1.5 rounded-md border border-[#e7e2d7] bg-[#ffffff] px-3 py-1.5 text-xs font-semibold text-[#242924] hover:bg-[#f4f0e8] transition-colors shadow-xs"
      >
        <span>🏆 Đối thủ</span>
        <span class="rounded bg-[#f4f0e8] px-1 text-[10px] text-[#616c63]">M03</span>
      </a>

      <a
        href="/intelligence/benchmarks"
        class="inline-flex items-center gap-1.5 rounded-md border border-[#e7e2d7] bg-[#ffffff] px-3 py-1.5 text-xs font-semibold text-[#242924] hover:bg-[#f4f0e8] transition-colors shadow-xs"
      >
        <span>📊 Benchmark</span>
        <span class="rounded bg-[#f4f0e8] px-1 text-[10px] text-[#616c63]">M03</span>
      </a>

      <!-- Watchlist Drawer Trigger -->
      <button
        type="button"
        onclick={() => (isWatchlistDrawerOpen = true)}
        class="inline-flex items-center gap-2 rounded-md border border-[#274333] bg-[#ffffff] px-3.5 py-1.5 text-xs font-semibold text-[#274333] hover:bg-[#eef3f0] transition-colors shadow-xs"
        data-testid="open-watchlist-button"
      >
        <span>📌 Watchlist & Cảnh báo</span>
        {#if activeWatchlist.trendIds.length > 0}
          <span class="inline-flex h-4 min-w-4 items-center justify-center rounded-full bg-[#274333] px-1 text-[10px] text-[#fbf9f5]">
            {activeWatchlist.trendIds.length}
          </span>
        {/if}
      </button>

      <!-- View mode switch -->
      <div class="inline-flex rounded-md border border-[#e7e2d7] bg-[#ffffff] p-0.5">
        <button
          type="button"
          onclick={() => (viewMode = 'grid')}
          class="rounded px-2.5 py-1 text-xs font-medium transition-colors {viewMode === 'grid' ? 'bg-[#274333] text-[#fbf9f5]' : 'text-[#616c63] hover:text-[#242924]'}"
          aria-label="Chế độ lưới"
        >
          ▦ Lưới
        </button>
        <button
          type="button"
          onclick={() => (viewMode = 'list')}
          class="rounded px-2.5 py-1 text-xs font-medium transition-colors {viewMode === 'list' ? 'bg-[#274333] text-[#fbf9f5]' : 'text-[#616c63] hover:text-[#242924]'}"
          aria-label="Chế độ danh sách"
        >
          ☰ Danh sách
        </button>
      </div>
    </div>
  </div>

  <!-- Acceptance Target 1: Degraded Source Notice Banner -->
  {#if disconnectedPlatforms.length > 0}
    <div
      class="rounded-lg border-2 border-[#d94a31] bg-[#fdf5f3] p-4 text-[#242924] shadow-sm animate-pulse-subtle"
      role="alert"
      data-testid="degraded-source-banner"
    >
      <div class="flex flex-col gap-3 sm:flex-row sm:items-center sm:justify-between">
        <div class="flex items-start gap-3">
          <span class="inline-flex h-7 w-7 shrink-0 items-center justify-center rounded-full bg-[#d94a31] text-sm font-bold text-[#fbf9f5]">
            ⚠️
          </span>
          <div>
            <h3 class="text-sm font-bold text-[#d94a31]">
              Nguồn dữ liệu bị suy giảm: {disconnectedPlatforms.map((p) => p.label).join(', ')} đang bị gián đoạn
            </h3>
            <p class="text-xs text-[#616c63] mt-0.5">
              Hệ thống chuyển sang chế độ dữ liệu ước tính (ESTIMATED) với độ tin cậy thấp (CONFIDENCE_BAND_LOW). Các chỉ số xu hướng từ nguồn này có thể không phản ánh chính xác 100% thời gian thực.
            </p>
          </div>
        </div>

        <div class="flex items-center gap-2 shrink-0">
          <a
            href="/settings/connections"
            class="rounded-md bg-[#d94a31] px-3 py-1.5 text-xs font-semibold text-[#fbf9f5] hover:bg-[#b83b25] transition-colors shadow-xs"
          >
            Kết nối lại nguồn
          </a>
          <button
            type="button"
            onclick={() => togglePlatformConnection(disconnectedPlatforms[0].platform)}
            class="rounded-md border border-[#d94a31] bg-[#ffffff] px-2.5 py-1.5 text-xs font-medium text-[#d94a31] hover:bg-[#fbeee9]"
          >
            Khôi phục (Test)
          </button>
        </div>
      </div>
    </div>
  {/if}

  <!-- Converted to Opportunity Success Toast -->
  {#if convertedOpportunityNotice}
    <div
      class="rounded-lg border border-[#274333]/30 bg-[#eef3f0] p-4 text-[#274333] shadow-xs flex items-center justify-between"
      role="status"
    >
      <div class="flex items-center gap-2">
        <span class="text-lg">🎉</span>
        <span class="text-xs font-semibold">{convertedOpportunityNotice}</span>
      </div>
      <button
        type="button"
        onclick={() => (convertedOpportunityNotice = null)}
        class="text-xs font-bold text-[#274333] hover:underline"
      >
        Đóng
      </button>
    </div>
  {/if}

  <!-- Quick Summary Bar (W038 §3) -->
  <div class="rounded-xl border border-[#e7e2d7] bg-[#ffffff] p-4 shadow-xs">
    <div class="grid grid-cols-2 gap-4 sm:grid-cols-4 sm:divide-x sm:divide-[#e7e2d7]">
      <div class="px-2">
        <span class="text-xs font-medium text-[#616c63]">Tổng xu hướng theo dõi</span>
        <p class="text-xl font-bold text-[#242924] mt-0.5">🔥 {totalTrendsCount} xu hướng</p>
      </div>

      <div class="px-2">
        <span class="text-xs font-medium text-[#616c63]">Xu hướng bứt phá nhất</span>
        <p class="text-sm font-bold text-[#274333] truncate mt-0.5">
          ⭐ {topTrend ? topTrend.title : 'Chưa có'} ({topTrend ? topTrend.strengthScore : 0}đ)
        </p>
      </div>

      <div class="px-2">
        <span class="text-xs font-medium text-[#616c63]">Nền tảng kết nối</span>
        <div class="flex flex-wrap gap-1 mt-1">
          {#each platformStatuses as p}
            <span
              class="inline-flex items-center gap-1 rounded px-1.5 py-0.5 text-[10px] font-medium {p.isConnected ? 'bg-[#eef3f0] text-[#274333]' : 'bg-[#fbeee9] text-[#d94a31] line-through'}"
              title="{p.label}: {p.statusNote}"
            >
              <span class="h-1.5 w-1.5 rounded-full {p.isConnected ? 'bg-[#274333]' : 'bg-[#d94a31]'}"></span>
              {p.platform}
            </span>
          {/each}
        </div>
      </div>

      <div class="px-2 flex items-center justify-between">
        <div>
          <span class="text-xs font-medium text-[#616c63]">Kiểm tra kết nối</span>
          <p class="text-[11px] text-[#616c63] mt-0.5">Mô phỏng ngắt kết nối</p>
        </div>
        <button
          type="button"
          onclick={() => togglePlatformConnection('TikTok')}
          class="rounded border border-[#e7e2d7] bg-[#f4f0e8] px-2 py-1 text-[11px] font-semibold text-[#242924] hover:bg-[#e7e2d7] transition-colors"
          data-testid="toggle-degrade-button"
        >
          {platformStatuses.find((p) => p.platform === 'TikTok')?.isConnected ? 'Ngắt TikTok' : 'Nối lại TikTok'}
        </button>
      </div>
    </div>
  </div>

  <!-- Filter & Tenant-Scoped Search Bar (Acceptance Target 3) -->
  <div class="rounded-xl border border-[#e7e2d7] bg-[#ffffff] p-4 shadow-xs space-y-3">
    <div class="flex flex-col gap-3 md:flex-row md:items-center">
      <!-- Search Input -->
      <div class="relative flex-1">
        <span class="absolute inset-y-0 left-0 flex items-center pl-3 text-[#616c63]">
          🔍
        </span>
        <input
          type="search"
          bind:value={searchQuery}
          placeholder="Tìm kiếm ngữ nghĩa theo từ khóa, lý do bứt phá, ngành hàng..."
          class="w-full rounded-md border border-[#e7e2d7] bg-[#fbf9f5] py-2 pl-9 pr-3 text-xs text-[#242924] placeholder-[#616c63] focus:border-[#274333] focus:bg-[#ffffff] focus:outline-hidden"
          data-testid="trend-search-input"
        />
      </div>

      <!-- Quick Filters -->
      <div class="flex flex-wrap items-center gap-2">
        <!-- Platform filter -->
        <select
          bind:value={selectedPlatform}
          class="rounded-md border border-[#e7e2d7] bg-[#ffffff] px-2.5 py-2 text-xs font-medium text-[#242924] focus:border-[#274333] focus:outline-hidden"
          data-testid="trend-platform-filter"
        >
          <option value="all">Tất cả nền tảng</option>
          <option value="TikTok">TikTok</option>
          <option value="Shopee">Shopee</option>
          <option value="YouTube">YouTube</option>
          <option value="Google Trends">Google Trends</option>
        </select>

        <!-- Category filter -->
        <select
          bind:value={selectedCategory}
          class="rounded-md border border-[#e7e2d7] bg-[#ffffff] px-2.5 py-2 text-xs font-medium text-[#242924] focus:border-[#274333] focus:outline-hidden"
          data-testid="trend-category-filter"
        >
          <option value="all">Tất cả ngành hàng</option>
          <option value="Home & Living">Home & Living</option>
          <option value="Beauty">Beauty & Skincare</option>
          <option value="Tech & Gadgets">Tech & Gadgets</option>
          <option value="Food & Cooking">Food & F&B</option>
          <option value="Fashion">Thời trang & Phụ kiện</option>
        </select>

        <!-- Confidence filter -->
        <select
          bind:value={selectedConfidence}
          class="rounded-md border border-[#e7e2d7] bg-[#ffffff] px-2.5 py-2 text-xs font-medium text-[#242924] focus:border-[#274333] focus:outline-hidden"
          data-testid="trend-confidence-filter"
        >
          <option value="all">Tất cả độ tin cậy</option>
          <option value="high">Độ tin cậy Cao (High)</option>
          <option value="medium_high">Khá cao (Medium-High)</option>
          <option value="medium">Trung bình (Medium)</option>
          <option value="low">Thấp / Ước tính (Low)</option>
        </select>

        <!-- Sort dropdown -->
        <select
          bind:value={selectedSort}
          class="rounded-md border border-[#e7e2d7] bg-[#ffffff] px-2.5 py-2 text-xs font-medium text-[#242924] focus:border-[#274333] focus:outline-hidden"
          data-testid="trend-sort-filter"
        >
          <option value="score_desc">Điểm mạnh (Cao → Thấp)</option>
          <option value="velocity_desc">Tốc độ tăng trưởng</option>
          <option value="freshness_desc">Độ tươi mới</option>
        </select>

        {#if searchQuery || selectedPlatform !== 'all' || selectedCategory !== 'all' || selectedConfidence !== 'all'}
          <button
            type="button"
            onclick={() => {
              searchQuery = '';
              selectedPlatform = 'all';
              selectedCategory = 'all';
              selectedConfidence = 'all';
            }}
            class="text-xs font-semibold text-[#d94a31] hover:underline px-1"
          >
            Xóa bộ lọc
          </button>
        {/if}
      </div>
    </div>
  </div>

  <!-- Trends Grid or List View -->
  {#if visibleTrends.length === 0}
    <div class="rounded-xl border border-dashed border-[#e7e2d7] bg-[#ffffff] p-12 text-center">
      <p class="text-sm font-semibold text-[#242924]">Không tìm thấy xu hướng phù hợp</p>
      <p class="text-xs text-[#616c63] mt-1">
        Hãy thử điều chỉnh từ khóa tìm kiếm hoặc đặt lại các bộ lọc nền tảng và ngành hàng.
      </p>
    </div>
  {:else if viewMode === 'grid'}
    <div class="grid grid-cols-1 gap-5 md:grid-cols-2 lg:grid-cols-3" data-testid="trend-cards-grid">
      {#each visibleTrends as trend (trend.id)}
        <div
          class="flex flex-col justify-between rounded-xl border border-[#e7e2d7] bg-[#ffffff] p-5 shadow-xs transition-shadow hover:shadow-md relative overflow-hidden"
          data-testid="trend-card-{trend.id}"
        >
          <!-- Degraded Watermark Indicator -->
          {#if trend.isDegraded}
            <div class="bg-[#fbeee9] border-b border-[#d94a31]/30 -mx-5 -mt-5 px-5 py-2 mb-3 flex items-center justify-between">
              <span class="text-[11px] font-bold text-[#d94a31] flex items-center gap-1">
                ⚠️ Dữ liệu ước tính (Nguồn gián đoạn)
              </span>
              <span class="text-[10px] font-mono text-[#d94a31] uppercase">DEGRADED</span>
            </div>
          {/if}

          <div>
            <!-- Header: Category & Platform & Strength Score -->
            <div class="flex items-start justify-between gap-2 mb-2">
              <div class="flex flex-wrap items-center gap-1.5">
                <span class="rounded bg-[#f4f0e8] px-2 py-0.5 text-[11px] font-medium text-[#274333]">
                  {trend.category}
                </span>
                <span class="rounded bg-[#eef3f0] px-2 py-0.5 text-[11px] font-semibold text-[#274333]">
                  {trend.platform}
                </span>
                <span
                  class="rounded px-1.5 py-0.5 text-[10px] font-bold uppercase {trend.sourceClass === 'official' ? 'bg-[#eef3f0] text-[#274333]' : 'bg-[#fbeee9] text-[#d94a31]'}"
                  title="Source class: {trend.sourceClass}"
                >
                  {trend.sourceClass}
                </span>
              </div>

              <!-- Composite Strength Score badge -->
              <div class="flex flex-col items-end">
                <span class="text-xs font-mono font-bold text-[#274333] bg-[#eef3f0] border border-[#274333]/20 rounded px-2 py-0.5">
                  ⭐ {trend.strengthScore}đ
                </span>
              </div>
            </div>

            <!-- Title -->
            <h3 class="text-base font-bold text-[#242924] tracking-tight leading-snug">
              {trend.title}
            </h3>

            <!-- Why Now Insight -->
            <div class="mt-2.5 rounded-md bg-[#fbf9f5] border border-[#e7e2d7] p-2.5">
              <p class="text-[11px] font-semibold text-[#274333] flex items-center gap-1">
                <span>💡 Tại sao ngay lúc này?</span>
              </p>
              <p class="text-xs text-[#242924] mt-1 leading-relaxed">
                {trend.whyNow}
              </p>
              <p class="text-[11px] text-[#616c63] mt-1 italic">
                {trend.relevanceDescription}
              </p>
            </div>

            <!-- 3 Dimension Bars (Velocity, Freshness, Saturation) -->
            <div class="mt-3.5 space-y-2">
              <div>
                <div class="flex justify-between text-[11px]">
                  <span class="font-medium text-[#616c63]">Tốc độ (Velocity)</span>
                  <span class="font-bold text-[#242924]">{trend.velocity}%</span>
                </div>
                <div class="w-full bg-[#f4f0e8] h-1.5 rounded-full overflow-hidden mt-0.5">
                  <div class="bg-[#274333] h-full rounded-full" style="width: {trend.velocity}%"></div>
                </div>
              </div>

              <div>
                <div class="flex justify-between text-[11px]">
                  <span class="font-medium text-[#616c63]">Độ tươi mới (Freshness)</span>
                  <span class="font-bold text-[#242924]">{trend.freshnessScore}%</span>
                </div>
                <div class="w-full bg-[#f4f0e8] h-1.5 rounded-full overflow-hidden mt-0.5">
                  <div class="bg-[#487a5a] h-full rounded-full" style="width: {trend.freshnessScore}%"></div>
                </div>
              </div>

              <div>
                <div class="flex justify-between text-[11px]">
                  <span class="font-medium text-[#616c63]">Độ bão hòa (Saturation - thấp là tốt)</span>
                  <span class="font-bold text-[#242924]">{trend.saturationScore}%</span>
                </div>
                <div class="w-full bg-[#f4f0e8] h-1.5 rounded-full overflow-hidden mt-0.5">
                  <div class="bg-[#d94a31] h-full rounded-full" style="width: {trend.saturationScore}%"></div>
                </div>
              </div>
            </div>

            <!-- Confidence and Provenance details -->
            <div class="mt-3 pt-2.5 border-t border-[#e7e2d7] flex items-center justify-between text-[11px] text-[#616c63]">
              <span class="flex items-center gap-1">
                Độ tin cậy:
                <span class="font-bold {trend.confidence === 'high' ? 'text-[#274333]' : trend.confidence === 'low' ? 'text-[#d94a31]' : 'text-[#8c6d1f]'}">
                  {trend.confidence.toUpperCase()}
                </span>
              </span>
              <span>{trend.sampleSize.toLocaleString()} mẫu tín hiệu</span>
            </div>
          </div>

          <!-- Action buttons -->
          <div class="mt-4 pt-3 border-t border-[#e7e2d7] space-y-2">
            <div class="grid grid-cols-2 gap-2">
              <button
                type="button"
                onclick={() => toggleSaveWatchlist(trend)}
                class="rounded-md border border-[#e7e2d7] bg-[#fbf9f5] py-1.5 px-2 text-xs font-semibold transition-colors {activeWatchlist.trendIds.includes(trend.id) ? 'bg-[#274333] text-[#fbf9f5] border-[#274333]' : 'text-[#242924] hover:bg-[#e7e2d7]'}"
                data-testid="save-watchlist-btn-{trend.id}"
              >
                {activeWatchlist.trendIds.includes(trend.id) ? '✓ Đã lưu' : '📌 Watchlist'}
              </button>

              <button
                type="button"
                onclick={() => handleConvertToOpportunity(trend)}
                class="rounded-md bg-[#274333] py-1.5 px-2 text-xs font-semibold text-[#fbf9f5] hover:bg-[#1f3528] transition-colors shadow-xs"
                data-testid="convert-opp-btn-{trend.id}"
              >
                💡 Tạo cơ hội
              </button>
            </div>

            <a
              href="/studio/remix?trend_id={encodeURIComponent(trend.id)}&topic={encodeURIComponent(trend.title)}&reference_url={encodeURIComponent('https://tiktok.com/@trend/video/' + trend.id)}"
              class="w-full flex items-center justify-center gap-1 rounded-md border border-[#274333] bg-[#eef3f0] py-1.5 px-2 text-xs font-semibold text-[#274333] hover:bg-[#dce7e1] transition-colors shadow-xs"
              data-testid="remix-trend-btn-{trend.id}"
            >
              🔄 Remix video này
            </a>
          </div>
        </div>
      {/each}
    </div>
  {:else}
    <!-- List View -->
    <div class="rounded-xl border border-[#e7e2d7] bg-[#ffffff] overflow-hidden shadow-xs">
      <table class="w-full text-left border-collapse text-xs">
        <thead class="bg-[#f4f0e8] text-[#242924] font-semibold border-b border-[#e7e2d7]">
          <tr>
            <th class="py-3 px-4">Xu hướng</th>
            <th class="py-3 px-4">Nền tảng</th>
            <th class="py-3 px-4">Ngành hàng</th>
            <th class="py-3 px-4 text-center">Điểm mạnh</th>
            <th class="py-3 px-4 text-center">Tốc độ</th>
            <th class="py-3 px-4 text-center">Độ tin cậy</th>
            <th class="py-3 px-4 text-right">Thao tác</th>
          </tr>
        </thead>
        <tbody class="divide-y divide-[#e7e2d7]">
          {#each visibleTrends as trend (trend.id)}
            <tr class="hover:bg-[#fbf9f5] transition-colors">
              <td class="py-3 px-4">
                <div class="font-bold text-[#242924]">{trend.title}</div>
                <div class="text-[11px] text-[#616c63] truncate max-w-xs">{trend.whyNow}</div>
              </td>
              <td class="py-3 px-4 font-medium text-[#242924]">{trend.platform}</td>
              <td class="py-3 px-4 text-[#616c63]">{trend.category}</td>
              <td class="py-3 px-4 text-center font-bold text-[#274333]">⭐ {trend.strengthScore}</td>
              <td class="py-3 px-4 text-center font-bold text-[#242924]">{trend.velocity}%</td>
              <td class="py-3 px-4 text-center">
                <span class="rounded px-1.5 py-0.5 text-[10px] font-bold uppercase {trend.confidence === 'high' ? 'bg-[#eef3f0] text-[#274333]' : 'bg-[#fbeee9] text-[#d94a31]'}">
                  {trend.confidence}
                </span>
              </td>
              <td class="py-3 px-4 text-right space-x-2">
                <button
                  type="button"
                  onclick={() => toggleSaveWatchlist(trend)}
                  class="font-semibold text-[#274333] hover:underline"
                >
                  {activeWatchlist.trendIds.includes(trend.id) ? 'Bỏ lưu' : 'Lưu'}
                </button>
                <button
                  type="button"
                  onclick={() => handleConvertToOpportunity(trend)}
                  class="font-semibold text-[#274333] hover:underline"
                >
                  Cơ hội
                </button>
                <a
                  href="/studio/remix?trend_id={encodeURIComponent(trend.id)}&topic={encodeURIComponent(trend.title)}&reference_url={encodeURIComponent('https://tiktok.com/@trend/video/' + trend.id)}"
                  class="font-semibold text-[#274333] hover:underline"
                  data-testid="remix-trend-table-btn-{trend.id}"
                >
                  Remix
                </a>
              </td>
            </tr>
          {/each}
        </tbody>
      </table>
    </div>
  {/if}

  <!-- Watchlist & Alert Deduplication Drawer / Modal (Acceptance Target 2) -->
  {#if isWatchlistDrawerOpen}
    <div
      class="fixed inset-0 z-50 bg-[#242924]/50 backdrop-blur-xs flex justify-end"
      role="dialog"
      aria-modal="true"
      data-testid="watchlist-drawer"
    >
      <div class="w-full max-w-md bg-[#ffffff] h-full shadow-2xl flex flex-col justify-between overflow-y-auto p-6 space-y-6">
        <div>
          <!-- Drawer Header -->
          <div class="flex items-center justify-between border-b border-[#e7e2d7] pb-4">
            <div>
              <h2 class="text-lg font-bold text-[#242924]">Watchlist & Cảnh báo bứt phá</h2>
              <p class="text-xs text-[#616c63]">Tenant: {currentWorkspaceId}</p>
            </div>
            <button
              type="button"
              onclick={() => (isWatchlistDrawerOpen = false)}
              class="rounded p-1 text-[#616c63] hover:bg-[#e7e2d7] text-sm"
              aria-label="Đóng ngăn"
            >
              ✕
            </button>
          </div>

          <!-- Alert Storm Notification Banner -->
          {#if alertStormNotification}
            <div class="mt-4 rounded-md bg-[#fbeee9] border border-[#d94a31] p-3 text-xs text-[#d94a31]" role="alert">
              <span class="font-bold">🌪️ BÃO CẢNH BÁO:</span> {alertStormNotification}
            </div>
          {/if}

          <!-- Watchlist Configuration -->
          <div class="mt-4 space-y-4">
            <div>
              <label for="wl-name" class="block text-xs font-semibold text-[#242924] mb-1">
                Tên danh sách theo dõi
              </label>
              <input
                id="wl-name"
                type="text"
                bind:value={activeWatchlist.name}
                class="w-full rounded border border-[#e7e2d7] bg-[#fbf9f5] px-3 py-1.5 text-xs text-[#242924]"
              />
            </div>

            <!-- Thresholds for Deduplicated Alerts -->
            <div class="rounded-lg bg-[#fbf9f5] border border-[#e7e2d7] p-3 space-y-3">
              <h4 class="text-xs font-bold text-[#274333]">Cài đặt ngưỡng kích hoạt cảnh báo</h4>

              <div>
                <label for="vel-thresh" class="flex justify-between text-xs text-[#242924]">
                  <span>Ngưỡng tốc độ (Velocity) tối thiểu</span>
                  <span class="font-bold">{activeWatchlist.minVelocityThreshold}%</span>
                </label>
                <input
                  id="vel-thresh"
                  type="range"
                  min="50"
                  max="95"
                  step="5"
                  bind:value={activeWatchlist.minVelocityThreshold}
                  class="w-full mt-1"
                />
              </div>

              <div>
                <label for="cooldown" class="flex justify-between text-xs text-[#242924]">
                  <span>Thời gian chờ khử trùng lặp (Cooldown)</span>
                  <span class="font-bold">{activeWatchlist.cooldownMinutes} phút</span>
                </label>
                <input
                  id="cooldown"
                  type="number"
                  min="10"
                  max="1440"
                  bind:value={activeWatchlist.cooldownMinutes}
                  class="w-full rounded border border-[#e7e2d7] bg-[#ffffff] px-2 py-1 text-xs mt-1"
                />
                <p class="text-[10px] text-[#616c63] mt-0.5">
                  Các vi phạm cùng xu hướng trong khoảng thời gian này sẽ được deduplicate tự động (Target 2).
                </p>
              </div>
            </div>

            <!-- Simulation Controls -->
            <div class="pt-2 flex flex-col gap-2">
              <button
                type="button"
                onclick={() => runWatchlistAlertEvaluation(false)}
                class="w-full rounded-md bg-[#274333] py-2 px-3 text-xs font-semibold text-[#fbf9f5] hover:bg-[#1f3528]"
                data-testid="evaluate-alerts-btn"
              >
                ⚡ Quét cảnh báo ngay
              </button>

              <button
                type="button"
                onclick={() => runWatchlistAlertEvaluation(true)}
                class="w-full rounded-md border border-[#d94a31] bg-[#fbeee9] py-1.5 px-3 text-xs font-semibold text-[#d94a31] hover:bg-[#f6dfd8]"
                data-testid="simulate-storm-btn"
              >
                🌪️ Giả lập bão cảnh báo (>5 vi phạm đồng thời)
              </button>
            </div>

            <!-- Deduplication Evidence Stats -->
            <div class="rounded-md border border-[#e7e2d7] bg-[#f4f0e8] p-3 text-xs space-y-1">
              <div class="flex justify-between">
                <span class="text-[#616c63]">Cảnh báo đã phát:</span>
                <span class="font-bold text-[#242924]">{emittedAlerts.length}</span>
              </div>
              <div class="flex justify-between">
                <span class="text-[#616c63]">Cảnh báo bị khử trùng lặp (Suppressed):</span>
                <span class="font-bold text-[#d94a31]">{suppressedAlertsCount}</span>
              </div>
            </div>

            <!-- Emitted Alerts Log -->
            <div class="space-y-2">
              <h4 class="text-xs font-bold text-[#242924]">Nhật ký cảnh báo gần nhất</h4>
              {#if emittedAlerts.length === 0}
                <p class="text-xs text-[#616c63] italic">Chưa có cảnh báo nào được kích hoạt.</p>
              {:else}
                <div class="max-h-60 overflow-y-auto space-y-2 pr-1">
                  {#each emittedAlerts as alert}
                    <div class="rounded border border-[#e7e2d7] bg-[#ffffff] p-2.5 text-xs shadow-2xs">
                      <div class="flex items-center justify-between">
                        <span class="font-bold text-[#242924] truncate">{alert.trendTitle}</span>
                        {#if alert.isBatchedSummary}
                          <span class="rounded bg-[#fbeee9] px-1.5 py-0.5 text-[10px] font-bold text-[#d94a31]">
                            GỘP {alert.batchedAlertCount} BÁO ĐỘNG
                          </span>
                        {/if}
                      </div>
                      <p class="text-[11px] text-[#616c63] mt-0.5">
                        Chỉ số: {alert.metricName} = {alert.actualValue}% (Ngưỡng: {alert.thresholdValue}%)
                      </p>
                      <p class="text-[10px] font-mono text-[#616c63] mt-0.5 truncate">
                        Fingerprint: {alert.fingerprint}
                      </p>
                    </div>
                  {/each}
                </div>
              {/if}
            </div>
          </div>
        </div>

        <button
          type="button"
          onclick={() => (isWatchlistDrawerOpen = false)}
          class="w-full rounded-md border border-[#e7e2d7] bg-[#f4f0e8] py-2 text-xs font-semibold text-[#242924] hover:bg-[#e7e2d7]"
        >
          Đóng ngăn
        </button>
      </div>
    </div>
  {/if}

  <!-- Downstream Intelligence Modules (M03, M04) -->
  <div class="pt-6 border-t border-[#e7e2d7] space-y-4">
    <div class="flex items-center justify-between">
      <div>
        <h2 class="text-base font-bold text-[#242924]">Hệ sinh thái Intelligence tiếp nối</h2>
        <p class="text-xs text-[#616c63]">Các module M03 và M04 tích hợp dữ liệu từ Trend Fusion Radar (M02).</p>
      </div>
    </div>

    <div class="grid grid-cols-1 gap-5 md:grid-cols-2">
      <!-- Card 2: Competitor Intelligence -->
      <JobCard
        title="Nghiên cứu đối thủ"
        moduleTag="M03"
        isUnavailable={true}
        description="Theo dõi chiến lược nội dung, sản phẩm chủ lực và cấu trúc giá của các nhà bán hàng cùng ngành."
      >
        <div class="space-y-2">
          <p class="text-xs text-[#616c63]">
            Hồ sơ đối thủ: <span class="font-mono text-[#616c63]">0 hồ sơ được kích hoạt</span>
          </p>
          <button
            type="button"
            disabled
            class="w-full cursor-not-allowed rounded-md bg-[#e7e2d7] py-2 px-3 text-xs font-medium text-[#616c63]"
          >
            Thêm đối thủ theo dõi (Khả dụng Phase P3)
          </button>
        </div>
      </JobCard>

      <!-- Card 3: Opportunity Board -->
      <JobCard
        title="Bảng cơ hội (Opportunity Board)"
        moduleTag="M04"
        isUnavailable={true}
        description="Chấm điểm tiềm năng kinh doanh dựa trên biên lợi nhuận kỳ vọng và mức độ cạnh tranh."
      >
        <div class="space-y-2">
          <p class="text-xs text-[#616c63]">
            Tích hợp M02: <span class="font-mono text-[#274333]">Sẵn sàng tiếp nhận Trend Conversion</span>
          </p>
          <button
            type="button"
            disabled
            class="w-full cursor-not-allowed rounded-md bg-[#e7e2d7] py-2 px-3 text-xs font-medium text-[#616c63]"
          >
            Bảng Kanban cơ hội (Khả dụng Phase P4)
          </button>
        </div>
      </JobCard>
    </div>
  </div>
</div>

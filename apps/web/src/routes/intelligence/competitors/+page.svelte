<script lang="ts">
  import {
    filterAndSearchCompetitors,
    formatCompactNumber,
    formatPercent,
    evaluateStaleness,
    generateBenchmarkWhyExplanation,
    evaluateContinuousMonitoringAlert,
    type CompetitorItem,
    type CompetitorSuggestion,
    type WhyExplanation,
    type MonitoringSourceStatus
  } from '$lib/competitor';
  import CompetitorWhyDrawer from '$lib/competitor/CompetitorWhyDrawer.svelte';

  // Workspace tenant context
  const currentWorkspaceId = 'ws-current-tenant';

  // State: Tracked Competitors Seed Data
  let competitors = $state<CompetitorItem[]>([
    {
      id: 'comp-001',
      workspaceId: currentWorkspaceId,
      name: 'Skincare Queen VN',
      platform: 'TikTok',
      handle: '@skincare_queen',
      category: 'Làm đẹp / Skincare',
      notes: 'Đối thủ trực tiếp về các dòng serum và phục hồi da dầu mụn',
      relevanceScore: 92,
      relevanceReason: 'Cùng phân khúc sản phẩm, trùng lặp 78% tệp khán giả mục tiêu 18-28 tuổi',
      followersCount: 245000,
      videoCount30d: 48,
      avgViews: 120000,
      growthRate30d: 14.2,
      avgEngagementRate: 9.5,
      postingFrequencyPerDay: 2.3,
      lastPostAt: '6 giờ trước',
      status: 'tracking',
      avatarUrl: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=100&h=100&fit=crop'
    },
    {
      id: 'comp-002',
      workspaceId: currentWorkspaceId,
      name: 'Beauty Guru Official',
      platform: 'Instagram',
      handle: '@beauty_guru99',
      category: 'Làm đẹp / Mỹ phẩm',
      notes: 'Tập trung hình ảnh aesthetic và reels ngắn review tone giọng chuyên gia',
      relevanceScore: 78,
      relevanceReason: 'Cùng ngành hàng mỹ phẩm, phong cách quay dựng tối giản cao cấp',
      followersCount: 180000,
      videoCount30d: 32,
      avgViews: 85000,
      growthRate30d: 8.0,
      avgEngagementRate: 5.2,
      postingFrequencyPerDay: 1.1,
      lastPostAt: '1 ngày trước',
      status: 'tracking',
      avatarUrl: 'https://images.unsplash.com/photo-1517841905240-472988babdf9?w=100&h=100&fit=crop'
    },
    {
      id: 'comp-003',
      workspaceId: currentWorkspaceId,
      name: 'Gia Dụng Bếp Thông Minh',
      platform: 'TikTok',
      handle: '@smart_kitchen_vn',
      category: 'Đời sống / Gia dụng',
      notes: 'Thường xuyên livestream buổi tối với deal shock',
      relevanceScore: 84,
      relevanceReason: 'Nội dung thực tế đánh trúng tâm lý người nội trợ hiện đại',
      followersCount: 310000,
      videoCount30d: 65,
      avgViews: 155000,
      growthRate30d: 18.5,
      avgEngagementRate: 7.8,
      postingFrequencyPerDay: 3.1,
      lastPostAt: '2 ngày trước',
      status: 'tracking',
      avatarUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100&h=100&fit=crop'
    }
  ]);

  // AI Suggestions State
  let suggestions = $state<CompetitorSuggestion[]>([
    {
      id: 'sug-001',
      name: 'Bác Sĩ Da Liễu Hữu Cơ',
      platform: 'TikTok',
      handle: '@dr_organic_skin',
      followersCount: 95000,
      relevanceScore: 89,
      relevanceReason: 'Cùng phân tích thành phần mỹ phẩm hữu cơ, tốc độ tăng trưởng nhanh trong 30 ngày qua (+24%).'
    },
    {
      id: 'sug-002',
      name: 'Review Mê Ly Cosmetics',
      platform: 'YouTube',
      handle: '@review_mely',
      followersCount: 140000,
      relevanceScore: 74,
      relevanceReason: 'Tập trung video so sánh sản phẩm trước - sau, tỷ lệ bình luận hỏi mua hàng cao.'
    }
  ]);

  // Filters State
  let searchQuery = $state('');
  let selectedPlatform = $state('all');
  let selectedCategory = $state('all');

  // Filtered List
  let visibleCompetitors = $derived(
    filterAndSearchCompetitors(competitors, {
      query: searchQuery,
      platform: selectedPlatform,
      category: selectedCategory
    })
  );

  // Add Modal State
  let isAddModalOpen = $state(false);
  let newPlatform = $state<'TikTok' | 'Instagram' | 'YouTube' | 'Shopee'>('TikTok');
  let newHandle = $state('');
  let newName = $state('');
  let newCategory = $state('Làm đẹp / Skincare');
  let newNotes = $state('');
  let addError = $state('');

  // Why Drawer State (Acceptance Target 1)
  let isWhyDrawerOpen = $state(false);
  let whyDrawerTitle = $state('');
  let activeWhyExplanation = $state<WhyExplanation | null>(null);

  // Alert Modal State
  let isAlertModalOpen = $state(false);
  let activeAlertCompetitor = $state<CompetitorItem | null>(null);
  let alertMetric = $state('engagement_rate');
  let alertThreshold = $state(10);
  let alertMinInterval = $state(60);
  let alertSuccessMessage = $state('');

  // P8-07 Target 1: Continuous Monitoring Source Status & Simulation
  let alertSourceAvailable = $state(true);
  let monitoringSourceStatus = $derived<MonitoringSourceStatus>(alertSourceAvailable ? 'ACTIVE' : 'PAUSED');
  let simulatedDropAlert = $derived(
    activeAlertCompetitor
      ? evaluateContinuousMonitoringAlert(
          {
            competitorId: activeAlertCompetitor.id,
            metric: alertMetric,
            thresholdPercent: alertThreshold,
            sourceStatus: monitoringSourceStatus,
            recoveryLatched: false,
            insufficientData: false
          },
          100, // Previous benchmark value
          60,  // Current benchmark value (40% drop)
          'snap-simulated-01',
          alertSourceAvailable
        )
      : null
  );

  // Handlers
  function openWhyDrawer(comp: CompetitorItem) {
    whyDrawerTitle = `Giải thích suy luận AI: ${comp.name} (${comp.handle})`;
    activeWhyExplanation = generateBenchmarkWhyExplanation(comp.name, comp.platform, comp.videoCount30d);
    isWhyDrawerOpen = true;
  }

  function handleAddCompetitor(e: Event) {
    e.preventDefault();
    addError = '';

    const cleanHandle = newHandle.trim().startsWith('@') ? newHandle.trim() : `@${newHandle.trim()}`;
    if (!cleanHandle || cleanHandle.length < 3) {
      addError = 'Vui lòng nhập handle hợp lệ (ví dụ: @ten_kenh)';
      return;
    }

    // Check duplicate
    if (competitors.some((c) => c.handle.toLowerCase() === cleanHandle.toLowerCase())) {
      addError = `Đã theo dõi đối thủ ${cleanHandle}. Không thể thêm trùng lặp.`;
      return;
    }

    if (competitors.length >= 50) {
      addError = 'Đã đạt giới hạn tối đa 50 đối thủ được theo dõi trong gói này.';
      return;
    }

    const newComp: CompetitorItem = {
      id: `comp-${Date.now()}`,
      workspaceId: currentWorkspaceId,
      name: newName.trim() || cleanHandle.replace('@', ''),
      platform: newPlatform,
      handle: cleanHandle,
      category: newCategory,
      notes: newNotes.trim(),
      relevanceScore: Math.floor(75 + Math.random() * 20),
      relevanceReason: 'Đối thủ mới được đăng ký thủ công vào danh sách theo dõi phân tích.',
      followersCount: 50000 + Math.floor(Math.random() * 100000),
      videoCount30d: 20 + Math.floor(Math.random() * 20),
      avgViews: 40000 + Math.floor(Math.random() * 60000),
      growthRate30d: +(Math.random() * 15).toFixed(1),
      avgEngagementRate: +(4 + Math.random() * 6).toFixed(1),
      postingFrequencyPerDay: +(1 + Math.random() * 2).toFixed(1),
      lastPostAt: 'Mới cập nhật',
      status: 'tracking'
    };

    competitors = [newComp, ...competitors];
    isAddModalOpen = false;
    newHandle = '';
    newName = '';
    newNotes = '';
  }

  function handleRemoveCompetitor(id: string) {
    if (confirm('Bạn có chắc chắn muốn ngừng theo dõi đối thủ này?')) {
      competitors = competitors.filter((c) => c.id !== id);
    }
  }

  function handleAcceptSuggestion(sug: CompetitorSuggestion) {
    const newComp: CompetitorItem = {
      id: `comp-${Date.now()}`,
      workspaceId: currentWorkspaceId,
      name: sug.name,
      platform: sug.platform,
      handle: sug.handle,
      category: 'Làm đẹp & Chăm sóc cá nhân',
      notes: 'Thêm từ gợi ý AI',
      relevanceScore: sug.relevanceScore,
      relevanceReason: sug.relevanceReason,
      followersCount: sug.followersCount,
      videoCount30d: 28,
      avgViews: 65000,
      growthRate30d: 11.4,
      avgEngagementRate: 8.1,
      postingFrequencyPerDay: 1.4,
      lastPostAt: 'Hôm nay',
      status: 'tracking'
    };

    competitors = [...competitors, newComp];
    suggestions = suggestions.filter((s) => s.id !== sug.id);
  }

  function handleDismissSuggestion(id: string) {
    suggestions = suggestions.filter((s) => s.id !== id);
  }

  function openAlertModal(comp: CompetitorItem) {
    activeAlertCompetitor = comp;
    isAlertModalOpen = true;
    alertSuccessMessage = '';
  }

  function saveAlertConfig() {
    if (!activeAlertCompetitor) return;
    const compId = activeAlertCompetitor.id;

    // Minimum interval 60 minutes per §27.3
    const interval = Math.max(60, alertMinInterval);

    competitors = competitors.map((c) =>
      c.id === compId
        ? {
            ...c,
            alertConfig: {
              enabled: true,
              metric: alertMetric,
              threshold: alertThreshold,
              minIntervalMinutes: interval
            }
          }
        : c
    );

    alertSuccessMessage = `Đã cài đặt cảnh báo cho ${activeAlertCompetitor.handle}. Khoảng cách tối thiểu: ${interval} phút.`;
    setTimeout(() => {
      isAlertModalOpen = false;
      alertSuccessMessage = '';
    }, 1500);
  }
</script>

<div class="space-y-6">
  <!-- Page Header -->
  <div class="flex flex-col gap-4 sm:flex-row sm:items-center sm:justify-between border-b border-[#e7e2d7] pb-5">
    <div>
      <div class="flex items-center gap-2">
        <h1 class="text-xl font-bold text-[#242924] sm:text-2xl" data-testid="page-title">
          🏆 Danh bạ đối thủ cạnh tranh
        </h1>
        <span class="rounded bg-[#274333] px-2 py-0.5 text-[11px] font-semibold text-[#fbf9f5]">
          M03
        </span>
      </div>
      <p class="text-xs text-[#616c63] mt-1">
        Theo dõi tài khoản đối thủ, chấm điểm độ tương quan AI và chuẩn bị dữ liệu so sánh benchmark đa nền tảng.
      </p>
    </div>

    <div class="flex items-center gap-2.5">
      <a
        href="/intelligence/benchmarks"
        class="inline-flex items-center gap-1.5 rounded-lg border border-[#274333] bg-[#ffffff] px-3.5 py-2 text-xs font-semibold text-[#274333] hover:bg-[#eef3f0] transition-colors shadow-xs"
        data-testid="benchmark-link"
      >
        <span>📊 So sánh Benchmark</span>
        <span>→</span>
      </a>

      <button
        type="button"
        onclick={() => (isAddModalOpen = true)}
        class="inline-flex items-center gap-1.5 rounded-lg bg-[#274333] px-4 py-2 text-xs font-semibold text-[#fbf9f5] hover:bg-[#1f3529] transition-colors shadow-xs"
        data-testid="add-competitor-button"
      >
        <span>+</span>
        <span>Thêm đối thủ</span>
      </button>
    </div>
  </div>

  <!-- Filter & Search Bar -->
  <div class="rounded-xl border border-[#e7e2d7] bg-[#ffffff] p-4 shadow-xs">
    <div class="grid grid-cols-1 gap-3 sm:grid-cols-3">
      <!-- Search Input -->
      <div>
        <label for="search-input" class="block text-[11px] font-bold uppercase tracking-wider text-[#616c63] mb-1">
          🔍 Tìm kiếm
        </label>
        <input
          id="search-input"
          type="text"
          bind:value={searchQuery}
          placeholder="Tìm theo tên, handle, ghi chú..."
          class="w-full rounded-lg border border-[#e7e2d7] bg-[#fbf9f5] px-3 py-1.5 text-xs text-[#242924] focus:border-[#274333] focus:outline-none"
          data-testid="search-input"
        />
      </div>

      <!-- Platform Filter -->
      <div>
        <label for="platform-filter" class="block text-[11px] font-bold uppercase tracking-wider text-[#616c63] mb-1">
          🌐 Nền tảng
        </label>
        <select
          id="platform-filter"
          bind:value={selectedPlatform}
          class="w-full rounded-lg border border-[#e7e2d7] bg-[#fbf9f5] px-3 py-1.5 text-xs text-[#242924] focus:border-[#274333] focus:outline-none"
          data-testid="platform-filter"
        >
          <option value="all">Tất cả nền tảng</option>
          <option value="TikTok">TikTok</option>
          <option value="Instagram">Instagram</option>
          <option value="YouTube">YouTube</option>
          <option value="Shopee">Shopee</option>
        </select>
      </div>

      <!-- Category Filter -->
      <div>
        <label for="category-filter" class="block text-[11px] font-bold uppercase tracking-wider text-[#616c63] mb-1">
          🏷️ Ngành hàng
        </label>
        <select
          id="category-filter"
          bind:value={selectedCategory}
          class="w-full rounded-lg border border-[#e7e2d7] bg-[#fbf9f5] px-3 py-1.5 text-xs text-[#242924] focus:border-[#274333] focus:outline-none"
          data-testid="category-filter"
        >
          <option value="all">Tất cả ngành hàng</option>
          <option value="Làm đẹp">Làm đẹp / Mỹ phẩm</option>
          <option value="Gia dụng">Đời sống / Gia dụng</option>
          <option value="Thời trang">Thời trang & Phụ kiện</option>
        </select>
      </div>
    </div>
  </div>

  <!-- Tracked Competitor List -->
  <div class="space-y-4">
    <div class="flex items-center justify-between">
      <h2 class="text-sm font-bold text-[#242924]">
        Đang theo dõi ({visibleCompetitors.length} / {competitors.length})
      </h2>
      <span class="text-[11px] text-[#616c63]">
        Giới hạn theo dõi: 50 đối thủ
      </span>
    </div>

    {#if visibleCompetitors.length === 0}
      <div class="rounded-xl border border-dashed border-[#e7e2d7] bg-[#ffffff] p-8 text-center" data-testid="empty-competitors">
        <p class="text-sm font-semibold text-[#242924]">Không tìm thấy đối thủ phù hợp bộ lọc</p>
        <p class="text-xs text-[#616c63] mt-1">Thử thay đổi từ khóa tìm kiếm hoặc bấm "Thêm đối thủ" để mở rộng theo dõi.</p>
      </div>
    {:else}
      <div class="grid grid-cols-1 gap-4 lg:grid-cols-2" data-testid="competitor-list">
        {#each visibleCompetitors as comp (comp.id)}
          <div
            class="flex flex-col justify-between rounded-xl border border-[#e7e2d7] bg-[#ffffff] p-5 shadow-xs hover:border-[#274333]/40 transition-colors"
            data-testid="competitor-card"
          >
            <div>
              <!-- Top Row: Avatar, Handle, Platform, Status -->
              <div class="flex items-start justify-between gap-3">
                <div class="flex items-center gap-3">
                  <div class="h-11 w-11 shrink-0 overflow-hidden rounded-full border border-[#e7e2d7] bg-[#f4f0e8] flex items-center justify-center text-sm font-bold text-[#274333]">
                    {#if comp.avatarUrl}
                      <img src={comp.avatarUrl} alt={comp.name} class="h-full w-full object-cover" />
                    {:else}
                      {comp.name.slice(0, 2).toUpperCase()}
                    {/if}
                  </div>
                  <div>
                    <div class="flex items-center gap-2">
                      <h3 class="text-sm font-bold text-[#242924]">{comp.name}</h3>
                      <span class="rounded bg-[#eef3f0] px-1.5 py-0.5 text-[10px] font-semibold text-[#274333]">
                        {comp.platform}
                      </span>
                    </div>
                    <p class="text-xs font-mono text-[#616c63]">{comp.handle}</p>
                  </div>
                </div>

                <span class="inline-flex items-center gap-1 rounded-full bg-[#eaf4ed] px-2.5 py-0.5 text-[11px] font-semibold text-[#274333] border border-[#274333]/20">
                  <span class="h-1.5 w-1.5 rounded-full bg-[#274333]"></span>
                  Đang theo dõi
                </span>
              </div>

              <!-- Metrics Row -->
              <div class="mt-4 grid grid-cols-3 gap-2 rounded-lg bg-[#fbf9f5] p-3 border border-[#e7e2d7]/60 text-center">
                <div>
                  <span class="block text-[10px] uppercase font-bold text-[#616c63]">Followers</span>
                  <span class="text-xs font-bold text-[#242924]">{formatCompactNumber(comp.followersCount)}</span>
                </div>
                <div>
                  <span class="block text-[10px] uppercase font-bold text-[#616c63]">Video 30 ngày</span>
                  <span class="text-xs font-bold text-[#242924]">{comp.videoCount30d}</span>
                </div>
                <div>
                  <span class="block text-[10px] uppercase font-bold text-[#616c63]">Views trung bình</span>
                  <span class="text-xs font-bold text-[#242924]">{formatCompactNumber(comp.avgViews)}</span>
                </div>
              </div>

              <!-- Growth & Engagement Row -->
              <div class="mt-3 flex items-center justify-between text-xs px-1">
                <div>
                  <span class="text-[#616c63]">Tăng trưởng 30d: </span>
                  <span class="font-bold text-[#274333]">{formatPercent(comp.growthRate30d)}</span>
                </div>
                <div>
                  <span class="text-[#616c63]">Tỷ lệ tương tác: </span>
                  <span class="font-bold text-[#242924]">{comp.avgEngagementRate}%</span>
                </div>
                <div>
                  <span class="text-[#616c63]">Tần suất: </span>
                  <span class="font-semibold text-[#242924]">{comp.postingFrequencyPerDay}/ngày</span>
                </div>
              </div>

              <!-- AI Relevance Score with "Why" Trigger (Acceptance Target 1) -->
              <div class="mt-3 rounded-lg border border-[#fef08a] bg-[#fefce8] p-3 text-xs">
                <div class="flex items-center justify-between">
                  <div class="flex items-center gap-1.5">
                    <span class="text-amber-500">⭐</span>
                    <span class="font-bold text-[#854d0e]">Độ tương quan AI: {comp.relevanceScore}/100</span>
                    <span class="rounded bg-[#fef08a] px-1.5 py-0.2 text-[10px] font-semibold text-[#854d0e]">
                      INFERRED
                    </span>
                  </div>

                  <button
                    type="button"
                    onclick={() => openWhyDrawer(comp)}
                    class="text-[11px] font-semibold text-[#854d0e] underline hover:text-[#713f12]"
                    data-testid="why-drawer-trigger"
                  >
                    Xem lý do (Why?) →
                  </button>
                </div>
                <p class="text-[11px] text-[#713f12] mt-1 italic leading-relaxed">
                  "{comp.relevanceReason}"
                </p>
              </div>

              {#if comp.notes}
                <p class="mt-2 text-[11px] text-[#616c63] italic px-1">
                  📝 Ghi chú: {comp.notes}
                </p>
              {/if}
            </div>

            <!-- Actions Footer -->
            <div class="mt-4 flex items-center justify-between border-t border-[#e7e2d7] pt-3">
              <span class="text-[10px] text-[#616c63]">Đăng gần nhất: {comp.lastPostAt}</span>

              <div class="flex items-center gap-2">
                <a
                  href={`/intelligence/benchmarks?comp=${comp.id}`}
                  class="rounded-md bg-[#eef3f0] px-2.5 py-1 text-xs font-semibold text-[#274333] hover:bg-[#d8e7df] transition-colors"
                >
                  📊 So sánh
                </a>
                <button
                  type="button"
                  onclick={() => openAlertModal(comp)}
                  class="rounded-md border border-[#e7e2d7] px-2 py-1 text-xs font-medium text-[#616c63] hover:text-[#242924] hover:bg-[#f4f0e8] transition-colors"
                  title="Cài đặt cảnh báo biến động"
                >
                  🔔 Cảnh báo
                </button>
                <button
                  type="button"
                  onclick={() => handleRemoveCompetitor(comp.id)}
                  class="rounded-md px-2 py-1 text-xs font-medium text-[#d94a31] hover:bg-[#fdf5f3] transition-colors"
                  title="Gỡ khỏi theo dõi"
                >
                  ❌ Gỡ
                </button>
              </div>
            </div>
          </div>
        {/each}
      </div>
    {/if}
  </div>

  <!-- AI Suggested Competitors Section -->
  {#if suggestions.length > 0}
    <div class="rounded-xl border border-[#e7e2d7] bg-[#ffffff] p-5 shadow-xs space-y-4" data-testid="suggestions-section">
      <div class="flex items-center justify-between">
        <div class="flex items-center gap-2">
          <span class="text-base">🤖</span>
          <h2 class="text-sm font-bold text-[#242924]">Gợi ý đối thủ tiềm năng từ AI</h2>
          <span class="rounded bg-[#fef9c3] px-2 py-0.5 text-[10px] font-semibold text-[#854d0e] border border-[#854d0e]/20">
            Smart Discovery
          </span>
        </div>
        <span class="text-xs text-[#616c63]">Dựa trên ngành hàng và tập khán giả tương tự</span>
      </div>

      <div class="grid grid-cols-1 gap-3 sm:grid-cols-2">
        {#each suggestions as sug (sug.id)}
          <div class="flex flex-col justify-between rounded-lg border border-[#e7e2d7] bg-[#fbf9f5] p-4 text-xs">
            <div>
              <div class="flex items-center justify-between">
                <div>
                  <span class="font-bold text-[#242924]">{sug.name}</span>
                  <span class="text-[#616c63] font-mono ml-1">{sug.handle}</span>
                </div>
                <span class="rounded bg-[#ffffff] px-1.5 py-0.5 text-[10px] font-semibold text-[#274333] border border-[#e7e2d7]">
                  {sug.platform}
                </span>
              </div>
              <p class="text-[11px] text-[#616c63] mt-1">{formatCompactNumber(sug.followersCount)} người theo dõi</p>
              <p class="text-[11px] text-[#274333] mt-2 font-medium bg-[#eef3f0] p-2 rounded">
                💡 {sug.relevanceReason}
              </p>
            </div>

            <div class="mt-3 flex items-center justify-end gap-2 border-t border-[#e7e2d7] pt-2.5">
              <button
                type="button"
                onclick={() => handleDismissSuggestion(sug.id)}
                class="rounded px-2.5 py-1 text-xs text-[#616c63] hover:text-[#242924] hover:bg-[#e7e2d7]"
              >
                Bỏ qua
              </button>
              <button
                type="button"
                onclick={() => handleAcceptSuggestion(sug)}
                class="rounded bg-[#274333] px-3 py-1 text-xs font-semibold text-[#fbf9f5] hover:bg-[#1f3529]"
              >
                + Thêm theo dõi
              </button>
            </div>
          </div>
        {/each}
      </div>
    </div>
  {/if}

  <!-- Add Competitor Modal -->
  {#if isAddModalOpen}
    <div
      class="fixed inset-0 z-50 flex items-center justify-center bg-black/40 backdrop-blur-xs p-4"
      role="dialog"
      aria-modal="true"
      aria-labelledby="add-modal-title"
    >
      <div class="w-full max-w-md rounded-xl border border-[#e7e2d7] bg-[#ffffff] p-6 shadow-2xl">
        <div class="flex items-center justify-between border-b border-[#e7e2d7] pb-3 mb-4">
          <h2 id="add-modal-title" class="text-base font-bold text-[#242924]">
            ➕ Thêm đối thủ theo dõi
          </h2>
          <button
            type="button"
            onclick={() => (isAddModalOpen = false)}
            class="text-[#616c63] hover:text-[#242924] text-sm"
          >
            ✕
          </button>
        </div>

        {#if addError}
          <div class="mb-4 rounded-lg border border-[#d94a31]/20 bg-[#fdf5f3] p-3 text-xs text-[#d94a31]">
            {addError}
          </div>
        {/if}

        <form onsubmit={handleAddCompetitor} class="space-y-4 text-xs">
          <div>
            <label for="modal-platform" class="block font-bold text-[#242924] mb-1">Nền tảng</label>
            <select
              id="modal-platform"
              bind:value={newPlatform}
              class="w-full rounded-lg border border-[#e7e2d7] bg-[#fbf9f5] p-2 text-xs focus:border-[#274333] focus:outline-none"
            >
              <option value="TikTok">TikTok</option>
              <option value="Instagram">Instagram</option>
              <option value="YouTube">YouTube</option>
              <option value="Shopee">Shopee</option>
            </select>
          </div>

          <div>
            <label for="modal-handle" class="block font-bold text-[#242924] mb-1">Handle / Tên kênh (@handle)</label>
            <input
              id="modal-handle"
              type="text"
              bind:value={newHandle}
              placeholder="@skincare_queen"
              class="w-full rounded-lg border border-[#e7e2d7] bg-[#fbf9f5] p-2 text-xs focus:border-[#274333] focus:outline-none font-mono"
              required
            />
          </div>

          <div>
            <label for="modal-name" class="block font-bold text-[#242924] mb-1">Tên hiển thị (Tùy chọn)</label>
            <input
              id="modal-name"
              type="text"
              bind:value={newName}
              placeholder="Skincare Queen"
              class="w-full rounded-lg border border-[#e7e2d7] bg-[#fbf9f5] p-2 text-xs focus:border-[#274333] focus:outline-none"
            />
          </div>

          <div>
            <label for="modal-notes" class="block font-bold text-[#242924] mb-1">Ghi chú riêng tư (Chỉ nội bộ)</label>
            <textarea
              id="modal-notes"
              bind:value={newNotes}
              rows="2"
              placeholder="Theo dõi dòng video so sánh giá..."
              class="w-full rounded-lg border border-[#e7e2d7] bg-[#fbf9f5] p-2 text-xs focus:border-[#274333] focus:outline-none"
            ></textarea>
          </div>

          <div class="flex items-center justify-end gap-2 border-t border-[#e7e2d7] pt-4">
            <button
              type="button"
              onclick={() => (isAddModalOpen = false)}
              class="rounded-lg border border-[#e7e2d7] px-4 py-2 font-medium text-[#616c63] hover:bg-[#f4f0e8]"
            >
              Hủy
            </button>
            <button
              type="submit"
              class="rounded-lg bg-[#274333] px-4 py-2 font-semibold text-[#fbf9f5] hover:bg-[#1f3529]"
            >
              Lưu đối thủ
            </button>
          </div>
        </form>
      </div>
    </div>
  {/if}

  <!-- Alert Config Modal (§27.3) -->
  {#if isAlertModalOpen && activeAlertCompetitor}
    <div
      class="fixed inset-0 z-50 flex items-center justify-center bg-black/40 backdrop-blur-xs p-4"
      role="dialog"
      aria-modal="true"
      aria-labelledby="alert-modal-title"
    >
      <div class="w-full max-w-md rounded-xl border border-[#e7e2d7] bg-[#ffffff] p-6 shadow-2xl text-xs">
        <div class="flex items-center justify-between border-b border-[#e7e2d7] pb-3 mb-4">
          <h2 id="alert-modal-title" class="text-sm font-bold text-[#242924]">
            🔔 Cài đặt cảnh báo: {activeAlertCompetitor.handle}
          </h2>
          <button
            type="button"
            onclick={() => (isAlertModalOpen = false)}
            class="text-[#616c63] hover:text-[#242924]"
          >
            ✕
          </button>
        </div>

        {#if alertSuccessMessage}
          <div class="mb-4 rounded-lg bg-[#eaf4ed] p-3 text-[#274333] border border-[#274333]/20 font-semibold">
            {alertSuccessMessage}
          </div>
        {/if}

        <!-- P8-07 Target 1: Source Access Status & Paused/Import Path -->
        <div class="p-3 rounded-lg border border-[#e7e2d7] bg-[#fbf9f5] space-y-2">
          <div class="flex items-center justify-between">
            <span class="font-bold text-[#242924]">Trạng thái kết nối nguồn dữ liệu:</span>
            <span class="px-2 py-0.5 rounded text-[11px] font-bold uppercase {alertSourceAvailable ? 'bg-emerald-100 text-emerald-800' : 'bg-amber-100 text-amber-800'}">
              {monitoringSourceStatus}
            </span>
          </div>

          <div class="flex items-center justify-between text-[11px] text-[#616c63]">
            <span>Mô phỏng mất kết nối nguồn:</span>
            <button
              type="button"
              onclick={() => (alertSourceAvailable = !alertSourceAvailable)}
              class="px-2 py-1 rounded bg-[#e7e2d7] hover:bg-[#d5cfc2] font-semibold text-[#242924] transition"
            >
              {alertSourceAvailable ? 'Ngắt kết nối nguồn (Mất quyền)' : 'Khôi phục kết nối'}
            </button>
          </div>

          {#if !alertSourceAvailable}
            <div class="p-2 rounded bg-amber-50 border border-amber-200 text-amber-900 text-[11px] leading-relaxed">
              <strong>Target 1 (Không có quyền truy cập nguồn):</strong> Cảnh báo tự động tạm dừng (PAUSED). Hệ thống bảo toàn toàn bộ ảnh chụp benchmark lịch sử và chuyển sang quy trình nhập dữ liệu thủ công (Import path), không phát sinh cảnh báo tụt ảo.
            </div>
          {/if}

          {#if simulatedDropAlert}
            <div class="text-[10px] text-[#616c63] italic">
              Đánh giá: {simulatedDropAlert.reason}
            </div>
          {/if}
        </div>

        <div class="space-y-4">
          <div>
            <label for="alert-metric" class="block font-bold text-[#242924] mb-1">Chỉ số theo dõi</label>
            <select
              id="alert-metric"
              bind:value={alertMetric}
              class="w-full rounded-lg border border-[#e7e2d7] bg-[#fbf9f5] p-2"
            >
              <option value="engagement_rate">Tỷ lệ tương tác tăng đột biến</option>
              <option value="follower_growth">Tăng trưởng người theo dõi nhanh</option>
              <option value="viral_video">Video đạt ngưỡng triệu views</option>
            </select>
          </div>

          <div>
            <label for="alert-threshold" class="block font-bold text-[#242924] mb-1">Ngưỡng cảnh báo (%)</label>
            <input
              id="alert-threshold"
              type="number"
              bind:value={alertThreshold}
              min="1"
              max="100"
              class="w-full rounded-lg border border-[#e7e2d7] bg-[#fbf9f5] p-2"
            />
          </div>

          <div>
            <label for="alert-interval" class="block font-bold text-[#242924] mb-1">
              Khoảng cách gửi cảnh báo tối thiểu (phút, tối thiểu 60p per §27.3)
            </label>
            <input
              id="alert-interval"
              type="number"
              bind:value={alertMinInterval}
              min="60"
              class="w-full rounded-lg border border-[#e7e2d7] bg-[#fbf9f5] p-2"
            />
            <p class="text-[10px] text-[#616c63] mt-1">Giúp chống bão thông báo khi đối thủ có video viral.</p>
          </div>

          <div class="flex items-center justify-end gap-2 border-t border-[#e7e2d7] pt-4">
            <button
              type="button"
              onclick={() => (isAlertModalOpen = false)}
              class="rounded-lg border border-[#e7e2d7] px-4 py-2 text-[#616c63] hover:bg-[#f4f0e8]"
            >
              Đóng
            </button>
            <button
              type="button"
              onclick={saveAlertConfig}
              class="rounded-lg bg-[#274333] px-4 py-2 font-semibold text-[#fbf9f5] hover:bg-[#1f3529]"
            >
              Lưu cấu hình
            </button>
          </div>
        </div>
      </div>
    </div>
  {/if}

  <!-- Why Drawer Component (RULE-M03-001, RULE-M03-002) -->
  <CompetitorWhyDrawer
    isOpen={isWhyDrawerOpen}
    title={whyDrawerTitle}
    sourceClass="inferred"
    confidence="high"
    whyExplanation={activeWhyExplanation}
    onclose={() => (isWhyDrawerOpen = false)}
  />
</div>

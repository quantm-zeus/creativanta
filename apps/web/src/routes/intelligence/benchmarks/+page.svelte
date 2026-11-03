<script lang="ts">
  import {
    buildComparativeMetricsTable,
    evaluateStaleness,
    generateBenchmarkWhyExplanation,
    getCompetitorRevenueGuard,
    type MetricComparisonRow,
    type WhyExplanation,
    type WhiteSpaceGap
  } from '$lib/competitor';
  import CompetitorWhyDrawer from '$lib/competitor/CompetitorWhyDrawer.svelte';

  // Active user / workspace metrics
  const youMetrics = {
    name: 'Bạn (Kênh của tôi)',
    handle: '@my_studio_vn',
    followers: 125000,
    growth30d: 8.5,
    engagementRate: 9.8,
    avgViews: 45000,
    postsPerWeek: 14
  };

  // Selected competitors for benchmarking
  let competitorList = $state([
    {
      id: 'comp-001',
      name: 'Skincare Queen',
      handle: '@skincare_queen',
      platform: 'TikTok',
      followers: 245000,
      growth30d: 14.2,
      engagementRate: 7.5,
      avgViews: 120000,
      postsPerWeek: 16,
      avatarUrl: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=100&h=100&fit=crop'
    },
    {
      id: 'comp-002',
      name: 'Beauty Guru Official',
      handle: '@beauty_guru99',
      platform: 'Instagram',
      followers: 180000,
      growth30d: 6.8,
      engagementRate: 5.2,
      avgViews: 85000,
      postsPerWeek: 8,
      avatarUrl: 'https://images.unsplash.com/photo-1517841905240-472988babdf9?w=100&h=100&fit=crop'
    }
  ]);

  // Selected period
  let selectedPeriod = $state<'7d' | '30d' | '90d'>('30d');

  // Acceptance Target 2: Snapshot timestamp & Staleness evaluation
  // Initialized to 42 days ago to demonstrate stale snapshot detection on load
  let snapshotCapturedAt = $state<Date>(new Date(Date.now() - 42 * 24 * 60 * 60 * 1000));
  let staleness = $derived(evaluateStaleness(snapshotCapturedAt));

  // Acceptance Target 3: Revenue guard
  const revenueGuard = getCompetitorRevenueGuard();

  // Metrics Table Rows
  let comparisonRows = $derived<MetricComparisonRow[]>(
    buildComparativeMetricsTable(youMetrics, competitorList)
  );

  // Acceptance Target 1: White-space Gaps & AI Insight
  let whiteSpaceGaps = $state<WhiteSpaceGap[]>([
    {
      id: 'gap-001',
      title: 'Thiếu nội dung: Phân tích thành phần B5 phục hồi ban đêm',
      description: 'Cả 2 đối thủ đều tập trung vào kem chống nắng ban ngày. Lượng tìm kiếm serum phục hồi ban đêm tăng 120% nhưng đối thủ chưa có video tương ứng.',
      niche: 'Skincare / Chăm sóc phục hồi',
      potentialScore: 94,
      estimatedDemand: 'Rất cao (Trending +120%)',
      competitorSaturation: 'Rất thấp (0 video trong 14 ngày qua)',
      sourceClass: 'inferred',
      confidence: 'high',
      whyExplanation: generateBenchmarkWhyExplanation('Toàn thị trường ngách', 'TikTok & Shopee', 60)
    },
    {
      id: 'gap-002',
      title: 'Định dạng chưa khai thác: Thử thách 7 ngày cải thiện da mụn',
      description: 'Khán giả của @skincare_queen thường xuyên hỏi về routine thực tế theo ngày. Dạng nội dung serial challenge có tiềm năng viral cao.',
      niche: 'Vlog trải nghiệm / Serial Content',
      potentialScore: 88,
      estimatedDemand: 'Cao (+85%)',
      competitorSaturation: 'Thấp',
      sourceClass: 'inferred',
      confidence: 'medium',
      whyExplanation: generateBenchmarkWhyExplanation('Định dạng nội dung', 'TikTok', 45)
    }
  ]);

  // Why Drawer State (Acceptance Target 1)
  let isWhyDrawerOpen = $state(false);
  let whyDrawerTitle = $state('');
  let activeWhyExplanation = $state<WhyExplanation | null>(null);

  function openInsightWhyDrawer(title: string, why: WhyExplanation) {
    whyDrawerTitle = title;
    activeWhyExplanation = why;
    isWhyDrawerOpen = true;
  }

  function handleRefreshSnapshot() {
    // Refresh snapshot timestamp to now
    snapshotCapturedAt = new Date();
  }

  // Active chart metric for time-series
  let activeChartMetric = $state<'engagement' | 'views'>('engagement');
</script>

<div class="space-y-6">
  <!-- Page Header -->
  <div class="flex flex-col gap-4 sm:flex-row sm:items-center sm:justify-between border-b border-[#e7e2d7] pb-5">
    <div>
      <div class="flex items-center gap-2">
        <h1 class="text-xl font-bold text-[#242924] sm:text-2xl" data-testid="benchmark-page-title">
          📊 So sánh Benchmark đa đối thủ
        </h1>
        <span class="rounded bg-[#274333] px-2 py-0.5 text-[11px] font-semibold text-[#fbf9f5]">
          W041
        </span>
      </div>
      <p class="text-xs text-[#616c63] mt-1">
        Phân tích định vị hiệu suất so với đối thủ cùng ngành, tìm kiếm khoảng trống thị trường (White-Space) và phát hiện cơ hội bứt phá.
      </p>
    </div>

    <div class="flex items-center gap-2.5">
      <!-- Period Selector -->
      <div class="inline-flex rounded-lg border border-[#e7e2d7] bg-[#ffffff] p-0.5 text-xs">
        <button
          type="button"
          onclick={() => (selectedPeriod = '7d')}
          class="rounded-md px-3 py-1.5 font-medium transition-colors {selectedPeriod === '7d' ? 'bg-[#274333] text-[#fbf9f5]' : 'text-[#616c63] hover:text-[#242924]'}"
        >
          7 ngày
        </button>
        <button
          type="button"
          onclick={() => (selectedPeriod = '30d')}
          class="rounded-md px-3 py-1.5 font-medium transition-colors {selectedPeriod === '30d' ? 'bg-[#274333] text-[#fbf9f5]' : 'text-[#616c63] hover:text-[#242924]'}"
        >
          30 ngày
        </button>
        <button
          type="button"
          onclick={() => (selectedPeriod = '90d')}
          class="rounded-md px-3 py-1.5 font-medium transition-colors {selectedPeriod === '90d' ? 'bg-[#274333] text-[#fbf9f5]' : 'text-[#616c63] hover:text-[#242924]'}"
        >
          90 ngày
        </button>
      </div>

      <a
        href="/intelligence/competitors"
        class="inline-flex items-center gap-1.5 rounded-lg border border-[#e7e2d7] bg-[#ffffff] px-3.5 py-1.5 text-xs font-semibold text-[#242924] hover:bg-[#f4f0e8] transition-colors shadow-xs"
      >
        <span>⚙️ Quản lý đối thủ</span>
      </a>
    </div>
  </div>

  <!-- Acceptance Target 2: Stale Snapshots Visible Banner -->
  {#if staleness.isStale}
    <div
      class="rounded-xl border-2 border-[#d94a31] bg-[#fdf5f3] p-4 text-[#242924] shadow-sm animate-pulse-subtle"
      role="alert"
      data-testid="stale-snapshot-banner"
    >
      <div class="flex flex-col gap-3 sm:flex-row sm:items-center sm:justify-between">
        <div class="flex items-start gap-3">
          <span class="inline-flex h-8 w-8 shrink-0 items-center justify-center rounded-full bg-[#d94a31] text-sm font-bold text-[#fbf9f5]">
            ⚠️
          </span>
          <div>
            <div class="flex items-center gap-2">
              <span class="rounded bg-[#d94a31] px-2 py-0.5 text-[10px] font-bold text-[#fbf9f5] uppercase tracking-wider">
                Stale Data Warning
              </span>
              <span class="text-xs font-bold text-[#d94a31]">
                Ảnh chụp chỉ số đã quá {staleness.daysOld} ngày
              </span>
            </div>
            <p class="text-xs text-[#616c63] mt-1" data-testid="stale-snapshot-message">
              {staleness.staleWarning}
            </p>
          </div>
        </div>

        <button
          type="button"
          onclick={handleRefreshSnapshot}
          class="inline-flex items-center gap-1.5 rounded-lg bg-[#d94a31] px-4 py-2 text-xs font-semibold text-[#fbf9f5] hover:bg-[#b83b25] transition-colors shadow-xs shrink-0"
          data-testid="refresh-snapshot-button"
        >
          <span>🔄 Làm mới dữ liệu</span>
        </button>
      </div>
    </div>
  {:else}
    <div class="flex items-center justify-between rounded-lg bg-[#eaf4ed] px-3.5 py-2 text-xs text-[#274333] border border-[#274333]/20">
      <div class="flex items-center gap-2">
        <span class="h-2 w-2 rounded-full bg-[#274333]"></span>
        <span>Dữ liệu benchmark được chụp mới nhất (hôm nay). Tất cả các chỉ số đang ở trạng thái chuẩn xác.</span>
      </div>
      <button
        type="button"
        onclick={handleRefreshSnapshot}
        class="text-[11px] font-semibold underline hover:text-[#1a2f24]"
      >
        Quét lại
      </button>
    </div>
  {/if}

  <!-- Overall Ranking Podium Card -->
  <div class="rounded-xl border border-[#e7e2d7] bg-[#ffffff] p-5 shadow-xs">
    <div class="flex flex-col gap-4 md:flex-row md:items-center md:justify-between">
      <div>
        <span class="text-[11px] font-bold uppercase tracking-wider text-[#616c63]">
          Xếp hạng tổng thể (Overall Score)
        </span>
        <h2 class="text-lg font-bold text-[#242924] mt-1">
          Kênh của bạn đứng <span class="text-[#274333] underline">#2</span> trong 3 kênh so sánh
        </h2>
        <p class="text-xs text-[#616c63] mt-0.5">
          Điểm số tổng hợp: <span class="font-bold text-[#242924]">78 / 100</span> · <span class="text-[#274333] font-semibold">↑ +5.2%</span> so với kỳ trước.
        </p>
      </div>

      <!-- Podium -->
      <div class="flex items-end justify-center gap-3 pt-2">
        <!-- #2: You -->
        <div class="flex flex-col items-center">
          <span class="text-xs font-bold text-[#274333] mb-1">🥈 #2 (Bạn)</span>
          <div class="h-16 w-20 rounded-t-lg bg-[#274333] flex flex-col items-center justify-center text-[#fbf9f5] shadow-xs">
            <span class="text-xs font-bold">78đ</span>
            <span class="text-[9px] opacity-80">9.8% eng</span>
          </div>
        </div>

        <!-- #1: Leader -->
        <div class="flex flex-col items-center">
          <span class="text-xs font-bold text-amber-600 mb-1">🏆 #1</span>
          <div class="h-24 w-24 rounded-t-lg bg-amber-500 flex flex-col items-center justify-center text-[#ffffff] shadow-sm">
            <span class="text-xs font-bold">88đ</span>
            <span class="text-[9px] opacity-90 truncate max-w-[80px]">@skincare_queen</span>
          </div>
        </div>

        <!-- #3: Competitor 2 -->
        <div class="flex flex-col items-center">
          <span class="text-xs font-bold text-[#616c63] mb-1">🥉 #3</span>
          <div class="h-12 w-20 rounded-t-lg bg-[#e7e2d7] flex flex-col items-center justify-center text-[#242924]">
            <span class="text-xs font-bold">64đ</span>
            <span class="text-[9px] text-[#616c63] truncate max-w-[70px]">@beauty_guru</span>
          </div>
        </div>
      </div>
    </div>
  </div>

  <!-- Comparative Metrics Table (Acceptance Target 3) -->
  <div class="rounded-xl border border-[#e7e2d7] bg-[#ffffff] shadow-xs overflow-hidden" data-testid="benchmark-metrics-table">
    <div class="p-4 border-b border-[#e7e2d7] bg-[#fbf9f5] flex items-center justify-between">
      <h3 class="text-xs font-bold uppercase tracking-wider text-[#242924]">
        📋 Bảng so sánh chỉ số chi tiết
      </h3>
      <span class="text-[11px] text-[#616c63]">
        Biểu tượng 🏆 đánh dấu kênh dẫn đầu ở từng chỉ số
      </span>
    </div>

    <div class="overflow-x-auto">
      <table class="w-full text-left text-xs border-collapse">
        <thead>
          <tr class="border-b border-[#e7e2d7] bg-[#f4f0e8]/50 text-[#616c63]">
            <th class="p-3 font-semibold">Chỉ số so sánh</th>
            <th class="p-3 font-semibold text-[#274333] bg-[#eef3f0]/50">
              Bạn ({youMetrics.handle})
            </th>
            {#each competitorList as comp}
              <th class="p-3 font-semibold text-[#242924]">
                {comp.name} ({comp.handle})
              </th>
            {/each}
            <th class="p-3 font-semibold text-[#616c63]">Trung bình thị trường</th>
          </tr>
        </thead>
        <tbody class="divide-y divide-[#e7e2d7]">
          {#each comparisonRows as row}
            <tr class="hover:bg-[#fbf9f5] transition-colors {row.isPrivateRevenueGuard ? 'bg-[#fdf5f3]/40' : ''}">
              <td class="p-3 font-medium text-[#242924] flex items-center gap-1.5">
                <span>{row.metricLabel}</span>
                {#if row.isPrivateRevenueGuard}
                  <span
                    class="cursor-help rounded-full bg-[#e7e2d7] px-1 text-[10px] text-[#616c63]"
                    title={revenueGuard.tooltip}
                  >
                    ℹ️
                  </span>
                {/if}
              </td>

              <!-- Your column -->
              <td class="p-3 font-bold text-[#274333] bg-[#eef3f0]/30" data-testid={`cell-you-${row.metricKey}`}>
                <div class="flex items-center gap-1.5">
                  <span>{row.you.formattedValue}</span>
                  {#if row.you.isLeader}
                    <span class="text-amber-500" title="Dẫn đầu">🏆</span>
                  {/if}
                </div>
              </td>

              <!-- Competitor columns -->
              {#each competitorList as comp}
                {@const cCell = row.competitors[comp.id]}
                <td class="p-3 text-[#242924]" data-testid={`cell-${comp.id}-${row.metricKey}`}>
                  <div class="flex items-center gap-1.5">
                    {#if row.isPrivateRevenueGuard}
                      <span class="font-mono text-[#8a968c]" data-testid="private-revenue-indicator">
                        {cCell?.formattedValue || '—'}
                      </span>
                    {:else}
                      <span class="font-medium">{cCell?.formattedValue}</span>
                      {#if cCell?.isLeader}
                        <span class="text-amber-500" title="Dẫn đầu">🏆</span>
                      {/if}
                    {/if}
                  </div>
                </td>
              {/each}

              <!-- Market Average -->
              <td class="p-3 font-mono text-[#616c63]">
                {row.marketAvg}
              </td>
            </tr>
          {/each}
        </tbody>
      </table>
    </div>

    <!-- Acceptance Target 3 Caveat Footer -->
    <div class="p-3 bg-[#fbf9f5] border-t border-[#e7e2d7] text-[11px] text-[#616c63] flex items-center gap-2">
      <span class="font-bold text-[#d94a31]">* Lưu ý bảo mật tài chính (RULE-M03-003):</span>
      <span>Doanh thu và lợi nhuận đối thủ mang tính bảo mật và không được hiển thị hay so sánh. Hệ thống nghiêm cấm đưa số liệu đối thủ giả định vào Sổ cái vận hành M19.</span>
    </div>
  </div>

  <!-- Radar Chart & Time Series Side-by-Side -->
  <div class="grid grid-cols-1 gap-6 lg:grid-cols-2">
    <!-- Visual Radar Chart -->
    <div class="rounded-xl border border-[#e7e2d7] bg-[#ffffff] p-5 shadow-xs flex flex-col justify-between">
      <div>
        <div class="flex items-center justify-between mb-4">
          <h3 class="text-xs font-bold uppercase tracking-wider text-[#242924]">
            🕸️ Radar phân bổ sức mạnh (5 trục)
          </h3>
          <span class="text-[11px] text-[#616c63]">Thang chuẩn hóa 0 - 100</span>
        </div>

        <!-- Custom SVG Radar Diagram -->
        <div class="flex items-center justify-center p-4">
          <svg viewBox="0 0 300 260" class="w-full max-w-[280px]">
            <!-- Radar background polygons (levels 20, 40, 60, 80, 100) -->
            <polygon points="150,20 270,105 225,240 75,240 30,105" fill="none" stroke="#e7e2d7" stroke-width="1" />
            <polygon points="150,50 240,115 205,215 95,215 60,115" fill="none" stroke="#e7e2d7" stroke-width="1" />
            <polygon points="150,80 210,125 185,190 115,190 90,125" fill="none" stroke="#e7e2d7" stroke-width="1" />
            <polygon points="150,110 180,135 165,165 135,165 120,135" fill="none" stroke="#e7e2d7" stroke-width="1" />

            <!-- Axis lines -->
            <line x1="150" y1="140" x2="150" y2="20" stroke="#e7e2d7" stroke-width="1" />
            <line x1="150" y1="140" x2="270" y2="105" stroke="#e7e2d7" stroke-width="1" />
            <line x1="150" y1="140" x2="225" y2="240" stroke="#e7e2d7" stroke-width="1" />
            <line x1="150" y1="140" x2="75" y2="240" stroke="#e7e2d7" stroke-width="1" />
            <line x1="150" y1="140" x2="30" y2="105" stroke="#e7e2d7" stroke-width="1" />

            <!-- Entity 1: You (Green Polygon) -->
            <!-- Followers: 50, Growth: 65, Engagement: 95, Views: 45, Freq: 85 -->
            <polygon
              points="150,80 228,118 221,235 116,185 48,110"
              fill="rgba(39, 67, 51, 0.25)"
              stroke="#274333"
              stroke-width="2"
            />

            <!-- Entity 2: Skincare Queen (Amber Polygon) -->
            <!-- Followers: 90, Growth: 85, Engagement: 70, Views: 95, Freq: 90 -->
            <polygon
              points="150,32 252,110 202,210 78,235 40,108"
              fill="rgba(217, 74, 49, 0.2)"
              stroke="#d94a31"
              stroke-width="1.5"
              stroke-dasharray="4,2"
            />

            <!-- Labels around axes -->
            <text x="150" y="12" text-anchor="middle" font-size="9" fill="#242924" font-weight="bold">Followers</text>
            <text x="275" y="105" text-anchor="start" font-size="9" fill="#242924" font-weight="bold">Tăng trưởng</text>
            <text x="230" y="255" text-anchor="middle" font-size="9" fill="#242924" font-weight="bold">Tần suất</text>
            <text x="70" y="255" text-anchor="middle" font-size="9" fill="#242924" font-weight="bold">Lượt xem</text>
            <text x="25" y="105" text-anchor="end" font-size="9" fill="#242924" font-weight="bold">Tương tác</text>
          </svg>
        </div>
      </div>

      <!-- Legend -->
      <div class="flex items-center justify-center gap-6 border-t border-[#e7e2d7] pt-3 text-xs">
        <div class="flex items-center gap-2">
          <span class="h-3 w-3 rounded-full bg-[#274333]"></span>
          <span class="font-bold text-[#242924]">Bạn (@my_studio_vn)</span>
        </div>
        <div class="flex items-center gap-2">
          <span class="h-3 w-3 rounded-full bg-[#d94a31]"></span>
          <span class="text-[#616c63]">@skincare_queen</span>
        </div>
      </div>
    </div>

    <!-- Metric Curve Chart (Time-Series) -->
    <div class="rounded-xl border border-[#e7e2d7] bg-[#ffffff] p-5 shadow-xs flex flex-col justify-between">
      <div>
        <div class="flex items-center justify-between mb-4">
          <h3 class="text-xs font-bold uppercase tracking-wider text-[#242924]">
            📈 Biểu đồ biến động xu hướng (30 ngày)
          </h3>

          <div class="flex items-center gap-1 text-[11px]">
            <button
              type="button"
              onclick={() => (activeChartMetric = 'engagement')}
              class="rounded px-2 py-1 {activeChartMetric === 'engagement' ? 'bg-[#274333] text-[#fbf9f5] font-semibold' : 'text-[#616c63] hover:text-[#242924]'}"
            >
              Tương tác (%)
            </button>
            <button
              type="button"
              onclick={() => (activeChartMetric = 'views')}
              class="rounded px-2 py-1 {activeChartMetric === 'views' ? 'bg-[#274333] text-[#fbf9f5] font-semibold' : 'text-[#616c63] hover:text-[#242924]'}"
            >
              Lượt xem
            </button>
          </div>
        </div>

        <!-- SVG Line Chart Mockup -->
        <div class="p-2">
          <svg viewBox="0 0 350 180" class="w-full">
            <!-- Grid lines -->
            <line x1="30" y1="20" x2="330" y2="20" stroke="#f4f0e8" stroke-width="1" />
            <line x1="30" y1="60" x2="330" y2="60" stroke="#f4f0e8" stroke-width="1" />
            <line x1="30" y1="100" x2="330" y2="100" stroke="#f4f0e8" stroke-width="1" />
            <line x1="30" y1="140" x2="330" y2="140" stroke="#e7e2d7" stroke-width="1" />

            <!-- Y Axis labels -->
            <text x="25" y="24" text-anchor="end" font-size="9" fill="#8a968c">12%</text>
            <text x="25" y="64" text-anchor="end" font-size="9" fill="#8a968c">9%</text>
            <text x="25" y="104" text-anchor="end" font-size="9" fill="#8a968c">6%</text>
            <text x="25" y="144" text-anchor="end" font-size="9" fill="#8a968c">3%</text>

            <!-- Line 1: You (Green Line) -->
            <path
              d="M30,80 Q90,50 150,55 T270,40 T330,35"
              fill="none"
              stroke="#274333"
              stroke-width="2.5"
            />

            <!-- Line 2: Competitor (Red Dash Line) -->
            <path
              d="M30,70 Q90,90 150,75 T270,85 T330,95"
              fill="none"
              stroke="#d94a31"
              stroke-width="1.8"
              stroke-dasharray="4,3"
            />

            <!-- Current point circles -->
            <circle cx="330" cy="35" r="4" fill="#274333" />
            <circle cx="330" cy="95" r="4" fill="#d94a31" />

            <!-- X Axis labels -->
            <text x="30" y="160" font-size="9" fill="#8a968c">1 Th10</text>
            <text x="130" y="160" font-size="9" fill="#8a968c">10 Th10</text>
            <text x="230" y="160" font-size="9" fill="#8a968c">20 Th10</text>
            <text x="330" y="160" text-anchor="end" font-size="9" fill="#8a968c">Hôm nay</text>
          </svg>
        </div>
      </div>

      <div class="rounded-lg bg-[#fbf9f5] p-3 border border-[#e7e2d7] text-xs text-[#616c63]">
        💡 <span class="font-bold text-[#242924]">Nhận định đường xu hướng:</span> Tỷ lệ tương tác của kênh bạn đang tăng trưởng ổn định (+2.3% trong 10 ngày qua), trong khi đối thủ @skincare_queen đang có dấu hiệu bão hòa tương tác.
      </div>
    </div>
  </div>

  <!-- Acceptance Target 1: White-space Gaps & Inferred AI Insight Card -->
  <div class="rounded-xl border border-[#e7e2d7] bg-[#ffffff] p-6 shadow-xs space-y-4" data-testid="whitespace-gaps-section">
    <div class="flex flex-col gap-2 sm:flex-row sm:items-center sm:justify-between border-b border-[#e7e2d7] pb-3">
      <div class="flex items-center gap-2">
        <span class="text-xl">🎯</span>
        <div>
          <div class="flex items-center gap-2">
            <h2 class="text-sm font-bold text-[#242924]">
              Khoảng trống thị trường (White-Space Opportunity)
            </h2>
            <span class="rounded bg-[#fef9c3] px-2 py-0.5 text-[10px] font-semibold text-[#854d0e] border border-[#854d0e]/20" data-testid="inferred-badge">
              🏷️ INFERRED
            </span>
          </div>
          <p class="text-xs text-[#616c63]">
            Các chủ đề có nhu cầu người dùng cao nhưng chưa bị đối thủ chiếm lĩnh.
          </p>
        </div>
      </div>

      <span class="text-xs text-[#274333] font-semibold bg-[#eef3f0] px-2.5 py-1 rounded-md">
        AI Niche Analyzer v2
      </span>
    </div>

    <div class="grid grid-cols-1 gap-4 md:grid-cols-2">
      {#each whiteSpaceGaps as gap}
        <div
          class="flex flex-col justify-between rounded-xl border border-[#e7e2d7] bg-[#fbf9f5] p-5 hover:border-[#274333]/40 transition-colors"
          data-testid="gap-card"
        >
          <div>
            <div class="flex items-start justify-between gap-2">
              <span class="rounded bg-[#eef3f0] px-2 py-0.5 text-[10px] font-semibold text-[#274333]">
                {gap.niche}
              </span>
              <span class="rounded-full bg-[#fef08a] px-2 py-0.5 text-[10px] font-bold text-[#854d0e]">
                Tiềm năng: {gap.potentialScore}/100
              </span>
            </div>

            <h3 class="text-sm font-bold text-[#242924] mt-2.5">
              {gap.title}
            </h3>
            <p class="text-xs text-[#616c63] mt-1.5 leading-relaxed">
              {gap.description}
            </p>

            <div class="mt-4 grid grid-cols-2 gap-2 text-[11px] rounded-lg bg-[#ffffff] p-2.5 border border-[#e7e2d7]">
              <div>
                <span class="text-[#616c63] block">Nhu cầu tìm kiếm:</span>
                <span class="font-bold text-[#274333]">{gap.estimatedDemand}</span>
              </div>
              <div>
                <span class="text-[#616c63] block">Mật độ đối thủ:</span>
                <span class="font-bold text-[#242924]">{gap.competitorSaturation}</span>
              </div>
            </div>
          </div>

          <!-- Inferred Label & Why Trigger (Acceptance Target 1) -->
          <div class="mt-4 flex items-center justify-between border-t border-[#e7e2d7] pt-3 text-xs">
            <div class="flex items-center gap-1.5">
              <span class="h-2 w-2 rounded-full bg-[#854d0e]"></span>
              <span class="text-[11px] font-medium text-[#854d0e]">
                Suy luận từ dữ liệu công khai
              </span>
            </div>

            <button
              type="button"
              onclick={() => openInsightWhyDrawer(gap.title, gap.whyExplanation)}
              class="font-semibold text-[#274333] hover:underline flex items-center gap-1"
              data-testid="why-explanation-trigger"
            >
              <span>Xem căn cứ suy luận (Why?)</span>
              <span>→</span>
            </button>
          </div>
        </div>
      {/each}
    </div>
  </div>

  <!-- Why Drawer Component (RULE-M03-001, RULE-M03-002, AC 1) -->
  <CompetitorWhyDrawer
    isOpen={isWhyDrawerOpen}
    title={whyDrawerTitle}
    sourceClass="inferred"
    confidence="high"
    whyExplanation={activeWhyExplanation}
    onclose={() => (isWhyDrawerOpen = false)}
  />
</div>

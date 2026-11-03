<script lang="ts">
  import {
    calculateOverallScore,
    computeRepairStatus,
    filterOpportunities,
    sortOpportunities,
    type Opportunity,
    type PriorityState,
  } from '$lib/opportunity';

  // Workspace tenant context
  const currentWorkspaceId = 'ws-current-tenant';

  // Seed data matching canonical M04 Opportunity Board
  let opportunities = $state<Opportunity[]>([
    {
      id: 'opp-001',
      workspaceId: currentWorkspaceId,
      opportunityType: 'content',
      title: 'Morning skincare routine — chưa có trên TikTok VN',
      summary: 'Hiện chỉ có 3 video VN về morning routine. Trending +200% globally nhưng VN market chưa khai thác. Audience 18-25 match 92%.',
      whyItMatters: 'First mover advantage rất cao; đối thủ chưa phủ ngách buổi sáng.',
      expectedImpact: {
        score: 89,
        description: 'Tăng trưởng organic reach và tương tác cao',
        revenueEstimate: '25.000.000 đ'
      },
      expectedEffort: {
        score: 35,
        description: 'Quay ngắn 30-45s với sản phẩm hiện có',
        timeEstimate: '2 giờ sản xuất'
      },
      priorityState: 'prioritized',
      priorityReason: 'Audience match 92%, low competition trên TikTok VN',
      suggestedNextStep: 'Tạo kịch bản POV buổi sáng 30 giây',
      ownerUserId: '', // Unassigned -> triggers repair prompt!
      confidence: 'high',
      sourceClass: 'inferred',
      convertedToType: '',
      convertedToId: '',
      sources: [
        {
          sourceType: 'trend',
          sourceId: 'trend-morning-glow',
          sourceName: 'Morning Glow #morningroutine (+200%)',
          sourceUrl: 'https://tiktok.com/tag/morningroutine'
        },
        {
          sourceType: 'competitor',
          sourceId: 'comp-queen',
          sourceName: '@skincare_queen (khoảng trống nội dung)'
        }
      ],
      isSaved: false,
      isDismissed: false,
      overallScore: 89,
      estimatedProfit: {
        amountCents: 25000000,
        currency: 'VND',
        confidence: 'high',
        sourceClass: 'estimated',
        isEstimate: true,
        explanation: 'Dự toán doanh thu tiềm năng dựa trên tín hiệu thị trường; không phải số liệu kế toán chính thức.'
      },
      createdAt: '2026-11-03T02:00:00Z',
      updatedAt: '2026-11-03T02:00:00Z',
      isRepairable: true,
      repairReasons: ['Chưa phân công người phụ trách (Unassigned owner — assign team member)']
    },
    {
      id: 'opp-002',
      workspaceId: currentWorkspaceId,
      opportunityType: 'content',
      title: 'Review serum retinol — competitor giảm tần suất',
      summary: '@skincare_queen chưa post về retinol 2 tuần nay. Keyword vẫn trending. Cơ hội lấp khoảng trống.',
      whyItMatters: 'Top competitor đang chuyển hướng sang sản phẩm khác, bỏ trống từ khóa retinol.',
      expectedImpact: {
        score: 74,
        description: 'Chiếm sóng tìm kiếm ngành hàng phục hồi da',
        revenueEstimate: '18.000.000 đ'
      },
      expectedEffort: {
        score: 40,
        description: 'Cần so sánh 2 chai serum thực tế',
        timeEstimate: '3 giờ sản xuất'
      },
      priorityState: 'assigned',
      priorityReason: 'Đối thủ ngừng post, nhu cầu tìm kiếm vẫn duy trì mức cao',
      suggestedNextStep: 'Quay video so sánh Retinol 0.5% vs 1%',
      ownerUserId: 'user-editor-01',
      confidence: 'medium_high',
      sourceClass: 'inferred',
      convertedToType: '',
      convertedToId: '',
      sources: [
        {
          sourceType: 'competitor',
          sourceId: 'comp-queen',
          sourceName: '@skincare_queen chưa đăng retinol 14 ngày qua'
        }
      ],
      isSaved: true,
      isDismissed: false,
      overallScore: 74,
      estimatedProfit: {
        amountCents: 18000000,
        currency: 'VND',
        confidence: 'medium_high',
        sourceClass: 'estimated',
        isEstimate: true,
        explanation: 'Ước tính GMV affiliate tiềm năng.'
      },
      createdAt: '2026-11-02T14:30:00Z',
      updatedAt: '2026-11-02T16:00:00Z',
      isRepairable: false,
      repairReasons: []
    },
    {
      id: 'opp-003',
      workspaceId: currentWorkspaceId,
      opportunityType: 'product',
      title: 'Cushion chống nắng nâng tone — xu hướng mùa hè',
      summary: 'Tín hiệu tìm kiếm cushion SPF50+ tăng đột biến +150% từ Gen Z.',
      whyItMatters: 'Khách hàng có nhu cầu sản phẩm 2-trong-1 vừa chống nắng vừa trang điểm nhẹ.',
      expectedImpact: {
        score: 82,
        description: 'Doanh số bán lẻ và livestream dự kiến cao',
        revenueEstimate: '40.000.000 đ'
      },
      expectedEffort: {
        score: 60,
        description: 'Cần nhập mẫu thử và kiểm nghiệm tone màu',
        timeEstimate: '2 ngày chuẩn bị'
      },
      priorityState: 'open',
      priorityReason: '',
      suggestedNextStep: 'Liên hệ nhà cung cấp lấy mẫu',
      ownerUserId: '',
      confidence: 'unspecified',
      sourceClass: 'imported',
      convertedToType: '',
      convertedToId: '',
      sources: [
        {
          sourceType: 'signal',
          sourceId: 'sig-cushion-spf',
          sourceName: 'Google & TikTok Search Trends (+150%)'
        }
      ],
      isSaved: false,
      isDismissed: false,
      overallScore: 69,
      estimatedProfit: {
        amountCents: 40000000,
        currency: 'VND',
        confidence: 'low_medium',
        sourceClass: 'estimated',
        isEstimate: true,
        explanation: 'Ước tính theo biên lợi nhuận phân phối 35%.'
      },
      createdAt: '2026-11-03T04:15:00Z',
      updatedAt: '2026-11-03T04:15:00Z',
      isRepairable: true,
      repairReasons: [
        'Chưa phân công người phụ trách (Unassigned owner — assign team member)',
        'Thiếu ngữ cảnh ưu tiên (Missing priority context — add reason or confidence)'
      ]
    }
  ]);

  // Filter & Sort State
  let sortBy = $state<'score_desc' | 'score_asc' | 'updated_desc' | 'impact_desc'>('score_desc');
  let minScore = $state<number>(0);
  let filterState = $state<string>('all');
  let searchQuery = $state<string>('');
  let assignModalOppId = $state<string | null>(null);
  let assignUserIdInput = $state<string>('');

  // Derived Summary Metrics
  const activeOpportunities = $derived(opportunities.filter((o) => !o.isDismissed));
  const totalCount = $derived(activeOpportunities.length);
  const avgScore = $derived(
    totalCount > 0
      ? Math.round(activeOpportunities.reduce((sum, o) => sum + o.overallScore, 0) / totalCount)
      : 0
  );
  const newTodayCount = $derived(
    activeOpportunities.filter((o) => {
      const created = new Date(o.createdAt);
      const today = new Date();
      return (
        created.getDate() === today.getDate() &&
        created.getMonth() === today.getMonth() &&
        created.getFullYear() === today.getFullYear()
      );
    }).length
  );

  // Derived Filtered List
  const displayedOpportunities = $derived.by(() => {
    let list = activeOpportunities;
    if (filterState !== 'all') {
      list = list.filter((o) => o.priorityState === filterState);
    }
    list = filterOpportunities(list, {
      minScore,
      search: searchQuery
    });
    return sortOpportunities(list, sortBy);
  });

  // Actions
  function toggleSave(id: string) {
    const opp = opportunities.find((o) => o.id === id);
    if (opp) {
      opp.isSaved = !opp.isSaved;
    }
  }

  function dismissOpportunity(id: string) {
    const opp = opportunities.find((o) => o.id === id);
    if (opp) {
      opp.isDismissed = true;
    }
  }

  function openAssignModal(id: string) {
    assignModalOppId = id;
    const opp = opportunities.find((o) => o.id === id);
    assignUserIdInput = opp?.ownerUserId || 'user-nguyen-van-a';
  }

  function confirmAssign() {
    if (!assignModalOppId || !assignUserIdInput.trim()) return;
    const opp = opportunities.find((o) => o.id === assignModalOppId);
    if (opp) {
      opp.ownerUserId = assignUserIdInput.trim();
      if (opp.priorityState === 'open' || opp.priorityState === 'prioritized') {
        opp.priorityState = 'assigned';
      }
      opp.updatedAt = new Date().toISOString();
      const repair = computeRepairStatus(opp);
      opp.isRepairable = repair.isRepairable;
      opp.repairReasons = repair.repairReasons;
    }
    assignModalOppId = null;
  }
</script>

<svelte:head>
  <title>💎 Opportunity Board — Creativanta</title>
</svelte:head>

<div class="space-y-6 p-6">
  <!-- Page Header -->
  <div class="flex flex-col gap-4 sm:flex-row sm:items-center sm:justify-between">
    <div>
      <h1 class="text-2xl font-bold tracking-tight text-slate-900">💎 Cơ hội phát triển nội dung</h1>
      <p class="text-sm text-slate-500">
        AI phát hiện các khoảng trống thị trường, phân tích đối thủ và chấm điểm tiềm năng theo thời gian thực (M04).
      </p>
    </div>
    <div class="flex items-center gap-3">
      <a
        href="/intelligence/competitors"
        class="inline-flex items-center gap-1.5 rounded-lg border border-slate-300 bg-white px-3 py-1.5 text-sm font-medium text-slate-700 shadow-sm hover:bg-slate-50"
      >
        🎯 Đối thủ
      </a>
      <a
        href="/kham-pha"
        class="inline-flex items-center gap-1.5 rounded-lg border border-slate-300 bg-white px-3 py-1.5 text-sm font-medium text-slate-700 shadow-sm hover:bg-slate-50"
      >
        🔥 Xu hướng
      </a>
    </div>
  </div>

  <!-- Summary Bar -->
  <div class="grid grid-cols-1 gap-4 sm:grid-cols-3">
    <div class="rounded-xl border border-slate-200 bg-white p-4 shadow-sm">
      <div class="text-xs font-semibold uppercase tracking-wider text-slate-500">Tổng cơ hội khả dụng</div>
      <div class="mt-2 flex items-baseline gap-2">
        <span class="text-2xl font-bold text-slate-900">{totalCount}</span>
        <span class="text-xs text-slate-500">cơ hội đang mở</span>
      </div>
    </div>
    <div class="rounded-xl border border-slate-200 bg-white p-4 shadow-sm">
      <div class="text-xs font-semibold uppercase tracking-wider text-slate-500">Điểm tiềm năng trung bình</div>
      <div class="mt-2 flex items-baseline gap-2">
        <span class="text-2xl font-bold text-indigo-600">⭐ {avgScore}</span>
        <span class="text-xs text-slate-500">/ 100 điểm</span>
      </div>
    </div>
    <div class="rounded-xl border border-slate-200 bg-white p-4 shadow-sm">
      <div class="text-xs font-semibold uppercase tracking-wider text-slate-500">Cơ hội mới hôm nay</div>
      <div class="mt-2 flex items-baseline gap-2">
        <span class="text-2xl font-bold text-emerald-600">+{newTodayCount}</span>
        <span class="text-xs text-slate-500">từ AI Radar</span>
      </div>
    </div>
  </div>

  <!-- Filters & Search Toolbar -->
  <div class="flex flex-col gap-4 rounded-xl border border-slate-200 bg-white p-4 shadow-sm md:flex-row md:items-center md:justify-between">
    <div class="flex flex-1 items-center gap-3">
      <input
        type="search"
        placeholder="Tìm kiếm cơ hội theo từ khóa, ngành hàng..."
        bind:value={searchQuery}
        class="w-full max-w-md rounded-lg border border-slate-300 px-3 py-2 text-sm focus:border-indigo-500 focus:outline-none"
      />
      <select
        bind:value={filterState}
        class="rounded-lg border border-slate-300 px-3 py-2 text-sm text-slate-700 focus:border-indigo-500 focus:outline-none"
      >
        <option value="all">Tất cả trạng thái</option>
        <option value="open">Đang mở (Open)</option>
        <option value="prioritized">Đã ưu tiên (Prioritized)</option>
        <option value="assigned">Đã phân công (Assigned)</option>
        <option value="in_progress">Đang thực hiện (In Progress)</option>
      </select>
    </div>

    <div class="flex items-center gap-4">
      <div class="flex items-center gap-2">
        <span class="text-xs font-medium text-slate-600">Điểm ≥ {minScore}</span>
        <input
          type="range"
          min="0"
          max="95"
          step="5"
          bind:value={minScore}
          class="h-2 w-24 cursor-pointer accent-indigo-600"
        />
      </div>

      <div class="flex items-center gap-2">
        <span class="text-xs font-medium text-slate-600">Sắp xếp:</span>
        <select
          bind:value={sortBy}
          class="rounded-lg border border-slate-300 px-3 py-1.5 text-sm text-slate-700 focus:border-indigo-500 focus:outline-none"
        >
          <option value="score_desc">Điểm cao nhất</option>
          <option value="score_asc">Điểm thấp nhất</option>
          <option value="updated_desc">Mới cập nhật</option>
          <option value="impact_desc">Tác động kỳ vọng</option>
        </select>
      </div>
    </div>
  </div>

  <!-- Opportunity Feed Cards -->
  <div class="space-y-4" role="feed">
    {#if displayedOpportunities.length === 0}
      <div class="rounded-xl border border-dashed border-slate-300 bg-white p-12 text-center">
        <div class="mx-auto flex h-12 w-12 items-center justify-center rounded-full bg-slate-100 text-2xl">
          🔍
        </div>
        <h3 class="mt-4 text-base font-semibold text-slate-900">Không tìm thấy cơ hội phù hợp</h3>
        <p class="mt-1 text-sm text-slate-500">
          Hãy thử giảm bộ lọc điểm hoặc theo dõi thêm đối thủ và từ khóa để AI phát hiện cơ hội mới.
        </p>
      </div>
    {/if}

    {#each displayedOpportunities as opp (opp.id)}
      <article
        class="rounded-xl border border-slate-200 bg-white p-6 shadow-sm transition hover:border-slate-300"
        aria-label="Cơ hội: {opp.title}, điểm {opp.overallScore}, loại {opp.opportunityType}"
      >
        <!-- Card Header -->
        <div class="flex flex-col gap-2 sm:flex-row sm:items-start sm:justify-between">
          <div>
            <div class="flex items-center gap-2">
              <span class="rounded-full bg-indigo-50 px-2.5 py-0.5 text-xs font-semibold text-indigo-700">
                ⭐ {opp.overallScore}/100
              </span>
              <span class="rounded-md bg-slate-100 px-2 py-0.5 text-xs font-medium uppercase tracking-wider text-slate-600">
                {opp.opportunityType}
              </span>
              <span class="rounded-md px-2 py-0.5 text-xs font-medium {opp.priorityState === 'assigned' ? 'bg-emerald-50 text-emerald-700' : 'bg-amber-50 text-amber-700'}">
                {opp.priorityState}
              </span>
            </div>
            <h2 class="mt-2 text-lg font-bold text-slate-900 hover:text-indigo-600">
              <a href="/intelligence/opportunities/{opp.id}">💎 {opp.title}</a>
            </h2>
          </div>

          <div class="flex items-center gap-2">
            <button
              type="button"
              onclick={() => toggleSave(opp.id)}
              class="rounded-lg border border-slate-200 p-2 text-slate-600 hover:bg-slate-50 {opp.isSaved ? 'text-amber-500 font-bold' : ''}"
              title="Lưu cơ hội"
            >
              {opp.isSaved ? '📌 Đã lưu' : '📌 Lưu'}
            </button>
            <button
              type="button"
              onclick={() => dismissOpportunity(opp.id)}
              class="rounded-lg border border-slate-200 p-2 text-slate-400 hover:bg-slate-50 hover:text-rose-600"
              title="Bỏ qua cơ hội này"
            >
              ⏭ Bỏ qua
            </button>
          </div>
        </div>

        <!-- Acceptance Target 1: Unassigned open items repair prompt / warning banner -->
        {#if opp.isRepairable}
          <div class="mt-4 flex flex-col gap-2 rounded-lg border border-amber-200 bg-amber-50 p-3 text-sm text-amber-800 sm:flex-row sm:items-center sm:justify-between">
            <div class="flex items-center gap-2">
              <span class="font-bold">⚠️ Cần bổ sung thông tin (Repairable):</span>
              <span>{opp.repairReasons.join(' · ')}</span>
            </div>
            {#if !opp.ownerUserId}
              <button
                type="button"
                onclick={() => openAssignModal(opp.id)}
                class="inline-flex shrink-0 items-center gap-1 rounded-md bg-amber-600 px-3 py-1 text-xs font-medium text-white shadow-sm hover:bg-amber-700"
              >
                👤 Phân công ngay
              </button>
            {/if}
          </div>
        {/if}

        <!-- AI Analysis & Summary -->
        <p class="mt-3 text-sm leading-relaxed text-slate-700">
          🤖 <span class="font-semibold text-slate-900">Phân tích AI:</span> {opp.summary}
        </p>

        <!-- Financial Non-Conflation Estimate Badge (RULE-M04-005) -->
        {#if opp.estimatedProfit}
          <div class="mt-3 inline-flex items-center gap-2 rounded-md border border-slate-200 bg-slate-50 px-2.5 py-1 text-xs text-slate-600">
            <span class="font-semibold text-emerald-700">
              Dự toán doanh thu: {(opp.estimatedProfit.amountCents / 100).toLocaleString('vi-VN')} đ
            </span>
            <span class="rounded bg-slate-200 px-1.5 py-0.2 text-[10px] uppercase font-bold text-slate-600">
              Estimate
            </span>
            <span class="text-slate-500">
              (Độ tin cậy: {opp.estimatedProfit.confidence})
            </span>
          </div>
        {/if}

        <!-- Provenance Sources Links (RULE-M04-001) -->
        <div class="mt-4 flex flex-wrap items-center gap-2 text-xs">
          <span class="font-medium text-slate-500">Nguồn dẫn chứng:</span>
          {#each opp.sources as source}
            <span class="inline-flex items-center gap-1 rounded-md border border-indigo-100 bg-indigo-50/60 px-2.5 py-1 font-medium text-indigo-700">
              🔗 {source.sourceName}
            </span>
          {/each}
        </div>

        <!-- Action Buttons -->
        <div class="mt-5 flex flex-wrap items-center gap-3 border-t border-slate-100 pt-4">
          <a
            href="/intelligence/opportunities/{opp.id}/convert?type=idea"
            class="inline-flex items-center gap-1.5 rounded-lg bg-indigo-600 px-4 py-2 text-sm font-semibold text-white shadow-sm hover:bg-indigo-700"
          >
            💡 Tạo ý tưởng
          </a>
          <a
            href="/intelligence/opportunities/{opp.id}/convert?type=script"
            class="inline-flex items-center gap-1.5 rounded-lg border border-slate-300 bg-white px-4 py-2 text-sm font-semibold text-slate-700 shadow-sm hover:bg-slate-50"
          >
            📝 Viết script ngay
          </a>
          <a
            href="/intelligence/opportunities/{opp.id}"
            class="inline-flex items-center gap-1 text-sm font-medium text-slate-600 hover:text-slate-900"
          >
            Xem phân tích chi tiết →
          </a>
        </div>
      </article>
    {/each}
  </div>
</div>

<!-- Assign Owner Modal -->
{#if assignModalOppId}
  <div class="fixed inset-0 z-50 flex items-center justify-center bg-black/40 p-4">
    <div class="w-full max-w-md rounded-xl bg-white p-6 shadow-xl">
      <h3 class="text-lg font-bold text-slate-900">👤 Phân công người phụ trách cơ hội</h3>
      <p class="mt-1 text-sm text-slate-500">
        Chỉ định thành viên để cơ hội chuyển từ trạng thái mở/ưu tiên sang trạng thái phân công (Assigned).
      </p>

      <div class="mt-4">
        <label for="assignUser" class="block text-xs font-semibold uppercase text-slate-600">Thành viên</label>
        <select
          id="assignUser"
          bind:value={assignUserIdInput}
          class="mt-1 w-full rounded-lg border border-slate-300 p-2 text-sm focus:border-indigo-500 focus:outline-none"
        >
          <option value="user-nguyen-van-a">Nguyễn Văn A (Content Lead)</option>
          <option value="user-tran-thi-b">Trần Thị B (Video Creator)</option>
          <option value="user-le-van-c">Lê Văn C (Growth / Affiliate)</option>
        </select>
      </div>

      <div class="mt-6 flex items-center justify-end gap-3">
        <button
          type="button"
          onclick={() => assignModalOppId = null}
          class="rounded-lg border border-slate-300 px-4 py-2 text-sm font-medium text-slate-700 hover:bg-slate-50"
        >
          Hủy
        </button>
        <button
          type="button"
          onclick={confirmAssign}
          class="rounded-lg bg-indigo-600 px-4 py-2 text-sm font-semibold text-white shadow-sm hover:bg-indigo-700"
        >
          Xác nhận phân công
        </button>
      </div>
    </div>
  </div>
{/if}

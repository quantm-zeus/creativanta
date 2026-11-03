<script lang="ts">
  import { page } from '$app/state';
  import {
    computeRepairStatus,
    type Opportunity,
    type PriorityState,
  } from '$lib/opportunity';

  const opportunityId = page.params.id || 'opp-001';

  // Seed data for the detail view
  let opportunity = $state<Opportunity>({
    id: opportunityId,
    workspaceId: 'ws-current-tenant',
    opportunityType: 'content',
    title: 'Morning skincare routine — chưa có trên TikTok VN',
    summary: 'Hiện chỉ có 3 video VN về morning routine trên TikTok. Trong khi đó, keyword "morning skincare" trending +200% globally. Audience 18-25 match 92%. First mover advantage rất cao.',
    whyItMatters: 'Đối thủ cạnh tranh lớn nhất (@skincare_queen) chưa chạm vào chủ đề quy trình buổi sáng cho da dầu mụn tại thị trường Việt Nam.',
    expectedImpact: {
      score: 89,
      description: 'Lượng view kỳ vọng 150k - 300k, tỷ lệ click affiliate dự kiến 4.5%',
      revenueEstimate: '25.000.000 đ'
    },
    expectedEffort: {
      score: 35,
      description: 'Quay ngắn 30-45s với ánh sáng tự nhiên buổi sáng, tận dụng tủ đồ skincare hiện có',
      timeEstimate: '2 giờ sản xuất'
    },
    priorityState: 'prioritized',
    priorityReason: 'Audience match 92%, low competition trên TikTok VN, first mover advantage rất cao',
    suggestedNextStep: 'Tạo kịch bản POV buổi sáng 30 giây: 3 bước tối giản',
    ownerUserId: '', // Unassigned -> triggers repair prompt
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
        sourceName: '@skincare_queen (khoảng trống 14 ngày không post retinol/routine)'
      },
      {
        sourceType: 'signal',
        sourceId: 'sig-genz-audience',
        sourceName: 'Tệp khán giả nữ 18-25 VN trùng khớp 92%'
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
  });

  let assignModalOpen = $state(false);
  let selectedOwner = $state('user-nguyen-van-a');
  let actionToast = $state<string | null>(null);

  function triggerToast(msg: string) {
    actionToast = msg;
    setTimeout(() => {
      actionToast = null;
    }, 3000);
  }

  function assignOwner() {
    opportunity.ownerUserId = selectedOwner;
    opportunity.priorityState = 'assigned';
    opportunity.updatedAt = new Date().toISOString();
    const repair = computeRepairStatus(opportunity);
    opportunity.isRepairable = repair.isRepairable;
    opportunity.repairReasons = repair.repairReasons;
    assignModalOpen = false;
    triggerToast('Đã phân công người phụ trách thành công!');
  }

  function toggleSave() {
    opportunity.isSaved = !opportunity.isSaved;
    triggerToast(opportunity.isSaved ? 'Đã lưu cơ hội vào danh sách ghim!' : 'Đã bỏ lưu cơ hội.');
  }
</script>

<svelte:head>
  <title>💎 {opportunity.title} — Creativanta</title>
</svelte:head>

<div class="space-y-6 p-6">
  <!-- Toast notification -->
  {#if actionToast}
    <div class="fixed top-4 right-4 z-50 rounded-lg bg-slate-900 px-4 py-2 text-sm text-white shadow-lg">
      {actionToast}
    </div>
  {/if}

  <!-- Page Header -->
  <div class="flex flex-col gap-4 sm:flex-row sm:items-center sm:justify-between">
    <div class="flex items-center gap-3">
      <a
        href="/intelligence/opportunities"
        class="inline-flex h-9 w-9 items-center justify-center rounded-lg border border-slate-300 bg-white text-slate-600 hover:bg-slate-50"
        title="Quay lại Opportunity Board"
      >
        ←
      </a>
      <div>
        <div class="flex items-center gap-2">
          <span class="rounded-full bg-indigo-50 px-2.5 py-0.5 text-xs font-semibold text-indigo-700">
            ⭐ {opportunity.overallScore}/100
          </span>
          <span class="rounded-md bg-slate-100 px-2 py-0.5 text-xs font-medium uppercase tracking-wider text-slate-600">
            {opportunity.opportunityType}
          </span>
        </div>
        <h1 class="mt-1 text-2xl font-bold tracking-tight text-slate-900">
          {opportunity.title}
        </h1>
      </div>
    </div>

    <div class="flex items-center gap-2">
      <button
        type="button"
        onclick={toggleSave}
        class="inline-flex items-center gap-1.5 rounded-lg border border-slate-300 bg-white px-3 py-1.5 text-sm font-medium text-slate-700 shadow-sm hover:bg-slate-50"
      >
        {opportunity.isSaved ? '📌 Đã lưu' : '📌 Lưu cơ hội'}
      </button>
      <a
        href="/intelligence/opportunities/{opportunity.id}/convert?type=idea"
        class="inline-flex items-center gap-1.5 rounded-lg bg-indigo-600 px-4 py-1.5 text-sm font-semibold text-white shadow-sm hover:bg-indigo-700"
      >
        💡 Chuyển đổi thành nội dung
      </a>
    </div>
  </div>

  <!-- Acceptance Target 1: Repair Warning Banner -->
  {#if opportunity.isRepairable}
    <div class="flex flex-col gap-2 rounded-xl border border-amber-200 bg-amber-50 p-4 text-sm text-amber-900 sm:flex-row sm:items-center sm:justify-between">
      <div class="flex items-center gap-2">
        <span class="text-lg">⚠️</span>
        <div>
          <span class="font-bold">Cần bổ sung thông tin để tiếp tục quy trình (Repair Required):</span>
          <ul class="list-inside list-disc text-xs text-amber-800">
            {#each opportunity.repairReasons as reason}
              <li>{reason}</li>
            {/each}
          </ul>
        </div>
      </div>
      {#if !opportunity.ownerUserId}
        <button
          type="button"
          onclick={() => assignModalOpen = true}
          class="inline-flex shrink-0 items-center gap-1 rounded-lg bg-amber-600 px-3 py-1.5 text-xs font-semibold text-white shadow-sm hover:bg-amber-700"
        >
          👤 Phân công người phụ trách
        </button>
      {/if}
    </div>
  {/if}

  <!-- Split View (65% / 35%) -->
  <div class="grid grid-cols-1 gap-6 lg:grid-cols-12">
    <!-- Main Panel (65% -> 8 cols) -->
    <div class="space-y-6 lg:col-span-8">
      <!-- AI Analysis Card -->
      <div class="rounded-xl border border-slate-200 bg-white p-6 shadow-sm">
        <h2 class="text-base font-bold text-slate-900">🤖 Phân tích trí tuệ nhân tạo (AI Copilot Analysis)</h2>
        <p class="mt-3 text-sm leading-relaxed text-slate-700">
          {opportunity.summary}
        </p>

        <div class="mt-4 rounded-lg bg-slate-50 p-3 text-xs text-slate-600">
          <span class="font-semibold text-slate-800">Tại sao cơ hội này quan trọng:</span> {opportunity.whyItMatters}
        </div>

        <div class="mt-4 rounded-lg bg-indigo-50/70 p-3 text-xs text-indigo-900">
          <span class="font-semibold text-indigo-950">Gợi ý hành động tiếp theo:</span> {opportunity.suggestedNextStep}
        </div>
      </div>

      <!-- Score Breakdown -->
      <div class="rounded-xl border border-slate-200 bg-white p-6 shadow-sm">
        <h2 class="text-base font-bold text-slate-900">📊 Chi tiết chỉ số chấm điểm</h2>
        <div class="mt-4 space-y-3">
          <div>
            <div class="flex justify-between text-xs font-medium text-slate-700">
              <span>Tác động kỳ vọng (Expected Impact)</span>
              <span class="font-bold text-indigo-600">{opportunity.expectedImpact.score}/100</span>
            </div>
            <div class="mt-1 h-2 w-full rounded-full bg-slate-100">
              <div class="h-2 rounded-full bg-indigo-600" style="width: {opportunity.expectedImpact.score}%"></div>
            </div>
            <p class="mt-1 text-[11px] text-slate-500">{opportunity.expectedImpact.description}</p>
          </div>

          <div>
            <div class="flex justify-between text-xs font-medium text-slate-700">
              <span>Mức độ nỗ lực (Expected Effort — thấp hơn là tốt hơn)</span>
              <span class="font-bold text-emerald-600">{opportunity.expectedEffort.score}/100</span>
            </div>
            <div class="mt-1 h-2 w-full rounded-full bg-slate-100">
              <div class="h-2 rounded-full bg-emerald-500" style="width: {opportunity.expectedEffort.score}%"></div>
            </div>
            <p class="mt-1 text-[11px] text-slate-500">{opportunity.expectedEffort.description}</p>
          </div>
        </div>
      </div>

      <!-- Provenance Evidence Links (RULE-M04-001) -->
      <div class="rounded-xl border border-slate-200 bg-white p-6 shadow-sm">
        <h2 class="text-base font-bold text-slate-900">🔗 Bằng chứng và Nguồn gốc (Provenance Evidence)</h2>
        <p class="mt-1 text-xs text-slate-500">
          Mỗi cơ hội đều được bảo đảm tính truy nguyên nguồn gốc, gắn với xu hướng, tín hiệu hoặc đối thủ thực tế.
        </p>

        <div class="mt-4 divide-y divide-slate-100 rounded-lg border border-slate-200">
          {#each opportunity.sources as source}
            <div class="flex items-center justify-between p-3 text-sm">
              <div class="flex items-center gap-2">
                <span class="rounded bg-slate-100 px-2 py-0.5 text-xs font-semibold uppercase text-slate-700">
                  {source.sourceType}
                </span>
                <span class="font-medium text-slate-900">{source.sourceName}</span>
              </div>
              {#if source.sourceUrl}
                <a
                  href={source.sourceUrl}
                  target="_blank"
                  rel="noreferrer"
                  class="text-xs font-medium text-indigo-600 hover:underline"
                >
                  Mở liên kết ↗
                </a>
              {/if}
            </div>
          {/each}
        </div>
      </div>
    </div>

    <!-- Side Panel (35% -> 4 cols) -->
    <div class="space-y-6 lg:col-span-4">
      <!-- Quick Info -->
      <div class="rounded-xl border border-slate-200 bg-white p-6 shadow-sm">
        <h3 class="text-sm font-bold uppercase tracking-wider text-slate-900">Thông tin tổng quan</h3>
        <dl class="mt-4 divide-y divide-slate-100 text-xs">
          <div class="flex justify-between py-2">
            <dt class="text-slate-500">Trạng thái</dt>
            <dd class="font-semibold text-slate-900 uppercase">{opportunity.priorityState}</dd>
          </div>
          <div class="flex justify-between py-2">
            <dt class="text-slate-500">Người phụ trách</dt>
            <dd class="font-semibold text-slate-900">
              {opportunity.ownerUserId ? opportunity.ownerUserId : 'Chưa phân công ⚠️'}
            </dd>
          </div>
          <div class="flex justify-between py-2">
            <dt class="text-slate-500">Độ tin cậy</dt>
            <dd class="font-semibold text-indigo-600 uppercase">{opportunity.confidence}</dd>
          </div>
          <div class="flex justify-between py-2">
            <dt class="text-slate-500">Ngày phát hiện</dt>
            <dd class="text-slate-700">{new Date(opportunity.createdAt).toLocaleDateString('vi-VN')}</dd>
          </div>
        </dl>
      </div>

      <!-- Financial Estimation Non-Conflation Badge (RULE-M04-005) -->
      <div class="rounded-xl border border-slate-200 bg-white p-6 shadow-sm">
        <div class="flex items-center justify-between">
          <h3 class="text-sm font-bold uppercase tracking-wider text-slate-900">Dự toán tài chính</h3>
          <span class="rounded bg-amber-100 px-1.5 py-0.5 text-[10px] font-bold text-amber-800">
            ESTIMATE ONLY
          </span>
        </div>
        <div class="mt-3">
          <div class="text-2xl font-bold text-emerald-600">
            {(opportunity.estimatedProfit.amountCents / 100).toLocaleString('vi-VN')} đ
          </div>
          <p class="mt-2 text-xs leading-relaxed text-slate-500">
            {opportunity.estimatedProfit.explanation}
          </p>
        </div>
      </div>

      <!-- Quick Actions -->
      <div class="rounded-xl border border-slate-200 bg-white p-6 shadow-sm">
        <h3 class="text-sm font-bold uppercase tracking-wider text-slate-900">Hành động chuyển đổi</h3>
        <div class="mt-4 space-y-2">
          <a
            href="/intelligence/opportunities/{opportunity.id}/convert?type=idea"
            class="flex w-full items-center justify-center gap-2 rounded-lg bg-indigo-600 px-4 py-2.5 text-sm font-semibold text-white shadow-sm hover:bg-indigo-700"
          >
            💡 Tạo ý tưởng kịch bản
          </a>
          <a
            href="/intelligence/opportunities/{opportunity.id}/convert?type=script"
            class="flex w-full items-center justify-center gap-2 rounded-lg border border-slate-300 bg-white px-4 py-2.5 text-sm font-semibold text-slate-700 shadow-sm hover:bg-slate-50"
          >
            📝 Viết kịch bản chi tiết
          </a>
          {#if !opportunity.ownerUserId}
            <button
              type="button"
              onclick={() => assignModalOpen = true}
              class="flex w-full items-center justify-center gap-2 rounded-lg border border-amber-300 bg-amber-50 px-4 py-2 text-sm font-semibold text-amber-800 hover:bg-amber-100"
            >
              👤 Phân công người phụ trách
            </button>
          {/if}
        </div>
      </div>
    </div>
  </div>
</div>

<!-- Assign Owner Modal -->
{#if assignModalOpen}
  <div class="fixed inset-0 z-50 flex items-center justify-center bg-black/40 p-4">
    <div class="w-full max-w-md rounded-xl bg-white p-6 shadow-xl">
      <h3 class="text-lg font-bold text-slate-900">👤 Phân công người phụ trách</h3>
      <p class="mt-1 text-sm text-slate-500">
        Chọn thành viên để chịu trách nhiệm thúc đẩy cơ hội này.
      </p>

      <div class="mt-4">
        <label for="detailAssignUser" class="block text-xs font-semibold uppercase text-slate-600">Thành viên</label>
        <select
          id="detailAssignUser"
          bind:value={selectedOwner}
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
          onclick={() => assignModalOpen = false}
          class="rounded-lg border border-slate-300 px-4 py-2 text-sm font-medium text-slate-700 hover:bg-slate-50"
        >
          Hủy
        </button>
        <button
          type="button"
          onclick={assignOwner}
          class="rounded-lg bg-indigo-600 px-4 py-2 text-sm font-semibold text-white shadow-sm hover:bg-indigo-700"
        >
          Lưu phân công
        </button>
      </div>
    </div>
  </div>
{/if}

<script lang="ts">
  import { page } from '$app/state';
  import {
    validateStateTransition,
    isConcurrentConflict,
    type Opportunity,
  } from '$lib/opportunity';

  const opportunityId = page.params.id || 'opp-001';

  // State: Seed Opportunity
  let opportunity = $state<Opportunity>({
    id: opportunityId,
    workspaceId: 'ws-current-tenant',
    opportunityType: 'content',
    title: 'Morning skincare routine — chưa có trên TikTok VN',
    summary: 'Hiện chỉ có 3 video VN về morning routine. Trending +200% globally nhưng VN market chưa khai thác. Audience 18-25 match 92%.',
    whyItMatters: 'First mover advantage rất cao; đối thủ chưa phủ ngách buổi sáng.',
    expectedImpact: { score: 89, description: 'Lượng view kỳ vọng cao' },
    expectedEffort: { score: 35, description: 'Quay ngắn 30-45s' },
    priorityState: 'in_progress',
    priorityReason: 'Audience match 92%',
    suggestedNextStep: 'Tạo kịch bản POV buổi sáng 30 giây',
    ownerUserId: 'user-nguyen-van-a',
    confidence: 'high',
    sourceClass: 'inferred',
    convertedToType: '',
    convertedToId: '',
    sources: [
      {
        sourceType: 'trend',
        sourceId: 'trend-morning-glow',
        sourceName: 'Morning Glow #morningroutine'
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
      explanation: 'Dự toán doanh thu tiềm năng'
    },
    createdAt: '2026-11-03T02:00:00Z',
    updatedAt: '2026-11-03T02:00:00Z',
    isRepairable: false,
    repairReasons: []
  });

  // Wizard state
  let conversionType = $state<'idea' | 'script' | 'campaign'>('idea');
  let contentTitle = $state('Morning skincare routine — 3 bước tối giản cho da dầu');
  let selectedPlatform = $state('tiktok');
  let selectedFormat = $state('short_form');
  let notes = $state('Tập trung vào bước dưỡng ẩm và chống nắng; hook trong 3 giây đầu tiên.');
  let isSubmitting = $state(false);
  let errorMsg = $state<string | null>(null);
  let successNotice = $state<string | null>(null);

  function handleConvert() {
    isSubmitting = true;
    errorMsg = null;

    // Concurrency conflict check simulation (EC-M04-003)
    const expectedUpdatedAt = opportunity.updatedAt;
    if (isConcurrentConflict(opportunity.updatedAt, expectedUpdatedAt)) {
      errorMsg = 'Xung đột sửa đổi đồng thời: Cơ hội này vừa được cập nhật bởi thành viên khác. Vui lòng tải lại.';
      isSubmitting = false;
      return;
    }

    // State transition check (RULE-M04-004)
    const validation = validateStateTransition(opportunity.priorityState, 'converted', opportunity);
    if (!validation.allowed) {
      errorMsg = validation.error || 'Chuyển đổi trạng thái không hợp lệ.';
      isSubmitting = false;
      return;
    }

    // Transition successfully and record lineage (RULE-M04-006)
    opportunity.convertedToType = conversionType;
    opportunity.convertedToId = `converted-${conversionType}-001`;
    opportunity.priorityState = 'converted';
    opportunity.updatedAt = new Date().toISOString();

    isSubmitting = false;
    successNotice = `Đã chuyển đổi thành công sang ${conversionType}! Đang chuyển hướng...`;

    setTimeout(() => {
      window.location.href = `/intelligence/opportunities`;
    }, 1200);
  }
</script>

<svelte:head>
  <title>Chuyển đổi cơ hội thành nội dung — Creativanta</title>
</svelte:head>

<div class="mx-auto max-w-4xl space-y-6 p-6">
  <!-- Header -->
  <div class="flex items-center gap-3">
    <a
      href="/intelligence/opportunities/{opportunity.id}"
      class="inline-flex h-9 w-9 items-center justify-center rounded-lg border border-slate-300 bg-white text-slate-600 hover:bg-slate-50"
    >
      ←
    </a>
    <div>
      <h1 class="text-2xl font-bold tracking-tight text-slate-900">
        Chuyển đổi cơ hội thành nội dung sản xuất
      </h1>
      <p class="text-sm text-slate-500">
        AI tự động trích xuất thông tin phân tích để tạo ngay ý tưởng hoặc kịch bản với nguồn gốc được bảo tồn (M04).
      </p>
    </div>
  </div>

  <!-- Opportunity Summary Banner -->
  <div class="flex items-center justify-between rounded-xl border border-indigo-100 bg-indigo-50/50 p-4">
    <div class="flex items-center gap-3">
      <span class="rounded-full bg-indigo-600 px-2.5 py-1 text-xs font-bold text-white">
        ⭐ {opportunity.overallScore}
      </span>
      <div>
        <div class="text-xs uppercase font-semibold text-indigo-700">Cơ hội nguồn</div>
        <div class="text-sm font-bold text-slate-900">{opportunity.title}</div>
      </div>
    </div>
    <div class="text-xs text-slate-600">
      Trạng thái: <span class="font-semibold uppercase">{opportunity.priorityState}</span>
    </div>
  </div>

  {#if errorMsg}
    <div class="rounded-xl border border-rose-200 bg-rose-50 p-4 text-sm text-rose-800">
      ❌ {errorMsg}
    </div>
  {/if}

  {#if successNotice}
    <div class="rounded-xl border border-emerald-200 bg-emerald-50 p-4 text-sm font-semibold text-emerald-800">
      ✅ {successNotice}
    </div>
  {/if}

  <!-- Step 1: Chọn hình thức chuyển đổi -->
  <div class="rounded-xl border border-slate-200 bg-white p-6 shadow-sm">
    <h2 class="text-base font-bold text-slate-900">Bước 1: Chọn hình thức chuyển đổi</h2>
    <div class="mt-4 grid grid-cols-1 gap-4 sm:grid-cols-3">
      <button
        type="button"
        onclick={() => conversionType = 'idea'}
        class="flex flex-col items-start rounded-xl border p-4 text-left transition {conversionType === 'idea' ? 'border-indigo-600 bg-indigo-50/30 ring-2 ring-indigo-600' : 'border-slate-200 hover:border-slate-300'}"
      >
        <span class="text-2xl">💡</span>
        <span class="mt-2 text-sm font-bold text-slate-900">Tạo 1 ý tưởng mới</span>
        <span class="mt-1 text-xs text-slate-500">Nhanh chóng thêm vào Idea Board để ủ mầm và thảo luận với team.</span>
      </button>

      <button
        type="button"
        onclick={() => conversionType = 'script'}
        class="flex flex-col items-start rounded-xl border p-4 text-left transition {conversionType === 'script' ? 'border-indigo-600 bg-indigo-50/30 ring-2 ring-indigo-600' : 'border-slate-200 hover:border-slate-300'}"
      >
        <span class="text-2xl">📝</span>
        <span class="mt-2 text-sm font-bold text-slate-900">Viết kịch bản ngay</span>
        <span class="mt-1 text-xs text-slate-500">Mở Studio kịch bản với gợi ý hook và khung sườn 30s từ AI.</span>
      </button>

      <button
        type="button"
        onclick={() => conversionType = 'campaign'}
        class="flex flex-col items-start rounded-xl border p-4 text-left transition {conversionType === 'campaign' ? 'border-indigo-600 bg-indigo-50/30 ring-2 ring-indigo-600' : 'border-slate-200 hover:border-slate-300'}"
      >
        <span class="text-2xl">📦</span>
        <span class="mt-2 text-sm font-bold text-slate-900">Lên chiến dịch tổng</span>
        <span class="mt-1 text-xs text-slate-500">Tạo chuỗi nội dung đa kênh (TikTok, Reels, Shorts) theo kế hoạch tuần.</span>
      </button>
    </div>
  </div>

  <!-- Step 2: Chi tiết nội dung -->
  <div class="rounded-xl border border-slate-200 bg-white p-6 shadow-sm">
    <h2 class="text-base font-bold text-slate-900">Bước 2: Chi tiết nội dung sản xuất</h2>
    <div class="mt-4 space-y-4">
      <div>
        <label for="contentTitle" class="block text-xs font-semibold uppercase text-slate-600">Tiêu đề dự kiến</label>
        <input
          id="contentTitle"
          type="text"
          bind:value={contentTitle}
          class="mt-1 w-full rounded-lg border border-slate-300 p-2.5 text-sm font-medium text-slate-900 focus:border-indigo-500 focus:outline-none"
        />
      </div>

      <div class="grid grid-cols-1 gap-4 sm:grid-cols-2">
        <div>
          <label for="platformSelect" class="block text-xs font-semibold uppercase text-slate-600">Nền tảng chính</label>
          <select
            id="platformSelect"
            bind:value={selectedPlatform}
            class="mt-1 w-full rounded-lg border border-slate-300 p-2 text-sm text-slate-700 focus:border-indigo-500 focus:outline-none"
          >
            <option value="tiktok">🎵 TikTok (Short-form)</option>
            <option value="instagram">📸 Instagram Reels</option>
            <option value="youtube">▶️ YouTube Shorts</option>
            <option value="facebook">📘 Facebook Reels</option>
          </select>
        </div>

        <div>
          <label for="formatSelect" class="block text-xs font-semibold uppercase text-slate-600">Định dạng</label>
          <select
            id="formatSelect"
            bind:value={selectedFormat}
            class="mt-1 w-full rounded-lg border border-slate-300 p-2 text-sm text-slate-700 focus:border-indigo-500 focus:outline-none"
          >
            <option value="short_form">Video ngắn (30 - 60s)</option>
            <option value="pov">POV / Vlog kể chuyện</option>
            <option value="comparison">So sánh đối chứng sản phẩm</option>
            <option value="tutorial">Hướng dẫn từng bước (Step-by-step)</option>
          </select>
        </div>
      </div>

      <div>
        <label for="notesText" class="block text-xs font-semibold uppercase text-slate-600">Ghi chú sản xuất</label>
        <textarea
          id="notesText"
          rows="3"
          bind:value={notes}
          class="mt-1 w-full rounded-lg border border-slate-300 p-2.5 text-sm text-slate-700 focus:border-indigo-500 focus:outline-none"
        ></textarea>
      </div>

      <!-- Lineage preservation info (RULE-M04-006) -->
      <div class="rounded-lg bg-slate-50 p-3 text-xs text-slate-600">
        🛡️ <span class="font-semibold text-slate-800">Bảo tồn dòng xuất xứ (Lineage):</span> Đối tượng mới sẽ lưu liên kết ngược về Opportunity <code class="rounded bg-slate-200 px-1">{opportunity.id}</code> và các nguồn trend/competitor gốc.
      </div>
    </div>
  </div>

  <!-- Action Bar -->
  <div class="flex items-center justify-end gap-3 border-t border-slate-200 pt-4">
    <a
      href="/intelligence/opportunities/{opportunity.id}"
      class="rounded-lg border border-slate-300 px-4 py-2 text-sm font-medium text-slate-700 hover:bg-slate-50"
    >
      Hủy bỏ
    </a>
    <button
      type="button"
      onclick={handleConvert}
      disabled={isSubmitting}
      class="rounded-lg bg-indigo-600 px-5 py-2 text-sm font-semibold text-white shadow-sm hover:bg-indigo-700 disabled:opacity-50"
    >
      {isSubmitting ? 'Đang chuyển đổi...' : 'Xác nhận tạo và mở →'}
    </button>
  </div>
</div>

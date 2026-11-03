<script lang="ts">
  import { page } from '$app/stores';
  import {
    validateConversionEligibility,
    validateStateTransition,
    type Hook,
    type Idea,
    type IdeaStatus,
  } from '$lib/idea';
  import HookBankDrawer from '$lib/idea/HookBankDrawer.svelte';
  import SourceLineageBadge from '$lib/idea/SourceLineageBadge.svelte';

  const currentWorkspaceId = 'ws-current-tenant';
  const ideaId = $page.params.id;

  // Idea state
  let idea = $state<Idea>({
    ideaId: ideaId || 'idea-001',
    workspaceId: currentWorkspaceId,
    title: 'Hướng dẫn skincare mùa hè cho da dầu',
    description: 'Quy trình dưỡng ẩm tối giản 3 bước không gây bết dính trong thời tiết nóng ẩm.',
    audienceIntent: 'Học sinh sinh viên da dầu mụn tìm giải pháp kiềm dầu',
    creatorIntent: 'Giáo dục người xem kết hợp review nhẹ sản phẩm',
    suggestedFormat: 'short_form',
    suggestedDirection: 'Pacing nhanh, quay cận texture sản phẩm, nhạc nền năng động',
    status: 'selected',
    ideaScore: 92,
    createdBy: 'user-001',
    sources: [
      {
        sourceType: 'trend',
        sourceId: 'trend-summer-skin',
        sourceTitle: 'Chăm sóc da mùa hè #summerskincare (+180%)',
        sourceUrl: 'https://creativanta.app/trends/trend-summer-skin'
      },
      {
        sourceType: 'opportunity',
        sourceId: 'opp-skincare-gap',
        sourceTitle: 'Khoảng trống nội dung buổi sáng trên TikTok VN'
      }
    ],
    hooks: [
      {
        hookId: 'hk-1',
        workspaceId: currentWorkspaceId,
        ideaId: ideaId || 'idea-001',
        hookText: 'Nếu hè này da bạn đổ dầu như chảo mỡ, hãy dừng ngay 2 bước này!',
        hookType: 'question',
        effectivenessScore: 88,
        usageCount: 2,
        source: 'manual',
        createdAt: new Date().toISOString()
      },
      {
        hookId: 'hk-2',
        workspaceId: currentWorkspaceId,
        ideaId: ideaId || 'idea-001',
        hookText: '3 sai lầm khiến da bạn càng dưỡng càng nổi mụn vào mùa nóng!',
        hookType: 'shock',
        effectivenessScore: 92,
        usageCount: 0,
        source: 'ai_generated',
        createdAt: new Date().toISOString()
      }
    ],
    createdAt: new Date().toISOString(),
    updatedAt: new Date().toISOString(),
    sourceClass: 'inferred',
    confidence: 'high',
    angle: 'Góc bóc mẽ sai lầm skincare mùa nóng'
  });

  // Mock hook bank
  let availableHooks = $state<Hook[]>([
    {
      hookId: 'hk-bank-1',
      workspaceId: currentWorkspaceId,
      hookText: 'Bạn có đang lãng phí tiền vào những bước skincare này không?',
      hookType: 'question',
      effectivenessScore: 89,
      usageCount: 5,
      source: 'library',
      createdAt: new Date().toISOString()
    },
    {
      hookId: 'hk-bank-2',
      workspaceId: currentWorkspaceId,
      hookText: 'Đừng bao giờ bôi kem chống nắng theo cách này nếu không muốn da đen sạm!',
      hookType: 'shock',
      effectivenessScore: 96,
      usageCount: 12,
      source: 'library',
      createdAt: new Date().toISOString()
    },
    {
      hookId: 'hk-bank-3',
      workspaceId: currentWorkspaceId,
      hookText: 'Trước đây da mình bùng mụn mỗi mùa hè, cho đến khi mình phát hiện ra quy tắc này...',
      hookType: 'story',
      effectivenessScore: 85,
      usageCount: 3,
      source: 'library',
      createdAt: new Date().toISOString()
    }
  ]);

  let errorMessage = $state<string | null>(null);
  let successMessage = $state<string | null>(null);

  function handleTransition(target: IdeaStatus) {
    const check = validateStateTransition(idea.status, target);
    if (!check.valid) {
      errorMessage = check.error || 'Chuyển trạng thái không hợp lệ.';
      successMessage = null;
      return;
    }

    idea.status = target;
    idea.updatedAt = new Date().toISOString();
    errorMessage = null;
    successMessage = `Đã chuyển trạng thái sang '${target}' thành công!`;
  }

  function handleConvertToScript() {
    // Validate conversion eligibility per EC-M05-004
    const validation = validateConversionEligibility(idea);
    if (!validation.eligible) {
      errorMessage = validation.message || 'Không đủ điều kiện chuyển đổi sang kịch bản.';
      successMessage = null;
      return;
    }

    idea.status = 'converted';
    idea.convertedToType = 'script';
    idea.convertedToId = `script-${Date.now()}`;
    idea.updatedAt = new Date().toISOString();
    errorMessage = null;
    successMessage = '🎉 Đã chuyển đổi ý tưởng sang kịch bản (Script Lab M06)!';
  }

  function handleAddHook(hook: Hook) {
    if (idea.hooks.some((h) => h.hookId === hook.hookId)) {
      errorMessage = 'Hook này đã được gắn vào ý tưởng.';
      return;
    }
    idea.hooks = [...idea.hooks, { ...hook, ideaId: idea.ideaId }];
    successMessage = 'Đã thêm hook vào ý tưởng thành công!';
    errorMessage = null;
  }
</script>

<svelte:head>
  <title>{idea.title} — Chi tiết ý tưởng</title>
</svelte:head>

<div class="space-y-6">
  <!-- Breadcrumb & Header -->
  <div class="flex flex-col gap-2 sm:flex-row sm:items-center sm:justify-between">
    <div>
      <nav class="flex items-center gap-1.5 text-xs text-[#616c63] mb-1">
        <a href="/ideas" class="hover:text-[#274333]">Kho ý tưởng</a>
        <span>/</span>
        <span class="text-[#242924] font-medium">{idea.title}</span>
      </nav>
      <h1 class="text-xl font-bold tracking-tight text-[#242924] sm:text-2xl">
        {idea.title}
      </h1>
    </div>

    <!-- Stepper & Actions -->
    <div class="flex items-center gap-2">
      <span
        class="rounded-full px-3 py-1 text-xs font-semibold uppercase {idea.status === 'draft'
          ? 'bg-gray-100 text-gray-800'
          : idea.status === 'candidate'
          ? 'bg-blue-100 text-blue-800'
          : idea.status === 'selected'
          ? 'bg-amber-100 text-amber-800'
          : idea.status === 'converted'
          ? 'bg-purple-100 text-purple-800'
          : 'bg-zinc-100 text-zinc-700'}"
      >
        Trạng thái: {idea.status}
      </span>

      {#if idea.status === 'selected'}
        <button
          type="button"
          onclick={handleConvertToScript}
          class="rounded-md bg-[#274333] px-3.5 py-1.5 text-xs font-semibold text-white shadow-sm hover:bg-[#1f3528]"
        >
          🚀 Chuyển sang Script (M06)
        </button>
      {:else if idea.status === 'draft'}
        <button
          type="button"
          onclick={() => handleTransition('candidate')}
          class="rounded-md bg-blue-600 px-3 py-1.5 text-xs font-semibold text-white shadow-sm hover:bg-blue-700"
        >
          Duyệt thành ứng viên
        </button>
      {:else if idea.status === 'candidate'}
        <button
          type="button"
          onclick={() => handleTransition('selected')}
          class="rounded-md bg-amber-600 px-3 py-1.5 text-xs font-semibold text-white shadow-sm hover:bg-amber-700"
        >
          Chọn sản xuất ⭐
        </button>
      {/if}
    </div>
  </div>

  <!-- Messages -->
  {#if errorMessage}
    <div class="rounded-md bg-rose-50 p-3 text-xs font-medium text-rose-800 border border-rose-200">
      ⚠️ {errorMessage}
    </div>
  {/if}
  {#if successMessage}
    <div class="rounded-md bg-emerald-50 p-3 text-xs font-medium text-emerald-800 border border-emerald-200">
      {successMessage}
    </div>
  {/if}

  <div class="grid grid-cols-1 gap-6 lg:grid-cols-3">
    <!-- Main Content Info -->
    <div class="lg:col-span-2 space-y-6">
      <div class="rounded-lg border border-[#e7e2d7] bg-white p-5 shadow-sm space-y-4">
        <h3 class="text-sm font-semibold text-[#242924] border-b border-[#e7e2d7] pb-2">
          Thông tin chi tiết nội dung
        </h3>

        <div>
          <span class="block text-xs font-semibold text-[#616c63] mb-1">Mô tả nội dung</span>
          <p class="text-xs text-[#242924] leading-relaxed bg-[#fbf9f5] p-3 rounded border border-[#e7e2d7]">
            {idea.description || '(Chưa có mô tả)'}
          </p>
        </div>

        <div class="grid grid-cols-1 gap-3 sm:grid-cols-2">
          <div>
            <span class="block text-xs font-semibold text-[#616c63] mb-1">Ý đồ người xem (Audience Intent)</span>
            <p class="text-xs text-[#242924] bg-[#fbf9f5] p-2.5 rounded border border-[#e7e2d7]">
              {idea.audienceIntent || 'Không xác định'}
            </p>
          </div>
          <div>
            <span class="block text-xs font-semibold text-[#616c63] mb-1">Ý đồ người sáng tạo (Creator Intent)</span>
            <p class="text-xs text-[#242924] bg-[#fbf9f5] p-2.5 rounded border border-[#e7e2d7]">
              {idea.creatorIntent || 'Không xác định'}
            </p>
          </div>
        </div>

        <div class="grid grid-cols-1 gap-3 sm:grid-cols-2">
          <div>
            <span class="block text-xs font-semibold text-[#616c63] mb-1">Định dạng đề xuất</span>
            <span class="inline-block rounded bg-zinc-100 px-2.5 py-1 text-xs font-medium text-[#242924]">
              {idea.suggestedFormat}
            </span>
          </div>
          <div>
            <span class="block text-xs font-semibold text-[#616c63] mb-1">Góc tiếp cận (Angle)</span>
            <span class="text-xs text-[#242924] font-medium">
              {idea.angle || 'Chưa thiết lập'}
            </span>
          </div>
        </div>

        <div>
          <span class="block text-xs font-semibold text-[#616c63] mb-1">Chỉ dẫn quay dựng (Direction)</span>
          <p class="text-xs text-[#242924] bg-[#fbf9f5] p-2.5 rounded border border-[#e7e2d7]">
            {idea.suggestedDirection || 'Chưa có chỉ dẫn cụ thể.'}
          </p>
        </div>
      </div>

      <!-- Attached Hooks -->
      <div class="rounded-lg border border-[#e7e2d7] bg-white p-5 shadow-sm space-y-3">
        <div class="flex items-center justify-between border-b border-[#e7e2d7] pb-2">
          <h3 class="text-sm font-semibold text-[#242924]">
            Hooks đính kèm ý tưởng ({idea.hooks.length})
          </h3>
          <span class="text-xs text-[#616c63]">Sẽ tự động chuyển thành CTA/Hook trong kịch bản</span>
        </div>

        {#if idea.hooks.length === 0}
          <p class="text-xs text-[#616c63] py-2">
            Chưa có hook nào. Hãy chọn từ Kho Hook bên phải để đính kèm.
          </p>
        {:else}
          <div class="space-y-2">
            {#each idea.hooks as hook}
              <div class="rounded border border-[#e7e2d7] bg-[#fbf9f5] p-3 text-xs space-y-1">
                <div class="flex items-start justify-between gap-2">
                  <p class="font-medium text-[#242924]">"{hook.hookText}"</p>
                  <span class="rounded bg-emerald-100 px-1.5 py-0.5 text-[10px] font-bold text-emerald-800">
                    {hook.effectivenessScore} đ
                  </span>
                </div>
                <div class="flex items-center gap-3 text-[10px] text-[#616c63]">
                  <span>Phân loại: <strong>{hook.hookType}</strong></span>
                  <span>Nguồn: {hook.source === 'ai_generated' ? 'AI Gợi ý' : 'Thủ công'}</span>
                </div>
              </div>
            {/each}
          </div>
        {/if}
      </div>
    </div>

    <!-- Sidebar / Provenance Lineage & Hook Bank -->
    <div class="space-y-6">
      <!-- Provenance Lineage -->
      <div class="rounded-lg border border-[#e7e2d7] bg-white p-5 shadow-sm space-y-3">
        <h3 class="text-sm font-semibold text-[#242924] border-b border-[#e7e2d7] pb-2">
          Nguồn gốc ý tưởng (Lineage)
        </h3>
        <p class="text-xs text-[#616c63]">
          Mọi ý tưởng đều lưu giữ vết liên kết với tín hiệu gốc để đảm bảo tính minh bạch.
        </p>

        <div class="space-y-2 pt-1">
          {#each idea.sources as source}
            <div class="p-2 rounded border border-[#e7e2d7] bg-[#fbf9f5]">
              <SourceLineageBadge {source} />
            </div>
          {/each}
        </div>
      </div>

      <!-- Hook Bank Component -->
      <HookBankDrawer hooks={availableHooks} onSelectHook={handleAddHook} />
    </div>
  </div>
</div>

<script lang="ts">
  import {
    checkDuplicateIdea,
    validateStateTransition,
    type DuplicateWarning,
    type Hook,
    type Idea,
    type IdeaStatus,
  } from '$lib/idea';
  import DuplicateWarningBanner from '$lib/idea/DuplicateWarningBanner.svelte';
  import SourceLineageBadge from '$lib/idea/SourceLineageBadge.svelte';

  const currentWorkspaceId = 'ws-current-tenant';

  // Seed ideas matching M05 canonical data
  let ideas = $state<Idea[]>([
    {
      ideaId: 'idea-001',
      workspaceId: currentWorkspaceId,
      title: 'Hướng dẫn skincare mùa hè cho da dầu',
      description: 'Quy trình dưỡng ẩm tối giản 3 bước không gây bết dính trong thời tiết nóng ẩm.',
      audienceIntent: 'Học sinh sinh viên da dầu mụn tìm giải pháp nhẹ mặt',
      creatorIntent: 'Giáo dục người xem kết hợp review nhẹ kem chống nắng kiềm dầu',
      suggestedFormat: 'short_form',
      suggestedDirection: 'Pacing nhanh, quay cận texture sản phẩm',
      status: 'selected',
      ideaScore: 92,
      createdBy: 'user-001',
      sources: [
        {
          sourceType: 'trend',
          sourceId: 'trend-summer-skin',
          sourceTitle: 'Chăm sóc da mùa hè #summerskincare (+180%)',
          sourceUrl: 'https://creativanta.app/trends/trend-summer-skin'
        }
      ],
      hooks: [
        {
          hookId: 'hk-1',
          workspaceId: currentWorkspaceId,
          ideaId: 'idea-001',
          hookText: 'Nếu hè này da bạn đổ dầu như chảo mỡ, hãy dừng ngay 2 bước này!',
          hookType: 'question',
          effectivenessScore: 88,
          usageCount: 2,
          source: 'manual',
          createdAt: new Date().toISOString()
        }
      ],
      createdAt: new Date().toISOString(),
      updatedAt: new Date().toISOString(),
      sourceClass: 'inferred',
      confidence: 'high',
      angle: 'Góc bóc mẽ sai lầm skincare mùa nóng'
    },
    {
      ideaId: 'idea-002',
      workspaceId: currentWorkspaceId,
      title: 'So sánh kem chống nắng vật lý vs hoá học',
      description: 'Thử nghiệm thực tế dưới camera UV để xem loại nào kháng nước tốt hơn.',
      audienceIntent: 'Người tiêu dùng phân vân trước ma trận kem chống nắng',
      creatorIntent: 'Tạo niềm tin chuyên gia thông qua test thiết bị khoa học',
      suggestedFormat: 'review',
      suggestedDirection: 'Split-screen so sánh trực quan hai nửa mặt',
      status: 'candidate',
      ideaScore: 85,
      createdBy: 'user-002',
      sources: [
        {
          sourceType: 'opportunity',
          sourceId: 'opp-sunscreen-gap',
          sourceTitle: 'Thiếu hụt video kiểm chứng UV camera trên sàn'
        }
      ],
      hooks: [
        {
          hookId: 'hk-2',
          workspaceId: currentWorkspaceId,
          ideaId: 'idea-002',
          hookText: 'Sự thật camera UV sẽ khiến bạn sốc về lọ kem chống nắng giá rẻ!',
          hookType: 'shock',
          effectivenessScore: 94,
          usageCount: 0,
          source: 'ai_generated',
          createdAt: new Date().toISOString()
        }
      ],
      createdAt: new Date().toISOString(),
      updatedAt: new Date().toISOString(),
      sourceClass: 'official',
      confidence: 'medium_high',
      angle: 'Thực nghiệm trực quan bằng UV camera'
    },
    {
      ideaId: 'idea-003',
      workspaceId: currentWorkspaceId,
      title: 'Top 5 lỗi đánh kem nền bị mốc vào mùa nóng',
      description: 'Chỉ ra lỗi thường gặp và mẹo xịt khoáng khoá nền giữ nguyên 8 tiếng.',
      audienceIntent: 'Dân văn phòng cần lớp nền bền cả ngày',
      creatorIntent: 'Gắn link affiliate xịt khoáng kiềm dầu',
      suggestedFormat: 'listicle',
      suggestedDirection: 'Hướng dẫn mẹo thực chiến 60s',
      status: 'draft',
      ideaScore: 78,
      createdBy: 'user-001',
      sources: [
        {
          sourceType: 'comment_cluster',
          sourceId: 'cluster-cakey-makeup',
          sourceTitle: 'Hơn 40 bình luận hỏi về cách chống mốc nền mùa hè'
        }
      ],
      hooks: [],
      createdAt: new Date().toISOString(),
      updatedAt: new Date().toISOString(),
      sourceClass: 'inferred',
      confidence: 'medium',
      angle: 'Khắc phục sự cố makeup tức thì'
    }
  ]);

  // Form state
  let newTitle = $state('');
  let newDescription = $state('');
  let newFormat = $state('short_form');
  let selectedTab = $state<string>('all');
  let activeWarning = $state<DuplicateWarning | null>(null);
  let statusMessage = $state<{ type: 'success' | 'error'; text: string } | null>(null);

  // Filtered ideas
  let filteredIdeas = $derived(
    selectedTab === 'all'
      ? ideas
      : ideas.filter((item) => item.status === selectedTab)
  );

  function handleCheckDuplicate() {
    activeWarning = checkDuplicateIdea(newTitle, ideas, 0.85);
  }

  function handleCreateIdea(force = false) {
    if (!newTitle.trim()) {
      statusMessage = { type: 'error', text: 'Vui lòng nhập tiêu đề ý tưởng.' };
      return;
    }

    // Check duplicate if not forced
    if (!force) {
      const dup = checkDuplicateIdea(newTitle, ideas, 0.85);
      if (dup) {
        activeWarning = dup;
        return;
      }
    }

    const newId = `idea-${Date.now()}`;
    const newIdea: Idea = {
      ideaId: newId,
      workspaceId: currentWorkspaceId,
      title: newTitle.trim(),
      description: newDescription.trim(),
      audienceIntent: 'Người xem quan tâm',
      creatorIntent: 'Xây dựng tương tác',
      suggestedFormat: newFormat,
      suggestedDirection: '',
      status: 'draft',
      ideaScore: Math.floor(Math.random() * 20) + 75,
      createdBy: 'current-user',
      sources: [
        {
          sourceType: 'manual',
          sourceId: 'current-user',
          sourceTitle: 'Ghi chú nhanh'
        }
      ],
      hooks: [],
      createdAt: new Date().toISOString(),
      updatedAt: new Date().toISOString(),
      sourceClass: 'official',
      confidence: 'medium'
    };

    ideas = [newIdea, ...ideas];
    newTitle = '';
    newDescription = '';
    activeWarning = null;
    statusMessage = {
      type: 'success',
      text: force
        ? '✅ Đã lưu ý tưởng mới độc lập (không gộp tự động với ý tưởng tương tự).'
        : '✅ Đã tạo ý tưởng mới thành công!'
    };
  }

  function handlePromote(idea: Idea, target: IdeaStatus) {
    const check = validateStateTransition(idea.status, target);
    if (!check.valid) {
      statusMessage = { type: 'error', text: check.error || 'Chuyển trạng thái không hợp lệ.' };
      return;
    }

    idea.status = target;
    idea.updatedAt = new Date().toISOString();
    ideas = [...ideas];
    statusMessage = { type: 'success', text: `Đã chuyển ý tưởng sang '${target}' thành công!` };
  }
</script>

<svelte:head>
  <title>Kho ý tưởng (Idea Board) — Creativanta</title>
</svelte:head>

<div class="space-y-6">
  <!-- Page Header -->
  <div class="flex flex-col gap-2 sm:flex-row sm:items-center sm:justify-between">
    <div>
      <div class="flex items-center gap-2">
        <span class="rounded bg-[#274333] px-2 py-0.5 text-xs font-semibold text-[#fbf9f5]">
          M05
        </span>
        <h1 class="text-2xl font-bold tracking-tight text-[#242924] sm:text-3xl">
          Kho ý tưởng (Idea Board)
        </h1>
      </div>
      <p class="text-sm text-[#616c63] mt-1">
        Thu thập, phát hiện trùng lặp (&gt;85%), gắn hook mở đầu và bảo toàn nguồn gốc (lineage) trước khi sản xuất kịch bản.
      </p>
    </div>

    <div class="flex items-center gap-2">
      <span class="rounded-md border border-[#e7e2d7] bg-[#ffffff] px-3 py-1.5 text-xs font-medium text-[#242924]">
        Phase: P3 (Hoạt động)
      </span>
      <a
        href="/ideas/new"
        class="rounded-md bg-[#274333] px-3 py-1.5 text-xs font-semibold text-white shadow-sm hover:bg-[#1f3528]"
      >
        ➕ Thêm ý tưởng chi tiết
      </a>
    </div>
  </div>

  <!-- Status Notification -->
  {#if statusMessage}
    <div
      class="rounded-md p-3 text-xs font-medium flex items-center justify-between {statusMessage.type ===
      'success'
        ? 'bg-emerald-50 text-emerald-800 border border-emerald-200'
        : 'bg-rose-50 text-rose-800 border border-rose-200'}"
    >
      <span>{statusMessage.text}</span>
      <button
        type="button"
        onclick={() => (statusMessage = null)}
        class="text-gray-500 hover:text-gray-700 ml-2"
      >
        ✕
      </button>
    </div>
  {/if}

  <!-- Quick Capture Form & Duplicate Detection -->
  <div class="rounded-lg border border-[#e7e2d7] bg-white p-5 shadow-sm space-y-4">
    <div class="flex items-center justify-between border-b border-[#e7e2d7] pb-3">
      <h3 class="text-sm font-semibold text-[#242924]">
        ⚡ Quick Capture — Tạo ý tưởng nhanh
      </h3>
      <span class="text-xs text-[#616c63]">
        Hỗ trợ kiểm tra trùng lặp tự động (&gt;85%) mà không âm thầm gộp
      </span>
    </div>

    {#if activeWarning}
      <DuplicateWarningBanner
        warning={activeWarning}
        onProceedAnyway={() => handleCreateIdea(true)}
        onViewExisting={(id) => {
          window.location.href = `/ideas/${id}`;
        }}
        onDismiss={() => (activeWarning = null)}
      />
    {/if}

    <div class="grid grid-cols-1 gap-3 sm:grid-cols-12">
      <div class="sm:col-span-6">
        <label for="idea-title" class="block text-xs font-medium text-[#242924] mb-1">
          Tiêu đề ý tưởng *
        </label>
        <input
          id="idea-title"
          type="text"
          bind:value={newTitle}
          oninput={handleCheckDuplicate}
          placeholder="Ví dụ: 5 cách chăm sóc da mùa hè..."
          class="w-full rounded-md border border-[#e7e2d7] px-3 py-2 text-xs text-[#242924] focus:border-[#274333] focus:outline-none focus:ring-1 focus:ring-[#274333]"
        />
      </div>

      <div class="sm:col-span-4">
        <label for="idea-format" class="block text-xs font-medium text-[#242924] mb-1">
          Định dạng
        </label>
        <select
          id="idea-format"
          bind:value={newFormat}
          class="w-full rounded-md border border-[#e7e2d7] px-3 py-2 text-xs text-[#242924] focus:border-[#274333] focus:outline-none focus:ring-1 focus:ring-[#274333]"
        >
          <option value="short_form">Video ngắn (Short-form 30-60s)</option>
          <option value="review">Đánh giá sản phẩm (Review)</option>
          <option value="tutorial">Hướng dẫn (Tutorial / How-to)</option>
          <option value="live">Kịch bản Live Commerce</option>
          <option value="listicle">Top danh sách (Listicle)</option>
        </select>
      </div>

      <div class="sm:col-span-2 flex items-end">
        <button
          type="button"
          onclick={() => handleCreateIdea(false)}
          class="w-full rounded-md bg-[#274333] py-2 px-3 text-xs font-semibold text-white shadow-sm hover:bg-[#1f3528]"
        >
          Lưu ý tưởng
        </button>
      </div>
    </div>
  </div>

  <!-- Status Tabs -->
  <div class="flex border-b border-[#e7e2d7] gap-2 overflow-x-auto pb-1 text-xs">
    {#each [
      { key: 'all', label: 'Tất cả' },
      { key: 'draft', label: '📥 Bản nháp (Inbox)' },
      { key: 'candidate', label: '🔍 Ứng viên (Candidate)' },
      { key: 'selected', label: '⭐ Được chọn (Selected)' },
      { key: 'converted', label: '🎬 Đã chuyển đổi (Converted)' },
      { key: 'archived', label: '📦 Lưu trữ (Archived)' }
    ] as tab}
      <button
        type="button"
        onclick={() => (selectedTab = tab.key)}
        class="px-3 py-2 font-medium whitespace-nowrap border-b-2 transition-colors {selectedTab ===
        tab.key
          ? 'border-[#274333] text-[#274333]'
          : 'border-transparent text-[#616c63] hover:text-[#242924]'}"
      >
        {tab.label}
        <span class="ml-1 text-[11px] font-normal text-gray-500">
          ({tab.key === 'all'
            ? ideas.length
            : ideas.filter((i) => i.status === tab.key).length})
        </span>
      </button>
    {/each}
  </div>

  <!-- Idea Grid / List -->
  {#if filteredIdeas.length === 0}
    <div class="rounded-lg border border-dashed border-[#e7e2d7] p-8 text-center bg-white">
      <p class="text-sm font-medium text-[#242924]">Chưa có ý tưởng nào trong mục này</p>
      <p class="text-xs text-[#616c63] mt-1">
        Hãy nhập tiêu đề ở trên hoặc tạo từ Xu hướng (M02) và Cơ hội (M04).
      </p>
    </div>
  {:else}
    <div class="grid grid-cols-1 gap-4 md:grid-cols-2 lg:grid-cols-3">
      {#each filteredIdeas as idea (idea.ideaId)}
        <div
          class="rounded-lg border border-[#e7e2d7] bg-white p-4 shadow-sm flex flex-col justify-between hover:shadow-md transition-shadow"
        >
          <div class="space-y-3">
            <div class="flex items-start justify-between gap-2">
              <a
                href="/ideas/{idea.ideaId}"
                class="font-semibold text-sm text-[#242924] hover:text-[#274333] line-clamp-2"
              >
                {idea.title}
              </a>
              <span
                class="shrink-0 rounded bg-emerald-100 px-2 py-0.5 text-xs font-bold text-emerald-800"
                title="Điểm tiềm năng AI"
              >
                {idea.ideaScore} đ
              </span>
            </div>

            {#if idea.description}
              <p class="text-xs text-[#616c63] line-clamp-2 leading-relaxed">
                {idea.description}
              </p>
            {/if}

            <!-- Sources Lineage -->
            <div class="space-y-1">
              {#each idea.sources as src}
                <SourceLineageBadge source={src} />
              {/each}
            </div>

            <!-- Hooks summary -->
            {#if idea.hooks && idea.hooks.length > 0}
              <div class="rounded bg-[#fbf9f5] p-2 text-[11px] text-[#242924] border border-[#e7e2d7]">
                <span class="font-semibold text-[#274333]">Hook gợi ý:</span> "{idea.hooks[0].hookText}"
              </div>
            {/if}
          </div>

          <!-- Card Footer & State Action -->
          <div class="mt-4 pt-3 border-t border-[#e7e2d7] flex items-center justify-between text-xs">
            <span
              class="capitalize rounded px-2 py-0.5 text-[11px] font-medium {idea.status ===
              'draft'
                ? 'bg-gray-100 text-gray-700'
                : idea.status === 'candidate'
                ? 'bg-blue-100 text-blue-800'
                : idea.status === 'selected'
                ? 'bg-amber-100 text-amber-800'
                : idea.status === 'converted'
                ? 'bg-purple-100 text-purple-800'
                : 'bg-zinc-100 text-zinc-600'}"
            >
              {idea.status}
            </span>

            <div class="flex items-center gap-1.5">
              {#if idea.status === 'draft'}
                <button
                  type="button"
                  onclick={() => handlePromote(idea, 'candidate')}
                  class="rounded bg-gray-100 px-2 py-1 text-[11px] font-medium text-gray-800 hover:bg-gray-200"
                >
                  Duyệt ứng viên →
                </button>
              {:else if idea.status === 'candidate'}
                <button
                  type="button"
                  onclick={() => handlePromote(idea, 'selected')}
                  class="rounded bg-amber-600 px-2 py-1 text-[11px] font-medium text-white hover:bg-amber-700"
                >
                  Chọn sản xuất ⭐
                </button>
              {:else if idea.status === 'selected'}
                <a
                  href="/ideas/{idea.ideaId}"
                  class="rounded bg-[#274333] px-2 py-1 text-[11px] font-medium text-white hover:bg-[#1f3528]"
                >
                  Chuyển sang script 📝
                </a>
              {:else if idea.status === 'converted'}
                <span class="text-[11px] text-purple-700 font-medium">
                  Đã thành kịch bản
                </span>
              {/if}
            </div>
          </div>
        </div>
      {/each}
    </div>
  {/if}
</div>

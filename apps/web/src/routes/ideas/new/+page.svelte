<script lang="ts">
  import {
    checkDuplicateIdea,
    type DuplicateWarning,
    type Idea,
  } from '$lib/idea';
  import DuplicateWarningBanner from '$lib/idea/DuplicateWarningBanner.svelte';

  const currentWorkspaceId = 'ws-current-tenant';

  let title = $state('');
  let description = $state('');
  let audienceIntent = $state('');
  let creatorIntent = $state('');
  let suggestedFormat = $state('short_form');
  let angle = $state('');
  let hookText = $state('');

  let activeWarning = $state<DuplicateWarning | null>(null);
  let statusMessage = $state<{ type: 'success' | 'error'; text: string } | null>(null);

  // Existing mock ideas to check against
  const existingIdeas: Idea[] = [
    {
      ideaId: 'idea-001',
      workspaceId: currentWorkspaceId,
      title: 'Hướng dẫn skincare mùa hè cho da dầu',
      description: 'Quy trình tối giản 3 bước',
      audienceIntent: '',
      creatorIntent: '',
      suggestedFormat: 'short_form',
      suggestedDirection: '',
      status: 'selected',
      ideaScore: 92,
      createdBy: 'user-001',
      sources: [],
      hooks: [],
      createdAt: '',
      updatedAt: ''
    }
  ];

  function handleCheckDuplicate() {
    activeWarning = checkDuplicateIdea(title, existingIdeas, 0.85);
  }

  function handleSave(force = false) {
    if (!title.trim()) {
      statusMessage = { type: 'error', text: 'Vui lòng nhập tiêu đề ý tưởng.' };
      return;
    }

    if (!force) {
      const dup = checkDuplicateIdea(title, existingIdeas, 0.85);
      if (dup) {
        activeWarning = dup;
        return;
      }
    }

    statusMessage = {
      type: 'success',
      text: force
        ? '✅ Đã lưu ý tưởng mới độc lập (không gộp tự động với ý tưởng tương tự).'
        : '✅ Đã tạo ý tưởng mới thành công!'
    };
    activeWarning = null;
  }
</script>

<svelte:head>
  <title>Tạo ý tưởng mới — Creativanta</title>
</svelte:head>

<div class="max-w-3xl mx-auto space-y-6">
  <div class="flex items-center justify-between border-b border-[#e7e2d7] pb-3">
    <div>
      <h1 class="text-xl font-bold tracking-tight text-[#242924]">
        Tạo ý tưởng mới (M05 Idea Engine)
      </h1>
      <p class="text-xs text-[#616c63] mt-0.5">
        Bảo toàn nguồn gốc và tự động phát hiện trùng lặp (&gt;85%)
      </p>
    </div>
    <a
      href="/ideas"
      class="text-xs font-semibold text-[#274333] hover:underline"
    >
      ← Quay lại Kho ý tưởng
    </a>
  </div>

  {#if statusMessage}
    <div
      class="rounded-md p-3 text-xs font-medium {statusMessage.type === 'success'
        ? 'bg-emerald-50 text-emerald-800 border border-emerald-200'
        : 'bg-rose-50 text-rose-800 border border-rose-200'}"
    >
      {statusMessage.text}
    </div>
  {/if}

  {#if activeWarning}
    <DuplicateWarningBanner
      warning={activeWarning}
      onProceedAnyway={() => handleSave(true)}
      onViewExisting={(id) => {
        window.location.href = `/ideas/${id}`;
      }}
      onDismiss={() => (activeWarning = null)}
    />
  {/if}

  <form
    onsubmit={(e) => {
      e.preventDefault();
      handleSave(false);
    }}
    class="rounded-lg border border-[#e7e2d7] bg-white p-6 shadow-sm space-y-4 text-xs"
  >
    <div>
      <label for="title" class="block font-medium text-[#242924] mb-1">
        Tiêu đề ý tưởng *
      </label>
      <input
        id="title"
        type="text"
        bind:value={title}
        oninput={handleCheckDuplicate}
        placeholder="Ví dụ: 5 cách chăm sóc da mùa hè..."
        class="w-full rounded-md border border-[#e7e2d7] px-3 py-2 text-xs text-[#242924] focus:border-[#274333] focus:outline-none focus:ring-1 focus:ring-[#274333]"
      />
    </div>

    <div>
      <label for="desc" class="block font-medium text-[#242924] mb-1">
        Mô tả nội dung (Cần thiết trước khi chuyển thành kịch bản)
      </label>
      <textarea
        id="desc"
        rows="3"
        bind:value={description}
        placeholder="Mô tả tóm tắt nội dung video, góc quay, giá trị truyền tải..."
        class="w-full rounded-md border border-[#e7e2d7] px-3 py-2 text-xs text-[#242924] focus:border-[#274333] focus:outline-none focus:ring-1 focus:ring-[#274333]"
      ></textarea>
    </div>

    <div class="grid grid-cols-1 gap-4 sm:grid-cols-2">
      <div>
        <label for="format" class="block font-medium text-[#242924] mb-1">
          Định dạng đề xuất
        </label>
        <select
          id="format"
          bind:value={suggestedFormat}
          class="w-full rounded-md border border-[#e7e2d7] px-3 py-2 text-xs text-[#242924] focus:border-[#274333] focus:outline-none focus:ring-1 focus:ring-[#274333]"
        >
          <option value="short_form">Video ngắn (Short-form 30-60s)</option>
          <option value="review">Đánh giá sản phẩm (Review)</option>
          <option value="tutorial">Hướng dẫn thực hành (Tutorial)</option>
          <option value="live">Live Commerce</option>
          <option value="listicle">Top danh sách (Listicle)</option>
        </select>
      </div>

      <div>
        <label for="angle" class="block font-medium text-[#242924] mb-1">
          Góc tiếp cận (Angle)
        </label>
        <input
          id="angle"
          type="text"
          bind:value={angle}
          placeholder="Ví dụ: Bóc mẽ sai lầm, Trước/Sau..."
          class="w-full rounded-md border border-[#e7e2d7] px-3 py-2 text-xs text-[#242924] focus:border-[#274333] focus:outline-none focus:ring-1 focus:ring-[#274333]"
        />
      </div>
    </div>

    <div class="grid grid-cols-1 gap-4 sm:grid-cols-2">
      <div>
        <label for="audience" class="block font-medium text-[#242924] mb-1">
          Ý đồ người xem (Audience Intent)
        </label>
        <input
          id="audience"
          type="text"
          bind:value={audienceIntent}
          placeholder="Ví dụ: Tìm kiếm giải pháp da dầu không bóng nhờn..."
          class="w-full rounded-md border border-[#e7e2d7] px-3 py-2 text-xs text-[#242924] focus:border-[#274333] focus:outline-none focus:ring-1 focus:ring-[#274333]"
        />
      </div>

      <div>
        <label for="creator" class="block font-medium text-[#242924] mb-1">
          Ý đồ người sáng tạo (Creator Intent)
        </label>
        <input
          id="creator"
          type="text"
          bind:value={creatorIntent}
          placeholder="Ví dụ: Tăng tương tác, gắn link affiliate..."
          class="w-full rounded-md border border-[#e7e2d7] px-3 py-2 text-xs text-[#242924] focus:border-[#274333] focus:outline-none focus:ring-1 focus:ring-[#274333]"
        />
      </div>
    </div>

    <div>
      <label for="hook" class="block font-medium text-[#242924] mb-1">
        Hook mở đầu (Tuỳ chọn)
      </label>
      <input
        id="hook"
        type="text"
        bind:value={hookText}
        placeholder="Câu mở đầu trong 3 giây đầu tiên..."
        class="w-full rounded-md border border-[#e7e2d7] px-3 py-2 text-xs text-[#242924] focus:border-[#274333] focus:outline-none focus:ring-1 focus:ring-[#274333]"
      />
    </div>

    <div class="pt-3 border-t border-[#e7e2d7] flex items-center justify-end gap-2">
      <a
        href="/ideas"
        class="rounded-md border border-[#e7e2d7] px-3 py-1.5 font-medium text-[#616c63] hover:bg-[#fbf9f5]"
      >
        Huỷ
      </a>
      <button
        type="submit"
        class="rounded-md bg-[#274333] px-4 py-1.5 font-semibold text-white shadow-sm hover:bg-[#1f3528]"
      >
        Lưu ý tưởng
      </button>
    </div>
  </form>
</div>

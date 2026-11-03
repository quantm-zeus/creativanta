<script lang="ts">
  interface Props {
    isOpen: boolean;
    sourceTitle: string;
    sourceIdeaId?: string;
    onRewrite: (targetPlatform: string, targetFormat: string, durationSeconds: number) => void;
    onCancel: () => void;
  }

  let { isOpen, sourceTitle, sourceIdeaId, onRewrite, onCancel }: Props = $props();

  let selectedPlatform = $state('TikTok');
  let duration = $state(60);

  let formatDerived = $derived.by(() => {
    if (selectedPlatform === 'YouTube') {
      return '16:9 horizontal long';
    }
    return '9:16 vertical short';
  });

  function handlePlatformChange(p: string) {
    selectedPlatform = p;
    if (p === 'YouTube') {
      duration = 180;
    } else {
      duration = 60;
    }
  }

  function handleConfirm() {
    onRewrite(selectedPlatform, formatDerived, duration);
  }
</script>

{#if isOpen}
  <div
    class="fixed inset-0 z-50 flex items-center justify-center bg-black/50 p-4 backdrop-blur-sm"
    data-testid="channel-rewrite-modal"
  >
    <div
      class="w-full max-w-lg rounded-xl bg-white p-6 shadow-2xl border border-indigo-200"
      role="dialog"
      aria-modal="true"
    >
      <div class="flex items-center gap-3 text-indigo-700">
        <span class="text-2xl">🔄</span>
        <h2 class="text-lg font-bold">
          Chuyển thể kịch bản đa kênh (Channel Rewrite)
        </h2>
      </div>

      <p class="mt-2 text-sm text-gray-600">
        Tạo kịch bản thích ứng cho nền tảng khác từ <strong class="text-gray-900">{sourceTitle}</strong>.
        Kịch bản mới sẽ được lưu dưới dạng độc lập nhưng giữ nguyên liên kết ý tưởng gốc
        <code class="rounded bg-gray-100 px-1 py-0.5 font-mono text-xs text-indigo-600">{sourceIdeaId || 'Không có ID ý tưởng'}</code> (RULE-M06-004, AC-4).
      </p>

      <div class="mt-4 space-y-4">
        <div>
          <span class="block text-xs font-semibold uppercase tracking-wider text-gray-700">
            Nền tảng đích
          </span>
          <div class="mt-2 grid grid-cols-3 gap-2">
            {#each ['TikTok', 'YouTube', 'Instagram Reels'] as platform}
              <button
                type="button"
                onclick={() => handlePlatformChange(platform)}
                class="rounded-lg border p-3 text-center text-xs font-bold transition {selectedPlatform === platform
                  ? 'border-indigo-600 bg-indigo-50 text-indigo-700 shadow-sm'
                  : 'border-gray-200 bg-white text-gray-700 hover:bg-gray-50'}"
              >
                {platform}
              </button>
            {/each}
          </div>
        </div>

        <div class="grid grid-cols-2 gap-4">
          <div>
            <label for="format-adaptive" class="block text-xs font-semibold text-gray-700">Định dạng thích ứng</label>
            <input
              id="format-adaptive"
              type="text"
              readonly
              value={formatDerived}
              class="mt-1 w-full rounded-lg border border-gray-300 bg-gray-50 p-2 text-xs font-mono text-gray-700"
            />
          </div>
          <div>
            <label for="duration-target" class="block text-xs font-semibold text-gray-700">Thời lượng mục tiêu (giây)</label>
            <input
              id="duration-target"
              type="number"
              bind:value={duration}
              min="5"
              max="900"
              class="mt-1 w-full rounded-lg border border-gray-300 p-2 text-xs font-mono text-gray-700 focus:border-indigo-500 focus:outline-none"
            />
          </div>
        </div>
      </div>

      <div class="mt-6 flex justify-end gap-3">
        <button
          type="button"
          onclick={onCancel}
          class="rounded-lg border border-gray-300 px-4 py-2 text-sm font-medium text-gray-700 hover:bg-gray-50 focus:outline-none"
        >
          Hủy bỏ
        </button>
        <button
          type="button"
          onclick={handleConfirm}
          class="rounded-lg bg-indigo-600 px-4 py-2 text-sm font-semibold text-white shadow-sm hover:bg-indigo-700 focus:outline-none"
          data-testid="confirm-rewrite-btn"
        >
          Tạo bản chuyển thể độc lập
        </button>
      </div>
    </div>
  </div>
{/if}

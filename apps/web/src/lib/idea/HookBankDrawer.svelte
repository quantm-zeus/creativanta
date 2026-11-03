<script lang="ts">
  import type { Hook, HookType } from './index';

  interface Props {
    hooks?: Hook[];
    onSelectHook?: (hook: Hook) => void;
  }

  let { hooks = [], onSelectHook = () => {} }: Props = $props();

  let selectedCategory = $state<HookType | 'all'>('all');

  const categories: { key: HookType | 'all'; label: string }[] = [
    { key: 'all', label: 'Tất cả' },
    { key: 'question', label: '❓ Câu hỏi' },
    { key: 'shock', label: '⚡ Gây sốc' },
    { key: 'story', label: '📖 Kể chuyện' },
    { key: 'pov', label: '👁️ POV' },
    { key: 'listicle', label: '🔢 Danh sách' },
    { key: 'contrast', label: '⚖️ Tương phản' }
  ];

  let filteredHooks = $derived(
    selectedCategory === 'all'
      ? hooks
      : hooks.filter((h) => h.hookType === selectedCategory)
  );
</script>

<div class="rounded-lg border border-[#e7e2d7] bg-[#ffffff] p-4 shadow-sm">
  <div class="flex items-center justify-between mb-3">
    <div class="flex items-center gap-2">
      <span class="rounded bg-[#274333] px-2 py-0.5 text-xs font-semibold text-[#fbf9f5]">
        M05 Hook Bank
      </span>
      <h3 class="text-sm font-semibold text-[#242924]">Kho Hook Mở Đầu Video</h3>
    </div>
    <span class="text-xs text-[#616c63]">
      {filteredHooks.length} mẫu khả dụng
    </span>
  </div>

  <!-- Category Pills -->
  <div class="flex flex-wrap gap-1.5 mb-3">
    {#each categories as cat}
      <button
        type="button"
        onclick={() => (selectedCategory = cat.key)}
        class="rounded-full px-2.5 py-1 text-xs font-medium transition-colors {selectedCategory ===
        cat.key
          ? 'bg-[#274333] text-white'
          : 'bg-[#fbf9f5] text-[#616c63] border border-[#e7e2d7] hover:bg-[#e7e2d7]'}"
      >
        {cat.label}
      </button>
    {/each}
  </div>

  <!-- Hook List -->
  <div class="space-y-2 max-h-72 overflow-y-auto pr-1">
    {#if filteredHooks.length === 0}
      <p class="py-4 text-center text-xs text-[#616c63]">
        Chưa có hook nào trong danh mục này.
      </p>
    {:else}
      {#each filteredHooks as hook}
        <div
          class="rounded-md border border-[#e7e2d7] bg-[#fbf9f5] p-3 text-xs space-y-2 hover:border-[#274333] transition-colors"
        >
          <div class="flex items-start justify-between gap-2">
            <p class="font-medium text-[#242924] leading-relaxed">
              "{hook.hookText}"
            </p>
            <button
              type="button"
              onclick={() => onSelectHook(hook)}
              class="shrink-0 rounded bg-[#274333] px-2 py-1 text-[11px] font-semibold text-white hover:bg-[#1f3528]"
            >
              Chọn
            </button>
          </div>

          <div class="flex items-center justify-between text-[11px] text-[#616c63] pt-1 border-t border-[#e7e2d7]">
            <span class="capitalize">Loại: {hook.hookType}</span>
            <div class="flex items-center gap-2">
              <span>Hiệu quả: <strong class="text-emerald-700">{hook.effectivenessScore}/100</strong></span>
              <span>Đã dùng: {hook.usageCount} lần</span>
              <span class="rounded bg-gray-200 px-1 py-0.5 text-[10px] text-gray-700">
                {hook.source === 'ai_generated' ? 'AI Gợi ý' : 'Thủ công'}
              </span>
            </div>
          </div>
        </div>
      {/each}
    {/if}
  </div>
</div>

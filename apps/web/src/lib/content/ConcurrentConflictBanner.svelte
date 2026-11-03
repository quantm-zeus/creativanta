<script lang="ts">
  interface Props {
    isStale: boolean;
    reason?: string;
    onReload?: () => void;
  }

  let { isStale, reason = 'Kịch bản đã có thay đổi mới từ tác giả. Vui lòng tải lại trước khi thực hiện thao tác duyệt hoặc lưu.', onReload }: Props = $props();
</script>

{#if isStale}
  <div
    class="flex items-center justify-between rounded-xl border border-red-300 bg-red-50 p-4 text-red-900 shadow-sm"
    data-testid="concurrent-conflict-banner"
  >
    <div class="flex items-center gap-3">
      <span class="text-xl">⚠️</span>
      <div>
        <h4 class="font-bold text-red-800">Xung đột phiên bản đồng thời (EC-M06-003)</h4>
        <p class="text-xs text-red-700">{reason}</p>
      </div>
    </div>
    {#if onReload}
      <button
        onclick={onReload}
        class="rounded-lg bg-red-600 px-3 py-1.5 text-xs font-semibold text-white shadow hover:bg-red-700 transition"
        data-testid="btn-reload-latest"
      >
        🔄 Tải lại bản mới nhất
      </button>
    {/if}
  </div>
{/if}

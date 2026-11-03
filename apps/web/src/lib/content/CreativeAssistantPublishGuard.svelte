<script lang="ts">
  interface Props {
    refusalNotice?: string;
  }

  let { refusalNotice }: Props = $props();
</script>

{#if refusalNotice}
  <div
    class="rounded-xl border border-amber-300 bg-amber-50 p-4 text-amber-900 shadow-sm"
    data-testid="publish-guard-refusal"
  >
    <div class="flex items-start gap-3">
      <span class="text-xl">🛑</span>
      <div>
        <h4 class="font-bold text-amber-900">Bảo vệ ranh giới xuất bản (P3 vs P5)</h4>
        <p class="mt-1 text-xs text-amber-800 leading-relaxed">{refusalNotice}</p>
        <div class="mt-2 flex items-center gap-2 text-[11px] text-amber-700">
          <span class="rounded bg-amber-200 px-1.5 py-0.5 font-mono">0 Tác vụ đăng bài</span>
          <span>•</span>
          <span class="rounded bg-amber-200 px-1.5 py-0.5 font-mono">0 Hiệu ứng phụ bên ngoài</span>
        </div>
      </div>
    </div>
  </div>
{/if}

<script lang="ts">
  import type { SourceChainLineage } from './index';

  interface Props {
    lineage: SourceChainLineage;
  }

  let { lineage }: Props = $props();
</script>

<div class="rounded-xl border border-gray-200 bg-white p-4 shadow-sm" data-testid="source-chain-lineage">
  <div class="mb-3 flex flex-wrap items-center justify-between gap-2 border-b border-gray-100 pb-2">
    <div class="flex items-center gap-2">
      <span class="text-sm font-semibold text-gray-800">Chuỗi nguồn gốc nội dung (Source Lineage)</span>
      {#if lineage.isProductionReady}
        <span class="rounded-full bg-emerald-100 px-2.5 py-0.5 text-xs font-medium text-emerald-800" data-testid="badge-ready">
          ✓ Sẵn sàng sản xuất (M07)
        </span>
      {:else if lineage.isComplete}
        <span class="rounded-full bg-blue-100 px-2.5 py-0.5 text-xs font-medium text-blue-800" data-testid="badge-approved">
          ✓ Đã duyệt kịch bản & brief
        </span>
      {:else}
        <span class="rounded-full bg-amber-100 px-2.5 py-0.5 text-xs font-medium text-amber-800" data-testid="badge-in-progress">
          Đang hoàn thiện
        </span>
      {/if}
    </div>
    {#if lineage.lineageHash}
      <span class="font-mono text-xs text-gray-400" title="Mã băm bằng chứng toàn vẹn chuỗi nguồn">
        Hash: {lineage.lineageHash.slice(0, 12)}...
      </span>
    {/if}
  </div>

  <!-- Lineage Flow Stepper -->
  <div class="flex flex-wrap items-center gap-2 text-xs">
    <!-- Trend Node -->
    {#if lineage.trend}
      <a
        href={lineage.trend.routeUrl}
        class="flex items-center gap-1.5 rounded-lg border border-purple-200 bg-purple-50 px-2.5 py-1 text-purple-700 transition hover:bg-purple-100"
        data-testid="node-trend"
      >
        <span class="font-bold">M02 Xu hướng:</span>
        <span class="max-w-[140px] truncate">{lineage.trend.title}</span>
      </a>
      <span class="text-gray-300">➔</span>
    {/if}

    <!-- Opportunity Node -->
    {#if lineage.opportunity}
      <a
        href={lineage.opportunity.routeUrl}
        class="flex items-center gap-1.5 rounded-lg border border-indigo-200 bg-indigo-50 px-2.5 py-1 text-indigo-700 transition hover:bg-indigo-100"
        data-testid="node-opportunity"
      >
        <span class="font-bold">M04 Cơ hội:</span>
        <span class="max-w-[140px] truncate">{lineage.opportunity.title}</span>
      </a>
      <span class="text-gray-300">➔</span>
    {/if}

    <!-- Idea Node -->
    {#if lineage.idea}
      <a
        href={lineage.idea.routeUrl}
        class="flex items-center gap-1.5 rounded-lg border border-amber-200 bg-amber-50 px-2.5 py-1 text-amber-800 transition hover:bg-amber-100"
        data-testid="node-idea"
      >
        <span class="font-bold">M05 Ý tưởng:</span>
        <span class="max-w-[140px] truncate">{lineage.idea.title}</span>
      </a>
      <span class="text-gray-300">➔</span>
    {/if}

    <!-- Script Node (Current) -->
    <div
      class="flex items-center gap-1.5 rounded-lg border border-blue-500 bg-blue-50 px-3 py-1 font-semibold text-blue-900 shadow-sm"
      data-testid="node-script"
    >
      <span>M06 Kịch bản:</span>
      <span class="max-w-[160px] truncate">{lineage.script.title}</span>
    </div>

    <!-- Asset Brief Node -->
    {#if lineage.assetBrief}
      <span class="text-gray-300">➔</span>
      <a
        href={lineage.assetBrief.routeUrl}
        class="flex items-center gap-1.5 rounded-lg border border-emerald-300 bg-emerald-50 px-2.5 py-1 text-emerald-800 transition hover:bg-emerald-100"
        data-testid="node-brief"
      >
        <span class="font-bold">M06/M07 Brief:</span>
        <span>{lineage.assetBrief.state}</span>
      </a>
    {/if}
  </div>
</div>

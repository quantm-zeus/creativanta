<script lang="ts">
  import { getDownstreamGatePolicy, type DownstreamTargetType } from './access_proof';

  let {
    targetType,
    opportunityId,
    convertedDraftId = undefined
  }: {
    targetType: DownstreamTargetType;
    opportunityId: string;
    convertedDraftId?: string;
  } = $props();

  let policy = $derived(getDownstreamGatePolicy(targetType));
</script>

<div class="rounded-xl border border-indigo-100 bg-indigo-50/60 p-4 text-xs text-indigo-950">
  <div class="flex items-start gap-3">
    <span class="text-xl">🚪</span>
    <div class="space-y-1">
      <div class="flex items-center gap-2">
        <span class="font-bold text-sm text-indigo-900">
          Chỉ định triển khai: Giai đoạn {policy.phaseAssigned} ({policy.taskRef})
        </span>
        <span class="rounded bg-indigo-200/70 px-1.5 py-0.5 font-mono text-[10px] font-bold text-indigo-800">
          {policy.targetModule}
        </span>
      </div>
      <p class="text-indigo-800/90 leading-relaxed">
        {policy.explanation}
      </p>
      <div class="mt-2 flex flex-wrap items-center gap-2 pt-1 border-t border-indigo-200/50">
        <span class="font-semibold text-indigo-900">🛡️ Bảo tồn dòng xuất xứ (Lineage):</span>
        <span class="font-mono text-slate-700 bg-white/80 px-1.5 py-0.5 rounded border border-indigo-200">
          Gốc: {opportunityId}
        </span>
        {#if convertedDraftId}
          <span class="font-mono text-slate-700 bg-white/80 px-1.5 py-0.5 rounded border border-indigo-200">
            Nháp: {convertedDraftId}
          </span>
        {/if}
        <span class="rounded-full bg-emerald-100 px-2 py-0.5 text-[10px] font-bold text-emerald-800">
          draft_linked
        </span>
      </div>
    </div>
  </div>
</div>

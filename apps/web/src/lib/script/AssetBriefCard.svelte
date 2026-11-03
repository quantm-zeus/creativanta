<script lang="ts">
  import {
    isAssetBriefComplete,
    isReadyForProductionEligible,
    type AssetBrief,
    type Script
  } from './index';

  interface Props {
    script: Script;
    brief: AssetBrief | null;
    onHandoffToProduction?: () => void;
  }

  let { script, brief, onHandoffToProduction }: Props = $props();

  let eligibility = $derived(isReadyForProductionEligible(script, brief));
  let briefComplete = $derived(isAssetBriefComplete(brief));
</script>

<div class="rounded-xl border border-indigo-100 bg-white p-6 shadow-sm" data-testid="asset-brief-card">
  <div class="flex items-center justify-between border-b border-gray-100 pb-4">
    <div>
      <h3 class="text-base font-bold text-gray-900 flex items-center gap-2">
        <span>🎬</span> Bản tóm tắt tài sản sản xuất (Asset Brief)
      </h3>
      <p class="text-xs text-gray-500 mt-0.5">
        Handoff sang Studio AI & Ekip quay dựng (M07 AI Video Studio)
      </p>
    </div>
    {#if brief}
      <span
        class="inline-flex items-center rounded-full px-2.5 py-0.5 text-xs font-semibold {briefComplete
          ? 'bg-emerald-100 text-emerald-800'
          : 'bg-amber-100 text-amber-800'}"
      >
        {briefComplete ? 'Hoàn chỉnh' : 'Bản nháp'}
      </span>
    {:else}
      <span class="inline-flex items-center rounded-full bg-gray-100 px-2.5 py-0.5 text-xs font-semibold text-gray-600">
        Chưa tạo
      </span>
    {/if}
  </div>

  {#if brief}
    <div class="mt-4 grid grid-cols-2 gap-4 text-sm">
      <div>
        <span class="text-xs font-medium text-gray-500">Định dạng đầu ra:</span>
        <p class="font-semibold text-gray-800 capitalize">{brief.outputType || 'Chưa đặt'}</p>
      </div>
      <div>
        <span class="text-xs font-medium text-gray-500">Tỷ lệ khung hình:</span>
        <p class="font-semibold text-gray-800">{brief.targetFormat || 'Chưa đặt'}</p>
      </div>
      <div>
        <span class="text-xs font-medium text-gray-500">Thời lượng mục tiêu:</span>
        <p class="font-semibold text-gray-800">{brief.targetDurationSeconds}s</p>
      </div>
      <div>
        <span class="text-xs font-medium text-gray-500">Nền tảng đích:</span>
        <p class="font-semibold text-gray-800">{brief.targetPlatforms.join(', ') || 'Chưa chọn'}</p>
      </div>
    </div>

    {#if brief.continuityRequirementsJson && brief.continuityRequirementsJson !== '{}'}
      <div class="mt-4 rounded-lg bg-slate-50 p-3 text-xs">
        <span class="font-bold text-slate-700">Yêu cầu tính liên tục (Continuity):</span>
        <p class="mt-1 font-mono text-slate-600 break-all">{brief.continuityRequirementsJson}</p>
      </div>
    {/if}
  {:else}
    <div class="mt-4 rounded-lg border border-dashed border-gray-300 p-6 text-center text-sm text-gray-500">
      <p>Chưa có Asset Brief cho kịch bản này.</p>
    </div>
  {/if}

  <!-- Readiness Gates Checklist (RULE-M06-005, RULE-M06-006, AC-2) -->
  <div class="mt-5 rounded-lg border border-gray-200 bg-gray-50 p-4">
    <h4 class="text-xs font-bold uppercase tracking-wider text-gray-600">
      Điều kiện sẵn sàng sản xuất (Ready for Production)
    </h4>
    <ul class="mt-2 space-y-1.5 text-xs">
      <li class="flex items-center gap-2">
        <span class={script.approvalState === 'approved' ? 'text-emerald-600' : 'text-rose-500'}>
          {script.approvalState === 'approved' ? '✓' : '✗'}
        </span>
        <span class={script.approvalState === 'approved' ? 'text-gray-700' : 'text-rose-700 font-medium'}>
          Kịch bản đã được Quản lý duyệt (Approval State = Approved)
        </span>
      </li>
      <li class="flex items-center gap-2">
        <span class={briefComplete ? 'text-emerald-600' : 'text-rose-500'}>
          {briefComplete ? '✓' : '✗'}
        </span>
        <span class={briefComplete ? 'text-gray-700' : 'text-rose-700 font-medium'}>
          Asset Brief hoàn chỉnh (Định dạng, thời lượng, yêu cầu liên tục)
        </span>
      </li>
    </ul>

    <div class="mt-4 flex items-center justify-between border-t border-gray-200 pt-3">
      {#if !eligibility.eligible}
        <p class="text-xs text-amber-700 italic">
          ⚠️ {eligibility.reasons[0]}
        </p>
      {:else}
        <p class="text-xs font-medium text-emerald-700">
          ✓ Đủ điều kiện chuyển sang giai đoạn sản xuất video.
        </p>
      {/if}

      <button
        type="button"
        disabled={!eligibility.eligible}
        onclick={onHandoffToProduction}
        class="inline-flex items-center gap-1.5 rounded-lg bg-indigo-600 px-4 py-2 text-xs font-bold text-white shadow hover:bg-indigo-700 disabled:cursor-not-allowed disabled:bg-gray-300 focus:outline-none"
        data-testid="ready-for-production-btn"
      >
        <span>🚀</span> Chuyển sang Sản xuất (M07)
      </button>
    </div>
  </div>
</div>

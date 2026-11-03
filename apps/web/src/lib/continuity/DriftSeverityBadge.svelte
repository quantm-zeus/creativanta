<script lang="ts">
  import { getDriftSeverityBadgeInfo, type DriftSeverity } from './types';

  interface Props {
    severity?: DriftSeverity;
    showWarningNotice?: boolean;
  }

  let { severity = 'none', showWarningNotice = false }: Props = $props();

  let badge = $derived(getDriftSeverityBadgeInfo(severity));
</script>

<div class="inline-flex items-center gap-1.5 px-2.5 py-1 rounded-full text-xs font-medium border {badge.badgeClass}">
  {#if badge.blocksPublish}
    <span class="w-1.5 h-1.5 rounded-full bg-rose-500 animate-pulse" aria-hidden="true"></span>
  {:else if badge.requiresWarning}
    <span class="w-1.5 h-1.5 rounded-full bg-amber-500" aria-hidden="true"></span>
  {:else}
    <span class="w-1.5 h-1.5 rounded-full bg-emerald-500" aria-hidden="true"></span>
  {/if}
  <span>{badge.label}</span>
</div>

{#if showWarningNotice && badge.blocksPublish}
  <p class="mt-1 text-xs text-rose-600 font-medium">
    ⚠️ Nội dung có độ lệch cao so với hồ sơ chuẩn (Character Pack). Cần Manager+ ghi lý do duyệt để mở khóa xuất bản (RULE-M08-005).
  </p>
{/if}

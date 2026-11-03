<script lang="ts">
  import { formatSourceLabel, type IdeaSourceRef } from './index';

  interface Props {
    source: IdeaSourceRef;
  }

  let { source }: Props = $props();

  let info = $derived(formatSourceLabel(source));
</script>

<div class="inline-flex items-center gap-1.5 text-xs">
  <span
    class="inline-flex items-center rounded-md px-2 py-0.5 font-medium border {info.isArchived
      ? 'bg-amber-50 text-amber-700 border-amber-200'
      : 'bg-emerald-50 text-emerald-800 border-emerald-200'}"
  >
    <span class="mr-1 text-[10px]">
      {#if source.sourceType === 'trend'}
        🔥
      {:else if source.sourceType === 'opportunity'}
        🎯
      {:else if source.sourceType === 'product'}
        🛍️
      {:else if source.sourceType === 'objection'}
        ⚡
      {:else if source.sourceType === 'comment_cluster'}
        💬
      {:else}
        📝
      {/if}
    </span>
    {info.typeLabel}:
    {#if info.url}
      <a
        href={info.url}
        class="ml-1 font-semibold underline hover:text-emerald-900"
        target="_blank"
        rel="noreferrer"
      >
        {info.title}
      </a>
    {:else}
      <span class="ml-1 font-semibold">{info.title}</span>
    {/if}

    {#if info.isArchived}
      <span
        class="ml-1.5 rounded bg-amber-200 px-1 py-0.2 text-[10px] text-amber-900"
        title={info.archiveNotice || 'Nguồn gốc đã hết hạn — dữ liệu chỉ đọc'}
      >
        Hết hạn / Lưu trữ
      </span>
    {/if}
  </span>
</div>

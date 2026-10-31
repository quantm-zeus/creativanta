<script lang="ts">
  import type { Snippet } from 'svelte';

  interface Props {
    title: string;
    description?: string;
    moduleTag?: string;
    statusTag?: string;
    isUnavailable?: boolean;
    children?: Snippet;
  }

  let {
    title,
    description,
    moduleTag,
    statusTag = 'P0 Shell',
    isUnavailable = false,
    children
  }: Props = $props();
</script>

<div
  class="flex flex-col justify-between rounded-xl border border-[#e7e2d7] bg-[#ffffff] p-5 shadow-xs transition-shadow hover:shadow-sm"
>
  <div>
    <div class="flex items-center justify-between gap-2 mb-2.5">
      <div class="flex items-center gap-2">
        <h3 class="text-base font-semibold text-[#242924] tracking-tight">{title}</h3>
        {#if moduleTag}
          <span
            class="rounded bg-[#f4f0e8] px-1.5 py-0.5 font-mono text-[11px] font-medium text-[#274333]"
          >
            {moduleTag}
          </span>
        {/if}
      </div>

      {#if isUnavailable}
        <span
          class="rounded border border-[#d94a31]/20 bg-[#fbeee9] px-2 py-0.5 text-[10px] font-semibold text-[#d94a31]"
        >
          Chưa khả dụng (P0)
        </span>
      {:else}
        <span
          class="rounded bg-[#eef3f0] px-2 py-0.5 text-[10px] font-medium text-[#274333]"
        >
          {statusTag}
        </span>
      {/if}
    </div>

    {#if description}
      <p class="text-xs leading-relaxed text-[#616c63] mb-4">
        {description}
      </p>
    {/if}
  </div>

  {#if children}
    <div class="pt-3 border-t border-[#f4f0e8]">
      {@render children()}
    </div>
  {/if}
</div>

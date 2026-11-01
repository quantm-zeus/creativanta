<script lang="ts">
  interface Props {
    workspaceName?: string;
  }

  let { workspaceName = 'Workspace Khách (P0)' }: Props = $props();
</script>

<header class="border-b border-[#e7e2d7] bg-[#fbf9f5] px-4 py-3 sm:px-6">
  <div class="mx-auto flex max-w-7xl items-center justify-between gap-4">
    <!-- Brand Mark & Identity -->
    <div class="flex items-center gap-3">
      <a href="/" class="flex items-center gap-2.5 text-inherit no-underline">
        <span
          class="flex h-8 w-8 items-center justify-center rounded-md bg-[#274333] text-sm font-black text-[#fbf9f5] shadow-xs"
        >
          C
        </span>
        <div class="flex flex-col">
          <span class="text-base font-bold tracking-tight text-[#242924]">
            Creativanta
          </span>
          <span class="text-[10px] font-mono text-[#616c63] leading-none">
            V5 Trend-to-Profit OS
          </span>
        </div>
      </a>
      <span
        class="hidden sm:inline-block rounded border border-[#d94a31]/30 bg-[#fbeee9] px-2 py-0.5 text-[11px] font-semibold text-[#d94a31]"
      >
        P0-01 Shell
      </span>
    </div>

    <!-- Workspace & Mode Indicator -->
    <div class="flex items-center gap-3">
      <div
        class="flex items-center gap-2 rounded-md border border-[#e7e2d7] bg-[#ffffff] px-2.5 py-1 text-xs text-[#242924] shadow-xs"
      >
        <span class="h-2 w-2 rounded-full bg-[#274333]" title="Trạng thái cục bộ"></span>
        <span class="font-medium truncate max-w-[140px] sm:max-w-none">{workspaceName}</span>
      </div>

      <div
        class="hidden lg:flex items-center gap-1.5 rounded-md border border-[#e7e2d7] bg-[#f4f0e8] px-2.5 py-1 text-[11px] text-[#616c63]"
      >
        <span>Auth:</span>
        <span class="font-mono text-[#d94a31]">Pre-auth (P0-03)</span>
      </div>
    </div>
  </div>
</header>

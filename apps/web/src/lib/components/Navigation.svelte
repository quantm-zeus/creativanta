<script lang="ts">
  import { JOB_NAV_ITEMS, type NavItem } from '$lib/constants/navigation';

  interface Props {
    currentPath?: string;
  }

  let { currentPath = '/' }: Props = $props();

  function isItemActive(href: string, path: string): boolean {
    if (href === '/') {
      return path === '/';
    }
    return path.startsWith(href);
  }
</script>

<!-- Desktop Navigation Bar -->
<nav
  class="hidden border-b border-[#e7e2d7] bg-[#fbf9f5] px-6 md:block"
  aria-label="Điều hướng chính theo công việc"
>
  <div class="mx-auto flex max-w-7xl items-center justify-between">
    <div class="flex space-x-1">
      {#each JOB_NAV_ITEMS as item (item.id)}
        {@const active = isItemActive(item.href, currentPath)}
        <a
          href={item.href}
          class="relative flex items-center gap-2 border-b-2 px-4 py-3.5 text-sm font-medium transition-colors {active
            ? 'border-[#d94a31] text-[#242924] font-semibold'
            : 'border-transparent text-[#616c63] hover:border-[#e7e2d7] hover:text-[#242924]'}"
          aria-current={active ? 'page' : undefined}
        >
          <span>{item.label}</span>
          <span
            class="text-[10px] font-mono px-1.5 py-0.5 rounded {active
              ? 'bg-[#274333] text-[#fbf9f5]'
              : 'bg-[#f4f0e8] text-[#8a968c]'}"
          >
            {item.moduleRef}
          </span>
        </a>
      {/each}
    </div>

    <div class="hidden items-center gap-3 lg:flex">
      <span
        class="inline-flex items-center gap-1.5 rounded-full border border-[#274333]/20 bg-[#eef3f0] px-3 py-1 text-xs font-medium text-[#274333]"
      >
        <span class="h-1.5 w-1.5 rounded-full bg-[#274333]"></span>
        P0-01 Shell Mode
      </span>
    </div>
  </div>
</nav>

<!-- Mobile Bottom Navigation Bar (Responsive at mobile widths) -->
<nav
  class="fixed bottom-0 left-0 right-0 z-40 border-t border-[#e7e2d7] bg-[#fbf9f5]/95 backdrop-blur-md px-2 py-1.5 md:hidden"
  aria-label="Điều hướng di động"
>
  <div class="flex items-center justify-around">
    {#each JOB_NAV_ITEMS as item (item.id)}
      {@const active = isItemActive(item.href, currentPath)}
      <a
        href={item.href}
        class="flex flex-col items-center justify-center py-1 px-2 rounded-lg text-center transition-colors {active
          ? 'text-[#d94a31] font-semibold'
          : 'text-[#616c63] hover:text-[#242924]'}"
        aria-current={active ? 'page' : undefined}
      >
        <span class="text-xs tracking-tight">{item.label}</span>
        <span
          class="text-[9px] font-mono mt-0.5 px-1 rounded {active
            ? 'bg-[#d94a31] text-[#fbf9f5]'
            : 'bg-[#e7e2d7] text-[#616c63]'}"
        >
          {item.id}
        </span>
      </a>
    {/each}
  </div>
</nav>

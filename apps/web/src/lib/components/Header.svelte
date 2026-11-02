<script lang="ts">
  import { authStore } from '$lib/auth';
  import { modeStore, OPERATOR_MODES, type OperatorModeId } from '$lib/constants/modes';
  import { notificationStore, unreadCount } from '$lib/notification/store';
  import { helpStore } from '$lib/help/store';
  import AuthStatus from './AuthStatus.svelte';

  interface Props {
    workspaceName?: string;
  }

  let { workspaceName }: Props = $props();

  let currentModeId = $derived($modeStore);
  let activeModeDef = $derived(modeStore.getModeDef(currentModeId));

  function handleModeChange(event: Event) {
    const target = event.target as HTMLSelectElement;
    modeStore.setMode(target.value as OperatorModeId);
  }
</script>

<header class="border-b border-[#e7e2d7] bg-[#fbf9f5] px-4 py-2.5 sm:px-6 sticky top-0 z-30 shadow-2xs">
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

      <!-- Operator Mode Selector (6 Modes Identity) -->
      <div class="hidden sm:flex items-center gap-1.5 rounded-lg border border-[#e7e2d7] bg-[#ffffff] px-2.5 py-1 shadow-2xs">
        <span class="text-[11px] font-medium text-[#616c63]">Vai trò:</span>
        <select
          id="operator-mode-select"
          aria-label="Chọn chế độ vận hành"
          value={currentModeId}
          onchange={handleModeChange}
          class="bg-transparent text-xs font-bold text-[#274333] cursor-pointer focus:outline-hidden"
        >
          {#each OPERATOR_MODES as mode}
            <option value={mode.id}>{mode.name}</option>
          {/each}
        </select>
      </div>
    </div>

    <!-- Right Controls: Mode (Mobile), Notification Bell, Help, Auth Status -->
    <div class="flex items-center gap-2 sm:gap-3">
      <!-- Mobile Mode Selector -->
      <div class="sm:hidden">
        <select
          aria-label="Chọn chế độ vận hành trên di động"
          value={currentModeId}
          onchange={handleModeChange}
          class="rounded border border-[#e7e2d7] bg-[#ffffff] px-2 py-1 text-xs font-semibold text-[#274333]"
        >
          {#each OPERATOR_MODES as mode}
            <option value={mode.id}>{mode.shortLabel}</option>
          {/each}
        </select>
      </div>

      <!-- Help Center Trigger Button -->
      <button
        type="button"
        onclick={() => helpStore.isOpen.open()}
        class="relative flex h-8 w-8 items-center justify-center rounded-full border border-[#e7e2d7] bg-[#ffffff] text-[#616c63] hover:border-[#274333] hover:text-[#274333] focus:outline-hidden focus:ring-2 focus:ring-[#274333] transition-colors"
        title="Trung tâm trợ giúp (Help Center)"
        aria-label="Mở trung tâm trợ giúp"
      >
        <span class="text-xs font-bold font-mono">?</span>
      </button>

      <!-- Scoped Notifications Bell Trigger -->
      <button
        type="button"
        onclick={() => notificationStore.isOpen.toggle()}
        class="relative flex h-8 w-8 items-center justify-center rounded-full border border-[#e7e2d7] bg-[#ffffff] text-[#616c63] hover:border-[#274333] hover:text-[#274333] focus:outline-hidden focus:ring-2 focus:ring-[#274333] transition-colors"
        title="Thông báo vận hành"
        aria-label="Mở trung tâm thông báo"
      >
        <svg class="h-4 w-4" fill="none" viewBox="0 0 24 24" stroke="currentColor">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 17h5l-1.405-1.405A2.032 2.032 0 0118 14.158V11a6.002 6.002 0 00-4-5.659V5a2 2 0 10-4 0v.341C7.67 6.165 6 8.388 6 11v3.159c0 .538-.214 1.055-.595 1.436L4 17h5m6 0v1a3 3 0 11-6 0v-1m6 0H9" />
        </svg>
        {#if $unreadCount > 0}
          <span
            class="absolute -top-1 -right-1 flex h-4 min-w-4 items-center justify-center rounded-full bg-[#d94a31] px-1 text-[9px] font-bold text-[#ffffff] ring-2 ring-[#ffffff]"
          >
            {$unreadCount}
          </span>
        {/if}
      </button>

      <!-- Workspace & Identity -->
      <AuthStatus />
    </div>
  </div>
</header>

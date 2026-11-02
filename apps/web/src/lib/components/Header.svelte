<script lang="ts">
  import { authStore } from '$lib/auth';
  import AuthStatus from './AuthStatus.svelte';

  interface Props {
    workspaceName?: string;
  }

  let { workspaceName }: Props = $props();

  let resolvedWorkspaceName = $derived(
    workspaceName || $authStore.activeWorkspace?.name || ($authStore.state === 'authenticated' ? 'Chưa chọn Workspace' : 'Khách vãng lai (P0-03)')
  );
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
        P0-03 Auth Shell
      </span>
    </div>

    <!-- Right Controls: Workspace & Auth Status -->
    <div class="flex items-center gap-3">
      <AuthStatus />
    </div>
  </div>
</header>

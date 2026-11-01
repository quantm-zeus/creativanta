<script lang="ts">
  import { authStore, CANONICAL_OPERATOR_MODES, type OperatorMode } from '$lib/auth';

  let showModeMenu = $state(false);

  function handleSignOut() {
    authStore.signOut();
  }

  function handleSelectMode(mode: OperatorMode) {
    authStore.setOperatorMode(mode);
    showModeMenu = false;
  }
</script>

<div class="flex items-center gap-2.5">
  <!-- Mode Selector Badge -->
  <div class="relative">
    <button
      type="button"
      onclick={() => (showModeMenu = !showModeMenu)}
      class="inline-flex items-center gap-1.5 rounded-md border border-[#e7e2d7] bg-[#ffffff] px-2.5 py-1 text-xs font-medium text-[#242924] hover:bg-[#f4f0e8] transition-colors shadow-xs"
      aria-haspopup="true"
      aria-expanded={showModeMenu}
      aria-label="Chọn chế độ vận hành (6 Operator Modes)"
    >
      <span class="h-2 w-2 rounded-full bg-[#d94a31]" aria-hidden="true"></span>
      <span class="font-medium">
        {CANONICAL_OPERATOR_MODES.find((m) => m.id === $authStore.activeMode)?.vietnameseLabel || 'Nhà sáng tạo'}
      </span>
      <span class="text-[10px] text-[#616c63]">▾</span>
    </button>

    {#if showModeMenu}
      <div
        class="absolute right-0 mt-1.5 w-64 rounded-lg border border-[#e7e2d7] bg-[#ffffff] p-1.5 shadow-lg z-50 text-xs"
        role="menu"
      >
        <div class="px-2 py-1 text-[11px] font-semibold text-[#616c63] border-b border-[#f4f0e8]">
          Chế độ vận hành (PRD §8.2)
        </div>
        {#each CANONICAL_OPERATOR_MODES as mode (mode.id)}
          <button
            type="button"
            onclick={() => handleSelectMode(mode.id)}
            class="w-full text-left px-2.5 py-1.5 rounded flex flex-col gap-0.5 transition-colors {$authStore.activeMode === mode.id
              ? 'bg-[#fbeee9] text-[#d94a31] font-semibold'
              : 'hover:bg-[#f4f0e8] text-[#242924]'}"
            role="menuitem"
          >
            <div class="flex items-center justify-between">
              <span>{mode.vietnameseLabel}</span>
              <span class="text-[10px] font-mono text-[#8a968c]">{mode.label}</span>
            </div>
            <span class="text-[10px] text-[#616c63] line-clamp-1 font-normal">
              {mode.description}
            </span>
          </button>
        {/each}
      </div>
    {/if}
  </div>

  <!-- Auth State & Workspace Indicator -->
  {#if $authStore.state === 'unconfigured'}
    <div
      class="flex items-center gap-1.5 rounded-md border border-[#e7e2d7] bg-[#f4f0e8] px-2.5 py-1 text-[11px] text-[#616c63]"
      title="Chưa cấu hình VITE_CLERK_PUBLISHABLE_KEY"
    >
      <span class="h-1.5 w-1.5 rounded-full bg-[#8a968c]"></span>
      <span class="font-mono text-[#8a968c]">Clerk: Chưa cấu hình (P0-03)</span>
    </div>
  {:else if $authStore.state === 'loading'}
    <div class="flex items-center gap-1.5 rounded-md border border-[#e7e2d7] bg-[#f4f0e8] px-2.5 py-1 text-xs text-[#616c63]">
      <span class="h-1.5 w-1.5 rounded-full bg-[#d94a31] animate-pulse"></span>
      <span>Đang tải...</span>
    </div>
  {:else if $authStore.state === 'authenticated'}
    <div class="flex items-center gap-2">
      <!-- Active Workspace Tag -->
      {#if $authStore.activeWorkspace}
        <a
          href="/workspaces"
          class="flex items-center gap-1.5 rounded-md border border-[#274333]/30 bg-[#eef3f0] px-2.5 py-1 text-xs text-[#274333] hover:bg-[#e4ede7] transition-colors"
          title="Bấm để đổi workspace"
        >
          <span class="h-2 w-2 rounded-full bg-[#274333]"></span>
          <span class="font-medium truncate max-w-[120px] sm:max-w-[160px]">
            {$authStore.activeWorkspace.name}
          </span>
          <span class="rounded bg-[#274333] px-1 py-0.2 text-[9px] uppercase font-semibold text-[#fbf9f5]">
            {$authStore.activeWorkspace.role}
          </span>
        </a>
      {:else}
        <a
          href="/workspaces"
          class="flex items-center gap-1.5 rounded-md border border-[#d94a31]/30 bg-[#fbeee9] px-2.5 py-1 text-xs text-[#d94a31] hover:bg-[#f6dfd8] transition-colors"
        >
          <span>Chọn Workspace ({$authStore.workspaces.length})</span>
        </a>
      {/if}

      <!-- User Info & Sign Out -->
      <div class="hidden sm:flex items-center gap-1.5 text-xs text-[#242924]">
        <span class="font-mono text-[#616c63] truncate max-w-[120px]" title={$authStore.user?.email}>
          {$authStore.user?.email || $authStore.user?.id}
        </span>
      </div>

      <button
        type="button"
        onclick={handleSignOut}
        class="rounded-md border border-[#e7e2d7] bg-[#ffffff] px-2 py-1 text-xs font-medium text-[#616c63] hover:text-[#d94a31] hover:border-[#d94a31]/40 transition-colors"
      >
        Đăng xuất
      </button>
    </div>
  {:else if $authStore.state === 'expired'}
    <div class="flex items-center gap-2">
      <span class="rounded border border-[#d94a31]/30 bg-[#fbeee9] px-2 py-0.5 text-xs font-medium text-[#d94a31]">
        Phiên hết hạn
      </span>
      <a
        href="/login"
        class="rounded-md bg-[#274333] px-2.5 py-1 text-xs font-medium text-[#fbf9f5] hover:bg-[#1e3528]"
      >
        Đăng nhập lại
      </a>
    </div>
  {:else}
    <!-- unauthenticated or error -->
    <a
      href="/login"
      class="inline-flex items-center gap-1 rounded-md bg-[#274333] px-3 py-1.5 text-xs font-medium text-[#fbf9f5] hover:bg-[#1e3528] transition-colors shadow-xs"
    >
      <span>Đăng nhập</span>
    </a>
  {/if}
</div>

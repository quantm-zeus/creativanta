<script lang="ts">
  import { goto } from '$app/navigation';
  import {
    authStore,
    CANONICAL_OPERATOR_MODES,
    slugifyWorkspaceName,
    type WorkspaceSummary,
    type OperatorMode
  } from '$lib/auth';
  import UnavailableNotice from '$lib/components/UnavailableNotice.svelte';

  let selectionError = $state<string | null>(null);
  let isSelecting = $state(false);

  // First-Workspace Creation / New Workspace Onboarding State (UF-02)
  let showCreateForm = $state(false);
  let newWorkspaceName = $state('');
  let newWorkspaceSlug = $state('');
  let slugManuallyEdited = $state(false);
  let newWorkspaceMode = $state<OperatorMode>($authStore.activeMode || 'creator');
  let isCreatingWorkspace = $state(false);
  let createWorkspaceError = $state<string | null>(null);
  let createWorkspaceSuccess = $state<string | null>(null);

  function handleNameInput(value: string) {
    newWorkspaceName = value;
    if (!slugManuallyEdited) {
      newWorkspaceSlug = slugifyWorkspaceName(value);
    }
  }

  async function handleCreateWorkspace(e: SubmitEvent) {
    e.preventDefault();
    createWorkspaceError = null;
    createWorkspaceSuccess = null;
    isCreatingWorkspace = true;

    try {
      const res = await authStore.createWorkspace({
        displayName: newWorkspaceName,
        slug: newWorkspaceSlug,
        defaultOperatorMode: newWorkspaceMode
      });

      if (!res.ok || !res.workspace) {
        createWorkspaceError =
          res.error || 'Không thể khởi tạo Workspace mới. Thông tin bạn nhập đã được giữ nguyên.';
        return;
      }

      createWorkspaceSuccess = `Đã tạo Workspace "${res.workspace.name}" thành công!`;
      showCreateForm = false;
      newWorkspaceName = '';
      newWorkspaceSlug = '';
      slugManuallyEdited = false;
      await goto('/');
    } finally {
      isCreatingWorkspace = false;
    }
  }

  async function handleSelectWorkspace(workspace: WorkspaceSummary) {
    selectionError = null;
    isSelecting = true;

    try {
      await authStore.selectWorkspace(workspace.id);
      await goto('/');
    } catch (err: any) {
      selectionError = err?.message || 'Không thể chọn không gian làm việc này';
    } finally {
      isSelecting = false;
    }
  }

  function handleSwitchMode(mode: OperatorMode) {
    authStore.setOperatorMode(mode);
    newWorkspaceMode = mode;
  }

  function getRoleBadgeClass(role: string): string {
    const r = role.toLowerCase();
    if (r === 'owner') {
      return 'bg-[#274333] text-[#fbf9f5] border-[#274333]';
    }
    if (r === 'admin' || r === 'manager') {
      return 'bg-[#3b5998] text-[#ffffff] border-[#3b5998]';
    }
    if (r === 'editor') {
      return 'bg-[#1e6f5c] text-[#ffffff] border-[#1e6f5c]';
    }
    return 'bg-[#f4f0e8] text-[#616c63] border-[#e7e2d7]';
  }
</script>

<svelte:head>
  <title>Chọn Workspace — Creativanta (W002)</title>
</svelte:head>

<div class="max-w-4xl mx-auto space-y-6 py-4">
  <!-- Header with Page Title & P0-03 Context -->
  <div class="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4 border-b border-[#e7e2d7] pb-5">
    <div>
      <div class="flex items-center gap-2">
        <span class="rounded bg-[#274333] px-2 py-0.5 text-xs font-semibold text-[#fbf9f5]">
          Màn hình W002
        </span>
        <h1 class="text-2xl font-bold tracking-tight text-[#242924]">
          Chọn Workspace
        </h1>
      </div>
      <p class="text-xs text-[#616c63] mt-1">
        Khám phá và chọn không gian làm việc đang hoạt động của bạn. Chuyển đổi workspace không cần đăng nhập lại (RULE-AUTH-003).
      </p>
    </div>

    <!-- Team & RBAC Link + Create Workspace Button -->
    <div class="flex items-center gap-2">
      <a
        href="/settings/team"
        class="inline-flex items-center gap-1.5 rounded-lg border border-[#274333] bg-[#ffffff] px-3 py-2 text-xs font-semibold text-[#274333] hover:bg-[#eef3f0] transition-colors"
      >
        <span>Team &amp; Vai trò (W115/W116)</span>
      </a>
      <button
        type="button"
        disabled={$authStore.state !== 'authenticated'}
        onclick={() => (showCreateForm = !showCreateForm)}
        class="inline-flex items-center gap-1.5 rounded-lg border border-[#274333] bg-[#274333] px-3 py-2 text-xs font-semibold text-[#fbf9f5] hover:bg-[#1e3528] transition-colors disabled:opacity-50 disabled:cursor-not-allowed"
      >
        <span>+ Tạo mới Workspace</span>
      </button>
    </div>
  </div>

  <!-- Operator Mode Switcher Ribbon (PRD §8.2: 6 Modes) -->
  <div class="rounded-xl border border-[#e7e2d7] bg-[#ffffff] p-4 shadow-xs">
    <div class="flex flex-col sm:flex-row sm:items-center justify-between gap-3 mb-3">
      <div>
        <h3 class="text-xs font-bold uppercase tracking-wider text-[#616c63]">
          Chế độ vận hành hiện tại (6 Operator Modes)
        </h3>
        <p class="text-[11px] text-[#8a968c]">
          Mỗi chế độ tập trung vào nhóm công việc và nhịp vận hành chuyên biệt.
        </p>
      </div>
      <span class="text-[11px] font-mono text-[#d94a31] bg-[#fbeee9] px-2 py-0.5 rounded font-semibold self-start sm:self-auto">
        Mode: {$authStore.activeMode}
      </span>
    </div>

    <div class="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-6 gap-2">
      {#each CANONICAL_OPERATOR_MODES as mode (mode.id)}
        <button
          type="button"
          onclick={() => handleSwitchMode(mode.id)}
          class="flex flex-col p-2.5 rounded-lg border text-left transition-all {$authStore.activeMode === mode.id
            ? 'border-[#d94a31] bg-[#fbeee9]/40 ring-1 ring-[#d94a31]'
            : 'border-[#e7e2d7] bg-[#fbf9f5] hover:border-[#8a968c]'}"
        >
          <span class="text-xs font-bold text-[#242924]">{mode.vietnameseLabel}</span>
          <span class="text-[10px] font-mono text-[#616c63] mt-0.5">{mode.label}</span>
        </button>
      {/each}
    </div>
  </div>

  {#if createWorkspaceSuccess}
    <div class="rounded-xl border border-emerald-200 bg-emerald-50 p-4 text-xs font-semibold text-emerald-900" role="status">
      {createWorkspaceSuccess}
    </div>
  {/if}

  {#if createWorkspaceError}
    <div class="rounded-xl border border-red-200 bg-red-50 p-4 text-xs text-red-800" role="alert">
      {createWorkspaceError}
    </div>
  {/if}

  {#if showCreateForm && $authStore.state === 'authenticated'}
    <form
      onsubmit={handleCreateWorkspace}
      class="rounded-2xl border border-[#274333]/30 bg-[#ffffff] p-6 shadow-sm space-y-4"
    >
      <div class="flex items-center justify-between border-b border-[#e7e2d7] pb-3">
        <div>
          <h2 class="text-base font-bold text-[#242924]">Tạo Workspace mới (Onboarding)</h2>
          <p class="text-xs text-[#616c63]">
            Khởi tạo không gian làm việc qua <code>WorkspaceService/Create</code> với vai trò Owner.
          </p>
        </div>
        <button
          type="button"
          onclick={() => (showCreateForm = false)}
          class="text-xs font-semibold text-[#616c63] hover:text-[#242924]"
        >
          Đóng ✕
        </button>
      </div>

      <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
        <div>
          <label for="ws-display-name" class="block text-xs font-semibold text-[#242924] mb-1">
            Tên hiển thị Workspace
          </label>
          <input
            id="ws-display-name"
            type="text"
            value={newWorkspaceName}
            oninput={(e) => handleNameInput(e.currentTarget.value)}
            required
            placeholder="Ví dụ: Viet Cosmetics Studio"
            class="w-full rounded-lg border border-[#e7e2d7] bg-[#fbf9f5] px-3 py-2 text-xs text-[#242924] focus:border-[#274333] focus:outline-none"
          />
        </div>

        <div>
          <label for="ws-slug" class="block text-xs font-semibold text-[#242924] mb-1">
            Slug định danh
          </label>
          <input
            id="ws-slug"
            type="text"
            value={newWorkspaceSlug}
            oninput={(e) => {
              slugManuallyEdited = true;
              newWorkspaceSlug = e.currentTarget.value;
            }}
            required
            placeholder="viet-cosmetics-studio"
            class="w-full rounded-lg border border-[#e7e2d7] bg-[#fbf9f5] px-3 py-2 text-xs font-mono text-[#242924] focus:border-[#274333] focus:outline-none"
          />
        </div>
      </div>

      <div>
        <label for="ws-default-mode" class="block text-xs font-semibold text-[#242924] mb-1">
          Chế độ vận hành mặc định (Default Operator Mode)
        </label>
        <select
          id="ws-default-mode"
          bind:value={newWorkspaceMode}
          class="w-full rounded-lg border border-[#e7e2d7] bg-[#fbf9f5] px-3 py-2 text-xs text-[#242924] focus:border-[#274333] focus:outline-none"
        >
          {#each CANONICAL_OPERATOR_MODES as mode (mode.id)}
            <option value={mode.id}>{mode.vietnameseLabel} ({mode.label})</option>
          {/each}
        </select>
      </div>

      <div class="flex justify-end gap-2 pt-2">
        <button
          type="button"
          onclick={() => (showCreateForm = false)}
          class="rounded-lg border border-[#e7e2d7] px-4 py-2 text-xs font-semibold text-[#616c63] hover:bg-[#f4f0e8]"
        >
          Hủy
        </button>
        <button
          type="submit"
          disabled={isCreatingWorkspace}
          class="rounded-lg bg-[#274333] px-4 py-2 text-xs font-semibold text-[#fbf9f5] hover:bg-[#1e3528] disabled:opacity-50"
        >
          {isCreatingWorkspace ? 'Đang tạo Workspace...' : 'Khởi tạo Workspace'}
        </button>
      </div>
    </form>
  {/if}

  <!-- State 1: Unauthenticated Guard -->
  {#if $authStore.state === 'unauthenticated' || $authStore.state === 'unconfigured'}
    <div class="space-y-4">
      <UnavailableNotice
        title="Yêu cầu phiên đăng nhập hợp lệ"
        domain="Identity / Discovery"
        requires="Clerk Authentication Session"
        message="Màn hình khám phá và chọn Workspace (W002) chỉ hiển thị khi có phiên đăng nhập xác thực từ Clerk IdP. Dữ liệu thành viên được phân quyền bảo mật cấp cơ sở dữ liệu."
      />

      <div class="rounded-xl border border-[#e7e2d7] bg-[#ffffff] p-6 text-center space-y-4">
        <p class="text-xs text-[#616c63]">
          Bạn chưa đăng nhập hoặc khóa Clerk chưa cấu hình.
        </p>
        <a
          href="/login?redirect=/workspaces"
          class="inline-flex items-center gap-2 rounded-lg bg-[#274333] px-5 py-2.5 text-xs font-semibold text-[#fbf9f5] hover:bg-[#1e3528] transition-colors"
        >
          <span>Đến trang Đăng nhập</span>
          <span>→</span>
        </a>
      </div>
    </div>

  <!-- State 2: Discovery Loading -->
  {:else if $authStore.isDiscoveryLoading}
    <div class="rounded-xl border border-[#e7e2d7] bg-[#ffffff] p-8 text-center space-y-3">
      <div class="inline-block h-6 w-6 animate-spin rounded-full border-2 border-[#274333] border-t-transparent"></div>
      <p class="text-xs text-[#616c63]">Đang truy vấn danh sách workspace từ cơ sở dữ liệu...</p>
    </div>

  <!-- State 3: Discovery Error / Unmounted Backend (Honest Unavailable State) -->
  {:else if $authStore.discoveryError}
    <div class="space-y-4">
      <UnavailableNotice
        title="Kết nối dịch vụ Workspace chưa khả dụng"
        domain="Backend Discovery (P0-03)"
        requires="Mounting of Go Discovery Endpoint"
        message={$authStore.discoveryError}
      />

      <div class="rounded-xl border border-[#e7e2d7] bg-[#ffffff] p-5 text-xs text-[#616c63] space-y-2">
        <p class="font-medium text-[#242924]">Giải thích trạng thái kiến trúc:</p>
        <p>
          Theo tài liệu <code>apps/api/internal/identity/README.md</code>, tầng backend ConnectRPC hiện được thiết lập ở trạng thái <em>fail-closed</em> và các endpoint nghiệp vụ chưa được gắn kết trực tiếp (unmounted). Giao diện hiển thị trạng thái trung thực này và không tạo dữ liệu giả lập.
        </p>
      </div>
    </div>

  <!-- State 4: Discovered Workspaces List -->
  {:else if $authStore.workspaces.length > 0}
    {#if selectionError}
      <div class="rounded-lg bg-[#fbeee9] border border-[#d94a31]/30 p-3 text-xs text-[#d94a31]">
        {selectionError}
      </div>
    {/if}

    <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
      {#each $authStore.workspaces as ws (ws.id)}
        {@const isCurrent = $authStore.activeWorkspace?.id === ws.id}
        <div
          class="rounded-xl border p-5 bg-[#ffffff] shadow-xs flex flex-col justify-between gap-4 transition-all {isCurrent
            ? 'border-[#274333] ring-1 ring-[#274333]'
            : 'border-[#e7e2d7] hover:border-[#8a968c]'}"
        >
          <div class="space-y-2">
            <div class="flex items-start justify-between gap-2">
              <div class="flex items-center gap-2">
                <span
                  class="h-2.5 w-2.5 rounded-full {ws.status === 'suspended'
                    ? 'bg-amber-500'
                    : ws.status === 'deactivated'
                    ? 'bg-red-500'
                    : 'bg-[#274333]'}"
                  title="Trạng thái: {ws.status || 'active'}"
                ></span>
                <h3 class="text-sm font-bold text-[#242924]">{ws.name}</h3>
              </div>
              <span class="rounded-sm border px-2 py-0.5 text-[10px] font-mono font-semibold uppercase {getRoleBadgeClass(ws.role)}">
                {ws.role}
              </span>
            </div>

            <div class="flex items-center gap-2 text-[11px] text-[#616c63]">
              <span>Gói: <strong>{ws.plan || 'Starter'}</strong></span>
              <span>·</span>
              <span class="font-mono text-[10px] text-[#8a968c]">ID: {ws.id}</span>
            </div>
          </div>

          <div class="pt-2 border-t border-[#f4f0e8] flex items-center justify-between">
            {#if isCurrent}
              <span class="inline-flex items-center gap-1.5 text-xs font-semibold text-[#274333]">
                <span class="h-2 w-2 rounded-full bg-[#274333]"></span>
                Đang kích hoạt
              </span>
            {:else}
              <span class="text-[11px] text-[#8a968c]">Chưa chọn</span>
            {/if}

            <button
              type="button"
              disabled={isSelecting || isCurrent}
              onclick={() => handleSelectWorkspace(ws)}
              class="rounded-lg px-3 py-1.5 text-xs font-semibold transition-colors {isCurrent
                ? 'bg-[#eef3f0] text-[#274333] cursor-default'
                : 'bg-[#274333] text-[#fbf9f5] hover:bg-[#1e3528]'}"
            >
              {isCurrent ? 'Đã chọn' : '→ Mở Workspace'}
            </button>
          </div>
        </div>
      {/each}
    </div>

  <!-- State 5: No Workspaces Found -> First-Workspace Onboarding -->
  {:else}
    <div class="rounded-2xl border border-[#e7e2d7] bg-[#ffffff] p-8 space-y-4">
      <div class="text-center space-y-2">
        <p class="text-base font-bold text-[#242924]">Chưa tìm thấy workspace nào — Khởi tạo Workspace đầu tiên</p>
        <p class="text-xs text-[#616c63] max-w-md mx-auto">
          Tài khoản của bạn chưa có không gian làm việc. Bạn có thể tạo Workspace đầu tiên ngay bên dưới hoặc liên hệ quản trị viên để nhận lời mời.
        </p>
      </div>

      {#if !showCreateForm}
        <div class="text-center pt-2">
          <button
            type="button"
            onclick={() => (showCreateForm = true)}
            class="inline-flex items-center gap-2 rounded-xl bg-[#274333] px-5 py-2.5 text-xs font-semibold text-[#fbf9f5] hover:bg-[#1e3528] transition-colors"
          >
            <span>+ Tạo Workspace đầu tiên của bạn</span>
          </button>
        </div>
      {/if}
    </div>
  {/if}
</div>

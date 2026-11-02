<script lang="ts">
  import {
    CANONICAL_WORKSPACE_ROLES,
    canModifyMemberInUI,
    type WorkspaceRole
  } from '$lib/auth';
  import UnavailableNotice from '$lib/components/UnavailableNotice.svelte';

  let activeTab = $state<'roles' | 'guards'>('roles');

  // Interactive simulation of last-owner protection & RBAC rules (W115 / W116)
  let simulatedActorRole = $state<WorkspaceRole>('owner');
  let simulatedTargetRole = $state<WorkspaceRole>('owner');
  let simulatedIsSelf = $state<boolean>(true);
  let simulatedActiveOwners = $state<number>(1);

  let guardResult = $derived(
    canModifyMemberInUI({
      actorRole: simulatedActorRole,
      actorUserId: 'user_actor_1',
      targetUserId: simulatedIsSelf ? 'user_actor_1' : 'user_target_2',
      targetRole: simulatedTargetRole,
      activeOwnerCount: simulatedActiveOwners
    })
  );
</script>

<svelte:head>
  <title>Team & Vai trò RBAC — Creativanta (W115 / W116)</title>
</svelte:head>

<div class="max-w-5xl mx-auto space-y-6 py-4">
  <!-- Header -->
  <div class="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4 border-b border-[#e7e2d7] pb-5">
    <div>
      <div class="flex items-center gap-2">
        <span class="rounded bg-[#274333] px-2 py-0.5 text-xs font-semibold text-[#fbf9f5]">
          Màn hình W115 / W116
        </span>
        <h1 class="text-2xl font-bold tracking-tight text-[#242924]">
          Team, Thành viên &amp; Phân quyền RBAC
        </h1>
      </div>
      <p class="text-xs text-[#616c63] mt-1">
        Quản trị 7 vai trò chuẩn hóa của Workspace, bảo vệ Owner cuối cùng (DB-M-003) và thu hồi quyền tức thời (EC-AUTH-003).
      </p>
    </div>

    <div class="flex items-center gap-2">
      <a
        href="/workspaces"
        class="rounded-lg border border-[#e7e2d7] bg-[#ffffff] px-3 py-2 text-xs font-semibold text-[#242924] hover:border-[#8a968c] transition-colors"
      >
        ← Danh sách Workspace (W002)
      </a>
    </div>
  </div>

  <!-- Honest Fail-Closed Backend Status Banner -->
  <UnavailableNotice
    title="Dịch vụ Thành viên &amp; Vai trò (P0-04 Backend Slice Ready — Transport Unmounted)"
    domain="Workspace &amp; RBAC (P0-04)"
    requires="Mounting of WorkspaceService ConnectRPC Handlers"
    message="Lược đồ PostgreSQL RLS (app_user), hàm giao dịch tenantdb.WithTx, ma trận 161 quyền × 7 vai trò (1.188 RPC bindings) và bộ lọc private projections đã được triển khai và kiểm thử trong apps/api/internal (migrate, tenantdb, rbac, workspace). Giao diện không hiển thị danh sách thành viên giả lập khi endpoint chưa được gắn kết."
  />

  <!-- Navigation Tabs -->
  <div class="flex gap-2 border-b border-[#e7e2d7]">
    <button
      type="button"
      onclick={() => (activeTab = 'roles')}
      class="px-4 py-2.5 text-xs font-bold border-b-2 transition-colors {activeTab === 'roles'
        ? 'border-[#d94a31] text-[#d94a31]'
        : 'border-transparent text-[#616c63] hover:text-[#242924]'}"
    >
      7 Vai trò chuẩn hóa (RBAC Matrix §1)
    </button>
    <button
      type="button"
      onclick={() => (activeTab = 'guards')}
      class="px-4 py-2.5 text-xs font-bold border-b-2 transition-colors {activeTab === 'guards'
        ? 'border-[#d94a31] text-[#d94a31]'
        : 'border-transparent text-[#616c63] hover:text-[#242924]'}"
    >
      Kiểm chứng Bảo vệ Owner Cuối &amp; Thu hồi Quyền
    </button>
  </div>

  {#if activeTab === 'roles'}
    <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
      {#each CANONICAL_WORKSPACE_ROLES as roleDef (roleDef.role)}
        <div class="rounded-xl border border-[#e7e2d7] bg-[#ffffff] p-4 shadow-xs space-y-2">
          <div class="flex items-center justify-between">
            <div class="flex items-center gap-2">
              <span>{roleDef.badgeIcon}</span>
              <span class="text-sm font-bold text-[#242924]">{roleDef.vietnameseLabel}</span>
              <span class="text-xs text-[#616c63]">({roleDef.label})</span>
            </div>
            <span class="rounded bg-[#f4f0e8] px-2 py-0.5 font-mono text-[10px] font-semibold text-[#274333]">
              {roleDef.role}
            </span>
          </div>
          <p class="text-xs text-[#616c63]">{roleDef.summary}</p>
          <div class="pt-2 border-t border-[#f4f0e8] flex items-center justify-between text-[11px]">
            <span class="text-[#8a968c]">Quyền quản lý thành viên:</span>
            <span class="font-semibold {roleDef.canInviteMembers ? 'text-[#274333]' : 'text-[#8a968c]'}">
              {roleDef.canRemoveMembers
                ? 'Toàn quyền (invite / role / remove)'
                : roleDef.canInviteMembers
                  ? 'Chỉ mời (invite)'
                  : 'Không'}
            </span>
          </div>
        </div>
      {/each}
    </div>
  {:else}
    <div class="rounded-xl border border-[#e7e2d7] bg-[#ffffff] p-5 shadow-xs space-y-4">
      <div>
        <h2 class="text-sm font-bold text-[#242924]">
          Bộ kiểm tra quy tắc Bảo vệ Owner Cuối cùng (RULE-AUTH-004 / DB-M-003)
        </h2>
        <p class="text-xs text-[#616c63] mt-1">
          Mỗi Workspace bắt buộc có đúng 1 <code>owner</code> đang hoạt động (ràng buộc bởi <code>idx_one_active_workspace_owner</code> và khóa ngoại <code>fk_workspaces_owner</code>).
        </p>
      </div>

      <div class="grid grid-cols-1 sm:grid-cols-2 gap-4 pt-2">
        <label class="block space-y-1">
          <span class="text-xs font-semibold text-[#242924]">Vai trò người thao tác (Actor Role)</span>
          <select
            bind:value={simulatedActorRole}
            class="w-full rounded-lg border border-[#e7e2d7] bg-[#fbf9f5] px-3 py-2 text-xs text-[#242924]"
          >
            {#each CANONICAL_WORKSPACE_ROLES as r (r.role)}
              <option value={r.role}>{r.vietnameseLabel} ({r.role})</option>
            {/each}
          </select>
        </label>

        <label class="block space-y-1">
          <span class="text-xs font-semibold text-[#242924]">Vai trò thành viên đích (Target Role)</span>
          <select
            bind:value={simulatedTargetRole}
            class="w-full rounded-lg border border-[#e7e2d7] bg-[#fbf9f5] px-3 py-2 text-xs text-[#242924]"
          >
            {#each CANONICAL_WORKSPACE_ROLES as r (r.role)}
              <option value={r.role}>{r.vietnameseLabel} ({r.role})</option>
            {/each}
          </select>
        </label>
      </div>

      <div class="flex flex-wrap items-center gap-6 pt-1">
        <label class="inline-flex items-center gap-2 text-xs text-[#242924]">
          <input type="checkbox" bind:checked={simulatedIsSelf} class="rounded border-[#e7e2d7]" />
          <span>Thao tác trên chính tài khoản của mình (Self-target)</span>
        </label>
      </div>

      <div
        class="rounded-lg border p-4 text-xs {guardResult.canChangeRole && guardResult.canRemove
          ? 'border-[#274333]/30 bg-[#eef3f0] text-[#274333]'
          : 'border-[#d94a31]/30 bg-[#fbeee9] text-[#d94a31]'}"
      >
        <p class="font-bold">
          {guardResult.canChangeRole && guardResult.canRemove
            ? 'CHO PHÉP THAO TÁC (Allowed)'
            : 'TỪ CHỐI THAO TÁC (Fail-Closed Denied)'}
        </p>
        {#if guardResult.reason}
          <p class="mt-1">{guardResult.reason}</p>
        {:else}
          <p class="mt-1">
            Thao tác hợp lệ theo ma trận RBAC. Khi thực thi qua ConnectRPC, <code>WorkspaceService</code> sẽ kiểm tra lại quyền trên PostgreSQL trong <code>tenantdb.WithTx</code>.
          </p>
        {/if}
      </div>
    </div>
  {/if}
</div>

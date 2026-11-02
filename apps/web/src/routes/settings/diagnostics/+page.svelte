<script lang="ts">
  import type { WorkspaceRole } from '$lib/auth';
  import UnavailableNotice from '$lib/components/UnavailableNotice.svelte';
  import {
    CANONICAL_DIAGNOSTIC_CATEGORIES,
    CANONICAL_QUEUE_SPECS,
    evaluateDiagnosticsPermission,
    evaluateExternalEffectRetryGuard,
    evaluateRepairWizardTransition,
    type ExternalEffectStatus,
    type RepairWizardStepNumber
  } from '$lib/diagnostics';

  let activeTab = $state<'categories' | 'queues' | 'wizard'>('categories');

  let selectedRole = $state<WorkspaceRole>('admin');
  let selectedEffectStatus = $state<ExternalEffectStatus>('unknown');
  let selectedWizardStep = $state<RepairWizardStepNumber>(3);
  let requiresReconciliation = $state<boolean>(true);
  let verificationRef = $state<string>('');

  let readPerm = $derived(evaluateDiagnosticsPermission(selectedRole, 'read'));
  let repairPerm = $derived(evaluateDiagnosticsPermission(selectedRole, 'repair'));
  let effectVerdict = $derived(evaluateExternalEffectRetryGuard(selectedEffectStatus));
  let wizardVerdict = $derived(
    evaluateRepairWizardTransition(selectedWizardStep, requiresReconciliation, verificationRef)
  );
</script>

<svelte:head>
  <title>Trung tâm Chẩn đoán &amp; Hàng đợi Bền vững — Creativanta (W125)</title>
</svelte:head>

<div class="max-w-5xl mx-auto space-y-6 py-4">
  <div class="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4 border-b border-[#e7e2d7] pb-5">
    <div>
      <div class="flex items-center gap-2">
        <span class="rounded bg-[#274333] px-2 py-0.5 text-xs font-semibold text-[#fbf9f5]">
          Màn hình W125 (M23 / S24)
        </span>
        <h1 class="text-2xl font-bold tracking-tight text-[#242924]">
          Trung tâm Chẩn đoán, Outbox/Inbox &amp; Tác vụ Ngoài
        </h1>
      </div>
      <p class="text-xs text-[#616c63] mt-1">
        Kiểm soát 8 hạng mục sức khỏe hệ thống, 11 hàng đợi bền vững, chống trùng lặp Webhook và khóa chống gửi lại mù khi tác vụ ngoài ở trạng thái unknown.
      </p>
    </div>

    <div class="flex items-center gap-2">
      <a
        href="/settings/team"
        class="rounded-lg border border-[#e7e2d7] bg-[#ffffff] px-3 py-2 text-xs font-semibold text-[#242924] hover:border-[#8a968c] transition-colors"
      >
        ← Team &amp; RBAC (W115)
      </a>
    </div>
  </div>

  <UnavailableNotice
    title="Dịch vụ Chẩn đoán &amp; Hàng đợi Bền vững (P0-05 Backend Slice Ready — Transport Unmounted)"
    domain="Diagnostics, Outbox/Inbox &amp; External Effects (P0-05)"
    requires="Mounting of DiagnosticsService ConnectRPC Handlers &amp; Live Redis Streams"
    message="Lược đồ PostgreSQL 00002_p0_05_outbox_inbox_external_effects.sql (consumer_inbox, external_effects, diagnostics_records, dead_letter_queue, audit immutability triggers), gói apps/api/internal/outbox và apps/api/internal/diagnostics đã được triển khai và kiểm thử. Giao diện không hiển thị số liệu giả lập khi endpoint chưa được gắn kết."
  />

  <div class="flex gap-2 border-b border-[#e7e2d7]">
    <button
      type="button"
      onclick={() => (activeTab = 'categories')}
      class="px-4 py-2.5 text-xs font-bold border-b-2 transition-colors {activeTab === 'categories'
        ? 'border-[#d94a31] text-[#d94a31]'
        : 'border-transparent text-[#616c63] hover:text-[#242924]'}"
    >
      8 Hạng mục Sức khỏe (Health Grid)
    </button>
    <button
      type="button"
      onclick={() => (activeTab = 'queues')}
      class="px-4 py-2.5 text-xs font-bold border-b-2 transition-colors {activeTab === 'queues'
        ? 'border-[#d94a31] text-[#d94a31]'
        : 'border-transparent text-[#616c63] hover:text-[#242924]'}"
    >
      11 Hàng đợi Bền vững &amp; Retry Matrix
    </button>
    <button
      type="button"
      onclick={() => (activeTab = 'wizard')}
      class="px-4 py-2.5 text-xs font-bold border-b-2 transition-colors {activeTab === 'wizard'
        ? 'border-[#d94a31] text-[#d94a31]'
        : 'border-transparent text-[#616c63] hover:text-[#242924]'}"
    >
      Trình sửa lỗi 4 bước &amp; Khóa External Effects
    </button>
  </div>

  {#if activeTab === 'categories'}
    <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
      {#each CANONICAL_DIAGNOSTIC_CATEGORIES as cat (cat.key)}
        <div class="rounded-xl border border-[#e7e2d7] bg-[#ffffff] p-4 shadow-xs space-y-2">
          <div class="flex items-center justify-between">
            <span class="text-sm font-bold text-[#242924]">{cat.displayName}</span>
            <span class="rounded bg-[#f4f0e8] px-2 py-0.5 font-mono text-[10px] font-semibold text-[#274333]">
              {cat.key}
            </span>
          </div>
          <p class="text-xs text-[#616c63]">{cat.summary}</p>
        </div>
      {/each}
    </div>
  {:else if activeTab === 'queues'}
    <div class="rounded-xl border border-[#e7e2d7] bg-[#ffffff] overflow-hidden shadow-xs">
      <table class="w-full text-left text-xs">
        <thead class="bg-[#f4f0e8] text-[#242924] font-bold border-b border-[#e7e2d7]">
          <tr>
            <th class="px-4 py-3">Queue Stream</th>
            <th class="px-4 py-3">Mô tả</th>
            <th class="px-4 py-3">Workers</th>
            <th class="px-4 py-3">Timeout</th>
            <th class="px-4 py-3">Max Retries</th>
            <th class="px-4 py-3">Lịch Backoff</th>
          </tr>
        </thead>
        <tbody class="divide-y divide-[#f4f0e8]">
          {#each CANONICAL_QUEUE_SPECS as q (q.name)}
            <tr>
              <td class="px-4 py-2.5 font-mono font-semibold text-[#274333]">{q.name}</td>
              <td class="px-4 py-2.5 text-[#242924]">{q.vietnameseLabel}</td>
              <td class="px-4 py-2.5 text-[#616c63]">{q.concurrency}</td>
              <td class="px-4 py-2.5 text-[#616c63]">{q.timeoutLabel}</td>
              <td class="px-4 py-2.5 text-[#616c63]">{q.maxRetries}</td>
              <td class="px-4 py-2.5 font-mono text-[11px] text-[#616c63]">{q.backoffLabel}</td>
            </tr>
          {/each}
        </tbody>
      </table>
    </div>
  {:else}
    <div class="rounded-xl border border-[#e7e2d7] bg-[#ffffff] p-5 shadow-xs space-y-5">
      <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
        <label class="block space-y-1">
          <span class="text-xs font-semibold text-[#242924]">Vai trò người thao tác (RBAC)</span>
          <select
            bind:value={selectedRole}
            class="w-full rounded-lg border border-[#e7e2d7] bg-[#fbf9f5] px-3 py-2 text-xs text-[#242924]"
          >
            <option value="owner">owner</option>
            <option value="admin">admin</option>
            <option value="manager">manager</option>
            <option value="editor">editor</option>
            <option value="viewer">viewer</option>
          </select>
        </label>

        <label class="block space-y-1">
          <span class="text-xs font-semibold text-[#242924]">Trạng thái external_effects</span>
          <select
            bind:value={selectedEffectStatus}
            class="w-full rounded-lg border border-[#e7e2d7] bg-[#fbf9f5] px-3 py-2 text-xs text-[#242924]"
          >
            <option value="unknown">unknown (timeout / mất kết nối)</option>
            <option value="submitted">submitted (đang gửi đối tác)</option>
            <option value="prepared">prepared (chưa gửi đối tác)</option>
            <option value="succeeded">succeeded (đã hoàn tất)</option>
            <option value="failed">failed (từ chối rõ ràng)</option>
            <option value="cancelled">cancelled (đã hủy)</option>
          </select>
        </label>
      </div>

      <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
        <label class="block space-y-1">
          <span class="text-xs font-semibold text-[#242924]">Bước Trình sửa lỗi 4 bước (W125)</span>
          <select
            bind:value={selectedWizardStep}
            class="w-full rounded-lg border border-[#e7e2d7] bg-[#fbf9f5] px-3 py-2 text-xs text-[#242924]"
          >
            <option value={1}>Bước 1: Xác minh (Verify)</option>
            <option value={2}>Bước 2: Chẩn đoán (Diagnose)</option>
            <option value={3}>Bước 3: Khắc phục (Fix)</option>
            <option value={4}>Bước 4: Xác nhận (Confirm)</option>
          </select>
        </label>

        <label class="block space-y-1">
          <span class="text-xs font-semibold text-[#242924]">Mã đối chiếu xác minh (verification_reference)</span>
          <input
            type="text"
            bind:value={verificationRef}
            placeholder="VD: tiktok_post_id_998877"
            class="w-full rounded-lg border border-[#e7e2d7] bg-[#fbf9f5] px-3 py-2 text-xs text-[#242924]"
          />
        </label>
      </div>

      <div class="rounded-lg border p-4 space-y-2 {effectVerdict.allowBlindRetry ? 'border-[#274333] bg-[#f4f0e8]' : 'border-[#d94a31] bg-[#fff5f2]'}">
        <div class="text-xs font-bold text-[#242924]">
          Phán quyết Khóa External Effects ({selectedEffectStatus}):
          <span class="font-mono">{effectVerdict.decision}</span>
        </div>
        <p class="text-xs text-[#616c63]">{effectVerdict.reason}</p>
      </div>

      <div class="rounded-lg border border-[#e7e2d7] bg-[#fbf9f5] p-4 space-y-2">
        <div class="text-xs font-bold text-[#242924]">
          Quyền RBAC ({readPerm.permissionKey} / {repairPerm.permissionKey}):
          {repairPerm.allowed ? 'CHO PHÉP' : 'TỪ CHỐI'}
        </div>
        <p class="text-xs text-[#616c63]">{repairPerm.reason}</p>
        <div class="pt-2 border-t border-[#e7e2d7] text-xs font-semibold text-[#242924]">
          {wizardVerdict.message}
        </div>
      </div>
    </div>
  {/if}
</div>

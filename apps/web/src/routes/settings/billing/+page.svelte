<script lang="ts">
  import type { WorkspaceRole } from '$lib/auth';
  import UnavailableNotice from '$lib/components/UnavailableNotice.svelte';
  import {
    CANONICAL_ADDONS,
    CANONICAL_PLANS,
    PRICEBOOK_VERSION,
    evaluateBillingPermission,
    evaluateLastPaymentMethodRemoval,
    type PlanTierCode
  } from '$lib/billing';

  let selectedRole = $state<WorkspaceRole>('owner');
  let selectedPlan = $state<PlanTierCode>('pro');
  let billingCurrency = $state<'USD' | 'VND'>('VND');
  let paymentMethodCount = $state<number>(1);
  let subscriptionActive = $state<boolean>(true);

  let readPerm = $derived(evaluateBillingPermission(selectedRole, 'read_billing'));
  let managePerm = $derived(evaluateBillingPermission(selectedRole, 'manage_billing'));
  let pmRemovalVerdict = $derived(
    evaluateLastPaymentMethodRemoval(selectedPlan, subscriptionActive, paymentMethodCount)
  );
</script>

<svelte:head>
  <title>Thanh toán &amp; Gói cước — Creativanta (W119)</title>
</svelte:head>

<div class="max-w-5xl mx-auto space-y-6 py-4">
  <div class="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4 border-b border-[#e7e2d7] pb-5">
    <div>
      <div class="flex items-center gap-2">
        <span class="rounded bg-[#274333] px-2 py-0.5 text-xs font-semibold text-[#fbf9f5]">
          Màn hình W119 (M23)
        </span>
        <h1 class="text-2xl font-bold tracking-tight text-[#242924]">
          Quản lý Gói cước, Add-on &amp; Thanh toán
        </h1>
      </div>
      <p class="text-xs text-[#616c63] mt-1">
        Bảng giá có phiên bản ({PRICEBOOK_VERSION}), phân quyền Owner-only và khóa bảo vệ phương thức thanh toán cuối cùng (EC-M23-001).
      </p>
    </div>

    <div class="flex flex-wrap items-center gap-2">
      <a
        href="/settings/credits/purchase"
        class="rounded-lg border border-[#e7e2d7] bg-[#ffffff] px-3 py-2 text-xs font-semibold text-[#242924] hover:border-[#8a968c] transition-colors"
      >
        Mua thêm Credits (W120/W128) →
      </a>
      <a
        href="/settings/credits/usage"
        class="rounded-lg border border-[#e7e2d7] bg-[#ffffff] px-3 py-2 text-xs font-semibold text-[#242924] hover:border-[#8a968c] transition-colors"
      >
        Sổ cái Lots &amp; Báo giá (W121) →
      </a>
    </div>
  </div>

  <UnavailableNotice
    title="Dịch vụ Thanh toán &amp; Sổ cái Credits (P0-06 Backend Slice Ready — Transport Unmounted)"
    domain="Credit Lots, Cost-Based Quotes &amp; Billing Foundations (P0-06)"
    requires="Mounting of AdminBillingService / BillingService / CreditService ConnectRPC Handlers &amp; Live Stripe Webhook"
    message="Lược đồ PostgreSQL 00003_p0_06_credit_lots_quotes_and_billing.sql (ai_provider_rates, ai_credit_quotes, ai_credit_lots, ai_credit_reservations, ai_credit_reservation_allocations, invoices, payment_methods) và gói apps/api/internal/billing đã được triển khai và kiểm thử. Giao diện chỉ hiển thị bảng giá chuẩn có phiên bản, không giả lập giao dịch thanh toán."
  />

  <div class="flex items-center justify-between">
    <h2 class="text-sm font-bold text-[#242924]">
      5 Gói cước Chuẩn (Pricebook {PRICEBOOK_VERSION})
    </h2>
    <div class="flex items-center gap-2">
      <button
        type="button"
        onclick={() => (billingCurrency = 'VND')}
        class="rounded px-2.5 py-1 text-xs font-bold {billingCurrency === 'VND'
          ? 'bg-[#274333] text-[#fbf9f5]'
          : 'bg-[#f4f0e8] text-[#242924]'}"
      >
        VND (₫)
      </button>
      <button
        type="button"
        onclick={() => (billingCurrency = 'USD')}
        class="rounded px-2.5 py-1 text-xs font-bold {billingCurrency === 'USD'
          ? 'bg-[#274333] text-[#fbf9f5]'
          : 'bg-[#f4f0e8] text-[#242924]'}"
      >
        USD ($)
      </button>
    </div>
  </div>

  <div class="grid grid-cols-1 md:grid-cols-5 gap-3">
    {#each CANONICAL_PLANS as plan (plan.tierCode)}
      <div class="rounded-xl border border-[#e7e2d7] bg-[#ffffff] p-4 shadow-xs space-y-2">
        <div class="flex items-center justify-between">
          <span class="text-sm font-bold text-[#242924]">{plan.displayName}</span>
          <span class="rounded bg-[#f4f0e8] px-1.5 py-0.5 font-mono text-[10px] font-semibold text-[#274333]">
            {plan.tierCode}
          </span>
        </div>
        <div class="text-base font-bold text-[#d94a31] font-mono">
          {billingCurrency === 'VND' ? `₫${plan.monthlyPriceVnd}/th` : `$${plan.monthlyPriceUsd}/mo`}
        </div>
        <div class="text-[11px] text-[#616c63] space-y-1">
          <div>Credits/tháng: <strong class="text-[#242924]">{plan.monthlyCredits}</strong></div>
          <div>Rollover: <strong class="text-[#242924]">{plan.rolloverPercentLabel}</strong></div>
          <div>Thành viên: {plan.maxSeats} · Kênh: {plan.maxChannels}</div>
          <div>Lưu trữ: {plan.maxStorageGb} GB</div>
        </div>
      </div>
    {/each}
  </div>

  <div class="rounded-xl border border-[#e7e2d7] bg-[#ffffff] p-4 shadow-xs space-y-3">
    <h2 class="text-sm font-bold text-[#242924]">4 Module Add-ons (Pro / Business / Enterprise)</h2>
    <div class="grid grid-cols-1 sm:grid-cols-2 gap-3">
      {#each CANONICAL_ADDONS as addon (addon.addonCode)}
        <div class="rounded-lg border border-[#f4f0e8] bg-[#fbf9f5] p-3 flex items-center justify-between">
          <div>
            <div class="text-xs font-bold text-[#242924]">{addon.displayName}</div>
            <div class="font-mono text-[10px] text-[#616c63]">{addon.addonCode}</div>
          </div>
          <div class="font-mono text-xs font-bold text-[#274333]">
            {billingCurrency === 'VND' ? `₫${addon.monthlyPriceVnd}/th` : `$${addon.monthlyPriceUsd}/mo`}
          </div>
        </div>
      {/each}
    </div>
  </div>

  <div class="rounded-xl border border-[#e7e2d7] bg-[#ffffff] p-5 shadow-xs space-y-4">
    <h2 class="text-sm font-bold text-[#242924]">
      Trình kiểm tra Phân quyền Owner-only &amp; Quy tắc EC-M23-001
    </h2>
    <div class="grid grid-cols-1 sm:grid-cols-3 gap-4">
      <label class="block space-y-1">
        <span class="text-xs font-semibold text-[#242924]">Vai trò (RBAC)</span>
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
        <span class="text-xs font-semibold text-[#242924]">Gói cước hiện tại</span>
        <select
          bind:value={selectedPlan}
          class="w-full rounded-lg border border-[#e7e2d7] bg-[#fbf9f5] px-3 py-2 text-xs text-[#242924]"
        >
          {#each CANONICAL_PLANS as p (p.tierCode)}
            <option value={p.tierCode}>{p.displayName} ({p.tierCode})</option>
          {/each}
        </select>
      </label>

      <label class="block space-y-1">
        <span class="text-xs font-semibold text-[#242924]">Số thẻ thanh toán đã lưu</span>
        <select
          bind:value={paymentMethodCount}
          class="w-full rounded-lg border border-[#e7e2d7] bg-[#fbf9f5] px-3 py-2 text-xs text-[#242924]"
        >
          <option value={1}>1 phương thức (duy nhất)</option>
          <option value={2}>2 phương thức</option>
        </select>
      </label>
    </div>

    <div class="rounded-lg border border-[#e7e2d7] bg-[#fbf9f5] p-4 space-y-2 text-xs">
      <div>
        <strong>Quyền xem hóa đơn ({readPerm.permissionKey}):</strong>
        {readPerm.allowed ? 'CHO PHÉP' : 'TỪ CHỐI'} — {readPerm.reason}
      </div>
      <div>
        <strong>Quyền thay đổi gói / thẻ ({managePerm.permissionKey}):</strong>
        {managePerm.allowed ? 'CHO PHÉP' : 'TỪ CHỐI'} — {managePerm.reason}
      </div>
      <div class="pt-2 border-t border-[#e7e2d7] font-semibold {pmRemovalVerdict.allowed ? 'text-[#274333]' : 'text-[#d94a31]'}">
        Kiểm tra xóa thẻ (EC-M23-001): {pmRemovalVerdict.reason}
      </div>
    </div>
  </div>
</div>

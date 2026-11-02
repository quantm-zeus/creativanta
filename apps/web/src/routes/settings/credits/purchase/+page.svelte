<script lang="ts">
  import type { WorkspaceRole } from '$lib/auth';
  import UnavailableNotice from '$lib/components/UnavailableNotice.svelte';
  import {
    CANONICAL_CREDIT_PACKS,
    PRICEBOOK_VERSION,
    evaluateBillingPermission
  } from '$lib/billing';

  let selectedRole = $state<WorkspaceRole>('owner');
  let currency = $state<'USD' | 'VND'>('VND');
  let topUpPerm = $derived(evaluateBillingPermission(selectedRole, 'top_up_credits'));
</script>

<svelte:head>
  <title>Mua thêm AI Credits — Creativanta (W120 / W128)</title>
</svelte:head>

<div class="max-w-5xl mx-auto space-y-6 py-4">
  <div class="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4 border-b border-[#e7e2d7] pb-5">
    <div>
      <div class="flex items-center gap-2">
        <span class="rounded bg-[#274333] px-2 py-0.5 text-xs font-semibold text-[#fbf9f5]">
          Màn hình W120 / W128 (M23)
        </span>
        <h1 class="text-2xl font-bold tracking-tight text-[#242924]">
          Gói Nạp AI Credits &amp; Tự động Nạp (Auto-Refill)
        </h1>
      </div>
      <p class="text-xs text-[#616c63] mt-1">
        Credits mua thêm không bao giờ hết hạn (expires_at = NULL) và chỉ được cộng vào sổ cái sau khi Webhook thanh toán xác thực thành công.
      </p>
    </div>

    <div class="flex items-center gap-2">
      <a
        href="/settings/billing"
        class="rounded-lg border border-[#e7e2d7] bg-[#ffffff] px-3 py-2 text-xs font-semibold text-[#242924] hover:border-[#8a968c] transition-colors"
      >
        ← Thanh toán &amp; Gói cước (W119)
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
    title="Cổng Thanh toán Gói Credits (P0-06 Backend Slice Ready — Transport Unmounted)"
    domain="Credit Lots &amp; Top-Up Checkout (P0-06)"
    requires="Mounting of CreditService/Purchase &amp; Live Stripe Checkout Webhook"
    message="Gói apps/api/internal/billing đảm bảo lệnh PurchaseCredits / Purchase chỉ tạo phiên chờ thanh toán và chỉ cấp lot nguồn 'purchased' (expires_at IS NULL) một lần duy nhất khi nhận Stripe webhook đã xác thực chữ ký HMAC."
  />

  <div class="flex items-center justify-between">
    <h2 class="text-sm font-bold text-[#242924]">
      4 Gói Credits Chuẩn (Pricebook {PRICEBOOK_VERSION})
    </h2>
    <div class="flex items-center gap-2">
      <button
        type="button"
        onclick={() => (currency = 'VND')}
        class="rounded px-2.5 py-1 text-xs font-bold {currency === 'VND'
          ? 'bg-[#274333] text-[#fbf9f5]'
          : 'bg-[#f4f0e8] text-[#242924]'}"
      >
        VND (₫)
      </button>
      <button
        type="button"
        onclick={() => (currency = 'USD')}
        class="rounded px-2.5 py-1 text-xs font-bold {currency === 'USD'
          ? 'bg-[#274333] text-[#fbf9f5]'
          : 'bg-[#f4f0e8] text-[#242924]'}"
      >
        USD ($)
      </button>
    </div>
  </div>

  <div class="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-4 gap-4">
    {#each CANONICAL_CREDIT_PACKS as pack (pack.packCode)}
      <div class="rounded-xl border border-[#e7e2d7] bg-[#ffffff] p-4 shadow-xs space-y-2">
        <div class="flex items-center justify-between">
          <span class="text-sm font-bold text-[#242924]">{pack.displayName}</span>
          <span class="rounded bg-[#f4f0e8] px-2 py-0.5 font-mono text-[10px] font-semibold text-[#274333]">
            {pack.packCode}
          </span>
        </div>
        <div class="text-lg font-bold font-mono text-[#d94a31]">
          {currency === 'VND' ? `₫${pack.priceVnd}` : `$${pack.priceUsd}`}
        </div>
        <div class="text-xs text-[#616c63]">
          Số lượng: <strong class="text-[#242924]">{pack.credits} credits</strong>
        </div>
        <div class="text-[11px] font-semibold text-[#274333]">
          Hiệu lực: Không bao giờ hết hạn (expires_at = NULL)
        </div>
      </div>
    {/each}
  </div>

  <div class="rounded-xl border border-[#e7e2d7] bg-[#ffffff] p-4 shadow-xs space-y-3">
    <label class="block space-y-1 max-w-xs">
      <span class="text-xs font-semibold text-[#242924]">Kiểm tra vai trò mua Credits (credits:top_up)</span>
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
    <p class="text-xs font-semibold {topUpPerm.allowed ? 'text-[#274333]' : 'text-[#d94a31]'}">
      {topUpPerm.allowed ? 'CHO PHÉP' : 'TỪ CHỐI'}: {topUpPerm.reason}
    </p>
  </div>
</div>

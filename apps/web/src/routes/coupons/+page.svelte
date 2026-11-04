<script lang="ts">
  import { type Coupon } from '$lib/commerce';

  const workspaceId = 'ws-commerce-live-01';

  let coupons = $state<Coupon[]>([
    {
      couponId: 'cpn-flash-50k',
      workspaceId,
      code: 'FLASH50K',
      couponType: 'fixed_amount',
      discountValue: '50000.000000',
      minOrderAmount: '200000.000000',
      maxUses: 5,
      currentUses: 4,
      lifecycleState: 'active',
      createdAt: '2026-11-01T00:00:00Z',
      updatedAt: '2026-11-01T00:00:00Z'
    },
    {
      couponId: 'cpn-pct-10',
      workspaceId,
      code: 'WELCOME10',
      couponType: 'percentage',
      discountValue: '10.000000',
      minOrderAmount: '100000.000000',
      maxUses: 100,
      currentUses: 23,
      lifecycleState: 'active',
      createdAt: '2026-11-01T00:00:00Z',
      updatedAt: '2026-11-01T00:00:00Z'
    },
    {
      couponId: 'cpn-exhausted',
      workspaceId,
      code: 'LIMITREACHED',
      couponType: 'fixed_amount',
      discountValue: '20000.000000',
      maxUses: 2,
      currentUses: 2,
      lifecycleState: 'expired',
      createdAt: '2026-11-01T00:00:00Z',
      updatedAt: '2026-11-02T00:00:00Z'
    }
  ]);
</script>

<svelte:head>
  <title>Quản lý Mã giảm giá (Coupons) — Creativanta</title>
</svelte:head>

<div class="space-y-6 p-6 max-w-7xl mx-auto">
  <div class="flex items-center justify-between border-b pb-4">
    <div>
      <h1 class="text-2xl font-bold tracking-tight text-neutral-900">Quản lý Mã giảm giá (Coupons)</h1>
      <p class="text-sm text-neutral-600 mt-1">
        Kiểm soát trần sử dụng atomic chống race conditions (Target 2) và tự động hết hạn khi đạt max_uses.
      </p>
    </div>
    <a href="/monetization" class="text-xs text-neutral-600 hover:text-neutral-900 font-medium">
      &larr; Về Monetization OS
    </a>
  </div>

  <div class="overflow-hidden bg-white shadow-sm border border-neutral-200 rounded-lg">
    <table class="min-w-full divide-y divide-neutral-200 text-sm">
      <thead class="bg-neutral-50 text-neutral-500 font-semibold text-xs uppercase tracking-wider text-left">
        <tr>
          <th class="px-4 py-3">Mã Code</th>
          <th class="px-4 py-3">Loại giảm giá</th>
          <th class="px-4 py-3">Giá trị giảm</th>
          <th class="px-4 py-3">Đơn tối thiểu</th>
          <th class="px-4 py-3">Lượt dùng / Trần (Max)</th>
          <th class="px-4 py-3">Trạng thái</th>
        </tr>
      </thead>
      <tbody class="divide-y divide-neutral-200">
        {#each coupons as c}
          <tr class="hover:bg-neutral-50 transition">
            <td class="px-4 py-3 font-mono font-bold text-neutral-900">{c.code}</td>
            <td class="px-4 py-3 text-neutral-600 font-mono text-xs">{c.couponType}</td>
            <td class="px-4 py-3 font-mono text-neutral-900">{c.discountValue}</td>
            <td class="px-4 py-3 font-mono text-neutral-600">{c.minOrderAmount || '0'}</td>
            <td class="px-4 py-3">
              <span class="font-mono {c.currentUses >= (c.maxUses || 0) ? 'text-red-600 font-bold' : 'text-neutral-900'}">
                {c.currentUses} / {c.maxUses ?? '∞'}
              </span>
            </td>
            <td class="px-4 py-3">
              <span class="inline-flex px-2 py-0.5 rounded text-xs font-semibold {c.lifecycleState === 'active' ? 'bg-emerald-100 text-emerald-800' : 'bg-red-100 text-red-800'}">
                {c.lifecycleState}
              </span>
            </td>
          </tr>
        {/each}
      </tbody>
    </table>
  </div>
</div>

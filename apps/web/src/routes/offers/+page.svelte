<script lang="ts">
  import { type Offer } from '$lib/commerce';

  const workspaceId = 'ws-commerce-live-01';

  let offers = $state<Offer[]>([
    {
      offerId: 'off-black-friday',
      workspaceId,
      title: 'Black Friday 50% Giảm giá chớp nhoáng',
      offerType: 'product_offer',
      pricingValue: '50.000000',
      pricingCurrency: 'VND',
      productId: 'prod-backpack-01',
      lifecycleState: 'active',
      validFrom: '2026-11-01T00:00:00Z',
      validUntil: '2026-11-10T23:59:59Z',
      createdAt: '2026-11-01T00:00:00Z',
      updatedAt: '2026-11-01T00:00:00Z'
    },
    {
      offerId: 'off-bundle-pro',
      workspaceId,
      title: 'Gói Bundle Creator Pro',
      offerType: 'bundle_offer',
      pricingValue: '1990000.000000',
      pricingCurrency: 'VND',
      productLessDeclaration: 'Bundle pack containing digital assets and access key',
      lifecycleState: 'active',
      validFrom: '2026-11-01T00:00:00Z',
      validUntil: '2026-12-31T23:59:59Z',
      createdAt: '2026-11-01T00:00:00Z',
      updatedAt: '2026-11-01T00:00:00Z'
    },
    {
      offerId: 'off-halloween-expired',
      workspaceId,
      title: 'Halloween 30% Off (Đã hết hạn)',
      offerType: 'product_offer',
      pricingValue: '30.000000',
      pricingCurrency: 'VND',
      productId: 'prod-backpack-01',
      lifecycleState: 'expired',
      validFrom: '2026-10-25T00:00:00Z',
      validUntil: '2026-10-31T23:59:59Z',
      createdAt: '2026-10-25T00:00:00Z',
      updatedAt: '2026-11-01T00:00:00Z'
    }
  ]);
</script>

<svelte:head>
  <title>Quản lý Ưu đãi (Offers) — Creativanta</title>
</svelte:head>

<div class="space-y-6 p-6 max-w-7xl mx-auto">
  <div class="flex items-center justify-between border-b pb-4">
    <div>
      <h1 class="text-2xl font-bold tracking-tight text-neutral-900">Quản lý Ưu đãi (Offers)</h1>
      <p class="text-sm text-neutral-600 mt-1">
        Vòng đời ưu đãi, kiểm soát khung thời gian hiệu lực và chống thanh toán khi ưu đãi hết hạn (Target 1).
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
          <th class="px-4 py-3">Tiêu đề ưu đãi</th>
          <th class="px-4 py-3">Loại</th>
          <th class="px-4 py-3">Giá / Mức giảm</th>
          <th class="px-4 py-3">Trạng thái</th>
          <th class="px-4 py-3">Hiệu lực đến</th>
        </tr>
      </thead>
      <tbody class="divide-y divide-neutral-200">
        {#each offers as o}
          <tr class="hover:bg-neutral-50 transition">
            <td class="px-4 py-3 font-medium text-neutral-900">{o.title}</td>
            <td class="px-4 py-3 text-neutral-600 font-mono text-xs">{o.offerType}</td>
            <td class="px-4 py-3 font-mono text-neutral-900">{o.pricingValue} {o.pricingCurrency}</td>
            <td class="px-4 py-3">
              <span class="inline-flex px-2 py-0.5 rounded text-xs font-semibold {o.lifecycleState === 'active' ? 'bg-emerald-100 text-emerald-800' : 'bg-neutral-100 text-neutral-800'}">
                {o.lifecycleState}
              </span>
            </td>
            <td class="px-4 py-3 text-xs text-neutral-500">{o.validUntil ? new Date(o.validUntil).toLocaleDateString() : 'Không thời hạn'}</td>
          </tr>
        {/each}
      </tbody>
    </table>
  </div>
</div>

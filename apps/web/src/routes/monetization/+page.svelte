<script lang="ts">
  import {
    evaluateCheckout,
    evaluateCampaignBudget,
    type Offer,
    type Coupon,
    type Campaign,
    type CheckoutEvaluationResult
  } from '$lib/commerce';

  // Workspace context
  const workspaceId = 'ws-commerce-live-01';

  // Demo active offers
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

  // Demo coupons
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

  // Demo campaign
  let campaign = $state<Campaign>({
    campaignId: 'camp-q4-blitz',
    workspaceId,
    title: 'Chiến dịch Q4 Commerce Blitz',
    campaignType: 'content',
    status: 'active',
    startDate: '2026-11-01',
    endDate: '2026-11-30',
    budget: '10000000.000000',
    budgetCurrency: 'VND',
    totalSpend: '8500000.000000',
    costs: [
      {
        costItemId: 'cost-1',
        campaignId: 'camp-q4-blitz',
        costType: 'ad_spend',
        amount: '5000000.000000',
        currency: 'VND',
        description: 'TikTok Video Ads',
        effectiveDate: '2026-11-02',
        createdAt: '2026-11-02T10:00:00Z'
      },
      {
        costItemId: 'cost-2',
        campaignId: 'camp-q4-blitz',
        costType: 'influencer_fee',
        amount: '3500000.000000',
        currency: 'VND',
        description: 'KOL Review video',
        effectiveDate: '2026-11-03',
        createdAt: '2026-11-03T14:00:00Z'
      }
    ],
    createdAt: '2026-11-01T00:00:00Z',
    updatedAt: '2026-11-03T14:00:00Z'
  });

  let budgetStatus = $derived(evaluateCampaignBudget(campaign));

  // Interactive Checkout Simulator state
  let simSelectedOfferId = $state<string>('off-black-friday');
  let simSelectedCouponCode = $state<string>('FLASH50K');
  let simOrderAmount = $state<string>('350000.000000');
  let simResult = $state<CheckoutEvaluationResult | null>(null);

  function runSimulation() {
    const selectedOffer = offers.find((o) => o.offerId === simSelectedOfferId);
    const selectedCoupon = coupons.find((c) => c.code === simSelectedCouponCode);

    const res = evaluateCheckout({
      workspaceId,
      offer: selectedOffer,
      coupon: selectedCoupon,
      orderAmount: simOrderAmount,
      currency: 'VND'
    });

    simResult = res;

    // If coupon used, update local state
    if (res.accepted && res.updatedCoupon) {
      coupons = coupons.map((c) =>
        c.couponId === res.updatedCoupon!.couponId ? res.updatedCoupon! : c
      );
    }
  }
</script>

<svelte:head>
  <title>Monetization OS (M14) — Creativanta</title>
</svelte:head>

<div class="space-y-8 p-6 max-w-7xl mx-auto">
  <!-- Header -->
  <div class="flex flex-col gap-2 md:flex-row md:items-center md:justify-between border-b pb-4">
    <div>
      <div class="flex items-center gap-2">
        <span class="rounded bg-[#274333] px-2.5 py-0.5 text-xs font-semibold text-[#fbf9f5]">
          Module M14
        </span>
        <h1 class="text-2xl font-bold tracking-tight text-[#242924] sm:text-3xl">
          Monetization OS
        </h1>
      </div>
      <p class="text-sm text-[#616c63] mt-1">
        Điều phối định giá ưu đãi, hạn mức mã giảm giá (anti-race), ngân sách chiến dịch và tự động kết nối sổ cái M19.
      </p>
    </div>

    <div class="flex items-center gap-3">
      <a href="/offers" class="px-3 py-1.5 text-xs font-medium bg-white border rounded shadow-sm hover:bg-neutral-50">
        Ưu đãi ({offers.length})
      </a>
      <a href="/coupons" class="px-3 py-1.5 text-xs font-medium bg-white border rounded shadow-sm hover:bg-neutral-50">
        Mã giảm giá ({coupons.length})
      </a>
      <a href="/campaigns" class="px-3 py-1.5 text-xs font-medium bg-white border rounded shadow-sm hover:bg-neutral-50">
        Chiến dịch (1)
      </a>
    </div>
  </div>

  <!-- Budget Alert Banner (EC-M14-003) -->
  {#if budgetStatus.isWarning}
    <div class="p-4 rounded-lg border {budgetStatus.isOverBudget ? 'bg-red-50 border-red-200 text-red-900' : 'bg-amber-50 border-amber-200 text-amber-900'}">
      <div class="flex items-center justify-between">
        <div class="flex items-center gap-2 font-medium">
          <span class="text-lg">{budgetStatus.isOverBudget ? '🚨' : '⚠️'}</span>
          <span>{budgetStatus.alertMessage}</span>
        </div>
        <span class="text-xs font-semibold uppercase px-2 py-0.5 rounded {budgetStatus.isOverBudget ? 'bg-red-200 text-red-800' : 'bg-amber-200 text-amber-800'}">
          {budgetStatus.utilizationPct}% Chi tiêu
        </span>
      </div>
    </div>
  {/if}

  <!-- KPI Grid -->
  <div class="grid grid-cols-1 md:grid-cols-4 gap-4">
    <div class="p-4 bg-white rounded-lg border border-neutral-200 shadow-sm">
      <div class="text-xs font-medium text-neutral-500 uppercase tracking-wider">Ưu đãi kích hoạt</div>
      <div class="mt-2 text-2xl font-bold text-neutral-900">
        {offers.filter((o) => o.lifecycleState === 'active').length} / {offers.length}
      </div>
      <div class="mt-1 text-xs text-neutral-600">Tuân thủ RULE-M14-001</div>
    </div>

    <div class="p-4 bg-white rounded-lg border border-neutral-200 shadow-sm">
      <div class="text-xs font-medium text-neutral-500 uppercase tracking-wider">Mã coupon khả dụng</div>
      <div class="mt-2 text-2xl font-bold text-neutral-900">
        {coupons.filter((c) => c.lifecycleState === 'active').length}
      </div>
      <div class="mt-1 text-xs text-neutral-600">Khóa trần atomic khi cạn lượt</div>
    </div>

    <div class="p-4 bg-white rounded-lg border border-neutral-200 shadow-sm">
      <div class="text-xs font-medium text-neutral-500 uppercase tracking-wider">Ngân sách chiến dịch Q4</div>
      <div class="mt-2 text-2xl font-bold text-neutral-900">
        {campaign.totalSpend.split('.')[0]} / {campaign.budget?.split('.')[0]} <span class="text-sm font-normal text-neutral-500">VND</span>
      </div>
      <div class="mt-1 text-xs text-neutral-600">Tỷ lệ: {budgetStatus.utilizationPct}% (Cảnh báo &ge;80%)</div>
    </div>

    <div class="p-4 bg-white rounded-lg border border-neutral-200 shadow-sm">
      <div class="text-xs font-medium text-neutral-500 uppercase tracking-wider">Kết nối sổ cái M19</div>
      <div class="mt-2 text-2xl font-bold text-emerald-600">
        Hoạt động
      </div>
      <div class="mt-1 text-xs text-neutral-600">Bút toán kép FinancialPosting</div>
    </div>
  </div>

  <!-- Interactive Acceptance Simulator -->
  <div class="bg-white rounded-xl border border-neutral-200 p-6 shadow-sm space-y-6">
    <div>
      <h2 class="text-lg font-bold text-neutral-900">Trình giả lập Thanh toán Checkout (Acceptance Targets 1, 2, 3)</h2>
      <p class="text-xs text-neutral-600 mt-1">
        Thử nghiệm trực tiếp kiểm thử chấp nhận: Từ chối ưu đãi hết hạn, kiểm soát trần coupon chống race condition, và sinh bút toán sổ cái.
      </p>
    </div>

    <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
      <div>
        <label for="offer-select" class="block text-xs font-semibold text-neutral-700 mb-1">1. Chọn Ưu đãi (Target 1)</label>
        <select id="offer-select" bind:value={simSelectedOfferId} class="w-full text-sm border rounded-md p-2 bg-neutral-50">
          <option value="">-- Không áp dụng --</option>
          {#each offers as o}
            <option value={o.offerId}>
              {o.title} [{o.lifecycleState}]
            </option>
          {/each}
        </select>
      </div>

      <div>
        <label for="coupon-select" class="block text-xs font-semibold text-neutral-700 mb-1">2. Chọn Mã giảm giá (Target 2)</label>
        <select id="coupon-select" bind:value={simSelectedCouponCode} class="w-full text-sm border rounded-md p-2 bg-neutral-50">
          <option value="">-- Không dùng coupon --</option>
          {#each coupons as c}
            <option value={c.code}>
              {c.code} ({c.currentUses}/{c.maxUses} lượt) [{c.lifecycleState}]
            </option>
          {/each}
        </select>
      </div>

      <div>
        <label for="order-amt" class="block text-xs font-semibold text-neutral-700 mb-1">3. Giá trị đơn hàng (VND)</label>
        <input
          id="order-amt"
          type="text"
          bind:value={simOrderAmount}
          class="w-full text-sm border rounded-md p-2"
          placeholder="350000.000000"
        />
      </div>
    </div>

    <div>
      <button
        onclick={runSimulation}
        class="px-4 py-2 bg-[#274333] hover:bg-[#1f3528] text-white text-sm font-semibold rounded-md shadow-sm transition"
      >
        Đánh giá Checkout (EvaluateCheckout)
      </button>
    </div>

    <!-- Simulation Result -->
    {#if simResult}
      <div class="mt-4 p-4 rounded-lg border {simResult.accepted ? 'bg-emerald-50 border-emerald-200' : 'bg-rose-50 border-rose-200'}">
        <div class="flex items-center justify-between mb-2">
          <span class="font-bold text-sm {simResult.accepted ? 'text-emerald-900' : 'text-rose-900'}">
            {simResult.accepted ? '✅ Checkout Chấp thuận (APPROVED)' : `❌ Checkout Bị từ chối (${simResult.errorCode})`}
          </span>
          <span class="text-xs text-neutral-500">Mã đơn: {simResult.orderId || 'N/A'}</span>
        </div>

        {#if !simResult.accepted}
          <div class="text-xs text-rose-800 font-medium">
            Lý do từ chối: {simResult.errorMessage}
          </div>
        {:else}
          <div class="grid grid-cols-3 gap-2 text-xs text-emerald-950 mt-2">
            <div>Tổng ban đầu: <strong>{simResult.originalAmount} VND</strong></div>
            <div>Giảm trừ: <strong>{simResult.discountAmount} VND</strong></div>
            <div>Thực thu (Net): <strong>{simResult.netPayableAmount} VND</strong></div>
          </div>

          {#if simResult.posting}
            <div class="mt-3 pt-3 border-t border-emerald-200 text-xs text-emerald-900 space-y-1">
              <div class="font-bold">Bút toán sổ cái M19 (Target 3):</div>
              <div class="font-mono bg-white p-2 rounded border border-emerald-200 text-[11px] overflow-x-auto">
                PostingID: {simResult.posting.postingId} | OrderID: {simResult.posting.orderId} | Net: {simResult.posting.netAmount} {simResult.posting.currency}
              </div>
            </div>
          {/if}
        {/if}
      </div>
    {/if}
  </div>
</div>

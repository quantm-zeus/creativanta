<script lang="ts">
  import { type Campaign, evaluateCampaignBudget } from '$lib/commerce';

  const workspaceId = 'ws-commerce-live-01';

  let campaigns = $state<Campaign[]>([
    {
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
      costs: [],
      createdAt: '2026-11-01T00:00:00Z',
      updatedAt: '2026-11-03T14:00:00Z'
    },
    {
      campaignId: 'camp-affiliate-kol',
      workspaceId,
      title: 'KOL Seeding & Tiếp thị liên kết',
      campaignType: 'affiliate',
      status: 'active',
      startDate: '2026-10-15',
      endDate: '2026-11-15',
      budget: '5000000.000000',
      budgetCurrency: 'VND',
      totalSpend: '2100000.000000',
      costs: [],
      createdAt: '2026-10-15T00:00:00Z',
      updatedAt: '2026-10-20T00:00:00Z'
    }
  ]);
</script>

<svelte:head>
  <title>Quản lý Chiến dịch (Campaigns) — Creativanta</title>
</svelte:head>

<div class="space-y-6 p-6 max-w-7xl mx-auto">
  <div class="flex items-center justify-between border-b pb-4">
    <div>
      <h1 class="text-2xl font-bold tracking-tight text-neutral-900">Quản lý Chiến dịch & Ngân sách</h1>
      <p class="text-sm text-neutral-600 mt-1">
        Theo dõi chi phí tiếp thị, kiểm soát trần ngân sách và cảnh báo vượt ngưỡng 80% / 100% (EC-M14-003).
      </p>
    </div>
    <a href="/monetization" class="text-xs text-neutral-600 hover:text-neutral-900 font-medium">
      &larr; Về Monetization OS
    </a>
  </div>

  <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
    {#each campaigns as camp}
      {@const budget = evaluateCampaignBudget(camp)}
      <div class="p-6 bg-white border rounded-xl shadow-sm space-y-4">
        <div class="flex items-center justify-between">
          <h2 class="text-lg font-bold text-neutral-900">{camp.title}</h2>
          <span class="px-2 py-0.5 rounded text-xs font-semibold uppercase bg-neutral-100 text-neutral-700">
            {camp.campaignType}
          </span>
        </div>

        <div class="space-y-2">
          <div class="flex justify-between text-xs text-neutral-600">
            <span>Chi tiêu: <strong>{camp.totalSpend.split('.')[0]} {camp.budgetCurrency}</strong></span>
            <span>Ngân sách: <strong>{camp.budget?.split('.')[0]} {camp.budgetCurrency}</strong></span>
          </div>

          <div class="w-full bg-neutral-100 rounded-full h-2.5 overflow-hidden">
            <div
              class="h-2.5 rounded-full {budget.isOverBudget ? 'bg-red-600' : budget.isWarning ? 'bg-amber-500' : 'bg-emerald-500'}"
              style="width: {Math.min(100, budget.utilizationPct)}%"
            ></div>
          </div>

          <div class="flex justify-between items-center text-xs">
            <span class="font-medium {budget.isOverBudget ? 'text-red-700' : budget.isWarning ? 'text-amber-700' : 'text-neutral-500'}">
              {budget.alertMessage || `${budget.utilizationPct}% ngân sách đã sử dụng`}
            </span>
            <span class="font-bold">{budget.utilizationPct}%</span>
          </div>
        </div>
      </div>
    {/each}
  </div>
</div>

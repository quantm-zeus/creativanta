<script lang="ts">
  import {
    getSourceClassBadge,
    type AttributionRecord
  } from '$lib/commerce';

  const workspaceId = 'ws-affiliate-01';

  let attributions = $state<AttributionRecord[]>([
    {
      attributionId: 'attr-official-001',
      workspaceId,
      orderId: 'ord-shopee-9871',
      affiliateLinkId: 'link-shopee-backpack',
      creatorEntityId: 'creator-linh-ka',
      clickId: 'clk-sp-01',
      touchpointCount: 1,
      isMultiTouch: false,
      sourceClass: 'official', // Official platform API
      confidence: 'high',
      attributionNote: 'Official Shopee Open API webhook conversion confirmation.',
      orderAmount: '750000.000000',
      attributedRevenue: '750000.000000',
      commissionAmount: '75000.000000',
      currency: 'VND',
      attributedAt: '2026-11-04T08:15:00Z'
    },
    {
      attributionId: 'attr-inferred-002',
      workspaceId,
      orderId: 'ord-tiktok-9872',
      affiliateLinkId: 'link-tiktok-serum',
      creatorEntityId: 'creator-mai-anh',
      clickId: 'clk-tt-44',
      touchpointCount: 2,
      isMultiTouch: true, // Multi-touch: Ambiguous attribution!
      sourceClass: 'inferred',
      confidence: 'medium',
      attributionNote: 'Multiple touch points detected — last click rule applied.',
      orderAmount: '450000.000000',
      attributedRevenue: '450000.000000',
      commissionAmount: '67500.000000',
      currency: 'VND',
      attributedAt: '2026-11-04T09:20:00Z'
    },
    {
      attributionId: 'attr-inferred-003',
      workspaceId,
      orderId: 'ord-cross-device-9873',
      affiliateLinkId: 'link-shopee-backpack',
      touchpointCount: 4,
      isMultiTouch: true,
      sourceClass: 'inferred',
      confidence: 'low',
      attributionNote: 'Cross-device multi-channel touchpoint detected — lower confidence band.',
      orderAmount: '1200000.000000',
      attributedRevenue: '1200000.000000',
      commissionAmount: '120000.000000',
      currency: 'VND',
      attributedAt: '2026-11-04T10:05:00Z'
    }
  ]);
</script>

<div class="mx-auto max-w-7xl px-4 py-8 sm:px-6 lg:px-8">
  <div class="mb-8 flex items-center justify-between">
    <div>
      <h1 class="text-2xl font-bold tracking-tight text-slate-900 dark:text-white sm:text-3xl">
        Attribution Provenance & Confidence Report
      </h1>
      <p class="mt-1 text-sm text-slate-500 dark:text-slate-400">
        Acceptance Target 2 & RULE-M16-002: Ambiguous attribution is explicitly labeled with source class and confidence.
      </p>
    </div>
    <a
      href="/affiliates"
      class="rounded-lg border border-slate-300 bg-white px-4 py-2 text-sm font-medium text-slate-700 shadow-sm hover:bg-slate-50 dark:border-slate-700 dark:bg-slate-800 dark:text-slate-200"
    >
      ← Back to Affiliates
    </a>
  </div>

  <!-- Invariant Banner -->
  <div class="mb-6 rounded-xl border border-blue-200 bg-blue-50/50 p-4 dark:border-blue-900/50 dark:bg-blue-950/20">
    <div class="flex items-start gap-3">
      <div class="text-blue-600 dark:text-blue-400">ℹ️</div>
      <div>
        <div class="text-sm font-semibold text-blue-900 dark:text-blue-300">
          Proof Truth Hierarchy Enforced
        </div>
        <div class="mt-1 text-xs text-blue-800 dark:text-blue-400">
          The system strictly separates <strong>Official (API-confirmed)</strong> data from <strong>Inferred (multi-touch / UTM)</strong> and <strong>Unreconciled</strong> attributions. Uncertain attributions are NEVER presented as definitive truth without an explicit provenance badge.
        </div>
      </div>
    </div>
  </div>

  <!-- Attribution Records Table -->
  <div class="overflow-hidden rounded-xl border border-slate-200 bg-white shadow-sm dark:border-slate-800 dark:bg-slate-900">
    <table class="w-full text-left text-sm text-slate-600 dark:text-slate-300">
      <thead class="bg-slate-50 text-xs font-semibold uppercase text-slate-500 dark:bg-slate-800/60 dark:text-slate-400">
        <tr>
          <th class="px-6 py-3">Order & Touchpoints</th>
          <th class="px-6 py-3">Source Class Badge</th>
          <th class="px-6 py-3">Confidence</th>
          <th class="px-6 py-3">Attributed Revenue</th>
          <th class="px-6 py-3">Commission</th>
          <th class="px-6 py-3">Attribution Provenance Note</th>
        </tr>
      </thead>
      <tbody class="divide-y divide-slate-200 dark:divide-slate-800">
        {#each attributions as attr}
          {@const badge = getSourceClassBadge(attr.sourceClass)}
          <tr class="hover:bg-slate-50/50 dark:hover:bg-slate-800/50">
            <td class="px-6 py-4">
              <div class="font-mono font-medium text-slate-900 dark:text-white">{attr.orderId}</div>
              <div class="text-xs text-slate-500">
                {attr.touchpointCount} touchpoint{attr.touchpointCount > 1 ? 's' : ''}
                {#if attr.isMultiTouch}
                  <span class="text-amber-600 font-semibold">(Multi-touch)</span>
                {/if}
              </div>
            </td>
            <td class="px-6 py-4">
              <span class="inline-flex items-center rounded-full px-2.5 py-0.5 text-xs font-medium {badge.bg} {badge.text}">
                {badge.label}
              </span>
            </td>
            <td class="px-6 py-4">
              <span class="font-semibold capitalize text-xs {attr.confidence === 'high' ? 'text-emerald-600' : attr.confidence === 'medium' ? 'text-amber-600' : 'text-rose-600'}">
                {attr.confidence}
              </span>
            </td>
            <td class="px-6 py-4 font-mono font-medium text-slate-900 dark:text-white">
              {Number(attr.attributedRevenue).toLocaleString()} {attr.currency}
            </td>
            <td class="px-6 py-4 font-mono text-indigo-600 dark:text-indigo-400">
              {Number(attr.commissionAmount).toLocaleString()} {attr.currency}
            </td>
            <td class="px-6 py-4 text-xs text-slate-600 dark:text-slate-400">
              {attr.attributionNote}
            </td>
          </tr>
        {/each}
      </tbody>
    </table>
  </div>
</div>

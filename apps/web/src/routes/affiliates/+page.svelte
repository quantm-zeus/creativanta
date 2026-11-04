<script lang="ts">
  import {
    evaluateLedgerImpact,
    repairBrokenLink,
    getHealthStatusColor,
    getSourceClassBadge,
    type AffiliateLink,
    type CreatorAssignment,
    type AffiliatePayout,
    type WorkspaceEconomicRole,
    type LedgerPostingEvaluation
  } from '$lib/commerce';

  const workspaceId = 'ws-affiliate-01';

  let selectedRole = $state<WorkspaceEconomicRole>('creator');
  let ledgerEvaluation = $state<LedgerPostingEvaluation | null>(null);

  // Affiliate Links state
  let links = $state<AffiliateLink[]>([
    {
      affiliateLinkId: 'link-shopee-backpack',
      workspaceId,
      platform: 'shopee',
      originalUrl: 'https://shopee.vn/products/waterproof-backpack',
      trackedUrl: 'https://creativanta.link/sh-bp1',
      shortCode: 'sh-bp1',
      commissionRate: '10.00',
      lifecycleState: 'active',
      healthStatus: 'healthy',
      clickCount: 1420,
      conversionCount: 86,
      revenueAttributed: '25800000.000000',
      createdAt: '2026-11-01T00:00:00Z',
      updatedAt: '2026-11-01T00:00:00Z'
    },
    {
      affiliateLinkId: 'link-tiktok-serum-broken',
      workspaceId,
      platform: 'tiktok',
      originalUrl: 'https://shop.tiktok.com/p/serum-404',
      trackedUrl: 'https://creativanta.link/tt-sr2',
      shortCode: 'tt-sr2',
      commissionRate: '15.00',
      lifecycleState: 'active',
      healthStatus: 'broken', // Broken link needing repair!
      clickCount: 520,
      conversionCount: 34,
      revenueAttributed: '8500000.000000',
      suggestedReplacementProductId: 'prod-serum-v2',
      createdAt: '2026-11-02T00:00:00Z',
      updatedAt: '2026-11-04T00:00:00Z'
    },
    {
      affiliateLinkId: 'link-lazada-revoked',
      workspaceId,
      platform: 'lazada',
      originalUrl: 'https://lazada.vn/products/violating-item',
      trackedUrl: 'https://creativanta.link/lz-rev',
      shortCode: 'lz-rev',
      commissionRate: '8.00',
      lifecycleState: 'revoked', // Policy revoked - terminal!
      healthStatus: 'broken',
      clickCount: 88,
      conversionCount: 2,
      revenueAttributed: '450000.000000',
      createdAt: '2026-10-20T00:00:00Z',
      updatedAt: '2026-10-25T00:00:00Z'
    }
  ]);

  // Repair form state
  let repairingLinkId = $state<string | null>(null);
  let newDestinationUrl = $state('');
  let replacementProductId = $state('');
  let repairMessage = $state<{ type: 'success' | 'error'; text: string } | null>(null);

  // Creator assignments
  let assignments = $state<CreatorAssignment[]>([
    {
      assignmentId: 'asg-linh-ka',
      workspaceId,
      campaignId: 'camp-q4-launch',
      creatorEntityId: 'creator-linh-ka',
      affiliateLinkId: 'link-shopee-backpack',
      couponId: 'cpn-linh10',
      status: 'active',
      notes: 'Exclusive unboxing review campaign',
      createdAt: '2026-11-01T00:00:00Z',
      updatedAt: '2026-11-01T00:00:00Z'
    }
  ]);

  // Payout Proofs
  let payouts = $state<AffiliatePayout[]>([
    {
      payoutId: 'payout-batch-oct26',
      workspaceId,
      creatorEntityId: 'creator-linh-ka',
      commissionIds: ['comm-101', 'comm-102'],
      totalAmount: '2580000.000000',
      currency: 'VND',
      status: 'completed',
      proofHash: 'e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855',
      settlementId: 'settle-oct-shopee',
      paidAt: '2026-11-03T10:00:00Z',
      createdAt: '2026-11-03T09:30:00Z'
    }
  ]);

  // Handler for Economic Role Ledger Evaluation (Target 1)
  function handleEvaluateLedger() {
    ledgerEvaluation = evaluateLedgerImpact(workspaceId, '2580000.000000', 'VND', selectedRole);
  }

  // Handler for Link Repair (Target 3)
  function startRepair(link: AffiliateLink) {
    repairingLinkId = link.affiliateLinkId;
    newDestinationUrl = link.originalUrl;
    replacementProductId = link.suggestedReplacementProductId || '';
    repairMessage = null;
  }

  function submitRepair() {
    if (!repairingLinkId) return;
    const targetLink = links.find((l) => l.affiliateLinkId === repairingLinkId);
    if (!targetLink) return;

    const result = repairBrokenLink(targetLink, newDestinationUrl, replacementProductId);
    if (result.success) {
      links = links.map((l) => (l.affiliateLinkId === repairingLinkId ? result.link : l));
      repairMessage = { type: 'success', text: 'Affiliate link repaired successfully! Health restored to Healthy.' };
      repairingLinkId = null;
    } else {
      repairMessage = { type: 'error', text: result.error || 'Repair failed.' };
    }
  }
</script>

<div class="mx-auto max-w-7xl px-4 py-8 sm:px-6 lg:px-8">
  <!-- Header -->
  <div class="mb-8 flex flex-col justify-between gap-4 md:flex-row md:items-center">
    <div>
      <h1 class="text-2xl font-bold tracking-tight text-slate-900 dark:text-white sm:text-3xl">
        Affiliate Network & Ledger Proof
      </h1>
      <p class="mt-1 text-sm text-slate-500 dark:text-slate-400">
        Module M16 — Track affiliate links, repair broken destinations, and reconcile payouts with M19 ledger.
      </p>
    </div>
    <div class="flex items-center gap-3">
      <a
        href="/attribution"
        class="inline-flex items-center rounded-lg border border-slate-300 bg-white px-4 py-2 text-sm font-medium text-slate-700 shadow-sm hover:bg-slate-50 dark:border-slate-700 dark:bg-slate-800 dark:text-slate-200 dark:hover:bg-slate-700"
      >
        Attribution Report →
      </a>
    </div>
  </div>

  <!-- Acceptance Target 1: Economic Role & Ledger Posting Section -->
  <div class="mb-8 rounded-xl border border-slate-200 bg-white p-6 shadow-sm dark:border-slate-800 dark:bg-slate-900">
    <div class="mb-4 flex flex-col justify-between gap-4 sm:flex-row sm:items-center">
      <div>
        <h2 class="text-lg font-semibold text-slate-900 dark:text-white">
          Acceptance Target 1: Workspace Economic Role Ledger Integration
        </h2>
        <p class="text-xs text-slate-500 dark:text-slate-400">
          In accordance with RULE-M16-003 & financial_computation_contract.md §1:
          Creator commission is income (no COGS deduction); Seller commission is an expense deduction.
        </p>
      </div>
      <div class="flex items-center gap-2">
        <label for="role-select" class="text-xs font-medium text-slate-600 dark:text-slate-400">Role:</label>
        <select
          id="role-select"
          bind:value={selectedRole}
          class="rounded-lg border border-slate-300 bg-white px-3 py-1.5 text-sm dark:border-slate-700 dark:bg-slate-800 dark:text-white"
        >
          <option value="creator">Creator (Income View)</option>
          <option value="seller">Seller (Expense View)</option>
        </select>
        <button
          onclick={handleEvaluateLedger}
          class="rounded-lg bg-indigo-600 px-4 py-1.5 text-sm font-medium text-white hover:bg-indigo-700"
        >
          Post to Ledger
        </button>
      </div>
    </div>

    {#if ledgerEvaluation}
      <div class="rounded-lg bg-slate-50 p-4 dark:bg-slate-800/50">
        <div class="grid grid-cols-2 gap-4 sm:grid-cols-4">
          <div>
            <div class="text-xs text-slate-500">Posting Type</div>
            <div class="font-mono text-sm font-semibold text-slate-900 dark:text-white">
              {ledgerEvaluation.postingType}
            </div>
          </div>
          <div>
            <div class="text-xs text-slate-500">Amount</div>
            <div class="font-mono text-sm font-semibold text-indigo-600 dark:text-indigo-400">
              {ledgerEvaluation.amount} {ledgerEvaluation.currency}
            </div>
          </div>
          <div>
            <div class="text-xs text-slate-500">COGS Deducted?</div>
            <div class="text-sm font-semibold">
              {#if ledgerEvaluation.cogsDeducted}
                <span class="text-amber-600 dark:text-amber-400">Yes (Seller Expense)</span>
              {:else}
                <span class="text-emerald-600 dark:text-emerald-400">No (Creator Income Protected)</span>
              {/if}
            </div>
          </div>
          <div>
            <div class="text-xs text-slate-500">Net Profit Impact</div>
            <div class="font-mono text-sm font-semibold {ledgerEvaluation.economicRole === 'creator' ? 'text-emerald-600' : 'text-rose-600'}">
              {ledgerEvaluation.netProfitImpact}
            </div>
          </div>
        </div>
      </div>
    {/if}
  </div>

  <!-- Repair Message Alert -->
  {#if repairMessage}
    <div
      class="mb-6 rounded-lg p-4 text-sm font-medium {repairMessage.type === 'success'
        ? 'bg-emerald-50 text-emerald-800 dark:bg-emerald-950/40 dark:text-emerald-300'
        : 'bg-rose-50 text-rose-800 dark:bg-rose-950/40 dark:text-rose-300'}"
    >
      {repairMessage.text}
    </div>
  {/if}

  <!-- Affiliate Links List -->
  <div class="mb-8 rounded-xl border border-slate-200 bg-white shadow-sm dark:border-slate-800 dark:bg-slate-900">
    <div class="border-b border-slate-200 px-6 py-4 dark:border-slate-800">
      <h2 class="text-lg font-semibold text-slate-900 dark:text-white">
        Affiliate Links & Link Health Monitor (Target 3)
      </h2>
    </div>

    <div class="overflow-x-auto">
      <table class="w-full text-left text-sm text-slate-600 dark:text-slate-300">
        <thead class="bg-slate-50 text-xs font-semibold uppercase text-slate-500 dark:bg-slate-800/60 dark:text-slate-400">
          <tr>
            <th class="px-6 py-3">Platform & Link</th>
            <th class="px-6 py-3">Rate</th>
            <th class="px-6 py-3">Health Status</th>
            <th class="px-6 py-3">Clicks / Conv</th>
            <th class="px-6 py-3">Attributed Revenue</th>
            <th class="px-6 py-3 text-right">Actions</th>
          </tr>
        </thead>
        <tbody class="divide-y divide-slate-200 dark:divide-slate-800">
          {#each links as link}
            {@const healthStyle = getHealthStatusColor(link.healthStatus)}
            <tr class="hover:bg-slate-50/50 dark:hover:bg-slate-800/50">
              <td class="px-6 py-4">
                <div class="font-medium text-slate-900 dark:text-white capitalize">{link.platform}</div>
                <div class="text-xs font-mono text-slate-500">{link.trackedUrl}</div>
                <div class="text-xs text-slate-400 truncate max-w-xs">{link.originalUrl}</div>
              </td>
              <td class="px-6 py-4 font-mono font-medium">{link.commissionRate}%</td>
              <td class="px-6 py-4">
                <span class="inline-flex items-center rounded-full px-2.5 py-0.5 text-xs font-medium {healthStyle.bg} {healthStyle.text}">
                  {healthStyle.label}
                </span>
                {#if link.lifecycleState === 'revoked'}
                  <span class="ml-1 inline-flex items-center rounded-full bg-rose-100 px-2 py-0.5 text-xs text-rose-800">
                    Revoked
                  </span>
                {/if}
              </td>
              <td class="px-6 py-4">
                <div>{link.clickCount.toLocaleString()} clicks</div>
                <div class="text-xs text-slate-500">{link.conversionCount} conversions</div>
              </td>
              <td class="px-6 py-4 font-mono font-medium text-slate-900 dark:text-white">
                {Number(link.revenueAttributed).toLocaleString()} VND
              </td>
              <td class="px-6 py-4 text-right">
                {#if link.healthStatus === 'broken' && link.lifecycleState !== 'revoked'}
                  <button
                    onclick={() => startRepair(link)}
                    class="rounded-lg bg-amber-600 px-3 py-1.5 text-xs font-medium text-white hover:bg-amber-700"
                  >
                    Repair Link
                  </button>
                {:else if link.lifecycleState === 'revoked'}
                  <span class="text-xs text-slate-400 italic">Policy Revoked</span>
                {:else}
                  <span class="text-xs text-emerald-600">Active</span>
                {/if}
              </td>
            </tr>
          {/each}
        </tbody>
      </table>
    </div>
  </div>

  <!-- Repair Modal / Sheet (if repairing) -->
  {#if repairingLinkId}
    <div class="mb-8 rounded-xl border border-amber-300 bg-amber-50/30 p-6 dark:border-amber-900/50 dark:bg-amber-950/20">
      <h3 class="text-base font-semibold text-slate-900 dark:text-white">
        Repair Broken Link: {repairingLinkId}
      </h3>
      <p class="mt-1 text-xs text-slate-500 dark:text-slate-400">
        Update destination URL or swap out-of-stock product with recommended replacement.
      </p>

      <div class="mt-4 grid grid-cols-1 gap-4 sm:grid-cols-2">
        <div>
          <label for="new-url" class="block text-xs font-medium text-slate-700 dark:text-slate-300">New Destination URL</label>
          <input
            id="new-url"
            type="text"
            bind:value={newDestinationUrl}
            class="mt-1 w-full rounded-lg border border-slate-300 bg-white p-2 text-sm dark:border-slate-700 dark:bg-slate-800 dark:text-white"
          />
        </div>
        <div>
          <label for="repl-prod" class="block text-xs font-medium text-slate-700 dark:text-slate-300">Replacement Product ID</label>
          <input
            id="repl-prod"
            type="text"
            bind:value={replacementProductId}
            class="mt-1 w-full rounded-lg border border-slate-300 bg-white p-2 text-sm dark:border-slate-700 dark:bg-slate-800 dark:text-white"
          />
        </div>
      </div>

      <div class="mt-4 flex gap-3">
        <button
          onclick={submitRepair}
          class="rounded-lg bg-emerald-600 px-4 py-2 text-sm font-medium text-white hover:bg-emerald-700"
        >
          Confirm Repair & Restore Health
        </button>
        <button
          onclick={() => { repairingLinkId = null; }}
          class="rounded-lg border border-slate-300 px-4 py-2 text-sm font-medium text-slate-700 hover:bg-slate-100 dark:border-slate-700 dark:text-slate-300"
        >
          Cancel
        </button>
      </div>
    </div>
  {/if}

  <!-- Creator Assignments & Payout Proofs Grid -->
  <div class="grid grid-cols-1 gap-8 lg:grid-cols-2">
    <!-- Creator Assignments -->
    <div class="rounded-xl border border-slate-200 bg-white p-6 shadow-sm dark:border-slate-800 dark:bg-slate-900">
      <h3 class="text-base font-semibold text-slate-900 dark:text-white mb-4">
        Creator Assignments & Coupons
      </h3>
      <div class="space-y-4">
        {#each assignments as asg}
          <div class="rounded-lg border border-slate-100 bg-slate-50 p-4 dark:border-slate-800 dark:bg-slate-800/40">
            <div class="flex justify-between items-center">
              <span class="font-medium text-slate-900 dark:text-white">{asg.creatorEntityId}</span>
              <span class="rounded bg-emerald-100 px-2 py-0.5 text-xs font-medium text-emerald-800 dark:bg-emerald-950/50 dark:text-emerald-400">
                {asg.status}
              </span>
            </div>
            <div class="mt-2 text-xs text-slate-500">
              Coupon: <span class="font-mono font-medium text-indigo-600 dark:text-indigo-400">{asg.couponId}</span>
            </div>
            <div class="text-xs text-slate-400 mt-1">{asg.notes}</div>
          </div>
        {/each}
      </div>
    </div>

    <!-- Payout Batches & Proof -->
    <div class="rounded-xl border border-slate-200 bg-white p-6 shadow-sm dark:border-slate-800 dark:bg-slate-900">
      <h3 class="text-base font-semibold text-slate-900 dark:text-white mb-4">
        Payout Batches & Settlement Proof
      </h3>
      <div class="space-y-4">
        {#each payouts as p}
          <div class="rounded-lg border border-slate-100 bg-slate-50 p-4 dark:border-slate-800 dark:bg-slate-800/40">
            <div class="flex justify-between items-center">
              <span class="font-medium text-slate-900 dark:text-white">{p.payoutId}</span>
              <span class="font-mono text-sm font-semibold text-slate-900 dark:text-white">
                {Number(p.totalAmount).toLocaleString()} {p.currency}
              </span>
            </div>
            <div class="mt-2 text-xs text-slate-500">
              Settlement Ref: <span class="font-mono">{p.settlementId}</span>
            </div>
            <div class="mt-1 text-xs font-mono text-slate-400 truncate">
              Proof Hash: {p.proofHash}
            </div>
          </div>
        {/each}
      </div>
    </div>
  </div>
</div>

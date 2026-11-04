<script lang="ts">
  import type { ApprovalRequest, ApprovalQueueStats } from '$lib/workflow/types';

  // Demo fixture data representing real P7-02 approval queue state
  let approvals = $state<ApprovalRequest[]>([
    {
      approval_id: 'appr-req-001',
      workspace_id: 'ws-demo-1',
      run_id: 'run-p7-101',
      workflow_id: 'wf-auto-order-01',
      node_id: 'node-appr-1',
      title: 'Discount Gate > 20% for VIP Order #8841',
      action_hash: 'a1b2c3d4e5f67890123456789abcdef0123456789abcdef0123456789abcdef0',
      action_rpc: 'creativanta.commerce.v1.DiscountService/ApplyOrderDiscount',
      target_objects: ['order:8841', 'customer:vip-99'],
      budget_quote_credits: 50,
      approver_roles: ['workspace_owner', 'billing_manager'],
      status: 'pending',
      requested_at: '2026-11-04T11:45:00Z',
      expires_at: '2026-11-05T11:45:00Z',
      is_invalidated: false
    },
    {
      approval_id: 'appr-req-002',
      workspace_id: 'ws-demo-1',
      run_id: 'run-p7-102',
      workflow_id: 'wf-auto-order-01',
      node_id: 'node-appr-1',
      title: 'Discount Gate > 30% - Action Payload Modified After Request',
      action_hash: 'b9876543210fedcba9876543210fedcba9876543210fedcba9876543210fedcb',
      action_rpc: 'creativanta.commerce.v1.DiscountService/ApplyOrderDiscount',
      target_objects: ['order:8842', 'customer:vip-104'],
      budget_quote_credits: 75,
      approver_roles: ['workspace_owner'],
      status: 'invalidated',
      requested_at: '2026-11-04T10:15:00Z',
      expires_at: '2026-11-05T10:15:00Z',
      is_invalidated: true,
      invalidation_reason: 'Workflow definition updated to v4 while approval was pending; action hash mismatch.'
    },
    {
      approval_id: 'appr-req-003',
      workspace_id: 'ws-demo-1',
      run_id: 'run-p7-103',
      workflow_id: 'wf-stock-alert-02',
      node_id: 'node-po-appr',
      title: 'Supplier Purchase Order PO-2026-904',
      action_hash: 'c8f1e2d3c4b5a67890abcdef1234567890abcdef1234567890abcdef12345678',
      action_rpc: 'creativanta.commerce.v1.InventoryService/CreatePurchaseOrder',
      target_objects: ['sku:item-glass-vases', 'supplier:sup-china-01'],
      budget_quote_credits: 120,
      approver_roles: ['workspace_owner', 'operations_lead'],
      status: 'approved',
      decided_by: 'usr-demo-lead',
      decided_at: '2026-11-04T09:30:00Z',
      decision_notes: 'Approved after checking current inventory levels against backorder demand.',
      requested_at: '2026-11-04T09:00:00Z',
      expires_at: '2026-11-05T09:00:00Z',
      is_invalidated: false
    }
  ]);

  let filterStatus = $state<string>('all');
  let selectedApproval = $state<ApprovalRequest | null>(approvals[0]);
  let decisionNotes = $state<string>('');
  let feedbackMessage = $state<string | null>(null);

  let filteredApprovals = $derived(
    approvals.filter((a) => {
      if (filterStatus === 'all') return true;
      if (filterStatus === 'pending') return a.status === 'pending';
      if (filterStatus === 'invalidated') return a.is_invalidated || a.status === 'invalidated';
      if (filterStatus === 'resolved') return a.status === 'approved' || a.status === 'rejected';
      return true;
    })
  );

  let stats = $derived<ApprovalQueueStats>({
    total: approvals.length,
    pending: approvals.filter((a) => a.status === 'pending' || a.status === 'pending_approval').length,
    approved: approvals.filter((a) => a.status === 'approved').length,
    rejected: approvals.filter((a) => a.status === 'rejected').length,
    expired: approvals.filter((a) => a.status === 'expired').length,
    cancelled: approvals.filter((a) => a.status === 'cancelled').length,
    pending_count: approvals.filter((a) => (a.status === 'pending' || a.status === 'pending_approval') && !a.is_invalidated).length,
    invalidated_count: approvals.filter((a) => a.is_invalidated || a.status === 'invalidated').length,
    expiring_soon_count: approvals.filter((a) => a.status === 'pending' || a.status === 'pending_approval').length,
    total_approved: approvals.filter((a) => a.status === 'approved').length,
    total_rejected: approvals.filter((a) => a.status === 'rejected').length
  });

  function handleApprove(id: string) {
    const item = approvals.find((a) => a.approval_id === id);
    if (!item) return;
    if (item.is_invalidated) {
      feedbackMessage = 'Cannot approve: this request was invalidated by an action or workflow change.';
      return;
    }
    item.status = 'approved';
    item.decided_by = 'usr-current-operator';
    item.decided_at = new Date().toISOString();
    item.decision_notes = decisionNotes || 'Approved via Studio UI';
    decisionNotes = '';
    feedbackMessage = `Approval ${id} confirmed. Engine resumed execution without replay.`;
  }

  function handleReject(id: string) {
    const item = approvals.find((a) => a.approval_id === id);
    if (!item) return;
    item.status = 'rejected';
    item.decided_by = 'usr-current-operator';
    item.decided_at = new Date().toISOString();
    item.decision_notes = decisionNotes || 'Rejected by operator';
    decisionNotes = '';
    feedbackMessage = `Approval ${id} rejected. Workflow resumed on denial/fallback branch.`;
  }

  function getStatusBadge(item: ApprovalRequest) {
    if (item.is_invalidated || item.status === 'invalidated') {
      return 'bg-amber-500/10 text-amber-400 border-amber-500/30';
    }
    switch (item.status) {
      case 'pending':
        return 'bg-blue-500/10 text-blue-400 border-blue-500/30';
      case 'approved':
        return 'bg-emerald-500/10 text-emerald-400 border-emerald-500/30';
      case 'rejected':
        return 'bg-rose-500/10 text-rose-400 border-rose-500/30';
      case 'expired':
        return 'bg-zinc-700/30 text-zinc-400 border-zinc-600/40';
      default:
        return 'bg-neutral-800 text-neutral-400 border-neutral-700';
    }
  }
</script>

<div class="min-h-screen bg-neutral-950 text-neutral-100 p-6 md:p-8">
  <div class="max-w-7xl mx-auto space-y-6">
    <!-- Header -->
    <div class="flex flex-col sm:flex-row sm:items-center justify-between gap-4 border-b border-neutral-800 pb-6">
      <div>
        <div class="flex items-center gap-3">
          <a href="/workflows" class="text-sm text-neutral-400 hover:text-white transition-colors">← Back to Workflows</a>
          <span class="text-neutral-600">/</span>
          <h1 class="text-2xl font-bold text-white tracking-tight">Human Approval Queue</h1>
          <span class="px-2.5 py-0.5 text-xs font-semibold rounded-full bg-indigo-500/10 text-indigo-400 border border-indigo-500/20">
            P7-02 Gate Enforcement
          </span>
        </div>
        <p class="text-sm text-neutral-400 mt-1">
          Review sensitive automated actions. Edits to upstream actions invalidate pending approvals automatically.
        </p>
      </div>

      <div class="flex items-center gap-3">
        <a
          href="/workflows/dlq"
          class="px-3.5 py-2 text-xs font-medium rounded-lg bg-neutral-900 border border-neutral-800 text-neutral-300 hover:text-white hover:bg-neutral-800 transition-colors"
        >
          View Dead-Letter Queue
        </a>
      </div>
    </div>

    <!-- Notification Alert -->
    {#if feedbackMessage}
      <div class="p-3.5 bg-neutral-900 border border-indigo-500/40 rounded-xl flex items-center justify-between text-xs text-indigo-200">
        <span>{feedbackMessage}</span>
        <button type="button" onclick={() => (feedbackMessage = null)} class="text-neutral-400 hover:text-white">✕</button>
      </div>
    {/if}

    <!-- Stat Summary Cards -->
    <div class="grid grid-cols-2 md:grid-cols-4 gap-4">
      <div class="bg-neutral-900/60 border border-neutral-800 rounded-xl p-4">
        <div class="text-xs text-neutral-400">Pending Approvals</div>
        <div class="text-2xl font-bold text-blue-400 mt-1">{stats.pending_count}</div>
      </div>
      <div class="bg-neutral-900/60 border border-neutral-800 rounded-xl p-4">
        <div class="text-xs text-neutral-400">Invalidated (Safety Lock)</div>
        <div class="text-2xl font-bold text-amber-400 mt-1">{stats.invalidated_count}</div>
      </div>
      <div class="bg-neutral-900/60 border border-neutral-800 rounded-xl p-4">
        <div class="text-xs text-neutral-400">Approved Executions</div>
        <div class="text-2xl font-bold text-emerald-400 mt-1">{stats.total_approved}</div>
      </div>
      <div class="bg-neutral-900/60 border border-neutral-800 rounded-xl p-4">
        <div class="text-xs text-neutral-400">Rejected / Expired</div>
        <div class="text-2xl font-bold text-rose-400 mt-1">{stats.total_rejected}</div>
      </div>
    </div>

    <!-- Toolbar Filters -->
    <div class="flex items-center gap-2 bg-neutral-900/60 p-3 rounded-xl border border-neutral-800">
      {#each ['all', 'pending', 'invalidated', 'resolved'] as tab}
        <button
          type="button"
          onclick={() => (filterStatus = tab)}
          class="px-3 py-1.5 text-xs font-medium rounded-lg capitalize transition-colors {filterStatus === tab
            ? 'bg-neutral-800 text-white border border-neutral-700 shadow-sm'
            : 'text-neutral-400 hover:text-neutral-200 hover:bg-neutral-800/40'}"
        >
          {tab}
        </button>
      {/each}
    </div>

    <!-- Master-Detail Layout -->
    <div class="grid grid-cols-1 lg:grid-cols-12 gap-6">
      <!-- Approvals List -->
      <div class="lg:col-span-5 space-y-3">
        {#each filteredApprovals as item (item.approval_id)}
          <button
            type="button"
            onclick={() => (selectedApproval = item)}
            class="w-full text-left p-4 rounded-xl border transition-all {selectedApproval?.approval_id === item.approval_id
              ? 'bg-neutral-800/80 border-indigo-500/50 shadow-md'
              : 'bg-neutral-900/40 border-neutral-800 hover:border-neutral-700'}"
          >
            <div class="flex items-start justify-between gap-2">
              <span class="text-xs font-semibold text-white line-clamp-1">{item.title}</span>
              <span class="px-2 py-0.5 text-[10px] uppercase font-mono tracking-wider rounded border {getStatusBadge(item)} shrink-0">
                {item.is_invalidated ? 'INVALIDATED' : item.status}
              </span>
            </div>

            <div class="text-[11px] font-mono text-neutral-400 mt-2 truncate">
              {item.action_rpc}
            </div>

            <div class="flex items-center justify-between text-[11px] text-neutral-500 mt-3 pt-2 border-t border-neutral-800/80">
              <span>Run: {item.run_id}</span>
              <span>Quote: {item.budget_quote_credits} credits</span>
            </div>
          </button>
        {/each}
      </div>

      <!-- Detail Pane -->
      <div class="lg:col-span-7">
        {#if selectedApproval}
          <div class="bg-neutral-900/60 border border-neutral-800 rounded-xl p-6 space-y-6">
            <div class="flex items-start justify-between">
              <div>
                <span class="text-[11px] font-mono text-neutral-400">Request #{selectedApproval.approval_id}</span>
                <h2 class="text-lg font-bold text-white mt-1">{selectedApproval.title}</h2>
              </div>
              <span class="px-2.5 py-1 text-xs uppercase font-mono tracking-wider rounded border {getStatusBadge(selectedApproval)}">
                {selectedApproval.is_invalidated ? 'INVALIDATED' : selectedApproval.status}
              </span>
            </div>

            <!-- Invalidation Notice Banner -->
            {#if selectedApproval.is_invalidated || selectedApproval.status === 'invalidated'}
              <div class="p-4 rounded-lg bg-amber-500/10 border border-amber-500/30 text-amber-200 text-xs space-y-1">
                <div class="font-bold flex items-center gap-1.5">
                  <span>⚠️ Action Approval Invalidated</span>
                </div>
                <p>
                  {selectedApproval.invalidation_reason ||
                    'The upstream action definition or workflow version changed while this approval was pending. To prevent unreviewed side-effects, the prior authorization was automatically rescinded.'}
                </p>
              </div>
            {/if}

            <!-- Action Details -->
            <div class="grid grid-cols-2 gap-4 text-xs">
              <div class="p-3 bg-neutral-950 rounded-lg border border-neutral-800">
                <span class="text-neutral-500 block mb-1">Target RPC</span>
                <span class="font-mono text-indigo-300 break-all">{selectedApproval.action_rpc}</span>
              </div>
              <div class="p-3 bg-neutral-950 rounded-lg border border-neutral-800">
                <span class="text-neutral-500 block mb-1">Action SHA-256 Hash</span>
                <span class="font-mono text-neutral-300 break-all">{(selectedApproval.action_hash || '').slice(0, 24)}...</span>
              </div>
              <div class="p-3 bg-neutral-950 rounded-lg border border-neutral-800">
                <span class="text-neutral-500 block mb-1">Target Resource Objects</span>
                <span class="text-neutral-200 font-mono">{(selectedApproval.target_objects || []).join(', ')}</span>
              </div>
              <div class="p-3 bg-neutral-950 rounded-lg border border-neutral-800">
                <span class="text-neutral-500 block mb-1">Estimated Credit Impact</span>
                <span class="text-amber-400 font-semibold">{selectedApproval.budget_quote_credits} credits</span>
              </div>
            </div>

            <!-- Audit Trail -->
            <div class="border-t border-neutral-800 pt-4 space-y-2 text-xs">
              <div class="text-neutral-400 font-semibold">Audit & Timeline</div>
              <div class="text-neutral-400">Requested: <span class="text-neutral-300">{selectedApproval.requested_at}</span></div>
              <div class="text-neutral-400">Expires: <span class="text-neutral-300">{selectedApproval.expires_at}</span></div>
              {#if selectedApproval.decided_by}
                <div class="text-neutral-400">Decided by: <span class="text-neutral-300">{selectedApproval.decided_by}</span> at {selectedApproval.decided_at}</div>
                <div class="text-neutral-400">Notes: <span class="text-neutral-300 italic">{selectedApproval.decision_notes}</span></div>
              {/if}
            </div>

            <!-- Decision Form (if pending and not invalidated) -->
            {#if selectedApproval.status === 'pending' && !selectedApproval.is_invalidated}
              <div class="border-t border-neutral-800 pt-4 space-y-3">
                <label for="approval-notes" class="block text-xs font-medium text-neutral-300">Decision Notes (Optional)</label>
                <textarea
                  id="approval-notes"
                  bind:value={decisionNotes}
                  rows="2"
                  placeholder="Record justification for audit trail..."
                  class="w-full bg-neutral-950 border border-neutral-800 rounded-lg p-2.5 text-xs text-neutral-200 placeholder-neutral-500 focus:outline-none focus:border-indigo-500"
                ></textarea>

                <div class="flex items-center justify-end gap-3 pt-2">
                  <button
                    type="button"
                    onclick={() => handleReject(selectedApproval!.approval_id || selectedApproval!.request_id || '')}
                    class="px-4 py-2 text-xs font-semibold rounded-lg bg-rose-600/20 text-rose-300 border border-rose-600/40 hover:bg-rose-600/30 transition-colors"
                  >
                    Reject (Trigger Fallback)
                  </button>
                  <button
                    type="button"
                    onclick={() => handleApprove(selectedApproval!.approval_id || selectedApproval!.request_id || '')}
                    class="px-4 py-2 text-xs font-semibold rounded-lg bg-emerald-600 hover:bg-emerald-500 text-white transition-colors"
                  >
                    Approve & Resume
                  </button>
                </div>
              </div>
            {/if}
          </div>
        {/if}
      </div>
    </div>
  </div>
</div>

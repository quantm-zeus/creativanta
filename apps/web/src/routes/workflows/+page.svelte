<script lang="ts">
  import type { WorkflowSummary, WorkflowStatus } from '$lib/workflow/types';

  let filterStatus = $state<string>('all');
  let searchQuery = $state<string>('');

  // Initial demo/fixture workflows
  let workflows = $state<WorkflowSummary[]>([
    {
      workflow_id: 'wf-auto-order-01',
      workspace_id: 'ws-demo-1',
      title: 'VIP Order Auto-Fulfillment & Discount Gate',
      workflow_type: 'custom',
      status: 'active',
      version: 3,
      trigger_type: 'event',
      node_count: 10,
      run_count: 142,
      created_at: '2026-10-30T10:00:00Z',
      updated_at: '2026-11-04T09:30:00Z'
    },
    {
      workflow_id: 'wf-stock-alert-02',
      workspace_id: 'ws-demo-1',
      title: 'Low Stock Auto-Reorder & Telegram Notification',
      workflow_type: 'recipe_installed',
      status: 'active',
      version: 2,
      trigger_type: 'schedule',
      node_count: 6,
      run_count: 89,
      created_at: '2026-11-01T08:00:00Z',
      updated_at: '2026-11-03T16:20:00Z'
    },
    {
      workflow_id: 'wf-creator-approval-03',
      workspace_id: 'ws-demo-1',
      title: 'Sample Request Creator Vetting & Handoff',
      workflow_type: 'custom',
      status: 'draft',
      version: 1,
      trigger_type: 'webhook',
      node_count: 7,
      run_count: 0,
      created_at: '2026-11-04T06:00:00Z',
      updated_at: '2026-11-04T07:15:00Z'
    },
    {
      workflow_id: 'wf-abandoned-cart-04',
      workspace_id: 'ws-demo-1',
      title: 'Abandoned Cart Follow-Up Sequence',
      workflow_type: 'custom',
      status: 'paused',
      version: 4,
      trigger_type: 'event',
      node_count: 8,
      run_count: 310,
      created_at: '2026-10-25T14:00:00Z',
      updated_at: '2026-11-02T11:00:00Z'
    }
  ]);

  let filteredWorkflows = $derived(
    workflows.filter((w) => {
      const matchesStatus = filterStatus === 'all' || w.status === filterStatus;
      const matchesSearch =
        searchQuery === '' ||
        w.title.toLowerCase().includes(searchQuery.toLowerCase()) ||
        w.workflow_id.toLowerCase().includes(searchQuery.toLowerCase());
      return matchesStatus && matchesSearch;
    })
  );

  function getStatusBadge(status: WorkflowStatus) {
    switch (status) {
      case 'active':
        return 'bg-emerald-500/10 text-emerald-400 border-emerald-500/20';
      case 'draft':
        return 'bg-amber-500/10 text-amber-400 border-amber-500/20';
      case 'paused':
        return 'bg-slate-500/10 text-slate-400 border-slate-500/20';
      case 'error':
        return 'bg-rose-500/10 text-rose-400 border-rose-500/20';
      case 'archived':
        return 'bg-zinc-800 text-zinc-500 border-zinc-700';
      default:
        return 'bg-slate-500/10 text-slate-400 border-slate-500/20';
    }
  }

  function getTriggerIcon(type: string) {
    switch (type) {
      case 'event':
        return '⚡ Event';
      case 'schedule':
        return '⏰ Cron';
      case 'webhook':
        return '🔗 Webhook';
      case 'manual':
        return '👆 Manual';
      default:
        return '⚡';
    }
  }
</script>

<div class="min-h-screen bg-neutral-950 text-neutral-100 p-6 md:p-8">
  <div class="max-w-7xl mx-auto space-y-6">
    <!-- Header -->
    <div class="flex flex-col sm:flex-row sm:items-center justify-between gap-4 border-b border-neutral-800 pb-6">
      <div>
        <div class="flex items-center gap-3">
          <h1 class="text-2xl font-bold text-white tracking-tight">Workflow Studio</h1>
          <span class="px-2.5 py-0.5 text-xs font-semibold rounded-full bg-indigo-500/10 text-indigo-400 border border-indigo-500/20">
            Native Owned Engine
          </span>
        </div>
        <p class="text-sm text-neutral-400 mt-1">
          Build, orchestrate, and simulate 10-node automation pipelines with zero third-party licensing dependencies.
        </p>
      </div>

      <div class="flex items-center gap-3">
        <a
          href="/workflows/wf-auto-order-01"
          class="inline-flex items-center justify-center gap-2 px-4 py-2 text-sm font-medium text-white bg-indigo-600 hover:bg-indigo-500 rounded-lg transition-colors shadow-sm"
        >
          <span>+ New Workflow</span>
        </a>
      </div>
    </div>

    <!-- Filters & Search Toolbar -->
    <div class="flex flex-col sm:flex-row gap-4 items-center justify-between bg-neutral-900/60 p-4 rounded-xl border border-neutral-800">
      <div class="flex items-center gap-2 overflow-x-auto w-full sm:w-auto">
        {#each ['all', 'active', 'draft', 'paused', 'error'] as st}
          <button
            type="button"
            onclick={() => (filterStatus = st)}
            class="px-3 py-1.5 text-xs font-medium rounded-lg capitalize transition-colors {filterStatus === st
              ? 'bg-neutral-800 text-white border border-neutral-700 shadow-sm'
              : 'text-neutral-400 hover:text-neutral-200 hover:bg-neutral-800/50'}"
          >
            {st}
          </button>
        {/each}
      </div>

      <div class="relative w-full sm:w-72">
        <input
          type="text"
          bind:value={searchQuery}
          placeholder="Search workflows..."
          class="w-full bg-neutral-950 border border-neutral-800 rounded-lg px-3.5 py-1.5 text-sm text-neutral-200 placeholder-neutral-500 focus:outline-none focus:border-indigo-500 transition-colors"
        />
      </div>
    </div>

    <!-- Workflow Cards Grid -->
    <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-5">
      {#each filteredWorkflows as wf (wf.workflow_id)}
        <div class="group relative flex flex-col justify-between bg-neutral-900 border border-neutral-800 hover:border-neutral-700 rounded-xl p-5 transition-all shadow-sm">
          <div>
            <div class="flex items-start justify-between gap-3 mb-3">
              <span class="inline-flex items-center px-2 py-0.5 text-xs font-medium rounded-md border {getStatusBadge(wf.status)}">
                {wf.status.toUpperCase()}
              </span>
              <span class="text-xs text-neutral-400 font-mono bg-neutral-950 px-2 py-0.5 rounded border border-neutral-800">
                {getTriggerIcon(wf.trigger_type)}
              </span>
            </div>

            <h3 class="text-base font-semibold text-white group-hover:text-indigo-400 transition-colors line-clamp-1">
              <a href="/workflows/{wf.workflow_id}" class="hover:underline">
                {wf.title}
              </a>
            </h3>

            <p class="text-xs text-neutral-400 font-mono mt-1">
              ID: {wf.workflow_id}
            </p>
          </div>

          <div class="mt-6 pt-4 border-t border-neutral-800/80 flex items-center justify-between text-xs text-neutral-400">
            <div class="flex items-center gap-3">
              <span>{wf.node_count} nodes</span>
              <span>•</span>
              <span>v{wf.version}</span>
              <span>•</span>
              <span>{wf.run_count} runs</span>
            </div>

            <a
              href="/workflows/{wf.workflow_id}"
              class="text-indigo-400 hover:text-indigo-300 font-medium inline-flex items-center gap-1 transition-colors"
            >
              Open &rarr;
            </a>
          </div>
        </div>
      {/each}

      {#if filteredWorkflows.length === 0}
        <div class="col-span-full py-16 text-center text-neutral-500 bg-neutral-900/30 rounded-xl border border-dashed border-neutral-800">
          <p class="text-base font-medium">No workflows match the selected criteria.</p>
          <p class="text-xs mt-1">Try resetting the status filter or search query.</p>
        </div>
      {/if}
    </div>
  </div>
</div>

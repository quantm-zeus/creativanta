<script lang="ts">
  import type { DLQItem } from '$lib/workflow/types';

  let dlqItems = $state<DLQItem[]>([
    {
      dlq_id: 'dlq-1001',
      workspace_id: 'ws-demo-1',
      run_id: 'run-fail-771',
      workflow_id: 'wf-auto-order-01',
      node_id: 'node-act-1',
      error_code: 'RATE_LIMIT_EXCEEDED',
      error_message: 'Target platform API responded with 429 Too Many Requests; max attempts exhausted.',
      failed_payload: { sku_id: 'sku-vip-99', quantity: 1, reservation_token: 'tok-res-771' },
      retry_count: 3,
      max_retries: 3,
      status: 'pending',
      created_at: '2026-11-04T10:30:00Z',
      updated_at: '2026-11-04T10:35:00Z'
    },
    {
      dlq_id: 'dlq-1002',
      workspace_id: 'ws-demo-1',
      run_id: 'run-fail-772',
      workflow_id: 'wf-stock-alert-02',
      node_id: 'node-act-notify',
      error_code: 'MALFORMED_RECIPIENT_ID',
      error_message: 'Target chat channel could not be parsed: recipient string empty or invalid channel id.',
      failed_payload: { channel: '', text: 'Low stock detected for SKU 8891' },
      retry_count: 1,
      max_retries: 3,
      status: 'pending',
      created_at: '2026-11-04T11:10:00Z',
      updated_at: '2026-11-04T11:10:00Z'
    },
    {
      dlq_id: 'dlq-1003',
      workspace_id: 'ws-demo-1',
      run_id: 'run-fail-770',
      workflow_id: 'wf-abandoned-cart-04',
      node_id: 'node-act-email',
      error_code: 'CAPABILITY_DEGRADED',
      error_message: 'Email dispatch connector snapshot shows platform in MAINTENANCE mode.',
      failed_payload: { to: 'cust-abandoned@example.com', template_id: 'cart-reminder' },
      retry_count: 2,
      max_retries: 3,
      status: 'resolved',
      created_at: '2026-11-03T18:00:00Z',
      updated_at: '2026-11-03T18:45:00Z'
    }
  ]);

  let filterStatus = $state<string>('all');
  let selectedItem = $state<DLQItem | null>(dlqItems[0]);
  let editPayloadText = $state<string>('');
  let feedbackMessage = $state<string | null>(null);

  $effect(() => {
    if (selectedItem) {
      editPayloadText = JSON.stringify(selectedItem.failed_payload, null, 2);
    }
  });

  let filteredItems = $derived(
    dlqItems.filter((i) => {
      if (filterStatus === 'all') return true;
      return i.status === filterStatus;
    })
  );

  function handleRetry(id: string) {
    const item = dlqItems.find((d) => d.dlq_id === id);
    if (!item) return;
    item.status = 'retrying';
    item.retry_count = (item.retry_count ?? 0) + 1;
    feedbackMessage = `Retrying execution for DLQ item ${id}. Run resumed.`;
  }

  function handleRepairAndRetry(id: string) {
    const item = dlqItems.find((d) => d.dlq_id === id);
    if (!item) return;
    try {
      const parsed = JSON.parse(editPayloadText);
      item.failed_payload = parsed;
      item.status = 'retrying';
      item.retry_count = (item.retry_count ?? 0) + 1;
      feedbackMessage = `Payload repaired and run re-queued for DLQ item ${id}.`;
    } catch {
      feedbackMessage = 'Invalid JSON payload. Please correct syntax before repairing.';
    }
  }

  function handleDiscard(id: string) {
    const item = dlqItems.find((d) => d.dlq_id === id);
    if (!item) return;
    item.status = 'discarded';
    feedbackMessage = `DLQ item ${id} discarded. Node marked as permanently failed.`;
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
          <h1 class="text-2xl font-bold text-white tracking-tight">Dead-Letter Queue (DLQ)</h1>
          <span class="px-2.5 py-0.5 text-xs font-semibold rounded-full bg-rose-500/10 text-rose-400 border border-rose-500/20">
            P7-02 Fault Recovery
          </span>
        </div>
        <p class="text-sm text-neutral-400 mt-1">
          Inspect failed workflow executions, diagnose root causes, repair payloads, and re-dispatch safely without effect replay.
        </p>
      </div>

      <div class="flex items-center gap-3">
        <a
          href="/workflows/approvals"
          class="px-3.5 py-2 text-xs font-medium rounded-lg bg-neutral-900 border border-neutral-800 text-neutral-300 hover:text-white hover:bg-neutral-800 transition-colors"
        >
          View Approval Queue
        </a>
      </div>
    </div>

    <!-- Feedback Banner -->
    {#if feedbackMessage}
      <div class="p-3.5 bg-neutral-900 border border-rose-500/40 rounded-xl flex items-center justify-between text-xs text-rose-200">
        <span>{feedbackMessage}</span>
        <button type="button" onclick={() => (feedbackMessage = null)} class="text-neutral-400 hover:text-white">✕</button>
      </div>
    {/if}

    <!-- Toolbar Filters -->
    <div class="flex items-center gap-2 bg-neutral-900/60 p-3 rounded-xl border border-neutral-800">
      {#each ['all', 'pending', 'retrying', 'resolved', 'discarded'] as tab}
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
      <!-- DLQ List -->
      <div class="lg:col-span-5 space-y-3">
        {#each filteredItems as item (item.dlq_id)}
          <button
            type="button"
            onclick={() => (selectedItem = item)}
            class="w-full text-left p-4 rounded-xl border transition-all {selectedItem?.dlq_id === item.dlq_id
              ? 'bg-neutral-800/80 border-rose-500/50 shadow-md'
              : 'bg-neutral-900/40 border-neutral-800 hover:border-neutral-700'}"
          >
            <div class="flex items-start justify-between gap-2">
              <span class="text-xs font-bold font-mono text-rose-400">{item.error_code}</span>
              <span class="px-2 py-0.5 text-[10px] uppercase font-mono tracking-wider rounded border {item.status === 'resolved'
                ? 'bg-emerald-500/10 text-emerald-400 border-emerald-500/30'
                : item.status === 'discarded'
                ? 'bg-zinc-800 text-zinc-500 border-zinc-700'
                : 'bg-rose-500/10 text-rose-400 border-rose-500/30'} shrink-0">
                {item.status}
              </span>
            </div>

            <div class="text-xs text-neutral-300 mt-2 line-clamp-2">
              {item.error_message}
            </div>

            <div class="flex items-center justify-between text-[11px] text-neutral-500 mt-3 pt-2 border-t border-neutral-800/80">
              <span>Run: {item.run_id} (Node: {item.node_id})</span>
              <span>Retries: {item.retry_count}/{item.max_retries}</span>
            </div>
          </button>
        {/each}
      </div>

      <!-- Detail & Repair Pane -->
      <div class="lg:col-span-7">
        {#if selectedItem}
          <div class="bg-neutral-900/60 border border-neutral-800 rounded-xl p-6 space-y-6">
            <div class="flex items-start justify-between">
              <div>
                <span class="text-[11px] font-mono text-neutral-400">DLQ Item #{selectedItem.dlq_id}</span>
                <h2 class="text-lg font-bold text-rose-300 mt-1">{selectedItem.error_code}</h2>
              </div>
              <span class="px-2.5 py-1 text-xs uppercase font-mono tracking-wider rounded border bg-rose-500/10 text-rose-400 border-rose-500/30">
                {selectedItem.status}
              </span>
            </div>

            <!-- Error Summary -->
            <div class="p-3.5 bg-neutral-950 rounded-lg border border-neutral-800 text-xs">
              <div class="text-neutral-500 text-[11px] mb-1 font-semibold uppercase tracking-wider">Root Cause Explanation</div>
              <p class="text-neutral-200">{selectedItem.error_message}</p>
            </div>

            <!-- Metadata Cards -->
            <div class="grid grid-cols-2 sm:grid-cols-4 gap-3 text-xs">
              <div class="p-3 bg-neutral-950 rounded-lg border border-neutral-800">
                <span class="text-neutral-500 block mb-1">Workflow ID</span>
                <span class="font-mono text-neutral-300 truncate block">{selectedItem.workflow_id}</span>
              </div>
              <div class="p-3 bg-neutral-950 rounded-lg border border-neutral-800">
                <span class="text-neutral-500 block mb-1">Run ID</span>
                <span class="font-mono text-neutral-300 truncate block">{selectedItem.run_id}</span>
              </div>
              <div class="p-3 bg-neutral-950 rounded-lg border border-neutral-800">
                <span class="text-neutral-500 block mb-1">Failed Node</span>
                <span class="font-mono text-indigo-300 truncate block">{selectedItem.node_id}</span>
              </div>
              <div class="p-3 bg-neutral-950 rounded-lg border border-neutral-800">
                <span class="text-neutral-500 block mb-1">Retries</span>
                <span class="font-bold text-amber-400">{selectedItem.retry_count} of {selectedItem.max_retries}</span>
              </div>
            </div>

            <!-- Payload Repair Form -->
            <div class="space-y-2">
              <div class="flex items-center justify-between">
                <label for="repair-payload" class="text-xs font-semibold text-neutral-300">Payload JSON (Editable for Repair)</label>
                <span class="text-[10px] text-neutral-500 font-mono">Modifications re-validate on dispatch</span>
              </div>
              <textarea
                id="repair-payload"
                bind:value={editPayloadText}
                rows="6"
                class="w-full bg-neutral-950 border border-neutral-800 rounded-lg p-3 text-xs text-emerald-300 font-mono focus:outline-none focus:border-indigo-500"
              ></textarea>
            </div>

            <!-- Actions Bar -->
            <div class="border-t border-neutral-800 pt-4 flex flex-wrap items-center justify-between gap-3">
              <button
                type="button"
                onclick={() => handleDiscard(selectedItem!.dlq_id)}
                class="px-3.5 py-2 text-xs font-semibold rounded-lg bg-zinc-800 hover:bg-zinc-700 text-zinc-300 transition-colors"
              >
                Discard & Archive
              </button>

              <div class="flex items-center gap-3">
                <button
                  type="button"
                  onclick={() => handleRetry(selectedItem!.dlq_id)}
                  class="px-4 py-2 text-xs font-semibold rounded-lg bg-neutral-800 hover:bg-neutral-700 text-neutral-200 border border-neutral-700 transition-colors"
                >
                  Direct Retry
                </button>
                <button
                  type="button"
                  onclick={() => handleRepairAndRetry(selectedItem!.dlq_id)}
                  class="px-4 py-2 text-xs font-semibold rounded-lg bg-indigo-600 hover:bg-indigo-500 text-white transition-colors shadow-sm"
                >
                  Repair Payload & Retry
                </button>
              </div>
            </div>
          </div>
        {/if}
      </div>
    </div>
  </div>
</div>

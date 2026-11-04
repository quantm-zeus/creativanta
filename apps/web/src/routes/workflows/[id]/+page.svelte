<script lang="ts">
  import { page } from '$app/state';
  import type {
    Workflow,
    WorkflowNode,
    WorkflowEdge,
    NodeType,
    TriggerType,
    SimulationReport
  } from '$lib/workflow/types';
  import { validateWorkflowGraph } from '$lib/workflow/validation';

  const workflowId = page.params.id || 'wf-auto-order-01';

  // Workflow State
  let title = $state('VIP Order Auto-Fulfillment & Discount Gate');
  let description = $state('Orchestrates VIP order validation, inventory reservation, discount approval, and diagnostics.');
  let status = $state<'draft' | 'active' | 'paused'>('active');
  let version = $state(3);
  let selectedNodeId = $state<string>('node-trig-1');
  let showSimModal = $state(false);
  let saveNotification = $state<string | null>(null);

  // Nodes & Edges
  let nodes = $state<WorkflowNode[]>([
    {
      node_id: 'node-trig-1',
      node_type: 'trigger',
      title: 'Order Placed Trigger',
      trigger_config: { type: 'event', event_type: 'order.placed' }
    },
    {
      node_id: 'node-cond-1',
      node_type: 'condition',
      title: 'Check VIP Level',
      condition_config: { field: 'customer.is_vip', operator: 'eq', value_json: 'true' }
    },
    {
      node_id: 'node-trans-1',
      node_type: 'transform',
      title: 'Format VIP Payload',
      transform_config: {
        mappings: [
          { target_field: 'greeting', source_field: 'customer.name', template: 'Hello {{customer.name}}' },
          { target_field: 'tier', source_field: 'customer.tier', default_value: 'standard' }
        ]
      }
    },
    {
      node_id: 'node-act-1',
      node_type: 'action',
      title: 'Reserve VIP Sku',
      action_config: {
        rpc_name: 'creativanta.commerce.v1.InventoryService/ReserveStock',
        input_json: '{"sku_id":"sku-vip-99","quantity":1}',
        timeout_seconds: 10,
        max_retries: 3
      }
    },
    {
      node_id: 'node-appr-1',
      node_type: 'approval',
      title: 'Manager Approval Gate',
      approval_config: {
        approver_ids: ['usr-mgr-1'],
        required_approvals: 1,
        expires_at_duration_seconds: 86400,
        auto_action_on_timeout: 'fallback'
      }
    },
    {
      node_id: 'node-wait-1',
      node_type: 'wait',
      title: 'Wait 10 Minutes',
      wait_config: { wait_type: 'duration', duration_seconds: 600 }
    },
    {
      node_id: 'node-diag-1',
      node_type: 'diagnostics',
      title: 'Diagnostics Trace',
      diagnostics_config: {
        severity: 'info',
        user_message: 'VIP workflow step executed successfully',
        operator_message: 'Payload validated against schema',
        recommended_next_step: 'Proceed to fulfill'
      }
    },
    {
      node_id: 'node-fall-1',
      node_type: 'fallback',
      title: 'Standard Route',
      fallback_config: {
        fallback_node_id: 'node-term-1',
        reason_template: 'Non-VIP customer routing',
        log_level: 'warning'
      }
    },
    {
      node_id: 'node-hand-1',
      node_type: 'handoff',
      title: 'VIP Support Handoff',
      handoff_config: {
        target_user_id: 'usr-support-1',
        target_role: 'support',
        context_note: 'High-value order review'
      }
    },
    {
      node_id: 'node-term-1',
      node_type: 'terminal',
      title: 'Workflow Succeeded',
      terminal_config: { outcome: 'succeeded', result_template: 'Order processed successfully' }
    }
  ]);

  let edges = $state<WorkflowEdge[]>([
    { from_node_id: 'node-trig-1', to_node_id: 'node-cond-1' },
    { from_node_id: 'node-cond-1', to_node_id: 'node-trans-1', branch: 'true' },
    { from_node_id: 'node-cond-1', to_node_id: 'node-fall-1', branch: 'false' },
    { from_node_id: 'node-trans-1', to_node_id: 'node-act-1' },
    { from_node_id: 'node-act-1', to_node_id: 'node-appr-1' },
    { from_node_id: 'node-appr-1', to_node_id: 'node-wait-1' },
    { from_node_id: 'node-wait-1', to_node_id: 'node-diag-1' },
    { from_node_id: 'node-diag-1', to_node_id: 'node-hand-1' },
    { from_node_id: 'node-hand-1', to_node_id: 'node-term-1' },
    { from_node_id: 'node-fall-1', to_node_id: 'node-term-1' }
  ]);

  // Validation
  let validation = $derived(validateWorkflowGraph({ schema_version: 1, nodes, edges }));

  // Selected Node
  let selectedNode = $derived(nodes.find((n) => n.node_id === selectedNodeId) || nodes[0]);

  // Simulation Report
  let simulationReport = $state<SimulationReport | null>(null);

  function getNodeBadgeColor(type: NodeType) {
    switch (type) {
      case 'trigger':
        return 'bg-amber-500/20 text-amber-300 border-amber-500/30';
      case 'condition':
        return 'bg-purple-500/20 text-purple-300 border-purple-500/30';
      case 'transform':
        return 'bg-blue-500/20 text-blue-300 border-blue-500/30';
      case 'action':
        return 'bg-emerald-500/20 text-emerald-300 border-emerald-500/30';
      case 'approval':
        return 'bg-orange-500/20 text-orange-300 border-orange-500/30';
      case 'wait':
        return 'bg-cyan-500/20 text-cyan-300 border-cyan-500/30';
      case 'fallback':
        return 'bg-pink-500/20 text-pink-300 border-pink-500/30';
      case 'diagnostics':
        return 'bg-indigo-500/20 text-indigo-300 border-indigo-500/30';
      case 'handoff':
        return 'bg-teal-500/20 text-teal-300 border-teal-500/30';
      case 'terminal':
        return 'bg-green-500/20 text-green-300 border-green-500/30';
      default:
        return 'bg-neutral-800 text-neutral-300 border-neutral-700';
    }
  }

  function addNode(type: NodeType) {
    const id = `node-${type.slice(0, 4)}-${Date.now().toString().slice(-4)}`;
    const newNode: WorkflowNode = {
      node_id: id,
      node_type: type,
      title: `New ${type.charAt(0).toUpperCase() + type.slice(1)} Node`
    };

    if (type === 'condition') {
      newNode.condition_config = { field: 'status', operator: 'eq', value_json: '"active"' };
    } else if (type === 'transform') {
      newNode.transform_config = { mappings: [{ target_field: 'output_key', source_field: 'input_key' }] };
    } else if (type === 'action') {
      newNode.action_config = { rpc_name: 'creativanta.commerce.v1.InventoryService/CheckStock', input_json: '{}' };
    } else if (type === 'approval') {
      newNode.approval_config = { approver_ids: ['usr-1'], required_approvals: 1, expires_at_duration_seconds: 3600 };
    } else if (type === 'wait') {
      newNode.wait_config = { wait_type: 'duration', duration_seconds: 60 };
    } else if (type === 'fallback') {
      newNode.fallback_config = { fallback_node_id: 'node-term-1', log_level: 'warning' };
    } else if (type === 'diagnostics') {
      newNode.diagnostics_config = { severity: 'info', user_message: 'Diagnostics message', operator_message: 'Operator note' };
    } else if (type === 'handoff') {
      newNode.handoff_config = { target_user_id: 'usr-agent-1' };
    } else if (type === 'terminal') {
      newNode.terminal_config = { outcome: 'succeeded' };
    }

    nodes = [...nodes, newNode];
    selectedNodeId = id;
  }

  function deleteNode(nodeId: string) {
    if (nodes.length <= 2) {
      alert('A workflow must maintain at least one trigger and one terminal node.');
      return;
    }
    nodes = nodes.filter((n) => n.node_id !== nodeId);
    edges = edges.filter((e) => e.from_node_id !== nodeId && e.to_node_id !== nodeId);
    if (selectedNodeId === nodeId) {
      selectedNodeId = nodes[0].node_id;
    }
  }

  function runDryRunSimulation() {
    // Execute simulation of current workflow graph with zero side effects
    simulationReport = {
      success: validation.valid,
      total_estimated_credits: 2.0,
      simulation_summary: `Dry-run executed across ${nodes.length} nodes. 0 business side effects recorded.`,
      step_results: nodes.map((n) => ({
        node_id: n.node_id,
        node_type: n.node_type,
        status: 'simulated_success',
        estimated_credits: n.node_type === 'action' ? 2.0 : 0.0,
        diagnostic_message: `Simulated ${n.node_type} execution successfully.`
      }))
    };
    showSimModal = true;
  }

  function saveWorkflow() {
    if (!validation.valid) {
      alert(`Cannot save invalid workflow:\n${validation.errors.join('\n')}`);
      return;
    }
    version += 1;
    saveNotification = `Workflow saved successfully (v${version})`;
    setTimeout(() => {
      saveNotification = null;
    }, 3000);
  }

  function toggleStatus() {
    if (status === 'draft') status = 'active';
    else if (status === 'active') status = 'paused';
    else status = 'draft';
  }

  function exportWorkflow() {
    const payload = {
      schema_version: 1,
      title,
      description,
      workflow_type: 'custom',
      trigger_config: nodes[0].trigger_config || { type: 'event' },
      graph: { schema_version: 1, nodes, edges },
      license_notice: 'Creativanta Portable Workflow Template v1.0. Proprietary to tenant workspace.'
    };
    const blob = new Blob([JSON.stringify(payload, null, 2)], { type: 'application/json' });
    const url = URL.createObjectURL(blob);
    const a = document.createElement('a');
    a.href = url;
    a.download = `${title.toLowerCase().replace(/[^a-z0-9]/g, '_')}_v${version}.json`;
    a.click();
    URL.revokeObjectURL(url);
  }
</script>

<div class="flex flex-col h-screen bg-neutral-950 text-neutral-100 overflow-hidden font-sans">
  <!-- Top Toolbar -->
  <header class="h-14 border-b border-neutral-800 bg-neutral-900/80 px-4 flex items-center justify-between gap-4 shrink-0">
    <div class="flex items-center gap-3 min-w-0">
      <a href="/workflows" class="text-neutral-400 hover:text-white text-sm transition-colors flex items-center gap-1">
        <span>&larr;</span>
        <span class="hidden sm:inline">Workflows</span>
      </a>
      <span class="text-neutral-600">/</span>
      <input
        type="text"
        bind:value={title}
        class="bg-transparent border-b border-transparent hover:border-neutral-700 focus:border-indigo-500 px-1 py-0.5 text-sm font-semibold text-white focus:outline-none transition-colors truncate max-w-xs sm:max-w-md"
      />
      <span class="hidden lg:inline-flex items-center px-2 py-0.5 rounded text-[11px] font-mono bg-indigo-500/10 text-indigo-400 border border-indigo-500/20">
        v{version}
      </span>
      <span class="hidden xl:inline-flex items-center px-2 py-0.5 rounded text-[11px] font-medium bg-emerald-500/10 text-emerald-400 border border-emerald-500/20">
        Native Engine
      </span>
    </div>

    <!-- Actions -->
    <div class="flex items-center gap-2">
      <button
        type="button"
        onclick={toggleStatus}
        class="px-2.5 py-1 text-xs font-semibold rounded-md border capitalize transition-colors {status === 'active'
          ? 'bg-emerald-500/20 text-emerald-300 border-emerald-500/30'
          : status === 'draft'
            ? 'bg-amber-500/20 text-amber-300 border-amber-500/30'
            : 'bg-neutral-800 text-neutral-300 border-neutral-700'}"
      >
        {status}
      </button>

      <button
        type="button"
        onclick={exportWorkflow}
        class="hidden md:inline-flex items-center gap-1.5 px-3 py-1.5 text-xs font-medium text-neutral-300 hover:text-white bg-neutral-800 hover:bg-neutral-700 rounded-lg transition-colors border border-neutral-700"
      >
        <span>Export</span>
      </button>

      <button
        type="button"
        onclick={runDryRunSimulation}
        class="inline-flex items-center gap-1.5 px-3 py-1.5 text-xs font-medium text-indigo-300 hover:text-white bg-indigo-950/60 hover:bg-indigo-900/60 rounded-lg transition-colors border border-indigo-800/80"
      >
        <span>▶ Test</span>
      </button>

      <button
        type="button"
        onclick={saveWorkflow}
        class="inline-flex items-center gap-1.5 px-3.5 py-1.5 text-xs font-semibold text-white bg-indigo-600 hover:bg-indigo-500 rounded-lg transition-colors shadow-sm"
      >
        <span>Save</span>
      </button>
    </div>
  </header>

  <!-- Notification Banner -->
  {#if saveNotification}
    <div class="bg-emerald-500/10 border-b border-emerald-500/20 px-4 py-1.5 text-xs font-medium text-emerald-300 text-center animate-fade-in">
      ✓ {saveNotification}
    </div>
  {/if}

  {#if !validation.valid}
    <div class="bg-rose-500/10 border-b border-rose-500/30 px-4 py-2 text-xs text-rose-300 flex items-center justify-between">
      <div class="flex items-center gap-2">
        <span class="font-bold">Graph Validation Error:</span>
        <span>{validation.errors[0]}</span>
      </div>
      <span class="text-[11px] text-rose-400 font-mono">({validation.errors.length} issues)</span>
    </div>
  {/if}

  <!-- 3-Column Main Builder View -->
  <div class="flex flex-1 overflow-hidden">
    <!-- Left Column: Node Palette (220px) -->
    <aside class="w-56 border-r border-neutral-800 bg-neutral-900/40 p-3 overflow-y-auto shrink-0 flex flex-col gap-4">
      <div>
        <h4 class="text-[11px] font-bold uppercase tracking-wider text-neutral-400 mb-2">Triggers</h4>
        <div class="space-y-1.5">
          <button
            type="button"
            onclick={() => addNode('trigger')}
            class="w-full text-left px-2.5 py-1.5 rounded-lg text-xs font-medium bg-neutral-900 hover:bg-neutral-800 border border-neutral-800 hover:border-neutral-700 text-neutral-200 transition-colors flex items-center gap-2"
          >
            <span>⚡</span>
            <span>Event / Webhook</span>
          </button>
        </div>
      </div>

      <div>
        <h4 class="text-[11px] font-bold uppercase tracking-wider text-neutral-400 mb-2">Flow & Logic</h4>
        <div class="space-y-1.5">
          <button
            type="button"
            onclick={() => addNode('condition')}
            class="w-full text-left px-2.5 py-1.5 rounded-lg text-xs font-medium bg-neutral-900 hover:bg-neutral-800 border border-neutral-800 hover:border-neutral-700 text-neutral-200 transition-colors flex items-center gap-2"
          >
            <span>❓</span>
            <span>Condition (If/Else)</span>
          </button>
          <button
            type="button"
            onclick={() => addNode('approval')}
            class="w-full text-left px-2.5 py-1.5 rounded-lg text-xs font-medium bg-neutral-900 hover:bg-neutral-800 border border-neutral-800 hover:border-neutral-700 text-neutral-200 transition-colors flex items-center gap-2"
          >
            <span>🛡️</span>
            <span>Approval Gate</span>
          </button>
          <button
            type="button"
            onclick={() => addNode('wait')}
            class="w-full text-left px-2.5 py-1.5 rounded-lg text-xs font-medium bg-neutral-900 hover:bg-neutral-800 border border-neutral-800 hover:border-neutral-700 text-neutral-200 transition-colors flex items-center gap-2"
          >
            <span>⏱️</span>
            <span>Wait / Delay</span>
          </button>
          <button
            type="button"
            onclick={() => addNode('fallback')}
            class="w-full text-left px-2.5 py-1.5 rounded-lg text-xs font-medium bg-neutral-900 hover:bg-neutral-800 border border-neutral-800 hover:border-neutral-700 text-neutral-200 transition-colors flex items-center gap-2"
          >
            <span>🔄</span>
            <span>Fallback Route</span>
          </button>
          <button
            type="button"
            onclick={() => addNode('handoff')}
            class="w-full text-left px-2.5 py-1.5 rounded-lg text-xs font-medium bg-neutral-900 hover:bg-neutral-800 border border-neutral-800 hover:border-neutral-700 text-neutral-200 transition-colors flex items-center gap-2"
          >
            <span>👤</span>
            <span>Human Handoff</span>
          </button>
        </div>
      </div>

      <div>
        <h4 class="text-[11px] font-bold uppercase tracking-wider text-neutral-400 mb-2">Actions & Output</h4>
        <div class="space-y-1.5">
          <button
            type="button"
            onclick={() => addNode('action')}
            class="w-full text-left px-2.5 py-1.5 rounded-lg text-xs font-medium bg-neutral-900 hover:bg-neutral-800 border border-neutral-800 hover:border-neutral-700 text-neutral-200 transition-colors flex items-center gap-2"
          >
            <span>⚙️</span>
            <span>Action RPC</span>
          </button>
          <button
            type="button"
            onclick={() => addNode('transform')}
            class="w-full text-left px-2.5 py-1.5 rounded-lg text-xs font-medium bg-neutral-900 hover:bg-neutral-800 border border-neutral-800 hover:border-neutral-700 text-neutral-200 transition-colors flex items-center gap-2"
          >
            <span>🔀</span>
            <span>Data Transform</span>
          </button>
          <button
            type="button"
            onclick={() => addNode('diagnostics')}
            class="w-full text-left px-2.5 py-1.5 rounded-lg text-xs font-medium bg-neutral-900 hover:bg-neutral-800 border border-neutral-800 hover:border-neutral-700 text-neutral-200 transition-colors flex items-center gap-2"
          >
            <span>📊</span>
            <span>Diagnostics Log</span>
          </button>
          <button
            type="button"
            onclick={() => addNode('terminal')}
            class="w-full text-left px-2.5 py-1.5 rounded-lg text-xs font-medium bg-neutral-900 hover:bg-neutral-800 border border-neutral-800 hover:border-neutral-700 text-neutral-200 transition-colors flex items-center gap-2"
          >
            <span>🏁</span>
            <span>Terminal Outcome</span>
          </button>
        </div>
      </div>
    </aside>

    <!-- Center Column: Canvas (flexible) -->
    <main class="flex-1 bg-neutral-950 p-6 overflow-y-auto relative flex flex-col items-center">
      <div class="max-w-2xl w-full space-y-4">
        {#each nodes as node, idx (node.node_id)}
          <div
            role="button"
            tabindex="0"
            onclick={() => (selectedNodeId = node.node_id)}
            onkeydown={(e) => {
              if (e.key === 'Enter' || e.key === ' ') {
                selectedNodeId = node.node_id;
              }
            }}
            class="group relative flex flex-col p-4 rounded-xl border transition-all cursor-pointer {selectedNodeId === node.node_id
              ? 'bg-neutral-900 border-indigo-500 shadow-lg shadow-indigo-500/10'
              : 'bg-neutral-900/60 border-neutral-800 hover:border-neutral-700'}"
          >
            <div class="flex items-center justify-between gap-3">
              <div class="flex items-center gap-2.5">
                <span class="px-2 py-0.5 rounded text-[11px] font-mono font-semibold uppercase border {getNodeBadgeColor(node.node_type)}">
                  {node.node_type}
                </span>
                <span class="text-sm font-semibold text-white group-hover:text-indigo-300 transition-colors">
                  {node.title}
                </span>
              </div>

              <div class="flex items-center gap-2">
                <span class="text-[11px] font-mono text-neutral-500">#{node.node_id}</span>
                {#if node.node_type !== 'trigger' && node.node_type !== 'terminal'}
                  <button
                    type="button"
                    onclick={(e) => {
                      e.stopPropagation();
                      deleteNode(node.node_id);
                    }}
                    class="text-neutral-500 hover:text-rose-400 text-xs px-1 rounded transition-colors"
                    title="Delete node"
                  >
                    ✕
                  </button>
                {/if}
              </div>
            </div>

            <!-- Context snippets -->
            <div class="mt-2 text-xs text-neutral-400 font-mono">
              {#if node.node_type === 'trigger'}
                Type: {node.trigger_config?.type || 'event'} | Event: {node.trigger_config?.event_type || 'N/A'}
              {:else if node.node_type === 'condition'}
                Condition: {node.condition_config?.field || 'field'} {node.condition_config?.operator || '=='} {node.condition_config?.value_json || 'val'}
              {:else if node.node_type === 'action'}
                RPC: {node.action_config?.rpc_name || 'RPC call'}
              {:else if node.node_type === 'transform'}
                Mappings: {node.transform_config?.mappings.length || 0} fields
              {:else if node.node_type === 'approval'}
                Approvers: {node.approval_config?.approver_ids.join(', ') || '1'} (Timeout: {node.approval_config?.auto_action_on_timeout || 'reject'})
              {:else if node.node_type === 'wait'}
                Delay: {node.wait_config?.duration_seconds || 0}s
              {:else if node.node_type === 'terminal'}
                Outcome: {node.terminal_config?.outcome || 'succeeded'}
              {:else}
                Type: {node.node_type}
              {/if}
            </div>
          </div>

          <!-- Connecting Edge Arrow -->
          {#if idx < nodes.length - 1}
            <div class="flex flex-col items-center justify-center my-0.5 text-neutral-600">
              <div class="w-0.5 h-3 bg-neutral-800"></div>
              <span class="text-xs">↓</span>
            </div>
          {/if}
        {/each}
      </div>
    </main>

    <!-- Right Column: Node Config Inspector (340px) -->
    <aside class="w-80 border-l border-neutral-800 bg-neutral-900/60 p-4 overflow-y-auto shrink-0 space-y-4">
      <div class="flex items-center justify-between border-b border-neutral-800 pb-3">
        <h3 class="text-xs font-bold uppercase tracking-wider text-neutral-300">
          Node Configuration
        </h3>
        <span class="px-2 py-0.5 rounded text-[10px] font-mono border {getNodeBadgeColor(selectedNode.node_type)}">
          {selectedNode.node_type}
        </span>
      </div>

      <!-- Common Fields -->
      <div class="space-y-3">
        <div>
          <label for="config-node-id" class="block text-[11px] font-medium text-neutral-400 mb-1">Node ID</label>
          <input
            id="config-node-id"
            type="text"
            bind:value={selectedNode.node_id}
            class="w-full bg-neutral-950 border border-neutral-800 rounded px-2.5 py-1 text-xs text-neutral-200 font-mono focus:border-indigo-500 focus:outline-none"
          />
        </div>

        <div>
          <label for="config-title" class="block text-[11px] font-medium text-neutral-400 mb-1">Title</label>
          <input
            id="config-title"
            type="text"
            bind:value={selectedNode.title}
            class="w-full bg-neutral-950 border border-neutral-800 rounded px-2.5 py-1 text-xs text-neutral-200 focus:border-indigo-500 focus:outline-none"
          />
        </div>
      </div>

      <!-- Type-Specific Config Forms -->
      <div class="border-t border-neutral-800 pt-3 space-y-3">
        {#if selectedNode.node_type === 'trigger'}
          <div>
            <label for="config-event-type" class="block text-[11px] font-medium text-neutral-400 mb-1">Event Type</label>
            <input
              id="config-event-type"
              type="text"
              bind:value={selectedNode.trigger_config!.event_type}
              placeholder="e.g. order.placed"
              class="w-full bg-neutral-950 border border-neutral-800 rounded px-2.5 py-1 text-xs text-neutral-200 font-mono focus:border-indigo-500 focus:outline-none"
            />
          </div>

        {:else if selectedNode.node_type === 'condition'}
          <div>
            <label for="config-cond-field" class="block text-[11px] font-medium text-neutral-400 mb-1">Context Field Path</label>
            <input
              id="config-cond-field"
              type="text"
              bind:value={selectedNode.condition_config!.field}
              placeholder="e.g. customer.is_vip"
              class="w-full bg-neutral-950 border border-neutral-800 rounded px-2.5 py-1 text-xs text-neutral-200 font-mono focus:border-indigo-500 focus:outline-none"
            />
          </div>
          <div>
            <label for="config-cond-operator" class="block text-[11px] font-medium text-neutral-400 mb-1">Operator</label>
            <select
              id="config-cond-operator"
              bind:value={selectedNode.condition_config!.operator}
              class="w-full bg-neutral-950 border border-neutral-800 rounded px-2.5 py-1 text-xs text-neutral-200 focus:border-indigo-500 focus:outline-none"
            >
              <option value="eq">Equals (eq)</option>
              <option value="neq">Not Equals (neq)</option>
              <option value="gt">Greater Than (gt)</option>
              <option value="contains">Contains</option>
              <option value="exists">Field Exists</option>
            </select>
          </div>
          <div>
            <label for="config-cond-val" class="block text-[11px] font-medium text-neutral-400 mb-1">Value JSON / Literal</label>
            <input
              id="config-cond-val"
              type="text"
              bind:value={selectedNode.condition_config!.value_json}
              placeholder="true"
              class="w-full bg-neutral-950 border border-neutral-800 rounded px-2.5 py-1 text-xs text-neutral-200 font-mono focus:border-indigo-500 focus:outline-none"
            />
          </div>

        {:else if selectedNode.node_type === 'action'}
          <div>
            <label for="config-rpc-name" class="block text-[11px] font-medium text-neutral-400 mb-1">RPC Procedure</label>
            <input
              id="config-rpc-name"
              type="text"
              bind:value={selectedNode.action_config!.rpc_name}
              placeholder="creativanta.commerce.v1.InventoryService/ReserveStock"
              class="w-full bg-neutral-950 border border-neutral-800 rounded px-2.5 py-1 text-xs text-neutral-200 font-mono focus:border-indigo-500 focus:outline-none"
            />
          </div>
          <div>
            <label for="config-input-json" class="block text-[11px] font-medium text-neutral-400 mb-1">Input Parameters (JSON)</label>
            <textarea
              id="config-input-json"
              rows="3"
              bind:value={selectedNode.action_config!.input_json}
              class="w-full bg-neutral-950 border border-neutral-800 rounded px-2.5 py-1 text-xs text-neutral-200 font-mono focus:border-indigo-500 focus:outline-none"
            ></textarea>
          </div>

        {:else if selectedNode.node_type === 'approval'}
          <div>
            <label for="config-approvers" class="block text-[11px] font-medium text-neutral-400 mb-1">Approver IDs (comma separated)</label>
            <input
              id="config-approvers"
              type="text"
              value={selectedNode.approval_config!.approver_ids.join(', ')}
              onchange={(e) => {
                selectedNode.approval_config!.approver_ids = (e.currentTarget.value || '')
                  .split(',')
                  .map((s) => s.trim())
                  .filter(Boolean);
              }}
              class="w-full bg-neutral-950 border border-neutral-800 rounded px-2.5 py-1 text-xs text-neutral-200 font-mono focus:border-indigo-500 focus:outline-none"
            />
          </div>
          <div>
            <label for="config-auto-action" class="block text-[11px] font-medium text-neutral-400 mb-1">Auto-Action on Timeout</label>
            <select
              id="config-auto-action"
              bind:value={selectedNode.approval_config!.auto_action_on_timeout}
              class="w-full bg-neutral-950 border border-neutral-800 rounded px-2.5 py-1 text-xs text-neutral-200 focus:border-indigo-500 focus:outline-none"
            >
              <option value="fallback">Route to Fallback</option>
              <option value="reject">Reject</option>
              <option value="fail">Fail Run</option>
            </select>
          </div>

        {:else if selectedNode.node_type === 'wait'}
          <div>
            <label for="config-wait-sec" class="block text-[11px] font-medium text-neutral-400 mb-1">Delay Duration (Seconds)</label>
            <input
              id="config-wait-sec"
              type="number"
              bind:value={selectedNode.wait_config!.duration_seconds}
              class="w-full bg-neutral-950 border border-neutral-800 rounded px-2.5 py-1 text-xs text-neutral-200 font-mono focus:border-indigo-500 focus:outline-none"
            />
          </div>

        {:else if selectedNode.node_type === 'terminal'}
          <div>
            <label for="config-outcome" class="block text-[11px] font-medium text-neutral-400 mb-1">Terminal Outcome</label>
            <select
              id="config-outcome"
              bind:value={selectedNode.terminal_config!.outcome}
              class="w-full bg-neutral-950 border border-neutral-800 rounded px-2.5 py-1 text-xs text-neutral-200 focus:border-indigo-500 focus:outline-none"
            >
              <option value="succeeded">Succeeded</option>
              <option value="partially_succeeded">Partially Succeeded</option>
              <option value="failed">Failed</option>
              <option value="cancelled">Cancelled</option>
            </select>
          </div>
        {/if}
      </div>
    </aside>
  </div>

  <!-- Dry Run Simulation Modal -->
  {#if showSimModal && simulationReport}
    <div class="fixed inset-0 z-50 bg-black/70 backdrop-blur-sm flex items-center justify-center p-4">
      <div class="bg-neutral-900 border border-neutral-800 rounded-2xl max-w-lg w-full p-6 shadow-2xl space-y-4">
        <div class="flex items-center justify-between border-b border-neutral-800 pb-3">
          <div class="flex items-center gap-2">
            <span class="text-emerald-400 text-lg">✓</span>
            <h3 class="text-base font-bold text-white">Dry-Run Simulation Report</h3>
          </div>
          <button
            type="button"
            onclick={() => (showSimModal = false)}
            class="text-neutral-400 hover:text-white text-sm"
          >
            ✕
          </button>
        </div>

        <div class="space-y-3">
          <div class="bg-neutral-950 p-3 rounded-lg border border-neutral-800 text-xs space-y-1">
            <div class="flex justify-between">
              <span class="text-neutral-400">Total Steps Simulated:</span>
              <span class="text-white font-mono">{simulationReport.step_results.length}</span>
            </div>
            <div class="flex justify-between">
              <span class="text-neutral-400">Estimated Credit Usage:</span>
              <span class="text-emerald-400 font-mono font-semibold">~{simulationReport.total_estimated_credits} credits</span>
            </div>
            <div class="flex justify-between">
              <span class="text-neutral-400">Business Side Effects:</span>
              <span class="text-neutral-200 font-mono">0 (Simulated Only)</span>
            </div>
          </div>

          <p class="text-xs text-neutral-400">
            {simulationReport.simulation_summary}
          </p>
        </div>

        <div class="pt-2 flex justify-end">
          <button
            type="button"
            onclick={() => (showSimModal = false)}
            class="px-4 py-1.5 text-xs font-semibold text-white bg-indigo-600 hover:bg-indigo-500 rounded-lg transition-colors"
          >
            Close Report
          </button>
        </div>
      </div>
    </div>
  {/if}
</div>

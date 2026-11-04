<script lang="ts">
  import { onMount } from 'svelte';
  import type { RecipeTemplate, MissingCapabilityExplanation } from '$lib/workflow/recipe';
  import { checkRecipeCapabilities, instantiateRecipeWorkflow } from '$lib/workflow/recipe';

  // Sample catalog of proved automation recipes
  let templates: RecipeTemplate[] = [
    {
      recipe_id: 'rec-001',
      title: 'Auto-respond to purchase inquiries',
      description: 'Detect buyer intent in video comments and auto-reply with personalized offer links.',
      category: 'engagement',
      template_kind: 'workflow',
      template_version: 1,
      template_payload: {
        schema_version: 1,
        license_notice: 'MIT',
        graph: {
          schema_version: 1,
          nodes: [
            { node_id: 'n1', node_type: 'trigger', title: 'Message Received Trigger', config: { type: 'event', event_type: 'message.received' } },
            { node_id: 'n2', node_type: 'condition', title: 'Check Intent Condition', config: { field: 'intent', operator: 'eq', value_json: '"purchase"' } },
            { node_id: 'n3', node_type: 'action', title: 'Send Reply Action', config: { service: 'UnifiedInbox', action: 'SendReply', template: '{{reply_template}}' } },
            { node_id: 'n4', node_type: 'terminal', title: 'Complete Flow', config: {} }
          ],
          edges: [
            { from_node_id: 'n1', to_node_id: 'n2' },
            { from_node_id: 'n2', to_node_id: 'n3', branch: 'true' },
            { from_node_id: 'n3', to_node_id: 'n4' }
          ]
        }
      },
      parameters: [
        { name: 'reply_template', type: 'string', default_value: 'Cảm ơn bạn đã quan tâm! Xem ngay tại: {{store_url}}', required: true, description: 'Mẫu câu trả lời tự động' }
      ],
      required_capabilities: ['tiktok.publish'],
      install_count: 1234,
      rating_avg: 4.8,
      review_count: 89,
      price_usd: '0.000000',
      status: 'published',
      created_at: '2026-10-01T00:00:00Z',
      updated_at: '2026-10-15T00:00:00Z'
    },
    {
      recipe_id: 'rec-002',
      title: 'Daily content pipeline',
      description: 'Check viral trends daily at 10:00, generate 3 scripts, and queue for manager approval.',
      category: 'content',
      template_kind: 'workflow',
      template_version: 1,
      template_payload: {
        schema_version: 1,
        license_notice: 'MIT',
        graph: {
          schema_version: 1,
          nodes: [
            { node_id: 't1', node_type: 'trigger', title: 'Daily Schedule Trigger', config: { type: 'schedule', cron_expression: '0 10 * * *' } },
            { node_id: 't2', node_type: 'action', title: 'Fetch Top Signals', config: { service: 'TrendRadar', action: 'FetchTopSignals' } },
            { node_id: 't3', node_type: 'action', title: 'Batch Generate Scripts', config: { service: 'ScriptLab', action: 'BatchGenerate' } },
            { node_id: 't4', node_type: 'approval', title: 'Manager Approval', config: { approver_role: 'manager' } },
            { node_id: 't5', node_type: 'terminal', title: 'Complete Pipeline', config: {} }
          ],
          edges: [
            { from_node_id: 't1', to_node_id: 't2' },
            { from_node_id: 't2', to_node_id: 't3' },
            { from_node_id: 't3', to_node_id: 't4' },
            { from_node_id: 't4', to_node_id: 't5', branch: 'success' }
          ]
        }
      },
      parameters: [],
      required_capabilities: [],
      install_count: 890,
      rating_avg: 4.6,
      review_count: 56,
      price_usd: '0.000000',
      status: 'published',
      created_at: '2026-09-20T00:00:00Z',
      updated_at: '2026-10-10T00:00:00Z'
    },
    {
      recipe_id: 'rec-003',
      title: 'Order fulfillment & Shopee sync',
      description: 'Synchronize new orders from Shopee, trigger packaging checks, and notify team on Slack.',
      category: 'commerce',
      template_kind: 'workflow',
      template_version: 1,
      template_payload: {
        schema_version: 1,
        license_notice: 'Commercial',
        graph: {
          schema_version: 1,
          nodes: [
            { node_id: 'c1', node_type: 'trigger', title: 'Order Imported Trigger', config: { type: 'event', event_type: 'order.imported' } },
            { node_id: 'c2', node_type: 'action', title: 'Verify Stock', config: { service: 'ProductHub', action: 'VerifyStock' } },
            { node_id: 'c3', node_type: 'action', title: 'Send Alert', config: { service: 'Notification', action: 'SendAlert' } },
            { node_id: 'c4', node_type: 'terminal', title: 'Order Sync Done', config: {} }
          ],
          edges: [
            { from_node_id: 'c1', to_node_id: 'c2' },
            { from_node_id: 'c2', to_node_id: 'c3' },
            { from_node_id: 'c3', to_node_id: 'c4' }
          ]
        }
      },
      parameters: [],
      required_capabilities: ['shopee.order.sync'],
      install_count: 2100,
      rating_avg: 4.9,
      review_count: 120,
      price_usd: '29.000000',
      status: 'published',
      created_at: '2026-08-15T00:00:00Z',
      updated_at: '2026-10-25T00:00:00Z'
    }
  ];

  // Active workspace capability snapshot (Shopee is degraded/not connected for demo testing)
  let workspaceCapabilities: Record<string, string> = {
    'tiktok.publish': 'supported',
    'shopee.order.sync': 'unsupported'
  };

  let selectedCategory = 'all';
  let searchQuery = '';
  let previewTemplate: RecipeTemplate | null = null;
  let deployingRecipeId: string | null = null;
  let deployMessage: string | null = null;

  $: filteredTemplates = templates.filter((t) => {
    const matchesCategory = selectedCategory === 'all' || t.category === selectedCategory;
    const matchesQuery =
      !searchQuery ||
      t.title.toLowerCase().includes(searchQuery.toLowerCase()) ||
      t.description.toLowerCase().includes(searchQuery.toLowerCase());
    return matchesCategory && matchesQuery;
  });

  function getCapabilityCheck(recipe: RecipeTemplate) {
    return checkRecipeCapabilities(recipe, workspaceCapabilities);
  }

  function handleDeploy(template: RecipeTemplate) {
    const check = getCapabilityCheck(template);
    if (!check.eligible) {
      alert(`Không thể cài đặt: ${check.missing[0].reason}\n${check.missing[0].resolution_guidance}`);
      return;
    }

    deployingRecipeId = template.recipe_id;
    deployMessage = `Đang khởi tạo workflow từ template "${template.title}"...`;

    setTimeout(() => {
      const createdWorkflow = instantiateRecipeWorkflow(template, 'ws-demo-123', {});
      deployingRecipeId = null;
      deployMessage = `Đã tạo thành công workflow "${createdWorkflow.title}" (ID: ${createdWorkflow.workflow_id}). Workflow được lưu ở trạng thái Draft và có thể chỉnh sửa tự do.`;
    }, 600);
  }
</script>

<div class="p-6 max-w-7xl mx-auto space-y-6">
  <!-- Header -->
  <div class="flex items-center justify-between border-b pb-4">
    <div class="flex items-center space-x-3">
      <a href="/workflows" class="text-sm text-gray-500 hover:text-gray-900 font-medium">← Quay lại Workflows</a>
      <span class="text-gray-300">|</span>
      <h1 class="text-2xl font-bold text-gray-900 flex items-center gap-2">
        <span>📋</span> Recipe & Workflow Templates
      </h1>
    </div>

    <!-- Search Input -->
    <div class="relative w-80">
      <input
        type="text"
        bind:value={searchQuery}
        placeholder="Tìm kiếm template..."
        class="w-full pl-9 pr-4 py-2 border rounded-lg text-sm focus:ring-2 focus:ring-blue-500 focus:outline-none"
      />
      <span class="absolute left-3 top-2.5 text-gray-400 text-sm">🔍</span>
    </div>
  </div>

  <!-- Deploy Message / Alert -->
  {#if deployMessage}
    <div class="p-4 bg-green-50 border border-green-200 text-green-800 rounded-lg flex items-center justify-between">
      <span>{deployMessage}</span>
      <button on:click={() => (deployMessage = null)} class="text-green-600 hover:text-green-900 font-bold ml-4">✕</button>
    </div>
  {/if}

  <!-- Category Filter Chips -->
  <div class="flex gap-2 border-b pb-3 overflow-x-auto">
    {#each [
      { id: 'all', label: '🔥 Tất cả', count: templates.length },
      { id: 'engagement', label: '💬 Tương tác' },
      { id: 'content', label: '📤 Nội dung' },
      { id: 'commerce', label: '🛍 Thương mại' },
      { id: 'analytics', label: '📊 Phân tích' }
    ] as cat}
      <button
        class="px-4 py-1.5 rounded-full text-sm font-medium transition-colors {selectedCategory === cat.id
          ? 'bg-blue-600 text-white shadow-sm'
          : 'bg-gray-100 text-gray-600 hover:bg-gray-200'}"
        on:click={() => (selectedCategory = cat.id)}
      >
        {cat.label}
      </button>
    {/each}
  </div>

  <!-- Template Cards Grid -->
  <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
    {#each filteredTemplates as tmpl (tmpl.recipe_id)}
      {@const capCheck = getCapabilityCheck(tmpl)}
      <div class="bg-white border rounded-xl shadow-sm hover:shadow-md transition-shadow p-5 flex flex-col justify-between">
        <div class="space-y-3">
          <!-- Top Row: Category, Rating & Price -->
          <div class="flex items-center justify-between text-xs">
            <span class="px-2.5 py-1 rounded bg-blue-50 text-blue-700 font-medium capitalize">
              {tmpl.category}
            </span>
            <div class="flex items-center gap-2">
              <span class="text-amber-500 font-semibold flex items-center gap-1">
                ⭐ {tmpl.rating_avg.toFixed(1)} <span class="text-gray-400 font-normal">({tmpl.review_count})</span>
              </span>
              <span class="px-2 py-0.5 rounded font-mono font-medium {tmpl.price_usd === '0.000000' ? 'bg-green-100 text-green-800' : 'bg-purple-100 text-purple-800'}">
                {tmpl.price_usd === '0.000000' ? 'Miễn phí' : `$${tmpl.price_usd}`}
              </span>
            </div>
          </div>

          <!-- Title & Description -->
          <div>
            <h3 class="text-base font-bold text-gray-900">{tmpl.title}</h3>
            <p class="text-xs text-gray-600 mt-1 line-clamp-2">{tmpl.description}</p>
          </div>

          <!-- Flow Summary -->
          <div class="p-2.5 bg-gray-50 rounded text-xs space-y-1 text-gray-600">
            <div><span class="font-medium text-gray-800">Trigger:</span> {tmpl.template_payload.graph.nodes[0]?.config?.event_type || 'Thủ công / Lịch biểu'}</div>
            <div><span class="font-medium text-gray-800">Số bước:</span> {tmpl.template_payload.graph.nodes.length} bước xử lý</div>
            <div><span class="font-medium text-gray-800">Lượt dùng:</span> {tmpl.install_count.toLocaleString()} workspaces</div>
          </div>

          <!-- Missing Capability Warning Banner -->
          {#if !capCheck.eligible}
            <div class="p-2.5 bg-amber-50 border border-amber-200 rounded text-xs text-amber-800 space-y-1">
              <div class="font-semibold flex items-center gap-1">
                <span>⚠️</span> Thiếu kết nối platform
              </div>
              <div>{capCheck.missing[0].reason}</div>
              <a href={capCheck.missing[0].connect_url} class="inline-block text-blue-600 hover:underline font-medium pt-1">
                → {capCheck.missing[0].resolution_guidance}
              </a>
            </div>
          {/if}
        </div>

        <!-- Action Bar -->
        <div class="flex items-center gap-2 pt-4 mt-4 border-t">
          <button
            on:click={() => (previewTemplate = tmpl)}
            class="flex-1 px-3 py-2 border rounded-lg text-xs font-medium text-gray-700 hover:bg-gray-50"
          >
            ▶ Xem trước flow
          </button>
          <button
            on:click={() => handleDeploy(tmpl)}
            disabled={!capCheck.eligible || deployingRecipeId === tmpl.recipe_id}
            class="flex-1 px-3 py-2 rounded-lg text-xs font-medium text-white transition-colors {capCheck.eligible
              ? 'bg-blue-600 hover:bg-blue-700 shadow-sm'
              : 'bg-gray-300 cursor-not-allowed text-gray-500'}"
          >
            {#if deployingRecipeId === tmpl.recipe_id}
              Đang tạo...
            {:else}
              📥 Dùng template
            {/if}
          </button>
        </div>
      </div>
    {/each}
  </div>

  <!-- Read-only Preview Modal -->
  {#if previewTemplate}
    <div class="fixed inset-0 bg-black/50 z-50 flex items-center justify-center p-4">
      <div class="bg-white rounded-xl max-w-2xl w-full p-6 space-y-4 max-h-[90vh] overflow-y-auto">
        <div class="flex items-center justify-between border-b pb-3">
          <div>
            <h2 class="text-lg font-bold text-gray-900">{previewTemplate.title}</h2>
            <p class="text-xs text-gray-500">Xem trước đồ thị các bước tự động hóa (Read-only)</p>
          </div>
          <button on:click={() => (previewTemplate = null)} class="text-gray-400 hover:text-gray-600 text-lg">✕</button>
        </div>

        <div class="space-y-3">
          <h4 class="text-xs font-semibold text-gray-500 uppercase tracking-wide">Các bước thực thi (Canonical Nodes)</h4>
          <div class="space-y-2">
            {#each previewTemplate.template_payload.graph.nodes as node, idx}
              <div class="flex items-center gap-3 p-3 bg-gray-50 rounded-lg border text-sm">
                <span class="w-6 h-6 rounded-full bg-blue-100 text-blue-700 font-bold flex items-center justify-center text-xs">
                  {idx + 1}
                </span>
                <div>
                  <div class="font-medium text-gray-800 capitalize">{node.node_type}: {node.node_id}</div>
                  <div class="text-xs text-gray-500">{JSON.stringify(node.config)}</div>
                </div>
              </div>
            {/each}
          </div>
        </div>

        <div class="flex justify-end gap-3 pt-4 border-t">
          <button on:click={() => (previewTemplate = null)} class="px-4 py-2 border rounded-lg text-sm text-gray-700">
            Đóng
          </button>
          <button
            on:click={() => {
              const tmpl = previewTemplate;
              previewTemplate = null;
              if (tmpl) handleDeploy(tmpl);
            }}
            class="px-4 py-2 bg-blue-600 text-white rounded-lg text-sm font-medium hover:bg-blue-700"
          >
            📥 Dùng template này
          </button>
        </div>
      </div>
    </div>
  {/if}
</div>

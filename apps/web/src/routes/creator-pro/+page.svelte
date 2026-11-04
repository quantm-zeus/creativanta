<script lang="ts">
  import {
    validateDealTransition,
    evaluateLinkThreat,
    canPublishBioPage,
    computeRPM,
    checkRPMDropAlert,
    isToolEntitledForMode,
    MAX_DAILY_LINKS_PER_WORKSPACE,
    organizeDealsIntoKanban,
    validateOptimisticKanbanMove,
    attachContractToDeal,
    STANDARD_CONTRACT_TEMPLATES,
    type BrandDeal,
    type BrandDealStatus,
    type LinkInBioPage,
    type LinkItem,
    type WorkspaceMode,
    type CreatorProTool,
    type ContractTemplate
  } from '$lib/commerce';

  const workspaceId = 'ws-creator-01';

  const ALL_OPERATOR_MODES: readonly WorkspaceMode[] = [
    'creator',
    'seller',
    'agency',
    'affiliate',
    'brand_collab',
    'live_operator'
  ];

  const CREATOR_PRO_TOOLS: readonly CreatorProTool[] = [
    'bio_pages',
    'media_kits',
    'rate_cards',
    'brand_deals',
    'content_roi',
    'tax_reports'
  ];

  // Mode and Entitlements State
  let currentMode = $state<WorkspaceMode>('creator');

  // Deal Lifecycle State
  let deals = $state<BrandDeal[]>([
    {
      dealId: 'deal-nike-spring',
      workspaceId,
      brandName: 'Nike Running',
      dealType: 'sponsored_post',
      value: 15000000,
      currency: 'VND',
      status: 'in_progress',
      deliverables: 'Spring Marathon 3x Short Series',
      contractEvidenceIds: ['ev-001'],
      notes: 'Deliverable 1 of 3 finished',
      createdAt: '2026-11-01T00:00:00Z',
      updatedAt: '2026-11-04T00:00:00Z'
    },
    {
      dealId: 'deal-unilever-shampoo',
      workspaceId,
      brandName: 'Unilever Haircare',
      dealType: 'brand_ambassador',
      value: 8500000,
      currency: 'VND',
      status: 'negotiating',
      deliverables: 'Anti-Dandruff Reel Placement',
      contractEvidenceIds: [],
      notes: 'Initial terms review',
      createdAt: '2026-11-03T00:00:00Z',
      updatedAt: '2026-11-03T00:00:00Z'
    },
    {
      dealId: 'deal-samsung-galaxy',
      workspaceId,
      brandName: 'Samsung Mobile',
      dealType: 'ugc_creation',
      value: 35000000,
      currency: 'VND',
      status: 'paid',
      deliverables: 'Fold 6 Unboxing & First Look',
      contractEvidenceIds: ['ev-002'],
      financialReversalLogged: false,
      notes: 'Payment confirmed, waiting final review',
      createdAt: '2026-10-25T00:00:00Z',
      updatedAt: '2026-11-02T00:00:00Z'
    }
  ]);

  let transitionError = $state<string | null>(null);
  let cancelReason = $state<string>('');
  let financialReversalConfirmed = $state<boolean>(false);

  function advanceDeal(deal: BrandDeal, nextStatus: BrandDealStatus) {
    transitionError = null;
    const validation = validateDealTransition(deal.status, nextStatus, {
      cancellationReason: cancelReason,
      financialReversalConfirmed
    });
    if (!validation.valid) {
      transitionError = validation.error ?? 'Invalid state transition';
      return;
    }
    deal.status = nextStatus;
    deal.updatedAt = new Date().toISOString();
    if (nextStatus === 'cancelled') {
      deal.cancellationReason = cancelReason;
      if (deal.status === 'paid' || financialReversalConfirmed) {
        deal.financialReversalLogged = true;
      }
    }
    deals = [...deals];
  }

  // P8-07: Deal Kanban & Contract Templates State
  let dealViewTab = $state<'kanban' | 'list'>('kanban');
  let kanbanColumns = $derived(organizeDealsIntoKanban(deals));
  let selectedDealForContract = $state<BrandDeal | null>(null);
  let selectedTemplate = $state<ContractTemplate | null>(STANDARD_CONTRACT_TEMPLATES[0]);
  let contractAttachSuccess = $state<string | null>(null);
  let contractAttachError = $state<string | null>(null);

  function moveDealOnKanban(deal: BrandDeal, targetStatus: BrandDealStatus) {
    transitionError = null;
    // Acceptance Target: Optimistic CAS check (verifying deal was not concurrently altered)
    const check = validateOptimisticKanbanMove(deal, deal.updatedAt, targetStatus);
    if (!check.valid) {
      transitionError = check.error ?? 'Lỗi cập nhật trạng thái Kanban';
      return;
    }
    deal.status = targetStatus;
    deal.updatedAt = new Date().toISOString();
    deals = [...deals];
  }

  function handleAttachContractTemplate(deal: BrandDeal, template: ContractTemplate) {
    contractAttachSuccess = null;
    contractAttachError = null;
    // Generate versioned evidence snapshot identifier
    const evidenceId = `ev-${template.templateId}-v${template.version}-${Date.now().toString(36)}`;
    const result = attachContractToDeal(deal, evidenceId);
    if (!result.success || !result.deal) {
      contractAttachError = result.error ?? 'Gắn mẫu hợp đồng thất bại';
      return;
    }
    // Update local state with the new append-only deal
    deals = deals.map((d) => (d.dealId === deal.dealId ? result.deal! : d));
    contractAttachSuccess = `Đã đính kèm phiên bản hợp đồng v${template.version} (${evidenceId}) thành công. Bằng chứng là bất biến!`;
  }

  // Security & Link Scanner State
  let testUrl = $state<string>('https://google-login-verify-account.phish.cc/auth');
  let aupAcknowledged = $state<boolean>(false);
  let scanThreat = $state<{
    scanStatus: string;
    phishingDetected: boolean;
    blockedFromPublishing: boolean;
    threatDetails: string;
  } | null>(null);
  let publishBlockMessage = $state<string | null>(null);
  let linkCreationCountToday = $state<number>(18);
  let throttleWarning = $state<string | null>(null);

  function handleScanLink() {
    scanThreat = evaluateLinkThreat(testUrl);
    const mockPage: LinkInBioPage = {
      pageId: 'page-01',
      workspaceId,
      slug: 'creator-official',
      title: 'Official Creator Links',
      bio: 'Fashion & Tech content creator',
      theme: 'clean-dark',
      customDomainVerified: false,
      analyticsEnabled: true,
      totalViews: 4500,
      status: 'draft',
      createdAt: new Date().toISOString(),
      updatedAt: new Date().toISOString()
    };
    const mockItem: LinkItem = {
      linkItemId: 'link-item-test',
      pageId: 'page-01',
      workspaceId,
      linkType: 'custom',
      title: 'Partner Link',
      url: testUrl,
      position: 0,
      isActive: true,
      isPinned: false,
      clickCount: 0,
      scanStatus: scanThreat.scanStatus as any,
      phishingDetected: scanThreat.phishingDetected,
      scanThreatDetails: scanThreat.threatDetails,
      createdAt: new Date().toISOString(),
      updatedAt: new Date().toISOString()
    };

    const pub = canPublishBioPage(mockPage, [mockItem], aupAcknowledged);
    if (!pub.allowed) {
      publishBlockMessage = pub.reason ?? 'Blocked by security scan';
    } else {
      publishBlockMessage = null;
    }
  }

  function handleAddLinkAttempt() {
    if (linkCreationCountToday >= MAX_DAILY_LINKS_PER_WORKSPACE) {
      throttleWarning = `Daily link creation limit reached (${MAX_DAILY_LINKS_PER_WORKSPACE} links/day). Mass link generation throttled to prevent spam and abuse.`;
    } else {
      linkCreationCountToday++;
      throttleWarning = null;
    }
  }

  // RPM Calculator & Alert State
  let sampleViews = $state<number>(0);
  let sampleRevenue = $state<number>(5000000); // 5,000,000 VND
  let rpmResult = $derived(computeRPM(sampleViews, sampleRevenue));

  let prevRpmVal = $state<number>(25000);
  let currentRpmVal = $state<number>(18000);
  let rpmDropAlert = $derived(
    checkRPMDropAlert(
      { rpm: prevRpmVal, isUndefined: false },
      { rpm: currentRpmVal, isUndefined: false },
      20.0
    )
  );
</script>

<div class="p-6 max-w-7xl mx-auto space-y-8 font-sans">
  <!-- Header -->
  <div class="flex flex-col md:flex-row md:items-center md:justify-between border-b border-gray-200 pb-5 gap-4">
    <div>
      <h1 class="text-3xl font-bold tracking-tight text-gray-900 flex items-center gap-2">
        <span class="text-amber-500">🌟</span> Creator Pro Dashboard (W088)
      </h1>
      <p class="text-sm text-gray-500 mt-1">
        Command center for brand deals, rate cards, media kits, link-in-bio security and tax reporting.
      </p>
    </div>

    <!-- Six Operator Modes Selector -->
    <div class="flex items-center gap-2 bg-gray-100 p-1.5 rounded-lg border border-gray-200">
      <span class="text-xs font-semibold text-gray-600 px-2">Mode:</span>
      <select
        bind:value={currentMode}
        class="text-sm bg-white border border-gray-300 rounded px-2.5 py-1 text-gray-800 font-medium focus:ring-2 focus:ring-amber-500 focus:outline-none"
      >
        {#each ALL_OPERATOR_MODES as mode}
          <option value={mode}>{mode}</option>
        {/each}
      </select>
    </div>
  </div>

  <!-- KPI Row -->
  <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4">
    <div class="bg-white p-5 rounded-xl border border-gray-200 shadow-sm">
      <div class="text-xs font-semibold uppercase tracking-wider text-gray-500">Average Engagement</div>
      <div class="text-2xl font-bold text-gray-900 mt-1">6.2%</div>
      <div class="text-xs text-emerald-600 font-medium mt-1">↑ 0.5% vs previous 30d</div>
    </div>
    <div class="bg-white p-5 rounded-xl border border-gray-200 shadow-sm">
      <div class="text-xs font-semibold uppercase tracking-wider text-gray-500">Total Reach (30d)</div>
      <div class="text-2xl font-bold text-gray-900 mt-1">1.2M</div>
      <div class="text-xs text-emerald-600 font-medium mt-1">↑ 18% audience growth</div>
    </div>
    <div class="bg-white p-5 rounded-xl border border-gray-200 shadow-sm">
      <div class="text-xs font-semibold uppercase tracking-wider text-gray-500">Sponsorship Revenue</div>
      <div class="text-2xl font-bold text-gray-900 mt-1">58.5M VND</div>
      <div class="text-xs text-emerald-600 font-medium mt-1">↑ 35% completed deals</div>
    </div>
    <div class="bg-white p-5 rounded-xl border border-gray-200 shadow-sm">
      <div class="text-xs font-semibold uppercase tracking-wider text-gray-500">Creator Rating</div>
      <div class="text-2xl font-bold text-gray-900 mt-1">4.8 / 5.0</div>
      <div class="text-xs text-gray-500 font-medium mt-1">12 verified brand reviews</div>
    </div>
  </div>

  <!-- Mode Entitlement Bar -->
  <div class="bg-slate-50 border border-slate-200 rounded-xl p-4 flex flex-wrap items-center justify-between gap-3">
    <div class="flex items-center gap-2">
      <span class="text-xs font-bold uppercase tracking-wider text-slate-700">Entitled Tools for Mode [{currentMode}]:</span>
    </div>
    <div class="flex flex-wrap gap-2">
      {#each CREATOR_PRO_TOOLS as tool}
        {@const entitled = isToolEntitledForMode(currentMode, tool)}
        <span
          class="px-2.5 py-1 text-xs rounded-md font-medium border transition-colors {entitled
            ? 'bg-emerald-50 text-emerald-700 border-emerald-300'
            : 'bg-gray-100 text-gray-400 border-gray-200 line-through'}"
        >
          {tool}
        </span>
      {/each}
    </div>
  </div>

  <!-- Grid of Acceptance Targets -->
  <div class="grid grid-cols-1 lg:grid-cols-2 gap-6">
  <!-- P8-07 Deliverable: Deal Kanban Board & Contract Templates -->
  <div class="bg-white border border-gray-200 rounded-xl p-6 shadow-sm space-y-5">
    <div class="flex flex-col sm:flex-row sm:items-center justify-between pb-3 border-b border-gray-200 gap-3">
      <div>
        <h2 class="text-xl font-bold text-gray-900 flex items-center gap-2">
          <span>📋</span> Brand Deal Kanban & Hợp đồng Mẫu (P8-07)
        </h2>
        <p class="text-xs text-gray-500 mt-0.5">
          Quy trình quản lý tài trợ theo cột Kanban với kiểm tra xung đột đồng thời (CAS optimistic check) và hợp đồng phiên bản bất biến.
        </p>
      </div>

      <!-- View Selector -->
      <div class="flex items-center gap-1 bg-gray-100 p-1 rounded-lg">
        <button
          type="button"
          onclick={() => (dealViewTab = 'kanban')}
          class="px-3 py-1 text-xs font-semibold rounded-md transition {dealViewTab === 'kanban' ? 'bg-white text-gray-900 shadow-sm' : 'text-gray-600 hover:text-gray-900'}"
        >
          Bảng Kanban
        </button>
        <button
          type="button"
          onclick={() => (dealViewTab = 'list')}
          class="px-3 py-1 text-xs font-semibold rounded-md transition {dealViewTab === 'list' ? 'bg-white text-gray-900 shadow-sm' : 'text-gray-600 hover:text-gray-900'}"
        >
          Danh sách chi tiết
        </button>
      </div>
    </div>

    {#if transitionError}
      <div class="p-3 bg-rose-50 border border-rose-200 rounded-lg text-rose-700 text-xs font-medium flex items-center justify-between">
        <span>⚠️ Lỗi cập nhật trạng thái: {transitionError}</span>
        <button type="button" onclick={() => (transitionError = null)} class="text-rose-500 hover:text-rose-700 text-xs">✕</button>
      </div>
    {/if}

    {#if contractAttachSuccess}
      <div class="p-3 bg-emerald-50 border border-emerald-200 rounded-lg text-emerald-800 text-xs font-medium flex items-center justify-between">
        <span>✓ {contractAttachSuccess}</span>
        <button type="button" onclick={() => (contractAttachSuccess = null)} class="text-emerald-600 hover:text-emerald-800 text-xs">✕</button>
      </div>
    {/if}

    {#if contractAttachError}
      <div class="p-3 bg-rose-50 border border-rose-200 rounded-lg text-rose-700 text-xs font-medium flex items-center justify-between">
        <span>⚠️ Lỗi hợp đồng: {contractAttachError}</span>
        <button type="button" onclick={() => (contractAttachError = null)} class="text-rose-500 hover:text-rose-700 text-xs">✕</button>
      </div>
    {/if}

    {#if dealViewTab === 'kanban'}
      <!-- Kanban Columns Grid -->
      <div class="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-6 gap-3 overflow-x-auto pb-2">
        {#each kanbanColumns as col}
          <div class="bg-slate-50 border border-slate-200 rounded-xl p-3 flex flex-col justify-between min-h-[360px]">
            <div>
              <div class="flex items-center justify-between pb-2 border-b border-slate-200">
                <span class="text-xs font-bold text-slate-800 uppercase tracking-wider">{col.title.split(' ')[0]}</span>
                <span class="px-1.5 py-0.5 text-[10px] font-bold rounded-full bg-slate-200 text-slate-700">
                  {col.deals.length}
                </span>
              </div>

              <!-- Deal Cards in this column -->
              <div class="space-y-2 mt-2.5">
                {#if col.deals.length === 0}
                  <div class="p-4 text-center text-slate-400 text-[11px] italic">
                    Trống
                  </div>
                {:else}
                  {#each col.deals as deal (deal.dealId)}
                    <div class="p-3 bg-white border border-slate-200 rounded-lg shadow-xs hover:shadow-sm space-y-2 transition">
                      <div class="flex items-start justify-between gap-1">
                        <div class="font-bold text-xs text-slate-900 line-clamp-1">{deal.brandName}</div>
                        <span class="text-[9px] px-1.5 py-0.5 rounded font-mono bg-amber-50 text-amber-800">
                          {deal.dealType.split('_')[0]}
                        </span>
                      </div>
                      <div class="text-[11px] text-slate-500 font-semibold">
                        {(deal.value / 1000000).toLocaleString('vi-VN')}M {deal.currency}
                      </div>
                      <div class="text-[10px] text-slate-600 line-clamp-2">
                        {deal.deliverables || 'Chưa có mô tả'}
                      </div>

                      <!-- Attached contract evidence badges (Immutable versions) -->
                      {#if deal.contractEvidenceIds.length > 0}
                        <div class="pt-1 flex flex-wrap gap-1">
                          {#each deal.contractEvidenceIds as evId}
                            <span class="px-1.5 py-0.5 rounded text-[9px] font-mono bg-emerald-50 text-emerald-700 border border-emerald-200" title="Bằng chứng hợp đồng bất biến">
                              📄 {evId.slice(0, 10)}...
                            </span>
                          {/each}
                        </div>
                      {/if}

                      <!-- Quick Action Controls -->
                      <div class="pt-2 border-t border-slate-100 flex items-center justify-between text-[11px]">
                        {#if deal.status === 'negotiating'}
                          <button
                            type="button"
                            onclick={() => moveDealOnKanban(deal, 'agreed')}
                            class="text-indigo-600 hover:text-indigo-800 font-semibold"
                          >
                            Đồng ý →
                          </button>
                        {:else if deal.status === 'agreed'}
                          <button
                            type="button"
                            onclick={() => moveDealOnKanban(deal, 'in_progress')}
                            class="text-blue-600 hover:text-blue-800 font-semibold"
                          >
                            Triển khai →
                          </button>
                        {:else if deal.status === 'in_progress'}
                          <button
                            type="button"
                            onclick={() => moveDealOnKanban(deal, 'delivered')}
                            class="text-purple-600 hover:text-purple-800 font-semibold"
                          >
                            Bàn giao →
                          </button>
                        {:else if deal.status === 'delivered'}
                          <button
                            type="button"
                            onclick={() => moveDealOnKanban(deal, 'paid')}
                            class="text-amber-600 hover:text-amber-800 font-semibold"
                          >
                            Đã nhận tiền →
                          </button>
                        {:else if deal.status === 'paid'}
                          <button
                            type="button"
                            onclick={() => moveDealOnKanban(deal, 'completed')}
                            class="text-emerald-600 hover:text-emerald-800 font-semibold"
                          >
                            Hoàn tất ✓
                          </button>
                        {:else if deal.status === 'completed'}
                          <span class="text-[10px] text-emerald-600 font-bold">✓ Hoàn tất</span>
                        {/if}

                        <button
                          type="button"
                          onclick={() => (selectedDealForContract = deal)}
                          class="text-slate-400 hover:text-slate-700"
                          title="Gắn hợp đồng mẫu"
                        >
                          + Hợp đồng
                        </button>
                      </div>
                    </div>
                  {/each}
                {/if}
              </div>
            </div>
          </div>
        {/each}
      </div>
    {:else}
      <!-- Classic List View -->
      <div class="space-y-3">
        {#each deals as deal}
          <div class="p-4 bg-gray-50 border border-gray-200 rounded-lg space-y-2">
            <div class="flex items-center justify-between">
              <div>
                <div class="font-semibold text-gray-900 text-sm">{deal.brandName}</div>
                <div class="text-xs text-gray-600">{deal.deliverables}</div>
              </div>
              <span class="px-2.5 py-0.5 rounded-full text-xs font-bold uppercase bg-blue-100 text-blue-800">
                {deal.status}
              </span>
            </div>

            <div class="text-xs text-gray-500 flex items-center justify-between">
              <span>Giá trị: {deal.value.toLocaleString()} {deal.currency}</span>
              <span>Phiên bản: {deal.updatedAt}</span>
            </div>

            <!-- Lifecycle Actions -->
            <div class="flex flex-wrap items-center gap-2 pt-2 border-t border-gray-200">
              {#if deal.status === 'negotiating'}
                <button
                  type="button"
                  onclick={() => advanceDeal(deal, 'agreed')}
                  class="px-2.5 py-1 text-xs font-medium bg-indigo-600 hover:bg-indigo-700 text-white rounded"
                >
                  Agree Terms →
                </button>
              {:else if deal.status === 'agreed'}
                <button
                  type="button"
                  onclick={() => advanceDeal(deal, 'in_progress')}
                  class="px-2.5 py-1 text-xs font-medium bg-blue-600 hover:bg-blue-700 text-white rounded"
                >
                  Start Production →
                </button>
              {:else if deal.status === 'in_progress'}
                <button
                  type="button"
                  onclick={() => advanceDeal(deal, 'delivered')}
                  class="px-2.5 py-1 text-xs font-medium bg-purple-600 hover:bg-purple-700 text-white rounded"
                >
                  Mark Delivered →
                </button>
              {:else if deal.status === 'delivered'}
                <button
                  type="button"
                  onclick={() => advanceDeal(deal, 'paid')}
                  class="px-2.5 py-1 text-xs font-medium bg-amber-600 hover:bg-amber-700 text-white rounded"
                >
                  Confirm Paid →
                </button>
              {:else if deal.status === 'paid'}
                <button
                  type="button"
                  onclick={() => advanceDeal(deal, 'completed')}
                  class="px-2.5 py-1 text-xs font-medium bg-emerald-600 hover:bg-emerald-700 text-white rounded"
                >
                  Complete Deal ✓
                </button>
              {:else if deal.status === 'completed'}
                <span class="text-xs text-emerald-700 font-bold">✓ Deal Fully Completed (Terminal)</span>
              {:else if deal.status === 'cancelled'}
                <span class="text-xs text-rose-700 font-bold">
                  ✗ Cancelled ({deal.cancellationReason || 'No reason'})
                  {#if deal.financialReversalLogged}
                    · [Financial Reversal Logged]
                  {/if}
                </span>
              {/if}

              {#if deal.status !== 'completed' && deal.status !== 'cancelled'}
                <button
                  type="button"
                  onclick={() => {
                    if (!cancelReason) cancelReason = 'Brand client terminated partnership';
                    if (deal.status === 'paid') financialReversalConfirmed = true;
                    advanceDeal(deal, 'cancelled');
                  }}
                  class="px-2 py-1 text-xs font-medium text-rose-600 hover:bg-rose-50 rounded border border-rose-200"
                >
                  Cancel Deal
                </button>
              {/if}
            </div>
          </div>
        {/each}
      </div>
    {/if}

    <!-- Contract Template Attachment Modal/Drawer -->
    {#if selectedDealForContract}
      <div class="p-4 bg-slate-100 rounded-xl border border-slate-300 space-y-3">
        <div class="flex items-center justify-between border-b border-slate-200 pb-2">
          <div class="text-xs font-bold text-slate-800">
            Đính kèm Mẫu Hợp Đồng cho "{selectedDealForContract.brandName}" (Target 4: Bản ghi bất biến)
          </div>
          <button
            type="button"
            onclick={() => (selectedDealForContract = null)}
            class="text-xs text-slate-500 hover:text-slate-800"
          >
            ✕ Đóng
          </button>
        </div>

        <div class="grid grid-cols-1 sm:grid-cols-2 gap-3">
          <div>
            <label for="template-select" class="block text-[11px] font-semibold text-slate-600 mb-1">Chọn Mẫu Hợp Đồng Chuẩn:</label>
            <select
              id="template-select"
              bind:value={selectedTemplate}
              class="w-full text-xs bg-white border border-slate-300 rounded p-1.5 focus:outline-none focus:ring-1 focus:ring-amber-500"
            >
              {#each STANDARD_CONTRACT_TEMPLATES as tmpl}
                <option value={tmpl}>{tmpl.title} (v{tmpl.version})</option>
              {/each}
            </select>
            {#if selectedTemplate}
              <div class="mt-2 text-[10px] text-slate-500 italic bg-white p-2 rounded border border-slate-200">
                {selectedTemplate.disclaimer}
              </div>
            {/if}
          </div>

          <div>
            <div class="block text-[11px] font-semibold text-slate-600 mb-1">Quy tắc Phiên bản Bất biến (Immutability):</div>
            <p class="text-[11px] text-slate-600 bg-white p-2 rounded border border-slate-200">
              Mỗi hợp đồng đính kèm sẽ được lưu vào danh sách bằng chứng (evidence IDs) theo cơ chế chỉ ghi thêm (append-only). Các phiên bản cũ không thể bị ghi đè hoặc chỉnh sửa nhằm đảm bảo tính toàn vẹn pháp lý.
            </p>
            <div class="mt-2 flex justify-end">
              <button
                type="button"
                onclick={() => {
                  if (selectedDealForContract && selectedTemplate) {
                    handleAttachContractTemplate(selectedDealForContract, selectedTemplate);
                    selectedDealForContract = null;
                  }
                }}
                class="px-3 py-1.5 text-xs font-bold rounded bg-amber-500 hover:bg-amber-600 text-white transition"
              >
                Xác nhận Đính kèm Phiên bản
              </button>
            </div>
          </div>
        </div>
      </div>
    {/if}
  </div>

    <!-- Acceptance Target 2: Phishing Security & Anti-Spam Throttle -->
    <div class="bg-white border border-gray-200 rounded-xl p-6 shadow-sm space-y-4">
      <div class="flex items-center justify-between border-b pb-3">
        <h2 class="text-lg font-bold text-gray-900 flex items-center gap-2">
          <span>🛡️</span> Target 2: Phishing Protection & Throttle
        </h2>
        <span class="text-xs bg-red-100 text-red-800 font-semibold px-2 py-0.5 rounded">
          Non-Bypassable
        </span>
      </div>

      <div class="space-y-3">
        <div>
          <label for="test-url-input" class="block text-xs font-semibold text-gray-700 mb-1">Destination URL to Test:</label>
          <input
            id="test-url-input"
            type="text"
            bind:value={testUrl}
            class="w-full text-xs font-mono border border-gray-300 rounded-lg p-2 focus:ring-2 focus:ring-amber-500 focus:outline-none"
          />
        </div>

        <div class="flex items-center gap-2">
          <input
            type="checkbox"
            id="aupCheck"
            bind:checked={aupAcknowledged}
            class="rounded border-gray-300 text-amber-600 focus:ring-amber-500"
          />
          <label for="aupCheck" class="text-xs text-gray-700">
            AUP Acknowledgment (Check if user tries to bypass block)
          </label>
        </div>

        <button
          onclick={handleScanLink}
          class="w-full py-2 bg-slate-800 hover:bg-slate-900 text-white font-medium text-xs rounded-lg transition-colors"
        >
          Scan URL for Phishing & Attempt Publish
        </button>

        {#if scanThreat}
          <div class="p-3 bg-gray-50 border rounded-lg space-y-1 text-xs">
            <div class="flex items-center justify-between">
              <span class="font-bold text-gray-700">Scan Status:</span>
              <span class="px-2 py-0.5 rounded font-mono font-bold {scanThreat.phishingDetected ? 'bg-red-100 text-red-700' : 'bg-green-100 text-green-700'}">
                {scanThreat.scanStatus}
              </span>
            </div>
            <p class="text-gray-600">{scanThreat.threatDetails}</p>
          </div>
        {/if}

        {#if publishBlockMessage}
          <div class="p-3 bg-red-50 border border-red-200 rounded-lg text-red-700 text-xs font-semibold">
            🚨 Security Enforcement: {publishBlockMessage}
          </div>
        {/if}

        <!-- Anti-Spam Throttle Guard -->
        <div class="pt-3 border-t border-gray-200 space-y-2">
          <div class="flex items-center justify-between text-xs">
            <span class="font-medium text-gray-700">Daily Links Created Today:</span>
            <span class="font-bold {linkCreationCountToday >= MAX_DAILY_LINKS_PER_WORKSPACE ? 'text-rose-600' : 'text-gray-900'}">
              {linkCreationCountToday} / {MAX_DAILY_LINKS_PER_WORKSPACE} max
            </span>
          </div>

          <button
            onclick={handleAddLinkAttempt}
            class="w-full py-1.5 bg-gray-100 hover:bg-gray-200 border border-gray-300 text-gray-800 font-medium text-xs rounded transition-colors"
          >
            Attempt Add New Link (Throttle Guard)
          </button>

          {#if throttleWarning}
            <div class="p-2.5 bg-amber-50 border border-amber-200 rounded text-amber-800 text-xs font-medium">
              ⚠️ {throttleWarning}
            </div>
          {/if}
        </div>
      </div>
    </div>

    <!-- Acceptance Target 3: Zero-View RPM Undefined & Drop Alert -->
    <div class="bg-white border border-gray-200 rounded-xl p-6 shadow-sm space-y-4">
      <div class="flex items-center justify-between border-b pb-3">
        <h2 class="text-lg font-bold text-gray-900 flex items-center gap-2">
          <span>📊</span> Target 3: Content ROI & RPM Undefined Rule
        </h2>
        <span class="text-xs bg-blue-100 text-blue-800 font-semibold px-2 py-0.5 rounded">
          S16 §4.2 Strict
        </span>
      </div>

      <div class="space-y-3">
        <div class="grid grid-cols-2 gap-3">
          <div>
            <label for="sample-views-input" class="block text-xs font-semibold text-gray-700 mb-1">Views:</label>
            <input
              id="sample-views-input"
              type="number"
              bind:value={sampleViews}
              min="0"
              class="w-full text-xs border border-gray-300 rounded p-1.5 font-mono"
            />
          </div>
          <div>
            <span class="block text-xs font-semibold text-gray-700 mb-1">Sample Revenue:</span>
            <div class="text-xs font-mono p-1.5 bg-gray-100 rounded text-gray-800">
              {sampleRevenue.toLocaleString()} VND
            </div>
          </div>
        </div>

        <div class="p-3 bg-gray-50 border rounded-lg space-y-1">
          <div class="text-xs font-bold text-gray-700">Calculated RPM:</div>
          {#if rpmResult.rpmIsUndefined}
            <div class="text-sm font-bold text-amber-600 flex items-center gap-1">
              <span>⚠️</span> RPM is strictly UNDEFINED (Views == 0)
            </div>
            <p class="text-xs text-gray-500">
              Per S16 §4.2, RPM with 0 views is undefined, never defaulted to 0.00.
            </p>
          {:else}
            <div class="text-xl font-bold text-gray-900 font-mono">
              {rpmResult.formatted}
            </div>
            <p class="text-xs text-gray-500">RPM per 1,000 views computed accurately.</p>
          {/if}
        </div>

        <!-- RPM Drop Alert (>20%) -->
        <div class="pt-3 border-t border-gray-200 space-y-2">
          <div class="text-xs font-bold text-gray-700">RPM Drop Alert Monitor (>20% drop):</div>
          <div class="grid grid-cols-2 gap-2 text-xs">
            <div>
              <label for="prev-rpm-input" class="text-gray-500 block mb-0.5">Previous RPM:</label>
              <input
                id="prev-rpm-input"
                type="number"
                bind:value={prevRpmVal}
                class="w-full border rounded p-1 font-mono text-xs"
              />
            </div>
            <div>
              <label for="current-rpm-input" class="text-gray-500 block mb-0.5">Current RPM:</label>
              <input
                id="current-rpm-input"
                type="number"
                bind:value={currentRpmVal}
                class="w-full border rounded p-1 font-mono text-xs"
              />
            </div>
          </div>

          {#if rpmDropAlert.alertTriggered}
            <div class="p-2.5 bg-rose-50 border border-rose-200 rounded text-rose-800 text-xs font-medium">
              🚨 Alert Triggered: Significant RPM drop detected ({rpmDropAlert.changePercent}%)
            </div>
          {:else}
            <div class="p-2.5 bg-emerald-50 border border-emerald-200 rounded text-emerald-800 text-xs font-medium">
              ✓ RPM Health Normal (Change: {rpmDropAlert.changePercent}%)
            </div>
          {/if}
        </div>
      </div>
    </div>

    <!-- Media Kit & Rate Card Fast Actions -->
    <div class="bg-white border border-gray-200 rounded-xl p-6 shadow-sm space-y-4">
      <div class="flex items-center justify-between border-b pb-3">
        <h2 class="text-lg font-bold text-gray-900 flex items-center gap-2">
          <span>📋</span> Media Kit & Rate Card Tools
        </h2>
        <span class="text-xs bg-purple-100 text-purple-800 font-semibold px-2 py-0.5 rounded">
          Published & Verified
        </span>
      </div>

      <div class="space-y-3">
        <div class="p-4 bg-gradient-to-r from-purple-50 to-indigo-50 border border-purple-200 rounded-lg flex items-center justify-between">
          <div>
            <div class="font-bold text-sm text-purple-950">Official Media Kit</div>
            <div class="text-xs text-purple-700">87K Followers · 6.2% Engagement · Verified Creator</div>
          </div>
          <a
            href="#mediakit"
            class="px-3 py-1.5 bg-purple-600 hover:bg-purple-700 text-white rounded text-xs font-semibold"
          >
            Export PDF →
          </a>
        </div>

        <div class="p-4 bg-gradient-to-r from-emerald-50 to-teal-50 border border-emerald-200 rounded-lg flex items-center justify-between">
          <div>
            <div class="font-bold text-sm text-emerald-950">Active Rate Card (2026 Q4)</div>
            <div class="text-xs text-emerald-700">Reels: 5M VND · TikTok: 6.5M VND · YouTube: 15M VND</div>
          </div>
          <a
            href="#ratecard"
            class="px-3 py-1.5 bg-emerald-600 hover:bg-emerald-700 text-white rounded text-xs font-semibold"
          >
            Edit Packages →
          </a>
        </div>

        <div class="p-4 bg-gradient-to-r from-amber-50 to-yellow-50 border border-amber-200 rounded-lg flex items-center justify-between">
          <div>
            <div class="font-bold text-sm text-amber-950">Annual Tax Summary Export</div>
            <div class="text-xs text-amber-700">Gross: 120M VND · Deductions: 12M VND · Net: 108M VND</div>
          </div>
          <button
            class="px-3 py-1.5 bg-amber-600 hover:bg-amber-700 text-white rounded text-xs font-semibold"
          >
            Download CSV
          </button>
        </div>
      </div>
    </div>
  </div>
</div>

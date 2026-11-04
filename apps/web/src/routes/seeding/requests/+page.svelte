<script lang="ts">
  import {
    computeSeedingROI,
    evaluateIdempotentSeedingCost,
    validateStateTransition,
    type SampleRequest,
    type SampleRequestStatus,
    type SampleShipmentStatus,
    type SampleOutcomeStatus,
    type FollowUpStatus,
    type SeedingCostItem
  } from '$lib/commerce';

  const workspaceId = 'ws-seeding-01';

  let filterStatus = $state<string>('all');
  let successNotice = $state<string | null>(null);

  // Cost items tracking ledger (Target 3)
  let costLedger = $state<SeedingCostItem[]>([
    {
      costItemId: 'cost-101',
      workspaceId,
      sampleRequestId: 'req-002',
      costType: 'seeding',
      amount: '320000.000000',
      currency: 'VND',
      sourceClass: 'imported',
      description: 'Seeding cost: 1 x Serum VitC (290000.000000) + shipping (30000.000000)',
      idempotencyKey: 'idemp-ship-002',
      createdAt: '2026-11-01T00:00:00Z',
      updatedAt: '2026-11-02T00:00:00Z'
    }
  ]);

  // Sample requests (Target 1: Separate orthogonal states)
  let requests = $state<SampleRequest[]>([
    {
      sampleRequestId: 'req-001',
      workspaceId,
      campaignId: 'camp-spring-2026',
      creatorEntityId: 'creator-skincare-queen',
      productId: 'prod-vitc-serum',
      productTitle: 'Serum Vitamin C Glow',
      creatorName: 'Pham Skincare',
      creatorHandle: '@skincare_queen',
      creatorPlatform: 'TikTok',
      status: 'submitted',
      outcomeStatus: 'pending',
      followUpStatus: 'not_started',
      quantity: 1,
      provisionalUnitCost: '290000.000000',
      currency: 'VND',
      shippingAddress: {
        name: 'Pham Thi Lan',
        phone: '0901234567',
        addressLine1: '123 Le Loi',
        city: 'Ho Chi Minh',
        country: 'VN'
      },
      contentRequirements: 'Unboxing & 7-day before/after video',
      deadline: '2026-11-20',
      createdAt: '2026-11-03T10:00:00Z',
      updatedAt: '2026-11-03T10:00:00Z'
    },
    {
      sampleRequestId: 'req-002',
      workspaceId,
      campaignId: 'camp-spring-2026',
      creatorEntityId: 'creator-beauty-rev',
      productId: 'prod-sunscreen-spf50',
      productTitle: 'Kem Chống Nắng SPF 50+',
      creatorName: 'Nguyen Beauty',
      creatorHandle: '@beauty_review',
      creatorPlatform: 'Instagram',
      status: 'approved',
      outcomeStatus: 'pending', // Target 2: Delivered but outcome pending (NOT definitive 0)
      followUpStatus: 'sent',
      quantity: 1,
      provisionalUnitCost: '220000.000000',
      currency: 'VND',
      shippingAddress: {
        name: 'Nguyen Mai',
        phone: '0912345678',
        addressLine1: '456 Tran Hung Dao',
        city: 'Da Nang',
        country: 'VN'
      },
      shipment: {
        sampleShipmentId: 'ship-002',
        sampleRequestId: 'req-002',
        workspaceId,
        carrier: 'VNPost',
        trackingNumber: 'VNPOST-123456',
        status: 'shipped',
        shippingCost: '30000.000000',
        currency: 'VND',
        shippedAt: '2026-11-02T08:00:00Z',
        createdAt: '2026-11-02T08:00:00Z',
        updatedAt: '2026-11-02T08:00:00Z'
      },
      contentRequirements: 'Instagram Reel + story link',
      deadline: '2026-11-15',
      createdAt: '2026-11-01T09:00:00Z',
      updatedAt: '2026-11-02T08:00:00Z'
    },
    {
      sampleRequestId: 'req-003',
      workspaceId,
      campaignId: 'camp-spring-2026',
      creatorEntityId: 'creator-health-guru',
      productId: 'prod-toner-aha',
      productTitle: 'Toner AHA 7% Exfoliating',
      creatorName: 'Tran Health',
      creatorHandle: '@health_guru',
      creatorPlatform: 'TikTok',
      status: 'fulfilled',
      outcomeStatus: 'complete',
      followUpStatus: 'replied',
      quantity: 2,
      provisionalUnitCost: '180000.000000',
      currency: 'VND',
      shippingAddress: {
        name: 'Tran Van H',
        phone: '0987654321',
        addressLine1: '789 Ba Trieu',
        city: 'Hanoi',
        country: 'VN'
      },
      shipment: {
        sampleShipmentId: 'ship-003',
        sampleRequestId: 'req-003',
        workspaceId,
        carrier: 'GHTK',
        trackingNumber: 'GHTK-778899',
        status: 'delivered',
        shippingCost: '35000.000000',
        currency: 'VND',
        shippedAt: '2026-10-25T08:00:00Z',
        deliveredAt: '2026-10-27T14:00:00Z',
        createdAt: '2026-10-25T08:00:00Z',
        updatedAt: '2026-10-27T14:00:00Z'
      },
      outcome: {
        contentUrl: 'https://tiktok.com/@health_guru/video/987654321',
        contentType: 'video',
        publishItemId: 'pub-item-303',
        attributedOrders: 28,
        attributedGmv: '5600000.000000',
        attributedComm: '560000.000000',
        currency: 'VND',
        sourceClass: 'official',
        confidenceLevel: 'high',
        loggedAt: '2026-10-29T16:00:00Z'
      },
      createdAt: '2026-10-24T11:00:00Z',
      updatedAt: '2026-10-29T16:00:00Z'
    }
  ]);

  // Derived ROI & Pipeline report
  const seedingReport = $derived(computeSeedingROI(requests, workspaceId, 'camp-spring-2026', 'VND'));

  const filteredRequests = $derived(
    filterStatus === 'all'
      ? requests
      : requests.filter((r) => r.status === filterStatus || r.outcomeStatus === filterStatus)
  );

  // Actions
  function handleApprove(req: SampleRequest) {
    const idempKey = `idemp-appr-${req.sampleRequestId}`;
    // Target 3: Idempotent cost creation
    const costResult = evaluateIdempotentSeedingCost(
      costLedger,
      req.sampleRequestId,
      workspaceId,
      req.quantity,
      req.provisionalUnitCost,
      '0.000000',
      idempKey
    );
    costLedger = costResult.costItems;

    // Target 1: Orthogonal state transition
    req.status = 'approved';
    req.updatedAt = new Date().toISOString();
    successNotice = `Đã duyệt yêu cầu cho ${req.creatorHandle}. ${
      costResult.isReplay ? '(Replay idempotency: đã ghi nhận chi phí dự kiến trước đó)' : 'Đã ghi nhận chi phí dự kiến.'
    }`;
  }

  function handleShip(req: SampleRequest) {
    const idempKey = `idemp-ship-${req.sampleRequestId}`;
    const shipCost = '32000.000000';

    // Target 3: Idempotent update of cost item without duplication
    const costResult = evaluateIdempotentSeedingCost(
      costLedger,
      req.sampleRequestId,
      workspaceId,
      req.quantity,
      req.provisionalUnitCost,
      shipCost,
      idempKey
    );
    costLedger = costResult.costItems;

    req.shipment = {
      sampleShipmentId: `ship-${Date.now()}`,
      sampleRequestId: req.sampleRequestId,
      workspaceId,
      carrier: 'GHTK Express',
      trackingNumber: `GHTK-${Math.floor(100000 + Math.random() * 900000)}`,
      status: 'shipped',
      shippingCost: shipCost,
      currency: 'VND',
      shippedAt: new Date().toISOString(),
      createdAt: new Date().toISOString(),
      updatedAt: new Date().toISOString()
    };
    req.status = 'approved';
    req.updatedAt = new Date().toISOString();
    successNotice = `Đã tạo vận đơn và giao hàng cho ${req.creatorHandle}. Tổng chi phí: ${costResult.totalCost} VND.`;
  }

  function handleDeliver(req: SampleRequest) {
    if (!req.shipment) return;
    req.shipment.status = 'delivered';
    req.shipment.deliveredAt = new Date().toISOString();
    req.status = 'fulfilled';
    req.followUpStatus = 'scheduled';
    // IMPORTANT Target 1 & Target 2: Outcome status remains pending!
    if (req.outcomeStatus === 'pending') {
      successNotice = `Đã xác nhận nhận hàng cho ${req.creatorHandle}. Trạng thái bài đăng: Đang chờ (chưa tính là 0 doanh thu).`;
    }
    req.updatedAt = new Date().toISOString();
  }

  function handleSendFollowUp(req: SampleRequest) {
    req.followUpStatus = 'sent';
    req.updatedAt = new Date().toISOString();
    successNotice = `Đã gửi tin nhắn nhắc nhở creator ${req.creatorHandle}.`;
  }
</script>

<div class="space-y-6 p-6">
  <!-- Header -->
  <div class="flex flex-col gap-2 sm:flex-row sm:items-center sm:justify-between">
    <div>
      <div class="flex items-center gap-2">
        <a href="/seeding/campaigns" class="text-sm font-medium text-blue-600 hover:underline">← Seeding Campaigns</a>
        <span class="text-gray-400">/</span>
        <h1 class="text-2xl font-bold tracking-tight text-gray-900">🌱 Seeding Requests Manager</h1>
      </div>
      <p class="text-sm text-gray-600">Quản lý mẫu gửi thử, vận đơn độc lập, theo dõi creator và phân tích ROI chính xác.</p>
    </div>
    <div class="flex gap-2">
      <button class="rounded-lg bg-blue-600 px-4 py-2 text-sm font-medium text-white shadow-sm hover:bg-blue-700">
        + Tạo yêu cầu mẫu
      </button>
    </div>
  </div>

  {#if successNotice}
    <div class="rounded-lg border border-green-200 bg-green-50 p-4 text-sm text-green-800">
      {successNotice}
    </div>
  {/if}

  <!-- Pipeline Summary Card -->
  <div class="rounded-xl border border-gray-200 bg-white p-6 shadow-sm">
    <h2 class="text-base font-semibold text-gray-900">Pipeline Summary & Performance</h2>

    <!-- Stage Counts Filter -->
    <div class="mt-4 flex flex-wrap gap-2">
      <button
        onclick={() => (filterStatus = 'all')}
        class="rounded-lg px-3 py-1.5 text-xs font-medium transition-colors {filterStatus === 'all' ? 'bg-gray-900 text-white' : 'bg-gray-100 text-gray-700 hover:bg-gray-200'}"
      >
        Tất cả ({requests.length})
      </button>
      <button
        onclick={() => (filterStatus = 'submitted')}
        class="rounded-lg px-3 py-1.5 text-xs font-medium transition-colors {filterStatus === 'submitted' ? 'bg-amber-600 text-white' : 'bg-amber-50 text-amber-800 hover:bg-amber-100'}"
      >
        📋 Chờ duyệt ({requests.filter((r) => r.status === 'submitted').length})
      </button>
      <button
        onclick={() => (filterStatus = 'approved')}
        class="rounded-lg px-3 py-1.5 text-xs font-medium transition-colors {filterStatus === 'approved' ? 'bg-blue-600 text-white' : 'bg-blue-50 text-blue-800 hover:bg-blue-100'}"
      >
        ✅ Đã duyệt ({requests.filter((r) => r.status === 'approved').length})
      </button>
      <button
        onclick={() => (filterStatus = 'fulfilled')}
        class="rounded-lg px-3 py-1.5 text-xs font-medium transition-colors {filterStatus === 'fulfilled' ? 'bg-purple-600 text-white' : 'bg-purple-50 text-purple-800 hover:bg-purple-100'}"
      >
        📬 Đã nhận hàng ({requests.filter((r) => r.status === 'fulfilled').length})
      </button>
      <button
        onclick={() => (filterStatus = 'complete')}
        class="rounded-lg px-3 py-1.5 text-xs font-medium transition-colors {filterStatus === 'complete' ? 'bg-green-600 text-white' : 'bg-green-50 text-green-800 hover:bg-green-100'}"
      >
        📱 Đã đăng bài ({requests.filter((r) => r.outcomeStatus === 'complete').length})
      </button>
    </div>

    <!-- Metrics Row -->
    <div class="mt-6 grid grid-cols-2 gap-4 border-t border-gray-100 pt-6 sm:grid-cols-4">
      <div>
        <span class="text-xs text-gray-500">Tổng chi phí mẫu & ship</span>
        <div class="text-lg font-bold text-gray-900">{seedingReport.totalCost} VND</div>
      </div>
      <div>
        <span class="text-xs text-gray-500">Doanh thu ghi nhận (Attributed GMV)</span>
        <div class="text-lg font-bold text-gray-900">{seedingReport.attributableRevenue} VND</div>
      </div>
      <div>
        <span class="text-xs text-gray-500">ROI Seeding</span>
        <div class="text-lg font-bold {seedingReport.roiPercentage.startsWith('+') ? 'text-green-600' : 'text-gray-900'}">
          {seedingReport.roiPercentage}
        </div>
      </div>
      <div>
        <span class="text-xs text-gray-500">Tỷ lệ có bài review</span>
        <div class="text-lg font-bold text-blue-600">{seedingReport.outcomeCoverageRate}</div>
      </div>
    </div>

    <!-- Acceptance Target 2 Alert -->
    {#if seedingReport.isMissingOutcomePending}
      <div class="mt-4 rounded-lg border border-amber-200 bg-amber-50 p-3 text-xs text-amber-900">
        <span class="font-semibold">⚠️ Lưu ý định lượng (Acceptance Target 2):</span> {seedingReport.pendingOutcomesCount} mẫu đã giao tới creator hiện đang chờ xuất bản nội dung. Dữ liệu này được xác định là <em>kết quả đang chờ (Pending)</em>, tuyệt đối không tính là doanh thu 0 definitive loss.
      </div>
    {/if}
  </div>

  <!-- Request Cards List -->
  <div class="space-y-4">
    {#each filteredRequests as req (req.sampleRequestId)}
      <div class="rounded-xl border border-gray-200 bg-white p-5 shadow-sm transition-shadow hover:shadow-md">
        <div class="flex flex-col justify-between gap-4 md:flex-row md:items-start">
          <div class="space-y-2">
            <div class="flex items-center gap-2">
              <span class="text-base font-semibold text-gray-900">{req.productTitle}</span>
              <span class="rounded bg-gray-100 px-2 py-0.5 text-xs text-gray-600">x{req.quantity} sp</span>
              <span class="text-xs text-gray-400">·</span>
              <span class="font-medium text-gray-700">{req.creatorHandle}</span>
              <span class="rounded bg-indigo-50 px-2 py-0.5 text-xs font-medium text-indigo-700">{req.creatorPlatform}</span>
            </div>

            <!-- Target 1: Orthogonal State Badges -->
            <div class="flex flex-wrap items-center gap-2 pt-1 text-xs">
              <!-- Request Status Badge -->
              <span class="rounded-full px-2.5 py-0.5 font-medium {req.status === 'approved' ? 'bg-blue-100 text-blue-800' : req.status === 'fulfilled' ? 'bg-purple-100 text-purple-800' : 'bg-amber-100 text-amber-800'}">
                Trạng thái: {req.status}
              </span>

              <!-- Shipment Status Badge -->
              {#if req.shipment}
                <span class="rounded-full px-2.5 py-0.5 font-medium {req.shipment.status === 'delivered' ? 'bg-green-100 text-green-800' : 'bg-cyan-100 text-cyan-800'}">
                  Vận đơn: {req.shipment.carrier} ({req.shipment.status})
                </span>
              {:else}
                <span class="rounded-full bg-gray-100 px-2.5 py-0.5 font-medium text-gray-600">
                  Vận đơn: Chưa giao
                </span>
              {/if}

              <!-- Outcome Status Badge (Target 2) -->
              <span class="rounded-full px-2.5 py-0.5 font-medium {req.outcomeStatus === 'complete' ? 'bg-emerald-100 text-emerald-800' : 'bg-yellow-100 text-yellow-800'}">
                Nội dung: {req.outcomeStatus === 'pending' ? '⏳ Đang chờ review (Pending outcome)' : '✅ Đã có bài'}
              </span>

              <!-- Follow-Up Status Badge -->
              <span class="rounded-full bg-slate-100 px-2.5 py-0.5 font-medium text-slate-700">
                Follow-up: {req.followUpStatus}
              </span>
            </div>

            <!-- Details -->
            <div class="pt-2 text-xs text-gray-600">
              <div>📍 Địa chỉ: {req.shippingAddress.name} ({req.shippingAddress.phone}), {req.shippingAddress.addressLine1}, {req.shippingAddress.city}</div>
              <div>💰 Giá vốn COGS: {req.provisionalUnitCost} VND/sp · Vận chuyển: {req.shipment?.shippingCost || '0.000000'} VND</div>
              {#if req.shipment?.trackingNumber}
                <div>📦 Mã vận đơn: <span class="font-mono font-medium text-gray-900">{req.shipment.trackingNumber}</span></div>
              {/if}
              {#if req.outcome}
                <div class="mt-1 text-emerald-700 font-medium">
                  🎬 Bài đăng: <a href={req.outcome.contentUrl} target="_blank" rel="noopener noreferrer" class="underline hover:text-emerald-900">{req.outcome.contentUrl}</a>
                  ({req.outcome.attributedOrders} đơn · {req.outcome.attributedGmv} VND)
                </div>
              {/if}
            </div>
          </div>

          <!-- Actions (Target 1 & 3: Independent Operations) -->
          <div class="flex flex-wrap gap-2 md:flex-col md:items-end">
            {#if req.status === 'submitted'}
              <button
                onclick={() => handleApprove(req)}
                class="rounded-lg bg-blue-600 px-3 py-1.5 text-xs font-medium text-white hover:bg-blue-700"
              >
                Duyệt yêu cầu
              </button>
            {/if}

            {#if req.status === 'approved' && (!req.shipment || req.shipment.status === 'label_created')}
              <button
                onclick={() => handleShip(req)}
                class="rounded-lg bg-indigo-600 px-3 py-1.5 text-xs font-medium text-white hover:bg-indigo-700"
              >
                📦 Giao hàng & ghi nhận chi phí
              </button>
            {/if}

            {#if req.shipment && req.shipment.status === 'shipped'}
              <button
                onclick={() => handleDeliver(req)}
                class="rounded-lg bg-green-600 px-3 py-1.5 text-xs font-medium text-white hover:bg-green-700"
              >
                ✅ Đã giao tới creator
              </button>
            {/if}

            {#if req.status === 'fulfilled' && req.outcomeStatus === 'pending'}
              <button
                onclick={() => handleSendFollowUp(req)}
                class="rounded-lg border border-gray-300 bg-white px-3 py-1.5 text-xs font-medium text-gray-700 hover:bg-gray-50"
              >
                💬 Gửi tin nhắn nhắc review
              </button>
            {/if}
          </div>
        </div>
      </div>
    {/each}
  </div>
</div>

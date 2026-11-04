<script lang="ts">
  import {
    computeSeedingROI,
    type SeedingCampaign,
    type SampleRequest
  } from '$lib/commerce';

  const workspaceId = 'ws-seeding-01';

  let filterStatus = $state<string>('all');

  // Campaigns state
  let campaigns = $state<SeedingCampaign[]>([
    {
      campaignId: 'camp-spring-2026',
      workspaceId,
      title: 'Spring Skincare Seeding 2026',
      objective: 'Launch dòng Serum Vitamin C & Toner AHA mới',
      status: 'active',
      startDate: '2026-03-01',
      endDate: '2026-03-30',
      budget: '15000000.000000',
      budgetCurrency: 'VND',
      relatedProductIds: ['prod-vitc-serum', 'prod-sunscreen-spf50', 'prod-toner-aha'],
      createdAt: '2026-02-28T00:00:00Z',
      updatedAt: '2026-03-01T00:00:00Z'
    },
    {
      campaignId: 'camp-summer-glow',
      workspaceId,
      title: 'Summer Sun Protection Campaign',
      objective: 'Đẩy mạnh sản phẩm chống nắng mùa hè cho Gen Z',
      status: 'draft',
      startDate: '2026-05-01',
      endDate: '2026-05-31',
      budget: '25000000.000000',
      budgetCurrency: 'VND',
      relatedProductIds: ['prod-sunscreen-spf50'],
      createdAt: '2026-03-15T00:00:00Z',
      updatedAt: '2026-03-15T00:00:00Z'
    }
  ]);

  // Sample requests for active campaign
  let requests = $state<SampleRequest[]>([
    {
      sampleRequestId: 'req-001',
      workspaceId,
      campaignId: 'camp-spring-2026',
      creatorEntityId: 'creator-1',
      productId: 'prod-vitc-serum',
      status: 'submitted',
      outcomeStatus: 'pending',
      followUpStatus: 'not_started',
      quantity: 1,
      provisionalUnitCost: '290000.000000',
      currency: 'VND',
      shippingAddress: { name: 'Lan', phone: '0901', addressLine1: 'HCM', city: 'HCM', country: 'VN' },
      createdAt: '2026-03-02T00:00:00Z',
      updatedAt: '2026-03-02T00:00:00Z'
    },
    {
      sampleRequestId: 'req-002',
      workspaceId,
      campaignId: 'camp-spring-2026',
      creatorEntityId: 'creator-2',
      productId: 'prod-sunscreen-spf50',
      status: 'fulfilled',
      outcomeStatus: 'pending', // Target 2: Delivered, pending review, NOT definitive 0
      followUpStatus: 'sent',
      quantity: 1,
      provisionalUnitCost: '220000.000000',
      currency: 'VND',
      shippingAddress: { name: 'Mai', phone: '0902', addressLine1: 'DN', city: 'DN', country: 'VN' },
      shipment: {
        sampleShipmentId: 'ship-002',
        sampleRequestId: 'req-002',
        workspaceId,
        carrier: 'VNPost',
        trackingNumber: 'VNPOST-123',
        status: 'delivered',
        shippingCost: '30000.000000',
        currency: 'VND',
        createdAt: '2026-03-03T00:00:00Z',
        updatedAt: '2026-03-05T00:00:00Z'
      },
      createdAt: '2026-03-02T00:00:00Z',
      updatedAt: '2026-03-05T00:00:00Z'
    },
    {
      sampleRequestId: 'req-003',
      workspaceId,
      campaignId: 'camp-spring-2026',
      creatorEntityId: 'creator-3',
      productId: 'prod-toner-aha',
      status: 'fulfilled',
      outcomeStatus: 'complete',
      followUpStatus: 'replied',
      quantity: 2,
      provisionalUnitCost: '180000.000000',
      currency: 'VND',
      shippingAddress: { name: 'Hung', phone: '0903', addressLine1: 'HN', city: 'HN', country: 'VN' },
      shipment: {
        sampleShipmentId: 'ship-003',
        sampleRequestId: 'req-003',
        workspaceId,
        carrier: 'GHTK',
        trackingNumber: 'GHTK-999',
        status: 'delivered',
        shippingCost: '35000.000000',
        currency: 'VND',
        createdAt: '2026-03-03T00:00:00Z',
        updatedAt: '2026-03-06T00:00:00Z'
      },
      outcome: {
        contentUrl: 'https://tiktok.com/@health/video/1',
        attributedOrders: 28,
        attributedGmv: '5600000.000000',
        attributedComm: '560000.000000',
        currency: 'VND',
        sourceClass: 'official',
        confidenceLevel: 'high',
        loggedAt: '2026-03-08T00:00:00Z'
      },
      createdAt: '2026-03-02T00:00:00Z',
      updatedAt: '2026-03-08T00:00:00Z'
    }
  ]);

  const roiSpring = $derived(computeSeedingROI(requests, workspaceId, 'camp-spring-2026', 'VND'));

  const filteredCampaigns = $derived(
    filterStatus === 'all'
      ? campaigns
      : campaigns.filter((c) => c.status === filterStatus)
  );
</script>

<div class="space-y-6 p-6">
  <!-- Header -->
  <div class="flex flex-col gap-2 sm:flex-row sm:items-center sm:justify-between">
    <div>
      <h1 class="text-2xl font-bold tracking-tight text-gray-900">🌱 Seeding Campaigns Dashboard</h1>
      <p class="text-sm text-gray-600">Tổng quan chiến dịch gửi mẫu, kiểm soát ngân sách, quản lý creators và ROI đa nguồn.</p>
    </div>
    <div class="flex gap-2">
      <a href="/seeding/requests" class="rounded-lg border border-gray-300 bg-white px-4 py-2 text-sm font-medium text-gray-700 hover:bg-gray-50">
        Quản lý danh sách mẫu →
      </a>
      <button class="rounded-lg bg-blue-600 px-4 py-2 text-sm font-medium text-white shadow-sm hover:bg-blue-700">
        + Tạo campaign mới
      </button>
    </div>
  </div>

  <!-- Summary Bar -->
  <div class="rounded-xl border border-gray-200 bg-white p-6 shadow-sm">
    <div class="flex flex-wrap items-center justify-between gap-4 border-b border-gray-100 pb-4">
      <div class="flex items-center gap-3 text-sm">
        <span class="inline-flex items-center gap-1.5 font-medium text-green-700">
          <span class="h-2 w-2 rounded-full bg-green-500"></span> 1 Running
        </span>
        <span class="text-gray-300">|</span>
        <span class="inline-flex items-center gap-1.5 font-medium text-amber-700">
          <span class="h-2 w-2 rounded-full bg-amber-500"></span> 1 Draft
        </span>
      </div>
      <div class="text-xs text-gray-500">
        Ngân sách khả dụng: 40,000,000 VND
      </div>
    </div>

    <div class="mt-4 grid grid-cols-2 gap-4 sm:grid-cols-4">
      <div>
        <div class="text-xs text-gray-500">Tổng mẫu đã gửi</div>
        <div class="text-xl font-bold text-gray-900">3 creators</div>
      </div>
      <div>
        <div class="text-xs text-gray-500">Tổng chi phí (COGS + Ship)</div>
        <div class="text-xl font-bold text-gray-900">{roiSpring.totalCost} VND</div>
      </div>
      <div>
        <div class="text-xs text-gray-500">Doanh thu ghi nhận</div>
        <div class="text-xl font-bold text-emerald-600">{roiSpring.attributableRevenue} VND</div>
      </div>
      <div>
        <div class="text-xs text-gray-500">ROI trung bình</div>
        <div class="text-xl font-bold text-blue-600">{roiSpring.roiPercentage}</div>
      </div>
    </div>
  </div>

  <!-- Campaigns List -->
  <div class="space-y-4">
    {#each filteredCampaigns as camp (camp.campaignId)}
      <div class="rounded-xl border border-gray-200 bg-white p-6 shadow-sm">
        <div class="flex flex-col justify-between gap-4 sm:flex-row sm:items-start">
          <div class="space-y-1">
            <div class="flex items-center gap-2">
              <span class="text-lg font-bold text-gray-900">🌱 {camp.title}</span>
              <span class="rounded-full px-2.5 py-0.5 text-xs font-medium {camp.status === 'active' ? 'bg-green-100 text-green-800' : 'bg-amber-100 text-amber-800'}">
                {camp.status === 'active' ? '🟢 Running' : '📋 Draft'}
              </span>
            </div>
            <p class="text-xs text-gray-600">{camp.objective}</p>
            <div class="text-xs text-gray-500">
              Thời gian: {camp.startDate || 'Chưa thiết lập'} - {camp.endDate || 'Chưa thiết lập'} · Ngân sách: {camp.budget} {camp.budgetCurrency}
            </div>
          </div>
          <div>
            <a
              href="/seeding/requests"
              class="rounded-lg bg-gray-50 px-3 py-1.5 text-xs font-medium text-gray-700 hover:bg-gray-100"
            >
              Chi tiết yêu cầu ({requests.length}) →
            </a>
          </div>
        </div>

        {#if camp.status === 'active'}
          <div class="mt-6 grid grid-cols-1 gap-4 rounded-lg bg-gray-50 p-4 sm:grid-cols-3">
            <div>
              <div class="text-xs text-gray-500">Tiến độ giao mẫu & bài viết</div>
              <div class="mt-1 text-sm font-semibold text-gray-900">
                {roiSpring.outcomesLoggedCount}/{roiSpring.totalSamplesDelivered} bài đăng ({roiSpring.outcomeCoverageRate})
              </div>
            </div>
            <div>
              <div class="text-xs text-gray-500">Tổng chi phí thực tế</div>
              <div class="mt-1 text-sm font-semibold text-gray-900">{roiSpring.totalCost} VND</div>
            </div>
            <div>
              <div class="text-xs text-gray-500">Hiệu quả ROI Seeding</div>
              <div class="mt-1 text-sm font-semibold text-emerald-600">{roiSpring.roiPercentage}</div>
            </div>
          </div>

          <!-- Target 2 Information Card -->
          {#if roiSpring.isMissingOutcomePending}
            <div class="mt-4 rounded-lg border border-blue-200 bg-blue-50 p-3 text-xs text-blue-900">
              <span class="font-semibold">Độ tin cậy ROI (Acceptance Target 2):</span> {roiSpring.pendingOutcomesCount} mẫu đã nhận chưa có bài viết. Hệ thống đánh dấu <em>Pending Outcome</em>, không giả định doanh thu = 0 gây sai lệch hiệu quả chiến dịch.
            </div>
          {/if}
        {/if}
      </div>
    {/each}
  </div>
</div>

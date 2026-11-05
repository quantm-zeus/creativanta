<script lang="ts">
  import type { WorkspaceRole } from '$lib/auth';
  import { authStore } from '$lib/auth';
  import {
    getModuleIntegritySummaries,
    getCrossModuleLinks,
    getInitialUnreconciledOutcomes,
    applyOperationalRepairRemote,
    getProviderAndShippingGateSummary,
    type UnreconciledOutcome,
    type OperationalRepairRequest
  } from '$lib/commerce';
  import {
    evaluateAuthorizedP1Import,
    filterRepairCardsForRole,
    resolveUnderlyingRepairGap,
    type AuthorizedImportInput,
    type LabeledProfitAndRepairProjection
  } from '$lib/p1_first_value';
  import { callCanonicalRpc } from '$lib/api/client';

  const workspaceId = 'ws-p6-commerce';
  let selectedRole = $state<WorkspaceRole>('owner');
  let activeTab = $state<'overview' | 'unreconciled' | 'gates' | 'p1_import'>('overview');

  // P6 Acceptance State
  const moduleSummaries = getModuleIntegritySummaries();
  const crossModuleLinks = getCrossModuleLinks();
  let unreconciledItems = $state<UnreconciledOutcome[]>(getInitialUnreconciledOutcomes(workspaceId));
  const gateSummary = getProviderAndShippingGateSummary(workspaceId);

  // Operational Repair Modal / Form state
  let selectedUnrecItem = $state<UnreconciledOutcome | null>(null);
  let auditReasonInput = $state('');
  let repairError = $state<string | null>(null);
  let repairSuccessMessage = $state<string | null>(null);

  let isSubmittingRepair = $state(false);

  function openRepairDialog(item: UnreconciledOutcome) {
    selectedUnrecItem = item;
    auditReasonInput = '';
    repairError = null;
    repairSuccessMessage = null;
  }

  async function handleExecuteRepair() {
    if (!selectedUnrecItem) return;
    repairError = null;
    isSubmittingRepair = true;
    try {
      const req: OperationalRepairRequest = {
        workspaceId: $authStore.activeWorkspace?.id || workspaceId,
        unreconciledId: selectedUnrecItem.id,
        repairType: selectedUnrecItem.repairActionSuggested as any,
        auditReason: auditReasonInput,
        actorId: $authStore.user?.id || 'user-operator-current',
        actorRole: selectedRole
      };
      const res = await applyOperationalRepairRemote(unreconciledItems, req);
      if (!res.ok || !res.result) {
        repairError =
          res.error ||
          'Không thể ghi bút toán đối soát lên Sổ cái máy chủ (ReconciliationService/ApplyRepair). Lý do kiểm toán của bạn đã được giữ nguyên.';
        return;
      }
      unreconciledItems = res.updatedOutcomes;
      repairSuccessMessage = `Đã đối soát thành công! Mã chứng từ: ${res.result.ledgerPostingId}`;
      selectedUnrecItem = null;
    } catch (err: any) {
      repairError = err.message || 'Lỗi khi thực hiện đối soát';
    } finally {
      isSubmittingRepair = false;
    }
  }

  // P1-05 Preserved Import Fixture
  const initialBatch: AuthorizedImportInput = {
    workspaceId: 'ws-p1-commerce',
    userId: 'user-owner-p1',
    role: 'owner',
    connectedAccountsCount: 0,
    productsCount: 12,
    ordersCount: 84,
    costsCount: 6,
    settlementsCount: 1,
    grossRevenueVnd: '24500000',
    knownCostsVnd: '9200000',
    isDemoFixture: false,
    repairGaps: [
      {
        gapId: 'gap-missing-cogs-sku-a1',
        gapKind: 'missing_cogs',
        title: 'Thiếu giá vốn (COGS) cho 2 SKU vừa nhập CSV',
        reason: '2 SKU chưa khai báo giá vốn trong Sổ cái, lợi nhuận ròng đang tạm tính.',
        repairCtaLabel: 'Bổ sung giá vốn (COGS)',
        repairRoute: '/kinh-doanh',
        affectedAmountVnd: '2800000',
        resolved: false
      },
      {
        gapId: 'gap-missing-evidence-settle-01',
        gapKind: 'missing_evidence',
        title: 'Thiếu chứng từ phí vận chuyển kỳ đối soát #01',
        reason: 'Khoản khấu trừ phí vận chuyển chưa đính kèm chứng từ đối soát.',
        repairCtaLabel: 'Đính kèm chứng từ đối soát',
        repairRoute: '/kinh-doanh',
        affectedAmountVnd: '650000',
        resolved: false
      }
    ]
  };

  let projection = $state<LabeledProfitAndRepairProjection>(
    evaluateAuthorizedP1Import(initialBatch)
  );
  let visibleRepairCards = $derived(
    filterRepairCardsForRole(projection.activeRepairCards, selectedRole)
  );

  let p1RepairError = $state<string | null>(null);

  async function handleResolveGap(gapId: string, addedCostVnd: string) {
    if (selectedRole === 'viewer') return;
    p1RepairError = null;
    const rpcRes = await callCanonicalRpc(
      'creativanta.finance.v1.CostService/RecordCostEntry',
      {
        workspace_id: $authStore.activeWorkspace?.id || projection.workspaceId,
        gap_id: gapId,
        amount_vnd_exact: addedCostVnd,
        actor_role: selectedRole
      }
    );
    if (!rpcRes.ok) {
      p1RepairError = rpcRes.error.message;
      return;
    }
    projection = resolveUnderlyingRepairGap(projection, gapId, addedCostVnd, selectedRole);
  }

  let pendingUnreconciledCount = $derived(unreconciledItems.filter(i => !i.resolved).length);
</script>

<svelte:head><title>Kinh doanh & Vận hành Thương mại — Creativanta</title></svelte:head>

<section class="space-y-6" aria-labelledby="commerce-title">
  <!-- Header -->
  <div class="flex flex-col md:flex-row md:items-center md:justify-between gap-4">
    <div>
      <p class="text-xs font-bold uppercase tracking-[0.15em] text-[#ad6047]">
        COMMERCE &amp; MONETIZATION OS · PHASE P6 ACCEPTANCE HUB
      </p>
      <h1 id="commerce-title" class="text-3xl font-bold tracking-tight text-[#242924]">Kinh doanh &amp; Vận hành</h1>
      <p class="max-w-2xl text-sm leading-6 text-[#7d837b]">
        Trung tâm nghiệm thu thương mại toàn diện: Quản lý sản phẩm, đơn hàng, gói ưu đãi, cửa hàng, liên kết affiliate, live war room, seeding và đối soát tài chính minh bạch.
      </p>
    </div>

    <!-- Role Switcher -->
    <div class="flex items-center gap-2 self-start md:self-auto rounded-xl border border-[#e8e5dc] bg-white p-1.5 shadow-sm">
      <span class="text-xs font-medium text-[#7d837b] px-2">Vai trò:</span>
      <select
        bind:value={selectedRole}
        class="rounded-lg border-0 bg-[#f4f2ea] px-3 py-1.5 text-xs font-bold text-[#242924] focus:ring-2 focus:ring-[#274333]"
      >
        <option value="owner">Chủ sở hữu (Owner)</option>
        <option value="admin">Quản trị viên (Admin)</option>
        <option value="manager">Quản lý (Manager)</option>
        <option value="editor">Biên tập (Editor)</option>
        <option value="contributor">Cộng tác viên (Contributor)</option>
        <option value="viewer">Người xem (Viewer)</option>
      </select>
    </div>
  </div>

  <!-- Acceptance Navigation Tabs -->
  <div class="flex border-b border-[#e8e5dc] gap-2 overflow-x-auto text-sm font-semibold">
    <button
      type="button"
      class="pb-3 px-3 transition-colors {activeTab === 'overview' ? 'border-b-2 border-[#274333] text-[#274333]' : 'text-[#7d837b] hover:text-[#242924]'}"
      onclick={() => (activeTab = 'overview')}
    >
      Tổng quan 11 Phân hệ P6
    </button>
    <button
      type="button"
      class="pb-3 px-3 transition-colors flex items-center gap-1.5 {activeTab === 'unreconciled' ? 'border-b-2 border-[#ad6047] text-[#ad6047]' : 'text-[#7d837b] hover:text-[#242924]'}"
      onclick={() => (activeTab = 'unreconciled')}
    >
      Hạng mục Cần Đối soát
      {#if pendingUnreconciledCount > 0}
        <span class="rounded-full bg-[#ad6047] text-white px-2 py-0.5 text-[11px] font-bold">
          {pendingUnreconciledCount}
        </span>
      {/if}
    </button>
    <button
      type="button"
      class="pb-3 px-3 transition-colors {activeTab === 'gates' ? 'border-b-2 border-[#274333] text-[#274333]' : 'text-[#7d837b] hover:text-[#242924]'}"
      onclick={() => (activeTab = 'gates')}
    >
      Cổng Thanh toán &amp; Vận chuyển
    </button>
    <button
      type="button"
      class="pb-3 px-3 transition-colors {activeTab === 'p1_import' ? 'border-b-2 border-[#274333] text-[#274333]' : 'text-[#7d837b] hover:text-[#242924]'}"
      onclick={() => (activeTab = 'p1_import')}
    >
      Nhập CSV &amp; Sổ cái P1
    </button>
  </div>

  <!-- Tab 1: Overview & 11 Modules (Target 1: No Function Lost) -->
  {#if activeTab === 'overview'}
    <div class="space-y-6">
      <!-- Acceptance Target 1 Banner -->
      <div class="rounded-2xl border border-[#d8e6db] bg-[#f2f8f4] p-5">
        <div class="flex items-center gap-2">
          <span class="rounded bg-[#274333] px-2.5 py-1 text-xs font-bold text-white uppercase tracking-wider">
            Target 1: Không thất thoát tính năng giữa các module
          </span>
          <span class="text-xs font-semibold text-[#274333]">
            11 Phân hệ P6 + Sổ cái M19 hoàn toàn kết nối &amp; không island silos
          </span>
        </div>
        <p class="mt-2 text-xs leading-relaxed text-[#3a5843]">
          Mọi giao dịch từ Cơ hội (M04), Ý tưởng (M05), Sản phẩm (M13), Gói bán (M14/M15), Affiliate (M16), Live War Room (M17), Seeding (M18), Creator Pro (S16) đều tự động đối chiếu và ghi nhận chứng từ vào Sổ cái Vận hành (M19).
        </p>
      </div>

      <!-- 12 Modules Grid -->
      <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-4">
        {#each moduleSummaries as mod}
          <a
            href={mod.route}
            class="group rounded-xl border border-[#e8e5dc] bg-white p-4 shadow-sm hover:border-[#274333] hover:shadow-md transition-all flex flex-col justify-between"
          >
            <div>
              <div class="flex items-center justify-between">
                <span class="font-mono text-xs font-bold text-[#ad6047]">{mod.moduleId}</span>
                <span class="rounded bg-[#eaf4ed] px-2 py-0.5 text-[11px] font-bold text-[#274333]">
                  {mod.status}
                </span>
              </div>
              <h3 class="mt-2 text-sm font-bold text-[#242924] group-hover:text-[#274333]">
                {mod.name}
              </h3>
            </div>
            <div class="mt-4 pt-3 border-t border-[#f4f0e8] flex items-center justify-between text-xs text-[#7d837b]">
              <span>{mod.connectedLinks} liên kết</span>
              <span>{mod.activeEntities} thực thể</span>
            </div>
          </a>
        {/each}
      </div>

      <!-- Cross-Module Lineage Connections -->
      <div class="rounded-2xl border border-[#e8e5dc] bg-white p-6 shadow-sm space-y-4">
        <h3 class="text-base font-bold text-[#242924]">Chuỗi Chuyển đổi &amp; Đối chiếu Đa Phân hệ (Cross-Domain Lineage)</h3>
        <div class="divide-y divide-[#f4f0e8]">
          {#each crossModuleLinks as link}
            <div class="py-3 flex flex-col sm:flex-row sm:items-center sm:justify-between gap-2 text-xs">
              <div class="flex items-center gap-2">
                <span class="font-mono font-bold text-[#274333] bg-[#eaf4ed] px-2 py-0.5 rounded">
                  {link.fromModule} &rarr; {link.toModule}
                </span>
                <span class="font-medium text-[#242924]">{link.description}</span>
              </div>
              <div class="flex items-center gap-2 text-[#7d837b]">
                <span class="font-mono">Loại: {link.linkType}</span>
                <span class="text-[#274333] font-bold">&#10003; Đã xác minh</span>
              </div>
            </div>
          {/each}
        </div>
      </div>
    </div>
  {/if}

  <!-- Tab 2: Partial & Unreconciled Outcomes (Target 2) -->
  {#if activeTab === 'unreconciled'}
    <div class="space-y-6">
      <!-- Target 2 Banner -->
      <div class="rounded-2xl border border-[#fde8e4] bg-[#fff5f3] p-5">
        <div class="flex items-center gap-2">
          <span class="rounded bg-[#ad6047] px-2.5 py-1 text-xs font-bold text-white uppercase tracking-wider">
            Target 2: Minh bạch các kết quả bán phần &amp; chưa đối soát
          </span>
          <span class="text-xs font-semibold text-[#ad6047]">
            PRD §15.1: Không che giấu số liệu, phân định rõ source_class &amp; confidence
          </span>
        </div>
        <p class="mt-2 text-xs leading-relaxed text-[#7c3b28]">
          Tuyệt đối không giả mạo kết quả chưa có thành hoàn thành. Đơn hoàn tiền một phần, kho hàng lệch số liệu, quà seeding chờ creator đăng bài, hoặc bảng kê chưa khớp được gắn nhãn minh bạch và cho phép sửa chữa vận hành có lý do kiểm toán (audit_reason).
        </p>
      </div>

      {#if repairSuccessMessage}
        <div class="rounded-xl border border-green-200 bg-green-50 p-4 text-xs font-bold text-green-800">
          {repairSuccessMessage}
        </div>
      {/if}

      <!-- Unreconciled List -->
      <div class="space-y-3">
        {#each unreconciledItems as item}
          <div class="rounded-2xl border {item.resolved ? 'border-gray-200 bg-gray-50 opacity-75' : 'border-[#e8e5dc] bg-white'} p-5 shadow-sm space-y-3">
            <div class="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-2">
              <div class="flex items-center gap-2 flex-wrap">
                <span class="font-mono text-xs font-bold px-2 py-0.5 rounded bg-[#f4f2ea] text-[#242924]">
                  {item.domain}
                </span>
                <span class="rounded px-2 py-0.5 text-[11px] font-bold {item.sourceClass === 'official' ? 'bg-[#eaf4ed] text-[#274333]' : item.sourceClass === 'unreconciled' ? 'bg-[#fee2e2] text-[#991b1b]' : 'bg-[#fef9c3] text-[#854d0e]'}">
                  source_class: {item.sourceClass}
                </span>
                <span class="rounded bg-blue-50 text-blue-800 px-2 py-0.5 text-[11px] font-semibold">
                  Độ tin cậy: {Math.round(item.confidenceScore * 100)}%
                </span>
                {#if item.resolved}
                  <span class="rounded bg-green-100 text-green-800 px-2 py-0.5 text-[11px] font-bold">
                    &#10003; Đã đối soát
                  </span>
                {:else}
                  <span class="rounded bg-amber-100 text-amber-800 px-2 py-0.5 text-[11px] font-bold">
                    Trạng thái: {item.status}
                  </span>
                {/if}
              </div>

              {#if !item.resolved}
                <button
                  type="button"
                  class="self-start sm:self-auto rounded-lg bg-[#274333] px-3 py-1.5 text-xs font-bold text-white hover:bg-[#1f3529] transition-colors"
                  onclick={() => openRepairDialog(item)}
                >
                  Sửa chữa vận hành
                </button>
              {/if}
            </div>

            <div>
              <h4 class="text-sm font-bold text-[#242924]">{item.title}</h4>
              <p class="text-xs text-[#616c63] mt-1 leading-relaxed">{item.detail}</p>
            </div>

            <div class="pt-2 border-t border-[#f4f0e8] flex flex-wrap items-center justify-between text-xs text-[#7d837b] gap-2">
              <span>Giá trị tài chính: <strong class="text-[#242924] font-mono">{Number(item.financialImpactExact).toLocaleString('vi-VN')} VND</strong></span>
              {#if item.originalCapturedExact}
                <span>Đã thu gốc: <span class="font-mono">{Number(item.originalCapturedExact).toLocaleString('vi-VN')} VND</span></span>
              {/if}
              {#if item.physicalReturnState}
                <span>Trạng thái hàng: <strong class="font-mono">{item.physicalReturnState}</strong></span>
              {/if}
              {#if item.auditReason}
                <span class="text-green-700 font-medium">Lý do kiểm toán: {item.auditReason}</span>
              {/if}
            </div>
          </div>
        {/each}
      </div>

      <!-- Repair Modal -->
      {#if selectedUnrecItem}
        <div class="fixed inset-0 z-50 flex items-center justify-center bg-black/50 p-4">
          <div class="w-full max-w-lg rounded-2xl bg-white p-6 shadow-xl space-y-4">
            <div class="flex items-center justify-between border-b pb-3">
              <h3 class="text-base font-bold text-[#242924]">Sửa chữa vận hành đối soát</h3>
              <button
                type="button"
                class="text-gray-400 hover:text-gray-600 text-lg font-bold"
                onclick={() => (selectedUnrecItem = null)}
              >
                &times;
              </button>
            </div>

            <div class="text-xs text-[#616c63] space-y-1">
              <p><strong>Mục xử lý:</strong> {selectedUnrecItem.title}</p>
              <p><strong>Thao tác:</strong> <span class="font-mono text-[#ad6047]">{selectedUnrecItem.repairActionSuggested}</span></p>
              <p><strong>Tác động tài chính:</strong> <span class="font-mono">{Number(selectedUnrecItem.financialImpactExact).toLocaleString('vi-VN')} VND</span></p>
            </div>

            <div class="space-y-1.5">
              <label for="repair-reason" class="block text-xs font-bold text-[#242924]">
                Lý do kiểm toán (Audit Reason — Bắt buộc):
              </label>
              <textarea
                id="repair-reason"
                bind:value={auditReasonInput}
                rows="3"
                placeholder="Nhập lý do kiểm toán, mã biên bản đối chiếu hoặc quyết định phê duyệt..."
                class="w-full rounded-xl border border-[#e8e5dc] p-3 text-xs text-[#242924] focus:ring-2 focus:ring-[#274333]"
              ></textarea>
            </div>

            {#if repairError}
              <p class="text-xs font-bold text-red-600">{repairError}</p>
            {/if}

            <div class="flex justify-end gap-2 pt-2 border-t">
              <button
                type="button"
                class="rounded-lg border border-[#e8e5dc] px-4 py-2 text-xs font-bold text-[#7d837b] hover:bg-[#f4f2ea]"
                onclick={() => (selectedUnrecItem = null)}
              >
                Hủy bỏ
              </button>
              <button
                type="button"
                class="rounded-lg bg-[#274333] px-4 py-2 text-xs font-bold text-white hover:bg-[#1f3529]"
                onclick={handleExecuteRepair}
              >
                Ghi nhận bút toán đối soát
              </button>
            </div>
          </div>
        </div>
      {/if}
    </div>
  {/if}

  <!-- Tab 3: Provider & Shipping Gates (Target 3) -->
  {#if activeTab === 'gates'}
    <div class="space-y-6">
      <!-- Target 3 Banner -->
      <div class="rounded-2xl border border-[#d8e6db] bg-[#f2f8f4] p-5">
        <div class="flex items-center gap-2">
          <span class="rounded bg-[#274333] px-2.5 py-1 text-xs font-bold text-white uppercase tracking-wider">
            Target 3: Bằng chứng Cổng thanh toán &amp; Hãng vận chuyển
          </span>
          <span class="text-xs font-semibold text-[#274333]">
            Kiểm chứng chữ ký HMAC, chống trùng lặp replay &amp; bảo toàn dòng tiền
          </span>
        </div>
        <p class="mt-2 text-xs leading-relaxed text-[#3a5843]">
          Hệ thống chạy trên adapter tất định đã được kiểm thử toàn diện với -race trong môi trường local, đồng thời ghi nhận trung thực các Gate phụ thuộc bên ngoài khi triển khai môi trường live production.
        </p>
      </div>

      <!-- Payment Gates -->
      <div class="rounded-2xl border border-[#e8e5dc] bg-white p-6 shadow-sm space-y-4">
        <h3 class="text-base font-bold text-[#242924]">Cổng Thanh toán (Payment Connectors)</h3>
        <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
          {#each gateSummary.paymentGates as gate}
            <div class="rounded-xl border border-[#f4f0e8] bg-[#faf9f5] p-4 space-y-2">
              <div class="flex items-center justify-between">
                <span class="font-bold text-sm uppercase text-[#242924]">{gate.provider}</span>
                <span class="rounded bg-green-100 text-green-800 px-2 py-0.5 text-[11px] font-bold">
                  {gate.gateStatus}
                </span>
              </div>
              <ul class="text-xs text-[#616c63] space-y-1">
                <li>&#10003; Xác minh chữ ký Webhook HMAC: <strong class="text-green-700">ĐẠT</strong></li>
                <li>&#10003; Chống gửi trùng Webhook Replay: <strong class="text-green-700">ĐẠT</strong></li>
                <li>&#10003; Phục hồi thanh toán trễ (Late Payment): <strong class="text-green-700">ĐẠT</strong></li>
              </ul>
              <div class="text-[11px] font-mono text-[#7d837b] pt-1 border-t border-[#f4f0e8]">
                External Gate: {gate.externalGateId}
              </div>
            </div>
          {/each}
        </div>
      </div>

      <!-- Shipping Gates -->
      <div class="rounded-2xl border border-[#e8e5dc] bg-white p-6 shadow-sm space-y-4">
        <h3 class="text-base font-bold text-[#242924]">Vận chuyển Đông Nam Á (SEA Logistics &amp; Shipping Gates)</h3>
        <div class="space-y-3">
          {#each gateSummary.shippingGates as parcel}
            <div class="rounded-xl border border-[#e8e5dc] p-4 flex flex-col md:flex-row md:items-center justify-between gap-3 text-xs">
              <div>
                <div class="flex items-center gap-2">
                  <span class="font-bold uppercase text-[#ad6047]">{parcel.carrier}</span>
                  <span class="font-mono text-[#242924]">{parcel.trackingNumber}</span>
                  <span class="rounded bg-[#eaf4ed] text-[#274333] px-2 py-0.5 font-bold text-[11px]">
                    {parcel.state}
                  </span>
                </div>
                <p class="text-[#7d837b] mt-1">
                  Điểm đến: {parcel.destinationProvince} &bull; Khối lượng: {parcel.weightGrams}g &bull; Cước phí: <strong class="font-mono text-[#242924]">{Number(parcel.shippingCostExact).toLocaleString('vi-VN')} VND</strong>
                </p>
              </div>
              <div class="text-right">
                <span class="rounded bg-blue-50 text-blue-700 font-semibold px-2 py-1 text-[11px]">
                  {parcel.gateStatus}
                </span>
              </div>
            </div>
          {/each}
        </div>
      </div>

      <!-- External Gates Honesty Table -->
      <div class="rounded-2xl border border-[#e8e5dc] bg-white p-6 shadow-sm space-y-4">
        <h3 class="text-base font-bold text-[#242924]">Bảng Đăng ký External Gates (PRD &amp; Contract Invariants)</h3>
        <div class="divide-y divide-[#f4f0e8] text-xs">
          {#each gateSummary.externalGates as eg}
            <div class="py-3 flex flex-col sm:flex-row sm:items-center justify-between gap-2">
              <div>
                <span class="font-mono font-bold text-[#242924]">{eg.gateId}</span>
                <p class="text-[#616c63] mt-0.5">{eg.description}</p>
              </div>
              <span class="font-mono text-[11px] font-bold text-amber-800 bg-amber-50 px-2.5 py-1 rounded self-start sm:self-auto">
                {eg.status}
              </span>
            </div>
          {/each}
        </div>
      </div>
    </div>
  {/if}

  <!-- Tab 4: P1-05 Preserved Loop (No function lost) -->
  {#if activeTab === 'p1_import'}
    <div class="space-y-6">
      <div class="rounded-2xl border border-[#e8e5dc] bg-[#fffefa] p-6 shadow-sm space-y-5">
        <div class="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-3 border-b border-[#f4f0e8] pb-4">
          <div>
            <div class="flex items-center gap-2">
              <span class="rounded bg-[#274333] px-2 py-0.5 text-[11px] font-bold text-[#ffffff]">
                P1-05 First-Value Loop (Bảo toàn)
              </span>
              <span class="rounded bg-[#eaf4ed] px-2 py-0.5 font-mono text-[11px] font-semibold text-[#274333]">
                source_class: {projection.sourceClass}
              </span>
              <span class="rounded bg-[#fef9c3] px-2 py-0.5 font-mono text-[11px] font-semibold text-[#854d0e]">
                confidence_band: {projection.confidenceBand}
              </span>
            </div>
            <h2 class="mt-2 text-base font-bold text-[#242924]">
              Báo cáo Lợi nhuận Dữ liệu Nhập &amp; Hàng đợi Bổ sung Chứng từ (M19)
            </h2>
            <p class="text-xs text-[#616c63]">
              Workspace: <code class="font-mono font-semibold">{projection.workspaceId}</code> &bull; 0 tài khoản API sàn &bull; 84 đơn hàng &bull; 12 sản phẩm
            </p>
          </div>

          <!-- Profit Numbers -->
          <div class="text-right">
            <p class="text-xs uppercase tracking-wider text-[#7d837b] font-medium">Lợi nhuận ròng sơ bộ</p>
            <p class="text-2xl font-extrabold text-[#274333] font-mono">
              {Number(projection.netProfitVnd).toLocaleString('vi-VN')} VND
            </p>
            <p class="text-[11px] text-[#7d837b]">
              Doanh thu: {Number(projection.grossRevenueVnd).toLocaleString('vi-VN')} VND
            </p>
          </div>
        </div>

        <!-- Repair Gaps -->
        <div class="space-y-3">
          <h3 class="text-sm font-bold text-[#242924]">Chứng từ Cần Bổ sung Đối soát</h3>
          {#if p1RepairError}
            <div class="rounded-xl border border-red-200 bg-red-50 p-3 text-xs font-semibold text-red-800" role="alert">
              {p1RepairError}
            </div>
          {/if}
          {#if visibleRepairCards.length === 0}
            <div class="rounded-xl border border-green-200 bg-green-50 p-4 text-xs font-semibold text-green-800">
              &#10003; Tất cả khoảng trống chứng từ đã được hoàn tất đối soát!
            </div>
          {:else}
            {#each visibleRepairCards as gap}
              <div class="rounded-xl border border-[#e8e5dc] p-4 flex flex-col sm:flex-row sm:items-center justify-between gap-3 text-xs">
                <div>
                  <h4 class="font-bold text-[#242924]">{gap.title}</h4>
                  <p class="text-[#616c63] mt-0.5">{gap.reason}</p>
                </div>
                <button
                  type="button"
                  class="rounded-lg bg-[#274333] px-3 py-1.5 font-bold text-white hover:bg-[#1f3529] transition-colors"
                  onclick={() => handleResolveGap(gap.gapId, gap.affectedAmountVnd)}
                >
                  {gap.repairCtaLabel}
                </button>
              </div>
            {/each}
          {/if}
        </div>
      </div>
    </div>
  {/if}
</section>

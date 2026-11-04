<script lang="ts">
  import {
    type MembershipPlan,
    type MRRSummary,
    validateBuyerPrivilegeBoundary,
  } from '$lib/commerce';

  const workspaceId = 'ws-store-demo-01';

  let plans = $state<MembershipPlan[]>([
    {
      planId: 'plan-supporter',
      workspaceId,
      title: 'Supporter Tier (Người ủng hộ)',
      description: 'Hỗ trợ kênh và nhận huy hiệu người hâm mộ độc quyền',
      price: '49000.000000',
      currency: 'VND',
      billingInterval: 'monthly',
      benefitsJson: [
        { title: 'Huy hiệu Supporter trong bình luận' },
        { title: 'Xem bài viết hậu trường độc quyền' },
      ],
      entitlementConfigJson: {
        exclusiveContent: true,
      },
      status: 'active',
      subscriberCount: 230,
      createdAt: '2026-10-01T00:00:00Z',
      updatedAt: '2026-11-01T00:00:00Z',
    },
    {
      planId: 'plan-vip-pro',
      workspaceId,
      title: 'VIP Creator Club',
      description: 'Truy cập toàn bộ thư viện tài nguyên số và nhóm Discord VIP',
      price: '199000.000000',
      currency: 'VND',
      billingInterval: 'monthly',
      benefitsJson: [
        { title: 'Tải miễn phí mọi Presets & Templates mới' },
        { title: 'Phòng chat Discord VIP với Creator' },
        { title: 'Xem sớm video trước 48 giờ' },
      ],
      entitlementConfigJson: {
        exclusiveContent: true,
        discordRole: 'vip_creator',
        earlyAccessHours: 48,
        discountPercent: 15,
      },
      status: 'active',
      subscriberCount: 185,
      createdAt: '2026-10-15T00:00:00Z',
      updatedAt: '2026-11-03T00:00:00Z',
    },
    {
      planId: 'plan-mastermind',
      workspaceId,
      title: 'Mastermind 1-on-1 (Hàng năm)',
      description: 'Coaching 1-1 hàng tháng và review kênh chuyên sâu',
      price: '4990000.000000',
      currency: 'VND',
      billingInterval: 'yearly',
      benefitsJson: [
        { title: '1 cuộc gọi coaching 1:1 mỗi tháng' },
        { title: 'Review và audit kịch bản video riêng' },
      ],
      entitlementConfigJson: {
        exclusiveContent: true,
      },
      status: 'draft',
      subscriberCount: 0,
      createdAt: '2026-11-02T00:00:00Z',
      updatedAt: '2026-11-02T00:00:00Z',
    },
  ]);

  let mrrSummary = $state<MRRSummary>({
    currentMrr: '48085000', // 230 * 49k + 185 * 199k
    currency: 'VND',
    activeSubscribers: 415,
    churnRate: 2.1,
    averageLtv: '2388000',
    trialConversionRate: 45.2,
  });

  // Acceptance Target 3: Privilege Boundary Demonstration
  const testPrivilegeCheck = $derived(
    validateBuyerPrivilegeBoundary(true, 'store:manage')
  );
</script>

<svelte:head>
  <title>Quản lý Gói Hội viên & MRR (Memberships) — Creativanta</title>
</svelte:head>

<div class="space-y-8 p-6 max-w-7xl mx-auto">
  <!-- Header -->
  <div class="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4 border-b border-neutral-200 pb-4">
    <div>
      <h1 class="text-2xl font-bold tracking-tight text-neutral-900">Quản lý Hội viên & Doanh thu Định kỳ (MRR)</h1>
      <p class="text-sm text-neutral-600 mt-1">
        Mô hình Hội viên định kỳ (W071, Module M15) — Tích hợp nội dung độc quyền, đặc quyền cộng đồng và phân tích MRR.
      </p>
    </div>
    <div class="flex items-center gap-3">
      <a
        href="/store"
        class="inline-flex items-center px-4 py-2 text-sm font-medium text-neutral-700 bg-white border border-neutral-300 rounded-md hover:bg-neutral-50 shadow-sm"
      >
        &larr; Về Cửa hàng
      </a>
      <button
        type="button"
        class="inline-flex items-center px-4 py-2 text-sm font-medium text-white bg-indigo-600 rounded-md hover:bg-indigo-700 shadow-sm"
      >
        + Tạo gói hội viên mới
      </button>
    </div>
  </div>

  <!-- KPI Overview -->
  <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-5 gap-4">
    <div class="p-4 bg-white border border-neutral-200 rounded-lg shadow-sm">
      <div class="text-xs font-semibold text-neutral-500 uppercase tracking-wider">Doanh thu định kỳ (MRR)</div>
      <div class="mt-2 text-2xl font-bold text-neutral-900">48.085.000 {mrrSummary.currency}</div>
      <div class="text-xs text-emerald-600 mt-1">&uarr; +18.4% tháng này</div>
    </div>
    <div class="p-4 bg-white border border-neutral-200 rounded-lg shadow-sm">
      <div class="text-xs font-semibold text-neutral-500 uppercase tracking-wider">Thành viên đang hoạt động</div>
      <div class="mt-2 text-2xl font-bold text-neutral-900">{mrrSummary.activeSubscribers}</div>
      <div class="text-xs text-neutral-500 mt-1">Từ 2 gói kích hoạt</div>
    </div>
    <div class="p-4 bg-white border border-neutral-200 rounded-lg shadow-sm">
      <div class="text-xs font-semibold text-neutral-500 uppercase tracking-wider">Tỷ lệ hủy (Churn Rate)</div>
      <div class="mt-2 text-2xl font-bold text-emerald-600">{mrrSummary.churnRate}%</div>
      <div class="text-xs text-neutral-500 mt-1">Dưới ngưỡng benchmark 3%</div>
    </div>
    <div class="p-4 bg-white border border-neutral-200 rounded-lg shadow-sm">
      <div class="text-xs font-semibold text-neutral-500 uppercase tracking-wider">Giá trị vòng đời (LTV)</div>
      <div class="mt-2 text-2xl font-bold text-neutral-900">2.388.000 {mrrSummary.currency}</div>
      <div class="text-xs text-neutral-500 mt-1">Dự phóng 12 tháng</div>
    </div>
    <div class="p-4 bg-white border border-neutral-200 rounded-lg shadow-sm">
      <div class="text-xs font-semibold text-neutral-500 uppercase tracking-wider">Chuyển đổi dùng thử</div>
      <div class="mt-2 text-2xl font-bold text-neutral-900">{mrrSummary.trialConversionRate}%</div>
      <div class="text-xs text-emerald-600 mt-1">&uarr; +5.1% so với tháng trước</div>
    </div>
  </div>

  <!-- Acceptance Target 3: Security & Privilege Boundary Banner -->
  <div class="p-4 rounded-lg bg-indigo-50 border border-indigo-200">
    <div class="flex items-start justify-between">
      <div class="space-y-1">
        <h3 class="text-sm font-bold text-indigo-950">
          Hàng rào bảo mật đặc quyền Người mua (Acceptance Target 3: Buyer subscription cannot unlock SaaS privileges)
        </h3>
        <p class="text-xs text-indigo-800 leading-relaxed">
          Đăng ký hội viên cửa hàng người mua (bảng <code>membership_subscriptions</code>) chỉ mở khóa nội dung độc quyền, chiết khấu và huy hiệu cộng đồng.
          Cơ chế RBAC đảm bảo tuyệt đối người mua <strong>KHÔNG BAO GIỜ</strong> có thể leo thang đặc quyền để truy cập cấu hình SaaS Workspace (như <code>store:manage</code>, <code>product:manage</code>, <code>workspace:admin</code>).
        </p>
      </div>
      <span class="inline-flex px-2.5 py-1 text-xs font-bold rounded bg-indigo-200 text-indigo-900 shrink-0">
        RBAC Isolated
      </span>
    </div>
    <div class="mt-3 p-2.5 rounded bg-white border border-indigo-200 font-mono text-[11px] text-neutral-700">
      Kiểm tra thử nghiệm cố gắng gán <code>store:manage</code> cho Buyer Subscription &rarr;
      <span class="text-rose-600 font-bold">
        {testPrivilegeCheck.reason}
      </span>
    </div>
  </div>

  <!-- Membership Plans List -->
  <div class="space-y-4">
    <div class="flex items-center justify-between">
      <h2 class="text-lg font-bold text-neutral-900">Các gói Hội viên hiện có</h2>
      <span class="text-xs text-neutral-500">{plans.length} gói cấu hình</span>
    </div>

    <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
      {#each plans as plan}
        <div class="p-6 bg-white border border-neutral-200 rounded-lg shadow-sm flex flex-col justify-between">
          <div>
            <div class="flex items-center justify-between">
              <span class="inline-flex px-2 py-0.5 rounded text-xs font-semibold {plan.status === 'active' ? 'bg-emerald-100 text-emerald-800' : 'bg-neutral-100 text-neutral-600'}">
                {plan.status === 'active' ? 'Đang hoạt động' : 'Bản nháp'}
              </span>
              <span class="text-xs font-medium text-neutral-500">
                {plan.subscriberCount} thành viên
              </span>
            </div>
            <h3 class="mt-3 text-lg font-bold text-neutral-900">{plan.title}</h3>
            <p class="mt-1 text-xs text-neutral-600 leading-relaxed">{plan.description}</p>
            <div class="mt-4 flex items-baseline gap-1">
              <span class="text-2xl font-extrabold text-neutral-900">{parseInt(plan.price).toLocaleString()}</span>
              <span class="text-xs font-semibold text-neutral-500">{plan.currency} / {plan.billingInterval === 'yearly' ? 'năm' : 'tháng'}</span>
            </div>
            <div class="mt-4 pt-4 border-t border-neutral-100 space-y-2">
              <div class="text-xs font-bold text-neutral-700">Quyền lợi thành viên:</div>
              {#each plan.benefitsJson as b}
                <div class="flex items-center gap-2 text-xs text-neutral-600">
                  <span class="text-emerald-500">✓</span>
                  <span>{b.title}</span>
                </div>
              {/each}
            </div>
          </div>
          <div class="mt-6 pt-4 border-t border-neutral-200 flex items-center justify-between">
            <button
              type="button"
              class="text-xs font-semibold text-indigo-600 hover:text-indigo-900"
            >
              Chỉnh sửa gói
            </button>
            <button
              type="button"
              class="text-xs font-semibold text-neutral-500 hover:text-neutral-800"
            >
              Xem danh sách ({plan.subscriberCount})
            </button>
          </div>
        </div>
      {/each}
    </div>
  </div>
</div>

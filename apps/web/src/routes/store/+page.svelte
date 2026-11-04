<script lang="ts">
  import {
    type StorePage,
    type Bundle,
    type PageStats,
    checkBundleStockAtomic,
  } from '$lib/commerce';

  const workspaceId = 'ws-store-demo-01';

  let pages = $state<StorePage[]>([
    {
      storePageId: 'page-main-store',
      workspaceId,
      title: 'Cửa hàng chính — Creativanta Shop',
      slug: 'main-store',
      description: 'Trang bán sản phẩm số, khóa học và gói tài nguyên creator',
      layoutJson: {
        sections: [
          { id: 'sec-hero', type: 'hero', title: 'Chào mừng bạn đến với Creator Shop' },
          { id: 'sec-feat', type: 'featured_products', title: 'Sản phẩm nổi bật' },
          { id: 'sec-bun', type: 'bundles', title: 'Combo tiết kiệm' },
          { id: 'sec-mem', type: 'memberships', title: 'Gói Hội viên VIP' },
        ],
      },
      themeOverridesJson: {
        primaryColor: '#0ea5e9',
        fontFamily: 'Inter',
        borderRadius: '8px',
      },
      status: 'published',
      customDomain: 'shop.creativanta.example',
      seoConfigJson: {
        metaTitle: 'Creativanta Shop — Sản phẩm số cho Creator',
        metaDescription: 'Presets, templates, ebook và hội viên độc quyền',
      },
      widgetConfigJson: {
        floatingBuyButton: true,
        chatWidget: true,
        announcementBar: 'Ưu đãi tháng 11: Giảm 20% cho thành viên mới!',
      },
      createdAt: '2026-11-01T08:00:00Z',
      updatedAt: '2026-11-04T06:00:00Z',
    },
    {
      storePageId: 'page-black-friday',
      workspaceId,
      title: 'Landing Page Black Friday 2026',
      slug: 'black-friday-2026',
      description: 'Trang khuyến mãi Black Friday độc quyền',
      layoutJson: {
        sections: [
          { id: 'sec-bf-hero', type: 'hero', title: 'Black Friday Siêu Giảm Giá' },
          { id: 'sec-bf-bun', type: 'bundles', title: 'Gói Siêu Cấp Bundle' },
        ],
      },
      themeOverridesJson: {
        primaryColor: '#e11d48',
        fontFamily: 'Roboto',
        borderRadius: '12px',
      },
      status: 'draft',
      seoConfigJson: {
        metaTitle: 'Black Friday Deals — Creativanta',
      },
      widgetConfigJson: {
        floatingBuyButton: true,
      },
      createdAt: '2026-11-03T10:00:00Z',
      updatedAt: '2026-11-04T05:30:00Z',
    },
  ]);

  let stats = $state<PageStats>({
    storePageId: 'page-main-store',
    views: 14850,
    orders: 342,
    conversionRate: 2.3,
    revenue: '48500000.000000',
    currency: 'VND',
  });

  // Bundle stock demo
  const sampleBundle: Bundle = {
    bundleId: 'bun-camera-kit',
    workspaceId,
    title: 'Combo Thiết Bị & Preset Quay Phim',
    bundlePrice: '1890000.000000',
    currency: 'VND',
    isActive: true,
    items: [
      { productId: 'p-mic', quantity: 1, productTitle: 'Microphone Lavalier', availableStock: 12 },
      { productId: 'p-lut', quantity: 1, productTitle: 'Cinematic LUTs Pack', availableStock: 999 },
      { productId: 'p-tripod', quantity: 1, productTitle: 'Mini Tripod', availableStock: 0 },
    ],
    createdAt: '2026-11-01T00:00:00Z',
    updatedAt: '2026-11-01T00:00:00Z',
  };

  const bundleStockCheck = $derived(
    checkBundleStockAtomic(
      sampleBundle,
      {
        'p-mic': 12,
        'p-lut': 999,
        'p-tripod': 0, // Out of stock -> Target 1
      },
      1
    )
  );

  function togglePublish(pageId: string) {
    pages = pages.map((p) => {
      if (p.storePageId === pageId) {
        return {
          ...p,
          status: p.status === 'published' ? 'draft' : 'published',
          updatedAt: new Date().toISOString(),
        };
      }
      return p;
    });
  }
</script>

<svelte:head>
  <title>Creator Store & Storefront Builder — Creativanta</title>
</svelte:head>

<div class="space-y-8 p-6 max-w-7xl mx-auto">
  <!-- Header -->
  <div class="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4 border-b border-neutral-200 pb-4">
    <div>
      <h1 class="text-2xl font-bold tracking-tight text-neutral-900">Creator Store & Storefront</h1>
      <p class="text-sm text-neutral-600 mt-1">
        Xây dựng cửa hàng số, gói combo (bundles), giao hàng tự động và quản lý trang đích (Module M15).
      </p>
    </div>
    <div class="flex items-center gap-3">
      <a
        href="/memberships"
        class="inline-flex items-center px-4 py-2 text-sm font-medium text-neutral-700 bg-white border border-neutral-300 rounded-md hover:bg-neutral-50 shadow-sm"
      >
        Quản lý Hội viên (MRR) &rarr;
      </a>
      <button
        type="button"
        class="inline-flex items-center px-4 py-2 text-sm font-medium text-white bg-indigo-600 rounded-md hover:bg-indigo-700 shadow-sm"
      >
        + Tạo trang cửa hàng mới
      </button>
    </div>
  </div>

  <!-- KPI Overview -->
  <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4">
    <div class="p-4 bg-white border border-neutral-200 rounded-lg shadow-sm">
      <div class="text-xs font-semibold text-neutral-500 uppercase tracking-wider">Tổng lượt xem</div>
      <div class="mt-2 text-2xl font-bold text-neutral-900">{stats.views.toLocaleString()}</div>
      <div class="text-xs text-emerald-600 mt-1">&uarr; +14.2% so với tháng trước</div>
    </div>
    <div class="p-4 bg-white border border-neutral-200 rounded-lg shadow-sm">
      <div class="text-xs font-semibold text-neutral-500 uppercase tracking-wider">Đơn hàng thành công</div>
      <div class="mt-2 text-2xl font-bold text-neutral-900">{stats.orders}</div>
      <div class="text-xs text-neutral-500 mt-1">Tỷ lệ chuyển đổi: {stats.conversionRate}%</div>
    </div>
    <div class="p-4 bg-white border border-neutral-200 rounded-lg shadow-sm">
      <div class="text-xs font-semibold text-neutral-500 uppercase tracking-wider">Doanh thu cửa hàng</div>
      <div class="mt-2 text-2xl font-bold text-neutral-900">48.500.000 {stats.currency}</div>
      <div class="text-xs text-emerald-600 mt-1">&uarr; +22.8% tăng trưởng</div>
    </div>
    <div class="p-4 bg-white border border-neutral-200 rounded-lg shadow-sm">
      <div class="text-xs font-semibold text-neutral-500 uppercase tracking-wider">Trạng thái tên miền riêng</div>
      <div class="mt-2 text-sm font-semibold text-emerald-700 flex items-center gap-1.5">
        <span class="inline-block w-2.5 h-2.5 rounded-full bg-emerald-500"></span>
        shop.creativanta.example (SSL Active)
      </div>
      <div class="text-xs text-neutral-500 mt-1">Cloudflare CNAME Verified</div>
    </div>
  </div>

  <!-- Acceptance Target 1: Bundle Stock Atomicity Indicator -->
  <div class="p-4 rounded-lg border {bundleStockCheck.isAvailable ? 'bg-emerald-50 border-emerald-200' : 'bg-amber-50 border-amber-200'}">
    <div class="flex items-start justify-between">
      <div>
        <h3 class="text-sm font-bold {bundleStockCheck.isAvailable ? 'text-emerald-900' : 'text-amber-900'}">
          Kiểm tra tồn kho Bundle nguyên tử (Acceptance Target 1: Bundle stock atomic)
        </h3>
        <p class="text-xs mt-1 {bundleStockCheck.isAvailable ? 'text-emerald-700' : 'text-amber-800'}">
          {#if bundleStockCheck.isAvailable}
            Tất cả các thành phần trong bundle đều còn hàng. Sẵn sàng thanh toán!
          {:else}
            <strong>Cảnh báo tồn kho:</strong> {bundleStockCheck.reason}. Hệ thống tự động khóa nút mua bundle để tránh rò rỉ đơn hàng thiếu linh kiện.
          {/if}
        </p>
      </div>
      <span class="inline-flex px-2 py-1 text-xs font-bold rounded {bundleStockCheck.isAvailable ? 'bg-emerald-200 text-emerald-800' : 'bg-amber-200 text-amber-900'}">
        {bundleStockCheck.isAvailable ? 'Sẵn sàng' : 'Tạm hết hàng'}
      </span>
    </div>
    <div class="mt-3 grid grid-cols-1 sm:grid-cols-3 gap-2">
      {#each bundleStockCheck.stockBreakdown as item}
        <div class="p-2 rounded bg-white/70 border border-neutral-200 text-xs">
          <div class="font-medium text-neutral-800">{item.productTitle}</div>
          <div class="flex justify-between mt-1 text-neutral-600">
            <span>Yêu cầu: {item.requiredPerUnit}</span>
            <span class="font-semibold {item.isSufficient ? 'text-emerald-600' : 'text-rose-600'}">
              Tồn kho: {item.availableStock}
            </span>
          </div>
        </div>
      {/each}
    </div>
  </div>

  <!-- Store Pages Table -->
  <div class="bg-white border border-neutral-200 rounded-lg shadow-sm overflow-hidden">
    <div class="px-6 py-4 border-b border-neutral-200 flex justify-between items-center">
      <h2 class="text-base font-bold text-neutral-900">Danh sách Trang cửa hàng</h2>
      <span class="text-xs text-neutral-500">{pages.length} trang cấu hình</span>
    </div>
    <table class="min-w-full divide-y divide-neutral-200 text-sm">
      <thead class="bg-neutral-50 text-neutral-500 font-semibold text-xs uppercase tracking-wider text-left">
        <tr>
          <th class="px-6 py-3">Tiêu đề & Đường dẫn</th>
          <th class="px-4 py-3">Bố cục</th>
          <th class="px-4 py-3">Tên miền</th>
          <th class="px-4 py-3">Trạng thái</th>
          <th class="px-4 py-3">Cập nhật</th>
          <th class="px-6 py-3 text-right">Thao tác</th>
        </tr>
      </thead>
      <tbody class="divide-y divide-neutral-200">
        {#each pages as page}
          <tr class="hover:bg-neutral-50 transition">
            <td class="px-6 py-4">
              <div class="font-medium text-neutral-900">{page.title}</div>
              <div class="text-xs text-neutral-500 font-mono mt-0.5">/{page.slug}</div>
            </td>
            <td class="px-4 py-4 text-xs text-neutral-600">
              <span class="inline-flex items-center px-2 py-0.5 rounded bg-neutral-100 text-neutral-700">
                {page.layoutJson.sections.length} khối nội dung
              </span>
            </td>
            <td class="px-4 py-4 text-xs font-mono text-neutral-700">
              {page.customDomain || 'creativanta.me/' + page.slug}
            </td>
            <td class="px-4 py-4">
              <span
                class="inline-flex px-2 py-0.5 rounded-full text-xs font-semibold {page.status === 'published'
                  ? 'bg-emerald-100 text-emerald-800'
                  : 'bg-neutral-100 text-neutral-700'}"
              >
                {page.status === 'published' ? 'Đã xuất bản' : 'Bản nháp'}
              </span>
            </td>
            <td class="px-4 py-4 text-xs text-neutral-500">
              {new Date(page.updatedAt).toLocaleDateString()}
            </td>
            <td class="px-6 py-4 text-right space-x-2">
              <a
                href="/store/{page.storePageId}/edit"
                class="text-xs font-semibold text-indigo-600 hover:text-indigo-900"
              >
                Chỉnh sửa
              </a>
              <button
                type="button"
                onclick={() => togglePublish(page.storePageId)}
                class="text-xs font-semibold {page.status === 'published' ? 'text-amber-600 hover:text-amber-900' : 'text-emerald-600 hover:text-emerald-900'}"
              >
                {page.status === 'published' ? 'Gỡ xuất bản' : 'Xuất bản'}
              </button>
            </td>
          </tr>
        {/each}
      </tbody>
    </table>
  </div>
</div>

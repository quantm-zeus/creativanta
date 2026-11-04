<script lang="ts">
  import { page } from '$app/state';
  import { type StorePage } from '$lib/commerce';

  const pageId = page.params.id;

  let storePage = $state<StorePage>({
    storePageId: pageId,
    workspaceId: 'ws-store-demo-01',
    title: 'Cửa hàng chính — Creativanta Shop',
    slug: 'main-store',
    description: 'Trang bán sản phẩm số, presets và combo gói độc quyền',
    layoutJson: {
      sections: [
        { id: 'sec-hero', type: 'hero', title: 'Chào mừng bạn đến với Creator Shop' },
        { id: 'sec-feat', type: 'featured_products', title: 'Sản phẩm nổi bật' },
        { id: 'sec-bun', type: 'bundles', title: 'Combo bundles tiết kiệm' },
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
  });

  let activeTab = $state<'sections' | 'theme' | 'seo' | 'widgets'>('sections');
  let saveSuccess = $state(false);

  function addSection(type: 'hero' | 'featured_products' | 'bundles' | 'memberships' | 'testimonials' | 'faq') {
    const newId = `sec-${Date.now()}`;
    const titles: Record<string, string> = {
      hero: 'Banner chính',
      featured_products: 'Sản phẩm nổi bật',
      bundles: 'Combo Bundle',
      memberships: 'Hội viên độc quyền',
      testimonials: 'Đánh giá từ khách hàng',
      faq: 'Câu hỏi thường gặp',
    };
    storePage.layoutJson.sections.push({
      id: newId,
      type,
      title: titles[type] ?? 'Khối mới',
    });
  }

  function removeSection(index: number) {
    storePage.layoutJson.sections.splice(index, 1);
  }

  function handleSave() {
    saveSuccess = true;
    setTimeout(() => {
      saveSuccess = false;
    }, 3000);
  }
</script>

<svelte:head>
  <title>Chỉnh sửa Trang cửa hàng ({storePage.title}) — Creativanta</title>
</svelte:head>

<div class="space-y-6 p-6 max-w-7xl mx-auto">
  <!-- Top bar -->
  <div class="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4 border-b border-neutral-200 pb-4">
    <div class="flex items-center gap-3">
      <a href="/store" class="text-neutral-500 hover:text-neutral-800 text-sm font-medium">
        &larr; Cửa hàng
      </a>
      <span class="text-neutral-300">/</span>
      <div>
        <h1 class="text-xl font-bold text-neutral-900">{storePage.title}</h1>
        <p class="text-xs text-neutral-500 font-mono">ID: {storePage.storePageId} • /{storePage.slug}</p>
      </div>
    </div>
    <div class="flex items-center gap-3">
      {#if saveSuccess}
        <span class="text-xs text-emerald-600 font-medium">✓ Đã lưu thay đổi</span>
      {/if}
      <a
        href="https://{storePage.customDomain || 'creativanta.me/' + storePage.slug}"
        target="_blank"
        rel="noopener noreferrer"
        class="px-3 py-1.5 text-xs font-semibold text-neutral-700 bg-white border border-neutral-300 rounded hover:bg-neutral-50"
      >
        Xem trang trực tiếp &nearr;
      </a>
      <button
        type="button"
        onclick={handleSave}
        class="px-4 py-1.5 text-xs font-semibold text-white bg-indigo-600 rounded hover:bg-indigo-700"
      >
        Lưu cấu hình
      </button>
    </div>
  </div>

  <!-- Editor tabs -->
  <div class="border-b border-neutral-200">
    <nav class="flex space-x-6 text-sm">
      <button
        type="button"
        onclick={() => (activeTab = 'sections')}
        class="pb-3 font-medium border-b-2 {activeTab === 'sections'
          ? 'border-indigo-600 text-indigo-600'
          : 'border-transparent text-neutral-500 hover:text-neutral-800'}"
      >
        Khối bố cục ({storePage.layoutJson.sections.length})
      </button>
      <button
        type="button"
        onclick={() => (activeTab = 'theme')}
        class="pb-3 font-medium border-b-2 {activeTab === 'theme'
          ? 'border-indigo-600 text-indigo-600'
          : 'border-transparent text-neutral-500 hover:text-neutral-800'}"
      >
        Giao diện & Màu sắc
      </button>
      <button
        type="button"
        onclick={() => (activeTab = 'seo')}
        class="pb-3 font-medium border-b-2 {activeTab === 'seo'
          ? 'border-indigo-600 text-indigo-600'
          : 'border-transparent text-neutral-500 hover:text-neutral-800'}"
      >
        Tên miền riêng & SEO
      </button>
      <button
        type="button"
        onclick={() => (activeTab = 'widgets')}
        class="pb-3 font-medium border-b-2 {activeTab === 'widgets'
          ? 'border-indigo-600 text-indigo-600'
          : 'border-transparent text-neutral-500 hover:text-neutral-800'}"
      >
        Widgets & Tương tác
      </button>
    </nav>
  </div>

  <!-- Tab Content -->
  {#if activeTab === 'sections'}
    <div class="grid grid-cols-1 lg:grid-cols-3 gap-6">
      <div class="lg:col-span-2 space-y-4">
        {#each storePage.layoutJson.sections as sec, idx}
          <div class="p-4 bg-white border border-neutral-200 rounded-lg shadow-sm flex items-center justify-between">
            <div class="flex items-center gap-3">
              <span class="w-6 h-6 rounded bg-neutral-100 text-neutral-600 text-xs font-bold flex items-center justify-center">
                {idx + 1}
              </span>
              <div>
                <div class="text-sm font-semibold text-neutral-900">{sec.title}</div>
                <div class="text-xs text-neutral-500 font-mono">Loại: {sec.type}</div>
              </div>
            </div>
            <button
              type="button"
              onclick={() => removeSection(idx)}
              class="text-xs text-rose-600 hover:text-rose-800 font-semibold"
            >
              Xóa khối
            </button>
          </div>
        {/each}
      </div>
      <div class="p-4 bg-neutral-50 border border-neutral-200 rounded-lg h-fit space-y-3">
        <h3 class="text-sm font-bold text-neutral-900">+ Thêm khối mới</h3>
        <div class="grid grid-cols-2 gap-2 text-xs">
          <button
            type="button"
            onclick={() => addSection('hero')}
            class="p-2 bg-white border border-neutral-200 rounded hover:border-neutral-300 font-medium text-left"
          >
            Banner chính
          </button>
          <button
            type="button"
            onclick={() => addSection('featured_products')}
            class="p-2 bg-white border border-neutral-200 rounded hover:border-neutral-300 font-medium text-left"
          >
            Sản phẩm
          </button>
          <button
            type="button"
            onclick={() => addSection('bundles')}
            class="p-2 bg-white border border-neutral-200 rounded hover:border-neutral-300 font-medium text-left"
          >
            Combo Bundle
          </button>
          <button
            type="button"
            onclick={() => addSection('memberships')}
            class="p-2 bg-white border border-neutral-200 rounded hover:border-neutral-300 font-medium text-left"
          >
            Gói Hội viên
          </button>
          <button
            type="button"
            onclick={() => addSection('testimonials')}
            class="p-2 bg-white border border-neutral-200 rounded hover:border-neutral-300 font-medium text-left"
          >
            Đánh giá
          </button>
          <button
            type="button"
            onclick={() => addSection('faq')}
            class="p-2 bg-white border border-neutral-200 rounded hover:border-neutral-300 font-medium text-left"
          >
            FAQ
          </button>
        </div>
      </div>
    </div>
  {:else if activeTab === 'theme'}
    <div class="p-6 bg-white border border-neutral-200 rounded-lg max-w-xl space-y-4">
      <h3 class="text-base font-bold text-neutral-900">Tùy biến Giao diện</h3>
      <div>
        <label for="primary-color-input" class="block text-xs font-semibold text-neutral-700">Màu chủ đạo (Primary Color)</label>
        <div class="mt-1 flex items-center gap-3">
          <input
            id="primary-color-input"
            type="color"
            bind:value={storePage.themeOverridesJson.primaryColor as string}
            class="w-10 h-10 rounded border border-neutral-200 cursor-pointer"
          />
          <span class="text-xs font-mono text-neutral-600">{storePage.themeOverridesJson.primaryColor}</span>
        </div>
      </div>
      <div>
        <label for="font-family-select" class="block text-xs font-semibold text-neutral-700">Phông chữ (Font Family)</label>
        <select
          id="font-family-select"
          bind:value={storePage.themeOverridesJson.fontFamily}
          class="mt-1 block w-full text-xs rounded border border-neutral-300 p-2"
        >
          <option value="Inter">Inter (Khuyên dùng)</option>
          <option value="Roboto">Roboto</option>
          <option value="Montserrat">Montserrat</option>
          <option value="Playfair Display">Playfair Display (Sang trọng)</option>
        </select>
      </div>
      <div>
        <label for="border-radius-select" class="block text-xs font-semibold text-neutral-700">Bo góc viền (Border Radius)</label>
        <select
          id="border-radius-select"
          bind:value={storePage.themeOverridesJson.borderRadius}
          class="mt-1 block w-full text-xs rounded border border-neutral-300 p-2"
        >
          <option value="4px">Nhỏ (4px)</option>
          <option value="8px">Vừa (8px - Chuẩn)</option>
          <option value="16px">Lớn (16px)</option>
          <option value="9999px">Tròn hoàn toàn</option>
        </select>
      </div>
    </div>
  {:else if activeTab === 'seo'}
    <div class="p-6 bg-white border border-neutral-200 rounded-lg max-w-xl space-y-4">
      <h3 class="text-base font-bold text-neutral-900">Tên miền & Tối ưu SEO</h3>
      <div>
        <label for="custom-domain-input" class="block text-xs font-semibold text-neutral-700">Tên miền tùy chỉnh (Custom Domain)</label>
        <input
          id="custom-domain-input"
          type="text"
          bind:value={storePage.customDomain}
          placeholder="shop.yourdomain.com"
          class="mt-1 block w-full text-xs rounded border border-neutral-300 p-2"
        />
        <p class="text-[11px] text-neutral-500 mt-1">Trỏ CNAME về <code>domains.creativanta.me</code> để kích hoạt chứng chỉ SSL tự động.</p>
      </div>
      <div>
        <label for="meta-title-input" class="block text-xs font-semibold text-neutral-700">Tiêu đề SEO (Meta Title)</label>
        <input
          id="meta-title-input"
          type="text"
          bind:value={storePage.seoConfigJson.metaTitle}
          class="mt-1 block w-full text-xs rounded border border-neutral-300 p-2"
        />
      </div>
      <div>
        <label for="meta-desc-input" class="block text-xs font-semibold text-neutral-700">Mô tả SEO (Meta Description)</label>
        <textarea
          id="meta-desc-input"
          bind:value={storePage.seoConfigJson.metaDescription}
          rows="3"
          class="mt-1 block w-full text-xs rounded border border-neutral-300 p-2"
        ></textarea>
      </div>
    </div>
  {:else if activeTab === 'widgets'}
    <div class="p-6 bg-white border border-neutral-200 rounded-lg max-w-xl space-y-4">
      <h3 class="text-base font-bold text-neutral-900">Cấu hình Widgets</h3>
      <div class="flex items-center justify-between">
        <div>
          <div class="text-sm font-semibold text-neutral-900">Nút Mua Nhanh Nổi (Floating Buy Button)</div>
          <div class="text-xs text-neutral-500">Giữ nút CTA luôn hiển thị khi khách hàng cuộn trang</div>
        </div>
        <input
          type="checkbox"
          bind:checked={storePage.widgetConfigJson.floatingBuyButton}
          class="w-4 h-4 text-indigo-600 rounded"
        />
      </div>
      <div class="flex items-center justify-between pt-2 border-t">
        <div>
          <div class="text-sm font-semibold text-neutral-900">Chat Hỗ Trợ (Chat Widget)</div>
          <div class="text-xs text-neutral-500">Kết nối trực tiếp với Unified Inbox (M12)</div>
        </div>
        <input
          type="checkbox"
          bind:checked={storePage.widgetConfigJson.chatWidget}
          class="w-4 h-4 text-indigo-600 rounded"
        />
      </div>
      <div class="pt-2 border-t">
        <label for="announcement-bar-input" class="block text-xs font-semibold text-neutral-700">Thanh thông báo đầu trang (Announcement Bar)</label>
        <input
          id="announcement-bar-input"
          type="text"
          bind:value={storePage.widgetConfigJson.announcementBar}
          placeholder="Ví dụ: Miễn phí vận chuyển cho đơn hàng từ 500k!"
          class="mt-1 block w-full text-xs rounded border border-neutral-300 p-2"
        />
      </div>
    </div>
  {/if}
</div>

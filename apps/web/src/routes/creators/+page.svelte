<script lang="ts">
  import {
    filterCreatorDirectory,
    type CreatorDirectoryEntry
  } from '$lib/commerce';

  // Seed with published & consented profiles
  let allEntries = $state<CreatorDirectoryEntry[]>([
    {
      mediaKitId: 'mk-lananh-beauty',
      profile: {
        creatorName: 'Lan Anh Beauty',
        headline: 'Beauty & Skincare Creator • Top 10 TikTok Shop Star',
        bio: 'Chuyên đánh giá mỹ phẩm và chia sẻ chu trình dưỡng da chuẩn y khoa. Hơn 5 năm kinh nghiệm hợp tác với các nhãn hàng quốc tế.',
        avatarUrl: '',
        categories: ['Làm đẹp', 'Skincare', 'Mỹ phẩm'],
        languages: ['vi', 'en'],
        publicRates: [
          {
            serviceType: 'TikTok Video 60s (Dedicated)',
            priceMin: 6000000,
            priceMax: 10000000,
            currency: 'VND',
            deliveryDays: 5,
            description: '1 video ngắn trên TikTok + gắn link affiliate sản phẩm'
          },
          {
            serviceType: 'Instagram Reel + 3 Stories',
            priceMin: 4500000,
            priceMax: 7000000,
            currency: 'VND',
            deliveryDays: 3,
            description: 'Đăng tải chéo nền tảng với swipe-up link'
          }
        ],
        socialMetrics: [
          {
            platform: 'TikTok',
            handle: '@lananh.skincare',
            followers: 350000,
            avgViews: 95000,
            engagementRate: 6.8,
            verified: true
          },
          {
            platform: 'Instagram',
            handle: '@lananh.beauty',
            followers: 85000,
            avgViews: 25000,
            engagementRate: 5.2,
            verified: true
          }
        ],
        directoryStatus: 'published',
        directoryOptIn: true
      },
      verifiedBadge: true,
      lastActiveAt: '2026-11-04T18:00:00Z'
    },
    {
      mediaKitId: 'mk-quangtech-review',
      profile: {
        creatorName: 'Quang Tech Studio',
        headline: 'Chuyên gia Mở hộp & Đánh giá Thiết bị Di động',
        bio: 'Phân tích chi tiết điện thoại, laptop, đồ gia dụng thông minh với góc nhìn khách quan và trải nghiệm thực tế sau 1 tháng.',
        avatarUrl: '',
        categories: ['Công nghệ', 'Gadgets', 'Gia dụng thông minh'],
        languages: ['vi'],
        publicRates: [
          {
            serviceType: 'YouTube Video 10-12m (Full Review)',
            priceMin: 15000000,
            priceMax: 22000000,
            currency: 'VND',
            deliveryDays: 7,
            description: 'Đánh giá toàn diện, benchmark pin, hiệu năng và camera'
          },
          {
            serviceType: 'TikTok Tech Shorts 60s',
            priceMin: 5000000,
            priceMax: 8000000,
            currency: 'VND',
            deliveryDays: 4,
            description: 'Tóm tắt 3 điểm mạnh/yếu nổi bật'
          }
        ],
        socialMetrics: [
          {
            platform: 'YouTube',
            handle: 'QuangTechVN',
            followers: 520000,
            avgViews: 140000,
            engagementRate: 7.4,
            verified: true
          },
          {
            platform: 'TikTok',
            handle: '@quangtech',
            followers: 280000,
            avgViews: 80000,
            engagementRate: 6.1,
            verified: false
          }
        ],
        directoryStatus: 'published',
        directoryOptIn: true
      },
      verifiedBadge: true,
      lastActiveAt: '2026-11-04T12:00:00Z'
    },
    {
      mediaKitId: 'mk-bep-nha-mai',
      profile: {
        creatorName: 'Bếp Nhà Mai',
        headline: 'Ẩm thực Gia đình & Nông sản Sạch',
        bio: 'Chia sẻ công thức nấu ăn hằng ngày, review nồi chiên không dầu và các gia vị truyền thống Việt Nam.',
        avatarUrl: '',
        categories: ['Ẩm thực', 'Gia đình', 'Nông sản'],
        languages: ['vi'],
        publicRates: [
          {
            serviceType: 'Video Nấu ăn + Tài trợ Gia vị',
            priceMin: 3500000,
            priceMax: 5500000,
            currency: 'VND',
            deliveryDays: 5
          }
        ],
        socialMetrics: [
          {
            platform: 'TikTok',
            handle: '@bepnhamai',
            followers: 180000,
            avgViews: 45000,
            engagementRate: 8.9,
            verified: true
          }
        ],
        directoryStatus: 'published',
        directoryOptIn: true
      },
      verifiedBadge: true,
      lastActiveAt: '2026-11-03T20:00:00Z'
    }
  ]);

  // Filters state
  let searchQuery = $state('');
  let selectedCategory = $state('all');
  let selectedLanguage = $state('all');

  // Opt-out demonstration toggle for Acceptance Target 2
  let showOptOutTester = $state(false);

  const CATEGORIES = [
    { value: 'all', label: 'Tất cả lĩnh vực' },
    { value: 'làm đẹp', label: 'Làm đẹp & Skincare' },
    { value: 'công nghệ', label: 'Công nghệ & Điện tử' },
    { value: 'ẩm thực', label: 'Ẩm thực & Gia đình' },
    { value: 'gia dụng', label: 'Gia dụng thông minh' }
  ];

  const LANGUAGES = [
    { value: 'all', label: 'Mọi ngôn ngữ' },
    { value: 'vi', label: 'Tiếng Việt' },
    { value: 'en', label: 'English' }
  ];

  let filteredEntries = $derived(
    filterCreatorDirectory(allEntries, {
      query: searchQuery,
      category: selectedCategory,
      language: selectedLanguage
    })
  );

  function toggleOptOut(mediaKitId: string) {
    // Acceptance Target 2: Opt-out removes creator immediately
    allEntries = allEntries.map((e) => {
      if (e.mediaKitId === mediaKitId) {
        const nextStatus = e.profile.directoryStatus === 'published' ? 'hidden' : 'published';
        const nextOptIn = nextStatus === 'published';
        return {
          ...e,
          profile: {
            ...e.profile,
            directoryStatus: nextStatus,
            directoryOptIn: nextOptIn
          }
        };
      }
      return e;
    });
  }

  function clearFilters() {
    searchQuery = '';
    selectedCategory = 'all';
    selectedLanguage = 'all';
  }
</script>

<div class="min-h-screen bg-slate-50 py-10 px-4 sm:px-6 lg:px-8">
  <div class="max-w-7xl mx-auto space-y-8">
    <!-- Header -->
    <div class="text-center max-w-3xl mx-auto space-y-3">
      <div class="inline-flex items-center gap-2 px-3 py-1 rounded-full bg-amber-100 text-amber-900 text-xs font-semibold tracking-wide uppercase">
        <span>Danh Bạ Nhà Sáng Tạo (W134)</span>
      </div>
      <h1 class="text-3xl sm:text-4xl font-extrabold text-slate-900 tracking-tight">
        Kết nối Thương hiệu & Nhà sáng tạo Nội dung
      </h1>
      <p class="text-base sm:text-lg text-slate-600">
        Khám phá các Creator đã xác thực, xem báo giá công khai và gửi đề nghị hợp tác trực tiếp không qua trung gian.
      </p>
    </div>

    <!-- Opt-Out Immediate Removal Verification Bar (Target 2 Demo) -->
    <div class="bg-white border border-slate-200 rounded-xl p-4 shadow-sm">
      <div class="flex flex-col sm:flex-row sm:items-center justify-between gap-3">
        <div>
          <h2 class="text-sm font-semibold text-slate-800 flex items-center gap-1.5">
            <span>🛡️</span> Kiểm thử Quyền riêng tư & Cơ chế Opt-out Ngay lập tức (Target 2 & 3)
          </h2>
          <p class="text-xs text-slate-500 mt-0.5">
            Khi creator tắt chia sẻ (Opt-out), hồ sơ lập tức biến mất khỏi danh bạ công khai và API search.
          </p>
        </div>
        <button
          type="button"
          onclick={() => (showOptOutTester = !showOptOutTester)}
          class="inline-flex items-center justify-center px-3 py-1.5 text-xs font-medium rounded-lg bg-slate-100 hover:bg-slate-200 text-slate-700 transition"
        >
          {showOptOutTester ? 'Ẩn bộ điều khiển Opt-out' : 'Mở bộ điều khiển Opt-out'}
        </button>
      </div>

      {#if showOptOutTester}
        <div class="mt-4 pt-3 border-t border-slate-100 grid grid-cols-1 sm:grid-cols-3 gap-3">
          {#each allEntries as entry}
            <div class="p-3 bg-slate-50 rounded-lg border border-slate-200 flex items-center justify-between">
              <div>
                <div class="text-xs font-bold text-slate-800">{entry.profile.creatorName}</div>
                <div class="text-[11px] text-slate-500">
                  Trạng thái: <span class={entry.profile.directoryOptIn ? 'text-emerald-600 font-semibold' : 'text-rose-600 font-semibold'}>
                    {entry.profile.directoryOptIn ? 'Công khai (Published)' : 'Đã ẩn (Hidden / Opted-out)'}
                  </span>
                </div>
              </div>
              <button
                type="button"
                onclick={() => toggleOptOut(entry.mediaKitId)}
                class="px-2.5 py-1 text-xs font-medium rounded {entry.profile.directoryOptIn ? 'bg-rose-100 hover:bg-rose-200 text-rose-800' : 'bg-emerald-100 hover:bg-emerald-200 text-emerald-800'} transition"
              >
                {entry.profile.directoryOptIn ? 'Opt-Out' : 'Opt-In'}
              </button>
            </div>
          {/each}
        </div>
      {/if}
    </div>

    <!-- Search & Filter Controls -->
    <div class="bg-white rounded-xl border border-slate-200 shadow-sm p-4 space-y-4">
      <div class="grid grid-cols-1 md:grid-cols-4 gap-3">
        <!-- Search Query -->
        <div class="md:col-span-2">
          <label for="search-input" class="block text-xs font-semibold text-slate-700 mb-1">Tìm kiếm theo tên hoặc từ khóa</label>
          <div class="relative">
            <input
              id="search-input"
              type="text"
              bind:value={searchQuery}
              placeholder="VD: Lan Anh, skincare, công nghệ, nấu ăn..."
              class="w-full bg-slate-50 border border-slate-300 rounded-lg px-3 py-2 text-sm text-slate-900 focus:outline-none focus:ring-2 focus:ring-amber-500 focus:bg-white transition"
            />
            {#if searchQuery}
              <button
                type="button"
                onclick={() => (searchQuery = '')}
                class="absolute right-2.5 top-2.5 text-xs text-slate-400 hover:text-slate-600"
              >
                ✕
              </button>
            {/if}
          </div>
        </div>

        <!-- Category -->
        <div>
          <label for="category-select" class="block text-xs font-semibold text-slate-700 mb-1">Lĩnh vực</label>
          <select
            id="category-select"
            bind:value={selectedCategory}
            class="w-full bg-slate-50 border border-slate-300 rounded-lg px-3 py-2 text-sm text-slate-900 focus:outline-none focus:ring-2 focus:ring-amber-500 focus:bg-white transition"
          >
            {#each CATEGORIES as cat}
              <option value={cat.value}>{cat.label}</option>
            {/each}
          </select>
        </div>

        <!-- Language -->
        <div>
          <label for="language-select" class="block text-xs font-semibold text-slate-700 mb-1">Ngôn ngữ</label>
          <select
            id="language-select"
            bind:value={selectedLanguage}
            class="w-full bg-slate-50 border border-slate-300 rounded-lg px-3 py-2 text-sm text-slate-900 focus:outline-none focus:ring-2 focus:ring-amber-500 focus:bg-white transition"
          >
            {#each LANGUAGES as lang}
              <option value={lang.value}>{lang.label}</option>
            {/each}
          </select>
        </div>
      </div>

      <!-- Quick status summary -->
      <div class="flex items-center justify-between text-xs text-slate-500 pt-2 border-t border-slate-100">
        <div>
          Hiển thị <strong>{filteredEntries.length}</strong> nhà sáng tạo sẵn sàng hợp tác
        </div>
        {#if searchQuery || selectedCategory !== 'all' || selectedLanguage !== 'all'}
          <button
            type="button"
            onclick={clearFilters}
            class="text-amber-600 hover:text-amber-700 font-medium underline"
          >
            Xóa bộ lọc
          </button>
        {/if}
      </div>
    </div>

    <!-- Creator Cards Grid -->
    {#if filteredEntries.length === 0}
      <div class="bg-white rounded-xl border border-slate-200 p-12 text-center space-y-4">
        <div class="text-4xl">🔍</div>
        <h3 class="text-lg font-bold text-slate-900">Không tìm thấy nhà sáng tạo phù hợp</h3>
        <p class="text-sm text-slate-500 max-w-md mx-auto">
          Không có kết quả nào khớp với bộ lọc hiện tại. Thử đổi từ khóa hoặc xóa bớt tiêu chí lọc.
        </p>
        <button
          type="button"
          onclick={clearFilters}
          class="inline-flex items-center px-4 py-2 text-sm font-semibold rounded-lg bg-amber-500 text-white hover:bg-amber-600 transition"
        >
          Xóa toàn bộ bộ lọc
        </button>
      </div>
    {:else}
      <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
        {#each filteredEntries as entry (entry.mediaKitId)}
          <div class="bg-white rounded-xl border border-slate-200 shadow-sm hover:shadow-md transition flex flex-col justify-between overflow-hidden">
            <div class="p-6 space-y-4">
              <!-- Creator Info -->
              <div class="flex items-start justify-between gap-3">
                <div class="flex items-center gap-3">
                  <div class="w-12 h-12 rounded-full bg-gradient-to-tr from-amber-400 to-rose-400 flex items-center justify-center text-white font-bold text-lg shadow-sm">
                    {entry.profile.creatorName.charAt(0)}
                  </div>
                  <div>
                    <h3 class="font-bold text-slate-900 text-base flex items-center gap-1.5">
                      {entry.profile.creatorName}
                      {#if entry.verifiedBadge}
                        <span class="text-blue-500 text-xs" title="Đã xác minh danh tính">✓</span>
                      {/if}
                    </h3>
                    <p class="text-xs text-slate-500 line-clamp-1">{entry.profile.headline}</p>
                  </div>
                </div>
              </div>

              <!-- Bio -->
              <p class="text-xs text-slate-600 line-clamp-3 leading-relaxed">
                {entry.profile.bio}
              </p>

              <!-- Categories & Languages -->
              <div class="flex flex-wrap gap-1.5">
                {#each entry.profile.categories as cat}
                  <span class="px-2 py-0.5 rounded text-[11px] font-medium bg-slate-100 text-slate-700">
                    {cat}
                  </span>
                {/each}
                {#each entry.profile.languages as lang}
                  <span class="px-2 py-0.5 rounded text-[11px] font-medium bg-amber-50 text-amber-700 uppercase">
                    {lang}
                  </span>
                {/each}
              </div>

              <!-- Social Metrics Overview -->
              <div class="bg-slate-50 rounded-lg p-3 grid grid-cols-2 gap-2 text-center">
                {#each entry.profile.socialMetrics.slice(0, 2) as metric}
                  <div>
                    <div class="text-[11px] font-medium text-slate-500">{metric.platform}</div>
                    <div class="text-sm font-bold text-slate-900">
                      {(metric.followers / 1000).toFixed(0)}K
                    </div>
                    <div class="text-[10px] text-emerald-600 font-semibold">
                      {metric.engagementRate}% ER
                    </div>
                  </div>
                {/each}
              </div>

              <!-- Price starting at -->
              {#if entry.profile.publicRates.length > 0}
                <div class="text-xs text-slate-500 flex items-center justify-between pt-1">
                  <span>Báo giá từ:</span>
                  <span class="font-bold text-slate-900 text-sm">
                    {(entry.profile.publicRates[0].priceMin / 1000000).toLocaleString('vi-VN')}M {entry.profile.publicRates[0].currency}
                  </span>
                </div>
              {/if}
            </div>

            <!-- Footer Action -->
            <div class="p-4 bg-slate-50 border-t border-slate-100 flex items-center justify-between">
              <span class="text-[11px] text-slate-400">
                Sẵn sàng nhận hợp tác
              </span>
              <a
                href="/creators/{entry.mediaKitId}"
                class="inline-flex items-center gap-1 px-3 py-1.5 rounded-lg bg-amber-500 hover:bg-amber-600 text-white text-xs font-semibold transition"
              >
                <span>Xem chi tiết & Đề xuất</span>
                <span>→</span>
              </a>
            </div>
          </div>
        {/each}
      </div>
    {/if}
  </div>
</div>

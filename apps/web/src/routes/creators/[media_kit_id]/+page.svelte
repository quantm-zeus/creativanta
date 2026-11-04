<script lang="ts">
  import { page } from '$app/stores';
  import {
    getCreatorDirectoryProfile,
    submitSponsorInquiry,
    type CreatorDirectoryEntry,
    type SponsorInquiryReceipt
  } from '$lib/commerce';

  const mediaKitId = $page.params.media_kit_id;

  // Mock catalog containing published and hidden profiles
  let catalog = $state<CreatorDirectoryEntry[]>([
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

  // Acceptance Target 2: If creator opts out while page is open, profile immediately becomes unavailable
  let entry = $derived(getCreatorDirectoryProfile(catalog, mediaKitId));

  // Inquiry Form State
  let brandName = $state('');
  let contactEmail = $state('');
  let message = $state('');
  let estimatedBudget = $state<number>(7500000);
  let challengeToken = $state('human-token-verified');
  let isSubmitting = $state(false);
  let submitError = $state<string | null>(null);
  let receipt = $state<SponsorInquiryReceipt | null>(null);

  function handleSimulateOptOut() {
    catalog = catalog.map((item) => {
      if (item.mediaKitId === mediaKitId) {
        return {
          ...item,
          profile: {
            ...item.profile,
            directoryStatus: 'hidden',
            directoryOptIn: false
          }
        };
      }
      return item;
    });
  }

  function handleSendInquiry(e: Event) {
    e.preventDefault();
    submitError = null;
    isSubmitting = true;

    // Acceptance Target 2 & 3: Validate against current opt-in state
    const result = submitSponsorInquiry(entry, {
      mediaKitId,
      brandName,
      contactEmail,
      message,
      estimatedBudget,
      challengeToken
    });

    isSubmitting = false;
    if (!result.success) {
      submitError = result.error ?? 'Gửi đề xuất thất bại';
      return;
    }

    receipt = result.receipt ?? null;
  }
</script>

<div class="min-h-screen bg-slate-50 py-10 px-4 sm:px-6 lg:px-8">
  <div class="max-w-4xl mx-auto space-y-6">
    <!-- Back to Directory -->
    <div>
      <a
        href="/creators"
        class="inline-flex items-center gap-1.5 text-xs font-semibold text-slate-600 hover:text-slate-900 transition"
      >
        <span>←</span>
        <span>Quay lại Danh bạ Creator</span>
      </a>
    </div>

    <!-- Acceptance Target 2: If creator is opted out / hidden, fail closed immediately -->
    {#if !entry}
      <div class="bg-white rounded-2xl border border-slate-200 p-12 text-center space-y-4 shadow-sm">
        <div class="text-4xl">🔒</div>
        <h2 class="text-xl font-bold text-slate-900">Hồ sơ không khả dụng hoặc đã ẩn</h2>
        <p class="text-sm text-slate-500 max-w-md mx-auto">
          Nhà sáng tạo nội dung hiện đã tắt chế độ công khai danh bạ hoặc tạm ngừng tiếp nhận đề xuất hợp tác mới.
        </p>
        <a
          href="/creators"
          class="inline-flex items-center px-4 py-2 text-xs font-semibold rounded-lg bg-amber-500 text-white hover:bg-amber-600 transition"
        >
          Khám phá các Creator khác
        </a>
      </div>
    {:else}
      <!-- Privacy demonstration simulation bar -->
      <div class="bg-amber-50 border border-amber-200 rounded-xl p-3 flex items-center justify-between text-xs text-amber-900">
        <div>
          <strong>Thử nghiệm Quyền riêng tư:</strong> Giả lập nhà sáng tạo tắt tính năng chia sẻ danh bạ công khai.
        </div>
        <button
          type="button"
          onclick={handleSimulateOptOut}
          class="px-2.5 py-1 rounded bg-amber-200 hover:bg-amber-300 font-semibold transition"
        >
          Mô phỏng Creator Opt-Out Ngay
        </button>
      </div>

      <!-- Creator Header Card -->
      <div class="bg-white rounded-2xl border border-slate-200 p-6 sm:p-8 shadow-sm space-y-6">
        <div class="flex flex-col sm:flex-row sm:items-center gap-5">
          <div class="w-20 h-20 rounded-2xl bg-gradient-to-tr from-amber-400 to-rose-400 flex items-center justify-center text-white text-3xl font-extrabold shadow-md shrink-0">
            {entry.profile.creatorName.charAt(0)}
          </div>
          <div class="space-y-1">
            <h1 class="text-2xl sm:text-3xl font-black text-slate-900 flex items-center gap-2">
              {entry.profile.creatorName}
              {#if entry.verifiedBadge}
                <span class="text-blue-500 text-base" title="Đã xác thực hồ sơ">✓</span>
              {/if}
            </h1>
            <p class="text-sm text-slate-600 font-medium">{entry.profile.headline}</p>
            <div class="flex flex-wrap gap-2 pt-1">
              {#each entry.profile.categories as cat}
                <span class="px-2.5 py-0.5 rounded-full text-xs font-medium bg-slate-100 text-slate-700">
                  {cat}
                </span>
              {/each}
              {#each entry.profile.languages as lang}
                <span class="px-2 py-0.5 rounded-full text-xs font-semibold bg-amber-100 text-amber-800 uppercase">
                  {lang}
                </span>
              {/each}
            </div>
          </div>
        </div>

        <div class="border-t border-slate-100 pt-5 space-y-3">
          <h2 class="text-xs font-bold uppercase tracking-wider text-slate-400">Giới thiệu bản thân</h2>
          <p class="text-sm text-slate-700 leading-relaxed whitespace-pre-line">
            {entry.profile.bio}
          </p>
        </div>

        <!-- Social Media Proof -->
        <div class="border-t border-slate-100 pt-5 space-y-3">
          <h2 class="text-xs font-bold uppercase tracking-wider text-slate-400">Chỉ số mạng xã hội công khai</h2>
          <div class="grid grid-cols-1 sm:grid-cols-2 gap-3">
            {#each entry.profile.socialMetrics as sm}
              <div class="p-3.5 bg-slate-50 rounded-xl border border-slate-200 flex items-center justify-between">
                <div>
                  <div class="text-xs font-semibold text-slate-500">{sm.platform} • {sm.handle}</div>
                  <div class="text-lg font-black text-slate-900 mt-0.5">
                    {sm.followers.toLocaleString('vi-VN')} <span class="text-xs font-normal text-slate-500">người theo dõi</span>
                  </div>
                </div>
                <div class="text-right">
                  <div class="text-xs font-bold text-emerald-600">{sm.engagementRate}% ER</div>
                  <div class="text-[11px] text-slate-400">{sm.avgViews.toLocaleString('vi-VN')} views TB</div>
                </div>
              </div>
            {/each}
          </div>
        </div>

        <!-- Public Rate Cards -->
        <div class="border-t border-slate-100 pt-5 space-y-3">
          <h2 class="text-xs font-bold uppercase tracking-wider text-slate-400">Báo giá tham khảo công khai</h2>
          <div class="space-y-2.5">
            {#each entry.profile.publicRates as rate}
              <div class="p-4 bg-slate-50 rounded-xl border border-slate-200 flex flex-col sm:flex-row sm:items-center justify-between gap-3">
                <div>
                  <div class="text-sm font-bold text-slate-900">{rate.serviceType}</div>
                  {#if rate.description}
                    <div class="text-xs text-slate-500 mt-0.5">{rate.description}</div>
                  {/if}
                  <div class="text-[11px] text-slate-400 mt-1">Thời gian bàn giao ước tính: ~{rate.deliveryDays} ngày</div>
                </div>
                <div class="text-right shrink-0">
                  <div class="text-base font-extrabold text-amber-600">
                    {(rate.priceMin / 1000000).toLocaleString('vi-VN')}M - {(rate.priceMax / 1000000).toLocaleString('vi-VN')}M {rate.currency}
                  </div>
                </div>
              </div>
            {/each}
          </div>
        </div>
      </div>

      <!-- Sponsor Inquiry Section -->
      <div class="bg-white rounded-2xl border border-slate-200 p-6 sm:p-8 shadow-sm space-y-6">
        <div>
          <h2 class="text-xl font-bold text-slate-900">Gửi đề nghị hợp tác (Sponsor Inquiry)</h2>
          <p class="text-xs text-slate-500 mt-1">
            Gửi tóm tắt chiến dịch của bạn trực tiếp tới nhà sáng tạo. Thư sẽ được gửi an toàn mà không làm lộ thông tin nội bộ của hai bên.
          </p>
        </div>

        {#if receipt}
          <div class="p-6 bg-emerald-50 border border-emerald-200 rounded-xl space-y-3">
            <div class="flex items-center gap-2 text-emerald-800 font-bold text-base">
              <span>✓</span>
              <span>Đề xuất hợp tác đã được gửi thành công!</span>
            </div>
            <p class="text-xs text-emerald-700">
              Biên nhận hệ thống (Receipt ID): <code class="font-mono bg-white px-2 py-0.5 rounded border border-emerald-200">{receipt.receiptId}</code>
            </p>
            <p class="text-xs text-emerald-600 italic">
              {receipt.disclaimer}
            </p>
            <div class="pt-2">
              <button
                type="button"
                onclick={() => (receipt = null)}
                class="px-3 py-1.5 text-xs font-semibold rounded-lg bg-emerald-600 text-white hover:bg-emerald-700 transition"
              >
                Gửi một đề xuất khác
              </button>
            </div>
          </div>
        {:else}
          {#if submitError}
            <div class="p-3 bg-rose-50 border border-rose-200 rounded-lg text-xs font-semibold text-rose-800">
              {submitError}
            </div>
          {/if}

          <form onsubmit={handleSendInquiry} class="space-y-4">
            <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
              <div>
                <label for="brand-name-input" class="block text-xs font-semibold text-slate-700 mb-1">Tên nhãn hàng / Doanh nghiệp</label>
                <input
                  id="brand-name-input"
                  type="text"
                  bind:value={brandName}
                  required
                  placeholder="VD: Thương hiệu Mỹ phẩm Natural Organic"
                  class="w-full bg-slate-50 border border-slate-300 rounded-lg px-3 py-2 text-sm text-slate-900 focus:outline-none focus:ring-2 focus:ring-amber-500 focus:bg-white"
                />
              </div>

              <div>
                <label for="contact-email-input" class="block text-xs font-semibold text-slate-700 mb-1">Email liên hệ của bạn (Brand Email)</label>
                <input
                  id="contact-email-input"
                  type="email"
                  bind:value={contactEmail}
                  required
                  placeholder="contact@brand.vn"
                  class="w-full bg-slate-50 border border-slate-300 rounded-lg px-3 py-2 text-sm text-slate-900 focus:outline-none focus:ring-2 focus:ring-amber-500 focus:bg-white"
                />
              </div>
            </div>

            <div>
              <label for="estimated-budget-input" class="block text-xs font-semibold text-slate-700 mb-1">Ngân sách dự kiến (VND)</label>
              <input
                id="estimated-budget-input"
                type="number"
                bind:value={estimatedBudget}
                min="1000000"
                step="500000"
                required
                class="w-full bg-slate-50 border border-slate-300 rounded-lg px-3 py-2 text-sm text-slate-900 focus:outline-none focus:ring-2 focus:ring-amber-500 focus:bg-white"
              />
            </div>

            <div>
              <label for="campaign-message-input" class="block text-xs font-semibold text-slate-700 mb-1">Mô tả tóm tắt chiến dịch & Yêu cầu hợp tác</label>
              <textarea
                id="campaign-message-input"
                bind:value={message}
                rows="4"
                required
                minlength="10"
                placeholder="Nêu rõ mục tiêu chiến dịch, thời hạn ra mắt sản phẩm và hình thức nội dung mong muốn..."
                class="w-full bg-slate-50 border border-slate-300 rounded-lg px-3 py-2 text-sm text-slate-900 focus:outline-none focus:ring-2 focus:ring-amber-500 focus:bg-white"
              ></textarea>
            </div>

            <div class="flex items-center justify-between pt-2">
              <span class="text-[11px] text-slate-400">
                🔒 Thông tin được bảo vệ, không chia sẻ cho bên thứ ba.
              </span>
              <button
                type="submit"
                disabled={isSubmitting}
                class="inline-flex items-center px-5 py-2.5 rounded-lg bg-amber-500 hover:bg-amber-600 disabled:opacity-50 text-white font-bold text-xs shadow-sm transition"
              >
                {isSubmitting ? 'Đang gửi đề xuất...' : 'Gửi Đề Nghị Hợp Tác'}
              </button>
            </div>
          </form>
        {/if}
      </div>
    {/if}
  </div>
</div>

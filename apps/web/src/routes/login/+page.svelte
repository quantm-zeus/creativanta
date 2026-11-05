<script lang="ts">
  import { onMount } from 'svelte';
  import { page } from '$app/stores';
  import { goto } from '$app/navigation';
  import { authStore, getOrInitClerk, sanitizeRedirectTarget } from '$lib/auth';
  import UnavailableNotice from '$lib/components/UnavailableNotice.svelte';

  let email = $state('');
  let password = $state('');
  let rememberMe = $state(false);
  let showPassword = $state(false);
  let errorMessage = $state<string | null>(null);
  let isSubmitting = $state(false);
  let clerkContainer = $state<HTMLDivElement | null>(null);

  let redirectTarget = $derived(sanitizeRedirectTarget($page.url.searchParams.get('redirect'), '/workspaces'));

  onMount(async () => {
    // If Clerk is configured and mounted component is available
    if ($authStore.state === 'unconfigured') {
      return;
    }

    try {
      const clerk = await getOrInitClerk();
      if (clerk && clerkContainer && typeof clerk.mountSignIn === 'function') {
        clerk.mountSignIn(clerkContainer, {
          routing: 'path',
          path: '/login',
          afterSignInUrl: redirectTarget,
          signUpUrl: '/register'
        });
      }
    } catch {
      // If mount fails or fallback is preferred
    }
  });

  async function handleFormSubmit(e: Event) {
    e.preventDefault();
    if ($authStore.state === 'unconfigured') {
      errorMessage = 'Không thể đăng nhập: Khóa Clerk Publishable Key chưa được cấu hình (Fail-closed).';
      return;
    }

    isSubmitting = true;
    errorMessage = null;

    try {
      // In unmounted/test environments without live Clerk IdP backend
      errorMessage = 'Xác thực trực tiếp yêu cầu kết nối Clerk IdP hợp lệ. Vui lòng hoàn tất đăng nhập qua Clerk SDK widget.';
    } catch (err: any) {
      errorMessage = err?.message || 'Đăng nhập không thành công';
    } finally {
      isSubmitting = false;
    }
  }

  function handleSignOut() {
    authStore.signOut();
  }
</script>

<svelte:head>
  <title>Đăng nhập — Creativanta (W010)</title>
</svelte:head>

<div class="min-h-[calc(100vh-14rem)] flex items-center justify-center py-6">
  <div class="w-full max-w-4xl overflow-hidden rounded-2xl border border-[#e7e2d7] bg-[#ffffff] shadow-sm grid grid-cols-1 lg:grid-cols-12">
    <!-- Left Brand Panel (Desktop 5/12 cols) -->
    <div class="lg:col-span-5 bg-[#274333] p-8 text-[#fbf9f5] flex flex-col justify-between relative overflow-hidden">
      <!-- Background subtle styling -->
      <div class="absolute -right-16 -top-16 h-48 w-48 rounded-full bg-[#345944]/40 blur-2xl"></div>
      <div class="absolute -left-16 -bottom-16 h-48 w-48 rounded-full bg-[#d94a31]/20 blur-2xl"></div>

      <div class="relative z-10 space-y-6">
        <div class="flex items-center gap-2.5">
          <span class="flex h-9 w-9 items-center justify-center rounded-lg bg-[#ffffff] text-base font-black text-[#274333]">
            C
          </span>
          <div>
            <h2 class="text-lg font-bold tracking-tight text-[#ffffff]">Creativanta</h2>
            <p class="text-[10px] font-mono text-[#a3b8aa]">V5 Trend-to-Profit OS</p>
          </div>
        </div>

        <div class="space-y-3 pt-4">
          <p class="text-xs uppercase tracking-widest text-[#d94a31] font-semibold">
            Màn hình W010 · Định danh
          </p>
          <h3 class="text-xl font-medium tracking-tight text-[#ffffff] font-serif leading-snug">
            Nền tảng quản lý nội dung thông minh cho creator Việt Nam.
          </h3>
          <p class="text-xs text-[#cad5cd] leading-relaxed">
            Hợp nhất 23 phân hệ, 6 chế độ vận hành và một đồ thị vận hành xuyên suốt từ tín hiệu xu hướng đến lợi nhuận thực tế.
          </p>
        </div>

        <div class="space-y-2 pt-2 text-xs text-[#e4ede7]">
          <div class="flex items-center gap-2">
            <span class="h-1.5 w-1.5 rounded-full bg-[#d94a31]"></span>
            <span>Bảo mật phiên định danh phân cấp qua Clerk SDK</span>
          </div>
          <div class="flex items-center gap-2">
            <span class="h-1.5 w-1.5 rounded-full bg-[#d94a31]"></span>
            <span>Xác thực tenant nhiều workspace fail-closed</span>
          </div>
          <div class="flex items-center gap-2">
            <span class="h-1.5 w-1.5 rounded-full bg-[#d94a31]"></span>
            <span>Không lưu trữ mật khẩu cục bộ hoặc bypass token</span>
          </div>
        </div>
      </div>

      <div class="relative z-10 pt-8 border-t border-[#345944] text-[11px] text-[#a3b8aa]">
        © 2026 Creativanta · Bảo mật cấp doanh nghiệp
      </div>
    </div>

    <!-- Right Form Panel (Desktop 7/12 cols) -->
    <div class="lg:col-span-7 p-6 sm:p-8 flex flex-col justify-between bg-[#ffffff]">
      <div>
        <div class="flex items-center justify-between border-b border-[#f4f0e8] pb-4 mb-6">
          <div>
            <h1 class="text-xl font-bold tracking-tight text-[#242924]">Đăng nhập</h1>
            <p class="text-xs text-[#616c63] mt-0.5">Truy cập không gian làm việc của bạn</p>
          </div>
          <span class="rounded bg-[#fbeee9] px-2 py-0.5 text-[10px] font-mono font-semibold text-[#d94a31]">
            P0-03 Auth
          </span>
        </div>

        <!-- State 1: Already Authenticated -->
        {#if $authStore.state === 'authenticated'}
          <div class="space-y-4 py-4">
            <div class="rounded-xl border border-[#274333]/20 bg-[#eef3f0] p-4 text-xs space-y-2">
              <div class="flex items-center gap-2 text-[#274333] font-semibold">
                <span class="h-2 w-2 rounded-full bg-[#274333]"></span>
                <span>Phiên đăng nhập đang hoạt động</span>
              </div>
              <p class="text-[#242924]">
                Tài khoản: <strong class="font-mono">{$authStore.user?.email || $authStore.user?.id}</strong>
              </p>
              {#if $authStore.activeWorkspace}
                <p class="text-[#616c63]">
                  Workspace hiện tại: <span class="font-medium text-[#242924]">{$authStore.activeWorkspace.name}</span>
                  ({$authStore.activeWorkspace.role})
                </p>
              {/if}
            </div>

            <div class="flex flex-col sm:flex-row gap-3 pt-2">
              <a
                href={redirectTarget}
                class="flex-1 text-center rounded-lg bg-[#274333] px-4 py-2.5 text-xs font-semibold text-[#fbf9f5] hover:bg-[#1e3528] transition-colors"
              >
                Tiếp tục đến Workspace →
              </a>
              <button
                type="button"
                onclick={handleSignOut}
                class="rounded-lg border border-[#e7e2d7] bg-[#ffffff] px-4 py-2.5 text-xs font-medium text-[#616c63] hover:text-[#d94a31] hover:border-[#d94a31]/40 transition-colors"
              >
                Đăng xuất phiên này
              </button>
            </div>
          </div>

        <!-- State 2: Unconfigured Publishable Key (Honest Notice) -->
        {:else if $authStore.state === 'unconfigured'}
          <div class="space-y-4">
            <UnavailableNotice
              title="Khóa định danh Clerk chưa cấu hình"
              domain="Identity & Session"
              requires="VITE_CLERK_PUBLISHABLE_KEY"
              message="Chưa tìm thấy biến môi trường VITE_CLERK_PUBLISHABLE_KEY. Hệ thống không tạo người dùng giả mạo hay cấp quyền bypass (Principle 1 & RULE-AUTH-002). Vui lòng cấu hình Publishable Key để kết nối luồng đăng nhập thật."
            />

            <div class="opacity-50 pointer-events-none space-y-3 pt-2">
              <div class="grid grid-cols-2 gap-2">
                <button type="button" disabled class="flex items-center justify-center gap-2 rounded-lg border border-[#e7e2d7] bg-[#fbf9f5] py-2 text-xs font-medium text-[#616c63]">
                  <span>🔵</span> Google
                </button>
                <button type="button" disabled class="flex items-center justify-center gap-2 rounded-lg border border-[#e7e2d7] bg-[#fbf9f5] py-2 text-xs font-medium text-[#616c63]">
                  <span></span> Apple
                </button>
              </div>

              <div class="space-y-2">
                <label for="mock-email" class="block text-xs font-medium text-[#616c63]">Email</label>
                <input id="mock-email" type="email" disabled placeholder="creator@example.com" class="w-full rounded-md border border-[#e7e2d7] bg-[#fbf9f5] px-3 py-2 text-xs" />
              </div>

              <button type="button" disabled class="w-full rounded-lg bg-[#e7e2d7] py-2.5 text-xs font-semibold text-[#8a968c]">
                Đăng nhập (Đã vô hiệu hóa)
              </button>
            </div>
          </div>

        <!-- State 3: Session Expired -->
        {:else if $authStore.state === 'expired'}
          <div class="space-y-4">
            <div class="rounded-lg border border-[#d94a31]/30 bg-[#fbeee9] p-4 text-xs text-[#242924] space-y-1">
              <h4 class="font-semibold text-[#d94a31]">Phiên làm việc đã hết hạn</h4>
              <p class="text-[#616c63]">
                JWT phiên của bạn đã hết hạn hoặc bị thu hồi bởi nhà cung cấp Clerk. Vui lòng đăng nhập lại để tiếp tục.
              </p>
            </div>

            <!-- Clerk Container Mount for re-auth -->
            <div bind:this={clerkContainer} class="min-h-[280px] flex items-center justify-center">
              <p class="text-xs text-[#616c63]">Đang kết nối giao diện đăng nhập Clerk...</p>
            </div>
          </div>

        <!-- State 4: Unauthenticated with Clerk Available -->
        {:else}
          <div class="space-y-4">
            <!-- Mount point for official Clerk widget if available -->
            <div bind:this={clerkContainer} class="min-h-[260px]">
              <!-- Fallback UI if widget is pending mount -->
              <div class="space-y-4">
                <div class="grid grid-cols-2 gap-2.5">
                  <button
                    type="button"
                    onclick={() => alert('Vui lòng hoàn tất xác thực thông qua Clerk widget')}
                    class="flex items-center justify-center gap-2 rounded-lg border border-[#e7e2d7] bg-[#ffffff] py-2.5 px-3 text-xs font-medium text-[#242924] hover:bg-[#fbf9f5] transition-colors"
                  >
                    <span class="font-bold text-blue-600">G</span> Google
                  </button>
                  <button
                    type="button"
                    onclick={() => alert('Vui lòng hoàn tất xác thực thông qua Clerk widget')}
                    class="flex items-center justify-center gap-2 rounded-lg border border-[#e7e2d7] bg-[#ffffff] py-2.5 px-3 text-xs font-medium text-[#242924] hover:bg-[#fbf9f5] transition-colors"
                  >
                    <span></span> Apple
                  </button>
                </div>

                <div class="relative flex items-center justify-center">
                  <div class="w-full border-t border-[#f4f0e8]"></div>
                  <span class="relative bg-[#ffffff] px-2 text-[11px] text-[#8a968c]">hoặc email</span>
                </div>

                <form onsubmit={handleFormSubmit} class="space-y-3">
                  <div>
                    <label for="login-email" class="block text-xs font-medium text-[#242924] mb-1">
                      Địa chỉ Email
                    </label>
                    <input
                      id="login-email"
                      type="email"
                      bind:value={email}
                      required
                      placeholder="ten@creativanta.vn"
                      class="w-full rounded-lg border border-[#e7e2d7] px-3 py-2 text-xs focus:border-[#d94a31] focus:outline-hidden"
                    />
                  </div>

                  <div>
                    <div class="flex items-center justify-between mb-1">
                      <label for="login-pwd" class="block text-xs font-medium text-[#242924]">
                        Mật khẩu
                      </label>
                      <a href="/forgot-password" class="text-[11px] text-[#d94a31] hover:underline">
                        Quên mật khẩu?
                      </a>
                    </div>
                    <div class="relative">
                      <input
                        id="login-pwd"
                        type={showPassword ? 'text' : 'password'}
                        bind:value={password}
                        required
                        class="w-full rounded-lg border border-[#e7e2d7] px-3 py-2 text-xs pr-10 focus:border-[#d94a31] focus:outline-hidden"
                      />
                      <button
                        type="button"
                        onclick={() => (showPassword = !showPassword)}
                        class="absolute right-2.5 top-1/2 -translate-y-1/2 text-xs text-[#8a968c] hover:text-[#242924]"
                      >
                        {showPassword ? 'Ẩn' : 'Hiện'}
                      </button>
                    </div>
                  </div>

                  {#if errorMessage}
                    <div class="rounded-md bg-[#fbeee9] border border-[#d94a31]/30 p-2.5 text-xs text-[#d94a31]">
                      {errorMessage}
                    </div>
                  {/if}

                  <button
                    type="submit"
                    disabled={isSubmitting}
                    class="w-full rounded-lg bg-[#274333] py-2.5 text-xs font-semibold text-[#fbf9f5] hover:bg-[#1e3528] transition-colors disabled:opacity-50"
                  >
                    {isSubmitting ? 'Đang xác thực...' : 'Đăng nhập'}
                  </button>
                </form>
              </div>
            </div>
          </div>
        {/if}
      </div>

      <div class="pt-6 border-t border-[#f4f0e8] text-center text-xs text-[#616c63]">
        Chưa có tài khoản?
        <a href="/register" class="font-semibold text-[#d94a31] hover:underline ml-1">
          Đăng ký miễn phí →
        </a>
      </div>
    </div>
  </div>
</div>

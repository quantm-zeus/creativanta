<script lang="ts">
  import { authStore } from '$lib/auth';
  import UnavailableNotice from '$lib/components/UnavailableNotice.svelte';
</script>

<svelte:head>
  <title>Đăng ký tài khoản — Creativanta (W011)</title>
</svelte:head>

<div class="min-h-[calc(100vh-14rem)] flex items-center justify-center py-6">
  <div class="w-full max-w-lg rounded-2xl border border-[#e7e2d7] bg-[#ffffff] p-6 sm:p-8 shadow-sm space-y-6">
    <div class="border-b border-[#f4f0e8] pb-4">
      <div class="flex items-center justify-between">
        <h1 class="text-xl font-bold tracking-tight text-[#242924]">Đăng ký tài khoản</h1>
        <span class="rounded bg-[#fbeee9] px-2 py-0.5 text-[10px] font-mono font-semibold text-[#d94a31]">
          Màn hình W011
        </span>
      </div>
      <p class="text-xs text-[#616c63] mt-1">
        Tạo tài khoản Creativanta và bắt đầu với gói Creator.
      </p>
    </div>

    {#if $authStore.state === 'unconfigured'}
      <UnavailableNotice
        title="Đăng ký chưa khả dụng"
        domain="Identity / Registration"
        requires="VITE_CLERK_PUBLISHABLE_KEY"
        message="Khóa cấu hình Clerk chưa được thiết lập. Để đảm bảo an toàn và tính xác thực (RULE-AUTH-001, Principle 1), hệ thống không tạo tài khoản giả lập khi chưa kết nối Clerk IdP."
      />
    {:else}
      <div class="space-y-4">
        <div class="rounded-lg border border-[#e7e2d7] bg-[#fbf9f5] p-4 text-xs text-[#616c63]">
          Vui lòng hoàn tất quá trình đăng ký và xác thực email thông qua giao diện chính thức của Clerk.
        </div>
      </div>
    {/if}

    <div class="pt-4 border-t border-[#f4f0e8] text-center text-xs text-[#616c63]">
      Đã có tài khoản?
      <a href="/login" class="font-semibold text-[#d94a31] hover:underline ml-1">
        Đăng nhập ngay →
      </a>
    </div>
  </div>
</div>

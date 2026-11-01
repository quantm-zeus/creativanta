<script lang="ts">
  import { authStore } from '$lib/auth';
  import UnavailableNotice from '$lib/components/UnavailableNotice.svelte';
</script>

<svelte:head>
  <title>Quên mật khẩu — Creativanta (W012a)</title>
</svelte:head>

<div class="min-h-[calc(100vh-14rem)] flex items-center justify-center py-6">
  <div class="w-full max-w-lg rounded-2xl border border-[#e7e2d7] bg-[#ffffff] p-6 sm:p-8 shadow-sm space-y-6">
    <div class="border-b border-[#f4f0e8] pb-4">
      <div class="flex items-center justify-between">
        <h1 class="text-xl font-bold tracking-tight text-[#242924]">Khôi phục mật khẩu</h1>
        <span class="rounded bg-[#fbeee9] px-2 py-0.5 text-[10px] font-mono font-semibold text-[#d94a31]">
          Màn hình W012a
        </span>
      </div>
      <p class="text-xs text-[#616c63] mt-1">
        Nhập địa chỉ email đã đăng ký để nhận mã khôi phục từ Clerk.
      </p>
    </div>

    {#if $authStore.state === 'unconfigured'}
      <UnavailableNotice
        title="Khôi phục mật khẩu chưa khả dụng"
        domain="Identity / Password Recovery"
        requires="VITE_CLERK_PUBLISHABLE_KEY"
        message="Khóa cấu hình Clerk chưa được thiết lập. Quá trình gửi mã khôi phục sử dụng trực tiếp luồng bảo mật của Clerk (RULE-AUTH-004) và không hỗ trợ gửi email giả lập."
      />
    {:else}
      <div class="space-y-4">
        <div class="rounded-lg border border-[#e7e2d7] bg-[#fbf9f5] p-4 text-xs text-[#616c63]">
          Quy trình khôi phục mật khẩu tuân theo thời hạn báo cáo bởi Clerk và vô hiệu hóa mọi phiên đăng nhập hiện hữu sau khi hoàn tất.
        </div>
      </div>
    {/if}

    <div class="pt-4 border-t border-[#f4f0e8] text-center text-xs text-[#616c63]">
      <a href="/login" class="font-semibold text-[#d94a31] hover:underline">
        ← Quay lại trang Đăng nhập
      </a>
    </div>
  </div>
</div>

<script lang="ts">
  import { canAccessAdmin } from '$lib/access';
</script>
<svelte:head>
  <title>Admin · Access Restricted · Creativanta</title>
  <meta name="robots" content="noindex, nofollow" />
</svelte:head>
<section aria-labelledby="restricted-title" class="max-w-2xl">
  <p class="text-xs font-bold uppercase tracking-[0.16em] text-[#bb5b3f]">P0-01 · INTERNAL TRUST BOUNDARY</p>
  <h1 id="restricted-title" class="mt-4 text-4xl font-bold tracking-tight text-[#242924]">Khu vực vận hành nội bộ</h1>
  <p class="mt-4 max-w-xl text-sm leading-7 text-[#7d837b]">Truy cập bị khóa cho đến khi xác thực Admin riêng, VPN/MFA và phân quyền server-side được triển khai và kiểm thử.</p>
  <div class="mt-8 rounded-2xl border border-[#e8e5dc] bg-[#fffefa] p-6">
    <div class="flex items-center gap-3">
      <span class="inline-flex h-11 w-11 items-center justify-center rounded-xl bg-[#fff0e7] text-[#d94a31] text-2xl" aria-hidden="true">!</span>
      <div>
        <h2 class="text-base font-bold">Chưa cấp quyền truy cập</h2>
        <p class="mt-1 text-xs leading-6 text-[#7d837b]">P0-03 / P0-07: identity, role, capability, audit.</p>
      </div>
    </div>
    <div class="mt-5 border-t border-[#e8e5dc] pt-4 text-xs text-[#7d837b]">
      Admin UI enabled: <strong class="text-[#b44833]">{canAccessAdmin() ? 'yes' : 'no'}</strong>.
      Không có dữ liệu vận hành hoặc API privileged nào được phát hành trong P0-01.
    </div>
  </div>
</section>

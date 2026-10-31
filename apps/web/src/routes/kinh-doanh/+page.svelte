<script lang="ts">
  import UnavailableNotice from '$lib/components/UnavailableNotice.svelte';
</script>

<svelte:head><title>Kinh doanh — Creativanta</title></svelte:head>

<section class="space-y-6" aria-labelledby="commerce-title">
  <div class="flex flex-col gap-3">
    <p class="text-xs font-bold uppercase tracking-[0.15em] text-[#ad6047]">COMMERCE / FOUNDATION · P0-01</p>
    <h1 id="commerce-title" class="text-3xl font-bold tracking-tight text-[#242924]">Kinh doanh</h1>
    <p class="max-w-2xl text-sm leading-7 text-[#7d837b]">Theo dõi sản phẩm, đơn hàng và hiệu quả kinh doanh khi ledger, ConnectRPC và quyền tenant đã được triển khai.</p>
  </div>
  <UnavailableNotice
    title="Chưa kết nối dữ liệu bán hàng"
    domain="Kinh doanh & phân tích"
    requires="P0-02 / P0-04 / P0-06"
    message="Không hiển thị đơn hàng, doanh thu, số dư hoặc trạng thái thanh toán giả như thông tin thật. Tất cả thao tác liên quan đến tiền đều tạm khóa."
  />
  <div class="rounded-2xl border border-[#e8e5dc] bg-[#fffefa] p-7 shadow-sm">
    <h2 class="text-base font-semibold text-[#274333]">Luồng kinh doanh sẽ có</h2>
    <div class="mt-5 grid gap-4 sm:grid-cols-3">
      {#each ['Sản phẩm & đơn hàng', 'Affiliate & chiến dịch', 'Doanh thu & đối soát'] as title}
        <div class="rounded-xl border border-[#e8e5dc] bg-[#fbf9f5] p-4">
          <div class="mb-2 text-xs font-bold text-[#274333]">{title}</div>
          <span class="text-xs text-[#7d837b]">Chưa khả dụng trong Phase 0</span>
        </div>
      {/each}
    </div>
    <button type="button" disabled class="mt-6 rounded-xl bg-[#e8e5dc] px-5 py-3 text-sm font-medium text-[#7d837b] cursor-not-allowed">Chưa thể xử lý giao dịch</button>
  </div>
</section>
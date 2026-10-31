<script lang="ts">
  import UnavailableNotice from '$lib/components/UnavailableNotice.svelte';
  import JobCard from '$lib/components/JobCard.svelte';
  import { P0_UNSUPPORTED_FEATURES } from '$lib/constants/navigation';
</script>

<svelte:head>
  <title>Tổng quan — Creativanta</title>
</svelte:head>

<div class="space-y-6">
  <!-- Job Header -->
  <div class="flex flex-col gap-2 sm:flex-row sm:items-center sm:justify-between">
    <div>
      <div class="flex items-center gap-2">
        <span class="rounded bg-[#274333] px-2 py-0.5 text-xs font-semibold text-[#fbf9f5]">
          Job 1
        </span>
        <h1 class="text-2xl font-bold tracking-tight text-[#242924] sm:text-3xl">
          Tổng quan
        </h1>
      </div>
      <p class="text-sm text-[#616c63] mt-1">
        Daily Decision Engine (M01) — Điều phối nhịp vận hành đầu ngày và quyết định ưu tiên.
      </p>
    </div>

    <div class="flex items-center gap-2">
      <span class="rounded-md border border-[#e7e2d7] bg-[#ffffff] px-3 py-1.5 text-xs font-medium text-[#242924]">
        Trạng thái: P0-01 Shell
      </span>
    </div>
  </div>

  <!-- Honesty & Unsupported Boundary Notice -->
  <UnavailableNotice
    title="Giới hạn thực thi P0-01 Shell"
    domain="Hạ tầng & Kết nối"
    requires="P0-02 (Transport) / P0-03 (IAM)"
    message="Toàn bộ hành động ra quyết định và dữ liệu trực tiếp yêu cầu kết nối ConnectRPC và phiên định danh Clerk. Các nút thao tác tạm thời bị vô hiệu hoá để đảm bảo tính trung thực (Principle 1)."
  />

  <!-- Decision Grid -->
  <div class="grid grid-cols-1 gap-5 md:grid-cols-2 lg:grid-cols-3">
    <!-- Card 1: Morning Brief -->
    <JobCard
      title="Morning Decision Brief"
      moduleTag="M01"
      description="Tổng hợp cơ hội có giá trị kinh tế cao nhất và các điểm nghẽn vận hành cần giải quyết trong ngày."
    >
      <div class="space-y-3">
        <div class="rounded bg-[#fbf9f5] p-3 border border-[#e7e2d7]">
          <span class="text-[11px] font-semibold text-[#274333] uppercase tracking-wider block">
            Ưu tiên hàng đầu (Static Fixture)
          </span>
          <p class="text-xs text-[#242924] mt-1 font-medium">
            Xu hướng âm thanh mới nổi trong ngành tiêu dùng nhanh (FMCG).
          </p>
        </div>
        <button
          type="button"
          disabled
          class="w-full cursor-not-allowed rounded-md bg-[#e7e2d7] py-2 px-3 text-xs font-medium text-[#616c63]"
        >
          Xác nhận luồng quyết định (Chưa khả dụng)
        </button>
      </div>
    </JobCard>

    <!-- Card 2: Operating Pulse -->
    <JobCard
      title="Nhịp vận hành & SLA"
      moduleTag="M12/M19"
      description="Giám sát cảnh báo SLA phản hồi khách hàng và phát hiện bất thường tài chính."
    >
      <div class="space-y-3">
        <div class="flex items-center justify-between text-xs py-1 border-b border-[#f4f0e8]">
          <span class="text-[#616c63]">Tin nhắn chờ xử lý:</span>
          <span class="font-mono font-semibold text-[#242924]">0 (P0 Stub)</span>
        </div>
        <div class="flex items-center justify-between text-xs py-1 border-b border-[#f4f0e8]">
          <span class="text-[#616c63]">Bất thường ký quỹ:</span>
          <span class="font-mono font-semibold text-[#274333]">Chưa kết nối dữ liệu</span>
        </div>
        <button
          type="button"
          disabled
          class="w-full cursor-not-allowed rounded-md bg-[#e7e2d7] py-2 px-3 text-xs font-medium text-[#616c63]"
        >
          Mở hàng đợi phản hồi (Chưa khả dụng)
        </button>
      </div>
    </JobCard>

    <!-- Card 3: AI Credit Quota -->
    <JobCard
      title="Hạn mức AI Credit"
      moduleTag="M23"
      description="Quản lý và đối soát số dư lot tín dụng sử dụng cho các tác vụ AI Studio."
    >
      <div class="space-y-3">
        <div class="flex items-center justify-between text-xs py-1 border-b border-[#f4f0e8]">
          <span class="text-[#616c63]">Hạn mức khả dụng:</span>
          <span class="font-mono font-semibold text-[#242924]">-- (Chờ P0-06)</span>
        </div>
        <button
          type="button"
          disabled
          class="w-full cursor-not-allowed rounded-md bg-[#e7e2d7] py-2 px-3 text-xs font-medium text-[#616c63]"
        >
          Nạp thêm tín dụng (Cổng thanh toán tắt)
        </button>
      </div>
    </JobCard>
  </div>

  <!-- P0 Architectural Status Table -->
  <div class="rounded-xl border border-[#e7e2d7] bg-[#ffffff] p-5 shadow-xs">
    <h3 class="text-sm font-bold tracking-tight text-[#242924] mb-3">
      Trạng thái ranh giới thực thi P0
    </h3>
    <div class="overflow-x-auto">
      <table class="w-full text-left text-xs">
        <thead class="border-b border-[#e7e2d7] text-[#616c63]">
          <tr>
            <th class="py-2 font-medium">Hạng mục</th>
            <th class="py-2 font-medium">Trạng thái hiện tại</th>
            <th class="py-2 font-medium">Ràng buộc thực thi</th>
          </tr>
        </thead>
        <tbody class="divide-y divide-[#f4f0e8]">
          {#each P0_UNSUPPORTED_FEATURES as item}
            <tr>
              <td class="py-2.5 font-medium text-[#242924]">{item.domain} — {item.feature}</td>
              <td class="py-2.5">
                <span class="rounded bg-[#fbeee9] px-2 py-0.5 font-mono text-[10px] font-semibold text-[#d94a31]">
                  {item.status}
                </span>
              </td>
              <td class="py-2.5 text-[#616c63]">{item.explanation}</td>
            </tr>
          {/each}
        </tbody>
      </table>
    </div>
  </div>
</div>

<script lang="ts">
  import UnavailableNotice from '$lib/components/UnavailableNotice.svelte';
  import JobCard from '$lib/components/JobCard.svelte';
</script>

<svelte:head>
  <title>Khám phá — Creativanta</title>
</svelte:head>

<div class="space-y-6">
  <!-- Job Header -->
  <div class="flex flex-col gap-2 sm:flex-row sm:items-center sm:justify-between">
    <div>
      <div class="flex items-center gap-2">
        <span class="rounded bg-[#274333] px-2 py-0.5 text-xs font-semibold text-[#fbf9f5]">
          Job 2
        </span>
        <h1 class="text-2xl font-bold tracking-tight text-[#242924] sm:text-3xl">
          Khám phá
        </h1>
      </div>
      <p class="text-sm text-[#616c63] mt-1">
        Trend Fusion Radar & Phân tích thị trường (M02–M04) — Biến tín hiệu xã hội thành cơ hội kinh doanh.
      </p>
    </div>

    <span class="rounded-md border border-[#e7e2d7] bg-[#ffffff] px-3 py-1.5 text-xs font-medium text-[#242924]">
      Phase dự kiến: P2–P4
    </span>
  </div>

  <UnavailableNotice
    title="Chưa kết nối luồng tín hiệu thời gian thực"
    domain="Intelligence"
    requires="P2 (Trend Connectors)"
    message="Trình quét radar TikTok, Shopee và Meilisearch chỉ bắt đầu hoạt động từ Phase P2. Không có dữ liệu thị trường giả mạo nào được mô phỏng."
  />

  <div class="grid grid-cols-1 gap-5 md:grid-cols-2 lg:grid-cols-3">
    <!-- Card 1: Trend Fusion Radar -->
    <JobCard
      title="Trend Fusion Radar"
      moduleTag="M02"
      isUnavailable={true}
      description="Tổng hợp tín hiệu xu hướng từ các nền tảng video ngắn và sàn thương mại điện tử khu vực Đông Nam Á."
    >
      <div class="space-y-2">
        <p class="text-xs text-[#616c63]">
          Kết nối nền tảng: <span class="font-mono text-[#d94a31]">Ngắt kết nối (P0 Shell)</span>
        </p>
        <button
          type="button"
          disabled
          class="w-full cursor-not-allowed rounded-md bg-[#e7e2d7] py-2 px-3 text-xs font-medium text-[#616c63]"
        >
          Quét tín hiệu mới (Chưa khả dụng)
        </button>
      </div>
    </JobCard>

    <!-- Card 2: Competitor Intelligence -->
    <JobCard
      title="Nghiên cứu đối thủ"
      moduleTag="M03"
      isUnavailable={true}
      description="Theo dõi chiến lược nội dung, sản phẩm chủ lực và cấu trúc giá của các nhà bán hàng cùng ngành."
    >
      <div class="space-y-2">
        <p class="text-xs text-[#616c63]">
          Hồ sơ đối thủ: <span class="font-mono text-[#616c63]">0 hồ sơ được kích hoạt</span>
        </p>
        <button
          type="button"
          disabled
          class="w-full cursor-not-allowed rounded-md bg-[#e7e2d7] py-2 px-3 text-xs font-medium text-[#616c63]"
        >
          Thêm đối thủ theo dõi (Chưa khả dụng)
        </button>
      </div>
    </JobCard>

    <!-- Card 3: Opportunity Board -->
    <JobCard
      title="Bảng cơ hội (Opportunity Board)"
      moduleTag="M04"
      isUnavailable={true}
      description="Chấm điểm tiềm năng kinh doanh dựa trên biên lợi nhuận kỳ vọng và mức độ cạnh tranh."
    >
      <div class="space-y-2">
        <p class="text-xs text-[#616c63]">
          Thuật toán định giá: <span class="font-mono text-[#616c63]">Chờ hợp đồng P2</span>
        </p>
        <button
          type="button"
          disabled
          class="w-full cursor-not-allowed rounded-md bg-[#e7e2d7] py-2 px-3 text-xs font-medium text-[#616c63]"
        >
          Tạo thẻ cơ hội (Chưa khả dụng)
        </button>
      </div>
    </JobCard>
  </div>
</div>

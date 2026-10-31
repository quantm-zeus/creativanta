<script lang="ts">
  import UnavailableNotice from '$lib/components/UnavailableNotice.svelte';
  import JobCard from '$lib/components/JobCard.svelte';
</script>

<svelte:head>
  <title>Sáng tạo — Creativanta</title>
</svelte:head>

<div class="space-y-6">
  <!-- Job Header -->
  <div class="flex flex-col gap-2 sm:flex-row sm:items-center sm:justify-between">
    <div>
      <div class="flex items-center gap-2">
        <span class="rounded bg-[#274333] px-2 py-0.5 text-xs font-semibold text-[#fbf9f5]">
          Job 3
        </span>
        <h1 class="text-2xl font-bold tracking-tight text-[#242924] sm:text-3xl">
          Sáng tạo
        </h1>
      </div>
      <p class="text-sm text-[#616c63] mt-1">
        Content Studio & AI Generation (M05–M10) — Xưởng sản xuất kịch bản, AI Video và bảo toàn nhân vật Continuity OS.
      </p>
    </div>

    <span class="rounded-md border border-[#e7e2d7] bg-[#ffffff] px-3 py-1.5 text-xs font-medium text-[#242924]">
      Phase dự kiến: P3–P4
    </span>
  </div>

  <UnavailableNotice
    title="Bộ điều phối AI Provider & Media Render chưa kết nối"
    domain="Production & AI"
    requires="P4 (AI Video Studio & Workers)"
    message="Các adapter tích hợp đa nhà cung cấp (Gemini 2.5, Google Veo, Kling, Flux, ElevenLabs) và quy trình biên tập Revideo/FFmpeg chưa được triển khai trong P0. Nút tạo video bị khóa để đảm bảo không tiêu hao credit giả."
  />

  <div class="grid grid-cols-1 gap-5 md:grid-cols-2 lg:grid-cols-3">
    <!-- Card 1: Idea Engine -->
    <JobCard
      title="Idea Engine"
      moduleTag="M05"
      isUnavailable={true}
      description="Biến tín hiệu thị trường, phản hồi của người mua và góc phản biện thành ý tưởng kịch bản có tính chuyển đổi."
    >
      <div class="space-y-2">
        <div class="rounded bg-[#fbf9f5] p-2.5 text-xs text-[#616c63] border border-[#e7e2d7]">
          Khuôn mẫu ý tưởng: 0/12 mẫu khả dụng
        </div>
        <button
          type="button"
          disabled
          class="w-full cursor-not-allowed rounded-md bg-[#e7e2d7] py-2 px-3 text-xs font-medium text-[#616c63]"
        >
          Sinh ý tưởng bằng AI (Chưa khả dụng)
        </button>
      </div>
    </JobCard>

    <!-- Card 2: Script Lab -->
    <JobCard
      title="Script Lab"
      moduleTag="M06"
      isUnavailable={true}
      description="Soạn thảo kịch bản video ngắn đa phân cảnh kèm hook, call-to-action và chỉ dẫn góc máy chuẩn xác."
    >
      <div class="space-y-2">
        <div class="rounded bg-[#fbf9f5] p-2.5 text-xs text-[#616c63] border border-[#e7e2d7]">
          Kịch bản đang mở: Không có bản thảo
        </div>
        <button
          type="button"
          disabled
          class="w-full cursor-not-allowed rounded-md bg-[#e7e2d7] py-2 px-3 text-xs font-medium text-[#616c63]"
        >
          Tạo bản thảo mới (Chưa khả dụng)
        </button>
      </div>
    </JobCard>

    <!-- Card 3: Continuity OS & Studio -->
    <JobCard
      title="Continuity OS & Video Studio"
      moduleTag="M07/M08"
      isUnavailable={true}
      description="Duy trì tính nhất quán về gương mặt nhân vật, giọng điệu thương hiệu và không gian sản phẩm qua các tập phim."
    >
      <div class="space-y-2">
        <div class="rounded bg-[#fbf9f5] p-2.5 text-xs text-[#616c63] border border-[#e7e2d7]">
          Hồ sơ nhân vật (Character Pack): 0 hồ sơ
        </div>
        <button
          type="button"
          disabled
          class="w-full cursor-not-allowed rounded-md bg-[#e7e2d7] py-2 px-3 text-xs font-medium text-[#616c63]"
        >
          Khởi động render video (Chưa khả dụng)
        </button>
      </div>
    </JobCard>
  </div>
</div>

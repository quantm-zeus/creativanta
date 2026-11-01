<script lang="ts">
  import UnavailableNotice from '$lib/components/UnavailableNotice.svelte';
  import JobCard from '$lib/components/JobCard.svelte';
</script>

<svelte:head>
  <title>Xuất bản — Creativanta</title>
</svelte:head>

<div class="space-y-6">
  <!-- Job Header -->
  <div class="flex flex-col gap-2 sm:flex-row sm:items-center sm:justify-between">
    <div>
      <div class="flex items-center gap-2">
        <span class="rounded bg-[#274333] px-2 py-0.5 text-xs font-semibold text-[#fbf9f5]">
          Job 4
        </span>
        <h1 class="text-2xl font-bold tracking-tight text-[#242924] sm:text-3xl">
          Xuất bản
        </h1>
      </div>
      <p class="text-sm text-[#616c63] mt-1">
        Publish Hub & Hộp thư tương tác (M11–M12) — Điều phối phát hành đa kênh và quản lý hội thoại bán hàng.
      </p>
    </div>

    <span class="rounded-md border border-[#e7e2d7] bg-[#ffffff] px-3 py-1.5 text-xs font-medium text-[#242924]">
      Phase dự kiến: P5–P6
    </span>
  </div>

  <UnavailableNotice
    title="Chưa kết nối cổng phát hành và OAuth Connector"
    domain="Publishing & Distribution"
    requires="P5 (Publish Hub & Platform Connectors)"
    message="Toàn bộ kết nối tài khoản mạng xã hội (TikTok Content Posting API, YouTube Data API, Meta Graph API) chưa được liên kết. Không có thao tác đăng bài hoặc lên lịch giả lập nào được thực thi."
  />

  <div class="grid grid-cols-1 gap-5 md:grid-cols-2 lg:grid-cols-3">
    <!-- Card 1: Publish Hub Queue -->
    <JobCard
      title="Hàng đợi xuất bản (Publish Queue)"
      moduleTag="M11"
      isUnavailable={true}
      description="Lên lịch phát hành nội dung đa nền tảng có kiểm soát định dạng, hashtag và âm thanh bản quyền."
    >
      <div class="space-y-2">
        <div class="rounded bg-[#fbf9f5] p-2.5 text-xs text-[#616c63] border border-[#e7e2d7]">
          Nội dung trong hàng đợi: 0 bài
        </div>
        <button
          type="button"
          disabled
          class="w-full cursor-not-allowed rounded-md bg-[#e7e2d7] py-2 px-3 text-xs font-medium text-[#616c63]"
        >
          Lên lịch phát hành (Chưa khả dụng)
        </button>
      </div>
    </JobCard>

    <!-- Card 2: Connected Channels -->
    <JobCard
      title="Kênh liên kết (Connected Accounts)"
      moduleTag="M11"
      isUnavailable={true}
      description="Trạng thái ủy quyền OAuth và hạn mức đăng bài API của từng tài khoản được kết nối."
    >
      <div class="space-y-2">
        <div class="rounded bg-[#fbf9f5] p-2.5 text-xs text-[#616c63] border border-[#e7e2d7]">
          Tài khoản đã liên kết: 0 tài khoản
        </div>
        <button
          type="button"
          disabled
          class="w-full cursor-not-allowed rounded-md bg-[#e7e2d7] py-2 px-3 text-xs font-medium text-[#616c63]"
        >
          Kết nối tài khoản mới (Chưa khả dụng)
        </button>
      </div>
    </JobCard>

    <!-- Card 3: Unified Inbox -->
    <JobCard
      title="Hộp thư hội thoại & Intent"
      moduleTag="M12"
      isUnavailable={true}
      description="Hợp nhất bình luận, tin nhắn trực tiếp và phát hiện ý định mua hàng từ khách hàng tiềm năng."
    >
      <div class="space-y-2">
        <div class="rounded bg-[#fbf9f5] p-2.5 text-xs text-[#616c63] border border-[#e7e2d7]">
          Hội thoại chưa đọc: 0 cuộc
        </div>
        <button
          type="button"
          disabled
          class="w-full cursor-not-allowed rounded-md bg-[#e7e2d7] py-2 px-3 text-xs font-medium text-[#616c63]"
        >
          Mở hộp thư thống nhất (Chưa khả dụng)
        </button>
      </div>
    </JobCard>
  </div>
</div>

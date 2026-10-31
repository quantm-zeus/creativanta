<script lang="ts">
  interface Props {
    title?: string;
    message?: string;
    domain?: string;
    requires?: string;
  }

  let {
    title = 'Tính năng chưa khả dụng',
    message = 'Chức năng này hiện chưa được kích hoạt trong giai đoạn P0-01 Bootstrap Shell.',
    domain = 'Platform',
    requires = 'Phase tiếp theo'
  }: Props = $props();
</script>

<div
  class="rounded-lg border border-[#e7e2d7] bg-[#f4f0e8] p-4 text-[#242924] shadow-xs"
  role="alert"
>
  <div class="flex items-start gap-3">
    <span
      class="inline-flex h-6 w-6 shrink-0 items-center justify-center rounded-full bg-[#d94a31] text-xs font-bold text-[#fbf9f5]"
      aria-hidden="true"
    >
      !
    </span>
    <div class="space-y-1">
      <div class="flex flex-wrap items-center gap-2">
        <h4 class="text-sm font-semibold tracking-tight text-[#242924]">{title}</h4>
        <span
          class="rounded-sm bg-[#e7e2d7] px-2 py-0.5 text-[11px] font-medium tracking-wide text-[#616c63]"
        >
          {domain}
        </span>
        <span
          class="rounded-sm border border-[#d94a31]/20 bg-[#fbeee9] px-2 py-0.5 text-[11px] font-semibold text-[#d94a31]"
        >
          Yêu cầu: {requires}
        </span>
      </div>
      <p class="text-xs leading-relaxed text-[#616c63]">
        {message}
      </p>
    </div>
  </div>
</div>

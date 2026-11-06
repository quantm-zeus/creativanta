<script lang="ts">
  import { CANONICAL_LEGAL_LINKS, type LegalDocumentSpec } from '$lib/a11y';

  interface Props {
    data: {
      document: LegalDocumentSpec;
    };
  }

  let { data }: Props = $props();
  let doc = $derived(data.document);
</script>

<svelte:head>
  <title>{doc.titleVi} ({doc.titleEn}) — Creativanta</title>
</svelte:head>

<div class="mx-auto max-w-4xl px-4 py-8 sm:px-6 lg:px-8 space-y-6">
  <!-- Breadcrumb & Navigation Tabs -->
  <nav aria-label="Tài liệu pháp lý và tuân thủ" class="flex flex-wrap items-center gap-2 border-b border-[#e7e2d7] pb-4">
    {#each CANONICAL_LEGAL_LINKS as link}
      {@const isCurrent = link.href === doc.href}
      <a
        href={link.href}
        aria-current={isCurrent ? 'page' : undefined}
        class="rounded-lg px-3 py-1.5 text-xs font-semibold transition-colors {isCurrent
          ? 'bg-[#274333] text-[#ffffff]'
          : 'bg-[#f4f0e8] text-[#242924] hover:bg-[#e7e2d7]'}"
      >
        {link.labelVi}
      </a>
    {/each}
  </nav>

  <!-- Launch-Gate Compliance Notice (LEG-H-001) -->
  <div
    role="status"
    class="rounded-xl border border-[#854d0e]/30 bg-[#fef9c3]/60 p-4 text-xs text-[#854d0e]"
  >
    <div class="flex flex-wrap items-center justify-between gap-2 font-bold">
      <span>Trạng thái pháp chế: Phê duyệt kỹ thuật · Chờ ký duyệt Pháp chế cuối cùng trước Public GA</span>
      <span class="rounded bg-[#854d0e]/15 px-2 py-0.5 font-mono text-[11px]">
        {doc.blockerRef} · v{doc.version}
      </span>
    </div>
    <p class="mt-1 text-[11px] leading-relaxed">
      Tài liệu này áp dụng bộ quy chuẩn kỹ thuật tại <code>docs/01_business/legal_compliance.md</code> (Hiệu lực dự kiến: {doc.effectiveDate}).
    </p>
  </div>

  <!-- Document Header -->
  <header class="rounded-xl border border-[#e7e2d7] bg-[#ffffff] p-6 shadow-xs">
    <div class="text-xs font-semibold uppercase tracking-wider text-[#616c63]">
      {doc.titleEn}
    </div>
    <h1 class="mt-1 text-2xl font-bold text-[#242924]">
      {doc.titleVi}
    </h1>
    <p class="mt-2 text-sm text-[#616c63] leading-relaxed">
      {doc.summary}
    </p>
  </header>

  <!-- Document Sections -->
  <article class="space-y-4">
    {#each doc.sections as section}
      <section class="rounded-xl border border-[#e7e2d7] bg-[#ffffff] p-6 shadow-xs space-y-3">
        <h2 class="text-base font-bold text-[#242924]">
          {section.heading}
        </h2>
        {#each section.paragraphs as paragraph}
          <p class="text-sm text-[#242924] leading-relaxed">
            {paragraph}
          </p>
        {/each}
        {#if section.bullets && section.bullets.length > 0}
          <ul class="list-disc pl-5 space-y-1.5 text-sm text-[#616c63]">
            {#each section.bullets as bullet}
              <li>{bullet}</li>
            {/each}
          </ul>
        {/if}
      </section>
    {/each}
  </article>
</div>

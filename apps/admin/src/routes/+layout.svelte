<script lang="ts">
  import '../app.css';
  import type { Snippet } from 'svelte';
  let { children }: { children?: Snippet } = $props();
</script>
<div class="min-h-screen bg-[#fbf9f5] text-[#242924]">
  <header class="border-b border-[#e8e5dc] bg-[#fffefa] px-5 py-4">
    <div class="mx-auto flex max-w-5xl items-center gap-3">
      <span class="inline-flex h-9 w-9 items-center justify-center rounded-xl bg-[#d94a31] text-white font-bold">C</span>
      <strong class="text-xl tracking-tight">creativanta<span class="text-[#d94a31]">.</span></strong>
      <span class="ml-auto rounded-lg border border-[#e8e5dc] px-3 py-2 text-[10px] font-semibold uppercase tracking-widest text-[#7d837b]">INTERNAL ADMIN · P0</span>
    </div>
  </header>
  <main class="mx-auto max-w-5xl px-5 py-12">
    {#if children}{@render children()}{/if}
  </main>
</div>

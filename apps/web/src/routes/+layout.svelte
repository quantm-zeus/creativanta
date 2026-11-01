<script lang="ts">
  import '../app.css';
  import { page } from '$app/stores';
  import Header from '$lib/components/Header.svelte';
  import Navigation from '$lib/components/Navigation.svelte';
  import type { Snippet } from 'svelte';

  interface Props {
    children?: Snippet;
  }

  let { children }: Props = $props();
</script>

<div class="min-h-screen flex flex-col bg-[#fbf9f5] text-[#242924]">
  <!-- Top Global Header -->
  <Header />

  <!-- Job-based Navigation (Responsive: Desktop Top Bar / Mobile Bottom Bar) -->
  <Navigation currentPath={$page.url.pathname} />

  <!-- Main Viewport Content -->
  <main class="flex-1 px-4 py-6 sm:px-6 md:px-8 max-w-7xl w-full mx-auto pb-20 md:pb-10">
    {#if children}
      {@render children()}
    {/if}
  </main>
</div>

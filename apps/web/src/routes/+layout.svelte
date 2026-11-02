<script lang="ts">
  import '../app.css';
  import { onMount } from 'svelte';
  import { page } from '$app/stores';
  import Header from '$lib/components/Header.svelte';
  import Navigation from '$lib/components/Navigation.svelte';
  import NotificationDrawer from '$lib/components/NotificationDrawer.svelte';
  import HelpDrawer from '$lib/components/HelpDrawer.svelte';
  import { authStore } from '$lib/auth';
  import type { Snippet } from 'svelte';

  interface Props {
    children?: Snippet;
  }

  let { children }: Props = $props();

  onMount(() => {
    authStore.init();
  });
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

  <!-- Global Slide-over Drawers for Scoped Notifications & Contextual Help -->
  <NotificationDrawer />
  <HelpDrawer />
</div>

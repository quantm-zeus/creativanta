<script lang="ts">
  import '../app.css';
  import { onMount } from 'svelte';
  import { page } from '$app/stores';
  import Header from '$lib/components/Header.svelte';
  import Navigation from '$lib/components/Navigation.svelte';
  import NotificationDrawer from '$lib/components/NotificationDrawer.svelte';
  import HelpDrawer from '$lib/components/HelpDrawer.svelte';
  import CopilotSidebar from '$lib/copilot/CopilotSidebar.svelte';
  import { authStore } from '$lib/auth';
  import { t, type SupportedLocale } from '$lib/i18n';
  import { CANONICAL_LEGAL_LINKS } from '$lib/a11y';
  import type { Snippet } from 'svelte';

  interface Props {
    children?: Snippet;
  }

  let { children }: Props = $props();
  let locale = $state<SupportedLocale>('vi');
  let liveAnnouncement = $state('');

  function switchLocale(nextLocale: SupportedLocale) {
    locale = nextLocale;
    liveAnnouncement =
      nextLocale === 'vi'
        ? 'Đã chuyển ngôn ngữ hiển thị sang Tiếng Việt'
        : 'Display language switched to English';
  }

  onMount(() => {
    authStore.init();
  });
</script>

<div class="min-h-screen flex flex-col bg-[#fbf9f5] text-[#242924]">
  <!-- WCAG 2.1 AA Skip-to-Content Link -->
  <a
    href="#main-content"
    class="sr-only focus:not-sr-only focus:fixed focus:top-2 focus:left-2 focus:z-50 focus:px-4 focus:py-2 focus:rounded-lg focus:bg-[#1e293b] focus:text-white focus:outline-none focus:ring-2 focus:ring-indigo-500"
  >
    {t('shared_shell_skip_to_content', locale)}
  </a>

  <!-- Screen Reader ARIA Live Regions (accessibility_spec.md §4.1) -->
  <div
    class="sr-only"
    role="status"
    aria-live="polite"
    aria-atomic="true"
    aria-label={t('shared_shell_live_polite_label', locale)}
  >
    {liveAnnouncement}
  </div>
  <div
    class="sr-only"
    role="alert"
    aria-live="assertive"
    aria-atomic="true"
    aria-label={t('shared_shell_live_assertive_label', locale)}
  ></div>

  <!-- Top Global Header -->
  <Header />

  <!-- Job-based Navigation (Responsive: Desktop Top Bar / Mobile Bottom Bar) -->
  <Navigation currentPath={$page.url.pathname} />

  <!-- Main Viewport Content -->
  <main
    id="main-content"
    tabindex="-1"
    class="flex-1 px-4 py-6 sm:px-6 md:px-8 max-w-7xl w-full mx-auto pb-20 md:pb-10"
  >
    {#if children}
      {@render children()}
    {/if}
  </main>

  <!-- Legal Compliance & Localization Footer (legal_compliance.md §1, §8.1 & i18n_guide.md) -->
  <footer
    aria-label={t('shared_legal_footer_label', locale)}
    class="border-t border-[#e5e0d8] bg-[#f5f2eb] px-4 py-4 sm:px-6 md:px-8 text-xs text-[#4b5563]"
  >
    <div class="max-w-7xl mx-auto flex flex-col sm:flex-row items-start sm:items-center justify-between gap-3">
      <nav aria-label={t('shared_legal_footer_label', locale)} class="flex flex-wrap gap-x-4 gap-y-1">
        {#each CANONICAL_LEGAL_LINKS as link (link.id)}
          <a
            href={link.href}
            class="underline-offset-2 hover:underline focus:outline-none focus:ring-2 focus:ring-indigo-500 rounded px-1 py-0.5"
          >
            {locale === 'vi' ? link.labelVi : link.labelEn}
          </a>
        {/each}
      </nav>
      <div class="flex items-center gap-2" role="group" aria-label={t('shared_shell_locale_switcher_label', locale)}>
        <button
          type="button"
          onclick={() => switchLocale('vi')}
          aria-pressed={locale === 'vi'}
          class="px-2 py-1 rounded border text-xs font-medium {locale === 'vi'
            ? 'bg-[#1e293b] text-white border-[#1e293b]'
            : 'bg-white text-[#242924] border-[#d1cdc3]'}"
        >
          VI
        </button>
        <button
          type="button"
          onclick={() => switchLocale('en')}
          aria-pressed={locale === 'en'}
          class="px-2 py-1 rounded border text-xs font-medium {locale === 'en'
            ? 'bg-[#1e293b] text-white border-[#1e293b]'
            : 'bg-white text-[#242924] border-[#d1cdc3]'}"
        >
          EN
        </button>
      </div>
    </div>
  </footer>

  <!-- Global Slide-over Drawers for Scoped Notifications, Contextual Help & Copilot AI -->
  <NotificationDrawer />
  <HelpDrawer />
  <CopilotSidebar />
</div>

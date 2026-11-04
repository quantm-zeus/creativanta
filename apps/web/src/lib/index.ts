export { V5_THEME, type V5Theme } from './constants/theme';
export {
  JOB_NAV_ITEMS,
  P0_UNSUPPORTED_FEATURES,
  type NavItem,
  type UnsupportedCapabilityNotice
} from './constants/navigation';

export { default as Header } from './components/Header.svelte';
export { default as Navigation } from './components/Navigation.svelte';
export { default as JobCard } from './components/JobCard.svelte';
export { default as UnavailableNotice } from './components/UnavailableNotice.svelte';
export { default as AuthStatus } from './components/AuthStatus.svelte';
export * from './auth';
export * from './capability';
export * from './script';
export * from './continuity';
export * from './copilot';
export * from './publish';
export * from './engagement';
export { default as SourceChainLineage } from './content/SourceChainLineage.svelte';
export { default as ConcurrentConflictBanner } from './content/ConcurrentConflictBanner.svelte';
export { default as CreativeAssistantPublishGuard } from './content/CreativeAssistantPublishGuard.svelte';
export { hasPublishIntent, type SourceChainLineage as SourceChainLineageData, type LineageNode } from './content';

import { describe, expect, it } from 'vitest';
import { get } from 'svelte/store';
import {
  helpStore,
  filteredArticles,
  KB_CATEGORIES,
  KB_ARTICLES
} from './store';

describe('Contextual Help Center & Knowledge Base (docs/02_features/platform/help_center.md)', () => {
  it('defines knowledge base categories and seed articles', () => {
    expect(KB_CATEGORIES.length).toBeGreaterThanOrEqual(4);
    expect(KB_ARTICLES.length).toBeGreaterThanOrEqual(5);

    const slugs = KB_ARTICLES.map((a) => a.slug);
    expect(slugs).toContain('6-operator-modes-guide');
    expect(slugs).toContain('understanding-why-this-number');
    expect(slugs).toContain('reconnect-tiktok-shop-channel');
  });

  it('filters articles by search query', () => {
    helpStore.searchQuery.set('TikTok');

    const results = get(filteredArticles);
    expect(results.length).toBeGreaterThanOrEqual(1);
    expect(results.some((a) => a.title.includes('TikTok') || a.summary.includes('TikTok'))).toBe(true);

    helpStore.searchQuery.set('');
  });

  it('filters articles by active module', () => {
    helpStore.activeModuleFilter.set('M11');

    const results = get(filteredArticles);
    expect(results.length).toBeGreaterThanOrEqual(1);
    expect(results.every((a) => a.moduleRef.includes('M11') || a.moduleRef === 'help')).toBe(true);

    helpStore.activeModuleFilter.set(null);
  });

  it('records helpful and unhelpful article ratings', () => {
    const article = KB_ARTICLES[0];
    const initialHelpful = article.helpfulVotes;

    helpStore.rateArticle(article.id, true);

    const ratings = get(helpStore.userRatings);
    expect(ratings[article.id]).toBe(true);

    const articles = get(helpStore.articles);
    const updated = articles.find((a) => a.id === article.id);
    expect(updated?.helpfulVotes).toBe(initialHelpful + 1);
  });
});

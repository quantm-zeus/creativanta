import { describe, it, expect } from 'vitest';
import { JOB_NAV_ITEMS } from './navigation';

describe('Navigation and Auth Route Integrity', () => {
  it('preserves all five canonical jobs-first navigation items', () => {
    expect(JOB_NAV_ITEMS).toHaveLength(5);
    const ids = JOB_NAV_ITEMS.map((item) => item.id);
    expect(ids).toEqual(['overview', 'explore', 'create', 'publish', 'commerce']);
  });

  it('keeps navigation destinations matching canonical paths', () => {
    const hrefs = JOB_NAV_ITEMS.map((item) => item.href);
    expect(hrefs).toEqual(['/', '/kham-pha', '/sang-tao', '/xuat-ban', '/kinh-doanh']);
  });

  it('preserves module references in navigation', () => {
    const modules = JOB_NAV_ITEMS.map((item) => item.moduleRef);
    expect(modules).toContain('M01');
    expect(modules).toContain('M02-M04');
    expect(modules).toContain('M05-M10');
    expect(modules).toContain('M11-M12');
    expect(modules).toContain('M13-M19');
  });
});

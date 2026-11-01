import { describe, expect, it } from 'vitest';
import { JOB_NAV_ITEMS, P0_UNSUPPORTED_FEATURES } from './navigation';

describe('P0-01 job navigation contract', () => {
  it('uses five distinct, jobs-first destinations', () => {
    expect(JOB_NAV_ITEMS).toHaveLength(5);
    expect(new Set(JOB_NAV_ITEMS.map((x) => x.href)).size).toBe(5);
    expect(JOB_NAV_ITEMS[0].href).toBe('/');
  });
  it('keeps undeployed backend capabilities explicitly unavailable', () => {
    expect(P0_UNSUPPORTED_FEATURES.length).toBeGreaterThan(0);
    expect(P0_UNSUPPORTED_FEATURES.every((x) => x.status !== undefined)).toBe(true);
    expect(P0_UNSUPPORTED_FEATURES.map((x) => x.feature).join(' ')).toMatch(/Clerk|ConnectRPC/);
  });
});

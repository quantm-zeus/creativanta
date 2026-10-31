import { describe, expect, it } from 'vitest';
import { ADMIN_UI_ENABLED, canAccessAdmin } from './access';
describe('P0 admin remains restricted', () => {
  it('denies access without independent admin authentication', () => {
    expect(ADMIN_UI_ENABLED).toBe(false);
    expect(canAccessAdmin()).toBe(false);
  });
});

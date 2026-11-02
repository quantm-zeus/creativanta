import { describe, expect, it } from 'vitest';
import {
  OPERATOR_MODES,
  DEFAULT_OPERATOR_MODE,
  modeStore,
  type OperatorModeId
} from './modes';

describe('Six Canonical Operator Modes (Acceptance Target 1)', () => {
  it('defines exactly the 6 canonical operator modes', () => {
    expect(OPERATOR_MODES).toHaveLength(6);
    const modeIds = OPERATOR_MODES.map((m) => m.id);
    expect(modeIds).toEqual([
      'creator',
      'seller',
      'affiliate_operator',
      'live_operator',
      'agency_mcn',
      'brand_collaboration'
    ]);
  });

  it('assigns unique names and primary module tags to each mode', () => {
    const names = new Set(OPERATOR_MODES.map((m) => m.name));
    expect(names.size).toBe(6);

    for (const mode of OPERATOR_MODES) {
      expect(mode.tagline.length).toBeGreaterThan(5);
      expect(mode.priorityBrief.length).toBeGreaterThan(10);
      expect(mode.focusMetrics.length).toBeGreaterThanOrEqual(3);
    }
  });

  it('defaults to creator mode and supports switching modes', () => {
    expect(DEFAULT_OPERATOR_MODE).toBe('creator');

    let currentMode: OperatorModeId = 'creator';
    const unsubscribe = modeStore.subscribe((m) => (currentMode = m));

    modeStore.setMode('seller');
    expect(currentMode).toBe('seller');

    const def = modeStore.getModeDef('seller');
    expect(def.name).toContain('Seller');
    expect(def.primaryModule).toBe('M13-M19');

    // Restore to default
    modeStore.setMode('creator');
    unsubscribe();
  });
});

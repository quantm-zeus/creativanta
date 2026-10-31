/** P0-01 guard is intentionally closed; real admin auth must be server enforced. */
export const ADMIN_UI_ENABLED = false as boolean;
/**
 * Frontend notice only, NOT a security boundary. Do not enable before
 * isolated identity, VPN/MFA and backend permission verification in P0-07.
 */
export function canAccessAdmin(): boolean {
  return ADMIN_UI_ENABLED;
}

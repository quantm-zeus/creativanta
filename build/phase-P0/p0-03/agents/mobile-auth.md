# Evidence Report: Mobile User-Facing Identity Entry & Session Boundary (P0-03)

- **Agent Name**: `mobile-auth`
- **Role**: Flutter mobile user-facing identity entry
- **Branch**: `feat/p0-03-mobile-auth`
- **Base Commit**: `03e423ad489eb367a533f2680becce5ff5476862`
- **Timestamp**: 2026-11-01
- **Status**: IMPLEMENTED / TESTS_PASSING (Slice P0-03 mobile-auth)

---

## 1. Summary of Changes

Implemented a secure, responsive, fail-closed and testable Flutter sign-in/session boundary, workspace switcher (M004), and operator mode selection across all six canonical operator modes. Owned code is strictly confined to `apps/mobile/**`. No backend, web, or shared workflow files were modified. The shared manifest (`build/phase-P0/p0-03/manifest.json`) was NOT modified.

### Files Created & Modified

| File | Type | Description |
|---|---|---|
| `apps/mobile/lib/auth/auth_models.dart` | Created | Canonical models: `OperatorMode` (6 modes), `WorkspaceSummary`, `UserIdentity`, `AuthSession`, `AuthStatus`, `AuthFailure`, `AuthResult` |
| `apps/mobile/lib/auth/secure_token_store.dart` | Created | `SecureTokenStore` contract + `EphemeralSecureTokenStore` preventing cleartext JWT persistence, enforcing memory-zeroing and redaction |
| `apps/mobile/lib/auth/auth_provider_adapter.dart` | Created | `AuthProviderAdapter` explicit interface with `ClerkAuthProviderAdapter` (fail-closed unconfigured) and `TestAuthProviderAdapter` (test double only) |
| `apps/mobile/lib/ui/auth/sign_in_screen.dart` | Created | `MobileAuthScreen` with fail-closed external provider gate banner, input validation, and OAuth hooks |
| `apps/mobile/lib/ui/auth/workspace_switcher_sheet.dart` | Created | `WorkspaceSwitchSheet` (M004) modal bottom sheet for switching workspaces without re-auth (RULE-AUTH-003) |
| `apps/mobile/lib/ui/auth/operator_mode_sheet.dart` | Created | `OperatorModeSheet` for switching between all six operator modes |
| `apps/mobile/lib/ui/auth/session_expired_dialog.dart` | Created | `SessionExpiredDialog` handling token expiry (EC-AUTH-002) with refresh / sign-out |
| `apps/mobile/lib/main.dart` | Modified | Root `CreativantaApp` stateful auth router and `WorkspaceShell` preserving navigation destinations, unbuilt disabled actions, workspace switcher, and mode chip |
| `apps/mobile/test/auth/secure_token_store_test.dart` | Created | 6 unit tests verifying storage contracts, zeroing, and token redaction |
| `apps/mobile/test/auth/auth_adapter_test.dart` | Created | 8 unit tests verifying fail-closed unconfigured adapter, test double behavior, workspace switching, and mode switching |
| `apps/mobile/test/auth/auth_widget_test.dart` | Created | 5 widget tests covering `MobileAuthScreen`, `WorkspaceSwitchSheet`, `OperatorModeSheet`, and `SessionExpiredDialog` |
| `apps/mobile/test/widget_test.dart` | Modified | 4 integration widget tests verifying unauthenticated external gate boundary and authenticated shell behavior |

---

## 2. Security & Architecture Invariants Enforced

1. **Explicit Provider-Adapter & External Provider Gate**:
   - `ClerkAuthProviderAdapter` defaults to `AuthStatus.unconfigured` when credentials are absent.
   - External provider gate `EXT-GATE-CLERK-MOBILE` is explicitly rendered on screen and in error messages.
   - Any attempt to sign in while unconfigured fails closed with `PROVIDER_UNAVAILABLE_001`.
   - Never creates fake authentication bypasses.
2. **Zero Cleartext JWT Persistence**:
   - `SecureTokenStore` interface specifies that tokens must not be persisted in cleartext files or shared preferences.
   - In-memory obfuscation and memory-zeroing on token deletion/logout.
   - `AuthSession.toString()` and `EphemeralSecureTokenStore.toString()` redact sensitive tokens (`[REDACTED]`).
3. **Workspace Switching Without Re-authentication (RULE-AUTH-003)**:
   - User session maintains active and available workspaces.
   - Tapping an available workspace in M004 sheet updates application context without re-authenticating or issuing new tokens.
4. **All Six Operator Mode Identities Preserved**:
   - `creator` (Sáng tạo nội dung)
   - `seller` (Bán hàng & Tồn kho)
   - `affiliate_operator` (Tiếp thị liên kết KOC/KOL)
   - `live_operator` (Phòng chiến Live Commerce)
   - `agency_mcn` (Đội ngũ Agency / MCN)
   - `brand_collaboration` (Hợp tác nhãn hàng & Tài trợ)
5. **Fail-Closed Unbuilt Features**:
   - Unbuilt actions (e.g. "+ Tạo workspace mới" in M004, feature cards in shell) stay disabled without demo data.

---

## 3. Verification & Test Evidence

### `flutter analyze`
```
Analyzing mobile...
No issues found! (ran in 7.1s)
```
Exit code: 0

### `flutter test`
Total test count: 52 tests across 5 test suites.
- `test/transport_validation_test.dart`: 23 tests passed
- `test/generated_proto_test.dart`: 2 tests passed
- `test/auth/secure_token_store_test.dart`: 6 tests passed
- `test/auth/auth_adapter_test.dart`: 12 tests passed
- `test/auth/auth_widget_test.dart`: 5 tests passed
- `test/widget_test.dart`: 4 tests passed
```
00:10 +52: All tests passed!
```
Exit code: 0

### `git diff --check`
```
(No whitespace or formatting errors)
```
Exit code: 0

---

## 4. External Gates & Missing Items

- **EXT-GATE-CLERK-MOBILE**: Official Clerk production publishable key (`pk_live_...` or `pk_test_...`) and native mobile SDK configuration (when GA). Currently fail-closed with `PROVIDER_UNAVAILABLE_001`.
- **E2E Backend Wire Integration**: gRPC/Connect client connecting mobile auth session to live Go API (`apps/api/internal/identity`) gated on backend deployment and network endpoints.

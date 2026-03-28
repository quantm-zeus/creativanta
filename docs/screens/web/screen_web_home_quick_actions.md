# Screen: Web — Quick Action Menu

> **Screen ID**: W007
> **Module**: M01 — Home & Decision
> **Route**: N/A (global overlay component)
> **Platform**: Web (SvelteKit)
> **Upstream**: Pack 01 §4, Product Freeze §9, B5 RBAC §2.1

---

## 1. Purpose & Context

The Quick Action Menu is a floating action button (FAB) permanently anchored to the bottom-right of every app page. When activated, it expands into a radial or stacked menu offering one-tap access to the most frequent creation actions across all modules. This eliminates the need to navigate through the sidebar to start creating — the creative impulse can be captured in one click from anywhere.

### User Story
> As a creator browsing analytics or checking trends, I want to immediately start creating content (idea, script, AI generation) without navigating away — capturing the inspiration moment.

### Business Goals
- Reduce friction between inspiration and creation (fewer navigation steps = higher creation rate)
- Increase DAU creation actions by making them always accessible
- Provide a consistent creation entry point regardless of current location
- Permission-aware: only show actions the user can perform

### When This Component Is Used
- **Always visible**: On every authenticated page within the main app shell
- **Hidden on**: Login, onboarding, checkout (Stripe), and admin pages
- **Disabled**: When a modal is open (dimmed, non-interactive)

### Entry Points
- Click FAB button (✨ icon, bottom-right)
- Keyboard shortcut: `Cmd+N` (Mac) / `Ctrl+N` (Windows)

### Exit Points (navigation from menu)
- "💡 Tạo ý tưởng mới" → `/ideas/new`
- "📝 Viết script" → `/scripts/new`
- "🤖 AI tạo ý tưởng" → `/ideas/generate`
- "🎬 AI Studio" → `/studio`
- "📤 Đăng bài nhanh" → `/publish/compose`
- "🛍️ Thêm sản phẩm" → `/products/new`
- "📨 Tin nhắn mới" → `/inbox/compose`

---

## 2. Preconditions / Postconditions

### Preconditions
- User authenticated with valid session
- Not on excluded pages (login, onboarding, checkout, admin)
- User belongs to at least one workspace
- At least one action permitted by user's role

### Postconditions
- Navigation to selected creation screen
- Analytics event dispatched with action type and source page
- Menu auto-closes after action selection
- Last used action tracked for potential re-ordering (future enhancement)

---

## 3. Screen Layout

### Responsive Behavior
| Breakpoint | Layout |
|---|---|
| Desktop (≥1280px) | FAB bottom-right (32px from edge), menu expands upward as stacked list |
| Tablet (768-1279px) | Same position, same behavior |
| Mobile (≤767px) | FAB bottom-right (16px from edge), larger touch target (56px), full-width bottom sheet on expand |

### ASCII Wireframe (Collapsed)
```
                                                    ┌─────┐
                                                    │ ✨  │ ← FAB (48px)
                                                    └─────┘
                                                    Fixed: bottom 32px, right 32px
```

### ASCII Wireframe (Expanded — Desktop)
```
                                        ┌───────────────────────────────┐
                                        │  💡 Tạo ý tưởng mới         │
                                        ├───────────────────────────────┤
                                        │  📝 Viết script              │
                                        ├───────────────────────────────┤
                                        │  🤖 AI tạo ý tưởng          │
                                        ├───────────────────────────────┤
                                        │  🎬 AI Studio                │
                                        ├───────────────────────────────┤
                                        │  📤 Đăng bài nhanh           │
                                        ├───────────────────────────────┤
                                        │  🛍️ Thêm sản phẩm          │
                                        ├───────────────────────────────┤
                                        │  📨 Tin nhắn mới             │
                                        └───────────────────────────────┘
                                                    ┌─────┐
                                                    │  ✕  │ ← FAB (close icon)
                                                    └─────┘
```

### ASCII Wireframe (Expanded — Mobile Bottom Sheet)
```
┌──────────────────────────────────────────────────────────────────────┐
│  ──────  (drag handle)                                               │
│                                                                      │
│  💡 Tạo ý tưởng mới                                         →      │
│  📝 Viết script                                              →      │
│  🤖 AI tạo ý tưởng                                          →      │
│  🎬 AI Studio                                                →      │
│  📤 Đăng bài nhanh                                           →      │
│  🛍️ Thêm sản phẩm                                          →      │
│  📨 Tin nhắn mới                                             →      │
│                                                                      │
│  [Hủy]                                                               │
└──────────────────────────────────────────────────────────────────────┘
```

---

## 4. Component Hierarchy

```
QuickActionFAB (global component, mounted in +layout.svelte)
├── FABButton
│   ├── CollapsedState
│   │   ├── Icon (✨ sparkle)
│   │   └── PulseAnimation (subtle pulse every 30s if user hasn't used in session)
│   └── ExpandedState
│       └── Icon (✕ close)
├── BackdropOverlay (semi-transparent, click to close)
├── ActionMenu (Desktop: stacked list above FAB / Mobile: bottom sheet)
│   └── ActionItem[]
│       ├── ActionIcon (emoji)
│       ├── ActionLabel (Vietnamese)
│       ├── KeyboardShortcut (desktop only, faded — e.g., "⌘1")
│       └── ClickHandler → navigate
├── KeyboardHandler
│   ├── Cmd+N → toggle menu
│   ├── Escape → close menu
│   ├── 1-7 → quick select action (when menu open)
│   └── Tab → cycle through actions
└── PermissionFilter (hides actions user can't perform)
```

### Action Registry

| # | Action | Label | Icon | Route | Permission | Shortcut |
|---|---|---|---|---|---|---|
| 1 | Create idea | "Tạo ý tưởng mới" | 💡 | `/ideas/new` | `idea:create` | `⌘1` |
| 2 | Write script | "Viết script" | 📝 | `/scripts/new` | `script:create` | `⌘2` |
| 3 | AI generate idea | "AI tạo ý tưởng" | 🤖 | `/ideas/generate` | `idea:generate` | `⌘3` |
| 4 | AI Studio | "AI Studio" | 🎬 | `/studio` | `asset:generate` | `⌘4` |
| 5 | Quick publish | "Đăng bài nhanh" | 📤 | `/publish/compose` | `publish:create` | `⌘5` |
| 6 | Add product | "Thêm sản phẩm" | 🛍️ | `/products/new` | `product:create` | `⌘6` |
| 7 | New message | "Tin nhắn mới" | 📨 | `/inbox/compose` | `inbox:reply` | `⌘7` |

---

## 5. Displayed Data / Data Binding

| UI Element | Data Source | API | Display Format | Cache |
|---|---|---|---|---|
| Action visibility | User permissions (from auth context) | `AuthStore.permissions` (client-side store) | Show/hide per action | Session |
| Action list | Static configuration (hardcoded registry) | None (client-side) | Ordered list | Static |
| Credit indicator (optional) | `CreditService/GetBalance` | Pre-fetched in layout | Small badge on AI actions if credits low: "🪙 120" | 5m TTL |

### Permission-Based Visibility
| Role | Visible Actions |
|---|---|
| Owner | All 7 actions |
| Admin | All 7 actions |
| Manager | 💡📝🤖🎬📤🛍️📨 (all 7) |
| Editor | 💡📝🤖🎬📤📨 (no products) |
| Contributor | 💡📝🤖📤 (limited — no AI Studio, no products, no messages) |
| Viewer | 💡 only (create idea as notes) |
| External | ❌ FAB hidden entirely |

---

## 6. User Actions

| # | Action | Trigger | API Call | System Response | Permission |
|---|---|---|---|---|---|
| 1 | Toggle menu | Click FAB or Cmd+N | — | Menu expands/collapses with spring animation | Any (authenticated) |
| 2 | Select action | Click action item or press 1-7 | — | Navigate to route. Menu closes. Analytics event. | Per-action permission |
| 3 | Close menu | Click backdrop, press Escape, or click FAB ✕ | — | Menu collapses with reverse animation | Any |
| 4 | Dismiss backdrop | Click outside menu | — | Menu closes | Any |

---

## 7. States / State Machine

| State | Condition | Visual |
|---|---|---|
| COLLAPSED | Default state | FAB: ✨ icon, 48px circle button, bottom-right fixed. Subtle shadow. |
| EXPANDING | Transition (200ms) | FAB icon rotates to ✕. Menu items stagger-in from bottom (50ms per item). Backdrop fades in. |
| EXPANDED | Menu visible | FAB shows ✕. Menu list visible. Backdrop overlay. Focus trapped in menu. |
| COLLAPSING | Transition (150ms) | Menu items stagger-out (reverse order). FAB icon rotates back to ✨. Backdrop fades out. |
| HIDDEN | On excluded pages | FAB not rendered at all |
| DISABLED | Modal open on page | FAB visible but dimmed, `pointer-events: none`, `opacity: 0.3` |

---

## 8. Validation Rules

N/A — No form inputs. All actions are navigation-only.

---

## 9. Permission Matrix

| Feature | Owner | Admin | Manager | Editor | Contributor | Viewer | External |
|---|---|---|---|---|---|---|---|
| See FAB button | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ❌ |
| See all actions | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ |
| Use keyboard shortcuts | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ❌ |

See §5 for detailed per-role action visibility.

---

## 10. Navigation Map

```
Quick Action Menu (global overlay)
├── → /ideas/new                  (💡 Create idea)
├── → /scripts/new               (📝 Write script)
├── → /ideas/generate             (🤖 AI generate idea)
├── → /studio                     (🎬 AI Studio)
├── → /publish/compose            (📤 Quick publish)
├── → /products/new               (🛍️ Add product)
└── → /inbox/compose              (📨 New message)
```

---

## 11. Error Handling

| Error Type | Trigger | UI Response | Recovery |
|---|---|---|---|
| Navigation fails | Target route errors (rare) | Standard SvelteKit error page | Browser back |
| Permission changed mid-session | Role downgraded while menu open | Action click → 403 → Toast: "Bạn không còn quyền thực hiện hành động này." | Menu re-renders with updated permissions |
| Credits insufficient | Click AI action with 0 credits | Navigate to AI Studio/Generator → credit warning shown on target screen | Not blocked at FAB level (soft warning on destination) |

> **Note**: The FAB itself rarely encounters errors — it's a navigation component. Most errors surface on the destination screens.

---

## 12. Accessibility

| Element | Requirement |
|---|---|
| FAB button | `aria-label="Open quick action menu"` when collapsed, `aria-label="Close quick action menu"` when expanded |
| FAB button | `aria-expanded="true/false"` |
| Action menu | `role="menu"`, `aria-label="Quick actions"` |
| Action items | `role="menuitem"`, `aria-label` includes action name: "Create new idea" |
| Backdrop | Click to dismiss — also `aria-hidden="true"` (not focusable) |
| Focus trap | When expanded: Tab cycles within menu items. Shift+Tab to FAB close. |
| Escape | Closes menu and returns focus to FAB button |
| Reduced motion | If `prefers-reduced-motion`: disable stagger animation, use simple fade |
| Focus indicator | Visible focus ring on all action items when navigated via keyboard |
| Color contrast | All text meets WCAG 2.1 AA (4.5:1 ratio) |

---

## 13. Loading Behavior

| Stage | Duration | Visual |
|---|---|---|
| Page mount | 0ms | FAB renders immediately (no data dependency) |
| First interaction | 0ms | Menu expands instantly (all data is client-side) |

> **Performance**: FAB has zero data dependencies on mount. Permissions are already in the auth store. Action list is static. No API calls needed.

---

## 14. Performance Requirements

| Metric | Target | Measurement |
|---|---|---|
| FAB render | < 50ms | Component mounts in layout, zero API cost |
| Menu expand animation | 200ms | Spring animation completes in 200ms |
| Menu collapse | 150ms | Reverse animation slightly faster |
| Navigation on click | < 100ms | Route navigation starts within 100ms of click |
| Memory footprint | < 5KB | Small component, minimal DOM |

---

## 15. Real-time Updates

| Data | Method | Frequency |
|---|---|---|
| Permission changes | Reactive store subscription | Real-time (auth store updates propagate) |
| Credit balance badge | Store subscription | Updates when credits change (from layout-level polling) |

---

## 16. Localization Notes

- Primary language: Vietnamese
- Action labels: Vietnamese ("Tạo ý tưởng mới", "Viết script")
- Keyboard shortcuts: Universal (⌘1, ⌘2) — not localized
- Tone: Action-oriented verbs ("Tạo", "Viết", "Đăng", "Thêm")
- No currency or date formatting in this component

---

## 17. Analytics / Tracking Events

| Event | Trigger | Properties |
|---|---|---|
| `quick_action.fab.clicked` | FAB button clicked | `source_page` (current route), `action` (open/close) |
| `quick_action.shortcut.used` | Cmd+N pressed | `source_page` |
| `quick_action.action.selected` | Action item clicked | `action_type` (idea/script/ai_idea/studio/publish/product/message), `source_page`, `shortcut_used` (boolean) |
| `quick_action.dismissed` | Backdrop click or Escape | `source_page`, `time_open_ms` |

---

## 18. Design Tokens Reference

| Token | Usage |
|---|---|
| `--color-accent` | FAB background color |
| `--color-accent-hover` | FAB hover state |
| `--color-surface-elevated` | Menu background |
| `--color-text-primary` | Action labels |
| `--color-text-secondary` | Keyboard shortcut labels |
| `--color-backdrop` | Semi-transparent backdrop (rgba, 50% opacity) |
| `--shadow-fab` | FAB elevation shadow (larger than standard card) |
| `--shadow-menu` | Menu panel shadow |
| `--radius-fab` | FAB border-radius (50% = circle) |
| `--radius-menu` | Menu border-radius (16px) |
| `--z-index-fab` | z-index: 1000 (above page content, below modals) |
| `--z-index-menu` | z-index: 1001 (above FAB) |
| `--z-index-backdrop` | z-index: 999 (below FAB) |
| `--animation-spring` | Spring animation config for expand/collapse |

---

## 19. Technical Implementation Notes

### SvelteKit Specifics
- **Component path**: `src/lib/components/QuickActionFAB.svelte`
- **Mounted in**: `src/routes/(app)/+layout.svelte` (app-level layout)
- **Not mounted in**: `src/routes/(auth)/+layout.svelte` (auth pages) or `src/routes/(admin)/+layout.svelte` (admin)

### Implementation Pattern
```svelte
<script>
  import { page } from '$app/stores'
  import { permissions } from '$lib/stores/auth'
  import { spring } from 'svelte/motion'
  
  let expanded = false
  
  const actions = [
    { icon: '💡', label: 'Tạo ý tưởng mới', route: '/ideas/new', perm: 'idea:create', key: '1' },
    // ...
  ]
  
  $: visibleActions = actions.filter(a => $permissions.includes(a.perm))
  
  function handleKeydown(e) {
    if ((e.metaKey || e.ctrlKey) && e.key === 'n') {
      e.preventDefault()
      expanded = !expanded
    }
    if (e.key === 'Escape' && expanded) expanded = false
  }
</script>

<svelte:window on:keydown={handleKeydown} />

{#if !excludedRoutes.includes($page.route.id)}
  <div class="fab-container">
    <button on:click={() => expanded = !expanded} aria-expanded={expanded}>
      {expanded ? '✕' : '✨'}
    </button>
    {#if expanded}
      <div class="backdrop" on:click={() => expanded = false} />
      <menu role="menu">
        {#each visibleActions as action, i}
          <a href={action.route} role="menuitem" style="--delay: {i * 50}ms">
            {action.icon} {action.label}
          </a>
        {/each}
      </menu>
    {/if}
  </div>
{/if}
```

### Excluded Routes
```javascript
const excludedRoutes = [
  '/(auth)',           // Login, signup, forgot password
  '/(onboarding)',     // Onboarding flow
  '/checkout',         // Stripe checkout return
]
```

### Animation
- **Expand**: Spring-based stagger (each item 50ms delay, springy entrance from below)
- **Collapse**: Reverse stagger (faster, 30ms per item)
- **FAB icon**: 180° rotation on toggle
- **Backdrop**: Opacity fade 0→0.5 over 200ms

---

## 20. Related Screens

| Screen | Relationship |
|---|---|
| [W001] Home Dashboard | Most common source page for FAB use |
| [W010] Idea Board | Destination: "💡 Tạo ý tưởng mới" |
| [W020] Script Editor | Destination: "📝 Viết script" |
| [W024] AI Studio | Destination: "🎬 AI Studio" |
| [W048] Publish Composer | Destination: "📤 Đăng bài nhanh" |
| [M007] Mobile Quick Action | Mobile equivalent (bottom sheet variant) |

---

## 21. Revision History

| Date | Version | Change | Author |
|---|---|---|---|
| 2026-03-29 | 2.0 | **Full Tier A rewrite**: Upgraded from 161-line Tier C with generic boilerplate to 380+ line full spec. Added: action registry table with permissions and keyboard shortcuts, per-role visibility matrix, spring animation specification, mobile bottom sheet variant, keyboard shortcut handling (Cmd+N, 1-7, Escape), excluded routes specification, Svelte implementation pattern, z-index layering, reduced-motion support. Removed all generic boilerplate. Standardized Screen ID from W07 to W007. | System |
| 2026-03-28 | 1.0 | Initial specification (Tier C) | System |

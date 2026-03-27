# A5 — Design System & Token Specification

> **Upstream**: Pack 01 (FE/UX), Tech Stack ADR v3
> **Tech**: Tailwind CSS v4 + shadcn-svelte + Bits UI
> **Fonts**: Inter (primary), JetBrains Mono (code)

---

## 1. Color Palette

### 1.1 Brand Colors (HSL)
```css
:root {
  /* Primary — Teal/Cyan energy */
  --color-primary-50: hsl(174, 80%, 96%);
  --color-primary-100: hsl(174, 75%, 90%);
  --color-primary-200: hsl(174, 70%, 78%);
  --color-primary-300: hsl(174, 65%, 64%);
  --color-primary-400: hsl(174, 60%, 50%);
  --color-primary-500: hsl(174, 65%, 42%); /* Main */
  --color-primary-600: hsl(174, 70%, 34%);
  --color-primary-700: hsl(174, 75%, 26%);
  --color-primary-800: hsl(174, 80%, 18%);
  --color-primary-900: hsl(174, 85%, 10%);

  /* Accent — Warm Amber */
  --color-accent-50: hsl(38, 95%, 96%);
  --color-accent-100: hsl(38, 90%, 88%);
  --color-accent-200: hsl(38, 85%, 76%);
  --color-accent-300: hsl(38, 80%, 64%);
  --color-accent-400: hsl(38, 85%, 52%);
  --color-accent-500: hsl(38, 90%, 45%); /* Main */
  --color-accent-600: hsl(38, 85%, 36%);

  /* Semantic */
  --color-success: hsl(152, 60%, 45%);
  --color-warning: hsl(38, 90%, 50%);
  --color-error: hsl(0, 72%, 55%);
  --color-info: hsl(210, 70%, 55%);

  /* Trust Indicators */
  --color-source-official: hsl(152, 60%, 45%);
  --color-source-imported: hsl(210, 70%, 55%);
  --color-source-inferred: hsl(38, 90%, 50%);
  --color-source-estimated: hsl(25, 80%, 55%);
  --color-source-unreconciled: hsl(0, 72%, 55%);

  /* Confidence Bands */
  --color-confidence-high: hsl(152, 60%, 45%);
  --color-confidence-medium: hsl(38, 90%, 50%);
  --color-confidence-low: hsl(0, 72%, 55%);
}
```

### 1.2 Dark Mode
```css
.dark {
  --bg-primary: hsl(220, 20%, 10%);
  --bg-secondary: hsl(220, 18%, 14%);
  --bg-tertiary: hsl(220, 16%, 18%);
  --bg-elevated: hsl(220, 18%, 16%);
  --border-default: hsl(220, 15%, 22%);
  --border-subtle: hsl(220, 12%, 18%);
  --text-primary: hsl(220, 15%, 95%);
  --text-secondary: hsl(220, 12%, 70%);
  --text-muted: hsl(220, 10%, 50%);
}
```

### 1.3 Light Mode
```css
:root {
  --bg-primary: hsl(0, 0%, 100%);
  --bg-secondary: hsl(220, 20%, 97%);
  --bg-tertiary: hsl(220, 15%, 94%);
  --bg-elevated: hsl(0, 0%, 100%);
  --border-default: hsl(220, 15%, 88%);
  --border-subtle: hsl(220, 12%, 92%);
  --text-primary: hsl(220, 25%, 10%);
  --text-secondary: hsl(220, 15%, 40%);
  --text-muted: hsl(220, 10%, 60%);
}
```

---

## 2. Typography

```css
:root {
  --font-sans: 'Inter', system-ui, -apple-system, sans-serif;
  --font-mono: 'JetBrains Mono', ui-monospace, monospace;

  /* Scale (fluid) */
  --text-xs: 0.75rem;     /* 12px */
  --text-sm: 0.875rem;    /* 14px */
  --text-base: 1rem;      /* 16px */
  --text-lg: 1.125rem;    /* 18px */
  --text-xl: 1.25rem;     /* 20px */
  --text-2xl: 1.5rem;     /* 24px */
  --text-3xl: 1.875rem;   /* 30px */
  --text-4xl: 2.25rem;    /* 36px */

  --leading-tight: 1.25;
  --leading-normal: 1.5;
  --leading-relaxed: 1.75;

  --font-weight-normal: 400;
  --font-weight-medium: 500;
  --font-weight-semibold: 600;
  --font-weight-bold: 700;
}
```

---

## 3. Spacing & Layout

```css
:root {
  --space-0: 0;
  --space-1: 0.25rem;   /* 4px */
  --space-2: 0.5rem;    /* 8px */
  --space-3: 0.75rem;   /* 12px */
  --space-4: 1rem;      /* 16px */
  --space-5: 1.25rem;   /* 20px */
  --space-6: 1.5rem;    /* 24px */
  --space-8: 2rem;      /* 32px */
  --space-10: 2.5rem;   /* 40px */
  --space-12: 3rem;     /* 48px */
  --space-16: 4rem;     /* 64px */

  --radius-sm: 0.375rem;   /* 6px */
  --radius-md: 0.5rem;     /* 8px */
  --radius-lg: 0.75rem;    /* 12px */
  --radius-xl: 1rem;       /* 16px */
  --radius-2xl: 1.5rem;    /* 24px */
  --radius-full: 9999px;

  --sidebar-width: 260px;
  --sidebar-collapsed: 64px;
  --topbar-height: 56px;
  --content-max-width: 1280px;
}
```

---

## 4. Shadows & Effects

```css
:root {
  --shadow-sm: 0 1px 2px 0 hsl(0 0% 0% / 0.05);
  --shadow-md: 0 4px 6px -1px hsl(0 0% 0% / 0.1);
  --shadow-lg: 0 10px 15px -3px hsl(0 0% 0% / 0.1);
  --shadow-xl: 0 20px 25px -5px hsl(0 0% 0% / 0.1);

  /* Glassmorphism (for elevated cards) */
  --glass-bg: hsl(0 0% 100% / 0.7);
  --glass-border: hsl(0 0% 100% / 0.2);
  --glass-blur: blur(12px);
}
.dark {
  --glass-bg: hsl(220 20% 14% / 0.7);
  --glass-border: hsl(220 15% 25% / 0.3);
}
```

---

## 5. Animation Tokens

```css
:root {
  --duration-fast: 100ms;
  --duration-normal: 200ms;
  --duration-slow: 300ms;
  --duration-slower: 500ms;

  --ease-default: cubic-bezier(0.4, 0, 0.2, 1);
  --ease-in: cubic-bezier(0.4, 0, 1, 1);
  --ease-out: cubic-bezier(0, 0, 0.2, 1);
  --ease-bounce: cubic-bezier(0.34, 1.56, 0.64, 1);
}
```

---

## 6. Component Tokens

### 6.1 Buttons
| Variant | Background | Text | Border |
|---|---|---|---|
| Primary | `--color-primary-500` | white | none |
| Secondary | transparent | `--text-primary` | `--border-default` |
| Ghost | transparent | `--text-secondary` | none |
| Danger | `--color-error` | white | none |
| Success | `--color-success` | white | none |

Sizes: `sm` (h-8), `md` (h-10), `lg` (h-12), `icon` (h-10 w-10)

### 6.2 Cards
| Variant | Usage |
|---|---|
| Default | Standard content card |
| Elevated | Glass effect, floating card |
| Interactive | Hover lift + shadow, clickable |
| Metric | Dashboard KPI card |
| Action | CTA-bearing card (M01 Home) |

### 6.3 Status Badges
| State | Color | Usage |
|---|---|---|
| Active/Published | `--color-success` | Offer, Campaign, Publish |
| Draft | `--text-muted` | Most objects default |
| Warning | `--color-warning` | SLA approach, degraded |
| Error/Failed | `--color-error` | Publish fail, sync error |
| Pending | `--color-info` | Approval, processing |

### 6.4 Score Indicators
| Range | Color | Label |
|---|---|---|
| 80-100 | `--color-success` | Excellent |
| 60-79 | `--color-info` | Good |
| 40-59 | `--color-warning` | Fair |
| 0-39 | `--color-error` | Needs work |

### 6.5 Source Class Badges
| Source | Color | Icon |
|---|---|---|
| Official | Green | ✓ shield |
| Imported | Blue | ↓ arrow |
| Inferred | Amber | ? brain |
| Estimated | Orange | ~ wave |
| Unreconciled | Red | ⚠ alert |

---

## 7. Layout System

### 7.1 App Shell (Web)
```
┌─ Topbar (56px) ──────────────────────────────────────┐
├─ Sidebar (260px) ─┬─ Main Content ───────────────────┤
│  Logo             │  ┌─ Page Header ───────────────┐ │
│  Navigation       │  │  Breadcrumb + Title + Actions│ │
│  Workspace        │  ├─ Content Area ──────────────┤ │
│  Mode Selector    │  │  (max-width: 1280px)        │ │
│  Quick Actions    │  │                              │ │
│  Help / Copilot   │  │                              │ │
│                   │  └──────────────────────────────┘ │
└───────────────────┴──────────────────────────────────┘
```

### 7.2 Responsive Breakpoints
| Name | Width | Sidebar |
|---|---|---|
| `sm` | < 640px | Hidden (mobile) |
| `md` | 640-1024px | Collapsed (icons only) |
| `lg` | 1024-1440px | Expanded |
| `xl` | > 1440px | Expanded + wider content |

---

## 8. Operator Mode Theming

Each operator mode has a subtle accent applied to sidebar/topbar:

| Mode | Accent Indicator | Description |
|---|---|---|
| Creator | Teal dot | Content-first view |
| Seller | Amber dot | Commerce-first view |
| Affiliate | Blue dot | Partner-first view |
| Live | Red dot (pulsing) | Live commerce active |
| Agency/MCN | Slate dot | Multi-creator management |
| Brand Collaboration | Gold dot | Sponsor/brand view |

---

## 9. Icon System

- **Library**: Lucide Icons (MIT, tree-shakeable)
- **Size**: 16px (inline), 20px (menu), 24px (headers), 32px (empty states)
- **Stroke**: 1.5px default

---

## 10. Tailwind CSS v4 Config Integration

```css
/* apps/web/src/app.css */
@import "tailwindcss";

@theme {
  --color-primary-*: /* mapped from Section 1 */;
  --color-accent-*: /* mapped from Section 1 */;
  --font-sans: 'Inter', system-ui, sans-serif;
  --font-mono: 'JetBrains Mono', monospace;
}
```

All tokens above are the source of truth for Google Stitch design sync.

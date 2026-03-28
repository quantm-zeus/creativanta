# Screen: Mobile — Contact List

> **Screen ID**: M048
> **Module**: M13 — Engagement & CRM
> **Route**: `/contacts` (mobile)
> **Platform**: Mobile (Flutter)
> **Upstream**: Pack 01 §4, Product Freeze §21-23, A1 Schema (contacts, engagement_events, orders), B5 RBAC §2.7

---

## 1. Purpose & Context

Mobile CRM — unified contact list merged from all connected platforms with VIP labels, lifetime value (LTV), engagement recency, purchase history, and quick call/message actions. Supports alphabetical index for fast scrolling, filter chips for segmentation, and search for finding specific contacts. This is the mobile companion to the web CRM, optimized for quick lookup and action while on the go.

### User Goals
- Quickly find a specific contact by name, platform, or tag
- View contact engagement context before replying
- Identify VIP customers and high-value prospects
- Execute quick actions (call, message, view orders) without deep navigation

### Business Goals
- Increase CRM utilization on mobile (target: 40%+ of CRM views)
- Enable faster response times by surfacing contact context upfront
- Improve customer segmentation through tag and VIP management
- Drive cross-sell by surfacing LTV and purchase patterns

### When This Screen Is Used
- **Before replying**: Check contact history before crafting response
- **Quick lookup**: Find contact phone/social for direct outreach
- **Segment review**: Browse VIP or buyer lists for campaign targeting
- **Post-order**: View buyer profile after incoming order

### Entry Points
- Bottom nav → Contacts tab (if configured)
- Inbox (M007): "👤 View contact" on thread row
- Commerce orders: "Buyer profile" link
- Home Dashboard (M001): CRM summary widget → "Xem contacts"
- Search: Global search → contact results

### Exit Points
- Tap contact → Contact Detail (M049)
- Swipe "💬 Message" → Thread Detail (M008)
- Swipe "📞 Call" → Phone dialer / In-app VoIP

---

## 2. Preconditions / Postconditions

### Preconditions
- User has `contact:read` permission (Contributor+)
- At least one connected platform (contacts auto-created from engagement)
- Contacts populated from platform interactions, orders, or manual entry

### Postconditions
- Contact viewed → `contacts.last_viewed_at` updated
- Quick action (call/message) → navigation to respective screen
- Tag modification → `contact_tags` updated
- Search query → logged for analytics

---

## 3. Screen Layout

### ASCII Wireframe
```
┌─ Status Bar ─────────────────────────────────────────────────────────┐
│ ← Contacts (234)                              [🔍 Search] [⋮]      │
├──────────────────────────────────────────────────────────────────────┤
│ Summary: 234 contacts · 12 VIP · 45 buyers · 89 engaged             │
│ Chips: [All (234)] [⭐ VIP (12)] [🛒 Buyers (45)]                   │
│        [💬 Engaged (89)] [🆕 New 7d (15)] [🏷 Tagged]               │
│                                                                      │
│ ── A ──                                                              │
│ ┌─ Contact Row ──────────────────────────────────────────────────┐   │
│ │ [Avatar] Anh Đức · ⭐ VIP                        📸 Instagram │   │
│ │ Last: 2h ago · 5 orders · LTV: 1.2M VND                       │   │
│ │ Tags: [repeat-buyer] [skincare] [+2]                           │   │
│ │ ← swipe: [📞 Call] [💬 Message]                                │   │
│ └────────────────────────────────────────────────────────────────┘   │
│                                                                      │
│ ── N ──                                                              │
│ ┌─ Contact Row ──────────────────────────────────────────────────┐   │
│ │ [Avatar] Nguyễn Thảo                              🎵 TikTok   │   │
│ │ Last: 3d ago · 0 orders · Engaged: 12 comments                 │   │
│ │ Tags: [prospect]                                                │   │
│ └────────────────────────────────────────────────────────────────┘   │
│                                                                      │
│ ── T ──                                                              │
│ ┌─ Contact Row ──────────────────────────────────────────────────┐   │
│ │ [Avatar] Trần Bình                                📺 YouTube   │   │
│ │ Last: 1w ago · 2 orders · LTV: 450K VND                        │   │
│ │ Tags: [buyer]                                                   │   │
│ └────────────────────────────────────────────────────────────────┘   │
│                                                                      │
│ Pull-to-refresh                                          [A-Z Index]│
├──────────────────────────────────────────────────────────────────────┤
│ [🏠] [💡] [🎬] [💬] [📊]                                          │
└──────────────────────────────────────────────────────────────────────┘
```

---

## 4. Component Hierarchy

```
ContactListPage
├── AppBar
│   ├── BackButton (or title if root tab)
│   ├── Title ("Contacts" + total count)
│   ├── SearchButton ("🔍" → expands search field)
│   └── MoreMenu ("⋮" → Import, Export, Settings)
├── SummaryRow (total, VIP, buyers, engaged counts)
├── FilterChips (horizontal scroll)
│   ├── AllChip (default active)
│   ├── VIPChip ("⭐ VIP" + count)
│   ├── BuyersChip ("🛒 Buyers" + count)
│   ├── EngagedChip ("💬 Engaged" + count)
│   ├── NewContactsChip ("🆕 New 7d" + count)
│   └── TaggedChip ("🏷 Tagged" → tag filter drawer)
├── ContactList (pull-to-refresh + infinite scroll)
│   ├── AlphabeticSectionHeader ("A", "B", ...)
│   └── ContactRow[] (swipeable left for actions)
│       ├── Avatar (platform avatar or initials)
│       ├── ContactInfo
│       │   ├── Name (bold)
│       │   ├── VIPBadge (⭐, if VIP)
│       │   ├── PlatformIcon (🎵/📸/📺)
│       │   ├── LastEngagement ("Last: 2h ago")
│       │   ├── OrderSummary ("5 orders · LTV: 1.2M")
│       │   └── TagChips (max 2 + "+N")
│       └── SwipeActions
│           ├── CallAction ("📞 Call")
│           └── MessageAction ("💬 Message")
├── AlphabeticalSideIndex (A-Z strip on right edge)
├── SearchOverlay (when search is active)
│   ├── SearchInput (auto-focus)
│   └── SearchResults (filtered list)
└── BottomNavBar (shared)
```

---

## 5. Data Binding & Display Format

| UI Element | Data Source | API | Display Format | Cache |
|---|---|---|---|---|
| Contact list | `contacts ORDER BY display_name ASC` | `ContactService/List(filter, cursor)` | Rows grouped by first letter | 5m TTL |
| Summary counts | `COUNT GROUP BY segment` | `ContactService/GetSummary()` | "234 contacts · 12 VIP · 45 buyers" | 5m TTL |
| Avatar | `contacts.avatar_url` | CDN | 40dp circle crop | Until invalidated |
| VIP status | `contacts.is_vip` | Included | ⭐ badge | 5m |
| LTV | `contacts.lifetime_value` | Included | "1.2M VND" (abbreviated) | 5m |
| Last engagement | `contacts.last_engagement_at` | Included | Relative time ("2h ago") | 5m |
| Order count | `contacts.order_count` | Included | "5 orders" | 5m |
| Tags | `contact_tags` join | Included | Chip list (max 2 + "+N") | 5m |
| Platform | `contacts.primary_platform` | Included | Platform icon | 5m |
| Engagement count | `contacts.engagement_count` | Included | "12 comments" | 5m |

---

## 6. Actions Table

| # | Action | Trigger | Type | API Call | System Response | Permission |
|---|---|---|---|---|---|---|
| 1 | View contact | Tap row | Navigate | — | Push → Contact Detail (M049) | `contact:read` |
| 2 | Call contact | Swipe left → "📞 Call" | External | Launch phone dialer with `contacts.phone` | Opens phone app | `contact:read` |
| 3 | Message contact | Swipe left → "💬 Message" | Navigate | — | Push → Thread Detail (M008) filtered by contact | `engagement:reply` |
| 4 | Search | Tap "🔍" → type query | Filter | `ContactService/Search(query)` | Results filter in real-time (debounced 300ms) | `contact:read` |
| 5 | Filter by segment | Tap chip | Filter | `ContactService/List(segment=...)` | List filters. Active chip highlighted. | `contact:read` |
| 6 | Filter by tag | "🏷 Tagged" chip → tag drawer | Filter | `ContactService/List(tag=...)` | List shows tagged contacts only | `contact:read` |
| 7 | Pull refresh | Pull-down | Refresh | Refetch list | Data updates. Haptic light. | `contact:read` |
| 8 | Scroll to letter | Tap letter on side index | Scroll | Client-side | List scrolls to matching section | — |
| 9 | Toggle VIP | Long press → "⭐ Toggle VIP" | Action | `ContactService/UpdateVIP(id, is_vip)` | Star appears/disappears. Haptic light. Toast "Đã đánh dấu VIP" | `contact:update` |
| 10 | Export contacts | ⋮ → "📥 Export" | Action | `ContactService/Export(filter)` | Toast "Đang xuất..." → push notification when ready | `contact:export` |

---

## 7. Validation Rules

### Search
| Field | Rule | Error |
|---|---|---|
| Search query | Min 2 chars for search trigger | No error — just debounce |
| Phone format | Auto-formatted (Vietnamese: +84) | — |

---

## 8. States

| State | Condition | Visual | User Action |
|---|---|---|---|
| LOADING | Initial fetch | Row shimmer (6 placeholders) + summary shimmer | Wait |
| LOADED | Contacts available | Alphabetical list with side index | Normal interaction |
| EMPTY | No contacts in workspace | "👥 Chưa có contact. Contacts tự động tạo từ tương tác trên nền tảng." | Connect platforms |
| EMPTY_FILTERED | Filter active, 0 matches | "Không có contact {segment}. [Xem tất cả →]" | Clear filter |
| SEARCHING | Search active | Search bar expanded, filtered results | Type to search |
| SEARCH_NO_RESULTS | Query matches nothing | "🔍 Không tìm thấy. Thử tên khác hoặc tag." | Modify search |
| REFRESHING | Pull-to-refresh | Refresh indicator | Wait |
| ERROR | API failed | "Không tải được contacts. [Thử lại]" | Retry |
| OFFLINE | No network | Cached contacts viewable. Actions disabled. Banner: "📡 Ngoại tuyến" | View cached |

---

## 9. Permissions & Role-based Behavior

| Action | Owner | Admin | Manager | Editor | Contributor | Viewer | External |
|---|---|---|---|---|---|---|---|
| View contacts | ✅ | ✅ | ✅ | ✅ | ✅ (own interactions) | ❌ | ❌ |
| Search | ✅ | ✅ | ✅ | ✅ | ✅ (own) | ❌ | ❌ |
| Call/Message | ✅ | ✅ | ✅ | ✅ | ✅ (own) | ❌ | ❌ |
| Toggle VIP | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ |
| Export | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ |
| Delete contact | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ |

### Visibility Rules
- **Contributor**: Only sees contacts they've personally interacted with
- **Viewer/External**: Contact List hidden from navigation

---

## 10. Mobile-specific UX

### Gestures & Haptics
| Gesture | Target | Haptic | Result |
|---|---|---|---|
| Tap row | ContactRow | Light | Push → Contact Detail |
| Swipe left | ContactRow | Medium | Reveal call + message actions |
| Long press | ContactRow | Heavy | Context menu (VIP, Tag, Delete) |
| Pull down | Page | Light | Refresh |
| Tap side index | AlphaIndex | Light per letter | Scroll to letter section |

### Alphabetical Side Index
- Right edge, A-Z strip (semi-transparent)
- Drag finger along strip = fast scroll with letter popover (center screen)
- Haptic light on each letter change

### Offline Behavior
- **Available offline**: Cached contact list (last known), search (cached only)
- **Not available**: Call/message actions, new data, export
- Banner: "📡 Ngoại tuyến — dữ liệu contact có thể chưa mới nhất"

---

## 11. Edge Cases

| Edge Case | Handling |
|---|---|
| 1000+ contacts | Virtual scroll with section index. Performance target: 60fps. |
| Contact from multiple platforms | Merged row showing primary avatar + secondary platform badges. |
| No phone number | "📞 Call" swipe action hidden. Only "💬 Message" available. |
| Contact name in non-Vietnamese | Sort by Unicode. Display as-is. Side index handles Latin only. |
| Duplicate contacts (same person, different platforms) | Show as separate rows until manually merged (future feature). |
| VIP toggled frequently | Debounce API: max 1 update per 2 seconds per contact. |
| Avatar fails to load | Show initials circle (first letter of name, platform-colored background) |

---

## 12. Real-time Updates

| Data | Channel | Frequency |
|---|---|---|
| New contacts (from engagement) | SSE `/events/contacts` | Real-time |
| Contact updates (new order, engagement) | SSE | Real-time |
| VIP changes (from web) | SSE | Real-time |

---

## 13. Navigation Map

```
Contact List (/contacts)
├── → /contacts/[id] (tap row → M049 Contact Detail)
├── → /inbox/[threadId] (swipe message → M008 Thread Detail)
├── → tel:[phone] (swipe call → phone dialer)
├── → /settings/platforms (empty state → Connect platforms)
└── ← Back (via back button or bottom nav)
```

---

## 14. Analytics / Tracking Events

| Event | Trigger | Properties |
|---|---|---|
| `contacts.viewed` | Page load | `total_count`, `vip_count`, `filter`, `source` |
| `contacts.searched` | Search submitted | `query_length`, `result_count` |
| `contacts.filtered` | Chip tapped | `filter_type` (vip/buyer/engaged/new) |
| `contacts.opened` | Contact row tapped | `contact_id`, `is_vip`, `platform` |
| `contacts.called` | Call swipe action | `contact_id`, `has_phone` |
| `contacts.messaged` | Message swipe action | `contact_id`, `platform` |
| `contacts.vip_toggled` | VIP toggled | `contact_id`, `new_vip_status` |

---

## 15. Performance Requirements

| Metric | Target |
|---|---|
| Screen render | <1.5s |
| Search results (debounced) | <500ms after 300ms debounce |
| Scroll performance | 60fps (virtual scroll for 1000+) |
| Side index scroll | <50ms per letter jump |
| Pull-to-refresh | <2s |

---

## 16. Flutter Implementation Notes

### Widget Structure
- **Route**: `/contacts` → `ContactListPage extends ConsumerStatefulWidget`
- **State**: Riverpod `contactListProvider(filter, searchQuery)` — paginated
- **List**: `ListView.builder` with `Dismissible` for swipe actions
- **Section headers**: `StickyHeader` for alphabetical grouping
- **Side index**: `AlphabetScrollListView` or custom overlay
- **Search**: `SearchDelegate` or inline search bar

### Data Fetching
```
onInit:
  contactService.getSummary()
  contactService.list(filter: 'all', cursor: null)

onSearch(query):
  debounce(300ms) → contactService.search(query)
  
onFilter(segment):
  contactService.list(filter: segment, cursor: null)
```

---

## 17. Error Handling

| Error Type | Trigger | UI Response | Recovery |
|---|---|---|---|
| Network offline | No connectivity | Banner: "📡 Ngoại tuyến" + show cached contacts | Pull-to-refresh when online |
| API error | Server 5xx | Toast: "Không tải được contacts. [Thử lại]" | Retry button |
| Search failed | Search API error | Toast: "Tìm kiếm thất bại." + show cached results | Retry search |
| Call failed | No phone number | Toast: "Contact không có số điện thoại." | — |
| Export failed | Export API error | Toast: "Xuất thất bại. [Thử lại]" | Retry |

---

## 18. Accessibility

| Element | Requirement |
|---|---|
| Contact rows | `Semantics(label: "Nguyễn Thảo, VIP, TikTok, liên hệ cuối 2 giờ trước, 5 đơn hàng")` |
| VIP badge | `Semantics(label: "Khách hàng VIP")` |
| Side index | `Semantics(label: "Cuộn nhanh đến chữ {letter}")` per letter |
| Summary row | `Semantics(label: "234 contacts, 12 VIP, 45 người mua")` |
| Swipe actions | Also available via long-press context menu |
| Search | `Semantics(textField: true, hint: "Tìm contact theo tên hoặc tag")` |

---

## 19. Loading Behavior

| Stage | Duration | Visual |
|---|---|---|
| Screen mount | 0ms | App bar + summary shimmer + row shimmers |
| Summary counts | 100-200ms | Numbers fade in |
| Contact list | 200-500ms | Rows populate with staggered animation |
| Avatars | 300-800ms | Initials → avatar images load progressively |
| Search results | <500ms | Filtered list after 300ms debounce |

---

## 20. Localization Notes

- Primary language: Vietnamese
- LTV format: "1.2M VND" (abbreviated, no decimals for > triệu)
- Time: Relative ("2h ago", "3d ago", "1w ago")
- Names: Vietnamese name order (family name first)
- VIP label: "VIP" (international)
- Tags: English lowercase (tech convention)
- Empty state: Vietnamese, friendly tone

---

## 21. Design Tokens Reference

| Token | Usage |
|---|---|
| `--color-accent` | Active filter chip, search highlight |
| `--color-vip` | VIP badge (gold/amber) |
| `--color-success` | Engaged contact indicator |
| `--color-surface-elevated` | Contact row cards |
| `--color-text-primary` | Contact names |
| `--color-text-secondary` | Last engagement, LTV, order count |
| `--color-call` | Call swipe action (green) |
| `--color-message` | Message swipe action (blue) |

---

## 22. Related Screens

| Screen | Relationship |
|---|---|
| [W050] Web Contacts | Web equivalent (table view with bulk actions) |
| [M049] Mobile Contact Detail | Detail view for single contact |
| [M007] Mobile Inbox | Thread context via "View contact" |
| [M008] Mobile Thread Detail | Message action destination |

---

## 23. Revision History

| Date | Version | Change | Author |
|---|---|---|---|
| 2026-03-28 | 2.0 | **Full Tier A rewrite** from 237-line Tier C. Added complete 23-section structure: expanded wireframe with alphabetical index, full component hierarchy, specific data binding (10 fields), 10 user actions, search/filter validation, 9 states, full RBAC matrix, mobile UX with gestures/haptics/alphabetical index/offline, 7 edge cases, real-time SSE, navigation map, 7 tracking events, performance targets, Flutter implementation, error handling (5 scenarios), accessibility, localization, design tokens. Replaced ALL template placeholders. | System |
| 2026-03-28 | 1.0 | Initial specification | System |

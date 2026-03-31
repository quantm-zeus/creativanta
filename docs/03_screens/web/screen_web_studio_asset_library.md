# Screen: Web — Asset Library

> **Screen ID**: W39
> **Module**: M07 — AI Studio
> **Route**: `/studio/library`
> **Platform**: Web (SvelteKit)
> **Upstream**: Pack 04, A1 Schema (assets)

---

## 1. Purpose & Context

Central library for all AI-generated and uploaded media assets. Filterable gallery with metadata, usage tracking, and quick publish shortcuts.

### User Story
> As a creator, I want to find and manage all my generated videos, images, and audio files in one place.

---

## 2. Layout Structure

### ASCII Wireframe
```
┌─ App Shell ──────────────────────────────────────────────────────────┐
│ ← Studio   📚 Asset Library (234 assets)    [🔍 Search] [📎 Upload]│
├──────────────────────────────────────────────────────────────────────┤
│ Filter: [Type ▾] [Mode ▾] [Date ▾] [Status ▾]                     │
│ View: [🔲 Grid] [☰ List]                                           │
├──────────────────────────────────────────────────────────────────────┤
│                                                                      │
│ ┌───────┐  ┌───────┐  ┌───────┐  ┌───────┐  ┌───────┐            │
│ │ 🎬    │  │ 🖼    │  │ 🎬    │  │ 🎵    │  │ 🎬    │            │
│ │ Video │  │ Thumb │  │ Video │  │ Music │  │ Video │            │
│ │ 52s   │  │ 1080p │  │ 28s   │  │ 30s   │  │ 45s   │            │
│ │ 2h ago│  │ 3h ago│  │ 1d ago│  │ 1d ago│  │ 2d ago│            │
│ │[📤][⋮]│  │[📤][⋮]│  │[📤][⋮]│  │[📤][⋮]│  │[📤][⋮]│            │
│ └───────┘  └───────┘  └───────┘  └───────┘  └───────┘            │
│                                                                      │
│ [Tải thêm ↓]                                                        │
│                                                                      │
│ Storage used: 2.3 GB / 10 GB                                        │
└──────────────────────────────────────────────────────────────────────┘
```

---

## 3-5. Component & Actions

```
AssetLibraryPage
├── AppShell
├── PageHeader (title, count, search, upload)
├── FilterBar (type, mode, date, status)
├── ViewToggle (Grid / List)
├── AssetGrid
│   └── AssetThumbnail[] (preview, type icon, duration, time, actions)
└── StorageIndicator
```

| # | Action | Trigger | Result |
|---|---|---|---|
| 1 | View detail | Click thumbnail | Modal/popup with full preview + metadata |
| 2 | Publish | "📤" quick action | → Publish flow pre-filled |
| 3 | Download | ⋮ → Download | File download |
| 4 | Delete | ⋮ → Delete | Asset removed |
| 5 | Use in mode | ⋮ → Edit in... | → relevant studio mode |

---

## 5. States

| State | Condition | Visual |
|---|---|---|
| LOADING | Initial fetch | Grid skeleton thumbnails |
| LOADED | Assets available | Thumbnails grid + storage bar |
| EMPTY | No assets | Illustration: "Chưa có asset. [← Tạo video mới]" |
| EMPTY_FILTERED | Filter active, no match | "Không tìm thấy asset phù hợp. [Xóa bộ lọc]" |
| ERROR | API failed | Error banner with retry |

---

## 6. Edge Cases

| Edge Case | Handling |
|---|---|
| Storage > 90% full | Warning banner: "⚠️ Sắp hết dung lượng (9.2/10 GB). [Xóa bớt] [Nâng cấp]" |
| Bulk delete (10+ assets) | Confirm: "Xóa {n} asset? Không thể hoàn tác." |
| Asset still processing | Show "⏳ Đang xử lý" badge, actions disabled |
| Asset published to platform | Show "📤 Đã đăng TikTok" badge, delete warns |
| 1000+ assets (performance) | Virtual scroll + lazy thumbnail loading |

---

## 7. Error Handling

| Error Type | Trigger | UI Response | Recovery |
|---|---|---|---|
| Network offline | No connectivity | Banner: "📡 Ngoại tuyến — hiển thị cached" | Auto-retry online |
| Upload failed | File/size error | Toast: "Upload thất bại. Tối đa 500MB" | Retry |
| Delete failed | Server error | Toast: "Không xóa được. [Thử lại]" | Retry |
| Search failed | Meilisearch down | Fallback to SQL. Toast: "Tìm kiếm cơ bản" | Auto-fallback |
| Download failed | Storage error | Toast: "Không tải xuống được. [Thử lại]" | Retry |

---

## 8. Accessibility

| Element | Requirement |
|---|---|
| Asset grid | `role="grid"`, thumbnails with `role="gridcell"` |
| Thumbnails | `aria-label="{type}: {name}, {duration/size}, {created_time}"` |
| View toggle | `role="radiogroup"`, `aria-label="Chế độ xem"` |
| Filter dropdowns | `aria-expanded`, `aria-haspopup="listbox"` |
| Storage bar | `role="progressbar"`, `aria-label="Dung lượng: {used}/{total}"` |

---

## 9. Loading Behavior

| Stage | Duration | Visual |
|---|---|---|
| Initial render | 0ms | Filter bar + grid skeletons |
| Thumbnail batch 1 | 200-400ms | First 20 thumbnails |
| Infinite scroll | On scroll | Next 20 thumbnails load |
| View toggle | 150ms | Crossfade grid ↔ list |
| Search results | < 100ms | Grid updates (Meilisearch) |

---

## 10. Performance Requirements

| Metric | Target |
|---|---|
| LCP | < 1.5s (first thumbnail row) |
| Thumbnail load | < 200ms each (lazy) |
| Search | < 100ms (Meilisearch) |
| Filter switch | < 300ms |
| Infinite scroll trigger | 200px before bottom |

---

## 11. Analytics Events

| Event | Trigger | Properties |
|---|---|---|
| `library.viewed` | Page load | `total_assets`, `storage_used` |
| `library.searched` | Search query | `query`, `results_count` |
| `library.filtered` | Filter applied | `filter_type`, `filter_value` |
| `library.asset_viewed` | Click thumbnail | `asset_id`, `asset_type` |
| `library.asset_published` | Quick publish | `asset_id`, `platform` |
| `library.asset_deleted` | Delete | `asset_id`, `asset_type` |
| `library.uploaded` | Manual upload | `file_type`, `file_size` |

---

## 12. SvelteKit Implementation Notes

- **Route**: `src/routes/(app)/studio/library/+page.svelte`
- **Server load**: `+page.server.ts` → fetch first 20 assets + storage stats
- **Search**: Meilisearch `assets` index with type/status facets
- **Infinite scroll**: IntersectionObserver → fetch next page
- **Thumbnails**: R2 CDN with auto-generated preview frames (video) / resized (image)
- **Upload**: Chunked upload to R2 via `AssetService/Upload`
- **Virtual scroll**: For 1000+ assets, virtual list (svelte-virtual-scroll)

---

## 13. Localization Notes

- Types: "🎬 Video", "🖼 Ảnh", "🎵 Nhạc", "👤 Character"
- Status: "✅ Sẵn sàng", "⏳ Đang xử lý", "❌ Lỗi"
- Storage: "2.3 GB / 10 GB đã sử dụng"
- Filters: "Loại", "Chế độ", "Ngày tạo", "Trạng thái"
- Actions: "Đăng", "Tải xuống", "Xóa", "Chỉnh sửa trong..."

---

## 14. Design Tokens

| Token | Usage |
|---|---|
| `--color-asset-video` | Video type indicator (blue) |
| `--color-asset-image` | Image type indicator (green) |
| `--color-asset-audio` | Audio type indicator (purple) |
| `--color-storage-ok` | Storage bar normal (green) |
| `--color-storage-warning` | Storage > 80% (amber) |
| `--color-storage-critical` | Storage > 90% (red) |
| `--color-accent` | Primary CTAs |
| `--color-surface-elevated` | Cards, thumbnails |

---

## 15. Related Screens

| Screen | Relationship |
|---|---|
| [W024] AI Studio Launcher | Parent |
| [W038] Studio Queue | Processing assets |
| All studio modes | Asset source |

---

## 16. Revision History

| Date | Version | Change | Author |
|---|---|---|---|
| 2026-03-29 | 2.0 | **Tier A upgrade**: Added 5 states, 5 edge cases (storage quota, bulk delete), 5 errors, media grid accessibility, 5 perf KPIs, 7 analytics, SvelteKit impl (Meilisearch, virtual scroll, R2), storage localization, 8 design tokens. | System |
| 2026-03-28 | 1.0 | Initial specification | System |

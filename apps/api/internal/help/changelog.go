package help

import (
	"context"
	"errors"
	"strings"
	"time"
)

var (
	ErrAnnouncementNotFound = errors.New("help: announcement not found")
)

// ChangelogEntry models the changelog format per §3.1.
type ChangelogEntry struct {
	EntryID         string    `json:"entry_id"`
	Date            string    `json:"date"` // e.g. "2026-11-04"
	Title           string    `json:"title"`
	Category        string    `json:"category"` // "Feature", "Improvement", "Fix", "Breaking Change"
	AffectedModules []string  `json:"affected_modules"`
	Description     string    `json:"description"`
	Impact          string    `json:"impact"`
	PublishedAt     time.Time `json:"published_at"`
}

// SystemAnnouncement models in-app announcements (§3.2, §17.7).
type SystemAnnouncement struct {
	AnnouncementID string     `json:"announcement_id"`
	Title          string     `json:"title"`
	Body           string     `json:"body"`
	Type           string     `json:"type"`         // "breaking_change", "feature_launch", "improvement", "fix"
	DisplayMode    string     `json:"display_mode"` // "blocking_modal", "modal", "banner", "toast"
	Priority       int        `json:"priority"`     // 4 = breaking, 3 = feature, 2 = improvement, 1 = fix
	TargetPlans    []string   `json:"target_plans"` // e.g. ["pro", "business"]
	TargetModes    []string   `json:"target_modes"` // e.g. ["creator", "seller"]
	TargetLocales  []string   `json:"target_locales"`
	StartsAt       time.Time  `json:"starts_at"`
	EndsAt         *time.Time `json:"ends_at,omitempty"`
	IsDismissible  bool       `json:"is_dismissible"`
	CreatedAt      time.Time  `json:"created_at"`
}

// Priority ranks for announcement types (§3.2)
func AnnouncementPriority(annType string) (int, string) {
	switch strings.ToLower(strings.TrimSpace(annType)) {
	case "breaking_change", "breaking":
		return 4, "blocking_modal"
	case "feature_launch", "feature":
		return 3, "modal"
	case "improvement":
		return 2, "banner"
	default: // fix / info
		return 1, "toast"
	}
}

// ListChangelog returns published changelog entries.
func (s *Service) ListChangelog(ctx context.Context, categoryFilter string) ([]ChangelogEntry, error) {
	s.store.mu.RLock()
	defer s.store.mu.RUnlock()

	var out []ChangelogEntry
	catFilter := strings.ToLower(strings.TrimSpace(categoryFilter))

	for _, entry := range s.store.changelogEntries {
		if catFilter != "" && !strings.EqualFold(entry.Category, catFilter) {
			continue
		}
		out = append(out, *entry)
	}

	return out, nil
}

// GetActiveAnnouncementsForUser returns announcements targeted to a user (§3.2).
// Invariants enforced:
// 1. Max 1 announcement per session per user (sessionCount > 0 returns empty).
// 2. User dismissal check: dismissed announcements never reappear.
// 3. Targeting per tier, per operator mode, per region/locale.
// 4. Priority ordering: Breaking changes > Feature launches > Improvements > Fixes.
func (s *Service) GetActiveAnnouncementsForUser(
	ctx context.Context,
	userID, workspaceID, tier, operatorMode, locale string,
	sessionSeenCount int,
) ([]SystemAnnouncement, error) {
	// Rule: Max 1 announcement per session per user
	if sessionSeenCount >= 1 {
		return nil, nil
	}

	s.store.mu.RLock()
	defer s.store.mu.RUnlock()

	now := time.Now().UTC()
	userTier := strings.ToLower(strings.TrimSpace(tier))
	userMode := strings.ToLower(strings.TrimSpace(operatorMode))
	userLocale := strings.ToLower(strings.TrimSpace(locale))

	var candidates []SystemAnnouncement

	for _, ann := range s.store.announcements {
		// Active time window
		if now.Before(ann.StartsAt) {
			continue
		}
		if ann.EndsAt != nil && now.After(*ann.EndsAt) {
			continue
		}

		// Check if previously dismissed by this user
		dismissKey := userID + ":" + ann.AnnouncementID
		if s.store.announcementDismissals[dismissKey] {
			continue
		}

		// Check Plan Targeting
		if len(ann.TargetPlans) > 0 {
			planMatch := false
			for _, p := range ann.TargetPlans {
				if strings.EqualFold(p, userTier) {
					planMatch = true
					break
				}
			}
			if !planMatch {
				continue
			}
		}

		// Check Operator Mode Targeting
		if len(ann.TargetModes) > 0 {
			modeMatch := false
			for _, m := range ann.TargetModes {
				if strings.EqualFold(m, userMode) {
					modeMatch = true
					break
				}
			}
			if !modeMatch {
				continue
			}
		}

		// Check Locale Targeting
		if len(ann.TargetLocales) > 0 && userLocale != "" {
			locMatch := false
			for _, l := range ann.TargetLocales {
				if strings.EqualFold(l, userLocale) {
					locMatch = true
					break
				}
			}
			if !locMatch {
				continue
			}
		}

		candidates = append(candidates, *ann)
	}

	// Sort candidates by priority (Highest priority first)
	sortAnnouncementsByPriority(candidates)

	// Max 1 per session: take only the top priority announcement
	if len(candidates) > 1 {
		return candidates[:1], nil
	}

	return candidates, nil
}

func sortAnnouncementsByPriority(items []SystemAnnouncement) {
	for i := 0; i < len(items)-1; i++ {
		for j := i + 1; j < len(items); j++ {
			if items[j].Priority > items[i].Priority {
				items[i], items[j] = items[j], items[i]
			}
		}
	}
}

// DismissAnnouncement records an announcement dismissal by a user (§3.2).
// Dismissed announcements do not reappear.
func (s *Service) DismissAnnouncement(
	ctx context.Context,
	userID, workspaceID, announcementID string,
) error {
	if strings.TrimSpace(userID) == "" || strings.TrimSpace(announcementID) == "" {
		return ErrInvalidInput
	}

	s.store.mu.Lock()
	defer s.store.mu.Unlock()

	if _, exists := s.store.announcements[announcementID]; !exists {
		return ErrAnnouncementNotFound
	}

	dismissKey := userID + ":" + announcementID
	s.store.announcementDismissals[dismissKey] = true

	return nil
}

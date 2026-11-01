/**
 * Creativanta Go V5 Design Tokens
 * Source of truth: docs/00_index/AGENT_TASK_CARDS.md, PRD V5 Design Language
 */
export const V5_THEME = {
  colors: {
    paper: '#fbf9f5',
    paperCard: '#ffffff',
    paperMuted: '#f4f0e8',
    paperBorder: '#e7e2d7',
    ink: '#242924',
    inkMuted: '#616c63',
    inkSubtle: '#8a968c',
    vermilion: '#d94a31',
    vermilionHover: '#c23e27',
    vermilionSubtle: '#fbeee9',
    forest: '#274333',
    forestHover: '#1e3528',
    forestSubtle: '#eef3f0'
  },
  typography: {
    fontSans: '-apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif'
  }
} as const;

export type V5Theme = typeof V5_THEME;

---
description: Rules for reusing, extending, and creating shared widgets in Elara LMS. Use when writing or modifying UI components, screens, or layouts.
globs: lib/**/*.dart
alwaysApply: false
---

# Elara LMS Shared Widgets Guidelines

To maintain visual consistency, reduce code duplication, and enforce design tokens throughout Elara LMS, **always inspect the shared widgets catalog before building new UI**.

---

## 📐 The Golden Rule of UI Development

> [!IMPORTANT]
> **Reuse first, extend second, create last.**
> If a feature or screen requires common UI patterns (e.g., headers, buttons, cards, progress bars, settings lists, tabs), **extend or compose** the widgets under `lib/shared/widgets/` rather than re-creating them inside a feature module.

---

## 🗃️ Shared Widgets Catalog (`lib/shared/widgets/`)

Familiarize yourself with the existing shared components before writing any UI layout code:

| File / Component | Purpose & Description | Typical Use Cases |
| :--- | :--- | :--- |
| **`app_buttons.dart`**<br>`AppPrimaryButton`<br>`AppSecondaryButton`<br>`AppOutlineButton`<br>`AppGhostButton`<br>`AppPrimaryReversedButton`<br>`AppSecondaryReversedButton` | Themed buttons adhering to system design tokens. Supports loading states (`isLoading`), leading/trailing icons, and text labels. | Primary forms, optional actions, outline borders, clean text-only options, light-on-dark contrasts. |
| **`app_glass_header.dart`**<br>`AppGlassHeader` | A premium blurred glass `AppBar` that implements `PreferredSizeWidget`. Manages titles, subtitles, action widgets, custom leading actions, and automatic back buttons. | Top screen headers, dashboards, detailed views. |
| **`app_section_header.dart`**<br>`AppSectionHeader` | A structured horizontal row for category headings. Includes a bold title, optional "See All" action, and an optional **Create** action. | Main categories, list divisions, grid sections. Frequently opens a `GroupDialog` via `onCreateGroup`. |
| **`pill_tab_bar.dart`**<br>`PillTabBar` | A modern, pill-shaped customized `TabBar` designed for smooth navigation. Works with both `DefaultTabController` or custom `TabController`. | Category filters, sub-navigation blocks. |
| **`app_bottom_nav_bar.dart`**<br>`AppBottomNavBar`<br>`AppNavTab` | A premium floating bottom navigation shell that contains presets for the three key roles: `studentTabs`, `teacherTabs`, and `parentTabs`. | Root shells for role dashboards. |
| **`app_action_card.dart`**<br>`AppActionCard` | A premium card displaying a title, subtitle, icon, custom gradient theme, and a selection state that produces a visual "glow" effect when activated. | Call-to-actions, mode selectors, onboarding choices. |
| **`subject_group_card.dart`**<br>`SubjectGroupCard` | The standard card representation for subject groups. Uses `SubjectGroupCardVariant` (`student`, `teacher`, `roadmap`) and handles draft states via `isDraft`. | Classroom listings, study plan blocks, learning paths. |
| **`gradient_glow_card.dart`**<br>`GradientGlowCard`<br>`GradientGlowClipStack`<br>`GlowOrbLayer` | Elevated cards utilizing glowing gradients (`GradientGlowTints` / `GradientGlowOrbs`) to match hero elements. | Core stats, hero banners, special achievements. |
| **`progress_bar.dart`**<br>`ProgressBar` | A combination widget that presents a progress percentage, labels, and the progress bar. | Progress trackers, completion percentages. |
| **`segmented_progress_bar.dart`**<br>`SegmentedProgressBar` | A bare progress bar indicator. Supports custom heights and track color overlays. | In-card progress bars, nested indicators. |
| **`app_activity_item.dart`**<br>`AppActivityItem` | A standardized list row depicting activity history. Features an SVG icon container, title, subtitle, and elapsed time text. | Notification centers, teacher alerts, recent activity feeds. |
| **`create_group_dialog.dart`**<br>`GroupDialog`<br>`GroupDialogConfig` | A structured, full-screen dialog wrapping configuration fields for group generation. | Category/classroom group creation. |
| **`app_form_dialog.dart`** | A uniform, highly polished overlay layout for user data input. | Feature input modals, quick edits. |
| **`settings/settings_card.dart`**<br>`SettingsCard` | An elevated, rounded structural surface card that encapsulates arbitrary child lists. | Settings panels, account categories. |
| **`settings/settings_section_list.dart`**<br>`SettingsSectionList`<br>`SettingsNavigationTile`<br>`SettingsToggleTile`<br>`SettingsDenseChipTile` | Highly polished settings layout widgets supporting navigations, toggle switches, and metadata chips with automatic divider spacing. | Profile settings, app customization, notification preferences. |
| **`announcement_card.dart`**<br>`AnnouncementCard` | Shared announcement card with a left orange accent border, title row (with elapsed time), and body copy. Shows an `AppOverflowMenu` (Edit/Delete) only when `onEdit`/`onDelete` callbacks are provided, so student and teacher views share the same widget. | Student/teacher group announcement feeds, bulletin boards. |
| **`announcement_form_content.dart`**<br>`AnnouncementFormContent` | Reusable two-field form (Title + Body) with a submit button. Owns its own `TextEditingController` lifecycle. Supports pre-filled values for edit mode via `initialTitle`/`initialBody`, and customisable field labels. | Add/Edit announcement dialogs, any two-field form overlay. |
| **`app_dialog.dart`**<br>`AppDialog` | A compact, centered modal dialog with a title bar, close (✕) icon, and arbitrary `content` slot. Includes a static `AppDialog.show()` helper that applies a custom slide-up + fade-in transition with a semi-transparent barrier. | Announcement forms, confirmation prompts, lightweight input modals. |
| **`app_overflow_menu.dart`**<br>`AppOverflowMenu`<br>`AppOverflowMenuItem` | A custom floating overflow menu triggered by a ⋮ icon button. Renders each item as a full-width colored row (icon + label) stacked vertically in an `OverlayEntry`, with rounded corners and a full-screen dismiss layer. | Announcement Edit/Delete menus, any contextual action overflow. |
| **`app_stat_tile.dart`**<br>`AppStatTile` | A colored stat tile displaying an SVG icon, a label, and a large value. Accepts a custom `backgroundColor` to match any brand palette. | Teacher dashboards, group analytics, overview stats. |
| **`app_tab_bar.dart`**<br>`AppTabBar` | A lightweight, self-contained pill-shaped tab bar (no `TabController` dependency). Each tab animates between brand-primary active fill and transparent inactive states. Manages selection via `activeTab` index and `onTabChanged` callback. | Sub-navigation inside detail screens, content filters. |
| **`app_text_field.dart`**<br>`AppTextField` | A globally shared `TextFormField` with pill-shaped (radius 100) styling, scaffold-colored fill, and built-in validator support. Accepts `readOnly`, `onTap`, `onChanged`, and `textInputAction` for flexible use. | Search bars, inline edit fields, quick-entry inputs. |
| **`assignment_overview_card.dart`**<br>`AssignmentOverviewCard` | An elevated summary card showing assignment XP reward and optional overall progress (completed/total problems + `LinearProgressIndicator`). Progress section renders only when all three progress params are provided. | Student homework screens, teacher assignment detail views. |
| **`learner_stats_row.dart`**<br>`LearnerStatsRow` | A horizontal row of three `StatColumnCard` tiles (Day Streak, Total XP, Lessons) with brand-secondary, brand-primary, and success color palettes respectively. | Student profile overview, parent child-detail cards. |
| **`module_card.dart`**<br>`ModuleCard`<br>`ModuleLeadingCircle` | Shared roadmap module row card. Layout: leading 48×48 circle + card body (label, title, description, optional trailing widget). Callers inject the `leading` circle and `cardTrailing` slot so student status chips and teacher overflow menus share the same base. `ModuleLeadingCircle` is a companion widget for the leading icon. | Student roadmap list, teacher roadmap management. |
| **`stat_column_card.dart`**<br>`StatColumnCard` | A single vertical stat tile (SVG icon, value, label) rendered over a gradient-filled card with a decorative glow orb. Accepts configurable `color`, `titleColor`, and `subtitleColor` for any brand palette. | Profile stat rows (via `LearnerStatsRow`), parent child cards, achievement highlights. |
| **`student_row_card.dart`**<br>`StudentRowCard` | A generic student row card: circular avatar + name (expanded) + customisable `trailing` widget. Supports optional `onTap`, custom `avatarChild`, configurable `avatarSize`, `cardColor`, and `showShadow`. | Student enrollment lists, score displays, attendance rows, grade tables. |

---

## 🛠️ When to Create or Elevate a Widget

1. **Feature-Specific Widgets:** If a UI widget is used **strictly within one feature** (e.g., a rewards widget only used in student rewards), keep it inside `lib/features/<feature>/presentation/widgets/`.
2. **Promotion to Shared:** If a widget created inside a feature folder starts being imported by another feature, it **must** be promoted:
   - Extract it from the feature folder.
   - Refactor it to depend solely on **design tokens** (`AppColors`, `AppSpacing`, etc.) and basic domain entities, removing any feature-specific dependency.
   - Move it to `lib/shared/widgets/` and add it to the catalog in this file.
3. **No Direct Data Layer Imports:** Shared widgets must **never** import `data/` directories, models, or API clients. They must receive all display data via constructor parameters (e.g., primitives, styles, or pure domain `Entities`).

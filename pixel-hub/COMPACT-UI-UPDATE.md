# PixeL UI 1.2 — compact toolbar and notification center

This release updates only the UI library. Existing hub loaders and game logic are unchanged.

## Layout

- Compact density is enabled by default and can be changed with `Compact layout` in Settings. The preference uses existing autosave/autoload. Compact reduces desktop control metrics, container spacing, navigation height and the page heading. Touch controls retain their existing input dimensions.
- One global search field lives in the top toolbar. The old per-page search placement and filtering behavior are removed. Search finds controls/actions across inactive tabs, including localized labels and descriptions. Clicking a result selects the tab, expands the group, scrolls to the target and briefly highlights it. Hidden controls are excluded; the first 30 matches are shown.
- Header/tab/group/toast icons are smaller. The toolbar uses fixed alignment, restrained borders, rounded utility panels and consistent spacing. The Kingdom palette and pixel identity remain.
- Minimize immediately hides navigation, page content and utility panels. The window becomes a bar at most 360 logical pixels wide and 76 high, with title, restore/close controls, session status and All Off. Restore preserves the original size and selected tab. The compact bar obeys current UI scale.

## Notifications and motion

- Toolbar button opens a scrollable notification center with the newest 50 session messages, unread badge, clear action and repeated-message counts.
- Matching messages within 10 seconds are merged, including interleaved repeats. Opening the center marks messages read. Incoming messages remain read while the center is open. Active toasts are capped at four; duplicates update history without another toast.
- Utility panels close on outside click, Escape, hide or minimize. They are sized to fit short/narrow windows. Full history text remains available through row tooltips.
- Kingdom interactions use short press/hover feedback, 160 ms page/section transitions and subtle restore/minimize feedback. Toggle coin/burst decoration is omitted in Kingdom. Reduce Motion continues to apply.

## Verification

Luau compilation and real-window-construction mocks pass. 46 checks cover global search across inactive tabs and languages, actions/hidden controls, result navigation, toolbar bounds at 320–900 logical pixels, minimized controls/restore, compact spacing, notification grouping/read state, history/toast limits and cleanup. Autosave/config migration checks and existing shared-UI layout/animation/localization checks also pass.

No live Roblox/executor rendering is available. Notification history is limited to the current library session and is cleared on unload. Existing consumers that inspect SearchField should account for its new Topbar parent; public library methods and option IDs remain compatible.

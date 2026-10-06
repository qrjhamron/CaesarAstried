# PixeL UI 1.2 — Jeaneism

Universal Roblox retro/pixel UI library by **Jeaneism**. Website: **https://0x4.me**.

English, Indonesia and ไทย can be changed live, including the Loot To Forge controls, dashboard, mini HUD and settings. Automatic language selection recognizes Roblox Indonesian and Thai locales. The existing URL and library API remain available:

```lua
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/qrjhamron/CaesarAstried/main/pixel-hub/pixel-hub-ui.lua"))()
local Window = Library:CreateWindow({ Title = "PixeL UI", Theme = "Workshop", AnimationIntensity = "Lively", Language = "Auto" })
Window:AddSettingsTab()
```

The URL loader requires `game:HttpGet` and `loadstring`. In Roblox Studio, import `pixel-hub-ui.lua` as a ModuleScript and require it from a LocalScript. See [example.client.lua](example.client.lua) for Studio or [loader.lua](loader.lua) for URL loading.

## PixeL UI 1.2

- 75 newly authored 16×16 semantic icons; **96 built-in icons total**. Anvil, hammer, ore, equipment, boss, tower, chest, potion, rune, controls, settings, and four robot poses. See [icon-catalog.md](icon-catalog.md).
- Read-only dashboard cards with live values and explicit Running / Waiting / Off / Success / Error states.
- Pocket Arcade identity and a new Workshop palette for Loot To Forge. Contextual accents follow the selected tab; semantic status colors remain meaningful.
- Robot mascot reacts to work, success and error; decorative idle motion respects animation settings.
- Explicit result feedback for confirmed forge responses and successful config saves. A click only indicates interaction.
- Mini mode displays current task, enabled-feature count and All Off when a callback is configured. All Off switches configured toggles off; it does not cancel an already executing game operation.
- Narrow-screen/touch navigation drawer, one-column touch content, a separate full-width search row, and centered viewport-constrained pickers.
- Reduced Motion respects the Roblox setting by default; manual override and intensity controls remain available.

## Localization API

```lua
Library:SetLanguage("ID") -- EN / ID / TH
Library:RegisterTranslations("ID", { ["My label"] = "Label saya" })
local label = Library:T("English text", "ข้อความไทย", "Teks Indonesia")
Library:OnLanguageChanged(function() -- refresh custom dynamic text here
end)
```

The existing `Library:T(english, thai)` call remains compatible. `Extra` remains accepted as a legacy animation value; the settings display uses Lively.

## Dashboard API

```lua
local Tab = Window:AddTab("Home", "chart")
local Group = Tab:AddLeftGroupbox("Session", "network")
local Card = Group:AddStatCard({ Title = "Coins", Value = 0, Icon = "coin-stack", Status = "Waiting" })
Card:SetValue(1200)
Card:SetStatus("Success", "Current")
Card:SetIcon("gem-green")
Window:SetSessionStatus("Forge", 2, "Running")
Window:SetAllOff(function() -- switch your feature toggles off here
end)
Library:Feedback("Forge") -- only after your application confirms the result
```

Use `Multiline = true` on cards with longer values. `Library:GetIcons()` returns a sorted copy of all icon names. Existing controls, option IDs, configs, language support, custom asset overrides and legacy icon aliases remain compatible. The storage directory remains `mariohub` to preserve saved data.

## Loot To Forge

[loot-to-forge.lua](loot-to-forge.lua) uses this library URL, the Workshop theme, a session dashboard, semantic icons, shared All Off and the mini HUD. Community links and changelog moved into Settings. Rejoin loads the published updated script. The window, notifications and website identify Jeaneism / PixeL UI. Existing option/config IDs are preserved.

## Validation

Library, game integration, URL example and Studio example compile with Luau. Mock tests cover icon dimensions/aliases, dashboard updates, semantic colors, mobile/desktop layout transitions, popup placement, mini All Off, maskot reactions, motion pause/resume and cleanup. Separate tests check confirmed forge response counts, rejected responses and missing ore.

There is no Roblox runtime in this workspace. Actual game data, visual clipping, keyboard/touch behavior and frame rates require an in-game check. Mock tests cannot establish successful execution in Loot To Forge.

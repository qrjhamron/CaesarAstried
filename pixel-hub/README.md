# Pixel Hub

Universal retro/pixel Roblox UI library, with six arcade themes, 21 built-in pixel icons, button bursts, tab transitions, and configurable motion.

## Load the library

```lua
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/qrjhamron/CaesarAstried/main/pixel-hub/pixel-hub-ui.lua"))()
local Window = Library:CreateWindow({
    Theme = "Arcade",
    AnimationIntensity = "Extra", -- Low / Normal / Extra
})
Window:AddSettingsTab()
```

This URL loader requires an environment providing `game:HttpGet` and `loadstring`. In Roblox Studio, import the library as a ModuleScript and require it from a LocalScript.

Run [loader.lua](loader.lua) for a complete small UI example.

## Themes and icons

Themes: Arcade, Daylight, Midnight, Forest, Sunset, Frost. Older themes remain accepted.

Icons: spark, home, robot, crystal, cartridge, portal, leaf, shield, eye, flag, key, gear, heart, warning, check, bolt, search, code, copy, refresh, block.

Legacy icon names such as mushroom, qblock, pipe, and boo resolve to the new universal sprites. Existing option IDs and storage paths are retained for configuration compatibility.

## Motion

```lua
Library:SetAnimationIntensity("Normal")
Library:SetReduceMotion(true)
```

Decorative motion and particles pause when the window is hidden or minimized. Reduce Motion disables decorative motion and makes transitions immediate.

Luau compilation and mocked animation lifecycle checks passed. Visual behavior still needs validation in Roblox.

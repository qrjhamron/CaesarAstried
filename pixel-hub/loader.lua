-- Requires an environment providing game:HttpGet and loadstring.
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/qrjhamron/CaesarAstried/main/pixel-hub/pixel-hub-ui.lua"))()

local Window = Library:CreateWindow({
    Title = "Pixel Hub",
    SubTitle = "PLAYGROUND",
    Theme = "Arcade",
    AnimationIntensity = "Extra",
    Intro = true,
})

local Home = Window:AddTab("Home", "home", "Welcome to Pixel Hub")
local Controls = Home:AddLeftGroupbox("Controls", "robot")
Controls:AddToggle("DemoPower", { Text = "Power up", Default = true })
Controls:AddSlider("DemoSpeed", { Text = "Speed", Min = 0, Max = 100, Default = 50, Suffix = "%" })
Controls:AddButton({
    Text = "Collect reward",
    Style = "Primary",
    Func = function()
        Library:Notify("Reward collected", "Your crystal is ready!", 4, "Success")
    end,
})
Window:AddSettingsTab()

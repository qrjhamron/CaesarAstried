-- URL loader: requires game:HttpGet and loadstring.
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/qrjhamron/CaesarAstried/main/pixel-hub/pixel-hub-ui.lua"))()
local Power
local Window = Library:CreateWindow({
    Title = "PixeL UI", Navigation = "Chunky", IntroDuration = 7.5, SubTitle = "Jeaneism · 0x4.me", Owner = "Jeaneism", Website = "https://0x4.me", Language = "Auto", Theme = "Citadel",
    AnimationIntensity = "Lively",
    AllOff = function() if Power then Power:SetValue(false) end end,
})
local Home = Window:AddTab("Dashboard", "castle-gate", "Explore the PixeL UI components")
local Stats = Home:AddLeftGroupbox("Session", "network")
local Activity = Stats:AddStatCard({Title="Current task",Value="Idle",Icon="clock",Status="Off"})
local Controls = Home:AddRightGroupbox("Controls", "settings-sliders")
Power = Controls:AddToggle("DemoPower", {Text="Power up",Callback=function(value)
    Activity:SetValue(value and "Demo enabled" or "Idle")
    Activity:SetStatus(value and "Running" or "Off")
    Window:SetSessionStatus(value and "Demo" or "Idle", value and 1 or 0, value and "Running" or "Off")
end})
Controls:AddSlider("DemoSpeed", {Text="Speed",Min=0,Max=100,Default=50,Suffix="%"})
Controls:AddButton({Text="Preview forge feedback",Style="Primary",Func=function() Library:Feedback("Forge") end})
local Gallery = Window:AddTab("Icons", "palette", "96 icons: 75 new semantic illustrations")
local Preview = Gallery:AddLeftGroupbox("Icon preview", "grid")
local Tile = Preview:AddStatCard({Title="Selected icon",Value="castle-gate",Icon="castle-gate",Status="Success"})
Preview:AddDropdown("DemoIcon", {Text="Icon",Values=Library:GetIcons(),Default="castle-gate",NoSave=true,
    Callback=function(value) Tile:SetIcon(value);Tile:SetValue(value) end})
local Themes = Gallery:AddRightGroupbox("Themes", "palette")
Themes:AddDropdown("DemoTheme", {Text="Theme",Values=Library.Themes,Default="Citadel",Callback=function(value) Library:SetTheme(value) end})
Window:AddSettingsTab()

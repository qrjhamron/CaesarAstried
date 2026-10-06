if not game:IsLoaded() then
    game.Loaded:Wait()
end

if game.GameId ~= 10684750879 then
    game:GetService("Players").LocalPlayer:Kick("PixeL UI 1.2: this script is for Loot To Forge only")
    return
end

local PixeLBanner = {
    Print = print,
    Started = os.clock(),
    Last = os.clock(),
    Done = 0,
    Total = 4,
}

do
    local ok, renv = pcall(getrenv)
    if ok and type(renv) == "table" and type(renv.print) == "function" then
        PixeLBanner.Print = renv.print
    end
end

function PixeLBanner.Show()
    local ok, executor = pcall(identifyexecutor)
    if not ok or type(executor) ~= "string" then executor = "Unknown" end
    local rule = string.rep("=", 54)
    PixeLBanner.Print(table.concat({
        rule,
        "    [■ ■]  PixeL UI 1.2 / Jeaneism",
        "     [═]   LOOT TO FORGE",
        "   by Jeaneism  //  0x4.me",
        "   executor: " .. executor .. " / player: " .. game:GetService("Players").LocalPlayer.Name,
        rule,
    }, "\n"))
end

---@param label string  what just finished loading
function PixeLBanner.Step(label)
    local now = os.clock()
    PixeLBanner.Done = math.min(PixeLBanner.Done + 1, PixeLBanner.Total)
    local filled = math.floor(PixeLBanner.Done / PixeLBanner.Total * 20 + 0.5)
    PixeLBanner.Print(string.format("[PixeL UI 1.2] [%s] %3d%%  %-24s +%dms",
        string.rep("#", filled) .. string.rep(".", 20 - filled),
        math.floor(PixeLBanner.Done / PixeLBanner.Total * 100), label, math.floor((now - PixeLBanner.Last) * 1000)))
    PixeLBanner.Last = now
end

function PixeLBanner.Ready()
    local rule = string.rep("=", 54)
    PixeLBanner.Print(table.concat({
        rule,
        string.format("   >> READY in %dms", math.floor((os.clock() - PixeLBanner.Started) * 1000)),
        rule,
    }, "\n"))
end

pcall(PixeLBanner.Show)
pcall(PixeLBanner.Step, "Core")

if not LPH_OBFUSCATED then
    local function Passthrough(fn) return fn end
    LPH_JIT, LPH_JIT_MAX, LPH_NO_VIRTUALIZE = Passthrough, Passthrough, Passthrough
end

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local VirtualUser = game:GetService("VirtualUser")
local RunService = game:GetService("RunService")
local GuiService = game:GetService("GuiService")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local StarterGui = game:GetService("StarterGui")

local LocalPlayer = Players.LocalPlayer

local Jeaneism = setmetatable({}, {
    __newindex = function(self, key, value)
        rawset(self, key, type(value) == "function" and LPH_JIT(value) or value)
    end,
})

Jeaneism.Config = {
    SaveFolder = "Loot To Forge",
    Website = "https://0x4.me",
    UpdateLog = {
        { "2026-10-06", "Auto click rate control and typing pause\nSingle-worker fast loops\nRetry backoff for failed jobs\nString-ID training areas fixed\nAuto reconnect deduplicated\nRace and coin loops stop after unload" },
        { "2026-10-04", "Spawn Scrolls, Tickets & Stones\nDupe Whole Inventory\nAdd Season Coins (OP)\nFaster Tower farm\nRemoved keybinds from auto features\nMax Gear picks Exclusive gear\nSpawn Gear (OP)\nPotions (OP)\nFixed Auto World Boss\nBoss Server Hop\nAuto Sell keeps your best base gear\nMax Gear now goes to +20, much faster\nFixed freeze when loading the script\nUpdated for the new game version\nAuto Sell keeps items you locked\nSteadier Boss Server Hop" },
        { "2026-10-03", "Fixed World Boss, Auto Click & Codes\nImproved Auto Train\nAuto rune detection" },
    },
    UiSource = "https://raw.githubusercontent.com/qrjhamron/CaesarAstried/main/pixel-hub/pixel-hub-ui.lua",
    ReloadSource = [[
if not game:IsLoaded() then game.Loaded:Wait() end
task.wait(2)
local url = "https://raw.githubusercontent.com/qrjhamron/CaesarAstried/main/pixel-hub/loot-to-forge.lua"
local ok, body = pcall(game.HttpGet, game, url)
if not (ok and type(body) == "string") then
    local requester = request or http_request or (syn and syn.request) or (http and http.request)
    local sent, reply = pcall(requester, { Url = url, Method = "GET" })
    body = sent and type(reply) == "table" and reply.Body
end
if type(body) == "string" then loadstring(body)() end]],
    LoadTimeout = 30,
    RemoteTimeout = 10,
    RequireTimeout = 3,
    MaxFailures = 5,
    FailWindow = 10,
    AlertTries = 20,
    AlertDelay = 0.5,
    TickDelay = 0.2,
    StatusInterval = 2,
    PumpInterval = 0.25,
    RefillAmount = 100000,
    OwnedOresLabel = "Owned ores",
    AcquireRounds = 300,
    StoneWorkers = 8,
    StoneCallsPerWorker = 15,
    TowerWorkers = 128,
    CoinFarmTimeout = 600,
    PotionStack = 100000,
    TowerCallsPerWorker = 25,
    GearForgeTries = 15,
    GearEnhanceTries = 2,
    GearEnhanceWorkers = 8,
    SlotEnhanceRounds = 200,
    ClickInterval = 0.16,
    RetryBase = 0.25, RetryMax = 2,
    ForgeTargets = {
        { name = "Great Weapon", forgeType = "Weapon", ores = 13 },
        { name = "Katana", forgeType = "Weapon", ores = 4 },
        { name = "Armor", forgeType = "Armor", ores = 11 },
        { name = "Hat", forgeType = "Armor", ores = 4 },
    },
    GearSlots = {
        { slot = "Weapon", forgeType = "Weapon", ores = 13 },
        { slot = "Armor", forgeType = "Armor", ores = 11 },
        { slot = "Hat", forgeType = "Armor", ores = 4 },
    },
    GearTypes = { "Weapon", "Armor", "Hat" },
    EnchantPriority = { "Poison_3", "Thunder_3", "Ice_3", "Fire_3", "Poison_2", "Thunder_2", "Ice_2", "Fire_2" },
    RuneMinTier = 2,
    EnchantRefill = 50,
    ForgeCountMax = 30,
    PlanSlice = 0.004,
    HuntBatch = 40,
    HuntWorkers = 4,
    HuntMaxForges = 4000,
    HuntTargetHits = 3,
    IndexInterval = 60,
    IndexLevelClaims = 50,
    ClaimIdScan = 20,
    ClaimInterval = 30,
    SeasonInterval = 60,
    BossCards = 8,
    BossAttackIds = { Katana = "K_ATK_1", Great = "G_ATK_1" },
    BossHitsPerTick = 30,
    BossHitGap = 0.02,
    BossJoinSettle = 1,
    BossClaimDelay = 3.5,
    BossStandHeight = 3,
    BossStandBack = 8,
    BossReach = 25,
    UpgradeInterval = 5,
    EquipInterval = 3,
    SellInterval = 1,
    RebirthInterval = 2,
    BossInterval = 1,
    BossHopInterval = 5,
    BossHopLead = 150,
    BossHopAfter = 8,
    BossHopFlag = "bosshop.txt",
    BossHopResume = 180,
    BossHopServers = "bossservers.json",
    HopListTtl = 120,
    HopBackoffStart = 5,
    HopBackoffMax = 60,
    HopGiveUp = 8,
    HopStall = 30,
    HopGap = 15,
    TrainRejoinDelay = 0.3,
    TrainWatchdog = 3,
    TrainAcceptWait = 1.5,
    TrainExitTries = 3,
    TrainSettle = 0.5,
    WarnCooldown = 30,
    WarnMemory = 64,
    KillAuraInterval = 0.25,
    KillDamage = 1e30,
    RaceRollDelay = 0.45,
    RejoinDelay = 5,
    CodeReplyWait = 1.5,
    Codes = { "100000CCU", "50000CCU", "30000CCU", "20000CCU" },
    Needs = {
        CollectOre = { "Remote.Stage.StageFinishedRF", "Remote.Stage.GetOreRF", "Remote.Stage.ClaimedAllOreRE", "Config.Stage.Helper", "Config.Ore.Config" },
        SuperLootAura = { "Remote.SuperLoot.KillSuperLootRE", "Remote.SuperLoot.RefreshSuperLootRE", "Remote.Stage.GetOreRF" },
        AutoWorldBoss = { "Remote.WorldBoss.IntoWorldBossFight", "Remote.WorldBoss.ExitWorldBossFight", "Remote.WorldBoss.BossDeadRE", "Remote.Attack.UseAnyATKRE", "Remote.Attack.AttackEnemyServiceRE" },
        AutoIndex = { "Remote.Forge.ForgeRF", "Remote.Index.TryClaimIndexExpRF", "Utils.ForgeUtils", "Config.Weapon.Config", "Config.Armor.Config" },
        MaxGear = { "Utils.BalanceUtils", "Remote.Forge.ForgeRF", "Remote.Backpack.EnhantEquipmentRF", "Remote.Backpack.EnchantRE", "Config.Enhant.Config", "Config.EnchStone.Show" },
        AutoEquip = { "Utils.BalanceUtils", "Remote.Backpack.TryEquipItemRE", "Config.Weapon.Helper", "Config.Armor.Helper" },
        AutoForge = { "Remote.Forge.ForgeRF", "Remote.Backpack.TrySellItemRE", "Config.Ore.Config" },
        AutoSell = { "Remote.Backpack.TrySellItemRE", "Config.Weapon.Config", "Config.Armor.Config" },
        AutoTrain = { "Remote.Train.IntoAutoTrainRE", "Remote.Train.ExitAutoTrainRE", "Config.TrainArea.Config" },
        AutoRebirth = { "Remote.Rebirth.TryRebirthRE", "Config.Rebirth.Helper" },
        AutoUpgrade = { "Remote.Upgrade.UpgradeOnceRE", "Config.Upgrade.Config" },
        AutoTower = { "Remote.Dungeon.TryIntoDungeonRF", "Remote.Dungeon.StartRoundRE", "Remote.Dungeon.CompleteRoundRF", "Config.Dungeon.Config.LootTab" },
        AutoSeason = { "Remote.Season.TryClaimDailyTicRE", "Remote.Season.ExchangeGoodsRE", "Remote.Season.LuckRE", "Config.Season.GoodsConfig" },
        AutoClaim = { "Remote.Offline.TryClaimOfflineRewardRE", "Remote.Online.TryClaimRE" },
        AutoRace = { "Remote.Class.LuckOnceRE", "Config.Class.Config" },
        AutoBestRace = { "Remote.Class.ChangeEquipedIndexRE", "Config.Class.Config" },
        KeepOre = { "Remote.Stage.LostAllOreRF" },
    },
    KaitunToggles = { "MaxGear", "AutoEquip", "AutoForge", "AutoSell", "AutoTrain", "AutoRebirth", "AutoUpgrade", "AutoClaim", "AutoSeason", "KillAura", "SuperLootAura", "AutoWorldBoss", "AutoTower", "GodMode", "AutoBestRace" },
}

local Config = Jeaneism.Config
local Remote = ReplicatedStorage:WaitForChild("Remote", Config.LoadTimeout)
local GameConfig = ReplicatedStorage:WaitForChild("Config", Config.LoadTimeout)

Jeaneism.State = {
    Alive = true,
    Busy = false,
    Lock = nil,
    Failures = {},
    WorkerLoops = {},
    Halted = {},
    InTower = false,
    Entering = false,
    GearForged = false,
    TrainArea = nil,
    TrainPending = nil,
    TrainEntering = false,
    TrainGen = 0,
    TrainFiredAt = 0,
    TrainRebirth = nil,
    BossReturn = nil,
    TrainLevel = nil,
    TrainNilSince = nil,
    Warned = {},
    WarnedCount = 0,
    LastRun = {},
    Profile = nil,
    GearNote = nil,
    IndexNote = nil,
    TowerLoot = 0,
    OreLabels = {},
    SpawnLabels = {},
    GearLabels = {},
    BossHopping = false,
    HopFails = 0,
    HopBackoff = nil,
    HopBlockedUntil = 0,
    HopQueued = false,
    BossDone = nil,
    MissingLabels = {},
    OreStage = {},
    Plans = {},
    Runes = nil,
    Conns = {},
    Opt = {
        MaxGear = false,
        AutoEquip = false,
        EnhanceTarget = 20,
        GearForge = true,
        GearEnchant = true,
        GearEnhance = true,
        EnchantPriority = {},
        EnhanceSlot = "Weapon",
        ForgeSellJunk = false,
        ForgePerTick = 10,
        BossCards = true,
        SeasonSpin = true,
        SeasonGoods = { ["4"] = true, ["7"] = true },
        AutoBestRace = false,
        GodMode = false,
        KeepOre = false,
        CollectOre = false,
        FarmWorkers = 24,
        FarmAllOres = true,
        Stage = nil,
        CollectRarities = {},
        KillAura = false,
        SuperLootAura = false,
        AutoWorldBoss = false,
        BossHop = false,
        AutoForge = false,
        ForgeTarget = "Great Weapon",
        ForgeOre = nil,
        ForgeRarities = {},
        KeepPerOre = 0,
        BestOreFirst = false,
        AutoSell = false,
        SellTypes = { Weapon = true, Armor = true, Hat = true },
        SellRarities = {},
        KeepPerItem = 1,
        AutoIndex = false,
        IndexTypes = { Weapon = true, Armor = true, Hat = true },
        MissingItem = nil,
        AutoTrain = false,
        AutoClick = false,
        ClickRate = 6,
        ClickPauseTyping = true,
        AutoRebirth = false,
        AutoUpgrade = false,
        Upgrades = {},
        AutoClaim = false,
        AutoSeason = false,
        AutoTower = false,
        AutoRace = false,
        TargetRace = nil,
        SpawnItem = nil,
        SpawnAmount = 100000,
        CoinTarget = 1000000,
        SpawnGear = nil,
        GearCopies = 1,
        SpeedOn = false,
        WalkSpeed = 60,
        InfJump = false,
        AutoRejoin = false,
        LowGraphics = false,
    },
}

local State = Jeaneism.State

Jeaneism.GameLib = { Loaded = {}, Failed = {}, Apis = {}, Deferred = {} }

---@return boolean, any  ok + module, retried from an identity-2 thread when the executor can really switch
function Jeaneism.GameLib.RequireAsGame(module)
    local done, ok, loaded = false, false, nil
    task.spawn(function()
        pcall(setthreadidentity, 2)
        local read, identity = pcall(getthreadidentity)
        if read and identity == 2 then
            ok, loaded = pcall(require, module)
        end
        done = true
    end)
    local deadline = os.clock() + Config.RequireTimeout
    while not done and os.clock() < deadline do
        task.wait()
    end
    return ok, loaded
end

---@return table?  nil when this executor can't require it; the failure is warned once
function Jeaneism.GameLib.Require(module)
    local cached = Jeaneism.GameLib.Loaded[module]
    if cached ~= nil or Jeaneism.GameLib.Failed[module] then return cached end

    local ok, loaded = pcall(require, module)
    if not ok then
        local firstErr = loaded
        ok, loaded = Jeaneism.GameLib.RequireAsGame(module)
        if not ok then
            Jeaneism.GameLib.Failed[module] = tostring(firstErr)
            warn("[LootToForge] require", module:GetFullName(), firstErr)
            return nil
        end
    end
    Jeaneism.GameLib.Loaded[module] = loaded
    return loaded
end

---@return boolean, any ...  pcall-style results
function Jeaneism.GameLib.CallAsGame(fn, ...)
    local args = table.pack(...)
    local box
    task.defer(function()
        pcall(setthreadidentity, 2)
        box = table.pack(pcall(fn, table.unpack(args, 1, args.n)))
    end)
    local deadline = os.clock() + Config.RequireTimeout
    while not box and os.clock() < deadline do
        task.wait()
    end
    if not box then return false, "game call timed out" end
    return table.unpack(box, 1, box.n)
end

function Jeaneism.GameLib.Call(fn, ...)
    if not Jeaneism.GameLib.Deferred[fn] then
        local result = table.pack(pcall(fn, ...))
        if result[1] or not tostring(result[2]):find("non-RobloxScript", 1, true) then
            if not result[1] then error(result[2], 0) end
            return table.unpack(result, 2, result.n)
        end
        Jeaneism.GameLib.Deferred[fn] = true
    end
    local result = table.pack(Jeaneism.GameLib.CallAsGame(fn, ...))
    if not result[1] then error(result[2], 0) end
    return table.unpack(result, 2, result.n)
end

---@return table  function fields go through GameLib.Call; for helper/controller modules, not config tables
function Jeaneism.GameLib.Api(module)
    local api = Jeaneism.GameLib.Apis[module]
    if api then return api end
    local loaded = Jeaneism.GameLib.Need(module)
    api = setmetatable({}, {
        __index = function(self, key)
            local value = loaded[key]
            if type(value) ~= "function" then return value end
            local wrapped = function(...)
                return Jeaneism.GameLib.Call(value, ...)
            end
            rawset(self, key, wrapped)
            return wrapped
        end,
    })
    Jeaneism.GameLib.Apis[module] = api
    return api
end

---@return table  errors with a readable reason instead of returning nil
function Jeaneism.GameLib.Need(module)
    local loaded = Jeaneism.GameLib.Require(module)
    if loaded == nil then
        error(("game data %s.%s can't be read on this executor"):format(module.Parent.Name, module.Name), 0)
    end
    return loaded
end

---@param path string  dotted path under ReplicatedStorage, e.g. "Config.Ore.Config"
---@return Instance?
function Jeaneism.GameLib.Find(path)
    local node = ReplicatedStorage
    for part in path:gmatch("[^%.]+") do
        node = node and node:FindFirstChild(part)
    end
    if node then return node end
    local folder, name = path:match("^Remote%.([^%.]+)%.([^%.]+)$")
    return folder and Jeaneism.Util.FindRemote(folder, name)
end

---@return table  option idx -> missing paths
function Jeaneism.GameLib.Missing()
    local missing = {}
    for idx, paths in pairs(Config.Needs) do
        for _, path in ipairs(paths) do
            if not Jeaneism.GameLib.Find(path) then
                missing[idx] = missing[idx] or {}
                table.insert(missing[idx], path)
            end
        end
    end
    return missing
end

for _, name in ipairs({ "Util", "Data", "Stage", "Ore", "Spawn", "Potion", "Forge", "Sell", "Gear", "Index", "Level", "Upgrade", "Tower", "Boss", "Season", "Claim", "SuperLoot", "Combat", "Guard", "Race", "Movement", "Session", "Scheduler" }) do
    Jeaneism[name] = {}
end

---@return Instance?  nil when missing; a renamed folder is searched by remote name
function Jeaneism.Util.FindRemote(folder, name)
    if not Remote then return nil end
    local holder = Remote:FindFirstChild(folder)
    if holder then return holder:FindFirstChild(name) end
    return Remote:FindFirstChild(name, true)
end

function Jeaneism.Util.Remote(folder, name)
    local remote = Jeaneism.Util.FindRemote(folder, name)
    if remote then return remote end

    local holder = Remote and Remote:WaitForChild(folder, Config.RemoteTimeout)
    remote = holder and holder:WaitForChild(name, Config.RemoteTimeout) or Jeaneism.Util.FindRemote(folder, name)
    if not remote then error(("remote %s.%s not found"):format(folder, name), 0) end
    return remote
end

---@return string?, string?  body, or nil + why every transport failed
function Jeaneism.Util.HttpGet(url)
    local ok, body = pcall(function() return game:HttpGet(url) end)
    if ok and type(body) == "string" then return body end

    local send = request or http_request or (syn and syn.request) or (http and http.request)
    if not send then return nil, tostring(body) end
    local sent, response = pcall(send, { Url = url, Method = "GET" })
    if not sent then return nil, tostring(response) end
    if type(response) ~= "table" or response.StatusCode ~= 200 or type(response.Body) ~= "string" then
        return nil, "HTTP " .. tostring(type(response) == "table" and response.StatusCode)
    end
    return response.Body
end

function Jeaneism.Util.Alert(text, detail)
    warn("[LootToForge] menu:", text, detail or "")
    task.spawn(function()
        for _ = 1, Config.AlertTries do
            local shown = pcall(StarterGui.SetCore, StarterGui, "SendNotification", { Title = "PixeL UI 1.2", Text = text, Duration = 10 })
            if shown then return end
            task.wait(Config.AlertDelay)
        end
    end)
end

---@return table?  the UI library, nil after telling the player why
function Jeaneism.Util.LoadLibrary()
    local body, err = Jeaneism.Util.HttpGet(Config.UiSource)
    if not body or not body:sub(-64):find("return Library%s*$") then
        Jeaneism.Util.Alert("Could not download the menu. Check your connection and run it again.", err or "truncated body")
        return nil
    end
    local chunk, compileErr = loadstring(body)
    if not chunk then
        Jeaneism.Util.Alert("The menu failed to load on this executor: " .. tostring(compileErr))
        return nil
    end
    local ok, library = pcall(chunk)
    if not ok or type(library) ~= "table" then
        Jeaneism.Util.Alert("The menu failed to load on this executor: " .. tostring(library))
        return nil
    end
    return library
end

---Warns a job failure once per Config.WarnCooldown so a feature that flips between failing and succeeding can't flood the console.
function Jeaneism.Util.WarnJob(key, err)
    local stamp = key .. tostring(err):match("[^\n]*")
    local now = os.clock()
    if now - (State.Warned[stamp] or -Config.WarnCooldown) < Config.WarnCooldown then return end

    if not State.Warned[stamp] then
        State.WarnedCount += 1
        if State.WarnedCount > Config.WarnMemory then
            table.clear(State.Warned)
            State.WarnedCount = 1
        end
    end
    State.Warned[stamp] = now
    warn("[LootToForge]", key, err)
end

function Jeaneism.Util.Try(fn, ...)
    local ok, err = pcall(fn, ...)
    if not ok then
        warn("[LootToForge]", err)
    end
    return ok, err
end

function Jeaneism.Util.Tier(id)
    return tonumber(tostring(id):match("%d+")) or 0
end

function Jeaneism.Util.Abbreviate(number)
    local units = { "", "K", "M", "B", "T", "Qa", "Qi", "Sx", "Sp" }
    local index = 1
    while number >= 1000 and index < #units do
        number /= 1000
        index += 1
    end
    return (index == 1 and "%d%s" or "%.2f%s"):format(number, units[index])
end

function Jeaneism.Util.HighestKey(configTable)
    local bestKey, bestTier = nil, -1
    for key in pairs(configTable) do
        local tier = Jeaneism.Util.Tier(key)
        if tier > bestTier then
            bestKey, bestTier = key, tier
        end
    end
    return bestKey
end

function Jeaneism.Util.WaitAll(workers, job)
    local pending = workers
    for _ = 1, workers do
        task.spawn(function()
            Jeaneism.Util.Try(job)
            pending -= 1
        end)
    end
    local deadline = os.clock() + Config.RemoteTimeout * 3
    while pending > 0 and os.clock() < deadline do
        task.wait(0.1)
    end
end

function Jeaneism.Util.RarityNames()
    local helper = Jeaneism.GameLib.Api(GameConfig.Rarity.Helper)
    local names = {}
    for level = 1, 20 do
        local name = helper.GetRarityByLevel(level)
        if not name then break end
        table.insert(names, name)
    end
    return names
end

function Jeaneism.Util.AllSet(list)
    local set = {}
    for _, name in ipairs(list) do
        set[name] = true
    end
    return set
end

---@param name string  shown in status while it runs
---@return boolean     false if another long job holds the character
function Jeaneism.Util.Exclusive(name, fn, ...)
    if State.Lock then return false end
    State.Lock = name
    local ok, result = Jeaneism.Util.Try(fn, ...)
    State.Lock = nil
    return ok, result
end

function Jeaneism.Data.Get()
    State.Profile = Jeaneism.Util.Remote("Profile", "GetTotalDataRF"):InvokeServer()
    return State.Profile
end

function Jeaneism.Data.Count(profile, itemId)
    local total = 0
    for _, entry in pairs(profile.Backpack.have) do
        if entry.ID == itemId then
            total += entry.Number or 1
        end
    end
    return total
end

function Jeaneism.Data.Uuid(profile, itemId)
    for uuid, entry in pairs(profile.Backpack.have) do
        if entry.ID == itemId and (entry.Number or 0) >= 1 then
            return uuid
        end
    end
    return nil
end

function Jeaneism.Data.Snapshot()
    local seen = {}
    for uuid in pairs(Jeaneism.Data.Get().Backpack.have) do
        seen[uuid] = true
    end
    return seen
end

---@return table  { [uuid] = entry } gear that appeared after the snapshot
function Jeaneism.Data.NewGear(before)
    local fresh = {}
    for uuid, entry in pairs(Jeaneism.Data.Get().Backpack.have) do
        if not before[uuid] and entry.Type ~= "Ore" and entry.Type ~= "Material" and entry.Type ~= "EnchStone" then
            fresh[uuid] = entry
        end
    end
    return fresh
end

function Jeaneism.Ore.Rarity(oreId)
    local oreConfig = Jeaneism.GameLib.Need(GameConfig.Ore.Config)[oreId]
    return oreConfig and Jeaneism.GameLib.Api(GameConfig.Rarity.Helper).GetRarityByLevel(oreConfig.Rarity)
end

function Jeaneism.Ore.Owned(profile)
    local ores = {}
    for uuid, entry in pairs(profile.Backpack.have) do
        if entry.Type == "Ore" and (entry.Number or 0) >= 1 then
            table.insert(ores, {
                uuid = uuid,
                id = entry.ID,
                tier = Jeaneism.Util.Tier(entry.ID),
                number = math.floor(entry.Number),
                rarity = Jeaneism.Ore.Rarity(entry.ID),
            })
        end
    end
    table.sort(ores, function(a, b) return a.tier > b.tier end)
    return ores
end

function Jeaneism.Ore.Ids()
    local ids = {}
    for oreId in pairs(Jeaneism.GameLib.Need(GameConfig.Ore.Config)) do
        table.insert(ids, oreId)
    end
    table.sort(ids, function(a, b) return Jeaneism.Util.Tier(a) > Jeaneism.Util.Tier(b) end)
    return ids
end

function Jeaneism.Ore.Choices()
    local oreShow = Jeaneism.GameLib.Need(GameConfig.Ore.Show)
    local labels, idByLabel = {}, {}
    for _, oreId in ipairs(Jeaneism.Ore.Ids()) do
        local label = ("%s (%s)"):format(oreShow[oreId] and oreShow[oreId].DisplayName or oreId, Jeaneism.Ore.Rarity(oreId) or "?")
        if idByLabel[label] then
            label = ("%s #%d"):format(label, Jeaneism.Util.Tier(oreId))
        end
        idByLabel[label] = oreId
        table.insert(labels, label)
    end
    State.OreLabels = idByLabel
    return labels
end

function Jeaneism.Ore.ForgeChoices()
    local labels = Jeaneism.Ore.Choices()
    table.insert(labels, 1, Config.OwnedOresLabel)
    return labels
end

function Jeaneism.Ore.Add(uuid, amount)
    Jeaneism.Util.Remote("Backpack", "TrySellItemRE"):FireServer(uuid, -math.abs(amount))
end

---@param need number  how many must be in the stack afterwards
---@return string?     stack uuid, nil if the ore never dropped
function Jeaneism.Ore.Ensure(oreId, need)
    local profile = Jeaneism.Data.Get()
    local uuid = Jeaneism.Data.Uuid(profile, oreId)
    if not uuid then
        if not Jeaneism.Stage.AcquireOre(oreId) then return nil end
        task.wait(0.4)
        profile = Jeaneism.Data.Get()
        uuid = Jeaneism.Data.Uuid(profile, oreId)
    end
    if uuid and Jeaneism.Data.Count(profile, oreId) < need then
        Jeaneism.Ore.Add(uuid, math.max(Config.RefillAmount, need))
        task.wait(0.4)
    end
    return uuid
end

function Jeaneism.Ore.Top(minimum)
    local top = Jeaneism.Ore.Owned(Jeaneism.Data.Get())[1]
    if not top then
        Jeaneism.Stage.Collect(Jeaneism.Stage.Best(), nil)
        top = Jeaneism.Ore.Owned(Jeaneism.Data.Get())[1]
    end
    if top and top.number < minimum then
        Jeaneism.Ore.Add(top.uuid, Config.RefillAmount)
        task.wait(0.4)
    end
    return top
end

function Jeaneism.Spawn.Choices()
    local labels, byLabel = Jeaneism.Ore.Choices(), {}
    for label, oreId in pairs(State.OreLabels) do
        byLabel[label] = { id = oreId, kind = "Ore" }
    end
    local stoneShow = Jeaneism.GameLib.Need(GameConfig.EnchStone.Show)
    local stones = {}
    for stoneId in pairs(stoneShow) do
        table.insert(stones, stoneId)
    end
    table.sort(stones, function(a, b)
        local ta, tb = Jeaneism.Util.Tier(a), Jeaneism.Util.Tier(b)
        if ta ~= tb then return ta > tb end
        return a < b
    end)
    for _, stoneId in ipairs(stones) do
        local label = stoneShow[stoneId].DisplayName or stoneId
        byLabel[label] = { id = stoneId, kind = "EnchStone" }
        table.insert(labels, label)
    end
    local materialModule = Jeaneism.GameLib.Find("Config.Material.Show")
    local materialShow = materialModule and Jeaneism.GameLib.Require(materialModule)
    if type(materialShow) == "table" then
        local materials = {}
        for materialId, show in pairs(materialShow) do
            table.insert(materials, { materialId, show.DisplayName or materialId })
        end
        table.sort(materials, function(a, b) return a[2] < b[2] end)
        for i, entry in ipairs(materials) do
            byLabel[entry[2]] = { id = entry[1], kind = "Material" }
            table.insert(labels, i, entry[2])
        end
    end
    State.SpawnLabels = byLabel
    return labels
end

---@param counts table<string, number>  uuid -> amount to add
function Jeaneism.Spawn.Stack(counts)
    local list = {}
    for uuid, amount in pairs(counts) do
        list[uuid] = -math.abs(amount)
    end
    Jeaneism.Util.Remote("Forge", "ForgeRF"):InvokeServer({ ConfigType = "Weapon", UUIDList = list })
end

---@return boolean  false if the item was never owned and can't be found
function Jeaneism.Spawn.Give(itemId, kind, amount)
    if kind == "Ore" then
        local uuid = Jeaneism.Ore.Ensure(itemId, 0)
        if not uuid then return false end
        Jeaneism.Ore.Add(uuid, amount)
        return true
    end
    local uuid = Jeaneism.Data.Uuid(Jeaneism.Data.Get(), itemId)
    if not uuid then return false end
    if kind == "Material" then
        Jeaneism.Spawn.Stack({ [uuid] = amount })
    else
        Jeaneism.Ore.Add(uuid, amount)
    end
    return true
end

---@return string[]  potion ids you own at least once (the rest can't be added)
function Jeaneism.Potion.Owned()
    local owned = {}
    local stock = Jeaneism.Data.Get().Potion or {}
    for potionId in pairs(Jeaneism.GameLib.Need(GameConfig.Potion.Config)) do
        if stock[potionId] ~= nil then table.insert(owned, potionId) end
    end
    table.sort(owned)
    return owned
end

function Jeaneism.Potion.Add(potionId, amount)
    Jeaneism.Util.Remote("Potion", "TryUsePotionRE"):FireServer(potionId, -math.abs(amount))
end

---@return number  potions boosted for about a year each
function Jeaneism.Potion.MaxBuffs()
    local use = Jeaneism.Util.Remote("Potion", "TryUsePotionRE")
    local owned = Jeaneism.Potion.Owned()
    for _, potionId in ipairs(owned) do
        Jeaneism.Potion.Add(potionId, Config.PotionStack)
        use:FireServer(potionId, Config.PotionStack)
    end
    return #owned
end

---@return number  stacks touched
function Jeaneism.Spawn.DupeAll(amount)
    local materials, touched = {}, 0
    for uuid, entry in pairs(Jeaneism.Data.Get().Backpack.have) do
        if type(entry) ~= "table" or not entry.Number then continue end
        touched += 1
        if entry.Type == "Material" then
            materials[uuid] = amount
        else
            Jeaneism.Ore.Add(uuid, amount)
        end
    end
    if next(materials) then Jeaneism.Spawn.Stack(materials) end
    return touched
end

function Jeaneism.Stage.List()
    local stages = {}
    for stageId in pairs(Jeaneism.GameLib.Api(GameConfig.Stage.Helper).GetStageEnemyConfig()) do
        table.insert(stages, stageId)
    end
    table.sort(stages, function(a, b) return Jeaneism.Util.Tier(a) > Jeaneism.Util.Tier(b) end)
    return stages
end

function Jeaneism.Stage.Best()
    return Jeaneism.Stage.List()[1]
end

-- Keep failed/unclaimed batches so retries never open a new stage over pending loot.
function Jeaneism.Stage.Collect(stageId, rarities, keepRunning)
    local function active()
        return State.Alive and (not keepRunning or keepRunning())
    end
    while State.CollectBusy do
        if not active() then return end
        task.wait(0.01)
    end
    if not active() or not stageId then return end
    State.CollectBusy = true
    local ok, result = pcall(function()
        local batch = State.OreBatch
        if not batch then
            local drops = Jeaneism.Util.Remote("Stage", "StageFinishedRF"):InvokeServer(stageId)
            if type(drops) ~= "table" then error("Stage did not return a loot batch", 0) end
            batch = {stage=stageId, ores={}, stones={}, done={}}
            for uuid, drop in pairs(drops) do
                if type(drop) == "table" then
                    table.insert(batch.stones, uuid)
                elseif not rarities or rarities[Jeaneism.Ore.Rarity(drop)] then
                    table.insert(batch.ores, uuid)
                end
            end
            State.OreBatch = batch
        end
        if not active() then return end
        if #batch.stones > 0 then
            local pickStone = Jeaneism.Util.Remote("Stage", "GetEnhantStoneRE")
            for _, uuid in ipairs(batch.stones) do
                if not active() then return end
                if not batch.done[uuid] then
                    pickStone:FireServer(uuid)
                    batch.done[uuid] = true
                end
            end
        end
        local ores = {}
        for _, uuid in ipairs(batch.ores) do
            if not batch.done[uuid] then table.insert(ores, uuid) end
        end
        if #ores > 0 then
            local pickOre = Jeaneism.Util.Remote("Stage", "GetOreRF")
            local workers = math.min(#ores, math.clamp(math.floor(tonumber(State.Opt.FarmWorkers) or 24), 1, 32))
            local nextOre, pending, failure = 1, workers, nil
            for _ = 1, workers do
                task.spawn(function()
                    local worked, err = pcall(function()
                        while active() do
                            local index = nextOre
                            nextOre += 1
                            if index > #ores then break end
                            local uuid = ores[index]
                            local lastError
                            for attempt = 1, 3 do
                                if not active() then break end
                                local accepted, response = pcall(pickOre.InvokeServer, pickOre, uuid)
                                if accepted and response ~= false then
                                    batch.done[uuid] = true
                                    lastError = nil
                                    break
                                end
                                lastError = accepted and "Ore pickup was rejected" or response
                                if attempt < 3 and active() then task.wait(0.04 * attempt) end
                            end
                            if lastError then failure = failure or lastError end
                        end
                    end)
                    if not worked then failure = failure or err end
                    pending -= 1
                end)
            end
            -- Wait for in-flight requests even after disable; no overlapping batches.
            while pending > 0 do task.wait(0.001) end
            if failure then error(failure, 0) end
        end
        if not active() then return end
        -- Failed pickups never reach this claim; the next call resumes their UUIDs.
        Jeaneism.Util.Remote("Stage", "ClaimedAllOreRE"):FireServer()
        State.OreBatch = nil
    end)
    State.CollectBusy = false
    if not ok then error(result, 0) end
end

function Jeaneism.Stage.StartCollecting()
    Jeaneism.Scheduler.StartLoop("CollectOre", function()
        if State.Lock then return end
        local ok, err = Jeaneism.Util.Exclusive("Farm", function()
            Jeaneism.Stage.Collect(State.Opt.Stage or Jeaneism.Stage.Best(),
                not State.Opt.FarmAllOres and State.Opt.CollectRarities or nil,
                function() return State.Opt.CollectOre end)
        end)
        if not ok and err ~= nil then error(err, 0) end
    end, function() return 0.04 end)
end

function Jeaneism.Stage.FarmStones(stageId)
    if State.OreBatch then Jeaneism.Stage.Collect(stageId, nil) end
    local finished = Jeaneism.Util.Remote("Stage", "StageFinishedRF")
    local pickStone = Jeaneism.Util.Remote("Stage", "GetEnhantStoneRE")
    Jeaneism.Util.WaitAll(Config.StoneWorkers, function()
        for _ = 1, Config.StoneCallsPerWorker do
            local drops = finished:InvokeServer(stageId)
            for uuid, drop in pairs(type(drops) == "table" and drops or {}) do
                if type(drop) == "table" then
                    pickStone:FireServer(uuid)
                end
            end
        end
    end)
end

function Jeaneism.Stage.AcquireOre(oreId)
    local stages = Jeaneism.Stage.List()
    local known = State.OreStage[oreId]
    local target = Jeaneism.Util.Tier(oreId) * #stages / Jeaneism.Util.Tier(Jeaneism.Util.HighestKey(Jeaneism.GameLib.Need(GameConfig.Ore.Config)))
    table.sort(stages, function(a, b)
        if a == known or b == known then return a == known end
        return math.abs(Jeaneism.Util.Tier(a) - target) < math.abs(Jeaneism.Util.Tier(b) - target)
    end)

    local finished = Jeaneism.Util.Remote("Stage", "StageFinishedRF")
    local pickOre = Jeaneism.Util.Remote("Stage", "GetOreRF")
    for round = 1, Config.AcquireRounds do
        local stageId = stages[(round - 1) % math.min(#stages, 4) + 1]
        local drops = finished:InvokeServer(stageId)
        for uuid, drop in pairs(type(drops) == "table" and drops or {}) do
            if drop == oreId and pickOre:InvokeServer(uuid) then
                Jeaneism.Util.Remote("Stage", "ClaimedAllOreRE"):FireServer()
                State.OreStage[oreId] = stageId
                return true
            end
        end
    end
    return false
end

function Jeaneism.Stage.ExitFight()
    Jeaneism.GameLib.Api(LocalPlayer.PlayerScripts.Manager.StageManager.StageUtils).ExitFight(true)
end

function Jeaneism.Forge.Target()
    for _, target in ipairs(Config.ForgeTargets) do
        if target.name == State.Opt.ForgeTarget then
            return target
        end
    end
    return Config.ForgeTargets[1]
end

function Jeaneism.Forge.Run(forgeType, oreList)
    return Jeaneism.Util.Remote("Forge", "ForgeRF"):InvokeServer({ ConfigType = forgeType, UUIDList = oreList })
end

function Jeaneism.Forge.PickOwned(profile, count)
    local opt = State.Opt
    local candidates = {}
    for _, ore in ipairs(Jeaneism.Ore.Owned(profile)) do
        local spare = ore.number - opt.KeepPerOre
        if opt.ForgeRarities[ore.rarity] and spare > 0 then
            ore.spare = spare
            table.insert(candidates, ore)
        end
    end
    if not opt.BestOreFirst then
        table.sort(candidates, function(a, b) return a.tier < b.tier end)
    end

    local pick, need = {}, count
    for _, ore in ipairs(candidates) do
        if need <= 0 then break end
        local take = math.min(need, ore.spare)
        pick[ore.uuid] = take
        need -= take
    end
    return need <= 0 and pick or nil
end

---@return table?  { [uuid] = count }, nil when no ore fits
function Jeaneism.Forge.Pick(count)
    local oreId = State.OreLabels[State.Opt.ForgeOre]
    if not oreId then
        return Jeaneism.Forge.PickOwned(Jeaneism.Data.Get(), count)
    end
    local uuid = Jeaneism.Ore.Ensure(oreId, count * State.Opt.ForgePerTick)
    return uuid and { [uuid] = count }
end

function Jeaneism.Forge.Once()
    local target = Jeaneism.Forge.Target()
    local pick = Jeaneism.Forge.Pick(target.ores)
    if not pick then return false end
    local result = Jeaneism.Forge.Run(target.forgeType, pick)
    return result ~= nil and result ~= false
end

function Jeaneism.Forge.Burst()
    local target = Jeaneism.Forge.Target()
    local perTick = State.Opt.ForgePerTick
    local pick = Jeaneism.Forge.Pick(target.ores * perTick)
    if not pick then return 0 end
    local completed = 0
    local uuid = next(pick)
    if next(pick, uuid) == nil then
        for _ = 1, perTick do
            local result = Jeaneism.Forge.Run(target.forgeType, { [uuid] = target.ores })
            if result ~= nil and result ~= false then completed += 1 end
        end
        return completed
    end
    for _ = 1, perTick do
        if not Jeaneism.Forge.Once() then break end
        completed += 1
    end
    return completed
end

function Jeaneism.Forge.Step()
    if not State.Opt.ForgeSellJunk then return Jeaneism.Forge.Burst() end
    local before = Jeaneism.Data.Snapshot()
    local completed = Jeaneism.Forge.Burst()
    local fresh = Jeaneism.Data.NewGear(before)
    local profile = State.Profile
    local keep = {}
    for uuid, entry in pairs(fresh) do
        local worn = profile.Backpack.equiped[entry.Type]
        local wornEntry = worn and profile.Backpack.have[worn]
        if not wornEntry or Jeaneism.Gear.Score(entry, true) > Jeaneism.Gear.Score(wornEntry, true) then
            keep[uuid] = true
        end
    end
    Jeaneism.Sell.Fresh(fresh, keep)
    return completed
end

function Jeaneism.Sell.Rarity(entry)
    local folder = entry.Type == "Weapon" and "Weapon" or "Armor"
    local itemConfig = Jeaneism.GameLib.Need(GameConfig[folder].Config)[entry.ID]
    return itemConfig and itemConfig.Rarity
end

---@return table<string, boolean>  uuids of the strongest normal piece per slot, which exclusive gear takes its power from
function Jeaneism.Sell.Anchors(profile)
    local anchors, bestPower = {}, {}
    for uuid, entry in pairs(profile.Backpack.have) do
        if not (entry.Type == "Weapon" or entry.Type == "Armor" or entry.Type == "Hat") then continue end
        local helper = Jeaneism.GameLib.Api(entry.Type == "Weapon" and GameConfig.Weapon.Helper or GameConfig.Armor.Helper)
        local ok, percent = pcall(helper.CheckIsBestPercent, entry.ID)
        if not ok or percent then continue end
        local powerOk, power = pcall(helper.GetMainAffix, entry.ID)
        if powerOk and type(power) == "number" and power > (bestPower[entry.Type] or 0) then
            bestPower[entry.Type] = power
            anchors[entry.Type] = uuid
        end
    end
    local keep = {}
    for _, uuid in pairs(anchors) do
        keep[uuid] = true
    end
    local backpack = Jeaneism.GameLib.Require(ReplicatedStorage.LocalData.BackpackData)
    if type(backpack) == "table" and type(backpack.IsLocked) == "function" then
        for uuid in pairs(profile.Backpack.have) do
            local ok, locked = pcall(backpack.IsLocked, uuid)
            if ok and locked then keep[uuid] = true end
        end
    end
    return keep
end

function Jeaneism.Sell.Run(profile)
    local opt = State.Opt
    local equipped = Jeaneism.Sell.Anchors(profile)
    for _, uuid in pairs(profile.Backpack.equiped) do
        equipped[uuid] = true
    end

    local byId = {}
    for uuid, entry in pairs(profile.Backpack.have) do
        if opt.SellTypes[entry.Type] and not equipped[uuid] then
            byId[entry.ID] = byId[entry.ID] or {}
            table.insert(byId[entry.ID], { uuid = uuid, entry = entry })
        end
    end

    local sell = Jeaneism.Util.Remote("Backpack", "TrySellItemRE")
    for _, items in pairs(byId) do
        table.sort(items, function(a, b) return (a.entry.Level or 0) > (b.entry.Level or 0) end)
        for index, gear in ipairs(items) do
            if index > opt.KeepPerItem and opt.SellRarities[Jeaneism.Sell.Rarity(gear.entry)] then
                sell:FireServer(gear.uuid, 1)
            end
        end
    end
end

---@param keep table?  { [uuid] = true } never sold
function Jeaneism.Sell.Fresh(fresh, keep)
    local equipped = Jeaneism.Sell.Anchors(State.Profile)
    for _, uuid in pairs(State.Profile.Backpack.equiped) do
        equipped[uuid] = true
    end
    local sell = Jeaneism.Util.Remote("Backpack", "TrySellItemRE")
    for uuid in pairs(fresh) do
        if not equipped[uuid] and not (keep and keep[uuid]) then
            sell:FireServer(uuid, 1)
        end
    end
end

---@param atTarget boolean?  score as if enhanced to the target, so exclusive gear isn't skipped for a higher-level common piece
---@return number           power from the game's own formula
function Jeaneism.Gear.Score(entry, atTarget)
    local balance = Jeaneism.GameLib.Api(ReplicatedStorage.Utils.BalanceUtils)
    local backpack = (State.Profile or Jeaneism.Data.Get()).Backpack
    local potential = table.clone(entry)
    if atTarget then potential.Level = math.max(entry.Level or 0, State.Opt.EnhanceTarget) end
    local value = entry.Type == "Weapon" and balance.GetWeaponTrainValue or balance.GetArmorValue
    local ok, power = pcall(value, LocalPlayer, potential, backpack)
    if not ok or type(power) ~= "number" then return 0 end
    return power * (1 + (entry.Level or 0) * 1e-6 + #(entry.EnchanceList or {}) * 1e-9)
end

function Jeaneism.Gear.BestOwned(profile, slot, atTarget)
    local bestUuid, bestScore = nil, -1
    for uuid, entry in pairs(profile.Backpack.have) do
        if entry.Type == slot then
            local score = Jeaneism.Gear.Score(entry, atTarget)
            if score > bestScore then
                bestUuid, bestScore = uuid, score
            end
        end
    end
    return bestUuid, bestScore
end

---@return number  slots changed
function Jeaneism.Gear.EquipBest()
    local profile = Jeaneism.Data.Get()
    local equip = Jeaneism.Util.Remote("Backpack", "TryEquipItemRE")
    local changed = 0
    local atTarget = State.Opt.MaxGear and State.Opt.GearEnhance
    for _, slot in ipairs(Config.GearTypes) do
        local best, bestScore = Jeaneism.Gear.BestOwned(profile, slot, atTarget)
        local current = profile.Backpack.equiped[slot]
        local currentEntry = current and profile.Backpack.have[current]
        if best and best ~= current and bestScore > (currentEntry and Jeaneism.Gear.Score(currentEntry, atTarget) or -1) then
            equip:FireServer(best, slot)
            changed += 1
        end
    end
    return changed
end

function Jeaneism.Gear.ForgeBest()
    local before = Jeaneism.Data.Snapshot()
    for _, spec in ipairs(Config.GearSlots) do
        local top = Jeaneism.Ore.Top(spec.ores * Config.GearForgeTries)
        if top then
            for _ = 1, Config.GearForgeTries do
                Jeaneism.Forge.Run(spec.forgeType, { [top.uuid] = spec.ores })
            end
        end
        local best = Jeaneism.Gear.BestOwned(Jeaneism.Data.Get(), spec.slot, true)
        if best then
            Jeaneism.Util.Remote("Backpack", "TryEquipItemRE"):FireServer(best, spec.slot)
        end
    end
    task.wait(1)
    Jeaneism.Sell.Fresh(Jeaneism.Data.NewGear(before))
end

function Jeaneism.Gear.MissingForEnhance(profile, level)
    local cost = Jeaneism.GameLib.Need(GameConfig.Enhant.Config)[level + 1]
    if not cost then return nil end
    if Jeaneism.Data.Count(profile, "EnhantStone_2") < (cost.EnhantStone_2 or 0) then return "EnhantStone_2" end
    if Jeaneism.Data.Count(profile, "EnhantStone_1") < (cost.EnhantStone_1 or 0) then return "EnhantStone_1" end
    if profile.Eco.coin < (cost.NeedCoin or 0) then return "Coin" end
    return nil
end

function Jeaneism.Gear.Gather(missing)
    State.GearNote = missing
    if missing == "Coin" then
        Jeaneism.Forge.Step()
        Jeaneism.Sell.Run(Jeaneism.Data.Get())
    elseif missing == "EnhantStone_1" then
        Jeaneism.Stage.FarmStones(Jeaneism.Stage.Best())
    elseif not Jeaneism.Tower.FarmStep() then
        State.GearNote = "NoTicket"
    end
end

---@return string[]  every rune the game has from RuneMinTier up, strongest tier first
function Jeaneism.Gear.RuneOrder()
    if State.Runes then return State.Runes end
    local show = Jeaneism.GameLib.Find("Config.EnchStone.Show")
    local stones = show and Jeaneism.GameLib.Require(show)
    if not stones then return Config.EnchantPriority end

    local known = {}
    for index, stoneId in ipairs(Config.EnchantPriority) do
        known[stoneId] = index
    end
    local runes = {}
    for stoneId in pairs(stones) do
        if Jeaneism.Util.Tier(stoneId) >= Config.RuneMinTier then runes[#runes + 1] = stoneId end
    end
    table.sort(runes, function(a, b)
        local ta, tb = Jeaneism.Util.Tier(a), Jeaneism.Util.Tier(b)
        if ta ~= tb then return ta > tb end
        local ka, kb = known[a] or math.huge, known[b] or math.huge
        if ka ~= kb then return ka < kb end
        return a < b
    end)
    State.Runes = runes
    return runes
end

function Jeaneism.Gear.Priority()
    return #State.Opt.EnchantPriority > 0 and State.Opt.EnchantPriority or Jeaneism.Gear.RuneOrder()
end

function Jeaneism.Gear.StockEnchants(profile)
    for _, stoneId in ipairs(Jeaneism.Gear.Priority()) do
        local uuid = Jeaneism.Data.Uuid(profile, stoneId)
        if uuid and Jeaneism.Data.Count(profile, stoneId) < Config.EnchantRefill then
            Jeaneism.Ore.Add(uuid, Config.EnchantRefill)
        end
    end
end

function Jeaneism.Gear.Enchant(profile, uuid)
    local entry = profile.Backpack.have[uuid]
    local used = {}
    for slot = 1, entry.EnchanceNum or 0 do
        local current = entry.EnchanceList and entry.EnchanceList[slot]
        local currentId = current and current.ID
        local wanted
        for _, stoneId in ipairs(Jeaneism.Gear.Priority()) do
            if not used[stoneId] and (stoneId == currentId or Jeaneism.Data.Count(profile, stoneId) > 0) then
                wanted = stoneId
                break
            end
        end
        if wanted then
            used[wanted] = true
            if wanted ~= currentId then
                if currentId then
                    Jeaneism.Util.Remote("Backpack", "UnEnchantRE"):FireServer(uuid, slot)
                    task.wait(0.3)
                end
                Jeaneism.Util.Remote("Backpack", "EnchantRE"):FireServer(uuid, Jeaneism.Data.Uuid(profile, wanted), slot)
                task.wait(0.3)
            end
        end
    end
end

function Jeaneism.Gear.Enhance(profile)
    local target = math.min(State.Opt.EnhanceTarget, Jeaneism.Util.Tier(Jeaneism.Util.HighestKey(Jeaneism.GameLib.Need(GameConfig.Enhant.Config))))
    local enhance = Jeaneism.Util.Remote("Backpack", "EnhantEquipmentRF")
    for _, spec in ipairs(Config.GearSlots) do
        local uuid = profile.Backpack.equiped[spec.slot]
        local entry = uuid and profile.Backpack.have[uuid]
        if entry and (entry.Level or 0) < target then
            local missing = Jeaneism.Gear.MissingForEnhance(profile, entry.Level or 0)
            if missing then
                Jeaneism.Gear.Gather(missing)
                return false
            end
            State.GearNote = "Enhancing"
            local useProtect = Jeaneism.Data.Count(profile, "EnhantProtect") > 0 and (entry.Level or 0) >= Jeaneism.GameLib.Api(GameConfig.Enhant.Helper).GetFailLevel()
            Jeaneism.Util.WaitAll(Config.GearEnhanceWorkers, function()
                for _ = 1, Config.GearEnhanceTries do
                    if not enhance:InvokeServer(uuid, { UseProtect = useProtect }) then return end
                end
            end)
            return false
        end
    end
    return true
end

function Jeaneism.Gear.MaxStep()
    local opt = State.Opt
    if opt.GearForge and not State.GearForged then
        Jeaneism.Gear.ForgeBest()
        State.GearForged = true
    end
    if opt.GearEnchant then
        local profile = Jeaneism.Data.Get()
        Jeaneism.Gear.StockEnchants(profile)
        profile = Jeaneism.Data.Get()
        for _, spec in ipairs(Config.GearSlots) do
            local uuid = profile.Backpack.equiped[spec.slot]
            if uuid then Jeaneism.Gear.Enchant(profile, uuid) end
        end
    end
    if not opt.GearEnhance or Jeaneism.Gear.Enhance(Jeaneism.Data.Get()) then
        State.GearNote = "Done"
    end
end

---@return number?  level reached, nil if nothing equipped there
function Jeaneism.Gear.EnhanceSlot(slot, target)
    local enhance = Jeaneism.Util.Remote("Backpack", "EnhantEquipmentRF")
    local failLevel = Jeaneism.GameLib.Api(GameConfig.Enhant.Helper).GetFailLevel()
    local level = 0
    for _ = 1, Config.SlotEnhanceRounds do
        local profile = Jeaneism.Data.Get()
        local uuid = profile.Backpack.equiped[slot]
        local entry = uuid and profile.Backpack.have[uuid]
        if not entry then return nil end
        level = entry.Level or 0
        if level >= target then return level end
        local missing = Jeaneism.Gear.MissingForEnhance(profile, level)
        if missing == "EnhantStone_1" then
            Jeaneism.Stage.FarmStones(Jeaneism.Stage.Best())
        elseif missing then
            return level
        else
            enhance:InvokeServer(uuid, { UseProtect = level >= failLevel and Jeaneism.Data.Count(profile, "EnhantProtect") > 0 })
        end
    end
    return level
end

function Jeaneism.Gear.EquippedNames(profile)
    local names = {}
    for _, spec in ipairs(Config.GearSlots) do
        local uuid = profile.Backpack.equiped[spec.slot]
        local entry = uuid and profile.Backpack.have[uuid]
        if entry then
            local shows = Jeaneism.GameLib.Require(GameConfig[entry.Type == "Weapon" and "Weapon" or "Armor"].Show)
            local show = shows and shows[entry.ID]
            table.insert(names, ("%s +%d"):format(show and show.DisplayName or entry.ID, entry.Level or 0))
        end
    end
    return table.concat(names, " · ")
end

function Jeaneism.Index.GearCatalog()
    local gear = {}
    local armorHelper = Jeaneism.GameLib.Api(GameConfig.Armor.Helper)
    for weaponId, weapon in pairs(Jeaneism.GameLib.Need(GameConfig.Weapon.Config)) do
        table.insert(gear, { id = weaponId, slot = "Weapon", forgeType = "Weapon", forgeable = weapon.TLevel ~= nil })
    end
    for armorId, armor in pairs(Jeaneism.GameLib.Need(GameConfig.Armor.Config)) do
        table.insert(gear, { id = armorId, slot = armorHelper.GetBigType(armorId) or "Armor", forgeType = "Armor", forgeable = armor.TLevel ~= nil })
    end
    return gear
end

---@return table[]  gear the index still lacks, filtered by IndexTypes
function Jeaneism.Index.Missing()
    local unlocked = Jeaneism.Data.Get().Index.unlocked
    local missing = {}
    for _, gear in ipairs(Jeaneism.Index.GearCatalog()) do
        if State.Opt.IndexTypes[gear.slot] and not unlocked[gear.slot .. "-" .. gear.id] then
            table.insert(missing, gear)
        end
    end
    table.sort(missing, function(a, b)
        if a.forgeable ~= b.forgeable then return a.forgeable end
        return a.id < b.id
    end)
    return missing
end

---@return number, string?, number?  chance per forge, ore id, ore count
function Jeaneism.Index.Plan(gear)
    local cached = State.Plans[gear.id]
    if cached then return cached[1], cached[2], cached[3] end

    local forgeUtils = Jeaneism.GameLib.Api(ReplicatedStorage.Utils.ForgeUtils)
    local helper = Jeaneism.GameLib.Api(gear.forgeType == "Weapon" and GameConfig.Weapon.Helper or GameConfig.Armor.Helper)
    local bestChance, bestOre, bestCount = 0, nil, nil
    local sliceStart = os.clock()
    for count = 1, Config.ForgeCountMax do
        local split = helper.GetForgePercentByNumber(count)
        if not split then continue end
        for _, oreId in ipairs(Jeaneism.Ore.Ids()) do
            if os.clock() - sliceStart > Config.PlanSlice then
                task.wait()
                sliceStart = os.clock()
            end
            local list = { [oreId] = count }
            local ok, chance = pcall(function()
                local low, high = forgeUtils.GetForgeOreResult(list)
                local power = forgeUtils.GetOreAvgPower(list)
                local total = 0
                for subType, share in pairs(split) do
                    if share > 0 then
                        total += share * (forgeUtils.GetEquPercent(gear.forgeType, count, low, high, power, subType)[gear.id] or 0)
                    end
                end
                return total
            end)
            if ok and chance > bestChance then
                bestChance, bestOre, bestCount = chance, oreId, count
            end
        end
    end
    State.Plans[gear.id] = { bestChance, bestOre, bestCount }
    return bestChance, bestOre, bestCount
end

function Jeaneism.Index.Label(gear)
    local show = Jeaneism.GameLib.Need(GameConfig[gear.forgeType].Show)[gear.id]
    local name = ("%s [%s]"):format(show and show.DisplayName or gear.id, gear.slot)
    if not gear.forgeable then return name .. " - event" end
    local chance = Jeaneism.Index.Plan(gear)
    return chance > 0 and ("%s - %.2f%%"):format(name, chance * 100) or name .. " - no recipe"
end

function Jeaneism.Index.Choices()
    local labels, byLabel = {}, {}
    for _, gear in ipairs(Jeaneism.Index.Missing()) do
        local label = Jeaneism.Index.Label(gear)
        byLabel[label] = gear
        table.insert(labels, label)
    end
    State.MissingLabels = byLabel
    return labels
end

---@param copies number?  keep forging until this many new copies, ignoring the index
---@return boolean        true once the index has it, or all copies were made
function Jeaneism.Index.Hunt(gear, copies)
    local chance, oreId, count = Jeaneism.Index.Plan(gear)
    if chance <= 0 then return false end
    local budget = math.min(Config.HuntMaxForges * (copies or 1), math.ceil(Config.HuntTargetHits * (copies or 1) / chance))
    local key = gear.slot .. "-" .. gear.id
    local forged, got = 0, 0
    while forged < budget and State.Alive do
        local uuid = Jeaneism.Ore.Ensure(oreId, count * Config.HuntBatch)
        if not uuid then return false end
        local before = Jeaneism.Data.Snapshot()
        local perWorker = math.ceil(Config.HuntBatch / Config.HuntWorkers)
        Jeaneism.Util.WaitAll(Config.HuntWorkers, function()
            for _ = 1, perWorker do
                Jeaneism.Forge.Run(gear.forgeType, { [uuid] = count })
            end
        end)
        forged += perWorker * Config.HuntWorkers
        State.IndexNote = ("%s %d/%d"):format(gear.id, forged, budget)
        local fresh = Jeaneism.Data.NewGear(before)
        local keep = {}
        for freshUuid, entry in pairs(fresh) do
            if entry.ID == gear.id and (not copies or got < copies) then
                keep[freshUuid] = true
                got += 1
            end
        end
        Jeaneism.Sell.Fresh(fresh, keep)
        if copies then
            State.IndexNote = ("%s %d/%d"):format(gear.id, got, copies)
            if got >= copies then return true end
        elseif State.Profile.Index.unlocked[key] or next(keep) then
            return true
        end
    end
    return false
end

---@param slot string  "Weapon", "Armor" or "Hat"
---@return string[]    every forgeable piece of that slot, strongest first
function Jeaneism.Spawn.GearChoices(slot)
    local labels, byLabel, list = {}, {}, {}
    for _, gear in ipairs(Jeaneism.Index.GearCatalog()) do
        if not gear.forgeable or gear.slot ~= slot then continue end
        local helper = Jeaneism.GameLib.Api(gear.forgeType == "Weapon" and GameConfig.Weapon.Helper or GameConfig.Armor.Helper)
        local ok, power = pcall(helper.GetMainAffix, gear.id)
        table.insert(list, { gear, ok and tonumber(power) or 0 })
    end
    table.sort(list, function(a, b) return a[2] > b[2] end)
    for _, pair in ipairs(list) do
        local label = Jeaneism.Index.Label(pair[1])
        byLabel[label] = pair[1]
        table.insert(labels, label)
    end
    State.GearLabels = byLabel
    return labels
end

---@return number, number  found, tried
function Jeaneism.Index.HuntAll()
    local found, tried = 0, 0
    for _, gear in ipairs(Jeaneism.Index.Missing()) do
        if not State.Opt.AutoIndex and State.Lock ~= "Index" then break end
        if gear.forgeable and Jeaneism.Index.Plan(gear) > 0 then
            tried += 1
            if Jeaneism.Index.Hunt(gear) then found += 1 end
        end
    end
    Jeaneism.Index.ClaimAll()
    if tried > 0 then State.IndexNote = ("Found %d/%d"):format(found, tried) end
    return found, tried
end

function Jeaneism.Index.CollectOres()
    for _, stageId in ipairs(Jeaneism.Stage.List()) do
        Jeaneism.Stage.Collect(stageId, nil)
    end
    Jeaneism.Index.ClaimAll()
end

function Jeaneism.Index.ClaimAll()
    local index = Jeaneism.Data.Get().Index
    local claimExp = Jeaneism.Util.Remote("Index", "TryClaimIndexExpRF")
    for key in pairs(index.unlocked) do
        local itemType, itemId = key:match("^(.-)%-(.+)$")
        if itemType and not index.claimed[key] then
            claimExp:InvokeServer(itemType, itemId)
        end
    end
    local claimLevel = Jeaneism.Util.Remote("Index", "TryClaimLevelRewardRF")
    for _ = 1, Config.IndexLevelClaims do
        if not claimLevel:InvokeServer() then break end
    end
end

function Jeaneism.Index.Progress()
    local index = Jeaneism.Data.Get().Index
    local unlocked = 0
    for _ in pairs(index.unlocked) do
        unlocked += 1
    end
    return unlocked, index.level
end

---@param gen number  State.TrainGen at the start; a newer one aborts the search
---@return number?    area entered, nil when none accepted or AutoTrain was toggled meanwhile
function Jeaneism.Level.FindBestArea(gen)
    local areas = Jeaneism.GameLib.Need(GameConfig.TrainArea.Config)
    local ids,seen = {},{}
    for areaId,area in pairs(areas) do
        local id=tonumber(areaId)
        if id and not seen[id] and type(area)=="table" then
            seen[id]=true
            table.insert(ids,{id=id,basic=tonumber(area.Basic) or 0})
        end
    end
    table.sort(ids,function(a,b) return a.basic==b.basic and a.id>b.id or a.basic>b.basic end)

    local function Live()
        return State.Alive and State.Opt.AutoTrain and State.TrainGen == gen
    end

    local into = Jeaneism.Util.Remote("Train", "IntoAutoTrainRE")
    for _, entry in ipairs(ids) do
        local areaId=entry.id
        if not Live() then State.TrainPending=nil;return nil end
        State.TrainPending = areaId
        into:FireServer(areaId)
        local deadline = os.clock() + Config.TrainAcceptWait
        while Live() and os.clock() < deadline and tonumber(LocalPlayer:GetAttribute("AutoTrainAreaID")) ~= areaId do
            task.wait(0.1)
        end
        if Live() and tonumber(LocalPlayer:GetAttribute("AutoTrainAreaID")) == areaId then
            State.TrainPending = nil
            return areaId
        end
    end
    State.TrainPending = nil
    return nil
end

function Jeaneism.Level.Enter()
    if not State.Opt.AutoTrain or State.TrainEntering then return end
    if State.TrainArea then
        if os.clock() - State.TrainFiredAt < Config.TrainAcceptWait then return end
        State.TrainFiredAt = os.clock()
        Jeaneism.Util.Remote("Train", "IntoAutoTrainRE"):FireServer(State.TrainArea)
        return
    end

    local gen = State.TrainGen
    State.TrainEntering = true
    local ok, areaId = pcall(Jeaneism.Level.FindBestArea, gen)
    State.TrainEntering = false
    if not ok then error(areaId, 0) end
    if State.TrainGen == gen and areaId then
        State.TrainArea = areaId
        State.TrainFiredAt = os.clock()
    end
end

---Exits the training area and keeps resending until the server drops it; stops if AutoTrain is turned back on or the hub unloaded.
function Jeaneism.Level.Leave()
    local exit = Jeaneism.Util.Remote("Train", "ExitAutoTrainRE")
    for _ = 1, Config.TrainExitTries do
        local areaId = LocalPlayer:GetAttribute("AutoTrainAreaID") or State.TrainPending or State.TrainArea
        if not areaId then return end
        exit:FireServer(areaId)
        if not State.Alive then
            State.TrainPending = nil
            return
        end

        task.wait(Config.TrainSettle)
        if State.Opt.AutoTrain then return end
        if not LocalPlayer:GetAttribute("AutoTrainAreaID") then
            State.TrainPending = nil
            return
        end
    end
    warn("[LootToForge] training area still set after", Config.TrainExitTries, "exits")
end

function Jeaneism.Level.SetTraining(enabled)
    State.TrainGen += 1
    if enabled then
        Jeaneism.Level.Enter()
    else
        Jeaneism.Level.Leave()
    end
end

function Jeaneism.Level.Bind()
    table.insert(State.Conns, LocalPlayer:GetAttributeChangedSignal("AutoTrainAreaID"):Connect(function()
        if not State.Opt.AutoTrain or LocalPlayer:GetAttribute("AutoTrainAreaID") then return end
        task.delay(Config.TrainRejoinDelay, function()
            if State.Opt.AutoTrain and not LocalPlayer:GetAttribute("AutoTrainAreaID") then
                Jeaneism.Util.Try(Jeaneism.Level.Enter)
            end
        end)
    end))
end

function Jeaneism.Level.UsePotions(profile)
    local potionConfig = Jeaneism.GameLib.Need(GameConfig.Potion.Config)
    local now = workspace:GetAttribute("ServerTime") or os.time()
    local buffs = profile.Buff or {}
    for potionName, count in pairs(profile.Potion or {}) do
        local buffId = potionConfig[potionName] and potionConfig[potionName].BuffID
        local active = buffId and type(buffs[buffId]) == "number" and buffs[buffId] > now
        if type(count) == "number" and count > 0 and not active then
            Jeaneism.Util.Remote("Potion", "TryUsePotionRE"):FireServer(potionName, 1)
        end
    end
end

function Jeaneism.Level.TrainStep()
    local profile = Jeaneism.Data.Get()
    Jeaneism.Level.UsePotions(profile)
    if profile.Eco.rebirth ~= State.TrainRebirth or profile.Eco.level ~= State.TrainLevel then
        State.TrainRebirth = profile.Eco.rebirth
        State.TrainLevel = profile.Eco.level
        State.TrainArea = nil
    end

    if LocalPlayer:GetAttribute("AutoTrainAreaID") then
        State.TrainNilSince = nil
        return
    end
    State.TrainNilSince = State.TrainNilSince or os.clock()
    if os.clock() - State.TrainNilSince < Config.TrainWatchdog then return end
    Jeaneism.Level.Enter()
end

function Jeaneism.Level.Rebirth()
    Jeaneism.Util.Remote("Rebirth", "TryRebirthRE"):FireServer()
end

function Jeaneism.Level.RebirthStep()
    local profile = Jeaneism.Data.Get()
    local ok, needLevel = pcall(Jeaneism.GameLib.Api(GameConfig.Rebirth.Helper).GetNeedLevel, profile.Eco.rebirth + 1)
    if ok and needLevel and profile.Eco.level >= needLevel then
        Jeaneism.Level.Rebirth()
    end
end

function Jeaneism.Level.ClickOnce()
    Jeaneism.GameLib.Api(ReplicatedStorage.CTRL.TrainCTRL).TrainOnce()
end

function Jeaneism.Level.CanClick()
    if not State.Alive or not State.Opt.AutoClick then return false end
    local hum=Jeaneism.Movement.Humanoid()
    if not hum or hum.Health<=0 then return false end
    if State.Opt.ClickPauseTyping then
        local ok,focused=pcall(UserInputService.GetFocusedTextBox,UserInputService)
        if ok and focused then return false end
    end
    return true
end

function Jeaneism.Level.StartClicking()
    Jeaneism.Scheduler.StartLoop("AutoClick",function()
        if Jeaneism.Level.CanClick() then Jeaneism.Level.ClickOnce() end
    end,function() return 1/math.clamp(tonumber(State.Opt.ClickRate) or 6,1,25) end)
end

function Jeaneism.Upgrade.Names()
    local names = {}
    for name in pairs(Jeaneism.GameLib.Need(GameConfig.Upgrade.Config)) do
        table.insert(names, name)
    end
    table.sort(names)
    return names
end

function Jeaneism.Upgrade.BuySelected()
    local buy = Jeaneism.Util.Remote("Upgrade", "UpgradeOnceRE")
    for name, selected in pairs(State.Opt.Upgrades) do
        if selected then buy:FireServer(name) end
    end
end

---@return number  highest floor that still has a loot table
function Jeaneism.Tower.LastRound()
    return #Jeaneism.GameLib.Need(GameConfig.Dungeon.Config.LootTab)
end

function Jeaneism.Tower.Enter()
    local deadline = os.clock() + 10
    while State.Entering and os.clock() < deadline do
        task.wait(0.1)
    end
    if State.InTower then return true end
    State.Entering = true
    local ok, entered = pcall(function()
        return Jeaneism.Util.Remote("Dungeon", "TryIntoDungeonRF"):InvokeServer(1)
    end)
    State.Entering = false
    State.InTower = ok and entered and true or false
    return State.InTower
end

function Jeaneism.Tower.Exit()
    if not State.InTower then return end
    State.InTower = false
    Jeaneism.Util.Remote("Dungeon", "ExitDungeonRE"):FireServer()
end

function Jeaneism.Tower.FarmStep()
    if not Jeaneism.Tower.Enter() then return false end
    local round = Jeaneism.Tower.LastRound()
    local start = Jeaneism.Util.Remote("Dungeon", "StartRoundRE")
    local complete = Jeaneism.Util.Remote("Dungeon", "CompleteRoundRF")
    start:FireServer(round)
    Jeaneism.Util.WaitAll(Config.TowerWorkers, function()
        for _ = 1, Config.TowerCallsPerWorker do
            if complete:InvokeServer(round) then
                State.TowerLoot += 1
            end
        end
    end)
    return true
end

---@return number  season coins gained
function Jeaneism.Tower.FarmCoins(target)
    local start = (Jeaneism.Season.Current() or {}).SeasonCoin or 0
    local deadline = os.clock() + Config.CoinFarmTimeout
    local gained = 0
    while State.Alive and gained < target and os.clock() < deadline do
        if not State.InTower and Jeaneism.Data.Count(Jeaneism.Data.Get(), "Dungeon_Ticket") < 1 then break end
        if not Jeaneism.Tower.FarmStep() then break end
        gained = ((Jeaneism.Season.Current() or {}).SeasonCoin or 0) - start
    end
    Jeaneism.Tower.Exit()
    return gained
end

---@return string?  basic attack id of the equipped weapon, nil for an unknown weapon type
function Jeaneism.Boss.AttackId()
    local weapon = LocalPlayer:GetAttribute("WeaponType")
    return Config.BossAttackIds[weapon]
end

function Jeaneism.Boss.Join()
    Jeaneism.Util.Remote("WorldBoss", "IntoWorldBossFight"):FireServer()
    local char = LocalPlayer.Character
    if char and not State.BossReturn then State.BossReturn = char:GetPivot() end
end

---@param boss Model
function Jeaneism.Boss.StandNear(boss)
    local char = LocalPlayer.Character
    if not char then return end
    local pos = boss:GetPivot().Position
    if (char:GetPivot().Position - pos).Magnitude > Config.BossReach then
        char:PivotTo(CFrame.new(pos + Vector3.new(0, Config.BossStandHeight, Config.BossStandBack), pos))
    end
end

function Jeaneism.Boss.Step()
    local bossName = workspace:GetAttribute("CurrentWorldBoss")
    if not bossName then return end
    local attackId = Jeaneism.Boss.AttackId()
    if not attackId then return end
    if LocalPlayer:GetAttribute("IntoFight") ~= "WorldBoss" then
        Jeaneism.Boss.Join()
        task.wait(Config.BossJoinSettle)
    end

    local boss = workspace.EnemyFolder_Server:FindFirstChild(bossName)
    if not boss or boss:GetAttribute("Dead") then return end
    Jeaneism.Boss.StandNear(boss)
    local announce = Jeaneism.Util.Remote("Attack", "UseAnyATKRE")
    local attack = Jeaneism.Util.Remote("Attack", "AttackEnemyServiceRE")
    for _ = 1, Config.BossHitsPerTick do
        if not (State.Opt.AutoWorldBoss and boss.Parent) then return end
        announce:FireServer(attackId, workspace:GetServerTimeNow())
        attack:FireServer({ bossName }, { Phase = 1, SkillID = attackId, Attacker = LocalPlayer }, workspace:GetServerTimeNow())
        task.wait(Config.BossHitGap)
    end
end

function Jeaneism.Boss.ClaimCards()
    local claim = Jeaneism.Util.Remote("WorldBoss", "TryClaimBossRewardRE")
    for card = 1, Config.BossCards do
        task.spawn(claim.FireServer, claim, tostring(card))
    end
end

function Jeaneism.Boss.Leave()
    Jeaneism.Util.Remote("WorldBoss", "ExitWorldBossFight"):FireServer()
    LocalPlayer:SetAttribute("IntoFight", nil)
    local char = LocalPlayer.Character
    if State.BossReturn and char then char:PivotTo(State.BossReturn) end
    State.BossReturn = nil
end

function Jeaneism.Boss.Bind()
    table.insert(State.Conns, Jeaneism.Util.Remote("WorldBoss", "BossDeadRE").OnClientEvent:Connect(function()
        if not State.Opt.AutoWorldBoss then return end
        task.delay(Config.BossClaimDelay, function()
            if State.Opt.BossCards then Jeaneism.Util.Try(Jeaneism.Boss.ClaimCards) end
            Jeaneism.Util.Try(Jeaneism.Boss.Leave)
            State.BossDone = os.clock()
        end)
    end))
    table.insert(State.Conns, Jeaneism.Util.Remote("WorldBoss", "BossEscapeRE").OnClientEvent:Connect(function()
        if State.Opt.AutoWorldBoss then Jeaneism.Util.Try(Jeaneism.Boss.Leave) end
    end))
end

function Jeaneism.Season.Current()
    local seasons = Jeaneism.Data.Get().Season or {}
    local bestKey = Jeaneism.Util.HighestKey(seasons)
    return bestKey and seasons[bestKey]
end

function Jeaneism.Season.Goods()
    local goods = Jeaneism.GameLib.Need(GameConfig.Season.GoodsConfig)
    local ids = {}
    for goodId in pairs(goods) do
        table.insert(ids, goodId)
    end
    table.sort(ids, function(a, b) return tonumber(a) < tonumber(b) end)
    local labels, byLabel = {}, {}
    for _, goodId in ipairs(ids) do
        local good = goods[goodId]
        local label = ("%s x%d (%d coin)"):format(good.ID, good.Number, good.NeedSeasonCoin)
        byLabel[label] = goodId
        table.insert(labels, label)
    end
    return labels, byLabel
end

---@return number  exclusive gear bought, farming the coins first when short
function Jeaneism.Season.BuyExclusive()
    local goods = Jeaneism.GameLib.Need(GameConfig.Season.GoodsConfig)
    local exchange = Jeaneism.Util.Remote("Season", "ExchangeGoodsRE")
    local bought = 0
    for goodId, good in pairs(goods) do
        if good.Type ~= "Weapon" and good.Type ~= "Armor" and good.Type ~= "Hat" then continue end
        local season = Jeaneism.Season.Current()
        if not season or ((season.Goods or {})[goodId] or 0) >= (good.Store or 1) then continue end
        local short = good.NeedSeasonCoin - (season.SeasonCoin or 0)
        if short > 0 then Jeaneism.Tower.FarmCoins(short) end
        exchange:FireServer(goodId)
        bought += 1
        task.wait(0.5)
    end
    return bought
end

function Jeaneism.Season.BuyGoods()
    local goods = Jeaneism.GameLib.Need(GameConfig.Season.GoodsConfig)
    local exchange = Jeaneism.Util.Remote("Season", "ExchangeGoodsRE")
    for goodId, wanted in pairs(State.Opt.SeasonGoods) do
        local good = goods[goodId]
        if not (wanted and good) then continue end
        for _ = 1, good.Store or 1 do
            local season = Jeaneism.Season.Current()
            if not season or (season.SeasonCoin or 0) < good.NeedSeasonCoin then break end
            exchange:FireServer(goodId)
            task.wait(0.3)
        end
    end
end

function Jeaneism.Season.Step()
    Jeaneism.Util.Remote("Season", "TryClaimDailyTicRE"):FireServer()
    Jeaneism.Util.Remote("Season", "TryClaimAllRewardRE"):FireServer()
    task.wait(0.5)
    Jeaneism.Season.BuyGoods()
    local season = Jeaneism.Season.Current()
    if not (season and State.Opt.SeasonSpin) then return end
    local luck = Jeaneism.Util.Remote("Season", "LuckRE")
    for _ = 1, season.SeasonTicket or 0 do
        luck:FireServer(1)
        task.wait(0.5)
    end
end

function Jeaneism.Claim.All()
    Jeaneism.Util.Remote("Offline", "TryClaimOfflineRewardRE"):FireServer()
    Jeaneism.Util.Remote("Dungeon", "TryClaimDailyDunTicRE"):FireServer()
    Jeaneism.Util.Try(Jeaneism.Index.ClaimAll)

    local claimQuest = Jeaneism.Util.Remote("EnhantEvent", "TryClaimQuestRE")
    local claimUpdate = Jeaneism.Util.Remote("UpdateLog", "TryClaimUPDRewardRE")
    for id = 1, Config.ClaimIdScan do
        claimQuest:FireServer(id)
        claimUpdate:FireServer(id)
    end

    local ok, rewards = pcall(Jeaneism.GameLib.Api(GameConfig.Online.Helper).GetOnlineRewardConfig)
    for rewardName in pairs(ok and type(rewards) == "table" and rewards or {}) do
        Jeaneism.Util.Remote("Online", "TryClaimRE"):FireServer(rewardName)
    end
end

---@return string  the server's message for this code ("no reply" when it stayed silent)
function Jeaneism.Claim.Code(code)
    local message
    local hasListener, messageEvent = pcall(Jeaneism.Util.Remote, "Message", "MessageRE")
    local conn = hasListener and messageEvent.OnClientEvent:Connect(function(text)
        message = message or tostring(text)
    end)
    local ok, err = pcall(function()
        return Jeaneism.Util.Remote("Code", "TryUseCodeRF"):InvokeServer(code)
    end)
    local deadline = os.clock() + Config.CodeReplyWait
    while conn and not message and os.clock() < deadline do task.wait(0.05) end
    if conn then conn:Disconnect() end
    if not ok then return "failed: " .. tostring(err) end
    return message or "no reply"
end

function Jeaneism.Claim.AllCodes()
    local results = {}
    for _, code in ipairs(Config.Codes) do
        table.insert(results, ("%s: %s"):format(code, Jeaneism.Claim.Code(code)))
    end
    return table.concat(results, "\n")
end

function Jeaneism.SuperLoot.Kill(uuid)
    Jeaneism.Util.Remote("SuperLoot", "KillSuperLootRE"):FireServer(uuid)
    task.wait(0.2)
    Jeaneism.Util.Remote("Stage", "GetOreRF"):InvokeServer(uuid)
    Jeaneism.Util.Remote("Stage", "ClaimedAllOreRE"):FireServer()
end

function Jeaneism.SuperLoot.KillExisting()
    for _, enemy in ipairs(workspace.EnemyFolder:GetChildren()) do
        local enemyId = enemy:GetAttribute("EnemyID")
        if enemyId and enemyId:find("^Super") then
            task.spawn(Jeaneism.Util.Try, Jeaneism.SuperLoot.Kill, enemy.Name)
        end
    end
end

function Jeaneism.SuperLoot.Bind()
    table.insert(State.Conns, Jeaneism.Util.Remote("SuperLoot", "RefreshSuperLootRE").OnClientEvent:Connect(function(_, uuid)
        if State.Opt.SuperLootAura then
            task.spawn(Jeaneism.Util.Try, Jeaneism.SuperLoot.Kill, uuid)
        end
    end))
end

function Jeaneism.Combat.KillAll()
    local folder=workspace:FindFirstChild("EnemyFolder")
    if not folder then return false end
    local hit = Jeaneism.GameLib.Api(ReplicatedStorage.Utils.CommunicationUtils).TryGetBindableEvent("Attack", "EnemyHitBE")
    local hitInfo = { SkillID = "K_ATK_1", IsCrit = true, Damage = Config.KillDamage }
    for _, enemy in ipairs(folder:GetChildren()) do
        local enemyId = enemy:GetAttribute("EnemyID")
        if enemyId and not enemyId:find("^Super") then
            hit:Fire(enemy.Name, Config.KillDamage, hitInfo)
        end
    end
end

function Jeaneism.Combat.Start()
    Jeaneism.Scheduler.StartLoop("KillAura",Jeaneism.Combat.KillAll,function() return Config.KillAuraInterval end)
end

---@return boolean  false when the game's damage function can't be reached
function Jeaneism.Guard.HookDamage()
    if State.RestoreDamage then return true end
    local hpCtrl = Jeaneism.GameLib.Require(ReplicatedStorage.CTRL.HPCTRL)
    local damageOnce = hpCtrl and hpCtrl.DamageOnce
    if type(damageOnce) ~= "function" then return false end

    hpCtrl.DamageOnce = function(target, damage)
        if target == LocalPlayer and State.Opt.GodMode then return false end
        return damageOnce(target, damage)
    end
    State.RestoreDamage = function()
        hpCtrl.DamageOnce = damageOnce
        State.RestoreDamage = nil
    end
    return true
end

---@return boolean  false when the executor can't hook namecall or the remote is missing
function Jeaneism.Guard.HookOreLoss()
    if State.RestoreNamecall then return true end
    local compat = Jeaneism.Compat
    if not (compat and compat.Caps.Namecall) then return false end
    local found, lostOre = pcall(Jeaneism.Util.Remote, "Stage", "LostAllOreRF")
    if not found then
        warn("[LootToForge] keep ore:", lostOre)
        return false
    end

    local original, restore
    original, restore = compat.HookMeta(game, "__namecall", function(self, ...)
        if self == lostOre and State.Opt.KeepOre and getnamecallmethod() == "InvokeServer" then
            return {}
        end
        return original(self, ...)
    end)
    if not original then return false end

    State.RestoreNamecall = function()
        State.RestoreNamecall = nil
        restore()
    end
    return true
end

function Jeaneism.Guard.UnhookOreLoss()
    if State.RestoreNamecall then State.RestoreNamecall() end
end

function Jeaneism.Guard.Stop()
    if State.RestoreDamage then State.RestoreDamage() end
    Jeaneism.Guard.UnhookOreLoss()
end

function Jeaneism.Race.Choices()
    local classConfig = Jeaneism.GameLib.Need(GameConfig.Class.Config)
    local show = Jeaneism.GameLib.Need(GameConfig.Class.Show)
    local ids = {}
    for classId in pairs(classConfig) do
        table.insert(ids, classId)
    end
    table.sort(ids, function(a, b) return classConfig[a].Weight < classConfig[b].Weight end)

    local labels, idByLabel = {}, {}
    for _, classId in ipairs(ids) do
        local label = ("%s (%s)"):format(show[classId] and show[classId].DisplayName or classId, classConfig[classId].Rarity)
        idByLabel[label] = classId
        table.insert(labels, label)
    end
    return labels, idByLabel
end

function Jeaneism.Race.EquipBest()
    local classData = Jeaneism.Data.Get().Class
    local classConfig = Jeaneism.GameLib.Need(GameConfig.Class.Config)
    local bestSlot, bestWeight = nil, math.huge
    for slot, classId in pairs(classData.have) do
        local weight = classConfig[classId] and classConfig[classId].Weight or math.huge
        if weight < bestWeight then bestSlot, bestWeight = slot, weight end
    end
    if not bestSlot or tostring(bestSlot) == tostring(classData.equiped) then return false end
    Jeaneism.Util.Remote("Class", "ChangeEquipedIndexRE"):FireServer(tostring(bestSlot))
    return true
end

function Jeaneism.Race.RollUntil(targetId)
    if not targetId then return "target" end
    local roll = Jeaneism.Util.Remote("Class", "LuckOnceRE")
    while State.Alive and State.Opt.AutoRace do
        local classData = Jeaneism.Data.Get().Class
        if classData.have[classData.equiped] == targetId then return "got" end
        if (classData.luckTimes or 0) <= 0 then return "empty" end
        roll:FireServer(tostring(classData.equiped))
        task.wait(Config.RaceRollDelay)
    end
    return "stopped"
end

function Jeaneism.Movement.Humanoid()
    return LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
end

function Jeaneism.Movement.Apply()
    local hum = Jeaneism.Movement.Humanoid()
    if not hum then return end
    hum.WalkSpeed = State.Opt.SpeedOn and State.Opt.WalkSpeed or (LocalPlayer:GetAttribute("OriWalkSpeed") or 22)
end

function Jeaneism.Movement.Bind()
    table.insert(State.Conns, UserInputService.JumpRequest:Connect(function()
        local hum = Jeaneism.Movement.Humanoid()
        if State.Opt.InfJump and hum then
            hum:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end))
    table.insert(State.Conns, LocalPlayer.CharacterAdded:Connect(function()
        task.wait(1)
        Jeaneism.Movement.Apply()
    end))
end

function Jeaneism.Session.SetLowGraphics(enabled)
    RunService:Set3dRenderingEnabled(not enabled)
end

function Jeaneism.Session.Rejoin()
    local queue = queue_on_teleport or queueonteleport
    if queue then queue(Config.ReloadSource) end
    TeleportService:Teleport(game.PlaceId, LocalPlayer)
end

function Jeaneism.Boss.HopFlag(enabled)
    local flag = Config.SaveFolder .. "/" .. Config.BossHopFlag
    pcall(function()
        if enabled then
            if not isfolder(Config.SaveFolder) then makefolder(Config.SaveFolder) end
            writefile(flag, tostring(os.time()))
        elseif isfile(flag) then
            delfile(flag)
        end
    end)
end

---@return number?  seconds since the last hop, nil when no hop is pending
function Jeaneism.Boss.SinceLastHop()
    local ok, stamp = pcall(readfile, Config.SaveFolder .. "/" .. Config.BossHopFlag)
    if not ok or not tonumber(stamp) then return nil end
    return os.time() - tonumber(stamp)
end

---@return boolean  true only right after a hop, so a fresh launch never starts hopping by itself
function Jeaneism.Boss.HopWanted()
    local since = Jeaneism.Boss.SinceLastHop()
    return since ~= nil and since < Config.BossHopResume
end

---@return string[], number  unvisited servers from the saved list, and when it was fetched
function Jeaneism.Boss.LoadServers()
    local ok, text = pcall(readfile, Config.SaveFolder .. "/" .. Config.BossHopServers)
    if not ok then return {}, 0 end
    local decoded
    ok, decoded = pcall(HttpService.JSONDecode, HttpService, text)
    if not ok or type(decoded) ~= "table" or type(decoded.ids) ~= "table" then return {}, 0 end
    local fetchedAt = tonumber(decoded.at) or 0
    if os.time() - fetchedAt > Config.HopListTtl then return {}, 0 end
    return decoded.ids, fetchedAt
end

---@param ids string[]    servers still unvisited
---@param fetchedAt number  when the list came from the API
function Jeaneism.Boss.SaveServers(ids, fetchedAt)
    pcall(function()
        if not isfolder(Config.SaveFolder) then makefolder(Config.SaveFolder) end
        writefile(Config.SaveFolder .. "/" .. Config.BossHopServers, HttpService:JSONEncode({ at = fetchedAt, ids = ids }))
    end)
end

---@return string[]  public servers with room; empty while the API refuses (waits 2x longer after each refusal)
function Jeaneism.Boss.FetchServers()
    if os.clock() < State.HopBlockedUntil then return {} end
    local body = Jeaneism.Util.HttpGet(("https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=Asc&limit=100"):format(game.PlaceId))
    local ok, list = pcall(HttpService.JSONDecode, HttpService, body or "")
    local ids = {}
    for _, server in ipairs(ok and type(list) == "table" and type(list.data) == "table" and list.data or {}) do
        if server.id ~= game.JobId and server.playing < server.maxPlayers then table.insert(ids, server.id) end
    end
    if #ids > 0 then
        State.HopFails, State.HopBackoff = 0, nil
        return ids
    end
    State.HopFails += 1
    State.HopBackoff = math.min((State.HopBackoff or Config.HopBackoffStart / 2) * 2, Config.HopBackoffMax)
    State.HopBlockedUntil = os.clock() + State.HopBackoff
    warn("[LootToForge] server list refused, retry in", State.HopBackoff, "s, fail", State.HopFails)
    return {}
end

---@return string?  a public server with room, not this one
function Jeaneism.Boss.PickServer()
    local ids, fetchedAt = Jeaneism.Boss.LoadServers()
    if #ids == 0 then
        ids, fetchedAt = Jeaneism.Boss.FetchServers(), os.time()
    end
    while #ids > 0 do
        local serverId = table.remove(ids, math.random(#ids))
        if serverId ~= game.JobId then
            Jeaneism.Boss.SaveServers(ids, fetchedAt)
            return serverId
        end
    end
    Jeaneism.Boss.SaveServers(ids, fetchedAt)
    return nil
end

function Jeaneism.Boss.Hop()
    local serverId = Jeaneism.Boss.PickServer()
    if not serverId then return end
    State.BossHopping = os.clock()
    Jeaneism.Boss.HopFlag(true)
    local queue = queue_on_teleport or queueonteleport
    if queue and not State.HopQueued then
        queue(Config.ReloadSource)
        State.HopQueued = true
    end
    TeleportService:TeleportToPlaceInstance(game.PlaceId, serverId, LocalPlayer)
end

---@return boolean  true when this server is worth staying in: boss up, boss about to spawn, or still collecting
function Jeaneism.Boss.WorthStaying()
    local boss = workspace:GetAttribute("CurrentWorldBoss")
    if boss and not State.BossDone then return true end
    if State.BossDone then return os.clock() - State.BossDone < Config.BossHopAfter end
    local nextTick, serverTime = workspace:GetAttribute("NextWorldBossTick"), workspace:GetAttribute("ServerTime")
    if not nextTick or not serverTime then return true end
    return nextTick - serverTime <= Config.BossHopLead
end

function Jeaneism.Boss.HopGiveUp()
    State.Opt.BossHop = false
    Jeaneism.Boss.HopFlag(false)
    table.insert(State.Halted, { "BossHop", "no server list from Roblox, try again later" })
end

function Jeaneism.Boss.HopStep()
    if State.BossHopping then
        if os.clock() - State.BossHopping < Config.HopStall then return end
        State.BossHopping = false
    end
    if Jeaneism.Boss.WorthStaying() then return end
    if (Jeaneism.Boss.SinceLastHop() or Config.HopGap) < Config.HopGap then return end
    if State.HopFails >= Config.HopGiveUp then
        Jeaneism.Boss.HopGiveUp()
        return
    end
    Jeaneism.Boss.Hop()
end

function Jeaneism.Session.Bind()
    table.insert(State.Conns, TeleportService.TeleportInitFailed:Connect(function()
        if not State.BossHopping then return end
        State.BossHopping = false
        task.delay(1, Jeaneism.Util.Try, Jeaneism.Boss.HopStep)
    end))
    table.insert(State.Conns, LocalPlayer.Idled:Connect(function()
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end))
    table.insert(State.Conns,GuiService.ErrorMessageChanged:Connect(function(msg)
        State.LastErrorText=msg
        if not State.Opt.AutoRejoin or msg=="" or State.RejoinQueued then return end
        State.RejoinQueued=true
        task.delay(Config.RejoinDelay,function()
            State.RejoinQueued=false
            if State.Alive and State.Opt.AutoRejoin and State.LastErrorText~="" then
                Jeaneism.Util.Try(Jeaneism.Session.Rejoin)
            end
        end)
    end))
end

Jeaneism.Scheduler.Jobs = {
    { key = "MaxGear", every = 0, run = function()
        local ok, err = Jeaneism.Util.Exclusive("Gear", Jeaneism.Gear.MaxStep)
        if not ok and err ~= nil then error(err, 0) end
    end },
    { key = "AutoForge", every = 0, run = function() Jeaneism.Forge.Step() end },
    { key = "AutoEquip", every = Config.EquipInterval, run = function() Jeaneism.Gear.EquipBest() end },
    { key = "AutoSell", every = Config.SellInterval, run = function() Jeaneism.Sell.Run(Jeaneism.Data.Get()) end },
    { key = "AutoTrain", every = 1, run = function() Jeaneism.Level.TrainStep() end },
    { key = "AutoRebirth", every = Config.RebirthInterval, run = function() Jeaneism.Level.RebirthStep() end },
    { key = "AutoUpgrade", every = Config.UpgradeInterval, run = function() Jeaneism.Upgrade.BuySelected() end },
    { key = "AutoTower", every = 0, run = function() Jeaneism.Tower.FarmStep() end },
    { key = "AutoWorldBoss", every = Config.BossInterval, run = function() Jeaneism.Boss.Step() end },
    { key = "BossHop", every = Config.BossHopInterval, run = function() Jeaneism.Boss.HopStep() end },
    { key = "AutoClaim", every = Config.ClaimInterval, run = function() Jeaneism.Claim.All() end },
    { key = "AutoSeason", every = Config.SeasonInterval, run = function() Jeaneism.Season.Step() end },
    { key = "AutoBestRace", every = 10, run = function() Jeaneism.Race.EquipBest() end },
    { key = "AutoIndex", every = Config.IndexInterval, run = function()
        local ok, err = Jeaneism.Util.Exclusive("Index", Jeaneism.Index.HuntAll)
        if not ok and err ~= nil then error(err, 0) end
    end },
}

---Runs one round of a feature; one that keeps failing for Config.FailWindow seconds is switched off and queued for the UI to report.
---@param key string  State.Opt flag of the feature
function Jeaneism.Scheduler.Run(key,fn)
    if not State.Alive or not State.Opt[key] then return false end
    local failures=State.Failures
    local streak=failures[key]
    local now=os.clock()
    if streak and now<(streak.nextTry or 0) then return false end
    local ok,result=pcall(fn)
    if ok then failures[key]=nil;return true,result end
    now=os.clock()
    if not streak then
        streak={count=0,since=now}
        failures[key]=streak
        Jeaneism.Util.WarnJob(key,result)
    end
    streak.count+=1
    streak.nextTry=now+math.min(Config.RetryMax,Config.RetryBase*2^math.min(streak.count-1,8))
    if streak.count>=Config.MaxFailures and now-streak.since>=Config.FailWindow then
        failures[key]=nil
        State.Opt[key]=false
        local reason=tostring(result):match("[^\n]*")
        warn("[LootToForge]",key,"stopped:",reason)
        table.insert(State.Halted,{key,reason})
    end
    return false,result
end

-- One persistent worker per fast feature, including rapid off/on toggles.
function Jeaneism.Scheduler.StartLoop(key,fn,interval)
    if State.WorkerLoops[key] then return end
    State.WorkerLoops[key]=true
    task.spawn(function()
        local ok,err=pcall(function()
            while State.Alive do
                local started = os.clock()
                if State.Opt[key] then Jeaneism.Scheduler.Run(key,fn) end
                local delay=State.Opt[key] and interval() or 0.1
                local period = math.max(0.04,tonumber(delay) or 0.1)
                local elapsed = os.clock() - started
                -- Account for call time without replaying missed ticks after a stall.
                task.wait(elapsed < period and math.max(0.001,period-elapsed) or period)
            end
        end)
        State.WorkerLoops[key]=nil
        if not ok then Jeaneism.Util.WarnJob(key,err) end
    end)
end

function Jeaneism.Scheduler.Step()
    if State.Lock then return end
    local now = os.clock()
    for _, job in ipairs(Jeaneism.Scheduler.Jobs) do
        if not State.Opt[job.key] or State.Lock then continue end
        if now - (State.LastRun[job.key] or 0) < job.every then continue end
        State.LastRun[job.key] = now
        Jeaneism.Scheduler.Run(job.key, job.run)
    end
end

function Jeaneism.Scheduler.Start()
    task.spawn(function()
        while State.Alive do
            if not State.Busy then
                State.Busy = true
                Jeaneism.Util.Try(Jeaneism.Scheduler.Step)
                State.Busy = false
            end
            task.wait(Config.TickDelay)
        end
    end)
end

function Jeaneism.Scheduler.Boot()
    for _, bind in ipairs({ Jeaneism.Movement.Bind, Jeaneism.Level.Bind, Jeaneism.SuperLoot.Bind, Jeaneism.Boss.Bind, Jeaneism.Session.Bind }) do
        Jeaneism.Util.Try(bind)
    end
    Jeaneism.Scheduler.Start()
end

function Jeaneism.Scheduler.Stop()
    State.Alive = false
    for _, conn in ipairs(State.Conns) do
        conn:Disconnect()
    end
    table.clear(State.Conns)
    if State.Opt.AutoTrain then
        State.Opt.AutoTrain = false
        task.spawn(Jeaneism.Util.Try, Jeaneism.Level.SetTraining, false)
    end
    if State.Opt.SpeedOn then
        State.Opt.SpeedOn = false
        Jeaneism.Movement.Apply()
    end
    if State.Opt.LowGraphics then
        Jeaneism.Session.SetLowGraphics(false)
    end
    Jeaneism.Util.Try(Jeaneism.Tower.Exit)
    if LocalPlayer:GetAttribute("IntoFight") == "WorldBoss" then Jeaneism.Util.Try(Jeaneism.Boss.Leave) end
    Jeaneism.Guard.Stop()
end

local function BuildInterface()
    local Library = Jeaneism.Util.LoadLibrary()
    if not Library then return end
    Jeaneism.Compat = Library.Compat or { Caps = {}, Block = function() end, NeedCap = function() end }
    pcall(PixeLBanner.Step, "UI library")
    local Options = Library.Options
    Library:RegisterTranslations("ID", {
        ["Above +10 the success rate gets very low and can take a long time"] = "Di atas +10, peluang berhasil sangat kecil dan proses bisa lama",
        ["Add 100K Potions"] = "Tambah 100 ribu ramuan",
        ["Add Season Coins"] = "Tambah koin musim",
        ["Always wears your strongest weapon, armor and hat, counting enhance level"] = "Selalu memakai senjata, armor, dan topi terkuat dengan memperhitungkan peningkatan",
        ["Amount"] = "Jumlah",
        ["Any stage, no unlock needed"] = "Pilih stage mana pun tanpa perlu membuka akses",
        ["Auto Buy Upgrades"] = "Beli peningkatan otomatis",
        ["Auto Claim"] = "Klaim otomatis",
        ["Auto Click"] = "Klik otomatis",
        ["Auto Collect Ore"] = "Kumpulkan bijih otomatis",
        ["Auto Complete Index"] = "Lengkapi indeks otomatis",
        ["Auto Equip Best"] = "Pakai perlengkapan terbaik otomatis",
        ["Auto Farm Tower"] = "Farm menara otomatis",
        ["Auto Forge"] = "Tempa otomatis",
        ["Auto Rebirth"] = "Rebirth otomatis",
        ["Auto Rejoin"] = "Masuk ulang otomatis",
        ["Auto Roll Race"] = "Acak ras otomatis",
        ["Auto Season"] = "Musim otomatis",
        ["Auto Sell"] = "Jual otomatis",
        ["Auto Train"] = "Latihan otomatis",
        ["Auto World Boss"] = "World boss otomatis",
        ["Best gear and runes, enhanced to your target. Finds anything missing by itself"] = "Perlengkapan dan rune terbaik, ditingkatkan sesuai target. Mencari yang belum dimiliki secara otomatis",
        ["Best gear, money, level, rewards and bosses all at once"] = "Perlengkapan, uang, level, hadiah, dan boss sekaligus",
        ["Best runes"] = "Rune terbaik",
        ["Boss Server Hop"] = "Pindah server untuk boss",
        ["Buy Exclusive Gear"] = "Beli perlengkapan eksklusif",
        ["Buy Upgrade Now"] = "Beli peningkatan sekarang",
        ["Buys the selected upgrades whenever possible"] = "Membeli peningkatan terpilih saat memungkinkan",
        ["Chance shown is per forge with the best ore"] = "Peluang yang ditampilkan berlaku per tempa dengan bijih terbaik",
        ["Claim Now"] = "Klaim sekarang",
        ["Claim Rewards"] = "Klaim hadiah",
        ["Claims every free reward, including index"] = "Mengklaim semua hadiah gratis, termasuk indeks",
        ["Clears the stage and collects its ores nonstop"] = "Menyelesaikan stage dan mengumpulkan bijihnya terus-menerus",
        ["Clicks to train as fast as the game allows"] = "Klik untuk latihan secepat yang diizinkan game",
        ["Code"] = "Kode",
        ["Collect All Ores"] = "Kumpulkan semua bijih",
        ["Combat"] = "Pertarungan",
        ["Combat & Farm"] = "Pertarungan & farm",
        ["Copies"] = "Salinan",
        ["Copy Discord Link"] = "Salin tautan Discord",
        ["Copy Website Link"] = "Salin tautan situs web",
        ["Daily ticket, pass rewards, spins and shop"] = "Tiket harian, hadiah pass, putaran, dan toko",
        ["Dupe Whole Inventory"] = "Duplikasi seluruh inventaris",
        ["Enhance"] = "Peningkatan",
        ["Enhance Slot"] = "Slot peningkatan",
        ["Enhance Stones"] = "Batu peningkatan",
        ["Enhance Target"] = "Target peningkatan",
        ["Enhance To Target"] = "Tingkatkan hingga target",
        ["Equip"] = "Perlengkapan",
        ["Equip Best Now"] = "Pakai yang terbaik sekarang",
        ["Every monster in your fight dies instantly"] = "Semua monster dalam pertarungan dikalahkan seketika",
        ["Exit Fight Now"] = "Keluar dari pertarungan sekarang",
        ["Exit Tower Now"] = "Keluar dari menara sekarang",
        ["FPS Boost"] = "Peningkat FPS",
        ["Farm"] = "Farm",
        ["Farm Enhance Stones"] = "Farm batu peningkatan",
        ["Farm Rare Stones"] = "Farm batu langka",
        ["Filters"] = "Filter",
        ["Forge"] = "Tempa",
        ["Forge Now"] = "Tempa sekarang",
        ["Forge Ore Rarity"] = "Kelangkaan bijih untuk tempa",
        ["Forge best gear"] = "Tempa perlengkapan terbaik",
        ["Forge gear from any ore"] = "Tempa perlengkapan dari bijih apa pun",
        ["Forges Per Round"] = "Jumlah tempa per putaran",
        ["Forges every missing weapon, armor and hat, then claims rewards"] = "Menempa senjata, armor, dan topi yang belum dimiliki, lalu mengklaim hadiah",
        ["Forges the target gear nonstop"] = "Menempa perlengkapan target terus-menerus",
        ["Gear"] = "Perlengkapan",
        ["Get Selected"] = "Ambil yang dipilih",
        ["Hops to servers where the boss is up or about to spawn, kills it, then moves on"] = "Berpindah ke server tempat boss muncul atau segera muncul, mengalahkannya, lalu berpindah lagi",
        ["Index"] = "Indeks",
        ["Index Types"] = "Jenis indeks",
        ["Infinite Jump"] = "Lompatan tanpa batas",
        ["Invincible"] = "Kebal",
        ["Item"] = "Item",
        ["Joins every world boss and kills it"] = "Mengikuti dan mengalahkan setiap world boss",
        ["Kaitun"] = "Mode lengkap",
        ["Kaitun (All-in-one)"] = "Mode lengkap (semua fitur)",
        ["Keep Ore On Death"] = "Simpan bijih saat mati",
        ["Keep Per Item"] = "Simpan per item",
        ["Keep Per Ore"] = "Simpan per bijih",
        ["Keeps this many of each item, highest enhance first"] = "Menyimpan jumlah ini untuk setiap item, dimulai dari peningkatan tertinggi",
        ["Kill Aura"] = "Aura serangan",
        ["Kill Ore Boss"] = "Kalahkan boss bijih",
        ["Kills rare ore bosses the moment they spawn"] = "Mengalahkan boss bijih langka segera setelah muncul",
        ["Live activity"] = "Aktivitas langsung",
        ["Main"] = "Utama",
        ["Max Gear"] = "Perlengkapan maksimum",
        ["Max Potion Buffs"] = "Buff ramuan maksimum",
        ["Missing Item"] = "Item yang belum dimiliki",
        ["Monsters and bosses can't kill you"] = "Monster dan boss tidak dapat mengalahkanmu",
        ["Movement"] = "Pergerakan",
        ["Never forge below this amount of each ore"] = "Jangan menempa jika jumlah setiap bijih akan turun di bawah batas ini",
        ["Not available after a game update"] = "Tidak tersedia setelah pembaruan game",
        ["Not available on this executor"] = "Tidak tersedia pada executor ini",
        ["Off = spend the weakest ore first"] = "Mati = gunakan bijih terlemah lebih dahulu",
        ["Only collect these rarities"] = "Hanya kumpulkan kelangkaan ini",
        ["Only sell these rarities"] = "Hanya jual kelangkaan ini",
        ["Only these ore rarities are used for forging"] = "Hanya kelangkaan bijih ini yang digunakan untuk menempa",
        ["Ore Rarity Filter"] = "Filter kelangkaan bijih",
        ["Ore To Use"] = "Bijih yang digunakan",
        ["Ore Usage"] = "Penggunaan bijih",
        ["Ores, runes and enhance stones"] = "Bijih, rune, dan batu peningkatan",
        ["Ores, runes, scrolls, tickets and stones. Runes and materials need at least one owned"] = "Bijih, rune, scroll, tiket, dan batu. Rune dan material harus sudah dimiliki setidaknya satu",
        ["Other"] = "Lainnya",
        ["Panic - All Off"] = "Darurat - matikan semua",
        ["Pick an ore and it never runs out"] = "Pilih bijih agar tidak habis",
        ["Player"] = "Pemain",
        ["Potions"] = "Ramuan",
        ["Progress"] = "Progres",
        ["Race"] = "Ras",
        ["Race, movement and survival"] = "Ras, pergerakan, dan bertahan hidup",
        ["Rebirth Now"] = "Rebirth sekarang",
        ["Rebirths as soon as your level is high enough"] = "Melakukan rebirth segera setelah level mencukupi",
        ["Redeem All Codes"] = "Tukarkan semua kode",
        ["Redeem Code"] = "Tukarkan kode",
        ["Refresh"] = "Muat ulang",
        ["Rejoin Now"] = "Masuk ulang sekarang",
        ["Rejoins the game by itself after a disconnect"] = "Masuk kembali ke game secara otomatis setelah terputus",
        ["Rewards"] = "Hadiah",
        ["Runes To Use"] = "Rune yang digunakan",
        ["Season"] = "Musim",
        ["Season Coins"] = "Koin musim",
        ["Season Now"] = "Jalankan musim sekarang",
        ["Sell"] = "Jual",
        ["Sell All Now"] = "Jual semua sekarang",
        ["Sell Item Types"] = "Jenis item yang dijual",
        ["Sell Rarity Filter"] = "Filter kelangkaan penjualan",
        ["Sell gear by type and rarity"] = "Jual perlengkapan berdasarkan jenis dan kelangkaan",
        ["Sell worse gear right away"] = "Langsung jual perlengkapan yang lebih lemah",
        ["Sells gear that matches your filters. Equipped gear is never sold"] = "Menjual perlengkapan sesuai filter. Perlengkapan yang dipakai tidak pernah dijual",
        ["Session"] = "Sesi",
        ["Session dashboard"] = "Dashboard sesi",
        ["Shop Items To Buy"] = "Item toko yang dibeli",
        ["Spawn"] = "Buat item",
        ["Spawn Gear"] = "Buat perlengkapan",
        ["Spawn Items"] = "Buat item",
        ["Speed"] = "Kecepatan",
        ["Spend Best Ore First"] = "Gunakan bijih terbaik lebih dahulu",
        ["Spin every ticket"] = "Gunakan semua tiket putaran",
        ["Stage"] = "Stage",
        ["Stages, monsters, bosses and index"] = "Stage, monster, boss, dan indeks",
        ["Status, all-in-one mode and rewards"] = "Status, mode lengkap, dan hadiah",
        ["Stronger runes go in first"] = "Rune yang lebih kuat dipasang lebih dahulu",
        ["Strongest first. Exclusive gear is shop only"] = "Terkuat lebih dahulu. Perlengkapan eksklusif hanya tersedia di toko",
        ["Survival"] = "Bertahan hidup",
        ["Switch Now"] = "Ganti sekarang",
        ["Switches to your rarest race"] = "Beralih ke ras paling langka yang dimiliki",
        ["Take every reward card"] = "Ambil semua kartu hadiah",
        ["Target Gear"] = "Perlengkapan target",
        ["Target Race"] = "Ras target",
        ["Top floor loot nonstop on one ticket: rare stones and season coins"] = "Loot lantai teratas terus-menerus dengan satu tiket: batu langka dan koin musim",
        ["Tower"] = "Menara",
        ["Tower loot and season pass"] = "Loot menara dan season pass",
        ["Training"] = "Latihan",
        ["Training, rebirth and upgrades"] = "Latihan, rebirth, dan peningkatan",
        ["Trains at the best area nonstop and drinks your potions"] = "Latihan terus-menerus di area terbaik dan menggunakan ramuan",
        ["Turns off 3D rendering to save CPU and GPU"] = "Mematikan rendering 3D untuk menghemat CPU dan GPU",
        ["Type"] = "Jenis",
        ["Update Log"] = "Catatan pembaruan",
        ["Upgrade & Rebirth"] = "Peningkatan & rebirth",
        ["Upgrades"] = "Peningkatan",
        ["Upgrades To Buy"] = "Peningkatan yang dibeli",
        ["Use Best Race Slot"] = "Gunakan slot ras terbaik",
        ["Used when Ore To Use is Owned ores"] = "Digunakan saat Bijih yang digunakan diatur ke Bijih yang dimiliki",
        ["Uses your race rolls until you get the chosen race"] = "Menggunakan putaran ras sampai mendapatkan ras pilihan",
        ["Walk Speed"] = "Kecepatan berjalan",
        ["Website"] = "Situs web",
        ["World Boss"] = "World boss",
    })
    local T = function(en, th) return Library:T(en, th) end
    local opt = State.Opt
    local featureNames = {}
    local uiQueue = {}
    local dashboard = {}
    local activityLabel

    ---@return table, table  empty tables when the game data can't be read
    local function Source(fn)
        local ok, first, second = pcall(fn)
        if not ok then
            warn("[LootToForge] menu data:", first)
            return {}, {}
        end
        return first or {}, second or {}
    end

    local rarityNames = Source(Jeaneism.Util.RarityNames)

    local function Later(fn, ...)
        local args = table.pack(...)
        table.insert(uiQueue, function()
            fn(table.unpack(args, 1, args.n))
        end)
    end

    local function Notify(text, kind, seconds)
        Later(Library.Notify, Library, "PixeL UI", text, seconds or 4, kind or "Info")
    end

    local function TurnOff(key)
        local toggle = Options[key]
        if toggle and toggle.Value then toggle:SetValue(false) end
    end

    local function AllOff()
        TurnOff("Kaitun")
        for key in pairs(featureNames) do TurnOff(key) end
        if Library.Window then Library.Window:SetSessionStatus("Stopped", 0, "Off") end
    end

    ---@param pickFirst boolean?  also select the first entry
    local function SetList(idx, values, pickFirst)
        local dropdown = Options[idx]
        if not dropdown then return end
        dropdown:SetValues(values)
        if pickFirst and values[1] then
            dropdown:SetValue(values[1])
        elseif dropdown.Value ~= opt[idx] then
            dropdown:SetValue(dropdown.Value)
        end
    end

    ---@param module Instance  game module the feature can't run without
    local function NeedModule(option, module)
        if Jeaneism.GameLib.Require(module) then return end
        Jeaneism.Compat.Block(option, T("Not available on this executor", "ใช้กับ executor นี้ไม่ได้"))
    end

    local function BlockMissing()
        for idx, paths in pairs(Jeaneism.GameLib.Missing()) do
            warn("[LootToForge]", idx, "blocked, missing:", table.concat(paths, ", "))
            if Options[idx] then Jeaneism.Compat.Block(Options[idx], T("Not available after a game update", "ใช้ไม่ได้หลังเกมอัปเดต")) end
        end
    end

    local function Pump()
        for _, halt in ipairs(State.Halted) do
            TurnOff(halt[1])
            Notify(("%s stopped: %s"):format(featureNames[halt[1]] or halt[1], halt[2]), "Warning")
        end
        table.clear(State.Halted)

        local jobs = uiQueue
        uiQueue = {}
        for _, job in ipairs(jobs) do
            Jeaneism.Util.Try(job)
        end
    end

    local function Action(action, feedback)
        return function()
            task.defer(function()
                local ok, result = Jeaneism.Util.Try(action)
                if not ok then
                    Later(Library.Feedback, Library, "Error")
                    Notify("Action failed; check the console", "Error")
                elseif feedback and (result == true or (type(result) == "number" and result > 0)) then
                    Later(Library.Feedback, Library, feedback)
                    Notify(feedback .. " completed", "Success")
                elseif feedback then
                    Notify("No confirmed result yet", "Warning")
                end
            end)
        end
    end

    ---@param name string  lock name, also the busy message
    local function LongAction(name, action, done)
        return function()
            task.defer(function()
                if State.Lock then return Notify("Busy: " .. State.Lock, "Warning") end
                Notify(name .. "...")
                local outcome
                local completed = Jeaneism.Util.Exclusive(name, function() outcome = action() end)
                if not completed then
                    Notify(name .. " failed; check the console", "Error")
                elseif done then
                    Notify(done(outcome), "Success")
                end
            end)
        end
    end

    local function Toggle(group, key, text, description, onChange, risky)
        featureNames[key] = text.EN
        return group:AddToggle(key, {
            Text = text,
            Description = description,
            Risky = risky,
            Default = opt[key],
            Callback = function(value)
                opt[key] = value
                State.Failures[key] = nil
                if onChange then
                    onChange(value)
                end
            end,
        })
    end

    local Feature = Toggle

    local function HotkeyFeature(group, key, text, description, onChange, risky)
        return Toggle(group, key, text, description, onChange, risky):AddKeyPicker(key .. "Key", { Default = "None", Mode = "Toggle" })
    end

    local function Check(group, key, text)
        return group:AddCheckbox(key, {
            Text = text,
            Default = opt[key],
            Callback = function(value)
                opt[key] = value
                State.Failures[key] = nil
            end,
        })
    end

    local function MultiSelect(group, key, text, description, values)
        opt[key] = Jeaneism.Util.AllSet(values)
        return group:AddDropdown(key, {
            Text = text,
            Description = description,
            Values = values,
            Multi = true,
            Default = values,
            Searchable = #values > 8,
            Callback = function(selected)
                opt[key] = selected
            end,
        })
    end

    ---@param source function  returns the dropdown values, read safely
    local function Pick(group, key, text, description, source, noSave, risky)
        local values = Source(source)
        opt[key] = values[1]
        return group:AddDropdown(key, {
            Text = text,
            Description = description,
            Risky = risky,
            Values = values,
            Default = 1,
            Searchable = #values > 8,
            NoSave = noSave,
            Callback = function(value)
                opt[key] = value
                State.Failures[key] = nil
            end,
        })
    end

    local function NumberInput(group, key, text, description, minimum)
        return group:AddInput(key, {
            Text = text,
            Description = description,
            Default = tostring(opt[key]),
            Numeric = true,
            Finished = true,
            Callback = function(value)
                opt[key] = math.max(minimum or 0, math.floor(tonumber(value) or opt[key]))
            end,
        })
    end

    local function RefreshButton(idx, list)
        return { Text = T("Refresh", "รีเฟรช"), Func = function()
            task.defer(function()
                Later(SetList, idx, (Source(list)))
            end)
        end }
    end

    local function BuildMain(tab)
        local statusBox = tab:AddLeftGroupbox(T("Session dashboard", "สถานะเซสชัน"), "chart")
        dashboard.Level = statusBox:AddStatCard({ Title = T("Level", "เลเวล"), Value = "—", Icon = "level-up", Status = "Waiting" })
        dashboard.Coins = statusBox:AddStatCard({ Title = T("Coins", "เหรียญ"), Value = "—", Icon = "coin-stack", Status = "Waiting" })
        dashboard.Rebirth = statusBox:AddStatCard({ Title = T("Rebirth", "รีเบิร์ธ"), Value = "—", Icon = "rebirth", Status = "Waiting" })
        local activity = tab:AddRightGroupbox(T("Live activity", "งานปัจจุบัน"), "signal")
        dashboard.Task = activity:AddStatCard({ Title = T("Current task", "งานปัจจุบัน"), Value = "Idle", Icon = "clock", Status = "Off" })
        dashboard.Gear = activity:AddStatCard({ Title = T("Equipped gear", "อุปกรณ์ที่ใส่"), Value = "—", Icon = "armor", Status = "Waiting", Multiline = true })
        dashboard.Tower = activity:AddStatCard({ Title = T("Tower loot", "ของจากหอคอย"), Value = "0", Icon = "chest", Status = "Off" })
        activityLabel = activity:AddLabel(T("• Off / No active features", "• ปิด / ไม่มีงาน", "• Mati / Tidak ada fitur aktif"), true)

        local kaitunBox = tab:AddLeftGroupbox(T("Kaitun", "ไก่ตัน"), "robot-work")
        kaitunBox:AddToggle("Kaitun", {
            Text = T("Kaitun (All-in-one)", "ไก่ตัน (ทำทุกอย่าง)"),
            Description = T("Best gear, money, level, rewards and bosses all at once", "ของดีสุด เงิน เลเวล รางวัล และบอส ทำพร้อมกันทั้งหมด"),
            NoSave = true,
            Callback = function(value)
                for _, key in ipairs(Config.KaitunToggles) do
                    if Options[key] then Options[key]:SetValue(value) end
                end
            end,
        })
        kaitunBox:AddButton({ Text = T("Panic - All Off", "ฉุกเฉิน ปิดทั้งหมด"), Style = "Danger", Func = function()
            AllOff()
        end })

        local gearBox = tab:AddRightGroupbox(T("Max Gear", "อุปกรณ์สูงสุด"), "crown")
        Feature(gearBox, "MaxGear", T("Max Gear", "อุปกรณ์สูงสุด"),
            T("Best gear and runes, enhanced to your target. Finds anything missing by itself", "ของดีสุด รูนดีสุด ตีบวกถึงเป้า ขาดอะไรหาเองหมด"),
            function()
                State.GearForged = false
            end)
        Check(gearBox, "GearForge", T("Forge best gear", "หลอมของดีสุด"))
        Check(gearBox, "GearEnchant", T("Best runes", "ใส่รูนดีสุด"))
        Check(gearBox, "GearEnhance", T("Enhance", "ตีบวก"))
        gearBox:AddSlider("EnhanceTarget", {
            Text = T("Enhance Target", "ตีบวกถึง"),
            Description = T("Above +10 the success rate gets very low and can take a long time", "เกิน +10 โอกาสสำเร็จต่ำมาก อาจใช้เวลานาน"),
            Min = 5, Max = 20, Default = opt.EnhanceTarget, Rounding = 0, Prefix = "+",
            Callback = function(value)
                opt.EnhanceTarget = value
            end,
        })
        local runes = Jeaneism.Gear.RuneOrder()
        opt.EnchantPriority = table.clone(runes)
        gearBox:AddDropdown("EnchantPriority", {
            Text = T("Runes To Use", "รูนที่ใช้"),
            Description = T("Stronger runes go in first", "รูนที่แรงกว่าใส่ก่อน"),
            Values = runes,
            Multi = true,
            Default = runes,
            Searchable = #runes > 8,
            Callback = function(selected)
                local order = {}
                for _, stoneId in ipairs(runes) do
                    if selected[stoneId] then order[#order + 1] = stoneId end
                end
                if #order == 0 then Notify("No rune selected, using all runes", "Warning") end
                opt.EnchantPriority = order
            end,
        })

        local equipBox = tab:AddLeftGroupbox(T("Equip", "ใส่ของ"), "armor")
        Feature(equipBox, "AutoEquip", T("Auto Equip Best", "ใส่ของดีสุดอัตโนมัติ"), T("Always wears your strongest weapon, armor and hat, counting enhance level", "ใส่อาวุธ เกราะ และหมวกที่แรงที่สุดเสมอ นับระดับตีบวกด้วย"))
        equipBox:AddButton({ Text = T("Equip Best Now", "ใส่ของดีสุดเดี๋ยวนี้"), Func = function()
            task.defer(function()
                local changed = Jeaneism.Gear.EquipBest()
                Notify(changed > 0 and ("Equipped %d better item(s)"):format(changed) or "Already wearing your best gear")
            end)
        end })

        equipBox:AddDivider()
        equipBox:AddDropdown("EnhanceSlot", {
            Text = T("Enhance Slot", "ช่องที่ตีบวก"),
            Values = Config.GearTypes,
            Default = opt.EnhanceSlot,
            Callback = function(value)
                opt.EnhanceSlot = value or opt.EnhanceSlot
            end,
        })
        equipBox:AddButton({ Text = T("Enhance To Target", "ตีบวกถึงเป้า"), Style = "Primary", Func = LongAction("Enhance", function()
            return Jeaneism.Gear.EnhanceSlot(opt.EnhanceSlot, opt.EnhanceTarget)
        end, function(level) return level and ("%s is +%d"):format(opt.EnhanceSlot, level) or "Nothing equipped there" end) })

        local rewardBox = tab:AddRightGroupbox(T("Rewards", "รางวัล"), "chest-open")
        Feature(rewardBox, "AutoClaim", T("Auto Claim", "รับรางวัลอัตโนมัติ"), T("Claims every free reward, including index", "รับรางวัลฟรีทุกอย่าง รวมสมุดสะสม"))
        rewardBox:AddButton({ Text = T("Claim Now", "รับเดี๋ยวนี้"), Style = "Success", Func = Action(Jeaneism.Claim.All) })
        rewardBox:AddButton({ Text = T("Redeem All Codes", "ใช้โค้ดทั้งหมด"), Style = "Primary", Func = Action(function()
            Notify(Jeaneism.Claim.AllCodes(), "Success", 6)
        end) })
        rewardBox:AddInput("Code", {
            Text = T("Redeem Code", "ใส่โค้ด"),
            Placeholder = T("Code", "โค้ด"),
            Finished = true,
            NoSave = true,
            Callback = function(value)
                if value == "" then return end
                task.defer(function()
                    Notify("Code: " .. tostring(Jeaneism.Claim.Code(value)))
                end)
            end,
        })
    end

    local function BuildFarm(tab)
        local stageBox = tab:AddLeftGroupbox(T("Stage", "ด่าน"), "map-scroll")
        Pick(stageBox, "Stage", T("Stage", "ด่าน"), T("Any stage, no unlock needed", "เลือกด่านไหนก็ได้ ไม่ต้องปลดล็อก"), Jeaneism.Stage.List)
        Feature(stageBox, "CollectOre", T("Auto Collect Ore", "เก็บแร่อัตโนมัติ"), Library:T("Fast parallel pickups; retries unfinished ore before the next round", "เก็บแร่พร้อมกันและลองแร่ที่ยังไม่สำเร็จก่อนรอบใหม่", "Pickup paralel cepat; retry ore yang gagal sebelum ronde baru"), function(value)
            if value then Jeaneism.Stage.StartCollecting() end
        end)
        stageBox:AddToggle("FarmAllOres", {Text=Library:T("Collect all ore (ignore rarity filter)", "เก็บแร่ทั้งหมด (ไม่กรองความหายาก)", "Ambil semua ore (abaikan filter rarity)"), Default=opt.FarmAllOres, Callback=function(value) opt.FarmAllOres=value end})
        stageBox:AddSlider("FarmWorkers", {Text=Library:T("Ore pickup workers", "จำนวนตัวเก็บแร่", "Worker pengambil ore"), Min=1, Max=32, Default=opt.FarmWorkers, Rounding=0, Callback=function(value) opt.FarmWorkers=value end})
        MultiSelect(stageBox, "CollectRarities", T("Ore Rarity Filter", "กรอง rarity แร่"), T("Only collect these rarities", "เก็บเฉพาะ rarity ที่เลือก"), rarityNames)

        local combatBox = tab:AddLeftGroupbox(T("Combat", "ต่อสู้"), "sword")
        local killAura = Feature(combatBox, "KillAura", T("Kill Aura", "ฆ่ารอบตัว"), T("Every monster in your fight dies instantly", "มอนสเตอร์ทุกตัวในการต่อสู้ตายทันที"), function(value)
            if value then Jeaneism.Combat.Start() end
        end)
        NeedModule(killAura, ReplicatedStorage.Utils.CommunicationUtils)
        Feature(combatBox, "SuperLootAura", T("Kill Ore Boss", "ฆ่าบอสแร่"), T("Kills rare ore bosses the moment they spawn", "ฆ่าบอสแร่หายากทันทีที่เกิด"), function(value)
            if value then Jeaneism.SuperLoot.KillExisting() end
        end)
        combatBox:AddButton({ Text = T("Exit Fight Now", "ออกจากการต่อสู้เดี๋ยวนี้"), Style = "Warning", Func = Action(Jeaneism.Stage.ExitFight) })

        local bossBox = tab:AddRightGroupbox(T("World Boss", "บอสโลก"), "boss")
        Feature(bossBox, "AutoWorldBoss", T("Auto World Boss", "บอสโลกอัตโนมัติ"), T("Joins every world boss and kills it", "เข้าบอสโลกทุกรอบแล้วฆ่า"), function(value)
            if not value and LocalPlayer:GetAttribute("IntoFight") == "WorldBoss" then task.spawn(Jeaneism.Util.Try, Jeaneism.Boss.Leave) end
        end)
        Check(bossBox, "BossCards", T("Take every reward card", "เปิดการ์ดรางวัลทุกใบ"))
        Feature(bossBox, "BossHop", T("Boss Server Hop", "ย้ายเซิร์ฟหาบอส"), T("Hops to servers where the boss is up or about to spawn, kills it, then moves on", "ย้ายไปเซิร์ฟที่บอสเกิดอยู่หรือใกล้เกิด ฆ่าแล้วย้ายต่อ"), function(value)
            Jeaneism.Boss.HopFlag(value)
            if value and Options.AutoWorldBoss and not Options.AutoWorldBoss.Value then Options.AutoWorldBoss:SetValue(true) end
        end, true)

        local indexBox = tab:AddRightGroupbox(T("Index", "สมุดสะสม"), "book")
        MultiSelect(indexBox, "IndexTypes", T("Index Types", "ประเภทที่จะเก็บ"), nil, Config.GearTypes)
        Pick(indexBox, "MissingItem", T("Missing Item", "ของที่ยังไม่มี"), T("Chance shown is per forge with the best ore", "เปอร์เซ็นต์ = โอกาสต่อการหลอมหนึ่งครั้งด้วยแร่ที่ดีที่สุด"), function()
            return { "..." }
        end, true)
        task.defer(function()
            local ok, labels = pcall(Jeaneism.Index.Choices)
            if ok then
                Later(SetList, "MissingItem", labels, true)
            else
                warn("[LootToForge] index list:", labels)
            end
        end)
        indexBox:AddButton({ Text = T("Get Selected", "หาชิ้นนี้"), Style = "Primary", Func = LongAction("Index", function()
            local gear = State.MissingLabels[opt.MissingItem]
            return gear and Jeaneism.Index.Hunt(gear)
        end, function(got)
            Later(SetList, "MissingItem", (Source(Jeaneism.Index.Choices)))
            return got and "Got it!" or "Not found this time, press again"
        end) }):AddButton(RefreshButton("MissingItem", Jeaneism.Index.Choices))
        Feature(indexBox, "AutoIndex", T("Auto Complete Index", "เก็บสมุดสะสมอัตโนมัติ"), T("Forges every missing weapon, armor and hat, then claims rewards", "หลอมอาวุธ เกราะ หมวกที่ยังไม่มีทุกชิ้น แล้วรับรางวัล"), nil, true)
        indexBox:AddButton({ Text = T("Collect All Ores", "เก็บแร่ทุกชนิด"), Func = LongAction("Ores", Jeaneism.Index.CollectOres, function()
            local count, level = Jeaneism.Index.Progress()
            return ("Index %d, level %d"):format(count, level)
        end) }):AddButton({ Text = T("Claim Rewards", "รับรางวัล"), Style = "Success", Func = Action(Jeaneism.Index.ClaimAll) })
    end

    local function BuildForge(tab)
        local forgeBox = tab:AddLeftGroupbox(T("Forge", "หลอม"), "anvil")
        local targetNames = {}
        for _, target in ipairs(Config.ForgeTargets) do
            targetNames[#targetNames + 1] = target.name
        end
        forgeBox:AddDropdown("ForgeTarget", {
            Text = T("Target Gear", "อุปกรณ์ที่จะหลอม"),
            Values = targetNames,
            Default = 1,
            Callback = function(value)
                opt.ForgeTarget = value or opt.ForgeTarget
            end,
        })
        Pick(forgeBox, "ForgeOre", T("Ore To Use", "แร่ที่ใช้หลอม"), T("Pick an ore and it never runs out", "เลือกแร่แล้วไม่มีวันหมด"), Jeaneism.Ore.ForgeChoices, nil, true)
        Feature(forgeBox, "AutoForge", T("Auto Forge", "หลอมอัตโนมัติ"), T("Forges the target gear nonstop", "หลอมอุปกรณ์ที่เลือกไม่หยุด"))
        forgeBox:AddButton({ Text = T("Forge Now", "หลอมเดี๋ยวนี้"), Style = "Primary", Func = Action(Jeaneism.Forge.Step, "Forge") })
        forgeBox:AddSlider("ForgePerTick", {
            Text = T("Forges Per Round", "หลอมต่อรอบ"),
            Min = 1, Max = 50, Default = opt.ForgePerTick, Rounding = 0,
            Callback = function(value)
                opt.ForgePerTick = value
            end,
        })
        Check(forgeBox, "ForgeSellJunk", T("Sell worse gear right away", "ขายของที่แย่กว่าที่ใส่ทันที"))

        local oreUseBox = tab:AddRightGroupbox(T("Ore Usage", "การใช้แร่"), "ore")
        oreUseBox:AddLabel(T("Used when Ore To Use is Owned ores", "ใช้ตอนแร่ที่ใช้หลอม = Owned ores"))
        Toggle(oreUseBox, "BestOreFirst", T("Spend Best Ore First", "ใช้แร่ดีสุดก่อน"), T("Off = spend the weakest ore first", "ปิด = ใช้แร่ที่อ่อนที่สุดก่อน"))
        MultiSelect(oreUseBox, "ForgeRarities", T("Forge Ore Rarity", "rarity แร่ที่ใช้หลอม"), T("Only these ore rarities are used for forging", "ใช้แร่เฉพาะ rarity ที่เลือกในการหลอม"), rarityNames)
        NumberInput(oreUseBox, "KeepPerOre", T("Keep Per Ore", "เก็บแร่ไว้ชนิดละ"), T("Never forge below this amount of each ore", "ไม่หลอมจนแร่แต่ละชนิดต่ำกว่าจำนวนนี้"))
    end

    local function BuildSell(tab)
        local sellBox = tab:AddLeftGroupbox(T("Auto Sell", "ขายอัตโนมัติ"), "coinbag")
        Feature(sellBox, "AutoSell", T("Auto Sell", "ขายอัตโนมัติ"), T("Sells gear that matches your filters. Equipped gear is never sold", "ขายอุปกรณ์ที่ตรงตัวกรอง ของที่ใส่อยู่จะไม่ขาย"))
        sellBox:AddButton({ Text = T("Sell All Now", "ขายทั้งหมดเดี๋ยวนี้"), Style = "Primary", Func = Action(function()
            Jeaneism.Sell.Run(Jeaneism.Data.Get())
            Notify("Sold", "Coin")
        end) })

        local filterBox = tab:AddRightGroupbox(T("Filters", "ตัวกรอง"), "filter")
        MultiSelect(filterBox, "SellTypes", T("Sell Item Types", "ประเภทที่จะขาย"), nil, Config.GearTypes)
        MultiSelect(filterBox, "SellRarities", T("Sell Rarity Filter", "กรอง rarity ที่จะขาย"), T("Only sell these rarities", "ขายเฉพาะ rarity ที่เลือก"), rarityNames)
        NumberInput(filterBox, "KeepPerItem", T("Keep Per Item", "เก็บไว้ชิ้นละ"), T("Keeps this many of each item, highest enhance first", "เก็บแต่ละไอเทมไว้ตามจำนวนนี้ เลือกตัวตีบวกสูงสุดก่อน"))
    end

    local function BuildProgress(tab)
        local trainBox = tab:AddLeftGroupbox(T("Training", "ฝึก"), "xp")
        Feature(trainBox, "AutoTrain", T("Auto Train", "ฝึกอัตโนมัติ"), T("Trains at the best area nonstop and drinks your potions", "ฝึกโซนดีสุดไม่หยุด ใช้ยาให้เอง"), function(value)
            task.spawn(Jeaneism.Util.Try, Jeaneism.Level.SetTraining, value)
        end)
        local autoClick = Feature(trainBox, "AutoClick", T("Auto Click", "คลิกอัตโนมัติ"), Library:T("Steady training clicks; pauses while typing or respawning", "คลิกฝึกสม่ำเสมอ หยุดตอนพิมพ์หรือเกิดใหม่", "Klik latihan stabil; jeda saat mengetik atau respawn"), function(value)
            if value then Jeaneism.Level.StartClicking() end
        end)
        NeedModule(autoClick, ReplicatedStorage.CTRL.TrainCTRL)
        trainBox:AddSlider("ClickRate",{Text=Library:T("Clicks per second","คลิกต่อวินาที","Klik per detik"),Min=1,Max=25,Default=opt.ClickRate,Rounding=0,Callback=function(value) opt.ClickRate=value end})
        trainBox:AddToggle("ClickPauseTyping",{Text=Library:T("Pause while typing","หยุดขณะพิมพ์","Jeda saat mengetik"),Default=opt.ClickPauseTyping,Callback=function(value) opt.ClickPauseTyping=value end})
        Feature(trainBox, "AutoRebirth", T("Auto Rebirth", "รีเบิร์ธอัตโนมัติ"), T("Rebirths as soon as your level is high enough", "รีเบิร์ธทันทีเมื่อเลเวลถึง"))
        trainBox:AddButton({ Text = T("Rebirth Now", "รีเบิร์ธเดี๋ยวนี้"), Func = Action(Jeaneism.Level.Rebirth) })

        local upgradeBox = tab:AddRightGroupbox(T("Upgrades", "อัปเกรด"), "level-up")
        MultiSelect(upgradeBox, "Upgrades", T("Upgrades To Buy", "อัปเกรดที่จะซื้อ"), nil, (Source(Jeaneism.Upgrade.Names)))
        Feature(upgradeBox, "AutoUpgrade", T("Auto Buy Upgrades", "ซื้ออัปเกรดอัตโนมัติ"), T("Buys the selected upgrades whenever possible", "ซื้ออัปเกรดที่เลือกทุกครั้งที่ซื้อได้"))
        upgradeBox:AddButton({ Text = T("Buy Upgrade Now", "ซื้ออัปเกรดเดี๋ยวนี้"), Func = Action(Jeaneism.Upgrade.BuySelected) })
    end

    local function BuildTower(tab)
        local towerBox = tab:AddLeftGroupbox(T("Tower", "หอคอย"), "tower")
        Feature(towerBox, "AutoTower", T("Auto Farm Tower", "ฟาร์มหอคอยอัตโนมัติ"), T("Top floor loot nonstop on one ticket: rare stones and season coins", "ของชั้นบนสุดไม่หยุดด้วยตั๋วใบเดียว ได้หินหายากและเหรียญซีซั่น"), function(value)
            task.defer(function()
                if not value then return Jeaneism.Util.Try(Jeaneism.Tower.Exit) end
                if not Jeaneism.Tower.Enter() then Notify("No tower ticket", "Warning") end
            end)
        end)
        towerBox:AddButton({ Text = T("Exit Tower Now", "ออกจากหอคอยเดี๋ยวนี้"), Style = "Warning", Func = function()
            Options.AutoTower:SetValue(false)
            task.spawn(Jeaneism.Util.Try, Jeaneism.Tower.Exit)
        end })

        local seasonBox = tab:AddRightGroupbox(T("Season", "ซีซั่น"), "star-medal")
        local goodLabels, goodIds = Source(Jeaneism.Season.Goods)
        local goodDefault = {}
        for label, goodId in pairs(goodIds) do
            if opt.SeasonGoods[goodId] then table.insert(goodDefault, label) end
        end
        Feature(seasonBox, "AutoSeason", T("Auto Season", "ซีซั่นอัตโนมัติ"), T("Daily ticket, pass rewards, spins and shop", "ตั๋วรายวัน รางวัลพาส สุ่ม และร้าน"))
        seasonBox:AddButton({ Text = T("Season Now", "ซีซั่นเดี๋ยวนี้"), Func = Action(Jeaneism.Season.Step) })
        Check(seasonBox, "SeasonSpin", T("Spin every ticket", "สุ่มตั๋วทุกใบ"))
        seasonBox:AddDropdown("SeasonGoods", {
            Text = T("Shop Items To Buy", "ของในร้านที่จะซื้อ"),
            Values = goodLabels,
            Multi = true,
            Default = goodDefault,
            Searchable = #goodLabels > 8,
            Callback = function(selected)
                local wanted = {}
                for label, on in pairs(selected) do
                    if on and goodIds[label] then wanted[goodIds[label]] = true end
                end
                opt.SeasonGoods = wanted
            end,
        })
    end

    local function BuildSpawn(tab)
        local spawnBox = tab:AddLeftGroupbox(T("Spawn Items", "เสกของ"), "bag", "OP")
        Pick(spawnBox, "SpawnItem", T("Item", "ของ"), T("Ores, runes, scrolls, tickets and stones. Runes and materials need at least one owned", "แร่ รูน สกรอล ตั๋ว และหิน รูนกับวัตถุดิบต้องมีอย่างน้อย 1 ชิ้น"), Jeaneism.Spawn.Choices, true, true)
        NumberInput(spawnBox, "SpawnAmount", T("Amount", "จำนวน"), nil, 1)
        spawnBox:AddButton({ Text = T("Spawn", "เสก"), Style = "Primary", Func = function()
            local picked = State.SpawnLabels[opt.SpawnItem]
            if not picked then return Notify("Pick an item first", "Warning") end
            local label, amount = opt.SpawnItem, opt.SpawnAmount
            task.defer(function()
                local ok = Jeaneism.Spawn.Give(picked.id, picked.kind, amount)
                Notify(ok and ("Added %s %s"):format(Jeaneism.Util.Abbreviate(amount), label) or "You need at least one of this item first", ok and "Success" or "Warning")
            end)
        end }):AddButton(RefreshButton("SpawnItem", Jeaneism.Spawn.Choices))
        spawnBox:AddButton({ Text = T("Dupe Whole Inventory", "ปั๊มของทั้งกระเป๋า"), Risky = true, Func = function()
            local amount = opt.SpawnAmount
            task.defer(function()
                local touched = Jeaneism.Spawn.DupeAll(amount)
                Notify(("Added %s to %d stacks"):format(Jeaneism.Util.Abbreviate(amount), touched), touched > 0 and "Success" or "Warning")
            end)
        end })

        local gearBox = tab:AddLeftGroupbox(T("Spawn Gear", "เสกอาวุธและชุด"), "helmet", "OP")
        local function LoadGearList(slot)
            task.defer(function()
                local ok, labels = pcall(Jeaneism.Spawn.GearChoices, slot)
                if ok then
                    Later(SetList, "SpawnGear", labels, true)
                else
                    warn("[LootToForge] gear list:", labels)
                end
            end)
        end
        opt.GearSlot = Config.GearTypes[1]
        gearBox:AddDropdown("GearSlot", {
            Text = T("Type", "ประเภท"),
            Values = Config.GearTypes,
            Default = 1,
            NoSave = true,
            Callback = function(value)
                opt.GearSlot = value
                LoadGearList(value)
            end,
        })
        opt.SpawnGear = nil
        gearBox:AddDropdown("SpawnGear", {
            Text = T("Gear", "อุปกรณ์"),
            Description = T("Strongest first. Exclusive gear is shop only", "แรงสุดอยู่บน ของ Exclusive มีแค่ในร้าน"),
            Values = { "..." },
            Default = 1,
            Searchable = true,
            NoSave = true,
            Callback = function(value)
                opt.SpawnGear = value
            end,
        })
        LoadGearList(opt.GearSlot)
        NumberInput(gearBox, "GearCopies", T("Copies", "จำนวนชิ้น"), nil, 1)
        gearBox:AddButton({ Text = T("Spawn Gear", "เสกอุปกรณ์"), Style = "Primary", Func = LongAction("Index", function()
            local gear = State.GearLabels[opt.SpawnGear]
            return gear and Jeaneism.Index.Hunt(gear, math.max(1, math.floor(opt.GearCopies)))
        end, function(got)
            return got and "Spawned!" or "Not all copies this time, press again"
        end) })
        gearBox:AddButton({ Text = T("Buy Exclusive Gear", "ซื้อของ Exclusive"), Func = LongAction("Tower", Jeaneism.Season.BuyExclusive, function(bought)
            return (bought or 0) > 0 and ("Bought %d exclusive pieces"):format(bought) or "Already bought this refresh"
        end) })

        local potionBox = tab:AddRightGroupbox(T("Potions", "ยา"), "potion", "OP")
        potionBox:AddButton({ Text = T("Max Potion Buffs", "บัฟยาเต็มทั้งปี"), Style = "Primary", Func = LongAction("Potion", Jeaneism.Potion.MaxBuffs, function(count)
            return (count or 0) > 0 and ("%d potion buffs active for about a year"):format(count) or "Own at least one potion first"
        end) })
        potionBox:AddButton({ Text = T("Add 100K Potions", "เพิ่มยา 100K ขวด"), Func = Action(function()
            for _, potionId in ipairs(Jeaneism.Potion.Owned()) do
                Jeaneism.Potion.Add(potionId, Config.PotionStack)
            end
        end) })

        local coinBox = tab:AddRightGroupbox(T("Season Coins", "เหรียญซีซั่น"), "coin-stack", "OP")
        NumberInput(coinBox, "CoinTarget", T("Amount", "จำนวน"), nil, 1)
        coinBox:AddButton({ Text = T("Add Season Coins", "เพิ่มเหรียญซีซั่น"), Style = "Primary", Func = LongAction("Tower", function()
            return Jeaneism.Tower.FarmCoins(opt.CoinTarget)
        end, function(gained) return ("+%s season coins"):format(Jeaneism.Util.Abbreviate(gained or 0)) end) })

        local stoneBox = tab:AddRightGroupbox(T("Enhance Stones", "หินตีบวก"))
        stoneBox:AddButton({ Text = T("Farm Enhance Stones", "ฟาร์มหินตีบวก"), Style = "Primary", Func = LongAction("Stones", function()
            local before = Jeaneism.Data.Count(Jeaneism.Data.Get(), "EnhantStone_1")
            Jeaneism.Stage.FarmStones(Jeaneism.Stage.Best())
            task.wait(0.5)
            return Jeaneism.Data.Count(Jeaneism.Data.Get(), "EnhantStone_1") - before
        end, function(gained) return ("+%d enhance stones"):format(gained or 0) end) })
        stoneBox:AddButton({ Text = T("Farm Rare Stones", "ฟาร์มหินตีบวกหายาก"), Func = LongAction("Tower", function()
            local before = Jeaneism.Data.Count(Jeaneism.Data.Get(), "EnhantStone_2")
            Jeaneism.Tower.FarmStep()
            task.wait(0.5)
            return Jeaneism.Data.Count(Jeaneism.Data.Get(), "EnhantStone_2") - before
        end, function(gained) return ("+%d rare stones"):format(gained or 0) end) })
    end

    local function BuildPlayer(tab)
        local raceBox = tab:AddLeftGroupbox(T("Race", "เผ่า"), "robot-idle")
        local raceLabels, raceIds = Source(Jeaneism.Race.Choices)
        opt.TargetRace = raceIds[raceLabels[1]]
        raceBox:AddDropdown("TargetRace", {
            Text = T("Target Race", "เผ่าที่ต้องการ"),
            Values = raceLabels,
            Default = 1,
            Searchable = #raceLabels > 8,
            Callback = function(value)
                opt.TargetRace = raceIds[value]
            end,
        })
        Feature(raceBox, "AutoRace", T("Auto Roll Race", "สุ่มเผ่าอัตโนมัติ"), T("Uses your race rolls until you get the chosen race", "สุ่มเผ่าจนกว่าจะได้เผ่าที่เลือก"), function(value)
            if not value or State.Rolling then return end
            State.Rolling = true
            task.defer(function()
                local ok, outcome = pcall(Jeaneism.Race.RollUntil, opt.TargetRace)
                State.Rolling = false
                if ok and outcome == "got" then
                    Notify("Got the race!", "Success")
                elseif ok and outcome == "empty" then
                    Notify("No race rolls left", "Warning")
                elseif ok and outcome == "target" then
                    Notify("Pick a race first", "Warning")
                end
                Later(TurnOff, "AutoRace")
            end)
        end)
        Feature(raceBox, "AutoBestRace", T("Use Best Race Slot", "ใช้ช่องเผ่าที่ดีสุด"), T("Switches to your rarest race", "สลับไปใช้เผ่าที่หายากที่สุด"))
        raceBox:AddButton({ Text = T("Switch Now", "สลับเดี๋ยวนี้"), Func = Action(function()
            Notify(Jeaneism.Race.EquipBest() and "Switched race slot" or "Already on your best race")
        end) })

        local moveBox = tab:AddRightGroupbox(T("Movement", "การเคลื่อนที่"), "speed")
        HotkeyFeature(moveBox, "SpeedOn", T("Speed", "ความเร็ว"), nil, Jeaneism.Movement.Apply)
        moveBox:AddSlider("WalkSpeed", {
            Text = T("Walk Speed", "ความเร็วเดิน"),
            Min = 16, Max = 200, Default = opt.WalkSpeed, Rounding = 0,
            Callback = function(value)
                opt.WalkSpeed = value
                Jeaneism.Movement.Apply()
            end,
        })
        HotkeyFeature(moveBox, "InfJump", T("Infinite Jump", "กระโดดไม่จำกัด"))

        local guardBox = tab:AddRightGroupbox(T("Survival", "เอาตัวรอด"), "health")
        local godMode = Feature(guardBox, "GodMode", T("Invincible", "อมตะ"), T("Monsters and bosses can't kill you", "มอนสเตอร์และบอสฆ่าไม่ตาย"), function(value)
            if not value then
                if State.RestoreDamage then State.RestoreDamage() end
            elseif not Jeaneism.Guard.HookDamage() then
                Notify("Invincible is not available on this executor", "Warning")
                task.defer(TurnOff, "GodMode")
            end
        end)
        NeedModule(godMode, ReplicatedStorage.CTRL.HPCTRL)
        local keepOre = Feature(guardBox, "KeepOre", T("Keep Ore On Death", "ตายแล้วแร่ไม่หาย"), nil, function(value)
            if not value then
                Jeaneism.Guard.UnhookOreLoss()
            elseif not Jeaneism.Guard.HookOreLoss() then
                Notify("Keep Ore On Death is not supported on this executor", "Warning")
                task.defer(TurnOff, "KeepOre")
            end
        end)
        Jeaneism.Compat.NeedCap(keepOre, "Namecall")
    end

    local function BuildSettings(window)
        local settingsTab = window:AddSettingsTab()
        local discordBox = settingsTab:AddRightGroupbox(T("Website", "เว็บไซต์"), "link-chain")
        discordBox:AddLabel(Config.Website)
        discordBox:AddButton({ Text = T("Copy Website Link", "คัดลอกลิงก์เว็บไซต์"), Style = "Primary", Func = function()
            local copy = setclipboard or toclipboard
            if copy then copy(Config.Website) end
            Notify(copy and "Website link copied" or Config.Website)
        end })

        local logBox = settingsTab:AddRightGroupbox(T("Update Log", "อัปเดตล่าสุด"), "bell")
        for i = 1, math.min(2, #Config.UpdateLog) do
            local entry = Config.UpdateLog[i]
            logBox:AddParagraph({ Title = entry[1], Content = entry[2] })
        end

        local sessionBox = settingsTab:AddRightGroupbox(T("Session", "เซสชัน"))
        Toggle(sessionBox, "AutoRejoin", T("Auto Rejoin", "เข้าเกมใหม่อัตโนมัติ"), T("Rejoins the game by itself after a disconnect", "หลุดแล้วเข้าเกมใหม่เอง"))
        Toggle(sessionBox, "LowGraphics", T("FPS Boost", "เพิ่ม FPS"), T("Turns off 3D rendering to save CPU and GPU", "ปิดการแสดงผล 3D ประหยัด CPU/GPU"), Jeaneism.Session.SetLowGraphics)
        sessionBox:AddButton({ Text = T("Rejoin Now", "เข้าเกมใหม่เดี๋ยวนี้"), Func = Action(Jeaneism.Session.Rejoin) })
    end

    local noteText = {
        EnhantStone_1 = "farming enhance stones",
        EnhantStone_2 = "farming rare enhance stones",
        Coin = "farming coins",
        Enhancing = "enhancing",
        NoTicket = "need a tower ticket",
        Done = "all at target",
    }

    local function TaskText()
        if State.Lock == "Index" then return Library:Translate("Index") .. " " .. Library:Translate(State.IndexNote or "planning") end
        if State.Lock then return Library:Translate(State.Lock) end
        if opt.MaxGear then return Library:Translate("Max Gear") .. ", " .. Library:Translate(noteText[State.GearNote] or "starting") end
        return "Idle"
    end

    local function UpdateStatus()
        if not dashboard.Level then return end
        local ok, profile = pcall(Jeaneism.Data.Get)
        if not State.Alive then return end
        if not (ok and profile and profile.Eco) then
            Later(dashboard.Task.SetStatus, dashboard.Task, "Waiting", "Profile unavailable")
            Later(Library.Window.SetSessionStatus, Library.Window, "Waiting for profile", 0, "Waiting")
            return
        end
        local eco = profile.Eco
        local running = {}
        for key, name in pairs(featureNames) do
            if opt[key] then running[#running + 1] = Library:Translate(name) end
        end
        table.sort(running)
        local count = #running
        local task = TaskText()
        local waiting = opt.MaxGear and State.GearNote == "NoTicket"
        local status = waiting and "Waiting" or ((State.Lock or count > 0) and "Running" or "Off")
        Later(dashboard.Level.SetValue, dashboard.Level, eco.level)
        Later(dashboard.Level.SetStatus, dashboard.Level, "Success", "Current")
        Later(dashboard.Coins.SetValue, dashboard.Coins, Jeaneism.Util.Abbreviate(eco.coin))
        Later(dashboard.Coins.SetStatus, dashboard.Coins, "Success", "Current")
        Later(dashboard.Rebirth.SetValue, dashboard.Rebirth, eco.rebirth)
        Later(dashboard.Rebirth.SetStatus, dashboard.Rebirth, "Success", "Current")
        Later(dashboard.Gear.SetValue, dashboard.Gear, Jeaneism.Gear.EquippedNames(profile))
        Later(dashboard.Gear.SetStatus, dashboard.Gear, "Success", "Current")
        Later(dashboard.Task.SetValue, dashboard.Task, task)
        Later(dashboard.Task.SetStatus, dashboard.Task, status, Library:T(count .. " enabled", "เปิด " .. count, count .. " diaktifkan"))
        Later(dashboard.Tower.SetValue, dashboard.Tower, State.TowerLoot or 0)
        Later(dashboard.Tower.SetStatus, dashboard.Tower, "Success", "Collected")
        Later(activityLabel.SetText, activityLabel, count > 0 and (Library:Translate("Active features") .. " / " .. table.concat(running, "\n> ")) or Library:Translate("No active features"))
        Later(Library.Window.SetSessionStatus, Library.Window, task, count, status)
    end

    Library:OnLanguageChanged(function()
        if State.Alive and dashboard.Level then task.defer(UpdateStatus) end
    end)

    local function BuildTabs()
        local Window = Library.Window
        Window:AddTabSection(T("Farm", "ฟาร์ม"))
        local MainTab = Window:AddTab(T("Main", "หลัก"), "castle-gate", T("Status, all-in-one mode and rewards", "สถานะ โหมดทำทุกอย่าง และรางวัล"))
        local FarmTab = Window:AddTab(T("Combat & Farm", "ต่อสู้และฟาร์ม"), "sword", T("Stages, monsters, bosses and index", "ด่าน มอนสเตอร์ บอส และสมุดสะสม"))
        local ForgeTab = Window:AddTab(T("Forge", "หลอม"), "anvil", T("Forge gear from any ore", "หลอมอุปกรณ์จากแร่ไหนก็ได้"))
        local SellTab = Window:AddTab(T("Sell", "ขาย"), "coinbag", T("Sell gear by type and rarity", "ขายอุปกรณ์ตามประเภทและ rarity"))
        Window:AddTabSection(T("Progress", "ความคืบหน้า"))
        local ProgressTab = Window:AddTab(T("Upgrade & Rebirth", "อัปเกรดและรีเบิร์ธ"), "crown", T("Training, rebirth and upgrades", "ฝึก รีเบิร์ธ และอัปเกรด"))
        local TowerTab = Window:AddTab(T("Tower", "หอคอย"), "tower", T("Tower loot and season pass", "ของจากหอคอย และซีซั่นพาส"))
        local SpawnTab = Window:AddTab(T("Spawn Items", "เสกของ"), "chest-open", T("Ores, runes and enhance stones", "แร่ รูน และหินตีบวก"))
        Window:AddTabSection(T("Other", "อื่นๆ"))
        local PlayerTab = Window:AddTab(T("Player", "ผู้เล่น"), "compass", T("Race, movement and survival", "เผ่า การเคลื่อนที่ และเอาตัวรอด"))

        local sections = {
            { BuildMain, MainTab },
            { BuildFarm, FarmTab },
            { BuildForge, ForgeTab },
            { BuildSell, SellTab },
            { BuildProgress, ProgressTab },
            { BuildTower, TowerTab },
            { BuildSpawn, SpawnTab },
            { BuildPlayer, PlayerTab },
            { BuildSettings, Window },
        }
        for _, section in ipairs(sections) do
            Jeaneism.Util.Try(section[1], section[2])
        end
        Jeaneism.Util.Try(BlockMissing)

        Library:Every(Config.PumpInterval, Pump)
        task.spawn(function()
            while State.Alive do
                UpdateStatus()
                task.wait(Config.StatusInterval)
            end
        end)
    end

    local function Unload()
        Library:Unload()
    end
    Library:OnUnload(Jeaneism.Scheduler.Stop)
    Library:OnUnload(function()
        if getgenv().LootToForgeUnload == Unload then getgenv().LootToForgeUnload = nil end
    end)
    getgenv().LootToForgeUnload = Unload

    Library:CreateWindow({
        Title = "PixeL UI",
        Navigation = "Chunky",
        IntroDuration = 7.5,
        Watermark = false,
        Particles = false,
        SubTitle = "Loot To Forge · Jeaneism · 0x4.me",
        Owner = "Jeaneism",
        Website = "https://0x4.me",
        MenuKey = Enum.KeyCode.LeftControl,
        ConfigFolder = Config.SaveFolder,
        Language = "Auto",
        Theme = "Studio",
        AnimationIntensity = "Normal",
        AllOff = AllOff,
        OnUnlocked = function()
            BuildTabs()
            Jeaneism.Util.Try(Jeaneism.Scheduler.Boot)
            Notify("Loaded", "Success")
            Jeaneism.Util.Try(Library.LoadAutoloadConfig, Library)
            if Jeaneism.Boss.HopWanted() and Options.BossHop then Options.BossHop:SetValue(true) end
        end,
    })
end

if getgenv().LootToForgeUnload then
    pcall(getgenv().LootToForgeUnload)
end

pcall(PixeLBanner.Step, "Systems")
BuildInterface()
pcall(PixeLBanner.Step, "Interface")
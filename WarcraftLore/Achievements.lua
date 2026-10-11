-- Achievements.lua – the addon's own achievements (Blizzard's cannot be extended by addons).
-- Generated from the veteran data, so they grow with Data.lua. Earned ones are stored account-wide:
-- WarcraftLoreDB.achievements[id] = time earned.
--
--   ns.Achievements.List()   array of { id, title, desc, category, progress, total, done, earned, icon }
--   ns.Achievements.Counts() earned, total
--   ns.Achievements.Check()  stores and announces newly done ones; returns their ids

local _, ns = ...
local C = ns.Compat

local Achievements = {}
ns.Achievements = Achievements

local PREFIX = "|cff8b6cd6Warcraft Lore:|r "
local ICON = "Interface\\Icons\\"
local CATEGORY_ORDER = { "milestone", "game", "zone", "circle", "special" }
local MILESTONES = {
    { 1, "First Contact" }, { 10, "Old Soldiers" }, { 25, "Seasoned Traveller" },
    { 50, "Keeper of Lore" }, { 100, "Living Archive" },
}
local GAME_TITLE = {
    WC1 = "Where It Began", WC2 = "Tides of Darkness", BTDP = "Beyond the Portal",
    WC3 = "Heroes of Reign of Chaos", TFT = "Heroes of the Frozen Throne",
    FK = "The Forsaken Kingdom", BOOK = "Keeper of the Books",
}
local BOOK_STEPS = { { 25, "Bookworm" }, { 50, "Library Regular" } }
local MIN_GROUP = 3 -- smallest set that gets a game, zone or circle achievement

-- Static part: id, text, icon and the veterans that count. Built on first use.
local defs

local function add(list, d)
    list[#list + 1] = d
end

local function build()
    local list = {}
    local vets = ns.Veterans()
    local total = #vets

    for _, m in ipairs(MILESTONES) do
        if m[1] <= total then
            add(list, {
                id = "milestone_" .. m[1], title = m[2], category = "milestone", icon = ICON .. "Achievement_Level_10",
                desc = m[1] == 1 and "Meet your first veteran." or ("Meet %d veterans."):format(m[1]),
                total = m[1], all = true,
            })
        end
    end

    local perGame, perZone, zones = {}, {}, {}
    for _, g in ipairs(vets) do
        for _, code in ipairs(g.codes) do
            perGame[code] = perGame[code] or {}
            table.insert(perGame[code], g)
        end
        local seen = {}
        local function zone(z)
            if type(z) == "string" and z ~= "" and not seen[z] then
                seen[z] = true
                if not perZone[z] then
                    perZone[z] = {}
                    zones[#zones + 1] = z
                end
                table.insert(perZone[z], g)
            end
        end
        zone(g.entry.zone)
        for _, id in ipairs(g.ids) do
            for _, z in ipairs(ns.NPCS[id].alsoIn or {}) do
                zone(z)
            end
        end
    end

    local rtsCodes = {}
    for _, code in ipairs(ns.GAME_ORDER) do
        local members = perGame[code]
        if members then
            if code ~= "BOOK" then
                rtsCodes[#rtsCodes + 1] = code
            end
            if #members >= MIN_GROUP then
                local long = ns.GAME_LONG[code] or code
                if code == "BOOK" then
                    for _, step in ipairs(BOOK_STEPS) do
                        if step[1] < #members then
                            add(list, {
                                id = "game_BOOK_" .. step[1], title = step[2], category = "game", icon = ICON .. "INV_Misc_Book_09",
                                desc = ("Meet %d veterans from the Warcraft novels and books."):format(step[1]),
                                members = members, total = step[1],
                            })
                        end
                    end
                end
                add(list, {
                    id = "game_" .. code, title = GAME_TITLE[code] or long, category = "game", icon = ICON .. "INV_Misc_Book_09",
                    desc = code == "BOOK" and "Meet every veteran from the Warcraft novels and books."
                        or ("Meet every veteran from %s."):format(long),
                    members = members, total = #members,
                })
            end
        end
    end

    for _, z in ipairs(zones) do
        local members = perZone[z]
        if #members >= MIN_GROUP then
            add(list, {
                id = "zone_" .. z, title = "All of " .. z, category = "zone", icon = ICON .. "INV_Misc_Map_01",
                desc = ("Meet every veteran in %s."):format(z), members = members, total = #members,
            })
        end
    end

    for _, g in ipairs(vets) do
        local related = ns.Related(g.id)
        if #related >= MIN_GROUP then
            local members = { g }
            for _, r in ipairs(related) do
                members[#members + 1] = r
            end
            local name = g.entry.name or "?"
            add(list, {
                id = "circle_" .. g.id, title = name .. "'s Circle", category = "circle", icon = ICON .. "Achievement_Reputation_01",
                desc = ("Meet %s and everyone tied to them."):format(name), members = members, total = #members,
            })
        end
    end

    if #rtsCodes >= 2 then
        add(list, {
            id = "special_ages", title = "Across the Ages", category = "special", icon = ICON .. "INV_Misc_Spyglass_03",
            desc = "Meet a veteran from every Warcraft game.", codes = rtsCodes, total = #rtsCodes,
        })
    end

    local rank = {}
    for i, c in ipairs(CATEGORY_ORDER) do
        rank[c] = i
    end
    -- Stable: same data always gives the same order (milestones by size, the rest by title, then id).
    table.sort(list, function(a, b)
        if a.category ~= b.category then
            return rank[a.category] < rank[b.category]
        end
        if a.category == "milestone" then
            return a.total < b.total
        end
        if a.title ~= b.title then
            return a.title < b.title
        end
        return a.id < b.id
    end)
    return list
end

local function stored()
    local db = WarcraftLoreDB
    return db and type(db.achievements) == "table" and db.achievements or nil
end

function Achievements.List()
    if not defs then
        defs = build()
    end
    local earned = stored() or {}
    local metCache = {}
    local function met(g)
        local m = metCache[g]
        if m == nil then
            m = ns.GroupMet(g)
            metCache[g] = m
        end
        return m
    end
    local metTotal = 0
    for _, g in ipairs(ns.Veterans()) do
        if met(g) then
            metTotal = metTotal + 1
        end
    end
    local out = {}
    for i, d in ipairs(defs) do
        local progress = 0
        if d.all then
            progress = metTotal
        elseif d.members then
            for _, g in ipairs(d.members) do
                if met(g) then
                    progress = progress + 1
                end
            end
        elseif d.codes then
            local have = {}
            for _, g in ipairs(ns.Veterans()) do
                if met(g) then
                    for _, c in ipairs(g.codes) do
                        have[c] = true
                    end
                end
            end
            for _, code in ipairs(d.codes) do
                if have[code] then
                    progress = progress + 1
                end
            end
        end
        out[i] = {
            id = d.id, title = d.title, desc = d.desc, category = d.category, icon = d.icon,
            progress = math.min(progress, d.total), total = d.total, done = progress >= d.total,
            earned = tonumber(earned[d.id]),
        }
    end
    return out
end

function Achievements.Counts()
    local n, list = 0, Achievements.List()
    for _, a in ipairs(list) do
        if a.earned then
            n = n + 1
        end
    end
    return n, #list
end

local function announce(titles)
    local n = #titles
    if n == 0 then
        return
    end
    if n == 1 then
        C.Print(PREFIX .. "Achievement earned: " .. titles[1])
    else
        local shown = {}
        for i = 1, math.min(n, 3) do
            shown[i] = titles[i]
        end
        local text = table.concat(shown, ", ")
        if n > 3 then
            text = text .. (" and %d more"):format(n - 3)
        end
        C.Print(PREFIX .. ("%d achievements earned: %s"):format(n, text))
    end
    if ns.Toast and ns.Toast.ShowAchievement then
        pcall(ns.Toast.ShowAchievement, titles[1], n)
    end
    pcall(C.PlayAlertSound)
end

function Achievements.Check()
    local db = WarcraftLoreDB
    local store = stored()
    if not db or not store then
        return {} -- before ADDON_LOADED, or data from a newer version: left alone
    end
    local fresh, titles = {}, {}
    local now = time()
    for _, a in ipairs(Achievements.List()) do
        if a.done and not a.earned then
            store[a.id] = now
            fresh[#fresh + 1] = a.id
            titles[#titles + 1] = a.title
        end
    end
    if not db.achievementsSeeded then
        -- First run with this feature: what is already done is stored without announcing.
        db.achievementsSeeded = true
        if #fresh > 0 then
            C.Print(PREFIX .. ("you already have %d achievements \226\128\147 see /wcl journal."):format(#fresh))
        end
        return {}
    end
    announce(titles)
    return fresh
end

-- At login: seeds on the first run, otherwise stores anything the data made newly done, quietly
-- announced like any other. Runs once WarcraftLoreDB is loaded.
local events = CreateFrame("Frame")
if C.RegisterEventSafe(events, "PLAYER_LOGIN") then
    events:SetScript("OnEvent", function()
        pcall(Achievements.Check)
    end)
end

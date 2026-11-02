-- Achievements.lua – the addon's own achievements (Blizzard's cannot be extended by addons).
-- Generated from the veteran data, so they grow with Data.lua. Earned ones are stored account-wide:
-- WarcraftLoreDB.achievements[id] = time earned.
--
--   ns.Achievements.List()   array of { id, title, desc, category, progress, total, done, earned, icon, later }
--   ns.Achievements.Counts() earned, total, later (later ones are not in the total)
--   ns.Achievements.IsReachable(veteran)  false when every zone it is found in is above LEVEL_CAP
--   ns.Achievements.Check()  stores and announces newly done ones; returns their ids

local _, ns = ...
local C = ns.Compat
local L = ns.L

local Achievements = {}
ns.Achievements = Achievements

-- WoW Forever is capped at this player level for now. Raise it when the cap rises: veterans in
-- zones with a higher minimum level are "later" until then, and the achievements that need them wait.
-- Classic Era is at its final cap of 60, so nothing waits there.
local LEVEL_CAP = C.IsForever() == false and 60 or 30
Achievements.LEVEL_CAP = LEVEL_CAP

-- Minimum player level per zone or instance (Classic ranges). A zone that is not listed counts as 1.
local ZONE_LEVEL = {
    ["Elwynn Forest"] = 1, ["Durotar"] = 1, ["Mulgore"] = 1, ["Tirisfal Glades"] = 1, ["Dun Morogh"] = 1,
    ["Teldrassil"] = 1, ["Stormwind City"] = 1, ["Ironforge"] = 1, ["Orgrimmar"] = 1, ["Thunder Bluff"] = 1,
    ["Undercity"] = 1, ["Darnassus"] = 1, ["Moonglade"] = 1,
    ["Loch Modan"] = 10, ["Darkshore"] = 10, ["Silverpine Forest"] = 10, ["Westfall"] = 10, ["The Barrens"] = 10,
    ["Redridge Mountains"] = 15, ["Stonetalon Mountains"] = 15, ["Duskwood"] = 18, ["Ashenvale"] = 18,
    ["Wetlands"] = 20, ["Hillsbrad Foothills"] = 20, ["Thousand Needles"] = 25,
    ["Alterac Mountains"] = 30, ["Arathi Highlands"] = 30, ["Stranglethorn Vale"] = 30, ["Desolace"] = 30,
    ["Dustwallow Marsh"] = 35, ["Badlands"] = 35, ["Swamp of Sorrows"] = 35,
    ["Tanaris"] = 40, ["Feralas"] = 40, ["The Hinterlands"] = 40, ["Searing Gorge"] = 43, ["Azshara"] = 45,
    ["Blasted Lands"] = 45, ["Un'Goro Crater"] = 48, ["Felwood"] = 48, ["Burning Steppes"] = 50,
    ["Western Plaguelands"] = 51, ["Eastern Plaguelands"] = 53, ["Winterspring"] = 53, ["Silithus"] = 55,
    ["Deadwind Pass"] = 55,
    -- dungeons and raids
    ["Ragefire Chasm"] = 13, ["The Deadmines"] = 15, ["Wailing Caverns"] = 15, ["Shadowfang Keep"] = 18,
    ["Blackfathom Deeps"] = 20, ["The Stockade"] = 22, ["Gnomeregan"] = 24, ["Razorfen Kraul"] = 25,
    ["Scarlet Monastery"] = 26, ["Razorfen Downs"] = 37, ["Uldaman"] = 40, ["Zul'Farrak"] = 42,
    ["Maraudon"] = 45, ["Sunken Temple"] = 45, ["Blackrock Depths"] = 52, ["Lower Blackrock Spire"] = 55,
    ["Upper Blackrock Spire"] = 58, ["Dire Maul"] = 56, ["Scholomance"] = 58, ["Stratholme"] = 58,
    ["Molten Core"] = 60, ["Onyxia's Lair"] = 60, ["Blackwing Lair"] = 60, ["Ruins of Ahn'Qiraj"] = 60,
    ["Temple of Ahn'Qiraj"] = 60, ["Naxxramas"] = 60, ["Zul'Gurub"] = 60,
    -- battlegrounds
    ["Warsong Gulch"] = 10, ["Arathi Basin"] = 20, ["Alterac Valley"] = 51,
}
Achievements.ZONE_LEVEL = ZONE_LEVEL

local function zoneReachable(z)
    return (ZONE_LEVEL[z] or 1) <= LEVEL_CAP
end

-- A veteran can be met at the cap when any zone it is found in is open; no known zone = open.
local reachCache = {}
local function reachable(g)
    local r = reachCache[g]
    if r == nil then
        local any, open = false, false
        local function visit(z)
            if type(z) == "string" and z ~= "" then
                any = true
                if zoneReachable(z) then
                    open = true
                end
            end
        end
        visit(g.entry.zone)
        for _, id in ipairs(g.ids) do
            for _, z in ipairs(ns.NPCS[id].alsoIn or {}) do
                visit(z)
            end
        end
        r = open or not any
        reachCache[g] = r
    end
    return r
end
Achievements.IsReachable = reachable

local PREFIX = "|cff8b6cd6Warcraft Lore:|r "
local ICON = "Interface\\Icons\\"
local CATEGORY_ORDER = { "milestone", "game", "zone", "circle", "memorial", "special" }
-- The five plaques of the Valley of Heroes in Stormwind (keys in Memorials.lua).
local VALLEY_OF_HEROES = { "turalyon", "khadgar", "alleria", "danath", "kurdran" }
local MILESTONES = {
    { 1, L["First Contact"] }, { 10, L["Old Soldiers"] }, { 25, L["Seasoned Traveller"] },
    { 50, L["Keeper of Lore"] }, { 100, L["Living Archive"] },
}
local GAME_TITLE = {
    WC1 = L["Where It Began"], WC2 = L["Tides of Darkness"], BTDP = L["Beyond the Portal"],
    WC3 = L["Veterans of the Third War"], TFT = L["Veterans of the Frozen Throne"],
    FK = L["The Forsaken Kingdom"], BOOK = L["Grand Librarian"],
}
local BOOK_STEPS = { { 25, L["Bookworm"] }, { 50, L["Archivist"] } }
local MIN_GROUP = 3 -- smallest set that gets a game, zone or circle achievement

-- Static part: id, text, icon and the veterans that count. Built on first use.
local defs

local function add(list, d)
    list[#list + 1] = d
end

local function build()
    local list = {}
    local vets = ns.Veterans()
    local total, open = #vets, 0
    for _, g in ipairs(vets) do
        if reachable(g) then
            open = open + 1
        end
    end

    for _, m in ipairs(MILESTONES) do
        if m[1] <= total then
            add(list, {
                id = "milestone_" .. m[1], title = m[2], category = "milestone", icon = ICON .. "Achievement_Level_10",
                desc = m[1] == 1 and L["Meet your first veteran."] or L["Meet %d veterans."]:format(m[1]),
                total = m[1], all = true, later = m[1] > open, -- more than can be met at the cap
            })
        end
    end

    local perGame, perZone, zones, codeAny = {}, {}, {}, {}
    for _, g in ipairs(vets) do
        for _, code in ipairs(g.codes) do
            codeAny[code] = true
            if reachable(g) then -- games count only the veterans that can be met at the cap
                perGame[code] = perGame[code] or {}
                table.insert(perGame[code], g)
            end
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

    local rtsCodes, ageOpen = {}, true
    for gi, code in ipairs(ns.GAME_ORDER) do
        local members = perGame[code]
        if code ~= "BOOK" and codeAny[code] then
            rtsCodes[#rtsCodes + 1] = code
            ageOpen = ageOpen and members ~= nil
        end
        if members then
            if #members >= MIN_GROUP then
                local long = ns.GAME_LONG[code] or code
                if code == "BOOK" then
                    for _, step in ipairs(BOOK_STEPS) do
                        if step[1] < #members then
                            add(list, {
                                id = "game_BOOK_" .. step[1], title = step[2], category = "game", icon = ICON .. "INV_Misc_Book_09",
                                desc = L["Meet %d veterans from the Warcraft novels and books."]:format(step[1]),
                                members = members, total = step[1], gameRank = gi,
                            })
                        end
                    end
                end
                add(list, {
                    id = "game_" .. code, title = GAME_TITLE[code] or long, category = "game", icon = ICON .. "INV_Misc_Book_09",
                    desc = code == "BOOK" and L["Meet every veteran from the Warcraft novels and books."]
                        or L["Meet every veteran from %s."]:format(long),
                    members = members, total = #members, gameRank = gi,
                })
            end
        end
    end

    for _, z in ipairs(zones) do
        local members = perZone[z]
        if #members >= MIN_GROUP then
            add(list, {
                id = "zone_" .. z, title = L["Veterans of %s"]:format(z), category = "zone", icon = ICON .. "INV_Misc_Map_01",
                desc = L["Meet every veteran in %s."]:format(z), members = members, total = #members,
                later = not zoneReachable(z),
            })
        end
    end

    for _, g in ipairs(vets) do
        local related = ns.Related(g.id)
        if #related >= MIN_GROUP then
            local members, later = { g }, not reachable(g)
            for _, r in ipairs(related) do
                members[#members + 1] = r
                later = later or not reachable(r)
            end
            local name = g.entry.name or "?"
            -- "Thrall's Circle", but "Fizzle Brassbolts' Circle"
            local title = name:sub(-1) == "s" and L["%s' Circle"]:format(name) or L["%s's Circle"]:format(name)
            add(list, {
                id = "circle_" .. g.id, title = title, later = later, category = "circle", icon = ICON .. "Achievement_Reputation_01",
                desc = L["Meet %s and everyone tied to them."]:format(name), members = members, total = #members,
            })
        end
    end

    -- Memorials (Memorials.lua): items are { key, entry, memorial = true }. The first goal counts the ones
    -- in zones open at the level cap and grows when the cap rises, like the games' veterans.
    -- The History of Warcraft books (kind "book") have a goal of their own; a book counts as soon as
    -- one of the places it stands in is open.
    local all = ns.MemorialList and ns.MemorialList() or {}
    local mems, books, reachableMems, reachableBooks = {}, {}, {}, {}
    for _, m in ipairs(all) do
        if m.entry.kind == "book" then
            books[#books + 1] = m
            local open = zoneReachable(m.entry.zone)
            for _, spot in ipairs(type(m.entry.locations) == "table" and m.entry.locations or {}) do
                open = open or zoneReachable(spot.zone)
            end
            if open then
                reachableBooks[#reachableBooks + 1] = m
            end
        else
            mems[#mems + 1] = m
            if zoneReachable(m.entry.zone) then
                reachableMems[#reachableMems + 1] = m
            end
        end
    end
    if #mems >= MIN_GROUP then
        add(list, {
            id = "memorial_all", title = L["Pay Your Respects"], category = "memorial", icon = ICON .. "INV_Misc_Note_02",
            desc = L["Visit every memorial."],
            members = reachableMems, total = math.max(#reachableMems, 1), later = #reachableMems == 0,
        })
    end
    local valley, valleyOpen = {}, true
    for _, key in ipairs(VALLEY_OF_HEROES) do
        for _, m in ipairs(mems) do
            if m.key == key then
                valley[#valley + 1] = m
                valleyOpen = valleyOpen and zoneReachable(m.entry.zone)
            end
        end
    end
    if #valley == #VALLEY_OF_HEROES then
        add(list, {
            id = "memorial_valley", title = L["Heroes of the Second War"], category = "memorial", icon = ICON .. "INV_Sword_27",
            desc = L["Visit all five plaques in Stormwind's Valley of Heroes."],
            members = valley, total = #valley, later = not valleyOpen,
        })
    end
    if #books >= MIN_GROUP then
        add(list, {
            id = "memorial_library", title = L["Student of History"], category = "memorial", icon = ICON .. "INV_Misc_Book_09",
            desc = L["Read every History of Warcraft book."],
            members = reachableBooks, total = math.max(#reachableBooks, 1), later = #reachableBooks == 0,
        })
    end

    if #rtsCodes >= 2 then
        add(list, {
            id = "special_ages", title = L["Across the Ages"], category = "special", icon = ICON .. "INV_Misc_Spyglass_03",
            desc = L["Meet a veteran from each Warcraft strategy game and its expansions."],
            codes = rtsCodes, total = #rtsCodes, later = not ageOpen,
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
        if a.category == "game" and a.gameRank ~= b.gameRank then
            return a.gameRank < b.gameRank
        end
        if a.category == "game" and a.total ~= b.total then
            return a.total < b.total -- the book steps stay together, smallest first
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
            if g.memorial then
                m = ns.IsVisited ~= nil and ns.IsVisited(g.key) == true
            else
                m = ns.GroupMet(g)
            end
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
            progress = math.min(progress, d.total), total = d.total, later = d.later == true,
            earned = tonumber(earned[d.id]),
        }
        -- An earned one stays done when a data update grows its goal.
        out[i].done = progress >= d.total or out[i].earned ~= nil
    end
    return out
end

-- earned, total of the ones that can be earned now, and how many wait for a higher level cap.
function Achievements.Counts()
    local n, total, later = 0, 0, 0
    for _, a in ipairs(Achievements.List()) do
        if a.later and not a.earned then
            later = later + 1
        else
            total = total + 1
            if a.earned then
                n = n + 1
            end
        end
    end
    return n, total, later
end

local function announce(titles)
    local db = WarcraftLoreDB
    local n = #titles
    if n == 0 then
        return
    end
    if n == 1 then
        C.Print(PREFIX .. L["Achievement earned: %s"]:format(titles[1]))
    else
        local shown = {}
        for i = 1, math.min(n, 3) do
            shown[i] = titles[i]
        end
        local text = table.concat(shown, ", ")
        if n > 3 then
            text = text .. L[" and %d more"]:format(n - 3)
        end
        C.Print(PREFIX .. L["%d achievements earned: %s"]:format(n, text))
    end
    if ns.Toast and ns.Toast.ShowAchievement then
        pcall(ns.Toast.ShowAchievement, titles[1], n)
    end
    if not db or db.alert ~= false then
        pcall(C.PlayAlertSound) -- one sound, unless alerts are switched off
    end
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
        if a.done and not a.earned and not a.later then
            store[a.id] = now
            fresh[#fresh + 1] = a.id
            titles[#titles + 1] = a.title
        end
    end
    if #fresh > 0 and ns.Journal and ns.Journal.Refresh then
        pcall(ns.Journal.Refresh) -- an open Lore Journal shows the new dates right away
    end
    if not db.achievementsSeeded then
        -- First run with this feature: what is already done is stored without announcing.
        db.achievementsSeeded = true
        if #fresh > 0 then
            C.Print(PREFIX .. L["You already have %d achievements – see /wcl journal."]:format(#fresh))
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

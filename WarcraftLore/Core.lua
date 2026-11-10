-- Core.lua – lookup, tooltip line, events and the /wcl commands.
-- Every client-version-dependent call goes through ns.Compat (Compat.lua).

local ADDON_NAME, ns = ...
local C = ns.Compat
local L = ns.L

local PREFIX = "|cff8b6cd6Warcraft Lore:|r "

-- Entries marked forever = true stand in zones only WoW Forever has (Mount Hyjal, Dalaran ...).
-- Other clients (Classic Era) drop them here, before any list, count or achievement is built.
if C.IsForever() == false then
    for _, db in ipairs({ ns.NPCS or {}, ns.MEMORIALS or {} }) do
        for id, entry in pairs(db) do
            if type(entry) == "table" and entry.forever then
                db[id] = nil
            end
        end
    end
end

-- WoW Forever gave some veterans a new NPC ID (Leonid Barthalomew is 11036 everywhere else, 267008 in
-- Forever). An entry lists those in foreverIDs = { ... }; ns.Lookup turns them into the entry's own ID,
-- so meetings, alerts and the met counter all treat them as the same veteran.
ns.FOREVER_ALIAS = {}
for id, entry in pairs(ns.NPCS or {}) do
    if type(entry) == "table" and type(entry.foreverIDs) == "table" then
        for _, fid in ipairs(entry.foreverIDs) do
            if ns.NPCS[fid] == nil then
                ns.FOREVER_ALIAS[fid] = id
            end
        end
    end
end

ns.GAME_ORDER = { "WC1", "WC2", "BTDP", "WC3", "TFT", "FK", "BOOK" }
ns.GAME_SHORT = { WC1 = "WC1", WC2 = "WC2", BTDP = "BtDP", WC3 = "WC3", TFT = "TFT", FK = "FK", BOOK = "Book" }
ns.GAME_LONG = {
    WC1 = "Warcraft: Orcs & Humans",
    WC2 = "Warcraft II: Tides of Darkness",
    BTDP = "Warcraft II: Beyond the Dark Portal",
    WC3 = "Warcraft III: Reign of Chaos",
    TFT = "Warcraft III: The Frozen Throne",
    FK = "Warcraft III Reforged: Forsaken Kingdom",
    BOOK = L["Warcraft novels and books"],
}
-- One color per game: bronze, red, violet, orange, ice blue, lime (Reforged's new Forsaken campaign), parchment (books).
ns.GAME_COLOR = { WC1 = "c9a46a", WC2 = "e0533f", BTDP = "b07cf0", WC3 = "f0a24a", TFT = "7cc7ef", FK = "9bd46a", BOOK = "e8dcb5" }

function ns.GameRGB(code)
    local hex = ns.GAME_COLOR[code] or "a79d8a"
    return tonumber(hex:sub(1, 2), 16) / 255, tonumber(hex:sub(3, 4), 16) / 255, tonumber(hex:sub(5, 6), 16) / 255
end

-------------------------------------------------------------------- Zones and coordinates
-- Zone name -> uiMapIDs. Classic-era IDs first, Mainline IDs after; the client only
-- knows one set, so listing both is harmless. Only zones with coords in Data.lua or Memorials.lua.
local ZONE_MAPS = {
    ["Orgrimmar"] = { 1454, 85 },
    ["Durotar"] = { 1411, 1 },
    ["The Barrens"] = { 1413, 10 },
    ["Undercity"] = { 1458, 90 },
    ["Silverpine Forest"] = { 1421, 21 },
    ["Stonetalon Mountains"] = { 1442, 65 },
    ["Mulgore"] = { 1412, 7 },
    ["Thunder Bluff"] = { 1456, 88 },
    ["Feralas"] = { 1444, 69 },
    ["Dustwallow Marsh"] = { 1445, 70 },
    ["Darkshore"] = { 1439, 62 },
    ["Hillsbrad Foothills"] = { 1424, 25 },
    ["Alterac Mountains"] = { 1416 }, -- Mainline 27 is Dun Morogh, so only the Classic ID
    ["Tirisfal Glades"] = { 1420, 18 },
    ["Western Plaguelands"] = { 1422, 22 },
    ["Darnassus"] = { 1457, 89 },
    ["Elwynn Forest"] = { 1429, 37 },
    ["Stormwind City"] = { 1453, 84 },
    ["Ironforge"] = { 1455, 87 },
    ["Redridge Mountains"] = { 1433, 49 },
    ["Duskwood"] = { 1431, 47 },
    ["Loch Modan"] = { 1432, 48 },
    ["Thousand Needles"] = { 1441, 64 },
    ["Ashenvale"] = { 1440, 63 },
    ["Tanaris"] = { 1446, 71 },
    ["Winterspring"] = { 1452, 83 },
    ["Moonglade"] = { 1450, 80 },
    ["Felwood"] = { 1448, 77 },
    ["Eastern Plaguelands"] = { 1423, 23 },
    ["The Hinterlands"] = { 1425, 26 },
    ["Arathi Highlands"] = { 1417, 14 },
    ["Stranglethorn Vale"] = { 1434 }, -- Mainline splits the zone in two, so only the Classic ID
    -- zones that only have memorials or History of Warcraft books
    ["Westfall"] = { 1436, 52 },
    ["Dun Morogh"] = { 1426, 27 },
    ["Desolace"] = { 1443, 66 },
    ["Swamp of Sorrows"] = { 1435, 51 },
    ["Blasted Lands"] = { 1419, 17 },
    ["Wetlands"] = { 1437, 56 },
}
ns.ZONE_MAPS = ZONE_MAPS -- read by MapPins.lua

-- How close (distance in map percent, 0-100) the player must come to an NPC's coords for the
-- "usually found near here" hint. Capital cities are small and crowded on their map, so they get
-- a tighter circle; every other zone uses HINT_RADIUS.
local HINT_RADIUS = 3
local ZONE_RADIUS = {
    ["Orgrimmar"] = 1.5,
    ["Undercity"] = 1.5,
    ["Thunder Bluff"] = 1.5,
    ["Darnassus"] = 1.5,
    ["Stormwind City"] = 1.5,
    ["Ironforge"] = 1.5,
}

-- The zone name a uiMapID belongs to (from ZONE_MAPS), or nil for a map we do not list.
local zoneOfMap -- uiMapID -> zone name, built on first use
function ns.ZoneOfMap(mapID)
    if not zoneOfMap then
        zoneOfMap = {}
        for zone, maps in pairs(ZONE_MAPS) do
            for _, id in ipairs(maps) do
                zoneOfMap[id] = zone
            end
        end
    end
    return zoneOfMap[mapID]
end

-- The entry's `coords` ("32.0, 37.8") as two numbers in map percent, or nil when there are none.
-- Works for anything with a coords field: NPC entries, memorials and their `locations`.
function ns.Coords(entry)
    if type(entry) ~= "table" then
        return nil
    end
    local x, y = tostring(entry.coords or ""):match("^%s*([%d%.]+)%s*,%s*([%d%.]+)")
    x, y = tonumber(x), tonumber(y)
    if x and y then
        return x, y
    end
    return nil
end

local function chat(msg)
    C.Print(PREFIX .. msg)
end

-------------------------------------------------------------------- Guards
-- Every feature's entry point (tooltip callback, nameplate alert, ticker, target handler, slash
-- command) runs inside a guard. If it errors, only that feature is off for the session, ONE chat
-- line says so, and the error text is kept for /wcl debug. Nothing reaches the client's error frame.
local disabled, failures, failureOrder = {}, {}, {}

local function fail(key, label, err)
    disabled[key] = true
    if not failures[key] then
        failureOrder[#failureOrder + 1] = key
    end
    failures[key] = { label = label, err = tostring(err) }
    pcall(chat, L["%s is off after an error until you /reload. Type /wcl debug for details."]:format(label))
end

-- Returns a wrapper that calls fn unless the feature is off. An error turns the feature off.
local function guard(key, label, fn)
    return function(...)
        if disabled[key] then
            return
        end
        local ok, err = pcall(fn, ...)
        if not ok then
            fail(key, label, err)
        end
    end
end
ns.Guard = guard
ns.FeatureOff = function(key) return disabled[key] == true end

-- Looks up a unit ("target", "mouseover" …) or a GUID.
-- Returns entry (or nil), npcID (or nil), guidType, name.
function ns.Lookup(unit, guid)
    guid = guid or (unit and C.UnitGUID(unit))
    local npcID, guidType = C.NPCIDFromGUID(guid)
    npcID = npcID and ns.FOREVER_ALIAS[npcID] or npcID
    local name = unit and C.UnitName(unit)
    local entry = npcID and ns.NPCS[npcID]
    return entry, npcID, guidType, name
end

-- The entry's games, each once, in release order.
function ns.GamesInOrder(entry)
    local seen = {}
    for _, a in ipairs(entry.appearances or {}) do
        seen[a.game] = true
    end
    local games = {}
    for _, code in ipairs(ns.GAME_ORDER) do
        if seen[code] then
            games[#games + 1] = code
        end
    end
    return games
end

-- "WC3 · TFT" with each code in its game's color.
function ns.CodesLabel(codes)
    local parts = {}
    for _, code in ipairs(codes) do
        parts[#parts + 1] = "|cff" .. ns.GAME_COLOR[code] .. ns.GAME_SHORT[code] .. "|r"
    end
    return table.concat(parts, " · ")
end

function ns.GamesLabel(entry)
    return ns.CodesLabel(ns.GamesInOrder(entry))
end

-------------------------------------------------------------------- Veterans (merged by name + zone)
-- Data.lua can hold the same character under two NPC IDs (e.g. Season of Discovery IDs). For the
-- list and the counters those count as ONE veteran: { ids = sorted NPC IDs, id = lowest ID,
-- entry = that ID's entry, codes = union of games in release order }.
local veterans, byID
function ns.Veterans()
    if veterans then
        return veterans
    end
    local byKey = {}
    veterans, byID = {}, {}
    for npcID, entry in pairs(ns.NPCS) do
        local key = (entry.name or "?") .. "\1" .. (entry.zone or "")
        local g = byKey[key]
        if not g then
            g = { ids = {} }
            byKey[key] = g
            veterans[#veterans + 1] = g
        end
        g.ids[#g.ids + 1] = npcID
    end
    for _, g in ipairs(veterans) do
        table.sort(g.ids)
        g.id = g.ids[1]
        g.entry = ns.NPCS[g.id]
        g.idSet = {}
        local seen = {}
        for _, id in ipairs(g.ids) do
            g.idSet[id] = true
            byID[id] = g
            for _, code in ipairs(ns.GamesInOrder(ns.NPCS[id])) do
                seen[code] = true
            end
        end
        g.codes = {}
        for _, code in ipairs(ns.GAME_ORDER) do
            if seen[code] then
                g.codes[#g.codes + 1] = code
            end
        end
    end
    return veterans
end

-- The merged veteran an NPC ID belongs to (nil if the ID is not in the database).
function ns.VeteranOf(npcID)
    ns.Veterans()
    return byID[npcID]
end

-------------------------------------------------------------------- Related veterans
-- `related` in Data.lua only needs to be written on one side: an entry is related to the IDs it
-- lists and to every entry that lists it. Works on merged veterans, so a Season of Discovery ID
-- shares the relations of its namesake.
local incoming -- npcID -> list of NPC IDs whose `related` names it, built on first use
function ns.Related(npcID)
    if not incoming then
        incoming = {}
        for id, entry in pairs(ns.NPCS) do
            for _, rid in ipairs(entry.related or {}) do
                incoming[rid] = incoming[rid] or {}
                table.insert(incoming[rid], id)
            end
        end
    end
    local own = ns.VeteranOf(npcID)
    local seen, out = {}, {}
    local function add(id)
        local g = ns.VeteranOf(id)
        if g and g ~= own and not seen[g] then
            seen[g] = true
            out[#out + 1] = g
        end
    end
    for _, id in ipairs(own and own.ids or { npcID }) do
        local entry = ns.NPCS[id]
        for _, rid in ipairs(entry and entry.related or {}) do
            add(rid)
        end
        for _, rid in ipairs(incoming[id] or {}) do
            add(rid)
        end
    end
    table.sort(out, function(a, b) return (a.entry.name or "") < (b.entry.name or "") end)
    return out
end

-------------------------------------------------------------------- Met tracking
-- A veteran counts as met when the player targets it or mouses over it (a real unit, not
-- a nameplate/coordinate alert and not /wcl test). Stored account-wide (SavedData.lua):
-- WarcraftLoreDB.met[npcID] = { first = time(), count = meetings, by = "Name-Realm" }.
-- count goes up once per NPC per session, not on every tooltip refresh.
local metThisSession = {}

local function metEntry(npcID)
    local db = WarcraftLoreDB
    local e = db and type(db.met) == "table" and npcID and db.met[npcID]
    return type(e) == "table" and e or nil
end

function ns.IsMet(npcID)
    return metEntry(npcID) ~= nil
end

-- How many sessions the player has met this NPC ID in (0 = never).
function ns.MeetCount(npcID)
    local e = metEntry(npcID)
    return e and tonumber(e.count) or 0
end

-- Short player-facing line for a met veteran ("Met 4 times · first on 3 Oct 2026 with Arthas"),
-- summed over the merged veteran group; nil when never met.
function ns.MetSummary(npcID)
    local group = npcID and ns.VeteranOf(npcID)
    local ids = group and group.ids or { npcID }
    local count, first, by = 0, nil, nil
    for _, id in ipairs(ids) do
        local e = metEntry(id)
        if e then
            count = count + math.max(1, tonumber(e.count) or 1)
            local t = tonumber(e.first)
            if t and (not first or t < first) then
                first, by = t, e.by
            end
        end
    end
    if count == 0 then
        return nil
    end
    local text = count == 1 and L["Met once"] or L["Met %d times"]:format(count)
    if first then
        local when = ns.FormatDate and ns.FormatDate(first) -- Locale.lua: month names in the client language
        if when then
            local who
            if type(by) == "string" and by ~= "" then
                local name, realm = by:match("^(.-)%-(.+)$")
                local mine = C.GetRealmName()
                if name and mine and realm == (mine:gsub("%s", "")) then
                    by = name
                end
                who = by
            end
            if who then
                text = count == 1 and L["Met once, on %s as %s"]:format(when, who)
                    or L["Met %d times · first on %s as %s"]:format(count, when, who)
            else
                text = count == 1 and L["Met once, on %s"]:format(when)
                    or L["Met %d times · first on %s"]:format(count, when)
            end
        end
    end
    return text
end

-- A merged veteran is met when any of its NPC IDs is met.
function ns.GroupMet(g)
    for _, id in ipairs(g.ids) do
        if ns.IsMet(id) then
            return true
        end
    end
    return false
end

-- Returns perGame, overall. perGame[code] = { met = n, total = n } for every code in
-- ns.GAME_ORDER (a veteran with several games counts in each; BOOK counts as its own game);
-- overall = { met = n, total = n } counted once per veteran (NPC IDs of the same name and zone merged).
function ns.MetCounts()
    local perGame = {}
    for _, code in ipairs(ns.GAME_ORDER) do
        perGame[code] = { met = 0, total = 0 }
    end
    local overall = { met = 0, total = 0 }
    for _, g in ipairs(ns.Veterans()) do
        local met = ns.GroupMet(g)
        overall.total = overall.total + 1
        if met then
            overall.met = overall.met + 1
        end
        for _, code in ipairs(g.codes) do
            perGame[code].total = perGame[code].total + 1
            if met then
                perGame[code].met = perGame[code].met + 1
            end
        end
    end
    return perGame, overall
end

-- Records a meeting with a database NPC. Returns true if it was the first ever.
function ns.MarkMet(npcID)
    local db = WarcraftLoreDB
    local entry = npcID and ns.NPCS[npcID]
    if not db or not entry then
        return false -- before ADDON_LOADED, or not a veteran
    end
    if type(db.met) ~= "table" then
        return false -- account data from a newer version: left alone
    end
    if metThisSession[npcID] then
        return false
    end
    metThisSession[npcID] = true
    local e = metEntry(npcID)
    if e then
        e.count = (tonumber(e.count) or 0) + 1
        return false
    end
    local group = ns.VeteranOf(npcID)
    local alreadyMet = group and ns.GroupMet(group) -- another NPC ID of the same veteran was met before
    -- Recorded right away (so a second call in the same frame is a no-op) ...
    db.met[npcID] = { first = time(), count = 1, by = ns.SavedData.CharacterName() }
    -- ... but the chat line and window refreshes wait for the next frame: this is usually
    -- called from inside a tooltip post-call, which should stay quick and must not be
    -- able to break the tooltip if one of our windows errors.
    C.After(function()
        -- A meet that earns an achievement prints only the achievement line (and one sound).
        local earnedNow = false
        if not alreadyMet and ns.Achievements then
            local ok, fresh = pcall(ns.Achievements.Check)
            earnedNow = ok and type(fresh) == "table" and #fresh > 0
        end
        if not alreadyMet and not earnedNow then
            local _, overall = ns.MetCounts()
            chat(L["New veteran met: |cffd4c6f7%s|r (%s) – %d/%d met."]:format(
                entry.name or "?", ns.GamesLabel(entry), overall.met, overall.total))
        end
        -- Window refreshes are best effort: a broken window must not stop the meeting being recorded.
        if ns.Browser then
            pcall(ns.Browser.Refresh)
        end
        if ns.Journal and ns.Journal.IsShown and ns.Journal.IsShown() then
            pcall(ns.Journal.Refresh) -- open progress bars move on every meet
        end
        if ns.MapPins and ns.MapPins.Refresh then
            pcall(ns.MapPins.Refresh) -- redraws only when the world map is shown
        end
        if ns.UI and not ns.FeatureOff("window") then
            pcall(ns.UI.RefreshMet, npcID)
        end
    end)
    return true
end

-------------------------------------------------------------------- Memorials
-- Graves, plaques and monuments for characters of the strategy games (Memorials.lua). They are
-- found by the object's ID (hover, when the client tells it) or name: reading its text
-- (ITEM_TEXT_BEGIN) or hovering it counts as a visit, but only in the memorial's own zone.
-- Stored account-wide: WarcraftLoreDB.visited[key] = { first = time(), by = "Name-Realm" }.
local memList, memByName, memByObject -- sorted list of { key, entry, codes, memorial = true }; lower-case name -> item; object ID -> item

local function normalizeName(s)
    if type(s) ~= "string" then
        return nil
    end
    s = s:gsub("^%s+", ""):gsub("%s+$", ""):lower()
    return s ~= "" and s or nil
end

-- All memorials, sorted by name. Each item is { key, entry, codes (games in release order), memorial = true }.
function ns.MemorialList()
    if not memList then
        memList, memByName, memByObject = {}, {}, {}
        for key, entry in pairs(ns.MEMORIALS or {}) do
            local item = { key = key, entry = entry, codes = ns.GamesInOrder(entry), memorial = true }
            memList[#memList + 1] = item
            local low = normalizeName(entry.name)
            if low then
                memByName[low] = item
            end
            for _, objectID in ipairs(type(entry.objectIDs) == "table" and entry.objectIDs or {}) do
                memByObject[objectID] = item
            end
        end
        table.sort(memList, function(a, b) return (a.entry.name or "") < (b.entry.name or "") end)
    end
    return memList
end

-- The memorial item for a key.
function ns.MemorialOf(key)
    for _, m in ipairs(ns.MemorialList()) do
        if m.key == key then
            return m
        end
    end
    return nil
end

-- The memorial whose object name is `name` (ignoring case and surrounding spaces), or nil.
function ns.MemorialByName(name)
    ns.MemorialList()
    local low = normalizeName(name)
    return low and memByName[low] or nil
end

-- The memorial with this game object ID (from objectIDs in Memorials.lua), or nil. Works in every
-- client language, unlike the name.
function ns.MemorialByObjectID(objectID)
    ns.MemorialList()
    return type(objectID) == "number" and memByObject[objectID] or nil
end

-- "Uther the Lightbringer" / "Danath Trollbane, Kurdran Wildhammer": who the memorial honors.
function ns.MemorialHonors(entry)
    return table.concat(entry.honors or {}, ", ")
end

local function visitEntry(key)
    local db = WarcraftLoreDB
    local e = db and type(db.visited) == "table" and key and db.visited[key]
    return type(e) == "table" and e or nil
end

function ns.IsVisited(key)
    return visitEntry(key) ~= nil
end

-- "Visited on 3 Oct 2026 as Arthas" for the hover text; nil when not visited.
function ns.VisitSummary(key)
    local e = visitEntry(key)
    if not e then
        return nil
    end
    local when = ns.FormatDate and ns.FormatDate(e.first)
    if not when then
        return L["Visited"]
    end
    local by = type(e.by) == "string" and e.by ~= "" and e.by or nil
    if by then
        local name, realm = by:match("^(.-)%-(.+)$")
        local mine = C.GetRealmName()
        if name and mine and realm == (mine:gsub("%s", "")) then
            by = name
        end
        return L["Visited on %s as %s"]:format(when, by)
    end
    return L["Visited on %s"]:format(when)
end

function ns.VisitedCounts()
    local n, total = 0, 0
    for _, m in ipairs(ns.MemorialList()) do
        total = total + 1
        if ns.IsVisited(m.key) then
            n = n + 1
        end
    end
    return n, total
end

-- Records a visit. Returns true if it was the first ever. The chat line and window refreshes wait
-- for the next frame (this is usually called from a tooltip post-call).
function ns.MarkVisited(key)
    local db = WarcraftLoreDB
    local item = key and ns.MemorialOf(key)
    if not db or not item then
        return false -- before ADDON_LOADED, or not a memorial
    end
    if type(db.visited) ~= "table" then
        return false -- account data from a newer version: left alone
    end
    if db.visited[key] then
        return false
    end
    db.visited[key] = { first = time(), by = ns.SavedData.CharacterName() }
    C.After(function()
        local earnedNow = false
        if ns.Achievements then
            local ok, fresh = pcall(ns.Achievements.Check)
            earnedNow = ok and type(fresh) == "table" and #fresh > 0
        end
        if not earnedNow then
            chat(L["Memorial visited: %s – honors %s"]:format(item.entry.name or "?", ns.MemorialHonors(item.entry)))
            if WarcraftLoreDB and WarcraftLoreDB.alert ~= false then
                C.PlayAlertSound() -- one sound, unless alerts are switched off
            end
        end
        if ns.Browser then
            pcall(ns.Browser.Refresh)
        end
        if ns.Journal and ns.Journal.IsShown and ns.Journal.IsShown() then
            pcall(ns.Journal.Refresh)
        end
        if ns.MapPins and ns.MapPins.Refresh then
            pcall(ns.MapPins.Refresh)
        end
        if ns.UI and ns.UI.RefreshVisited and not ns.FeatureOff("window") then
            pcall(ns.UI.RefreshVisited, key)
        end
    end)
    return true
end

-- True unless we can tell that the player is in another zone than the memorial (or any of its
-- `locations`). Only a map ID we know from ZONE_MAPS can rule a memorial out: an unreadable map,
-- a map we do not list (a city's inner map, another client's IDs) or a memorial zone without
-- ZONE_MAPS entry all keep the old behaviour (the name decides).
local function inMemorialZone(entry)
    local mapID = C.GetPlayerMapPos()
    if not mapID and C.GetZoneMapID then
        mapID = C.GetZoneMapID()
    end
    local here = mapID and ns.ZoneOfMap(mapID)
    if not here then
        return true
    end
    local zones = { entry.zone }
    for _, spot in ipairs(type(entry.locations) == "table" and entry.locations or {}) do
        zones[#zones + 1] = spot.zone
    end
    for _, zone in ipairs(zones) do
        if zone == here or not ns.ZONE_MAPS[zone] then
            return true
        end
    end
    return false
end

-- Reading a plaque or tomb: the title of the opened text is the object's name.
local onItemText = guard("memorial-text", L["the memorial reading"], function()
    local item = ns.MemorialByName(C.ItemTextName())
    if item and inMemorialZone(item.entry) then
        ns.MarkVisited(item.key)
    end
end)

-- Hovering a world object: add the memorial line and count the visit. Never on a unit tooltip.
-- The object ID (when the client gives it) is matched first, the object's name after that.
local onObjectTooltip = guard("memorial-tooltip", L["the memorial tooltip line"], function(tooltip, firstLine, hasUnit, objectID)
    if hasUnit then
        return
    end
    local item = ns.MemorialByObjectID(objectID) or ns.MemorialByName(firstLine)
    if not item or not inMemorialZone(item.entry) then
        return
    end
    ns.MarkVisited(item.key)
    C.AddTooltipLine(tooltip, L["Warcraft Memorial: %s (%s)"]:format(
        ns.MemorialHonors(item.entry), ns.CodesLabel(item.codes)), 0.83, 0.78, 0.97)
end)

-------------------------------------------------------------------- Slash commands
-- The lore window failed to build: say so once instead of erroring in every feature.
local function windowOff()
    if ns.FeatureOff("window") or not ns.UI then
        chat(L["The lore window is not available. Type /wcl debug for details."])
        return true
    end
    return false
end

-- True (after saying so with `say`) when there is no target to look at. A target the game will
-- not tell us about right now (a secret answer) gets its own message instead of "no target".
local function noTarget(say, noTargetText)
    local exists, unreadable = C.UnitExists("target")
    if exists then
        return false
    end
    say(unreadable and L["Your target cannot be read right now (often in combat). Try again in a moment."] or noTargetText)
    return true
end

local function cmdShow()
    if windowOff() then
        return
    end
    if noTarget(ns.UI.ShowMessage, L["You have no target. Target an NPC and type /wcl again."]) then
        return
    end
    local entry, npcID, guidType, name = ns.Lookup("target")
    if entry then
        ns.UI.ShowEntry(npcID, entry, "target")
    elseif npcID then
        ns.UI.ShowUnknown(name, npcID, "target")
    elseif guidType == "Player" then
        ns.UI.ShowMessage(L["%s is a player, not an NPC."]:format(name or L["Your target"]))
    else
        ns.UI.ShowMessage(L["The game is not sharing this NPC's details right now (often in combat). Try again out of combat."])
    end
end

local function cmdID()
    if noTarget(chat, L["You have no target."]) then
        return
    end
    local entry, npcID, guidType, name = ns.Lookup("target")
    local shownName = name or L["<unknown name>"]
    if npcID then
        local status = entry and L["|cff40ff40in the database|r"] or L["|cffaaaaaanot in the database|r"]
        chat(L["%s – NPC ID |cffffffff%d|r (%s)"]:format(shownName, npcID, status))
    elseif guidType == "Player" then
        chat(L["%s is a player, not an NPC."]:format(shownName))
    elseif guidType then
        chat(L["%s is not an NPC."]:format(shownName))
    else
        chat(L["The game is not sharing this NPC's details right now (often in combat). Try again out of combat."])
    end
end

ns.ShowTarget = cmdShow -- the minimap button's right-click does the same as /wcl

local function cmdList()
    if not ns.Browser then
        chat(L["The veterans list is not available."])
        return
    end
    ns.Browser.Toggle()
end

-- Keeps the settings page's checkboxes in step when a setting changes by slash command.
local function refreshOptions()
    if ns.Options and ns.Options.Refresh then
        ns.Options.Refresh()
    end
end

local function cmdMinimap()
    local shown = ns.Minimap.Toggle()
    chat(L["The minimap button is now %s."]:format(shown and L["|cff40ff40shown|r"] or L["|cffff4040hidden|r"]))
    refreshOptions()
end

local function cmdAuto()
    WarcraftLoreDB.auto = not WarcraftLoreDB.auto
    chat(L["The alert when you target a veteran is now %s."]:format(WarcraftLoreDB.auto and L["|cff40ff40ON|r"] or L["|cffff4040OFF|r"]))
    refreshOptions()
end

local function cmdAlert()
    WarcraftLoreDB.alert = not WarcraftLoreDB.alert
    chat(L["Nearby alerts are now %s."]:format(WarcraftLoreDB.alert and L["|cff40ff40ON|r"] or L["|cffff4040OFF|r"]))
    refreshOptions()
end

-------------------------------------------------------------------- Nearby alert
-- A veteran seen up close (its nameplate appears, or the player mouses over it) is announced once
-- per session: chat line, sound and the pill.
local alerted = {}

-- The first veteran is announced at once (chat line, sound, pill). Others appearing within
-- BATCH_WINDOW seconds (entering a city) are collected into ONE follow-up chat line naming up to
-- MAX_NAMED of them, with no extra sound; the pill gets a short "+N more".
local BATCH_WINDOW = 1.5
local MAX_NAMED = 3
local batch -- nil, or { npcID = first veteran, list = { { entry, name }, ... } }

-- The pill has its own guard key: if it breaks, the chat lines and the sound keep working.
local showPill = guard("pill", L["the alert pill"], function(npcID, entry, who, unit, more)
    if ns.Toast and ns.Toast.Show then
        ns.Toast.Show(npcID, entry, who, unit, more)
    end
end)
local setPillMore = guard("pill", L["the alert pill"], function(npcID, n)
    if ns.Toast and ns.Toast.SetMore then
        ns.Toast.SetMore(npcID, n)
    end
end)

-- "Alpha (WC3), Beta (WC2) +2 more": up to MAX_NAMED names in color, the rest counted.
local function namesLine(list)
    local parts = {}
    for i = 1, math.min(#list, MAX_NAMED) do
        local v = list[i]
        parts[i] = ("|cffd4c6f7%s|r (%s)"):format(v.name or v.entry.name or "?", ns.GamesLabel(v.entry))
    end
    local more = #list > MAX_NAMED and (" " .. L["|cffa79d8a+%d more|r"]:format(#list - MAX_NAMED)) or ""
    return table.concat(parts, ", ") .. more
end

-- quiet = no chat line (the "New veteran met" line already names it).
local function show(npcID, entry, name, unit, quiet)
    local who = name or entry.name
    if not quiet then
        chat(L["Veteran nearby: |cffd4c6f7%s|r (%s)."]:format(who, ns.GamesLabel(entry)))
    end
    C.PlayAlertSound()
    showPill(npcID, entry, who, unit)
end

local function flushBatch(b)
    local n = #b.list
    if n == 0 then
        return
    end
    chat(L["Also nearby: %s"]:format(namesLine(b.list)))
    setPillMore(b.npcID, n)
end
local flushGuarded = function() end -- set below, once guard() is used

local function onBatchTimer()
    local b = batch
    batch = nil -- cleared first, so a failing flush can never leave the window stuck open
    if b then
        flushGuarded(b)
    end
end

-- Shared by the nameplate path and the mouseover path, so nobody is announced twice.
-- unit = the unit token when there is one (used for the pill's portrait).
-- quiet = a first-ever meeting from a mouseover: ns.MarkMet prints its own chat line, so this one
-- gives only the sound and the pill (and nothing at all while a batch is open).
local function announce(npcID, entry, name, isTest, unit, quiet)
    if isTest then
        show(npcID, entry, name, unit)
        return
    end
    alerted[npcID] = true
    if batch then
        if not quiet then
            batch.list[#batch.list + 1] = { entry = entry, name = name }
        end
        return
    end
    batch = { npcID = npcID, list = {} }
    C.After(onBatchTimer, BATCH_WINDOW)
    show(npcID, entry, name, unit, quiet)
end
-- One guard key for the nearby-alert path (nameplates, mouseover and the follow-up line).
flushGuarded = guard("alert", L["the nearby alert"], flushBatch)

-- /wcl test: shows the alert for the database NPC with the lowest ID.
local function cmdTest()
    local lowest
    for npcID in pairs(ns.NPCS) do
        if not lowest or npcID < lowest then
            lowest = npcID
        end
    end
    if not lowest then
        chat(L["The database is empty."])
        return
    end
    announce(lowest, ns.NPCS[lowest], nil, true)
end

-- Forever reportedly fires NAME_PLATE_UNIT_ADDED before the unit is filled in, so a plate we
-- cannot read yet gets up to three more looks: 0.3 s later, 1 s after that and 2 s after that.
-- The retries stop as soon as the plate can be read.
local NAMEPLATE_RETRIES = { 0.3, 1, 2 }
local onNameplateRetry = function() end -- set below, once guard() is used

-- attempt = how many retries this call is (nil for the event itself).
local function nameplateAdded(unit, attempt)
    if not (WarcraftLoreDB and WarcraftLoreDB.alert) or type(unit) ~= "string" then
        return
    end
    attempt = attempt or 0
    if not C.UnitGUID(unit) then
        local delay = NAMEPLATE_RETRIES[attempt + 1]
        if delay then
            C.After(function() onNameplateRetry(unit, attempt + 1) end, delay)
        end
        return
    end
    local entry, npcID, _, name = ns.Lookup(unit)
    if not entry or alerted[npcID] then
        return
    end
    announce(npcID, entry, name, false, unit)
end
local onNameplateAdded = guard("alert", L["the nearby alert"], nameplateAdded)
onNameplateRetry = onNameplateAdded

-------------------------------------------------------------------- Tooltip
-- The alert for a veteran found by mouseover runs a frame later, outside the tooltip post-call,
-- under the nearby alert's guard key.
local onMouseoverAlert = guard("alert", L["the nearby alert"], function(npcID, entry, name, unit, quiet)
    if WarcraftLoreDB and WarcraftLoreDB.alert then
        announce(npcID, entry, name, false, unit, quiet)
    end
end)

-- True when the tooltip shows the player's current target.
local function isTarget(unit, guid)
    if unit == "target" then
        return true
    end
    local targetGUID = C.UnitGUID("target")
    guid = guid or (unit and C.UnitGUID(unit))
    return targetGUID ~= nil and guid == targetGUID
end

local function tooltipLine(tooltip, unit, guid)
    local entry, npcID, _, name = ns.Lookup(unit, guid)
    if not entry then
        return -- not in the database: no line
    end
    -- Any GameTooltip unit tooltip counts as meeting: mouseover in the world, on a nameplate
    -- or on a unit frame. You can only mouse over what is on screen and in view range (the
    -- same range at which nameplates show), so "seen up close" is the bar. Unreadable (secret)
    -- GUIDs give no entry above, so nothing is marked then.
    local group = ns.VeteranOf(npcID)
    local groupMetBefore = group and ns.GroupMet(group)
    local firstMeet = ns.MarkMet(npcID)
    C.AddTooltipLine(tooltip, L["Warcraft Veteran: %s"]:format(ns.GamesLabel(entry)), 0.83, 0.78, 0.97)
    -- Friendly nameplates are off by default, so hovering is often the only way a veteran is seen:
    -- it gives the nearby alert too, once per session. Not for the target when /wcl auto already
    -- shows its pill (onTargetChanged).
    local db = WarcraftLoreDB
    if db and db.alert and not alerted[npcID] and not (db.auto and isTarget(unit, guid)) then
        alerted[npcID] = true -- right away: the tooltip is refreshed many times while hovered
        local quiet = firstMeet and not groupMetBefore -- MarkMet prints "New veteran met" then
        C.After(function() onMouseoverAlert(npcID, entry, name, unit, quiet) end)
    end
end
local onUnitTooltip = guard("tooltip", L["the tooltip line"], tooltipLine)

-------------------------------------------------------------------- Nearby hint (coordinates)
-- Compares the player's map position with `coords` in Data.lua (Wowhead map percent). Being near
-- the spot is only a hint (the NPC may be elsewhere), so it has its own softer chat line without
-- sound, is remembered in `hinted` (not `alerted`), and a later real sighting still gives the
-- full alert. Entries with roams = true never give a hint.
local CHECK_INTERVAL = 2      -- seconds between checks
local hinted = {}

-- True when the entry has stored coordinates in a zone we can match to a map.
local function hasCoords(entry)
    return ns.Coords(entry) ~= nil and ZONE_MAPS[entry.zone] ~= nil
end

-- uiMapID -> list of { npcID, x, y, radius } (in map percent), built once on first use.
local byMap
local function buildIndex()
    byMap = {}
    for npcID, entry in pairs(ns.NPCS) do
        local x, y = ns.Coords(entry)
        local maps = ZONE_MAPS[entry.zone]
        if x and y and maps and not entry.roams then
            local radius = ZONE_RADIUS[entry.zone] or HINT_RADIUS
            for _, mapID in ipairs(maps) do
                byMap[mapID] = byMap[mapID] or {}
                table.insert(byMap[mapID], { npcID, x, y, radius })
            end
        end
    end
end

-- All hints of one check become one chat line (and one pill with "+N more"), no sound.
local function showHints(found)
    local first = found[1]
    if #found == 1 then
        chat(L["A veteran is usually found near here: |cffd4c6f7%s|r (%s)."]:format(
            first.entry.name or "?", ns.GamesLabel(first.entry)))
    else
        chat(L["Veterans usually found near here: %s"]:format(namesLine(found)))
    end
    showPill(first.npcID, first.entry, first.entry.name, nil, #found > 1 and #found - 1 or nil)
end

local function positionCheck()
    if not (WarcraftLoreDB and WarcraftLoreDB.alert) or C.InInstance() or C.OnTaxi() then
        return
    end
    local mapID, px, py = C.GetPlayerMapPos()
    if not mapID then
        return
    end
    if not byMap then
        buildIndex()
    end
    local list = byMap[mapID]
    if not list then
        return
    end
    px, py = px * 100, py * 100
    local found = {}
    for _, spot in ipairs(list) do
        local npcID, radius = spot[1], spot[4]
        if not alerted[npcID] and not hinted[npcID] then
            local dx, dy = px - spot[2], py - spot[3]
            if dx * dx + dy * dy <= radius * radius then
                hinted[npcID] = true
                found[#found + 1] = { npcID = npcID, entry = ns.NPCS[npcID] }
            end
        end
    end
    if #found > 0 then
        table.sort(found, function(a, b) return a.npcID < b.npcID end)
        showHints(found)
    end
end
local checkPosition = guard("position", L["the nearby alert by map position"], positionCheck)

local function cmdDebug()
    local r = C.Report()
    chat(L["build %s, interface %s, issecretvalue=%s, TooltipDataProcessor=%s, tooltip hook=%s"]
        :format(tostring(r.build), tostring(r.interface), tostring(r.issecretvalue),
            tostring(r.tooltipDataProcessor), tostring(ns.tooltipHook)))
    local missing = {}
    for k in pairs(C.missing) do
        missing[#missing + 1] = k
    end
    table.sort(missing)
    chat(L["Missing: %s"]:format(#missing > 0 and table.concat(missing, ", ") or L["nothing"]))
    local n = 0
    for _ in pairs(ns.NPCS) do
        n = n + 1
    end
    chat(L["NPCs in the database: %d"]:format(n))
    -- Where the client says the player is: lets the owner check ZONE_MAPS in game.
    local mapID, px, py = C.GetPlayerMapPos()
    if mapID then
        chat(L["Map ID %d (%s), position %.1f, %.1f"]:format(mapID,
            ns.ZoneOfMap(mapID) or L["not in the zone list"], px * 100, py * 100))
    else
        chat(L["Map ID and position: not readable here."])
    end
    if #failureOrder == 0 then
        chat(L["Errors: none"])
    end
    for _, key in ipairs(failureOrder) do
        local f = failures[key]
        chat(L["Error in %s (off for this session): %s"]:format(f.label, f.err))
    end
end

-- /wcl why: explains in one or two lines why the target is or is not recognised.
local function cmdWhy()
    if noTarget(chat, L["You have no target. Target an NPC and type /wcl why."]) then
        return
    end
    local entry, npcID, guidType, name = ns.Lookup("target")
    local shown = name or L["Your target"]
    if not npcID then
        if guidType == "Player" then
            chat(L["%s is a player, not an NPC, so there is nothing to recognise."]:format(shown))
        elseif guidType then
            chat(L["%s is not an NPC."]:format(shown))
        else
            chat(L["%s: the game is not sharing this NPC's details right now (often in combat). Try again out of combat."]:format(shown))
        end
        return
    end
    if not entry then
        chat(L["%s has NPC ID %d, which is not in the database, so there is no tooltip line, alert or story."]:format(shown, npcID))
        return
    end
    chat(L["%s is a veteran (NPC ID %d, %s)."]:format(shown, npcID, ns.GamesLabel(entry)))
    local notes = {}
    if not WarcraftLoreDB.alert then
        notes[#notes + 1] = L["nearby alerts are off (/wcl alert)"]
    else
        if disabled.alert then
            notes[#notes + 1] = L["the nameplate alert is off after an error"]
        end
        if disabled.position then
            notes[#notes + 1] = L["the map position alert is off after an error"]
        elseif C.InInstance() then
            notes[#notes + 1] = L["you are in an instance, so map position alerts are off"]
        elseif entry.roams then
            notes[#notes + 1] = L["it moves around, so walking near its usual spot gives no hint; its nameplate or tooltip gives the alert"]
        elseif not hasCoords(entry) then
            notes[#notes + 1] = L["no map position is stored for this NPC, so only its nameplate or tooltip can trigger an alert"]
        end
        if alerted[npcID] then
            notes[#notes + 1] = L["you were already alerted about it this session"]
        end
    end
    if disabled.tooltip then
        notes[#notes + 1] = L["the tooltip line is off after an error"]
    end
    chat(#notes > 0 and L["Note: %s."]:format(table.concat(notes, "; "))
        or L["Its tooltip line, alerts and story are all active."])
end

local function cmdHelp()
    local on, off = L["on"], L["off"]
    chat(L["/wcl – open the window for your target"])
    chat(L["/wcl id – print your target's NPC ID and name in chat"])
    chat(L["/wcl list (or /wcl browse) – open or close the veterans list: search, filter, see who you have met"])
    chat(L["/wcl auto – show a small alert when you target a veteran (now: %s)"]:format(WarcraftLoreDB.auto and on or off))
    chat(L["/wcl alert – toggle the nearby alert (now: %s); by nameplate, mouseover and map position"]:format(WarcraftLoreDB.alert and on or off))
    chat(L["/wcl minimap – show or hide the minimap button (now: %s)"]:format(
        (WarcraftLoreDB.minimap and WarcraftLoreDB.minimap.hide) and L["hidden"] or L["shown"]))
    chat(L["/wcl why – explain why your target is or is not recognised"])
    chat(L["/wcl test – show a test alert (small pill, chat line, sound)"])
    chat(L["/wcl journal – open the Lore Journal (your achievements)"])
    chat(L["/wcl reset – move the windows back to the center"])
    chat(L["/wcl theme – switch between the Warcraft II look and the classic look (now: %s)"]:format(
        ns.Style.ThemeLabel(ns.Style.theme)))
    chat(L["/wcl options – open the Warcraft Lore settings"])
    chat(L["/wcl export – copy your met list as text"])
    chat(L["/wcl import – paste a met list from another account"])
    chat(L["/wcl debug – show which APIs the client has"])
end

-- Also used by the settings page's "Reset window positions" button.
function ns.ResetWindows()
    if ns.UI and not ns.FeatureOff("window") then
        ns.UI.ResetPosition()
    end
    if ns.Browser then
        ns.Browser.ResetPosition()
    end
    if ns.Journal then
        ns.Journal.ResetPosition()
    end
    chat(L["The windows are back in the center."])
end

local COMMANDS = {
    [""] = cmdShow, id = cmdID, list = cmdList, browse = cmdList, minimap = cmdMinimap,
    auto = cmdAuto, alert = cmdAlert, test = cmdTest, ["alert test"] = cmdTest, why = cmdWhy,
    debug = cmdDebug,
    journal = function()
        if ns.Journal then
            ns.Journal.Toggle()
        else
            chat(L["The Lore Journal is not available in this client."])
        end
    end,
    options = function()
        local hasPanel, opened = false, false
        if ns.Options then
            hasPanel, opened = ns.Options.Open()
        end
        if not hasPanel then
            chat(L["This client has no settings panel for Warcraft Lore."])
        elseif opened == false then
            chat(L["Could not open the settings right now."])
        end
    end,
    reset = function()
        ns.ResetWindows()
    end,
    export = function()
        if ns.Share then
            ns.Share.Open("export")
        else
            chat(L["Import and export are not available in this client."])
        end
    end,
    import = function()
        if ns.Share then
            ns.Share.Open("import")
        else
            chat(L["Import and export are not available in this client."])
        end
    end,
    -- Switch between the Warcraft II look and the classic look (asks, then reloads the interface).
    theme = function()
        ns.Style.RequestTheme(ns.Style.OtherTheme())
    end,
    ["theme wc2"] = function()
        ns.Style.RequestTheme("wc2")
    end,
    ["theme classic"] = function()
        ns.Style.RequestTheme("classic")
    end,
}
local guardedCommands = {}
for name, fn in pairs(COMMANDS) do
    local shown = name == "" and "/wcl" or ("/wcl " .. name)
    guardedCommands[name] = guard("cmd:" .. name, L["the %s command"]:format(shown), fn)
end
guardedCommands.help = guard("cmd:help", L["the /wcl help command"], cmdHelp)

SLASH_WARCRAFTLORE1 = "/wcl"
SlashCmdList.WARCRAFTLORE = function(msg)
    local ok, cmd = pcall(function() return strtrim((msg or ""):lower()) end)
    local run = guardedCommands[ok and cmd or "help"] or guardedCommands.help
    run()
end

-------------------------------------------------------------------- Events
local events = CreateFrame("Frame")
events:RegisterEvent("ADDON_LOADED")
events:RegisterEvent("PLAYER_TARGET_CHANGED")
C.RegisterEventSafe(events, C.EVENT_NAMEPLATE_ADDED)
C.RegisterEventSafe(events, "ITEM_TEXT_BEGIN")
local onAddonLoaded = guard("init", L["the addon setup"], function()
    -- SavedVariables are only available from here on (defaults and migrations: SavedData.lua).
    ns.SavedData.Load()
    -- Before any window is drawn: the windows take the theme's art and colors when they are built.
    ns.Style.ApplyTheme(WarcraftLoreDB.theme)
    guard("window", L["the lore window"], ns.UI.Init)()
    guard("minimap", L["the minimap button"], ns.Minimap.Init)()
    C.StartTicker(CHECK_INTERVAL, checkPosition)
    guard("tooltip-hook", L["the tooltip line"], function()
        ns.tooltipHook = C.HookUnitTooltip(onUnitTooltip)
        if not ns.tooltipHook then
            chat(L["Found no way to hook tooltips in this client, so the tooltip line is off. Type /wcl debug."])
        end
    end)()
    guard("memorial-hook", L["the memorial tooltip line"], function()
        ns.memorialHook = C.HookObjectTooltip(onObjectTooltip)
    end)()
end)

local onTargetChanged = guard("target", L["the target alert"], function()
    if not WarcraftLoreDB then
        return
    end
    local entry, npcID, _, name = ns.Lookup("target")
    if entry then
        ns.MarkMet(npcID)
        if WarcraftLoreDB.auto and not ns.FeatureOff("window") then
            if ns.UI.IsShown() then
                ns.UI.ShowEntry(npcID, entry, "target")   -- already open: follow the target
            elseif ns.Toast then
                ns.Toast.Show(npcID, entry, name, "target") -- otherwise a small pill; click for the story
            end
        end
    end
end)

events:SetScript("OnEvent", function(_, event, arg1)
    if event == C.EVENT_NAMEPLATE_ADDED then
        onNameplateAdded(arg1)
    elseif event == "ADDON_LOADED" and arg1 == ADDON_NAME then
        events:UnregisterEvent("ADDON_LOADED")
        onAddonLoaded()
    elseif event == "PLAYER_TARGET_CHANGED" then
        onTargetChanged()
    elseif event == "ITEM_TEXT_BEGIN" then
        onItemText()
    end
end)

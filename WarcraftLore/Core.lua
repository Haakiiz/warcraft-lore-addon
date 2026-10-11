-- Core.lua – lookup, tooltip line, events and the /wcl commands.
-- Every client-version-dependent call goes through ns.Compat (Compat.lua).

local ADDON_NAME, ns = ...
local C = ns.Compat

local PREFIX = "|cff8b6cd6Warcraft Lore:|r "

ns.GAME_ORDER = { "WC1", "WC2", "BTDP", "WC3", "TFT", "FK", "BOOK" }
ns.GAME_SHORT = { WC1 = "WC1", WC2 = "WC2", BTDP = "BtDP", WC3 = "WC3", TFT = "TFT", FK = "FK", BOOK = "Book" }
ns.GAME_LONG = {
    WC1 = "Warcraft: Orcs & Humans",
    WC2 = "Warcraft II: Tides of Darkness",
    BTDP = "Warcraft II: Beyond the Dark Portal",
    WC3 = "Warcraft III: Reign of Chaos",
    TFT = "Warcraft III: The Frozen Throne",
    FK = "Warcraft III Reforged: Forsaken Kingdom",
    BOOK = "Warcraft novels and books",
}
-- One color per game: bronze, red, violet, orange, ice blue, lime (Reforged's new Forsaken campaign), parchment (books).
ns.GAME_COLOR = { WC1 = "c9a46a", WC2 = "e0533f", BTDP = "b07cf0", WC3 = "f0a24a", TFT = "7cc7ef", FK = "9bd46a", BOOK = "e8dcb5" }

function ns.GameRGB(code)
    local hex = ns.GAME_COLOR[code] or "a79d8a"
    return tonumber(hex:sub(1, 2), 16) / 255, tonumber(hex:sub(3, 4), 16) / 255, tonumber(hex:sub(5, 6), 16) / 255
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
    pcall(chat, ("%s hit an error and is off until you /reload. Type /wcl debug for details."):format(label))
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

-- Short player-facing line for a met veteran ("Met 4 times · first on 3 Oct 2026 by Arthas"),
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
    local text = count == 1 and "Met once" or ("Met %d times"):format(count)
    if first then
        local ok, d = pcall(date, "%d %b %Y", first)
        if ok and type(d) == "string" then
            text = text .. " \194\183 first on " .. d
            if type(by) == "string" and by ~= "" then
                local name, realm = by:match("^(.-)%-(.+)$")
                local mine = C.GetRealmName()
                if name and mine and realm == (mine:gsub("%s", "")) then
                    by = name
                end
                text = text .. " by " .. by
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
        if not alreadyMet then
            local _, overall = ns.MetCounts()
            chat(("New veteran met: |cffd4c6f7%s|r (%s) – %d/%d met."):format(
                entry.name or "?", ns.GamesLabel(entry), overall.met, overall.total))
        end
        if ns.Browser then
            ns.Browser.Refresh()
        end
        if ns.UI then
            ns.UI.RefreshMet(npcID)
        end
    end)
    return true
end

-------------------------------------------------------------------- Tooltip
local function tooltipLine(tooltip, unit, guid)
    local entry, npcID = ns.Lookup(unit, guid)
    if not entry then
        return -- not in the database: no line
    end
    -- Any GameTooltip unit tooltip counts as meeting: mouseover in the world, on a nameplate
    -- or on a unit frame. You can only mouse over what is on screen and in view range (the
    -- same range at which nameplates show), so "seen up close" is the bar. Unreadable (secret)
    -- GUIDs give no entry above, so nothing is marked then.
    ns.MarkMet(npcID)
    local line
    if entry.confidence == "uncertain" then
        line = "Warcraft Veteran? " .. ns.GamesLabel(entry) .. " |cffa79d8a(uncertain)|r"
    else
        line = "Warcraft Veteran: " .. ns.GamesLabel(entry)
    end
    C.AddTooltipLine(tooltip, line, 0.83, 0.78, 0.97)
end
local onUnitTooltip = guard("tooltip", "the tooltip line", tooltipLine)

-------------------------------------------------------------------- Slash commands
local function cmdShow()
    if not C.UnitExists("target") then
        ns.UI.ShowMessage("You have no target. Target an NPC and type /wcl again.")
        return
    end
    local entry, npcID, guidType, name = ns.Lookup("target")
    if entry then
        ns.UI.ShowEntry(npcID, entry, "target")
    elseif npcID then
        ns.UI.ShowUnknown(name, npcID, "target")
    elseif guidType == "Player" then
        ns.UI.ShowMessage((name or "Your target") .. " is a player, not an NPC.")
    else
        ns.UI.ShowMessage("Could not read the NPC ID of your target. The client may hide it right now "
            .. "(for example in combat). Try again out of combat.")
    end
end

local function cmdID()
    if not C.UnitExists("target") then
        chat("You have no target.")
        return
    end
    local entry, npcID, guidType, name = ns.Lookup("target")
    local shownName = name or "<unknown name>"
    if npcID then
        local status = entry and "|cff40ff40in the database|r" or "|cffaaaaaanot in the database|r"
        chat(("%s – NPC ID |cffffffff%d|r (%s)"):format(shownName, npcID, status))
    elseif guidType == "Player" then
        chat(shownName .. " is a player, not an NPC.")
    elseif guidType then
        chat(shownName .. " is not an NPC (GUID type " .. guidType .. ").")
    else
        chat("Could not read the NPC ID. The client may hide the GUID right now (for example in combat).")
    end
end

ns.ShowTarget = cmdShow -- the minimap button's right-click does the same as /wcl

local function cmdList()
    ns.Browser.Toggle()
end

local function cmdMinimap()
    local shown = ns.Minimap.Toggle()
    chat("The minimap button is now " .. (shown and "|cff40ff40shown|r" or "|cffff4040hidden|r") .. ".")
end

local function cmdAuto()
    WarcraftLoreDB.auto = not WarcraftLoreDB.auto
    chat("The alert when you target a veteran is now " .. (WarcraftLoreDB.auto and "|cff40ff40ON|r" or "|cffff4040OFF|r") .. ".")
end

local function cmdAlert()
    WarcraftLoreDB.alert = not WarcraftLoreDB.alert
    chat("Nearby alerts are now " .. (WarcraftLoreDB.alert and "|cff40ff40ON|r" or "|cffff4040OFF|r") .. ".")
end

-------------------------------------------------------------------- Nearby alert
-- When a nameplate appears for an NPC in the database, say so once per session.
local alerted = {}

-- Several veterans appearing together (entering a city) are batched: after BATCH_WINDOW seconds
-- there is ONE chat line, ONE sound and ONE pill, for the first veteran, saying "+N more nearby".
local BATCH_WINDOW = 1.5
local batch -- nil, or { first = { npcID, entry, name, unit }, more = n }

local function show(npcID, entry, name, unit, more)
    local who = name or entry.name
    local extra = (more or 0) > 0 and (" |cffa79d8a+%d more nearby|r"):format(more) or ""
    chat(("Veteran nearby: |cffd4c6f7%s|r (%s).%s"):format(who, ns.GamesLabel(entry), extra))
    C.PlayAlertSound()
    if ns.Toast then
        ns.Toast.Show(npcID, entry, who, unit, more)
    end
end

local function flushBatch()
    local b = batch
    batch = nil
    if not b then
        return
    end
    local f = b.first
    local unit = f.unit
    if unit then
        -- The nameplate may be gone or reused by now: only keep it if it still shows this NPC.
        local id = C.NPCIDFromGUID(C.UnitGUID(unit))
        if id ~= f.npcID then
            unit = nil
        end
    end
    show(f.npcID, f.entry, f.name, unit, b.more)
end
local flushGuarded = function() end -- set below, once guard() is used

-- Shared by the nameplate path and the coordinate path, so nobody is announced twice.
-- unit = the nameplate unit token when there is one (used for the pill's portrait).
local function announce(npcID, entry, name, isTest, unit)
    if isTest then
        show(npcID, entry, name, unit)
        return
    end
    alerted[npcID] = true
    if batch then
        batch.more = batch.more + 1
        return
    end
    batch = { first = { npcID = npcID, entry = entry, name = name, unit = unit }, more = 0 }
    C.After(flushGuarded, BATCH_WINDOW)
end
flushGuarded = guard("alert-batch", "the nearby alert", flushBatch)

-- /wcl test: shows the alert for the database NPC with the lowest ID.
local function cmdTest()
    local lowest
    for npcID in pairs(ns.NPCS) do
        if not lowest or npcID < lowest then
            lowest = npcID
        end
    end
    if not lowest then
        chat("The database is empty.")
        return
    end
    announce(lowest, ns.NPCS[lowest], nil, true)
end

local function nameplateAdded(unit)
    if not (WarcraftLoreDB and WarcraftLoreDB.alert) or type(unit) ~= "string" then
        return
    end
    local entry, npcID, _, name = ns.Lookup(unit)
    if not entry or alerted[npcID] then
        return
    end
    announce(npcID, entry, name, false, unit)
end
local onNameplateAdded = guard("alert", "the nearby alert", nameplateAdded)

-------------------------------------------------------------------- Nearby alert (coordinates)
-- Compares the player's map position with `coords` in Data.lua (Wowhead map percent).
local CHECK_INTERVAL = 2      -- seconds between checks
local ALERT_RADIUS = 3        -- distance in map percent (0-100) that counts as "nearby"

-- Zone name -> uiMapIDs. Classic-era IDs first, Mainline IDs after; the client only
-- knows one set, so listing both is harmless. Only zones with coords in Data.lua.
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
}

-- True when the entry has stored coordinates in a zone we can match to a map.
local function hasCoords(entry)
    local x, y = tostring(entry.coords or ""):match("^%s*([%d%.]+)%s*,%s*([%d%.]+)")
    return tonumber(x) ~= nil and tonumber(y) ~= nil and ZONE_MAPS[entry.zone] ~= nil
end

-- uiMapID -> list of { npcID, x, y } (x, y in percent), built once on first use.
local byMap
local function buildIndex()
    byMap = {}
    for npcID, entry in pairs(ns.NPCS) do
        local x, y = tostring(entry.coords or ""):match("^%s*([%d%.]+)%s*,%s*([%d%.]+)")
        x, y = tonumber(x), tonumber(y)
        local maps = ZONE_MAPS[entry.zone]
        if x and y and maps then
            for _, mapID in ipairs(maps) do
                byMap[mapID] = byMap[mapID] or {}
                table.insert(byMap[mapID], { npcID, x, y })
            end
        end
    end
end

local function positionCheck()
    if not (WarcraftLoreDB and WarcraftLoreDB.alert) or C.InInstance() then
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
    for _, npc in ipairs(list) do
        local npcID = npc[1]
        if not alerted[npcID] then
            local dx, dy = px - npc[2], py - npc[3]
            if dx * dx + dy * dy <= ALERT_RADIUS * ALERT_RADIUS then
                announce(npcID, ns.NPCS[npcID])
            end
        end
    end
end
local checkPosition = guard("position", "the nearby alert by map position", positionCheck)

local function cmdDebug()
    local r = C.Report()
    chat(("build %s, interface %s, issecretvalue=%s, TooltipDataProcessor=%s, tooltip hook=%s")
        :format(tostring(r.build), tostring(r.interface), tostring(r.issecretvalue),
            tostring(r.tooltipDataProcessor), tostring(ns.tooltipHook)))
    local missing = {}
    for k in pairs(C.missing) do
        missing[#missing + 1] = k
    end
    table.sort(missing)
    chat("Missing: " .. (#missing > 0 and table.concat(missing, ", ") or "nothing"))
    local n = 0
    for _ in pairs(ns.NPCS) do
        n = n + 1
    end
    chat("NPCs in the database: " .. n)
    if #failureOrder == 0 then
        chat("Errors: none")
    end
    for _, key in ipairs(failureOrder) do
        local f = failures[key]
        chat(("Error in %s (off for this session): %s"):format(f.label, f.err))
    end
end

-- /wcl why: explains in one or two lines why the target is or is not recognised.
local function cmdWhy()
    if not C.UnitExists("target") then
        chat("You have no target. Target an NPC and type /wcl why.")
        return
    end
    local entry, npcID, guidType, name = ns.Lookup("target")
    local shown = name or "Your target"
    if not npcID then
        if guidType == "Player" then
            chat(shown .. " is a player, not an NPC, so there is nothing to recognise.")
        elseif guidType then
            chat(shown .. " is not an NPC (GUID type " .. guidType .. ").")
        else
            chat(shown .. ": the client hides this unit's ID right now (a secret value, often in combat). Try again out of combat.")
        end
        return
    end
    if not entry then
        chat(("%s has NPC ID %d, which is not in the database, so there is no tooltip line, alert or story."):format(shown, npcID))
        return
    end
    chat(("%s is a veteran (NPC ID %d, %s)."):format(shown, npcID, ns.GamesLabel(entry)))
    local notes = {}
    if not WarcraftLoreDB.alert then
        notes[#notes + 1] = "nearby alerts are off (/wcl alert)"
    else
        if disabled.alert then
            notes[#notes + 1] = "the nameplate alert is off after an error"
        end
        if disabled.position then
            notes[#notes + 1] = "the map position alert is off after an error"
        elseif C.InInstance() then
            notes[#notes + 1] = "you are in an instance, so map position alerts are off"
        elseif not hasCoords(entry) then
            notes[#notes + 1] = "no map position is stored for this NPC, so only its nameplate can trigger an alert"
        end
        if alerted[npcID] then
            notes[#notes + 1] = "you were already alerted about it this session"
        end
    end
    if disabled.tooltip then
        notes[#notes + 1] = "the tooltip line is off after an error"
    end
    chat(#notes > 0 and ("Note: " .. table.concat(notes, "; ") .. ".")
        or "Its tooltip line, alerts and story are all active.")
end

local function cmdHelp()
    chat("/wcl – open the window for your target")
    chat("/wcl id – print your target's NPC ID and name in chat")
    chat("/wcl list (or /wcl browse) – open or close the veterans list: search, filter, see who you have met")
    chat("/wcl auto – show a small alert when you target a veteran (now: " .. (WarcraftLoreDB.auto and "on" or "off") .. ")")
    chat("/wcl alert – toggle the nearby alert (now: " .. (WarcraftLoreDB.alert and "on" or "off") .. "); by nameplate and map position")
    chat("/wcl minimap – show or hide the minimap button (now: " .. ((WarcraftLoreDB.minimap and WarcraftLoreDB.minimap.hide) and "hidden" or "shown") .. ")")
    chat("/wcl why – explain why your target is or is not recognised")
    chat("/wcl test – show a test alert (small pill, chat line, sound)")
    chat("/wcl reset – move the windows back to the center")
    chat("/wcl options – open the Warcraft Lore settings")
    chat("/wcl debug – show which APIs the client has")
end

local COMMANDS = {
    [""] = cmdShow, id = cmdID, list = cmdList, browse = cmdList, minimap = cmdMinimap,
    auto = cmdAuto, alert = cmdAlert, test = cmdTest, ["alert test"] = cmdTest, why = cmdWhy,
    debug = cmdDebug,
    options = function()
        if not (ns.Options and ns.Options.Open()) then
            chat("This client has no settings panel for Warcraft Lore.")
        end
    end,
    reset = function()
        ns.UI.ResetPosition()
        ns.Browser.ResetPosition()
        chat("The windows are back in the center.")
    end,
}
local guardedCommands = {}
for name, fn in pairs(COMMANDS) do
    local shown = name == "" and "/wcl" or ("/wcl " .. name)
    guardedCommands[name] = guard("cmd:" .. name, "the " .. shown .. " command", fn)
end
guardedCommands.help = guard("cmd:help", "the /wcl help command", cmdHelp)

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
local onAddonLoaded = guard("init", "the addon setup", function()
    -- SavedVariables are only available from here on (defaults and migrations: SavedData.lua).
    ns.SavedData.Load()
    guard("window", "the lore window", ns.UI.Init)()
    guard("minimap", "the minimap button", ns.Minimap.Init)()
    C.StartTicker(CHECK_INTERVAL, checkPosition)
    guard("tooltip-hook", "the tooltip line", function()
        ns.tooltipHook = C.HookUnitTooltip(onUnitTooltip)
        if not ns.tooltipHook then
            chat("Found no way to hook tooltips in this client, so the tooltip line is off. Type /wcl debug.")
        end
    end)()
end)

local onTargetChanged = guard("target", "the target alert", function()
    if not WarcraftLoreDB then
        return
    end
    local entry, npcID, _, name = ns.Lookup("target")
    if entry then
        ns.MarkMet(npcID)
        if WarcraftLoreDB.auto then
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
    end
end)

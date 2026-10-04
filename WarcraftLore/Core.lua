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
function ns.GamesLabel(entry)
    local parts = {}
    for _, code in ipairs(ns.GamesInOrder(entry)) do
        parts[#parts + 1] = "|cff" .. ns.GAME_COLOR[code] .. ns.GAME_SHORT[code] .. "|r"
    end
    return table.concat(parts, " · ")
end

-------------------------------------------------------------------- Tooltip
local function onUnitTooltip(tooltip, unit, guid)
    local entry = ns.Lookup(unit, guid)
    if not entry then
        return -- not in the database: no line
    end
    local line
    if entry.confidence == "uncertain" then
        line = "Warcraft Veteran? " .. ns.GamesLabel(entry) .. " |cffa79d8a(uncertain)|r"
    else
        line = "Warcraft Veteran: " .. ns.GamesLabel(entry)
    end
    C.AddTooltipLine(tooltip, line, 0.83, 0.78, 0.97)
end

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

local function cmdAuto()
    WarcraftLoreDB.auto = not WarcraftLoreDB.auto
    chat("Auto-open is now " .. (WarcraftLoreDB.auto and "|cff40ff40ON|r" or "|cffff4040OFF|r") .. ".")
end

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
end

local function cmdHelp()
    chat("/wcl – open the window for your target")
    chat("/wcl id – print your target's NPC ID and name in chat")
    chat("/wcl auto – toggle auto-open (now: " .. (WarcraftLoreDB.auto and "on" or "off") .. ")")
    chat("/wcl reset – move the window back to the center")
    chat("/wcl debug – show which APIs the client has")
end

SLASH_WARCRAFTLORE1 = "/wcl"
SlashCmdList.WARCRAFTLORE = function(msg)
    local cmd = strtrim((msg or ""):lower())
    if cmd == "" then
        cmdShow()
    elseif cmd == "id" then
        cmdID()
    elseif cmd == "auto" then
        cmdAuto()
    elseif cmd == "reset" then
        ns.UI.ResetPosition()
        chat("The window is back in the center.")
    elseif cmd == "debug" then
        cmdDebug()
    else
        cmdHelp()
    end
end

-------------------------------------------------------------------- Events
local events = CreateFrame("Frame")
events:RegisterEvent("ADDON_LOADED")
events:RegisterEvent("PLAYER_TARGET_CHANGED")
events:SetScript("OnEvent", function(_, event, arg1)
    if event == "ADDON_LOADED" and arg1 == ADDON_NAME then
        -- SavedVariables are only available from here on.
        WarcraftLoreDB = WarcraftLoreDB or {}
        if WarcraftLoreDB.auto == nil then
            WarcraftLoreDB.auto = true
        end
        ns.UI.Init()
        ns.tooltipHook = C.HookUnitTooltip(onUnitTooltip)
        if not ns.tooltipHook then
            chat("Found no way to hook tooltips in this client, so the tooltip line is off. Type /wcl debug.")
        end
        events:UnregisterEvent("ADDON_LOADED")
    elseif event == "PLAYER_TARGET_CHANGED" then
        if not (WarcraftLoreDB and WarcraftLoreDB.auto) then
            return
        end
        local entry, npcID = ns.Lookup("target")
        if entry then
            ns.UI.ShowEntry(npcID, entry, "target")
        end
    end
end)

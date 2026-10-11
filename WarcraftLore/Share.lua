-- Share.lua – export and import of the met list as a short text string (/wcl export, /wcl import).
-- Format: "WCL1:" + entries "id.first.count" (base 36) joined by ";" + "~" + 4-character checksum.
-- The encode/decode/merge functions are pure so they can be tested without a client.

local _, ns = ...
local C = ns.Compat
local S = ns.Style

local Share = {}
ns.Share = Share

local PREFIX = "|cff8b6cd6Warcraft Lore:|r "
local VERSION = "WCL1:"
local DIGITS = "0123456789abcdefghijklmnopqrstuvwxyz"
local CHECK_MOD = 36 ^ 4

local function toBase36(n)
    n = math.floor(tonumber(n) or 0)
    if n <= 0 then
        return "0"
    end
    local out = ""
    while n > 0 do
        local d = n % 36
        out = DIGITS:sub(d + 1, d + 1) .. out
        n = (n - d) / 36
    end
    return out
end

local function fromBase36(s)
    if type(s) ~= "string" or not s:find("^[0-9a-z]+$") then
        return nil
    end
    local n = 0
    for i = 1, #s do
        n = n * 36 + (DIGITS:find(s:sub(i, i), 1, true) - 1)
    end
    return n
end

-- Simple position-weighted checksum of a string, as 4 base-36 characters.
local function checksum(s)
    local sum = 0
    for i = 1, #s do
        sum = (sum * 31 + s:byte(i) * ((i % 251) + 1)) % CHECK_MOD
    end
    local out = toBase36(sum)
    return string.rep("0", 4 - #out) .. out
end

Share.Checksum = checksum

-- Builds the export string from a met table (met[npcID] = { first, count }).
function Share.Encode(met)
    local ids = {}
    for id, e in pairs(type(met) == "table" and met or {}) do
        if type(id) == "number" and type(e) == "table" and tonumber(e.first) then
            ids[#ids + 1] = id
        end
    end
    table.sort(ids)
    local parts = {}
    for _, id in ipairs(ids) do
        local e = met[id]
        local count = math.max(1, math.floor(tonumber(e.count) or 1))
        parts[#parts + 1] = toBase36(id) .. "." .. toBase36(e.first) .. "." .. toBase36(count)
    end
    local body = VERSION .. table.concat(parts, ";")
    return body .. "~" .. checksum(body)
end

-- Reads an export string. Returns a list of { id, first, count }, or nil and a reason.
function Share.Decode(str)
    if type(str) ~= "string" then
        return nil, "empty"
    end
    str = str:gsub("%s+", "")
    if str == "" then
        return nil, "empty"
    end
    if not str:find("^WCL%d+:") then
        return nil, "format"
    end
    if str:sub(1, #VERSION) ~= VERSION then
        return nil, "version"
    end
    local body, check = str:match("^(.*)~([0-9a-z]+)$")
    if not body or check ~= checksum(body) then
        return nil, "damaged"
    end
    local list = {}
    local data = body:sub(#VERSION + 1)
    if data ~= "" then
        for entry in (data .. ";"):gmatch("([^;]*);") do
            local a, b, c = entry:match("^([0-9a-z]+)%.([0-9a-z]+)%.([0-9a-z]+)$")
            local id, first, count = fromBase36(a), fromBase36(b), fromBase36(c)
            if not id or not first or not count or count < 1 then
                return nil, "damaged"
            end
            list[#list + 1] = { id = id, first = first, count = count }
        end
    end
    return list
end

-- Merges decoded entries into met. The earliest first time wins, the larger count wins, nothing
-- is deleted and NPC IDs that are not in npcs are ignored. Returns imported, new.
function Share.Merge(met, list, npcs)
    local imported, new = 0, 0
    for _, item in ipairs(list) do
        if npcs[item.id] then
            imported = imported + 1
            local e = met[item.id]
            if type(e) ~= "table" then
                met[item.id] = { first = item.first, count = item.count }
                new = new + 1
            else
                local old = tonumber(e.first)
                if not old or item.first < old then
                    e.first = item.first
                    e.by = nil -- which character met it first is no longer known
                end
                e.count = math.max(tonumber(e.count) or 0, item.count)
            end
        end
    end
    return imported, new
end

local ERRORS = {
    empty = "Nothing to import. Paste an export string first.",
    format = "That is not a Warcraft Lore export string. Nothing was changed.",
    version = "That string comes from a different version of the addon. Nothing was changed.",
    damaged = "That string looks damaged or incomplete. Nothing was changed.",
}

-- Decodes str and merges it into WarcraftLoreDB.met. Returns ok and the chat line.
function Share.Import(str)
    local db = WarcraftLoreDB
    if type(db) ~= "table" or type(db.met) ~= "table" then
        return false, "The met list is not available right now. Nothing was changed."
    end
    local list, reason = Share.Decode(str)
    if not list then
        return false, ERRORS[reason] or ERRORS.damaged
    end
    local imported, new = Share.Merge(db.met, list, ns.NPCS)
    return true, ("Imported %d %s (%d new)."):format(imported, imported == 1 and "veteran" or "veterans", new)
end

-------------------------------------------------------------------- window
local WIDTH, HEIGHT = 440, 250
local TITLE_EXPORT, TITLE_IMPORT = "Export met veterans", "Import met veterans"
local frame, box, importBtn, hint, titleFs

local function say(msg)
    C.Print(PREFIX .. msg)
end

local function build()
    local f = CreateFrame("Frame", "WarcraftLoreShare", UIParent)
    f:SetSize(WIDTH, HEIGHT)
    f:SetPoint("CENTER")
    f:SetFrameStrata("DIALOG")
    f:SetClampedToScreen(true)
    f:SetMovable(true)
    f:EnableMouse(true)
    f:RegisterForDrag("LeftButton")
    f:SetScript("OnDragStart", f.StartMoving)
    f:SetScript("OnDragStop", f.StopMovingOrSizing)
    f:Hide()
    C.RegisterEscapeClose(f)

    S.buildFrameArt(f, WIDTH, HEIGHT)
    local inner = S.buildInner(f)
    S.buildHeader(inner, TITLE_EXPORT, function() f:Hide() end)
    -- buildHeader does not return its title, so find it to change the text for import.
    pcall(function()
        for _, region in ipairs({ inner:GetRegions() }) do
            if region.GetText and region:GetText() == TITLE_EXPORT then
                titleFs = region
            end
        end
    end)

    hint = S.text(inner, C.FONT_BODY, 12, S.COL.text)
    hint:SetPoint("TOPLEFT", 16, -42)
    hint:SetPoint("TOPRIGHT", -16, -42)
    hint:SetJustifyH("LEFT")

    local holder = S.box(inner)
    holder:SetPoint("TOPLEFT", 16, -64)
    holder:SetPoint("BOTTOMRIGHT", -16, 48)
    holder:SetColors(S.COL.outer, 1, S.COL.headerLine, 1)

    local scroll = CreateFrame("ScrollFrame", nil, holder)
    scroll:SetPoint("TOPLEFT", 6, -6)
    scroll:SetPoint("BOTTOMRIGHT", -6, 6)
    scroll:EnableMouseWheel(true)

    local b = C.CreateEditBox(scroll, C.FONT_BODY, 12)
    if not b then
        return nil
    end
    local ok = pcall(function()
        b:SetMultiLine(true)
        b:SetMaxLetters(0)
        b:SetWidth(WIDTH - 2 * 24 - 12 - 16)
        b:SetHeight(400)
        b:SetTextColor(S.COL.title[1], S.COL.title[2], S.COL.title[3])
        b:SetScript("OnEscapePressed", function() f:Hide() end)
        scroll:SetScrollChild(b)
        scroll:SetScript("OnMouseWheel", function(_, delta)
            local max = math.max(0, b:GetHeight() - scroll:GetHeight())
            scroll:SetVerticalScroll(math.min(max, math.max(0, scroll:GetVerticalScroll() - delta * 30)))
        end)
    end)
    if not ok then
        return nil
    end
    box = b

    importBtn = S.box(inner, "Button")
    importBtn:SetSize(110, 26)
    importBtn:SetPoint("BOTTOMRIGHT", -16, 12)
    importBtn:SetColors(S.COL.header, 1, S.COL.headerLine, 1)
    C.RegisterClicks(importBtn)
    local label = S.text(importBtn, C.FONT_BODY, 12, S.COL.title)
    label:SetPoint("CENTER")
    label:SetText("Import")
    importBtn:SetScript("OnEnter", function() importBtn:SetColors(S.COL.header, 1, S.COL.violet, 1) end)
    importBtn:SetScript("OnLeave", function() importBtn:SetColors(S.COL.header, 1, S.COL.headerLine, 1) end)
    local function doImport()
        local ok2, line = Share.Import(box:GetText())
        say(line)
        if ok2 then
            f:Hide()
            if ns.Browser and ns.Browser.Refresh then
                pcall(ns.Browser.Refresh, true)
            end
        end
    end
    importBtn:SetScript("OnClick", ns.Guard and ns.Guard("import", "the import", doImport) or doImport)
    return f
end

-- which = "export" or "import". Says so in chat if the client cannot make the text box.
function Share.Open(which)
    if not frame then
        frame = build()
    end
    if not frame then
        say("Import and export are not available in this client.")
        return
    end
    if which == "export" then
        if titleFs then titleFs:SetText(TITLE_EXPORT) end
        hint:SetText("Copy this text with Ctrl+C. Paste it with /wcl import on another account.")
        importBtn:Hide()
        box:SetText(Share.Encode(type(WarcraftLoreDB) == "table" and WarcraftLoreDB.met or {}))
        frame:Show()
        box:SetFocus()
        box:HighlightText()
    else
        if titleFs then titleFs:SetText(TITLE_IMPORT) end
        hint:SetText("Paste an export string below, then press Import. Nothing is ever deleted.")
        importBtn:Show()
        box:SetText("")
        frame:Show()
        box:SetFocus()
    end
end

-- Share.lua – export and import of the met list as a short text string (/wcl export, /wcl import).
-- Format: "WCL1:" + entries "id.first.count" (base 36) joined by ";" + "~" + 4-character checksum.
-- The encode/decode/merge functions are pure so they can be tested without a client.

local _, ns = ...
local C = ns.Compat
local L = ns.L
local S = ns.Style

local Share = {}
ns.Share = Share

local PREFIX = "|cff8b6cd6Warcraft Lore:|r "
local VERSION = "WCL1:"
local DIGITS = "0123456789abcdefghijklmnopqrstuvwxyz"
local CHECK_MOD = 36 ^ 4
local MIN_FIRST = 1072915200 -- 1 Jan 2004, before the game existed
local MAX_FIRST = 4102444800 -- 1 Jan 2100
local MAX_COUNT = 99999

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
            -- A hand-edited string can carry silly values; keep them in a believable range.
            first = math.min(math.max(first, MIN_FIRST), MAX_FIRST)
            count = math.min(count, MAX_COUNT)
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
    empty = L["Nothing to import. Paste an export string first."],
    format = L["That is not a Warcraft Lore export string. Nothing was changed."],
    version = L["That string comes from a different version of the addon. Nothing was changed."],
    damaged = L["That string looks damaged or incomplete. Nothing was changed."],
}

-- Decodes str and merges it into WarcraftLoreDB.met. Returns ok and the chat line.
function Share.Import(str)
    local db = WarcraftLoreDB
    if type(db) ~= "table" or type(db.met) ~= "table" then
        return false, L["The met list is not available right now. Nothing was changed."]
    end
    local list, reason = Share.Decode(str)
    if not list then
        return false, ERRORS[reason] or ERRORS.damaged
    end
    local imported, new = Share.Merge(db.met, list, ns.NPCS)
    return true, (imported == 1 and L["Imported %d veteran (%d new)."] or L["Imported %d veterans (%d new)."]):format(imported, new)
end

-------------------------------------------------------------------- window
local WIDTH, HEIGHT = 440, 250
local TITLE_EXPORT, TITLE_IMPORT = L["Export met veterans"], L["Import met veterans"]
local frame, box, importBtn, hint, titleFs
local exportMode = false

-- Width of the edit box: window - two vine bands - holder insets (2 * 16) - scroll insets (2 * 6).
function Share.EditWidth(windowWidth, band)
    return windowWidth - 2 * band - 32 - 12
end

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
    local _, title = S.buildHeader(inner, TITLE_EXPORT, function() f:Hide() end)
    titleFs = title

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
        b:SetWidth(Share.EditWidth(WIDTH, S.BAND))
        b:SetHeight(HEIGHT - 2 * S.BAND - 124) -- start as tall as the view; a multi-line box grows with its text
        b:SetTextColor(S.COL.title[1], S.COL.title[2], S.COL.title[3])
        b:SetScript("OnEscapePressed", function() f:Hide() end)
        scroll:SetScrollChild(b)
        local function wheel(_, delta)
            local max = math.max(0, b:GetHeight() - scroll:GetHeight())
            scroll:SetVerticalScroll(math.min(max, math.max(0, scroll:GetVerticalScroll() - delta * 30)))
        end
        scroll:SetScript("OnMouseWheel", wheel)
        b:EnableMouseWheel(true) -- the box covers the scroll frame, so it needs the wheel too
        b:SetScript("OnMouseWheel", wheel)
        -- Keep the cursor in view while typing or pasting.
        b:SetScript("OnCursorChanged", function(_, _, y, _, h)
            y = -y
            local top, view = scroll:GetVerticalScroll(), scroll:GetHeight()
            if y < top then
                scroll:SetVerticalScroll(y)
            elseif y + h > top + view then
                scroll:SetVerticalScroll(y + h - view)
            end
        end)
        -- In export mode a click would drop the highlight, so select everything again on focus.
        b:SetScript("OnEditFocusGained", function(self)
            if exportMode then self:HighlightText() end
        end)
        -- The box already has focus when it opens, so a click needs this too.
        b:SetScript("OnMouseUp", function(self)
            if exportMode then self:HighlightText() end
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
    label:SetText(L["Import"])
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
            if ns.UI and ns.UI.RefreshOpen then
                pcall(ns.UI.RefreshOpen)
            end
        end
    end
    importBtn:SetScript("OnClick", ns.Guard and ns.Guard("import", L["the import"], doImport) or doImport)
    return f
end

-- which = "export" or "import". Says so in chat if the client cannot make the text box.
function Share.Open(which)
    if not frame then
        frame = build()
    end
    if not frame then
        say(L["Import and export are not available in this client."])
        return
    end
    if which == "export" then
        if titleFs then titleFs:SetText(TITLE_EXPORT) end
        hint:SetText(L["Copy this text with Ctrl+C. Paste it with /wcl import on another account."])
        importBtn:Hide()
        exportMode = true
        local met = type(WarcraftLoreDB) == "table" and WarcraftLoreDB.met or {}
        if next(met) == nil then
            hint:SetText(L["You have not met any veterans yet, so there is nothing to export."])
        end
        box:SetText(Share.Encode(met))
        frame:Show()
        box:SetFocus()
        box:HighlightText()
    else
        if titleFs then titleFs:SetText(TITLE_IMPORT) end
        hint:SetText(L["Paste an export string below, then press Import. Nothing is ever deleted."])
        importBtn:Show()
        exportMode = false
        box:SetText("")
        frame:Show()
        box:SetFocus()
    end
end

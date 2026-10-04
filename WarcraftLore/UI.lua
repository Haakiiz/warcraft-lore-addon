-- UI.lua – the lore window: violet frame with turquoise vines, a round portrait
-- with a glow in the game's color, and one box per game.

local ADDON_NAME, ns = ...
local C = ns.Compat

local UI = {}
ns.UI = UI

local TEX = "Interface\\AddOns\\" .. ADDON_NAME .. "\\Textures\\"
local PORTRAITS = "Interface\\AddOns\\" .. ADDON_NAME .. "\\Portraits\\"
local QUESTION_MARK = "Interface\\Icons\\INV_Misc_QuestionMark"

local W, H = 460, 580      -- window size
local BAND = 20            -- width of the vine band around the window
local PAD = 12             -- inner padding
local HEADER = 26          -- height of the title band
local RING = 96            -- portrait ring size
local INNER_W = W - 2 * BAND
local CONTENT_W = INNER_W - 2 * PAD
local VINE_TILE = 80       -- on-screen length of one vine tile (128x32 texture shown 20 px high)

local function rgb(hex)
    return tonumber(hex:sub(1, 2), 16) / 255, tonumber(hex:sub(3, 4), 16) / 255, tonumber(hex:sub(5, 6), 16) / 255
end

local COL = {
    outer = { rgb("120f1c") }, inner = { rgb("100d18") }, header = { rgb("181226") },
    headerLine = { rgb("3d2a78") }, violet = { rgb("8b6cd6") }, teal = { rgb("2a6f68") },
    title = { rgb("d4c6f7") }, text = { rgb("d9d2c3") }, muted = { rgb("a79d8a") },
    divider = { rgb("2d2347") }, uncertain = { rgb("e0b04a") }, dim = { rgb("4d4434") },
}
local HEX_MUTED = "|cffa79d8a"
local HEX_TITLE = "|cffd4c6f7"
local END = "|r"

-------------------------------------------------------------------- small builders
local function solid(parent, layer, c, a)
    local t = parent:CreateTexture(nil, layer)
    t:SetColorTexture(c[1], c[2], c[3], a or 1)
    return t
end

local function text(parent, font, size, c)
    local fs = parent:CreateFontString(nil, "OVERLAY")
    C.SetFont(fs, font, size)
    fs:SetJustifyH("LEFT")
    fs:SetJustifyV("TOP")
    if c then
        fs:SetTextColor(c[1], c[2], c[3])
    end
    return fs
end

-- Four textures forming a rectangle outline, `inset` px inside the parent.
local function outline(parent, inset, thickness, c, layer)
    local t = solid(parent, layer, c); t:SetPoint("TOPLEFT", inset, -inset); t:SetPoint("TOPRIGHT", -inset, -inset); t:SetHeight(thickness)
    local b = solid(parent, layer, c); b:SetPoint("BOTTOMLEFT", inset, inset); b:SetPoint("BOTTOMRIGHT", -inset, inset); b:SetHeight(thickness)
    local l = solid(parent, layer, c); l:SetPoint("TOPLEFT", inset, -inset); l:SetPoint("BOTTOMLEFT", inset, inset); l:SetWidth(thickness)
    local r = solid(parent, layer, c); r:SetPoint("TOPRIGHT", -inset, -inset); r:SetPoint("BOTTOMRIGHT", -inset, inset); r:SetWidth(thickness)
    return { t, b, l, r }
end

-- A frame with a flat background and a 1 px border whose colors can change.
local function box(parent)
    local f = CreateFrame("Frame", nil, parent)
    f.bg = solid(f, "BACKGROUND", COL.inner)
    f.bg:SetAllPoints()
    f.edges = outline(f, 0, 1, COL.violet, "BORDER")
    function f:SetColors(fill, fillAlpha, edge, edgeAlpha)
        self.bg:SetColorTexture(fill[1], fill[2], fill[3], fillAlpha)
        for _, e in ipairs(self.edges) do
            e:SetColorTexture(edge[1], edge[2], edge[3], edgeAlpha)
        end
    end
    return f
end

local function badge(parent)
    local b = box(parent)
    b:SetHeight(16)
    b.label = text(b, C.FONT_BODY, 10)
    b.label:SetPoint("CENTER", b, "CENTER", 0, 0)
    b.label:SetJustifyV("MIDDLE")
    function b:Set(label, c)
        self.label:SetText(label)
        self.label:SetTextColor(c[1], c[2], c[3])
        self:SetColors(c, 0.12, c, 1)
        self:SetWidth(math.floor(self.label:GetStringWidth() + 14))
        self:Show()
    end
    return b
end

-------------------------------------------------------------------- the window
local frame, nameText, placeText, idText, portrait, portraitRing
local ringParts = {}
local headerBadges = {}
local scroll, content
local gameBoxes, sections = {}, {}

local function savePosition()
    local point, _, relativePoint, x, y = frame:GetPoint(1)
    WarcraftLoreDB.pos = { point = point, relativePoint = relativePoint, x = x, y = y }
end

local function applyPosition()
    frame:ClearAllPoints()
    local pos = WarcraftLoreDB.pos
    if pos and pos.point then
        frame:SetPoint(pos.point, UIParent, pos.relativePoint or pos.point, pos.x or 0, pos.y or 0)
    else
        frame:SetPoint("CENTER", UIParent, "CENTER", 0, 40)
    end
end

function UI.ResetPosition()
    WarcraftLoreDB.pos = nil
    if frame then
        applyPosition()
    end
end

-- Violet outer lines, turquoise vines along all four edges, rosettes in the corners.
local function buildFrameArt(f)
    local bg = solid(f, "BACKGROUND", COL.outer)
    bg:SetAllPoints()
    outline(f, 0, 3, COL.violet, "BORDER")
    outline(f, 6, 1, COL.teal, "BORDER")

    local half = BAND / 2
    local spanH, spanV = W - 2 * 24, H - 2 * 24
    local tilesH, tilesV = spanH / VINE_TILE, spanV / VINE_TILE

    local top = f:CreateTexture(nil, "ARTWORK")
    top:SetPoint("TOPLEFT", 24, 0); top:SetSize(spanH, BAND)
    C.SetTiledTexture(top, TEX .. "VineH", tilesH, 1)
    local bottom = f:CreateTexture(nil, "ARTWORK")
    bottom:SetPoint("BOTTOMLEFT", 24, 0); bottom:SetSize(spanH, BAND)
    C.SetTiledTexture(bottom, TEX .. "VineH", tilesH, -1)
    local left = f:CreateTexture(nil, "ARTWORK")
    left:SetPoint("TOPLEFT", 0, -24); left:SetSize(BAND, spanV)
    C.SetTiledTexture(left, TEX .. "VineV", 1, tilesV)
    local right = f:CreateTexture(nil, "ARTWORK")
    right:SetPoint("TOPRIGHT", 0, -24); right:SetSize(BAND, spanV)
    C.SetTiledTexture(right, TEX .. "VineV", -1, tilesV)

    -- Rosettes: the texture's leaves point right and down, so mirror it per corner.
    local corners = {
        { "CENTER", "TOPLEFT", half, -half, 0, 1, 0, 1 },
        { "CENTER", "TOPRIGHT", -half, -half, 1, 0, 0, 1 },
        { "CENTER", "BOTTOMLEFT", half, half, 0, 1, 1, 0 },
        { "CENTER", "BOTTOMRIGHT", -half, half, 1, 0, 1, 0 },
    }
    for _, c in ipairs(corners) do
        local t = f:CreateTexture(nil, "OVERLAY")
        t:SetTexture(TEX .. "Corner")
        t:SetSize(34, 34)
        t:SetPoint(c[1], f, c[2], c[3], c[4])
        t:SetTexCoord(c[5], c[6], c[7], c[8])
    end
end

local function buildHeader(inner)
    local band = solid(inner, "BORDER", COL.header)
    band:SetPoint("TOPLEFT"); band:SetPoint("TOPRIGHT"); band:SetHeight(HEADER)
    local line = solid(inner, "BORDER", COL.headerLine)
    line:SetPoint("TOPLEFT", 0, -HEADER); line:SetPoint("TOPRIGHT", 0, -HEADER); line:SetHeight(1)

    local title = text(inner, C.FONT_TITLE, 14, COL.title)
    title:SetPoint("LEFT", inner, "TOPLEFT", PAD, -HEADER / 2)
    title:SetJustifyV("MIDDLE")
    title:SetText("Warcraft Lore")

    local close = CreateFrame("Button", nil, inner)
    close:SetSize(22, 18)
    close:SetPoint("RIGHT", inner, "TOPRIGHT", -PAD + 4, -HEADER / 2)
    local edges = outline(close, 0, 1, COL.headerLine, "BORDER")
    local x = text(close, C.FONT_BODY, 12, COL.violet)
    x:SetPoint("CENTER", 0, 0)
    x:SetText("X")
    C.RegisterClicks(close)
    close:SetScript("OnClick", function() frame:Hide() end)
    close:SetScript("OnEnter", function()
        x:SetTextColor(COL.title[1], COL.title[2], COL.title[3])
        for _, e in ipairs(edges) do e:SetColorTexture(COL.violet[1], COL.violet[2], COL.violet[3], 1) end
    end)
    close:SetScript("OnLeave", function()
        x:SetTextColor(COL.violet[1], COL.violet[2], COL.violet[3])
        for _, e in ipairs(edges) do e:SetColorTexture(COL.headerLine[1], COL.headerLine[2], COL.headerLine[3], 1) end
    end)
end

local function buildPortrait(inner)
    local holder = CreateFrame("Frame", nil, inner)
    holder:SetSize(RING, RING)
    holder:SetPoint("TOPLEFT", PAD - 6, -(HEADER + 8))

    for i = 1, 4 do
        local t = holder:CreateTexture(nil, "BORDER")
        t:SetTexture(TEX .. "RingGlow")
        ringParts[i] = t
    end

    portrait = holder:CreateTexture(nil, "ARTWORK")
    portrait:SetSize(58, 58)
    portrait:SetPoint("CENTER")
    C.ApplyCircleMask(portrait, TEX .. "CircleMask")

    portraitRing = holder:CreateTexture(nil, "OVERLAY")
    portraitRing:SetTexture(TEX .. "RingThin")
    portraitRing:SetSize(66, 66)
    portraitRing:SetPoint("CENTER")
    portraitRing:SetVertexColor(COL.violet[1], COL.violet[2], COL.violet[3])

    local x0 = PAD - 6 + RING + 8
    local wText = INNER_W - x0 - PAD
    nameText = text(inner, C.FONT_TITLE, 22, COL.title)
    nameText:SetPoint("TOPLEFT", x0, -(HEADER + 18))
    nameText:SetWidth(wText)
    nameText:SetWordWrap(false)
    placeText = text(inner, C.FONT_BODY, 11, COL.text)
    placeText:SetPoint("TOPLEFT", nameText, "BOTTOMLEFT", 0, -6)
    placeText:SetWidth(wText)
    idText = text(inner, C.FONT_BODY, 11, COL.muted)
    idText:SetPoint("TOPLEFT", placeText, "BOTTOMLEFT", 0, -3)

    for i = 1, 6 do
        local b = badge(inner)
        if i == 1 then
            b:SetPoint("TOPLEFT", idText, "BOTTOMLEFT", 0, -6)
        else
            b:SetPoint("LEFT", headerBadges[i - 1], "RIGHT", 6, 0)
        end
        b:Hide()
        headerBadges[i] = b
    end
end

-- Splits the ring between the games: whole ring for one, halves for two, quarters for more.
local function setRing(colors, alpha)
    for _, t in ipairs(ringParts) do
        t:ClearAllPoints()
        t:Hide()
    end
    local n = #colors
    local h = RING / 2
    local layout
    if n <= 1 then
        layout = { { "TOPLEFT", RING, RING, 0, 1, 0, 1 } }
    elseif n == 2 then
        layout = { { "TOPLEFT", h, RING, 0, 0.5, 0, 1 }, { "TOPRIGHT", h, RING, 0.5, 1, 0, 1 } }
    else
        layout = { { "TOPLEFT", h, h, 0, 0.5, 0, 0.5 }, { "TOPRIGHT", h, h, 0.5, 1, 0, 0.5 },
                   { "BOTTOMRIGHT", h, h, 0.5, 1, 0.5, 1 }, { "BOTTOMLEFT", h, h, 0, 0.5, 0.5, 1 } }
    end
    for i, L in ipairs(layout) do
        local t = ringParts[i]
        local c = colors[((i - 1) % math.max(n, 1)) + 1] or COL.dim
        t:SetPoint(L[1])
        t:SetSize(L[2], L[3])
        t:SetTexCoord(L[4], L[5], L[6], L[7])
        t:SetVertexColor(c[1], c[2], c[3], alpha or 1)
        t:Show()
    end
end

local function setPortrait(entry, unit)
    portrait:SetTexCoord(0, 1, 0, 1)
    if entry and entry.portrait and entry.portrait ~= "" then
        portrait:SetTexture(PORTRAITS .. entry.portrait)
    elseif unit and C.SetUnitPortrait(portrait, unit) then
        -- WoW's own portrait of the NPC
    else
        portrait:SetTexture(QUESTION_MARK)
        portrait:SetTexCoord(0.08, 0.92, 0.08, 0.92)
    end
end

-------------------------------------------------------------------- scrolling content
local function gameBox(i)
    if gameBoxes[i] then
        return gameBoxes[i]
    end
    local b = box(content)
    b:SetWidth(CONTENT_W)
    b.bar = solid(b, "ARTWORK", COL.violet)
    b.bar:SetPoint("TOPLEFT"); b.bar:SetPoint("BOTTOMLEFT"); b.bar:SetWidth(4)
    b.badge = badge(b)
    b.badge:SetPoint("TOPLEFT", 12, -8)
    b.title = text(b, C.FONT_BODY, 12)
    b.title:SetPoint("LEFT", b.badge, "RIGHT", 8, 0)
    b.title:SetJustifyV("MIDDLE")
    b.body = text(b, C.FONT_BODY, 11, COL.text)
    b.body:SetPoint("TOPLEFT", 12, -30)
    b.body:SetWidth(CONTENT_W - 22)
    b.body:SetSpacing(2)
    gameBoxes[i] = b
    return b
end

local function section(i)
    if sections[i] then
        return sections[i]
    end
    local s = CreateFrame("Frame", nil, content)
    s:SetWidth(CONTENT_W)
    s.line = solid(s, "BORDER", COL.divider)
    s.line:SetPoint("TOPLEFT"); s.line:SetPoint("TOPRIGHT"); s.line:SetHeight(1)
    s.label = text(s, C.FONT_BODY, 10, COL.violet)
    s.label:SetPoint("TOPLEFT", 0, -8)
    s.body = text(s, C.FONT_BODY, 11, COL.text)
    s.body:SetPoint("TOPLEFT", 0, -24)
    s.body:SetWidth(CONTENT_W)
    s.body:SetSpacing(2)
    sections[i] = s
    return s
end

local function clearContent()
    for _, b in ipairs(gameBoxes) do b:Hide() end
    for _, s in ipairs(sections) do s:Hide() end
end

local function layout(blocks)
    local y = 0
    for _, blk in ipairs(blocks) do
        blk:ClearAllPoints()
        blk:SetPoint("TOPLEFT", content, "TOPLEFT", 0, -y)
        blk:Show()
        y = y + blk:GetHeight() + 10
    end
    content:SetHeight(math.max(10, y))
    scroll:SetVerticalScroll(0)
end

local function fillGameBox(b, app)
    local c = { ns.GameRGB(app.game) }
    b:SetColors(c, 0.07, c, 0.45)
    b.bar:SetColorTexture(c[1], c[2], c[3], 1)
    b.badge:Set(ns.GAME_SHORT[app.game] or app.game, c)
    b.title:SetText(ns.GAME_LONG[app.game] or app.game)
    b.title:SetTextColor(c[1], c[2], c[3])
    -- Books use the same fields: campaign = book title, missions = chapters (optional).
    local isBook = app.game == "BOOK"
    local lines = {}
    if app.campaign and app.campaign ~= "" then
        lines[#lines + 1] = HEX_MUTED .. (isBook and "Book" or "Campaign") .. END .. "  " .. app.campaign
    end
    if app.missions and #app.missions > 0 then
        local label = isBook and (#app.missions == 1 and "Chapter" or "Chapters")
            or (#app.missions == 1 and "Mission" or "Missions")
        lines[#lines + 1] = HEX_MUTED .. label .. END .. "  " .. table.concat(app.missions, ", ")
    end
    if app.role and app.role ~= "" then
        lines[#lines + 1] = HEX_MUTED .. "Role" .. END .. "  " .. app.role
    end
    b.body:SetText(table.concat(lines, "\n"))
    b:SetHeight(30 + b.body:GetStringHeight() + 10)
end

local function fillSection(s, label, body, color)
    s.label:SetText(label:upper())
    s.body:SetText(body)
    local c = color or COL.text
    s.body:SetTextColor(c[1], c[2], c[3])
    s:SetHeight(24 + s.body:GetStringHeight() + 2)
end

-------------------------------------------------------------------- init
function UI.Init()
    if frame then
        return
    end
    frame = CreateFrame("Frame", "WarcraftLoreFrame", UIParent)
    frame:SetSize(W, H)
    frame:SetFrameStrata("DIALOG")
    frame:SetClampedToScreen(true)
    frame:SetMovable(true)
    frame:EnableMouse(true)
    frame:RegisterForDrag("LeftButton")
    frame:SetScript("OnDragStart", frame.StartMoving)
    frame:SetScript("OnDragStop", function(self)
        self:StopMovingOrSizing()
        savePosition()
    end)
    frame:Hide()
    C.RegisterEscapeClose(frame)

    buildFrameArt(frame)

    local inner = CreateFrame("Frame", nil, frame)
    inner:SetPoint("TOPLEFT", BAND, -BAND)
    inner:SetPoint("BOTTOMRIGHT", -BAND, BAND)
    local ibg = solid(inner, "BACKGROUND", COL.inner)
    ibg:SetAllPoints()
    outline(inner, 0, 1, COL.violet, "BORDER")

    buildHeader(inner)
    buildPortrait(inner)

    scroll = CreateFrame("ScrollFrame", nil, inner)
    scroll:SetPoint("TOPLEFT", PAD, -(HEADER + 8 + RING + 6))
    scroll:SetPoint("BOTTOMRIGHT", -PAD, PAD)
    scroll:EnableMouseWheel(true)
    scroll:SetScript("OnMouseWheel", function(self, delta)
        local new = self:GetVerticalScroll() - delta * 30
        new = math.max(0, math.min(new, self:GetVerticalScrollRange()))
        self:SetVerticalScroll(new)
    end)
    content = CreateFrame("Frame", nil, scroll)
    content:SetSize(CONTENT_W, 10)
    scroll:SetScrollChild(content)

    applyPosition()
end

local function showHeader(name, place, npcID, badges)
    nameText:SetText(name or "")
    placeText:SetText(place or "")
    idText:SetText(npcID and ("NPC ID " .. npcID) or "")
    for i, b in ipairs(headerBadges) do
        local spec = badges[i]
        if spec then
            b:Set(spec[1], spec[2])
        else
            b:Hide()
        end
    end
end

-------------------------------------------------------------------- public
function UI.ShowEntry(npcID, entry, unit)
    UI.Init()
    local games = ns.GamesInOrder(entry)
    local ringColors, badges = {}, {}
    for _, g in ipairs(games) do
        local c = { ns.GameRGB(g) }
        ringColors[#ringColors + 1] = c
        badges[#badges + 1] = { ns.GAME_SHORT[g], c }
    end
    if entry.confidence == "uncertain" then
        badges[#badges + 1] = { "UNCERTAIN", COL.uncertain }
    end
    local place = entry.zone or ""
    if entry.coords and entry.coords ~= "" then
        place = place .. " · " .. entry.coords
    end
    if entry.alsoIn and #entry.alsoIn > 0 then
        place = place .. "\n" .. HEX_MUTED .. "Also in " .. table.concat(entry.alsoIn, ", ") .. END
    end
    showHeader(entry.name, place, npcID, badges)
    setRing(ringColors, 1)
    setPortrait(entry, unit)

    clearContent()
    local blocks = {}
    for i, app in ipairs(entry.appearances or {}) do
        local b = gameBox(i)
        fillGameBox(b, app)
        blocks[#blocks + 1] = b
    end
    local n = 0
    local function add(label, body, color)
        n = n + 1
        local s = section(n)
        fillSection(s, label, body, color)
        blocks[#blocks + 1] = s
    end
    if entry.confidence == "uncertain" then
        add("Why uncertain", entry.searched or "", COL.uncertain)
    end
    if entry.story and entry.story ~= "" then
        add("Story", entry.story)
    end
    local items = {}
    for _, item in ipairs(entry.items or {}) do
        local line = HEX_TITLE .. (item.name or "?") .. END .. HEX_MUTED .. " · item ID " .. tostring(item.id) .. END
        if item.note and item.note ~= "" then
            line = line .. "\n" .. HEX_MUTED .. item.note .. END
        end
        items[#items + 1] = line
    end
    add("Items in WoW", #items > 0 and table.concat(items, "\n") or (HEX_MUTED .. "None recorded." .. END))
    add("Sources", table.concat(entry.sources or {}, "\n"), COL.muted)
    layout(blocks)
    frame:Show()
end

function UI.ShowUnknown(name, npcID, unit)
    UI.Init()
    showHeader(name or "Unknown NPC", "", npcID, {})
    setRing({ COL.dim }, 0.6)
    setPortrait(nil, unit)
    clearContent()
    local s = section(1)
    fillSection(s, "No record yet",
        ("No known Warcraft history recorded for %s (NPC ID %d) yet."):format(name or "this NPC", npcID))
    layout({ s })
    frame:Show()
end

function UI.ShowMessage(msg)
    UI.Init()
    showHeader("Warcraft Lore", "", nil, {})
    setRing({ COL.dim }, 0.6)
    setPortrait(nil, nil)
    clearContent()
    local s = section(1)
    fillSection(s, "Notice", msg)
    layout({ s })
    frame:Show()
end

-- UI.lua – the lore window: violet frame with turquoise vines, a round portrait
-- with a glow in the game's color, and one box per game.

local ADDON_NAME, ns = ...
local C = ns.Compat

local UI = {}
ns.UI = UI

local TEX = "Interface\\AddOns\\" .. ADDON_NAME .. "\\Textures\\"
local PORTRAITS = "Interface\\AddOns\\" .. ADDON_NAME .. "\\Portraits\\"
local QUESTION_MARK = "Interface\\Icons\\INV_Misc_QuestionMark"

local S = ns.Style
local COL, solid, text, box, badge = S.COL, S.solid, S.text, S.box, S.badge
local BAND, PAD, HEADER = S.BAND, S.PAD, S.HEADER
local HEX_MUTED, HEX_TITLE, HEX_MET, END = S.HEX_MUTED, S.HEX_TITLE, S.HEX_MET, S.END

local W, H = 460, 580      -- window size
local RING = 96            -- portrait ring size
local INNER_W = W - 2 * BAND
local CONTENT_W = INNER_W - 2 * PAD

-------------------------------------------------------------------- the window
local frame, nameText, placeText, idText, metBadge, portrait, portraitRing
local shownNPC            -- NPC ID the lore window currently shows (nil for messages)
local ringParts = {}
local headerBadges = {}
local badgeCount = 0       -- game/uncertain badges currently shown (the MET badge follows them)
local function notifyBrowser()   -- tells the veterans list which row to highlight
    if ns.Browser then
        ns.Browser.RefreshSelection()
    end
end
local docked = false       -- true while the window sits next to the browser instead of at its saved spot
local scroll, content
local gameBoxes, sections = {}, {}
local relatedBlock         -- "Related" section with one clickable row per related veteran

local function savePosition()
    local point, _, relativePoint, x, y = frame:GetPoint(1)
    WarcraftLoreDB.pos = { point = point, relativePoint = relativePoint, x = x, y = y }
    docked = false -- dragged by hand: this is its own spot now
end

local function applyPosition()
    frame:ClearAllPoints()
    docked = false
    local pos = WarcraftLoreDB.pos
    if type(pos) == "table" and pos.point then
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
    -- Green "MET" badge after the game badges: a small filled square and the word.
    metBadge = box(inner)
    metBadge:SetHeight(16)
    metBadge.square = solid(metBadge, "ARTWORK", COL.met)
    metBadge.square:SetSize(5, 5)
    metBadge.square:SetPoint("LEFT", 8, 0)
    metBadge.label = text(metBadge, C.FONT_BODY, 10, COL.met)
    metBadge.label:SetPoint("LEFT", 18, 0)
    metBadge.label:SetJustifyV("MIDDLE")
    metBadge.label:SetText("MET")
    metBadge:SetColors(COL.met, 0.12, COL.met, 1)
    metBadge:SetWidth(math.floor(18 + metBadge.label:GetStringWidth() + 8))
    metBadge:Hide()

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

local function newSection()
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
    return s
end

local function section(i)
    if not sections[i] then
        sections[i] = newSection()
    end
    return sections[i]
end

local ROW_H = 20

-- One row in the Related block: name, game codes and zone; click to open that veteran.
local function relatedRow(i)
    local rows = relatedBlock.rows
    if rows[i] then
        return rows[i]
    end
    local r = CreateFrame("Button", nil, relatedBlock)
    r:SetSize(CONTENT_W, ROW_H)
    r:SetPoint("TOPLEFT", 0, -(22 + (i - 1) * ROW_H))
    r.hl = solid(r, "BACKGROUND", COL.violet, 0.14)
    r.hl:SetAllPoints()
    r.hl:Hide()
    r.label = text(r, C.FONT_BODY, 11, COL.text)
    r.label:SetPoint("LEFT", 6, 0)
    r.label:SetPoint("RIGHT", -6, 0)
    r.label:SetJustifyV("MIDDLE")
    r.label:SetWordWrap(false)
    C.RegisterClicks(r)
    r:SetScript("OnEnter", function(self) self.hl:Show() end)
    r:SetScript("OnLeave", function(self) self.hl:Hide() end)
    r:SetScript("OnClick", function(self)
        UI.ShowEntry(self.group.id, self.group.entry, nil, nil, true)
    end)
    rows[i] = r
    return r
end

local function fillRelated(groups)
    if not relatedBlock then
        relatedBlock = newSection()
        relatedBlock.body:Hide()
        relatedBlock.rows = {}
        relatedBlock.label:SetText("RELATED")
    end
    for _, r in ipairs(relatedBlock.rows) do r:Hide() end
    for i, g in ipairs(groups) do
        local r = relatedRow(i)
        r.group = g
        local line = HEX_TITLE .. (g.entry.name or "?") .. END .. "  " .. ns.CodesLabel(g.codes)
            .. "  " .. HEX_MUTED .. (g.entry.zone or "") .. END
        if ns.GroupMet(g) then
            line = line .. "  " .. HEX_MET .. "met" .. END
        end
        r.label:SetText(line)
        r:Show()
    end
    relatedBlock:SetHeight(22 + #groups * ROW_H + 2)
    return relatedBlock
end

local function clearContent()
    for _, b in ipairs(gameBoxes) do b:Hide() end
    for _, s in ipairs(sections) do s:Hide() end
    if relatedBlock then relatedBlock:Hide() end
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
    frame:SetScript("OnHide", notifyBrowser)
    frame:Hide()
    C.RegisterEscapeClose(frame)

    S.buildFrameArt(frame, W, H)
    local inner = S.buildInner(frame)
    S.buildHeader(inner, "Warcraft Lore", function() frame:Hide() end)
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

-- The green MET badge after the last game badge. Only for database entries you have met;
-- not met shows nothing.
local function setMetBadge(npcID)
    local group = npcID and ns.VeteranOf(npcID)
    if not (group and ns.GroupMet(group)) then
        metBadge:Hide()
        return
    end
    metBadge:ClearAllPoints()
    if badgeCount > 0 then
        metBadge:SetPoint("LEFT", headerBadges[badgeCount], "RIGHT", 6, 0)
    else
        metBadge:SetPoint("TOPLEFT", idText, "BOTTOMLEFT", 0, -6)
    end
    metBadge:Show()
end

-- Called when a veteran is met while the lore window already shows it.
function UI.RefreshMet(npcID)
    local group = ns.VeteranOf(npcID)
    if frame and frame:IsShown() and shownNPC and group and group.idSet[shownNPC] then
        npcID = shownNPC
        setMetBadge(npcID)
    end
end

-- The NPC the lore window shows right now (nil when closed or showing a message).
function UI.GetShownNPC()
    if frame and frame:IsShown() then
        return shownNPC
    end
    return nil
end

function UI.IsShown()
    return frame ~= nil and frame:IsShown()
end

-- Places the window next to `dock` (8 px to its right, or to its left when there is no room).
-- The spot is not saved: opening the window any other way goes back to the saved position.
local function dockTo(dock)
    frame:ClearAllPoints()
    local right = dock:GetRight() or 0
    if right + 8 + W > UIParent:GetWidth() and (dock:GetLeft() or 0) - 8 - W >= 0 then
        frame:SetPoint("TOPRIGHT", dock, "TOPLEFT", -8, 0)
    else
        frame:SetPoint("TOPLEFT", dock, "TOPRIGHT", 8, 0)
    end
    docked = true
end

local function showHeader(name, place, npcID, badges)
    shownNPC = nil
    metBadge:Hide()
    nameText:SetText(name or "")
    placeText:SetText(place or "")
    idText:SetText(npcID and ("NPC ID " .. npcID) or "")
    badgeCount = math.min(#badges, #headerBadges)
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
-- dock = optional frame to sit next to (the veterans list); nil = the saved position.
-- keepPlace = true leaves the window where it is (used by the Related links).
function UI.ShowEntry(npcID, entry, unit, dock, keepPlace)
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
    shownNPC = npcID
    setMetBadge(npcID)
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
    local related = ns.Related(npcID)
    if #related > 0 then
        blocks[#blocks + 1] = fillRelated(related)
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
    if dock then
        dockTo(dock)
    elseif docked and not keepPlace then
        applyPosition()
    end
    frame:Show()
    notifyBrowser()
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
    if docked then
        applyPosition()
    end
    frame:Show()
    notifyBrowser()
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
    if docked then
        applyPosition()
    end
    frame:Show()
    notifyBrowser()
end

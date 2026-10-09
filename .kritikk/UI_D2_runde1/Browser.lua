-- Browser.lua – the "Warcraft Veterans" window (/wcl list): every veteran in the database,
-- with met/not met, a counter per game, a name search and filters for game, zone,
-- campaign and met status. Clicking a row opens the lore window.
-- Same frame art as the lore window (Style.lua). Popups are plain frames, no Blizzard templates.

local _, ns = ...
local C = ns.Compat

local Browser = {}
ns.Browser = Browser

local S = ns.Style
local COL, solid, text, box, badge = S.COL, S.solid, S.text, S.box, S.badge
local BAND, PAD, HEADER = S.BAND, S.PAD, S.HEADER
local HEX_MUTED, END = S.HEX_MUTED, S.END

local W, H = 520, 600                 -- window size
local INNER_W = W - 2 * BAND
local CONTENT_W = INNER_W - 2 * PAD   -- width of everything inside the panel
local LIST_W = CONTENT_W - 8          -- the list leaves 8 px for the scrollbar
local ROW_H = 20
local POPUP_W = 260
local POPUP_ROW_H = 18
local POPUP_MAX_ROWS = 14
local STATUS_LABELS = { "All", "Met", "Not met" }

-- Filter state. Lives for the session only (not saved).
local state = { games = {}, zone = nil, campaign = nil, status = 1, query = "" }

local frame, counterHolder, overallBadge, searchEdit, searchHint
local zoneBtn, campaignBtn, statusBtn, clearBtn
local countText, emptyText
local scroll, content, track, thumb
local gameBadges = {}
local rows = {}
local popup, popupOwner

-------------------------------------------------------------------- data index
-- Built once on first use; ns.NPCS does not change while the game runs.
local items            -- all veterans sorted by name: { id, entry, name, lower, label, games, zones, campaigns }
local zoneItems        -- popup list: "All zones" + every zone, sorted
local campaignItems    -- popup list: "All campaigns" + campaigns grouped under their (earliest) game

local function buildIndex()
    if items then
        return
    end
    items = {}
    local zoneSet, campaignRank = {}, {}
    local gameRank = {}
    for i, code in ipairs(ns.GAME_ORDER) do
        gameRank[code] = i
    end
    for npcID, entry in pairs(ns.NPCS) do
        local it = {
            id = npcID, entry = entry, name = entry.name or "?",
            label = ns.GamesLabel(entry), games = {}, zones = {}, campaigns = {},
        }
        it.lower = it.name:lower()
        for _, code in ipairs(ns.GamesInOrder(entry)) do
            it.games[code] = true
        end
        local function addZone(z)
            if type(z) == "string" and z ~= "" then
                it.zones[z] = true
                zoneSet[z] = true
            end
        end
        addZone(entry.zone)
        for _, z in ipairs(entry.alsoIn or {}) do
            addZone(z)
        end
        for _, a in ipairs(entry.appearances or {}) do
            local camp = a.campaign
            if type(camp) == "string" and camp ~= "" then
                it.campaigns[camp] = true
                local rank = gameRank[a.game] or 99
                if not campaignRank[camp] or rank < campaignRank[camp] then
                    campaignRank[camp] = rank
                end
            end
        end
        items[#items + 1] = it
    end
    table.sort(items, function(a, b)
        if a.lower ~= b.lower then
            return a.lower < b.lower
        end
        return a.id < b.id
    end)

    local zones = {}
    for z in pairs(zoneSet) do
        zones[#zones + 1] = z
    end
    table.sort(zones)
    zoneItems = { { label = "All zones" } }
    for _, z in ipairs(zones) do
        zoneItems[#zoneItems + 1] = { label = z, value = z }
    end

    local camps = {}
    for camp in pairs(campaignRank) do
        camps[#camps + 1] = camp
    end
    table.sort(camps, function(a, b)
        if campaignRank[a] ~= campaignRank[b] then
            return campaignRank[a] < campaignRank[b]
        end
        return a < b
    end)
    campaignItems = { { label = "All campaigns" } }
    local lastRank
    for _, camp in ipairs(camps) do
        local rank = campaignRank[camp]
        if rank ~= lastRank then
            lastRank = rank
            local code = ns.GAME_ORDER[rank]
            campaignItems[#campaignItems + 1] = {
                header = true, label = code and ns.GAME_LONG[code] or "Other",
                color = code and { ns.GameRGB(code) } or COL.muted,
            }
        end
        campaignItems[#campaignItems + 1] = { label = camp, value = camp }
    end
end

local function matches(it, anyGame)
    if anyGame then
        local ok = false
        for code in pairs(state.games) do
            if it.games[code] then
                ok = true
                break
            end
        end
        if not ok then
            return false
        end
    end
    if state.zone and not it.zones[state.zone] then
        return false
    end
    if state.campaign and not it.campaigns[state.campaign] then
        return false
    end
    if state.status == 2 and not ns.IsMet(it.id) then
        return false
    elseif state.status == 3 and ns.IsMet(it.id) then
        return false
    end
    if state.query ~= "" and not string.find(it.lower, state.query, 1, true) then
        return false
    end
    return true
end

local function anyFilter()
    return next(state.games) ~= nil or state.zone ~= nil or state.campaign ~= nil
        or state.status ~= 1 or state.query ~= ""
end

-------------------------------------------------------------------- position
local function savePosition()
    local point, _, relativePoint, x, y = frame:GetPoint(1)
    WarcraftLoreDB.browserPos = { point = point, relativePoint = relativePoint, x = x, y = y }
end

local function applyPosition()
    frame:ClearAllPoints()
    local pos = WarcraftLoreDB.browserPos
    if pos and pos.point then
        frame:SetPoint(pos.point, UIParent, pos.relativePoint or pos.point, pos.x or 0, pos.y or 0)
    else
        frame:SetPoint("CENTER", UIParent, "CENTER", -280, 0)
    end
end

function Browser.ResetPosition()
    WarcraftLoreDB.browserPos = nil
    if frame then
        applyPosition()
    end
end

-------------------------------------------------------------------- popup list
-- One shared popup for the zone and campaign pickers: a scrollable list under the button
-- (or above it when there is no room), plus a transparent catcher so a click anywhere
-- else in the window closes it.
local function closePopup()
    if popup then
        popup.frame:Hide()
        popup.catcher:Hide()
    end
    popupOwner = nil
end

local function buildPopup()
    local p = { rows = {} }
    local level = frame:GetFrameLevel()

    p.catcher = CreateFrame("Button", nil, frame)
    p.catcher:SetAllPoints(frame)
    p.catcher:SetFrameLevel(level + 20)
    C.RegisterClicks(p.catcher)
    p.catcher:SetScript("OnClick", closePopup)
    p.catcher:Hide()

    p.frame = box(frame)
    p.frame:SetFrameLevel(level + 30)
    p.frame:SetWidth(POPUP_W)
    p.frame:SetClampedToScreen(true)
    p.frame:EnableMouse(true) -- clicks on the popup's own background must not reach the catcher
    p.frame:SetColors(COL.inner, 1, COL.violet, 1)
    p.frame:Hide()

    p.scroll = CreateFrame("ScrollFrame", nil, p.frame)
    p.scroll:SetPoint("TOPLEFT", 2, -2)
    p.scroll:SetPoint("BOTTOMRIGHT", -2, 2)
    p.scroll:EnableMouseWheel(true)
    p.scroll:SetScript("OnMouseWheel", function(self, delta)
        local new = self:GetVerticalScroll() - delta * POPUP_ROW_H * 2
        new = math.max(0, math.min(new, self:GetVerticalScrollRange()))
        self:SetVerticalScroll(new)
    end)
    p.content = CreateFrame("Frame", nil, p.scroll)
    p.content:SetSize(POPUP_W - 4, 10)
    p.scroll:SetScrollChild(p.content)
    popup = p
end

local function popupRow(i)
    local r = popup.rows[i]
    if r then
        return r
    end
    r = CreateFrame("Button", nil, popup.content)
    r:SetSize(POPUP_W - 4, POPUP_ROW_H)
    C.RegisterClicks(r)
    r.hl = solid(r, "BACKGROUND", COL.violet, 0.25)
    r.hl:SetAllPoints()
    r.hl:Hide()
    r.label = text(r, C.FONT_BODY, 11, COL.text)
    r.label:SetPoint("LEFT", 8, 0)
    r.label:SetPoint("RIGHT", -6, 0)
    r.label:SetJustifyV("MIDDLE")
    r.label:SetWordWrap(false)
    r:SetScript("OnEnter", function(self)
        if not self.isHeader then
            self.hl:Show()
        end
    end)
    r:SetScript("OnLeave", function(self)
        self.hl:Hide()
    end)
    r:SetScript("OnClick", function(self)
        if self.isHeader then
            return
        end
        local pick = popup.onPick
        closePopup()
        if pick then
            pick(self.value)
        end
    end)
    popup.rows[i] = r
    return r
end

-- list = { { label, value, header, color }, ... }; the entry whose value equals `current` is
-- highlighted; onPick(value) runs when one is chosen. Clicking the owner again closes it.
local function openPopup(owner, list, current, onPick)
    if popup and popup.frame:IsShown() and popupOwner == owner then
        closePopup()
        return
    end
    if not popup then
        buildPopup()
    end
    popupOwner = owner
    popup.onPick = onPick
    for i, it in ipairs(list) do
        local r = popupRow(i)
        r:ClearAllPoints()
        r:SetPoint("TOPLEFT", popup.content, "TOPLEFT", 0, -(i - 1) * POPUP_ROW_H)
        r.isHeader = it.header and true or false
        r.value = it.value
        r.label:SetText(it.label)
        local c
        if it.header then
            c = it.color or COL.muted
        elseif it.value == current then
            c = COL.title
        else
            c = COL.text
        end
        r.label:SetTextColor(c[1], c[2], c[3])
        r.hl:Hide()
        r:Show()
    end
    for i = #list + 1, #popup.rows do
        popup.rows[i]:Hide()
    end
    local contentH = #list * POPUP_ROW_H
    popup.content:SetHeight(math.max(1, contentH))
    popup.scroll:SetVerticalScroll(0)

    -- Size and place it: below the button if it fits, otherwise above, never off the screen.
    local h = math.min(contentH, POPUP_MAX_ROWS * POPUP_ROW_H) + 4
    local screenH = UIParent:GetHeight()
    local below = owner:GetBottom() or 0
    local above = screenH - (owner:GetTop() or screenH)
    popup.frame:ClearAllPoints()
    if h > below - 8 and above > below then
        h = math.min(h, math.max(above - 8, 60))
        popup.frame:SetPoint("BOTTOMLEFT", owner, "TOPLEFT", 0, 2)
    else
        h = math.min(h, math.max(below - 8, 60))
        popup.frame:SetPoint("TOPLEFT", owner, "BOTTOMLEFT", 0, -2)
    end
    popup.frame:SetHeight(h)
    popup.catcher:Show()
    popup.frame:Show()
end

-------------------------------------------------------------------- list rows
local function acquireRow(i)
    local r = rows[i]
    if r then
        return r
    end
    r = CreateFrame("Button", nil, content)
    r:SetSize(LIST_W, ROW_H)
    r:SetPoint("TOPLEFT", content, "TOPLEFT", 0, -(i - 1) * ROW_H)
    C.RegisterClicks(r)
    r.hl = solid(r, "BACKGROUND", COL.violet, 0.18)
    r.hl:SetAllPoints()
    r.hl:Hide()
    r.dot = solid(r, "ARTWORK", COL.dim)
    r.dot:SetSize(7, 7)
    r.dot:SetPoint("LEFT", 5, 0)
    r.nameText = text(r, C.FONT_BODY, 12, COL.text)
    r.nameText:SetPoint("LEFT", 18, 0)
    r.nameText:SetWidth(190)
    r.nameText:SetJustifyV("MIDDLE")
    r.nameText:SetWordWrap(false)
    r.zoneText = text(r, C.FONT_BODY, 11, COL.muted)
    r.zoneText:SetPoint("LEFT", 212, 0)
    r.zoneText:SetWidth(100)
    r.zoneText:SetJustifyV("MIDDLE")
    r.zoneText:SetWordWrap(false)
    r.gamesText = text(r, C.FONT_BODY, 11, COL.muted)
    r.gamesText:SetPoint("RIGHT", -4, 0)
    r.gamesText:SetWidth(124)
    r.gamesText:SetJustifyH("RIGHT")
    r.gamesText:SetJustifyV("MIDDLE")
    r.gamesText:SetWordWrap(false)
    r:SetScript("OnEnter", function(self) self.hl:Show() end)
    r:SetScript("OnLeave", function(self) self.hl:Hide() end)
    r:SetScript("OnClick", function(self)
        closePopup()
        if self.npcID and self.entry then
            -- The lore window sits in a higher strata than this window, so it opens on top.
            ns.UI.ShowEntry(self.npcID, self.entry, nil)
        end
    end)
    rows[i] = r
    return r
end

local function fillRow(r, it)
    r.npcID, r.entry = it.id, it.entry
    local met = ns.IsMet(it.id)
    local dot = met and COL.met or COL.dim
    r.dot:SetColorTexture(dot[1], dot[2], dot[3], 1)
    local name = it.name
    if it.entry.confidence == "uncertain" then
        name = name .. " " .. HEX_MUTED .. "(uncertain)" .. END
    end
    r.nameText:SetText(name)
    local nc = met and COL.title or COL.text
    r.nameText:SetTextColor(nc[1], nc[2], nc[3])
    r.zoneText:SetText(it.entry.zone or "")
    r.gamesText:SetText(it.label)
    r:Show()
end

-------------------------------------------------------------------- scrollbar thumb
local function updateThumb()
    if not (scroll and track and thumb) then
        return
    end
    local range = scroll:GetVerticalScrollRange() or 0
    local viewH = scroll:GetHeight() or 0
    local trackH = track:GetHeight() or viewH
    if range <= 0.5 or viewH <= 0 or trackH <= 0 then
        thumb:Hide()
        return
    end
    local thumbH = math.max(18, trackH * viewH / (viewH + range))
    local y = (scroll:GetVerticalScroll() / range) * (trackH - thumbH)
    thumb:ClearAllPoints()
    thumb:SetPoint("TOPLEFT", track, "TOPLEFT", 0, -y)
    thumb:SetSize(4, thumbH)
    thumb:Show()
end

-------------------------------------------------------------------- refresh
-- Lays the badges out in rows that wrap at the window width.
local function layoutCounters(list)
    local x, row = 0, 0
    for _, b in ipairs(list) do
        local w = b:GetWidth()
        if x > 0 and x + w > CONTENT_W then
            x, row = 0, row + 1
        end
        b:ClearAllPoints()
        b:SetPoint("TOPLEFT", counterHolder, "TOPLEFT", x, -row * 20)
        x = x + w + 6
    end
    counterHolder:SetHeight((row + 1) * 20 - 4)
end

local function updateCounters()
    local perGame, overall = ns.MetCounts()
    overallBadge:Set(("Met %d/%d"):format(overall.met, overall.total), COL.met)
    local list = { overallBadge }
    for _, code in ipairs(ns.GAME_ORDER) do
        local b = gameBadges[code]
        local n = perGame[code]
        if n and n.total > 0 then
            local c = { ns.GameRGB(code) }
            b:Set(("%s %d/%d"):format(ns.GAME_SHORT[code] or code, n.met, n.total), c)
            if state.games[code] then
                b:SetColors(c, 0.45, c, 1)      -- selected: brighter fill
            else
                b:SetColors(c, 0.12, c, 0.55)
            end
            list[#list + 1] = b
        else
            b:Hide()
        end
    end
    layoutCounters(list)
end

local function updateFilterButtons()
    zoneBtn:SetValue("Zone: ", state.zone or "All zones", state.zone ~= nil)
    campaignBtn:SetValue("Campaign: ", state.campaign or "All campaigns", state.campaign ~= nil)
    statusBtn:SetValue("Status: ", STATUS_LABELS[state.status], state.status ~= 1)
    if anyFilter() then
        clearBtn:Show()
    else
        clearBtn:Hide()
    end
end

-- resetScroll = true when the filters changed; otherwise the scroll position is kept.
function Browser.Refresh(resetScroll)
    if not frame or not frame:IsShown() then
        return
    end
    buildIndex()
    updateCounters()
    updateFilterButtons()

    local anyGame = next(state.games) ~= nil
    local shown = 0
    for _, it in ipairs(items) do
        if matches(it, anyGame) then
            shown = shown + 1
            fillRow(acquireRow(shown), it)
        end
    end
    for i = shown + 1, #rows do
        rows[i]:Hide()
    end

    local previous = scroll:GetVerticalScroll() or 0
    content:SetSize(LIST_W, math.max(1, shown * ROW_H))
    local maxScroll = math.max(0, shown * ROW_H - (scroll:GetHeight() or 0))
    scroll:SetVerticalScroll(resetScroll and 0 or math.min(previous, maxScroll))
    updateThumb()

    countText:SetText(("Showing %d of %d"):format(shown, #items))
    if shown == 0 then
        emptyText:Show()
    else
        emptyText:Hide()
    end
end

local function refreshFiltered()
    Browser.Refresh(true)
end

-------------------------------------------------------------------- build
local function buildCounters(inner)
    counterHolder = CreateFrame("Frame", nil, inner)
    counterHolder:SetPoint("TOPLEFT", inner, "TOPLEFT", PAD, -(HEADER + 8))
    counterHolder:SetSize(CONTENT_W, 16)
    overallBadge = badge(counterHolder)
    for _, code in ipairs(ns.GAME_ORDER) do
        local b = badge(counterHolder, "Button")
        C.RegisterClicks(b)
        b:SetScript("OnClick", function()
            if state.games[code] then
                state.games[code] = nil
            else
                state.games[code] = true
            end
            refreshFiltered()
        end)
        gameBadges[code] = b
    end
end

local function buildSearch(inner)
    local holder = box(inner)
    holder:SetSize(CONTENT_W, 22)
    holder:SetPoint("TOPLEFT", counterHolder, "BOTTOMLEFT", 0, -6)
    holder:SetColors(COL.inner, 1, COL.headerLine, 1)

    searchHint = text(holder, C.FONT_BODY, 11, COL.muted)
    searchHint:SetPoint("LEFT", 8, 0)
    searchHint:SetJustifyV("MIDDLE")

    searchEdit = C.CreateEditBox(holder, C.FONT_BODY, 12)
    if not searchEdit then
        searchHint:SetText("Search is not available in this client.")
        return holder
    end
    searchHint:SetText("Search by name")
    searchEdit:SetPoint("TOPLEFT", holder, "TOPLEFT", 8, -3)
    searchEdit:SetPoint("BOTTOMRIGHT", holder, "BOTTOMRIGHT", -8, 3)
    searchEdit:SetTextColor(COL.text[1], COL.text[2], COL.text[3])
    searchEdit:SetScript("OnTextChanged", function(self)
        local raw = self:GetText() or ""
        if raw == "" then
            searchHint:Show()
        else
            searchHint:Hide()
        end
        local q = strtrim(raw):lower()
        if q ~= state.query then
            state.query = q
            refreshFiltered()
        end
    end)
    searchEdit:SetScript("OnEscapePressed", function(self) self:ClearFocus() end)
    searchEdit:SetScript("OnEnterPressed", function(self) self:ClearFocus() end)
    searchEdit:SetScript("OnEditFocusGained", function()
        holder:SetColors(COL.inner, 1, COL.violet, 1)
    end)
    searchEdit:SetScript("OnEditFocusLost", function()
        holder:SetColors(COL.inner, 1, COL.headerLine, 1)
    end)
    return holder
end

-- A dropdown-looking button: "Prefix: value" and a small arrow.
local function filterButton(parent, width)
    local b = box(parent, "Button")
    b:SetSize(width, 22)
    C.RegisterClicks(b)
    b.label = text(b, C.FONT_BODY, 11, COL.text)
    b.label:SetPoint("LEFT", 8, 0)
    b.label:SetPoint("RIGHT", -16, 0)
    b.label:SetJustifyV("MIDDLE")
    b.label:SetWordWrap(false)
    b.arrow = text(b, C.FONT_BODY, 9, COL.muted)
    b.arrow:SetPoint("RIGHT", -6, 0)
    b.arrow:SetJustifyV("MIDDLE")
    b.arrow:SetText("v")
    b.active = false
    b:SetColors(COL.inner, 1, COL.headerLine, 1)
    function b:SetValue(prefix, value, active)
        self.active = active
        self.label:SetText(HEX_MUTED .. prefix .. END .. value)
        local c = active and COL.title or COL.text
        self.label:SetTextColor(c[1], c[2], c[3])
        self:SetColors(COL.inner, 1, active and COL.violet or COL.headerLine, 1)
    end
    b:SetScript("OnEnter", function(self)
        self:SetColors(COL.header, 1, COL.violet, 1)
    end)
    b:SetScript("OnLeave", function(self)
        self:SetColors(COL.inner, 1, self.active and COL.violet or COL.headerLine, 1)
    end)
    return b
end

local function buildFilters(inner, searchHolder)
    zoneBtn = filterButton(inner, 170)
    zoneBtn:SetPoint("TOPLEFT", searchHolder, "BOTTOMLEFT", 0, -6)
    zoneBtn:SetScript("OnClick", function(self)
        buildIndex()
        openPopup(self, zoneItems, state.zone, function(value)
            state.zone = value
            refreshFiltered()
        end)
    end)

    campaignBtn = filterButton(inner, 170)
    campaignBtn:SetPoint("TOPLEFT", zoneBtn, "TOPRIGHT", 8, 0)
    campaignBtn:SetScript("OnClick", function(self)
        buildIndex()
        openPopup(self, campaignItems, state.campaign, function(value)
            state.campaign = value
            refreshFiltered()
        end)
    end)

    statusBtn = filterButton(inner, 100)
    statusBtn:SetPoint("TOPLEFT", campaignBtn, "TOPRIGHT", 8, 0)
    statusBtn:SetScript("OnClick", function()
        closePopup()
        state.status = state.status % #STATUS_LABELS + 1
        refreshFiltered()
    end)

    countText = text(inner, C.FONT_BODY, 11, COL.muted)
    countText:SetPoint("TOPLEFT", zoneBtn, "BOTTOMLEFT", 0, -8)

    clearBtn = CreateFrame("Button", nil, inner)
    clearBtn:SetSize(90, 14)
    clearBtn:SetPoint("TOPRIGHT", statusBtn, "BOTTOMRIGHT", 0, -7)
    C.RegisterClicks(clearBtn)
    local clearLabel = text(clearBtn, C.FONT_BODY, 11, COL.violet)
    clearLabel:SetPoint("RIGHT", 0, 0)
    clearLabel:SetJustifyH("RIGHT")
    clearLabel:SetJustifyV("MIDDLE")
    clearLabel:SetText("Clear filters")
    clearBtn:SetScript("OnEnter", function() clearLabel:SetTextColor(COL.title[1], COL.title[2], COL.title[3]) end)
    clearBtn:SetScript("OnLeave", function() clearLabel:SetTextColor(COL.violet[1], COL.violet[2], COL.violet[3]) end)
    clearBtn:SetScript("OnClick", function()
        closePopup()
        state.games = {}
        state.zone, state.campaign, state.status, state.query = nil, nil, 1, ""
        if searchEdit then
            searchEdit:SetText("")
            searchEdit:ClearFocus()
        end
        refreshFiltered()
    end)
    clearBtn:Hide()
end

local function buildList(inner)
    scroll = CreateFrame("ScrollFrame", nil, inner)
    scroll:SetPoint("TOPLEFT", countText, "BOTTOMLEFT", 0, -6)
    scroll:SetPoint("BOTTOMRIGHT", inner, "BOTTOMRIGHT", -(PAD + 8), PAD)
    -- Wheel events go to the topmost wheel-enabled frame under the cursor; the row Buttons
    -- have no wheel handler, so scrolling over them reaches this ScrollFrame.
    scroll:EnableMouseWheel(true)
    scroll:SetScript("OnMouseWheel", function(self, delta)
        local new = self:GetVerticalScroll() - delta * ROW_H * 3
        new = math.max(0, math.min(new, self:GetVerticalScrollRange()))
        self:SetVerticalScroll(new)
    end)
    scroll:SetScript("OnVerticalScroll", updateThumb)
    scroll:SetScript("OnScrollRangeChanged", updateThumb)
    content = CreateFrame("Frame", nil, scroll)
    content:SetSize(LIST_W, 10)
    scroll:SetScrollChild(content)

    -- A thin scrollbar: just a track and a thumb that follows the scroll position.
    track = CreateFrame("Frame", nil, inner)
    track:SetWidth(4)
    track:SetPoint("TOPLEFT", scroll, "TOPRIGHT", 4, 0)
    track:SetPoint("BOTTOMLEFT", scroll, "BOTTOMRIGHT", 4, 0)
    local trackBg = solid(track, "BACKGROUND", COL.divider, 0.6)
    trackBg:SetAllPoints()
    thumb = solid(track, "ARTWORK", COL.violet, 0.9)
    thumb:SetSize(4, 18)
    thumb:Hide()

    emptyText = text(inner, C.FONT_BODY, 12, COL.muted)
    emptyText:SetPoint("TOP", scroll, "TOP", 0, -24)
    emptyText:SetJustifyH("CENTER")
    emptyText:SetText("No veterans match.")
    emptyText:Hide()
end

function Browser.Init()
    if frame then
        return
    end
    frame = CreateFrame("Frame", "WarcraftLoreBrowser", UIParent)
    frame:SetSize(W, H)
    frame:SetFrameStrata("HIGH") -- below the lore window (DIALOG), so a clicked veteran opens on top
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

    S.buildFrameArt(frame, W, H)
    local inner = S.buildInner(frame)
    S.buildHeader(inner, "Warcraft Veterans", function() frame:Hide() end)

    buildCounters(inner)
    local searchHolder = buildSearch(inner)
    buildFilters(inner, searchHolder)
    buildList(inner)

    frame:SetScript("OnShow", function() Browser.Refresh(true) end)
    frame:SetScript("OnHide", function()
        closePopup()
        if searchEdit then
            searchEdit:ClearFocus()
        end
    end)
    applyPosition()
end

-- /wcl list: opens the window, or closes it if it is already open.
function Browser.Toggle()
    Browser.Init()
    if frame:IsShown() then
        frame:Hide()
    else
        frame:Show()
    end
end

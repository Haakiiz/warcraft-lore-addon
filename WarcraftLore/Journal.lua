-- Journal.lua – the "Lore Journal" window (/wcl journal, shift-click on the minimap button,
-- "Journal" in the Veterans list): your achievements with progress, filtered by category.
-- Data comes from ns.Achievements (Achievements.lua); without it the window says so.
-- Same frame art as the Veterans list (Style.lua). Rows are pooled and built lazily.

local ADDON_NAME, ns = ...
local C = ns.Compat
local L = ns.L

local Journal = {}
ns.Journal = Journal

local S = ns.Style
local COL, solid, text, box = S.COL, S.solid, S.text, S.box
local PAD, HEADER = S.PAD, S.HEADER

local FALLBACK_ICON = "Interface\\Icons\\INV_Misc_QuestionMark"

local W, H = 460, 580
local INNER_W = W - 2 * S.BAND
local CONTENT_W = INNER_W - 2 * PAD
local ROW_H, ROW_GAP = 60, 4
local ROW_STEP = ROW_H + ROW_GAP
local ICON = 36
local TEXT_X = 8 + ICON + 8
local BAR_W = 190
local CHIP_GAP = 4

local CATEGORIES = {
    { key = nil, label = L["All"] },
    { key = "milestone", label = L["Milestones"] },
    { key = "game", label = L["Games"] },
    { key = "zone", label = L["Zones"] },
    { key = "circle", label = L["Circles"] },
    { key = "special", label = L["Special"] },
}

local frame, summary, summaryBar, summaryFill, emptyText
local scroll, content, track, thumb
local chips = {}
local rows = {}
local filter = nil          -- category key; nil = all (session only)
local barWidth = CONTENT_W

-------------------------------------------------------------------- helpers
-- "3 Oct 2026" in the client language (ns.FormatDate, Locale.lua).
local function formatDate(t)
    return ns.FormatDate and ns.FormatDate(t) or nil
end
Journal.FormatDate = formatDate

local function fetch()
    local A = ns.Achievements
    if type(A) ~= "table" or type(A.List) ~= "function" then
        return nil
    end
    local ok, list = pcall(A.List)
    if not ok or type(list) ~= "table" then
        return nil
    end
    local earned, total, later
    if type(A.Counts) == "function" then
        local okC, e, t, l = pcall(A.Counts)
        if okC then
            earned, total, later = tonumber(e), tonumber(t), tonumber(l)
        end
    end
    if not earned or not total then
        earned, total, later = 0, 0, 0
        for _, a in ipairs(list) do
            if a.later and not a.earned then
                later = later + 1
            else
                total = total + 1
                if a.done then
                    earned = earned + 1
                end
            end
        end
    end
    return list, earned, total, later or 0
end

-------------------------------------------------------------------- position
local function savePosition()
    local point, _, relativePoint, x, y = frame:GetPoint(1)
    WarcraftLoreDB.journalPos = { point = point, relativePoint = relativePoint, x = x, y = y }
end

local function applyPosition()
    frame:ClearAllPoints()
    local pos = WarcraftLoreDB and WarcraftLoreDB.journalPos
    if type(pos) == "table" and pos.point then
        frame:SetPoint(pos.point, UIParent, pos.relativePoint or pos.point, pos.x or 0, pos.y or 0)
    else
        frame:SetPoint("CENTER", UIParent, "CENTER", 280, 0)
    end
end

function Journal.ResetPosition()
    if type(WarcraftLoreDB) == "table" then
        WarcraftLoreDB.journalPos = nil
    end
    if frame then
        applyPosition()
    end
end

-------------------------------------------------------------------- rows
local function styleRow(row, a)
    row.later = a.later and not a.earned and true or false
    local done = a.done and not row.later and true or false
    row.done = done
    row:SetAlpha(row.later and 0.55 or 1)
    if done then
        row:SetColors(COL.gold, 0.08, COL.gold, 0.55)
        row.title:SetTextColor(COL.gold[1], COL.gold[2], COL.gold[3])
        row.desc:SetTextColor(COL.text[1], COL.text[2], COL.text[3])
        row.fill:SetColorTexture(COL.gold[1], COL.gold[2], COL.gold[3], 1)
        row.icon:SetVertexColor(1, 1, 1)
        row.icon:SetDesaturated(false)
    else
        row:SetColors(COL.inner, 0.6, COL.divider, 1)
        row.title:SetTextColor(COL.muted[1], COL.muted[2], COL.muted[3])
        row.desc:SetTextColor(COL.hollow[1], COL.hollow[2], COL.hollow[3])
        row.fill:SetColorTexture(COL.violet[1], COL.violet[2], COL.violet[3], 1)
        row.icon:SetVertexColor(0.5, 0.5, 0.5)
        row.icon:SetDesaturated(true)
    end
end

local function showRowTooltip(row)
    local a = row.data
    if not a then
        return
    end
    local t, x, m = COL.title, COL.text, COL.muted
    local lines = {
        { tostring(a.title or "?"), t[1], t[2], t[3] },
        { tostring(a.desc or ""), x[1], x[2], x[3], true },
    }
    local total = tonumber(a.total)
    if row.later then
        lines[#lines + 1] = { L["Needs zones above level %d – coming with the next level cap."]:format(
            ns.Achievements and tonumber(ns.Achievements.LEVEL_CAP) or 30), m[1], m[2], m[3], true }
    end
    if a.done and not row.later then
        local when = formatDate(a.earned)
        lines[#lines + 1] = { when and L["Earned %s"]:format(when) or L["Earned"], COL.gold[1], COL.gold[2], COL.gold[3] }
    elseif total and total > 1 then
        lines[#lines + 1] = { L["Progress: %d/%d"]:format(tonumber(a.progress) or 0, total), m[1], m[2], m[3] }
    end
    C.ShowTooltip(row, "ANCHOR_RIGHT", lines)
end

local function newRow()
    local row = box(content)
    row:SetSize(CONTENT_W - 6, ROW_H)
    row:EnableMouse(true)
    row.icon = row:CreateTexture(nil, "ARTWORK")
    row.icon:SetSize(ICON, ICON)
    row.icon:SetPoint("TOPLEFT", 8, -8)
    row.title = text(row, C.FONT_TITLE, 12, COL.text)
    row.title:SetPoint("TOPLEFT", TEXT_X, -7)
    row.title:SetWidth(CONTENT_W - TEXT_X - 100)
    row.title:SetWordWrap(false)
    row.date = text(row, C.FONT_BODY, 10, COL.gold)
    row.date:SetPoint("TOPRIGHT", -10, -8)
    row.date:SetJustifyH("RIGHT")
    row.desc = text(row, C.FONT_BODY, 10, COL.muted)
    row.desc:SetPoint("TOPLEFT", TEXT_X, -23)
    row.desc:SetWidth(CONTENT_W - TEXT_X - 16)
    row.desc:SetHeight(24)
    row.track = solid(row, "ARTWORK", COL.divider)
    row.track:SetPoint("BOTTOMLEFT", TEXT_X, 7)
    row.track:SetSize(BAR_W, 3)
    row.fill = solid(row, "OVERLAY", COL.violet)
    row.fill:SetPoint("BOTTOMLEFT", TEXT_X, 7)
    row.fill:SetHeight(3)
    row.count = text(row, C.FONT_BODY, 10, COL.muted)
    row.count:SetPoint("LEFT", row.track, "RIGHT", 8, 0)
    row.count:SetJustifyV("MIDDLE")
    row:SetScript("OnEnter", showRowTooltip)
    row:SetScript("OnLeave", function() C.HideTooltip() end)
    return row
end

local function fillRow(row, a, index)
    row.data = a
    row:ClearAllPoints()
    row:SetPoint("TOPLEFT", content, "TOPLEFT", 0, -(index - 1) * ROW_STEP)
    C.SetIconTexture(row.icon, a.icon or FALLBACK_ICON, FALLBACK_ICON)
    row.title:SetText(tostring(a.title or "?"))
    row.desc:SetText(tostring(a.desc or ""))
    styleRow(row, a)
    local total = tonumber(a.total)
    if total and total > 1 then
        local p = math.max(0, math.min(tonumber(a.progress) or 0, total))
        if a.done then
            p = total
        end
        row.track:Show()
        row.count:SetText(("%d/%d"):format(p, total))
        row.count:Show()
        if p > 0 then
            row.fill:SetWidth(math.max(math.floor(BAR_W * p / total + 0.5), 2))
            row.fill:Show()
        else
            row.fill:Hide()
        end
    else
        row.track:Hide(); row.fill:Hide(); row.count:SetText(""); row.count:Hide()
    end
    local when = a.done and formatDate(a.earned)
    row.date:SetText(when or "")
    row:Show()
end

-------------------------------------------------------------------- refresh
local function updateThumb()
    if not thumb or not scroll then
        return
    end
    local range = scroll:GetVerticalScrollRange() or 0
    if range <= 0 then
        thumb:Hide()
        return
    end
    local trackH = track:GetHeight() or 0
    local viewH = scroll:GetHeight() or 0
    local thumbH = math.max(18, trackH * viewH / (viewH + range))
    thumb:SetHeight(thumbH)
    thumb:ClearAllPoints()
    thumb:SetPoint("TOP", track, "TOP", 0, -((trackH - thumbH) * (scroll:GetVerticalScroll() or 0) / range))
    thumb:Show()
end

local function updateChips()
    for _, chip in ipairs(chips) do
        local on = chip.key == filter
        chip.on = on
        chip:SetColors(on and COL.violet or COL.inner, on and 0.25 or 0.5, on and COL.title or COL.violet, on and 1 or 0.4)
        local c = on and COL.title or COL.muted
        chip.label:SetTextColor(c[1], c[2], c[3])
    end
end

function Journal.Refresh()
    if not frame or not frame:IsShown() then
        return
    end
    local list, earned, total, later = fetch()
    if not list then
        summary:SetText("")
        summaryFill:Hide()
        for _, r in ipairs(rows) do r:Hide() end
        emptyText:SetText(L["Achievements are not available."])
        emptyText:Show()
        content:SetHeight(10)
        updateChips()
        updateThumb()
        return
    end
    if later > 0 then
        summary:SetText(L["%s%d%s of %d achievements · %d later"]:format(S.HEX_GOLD, earned, S.END, total, later))
    else
        summary:SetText(L["%s%d%s of %d achievements"]:format(S.HEX_GOLD, earned, S.END, total))
    end
    local fillW = total > 0 and math.floor(barWidth * earned / total + 0.5) or 0
    if earned > 0 then
        summaryFill:SetWidth(math.max(fillW, 2))
        summaryFill:Show()
    else
        summaryFill:Hide()
    end

    -- The ones that wait for a higher level cap go last, in the order they came.
    local n = 0
    for pass = 1, 2 do
        for _, a in ipairs(list) do
            if type(a) == "table" and (filter == nil or a.category == filter)
                and (pass == 2) == (a.later and not a.earned and true or false) then
                n = n + 1
                local row = rows[n]
                if not row then
                    row = newRow()
                    rows[n] = row
                end
                fillRow(row, a, n)
            end
        end
    end
    for i = n + 1, #rows do
        rows[i]:Hide()
        rows[i].data = nil
    end
    emptyText:SetText(L["Nothing here yet."])
    if n == 0 then emptyText:Show() else emptyText:Hide() end
    content:SetHeight(math.max(10, n * ROW_STEP))
    updateChips()
    updateThumb()
end

function Journal.SetFilter(key)
    filter = key
    if frame and scroll then
        scroll:SetVerticalScroll(0)
    end
    Journal.Refresh()
end

-------------------------------------------------------------------- build
local function buildChips(inner, above)
    local holder = CreateFrame("Frame", nil, inner)
    holder:SetSize(CONTENT_W, 22)
    holder:SetPoint("TOPLEFT", above, "BOTTOMLEFT", 0, -10)
    local w = math.floor((CONTENT_W - CHIP_GAP * (#CATEGORIES - 1)) / #CATEGORIES)
    local prev
    for _, cat in ipairs(CATEGORIES) do
        local chip = box(holder, "Button")
        chip:SetSize(w, 22)
        C.RegisterClicks(chip)
        chip.key = cat.key
        chip.label = text(chip, C.FONT_BODY, 10, COL.muted)
        chip.label:SetPoint("CENTER", 0, 0)
        chip.label:SetJustifyV("MIDDLE")
        chip.label:SetJustifyH("CENTER")
        chip.label:SetText(cat.label)
        if prev then
            chip:SetPoint("LEFT", prev, "RIGHT", CHIP_GAP, 0)
        else
            chip:SetPoint("LEFT", holder, "LEFT", 0, 0)
        end
        chip:SetScript("OnClick", function() Journal.SetFilter(cat.key) end)
        chips[#chips + 1] = chip
        prev = chip
    end
    return holder
end

local function build()
    frame = CreateFrame("Frame", "WarcraftLoreJournal", UIParent)
    frame:SetSize(W, H)
    frame:SetFrameStrata("HIGH")
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
    S.buildHeader(inner, L["Lore Journal"], function() frame:Hide() end)

    -- "12 of 48 achievements" over a thin progress bar
    local head = CreateFrame("Frame", nil, inner)
    head:SetSize(CONTENT_W, 30)
    head:SetPoint("TOPLEFT", inner, "TOPLEFT", PAD, -(HEADER + 10))
    summary = text(head, C.FONT_TITLE, 14, COL.title)
    summary:SetPoint("TOPLEFT", 0, 0)
    summaryBar = solid(head, "BACKGROUND", COL.divider)
    summaryBar:SetPoint("TOPLEFT", 0, -22)
    summaryBar:SetSize(barWidth, 4)
    summaryFill = solid(head, "ARTWORK", COL.gold)
    summaryFill:SetPoint("TOPLEFT", 0, -22)
    summaryFill:SetHeight(4)

    local chipRow = buildChips(inner, head)

    scroll = CreateFrame("ScrollFrame", nil, inner)
    scroll:SetPoint("TOPLEFT", chipRow, "BOTTOMLEFT", 0, -10)
    scroll:SetPoint("BOTTOMRIGHT", inner, "BOTTOMRIGHT", -PAD, PAD)
    scroll:EnableMouseWheel(true)
    scroll:SetScript("OnMouseWheel", function(self, delta)
        local new = self:GetVerticalScroll() - delta * ROW_STEP
        new = math.max(0, math.min(new, self:GetVerticalScrollRange()))
        self:SetVerticalScroll(new)
    end)
    scroll:SetScript("OnVerticalScroll", updateThumb)
    scroll:SetScript("OnScrollRangeChanged", updateThumb)
    content = CreateFrame("Frame", nil, scroll)
    content:SetSize(CONTENT_W, 10)
    scroll:SetScrollChild(content)

    track = CreateFrame("Frame", nil, inner)
    track:SetFrameLevel(scroll:GetFrameLevel() + 5)
    track:SetWidth(3)
    track:SetPoint("TOPRIGHT", scroll, "TOPRIGHT", 0, 0)
    track:SetPoint("BOTTOMRIGHT", scroll, "BOTTOMRIGHT", 0, 0)
    local trackBg = solid(track, "BACKGROUND", COL.divider, 0.6)
    trackBg:SetAllPoints()
    thumb = solid(track, "ARTWORK", COL.violet)
    thumb:SetSize(3, 18)
    thumb:Hide()

    emptyText = text(inner, C.FONT_BODY, 12, COL.muted)
    emptyText:SetPoint("TOP", scroll, "TOP", 0, -40)
    emptyText:SetJustifyH("CENTER")
    emptyText:Hide()

    frame:SetScript("OnShow", function() Journal.Refresh() end)
    frame:SetScript("OnHide", function() C.HideTooltip() end)
    applyPosition()
end

function Journal.Init()
    if not frame then
        build()
    end
end

function Journal.Toggle()
    Journal.Init()
    if frame:IsShown() then
        frame:Hide()
    else
        frame:Show()
    end
end

-- Opens the window (never closes it).
function Journal.Show()
    Journal.Init()
    if frame:IsShown() then
        Journal.Refresh()
    else
        frame:Show()
    end
end

function Journal.IsShown()
    return frame ~= nil and frame:IsShown()
end

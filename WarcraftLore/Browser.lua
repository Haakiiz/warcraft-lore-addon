-- Browser.lua – the "Warcraft Veterans" window (/wcl list): every veteran in the database,
-- with a met counter, a chip per game, a name search and filters for game, zone, campaign
-- and met status. Clicking a row opens the lore window next to this one.
-- Same frame art as the lore window (Style.lua). Popups are plain frames, no Blizzard templates.

local ADDON_NAME, ns = ...
local C = ns.Compat
local L = ns.L

local Browser = {}
ns.Browser = Browser

local S = ns.Style
local COL, solid, text, box, outline = S.COL, S.solid, S.text, S.box, S.outline
local PAD, HEADER = S.PAD, S.HEADER
local END = S.END

local TEX = "Interface\\AddOns\\" .. ADDON_NAME .. "\\Textures\\"

local W, H = 520, 600                     -- window size
local INNER_W = W - 2 * S.BAND
local CONTENT_W = INNER_W - 2 * PAD       -- width of everything inside the panel (456)
local ROW_H = 20
local COL_MARK, COL_NAME, COL_GAMES = 18, 230, 100   -- list columns; the zone column takes the rest
local ZONE_W = CONTENT_W - COL_MARK - COL_NAME - COL_GAMES
local POPUP_W = 260
local POPUP_ROW_H = 18
local POPUP_HEAD_H = 21                   -- a group header: 2 px gap, 1 px line, 18 px of label
local POPUP_MAX_H = 282
local POPUP_PAD = 3
local STATUS_LABELS = { L["All"], L["Met"], L["Not met"] }
local FILTER_GAP = 8
local ZONE_BTN_W, STATUS_BTN_W = 168, 104
local COUNT_GAP = 14                      -- gap between the items at the right end of the count row
local CHEVRON_INSET = 22                  -- label room taken by the chevron on a filter button
local LABEL_INSET = 9

-- Group headers in the campaign picker.
local POPUP_HEAD = {
    WC1 = "WARCRAFT", WC2 = "WARCRAFT II", BTDP = "BEYOND THE DARK PORTAL", WC3 = "WARCRAFT III",
    TFT = "THE FROZEN THRONE", FK = "FORSAKEN KINGDOM", BOOK = L["BOOKS"],
}

-- Filter state. Lives for the session only (not saved). "Hide book-only" is a preference and
-- is saved in WarcraftLoreDB.hideBookOnly instead.
-- state.memorials = true shows the memorials (Memorials.lua) instead of the veterans.
local state = { games = {}, zone = nil, campaign = nil, status = 1, query = "", memorials = false }

local frame, searchEdit, searchHint
local journalBtn, memBtn
local zoneBtn, hereBtn, campaignBtn, statusBtn, clearBtn, bookToggle
local progress, countText, emptyText, emptyHint
local scroll, content, track, thumb
local chips = {}
local rows = {}
local popup, popupOwner
local hoverRow
local ctlLevel, catchLevel                -- frame levels: controls sit above the popup's click catcher

local function hideBookOnly()
    return type(WarcraftLoreDB) == "table" and WarcraftLoreDB.hideBookOnly == true
end

-------------------------------------------------------------------- data index
-- Built once on first use; ns.NPCS does not change while the game runs.
local items            -- all veterans sorted by name: { id, entry, name, lower, label, games, zones, campaigns, bookOnly }
local zoneItems        -- popup list: "All zones" + every zone, sorted
local campaignItems    -- popup list: "All campaigns" + campaigns grouped under their (earliest) game
local zoneCounts       -- zone -> { met, total }; built on demand, dropped on every Refresh (met can change)

-- Search text: lower case without spaces or punctuation, so "mugthol" finds Mug'thol and
-- "thousandneedles" or "needles" finds Thousand Needles.
local function normalize(s)
    return (s:lower():gsub("[%s%p]", ""))
end

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
    for _, group in ipairs(ns.Veterans()) do
        -- One row per veteran: NPC IDs with the same name and zone are merged (opens the lowest ID).
        local npcID, entry = group.id, group.entry
        local it = {
            id = npcID, entry = entry, group = group, name = entry.name or "?",
            label = ns.CodesLabel(group.codes), games = {}, zones = {}, campaigns = {},
        }
        it.lower = it.name:lower()
        local codes = group.codes
        it.bookOnly = #codes > 0
        for _, code in ipairs(codes) do
            it.games[code] = true
            if code ~= "BOOK" then
                it.bookOnly = false
            end
        end
        local function addZone(z)
            if type(z) == "string" and z ~= "" then
                it.zones[z] = true
                zoneSet[z] = true
            end
        end
        for _, id in ipairs(group.ids) do
            local e = ns.NPCS[id]
            addZone(e.zone)
            for _, z in ipairs(e.alsoIn or {}) do
                addZone(z)
            end
            for _, a in ipairs(e.appearances or {}) do
                local camp = a.campaign
                if type(camp) == "string" and camp ~= "" then
                    it.campaigns[camp] = true
                    local rank = gameRank[a.game] or 99
                    if not campaignRank[camp] or rank < campaignRank[camp] then
                        campaignRank[camp] = rank
                    end
                end
            end
        end
        -- The search box matches the name and every zone the veteran is found in.
        local haystack = { normalize(it.name) }
        for z in pairs(it.zones) do
            haystack[#haystack + 1] = normalize(z)
        end
        it.search = table.concat(haystack, "\1")
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
    zoneItems = { { label = L["All zones"], indent = 8 } }
    for _, z in ipairs(zones) do
        zoneItems[#zoneItems + 1] = { label = z, value = z, indent = 8 }
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
    campaignItems = { { label = L["All campaigns"], indent = 8 } }
    local lastRank
    for _, camp in ipairs(camps) do
        local rank = campaignRank[camp]
        if rank ~= lastRank then
            lastRank = rank
            local code = ns.GAME_ORDER[rank]
            campaignItems[#campaignItems + 1] = {
                header = true, label = (code and POPUP_HEAD[code]) or L["OTHER"],
                color = code and { ns.GameRGB(code) } or COL.muted,
            }
        end
        campaignItems[#campaignItems + 1] = { label = camp, value = camp, indent = 16 }
    end
end

-- The memorials as list items (same fields the rows use), sorted by name. Built on first use.
local memItems
local function buildMemorialIndex()
    if memItems then
        return
    end
    memItems = {}
    for _, m in ipairs(ns.MemorialList and ns.MemorialList() or {}) do
        local entry = m.entry
        local it = {
            memorial = true, key = m.key, id = m.key, entry = entry, name = entry.name or "?",
            label = ns.CodesLabel(m.codes), games = {}, zones = {}, campaigns = {}, codes = m.codes,
        }
        it.lower = it.name:lower()
        for _, code in ipairs(m.codes) do
            it.games[code] = true
        end
        it.search = table.concat({ normalize(it.name), normalize(entry.zone or ""),
            normalize(table.concat(entry.honors or {}, " ")) }, "\1")
        memItems[#memItems + 1] = it
    end
end

-- A veteran counts as met, a memorial as visited.
local function isMet(it)
    if it.memorial then
        return ns.IsVisited ~= nil and ns.IsVisited(it.key) == true
    end
    return ns.GroupMet(it.group)
end

-- Memorials per game: { code = { met = visited, total = n } }, a memorial with several games counts in each.
local function memorialCounts()
    buildMemorialIndex()
    local perGame, overall = {}, { met = 0, total = #memItems }
    for _, it in ipairs(memItems) do
        local met = isMet(it)
        if met then
            overall.met = overall.met + 1
        end
        for _, code in ipairs(it.codes) do
            local n = perGame[code]
            if not n then
                n = { met = 0, total = 0 }
                perGame[code] = n
            end
            n.total = n.total + 1
            if met then
                n.met = n.met + 1
            end
        end
    end
    return perGame, overall
end

local function matches(it, anyGame, hideBooks)
    if it.memorial then
        -- Memorials: game chips, visited status and the search box. No zone, campaign or book filters.
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
        local visited = isMet(it)
        if state.status == 2 and not visited then
            return false
        elseif state.status == 3 and visited then
            return false
        end
        return state.query == "" or string.find(it.search, state.query, 1, true) ~= nil
    end
    if hideBooks and it.bookOnly then
        return false
    end
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
    local met = ns.GroupMet(it.group)
    if state.status == 2 and not met then
        return false
    elseif state.status == 3 and met then
        return false
    end
    if state.query ~= "" and not string.find(it.search, state.query, 1, true) then
        return false
    end
    return true
end

-- Veterans met / total per zone, an alsoIn zone counts too. Built lazily from the index.
local function getZoneCounts()
    if zoneCounts then
        return zoneCounts
    end
    buildIndex()
    zoneCounts = {}
    for _, it in ipairs(items) do
        local met = ns.GroupMet(it.group)
        for z in pairs(it.zones) do
            local n = zoneCounts[z]
            if not n then
                n = { met = 0, total = 0 }
                zoneCounts[z] = n
            end
            n.total = n.total + 1
            if met then
                n.met = n.met + 1
            end
        end
    end
    return zoneCounts
end

-- "3/8" with the met part in the met color; a complete zone is all in the met color.
local function zoneCountText(n)
    if n.met >= n.total then
        return S.HEX_MET .. n.met .. "/" .. n.total .. END
    end
    return (n.met > 0 and (S.HEX_MET .. n.met .. END) or "0") .. "/" .. n.total
end

-- A filter or search is active (hide book-only is a preference, so it does not count).
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
    local pos = WarcraftLoreDB and WarcraftLoreDB.browserPos
    if type(pos) == "table" and pos.point then
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
-- (or above it when there is no room). Everything clickable in the window sits above a
-- transparent catcher, so a click on the bare window closes the popup and a click on any
-- control goes straight to that control (each control closes the popup itself).
local function setOwnerOpen(owner, open)
    if owner and owner.SetOpen then
        owner:SetOpen(open)
    end
end

-- Closes the popup without touching the search box (used when the search box takes focus).
local function hidePopup()
    if popup then
        popup.frame:Hide()
        popup.catcher:Hide()
    end
    setOwnerOpen(popupOwner, false)
    popupOwner = nil
end

local function closePopup()
    hidePopup()
    if searchEdit then
        searchEdit:ClearFocus()
    end
end

local function updatePopupScroll()
    if not popup then
        return
    end
    local range = popup.scroll:GetVerticalScrollRange() or 0
    local viewH = popup.scroll:GetHeight() or 0
    if range <= 0.5 or viewH <= 0 then
        popup.thumb:Hide()
        popup.track:Hide()
        popup.fade:Hide()
        return
    end
    popup.track:Show()
    local trackH = popup.track:GetHeight() or viewH
    local thumbH = math.max(18, trackH * viewH / (viewH + range))
    local cur = popup.scroll:GetVerticalScroll() or 0
    popup.thumb:ClearAllPoints()
    popup.thumb:SetPoint("TOPLEFT", popup.track, "TOPLEFT", 0, -(cur / range) * (trackH - thumbH))
    popup.thumb:SetSize(3, thumbH)
    popup.thumb:Show()
    if cur < range - 1 then
        popup.fade:Show()
    else
        popup.fade:Hide()
    end
end

local function buildPopup()
    local p = { rows = {} }

    p.catcher = CreateFrame("Button", nil, frame)
    p.catcher:SetAllPoints(frame)
    p.catcher:SetFrameLevel(catchLevel)
    C.RegisterClicks(p.catcher)
    p.catcher:SetScript("OnClick", closePopup)
    p.catcher:Hide()

    -- Soft drop shadow: four black fading strips around the popup (16 px, 60 %).
    p.shadowFrame = CreateFrame("Frame", nil, frame)
    p.shadowFrame:SetFrameLevel(catchLevel + 9)
    p.shadowFrame:Hide()
    p.frame = box(frame)
    p.frame:SetFrameLevel(catchLevel + 10)
    p.frame:SetWidth(POPUP_W)
    p.frame:SetClampedToScreen(true)
    p.frame:EnableMouse(true) -- clicks on the popup's own background must not reach the catcher
    p.frame:SetColors(COL.inner, 1, COL.violet, 1)
    p.frame:Hide()
    p.shadowFrame:SetAllPoints(p.frame) -- a frame without a rect may not draw its regions
    local function strip(file, c1, c2, flipU, flipV)
        local t = p.shadowFrame:CreateTexture(nil, "BACKGROUND")
        t:SetTexture(TEX .. file)
        t:SetVertexColor(0, 0, 0, 0.6)
        t:SetTexCoord(flipU and 1 or 0, flipU and 0 or 1, flipV and 1 or 0, flipV and 0 or 1)
        t:SetPoint(c1[1], p.frame, c1[2], c1[3], c1[4])
        t:SetPoint(c2[1], p.frame, c2[2], c2[3], c2[4])
    end
    strip("ShadowV", { "TOPLEFT", "BOTTOMLEFT", -16, 0 }, { "BOTTOMRIGHT", "BOTTOMRIGHT", 16, -16 })          -- below
    strip("ShadowV", { "BOTTOMLEFT", "TOPLEFT", -16, 0 }, { "TOPRIGHT", "TOPRIGHT", 16, 16 }, false, true)     -- above
    strip("ShadowH", { "TOPLEFT", "TOPRIGHT", 0, 0 }, { "BOTTOMRIGHT", "BOTTOMRIGHT", 16, 0 })                 -- right
    strip("ShadowH", { "TOPRIGHT", "TOPLEFT", 0, 0 }, { "BOTTOMLEFT", "BOTTOMLEFT", -16, 0 }, true, false)     -- left
    p.frame:SetScript("OnShow", function() p.shadowFrame:Show() end)
    p.frame:SetScript("OnHide", function() p.shadowFrame:Hide() end)

    p.scroll = CreateFrame("ScrollFrame", nil, p.frame)
    p.scroll:SetPoint("TOPLEFT", POPUP_PAD, -POPUP_PAD)
    p.scroll:SetPoint("BOTTOMRIGHT", -POPUP_PAD, POPUP_PAD)
    p.scroll:EnableMouseWheel(true)
    p.scroll:SetScript("OnMouseWheel", function(self, delta)
        local new = self:GetVerticalScroll() - delta * POPUP_ROW_H * 3
        new = math.max(0, math.min(new, self:GetVerticalScrollRange()))
        self:SetVerticalScroll(new)
    end)
    p.scroll:SetScript("OnVerticalScroll", updatePopupScroll)
    p.scroll:SetScript("OnScrollRangeChanged", updatePopupScroll)
    p.content = CreateFrame("Frame", nil, p.scroll)
    p.content:SetSize(POPUP_W - 2 * POPUP_PAD - 5, 10)
    p.scroll:SetScrollChild(p.content)

    -- The bottom fade and the thin scroll thumb show only when the list overflows.
    local over = CreateFrame("Frame", nil, p.frame)
    over:SetAllPoints(p.frame)
    over:SetFrameLevel(catchLevel + 20)
    p.fade = over:CreateTexture(nil, "OVERLAY")
    p.fade:SetTexture(TEX .. "FadeDown")
    p.fade:SetPoint("BOTTOMLEFT", POPUP_PAD, POPUP_PAD)
    p.fade:SetPoint("BOTTOMRIGHT", -POPUP_PAD - 5, POPUP_PAD)
    p.fade:SetHeight(26)
    p.track = CreateFrame("Frame", nil, over)
    p.track:SetWidth(3)
    p.track:SetPoint("TOPRIGHT", p.frame, "TOPRIGHT", -POPUP_PAD + 1, -POPUP_PAD)
    p.track:SetPoint("BOTTOMRIGHT", p.frame, "BOTTOMRIGHT", -POPUP_PAD + 1, POPUP_PAD)
    local trackBg = solid(p.track, "BACKGROUND", COL.divider, 0.8)
    trackBg:SetAllPoints()
    p.thumb = solid(p.track, "ARTWORK", COL.violet)
    p.thumb:SetSize(3, 18)
    popup = p
end

local function popupRow(i)
    local r = popup.rows[i]
    if r then
        return r
    end
    r = CreateFrame("Button", nil, popup.content)
    C.RegisterClicks(r)
    r.cur = solid(r, "BACKGROUND", COL.violet, 0.15)   -- the entry that is picked now
    r.cur:SetPoint("BOTTOMLEFT"); r.cur:SetPoint("BOTTOMRIGHT"); r.cur:SetHeight(POPUP_ROW_H)
    r.cur:Hide()
    r.hl = solid(r, "BACKGROUND", COL.violet, 0.25)
    r.hl:SetPoint("BOTTOMLEFT"); r.hl:SetPoint("BOTTOMRIGHT"); r.hl:SetHeight(POPUP_ROW_H)
    r.hl:Hide()
    r.line = solid(r, "BORDER", COL.divider)
    r.line:SetPoint("TOPLEFT", 0, -2); r.line:SetPoint("TOPRIGHT", 0, -2); r.line:SetHeight(1)
    r.label = text(r, C.FONT_BODY, 11, COL.text)
    r.label:SetJustifyV("MIDDLE")
    r.label:SetWordWrap(false)
    r.count = text(r, C.FONT_BODY, 10, COL.muted)       -- per-zone progress, right-aligned
    r.count:SetPoint("BOTTOMRIGHT", -6, 0)
    r.count:SetHeight(POPUP_ROW_H)
    r.count:SetJustifyH("RIGHT")
    r.count:SetJustifyV("MIDDLE")
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

-- list = { { label, value, header, color, indent }, ... }; the entry whose value equals
-- `current` is highlighted; onPick(value) runs when one is chosen. Clicking the owner
-- again closes it.
local function openPopup(owner, list, current, onPick)
    if popup and popup.frame:IsShown() and popupOwner == owner then
        closePopup()
        return
    end
    closePopup()
    if not popup then
        buildPopup()
    end
    popupOwner = owner
    setOwnerOpen(owner, true)
    popup.onPick = onPick
    local y = 0
    for i, it in ipairs(list) do
        local r = popupRow(i)
        local h = it.header and POPUP_HEAD_H or POPUP_ROW_H
        r:SetSize(popup.content:GetWidth(), h)
        r:ClearAllPoints()
        r:SetPoint("TOPLEFT", popup.content, "TOPLEFT", 0, -y)
        y = y + h
        r.isHeader = it.header and true or false
        r.value = it.value
        r.label:ClearAllPoints()
        local c
        if it.header then
            r.label:SetPoint("BOTTOMLEFT", 8, 2)
            r.label:SetPoint("BOTTOMRIGHT", -6, 2)
            C.SetFont(r.label, C.FONT_BODY, 9)
            r.line:Show()
            c = it.color or COL.muted
        else
            r.label:SetPoint("LEFT", it.indent or 8, 0)
            r.label:SetPoint("RIGHT", it.right and -46 or -6, 0)
            C.SetFont(r.label, C.FONT_BODY, 11)
            r.line:Hide()
            c = (it.value == current) and COL.title or COL.text
        end
        r.label:SetText(it.label)
        r.label:SetTextColor(c[1], c[2], c[3])
        if it.right then
            r.count:SetText(it.right)
            r.count:Show()
        else
            r.count:Hide()
        end
        if not it.header and it.value == current then
            r.cur:Show()
        else
            r.cur:Hide()
        end
        r.hl:Hide()
        r:Show()
    end
    for i = #list + 1, #popup.rows do
        popup.rows[i]:Hide()
    end
    popup.content:SetHeight(math.max(1, y))
    popup.scroll:SetVerticalScroll(0)

    -- Size and place it: below the button if it fits, otherwise above, never off the screen.
    local h = math.min(y + 2 * POPUP_PAD, POPUP_MAX_H)
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
    updatePopupScroll()
end

-------------------------------------------------------------------- list rows
local function showRowTip(r)
    local it = r.item
    if not it then
        return
    end
    local entry = it.entry
    local nc, mc = COL.title, COL.muted
    local lines = {
        { it.name, nc[1], nc[2], nc[3] },
        { entry.zone or "", mc[1], mc[2], mc[3] },
    }
    for _, code in ipairs(it.memorial and it.codes or it.group.codes) do          -- one game per line, in its color
        local gr, gg, gb = ns.GameRGB(code)
        lines[#lines + 1] = { ns.GAME_LONG[code] or code, gr, gg, gb }
    end
    if it.memorial then
        table.insert(lines, 3, { L["Honors %s"]:format(table.concat(entry.honors or {}, ", ")), COL.text[1], COL.text[2], COL.text[3] })
        local visit = isMet(it) and ns.VisitSummary(it.key)
        if visit then
            lines[#lines + 1] = { visit, COL.met[1], COL.met[2], COL.met[3] }
        else
            lines[#lines + 1] = { L["Not visited yet"], mc[1], mc[2], mc[3] }
        end
    elseif ns.GroupMet(it.group) then
        lines[#lines + 1] = { ns.MetSummary(it.group.ids[1]) or L["Met"], COL.met[1], COL.met[2], COL.met[3] }
    else
        lines[#lines + 1] = { L["Not met yet"], mc[1], mc[2], mc[3] }
    end
    lines[#lines + 1] = { L["Click to read their story"], mc[1], mc[2], mc[3] }
    C.ShowTooltip(r, { "TOPLEFT", "BOTTOMLEFT", 40, 0 }, lines, 220)
end

-- Selected (the veteran the lore window shows) and met colors of a row.
local function applyRowState(r)
    if not r.item then
        return
    end
    local selected
    if r.item.memorial then
        selected = ns.UI.GetShownMemorial ~= nil and ns.UI.GetShownMemorial() == r.item.key
    else
        local shownID = ns.UI.GetShownNPC()
        selected = shownID ~= nil and r.item.group.idSet[shownID] == true
    end
    if selected then
        r.sel:Show()
    else
        r.sel:Hide()
    end
    local nc = (r.met or selected) and COL.title or COL.text
    r.nameText:SetTextColor(nc[1], nc[2], nc[3])
end

local function acquireRow(i)
    local r = rows[i]
    if r then
        return r
    end
    r = CreateFrame("Button", nil, content)
    r:SetSize(CONTENT_W, ROW_H)
    r:SetPoint("TOPLEFT", content, "TOPLEFT", 0, -(i - 1) * ROW_H)
    C.RegisterClicks(r)
    r.alt = r:CreateTexture(nil, "BACKGROUND", nil, 0)     -- every other row is a little lighter
    r.alt:SetColorTexture(1, 1, 1, 0.025)
    r.alt:SetAllPoints()
    if i % 2 == 0 then r.alt:Show() else r.alt:Hide() end
    r.sel = r:CreateTexture(nil, "BACKGROUND", nil, 1)     -- shown in the lore window right now
    r.sel:SetColorTexture(COL.violet[1], COL.violet[2], COL.violet[3], 0.28)
    r.sel:SetAllPoints()
    r.sel:Hide()
    r.hl = r:CreateTexture(nil, "BACKGROUND", nil, 2)      -- mouse over
    r.hl:SetColorTexture(COL.violet[1], COL.violet[2], COL.violet[3], 0.18)
    r.hl:SetAllPoints()
    r.hl:Hide()
    -- Marker: met = filled green square, not met = hollow 5 px square.
    r.metMark = solid(r, "ARTWORK", COL.met)
    r.metMark:SetSize(7, 7)
    r.metMark:SetPoint("LEFT", 5, 0)
    r.hollow = CreateFrame("Frame", nil, r)
    r.hollow:SetSize(5, 5)
    r.hollow:SetPoint("LEFT", 6, 0)
    outline(r.hollow, 0, 1, COL.hollow, "ARTWORK")
    r.nameText = text(r, C.FONT_BODY, 12, COL.text)
    r.nameText:SetPoint("LEFT", COL_MARK, 0)
    r.nameText:SetJustifyV("MIDDLE")
    r.nameText:SetWordWrap(false)
    r.zoneText = text(r, C.FONT_BODY, 11, COL.muted)
    r.zoneText:SetPoint("LEFT", COL_MARK + COL_NAME, 0)
    r.zoneText:SetWidth(ZONE_W - 4)
    r.zoneText:SetJustifyV("MIDDLE")
    r.zoneText:SetWordWrap(false)
    r.gamesText = text(r, C.FONT_BODY, 11, COL.dim)         -- dim "·" separators; the codes carry their own color
    r.gamesText:SetPoint("RIGHT", -10, 0)
    r.gamesText:SetJustifyH("RIGHT")
    r.gamesText:SetJustifyV("MIDDLE")
    r.gamesText:SetWordWrap(false)
    r:SetScript("OnEnter", function(self)
        self.hl:Show()
        hoverRow = self
        showRowTip(self)
    end)
    r:SetScript("OnLeave", function(self)
        self.hl:Hide()
        if hoverRow == self then
            hoverRow = nil
            C.HideTooltip()
        end
    end)
    r:SetScript("OnClick", function(self)
        closePopup()
        if self.item then
            -- The lore window sits in a higher strata than this window, so it opens on top,
            -- docked next to this one.
            if self.item.memorial then
                ns.UI.ShowMemorial(self.item.key, frame)
            else
                ns.UI.ShowEntry(self.item.id, self.item.entry, nil, frame)
            end
        end
    end)
    rows[i] = r
    return r
end

local function fillRow(r, it)
    r.item = it
    r.met = isMet(it)
    if r.met then
        r.metMark:Show()
        r.hollow:Hide()
    else
        r.metMark:Hide()
        r.hollow:Show()
    end
    r.nameText:SetWidth(0)
    r.nameText:SetText(it.name)
    local limit = COL_NAME - 8
    r.nameText:SetWidth(math.max(20, math.min(math.ceil(r.nameText:GetStringWidth()) + 1, limit)))
    r.zoneText:SetText(it.entry.zone or "")
    r.gamesText:SetText(it.label)
    applyRowState(r)
    r:Show()
end

-- Re-marks which row is open in the lore window (called by UI.lua whenever it changes).
function Browser.RefreshSelection()
    if not frame or not frame:IsShown() then
        return
    end
    for _, r in ipairs(rows) do
        if r:IsShown() then
            applyRowState(r)
        end
    end
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
    thumb:SetSize(3, thumbH)
    thumb:Show()
end

-------------------------------------------------------------------- refresh
local function styleChip(chip, hover)
    local c = chip.color
    local on = state.games[chip.code]
    chip:SetColors(c, on and 0.2 or 0.07, hover and COL.title or c, (on or hover) and 1 or 0.45)
end

local function updateProgress(overall)
    progress.count:SetText(tostring(overall.met))
    progress.of:SetText(L["of %d"]:format(overall.total))
    local used = progress.label:GetStringWidth() + 10 + progress.count:GetStringWidth() + 10 + progress.of:GetStringWidth() + 10
    local reserved = journalBtn and (journalBtn:GetWidth() or 0) + 10 or 0   -- room for the Journal button
    if memBtn then
        reserved = reserved + (memBtn:GetWidth() or 0) + 14                 -- ... and the Memorials button
    end
    local barW = math.max(10, math.floor(CONTENT_W - used - reserved))
    progress.track:ClearAllPoints()
    progress.track:SetPoint("TOPLEFT", progress, "TOPLEFT", math.ceil(used), -10)
    progress.track:SetSize(barW, 4)
    local fillW = overall.total > 0 and math.floor(barW * overall.met / overall.total + 0.5) or 0
    if overall.met > 0 then
        fillW = math.max(fillW, 2)
    end
    if fillW > 0 then
        progress.fill:SetWidth(fillW)
        progress.fill:Show()
    else
        progress.fill:Hide()
    end
end

local function updateCounters()
    local perGame, overall
    if state.memorials then
        perGame, overall = memorialCounts()
    else
        perGame, overall = ns.MetCounts()
    end
    progress.label:SetText(state.memorials and L["MEMORIALS VISITED"] or L["VETERANS MET"])
    if memBtn then
        local _, all = memorialCounts()
        memBtn.label:SetText(state.memorials and L["Veterans"] or (L["Memorials"] .. " " .. all.met .. "/" .. all.total))
        memBtn:SetWidth(math.ceil(memBtn.label:GetStringWidth()))
        memBtn:SetShown(all.total > 0)
        local c = state.memorials and COL.title or COL.violet
        memBtn.label:SetTextColor(c[1], c[2], c[3])
    end
    updateProgress(overall)
    local shown = {}
    for _, code in ipairs(ns.GAME_ORDER) do
        local n = perGame[code]
        if n and n.total > 0 then
            shown[#shown + 1] = code
        else
            chips[code]:Hide()
        end
    end
    local gap = 6
    local w = (CONTENT_W - gap * (#shown - 1)) / math.max(#shown, 1)
    for i, code in ipairs(shown) do
        local chip, n = chips[code], perGame[code]
        chip:SetWidth(w)
        chip:ClearAllPoints()
        chip:SetPoint("TOPLEFT", chip:GetParent(), "TOPLEFT", (i - 1) * (w + gap), 0)
        chip.count:SetText(n.met .. "/" .. n.total)
        local barW = w - 16
        chip.track:SetWidth(barW)
        local fillW = math.floor(barW * n.met / n.total + 0.5)
        if n.met > 0 then
            fillW = math.max(fillW, 2)
        end
        if fillW > 0 then
            chip.fill:SetWidth(fillW)
            chip.fill:Show()
        else
            chip.fill:Hide()
        end
        styleChip(chip, false)
        chip:Show()
    end
end

local function updateFilterButtons()
    zoneBtn:SetValue(L["Zone"] .. " ", state.zone or L["All zones"], state.zone ~= nil)
    campaignBtn:SetValue(L["Campaign"] .. " ", state.campaign or L["All campaigns"], state.campaign ~= nil)
    local statusText = STATUS_LABELS[state.status]
    if state.memorials and state.status == 2 then
        statusText = L["Visited"]
    elseif state.memorials and state.status == 3 then
        statusText = L["Not visited"]
    end
    statusBtn:SetValue(L["Show"] .. " ", statusText, state.status ~= 1)
    -- Memorials have no zone, campaign or book filters: the Show button moves up to take their place.
    local mem = state.memorials
    zoneBtn:SetShown(not mem)
    campaignBtn:SetShown(not mem)
    hereBtn:SetShown(not mem)
    bookToggle:SetShown(not mem)
    statusBtn:ClearAllPoints()
    if mem then
        statusBtn:SetPoint("TOPLEFT", zoneBtn, "TOPLEFT", 0, 0)
    else
        statusBtn:SetPoint("TOPLEFT", campaignBtn, "TOPRIGHT", FILTER_GAP, 0)
    end
    Browser.UpdateHere()
    if anyFilter() then
        clearBtn:Show()
    else
        clearBtn:Hide()
    end
    local on = hideBookOnly()
    bookToggle.tick:SetShown(on)
    bookToggle.box:SetColors(COL.inner, 1, on and COL.violet or COL.headerLine, 1)
    local c = on and COL.title or COL.muted
    bookToggle.label:SetTextColor(c[1], c[2], c[3])
end

-- resetScroll = true when the filters changed; otherwise the scroll position is kept.
function Browser.Refresh(resetScroll)
    zoneCounts = nil
    if not frame or not frame:IsShown() then
        return
    end
    buildIndex()
    buildMemorialIndex()
    updateCounters()
    updateFilterButtons()

    local anyGame = next(state.games) ~= nil
    local hideBooks = hideBookOnly() and not state.memorials
    local list = state.memorials and memItems or items
    local shown = 0
    for _, it in ipairs(list) do
        if matches(it, anyGame, hideBooks) then
            shown = shown + 1
            fillRow(acquireRow(shown), it)
        end
    end
    for i = shown + 1, #rows do
        rows[i]:Hide()
        rows[i].item = nil
    end

    local previous = scroll:GetVerticalScroll() or 0
    content:SetSize(CONTENT_W, math.max(1, shown * ROW_H))
    local maxScroll = math.max(0, shown * ROW_H - (scroll:GetHeight() or 0))
    scroll:SetVerticalScroll(resetScroll and 0 or math.min(previous, maxScroll))
    updateThumb()

    local zn = state.zone and not state.memorials and getZoneCounts()[state.zone]
    if state.memorials then
        if anyFilter() then
            countText:SetText(L["Showing %d of %d"]:format(shown, #list))
        else
            countText:SetText(L["Showing all %d memorials"]:format(#list))
        end
    elseif zn then
        -- With a zone picked, the line shows that zone's progress ("1 of 6 met here"). The zone
        -- name is left out: the Zone button already shows it, and the row is narrow.
        local line = Browser.ZoneLine(zn.met, zn.total, shown)
        countText:SetText(line)
    elseif anyFilter() or hideBooks then
        countText:SetText(L["Showing %d of %d"]:format(shown, #items))
    else
        countText:SetText(L["Showing all %d veterans"]:format(#items))
    end
    emptyText:SetText(state.memorials and L["No memorials match."] or L["No veterans match."])
    if shown == 0 then
        emptyText:Show()
        emptyHint:Show()
    else
        emptyText:Hide()
        emptyHint:Hide()
    end

    -- A tooltip over a row that now shows someone else (or nobody) follows the new content.
    if hoverRow then
        if hoverRow:IsShown() and hoverRow.item then
            showRowTip(hoverRow)
        else
            hoverRow = nil
            C.HideTooltip()
        end
    end
end

local function refreshFiltered()
    Browser.Refresh(true)
end

-------------------------------------------------------------------- build
-- Every clickable control sits above the popup's click catcher.
local function raise(f)
    f:SetFrameLevel(ctlLevel)
    return f
end

-- "VETERANS MET  13  of N  [====      ]"
local function buildProgress(inner)
    progress = CreateFrame("Frame", nil, inner)
    progress:SetSize(CONTENT_W, 24)
    progress:SetPoint("TOPLEFT", inner, "TOPLEFT", PAD, -(HEADER + 10))
    progress.label = text(progress, C.FONT_BODY, 10, COL.violet)
    progress.label:SetPoint("BOTTOMLEFT", 0, 4)
    progress.label:SetText(L["VETERANS MET"])
    progress.count = text(progress, C.FONT_TITLE, 20, COL.title)
    progress.count:SetPoint("BOTTOMLEFT", progress.label, "BOTTOMRIGHT", 10, -3)
    progress.of = text(progress, C.FONT_BODY, 12, COL.muted)
    progress.of:SetPoint("BOTTOMLEFT", progress.count, "BOTTOMRIGHT", 10, 2)
    progress.track = solid(progress, "BACKGROUND", COL.divider)
    progress.fill = solid(progress, "ARTWORK", COL.met)
    progress.fill:SetPoint("TOPLEFT", progress.track, "TOPLEFT")
    progress.fill:SetPoint("BOTTOMLEFT", progress.track, "BOTTOMLEFT")

    -- Small text button at the right end: opens the Lore Journal (achievements).
    local jb = raise(CreateFrame("Button", nil, progress))
    jb:SetHeight(14)
    C.RegisterClicks(jb)
    local jl = text(jb, C.FONT_BODY, 11, COL.violet)
    jl:SetPoint("LEFT", 0, 0)
    jl:SetJustifyV("MIDDLE")
    jl:SetText(L["Journal"])
    jb:SetWidth(math.ceil(jl:GetStringWidth()))
    jb:SetPoint("BOTTOMRIGHT", progress, "BOTTOMRIGHT", 0, 4)
    jb:SetScript("OnEnter", function() jl:SetTextColor(COL.title[1], COL.title[2], COL.title[3]) end)
    jb:SetScript("OnLeave", function() jl:SetTextColor(COL.violet[1], COL.violet[2], COL.violet[3]) end)
    jb:SetScript("OnClick", function()
        closePopup()
        if ns.Journal then
            ns.Journal.Toggle()
        end
    end)
    journalBtn = jb

    -- Next to it: switches the list between the veterans and the memorials (graves, plaques, monuments).
    local mb = raise(CreateFrame("Button", nil, progress))
    mb:SetHeight(14)
    C.RegisterClicks(mb)
    mb.label = text(mb, C.FONT_BODY, 11, COL.violet)
    mb.label:SetPoint("LEFT", 0, 0)
    mb.label:SetJustifyV("MIDDLE")
    mb.label:SetText(L["Memorials"])
    mb:SetWidth(math.ceil(mb.label:GetStringWidth()))
    mb:SetPoint("BOTTOMRIGHT", jb, "BOTTOMLEFT", -14, 0)
    mb:SetScript("OnEnter", function(self) self.label:SetTextColor(COL.title[1], COL.title[2], COL.title[3]) end)
    mb:SetScript("OnLeave", function(self)
        local c = state.memorials and COL.title or COL.violet
        self.label:SetTextColor(c[1], c[2], c[3])
    end)
    mb:SetScript("OnClick", function()
        closePopup()
        Browser.SetMemorials(not state.memorials)
    end)
    memBtn = mb
end

-- Shows the memorials instead of the veterans (true) or back (false). Zone and campaign filters
-- belong to the veterans and are cleared.
function Browser.SetMemorials(on)
    state.memorials = on == true
    state.zone, state.campaign = nil, nil
    Browser.Refresh(true)
end

function Browser.IsShowingMemorials()
    return state.memorials == true
end

-- One chip per game: code, met/total and a thin bar. Clicking toggles the game filter.
local function buildChips(inner)
    local holder = CreateFrame("Frame", nil, inner)
    holder:SetSize(CONTENT_W, 32)
    holder:SetPoint("TOPLEFT", progress, "BOTTOMLEFT", 0, -8)
    for _, code in ipairs(ns.GAME_ORDER) do
        local chip = raise(box(holder, "Button"))
        chip:SetHeight(32)
        C.RegisterClicks(chip)
        chip.code = code
        chip.color = { ns.GameRGB(code) }
        local c = chip.color
        chip.codeText = text(chip, C.FONT_BODY, 11, c)
        chip.codeText:SetPoint("TOPLEFT", 8, -6)
        chip.codeText:SetText(ns.GAME_SHORT[code] or code)
        chip.count = text(chip, C.FONT_BODY, 11, COL.text)
        chip.count:SetPoint("TOPRIGHT", -8, -6)
        chip.count:SetJustifyH("RIGHT")
        chip.track = solid(chip, "ARTWORK", { 1, 1, 1 }, 0.08)
        chip.track:SetPoint("TOPLEFT", 8, -23)
        chip.track:SetHeight(2)
        chip.fill = solid(chip, "OVERLAY", c)
        chip.fill:SetPoint("TOPLEFT", 8, -23)
        chip.fill:SetHeight(2)
        chip:SetScript("OnClick", function()
            closePopup()
            if state.games[code] then
                state.games[code] = nil
            else
                state.games[code] = true
            end
            refreshFiltered()
        end)
        chip:SetScript("OnEnter", function(self) styleChip(self, true) end)
        chip:SetScript("OnLeave", function(self) styleChip(self, false) end)
        chips[code] = chip
    end
    return holder
end

local function buildSearch(inner, above)
    local holder = box(inner)
    holder:SetSize(CONTENT_W, 24)
    holder:SetPoint("TOPLEFT", above, "BOTTOMLEFT", 0, -8)
    holder:SetColors(COL.inner, 1, COL.headerLine, 1)

    local glass = holder:CreateTexture(nil, "ARTWORK")
    glass:SetTexture(TEX .. "Magnifier")
    glass:SetSize(12, 12)
    glass:SetPoint("LEFT", 9, 0)
    glass:SetVertexColor(COL.muted[1], COL.muted[2], COL.muted[3])

    searchHint = text(holder, C.FONT_BODY, 12, COL.muted)
    searchHint:SetPoint("LEFT", 27, 0)
    searchHint:SetJustifyV("MIDDLE")

    searchEdit = C.CreateEditBox(holder, C.FONT_BODY, 12)
    if not searchEdit then
        searchHint:SetText(L["Search is not available in this client."])
        return holder
    end
    raise(searchEdit)
    searchHint:SetText(L["Search by name or zone"])
    searchEdit:SetPoint("TOPLEFT", holder, "TOPLEFT", 27, -3)
    searchEdit:SetPoint("BOTTOMRIGHT", holder, "BOTTOMRIGHT", -9, 3)
    searchEdit:SetTextColor(COL.text[1], COL.text[2], COL.text[3])
    searchEdit:SetScript("OnTextChanged", function(self)
        local raw = self:GetText() or ""
        if raw == "" then
            searchHint:Show()
        else
            searchHint:Hide()
        end
        local q = normalize(raw)
        if q ~= state.query then
            state.query = q
            refreshFiltered()
        end
    end)
    searchEdit:SetScript("OnEscapePressed", function(self) self:ClearFocus() end)
    searchEdit:SetScript("OnEnterPressed", function(self) self:ClearFocus() end)
    searchEdit:SetScript("OnEditFocusGained", function()
        hidePopup()
        holder:SetColors(COL.inner, 1, COL.violet, 1)
    end)
    searchEdit:SetScript("OnEditFocusLost", function()
        holder:SetColors(COL.inner, 1, COL.headerLine, 1)
    end)
    return holder
end

-- A dropdown-looking button: muted "Prefix " then the value, and a small chevron
-- (withChevron = false for the Show button, which cycles instead of opening a list).
local function filterButton(parent, width, withChevron)
    local b = raise(box(parent, "Button"))
    b:SetSize(width, 22)
    C.RegisterClicks(b)
    b.label = text(b, C.FONT_BODY, 11, COL.text)
    b.label:SetPoint("LEFT", LABEL_INSET, 0)
    b.label:SetPoint("RIGHT", withChevron and -CHEVRON_INSET or -LABEL_INSET, 0)
    b.label:SetJustifyV("MIDDLE")
    b.label:SetWordWrap(false)
    if withChevron then
        b.chevron = b:CreateTexture(nil, "ARTWORK")
        b.chevron:SetTexture(TEX .. "ChevronDown")
        b.chevron:SetSize(10, 10)
        b.chevron:SetPoint("RIGHT", -8, 0)
        b.chevron:SetVertexColor(COL.muted[1], COL.muted[2], COL.muted[3])
    end
    b.active, b.open, b.hover = false, false, false
    local function paint(self)
        local lit = self.open or self.hover
        self:SetColors(lit and COL.header or COL.inner, 1, (lit or self.active) and COL.violet or COL.headerLine, 1)
        if self.chevron then
            local c = self.open and COL.title or COL.muted
            self.chevron:SetVertexColor(c[1], c[2], c[3])
            if self.open then
                self.chevron:SetTexCoord(0, 1, 1, 0)   -- flipped: points up while the list is open
            else
                self.chevron:SetTexCoord(0, 1, 0, 1)
            end
        end
    end
    function b:SetValue(prefix, value, active)
        self.active = active
        self.label:SetText(S.HEX_MUTED .. prefix .. END .. value)
        local c = active and COL.title or COL.text
        self.label:SetTextColor(c[1], c[2], c[3])
        paint(self)
    end
    function b:SetOpen(open)
        self.open = open
        paint(self)
    end
    b:SetScript("OnEnter", function(self) self.hover = true paint(self) end)
    b:SetScript("OnLeave", function(self) self.hover = false paint(self) end)
    paint(b)
    return b
end

local function buildFilters(inner, above)
    local campaignW = CONTENT_W - ZONE_BTN_W - STATUS_BTN_W - 2 * FILTER_GAP

    zoneBtn = filterButton(inner, ZONE_BTN_W, true)
    zoneBtn:SetPoint("TOPLEFT", above, "BOTTOMLEFT", 0, -8)
    zoneBtn:SetScript("OnClick", function(self)
        local counts = getZoneCounts()
        for _, z in ipairs(zoneItems) do
            z.right = z.value and counts[z.value] and zoneCountText(counts[z.value]) or nil
        end
        openPopup(self, zoneItems, state.zone, function(value)
            state.zone = value
            refreshFiltered()
        end)
    end)

    campaignBtn = filterButton(inner, campaignW, true)
    campaignBtn:SetPoint("TOPLEFT", zoneBtn, "TOPRIGHT", FILTER_GAP, 0)
    campaignBtn:SetScript("OnClick", function(self)
        buildIndex()
        openPopup(self, campaignItems, state.campaign, function(value)
            state.campaign = value
            refreshFiltered()
        end)
    end)

    statusBtn = filterButton(inner, STATUS_BTN_W, false)
    statusBtn:SetPoint("TOPLEFT", campaignBtn, "TOPRIGHT", FILTER_GAP, 0)
    statusBtn:SetScript("OnClick", function()
        closePopup()
        state.status = state.status % #STATUS_LABELS + 1
        refreshFiltered()
    end)
    return zoneBtn
end

-- Count line with a zone picked; "showing N" only when other filters shrink the zone's list.
function Browser.ZoneLine(met, total, shown)
    local line = L["%s%d of %d%s met here"]:format(S.HEX_MET, met, total, END)
    if shown ~= total then
        line = line .. L["  ·  showing %d"]:format(shown)
    end
    return line
end

-- "Showing all N veterans" ... "Clear filters" ... [ ] Hide book-only
-- Width left for the count text once "Clear filters", "This zone" and the book toggle sit at
-- the right end of the row (each separated by COUNT_GAP, plus one gap before the text).
function Browser.CountRowWidth(bookW, hereW, clearW)
    return CONTENT_W - bookW - hereW - clearW - 3 * COUNT_GAP
end

-- Layout numbers for tests: filter button widths and the room a label has inside a button.
function Browser.FilterLayout()
    return {
        zone = ZONE_BTN_W, status = STATUS_BTN_W,
        campaign = CONTENT_W - ZONE_BTN_W - STATUS_BTN_W - 2 * FILTER_GAP,
        chevronInset = CHEVRON_INSET, labelInset = LABEL_INSET, contentW = CONTENT_W,
    }
end

local function buildCountRow(inner, above)
    local row = CreateFrame("Frame", nil, inner)
    row:SetSize(CONTENT_W, 14)
    row:SetPoint("TOPLEFT", above, "BOTTOMLEFT", 0, -8)

    countText = text(row, C.FONT_BODY, 11, COL.muted)
    countText:SetPoint("LEFT", 0, 0)
    countText:SetJustifyV("MIDDLE")
    countText:SetJustifyH("LEFT")
    countText:SetWordWrap(false)

    bookToggle = raise(CreateFrame("Button", nil, row))
    bookToggle:SetHeight(14)
    C.RegisterClicks(bookToggle)
    bookToggle.box = box(bookToggle)
    bookToggle.box:SetSize(10, 10)
    bookToggle.box:SetPoint("LEFT", 0, 0)
    bookToggle.tick = solid(bookToggle.box, "ARTWORK", COL.violet)
    bookToggle.tick:SetSize(6, 6)
    bookToggle.tick:SetPoint("CENTER")
    bookToggle.label = text(bookToggle, C.FONT_BODY, 11, COL.muted)
    bookToggle.label:SetPoint("LEFT", 16, 0)
    bookToggle.label:SetJustifyV("MIDDLE")
    bookToggle.label:SetText(L["Hide book-only"])
    bookToggle:SetWidth(math.ceil(16 + bookToggle.label:GetStringWidth()))
    bookToggle:SetPoint("RIGHT", row, "RIGHT", 0, 0)
    bookToggle:SetScript("OnClick", function()
        closePopup()
        if hideBookOnly() then
            WarcraftLoreDB.hideBookOnly = nil
        else
            WarcraftLoreDB.hideBookOnly = true
        end
        refreshFiltered()
    end)

    -- "This zone": small text button that filters to the zone the player is standing in
    -- (dimmed when that zone has no veterans or is already the filter).
    hereBtn = raise(CreateFrame("Button", nil, row))
    hereBtn:SetHeight(14)
    C.RegisterClicks(hereBtn)
    hereBtn.label = text(hereBtn, C.FONT_BODY, 11, COL.violet)
    hereBtn.label:SetPoint("LEFT", 0, 0)
    hereBtn.label:SetJustifyV("MIDDLE")
    hereBtn.label:SetWordWrap(false)
    hereBtn.label:SetText(L["This zone"])
    hereBtn:SetWidth(math.ceil(hereBtn.label:GetStringWidth()))
    hereBtn:SetPoint("RIGHT", bookToggle, "LEFT", -COUNT_GAP, 0)
    hereBtn:SetScript("OnEnter", function(self)
        if self.usable ~= false then
            self.label:SetTextColor(COL.title[1], COL.title[2], COL.title[3])
        end
    end)
    hereBtn:SetScript("OnLeave", function() Browser.UpdateHere() end)
    hereBtn:SetScript("OnClick", function()
        closePopup()
        Browser.ThisZone()
    end)

    clearBtn = raise(CreateFrame("Button", nil, row))
    clearBtn:SetHeight(14)
    C.RegisterClicks(clearBtn)
    local clearLabel = text(clearBtn, C.FONT_BODY, 11, COL.violet)
    clearLabel:SetPoint("LEFT", 0, 0)
    clearLabel:SetJustifyV("MIDDLE")
    clearLabel:SetText(L["Clear filters"])
    clearBtn:SetWidth(math.ceil(clearLabel:GetStringWidth()))
    clearBtn:SetPoint("RIGHT", hereBtn, "LEFT", -COUNT_GAP, 0)
    clearBtn:SetScript("OnEnter", function() clearLabel:SetTextColor(COL.title[1], COL.title[2], COL.title[3]) end)
    clearBtn:SetScript("OnLeave", function() clearLabel:SetTextColor(COL.violet[1], COL.violet[2], COL.violet[3]) end)
    clearBtn:SetScript("OnClick", function()
        closePopup()
        state.games = {}
        state.zone, state.campaign, state.status, state.query = nil, nil, 1, ""
        if searchEdit then
            searchEdit:SetText("")
        end
        refreshFiltered()
    end)
    clearBtn:Hide()
    countText:SetWidth(Browser.CountRowWidth(bookToggle:GetWidth(), hereBtn:GetWidth(), clearBtn:GetWidth()))
    return row
end

local function buildList(inner, above)
    -- Column header: NAME / ZONE / APPEARS IN over a thin divider.
    local head = CreateFrame("Frame", nil, inner)
    head:SetSize(CONTENT_W, 15)
    head:SetPoint("TOPLEFT", above, "BOTTOMLEFT", 0, -6)
    local function heading(str)
        local fs = text(head, C.FONT_BODY, 9, COL.violet)
        fs:SetText(str)
        return fs
    end
    heading(L["NAME"]):SetPoint("TOPLEFT", COL_MARK, 0)
    heading(L["ZONE"]):SetPoint("TOPLEFT", COL_MARK + COL_NAME, 0)
    local appears = heading(L["APPEARS IN"])
    appears:SetPoint("TOPRIGHT", -10, 0)
    appears:SetJustifyH("RIGHT")
    local line = solid(head, "BORDER", COL.divider)
    line:SetPoint("BOTTOMLEFT"); line:SetPoint("BOTTOMRIGHT"); line:SetHeight(1)

    scroll = raise(CreateFrame("ScrollFrame", nil, inner))
    scroll:SetPoint("TOPLEFT", head, "BOTTOMLEFT", 0, 0)
    scroll:SetPoint("BOTTOMRIGHT", inner, "BOTTOMRIGHT", -PAD, PAD)
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
    content:SetSize(CONTENT_W, 10)
    scroll:SetScrollChild(content)

    -- A thin scrollbar on top of the list's right edge: a track and a thumb.
    track = CreateFrame("Frame", nil, inner)
    track:SetFrameLevel(ctlLevel + 5)
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
    emptyText:SetText(L["No veterans match."])
    emptyText:Hide()
    emptyHint = text(inner, C.FONT_BODY, 11, COL.muted)
    emptyHint:SetPoint("TOP", emptyText, "BOTTOM", 0, -4)
    emptyHint:SetJustifyH("CENTER")
    emptyHint:SetText(L["Try another name, or clear the filters."])
    emptyHint:Hide()
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
    catchLevel = frame:GetFrameLevel() + 20
    ctlLevel = catchLevel + 5

    S.buildFrameArt(frame, W, H)
    local inner = S.buildInner(frame)
    local close = raise(S.buildHeader(inner, L["Warcraft Veterans"], function() frame:Hide() end))
    raise(close.themeButton)

    buildProgress(inner)
    local chipRow = buildChips(inner)
    local searchHolder = buildSearch(inner, chipRow)
    local filterRow = buildFilters(inner, searchHolder)
    local countRow = buildCountRow(inner, filterRow)
    buildList(inner, countRow)

    frame:SetScript("OnShow", function() Browser.Refresh(true) end)
    frame:SetScript("OnHide", function()
        closePopup()
        if hoverRow then
            hoverRow = nil
            C.HideTooltip()
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

-- Opens the window (never closes it), filtered to a zone. A zone no veteran is in leaves the list unfiltered.
function Browser.ShowZone(zoneName)
    Browser.Init()
    buildIndex()
    local known = false
    for _, z in ipairs(zoneItems or {}) do
        if z.value and z.value == zoneName then
            known = true
        end
    end
    state.zone = known and zoneName or nil
    state.memorials = false -- a zone is a list of veterans
    if frame:IsShown() then
        Browser.Refresh(true)
    else
        frame:Show()
    end
end

-- The zone the player is in, when at least one veteran is found there (otherwise nil).
local function hereZone()
    -- By uiMapID first: the map name is translated in a German or French client, Data.lua is English.
    local mapID = C.GetZoneMapID and C.GetZoneMapID()
    if mapID and type(ns.ZONE_MAPS) == "table" then
        local counts = getZoneCounts()
        for name, ids in pairs(ns.ZONE_MAPS) do
            if counts[name] then
                for _, id in ipairs(ids) do
                    if id == mapID then
                        return name
                    end
                end
            end
        end
    end
    local zone = C.GetZoneName()
    if zone and getZoneCounts()[zone] then
        return zone
    end
    return nil
end

-- Dims the "This zone" button when there is nothing to show for the current zone, or when
-- the list is already filtered to it.
function Browser.UpdateHere()
    if not hereBtn then
        return
    end
    local zone = hereZone()
    hereBtn.usable = zone ~= nil and zone ~= state.zone
    local c = hereBtn.usable and COL.violet or COL.dim
    hereBtn.label:SetTextColor(c[1], c[2], c[3])
end

-- Filters the list to the player's current zone. Returns true when it did.
function Browser.ThisZone()
    local zone = hereZone()
    if not zone then
        return false
    end
    Browser.ShowZone(zone)
    return true
end

-- Met / total veterans in a zone (nil, nil for a zone nobody is found in).
function Browser.ZoneProgress(zone)
    local n = getZoneCounts()[zone]
    if n then
        return n.met, n.total
    end
    return nil, nil
end

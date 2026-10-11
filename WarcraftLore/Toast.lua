-- Toast.lua – the veteran alert pill, shown for nearby veterans (nameplate / map position) and when
-- you target one: a small glowing pill at the top of the screen with a round portrait, the name
-- and the game codes (max 3 at once, extra ones queue).
-- Click opens the lore window of the named veteran, "+N more" opens the Veterans list for the zone, right-click dismisses, shift-drag moves them.

local ADDON_NAME, ns = ...
local C = ns.Compat

local Toast = {}
ns.Toast = Toast

local S = ns.Style
local COL = S.COL

local TEX = "Interface\\AddOns\\" .. ADDON_NAME .. "\\Textures\\"
local PORTRAITS = "Interface\\AddOns\\" .. ADDON_NAME .. "\\Portraits\\"
local QUESTION_MARK = "Interface\\Icons\\INV_Misc_QuestionMark"

local TOAST_W, TOAST_H = 236, 48
local MORE_W = 56               -- width of the "+N more" target
local GAP = 16                  -- room for two glows, so neighbours do not mix
local MAX_TOASTS = 3
local FADE_IN, HOLD, FADE_OUT = 0.4, 12, 0.8
local GLOW_PAD = 16                 -- the glow texture reaches this far past the pill
local GLOW_LO, GLOW_HI, GLOW_HALF = 0.35, 1, 1.2   -- pulse: lo -> hi -> lo takes 2.4 s
local BORDER_ALPHA = 0.55

local anchor
local active = {}   -- toasts on screen, top first
local queue = {}    -- waiting { npcID, entry, name, unit }
local moving = false        -- a shift-drag is in progress
local lastDragEnd = -1
local CLICK_GRACE = 0.2     -- seconds after a drag in which a mouse-up does not count as a click

local function savePosition()
    local point, _, relativePoint, x, y = anchor:GetPoint(1)
    WarcraftLoreDB.toastPos = { point = point, relativePoint = relativePoint, x = x, y = y }
end

local function ensureAnchor()
    if anchor then
        return
    end
    anchor = CreateFrame("Frame", nil, UIParent)
    anchor:SetSize(TOAST_W, 1)
    anchor:SetMovable(true)
    anchor:SetClampedToScreen(true)
    local pos = WarcraftLoreDB and WarcraftLoreDB.toastPos
    if type(pos) == "table" and pos.point then
        anchor:SetPoint(pos.point, UIParent, pos.relativePoint or pos.point, pos.x or 0, pos.y or 0)
    else
        anchor:SetPoint("TOP", UIParent, "TOP", 0, -64)
    end
end

local function layoutToasts()
    for i, t in ipairs(active) do
        t:ClearAllPoints()
        t:SetPoint("TOP", anchor, "TOP", 0, -(i - 1) * (TOAST_H + GAP))
    end
end

local showNext

local function dismiss(t)
    for i, v in ipairs(active) do
        if v == t then
            table.remove(active, i)
            break
        end
    end
    if t.pulse then
        t.pulse.Stop()
    end
    t:Hide()
    t.state = nil
    t.pool = true
    layoutToasts()
    showNext()
end

-- Border and glow brighten while the mouse is over the pill, and the glow stops pulsing.
local function setHover(t, hover)
    t.hover = hover
    local a = hover and 1 or BORDER_ALPHA
    for _, e in ipairs(t.edges) do
        e:SetColorTexture(t.r, t.g, t.b, a)
    end
    if hover then
        if t.pulse then
            t.pulse.Stop()
        end
        t.glow:SetAlpha(1)
    elseif t.pulse then
        t.pulse.Play()
    end
end

local function onUpdate(t, dt)
    if t.state == nil then
        return
    end
    t.age = t.age + dt
    local a
    local over = t:IsMouseOver()
    if over ~= t.hover then
        setHover(t, over)
    end
    if t.age < FADE_IN then
        a = t.age / FADE_IN
    elseif t.age < FADE_IN + HOLD or over then
        if t.age >= FADE_IN + HOLD then
            t.age = FADE_IN + HOLD -- stay while the mouse is over it
        end
        a = 1
    elseif t.age < FADE_IN + HOLD + FADE_OUT then
        a = 1 - (t.age - FADE_IN - HOLD) / FADE_OUT
    else
        dismiss(t)
        return
    end
    t:SetAlpha(a)
    if not t.pulse and not over then
        -- No animation groups in this client: pulse the glow by hand.
        local phase = (t.age % (2 * GLOW_HALF)) / GLOW_HALF   -- 0..2
        local k = phase <= 1 and phase or 2 - phase
        t.glow:SetAlpha(GLOW_LO + (GLOW_HI - GLOW_LO) * k)
    end
end

local pool = {}

local function build()
    local t = CreateFrame("Button", nil, UIParent)
    t:SetSize(TOAST_W, TOAST_H)
    t:SetFrameStrata("FULLSCREEN_DIALOG")
    t:EnableMouse(true)
    C.RegisterClicks(t)
    t:RegisterForDrag("LeftButton")

    -- Soft glow around the pill, tinted with the first game's color and pulsing.
    t.glow = t:CreateTexture(nil, "BACKGROUND", nil, 0)
    t.glow:SetTexture(TEX .. "PillGlow")
    C.SetBlendMode(t.glow, "ADD")
    t.glow:SetPoint("TOPLEFT", -GLOW_PAD, GLOW_PAD)
    t.glow:SetPoint("BOTTOMRIGHT", GLOW_PAD, -GLOW_PAD)
    t.pulse = C.CreatePulse(t.glow, GLOW_LO, GLOW_HI, GLOW_HALF)

    t.bg = t:CreateTexture(nil, "BACKGROUND", nil, 1)
    t.bg:SetAllPoints()
    t.bg:SetColorTexture(0.071, 0.059, 0.110, 0.94)

    t.edges = S.outline(t, 0, 1, COL.violet, "BORDER")

    -- Round portrait in a thin ring tinted with the game's color.
    t.portrait = t:CreateTexture(nil, "ARTWORK")
    t.portrait:SetSize(32, 32)
    t.portrait:SetPoint("LEFT", 10, 0)
    C.ApplyCircleMask(t.portrait, TEX .. "CircleMask")
    t.ringGlow = t:CreateTexture(nil, "BORDER")      -- the lore window's ring, small: a soft halo under the thin ring
    t.ringGlow:SetTexture(TEX .. "RingGlow")
    t.ringGlow:SetSize(54, 54)
    t.ringGlow:SetPoint("CENTER", t.portrait, "CENTER")
    t.ring = t:CreateTexture(nil, "OVERLAY")
    t.ring:SetTexture(TEX .. "RingThin")
    t.ring:SetSize(40, 40)
    t.ring:SetPoint("CENTER", t.portrait, "CENTER")

    t.name = S.text(t, C.FONT_TITLE, 15, COL.title)
    t.name:SetPoint("TOPLEFT", t, "TOPLEFT", 56, -9)
    t.name:SetWidth(TOAST_W - 56 - 12 - 12 - 4)
    t.name:SetWordWrap(false)

    t.games = S.text(t, C.FONT_BODY, 10, COL.dim)   -- dim "·" separators; the codes carry their own color
    t.games:SetPoint("TOPLEFT", t.name, "BOTTOMLEFT", 0, -2)
    t.games:SetWidth(TOAST_W - 56 - 12 - 12 - 4)     -- never runs under the chevron
    t.games:SetWordWrap(false)
    t.games:SetJustifyH("LEFT")

    t.chevron = t:CreateTexture(nil, "ARTWORK")
    t.chevron:SetTexture(TEX .. "ChevronRight")
    t.chevron:SetSize(10, 10)
    t.chevron:SetPoint("RIGHT", -10, 0)
    t.chevron:SetVertexColor(COL.muted[1], COL.muted[2], COL.muted[3])

    t:SetScript("OnClick", ns.Guard("alert", "the nearby alert", function(self, button)
        if moving or C.Now() - lastDragEnd < CLICK_GRACE then
            return -- the mouse-up that ends a drag is not a click
        end
        if button == "RightButton" then
            dismiss(self)
        elseif self.npcID and not ns.FeatureOff("window") then
            ns.UI.ShowEntry(self.npcID, self.entry, nil)
            dismiss(self)
        end
    end))

    -- "+N more": its own small target; opens the Veterans list for the zone you are in.
    t.moreBtn = CreateFrame("Button", nil, t)
    t.moreBtn:SetSize(MORE_W, 14)
    t.moreBtn:SetPoint("BOTTOMRIGHT", t, "BOTTOMRIGHT", -24, 8)
    t.moreBtn:EnableMouse(true)
    C.RegisterClicks(t.moreBtn)
    t.moreText = S.text(t.moreBtn, C.FONT_BODY, 10, COL.muted)
    t.moreText:SetAllPoints()
    t.moreText:SetJustifyH("RIGHT")
    t.moreBtn:SetScript("OnClick", ns.Guard("alert", "the nearby alert", function(self)
        if moving or C.Now() - lastDragEnd < CLICK_GRACE then
            return
        end
        if ns.Browser and ns.Browser.ShowZone then
            ns.Browser.ShowZone(C.GetZoneName())
        end
    end))
    t.moreBtn:SetScript("OnEnter", function() setHover(t, true); t.moreText:SetTextColor(COL.title[1], COL.title[2], COL.title[3]) end)
    t.moreBtn:SetScript("OnLeave", function() t.moreText:SetTextColor(COL.muted[1], COL.muted[2], COL.muted[3]) end)

    t:SetScript("OnEnter", function(self) setHover(self, true) end)
    t:SetScript("OnLeave", function(self) setHover(self, false) end)
    t:SetScript("OnDragStart", function()
        if C.IsShiftDown() then
            moving = true
            anchor:StartMoving()
        end
    end)
    t:SetScript("OnDragStop", function()
        if not moving then
            return
        end
        moving = false
        lastDragEnd = C.Now()
        anchor:StopMovingOrSizing()
        savePosition()
    end)
    t:SetScript("OnUpdate", onUpdate)
    return t
end

-- Game codes, plus a short "+N more" when other veterans appeared together with this one.
local function setGames(t)
    local n = t.more or 0
    t.games:SetText(ns.GamesLabel(t.entry))
    t.games:SetWidth(TOAST_W - 56 - 12 - 12 - 4 - (n > 0 and MORE_W or 0))
    t.moreText:SetText("+" .. n .. " more")
    if n > 0 then
        t.moreBtn:Show()
    else
        t.moreBtn:Hide()
    end
end

local function display(npcID, entry, name, unit, more)
    ensureAnchor()
    local t
    for _, v in ipairs(pool) do
        if v.pool then
            t = v
            break
        end
    end
    if not t then
        t = build()
        pool[#pool + 1] = t
    end
    t.pool = false
    t.npcID, t.entry = npcID, entry
    t.age = 0
    t.state = "show"

    local codes = ns.GamesInOrder(entry)
    local r, g, b = ns.GameRGB(codes[1])
    t.r, t.g, t.b = r, g, b
    t.glow:SetVertexColor(r, g, b)
    t.glow:SetAlpha(GLOW_HI)
    t.ring:SetVertexColor(r, g, b)
    t.ringGlow:SetVertexColor(r, g, b, 0.8)
    t.name:SetText(name or entry.name or "?")
    t.more = more
    setGames(t)

    t.portrait:SetTexCoord(0, 1, 0, 1)
    if entry.portrait and entry.portrait ~= "" then
        t.portrait:SetTexture(PORTRAITS .. entry.portrait)
    elseif unit and C.SetUnitPortrait(t.portrait, unit) then
        -- WoW's own portrait of the NPC
    else
        t.portrait:SetTexture(QUESTION_MARK)
        t.portrait:SetTexCoord(0.08, 0.92, 0.08, 0.92)
    end

    t.hover = nil
    setHover(t, false)
    t:SetAlpha(0)
    t:Show()
    active[#active + 1] = t
    layoutToasts()
end

showNext = function()
    while #active < MAX_TOASTS and #queue > 0 do
        local q = table.remove(queue, 1)
        display(q.npcID, q.entry, q.name, q.unit, q.more)
    end
end

-- Adds "+N more" to the pill of a veteran that is already on screen (no-op if it is gone).
function Toast.SetMore(npcID, more)
    for _, t in ipairs(active) do
        if t.npcID == npcID then
            t.more = more
            setGames(t)
            return
        end
    end
    for _, q in ipairs(queue) do
        if q.npcID == npcID then
            q.more = more -- shown when the pill comes up
            return
        end
    end
end

-- Shows the pill for a veteran. Someone already on screen or waiting is not shown twice.
-- unit = optional unit token ("target", "nameplate3") for the portrait.
-- more = optional number of other veterans that appeared at the same time ("+N more nearby").
function Toast.Show(npcID, entry, name, unit, more)
    for _, t in ipairs(active) do
        if t.npcID == npcID then
            return
        end
    end
    for _, q in ipairs(queue) do
        if q.npcID == npcID then
            return
        end
    end
    queue[#queue + 1] = { npcID = npcID, entry = entry, name = name, unit = unit, more = more }
    showNext()
end

-------------------------------------------------------------------- Achievement banner
-- A small golden banner under the anchor: "Achievement earned" and the title (or the count when
-- several came at once). One banner at a time; a new one replaces the old. Right-click or time dismisses it.
local banner
local BANNER_W, BANNER_H, BANNER_HOLD, BANNER_FADE = 260, 44, 6, 0.8

local function buildBanner()
    local b = CreateFrame("Button", nil, UIParent)
    b:SetSize(BANNER_W, BANNER_H)
    b:SetFrameStrata("FULLSCREEN_DIALOG")
    b:EnableMouse(true)
    C.RegisterClicks(b)
    b.bg = b:CreateTexture(nil, "BACKGROUND")
    b.bg:SetAllPoints()
    b.bg:SetColorTexture(0.071, 0.059, 0.110, 0.94)
    b.edges = S.outline(b, 0, 1, COL.gold, "BORDER")
    b.head = S.text(b, C.FONT_BODY, 10, COL.gold)
    b.head:SetPoint("TOPLEFT", b, "TOPLEFT", 12, -8)
    b.head:SetText("ACHIEVEMENT EARNED")
    b.title = S.text(b, C.FONT_TITLE, 14, COL.title)
    b.title:SetPoint("TOPLEFT", b.head, "BOTTOMLEFT", 0, -3)
    b.title:SetWidth(BANNER_W - 24)
    b.title:SetWordWrap(false)
    b.title:SetJustifyH("LEFT")
    b:SetScript("OnClick", function(self, button)
        if button == "RightButton" then
            self.state = nil
            self:Hide()
        end
    end)
    b:SetScript("OnUpdate", function(self, dt)
        if not self.state then
            return
        end
        self.age = self.age + dt
        local a = 1
        if self.age < FADE_IN then
            a = self.age / FADE_IN
        elseif self.age > BANNER_HOLD + FADE_IN then
            a = 1 - (self.age - BANNER_HOLD - FADE_IN) / BANNER_FADE
        end
        if a <= 0 then
            self.state = nil
            self:Hide()
            return
        end
        self:SetAlpha(a)
    end)
    return b
end

-- title = the achievement; count = how many were earned at once (the banner says "3 achievements" then).
function Toast.ShowAchievement(title, count)
    ensureAnchor()
    if not banner then
        banner = buildBanner()
    end
    count = tonumber(count) or 1
    if count > 1 then
        banner.head:SetText("ACHIEVEMENTS EARNED")
        banner.title:SetText(("%d new achievements"):format(count))
    else
        banner.head:SetText("ACHIEVEMENT EARNED")
        banner.title:SetText(tostring(title or ""))
    end
    banner:ClearAllPoints()
    banner:SetPoint("TOP", anchor, "TOP", 0, -(MAX_TOASTS * (TOAST_H + GAP)) - 8)
    banner.age = 0
    banner.state = "show"
    banner:SetAlpha(0)
    banner:Show()
end

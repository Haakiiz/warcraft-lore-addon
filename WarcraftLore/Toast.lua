-- Toast.lua – on-screen "Warcraft veteran nearby!" toasts (max 3 at once, extra ones queue).
-- Click opens the lore window, right-click dismisses, shift-drag moves them.

local ADDON_NAME, ns = ...
local C = ns.Compat

local Toast = {}
ns.Toast = Toast

local TEX = "Interface\AddOns\\" .. ADDON_NAME .. "\Textures\\"
local PORTRAITS = "Interface\AddOns\\" .. ADDON_NAME .. "\Portraits\\"
local QUESTION_MARK = "Interface\Icons\INV_Misc_QuestionMark"

local TOAST_W, TOAST_H = 340, 78
local GAP = 6
local MAX_TOASTS = 3
local FADE_IN, HOLD, FADE_OUT = 0.4, 8, 0.8

local anchor
local active = {}   -- toasts on screen, top first
local queue = {}    -- waiting { npcID, entry, name }

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
    if pos and pos.point then
        anchor:SetPoint(pos.point, UIParent, pos.relativePoint or pos.point, pos.x or 0, pos.y or 0)
    else
        anchor:SetPoint("TOP", UIParent, "TOP", 0, -140)
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
    t:Hide()
    t.state = nil
    t.pool = true
    layoutToasts()
    showNext()
end

local function onUpdate(t, dt)
    if t.state == nil then
        return
    end
    t.age = t.age + dt
    local a
    if t.age < FADE_IN then
        a = t.age / FADE_IN
    elseif t.age < FADE_IN + HOLD or t:IsMouseOver() then
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
end

local pool = {}

local function build()
    local t = CreateFrame("Button", nil, UIParent)
    t:SetSize(TOAST_W, TOAST_H)
    t:SetFrameStrata("FULLSCREEN_DIALOG")
    t:EnableMouse(true)
    C.RegisterClicks(t)
    t:RegisterForDrag("LeftButton")

    t.bg = t:CreateTexture(nil, "BACKGROUND")
    t.bg:SetAllPoints()
    t.bg:SetColorTexture(0.063, 0.051, 0.094, 0.94)

    t.edges = {}
    local function edge(p1, p2, w, h)
        local e = t:CreateTexture(nil, "BORDER")
        e:SetPoint(p1)
        e:SetPoint(p2)
        if w then e:SetWidth(w) end
        if h then e:SetHeight(h) end
        t.edges[#t.edges + 1] = e
    end
    edge("TOPLEFT", "TOPRIGHT", nil, 2)
    edge("BOTTOMLEFT", "BOTTOMRIGHT", nil, 2)
    edge("TOPLEFT", "BOTTOMLEFT", 2, nil)
    edge("TOPRIGHT", "BOTTOMRIGHT", 2, nil)

    -- Turquoise vine along the top and bottom, as in the lore window.
    local vineTop = t:CreateTexture(nil, "ARTWORK")
    vineTop:SetPoint("TOPLEFT", 2, -2)
    vineTop:SetPoint("TOPRIGHT", -2, -2)
    vineTop:SetHeight(10)
    C.SetTiledTexture(vineTop, TEX .. "VineH", (TOAST_W - 4) / 40, 1)
    vineTop:SetAlpha(0.7)

    t.portrait = t:CreateTexture(nil, "ARTWORK")
    t.portrait:SetSize(52, 52)
    t.portrait:SetPoint("LEFT", 14, -4)
    C.ApplyCircleMask(t.portrait, TEX .. "CircleMask")
    t.ring = t:CreateTexture(nil, "OVERLAY")
    t.ring:SetTexture(TEX .. "RingThin")
    t.ring:SetSize(60, 60)
    t.ring:SetPoint("CENTER", t.portrait, "CENTER")

    t.title = t:CreateFontString(nil, "OVERLAY")
    C.SetFont(t.title, C.FONT_TITLE, 17, "OUTLINE")
    t.title:SetPoint("TOPLEFT", t.portrait, "TOPRIGHT", 14, 8)
    t.title:SetPoint("RIGHT", -10, 0)
    t.title:SetJustifyH("LEFT")
    t.title:SetTextColor(0.83, 0.78, 0.97)
    t.title:SetText("Warcraft veteran nearby!")

    t.name = t:CreateFontString(nil, "OVERLAY")
    C.SetFont(t.name, C.FONT_BODY, 13)
    t.name:SetPoint("TOPLEFT", t.title, "BOTTOMLEFT", 0, -5)
    t.name:SetPoint("RIGHT", -10, 0)
    t.name:SetJustifyH("LEFT")
    t.name:SetWordWrap(false)
    t.name:SetTextColor(0.85, 0.82, 0.76)

    t.games = t:CreateFontString(nil, "OVERLAY")
    C.SetFont(t.games, C.FONT_BODY, 12)
    t.games:SetPoint("TOPLEFT", t.name, "BOTTOMLEFT", 0, -3)
    t.games:SetJustifyH("LEFT")

    t.hint = t:CreateFontString(nil, "OVERLAY")
    C.SetFont(t.hint, C.FONT_BODY, 9)
    t.hint:SetPoint("BOTTOMRIGHT", -8, 5)
    t.hint:SetTextColor(0.65, 0.62, 0.54)
    t.hint:SetText("click: story  |  right-click: dismiss")

    t:SetScript("OnClick", function(self, button)
        if button == "RightButton" then
            dismiss(self)
        elseif self.npcID then
            ns.UI.ShowEntry(self.npcID, self.entry, nil)
            dismiss(self)
        end
    end)
    t:SetScript("OnDragStart", function()
        if IsShiftKeyDown() then
            anchor:StartMoving()
        end
    end)
    t:SetScript("OnDragStop", function()
        anchor:StopMovingOrSizing()
        savePosition()
    end)
    t:SetScript("OnUpdate", onUpdate)
    return t
end

local function display(npcID, entry, name)
    ensureAnchor()
    local t
    for i, v in ipairs(pool) do
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
    for _, e in ipairs(t.edges) do
        e:SetColorTexture(r, g, b, 1)
    end
    t.ring:SetVertexColor(r, g, b)
    t.name:SetText(name or entry.name or "?")
    t.games:SetText(ns.GamesLabel(entry))

    t.portrait:SetTexCoord(0, 1, 0, 1)
    if entry.portrait and entry.portrait ~= "" then
        t.portrait:SetTexture(PORTRAITS .. entry.portrait)
    else
        t.portrait:SetTexture(QUESTION_MARK)
        t.portrait:SetTexCoord(0.08, 0.92, 0.08, 0.92)
    end

    t:SetAlpha(0)
    t:Show()
    active[#active + 1] = t
    layoutToasts()
end

showNext = function()
    while #active < MAX_TOASTS and #queue > 0 do
        local q = table.remove(queue, 1)
        display(q.npcID, q.entry, q.name)
    end
end

function Toast.Show(npcID, entry, name)
    queue[#queue + 1] = { npcID = npcID, entry = entry, name = name }
    showNext()
end

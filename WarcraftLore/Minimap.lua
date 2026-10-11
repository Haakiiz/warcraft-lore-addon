-- Minimap.lua – the round minimap button: left-click opens the Veterans list, right-click the
-- story of your target, drag moves it around the minimap edge. /wcl minimap shows or hides it.
-- No libraries (LibDBIcon etc.): a plain button on the Minimap frame.

local ADDON_NAME, ns = ...
local C = ns.Compat
local L = ns.L

local MM = {}              -- not "Minimap": that is the game's minimap frame
ns.Minimap = MM

local S = ns.Style
local COL = S.COL

local TEX = "Interface\\AddOns\\" .. ADDON_NAME .. "\\Textures\\"
local ICON = "Interface\\Icons\\INV_Misc_Book_09"
local FALLBACK_ICON = "Interface\\Icons\\INV_Misc_QuestionMark"

local SIZE = 34
local DEFAULT_ANGLE = 225     -- degrees; 0 = right, 90 = up (lower left, away from the clock and tracking buttons)
local CLICK_GRACE = 0.2       -- seconds after a drag in which a mouse-up does not count as a click

local button, glow
local dragging = false
local lastDragEnd = -1

-- WarcraftLoreDB.minimap = { angle = degrees, hide = true/nil }; a damaged value is replaced.
local function settings()
    if type(WarcraftLoreDB.minimap) ~= "table" then
        WarcraftLoreDB.minimap = {}
    end
    return WarcraftLoreDB.minimap
end

local function place()
    local x, y = C.MinimapEdgeOffset(tonumber(settings().angle) or DEFAULT_ANGLE)
    button:ClearAllPoints()
    if x then
        button:SetPoint("CENTER", C.GetMinimap(), "CENTER", x, y)
    else
        button:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT", -190, -24) -- no minimap in this client
    end
end

local function showTooltip()
    local _, overall = ns.MetCounts()
    local t, m, v, x = COL.title, COL.muted, S.HEX_VIOLET, COL.text
    C.ShowTooltip(button, "ANCHOR_LEFT", {
        { L["Warcraft Lore"], t[1], t[2], t[3] },
        { L["Veterans met: %s%d%s of %d"]:format(S.HEX_MET, overall.met, S.END, overall.total), m[1], m[2], m[3] },
        { " ", 1, 1, 1 },
        { v .. L["Left-click"] .. S.END .. "  " .. L["Veterans list"], x[1], x[2], x[3] },
        { v .. L["Right-click"] .. S.END .. "  " .. L["Story of your target"], x[1], x[2], x[3] },
        { v .. L["Drag"] .. S.END .. "  " .. L["Move around the minimap"], x[1], x[2], x[3] },
    })
end

local function onDragUpdate()
    local angle = C.MinimapCursorAngle()
    if angle then
        settings().angle = angle
        place()
    end
end

local function build()
    button = CreateFrame("Button", nil, C.GetMinimap() or UIParent)
    button:SetSize(SIZE, SIZE)
    button:SetFrameStrata("MEDIUM")
    button:SetFrameLevel((button:GetParent():GetFrameLevel() or 0) + 8)
    button:RegisterForDrag("LeftButton")
    C.RegisterClicks(button)

    -- Soft lavender glow, only while the mouse is over the button.
    glow = button:CreateTexture(nil, "BACKGROUND")
    glow:SetTexture(TEX .. "RingGlow")
    glow:SetSize(46, 46)
    glow:SetPoint("CENTER")
    glow:SetVertexColor(COL.title[1], COL.title[2], COL.title[3])
    glow:Hide()

    local icon = button:CreateTexture(nil, "ARTWORK")
    icon:SetSize(22, 22)
    icon:SetPoint("CENTER")
    C.SetIconTexture(icon, ICON, FALLBACK_ICON)
    icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
    C.ApplyCircleMask(icon, TEX .. "CircleMask")

    local ring = button:CreateTexture(nil, "OVERLAY")
    ring:SetTexture(TEX .. "RingThin")
    ring:SetSize(SIZE, SIZE)
    ring:SetPoint("CENTER")
    ring:SetVertexColor(COL.violet[1], COL.violet[2], COL.violet[3])

    button:SetScript("OnEnter", function()
        glow:Show()
        if not dragging then
            showTooltip()
        end
    end)
    button:SetScript("OnLeave", function()
        glow:Hide()
        C.HideTooltip()
    end)
    button:SetScript("OnDragStart", function()
        dragging = true
        C.HideTooltip()
        button:SetScript("OnUpdate", onDragUpdate)
    end)
    button:SetScript("OnDragStop", function()
        dragging = false
        lastDragEnd = C.Now()
        button:SetScript("OnUpdate", nil)
    end)
    button:SetScript("OnClick", function(_, mouseButton)
        if dragging or C.Now() - lastDragEnd < CLICK_GRACE then
            return
        end
        if mouseButton == "RightButton" then
            ns.ShowTarget()
        else
            ns.Browser.Toggle()
        end
    end)
    place()
end

function MM.Init()
    if button then
        return
    end
    build()
    if settings().hide then
        button:Hide()
    end
end

-- /wcl minimap. Returns true when the button is shown afterwards.
function MM.Toggle()
    MM.Init()
    if settings().hide then
        settings().hide = nil
        button:Show()
        return true
    end
    settings().hide = true
    button:Hide()
    C.HideTooltip()
    return false
end

-- MapPins.lua – small round pins on the world map for the veterans of the zone you are looking at.
-- Colored by the veteran's first game; a green ring and dot once met. Hover for the name and
-- status, click for the story. No libraries: pins are plain buttons on the map canvas, pooled
-- and re-laid out only when the map changes, is shown or is zoomed. Option: WarcraftLoreDB.mapPins
-- (nil/true = on, false = off), set from the settings page.

local ADDON_NAME, ns = ...
local C = ns.Compat
local S = ns.Style
local COL = S.COL

local MP = {}
ns.MapPins = MP

local TEX = "Interface\\AddOns\\" .. ADDON_NAME .. "\\Textures\\"
local PIN_SIZE = 13

local holder, canvas, hooked
local pins = {}          -- the pool; pins[i] is reused for the i-th veteran on the map
local shown = 0
local byMap              -- uiMapID -> list of { group, x, y } (x, y in percent), built on first use

local function guarded(key, label, fn)
    return ns.Guard and ns.Guard(key, label, fn) or fn
end

function MP.Enabled()
    return not (type(WarcraftLoreDB) == "table" and WarcraftLoreDB.mapPins == false)
end

local function buildIndex()
    byMap = {}
    local zoneMaps = ns.ZONE_MAPS or {}
    for _, g in ipairs(ns.Veterans()) do
        local entry = g.entry
        local x, y = tostring(entry.coords or ""):match("^%s*([%d%.]+)%s*,%s*([%d%.]+)")
        x, y = tonumber(x), tonumber(y)
        local maps = zoneMaps[entry.zone]
        if x and y and maps then
            for _, mapID in ipairs(maps) do
                byMap[mapID] = byMap[mapID] or {}
                table.insert(byMap[mapID], { g, x, y })
            end
        end
    end
end

local function showTooltip(pin)
    local g = pin.group
    if not g then
        return
    end
    local t, m, x = COL.title, COL.muted, COL.text
    local met = ns.MetSummary and ns.MetSummary(g.id)
    local lines = {
        { g.entry.name or "?", t[1], t[2], t[3] },
        { ns.CodesLabel(g.codes), x[1], x[2], x[3] },
    }
    if met then
        lines[#lines + 1] = { met, COL.met[1], COL.met[2], COL.met[3] }
    else
        lines[#lines + 1] = { "Not met yet", m[1], m[2], m[3] }
    end
    lines[#lines + 1] = { "Click to read the story", m[1], m[2], m[3] }
    C.ShowTooltip(pin, "ANCHOR_RIGHT", lines)
end

local function newPin()
    local pin = CreateFrame("Button", nil, holder)
    pin:SetSize(PIN_SIZE, PIN_SIZE)
    C.RegisterClicks(pin)

    pin.fill = S.solid(pin, "ARTWORK", COL.violet)
    pin.fill:SetAllPoints()
    C.ApplyCircleMask(pin.fill, TEX .. "CircleMask")

    pin.ring = pin:CreateTexture(nil, "OVERLAY")
    pin.ring:SetTexture(TEX .. "RingThin")
    pin.ring:SetAllPoints()

    -- A small green dot in the corner says "met".
    pin.tick = S.solid(pin, "OVERLAY", COL.met)
    pin.tick:SetSize(6, 6)
    pin.tick:SetPoint("TOPRIGHT", 2, 2)
    C.ApplyCircleMask(pin.tick, TEX .. "CircleMask")

    pin:SetScript("OnEnter", guarded("mappins", "the world map pins", function() showTooltip(pin) end))
    pin:SetScript("OnLeave", C.HideTooltip)
    pin:SetScript("OnClick", guarded("mappins", "the world map pins", function()
        local g = pin.group
        if g and ns.UI and ns.UI.ShowEntry then
            ns.UI.ShowEntry(g.id, g.entry)
        end
    end))
    return pin
end

local function stylePin(pin, g)
    pin.group = g
    local met = ns.GroupMet and ns.GroupMet(g) or false
    pin.met = met and true or false
    local r, gr, b = ns.GameRGB(g.codes[1])
    pin.fill:SetVertexColor(r, gr, b)
    pin.fill:SetAlpha(met and 1 or 0.7)
    local ring = met and COL.met or COL.violet
    pin.ring:SetVertexColor(ring[1], ring[2], ring[3])
    pin.tick:SetShown(met and true or false)
end

local function hideAll()
    for i = 1, shown do
        pins[i].group = nil
        pins[i]:Hide()
    end
    shown = 0
end

local function layout()
    if not (holder and canvas) then
        return
    end
    hideAll()
    if not MP.Enabled() then
        return
    end
    local mapID = WorldMapFrame:GetMapID()
    if not byMap then
        buildIndex()
    end
    local list = mapID and byMap[mapID]
    if not list then
        return
    end
    local w, h = canvas:GetWidth(), canvas:GetHeight()
    if not (w and h and w > 0 and h > 0) then
        return
    end
    -- Keep the pins the same size on screen however far the map is zoomed.
    local scale = canvas:GetScale()
    local s = (scale and scale > 0) and 1 / scale or 1
    for i, item in ipairs(list) do
        local pin = pins[i]
        if not pin then
            pin = newPin()
            pins[i] = pin
        end
        pin:SetScale(s)
        pin:ClearAllPoints()
        pin:SetPoint("CENTER", holder, "TOPLEFT", item[2] / 100 * w / s, -item[3] / 100 * h / s)
        stylePin(pin, item[1])
        pin:Show()
    end
    shown = #list
end

local function refresh()
    local wm = rawget(_G, "WorldMapFrame")
    if wm and wm.IsShown and not wm:IsShown() then
        return -- laid out again when the map is opened
    end
    layout()
end
local guardedRefresh = guarded("mappins", "the world map pins", refresh)

local function setup()
    local wm = rawget(_G, "WorldMapFrame")
    if hooked or type(wm) ~= "table" then
        return -- no world map (yet): nothing to do
    end
    canvas = wm.GetCanvas and select(2, pcall(wm.GetCanvas, wm))
    if type(canvas) ~= "table" then
        canvas = wm.ScrollContainer and wm.ScrollContainer.Child
    end
    if type(canvas) ~= "table" then
        error("no map canvas")
    end
    holder = CreateFrame("Frame", nil, canvas)
    holder:SetAllPoints(canvas)
    holder:SetFrameLevel((canvas:GetFrameLevel() or 0) + 100)

    local hooks = 0
    local function try(fn)
        if pcall(fn) then
            hooks = hooks + 1
        end
    end
    try(function() hooksecurefunc(wm, "OnMapChanged", guardedRefresh) end)
    try(function() hooksecurefunc(wm, "OnCanvasScaleChanged", guardedRefresh) end)
    try(function() wm:HookScript("OnShow", guardedRefresh) end)
    try(function() canvas:HookScript("OnSizeChanged", guardedRefresh) end)
    if hooks == 0 then
        error("no map hooks")
    end
    hooked = true
    refresh()
end
local guardedSetup = guarded("mappins", "the world map pins", setup)

-- Called by the settings checkbox.
function MP.Refresh()
    if hooked then
        guardedRefresh()
    end
end

function MP.Init()
    guardedSetup()
end

-- The pins currently on the map (for tests): list of { frame, group, met }.
function MP.Active()
    local out = {}
    for i = 1, shown do
        out[i] = { frame = pins[i], group = pins[i].group, met = pins[i].met }
    end
    return out
end

-- The world map may load later than this addon (Blizzard_WorldMap), so also wait for it.
local loader = CreateFrame("Frame")
C.RegisterEventSafe(loader, "PLAYER_LOGIN")
C.RegisterEventSafe(loader, "ADDON_LOADED")
loader:SetScript("OnEvent", function(self, event, name)
    if event == "ADDON_LOADED" and name ~= "Blizzard_WorldMap" then
        return
    end
    MP.Init()
    if hooked then
        self:UnregisterAllEvents()
    end
end)

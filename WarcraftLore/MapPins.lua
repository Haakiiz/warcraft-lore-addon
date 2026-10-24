-- MapPins.lua – small round pins on the world map for the veterans of the zone you are looking at
-- (and small stone-colored squares for its memorials).
-- Colored by the veteran's first game; a green ring and dot once met. Hover for the name and
-- status, click for the story. No libraries: pins are plain buttons on the map canvas, pooled
-- and re-laid out only when the map changes, is shown or is zoomed. Option: WarcraftLoreDB.mapPins
-- (nil/true = on, false = off), set from the settings page.

local ADDON_NAME, ns = ...
local C = ns.Compat
local L = ns.L
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
    -- Memorials (Memorials.lua) get a pin of their own kind on the map of their zone.
    -- A book (kind "book") stands in several places: one pin for each of its locations.
    for _, m in ipairs(ns.MemorialList and ns.MemorialList() or {}) do
        local entry = m.entry
        local spots = type(entry.locations) == "table" and #entry.locations > 0 and entry.locations
            or { { zone = entry.zone, coords = entry.coords } }
        for _, spot in ipairs(spots) do
            local x, y = tostring(spot.coords or ""):match("^%s*([%d%.]+)%s*,%s*([%d%.]+)")
            x, y = tonumber(x), tonumber(y)
            local maps = zoneMaps[spot.zone]
            if x and y and maps then
                for _, mapID in ipairs(maps) do
                    byMap[mapID] = byMap[mapID] or {}
                    table.insert(byMap[mapID], { m, x, y })
                end
            end
        end
    end
end

-- A veteran group counts as met, a memorial item as visited.
local function isMet(g)
    if g.memorial then
        return ns.IsVisited ~= nil and ns.IsVisited(g.key) == true
    end
    return ns.GroupMet ~= nil and ns.GroupMet(g) or false
end

local function showTooltip(pin)
    local g = pin.group
    if not g then
        return
    end
    local t, m, x = COL.title, COL.muted, COL.text
    if g.memorial then
        local visit = isMet(g) and ns.VisitSummary and ns.VisitSummary(g.key)
        C.ShowTooltip(pin, "ANCHOR_RIGHT", {
            { g.entry.name or "?", t[1], t[2], t[3] },
            { L["Honors %s"]:format(table.concat(g.entry.honors or {}, ", ")), x[1], x[2], x[3] },
            { ns.CodesLabel(g.codes), x[1], x[2], x[3] },
            visit and { visit, COL.met[1], COL.met[2], COL.met[3] } or { L["Not visited yet"], m[1], m[2], m[3] },
            { L["Click to read the story"], m[1], m[2], m[3] },
        })
        return
    end
    local met = ns.MetSummary and ns.MetSummary(g.id)
    local lines = {
        { g.entry.name or "?", t[1], t[2], t[3] },
        { ns.CodesLabel(g.codes), x[1], x[2], x[3] },
    }
    if met then
        lines[#lines + 1] = { met, COL.met[1], COL.met[2], COL.met[3] }
    else
        lines[#lines + 1] = { L["Not met yet"], m[1], m[2], m[3] }
    end
    lines[#lines + 1] = { L["Click to read the story"], m[1], m[2], m[3] }
    C.ShowTooltip(pin, "ANCHOR_RIGHT", lines)
end

local function newPin()
    local pin = CreateFrame("Button", nil, holder)
    pin:SetSize(PIN_SIZE, PIN_SIZE)
    C.RegisterClicks(pin)
    -- Left click only, so a right-click passes through to the map (zoom out works over a pin).
    if pin.RegisterForClicks then
        pcall(pin.RegisterForClicks, pin, "LeftButtonUp")
    end

    pin.fill = S.solid(pin, "ARTWORK", COL.violet)
    pin.fill:SetAllPoints()
    C.ApplyCircleMask(pin.fill, TEX .. "CircleMask")

    -- Memorials look like a small stone block: a square in stone grey with a one pixel edge.
    pin.stoneEdge = S.solid(pin, "ARTWORK", COL.violet)
    pin.stoneEdge:SetAllPoints()
    pin.stone = S.solid(pin, "OVERLAY", COL.stone)
    pin.stone:SetPoint("TOPLEFT", 2, -2)
    pin.stone:SetPoint("BOTTOMRIGHT", -2, 2)

    pin.ring = pin:CreateTexture(nil, "OVERLAY")
    pin.ring:SetTexture(TEX .. "RingThin")
    pin.ring:SetAllPoints()

    -- A small green dot in the corner says "met".
    pin.tick = S.solid(pin, "OVERLAY", COL.met)
    pin.tick:SetSize(6, 6)
    pin.tick:SetPoint("TOPRIGHT", 2, 2)
    C.ApplyCircleMask(pin.tick, TEX .. "CircleMask")

    pin:SetScript("OnEnter", guarded("mappins", L["the world map pins"], function() showTooltip(pin) end))
    pin:SetScript("OnLeave", C.HideTooltip)
    pin:SetScript("OnClick", guarded("mappins", L["the world map pins"], function(_, button)
        if button and button ~= "LeftButton" then
            return -- only a left click opens the story
        end
        local g = pin.group
        if g and g.memorial and ns.UI and ns.UI.ShowMemorial then
            C.HideTooltip()
            ns.UI.ShowMemorial(g.key, nil, nil, true) -- raised above the world map
        elseif g and ns.UI and ns.UI.ShowEntry then
            C.HideTooltip()
            ns.UI.ShowEntry(g.id, g.entry, nil, nil, nil, true) -- raised above the world map
        end
    end))
    return pin
end

local function stylePin(pin, g)
    pin.group = g
    local met = isMet(g)
    pin.met = met and true or false
    local ring = met and COL.met or COL.violet
    local mem = g.memorial == true
    pin.fill:SetShown(not mem)
    pin.ring:SetShown(not mem)
    pin.stone:SetShown(mem)
    pin.stoneEdge:SetShown(mem)
    if mem then
        pin.stoneEdge:SetColorTexture(ring[1], ring[2], ring[3], 1)
        pin.stone:SetAlpha(met and 1 or 0.75)
    else
        local r, gr, b = ns.GameRGB(g.codes[1])
        pin.fill:SetVertexColor(r, gr, b)
        pin.fill:SetAlpha(met and 1 or 0.7)
        pin.ring:SetVertexColor(ring[1], ring[2], ring[3])
    end
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
local guardedRefresh = guarded("mappins", L["the world map pins"], refresh)

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
    -- The map closing puts a raised lore window back to its normal level.
    try(function()
        wm:HookScript("OnHide", function()
            if ns.UI and ns.UI.LowerWindow then
                pcall(ns.UI.LowerWindow)
            end
        end)
    end)
    try(function() canvas:HookScript("OnSizeChanged", guardedRefresh) end)
    if hooks == 0 then
        error("no map hooks")
    end
    hooked = true
    refresh()
end
local guardedSetup = guarded("mappins", L["the world map pins"], setup)

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

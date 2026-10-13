-- Style.lua – the look shared by every window: palette, small builders, the frame, the header band,
-- and the two themes. "wc2" (the default) is a Warcraft II remaster: stone frame, cracked leather,
-- dark inset panels, red buttons and gold text. "classic" is the violet frame with turquoise vines.
-- The theme is read once after the saved settings load (Style.ApplyTheme, called from Core.lua);
-- switching asks for a UI reload, because the windows are drawn once with the theme's art.

local ADDON_NAME, ns = ...
local C = ns.Compat
local L = ns.L

local Style = {}
ns.Style = Style

local TEX = "Interface\\AddOns\\" .. ADDON_NAME .. "\\Textures\\"

Style.BAND = 20            -- width of the band around a window (vines, or stone + leather)
Style.PAD = 12             -- inner padding
Style.HEADER = 26          -- height of the title band
local VINE_TILE = 80       -- on-screen length of one vine tile (128x32 texture shown 20 px high)
local STONE = 10           -- width of the WC2 stone frame
local LEATHER_TILE, STONE_TILE = 256, 128

local BAND, PAD, HEADER = Style.BAND, Style.PAD, Style.HEADER

function Style.rgb(hex)
    return tonumber(hex:sub(1, 2), 16) / 255, tonumber(hex:sub(3, 4), 16) / 255, tonumber(hex:sub(5, 6), 16) / 255
end
local rgb = Style.rgb

-- The palette per theme. Every window reads Style.COL, so ApplyTheme changes the values inside these
-- tables (never the tables themselves): a window file that kept a reference sees the new colors.
local PALETTES = {
    classic = {
        outer = "120f1c", inner = "100d18", header = "181226",
        headerLine = "3d2a78", violet = "8b6cd6", teal = "2a6f68",
        title = "d4c6f7", text = "d9d2c3", muted = "a79d8a",
        divider = "2d2347", dim = "4d4434",
        met = "6fcf7f", gold = "e0b84a", hollow = "6b5f4a", stone = "9e9689",
    },
    wc2 = {
        outer = "1a0f06", inner = "120a04", header = "6b140c",
        headerLine = "8a7f68", violet = "e8c547", teal = "7c1a10",
        title = "f2d36b", text = "e6dcc4", muted = "b9ab8e",
        divider = "3b2a14", dim = "5c4a30",
        met = "4cb84c", gold = "e8c547", hollow = "6b5f4a", stone = "9a8f78",
    },
}
local HEXES = {
    classic = { MUTED = "a79d8a", TITLE = "d4c6f7", MET = "6fcf7f", VIOLET = "8b6cd6", GOLD = "e0b84a" },
    wc2 = { MUTED = "b9ab8e", TITLE = "f2d36b", MET = "4cb84c", VIOLET = "e8c547", GOLD = "e8c547" },
}
Style.DEFAULT_THEME = "wc2"

local COL = {}
Style.COL = COL
Style.END = "|r"

-- Sets the palette and the color codes for a theme ("wc2" or "classic"; anything else means the
-- default). Safe to call more than once; returns the theme in use.
function Style.ApplyTheme(name)
    if not PALETTES[name] then
        name = Style.DEFAULT_THEME
    end
    Style.theme = name
    for key, hex in pairs(PALETTES[name]) do
        local c = COL[key] or {}
        c[1], c[2], c[3] = rgb(hex)
        COL[key] = c
    end
    for key, hex in pairs(HEXES[name]) do
        Style["HEX_" .. key] = "|cff" .. hex
    end
    return name
end
Style.ApplyTheme(Style.DEFAULT_THEME) -- until the saved settings are loaded

function Style.IsWC2()
    return Style.theme == "wc2"
end

-- The other theme, for the switch buttons.
function Style.OtherTheme()
    return Style.theme == "wc2" and "classic" or "wc2"
end

function Style.ThemeLabel(name)
    return name == "wc2" and L["Warcraft II look"] or L["Classic look"]
end

-- Saves the chosen theme and reloads the interface, after a confirmation where the client has one.
function Style.RequestTheme(name)
    if not PALETTES[name] or type(WarcraftLoreDB) ~= "table" then
        return false
    end
    local function apply()
        WarcraftLoreDB.theme = name
        if ReloadUI then
            ReloadUI()
        end
    end
    if type(StaticPopupDialogs) == "table" and StaticPopup_Show then
        StaticPopupDialogs["WARCRAFTLORE_THEME"] = {
            text = L["Switch Warcraft Lore to the %s? This reloads the interface."]:format(Style.ThemeLabel(name)),
            button1 = L["Reload"],
            button2 = L["Cancel"],
            OnAccept = apply,
            timeout = 0,
            whileDead = true,
            hideOnEscape = true,
        }
        StaticPopup_Show("WARCRAFTLORE_THEME")
    else
        apply()
    end
    return true
end

-------------------------------------------------------------------- small builders
function Style.solid(parent, layer, c, a)
    local t = parent:CreateTexture(nil, layer)
    t:SetColorTexture(c[1], c[2], c[3], a or 1)
    return t
end
local solid = Style.solid

function Style.text(parent, font, size, c)
    local fs = parent:CreateFontString(nil, "OVERLAY")
    C.SetFont(fs, font, size)
    fs:SetJustifyH("LEFT")
    fs:SetJustifyV("TOP")
    if c then
        fs:SetTextColor(c[1], c[2], c[3])
    end
    return fs
end
local text = Style.text

-- Four textures forming a rectangle outline, `inset` px inside the parent.
function Style.outline(parent, inset, thickness, c, layer)
    local t = solid(parent, layer, c); t:SetPoint("TOPLEFT", inset, -inset); t:SetPoint("TOPRIGHT", -inset, -inset); t:SetHeight(thickness)
    local b = solid(parent, layer, c); b:SetPoint("BOTTOMLEFT", inset, inset); b:SetPoint("BOTTOMRIGHT", -inset, inset); b:SetHeight(thickness)
    local l = solid(parent, layer, c); l:SetPoint("TOPLEFT", inset, -inset); l:SetPoint("BOTTOMLEFT", inset, inset); l:SetWidth(thickness)
    local r = solid(parent, layer, c); r:SetPoint("TOPRIGHT", -inset, -inset); r:SetPoint("BOTTOMRIGHT", -inset, inset); r:SetWidth(thickness)
    return { t, b, l, r }
end
local outline = Style.outline

-- A frame with a flat background and a 1 px border whose colors can change.
-- frameType is optional ("Button" for something clickable; the default is "Frame").
-- In the WC2 theme the box is an inset panel: a dark base under the fill (so a faint tint never shows
-- the leather through), a shadow edge on top and left, and the edge color on the bottom and right.
-- `flat` keeps one color on all four edges (the small game badges).
function Style.box(parent, frameType, flat)
    local f = CreateFrame(frameType or "Frame", nil, parent)
    local wc2 = Style.IsWC2()
    if wc2 then
        f.base = solid(f, "BACKGROUND", { rgb("0e0904") }, 0.85)
        f.base:SetAllPoints()
        f.base:SetDrawLayer("BACKGROUND", -2)
    end
    f.bg = solid(f, "BACKGROUND", COL.inner)
    f.bg:SetAllPoints()
    f.edges = outline(f, 0, 1, COL.violet, "BORDER")
    local bevel = wc2 and not flat
    function f:SetColors(fill, fillAlpha, edge, edgeAlpha)
        self.bg:SetColorTexture(fill[1], fill[2], fill[3], fillAlpha)
        for i, e in ipairs(self.edges) do
            if bevel and (i == 1 or i == 3) then -- top, left
                e:SetColorTexture(0, 0, 0, 0.85)
            else
                e:SetColorTexture(edge[1], edge[2], edge[3], edgeAlpha)
            end
        end
    end
    return f
end
local box = Style.box

function Style.badge(parent, frameType)
    local b = box(parent, frameType, true)
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

-------------------------------------------------------------------- frame art: classic
-- Violet outer lines, turquoise vines along all four edges, rosettes in the corners,
-- for a frame of w x h.
local function classicFrameArt(f, w, h)
    local bg = solid(f, "BACKGROUND", COL.outer)
    bg:SetAllPoints()
    outline(f, 0, 3, COL.violet, "BORDER")
    outline(f, 6, 1, COL.teal, "BORDER")

    local half = BAND / 2
    local spanH, spanV = w - 2 * 24, h - 2 * 24
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

-- The dark panel inside the vine band. Returns it.
local function classicInner(f)
    local inner = CreateFrame("Frame", nil, f)
    inner:SetPoint("TOPLEFT", BAND, -BAND)
    inner:SetPoint("BOTTOMRIGHT", -BAND, BAND)
    local ibg = solid(inner, "BACKGROUND", COL.inner)
    ibg:SetAllPoints()
    outline(inner, 0, 1, COL.violet, "BORDER")
    return inner
end

-- Title band with the window title and a close X that calls onClose.
local function classicHeader(inner, titleText, onClose)
    local band = solid(inner, "BORDER", COL.header)
    band:SetPoint("TOPLEFT"); band:SetPoint("TOPRIGHT"); band:SetHeight(HEADER)
    local line = solid(inner, "BORDER", COL.headerLine)
    line:SetPoint("TOPLEFT", 0, -HEADER); line:SetPoint("TOPRIGHT", 0, -HEADER); line:SetHeight(1)

    local title = text(inner, C.FONT_TITLE, 14, COL.title)
    title:SetPoint("LEFT", inner, "TOPLEFT", PAD, -HEADER / 2)
    title:SetJustifyV("MIDDLE")
    title:SetText(titleText)

    local close = CreateFrame("Button", nil, inner)
    close:SetSize(22, 18)
    close:SetPoint("RIGHT", inner, "TOPRIGHT", -PAD + 4, -HEADER / 2)
    local edges = outline(close, 0, 1, COL.headerLine, "BORDER")
    local x = text(close, C.FONT_BODY, 12, COL.violet)
    x:SetPoint("CENTER", 0, 0)
    x:SetText("X")
    C.RegisterClicks(close)
    close:SetScript("OnClick", onClose)
    close:SetScript("OnEnter", function()
        x:SetTextColor(COL.title[1], COL.title[2], COL.title[3])
        for _, e in ipairs(edges) do e:SetColorTexture(COL.violet[1], COL.violet[2], COL.violet[3], 1) end
    end)
    close:SetScript("OnLeave", function()
        x:SetTextColor(COL.violet[1], COL.violet[2], COL.violet[3])
        for _, e in ipairs(edges) do e:SetColorTexture(COL.headerLine[1], COL.headerLine[2], COL.headerLine[3], 1) end
    end)
    return close, title
end

-------------------------------------------------------------------- frame art: Warcraft II
local WC2_LIGHT, WC2_SHADOW = { rgb("d8cfb8") }, { rgb("5c5446") }
local WC2_RIM, WC2_INSET = { rgb("0e0904") }, { rgb("b8ad94") }
local RED, RED_HOVER = { rgb("6b140c") }, { rgb("7c1a10") }
local RED_LIGHT, RED_DARK = { rgb("b2483a") }, { rgb("2a0503") }

-- A raised dark-red WC2 button with a gold label; the bevel flips while it is pressed.
function Style.redButton(parent, w, h, label, size)
    local b = CreateFrame("Button", nil, parent)
    b:SetSize(w, h)
    b.face = solid(b, "BACKGROUND", RED)
    b.face:SetAllPoints()
    b.lines = outline(b, 0, 1, RED_LIGHT, "BORDER") -- top, bottom, left, right
    b.label = text(b, C.FONT_BODY, size or 11, COL.gold)
    b.label:SetPoint("CENTER", 0, 0)
    b.label:SetJustifyH("CENTER")
    b.label:SetJustifyV("MIDDLE")
    b.label:SetText(label or "")
    local function paint(down)
        local top, bottom = down and RED_DARK or RED_LIGHT, down and RED_LIGHT or RED_DARK
        for i, e in ipairs(b.lines) do
            local c = (i == 1 or i == 3) and top or bottom
            e:SetColorTexture(c[1], c[2], c[3], 1)
        end
        b.label:ClearAllPoints()
        b.label:SetPoint("CENTER", down and 1 or 0, down and -1 or 0)
    end
    paint(false)
    b:SetScript("OnMouseDown", function() paint(true) end)
    b:SetScript("OnMouseUp", function() paint(false) end)
    b:SetScript("OnEnter", function() b.face:SetColorTexture(RED_HOVER[1], RED_HOVER[2], RED_HOVER[3], 1) end)
    b:SetScript("OnLeave", function()
        b.face:SetColorTexture(RED[1], RED[2], RED[3], 1)
        paint(false)
    end)
    C.RegisterClicks(b)
    return b
end

-- Cracked leather over the whole window, a 10 px stone frame with a light top-left and a dark
-- bottom-right bevel, a dark rim outside and a dark lip where the stone meets the leather.
local function wc2FrameArt(f, w, h)
    local leather = f:CreateTexture(nil, "BACKGROUND")
    leather:SetAllPoints()
    C.SetTiledTexture(leather, TEX .. "WC2Leather", w / LEATHER_TILE, h / LEATHER_TILE)

    local function stone(p1, x1, y1, p2, x2, y2, tilesU, tilesV)
        local t = f:CreateTexture(nil, "BORDER")
        t:SetPoint(p1, x1, y1)
        t:SetPoint(p2, x2, y2)
        C.SetTiledTexture(t, TEX .. "WC2Stone", tilesU, tilesV)
        return t
    end
    local side = (h - 2 * STONE) / STONE_TILE
    stone("TOPLEFT", 0, 0, "TOPRIGHT", 0, 0, w / STONE_TILE, STONE / STONE_TILE):SetHeight(STONE)
    stone("BOTTOMLEFT", 0, 0, "BOTTOMRIGHT", 0, 0, w / STONE_TILE, STONE / STONE_TILE):SetHeight(STONE)
    stone("TOPLEFT", 0, -STONE, "BOTTOMLEFT", 0, STONE, STONE / STONE_TILE, side):SetWidth(STONE)
    stone("TOPRIGHT", 0, -STONE, "BOTTOMRIGHT", 0, STONE, STONE / STONE_TILE, side):SetWidth(STONE)

    local function line(c, p1, x1, y1, p2, x2, y2, wd, ht)
        local t = solid(f, "ARTWORK", c)
        t:SetPoint(p1, x1, y1)
        t:SetPoint(p2, x2, y2)
        if wd then t:SetWidth(wd) end
        if ht then t:SetHeight(ht) end
    end
    line(WC2_LIGHT, "TOPLEFT", 1, -1, "TOPRIGHT", -1, -1, nil, 2)
    line(WC2_LIGHT, "TOPLEFT", 1, -1, "BOTTOMLEFT", 1, 1, 2, nil)
    line(WC2_SHADOW, "BOTTOMLEFT", 1, 1, "BOTTOMRIGHT", -1, 1, nil, 2)
    line(WC2_SHADOW, "TOPRIGHT", -1, -1, "BOTTOMRIGHT", -1, 1, 2, nil)
    outline(f, 0, 1, WC2_RIM, "OVERLAY")
    outline(f, STONE, 1, WC2_RIM, "OVERLAY")
end

-- The content area: the leather darkened enough for text, with an inset edge.
local function wc2Inner(f)
    local inner = CreateFrame("Frame", nil, f)
    inner:SetPoint("TOPLEFT", BAND, -BAND)
    inner:SetPoint("BOTTOMRIGHT", -BAND, BAND)
    local shade = solid(inner, "BACKGROUND", WC2_RIM, 0.5)
    shade:SetAllPoints()
    local edges = outline(inner, 0, 1, WC2_INSET, "BORDER")
    edges[1]:SetColorTexture(0, 0, 0, 0.85) -- top
    edges[3]:SetColorTexture(0, 0, 0, 0.85) -- left
    return inner
end

-- A dark title band with a carved line under it, the title centered in gold, and a red close X.
local function wc2Header(inner, titleText, onClose)
    local band = solid(inner, "BORDER", { rgb("120a04") }, 0.92)
    band:SetPoint("TOPLEFT"); band:SetPoint("TOPRIGHT"); band:SetHeight(HEADER)
    local cut = solid(inner, "BORDER", WC2_RIM)
    cut:SetPoint("TOPLEFT", 0, -HEADER); cut:SetPoint("TOPRIGHT", 0, -HEADER); cut:SetHeight(1)
    local lit = solid(inner, "BORDER", WC2_INSET, 0.3)
    lit:SetPoint("TOPLEFT", 0, -HEADER - 1); lit:SetPoint("TOPRIGHT", 0, -HEADER - 1); lit:SetHeight(1)

    local title = text(inner, C.FONT_TITLE, 15, COL.title)
    title:SetPoint("CENTER", inner, "TOP", 0, -HEADER / 2)
    title:SetJustifyH("CENTER")
    title:SetJustifyV("MIDDLE")
    if title.SetShadowOffset then
        title:SetShadowOffset(1, -1)
        title:SetShadowColor(0, 0, 0, 1)
    end
    title:SetText(titleText)

    local close = Style.redButton(inner, 20, 18, "X", 11)
    close:SetPoint("RIGHT", inner, "TOPRIGHT", -PAD + 4, -HEADER / 2)
    close:SetScript("OnClick", onClose)
    return close, title
end

-------------------------------------------------------------------- the theme switch button
-- A small button left of the close X that switches to the other theme (after a reload prompt).
function Style.themeButton(inner, close)
    local other = Style.OtherTheme()
    local b, enter, leave
    if Style.IsWC2() then
        b = Style.redButton(inner, 56, 18, L["Classic"], 10)
        enter, leave = b:GetScript("OnEnter"), b:GetScript("OnLeave")
    else
        b = CreateFrame("Button", nil, inner)
        b:SetSize(40, 18)
        local edges = outline(b, 0, 1, COL.headerLine, "BORDER")
        local label = text(b, C.FONT_BODY, 10, COL.violet)
        label:SetPoint("CENTER", 0, 0)
        label:SetText("WC2")
        enter = function()
            label:SetTextColor(COL.title[1], COL.title[2], COL.title[3])
            for _, e in ipairs(edges) do e:SetColorTexture(COL.violet[1], COL.violet[2], COL.violet[3], 1) end
        end
        leave = function()
            label:SetTextColor(COL.violet[1], COL.violet[2], COL.violet[3])
            for _, e in ipairs(edges) do e:SetColorTexture(COL.headerLine[1], COL.headerLine[2], COL.headerLine[3], 1) end
        end
        C.RegisterClicks(b)
    end
    b:SetPoint("RIGHT", close, "LEFT", -4, 0)
    b:SetScript("OnClick", function() Style.RequestTheme(other) end)
    b:SetScript("OnEnter", function()
        if enter then enter() end
        if GameTooltip then
            GameTooltip:SetOwner(b, "ANCHOR_TOP")
            GameTooltip:SetText(L["Switch to the %s"]:format(Style.ThemeLabel(other)), 1, 1, 1)
            GameTooltip:AddLine(L["Reloads the interface. Also in the settings and with /wcl theme."], 0.8, 0.8, 0.8, true)
            GameTooltip:Show()
        end
    end)
    b:SetScript("OnLeave", function()
        if leave then leave() end
        if GameTooltip then GameTooltip:Hide() end
    end)
    return b
end

-------------------------------------------------------------------- the builders the windows call
function Style.buildFrameArt(f, w, h)
    if Style.IsWC2() then
        return wc2FrameArt(f, w, h)
    end
    return classicFrameArt(f, w, h)
end

-- The content panel inside the band. Returns it.
function Style.buildInner(f)
    return (Style.IsWC2() and wc2Inner or classicInner)(f)
end

-- Title band with the window title, a close X that calls onClose, and the theme switch button.
-- Returns the close button (with the switch button as close.themeButton) and the title.
function Style.buildHeader(inner, titleText, onClose)
    local close, title = (Style.IsWC2() and wc2Header or classicHeader)(inner, titleText, onClose)
    close.themeButton = Style.themeButton(inner, close)
    return close, title
end

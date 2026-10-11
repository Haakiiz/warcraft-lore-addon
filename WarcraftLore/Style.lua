-- Style.lua – the look shared by the lore window (UI.lua) and the browse window (Browser.lua):
-- palette, small builders, the violet frame with turquoise vines, and the header band.

local ADDON_NAME, ns = ...
local C = ns.Compat

local Style = {}
ns.Style = Style

local TEX = "Interface\\AddOns\\" .. ADDON_NAME .. "\\Textures\\"

Style.BAND = 20            -- width of the vine band around a window
Style.PAD = 12             -- inner padding
Style.HEADER = 26          -- height of the title band
local VINE_TILE = 80       -- on-screen length of one vine tile (128x32 texture shown 20 px high)

local BAND, PAD, HEADER = Style.BAND, Style.PAD, Style.HEADER

function Style.rgb(hex)
    return tonumber(hex:sub(1, 2), 16) / 255, tonumber(hex:sub(3, 4), 16) / 255, tonumber(hex:sub(5, 6), 16) / 255
end
local rgb = Style.rgb

local COL = {
    outer = { rgb("120f1c") }, inner = { rgb("100d18") }, header = { rgb("181226") },
    headerLine = { rgb("3d2a78") }, violet = { rgb("8b6cd6") }, teal = { rgb("2a6f68") },
    title = { rgb("d4c6f7") }, text = { rgb("d9d2c3") }, muted = { rgb("a79d8a") },
    divider = { rgb("2d2347") }, dim = { rgb("4d4434") },
    met = { rgb("6fcf7f") },
    gold = { rgb("e0b04a") },
    hollow = { rgb("6b5f4a") },
}
Style.COL = COL
Style.HEX_MUTED = "|cffa79d8a"
Style.HEX_TITLE = "|cffd4c6f7"
Style.HEX_MET = "|cff6fcf7f"
Style.HEX_VIOLET = "|cff8b6cd6"
Style.END = "|r"

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
function Style.box(parent, frameType)
    local f = CreateFrame(frameType or "Frame", nil, parent)
    f.bg = solid(f, "BACKGROUND", COL.inner)
    f.bg:SetAllPoints()
    f.edges = outline(f, 0, 1, COL.violet, "BORDER")
    function f:SetColors(fill, fillAlpha, edge, edgeAlpha)
        self.bg:SetColorTexture(fill[1], fill[2], fill[3], fillAlpha)
        for _, e in ipairs(self.edges) do
            e:SetColorTexture(edge[1], edge[2], edge[3], edgeAlpha)
        end
    end
    return f
end
local box = Style.box

function Style.badge(parent, frameType)
    local b = box(parent, frameType)
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

-------------------------------------------------------------------- frame art
-- Violet outer lines, turquoise vines along all four edges, rosettes in the corners,
-- for a frame of w x h.
function Style.buildFrameArt(f, w, h)
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
function Style.buildInner(f)
    local inner = CreateFrame("Frame", nil, f)
    inner:SetPoint("TOPLEFT", BAND, -BAND)
    inner:SetPoint("BOTTOMRIGHT", -BAND, BAND)
    local ibg = solid(inner, "BACKGROUND", COL.inner)
    ibg:SetAllPoints()
    outline(inner, 0, 1, COL.violet, "BORDER")
    return inner
end

-- Title band with the window title and a close X that calls onClose.
function Style.buildHeader(inner, titleText, onClose)
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

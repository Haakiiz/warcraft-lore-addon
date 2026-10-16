-- Fake WoW API for smoke-testing and rendering WarcraftLore outside the game.
-- Records enough visual state (textures, colors, fonts, anchors, strata...) that MOCK.dump()
-- can serialize it for render.py.
MOCK = { unknown = {}, chat = {}, frames = {}, newGlobals = {} }

unpack = table.unpack
function wipe(t) for k in pairs(t) do t[k] = nil end return t end
tinsert, tremove = table.insert, table.remove
format = string.format
strlower, strupper, strlen = string.lower, string.upper, string.len
function strtrim(s) return (s:gsub("^%s+", ""):gsub("%s+$", "")) end
function strsplit(sep, s)
    local out = {}
    for part in (s .. sep):gmatch("(.-)" .. sep:gsub("%p", "%%%0")) do out[#out + 1] = part end
    return table.unpack(out)
end
function hooksecurefunc() end
function IsShiftKeyDown() return false end
function GetBuildInfo() return "1.60.1", "0", "", 16001 end
function GetScreenWidth() return 1920 end
function GetScreenHeight() return 1080 end
function GetCursorPosition() return 500, 500 end
STANDARD_TEXT_FONT = "Fonts\\FRIZQT__.TTF"
SOUNDKIT = { MAP_PING = 1 }
function PlaySound() end
UISpecialFrames = {}
SlashCmdList = {}
Enum = { TooltipDataType = { Unit = 2 } }
TooltipDataProcessor = { AddTooltipPostCall = function(_, fn) MOCK.tooltipCB = fn end }
C_Timer = { NewTicker = function(_, fn) MOCK.ticker = fn return {} end, After = function(_, fn) fn() end }
C_Map = { GetBestMapForUnit = function() return nil end, GetPlayerMapPosition = function() return nil end }
function IsInInstance() return false end
DEFAULT_CHAT_FRAME = { AddMessage = function(_, m) MOCK.chat[#MOCK.chat + 1] = m end }
function RaidNotice_AddMessage() end
ChatTypeInfo = {}

-- Units: MOCK.units[unit] = { guid=, name= }
MOCK.units = {}
function UnitGUID(u) return MOCK.units[u] and MOCK.units[u].guid end
function UnitName(u) return MOCK.units[u] and MOCK.units[u].name end
function UnitExists(u) return MOCK.units[u] ~= nil end

---------------------------------------------------------------- text metrics
-- MOCK_WIDTHS (widths.lua, loaded by run.js) = per-font, per-size advance widths of the TTF the renderer draws with.
local WIDTHS = MOCK_WIDTHS or { body = {}, title = {} }

local function fontKind(path)
    return (path and tostring(path):upper():find("MORPHEUS", 1, true)) and "title" or "body"
end

-- Strips |cAARRGGBB, |r, |T..|t and turns || into |. Returns an array of code points (10 = newline).
local function plainCodepoints(text)
    local s = tostring(text or "")
    s = s:gsub("||", "\1")
    s = s:gsub("|c%x%x%x%x%x%x%x%x", ""):gsub("|r", ""):gsub("|T.-|t", ""):gsub("|n", "\n")
    s = s:gsub("\1", "|")
    local out = {}
    local ok = pcall(function() for _, cp in utf8.codes(s) do out[#out + 1] = cp end end)
    if not ok then
        out = {}
        for i = 1, #s do out[#out + 1] = s:byte(i) end
    end
    return out
end

local function advanceOf(kind, size, cp)
    local t = WIDTHS[kind] and WIDTHS[kind][size]
    local w = t and t[cp]
    if w then return w end
    return size * 0.55
end

local function lineHeight(size) return math.floor(size * 1.15 + 0.5) end

local function sumWidth(kind, size, cps, i, j) -- [i, j)
    local w = 0
    for k = i, j - 1 do w = w + advanceOf(kind, size, cps[k]) end
    return w
end

-- Breaks text into lines. Returns { {s, e, ell}, ... } (indices into cps, [s, e)), widest line, line count.
local function layoutText(o, boxW)
    local cps = plainCodepoints(o._text)
    local kind, size = fontKind(o._font), o._fsize or 12
    local wrap = o._wrap ~= false
    local lines = {}
    local n = #cps
    local ps = 1
    local function paragraph(a, b) -- [a, b)
        if not (wrap and boxW and boxW > 0) then
            local e = b
            local ell = false
            if (not wrap) and boxW and boxW > 0 and sumWidth(kind, size, cps, a, b) > boxW then
                local dots = advanceOf(kind, size, 46) * 3
                e = a
                local w = 0
                while e < b and w + advanceOf(kind, size, cps[e]) + dots <= boxW do
                    w = w + advanceOf(kind, size, cps[e]); e = e + 1
                end
                ell = true
            end
            lines[#lines + 1] = { a, e, ell }
            return
        end
        local start, lastSpace, cur = a, nil, 0
        local k = a
        while k < b do
            local c = cps[k]
            local w = advanceOf(kind, size, c)
            if c == 32 then
                lastSpace = k
            elseif cur + w > boxW and k > start then
                if lastSpace and lastSpace >= start then
                    lines[#lines + 1] = { start, lastSpace, false }
                    start = lastSpace + 1
                else
                    lines[#lines + 1] = { start, k, false }
                    start = k
                end
                lastSpace = nil
                cur = sumWidth(kind, size, cps, start, k)
            end
            cur = cur + w
            k = k + 1
        end
        lines[#lines + 1] = { start, b, false }
    end
    for i = 1, n + 1 do
        if i == n + 1 or cps[i] == 10 then
            paragraph(ps, i)
            ps = i + 1
        end
    end
    local widest = 0
    for _, l in ipairs(lines) do
        local w = sumWidth(kind, size, cps, l[1], l[2])
        if l[3] then w = w + advanceOf(kind, size, 46) * 3 end
        l.w = w
        if w > widest then widest = w end
    end
    return lines, widest, #lines
end

local function textHeight(o, nlines)
    local size = o._fsize or 12
    return nlines * lineHeight(size) + (nlines - 1) * (o._spacing or 0)
end

---------------------------------------------------------------- objects
local Obj = {}
local known = {}
local function def(name, fn) known[name] = true Obj[name] = fn end

local function effStrata(o)
    while o do
        if o._strata then return o._strata end
        o = o._parent
    end
    return "MEDIUM"
end

local REGION = { Texture = true, FontString = true, MaskTexture = true }

local function newObj(kind, parent, name)
    local o = setmetatable({ _kind = kind, _parent = parent, _scripts = {}, _shown = true, _w = 0, _h = 0,
        _text = "", _points = {}, _children = {}, _name = name, _alpha = 1, _id = #MOCK.frames + 1 }, { __index = function(t, k)
        if Obj[k] then return Obj[k] end
        if type(k) == "string" and k:match("^[A-Z]") then
            MOCK.unknown[kind .. ":" .. k] = true
            return function() end
        end
        return nil
    end })
    if not REGION[kind] then o._level = parent and ((parent._level or 0) + 1) or 0 end
    if parent and parent._children then table.insert(parent._children, o) end
    MOCK.frames[#MOCK.frames + 1] = o
    return o
end

def("Show", function(s) s._shown = true; if s._scripts.OnShow then s._scripts.OnShow(s) end end)
def("Hide", function(s) local was = s._shown; s._shown = false; if was and s._scripts.OnHide then s._scripts.OnHide(s) end end)
def("SetShown", function(s, v) if v then s:Show() else s:Hide() end end)
def("IsShown", function(s) return s._shown end)
def("IsVisible", function(s)
    local o = s
    while o do if not o._shown then return false end o = o._parent end
    return true
end)
def("SetScript", function(s, ev, fn) s._scripts[ev] = fn end)
def("GetScript", function(s, ev) return s._scripts[ev] end)
def("HookScript", function(s, ev, fn) local old = s._scripts[ev]; s._scripts[ev] = function(...) if old then old(...) end fn(...) end end)
def("HasScript", function() return true end)

---------------------------------------------------------------- layout (anchors -> rectangles)
-- Rect = { l, b, r, t } in WoW coordinates (origin bottom-left, y up) on a 1920x1080 UIParent.
local cache = {}

local function anchorPos(r, pt)
    local x = pt:find("LEFT", 1, true) and r.l or (pt:find("RIGHT", 1, true) and r.r or (r.l + r.r) / 2)
    local y = pt:find("TOP", 1, true) and r.t or (pt:find("BOTTOM", 1, true) and r.b or (r.b + r.t) / 2)
    return x, y
end

local rectOf
rectOf = function(f)
    if f == UIParent then return { l = 0, b = 0, r = 1920, t = 1080 } end
    local c = cache[f]
    if c ~= nil then return c or nil end
    cache[f] = false
    local res
    local pts = f._points
    if #pts == 0 then
        local p = f._parent
        if p and p._kind == "ScrollFrame" and p._child == f then
            local pr = rectOf(p)
            if pr then
                local l = pr.l - (p._hs or 0)
                local t = pr.t + (p._vs or 0)
                res = { l = l, b = t - f._h, r = l + f._w, t = t }
            end
        end
        cache[f] = res or false
        return res
    end
    local L, R, CX, B, T, CY
    for _, p in ipairs(pts) do
        local rel = p.rel or f._parent
        local rr = rel and rectOf(rel)
        if not rr then cache[f] = false return nil end
        local ax, ay = anchorPos(rr, p.relPoint)
        ax, ay = ax + p.x, ay + p.y
        local pt = p.point
        if pt:find("LEFT", 1, true) then L = ax elseif pt:find("RIGHT", 1, true) then R = ax else CX = ax end
        if pt:find("TOP", 1, true) then T = ay elseif pt:find("BOTTOM", 1, true) then B = ay else CY = ay end
    end
    local w, h = f._w, f._h
    local isFS = f._kind == "FontString"
    local lines, widest, nl
    if isFS then
        local boxW = (L and R) and (R - L) or (w > 0 and w or nil)
        lines, widest, nl = layoutText(f, boxW)
        if w == 0 and not (L and R) then w = widest end
        if h == 0 and not (B and T) then h = textHeight(f, nl) end
    end
    local l, r, b, t
    if L and R then l, r = L, R elseif L then l, r = L, L + w elseif R then l, r = R - w, R else l = (CX or 0) - w / 2; r = l + w end
    if B and T then b, t = B, T elseif B then b, t = B, B + h elseif T then b, t = T - h, T else b = (CY or 0) - h / 2; t = b + h end
    res = { l = l, b = b, r = r, t = t }
    cache[f] = res
    return res
end

local function R(f) cache = {} return rectOf(f) end
MOCK.rect = R

def("SetSize", function(s, w, h) s._w, s._h = w, h end)
def("SetWidth", function(s, w) s._w = w end)
def("SetHeight", function(s, h) s._h = h end)
def("GetWidth", function(s)
    if s._w > 0 then return s._w end
    local r = R(s)
    return r and (r.r - r.l) or 0
end)
def("GetHeight", function(s)
    if s._h > 0 then return s._h end
    local r = R(s)
    return r and (r.t - r.b) or 0
end)
def("GetSize", function(s) return s:GetWidth(), s:GetHeight() end)
def("GetLeft", function(s) local r = R(s) return r and r.l end)
def("GetRight", function(s) local r = R(s) return r and r.r end)
def("GetTop", function(s) local r = R(s) return r and r.t end)
def("GetBottom", function(s) local r = R(s) return r and r.b end)

def("SetPoint", function(s, point, a, b, c, d)
    local rel, relPoint, x, y
    if a == nil or type(a) == "number" then
        rel, relPoint, x, y = nil, point, a or 0, b or 0
    else
        rel = a
        if type(rel) == "string" then rel = _G[rel] end
        if type(b) == "string" then relPoint, x, y = b, c or 0, d or 0 else relPoint, x, y = point, b or 0, c or 0 end
    end
    s._points[#s._points + 1] = { point = point, rel = rel, relPoint = relPoint, x = x, y = y }
end)
def("ClearAllPoints", function(s) s._points = {} end)
def("SetAllPoints", function(s, target)
    target = target or s._parent
    if type(target) == "string" then target = _G[target] end
    s._points = {
        { point = "TOPLEFT", rel = target, relPoint = "TOPLEFT", x = 0, y = 0 },
        { point = "BOTTOMRIGHT", rel = target, relPoint = "BOTTOMRIGHT", x = 0, y = 0 },
    }
end)
def("GetPoint", function(s, i)
    local p = s._points[i or 1]
    if not p then return nil end
    return p.point, p.rel or s._parent, p.relPoint, p.x, p.y
end)
def("GetNumPoints", function(s) return #s._points end)
def("GetParent", function(s) return s._parent end)
def("SetParent", function(s, p) s._parent = p end)
def("GetName", function(s) return s._name end)

---------------------------------------------------------------- text
def("SetText", function(s, t) s._text = t == nil and "" or tostring(t) end)
def("GetText", function(s) return s._text end)
def("SetFormattedText", function(s, f, ...) s._text = f:format(...) end)
local function boxWidthFor(s)
    if s._w > 0 then return s._w end
    if #s._points >= 2 then
        local r = R(s)
        if r then return r.r - r.l end
    end
    return nil
end
def("GetStringWidth", function(s)
    local _, widest = layoutText(s, boxWidthFor(s))
    return widest
end)
def("GetStringHeight", function(s)
    local _, _, nl = layoutText(s, boxWidthFor(s))
    return textHeight(s, nl)
end)
def("SetFont", function(s, path, size, flags) s._font, s._fsize, s._fflags = path, size, flags or "" return true end)
def("GetFont", function(s) return s._font or "Fonts\\FRIZQT__.TTF", s._fsize or 12, s._fflags or "" end)
def("SetJustifyH", function(s, v) s._jh = v end)
def("SetJustifyV", function(s, v) s._jv = v end)
def("SetWordWrap", function(s, v) s._wrap = v and true or false end)
def("SetSpacing", function(s, v) s._spacing = v end)
def("SetTextColor", function(s, r, g, b, a) s._tcolor = { r, g, b, a or 1 } end)
def("GetTextColor", function(s)
    local c = s._tcolor or { 1, 1, 1, 1 }
    return c[1], c[2], c[3], c[4]
end)

---------------------------------------------------------------- textures
def("SetTexture", function(s, path, wrapH, wrapV)
    s._tex, s._wrapH, s._wrapV = path, wrapH, wrapV
    if path ~= nil then s._color = nil end
end)
def("SetColorTexture", function(s, r, g, b, a) s._color = { r, g, b, a or 1 }; s._tex = nil end)
def("SetTexCoord", function(s, ...)
    local a = { ... }
    if #a == 8 then
        s._tc = { a[1], a[5], a[2], a[4] }
    elseif #a == 4 then
        s._tc = { a[1], a[2], a[3], a[4] }
    end
end)
def("SetVertexColor", function(s, r, g, b, a) s._vc = { r, g, b, a or 1 } end)
def("SetAlpha", function(s, a) s._alpha = a end)
def("GetAlpha", function(s) return s._alpha end)
def("SetDrawLayer", function(s, layer, sub) s._layer, s._sub = layer, sub or 0 end)
def("AddMaskTexture", function(s, m) s._masks = s._masks or {}; table.insert(s._masks, m) end)
def("SetDesaturated", function(s, v) s._desat = v and true or false end)
def("SetBlendMode", function(s, v) s._blend = v end)

def("CreateTexture", function(s, name, layer, tmpl, sub)
    local o = newObj("Texture", s, name); o._layer = layer or "ARTWORK"; o._sub = sub or 0 return o
end)
def("CreateFontString", function(s, name, layer)
    local o = newObj("FontString", s, name); o._layer = layer or "OVERLAY"; o._sub = 0 return o
end)
def("CreateMaskTexture", function(s, name, layer, tmpl, sub)
    local o = newObj("MaskTexture", s, name); o._layer = layer or "ARTWORK"; o._sub = sub or 0 return o
end)
function SetPortraitTexture(tex, unit) tex._tex = "@unit-portrait"; tex._color = nil; tex._tc = nil end

---------------------------------------------------------------- frames
def("GetVerticalScroll", function(s) return s._vs or 0 end)
def("SetVerticalScroll", function(s, v) s._vs = v end)
def("GetHorizontalScroll", function(s) return s._hs or 0 end)
def("SetHorizontalScroll", function(s, v) s._hs = v end)
def("GetVerticalScrollRange", function(s)
    local c = s._child
    if not c then return 0 end
    return math.max(0, (c._h or 0) - s:GetHeight())
end)
def("SetScrollChild", function(s, c) s._child = c end)
def("GetScrollChild", function(s) return s._child end)
def("SetFrameStrata", function(s, v) s._strata = v end)
def("GetFrameStrata", function(s) return effStrata(s) end)
def("SetFrameLevel", function(s, v) s._level = v end)
def("GetFrameLevel", function(s) return s._level end)
def("Raise", function(s) s._raised = true end)
def("SetFocus", function(s) s._focus = true end)
def("ClearFocus", function(s) s._focus = false end)
def("HasFocus", function(s) return s._focus end)
def("IsMouseOver", function() return false end)
def("GetEffectiveScale", function() return 1 end)
def("GetScale", function() return 1 end)
def("IsObjectType", function(s, t) return s._kind == t end)
def("GetObjectType", function(s) return s._kind end)
def("GetChildren", function(s) return table.unpack(s._children) end)
-- Harmless setters that exist in the real API.
for _, n in ipairs({ "SetClampedToScreen", "SetMovable", "EnableMouse",
    "RegisterForDrag", "RegisterForClicks", "StartMoving", "StopMovingOrSizing", "EnableMouseWheel",
    "RegisterEvent", "UnregisterEvent", "SetAutoFocus", "SetMaxLetters", "SetTextInsets", "SetFontObject",
    "SetHighlightTexture", "SetNormalTexture", "SetPushedTexture", "SetNonSpaceWrap",
    "SetMaxLines", "SetToplevel", "SetHitRectInsets", "SetMultiLine", "SetCursorPosition", "HighlightText",
    "SetClampRectInsets", "SetIgnoreParentAlpha", "SetEnabled", "Enable", "Disable", "SetMouseClickEnabled",
    "SetMouseMotionEnabled", "SetPropagateKeyboardInput", "EnableKeyboard", "SetRotation",
    "SetUserPlaced", "SetDontSavePosition", "LockHighlight", "UnlockHighlight", "SetSnapToPixelGrid",
    "SetTexelSnappingBias", "SetShadowOffset", "SetShadowColor", "SetIndentedWordWrap",
    "SetScale", "SetObeyStepOnDrag", "SetCountInvisibleLetters", "EnableMouseMotion", "SetNumeric" }) do
    def(n, function() end)
end
def("IsEnabled", function() return true end)

function CreateFrame(kind, name, parent, template)
    if template then MOCK.templates = (MOCK.templates or "") .. template .. ";" end
    local f = newObj(kind, parent, name)
    if kind ~= "GameTooltip" then f._shown = true end
    if name then _G[name] = f end
    return f
end
UIParent = newObj("Frame", nil, "UIParent")
UIParent._strata, UIParent._w, UIParent._h = "MEDIUM", 1920, 1080

def("GetTexture", function(s) return s._tex end)
def("GetCenter", function(s) local r = R(s) if not r then return nil end return (r.l + r.r) / 2, (r.b + r.t) / 2 end)
def("CreateAnimationGroup", function(s)
    local g = {}
    local anim = setmetatable({}, { __index = function() return function() end end })
    function g.SetLooping() end
    function g.CreateAnimation() return anim end
    function g.Play() s._pulsing = true; s._alpha = 0.75 end -- a still image: show the pulse at mid strength
    function g.Stop() s._pulsing = false; s._alpha = 1 end
    MOCK.animGroups = (MOCK.animGroups or 0) + 1
    return g
end)
function GetMinimapShape() return MOCK.minimapShape or "ROUND" end
function GetTime() return MOCK.now or 0 end

-- Minimap: 140x140 at the top right of the screen, drawn as a dark green disc.
Minimap = newObj("Frame", UIParent, "Minimap")
Minimap._w, Minimap._h = 140, 140
Minimap:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT", -40, -40)
do
    local disc = Minimap:CreateTexture(nil, "BACKGROUND")
    disc:SetAllPoints()
    disc:SetTexture("Interface\\AddOns\\WarcraftLore\\Textures\\CircleMask")
    disc:SetVertexColor(0.30, 0.36, 0.24, 1)
end

-- GameTooltip: records its lines and lays them out as a dark box (Show builds the pieces).
GameTooltip = newObj("GameTooltip", UIParent, "GameTooltip")
GameTooltip._strata = "TOOLTIP"
GameTooltip._shown = false
GameTooltip._lines = {}
do
    local tt = GameTooltip
    local bg = tt:CreateTexture(nil, "BACKGROUND")
    bg:SetAllPoints(); bg:SetColorTexture(0.031, 0.031, 0.071, 0.96)
    local function edge(p1, p2, w, h)
        local e = tt:CreateTexture(nil, "BORDER")
        e:SetPoint(p1); e:SetPoint(p2)
        if w then e:SetWidth(w) end
        if h then e:SetHeight(h) end
        e:SetColorTexture(0.36, 0.36, 0.44, 1)
    end
    edge("TOPLEFT", "TOPRIGHT", nil, 1); edge("BOTTOMLEFT", "BOTTOMRIGHT", nil, 1)
    edge("TOPLEFT", "BOTTOMLEFT", 1, nil); edge("TOPRIGHT", "BOTTOMRIGHT", 1, nil)
    tt._pool = {}
    local ANCHORS = { ANCHOR_LEFT = { "BOTTOMRIGHT", "TOPLEFT" }, ANCHOR_RIGHT = { "BOTTOMLEFT", "TOPRIGHT" },
        ANCHOR_TOP = { "BOTTOM", "TOP" }, ANCHOR_BOTTOM = { "TOP", "BOTTOM" } }
    function tt.SetOwner(s, owner, anchor)
        s._owner = owner; s._minw = nil; s._points = {}
        local a = ANCHORS[anchor]
        if a then s:SetPoint(a[1], owner, a[2], 0, 0) end
    end
    function tt.GetOwner(s) return s._owner end
    function tt.ClearLines(s) s._lines = {} end
    function tt.SetMinimumWidth(s, w) s._minw = w end
    function tt.AddLine(s, text, r, g, b, wrap) s._lines[#s._lines + 1] = { text = text, r = r or 1, g = g or 1, b = b or 1, wrap = wrap } end
    function tt.Show(s)
        local widest = 0
        for i, l in ipairs(s._lines) do
            local fs = s._pool[i]
            if not fs then fs = s:CreateFontString(nil, "OVERLAY"); s._pool[i] = fs end
            fs:SetFont("Fonts\\FRIZQT__.TTF", i == 1 and 14 or 12, "")
            fs:SetText(l.text); fs:SetTextColor(l.r, l.g, l.b)
            fs._jh = "LEFT"; fs._jv = "TOP"
            fs._wrap = false; fs._w = 0
            if not l.wrap then widest = math.max(widest, fs:GetStringWidth()) end
        end
        local w = math.min(math.max(widest + 20, 120, s._minw or 0), 340)
        local y = 8
        for i, l in ipairs(s._lines) do
            local fs = s._pool[i]
            fs._wrap = l.wrap and true or false
            fs._w = w - 20
            fs._points = {}
            fs:SetPoint("TOPLEFT", s, "TOPLEFT", 10, -y)
            fs._shown = true
            y = y + fs:GetStringHeight() + 2
        end
        for i = #s._lines + 1, #s._pool do s._pool[i]._shown = false end
        s._w, s._h = w, y + 6
        s._shown = true
    end
end
RaidWarningFrame = newObj("Frame", UIParent, "RaidWarningFrame")
function MOCK.click(f, button)
    assert(f._scripts.OnClick, "no OnClick on " .. tostring(f._name or f._kind))
    f._scripts.OnClick(f, button or "LeftButton", false)
end

-- All visible FontString texts under a frame (for asserting what the user sees).
function MOCK.texts(root, out)
    out = out or {}
    for _, c in ipairs(root._children) do
        if c._shown then
            if c._kind == "FontString" and c._text ~= "" then out[#out + 1] = c._text end
            MOCK.texts(c, out)
        end
    end
    return out
end

---------------------------------------------------------------- dump (JSON)
local function jstr(s)
    s = tostring(s)
    s = s:gsub('[%c"\\]', function(c)
        if c == '"' then return '\\"' elseif c == "\\" then return "\\\\"
        elseif c == "\n" then return "\\n" elseif c == "\t" then return "\\t"
        else return string.format("\\u%04x", c:byte()) end
    end)
    return '"' .. s .. '"'
end
local function jnum(n)
    if n ~= n or n == math.huge or n == -math.huge then return "0" end
    if n == math.floor(n) then return string.format("%d", n) end
    return string.format("%.4f", n)
end
local function jval(v)
    local t = type(v)
    if t == "nil" then return "null"
    elseif t == "number" then return jnum(v)
    elseif t == "boolean" then return v and "true" or "false"
    elseif t == "string" then return jstr(v)
    elseif t == "table" then
        local parts = {}
        if #v > 0 or next(v) == nil then
            for _, x in ipairs(v) do parts[#parts + 1] = jval(x) end
            return "[" .. table.concat(parts, ",") .. "]"
        end
        local keys = {}
        for k in pairs(v) do keys[#keys + 1] = k end
        table.sort(keys)
        for _, k in ipairs(keys) do parts[#parts + 1] = jstr(k) .. ":" .. jval(v[k]) end
        return "{" .. table.concat(parts, ",") .. "}"
    end
    return "null"
end

local function effShown(o)
    while o do if not o._shown then return false end o = o._parent end
    return true
end

function MOCK.dump(path)
    cache = {}
    local out = {}
    for _, o in ipairs(MOCK.frames) do
        local rect = rectOf(o)
        local d = {
            id = o._id, parent = o._parent and o._parent._id or nil, kind = o._kind, name = o._name,
            shown = effShown(o), selfShown = o._shown, alpha = o._alpha,
            w = o._w, h = o._h,
        }
        if rect then d.rect = { rect.l, rect.b, rect.r, rect.t } end
        local pts = {}
        for _, p in ipairs(o._points) do
            local rel = p.rel or o._parent
            pts[#pts + 1] = { p.point, rel and rel._id, p.relPoint, p.x, p.y }
        end
        d.points = pts
        if REGION[o._kind] then
            d.layer, d.sub = o._layer, o._sub
            d.tex, d.color, d.tc, d.vc = o._tex, o._color, o._tc, o._vc
            d.wrapH, d.wrapV, d.desat, d.blend = o._wrapH, o._wrapV, o._desat, o._blend
            if o._masks then
                d.masks = {}
                for _, m in ipairs(o._masks) do d.masks[#d.masks + 1] = m._id end
            end
        else
            d.strata, d.level = effStrata(o), o._level
        end
        if o._kind == "FontString" or o._kind == "EditBox" then
            d.text = o._text
            d.font = o._font; d.fsize = o._fsize or 12; d.fflags = o._fflags or ""
            d.tcolor, d.jh, d.jv, d.wrap, d.spacing = o._tcolor, o._jh or "CENTER", o._jv or "MIDDLE", o._wrap ~= false, o._spacing or 0
            d.lh = lineHeight(o._fsize or 12)
            if rect then
                local lines = layoutText(o, rect.r - rect.l)
                local ls = {}
                for _, l in ipairs(lines) do ls[#ls + 1] = { l[1], l[2], l[3] and 1 or 0, l.w } end
                d.lines = ls
            end
        end
        out[#out + 1] = jval(d)
    end
    local json = '{"screen":[1920,1080],"objects":[' .. table.concat(out, ",\n") .. "]}"
    if path and __writefile then
        __writefile(path, json)
    else
        print(json)
    end
end

time = os.time; date = os.date

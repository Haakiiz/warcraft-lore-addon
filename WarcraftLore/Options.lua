-- Options.lua – the Warcraft Lore page in the game's AddOns settings: five checkboxes and two
-- buttons, styled like the windows. Changes apply at once. If the client has no settings
-- panel this file does nothing. ns.Options.Open() opens the page (used by /wcl options).

local ADDON_NAME, ns = ...
local C = ns.Compat
local L = ns.L
local S = ns.Style
local COL = S.COL

local Options = {}
ns.Options = Options

local PAD = 16
local ROW_GAP = 30

local panel, category
local checks = {}

local function db()
    return type(WarcraftLoreDB) == "table" and WarcraftLoreDB or nil
end

local function minimapHidden()
    local d = db()
    return d ~= nil and type(d.minimap) == "table" and d.minimap.hide == true
end

-- Each option: the label, how to read it, how to write it.
local OPTIONS = {
    { L["Alert when I target a veteran"],
        function(d) return d.auto == true end,
        function(d, on) d.auto = on end },
    { L["Alert when a veteran is nearby"],
        function(d) return d.alert == true end,
        function(d, on) d.alert = on end },
    { L["Show minimap button"],
        function() return not minimapHidden() end,
        function(_, on)
            if ns.Minimap and on == minimapHidden() then
                ns.Minimap.Toggle() -- Toggle flips the state, so only call it when it differs
            end
        end },
    { L["Show veterans on the world map"],
        function(d) return d.mapPins ~= false end,
        function(d, on)
            d.mapPins = on
            if ns.MapPins then
                ns.MapPins.Refresh()
            end
        end },
    { L["Hide book-only veterans in the list"],
        function(d) return d.hideBookOnly == true end,
        function(d, on)
            d.hideBookOnly = on or nil
            if ns.Browser then
                ns.Browser.Refresh(true)
            end
        end },
}

local function refreshChecks()
    local d = db()
    for _, cb in ipairs(checks) do
        local on = d ~= nil and cb.get(d)
        cb.tick:SetShown(on)
        cb.box:SetColors(COL.inner, 1, on and COL.violet or COL.headerLine, 1)
        local c = on and COL.title or COL.text
        cb.label:SetTextColor(c[1], c[2], c[3])
    end
end

local function addCheck(parent, y, option)
    local cb = CreateFrame("Button", nil, parent)
    cb:SetHeight(20)
    C.RegisterClicks(cb)
    cb.box = S.box(cb)
    cb.box:SetSize(14, 14)
    cb.box:SetPoint("LEFT", 0, 0)
    cb.tick = S.solid(cb.box, "ARTWORK", COL.violet)
    cb.tick:SetSize(8, 8)
    cb.tick:SetPoint("CENTER")
    cb.label = S.text(cb, C.FONT_BODY, 13, COL.text)
    cb.label:SetPoint("LEFT", 24, 0)
    cb.label:SetJustifyV("MIDDLE")
    cb.label:SetText(option[1])
    cb:SetWidth(math.ceil(24 + cb.label:GetStringWidth()) + 4)
    cb:SetPoint("TOPLEFT", parent, "TOPLEFT", PAD, y)
    cb.get = option[2]
    local set = option[3]
    local function onClick()
        local d = db()
        if not d then
            return
        end
        set(d, not cb.get(d))
        refreshChecks()
    end
    cb:SetScript("OnClick", function()
        -- ns.Guard (Core.lua) keeps an error in a setting's side effect out of the error frame.
        local run = ns.Guard and ns.Guard("options", L["the settings page"], onClick) or onClick
        run()
    end)
    checks[#checks + 1] = cb
    return cb
end

local function addButton(parent, y, label, onClick)
    local b = S.box(parent, "Button")
    b:SetSize(170, 24)
    b:SetPoint("TOPLEFT", parent, "TOPLEFT", PAD, y)
    b:SetColors(COL.header, 1, COL.headerLine, 1)
    C.RegisterClicks(b)
    local fs = S.text(b, C.FONT_BODY, 12, COL.title)
    fs:SetPoint("CENTER")
    fs:SetJustifyH("CENTER")
    fs:SetJustifyV("MIDDLE")
    fs:SetText(label)
    -- 170 px is enough for the shipped texts; a longer label widens the button instead of spilling.
    b:SetWidth(math.max(170, math.ceil(fs:GetStringWidth()) + 24))
    b:SetScript("OnEnter", function() b:SetColors(COL.header, 1, COL.violet, 1) end)
    b:SetScript("OnLeave", function() b:SetColors(COL.header, 1, COL.headerLine, 1) end)
    b:SetScript("OnClick", onClick)
    return b
end

local function build()
    panel = CreateFrame("Frame", nil, UIParent)
    panel.name = "Warcraft Lore"
    panel:Hide()

    local title = S.text(panel, C.FONT_TITLE, 20, COL.title)
    title:SetPoint("TOPLEFT", PAD, -PAD)
    title:SetText(L["Warcraft Lore"])
    local sub = S.text(panel, C.FONT_BODY, 12, COL.muted)
    sub:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -6)
    sub:SetText(L["Choose when Warcraft Lore speaks up."])
    local line = S.solid(panel, "BORDER", COL.divider)
    line:SetPoint("TOPLEFT", PAD, -62)
    line:SetPoint("TOPRIGHT", -PAD, -62)
    line:SetHeight(1)

    local y = -80
    for _, option in ipairs(OPTIONS) do
        addCheck(panel, y, option)
        y = y - ROW_GAP
    end
    y = y - 10
    addButton(panel, y, L["Open Veterans list"], function()
        if ns.Browser then
            ns.Browser.Toggle()
        end
    end)
    addButton(panel, y - 34, L["Reset window positions"], function()
        if not db() then
            return
        end
        if ns.ResetWindows then
            ns.ResetWindows() -- same as /wcl reset, including the chat line
        end
    end)
    -- Same as the switch button in every window's title band and /wcl theme.
    addButton(panel, y - 68, L["Switch to the %s"]:format(S.ThemeLabel(S.OtherTheme())), function()
        S.RequestTheme(S.OtherTheme())
    end)

    panel:SetScript("OnShow", refreshChecks)
    refreshChecks()
end

local function register()
    if panel then
        return
    end
    local hasSettings = type(Settings) == "table" and Settings.RegisterCanvasLayoutCategory ~= nil
        and Settings.RegisterAddOnCategory ~= nil
    if not hasSettings and not InterfaceOptions_AddCategory then
        return -- no settings panel in this client
    end
    if not pcall(build) then
        panel = nil
        return
    end
    if hasSettings then
        local registered = pcall(function()
            category = Settings.RegisterCanvasLayoutCategory(panel, panel.name)
            Settings.RegisterAddOnCategory(category)
        end)
        if not registered then
            category = nil
        end
    else
        pcall(InterfaceOptions_AddCategory, panel)
    end
end

-- Ticks the checkboxes to match the saved settings (after a slash command changed one).
function Options.Refresh()
    if panel then
        refreshChecks()
    end
end

-- Opens the page. Returns false when the client has no settings page at all; otherwise
-- true, plus a second value saying whether opening it worked (it can fail, for example in combat).
function Options.Open()
    if not panel then
        return false
    end
    if category and Settings and Settings.OpenToCategory then
        local id = category.GetID and category:GetID() or category.ID
        return true, (pcall(Settings.OpenToCategory, id))
    elseif InterfaceOptionsFrame_OpenToCategory then
        local ok = pcall(InterfaceOptionsFrame_OpenToCategory, panel)
        pcall(InterfaceOptionsFrame_OpenToCategory, panel) -- the first call can land on the wrong page
        return true, ok
    end
    return false
end

-- Core.lua is not touched: register once the player has logged in (saved data is loaded by then).
local loader = CreateFrame("Frame")
loader:RegisterEvent("PLAYER_LOGIN")
loader:SetScript("OnEvent", function(self)
    self:UnregisterEvent("PLAYER_LOGIN")
    register()
end)

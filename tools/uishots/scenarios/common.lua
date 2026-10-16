-- Shared helpers for screenshot scenarios (loaded before each scenario).
function MOCK.fire(ev, ...)
    for _, f in ipairs(MOCK.frames) do if f._scripts.OnEvent then f._scripts.OnEvent(f, ev, ...) end end
end
function visibleRows()
    local n = 0
    for _, f in ipairs(MOCK.frames) do
        if f._kind == "Button" and f.item and f.nameText and f:IsVisible() then n = n + 1 end
    end
    return n
end
function rowFor(name)
    for _, f in ipairs(MOCK.frames) do
        if f._kind == "Button" and f.nameText and f:IsVisible() and f.item and f.item.name == name then return f end
    end
end
function btnWithText(prefix)
    for _, f in ipairs(MOCK.frames) do
        if f._kind == "Button" and f.label and f.label._text:find(prefix, 1, true) and f:IsVisible() then return f end
    end
end
function searchBox()
    for _, f in ipairs(MOCK.frames) do if f._kind == "EditBox" then return f end end
end
function typeSearch(txt)
    local e = searchBox()
    if e._scripts.OnEditFocusGained then e._scripts.OnEditFocusGained(e) end
    e:SetFocus()
    e:SetText(txt)
    e._scripts.OnTextChanged(e, true)
end
function startAddon(met)
    WarcraftLoreCharDB = { met = met or {} }
    MOCK.fire("ADDON_LOADED", "WarcraftLore")
end
function target(id, name)
    MOCK.units.target = { guid = "Creature-0-1-2-3-" .. id .. "-0001", name = name }
    MOCK.fire("PLAYER_TARGET_CHANGED")
end
function chipFor(code)
    for _, f in ipairs(MOCK.frames) do
        if f._kind == "Button" and f.code == code and f:IsVisible() then return f end
    end
end
function toggleBook()
    for _, f in ipairs(MOCK.frames) do
        if f._kind == "Button" and f.label and f.label._text == "Hide book-only" then return f end
    end
end
function minimapButton()
    for _, f in ipairs(MOCK.frames) do
        if f._kind == "Button" and f._parent == Minimap then return f end
    end
end
function hover(f) f._scripts.OnEnter(f) end
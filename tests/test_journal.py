"""The Lore Journal window (Journal.lua) in Lua 5.1 via lupa with a fake client and a fake
ns.Achievements: the window builds lazily, category chips filter the rows, summary text, done and
not-done styling, a missing ns.Achievements, /wcl journal, shift-click on the minimap button, the
Veterans list button, position reset, and every Button registered for clicks.

Usage: python tests/test_journal.py   (needs: pip install lupa)
"""

from pathlib import Path

import lupa.lua51 as lupa

ADDON = Path(__file__).resolve().parent.parent / "WarcraftLore"

STUBS = """
local noop = function() end
local methods
local function newObj(kind)
    local o = { kind = kind, scripts = {}, shown = true, scroll = 0, name = nil, colors = {} }
    return setmetatable(o, { __index = function(_, k) return methods[k] or (k:match("^%u") and noop or nil) end })
end
methods = {
    SetScript = function(self, n, f) self.scripts[n] = f end,
    GetScript = function(self, n) return self.scripts[n] end,
    Show = function(self) self.shown = true; if self.scripts.OnShow then self.scripts.OnShow(self) end end,
    Hide = function(self) local was = self.shown; self.shown = false; if was and self.scripts.OnHide then self.scripts.OnHide(self) end end,
    IsShown = function(self) return self.shown end,
    SetText = function(self, t) self.text = t end,
    GetText = function(self) return self.text end,
    GetStringWidth = function(self) return 40 end,
    GetName = function(self) return self.name end,
    GetFrameLevel = function() return 1 end,
    GetHeight = function(self) return self.h or 100 end,
    GetWidth = function(self) return self.w or 40 end,
    SetSize = function(self, w, h) self.w, self.h = w, h end,
    SetWidth = function(self, w) self.w = w end,
    SetHeight = function(self, h) self.h = h end,
    GetPoint = function() return "CENTER", nil, "CENTER", 5, 6 end,
    SetPoint = function(self, ...) self.points = self.points or {}; self.points[#self.points + 1] = { ... } end,
    ClearAllPoints = function(self) self.points = {} end,
    SetColorTexture = function(self, r, g, b, a) self.color = { r, g, b, a } end,
    SetTextColor = function(self, r, g, b) self.textColor = { r, g, b } end,
    SetVertexColor = function(self, r, g, b) self.vertex = { r, g, b } end,
    SetDesaturated = function(self, v) self.desat = v end,
    SetTexture = function(self, p) self.texture = p end,
    GetVerticalScroll = function(self) return self.scroll end,
    SetVerticalScroll = function(self, v) self.scroll = v end,
    GetVerticalScrollRange = function(self) return self.range or 0 end,
    CreateTexture = function(self) return newObj("Texture") end,
    CreateFontString = function(self) local f = newObj("FontString"); frames[#frames + 1] = f; return f end,
}
frames = {}
CreateFrame = function(kind, name, parent)
    local f = newObj(kind)
    f.name = name
    f.parent = parent
    frames[#frames + 1] = f
    if name then _G[name] = f end
    return f
end
UIParent = newObj("Frame")
UISpecialFrames = {}
date = os.date
WarcraftLoreDB = {}
clicksRegistered, tooltips, hidden = {}, {}, 0
chat = {}
local C = {
    FONT_TITLE = "t", FONT_BODY = "b",
    SetFont = noop, SetTiledTexture = noop, ApplyCircleMask = noop, GetMinimap = function() return nil end,
    MinimapEdgeOffset = function() return nil end, MinimapCursorAngle = function() return nil end,
    RegisterClicks = function(b) clicksRegistered[b] = true end,
    RegisterEscapeClose = function(f) table.insert(UISpecialFrames, f:GetName()) end,
    SetIconTexture = function(t, path, fb)
        if path == "bad" then t:SetTexture(fb); return false end
        t:SetTexture(path); return true
    end,
    ShowTooltip = function(owner, anchor, lines) tooltips[#tooltips + 1] = lines end,
    HideTooltip = function() hidden = hidden + 1 end,
    Now = function() return 1000 end,
}
ns = { L = setmetatable({}, { __index = function(_, k) return k end }), Compat = C, MetCounts = function() return {}, { met = 3, total = 10 } end }
"""

LOAD = """
function load(src, name)
    assert(loadstring(src, name))('WarcraftLore', ns)
end
"""

LIST = """
ACH = {
    { id = "a", title = "First Steps", desc = "Meet a veteran.", category = "milestone", progress = 1, total = 1, done = true, earned = 1759449600, icon = "ico/a" },
    { id = "b", title = "Horde Hero", desc = "Meet 12 Horde veterans.", category = "game", progress = 7, total = 12, done = false, icon = "bad" },
    { id = "c", title = "Zone Walker", desc = "Meet everyone in a zone.", category = "zone", progress = 2, total = 5, done = false, icon = "ico/c" },
    { id = "d", title = "Inner Circle", desc = "Meet a circle.", category = "circle", progress = 5, total = 5, done = true, earned = 1759449600, icon = "ico/d" },
    { id = "e", title = "Secret", desc = "Something odd.", category = "special", progress = 0, total = 1, done = false, icon = "ico/e" },
    { id = "f", title = "Second Game", desc = "Game two.", category = "game", progress = 12, total = 12, done = true, earned = 1759449600, icon = "ico/f" },
}
ns.Achievements = {
    List = function() return ACH end,
    Counts = function() return 3, 6 end,
}
"""


def check(name, cond, detail=""):
    print(("ok   " if cond else "FAIL ") + name + (f"  ({detail})" if detail and not cond else ""))
    return cond


def main():
    lua = lupa.LuaRuntime(unpack_returned_tuples=True)
    lua.execute(STUBS)
    lua.execute(LOAD)
    ev = lua.eval
    load = lua.eval("load")
    # Real Style.lua on the fake client, then Journal.lua; Core's journal command is tested separately.
    load((ADDON / "Style.lua").read_text(encoding="utf-8"), "Style.lua")
    load((ADDON / "Journal.lua").read_text(encoding="utf-8"), "Journal.lua")
    r = []
    r.append(check("Journal.lua loads", ev("ns.Journal ~= nil")))
    r.append(check("window is built lazily", ev("WarcraftLoreJournal == nil")))
    r.append(check("Refresh before build does nothing", ev("(function() ns.Journal.Refresh(); return true end)()")))

    # --- missing ns.Achievements
    lua.execute("ns.Journal.Toggle()")
    r.append(check("Toggle builds and shows the window", ev("WarcraftLoreJournal:IsShown()")))
    r.append(check("Esc closes it (registered in UISpecialFrames)", ev("UISpecialFrames[1]") == "WarcraftLoreJournal"))
    r.append(check("no ns.Achievements: no error and a message",
                   ev("(function() for _, f in ipairs(frames) do if f.text == 'Achievements are not available.' then return f.shown end end end)()") is True))
    lua.execute("ns.Journal.Toggle()")
    r.append(check("Toggle closes it again", ev("WarcraftLoreJournal:IsShown()") is False))

    # --- with data
    lua.execute(LIST)
    lua.execute("ns.Journal.Show()")
    lua.execute("""
        function visible()
            local n = 0
            for _, f in ipairs(frames) do if f.title and f.shown and f.data then n = n + 1 end end
            return n
        end
        function rowFor(id)
            for _, f in ipairs(frames) do if f.data and f.data.id == id and f.shown then return f end end
        end
        function summaryText()
            for _, f in ipairs(frames) do if f.text and tostring(f.text):find('achievements') and not tostring(f.text):find('available') then return f.text end end
        end
        function chipFor(label)
            for _, f in ipairs(frames) do if f.kind == 'Button' and f.label and f.label.text == label then return f end end
        end
    """)
    r.append(check("message gone with data",
                   ev("(function() for _, f in ipairs(frames) do if f.text == 'Achievements are not available.' then return f.shown end end end)()") in (None, False)))
    r.append(check("six rows for All", ev("visible()") == 6, ev("visible()")))
    summary = ev("summaryText()")
    r.append(check("summary text '3 of 6 achievements'", summary and summary.replace("|cffe0b84a", "").replace("|r", "") == "3 of 6 achievements", summary))

    # --- chips filter
    expected = {"All": 6, "Milestones": 1, "Games": 2, "Zones": 1, "Circles": 1, "Special": 1}
    for label, count in expected.items():
        lua.execute(f"chipFor('{label}').scripts.OnClick()")
        r.append(check(f"chip {label} shows {count}", ev("visible()") == count, ev("visible()")))
    lua.execute("chipFor('Games').scripts.OnClick()")
    r.append(check("active chip is highlighted", ev("chipFor('Games').on") is True and ev("chipFor('Zones').on") is False))
    r.append(check("rows are pooled and reused", ev("(function() local n = 0 for _, f in ipairs(frames) do if f.data ~= nil or f.title then n = n + 1 end end return n end)()") >= 6))
    lua.execute("chipFor('All').scripts.OnClick()")

    # --- styling
    gold = ev("ns.Style.COL.gold[1]")
    done, notdone = ev("rowFor('a')"), ev("rowFor('b')")
    r.append(check("done row: golden title, full-color icon",
                   abs(done.title.textColor[1] - gold) < 1e-6 and done.icon.desat is False and done.icon.vertex[1] == 1))
    r.append(check("not-done row: muted title, desaturated dim icon",
                   abs(notdone.title.textColor[1] - gold) > 1e-6 and notdone.icon.desat is True and notdone.icon.vertex[1] < 1))
    r.append(check("done row shows the earned date without leading zero",
                   done.date.text == lua.eval("date('%d', 1759449600) + 0 .. ' ' .. date('%b %Y', 1759449600)"), done.date.text))
    r.append(check("not-done row shows no date", notdone.date.text == ""))
    r.append(check("progress text 7/12", notdone.count.text == "7/12", notdone.count.text))
    r.append(check("one-step achievement has no progress text", rowFor_text(lua, "a") == ""))
    r.append(check("bad icon falls back", notdone.icon.texture == "Interface\\Icons\\INV_Misc_QuestionMark", notdone.icon.texture))
    r.append(check("done row border is gold, not-done is not",
                   abs(done.edges[1].color[1] - gold) < 1e-6 and abs(notdone.edges[1].color[1] - gold) > 1e-6))

    # --- tooltip
    lua.execute("rowFor('b').scripts.OnEnter(rowFor('b'))")
    tip = lua.eval("tooltips[#tooltips]")
    lines = [tip[i + 1][1] for i in range(len(tip))]
    r.append(check("tooltip: title, description, progress",
                   lines[0] == "Horde Hero" and lines[1].startswith("Meet 12") and "7/12" in lines[2], lines))

    # --- public Refresh picks up changes
    lua.execute("ACH[2].done = true; ACH[2].progress = 12; ACH[2].earned = 1759449600; ns.Achievements.Counts = function() return 4, 6 end; ns.Journal.Refresh()")
    r.append(check("Refresh updates summary and row",
                   ev("summaryText()").replace("|cffe0b84a", "").replace("|r", "") == "4 of 6 achievements" and ev("rowFor('b').done") is True))

    # --- wheel scrolling
    lua.execute("""
        local scroll
        for _, f in ipairs(frames) do if f.kind == 'ScrollFrame' then scroll = f end end
        scroll.range = 200
        scroll.scripts.OnMouseWheel(scroll, -1)
        scrolled = scroll.scroll
    """)
    r.append(check("mouse wheel scrolls the list", ev("scrolled") == 64, ev("scrolled")))

    # --- position
    lua.execute("WarcraftLoreJournal.scripts.OnDragStop(WarcraftLoreJournal)")
    r.append(check("position saved in journalPos", ev("WarcraftLoreDB.journalPos.x") == 5))
    lua.execute("ns.Journal.ResetPosition()")
    r.append(check("ResetPosition clears journalPos", ev("WarcraftLoreDB.journalPos") is None))

    # --- every Button registered for clicks
    unreg = ev("(function() local n = 0 for _, f in ipairs(frames) do if f.kind == 'Button' and not clicksRegistered[f] then n = n + 1 end end return n end)()")
    r.append(check("every Button registered for clicks", unreg == 0, unreg))

    # --- /wcl journal and the minimap shift-click
    r.append(check("Core.lua has the journal command and help line", core_ok()))
    r.append(check("Minimap.lua shift-click opens the journal", minimap_ok()))
    r.append(check("Browser.lua has a Journal button that opens it", browser_ok()))

    print()
    print("ALL OK" if all(r) else "FAILURES")
    raise SystemExit(0 if all(r) else 1)


def rowFor_text(lua, id_):
    return lua.eval(f"rowFor('{id_}').count.text") or ""


def core_ok():
    src = (ADDON / "Core.lua").read_text(encoding="utf-8")
    return "journal = function()" in src and "ns.Journal.Toggle()" in src and "/wcl journal" in src \
        and "ns.Journal.ResetPosition()" in src


def minimap_ok():
    src = (ADDON / "Minimap.lua").read_text(encoding="utf-8")
    return "Shift-click" in src and "Lore Journal" in src and "IsShiftKeyDown" in src and "ns.Journal.Toggle()" in src


def browser_ok():
    src = (ADDON / "Browser.lua").read_text(encoding="utf-8")
    return 'jl:SetText(L["Journal"])' in src and "ns.Journal.Toggle()" in src


if __name__ == "__main__":
    main()

"""The alert pill (Toast.lua) in Lua 5.1 via lupa with a fake client: a click on the pill always
opens the named veteran, the "+N more" button opens (never toggles) the Veterans list for the
current zone, and SetMore also reaches a pill that is still waiting in the queue.

Usage: python tests/test_toast.py   (needs: pip install lupa)
"""

from pathlib import Path

import lupa.lua51 as lupa

ADDON = Path(__file__).resolve().parent.parent / "WarcraftLore"

STUBS = """
local noop = function() end
local function newObj(kind)
    local o = { kind = kind, scripts = {}, shown = true, children = {} }
    local methods = {
        SetScript = function(self, n, f) self.scripts[n] = f end,
        Show = function(self) self.shown = true end,
        Hide = function(self) self.shown = false end,
        IsShown = function(self) return self.shown end,
        SetText = function(self, t) self.text = t end,
        IsMouseOver = function() return false end,
        GetPoint = function() return "TOP", nil, "TOP", 0, 0 end,
        CreateTexture = function(self) return newObj("Texture") end,
        CreateFontString = function(self) return newObj("FontString") end,
    }
    return setmetatable(o, { __index = function(_, k) return methods[k] or (k:match("^%u") and noop or nil) end })
end
frames = {}
CreateFrame = function(kind, name, parent)
    local f = newObj(kind)
    frames[#frames + 1] = f
    return f
end
UIParent = newObj("Frame")
WarcraftLoreDB = {}
opened, browserCalls = {}, {}
zoneName = "Orgrimmar"
local Style = { COL = setmetatable({}, { __index = function() return { 1, 1, 1 } end }),
    text = function() return newObj("FontString") end,
    outline = function() return { newObj("Texture") } end }
ns = {
    Style = Style,
    FeatureOff = function() return false end,
    GamesLabel = function() return "WC3" end,
    GamesInOrder = function() return { "WC3" } end,
    GameRGB = function() return 1, 1, 1 end,
    UI = { ShowEntry = function(id) opened[#opened + 1] = id end },
    Browser = {
        Toggle = function() browserCalls[#browserCalls + 1] = "toggle" end,
        ShowZone = function(z) browserCalls[#browserCalls + 1] = "zone:" .. tostring(z) end,
    },
}
ns.Compat = {
    FONT_TITLE = "t", FONT_BODY = "b",
    RegisterClicks = noop, ApplyCircleMask = noop, SetBlendMode = noop, SetUnitPortrait = function() return false end,
    CreatePulse = function() return { Play = noop, Stop = noop } end,
    Now = function() return 1000 end,
    IsShiftDown = function() return false end,
    GetZoneName = function() return zoneName end,
}
"""


def check(name, cond, detail=""):
    print(("ok   " if cond else "FAIL ") + name + (f"  ({detail})" if detail and not cond else ""))
    return cond


def main():
    lua = lupa.LuaRuntime(unpack_returned_tuples=True)
    lua.execute(STUBS)
    lua.eval("function(src) assert(loadstring(src, 'Toast.lua'))('WarcraftLore', ns) end")(
        (ADDON / "Toast.lua").read_text(encoding="utf-8"))
    ev = lua.eval
    lua.execute("E = function(n) return { name = 'V' .. n } end")
    r = []

    # Pill with "+N more": the pill opens the named veteran; the +N button opens the zone list.
    lua.execute("ns.Toast.Show(101, E(101), 'Alpha', nil, 2)")
    lua.execute("""
        pill, more = nil, nil
        for _, f in ipairs(frames) do
            if f.kind == 'Button' and f.scripts.OnClick then
                if f.scripts.OnUpdate then pill = f else more = more or f end
            end
        end
    """)
    r.append(check("pill and +N button exist", ev("pill ~= nil and more ~= nil")))
    r.append(check("+N button shown with a count", ev("more.shown") is True and ev("pill.moreText.text") == "+2 more"))
    lua.execute("pill.scripts.OnClick(pill, 'LeftButton')")
    r.append(check("pill click opens the named veteran even with +N more",
                   ev("#opened") == 1 and ev("opened[1]") == 101 and ev("#browserCalls") == 0))

    lua.execute("ns.Toast.Show(102, E(102), 'Beta', nil, 3)")
    lua.execute("""
        browserCalls = {}
        more.scripts.OnClick(more, 'LeftButton')
        more.scripts.OnClick(more, 'LeftButton')
    """)
    r.append(check("+N button opens the list for the current zone, twice (never toggles)",
                   ev("#browserCalls") == 2 and ev("browserCalls[1]") == "zone:Orgrimmar"
                   and ev("browserCalls[2]") == "zone:Orgrimmar"))
    lua.execute("browserCalls = {}; zoneName = nil; more.scripts.OnClick(more, 'LeftButton')")
    r.append(check("unknown zone still opens the list", ev("browserCalls[1]") == "zone:nil"))

    # SetMore on a pill that is still waiting in the queue (3 pills on screen at most).
    lua.execute("""
        for i = 201, 204 do ns.Toast.Show(i, E(i), 'N' .. i) end
        ns.Toast.SetMore(204, 5)
        ns.Toast.SetMore(201, 1)
    """)
    lua.execute("""
        moreTexts = {}
        for _, f in ipairs(frames) do
            if f.moreText and f.moreText.text then moreTexts[#moreTexts + 1] = f.moreText.text end
        end
    """)
    lua.execute("""
        waiting = nil
        for _, f in ipairs(frames) do
            if f.npcID == 204 then waiting = f end
        end
    """)
    r.append(check("queued pill is not on screen yet", ev("waiting") is None))
    lua.execute("""
        for _, f in ipairs(frames) do
            if f.npcID == 201 or f.npcID == 202 then f.scripts.OnClick(f, 'RightButton') end
        end
        for _, f in ipairs(frames) do
            if f.npcID == 204 and not f.pool then waiting = f end
        end
    """)
    r.append(check("queued pill shows +5 more once it appears",
                   ev("waiting ~= nil") and ev("waiting.moreText.text") == "+5 more" and ev("waiting.moreBtn.shown") is True))

    print(f"\n{sum(r)}/{len(r)} passed")
    raise SystemExit(0 if all(r) else 1)


if __name__ == "__main__":
    main()

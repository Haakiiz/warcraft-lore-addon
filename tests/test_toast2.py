"""The alert pill (Toast.lua) in Lua 5.1 via lupa with a fake client: a queued pill whose unit token
now points at another unit does not show that unit's portrait, a pill without a usable unit shows
the entry's role icon (question mark as the last resort), and "+N more" opens the list for the
data's English zone name (Browser.HereZone) with the client's name as fallback.

Usage: python tests/test_toast2.py   (needs: pip install lupa)
"""

from pathlib import Path

import lupa.lua51 as lupa

ADDON = Path(__file__).resolve().parent.parent / "WarcraftLore"
QUESTION = "Interface\\Icons\\INV_Misc_QuestionMark"

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
        SetTexture = function(self, t) self.texture = t end,
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
browserCalls, portraitCalls = {}, {}
guids, zoneName, hereZone = {}, "Orgrimmar", nil
local Style = { COL = setmetatable({}, { __index = function() return { 1, 1, 1 } end }),
    text = function() return newObj("FontString") end,
    outline = function() return { newObj("Texture") } end }
ns = {
    L = setmetatable({}, { __index = function(_, k) return k end }),
    Style = Style,
    FeatureOff = function() return false end,
    Guard = function(key, label, fn) return function(...) pcall(fn, ...) end end,
    GamesLabel = function() return "WC3" end,
    GamesInOrder = function() return { "WC3" } end,
    GameRGB = function() return 1, 1, 1 end,
    FOREVER_ALIAS = { [900] = 100 },
    UI = {
        ShowEntry = noop,
        Timeline = function(entry) return entry.appearances or {} end,
        RoleIcon = function(app) return app.icon or "INV_Misc_Map_01" end,
    },
    Browser = {
        ShowZone = function(z) browserCalls[#browserCalls + 1] = "zone:" .. tostring(z) end,
        HereZone = function() return hereZone end,
    },
}
ns.Compat = {
    FONT_TITLE = "t", FONT_BODY = "b",
    RegisterClicks = noop, ApplyCircleMask = noop, SetBlendMode = noop,
    SetUnitPortrait = function(tex, unit) portraitCalls[#portraitCalls + 1] = unit; tex.texture = "unit:" .. unit; return true end,
    CreatePulse = function() return { Play = noop, Stop = noop } end,
    Now = function() return 1000 end,
    IsShiftDown = function() return false end,
    GetZoneName = function() return zoneName end,
    UnitGUID = function(unit) return guids[unit] end,
    NPCIDFromGUID = function(guid)
        if type(guid) ~= "string" then return nil, nil end
        return tonumber(guid:match("(%d+)-%d+$")), "Creature"
    end,
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
    lua.execute("""
        E = function(n, icon) return { name = 'V' .. n, appearances = icon and { { icon = icon } } or nil } end
        pillOf = function(id)
            for _, f in ipairs(frames) do
                if f.npcID == id and not f.pool then return f end
            end
        end
        moreOf = function()
            for _, f in ipairs(frames) do
                if f.kind == 'Button' and f.scripts.OnClick and not f.scripts.OnUpdate then return f end
            end
        end
        clearAll = function()
            for _, f in ipairs(frames) do
                if f.npcID and not f.pool then f.scripts.OnClick(f, 'RightButton') end
            end
            portraitCalls = {}
        end
    """)
    r = []

    # Fix 1: the unit token must still resolve to this NPC.
    lua.execute("""
        guids.target = 'Creature-0-0-0-0-100-0'
        guids.nameplate1 = 'Creature-0-0-0-0-555-0'
        ns.Toast.Show(100, E(100, 'INV_Sword_27'), 'Good', 'target')
        ns.Toast.Show(101, E(101, 'INV_Scroll_03'), 'Stale', 'nameplate1')
        ns.Toast.Show(102, E(102), 'NoGuid', 'nameplate9')
    """)
    r.append(check("matching unit gives the unit portrait", ev("pillOf(100).portrait.texture") == "unit:target"))
    r.append(check("stale token (other NPC) falls back to the role icon",
                   ev("pillOf(101).portrait.texture") == "Interface\\Icons\\INV_Scroll_03"))
    r.append(check("stale token never reached SetUnitPortrait", ev("table.concat(portraitCalls, ',')") == "target"))
    r.append(check("unreadable GUID counts as no unit (question mark without a timeline)",
                   ev("pillOf(102).portrait.texture") == QUESTION))

    # A Forever ID on the unit (900) counts as the pill's NPC (100).
    lua.execute("""
        clearAll()
        guids.nameplate2 = 'Creature-0-0-0-0-900-0'
        ns.Toast.Show(100, E(100), 'Alias', 'nameplate2')
    """)
    r.append(check("Forever alias of the NPC id is accepted", ev("pillOf(100).portrait.texture") == "unit:nameplate2"))

    # A throwing GUID read (secret value) must not break the pill.
    lua.execute("""
        clearAll()
        local old = ns.Compat.UnitGUID
        ns.Compat.UnitGUID = function() error("secret") end
        ns.Toast.Show(103, E(103, 'INV_Misc_Note_01'), 'Err', 'target')
        ns.Compat.UnitGUID = old
    """)
    r.append(check("erroring GUID read falls back to the role icon",
                   ev("pillOf(103).portrait.texture") == "Interface\\Icons\\INV_Misc_Note_01"))

    # Fix 2: no unit -> the entry's role icon; nothing known -> question mark.
    lua.execute("""
        clearAll()
        ns.Toast.Show(104, E(104, 'INV_Sword_27'), 'Pos', nil)
        local old = ns.UI.Timeline
        ns.UI.Timeline = nil
        ns.Toast.Show(105, E(105), 'Bare', nil)
        ns.UI.Timeline = old
    """)
    r.append(check("no unit shows the first appearance's role icon",
                   ev("pillOf(104).portrait.texture") == "Interface\\Icons\\INV_Sword_27"))
    r.append(check("no unit and no timeline keeps the question mark", ev("pillOf(105).portrait.texture") == QUESTION))

    # Fix 3: "+N more" uses the English zone name from Browser.HereZone.
    lua.execute("""
        clearAll()
        ns.Toast.Show(106, E(106), 'More', nil, 4)
        zoneName = 'Orgrimmar'; hereZone = 'Durotar'
        browserCalls = {}
        moreOf().scripts.OnClick(moreOf(), 'LeftButton')
    """)
    r.append(check("+N more passes the data's zone name, not the translated one", ev("browserCalls[1]") == "zone:Durotar"))
    lua.execute("""
        hereZone = nil; zoneName = 'Orgrimmar'; browserCalls = {}
        moreOf().scripts.OnClick(moreOf(), 'LeftButton')
    """)
    r.append(check("HereZone nil falls back to the client's zone name", ev("browserCalls[1]") == "zone:Orgrimmar"))
    lua.execute("""
        ns.Browser.HereZone = nil; browserCalls = {}
        moreOf().scripts.OnClick(moreOf(), 'LeftButton')
    """)
    r.append(check("missing HereZone falls back too", ev("browserCalls[1]") == "zone:Orgrimmar"))

    print(f"\n{sum(r)}/{len(r)} passed")
    raise SystemExit(0 if all(r) else 1)


if __name__ == "__main__":
    main()

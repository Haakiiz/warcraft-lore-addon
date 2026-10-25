"""Classic Era support (Lua 5.1 via lupa, with WoW stubs): the real Compat.lua on a Classic-like client
(no secret values, no TooltipDataProcessor) falls back to the older hooks, ClientFlavor tells Forever and
Classic Era apart, the level cap is 60 on Classic Era, the .toc lists both clients, and the database only
uses NPC IDs and map IDs that Classic Era has.

Usage: python tests/test_classic.py   (needs: pip install lupa)
"""

import re
from pathlib import Path

import lupa.lua51 as lupa  # WoW runs Lua 5.1

ADDON = Path(__file__).resolve().parent.parent / "WarcraftLore"

# A Classic Era client: build 1.15.9, WOW_PROJECT_CLASSIC, no issecretvalue, no TooltipDataProcessor,
# GameTooltip with OnTooltipSetUnit and HookScript.
CLASSIC = """
WOW_PROJECT_MAINLINE, WOW_PROJECT_CLASSIC, WOW_PROJECT_ID = 1, 2, 2
GetBuildInfo = function() return "1.15.9", "60000", "Jul 1 2026", 11509 end
"""

FOREVER = """
GetBuildInfo = function() return "1.60.1", "0", "", 16001 end
issecretvalue = function() return false end
"""

RETAIL = """
WOW_PROJECT_MAINLINE, WOW_PROJECT_CLASSIC, WOW_PROJECT_ID = 1, 2, 1
GetBuildInfo = function() return "12.0.7", "0", "", 120007 end
"""

TOOLTIP = """
hooks = {}
GameTooltip = {
    HasScript = function(self, name) return name == "OnTooltipSetUnit" or name == "OnShow" end,
    HookScript = function(self, name, fn) hooks[name] = fn end,
    GetUnit = function() return "Thrall", "mouseover" end,
    AddLine = function(self, t) added = t end,
    NumLines = function() return 1 end,
    Show = function() end,
}
GameTooltipTextLeft1 = { GetText = function() return "Uther's Tomb" end }
strsplit = function(sep, s)
    local out = {}
    for part in (s .. sep):gmatch("(.-)" .. sep:gsub("%-", "%%-")) do out[#out + 1] = part end
    return unpack(out)
end
"""


def compat(client):
    lua = lupa.LuaRuntime(unpack_returned_tuples=True)
    lua.execute(client + TOOLTIP + "ns = {}")
    run = lua.eval("function(src, name) assert(loadstring(src, name))('WarcraftLore', ns) end")
    run((ADDON / "Compat.lua").read_text(encoding="utf-8"), "Compat.lua")
    return lua


def achievements(flavor):
    """Achievements.lua on top of Data/SavedData/Core, with a stub Compat that reports `flavor`."""
    lua = lupa.LuaRuntime(unpack_returned_tuples=True)
    lua.execute("""
        local noop = function() end
        local function stub() return setmetatable({}, { __index = function() return noop end }) end
        ns = { L = setmetatable({}, { __index = function(_, k) return k end }), Compat = stub() }
        ns.Compat.ClientFlavor = function() return "%s" end
        ns.Compat.After = function(fn) fn() end
        CreateFrame = function() return stub() end
        SlashCmdList = {}
        time = os.time
        date = os.date
    """ % flavor)
    run = lua.eval("function(src, name) assert(loadstring(src, name))('WarcraftLore', ns) end")
    for name in ("Data.lua", "SavedData.lua", "Core.lua", "Achievements.lua"):
        run((ADDON / name).read_text(encoding="utf-8"), name)
    lua.execute("WarcraftLoreDB = { schema = 3, met = {}, achievements = {} }")
    return lua


def check(name, cond, detail=""):
    print(("ok   " if cond else "FAIL ") + name + (f"  ({detail})" if detail and not cond else ""))
    return cond


def main():
    r = []

    # 1. ClientFlavor
    r.append(check("Classic Era 11509 -> classic", compat(CLASSIC).eval("ns.Compat.ClientFlavor()") == "classic"))
    r.append(check("Forever 16001 -> forever", compat(FOREVER).eval("ns.Compat.ClientFlavor()") == "forever"))
    r.append(check("Retail 120007 -> other", compat(RETAIL).eval("ns.Compat.ClientFlavor()") == "other"))
    r.append(check("no GetBuildInfo -> forever", compat("").eval("ns.Compat.ClientFlavor()") == "forever"))
    r.append(check("/wcl debug report carries the flavor",
                   compat(CLASSIC).eval("ns.Compat.Report().flavor") == "classic"))

    # 2. The real Compat.lua on Classic Era
    lua = compat(CLASSIC)
    r.append(check("IsSecret is false without issecretvalue", lua.eval("ns.Compat.IsSecret('x')") is False))
    method = lua.eval("ns.Compat.HookUnitTooltip(function(t, unit, guid) gotUnit = unit end)")
    r.append(check("unit tooltip falls back to OnTooltipSetUnit", method == "OnTooltipSetUnit", method))
    lua.execute("hooks.OnTooltipSetUnit(GameTooltip)")
    r.append(check("OnTooltipSetUnit passes the unit on", lua.eval("gotUnit") == "mouseover"))
    method = lua.eval("ns.Compat.HookObjectTooltip(function(t, text) gotText = text end)")
    r.append(check("object tooltip falls back to OnShow", method == "OnShow", method))
    lua.execute("hooks.OnShow(GameTooltip)")
    r.append(check("OnShow reads the first tooltip line", lua.eval("gotText") == "Uther's Tomb"))
    npc = lua.eval("ns.Compat.NPCIDFromGUID('Creature-0-5250-1-123-4949-0000ABCDEF')")
    r.append(check("Classic Era creature GUID gives the NPC ID", npc == (4949, "Creature"), npc))

    # 3. Level cap and icons
    classic, forever = achievements("classic"), achievements("forever")
    r.append(check("level cap 60 on Classic Era", classic.eval("ns.Achievements.LEVEL_CAP") == 60))
    r.append(check("level cap 30 on Forever", forever.eval("ns.Achievements.LEVEL_CAP") == 30))
    later_classic = classic.eval("select(3, ns.Achievements.Counts())")
    later_forever = forever.eval("select(3, ns.Achievements.Counts())")
    r.append(check("no achievement waits for a later cap on Classic Era", later_classic == 0, later_classic))
    r.append(check("some achievements wait on Forever", later_forever > 0, later_forever))
    icons = classic.eval("function() local t = {} for _, a in ipairs(ns.Achievements.List()) do "
                         "t[#t + 1] = a.icon end return table.concat(t, ';') end")()
    r.append(check("no Wrath-era Achievement_ icons on Classic Era", "Achievement_" not in icons))

    # 4. The .toc lists both clients in one Interface line
    toc = (ADDON / "WarcraftLore.toc").read_text(encoding="utf-8-sig")
    m = re.search(r"^## Interface:\s*(.+)$", toc, re.M)
    values = [v.strip() for v in m.group(1).split(",")] if m else []
    r.append(check(".toc Interface lists Forever and Classic Era", "16001" in values
                   and any(v.startswith("115") for v in values), values))
    r.append(check("no client-specific .toc files (one .toc for every client)",
                   [p.name for p in ADDON.glob("*.toc")] == ["WarcraftLore.toc"]))

    # 5. The data only uses what Classic Era has
    data = (ADDON / "Data.lua").read_text(encoding="utf-8")
    ids = [int(x) for x in re.findall(r"^\s*\[(\d+)\] = \{", data, re.M)]
    high = [i for i in ids if i > 200000]
    r.append(check("no Season of Discovery or later NPC IDs (> 200000)", ids and not high, high))
    core = (ADDON / "Core.lua").read_text(encoding="utf-8")
    block = core[core.index("local ZONE_MAPS = {"):core.index("ns.ZONE_MAPS = ZONE_MAPS")]
    rows = re.findall(r'\["([^"]+)"\] = \{ ([\d, ]+) \}', block)
    no_classic = [z for z, nums in rows if not any(1400 <= int(n) < 1460 for n in nums.split(","))]
    r.append(check("every zone in ZONE_MAPS has a Classic Era uiMapID", rows and not no_classic, no_classic))

    passed = sum(1 for x in r if x)
    print(f"\n{passed}/{len(r)} passed")
    raise SystemExit(0 if passed == len(r) else 1)


if __name__ == "__main__":
    main()

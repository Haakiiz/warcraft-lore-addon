"""Zone atlas in the Veterans list (Browser.lua) in Lua 5.1 via lupa with a fake client:
met/total per zone (an alsoIn zone counts too, merged NPC IDs count once), the numbers follow
MarkMet, and the "This zone" action for a known and an unknown zone.

Usage: python tests/test_atlas.py   (needs: pip install lupa)
"""

from pathlib import Path

import lupa.lua51 as lupa

ADDON = Path(__file__).resolve().parent.parent / "WarcraftLore"

STUBS = """
local noop = function() end
local function newObj()
    return setmetatable({}, { __index = function(_, k) return k:match("^%u") and noop or nil end })
end
CreateFrame = function() return newObj() end
UIParent = newObj()
WarcraftLoreDB = {}
zoneName = "Orgrimmar"
met = {}
local COL = setmetatable({}, { __index = function() return { 1, 1, 1 } end })
ns = {
    Style = {
        COL = COL, PAD = 12, HEADER = 28, BAND = 8,
        HEX_MUTED = "|cffa79d8a", HEX_MET = "|cff6fcf7f", END = "|r",
        solid = newObj, text = newObj, box = newObj, outline = newObj,
    },
    Compat = { FONT_TITLE = "t", FONT_BODY = "b", GetZoneName = function() return zoneName end },
    GAME_ORDER = { "WC3" },
    CodesLabel = function() return "WC3" end,
    GameRGB = function() return 1, 1, 1 end,
    NPCS = {
        [1] = { name = "Thrall", zone = "Orgrimmar" },
        [2] = { name = "Thrall", zone = "Orgrimmar" },                       -- same veteran, merged
        [3] = { name = "Vol'jin", zone = "Orgrimmar", alsoIn = { "Durotar" } },
        [4] = { name = "Rexxar", zone = "Desolace" },
        [5] = { name = "Cairne", zone = "Thunder Bluff", alsoIn = { "Orgrimmar" } },
    },
    IsMet = function(id) return met[id] == true end,
}
ns.GroupMet = function(g)
    for _, id in ipairs(g.ids) do if ns.IsMet(id) then return true end end
    return false
end
local groups = {
    { id = 1, entry = ns.NPCS[1], ids = { 1, 2 }, codes = { "WC3" }, idSet = { [1] = true, [2] = true } },
    { id = 3, entry = ns.NPCS[3], ids = { 3 }, codes = { "WC3" }, idSet = { [3] = true } },
    { id = 4, entry = ns.NPCS[4], ids = { 4 }, codes = { "WC3" }, idSet = { [4] = true } },
    { id = 5, entry = ns.NPCS[5], ids = { 5 }, codes = { "WC3" }, idSet = { [5] = true } },
}
ns.Veterans = function() return groups end
shown = {}
"""


def check(name, cond, detail=""):
    print(("ok   " if cond else "FAIL ") + name + (f"  ({detail})" if detail and not cond else ""))
    return cond


def main():
    lua = lupa.LuaRuntime(unpack_returned_tuples=True)
    lua.execute(STUBS)
    lua.eval("function(src) assert(loadstring(src, 'Browser.lua'))('WarcraftLore', ns) end")(
        (ADDON / "Browser.lua").read_text(encoding="utf-8"))
    ev = lua.eval
    lua.execute("""
        -- Record what the zone action asks for instead of building the whole window.
        ns.Browser.ShowZone = function(z) shown[#shown + 1] = z end
        function prog(z) local m, t = ns.Browser.ZoneProgress(z); return tostring(m) .. '/' .. tostring(t) end
    """)
    r = []
    r.append(check("Browser.lua loads", ev("ns.Browser ~= nil")))

    r.append(check("Orgrimmar counts its own and alsoIn veterans, merged IDs once",
                   ev("prog('Orgrimmar')") == "0/3"))
    r.append(check("alsoIn zone counts the veteran", ev("prog('Durotar')") == "0/1"))
    r.append(check("zone with one veteran", ev("prog('Desolace')") == "0/1"))
    r.append(check("unknown zone has no progress", ev("prog('Nowhere')") == "nil/nil"))

    # Counts are cached until the next Refresh; MarkMet makes the window refresh, which drops them.
    lua.execute("met[2] = true; met[3] = true")
    r.append(check("cache keeps the old numbers until Refresh", ev("prog('Orgrimmar')") == "0/3"))
    lua.execute("ns.Browser.Refresh(false)")
    r.append(check("Refresh recounts: merged group met once, alsoIn counted",
                   ev("prog('Orgrimmar')") == "2/3" and ev("prog('Durotar')") == "1/1"))
    r.append(check("a zone with nobody met stays at 0", ev("prog('Desolace')") == "0/1"))

    lua.execute("shown = {}")
    r.append(check("This zone in a known zone filters to it",
                   ev("ns.Browser.ThisZone()") is True and ev("shown[1]") == "Orgrimmar" and ev("#shown") == 1))
    lua.execute("shown = {}; zoneName = 'Stormwind City'")
    r.append(check("This zone in a zone without veterans does nothing",
                   ev("ns.Browser.ThisZone()") is False and ev("#shown") == 0))
    lua.execute("zoneName = nil")
    r.append(check("This zone with an unknown location does nothing",
                   ev("ns.Browser.ThisZone()") is False and ev("#shown") == 0))
    lua.execute("zoneName = 'Durotar'")
    r.append(check("This zone works for an alsoIn-only zone", ev("ns.Browser.ThisZone()") is True and ev("shown[1]") == "Durotar"))
    r.append(check("UpdateHere before the window exists is harmless", ev("pcall(ns.Browser.UpdateHere)") is True))

    # Widths: ~6 px per character (a pessimistic Friz Quadrata estimate at size 12).
    px = lambda t: 6 * len(t)
    lay = lua.eval("ns.Browser.FilterLayout()")
    zone_room = lay.zone - lay.chevronInset - lay.labelInset
    camp_room = lay.campaign - lay.chevronInset - lay.labelInset
    stat_room = lay.status - lay.labelInset * 2
    r.append(check("filter row keeps the v0.5 widths (Zone 168, Status 104)",
                   lay.zone == 168 and lay.status == 104 and lay.campaign >= 168))
    r.append(check("default 'Zone All zones' fits", px("Zone All zones") <= zone_room))
    r.append(check("default 'Campaign All campaigns' fits", px("Campaign All campaigns") <= camp_room,
                   f"{px('Campaign All campaigns')}>{camp_room}"))
    r.append(check("'Show Not met' fits", px("Show Not met") <= stat_room))
    src = (ADDON / "Browser.lua").read_text(encoding="utf-8")
    r.append(check("filter labels are one line (ellipsis when long)",
                   "b.label:SetWordWrap(false)" in src and 'SetPoint("RIGHT", withChevron' in src))
    r.append(check("This zone is no longer a filter-row button", "hereBtn = filterButton" not in src))
    # Count row: This zone, Clear filters and Hide book-only never overlap each other or the count text.
    book, here, clear = px("Hide book-only") + 16, px("This zone"), px("Clear filters")
    count_w = lua.eval("ns.Browser.CountRowWidth")(book, here, clear)
    book_x0 = lay.contentW - book
    here_x0 = book_x0 - 14 - here
    clear_x0 = here_x0 - 14 - clear
    r.append(check("This zone does not overlap Clear filters", here_x0 >= clear_x0 + clear + 14))
    r.append(check("count text stays left of Clear filters", 150 <= count_w <= clear_x0, str(count_w)))

    # The zone line with a second filter active must fit the count text (real string, 6 px/char).
    import re
    zones = set(re.findall(r'\bzone\s*=\s*"([^"]+)"', (ADDON / "Data.lua").read_text(encoding="utf-8")))
    longest = max(zones, key=len)
    strip = lambda t: re.sub(r"\|c[0-9a-fA-F]{8}|\|r", "", t)
    worst = strip(lua.eval("ns.Browser.ZoneLine")(99, 99, 98))
    r.append(check(f"zone line (longest zone '{longest}', plus 'showing') fits the count text",
                   px(worst) <= count_w and longest not in worst, f"{px(worst)} > {count_w}: {worst}"))

    print(f"\n{sum(r)}/{len(r)} passed")
    raise SystemExit(0 if all(r) else 1)


if __name__ == "__main__":
    main()

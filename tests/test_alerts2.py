"""Detection fixes in Core.lua, Compat.lua and SavedData.lua (Lua 5.1 via lupa, with WoW stubs):
no hint on a flight path, the map position as a soft hint, `roams`, city radius, the mouseover
alert, nameplate retries, memorials by zone and object ID, settings defaults on newer data, the
pill's own guard key, ns.Coords, /wcl debug's map line and an unreadable target.

Usage: python tests/test_alerts2.py   (needs: pip install lupa)
"""

import sys
from pathlib import Path

import lupa.lua51 as lupa  # WoW runs Lua 5.1

sys.path.insert(0, str(Path(__file__).resolve().parent))
import validate_db  # noqa: E402

ADDON = Path(__file__).resolve().parent.parent / "WarcraftLore"

STUBS = """
local noop = function() end
local function stub() return setmetatable({}, { __index = function() return noop end }) end
printed, timers, sounds, toasts, setMore, messages = {}, {}, 0, {}, {}, {}
guids, targetExists, targetSecret, inInstance, onTaxi = {}, true, false, false, false
mapPos, zoneMapID = nil, nil -- mapPos = { mapID, x, y } (x, y in 0..1)
ns = { L = setmetatable({}, { __index = function(_, k) return k end }), Compat = {
    Print = function(m) printed[#printed + 1] = m end,
    IsForever = function() return true end,
    UnitGUID = function(u) return guids[u] end,
    UnitName = function() return nil end,
    UnitExists = function() return targetExists, targetSecret end,
    NPCIDFromGUID = function(g)
        if not g then return nil, nil end
        local t, id = g:match("^(%a+)-(%d+)$")
        if t == "Creature" then return tonumber(id), t end
        return nil, g:match("^(%a+)")
    end,
    After = function(fn, s) timers[#timers + 1] = { fn = fn, s = s } end,
    PlayAlertSound = function() sounds = sounds + 1 end,
    InInstance = function() return inInstance end,
    OnTaxi = function() return onTaxi end,
    GetPlayerMapPos = function() if mapPos then return mapPos[1], mapPos[2], mapPos[3] end end,
    GetZoneMapID = function() return zoneMapID end,
    StartTicker = function(_, fn) ticker = fn return true end,
    RegisterEventSafe = function() return true end,
    EVENT_NAMEPLATE_ADDED = "NAME_PLATE_UNIT_ADDED",
    missing = {},
    Report = function() return {} end,
    HookUnitTooltip = function(cb) unitTooltip = cb return "stub" end,
    HookObjectTooltip = function(cb) objectTooltip = cb return "stub" end,
    ItemTextName = function() return itemTextName end,
    AddTooltipLine = function(_, text) tooltipLines[#tooltipLines + 1] = text end,
    GetRealmName = function() return "Realm" end,
} }
tooltipLines = {}
ns.Toast = { Show = function(id, e, who, unit, more) toasts[#toasts + 1] = { id = id, who = who, unit = unit, more = more } end,
    SetMore = function(id, n) setMore[#setMore + 1] = { id = id, n = n } end }
ns.UI = { Init = noop, IsShown = function() return false end, ShowMessage = function(m) messages[#messages + 1] = m end }
ns.Minimap = { Init = noop }
ns.SavedData = { Load = function() end, CharacterName = function() return "Arthas-Realm" end }
ns.Style = { theme = "wc2", ApplyTheme = function() end, ThemeLabel = function(n) return n end,
             OtherTheme = function() return "classic" end, RequestTheme = function() end }
WarcraftLoreDB = { alert = true, auto = false }
WarcraftLoreCharDB = {}
strtrim = function(s) return (s:gsub("^%s+", ""):gsub("%s+$", "")) end
SlashCmdList = {}
local onEvent
CreateFrame = function()
    local f = stub()
    f.SetScript = function(_, _, fn) onEvent = fn end
    return f
end
fire = function(...) return onEvent(nil, ...) end
time = os.time
-- Runs every pending timer (and the timers they start) once, in order.
function runTimers()
    local i = 1
    while timers[i] do
        timers[i].fn()
        i = i + 1
    end
    timers = {}
end
function at(mapID, x, y) mapPos = { mapID, x / 100, y / 100 } end
function hoverUnit(unit, guid) tooltipLines = {}; unitTooltip({}, unit, guid) end
function hoverObject(name, objectID) tooltipLines = {}; objectTooltip({}, name, false, objectID) end
"""


def runtime(files=("Data.lua", "Memorials.lua", "Core.lua")):
    lua = lupa.LuaRuntime(unpack_returned_tuples=True)
    lua.execute(STUBS)
    run = lua.eval("function(src, name) assert(loadstring(src, name))('WarcraftLore', ns) end")
    for name in files:
        run((ADDON / name).read_text(encoding="utf-8"), name)
    # Fake veterans: Alpha in Orgrimmar (a city), Durotar's Delta and Epsilon close together,
    # Rover who roams, Beta without coords.
    lua.execute("""
        ns.NPCS[900001] = { name = "Alpha", zone = "Orgrimmar", coords = "50.0, 50.0", appearances = { { game = "WC3" } } }
        ns.NPCS[900002] = { name = "Beta", appearances = { { game = "WC2" } } }
        ns.NPCS[900004] = { name = "Delta", zone = "Durotar", coords = "50.0, 50.0", appearances = { { game = "WC1" } } }
        ns.NPCS[900005] = { name = "Epsilon", zone = "Durotar", coords = "51.0, 50.0", appearances = { { game = "TFT" } } }
        ns.NPCS[900006] = { name = "Rover", zone = "Durotar", coords = "60.0, 60.0", roams = true, appearances = { { game = "WC2" } } }
        fire("ADDON_LOADED", "WarcraftLore")
    """)
    return lua


def check(name, cond, detail=""):
    print(("ok   " if cond else "FAIL ") + name + (f"  ({detail})" if detail and not cond else ""))
    return bool(cond)


def lines(lua):
    return [str(x) for x in lua.eval("printed").values()]


def main():
    r = []

    # 1. No hint on a flight path.
    lua = runtime()
    lua.execute("onTaxi = true; at(1411, 50, 50); ticker()")
    r.append(check("1. on a taxi: no hint", len(lines(lua)) == 0 and lua.eval("#toasts") == 0, lines(lua)))
    lua.execute("onTaxi = false; ticker()")
    r.append(check("1. off the taxi: the hint comes", len(lines(lua)) == 1, lines(lua)))

    # 2. A position match is a soft hint: own wording, no sound, a pill without a unit.
    lua = runtime()
    lua.execute("at(1411, 50, 48.5); ticker()")  # 1.5 from Delta, 1.8 from Epsilon: both in range (3)
    out = lines(lua)
    r.append(check("2. two hints in one check: ONE line naming both",
                   len(out) == 1 and "usually found near here" in out[0] and "Delta" in out[0] and "Epsilon" in out[0], out))
    r.append(check("2. hint: no sound", lua.eval("sounds") == 0))
    r.append(check("2. hint: one pill, no unit, '+1 more'",
                   lua.eval("#toasts") == 1 and lua.eval("toasts[1].unit") is None and lua.eval("toasts[1].more") == 1
                   and lua.eval("toasts[1].id") == 900004))
    r.append(check("2. hint opens no alert batch (no timer)", lua.eval("#timers") == 0))
    lua.execute("ticker()")
    r.append(check("2. same spot again: no repeat hint", len(lines(lua)) == 1))
    lua.execute('guids.nameplate1 = "Creature-900004"; fire("NAME_PLATE_UNIT_ADDED", "nameplate1")')
    out = lines(lua)
    r.append(check("2. a hinted NPC's nameplate still gives the full alert",
                   len(out) == 2 and "Veteran nearby" in out[1] and "Delta" in out[1] and lua.eval("sounds") == 1, out))
    lua.execute("runTimers()")
    r.append(check("2. the alert's batch closes without a follow-up line", len(lines(lua)) == 2, lines(lua)))
    # Single hint wording; an NPC already alerted this session gives no hint.
    lua = runtime()
    lua.execute('guids.nameplate1 = "Creature-900005"; fire("NAME_PLATE_UNIT_ADDED", "nameplate1"); runTimers()')
    lua.execute("printed = {}; toasts = {}; at(1411, 50, 48.5); ticker()")
    out = lines(lua)
    r.append(check("2. already alerted: no hint; the other one gets the single-hint line",
                   len(out) == 1 and "A veteran is usually found near here" in out[0] and "Delta" in out[0]
                   and "Epsilon" not in out[0] and lua.eval("toasts[1].more") is None, out))
    # A hint during an open alert batch does not end up in its follow-up line, nor does it close it.
    lua = runtime()
    lua.execute('guids.nameplate1 = "Creature-900001"; fire("NAME_PLATE_UNIT_ADDED", "nameplate1")')
    lua.execute("at(1411, 50, 50); ticker()")
    lua.execute('guids.nameplate2 = "Creature-900002"; fire("NAME_PLATE_UNIT_ADDED", "nameplate2")')
    lua.execute("runTimers()")
    out = lines(lua)
    r.append(check("2. hint and alert batch stay apart",
                   len(out) == 3 and "Veteran nearby" in out[0] and "usually found" in out[1]
                   and "Also nearby" in out[2] and "Beta" in out[2] and "Delta" not in out[2], out))

    # 3. roams = true: no hint, but coords (and so the map pin) are kept.
    lua = runtime()
    lua.execute("at(1411, 60, 60); ticker()")
    r.append(check("3. a roaming NPC gives no hint", len(lines(lua)) == 0, lines(lua)))
    r.append(check("3. a roaming NPC keeps its coords for the map pin", lua.eval("(ns.Coords(ns.NPCS[900006]))") == 60))
    lua.execute('guids.target = "Creature-900006"; SlashCmdList.WARCRAFTLORE("why")')
    r.append(check("3. /wcl why explains it", "moves around" in lines(lua)[-1], lines(lua)[-1]))
    flagged = {10182: "Rexxar", 10204: "Misha", 14888: "Lethon", 14889: "Emeriss", 15457: "Huntress Swiftriver"}
    r.append(check("3. Data.lua: roams on the Emerald Dragons, Rexxar, Misha and Huntress Swiftriver",
                   all(lua.eval(f"ns.NPCS[{i}].roams") is True and lua.eval(f"ns.NPCS[{i}].name") == n
                       for i, n in flagged.items())))
    r.append(check("3. Data.lua: those entries still have coords", all(lua.eval(f"ns.Coords(ns.NPCS[{i}])") for i in flagged)))

    # 4. Capital cities use a radius of 1.5, other zones 3.
    lua = runtime()
    lua.execute("at(1454, 52, 50); ticker()")
    r.append(check("4. Orgrimmar, 2 away: no hint", len(lines(lua)) == 0, lines(lua)))
    lua.execute("at(1454, 51.4, 50); ticker()")
    r.append(check("4. Orgrimmar, 1.4 away: hint", len(lines(lua)) == 1 and "Alpha" in lines(lua)[0], lines(lua)))
    lua = runtime()
    lua.execute("at(1411, 48, 50); ticker()")
    r.append(check("4. Durotar, 2 away: hint", len(lines(lua)) == 1 and "Delta" in lines(lua)[0], lines(lua)))
    r.append(check("4. ZONE_MAPS keeps its shape (zone -> list of map IDs)",
                   lua.eval("type(ns.ZONE_MAPS.Orgrimmar) == 'table' and ns.ZONE_MAPS.Orgrimmar[1] == 1454 "
                            "and ns.ZONE_MAPS.Orgrimmar[2] == 85 and ns.ZONE_MAPS.Orgrimmar.radius == nil")))

    # 5. Mouseover gives the nearby alert.
    lua = runtime()
    lua.execute('guids.mouseover = "Creature-900002"; hoverUnit("mouseover"); hoverUnit("mouseover"); hoverUnit("mouseover")')
    r.append(check("5. mouseover: tooltip line now, alert next frame, scheduled once",
                   lua.eval("#tooltipLines") == 1 and len(lines(lua)) == 0 and lua.eval("#timers") == 1))
    lua.execute("runTimers()")
    out = lines(lua)
    r.append(check("5. mouseover alert: chat line, sound, pill",
                   len(out) == 1 and "Veteran nearby" in out[0] and "Beta" in out[0]
                   and lua.eval("sounds") == 1 and lua.eval("#toasts") == 1 and lua.eval("toasts[1].unit") == "mouseover", out))
    lua.execute('hoverUnit("mouseover"); runTimers()')
    r.append(check("5. mouseover again: nothing new", len(lines(lua)) == 1 and lua.eval("sounds") == 1))
    # First meeting ever: MarkMet's "New veteran met" line is the only chat line.
    lua = runtime()
    lua.execute('WarcraftLoreDB.met = {}; guids.mouseover = "Creature-900002"; hoverUnit("mouseover"); runTimers()')
    out = lines(lua)
    r.append(check("5. first meeting: one chat line (New veteran met), plus sound and pill",
                   len(out) == 1 and "New veteran met" in out[0] and lua.eval("sounds") == 1 and lua.eval("#toasts") == 1, out))
    # Already met before (not the first meeting): the normal alert line.
    lua = runtime()
    lua.execute('WarcraftLoreDB.met = { [900002] = { first = 1, count = 1 } }; guids.mouseover = "Creature-900002"; '
                'hoverUnit("mouseover"); runTimers()')
    out = lines(lua)
    r.append(check("5. met before: the nearby alert line", len(out) == 1 and "Veteran nearby" in out[0], out))
    # Already alerted by its nameplate: no second alert.
    lua = runtime()
    lua.execute('guids.nameplate1 = "Creature-900002"; fire("NAME_PLATE_UNIT_ADDED", "nameplate1"); runTimers(); '
                'guids.mouseover = "Creature-900002"; hoverUnit("mouseover"); runTimers()')
    r.append(check("5. nameplate first, then mouseover: one alert", len(lines(lua)) == 1 and lua.eval("sounds") == 1))
    # The target with /wcl auto on: onTargetChanged shows the pill, so no mouseover alert.
    lua = runtime()
    lua.execute('WarcraftLoreDB.auto = true; guids.target = "Creature-900002"; guids.mouseover = "Creature-900002"; '
                'hoverUnit("mouseover"); hoverUnit("target"); runTimers()')
    r.append(check("5. auto on, hovering the target: no alert", len(lines(lua)) == 0 and lua.eval("sounds") == 0))
    lua.execute('WarcraftLoreDB.auto = false; hoverUnit("target"); runTimers()')
    r.append(check("5. auto off, hovering the target: alert", len(lines(lua)) == 1 and lua.eval("sounds") == 1))
    lua = runtime()
    lua.execute('WarcraftLoreDB.alert = false; guids.mouseover = "Creature-900002"; hoverUnit("mouseover"); runTimers()')
    r.append(check("5. alerts off: tooltip line only", len(lines(lua)) == 0 and lua.eval("#tooltipLines") == 1))
    # A mouseover alert during a nameplate batch joins its follow-up line.
    lua = runtime()
    lua.execute('guids.nameplate1 = "Creature-900001"; fire("NAME_PLATE_UNIT_ADDED", "nameplate1"); '
                'guids.mouseover = "Creature-900002"; hoverUnit("mouseover"); '
                'timers[2].fn(); timers[1].fn()')  # the next frame comes before the 1.5 s batch timer
    out = lines(lua)
    r.append(check("5. mouseover during a batch: in the follow-up line",
                   len(out) == 2 and "Also nearby" in out[1] and "Beta" in out[1] and lua.eval("sounds") == 1, out))

    # 6. Nameplate retries stop once the plate is readable.
    lua = runtime()
    lua.execute('fire("NAME_PLATE_UNIT_ADDED", "nameplate1"); timers[1].fn()')
    r.append(check("6. first retry still unreadable: a second retry after 1 s",
                   lua.eval("#timers") == 2 and lua.eval("timers[2].s") == 1))
    lua.execute('guids.nameplate1 = "Creature-900001"; timers[2].fn()')
    out = lines(lua)
    r.append(check("6. readable on the second retry: alert, no third retry",
                   len(out) == 1 and "Alpha" in out[0] and lua.eval("#timers") == 3 and lua.eval("timers[3].s") == 1.5, out))

    # 7. Memorials: only in their zone; object ID first, the name as fallback.
    lua = runtime()
    lua.execute("WarcraftLoreDB.visited = {}")
    lua.execute("at(1454, 50, 50); hoverObject('General Turalyon')")
    r.append(check("7a. in Orgrimmar: Stormwind's memorial is not visited, no line",
                   lua.eval("ns.IsVisited('turalyon')") is False and lua.eval("#tooltipLines") == 0))
    lua.execute("itemTextName = 'General Turalyon'; fire('ITEM_TEXT_BEGIN')")
    r.append(check("7a. reading it in Orgrimmar: not visited", lua.eval("ns.IsVisited('turalyon')") is False))
    lua.execute("at(1453, 63, 75); hoverObject('General Turalyon')")
    r.append(check("7a. in Stormwind City: visited, line", lua.eval("ns.IsVisited('turalyon')") is True
                   and lua.eval("#tooltipLines") == 1))
    lua.execute("mapPos = nil; zoneMapID = nil; hoverObject('Monument to Grom Hellscream')")
    r.append(check("7a. map unreadable: old behaviour (visited by name)", lua.eval("ns.IsVisited('grom')") is True))
    lua.execute("at(210, 50, 50); itemTextName = 'Uther the Lightbringer'; fire('ITEM_TEXT_BEGIN')")
    r.append(check("7a. a map ZONE_MAPS does not list: old behaviour", lua.eval("ns.IsVisited('uther')") is True))
    lua.execute("mapPos = nil; zoneMapID = 1454; itemTextName = \"Trollbane's Tomb\"; fire('ITEM_TEXT_BEGIN')")
    r.append(check("7a. no position, but the zone map ID says elsewhere: not visited",
                   lua.eval("ns.IsVisited('trollbane')") is False))
    book = lua.eval("""(function()
        for key, m in pairs(ns.MEMORIALS) do
            if type(m.locations) == 'table' and m.zone ~= 'Undercity' then
                for _, l in ipairs(m.locations) do if l.zone == 'Undercity' then return key end end
            end
        end end)()""")
    lua.execute(f"zoneMapID = nil; at(1458, 50, 50); itemTextName = ns.MEMORIALS['{book}'].name; fire('ITEM_TEXT_BEGIN')")
    r.append(check(f"7a. a book in one of its other locations ({book}, Undercity): visited",
                   book is not None and lua.eval(f"ns.IsVisited('{book}')") is True))
    lua = runtime()
    lua.execute("WarcraftLoreDB.visited = {}; at(1453, 63, 75); hoverObject('General Turalyon (auf Deutsch)', 25330)")
    r.append(check("7b. object ID matches whatever the name (other client languages)",
                   lua.eval("ns.IsVisited('turalyon')") is True and lua.eval("#tooltipLines") == 1))
    lua.execute("hoverObject('King Llane I of the House of Wrynn', 999999)")
    r.append(check("7b. unknown object ID: the name still matches", lua.eval("ns.IsVisited('llane')") is True))
    r.append(check("7b. ns.MemorialByObjectID", lua.eval("ns.MemorialByObjectID(2082).key") == "uther"
                   and lua.eval("ns.MemorialByObjectID(nil) == nil") and lua.eval("ns.MemorialByObjectID('2082') == nil")))
    # Compat passes the object ID from the GUID; secret or non-object GUIDs give none.
    c = lupa.LuaRuntime(unpack_returned_tuples=True)
    c.execute("""
        ns = {}; Enum = { TooltipDataType = { Unit = 1, Object = 2 } }
        GameTooltip = { GetUnit = function() return nil, nil end }
        TooltipDataProcessor = { AddTooltipPostCall = function(kind, fn) post = fn end }
        secret = {}
        issecretvalue = function(v) return secret[v] == true end
    """)
    c.eval("function(src) assert(loadstring(src, 'Compat.lua'))('WarcraftLore', ns) end")(
        (ADDON / "Compat.lua").read_text(encoding="utf-8"))
    c.execute("ns.Compat.HookObjectTooltip(function(_, name, hasUnit, id) got = { name = name, unit = hasUnit, id = id } end)")
    c.execute("got = nil; post(GameTooltip, { guid = 'GameObject-0-1-2-3-25330-4', lines = { { leftText = 'X' } } })")
    r.append(check("7b. Compat: GameObject GUID gives the object ID", c.eval("got.id") == 25330 and c.eval("got.unit") is False))
    c.execute("got = nil; secret['GameObject-0-1-2-3-2082-4'] = true; "
              "post(GameTooltip, { guid = 'GameObject-0-1-2-3-2082-4', lines = { { leftText = 'X' } } })")
    r.append(check("7b. Compat: a secret GUID gives no object ID", c.eval("got == nil or got.id == nil")))
    c.execute("got = nil; post(GameTooltip, { lines = { { leftText = 'X' } } })")
    r.append(check("7b. Compat: no GUID gives no object ID", c.eval("got.id") is None and c.eval("got.name") == "X"))

    # 8. Saved data from a newer schema: missing settings get defaults, present ones are kept.
    def saved(account):
        s = lupa.LuaRuntime(unpack_returned_tuples=True)
        s.execute("ns = { L = setmetatable({}, { __index = function(_, k) return k end }), "
                  "Compat = { Print = function() end, UnitName = function() return 'A' end, GetRealmName = function() return 'R' end } }; "
                  f"WarcraftLoreDB = {account}; WarcraftLoreCharDB = {{}}")
        s.eval("function(src) assert(loadstring(src, 'SavedData.lua'))('WarcraftLore', ns) end")(
            (ADDON / "SavedData.lua").read_text(encoding="utf-8"))
        s.execute("ns.SavedData.Load()")
        return s
    s = saved("{ schema = 99 }")
    r.append(check("8. newer schema without settings: alert and auto default to on",
                   s.eval("WarcraftLoreDB.alert") is True and s.eval("WarcraftLoreDB.auto") is True
                   and s.eval("WarcraftLoreDB.schema") == 99 and s.eval("WarcraftLoreDB.met") is None))
    s = saved("{ schema = 99, alert = false, auto = false }")
    r.append(check("8. newer schema: present values are kept",
                   s.eval("WarcraftLoreDB.alert") is False and s.eval("WarcraftLoreDB.auto") is False))

    # 9. The pill has its own guard key.
    lua = runtime()
    lua.execute('ns.Toast.Show = function() error("pill broke") end; '
                'guids.nameplate1 = "Creature-900001"; fire("NAME_PLATE_UNIT_ADDED", "nameplate1"); runTimers()')
    out = lines(lua)
    r.append(check("9. pill error: chat line and sound still there",
                   any("Veteran nearby" in x for x in out) and lua.eval("sounds") == 1, out))
    r.append(check("9. pill error: 'pill' off, 'alert' on",
                   lua.eval('ns.FeatureOff("pill")') is True and lua.eval('ns.FeatureOff("alert")') is False))
    lua.execute('guids.nameplate2 = "Creature-900002"; fire("NAME_PLATE_UNIT_ADDED", "nameplate2")')
    r.append(check("9. the next veteran is still announced", "Beta" in lines(lua)[-1] and lua.eval("sounds") == 2, lines(lua)))

    # 10. ns.Coords is the only coordinate parser.
    lua = runtime()
    r.append(check("10. ns.Coords parses", lua.eval("select(2, ns.Coords({ coords = ' 32.0 , 37.8' }))") == 37.8
                   and lua.eval("(ns.Coords({ coords = '32.0, 37.8' }))") == 32))
    r.append(check("10. ns.Coords: none for empty, missing or bad coords",
                   lua.eval("ns.Coords({ coords = '' }) == nil and ns.Coords({}) == nil and ns.Coords(nil) == nil "
                            "and ns.Coords({ coords = 'x, y' }) == nil")))
    pattern = 'match("^%s*([%d%.]+)%s*,%s*([%d%.]+)")'
    core = (ADDON / "Core.lua").read_text(encoding="utf-8")
    pins = (ADDON / "MapPins.lua").read_text(encoding="utf-8")
    r.append(check("10. the pattern is written once (Core.lua) and MapPins.lua uses ns.Coords",
                   core.count(pattern) == 1 and pattern not in pins and pins.count("ns.Coords(") == 2))

    # 11. /wcl debug prints the map; an unreadable target is not "no target".
    lua = runtime()
    lua.execute('at(1454, 50, 25); SlashCmdList.WARCRAFTLORE("debug")')
    r.append(check("11. /wcl debug: map ID, zone and position",
                   any("Map ID 1454 (Orgrimmar), position 50.0, 25.0" in x for x in lines(lua)), lines(lua)))
    lua.execute('mapPos = nil; printed = {}; SlashCmdList.WARCRAFTLORE("debug")')
    r.append(check("11. /wcl debug: no position", any("not readable here" in x for x in lines(lua)), lines(lua)))
    lua.execute('targetExists, targetSecret = false, true; printed = {}; '
                'SlashCmdList.WARCRAFTLORE("id"); SlashCmdList.WARCRAFTLORE("why"); SlashCmdList.WARCRAFTLORE("")')
    out = lines(lua)
    r.append(check("11. secret target: id and why say it cannot be read, not 'no target'",
                   len(out) == 2 and all("cannot be read right now" in x and "no target" not in x for x in out), out))
    r.append(check("11. secret target: /wcl says it in the window",
                   lua.eval("#messages") == 1 and "cannot be read" in lua.eval("messages[1]")))
    lua.execute('targetExists, targetSecret = false, false; printed = {}; SlashCmdList.WARCRAFTLORE("id")')
    r.append(check("11. really no target: 'You have no target.'", lines(lua) == ["|cff8b6cd6Warcraft Lore:|r You have no target."],
                   lines(lua)))
    # Compat.UnitExists and Compat.OnTaxi with the real Compat.lua.
    c = lupa.LuaRuntime(unpack_returned_tuples=True)
    c.execute("ns = {}; S = {}; issecretvalue = function(v) return v == S end")
    c.eval("function(src) assert(loadstring(src, 'Compat.lua'))('WarcraftLore', ns) end")(
        (ADDON / "Compat.lua").read_text(encoding="utf-8"))
    c.execute("UnitExists = function() return S end")
    r.append(check("11. Compat.UnitExists: secret -> false, unreadable", list(c.eval("{ ns.Compat.UnitExists('target') }").values()) == [False, True]))
    c.execute("UnitExists = function() return true end")
    r.append(check("11. Compat.UnitExists: true -> true", c.eval("(ns.Compat.UnitExists('target'))") is True))
    c.execute("UnitOnTaxi = nil")
    r.append(check("1. Compat.OnTaxi: missing API -> false", c.eval("ns.Compat.OnTaxi()") is False
                   and c.eval("ns.Compat.missing.UnitOnTaxi") is True))
    c.execute("UnitOnTaxi = function() return S end")
    r.append(check("1. Compat.OnTaxi: secret -> false", c.eval("ns.Compat.OnTaxi()") is False))
    c.execute("UnitOnTaxi = function() return true end")
    r.append(check("1. Compat.OnTaxi: true -> true", c.eval("ns.Compat.OnTaxi()") is True))

    # Validator: an entry with coords in a zone ZONE_MAPS does not know is reported.
    zones = validate_db.load_zone_maps()
    fake = validate_db.Parser(validate_db.tokenize(
        '{ [1] = { zone = "Nowhere", coords = "1.0, 2.0" }, [2] = { zone = "Blackrock Depths", coords = "" }, '
        '[3] = { zone = "Durotar", coords = "1.0, 2.0" } }'), 0).table()
    errs = validate_db.check_zone_maps(fake, None, zones)
    r.append(check("validator: coords in an unknown zone is an error; instances and known zones pass",
                   "Orgrimmar" in zones and len(errs) == 1 and "Nowhere" in errs[0], errs))

    print(f"\n{sum(r)}/{len(r)} passed")
    raise SystemExit(0 if all(r) else 1)


if __name__ == "__main__":
    main()

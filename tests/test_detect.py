"""Independent test of the NPC detection core: GUID parsing, lookup, the map-position hint,
the nameplate and mouseover alerts, and the data they depend on.

Unlike test_alerts2.py this loads the REAL Compat.lua and the REAL Data.lua and only fakes the
WoW globals underneath (strsplit, UnitGUID, C_Map, UnitOnTaxi, IsInInstance, TooltipDataProcessor,
issecretvalue). Expectations come from the comments and the field reference, not from the
current output of the code.

Usage: python tests/test_detect.py   (needs: pip install lupa)
"""

import sys
from pathlib import Path

import lupa.lua51 as lupa  # WoW runs Lua 5.1

ADDON = Path(__file__).resolve().parent.parent / "WarcraftLore"

# WoW globals. Only the client is faked; Compat.lua is the real file (see runtime()).
GLOBALS = """
secret = {}                                   -- values issecretvalue() reports as secret
issecretvalue = function(v) return secret[v] == true end
-- WoW's strsplit(delimiter, str): the pieces as multiple return values.
strsplit = function(delim, str)
    local out, from = {}, 1
    while true do
        local s, e = string.find(str, delim, from, true)
        if not s then out[#out + 1] = string.sub(str, from); break end
        out[#out + 1] = string.sub(str, from, s - 1)
        from = e + 1
    end
    return unpack(out)
end
guids, names = {}, {}
UnitGUID = function(u) return guids[u] end
UnitName = function(u) return names[u] end
UnitExists = function(u) return guids[u] ~= nil end
onTaxi, inInstance = false, false
UnitOnTaxi = function() return onTaxi end
IsInInstance = function() return inInstance end
mapPos = nil                                  -- { mapID, x, y } with x, y in 0..1, as the client gives them
C_Map = {
    GetBestMapForUnit = function() return mapPos and mapPos[1] or nil end,
    GetPlayerMapPosition = function()
        if not mapPos then return nil end
        return { GetXY = function() return mapPos[2], mapPos[3] end }
    end,
}
GameTooltip = { GetUnit = function(self) return "name", self.unitToken end }
Enum = { TooltipDataType = { Unit = 1, Object = 2 } }
TooltipDataProcessor = { AddTooltipPostCall = function(kind, fn) if kind == 1 then unitPost = fn end end }
"""

# Everything below is the addon's own surroundings (windows, timers, sound, chat), faked as in the
# other tests. Applied AFTER the real Compat.lua is loaded, so only these functions are replaced.
OVERRIDES = """
local C = ns.Compat
printed, timers, sounds, toasts, tooltipLines = {}, {}, 0, {}, {}
C.Print = function(m) printed[#printed + 1] = m end
C.IsForever = function() return true end
C.After = function(fn, s) timers[#timers + 1] = { fn = fn, s = s } end
C.PlayAlertSound = function() sounds = sounds + 1 end
C.StartTicker = function(_, fn) ticker = fn return true end
C.RegisterEventSafe = function() return true end
C.EVENT_NAMEPLATE_ADDED = "NAME_PLATE_UNIT_ADDED"
C.HookObjectTooltip = function() return "stub" end
C.ItemTextName = function() return nil end
C.AddTooltipLine = function(_, text) tooltipLines[#tooltipLines + 1] = text end
C.GetRealmName = function() return "Realm" end
"""

SETUP = """
local noop = function() end
local function stub() return setmetatable({}, { __index = function() return noop end }) end
ns.L = setmetatable({}, { __index = function(_, k) return k end })
ns.Toast = { Show = function(id, e, who, unit, more) toasts[#toasts + 1] = { id = id, who = who, unit = unit, more = more } end,
    SetMore = noop }
ns.UI = { Init = noop, IsShown = function() return false end, ShowMessage = noop }
ns.Minimap = { Init = noop }
ns.SavedData = { Load = function() end, CharacterName = function() return "Arthas-Realm" end }
ns.Style = { theme = "wc2", ApplyTheme = noop, ThemeLabel = function(n) return n end,
             OtherTheme = function() return "classic" end, RequestTheme = noop }
WarcraftLoreDB = { alert = true, auto = false, met = {} }
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
function runTimers()  -- every pending timer, and the timers they start, once, in order
    local i = 1
    while timers[i] do timers[i].fn(); i = i + 1 end
    timers = {}
end
function at(mapID, x, y) mapPos = { mapID, x / 100, y / 100 } end   -- x, y in map percent
function plate(unit, guid) guids[unit] = guid; fire("NAME_PLATE_UNIT_ADDED", unit) end
function hover(unit, guid)
    guids[unit] = guid
    tooltipLines = {}
    GameTooltip.unitToken = unit
    unitPost(GameTooltip, { guid = guid })
end
-- Compat.NPCIDFromGUID that reports an error instead of throwing it.
function npc(g)
    local ok, id, kind = pcall(ns.Compat.NPCIDFromGUID, g)
    return { ok = ok, id = id, kind = kind }
end
"""

THRALL = "Creature-0-1-2-3-4949-0000A1"
THRALL_X, THRALL_Y = 32.0, 37.8        # Orgrimmar, map 1454 (capital: radius 1.5)
GADRIN_X, GADRIN_Y = 56.0, 74.6        # Master Gadrin [3188], Durotar, map 1411 (radius 3)


def runtime(files=("Data.lua", "Memorials.lua", "Core.lua")):
    lua = lupa.LuaRuntime(unpack_returned_tuples=True)
    lua.execute("ns = {}")
    lua.execute(GLOBALS)
    run = lua.eval("function(src, name) assert(loadstring(src, name))('WarcraftLore', ns) end")
    run((ADDON / "Compat.lua").read_text(encoding="utf-8"), "Compat.lua")
    lua.execute(OVERRIDES)
    lua.execute(SETUP)
    for name in files:
        run((ADDON / name).read_text(encoding="utf-8"), name)
    lua.execute('fire("ADDON_LOADED", "WarcraftLore")')
    return lua


def lines(lua):
    return [str(x) for x in lua.eval("printed").values()]


results = []


def check(name, cond, detail=""):
    print(("ok   " if cond else "FAIL ") + name + (f"  ({detail})" if detail and not cond else ""))
    results.append(bool(cond))


def section(fn):
    """A Lua error inside a section is a failed check, not a crash of the whole file."""
    try:
        fn()
    except Exception as exc:  # noqa: BLE001
        check(f"{fn.__name__}: no error", False, repr(exc)[:300])


def parse(lua, guid_lua):
    """(ok, id, type) of Compat.NPCIDFromGUID for a Lua expression."""
    lua.execute(f"r = npc({guid_lua})")
    return lua.eval("r.ok"), lua.eval("r.id"), lua.eval("r.kind")


def sec_guid_parsing():
    lua = runtime()
    ok, i, t = parse(lua, '"Creature-0-1-2-3-4949-0000A1"')
    check("1. Creature GUID gives the NPC ID and type", ok and i == 4949 and t == "Creature", (ok, i, t))
    ok, i, t = parse(lua, '"Vehicle-0-1-2-3-4949-0000A1"')
    check("1. Vehicle GUID gives the NPC ID and type", ok and i == 4949 and t == "Vehicle", (ok, i, t))
    ok, i, t = parse(lua, '"Creature-0-1-2-3-4949-0000A1"')
    check("1. the NPC ID is a number, not a string", lua.eval("type(r.id)") == "number")
    for kind, guid in [("Pet", "Pet-0-1-2-3-4949-0000A1"), ("Player", "Player-1-0000ABCD"),
                       ("GameObject", "GameObject-0-1-2-3-4949-0000A1"), ("Item", "Item-1-0-0000ABCD")]:
        ok, i, t = parse(lua, f'"{guid}"')
        check(f"1. {kind} GUID gives no NPC ID (and reports its type)", ok and i is None and t == kind, (ok, i, t))
    for label, expr in [("nil", "nil"), ("a number", "4949"), ("an empty string", '""'),
                        ("a malformed string (Creature-0-1)", '"Creature-0-1"'),
                        ("no dashes at all", '"Thrall"'), ("a table", "{}")]:
        ok, i, _ = parse(lua, expr)
        check(f"1. {label}: no error, no NPC ID", ok and i is None, (ok, i))
    lua.execute('secret["Creature-0-1-2-3-4949-0000A1"] = true')
    ok, i, t = parse(lua, '"Creature-0-1-2-3-4949-0000A1"')
    check("1. a secret GUID: no error, no NPC ID, no type", ok and i is None and t is None, (ok, i, t))
    # Non-numeric ID part must not produce a bogus number.
    ok, i, _ = parse(lua, '"Creature-0-1-2-3-abc-0000A1"')
    check("1. a non-numeric ID part gives no NPC ID", ok and i is None, (ok, i))
    check("1. strsplit stub behaves like WoW's (pieces as multiple values)",
          lua.eval('select("#", strsplit("-", "a-b-c"))') == 3 and lua.eval('(select(2, strsplit("-", "a-b-c")))') == "b")
    # Compat.UnitGUID: secret result and a throwing API both give nil.
    lua.execute('guids.target = "Creature-0-1-2-3-4949-0000A1"; secret[guids.target] = true')
    check("1. Compat.UnitGUID: a secret result gives nil", lua.eval('ns.Compat.UnitGUID("target")') is None)
    lua.execute('UnitGUID = function() error("boom") end')
    check("1. Compat.UnitGUID: an erroring API gives nil, no error", lua.eval('ns.Compat.UnitGUID("target")') is None)


def sec_lookup():
    lua = runtime()
    lua.execute(f'e, id, t = ns.Lookup(nil, "{THRALL}")')
    check("2. Lookup(GUID of Thrall) finds his entry", lua.eval("e and e.name") == "Thrall" and lua.eval("id") == 4949
          and lua.eval("t") == "Creature")
    lua.execute('guids.target = "%s"; e, id = ns.Lookup("target")' % THRALL)
    check("2. Lookup(unit token) finds him too", lua.eval("e and e.name") == "Thrall" and lua.eval("id") == 4949)
    # A real Forever alias from Data.lua: Leonid Barthalomew is 11036 everywhere, 267008 in Forever.
    lua.execute("main = ns.NPCS[11036]; alias = main and main.foreverIDs and main.foreverIDs[1]")
    check("2. Data.lua: Leonid [11036] lists foreverIDs 267008", lua.eval("alias") == 267008)
    lua.execute('e, id = ns.Lookup(nil, "Creature-0-1-2-3-267008-0000A1")')
    check("2. a Forever alias ID resolves to the main entry and the main ID",
          lua.eval("e == ns.NPCS[11036]") and lua.eval("id") == 11036, (lua.eval("id"),))
    # Every alias in the data resolves to its own main entry, not just Leonid.
    bad = lua.eval("""(function()
        local bad = {}
        for id, entry in pairs(ns.NPCS) do
            for _, fid in ipairs(entry.foreverIDs or {}) do
                local e, got = ns.Lookup(nil, "Creature-0-1-2-3-" .. fid .. "-0000A1")
                if e ~= entry or got ~= id then bad[#bad + 1] = fid end
            end
        end
        return table.concat(bad, ",") end)()""")
    check("2. every foreverIDs value in Data.lua resolves to its main entry", bad == "", bad)
    lua.execute('e, id = ns.Lookup(nil, "Pet-0-1-2-3-4949-0000A1")')
    check("2. a Pet GUID carrying 4949 does not match", lua.eval("e") is None and lua.eval("id") is None)
    lua.execute('e, id = ns.Lookup(nil, "Pet-0-1-2-3-267008-0000A1")')
    check("2. a Pet GUID carrying a Forever alias does not match", lua.eval("e") is None and lua.eval("id") is None)
    lua.execute(f'secret["{THRALL}"] = true; e, id = ns.Lookup(nil, "{THRALL}")')
    check("2. a secret GUID does not match", lua.eval("e") is None and lua.eval("id") is None)
    lua.execute(f'guids.target = "{THRALL}"; e, id = ns.Lookup("target")')
    check("2. a secret GUID read from a unit does not match", lua.eval("e") is None and lua.eval("id") is None)
    lua.execute("e, id = ns.Lookup(nil, nil)")
    check("2. no unit and no GUID: nothing, no error", lua.eval("e") is None and lua.eval("id") is None)
    lua.execute('e, id = ns.Lookup(nil, "Creature-0-1-2-3-999999999-0000A1")')
    check("2. an ID not in the database: no entry", lua.eval("e") is None)


def sec_position():
    lua = runtime()
    lua.execute(f"at(1454, {THRALL_X}, {THRALL_Y}); ticker()")
    out = lines(lua)
    check("3. Orgrimmar, exactly on Thrall's coords: ONE hint naming him",
          len(out) == 1 and "Thrall" in out[0] and "usually found near here" in out[0], out)
    check("3. a hint plays no alert sound", lua.eval("sounds") == 0)
    check("3. a hint shows a pill without a unit", lua.eval("#toasts") == 1 and lua.eval("toasts[1].id") == 4949
          and lua.eval("toasts[1].unit") is None)
    lua.execute("ticker()")
    check("3. a second check at the same spot repeats nothing", len(lines(lua)) == 1 and lua.eval("#toasts") == 1)

    # Boundary in a capital city: 1.5. Walk along -x, away from the neighbours Vol'jin and Eitrigg.
    for dist, expect, label in [(1.4, True, "just inside"), (1.6, False, "just outside")]:
        lua = runtime()
        lua.execute(f"at(1454, {THRALL_X - dist}, {THRALL_Y}); ticker()")
        out = lines(lua)
        got = len(out) == 1 and "Thrall" in out[0]
        check(f"3. Orgrimmar (radius 1.5), {dist} away ({label}): {'hint' if expect else 'no hint'}",
              got if expect else len(out) == 0, out)
    # The same boundary along y.
    for dist, expect in [(1.4, True), (1.6, False)]:
        lua = runtime()
        lua.execute(f"at(1454, {THRALL_X}, {THRALL_Y + dist}); ticker()")
        out = lines(lua)
        check(f"3. Orgrimmar, {dist} away in y: {'hint' if expect else 'no hint'}",
              (len(out) == 1 and "Thrall" in out[0]) if expect else len(out) == 0, out)
    # Distance is euclidean (a circle), not a square: 1.2 + 1.2 diagonal = 1.70 is out, 1.0 + 1.0 = 1.41 is in.
    lua = runtime()
    lua.execute(f"at(1454, {THRALL_X - 1.2}, {THRALL_Y - 1.2}); ticker()")
    check("3. diagonal 1.2/1.2 (distance 1.70, outside the circle): no hint", len(lines(lua)) == 0, lines(lua))
    lua = runtime()
    lua.execute(f"at(1454, {THRALL_X - 1.0}, {THRALL_Y - 1.0}); ticker()")
    check("3. diagonal 1.0/1.0 (distance 1.41, inside): hint", len(lines(lua)) == 1, lines(lua))

    # Normal zone: 3. Master Gadrin is alone in Durotar's east.
    for dist, expect, label in [(2.9, True, "just inside"), (3.1, False, "just outside")]:
        lua = runtime()
        lua.execute(f"at(1411, {GADRIN_X + dist}, {GADRIN_Y}); ticker()")
        out = lines(lua)
        check(f"3. Durotar (radius 3), {dist} away ({label}): {'hint' if expect else 'no hint'}",
              (len(out) == 1 and "Master Gadrin" in out[0]) if expect else len(out) == 0, out)
    lua = runtime()
    lua.execute(f"at(1, {GADRIN_X}, {GADRIN_Y}); ticker()")
    check("3. the Mainline map ID of Durotar (1) works the same", len(lines(lua)) == 1 and "Master Gadrin" in lines(lua)[0], lines(lua))
    # A city radius of 1.5 must not leak into zones, nor 3 into cities: 2.0 away is out in a city, in in a zone.
    lua = runtime()
    lua.execute(f"at(1411, {GADRIN_X - 2.0}, {GADRIN_Y}); ticker()")
    check("3. Durotar, 2.0 away: hint (zones are wider than cities)", len(lines(lua)) == 1, lines(lua))
    lua = runtime()
    lua.execute(f"at(1454, {THRALL_X - 2.0}, {THRALL_Y}); ticker()")
    check("3. Orgrimmar, 2.0 away: no hint", len(lines(lua)) == 0, lines(lua))

    # Wrong map, unlisted map, no position.
    for label, setup in [("wrong map ID (Mulgore, Thrall's coords)", f"at(1412, {THRALL_X}, {THRALL_Y})"),
                         ("a map ZONE_MAPS does not list", f"at(99999, {THRALL_X}, {THRALL_Y})"),
                         ("Durotar's coords in Orgrimmar", f"at(1454, {GADRIN_X}, {GADRIN_Y})"),
                         ("position unreadable", "mapPos = nil")]:
        lua = runtime()
        lua.execute(setup + "; ticker()")
        check(f"3. {label}: nothing", len(lines(lua)) == 0 and lua.eval("#toasts") == 0, lines(lua))
    # Secret position values give nothing and no error.
    lua = runtime()
    lua.execute(f"at(1454, {THRALL_X}, {THRALL_Y}); secret[mapPos[2]] = true; ticker()")
    check("3. a secret x value: nothing, no error", len(lines(lua)) == 0 and not lua.eval('ns.FeatureOff("position")'), lines(lua))

    # Taxi, instance, alerts off.
    lua = runtime()
    lua.execute(f"onTaxi = true; at(1454, {THRALL_X}, {THRALL_Y}); ticker()")
    check("3. on a taxi: no hint", len(lines(lua)) == 0 and lua.eval("#toasts") == 0, lines(lua))
    lua.execute("onTaxi = false; ticker()")
    check("3. off the taxi, same spot: the hint comes", len(lines(lua)) == 1, lines(lua))
    lua = runtime()
    lua.execute(f"inInstance = true; at(1454, {THRALL_X}, {THRALL_Y}); ticker()")
    check("3. in an instance: no hint", len(lines(lua)) == 0 and lua.eval("#toasts") == 0, lines(lua))
    lua.execute("inInstance = false; ticker()")
    check("3. out of the instance, same spot: the hint comes", len(lines(lua)) == 1, lines(lua))
    lua = runtime()
    lua.execute(f"WarcraftLoreDB.alert = false; at(1454, {THRALL_X}, {THRALL_Y}); ticker()")
    check("3. nearby alerts off: no hint", len(lines(lua)) == 0, lines(lua))

    # roams = true. Rexxar [10182] (Stonetalon Mountains, 30.2, 76.0).
    lua = runtime()
    lua.execute("rex = ns.NPCS[10182]")
    x, y = lua.eval("ns.Coords(rex)")
    check("3. Data.lua: Rexxar roams and has parseable coords",
          lua.eval("rex.roams") is True and (x, y) == (30.2, 76.0), (x, y))
    lua.execute("at(1442, 30.2, 76.0); ticker()")
    check("3. a roaming NPC (Rexxar) gives no hint on its exact coords", len(lines(lua)) == 0, lines(lua))
    lua = runtime()
    lua.execute("ns.NPCS[10182].roams = nil; ns.NPCS[10204].roams = nil; at(1442, 30.2, 76.0); ticker()")
    out = lines(lua)
    check("3. control: without roams the same spot DOES hint (the check above is not vacuous)",
          len(out) == 1 and "Rexxar" in out[0] or (len(out) == 1 and "Misha" in out[0]) or
          (len(out) == 1 and "Veterans usually found" in out[0]), out)


def sec_hint_then_sighting():
    lua = runtime()
    lua.execute(f"at(1454, {THRALL_X}, {THRALL_Y}); ticker()")
    check("4. setup: Thrall's hint came", len(lines(lua)) == 1 and lua.eval("sounds") == 0, lines(lua))
    lua.execute(f'plate("nameplate1", "{THRALL}")')
    out = lines(lua)
    check("4. hint, then his nameplate: the full alert (chat line)",
          len(out) == 2 and "Veteran nearby" in out[1] and "Thrall" in out[1], out)
    check("4. hint, then his nameplate: the full alert (sound and pill with unit)",
          lua.eval("sounds") == 1 and lua.eval("#toasts") == 2 and lua.eval("toasts[2].unit") == "nameplate1")
    lua.execute("runTimers()")
    lua.execute(f'ticker(); plate("nameplate2", "{THRALL}")')
    check("4. the same veteran's plate again: no second alert", len(lines(lua)) == 2 and lua.eval("sounds") == 1, lines(lua))

    lua = runtime()
    lua.execute(f'plate("nameplate1", "{THRALL}"); runTimers()')
    check("4. setup: full alert for Thrall", len(lines(lua)) == 1 and "Veteran nearby" in lines(lua)[0] and lua.eval("sounds") == 1,
          lines(lua))
    lua.execute(f"at(1454, {THRALL_X}, {THRALL_Y}); ticker()")
    check("4. after the full alert, standing on his coords: no hint", len(lines(lua)) == 1 and lua.eval("#toasts") == 1, lines(lua))
    # A Forever alias on the plate is the same veteran.
    lua = runtime()
    lua.execute('plate("nameplate1", "Creature-0-1-2-3-267008-0000A1"); runTimers()')
    out = lines(lua)
    check("4. a plate with a Forever alias ID alerts as the main veteran", len(out) == 1 and "Veteran nearby" in out[0], out)
    # A Pet plate with a veteran's ID is not a veteran.
    lua = runtime()
    lua.execute('plate("nameplate1", "Pet-0-1-2-3-4949-0000A1"); runTimers()')
    check("4. a Pet plate carrying 4949: no alert", len(lines(lua)) == 0 and lua.eval("sounds") == 0, lines(lua))


def sec_mouseover():
    lua = runtime()
    lua.execute("WarcraftLoreDB.met = { [4949] = { first = 1, count = 1 } }")  # met before: the normal alert line
    for _ in range(4):
        lua.execute(f'hover("mouseover", "{THRALL}")')
    check("5. Thrall hovered 4 times: his tooltip line each time, the alert scheduled once",
          lua.eval("#tooltipLines") == 1 and lua.eval("#timers") == 1, (lua.eval("#tooltipLines"), lua.eval("#timers")))
    lua.execute("runTimers()")
    out = lines(lua)
    check("5. the mouseover alert: one chat line, one sound, one pill",
          len(out) == 1 and "Veteran nearby" in out[0] and "Thrall" in out[0] and lua.eval("sounds") == 1
          and lua.eval("#toasts") == 1, out)
    for _ in range(3):
        lua.execute(f'hover("mouseover", "{THRALL}"); runTimers()')
    check("5. refreshing the tooltip several more times: nothing repeats",
          len(lines(lua)) == 1 and lua.eval("sounds") == 1 and lua.eval("#toasts") == 1, lines(lua))
    lua = runtime()
    lua.execute('hover("mouseover", "Pet-0-1-2-3-4949-0000A1"); runTimers()')
    check("5. a Pet tooltip carrying 4949: no line, no alert",
          lua.eval("#tooltipLines") == 0 and len(lines(lua)) == 0 and lua.eval("sounds") == 0)
    lua = runtime()
    lua.execute(f'secret["{THRALL}"] = true; hover("mouseover", "{THRALL}"); runTimers()')
    check("5. a tooltip with a secret GUID: no line, no alert, no error",
          lua.eval("#tooltipLines") == 0 and len(lines(lua)) == 0 and not lua.eval('ns.FeatureOff("tooltip")'))
    # First meeting ever: ns.MarkMet's own "New veteran met" line is the only chat line, plus sound and pill.
    lua = runtime()
    lua.execute(f'hover("mouseover", "{THRALL}"); hover("mouseover", "{THRALL}"); runTimers()')
    out = lines(lua)
    check("5. first meeting by mouseover: one chat line (New veteran met), one sound, one pill",
          len(out) == 1 and "New veteran met" in out[0] and lua.eval("sounds") == 1 and lua.eval("#toasts") == 1, out)
    # Mouseover first, then the nameplate: still one alert.
    lua = runtime()
    lua.execute(f'hover("mouseover", "{THRALL}"); runTimers(); plate("nameplate1", "{THRALL}"); runTimers()')
    check("5. mouseover, then his nameplate: still one alert", len(lines(lua)) == 1 and lua.eval("sounds") == 1, lines(lua))


def sec_data():
    lua = runtime()
    both = lua.eval("""(function()
        local bad, n = {}, 0
        for id, entry in pairs(ns.NPCS) do
            for _, fid in ipairs(entry.foreverIDs or {}) do
                n = n + 1
                if ns.NPCS[fid] ~= nil then bad[#bad + 1] = fid end
            end
        end
        return { n = n, bad = table.concat(bad, ",") } end)()""")
    check("6. Data.lua has foreverIDs to test", both["n"] > 0, both["n"])
    check("6. no foreverIDs value is also its own key in ns.NPCS (it would never alias)", both["bad"] == "", both["bad"])
    dup = lua.eval("""(function()
        local seen, dup = {}, {}
        for id, entry in pairs(ns.NPCS) do
            for _, fid in ipairs(entry.foreverIDs or {}) do
                if seen[fid] and seen[fid] ~= id then dup[#dup + 1] = fid end
                seen[fid] = id
            end
        end
        return table.concat(dup, ",") end)()""")
    check("6. no foreverIDs value is claimed by two entries", dup == "", dup)
    n_alias = lua.eval("(function() local n = 0 for _ in pairs(ns.FOREVER_ALIAS) do n = n + 1 end return n end)()")
    check("6. ns.FOREVER_ALIAS has one key per foreverIDs value", n_alias == both["n"], (n_alias, both["n"]))
    bad = lua.eval("""(function()
        local bad = {}
        for id, entry in pairs(ns.NPCS) do
            if entry.roams then
                local x, y = ns.Coords(entry)
                if not (x and y) then bad[#bad + 1] = id end
            end
        end
        return table.concat(bad, ",") end)()""")
    roams = lua.eval("(function() local n = 0 for _, e in pairs(ns.NPCS) do if e.roams then n = n + 1 end end return n end)()")
    check("6. entries with roams = true exist", roams > 0, roams)
    check("6. every roams = true entry still has parseable coords", bad == "", bad)
    # Hint coordinates: every entry that can give a hint has coords in a zone with map IDs and inside 0..100.
    bad = lua.eval("""(function()
        local bad = {}
        for id, entry in pairs(ns.NPCS) do
            local x, y = ns.Coords(entry)
            if x and (x > 100 or y > 100 or not ns.ZONE_MAPS[entry.zone]) and not entry.forever then bad[#bad + 1] = id end
        end
        return table.concat(bad, ",") end)()""")
    check("6. every non-Forever entry with coords is inside 0..100 and in a known zone", bad == "", bad)


def main():
    for fn in (sec_guid_parsing, sec_lookup, sec_position, sec_hint_then_sighting, sec_mouseover, sec_data):
        section(fn)
    print(f"\n{sum(results)}/{len(results)} checks passed")
    raise SystemExit(0 if all(results) else 1)


if __name__ == "__main__":
    main()

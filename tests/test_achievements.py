"""Achievements.lua in Lua 5.1 (via lupa, with WoW stubs): generation counts per category,
progress, Check (stores and returns new ids once), the silent first run, migration 3 and a stable order.

Usage: python tests/test_achievements.py   (needs: pip install lupa)
"""

from pathlib import Path

import lupa.lua51 as lupa

ADDON = Path(__file__).resolve().parent.parent / "WarcraftLore"

STUBS = """
local noop = function() end
local function stub() return setmetatable({}, { __index = function() return noop end }) end
ns = { L = setmetatable({}, { __index = function(_, k) return k end }), Compat = stub() }
ns.Compat.UnitName = function() return "Arthas" end
ns.Compat.GetRealmName = function() return "Silvermoon" end
ns.Compat.After = function(fn) fn() end
printed, sounds, banners = {}, 0, {}
ns.Compat.Print = function(msg) printed[#printed + 1] = msg end
ns.Compat.PlayAlertSound = function() sounds = sounds + 1 end
ns.Toast = { ShowAchievement = function(t, n) banners[#banners + 1] = { t, n } end }
CreateFrame = function() return stub() end
SlashCmdList = {}
now = 1759449600
time = function() return now end
date = os.date
"""

HELPERS = """
function metGroup(g) WarcraftLoreDB.met[g.id] = { first = 1, count = 1 } end
function byId(list) local t = {} for _, a in ipairs(list) do t[a.id] = a end return t end
function sortedIds(list) local t = {} for i, id in ipairs(list) do t[i] = id end table.sort(t) return table.concat(t, ",") end
function allIds() local t = {} for i, x in ipairs(ns.Achievements.List()) do t[i] = x.id end return table.concat(t, ",") end
function hasCode(g, code) for _, c in ipairs(g.codes) do if c == code then return true end end return false end
"""

FRESH = "{ schema = 3, met = {}, achievements = {} }"


# cap=30: the "later" mechanism is tested at the old launch cap; the shipped cap is checked separately.
def runtime(db=FRESH, files=("Data.lua", "SavedData.lua", "Core.lua", "Achievements.lua"), cap=30):
    lua = lupa.LuaRuntime(unpack_returned_tuples=True)
    lua.execute(STUBS)
    run = lua.eval("function(src, name) assert(loadstring(src, name))('WarcraftLore', ns) end")
    for name in files:
        run((ADDON / name).read_text(encoding="utf-8"), name)
    if cap and "Achievements.lua" in files:
        lua.execute(f"ns.Achievements.LEVEL_CAP = {cap}")
    if db:
        lua.execute("WarcraftLoreDB = " + db)
    lua.execute(HELPERS)
    return lua


def check(name, cond, detail=""):
    print(("ok   " if cond else "FAIL ") + name + (f"  ({detail})" if detail and not cond else ""))
    return cond


def main():
    r = []
    lua = runtime()
    ev = lua.eval
    lua.execute("list = ns.Achievements.List(); by = byId(list); cats = {}")
    lua.execute("for _, a in ipairs(list) do cats[a.category] = (cats[a.category] or 0) + 1 end")
    total = ev("#ns.Veterans()")
    counts = {c: ev(f"cats.{c} or 0") for c in ("milestone", "game", "zone", "circle", "special")}
    print("generated:", counts, "of", ev("#list"), "(", total, "veterans )")

    # Expected counts computed independently from the data.
    exp_ms = ev("(function() local n = 0 for _, m in ipairs({1,10,25,50,100}) do if m <= #ns.Veterans() then n = n + 1 end end return n end)()")
    r.append(check("milestones <= veterans", counts["milestone"] == exp_ms, counts["milestone"]))
    exp_game = ev("""(function()
        local per, n = {}, 0
        for _, g in ipairs(ns.Veterans()) do
            if ns.Achievements.IsReachable(g) then for _, c in ipairs(g.codes) do per[c] = (per[c] or 0) + 1 end end
        end
        for code, k in pairs(per) do
            if k >= 3 then n = n + 1 end
            if code == "BOOK" then for _, s in ipairs({25, 50}) do if k >= 3 and s < k then n = n + 1 end end end
        end
        return n end)()""")
    r.append(check("game count (BOOK has steps)", counts["game"] == exp_game, f"{counts['game']} vs {exp_game}"))
    exp_zone = ev("""(function()
        local per, n = {}, 0
        for _, g in ipairs(ns.Veterans()) do
            local seen = {}
            local function z(x) if x and x ~= "" and not seen[x] then seen[x] = true; per[x] = (per[x] or 0) + 1 end end
            z(g.entry.zone)
            for _, id in ipairs(g.ids) do for _, a in ipairs(ns.NPCS[id].alsoIn or {}) do z(a) end end
        end
        for _, k in pairs(per) do if k >= 3 then n = n + 1 end end
        return n end)()""")
    r.append(check("zone count (>= 3 veterans, alsoIn included)", counts["zone"] == exp_zone, f"{counts['zone']} vs {exp_zone}"))
    exp_circle = ev("(function() local n = 0 for _, g in ipairs(ns.Veterans()) do if #ns.Related(g.id) >= 3 then n = n + 1 end end return n end)()")
    r.append(check("circle count (>= 3 related)", counts["circle"] == exp_circle, f"{counts['circle']} vs {exp_circle}"))
    r.append(check("one special", counts["special"] == 1))

    r.append(check("entries well formed", ev("""(function()
        local seen = {}
        for _, a in ipairs(list) do
            if type(a.id) ~= "string" or seen[a.id] or type(a.title) ~= "string" or a.title == ""
               or type(a.desc) ~= "string" or type(a.icon) ~= "string" or a.total < 1 or a.progress ~= 0
               or a.done or a.earned ~= nil then return a.id end
            seen[a.id] = true
        end
        return true end)()""") is True))

    # Totals.
    r.append(check("milestone_1 total 1", ev("by.milestone_1.total") == 1))
    r.append(check("game total = reachable veterans of that game", ev("""(function()
        local n = 0 for _, g in ipairs(ns.Veterans()) do if hasCode(g, "WC3") and ns.Achievements.IsReachable(g) then n = n + 1 end end
        return by.game_WC3.total == n end)()""") is True))
    r.append(check("BOOK steps", ev("by.game_BOOK_25 ~= nil and by.game_BOOK_25.total == 25 and by.game_BOOK.total >= 25")))
    r.append(check("circle total = 1 + related", ev("""(function()
        for _, g in ipairs(ns.Veterans()) do
            local a = by['circle_' .. g.id]
            if a and a.total ~= 1 + #ns.Related(g.id) then return false end
        end
        return true end)()""") is True))
    r.append(check("nothing earned at start", ev("(ns.Achievements.Counts())") == 0))

    # Meeting one veteran.
    lua.execute("metGroup(ns.Veterans()[1])")
    lua.execute("list = ns.Achievements.List(); by = byId(list)")
    r.append(check("milestone_1 done after one meet", ev("by.milestone_1.done and by.milestone_1.progress == 1")))
    r.append(check("game progress counts the meeting", ev("""(function()
        for _, c in ipairs(ns.Veterans()[1].codes) do
            local a = by['game_' .. c]
            if a and a.progress ~= 1 then return false end
        end
        return true end)()""") is True))
    if total >= 10:
        r.append(check("milestone_10 progress 1 of 10", ev("by.milestone_10.progress == 1 and by.milestone_10.total == 10 and not by.milestone_10.done")))

    # First run: silent, one line.
    lua = runtime()
    lua.execute("metGroup(ns.Veterans()[1])")
    r.append(check("first run: returns nothing", lua.eval("#ns.Achievements.Check()") == 0))
    r.append(check("first run: stored", lua.eval("WarcraftLoreDB.achievements.milestone_1") == 1759449600))
    r.append(check("first run: one line 'already have'",
                   lua.eval("#printed") == 1 and "You already have" in lua.eval("printed[1]") and "/wcl journal" in lua.eval("printed[1]"),
                   lua.eval("tostring(printed[1])")))
    r.append(check("first run: no banner or sound", lua.eval("#banners") == 0 and lua.eval("sounds") == 0))

    # Later: new ones stored and returned once, announced once.
    lua.execute("printed = {}; now = now + 100")
    lua.execute("for _, g in ipairs(ns.Veterans()) do metGroup(g) end")
    got = lua.eval("sortedIds(ns.Achievements.Check())")
    r.append(check("check returns new ids", "milestone_" in got and "special_ages" in got, got))
    r.append(check("new ids stored with time", lua.eval("WarcraftLoreDB.achievements.special_ages") == 1759449700))
    r.append(check("first-run one is not returned again", "milestone_1," not in got + ","))
    r.append(check("one chat line, one banner, one sound",
                   lua.eval("#printed") == 1 and lua.eval("#banners") == 1 and lua.eval("sounds") == 1))
    r.append(check("line says how many", " achievements earned: " in lua.eval("printed[1]")))
    r.append(check("banner carries the count", lua.eval("banners[1][2]") > 1))
    lua.execute("printed = {}")
    r.append(check("second Check: nothing new", lua.eval("#ns.Achievements.Check()") == 0 and lua.eval("#printed") == 0))
    e, t, later = lua.eval("ns.Achievements.Counts()")
    r.append(check("all reachable earned, later ones left", e == t and t > 0 and later > 0, f"{e}/{t} +{later}"))
    r.append(check("later ones never stored", lua.eval("""(function()
        for _, a in ipairs(ns.Achievements.List()) do
            if a.later and (a.earned or WarcraftLoreDB.achievements[a.id]) then return a.id end
        end
        return true end)()""") is True))
    r.append(check("earned time in List", lua.eval("byId(ns.Achievements.List()).special_ages.earned") == 1759449700))

    # Single wording.
    lua = runtime("{ schema = 3, met = {}, achievements = {}, achievementsSeeded = true }")
    lua.execute("metGroup(ns.Veterans()[1])")
    r.append(check("seeded: single new id", lua.eval("sortedIds(ns.Achievements.Check())") == "milestone_1"))
    last = lua.eval("printed[#printed]")
    r.append(check("single wording", last.endswith("Achievement earned: First Contact"), last))
    r.append(check("single banner count 1", lua.eval("banners[1][2]") == 1 and lua.eval("banners[1][1]") == "First Contact"))

    # Nothing met on a first run: no line.
    lua = runtime()
    r.append(check("empty first run is silent", lua.eval("#ns.Achievements.Check()") == 0 and lua.eval("#printed") == 0))

    # Newer data format is left alone.
    lua = runtime("{ schema = 3, met = {}, achievements = 'newer' }")
    r.append(check("achievements not a table: no-op",
                   lua.eval("#ns.Achievements.Check()") == 0 and lua.eval("WarcraftLoreDB.achievements") == "newer"))

    # Order.
    a = runtime().eval("allIds()")
    b = runtime().eval("allIds()")
    r.append(check("order stable across loads", a == b and a != ""))
    lua = runtime()
    r.append(check("category order", lua.eval("""(function()
        local rank, last = {milestone = 1, game = 2, zone = 3, circle = 4, special = 5}, 0
        for _, x in ipairs(ns.Achievements.List()) do
            if rank[x.category] < last then return false end
            last = rank[x.category]
        end
        return true end)()""") is True))
    r.append(check("zones sorted by title", lua.eval("""(function()
        local prev
        for _, x in ipairs(ns.Achievements.List()) do
            if x.category == "zone" then
                if prev and prev > x.title then return false end
                prev = x.title
            end
        end
        return true end)()""") is True))

    # --- level cap: reachable veterans and "later"
    lua = runtime()
    ev = lua.eval
    cap = ev("ns.Achievements.LEVEL_CAP")
    reach = ev("(function() local n = 0 for _, g in ipairs(ns.Veterans()) do if ns.Achievements.IsReachable(g) then n = n + 1 end end return n end)()")
    lua.execute("list = ns.Achievements.List(); by = byId(list)")
    n_later = ev("(function() local n = 0 for _, a in ipairs(list) do if a.later then n = n + 1 end end return n end)()")
    print(f"level cap {cap}: {reach} of {total} veterans reachable, {n_later} of {ev('#list')} achievements later")
    shipped = runtime(cap=None)
    r.append(check("shipped LEVEL_CAP is 60", shipped.eval("ns.Achievements.LEVEL_CAP") == 60))
    r.append(check("at the shipped cap no achievement is later", shipped.eval("""(function()
        for _, a in ipairs(ns.Achievements.List()) do if a.later then return a.id end end
        return true end)()""") is True))
    r.append(check("some veterans are unreachable, most are reachable", 0 < reach < total and reach > total // 2))
    r.append(check("Tanaris is later, Stormwind is not",
                   ev("by['zone_Tanaris'].later") is True and ev("by['zone_Stormwind City'].later") is False))
    r.append(check("Temple of Ahn'Qiraj is later", ev('by["zone_Temple of Ahn\'Qiraj"].later') is True))
    r.append(check("a veteran with only a 40+ zone is unreachable", ev("""(function()
        for _, g in ipairs(ns.Veterans()) do
            if g.entry.zone == "Tanaris" and #(ns.NPCS[g.id].alsoIn or {}) == 0 then return not ns.Achievements.IsReachable(g) end
        end return false end)()""") is True))
    r.append(check("a circle is later exactly when a member is unreachable", ev("""(function()
        for _, a in ipairs(list) do
            if a.id:sub(1, 7) == "circle_" then
                local id = tonumber(a.id:sub(8))
                local g = ns.VeteranOf(id)
                local need = not ns.Achievements.IsReachable(g)
                for _, rg in ipairs(ns.Related(id)) do need = need or not ns.Achievements.IsReachable(rg) end
                if need ~= a.later then return a.id end
            end
        end return true end)()""") is True))
    r.append(check("games count only reachable veterans (no game is later)", ev("""(function()
        for _, a in ipairs(list) do if a.category == "game" and a.later then return a.id end end
        return true end)()""") is True))
    r.append(check("milestones above the reachable count are later", ev("""(function()
        local open = %d
        for _, a in ipairs(list) do
            if a.category == "milestone" and (a.total > open) ~= a.later then return a.id end
        end return true end)()""" % reach) is True))

    # Check never awards a later one, even when every member is met.
    lua.execute("WarcraftLoreDB.achievementsSeeded = true; for _, g in ipairs(ns.Veterans()) do metGroup(g) end")
    lua.execute("list = ns.Achievements.List(); by = byId(list)")
    r.append(check("a later one can be done by progress yet is not awarded", ev("by['zone_Tanaris'].done") is True))
    lua.execute("fresh = ns.Achievements.Check()")
    r.append(check("Check awards no later achievement", ev("""(function()
        local now = byId(ns.Achievements.List())
        for _, id in ipairs(fresh) do if now[id].later then return id end end
        return WarcraftLoreDB.achievements['zone_Tanaris'] == nil end)()""") is True))
    e, t, later = lua.eval("ns.Achievements.Counts()")
    r.append(check("Counts: later ones are not in the total", t == ev("#list") - later and later == n_later and e == t, f"{e}/{t} +{later}"))

    # Possessive.
    lua = runtime()
    lua.execute("by = byId(ns.Achievements.List())")
    r.append(check("no s's Circle anywhere", lua.eval("""(function()
        for _, a in ipairs(ns.Achievements.List()) do
            if a.title:find("s's Circle", 1, true) then return a.title end
        end return true end)()""") is True))
    r.append(check("names ending in s get an apostrophe only; others 's", lua.eval("""(function()
        local ends, plain = 0, 0
        for _, g in ipairs(ns.Veterans()) do
            local a = by['circle_' .. g.id]
            if a then
                local name = g.entry.name
                local want = name:sub(-1) == "s" and (name .. "' Circle") or (name .. "'s Circle")
                if a.title ~= want then return a.title end
                if name:sub(-1) == "s" then ends = ends + 1 else plain = plain + 1 end
            end
        end
        return ends >= 1 and plain >= 1 end)()""") is True))

    # Earned stays done when the goal grows; real progress is kept.
    lua = runtime("{ schema = 3, met = {}, achievements = { game_WC3 = 1759449600 }, achievementsSeeded = true }")
    lua.execute("by = byId(ns.Achievements.List())")
    r.append(check("earned but progress short: still done, date kept, progress honest",
                   lua.eval("by.game_WC3.done") is True and lua.eval("by.game_WC3.earned") == 1759449600
                   and lua.eval("by.game_WC3.progress") < lua.eval("by.game_WC3.total")))
    r.append(check("earned counts once in Counts", lua.eval("(ns.Achievements.Counts())") == 1))

    # Order and wording.
    lua = runtime()
    r.append(check("book steps stay together, smallest first", lua.eval("""(function()
        local l, ids = ns.Achievements.List(), {}
        for i, a in ipairs(l) do if a.id:sub(1, 9) == "game_BOOK" then ids[#ids + 1] = i end end
        if #ids < 3 then return false end
        for k = 2, #ids do if ids[k] ~= ids[k - 1] + 1 or l[ids[k]].total <= l[ids[k - 1]].total then return false end end
        return true end)()""") is True))
    r.append(check("flat old titles are gone and Across the Ages matches its rule", lua.eval("""(function()
        local by = byId(ns.Achievements.List())
        for _, a in ipairs(ns.Achievements.List()) do
            if a.title:find("^All of ") or a.title == "Library Regular" or a.title:find("Heroes of Reign") then return a.title end
        end
        return by.game_WC3.title == "Veterans of the Third War" and by.special_ages.desc:find("strategy", 1, true) ~= nil end)()""") is True))

    # Alerts off: the achievement still shows, but no sound.
    lua = runtime("{ schema = 3, met = {}, achievements = {}, achievementsSeeded = true, alert = false }")
    lua.execute("metGroup(ns.Veterans()[1])")
    lua.eval("ns.Achievements.Check()")
    r.append(check("alert off: line and banner, no sound",
                   lua.eval("#printed") == 1 and lua.eval("#banners") == 1 and lua.eval("sounds") == 0))

    # A meet that earns an achievement prints only the achievement line; a plain meet prints the meet line.
    lua = runtime("{ schema = 3, met = {}, achievements = {}, achievementsSeeded = true, alert = true }")
    lua.execute("first = ns.Veterans()[1].id; second = ns.Veterans()[2].id")
    lua.execute("ns.MarkMet(first)")
    r.append(check("meet with achievement: one line, the achievement; one sound",
                   lua.eval("#printed") == 1 and "Achievement earned" in lua.eval("printed[1]")
                   and "New veteran met" not in lua.eval("printed[1]") and lua.eval("sounds") == 1,
                   lua.eval("table.concat(printed, ' | ')")))
    lua.execute("printed = {}")
    lua.execute("ns.MarkMet(second)")
    r.append(check("plain meet: the meet line only, no new sound",
                   lua.eval("#printed") == 1 and "New veteran met" in lua.eval("printed[1]") and lua.eval("sounds") == 1,
                   lua.eval("table.concat(printed, ' | ')")))

    # Migration 3 from schema 2 data.
    lua = runtime(None, files=("Data.lua", "SavedData.lua"))
    lua.execute("WarcraftLoreDB = { schema = 2, auto = true, alert = true, minimap = {}, met = { [4949] = { first = 5, count = 2 } } }")
    lua.execute("WarcraftLoreCharDB = { schema = 2 }")
    lua.execute("ns.SavedData.Load()")
    r.append(check("migration 3: runs on to the latest schema", lua.eval("WarcraftLoreDB.schema") == 4 and lua.eval("ns.SavedData.ACCOUNT_SCHEMA") == 4))
    r.append(check("migration 3: achievements table, met kept",
                   lua.eval("type(WarcraftLoreDB.achievements)") == "table" and lua.eval("WarcraftLoreDB.met[4949].count") == 2))
    r.append(check("migration 3: not yet seeded", lua.eval("WarcraftLoreDB.achievementsSeeded") is None))

    print(f"\n{sum(r)}/{len(r)} passed")
    raise SystemExit(0 if all(r) else 1)


if __name__ == "__main__":
    main()

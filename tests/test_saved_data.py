"""Runs WarcraftLore/SavedData.lua in Lua 5.1 (via lupa) and checks the migrations.

Usage: python tests/test_saved_data.py   (needs: pip install lupa)
"""

from pathlib import Path

import lupa.lua51 as lupa  # WoW runs Lua 5.1

SOURCE = (Path(__file__).resolve().parent.parent / "WarcraftLore" / "SavedData.lua").read_text(encoding="utf-8")


def load(account, char, name="Arthas", realm="Silvermoon"):
    """Runs SavedData.Load() with the given saved variables (Lua table source or 'nil')."""
    lua = lupa.LuaRuntime(unpack_returned_tuples=True)
    lua.execute(f"""
        printed = {{}}
        ns = {{ Compat = {{
            Print = function(msg) printed[#printed + 1] = msg end,
            UnitName = function(u) return UnitName(u) end,
            GetRealmName = function() return GetRealmName() end,
        }} }}
        UnitName = function() return "{name}" end
        GetRealmName = function() return "{realm}" end
        WarcraftLoreDB = {account}
        WarcraftLoreCharDB = {char}
    """)
    lua.eval("function(src) assert(loadstring(src, 'SavedData.lua'))('WarcraftLore', ns) end")(SOURCE)
    lua.execute("ns.SavedData.Load()")
    return lua


def reload(lua, name="Arthas"):
    """Runs Load() again on the same (already loaded) saved variables."""
    lua.execute(f'UnitName = function() return "{name}" end; ns.SavedData.Load()')


def check(name, cond):
    print(("ok   " if cond else "FAIL ") + name)
    return cond


def main():
    results = []

    # Fresh install: no saved variables at all.
    lua = load("nil", "nil")
    g = lua.globals()
    results.append(check("fresh: defaults set", g.WarcraftLoreDB.auto is True and g.WarcraftLoreDB.alert is True))
    results.append(check("fresh: schemas set", g.WarcraftLoreDB.schema == 2 and g.WarcraftLoreCharDB.schema == 2))
    results.append(check("fresh: account met table", lua.eval("type(WarcraftLoreDB.met)") == "table"))
    results.append(check("fresh: no char met table", lua.eval("WarcraftLoreCharDB.met") is None))
    results.append(check("fresh: silent", lua.eval("#printed") == 0))

    # v0.3 data without schema: settings and met list are kept.
    lua = load("{ auto = false, alert = true, minimap = { angle = 90 } }", "{ met = { [4949] = 1700000000 } }")
    g = lua.globals()
    results.append(check("v0.3: auto=false kept", g.WarcraftLoreDB.auto is False))
    results.append(check("v0.3: minimap kept", g.WarcraftLoreDB.minimap.angle == 90))
    e = g.WarcraftLoreDB.met[4949]
    results.append(check("v0.3: met moved to account", e.first == 1700000000 and e.count == 1 and e.by == "Arthas-Silvermoon"))
    results.append(check("v0.3: char met removed", lua.eval("WarcraftLoreCharDB.met") is None))
    results.append(check("v0.3: schemas set", g.WarcraftLoreDB.schema == 2 and g.WarcraftLoreCharDB.schema == 2))

    # Damaged data: wrong types are replaced.
    lua = load("'oops'", "{ met = 5 }")
    results.append(check("damaged: account replaced", lua.eval("type(WarcraftLoreDB.minimap)") == "table"))
    results.append(check("damaged: account met table", lua.eval("type(WarcraftLoreDB.met)") == "table"))
    results.append(check("damaged: char met dropped", lua.eval("WarcraftLoreCharDB.met") is None))

    # Newer schema (downgrade): left untouched apart from the safety types, one chat line each.
    lua = load("{ schema = 99, auto = 'x' }", "{ schema = 99, met = { [1] = 1 } }")
    g = lua.globals()
    results.append(check("newer: schema kept", g.WarcraftLoreDB.schema == 99 and g.WarcraftLoreCharDB.schema == 99))
    results.append(check("newer: values untouched", g.WarcraftLoreDB.auto == "x"))
    results.append(check("newer: one warning, character left alone", lua.eval("#printed") == 1))

    # Already current: nothing changes, nothing printed.
    lua = load("{ schema = 2, auto = false, alert = false, minimap = {}, met = {} }", "{ schema = 2 }")
    g = lua.globals()
    results.append(check("current: untouched", g.WarcraftLoreDB.auto is False and g.WarcraftLoreDB.alert is False))
    results.append(check("current: silent", lua.eval("#printed") == 0))

    # v0.4 data on two characters: earliest time wins, counts add up, nothing left behind.
    account = "{ schema = 1, auto = true, alert = true, minimap = {} }"
    lua = load(account, "{ schema = 1, met = { [4949] = 1700000500, [100] = 1700000900 } }", "Arthas")
    results.append(check("two chars: first char merged", lua.eval("WarcraftLoreDB.met[4949].by") == "Arthas-Silvermoon"))
    # A second character with an older meeting of 4949 and a newer one of 100 logs in.
    lua.execute("""WarcraftLoreCharDB = { schema = 1, met = { [4949] = 1700000100, [100] = 1700001000, [7] = 1700002000 } }
                   GetRealmName = function() return "Area 52" end""")
    reload(lua, "Jaina")
    g = lua.globals()
    a, b, c = g.WarcraftLoreDB.met[4949], g.WarcraftLoreDB.met[100], g.WarcraftLoreDB.met[7]
    results.append(check("two chars: earliest time and its character kept", a.first == 1700000100 and a.by == "Jaina-Area52"))
    results.append(check("two chars: later meeting keeps first character", b.first == 1700000900 and b.by == "Arthas-Silvermoon"))
    results.append(check("two chars: counts summed", a.count == 2 and b.count == 2 and c.count == 1))
    results.append(check("two chars: char list emptied", lua.eval("WarcraftLoreCharDB.met") is None))
    total = "WarcraftLoreDB.met[4949].count + WarcraftLoreDB.met[100].count + WarcraftLoreDB.met[7].count"
    before = lua.eval(total)
    reload(lua, "Jaina")
    results.append(check("idempotent: second load changes nothing", before == lua.eval(total) == 5))

    # Leftover per-character list on a character already at schema 2 is merged at the next load.
    lua.execute("WarcraftLoreCharDB = { schema = 2, met = { [55] = 1700003000 } }")
    reload(lua, "Thrall")
    results.append(check("leftover: merged at load", lua.eval("WarcraftLoreDB.met[55].first") == 1700003000
                         and lua.eval("WarcraftLoreCharDB.met") is None))

    # Newer account schema: character list is kept for when the addon is updated.
    lua = load("{ schema = 99, met = { [1] = 'x' } }", "{ schema = 1, met = { [4949] = 1700000000 } }")
    g = lua.globals()
    results.append(check("newer account: char met kept", g.WarcraftLoreCharDB.met[4949] == 1700000000
                         and g.WarcraftLoreCharDB.schema == 1 and g.WarcraftLoreDB.met[1] == "x"))
    # Newer character schema: untouched.
    lua = load("{ schema = 2, met = {} }", "{ schema = 99, met = { [4949] = 1700000000 } }")
    results.append(check("newer char: untouched", lua.eval("WarcraftLoreCharDB.met[4949]") == 1700000000
                         and lua.eval("next(WarcraftLoreDB.met)") is None))

    # Damaged entries are skipped, valid ones kept.
    lua = load("{ schema = 1 }", "{ schema = 1, met = { [1] = 'bad', [2] = 1700000000, x = 5 } }")
    results.append(check("damaged entries skipped", lua.eval("WarcraftLoreDB.met[1]") is None
                         and lua.eval("WarcraftLoreDB.met[2].first") == 1700000000))

    print(f"\n{sum(results)}/{len(results)} passed")
    raise SystemExit(0 if all(results) else 1)


if __name__ == "__main__":
    main()

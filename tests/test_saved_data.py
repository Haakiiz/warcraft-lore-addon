"""Runs WarcraftLore/SavedData.lua in Lua 5.1 (via lupa) and checks the migrations.

Usage: python tests/test_saved_data.py   (needs: pip install lupa)
"""

from pathlib import Path

import lupa.lua51 as lupa  # WoW runs Lua 5.1

SOURCE = (Path(__file__).resolve().parent.parent / "WarcraftLore" / "SavedData.lua").read_text(encoding="utf-8")


def load(account, char):
    """Runs SavedData.Load() with the given saved variables (Lua table source or 'nil')."""
    lua = lupa.LuaRuntime(unpack_returned_tuples=True)
    lua.execute(f"""
        printed = {{}}
        ns = {{ Compat = {{ Print = function(msg) printed[#printed + 1] = msg end }} }}
        WarcraftLoreDB = {account}
        WarcraftLoreCharDB = {char}
    """)
    lua.eval("function(src) assert(loadstring(src, 'SavedData.lua'))('WarcraftLore', ns) end")(SOURCE)
    lua.execute("ns.SavedData.Load()")
    return lua


def check(name, cond):
    print(("ok   " if cond else "FAIL ") + name)
    return cond


def main():
    results = []

    # Fresh install: no saved variables at all.
    lua = load("nil", "nil")
    g = lua.globals()
    results.append(check("fresh: defaults set", g.WarcraftLoreDB.auto is True and g.WarcraftLoreDB.alert is True))
    results.append(check("fresh: schemas set", g.WarcraftLoreDB.schema == 1 and g.WarcraftLoreCharDB.schema == 1))
    results.append(check("fresh: met table", lua.eval("type(WarcraftLoreCharDB.met)") == "table"))
    results.append(check("fresh: silent", lua.eval("#printed") == 0))

    # v0.3 data without schema: settings and met list are kept.
    lua = load("{ auto = false, alert = true, minimap = { angle = 90 } }", "{ met = { [4949] = 1700000000 } }")
    g = lua.globals()
    results.append(check("v0.3: auto=false kept", g.WarcraftLoreDB.auto is False))
    results.append(check("v0.3: minimap kept", g.WarcraftLoreDB.minimap.angle == 90))
    results.append(check("v0.3: met kept", g.WarcraftLoreCharDB.met[4949] == 1700000000))
    results.append(check("v0.3: schemas set", g.WarcraftLoreDB.schema == 1 and g.WarcraftLoreCharDB.schema == 1))

    # Damaged data: wrong types are replaced.
    lua = load("'oops'", "{ met = 5 }")
    results.append(check("damaged: account replaced", lua.eval("type(WarcraftLoreDB.minimap)") == "table"))
    results.append(check("damaged: met replaced", lua.eval("type(WarcraftLoreCharDB.met)") == "table"))

    # Newer schema (downgrade): left untouched apart from the safety types, one chat line each.
    lua = load("{ schema = 99, auto = 'x' }", "{ schema = 99, met = { [1] = 1 } }")
    g = lua.globals()
    results.append(check("newer: schema kept", g.WarcraftLoreDB.schema == 99 and g.WarcraftLoreCharDB.schema == 99))
    results.append(check("newer: values untouched", g.WarcraftLoreDB.auto == "x"))
    results.append(check("newer: warned twice", lua.eval("#printed") == 2))

    # Already current: nothing changes, nothing printed.
    lua = load("{ schema = 1, auto = false, alert = false, minimap = {} }", "{ schema = 1, met = {} }")
    g = lua.globals()
    results.append(check("current: untouched", g.WarcraftLoreDB.auto is False and g.WarcraftLoreDB.alert is False))
    results.append(check("current: silent", lua.eval("#printed") == 0))

    print(f"\n{sum(results)}/{len(results)} passed")
    raise SystemExit(0 if all(results) else 1)


if __name__ == "__main__":
    main()

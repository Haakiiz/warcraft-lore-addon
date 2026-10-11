"""Checks the interface translations (Lua 5.1 via lupa): every L["..."] key used in the code is
translated in deDE and frFR, the translations have no stray keys, every translation keeps the
same % placeholders and color codes as its English key, a missing key falls back to the key, and a
client without GetLocale is treated as enUS.

Usage: python tests/test_locale.py   (needs: pip install lupa)
"""

import re
from pathlib import Path

import lupa.lua51 as lupa

ROOT = Path(__file__).resolve().parent.parent / "WarcraftLore"
LOCALES = ("deDE", "frFR")
PLACEHOLDER = re.compile(r"%[-+ #0]*\d*(?:\.\d+)?[a-zA-Z]")
COLOR = re.compile(r"\|c[0-9a-fA-F]{8}|\|r")


def used_keys():
    """Every L["..."] in the addon's code (Data.lua holds the lore, which is not translated)."""
    keys = set()
    for path in ROOT.glob("*.lua"):
        if path.name == "Data.lua":
            continue
        keys.update(re.findall(r'\bL\["([^"]*)"\]', path.read_text(encoding="utf-8")))
    return keys


def run_locale(code, with_compat_locale=True):
    """Loads Locale.lua and Locales/<code>.lua; returns (lua, ns.L as a dict of its own keys)."""
    lua = lupa.LuaRuntime(unpack_returned_tuples=True)
    lua.execute("ns = { Compat = { GetLocale = function() return '%s' end } }" % code)
    run = lua.eval("function(src, n) assert(loadstring(src, n))('WarcraftLore', ns) end")
    run((ROOT / "Locale.lua").read_text(encoding="utf-8"), "Locale.lua")
    for path in sorted((ROOT / "Locales").glob("*.lua")):
        run(path.read_text(encoding="utf-8"), path.name)
    own = dict(lua.eval("function() local t = {} for k, v in pairs(ns.L) do t[k] = v end return t end")())
    return lua, own


def check(name, cond):
    print(("ok   " if cond else "FAIL ") + name)
    return cond


def main():
    results = []
    keys = used_keys()
    results.append(check("code uses interface keys (%d found)" % len(keys), len(keys) > 100))

    toc = (ROOT / "WarcraftLore.toc").read_text(encoding="utf-8").replace("\\", "/").splitlines()
    order = [line.strip() for line in toc if line.strip().endswith(".lua")]
    results.append(check(".toc: Locale.lua right after Compat.lua, then the locale files, before Data.lua",
                         order[:5] == ["Compat.lua", "Locale.lua", "Locales/deDE.lua", "Locales/frFR.lua", "Data.lua"]))

    # English client: nothing is translated, every key comes back as itself.
    lua, own = run_locale("enUS")
    results.append(check("enUS: no translations loaded", len(own) == 0))
    results.append(check("enUS: a key returns itself", lua.eval("ns.L['Veterans list']") == "Veterans list"))
    results.append(check("missing key falls back to the key, never nil",
                         lua.eval("ns.L['no such string %d']") == "no such string %d"))
    results.append(check("ns.Locale is enUS", lua.eval("ns.Locale") == "enUS"))

    # A client language we have no translation for behaves like English.
    lua, own = run_locale("koKR")
    results.append(check("unsupported language: English fallback", len(own) == 0 and lua.eval("ns.L['Import']") == "Import"))

    for code in LOCALES:
        lua, tr = run_locale(code)
        stray = sorted(set(tr) - keys)
        missing = sorted(keys - set(tr))
        results.append(check("%s: no keys that the code does not use %s" % (code, stray[:3]), not stray))
        results.append(check("%s: every key used in the code is translated %s" % (code, missing[:3]), not missing))
        bad = [k for k, v in tr.items() if PLACEHOLDER.findall(k) != PLACEHOLDER.findall(v)]
        results.append(check("%s: same %% placeholders in the same order %s" % (code, bad[:2]), not bad))
        bad = [k for k, v in tr.items() if COLOR.findall(k) != COLOR.findall(v)]
        results.append(check("%s: same color codes %s" % (code, bad[:2]), not bad))
        bad = [k for k, v in tr.items() if not isinstance(v, str) or v.strip() == ""]
        results.append(check("%s: no empty translations" % code, not bad))
        results.append(check("%s: translated key is returned, unknown key falls back" % code,
                             lua.eval("ns.L['Veterans list']") != "Veterans list"
                             and lua.eval("ns.L['no such string']") == "no such string"))
        # The translated format strings still format with the arguments the code passes.
        fmt = lua.eval("function(f, ...) return pcall(string.format, f, ...) end")
        ok = True
        for k, v in tr.items():
            args = ["x" if p.endswith("s") else 1 for p in PLACEHOLDER.findall(k)]
            ok = ok and bool(fmt(v, *args)[0])
        results.append(check("%s: format strings format" % code, ok))

    # The other language's file stays silent in a deDE client.
    lua, tr = run_locale("deDE")
    results.append(check("deDE client loads only German", lua.eval("ns.L['Import']") == "Importieren"))
    lua, tr = run_locale("frFR")
    results.append(check("frFR client loads only French", lua.eval("ns.L['Import']") == "Importer"))

    # Compat.GetLocale: missing API, wrong type and a real value.
    for setup, expected, label in (
        ("GetLocale = nil", "enUS", "GetLocale missing -> enUS"),
        ("GetLocale = function() return nil end", "enUS", "GetLocale returns nil -> enUS"),
        ("GetLocale = function() error('boom') end", "enUS", "GetLocale errors -> enUS"),
        ("GetLocale = function() return 'deDE' end", "deDE", "GetLocale deDE -> deDE"),
    ):
        lua = lupa.LuaRuntime(unpack_returned_tuples=True)
        lua.execute("ns = {}; " + setup)
        lua.eval("function(src) assert(loadstring(src, 'Compat.lua'))('WarcraftLore', ns) end")(
            (ROOT / "Compat.lua").read_text(encoding="utf-8"))
        results.append(check(label, lua.eval("ns.Compat.GetLocale()") == expected))

    # And Locale.lua picks that up: no GetLocale at all -> English.
    lua = lupa.LuaRuntime(unpack_returned_tuples=True)
    lua.execute("ns = {}; GetLocale = nil")
    run = lua.eval("function(src, n) assert(loadstring(src, n))('WarcraftLore', ns) end")
    run((ROOT / "Compat.lua").read_text(encoding="utf-8"), "Compat.lua")
    run((ROOT / "Locale.lua").read_text(encoding="utf-8"), "Locale.lua")
    for path in sorted((ROOT / "Locales").glob("*.lua")):
        run(path.read_text(encoding="utf-8"), path.name)
    results.append(check("no GetLocale: ns.Locale is enUS and text stays English",
                         lua.eval("ns.Locale") == "enUS" and lua.eval("ns.L['Import']") == "Import"))

    print(f"\n{sum(results)}/{len(results)} passed")
    raise SystemExit(0 if all(results) else 1)


if __name__ == "__main__":
    main()

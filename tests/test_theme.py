"""The two looks in Style.lua (Lua 5.1 via lupa, fake client from test_journal.py): Warcraft II is the
default (also for saved settings without a theme), ApplyTheme changes the colors inside the shared
tables, every window header gets a switch button, the switch saves the theme and reloads (after the
confirmation popup when the client has one), and the WC2 panels have a bevel while badges stay flat.

Usage: python tests/test_theme.py   (needs: pip install lupa)
"""

import re

import lupa.lua51 as lupa

from test_journal import ADDON, LOAD, STUBS, check


def fresh():
    lua = lupa.LuaRuntime(unpack_returned_tuples=True)
    lua.execute(STUBS)
    lua.execute(LOAD)
    lua.execute("reloads = 0; ReloadUI = function() reloads = reloads + 1 end")
    load = lua.eval("load")
    load((ADDON / "Locale.lua").read_text(encoding="utf-8"), "Locale.lua")
    load((ADDON / "Style.lua").read_text(encoding="utf-8"), "Style.lua")
    return lua


def main():
    r = []
    lua = fresh()
    ev = lua.eval

    r.append(check("Warcraft II is the theme before the settings load", ev("ns.Style.theme") == "wc2"))
    r.append(check("no saved theme -> Warcraft II", ev("ns.Style.ApplyTheme(nil)") == "wc2"))
    r.append(check("unknown saved theme -> Warcraft II", ev("ns.Style.ApplyTheme('purple')") == "wc2"))
    wc2_title = ev("ns.Style.COL.title[1]")
    lua.execute("keep = ns.Style.COL.title; keepCol = ns.Style.COL")
    r.append(check("classic applies", ev("ns.Style.ApplyTheme('classic')") == "classic" and ev("ns.Style.IsWC2()") is False))
    r.append(check("colors change inside the same tables",
                   ev("keep == ns.Style.COL.title and keepCol == ns.Style.COL") and abs(ev("keep[1]") - wc2_title) > 0.01))
    r.append(check("classic color codes", ev("ns.Style.HEX_TITLE") == "|cffd4c6f7" and ev("ns.Style.HEX_MUTED") == "|cffa79d8a"))
    lua.execute("ns.Style.ApplyTheme('wc2')")
    r.append(check("WC2 color codes", ev("ns.Style.HEX_TITLE") == "|cfff2d36b"))
    for key in ("MUTED", "TITLE", "MET", "VIOLET", "GOLD"):
        r.append(check(f"HEX_{key} is a color code", bool(re.fullmatch(r"\|cff[0-9a-f]{6}", ev(f"ns.Style.HEX_{key}")))))
    r.append(check("other theme / labels", ev("ns.Style.OtherTheme()") == "classic"
                   and ev("ns.Style.ThemeLabel('wc2')") == "Warcraft II look"
                   and ev("ns.Style.ThemeLabel('classic')") == "Classic look"))

    # WC2 panels: shadow on top/left, the edge color on bottom/right; badges keep one color.
    lua.execute("""
        local S = ns.Style
        panel = S.box(UIParent)
        panel:SetColors(S.COL.inner, 1, S.COL.gold, 1)
        tag = S.badge(UIParent)
        tag:Set("WC2", S.COL.gold)
    """)
    r.append(check("WC2 panel has a dark base", ev("panel.base ~= nil")))
    r.append(check("WC2 panel: top and left are shadow",
                   ev("panel.edges[1].color[1]") == 0 and ev("panel.edges[3].color[1]") == 0))
    r.append(check("WC2 panel: bottom and right take the edge color",
                   abs(ev("panel.edges[2].color[1]") - ev("ns.Style.COL.gold[1]")) < 1e-6
                   and abs(ev("panel.edges[4].color[1]") - ev("ns.Style.COL.gold[1]")) < 1e-6))
    r.append(check("WC2 badge keeps one color on all edges",
                   all(abs(ev(f"tag.edges[{i}].color[1]") - ev("ns.Style.COL.gold[1]")) < 1e-6 for i in range(1, 5))))

    # A window in each theme: frame art, inner panel, header with close and switch button.
    for theme, other in (("wc2", "classic"), ("classic", "wc2")):
        lua = fresh()
        ev = lua.eval
        lua.execute(f"""
            WarcraftLoreDB = {{}}
            ns.Style.ApplyTheme("{theme}")
            local S = ns.Style
            win = CreateFrame("Frame", "Win", UIParent)
            S.buildFrameArt(win, 520, 640)
            inner = S.buildInner(win)
            closed = 0
            before = #frames
            close, title = S.buildHeader(inner, "Warcraft Veterans", function() closed = closed + 1 end)
            switch = nil
            for i = before + 1, #frames do
                local f = frames[i]
                if f.kind == "Button" and f ~= close then switch = f end
            end
        """)
        r.append(check(f"{theme}: header returns close and title", ev("close ~= nil and title ~= nil and title.text") == "Warcraft Veterans"))
        lua.execute("close.scripts.OnClick(close)")
        r.append(check(f"{theme}: close calls onClose", ev("closed") == 1))
        r.append(check(f"{theme}: a switch button next to the close X", ev("switch ~= nil") and ev("clicksRegistered[switch]") is True))
        lua.execute("switch.scripts.OnClick(switch)")
        r.append(check(f"{theme}: no popup in this client -> saves '{other}' and reloads",
                       ev("WarcraftLoreDB.theme") == other and ev("reloads") == 1))

    # With the confirmation popup: nothing happens until the player accepts.
    lua = fresh()
    ev = lua.eval
    lua.execute("""
        WarcraftLoreDB = {}
        shownPopup = nil
        StaticPopupDialogs = {}
        StaticPopup_Show = function(name) shownPopup = name end
        ok = ns.Style.RequestTheme("classic")
    """)
    r.append(check("popup shown, nothing saved yet",
                   ev("ok") is True and ev("shownPopup") == "WARCRAFTLORE_THEME"
                   and ev("WarcraftLoreDB.theme") is None and ev("reloads") == 0))
    lua.execute("StaticPopupDialogs.WARCRAFTLORE_THEME.OnAccept()")
    r.append(check("accept saves and reloads", ev("WarcraftLoreDB.theme") == "classic" and ev("reloads") == 1))
    r.append(check("unknown theme is refused", ev("ns.Style.RequestTheme('purple')") is False))
    lua.execute("WarcraftLoreDB = nil")
    r.append(check("no saved settings yet: refused, no error", ev("ns.Style.RequestTheme('wc2')") is False))

    # Core applies the saved theme before any window is built.
    core = (ADDON / "Core.lua").read_text(encoding="utf-8")
    load_at = core.find("ns.SavedData.Load()")
    apply_at = core.find("ApplyTheme(WarcraftLoreDB.theme)")
    window_at = core.find('guard("window"')
    r.append(check("Core applies the saved theme after loading the settings, before the windows",
                   0 <= load_at < apply_at < window_at))
    r.append(check("/wcl theme command exists", '["theme classic"]' in core and '["theme wc2"]' in core))

    toc = (ADDON / "WarcraftLore.toc").read_text(encoding="utf-8")
    r.append(check("theme textures exist", (ADDON / "Textures" / "WC2Leather.tga").exists()
                   and (ADDON / "Textures" / "WC2Stone.tga").exists()))
    r.append(check("Locale.lua loads before Style.lua", toc.index("Locale.lua") < toc.index("Style.lua")))

    passed = sum(1 for x in r if x)
    print(f"\n{passed}/{len(r)} passed")
    raise SystemExit(0 if passed == len(r) else 1)


if __name__ == "__main__":
    main()

"""Width check for the fixed-width controls, in enUS, deDE and frFR.

Every string that sits in a control with a fixed width is measured with the project's pessimistic
estimate (6 px per character, 7 px for bold/title text) against the room that control has:
the filter buttons and count row of the Veterans list, the Options buttons, the Journal chips,
rows, dates and banner, the "+N more" target of the alert and the column headings.
A translation that does not fit fails here instead of showing "..." in the game.

Usage: python tests/test_widths.py   (needs: pip install lupa)
"""

import re
import sys
from pathlib import Path

import lupa.lua51 as lupa

sys.path.insert(0, str(Path(__file__).resolve().parent))
from test_atlas import STUBS  # noqa: E402  (the fake client that loads Browser.lua)

ADDON = Path(__file__).resolve().parent.parent / "WarcraftLore"
CODES = ("enUS", "deDE", "frFR")
COLOR = re.compile(r"\|c[0-9a-fA-F]{8}|\|r")

BODY, BOLD = 6, 7


def px(text, per=BODY):
    return per * len(COLOR.sub("", text))


def lua_const(src, name):
    m = re.search(r"^local %s\s*=\s*(\d+)" % name, src, re.M)
    return int(m.group(1)) if m else None


def runtime(code):
    lua = lupa.LuaRuntime(unpack_returned_tuples=True)
    lua.execute(STUBS)
    lua.execute("ns.Compat.GetLocale = function() return '%s' end" % code)
    lua.execute("date = os.date")
    run = lua.eval("function(src, n) assert(loadstring(src, n))('WarcraftLore', ns) end")
    run((ADDON / "Locale.lua").read_text(encoding="utf-8"), "Locale.lua")
    if code != "enUS":
        run((ADDON / "Locales" / (code + ".lua")).read_text(encoding="utf-8"), code + ".lua")
    run((ADDON / "Browser.lua").read_text(encoding="utf-8"), "Browser.lua")
    return lua


def main():
    data = (ADDON / "Data.lua").read_text(encoding="utf-8")
    zones = set(re.findall(r'\bzone\s*=\s*"([^"]+)"', data))
    names = set(re.findall(r'\bname\s*=\s*"([^"]+)"', data))
    longest_zone, longest_name = max(zones, key=len), max(names, key=len)
    toast = (ADDON / "Toast.lua").read_text(encoding="utf-8")
    more_w = lua_const(toast, "MORE_W") or 56
    banner_w = int(re.search(r"BANNER_W, BANNER_H.*?=\s*(\d+)", toast).group(1))
    opt = (ADDON / "Options.lua").read_text(encoding="utf-8")
    button_w = int(re.search(r"b:SetSize\((\d+), 24\)", opt).group(1))

    r = []

    def check(name, cond, detail=""):
        print(("ok   " if cond else "FAIL ") + name + (f"  ({detail})" if detail and not cond else ""))
        r.append(bool(cond))

    for code in CODES:
        lua = runtime(code)
        L = lua.eval("ns.L")
        t = lambda key: L[key]
        tag = code + ": "

        # Veterans list filter row.
        lay = lua.eval("ns.Browser.FilterLayout()")
        zone_room = lay.zone - lay.chevronInset - lay.labelInset
        camp_room = lay.campaign - lay.chevronInset - lay.labelInset
        stat_room = lay.status - 2 * lay.labelInset
        s = t("Zone") + " " + t("All zones")
        check(tag + f"'{s}' fits the Zone button", px(s) <= zone_room, f"{px(s)} > {zone_room}")
        s = t("Campaign") + " " + t("All campaigns")
        check(tag + f"'{s}' fits the Campaign button", px(s) <= camp_room, f"{px(s)} > {camp_room}")
        for status in ("All", "Met", "Not met"):
            s = t("Show") + " " + t(status)
            check(tag + f"'{s}' fits the Show button", px(s) <= stat_room, f"{px(s)} > {stat_room}")

        # Count row: the count text gets what the toggle, This zone and Clear filters leave.
        book = px(t("Hide book-only")) + 16
        here, clear = px(t("This zone")), px(t("Clear filters"))
        count_w = lua.eval("ns.Browser.CountRowWidth")(book, here, clear)
        strip = lambda x: COLOR.sub("", x)
        lines = [
            t("Showing all %d veterans") % 130,
            t("Showing %d of %d") % (130, 130),
            strip(lua.eval("ns.Browser.ZoneLine")(99, 99, 98)),
        ]
        for line in lines:
            check(tag + f"count text '{line}' fits {count_w} px", px(line) <= count_w, f"{px(line)} > {count_w}")

        # Column headings (9 pt): APPEARS IN has the 100 px games column minus its margin.
        check(tag + "'APPEARS IN' fits its column", px(t("APPEARS IN")) <= 100 - 10)
        check(tag + "'ZONE' fits before the games column", px(t("ZONE")) <= 100)

        # Options buttons: a fixed 170 px (12 pt) with 8 px each side.
        for key in ("Open Veterans list", "Reset window positions"):
            check(tag + f"Options button '{t(key)}'", px(t(key)) <= button_w - 16, f"{px(t(key))} > {button_w - 16}")

        # Journal chips: six equal chips in the 456 px content width.
        chip_w = (456 - 4 * 5) // 6
        for key in ("All", "Milestones", "Games", "Zones", "Circles", "Special"):
            check(tag + f"Journal chip '{t(key)}'", px(t(key)) <= chip_w - 8, f"{px(t(key))} > {chip_w - 8}")

        # Journal rows: titles (bold 12 pt) have 304 px, dates have the 100 px column.
        titles = [t(k) for k in ("First Contact", "Old Soldiers", "Seasoned Traveller", "Keeper of Lore",
                                 "Living Archive", "Where It Began", "Tides of Darkness", "Beyond the Portal",
                                 "The Forsaken Kingdom", "Bookworm", "Veterans of the Third War",
                                 "Veterans of the Frozen Throne", "Grand Librarian", "Archivist", "Across the Ages")]
        zone_title = t("Veterans of %s") % longest_zone
        circle_titles = [t("%s's Circle") % longest_name, t("%s' Circle") % longest_name]
        for title in titles + [zone_title] + circle_titles:
            check(tag + f"Journal title '{title}'", px(title, BOLD) <= 304, f"{px(title, BOLD)} > 304")
        for month in range(1, 13):
            when = lua.eval("ns.FormatDate")(1759449600 + (month - 10) * 30 * 86400)
            check(tag + f"date '{when}' fits the date column", when is not None and px(when) <= 90)

        # Achievement banner: the title (bold 14 pt) has banner width - 24 px.
        for title in titles + [zone_title]:
            check(tag + f"banner title '{title}'", px(title, BOLD) <= banner_w - 24, f"{px(title, BOLD)} > {banner_w - 24}")
        for key in ("ACHIEVEMENT EARNED", "ACHIEVEMENTS EARNED"):
            check(tag + f"banner head '{t(key)}'", px(t(key)) <= banner_w - 24)
        s = t("%d new achievements") % 99
        check(tag + f"banner count '{s}'", px(s, BOLD) <= banner_w - 24, f"{px(s, BOLD)} > {banner_w - 24}")

        # The "+N more" target on the nearby alert.
        s = t("+%d more") % 12
        check(tag + f"'{s}' fits the {more_w} px target", px(s) <= more_w, f"{px(s)} > {more_w}")

    print(f"\n{sum(r)}/{len(r)} passed")
    raise SystemExit(0 if all(r) else 1)


if __name__ == "__main__":
    main()

"""python tools/uishots/shoot.py [name ...]: runs scenarios and renders PNGs into tools/uishots/shots/.

Runs the addon's real Lua code (from the toc) in fengari against a WoW mock (wowmock.lua), then draws
the dumped frames with PIL (render.py). No game needed. Portraits, 3D models and Blizzard icons
show as "?" or a silhouette; the minimap and world map are not drawn.
With no names, every scenario below runs. First time: `npm install` in this folder (fengari).
"""
import os, subprocess, sys

H = os.path.dirname(os.path.abspath(__file__))
ADDON = os.path.normpath(os.path.join(H, "..", "..", "WarcraftLore"))
os.makedirs(os.path.join(H, "shots"), exist_ok=True)
BOTH = "WarcraftLoreBrowser,WarcraftLoreFrame"
SHOTS = [  # scenario, crop (frame names, or box:x0,y0,x1,y1 on the 1920x1080 screen)
    # basic states, empty met list
    ("lore", "WarcraftLoreFrame"),
    ("browser", "WarcraftLoreBrowser"),
    ("browser_filtered", "WarcraftLoreBrowser"),
    ("browser_met", "WarcraftLoreBrowser"),
    ("browser_empty", "WarcraftLoreBrowser"),
    ("browser_popup", "WarcraftLoreBrowser"),
    ("browser_hidebook", "WarcraftLoreBrowser"),
    ("browser_tip", "WarcraftLoreBrowser,GameTooltip"),
    ("both", BOTH),
    ("alert", "box:700,20,1220,240"),
    # a player some weeks in (scenarios/prog.lua): Journal, memorials, banner, both themes
    ("m_both", BOTH),
    ("m_classic", BOTH),
    ("m_journal", "WarcraftLoreJournal"),
    ("m_memorials", "WarcraftLoreBrowser"),
    ("m_memorials_zone", "WarcraftLoreBrowser"),
    ("m_tip", "WarcraftLoreBrowser,GameTooltip"),
    ("m_banner", "box:800,30,1120,330"),
]


def run(cmd):
    return subprocess.run(cmd, cwd=H, capture_output=True, text=True, encoding="utf-8", errors="replace")


wanted = set(sys.argv[1:])
ok = True
for scen, crop in SHOTS:
    if wanted and scen not in wanted:
        continue
    r = run(["node", "run.js", ADDON, "scenarios/common.lua", "scenarios/prog.lua", f"scenarios/{scen}.lua"])
    if r.returncode != 0:
        print("SCENARIO FAILED", scen, r.stderr.strip())
        ok = False
        continue
    for line in r.stdout.splitlines():
        if line.startswith("rows"):
            print(scen, line)
    r = run([sys.executable, "render.py", f"shots/{scen}.json", f"shots/{scen}.png", "--crop", crop, "--margin", "24", "--addon", ADDON])
    if r.returncode != 0:
        print("RENDER FAILED", scen, r.stderr.strip()[-400:])
        ok = False
    else:
        print(r.stdout.strip())
sys.exit(0 if ok else 1)

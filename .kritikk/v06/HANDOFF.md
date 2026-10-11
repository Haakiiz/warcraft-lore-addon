# v0.6 handoff (gauntlet-loop, 2026-10-11)

Branch `session/v0.6` (built on `session/v0.5`, PR #10). Same rules as .kritikk/v05/HANDOFF.md: yardstick,
Avoid list, only confirmed lore, no merge into main, no tags, no CurseForge changes.

## Parts
| Part | Branch | Owner files | Status |
|---|---|---|---|
| A Zone atlas in the list | v06/atlas | Browser.lua, tests/test_atlas.py | worker running |
| B Export/import met list | v06/share | Share.lua, .toc, Core COMMANDS, tests/test_share.py | worker running |
| C World map pins (no libs) | v06/mappins | MapPins.lua, .toc, Options.lua, tests/test_mappins.py | worker running |
| D Polish from critic_final | v06/polish | UI.lua, Toast.lua, .toc Notes, Data.lua comments | worker running |
| E New zones (17 zones + 4 dungeons) | v06/zones | Data.lua entries | orchestrator prep running, then Haiku workers + Haiku critics (brief v3) |

## Zones in round E (Wowhead classic zone IDs)
Kalimdor: Tanaris 440, Azshara 16, Felwood 361, Un'Goro 490, Moonglade 493, Winterspring 618, Silithus 1377.
Eastern Kingdoms: Arathi 45, Stranglethorn 33, Badlands 3, Swamp of Sorrows 8, Hinterlands 47, Searing Gorge 51,
Burning Steppes 46, Blasted Lands 4, Deadwind Pass 41, Eastern Plaguelands 139.
Dungeons: Uldaman 1337, Zul'Farrak 1176, Maraudon 2100, Sunken Temple 1477.

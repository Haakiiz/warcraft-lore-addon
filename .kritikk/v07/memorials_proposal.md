# Proposal: "Memorials" – meeting RTS characters who are no longer alive

Source: `memorials_report.md` (same folder). No WC1/WC2/BTDP character is a classic NPC, but 14 classic-era places and objects commemorate them, plus 2 more for WC3/TFT-only characters.

## How many solid ACCEPTs

| Grade | Count | What it means |
|---|---|---|
| A: the object's name or text names the character | **11** (List 1) + **1** (List 2: Armor of Mannoroth) = **12** | Clickable plaques/tombs with a tooltip and a readable text |
| B: named after them, or depicts them without naming them | **3** (Khadgar's Whisker, Orgrimmar, Lothar statue) + **1** (Arthas' Tears) = **4** | No in-game text says who it is |
| Story books (History of Warcraft) | 18 objects | Optional third layer |
| POSSIBLE (check in game / uncited) | 4 (Hammerfall, Kargath, Menethil Harbor, Grommash Hold) | Do not ship before checking |

By game (List 1, A+B, 14): **WC1** 3 (Llane, Lothar statue, Orgrimmar/Orgrim). **WC2 ToD** 7 (Uther, Terenas, Thoras, Daelin, Turalyon, Lothar statue, Orgrimmar). **BTDP** 8 (Turalyon, Khadgar plaque, Khadgar's Whisker, Alleria, Danath, Kurdran, Grom, Daelin). Characters in more than one game are counted in each game.

## How a player meets each one

Mouseover tooltips: in Classic every **interactable** gameobject shows its name in the GameTooltip when hovered. That covers type 9 plaques, quest objects and herb nodes. Map doodads (the statues themselves, buildings, the unclickable Lotharian Lotus) show nothing. Detection ideas for the addon (to be checked in game before relying on them):
- **Plaques (type 9 text):** clicking one fires `ITEM_TEXT_BEGIN`, and `ItemTextGetItem()` returns the object name (e.g. "General Turalyon"). This is a reliable trigger.
- **Hover:** hook `GameTooltip:OnShow`. When `UnitExists("mouseover")` is false, read `GameTooltipTextLeft1:GetText()` and match it against the object names.
- **Places:** `ZONE_CHANGED`/`ZONE_CHANGED_NEW_AREA` + `GetSubZoneText()`/`GetZoneText()`. Note that the Classic subzone text is "Valley Of Heroes" (capital O, until 2.4.0). Forever may use either spelling, so match without regard to case.
- **Quest object:** at `QUEST_DETAIL`/`QUEST_COMPLETE`, `UnitName("npc")` returns the object name ("Trollbane's Tomb").

| # | Memorial | Character (game) | How to meet it |
|---|---|---|---|
| 1 | **Uther the Lightbringer**, Uther's Tomb, WPL 52.1, 83.2 | Uther (WC2, WC3) | Walk into the subzone "Uther's Tomb" (south of Andorhal), then hover/click the marker stone before the statue |
| 2 | **Here Lies King Terenas Menethil II**, behind the Lordaeron throne room (Wowhead: Undercity map 65.9, 43.4) | Terenas (WC2, WC3) | Horde walk past it on the way into Undercity. Alliance can reach the ruins with care. Click the plaque |
| 3 | **Trollbane's Tomb**, Stromgarde Keep crypt, Arathi 28.9, 59.6 | Thoras Trollbane (WC2) | Hover the tomb (quest object). Horde finish "Trol'kalar" (645) and start (646) here. The area is hostile (level 40+) |
| 4 | **King Llane I of the House of Wrynn**, Royal Gallery, Stormwind Keep 64.2, 6.4 | Llane (WC1) | Go through the keep courtyard to the Royal Gallery and click the statue plaque |
| 5 | **Grand Admiral Daelin Proudmoore**, Royal Gallery 64.7, 6.8 | Daelin (WC2, BTDP, TFT) | Same room, next statue |
| 6 | **General Turalyon**, Valley of Heroes 63.8, 75.1 | Turalyon (WC2, BTDP) | Every visitor to Stormwind passes it. Click the plaque at the end of the main road before the gate |
| 7 | **Archmage Khadgar of the Kirin Tor**, 64.9, 78.2 | Khadgar (BTDP) | Valley of Heroes, left side |
| 8 | **Ranger Captain Alleria Windrunner**, 65.4, 77.4 | Alleria (BTDP) | Valley of Heroes, right side |
| 9 | **Danath Trollbane**, 67.3, 80.4 | Danath (BTDP) | Valley of Heroes, right side |
| 10 | **Kurdran Wildhammer**, 66.4, 81.0 | Kurdran (BTDP) | Valley of Heroes, left side |
| 11 | **Monument to Grom Hellscream**, Demon Fall Canyon, Ashenvale 82.9, 79.1 | Grom (BTDP, WC3) | Walk into Demon Fall Canyon (hostile demons, level 30s) and click the monument |
| 12 | **The Armor of Mannoroth**, Valley of Wisdom, Orgrimmar 45.3, 34.9 | Mannoroth (WC3) | Horde in Orgrimmar. Click the plate at the foot of the white tree |
| 13 | **Khadgar's Whisker** herb nodes (2043) | Khadgar (BTDP) | Hover any node (herbalists see them on the minimap). Very common in Arathi, STV, Feralas and Dustwallow |
| 14 | **Arthas' Tears** herb nodes (142141, 176642) | Arthas (WC3) | Hover a node in the Plaguelands or Felwood |
| 15 | **Orgrimmar** (city) | Orgrim Doomhammer (WC1, WC2) | Entering the zone. Lore note only: no in-game text gives the reason for the name |
| 16 | **Statue of Anduin Lothar**, Burning Steppes (~47, 54 Classic) | Lothar (WC1, WC2) | Walk past the giant knight statue in the central orc camp, sword raised toward Blackrock Mountain. No tooltip, so it can only be detected by coordinates (or by subzone "Pillar of Ash", to be checked). Confirm the statue in game first |

## Recommendation

- Ship the 12 A-grade objects as "Memorials" entries keyed by **object name**, not by NPC ID. Each entry shows the character's RTS appearances (game + missions, as in Data.lua `appearances`) and the inscription.
- The six Stormwind objects (Valley of Heroes ×5, Royal Gallery ×2) and Uther/Terenas give both factions an easy start. Grom and Mannoroth are Horde-friendly.
- Add the B-grade items as lighter "named after" notes (herb tooltips, the Orgrimmar zone entry, Lothar's statue by coordinates). Do this only after Lothar's statue is confirmed in game.
- Leave the 18 story books as a possible later "Library" feature.
- Do not use the POSSIBLE items until a citation or in-game check exists.

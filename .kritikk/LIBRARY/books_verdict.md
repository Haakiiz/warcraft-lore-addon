# History of Warcraft books - verdict

Checked 2026-10-24 against Wowhead Classic object pages (g_mapperData, tolerance 1.5) and the wiki raw pages. Validator: `py -3 tests/validate_db.py` on a temp copy with the new block: "OK: 30 memorials, all fields valid".

All 15 existing books: object ID and name exist, every location (zone + coords) matches g_mapperData exactly, no missing or extra locations. Zone names are the Data.lua names (Booty Bay = "Stranglethorn Vale", Darnassus kept as Darnassus). No banned words, no copied text, no quotes.

| Book (ID) | Verdict | Evidence / change |
|---|---|---|
| The Last Guardian (175740) | FIX | "tired of the Council" is not in the text (book: Aegwynn "distrustful" of it). Changed. Rest supported. |
| Rise of the Horde (175742) | PASS | Every sentence matches; all 7 honors named. |
| Dark Portal and Fall of Stormwind (175745) | FIX | "King Llane's cautious plan" unsupported; book says Llane holds his position at Stormwind. Reworded. |
| Alliance of Lordaeron (175746) | PASS | Supported; Anasterian, Uther, Daelin, Turalyon, Khadgar all named. |
| Aftermath of the Second War (21581) | PASS | Supported. Not in wiki index (in-game extra); placed at 5. |
| Beyond the Dark Portal (21582) | FIX | Opening sentence referred to another book ("same events as The Invasion of Draenor"), which is not in the addon; removed. |
| The New Horde (175752) | FIX | Appearance used game WC3 for the novel Lord of the Clans; Data.lua uses game = "BOOK" for it. Changed to BOOK. |
| Kel'Thuzad and the Forming of the Scourge (175754) | FIX | "already shunned" overstated; book says "maverick". Reworded. |
| The Scourge of Lordaeron (175756) | PASS | Supported. |
| Sunwell - The Fall of Quel'Thalas (175757) | PASS | Supported. Booty Bay coords from Wowhead (27.1, 77.7 STV). |
| Archimonde's Return and the Flight to Kalimdor (175758) | PASS | Supported; 3 campaigns match Data.lua names. |
| The Betrayer Ascendant (175759) | PASS | Supported. Wowhead 66.5, 76.6 used (wiki says 61.9, 74.6; Wowhead is the reference). |
| Rise of the Blood Elves (175760) | FIX | Said Kael and Vashj "follow Illidan to Outland" and defeat Maiev; book: they follow Vashj, Maiev had already recaptured Illidan. Fixed. |
| Civil War in the Plaguelands (175761) | PASS | Supported. |
| Old Hatreds (175763) | FIX | honors listed Cairne Bloodhoof, who is not named in the book. Removed. |

REJECT: none.

## Order (wiki History of Warcraft index, Chapters II-V)
Index: Last Guardian, Rise of the Horde, Dark Portal, Alliance of Lordaeron, Invasion of Draenor, Birth of the Lich King, Icecrown, Grim Batol, Lethargy, New Horde, War of the Spider, Kel'Thuzad, Alliance Splinters, Scourge, Sunwell, Archimonde, Hyjal, Betrayer, Blood Elves, Civil War, Lich King Triumphant, Old Hatreds. The old numbering skipped slots wrongly once the three new books exist, so orders are renumbered to leave gaps for books not in the addon (Invasion of Draenor 6, Lethargy 11, War of the Spider 13, Alliance Splinters 15, Hyjal 19, Lich King Triumphant 23):
1 Last Guardian, 2 Rise, 3 Dark Portal, 4 Alliance, 5 Aftermath, 7 Beyond the Dark Portal, 8 Birth, 9 Icecrown, 10 Grim Batol, 12 New Horde, 14 Kel'Thuzad, 16 Scourge, 17 Sunwell, 18 Archimonde, 20 Betrayer, 21 Blood Elves, 22 Civil War, 24 Old Hatreds.
Aftermath (5) and Beyond (7) are in-game extras not in the index; their placement is a judgment call.

## New books (all exist in Classic with coordinates, verified in g_mapperData)
- The Birth of the Lich King (175748): Duskwood 72.0, 46.4; Hillsbrad Foothills 52.0, 58.4. PASS. Story from the book text; game BTDP (picks up with Ner'zhul's flight from Draenor) - judgment call.
- Icecrown and the Frozen Throne (175749): Elwynn Forest 43.8, 65.8; Undercity 55.9, 50.9. PASS. Game WC3 "The Scourge of Lordaeron (Human)" as background to Reign of Chaos (same approach as the Kel'Thuzad book).
- The Battle of Grim Batol (175750): Wetlands 10.8, 60.8; Mulgore 31.5, 49.4. PASS. Retells the novel Day of the Dragon, so game = "BOOK", campaign "Day of the Dragon" (same name as in Data.lua). Book page is "The_Battle_of_Grim_Batol_(History_of_Warcraft)" (the plain title redirects to the event); source link uses it.

## Not added (out of scope, uncertain in books_report.md)
The Invasion of Draenor, The Alliance Splinters, The Lich King Triumphant: only zone-level instance spawns, no coordinates; left out.

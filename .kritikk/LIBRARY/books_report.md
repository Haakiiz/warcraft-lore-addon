# Library books report

Source: Wowhead Classic object pages (g_mapperData) fetched 2026-10-24; text from warcraft.wiki.gg raw pages (needs a full browser User-Agent; the short "Mozilla/5.0" gets 403 there). Summaries are in my own words. Series order follows the History of Warcraft index (Chapters II-V). "Aftermath of the Second War" and "Beyond the Dark Portal" are not on that index, so their slots (5 and 7) are my choice.

Mapping caveat: the wiki's "The Last Guardian", "Rise of the Horde", "Beyond the Dark Portal" and "The Scourge of Lordaeron" pages are novels/other things; the in-game book pages have the "(History of Warcraft)" suffix.

| # | Book | Status | Locations | Notes |
|---|---|---|---|---|
| 1 | The Last Guardian (175740) | found | 2 | Loch Modan, Westfall. Story is Aegwynn/Medivh backstory, so WC1 only as background. |
| 2 | Rise of the Horde (175742) | found | 3 | WC1 background (pre-First War), campaign field generic. |
| 3 | The Dark Portal and the Fall of Stormwind (175745) | found | 3 | Wiki also lists Stormwind Keep War Room and Legacy of Scholomance; Wowhead Classic does not, so they are left out. |
| 4 | The Alliance of Lordaeron (175746) | found | 5 | Wiki also lists Silvermoon (TBC, not included). |
| 5 | Aftermath of the Second War (21581) | found | 4 | Order slot is my choice. |
| 6 | The Invasion of Draenor (175747) | UNCERTAIN | 1 (Scholomance, no coords) | Wowhead Classic lists only Scholomance (zone-level, no coords). Wiki says it sits in the "Legacy of Scholomance" (Mists remake), so it may not be in Classic Scholomance. Verify in game before showing. |
| 7 | Beyond the Dark Portal (21582) | found | 4 | Order slot is my choice. |
| 8 | The New Horde (175752) | found | 3 | Campaign set to the novel "Lord of the Clans" (as in Data.lua), not a game campaign. |
| 9 | Kel'Thuzad and the Forming of the Scourge (175754) | found | 2 | Pre-WC3 background; campaign field is an approximation. Wiki lists more places (Scarlet Monastery Library, Stratholme) that are Cata+ and not included. |
| 10 | The Alliance Splinters (175755) | UNCERTAIN | 1 (Blackrock Depths, no coords) | Wiki says "No corresponding in-game book" for it, yet Wowhead Classic has object 175755 in Blackrock Depths with zero coordinates. Probably unreachable or text-less. Recommend skipping unless confirmed. |
| 11 | The Scourge of Lordaeron (175756) | found | 3 | |
| 12 | Sunwell - The Fall of Quel'Thalas (175757) | found | 2 | Wiki's Booty Bay coords (41.05, 74.44, Cape of Stranglethorn) differ from Wowhead (27.1, 77.7 in STV); I used Wowhead. |
| 13 | Archimonde's Return and the Flight to Kalimdor (175758) | found | 2 | Wiki lists Ratchet and Stormwind Academy; Wowhead Classic has Barrens and Desolace only. Three appearances (Path of the Damned, Invasion of Kalimdor, Eternity's End). |
| 14 | The Betrayer Ascendant (175759) | found | 1 | Wowhead 66.5, 76.6; wiki says 61.9, 74.6 in Darnassus. Used Wowhead. |
| 15 | Rise of the Blood Elves (175760) | found | 3 | Campaign "Curse of the Blood Elves" is the wiki's name; not in Data.lua. |
| 16 | Civil War in the Plaguelands (175761) | found | 5 | |
| 17 | The Lich King Triumphant (175762) | UNCERTAIN | 2 (Stratholme, Scholomance; no coords) | Wowhead Classic zone-level only. Wiki lists the retail Legacy of Scholomance, Cata+ areas. Verify in game. |
| 18 | Old Hatreds - The Colonization of Kalimdor (175763) | found | 1 | |

## Notes
- Instance entries use coords = "" (Wowhead has none). Zone names Scholomance, Stratholme, Blackrock Depths match ZONE_LEVEL in Achievements.lua.
- Where a location had two near-identical coordinates on Wowhead (duplicate spawn), only the first is used.
- Not requested but also in Classic (all History of Warcraft, located): The Birth of the Lich King 175748 (Duskwood 72.0, 46.4; Hillsbrad 52.0, 58.4), Icecrown and the Frozen Throne 175749 (Elwynn 43.8, 65.8; Undercity 55.9, 50.9), The Battle of Grim Batol 175750 (Wetlands 10.8, 60.8; Mulgore 31.5, 49.4). They sit at slots between 6 and 8 in the wiki order (Birth, Icecrown, Grim Batol after Invasion of Draenor). Not written to books.lua.
- The page also says "Found at" other places on the wiki that are post-Classic remakes; those were intentionally dropped.
- Entries in books.lua are the table body only (no outer ns.MEMORIALS = { }); the file begins with comments, then entries.

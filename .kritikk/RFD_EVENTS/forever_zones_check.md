# WoW: Forever zone and NPC source check (2026-10-24)

Scope: can NPCs of the new Forever zones/dungeons/raids be found on Wowhead or another public database, with IDs and coordinates?

Short answer: partly. Wowhead has a Forever section and Forever-specific zone pages exist, but the zone pages returned HTTP 403 for every request, so NPC lists were not verified. No NPC IDs or coordinates were obtained. No IDs were guessed.

## Game status (from the guide sites)

- The game is in beta. Guide sites list launch as Nov 4, 2026, 3 p.m. PST. Wowhead's Forever page shows a countdown to the same launch.
- Barrow Deeps, Hyjal Summit and Onyxia's Lair are listed as **raids**, not dungeons, with raid unlock on Dec 9, 2026. The brief called Barrow Deeps and Hyjal Summit dungeons; the sources say raids.
- Krol'dok Stronghold is a level 40-45 ogre dungeon (wowforeverguides news, PAX Aus).
- A "City of Dalaran Excavation Site: Wetlands" entry appears on the wowforeverguides dungeon list (the new Dalaran dungeon, probably).
- Zones confirmed by the guide sites: Zephras Isle (Skyborne start), Mount Hyjal, Riverglades, Shen'dralas.
- Build 1.60.1 / interface 16001 was not verified against any source. Wowhead and the guide sites list patch 16001 in metadata.

## Per zone

| Zone | Wowhead Classic/standard search | Wowhead Forever | Guide sites | NPC IDs / coords |
|---|---|---|---|---|
| Mount Hyjal (Renewed) | Only the old Cata/Classic zone (zone=616). Not Forever. | Forever zone page link found: https://www.wowhead.com/forever/zone=616/mount-hyjal (403) | Listed as zone | Not found |
| Shen'dralas | No Forever zone in search | https://www.wowhead.com/forever/zone=16651/shendralas (403) | Listed as zone | Not found |
| Riverglades | No Forever zone in search | https://www.wowhead.com/forever/zone=16591/riverglades (403) | Listed as zone | Not found |
| Zephras Isle | No Forever zone in search | https://www.wowhead.com/forever/zone=16593/zephras-isle (403) | Listed; zone overview guide https://www.wowhead.com/forever/guide/... (article id 34862 in search JSON) | Not found |
| City of Dalaran (reworked) | Only old Dalaran hits | Not found | Dungeon list entry; no zone ID | Not found |
| Krol'Dok Stronghold | No Forever result | Not found (no zone ID found) | Confirmed dungeon | Not found |
| New Dalaran dungeon | Not found | Not found | Probably "City of Dalaran Excavation Site: Wetlands" | Not found |
| Hyjal Summit (raid) | Old Cata zone hit only | Not found | Raid, unlocks Dec 9 | Not found |
| Barrow Deeps (raid) | Old zone hit only | Not found | Raid, unlocks Dec 9 | Not found |

Extra Forever zone found: Darkspear Islands, https://www.wowhead.com/forever/zone=16606/darkspear-islands (403).

## What was checked

1. Wowhead classic and standard search (https://www.wowhead.com/classic/search?q=..., https://www.wowhead.com/search?q=...). All returned HTTP 200 but are JavaScript-rendered. Results are not in the HTML. The zone IDs in the raw HTML are old-expansion zones, not Forever.
2. Wowhead Forever: https://www.wowhead.com/forever (HTTP 200, news hub with locale variants), https://www.wowhead.com/forever/search?q=Riverglades and ?q=Zephras%20Isle (HTTP 200, Forever guides plus zone links above), https://www.wowhead.com/classic/news and ?q=Forever (news only).
3. Guide sites: https://wowforeverguides.com (zones, dungeons, raids, roadmap, zone-map tool; item and quest databases, no NPC database) and https://classicwowforever.com (guides only, no NPC list). Neither site has an NPC database or NPC list. Neither links to NPC IDs.
4. Wowhead Forever zone pages (5 URLs): every request returned HTTP 403 after one 60 s wait and retry. NPC tab (`id: 'npcs'`) status unknown.

## If the Wowhead Forever zone pages become accessible

- Zone URL pattern: https://www.wowhead.com/forever/zone=<id>/<slug>
- Zone IDs from the Forever search page: Riverglades 16591, Zephras Isle 16593, Shen'dralas 16651, Darkspear Islands 16606, Mount Hyjal 616 (Mount Hyjal ID may be reused from older expansions; verify).
- Check each page for `id: 'npcs'` and NPC links of the form /forever/npc=<id>. Only the zone page and its NPC links are confirmed to exist in the HTML; the NPC URL pattern itself is unverified for Forever.
- Coordinates would need to come from the NPC page or the zone's map data; this was not checked.

## Next steps

- Retry the five Forever zone pages later, or fetch them through a browser session, since the 403 looks like bot protection.
- Krol'dok, Dalaran and the raids have no zone ID yet. Find them via the Wowhead Forever dungeon guide (https://www.wowhead.com/forever/guide/zones-maps-locations-rewards, linked from the Forever search page; not fetched).

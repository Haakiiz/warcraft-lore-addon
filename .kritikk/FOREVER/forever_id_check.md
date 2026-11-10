# Data.lua NPC IDs checked against wowhead.com/forever (2026-10-24)

Method: browser fetch of https://www.wowhead.com/forever/npc=<id> for all 142 classic-ID entries; name from <title>,
first g_mapperData point per zone compared with our coords.

Result: all 142 IDs exist in the Forever database with the same name. Instance NPCs have no map data (as on Classic).

Same zone, same place (within ~2): all others.

Different position in Forever (first point; > 2 from our coords):
- 2543 Archmage Ansirem Runeweaver, Alterac Mountains: Forever 14.2, 59.8 (3 points) vs ours 18.8, 78.5
- 4968 Lady Jaina Proudmoore, Dustwallow Marsh: Forever 45.2, 24.2 (2 points) vs ours 66.2, 49.0
- 4965 Pained, Dustwallow Marsh: Forever 45.2, 24.2 (2 points) vs ours 66.2, 49.0
- 344 Magistrate Solomon, Redridge: Forever 24.8, 44.2 (3 points) vs ours 29.8, 44.6
- 2993 Baine Bloodhoof, Mulgore: Forever 46.6, 63.4 (3 points) vs ours 47.4, 60.2
- 3066 Narm Skychaser, Mulgore: Forever 47.4, 62.6 (2 points) vs ours 48.4, 59.2
- 9598 Arei, Felwood: Forever 49.2, 26.4 (9 points, she walks an escort route) vs ours 48.2, 28.8

Extra Forever locations: 14720 Saurfang also in Silithus 29.0, 90.4 (the Ahn'Qiraj gate event); Rexxar and Misha also
list zone 405 (Desolace), which matches alsoIn.

Assessment: all seven passed the earlier Wowhead Classic check, which compared our coords with EVERY spawn point
(within 2). The Forever list here only showed the first point of each zone, and these NPCs have 2–9 points, so the
difference is most likely another spawn point listed first, not a move. Full Forever point lists could not be read
(wowhead rate-limited the browser after the batch). Re-check Jaina and Pained in game with /wcl id if in doubt.

Update (later the same evening, full point lists read slowly):
- 4968 Jaina and 4965 Pained: Forever = Classic (45.2,24.2 and 66.2,49.0). No change.
- 2543 Ansirem, 344 Solomon, 2993 Baine, 3066 Narm: Forever keeps the Classic points and ADDS one more
  (Ansirem 14.2,59.8 next to Archmage Modera at the Kirin Tor camp in Alterac; Solomon 24.8,44.2; Baine 46.6,63.4;
  Narm 47.4,62.6). Our coords stay valid.
- Name search on wowhead.com/forever for ~85 RTS character names: only new Forever NPC is Archmage Modera
  (276235 and 246748, Alterac Mountains). Other hits are Season of Discovery IDs (Uther 232920, Krasus 232624,
  Mekkatorque 219659, Mograine 242499, Arthas 232627 in "The Burning of Andorhal"), which stay out.
- Forever zone pages with no NPC data yet: Elwynn Forest 16510, Stormwind City 16509, Burning Steppes 16508,
  City of Dalaran 16544/16560, Gilneas 17065, Ruins of Gilneas 16756, Battle for Gilneas 16653, Hyjal Crater 17852,
  Manor Mistmantle 17191, Half-Pint Tavern 16632, Whelgar's Excavation Site 16876.

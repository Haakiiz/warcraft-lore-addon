# Group A verdict (critic)

Sources checked: Wowhead classic NPC pages (fetched with User-Agent Mozilla/5.0, redirects followed; all 7 contain g_mapperData), warcraft.wiki.gg cached raw text, and book character lists in _books.json via lookup.py.

## Entries from A.lua

- 1573 Gryth Thurden: FIX. Role changed from Minor to Supporting: in The Shattering the character list puts him in the Supporting column (Minor column is a different block). Coords filled from Wowhead: 55.5, 47.7 (mean of 4 spawn points). Story checked sentence by sentence against wiki background (quarantine, injured gryphon, Anduin realizing the Deeprun Tram ruse) and passes.
- 2918 Advisor Belgrum: FIX. (a) Story sentence "After the Argus Campaign, Moira asks him..." had no book attribution; now "In Before the Storm, after the Argus Campaign, ...". (b) Before the Storm character list places him in the Mentioned column, not a role column; role now reads "Mentioned in the character list; chapter 7: ...", the chapter 7 action is kept as the wiki cites it. Coords from Wowhead: 76.8, 10.4. Note for orchestrator: the wiki infobox gives Old Ironforge 34.0, 49.2, which conflicts with Wowhead's 76.8, 10.4. Per brief, Wowhead was used.
- 5387 High Explorer Magellas: FIX. Before the Storm character list places Muninn Magellas in the Minor column, not Supporting; role changed to "Minor". The Shattering Supporting role (chapter 12, Anduin recognizes him as High Explorer Muninn Magellas) is confirmed. Identity: wiki disambiguation page states "High Explorer Muninn Magellas ... in Ironforge (NPC)", so the NPC-to-character link is source-stated. Coords from Wowhead: 69.9, 18.2.
- 5159 Daryl Riknussun: PASS. Wiki: cooking trainer in Ironforge; The War Effort: he helps Saegan clean and cook the fish, which go to Huntress Swiftriver (book text and wiki both confirm). Coords from Wowhead: 60.2, 37.1.
- 15457 Huntress Swiftriver: FIX. Confidence changed from uncertain to confirmed. The identity is now source-stated. The book text says Saegan carries the fish "to the Military Ward; Huntress Swiftriver would have plenty of food", and the Military Ward is in Ironforge (wiki Locations: Military Ward, Ironforge, Gates of Ahn'Qiraj, Classic only). The wiki page Notes also say "She is mentioned in the short story The War Effort, in which she is the addressee of a fish supply". Role now "Mentioned". Coords from Wowhead: 71.2, 69.7.

## ADDED (from the worker's REJECT table, spot-check)

- 233382 Korialstrasz (Wetlands): ADDED, BOOK Day of the Dragon, role Major. Wowhead page: "Korialstrasz", "This NPC can be found in Wetlands" (coords 74.2, 70.0), with a comment placing him around Grim Batol in SoD. Wiki Korialstrasz page: "In the guise of the high elf mage Krasus" and the Day of the Dragon section (freeing Alexstrasza from the Dragonmaw clan, summoning Rhonin at the final battle of Grim Batol). Day of the Dragon Characters: "Korialstrasz/Krasus" in the Major column. The worker's reason (wiki Npclocations has no Wetlands) is a gap in the wiki list, not a contradiction.
- 232624 Krasus (Wetlands): ADDED, BOOK Day of the Dragon, role Major. Wowhead title line: "Krasus <Consort to the Dragon Queen>", "This NPC can be found in Wetlands" (coords 74.4, 70.0). The wiki Korialstrasz infobox gives the title "Consort of the Queen", and the wiki states Korialstrasz assumed the identity of "Krasus". Quotes on Wowhead refer to Alexstrasza's dragon consort context; story kept to what the wiki and Wowhead state.

## Additions to existing Data.lua entries (CONFIRMED against book Characters lists)

- 2784 Magni Bronzebeard: CONFIRMED add: The Shattering: Prelude to Cataclysm, role "Major" (Major column, first block). Existing Data entry does not have this appearance.
- 7937 High Tinker Mekkatorque: CONFIRMED add: Beyond the Dark Portal, role "Supporting" (column 4 of the Supporting block). CONFIRMED add: War Crimes, role "Minor" (Minor column). Wolfheart (Minor) already in the entry.
- 11406 High Priest Rohan: CONFIRMED add: Wolfheart, role "Mentioned" (Mentioned column). The Shattering Supporting already in the entry.

## Spot-check of REJECTs (worker's table)

- 6030 Thorvald Deepforge (Loch Modan): REJECT stands. The wiki page for Thorvald Deepforge has no book link. Night of the Dragon's "Thorvald (dwarf)" is a separate page.
- 13444 Greatfather Winter (NPC): REJECT stands. Wiki disambiguation: the page covers "the legendary figure" and "the actors who portray him: Greatfather Winter (Ironforge)"; the NPC is the Smokywood actor, not the book figure.
- 1356 Prospector Stormpike: REJECT stands. Wiki page has no book source; the only book text found is the Explorers' League/Uldaman listing, not a Characters entry.
- Other rejects checked by cache only: Kelv Sternhammer, Wulmort Jinglepocket, Myolor Sunderfury, Balgaras the Foul and Electrocutioner 6000 have no book-text hits in _books.json. REJECT stands.

## Summary

- Entries from A.lua: 5 (PASS 1: Daryl Riknussun; FIX 4: Gryth Thurden, Advisor Belgrum, High Explorer Magellas, Huntress Swiftriver; REJECT 0)
- ADDED new entries: 2 (Korialstrasz 233382, Krasus 232624)
- Confirmed additions to existing entries: 4 (Magni Shattering Major; Mekkatorque BtDP Supporting and War Crimes Minor; Rohan Wolfheart Mentioned)
- Coords: 7 of 7 filled from Wowhead g_mapperData (mean of spawn points, 1 decimal)
- Output files: A_verdict.md and A_checked.lua in the work dir (checked.lua has 7 entries: 5 from A.lua with final text + 2 ADDED)

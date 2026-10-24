# QA report, group E (19 entries)

Wowhead Classic: all 19 IDs exist, names match, zones match, all coords within 0.2 of g_mapperData (Ukorz is a dungeon boss, no map data, "" is correct). No ID > 200000. None is removed/event-only in Classic.

## 4968 Lady Jaina Proudmoore: FIX
- Missing RTS appearances (she speaks/acts in all three): The Prince and the Prophet (WC3 Human) "I'm sorry for concealing myself, Arthas" (https://warcraft.wiki.gg/wiki/The_Prince_and_the_Prophet_(WC3_Human)); Divergent Courses (WC3 Human) "He's gone to Northrend to hunt Mal'Ganis" (.../Divergent_Courses_(WC3_Human)); The Last Guardian, Eternity's End interlude: "Thrall and Jaina arrive in the glade" (.../The_Last_Guardian_(WC3_Night_Elf)). Added to missions, roles, sources.
- Existing missions, roles, story verified (Jaina page: "helped the Horde gain ships from the goblins and ordered her own troops to stand down"; Theramore page: "respect the other's territory", "ragtag remnants").

## 4501 Draz'Zilb: FIX
- `related = { 4500 }` points to Mok'Morokk, which is REMOVE (below). Related dropped. Rest PASS (Old Hatreds page: "Ogg'marr, Tharg, Do'gol, and Draz'Zilb are present in the ogre village").

## 4502 Tharg: PASS
Story matches the Tharg page (wife slain, refuses Brackenwall as home, wants to reclaim Stonemaul Village).

## 5087 Do'gol: FIX
Story said he "offers parts two to four" of The Black Shield. Wiki: part 2 questfinish, part 3 start+finish, part 4 start. Reworded to "takes part in parts two to four".

## 4879 Ogg'marr: PASS
Butcher, sells meat, drink and four cooking recipes (Ogg'marr page).

## 3936 Shandris Feathermoon: FIX (missing appearances)
- RTS part verified (Shandris unit page: Enemies at the Gate, Daughters of the Moon, Twilight of the Gods).
- Missing Blizzard novels, all with Shandris in the book's Characters section and described on the Shandris page: The Demon Soul (ch. 9, 17, 18, 23), The Sundering (ch. 3, 20), Stormrage (left in charge of Darnassus, gave Tyrande Jai'alator), Wolfheart (Jarod reunion, Ashenvale war), Jaina Proudmoore: Tides of War (Sentinels at Theramore, searches Dustwallow for Thalen Songweaver). Added as BOOK appearances plus one story sentence on Tides of War (6 sentences, labelled as the novel). Seeds of Faith (post-Cataclysm short story) deliberately not added.

## 4500 Overlord Mok'Morokk: REMOVE (BLOCKER)
- The only appearance is "Exploring Azeroth: Kalimdor", a reference guide, not a novel (brief: guides are not BOOK). Wiki cites it as "World of Warcraft: Exploring Azeroth: Kalimdor, pg. 146". No novel or RTS mission features him (wiki search for "Mok'Morokk" returns only quest/NPC/location pages; Old Hatreds does not mention him). The first four story sentences rest on the guide. Entry has no valid appearance, so remove it (its 3 items are quest items only).
- Knock-on outside my files: the Rexxar entry in Data.lua (story sentence "Rexxar named the ogre Mok'Morokk the new leader of the Stonemaul clan, a decision he would later regret", Data.lua ~line 651) rests on the same guide. Orchestrator should re-check that sentence.

## 4965 Pained: PASS
Tides of War Characters lists Pained; wiki: assigned by Tyrande at Hyjal, dies in the mana bomb. Coords match (66.2, 49).

## 9598 Arei: PASS
Stormrage Characters lists Arei; page: "Arei finds and helps Broll Bearmantle inside the Dream and then leads him to Zaetar". Removed in Cataclysm but valid in Classic (Wowhead Classic page exists).

## 11832 Keeper Remulos: PASS
Remulos page, Stormrage and Shattering ch. 19 match; Moonglade page: "A few years after the Third War, Moonglade was opened to all druid races and Keeper Remulos became Moonglade's new guardian."

## 7564 Marin Noggenfogger: FIX
- The Goblin Way role/story said he "joins Gazlowe's cartel". Marin page: "Gazlowe offered to keep pressure off of Noggenfogger by aligning their cartels together ... Noggenfogger agreed." Marin stays Trade Prince of Steamwheedle. Reworded to align cartels.
- Traveler role: he was forced (Marin page "Noggenfogger was not happy about giving in to Malus's blackmail, but ... tipped him off"). Added "Under Malus's blackmail"; story sentence adjusted.
- Classic story verified (quests The Thirsty Goblin, In Good Taste are Classic-only, removed 4.0.3a).

## 7583 Sprinkle: PASS
Sprinkle Noggenfogger page matches picnic, caravan, Winifred's safe house and the Crustacean tip.

## 7804 Trenton Lighthammer: PASS
Page: Classic night elf, changed to high elf in 4.0.3a (same NPC); Traveler ch. 35: sleeps them in his tower, forges harpoon, gives new iron chain.

## 8197 Chronalis: PASS
Page: "initially denied them entry, he eventually consented to escort them" after learning of Ysera's direction.

## 8198 Tick: FIX (missing appearance)
Short story Charge of the Aspects (https://warcraft.wiki.gg/wiki/Charge_of_the_Aspects, Matt Burns, official site) lists Tick as Supporting; Tick page: "Tick bore and transported the fatally wounded Zirion ... it was the Infinite Dragonflight and its leader". Added appearance, 4th story sentence, source.

## 15192 Anachronos: PASS
War of the Shifting Sands: "Anachronos called upon the progeny of the remaining flights ... Anachronos summoned the enchanted barricade". Twilight of the Aspects ch. 12: present at Nozdormu's return.

## 11186 Lunnix Sprocketslip: PASS
Lunnix page cites Before the Storm prologue; story matches.

## 11753 Gogo: PASS (NIT)
Verified. NIT: role is passive (Kezzig hangs around her), kept since the page ties her to the plot.

## 7267 Chief Ukorz Sandscalp: PASS (NIT)
Page, Traveler ch. 33-34: "Ukorz and the other sand trolls summoned the loa Kimbul, Shadra, and Mueh'zala with the blood of the prisoners". NIT: story sentences 2-3 (obsessed with restoring tribe, Ruuzlu) come from the Adventure Guide (RPG) and quest pages, not a book; it is lore, left as is.

## Counts
PASS 12 (4502, 4879, 4965, 9598, 11832, 7583, 7804, 8197, 15192, 11186, 11753, 7267; 2 with NITs), FIX 6 (4968, 4501, 5087, 3936, 7564, 8198), REMOVE 1 (4500, also BLOCKER). Total 19. E_fixed.lua holds the 6 FIX entries.

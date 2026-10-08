# Group A report (Ironforge 1537, Loch Modan 38, Wetlands 11, Gnomeregan 721)

Coords: Wowhead (`classic/npc=<id>`) returned no g_mapperData for any accepted NPC, so all coords are "". The orchestrator must fill them. Wiki hint only, not used: Advisor Belgrum's wiki infobox gives `{{Co|34.0|49.2|Ironforge}}` (Old Ironforge).

## Ironforge (1537): 19 candidates, 11 not in Data.lua

### ACCEPT
| id | name | role | source |
|---|---|---|---|
| 1573 | Gryth Thurden | Minor, The Shattering (novel) | wiki Gryth Thurden + The Shattering Characters (Minor column); book line "According to the Ironforge gryphon master [[Gryth Thurden]]..." |
| 2918 | Advisor Belgrum | Supporting, The Shattering; ch. 7 in Before the Storm | wiki: "Advisor Belgrum is a dwarf located in Old Ironforge"; Shattering: "...and Advisor Belgrum from the Explorers' League." |
| 5387 | High Explorer Magellas | Supporting, The Shattering ch. 12; Supporting, Before the Storm | wiki disambig: "High Explorer [[Muninn Magellas]] ... in [[Ironforge]] (NPC)"; Explorers' League quote "Anduin recognized him as High Explorer Muninn Magellas, the head of the Explorers' League" (Shattering ch. 12, pg. 116) |
| 5159 | Daryl Riknussun | short story The War Effort | wiki: "During the Ahn'Qiraj War, he helped Saegan cleaning and cooking some fish supplies... ''The War Effort''" |
| 15457 | Huntress Swiftriver | Mentioned, The War Effort; confidence uncertain | wiki: "located in the Military Ward in Ironforge" (Classic Gates of Ahn'Qiraj event); book names her as fish recipient only |

Open point on 15457: The War Effort does not say Ironforge, so the identity is by name and shared context. Kept as "uncertain".

### REJECT
| id | name | reason (quoted line) |
|---|---|---|
| 1356 | Prospector Stormpike | "''[[Lands of Conflict]]'', pg. 78" is the only source; guide, not a book. |
| 3979 | Librarian Mae Paledust | Only source: "''[[World of Warcraft: Exploring Azeroth: The Eastern Kingdoms]]'', pg. 58" (guide). |
| 5113 | Kelv Sternhammer | rts-words only: "His name is taken from one of the random mountain kings seen in Warcraft III" (name is a random-hero label; no character link). |
| 5595 | Ironforge Guard | Generic NPC group, not a character. |
| 11145 | Myolor Sunderfury | Only source: "''[[World of Warcraft: Exploring Azeroth: The Eastern Kingdoms]]'', pg. 56" (guide). |
| 11859 | Doomguard | Generic demon unit type: "Doomguard ... are a type of demonic species". |
| 13433 | Wulmort Jinglepocket | Only source "I Got What Yule Need" (holiday text); no book hit in the books cache. |
| 13444 | Greatfather Winter (NPC) | The NPC is an actor: "a dwarf playing 'Greatfather Winter' for the Alliance" (Greatfather Winter page). The book figure is the legend, not this NPC. |

Already in Data.lua (skipped): 2784, 5137, 5144, 7312, 7937, 11406, 7800 (ids checked against Data.lua).

### Reverse check (Ironforge)
Names checked (full name, plus surname/first name for multi-word names): all 225 non-generic NPC names in npcs_1537.json, plus surnames. Characters-list hits found: Belgrum, Gryth Thurden, Muninn Magellas, Daryl Riknussun, Huntress Swiftriver (The War Effort), Greatfather Winter (BTDP "Other" list; rejected above), High Priest Rohan, Reyna Stonebranch, Bink, Dink, Gelbin Mekkatorque, Magni Bronzebeard (all but the first four already in Data.lua). Surname-only false hits (not the same person): "Thomas (child)" from Shattering vs. Thomas... not in candidates, no link.

### Additions to existing entries (Data.lua, read-only, not written)
- 2784 Magni Bronzebeard: Characters-list hit in The Shattering (Major column); entry has only Before the Storm, Blood Ties, Tides of Darkness. Other hits seen but not verified: Jaina Proudmoore: Tides of War, Quest for Pandaria, Wolfheart, Beyond the Dark Portal, War Crimes, Elegy, Stormrage.
- 7937 High Tinker Mekkatorque: Characters-list hits in Beyond the Dark Portal and War Crimes; entry has Before the Storm, Jaina Tides of War, Wolfheart.
- 11406 High Priest Rohan: Characters-list hit in Wolfheart ("[[High Priest Rohan|Rohan]]"); entry has only The Shattering.

## Loch Modan (38): 6 candidates, 5 not in Data.lua

### REJECT
| id | name | reason |
|---|---|---|
| 1139 | Magistrate Bluntnose | "Magistrate Bluntnose, Thelsamar's mayor, keeps the village safe and orderly." (''Lands of Conflict'', RPG/guide only) |
| 1154 | Marek Ironheart | "''[[Lands of Conflict]]'', pg. 78" (RPG/guide only). |
| 1933 | Sheep | Generic creature (RTS unit type). |
| 2098 | Ram | Generic creature. |
| 6491 | Spirit Healer | Generic NPC type, no book link. |

Already in Data.lua: 1156 Vyrin Swiftwind (Quest for Pandaria).

### Reverse check (Loch Modan)
149 names checked. Only Characters-list hits matching zone NPCs: Vyrin Swiftwind (in DL). "Thorvald" (Night of the Dragon, "[[Thorvald (dwarf)|Thorvald]]") was checked against Thorvald Deepforge (6030): REJECT, the Loch Modan page has no book link ("Thorvald Deepforge is a dwarf found in Valley of Kings in Loch Modan") and the book page is a different target.

## Wetlands (11): 12 candidates, 10 not in Data.lua (Krasus and Korialstrasz counted separately)

### REJECT
| id | name | reason |
|---|---|---|
| 1038 | Dragonmaw Shadowwarder | Generic creature. |
| 1051 | Dark Iron Dwarf | Generic creature. |
| 1364 | Balgaras the Foul | "World of Warcraft: The Comic" section; source is the comic/Cataclysm, not a book. |
| 1420 | Toad | rts-words only; generic creature. |
| 2091 | Chieftain Nek'rosh | RPG-only: "Chieftain Nek'rosh was the leader of a subgroup of the Dragonmaw clan... ''[[Dark Factions]]'', pg. 134" (RPG book). |
| 2098 | Ram | Generic creature. |
| 2104 | Captain Stoutfist | RPG-only ("Captain Stoutfist, Menethil's military leader..." sourced to the RPG). |
| 4962 | Tapoke "Slim" Jahn | Source is "The Missing Diplomat (12)", a comic. |
| 6491 | Spirit Healer | Generic. |
| 11859 | Doomguard | Generic demon unit type. |
| 232624 | Krasus (wiki: Korialstrasz) | Identity rule not met. The Korialstrasz page's Npclocations list only Wyrmrest Temple, Wrath Gate, Azshara, Black Rook Hold (no Wetlands). The page never mentions a Wetlands NPC. Name-only link. Only the name matches, not the NPC. |
| 233382 | Korialstrasz (same wiki page) | Same reason as 232624. |

Reverse check: "Karl (paladin)" (Knights of the Silver Hand) vs. Karl Boran (1242): REJECT. Karl Boran's page is a Menethil Harbor merchant-marine human with no book link. "Thomas" (Shattering, child) vs. Thomas Booker (1437): REJECT, first name only, no link.

Open question for the orchestrator: whether the Wetlands Krasus/Korialstrasz NPCs (232624, 233382) are meant to be the Dalaran lore figure. Only a source tying those IDs to the lore figure would change this. Not found in the wiki pages I read.

## Gnomeregan (721): 4 candidates, 3 not in Data.lua

### REJECT
| id | name | reason |
|---|---|---|
| 6228 | Dark Iron Ambassador | Only source: "''[[Monster Guide]]'', pg. 168" (guide). |
| 6235 | Electrocutioner 6000 | Only source: "''[[World of Warcraft: Exploring Azeroth: The Eastern Kingdoms]]'', pg. 64" (guide). |
| 7079 | Viscous Fallout | Same guide source, generic elemental. |

Already in Data.lua: 7800 Mekgineer Thermaplugg (Cut Short).

Reverse check (Gnomeregan): 54 names checked, no Characters-list hits.

## Summary counts
- Ironforge: 5 ACCEPT (1 uncertain), 9+ REJECT, 3 existing-entry additions.
- Loch Modan: 0 ACCEPT, 5 REJECT.
- Wetlands: 0 ACCEPT, 12 REJECT (incl. the Krasus/Korialstrasz pair).
- Gnomeregan: 0 ACCEPT, 3 REJECT.

Note on the brief's note about Krasus/Korialstrasz: the earlier rejection stands. The line quoted is Npclocations: "[[Wyrmrest Temple]] & [[Angrathar the Wrathgate]], [[Dragonflight]]", and the page has no Wetlands entry.

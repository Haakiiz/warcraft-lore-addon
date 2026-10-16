# RAV_B report: Alterac Mountains (zone 36)

## Scope and counts
- NPCs in npcs_36.json: 110.
- Removed: 10 Ravenholdt Manor NPCs (6707, 6766, 6768, 6771, 6777, 6779, 7323, 7324, 7325, 8309), 10 IDs above 200000.
- In scope: 90 NPCs. Of these, 45 are generic creatures and 45 are named or potentially named.
- Already in Data.lua: Mug'thol (2257), Lord Aliden Perenolde (2423). Not rewritten.
- Candidates (candidates_36.json) not in Data.lua: 5 (Deer, Sheep, Warden Belamoore, Archmage Ansirem Runeweaver, Lord Jorach Ravenholdt). Lord Jorach is Ravenholdt, assigned to another worker, not decided here.
- Wowhead returned 403 for every NPC ID tested (2543, 2415, 2306, 2317, 2316, 2414, 2320, 2447, 883, 1933). Coords left as "" for the orchestrator.

## Candidate decisions (candidates not in Data.lua)

| Name (id) | Decision | Reason with quoted line |
|---|---|---|
| Deer (883) | REJECT | Generic creature. "Deer appear as critters in Warcraft III: Reign of Chaos." |
| Sheep (1933) | REJECT | Generic creature. "Sheep flee rather than attack." |
| Warden Belamoore (2415) | REJECT | Only RPG and in-game item. "Warden Belamoore is a stern wizardess who oversees the Lordamere Internment Camp" is cited to Lands of Conflict pg. 87 (RPG). No BOOK or RTS line, no Characters-list hit. |
| Archmage Ansirem Runeweaver (2543) | ACCEPT | Identity explicit: "Archmage Ansirem Runeweaver was a human quest giver located at Dalaran Crater in the Alterac Mountains." Book Characters lists: Jaina Proudmoore: Tides of War (Minor), Quest for Pandaria (Minor), In the Shadow of the Sun (Mentioned). See entry. |

## Named NPCs with decision (non-candidates and borderline)

| Name (id) | Decision | Reason |
|---|---|---|
| Baron Vardus (2306) | REJECT | No book or RTS line. Page: "Since the Cataclysm, the Uplands are deserted and Baron Vardus has likely been killed by adventurers in lore." |
| Elysa (2317) | REJECT | No book or RTS line. Page: "Following the Cataclysm, she is nowhere to be found." Reverse check: only Blackmoore and Thrall article text, not Characters lists. |
| Gol'dir (2316) | REJECT | No book or RTS line. Reverse check: only Thrall article text. |
| Kegan Darkmar (2414) | REJECT | No book or RTS line. Page: "Kegan Darkmar is a Forsaken found in the Lordamere Internment Camp." Forsaken article hit is generic lore text. |
| Nagaz (2320) | REJECT | No book or RTS line. Page: "Nagaz is an orc warrior." Appearances are Legion and quest-only. |
| Narillasanz (2447) | REJECT | Rare elite mob, not a character. "Narillasanz is an elite rare mob red drake". No book or RTS line. |
| Lord Aliden Perenolde (2423) | EXISTING | Not rewritten. See additions below. |
| Mug'thol (2257) | EXISTING | Not rewritten. See additions below. |

## Reverse book check (step 4)
Names checked against Characters lists in _books.json (non-generic, 45 names): Mug'thol; Baron Vardus; Gol'dir; Elysa; Nagaz; Henchman Valik; Ricter; Alina; Dermot; Kegan Darkmar; Warden Belamoore; Grel'borg the Miser; Targ; Muckrake; Glommus; Lord Aliden Perenolde; Jailor Borhuin; Narillasanz; Skhowl; Lo'Grosh; Bro'kin; Archmage Ansirem Runeweaver; Rizz Loosebolt; Nancy Vishas; Grandpa Vishas; Bath'rah the Windwatcher; Salome; Myrokos Silentform; Thanthaldis Snowgleam; Jekyll Flandring; The Abominable Greench; Corporal Teeka Bloodsnarl; Sergeant Durgen Stormpike; Prospector Stonehewer; Voggah Deathgrip; Warmaster Laggrond; Lieutenant Haggerdin; Gravis Slipknot; Araga; Cranky Benj; Jimmy the Bleeder; Mirvyna Jinglepocket; Dillord Copperpinch; Apothecary Staffron Lerent; Captain Armando Ossex.
Generic creatures (45) were not searched, except a spot check of 17 names (Frostmaw, Cyclonian, Lake Frenzy, Spirit of Old, Horde Warbringer, Alliance Brigadier General, Dalaran Worker, Strange Snowman, Stone Fury, Argus Shadow Mage, Southshore Guard, Snapjaw, Elemental Slave, Lake Skulker, Gray Bear, Mountain Lion, Crushridge Ogre): no hits in book Characters lists and no RTS mention on their pages.
Hits outside Characters lists (only in article text, not books) were treated as noise. Examples: "Sylvanas Windrunner", "Forsaken", "Thrall", "Blackmoore", "Scarlet Crusade".

Reverse-check hits that are NOT added:
- Aiden Perenolde (in Tides of Darkness, Day of the Dragon, Knights of the Silver Hand, Beyond the Dark Portal): this is King Aiden, Aliden's father, not Aliden.
- Only Beyond the Dark Portal has an Aliden Perenolde Characters entry.

## ACCEPT list
- Archmage Ansirem Runeweaver (2543), Alterac Mountains. Sources:
  - https://warcraft.wiki.gg/wiki/Archmage_Ansirem_Runeweaver (identity: "Archmage Ansirem Runeweaver was a human quest giver located at Dalaran Crater in the Alterac Mountains.")
  - https://warcraft.wiki.gg/wiki/Jaina_Proudmoore:_Tides_of_War (Characters, Minor; action: "Ansirem was present during the meetings of the Council of Six and Jaina Proudmoore who was asking for help in defending Theramore and attacking Orgrimmar.")
  - https://warcraft.wiki.gg/wiki/Quest_for_Pandaria (Characters, Minor; action: "Ansirem, Modera, and a few other magi arrived near Booty Bay to save his daughter Catelyn when she and her crew were under attack from the Bloodsail Buccaneers.")
  - https://warcraft.wiki.gg/wiki/In_the_Shadow_of_the_Sun (Characters, Mentioned; action: "Grand Magister Rommath still holds Ansirem (and Modera) in contempt for doing nothing when Grand Marshal Garithos locked Prince Kael'thas and his followers away in the Dungeons of Dalaran.")
  - Not used: the WC3 citation on the page ("Warcraft III: Reforged: Under the Burning Sky (WC3 Undead)"). Game code and mission placement could not be verified from the cache, so it is left out.

## Additions to existing entries
- Lord Aliden Perenolde (2423): none. Only Beyond the Dark Portal has an Aliden Characters entry; other book hits are King Aiden.
- Mug'thol (2257): none. Book/article hits are generic lore, not Characters entries.

## Open questions
- Coords for 2543 are empty because Wowhead returns 403. Orchestrator should fill them. Coordinates for Dalaran Crater are not given on the wiki page, so they were not guessed.
- The wiki's WC3 citation for Ansirem (Under the Burning Sky, WC3 Undead) is not added. Game code (WC3 vs FK) needs checking in the RTS sources.
- _books.json holds only Characters sections. The roles of the three Ansirem book appearances come from the NPC page's citations, not from direct reading of the book text.

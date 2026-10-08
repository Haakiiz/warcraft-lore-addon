# Group F report (Duskwood 10, The Deadmines 1581, The Stockade 717)

Result: 0 ACCEPT, 17 REJECT, 0 coordinates needed, 0 additions to existing entries needed.

Method note: candidates were decided from the full cached page (`lookup.py page`). The reverse check ran over all named NPCs in `npcs_10.json`, `npcs_1581.json` and `npcs_717.json` (about 218 unique names) with exact-name matching (word boundaries) against `_books.json`, plus the surname for two-part names. Hits were then read in context with `lookup.py book` and `lookup.py books`. Several `_books.json` keys are not novels (faction, race and category pages such as "Defias", "Stormwind Assassins", "Explorers' League", "ambassador", "farmer", "tauren"). Hits in those keys are treated as non-book sources.

## Duskwood (10): NPCs 182, candidates 17 (12 not in Data.lua)

### ACCEPT
None.

### REJECT (candidates with already_in_Data_lua = false)

| name (id) | reason with quoted line |
|---|---|
| Skeletal Warrior (48) | Generic unit type: "Skeletal warriors (or skeleton warriors) are undead melee combatants summoned by necromancers." Named Duskwood NPCs on the page (e.g. Commander Felstrom) are separate entries. |
| Skeletal Mage (203) | Generic unit type: "Skeletal mages are spell-casting skeletons..." Only the RTS unit line ("In Warcraft III they can be summoned by Necromancers") and RPG text. |
| Lord Ello Ebonlocke (263) | Only RPG source: "Lord Ello Ebonlocke is the ruler of Duskwood." (Lands of Conflict, pg. 46, RPG). No novel, short story or RTS appearance. |
| Commander Althea Ebonlocke (264) | Comic only: "In the Dark Riders (comic), Althea was first portrayed with brown eyes..." Other sources are Legends comic Warrior: Divided and RPG Lands of Conflict. No novel. |
| Role Dreuger (269) | Only guide and in-game sources: "Around the time of the Cataclysm... Dreuger notified Lord Ello Ebonlocke" (The Art of Cataclysm, guide). The Twilight's Hammer letter is an in-game book. No novel. |
| Abercrombie (289) | In-game and guide sources only: "The story of the Embalmer is retold as a children's story in Darkshire" (in-game quest book). Legion line is an in-game tournament announcer. No novel. |
| Stalvan Mistmantle (315) | Inspiration only, not identity: "This character and the storyline is inspired by the novel Lolita." Sources are the Ultimate Visual Guide (guide) and quests. No Blizzard novel or RTS appearance. |
| Watcher Dodds (888) | Comic, unnamed: "Note that the character is not named but strongly resembles the man." (Warrior: Divided, Legends comic). |
| Nightbane Tainted One (920) | Generic worgen type: "Nightbane Tainted Ones are worgen found in Duskwood." |
| Spirit Healer (6491) | Generic NPC type: "Spirit Healers are angelic beings usually encountered at a graveyard." |
| Dark Rider (218931) | Generic faction mob. The Dark Riders page says: "They are the focus of the graphic novel Dark Riders." Comic, not a novel. |
| Fire Elemental (223287) | Generic creature type: "Fire elementals are elemental creatures made of fire and magma." |

### Existing entries (already_in_Data_lua = true), checked, no action
- Watcher Ladimore (576), Morbent Fel (1200), Watcher Cutford (1436): the "Terror by Torchlight" short story is already in Data.lua for each.
- Lethon (14888), Emeriss (14889): the "Stormrage" novel is already in Data.lua for each.

### Reverse check (Duskwood), hits that were not accepted
- Apothecary Faustin (5414) and Deathstalker Zraedus (5418): found only in the Varimathras wiki page, not a book. Sentence: "He also sent Apothecary Faustin and Deathstalker Zraedus to Duskwood..." (cited to the quest "Nothing But The Truth"). Not a novel, so REJECT.
- Kanrethad Ebonlocke (Blood Ties, Outland, warlock entries): a different Ebonlocke, not linked to Lord Ello in any source read. REJECT as different character.
- Eliza (314): only "Eliza Darkgrin" in Forsaken pages. Different character. REJECT.
- Ysondre (14887) and Taerar (14890): not in the "Stormrage" Characters list (Emeriss, Eranikus, Lethon, Ysera, Korialstrasz). No novel hit. REJECT.
- Watcher Backus (840) and Althea Ebonlocke: "Stormwind Assassins" key is the SI:7 faction page, not a book. REJECT.
- Sven Yorgen (311): only the worgen "farmer" category page. REJECT.
- Ambassador Berrybuck (271): only the "ambassador" category page. REJECT.
- Clerk Daltry (267): only "Surveyor Daltry" on the Explorers' League faction page. Different person. REJECT.
- Petras (Watcher Petras 828): hits are for the artist Bill Petras. Different person. REJECT.
- Unseen (3094): "Unseen Path" is a High elf faction, not a character. REJECT.
- Rat (4075): generic rodent (see Deadmines).
- All other Duskwood named NPCs: no book hits.

### Open questions (Duskwood)
- Watcher Dodds and Abercrombie: the wiki names them only in comics, RPG or in-game text. If the orchestrator wants a Legends-comic note, that is out of scope for this brief.

## The Deadmines (1581): NPCs 26, candidates 6 (5 not in Data.lua)

### ACCEPT
None.

### REJECT

| name (id) | reason with quoted line |
|---|---|
| Sneed (643) | Comic only: "When Jerias Bloodvein invaded the Deadmines, Sneed was killed by Bloodvein's crew." (source: Bloodsail Buccaneer, Legends comic). |
| Rhahk'Zor (644) | Comic plus speculation: "When Jerias Bloodvein invaded the Deadmines, his pirates killed Rhahk'Zor." (Bloodsail Buccaneer). The WC1 ogre link is "pure speculation." |
| Mr. Smite (646) | Guide, card and speculation only: "Mr. Smite was an elite tauren who could be found in the Deadmines." (Exploring Azeroth guide, Hearthstone card). No novel or RTS appearance. |
| Gilnid (1763) | RPG and comic only: "Gilnid may have had no equal" (Dark Factions, pg. 142, RPG); killed in Bloodsail Buccaneer (comic). No novel. |
| Rat (4075) | Generic creature: "Rats are medium-sized rodents..." RTS hits are unit types. |

### Existing entry
- Edwin VanCleef (639): "Beyond the Dark Portal" already in Data.lua. No action.

### Reverse check (Deadmines)
- Captain Greenskin, Cookie, Miner Johnson, Goblin Engineer, Goblin Shipbuilder and other goblin/Defias generics: only faction or race pages (Defias, goblin, tauren). "Cookie" hit is "Cookie" McWeaksauce in the tauren page, a different character. REJECT.
- Defias generics (Pirate, Miner, Taskmaster, Overseer, Blackguard, Companion, Captive etc.): unit types. No named hits.
- Remote-Controlled Golem, Defias Companion: generic.
- Named Deadmines bosses (e.g. Rhahk'Zor, Sneed, Smite) were covered above.

## The Stockade (717): NPCs 11, candidates 0

### ACCEPT
None.

### REJECT
None (no candidates).

### Reverse check (Stockade)
- Dextren Ward (1663), Kam Deepfury (1666), Targorr the Dread (1696), Bazil Thredd (1716), Hamhock (1717), Bruegal Ironknuckle (1720): exact-name search gave no book Characters hits. Bazil Thredd appears only on the Defias faction page. Kam Deepfury appears only on the Dark Iron dwarf race page. Neither is a book source.
- Defias Prisoner, Captive, Inmate, Convict, Insurgent (generic Defias types): unit types. REJECT.

## Summary of counts
- Duskwood: 182 NPCs, 17 candidates (12 not in Data.lua), 0 ACCEPT, 12 REJECT (candidates not in Data.lua).
- The Deadmines: 26 NPCs, 6 candidates (5 not in Data.lua), 0 ACCEPT, 5 REJECT.
- The Stockade: 11 NPCs, 0 candidates, 0 ACCEPT.
- Coordinates: none needed (no ACCEPT).

## Files
- F.lua: no new entries (zone comments only), valid Lua.
- F_report.md: this file.

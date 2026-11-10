# RE report: Razorfen Downs (zone 722) + classic world events

Method: lookup.py page/books/book on the cached wiki; warcraft.wiki.gg raw pages (Chrome UA, >=1.1 s apart) for every event NPC;
Wowhead retail event pages (event=327/423/181/201/341/321/324/141/479; the /classic/event= URLs 404/301) for NPC lists, filtered to ID < 40000, then Wowhead Classic NPC pages for coords.
Event wiki pages fetched are in `w/wiki/`.

## Part A: Razorfen Downs (zone 722)
NPC count 36. Candidates 2 (both not yet in Data.lua). Result: 1 ACCEPT, 1 REJECT (the second candidate, Roach, plus Spirit of Agamaggan from the reverse check).

### ACCEPT
- **7358 Amnennar the Coldbringer**: *Traveler: The Spiral Path* (Greg Weisman novel), Mentioned, chapter 19. Same character: the novel's page links to the Razorfen Downs lich page, and Data.lua already accepts "Mentioned in the novel" for Charlga Razorflank (4421) from the same book.
  - Plot line: "Instead, both are captured by Blackthorn and Chugara Razorflank, whose plan is to sacrifice Drella to Amnennar the Coldbringer" (Traveler: The Spiral Path, plot, chapter 19).
  - Characters/Mentioned: "Amnennar the Coldbringer - the undead Blackthorn plans to summon through Drella's sacrifice."
  - Story lines from the Amnennar (Classic) page: "The lich Amnennar and his forces participated in the Scourge's assault on Mount Hyjal during the Third War. Afterward, the Lich King instructed his servant to remain in Kalimdor and expand the Scourge's influence..."; Scourge page: "In the Barrens, Amnennar the Coldbringer was instructed to expand the Scourge's influence across Kalimdor".
  - coords = "" (dungeon boss; Wowhead `g_mapperData = []`).
  - Not used: the "Reigol Valdread / Traveler: The Shining Blade" lines of the retail page (Shining Blade text does not name him) and the Compendium of Fallen Heroes claim (not a novel).

### REJECT
| ID | Name | Reason |
|---|---|---|
| 4076 | Roach | Generic critter. "Roaches, or cockroaches are small insects"; the italic-ref is only the First Guardian locust note. |
| 222522 | Spirit of Agamaggan | ID > 200000 (Season of Discovery). Agamaggan himself ("the mighty demigod Agamaggan came forth to battle the Burning Legion", War of the Ancients) is a different NPC. |

### Names checked in the reverse step (lookup.py books)
Amnennar (hits = Scourge/Lich King/quilboar faction pages; the Traveler link found on the wiki, see ACCEPT), Ragglesnout ("|{{NPC|Combat|Ragglesnout|icon=Quilboar Male}}", quilboar faction table, not a book), Tuten'kash and Mordresh Fire Eye (RaceIcon list on the Scourge faction page, not a book), Plaguemaw the Rotting (quilboar faction table), Belnistrasz (0), Henry Stern (0), Sah'rhee (0), Lady Falther'ess (0), Glutton (0), Roach (0 book lines), Agamaggan (War of the Ancients trilogy hits, NPC 222522 rejected on ID).
Generic creatures not looked up: Black Rat, Withered *, Battle Boar Horror, Death's Head Geomancer/Necromancer, Skeletal *, Splinterbone *, Boneflayer Ghoul, Thorn Eater Ghoul, Tomb Fiend/Reaver, Frozen Soul, Freezing Spirit, Frost Spectre.

## Part B: classic world events
Event NPCs looked at: about 190 (all Lunar Festival Elders plus the NPCs below). Result: 1 ACCEPT (+1 bonus). No RTS or cinematic appearance found for any event NPC.

### ACCEPT
- **15077 Riggle Bassbait** (Stranglethorn Fishing Extravaganza, Booty Bay dock, 27.4, 76.8): official Blizzard short story "Stranglethorn Fishing Extravaganza" (wiki: copy of the official site preview article, in the short stories category). Quotes: "'It's Riggle Bassbait, isn't it?' he said" ; "I don't have the gold I'd need to properly fund such an operation. I don't suppose you could give me a loan. . .?" ; "Go seed the waters; they're anxious to begin." Event facts: "This event is held every Sunday from 2pm-4pm"; "turn them in to Riggle Bassbait in Booty Bay". Wowhead Classic npc=15077 confirms the NPC and coords.
- **BONUS 2496 Baron Revilgaz** (not an event NPC; same short story; Booty Bay 27.2, 76.8). Quotes: "'I already extended you credit once, Bassbait.'" ; "'This is fantastic!' the Baron exclaimed." Not in Data.lua; no other worker output grepped has an entry for him (QA_release/F_report.md only lists the short story as a "possible add" for Seahorn). Drop if the Booty Bay zone owner already has him.

### REJECT (every event NPC looked at)
| Event | NPC (ID) | Reason / quoted line |
|---|---|---|
| Lunar Festival | All Elders (Arp, Beldak, Bellowrage, Bladeleaf, Bladesing, Bladeswift, Bloodhoof, Bluewolf, Brightspear, Chogan'gada, Darkcore, Darkhorn, Dawnstrider, Dekidig, Dreamseer, Ezra Wheathoof, Fargal, Farwhisper, Goldwell, Graveborn, Graymane, Grimtotem, Hammershout, High Mountain, Highpeak, Igasho, Ikk'xataz, Ikk'zivan, Ironband, Jarten, Kilias, Knythall, Lunaro, Meadowrun, Mistwalker, Moonstrike, Moonwarden, Morndeep, Morningdew, Morthie, Muraco, Nightwind, Northal, Nurgen, Obsidian, Ohanzee, Pamuya, Primestone, Ragetotem, Razlok, Riversong, Rumblerock, Runetotem, Sandrene, Sardis, Silvervein, Skychaser, Skygleam, Skyseer, Skywarden, Snowcrown, Splitrock, Starglade, Starsong, Starweave, Stonebeard, Stonefort, Stonespire, Stormbrow, Swornvow, Tauros, Thoim, Thunderhorn, Wanikaya, Whurain, Wildmane, Windrun, Windtotem, Winterhoof, Yurauk) | No own wiki page; book scan finds only list lines: "Some Lunar Festival Elders such as Elder Bronzebeard (Bronzebeard dwarves), Elder Ironband ..." and city location bullets ("Elder Darkcore, Undercity, upstairs in the Throne Room"). No book/RTS character. |
| Lunar Festival | Elder Bronzebeard (15871) | Page: "Elder Bronzebeard is an earthen ghost located in the Mystic Ward of Ironforge." No source ties him to a book/RTS character. |
| Lunar Festival | Omen (15467), Minion of Omen (15466) | "Omen is a demon boss summoned in the Moonglade during the Lunar Festival"; only WoW lore; no novel/RTS (book hits for "Omen" are the word "moment" and WoW zone pages). |
| Lunar Festival | Valadar Starsong (15864), Fariel Starsong (15909) | "Valadar Starsong is a night elf quest giver located at Nighthaven"; "Fariel Starsong is a night elf member of the Cenarion Circle"; 0 book lines for either. |
| Love is in the Air | Kwee Q. Peddlefeet (16085) | Goblin vendor; only a goblin-page gallery line. 0 book/RTS. (Crown Chemical Co., Snivel Rustrocket, Detective Snap Snagglebolt, Roka, Investigator Fezzen Brasstacks are Wrath-era, not classic.) |
| Noblegarden | Spring Rabbit/Collector/Gatherer, Noblegarden Vendor/Merchant | Generic. |
| Children's Week | Orphan Matron Nightingale (14450), Battlewail (14451), Alowicious Czervik (14480), Speedy (16547), Mr. Wiggles (16548), Whiskers the Rat (16549) | Wiki pages have no book/RTS line; 0 book hits for matrons/Czervik; the only "Orphan Matron" hit is a joke by the draenei orphan Dornaa. Pets are critters. |
| Midsummer | Flame Wardens/Keepers, Master Fire Eater, Fire Eater, Festival Loremaster/Talespinner, Midsummer Celebrant/Merchant/Supplier, Spirit of Summer, Summer Scorchling | Generic. Ahune, Luma Skymother, Ice Caller Briatha etc. are Wrath-era (not classic). |
| Harvest Festival | Wagner Hammerstrike (15011), Javnir Nashak (15012) | Wiki pages have no book/RTS line; 0 book hits. |
| Hallow's End | Darkcaller Yanka (15197), Sergeant Hartman (15199), Spoops (15309), Jesper (15310), Katrina Shimmerstar (15353), Rachelle Gothena (15354), Costumed/Masked Orphan Matron, Sinister Squashling | 0 book hits; Hartman: "appears to be a reference to Gunnery Sergeant Hartman ... Full Metal Jacket". |
| Hallow's End | Shade of the Horseman (23543), Headless Horseman | Page notes only a Hearthstone card ("appears as a legendary death knight hero card"); book hits only say a Scarlet cultist "wanted to restore the Headless Horseman" (Scarlet Crusade page, not a novel character page). |
| Winter Veil | Greatfather Winter (13444) / Great-father Winter (13445) | NPC is an actor (also in LESSONS_LEARNED). Wiki: "Smokywood Pastures hires actors to play the Greatfather". The Beyond the Dark Portal mention is the legendary figure in a simile ("Turalyon might have been Greatfather Winter himself"), not this actor. |
| Winter Veil | Metzen the Reindeer (15664), Wulmort Jinglepocket (13433), Macey/Khole/Guchie/Bessbi/Wolgren/Eebee Jinglepocket, Copperpinch family (Kaymard, Penney, Nardstrum, Jaycrue, Whulwert, Seersa, Morshelz, Hotoppik, Olnayvi) | Only appearance is the comic *I Got What Yule Need* / "Smokywood Storytime" (wiki: comic-section, Legends characters). Comics are not books. |
| Winter Veil | Historian Karnik (2916), Goli Krumn (1365), Furmund (9550), Sagorne Creststrider (13417) | Ordinary NPCs; 0 book lines (Karnik only in an Explorers' League NPC table). Snowmen/reindeer/helpers generic. |
| Darkmoon Faire | Silas Darkmoon (14823), Sayge (14822), Chronos (14833), Professor Thaddeus Paleo (14847), Maxima Blastenheimer (15303), Kerri Hicks (14832), Stamp Thunderhorn (14845), Lhara (14846), Rinling (14841), Yebb Neblegear (14829), Gelvas Grimegate (14828), Burth (14827), Morja (14871), Selina Dourman (10445), Sylannia (14844), Melnan Darkstone (14842), Kruban Darkblade (14843), Flik (14860), Felinni, Jubjub, Hornsley, Khaz Modan Ram and other pets/barkers | No book/RTS line on any page. Only hits: "Bodyguard of Silas Darkmoon" (ogre page table), "Sayge, Seer of Darkmoon" (Hearthstone), "Burth" (ogre table); "Chronos" matches are Anachronos. Dark Factions is an RPG book. |
| Fishing Extravaganza | Jang, Fishbot 5000 | Not in any book/RTS source. |
| AQ war effort / Scepter chain | Narain Soothfancy, Dr. Weavil, Lord Lakmaeran, Stewvul, Meridith the Mermaiden, Dirge Quikcleave, Azuregos, Proxy/Agent of Nozdormu, Colossus Researchers Eazel/Nestor/Sophia, Bornakk, Kandrostrasz, Vethsera, Baristolth | 0 book lines for the Scepter-chain NPCs (Weavil/Azuregos/Quikcleave hits are WoW zone pages only); Bornakk is a Blizzard community manager; Broxigar is not a classic NPC. |
| AQ war effort | Anachronos, Merithra, Caelestrasz, Arygos, Huntress Swiftriver | Already in Data.lua. |
| AQ war effort | Valstann Staghelm | In the short story but not a classic NPC. |

## Additions to existing entries
**3516 Arch Druid Fandral Staghelm** (Darnassus): add a second BOOK appearance. Source: https://warcraft.wiki.gg/wiki/The_War_of_the_Shifting_Sands_(short_story)
```
            {
                game = "BOOK",
                campaign = "The War of the Shifting Sands",
                missions = {},
                role = "Leads the night elf charge against the qiraji in the gorge with his son Valstann, and cannot reach Valstann before the Qiraji general kills him (short story)",
            },
```
Story addition (append one sentence, story becomes 5 sentences): `.. "In the short story The War of the Shifting Sands, he leads the night elves against the qiraji at the side of his son Valstann, who is killed by the Qiraji general."` Quotes: "Fandral Staghelm led the charge, his son Valstann at his side."; "Fandral led the front lines from the gorge into the open sands". Add the source URL above to `sources`.

**2487 Fleet Master Seahorn** (Stranglethorn Vale): add a second BOOK appearance. Source: https://warcraft.wiki.gg/wiki/Stranglethorn_Fishing_Extravaganza_(short_story)
```
            {
                game = "BOOK",
                campaign = "Stranglethorn Fishing Extravaganza",
                missions = {},
                role = "Tells Baron Revilgaz that a goblin is rowing into the harbor shouting his name, which brings Riggle Bassbait to the Baron (short story)",
            },
```
Quote: "'There's some nutty goblin rowing into the harbor,' Seahorn rumbled. 'He's shouting your name over and over.'" Story addition: `.. "In the short story Stranglethorn Fishing Extravaganza, he warns the Baron that a goblin is rowing into the harbor shouting his name."` Add the source URL above.

## Open points
- Wowhead Classic has no working /classic/event= pages for these events (301/404), so the NPC lists came from the retail event pages (ID < 40000) and were filtered by hand. Retail-only (Wrath+) NPCs were dropped.
- Riggle's story is a copy of an official site preview article. If only strictly "official short stories" from the Blizzard story archive count, drop 15077 and 2496 (everything else stays valid).
- Amnennar is "Mentioned" only (like Charlga); drop if no mentioned-only entries are wanted.

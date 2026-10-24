# H1 report (zones 1583, 1584, 2717, 2677, 2159, 2057, 2017)

Result: 11 ACCEPT (all in H1.lua), rest REJECT. Coordinates: Wowhead (and wiki.gg via curl) returned 403 for every NPC page, so all `coords = ""`; the orchestrator must fill them. Zone values: Rend = Upper Blackrock Spire; Nefarian and Lord Victor Nefarius = Blackwing Lair (alsoIn Upper Blackrock Spire); no accepted NPC in Lower Blackrock Spire.

## ACCEPT
| id | name | appearances | quoted line |
|---|---|---|---|
| 10429 | Warchief Rend Blackhand | BOOK Tides of Darkness (ch 11), BOOK Beyond the Dark Portal (ch 8) | "Dal'rend served as lieutenant to the new Warchief Orgrim Doomhammer ... they never disobeyed any of his orders" / "Dal'rend only laughed and refused ... Nefarian quickly took command of the Blackhand brothers" (https://warcraft.wiki.gg/wiki/Dal%27rend_Blackhand). The RTS link (backlink "Lord of Outland (WC3 Blood Elf)") is NOT used: "they were retconned into different characters". |
| 11583 | Nefarian | BOOK Beyond the Dark Portal (ch 8) | "Deathwing commanded Onyxia and Nefarian to secure the Blackrock orcs of Blackrock Spire as their new force. His children agreed to do so. [Beyond the Dark Portal, chapter 8]" |
| 10162 | Lord Victor Nefarius | BOOK Beyond the Dark Portal (ch 8) | "he had a human guise, appearing as Victor Nefarius, Lord of Blackrock" (same page); separate NPC ID, same character |
| 10184 | Onyxia | BOOK Beyond the Dark Portal (ch 8), BOOK Visage Day (short story) | "Onyxia ... appearing as the Stormwindian noblewoman Lady Katrana Prestor"; "Chronormu ... sought an audience with Onyxia ... Onyxia scoffed ... [Visage Day]". Separate from existing 1749 (linked via related). |
| 8929 | Princess Moira Bronzebeard | BOOK The Shattering (pg 227), Fire and Iron (short story), War Crimes (ch 1, 30), The Lilac and the Stone (Major) | "Moira was brought to Emperor Dagran Thaurissan in Shadowforge City" (Blackrock Depths NPC = Moira Thaurissan page); "Moira revealed that she was never ensorcelled by her husband" [The Shattering]; Lilac: "It focuses on Moira Thaurissan's thoughts and worries about dwarven politics and parenthood". Before the Storm / Quest for Pandaria / Jade Hunters left out to keep the entry focused (usable if wanted). |
| 10508 | Ras Frostwhisper | FK The Last Days of Lordaeron (Human): Siege, Vengeance | "Ras led a group of the cultists out of Andorhal ... [Siege (WC3 Human)]"; "Garek and Ilastar attacked him once again and defeated him ... [Vengeance (WC3 Human)]". Mission pages list him ("Defeat Ras Frostwhisper"). WC3 March of the Scourge NOT used (Reforged-only lich-hero swap, wiki calls it "likely an oversight"). |
| 10440 | Baron Rivendare | FK Last Days of Lordaeron: Treachery, Vengeance; FK Forsaken Kingdom (Undead): War of the Damned | "Baron Rivendare has revealed himself as a high-ranking member of the Cult of the Damned" [Treachery]; "Find and defeat baron Rivendare" [Vengeance]; War of the Damned lists him; same character per Baron Rivendare page ("Master of Stratholme ... Treachery"). |
| 10439 | Ramstein the Gorger | FK Last Days of Lordaeron: Vengeance | "Ramstein was present at Stratholme when Garek Bandarion and Ilastar Songbreeze entered the city to hunt down Baron Rivendare. [Vengeance (WC3 Human)]" (Vengeance character list names him; page is the Stratholme NPC, so same character). |
| 10813 | Balnazzar | TFT Legacy of the Damned (Undead): King Arthas, The Flight from Lordaeron, A Kingdom Divided, A New Power in Lordaeron | Backlinks list; "Balnazzar: Lady Sylvanas. We are pleased that you came." [A Kingdom Divided]; "Varimathras kills Balnazzar." [A New Power]; Balnazzar page: "the execution was faked and Balnazzar later came to possess the body of Saidan Dathrohan, as Grand Crusader of the Scarlet Crusade". "The Dark Lady" left out (only mentioned there). |
| 10812 | Grand Crusader Dathrohan | BOOK Tides of Darkness (pg 86-87), BOOK Of Blood and Honor (ch 5, 7) | "Saidan, then Lord Commander of the order, established himself in Stratholme"; "he had no other choice than to accuse him of treason and to send him to Stratholme to stand trial" [Of Blood and Honor, ch 5]. The Paladin's Beast: Characters table only (Supporting), no action text found, so not used. |
| 10435 | Magistrate Barthilas | BOOK Of Blood and Honor (ch 5, 7) | "Barthilas personally oversaw the paladin's prosecution and served as a witness during his master's trial ... also made plans for the torture and execution of Eitrigg". Characters table: Supporting. |

Note on the Of Blood and Honor chapter numbers: ch 5 (trial) and ch 7 (execution/attack) come from the Saidan Dathrohan page; Barthilas' own page gives no chapters.

## Blackrock Spire (1583): 105 NPCs, 11 candidates decided

| id | name | decision | reason |
|---|---|---|---|
| 4076 | Roach | REJECT | Generic creature (Roach) |
| 10299 | Scarshield Infiltrator | REJECT | Generic Scarshield mob; wiki_title redirect points to Vaelastrasz, a different character |
| 10340 | Vaelastrasz the Red | REJECT | Page has no book/RTS section: 'led efforts to combat Nefarian ... corrupted and magically enslaved within Blackwing Lair'; the only cited prints are guides/magazine |
| 10363 | General Drakkisath | REJECT | No book or RTS appearance on the page; only dungeon guide text |
| 10430 | The Beast | REJECT | No book or RTS appearance; dungeon boss only |
| 10442 | Chromatic Whelp | REJECT | Generic mob (chromatic whelp) |
| 10776 | Pip Quickwit | REJECT | Only source is the guide Exploring Azeroth (Novel-section tag is misleading): 'Following the Fourth War, he is mentioned in a report of Mathias Shaw' |
| 11859 | Doomguard | REJECT | Generic unit (Doomguard); wiki_title Ered'ruin is a different character |
| 16042 | Lord Valthalak | REJECT | No book or RTS appearance; summoned dungeon boss only |

## Blackrock Depths (1584): 123 NPCs, 9 candidates decided

| id | name | decision | reason |
|---|---|---|---|
| 2675 | Explosive Sheep | REJECT | Generic creature (Explosive Sheep) |
| 9018 | High Interrogator Gerstahn | REJECT | No book/RTS appearance; page category is comic only |
| 9019 | Emperor Dagran Thaurissan | REJECT | Only 'Mentioned' in The Jade Hunters, The Lilac and the Stone and The Shattering (name in Characters table, no action); his son Dagran Thaurissan II is the book character |
| 9022 | Dughal Stormwing | REJECT | No appearance outside the game (Characters category only) |
| 9023 | Marshal Windsor | REJECT | Only appears in the World of Warcraft: The Comic (not a book) and the quest chain |
| 9056 | Fineous Darkvire | REJECT | Characters table of The Jade Hunters only, no action ('Daughter of Fineous, one of Moira's premier architects' is about Fenella) |
| 10116 | Slave | REJECT | Generic ('Slave' redirects to the concept Slavery) |
| 12944 | Lokhtos Darkbargainer | REJECT | No book/RTS appearance: 'a Dark Iron dwarf found in the Grim Guzzler' |

## Molten Core (2717): 63 NPCs, 11 candidates decided

| id | name | decision | reason |
|---|---|---|---|
| 11502 | Ragnaros | REJECT | Only 'Mentioned' in The Jade Hunters, Charge of the Aspects and The Lilac and the Stone (Characters table, no action); RPG books do not count |
| 11661 | Flamewaker | REJECT | Generic mob type (Flamewaker) |
| 11668 | Firelord | REJECT | Generic unit type (Firelord, an elemental class) |
| 11671 | Core Hound | REJECT | Generic creature (core hound) |
| 11859 | Doomguard | REJECT | Generic unit (Doomguard); wiki_title Ered'ruin is a different character |
| 11982 | Magmadar | REJECT | No book/RTS appearance; dungeon boss only |
| 12018 | Majordomo Executus | REJECT | No book/RTS appearance; dungeon boss only |
| 12056 | Baron Geddon | REJECT | No book/RTS appearance; dungeon boss only |
| 12057 | Garr | REJECT | No book/RTS appearance; dungeon boss only |
| 12265 | Lava Spawn | REJECT | Generic creature (lava spawn) |
| 227939 | The Molten Core | REJECT | ID > 200000 (Season of Discovery) and a location object, not a character |

## Blackwing Lair (2677): 51 NPCs, 6 candidates decided

| id | name | decision | reason |
|---|---|---|---|
| 416 | Imp | REJECT | Generic creature (Imp) |
| 11859 | Doomguard | REJECT | Generic unit (Doomguard); wiki_title Ered'ruin is a different character |
| 12467 | Death Talon Captain | REJECT | Generic mob, no book/RTS appearance |
| 14020 | Chromaggus | REJECT | No book/RTS appearance; dungeon boss only |

## Onyxia's Lair (2159): 1 NPCs, 1 candidates decided

| id | name | decision | reason |
|---|---|---|---|

## Scholomance (2057): 59 NPCs, 8 candidates decided

| id | name | decision | reason |
|---|---|---|---|
| 1853 | Darkmaster Gandling | REJECT | Only the guide Exploring Azeroth: 'Following the Fourth War, Mathias Shaw stated ...'; Cult of the Damned pages are not books |
| 4075 | Rat | REJECT | Generic creature (Rat); the RTS 'Rat' is a critter unit, not a character |
| 10502 | Lady Illucia Barov | REJECT | No book/RTS appearance beyond the dungeon |
| 10503 | Jandice Barov | REJECT | Only the guide Exploring Azeroth (Mathias Shaw report) |
| 10504 | Lord Alexei Barov | REJECT | No book/RTS appearance beyond the dungeon |
| 11261 | Doctor Theolen Krastinov | REJECT | No book/RTS appearance: 'a rare elite human found in Butcher's Sanctum' |
| 11622 | Rattlegore | REJECT | Only the guide Exploring Azeroth (Mathias Shaw report) |

## Stratholme (2017): 91 NPCs, 13 candidates decided

| id | name | decision | reason |
|---|---|---|---|
| 416 | Imp | REJECT | Generic creature (Imp) |
| 417 | Felhunter | REJECT | Generic creature (Felhunter spell summon) |
| 10390 | Skeletal Guardian | REJECT | Generic unit type (Skeletal Guardian) |
| 10516 | The Unforgiven | REJECT | No book/RTS appearance: 'an elite wraith located in Market Row' |
| 10917 | Aurius | REJECT | Only a name similarity: 'Aurius's name is similar to ... random names for Paladins in Warcraft III'; no RTS character |
| 16387 | Atiesh | REJECT | An item/quest object (staff). Medivh wields Atiesh in Warcraft III, but a staff is not a character |
| 243252 | Leonid Barthalomew | REJECT | SoD NPC (ID > 200000) and same character as 243393, already in Data.lua under another ID |
| 243393 | Leonid Barthalomew the Revered | REJECT | SoD NPC (ID > 200000); already in Data.lua under another ID (per brief) |

## Reverse check (names run through book pages that have a Characters section)
Every non-generic NPC name and surname in the seven zones (about 450 NPCs, mobs with generic prefixes such as Crimson/Scarshield/Blackhand/Smolderthorn/Spirestone/Death Talon/Scholomance/Risen skipped) was matched against the 95 book pages. Hits: Rend Blackhand, Nefarian, Onyxia, Moira, Dagran (II only), Fineous (mention), Ragnaros (mention), Dathrohan, Barthilas, Ramstein the Gorger. Ramstein in *Shadows Rising* (Characters table, abomination) is a different, later appearance without action text and is not used; the RTS link is the Vengeance mission. Also run through all page types with `lookup.py books`: Windsor, Gandling, Rivendare, Balnazzar, Frostwhisper, Hydraxis, Lokhtos, Grimstone, Gerstahn, Dughal, Majordomo, Krastinov, Barov, Rattlegore, Chromaggus, Gor'shak, Rocknot, Magmus, Angerforge, Bael'Gar, Anastari, Sothos, Ysida, Galford, Willey: no book hit (hits only on faction/overview pages).

## Additions to existing entries
- 1749 Lady Katrana Prestor (Onyxia): add BOOK "Visage Day" (short story): "Onyxia scoffed at Chronormu's view that dragons chose a visage to better relate to the mortal races" (https://warcraft.wiki.gg/wiki/Visage_Day_(short_story)); add `related = { 10184 }`.
- 2425 Varimathras: add `related = { 10813 }` (Balnazzar).
- 10181 Lady Sylvanas Windrunner: could add "A Kingdom Divided" to her TFT missions if not there (Balnazzar meeting: "Sylvanas assisted to a secret meeting with the dreadlords").
- 1855 Tirion Fordring / 3144 Eitrigg: add `related = { 10812, 10435 }` (Dathrohan, Barthilas) - both feature in Of Blood and Honor.

## Open questions
- Coordinates for all 11 entries still empty (Wowhead 403).
- Rend/Nefarian: should Lord Victor Nefarius (10162) stay as its own entry? Same character as Nefarian; kept for players who target the human form.
- 8929 Moira: Before the Storm (Minor), Quest for Pandaria and The Jade Hunters (Supporting) are further valid book appearances if a longer entry is wanted.

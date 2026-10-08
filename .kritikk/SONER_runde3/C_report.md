# Group C report (Undercity 1497, Tirisfal Glades 85, Silverpine Forest 130, Shadowfang Keep 209, Scarlet Monastery 796)

## Counts
- Candidates with already_in_Data_lua false: 1497: 4, 85: 12, 130: 3, 209: 3, 796: 8 (30 decided).
- New entries written: 2 (both uncertain). Coordinates empty for both (Wowhead has none in the fetched page).

## ACCEPT (uncertain, in C.lua)
| NPC | ID | Zone | Book | Role | Source of identity |
|---|---|---|---|---|---|
| Baron Silverlaine | 3887 | Shadowfang Keep | Arthas: Rise of the Lich King | Mentioned | Characters table links [[Baron Silverlaine]] to the NPC article; no explicit identity statement; story left "" |
| Highlord Mograine <The Ashbringer> | 242499 | Scarlet Monastery | We Ride Forth (short story) | Mentioned | Name and title match the Alexandros Mograine article; the article does not cite 242499 |

Sources: https://warcraft.wiki.gg/wiki/Arthas:_Rise_of_the_Lich_King ; https://warcraft.wiki.gg/wiki/Alexandros_Mograine ; https://warcraft.wiki.gg/wiki/We_Ride_Forth ; https://www.wowhead.com/classic/npc=3887 ; https://www.wowhead.com/classic/npc=242499

## Tyler and Robert Gossom (backlinks_all.txt question)
Decision: NOT the same characters, no entry. Quoted line on Tyler's page: "a [[Tyler (Warcraft III)|Tyler]] was also seen punching with a [[Robert (Warcraft III)|Robert]] in [[Trudging through the Ashes|chapter 1]] of the [[Path of the Damned|undead campaign]]". The Undercity page calls the Fight Club-style trivia the reason for the names, and the RTS links are indefinite ("a Tyler", "a Robert") with no identity claim. The linked "(Warcraft III)" disambiguation pages are not in the cache. The only book hit for Tyler is a Gladiator lore table row ("| {{RaceIcon|Undead|Male}} [[Tyler]]"), which is not a book. Robert Gossom has no book hit at all.

## REJECT table (candidates with already_in_Data_lua false)
| Zone | Name (id) | Reason (quoted line where possible) |
|---|---|---|
| 1497 | Aelthalyste (4606) | Only RPG: "The banshee Aelthalyste, in the Undercity ... [[Horde Player's Guide]], pg. 161"; no RTS, no novel |
| 1497 | Tyler (5653) | Different character: see above |
| 1497 | Robert Gossom (5655) | Different character: "In the case of Robert Gossom, a [[Robert (Warcraft III)|Robert]] was also seen punching with a [[Tyler (Warcraft III)|Tyler]]" |
| 1497 | Spirit Healer (6491) | Generic unit type |
| 85 | Hogger (448) | Wrong zone: "is a [[gnoll]] found atop [[Hogger Hill]] in southwestern [[Elwynn Forest]]"; no WC3 or novel link |
| 85 | Gunther Arcanus (1497) | Only in-game book: "Gunther ... is mentioned alongside ... in the [[Dalaran]] book \"[[Losses of the Third War]]\""; no RTS, no novel |
| 85 | Shadow Priest Sarvis (1569) | RPG only: "[[Horde Player's Guide]], pg. 161" |
| 85 | Executor Arren (1570) | RPG only: "''[[Lands of Conflict]]'', pg. 106" |
| 85 | Worg (1765) | Generic species page: "a species of massive wolves" |
| 85 | Captured Scarlet Zealot (1931) | Comic only: "''[[Legends Volume 3]]'': ''[[Crusader's Blood]]''" |
| 85 | Abigail Shiel (2118) | Cookbook author only: "author<ref>''[[World of Warcraft: The Official Cookbook]]''" |
| 85 | Velma Warnam (4773) | In-game mail book only ({{Book|Journeyman Riding in Tirisfal Glades}}); no RTS, no novel |
| 85 | Spirit Healer (6491) | Generic unit type |
| 85 | Junior Apothecary Holland (10665) | Voice reuse, not identity: "uses the same voice file as the [[Necromancer (Warcraft III)|necromancers]] of the [[Undead Scourge]]" |
| 85 | Alexi Barov (11022) | Different franchise reference only: "may be a reference to ... [[Alexei Stukov]], a character from the StarCraft universe" |
| 85 | The Banshee Queen (15193) | Duplicate character: wiki_title is Sylvanas Windrunner ("formerly styled ... the Banshee Queen"); already in Data.lua as 10181. Not added. Open question below |
| 130 | Worg (1765) | Generic creature (see above) |
| 130 | Shadow Priest Allister (2121) | RPG only: "''[[Lands of Conflict]]'', pg. 103"; his book is in-world ("He wrote a book, [[Holy Bologna]]") |
| 130 | Spirit Healer (6491) | Generic unit type |
| 209 | Commander Springvale (4278) | WoW quests and Exploring Azeroth only; no RTS, no novel |
| 209 | Incubus (185317) | Generic demon type: wiki_title is Sayaad, a species page |
| 796 | Fire Elemental (575) | Generic unit type ("Fire elementals are elemental creatures") |
| 796 | Rabbit (721) | Generic critter (Spring Rabbit, Noblegarden) |
| 796 | Rat (4075) | Generic creature |
| 796 | Scarlet Chaplain (4299) | Role title, not a character |
| 796 | High Inquisitor Fairbanks (4542) | Comic only: "Fairbanks in the comic" / "''[[World of Warcraft: Ashbringer]]''" (comic, excluded); no novel or RTS line found |
| 796 | Arcanist Doan (6487) | Comic only: "Arcanist Doan comic" / "''[[World of Warcraft: Ashbringer]]''"; no novel or RTS line found |

## Already in Data.lua (no new entry)
High Inquisitor Whitemane (3977), Lady Sylvanas (10181), Master Apothecary Faranell (2055), Sharlindra (2227), Varimathras (2425), Parqual Fintallas (4488), Doctor Halsey (4611), Apothecary Keever (5734), Gordo (10666), Archmage Arugal (4275), Dalar Dawnweaver (1938), Snarlmane (1948).

## Reverse check (step 4)
Ran on every non-generic named NPC in npcs_1497/85/130/209/796 not in Data.lua (about 600 names; generic creatures, mobs, guards, and vendors skipped by name pattern), plus a second pass on names the pattern filtered out. Hits were checked against the Characters-table lines and book text:
- Only real new book hits: Baron Silverlaine (Arthas), Alexandros Mograine (We Ride Forth). Both written as uncertain.
- Not book hits: Thule Ravenclaw (Scourge page only), Andron Gant and Fenwick Thatros (Varimathras page only), Devlin Agamand, Captain Dargol, Captain Vachon (Scourge and Scarlet Crusade pages), Brother Malach, Edward and Tyler (gladiator lore table), Samantha Shackleton (in-game Khadgar's Journal), Lillith Nefara (no hits), Joanna Blueheart (no book), Lirath Windrunner (not in my zones).

## Additions to existing entries (not rewritten; for the orchestrator)
- Lady Sylvanas Windrunner (10181): Characters-table hits missing from Data.lua: "A Good War", "Elegy", "A Thousand Years of War", "Before the Storm", "Beyond the Dark Portal", "Blood Ties", "Blood of the Highborne", "In the Shadow of the Sun". Role columns not checked.
- Varimathras (2425): "Before the Storm" (Characters: "*{{RaceIcon|Dreadlord2}} [[Varimathras]]") missing.
- Archmage Arugal (4275): "In the Shadow of the Sun" and "Wolfheart" (Characters table) missing. Data.lua has only "Lord of His Pack".
- High Inquisitor Whitemane (3977): no further book hits.

## Open questions
1. The Banshee Queen (15193): is a second NPC ID for Sylvanas wanted? Her existing entry is 10181. Not added.
2. Baron Silverlaine and Highlord Mograine are uncertain only because the identity link is via wiki Characters tables and name/title match. Someone with the novel text (Arthas: Rise of the Lich King; We Ride Forth) should confirm, and Wowhead coordinates should be filled in by the orchestrator.
3. "Death is Contagious" (cited on the Alexandros page) is not in the cache; its type (book or not) is unknown, so it was not used.
4. Thule Ravenclaw (1947, Silverpine) may have novel appearances not in the cache; needs a check of the Thule page and the Characters tables of Dalaran and Scourge novels.

# Group B report: Orgrimmar, Durotar, Ragefire Chasm, The Barrens

Files: `B.lua` (7 new entries), `B_report.md`. Repo not edited.

## Counts
| Zone | NPCs in zone | Candidates | Candidates not in Data.lua | ACCEPT |
|---|---|---|---|---|
| Orgrimmar (1637) | 260 (255 unique names) | 17 | 8 | 0 |
| Durotar (14) | 194 | 16 | 12 | 1 (Master Gadrin) |
| Ragefire Chasm (2437) | 13 | 0 (empty file) | 0 | 0 |
| The Barrens (17) | 374 | 17 | 15 | 6 (Jorn Skyseer, Wharfmaster Dizzywig, Innkeeper Wiley, Cannoneer Smythe, Cannoneer Whessan, Jazzik) |

Total 7 new entries in B.lua. Confidence: confirmed = Master Gadrin, Jorn Skyseer, Wharfmaster Dizzywig; uncertain = Innkeeper Wiley, Cannoneer Smythe, Cannoneer Whessan, Jazzik.

## Coordinates
Wowhead classic pages fetched via WebFetch returned no g_mapperData (the converted page does not expose it). All 7 entries have `coords = ""`. The orchestrator should fill them.

## ACCEPT (B.lua)
- **Master Gadrin** (3188), Durotar, confirmed. BOOK Before the Storm ch. 12 (Spirit Rise, Thunder Bluff; Gadrin page cites the chapter); BOOK Vol'jin: Shadows of the Horde, Mentioned (page's Mentioned list; Characters section). Sources: https://warcraft.wiki.gg/wiki/Master_Gadrin , https://warcraft.wiki.gg/wiki/Before_the_Storm , https://warcraft.wiki.gg/wiki/Vol%27jin:_Shadows_of_the_Horde
- **Jorn Skyseer** (3387), The Barrens, confirmed. BOOK The Shattering: Prelude to Cataclysm ch. 22 (gives shelter to Baine Bloodhoof in Thunder Bluff; Characters section also lists him). Sources: https://warcraft.wiki.gg/wiki/Jorn_Skyseer , https://warcraft.wiki.gg/wiki/The_Shattering:_Prelude_to_Cataclysm
- **Wharfmaster Dizzywig** (3453), The Barrens, confirmed. BOOK Night of the Dragon (transport for Velinde Starsong and Iridi; cited on his page; Characters section lists him). Novel by Richard A. Knaak (wiki intro). Sources: https://warcraft.wiki.gg/wiki/Wharfmaster_Dizzywig , https://warcraft.wiki.gg/wiki/Night_of_the_Dragon
- **Innkeeper Wiley** (6791), The Barrens, uncertain. Only the Night of the Dragon Characters list names him; no plot line found in the full summary.
- **Cannoneer Smythe** (3454), The Barrens, uncertain. Only the Jaina Proudmoore: Tides of War Characters list; no plot line found.
- **Cannoneer Whessan** (3455), The Barrens, uncertain. Same as Smythe (Tides of War Characters list only).
- **Jazzik** (3498), The Barrens, uncertain. Only The Shattering: Prelude to Cataclysm Characters list; no plot line found.

## Candidate decisions (not in Data.lua)

### Orgrimmar (1637)
| Name (id) | Decision | Reason |
|---|---|---|
| Neeru Fireblade (3216) | REJECT | Page: "was an orc warlock located in the Cleft of Shadow". Only RPG (Lands of Mystery, RPG guide), Hearthstone, WoW. |
| Orgrimmar Grunt (3296) | REJECT | Generic RTS unit type, not a character. |
| Kiro (3359, War Harness Maker) | REJECT | Different character. Kiro page: "For the orc of the same name, Kiro (orc)". The page is the vulpera caravan leader (Vol'dun), who appears in Shadows Rising and Heartlands. The orc is a separate article. |
| Belgrom Rockmaul (4485) | REJECT (open question) | Page has a {{Novel-section}} but the sentence about Feralas is cited to Exploring Azeroth: Kalimdor, a guide. No novel Characters entry for him. Only a Thrall-page line citing a quest. Orchestrator may check the Novel-section history. |
| Kildar (4752) | REJECT | Only an in-game book (Journeyman Riding in Orgrimmar). |
| Doomguard (11859) | REJECT | Generic demon unit type (page is Ered'ruin). |
| Omen (15467) | REJECT | Lunar Festival demon boss; RTS not cited; appears only in HotS and Hearthstone. No Omen identity in book cache. |
| Gurgthock (218246) | REJECT | Goblin quest giver in many WoW locations; no RTS or novel appearance on page. |
| Godan (3345, reverse-check) | REJECT | Enchanting trainer. The only book-like line is on the Sylvanas page citing The Dark Cleric's Bidding, which is a WoW quest (fetched wiki: "It's a quest from World of Warcraft"). |

### Durotar (14)
| Name (id) | Decision | Reason |
|---|---|---|
| Hogger (448) | REJECT | Page: RTS only as "gnoll creeps"; appears in HotS, Hearthstone, Rumble, film poster. No RTS or book character. |
| Razormane Scout (3112) | REJECT | WC3 unit type. |
| Thunder Lizard (3130) | REJECT | Creature type (no page). |
| Lieutenant Benedict (3192) | REJECT | Different character. Page: "Like Benedict from Warcraft III, his name is probably a reference to Benedict Arnold." |
| Orgrimmar Grunt (3296) | REJECT | Generic. |
| Master Vornal (3304) | REJECT | Only RPG and Horde Player's Guide p. 145 (guide). The "Short stories" line is a summary of that guide. |
| Spirit Healer (6491) | REJECT | Generic. |
| Xar'Ti (7953) | REJECT | Only an in-game book (Journeyman Riding in Durotar). |
| Raider Jhash (10676) | REJECT | Uses the voice set of the WC3 "Raider" unit; not a character. |
| Raider Kerr (10682) | REJECT | Same as Jhash. |
| Gurgthock (218246) | REJECT | See Orgrimmar. |

### Ragefire Chasm (2437)
No candidates. Reverse check on named NPCs (see below). Named bosses Oggleflint, Jergosh the Invoker, Bazzalan, Taragaman the Hungerer, Maur Grimtotem: REJECT, WoW Classic dungeon bosses; no RTS or book Characters entry. Jergosh's wiki page has only WoW Legion and Ragefire Chasm content. Remaining names are generic mobs.

### The Barrens (17)
| Name (id) | Decision | Reason |
|---|---|---|
| Explosive Sheep (2675) | REJECT | Generic creature type; the page only notes a WC2 critter reference. |
| Thork (3429) | REJECT | No RTS or book hit; page: "lead the defenses here in the name of the Warchief" (WoW). |
| Wildthorn Stalker (3819) | REJECT | Tarantula mob. |
| Silithid Swarm (4196) | REJECT | Generic mob. |
| Doan Karhan (6247) | REJECT | Tides of War is cited only for the fate of Forward Command. The book cache has no "Doan" line. |
| Spirit Healer (6491) | REJECT | Generic. |
| Peon (14901) | REJECT | Generic unit type. |
| Omen (15467) | REJECT | See Orgrimmar. |
| Dark Rider (218931) | REJECT | Generic unit type ("Dark Riders"). |
| Captain Thalo'thas Brightsun (reverse check) | REJECT | Only a High elf page reference; no book Characters entry. |
| Sarilus Foulborne (reverse check) | REJECT | No book Characters entry; WoW only. |
| Sergra Darkthorn (reverse check) | REJECT | The "Earth Mother" line is about a deity, not her; Thrall line cites a quest. |
| Tatternack Steelforge (reverse check) | REJECT | Only a Thrall-page line citing a quest. |

## Reverse check
Ran `lookup.py books` on every unique NPC name in each zone (Orgrimmar 255, Durotar 194, Barrens 370, Ragefire Chasm 13), then filtered to whole-word matches. Book-type keys and Characters-section entries were checked by hand. Keys that are wiki pages (goblin, troll, Darkspear tribe, snake, etc.) were not counted as books. Names with book hits that are already in Data.lua were not re-decided.

## Additions to existing entries (not written; Characters-list hits only, role and book type not verified)
- Eitrigg (3144): Characters lists in Heartlands, War Crimes, Rise of the Horde, Blood Ties. Existing entry has only Of Blood and Honor and Jaina Proudmoore: Tides of War.
- Gazlowe (3391): Characters lists in Before the Storm, Jaina Proudmoore: Tides of War, Shadows Rising. Existing entry has The Shattering and The Goblin Way (and a Founding of Durotar campaign).
- Kor'jus (3329) and Innkeeper Grosk (6928): Characters list in War Crimes. Book type of War Crimes not verified.
- Vol'jin (10540): Characters lists in Before the Storm, Shadows Rising, The Shattering, War Crimes (existing entry lacks these).

## Open questions
1. Belgrom Rockmaul: the {{Novel-section}} cites a guide. Please check whether a novel supports it.
2. War Crimes: type not confirmed as a novel. Used only for additions, not for any new entry.
3. Smythe, Whessan, Jazzik and Wiley have Characters-list identity only. Consider a second check against the books' full text if the orchestrator wants them confirmed.
4. Coordinates for all 7 new entries are empty.

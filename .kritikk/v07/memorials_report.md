# Classic-era memorials to RTS characters: research report (2026-10-12)

Follow-up to `rts_wc12_report.md` (no WC1/WC2/BTDP character is a classic NPC). This report covers the objects and places in the classic-era world that commemorate or depict those characters. List 1 covers WC1/WC2/BTDP characters. List 2 covers WC3/TFT characters who are not NPCs in `WarcraftLore/Data.lua`.

## Method

- **Wowhead Classic database.** I ran searches (`/classic/search?q=` and `/classic/objects?filter=na=`) on 45 character names (Lothar, Llane, Medivh, Doomhammer, Blackhand, Gul'dan, Terenas, Uther, Turalyon, Khadgar, Alleria, Danath, Kurdran, Trollbane, Proudmoore, Hellscream, Arthas, Mannoroth, Kel'Thuzad, Archimonde, Illidan and others). I also searched on generic words: Tomb, Here Lies, Monument, Statue, Memorial, Grave, Plaque, Shrine and Remains. Each hit's object page gave the name, map coordinates (`g_mapperData`) and readable text (`new Book` pages).
- **warcraft.wiki.gg.** I used the MediaWiki API with the requested User-Agent and at least 0.9 s between requests. I read about 45 location, object, quest and character pages for patch history, "named after" claims and RTS mission links.
- **Classic-era test.** An object counts as classic-era when it has a Wowhead **Classic** object page with an original 1.x ID (below 180000). Season of Discovery IDs (409xxx and up, 454xxx) and "added in 4.0.3a or later" were rejected. I also checked the wiki for a classic note ("Classic only", "removed 4.0.3a", or "after Classic the epitaph was changed").
- **Object type 9 = readable text.** Hovering it shows its name in a tooltip. Clicking it opens a text page with the quoted inscription. Type -2/3 are quest or container objects. Type -3 is a herb node.

## Main table

Coordinates are Wowhead Classic map coordinates (first spawn). "Names them?" asks whether the in-game object name or text names the character.

### List 1: WC1 / WC2 / BTDP characters

| Object / place | Type | Zone | Coords | Object ID | Character | Game(s) + missions | Names them? | Classic-era? | Evidence (quote + URL) |
|---|---|---|---|---|---|---|---|---|---|
| **Uther the Lightbringer** (plaque in **Uther's Tomb**, subzone area 196, with Uther's statue) | Tomb + readable plaque (type 9) | Western Plaguelands | 52.1, 83.2 | 2082 | Uther the Lightbringer | WC2 ToD Human: The Battle at Darrowmere (H9), Betrayal and the Destruction of Alterac (H11). Also WC3 Human (Defense of Strahnbrad, Blackrock and Roll, The Culling…) and WC3 Undead (Digging up the Dead) | Yes: object name and text | Yes. Pre-Cataclysm screenshots on the wiki, Classic object page | "Here lies Uther the Lightbringer First Paladin - Founder of the Order of the Silver Hand" – https://www.wowhead.com/classic/object=2082 ; https://warcraft.wiki.gg/wiki/Uther%27s_Tomb |
| **Here Lies King Terenas Menethil II** | Tomb plaque (type 9) behind the Lordaeron throne room | Ruins of Lordaeron (Wowhead maps it to Undercity) | 65.9, 43.4 (Undercity map) | 175659 | Terenas Menethil II | WC2 ToD: The Fall of Lordaeron (O14), Human briefings. WC3 Human: The Warning | Yes | Yes (Classic object) | "Here lies King Terenas Menethil II -- Last True King of Lordaeron." – https://www.wowhead.com/classic/object=175659 ; https://warcraft.wiki.gg/wiki/Terenas_Menethil_II |
| **Trollbane's Tomb** | Tomb, quest object (ends "Trol'kalar" 645, starts "Trol'kalar" 646) | Arathi Highlands (Stromgarde Keep crypt) | 28.9, 59.6 | 2703 | Thoras Trollbane | WC2 ToD Orc: Tol Barad (O5), The Badlands (O6), The Fall of Stromgarde (O7) | Yes. Object says "Trollbane". Quest 638 says "With Thoras Trollbane dead…" | Yes. Classic quest chain, removed 4.0.3a | "Trollbane's remains are entombed in the Sanctum behind the chapel in Stromgarde. Retrieve Trol'kalar." – https://warcraft.wiki.gg/wiki/Trol%27kalar_(Classic) ; https://www.wowhead.com/classic/object=2703 |
| **King Llane I of the House of Wrynn** (statue plaque, Royal Gallery) | Statue + plaque (type 9) | Stormwind City (Stormwind Keep) | 64.2, 6.4 | 177200 | Llane Wrynn I | WC1: Human campaign briefings (the King gives orders; his murder is announced before the last missions). Orc: Stormwind Keep (his castle) | Yes | Yes. "Classic only", removed 4.0.3a | "King Llane I of the House of Wrynn / Liege Lord of Stormwind / Defender of Azeroth" – https://www.wowhead.com/classic/object=177200 ; https://warcraft.wiki.gg/wiki/Royal_Gallery |
| **Grand Admiral Daelin Proudmoore** (statue plaque, Royal Gallery) | Statue + plaque (type 9) | Stormwind City (Stormwind Keep) | 64.7, 6.8 | 177201 | Daelin Proudmoore | WC2 ToD Human briefings (H3/H4/H12/H13). BTDP Orc: Assault on Kul Tiras (O8). TFT bonus campaign | Name only. The text reads "Commander of the Alliance Fleets / Friend of Stormwind" | Yes (removed 4.0.3a) | https://www.wowhead.com/classic/object=177201 ; https://warcraft.wiki.gg/wiki/Royal_Gallery ("statues of … King Llane, and Daelin Proudmoore") |
| **General Turalyon** (Valley of Heroes statue plaque) | Statue + plaque (type 9) | Stormwind City, Valley of Heroes | 63.8, 75.1 | 25330 | Turalyon (plaque also names Lothar and Uther) | WC2 ToD Human: The Great Portal (H14). BTDP Human: Alleria's Journey (H1), The Bitter Taste of Victory (H12) | Yes | Yes. The wiki notes the plaque text "at some point after Classic" was changed | "Former Lieutenant to Lord Anduin Lothar. Knight of the Silver Hand. High General of the Alliance Expedition…" – https://www.wowhead.com/classic/object=25330 ; https://warcraft.wiki.gg/wiki/Valley_of_Heroes |
| **Archmage Khadgar of the Kirin Tor** (statue plaque) | Statue + plaque (type 9) | Stormwind City, Valley of Heroes | 64.9, 78.2 | 25333 | Khadgar (plaque also names Medivh and Antonidas) | BTDP Human: hero/briefing in most missions (Alleria's Journey … Khadgar's Sacrifice) | Yes | Yes | "Former apprentice of Medivh. Supreme Commander of the Alliance Expedition…" – https://www.wowhead.com/classic/object=25333 |
| **Ranger Captain Alleria Windrunner** (statue plaque) | Statue + plaque (type 9) | Stormwind City, Valley of Heroes | 65.4, 77.4 | 25331 | Alleria Windrunner (signed by Sylvanas) | BTDP Human: Alleria's Journey (H1), Deathwing (H7) | Yes | Yes | "Renowned Troll Hunter of Quel'Thalas. Lead Scout and Intelligence Agent for the Alliance Expedition…" – https://www.wowhead.com/classic/object=25331 |
| **Danath Trollbane** (statue plaque) | Statue + plaque (type 9) | Stormwind City, Valley of Heroes | 67.3, 80.4 | 25332 | Danath Trollbane (signed by Thoras Trollbane) | BTDP Human: Alleria's Journey (H1), The Battle for Nethergarde (H2) | Yes | Yes | "Militia Commander of Stromgarde. Tactical Advisor to General Turalyon…" – https://www.wowhead.com/classic/object=25332 |
| **Kurdran Wildhammer** (statue plaque) | Statue + plaque (type 9) | Stormwind City, Valley of Heroes | 66.4, 81.0 | 25329 | Kurdran Wildhammer (and Sky'ree) | BTDP Human: The Fall of Auchindoun (H6), Deathwing (H7) | Yes | Yes. The Classic text is still signed "Falstad Wildhammer - Lord of Aerie Peak" (changed later) | "Renowned Dragon Fighter. Gryphon Master of the Aerie Peak…" – https://www.wowhead.com/classic/object=25329 |
| **Monument to Grom Hellscream** (Demon Fall Canyon) | Grave monument (type 9) | Ashenvale | 82.9, 79.1 | 21004 | Grom Hellscream (and Mannoroth). Not in Data.lua | BTDP Orc: Slayer of the Shadowmoon (O1, freed as hero). WC3 Orc: The Hunter of Shadows, The Blood of Mannoroth, By Demons Be Driven, The Death of Hellscream | Yes | Yes (1.x ID). The SoD copy 454487 is excluded | "Here lies Grommash Hellscream, Chieftain of the Warsong Clan … stood alone before the demon Mannoroth" – https://www.wowhead.com/classic/object=21004 ; https://warcraft.wiki.gg/wiki/Monument_to_Grom_Hellscream |
| **Khadgar's Whisker** | Herb node (gatherable) | Many (Badlands, Arathi, STV, Feralas, Dustwallow…) | e.g. Arathi 15.4, 44.0 | 2043 | Khadgar | BTDP Human (see above) | Name only | Yes | "\"Khadgar's Whisker\" is named after Archmage Khadgar." – https://warcraft.wiki.gg/wiki/Khadgar%27s_Whisker ; https://www.wowhead.com/classic/object=2043 |
| **Orgrimmar** | City named in his honour | Durotar / Orgrimmar | – | zone 1637 | Orgrim Doomhammer | WC1 Orc (the player is Orgrim after Blackhand's fall). WC2 ToD Orc (all briefings), Human: Assault on Blackrock Spire (H13) | Partly (the name "Orgrim-mar"). No in-game text says so | Yes | "Thrall named 'Orgrimmar', in honor of his friend and mentor Orgrim Doomhammer" (cites Chronicle Vol. 3 p. 111) – https://warcraft.wiki.gg/wiki/Orgrimmar |
| **Statue of Anduin Lothar** (unnamed statue; the unclickable **Lotharian Lotus** grows at its foot) | Statue (map doodad, no tooltip) | Burning Steppes (pre-Cata "Pillar of Ash" camp) | ~47, 54 (Classic comment) | 178125 (lotus) | Anduin Lothar | WC1 Human (hero in briefings). WC2 ToD Human H1–H13, dies in Assault on Blackrock Spire (H13) | No. The statue has no name. The lotus "can't be clicked on" | Probably. The Lotus is in the Wowhead Classic DB. A Classic-page comment says "seen in front of the statue of Lord Anduin Lothar, charging to Blackrock Mountain". The Black Tooth Hovel subzone name is Cata, the statue is older | https://warcraft.wiki.gg/wiki/Black_Tooth_Hovel ; https://www.wowhead.com/classic/object=178125 |

### List 2: WC3 / TFT characters not in Data.lua

| Object / place | Type | Zone | Coords | Object ID | Character | Game(s) + missions | Names them? | Classic-era? | Evidence |
|---|---|---|---|---|---|---|---|---|---|
| **Monument to Grom Hellscream** | see List 1 (counted there) | Ashenvale | 82.9, 79.1 | 21004 | Grom Hellscream | WC3 Orc (see above) | Yes | Yes | see above |
| **The Armor of Mannoroth** (armour and skull on the white tree) | Trophy + plaque (type 9) | Orgrimmar (Valley of Wisdom) | 45.3, 34.9 | 175658 | Mannoroth (Grom as "one brave orc") | WC3 Orc: The Hunter of Shadows, The Blood of Mannoroth, The Death of Hellscream | Yes (Mannoroth) | Yes. "Classic only", removed 4.0.3a | "Mannoroth the Destructor is no more. Let these plates always remind us…" – https://www.wowhead.com/classic/object=175658 ; https://warcraft.wiki.gg/wiki/The_Armor_of_Mannoroth |
| **Here Lies King Terenas Menethil II** | see List 1 | – | – | 175659 | Terenas | WC3 Human: The Warning | Yes | Yes | see above |
| **Uther the Lightbringer** | see List 1 | – | – | 2082 | Uther | WC3 Human/Undead | Yes | Yes | see above |
| **Arthas' Tears** | Herb node | Western/Eastern Plaguelands, Felwood | WPL 30.3, 60.4 | 142141, 176642 | Arthas Menethil (not in Data.lua) | WC3 Human: The Culling, Frostmourne… Undead: The Siege of Dalaran… TFT Undead | Name only | Yes. Removed in 6.0.2 | "Arthas' Tears is named after Arthas Menethil." – https://warcraft.wiki.gg/wiki/Arthas%27_Tears ; https://www.wowhead.com/classic/object=142141 |

### Story books (readable objects that tell the RTS stories)

These are classic "History of Warcraft" bookshelf objects (type 9). They are not memorials, but they are clickable objects whose text names the RTS characters and retells the games. RTS characters below were found by text search in each book's Classic text.

| Book (object name) | ID | Locations (Wowhead Classic) | RTS characters named in text | Covers |
|---|---|---|---|---|
| The Last Guardian | 175740 | Loch Modan 37.2,47.0; Westfall 52.5,53.1 | Medivh, Llane, Lothar | WC1 background |
| Rise of the Horde | 175742 | Swamp of Sorrows 47.9,54.9; Durotar 59.6,58.2; Ironforge 77.1,13.0 | Gul'dan, Blackhand, Orgrim Doomhammer, Grom, Mannoroth | pre-WC1 |
| The Dark Portal and the Fall of Stormwind | 175745 | Blasted Lands 66.8,18.4; Swamp of Sorrows 47.8,55.0; Redridge 26.8,45.8 | Medivh, Llane, Lothar, Garona, Gul'dan, Blackhand, Doomhammer, Khadgar | WC1 |
| The Alliance of Lordaeron | 175746 | Dun Morogh 47.6,52.0; Duskwood 72.1,47.9; Hillsbrad 63.7,20.8; Stormwind 73.0,9.6; Ironforge 76.9,12.2 | Lothar, Gul'dan, Doomhammer, Turalyon, Uther, Khadgar, Daelin Proudmoore | WC2 |
| The Invasion of Draenor | 175747 | Scholomance (no coords) | Terenas, Turalyon, Khadgar, Alleria, Kurdran, Danath, Ner'zhul, Kilrogg, Grom | BTDP |
| Beyond the Dark Portal | 21582 | Blasted Lands 65.2,22.8; STV 26.9,77.3; Arathi 22.6,24.0; Stormwind 73.2,6.2 | Terenas, Turalyon, Khadgar, Alleria, Kurdran, Danath, Ner'zhul | BTDP |
| Aftermath of the Second War | 21581 | Blasted Lands 64.3,15.5; Arathi 22.6,24.0; Stormwind 73.0,9.4; Darnassus 55.4,13.0 | Lothar, Doomhammer, Turalyon, Uther, Daelin | post-WC2 |
| The New Horde | 175752 | Swamp of Sorrows 47.8,55.0; Barrens 61.9,54.9; Stormwind 72.5,9.6 | Gul'dan, Doomhammer, Thrall, Grom | WC3 prologue |
| The Alliance Splinters | 175755 | Blackrock Depths | Terenas, Daelin, Antonidas | WC3 background |
| The Scourge of Lordaeron | 175756 | STV 27.7,77.1; Westfall 56.9,47.4; Ashenvale 34.8,49.8 | Terenas, Uther, Arthas, Kel'Thuzad | WC3 |
| Sunwell - The Fall of Quel'Thalas | 175757 | STV 27.1,77.7; Ashenvale 34.5,50.0 | Arthas, Kel'Thuzad, Sylvanas | WC3 |
| Kel'Thuzad and the Forming of the Scourge | 175754 | Hillsbrad 51.7,58.5; Undercity 56.0,51.1 | Kel'Thuzad, Ner'zhul | WC3 |
| Archimonde's Return and the Flight to Kalimdor | 175758 | Barrens 62.4,38.7; Desolace 66.3,7.7 | Medivh, Arthas, Thrall, Grom, Cairne, Archimonde, Illidan, Malfurion, Tyrande, Cenarius, Mannoroth | WC3 |
| The Betrayer Ascendant | 175759 | Darnassus 66.5,76.6 | Illidan, Maiev, Malfurion, Tyrande, Archimonde | TFT |
| Rise of the Blood Elves | 175760 | Elwynn 64.6,69.4; Arathi 74.1,32.3; Darnassus 49.2,16.8 | Kael'thas, Illidan, Maiev | TFT |
| Civil War in the Plaguelands | 175761 | Elwynn 49.5,39.6; Hillsbrad 51.3,58.4; Undercity 67.7,37.4; Stormwind 73.2,10.0; Ironforge 76.8,12.3 | Arthas, Kel'Thuzad, Illidan, Sylvanas | TFT |
| The Lich King Triumphant | 175762 | Stratholme / Scholomance | Arthas, Kel'Thuzad, Illidan, Sylvanas | TFT |
| Old Hatreds - The Colonization of Kalimdor | 175763 | Tanaris 51.0,29.4 | Daelin, Jaina, Thrall, Arthas | TFT |

(The Birth of the Lich King 175748 and Icecrown and the Frozen Throne 175749 also exist in Classic, but they name only Ner'zhul and Tichondrius. The Battle of Grim Batol 175750 is post-WC2 novel material.)

## ACCEPT (confirmed)

**List 1, A-grade: the object's name or text names the character (11 objects).**
1. Uther the Lightbringer plaque, Uther's Tomb (2082): Uther, WC2
2. Here Lies King Terenas Menethil II (175659): Terenas, WC2
3. Trollbane's Tomb (2703): Thoras Trollbane, WC2
4. King Llane I of the House of Wrynn (177200): Llane, WC1
5. Grand Admiral Daelin Proudmoore (177201): Daelin, WC2/BTDP
6. General Turalyon (25330): WC2/BTDP
7. Archmage Khadgar of the Kirin Tor (25333): BTDP
8. Ranger Captain Alleria Windrunner (25331): BTDP
9. Danath Trollbane (25332): BTDP
10. Kurdran Wildhammer (25329): BTDP
11. Monument to Grom Hellscream (21004): Grom, BTDP (and WC3)

**List 1, B-grade: named after them, or depicts them without naming them (3).**
12. Khadgar's Whisker herb (2043): Khadgar
13. Orgrimmar (city name): Orgrim Doomhammer
14. Statue of Anduin Lothar, Burning Steppes: physical depiction only, no in-game name. Classic existence is supported but should be checked in game.

**List 2 (WC3/TFT only, not in Data.lua): 2 new + 3 shared.**
- A: The Armor of Mannoroth (175658): Mannoroth
- B: Arthas' Tears herb (142141/176642): Arthas
- Shared with List 1: Grom monument, Uther plaque, Terenas plaque

**Story books:** the 18 History of Warcraft objects above (optional extra layer).

## REJECT

| Candidate | Reason |
|---|---|
| Lion's Rest / Lothar memorial in Stormwind | Added 7.0.3 (wiki). Not in the Wowhead Classic DB |
| Tomb of Sir Anduin Lothar | No such object or place in Classic (no Wowhead Classic hit for "Lothar" other than the Lotus) |
| Valley of Heroes as it looks after Cataclysm (Deathwing damage, Wick/Goldgild) | 4.0.3a and later. The **Classic** plaques are accepted above |
| Orgrim Doomhammer's grave | No Classic object (searched "Doomhammer", "Grave", "Monument"). The First War memorial "Heroes' Vigil" is Cataclysm |
| Hall of Blackhand (UBRS/LBRS) | The wiki gives no "named after Blackhand the Destroyer" source, and the name could equally point to Rend's family (Black Tooth Grin). Too speculative |
| Karazhan (Deadwind Pass) | Medivh's tower, but not named after him. No Classic object or text names Medivh. The instance is TBC |
| Grim Batol, Dun Modr, Caer Darrow, Dalaran crater, Altar of Storms, the Dark Portal, Durnholde Keep, internment camps | RTS mission locations, but no character is commemorated or named there in Classic. Durnholde's Blackmoore is not an RTS character |
| Alterac / Perenolde | No Classic object naming Aiden Perenolde. Aliden is already in Data.lua |
| Rock of Durotan (179909, Alterac Valley, 1.5.0) | Real grave plaque, but Durotan is not a character in any of the RTS games |
| Lady Mara Fordragon (177202), Archbishop Alonsus Faol (177199) | Classic plaques, but Mara is not in the games. Faol is only a briefing mention (WC2 H9) |
| Gromsblood herb | Wiki: "may be named after Grom Hellscream". Speculation |
| Grom'gol Base Camp | No source that it is named after Grom |
| Hammerfall (Orgrim) and Kargath (Kargath Bladefist, BTDP Orc hero) | Wiki claims "named in honor of", but **without a citation**. Kept as POSSIBLE, not accepted |
| Menethil Harbor (Terenas) | Wiki naming claim has no citation, and the name is the family name. POSSIBLE |
| Grommash Hold (Grom) | Named after Grom (wiki), but in Classic the hold was signposted "Thrall's Fortress". Classic subzone name not confirmed. POSSIBLE, check in game |
| Menethil's Gift (176631, Stratholme) | Scourge "holy ground" blessed by the Lich King. Not a memorial to Terenas or Arthas |
| Uther's Tribute / Grom's Tribute | Harvest Festival only (event) |
| Monument to Grom Hellscream 454487, Spear of Mannoroth 409311 | Season of Discovery objects, not original Classic |
| Ghost of Uther at the tomb | TBC (paladin quest) |
| Ashkandi, Khadgar's Unlocking, Gift of Arthas | Items and spells, not world objects |

## Sources (main)

- https://www.wowhead.com/classic/object=2082, =175659, =2703, =177200, =177201, =177199, =177202, =25329 … =25333, =21004, =175658, =2043, =142141, =176642, =178125, =179909, and the book IDs listed above
- https://warcraft.wiki.gg/wiki/Uther%27s_Tomb, /Valley_of_Heroes, /Royal_Gallery, /Trollbane%27s_Tomb, /Trol%27kalar_(Classic), /Trol%27kalar_(2), /Trollbane_(quest), /Monument_to_Grom_Hellscream, /The_Armor_of_Mannoroth, /Terenas_Menethil_II, /Black_Tooth_Hovel, /Lotharian_Lotus, /Orgrimmar, /Hammerfall, /Kargath, /Menethil_Harbor, /Grommash_Hold, /Khadgar%27s_Whisker, /Arthas%27_Tears, /Gromsblood, /Rock_of_Durotan, /Lion%27s_Rest, /Warcraft_II:_Beyond_the_Dark_Portal_missions, /Warcraft_II:_Tides_of_Darkness_missions, /Warcraft:_Orcs_%26_Humans_missions

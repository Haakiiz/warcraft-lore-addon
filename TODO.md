# Zone checklist

Every zone in World of Warcraft: Forever. A ticked zone has been checked NPC by NPC
(Wowhead Classic NPC list → warcraft.wiki.gg scan → mission backlinks → manual verification).
"Leads" are characters we already know appear in the RTS games, found while checking other zones. They are not verified for that zone yet.

## Done

- [x] Orgrimmar – 3 NPCs (Thrall, Nazgrel, Vol'jin; Grunt Maug was removed in 9023636); Kiro rejected (namesake of the vulpera leader)
- [x] The Barrens – 8 NPCs (Gazlowe, Apothecary Helbrim*; books: Jorn Skyseer, Wharfmaster Dizzywig, Innkeeper Wiley, Cannoneer Smythe, Cannoneer Whessan, Jazzik)
- [x] Undercity – 5 NPCs (Sylvanas, Varimathras, Sharlindra, Apothecary Keever, Lexington Mortaim*)
- [x] Silverpine Forest – 2 NPCs (Dalar Dawnweaver, Snarlmane*)
- [x] Stonetalon Mountains – 3 NPCs (Rexxar, Misha, Witch Doctor Jin'Zil*)

\* = confidence "uncertain"

## New in Forever

2026-11-06 rough pass after launch (10 Haiku workers, source: warcraft.wiki.gg "Forever NPCs"/"Forever mobs" categories,
550 pages, plus every character page that links to a Forever zone, instance or subzone; Wowhead blocks scripted access).
A rough pass, not NPC-by-NPC: the wiki was still filling in. Added: The Baron (= Othmar Garithos), Glix Xizzix, Image of Archmage Modera.

- [~] Mount Hyjal (Renewed): 0 hits (65 NPCs + 17 named bosses, all Forever-only)
- [x] Shen'dralas: Mordent Evenshade (*Wolfheart*) added (253471)
- [~] Riverglades: 0 hits (Cho'gall and Gul'dan are only mentioned, not NPCs)
- [~] Zephras Isle: 0 hits in 134 NPCs
- [~] City of Dalaran / Dalaran: Image of Archmage Modera added (Silverpine, outside the walls). Archmage Modera herself added (246748 + 276235)
- [~] Ruins of Lordaeron: The Baron added (no coords: instance)
- [x] Muln Earthfury added (253957 + 256620, 259118)
- [x] Leonid Barthalomew: Forever ID 267008 added as foreverIDs, alsoIn Tirisfal Glades
- [x] Archmage Ansirem Runeweaver: Forever IDs 253958, 256621, alsoIn Dalaran

2026-11-07 full pass: every NPC in the Forever 1.60.1 datamine (User:Mordecay/Forever/NPCs, 2 318 names with IDs),
the Forever categories and every page using the Forever templates: 4 880 names, 407 candidates, 12 Haiku screeners,
4 Sonnet verifiers. Added Mordent, Muln, Modera, Lariia, Dalar Dawnweaver; foreverIDs for Leonid and Ansirem.
Re-run with `tools/research/forever_scan.py` (only new wiki names + the watch list are checked).
Watch list (`tools/research/forever_watch.json`): book namesakes in the datamine with no Forever location yet:
Windle Sparkshine, Perith Stormhoof, Randal, Bluebell, Tiala Whitemane, Goldrinn.

2026-11-07 reverse check and memorials: every RTS/book character NAMED in Forever quests, Forever NPC pages and
Forever sections (247 characters; `tools/research/forever_mentions.py`) and 34 Forever object pages. Added Doctor
Gustaf VanHowzen (Tides of War). Almost all names are only mentioned (Arthas, Illidan, Sargeras ...).
- [ ] Agatha and Aradne (val'kyr in Deathknell, novel *Sylvanas*): meetable, but no NPC ID on the wiki yet
- [ ] Memorial lead: library book "Archmage Antonidas: The Unabridged Autobiography" in Ironforge (object 386691),
      tagged Season of Discovery only; check whether Forever has it
- Not counted: *World of Warcraft: Shaman* is a manga (Krelna, Shotoa)

2026-11-08 Warcraft III: Reforged pass: all 10 Forsaken Kingdom missions read in full (12 Haiku readers, 3 Sonnet
verifiers), plus every "Reforged" note in the 93 Reign of Chaos / Frozen Throne missions. Added 10 veterans (see
CHANGELOG). Rejected: Uther (only a Shadowlands NPC ID; the tomb memorial stays), Sedrick Calston (Cataclysm ID),
Melisara (no NPC ID on the wiki), Horace Alder (added in 2.4.2), Garek Bandarion and Dark Ranger Anya (no NPC in
the classic era or Forever), the Homecoming villagers (names from WC3 map makers, not the WoW NPCs).
Sylvanas and Varimathras in War of the Damned: the mission page lists them without saying what they do, so no new
appearance was added.

- Not included (Håkon, 2026-11-06): characters who only appear in the Forever audio short story *Unbowed* (Cormack, Danitha Morr, Arec Mistmantle)

2026-10-29 launch health check: all classic NPC IDs were found on wowhead.com/forever with the same names (.kritikk/FOREVER/forever_id_check.md on the session/release-qa branch); the first Forever-zone veterans are also on that branch, not yet on main.

Forever zone NPCs are not on Wowhead Classic. Their NPC IDs must come from the game (`/wcl id`) or from Forever databases once they exist.

2026-10-08 (evening): the 24 zones and dungeons up to level 30 were redone with Haiku workers + critics (brief v3):
21 new NPCs and 28 new book appearances in existing entries. See .kritikk/LESSONS_LEARNED.md.

2026-10-08: level cap is 30 in Forever. All zones up to level 30 are done; Orgrimmar, Durotar, Undercity, Tirisfal, Silverpine,
Thunder Bluff, Mulgore, The Barrens, Ashenvale, Darkshore, Teldrassil, Stonetalon and Hillsbrad were rescanned for book links.

## Kalimdor

- [x] Durotar – 2 NPCs (Gar'Thok; Master Gadrin, book)
- [x] Mulgore – 1 NPC (Baine Bloodhoof)
- [x] Thunder Bluff – 1 NPC (Cairne Bloodhoof) + 3 Skychasers from The Shattering (Beram, Siln, Tigor)
- [x] Teldrassil – 0 NPCs
- [x] Darnassus – 2 NPCs (Tyrande Whisperwind, Arch Druid Fandral Staghelm – book only)
- [x] Darkshore – 1 NPC (Athrikus Narassin)
- [x] Ashenvale – 0 NPCs (8 Season of Discovery name matches dropped)
- [x] Thousand Needles – 7 NPCs, all books (Traveler: The Spiral Path; Pozzik, Thalia Amberhide* added in round 3)
- [x] Desolace – 0 new (Rexxar and Misha wander here; same NPC IDs as in Stonetalon)
- [x] Dustwallow Marsh – 8 NPCs (Jaina, Tervosh*, Brother Karman*, Torq Ironblast*, Draz'Zilb, Tharg, Do'gol, Ogg'marr); Mok'Morokk rejected (link is book-only)
- [x] Feralas – 1 NPC (Shandris Feathermoon); Rexxar and Misha also wander here
- [x] Tanaris – 6 NPCs (Anachronos, Chronalis, Tick, Marin Noggenfogger, Sprinkle, Trenton Lighthammer)
- [x] Azshara – 0 NPCs
- [x] Felwood – 1 NPC (Arei)
- [x] Un'Goro Crater – 0 NPCs
- [x] Moonglade – 1 NPC (Keeper Remulos)
- [x] Winterspring – 2 NPCs (Gogo, Lunnix Sprocketslip)
- [x] Silithus – 0 NPCs (its three dragons are listed under Temple of Ahn'Qiraj)

## Eastern Kingdoms

- [x] Tirisfal Glades – 1 NPC (Gordo)
- [x] Dun Morogh – 0 NPCs
- [x] Ironforge – 11 NPCs, all books (Magni, Mekkatorque, Rohan, Bink, Dink, Reyna Stonebranch, Gryth Thurden, Advisor Belgrum, High Explorer Magellas, Daryl Riknussun, Huntress Swiftriver)
- [x] Elwynn Forest – 3 NPCs, all books
- [x] Stormwind City – 17 NPCs, all books (Anduin, Bolvar, Katrana, Shaw, Renzik …); Aedis Brom/Christoph Faral rejected
- [x] Westfall – 0 NPCs
- [x] Loch Modan – 1 NPC (Vyrin Swiftwind, book)
- [x] Redridge Mountains – 1 NPC (Magistrate Solomon, book)
- [x] Duskwood – 3 NPCs (Terror by Torchlight)
- [x] Wetlands – 2 NPCs (Korialstrasz and Krasus, Season of Discovery NPCs at Grim Batol; Day of the Dragon)
- [x] Hillsbrad Foothills – 0 NPCs
- [x] Alterac Mountains – 2 NPCs (Mug'thol, Archmage Ansirem Runeweaver*)
- [x] Arathi Highlands – 0 NPCs (Galen Trollbane and Adegwa removed in v0.6.1: book link unconfirmed)
- [x] Stranglethorn Vale – 4 NPCs (Catelyn the Blade, Fleet Master Seahorn, Innkeeper Skindle, Ironpatch)
- [x] Badlands – 0 NPCs
- [x] Swamp of Sorrows – 0 NPCs
- [x] The Hinterlands – 2 NPCs (Falstad Wildhammer, Shadra; Rothos removed in v0.6.1)
- [x] Searing Gorge – 0 NPCs
- [x] Burning Steppes – 0 NPCs
- [x] Blasted Lands – 0 NPCs
- [x] Deadwind Pass – 0 NPCs
- [x] Western Plaguelands – 1 NPC (Araj the Summoner*); Uther and Gregory (Season of Discovery IDs) were removed in 9023636 as NPCs Forever players cannot meet
- [x] Eastern Plaguelands – 8 NPCs (Tirion Fordring, Nathanos Blightcaller, Lord Maxwell Tyrosus, Leonid Barthalomew the Revered, Craftsman Wilhelm, Aurora Skycaller, Mirador, Ranger Lord Hawkspear)

## Battlegrounds, dungeons and raids (optional)

- [x] Alterac Valley – 2 NPCs (Drek'Thar, Renferal) (2026-10-24)
- [x] Warsong Gulch, Arathi Basin – 0 NPCs (2026-10-24)
- [x] Dungeons up to level 30 – Naralex, VanCleef*, Arugal*, Mograine + Whitemane (FK: A Scarlet Flame), Thermaplugg, Charlga; round 3: Baron Silverlaine*, Highlord Mograine* (SoD ID)
- [x] Zul'Farrak – 1 NPC (Chief Ukorz Sandscalp)
- [x] Sunken Temple – 2 NPCs (Malfurion Stormrage, Shade of Eranikus)
- [x] Temple of Ahn'Qiraj – 3 NPCs (Arygos, Caelestrasz, Merithra of the Dream)
- [x] Uldaman – 0 NPCs
- [x] Maraudon – 0 NPCs
- [x] Other higher dungeons and raids (2026-10-24, worker + critic): BRS (Rend, Nefarius), BRD (Moira), BWL (Nefarian), Onyxia's Lair (Onyxia), Scholomance (Ras Frostwhisper), Stratholme (Rivendare, Balnazzar, Dathrohan, Barthilas), Naxxramas (Kel'Thuzad, Sapphiron, Sir Zeliek), AQ20 (Rajaxx); 0 in MC, ZG, Dire Maul (King Gordok rejected: title). Rejected: Ramstein (forces list only), Dagran Thaurissan, Ragnaros, Gandling.
- [ ] Forever: Krol'Dok Stronghold (Riverglades), the new Dalaran dungeon, Hyjal Summit, Barrow Deeps (Mount Hyjal)

## Addon follow-ups

- [x] **Signal when a Warcraft veteran is nearby** (on-screen toast + center text + `/wcl test` added 2026-10-05, not tested in game; done 2026-10-04: nameplate-based chat line + sound, `/wcl alert`; coordinate-based variant also done 2026-10-04: 2 s ticker, 3% radius, shared once-per-session dedupe, skipped in instances) (requested 2026-10-03): give a small heads-up (sound, chat line or a little icon/toast) when an NPC from the database is close, so the player knows someone is worth clicking on. Ideas to evaluate:
  - Nameplates: listen for `NAME_PLATE_UNIT_ADDED`, read `UnitGUID("nameplateN")` → NPC ID → database. Only works when nameplates are shown (friendly NPC nameplates may need to be enabled), and GUIDs may be secret values in some situations on Midnight-based clients. Goes in Compat.lua.
  - Distance from known coordinates: compare the player's map position (`C_Map.GetPlayerMapPosition`) with `coords` in Data.lua for the current zone. Works without nameplates, but only for NPCs with coordinates and outside instances.
  - Show each NPC only once per session, add a `/wcl alert` on/off toggle, and maybe mark the NPC with a raid-target-style icon or a line pointing in its direction.

- [x] Book/novel source code `BOOK` added (Data.lua docs, validator, UI). - [x] Re-checked (2026-10-04, added as BOOK entries): earlier "novel only" rejects: Mok'Morokk (Exploring Azeroth), Marcus Redpath (Tides of Darkness), Aliden Perenolde (Beyond the Dark Portal, Day of the Dragon), Pained (Tides of War), and the Cycle of Hatred details for Nazgrel.

- [x] Allow more than one zone per NPC (`alsoIn` field; Rexxar/Misha)
- [x] Check in game whether Grunt Maug exists in Forever (moot: the entry was removed in 9023636)
- [x] Gazlowe's Charm removed (name-only link)
- [ ] Confirm in game that the new frame looks right (vines tiled, round portrait)
- [ ] Test `/wcl list` in game: layout, search box typing/Esc, mouse wheel over rows, zone/campaign popups
- [ ] Check in game that toast textures now show (2026-10-09: fixed `"Interface\AddOns"` single-backslash paths in Toast.lua, which Lua 5.1 turns into `InterfaceAddOns`)

### From competitor research (2026-10-08)

No other addon links NPCs to the RTS games or novels. Closest are LoreCompanion (Classic) and NPCodex (Retail), both small. Priority order:

- [x] **Veterans met:** remember which veterans the player has met, show a counter per game (e.g. "WC3: 12/40") and list the ones still missing. Builds on the nearby alert. (done 2026-10-09, not tested in game; met = targeted or moused over, stored per character in `WarcraftLoreCharDB`)
- [x] **Browse and search window:** list the whole database, filter by game, campaign and zone, search by name. Clicking an entry opens its lore window. (done 2026-10-09, not tested in game; `/wcl list`, merged with the met counter)
- [ ] **In-game test: alert pill.** Check the glow and its slow pulse, the pill appears for a nearby veteran and when you target one, click opens the lore window, right-click dismisses, shift-drag moves the stack and the spot is remembered, the portrait shows (unit portrait, or the question mark fallback), and up to 3 pills stack with room for the glow.
- [ ] **In-game test: minimap button.** Check the book icon exists (else the question mark shows), it sits on the minimap edge, drag moves it and the spot is remembered, left-click toggles the Veterans list, right-click opens your target's story, the tooltip shows the live met count, and `/wcl minimap` hides and shows it.
- [x] **Related NPCs:** link characters to each other (e.g. Thrall → Grom → Nazgrel) so players can follow a lore thread. (done in v0.4)
- [ ] **Localization and wider client support:** German and French done in v0.7; Classic Era and Retail builds are now milestone 3 in ROADMAP.md.
- [ ] **In-game test: Warcraft II theme (v0.8).** Check every window in both themes and that the switch button swaps them without a reload.

- [x] 2026-10-24 release QA: every veteran and memorial re-checked by Sonnet workers (.kritikk/QA_release/); Mok'Morokk removed (guidebook only). Håkon 2026-10-24: event NPCs (Swiftriver) and cinematics are included; Morbent Fel stays.
- [ ] In-game test: History of Warcraft books (v0.9). Read one, check the visit counts, the book icon, the pins on every copy, and Student of History.

See ROADMAP.md for the plan towards 1000 downloads.

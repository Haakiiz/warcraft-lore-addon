# Zone checklist

Every zone in World of Warcraft: Forever. A ticked zone has been checked NPC by NPC
(Wowhead Classic NPC list → warcraft.wiki.gg scan → mission backlinks → manual verification).
"Leads" are characters we already know appear in the RTS games, found while checking other zones. They are not verified for that zone yet.

## Done

- [x] Orgrimmar – 4 NPCs (Thrall, Nazgrel, Vol'jin, Grunt Maug)
- [x] The Barrens – 2 NPCs (Gazlowe, Apothecary Helbrim*)
- [x] Undercity – 5 NPCs (Sylvanas, Varimathras, Sharlindra, Apothecary Keever, Lexington Mortaim*)
- [x] Silverpine Forest – 2 NPCs (Dalar Dawnweaver, Snarlmane*)
- [x] Stonetalon Mountains – 3 NPCs (Rexxar, Misha, Witch Doctor Jin'Zil*)

\* = confidence "uncertain"

## New in Forever

- [ ] Mount Hyjal (Renewed): set after Archimonde's defeat, so it is a likely hotspot for Warcraft III characters
- [ ] Shen'dralas (Kalimdor, between Mulgore and Desolace)
- [ ] Riverglades (Eastern Kingdoms, east coast)
- [ ] Zephras Isle (Skyborne starting area)
- [ ] City of Dalaran (returning/reworked); the setting of several Warcraft II and III missions

Forever zone NPCs are not on Wowhead Classic. Their NPC IDs must come from the game (`/wcl id`) or from Forever databases once they exist.

2026-10-08: level cap is 30 in Forever. All zones up to level 30 are done; Orgrimmar, Durotar, Undercity, Tirisfal, Silverpine,
Thunder Bluff, Mulgore, The Barrens, Ashenvale, Darkshore, Teldrassil, Stonetalon and Hillsbrad were rescanned for book links.

## Kalimdor

- [x] Durotar – 1 NPC (Gar'Thok)
- [x] Mulgore – 1 NPC (Baine Bloodhoof)
- [x] Thunder Bluff – 1 NPC (Cairne Bloodhoof)
- [x] Teldrassil – 0 NPCs
- [x] Darnassus – 2 NPCs (Tyrande Whisperwind, Arch Druid Fandral Staghelm – book only)
- [x] Darkshore – 1 NPC (Athrikus Narassin)
- [x] Ashenvale – 0 NPCs (8 Season of Discovery name matches dropped)
- [x] Thousand Needles – 5 NPCs, all books (Traveler: The Spiral Path)
- [x] Desolace – 0 new (Rexxar and Misha wander here; same NPC IDs as in Stonetalon)
- [x] Dustwallow Marsh – 8 NPCs (Jaina, Tervosh*, Brother Karman*, Torq Ironblast*, Draz'Zilb, Tharg, Do'gol, Ogg'marr); Mok'Morokk rejected (link is book-only)
- [x] Feralas – 1 NPC (Shandris Feathermoon); Rexxar and Misha also wander here
- [ ] Tanaris
- [ ] Azshara
- [ ] Felwood
- [ ] Un'Goro Crater
- [ ] Moonglade
- [ ] Winterspring
- [ ] Silithus

## Eastern Kingdoms

- [x] Tirisfal Glades – 1 NPC (Gordo)
- [x] Dun Morogh – 0 NPCs
- [x] Ironforge – 6 NPCs, all books (Magni, Mekkatorque, Rohan, Bink, Dink, Reyna Stonebranch)
- [x] Elwynn Forest – 3 NPCs, all books
- [x] Stormwind City – 17 NPCs, all books (Anduin, Bolvar, Katrana, Shaw, Renzik …); Aedis Brom/Christoph Faral rejected
- [x] Westfall – 0 NPCs
- [x] Loch Modan – 1 NPC (Vyrin Swiftwind, book)
- [x] Redridge Mountains – 1 NPC (Magistrate Solomon, book)
- [x] Duskwood – 3 NPCs (Terror by Torchlight)
- [x] Wetlands – 0 NPCs (Korialstrasz/Krasus SoD NPCs rejected: name only)
- [x] Hillsbrad Foothills – 0 NPCs
- [x] Alterac Mountains – 2 NPCs (Mug'thol, Archmage Ansirem Runeweaver*)
- [ ] Arathi Highlands
- [ ] Stranglethorn Vale
- [ ] Badlands
- [ ] Swamp of Sorrows
- [ ] The Hinterlands
- [ ] Searing Gorge
- [ ] Burning Steppes
- [ ] Blasted Lands
- [ ] Deadwind Pass
- [x] Western Plaguelands – 4 NPCs (Uther, Gregory ×2, Araj the Summoner*); Uther and Gregory use Season of Discovery IDs
- [ ] Eastern Plaguelands

## Battlegrounds, dungeons and raids (optional)

- [ ] Alterac Valley – lead: Drek'Thar (quest giver in "To Tame a Land")
- [ ] Warsong Gulch, Arathi Basin
- [x] Dungeons up to level 30 – Naralex, VanCleef*, Arugal*, Mograine + Whitemane (FK: A Scarlet Flame), Thermaplugg, Charlga
- [ ] Higher dungeons and raids
- [ ] Forever: Krol'Dok Stronghold (Riverglades), the new Dalaran dungeon, Hyjal Summit, Barrow Deeps (Mount Hyjal)

## Addon follow-ups

- [x] **Signal when a Warcraft veteran is nearby** (on-screen toast + center text + `/wcl test` added 2026-10-05, not tested in game; done 2026-10-04: nameplate-based chat line + sound, `/wcl alert`; coordinate-based variant also done 2026-10-04: 2 s ticker, 3% radius, shared once-per-session dedupe, skipped in instances) (requested 2026-10-03): give a small heads-up (sound, chat line or a little icon/toast) when an NPC from the database is close, so the player knows someone is worth clicking on. Ideas to evaluate:
  - Nameplates: listen for `NAME_PLATE_UNIT_ADDED`, read `UnitGUID("nameplateN")` → NPC ID → database. Only works when nameplates are shown (friendly NPC nameplates may need to be enabled), and GUIDs may be secret values in some situations on Midnight-based clients. Goes in Compat.lua.
  - Distance from known coordinates: compare the player's map position (`C_Map.GetPlayerMapPosition`) with `coords` in Data.lua for the current zone. Works without nameplates, but only for NPCs with coordinates and outside instances.
  - Show each NPC only once per session, add a `/wcl alert` on/off toggle, and maybe mark the NPC with a raid-target-style icon or a line pointing in its direction.

- [x] Book/novel source code `BOOK` added (Data.lua docs, validator, UI). - [x] Re-checked (2026-10-04, added as BOOK entries): earlier "novel only" rejects: Mok'Morokk (Exploring Azeroth), Marcus Redpath (Tides of Darkness), Aliden Perenolde (Beyond the Dark Portal, Day of the Dragon), Pained (Tides of War), and the Cycle of Hatred details for Nazgrel.

- [x] Allow more than one zone per NPC (`alsoIn` field; Rexxar/Misha)
- [ ] Check in game whether Grunt Maug exists in Forever
- [x] Gazlowe's Charm removed (name-only link)
- [ ] Confirm in game that the new frame looks right (vines tiled, round portrait)

### From competitor research (2026-10-08)

No other addon links NPCs to the RTS games or novels. Closest are LoreCompanion (Classic) and NPCodex (Retail), both small. Priority order:

- [ ] **Veterans met:** remember which veterans the player has met, show a counter per game (e.g. "WC3: 12/40") and list the ones still missing. Builds on the nearby alert.
- [ ] **Browse and search window:** list the whole database, filter by game, campaign and zone, search by name. Clicking an entry opens its lore window.
- [ ] **Related NPCs:** link characters to each other (e.g. Thrall → Grom → Nazgrel) so players can follow a lore thread.
- [ ] **Localization and wider client support:** translations, plus Classic Era and Retail builds alongside Forever.

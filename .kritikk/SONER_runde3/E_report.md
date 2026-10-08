# Group E report: Ashenvale (331), Stonetalon Mountains (406), Blackfathom Deeps (719)

Result: 0 ACCEPT, 0 new entries. Candidates decided: 40 (33 non-DL, all REJECT; 7 already in Data.lua, skipped).

## Counts

| Zone | NPCs (npcs_*.json) | Candidates | Already in Data.lua | Non-DL candidates decided |
|---|---|---|---|---|
| Blackfathom Deeps (719) | 68 | 3 | 0 | 3, all REJECT |
| Stonetalon Mountains (406) | 132 | 12 | 3 (Witch Doctor Jin'Zil, Rexxar, Misha) | 9, all REJECT |
| Ashenvale (331) | 319 | 25 | 4 (Shael'dryn, Illiyana Moonblaze, Lethon, Emeriss) | 21, all REJECT |

## ACCEPT

None.

## REJECT table (name | reason with quoted line)

Quotes are from the cached wiki text with link markup removed.

### Blackfathom Deeps (719)

| Name (ID) | Reason |
|---|---|
| Aku'mai (4829) | Creature, not a character. Sources are guide only: "a three-headed hydra ... that has taken up residence within the Blackfathom Deeps"; cites Exploring Azeroth: Kalimdor pg. 73 (guide). |
| Old Serra'kis (4830) | Creature (thresher). Sources are guides: cites Exploring Azeroth: Kalimdor pg. 74 and "Adventure Guide". No book Characters hit. |
| Twilight Lord Kelris (4832) | Cites Exploring Azeroth: Kalimdor pg. 73 and "Twilight Lord Bathiel#Adventure Guide" (guide-only). No book Characters hit. |

### Stonetalon Mountains (406)

| Name (ID) | Reason |
|---|---|
| Rabbit (721) | Generic critter: "A rabbit is a small, fluffy critter". |
| Deer (883) | Generic critter: "Deer appear as critters in Warcraft III: Reign of Chaos." Unit type, not a character. |
| Twilight Runner (4067) | Generic nightsaber type. Its page cites Traveler: The Shining Blade ch. 9 for an unnamed creature: "a young twilight runner chased Aramar Thorne and Taryndrella". Open question (see below). |
| Braelyn Firehand (4198) | Source is Lands of Mystery pg. 45 (guide). No novel or RTS hit. |
| Spirit Healer (6491) | Generic NPC type (its only source is the WoW Official Strategy Guide and Shadowlands lore). |
| Grundig Darkcloud (11858) | Source is the Horde Player's Guide pg. 164 (RPG guide) and Grimtotem Chiefs. No novel or RTS hit. |
| Maggran Earthbinder (11860) | No identity line: "As such Maggran may have been killed during the assault on Sun Rock". Speculation. 0 book hits. |
| Mor'rogal (11861) | No identity line: "As such Mor'rogal may have been killed during the assault on Sun Rock". 0 book hits. |
| Tammra Windfield (11864) | No identity line: "As such, Tammra may have been killed during the assault". Her only book hit is the Earth Mother page citing Cycle of Rebirth (quest, not cached). |

### Ashenvale (331)

| Name (ID) | Reason |
|---|---|
| Deer (883) | Generic critter (see 406). |
| Voidwalker (1860) | Generic demon type: "Voidwalkers first appeared in Warcraft III: The Frozen Throne as a type of Outland creep". |
| Delgren the Purifier (3663) | Source is Lands of Mystery pg. 8 (guide): "Delgren the Purifier is a Knight of the Silver Hand. Lands of Mystery, pg. 8". 0 novel hits. |
| Ilkrud Magthrull (3664) | Source is Lands of Mystery pg. 8 (guide): "In a non-canonical book, he had an extra l (Illkrud)". 0 novel hits. |
| Wildthorn Stalker (3819) | Generic tarantula: "Wildthorn Stalkers are tarantulas found near Astranaar". |
| Befouled Water Elemental (3917) | Generic elemental type: "Befouled water elementals" from the Mystral Lake event; no character. |
| Force of Nature (4795) | Ability name, not a character. Trivia cites the WC3 Keeper of the Grove ability and Hearthstone. |
| Felguard (6115) | Unit type: "A felguard in Warcraft III: The Frozen Throne". Not a named character. |
| Spirit Healer (6491) | Generic NPC type (see 406). |
| Sharptalon (12676) | Source is World of Warcraft: The Comic (comic, excluded). 0 novel hits. |
| Je'neu Sancrea (12736) | Source is Dark Factions pg. 149. Dark Factions is a WoW RPG sourcebook ("Dark Factions is a sourcebook for the World of Warcraft RPG"). 0 novel hits. |
| Doan Karhan (232924) | Cited line concerns the fort, not Doan: "Northwatch Hold and Fort Triumph destroyed by the Horde, leaving Doan's whereabouts unknown" (Jaina Proudmoore: Tides of War). Doan is not in that book's Characters section. 0 hits. |
| Larodar (212707) | SoD WC3 random hero: "Larodar was a random hero in Warcraft III". Random-hero policy (see open questions). |
| Tojara (212730) | SoD WC3 random hero: "Tojara was a random hero in Warcraft III". Same policy. |
| Jubei (212801) | SoD WC3 random hero: "Jubei was a random hero in Warcraft III". Same policy. The Draenor "Blademaster Jubei'thos" is a different character. |
| Moogul the Sly (212802) | SoD WC3 random hero: "Moogul the Sly was a random hero in Warcraft III". Same policy. Warcraft RPG and Horde Player's Guide mentions are not novels. |
| Ceredwyn (212803) | SoD WC3 random hero: "Ceredwyn was a random hero in Warcraft III". Same policy. |
| Centrius (212804) | SoD WC3 random hero: "Centrius was a random hero in Warcraft III". Same policy. |
| Kazragore (212969) | SoD WC3 random hero: "Kazragore was a random hero in Warcraft III". Same policy. |
| Felore Moonray (212970) | SoD WC3 random hero: "Felore Moonray was a Priestess of the Moon random hero in Warcraft III". Same policy. |
| Mirror Image (217049) | Spell, not a character: "Mirror Image is... One of the Blademaster's abilities in Warcraft III". |

## Reverse-check names (step 4)

All 486 unique NPC names from npcs_719, npcs_406 and npcs_331 were run through `lookup.py books "<full name>"`. Names with 2+ words and a surname of 4+ letters were also run by surname. Lines from non-book pages (race, faction, category, guide and RPG pages) were read and rejected. Hits that were substrings of other words were rejected: Krond (in "Galakrond"), Llana (in "Yllana"), Talen (in "talent"/"talented"), Korra (in "Korrak").

Named hits in novel titles that were checked:

- Shael'dryn, Emeriss, Lethon (Stormrage Characters). Already in Data.lua.
- Illiyana Moonblaze (Wolfheart Characters). Already in Data.lua.
- Misha, Rexxar (Cycle of Hatred). Already in Data.lua.
- Rexxar (Beyond the Dark Portal, Cycle of Hatred). Already in Data.lua.
- Illiyana (3901) is a different NPC: a dryad page with "{{Distinguish|Illiyana Moonblaze}}". Not a candidate; the Wolfheart hit is the other character. Reject.
- Sentinel Onaeya: only the Cenarius page ("Cloak of Cenarius") and the Maestra's Post page. Not a novel. Reject.
- Taerar (14890), Ysondre (14887): only "dragon" and "green dragon" pages in the cache. See open questions.

## Additions to existing entries (step 7)

- Rexxar (10182), Wolfheart: listed in the Characters table, Mentioned column (read by table position; verify). Source: https://warcraft.wiki.gg/wiki/Wolfheart
- Rexxar (10182), Vol'jin: Shadows of the Horde: listed in the Characters table, Mentioned column (read by table position; verify). Source: https://warcraft.wiki.gg/wiki/Vol%27jin:_Shadows_of_the_Horde
- No additions for Shael'dryn, Lethon, Emeriss, Illiyana Moonblaze or Misha.

## Open questions for the orchestrator

1. Random-hero policy. All 9 SoD WC3 random heroes (Larodar, Tojara, Jubei, Moogul, Ceredwyn, Centrius, Kazragore, Felore Moonray, plus Mirror Image as an ability) were rejected. This follows the Data.lua precedent at lines 663, 869, 894 and 921 ("random hero name ... so no source confirms an actual character"). Please confirm.
2. Twilight Runner (4067). Rejected as a generic nightsaber type. Its page places it in Category:Traveler characters, and the novel line is "a young twilight runner chased Aramar Thorne and Taryndrella". If you count an unnamed novel creature with a named NPC page as a hit, this one is borderline.
3. Ysondre (14887) and Taerar (14890). Both are Dragons of Nightmare, but neither appears in the cached Stormrage Characters section (only Lethon and Emeriss do). They are not candidates. A manual check of the full Stormrage cast list would settle it.
4. Not cached and not verified: "Blackfathom Villainy" (cited for Aku'mai), "Test of Lore" (cited on the Night elf page for Braug Dimspirit), and "Cycle of Rebirth" (cited for Tammra). I did not fetch them. The ones I did fetch the cache for are rejected on other grounds.
5. Braug Dimspirit (406 4489) is not a candidate. His only book-title hit is the Night elf race page, which cites "Test of Lore". Not accepted.
6. Coordinates: none needed (0 accepts).

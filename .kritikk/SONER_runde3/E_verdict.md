# Group E critic verdict: Ashenvale (331), Stonetalon Mountains (406), Blackfathom Deeps (719)

Input: E.lua (no entries), E_report.md (0 ACCEPT, 33 REJECT).

## Per entry (the 33 worker rejects)

Re-checked = the cached raw wiki text was read again in this run. Worker reason = accepted from E_report.md without re-opening.

### Blackfathom Deeps (719)
- Aku'mai (4829): REJECT (worker reason; guide-only sources, not a novel or RTS character).
- Old Serra'kis (4830): REJECT (worker reason; creature type, guide sources).
- Twilight Lord Kelris (4832): REJECT (worker reason; guide sources only).

### Stonetalon Mountains (406)
- Rabbit (721): REJECT (worker reason; generic critter).
- Deer (883): REJECT (worker reason; generic unit type).
- Twilight Runner (4067): REJECT (re-checked). Page text: "{{novel-section}} At some point after the Cataclysm, a young twilight runner chased Aramar Thorne and Taryndrella. (Traveler: The Shining Blade, ch. 9)". The novel names no individual twilight runner. The NPC 4067 page is the nightsaber species (Npcbox: race Nightsaber, "Twilight Runners are nightsabers found in the Stonetalon Mountains"). A species mention is not "this WoW rare named as a character", so it fails criterion 1 and the generic-unit rule in malestokk.md. The Traveler category tag alone does not make it a character. Not ADDED.
- Braelyn Firehand (4198): REJECT (worker reason; only guide source).
- Spirit Healer (6491): REJECT (worker reason; generic NPC type).
- Grundig Darkcloud (11858): REJECT (worker reason; RPG guide only).
- Maggran Earthbinder (11860): REJECT (worker reason; book lookup for "Maggran" returns 0 lines; identity is speculation).
- Mor'rogal (11861): REJECT (re-checked). Raw page: "As such Mor'rogal may have been killed during the assault on Sun Rock" under ==Speculation==. Book lookup returns 0 lines.
- Tammra Windfield (11864): REJECT (re-checked). Raw page: "As such, Tammra may have been killed during the assault..." under ==Speculation==. Her only book-cache hit is the Earth Mother page citing the quest "Cycle of Rebirth", which is not a novel.

### Ashenvale (331)
- Deer (883): REJECT (worker reason; generic critter).
- Voidwalker (1860): REJECT (worker reason; generic demon type).
- Delgren the Purifier (3663): REJECT (worker reason). Book cache: only Lands of Mystery pg. 8 (guide). Not a novel.
- Ilkrud Magthrull (3664): REJECT (re-checked). Raw page: "In a non-canonical book, he had an extra l (Illkrud). Lands of Mystery, pg. 8". That is a guide, and the page itself confirms no novel link. 0 book hits.
- Wildthorn Stalker (3819): REJECT (worker reason; generic tarantula).
- Befouled Water Elemental (3917): REJECT (worker reason; generic elemental).
- Force of Nature (4795): REJECT (worker reason; ability name).
- Felguard (6115): REJECT (worker reason; unit type).
- Spirit Healer (6491): REJECT (worker reason; generic NPC type).
- Sharptalon (12676): REJECT (worker reason; comic, excluded).
- Je'neu Sancrea (12736): REJECT (re-checked). Raw page: RPG section, "Dark Factions, pg. 149"; Dark Factions is a WoW RPG sourcebook. 1 book-cache hit only, a Darkspear line that is not a character appearance. Not a novel.
- Doan Karhan (232924): REJECT (re-checked). Raw page: "Forward Command was later abandoned, with Northwatch Hold and Fort Triumph destroyed by the Horde, leaving Doan's whereabouts unknown" (ref: Jaina Proudmoore: Tides of War). That sentence is about the fort, not Doan. Book cache for "Doan": no Tides of War hit.
- Larodar (212707), Tojara (212730), Jubei (212801), Moogul the Sly (212802), Ceredwyn (212803), Centrius (212804), Kazragore (212969), Felore Moonray (212970): REJECT (worker reason; SoD Warcraft III random heroes, same policy as the existing Data.lua precedent). Not novel characters. Policy open question left to the orchestrator.
- Mirror Image (217049): REJECT (worker reason; spell).

## Counts
- Worker rejects reviewed: 33
- Re-checked against the raw page: 7 (Twilight Runner, Mor'rogal, Tammra Windfield, Ilkrud Magthrull, Je'neu Sancrea, Doan Karhan, Maggran via book cache)
- Confirmed REJECT: 33 (no change)
- Changed to PASS or FIX: 0
- ADDED (new entries written by critic): 0
- Coordinates fetched: none needed (no ADDED entries)

## Step 3: Rexxar (10182) "Mentioned" check
- Wolfheart: CONFIRMED. The table has four columns (Major, Supporting, Minor, Mentioned). The line `*{{RaceIcon|Rexxar}} [[Rexxar]]` is in the 4th cell, which is the Mentioned column.
- Vol'jin: Shadows of the Horde: CONFIRMED. Same four-column layout. The line `*{{RaceIcon|Rexxar}} [[Rexxar]]` is in the 4th cell, the Mentioned column.

## Other checks
- Ysondre (14887) and Taerar (14890): no novel Characters-section hit. Book cache hits are only the "dragon" page (Ysondre appears in a Cataclysm sentence citing Taerar's Fall, a game-era/guide reference). Not candidates. Stays out.
- Twilight Runner's Traveler tag: see the Stonetalon entry above. A Traveler entry is possible only if the orchestrator decides a species mention counts. Under the brief's rule ("named as a character") it does not.

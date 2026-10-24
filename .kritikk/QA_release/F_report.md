# QA report, group F (2026-10-24)

Wowhead Classic was reachable for all 17 NPC pages and the 12 object pages (IDs, names, zones, coords checked). Two object requests returned 403 once (rate limit); they were re-fetched later and succeeded, so no coords were left unverified. Instance NPCs (Shade of Eranikus, Malfurion, AQ dragons) have no coords on Wowhead (Merithra, Caelestrasz and Arygos show only the Silithus raid-entrance point 28.6, 89.2), so coords stay "".

Wowhead "removed/event" flags on the pages are site boilerplate, no NPC is removed or event-only. All IDs are below 200000.

## Eastern Plaguelands
- **1855 Tirion Fordring: FIX (missing appearance).** ID/name/coords OK (7.4-7.6, 43.4-43.6). Of Blood and Honor chapters 6-7 and Arthas: Rise of the Lich King (Minor, part 1 ch. 5) verified. Missing: novel *Tides of Darkness* lists Tirion as Minor and the Tirion wiki page cites it ("Tides of Darkness, chapter 5", studying under Faol). Added as BOOK. WC2 "Assault on Blackrock Spire" lists him only as a lore commander (not an in-game unit), not added.
- **10304 Aurora Skycaller: FIX (NIT-level).** ID/coords OK. Story said she "moved just outside Northpass Tower"; wiki: "Later she moved to below Quel'Lithien Lodge as the tower became a battlefield". Reworded. ISS role OK (Supporting).
- **10824 Ranger Lord Hawkspear: PASS.** Wowhead point 52.8, 18.2 exists. Sylvanas (pg 123-126) and ISS ("angrily declined... banished the quel'dorei of the lodge") verified.
- **11034 Lord Maxwell Tyrosus: PASS.** A Scarlet Flame: wiki NPC page "Maxwell led the Argent Dawn forces at Dawn's Watch, which came under attack by the Crushridge clan... liberated by Garek, Anya, Leonid"; mission page lists him under Forces. Blood Ties ch. 1 and Epilogue verified. Note: NPC page also claims War of the Damned, but that mission page lists only Leonid, so not added. NIT: wiki book title is "World of Warcraft: Blood Ties" (campaign says "Blood Ties").
- **11036 Leonid Barthalomew the Revered: PASS.** Mission names exact; story matches NPC page (Sylvanas freed him; Ras Frostwhisper; Tinkee/Betina quests).
- **11710 Mirador: PASS.** Chapters 2 and 6-7 match "chapter 6 - 7" and "chapter 2". Optional: related = { 1855 }.
- **11878 Nathanos Blightcaller: FIX (weak role).** The World of Warcraft: Sylvanas role ("asks Sylvanas to run away with him") rests on a trivia line citing "chapter ??". Replaced with supported content: saves Sylvanas and Lor'themar from Amani ambush, inducted into Farstriders (Sylvanas book), and promise after Garrosh's trial (chapter 23). Other books verified (A Good War Supporting; Dark Mirror Major; Shadows Rising). Story OK.
- **16376 Craftsman Wilhelm: PASS.** Wiki "Master Craftsman Wilhelm", Blood Ties (Minor, chapter 1 per ref). Story labels the Blood Ties detail as novel.

## Stranglethorn Vale
- **2487 Fleet Master Seahorn: PASS (caution).** Traveler NPC page: "Seahorn presented Adashe Flintwill with Sea King... (chapter 32)", but the book's own character table lists him as Mentioned. Kept because it is his only listing and the NPC page describes a scene; remove if the coordinator wants strict "no Mentioned". Possible add: short story *Stranglethorn Fishing Extravaganza* (Seahorn speaks, tells Revilgaz about Riggle Bassbait) - it is an old developer-preview article, not added.
- **2542 Catelyn the Blade: PASS.** Quest for Pandaria (Supporting) verified. Optional: related = { 2543 } (father Ansirem, already in Data.lua).
- **2547 Ironpatch: FIX (timeline).** Story said he is "in charge of the guns and cannons" - that comes from Cataclysm quests (Drive-By Piracy), and "He is the captain of the Killmonger" was stated as WoW fact though it is book lore. Rewrote and added his death by Makasa (chapter 32). Book role verified.
- **6807 Innkeeper Skindle: PASS.** Quest for Pandaria (Minor) verified.

## Sunken Temple
- **5709 Shade of Eranikus: PASS.** Wowhead boss page OK. Eranikus wiki page ties the Shade to him and the Stormrage section supports the role ("convinced him to transport them to the Bough Shadow", "sacrificing himself to ensure Ysera's escape"). Caution: lore says Eranikus died and the shade remained.
- **15362 Malfurion Stormrage: FIX (missing appearances).** Wowhead: boss in The Temple of Atal'Hakkar. Story "Scepter of the Shifting Sands... Green Shard fork" verified. Existing missions verified. Missing, with speaking/cutscene parts (mission pages, same pattern Data.lua already uses for Tyrande): A Destiny of Flame and Sorrow, The Last Guardian (Eternity's End); Shards of the Alliance, Unfinished Business, Malfurion's Vision, A Parting of Ways (Terror of the Tides). Also BOOK *Stormrage* (wiki Malfurion page, novel section). Added all.

## Temple of Ahn'Qiraj
- **15378 Merithra, 15379 Caelestrasz, 15380 Arygos: FIX (wording).** Wowhead names/zone OK; Classic quest items "Imperial Qiraji Regalia + Elementium Ore x3" confirmed on Wowhead (story correct). The short story says the three "decided to push into the city and hold the Qiraji back" and "flew headlong into the city"; the entries said they hold "the gates". Reworded. Arygos/Twilight of the Aspects verified (wiki: "Arygos told his guards to simply kill him... Kalecgos intervened").

## Counts (NPCs)
PASS 9 (10824, 11034, 11036, 11710, 16376, 2487, 2542, 6807, 5709), FIX 8 (1855, 10304, 11878, 2547, 15362, 15378, 15379, 15380), BLOCKER 0, REMOVE 0. Fixed entries are in F_fixed.lua.

Optional related links (not applied): 1855<->11710, 10304<->10824, 11034<->11036, 2542<->2543, 15378/15379/15380<->15192.

---

# Memorials (12)

All 12 objects verified on Wowhead Classic: object IDs, names and coords match exactly (e.g. 2082 at 52.1, 83.2; 175659 at 65.9, 43.4; 175658 at 45.3, 34.9). Book texts read from Wowhead Classic (Terenas, Grom, Mannoroth, Turalyon, Khadgar, Alleria, Danath, Kurdran, Llane, Daelin) and the wiki (Uther). Inscription claims all supported.

- **uther: FIX.** Role "Paladin hero who fights for the Alliance" is wrong for The Battle at Darrowmere: he is the passenger the fleet must escort (mission page). Missing active WC3 missions: March of the Scourge, The Culling (Human) and Digging up the Dead (Undead, Path of the Damned, he is killed). Story reworded to match the inscription ("First Paladin and Founder of the Order of the Silver Hand").
- **terenas: FIX.** WC3 missions {} but the role describes The Warning (opening cinematic) and he is killed in Arthas' Betrayal (closing cinematic); both added. Inscription "Last True King of Lordaeron" and "behind the throne room" verified.
- **trollbane: FIX.** The WC2 appearance is unsupported: The Fall of Stromgarde lists "Unknown Alliance commander", Thoras is not in any WC2 mission page (only the manual and the novels). Replaced with BOOK Tides of Darkness (Supporting; wiki: sends half of Stromgarde's army, leads troops through Alterac). Story: "king" (wiki; the Valley of Heroes plaque says "Lord of Stromgarde"). Quest chain claim verified (Trol'kalar Classic).
- **llane: PASS.** Plaque "Liege Lord of Stormwind / Defender of Azeroth" verified. WC1 role verified (The Temple of the Damned: "King Llane lies dead... assassinated by Garona"). Optional missions: The Black Morass, The Temple of the Damned.
- **daelin: PASS.** Plaque "Commander of the Alliance Fleets / Friend of Stormwind" verified; Assault on Kul Tiras is mission 8 of the BTDP Orc campaign with Daelin as commander.
- **turalyon: PASS.** Plaque and signature (Uther) verified; Alleria's Journey and Bitter Taste of Victory list him. Optional: Once More Unto the Breach, The Fall of Auchindoun, Siege of Vanguard.
- **khadgar: FIX.** "Once More Unto the Breach" only mentions him in the briefing (commander is Turalyon). Replaced by Deathwing (commander, must survive); The Bitter Taste of Victory kept (all five heroes, "Khadgar must survive").
- **alleria: PASS.** Alleria's Journey and Deathwing list her as commander; plaque signed by Sylvanas verified.
- **danath: PASS.** The Battle for Nethergarde (commander) and Alleria's Journey (recruited hero) OK; plaque signed by Thoras "Lord of Stromgarde" verified.
- **kurdran: FIX.** In The Fall of Auchindoun Kurdran only appears in the briefing (commanders are Turalyon and Danath). Replaced by The Bitter Taste of Victory (all five heroes); Deathwing kept (captured, must survive). Plaque signed "Falstad Wildhammer - Lord of Aerie Peak" verified.
- **grom: FIX.** Story said the inscription says he "gave his life to break the demon's hold"; the text says he "stood alone before the demon Mannoroth - and won our freedom with his blood", signed by Thrall. Reworded. Added missing The Spirits of Ashenvale (chapter 4, Grom commander) and the final cinematic The Death of Hellscream. Slayer of the Shadowmoon verified.
- **mannoroth: FIX (minor).** Plaque text says "remind us of how far we've come and how hard we fought to regain our honor" (not "the Horde"); reworded. Added the cinematic The Death of Hellscream where Grom kills Mannoroth.

Memorial counts: PASS 5 (llane, daelin, turalyon, alleria, danath), FIX 7 (uther, terenas, trollbane, khadgar, kurdran, grom, mannoroth), BLOCKER 0. Changed entries are in F_memorials_fixed.lua.

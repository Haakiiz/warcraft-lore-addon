# Group B verdict (critic)

Input: B.lua (7 entries), B_report.md. Output: B_checked.lua (7 entries, all FIX). No repo files edited.

## Entries
- **3188 Master Gadrin**: FIX. Identity confirmed (Before the Storm Characters link; Vol'jin: Shadows of the Horde Characters link; Npclocations Sen'jin Village, Durotar). BOOK chapter 12 role verified in raw page. Story: cut "After Vol'jin's death he carried the warchief's ashes to Atal'Dazar" (post-Classic WoW event, not book plot). Labelled Before the Storm as "the novel". Coords 56.0, 74.6 (Wowhead g_mapperData).
- **3387 Jorn Skyseer**: FIX. Identity confirmed (Shattering Characters, Minor). Chapter 22 claim verified (novel-section). Story: cut the Cataclysm firebombing / Vendetta Point and MoP Domination Point sentences (post-Classic WoW history, not book plot). Coords 44.8, 59.0.
- **3453 Wharfmaster Dizzywig**: FIX (coords only). Night of the Dragon Characters (Minor) and page both verified; Velinde/Iridi line verified on the page. Quests verified on the page. Coords 63.2, 38.4 from Wowhead; the wiki Npcbox says 69,72, which is not used (rule: Wowhead).
- **6791 Innkeeper Wiley**: FIX. Identity confirmed: Night of the Dragon Characters links [[Innkeeper Wiley]], which is this NPC's page (Ratchet, Northern Barrens). Tier in the book is **Minor** (report said Mentioned): role corrected. Confidence uncertain -> confirmed per brief (Characters-list link to own page). Story added from the page: "goblin innkeeper at the Broken Keel Tavern in Ratchet". Coords 62.0, 39.4.
- **3454 Cannoneer Smythe**: FIX. Identity confirmed: Tides of War Characters (Mentioned) links [[Cannoneer Smythe]], this NPC's page (Northwatch Hold, Southern Barrens; zone The Barrens per Wowhead). Confidence confirmed. Story left empty (page gives only post-Classic-era location detail). Coords 63.0, 56.6.
- **3455 Cannoneer Whessan**: FIX. Same basis as Smythe (Tides of War Characters, Mentioned, links own page). Coords 60.4, 54.8.
- **3498 Jazzik**: FIX. Identity confirmed: Shattering Characters (Mentioned) links [[Jazzik]], this NPC's page (Ratchet, Northern Barrens, general goods vendor). Story added from the page. Confidence confirmed. Coords 61.8, 38.8.

Summary: 7 entries checked. PASS 0, FIX 7, REJECT 0 (B.lua entries). Coords filled for all 7 from Wowhead g_mapperData.

## REJECT table spot-check (3 closest)
- **Belgrom Rockmaul (4485), Orgrimmar: REJECT.** Page's only novel-section text ("After the Fourth War, the Horde Council sent Belgrom to Feralas ... Camp Rockmaul") is cited to `<ref name="Exploring Azeroth: Kalimdor"/>`, a guide (pg. 92). No Blizzard novel, novella, or short story Characters entry (checked all cached book Characters sections). Not ADDED.
- **Doan Karhan (The Barrens): REJECT confirmed.** Tides of War is cited only for the fate of Forward Command. No Doan entry in any book Characters section.
- **Master Vornal (Durotar): REJECT confirmed.** The "Short stories" line is a summary of the Horde Player's Guide p. 145 (page lists "(145)" as the guide page), so it is a guide, not a standalone short story.
- No ADDED entries.

## Unverified additions to existing entries: CONFIRMED (not written to B_checked.lua)
Identity is by Characters link to the same wiki page (Gazlowe: [[Gazlowe]] redirects to Monte Gazlowe). Novel type checked on each book page.
- **Eitrigg (3144)**: The Shattering: Prelude to Cataclysm, Supporting (novel). Heartlands, Supporting (novella by Adam Christopher, Blizzard). War Crimes, Supporting (novel). Rise of the Horde, Minor (novel). Blood Ties, Minor (novel). The report missed The Shattering.
- **Gazlowe (3391)**: Jaina Proudmoore: Tides of War, Mentioned (novel). Before the Storm, **Mentioned** (report did not give a tier). Shadows Rising, Minor, listed as [[Monte Gazlowe]] (Gazlowe redirects there; novel).
- **Kor'jus (3329)**: Jaina Proudmoore: Tides of War, Minor (novel). War Crimes, Minor (novel).
- **Innkeeper Grosk (6928)**: Jaina Proudmoore: Tides of War, Minor (novel). War Crimes, **Visions** (listed tier, novel).
- **Vol'jin (10540)**: Vol'jin: Shadows of the Horde, Major (existing). Jaina Proudmoore: Tides of War, Major (existing). War Crimes, Major (novel). The Shattering, Mentioned (novel). Shadows Rising, Mentioned (novel). Before the Storm, Mentioned (novel).

Table cell positions were mapped by hand for each book, because a parser pass gave wrong tiers for Before the Storm (Gazlowe, Vol'jin, Gadrin).

## Notes
- Wiki raw fetch returned 403 with the bare `Mozilla/5.0` UA; a browser-style UA worked. Wowhead worked with `Mozilla/5.0`.
- Wiley, Smythe, Whessan and Jazzik are confirmed on Characters-list identity only (per brief). Their Ratchet/Northwatch locations come from their own wiki pages.
- Coordinates differ from the wiki Npcbox for several NPCs (e.g. Dizzywig 69,72 wiki vs 63.2, 38.4 Wowhead). Wowhead used per brief.

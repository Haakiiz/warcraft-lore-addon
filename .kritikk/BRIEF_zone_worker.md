# Brief v2: zone review worker (written for Claude Haiku 5.5)

Lessons from 2026-10-08: on Elwynn Forest + Stormwind City, Haiku found 14 of 21 NPCs that Opus found.
Haiku used the same sources; it lost NPCs in its own scan pipeline, not in the research.
It saw `{{Novel-section}}` on Archmage Malin and Baros Alexston, its book-title parser returned nothing,
and it rejected them as "no source found" without reading the section. The rules marked ★ fix that.

## Goal
For your zones, find every NPC who is the SAME character as someone in the Warcraft RTS games
(WC1, WC2, BTDP, WC3, TFT, FK = Warcraft III Reforged: Forsaken Kingdom) or in official Blizzard fiction (code BOOK):
novels, novellas, official short stories (also audio short stories). NOT books: comics, guides
(Exploring Azeroth, Lands of Conflict, Chronicle-style reference), RPG books, canceled games, Hearthstone.
Most zones have 0–3 hits; obscure NPCs (vendors, trainers, architects) are exactly the ones we want.

## Inputs
- `npcs_<zoneId>.json` ({id, name, tag}) from Wowhead Classic. `backlinks_*.txt` = RTS mission leads.
- Format + approved examples: WarcraftLore/Data.lua. Quality bar: .kritikk/referanse/malestokk.md.

## Method
1. Fetch the wikitext of EVERY named NPC (warcraft.wiki.gg API, 50 titles per call, `redirects=1`, ≥0.8 s between calls,
   `py -3 -I`, urllib with a User-Agent). Map redirected/normalized titles back to the NPC name. Save all pages to a JSON file.
2. ★ Flag a page as a candidate if ANY of these match, case-insensitive:
   - a section template: `{{novel-section}}`, `{{short story-section}}`, `{{shortstory-section}}`, `{{story-section}}`
   - a category ending in ` characters` that is a book or game, e.g. `[[Category:Before the Storm characters]]`
   - RTS words: Warcraft II, Warcraft III, Tides of Darkness, Beyond the Dark Portal, Reign of Chaos, Frozen Throne, Orcs & Humans, (WC1, (WC2, (WC3, Forsaken Kingdom
   - any italic linked title `''[[...]]''` inside a `<ref>`
3. ★ Never pipe scan output through `head`/`tail`. Write it to a file and read the file in chunks, so no NPC is cut off.
4. ★ For every candidate, print the raw section text (up to ~1500 characters after the template or heading) and READ it.
   Do not rely only on a regex that extracts book titles: if your parser finds no title but the template is there, read the section by hand.
5. ★ Reverse check: list the zone's NPC names, fetch the pages of the official short stories and novels that are set in or near the zone
   (start with the titles you met in step 2; for a city also try `Category:Short stories` and `Category:Novels`), read their
   `==Characters==` sections, and look for your NPC names there (Major / Supporting / Minor / Mentioned).
6. ★ A rejection must quote the wiki line that shows why (e.g. "only cites Exploring Azeroth"). "No source found" is only allowed
   for pages with no candidate signal at all.
7. Coordinates: Wowhead Classic NPC page, `g_mapperData`. If Wowhead returns 403, say so and leave coords out (do not guess).

## Writing entries
- Identity must be explicit in a source. Likely but unproven → `confidence = "uncertain"` + `searched`.
- `role` says how big the part is (Major / Supporting / Minor / Mentioned) and the chapter if the wiki gives one.
- ★ Timeline: `story` is 3–6 sentences OR exactly "". Describe the NPC as they are in World of Warcraft Classic
  ("In World of Warcraft Classic he is the boy king…"). Anything from later expansions or later books must be tied to its book
  ("In the novel X…"). Never write later titles (king, High King, Speaker, Speedbarge…) as the NPC's current WoW state.
- Items: only real Wowhead item IDs with a real link, else `{}`.
- All text in English.

## Output
- `<group>.lua`: new entries only, exact Data.lua syntax. `<group>_report.md`: per zone counts; per entry the source URLs;
  rejected candidates with the quoted reason; open questions. BOTH files are required, even if the system suggests putting findings in the reply.

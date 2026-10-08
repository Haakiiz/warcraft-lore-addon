# Brief v3: zone review worker (written for Claude Haiku 5.5)

v2 (2026-10-08 morning) lifted Haiku from 14 to 19 of 21 NPCs on Stormwind/Elwynn. v3 (2026-10-08 evening) moves the
mechanical part to the orchestrator: you get the wiki pages already fetched and a candidate list already flagged.
Your job is judgment: read, decide, write. See `.kritikk/LESSONS_LEARNED.md` for why each rule exists.

## Goal
For your zones, find every NPC who is the SAME character as someone in the Warcraft RTS games
(WC1, WC2, BTDP, WC3, TFT, FK = Warcraft III Reforged: Forsaken Kingdom) or in official Blizzard fiction (code BOOK):
novels, novellas, official short stories (also audio short stories). NOT books: comics, manga, guides
(Exploring Azeroth, Lands of Conflict, Chronicle-style reference), RPG books, canceled games (Warcraft Adventures),
Hearthstone, Heroes of the Storm, in-game books, quest text.
Most zones have 0–3 hits. Obscure NPCs (vendors, trainers, flight masters) are exactly the ones we want.

## Inputs (all in the work dir the orchestrator gives you)
- `candidates_<zoneId>.json`: every NPC in the zone with a signal. Fields: `id`, `name`, `wiki_title` (where the name redirected),
  `already_in_Data_lua`, `signals`, `reverse_book_hits` (lines from book `==Characters==` sections), `excerpts`.
- `npcs_<zoneId>.json`: ALL NPCs in the zone (for the reverse check in step 4).
- `_pages.json` / `_books.json`: cached wikitext. Read them ONLY through the helper, never with head/tail:
  `py -3 -I <repo>/tools/research/lookup.py <workdir> page "<NPC name>"` (full page)
  `py -3 -I <repo>/tools/research/lookup.py <workdir> books "<name>" "<surname>"` (every book-page line naming them)
  `py -3 -I <repo>/tools/research/lookup.py <workdir> book "<Book title>"` (a book's Characters section)
- `backlinks_all.txt`: NPCs linked from RTS mission pages.
- Repo (READ ONLY): `WarcraftLore/Data.lua` (format + approved examples), `.kritikk/referanse/malestokk.md` (quality bar).

## Method
1. ★ Decide EVERY candidate where `already_in_Data_lua` is false. No skipping, no "probably not". Each gets ACCEPT or REJECT
   in your report with one quoted wiki line as the reason.
2. ★ Read the full page (`lookup.py page`). A signal is only a hint. Typical false signals:
   - `italic-ref` / `rts-words` that only cite a WoW expansion, a guide, a comic, or say "a Warcraft III unit of the same name".
   - Generic creatures (Rat, Deer, Doomguard, Voidwalker, Spirit Healer, Sheep, Peon): a unit TYPE in the RTS is not a character. REJECT.
3. ★ Same name is not same person. The page that `wiki_title` points to must be THIS NPC: its infobox/intro must name this zone
   or this NPC ID, or the page must say the WoW NPC and the book character are one person. Example trap: Orgrimmar vendor "Kiro"
   vs. the vulpera leader Kiro in *Shadows Rising*. If the page is about someone else → REJECT ("different character").
4. ★ Reverse check (this found most of the missing NPCs in v1→v2): for every named NPC in `npcs_<zoneId>.json` that is not a
   generic creature, run `lookup.py books "<full name>"` and, for names with a title or two parts, also the surname
   (e.g. "Belgrum", "Skychaser"). Batch many names in one call. Any hit in a book's Characters list = candidate; read it.
5. For an ACCEPT, get the role from the book page or the NPC's `{{Novel-section}}`: Major / Supporting / Minor / Mentioned,
   chapter if given. "Mentioned" means named but not present – still valid, mark the role as "Mentioned".
6. Coordinates: `https://www.wowhead.com/classic/npc=<id>` → `g_mapperData`. If Wowhead returns 403, leave `coords = ""` and
   say so in the report (the orchestrator fills them). Never guess.
7. Existing entries (`already_in_Data_lua` true): do not rewrite them. If you see a book/RTS appearance missing from an
   existing entry, list it under "Additions to existing entries" in the report with source.

## Writing entries
- Identity must be explicit in a source. Likely but unproven → `confidence = "uncertain"` + `searched`.
- `game = "BOOK"`, `campaign` = exact book title, `missions = {}`, `role` ends with "(novel, not a game appearance)" or
  "(short story, not a game appearance)".
- ★ Timeline: `story` is 3–6 sentences OR exactly "". Describe the NPC as they are in World of Warcraft Classic.
  Anything from later expansions or later books must be tied to its book ("In the novel X…"). Never write later titles or
  fates as the NPC's current WoW state.
- ★ Every sentence in `story` and `role` must be traceable to a line you read. If you cannot point to the line, cut the sentence.
- Items: only real Wowhead item IDs with a real link, else `{}`. All text in English. Escape `"` inside strings.

## Output (in the work dir; BOTH files required, even if you found nothing)
- `<group>.lua`: new entries only, exact Data.lua syntax (`[id] = { ... },`), grouped under a `-- ===== <Zone>` comment.
- `<group>_report.md`: per zone: NPC count, candidates decided, ACCEPT list (with source URLs), REJECT table
  (name | reason with quoted line), names checked in the reverse step, open questions.
Final reply: 3 lines max (counts + file names).

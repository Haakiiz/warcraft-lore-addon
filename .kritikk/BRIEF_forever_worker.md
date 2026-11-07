# Brief F1: rough Forever NPC check (for Claude Haiku 5.5)

WoW Forever launched 4 Nov 2026. Its new and reworked zones have many new NPCs. Your job: find which of YOUR NPCs are
the SAME character as someone in the Warcraft RTS games or in official Blizzard novels / short stories.
This is a ROUGH first pass: decide every candidate and report. You do NOT write Data.lua entries.

## What counts
- RTS games: WC1 (Orcs & Humans), WC2 (Tides of Darkness), BTDP (Beyond the Dark Portal), WC3 (Reign of Chaos),
  TFT (The Frozen Throne), FK (Warcraft III Reforged: Forsaken Kingdom). Cinematics count.
- BOOK: official novels, novellas, short stories (also audio short stories).
- NOT counted: comics, manga, RPG books, guides (Exploring Azeroth, Chronicle), Hearthstone, Heroes of the Storm,
  in-game books, quest text, Warcraft Adventures, and anything that ONLY exists in WoW Forever itself.
- A unit TYPE is not a character (Footman, Grunt, Skeletal Mage, Wendigo, Fel Ancient, Doomguard): REJECT.
- Same name is not same person. The page must say the WoW Forever NPC and the RTS/book character are ONE person.

## Inputs (work dir: given in your prompt)
- `candidates_<group>.json`: your NPCs that have a signal. Fields: `name`, `wiki_title`, `already_in_Data_lua`,
  `signals`, `reverse_book_hits`, `excerpts`.
- `npcs_<group>.json`: ALL your NPCs (for step 3).
- Read wiki text ONLY with the helper (never head/tail/cat on the json files, they are huge):
  `python3 -I <repo>/tools/research/lookup.py <workdir> page "<Name>"`        full wiki page
  `python3 -I <repo>/tools/research/lookup.py <workdir> books "<Name>" "<Surname>"`  book-page lines naming them
- Live wiki (only if the cached page is missing): `https://warcraft.wiki.gg/api.php?action=parse&page=<Title>&prop=wikitext&format=json`
  with curl and `-A "WarcraftLoreAddonResearch/0.2 (personal project)"`. Wowhead is NOT reachable; do not try it.
- Repo is READ ONLY. Do not edit, commit or push anything.

## Method
1. Decide EVERY candidate where `already_in_Data_lua` is false: ACCEPT, REJECT or MAYBE, each with ONE quoted wiki line.
   MAYBE = the page hints at it but does not say it outright (e.g. same name as a WC3 hero, no link). Keep MAYBE rare.
2. Read the full page with `lookup.py page`. A signal is only a hint. "Human characters" / "Skyborne characters" categories
   are race tags, not a lore hit. Most Forever NPCs are brand new and will be REJECT "new Forever character". That is fine.
3. Reverse check: run `lookup.py books` on every named (non-generic) NPC in `npcs_<group>.json`, many names per call,
   plus the surname for two-part names. Any hit in a book's Characters list = candidate; read it.
4. `already_in_Data_lua` true: only note if Forever adds something new (new zone, new role). Do not rewrite.
5. Timeline trap: Forever is set after the Third War in some zones (Mount Hyjal after Archimonde). Note when an NPC is an
   RTS character who now stands in a NEW place.

## Output (BOTH files, in the work dir, even if you found nothing)
- `<group>_report.md`:
  - header: group, NPCs total, candidates decided, ACCEPT / MAYBE / REJECT counts
  - ACCEPT table: name | wiki title | NPC ID if the page has one | zone | game(s) + mission/book | quoted line | source URL
  - MAYBE table: same columns + what is missing to decide
  - REJECT table: name | reason (short) | quoted line
  - names checked in the reverse step (one line, comma-separated)
- `<group>_accept.json`: list of `{"name","wiki_title","npc_id","zone","games":[...],"quote","url","verdict"}` for ACCEPT + MAYBE.
Final reply: max 3 lines (counts + file names). Never invent missions, books, IDs or quotes.

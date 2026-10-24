# Release QA brief: re-check existing Warcraft Lore entries (2026-10-24)

The addon is public on CurseForge. Before the next release we re-check every shipped entry. You are a strict,
independent checker. Assume nothing is right until you have seen it in a source. Most entries are probably fine;
your value is in finding the few that are wrong, so check each one properly instead of skimming.

Repo (READ ONLY except your own files in `.kritikk/QA_release/`): `C:\Users\Håkon\PycharmProjects\WoW-WC-Addon`.
Read first: the header of `WarcraftLore/Data.lua` (field rules), `.kritikk/BRIEF_critic.md` (the "v4 overrides" and
checks 1–6), `.kritikk/LESSONS_LEARNED.md` ("Feil som fortsatt skjer" and "Feller i kildene"; Norwegian).
Your entries: `.kritikk/QA_release/<GROUP>_entries.lua` (exact copies from Data.lua).

## Tools
- Python: `py -3 -I` with urllib. Always send a User-Agent header.
- warcraft.wiki.gg raw wikitext: `https://warcraft.wiki.gg/index.php?title=<Page>&action=raw` (browser-style UA,
  wait ≥0.8 s between wiki requests or you get 429). Book pages have `==Characters==` sections.
- Wowhead Classic: `https://www.wowhead.com/classic/npc=<id>` with `User-Agent: Mozilla/5.0`. The HTML has the NPC name
  in `<title>` and coordinates in `g_mapperData` (zone id → list of [x, y]). Also check the page does not say the NPC
  was removed / is unused / event-only.
- Write helper scripts to your scratch area under `.kritikk/QA_release/<GROUP>_tmp/`. Never print huge pages with
  head/tail and guess; search the full text.

## Check for EACH entry
1. **NPC ID**: Wowhead Classic page exists, the name matches exactly, and the zone matches `zone` (or `alsoIn`).
   ID ≤ 200000. Not removed/unused/event-only.
2. **Coords**: within ~1.5 of a `g_mapperData` point for that zone. If empty and Wowhead has them, fill them in.
3. **Identity**: a source explicitly says this WoW NPC is the same person as the RTS/book character (not a namesake).
4. **Each appearance**: game code right (BOOK only for Blizzard novels/novellas/short stories; no comics, guides, RPG
   books, Hearthstone). Campaign and mission names spelled exactly as the wiki's mission pages. The character really
   is in each listed mission. `role` is one concrete clause about what they do (no bare "Minor character").
5. **Story**: every sentence supported by the sources. Nothing from after Classic (Cataclysm, Legion, BfA, Shadowlands,
   Dragonflight, Midnight…) written as current WoW state; such events only as clearly-labelled book plot.
   No Cataclysm place names written as current ("Northern Barrens"). No meta sentences. 3–6 sentences or "".
6. **Items**: a real item that is genuinely tied to the character (not a name-alike).
7. **Related**: the listed IDs are characters with a real tie (family, ally, rival in the sources).
8. **Missing appearances**: if the character is clearly in another RTS mission or Blizzard novel that the entry does
   not list, propose it (with source). Do not pad with "Mentioned" appearances that have no action.

Severity: **BLOCKER** = wrong ID/name/identity, invented mission, false lore statement, removed NPC.
**FIX** = wrong coords, wrong mission spelling, weak/incorrect role wording, timeline slip, missing appearance.
**NIT** = style only. Do not rewrite text that is correct just to make it nicer.

## Output (in `.kritikk/QA_release/`)
- `<GROUP>_report.md`: one section per entry: `PASS` / `FIX` / `BLOCKER` / `REMOVE`, each with the evidence
  (URL + short quoted line) for anything you change or flag. End with counts.
- `<GROUP>_fixed.lua`: ONLY the entries you changed, each as the complete final entry in exact Data.lua syntax
  (4-space indent, same field order). The orchestrator will paste them over the old ones. Entries to remove go in the
  report only.
Final reply: 3 lines max (counts + file names).

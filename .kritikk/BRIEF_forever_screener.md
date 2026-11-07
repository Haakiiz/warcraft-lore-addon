# Brief S2: screen WoW Forever candidates (for Claude Haiku 5.5)

Same goal and rules as .kritikk/BRIEF_forever_worker.md (in the repo)
(read its "What counts" section first). Differences this round:
- Your input is ONE file `cand_<group>.json` in the work dir. Each item: `name`, `wiki_title`, `signals`,
  `reverse_book_hits`, `excerpts`, `forever_ids` (NPC IDs from the Forever datamine; may be empty), `source`.
- Many items are NOT characters (items, zones, quests, spells, mounts): REJECT them in one line, "not a character".
- ★ The audio short story *Unbowed* does NOT count (owner's decision). A character whose only lore is Unbowed = REJECT.
- For each remaining item read the page: `python3 -I <repo>/tools/research/lookup.py <workdir> page "<name>"`.
  If the page is missing there, use the live API (see the old brief). Wowhead is not reachable.
- Key question: is this a character a player can MEET in WoW Forever (Forever NPC row, Forever section, or a Forever ID),
  AND the same person as an RTS/book character? Both are needed for ACCEPT.
- No reverse step this time (the orchestrator already ran the book index).
- Output: `<group>_report.md` and `<group>_accept.json` (same fields as the old brief, plus `forever_ids`).
Final reply: max 3 lines. Do not edit the repo.

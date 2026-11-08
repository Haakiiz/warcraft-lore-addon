# Runbook: recurring WoW Forever NPC scan (every 3 days)

Goal: find every NPC a WoW Forever player can meet who is the same character as someone in the Warcraft RTS games
(WC1, WC2, BTDP, WC3, TFT, FK) or in official novels / short stories, as the wiki fills in after launch.
Source: warcraft.wiki.gg only (Wowhead blocks scripted access; do not try to get around it).

## Steps
1. **Collect (no AI):** `python3 -I tools/research/forever_scan.py <workdir>` (workdir in the scratchpad).
   It skips every name in `tools/research/forever_seen.json` and always re-checks `tools/research/forever_watch.json`.
   If it reports 0 candidates not in Data.lua: still do step 1b, then skip to step 5.
1b. **Reverse check (no AI):** `python3 -I tools/research/forever_mentions.py <workdir>` (after step 1, it reuses
   `_books.json`). It lists RTS/book characters NAMED in Forever quests, Forever NPC pages and Forever sections who are
   not in the addon yet. Most are only mentions; give the list to one Haiku agent with the question "MEETABLE in
   Forever, or only MENTIONED?" (a hidden identity, like The Baron = Garithos, counts as meetable). Afterwards run it
   again with `--mark-seen`.
2. **Screen (Claude Haiku):** split `candidates_NEW.json` (only items with `already_in_Data_lua` false) into groups of
   about 30 (`cand_H01.json` ...). One Haiku agent per group with `.kritikk/BRIEF_forever_screener.md`.
   Run them in parallel, in the background.
3. **Verify and write (Claude Sonnet):** every ACCEPT and MAYBE goes to Sonnet agents (about 5 leads each) with
   `.kritikk/BRIEF_forever_writer.md`. Sonnet writes the Data.lua entries and `foreverIDs` / `alsoIn` updates.
   Watch the name trap: a "new" hit is often a veteran already in Data.lua under a title
   ("Lady Sylvanas Windrunner", "King Magni Bronzebeard"). Then it only matters if Forever gave a new NPC ID.
4. **Orchestrator check:** read every new entry yourself against its sources (timeline, 3–6 sentence story,
   banned words, no invented IDs). A book namesake with a Forever ID but no stated location or identity goes on
   `forever_watch.json`, not into Data.lua. Owner decisions: the audio short story *Unbowed* does NOT count;
   projections/images of a book character (Image of Archmage Modera) DO count.
5. **Mark seen** (both scripts): `python3 -I tools/research/forever_scan.py <workdir> --mark-seen` (watch-list names stay unseen).
6. **Test:** `pip install lupa` if needed, then `python3 tests/validate_db.py` and every `tests/test_*.py`.
7. **Ship:** commit on a new branch `forever-scan/<YYYY-MM-DD>`, push, and open a PR to `main` titled
   "Forever scan <date>: N new veterans" (or "Forever scan <date>: no new veterans, seen list updated").
   Add an "Unreleased" line in CHANGELOG.md for new veterans and a dated line in TODO.md under "New in Forever".
   Never commit .env files or secrets. Never push to main directly.

## Budget
Haiku for screening, Sonnet only for verifying/writing. Typical run with little new wiki content: 0–3 agents.

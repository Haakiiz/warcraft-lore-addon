# Critic brief: verify proposed Warcraft Lore entries

★ v4 (2026-10-11): apply the "v4 overrides" at the top of BRIEF_zone_worker.md. Reject (do not downgrade to "uncertain")
any entry whose identity is not explicit, any ID above 200000, removed/event-only NPCs, bare "Major/Minor/Mentioned"
roles and banned words. Run `py -3 -I <repo>/tests/validate_db.py <path to a Data.lua copy with the entries merged>` if you can.

Work dir: given by the orchestrator in your prompt. Cached wiki text (read with this, never with head/tail):
`py -3 -I <repo>/tools/research/lookup.py <workdir> page|books|book "<name>"`.
Repo (READ ONLY): C:\Users\Håkon\PycharmProjects\WoW-WC-Addon — see WarcraftLore/Data.lua (format + approved examples) and .kritikk/referanse/malestokk.md (quality bar, Norwegian).

You are a strict, independent checker. Another worker wrote the entries you get. Assume nothing is right until you have seen it in a source.

For EACH entry, fetch the sources yourself (warcraft.wiki.gg raw wikitext: `https://warcraft.wiki.gg/index.php?title=<Page>&action=raw`,
wait ≥0.8 s between wiki requests; Python is `py -3 -I` with urllib and a User-Agent header) and check:
1. Identity: the page is about THIS NPC (same zone/ID, not a namesake – Orgrimmar vendor Kiro is not the vulpera Kiro) and the source says the WoW NPC (this NPC ID / this name and location) is the same person as the book/RTS character.
2. game code + campaign: BOOK only for novels/novellas/short stories by Blizzard; real RTS games use WC1/WC2/BTDP/WC3/TFT/FK with exact mission page names.
   A guide (Exploring Azeroth etc.), comic, or a canceled game is NOT enough.
3. role: matches what the source says (chapter numbers if given).
4. story: every sentence is in the sources. Story must not present events from after Classic (Cataclysm, Legion, BfA…) as WoW history;
   such events are allowed only when they are clearly the book's plot. Cut unsupported or off-topic sentences.
5. NPC ID and coords: the ID exists on https://www.wowhead.com/classic/npc=<id> with that name and zone (coords within ~1 of g_mapperData).
   Fetch Wowhead with `User-Agent: Mozilla/5.0`; fill empty coords. (warcraft.wiki.gg may need a fuller browser-style UA.)
   Read story sentence by sentence: later places/titles written as WoW state (Speedbarge, High King, "Northern Barrens",
   "Shortly before the Cataclysm…") must be cut or tied to a book. No meta sentences ("Wowhead lists…").
   Count sentences: story is 3–6 sentences or exactly "" (the validator rejects 1–2).
   Keep confidence consistent with existing Data.lua entries that rest on the same source.
6. items: empty unless a real, linked item.
7. Spot-check the worker's REJECT table: re-open the 3 rejects that look closest to a hit. If one should be accepted,
   write the entry yourself and mark it `ADDED` in the verdict.

Output (in the work dir):
- `<group>_verdict.md`: one line per entry: `PASS`, `FIX` (what you changed and why) or `REJECT` (why), then a short summary with counts.
- `<group>_checked.lua`: the PASS and FIXED entries only, final text, exact Data.lua syntax.
Final reply: 3 lines max (counts + file names).

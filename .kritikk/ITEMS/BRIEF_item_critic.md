# Critic brief: check a worker's item findings (item round, 2026-11-28)

You are a strict, independent checker. Another worker wrote `<group>_items.lua` and `<group>_report.md` in `.kritikk/ITEMS/`
following `BRIEF_item_worker.md` (read it first: its KEEP/REJECT rules and blurb rules apply). Assume nothing is right until you
have seen it on a page. Repo is READ ONLY except your two output files.

Read pages with `python tools/research/item_lookup.py .kritikk/ITEMS page "<title>"`; uncached pages from
`https://warcraft.wiki.gg/index.php?title=<Title>&action=raw` (1 s between requests, User-Agent "WarcraftLoreAddonResearch/0.3").

For EACH kept item check:
1. The item ID is on the item page (`|itemid=`) and the name matches. If the page has a Classic ID and a separate SoD ID, the Classic ID is used.
2. The item exists in Classic Era or WoW Forever (not retail-only, not SoD-only).
3. The connection is real and of a kept kind (own thing / drop from the NPC / turn-in to the NPC / quest reward about the NPC / mount).
   A quest reward from a generic quest the NPC gives is a REJECT.
4. `note` is factual and short. `gear` is right (true only if equippable).
5. `blurb`: max 120 characters, 1–2 sentences, every fact is in `veterans.json` for that veteran, nothing post-Classic as WoW history,
   no game codes. Count the characters. Rewrite if needed.
6. Spot-check the worker's REJECT tables: re-open the 3 rejects closest to a hit and every "Open question". Decide them.
   Also open the NPC page of 3 veterans marked "none found" and look at Loot/Quests sections yourself.

Output:
- `.kritikk/ITEMS/<group>_verdict.md`: one line per item: `PASS`, `FIX` (what and why), `REJECT` (why) or `ADDED` (new, with quote).
  Then counts.
- `.kritikk/ITEMS/<group>_checked.lua`: final PASS + FIX + ADDED items, same syntax as the worker's file.
Final chat reply: max 3 lines.

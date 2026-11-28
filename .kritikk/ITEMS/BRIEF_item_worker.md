# Worker brief: WoW items tied to Warcraft veterans (item round, 2026-11-28)

You decide which WoW items belong to each veteran in your group and write a short tooltip text for each kept item.
The addon (Warcraft Lore) shows these items in their in-game tooltip: "Warcraft Lore: Kel'Thuzad (WC3 · TFT)" plus your blurb.

## Your inputs (READ ONLY repo)
- Work dir: `.kritikk/ITEMS/` in the repo given in your prompt.
- `candidates.json`: per veteran (key = lowest NPC ID): name, NPC IDs, items already in the database (`existing_item_ids`),
  and candidate items found mechanically on the wiki (each with item IDs, slot, quality, data variants and `via` = how it was found).
- `veterans.json`: per veteran, the RTS/book appearances and the story text from Data.lua. Your blurbs must rest on this text.
- Read wiki pages ONLY with the lookup tool (never head/tail, never your own scraper):
  `python tools/research/item_lookup.py .kritikk/ITEMS page "<page title>"`  (full wikitext, cached)
  `python tools/research/item_lookup.py .kritikk/ITEMS npc <key>`            (one veteran's candidates)
  A page not in the cache: `https://warcraft.wiki.gg/index.php?title=<Title>&action=raw` (wait 1 s between requests,
  User-Agent header "WarcraftLoreAddonResearch/0.3").
- Shell is Git Bash on Windows. Run Python as `python` (not `-I`).

## Decide EVERY candidate: KEEP or REJECT, with one quoted line from a page
KEEP when the item page, quest page or the NPC page says one of these:
1. **The NPC's own thing**: their head, body part, phylactery, letter, signature, token, a quest item they hand you.
2. **Drops from the NPC** (the item page says "drops from [[NPC]]" or the NPC's loot table lists it). All named drops of a
   veteran boss count, gear included. Not trash drops from the same dungeon.
3. **Turn-ins**: an item you deliver TO the NPC (quest `end` is the NPC and the item is an objective), e.g. a head brought to Thrall.
4. **Quest rewards** only when the quest is given or ended by the NPC AND it is about them (the quest text names them or their story).
   Generic green rewards from a quest the NPC happens to give: REJECT.
5. **Mounts / pets** that come from the NPC (Deathcharger's Reins from Baron Rivendare).

REJECT:
- Items only mentioned in lore text (Doomhammer, Frostmourne, Atiesh in RTS history), Warcraft III / RPG / TCG items, books on the wiki
  without an in-game item ID.
- Retail-only items (Burning Crusade or later). Season of Discovery-only items (the page's only versions are SoD).
  Classic Era and WoW Forever items are fine. If an item has a Classic ID AND a separate SoD ID, use the Classic ID.
- Vendor goods, reagents, generic world drops, items of a namesake, items tied to a different NPC with a similar name.
- Items already in `existing_item_ids` (list them under "Already in the database", do not repeat them).

Also look for items the mechanical search missed: read the veteran's own wiki page sections "Loot", "Drops", "Quests", "Objective of",
and the "(Classic)" page if there is one. Add what you find with the same rules.

## Blurb rules (the tooltip text)
- English, ONE or TWO sentences, max 120 characters, no line breaks.
- About the PERSON and their RTS/book past, tied to the item where natural. Use only facts in `veterans.json` for that veteran.
- No invented details, no events after Classic written as WoW history, no game codes (the line above already shows them),
  no "In Warcraft III: Reforged" boilerplate if it does not fit in 120 characters.
- Gear from the same veteran may share one blurb.
- Good: "The necromancer who spread the plague and summoned Archimonde. While the phylactery lasts, he returns."
- Bad: "This item is from Kel'Thuzad, an important character." (says nothing) / "Kel'Thuzad later ruled Naxxramas in Northrend." (post-Classic)

## Output (write files, do not answer in chat)
`.kritikk/ITEMS/<group>_items.lua` – one block per veteran with kept items, exact Data.lua syntax:
```lua
-- [15990] Kel'Thuzad
{ id = 22520, name = "The Phylactery of Kel'Thuzad", note = "Drops from him in Naxxramas", blurb = "The necromancer who ...", gear = false },
```
`note` = short factual sentence (how it connects: drop / quest name / who you hand it to), like the existing notes in Data.lua.
`gear` = true if it can be equipped.

`.kritikk/ITEMS/<group>_report.md`:
- Per veteran: KEEP table (item | id | kind | quoted line | page) and REJECT table (item | id | reason | quoted line).
  Veterans with no candidates and nothing found: one line "none found (checked: <pages>)".
- "Already in the database" list.
- "Open questions" for borderline cases.

Final chat reply: max 3 lines (counts + file names).

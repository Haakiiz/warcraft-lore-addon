# Brief W2: verify and write WoW Forever veterans (for Claude Sonnet 5.5)

You get a short list of leads: WoW Forever NPCs that may be the same character as someone in the Warcraft
RTS games or official novels/short stories. For each lead: VERIFY it, then WRITE a Data.lua entry or REJECT it.

## Hard rules (the addon is public; tests/validate_db.py enforces most of these)
- Only confirmed lore. If identity is not explicit in a source, REJECT. Never invent missions, books, IDs, items or coords.
- Counts: WC1, WC2, BTDP, WC3, TFT, FK (Warcraft III Reforged: Forsaken Kingdom), BOOK (official novels, novellas,
  short stories incl. audio). NOT: comics, manga, RPG books, guides (Chronicle, Exploring Azeroth), Hearthstone, HotS,
  in-game books, quest text. ★ NOT the audio short story *Unbowed* (owner's decision): drop those appearances.
- A unit TYPE (Footman, Skeletal Mage, Wendigo) is not a character. Same name is not same person.
- `role` = one concrete clause about what the character DOES there. Never a bare "Major/Minor/Supporting character".
- `story` = 3–6 sentences, plain player-facing English. Describe them as they are in WoW Forever; later events must be
  tied to their book ("In the novel X ..."). Banned words anywhere in name/role/story/campaign: "Classic", "Season of
  Discovery", "game files", "removed from the game", "ADP", "wiki", "listed", "pg.", "may not exist",
  "Major character", "Minor character", "Supporting character", "Mentioned in the book".
- Every sentence must trace to a line you read. Cut what you cannot source.

## Where things come from
- NPC IDs: `forever_ids` in the candidate file, or the wiki page "User:Mordecay/Forever/NPCs" (every new Forever NPC with its ID). Use these IDs, nothing else.
  If a character has several IDs, the lowest is the entry key and the rest go in `foreverIDs = { ... }`.
- Wiki text: `python3 -I <repo>/tools/research/lookup.py <workdir> page "<Title>"` (cached), or live:
  `curl -sS -A "WarcraftLoreAddonResearch/0.2 (personal project)" "https://warcraft.wiki.gg/api.php?action=parse&page=<Title>&prop=wikitext&format=json&formatversion=2"`.
  Look for the `==Forever==` section, `{{Forever-section}}`, and `{{Npclocations|...Forever-inline...}}` rows: they give
  the Forever location and coords (`{{Co|x|y|Zone (Forever)}}`). Wowhead is NOT reachable.
- Mission names: read the mission page (e.g. "Misconceptions (WC3 Blood Elf)") and use its title without the "(WC3 ...)" suffix.
- Repo (READ ONLY): `WarcraftLore/Data.lua` for format and examples; the last block "WoW Forever (new NPCs)" shows
  the house style for Forever entries. Do not edit the repo; the orchestrator merges your output.

## Two kinds of result
1. NEW veteran (not in Data.lua): a full entry with `forever = true`, `confidence = "confirmed"`, `coords` from the
   Forever Npclocations row or "" (instances have ""), `zone` = the zone name the player sees (e.g. "Mulgore",
   "Shen'dralas", "Ruins of Lordaeron", "Dalaran"), `sources` = wiki URLs.
2. EXISTING veteran (name already in Data.lua) who has a new Forever ID: do NOT write a new entry. Report
   `existing ID -> foreverIDs = { new IDs }` and, if Forever puts them in a new zone, `alsoIn` zones to add.

## Output (in the work dir, all required even if empty)
- `<name>.lua`: new entries only, exact Data.lua syntax (`[id] = { ... },`), 4-space indent like Data.lua.
- `<name>_updates.json`: `[{"existing_id":..,"name":..,"foreverIDs":[..],"alsoIn":[..],"source":".."}]`
- `<name>_report.md`: per lead ACCEPT / REJECT with one quoted source line each, and anything you were unsure of.
Final reply: max 4 lines.

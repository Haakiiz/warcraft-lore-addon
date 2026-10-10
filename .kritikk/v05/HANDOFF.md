# v0.5.0 handoff (gauntlet-loop)

## NEEDS HÅKON
(nothing yet)

## Morning summary
(to be written by the last session of the night)

## Goal
Warcraft Lore v0.5.0: professional and polished for other players. Work through ROADMAP.md.
Remove anything unfinished or uncertain rather than ship it.

## Håkon's decisions (2026-10-11 00:55)
- Images: ONLY the game's own assets. Main image in the lore window = live 3D model of the NPC as it
  looks in WoW now (PlayerModel / SetCreature / SetDisplayInfo, falling back to the 2D portrait).
  Inside the text: "Through the ages", how the character appeared in each RTS game/book, using game
  badges, WoW icons (Interface\\Icons via C.SetIconTexture with fallback) and text. NEVER ship
  Blizzard RTS art (WC1/WC2/WC3 portraits) as files.
- Only confirmed lore. validate_db.py rejects "uncertain".
- Git: branch `session/v0.5` (built on `session/v0.4-related`, PR #9). Push the branch, open/keep a PR,
  do NOT merge into main, do NOT push tags, do NOT touch the CurseForge page/account.
- Stop only for critical problems; note them under NEEDS HÅKON.

## Parts (one worker each, own files where possible)
| Part | Files | Status |
|---|---|---|
| P1 Portrait: 3D model + "Through the ages" | UI.lua (+ tests/render if useful) | worker started 00:59 |
| P2 Robustness: survive API changes, batch alerts, /wcl why | Core.lua (alert/tooltip/events), Compat.lua | worker started 00:59 |
| P3 Account-wide met + meet counts (migration 2) | SavedData.lua, Core.lua (met section only), tests | worker started 00:59 |
| P4 Options panel + mouse-wheel lists | new Options.lua, .toc, Browser.lua (scroll only) | worker started 00:59 |
| P5 Data quality audit | Data.lua, README test table | worker started 00:59 |

Each worker commits on its own worktree branch `v05/<part>`; the orchestrator merges them into
`session/v0.5`, runs all tests and sends each part to a fresh critic.

## Critic yardstick (score 1–10 each; GODKJENT needs all ≥ 8 and no blocking faults)
1. Looks and feels like a top-tier, polished addon: consistent with Style.lua (violet/teal, round
   portrait ring, game colors), calm layout, nothing cramped or overlapping.
2. Every player-facing text is short, clear English; no dev notes, jargon or debug wording.
3. Nothing unfinished: no placeholders, no "uncertain", no TODOs, no half-working features in the UI.
4. Never throws Lua errors: every client API goes through Compat.lua / pcall; a missing or changed API
   turns off only that feature, with at most one chat line.
5. Cheap at runtime: no per-frame work unless something is animating; lists/indexes built lazily.
6. Lore accuracy: only confirmed, sourced facts; stories 3–6 sentences; no invented IDs/missions.
7. Tests cover the new logic (Lua 5.1 via lupa) and all pass; validate_db.py passes.

## Avoid
- Shipping any Blizzard RTS art or other copyrighted files; external libraries unless clearly needed.
- New global variables (only WarcraftLoreDB / WarcraftLoreCharDB / slash globals / named frames).
- Chat spam (more than one line per event), sounds on every target.
- Colors or fonts hard-coded outside Style.lua.
- Reading secret values without the issecretvalue guard in Compat.lua.
- Breaking saved data: every layout change goes through a SavedData.lua migration.

## Tests to run before every push
python tests/validate_db.py; python tests/test_saved_data.py; python tests/test_related.py (+ new ones)

## Log
- 00:59 plan written, 5 workers started (Sonnet, worktrees).

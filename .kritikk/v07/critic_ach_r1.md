# Critic v0.7 – achievements + Lore Journal, round 1

Reviewed: `git diff origin/main...session/v0.7` (Achievements.lua, Journal.lua, Toast.ShowAchievement,
SavedData migration 3, Core MarkMet hook + /wcl journal, Browser Journal button, Minimap shift-click,
Style gold, tests). Yardstick: .kritikk/v05/HANDOFF.md.

## Tests
All green: validate_db (130 entries), test_achievements 38/38, test_journal ALL OK, atlas 22/22,
guard 30/30, mappins 31/31, met 18/18, options 16/16, portrait ok, related 7/7, saved_data 28/28,
share 38/38, timeline ok, toast 10/10. Both new scripts are in tests.yml and release.yml.

## Blind A/B
A = origin/main, B = session/v0.7 (labels picked at random, revealed here).
Preferred: **B**, confidence ~75 %. B adds a real, generated achievement system and a calm journal
window in the addon's own style without regressions. It loses points on fairness and a few text and
state faults (below), not on its foundation.

## What the generator produces now (39 achievements, 130 veterans)
5 milestones, 6 game (WC3 7, TFT 21, FK 8, Books 117 + steps 25/50), 18 zones, 9 circles, 1 special.

Reachability at the level 30 cap (veterans whose every zone is a 40+ zone or a raid:
EPL, Tanaris, Feralas, Hinterlands, AQ, Winterspring, Felwood, Sunken Temple, Zul'Farrak, Moonglade):
27 of 130 veterans. That makes these **impossible right now**:
- 5 zone achievements: All of Eastern Plaguelands, Feralas, Tanaris, The Hinterlands, Temple of Ahn'Qiraj.
- All 4 "complete a game" achievements: Heroes of Reign of Chaos (2 out of reach), Heroes of the Frozen
  Throne (1), The Forsaken Kingdom (2), Keeper of the Books (24).
- Living Archive (100) needs 100 of the 103 reachable veterans: possible, but barely.
So about a quarter of the journal, including the flagship game achievements, sits as permanent grey rows
with a progress bar that stops short. Circles, cities and the low zones are all reachable (good).

## Scores
| # | Point | Score | Why |
|---|---|---|---|
| 1 | Polished look, Style.lua | 7 | Same frame art, gold added to Style.lua (no hard-coded colors), sensible 460x580 grid. But a quarter of the rows can never light up, Books steps are scattered by the alphabetical sort, earned rows can turn grey (see B3). |
| 2 | Short clear English | 7 | "Fizzle Brassbolts's Circle"; "Heroes of Reign of Chaos" reads clumsily; "Across the Ages" says "every Warcraft game" but only WC3/TFT/FK count; zone titles "All of X" are flat next to the evocative milestones; "Keeper of Lore" vs "Keeper of the Books". |
| 3 | Nothing unfinished | 7 | Unreachable-at-cap achievements with no hint; earned/done mismatch after a data update; journal progress goes stale while open. |
| 4 | No Lua errors, Compat | 8 | pcall around every cross-module call, DB type checks, fallback icon. One raw global (IsShiftKeyDown) although C.IsShiftDown exists. |
| 5 | Cheap at runtime | 9 | defs built once lazily; List only on show / new meet; banner OnUpdate only runs while shown. List runs twice per Refresh (Counts calls it again) – trivial. |
| 6 | Lore accuracy | 8 | Built from validated data and Related links; no invented facts. "Across the Ages" description overstates. |
| 7 | Tests | 8 | Achievement logic, silent first run, migration 3, newer-data no-op and order are well tested against the real data. Missing: earned-but-no-longer-done, real string widths in the journal (fake GetStringWidth = 40). |

## Blocking faults
B1. **Unreachable achievements with no signal (fairness).** Achievements.lua:107-116 (zones) and
85-101 (games) generate goals that cannot be finished at the level 30 cap. Fix: give Data.lua (or a
small table in Achievements.lua) a minimum level per zone, mark any achievement whose members include a
veteran only found above the cap as `later = true`; in Journal.lua sort them last (or a "Later" chip),
dim them and add one tooltip line such as "Some of these veterans are in level 40+ lands." Keep them out
of the summary bar ("12 of 29, 10 more later"). Data-driven so it opens up when the cap rises.

B2. **Wrong possessive in player text.** Achievements.lua:126 builds "Fizzle Brassbolts's Circle".
Fix: `name:sub(-1) == "s" and name .. "' Circle" or name .. "'s Circle"`, plus a test.

B3. **Earned achievements turn grey after a data update.** Achievements.lua:212 sets `done` from
current progress only; Journal.lua:115/197/212 style and date only on `done`, while the summary uses the
stored `earned` (Counts). Each data release that adds a veteran to a zone/game/circle makes an earned
row grey with no date and the summary disagrees with the rows. Fix: `done = progress >= d.total or
earned[d.id] ~= nil` (keep the real progress for the count), test "earned, total grew -> still done,
date shown".

B4. **Raw client API.** Minimap.lua:121 calls `IsShiftKeyDown` directly; use `C.IsShiftDown()`
(already in Compat.lua:359), as the yardstick demands.

## Non-blocking polish
- Order: the Books steps (Bookworm 25 / Keeper of the Books 117 / Library Regular 50) are split up by the
  title sort (Achievements.lua:151). Sort steps by total within a game, or keep the BOOK chain together.
- Titles: "Heroes of the Reign of Chaos" (or "Reign of Chaos"); replace "Library Regular" (modern, a bit
  cheesy) with e.g. "Lorekeeper"; avoid two "Keeper of ..." titles; zone titles could be warmer
  ("Known in Orgrimmar", "Friend of Ironforge") – keep one pattern for all 18.
- "Across the Ages" desc: "Meet a veteran from each Warcraft III campaign" or list the games in the tooltip.
- Spam: earning an achievement on a meet gives two chat lines ("New veteran met" + "Achievement earned")
  and a second sound. Consider appending the achievement to the meet line, and skip the achievement
  sound when alerts are off (db.alert = false) – today it always plays.
- Journal.lua: MarkMet refreshes the journal only when a new achievement lands; call
  `ns.Journal.Refresh` (cheap no-op when hidden) on every new meet so open progress bars move.
- Banner: left-click does nothing; let it open the journal. It sits 200 px under the toast anchor with
  no clamp – check near the bottom of the screen.
- First-run line starts lower-case ("you already have ..."); other lines are capitalised.
- Chips are 62 px for "Milestones" at 10 pt – check in game that it does not touch the edges.
- Icons Achievement_Level_10 / Achievement_Reputation_01 are later-expansion names; the fallback covers
  a miss, but check in game that they show (otherwise use INV_Misc_Note_01 / INV_Misc_Bag_* style icons).

## Checked and fine
- Silent first run: seeds at PLAYER_LOGIN, one "/wcl journal" line, no banner, no sound; fresh install
  silent; returns {} so nothing re-announces.
- Several at once: one chat line (max 3 names + "and N more"), one banner with the count, one sound.
- Migration 3 safe for v0.6 users: only adds `achievements = {}`, met untouched, test covers it;
  newer/odd data (`achievements` not a table) is left alone.
- No new globals besides the named frame WarcraftLoreJournal; no per-frame work when idle; rows pooled.
- /wcl journal, help line, /wcl reset includes the journal, Browser button reserves bar width.

## Verdict: **AVVIST**
Scores 1-3 are 7 and there are four blocking faults (B1 fairness at the level cap, B2 text, B3 state,
B4 Compat). All are small, local fixes; the base is good and preferred over main.

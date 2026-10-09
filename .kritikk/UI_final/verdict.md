# Final verdict: Warcraft Lore v0.3.0 release candidate (branch session/veterans-browser, uncommitted)

**Verdict: AVVIST** (2 reject-level defects; docs accuracy and code quality are below 8)

## What was checked
- `python tests/validate_db.py`: OK, 128 entries, no duplicate NPC IDs.
- Offline harness (`run.js` + `browser_test.lua`): **ALL PASSED**. New globals: only `SLASH_WARCRAFTLORE1`, `WarcraftLoreDB`, `WarcraftLoreCharDB`, `WarcraftLoreFrame`, `WarcraftLoreBrowser` (`SHOTDIR` comes from the harness). The only unknown API reported is the mock's missing `GameTooltip:GetUnit`, which is harmless.
- `.toc`: all 8 files exist. Load order is Compat, Data, Core, Style, UI, Browser, Toast, Minimap, which is correct because each module only uses `ns.Style` and `ns.Compat` at load time and everything else lazily. Both SavedVariables are declared.
- Textures: all 13 `TEX .. "Name"` references exist in `WarcraftLore/Textures`, all are power-of-two 32-bit TGA files, and `tools/make_textures.py` generates every one. Every path string uses double backslashes (the old single-backslash Toast paths are fixed).
- `.pkgmeta`: ships only the `WarcraftLore` subfolder; tests, tools, media, `.kritikk` and `.claude` are ignored.
- Every `C.*` call is defined in Compat.lua, and every Compat function is used. No `RaidNotice`, no old toast API, no debug `print` (`Compat.lua:217` is the `C.Print` fallback).
- Met counts: 128 entries merge to 127 veterans (Gregory 231500 + 232932, Western Plaguelands). Browser, minimap tooltip, chat line, README, CurseForge text and screenshots all say 127.
- Behavior:
  - Targeting with auto on shows the pill, or follows the target if the lore window is already open (Core.lua:486-494).
  - `/wcl` opens the full window.
  - The nearby alert fires once per NPC per session through the shared `alerted` table.
  - Minimap: left-click opens the list, right-click shows the target's story, and a drag is not counted as a click.
  - The minimap glow is hidden at build and shows only on OnEnter.
  - The popup closes on the catcher, on a row click, on search focus and when the browser hides.
  - No heavy OnUpdate: Toast OnUpdate is light and runs only while a pill is shown, Minimap OnUpdate runs only while dragging, and `MetCounts` runs only on a new meeting or a refresh.
- Screenshots: all 5 resolve from `media/screenshots/...` and the captions match what the images show.
- TODO: the two finished items are ticked with "not tested in game".

## Scores
| | Area | Score |
|---|---|---|
| a | Runs / tests | 9 |
| b | Cross-module consistency | 8 |
| c | Docs accuracy | 6 |
| d | Code quality | 7 |
| e | Release readiness | 7 |

## Reject-level defects

### R1. The popup drop shadow is dead code: its OnShow handler is commented out
- **Where:** `WarcraftLore/Browser.lua:307`
  ```lua
  strip("ShadowH", { "TOPRIGHT", "TOPLEFT", 0, 0 }, ..., true, false)     -- left    p.frame:SetScript("OnShow", function() p.shadowFrame:Show() end)
  ```
- **What happened:** two lines were merged, so `p.frame:SetScript("OnShow", ...)` now sits inside the `-- left` comment. Byte check: there is no newline between "left" and "p.frame".
- **Failure scenario:**
  - `p.shadowFrame` starts hidden (line 288) and nothing ever shows it.
  - The four ShadowH/ShadowV strips (the fix for D1 runde2 nit 2: popup edge blending into the list underneath) are built but never drawn.
  - `campaign-filter.png` confirms it: the popup has no shadow.
  - Only the OnHide half (line 308) runs. The harness does not catch this.
- **Fix:** put `p.frame:SetScript("OnShow", function() p.shadowFrame:Show() end)` back on its own line, re-render `campaign-filter.png`, and add a harness check that the shadow frame is shown while the popup is open.

### R2. User-facing docs describe the old targeting behavior and misdescribe what is new
1. **Stale "Lore window" bullet**
   - Where: `README.md:14` and `media/curseforge-description.md:14`.
   - Both still say "targeting a known NPC opens a small window".
   - In 0.3, targeting shows the pill and the window opens only through `/wcl`, a pill click, the minimap right-click or a list row. README:38 ("Targeting a veteran now shows the pill instead of opening the window") contradicts README:14.
2. **Targeting does not give a chat line and sound**
   - Where: `README.md:16` and `media/curseforge-description.md:17`.
   - Both say the pill comes "together with one chat line and a sound" when you target a veteran, or "plus a chat line and sound, when a Warcraft veteran is close by or targeted".
   - The target path (Core.lua:491-492) only calls `Toast.Show`: no chat line, no sound. Only `announce()` (nearby or test) prints and plays a sound. The one exception is the "New veteran met" line on a first meeting.
3. **"What's new in 0.3" calls new features a redesign**
   - Where: `README.md:36`, "Veterans list redesign: ...".
   - v0.2.0 had no Veterans list, no `/wcl list` and no met tracking (`git show HEAD:WarcraftLore/Core.lua` has none of them).
   - So "What's new" never says the headline features are new: the Veterans list (`/wcl list`), per-character met tracking (`WarcraftLoreCharDB`), the "New veteran met" chat line and per-game counters.
- **Fix:**
  - Reword the Lore window bullet to "`/wcl` (or clicking the alert, a list row, or the minimap right-click) opens a small window ...".
  - Make the pill text say the chat line and sound are for nearby alerts only.
  - Rewrite the first "What's new" bullet as "New: Warcraft Veterans list (`/wcl list`) with search, filters and a per-character met counter ...".

## Non-blocking nits
1. **Merged veteran and the MET badge** (`UI.lua:296-308`, `UI.lua:311-315`, `Browser.lua:569`)
   - A list row opens the lowest ID (Gregory 231500), and `setMetBadge` checks only that ID.
   - If only 232932 was met, the row and tooltip say "Met on this character", but the lore window has no MET badge.
   - Fix: let `setMetBadge` and `RefreshMet` check the merged group, for example with a `ns.VeteranOf(id)` lookup.
2. **Misleading "New veteran met" line** (`Core.lua:177`): meeting the second Gregory ID prints "New veteran met" but the x/127 count does not change. Suppress the line when the group was already met.
3. **Stale comments** (`Browser.lua:783` and `:974`): they say "of 128" and "Showing all 128 veterans". The real number is 127.
4. **Outdated Toast header** (`Toast.lua:1`): it says "the nearby-veteran alert", but the pill is now also the target alert.
5. **The pill always shows "?" in a real install.** No portraits ship, and `display()` never tries `C.SetUnitPortrait`, even though the target and nameplate paths have a unit token. "A small pill with a portrait" (README:16, CF:17) oversells this. Pass the unit through and use the unit portrait when it is available.
6. **Hard-coded color** (`Browser.lua:470`): `"|cff" .. "c79b3e" .. "(uncertain)"` repeats `COL.amber` as an inline hex. Add `S.HEX_AMBER`.
7. **Direct API call outside Compat** (`Toast.lua:189`): `IsShiftKeyDown()` is called directly. It is a stable global, but the house rule says client calls go through `ns.Compat`.
8. **Shift-drag save** (`Toast.lua:193-196`): OnDragStop saves `toastPos` even when no move started (drag without shift). Harmless, but only save if moving began.
9. **Unconfirmed drag-then-click on the pill:** it is not confirmed whether a shift-drag release also fires OnClick (open and dismiss) in this client. Minimap.lua guards against this with `CLICK_GRACE`; Toast.lua does not. Add the same guard, or list it as an in-game check.
10. **UI.lua whitespace:** a double blank line at 328-329, and no blank line between `dockTo` and `showHeader` (341-342).
11. **Missing in-game checks in TODO.md:** there are no items for the pill (pulse, target pill, shift-drag) or the minimap button (placement on Forever's minimap, drag, hover glow). Add "not tested in game" items so the first in-game session covers them.
12. **CurseForge command list:** it leaves out `/wcl browse`, `/wcl alert test` and `/wcl debug`. A subset is acceptable, but `/wcl debug` is useful for bug reports.
13. **README:62 "/wcl test ... for the first database NPC":** the code uses the lowest NPC ID. Say "lowest ID".
14. **TASKS.md** (not shipped): a UTF-8 BOM was added on line 1, and the D1 status line still says "Runde 2 pågår" although D1 runde2 is approved.
15. **`simulering/`** is untracked and not in `.pkgmeta`'s ignore list. That is fine as long as it is never committed to this branch. The packager builds from git, but add it to the ignore list if it ever is committed.

## To reach GODKJENT
Fix R1 (one line, plus a re-render and a harness check) and R2 (README:14, 16, 36 and CurseForge 14, 17). Nits 1, 3, 4 and 11 are cheap and recommended in the same pass.

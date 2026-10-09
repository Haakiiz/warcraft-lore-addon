# Final verdict, round 2: Warcraft Lore v0.3.0 release candidate (branch session/veterans-browser, uncommitted)

**Verdict: GODKJENT.** There are no reject-level defects and every score is 8 or higher. The nits below are optional before the tag, but N1 is a one-line fix and worth doing in the same commit.

## What was checked
- **Database test:** `python tests/validate_db.py` is OK (128 entries, no duplicate IDs).
- **Offline harness:** `run.js` + `browser_test.lua` prints **ALL PASSED**. That now includes the new check "popup drop shadow is shown while the popup is open". The new globals are only `SLASH_WARCRAFTLORE1`, `WarcraftLoreDB`, `WarcraftLoreCharDB`, `WarcraftLoreFrame` and `WarcraftLoreBrowser` (`SHOTDIR` comes from the harness). The only unknown API is the mock's `GameTooltip:GetUnit`, which is harmless.
- **R1 (popup shadow) is fixed.**
  - `Browser.lua:308` now has `p.frame:SetScript("OnShow", ...)` on its own line, and `:309` has the matching OnHide.
  - The strip geometry is right: each strip is opaque next to the popup edge. `make_textures.py` writes ShadowV opaque at the top, and ShadowH (ShadowV rotated 90° counter-clockwise) opaque at the left.
  - A pixel sample of the re-rendered `campaign-filter.png` confirms it. Below the popup the pixels go (8,6,12) → (11,9,17) → (15,12,22) → panel (16,13,24), and to the right of it (12,10,16) → (21,18,27). The shadow renders, but it is subtle on the dark panel.
- **R2 (docs) is fixed.**
  - README:14 and CF:14 now say `/wcl` (or the pill, a list row, or the minimap right-click) opens the lore window.
  - README:16 and CF:17 now say the chat line and sound are for nearby alerts only.
  - "What's new in 0.3" now lists the Veterans list, met tracking, the pill and the minimap button as new.
- **Previous nits:**
  - Fixed: 1 (`setMetBadge`/`RefreshMet` use `ns.VeteranOf` + `GroupMet`), 2 (`alreadyMet` suppresses the "New veteran met" line), 3 (comments say "of N" / "all N"), 4 (Toast header), 6 (`S.HEX_AMBER`), 7 (`C.IsShiftDown`), 8 (OnDragStop returns unless moving), 9 (Toast has `CLICK_GRACE`), 10 (UI.lua whitespace), 11 (TODO has in-game items for the pill and minimap), 12 (CF lists `/wcl debug`) and 13 ("lowest ID").
  - Still open: 5 (pill portrait), which is now partly addressed because the target and nameplate paths pass the unit to `C.SetUnitPortrait`.
- **Core.lua rebuild:** I compared it to `git show HEAD:WarcraftLore/Core.lua`. Every hunk outside the intended features is unchanged: lookup, GamesInOrder, the tooltip line, cmdShow, cmdID, cmdAlert, the ZONE_MAPS table (all 23 zones with the same IDs, including the Alterac Classic-only note), buildIndex, checkPosition, cmdDebug and the event wiring. The intended changes are all present:
  - merged veterans (`ns.Veterans`/`VeteranOf`)
  - met tracking with the deferred `C.After` refresh
  - `/wcl list|browse|minimap`
  - the alert pill instead of RaidNotice or auto-open
  - the `WarcraftLoreDB.minimap` and `WarcraftLoreCharDB(.met)` type guards
  - `ns.ShowTarget`

  The only change that was not on the list is the shorter nearby chat line (see N3).
- **.toc and packaging:**
  - All 8 files exist, in the order Compat, Data, Core, Style, UI, Browser, Toast, Minimap. Each module only uses `ns.Style` and `ns.Compat` at load time.
  - Both SavedVariables are declared.
  - `.pkgmeta` ships only `WarcraftLore/`.
- **Textures:**
  - All 13 textures that are referenced exist, including ShadowH and ShadowV through `strip(file)`.
  - Every path uses `\\`, and there are no single-backslash `"Interface\X` literals.
  - Every `C.*` call is defined in Compat.
  - No RaidNotice, auto-open, debug print or "128" leftovers.
- **Cross-module consistency:**
  - The count is 127 in README, CF, the screenshots (browser, minimap tooltip) and `MetCounts`.
  - The slash commands in Core's help, README and CF agree. CF lists a subset without `browse`/`alert test`, which is acceptable.
- **Behavior:**
  - Target with auto on: the window follows the target if it is open, otherwise the pill shows (Core.lua:497-506). Met is marked even with auto off.
  - `/wcl` opens the full window.
  - The nearby alert fires once per NPC ID per session through `alerted`.
  - Minimap:
    - left-click toggles the list and right-click runs `cmdShow`
    - a drag does not count as a click (dragging flag plus a 0.2 s grace period)
    - the tooltip shows the live met count
    - OnUpdate runs only while dragging
  - The popup closes on the catcher, a row click, search focus and browser hide.
  - No heavy per-frame work: Toast OnUpdate runs only on visible pills and `MetCounts` only on a new meeting, a refresh or a minimap hover.
- **Docs and screenshots:** I looked at all 5 PNGs and their captions match. In TODO, finished items are marked "done …, not tested in game", and the in-game test items for `/wcl list`, the pill, the minimap and toast textures are present.

## Scores
| | Area | Score |
|---|---|---|
| a | Runs / tests | 9 |
| b | Cross-module consistency | 9 |
| c | Docs accuracy | 8 |
| d | Code quality | 8 |
| e | Release readiness | 8 |

## Reject-level defects
None.

## Nits (non-blocking)
1. **Shadow frame has no anchors** (`Browser.lua:286-288`)
   - **What:** `p.shadowFrame` is created without any points or size. Its textures are anchored to `p.frame`, so this works in the harness and very probably in game. But a frame with no rect is the one place where the live client could behave differently from the mock.
   - **Fix:** add `p.shadowFrame:SetAllPoints(p.frame)` (one line, no visual change). Also add "popup has a soft shadow" to the `/wcl list` in-game test item in TODO.
2. **Stale portrait unit for queued pills** (`Toast.lua:269-281`, `display` at :245)
   - **What:** the unit token is saved in the queue. If 3 pills are already showing, a queued pill is displayed later with `"target"` or `"nameplateN"`, which may by then point to a different unit or none, so the portrait can show the wrong NPC.
   - **Fix:** only pass `unit` when the pill is displayed immediately, or check that the unit's NPC ID still matches before you use it.
3. **Nearby alert lost its "(uncertain)" marker** (`Core.lua:290`)
   - **What:** HEAD's chat line had `(uncertain)` for uncertain entries. The new line has no tag, and the pill shows none either, so an uncertain link is announced like a confirmed one. The tooltip and the lore window still mark it.
   - **Fix:** restore the tag in the chat line (and optionally a "?" on the pill), in line with the project's "never present uncertain as fact" rule.
4. **Target-follow undocks the lore window** (`UI.lua:420-424`)
   - **What:** if the lore window is docked next to the Veterans list and you target a veteran with auto on, `ShowEntry(..., "target")` without a dock jumps the window back to its saved position, away from the list.
   - **Fix:** keep the dock while the browser is shown, or list this as an in-game UX check.
5. **`/wcl reset` leaves the pill stack in place** (`Core.lua:447-450`)
   - **What:** it resets the two windows but not `toastPos` (or the minimap angle). If the pill stack is shift-dragged somewhere awkward, nothing resets it.
   - **Fix:** clear `WarcraftLoreDB.toastPos` and re-anchor. The help text and README say "windows", so this is not a doc error.
6. **`make_textures.py` now needs numpy** (`pill_glow`, line 141), but README's Files section still says "(needs Pillow)". Write "(needs Pillow and numpy)".
7. **Formatting and error-name nits:**
   - `make_textures.py`: one blank line instead of two before `def _glyph` (PEP 8).
   - `Compat.lua`: no blank line between the end of `C.MinimapCursorAngle` and the `C.CreateEditBox` comment.
   - `C.MinimapCursorAngle` records "GetCursorPosition" as missing even when the real cause is a missing Minimap.
8. **Mixed line endings:** `Toast.lua`, `UI.lua` and `make_textures.py` are LF in a CRLF working tree (git warns). This is harmless, but normalize them before committing so the diff stays clean.
9. **Square shadow corners:** the shadow corners are the top and bottom strips extended by 16 px, so they fade only vertically and look slightly square at the popup's corners. This is cosmetic and hardly visible at 60 % on the dark panel.
10. **No in-game item for met tracking:** TODO has no item for checking met tracking itself: does mousing over or targeting a veteran mark them, does the "New veteran met" line print once, does the MET badge appear, and do secret GUIDs in combat mark nothing? Add it next to the other in-game tests.
11. **Carried over:**
    - `simulering/` is untracked and not in `.pkgmeta`'s ignore list. Never commit it on this branch, or add it to the list.
    - The README release example still says `v0.1.0`.

# Verdict – UI_D2 round 1 (met tracker + Warcraft Veterans browser)

Critic: independent code review of logic, robustness and code quality only. Visual design was not judged.
Material read: diff.patch, Browser.lua, Style.lua, and the current Core.lua, Compat.lua and UI.lua. The review copies of Browser.lua and Style.lua are byte-identical to the ones in WarcraftLore/.

## Scores

| # | Criterion | Score |
|---|-----------|-------|
| 1 | Correctness of met tracking | 8 |
| 2 | Robustness on 12.x/Forever | 8 |
| 3 | Correctness of browser logic | 8 |
| 4 | Lua 5.1 compatibility, no leaks, no nil-index or upvalue-order bugs | 9 |
| 5 | Code quality | 8 |

### 1. Met tracking (8)
- Both triggers are handled: target (PLAYER_TARGET_CHANGED, now independent of `auto`) and mouseover (unit tooltip post-call). Nameplate alerts, coordinate alerts, `/wcl test` and opening an entry from the browser (`unit == nil`) do not mark anyone as met, which matches the spec.
- The first timestamp is kept: `MarkMet` returns early when `db.met[npcID]` is truthy, and it writes the timestamp synchronously, so a second call in the same frame does nothing.
- `MetCounts` counts each NPC once overall and once per game it appears in. BOOK counts as its own game. `perGame[code]` always exists because `GamesInOrder` only returns codes from `GAME_ORDER`.
- Live refresh works. The browser keeps its scroll position, and the "Not met" filter drops the row. When the lore window shows the NPC, `UI.RefreshMet` updates it. With auto-open, the lore window shows "MET" right away because the write happens before `ShowEntry`.
- Secret GUIDs and unit tokens give no entry, so nothing is marked. That is correct and documented.
- Points deducted: met-by-mouseover depends entirely on the tooltip hook (see nit N4). There is also a small inconsistency between `IsMet` and `MarkMet` when a value is `false` (N5).

### 2. Robustness (8)
- Secret values go through `C.IsSecret` and `safeCall`. The tooltip post-call does only cheap work: the chat line and window refreshes are deferred with `C.After`, so an error in our windows cannot break GameTooltip. Nothing in the new code is protected, so combat lockdown is not a concern.
- Saved variables: `WarcraftLoreCharDB` and `.met` are type-checked and replaced if damaged. `MarkMet` also checks the type again, and it is safe before ADDON_LOADED.
- EditBox: the font is set before any `SetText`, `SetAutoFocus(false)` means it does not grab the keyboard when the window opens, and Esc, Enter and the window's OnHide all clear focus. However, focus is not cleared when you click a row, filter or badge (N1).
- Strata and levels: browser HIGH, lore window DIALOG (a clicked veteran opens on top). Popup at +30 is above the catcher at +20, which is above the controls. Every Button calls `C.RegisterClicks`.
- ScrollFrame: wheel scrolling is clamped by hand. `OnScrollRangeChanged` re-runs `updateThumb`, which covers the one-frame lag before the range updates.

### 3. Browser logic (8)
- Filters combine correctly: games are OR among the selected games, then AND with zone, campaign, status and search. `anyFilter` and the Clear button match the state. Clear resets the EditBox without a double refresh, because OnTextChanged sees `q == state.query`.
- Search is literal (`string.find(..., 1, true)`), trimmed and case-insensitive on both sides.
- The popup highlights the current value, including "All" (nil == nil), skips header rows, scrolls and clamps, opens above or below depending on room, and is clamped to the screen.
- The row pool reuses rows at fixed y positions and hides surplus rows. The empty state and the "Showing X of Y" line are correct. Toggle and reset work before and after Init.
- Points deducted: the click catcher makes one branch dead and swallows the first click (N2). The popup gives no sign that it can scroll (N7).

### 4. Lua 5.1 (9)
- No global leaks: every new file-level name is `local`. The only globals used are the intended `WarcraftLoreCharDB`, `strtrim` and `time`.
- No `goto`, integer division or `#` on a hash. Upvalue order is correct: `closePopup` is defined before `buildPopup`, `refreshFiltered` before `buildCounters`, `updateThumb` before `buildList`, and `content`/`scroll` are assigned before the first Refresh.
- The Toast.lua escape fix is a real Lua 5.1 bug fix: in 5.1, `"\A"` silently becomes `"A"`, so the toast texture paths were broken.

### 5. Code quality (8)
- Style.lua is a clean extraction with the same comment density and naming as the surrounding code. Client-dependent calls (`C.After`, `C.CreateEditBox`) live in Compat.
- Points deducted: dead code and one unused import (N2, N6). A feature-specific constant sits in the generic Compat helper (N8). Marking someone as met is a side effect inside the tooltip line renderer; it is documented, but it couples the two (N4).

## Reject-level defects

**None.** I found no crash path, nil-index, taint source, global leak or wrong filter result.

## Minor nits (non-blocking, recommended before release)

- **N1 – Search keeps keyboard focus after other clicks.** Browser.lua:360-366 (row OnClick), :506 (game badge), :596/:606/:616 (filter buttons), :256 (popup row).
  - Scenario: you type "thr", click Thrall, then press W to walk. The "w" goes into the search box and the list shows "No veterans match."
  - Fix: call `if searchEdit then searchEdit:ClearFocus() end` inside `closePopup()`, which all of these handlers already call except the badge, and in the badge handler. Optionally also clear focus in an `OnMouseDown` on `frame`.
- **N2 – The click catcher covers the filter buttons.** Browser.lua:202-207 (catcher at level+20 over the whole window) together with :273-276.
  - The "click the owner again to close" branch in `openPopup` can never run, because the catcher receives that click. It still behaves correctly (the popup closes), so the branch is dead code: remove it or fix the comment at :271.
  - With a popup open, the first click on Campaign, Status, X, a badge or the drag area only closes the popup; a second click is needed.
  - The catcher is not wheel-enabled, so the wheel scrolls the list behind it.
  - A click outside the window (in the world) does not close the popup, even though the popup can stick out past the window.
  - All of this is acceptable, but decide whether it is what you want.
- **N3 – Esc closes everything at once.** Both windows are in `UISpecialFrames`, so a single Esc closes the browser and the lore window. While a popup is open, Esc closes the whole browser rather than just the popup.
- **N4 – Mouseover tracking relies only on the tooltip hook.** Core.lua:133-142.
  - If `C.HookUnitTooltip` returns nil, or a tooltip addon suppresses or replaces GameTooltip's unit data, mouseover never counts and only targeting does. Nothing tells the user about this beyond the existing "tooltip line is off" message on load.
  - Consider also listening to `UPDATE_MOUSEOVER_UNIT`, registered through `C.RegisterEventSafe`, and calling `ns.Lookup("mouseover")` → `ns.MarkMet`. This would also take the side effect out of the tooltip renderer.
  - I believe this event still exists in 12.x but cannot verify it on Forever; registering it through `RegisterEventSafe` makes that risk zero.
- **N5 – `IsMet` and `MarkMet` disagree on a `false` value.** Core.lua:72 vs :110.
  - `IsMet` treats `met[id] = false` (from a damaged file) as met, because it tests `~= nil`. `MarkMet` treats it as not met and overwrites it.
  - Use the same test in both places, either truthiness or `type(v) == "number"`.
- **N6 – Unused import.** UI.lua:15 imports `outline`, which UI.lua no longer uses after the move to Style.lua.
- **N7 – Popup scrolling is invisible.** Browser.lua:309-321 caps the popup at 14 rows.
  - The zone and campaign lists can be longer, but the popup has no thumb or other sign that it scrolls, so entries past row 14 are easy to miss.
  - Reuse the same track/thumb as the main list, or add a "more…" fade.
- **N8 – Feature-specific limit in a generic helper.** Compat.lua:318 has `SetMaxLetters(40)` inside the generic `C.CreateEditBox`. Pass it as a parameter, or set it in Browser.lua.
- **N9 – Thumb can briefly overshoot.** Browser.lua:401: when the range is stale for one frame, `GetVerticalScroll()/range` can exceed 1 and the thumb is drawn past the track for a frame. Clamp the ratio to the range 0..1.
- **N10 – Zone filter vs. zone column.** The zone filter also matches `alsoIn`, but the row only shows `entry.zone` (Browser.lua:383). Filtering "Orgrimmar" can therefore list a row that says "Durotar". This is correct behaviour, but it looks like a bug to the user. Consider showing the matched zone when a zone filter is active.
- **N11 – Damaged position value.** Browser.lua:171-173 (and the same pattern in UI.lua): if `browserPos` is a number in a damaged saved-variables file, indexing it errors. Add a `type(pos) == "table"` guard, as is already done for `WarcraftLoreCharDB`.
- **N12 – Chat spam on a first visit.** Core.lua:118: every first meeting prints a chat line. Mousing over a crowd in a capital on the first visit can print many lines in a row. Consider a throttle or an option.
- **N13 – Unrelated fix in the same change.** The Toast.lua path fix is outside this feature's scope. It is valid; mention it in the commit message.

## Conclusion

All scores are 8 or higher, and there are no reject-level defects.

**GODKJENT** (approved). N1, N2 (dead branch) and N6 are cheap and should be fixed before the release build.

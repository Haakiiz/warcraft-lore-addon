# Verdict: UI_D1 round 2 (Warcraft Veterans window + popup, alert pills, minimap button)

## 1. Blind test

- **A** is a lore window (Thrall card). **B** is a list window ("Warcraft Veterans"). The content gives away which is which, so the test comes down to whether B holds up as a sibling of A.
- **Verdict: equal.** I am about 70% sure of this.
  - Both use the same frame: 3 px violet border, turquoise inner line, vines and rosettes.
  - Both use the same title band, Morpheus title, divider, thin-bordered X and dark fill.
  - B has far more controls than A and keeps the same discipline throughout. Neither window looks cheaper than the other.
  - Shown side by side (extra_both.png), they clearly belong to the same addon.

## 2. Scores (1–10)

| # | Criterion | A | B |
|---|---|---|---|
| 1 | Frame | 10 | 10 |
| 2 | Title bar | 10 | 10 |
| 3 | Colors | 9 | 9 |
| 4 | Typography | 9 | 9 |
| 5 | Rhythm and spacing | 9 | 8 |
| 6 | Controls | 9 (badges only) | 9 |
| 7 | List readability | N/A | 9 |
| 8 | States | N/A | 8 |
| 9 | Overall unity | 9 | 9 |

Why B scores what it does:

- **Criterion 5 (8):**
  - Vertical rhythm is even: about 9 px between the chips, search, filter and count rows.
  - The columns line up, and the list ends cleanly about 11 px above the inner frame.
  - Docked a point because one "uncertain" tag runs to within about 4 px of the zone column (see nits).
- **Criterion 6 (9):**
  - The chips, search field, dropdowns, "Show" control and checkbox all share one system: 1 px border and dark fill.
  - Active states are clear but quiet: the TFT chip is brighter, "Show Met" and the open Campaign control get a violet border, and the checkbox is filled violet.
- **Criterion 7 (9):**
  - Name, zone and games sit in fixed columns. The game codes are right-aligned under "APPEARS IN" and keep their game colors with dim separators.
  - Met and not-met are readable at a glance: a filled green square versus a hollow one, and met names are lavender.
  - The striping is subtle.
- **Criterion 8 (8):**
  - The empty state, filtered state, hide-book-only state and hover tooltip are all clean.
  - The popup state is good but less tidy than the mockup (see nits).

## 3. Extra images vs. mockups and yardstick

- **extra_browser_popup:**
  - Matches Popup.dc.html closely: left edge aligned with the Campaign control, about 258 px wide, "All campaigns" highlighted, game headers in each game's color with separators, a scrollbar, and an up chevron with violet border on the open control.
  - Two differences: the background is not dimmed (the mockup uses 0.4–0.55 opacity), and the list is clipped just after a separator without the faded "BOOKS" header the mockup shows.
- **extra_browser_tip:**
  - The tooltip follows the mockup: lavender name, muted zone, campaign lines in game colors, green "Met on this character", and a muted call to action.
  - It is readable and sits under the hovered row without covering it. Lines are tight, which is allowed by the GameTooltip caveat.
  - The "Show Met" active border and the "Clear filters" link both appear correctly.
- **extra_browser_empty:**
  - Shows the centered two-line message from the mockup, the "Clear filters" link and a "Showing 0 of 127" count. Clean.
- **extra_browser_hidebook:**
  - The checkbox is filled violet and its label lavender, and the count reads "Showing 38 of 127".
  - No book-only rows remain, and "Clear filters" is correctly absent, as in the mockup.
- **extra_browser_filtered:**
  - The TFT chip shows as active, search "ra" gives 6 rows, all containing TFT. Thrall's met marker and lavender name are visible.
  - The empty space below the rows is fine.
- **extra_alert:**
  - These read as soft glowing pills in the game color: an orange halo for Thrall (WC3) and a blue one for Nazgrel (TFT).
  - Size is about 236×48. Each has a game-colored portrait ring, a Morpheus lavender name, game codes with dim dots, and a muted chevron, as in Alert.dc.html.
  - The glow hugs the border rather than forming a separate halo line at -7 px. It is softer than the mockup, which is acceptable or even better.
- **extra_minimap:**
  - Reads as a proper round minimap button: about 34 px, violet ring with a light outer ring and soft glow, dark disc.
  - The tooltip matches the mockup almost word for word: lavender title, "Veterans met: 2 of 127" with a green 2, a blank-line spacer, and violet verbs. It is readable.
- **extra_both:**
  - The two windows share the same top line, frame, title band and vine rhythm.
  - They clearly look like one addon.

## 4. Defects

### Reject-level

None.

### Non-blocking nits (fix if cheap)

1. **"uncertain" tag nearly touching the zone column**
   - Where: B.png and extra_both.png, about x 255–300, y 412–426 ("Archmage Ansirem Runeweaver uncertain" next to "Alterac Mountains").
   - Problem: the gap is only about 4 px, so the tag reads as part of the zone text.
   - Data check: this is the longest name+tag combination in the dataset, so no row actually overflows.
   - Fix: reserve at least 8 px between the name column and the zone column, or truncate the name before the tag.
2. **Popup background not dimmed**
   - Where: extra_browser_popup.png, the right-hand strip x 492–512, y 210–490.
   - Problem: fragments of the content underneath ("only", "IN", "ok", "FT", "C3") peek out beside the popup edge.
   - Fix: add a dark overlay of about 0.4–0.5 alpha over the list while the popup is open (the mockup does this), or a click-catcher with a dim texture.
3. **Popup clipped at a dangling separator**
   - Where: extra_browser_popup.png, about y 476–488.
   - Problem: the list cuts right after a separator line with no visible next header or fade.
   - Fix: use the mockup's FadeDown over the bottom 26 px so a partially visible "BOOKS" header shows there is more to scroll.
4. **Minimap tooltip touching the button**
   - Where: extra_minimap.png, about (336–342, 122–128).
   - Problem: the tooltip's bottom-right corner touches the button's glow.
   - Fix: offset the anchor by a few pixels.
5. **Minimap glow and icon may differ from the mockup**
   - Glow: the mockup shows the glow only on hover. If the light outer ring is a permanent glow and not part of the ring texture, keep it for hover only.
   - Icon: the mockup uses a parchment book icon. If the real code also shows "?" rather than a placeholder, consider the book icon from the mockup.
6. **Faded halo ring on the alert pills**
   - Where: extra_alert.png.
   - Problem: the separate faint halo ring from the mockup is missing.
   - This is not required, since the current glow reads well.

## 5. Conclusion

- No score for the new UI (B) is under 8.
- There are no reject-level defects.
- The blind test came out **equal**.

**GODKJENT (approved)**

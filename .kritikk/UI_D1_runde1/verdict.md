# Verdict UI_D1 runde 1: AVVIST

## 1. Blind test
- A = Warcraft Veterans (list window), B = Warcraft Lore (character window).
- Both meet the frame, title band, palette and typography rules equally well. A shows the yardstick's list criteria (5 to 7) in full; B cannot be scored on them.
- **Verdict: equal.** If forced to pick, A at about 55 %. On the shared criteria the two are hard to tell apart, which is the goal for a sibling window.

## 2. Scores (1–10)

| # | Criterion | A | B |
|---|---|---|---|
| 1 | Frame (violet 3 px, turquoise inner line, vines, rosettes, dark base) | 9 | 9 |
| 2 | Title band (#181226, Morpheus lavender, #3d2a78 rule, thin X) | 9 | 9 |
| 3 | Colours (palette only, game colours used as accents) | 9 | 9 |
| 4 | Typography / hierarchy | 8 | 9 |
| 5 | Rhythm and air (PAD 12, control-row gaps, aligned columns) | 9 | 8 |
| 6 | Controls (one consistent control system) | 9 | 8 |
| 7 | List readability | **7** (duplicate rows, see R3) | N/A |
| 8 | States (empty, popup, filter, tooltip) | **6** (tooltip, see R1) | N/A |
| 9 | Overall look (both windows side by side) | 9 | 9 |

The new UI scores under 8 on criteria 7 and 8.

## 3. Extra states compared with mockups and yardstick
- **extra_browser_popup:** Position and size match the mockup closely (about 258×280 vs 260×282, attached under the Campaign control). The section headers are in game colours, options are indented, the "All campaigns" row is highlighted, group dividers are present, and there is a scrollbar thumb and a bottom fade. Unlike the mockup, the rest of the window is not dimmed, so stray fragments show to the right of the popup (nit N1).
- **extra_browser_tip:** The "Show Met" control has a clear active violet border, and the Clear filters link and count line are correct. The row tooltip has problems (R1).
- **extra_browser_empty:** Clean. The two-line message is centred, the count line reads "Showing 0 of 128" and Clear filters shows. The scrollbar track stays without a thumb, which is fine.
- **extra_browser_hidebook:** The checkbox is filled violet and the count reads "Showing 39 of 128". The columns line up, but the same row appears twice (R3).
- **extra_browser_filtered:** The active TFT chip is tinted and has a solid border, and search and chip filters combine correctly. Good.
- **extra_alert:** Size (about 234×48), layout, Morpheus name, game codes with dim separators, chevron and coloured ring all match the mockup. The **halo is not a soft glow** (R2).
- **extra_minimap:** The button is round, sits on the minimap rim, has a violet ring and a dark centre (the "?" is a renderer placeholder). The bright lavender outer glow matches the mockup's hover highlight, which is correct because the tooltip is open. Tooltip content and colours match the mockup. Acceptable.
- **extra_both:** Both windows clearly belong to the same addon, with identical frame, title band and X placement.

## 4. Defects that block the delivery

**R1. The row tooltip is too narrow, and game names break mid-title with separators left at line ends.**
- Image: extra_browser_tip.png, tooltip at about (97,290)–(248,440).
- The tooltip is about 150 px wide; the mockup sets `min-width: 200px; max-width: 300px`.
- "Warcraft III: Reign of / Chaos · Warcraft III: The / Frozen Throne · / Warcraft novels and / books": every title is broken across lines, and "·" is left hanging at the end of a line. This breaks the yardstick rules against text breaking unevenly and for good readability.
- Fix: set the tooltip width to at least 200 px. Then either use the mockup's short names on one line ("Reign of Chaos · The Frozen Throne · Books"), or put one game per line with no separators.

**R2. The alert pill halo is a hard-edged translucent rectangle, not a soft glow, and the halos of stacked pills mix into a muddy band.**
- Image: extra_alert.png, halos at about (134,36)–(386,156).
- Pixel samples show the halo is a flat tinted box about 8 px wide. Outside its outer line it fades to the background within about 1 px.
- The mockup asks for `box-shadow: 0 0 14px 3px` plus an inner glow: a soft fade of about 14–17 px. That is "soft edges look slightly harder" taken too far, so the renderer caveat does not cover it.
- Between the pills (y ≈ 91–100) the orange and blue halos overlap into a grey-brown band (rgb about 144,141,118 and 120,121,101), so neither pill reads as glowing in its own colour.
- Fix: make PillGlow.tga a real fade (alpha ramp over about 12–16 px, using ADD blend), and let it extend outside the pill. Space the pills so the glows do not overlap (spacing of at least 2× the glow width), or clip the glow for neighbouring pills.

**R3. Duplicate, identical rows in the list.**
- Image: extra_browser_hidebook.png, last two rows at about (56,550)–(512,590).
- "Gregory · Western Plaguelands · WC3" appears twice. Data.lua has two entries with the same name, which look like the same character under two NPC IDs.
- The user cannot tell the two apart, and both count in "39 of 128" and in the totals.
- Fix: merge entries with the same name, zone and games in the browser, and count them once. Alternatively, add a visible distinguishing detail (for example the NPC ID in the tooltip and a "(2)" marker). Check the counts afterwards.

## 5. Non-blocking nits
- N1 (popup): The mockup dims the rest of the window to opacity 0.4–0.55. The render does not, so fragments ("only", "IN", "ook", "FT", "C3") show at x ≈ 491–512, y ≈ 215–480 beside the popup. A dim overlay behind the popup would fix this and match the mockup. The popup also has no drop shadow, which may be a renderer limitation.
- N2 (list): "Archmage Ansirem Runeweaver" plus the "uncertain" tag ends about 8 px before the Zone column. Check that longer names get an ellipsis and never collide with the Zone column.
- N3 (minimap tooltip): There is a full empty line between "Veterans met" and the click hints; the mockup uses 6 px. Tighten it.
- N4 (alert): The ring around the portrait is a thin, plain circle. The mockup uses the textured portrait ring tinted in the game colour. This is minor.
- N5 (chips): The Book chip's progress bar (2/103) is only 1–2 px and almost invisible. Consider a minimum visible width for a value above 0.

## 6. Conclusion
**AVVIST (rejected).** The blind test passes (equal), and the frame, title band, palette, controls and docked look are at reference level. The delivery is still rejected because the new UI scores under 8 on criteria 7 and 8, and there are three defects that block it:
- R1: the row tooltip wraps badly.
- R2: the alert halo is not a soft glow and stacked halos turn muddy.
- R3: the same row appears twice in the list.

All three are small fixes. After them, the delivery looks ready for approval.

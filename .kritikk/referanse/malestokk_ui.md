# Målestokk: Warcraft Veterans-vinduet (/wcl list)

Referanse: lore-vinduet i WarcraftLore/UI.lua (godkjent design, "violet & turquoise vines", slide 8 i mockup-decket),
rendret til PNG med scratchpad-rendereren. Veterans-vinduet skal se ut som et søsken av det: samme familie, ikke en kopi.

## Kriterier (1–10 hver)
1. **Ramme:** samme ytre ramme: 3 px fiolett (#8b6cd6) ytterlinje, tynn turkis (#2a6f68) innerlinje, turkise bladranker flislagt langs alle fire kanter, rosetter i hjørnene, mørk lilla bunn (#120f1c / #100d18).
2. **Topplinje:** tittelband (#181226) med Morpheus-tittel i lys lavendel (#d4c6f7), fiolett-mørk skillelinje (#3d2a78) og X-knapp med tynn kant, plassert som i lore-vinduet.
3. **Farger:** bare paletten fra Style.COL + spillfargene (ns.GAME_COLOR). Spillfarger brukes som aksent (badger, etiketter), ikke store flater. Ingen nye, fremmede farger.
4. **Typografi:** Morpheus bare til titler/navn i stor størrelse; brødtekst Friz/standardfont 10–12 px; dempet tekst #a79d8a for sekundærinfo. Tydelig hierarki: navn > sone > meta.
5. **Rytme og luft:** konsekvent innerpadding (PAD 12), jevne mellomrom mellom kontrollrader (6–10 px), ingen elementer som kolliderer, overlapper eller stikker utenfor rammen. Kolonner i lista står på linje.
6. **Kontroller:** søkefelt, filterknapper og badger ser ut som samme system (1 px kant, mørk fyll, fiolett ved hover/aktiv). Aktiv tilstand er tydelig uten å skrike.
7. **Lesbarhet av lista:** rader lette å skanne: navn, sone og spill på faste kolonner, ingen avkortet tekst som skjuler viktig info (eller avkortet med god grunn), møtt/ikke møtt synlig med et øyekast.
8. **Tilstander:** tom liste, popup åpen, filter aktivt og lore-vindu over browser ser alle gjennomtenkte og ryddige ut.
9. **Helhet:** browser og lore-vindu ved siden av hverandre ser ut som samme addon.

## Unngå
- Blizzard-standardmaler (UIPanelButtonTemplate, grå dialogbokser, UIDropDownMenu, BackdropTemplate).
- Hvite eller grå flater, rene primærfarger, store fargede bakgrunner.
- Tekst som går utenfor sin boks eller over andre elementer; badger som brekker ujevnt.
- Emoji, Unicode-symboler fonten kanskje mangler (✓ ▼ ●), bruk teksturer/fargeflater.
- Mer enn én aksentfarge per element; glorete hover-effekter.
- Kopierte Blizzard-ikoner eller grafikk utover det addonen allerede bruker (spørsmålstegn-ikonet).

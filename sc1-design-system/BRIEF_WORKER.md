# Brief for arbeidere (les hele før du starter)

Du lager én del av et HTML/CSS-designsystem som skal se nesten identisk ut som brukergrensesnittet i StarCraft 1 (1998 / Remastered).

## Les først
1. `sc1-design-system/MALESTOKK.md`: kjennetegn 1–10 og forbudslisten. Kritikeren bruker denne til å avvise eller godkjenne arbeidet ditt.
2. Referansebildene i `.kritikk/referanse/sc1/` (åpne dem med Read-verktøyet og studer detaljene nøye).
3. `sc1-design-system/css/tokens.css`: felles variabler. Bruk `var(--sc-…)` og ikke hardkodede farger. Du kan **ikke** endre tokens.css. Mangler du en token, definer den lokalt i din egen fil med prefikset `--x-` og nevn den i rapporten.

## Felles klasse-API (kontrakt mellom arbeiderne)
Arbeider A definerer disse i `css/components.css`. Arbeider B og C bruker dem bare via `<link>`, og må ikke vente på A. Ser noe feil ut før A er ferdig, er det greit.
- `.sc-menu-link`: gulgrønn menytekst for glue screen (`a` eller `button`)
- `.sc-dialog.sc-dialog--red` med `.sc-dialog__body` og `.sc-dialog__actions`: svart dialog med grå/rød dobbel ramme
- `.sc-btn.sc-btn--red`: rektangel med rød kant og gulgrønn tekst
- `.sc-dialog.sc-dialog--blue` med `.sc-dialog__title`: halvgjennomsiktig blå spillmeny med rutemønster
- `.sc-btn.sc-btn--blue`: blå konturknapp med blek gul tekst
- `.sc-btn.sc-btn--rust`: Battle.net-knapp
- `.sc-panel--metal`, `.sc-panel--rust`: metallplater med fasede kanter og nagler
- `.sc-crt`: senket svart skjerm
- `.sc-cmdcard` (3×3) med `.sc-cmd` og `.sc-cmd--empty`. Ikonet er en inline-SVG i `.sc-cmd`, og `data-hotkey="A"` angir hurtigtasten.
- `.sc-resources` med `.sc-res.sc-res--mineral|gas|supply`, et ikon (`.sc-res__icon`) og et tall (`.sc-res__val`)
- `.sc-hp`: grønt HP-tall
- `.sc-led`: grønn punktmatrisetekst
- `.sc-input`, `.sc-label`: Battle.net-skjemafelt

## Regler
- Ren HTML/CSS/JS uten byggesteg og uten rammeverk. Fonter kommer bare fra Google Fonts (tokens.css importerer dem allerede).
- **Ingen originalgrafikk, -logoer, -fonter eller -lyd fra spillet.** Lag alt selv: CSS, inline-SVG, `<canvas>` (stjerner, tåke, planet, terreng, statisk støy) og Web Audio for lyd. Skriv aldri ordet «StarCraft» som logo. Bruk et eget fantasinavn hvis du trenger en logo, for eksempel «STELLAR COMMAND».
- Portretter skal være egne, abstrakte figurer (silhuett eller hjelm med statisk støy), ikke kopier av kjente figurer.
- Bruk relative stier. Sidene ligger i `sc1-design-system/` eller `sc1-design-system/patterns/`.
- Rør bare dine egne filer.

## Bevis
- Ta skjermbilder i 1280×720 med Playwright (`require('playwright')`, `chromium.launch()`, allerede installert; ikke installer noe). Vent til fontene er lastet (`await page.evaluate(() => document.fonts.ready)`) og la animasjoner stå ca. 500 ms.
- Lagre skjermbildene i mappen orkestratoren oppgir. Logg konsollfeil (`page.on('console')`, `page.on('pageerror')`). Det må være null feil.
- Se selv på hvert skjermbilde med Read og sammenlign med referansen før du leverer. Gjør minst én egen forbedringsrunde.

## Rapport (sluttsvaret ditt, kort)
- Filer du har laget eller endret
- Stiene til skjermbildene, og hvilket referansebilde hvert av dem skal sammenlignes med
- Antall konsollfeil
- Hva du selv mener fortsatt avviker fra referansen

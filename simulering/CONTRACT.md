# Kontrakt mellom delene (simulering/)

Sidens innhold er på norsk (bokmål). Spillersitater er på engelsk (slik de ville stått på CurseForge/Reddit).
Alt etter 2026-10-09 er SIMULERT og skal kunne merkes slik.

## Filer og eiere
- `story.js` (T1 data/innhold): definerer `window.STORY` (se skjema under). Ren data, ingen DOM.
- `chart.js` (T2 graf): definerer `window.SagaChart`. Tegner i et element den får. Leser bare `STORY.months`, `STORY.releases`, `STORY.events`.
- `index.html` (T3 side): skall, typografi, hero, kapittelkort, scroll-logikk, epilog. Laster
  `<script src="story.js"></script><script src="chart.js"></script>` før eget inline-skript.
  Siden skal fungere åpnet direkte fra disk (file://) og publisert som Artifact (de to .js-filene publiseres ved siden av).

## window.STORY
```js
{
  title: "…", subtitle: "…",
  today: "2026-10-09",                 // skillet mellom ekte og simulert
  months: [                            // én per måned, 2026-10 … 2029-10 (37 stk), sortert
    { m: "2026-10", downloads: 412,    // downloads i måneden
      total: 412,                      // kumulativt t.o.m. måneden
      active: 180,                     // anslått aktive installasjoner ved månedsslutt
      npcs: 128,                       // veteraner i databasen ved månedsslutt
      rating: null|4.8 }               // snittvurdering, null før første vurdering
  ],
  releases: [ { v: "0.1.0", date: "2026-10-07", name: "…", highlights: ["…","…"], major: false } ],
  events:   [ { date: "2027-01-12", label: "…", kind: "press|expansion|dip|community|milestone" } ],
  chapters: [ {
      id: "forge",                     // unik, a–z og bindestrek
      date: "2026-10-04",              // grafen tegnes t.o.m. denne datoen
      kicker: "Oktober 2026 · v0.1.0", // kort overlinje
      title: "…",                      // 3–8 ord
      body: "…",                       // 2–4 setninger, norsk
      stat: { label: "nedlastinger totalt", value: 412 },  // stemmer med months
      quotes: [ { who: "Thraxx_gaming", src: "CurseForge|Reddit|Discord|GitHub|Twitch|Wowhead", text: "…" } ], // 0–2
      release: "0.1.0" | null,         // versjon som omtales
      tone: "spark|rise|storm|fall|crown" // stemning, styrer aksentfarge i kortet
  } ],                                  // 14–19 kapitler, kronologisk
  epilogue: { title: "…", body: "…", facts: [ { label: "…", value: "…" } ] },
  actual: {                            // valgfritt: EKTE tall, tegnes som egen strek oppå kurven
    source: "CurseForge", checked: "2026-10-25",
    points: [ { date: "2026-10-15", total: 59, measured: true } ],   // totalt antall nedlastinger, sortert
    releases: [ { v: "0.8.1", date: "2026-10-16", downloads: 11, name: "…", beta: false } ], // filene på CurseForge
    features: [ { label: "Lore Journal", plan: "1.0.0", real: "0.7.0" } ]  // plan = STORY.releases, real = actual.releases
  }
}
```
`today` er siste dato i `actual.points` (story.js leser den fra listen ACTUAL). Nye målinger legges inn som en ny linje i ACTUAL.

## Den ekte streken
- Vises bare for metrikken «total» (vi har bare ekte totaltall). Rett linje mellom målepunktene, prikk på hver måling
  (`measured: true`), liten loddrett strek på hver ekte versjon (ikke beta).
- Tegnes fram til grafens dato, men aldri forbi siste måling. Etiketten viser ekte verdi (≈ mellom målinger),
  planens verdi på samme dato, avvik i prosent og ekte versjon mot planens versjon.
- Grafens topp tar hensyn til den ekte streken, så den aldri går ut av skala.
- `tick` får i tillegg `actual` (ekte total på datoen, siste måling etter den, null før første punkt).

## Verdi på en vilkårlig dato (felles regel for graf, teller og kort)
For dato d i måned M (dag = d.getDate(), n = antall dager i M, f = dag / n):
- total(d) = total(forrige måned) + f × downloads(M)   (forrige måned = 0 før 2026-10)
- active(d) og npcs(d) = forrige måned + f × (M − forrige måned)
- downloads(d) (per måned) = downloads(M), uten interpolering
Unntak / generalisering: STORY.anchors = [{date, total, active, npcs}] er ekte målepunkter (bare i oktober 2026).
Verdien er stykkevis lineær mellom alle kjente punkter sortert på tid: anchors + månedsslutt-punkter (månedsslutt M ligger
på dag 1 i neste måned kl. 00, «forrige månedsslutt» for 2026-10 er 2026-10-01 med 0/0/0). Uten anchors gir dette regelen over.
Før første anchor (2026-10-04) finnes ingen data: grafen starter der. Mellom 2026-10-04 og 2026-10-07 er total 0.
Kapittelstat med label «nedlastinger totalt» / «aktive installasjoner» / «veteraner i databasen» = denne verdien, rundet.
Grafens tick og teller bruker samme regel, så kort og teller viser samme tall på kapitteldatoen.

## window.SagaChart
```js
const chart = SagaChart.create(containerEl, STORY, { reducedMotion: bool });
chart.setDate("2027-03-01");   // animerer kurve, teller og annotasjoner fram/tilbake til denne datoen
chart.setMetric("total" | "downloads" | "active"); // valgfritt, standard "total"
chart.resize();                 // kalles ved resize
chart.on("tick", ({ date, total, downloads, active, npcs, version }) => {}) // for live-tellere i siden
```
Grafen eier sine egne farger via CSS-variablene under (leser dem med getComputedStyle), så siden og grafen matcher.

## Felles designtokens (index.html definerer dem på :root, chart.js leser dem)
```
--night: #0d0b15   --night-2: #120f1c   --panel: #181226   --line: #2d2347   --line-strong: #3d2a78
--violet: #8b6cd6  --teal: #3fb8a6      --teal-deep: #2a6f68
--title: #d4c6f7   --text: #d9d2c3      --muted: #a79d8a     --parchment: #e8dcb5
--wc1: #c9a46a --wc2: #e0533f --btdp: #b07cf0 --wc3: #f0a24a --tft: #7cc7ef --fk: #9bd46a --book: #e8dcb5
--good: #6fcf7f    --warn: #e0b04a
Fonter (Google Fonts): display "IM Fell English" (+ italic), brødtekst "Alegreya Sans", tall "Spline Sans Mono".
```
Siden er bevisst bare mørk (én visuell verden): `color-scheme: dark`, eksplisitt bakgrunn, ingen lys variant.

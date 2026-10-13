# Kritikk HEL_r2 (Veterans + Lore side om side)

Metode: begge bildene lest i full størrelse; B (1120x680) målt med PowerShell/System.Drawing (pikselskanninger langs kolonner og rader, utsnitt forstørret 2–8x med nærmeste-nabo, kontrast beregnet etter WCAG-formelen).

## 1. Blindtest

B treffer målestokken best som WC2-grensesnitt i remasterversjon. A er åpenbart originalen: lav oppløsning, pikselfont og spillkart. B har samme materialspråk som A: brun sprukken jord, steinramme med avfasing, mørke innfelte paneler, mørkerøde knapper med gull tekst og grønn ramme for valgt. I tillegg har B den moderne finishen målestokken krever. Som WC2-identitet regner jeg dem som likeverdige, og B vinner på målestokken. Sikkerhet: 80 %.

## 2. Poeng

| # | Punkt | A | B |
|---|-------|---|---|
| 1 | Underlag (brun sprukken tekstur) | 9 | 9 |
| 2 | Ytre ramme (8–12 px, avfaset stein) | 8 | 9 |
| 3 | Innfelte paneler | 9 | 9 |
| 4 | Knapper (røde, hevet bevel, gull tekst; kvadratiske ikonknapper) | 9 | 9 |
| 5 | Typografi (gull/beige, serif, ingen pikselfont) | 6 | 9 |
| 6 | Palett | 9 | 9 |
| 7 | Moderne finish | 3 | 9 |
| 8 | Struktur fra WC2 | 10 | 8 |
| 9 | Lesbarhet | 6 | 9 |
| 10 | Helhet (remaster, samme system) | 7 | 9 |

### Målinger i B (samsvar mellom de to vinduene)

| Komponent | Veterans (venstre) | Lore (høyre) | Samsvar |
|---|---|---|---|
| Ytre vindu | x 19–540, y 19–660 (522x642) | x 579–1100, y 19–660 (522x642) | identisk |
| Ytre ramme | 10 px (y 20–29), lys #d8cfb8 2 px oppe/venstre, mørk #5c5446 2 px nede/høyre, svart #0e0904 ytterst | samme verdier | identisk |
| Tittelbånd | y 31–66 = 36 px, bunn #2e1d0b, mørk linje #050301 på y 67, deretter bevel #5f4d36 | y 31–66 = 36 px, samme farger | identisk |
| Lukkeknapp | x 499–524, y 36–61 = 26x26 inkl. svart kant; 4 px fra innerkant av rammen; senter y 48,5 = senter av tittelbåndet | x 1059–1084, y 36–61 = 26x26; 4 px fra rammen; senter y 48,5 | identisk |
| Lukkeknapp-bevel | lys #b2483a 2 px + #92372a, flate #7a1a10→#5b0f09, mørk #2a0503 2 px | samme | identisk |
| Rød knapp (Journal/Memorials, Related/Close) | y 77–107 = 31 px inkl. kant; lys #c0553c 2 px + #a8402a 1 px oppe/venstre; flate #7a1a10→#5c0f09; mørk #3a0804 + #1f0402 2 px nede/høyre | y 608–638 = 31 px; nøyaktig samme bevel | identisk |
| Avstand mellom røde knapper | 10 px (x 275–284) | 12 px (x 834–845) | avviker med 2 px |
| Rullefelt | spor 16 px (x 500–515), pilknapp 14 px høy | spor 16 px (x 1062–1077), pilknapp 14 px | identisk, men avstanden til rammen er 13 px mot 11 px |
| Innfelt panelkant | mørk oppe/venstre, lys #b8ad94 nede/høyre | samme | identisk |

Konklusjon på samsvaret: tittelbånd, lukkeknapp og røde knapper er pikselidentiske i de to vinduene. Vinduene fremstår tydelig som ett system. De gjenstående avvikene er på 2 px og er ikke avvisningsgrunn.

## 3. Avvisningsfeil

Ingen.

Kontroller som er gjort:
- Kontrast i brødteksten:
  - Lore-tekst #e6dcc4 på panel ca. #2e1d0b: ca. 14:1.
  - Navnekolonnen #e6dcb8: ca. 15:1.
  - Zone-kolonnen #b4ab8e: ca. 7–9:1.
  - Kursiv «uncertain» #b3ab89: ca. 7:1 eller mer.
  - Plassholderen «Search by name» #9b8c70: ca. 5,5–6:1.
  
  Alle er over 4,5:1.
- All tekst står på mørke paneler.
- Ingenting stikker ut av rammene.
- Ingen avrundede hjørner, glød, lilla eller turkis.
- Pikselfont: ingen. Ikonene er egne former: forstørrelsesglass, øks-banner, trekanter og X.

## 4. Mindre merknader

1. **Lukkeknappens bevel avviker fra de store knappene.** Lyskanten er #b2483a mot #c0553c, og skyggen er #2a0503 mot #1f0402. Den er lik i begge vinduene, men bør bruke de samme tokenene som de røde knappene (#c0553c / #a8402a / #3a0804 / #1f0402). Da blir knappefamilien helt enhetlig.
2. **Knappeavstanden er ulik.** Den er 10 px i Veterans (Journal | Memorials) og 12 px i Lore (Related | Close). Velg én verdi, for eksempel 10 px.
3. **Rullefeltet står ulikt i forhold til rammen.** Avstanden fra rullefeltet til innerkanten av rammen er 13 px i Veterans (x 515 til 529) og 11 px i Lore (x 1077 til 1089). Juster til samme verdi.
4. **Knapperaden står ulikt.** I Veterans er den øverst (som Menu/Pause), i Lore nederst (Related/Close). Det kan forsvares som dialogknapper, slik WC2-menyene har dem nederst. Strukturelt er det likevel et lite avvik fra punkt 8.
5. **Lore har to lukkeknapper.** Både X i tittelbåndet og «Close» nederst lukker vinduet. Vurder å erstatte «Close» med en annen handling, eller beholde begge bevisst.
6. **Klipp nederst i Lore.** Seksjonen «Warcraft novels and books» klippes av nederst i rullefeltet (y ca. 588) uten skygge eller fade. Det er normalt for rullbart innhold. En 6–8 px innvendig skygge nederst i rullefeltet ville gjort klippet tydeligere.
7. **Fargefrynser på titlene.** Titlene har grønne og røde frynser (ClearType eller subpikselglatting, for eksempel #1e742f i «VETERANS»). Det er en artefakt fra renderingen, ikke designet. Ta neste skjermdump med gråtoneglatting.
8. **Sprekkene synes gjennom de innfelte panelene.** Det er i tråd med «gjennomskinnelig» og leses fint. Sprekkene bør ikke bli sterkere enn nå.

## 5. Konklusjon

**GODKJENT.** Ingen punkter under 8 for mockupet (B), ingen avvisningsfeil, og mockupet velges i blindtesten. De to vinduene er målbart samme system: tittelbåndet er 36 px, lukkeknappen 26x26 på samme sted, og de røde knappene er 31 px med identisk bevel.
